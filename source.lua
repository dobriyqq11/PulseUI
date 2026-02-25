--[=[
    PulseUI — Remastered (Complete)
    Acrylic Glass Style • Smooth Animations • Full Element Set
    
    Elements: Section, Label, Button, Toggle, Slider, Dropdown, Keybind, Input
    Features: Notification stacking, Minimize (RightShift), SetTitle, Destroy
]=]

local TweenService     = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService       = game:GetService("RunService")
local Players          = game:GetService("Players")
local CoreGui          = game:GetService("CoreGui")

local PulseUI = {}

PulseUI.Theme = {
    Background   = Color3.fromRGB(20, 20, 25),
    AcrylicTint  = Color3.fromRGB(30, 30, 40),
    Accent       = Color3.fromRGB(120, 80, 255),
    AccentDark   = Color3.fromRGB(85, 50, 200),
    Text         = Color3.fromRGB(240, 240, 240),
    TextDark     = Color3.fromRGB(150, 150, 160),
    ElementBg    = Color3.fromRGB(35, 35, 45),
    ElementHover = Color3.fromRGB(45, 45, 55),
    SliderBg     = Color3.fromRGB(50, 50, 60),
    ToggleOff    = Color3.fromRGB(60, 60, 70),
    Divider      = Color3.fromRGB(50, 50, 60),
}

-- ═══════════════════════════════════════
--  UTILITY
-- ═══════════════════════════════════════
local function Tween(inst, props, dur, style)
    dur   = dur or 0.2
    style = style or Enum.EasingStyle.Quint
    local t = TweenService:Create(inst, TweenInfo.new(dur, style, Enum.EasingDirection.Out), props)
    t:Play()
    return t
end

local function MakeDraggable(topbar, window)
    local dragging, dragInput, dragStart, startPos = false, nil, nil, nil

    topbar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos  = window.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)

    topbar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    RunService.RenderStepped:Connect(function()
        if dragging and dragInput then
            local d = dragInput.Position - dragStart
            Tween(window, {
                Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
            }, 0.08, Enum.EasingStyle.Linear)
        end
    end)
end

local canvasOK = pcall(function() Instance.new("CanvasGroup"):Destroy() end)

