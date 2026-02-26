--[[ 
    PulseUI Library (v5)
    Features: Tab Icons, Minimize/Close buttons, Profile zone, Separators
]]

local Library = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")

-- // ЦВЕТА //
local Colors = {
    Main        = Color3.fromRGB(15, 15, 15),
    Header      = Color3.fromRGB(20, 20, 20),
    Sidebar     = Color3.fromRGB(18, 18, 18),
    ProfileZone = Color3.fromRGB(28, 28, 28),       -- Серый фон профиля
    Element     = Color3.fromRGB(25, 25, 25),
    Stroke      = Color3.fromRGB(50, 50, 50),
    Accent      = Color3.fromRGB(255, 215, 0),
    Text        = Color3.fromRGB(240, 240, 240),
    TextDark    = Color3.fromRGB(160, 160, 160),
    CloseHover  = Color3.fromRGB(200, 50, 50),      -- Красный ховер закрытия
    MinHover    = Color3.fromRGB(60, 60, 60)         -- Серый ховер сворачивания
}

local Config = {
    Transparency = 0.08,
    CornerRadius = 10,
    WindowWidth = 560,
    WindowHeight = 370,
    SidebarWidth = 165,
    HeaderHeight = 42,
    ProfileHeight = 58
}

-- // УТИЛИТЫ //
local function AddCorner(parent, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius or 6)
    c.Parent = parent
    return c
end

local function AddStroke(parent, thickness, color)
    local s = Instance.new("UIStroke")
    s.Thickness = thickness or 1
    s.Color = color or Colors.Stroke
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    s.Parent = parent
    return s
end

local function AddPadding(parent, l, r, t, b)
    local p = Instance.new("UIPadding")
    p.PaddingLeft = UDim.new(0, l or 0)
    p.PaddingRight = UDim.new(0, r or 0)
    p.PaddingTop = UDim.new(0, t or 0)
    p.PaddingBottom = UDim.new(0, b or 0)
    p.Parent = parent
    return p
end

local function MakeDraggable(trigger, object)
    local Dragging, DragInput, DragStart, StartPos

    local function Update(input)
        local d = input.Position - DragStart
        object.Position = UDim2.new(StartPos.X.Scale, StartPos.X.Offset + d.X, StartPos.Y.Scale, StartPos.Y.Offset + d.Y)
    end

    trigger.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            Dragging = true
            DragStart = input.Position
            StartPos = object.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then Dragging = false end
            end)
        end
    end)

    trigger.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then DragInput = input end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == DragInput and Dragging then Update(input) end
    end)
end

local function HoverEffect(btn, normalColor, hoverColor)
    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = hoverColor}):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = normalColor}):Play()
    end)
end

