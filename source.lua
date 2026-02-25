--[=[
    PulseUI - Remastered Version
    Создано с фокусом на производительность, стекломорфизм (Acrylic) и плавные анимации.
]=]

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

local PulseUI = {}
PulseUI.Theme = {
    Background = Color3.fromRGB(20, 20, 25),
    AcrylicTint = Color3.fromRGB(30, 30, 40),
    Accent = Color3.fromRGB(120, 80, 255), -- Фиолетовый пульс
    Text = Color3.fromRGB(240, 240, 240),
    TextDark = Color3.fromRGB(150, 150, 160),
    ElementBg = Color3.fromRGB(35, 35, 45),
    ElementHover = Color3.fromRGB(45, 45, 55)
}

-- Глобальная функция для создания анимаций
local function Tween(instance, properties, duration, style)
    duration = duration or 0.2
    style = style or Enum.EasingStyle.Quint
    local tween = TweenService:Create(instance, TweenInfo.new(duration, style, Enum.EasingDirection.Out), properties)
    tween:Play()
    return tween
end

-- Функция для плавного перетаскивания (Smooth Dragging)
local function MakeDraggable(topbar, window)
    local dragging = false
    local dragInput, dragStart, startPos

    topbar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = window.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
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
            local delta = dragInput.Position - dragStart
            local targetPos = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            -- Плавное следование окна
            Tween(window, {Position = targetPos}, 0.15, Enum.EasingStyle.Linear)
        end
    end)
end

