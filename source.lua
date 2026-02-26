--[[ 
    PulseUI - Custom Library (v2 Refined)
    Style: High Contrast, Yellow Accent, Strokes, Compact
]]

local Library = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")

-- // НАСТРОЙКИ ЦВЕТОВ //
local Colors = {
    Main        = Color3.fromRGB(18, 18, 18),       -- Глубокий темный фон
    Sidebar     = Color3.fromRGB(25, 25, 25),       -- Боковая панель
    Section     = Color3.fromRGB(30, 30, 30),       -- Фон элементов
    Stroke      = Color3.fromRGB(50, 50, 50),       -- Цвет обводки (рамок)
    Accent      = Color3.fromRGB(255, 215, 0),      -- ЖЕЛТЫЙ (Gold)
    Text        = Color3.fromRGB(255, 255, 255),    -- Белый текст
    TextDark    = Color3.fromRGB(130, 130, 130)     -- Серый текст
}

-- // УТИЛИТЫ //
local function MakeDraggable(topbarobject, object)
    local Dragging, DragInput, DragStart, StartPosition
    
    local function Update(input)
        local Delta = input.Position - DragStart
        local Position = UDim2.new(StartPosition.X.Scale, StartPosition.X.Offset + Delta.X, StartPosition.Y.Scale, StartPosition.Y.Offset + Delta.Y)
        TweenService:Create(object, TweenInfo.new(0.1), {Position = Position}):Play()
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

local function AddStroke(instance, thickness, color)
    local stroke = Instance.new("UIStroke")
    stroke.Thickness = thickness or 1
    stroke.Color = color or Colors.Stroke
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Parent = instance
    return stroke
end