-- // ГЛАВНОЕ ОКНО //
function Library:Window(Subtitle)
    local UI = {}

    -- Очистка
    if CoreGui:FindFirstChild("PulseUI_v5") then CoreGui.PulseUI_v5:Destroy() end

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "PulseUI_v5"
    ScreenGui.Parent = CoreGui
    ScreenGui.ResetOnSpawn = false

    -- ============================================
    -- МИНИ-КНОПКА (для разворачивания после сворачивания)
    -- ============================================
    local MiniButton = Instance.new("TextButton")
    MiniButton.Name = "MiniButton"
    MiniButton.Size = UDim2.new(0, 46, 0, 46)
    MiniButton.Position = UDim2.new(0, 20, 0.5, -23)
    MiniButton.BackgroundColor3 = Colors.Header
    MiniButton.Text = ""
    MiniButton.AutoButtonColor = false
    MiniButton.Visible = false
    MiniButton.Parent = ScreenGui
    AddCorner(MiniButton, 10)
    AddStroke(MiniButton, 2, Color3.fromRGB(60, 60, 60))

    local MiniIcon = Instance.new("TextLabel")
    MiniIcon.Text = "P"
    MiniIcon.Font = Enum.Font.GothamBlack
    MiniIcon.TextSize = 22
    MiniIcon.TextColor3 = Colors.Accent
    MiniIcon.Size = UDim2.new(1, 0, 1, 0)
    MiniIcon.BackgroundTransparency = 1
    MiniIcon.Parent = MiniButton

    HoverEffect(MiniButton, Colors.Header, Color3.fromRGB(35, 35, 35))

    -- ============================================
    -- ОСНОВНОЙ ФРЕЙМ
    -- ============================================
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, Config.WindowWidth, 0, Config.WindowHeight)
    MainFrame.Position = UDim2.new(0.5, -Config.WindowWidth / 2, 0.5, -Config.WindowHeight / 2)
    MainFrame.BackgroundColor3 = Colors.Main
    MainFrame.BackgroundTransparency = Config.Transparency
    MainFrame.BorderSizePixel = 0
    MainFrame.ClipsDescendants = true
    MainFrame.Parent = ScreenGui
    AddCorner(MainFrame, Config.CornerRadius)
    AddStroke(MainFrame, 2, Color3.fromRGB(55, 55, 55))

    -- ============================================
    -- HEADER (Верхняя панель)
    -- ============================================
    local Header = Instance.new("Frame")
    Header.Name = "Header"
    Header.Size = UDim2.new(1, 0, 0, Config.HeaderHeight)
    Header.BackgroundColor3 = Colors.Header
    Header.BackgroundTransparency = Config.Transparency
    Header.BorderSizePixel = 0
    Header.Parent = MainFrame

    -- Убираем закругление снизу
    local HeaderFix = Instance.new("Frame")
    HeaderFix.Size = UDim2.new(1, 0, 0, Config.CornerRadius)
    HeaderFix.Position = UDim2.new(0, 0, 1, -Config.CornerRadius)
    HeaderFix.BackgroundColor3 = Colors.Header
    HeaderFix.BackgroundTransparency = Config.Transparency
    HeaderFix.BorderSizePixel = 0
    HeaderFix.Parent = Header
    AddCorner(Header, Config.CornerRadius)

    -- Линия под шапкой
    local HeaderLine = Instance.new("Frame")
    HeaderLine.Size = UDim2.new(1, 0, 0, 1)
    HeaderLine.Position = UDim2.new(0, 0, 1, 0)
    HeaderLine.BackgroundColor3 = Colors.Stroke
    HeaderLine.BorderSizePixel = 0
    HeaderLine.Parent = Header

    MakeDraggable(Header, MainFrame)

    -- Логотип "Pulse" + "UI"
    local PulseText = Instance.new("TextLabel")
    PulseText.Text = "Pulse"
    PulseText.Font = Enum.Font.GothamBlack
    PulseText.TextSize = 18
    PulseText.TextColor3 = Colors.Text
    PulseText.Size = UDim2.new(0, 52, 1, 0)
    PulseText.Position = UDim2.new(0, 16, 0, 0)
    PulseText.BackgroundTransparency = 1
    PulseText.TextXAlignment = Enum.TextXAlignment.Left
    PulseText.Parent = Header

    local UIText = Instance.new("TextLabel")
    UIText.Text = "UI"
    UIText.Font = Enum.Font.GothamBlack
    UIText.TextSize = 18
    UIText.TextColor3 = Colors.Accent
    UIText.Size = UDim2.new(0, 22, 1, 0)
    UIText.Position = UDim2.new(0, 68, 0, 0)
    UIText.BackgroundTransparency = 1
    UIText.TextXAlignment = Enum.TextXAlignment.Left
    UIText.Parent = Header

    -- Subtitle справа
    local SubLabel = Instance.new("TextLabel")
    SubLabel.Text = Subtitle or "Script"
    SubLabel.Font = Enum.Font.GothamBold
    SubLabel.TextSize = 12
    SubLabel.TextColor3 = Colors.TextDark
    SubLabel.Size = UDim2.new(0, 250, 1, 0)
    SubLabel.Position = UDim2.new(1, -330, 0, 0)
    SubLabel.BackgroundTransparency = 1
    SubLabel.TextXAlignment = Enum.TextXAlignment.Right
    SubLabel.Parent = Header

    -- ============================================
    -- КНОПКИ СВЕРНУТЬ / ЗАКРЫТЬ (Windows Style)
    -- ============================================
    local BtnSize = 28
    local BtnSpacing = 4

    -- Кнопка ЗАКРЫТЬ (✕)
    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Size = UDim2.new(0, BtnSize, 0, BtnSize)
    CloseBtn.Position = UDim2.new(1, -(BtnSize + 8), 0.5, -BtnSize / 2)
    CloseBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    CloseBtn.Text = "✕"
    CloseBtn.TextColor3 = Colors.Text
    CloseBtn.TextSize = 14
    CloseBtn.Font = Enum.Font.GothamBold
    CloseBtn.AutoButtonColor = false
    CloseBtn.Parent = Header
    AddCorner(CloseBtn, 6)

    HoverEffect(CloseBtn, Color3.fromRGB(45, 45, 45), Colors.CloseHover)

    CloseBtn.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
    end)

    -- Кнопка СВЕРНУТЬ (—)
    local MinBtn = Instance.new("TextButton")
    MinBtn.Size = UDim2.new(0, BtnSize, 0, BtnSize)
    MinBtn.Position = UDim2.new(1, -(BtnSize * 2 + BtnSpacing + 8), 0.5, -BtnSize / 2)
    MinBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    MinBtn.Text = "—"
    MinBtn.TextColor3 = Colors.Text
    MinBtn.TextSize = 14
    MinBtn.Font = Enum.Font.GothamBold
    MinBtn.AutoButtonColor = false
    MinBtn.Parent = Header
    AddCorner(MinBtn, 6)

    HoverEffect(MinBtn, Color3.fromRGB(45, 45, 45), Colors.MinHover)

    MinBtn.MouseButton1Click:Connect(function()
        MainFrame.Visible = false
        MiniButton.Visible = true
    end)

    MiniButton.MouseButton1Click:Connect(function()
        MainFrame.Visible = true
        MiniButton.Visible = false
    end)

    -- ============================================
    -- SIDEBAR (Левая панель)
    -- ============================================
    local Sidebar = Instance.new("Frame")
    Sidebar.Name = "Sidebar"
    Sidebar.Size = UDim2.new(0, Config.SidebarWidth, 1, -Config.HeaderHeight)
    Sidebar.Position = UDim2.new(0, 0, 0, Config.HeaderHeight)
    Sidebar.BackgroundColor3 = Colors.Sidebar
    Sidebar.BackgroundTransparency = Config.Transparency
    Sidebar.BorderSizePixel = 0
    Sidebar.Parent = MainFrame

    -- Вертикальный разделитель справа
    local SideLine = Instance.new("Frame")
    SideLine.Size = UDim2.new(0, 1, 1, 0)
    SideLine.Position = UDim2.new(1, 0, 0, 0)
    SideLine.BackgroundColor3 = Colors.Stroke
    SideLine.BorderSizePixel = 0
    SideLine.Parent = Sidebar

    -- ============================================
    -- ЗОНА ПРОФИЛЯ (серый фон снизу сайдбара)
    -- ============================================
    local ProfileZone = Instance.new("Frame")
    ProfileZone.Name = "ProfileZone"
    ProfileZone.Size = UDim2.new(1, 0, 0, Config.ProfileHeight)
    ProfileZone.Position = UDim2.new(0, 0, 1, -Config.ProfileHeight)
    ProfileZone.BackgroundColor3 = Colors.ProfileZone
    ProfileZone.BorderSizePixel = 0
    ProfileZone.Parent = Sidebar

    -- Закругляем только нижний левый угол через трюк
    AddCorner(ProfileZone, Config.CornerRadius)
    -- Фикс: убираем закругление сверху и справа
    local PZFixTop = Instance.new("Frame")
    PZFixTop.Size = UDim2.new(1, 0, 0, Config.CornerRadius)
    PZFixTop.Position = UDim2.new(0, 0, 0, 0)
    PZFixTop.BackgroundColor3 = Colors.ProfileZone
    PZFixTop.BorderSizePixel = 0
    PZFixTop.Parent = ProfileZone

    local PZFixRight = Instance.new("Frame")
    PZFixRight.Size = UDim2.new(0, Config.CornerRadius, 1, 0)
    PZFixRight.Position = UDim2.new(1, -Config.CornerRadius, 0, 0)
    PZFixRight.BackgroundColor3 = Colors.ProfileZone
    PZFixRight.BorderSizePixel = 0
    PZFixRight.Parent = ProfileZone

    -- Горизонтальный разделитель НАД профилем
    local ProfileSep = Instance.new("Frame")
    ProfileSep.Size = UDim2.new(1, 0, 0, 1)
    ProfileSep.Position = UDim2.new(0, 0, 0, 0)
    ProfileSep.BackgroundColor3 = Colors.Stroke
    ProfileSep.BorderSizePixel = 0
    ProfileSep.Parent = ProfileZone

    -- Аватарка
    local Avatar = Instance.new("ImageLabel")
    Avatar.Size = UDim2.new(0, 32, 0, 32)
    Avatar.Position = UDim2.new(0, 12, 0.5, -16)
    Avatar.BackgroundTransparency = 1
    Avatar.Parent = ProfileZone

    local success, thumb = pcall(function()
        return Players:GetUserThumbnailAsync(LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size48x48)
    end)
    Avatar.Image = success and thumb or ""
    AddCorner(Avatar, 16) -- Круглая аватарка

    -- Имя
    local NameLabel = Instance.new("TextLabel")
    NameLabel.Text = LocalPlayer.DisplayName
    NameLabel.Size = UDim2.new(1, -58, 0, 16)
    NameLabel.Position = UDim2.new(0, 52, 0, 12)
    NameLabel.Font = Enum.Font.GothamBold
    NameLabel.TextSize = 12
    NameLabel.TextColor3 = Colors.Text
    NameLabel.BackgroundTransparency = 1
    NameLabel.TextXAlignment = Enum.TextXAlignment.Left
    NameLabel.TextTruncate = Enum.TextTruncate.AtEnd
    NameLabel.Parent = ProfileZone

    -- @username
    local UserLabel = Instance.new("TextLabel")
    UserLabel.Text = "@" .. LocalPlayer.Name
    UserLabel.Size = UDim2.new(1, -58, 0, 14)
    UserLabel.Position = UDim2.new(0, 52, 0, 30)
    UserLabel.Font = Enum.Font.Gotham
    UserLabel.TextSize = 10
    UserLabel.TextColor3 = Colors.TextDark
    UserLabel.BackgroundTransparency = 1
    UserLabel.TextXAlignment = Enum.TextXAlignment.Left
    UserLabel.TextTruncate = Enum.TextTruncate.AtEnd
    UserLabel.Parent = ProfileZone

    -- ============================================
    -- КОНТЕЙНЕР ТАБОВ (между хедером и профилем)
    -- ============================================
    local TabContainer = Instance.new("ScrollingFrame")
    TabContainer.Name = "TabContainer"
    TabContainer.Size = UDim2.new(1, -12, 1, -Config.ProfileHeight - 10)
    TabContainer.Position = UDim2.new(0, 6, 0, 8)
    TabContainer.BackgroundTransparency = 1
    TabContainer.ScrollBarThickness = 0
    TabContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
    TabContainer.Parent = Sidebar

    local TabList = Instance.new("UIListLayout")
    TabList.Padding = UDim.new(0, 4)
    TabList.SortOrder = Enum.SortOrder.LayoutOrder
    TabList.HorizontalAlignment = Enum.HorizontalAlignment.Center
    TabList.Parent = TabContainer

    TabList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        TabContainer.CanvasSize = UDim2.new(0, 0, 0, TabList.AbsoluteContentSize.Y + 5)
    end)

    -- ============================================
    -- КОНТЕЙНЕР СТРАНИЦ (справа)
    -- ============================================
    local Pages = Instance.new("Frame")
    Pages.Name = "Pages"
    Pages.Size = UDim2.new(1, -(Config.SidebarWidth + 10), 1, -(Config.HeaderHeight + 10))
    Pages.Position = UDim2.new(0, Config.SidebarWidth + 5, 0, Config.HeaderHeight + 5)
    Pages.BackgroundTransparency = 1
    Pages.Parent = MainFrame

    local FirstTab = true

    -- ============================================
    -- ФУНКЦИЯ СОЗДАНИЯ ТАБА
    -- ============================================
    function UI:Tab(Name, IconId)
        local TabFuncs = {}

        -- Кнопка таба
        local TabBtn = Instance.new("TextButton")
        TabBtn.Name = Name .. "_Tab"
        TabBtn.Size = UDim2.new(1, -4, 0, 34)
        TabBtn.BackgroundColor3 = Colors.Element
        TabBtn.BackgroundTransparency = 1
        TabBtn.Text = ""
        TabBtn.AutoButtonColor = false
        TabBtn.Parent = TabContainer
        AddCorner(TabBtn, 8)

        -- Иконка таба
        if IconId then
            local Icon = Instance.new("ImageLabel")
            Icon.Name = "Icon"
            Icon.Size = UDim2.new(0, 18, 0, 18)
            Icon.Position = UDim2.new(0, 10, 0.5, -9)
            Icon.BackgroundTransparency = 1
            Icon.Image = IconId
            Icon.ImageColor3 = Colors.TextDark
            Icon.Parent = TabBtn
        end

        -- Текст таба
        local TabLabel = Instance.new("TextLabel")
        TabLabel.Text = Name
        TabLabel.Size = UDim2.new(1, IconId and -38 or -20, 1, 0)
        TabLabel.Position = UDim2.new(0, IconId and 34 or 12, 0, 0)
        TabLabel.Font = Enum.Font.GothamBold
        TabLabel.TextSize = 12
        TabLabel.TextColor3 = Colors.TextDark
        TabLabel.BackgroundTransparency = 1
        TabLabel.TextXAlignment = Enum.TextXAlignment.Left
        TabLabel.Parent = TabBtn

        -- Страница
        local Page = Instance.new("ScrollingFrame")
        Page.Name = Name .. "_Page"
        Page.Size = UDim2.new(1, 0, 1, 0)
        Page.BackgroundTransparency = 1
        Page.ScrollBarThickness = 2
        Page.ScrollBarImageColor3 = Colors.Accent
        Page.Visible = false
        Page.Parent = Pages

        local PageList = Instance.new("UIListLayout")
        PageList.Padding = UDim.new(0, 6)
        PageList.SortOrder = Enum.SortOrder.LayoutOrder
        PageList.Parent = Page

        PageList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            Page.CanvasSize = UDim2.new(0, 0, 0, PageList.AbsoluteContentSize.Y + 10)
        end)

        -- Активация
        local function Activate()
            for _, v in pairs(TabContainer:GetChildren()) do
                if v:IsA("TextButton") then
                    TweenService:Create(v, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play()
                    local lbl = v:FindFirstChildWhichIsA("TextLabel")
                    if lbl then
                        TweenService:Create(lbl, TweenInfo.new(0.2), {TextColor3 = Colors.TextDark}):Play()
                    end
                    local icon = v:FindFirstChild("Icon")
                    if icon then
                        TweenService:Create(icon, TweenInfo.new(0.2), {ImageColor3 = Colors.TextDark}):Play()
                    end
                end
            end
            for _, p in pairs(Pages:GetChildren()) do p.Visible = false end

            Page.Visible = true
            TweenService:Create(TabBtn, TweenInfo.new(0.2), {BackgroundTransparency = 0}):Play()
            TweenService:Create(TabLabel, TweenInfo.new(0.2), {TextColor3 = Colors.Accent}):Play()
            if TabBtn:FindFirstChild("Icon") then
                TweenService:Create(TabBtn.Icon, TweenInfo.new(0.2), {ImageColor3 = Colors.Accent}):Play()
            end
        end

        TabBtn.MouseButton1Click:Connect(Activate)

        if FirstTab then
            FirstTab = false
            Activate()
        end

        -- ============================================
        -- ЭЛЕМЕНТЫ
        -- ============================================

        -- BUTTON
        function TabFuncs:Button(Text, Callback)
            local Btn = Instance.new("TextButton")
            Btn.Size = UDim2.new(1, -6, 0, 36)
            Btn.BackgroundColor3 = Colors.Element
            Btn.BackgroundTransparency = Config.Transparency
            Btn.Text = ""
            Btn.AutoButtonColor = false
            Btn.Parent = Page
            AddCorner(Btn, 6)
            local Stroke = AddStroke(Btn, 1, Colors.Stroke)

            local Label = Instance.new("TextLabel")
            Label.Text = Text
            Label.Size = UDim2.new(1, -40, 1, 0)
            Label.Position = UDim2.new(0, 12, 0, 0)
            Label.BackgroundTransparency = 1
            Label.Font = Enum.Font.GothamBold
            Label.TextColor3 = Colors.Text
            Label.TextSize = 12
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.Parent = Btn

            local Arrow = Instance.new("TextLabel")
            Arrow.Text = "›"
            Arrow.Size = UDim2.new(0, 20, 1, 0)
            Arrow.Position = UDim2.new(1, -28, 0, 0)
            Arrow.BackgroundTransparency = 1
            Arrow.Font = Enum.Font.GothamBold
            Arrow.TextColor3 = Colors.TextDark
            Arrow.TextSize = 18
            Arrow.Parent = Btn

            HoverEffect(Btn, Colors.Element, Color3.fromRGB(35, 35, 35))

            Btn.MouseButton1Click:Connect(function()
                if Callback then Callback() end
                TweenService:Create(Stroke, TweenInfo.new(0.1), {Color = Colors.Accent}):Play()
                task.wait(0.15)
                TweenService:Create(Stroke, TweenInfo.new(0.2), {Color = Colors.Stroke}):Play()
            end)
        end

        -- TOGGLE
        function TabFuncs:Toggle(Text, Default, Callback)
            local Toggled = Default or false

            local Tgl = Instance.new("TextButton")
            Tgl.Size = UDim2.new(1, -6, 0, 36)
            Tgl.BackgroundColor3 = Colors.Element
            Tgl.BackgroundTransparency = Config.Transparency
            Tgl.Text = ""
            Tgl.AutoButtonColor = false
            Tgl.Parent = Page
            AddCorner(Tgl, 6)
            local Stroke = AddStroke(Tgl, 1, Colors.Stroke)

            local Label = Instance.new("TextLabel")
            Label.Text = Text
            Label.Size = UDim2.new(1, -55, 1, 0)
            Label.Position = UDim2.new(0, 12, 0, 0)
            Label.BackgroundTransparency = 1
            Label.Font = Enum.Font.GothamBold
            Label.TextColor3 = Colors.Text
            Label.TextSize = 12
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.Parent = Tgl

            -- Switch track
            local Track = Instance.new("Frame")
            Track.Size = UDim2.new(0, 36, 0, 20)
            Track.Position = UDim2.new(1, -48, 0.5, -10)
            Track.BackgroundColor3 = Toggled and Colors.Accent or Color3.fromRGB(50, 50, 50)
            Track.Parent = Tgl
            AddCorner(Track, 10)

            -- Switch circle
            local Circle = Instance.new("Frame")
            Circle.Size = UDim2.new(0, 14, 0, 14)
            Circle.Position = Toggled and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 3, 0.5, -7)
            Circle.BackgroundColor3 = Colors.Text
            Circle.Parent = Track
            AddCorner(Circle, 7)

            HoverEffect(Tgl, Colors.Element, Color3.fromRGB(35, 35, 35))

            local function UpdateVisual()
                if Toggled then
                    TweenService:Create(Track, TweenInfo.new(0.2), {BackgroundColor3 = Colors.Accent}):Play()
                    TweenService:Create(Circle, TweenInfo.new(0.2), {Position = UDim2.new(1, -17, 0.5, -7)}):Play()
                    TweenService:Create(Stroke, TweenInfo.new(0.2), {Color = Colors.Accent}):Play()
                    TweenService:Create(Label, TweenInfo.new(0.2), {TextColor3 = Colors.Accent}):Play()
                else
                    TweenService:Create(Track, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(50, 50, 50)}):Play()
                    TweenService:Create(Circle, TweenInfo.new(0.2), {Position = UDim2.new(0, 3, 0.5, -7)}):Play()
                    TweenService:Create(Stroke, TweenInfo.new(0.2), {Color = Colors.Stroke}):Play()
                    TweenService:Create(Label, TweenInfo.new(0.2), {TextColor3 = Colors.Text}):Play()
                end
            end

            if Toggled then UpdateVisual() end

            Tgl.MouseButton1Click:Connect(function()
                Toggled = not Toggled
                UpdateVisual()
                if Callback then Callback(Toggled) end
            end)
        end

        -- SLIDER
        function TabFuncs:Slider(Text, Min, Max, Default, Callback)
            local Value = Default or Min
            local Dragging = false

            local Sld = Instance.new("Frame")
            Sld.Size = UDim2.new(1, -6, 0, 50)
            Sld.BackgroundColor3 = Colors.Element
            Sld.BackgroundTransparency = Config.Transparency
            Sld.Parent = Page
            AddCorner(Sld, 6)
            local Stroke = AddStroke(Sld, 1, Colors.Stroke)

            local Label = Instance.new("TextLabel")
            Label.Text = Text
            Label.Size = UDim2.new(1, -60, 0, 22)
            Label.Position = UDim2.new(0, 12, 0, 4)
            Label.BackgroundTransparency = 1
            Label.Font = Enum.Font.GothamBold
            Label.TextColor3 = Colors.Text
            Label.TextSize = 12
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.Parent = Sld

            local ValLabel = Instance.new("TextLabel")
            ValLabel.Text = tostring(Value)
            ValLabel.Size = UDim2.new(0, 45, 0, 22)
            ValLabel.Position = UDim2.new(1, -55, 0, 4)
            ValLabel.BackgroundTransparency = 1
            ValLabel.Font = Enum.Font.GothamBold
            ValLabel.TextColor3 = Colors.Accent
            ValLabel.TextSize = 12
            ValLabel.TextXAlignment = Enum.TextXAlignment.Right
            ValLabel.Parent = Sld

            local Bar = Instance.new("Frame")
            Bar.Size = UDim2.new(1, -24, 0, 5)
            Bar.Position = UDim2.new(0, 12, 0, 34)
            Bar.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            Bar.BorderSizePixel = 0
            Bar.Parent = Sld
            AddCorner(Bar, 3)

            local Fill = Instance.new("Frame")
            Fill.Size = UDim2.new(math.clamp((Value - Min) / (Max - Min), 0, 1), 0, 1, 0)
            Fill.BackgroundColor3 = Colors.Accent
            Fill.BorderSizePixel = 0
            Fill.Parent = Bar
            AddCorner(Fill, 3)

            -- Кружок на слайдере
            local Knob = Instance.new("Frame")
            Knob.Size = UDim2.new(0, 13, 0, 13)
            Knob.AnchorPoint = Vector2.new(0.5, 0.5)
            Knob.Position = UDim2.new(math.clamp((Value - Min) / (Max - Min), 0, 1), 0, 0.5, 0)
            Knob.BackgroundColor3 = Colors.Text
            Knob.Parent = Bar
            AddCorner(Knob, 7)

            local Trigger = Instance.new("TextButton")
            Trigger.Size = UDim2.new(1, 0, 1, 0)
            Trigger.BackgroundTransparency = 1
            Trigger.Text = ""
            Trigger.Parent = Sld

            local function Update(input)
                local pos = math.clamp((input.Position.X - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X, 0, 1)
                local val = math.floor(((pos * (Max - Min)) + Min) * 10) / 10
                Fill:TweenSize(UDim2.new(pos, 0, 1, 0), "Out", "Sine", 0.05, true)
                TweenService:Create(Knob, TweenInfo.new(0.05), {Position = UDim2.new(pos, 0, 0.5, 0)}):Play()
                ValLabel.Text = tostring(val)
                if Callback then Callback(val) end
            end

            Trigger.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    Dragging = true
                    TweenService:Create(Stroke, TweenInfo.new(0.15), {Color = Colors.Accent}):Play()
                    Update(input)
                end
            end)

            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    Dragging = false
                    TweenService:Create(Stroke, TweenInfo.new(0.15), {Color = Colors.Stroke}):Play()
                end
            end)

            UserInputService.InputChanged:Connect(function(input)
                if Dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                    Update(input)
                end
            end)
        end

        -- LABEL (информационная строка)
        function TabFuncs:Label(Text)
            local Lbl = Instance.new("TextLabel")
            Lbl.Size = UDim2.new(1, -6, 0, 28)
            Lbl.BackgroundColor3 = Colors.Element
            Lbl.BackgroundTransparency = Config.Transparency
            Lbl.Text = "  " .. Text
            Lbl.Font = Enum.Font.GothamBold
            Lbl.TextSize = 11
            Lbl.TextColor3 = Colors.TextDark
            Lbl.TextXAlignment = Enum.TextXAlignment.Left
            Lbl.Parent = Page
            AddCorner(Lbl, 6)
            AddStroke(Lbl, 1, Colors.Stroke)
        end

        return TabFuncs
    end

    return UI
end

return Library
