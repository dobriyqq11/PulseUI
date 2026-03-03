--[[
    ██████╗ ██████╗ ██╗███████╗███╗   ███╗    ██╗   ██╗██╗
    ██╔══██╗██╔══██╗██║██╔════╝████╗ ████║    ██║   ██║██║
    ██████╔╝██████╔╝██║███████╗██╔████╔██║    ██║   ██║██║
    ██╔═══╝ ██╔══██╗██║╚════██║██║╚██╔╝██║    ██║   ██║██║
    ██║     ██║  ██║██║███████║██║ ╚═╝ ██║    ╚██████╔╝██║
    ╚═╝     ╚═╝  ╚═╝╚═╝╚══════╝╚═╝     ╚═╝     ╚═════╝ ╚═╝
    Prism UI Library v3.0 | "expensive" Style
    Two-column layout | Name+Description elements
]]

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local Player = Players.LocalPlayer

-- ══════════════════════════════════════
-- SAFE UTILITIES
-- ══════════════════════════════════════
local function SafeFont(name)
    local ok, f = pcall(function() return Enum.Font[name] end)
    return (ok and f) or Enum.Font.SourceSans
end

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
        if k ~= "Parent" then pcall(function() obj[k] = v end) end
    end
    if props and props.Parent then obj.Parent = props.Parent end
    return obj
end

local function Corner(p, r)
    if not p then return end
    return Create("UICorner", {CornerRadius = UDim.new(0, r or 6), Parent = p})
end

local function Stroke(p, c, t, tr)
    if not p then return end
    return Create("UIStroke", {Color = c or Color3.fromRGB(40, 40, 55), Thickness = t or 1, Transparency = tr or 0.5, Parent = p})
end

local function Pad(p, t, b, l, r)
    if not p then return end
    return Create("UIPadding", {
        PaddingTop = UDim.new(0, t or 0), PaddingBottom = UDim.new(0, b or 0),
        PaddingLeft = UDim.new(0, l or 0), PaddingRight = UDim.new(0, r or 0),
        Parent = p
    })
end

local function Ripple(btn)
    if not btn then return end
    local c = Create("Frame", {
        Size = UDim2.new(0,0,0,0), Position = UDim2.new(0.5,0,0.5,0),
        AnchorPoint = Vector2.new(0.5,0.5), BackgroundColor3 = Color3.new(1,1,1),
        BackgroundTransparency = 0.85, Parent = btn
    })
    if c then
        Corner(c, 999)
        Tween(c, 0.5, {Size = UDim2.new(2,0,2,0), BackgroundTransparency = 1})
        task.delay(0.5, function() if c and c.Parent then c:Destroy() end end)
    end
end

-- ══════════════════════════════════════
-- THEME (expensive-style dark)
-- ══════════════════════════════════════
local T = {
    Bg        = Color3.fromRGB(12, 12, 20),
    Sidebar   = Color3.fromRGB(16, 16, 26),
    TopBar    = Color3.fromRGB(14, 14, 22),
    Card      = Color3.fromRGB(20, 20, 32),
    CardHead  = Color3.fromRGB(24, 24, 38),
    Surface   = Color3.fromRGB(28, 28, 42),
    SurfH     = Color3.fromRGB(35, 35, 52),
    Accent    = Color3.fromRGB(100, 70, 235),
    AccentL   = Color3.fromRGB(130, 100, 255),
    Txt       = Color3.fromRGB(215, 215, 230),
    TxtD      = Color3.fromRGB(120, 120, 145),
    TxtM      = Color3.fromRGB(70, 70, 90),
    Bdr       = Color3.fromRGB(35, 35, 50),
    Ok        = Color3.fromRGB(70, 200, 120),
    Warn      = Color3.fromRGB(240, 170, 50),
    Err       = Color3.fromRGB(240, 65, 65),
    Badge     = Color3.fromRGB(30, 30, 46),
    F         = SafeFont("Gotham") or SafeFont("SourceSans"),
    FB        = SafeFont("GothamBold") or SafeFont("SourceSansBold"),
    FS        = SafeFont("GothamSemibold") or SafeFont("SourceSansSemibold"),
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
        Size = UDim2.new(1,0,0,68), BackgroundColor3 = T.Card,
        BackgroundTransparency = 0.05, ClipsDescendants = true, Parent = NHolder
    })
    if not n then return end
    Corner(n, 8); Stroke(n, ac, 1, 0.5)
    Create("Frame", {Size = UDim2.new(0,3,1,-12), Position = UDim2.new(0,8,0,6), BackgroundColor3 = ac, BorderSizePixel = 0, Parent = n})
    Create("TextLabel", {Text = title, Font = T.FB, TextColor3 = T.Txt, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left, Size = UDim2.new(1,-30,0,18), Position = UDim2.new(0,22,0,10), BackgroundTransparency = 1, Parent = n})
    Create("TextLabel", {Text = text, Font = T.F, TextColor3 = T.TxtD, TextSize = 11, TextXAlignment = Enum.TextXAlignment.Left, TextWrapped = true, Size = UDim2.new(1,-30,0,26), Position = UDim2.new(0,22,0,30), BackgroundTransparency = 1, Parent = n})
    local pb = Create("Frame", {Size = UDim2.new(1,-16,0,2), Position = UDim2.new(0,8,1,-6), BackgroundColor3 = T.Surface, BorderSizePixel = 0, Parent = n})
    local pf = Create("Frame", {Size = UDim2.new(1,0,1,0), BackgroundColor3 = ac, BorderSizePixel = 0, Parent = pb})
    Corner(pb, 2); Corner(pf, 2)
    n.Position = UDim2.new(1,50,0,0); n.BackgroundTransparency = 1
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