-- // ГЛАВНАЯ ФУНКЦИЯ //
function Library:Window(HubName)
    local UI = {}
    
    -- Удаляем старое, если есть
    if CoreGui:FindFirstChild("PulseUI_v2") then
        CoreGui.PulseUI_v2:Destroy()
    end

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "PulseUI_v2"
    ScreenGui.Parent = CoreGui
    ScreenGui.ResetOnSpawn = false

    -- === MAIN FRAME (Уменьшил размер) ===
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 500, 0, 320) -- Компактнее (было 600x400)
    MainFrame.Position = UDim2.new(0.5, -250, 0.5, -160)
    MainFrame.BackgroundColor3 = Colors.Main
    MainFrame.BorderSizePixel = 0
    MainFrame.Parent = ScreenGui
    
    local MainCorner = Instance.new("UICorner"); MainCorner.CornerRadius = UDim.new(0, 6); MainCorner.Parent = MainFrame
    AddStroke(MainFrame, 2, Color3.fromRGB(60, 60, 60)) -- Жирная обводка снаружи

    MakeDraggable(MainFrame, MainFrame)

    -- === SIDEBAR ===
    local Sidebar = Instance.new("Frame")
    Sidebar.Name = "Sidebar"
    Sidebar.Size = UDim2.new(0, 140, 1, 0) -- Уже (было 180)
    Sidebar.BackgroundColor3 = Colors.Sidebar
    Sidebar.BorderSizePixel = 0
    Sidebar.Parent = MainFrame
    
    local SideCorner = Instance.new("UICorner"); SideCorner.CornerRadius = UDim.new(0, 6); SideCorner.Parent = Sidebar
    
    -- Fix Right Corner of Sidebar
    local FixSide = Instance.new("Frame"); FixSide.Size = UDim2.new(0, 10, 1, 0); FixSide.Position = UDim2.new(1, -10, 0, 0); FixSide.BackgroundColor3 = Colors.Sidebar; FixSide.BorderSizePixel = 0; FixSide.Parent = Sidebar

    -- Разделительная линия
    local Sep = Instance.new("Frame")
    Sep.Size = UDim2.new(0, 1, 1, 0)
    Sep.Position = UDim2.new(1, 0, 0, 0)
    Sep.BackgroundColor3 = Colors.Stroke
    Sep.BorderSizePixel = 0
    Sep.Parent = Sidebar

    -- Title
    local Title = Instance.new("TextLabel")
    Title.Text = HubName
    Title.Size = UDim2.new(1, -10, 0, 30)
    Title.Position = UDim2.new(0, 10, 0, 8)
    Title.Font = Enum.Font.GothamBlack -- Максимально жирный
    Title.TextColor3 = Colors.Accent -- Желтый заголовок
    Title.TextSize = 16
    Title.BackgroundTransparency = 1
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = Sidebar

    -- === TAB CONTAINER ===
    local TabContainer = Instance.new("ScrollingFrame")
    TabContainer.Size = UDim2.new(1, 0, 1, -90) -- Место под профиль
    TabContainer.Position = UDim2.new(0, 0, 0, 45)
    TabContainer.BackgroundTransparency = 1
    TabContainer.ScrollBarThickness = 0
    TabContainer.Parent = Sidebar
    
    local TabList = Instance.new("UIListLayout")
    TabList.Padding = UDim.new(0, 4)
    TabList.SortOrder = Enum.SortOrder.LayoutOrder
    TabList.HorizontalAlignment = Enum.HorizontalAlignment.Center
    TabList.Parent = TabContainer

    -- === PROFILE (Compact) ===
    local ProfileFrame = Instance.new("Frame")
    ProfileFrame.Size = UDim2.new(1, -12, 0, 40)
    ProfileFrame.Position = UDim2.new(0, 6, 1, -46)
    ProfileFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    ProfileFrame.Parent = Sidebar
    local ProfCorner = Instance.new("UICorner"); ProfCorner.CornerRadius = UDim.new(0, 4); ProfCorner.Parent = ProfileFrame
    AddStroke(ProfileFrame, 1, Colors.Stroke)

    local Avatar = Instance.new("ImageLabel")
    Avatar.Size = UDim2.new(0, 28, 0, 28)
    Avatar.Position = UDim2.new(0, 6, 0.5, -14)
    Avatar.BackgroundColor3 = Colors.Background
    Avatar.Image = Players:GetUserThumbnailAsync(LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size48x48)
    Avatar.Parent = ProfileFrame
    local AvCorner = Instance.new("UICorner"); AvCorner.CornerRadius = UDim.new(0, 4); AvCorner.Parent = Avatar

    local NameLabel = Instance.new("TextLabel")
    NameLabel.Text = LocalPlayer.Name
    NameLabel.Size = UDim2.new(1, -40, 1, 0)
    NameLabel.Position = UDim2.new(0, 40, 0, 0)
    NameLabel.Font = Enum.Font.GothamBold
    NameLabel.TextColor3 = Colors.Text
    NameLabel.TextSize = 11
    NameLabel.BackgroundTransparency = 1
    NameLabel.TextXAlignment = Enum.TextXAlignment.Left
    NameLabel.Parent = ProfileFrame

    -- === PAGES CONTAINER ===
    local Pages = Instance.new("Frame")
    Pages.Size = UDim2.new(1, -150, 1, -20)
    Pages.Position = UDim2.new(0, 150, 0, 10)
    Pages.BackgroundTransparency = 1
    Pages.Parent = MainFrame

    -- === TABS LOGIC ===
    local FirstTab = true

    function UI:Tab(Name)
        local TabFuncs = {}
        
        -- Кнопка Таба
        local TabBtn = Instance.new("TextButton")
        TabBtn.Text = Name
        TabBtn.Size = UDim2.new(0, 120, 0, 26)
        TabBtn.BackgroundColor3 = Colors.Sidebar
        TabBtn.BackgroundTransparency = 1
        TabBtn.Font = Enum.Font.GothamBold -- Жирный шрифт
        TabBtn.TextSize = 12
        TabBtn.TextColor3 = Colors.TextDark
        TabBtn.AutoButtonColor = false
        TabBtn.Parent = TabContainer

        -- Индикатор слева от таба (желтая полоска)
        local Indicator = Instance.new("Frame")
        Indicator.Size = UDim2.new(0, 3, 0, 16)
        Indicator.Position = UDim2.new(0, 0, 0.5, -8)
        Indicator.BackgroundColor3 = Colors.Accent
        Indicator.BorderSizePixel = 0
        Indicator.Visible = false
        Indicator.Parent = TabBtn

        -- Страница
        local Page = Instance.new("ScrollingFrame")
        Page.Size = UDim2.new(1, 0, 1, 0)
        Page.BackgroundTransparency = 1
        Page.ScrollBarThickness = 2
        Page.ScrollBarImageColor3 = Colors.Accent
        Page.Visible = false
        Page.Parent = Pages
        
        local PageLayout = Instance.new("UIListLayout")
        PageLayout.Padding = UDim.new(0, 6) -- Меньше отступ между элементами
        PageLayout.SortOrder = Enum.SortOrder.LayoutOrder
        PageLayout.Parent = Page

        PageLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            Page.CanvasSize = UDim2.new(0, 0, 0, PageLayout.AbsoluteContentSize.Y + 10)
        end)

        -- Функция переключения
        local function Activate()
            -- Сброс остальных
            for _, v in pairs(TabContainer:GetChildren()) do
                if v:IsA("TextButton") then
                    TweenService:Create(v, TweenInfo.new(0.2), {TextColor3 = Colors.TextDark}):Play()
                    if v:FindFirstChild("Frame") then v.Frame.Visible = false end
                end
            end
            for _, p in pairs(Pages:GetChildren()) do
                p.Visible = false
            end
            
            -- Активация текущего
            Page.Visible = true
            Indicator.Visible = true
            TweenService:Create(TabBtn, TweenInfo.new(0.2), {TextColor3 = Colors.Text}):Play() -- Белый текст активного таба
        end

        TabBtn.MouseButton1Click:Connect(Activate)

        if FirstTab then
            FirstTab = false
            Activate()
        end

        -- [[ ЭЛЕМЕНТЫ UI ]] --

        -- BUTTON
        function TabFuncs:Button(Text, Callback)
            local Btn = Instance.new("TextButton")
            Btn.Size = UDim2.new(1, -5, 0, 32) -- Компактнее высота
            Btn.BackgroundColor3 = Colors.Section
            Btn.Text = ""
            Btn.AutoButtonColor = false
            Btn.Parent = Page
            
            local UIC = Instance.new("UICorner"); UIC.CornerRadius = UDim.new(0, 4); UIC.Parent = Btn
            AddStroke(Btn, 1, Colors.Stroke)

            local Title = Instance.new("TextLabel")
            Title.Text = Text
            Title.Size = UDim2.new(1, 0, 1, 0)
            Title.BackgroundTransparency = 1
            Title.Font = Enum.Font.GothamBold
            Title.TextSize = 12
            Title.TextColor3 = Colors.Text
            Title.Parent = Btn

            Btn.MouseButton1Click:Connect(function()
                Callback()
                TweenService:Create(Btn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(45,45,45)}):Play()
                wait(0.1)
                TweenService:Create(Btn, TweenInfo.new(0.1), {BackgroundColor3 = Colors.Section}):Play()
            end)
        end

        -- TOGGLE (Переключатель)
        function TabFuncs:Toggle(Text, Default, Callback)
            local Toggled = Default or false
            
            local Tgl = Instance.new("TextButton")
            Tgl.Size = UDim2.new(1, -5, 0, 32)
            Tgl.BackgroundColor3 = Colors.Section
            Tgl.Text = ""
            Tgl.AutoButtonColor = false
            Tgl.Parent = Page
            
            local UIC = Instance.new("UICorner"); UIC.CornerRadius = UDim.new(0, 4); UIC.Parent = Tgl
            local Stroke = AddStroke(Tgl, 1, Colors.Stroke)

            local Title = Instance.new("TextLabel")
            Title.Text = Text
            Title.Size = UDim2.new(1, -40, 1, 0)
            Title.Position = UDim2.new(0, 10, 0, 0)
            Title.BackgroundTransparency = 1
            Title.Font = Enum.Font.GothamBold
            Title.TextSize = 12
            Title.TextColor3 = Colors.Text
            Title.TextXAlignment = Enum.TextXAlignment.Left
            Title.Parent = Tgl

            -- Квадратик
            local Box = Instance.new("Frame")
            Box.Size = UDim2.new(0, 18, 0, 18)
            Box.Position = UDim2.new(1, -28, 0.5, -9)
            Box.BackgroundColor3 = Toggled and Colors.Accent or Color3.fromRGB(20,20,20)
            Box.Parent = Tgl
            local BoxCorn = Instance.new("UICorner"); BoxCorn.CornerRadius = UDim.new(0, 3); BoxCorn.Parent = Box
            AddStroke(Box, 1, Colors.Stroke) -- Обводка квадратика

            if Toggled then
                Title.TextColor3 = Colors.Accent -- Если включено сразу, красим текст
                Stroke.Color = Colors.Accent
            end

            Tgl.MouseButton1Click:Connect(function()
                Toggled = not Toggled
                Callback(Toggled)
                
                if Toggled then
                    TweenService:Create(Box, TweenInfo.new(0.2), {BackgroundColor3 = Colors.Accent}):Play()
                    TweenService:Create(Title, TweenInfo.new(0.2), {TextColor3 = Colors.Accent}):Play() -- Текст становится желтым
                    TweenService:Create(Stroke, TweenInfo.new(0.2), {Color = Colors.Accent}):Play() -- Рамка желтеет
                else
                    TweenService:Create(Box, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(20,20,20)}):Play()
                    TweenService:Create(Title, TweenInfo.new(0.2), {TextColor3 = Colors.Text}):Play()
                    TweenService:Create(Stroke, TweenInfo.new(0.2), {Color = Colors.Stroke}):Play()
                end
            end)
        end

        -- SLIDER
        function TabFuncs:Slider(Text, Min, Max, Default, Callback)
            local Value = Default or Min
            local Dragging = false
            
            local SldFrame = Instance.new("Frame")
            SldFrame.Size = UDim2.new(1, -5, 0, 42) -- Чуть выше
            SldFrame.BackgroundColor3 = Colors.Section
            SldFrame.Parent = Page
            
            local UIC = Instance.new("UICorner"); UIC.CornerRadius = UDim.new(0, 4); UIC.Parent = SldFrame
            AddStroke(SldFrame, 1, Colors.Stroke)

            local Title = Instance.new("TextLabel")
            Title.Text = Text
            Title.Size = UDim2.new(1, -10, 0, 20)
            Title.Position = UDim2.new(0, 10, 0, 2)
            Title.BackgroundTransparency = 1
            Title.Font = Enum.Font.GothamBold
            Title.TextColor3 = Colors.Text
            Title.TextSize = 12
            Title.TextXAlignment = Enum.TextXAlignment.Left
            Title.Parent = SldFrame
            
            local ValueLabel = Instance.new("TextLabel")
            ValueLabel.Text = tostring(Value)
            ValueLabel.Size = UDim2.new(0, 40, 0, 20)
            ValueLabel.Position = UDim2.new(1, -45, 0, 2)
            ValueLabel.BackgroundTransparency = 1
            ValueLabel.Font = Enum.Font.GothamBold
            ValueLabel.TextColor3 = Colors.Accent -- Значение желтое
            ValueLabel.TextSize = 12
            ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
            ValueLabel.Parent = SldFrame

            -- Полоска
            local BarBack = Instance.new("Frame")
            BarBack.Size = UDim2.new(1, -20, 0, 4)
            BarBack.Position = UDim2.new(0, 10, 0, 28)
            BarBack.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
            BarBack.BorderSizePixel = 0
            BarBack.Parent = SldFrame
            local BC = Instance.new("UICorner"); BC.CornerRadius = UDim.new(1,0); BC.Parent = BarBack
            
            local Fill = Instance.new("Frame")
            Fill.Size = UDim2.new((Value - Min) / (Max - Min), 0, 1, 0)
            Fill.BackgroundColor3 = Colors.Accent -- Желтая заливка
            Fill.BorderSizePixel = 0
            Fill.Parent = BarBack
            local FC = Instance.new("UICorner"); FC.CornerRadius = UDim.new(1,0); FC.Parent = Fill

            local Trigger = Instance.new("TextButton")
            Trigger.Size = UDim2.new(1, 0, 1, 0)
            Trigger.BackgroundTransparency = 1
            Trigger.Text = ""
            Trigger.Parent = SldFrame
            
            local function Update(input)
                local pos = math.clamp((input.Position.X - BarBack.AbsolutePosition.X) / BarBack.AbsoluteSize.X, 0, 1)
                local val = math.floor(((pos * (Max - Min)) + Min) * 10) / 10
                
                Fill:TweenSize(UDim2.new(pos, 0, 1, 0), "Out", "Sine", 0.05, true)
                ValueLabel.Text = tostring(val)
                Callback(val)
            end

            Trigger.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    Dragging = true
                    Update(input)
                end
            end)
            
            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then Dragging = false end
            end)
            
            UserInputService.InputChanged:Connect(function(input)
                if Dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                    Update(input)
                end
            end)
        end

        return TabFuncs
    end
    
    return UI
end

return Library
