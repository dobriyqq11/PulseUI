--[[
    ╔══════════════════════════════════════════════════════════════╗
    ║                 PulseUI Library v3.0 (Premium)               ║
    ╚══════════════════════════════════════════════════════════════╝
    
    Особенности:
    • Анимация появления (Zoom + Fade)
    • Гладкие переходы табов с плавающим индикатором
    • Эффекты свечения (Glow) при наведении
    • Слайдеры с градиентом
    • Выпадающие списки с анимацией стрелки
    • Уведомления с таймером
]]

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")

local PulseUI = {}

-- ═══════════════════════════════════════
--  THEME & CONFIG
-- ═══════════════════════════════════════
local T = {
    Bg          = Color3.fromRGB(13, 13, 18),
    TopBar      = Color3.fromRGB(17, 17, 23),
    Side        = Color3.fromRGB(17, 17, 23),
    Elem        = Color3.fromRGB(24, 24, 30),
    Hover       = Color3.fromRGB(32, 32, 40),
    Accent      = Color3.fromRGB(138, 55, 220), -- Основной фиолетовый
    AccentLight = Color3.fromRGB(175, 105, 245),
    Text        = Color3.fromRGB(230, 230, 235),
    Dim         = Color3.fromRGB(100, 100, 115),
    Off         = Color3.fromRGB(40, 40, 50),
    Line        = Color3.fromRGB(35, 35, 44),
    Scroll      = Color3.fromRGB(55, 55, 68),
}

-- ═══════════════════════════════════════
--  UTILITY FUNCTIONS
-- ═══════════════════════════════════════
local function tw(obj, props, dur, style, dir)
    local info = TweenInfo.new(
        dur or 0.2, 
        style or Enum.EasingStyle.Quart, 
        dir or Enum.EasingDirection.Out
    )
    local tween = TweenService:Create(obj, info, props)
    tween:Play()
    return tween
end

local function rc(obj, rad)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, rad or 6)
    c.Parent = obj
    return c
end

local function pad(obj, t, r, b, l)
    local p = Instance.new("UIPadding")
    p.PaddingTop = UDim.new(0, t or 0)
    p.PaddingRight = UDim.new(0, r or 0)
    p.PaddingBottom = UDim.new(0, b or 0)
    p.PaddingLeft = UDim.new(0, l or 0)
    p.Parent = obj
    return p
end

local function stroke(obj, color, thick, transp)
    local s = Instance.new("UIStroke")
    s.Color = color or T.Line
    s.Thickness = thick or 1
    s.Transparency = transp or 0.5
    s.Parent = obj
    return s
end

-- Проверка поддержки CanvasGroup (для красивого фейда)
local canvasSupport = pcall(function()
    local t = Instance.new("CanvasGroup")
    t:Destroy()
end)

