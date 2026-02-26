--[[ 
    PulseUI Library (v4 Acrylic)
    Style: Semi-Transparent, Top Header, Rounded Tabs
]]

local Library = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")

-- // ЦВЕТА И НАСТРОЙКИ //
local Config = {
    Transparency = 0.1, -- Насколько прозрачное окно (0 - нет, 1 - полностью)
    CornerRadius = 12,   -- Закругление углов окна
}

local Colors = {
    Main        = Color3.fromRGB(15, 15, 15),       -- Основной фон
    Header      = Color3.fromRGB(20, 20, 20),       -- Верхняя шапка
    Sidebar     = Color3.fromRGB(18, 18, 18),       -- Сайдбар
    Element     = Color3.fromRGB(25, 25, 25),       -- Фон элементов
    Stroke      = Color3.fromRGB(50, 50, 50),       -- Рамки
    Accent      = Color3.fromRGB(255, 215, 0),      -- ЖЕЛТЫЙ (Gold)
    Text        = Color3.fromRGB(240, 240, 240),    -- Текст
    TextDark    = Color3.fromRGB(160, 160, 160)     -- Темный текст
}

-- // ВСПОМОГАТЕЛЬНЫЕ ФУНКЦИИ //
local function AddStroke(instance, thickness, color)
    local stroke = Instance.new("UIStroke")
    stroke.Thickness = thickness or 1
    stroke.Color = color or Colors.Stroke
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Parent = instance
    return stroke
end

local function MakeDraggable(trigger, object)
    local Dragging, DragInput, DragStart, StartPosition
    
    local function Update(input)
        local Delta = input.Position - DragStart
        object.Position = UDim2.new(StartPosition.X.Scale, StartPosition.X.Offset + Delta.X, StartPosition.Y.Scale, StartPosition.Y.Offset + Delta.Y)
    end
    
    trigger.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            Dragging = true
            DragStart = input.Position
            StartPosition = object.Position
            
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

