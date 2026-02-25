--[[
    ╔══════════════════════════════════════════╗
    ║         PulseUI Library v1.0             ║
    ║    Dark + Purple Accent UI Framework     ║
    ╚══════════════════════════════════════════╝
    
    local PulseUI = loadstring(game:HttpGet("RAW_URL"))()
    local Window = PulseUI:CreateWindow({ Title = "MyScript" })
    local Tab = Window:AddTab("Tab Name")
    Tab:AddToggle({ Name = "Feature", Default = false, Callback = function(v) end })
]]

local TweenService   = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players        = game:GetService("Players")
local CoreGui        = game:GetService("CoreGui")

local PulseUI = {}

-- ═══════════════════════════════════════════
--  THEME
-- ═══════════════════════════════════════════
local Theme = {
    Background   = Color3.fromRGB(16, 16, 21),
    TopBar       = Color3.fromRGB(12, 12, 16),
    Sidebar      = Color3.fromRGB(20, 20, 26),
    Element      = Color3.fromRGB(28, 28, 35),
    ElementHover = Color3.fromRGB(36, 36, 45),
    Accent       = Color3.fromRGB(140, 60, 215),
    Text         = Color3.fromRGB(225, 225, 230),
    TextDim      = Color3.fromRGB(115, 115, 130),
    ToggleOff    = Color3.fromRGB(48, 48, 56),
    Divider      = Color3.fromRGB(35, 35, 43),
    ScrollBar    = Color3.fromRGB(55, 55, 65),
}

