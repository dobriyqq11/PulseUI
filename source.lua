--[[ 
    Custom UI Library by ChatGPT
    Style: Modern Dark / Sidebar Profile
]]

local Library = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Настройки цветов
local Colors = {
    Background = Color3.fromRGB(25, 25, 25),       -- Основной фон
    Sidebar = Color3.fromRGB(30, 30, 30),          -- Боковая панель
    Element = Color3.fromRGB(40, 40, 40),          -- Фон кнопок
    Hover = Color3.fromRGB(50, 50, 50),            -- При наведении
    Accent = Color3.fromRGB(0, 120, 215),          -- Акцентный цвет (синий)
    Text = Color3.fromRGB(240, 240, 240),          -- Текст
    TextDark = Color3.fromRGB(150, 150, 150)       -- Вторичный текст
}

-- Функция для драга (перетаскивания)
local function MakeDraggable(topbarobject, object)
    local Dragging = nil
    local DragInput = nil
    local DragStart = nil
    local StartPosition = nil

    local function Update(input)
        local Delta = input.Position - DragStart
        object.Position = UDim2.new(StartPosition.X.Scale, StartPosition.X.Offset + Delta.X, StartPosition.Y.Scale, StartPosition.Y.Offset + Delta.Y)
    end

    topbarobject.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            Dragging = true
            DragStart = input.Position
            StartPosition = object.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    Dragging = false
                end
            end)
        end
    end)

    topbarobject.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            DragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == DragInput and Dragging then
            Update(input)
        end
    end)
end

