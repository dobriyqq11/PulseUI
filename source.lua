--[[
    PulseUI Library v2.0
    Usage:
    local PulseUI = loadstring(game:HttpGet("URL"))()
    local Window = PulseUI:CreateWindow({ Title = "Name" })
    local Tab = Window:AddTab("TabName")
    Tab:AddToggle({ Name = "X", Default = false, Callback = function(v) end })
]]

local TweenService     = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players          = game:GetService("Players")
local CoreGui          = game:GetService("CoreGui")

local PulseUI = {}

local T = {
    Bg       = Color3.fromRGB(16, 16, 21),
    Top      = Color3.fromRGB(12, 12, 16),
    Side     = Color3.fromRGB(20, 20, 26),
    Elem     = Color3.fromRGB(28, 28, 35),
    Hover    = Color3.fromRGB(36, 36, 45),
    Accent   = Color3.fromRGB(140, 60, 215),
    Text     = Color3.fromRGB(225, 225, 230),
    Dim      = Color3.fromRGB(115, 115, 130),
    Off      = Color3.fromRGB(48, 48, 56),
    Line     = Color3.fromRGB(35, 35, 43),
}

local function tw(obj, props, dur)
    TweenService:Create(obj, TweenInfo.new(dur or 0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), props):Play()
end

local function rc(parent, r)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, r or 6)
    c.Parent = parent
end