-- // ГЛАВНОЕ ОКНО //
function Library:Window(Subtitle)
    local UI = {}
    
    -- Удаление старой версии
    if CoreGui:FindFirstChild("PulseUI_v4") then
        CoreGui.PulseUI_v4:Destroy()
    end

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "PulseUI_v4"
    ScreenGui.Parent = CoreGui
    ScreenGui.ResetOnSpawn = false

    -- 1. ОСНОВНОЙ ФРЕЙМ
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 550, 0, 360)
    MainFrame.Position = UDim2.new(0.5, -275, 0.5, -180)
    MainFrame.BackgroundColor3 = Colors.Main
    MainFrame.BackgroundTransparency = Config.Transparency -- Прозрачность
    MainFrame.BorderSizePixel = 0
    MainFrame.Parent = ScreenGui
    
    local MainCorner = Instance.new("UICorner"); MainCorner.CornerRadius = UDim.new(0, Config.CornerRadius); MainCorner.Parent = MainFrame
    AddStroke(MainFrame, 2, Color3.fromRGB(60,60,60)) -- Внешняя обводка

    -- 2. ВЕРХНЯЯ ШАПКА (HEADER)
    local Header = Instance.new("Frame")
    Header.Name = "Header"
    Header.Size = UDim2.new(1, 0, 0, 45) -- Высота шапки
    Header.BackgroundColor3 = Colors.Header
    Header.BackgroundTransparency = Config.Transparency
    Header.BorderSizePixel = 0
    Header.Parent = MainFrame

    local HeaderCorner = Instance.new("UICorner"); HeaderCorner.CornerRadius = UDim.new(0, Config.CornerRadius); HeaderCorner.Parent = Header
    -- Убираем закругление снизу шапки, чтобы она стыковалась с низом
    local HeaderFix = Instance.new("Frame"); HeaderFix.Size = UDim2.new(1, 0, 0, 10); HeaderFix.Position = UDim2.new(0, 0, 1, -10); HeaderFix.BackgroundColor3 = Colors.Header; HeaderFix.BackgroundTransparency = Config.Transparency; HeaderFix.BorderSizePixel = 0; HeaderFix.Parent = Header

    -- Линия разделитель под шапкой
    local HeaderLine = Instance.new("Frame")
    HeaderLine.Size = UDim2.new(1, 0, 0, 1)
    HeaderLine.Position = UDim2.new(0, 0, 1, 0)
    HeaderLine.BackgroundColor3 = Colors.Stroke
    HeaderLine.BorderSizePixel = 0
    HeaderLine.Parent = Header

    MakeDraggable(Header, MainFrame) -- Перетаскивание за шапку

    -- Логотип Pulse UI
    local TitleBox = Instance.new("Frame")
    TitleBox.Size = UDim2.new(0, 200, 1, 0)
    TitleBox.BackgroundTransparency = 1
    TitleBox.Parent = Header

    local PulseText = Instance.new("TextLabel")
    PulseText.Text = "Pulse"
    PulseText.Font = Enum.Font.GothamBlack
    PulseText.TextSize = 20
    PulseText.TextColor3 = Colors.Text
    PulseText.Size = UDim2.new(0, 55, 1, 0)
    PulseText.Position = UDim2.new(0, 15, 0, 0)
    PulseText.BackgroundTransparency = 1
    PulseText.TextXAlignment = Enum.TextXAlignment.Left
    PulseText.Parent = TitleBox

    local UIText = Instance.new("TextLabel")
    UIText.Text = "UI"
    UIText.Font = Enum.Font.GothamBlack
    UIText.TextSize = 20
    UIText.TextColor3 = Colors.Accent -- Желтый
    UIText.Size = UDim2.new(0, 30, 1, 0)
    UIText.Position = UDim2.new(0, 70, 0, 0)
    UIText.BackgroundTransparency = 1
    UIText.TextXAlignment = Enum.TextXAlignment.Left
    UIText.Parent = TitleBox

    -- Название Скрипта (Subtitle)
    local SubLabel = Instance.new("TextLabel")
    SubLabel.Text = Subtitle or "Script"
    SubLabel.Font = Enum.Font.GothamBold
    SubLabel.TextSize = 13
    SubLabel.TextColor3 = Colors.TextDark
    SubLabel.Size = UDim2.new(0, 200, 1, 0)
    SubLabel.Position = UDim2.new(1, -215, 0, 0)
    SubLabel.BackgroundTransparency = 1
    SubLabel.TextXAlignment = Enum.TextXAlignment.Right
    SubLabel.Parent = Header

    -- 3. САЙДБАР (ЛЕВАЯ ПАНЕЛЬ)
    local Sidebar = Instance.new("Frame")
    Sidebar.Name = "Sidebar"
    Sidebar.Size = UDim2.new(0, 160, 1, -46) -- Высота минус шапка
    Sidebar.Position = UDim2.new(0, 0, 0, 46)
    Sidebar.BackgroundColor3 = Colors.Sidebar
    Sidebar.BackgroundTransparency = Config.Transparency + 0.05
    Sidebar.BorderSizePixel = 0
    Sidebar.Parent = MainFrame

    local SideCorner = Instance.new("UICorner"); SideCorner.CornerRadius = UDim.new(0, Config.CornerRadius); SideCorner.Parent = Sidebar
    local SideFixTop = Instance.new("Frame"); SideFixTop.Size = UDim2.new(1, 0, 0, 10); SideFixTop.Position = UDim2.new(0, 0, 0, 0); SideFixTop.BackgroundColor3 = Colors.Sidebar; SideFixTop.BackgroundTransparency = Config.Transparency + 0.05; SideFixTop.BorderSizePixel = 0; SideFixTop.Parent = Sidebar
    local SideFixRight = Instance.new("Frame"); SideFixRight.Size = UDim2.new(0, 10, 1, 0); SideFixRight.Position = UDim2.new(1, -10, 0, 0); SideFixRight.BackgroundColor3 = Colors.Sidebar; SideFixRight.BackgroundTransparency = Config.Transparency + 0.05; SideFixRight.BorderSizePixel = 0; SideFixRight.Parent = Sidebar

    -- Разделитель справа от сайдбара
    local SideLine = Instance.new("Frame")
    SideLine.Size = UDim2.new(0, 1, 1, 0)
    SideLine.Position = UDim2.new(1, 0, 0, 0)
    SideLine.BackgroundColor3 = Colors.Stroke
    SideLine.BorderSizePixel = 0
    SideLine.Parent = Sidebar

    -- Контейнер для кнопок вкладок
    local TabContainer = Instance.new("ScrollingFrame")
    TabContainer.Size = UDim2.new(1, -10, 1, -60)
    TabContainer.Position = UDim2.new(0, 5, 0, 10)
    TabContainer.BackgroundTransparency = 1
    TabContainer.ScrollBarThickness = 0
    TabContainer.Parent = Sidebar

    local TabList = Instance.new("UIListLayout")
    TabList.Padding = UDim.new(0, 8)
    TabList.SortOrder = Enum.SortOrder.LayoutOrder
    TabList.HorizontalAlignment = Enum.HorizontalAlignment.Center
    TabList.Parent = TabContainer

    -- 4. ПРОФИЛЬ (Внизу сайдбара)
    local Profile = Instance.new("Frame")
    Profile.Size = UDim2.new(1, -20, 0, 40)
    Profile.Position = UDim2.new(0, 10, 1, -50)
    Profile.BackgroundColor3 = Color3.fromRGB(0,0,0)
    Profile.BackgroundTransparency = 0.5
    Profile.Parent = Sidebar
    local ProfCorner = Instance.new("UICorner"); ProfCorner.CornerRadius = UDim.new(0, 8); ProfCorner.Parent = Profile
    AddStroke(Profile, 1, Colors.Stroke)

    local Avatar = Instance.new("ImageLabel")
    Avatar.Size = UDim2.new(0, 26, 0, 26)
    Avatar.Position = UDim2.new(0, 7, 0.5, -13)
    Avatar.BackgroundTransparency = 1
    Avatar.Image = Players:GetUserThumbnailAsync(LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size48x48)
    Avatar.Parent = Profile
    local AvCorn = Instance.new("UICorner"); AvCorn.CornerRadius = UDim.new(1, 0); AvCorn.Parent = Avatar

    local NameLabel = Instance.new("TextLabel")
    NameLabel.Text = LocalPlayer.Name
    NameLabel.Size = UDim2.new(1, -40, 1, 0)
    NameLabel.Position = UDim2.new(0, 40, 0, 0)
    NameLabel.Font = Enum.Font.GothamBold
    NameLabel.TextSize = 11
    NameLabel.TextColor3 = Colors.Text
    NameLabel.BackgroundTransparency = 1
    NameLabel.TextXAlignment = Enum.TextXAlignment.Left
    NameLabel.Parent = Profile

    -- 5. КОНТЕЙНЕР СТРАНИЦ (СПРАВА)
    local Pages = Instance.new("Frame")
    Pages.Size = UDim2.new(1, -170, 1, -56)
    Pages.Position = UDim2.new(0, 170, 0, 56)
    Pages.BackgroundTransparency = 1
    Pages.Parent = MainFrame

    local FirstTab = true

    -- == ЛОГИКА ТАБОВ ==
    function UI:Tab(Name)
        local TabFuncs = {}
        
        -- Кнопка Таба
        local TabBtn = Instance.new("TextButton")
        TabBtn.Text = Name
        TabBtn.Size = UDim2.new(1, 0, 0, 32)
        TabBtn.BackgroundColor3 = Colors.Element
        TabBtn.BackgroundTransparency = 1 -- По умолчанию прозрачная
        TabBtn.TextColor3 = Colors.TextDark
        TabBtn.Font = Enum.Font.GothamBold
        TabBtn.TextSize = 12
        TabBtn.AutoButtonColor = false
        TabBtn.Parent = TabContainer
        
        local BtnCorner = Instance.new("UICorner"); BtnCorner.CornerRadius = UDim.new(0, 8); BtnCorner.Parent = TabBtn

        -- Страница
        local Page = Instance.new("ScrollingFrame")
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

        local function Activate()
            -- Сброс
            for _, v in pairs(TabContainer:GetChildren()) do
                if v:IsA("TextButton") then
                    TweenService:Create(v, TweenInfo.new(0.2), {BackgroundTransparency = 1, TextColor3 = Colors.TextDark}):Play()
                end
            end
            for _, p in pairs(Pages:GetChildren()) do p.Visible = false end
            
            -- Актив
            Page.Visible = true
            TweenService:Create(TabBtn, TweenInfo.new(0.2), {BackgroundTransparency = 0, TextColor3 = Colors.Accent}):Play()
        end

        TabBtn.MouseButton1Click:Connect(Activate)

        if FirstTab then
            FirstTab = false
            Activate()
        end

        -- == ЭЛЕМЕНТЫ ==
        
        -- BUTTON
        function TabFuncs:Button(Text, Callback)
            local Btn = Instance.new("TextButton")
            Btn.Size = UDim2.new(1, -5, 0, 36)
            Btn.BackgroundColor3 = Colors.Element
            Btn.BackgroundTransparency = Config.Transparency
            Btn.Text = ""
            Btn.AutoButtonColor = false
            Btn.Parent = Page
            
            local UIC = Instance.new("UICorner"); UIC.CornerRadius = UDim.new(0, 6); UIC.Parent = Btn
            local Stroke = AddStroke(Btn, 1, Colors.Stroke)

            local Label = Instance.new("TextLabel")
            Label.Text = Text
            Label.Size = UDim2.new(1, -30, 1, 0)
            Label.Position = UDim2.new(0, 10, 0, 0)
            Label.BackgroundTransparency = 1
            Label.Font = Enum.Font.GothamBold
            Label.TextColor3 = Colors.Text
            Label.TextSize = 12
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.Parent = Btn
            
            local Icon = Instance.new("ImageLabel")
            Icon.Image = "rbxassetid://6031091004"
            Icon.Size = UDim2.new(0, 18, 0, 18)
            Icon.Position = UDim2.new(1, -28, 0.5, -9)
            Icon.BackgroundTransparency = 1
            Icon.ImageColor3 = Colors.TextDark
            Icon.Parent = Btn

            Btn.MouseButton1Click:Connect(function()
                Callback()
                TweenService:Create(Stroke, TweenInfo.new(0.1), {Color = Colors.Accent}):Play()
                wait(0.15)
                TweenService:Create(Stroke, TweenInfo.new(0.2), {Color = Colors.Stroke}):Play()
            end)
        end

        -- TOGGLE
        function TabFuncs:Toggle(Text, Default, Callback)
            local Toggled = Default or false
            
            local Tgl = Instance.new("TextButton")
            Tgl.Size = UDim2.new(1, -5, 0, 36)
            Tgl.BackgroundColor3 = Colors.Element
            Tgl.BackgroundTransparency = Config.Transparency
            Tgl.Text = ""
            Tgl.AutoButtonColor = false
            Tgl.Parent = Page
            
            local UIC = Instance.new("UICorner"); UIC.CornerRadius = UDim.new(0, 6); UIC.Parent = Tgl
            local Stroke = AddStroke(Tgl, 1, Colors.Stroke)

            local Label = Instance.new("TextLabel")
            Label.Text = Text
            Label.Size = UDim2.new(1, -50, 1, 0)
            Label.Position = UDim2.new(0, 10, 0, 0)
            Label.BackgroundTransparency = 1
            Label.Font = Enum.Font.GothamBold
            Label.TextColor3 = Colors.Text
            Label.TextSize = 12
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.Parent = Tgl

            local Box = Instance.new("Frame")
            Box.Size = UDim2.new(0, 20, 0, 20)
            Box.Position = UDim2.new(1, -30, 0.5, -10)
            Box.BackgroundColor3 = Toggled and Colors.Accent or Color3.fromRGB(40,40,40)
            Box.Parent = Tgl
            local BoxC = Instance.new("UICorner"); BoxC.CornerRadius = UDim.new(0, 4); BoxC.Parent = Box
            
            local function Update()
                if Toggled then
                    TweenService:Create(Box, TweenInfo.new(0.2), {BackgroundColor3 = Colors.Accent}):Play()
                    TweenService:Create(Label, TweenInfo.new(0.2), {TextColor3 = Colors.Accent}):Play()
                    TweenService:Create(Stroke, TweenInfo.new(0.2), {Color = Colors.Accent}):Play()
                else
                    TweenService:Create(Box, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(40,40,40)}):Play()
                    TweenService:Create(Label, TweenInfo.new(0.2), {TextColor3 = Colors.Text}):Play()
                    TweenService:Create(Stroke, TweenInfo.new(0.2), {Color = Colors.Stroke}):Play()
                end
                Callback(Toggled)
            end
            
            if Toggled then Update() end
            
            Tgl.MouseButton1Click:Connect(function()
                Toggled = not Toggled
                Update()
            end)
        end

        -- SLIDER
        function TabFuncs:Slider(Text, Min, Max, Default, Callback)
            local Value = Default or Min
            local Dragging = false
            
            local Sld = Instance.new("Frame")
            Sld.Size = UDim2.new(1, -5, 0, 46)
            Sld.BackgroundColor3 = Colors.Element
            Sld.BackgroundTransparency = Config.Transparency
            Sld.Parent = Page
            
            local UIC = Instance.new("UICorner"); UIC.CornerRadius = UDim.new(0, 6); UIC.Parent = Sld
            local Stroke = AddStroke(Sld, 1, Colors.Stroke)

            local Label = Instance.new("TextLabel")
            Label.Text = Text
            Label.Size = UDim2.new(1, -10, 0, 20)
            Label.Position = UDim2.new(0, 10, 0, 4)
            Label.BackgroundTransparency = 1
            Label.Font = Enum.Font.GothamBold
            Label.TextColor3 = Colors.Text
            Label.TextSize = 12
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.Parent = Sld
            
            local ValLabel = Instance.new("TextLabel")
            ValLabel.Text = tostring(Value)
            ValLabel.Size = UDim2.new(0, 40, 0, 20)
            ValLabel.Position = UDim2.new(1, -50, 0, 4)
            ValLabel.BackgroundTransparency = 1
            ValLabel.Font = Enum.Font.GothamBold
            ValLabel.TextColor3 = Colors.Accent
            ValLabel.TextSize = 12
            ValLabel.TextXAlignment = Enum.TextXAlignment.Right
            ValLabel.Parent = Sld

            local Bar = Instance.new("Frame")
            Bar.Size = UDim2.new(1, -20, 0, 5)
            Bar.Position = UDim2.new(0, 10, 0, 32)
            Bar.BackgroundColor3 = Color3.fromRGB(40,40,40)
            Bar.BorderSizePixel = 0
            Bar.Parent = Sld
            local BarC = Instance.new("UICorner"); BarC.CornerRadius = UDim.new(1,0); BarC.Parent = Bar
            
            local Fill = Instance.new("Frame")
            Fill.Size = UDim2.new((Value - Min) / (Max - Min), 0, 1, 0)
            Fill.BackgroundColor3 = Colors.Accent
            Fill.BorderSizePixel = 0
            Fill.Parent = Bar
            local FillC = Instance.new("UICorner"); FillC.CornerRadius = UDim.new(1,0); FillC.Parent = Fill

            local Trigger = Instance.new("TextButton")
            Trigger.Size = UDim2.new(1, 0, 1, 0)
            Trigger.BackgroundTransparency = 1
            Trigger.Text = ""
            Trigger.Parent = Sld
            
            local function Update(input)
                local pos = math.clamp((input.Position.X - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X, 0, 1)
                local val = math.floor(((pos * (Max - Min)) + Min) * 10) / 10
                Fill:TweenSize(UDim2.new(pos, 0, 1, 0), "Out", "Sine", 0.05, true)
                ValLabel.Text = tostring(val)
                Callback(val)
            end
            
            Trigger.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    Dragging = true
                    TweenService:Create(Stroke, TweenInfo.new(0.2), {Color = Colors.Accent}):Play()
                    Update(input)
                end
            end)
            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    Dragging = false
                    TweenService:Create(Stroke, TweenInfo.new(0.2), {Color = Colors.Stroke}):Play()
                end
            end)
            UserInputService.InputChanged:Connect(function(input)
                if Dragging and input.UserInputType == Enum.UserInputType.MouseMovement then Update(input) end
            end)
        end

        return TabFuncs
    end
    
    return UI
end

return Library