-- Функция создания основного окна
function Library:Window(Name)
    local UI = {}
    
    -- Создаем ScreenGui
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "CustomLib"
    ScreenGui.Parent = game:GetService("CoreGui") -- Или LocalPlayer.PlayerGui для теста в Studio
    ScreenGui.ResetOnSpawn = false

    -- Главный фрейм
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 600, 0, 400)
    MainFrame.Position = UDim2.new(0.5, -300, 0.5, -200)
    MainFrame.BackgroundColor3 = Colors.Background
    MainFrame.BorderSizePixel = 0
    MainFrame.Parent = ScreenGui
    
    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 10)
    MainCorner.Parent = MainFrame

    MakeDraggable(MainFrame, MainFrame) -- Делаем окно перетаскиваемым

    -- Боковая панель (Sidebar)
    local Sidebar = Instance.new("Frame")
    Sidebar.Name = "Sidebar"
    Sidebar.Size = UDim2.new(0, 180, 1, 0)
    Sidebar.BackgroundColor3 = Colors.Sidebar
    Sidebar.BorderSizePixel = 0
    Sidebar.Parent = MainFrame

    local SidebarCorner = Instance.new("UICorner")
    SidebarCorner.CornerRadius = UDim.new(0, 10)
    SidebarCorner.Parent = Sidebar

    -- Исправляем углы сайдбара (чтобы справа было прямо)
    local FixPatch = Instance.new("Frame")
    FixPatch.Size = UDim2.new(0, 10, 1, 0)
    FixPatch.Position = UDim2.new(1, -10, 0, 0)
    FixPatch.BackgroundColor3 = Colors.Sidebar
    FixPatch.BorderSizePixel = 0
    FixPatch.Parent = Sidebar

    -- Заголовок скрипта
    local Title = Instance.new("TextLabel")
    Title.Text = Name
    Title.Size = UDim2.new(1, -20, 0, 40)
    Title.Position = UDim2.new(0, 10, 0, 10)
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 18
    Title.TextColor3 = Colors.Text
    Title.BackgroundTransparency = 1
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = Sidebar

    -- Контейнер для кнопок вкладок
    local TabButtonContainer = Instance.new("ScrollingFrame")
    TabButtonContainer.Size = UDim2.new(1, 0, 1, -110) -- Оставляем место под профиль
    TabButtonContainer.Position = UDim2.new(0, 0, 0, 60)
    TabButtonContainer.BackgroundTransparency = 1
    TabButtonContainer.ScrollBarThickness = 0
    TabButtonContainer.Parent = Sidebar
    
    local TabListLayout = Instance.new("UIListLayout")
    TabListLayout.Padding = UDim.new(0, 5)
    TabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TabListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    TabListLayout.Parent = TabButtonContainer

    -- Профиль игрока (снизу слева)
    local ProfileFrame = Instance.new("Frame")
    ProfileFrame.Size = UDim2.new(1, -20, 0, 50)
    ProfileFrame.Position = UDim2.new(0, 10, 1, -60)
    ProfileFrame.BackgroundColor3 = Colors.Element
    ProfileFrame.BorderSizePixel = 0
    ProfileFrame.Parent = Sidebar
    
    local ProfileCorner = Instance.new("UICorner")
    ProfileCorner.CornerRadius = UDim.new(0, 8)
    ProfileCorner.Parent = ProfileFrame
    
    local Avatar = Instance.new("ImageLabel")
    Avatar.Size = UDim2.new(0, 36, 0, 36)
    Avatar.Position = UDim2.new(0, 7, 0, 7)
    Avatar.BackgroundColor3 = Color3.new(0,0,0)
    Avatar.BackgroundTransparency = 1
    Avatar.Image = Players:GetUserThumbnailAsync(LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size48x48)
    Avatar.Parent = ProfileFrame
    
    local AvatarCorner = Instance.new("UICorner"); AvatarCorner.CornerRadius = UDim.new(1,0); AvatarCorner.Parent = Avatar
    
    local Username = Instance.new("TextLabel")
    Username.Text = LocalPlayer.Name
    Username.Size = UDim2.new(1, -60, 0, 20)
    Username.Position = UDim2.new(0, 50, 0, 8)
    Username.Font = Enum.Font.GothamBold
    Username.TextSize = 12
    Username.TextColor3 = Colors.Text
    Username.BackgroundTransparency = 1
    Username.TextXAlignment = Enum.TextXAlignment.Left
    Username.Parent = ProfileFrame
    
    local DisplayName = Instance.new("TextLabel")
    DisplayName.Text = "User" -- Можно сделать LocalPlayer.DisplayName
    DisplayName.Size = UDim2.new(1, -60, 0, 15)
    DisplayName.Position = UDim2.new(0, 50, 0, 26)
    DisplayName.Font = Enum.Font.Gotham
    DisplayName.TextSize = 10
    DisplayName.TextColor3 = Colors.TextDark
    DisplayName.BackgroundTransparency = 1
    DisplayName.TextXAlignment = Enum.TextXAlignment.Left
    DisplayName.Parent = ProfileFrame

    -- Контейнер для страниц (справа)
    local PagesContainer = Instance.new("Frame")
    PagesContainer.Size = UDim2.new(1, -200, 1, -20)
    PagesContainer.Position = UDim2.new(0, 190, 0, 10)
    PagesContainer.BackgroundTransparency = 1
    PagesContainer.Parent = MainFrame

    -- Логика вкладок
    local Tabs = {}
    local FirstTab = true

    function UI:Tab(TabName)
        local Tab = {}
        
        -- Кнопка табы
        local TabButton = Instance.new("TextButton")
        TabButton.Text = TabName
        TabButton.Size = UDim2.new(0, 160, 0, 35)
        TabButton.BackgroundColor3 = Colors.Sidebar
        TabButton.TextColor3 = Colors.TextDark
        TabButton.Font = Enum.Font.GothamBold
        TabButton.TextSize = 13
        TabButton.AutoButtonColor = false
        TabButton.Parent = TabButtonContainer
        
        local TabBtnCorner = Instance.new("UICorner"); TabBtnCorner.CornerRadius = UDim.new(0, 6); TabBtnCorner.Parent = TabButton

        -- Страница (скролл)
        local Page = Instance.new("ScrollingFrame")
        Page.Name = TabName .. "_Page"
        Page.Size = UDim2.new(1, 0, 1, 0)
        Page.BackgroundTransparency = 1
        Page.ScrollBarThickness = 2
        Page.ScrollBarImageColor3 = Colors.Accent
        Page.Visible = false
        Page.Parent = PagesContainer
        
        local PageLayout = Instance.new("UIListLayout")
        PageLayout.Padding = UDim.new(0, 8)
        PageLayout.SortOrder = Enum.SortOrder.LayoutOrder
        PageLayout.Parent = Page
        
        PageLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            Page.CanvasSize = UDim2.new(0, 0, 0, PageLayout.AbsoluteContentSize.Y + 10)
        end)

        -- Активация первой табы
        if FirstTab then
            FirstTab = false
            Page.Visible = true
            TabButton.BackgroundColor3 = Colors.Element
            TabButton.TextColor3 = Colors.Text
        end

        -- Клик по табу
        TabButton.MouseButton1Click:Connect(function()
            -- Сброс всех
            for _, btn in pairs(TabButtonContainer:GetChildren()) do
                if btn:IsA("TextButton") then
                    TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Colors.Sidebar, TextColor3 = Colors.TextDark}):Play()
                end
            end
            for _, pg in pairs(PagesContainer:GetChildren()) do
                pg.Visible = false
            end
            
            -- Активация текущей
            Page.Visible = true
            TweenService:Create(TabButton, TweenInfo.new(0.2), {BackgroundColor3 = Colors.Element, TextColor3 = Colors.Text}):Play()
        end)

        -- ЭЛЕМЕНТЫ ВНУТРИ ТАБА --

        -- 1. BUTTON
        function Tab:Button(Text, Callback)
            local Callback = Callback or function() end
            
            local BtnFrame = Instance.new("TextButton")
            BtnFrame.Size = UDim2.new(1, 0, 0, 40)
            BtnFrame.BackgroundColor3 = Colors.Element
            BtnFrame.Text = ""
            BtnFrame.AutoButtonColor = false
            BtnFrame.Parent = Page
            
            local BtnCorner = Instance.new("UICorner"); BtnCorner.CornerRadius = UDim.new(0, 6); BtnCorner.Parent = BtnFrame
            
            local BtnText = Instance.new("TextLabel")
            BtnText.Text = Text
            BtnText.Size = UDim2.new(1, -20, 1, 0)
            BtnText.Position = UDim2.new(0, 10, 0, 0)
            BtnText.BackgroundTransparency = 1
            BtnText.Font = Enum.Font.GothamSemibold
            BtnText.TextColor3 = Colors.Text
            BtnText.TextSize = 14
            BtnText.TextXAlignment = Enum.TextXAlignment.Left
            BtnText.Parent = BtnFrame
            
            -- Icon (стрелочка или что-то подобное)
            local Icon = Instance.new("ImageLabel")
            Icon.Size = UDim2.new(0, 20, 0, 20)
            Icon.Position = UDim2.new(1, -30, 0.5, -10)
            Icon.BackgroundTransparency = 1
            Icon.Image = "rbxassetid://6031094678" -- Иконка "Click"
            Icon.ImageColor3 = Colors.TextDark
            Icon.Parent = BtnFrame

            BtnFrame.MouseButton1Click:Connect(function()
                TweenService:Create(BtnFrame, TweenInfo.new(0.1), {BackgroundColor3 = Colors.Hover}):Play()
                Callback()
                wait(0.1)
                TweenService:Create(BtnFrame, TweenInfo.new(0.2), {BackgroundColor3 = Colors.Element}):Play()
            end)
        end

        -- 2. TOGGLE (Checkbox)
        function Tab:Toggle(Text, Default, Callback)
            local Callback = Callback or function() end
            local Toggled = Default or false
            
            local ToggleFrame = Instance.new("TextButton")
            ToggleFrame.Size = UDim2.new(1, 0, 0, 40)
            ToggleFrame.BackgroundColor3 = Colors.Element
            ToggleFrame.Text = ""
            ToggleFrame.AutoButtonColor = false
            ToggleFrame.Parent = Page
            
            local TglCorner = Instance.new("UICorner"); TglCorner.CornerRadius = UDim.new(0, 6); TglCorner.Parent = ToggleFrame
            
            local TglText = Instance.new("TextLabel")
            TglText.Text = Text
            TglText.Size = UDim2.new(1, -50, 1, 0)
            TglText.Position = UDim2.new(0, 10, 0, 0)
            TglText.BackgroundTransparency = 1
            TglText.Font = Enum.Font.GothamSemibold
            TglText.TextColor3 = Colors.Text
            TglText.TextSize = 14
            TglText.TextXAlignment = Enum.TextXAlignment.Left
            TglText.Parent = ToggleFrame

            -- Квадратик чекбокса
            local CheckBox = Instance.new("Frame")
            CheckBox.Size = UDim2.new(0, 22, 0, 22)
            CheckBox.Position = UDim2.new(1, -35, 0.5, -11)
            CheckBox.BackgroundColor3 = Toggled and Colors.Accent or Color3.fromRGB(60,60,60)
            CheckBox.Parent = ToggleFrame
            
            local CheckCorner = Instance.new("UICorner"); CheckCorner.CornerRadius = UDim.new(0, 4); CheckCorner.Parent = CheckBox

            -- Логика
            ToggleFrame.MouseButton1Click:Connect(function()
                Toggled = not Toggled
                Callback(Toggled)
                
                if Toggled then
                    TweenService:Create(CheckBox, TweenInfo.new(0.2), {BackgroundColor3 = Colors.Accent}):Play()
                else
                    TweenService:Create(CheckBox, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(60,60,60)}):Play()
                end
            end)
        end

        -- 3. SLIDER
        function Tab:Slider(Text, Min, Max, Default, Callback)
            local Callback = Callback or function() end
            local Value = Default or Min
            local Dragging = false
            
            local SliderFrame = Instance.new("Frame")
            SliderFrame.Size = UDim2.new(1, 0, 0, 50) -- Чуть выше
            SliderFrame.BackgroundColor3 = Colors.Element
            SliderFrame.Parent = Page
            
            local SldCorner = Instance.new("UICorner"); SldCorner.CornerRadius = UDim.new(0, 6); SldCorner.Parent = SliderFrame
            
            local SldText = Instance.new("TextLabel")
            SldText.Text = Text
            SldText.Size = UDim2.new(1, -20, 0, 20)
            SldText.Position = UDim2.new(0, 10, 0, 5)
            SldText.BackgroundTransparency = 1
            SldText.Font = Enum.Font.GothamSemibold
            SldText.TextColor3 = Colors.Text
            SldText.TextSize = 14
            SldText.TextXAlignment = Enum.TextXAlignment.Left
            SldText.Parent = SliderFrame
            
            local ValueLabel = Instance.new("TextLabel")
            ValueLabel.Text = tostring(Value)
            ValueLabel.Size = UDim2.new(0, 50, 0, 20)
            ValueLabel.Position = UDim2.new(1, -60, 0, 5)
            ValueLabel.BackgroundTransparency = 1
            ValueLabel.Font = Enum.Font.Gotham
            ValueLabel.TextColor3 = Colors.TextDark
            ValueLabel.TextSize = 12
            ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
            ValueLabel.Parent = SliderFrame

            -- Полоска слайдера
            local SliderBar = Instance.new("Frame")
            SliderBar.Size = UDim2.new(1, -20, 0, 6)
            SliderBar.Position = UDim2.new(0, 10, 0, 35)
            SliderBar.BackgroundColor3 = Color3.fromRGB(60,60,60)
            SliderBar.Parent = SliderFrame
            local BarCorner = Instance.new("UICorner"); BarCorner.CornerRadius = UDim.new(1,0); BarCorner.Parent = SliderBar
            
            local Fill = Instance.new("Frame")
            Fill.Size = UDim2.new((Value - Min) / (Max - Min), 0, 1, 0)
            Fill.BackgroundColor3 = Colors.Accent
            Fill.Parent = SliderBar
            local FillCorner = Instance.new("UICorner"); FillCorner.CornerRadius = UDim.new(1,0); FillCorner.Parent = Fill

            -- Логика движения
            local Trigger = Instance.new("TextButton")
            Trigger.Size = UDim2.new(1, 0, 1, 0)
            Trigger.BackgroundTransparency = 1
            Trigger.Text = ""
            Trigger.Parent = SliderBar
            
            local function UpdateSlide(input)
                local pos = UDim2.new(math.clamp((input.Position.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X, 0, 1), 0, 1, 0)
                Fill:TweenSize(pos, "Out", "Sine", 0.1, true)
                local val = math.floor(((pos.X.Scale * (Max - Min)) + Min) * 10) / 10
                ValueLabel.Text = tostring(val)
                Callback(val)
            end

            Trigger.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    Dragging = true
                    UpdateSlide(input)
                end
            end)
            
            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    Dragging = false
                end
            end)
            
            UserInputService.InputChanged:Connect(function(input)
                if Dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                    UpdateSlide(input)
                end
            end)
        end

        return Tab
    end
    
    return UI
end

return Library