-- ═══════════════════════════════════════════
--  UTILITIES
-- ═══════════════════════════════════════════
local function tween(obj, props, dur)
    TweenService:Create(
        obj,
        TweenInfo.new(dur or 0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
        props
    ):Play()
end

local function addCorner(parent, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius or 6)
    c.Parent = parent
    return c
end

local function addPadding(parent, t, r, b, l)
    local p = Instance.new("UIPadding")
    p.PaddingTop    = UDim.new(0, t or 0)
    p.PaddingRight  = UDim.new(0, r or 0)
    p.PaddingBottom = UDim.new(0, b or 0)
    p.PaddingLeft   = UDim.new(0, l or 0)
    p.Parent = parent
    return p
end

-- ═══════════════════════════════════════════
--  CREATE WINDOW
-- ═══════════════════════════════════════════
function PulseUI:CreateWindow(cfg)
    cfg = cfg or {}

    local Window    = {}
    local allTabs   = {}
    local firstTab  = true
    local isVisible = true

    -- ── ScreenGui ──
    local gui = Instance.new("ScreenGui")
    gui.Name = "PulseUI_" .. math.random(1000, 9999)
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    gui.ResetOnSpawn = false

    local ok = pcall(function() gui.Parent = CoreGui end)
    if not ok then
        gui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
    end

    -- ── Main Frame ──
    local main = Instance.new("Frame")
    main.Name = "Main"
    main.Parent = gui
    main.BackgroundColor3 = Theme.Background
    main.AnchorPoint = Vector2.new(0.5, 0.5)
    main.Position = UDim2.fromScale(0.5, 0.5)
    main.Size = cfg.Size or UDim2.fromOffset(680, 460)
    main.ClipsDescendants = true
    addCorner(main, 8)

    local stroke = Instance.new("UIStroke")
    stroke.Color = Theme.Accent
    stroke.Thickness = 1
    stroke.Transparency = 0.82
    stroke.Parent = main

    -- ── Top Bar ──
    local topBar = Instance.new("Frame")
    topBar.Name = "TopBar"
    topBar.Parent = main
    topBar.BackgroundColor3 = Theme.TopBar
    topBar.Size = UDim2.new(1, 0, 0, 38)
    topBar.BorderSizePixel = 0

    local topDiv = Instance.new("Frame")
    topDiv.Parent = topBar
    topDiv.BackgroundColor3 = Theme.Divider
    topDiv.Position = UDim2.new(0, 0, 1, 0)
    topDiv.Size = UDim2.new(1, 0, 0, 1)
    topDiv.BorderSizePixel = 0

    local titleLbl = Instance.new("TextLabel")
    titleLbl.Parent = topBar
    titleLbl.BackgroundTransparency = 1
    titleLbl.Position = UDim2.new(0, 14, 0, 0)
    titleLbl.Size = UDim2.new(1, -28, 1, 0)
    titleLbl.Font = Enum.Font.GothamBold
    titleLbl.Text = cfg.Title or "PulseUI"
    titleLbl.TextColor3 = Theme.Accent
    titleLbl.TextSize = 15
    titleLbl.TextXAlignment = Enum.TextXAlignment.Left

    -- ── Sidebar ──
    local sidebar = Instance.new("Frame")
    sidebar.Name = "Sidebar"
    sidebar.Parent = main
    sidebar.BackgroundColor3 = Theme.Sidebar
    sidebar.Position = UDim2.new(0, 0, 0, 39)
    sidebar.Size = UDim2.new(0, 150, 1, -39)
    sidebar.BorderSizePixel = 0

    local sideDiv = Instance.new("Frame")
    sideDiv.Parent = sidebar
    sideDiv.BackgroundColor3 = Theme.Divider
    sideDiv.Position = UDim2.new(1, 0, 0, 0)
    sideDiv.Size = UDim2.new(0, 1, 1, 0)
    sideDiv.BorderSizePixel = 0

    local tabScroll = Instance.new("ScrollingFrame")
    tabScroll.Parent = sidebar
    tabScroll.BackgroundTransparency = 1
    tabScroll.Position = UDim2.new(0, 6, 0, 8)
    tabScroll.Size = UDim2.new(1, -12, 1, -16)
    tabScroll.ScrollBarThickness = 0
    tabScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    tabScroll.ScrollingDirection = Enum.ScrollingDirection.Y

    local tabLayout = Instance.new("UIListLayout")
    tabLayout.Parent = tabScroll
    tabLayout.Padding = UDim.new(0, 3)
    tabLayout.SortOrder = Enum.SortOrder.LayoutOrder

    tabLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        tabScroll.CanvasSize = UDim2.new(0, 0, 0, tabLayout.AbsoluteContentSize.Y)
    end)

    -- ── Page Container ──
    local pageContainer = Instance.new("Frame")
    pageContainer.Name = "Pages"
    pageContainer.Parent = main
    pageContainer.BackgroundTransparency = 1
    pageContainer.Position = UDim2.new(0, 151, 0, 39)
    pageContainer.Size = UDim2.new(1, -151, 1, -39)

    -- ══════════════════════════════════
    --  DRAG (только за TopBar)
    -- ══════════════════════════════════
    do
        local dragging, dragStart, startPos

        topBar.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                dragStart = input.Position
                startPos  = main.Position
                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then
                        dragging = false
                    end
                end)
            end
        end)

        UserInputService.InputChanged:Connect(function(input)
            if not dragging then return end
            if input.UserInputType == Enum.UserInputType.MouseMovement
            or input.UserInputType == Enum.UserInputType.Touch then
                local delta = input.Position - dragStart
                main.Position = UDim2.new(
                    startPos.X.Scale, startPos.X.Offset + delta.X,
                    startPos.Y.Scale, startPos.Y.Offset + delta.Y
                )
            end
        end)
    end

    -- ══════════════════════════════════
    --  MINIMIZE KEY
    -- ══════════════════════════════════
    local minKey = cfg.MinimizeKey or Enum.KeyCode.RightControl

    UserInputService.InputBegan:Connect(function(input, gpe)
        if gpe then return end
        if input.KeyCode == minKey then
            isVisible = not isVisible
            main.Visible = isVisible
        end
    end)

    -- ══════════════════════════════════════════
    --  WINDOW:ADDTAB
    -- ══════════════════════════════════════════
    function Window:AddTab(tabName)
        local Tab = {}

        -- ── Кнопка вкладки ──
        local tabBtn = Instance.new("TextButton")
        tabBtn.Parent = tabScroll
        tabBtn.BackgroundColor3 = Theme.Accent
        tabBtn.BackgroundTransparency = 1
        tabBtn.Size = UDim2.new(1, 0, 0, 30)
        tabBtn.Text = ""
        tabBtn.AutoButtonColor = false
        addCorner(tabBtn, 5)

        local indicator = Instance.new("Frame")
        indicator.Parent = tabBtn
        indicator.BackgroundColor3 = Theme.Accent
        indicator.Position = UDim2.new(0, 0, 0.15, 0)
        indicator.Size = UDim2.new(0, 3, 0.7, 0)
        indicator.BackgroundTransparency = 1
        addCorner(indicator, 2)

        local tabText = Instance.new("TextLabel")
        tabText.Parent = tabBtn
        tabText.BackgroundTransparency = 1
        tabText.Position = UDim2.new(0, 14, 0, 0)
        tabText.Size = UDim2.new(1, -14, 1, 0)
        tabText.Font = Enum.Font.GothamMedium
        tabText.Text = tabName
        tabText.TextColor3 = Theme.TextDim
        tabText.TextSize = 13
        tabText.TextXAlignment = Enum.TextXAlignment.Left

        -- ── Страница ──
        local page = Instance.new("ScrollingFrame")
        page.Parent = pageContainer
        page.BackgroundTransparency = 1
        page.Size = UDim2.new(1, 0, 1, 0)
        page.ScrollBarThickness = 3
        page.ScrollBarImageColor3 = Theme.ScrollBar
        page.CanvasSize = UDim2.new(0, 0, 0, 0)
        page.Visible = false
        page.BorderSizePixel = 0
        page.ScrollingDirection = Enum.ScrollingDirection.Y
        page.TopImage    = "rbxasset://textures/ui/Scroll/scroll-middle.png"
        page.BottomImage = "rbxasset://textures/ui/Scroll/scroll-middle.png"

        local pageListLayout = Instance.new("UIListLayout")
        pageListLayout.Parent = page
        pageListLayout.Padding = UDim.new(0, 5)
        pageListLayout.SortOrder = Enum.SortOrder.LayoutOrder

        addPadding(page, 6, 10, 6, 10)

        pageListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            page.CanvasSize = UDim2.new(0, 0, 0, pageListLayout.AbsoluteContentSize.Y + 16)
        end)

        -- ── Активация вкладки ──
        local function activate()
            for _, t in ipairs(allTabs) do
                t.page.Visible = false
                tween(t.indicator, {BackgroundTransparency = 1}, 0.2)
                tween(t.tabText,   {TextColor3 = Theme.TextDim}, 0.2)
                tween(t.btn,       {BackgroundTransparency = 1}, 0.2)
            end
            page.Visible = true
            tween(indicator, {BackgroundTransparency = 0}, 0.2)
            tween(tabText,   {TextColor3 = Theme.Text}, 0.2)
            tween(tabBtn,    {BackgroundTransparency = 0.92}, 0.2)
        end

        tabBtn.MouseButton1Click:Connect(activate)

        table.insert(allTabs, {
            btn = tabBtn, page = page,
            indicator = indicator, tabText = tabText
        })

        if firstTab then
            firstTab = false
            activate()
        end

        -- ════════════════════════════════════
        --  ЭЛЕМЕНТЫ
        -- ════════════════════════════════════

        -- ── SECTION ──
        function Tab:AddSection(name)
            local sec = Instance.new("TextLabel")
            sec.Parent = page
            sec.BackgroundTransparency = 1
            sec.Size = UDim2.new(1, 0, 0, 24)
            sec.Font = Enum.Font.GothamBold
            sec.Text = string.upper(name)
            sec.TextColor3 = Theme.TextDim
            sec.TextSize = 10
            sec.TextXAlignment = Enum.TextXAlignment.Left
        end

        -- ── LABEL ──
        function Tab:AddLabel(text)
            local lbl = Instance.new("TextLabel")
            lbl.Parent = page
            lbl.BackgroundTransparency = 1
            lbl.Size = UDim2.new(1, 0, 0, 18)
            lbl.Font = Enum.Font.Gotham
            lbl.Text = text
            lbl.TextColor3 = Theme.TextDim
            lbl.TextSize = 12
            lbl.TextXAlignment = Enum.TextXAlignment.Left

            local obj = {}
            function obj:SetText(t) lbl.Text = t end
            return obj
        end

        -- ── BUTTON ──
        function Tab:AddButton(c)
            c = c or {}
            local btn = Instance.new("TextButton")
            btn.Parent = page
            btn.BackgroundColor3 = Theme.Element
            btn.Size = UDim2.new(1, 0, 0, 32)
            btn.Font = Enum.Font.GothamMedium
            btn.Text = c.Name or "Button"
            btn.TextColor3 = Theme.Text
            btn.TextSize = 13
            btn.AutoButtonColor = false
            addCorner(btn, 5)

            btn.MouseEnter:Connect(function()
                tween(btn, {BackgroundColor3 = Theme.ElementHover}, 0.12)
            end)
            btn.MouseLeave:Connect(function()
                tween(btn, {BackgroundColor3 = Theme.Element}, 0.12)
            end)
            btn.MouseButton1Click:Connect(function()
                tween(btn, {BackgroundColor3 = Theme.Accent}, 0.06)
                task.delay(0.06, function()
                    tween(btn, {BackgroundColor3 = Theme.Element}, 0.2)
                end)
                if c.Callback then c.Callback() end
            end)
        end

        -- ── TOGGLE ──
        function Tab:AddToggle(c)
            c = c or {}
            local toggled = c.Default or false
            local cb = c.Callback or function() end

            local frame = Instance.new("TextButton")
            frame.Parent = page
            frame.BackgroundColor3 = Theme.Element
            frame.Size = UDim2.new(1, 0, 0, 34)
            frame.Text = ""
            frame.AutoButtonColor = false
            addCorner(frame, 5)

            local lbl = Instance.new("TextLabel")
            lbl.Parent = frame
            lbl.BackgroundTransparency = 1
            lbl.Position = UDim2.new(0, 12, 0, 0)
            lbl.Size = UDim2.new(1, -58, 1, 0)
            lbl.Font = Enum.Font.Gotham
            lbl.Text = c.Name or "Toggle"
            lbl.TextColor3 = Theme.Text
            lbl.TextSize = 13
            lbl.TextXAlignment = Enum.TextXAlignment.Left

            local swBg = Instance.new("Frame")
            swBg.Parent = frame
            swBg.BackgroundColor3 = toggled and Theme.Accent or Theme.ToggleOff
            swBg.AnchorPoint = Vector2.new(0, 0.5)
            swBg.Position = UDim2.new(1, -46, 0.5, 0)
            swBg.Size = UDim2.new(0, 34, 0, 17)
            addCorner(swBg, 9)

            local circle = Instance.new("Frame")
            circle.Parent = swBg
            circle.BackgroundColor3 = Color3.new(1, 1, 1)
            circle.Size = UDim2.new(0, 13, 0, 13)
            circle.Position = toggled
                and UDim2.new(1, -15, 0.5, -6)
                or  UDim2.new(0, 2, 0.5, -6)
            addCorner(circle, 7)

            local function updateVisual()
                if toggled then
                    tween(swBg,    {BackgroundColor3 = Theme.Accent}, 0.18)
                    tween(circle,  {Position = UDim2.new(1, -15, 0.5, -6)}, 0.18)
                else
                    tween(swBg,    {BackgroundColor3 = Theme.ToggleOff}, 0.18)
                    tween(circle,  {Position = UDim2.new(0, 2, 0.5, -6)}, 0.18)
                end
            end

            frame.MouseButton1Click:Connect(function()
                toggled = not toggled
                updateVisual()
                cb(toggled)
            end)

            frame.MouseEnter:Connect(function()
                tween(frame, {BackgroundColor3 = Theme.ElementHover}, 0.12)
            end)
            frame.MouseLeave:Connect(function()
                tween(frame, {BackgroundColor3 = Theme.Element}, 0.12)
            end)

            local obj = {}
            function obj:SetValue(v)
                toggled = v
                updateVisual()
                cb(toggled)
            end
            function obj:GetValue() return toggled end
            return obj
        end

        -- ── SLIDER ──
        function Tab:AddSlider(c)
            c = c or {}
            local min   = c.Min or 0
            local max   = c.Max or 100
            local inc   = c.Increment or 1
            local value = math.clamp(c.Default or min, min, max)
            local cb    = c.Callback or function() end

            local frame = Instance.new("Frame")
            frame.Parent = page
            frame.BackgroundColor3 = Theme.Element
            frame.Size = UDim2.new(1, 0, 0, 48)
            addCorner(frame, 5)

            local lbl = Instance.new("TextLabel")
            lbl.Parent = frame
            lbl.BackgroundTransparency = 1
            lbl.Position = UDim2.new(0, 12, 0, 3)
            lbl.Size = UDim2.new(1, -65, 0, 20)
            lbl.Font = Enum.Font.Gotham
            lbl.Text = c.Name or "Slider"
            lbl.TextColor3 = Theme.Text
            lbl.TextSize = 13
            lbl.TextXAlignment = Enum.TextXAlignment.Left

            local valLbl = Instance.new("TextLabel")
            valLbl.Parent = frame
            valLbl.BackgroundTransparency = 1
            valLbl.Position = UDim2.new(1, -55, 0, 3)
            valLbl.Size = UDim2.new(0, 43, 0, 20)
            valLbl.Font = Enum.Font.GothamBold
            valLbl.Text = tostring(value)
            valLbl.TextColor3 = Theme.Accent
            valLbl.TextSize = 13
            valLbl.TextXAlignment = Enum.TextXAlignment.Right

            local barBg = Instance.new("Frame")
            barBg.Parent = frame
            barBg.BackgroundColor3 = Theme.ToggleOff
            barBg.Position = UDim2.new(0, 12, 0, 30)
            barBg.Size = UDim2.new(1, -24, 0, 5)
            addCorner(barBg, 3)

            local fill = Instance.new("Frame")
            fill.Parent = barBg
            fill.BackgroundColor3 = Theme.Accent
            fill.Size = UDim2.new(
                math.clamp((value - min) / (max - min), 0, 1), 0, 1, 0
            )
            addCorner(fill, 3)

            local clickArea = Instance.new("TextButton")
            clickArea.Parent = frame
            clickArea.BackgroundTransparency = 1
            clickArea.Position = UDim2.new(0, 10, 0, 24)
            clickArea.Size = UDim2.new(1, -20, 0, 18)
            clickArea.Text = ""
            clickArea.ZIndex = 2

            local sliding = false

            local function update(posX)
                local absX = barBg.AbsolutePosition.X
                local absW = barBg.AbsoluteSize.X
                if absW == 0 then return end
                local rel  = math.clamp((posX - absX) / absW, 0, 1)
                local raw  = min + (max - min) * rel
                value = math.clamp(
                    math.floor(raw / inc + 0.5) * inc, min, max
                )
                local pct = (value - min) / (max - min)
                tween(fill, {Size = UDim2.new(pct, 0, 1, 0)}, 0.04)
                valLbl.Text = tostring(value)
                cb(value)
            end

            clickArea.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1
                or input.UserInputType == Enum.UserInputType.Touch then
                    sliding = true
                    update(input.Position.X)
                end
            end)

            UserInputService.InputChanged:Connect(function(input)
                if not sliding then return end
                if input.UserInputType == Enum.UserInputType.MouseMovement
                or input.UserInputType == Enum.UserInputType.Touch then
                    update(input.Position.X)
                end
            end)

            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1
                or input.UserInputType == Enum.UserInputType.Touch then
                    sliding = false
                end
            end)

            local obj = {}
            function obj:SetValue(v)
                value = math.clamp(v, min, max)
                fill.Size = UDim2.new((value - min) / (max - min), 0, 1, 0)
                valLbl.Text = tostring(value)
                cb(value)
            end
            function obj:GetValue() return value end
            return obj
        end

        -- ── DROPDOWN ──
        function Tab:AddDropdown(c)
            c = c or {}
            local options  = c.Options or {}
            local selected = c.Default or (options[1] or "")
            local cb       = c.Callback or function() end
            local expanded = false
            local optH     = 26
            local closedH  = 34

            local frame = Instance.new("Frame")
            frame.Parent = page
            frame.BackgroundColor3 = Theme.Element
            frame.Size = UDim2.new(1, 0, 0, closedH)
            frame.ClipsDescendants = true
            addCorner(frame, 5)

            local header = Instance.new("TextButton")
            header.Parent = frame
            header.BackgroundTransparency = 1
            header.Size = UDim2.new(1, 0, 0, closedH)
            header.Text = ""
            header.AutoButtonColor = false

            local lbl = Instance.new("TextLabel")
            lbl.Parent = header
            lbl.BackgroundTransparency = 1
            lbl.Position = UDim2.new(0, 12, 0, 0)
            lbl.Size = UDim2.new(0.5, 0, 1, 0)
            lbl.Font = Enum.Font.Gotham
            lbl.Text = c.Name or "Dropdown"
            lbl.TextColor3 = Theme.Text
            lbl.TextSize = 13
            lbl.TextXAlignment = Enum.TextXAlignment.Left

            local selLbl = Instance.new("TextLabel")
            selLbl.Parent = header
            selLbl.BackgroundTransparency = 1
            selLbl.Position = UDim2.new(0.5, 0, 0, 0)
            selLbl.Size = UDim2.new(0.5, -12, 1, 0)
            selLbl.Font = Enum.Font.GothamMedium
            selLbl.Text = tostring(selected)
            selLbl.TextColor3 = Theme.Accent
            selLbl.TextSize = 12
            selLbl.TextXAlignment = Enum.TextXAlignment.Right

            local optFrame = Instance.new("Frame")
            optFrame.Parent = frame
            optFrame.BackgroundTransparency = 1
            optFrame.Position = UDim2.new(0, 0, 0, closedH + 2)
            optFrame.Size = UDim2.new(1, 0, 0, #options * optH)

            local optLayout = Instance.new("UIListLayout")
            optLayout.Parent = optFrame
            optLayout.SortOrder = Enum.SortOrder.LayoutOrder

            for _, opt in ipairs(options) do
                local optBtn = Instance.new("TextButton")
                optBtn.Name = opt
                optBtn.Parent = optFrame
                optBtn.BackgroundTransparency = 1
                optBtn.BackgroundColor3 = Theme.ElementHover
                optBtn.Size = UDim2.new(1, 0, 0, optH)
                optBtn.Font = Enum.Font.Gotham
                optBtn.Text = "   " .. opt
                optBtn.TextColor3 = (opt == selected)
                    and Theme.Accent or Theme.TextDim
                optBtn.TextSize = 12
                optBtn.TextXAlignment = Enum.TextXAlignment.Left
                optBtn.AutoButtonColor = false

                optBtn.MouseEnter:Connect(function()
                    tween(optBtn, {BackgroundTransparency = 0}, 0.1)
                end)
                optBtn.MouseLeave:Connect(function()
                    tween(optBtn, {BackgroundTransparency = 1}, 0.1)
                end)

                optBtn.MouseButton1Click:Connect(function()
                    selected = opt
                    selLbl.Text = opt
                    cb(opt)

                    for _, child in pairs(optFrame:GetChildren()) do
                        if child:IsA("TextButton") then
                            child.TextColor3 = (child.Name == opt)
                                and Theme.Accent or Theme.TextDim
                        end
                    end

                    expanded = false
                    tween(frame, {
                        Size = UDim2.new(1, 0, 0, closedH)
                    }, 0.2)
                end)
            end

            header.MouseButton1Click:Connect(function()
                expanded = not expanded
                local targetH = expanded
                    and (closedH + 4 + #options * optH)
                    or closedH
                tween(frame, {Size = UDim2.new(1, 0, 0, targetH)}, 0.25)
            end)

            local obj = {}
            function obj:SetValue(v)
                selected = v; selLbl.Text = tostring(v); cb(v)
            end
            function obj:GetValue() return selected end
            return obj
        end

        return Tab
    end

    -- ══════════════════════════════════
    --  NOTIFICATIONS
    -- ══════════════════════════════════
    function Window:Notify(c)
        c = c or {}
        local dur = c.Duration or 4

        local notif = Instance.new("Frame")
        notif.Parent = gui
        notif.BackgroundColor3 = Theme.Sidebar
        notif.AnchorPoint = Vector2.new(1, 1)
        notif.Position = UDim2.new(1, 300, 1, -20)
        notif.Size = UDim2.new(0, 250, 0, 60)
        addCorner(notif, 6)

        local nStroke = Instance.new("UIStroke")
        nStroke.Color = Theme.Accent
        nStroke.Thickness = 1
        nStroke.Transparency = 0.7
        nStroke.Parent = notif

        local nTitle = Instance.new("TextLabel")
        nTitle.Parent = notif
        nTitle.BackgroundTransparency = 1
        nTitle.Position = UDim2.new(0, 10, 0, 6)
        nTitle.Size = UDim2.new(1, -20, 0, 18)
        nTitle.Font = Enum.Font.GothamBold
        nTitle.Text = c.Title or ""
        nTitle.TextColor3 = Theme.Accent
        nTitle.TextSize = 13
        nTitle.TextXAlignment = Enum.TextXAlignment.Left

        local nText = Instance.new("TextLabel")
        nText.Parent = notif
        nText.BackgroundTransparency = 1
        nText.Position = UDim2.new(0, 10, 0, 26)
        nText.Size = UDim2.new(1, -20, 0, 28)
        nText.Font = Enum.Font.Gotham
        nText.Text = c.Content or ""
        nText.TextColor3 = Theme.TextDim
        nText.TextSize = 11
        nText.TextXAlignment = Enum.TextXAlignment.Left
        nText.TextWrapped = true

        tween(notif, {Position = UDim2.new(1, -15, 1, -20)}, 0.4)

        task.delay(dur, function()
            tween(notif, {Position = UDim2.new(1, 300, 1, -20)}, 0.4)
            task.delay(0.5, function() notif:Destroy() end)
        end)
    end

    -- ══════════════════════════════════
    --  DESTROY
    -- ══════════════════════════════════
    function Window:Destroy()
        gui:Destroy()
    end

    return Window
end

return PulseUI