-- ═══════════════════════════════════════
--  MAIN LIBRARY
-- ═══════════════════════════════════════
function PulseUI:CreateWindow(cfg)
    cfg = cfg or {}
    local Window = {}
    local tabs = {}
    local firstTab = true
    local isVisible = true
    
    local BTN_HEIGHT = 34
    local BTN_PAD = 4
    local TAB_START_Y = 44
    local SIDE_WIDTH = 155

    -- 1. SETUP GUI
    local sg = Instance.new("ScreenGui")
    sg.Name = "PulseUI_Library"
    sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    sg.ResetOnSpawn = false
    
    -- Безопасное добавление в GUI
    if gethui then
        sg.Parent = gethui()
    elseif CoreGui:FindFirstChild("RobloxGui") then
        sg.Parent = CoreGui
    else
        sg.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
    end

    -- 2. MAIN FRAME
    local main
    if canvasSupport then
        main = Instance.new("CanvasGroup")
        main.GroupTransparency = 1 -- Старт невидимым
    else
        main = Instance.new("Frame")
    end
    
    main.Name = "Main"
    main.BackgroundColor3 = T.Bg
    main.BorderSizePixel = 0
    main.Position = UDim2.fromScale(0.5, 0.5)
    main.AnchorPoint = Vector2.new(0.5, 0.5)
    main.Size = cfg.Size or UDim2.fromOffset(650, 450)
    main.ClipsDescendants = true
    main.Parent = sg
    rc(main, 10)
    
    -- Свечение вокруг окна
    stroke(main, T.Accent, 1.6, 0.6)

    -- Анимация появления
    local uiScale = Instance.new("UIScale")
    uiScale.Scale = 0.92
    uiScale.Parent = main

    task.defer(function()
        tw(uiScale, {Scale = 1}, 0.6, Enum.EasingStyle.Elastic)
        if canvasSupport then
            tw(main, {GroupTransparency = 0}, 0.4)
        end
    end)

    -- 3. TOP BAR
    local top = Instance.new("Frame")
    top.Name = "TopBar"
    top.BackgroundColor3 = T.TopBar
    top.BorderSizePixel = 0
    top.Size = UDim2.new(1, 0, 0, 38)
    top.Parent = main

    local title = Instance.new("TextLabel")
    title.BackgroundTransparency = 1
    title.Position = UDim2.fromOffset(16, 0)
    title.Size = UDim2.new(0, 200, 1, 0)
    title.Font = Enum.Font.GothamBold
    title.Text = cfg.Title or "PulseUI"
    title.TextColor3 = T.Accent
    title.TextSize = 16
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = top

    local subTitle = Instance.new("TextLabel")
    subTitle.BackgroundTransparency = 1
    subTitle.AnchorPoint = Vector2.new(1, 0)
    subTitle.Position = UDim2.new(1, -16, 0, 0)
    subTitle.Size = UDim2.new(0, 200, 1, 0)
    subTitle.Font = Enum.Font.Gotham
    subTitle.Text = cfg.SubTitle or "Premium"
    subTitle.TextColor3 = T.Dim
    subTitle.TextSize = 12
    subTitle.TextXAlignment = Enum.TextXAlignment.Right
    subTitle.Parent = top

    local topDiv = Instance.new("Frame")
    topDiv.BackgroundColor3 = T.Line
    topDiv.BorderSizePixel = 0
    topDiv.Position = UDim2.new(0, 0, 1, 0)
    topDiv.Size = UDim2.new(1, 0, 0, 1)
    topDiv.Parent = top

    -- 4. SIDEBAR
    local side = Instance.new("Frame")
    side.Name = "Sidebar"
    side.BackgroundColor3 = T.Side
    side.BorderSizePixel = 0
    side.Position = UDim2.fromOffset(0, 39)
    side.Size = UDim2.new(0, SIDE_WIDTH, 1, -39)
    side.Parent = main

    local sideDiv = Instance.new("Frame")
    sideDiv.BackgroundColor3 = T.Line
    sideDiv.BorderSizePixel = 0
    sideDiv.Position = UDim2.new(1, 0, 0, 0)
    sideDiv.Size = UDim2.new(0, 1, 1, 0)
    sideDiv.Parent = side

    local navTitle = Instance.new("TextLabel")
    navTitle.BackgroundTransparency = 1
    navTitle.Position = UDim2.fromOffset(16, 14)
    navTitle.Size = UDim2.new(1, -32, 0, 14)
    navTitle.Font = Enum.Font.GothamBold
    navTitle.Text = "NAVIGATION"
    navTitle.TextColor3 = T.Dim
    navTitle.TextSize = 10
    navTitle.TextXAlignment = Enum.TextXAlignment.Left
    navTitle.Parent = side

    -- Контейнер для кнопок табов
    local tabBox = Instance.new("Frame")
    tabBox.BackgroundTransparency = 1
    tabBox.Position = UDim2.fromOffset(10, TAB_START_Y)
    tabBox.Size = UDim2.new(1, -20, 1, -TAB_START_Y - 30)
    tabBox.Parent = side

    local tabLayout = Instance.new("UIListLayout")
    tabLayout.Padding = UDim.new(0, BTN_PAD)
    tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
    tabLayout.Parent = tabBox

    -- Плавающий индикатор
    local indicator = Instance.new("Frame")
    indicator.Name = "Indicator"
    indicator.BackgroundColor3 = T.Accent
    indicator.BorderSizePixel = 0
    indicator.Size = UDim2.fromOffset(3, BTN_HEIGHT)
    indicator.Position = UDim2.fromOffset(0, TAB_START_Y)
    indicator.ZIndex = 5
    indicator.Parent = side
    rc(indicator, 2)
    
    -- Свечение индикатора
    local indGlow = Instance.new("Frame")
    indGlow.BackgroundColor3 = T.Accent
    indGlow.BackgroundTransparency = 0.6
    indGlow.Position = UDim2.fromOffset(-2, 0)
    indGlow.Size = UDim2.new(1, 4, 1, 0)
    indGlow.ZIndex = 4
    indGlow.Parent = indicator
    rc(indGlow, 4)

    -- Нижний текст
    local footer = Instance.new("TextLabel")
    footer.BackgroundTransparency = 1
    footer.Position = UDim2.new(0, 16, 1, -25)
    footer.Size = UDim2.new(1, -32, 0, 20)
    footer.Font = Enum.Font.Gotham
    footer.Text = "PulseUI v3.0"
    footer.TextColor3 = Color3.fromRGB(60, 60, 75)
    footer.TextSize = 10
    footer.TextXAlignment = Enum.TextXAlignment.Left
    footer.Parent = side

    -- 5. CONTENT AREA
    local content = Instance.new("Frame")
    content.Name = "Content"
    content.BackgroundTransparency = 1
    content.Position = UDim2.fromOffset(SIDE_WIDTH + 1, 39)
    content.Size = UDim2.new(1, -(SIDE_WIDTH + 1), 1, -39)
    content.Parent = main
    content.ClipsDescendants = true

    -- 6. DRAGGING SYSTEM
    local dragging, dragInput, dragStart, startPos
    top.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = main.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    top.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    -- 7. MINIMIZE LOGIC
    UserInputService.InputBegan:Connect(function(input, gpe)
        if gpe then return end
        if input.KeyCode == (cfg.MinimizeKey or Enum.KeyCode.RightControl) then
            isVisible = not isVisible
            if canvasSupport then
                if isVisible then
                    main.Visible = true
                    tw(main, {GroupTransparency = 0}, 0.25)
                    tw(uiScale, {Scale = 1}, 0.3, Enum.EasingStyle.Back)
                else
                    tw(main, {GroupTransparency = 1}, 0.2)
                    tw(uiScale, {Scale = 0.95}, 0.2)
                    task.delay(0.25, function() 
                        if not isVisible then main.Visible = false end 
                    end)
                end
            else
                main.Visible = isVisible
            end
        end
    end)

    -- ═══════════════════════════════════════
    --  TAB CREATION
    -- ═══════════════════════════════════════
    function Window:AddTab(name)
        local Tab = {}
        local tabIndex = #tabs -- 0, 1, 2...
        
        -- Кнопка таба
        local btn = Instance.new("TextButton")
        btn.Name = name
        btn.BackgroundColor3 = T.Hover
        btn.BackgroundTransparency = 1
        btn.Size = UDim2.new(1, 0, 0, BTN_HEIGHT)
        btn.Font = Enum.Font.GothamMedium
        btn.Text = "  " .. name
        btn.TextColor3 = T.Dim
        btn.TextSize = 13
        btn.TextXAlignment = Enum.TextXAlignment.Left
        btn.AutoButtonColor = false
        btn.Parent = tabBox
        rc(btn, 6)

        -- Страница (ScrollingFrame)
        local page = Instance.new("ScrollingFrame")
        page.Name = name .. "_Page"
        page.BackgroundTransparency = 1
        page.BorderSizePixel = 0
        page.Size = UDim2.new(1, 0, 1, 0)
        page.ScrollBarThickness = 2
        page.ScrollBarImageColor3 = T.Scroll
        page.Visible = false
        page.Parent = content
        pad(page, 10, 10, 10, 14)

        local pageLayout = Instance.new("UIListLayout")
        pageLayout.Padding = UDim.new(0, 6)
        pageLayout.SortOrder = Enum.SortOrder.LayoutOrder
        pageLayout.Parent = page

        pageLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            page.CanvasSize = UDim2.fromOffset(0, pageLayout.AbsoluteContentSize.Y + 20)
        end)

        table.insert(tabs, {btn = btn, page = page})

        -- Функция активации таба
        local function activate()
            -- Деактивация всех
            for _, t in ipairs(tabs) do
                t.page.Visible = false
                tw(t.btn, {TextColor3 = T.Dim, BackgroundTransparency = 1}, 0.2)
            end
            
            -- Активация текущего
            page.Visible = true
            tw(btn, {TextColor3 = T.Text, BackgroundTransparency = 0.92}, 0.2)
            
            -- Движение индикатора
            local targetY = TAB_START_Y + (tabIndex * (BTN_HEIGHT + BTN_PAD))
            tw(indicator, {Position = UDim2.fromOffset(0, targetY)}, 0.35, Enum.EasingStyle.Quint)
        end

        btn.MouseButton1Click:Connect(activate)

        -- Ховер эффект на таб
        btn.MouseEnter:Connect(function()
            if not page.Visible then tw(btn, {BackgroundTransparency = 0.96}, 0.15) end
        end)
        btn.MouseLeave:Connect(function()
            if not page.Visible then tw(btn, {BackgroundTransparency = 1}, 0.15) end
        end)

        -- Активация первого таба при старте
        if firstTab then
            firstTab = false
            task.delay(0.1, activate) -- Небольшая задержка для корректного UI
        end

        -- ═══════════════════════════════════════
        --  ELEMENTS
        -- ═══════════════════════════════════════

        -- SECTION
        function Tab:AddSection(text)
            local s = Instance.new("Frame")
            s.BackgroundTransparency = 1
            s.Size = UDim2.new(1, 0, 0, 24)
            s.Parent = page

            local l = Instance.new("TextLabel")
            l.BackgroundTransparency = 1
            l.Position = UDim2.fromOffset(2, 6)
            l.Size = UDim2.new(1, 0, 0, 12)
            l.Font = Enum.Font.GothamBold
            l.Text = string.upper(text)
            l.TextColor3 = T.Accent
            l.TextSize = 10
            l.TextXAlignment = Enum.TextXAlignment.Left
            l.Parent = s

            local line = Instance.new("Frame")
            line.BackgroundColor3 = T.Line
            line.BorderSizePixel = 0
            line.Position = UDim2.new(0, 0, 1, -1)
            line.Size = UDim2.new(1, 0, 0, 1)
            line.Parent = s

            -- Градиент для линии (исчезает вправо)
            local grad = Instance.new("UIGradient")
            grad.Transparency = NumberSequence.new{
                NumberSequenceKeypoint.new(0, 0),
                NumberSequenceKeypoint.new(1, 1)
            }
            grad.Parent = line
        end

        -- LABEL
        function Tab:AddLabel(text)
            local l = Instance.new("TextLabel")
            l.BackgroundTransparency = 1
            l.Size = UDim2.new(1, 0, 0, 20)
            l.Font = Enum.Font.Gotham
            l.Text = text
            l.TextColor3 = T.Dim
            l.TextSize = 13
            l.TextXAlignment = Enum.TextXAlignment.Left
            l.Parent = page
            
            local obj = {}
            function obj:Set(v) l.Text = v end
            return obj
        end

        -- BUTTON
        function Tab:AddButton(c)
            local b = Instance.new("TextButton")
            b.BackgroundColor3 = T.Elem
            b.Size = UDim2.new(1, 0, 0, 32)
            b.Font = Enum.Font.GothamMedium
            b.Text = c.Name or "Button"
            b.TextColor3 = T.Text
            b.TextSize = 13
            b.AutoButtonColor = false
            b.Parent = page
            rc(b, 6)
            
            local s = stroke(b, T.Line, 1, 0.4)

            b.MouseEnter:Connect(function()
                tw(b, {BackgroundColor3 = T.Hover}, 0.15)
                tw(s, {Color = T.Accent, Transparency = 0.2}, 0.15) -- Glow effect
            end)
            b.MouseLeave:Connect(function()
                tw(b, {BackgroundColor3 = T.Elem}, 0.15)
                tw(s, {Color = T.Line, Transparency = 0.4}, 0.15)
            end)
            b.MouseButton1Click:Connect(function()
                tw(b, {BackgroundColor3 = T.Accent}, 0.05)
                task.delay(0.05, function() tw(b, {BackgroundColor3 = T.Hover}, 0.15) end)
                if c.Callback then task.spawn(c.Callback) end
            end)
        end

        -- TOGGLE
        function Tab:AddToggle(c)
            local on = c.Default or false
            
            local t = Instance.new("TextButton")
            t.BackgroundColor3 = T.Elem
            t.Size = UDim2.new(1, 0, 0, 36)
            t.Text = ""
            t.AutoButtonColor = false
            t.Parent = page
            rc(t, 6)
            local s = stroke(t, T.Line, 1, 0.4)

            local title = Instance.new("TextLabel")
            title.BackgroundTransparency = 1
            title.Position = UDim2.fromOffset(10, 0)
            title.Size = UDim2.new(1, -60, 1, 0)
            title.Font = Enum.Font.Gotham
            title.Text = c.Name or "Toggle"
            title.TextColor3 = T.Text
            title.TextSize = 13
            title.TextXAlignment = Enum.TextXAlignment.Left
            title.Parent = t

            -- Pill Background
            local pill = Instance.new("Frame")
            pill.BackgroundColor3 = on and T.Accent or T.Off
            pill.AnchorPoint = Vector2.new(1, 0.5)
            pill.Position = UDim2.new(1, -10, 0.5, 0)
            pill.Size = UDim2.fromOffset(34, 18)
            pill.Parent = t
            rc(pill, 9)

            -- Animated Dot
            local dot = Instance.new("Frame")
            dot.BackgroundColor3 = Color3.new(1,1,1)
            dot.Position = on and UDim2.new(1, -16, 0.5, -6) or UDim2.new(0, 2, 0.5, -6)
            dot.Size = UDim2.fromOffset(12, 12)
            dot.Parent = pill
            rc(dot, 6)

            local function update()
                tw(pill, {BackgroundColor3 = on and T.Accent or T.Off}, 0.2)
                tw(dot, {Position = on and UDim2.new(1, -16, 0.5, -6) or UDim2.new(0, 2, 0.5, -6)}, 0.2, Enum.EasingStyle.Back)
                if c.Callback then task.spawn(c.Callback, on) end
            end

            t.MouseButton1Click:Connect(function()
                on = not on
                update()
            end)

            t.MouseEnter:Connect(function()
                tw(t, {BackgroundColor3 = T.Hover}, 0.15)
                tw(s, {Color = T.Accent, Transparency = 0.2}, 0.15)
            end)
            t.MouseLeave:Connect(function()
                tw(t, {BackgroundColor3 = T.Elem}, 0.15)
                tw(s, {Color = T.Line, Transparency = 0.4}, 0.15)
            end)
            
            local obj = {}
            function obj:Set(v) on = v; update() end
            return obj
        end

        -- SLIDER
        function Tab:AddSlider(c)
            local min, max = c.Min or 0, c.Max or 100
            local val = math.clamp(c.Default or min, min, max)
            local dragging = false
            
            local f = Instance.new("Frame")
            f.BackgroundColor3 = T.Elem
            f.Size = UDim2.new(1, 0, 0, 48)
            f.Parent = page
            rc(f, 6)
            local s = stroke(f, T.Line, 1, 0.4)

            local title = Instance.new("TextLabel")
            title.BackgroundTransparency = 1
            title.Position = UDim2.fromOffset(10, 6)
            title.Size = UDim2.new(1, -40, 0, 20)
            title.Font = Enum.Font.Gotham
            title.Text = c.Name or "Slider"
            title.TextColor3 = T.Text
            title.TextSize = 13
            title.TextXAlignment = Enum.TextXAlignment.Left
            title.Parent = f

            local valLbl = Instance.new("TextLabel")
            valLbl.BackgroundTransparency = 1
            valLbl.AnchorPoint = Vector2.new(1, 0)
            valLbl.Position = UDim2.new(1, -10, 0, 6)
            valLbl.Size = UDim2.fromOffset(40, 20)
            valLbl.Font = Enum.Font.GothamBold
            valLbl.Text = tostring(val)
            valLbl.TextColor3 = T.Accent
            valLbl.TextSize = 12
            valLbl.TextXAlignment = Enum.TextXAlignment.Right
            valLbl.Parent = f

            local track = Instance.new("Frame")
            track.BackgroundColor3 = T.Off
            track.Position = UDim2.fromOffset(10, 34)
            track.Size = UDim2.new(1, -20, 0, 4)
            track.Parent = f
            rc(track, 2)

            local fill = Instance.new("Frame")
            fill.BackgroundColor3 = T.Accent
            fill.Size = UDim2.new((val-min)/(max-min), 0, 1, 0)
            fill.Parent = track
            rc(fill, 2)

            -- Gradient on Slider Fill
            local grad = Instance.new("UIGradient")
            grad.Color = ColorSequence.new{
                ColorSequenceKeypoint.new(0, T.AccentLight),
                ColorSequenceKeypoint.new(1, T.Accent)
            }
            grad.Parent = fill

            -- Knob
            local knob = Instance.new("Frame")
            knob.BackgroundColor3 = Color3.new(1,1,1)
            knob.AnchorPoint = Vector2.new(0.5, 0.5)
            knob.Position = UDim2.new(1, 0, 0.5, 0)
            knob.Size = UDim2.fromOffset(10, 10)
            knob.Parent = fill
            rc(knob, 5)
            stroke(knob, T.Accent, 1, 0.2)

            local function update(input)
                local sizeX = track.AbsoluteSize.X
                if sizeX == 0 then return end
                local percent = math.clamp((input.Position.X - track.AbsolutePosition.X) / sizeX, 0, 1)
                val = math.floor(min + (max - min) * percent)
                
                valLbl.Text = tostring(val)
                fill.Size = UDim2.new(percent, 0, 1, 0)
                
                if c.Callback then task.spawn(c.Callback, val) end
            end

            f.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    dragging = true
                    update(input)
                end
            end)
            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    dragging = false
                end
            end)
            UserInputService.InputChanged:Connect(function(input)
                if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                    update(input)
                end
            end)

            f.MouseEnter:Connect(function()
                tw(f, {BackgroundColor3 = T.Hover}, 0.15)
                tw(s, {Color = T.Accent, Transparency = 0.2}, 0.15)
            end)
            f.MouseLeave:Connect(function()
                tw(f, {BackgroundColor3 = T.Elem}, 0.15)
                tw(s, {Color = T.Line, Transparency = 0.4}, 0.15)
            end)
        end

        -- DROPDOWN
        function Tab:AddDropdown(c)
            local opts = c.Options or {}
            local sel = c.Default or opts[1] or "None"
            local open = false
            local CLOSED_H = 38
            local OPT_H = 30
            
            local f = Instance.new("Frame")
            f.BackgroundColor3 = T.Elem
            f.Size = UDim2.new(1, 0, 0, CLOSED_H)
            f.ClipsDescendants = true
            f.Parent = page
            rc(f, 6)
            local s = stroke(f, T.Line, 1, 0.4)

            local btn = Instance.new("TextButton")
            btn.BackgroundTransparency = 1
            btn.Size = UDim2.new(1, 0, 0, CLOSED_H)
            btn.Text = ""
            btn.Parent = f

            local title = Instance.new("TextLabel")
            title.BackgroundTransparency = 1
            title.Position = UDim2.fromOffset(10, 0)
            title.Size = UDim2.new(0.5, 0, 1, 0)
            title.Font = Enum.Font.Gotham
            title.Text = c.Name or "Dropdown"
            title.TextColor3 = T.Text
            title.TextSize = 13
            title.TextXAlignment = Enum.TextXAlignment.Left
            title.Parent = btn

            local disp = Instance.new("TextLabel")
            disp.BackgroundTransparency = 1
            disp.AnchorPoint = Vector2.new(1, 0)
            disp.Position = UDim2.new(1, -28, 0, 0)
            disp.Size = UDim2.new(0.4, 0, 1, 0)
            disp.Font = Enum.Font.GothamBold
            disp.Text = sel
            disp.TextColor3 = T.Accent
            disp.TextSize = 12
            disp.TextXAlignment = Enum.TextXAlignment.Right
            disp.Parent = btn

            -- Animated Arrow
            local arrow = Instance.new("TextLabel")
            arrow.BackgroundTransparency = 1
            arrow.AnchorPoint = Vector2.new(1, 0.5)
            arrow.Position = UDim2.new(1, -10, 0.5, 0)
            arrow.Size = UDim2.fromOffset(14, 14)
            arrow.Text = "›"
            arrow.Rotation = 90
            arrow.TextColor3 = T.Dim
            arrow.TextSize = 18
            arrow.Font = Enum.Font.GothamBold
            arrow.Parent = btn

            -- Options List
            local listFrame = Instance.new("Frame")
            listFrame.BackgroundTransparency = 1
            listFrame.Position = UDim2.fromOffset(0, CLOSED_H)
            listFrame.Size = UDim2.new(1, 0, 0, 0)
            listFrame.Parent = f

            local listLayout = Instance.new("UIListLayout")
            listLayout.SortOrder = Enum.SortOrder.LayoutOrder
            listLayout.Parent = listFrame

            local function buildOpts()
                for _, ch in ipairs(listFrame:GetChildren()) do
                    if ch:IsA("TextButton") then ch:Destroy() end
                end
                for _, opt in ipairs(opts) do
                    local b = Instance.new("TextButton")
                    b.BackgroundColor3 = T.Hover
                    b.BackgroundTransparency = 1
                    b.Size = UDim2.new(1, 0, 0, OPT_H)
                    b.Font = Enum.Font.Gotham
                    b.Text = "  " .. opt
                    b.TextColor3 = (opt == sel) and T.Accent or T.Dim
                    b.TextSize = 12
                    b.TextXAlignment = Enum.TextXAlignment.Left
                    b.Parent = listFrame
                    
                    b.MouseButton1Click:Connect(function()
                        sel = opt
                        disp.Text = sel
                        open = false
                        tw(f, {Size = UDim2.new(1, 0, 0, CLOSED_H)}, 0.25)
                        tw(arrow, {Rotation = 90}, 0.25)
                        if c.Callback then task.spawn(c.Callback, sel) end
                        
                        -- Update Highlight
                        for _, x in ipairs(listFrame:GetChildren()) do
                            if x:IsA("TextButton") then
                                x.TextColor3 = (x.Text:sub(3) == sel) and T.Accent or T.Dim
                            end
                        end
                    end)
                end
            end
            buildOpts()

            btn.MouseButton1Click:Connect(function()
                open = not open
                tw(arrow, {Rotation = open and -90 or 90}, 0.25)
                tw(f, {Size = UDim2.new(1, 0, 0, open and (CLOSED_H + #opts * OPT_H) or CLOSED_H)}, 0.25)
            end)
            
            btn.MouseEnter:Connect(function() tw(s, {Color = T.Accent, Transparency = 0.2}, 0.15) end)
            btn.MouseLeave:Connect(function() tw(s, {Color = T.Line, Transparency = 0.4}, 0.15) end)
            
            local obj = {}
            function obj:Refresh(newOpts)
                opts = newOpts
                sel = opts[1] or "None"
                disp.Text = sel
                buildOpts()
                if open then tw(f, {Size = UDim2.new(1, 0, 0, CLOSED_H + #opts * OPT_H)}, 0.25) end
            end
            return obj
        end

        -- KEYBIND
        function Tab:AddKeybind(c)
            local key = c.Default or Enum.KeyCode.RightShift
            local listening = false
            
            local f = Instance.new("TextButton")
            f.BackgroundColor3 = T.Elem
            f.Size = UDim2.new(1, 0, 0, 34)
            f.Text = ""
            f.AutoButtonColor = false
            f.Parent = page
            rc(f, 6)
            local s = stroke(f, T.Line, 1, 0.4)

            local title = Instance.new("TextLabel")
            title.BackgroundTransparency = 1
            title.Position = UDim2.fromOffset(10, 0)
            title.Size = UDim2.new(1, -50, 1, 0)
            title.Font = Enum.Font.Gotham
            title.Text = c.Name or "Keybind"
            title.TextColor3 = T.Text
            title.TextSize = 13
            title.TextXAlignment = Enum.TextXAlignment.Left
            title.Parent = f

            local kDisp = Instance.new("Frame")
            kDisp.BackgroundColor3 = T.Off
            kDisp.AnchorPoint = Vector2.new(1, 0.5)
            kDisp.Position = UDim2.new(1, -10, 0.5, 0)
            kDisp.Size = UDim2.fromOffset(46, 20)
            kDisp.Parent = f
            rc(kDisp, 4)

            local kLbl = Instance.new("TextLabel")
            kLbl.BackgroundTransparency = 1
            kLbl.Size = UDim2.new(1, 0, 1, 0)
            kLbl.Font = Enum.Font.GothamBold
            kLbl.Text = key.Name
            kLbl.TextColor3 = T.Accent
            kLbl.TextSize = 11
            kLbl.Parent = kDisp

            f.MouseButton1Click:Connect(function()
                listening = true
                kLbl.Text = "..."
                tw(kDisp, {BackgroundColor3 = T.Accent}, 0.15)
                tw(kLbl, {TextColor3 = Color3.new(1,1,1)}, 0.15)
            end)

            UserInputService.InputBegan:Connect(function(input)
                if listening and input.UserInputType == Enum.UserInputType.Keyboard then
                    listening = false
                    key = input.KeyCode
                    kLbl.Text = key.Name
                    tw(kDisp, {BackgroundColor3 = T.Off}, 0.15)
                    tw(kLbl, {TextColor3 = T.Accent}, 0.15)
                    if c.Callback then task.spawn(c.Callback, key) end
                elseif not listening and input.KeyCode == key then
                    if c.Callback then task.spawn(c.Callback, key) end
                end
            end)

            f.MouseEnter:Connect(function() tw(s, {Color = T.Accent, Transparency = 0.2}, 0.15) end)
            f.MouseLeave:Connect(function() tw(s, {Color = T.Line, Transparency = 0.4}, 0.15) end)
        end

        return Tab
    end

    -- ═══════════════════════════════════════
    --  NOTIFICATIONS
    -- ═══════════════════════════════════════
    function Window:Notify(c)
        local dur = c.Duration or 4
        
        local n = Instance.new("Frame")
        n.BackgroundColor3 = T.TopBar
        n.BorderSizePixel = 0
        n.AnchorPoint = Vector2.new(1, 1)
        n.Position = UDim2.new(1, 20, 1, -20) -- Start off screen
        n.Size = UDim2.fromOffset(260, 64)
        n.Parent = sg
        rc(n, 8)
        stroke(n, T.Accent, 1, 0.5)

        local bar = Instance.new("Frame")
        bar.BackgroundColor3 = T.Accent
        bar.BorderSizePixel = 0
        bar.Size = UDim2.new(0, 4, 1, 0)
        bar.Parent = n
        
        -- Скругление только слева для полоски
        local barCorner = Instance.new("UICorner")
        barCorner.CornerRadius = UDim.new(0, 8)
        barCorner.Parent = bar
        -- Обрезаем чтобы было ровно
        local clip = Instance.new("Frame")
        clip.BackgroundTransparency = 1
        clip.ClipsDescendants = true
        clip.Size = UDim2.new(1,0,1,0)
        clip.Parent = n
        bar.Parent = clip

        local title = Instance.new("TextLabel")
        title.BackgroundTransparency = 1
        title.Position = UDim2.fromOffset(14, 8)
        title.Size = UDim2.new(1, -20, 0, 16)
        title.Font = Enum.Font.GothamBold
        title.Text = c.Title or "Notification"
        title.TextColor3 = T.Text
        title.TextSize = 13
        title.TextXAlignment = Enum.TextXAlignment.Left
        title.Parent = n

        local msg = Instance.new("TextLabel")
        msg.BackgroundTransparency = 1
        msg.Position = UDim2.fromOffset(14, 26)
        msg.Size = UDim2.new(1, -20, 0, 24)
        msg.Font = Enum.Font.Gotham
        msg.Text = c.Content or "Alert message here"
        msg.TextColor3 = T.Dim
        msg.TextSize = 12
        msg.TextXAlignment = Enum.TextXAlignment.Left
        msg.TextWrapped = true
        msg.Parent = n

        -- Timer Bar
        local timer = Instance.new("Frame")
        timer.BackgroundColor3 = T.Accent
        timer.BorderSizePixel = 0
        timer.Position = UDim2.new(0, 0, 1, -2)
        timer.Size = UDim2.new(1, 0, 0, 2)
        timer.Parent = n

        -- Animate In
        tw(n, {Position = UDim2.new(1, -20, 1, -20)}, 0.4, Enum.EasingStyle.Back)
        -- Animate Timer
        tw(timer, {Size = UDim2.new(0, 0, 0, 2)}, dur, Enum.EasingStyle.Linear)
        
        task.delay(dur, function()
            tw(n, {Position = UDim2.new(1, 300, 1, -20)}, 0.4, Enum.EasingStyle.Back)
            task.delay(0.4, function() n:Destroy() end)
        end)
    end

    function Window:Destroy()
        if canvasSupport then
            tw(main, {GroupTransparency = 1}, 0.3)
            task.delay(0.3, function() sg:Destroy() end)
        else
            sg:Destroy()
        end
    end

    return Window
end

return PulseUI
