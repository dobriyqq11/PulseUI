--[[ 
    PulseUI Library (v3 Final)
    Style: Professional, Dark, Yellow Accent, Custom Logo
]]

local Library = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")

-- // ЦВЕТОВАЯ ПАЛИТРА //
local Colors = {
    Main        = Color3.fromRGB(15, 15, 15),       -- Основной фон (очень темный)
    Sidebar     = Color3.fromRGB(20, 20, 20),       -- Сайдбар
    Element     = Color3.fromRGB(25, 25, 25),       -- Фон кнопок
    Stroke      = Color3.fromRGB(45, 45, 45),       -- Цвет рамок
    Accent      = Color3.fromRGB(255, 200, 0),      -- ЖЕЛТЫЙ (Pulse Gold)
    Text        = Color3.fromRGB(255, 255, 255),    -- Белый текст
    TextDark    = Color3.fromRGB(140, 140, 140)     -- Серый текст
}

-- // УТИЛИТЫ //
local function AddStroke(instance, thickness, color)
    local stroke = Instance.new("UIStroke")
    stroke.Thickness = thickness or 1
    stroke.Color = color or Colors.Stroke
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Parent = instance
    return stroke
end

local function MakeDraggable(topbarobject, object)
    local Dragging, DragInput, DragStart, StartPosition
    
    local function Update(input)
        local Delta = input.Position - DragStart
        local Position = UDim2.new(StartPosition.X.Scale, StartPosition.X.Offset + Delta.X, StartPosition.Y.Scale, StartPosition.Y.Offset + Delta.Y)
        object.Position = Position
    end
    
    topbarobject.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            Dragging = true
            DragStart = input.Position
            StartPosition = object.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then Dragging = false end
            end)
        end
    end)
    
    topbarobject.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            DragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == DragInput and Dragging then Update(input) end
    end)
end

