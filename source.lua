--[[
    ██████╗ ██████╗ ██╗███████╗███╗   ███╗    ██╗   ██╗██╗
    ██╔══██╗██╔══██╗██║██╔════╝████╗ ████║    ██║   ██║██║
    ██████╔╝██████╔╝██║███████╗██╔████╔██║    ██║   ██║██║
    ██╔═══╝ ██╔══██╗██║╚════██║██║╚██╔╝██║    ██║   ██║██║
    ██║     ██║  ██║██║███████║██║ ╚═╝ ██║    ╚██████╔╝██║
    ╚═╝     ╚═╝  ╚═╝╚═╝╚══════╝╚═╝     ╚═╝     ╚═════╝ ╚═╝
    Prism UI Library v2.1 | Premium Roblox UI
    Compatible with Solara, Fluxus, Delta, etc.
]]

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")

local Player = Players.LocalPlayer
local Mouse = Player:GetMouse()

-- ══════════════════════════════════════
-- SAFE FONT RESOLVER
-- ══════════════════════════════════════
local function SafeFont(name)
    local ok, font = pcall(function() return Enum.Font[name] end)
    if ok and font then return font end
    return Enum.Font.SourceSans
end

-- ══════════════════════════════════════
-- UTILITY FUNCTIONS
-- ══════════════════════════════════════
local function Tween(obj, dur, props, style, dir)
    local ok, t = pcall(function()
        return TweenService:Create(obj, TweenInfo.new(dur, style or Enum.EasingStyle.Quint, dir or Enum.EasingDirection.Out), props)
    end)
    if ok and t then t:Play(); return t end
end

local function Create(cls, props)
    local ok, obj = pcall(Instance.new, cls)
    if not ok or not obj then return nil end
    for k, v in pairs(props or {}) do
        if k ~= "Parent" then
            pcall(function() obj[k] = v end)
        end
    end
    if props and props.Parent then
        obj.Parent = props.Parent
    end
    return obj
end

local function Corner(p, r)
    if not p then return end
    return Create("UICorner", {CornerRadius = UDim.new(0, r or 6), Parent = p})
end

local function Stroke(p, c, t, tr)
    if not p then return end
    return Create("UIStroke", {Color = c or Color3.fromRGB(55,55,70), Thickness = t or 1, Transparency = tr or 0.5, Parent = p})
end

local function Pad(p, t, b, l, r)
    if not p then return end
    return Create("UIPadding", {
        PaddingTop = UDim.new(0, t or 8),
        PaddingBottom = UDim.new(0, b or 8),
        PaddingLeft = UDim.new(0, l or 8),
        PaddingRight = UDim.new(0, r or 8),
        Parent = p
    })
end

local function Ripple(btn)
    if not btn then return end
    local c = Create("Frame", {
        Size = UDim2.new(0,0,0,0),
        Position = UDim2.new(0.5,0,0.5,0),
        AnchorPoint = Vector2.new(0.5,0.5),
        BackgroundColor3 = Color3.new(1,1,1),
        BackgroundTransparency = 0.85,
        Parent = btn
    })
    if c then
        Corner(c, 999)
        Tween(c, 0.5, {Size = UDim2.new(2,0,2,0), BackgroundTransparency = 1})
        task.delay(0.5, function()
            if c and c.Parent then c:Destroy() end
        end)
    end
end

-- ══════════════════════════════════════
-- THEME
-- ══════════════════════════════════════
local T = {
    Bg       = Color3.fromRGB(15, 15, 22),
    Surf     = Color3.fromRGB(20, 20, 30),
    SurfL    = Color3.fromRGB(28, 28, 42),
    SurfH    = Color3.fromRGB(35, 35, 50),
    Accent   = Color3.fromRGB(120, 80, 255),
    AccentD  = Color3.fromRGB(90, 55, 200),
    AccentG  = Color3.fromRGB(140, 100, 255),
    Txt      = Color3.fromRGB(220, 220, 235),
    TxtD     = Color3.fromRGB(130, 130, 155),
    TxtM     = Color3.fromRGB(80, 80, 100),
    Bdr      = Color3.fromRGB(45, 45, 60),
    Ok       = Color3.fromRGB(80, 220, 130),
    Warn     = Color3.fromRGB(255, 180, 50),
    Err      = Color3.fromRGB(255, 75, 75),
    F        = SafeFont("Gotham") or SafeFont("SourceSans"),
    FB       = SafeFont("GothamBold") or SafeFont("SourceSansBold"),
    FS       = SafeFont("GothamSemibold") or SafeFont("SourceSansSemibold"),
}