-- ═══════════════════════════════════════
--  CREATE WINDOW
-- ═══════════════════════════════════════
function PulseUI:CreateWindow(config)
    config = config or {}
    local TitleText    = config.Title or "PulseUI Remastered"
    local SubText      = config.SubTitle or ""
    local AccentColor  = config.Accent or self.Theme.Accent
    local MinKey       = config.MinimizeKey or Enum.KeyCode.RightShift
    local isVisible    = true

    local targetParent = (gethui and gethui()) or CoreGui
    local ScreenGui    = Instance.new("ScreenGui")
    ScreenGui.Name             = "PulseUI_Interface"
    ScreenGui.ZIndexBehavior   = Enum.ZIndexBehavior.Sibling
    ScreenGui.ResetOnSpawn     = false
    ScreenGui.Parent           = targetParent

    -- ── Main Frame (CanvasGroup for fade) ──
    local MainFrame
    if canvasOK then
        MainFrame = Instance.new("CanvasGroup")
        MainFrame.GroupTransparency = 1
    else
        MainFrame = Instance.new("Frame")
    end
    MainFrame.Name                 = "MainFrame"
    MainFrame.Size                 = UDim2.fromOffset(520, 360)
    MainFrame.Position             = UDim2.new(0.5, -260, 0.5, -180)
    MainFrame.BackgroundColor3     = self.Theme.AcrylicTint
    MainFrame.BackgroundTransparency = 0.15
    MainFrame.BorderSizePixel      = 0
    MainFrame.ClipsDescendants     = true
    MainFrame.Parent               = ScreenGui

    Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)

    local MainStroke       = Instance.new("UIStroke", MainFrame)
    MainStroke.Color       = Color3.fromRGB(255, 255, 255)
    MainStroke.Transparency = 0.88
    MainStroke.Thickness   = 1

    -- Shadow
    local Shadow                  = Instance.new("ImageLabel")
    Shadow.AnchorPoint            = Vector2.new(0.5, 0.5)
    Shadow.Position               = UDim2.fromScale(0.5, 0.5)
    Shadow.Size                   = UDim2.new(1, 47, 1, 47)
    Shadow.BackgroundTransparency = 1
    Shadow.Image                  = "rbxassetid://6015897843"
    Shadow.ImageColor3            = Color3.new(0, 0, 0)
    Shadow.ImageTransparency      = 0.5
    Shadow.ZIndex                 = -1
    Shadow.Parent                 = MainFrame

    -- Intro animation
    local IntroScale   = Instance.new("UIScale")
    IntroScale.Scale   = 0.88
    IntroScale.Parent  = MainFrame

    task.defer(function()
        Tween(IntroScale, {Scale = 1}, 0.55, Enum.EasingStyle.Back)
        if canvasOK then Tween(MainFrame, {GroupTransparency = 0}, 0.45) end
    end)

    -- ── Topbar ──
    local Topbar              = Instance.new("Frame")
    Topbar.Size               = UDim2.new(1, 0, 0, 40)
    Topbar.BackgroundTransparency = 1
    Topbar.Parent             = MainFrame
    MakeDraggable(Topbar, MainFrame)

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Size               = UDim2.new(0, 260, 1, 0)
    TitleLabel.Position           = UDim2.fromOffset(20, 0)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text               = TitleText
    TitleLabel.TextColor3         = self.Theme.Text
    TitleLabel.TextSize           = 16
    TitleLabel.Font               = Enum.Font.GothamBold
    TitleLabel.TextXAlignment     = Enum.TextXAlignment.Left
    TitleLabel.Parent             = Topbar

    local SubLabel = Instance.new("TextLabel")
    SubLabel.BackgroundTransparency = 1
    SubLabel.AnchorPoint          = Vector2.new(1, 0)
    SubLabel.Position             = UDim2.new(1, -15, 0, 0)
    SubLabel.Size                 = UDim2.new(0, 160, 1, 0)
    SubLabel.Text                 = SubText
    SubLabel.TextColor3           = self.Theme.TextDark
    SubLabel.TextSize             = 12
    SubLabel.Font                 = Enum.Font.Gotham
    SubLabel.TextXAlignment       = Enum.TextXAlignment.Right
    SubLabel.Parent               = Topbar

    -- Accent divider with pulse gradient
    local Divider             = Instance.new("Frame")
    Divider.Size              = UDim2.new(1, 0, 0, 1)
    Divider.Position          = UDim2.new(0, 0, 1, 0)
    Divider.BackgroundColor3  = AccentColor
    Divider.BorderSizePixel   = 0
    Divider.Parent            = Topbar

    local DivGrad = Instance.new("UIGradient")
    DivGrad.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, AccentColor),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(180, 150, 255)),
        ColorSequenceKeypoint.new(1, AccentColor),
    }
    DivGrad.Parent = Divider

    task.spawn(function()
        while MainFrame and MainFrame.Parent do
            DivGrad.Offset = Vector2.new(-1, 0)
            Tween(DivGrad, {Offset = Vector2.new(1, 0)}, 3, Enum.EasingStyle.Linear)
            task.wait(3)
        end
    end)

    -- ── Sidebar divider ──
    local SideLine                    = Instance.new("Frame")
    SideLine.Size                     = UDim2.new(0, 1, 1, -41)
    SideLine.Position                 = UDim2.fromOffset(130, 41)
    SideLine.BackgroundColor3         = Color3.fromRGB(255, 255, 255)
    SideLine.BackgroundTransparency   = 0.9
    SideLine.BorderSizePixel          = 0
    SideLine.Parent                   = MainFrame

    -- ── Tab Container (sidebar) ──
    local TabContainer                  = Instance.new("ScrollingFrame")
    TabContainer.Size                   = UDim2.new(0, 130, 1, -41)
    TabContainer.Position               = UDim2.fromOffset(0, 41)
    TabContainer.BackgroundTransparency = 1
    TabContainer.BorderSizePixel        = 0
    TabContainer.ScrollBarThickness     = 0
    TabContainer.Parent                 = MainFrame

    local TabLayout         = Instance.new("UIListLayout")
    TabLayout.Padding       = UDim.new(0, 4)
    TabLayout.SortOrder     = Enum.SortOrder.LayoutOrder
    TabLayout.Parent        = TabContainer

    local TabPad            = Instance.new("UIPadding")
    TabPad.PaddingTop       = UDim.new(0, 10)
    TabPad.PaddingLeft      = UDim.new(0, 10)
    TabPad.PaddingRight     = UDim.new(0, 10)
    TabPad.Parent           = TabContainer

    TabLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        TabContainer.CanvasSize = UDim2.fromOffset(0, TabLayout.AbsoluteContentSize.Y + 20)
    end)

    -- ── Content Container ──
    local ContentContainer                  = Instance.new("Frame")
    ContentContainer.Size                   = UDim2.new(1, -131, 1, -41)
    ContentContainer.Position               = UDim2.fromOffset(131, 41)
    ContentContainer.BackgroundTransparency = 1
    ContentContainer.ClipsDescendants       = true
    ContentContainer.Parent                 = MainFrame

    -- ── Minimize ──
    UserInputService.InputBegan:Connect(function(input, gpe)
        if gpe then return end
        if input.KeyCode == MinKey then
            isVisible = not isVisible
            if canvasOK then
                if isVisible then
                    MainFrame.Visible = true
                    Tween(IntroScale, {Scale = 1}, 0.3, Enum.EasingStyle.Back)
                    Tween(MainFrame, {GroupTransparency = 0}, 0.25)
                else
                    Tween(IntroScale, {Scale = 0.88}, 0.2)
                    Tween(MainFrame, {GroupTransparency = 1}, 0.2)
                    task.delay(0.25, function()
                        if not isVisible then MainFrame.Visible = false end
                    end)
                end
            else
                MainFrame.Visible = isVisible
            end
        end
    end)

    -- ── Notification System ──
    local activeNotifs = {}
    local NOTIF_H      = 70
    local NOTIF_GAP    = 8

    local function repositionNotifs()
        for i, nf in ipairs(activeNotifs) do
            local fromBottom = #activeNotifs - i
            local tY = -20 - fromBottom * (NOTIF_H + NOTIF_GAP)
            Tween(nf, {Position = UDim2.new(1, -20, 1, tY)}, 0.35)
        end
    end

    -- ═══════════════════════════════════════
    --  WINDOW OBJECT
    -- ═══════════════════════════════════════
    local Window = { Tabs = {}, CurrentTab = nil }

    function Window:SetTitle(t)    TitleLabel.Text = t end
    function Window:SetSubTitle(t) SubLabel.Text   = t end

    function Window:Destroy()
        if canvasOK then
            Tween(IntroScale, {Scale = 0.85}, 0.3)
            Tween(MainFrame, {GroupTransparency = 1}, 0.3)
            task.delay(0.35, function() ScreenGui:Destroy() end)
        else
            ScreenGui:Destroy()
        end
    end

    function Window:Notify(cfg)
        cfg = cfg or {}
        local dur = cfg.Duration or 4

        local NF                    = Instance.new("Frame")
        NF.BackgroundColor3         = PulseUI.Theme.AcrylicTint
        NF.BackgroundTransparency   = 0.08
        NF.BorderSizePixel          = 0
        NF.AnchorPoint              = Vector2.new(1, 1)
        NF.Position                 = UDim2.new(1, 300, 1, -20)
        NF.Size                     = UDim2.fromOffset(280, NOTIF_H)
        NF.ClipsDescendants         = true
        NF.Parent                   = ScreenGui
        Instance.new("UICorner", NF).CornerRadius = UDim.new(0, 8)

        local NS            = Instance.new("UIStroke", NF)
        NS.Color            = AccentColor
        NS.Transparency     = 0.65
        NS.Thickness        = 1

        local Bar               = Instance.new("Frame")
        Bar.BackgroundColor3    = AccentColor
        Bar.BorderSizePixel     = 0
        Bar.Size                = UDim2.new(0, 3, 1, 0)
        Bar.Parent              = NF

        local NT                        = Instance.new("TextLabel")
        NT.BackgroundTransparency       = 1
        NT.Position                     = UDim2.fromOffset(14, 12)
        NT.Size                         = UDim2.new(1, -24, 0, 18)
        NT.Font                         = Enum.Font.GothamBold
        NT.Text                         = cfg.Title or "Notification"
        NT.TextColor3                   = PulseUI.Theme.Text
        NT.TextSize                     = 14
        NT.TextXAlignment               = Enum.TextXAlignment.Left
        NT.Parent                       = NF

        local NC                        = Instance.new("TextLabel")
        NC.BackgroundTransparency       = 1
        NC.Position                     = UDim2.fromOffset(14, 34)
        NC.Size                         = UDim2.new(1, -24, 0, 26)
        NC.Font                         = Enum.Font.Gotham
        NC.Text                         = cfg.Content or ""
        NC.TextColor3                   = PulseUI.Theme.TextDark
        NC.TextSize                     = 12
        NC.TextXAlignment               = Enum.TextXAlignment.Left
        NC.TextWrapped                  = true
        NC.Parent                       = NF

        local Timer                 = Instance.new("Frame")
        Timer.BackgroundColor3      = AccentColor
        Timer.BorderSizePixel       = 0
        Timer.Position              = UDim2.new(0, 0, 1, -2)
        Timer.Size                  = UDim2.new(1, 0, 0, 2)
        Timer.Parent                = NF

        table.insert(activeNotifs, NF)
        repositionNotifs()

        Tween(Timer, {Size = UDim2.new(0, 0, 0, 2)}, dur, Enum.EasingStyle.Linear)

        task.delay(dur, function()
            local idx = table.find(activeNotifs, NF)
            if idx then table.remove(activeNotifs, idx) end
            Tween(NF, {Position = UDim2.new(1, 300, 1, NF.Position.Y.Offset)}, 0.4, Enum.EasingStyle.Back)
            repositionNotifs()
            task.delay(0.45, function() NF:Destroy() end)
        end)
    end

    -- ═══════════════════════════════════════
    --  CREATE TAB
    -- ═══════════════════════════════════════
    function Window:CreateTab(name)
        local TabBtn                    = Instance.new("TextButton")
        TabBtn.Size                     = UDim2.new(1, 0, 0, 32)
        TabBtn.BackgroundColor3         = PulseUI.Theme.ElementBg
        TabBtn.BackgroundTransparency   = 1
        TabBtn.Text                     = name
        TabBtn.TextColor3              = PulseUI.Theme.TextDark
        TabBtn.Font                     = Enum.Font.GothamSemibold
        TabBtn.TextSize                 = 13
        TabBtn.AutoButtonColor          = false
        TabBtn.Parent                   = TabContainer
        Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 6)

        local Page                          = Instance.new("ScrollingFrame")
        Page.Size                           = UDim2.new(1, 0, 1, 0)
        Page.BackgroundTransparency         = 1
        Page.BorderSizePixel                = 0
        Page.ScrollBarThickness             = 2
        Page.ScrollBarImageColor3           = AccentColor
        Page.Visible                        = false
        Page.Parent                         = ContentContainer

        local PL         = Instance.new("UIListLayout")
        PL.Padding       = UDim.new(0, 6)
        PL.SortOrder     = Enum.SortOrder.LayoutOrder
        PL.Parent        = Page

        local PP              = Instance.new("UIPadding")
        PP.PaddingTop         = UDim.new(0, 8)
        PP.PaddingLeft        = UDim.new(0, 10)
        PP.PaddingRight       = UDim.new(0, 10)
        PP.PaddingBottom      = UDim.new(0, 8)
        PP.Parent             = Page

        PL:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            Page.CanvasSize = UDim2.fromOffset(0, PL.AbsoluteContentSize.Y + 16)
        end)

        -- Tab switching
        TabBtn.MouseButton1Click:Connect(function()
            if Window.CurrentTab then
                Window.CurrentTab.Btn.BackgroundTransparency = 1
                Tween(Window.CurrentTab.Btn, {TextColor3 = PulseUI.Theme.TextDark}, 0.2)
                Window.CurrentTab.Page.Visible = false
            end
            Window.CurrentTab = {Btn = TabBtn, Page = Page}
            Page.Visible = true
            Tween(TabBtn, {BackgroundTransparency = 0, TextColor3 = PulseUI.Theme.Text}, 0.2)
            Page.Position = UDim2.fromOffset(12, 0)
            Tween(Page, {Position = UDim2.fromOffset(0, 0)}, 0.3)
        end)

        TabBtn.MouseEnter:Connect(function()
            if not Window.CurrentTab or Window.CurrentTab.Btn ~= TabBtn then
                Tween(TabBtn, {BackgroundTransparency = 0.5}, 0.12)
            end
        end)
        TabBtn.MouseLeave:Connect(function()
            if not Window.CurrentTab or Window.CurrentTab.Btn ~= TabBtn then
                Tween(TabBtn, {BackgroundTransparency = 1}, 0.12)
            end
        end)

        if not Window.CurrentTab then
            TabBtn.BackgroundTransparency = 0
            TabBtn.TextColor3 = PulseUI.Theme.Text
            Page.Visible = true
            Window.CurrentTab = {Btn = TabBtn, Page = Page}
        end

        -- ═══════════════════════════════════════
        --  TAB ELEMENTS
        -- ═══════════════════════════════════════
        local E = {}

        -- SECTION
        function E:CreateSection(text)
            local SF = Instance.new("Frame")
            SF.Size = UDim2.new(1, 0, 0, 26)
            SF.BackgroundTransparency = 1
            SF.Parent = Page

            local SL = Instance.new("TextLabel")
            SL.BackgroundTransparency = 1
            SL.Position = UDim2.fromOffset(2, 4)
            SL.Size = UDim2.new(1, 0, 0, 14)
            SL.Text = string.upper(text)
            SL.TextColor3 = AccentColor
            SL.Font = Enum.Font.GothamBold
            SL.TextSize = 11
            SL.TextXAlignment = Enum.TextXAlignment.Left
            SL.Parent = SF

            local Line = Instance.new("Frame")
            Line.Size = UDim2.new(1, 0, 0, 1)
            Line.Position = UDim2.new(0, 0, 1, -1)
            Line.BackgroundColor3 = PulseUI.Theme.Divider
            Line.BorderSizePixel = 0
            Line.Parent = SF

            local G = Instance.new("UIGradient")
            G.Transparency = NumberSequence.new{
                NumberSequenceKeypoint.new(0, 0),
                NumberSequenceKeypoint.new(1, 1),
            }
            G.Parent = Line
        end

        -- LABEL
        function E:CreateLabel(text)
            local L = Instance.new("TextLabel")
            L.Size = UDim2.new(1, 0, 0, 20)
            L.BackgroundTransparency = 1
            L.Text = text
            L.TextColor3 = PulseUI.Theme.TextDark
            L.Font = Enum.Font.Gotham
            L.TextSize = 13
            L.TextXAlignment = Enum.TextXAlignment.Left
            L.Parent = Page
            local o = {}
            function o:Set(v) L.Text = v end
            return o
        end

        -- BUTTON
        function E:CreateButton(btnText, callback)
            local B = Instance.new("TextButton")
            B.Size = UDim2.new(1, 0, 0, 35)
            B.BackgroundColor3 = PulseUI.Theme.ElementBg
            B.Text = btnText
            B.TextColor3 = PulseUI.Theme.Text
            B.Font = Enum.Font.Gotham
            B.TextSize = 14
            B.AutoButtonColor = false
            B.Parent = Page
            Instance.new("UICorner", B).CornerRadius = UDim.new(0, 6)

            local BS = Instance.new("UIStroke", B)
            BS.Color = Color3.fromRGB(255, 255, 255)
            BS.Transparency = 0.92

            B.MouseEnter:Connect(function()
                Tween(B, {BackgroundColor3 = PulseUI.Theme.ElementHover}, 0.15)
                Tween(BS, {Color = AccentColor, Transparency = 0.6}, 0.15)
            end)
            B.MouseLeave:Connect(function()
                Tween(B, {BackgroundColor3 = PulseUI.Theme.ElementBg}, 0.15)
                Tween(BS, {Color = Color3.fromRGB(255,255,255), Transparency = 0.92}, 0.15)
            end)
            B.MouseButton1Down:Connect(function()
                Tween(B, {Size = UDim2.new(0.98, 0, 0, 33)}, 0.08)
            end)
            B.MouseButton1Up:Connect(function()
                Tween(B, {Size = UDim2.new(1, 0, 0, 35)}, 0.12)
            end)
            B.MouseButton1Click:Connect(function()
                Tween(B, {BackgroundColor3 = AccentColor}, 0.05)
                task.delay(0.07, function() Tween(B, {BackgroundColor3 = PulseUI.Theme.ElementHover}, 0.2) end)
                if callback then task.spawn(callback) end
            end)
        end

        -- TOGGLE
        function E:CreateToggle(toggleText, default, callback)
            local toggled = default or false

            local TF = Instance.new("TextButton")
            TF.Size = UDim2.new(1, 0, 0, 35)
            TF.BackgroundColor3 = PulseUI.Theme.ElementBg
            TF.Text = ""
            TF.AutoButtonColor = false
            TF.Parent = Page
            Instance.new("UICorner", TF).CornerRadius = UDim.new(0, 6)

            local TS = Instance.new("UIStroke", TF)
            TS.Color = Color3.fromRGB(255, 255, 255)
            TS.Transparency = 0.92

            local TL = Instance.new("TextLabel")
            TL.Size = UDim2.new(1, -60, 1, 0)
            TL.Position = UDim2.fromOffset(10, 0)
            TL.BackgroundTransparency = 1
            TL.Text = toggleText
            TL.TextColor3 = PulseUI.Theme.Text
            TL.Font = Enum.Font.Gotham
            TL.TextSize = 14
            TL.TextXAlignment = Enum.TextXAlignment.Left
            TL.Parent = TF

            local TO = Instance.new("Frame")
            TO.Size = UDim2.fromOffset(40, 20)
            TO.AnchorPoint = Vector2.new(1, 0.5)
            TO.Position = UDim2.new(1, -10, 0.5, 0)
            TO.BackgroundColor3 = toggled and AccentColor or PulseUI.Theme.ToggleOff
            TO.Parent = TF
            Instance.new("UICorner", TO).CornerRadius = UDim.new(1, 0)

            local TI = Instance.new("Frame")
            TI.Size = UDim2.fromOffset(16, 16)
            TI.Position = toggled and UDim2.fromOffset(22, 2) or UDim2.fromOffset(2, 2)
            TI.BackgroundColor3 = Color3.new(1, 1, 1)
            TI.Parent = TO
            Instance.new("UICorner", TI).CornerRadius = UDim.new(1, 0)

            local function refresh()
                Tween(TO, {BackgroundColor3 = toggled and AccentColor or PulseUI.Theme.ToggleOff}, 0.25)
                Tween(TI, {Position = toggled and UDim2.fromOffset(22, 2) or UDim2.fromOffset(2, 2)}, 0.25, Enum.EasingStyle.Back)
                if callback then task.spawn(callback, toggled) end
            end

            TF.MouseButton1Click:Connect(function() toggled = not toggled; refresh() end)

            TF.MouseEnter:Connect(function()
                Tween(TF, {BackgroundColor3 = PulseUI.Theme.ElementHover}, 0.15)
                Tween(TS, {Color = AccentColor, Transparency = 0.7}, 0.15)
            end)
            TF.MouseLeave:Connect(function()
                Tween(TF, {BackgroundColor3 = PulseUI.Theme.ElementBg}, 0.15)
                Tween(TS, {Color = Color3.fromRGB(255,255,255), Transparency = 0.92}, 0.15)
            end)

            local o = {}
            function o:Set(v) toggled = v; refresh() end
            function o:Get() return toggled end
            return o
        end

        -- SLIDER
        function E:CreateSlider(cfg)
            cfg = cfg or {}
            local text     = cfg.Text or "Slider"
            local min      = cfg.Min or 0
            local max      = cfg.Max or 100
            local val      = math.clamp(cfg.Default or min, min, max)
            local cb       = cfg.Callback or function() end
            local sliding  = false
            local range    = math.max(max - min, 1)

            local SF = Instance.new("Frame")
            SF.Size = UDim2.new(1, 0, 0, 50)
            SF.BackgroundColor3 = PulseUI.Theme.ElementBg
            SF.Parent = Page
            Instance.new("UICorner", SF).CornerRadius = UDim.new(0, 6)

            local SS = Instance.new("UIStroke", SF)
            SS.Color = Color3.fromRGB(255, 255, 255)
            SS.Transparency = 0.92

            local SL = Instance.new("TextLabel")
            SL.BackgroundTransparency = 1
            SL.Position = UDim2.fromOffset(10, 4)
            SL.Size = UDim2.new(1, -55, 0, 20)
            SL.Text = text
            SL.TextColor3 = PulseUI.Theme.Text
            SL.Font = Enum.Font.Gotham
            SL.TextSize = 14
            SL.TextXAlignment = Enum.TextXAlignment.Left
            SL.Parent = SF

            local VL = Instance.new("TextLabel")
            VL.BackgroundTransparency = 1
            VL.AnchorPoint = Vector2.new(1, 0)
            VL.Position = UDim2.new(1, -10, 0, 4)
            VL.Size = UDim2.fromOffset(42, 20)
            VL.Text = tostring(val)
            VL.TextColor3 = AccentColor
            VL.Font = Enum.Font.GothamBold
            VL.TextSize = 13
            VL.TextXAlignment = Enum.TextXAlignment.Right
            VL.Parent = SF

            local Track = Instance.new("Frame")
            Track.BackgroundColor3 = PulseUI.Theme.SliderBg
            Track.Position = UDim2.fromOffset(10, 34)
            Track.Size = UDim2.new(1, -20, 0, 4)
            Track.Parent = SF
            Instance.new("UICorner", Track).CornerRadius = UDim.new(1, 0)

            local pct = (val - min) / range

            local Fill = Instance.new("Frame")
            Fill.BackgroundColor3 = AccentColor
            Fill.Size = UDim2.new(pct, 0, 1, 0)
            Fill.Parent = Track
            Instance.new("UICorner", Fill).CornerRadius = UDim.new(1, 0)

            local FG = Instance.new("UIGradient")
            FG.Color = ColorSequence.new{
                ColorSequenceKeypoint.new(0, Color3.fromRGB(165, 135, 255)),
                ColorSequenceKeypoint.new(1, AccentColor),
            }
            FG.Parent = Fill

            local Knob = Instance.new("Frame")
            Knob.BackgroundColor3 = Color3.new(1, 1, 1)
            Knob.AnchorPoint = Vector2.new(0.5, 0.5)
            Knob.Position = UDim2.new(1, 0, 0.5, 0)
            Knob.Size = UDim2.fromOffset(12, 12)
            Knob.ZIndex = 3
            Knob.Parent = Fill
            Instance.new("UICorner", Knob).CornerRadius = UDim.new(1, 0)

            local KS = Instance.new("UIStroke", Knob)
            KS.Color = AccentColor
            KS.Transparency = 0.3
            KS.Thickness = 1.5

            local function update(inputObj)
                local tw = Track.AbsoluteSize.X
                if tw == 0 then return end
                local p = math.clamp((inputObj.Position.X - Track.AbsolutePosition.X) / tw, 0, 1)
                val = math.floor(min + range * p)
                val = math.clamp(val, min, max)
                local ap = (val - min) / range
                Fill.Size = UDim2.new(ap, 0, 1, 0)
                VL.Text = tostring(val)
                task.spawn(cb, val)
            end

            SF.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    sliding = true
                    update(input)
                end
            end)
            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    sliding = false
                end
            end)
            UserInputService.InputChanged:Connect(function(input)
                if sliding and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                    update(input)
                end
            end)

            SF.MouseEnter:Connect(function()
                Tween(SF, {BackgroundColor3 = PulseUI.Theme.ElementHover}, 0.15)
                Tween(SS, {Color = AccentColor, Transparency = 0.7}, 0.15)
            end)
            SF.MouseLeave:Connect(function()
                Tween(SF, {BackgroundColor3 = PulseUI.Theme.ElementBg}, 0.15)
                Tween(SS, {Color = Color3.fromRGB(255,255,255), Transparency = 0.92}, 0.15)
            end)

            local o = {}
            function o:Set(v)
                val = math.clamp(v, min, max)
                local ap = (val - min) / range
                Fill.Size = UDim2.new(ap, 0, 1, 0)
                VL.Text = tostring(val)
                task.spawn(cb, val)
            end
            function o:Get() return val end
            return o
        end

        -- DROPDOWN
        function E:CreateDropdown(cfg)
            cfg = cfg or {}
            local text = cfg.Text or "Dropdown"
            local opts = cfg.Options or {}
            local sel  = cfg.Default or opts[1] or "None"
            local cb   = cfg.Callback or function() end
            local open = false
            local CH   = 35
            local OH   = 30

            local DF = Instance.new("Frame")
            DF.Size = UDim2.new(1, 0, 0, CH)
            DF.BackgroundColor3 = PulseUI.Theme.ElementBg
            DF.ClipsDescendants = true
            DF.Parent = Page
            Instance.new("UICorner", DF).CornerRadius = UDim.new(0, 6)

            local DS = Instance.new("UIStroke", DF)
            DS.Color = Color3.fromRGB(255, 255, 255)
            DS.Transparency = 0.92

            local Header = Instance.new("TextButton")
            Header.Size = UDim2.new(1, 0, 0, CH)
            Header.BackgroundTransparency = 1
            Header.Text = ""
            Header.AutoButtonColor = false
            Header.Parent = DF

            local DL = Instance.new("TextLabel")
            DL.BackgroundTransparency = 1
            DL.Position = UDim2.fromOffset(10, 0)
            DL.Size = UDim2.new(0.5, 0, 1, 0)
            DL.Text = text
            DL.TextColor3 = PulseUI.Theme.Text
            DL.Font = Enum.Font.Gotham
            DL.TextSize = 14
            DL.TextXAlignment = Enum.TextXAlignment.Left
            DL.Parent = Header

            local Disp = Instance.new("TextLabel")
            Disp.BackgroundTransparency = 1
            Disp.AnchorPoint = Vector2.new(1, 0)
            Disp.Position = UDim2.new(1, -28, 0, 0)
            Disp.Size = UDim2.new(0.4, 0, 1, 0)
            Disp.Text = tostring(sel)
            Disp.TextColor3 = AccentColor
            Disp.Font = Enum.Font.GothamBold
            Disp.TextSize = 12
            Disp.TextXAlignment = Enum.TextXAlignment.Right
            Disp.Parent = Header

            local Arrow = Instance.new("TextLabel")
            Arrow.BackgroundTransparency = 1
            Arrow.AnchorPoint = Vector2.new(1, 0.5)
            Arrow.Position = UDim2.new(1, -8, 0.5, 0)
            Arrow.Size = UDim2.fromOffset(14, 14)
            Arrow.Text = "›"
            Arrow.Rotation = 90
            Arrow.TextColor3 = PulseUI.Theme.TextDark
            Arrow.Font = Enum.Font.GothamBold
            Arrow.TextSize = 16
            Arrow.Parent = Header

            local LF = Instance.new("Frame")
            LF.BackgroundTransparency = 1
            LF.Position = UDim2.fromOffset(5, CH + 3)
            LF.Size = UDim2.new(1, -10, 0, 0)
            LF.Parent = DF

            local LL = Instance.new("UIListLayout")
            LL.Padding = UDim.new(0, 2)
            LL.SortOrder = Enum.SortOrder.LayoutOrder
            LL.Parent = LF

            local function buildOpts()
                for _, ch in ipairs(LF:GetChildren()) do
                    if ch:IsA("TextButton") then ch:Destroy() end
                end
                for _, opt in ipairs(opts) do
                    local OB = Instance.new("TextButton")
                    OB.Size = UDim2.new(1, 0, 0, OH)
                    OB.BackgroundColor3 = PulseUI.Theme.ElementHover
                    OB.BackgroundTransparency = 1
                    OB.Text = "  " .. opt
                    OB.TextColor3 = (opt == sel) and AccentColor or PulseUI.Theme.TextDark
                    OB.Font = Enum.Font.Gotham
                    OB.TextSize = 13
                    OB.TextXAlignment = Enum.TextXAlignment.Left
                    OB.AutoButtonColor = false
                    OB.Parent = LF
                    Instance.new("UICorner", OB).CornerRadius = UDim.new(0, 4)

                    OB.MouseEnter:Connect(function() Tween(OB, {BackgroundTransparency = 0}, 0.1) end)
                    OB.MouseLeave:Connect(function() Tween(OB, {BackgroundTransparency = 1}, 0.1) end)

                    OB.MouseButton1Click:Connect(function()
                        sel = opt
                        Disp.Text = sel
                        open = false
                        Tween(DF, {Size = UDim2.new(1, 0, 0, CH)}, 0.25)
                        Tween(Arrow, {Rotation = 90}, 0.25)
                        task.spawn(cb, sel)
                        for _, x in ipairs(LF:GetChildren()) do
                            if x:IsA("TextButton") then
                                x.TextColor3 = (x.Text:sub(3) == sel) and AccentColor or PulseUI.Theme.TextDark
                            end
                        end
                    end)
                end
            end
            buildOpts()

            Header.MouseButton1Click:Connect(function()
                open = not open
                Tween(Arrow, {Rotation = open and -90 or 90}, 0.25)
                local openH = CH + 5 + #opts * (OH + 2)
                Tween(DF, {Size = UDim2.new(1, 0, 0, open and openH or CH)}, 0.25)
            end)

            Header.MouseEnter:Connect(function() Tween(DS, {Color = AccentColor, Transparency = 0.7}, 0.15) end)
            Header.MouseLeave:Connect(function() Tween(DS, {Color = Color3.fromRGB(255,255,255), Transparency = 0.92}, 0.15) end)

            local o = {}
            function o:Set(v) sel = v; Disp.Text = tostring(v); task.spawn(cb, v) end
            function o:Get() return sel end
            function o:Refresh(newOpts) opts = newOpts; sel = opts[1] or "None"; Disp.Text = sel; buildOpts() end
            return o
        end

        -- KEYBIND
        function E:CreateKeybind(cfg)
            cfg = cfg or {}
            local text      = cfg.Text or "Keybind"
            local key       = cfg.Default or Enum.KeyCode.F
            local cb        = cfg.Callback or function() end
            local listening = false

            local KF = Instance.new("TextButton")
            KF.Size = UDim2.new(1, 0, 0, 35)
            KF.BackgroundColor3 = PulseUI.Theme.ElementBg
            KF.Text = ""
            KF.AutoButtonColor = false
            KF.Parent = Page
            Instance.new("UICorner", KF).CornerRadius = UDim.new(0, 6)

            local KS = Instance.new("UIStroke", KF)
            KS.Color = Color3.fromRGB(255, 255, 255)
            KS.Transparency = 0.92

            local KL = Instance.new("TextLabel")
            KL.BackgroundTransparency = 1
            KL.Position = UDim2.fromOffset(10, 0)
            KL.Size = UDim2.new(1, -60, 1, 0)
            KL.Text = text
            KL.TextColor3 = PulseUI.Theme.Text
            KL.Font = Enum.Font.Gotham
            KL.TextSize = 14
            KL.TextXAlignment = Enum.TextXAlignment.Left
            KL.Parent = KF

            local KD = Instance.new("Frame")
            KD.BackgroundColor3 = PulseUI.Theme.SliderBg
            KD.AnchorPoint = Vector2.new(1, 0.5)
            KD.Position = UDim2.new(1, -10, 0.5, 0)
            KD.Size = UDim2.fromOffset(46, 22)
            KD.Parent = KF
            Instance.new("UICorner", KD).CornerRadius = UDim.new(0, 4)

            local KT = Instance.new("TextLabel")
            KT.BackgroundTransparency = 1
            KT.Size = UDim2.new(1, 0, 1, 0)
            KT.Text = key.Name
            KT.TextColor3 = AccentColor
            KT.Font = Enum.Font.GothamBold
            KT.TextSize = 11
            KT.Parent = KD

            KF.MouseButton1Click:Connect(function()
                listening = true
                KT.Text = "..."
                Tween(KD, {BackgroundColor3 = AccentColor}, 0.15)
                Tween(KT, {TextColor3 = Color3.new(1, 1, 1)}, 0.15)
            end)

            UserInputService.InputBegan:Connect(function(input, gpe)
                if listening and input.UserInputType == Enum.UserInputType.Keyboard then
                    listening = false
                    if input.KeyCode == Enum.KeyCode.Escape then
                        key = Enum.KeyCode.Unknown
                        KT.Text = "None"
                    else
                        key = input.KeyCode
                        KT.Text = key.Name
                    end
                    Tween(KD, {BackgroundColor3 = PulseUI.Theme.SliderBg}, 0.15)
                    Tween(KT, {TextColor3 = AccentColor}, 0.15)
                    return
                end
                if gpe or listening then return end
                if key ~= Enum.KeyCode.Unknown and input.KeyCode == key then
                    task.spawn(cb, key)
                end
            end)

            KF.MouseEnter:Connect(function()
                Tween(KF, {BackgroundColor3 = PulseUI.Theme.ElementHover}, 0.15)
                Tween(KS, {Color = AccentColor, Transparency = 0.7}, 0.15)
            end)
            KF.MouseLeave:Connect(function()
                Tween(KF, {BackgroundColor3 = PulseUI.Theme.ElementBg}, 0.15)
                Tween(KS, {Color = Color3.fromRGB(255,255,255), Transparency = 0.92}, 0.15)
            end)

            local o = {}
            function o:SetKey(k) key = k; KT.Text = (k ~= Enum.KeyCode.Unknown) and k.Name or "None" end
            function o:GetKey() return key end
            return o
        end

        -- INPUT (TextBox)
        function E:CreateInput(cfg)
            cfg = cfg or {}
            local text = cfg.Text or "Input"
            local ph   = cfg.Placeholder or "Type here..."
            local cb   = cfg.Callback or function() end

            local IF = Instance.new("Frame")
            IF.Size = UDim2.new(1, 0, 0, 35)
            IF.BackgroundColor3 = PulseUI.Theme.ElementBg
            IF.Parent = Page
            Instance.new("UICorner", IF).CornerRadius = UDim.new(0, 6)

            local IS = Instance.new("UIStroke", IF)
            IS.Color = Color3.fromRGB(255, 255, 255)
            IS.Transparency = 0.92

            local IL = Instance.new("TextLabel")
            IL.BackgroundTransparency = 1
            IL.Position = UDim2.fromOffset(10, 0)
            IL.Size = UDim2.new(0.42, 0, 1, 0)
            IL.Text = text
            IL.TextColor3 = PulseUI.Theme.Text
            IL.Font = Enum.Font.Gotham
            IL.TextSize = 14
            IL.TextXAlignment = Enum.TextXAlignment.Left
            IL.Parent = IF

            local IB = Instance.new("TextBox")
            IB.BackgroundColor3 = PulseUI.Theme.SliderBg
            IB.AnchorPoint = Vector2.new(1, 0.5)
            IB.Position = UDim2.new(1, -8, 0.5, 0)
            IB.Size = UDim2.new(0.52, 0, 0, 24)
            IB.Text = cfg.Default or ""
            IB.PlaceholderText = ph
            IB.PlaceholderColor3 = PulseUI.Theme.TextDark
            IB.TextColor3 = PulseUI.Theme.Text
            IB.Font = Enum.Font.Gotham
            IB.TextSize = 13
            IB.ClearTextOnFocus = false
            IB.Parent = IF
            Instance.new("UICorner", IB).CornerRadius = UDim.new(0, 4)
            Instance.new("UIPadding", IB).PaddingLeft = UDim.new(0, 8)

            IB.Focused:Connect(function()
                Tween(IS, {Color = AccentColor, Transparency = 0.5}, 0.15)
            end)
            IB.FocusLost:Connect(function()
                Tween(IS, {Color = Color3.fromRGB(255,255,255), Transparency = 0.92}, 0.15)
                task.spawn(cb, IB.Text)
            end)

            local o = {}
            function o:Set(v) IB.Text = v end
            function o:Get() return IB.Text end
            return o
        end

        return E
    end

    return Window
end

return PulseUI