function PulseUI:CreateWindow(config)
    config = config or {}
    local TitleText = config.Title or "PulseUI Remastered"
    local AccentColor = config.Accent or self.Theme.Accent

    -- Контейнер GUI (Защита для эксплойтов, если доступен gethui)
    local targetParent = (gethui and gethui()) or CoreGui:FindFirstChild("RobloxGui") or CoreGui
    
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "PulseUI_Interface"
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.Parent = targetParent

    -- Основное окно (Стиль Acrylic)
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 500, 0, 350)
    MainFrame.Position = UDim2.new(0.5, -250, 0.5, -175)
    MainFrame.BackgroundColor3 = self.Theme.AcrylicTint
    MainFrame.BackgroundTransparency = 0.2 -- Эффект полупрозрачности стекла
    MainFrame.Parent = ScreenGui

    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 10)
    UICorner.Parent = MainFrame

    local UIStroke = Instance.new("UIStroke")
    UIStroke.Color = Color3.fromRGB(255, 255, 255)
    UIStroke.Transparency = 0.9
    UIStroke.Thickness = 1
    UIStroke.Parent = MainFrame

    -- Тень для глубины
    local DropShadow = Instance.new("ImageLabel")
    DropShadow.Name = "Shadow"
    DropShadow.AnchorPoint = Vector2.new(0.5, 0.5)
    DropShadow.Position = UDim2.new(0.5, 0, 0.5, 0)
    DropShadow.Size = UDim2.new(1, 40, 1, 40)
    DropShadow.BackgroundTransparency = 1
    DropShadow.Image = "rbxassetid://6015897843"
    DropShadow.ImageColor3 = Color3.new(0, 0, 0)
    DropShadow.ImageTransparency = 0.5
    DropShadow.ZIndex = -1
    DropShadow.Parent = MainFrame

    -- Верхняя панель (Topbar)
    local Topbar = Instance.new("Frame")
    Topbar.Size = UDim2.new(1, 0, 0, 40)
    Topbar.BackgroundTransparency = 1
    Topbar.Parent = MainFrame
    MakeDraggable(Topbar, MainFrame)

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, -20, 1, 0)
    Title.Position = UDim2.new(0, 20, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = TitleText
    Title.TextColor3 = self.Theme.Text
    Title.TextSize = 16
    Title.Font = Enum.Font.GothamBold
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = Topbar

    -- Линия-разделитель (Пульс)
    local Divider = Instance.new("Frame")
    Divider.Size = UDim2.new(1, 0, 0, 1)
    Divider.Position = UDim2.new(0, 0, 1, 0)
    Divider.BackgroundColor3 = AccentColor
    Divider.BorderSizePixel = 0
    Divider.Parent = Topbar
    
    -- Контейнер для вкладок (табов)
    local TabContainer = Instance.new("ScrollingFrame")
    TabContainer.Size = UDim2.new(0, 130, 1, -41)
    TabContainer.Position = UDim2.new(0, 0, 0, 41)
    TabContainer.BackgroundTransparency = 1
    TabContainer.BorderSizePixel = 0
    TabContainer.ScrollBarThickness = 0
    TabContainer.Parent = MainFrame

    local TabListLayout = Instance.new("UIListLayout")
    TabListLayout.Padding = UDim.new(0, 5)
    TabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TabListLayout.Parent = TabContainer

    local TabPadding = Instance.new("UIPadding")
    TabPadding.PaddingTop = UDim.new(0, 10)
    TabPadding.PaddingLeft = UDim.new(0, 10)
    TabPadding.PaddingRight = UDim.new(0, 10)
    TabPadding.Parent = TabContainer

    -- Контейнер для содержимого
    local ContentContainer = Instance.new("Frame")
    ContentContainer.Size = UDim2.new(1, -131, 1, -41)
    ContentContainer.Position = UDim2.new(0, 131, 0, 41)
    ContentContainer.BackgroundTransparency = 1
    ContentContainer.Parent = MainFrame

    -- Анимация появления окна
    MainFrame.Size = UDim2.new(0, 450, 0, 300)
    MainFrame.GroupTransparency = 1
    Tween(MainFrame, {Size = UDim2.new(0, 500, 0, 350), GroupTransparency = 0}, 0.5, Enum.EasingStyle.Back)

    local Window = {
        Tabs = {},
        CurrentTab = nil
    }

    function Window:CreateTab(name)
        local TabBtn = Instance.new("TextButton")
        TabBtn.Size = UDim2.new(1, 0, 0, 30)
        TabBtn.BackgroundColor3 = PulseUI.Theme.ElementBg
        TabBtn.BackgroundTransparency = 1
        TabBtn.Text = name
        TabBtn.TextColor3 = PulseUI.Theme.TextDark
        TabBtn.Font = Enum.Font.GothamSemibold
        TabBtn.TextSize = 14
        TabBtn.Parent = TabContainer

        local TabCorner = Instance.new("UICorner")
        TabCorner.CornerRadius = UDim.new(0, 6)
        TabCorner.Parent = TabBtn

        local Page = Instance.new("ScrollingFrame")
        Page.Size = UDim2.new(1, 0, 1, 0)
        Page.BackgroundTransparency = 1
        Page.BorderSizePixel = 0
        Page.ScrollBarThickness = 2
        Page.ScrollBarImageColor3 = AccentColor
        Page.Visible = false
        Page.Parent = ContentContainer

        local PageLayout = Instance.new("UIListLayout")
        PageLayout.Padding = UDim.new(0, 8)
        PageLayout.SortOrder = Enum.SortOrder.LayoutOrder
        PageLayout.Parent = Page

        local PagePadding = Instance.new("UIPadding")
        PagePadding.PaddingTop = UDim.new(0, 10)
        PagePadding.PaddingLeft = UDim.new(0, 10)
        PagePadding.PaddingRight = UDim.new(0, 10)
        PagePadding.Parent = Page

        -- Логика переключения вкладок с анимацией
        TabBtn.MouseButton1Click:Connect(function()
            if Window.CurrentTab then
                Window.CurrentTab.Btn.BackgroundTransparency = 1
                Tween(Window.CurrentTab.Btn, {TextColor3 = PulseUI.Theme.TextDark}, 0.2)
                Window.CurrentTab.Page.Visible = false
            end

            Window.CurrentTab = {Btn = TabBtn, Page = Page}
            Page.Visible = true
            Tween(TabBtn, {BackgroundTransparency = 0, TextColor3 = PulseUI.Theme.Text}, 0.2)
            
            -- Анимация появления элементов страницы
            Page.Position = UDim2.new(0, 10, 0, 0)
            Page.GroupTransparency = 1
            Tween(Page, {Position = UDim2.new(0, 0, 0, 0), GroupTransparency = 0}, 0.3)
        end)

        -- Если это первая вкладка, открываем её
        if not Window.CurrentTab then
            TabBtn.BackgroundTransparency = 0
            TabBtn.TextColor3 = PulseUI.Theme.Text
            Page.Visible = true
            Window.CurrentTab = {Btn = TabBtn, Page = Page}
        end

        local TabElements = {}

        -- Создание кнопки
        function TabElements:CreateButton(btnText, callback)
            local Button = Instance.new("TextButton")
            Button.Size = UDim2.new(1, 0, 0, 35)
            Button.BackgroundColor3 = PulseUI.Theme.ElementBg
            Button.Text = btnText
            Button.TextColor3 = PulseUI.Theme.Text
            Button.Font = Enum.Font.Gotham
            Button.TextSize = 14
            Button.Parent = Page

            Instance.new("UICorner", Button).CornerRadius = UDim.new(0, 6)
            
            local UIStrokeBtn = Instance.new("UIStroke", Button)
            UIStrokeBtn.Color = Color3.fromRGB(255,255,255)
            UIStrokeBtn.Transparency = 0.9

            -- Живые анимации (Alive Style)
            Button.MouseEnter:Connect(function()
                Tween(Button, {BackgroundColor3 = PulseUI.Theme.ElementHover}, 0.2)
            end)

            Button.MouseLeave:Connect(function()
                Tween(Button, {BackgroundColor3 = PulseUI.Theme.ElementBg}, 0.2)
            end)

            Button.MouseButton1Down:Connect(function()
                Tween(Button, {Size = UDim2.new(0.98, 0, 0, 33)}, 0.1)
            end)

            Button.MouseButton1Up:Connect(function()
                Tween(Button, {Size = UDim2.new(1, 0, 0, 35)}, 0.1)
                if callback then callback() end
            end)
        end

        -- Создание переключателя (Toggle)
        function TabElements:CreateToggle(toggleText, default, callback)
            local toggled = default or false

            local ToggleFrame = Instance.new("Frame")
            ToggleFrame.Size = UDim2.new(1, 0, 0, 35)
            ToggleFrame.BackgroundColor3 = PulseUI.Theme.ElementBg
            ToggleFrame.Parent = Page
            Instance.new("UICorner", ToggleFrame).CornerRadius = UDim.new(0, 6)

            local Label = Instance.new("TextLabel")
            Label.Size = UDim2.new(1, -60, 1, 0)
            Label.Position = UDim2.new(0, 10, 0, 0)
            Label.BackgroundTransparency = 1
            Label.Text = toggleText
            Label.TextColor3 = PulseUI.Theme.Text
            Label.Font = Enum.Font.Gotham
            Label.TextSize = 14
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.Parent = ToggleFrame

            local ToggleOuter = Instance.new("Frame")
            ToggleOuter.Size = UDim2.new(0, 40, 0, 20)
            ToggleOuter.Position = UDim2.new(1, -50, 0.5, -10)
            ToggleOuter.BackgroundColor3 = toggled and AccentColor or Color3.fromRGB(60, 60, 70)
            ToggleOuter.Parent = ToggleFrame
            Instance.new("UICorner", ToggleOuter).CornerRadius = UDim.new(1, 0)

            local ToggleInner = Instance.new("Frame")
            ToggleInner.Size = UDim2.new(0, 16, 0, 16)
            ToggleInner.Position = UDim2.new(0, toggled and 22 or 2, 0.5, -8)
            ToggleInner.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            ToggleInner.Parent = ToggleOuter
            Instance.new("UICorner", ToggleInner).CornerRadius = UDim.new(1, 0)

            local ClickBtn = Instance.new("TextButton")
            ClickBtn.Size = UDim2.new(1, 0, 1, 0)
            ClickBtn.BackgroundTransparency = 1
            ClickBtn.Text = ""
            ClickBtn.Parent = ToggleFrame

            ClickBtn.MouseButton1Click:Connect(function()
                toggled = not toggled
                -- Плавная анимация переключателя
                Tween(ToggleOuter, {BackgroundColor3 = toggled and AccentColor or Color3.fromRGB(60, 60, 70)}, 0.25)
                Tween(ToggleInner, {Position = UDim2.new(0, toggled and 22 or 2, 0.5, -8)}, 0.25, Enum.EasingStyle.Back)
                
                if callback then callback(toggled) end
            end)
        end

        return TabElements
    end

    return Window
end

return PulseUI