-- ══════════════════════════════════════
-- LIBRARY
-- ══════════════════════════════════════
local Library = {}
Library.__index = Library

local NHolder = nil

-- ── NOTIFICATIONS ──
function Library:Notify(cfg)
    if not NHolder or not NHolder.Parent then return end
    cfg = cfg or {}
    local title = cfg.Title or "Notification"
    local text = cfg.Text or ""
    local dur = cfg.Duration or 4
    local ntype = cfg.Type or "Info"

    local ac = T.Accent
    if ntype == "Success" then ac = T.Ok
    elseif ntype == "Warning" then ac = T.Warn
    elseif ntype == "Error" then ac = T.Err end

    local n = Create("Frame", {
        Name = "Notif",
        Size = UDim2.new(1, 0, 0, 68),
        BackgroundColor3 = T.Surf,
        BackgroundTransparency = 0.05,
        ClipsDescendants = true,
        Parent = NHolder
    })
    if not n then return end
    Corner(n, 8)
    Stroke(n, ac, 1, 0.6)

    -- Accent sidebar
    Create("Frame", {Size = UDim2.new(0,3,1,-12), Position = UDim2.new(0,8,0,6), BackgroundColor3 = ac, Parent = n})

    -- Title
    Create("TextLabel", {
        Text = title, Font = T.FB, TextColor3 = T.Txt, TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Left,
        Size = UDim2.new(1,-30,0,18), Position = UDim2.new(0,22,0,10),
        BackgroundTransparency = 1, Parent = n
    })

    -- Body
    Create("TextLabel", {
        Text = text, Font = T.F, TextColor3 = T.TxtD, TextSize = 11,
        TextXAlignment = Enum.TextXAlignment.Left, TextWrapped = true,
        Size = UDim2.new(1,-30,0,26), Position = UDim2.new(0,22,0,30),
        BackgroundTransparency = 1, Parent = n
    })

    -- Progress bar
    local pb = Create("Frame", {Size = UDim2.new(1,-16,0,2), Position = UDim2.new(0,8,1,-6), BackgroundColor3 = T.SurfL, Parent = n})
    local pf = Create("Frame", {Size = UDim2.new(1,0,1,0), BackgroundColor3 = ac, Parent = pb})
    Corner(pb, 2); Corner(pf, 2)

    -- Animate in
    n.Position = UDim2.new(1, 50, 0, 0)
    n.BackgroundTransparency = 1
    Tween(n, 0.4, {Position = UDim2.new(0,0,0,0), BackgroundTransparency = 0.05}, Enum.EasingStyle.Back)
    Tween(pf, dur, {Size = UDim2.new(0,0,1,0)}, Enum.EasingStyle.Linear)

    task.delay(dur, function()
        if n and n.Parent then
            Tween(n, 0.3, {Position = UDim2.new(1,50,0,0), BackgroundTransparency = 1})
            task.wait(0.35)
            if n and n.Parent then n:Destroy() end
        end
    end)
end