function PulseUI:CreateWindow(cfg)
    cfg = cfg or {}
    local W = {}
    local tabs = {}
    local isFirst = true

    local sg = Instance.new("ScreenGui")
    sg.Name = "PulseUI_" .. tostring(math.random(1000, 9999))
    sg.ResetOnSpawn = false
    sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    local ok = pcall(function() sg.Parent = CoreGui end)
    if not ok then
        sg.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
    end

    -- Main
    local main = Instance.new("Frame")
    main.Name = "Main"
    main.BackgroundColor3 = T.Bg
    main.BorderSizePixel = 0
    main.AnchorPoint = Vector2.new(0.5, 0.5)
    main.Position = UDim2.fromScale(0.5, 0.5)
    main.Size = UDim2.fromOffset(680, 460)
    main.Parent = sg
    rc(main, 8)

    local border = Instance.new("UIStroke")
    border.Color = T.Accent
    border.Thickness = 1
    border.Transparency = 0.8
    border.Parent = main

    -- TopBar
    local topBar = Instance.new("Frame")
    topBar.Name = "TopBar"
    topBar.BackgroundColor3 = T.Top
    topBar.BorderSizePixel = 0
    topBar.Position = UDim2.fromOffset(0, 0)
    topBar.Size = UDim2.new(1, 0, 0, 36)
    topBar.Parent = main

    local titleLabel = Instance.new("TextLabel")
    titleLabel.BackgroundTransparency = 1
    titleLabel.Position = UDim2.fromOffset(14, 0)
    titleLabel.Size = UDim2.new(1, -28, 1, 0)
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.Text = cfg.Title or "PulseUI"
    titleLabel.TextColor3 = T.Accent
    titleLabel.TextSize = 15
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = topBar

    -- Divider
    local div = Instance.new("Frame")
    div.BackgroundColor3 = T.Line
    div.BorderSizePixel = 0
    div.Position = UDim2.new(0, 0, 0, 36)
    div.Size = UDim2.new(1, 0, 0, 1)
    div.Parent = main

    -- Sidebar
    local side = Instance.new("Frame")
    side.Name = "Sidebar"
    side.BackgroundColor3 = T.Side
    side.BorderSizePixel = 0
    side.Position = UDim2.fromOffset(0, 37)
    side.Size = UDim2.new(0, 150, 1, -37)
    side.Parent = main

    local sideDiv = Instance.new("Frame")
    sideDiv.BackgroundColor3 = T.Line
    sideDiv.BorderSizePixel = 0
    sideDiv.Position = UDim2.fromOffset(150, 37)
    sideDiv.Size = UDim2.new(0, 1, 1, -37)
    sideDiv.Parent = main

    -- Tab buttons holder
    local tabHolder = Instance.new("Frame")
    tabHolder.Name = "TabHolder"
    tabHolder.BackgroundTransparency = 1
    tabHolder.Position = UDim2.fromOffset(8, 8)
    tabHolder.Size = UDim2.new(1, -16, 1, -16)
    tabHolder.Parent = side

    local tabList = Instance.new("UIListLayout")
    tabList.Padding = UDim.new(0, 4)
    tabList.SortOrder = Enum.SortOrder.LayoutOrder
    tabList.Parent = tabHolder

    -- Content area
    local content = Instance.new("Frame")
    content.Name = "Content"
    content.BackgroundTransparency = 1
    content.BorderSizePixel = 0
    content.Position = UDim2.fromOffset(152, 37)
    content.Size = UDim2.new(1, -152, 1, -37)
    content.Parent = main

    -- ═══ DRAG ═══
    do
        local dragging, dragStart, startPos
        topBar.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                dragStart = input.Position
                startPos = main.Position
                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then
                        dragging = false
                    end
                end)
            end
        end)
        UserInputService.InputChanged:Connect(function(input)
            if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                local delta = input.Position - dragStart
                main.Position = UDim2.new(
                    startPos.X.Scale, startPos.X.Offset + delta.X,
                    startPos.Y.Scale, startPos.Y.Offset + delta.Y
                )
            end
        end)
    end

    -- ═══ MINIMIZE ═══
    local vis = true
    UserInputService.InputBegan:Connect(function(input, gpe)
        if gpe then return end
        if input.KeyCode == (cfg.MinimizeKey or Enum.KeyCode.RightControl) then
            vis = not vis
            main.Visible = vis
        end
    end)

    -- ═══ ADD TAB ═══
    function W:AddTab(tabName)
        local Tab = {}

        local btn = Instance.new("TextButton")
        btn.Name = tabName
        btn.BackgroundColor3 = T.Accent
        btn.BackgroundTransparency = 1
        btn.BorderSizePixel = 0
        btn.Size = UDim2.new(1, 0, 0, 30)
        btn.Font = Enum.Font.GothamMedium
        btn.Text = "  " .. tabName
        btn.TextColor3 = T.Dim
        btn.TextSize = 13
        btn.TextXAlignment = Enum.TextXAlignment.Left
        btn.AutoButtonColor = false
        btn.Parent = tabHolder
        rc(btn, 5)

        local pg = Instance.new("ScrollingFrame")
        pg.Name = tabName .. "_Page"
        pg.BackgroundTransparency = 1
        pg.BorderSizePixel = 0
        pg.Position = UDim2.fromOffset(0, 0)
        pg.Size = UDim2.new(1, 0, 1, 0)
        pg.CanvasSize = UDim2.fromOffset(0, 0)
        pg.ScrollBarThickness = 3
        pg.ScrollBarImageColor3 = T.Off
        pg.ScrollingDirection = Enum.ScrollingDirection.Y
        pg.Visible = false
        pg.Parent = content

        local pgPad = Instance.new("UIPadding")
        pgPad.PaddingTop = UDim.new(0, 8)
        pgPad.PaddingLeft = UDim.new(0, 10)
        pgPad.PaddingRight = UDim.new(0, 10)
        pgPad.PaddingBottom = UDim.new(0, 8)
        pgPad.Parent = pg

        local pgLayout = Instance.new("UIListLayout")
        pgLayout.Padding = UDim.new(0, 5)
        pgLayout.SortOrder = Enum.SortOrder.LayoutOrder
        pgLayout.Parent = pg

        pgLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            pg.CanvasSize = UDim2.fromOffset(0, pgLayout.AbsoluteContentSize.Y + 20)
        end)

        local tabData = { btn = btn, pg = pg }
        table.insert(tabs, tabData)

        local function switchTo()
            for _, t in ipairs(tabs) do
                t.pg.Visible = false
                tw(t.btn, { TextColor3 = T.Dim, BackgroundTransparency = 1 }, 0.15)
            end
            pg.Visible = true
            tw(btn, { TextColor3 = T.Text, BackgroundTransparency = 0.88 }, 0.15)
        end

        btn.MouseButton1Click:Connect(switchTo)

        if isFirst then
            isFirst = false
            task.defer(switchTo)
        end

        -- ═══ SECTION ═══
        function Tab:AddSection(name)
            local s = Instance.new("TextLabel")
            s.BackgroundTransparency = 1
            s.Size = UDim2.new(1, 0, 0, 22)
            s.Font = Enum.Font.GothamBold
            s.Text = string.upper(name)
            s.TextColor3 = T.Dim
            s.TextSize = 10
            s.TextXAlignment = Enum.TextXAlignment.Left
            s.Parent = pg
        end

        -- ═══ LABEL ═══
        function Tab:AddLabel(text)
            local l = Instance.new("TextLabel")
            l.BackgroundTransparency = 1
            l.Size = UDim2.new(1, 0, 0, 18)
            l.Font = Enum.Font.Gotham
            l.Text = text
            l.TextColor3 = T.Dim
            l.TextSize = 12
            l.TextXAlignment = Enum.TextXAlignment.Left
            l.Parent = pg
            local obj = {}
            function obj:SetText(t) l.Text = t end
            return obj
        end

        -- ═══ BUTTON ═══
        function Tab:AddButton(c)
            c = c or {}
            local b = Instance.new("TextButton")
            b.BackgroundColor3 = T.Elem
            b.BorderSizePixel = 0
            b.Size = UDim2.new(1, 0, 0, 32)
            b.Font = Enum.Font.GothamMedium
            b.Text = c.Name or "Button"
            b.TextColor3 = T.Text
            b.TextSize = 13
            b.AutoButtonColor = false
            b.Parent = pg
            rc(b, 5)
            b.MouseEnter:Connect(function() tw(b, { BackgroundColor3 = T.Hover }, 0.1) end)
            b.MouseLeave:Connect(function() tw(b, { BackgroundColor3 = T.Elem }, 0.1) end)
            b.MouseButton1Click:Connect(function()
                tw(b, { BackgroundColor3 = T.Accent }, 0.05)
                task.delay(0.08, function() tw(b, { BackgroundColor3 = T.Elem }, 0.15) end)
                if c.Callback then task.spawn(c.Callback) end
            end)
        end

        -- ═══ TOGGLE ═══
        function Tab:AddToggle(c)
            c = c or {}
            local on = c.Default or false
            local cb = c.Callback or function() end

            local f = Instance.new("TextButton")
            f.BackgroundColor3 = T.Elem
            f.BorderSizePixel = 0
            f.Size = UDim2.new(1, 0, 0, 34)
            f.Text = ""
            f.AutoButtonColor = false
            f.Parent = pg
            rc(f, 5)

            local lbl = Instance.new("TextLabel")
            lbl.BackgroundTransparency = 1
            lbl.Position = UDim2.fromOffset(12, 0)
            lbl.Size = UDim2.new(1, -56, 1, 0)
            lbl.Font = Enum.Font.Gotham
            lbl.Text = c.Name or "Toggle"
            lbl.TextColor3 = T.Text
            lbl.TextSize = 13
            lbl.TextXAlignment = Enum.TextXAlignment.Left
            lbl.Parent = f

            local swBg = Instance.new("Frame")
            swBg.BackgroundColor3 = on and T.Accent or T.Off
            swBg.BorderSizePixel = 0
            swBg.AnchorPoint = Vector2.new(0, 0.5)
            swBg.Position = UDim2.new(1, -44, 0.5, 0)
            swBg.Size = UDim2.fromOffset(32, 16)
            swBg.Parent = f
            rc(swBg, 8)

            local dot = Instance.new("Frame")
            dot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            dot.BorderSizePixel = 0
            dot.Size = UDim2.fromOffset(12, 12)
            dot.Position = on and UDim2.new(1, -14, 0, 2) or UDim2.fromOffset(2, 2)
            dot.Parent = swBg
            rc(dot, 6)

            local function refresh()
                tw(swBg, { BackgroundColor3 = on and T.Accent or T.Off }, 0.15)
                tw(dot, { Position = on and UDim2.new(1, -14, 0, 2) or UDim2.fromOffset(2, 2) }, 0.15)
            end

            f.MouseButton1Click:Connect(function()
                on = not on
                refresh()
                task.spawn(cb, on)
            end)
            f.MouseEnter:Connect(function() tw(f, { BackgroundColor3 = T.Hover }, 0.1) end)
            f.MouseLeave:Connect(function() tw(f, { BackgroundColor3 = T.Elem }, 0.1) end)

            local obj = {}
            function obj:SetValue(v) on = v; refresh(); task.spawn(cb, on) end
            function obj:GetValue() return on end
            return obj
        end

        -- ═══ SLIDER ═══
        function Tab:AddSlider(c)
            c = c or {}
            local min = c.Min or 0
            local max = c.Max or 100
            local inc = c.Increment or 1
            local val = math.clamp(c.Default or min, min, max)
            local cb = c.Callback or function() end
            local range = math.max(max - min, 1)

            local f = Instance.new("Frame")
            f.BackgroundColor3 = T.Elem
            f.BorderSizePixel = 0
            f.Size = UDim2.new(1, 0, 0, 46)
            f.Parent = pg
            rc(f, 5)

            local lbl = Instance.new("TextLabel")
            lbl.BackgroundTransparency = 1
            lbl.Position = UDim2.fromOffset(12, 4)
            lbl.Size = UDim2.new(1, -60, 0, 16)
            lbl.Font = Enum.Font.Gotham
            lbl.Text = c.Name or "Slider"
            lbl.TextColor3 = T.Text
            lbl.TextSize = 13
            lbl.TextXAlignment = Enum.TextXAlignment.Left
            lbl.Parent = f

            local vLbl = Instance.new("TextLabel")
            vLbl.BackgroundTransparency = 1
            vLbl.Position = UDim2.new(1, -50, 0, 4)
            vLbl.Size = UDim2.fromOffset(38, 16)
            vLbl.Font = Enum.Font.GothamBold
            vLbl.Text = tostring(val)
            vLbl.TextColor3 = T.Accent
            vLbl.TextSize = 13
            vLbl.TextXAlignment = Enum.TextXAlignment.Right
            vLbl.Parent = f

            local barBg = Instance.new("Frame")
            barBg.BackgroundColor3 = T.Off
            barBg.BorderSizePixel = 0
            barBg.Position = UDim2.fromOffset(12, 28)
            barBg.Size = UDim2.new(1, -24, 0, 5)
            barBg.Parent = f
            rc(barBg, 3)

            local fill = Instance.new("Frame")
            fill.BackgroundColor3 = T.Accent
            fill.BorderSizePixel = 0
            fill.Size = UDim2.new(math.clamp((val - min) / range, 0, 1), 0, 1, 0)
            fill.Parent = barBg
            rc(fill, 3)

            local hitbox = Instance.new("TextButton")
            hitbox.BackgroundTransparency = 1
            hitbox.Position = UDim2.fromOffset(10, 22)
            hitbox.Size = UDim2.new(1, -20, 0, 18)
            hitbox.Text = ""
            hitbox.ZIndex = 2
            hitbox.Parent = f

            local sliding = false

            local function update(px)
                local ax = barBg.AbsolutePosition.X
                local aw = barBg.AbsoluteSize.X
                if aw <= 0 then return end
                local rel = math.clamp((px - ax) / aw, 0, 1)
                val = math.clamp(math.floor((min + range * rel) / inc + 0.5) * inc, min, max)
                fill.Size = UDim2.new((val - min) / range, 0, 1, 0)
                vLbl.Text = tostring(val)
                task.spawn(cb, val)
            end

            hitbox.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    sliding = true
                    update(input.Position.X)
                end
            end)
            UserInputService.InputChanged:Connect(function(input)
                if sliding and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                    update(input.Position.X)
                end
            end)
            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    sliding = false
                end
            end)

            local obj = {}
            function obj:SetValue(v)
                val = math.clamp(v, min, max)
                fill.Size = UDim2.new((val - min) / range, 0, 1, 0)
                vLbl.Text = tostring(val)
                task.spawn(cb, val)
            end
            function obj:GetValue() return val end
            return obj
        end

        -- ═══ DROPDOWN ═══
        function Tab:AddDropdown(c)
            c = c or {}
            local opts = c.Options or {}
            local sel = c.Default or (opts[1] or "")
            local cb = c.Callback or function() end
            local open = false
            local optH = 26
            local closedH = 34

            local f = Instance.new("Frame")
            f.BackgroundColor3 = T.Elem
            f.BorderSizePixel = 0
            f.Size = UDim2.new(1, 0, 0, closedH)
            f.ClipsDescendants = true
            f.Parent = pg
            rc(f, 5)

            local header = Instance.new("TextButton")
            header.BackgroundTransparency = 1
            header.BorderSizePixel = 0
            header.Size = UDim2.new(1, 0, 0, closedH)
            header.Text = ""
            header.AutoButtonColor = false
            header.Parent = f

            local hLbl = Instance.new("TextLabel")
            hLbl.BackgroundTransparency = 1
            hLbl.Position = UDim2.fromOffset(12, 0)
            hLbl.Size = UDim2.new(0.5, 0, 1, 0)
            hLbl.Font = Enum.Font.Gotham
            hLbl.Text = c.Name or "Dropdown"
            hLbl.TextColor3 = T.Text
            hLbl.TextSize = 13
            hLbl.TextXAlignment = Enum.TextXAlignment.Left
            hLbl.Parent = header

            local sLbl = Instance.new("TextLabel")
            sLbl.BackgroundTransparency = 1
            sLbl.Position = UDim2.new(0.5, 0, 0, 0)
            sLbl.Size = UDim2.new(0.5, -12, 1, 0)
            sLbl.Font = Enum.Font.GothamMedium
            sLbl.Text = tostring(sel)
            sLbl.TextColor3 = T.Accent
            sLbl.TextSize = 12
            sLbl.TextXAlignment = Enum.TextXAlignment.Right
            sLbl.Parent = header

            local optBox = Instance.new("Frame")
            optBox.BackgroundTransparency = 1
            optBox.BorderSizePixel = 0
            optBox.Position = UDim2.fromOffset(0, closedH + 2)
            optBox.Size = UDim2.new(1, 0, 0, #opts * optH)
            optBox.Parent = f

            local oLayout = Instance.new("UIListLayout")
            oLayout.SortOrder = Enum.SortOrder.LayoutOrder
            oLayout.Parent = optBox

            for _, opt in ipairs(opts) do
                local ob = Instance.new("TextButton")
                ob.Name = opt
                ob.BackgroundColor3 = T.Hover
                ob.BackgroundTransparency = 1
                ob.BorderSizePixel = 0
                ob.Size = UDim2.new(1, 0, 0, optH)
                ob.Font = Enum.Font.Gotham
                ob.Text = "   " .. opt
                ob.TextColor3 = (opt == sel) and T.Accent or T.Dim
                ob.TextSize = 12
                ob.TextXAlignment = Enum.TextXAlignment.Left
                ob.AutoButtonColor = false
                ob.Parent = optBox

                ob.MouseEnter:Connect(function() tw(ob, { BackgroundTransparency = 0 }, 0.08) end)
                ob.MouseLeave:Connect(function() tw(ob, { BackgroundTransparency = 1 }, 0.08) end)
                ob.MouseButton1Click:Connect(function()
                    sel = opt
                    sLbl.Text = opt
                    task.spawn(cb, opt)
                    for _, ch in ipairs(optBox:GetChildren()) do
                        if ch:IsA("TextButton") then
                            ch.TextColor3 = (ch.Name == opt) and T.Accent or T.Dim
                        end
                    end
                    open = false
                    tw(f, { Size = UDim2.new(1, 0, 0, closedH) }, 0.2)
                end)
            end

            header.MouseButton1Click:Connect(function()
                open = not open
                local h = open and (closedH + 4 + #opts * optH) or closedH
                tw(f, { Size = UDim2.new(1, 0, 0, h) }, 0.2)
            end)

            local obj = {}
            function obj:SetValue(v) sel = v; sLbl.Text = tostring(v); task.spawn(cb, v) end
            function obj:GetValue() return sel end
            return obj
        end

        return Tab
    end

    -- ═══ NOTIFY ═══
    function W:Notify(c)
        c = c or {}
        local n = Instance.new("Frame")
        n.BackgroundColor3 = T.Side
        n.BorderSizePixel = 0
        n.AnchorPoint = Vector2.new(1, 1)
        n.Position = UDim2.new(1, 300, 1, -20)
        n.Size = UDim2.fromOffset(250, 60)
        n.Parent = sg
        rc(n, 6)

        local ns = Instance.new("UIStroke")
        ns.Color = T.Accent
        ns.Thickness = 1
        ns.Transparency = 0.7
        ns.Parent = n

        local nt = Instance.new("TextLabel")
        nt.BackgroundTransparency = 1
        nt.Position = UDim2.fromOffset(10, 6)
        nt.Size = UDim2.new(1, -20, 0, 18)
        nt.Font = Enum.Font.GothamBold
        nt.Text = c.Title or ""
        nt.TextColor3 = T.Accent
        nt.TextSize = 13
        nt.TextXAlignment = Enum.TextXAlignment.Left
        nt.Parent = n

        local nc = Instance.new("TextLabel")
        nc.BackgroundTransparency = 1
        nc.Position = UDim2.fromOffset(10, 26)
        nc.Size = UDim2.new(1, -20, 0, 28)
        nc.Font = Enum.Font.Gotham
        nc.Text = c.Content or ""
        nc.TextColor3 = T.Dim
        nc.TextSize = 11
        nc.TextXAlignment = Enum.TextXAlignment.Left
        nc.TextWrapped = true
        nc.Parent = n

        tw(n, { Position = UDim2.new(1, -15, 1, -20) }, 0.35)
        task.delay(c.Duration or 4, function()
            tw(n, { Position = UDim2.new(1, 300, 1, -20) }, 0.35)
            task.delay(0.4, function() n:Destroy() end)
        end)
    end

    function W:Destroy()
        sg:Destroy()
    end

    return W
end

return PulseUI