-- // ОСНОВНАЯ ФУНКЦИЯ //
function Library:Window(SubtitleText)
    local UI = {}
    
    -- Очистка старого UI
    for _, v in pairs(CoreGui:GetChildren()) do
        if v.Name == "PulseUI_Lib" then v:Destroy() end
    end

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "PulseUI_Lib"
    ScreenGui.Parent = CoreGui
    ScreenGui.ResetOnSpawn = false

    -- === MAIN WINDOW ===
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 520, 0, 350) -- Компактный размер
    MainFrame.Position = UDim2.new(0.5, -260, 0.5, -175)
    MainFrame.BackgroundColor3 = Colors.Main
    MainFrame.BorderSizePixel = 0
    MainFrame.Parent = ScreenGui
    
    local MainCorner = Instance.new("UICorner"); MainCorner.CornerRadius = UDim.new(0, 8); MainCorner.Parent = MainFrame
    AddStroke(MainFrame, 2, Color3.fromRGB(60, 60, 60)) -- Жирная обводка окна

    MakeDraggable(MainFrame, MainFrame)

    -- === SIDEBAR ===
    local Sidebar = Instance.new("Frame")
    Sidebar.Name = "Sidebar"
    Sidebar.Size = UDim2.new(0, 150, 1, 0)
    Sidebar.BackgroundColor3 = Colors.Sidebar
    Sidebar.BorderSizePixel = 0
    Sidebar.Parent = MainFrame
    
    local SideCorner = Instance.new("UICorner"); SideCorner.CornerRadius = UDim.new(0, 8); SideCorner.Parent = Sidebar
    -- Fix Right Corner
    local Fix = Instance.new("Frame"); Fix.Size = UDim2.new(0, 10, 1, 0); Fix.Position = UDim2.new(1, -10, 0, 0); Fix.BackgroundColor3 = Colors.Sidebar; Fix.BorderSizePixel = 0; Fix.Parent = Sidebar
    
    -- Разделитель
    local Sep = Instance.new("Frame")
    Sep.Size = UDim2.new(0, 1, 1, 0)
    Sep.Position = UDim2.new(1, 0, 0, 0)
    Sep.BackgroundColor3 = Colors.Stroke
    Sep.BorderSizePixel = 0
    Sep.Parent = Sidebar

    -- === КРАСИВЫЙ ЗАГОЛОВОК (Pulse UI) ===
    local Header = Instance.new("Frame")
    Header.Size = UDim2.new(1, 0, 0, 50)
    Header.BackgroundTransparency = 1
    Header.Parent = Sidebar

    local TitlePulse = Instance.new("TextLabel")
    TitlePulse.Text = "Pulse"
    TitlePulse.Size = UDim2.new(0, 50, 1, 0)
    TitlePulse.Position = UDim2.new(0, 15, 0, 0)
    TitlePulse.Font = Enum.Font.GothamBlack
    TitlePulse.TextSize = 22
    TitlePulse.TextColor3 = Colors.Text
    TitlePulse.BackgroundTransparency = 1
    TitlePulse.TextXAlignment = Enum.TextXAlignment.Left
    TitlePulse.Parent = Header

    local TitleUI = Instance.new("TextLabel")
    TitleUI.Text = "UI"
    TitleUI.Size = UDim2.new(0, 30, 1, 0)
    TitleUI.Position = UDim2.new(0, 75, 0, 0) -- Сдвиг после "Pulse"
    TitleUI.Font = Enum.Font.GothamBlack
    TitleUI.TextSize = 22
    TitleUI.TextColor3 = Colors.Accent -- ЖЕЛТЫЙ ЦВЕТ
    TitleUI.BackgroundTransparency = 1
    TitleUI.TextXAlignment = Enum.TextXAlignment.Left
    TitleUI.Parent = Header

    -- Подзаголовок (Название скрипта)
    local SubLabel = Instance.new("TextLabel")
    SubLabel.Text = SubtitleText or "Script Hub"
    SubLabel.Size = UDim2.new(1, -20, 0, 15)
    SubLabel.Position = UDim2.new(0, 15, 0, 35)
    SubLabel.Font = Enum.Font.GothamBold
    SubLabel.TextSize = 10
    SubLabel.TextColor3 = Colors.TextDark
    SubLabel.BackgroundTransparency = 1
    SubLabel.TextXAlignment = Enum.TextXAlignment.Left
    SubLabel.Parent = Header

    -- === TABS CONTAINER ===
    local TabContainer = Instance.new("ScrollingFrame")
    TabContainer.Size = UDim2.new(1, 0, 1, -110)
    TabContainer.Position = UDim2.new(0, 0, 0, 60)
    TabContainer.BackgroundTransparency = 1
    TabContainer.ScrollBarThickness = 0
    TabContainer.Parent = Sidebar
    
    local TabList = Instance.new("UIListLayout")
    TabList.Padding = UDim.new(0, 5)
    TabList.SortOrder = Enum.SortOrder.LayoutOrder
    TabList.HorizontalAlignment = Enum.HorizontalAlignment.Center
    TabList.Parent = TabContainer

    -- === PROFILE ===
    local Profile = Instance.new("Frame")
    Profile.Size = UDim2.new(1, -20, 0, 40)
    Profile.Position = UDim2.new(0, 10, 1, -50)
    Profile.BackgroundColor3 = Colors.Element
    Profile.Parent = Sidebar
    local ProfCorn = Instance.new("UICorner"); ProfCorn.CornerRadius = UDim.new(0, 6); ProfCorn.Parent = Profile
    AddStroke(Profile, 1, Colors.Stroke)

    local Avatar = Instance.new("ImageLabel")
    Avatar.Size = UDim2.new(0, 26, 0, 26)
    Avatar.Position = UDim2.new(0, 7, 0.5, -13)
    Avatar.BackgroundColor3 = Colors.Main
    Avatar.Image = Players:GetUserThumbnailAsync(LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size48x48)
    Avatar.Parent = Profile
    local AvCorn = Instance.new("UICorner"); AvCorn.CornerRadius = UDim.new(0, 4); AvCorn.Parent = Avatar

    local NameInfo = Instance.new("TextLabel")
    NameInfo.Text = LocalPlayer.DisplayName
    NameInfo.Size = UDim2.new(1, -45, 1, 0)
    NameInfo.Position = UDim2.new(0, 42, 0, 0)
    NameInfo.Font = Enum.Font.GothamBold
    NameInfo.TextSize = 11
    NameInfo.TextColor3 = Colors.Text
    NameInfo.BackgroundTransparency = 1
    NameInfo.TextXAlignment = Enum.TextXAlignment.Left
    NameInfo.Parent = Profile

    -- === PAGES ===
    local Pages = Instance.new("Frame")
    Pages.Size = UDim2.new(1, -160, 1, -20)
    Pages.Position = UDim2.new(0, 160, 0, 10)
    Pages.BackgroundTransparency = 1
    Pages.Parent = MainFrame

    local FirstTab = true

    function UI:Tab(Name)
        local Functions = {}
        
        -- Кнопка
        local TabBtn = Instance.new("TextButton")
        TabBtn.Text = Name
        TabBtn.Size = UDim2.new(0, 130, 0, 30)
        TabBtn.BackgroundColor3 = Colors.Element
        TabBtn.BackgroundTransparency = 1
        TabBtn.TextColor3 = Colors.TextDark
        TabBtn.Font = Enum.Font.GothamBold
        TabBtn.TextSize = 13
        TabBtn.AutoButtonColor = false
        TabBtn.Parent = TabContainer
        
        local TabCorner = Instance.new("UICorner"); TabCorner.CornerRadius = UDim.new(0, 6); TabCorner.Parent = TabBtn

        -- Страница
        local Page = Instance.new("ScrollingFrame")
        Page.Size = UDim2.new(1, 0, 1, 0)
        Page.BackgroundTransparency = 1
        Page.ScrollBarThickness = 2
        Page.ScrollBarImageColor3 = Colors.Accent
        Page.Visible = false
        Page.Parent = Pages
        
        local PageLayout = Instance.new("UIListLayout")
        PageLayout.Padding = UDim.new(0, 6)
        PageLayout.SortOrder = Enum.SortOrder.LayoutOrder
        PageLayout.Parent = Page
        
        PageLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            Page.CanvasSize = UDim2.new(0, 0, 0, PageLayout.AbsoluteContentSize.Y + 10)
        end)

        -- Логика переключения
        local function Activate()
            for _, v in pairs(TabContainer:GetChildren()) do
                if v:IsA("TextButton") then
                    TweenService:Create(v, TweenInfo.new(0.2), {BackgroundTransparency = 1, TextColor3 = Colors.TextDark}):Play()
                end
            end
            for _, p in pairs(Pages:GetChildren()) do p.Visible = false end
            
            Page.Visible = true
            TweenService:Create(TabBtn, TweenInfo.new(0.2), {BackgroundTransparency = 0, TextColor3 = Colors.Accent}):Play()
        end

        TabBtn.MouseButton1Click:Connect(Activate)

        if FirstTab then
            FirstTab = false
            Activate()
        end

        -- [[ ЭЛЕМЕНТЫ ]] --

        -- BUTTON
        function Functions:Button(Text, Callback)
            local Btn = Instance.new("TextButton")
            Btn.Size = UDim2.new(1, -5, 0, 34)
            Btn.BackgroundColor3 = Colors.Element
            Btn.Text = ""
            Btn.AutoButtonColor = false
            Btn.Parent = Page
            
            local Corner = Instance.new("UICorner"); Corner.CornerRadius = UDim.new(0, 6); Corner.Parent = Btn
            local Stroke = AddStroke(Btn, 1, Colors.Stroke)

            local Label = Instance.new("TextLabel")
            Label.Text = Text
            Label.Size = UDim2.new(1, -10, 1, 0)
            Label.Position = UDim2.new(0, 10, 0, 0)
            Label.BackgroundTransparency = 1
            Label.Font = Enum.Font.GothamBold
            Label.TextSize = 12
            Label.TextColor3 = Colors.Text
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.Parent = Btn
            
            local Icon = Instance.new("ImageLabel")
            Icon.Size = UDim2.new(0, 16, 0, 16)
            Icon.Position = UDim2.new(1, -26, 0.5, -8)
            Icon.BackgroundTransparency = 1
            Icon.Image = "rbxassetid://6031091004" -- Mouse Click Icon
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
        function Functions:Toggle(Text, Default, Callback)
            local Toggled = Default or false
            
            local Tgl = Instance.new("TextButton")
            Tgl.Size = UDim2.new(1, -5, 0, 34)
            Tgl.BackgroundColor3 = Colors.Element
            Tgl.Text = ""
            Tgl.AutoButtonColor = false
            Tgl.Parent = Page
            
            local Corner = Instance.new("UICorner"); Corner.CornerRadius = UDim.new(0, 6); Corner.Parent = Tgl
            local Stroke = AddStroke(Tgl, 1, Colors.Stroke)

            local Label = Instance.new("TextLabel")
            Label.Text = Text
            Label.Size = UDim2.new(1, -50, 1, 0)
            Label.Position = UDim2.new(0, 10, 0, 0)
            Label.BackgroundTransparency = 1
            Label.Font = Enum.Font.GothamBold
            Label.TextSize = 12
            Label.TextColor3 = Colors.Text
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.Parent = Tgl

            local Box = Instance.new("Frame")
            Box.Size = UDim2.new(0, 20, 0, 20)
            Box.Position = UDim2.new(1, -30, 0.5, -10)
            Box.BackgroundColor3 = Toggled and Colors.Accent or Color3.fromRGB(35,35,35)
            Box.Parent = Tgl
            local BoxCorn = Instance.new("UICorner"); BoxCorn.CornerRadius = UDim.new(0, 4); BoxCorn.Parent = Box
            local BoxStroke = AddStroke(Box, 1, Toggled and Colors.Accent or Colors.Stroke)

            local function Update()
                if Toggled then
                    TweenService:Create(Box, TweenInfo.new(0.2), {BackgroundColor3 = Colors.Accent}):Play()
                    TweenService:Create(BoxStroke, TweenInfo.new(0.2), {Color = Colors.Accent}):Play()
                    TweenService:Create(Stroke, TweenInfo.new(0.2), {Color = Colors.Accent}):Play()
                    TweenService:Create(Label, TweenInfo.new(0.2), {TextColor3 = Colors.Accent}):Play()
                else
                    TweenService:Create(Box, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(35,35,35)}):Play()
                    TweenService:Create(BoxStroke, TweenInfo.new(0.2), {Color = Colors.Stroke}):Play()
                    TweenService:Create(Stroke, TweenInfo.new(0.2), {Color = Colors.Stroke}):Play()
                    TweenService:Create(Label, TweenInfo.new(0.2), {TextColor3 = Colors.Text}):Play()
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
        function Functions:Slider(Text, Min, Max, Default, Callback)
            local Value = Default or Min
            local Dragging = false
            
            local Sld = Instance.new("Frame")
            Sld.Size = UDim2.new(1, -5, 0, 45)
            Sld.BackgroundColor3 = Colors.Element
            Sld.Parent = Page
            
            local Corner = Instance.new("UICorner"); Corner.CornerRadius = UDim.new(0, 6); Corner.Parent = Sld
            local Stroke = AddStroke(Sld, 1, Colors.Stroke)

            local Label = Instance.new("TextLabel")
            Label.Text = Text
            Label.Size = UDim2.new(1, -10, 0, 20)
            Label.Position = UDim2.new(0, 10, 0, 5)
            Label.BackgroundTransparency = 1
            Label.Font = Enum.Font.GothamBold
            Label.TextSize = 12
            Label.TextColor3 = Colors.Text
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.Parent = Sld
            
            local ValLabel = Instance.new("TextLabel")
            ValLabel.Text = tostring(Value)
            ValLabel.Size = UDim2.new(0, 40, 0, 20)
            ValLabel.Position = UDim2.new(1, -50, 0, 5)
            ValLabel.BackgroundTransparency = 1
            ValLabel.Font = Enum.Font.GothamBold
            ValLabel.TextSize = 12
            ValLabel.TextColor3 = Colors.Accent
            ValLabel.TextXAlignment = Enum.TextXAlignment.Right
            ValLabel.Parent = Sld

            local Bar = Instance.new("Frame")
            Bar.Size = UDim2.new(1, -20, 0, 4)
            Bar.Position = UDim2.new(0, 10, 0, 32)
            Bar.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
            Bar.Parent = Sld
            local BarC = Instance.new("UICorner"); BarC.CornerRadius = UDim.new(1,0); BarC.Parent = Bar
            
            local Fill = Instance.new("Frame")
            Fill.Size = UDim2.new((Value - Min) / (Max - Min), 0, 1, 0)
            Fill.BackgroundColor3 = Colors.Accent
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

        return Functions
    end
    
    return UI
end

return Library