-- ══════════════════════════════════════
-- CREATE WINDOW (expensive-style)
-- ══════════════════════════════════════
function Library:CreateWindow(cfg)
    cfg = cfg or {}
    local wTitle = cfg.Title or "expensive"
    local wSize = cfg.Size or UDim2.new(0, 750, 0, 480)
    local wUser = cfg.User or Player.Name
    local wLogo = cfg.Logo or ""

    -- ScreenGui
    local sg = Create("ScreenGui", {
        Name = "PrismUI_" .. tostring(math.random(100000,999999)),
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    })
    pcall(function() if syn and syn.protect_gui then syn.protect_gui(sg) sg.Parent = game:GetService("CoreGui") end end)
    if not sg.Parent then pcall(function() sg.Parent = game:GetService("CoreGui") end) end
    if not sg.Parent then pcall(function() sg.Parent = Player:WaitForChild("PlayerGui") end) end
    if not sg.Parent then pcall(function() if gethui then sg.Parent = gethui() end end) end

    -- Notifications
    NHolder = Create("Frame", {Size = UDim2.new(0,300,1,0), Position = UDim2.new(1,-320,0,0), BackgroundTransparency = 1, Parent = sg})
    Create("UIListLayout", {SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0,8), VerticalAlignment = Enum.VerticalAlignment.Bottom, Parent = NHolder})
    Pad(NHolder, 0, 20, 0, 0)

    -- Main container
    local main = Create("Frame", {
        Name = "Main", Size = UDim2.new(0,0,0,0),
        Position = UDim2.new(0.5,0,0.5,0), AnchorPoint = Vector2.new(0.5,0.5),
        BackgroundColor3 = T.Bg, BorderSizePixel = 0, ClipsDescendants = true,
        Parent = sg
    })
    Corner(main, 12)
    Stroke(main, T.Bdr, 1, 0.3)

    -- Open animation
    task.defer(function()
        Tween(main, 0.6, {Size = wSize}, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
    end)

    -- ══════════════════════════════════
    -- SIDEBAR (left panel)
    -- ══════════════════════════════════
    local sidebarWidth = 155
    local sidebar = Create("Frame", {
        Name = "Sidebar", Size = UDim2.new(0, sidebarWidth, 1, 0),
        BackgroundColor3 = T.Sidebar, BorderSizePixel = 0, Parent = main
    })

    -- Logo area
    local logoFrame = Create("Frame", {
        Size = UDim2.new(1, 0, 0, 55), BackgroundTransparency = 1,
        BorderSizePixel = 0, Parent = sidebar
    })

    -- Accent dot for logo
    local logoDot = Create("Frame", {
        Size = UDim2.new(0, 10, 0, 10), Position = UDim2.new(0, 18, 0.5, -5),
        BackgroundColor3 = T.Accent, BorderSizePixel = 0, Parent = logoFrame
    })
    Corner(logoDot, 999)

    Create("TextLabel", {
        Text = wTitle, Font = T.FB, TextColor3 = T.AccentL, TextSize = 15,
        TextXAlignment = Enum.TextXAlignment.Left,
        Size = UDim2.new(1, -45, 1, 0), Position = UDim2.new(0, 36, 0, 0),
        BackgroundTransparency = 1, Parent = logoFrame
    })

    -- Separator under logo
    Create("Frame", {
        Size = UDim2.new(1, -24, 0, 1), Position = UDim2.new(0, 12, 0, 55),
        BackgroundColor3 = T.Bdr, BackgroundTransparency = 0.5,
        BorderSizePixel = 0, Parent = sidebar
    })

    -- Tab buttons container
    local tabBtnContainer = Create("Frame", {
        Size = UDim2.new(1, 0, 1, -120),
        Position = UDim2.new(0, 0, 0, 62),
        BackgroundTransparency = 1, BorderSizePixel = 0, Parent = sidebar
    })
    Create("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 2),
        Parent = tabBtnContainer
    })
    Pad(tabBtnContainer, 4, 4, 8, 8)

    -- User info at bottom
    local userFrame = Create("Frame", {
        Size = UDim2.new(1, 0, 0, 50),
        Position = UDim2.new(0, 0, 1, -55),
        BackgroundTransparency = 1, BorderSizePixel = 0, Parent = sidebar
    })
    -- Separator above user
    Create("Frame", {
        Size = UDim2.new(1, -24, 0, 1), Position = UDim2.new(0, 12, 0, 0),
        BackgroundColor3 = T.Bdr, BackgroundTransparency = 0.5,
        BorderSizePixel = 0, Parent = userFrame
    })

    -- User avatar circle
    local avatarFrame = Create("Frame", {
        Size = UDim2.new(0, 28, 0, 28), Position = UDim2.new(0, 16, 0, 14),
        BackgroundColor3 = T.Accent, BorderSizePixel = 0, Parent = userFrame
    })
    Corner(avatarFrame, 999)
    Create("TextLabel", {
        Text = string.sub(wUser, 1, 1):upper(), Font = T.FB, TextColor3 = Color3.new(1,1,1),
        TextSize = 13, Size = UDim2.new(1,0,1,0), BackgroundTransparency = 1, Parent = avatarFrame
    })

    -- User name + date
    Create("TextLabel", {
        Text = wUser, Font = T.FS, TextColor3 = T.Txt, TextSize = 11,
        TextXAlignment = Enum.TextXAlignment.Left,
        Size = UDim2.new(1, -55, 0, 14), Position = UDim2.new(0, 52, 0, 12),
        BackgroundTransparency = 1, Parent = userFrame
    })
    Create("TextLabel", {
        Text = os.date("%d.%m.%Y"), Font = T.F, TextColor3 = T.TxtM, TextSize = 10,
        TextXAlignment = Enum.TextXAlignment.Left,
        Size = UDim2.new(1, -55, 0, 14), Position = UDim2.new(0, 52, 0, 28),
        BackgroundTransparency = 1, Parent = userFrame
    })

    -- Sidebar right border
    Create("Frame", {
        Size = UDim2.new(0, 1, 1, 0), Position = UDim2.new(1, 0, 0, 0),
        BackgroundColor3 = T.Bdr, BackgroundTransparency = 0.5,
        BorderSizePixel = 0, Parent = sidebar
    })

    -- ══════════════════════════════════
    -- TOP BAR
    -- ══════════════════════════════════
    local topBarHeight = 45
    local topBar = Create("Frame", {
        Name = "TopBar",
        Size = UDim2.new(1, -sidebarWidth, 0, topBarHeight),
        Position = UDim2.new(0, sidebarWidth, 0, 0),
        BackgroundColor3 = T.TopBar, BorderSizePixel = 0, Parent = main
    })
    -- Bottom separator
    Create("Frame", {
        Size = UDim2.new(1, 0, 0, 1), Position = UDim2.new(0, 0, 1, 0),
        BackgroundColor3 = T.Bdr, BackgroundTransparency = 0.5,
        BorderSizePixel = 0, Parent = topBar
    })

    -- Active tab title in top bar
    local topTabTitle = Create("TextLabel", {
        Text = "Tab", Font = T.FB, TextColor3 = T.Txt, TextSize = 15,
        TextXAlignment = Enum.TextXAlignment.Left,
        Size = UDim2.new(0, 200, 1, 0), Position = UDim2.new(0, 20, 0, 0),
        BackgroundTransparency = 1, Parent = topBar
    })

    -- Search box
    local searchFrame = Create("Frame", {
        Size = UDim2.new(0, 160, 0, 28),
        Position = UDim2.new(1, -185, 0.5, -14),
        BackgroundColor3 = T.Surface, BorderSizePixel = 0, Parent = topBar
    })
    Corner(searchFrame, 6)
    Create("TextLabel", {
        Text = "Search", Font = T.F, TextColor3 = T.TxtM, TextSize = 11,
        Size = UDim2.new(1,-30,1,0), Position = UDim2.new(0,10,0,0),
        TextXAlignment = Enum.TextXAlignment.Left,
        BackgroundTransparency = 1, Parent = searchFrame
    })
    Create("TextLabel", {
        Text = "Q", Font = T.F, TextColor3 = T.TxtM, TextSize = 12,
        Size = UDim2.new(0,20,1,0), Position = UDim2.new(1,-25,0,0),
        BackgroundTransparency = 1, Parent = searchFrame
    })

    -- ══════════════════════════════════
    -- CONTENT AREA (two columns)
    -- ══════════════════════════════════
    local contentHolder = Create("Frame", {
        Name = "ContentArea",
        Size = UDim2.new(1, -(sidebarWidth + 16), 1, -(topBarHeight + 8)),
        Position = UDim2.new(0, sidebarWidth + 8, 0, topBarHeight + 4),
        BackgroundTransparency = 1, BorderSizePixel = 0, Parent = main
    })

    local tabs = {}
    local activeTab = nil

    -- ══════════════════════════════════
    -- DRAGGING
    -- ══════════════════════════════════
    local dragging, dragStart, startPos = false, nil, nil
    topBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true; dragStart = input.Position; startPos = main.Position
        end
    end)
    topBar.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local d = input.Position - dragStart
            Tween(main, 0.08, {Position = UDim2.new(startPos.X.Scale, startPos.X.Offset+d.X, startPos.Y.Scale, startPos.Y.Offset+d.Y)}, Enum.EasingStyle.Linear)
        end
    end)

    -- ══════════════════════════════════
    -- WINDOW OBJECT
    -- ══════════════════════════════════
    local Window = {}
    Window.ScreenGui = sg

    function Window:AddTab(cfg2)
        cfg2 = cfg2 or {}
        local tabName = cfg2.Name or "Tab"
        local tabIcon = cfg2.Icon or ""
        local displayText = tabName
        if tabIcon ~= "" then displayText = "  " .. tabIcon .. "  " .. tabName end

        -- Tab button in sidebar
        local tabBtn = Create("TextButton", {
            Text = displayText, Font = T.FS, TextColor3 = T.TxtD, TextSize = 12,
            TextXAlignment = Enum.TextXAlignment.Left,
            Size = UDim2.new(1, 0, 0, 34),
            BackgroundColor3 = T.Accent, BackgroundTransparency = 1,
            BorderSizePixel = 0, AutoButtonColor = false, Parent = tabBtnContainer
        })
        Corner(tabBtn, 6)

        -- Active accent bar (left edge)
        local accentBar = Create("Frame", {
            Size = UDim2.new(0, 3, 0.6, 0), Position = UDim2.new(0, 0, 0.2, 0),
            BackgroundColor3 = T.Accent, BackgroundTransparency = 1,
            BorderSizePixel = 0, Parent = tabBtn
        })
        Corner(accentBar, 2)

        -- Tab page: two-column scrollable area
        local tabPage = Create("ScrollingFrame", {
            Size = UDim2.new(1,0,1,0), BackgroundTransparency = 1,
            ScrollBarThickness = 2, ScrollBarImageColor3 = T.Accent,
            BorderSizePixel = 0, CanvasSize = UDim2.new(0,0,0,0),
            Visible = false, Parent = contentHolder
        })
        pcall(function() tabPage.AutomaticCanvasSize = Enum.AutomaticSize.Y end)

        -- Two columns
        local colLeft = Create("Frame", {
            Size = UDim2.new(0.5, -4, 0, 0), Position = UDim2.new(0, 0, 0, 0),
            BackgroundTransparency = 1, BorderSizePixel = 0, Parent = tabPage
        })
        pcall(function() colLeft.AutomaticSize = Enum.AutomaticSize.Y end)
        Create("UIListLayout", {SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 8), Parent = colLeft})

        local colRight = Create("Frame", {
            Size = UDim2.new(0.5, -4, 0, 0), Position = UDim2.new(0.5, 4, 0, 0),
            BackgroundTransparency = 1, BorderSizePixel = 0, Parent = tabPage
        })
        pcall(function() colRight.AutomaticSize = Enum.AutomaticSize.Y end)
        Create("UIListLayout", {SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 8), Parent = colRight})

        local td = {Button = tabBtn, Page = tabPage, AccentBar = accentBar, Name = tabName, ColLeft = colLeft, ColRight = colRight}
        table.insert(tabs, td)

        local function selectTab()
            for _, t2 in ipairs(tabs) do
                t2.Page.Visible = false
                Tween(t2.Button, 0.25, {BackgroundTransparency = 1, TextColor3 = T.TxtD})
                Tween(t2.AccentBar, 0.25, {BackgroundTransparency = 1})
            end
            td.Page.Visible = true
            topTabTitle.Text = tabName
            Tween(tabBtn, 0.25, {BackgroundTransparency = 0.88, TextColor3 = T.AccentL})
            Tween(accentBar, 0.25, {BackgroundTransparency = 0})
            activeTab = td
        end

        tabBtn.MouseButton1Click:Connect(selectTab)
        tabBtn.MouseEnter:Connect(function()
            if activeTab ~= td then Tween(tabBtn, 0.2, {BackgroundTransparency = 0.92, TextColor3 = T.Txt}) end
        end)
        tabBtn.MouseLeave:Connect(function()
            if activeTab ~= td then Tween(tabBtn, 0.2, {BackgroundTransparency = 1, TextColor3 = T.TxtD}) end
        end)
        if #tabs == 1 then selectTab() end

        -- ══════════════════════════════════
        -- TAB OBJECT
        -- ══════════════════════════════════
        local Tab = {}
        local sectionIndex = 0

        function Tab:AddSection(cfg3)
            cfg3 = cfg3 or {}
            local secName = cfg3.Name or "Section"
            local secIcon = cfg3.Icon or ""
            local secBind = cfg3.Bind or ""
            local side = cfg3.Side or "Left"

            sectionIndex = sectionIndex + 1
            local parentCol = (side == "Right") and colRight or colLeft

            -- Section card
            local card = Create("Frame", {
                Size = UDim2.new(1, 0, 0, 0),
                BackgroundColor3 = T.Card, BorderSizePixel = 0, Parent = parentCol
            })
            pcall(function() card.AutomaticSize = Enum.AutomaticSize.Y end)
            Corner(card, 10)
            Stroke(card, T.Bdr, 1, 0.6)

            -- Card header
            local header = Create("Frame", {
                Size = UDim2.new(1, 0, 0, 38),
                BackgroundColor3 = T.CardHead, BorderSizePixel = 0, Parent = card
            })
            Corner(header, 10)
            -- Bottom fill to square off bottom corners of header
            Create("Frame", {
                Size = UDim2.new(1, 0, 0, 10), Position = UDim2.new(0, 0, 1, -10),
                BackgroundColor3 = T.CardHead, BorderSizePixel = 0, Parent = header
            })

            -- Icon dot in header
            if secIcon ~= "" then
                local iconLbl = Create("TextLabel", {
                    Text = secIcon, Font = T.F, TextColor3 = T.Accent, TextSize = 14,
                    Size = UDim2.new(0, 20, 1, 0), Position = UDim2.new(0, 12, 0, 0),
                    BackgroundTransparency = 1, Parent = header
                })
            end

            -- Section title
            Create("TextLabel", {
                Text = secName, Font = T.FB, TextColor3 = T.Txt, TextSize = 13,
                TextXAlignment = Enum.TextXAlignment.Left,
                Size = UDim2.new(1, -100, 1, 0),
                Position = UDim2.new(0, secIcon ~= "" and 34 or 14, 0, 0),
                BackgroundTransparency = 1, Parent = header
            })

            -- Keybind/status badge
            if secBind ~= "" then
                local badge = Create("Frame", {
                    Size = UDim2.new(0, 36, 0, 22), Position = UDim2.new(1, -50, 0.5, -11),
                    BackgroundColor3 = T.Badge, BorderSizePixel = 0, Parent = header
                })
                Corner(badge, 5)
                Create("TextLabel", {
                    Text = secBind, Font = T.FS, TextColor3 = T.TxtD, TextSize = 11,
                    Size = UDim2.new(1,0,1,0), BackgroundTransparency = 1, Parent = badge
                })
            end

            -- Section content
            local sc = Create("Frame", {
                Size = UDim2.new(1, 0, 0, 0), Position = UDim2.new(0, 0, 0, 38),
                BackgroundTransparency = 1, BorderSizePixel = 0, Parent = card
            })
            pcall(function() sc.AutomaticSize = Enum.AutomaticSize.Y end)
            Create("UIListLayout", {SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 2), Parent = sc})
            Pad(sc, 4, 10, 12, 12)

            -- ══════════════════════════════════
            -- SECTION OBJECT
            -- ══════════════════════════════════
            local Section = {}

            -- Helper: element row with name + optional description
            local function MakeRow(parent, name, desc, height)
                height = height or 36
                if desc and desc ~= "" then height = height + 14 end
                local row = Create("Frame", {
                    Size = UDim2.new(1, 0, 0, height),
                    BackgroundTransparency = 1, BorderSizePixel = 0, Parent = parent
                })
                Create("TextLabel", {
                    Text = name or "", Font = T.FS, TextColor3 = T.Txt, TextSize = 12,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Size = UDim2.new(0.65, 0, 0, 16), Position = UDim2.new(0, 0, 0, 4),
                    BackgroundTransparency = 1, Parent = row
                })
                if desc and desc ~= "" then
                    Create("TextLabel", {
                        Text = desc, Font = T.F, TextColor3 = T.TxtM, TextSize = 10,
                        TextXAlignment = Enum.TextXAlignment.Left, TextWrapped = true,
                        Size = UDim2.new(0.6, 0, 0, 24), Position = UDim2.new(0, 0, 0, 20),
                        BackgroundTransparency = 1, Parent = row
                    })
                end
                -- Separator at bottom
                Create("Frame", {
                    Size = UDim2.new(1, 0, 0, 1), Position = UDim2.new(0, 0, 1, -1),
                    BackgroundColor3 = T.Bdr, BackgroundTransparency = 0.7,
                    BorderSizePixel = 0, Parent = row
                })
                return row
            end

            -- TOGGLE (with eye/settings icons)
            function Section:AddToggle(c)
                c = c or {}
                local name = c.Name or "Toggle"
                local desc = c.Description or ""
                local state = c.Default or false
                local cb = c.Callback or function() end

                local h = MakeRow(sc, name, desc, 36)

                -- Settings gear icon
                local gear = Create("TextButton", {
                    Text = "@", Font = T.F, TextColor3 = T.TxtM, TextSize = 12,
                    Size = UDim2.new(0,20,0,20), Position = UDim2.new(1,-60,0,4),
                    BackgroundTransparency = 1, BorderSizePixel = 0, Parent = h
                })

                -- Toggle switch
                local bg = Create("Frame", {
                    Size = UDim2.new(0,34,0,18), Position = UDim2.new(1,-34,0,4),
                    BackgroundColor3 = state and T.Accent or T.Surface,
                    BorderSizePixel = 0, Parent = h
                })
                Corner(bg, 9)

                local ci = Create("Frame", {
                    Size = UDim2.new(0,12,0,12),
                    Position = state and UDim2.new(1,-15,0.5,-6) or UDim2.new(0,3,0.5,-6),
                    BackgroundColor3 = Color3.new(1,1,1), BorderSizePixel = 0, Parent = bg
                })
                Corner(ci, 999)

                local btn = Create("TextButton", {Text = "", Size = UDim2.new(1,0,1,0), BackgroundTransparency = 1, BorderSizePixel = 0, Parent = h})

                local function upd()
                    if state then
                        Tween(bg, 0.3, {BackgroundColor3 = T.Accent})
                        Tween(ci, 0.3, {Position = UDim2.new(1,-15,0.5,-6)}, Enum.EasingStyle.Back)
                    else
                        Tween(bg, 0.3, {BackgroundColor3 = T.Surface})
                        Tween(ci, 0.3, {Position = UDim2.new(0,3,0.5,-6)}, Enum.EasingStyle.Back)
                    end
                end
                btn.MouseButton1Click:Connect(function() state = not state; upd(); pcall(cb, state) end)

                local obj = {Value = state}
                function obj:Set(v) state = v; self.Value = v; upd(); pcall(cb, state) end
                return obj
            end

            -- SLIDER
            function Section:AddSlider(c)
                c = c or {}
                local name = c.Name or "Slider"
                local desc = c.Description or ""
                local mn, mx = c.Min or 0, c.Max or 100
                local inc = c.Increment or 1
                local val = c.Default or mn
                local cb = c.Callback or function() end

                local baseH = (desc ~= "" and desc) and 55 or 46
                local h = Create("Frame", {Size = UDim2.new(1,0,0,baseH), BackgroundTransparency = 1, BorderSizePixel = 0, Parent = sc})
                Create("TextLabel", {Text = name, Font = T.FS, TextColor3 = T.Txt, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left, Size = UDim2.new(0.65,0,0,16), Position = UDim2.new(0,0,0,4), BackgroundTransparency = 1, Parent = h})
                if desc ~= "" then
                    Create("TextLabel", {Text = desc, Font = T.F, TextColor3 = T.TxtM, TextSize = 10, TextXAlignment = Enum.TextXAlignment.Left, TextWrapped = true, Size = UDim2.new(0.6,0,0,14), Position = UDim2.new(0,0,0,20), BackgroundTransparency = 1, Parent = h})
                end

                local vl = Create("TextLabel", {Text = tostring(val), Font = T.FS, TextColor3 = T.AccentL, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Right, Size = UDim2.new(0.35,0,0,16), Position = UDim2.new(0.65,0,0,4), BackgroundTransparency = 1, Parent = h})

                local sliderY = baseH - 14
                local sbg = Create("Frame", {Size = UDim2.new(1,0,0,5), Position = UDim2.new(0,0,0,sliderY), BackgroundColor3 = T.Surface, BorderSizePixel = 0, Parent = h})
                Corner(sbg, 3)
                local pct = (val - mn) / math.max(mx - mn, 1)
                local sfill = Create("Frame", {Size = UDim2.new(pct,0,1,0), BackgroundColor3 = T.Accent, BorderSizePixel = 0, Parent = sbg})
                Corner(sfill, 3)
                local knob = Create("Frame", {Size = UDim2.new(0,12,0,12), Position = UDim2.new(pct,-6,0.5,-6), BackgroundColor3 = T.AccentL, BorderSizePixel = 0, ZIndex = 2, Parent = sbg})
                Corner(knob, 999)

                local sliding = false
                local sBtn = Create("TextButton", {Text = "", Size = UDim2.new(1,0,0,18), Position = UDim2.new(0,0,0,sliderY-6), BackgroundTransparency = 1, BorderSizePixel = 0, Parent = h})

                local function updS(input)
                    local absX = sbg.AbsolutePosition.X
                    local absW = sbg.AbsoluteSize.X
                    if absW <= 0 then return end
                    local rel = math.clamp((input.Position.X - absX) / absW, 0, 1)
                    val = math.clamp(math.floor((mn + (mx-mn)*rel) / inc + 0.5) * inc, mn, mx)
                    local p = (val-mn) / math.max(mx-mn,1)
                    Tween(sfill, 0.08, {Size = UDim2.new(p,0,1,0)}, Enum.EasingStyle.Linear)
                    Tween(knob, 0.08, {Position = UDim2.new(p,-6,0.5,-6)}, Enum.EasingStyle.Linear)
                    vl.Text = tostring(val); pcall(cb, val)
                end

                sBtn.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then sliding = true; updS(i) end end)
                sBtn.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then sliding = false end end)
                UserInputService.InputChanged:Connect(function(i) if sliding and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then updS(i) end end)

                -- Separator
                Create("Frame", {Size = UDim2.new(1,0,0,1), Position = UDim2.new(0,0,1,-1), BackgroundColor3 = T.Bdr, BackgroundTransparency = 0.7, BorderSizePixel = 0, Parent = h})

                local obj = {Value = val}
                function obj:Set(v)
                    val = math.clamp(v,mn,mx); self.Value = val
                    local p = (val-mn)/math.max(mx-mn,1)
                    Tween(sfill,0.25,{Size=UDim2.new(p,0,1,0)}); Tween(knob,0.25,{Position=UDim2.new(p,-6,0.5,-6)})
                    vl.Text = tostring(val); pcall(cb,val)
                end
                return obj
            end

            -- BUTTON
            function Section:AddButton(c)
                c = c or {}
                local name = c.Name or "Button"
                local desc = c.Description or ""
                local cb = c.Callback or function() end

                local bh = (desc ~= "") and 44 or 34
                local btn = Create("TextButton", {
                    Text = "", Size = UDim2.new(1,0,0,bh),
                    BackgroundColor3 = T.Surface, BorderSizePixel = 0,
                    AutoButtonColor = false, Parent = sc
                })
                Corner(btn, 6)
                Create("TextLabel", {
                    Text = name, Font = T.FS, TextColor3 = T.Txt, TextSize = 12,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Size = UDim2.new(1,-20,0,16), Position = UDim2.new(0,10,0,5),
                    BackgroundTransparency = 1, Parent = btn
                })
                if desc ~= "" then
                    Create("TextLabel", {
                        Text = desc, Font = T.F, TextColor3 = T.TxtM, TextSize = 10,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        Size = UDim2.new(1,-20,0,14), Position = UDim2.new(0,10,0,22),
                        BackgroundTransparency = 1, Parent = btn
                    })
                end
                btn.MouseEnter:Connect(function() Tween(btn, 0.2, {BackgroundColor3 = T.Accent}) end)
                btn.MouseLeave:Connect(function() Tween(btn, 0.2, {BackgroundColor3 = T.Surface}) end)
                btn.MouseButton1Click:Connect(function() Ripple(btn); pcall(cb) end)
            end

            -- DROPDOWN
            function Section:AddDropdown(c)
                c = c or {}
                local name = c.Name or "Dropdown"
                local desc = c.Description or ""
                local opts = c.Options or {}
                local sel = c.Default or (opts[1] or "")
                local cb = c.Callback or function() end
                local isOpen = false

                local closedH = (desc ~= "") and 50 or 36
                local h = Create("Frame", {Size = UDim2.new(1,0,0,closedH), BackgroundTransparency = 1, BorderSizePixel = 0, ClipsDescendants = true, Parent = sc})
                Create("TextLabel", {Text = name, Font = T.FS, TextColor3 = T.Txt, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left, Size = UDim2.new(0.5,0,0,16), Position = UDim2.new(0,0,0,4), BackgroundTransparency = 1, Parent = h})
                if desc ~= "" then
                    Create("TextLabel", {Text = desc, Font = T.F, TextColor3 = T.TxtM, TextSize = 10, TextXAlignment = Enum.TextXAlignment.Left, TextWrapped = true, Size = UDim2.new(0.5,0,0,14), Position = UDim2.new(0,0,0,20), BackgroundTransparency = 1, Parent = h})
                end

                -- Dropdown button (right side)
                local db = Create("TextButton", {
                    Text = sel, Font = T.F, TextColor3 = T.TxtD, TextSize = 11,
                    Size = UDim2.new(0.42, 0, 0, 26), Position = UDim2.new(0.56, 0, 0, 2),
                    BackgroundColor3 = T.Surface, BorderSizePixel = 0,
                    AutoButtonColor = false, Parent = h
                })
                Corner(db, 5)

                local of = Create("Frame", {
                    Size = UDim2.new(0.42, 0, 0, 0), Position = UDim2.new(0.56, 0, 0, closedH),
                    BackgroundColor3 = T.Surface, BorderSizePixel = 0,
                    ClipsDescendants = true, Parent = h
                })
                Corner(of, 5); Stroke(of, T.Bdr, 1, 0.6)
                Create("UIListLayout", {SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0,1), Parent = of})

                local function refresh()
                    for _, ch in ipairs(of:GetChildren()) do if ch:IsA("TextButton") then ch:Destroy() end end
                    for _, opt in ipairs(opts) do
                        local ob = Create("TextButton", {
                            Text = "  " .. opt, Font = T.F,
                            TextColor3 = (opt == sel) and T.AccentL or T.TxtD,
                            TextSize = 11, TextXAlignment = Enum.TextXAlignment.Left,
                            Size = UDim2.new(1,0,0,26),
                            BackgroundColor3 = T.SurfH, BackgroundTransparency = 1,
                            BorderSizePixel = 0, AutoButtonColor = false, Parent = of
                        })
                        ob.MouseEnter:Connect(function() Tween(ob, 0.15, {BackgroundTransparency = 0.5}) end)
                        ob.MouseLeave:Connect(function() Tween(ob, 0.15, {BackgroundTransparency = 1}) end)
                        ob.MouseButton1Click:Connect(function()
                            sel = opt; db.Text = sel; isOpen = false
                            Tween(h, 0.3, {Size = UDim2.new(1,0,0,closedH)}, Enum.EasingStyle.Quint)
                            Tween(of, 0.3, {Size = UDim2.new(0.42,0,0,0)}, Enum.EasingStyle.Quint)
                            refresh(); pcall(cb, sel)
                        end)
                    end
                end
                refresh()

                db.MouseButton1Click:Connect(function()
                    isOpen = not isOpen
                    local totalH = #opts * 27
                    if isOpen then
                        Tween(h, 0.3, {Size = UDim2.new(1,0,0,closedH + totalH + 4)}, Enum.EasingStyle.Quint)
                        Tween(of, 0.3, {Size = UDim2.new(0.42,0,0,totalH)}, Enum.EasingStyle.Quint)
                    else
                        Tween(h, 0.3, {Size = UDim2.new(1,0,0,closedH)}, Enum.EasingStyle.Quint)
                        Tween(of, 0.3, {Size = UDim2.new(0.42,0,0,0)}, Enum.EasingStyle.Quint)
                    end
                end)

                -- Separator
                Create("Frame", {Size = UDim2.new(1,0,0,1), Position = UDim2.new(0,0,0,closedH-1), BackgroundColor3 = T.Bdr, BackgroundTransparency = 0.7, BorderSizePixel = 0, Parent = h})

                local obj = {Value = sel}
                function obj:Set(v) sel = v; self.Value = v; db.Text = sel; refresh(); pcall(cb, sel) end
                return obj
            end

            -- KEYBIND
            function Section:AddKeybind(c)
                c = c or {}
                local name = c.Name or "Keybind"
                local desc = c.Description or ""
                local key = c.Default or Enum.KeyCode.Unknown
                local cb = c.Callback or function() end
                local listening = false

                local h = MakeRow(sc, name, desc, 36)

                local kbBtn = Create("TextButton", {
                    Text = key.Name or "None", Font = T.FS, TextColor3 = T.AccentL, TextSize = 11,
                    Size = UDim2.new(0,60,0,22), Position = UDim2.new(1,-60,0,4),
                    BackgroundColor3 = T.Surface, BorderSizePixel = 0,
                    AutoButtonColor = false, Parent = h
                })
                Corner(kbBtn, 5)

                kbBtn.MouseButton1Click:Connect(function()
                    listening = true; kbBtn.Text = "..."
                    Tween(kbBtn, 0.2, {BackgroundColor3 = T.Accent, TextColor3 = Color3.new(1,1,1)})
                end)

                UserInputService.InputBegan:Connect(function(input, gpe)
                    if listening and input.UserInputType == Enum.UserInputType.Keyboard then
                        key = input.KeyCode; kbBtn.Text = key.Name; listening = false
                        Tween(kbBtn, 0.2, {BackgroundColor3 = T.Surface, TextColor3 = T.AccentL})
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
                local desc = c.Description or ""
                local placeholder = c.Placeholder or "Type..."
                local cb = c.Callback or function() end

                local closedH = (desc ~= "") and 50 or 36
                local h = Create("Frame", {Size = UDim2.new(1,0,0,closedH), BackgroundTransparency = 1, BorderSizePixel = 0, Parent = sc})
                Create("TextLabel", {Text = name, Font = T.FS, TextColor3 = T.Txt, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left, Size = UDim2.new(0.5,0,0,16), Position = UDim2.new(0,0,0,4), BackgroundTransparency = 1, Parent = h})
                if desc ~= "" then
                    Create("TextLabel", {Text = desc, Font = T.F, TextColor3 = T.TxtM, TextSize = 10, TextXAlignment = Enum.TextXAlignment.Left, Size = UDim2.new(0.5,0,0,14), Position = UDim2.new(0,0,0,20), BackgroundTransparency = 1, Parent = h})
                end

                local tbox = Create("TextBox", {
                    Text = "", PlaceholderText = placeholder, PlaceholderColor3 = T.TxtM,
                    Font = T.F, TextColor3 = T.Txt, TextSize = 11,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Size = UDim2.new(0.42,0,0,24), Position = UDim2.new(0.56,0,0,3),
                    BackgroundColor3 = T.Surface, BorderSizePixel = 0,
                    ClearTextOnFocus = false, Parent = h
                })
                Corner(tbox, 5); Pad(tbox, 0, 0, 8, 8)
                Create("Frame", {Size = UDim2.new(1,0,0,1), Position = UDim2.new(0,0,1,-1), BackgroundColor3 = T.Bdr, BackgroundTransparency = 0.7, BorderSizePixel = 0, Parent = h})

                tbox.Focused:Connect(function() Tween(tbox, 0.2, {BackgroundColor3 = T.SurfH}) end)
                tbox.FocusLost:Connect(function(enter) Tween(tbox, 0.2, {BackgroundColor3 = T.Surface}); if enter then pcall(cb, tbox.Text) end end)

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