-- ── CREATE WINDOW ──
function Library:CreateWindow(cfg)
    cfg = cfg or {}
    local wTitle = cfg.Title or "Prism UI"
    local wSize = cfg.Size or UDim2.new(0, 580, 0, 420)

    -- Create ScreenGui with proper parenting for executors
    local sg = Create("ScreenGui", {
        Name = "PrismUI_" .. tostring(math.random(100000, 999999)),
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    })

    -- Try syn.protect_gui first (for synapse-like executors)
    local protected = false
    pcall(function()
        if syn and syn.protect_gui then
            syn.protect_gui(sg)
            sg.Parent = game:GetService("CoreGui")
            protected = true
        end
    end)

    if not protected then
        pcall(function()
            sg.Parent = game:GetService("CoreGui")
        end)
    end

    if not sg.Parent then
        pcall(function()
            sg.Parent = Player:WaitForChild("PlayerGui")
        end)
    end

    if not sg.Parent then
        -- Last resort: gethui() for some executors
        pcall(function()
            if gethui then
                sg.Parent = gethui()
            end
        end)
    end

    -- Notification holder
    NHolder = Create("Frame", {
        Name = "Notifications",
        Size = UDim2.new(0, 300, 1, 0),
        Position = UDim2.new(1, -320, 0, 0),
        BackgroundTransparency = 1,
        Parent = sg
    })
    Create("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 8),
        VerticalAlignment = Enum.VerticalAlignment.Bottom,
        Parent = NHolder
    })
    Pad(NHolder, 0, 20, 0, 0)

    -- Main window frame
    local main = Create("Frame", {
        Name = "Main",
        Size = wSize,
        Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = T.Bg,
        BorderSizePixel = 0,
        ClipsDescendants = true,
        Parent = sg
    })
    Corner(main, 10)
    Stroke(main, T.Bdr, 1, 0.3)

    -- Open animation: start small, grow to full size
    main.Size = UDim2.new(0, 0, 0, 0)
    task.defer(function()
        Tween(main, 0.6, {Size = wSize}, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
    end)

    -- ── TITLE BAR ──
    local tb = Create("Frame", {
        Name = "TitleBar",
        Size = UDim2.new(1, 0, 0, 38),
        BackgroundColor3 = T.Surf,
        BorderSizePixel = 0,
        Parent = main
    })
    Corner(tb, 10)
    -- Bottom fill for title bar to remove bottom rounding
    Create("Frame", {
        Size = UDim2.new(1, 0, 0, 12),
        Position = UDim2.new(0, 0, 1, -12),
        BackgroundColor3 = T.Surf,
        BorderSizePixel = 0,
        Parent = tb
    })

    -- Accent dot with pulse
    local dot = Create("Frame", {
        Size = UDim2.new(0, 8, 0, 8),
        Position = UDim2.new(0, 14, 0.5, -4),
        BackgroundColor3 = T.Accent,
        BorderSizePixel = 0,
        Parent = tb
    })
    Corner(dot, 999)
    task.spawn(function()
        while true do
            if not dot or not dot.Parent then break end
            Tween(dot, 1.5, {BackgroundColor3 = T.AccentG})
            task.wait(1.5)
            if not dot or not dot.Parent then break end
            Tween(dot, 1.5, {BackgroundColor3 = T.Accent})
            task.wait(1.5)
        end
    end)

    -- Title text
    Create("TextLabel", {
        Text = wTitle,
        Font = T.FB,
        TextColor3 = T.Txt,
        TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Left,
        Size = UDim2.new(1, -100, 1, 0),
        Position = UDim2.new(0, 30, 0, 0),
        BackgroundTransparency = 1,
        Parent = tb
    })

    -- Close button
    local closeBtn = Create("TextButton", {
        Text = "X",
        Font = T.FB,
        TextColor3 = T.TxtD,
        TextSize = 14,
        Size = UDim2.new(0, 38, 0, 38),
        Position = UDim2.new(1, -38, 0, 0),
        BackgroundTransparency = 1,
        Parent = tb
    })
    closeBtn.MouseEnter:Connect(function() Tween(closeBtn, 0.2, {TextColor3 = T.Err}) end)
    closeBtn.MouseLeave:Connect(function() Tween(closeBtn, 0.2, {TextColor3 = T.TxtD}) end)
    closeBtn.MouseButton1Click:Connect(function()
        Tween(main, 0.4, {Size = UDim2.new(0,0,0,0)}, Enum.EasingStyle.Back, Enum.EasingDirection.In)
        task.wait(0.45)
        if sg and sg.Parent then sg:Destroy() end
    end)

    -- Minimize button
    local minBtn = Create("TextButton", {
        Text = "-",
        Font = T.FB,
        TextColor3 = T.TxtD,
        TextSize = 16,
        Size = UDim2.new(0, 38, 0, 38),
        Position = UDim2.new(1, -72, 0, 0),
        BackgroundTransparency = 1,
        Parent = tb
    })
    local minimized = false
    minBtn.MouseEnter:Connect(function() Tween(minBtn, 0.2, {TextColor3 = T.Warn}) end)
    minBtn.MouseLeave:Connect(function() Tween(minBtn, 0.2, {TextColor3 = T.TxtD}) end)
    minBtn.MouseButton1Click:Connect(function()
        minimized = not minimized
        if minimized then
            Tween(main, 0.4, {Size = UDim2.new(0, wSize.X.Offset, 0, 38)}, Enum.EasingStyle.Quint)
        else
            Tween(main, 0.4, {Size = wSize}, Enum.EasingStyle.Quint)
        end
    end)

    -- ── DRAGGING ──
    local dragging = false
    local dragStart = nil
    local startPos = nil

    tb.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = main.Position
        end
    end)

    tb.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            local newPos = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
            Tween(main, 0.08, {Position = newPos}, Enum.EasingStyle.Linear)
        end
    end)

    -- ── TAB SIDEBAR ──
    local sidebar = Create("Frame", {
        Name = "Sidebar",
        Size = UDim2.new(0, 140, 1, -40),
        Position = UDim2.new(0, 0, 0, 38),
        BackgroundColor3 = T.Surf,
        BorderSizePixel = 0,
        Parent = main
    })

    -- Separator line
    Create("Frame", {
        Size = UDim2.new(0, 1, 1, -16),
        Position = UDim2.new(1, 0, 0, 8),
        BackgroundColor3 = T.Bdr,
        BackgroundTransparency = 0.5,
        BorderSizePixel = 0,
        Parent = sidebar
    })

    local tabBtnContainer = Create("ScrollingFrame", {
        Size = UDim2.new(1, 0, 1, -8),
        Position = UDim2.new(0, 0, 0, 4),
        BackgroundTransparency = 1,
        ScrollBarThickness = 0,
        BorderSizePixel = 0,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        Parent = sidebar
    })
    -- Try AutomaticCanvasSize, fallback silently
    pcall(function() tabBtnContainer.AutomaticCanvasSize = Enum.AutomaticSize.Y end)

    Create("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 2),
        Parent = tabBtnContainer
    })
    Pad(tabBtnContainer, 4, 4, 6, 6)

    -- Content area
    local contentHolder = Create("Frame", {
        Name = "Content",
        Size = UDim2.new(1, -145, 1, -42),
        Position = UDim2.new(0, 143, 0, 40),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Parent = main
    })

    local tabs = {}
    local activeTab = nil

    -- ══════════════════════════════════════
    -- WINDOW OBJECT
    -- ══════════════════════════════════════
    local Window = {}
    Window.__index = Window
    Window.ScreenGui = sg

    function Window:AddTab(cfg2)
        cfg2 = cfg2 or {}
        local tabName = cfg2.Name or "Tab"
        local tabIcon = cfg2.Icon or ""
        local displayText = tabName
        if tabIcon ~= "" then displayText = tabIcon .. " " .. tabName end

        local tabBtn = Create("TextButton", {
            Text = displayText,
            Font = T.FS,
            TextColor3 = T.TxtD,
            TextSize = 12,
            TextXAlignment = Enum.TextXAlignment.Left,
            Size = UDim2.new(1, 0, 0, 32),
            BackgroundColor3 = T.Accent,
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            AutoButtonColor = false,
            Parent = tabBtnContainer
        })
        Corner(tabBtn, 6)
        Pad(tabBtn, 0, 0, 10, 0)

        local tabPage = Create("ScrollingFrame", {
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            ScrollBarThickness = 2,
            ScrollBarImageColor3 = T.Accent,
            BorderSizePixel = 0,
            CanvasSize = UDim2.new(0, 0, 0, 0),
            Visible = false,
            Parent = contentHolder
        })
        pcall(function() tabPage.AutomaticCanvasSize = Enum.AutomaticSize.Y end)

        Create("UIListLayout", {
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim.new(0, 8),
            Parent = tabPage
        })
        Pad(tabPage, 4, 4, 8, 8)

        local td = {Button = tabBtn, Page = tabPage, Name = tabName}
        table.insert(tabs, td)

        local function selectTab()
            for _, t in ipairs(tabs) do
                t.Page.Visible = false
                Tween(t.Button, 0.25, {BackgroundTransparency = 1, TextColor3 = T.TxtD})
            end
            td.Page.Visible = true
            Tween(tabBtn, 0.25, {BackgroundTransparency = 0.85, TextColor3 = T.Txt})
            activeTab = td
        end

        tabBtn.MouseButton1Click:Connect(selectTab)
        tabBtn.MouseEnter:Connect(function()
            if activeTab ~= td then
                Tween(tabBtn, 0.2, {BackgroundTransparency = 0.9, TextColor3 = T.Txt})
            end
        end)
        tabBtn.MouseLeave:Connect(function()
            if activeTab ~= td then
                Tween(tabBtn, 0.2, {BackgroundTransparency = 1, TextColor3 = T.TxtD})
            end
        end)

        if #tabs == 1 then selectTab() end

        -- ══════════════════════════════════════
        -- TAB OBJECT
        -- ══════════════════════════════════════
        local Tab = {}

        function Tab:AddSection(cfg3)
            cfg3 = cfg3 or {}
            local secName = cfg3.Name or "Section"

            local sf = Create("Frame", {
                Size = UDim2.new(1, 0, 0, 0),
                BackgroundColor3 = T.Surf,
                BackgroundTransparency = 0.3,
                BorderSizePixel = 0,
                Parent = tabPage
            })
            pcall(function() sf.AutomaticSize = Enum.AutomaticSize.Y end)
            Corner(sf, 8)
            Stroke(sf, T.Bdr, 1, 0.6)

            -- Section header
            Create("TextLabel", {
                Text = string.upper(secName),
                Font = T.FB,
                TextColor3 = T.TxtM,
                TextSize = 10,
                TextXAlignment = Enum.TextXAlignment.Left,
                Size = UDim2.new(1, -20, 0, 24),
                Position = UDim2.new(0, 12, 0, 4),
                BackgroundTransparency = 1,
                Parent = sf
            })

            local sc = Create("Frame", {
                Size = UDim2.new(1, 0, 0, 0),
                Position = UDim2.new(0, 0, 0, 26),
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                Parent = sf
            })
            pcall(function() sc.AutomaticSize = Enum.AutomaticSize.Y end)

            Create("UIListLayout", {
                SortOrder = Enum.SortOrder.LayoutOrder,
                Padding = UDim.new(0, 4),
                Parent = sc
            })
            Pad(sc, 0, 8, 10, 10)

            -- ══════════════════════════════════════
            -- SECTION OBJECT
            -- ══════════════════════════════════════
            local Section = {}

            -- TOGGLE
            function Section:AddToggle(c)
                c = c or {}
                local name = c.Name or "Toggle"
                local state = c.Default or false
                local cb = c.Callback or function() end

                local h = Create("Frame", {Size = UDim2.new(1,0,0,30), BackgroundTransparency = 1, BorderSizePixel = 0, Parent = sc})
                Create("TextLabel", {Text = name, Font = T.F, TextColor3 = T.Txt, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left, Size = UDim2.new(1,-50,1,0), BackgroundTransparency = 1, Parent = h})

                local bg = Create("Frame", {Size = UDim2.new(0,36,0,18), Position = UDim2.new(1,-36,0.5,-9), BackgroundColor3 = state and T.Accent or T.SurfL, BorderSizePixel = 0, Parent = h})
                Corner(bg, 9)
                Stroke(bg, T.Bdr, 1, 0.7)

                local ci = Create("Frame", {Size = UDim2.new(0,12,0,12), Position = state and UDim2.new(1,-15,0.5,-6) or UDim2.new(0,3,0.5,-6), BackgroundColor3 = Color3.new(1,1,1), BorderSizePixel = 0, Parent = bg})
                Corner(ci, 999)

                local btn = Create("TextButton", {Text = "", Size = UDim2.new(1,0,1,0), BackgroundTransparency = 1, BorderSizePixel = 0, Parent = h})

                local function upd()
                    if state then
                        Tween(bg, 0.3, {BackgroundColor3 = T.Accent})
                        Tween(ci, 0.3, {Position = UDim2.new(1,-15,0.5,-6)}, Enum.EasingStyle.Back)
                    else
                        Tween(bg, 0.3, {BackgroundColor3 = T.SurfL})
                        Tween(ci, 0.3, {Position = UDim2.new(0,3,0.5,-6)}, Enum.EasingStyle.Back)
                    end
                end

                btn.MouseButton1Click:Connect(function()
                    state = not state
                    upd()
                    pcall(cb, state)
                end)

                local obj = {Value = state}
                function obj:Set(v) state = v; self.Value = v; upd(); pcall(cb, state) end
                return obj
            end

            -- SLIDER
            function Section:AddSlider(c)
                c = c or {}
                local name = c.Name or "Slider"
                local mn = c.Min or 0
                local mx = c.Max or 100
                local inc = c.Increment or 1
                local val = c.Default or mn
                local cb = c.Callback or function() end

                local h = Create("Frame", {Size = UDim2.new(1,0,0,42), BackgroundTransparency = 1, BorderSizePixel = 0, Parent = sc})
                Create("TextLabel", {Text = name, Font = T.F, TextColor3 = T.Txt, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left, Size = UDim2.new(0.7,0,0,18), BackgroundTransparency = 1, Parent = h})
                local vl = Create("TextLabel", {Text = tostring(val), Font = T.FS, TextColor3 = T.Accent, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Right, Size = UDim2.new(0.3,0,0,18), Position = UDim2.new(0.7,0,0,0), BackgroundTransparency = 1, Parent = h})

                local sbg = Create("Frame", {Size = UDim2.new(1,0,0,6), Position = UDim2.new(0,0,0,26), BackgroundColor3 = T.SurfL, BorderSizePixel = 0, Parent = h})
                Corner(sbg, 3)

                local pct = (val - mn) / math.max(mx - mn, 1)
                local sfill = Create("Frame", {Size = UDim2.new(pct,0,1,0), BackgroundColor3 = T.Accent, BorderSizePixel = 0, Parent = sbg})
                Corner(sfill, 3)

                local knob = Create("Frame", {Size = UDim2.new(0,14,0,14), Position = UDim2.new(pct,-7,0.5,-7), BackgroundColor3 = Color3.new(1,1,1), BorderSizePixel = 0, ZIndex = 2, Parent = sbg})
                Corner(knob, 999)
                local knobDot = Create("Frame", {Size = UDim2.new(0,6,0,6), Position = UDim2.new(0.5,-3,0.5,-3), BackgroundColor3 = T.Accent, BorderSizePixel = 0, ZIndex = 3, Parent = knob})
                Corner(knobDot, 999)

                local sliding = false
                local sBtn = Create("TextButton", {Text = "", Size = UDim2.new(1,0,0,20), Position = UDim2.new(0,0,0,18), BackgroundTransparency = 1, BorderSizePixel = 0, Parent = h})

                local function updSlider(input)
                    local absX = sbg.AbsolutePosition.X
                    local absW = sbg.AbsoluteSize.X
                    if absW <= 0 then return end
                    local rel = math.clamp((input.Position.X - absX) / absW, 0, 1)
                    val = math.clamp(math.floor((mn + (mx - mn) * rel) / inc + 0.5) * inc, mn, mx)
                    local p = (val - mn) / math.max(mx - mn, 1)
                    Tween(sfill, 0.08, {Size = UDim2.new(p,0,1,0)}, Enum.EasingStyle.Linear)
                    Tween(knob, 0.08, {Position = UDim2.new(p,-7,0.5,-7)}, Enum.EasingStyle.Linear)
                    vl.Text = tostring(val)
                    pcall(cb, val)
                end

                sBtn.InputBegan:Connect(function(i)
                    if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
                        sliding = true
                        updSlider(i)
                    end
                end)
                sBtn.InputEnded:Connect(function(i)
                    if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
                        sliding = false
                    end
                end)
                UserInputService.InputChanged:Connect(function(i)
                    if sliding and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
                        updSlider(i)
                    end
                end)

                local obj = {Value = val}
                function obj:Set(v)
                    val = math.clamp(v, mn, mx)
                    self.Value = val
                    local p = (val - mn) / math.max(mx - mn, 1)
                    Tween(sfill, 0.25, {Size = UDim2.new(p,0,1,0)})
                    Tween(knob, 0.25, {Position = UDim2.new(p,-7,0.5,-7)})
                    vl.Text = tostring(val)
                    pcall(cb, val)
                end
                return obj
            end

            -- BUTTON
            function Section:AddButton(c)
                c = c or {}
                local name = c.Name or "Button"
                local cb = c.Callback or function() end

                local btn = Create("TextButton", {
                    Text = name, Font = T.FS, TextColor3 = T.Txt, TextSize = 12,
                    Size = UDim2.new(1,0,0,32),
                    BackgroundColor3 = T.SurfL, BorderSizePixel = 0,
                    AutoButtonColor = false, Parent = sc
                })
                Corner(btn, 6)
                Stroke(btn, T.Bdr, 1, 0.7)

                btn.MouseEnter:Connect(function() Tween(btn, 0.2, {BackgroundColor3 = T.Accent, TextColor3 = Color3.new(1,1,1)}) end)
                btn.MouseLeave:Connect(function() Tween(btn, 0.2, {BackgroundColor3 = T.SurfL, TextColor3 = T.Txt}) end)
                btn.MouseButton1Click:Connect(function() Ripple(btn); pcall(cb) end)
            end

            -- DROPDOWN
            function Section:AddDropdown(c)
                c = c or {}
                local name = c.Name or "Dropdown"
                local opts = c.Options or {}
                local sel = c.Default or (opts[1] or "")
                local cb = c.Callback or function() end
                local isOpen = false

                local h = Create("Frame", {Size = UDim2.new(1,0,0,52), BackgroundTransparency = 1, BorderSizePixel = 0, ClipsDescendants = true, Parent = sc})
                Create("TextLabel", {Text = name, Font = T.F, TextColor3 = T.Txt, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left, Size = UDim2.new(1,0,0,18), BackgroundTransparency = 1, Parent = h})

                local db = Create("TextButton", {
                    Text = "  " .. sel .. "  v", Font = T.F, TextColor3 = T.TxtD, TextSize = 12,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Size = UDim2.new(1,0,0,28), Position = UDim2.new(0,0,0,20),
                    BackgroundColor3 = T.SurfL, BorderSizePixel = 0,
                    AutoButtonColor = false, Parent = h
                })
                Corner(db, 6)
                Stroke(db, T.Bdr, 1, 0.7)

                local of = Create("Frame", {
                    Size = UDim2.new(1,0,0,0), Position = UDim2.new(0,0,0,50),
                    BackgroundColor3 = T.SurfL, BorderSizePixel = 0,
                    ClipsDescendants = true, Parent = h
                })
                Corner(of, 6)
                Stroke(of, T.Bdr, 1, 0.6)
                Create("UIListLayout", {SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0,1), Parent = of})

                local function refresh()
                    for _, ch in ipairs(of:GetChildren()) do
                        if ch:IsA("TextButton") then ch:Destroy() end
                    end
                    for _, opt in ipairs(opts) do
                        local ob = Create("TextButton", {
                            Text = "  " .. opt, Font = T.F,
                            TextColor3 = (opt == sel) and T.Accent or T.TxtD,
                            TextSize = 11, TextXAlignment = Enum.TextXAlignment.Left,
                            Size = UDim2.new(1,0,0,26),
                            BackgroundColor3 = T.SurfH, BackgroundTransparency = 1,
                            BorderSizePixel = 0, AutoButtonColor = false,
                            Parent = of
                        })
                        ob.MouseEnter:Connect(function() Tween(ob, 0.15, {BackgroundTransparency = 0.5}) end)
                        ob.MouseLeave:Connect(function() Tween(ob, 0.15, {BackgroundTransparency = 1}) end)
                        ob.MouseButton1Click:Connect(function()
                            sel = opt
                            db.Text = "  " .. sel .. "  v"
                            isOpen = false
                            Tween(h, 0.3, {Size = UDim2.new(1,0,0,52)}, Enum.EasingStyle.Quint)
                            Tween(of, 0.3, {Size = UDim2.new(1,0,0,0)}, Enum.EasingStyle.Quint)
                            refresh()
                            pcall(cb, sel)
                        end)
                    end
                end
                refresh()

                db.MouseButton1Click:Connect(function()
                    isOpen = not isOpen
                    local totalH = #opts * 27
                    if isOpen then
                        Tween(h, 0.3, {Size = UDim2.new(1,0,0,52 + totalH)}, Enum.EasingStyle.Quint)
                        Tween(of, 0.3, {Size = UDim2.new(1,0,0,totalH)}, Enum.EasingStyle.Quint)
                    else
                        Tween(h, 0.3, {Size = UDim2.new(1,0,0,52)}, Enum.EasingStyle.Quint)
                        Tween(of, 0.3, {Size = UDim2.new(1,0,0,0)}, Enum.EasingStyle.Quint)
                    end
                end)

                local obj = {Value = sel}
                function obj:Set(v) sel = v; self.Value = v; db.Text = "  " .. sel .. "  v"; refresh(); pcall(cb, sel) end
                return obj
            end

            -- KEYBIND
            function Section:AddKeybind(c)
                c = c or {}
                local name = c.Name or "Keybind"
                local key = c.Default or Enum.KeyCode.Unknown
                local cb = c.Callback or function() end
                local listening = false

                local h = Create("Frame", {Size = UDim2.new(1,0,0,30), BackgroundTransparency = 1, BorderSizePixel = 0, Parent = sc})
                Create("TextLabel", {Text = name, Font = T.F, TextColor3 = T.Txt, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left, Size = UDim2.new(1,-80,1,0), BackgroundTransparency = 1, Parent = h})

                local kbBtn = Create("TextButton", {
                    Text = key.Name or "None", Font = T.FS, TextColor3 = T.Accent, TextSize = 11,
                    Size = UDim2.new(0,70,0,24), Position = UDim2.new(1,-70,0.5,-12),
                    BackgroundColor3 = T.SurfL, BorderSizePixel = 0,
                    AutoButtonColor = false, Parent = h
                })
                Corner(kbBtn, 5)
                Stroke(kbBtn, T.Bdr, 1, 0.7)

                kbBtn.MouseButton1Click:Connect(function()
                    listening = true
                    kbBtn.Text = "..."
                    Tween(kbBtn, 0.2, {BackgroundColor3 = T.Accent, TextColor3 = Color3.new(1,1,1)})
                end)

                UserInputService.InputBegan:Connect(function(input, gpe)
                    if listening and input.UserInputType == Enum.UserInputType.Keyboard then
                        key = input.KeyCode
                        kbBtn.Text = key.Name
                        listening = false
                        Tween(kbBtn, 0.2, {BackgroundColor3 = T.SurfL, TextColor3 = T.Accent})
                    elseif not gpe and not listening and input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == key then
                        pcall(cb, key)
                    end
                end)

                local obj = {Value = key}
                function obj:Set(k) key = k; self.Value = k; kbBtn.Text = k.Name end
                return obj
            end

            -- LABEL
            function Section:AddLabel(text)
                local lbl = Create("TextLabel", {
                    Text = text or "", Font = T.F, TextColor3 = T.TxtD, TextSize = 11,
                    TextXAlignment = Enum.TextXAlignment.Left, TextWrapped = true,
                    Size = UDim2.new(1,0,0,18), BackgroundTransparency = 1, Parent = sc
                })
                local obj = {}
                function obj:Set(t) if lbl then lbl.Text = t end end
                return obj
            end

            -- TEXTBOX
            function Section:AddTextbox(c)
                c = c or {}
                local name = c.Name or "Input"
                local placeholder = c.Placeholder or "Type here..."
                local cb = c.Callback or function() end

                local h = Create("Frame", {Size = UDim2.new(1,0,0,48), BackgroundTransparency = 1, BorderSizePixel = 0, Parent = sc})
                Create("TextLabel", {Text = name, Font = T.F, TextColor3 = T.Txt, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left, Size = UDim2.new(1,0,0,18), BackgroundTransparency = 1, Parent = h})

                local tbox = Create("TextBox", {
                    Text = "", PlaceholderText = placeholder, PlaceholderColor3 = T.TxtM,
                    Font = T.F, TextColor3 = T.Txt, TextSize = 12,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Size = UDim2.new(1,0,0,26), Position = UDim2.new(0,0,0,20),
                    BackgroundColor3 = T.SurfL, BorderSizePixel = 0,
                    ClearTextOnFocus = false, Parent = h
                })
                Corner(tbox, 6)
                Stroke(tbox, T.Bdr, 1, 0.7)
                Pad(tbox, 0, 0, 8, 8)

                tbox.Focused:Connect(function() Tween(tbox, 0.2, {BackgroundColor3 = T.SurfH}) end)
                tbox.FocusLost:Connect(function(enter)
                    Tween(tbox, 0.2, {BackgroundColor3 = T.SurfL})
                    if enter then pcall(cb, tbox.Text) end
                end)

                local obj = {Value = ""}
                function obj:Set(v) tbox.Text = v; self.Value = v end
                tbox:GetPropertyChangedSignal("Text"):Connect(function() obj.Value = tbox.Text end)
                return obj
            end

            return Section
        end

        return Tab
    end

    Window.Library = self
    return Window
end

return Library
