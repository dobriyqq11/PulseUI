--[[ 
    PulseVisuals UI Library 
    Style: Deep Dark / Purple / Left Tabs
    Author: Thinking+ (Generated for User)
]]

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")

local Library = {}

--// НАСТРОЙКИ СТИЛЯ (Pulse Style)
local Theme = {
	Background = Color3.fromRGB(15, 15, 18),       -- Глубокий черный (Obsidian)
	Sidebar = Color3.fromRGB(20, 20, 24),          -- Чуть светлее для меню
	Element = Color3.fromRGB(28, 28, 32),          -- Фон кнопок
	Accent = Color3.fromRGB(138, 43, 226),         -- PULSE PURPLE (Neon Violet)
	Text = Color3.fromRGB(240, 240, 240),          -- Белый текст
	TextDim = Color3.fromRGB(120, 120, 120)        -- Серый текст
}

function Library:CreateWindow(Settings)
	local WindowName = Settings.Name or "Pulse UI"
	
	local Window = {}
	
	-- Защита от обнаружения (CoreGui)
	local ScreenGui = Instance.new("ScreenGui")
	ScreenGui.Name = "PulseHook_" .. math.random(1000,9999)
	ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	if RunService:IsStudio() then
		ScreenGui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
	else
		pcall(function() ScreenGui.Parent = CoreGui end)
	end

	-- Основной фрейм
	local Main = Instance.new("Frame")
	Main.Name = "Main"
	Main.Parent = ScreenGui
	Main.BackgroundColor3 = Theme.Background
	Main.Position = UDim2.fromScale(0.5, 0.5)
	Main.AnchorPoint = Vector2.new(0.5, 0.5)
	Main.Size = UDim2.fromOffset(600, 400)
	Main.BorderSizePixel = 0
	
	-- Скругления и Тень
	local UICorner = Instance.new("UICorner")
	UICorner.CornerRadius = UDim.new(0, 6)
	UICorner.Parent = Main
	
	local Stroke = Instance.new("UIStroke")
	Stroke.Parent = Main
	Stroke.Color = Theme.Accent
	Stroke.Thickness = 1
	Stroke.Transparency = 0.8 -- Еле заметная фиолетовая рамка

	-- Сайдбар (Слева)
	local Sidebar = Instance.new("Frame")
	Sidebar.Parent = Main
	Sidebar.BackgroundColor3 = Theme.Sidebar
	Sidebar.Size = UDim2.new(0, 150, 1, 0)
	Sidebar.BorderSizePixel = 0
	
	local SideCorner = Instance.new("UICorner")
	SideCorner.CornerRadius = UDim.new(0, 6)
	SideCorner.Parent = Sidebar
	
	-- Заплатка чтобы правый край сайдбара был прямым
	local Patch = Instance.new("Frame")
	Patch.Parent = Sidebar
	Patch.BackgroundColor3 = Theme.Sidebar
	Patch.BorderSizePixel = 0
	Patch.Size = UDim2.new(0, 10, 1, 0)
	Patch.Position = UDim2.new(1, -10, 0, 0)

	-- Заголовок
	local TitleLabel = Instance.new("TextLabel")
	TitleLabel.Parent = Sidebar
	TitleLabel.BackgroundTransparency = 1
	TitleLabel.Position = UDim2.new(0, 15, 0, 15)
	TitleLabel.Size = UDim2.new(1, -15, 0, 30)
	TitleLabel.Font = Enum.Font.GothamBold
	TitleLabel.Text = WindowName
	TitleLabel.TextColor3 = Theme.Accent
	TitleLabel.TextSize = 20
	TitleLabel.TextXAlignment = Enum.TextXAlignment.Left

	-- Контейнер для кнопок вкладок
	local TabContainer = Instance.new("Frame")
	TabContainer.Parent = Sidebar
	TabContainer.BackgroundTransparency = 1
	TabContainer.Position = UDim2.new(0, 10, 0, 60)
	TabContainer.Size = UDim2.new(1, -20, 1, -70)
	
	local TabList = Instance.new("UIListLayout")
	TabList.Parent = TabContainer
	TabList.Padding = UDim.new(0, 5)
	TabList.SortOrder = Enum.SortOrder.LayoutOrder

	-- Контейнер страниц (Справа)
	local Pages = Instance.new("Frame")
	Pages.Parent = Main
	Pages.BackgroundTransparency = 1
	Pages.Position = UDim2.new(0, 160, 0, 10)
	Pages.Size = UDim2.new(1, -170, 1, -20)

	-- Drag Logic
	local Dragging, DragInput, DragStart, StartPos
	local function Update(Input)
		local Delta = Input.Position - DragStart
		Main.Position = UDim2.new(StartPos.X.Scale, StartPos.X.Offset + Delta.X, StartPos.Y.Scale, StartPos.Y.Offset + Delta.Y)
	end
	Main.InputBegan:Connect(function(Input)
		if Input.UserInputType == Enum.UserInputType.MouseButton1 then
			Dragging = true; DragStart = Input.Position; StartPos = Main.Position
			Input.Changed:Connect(function() if Input.UserInputState == Enum.UserInputState.End then Dragging = false end end)
		end
	end)
	Main.InputChanged:Connect(function(Input)
		if Input.UserInputType == Enum.UserInputType.MouseMovement then DragInput = Input end
	end)
	UserInputService.InputChanged:Connect(function(Input)
		if Input == DragInput and Dragging then Update(Input) end
	end)

	local FirstTab = true

	--// Создание вкладки
	function Window:Tab(Name)
		local Tab = {}
		
		-- Кнопка
		local Btn = Instance.new("TextButton")
		Btn.Parent = TabContainer
		Btn.BackgroundColor3 = Theme.Background
		Btn.BackgroundTransparency = 1
		Btn.Size = UDim2.new(1, 0, 0, 32)
		Btn.Font = Enum.Font.GothamMedium
		Btn.Text = "  " .. Name
		Btn.TextColor3 = Theme.TextDim
		Btn.TextSize = 14
		Btn.TextXAlignment = Enum.TextXAlignment.Left
		Btn.AutoButtonColor = false
		
		local BtnCorner = Instance.new("UICorner")
		BtnCorner.CornerRadius = UDim.new(0, 4)
		BtnCorner.Parent = Btn
		
		-- Страница
		local Page = Instance.new("ScrollingFrame")
		Page.Parent = Pages
		Page.BackgroundTransparency = 1
		Page.Size = UDim2.new(1, 0, 1, 0)
		Page.ScrollBarThickness = 2
		Page.ScrollBarImageColor3 = Theme.Accent
		Page.Visible = false
		Page.CanvasSize = UDim2.new(0, 0, 0, 0)
		
		local PageList = Instance.new("UIListLayout")
		PageList.Parent = Page
		PageList.Padding = UDim.new(0, 8)
		PageList.SortOrder = Enum.SortOrder.LayoutOrder
		
		PageList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
			Page.CanvasSize = UDim2.new(0, 0, 0, PageList.AbsoluteContentSize.Y + 10)
		end)

		if FirstTab then
			FirstTab = false
			Page.Visible = true
			Btn.TextColor3 = Theme.Text
			Btn.BackgroundTransparency = 0
		end
		
		Btn.MouseButton1Click:Connect(function()
			for _, v in pairs(Pages:GetChildren()) do v.Visible = false end
			for _, v in pairs(TabContainer:GetChildren()) do
				if v:IsA("TextButton") then
					TweenService:Create(v, TweenInfo.new(0.3), {BackgroundTransparency = 1, TextColor3 = Theme.TextDim}):Play()
				end
			end
			Page.Visible = true
			TweenService:Create(Btn, TweenInfo.new(0.3), {BackgroundTransparency = 0, TextColor3 = Theme.Text}):Play()
		end)

		--// Элементы
		function Tab:Section(Text)
			local Label = Instance.new("TextLabel")
			Label.Parent = Page
			Label.BackgroundTransparency = 1
			Label.Size = UDim2.new(1, 0, 0, 25)
			Label.Font = Enum.Font.GothamBold
			Label.Text = Text
			Label.TextColor3 = Theme.TextDim
			Label.TextSize = 12
			Label.TextXAlignment = Enum.TextXAlignment.Left
		end

		function Tab:Button(Text, Callback)
			local ButtonFrame = Instance.new("TextButton")
			ButtonFrame.Parent = Page
			ButtonFrame.BackgroundColor3 = Theme.Element
			ButtonFrame.Size = UDim2.new(1, -5, 0, 36)
			ButtonFrame.Font = Enum.Font.Gotham
			ButtonFrame.Text = Text
			ButtonFrame.TextColor3 = Theme.Text
			ButtonFrame.TextSize = 14
			ButtonFrame.AutoButtonColor = false
			
			local Corner = Instance.new("UICorner")
			Corner.CornerRadius = UDim.new(0, 4)
			Corner.Parent = ButtonFrame
			
			ButtonFrame.MouseButton1Click:Connect(function()
				Callback()
				TweenService:Create(ButtonFrame, TweenInfo.new(0.1), {BackgroundColor3 = Theme.Accent}):Play()
				task.wait(0.1)
				TweenService:Create(ButtonFrame, TweenInfo.new(0.3), {BackgroundColor3 = Theme.Element}):Play()
			end)
		end

		function Tab:Toggle(Text, Default, Callback)
			local Toggled = Default or false
			local ToggleBtn = Instance.new("TextButton")
			ToggleBtn.Parent = Page
			ToggleBtn.BackgroundColor3 = Theme.Element
			ToggleBtn.Size = UDim2.new(1, -5, 0, 36)
			ToggleBtn.Text = ""
			ToggleBtn.AutoButtonColor = false
			
			local Corner = Instance.new("UICorner")
			Corner.CornerRadius = UDim.new(0, 4)
			Corner.Parent = ToggleBtn
			
			local Title = Instance.new("TextLabel")
			Title.Parent = ToggleBtn
			Title.BackgroundTransparency = 1
			Title.Position = UDim2.new(0, 10, 0, 0)
			Title.Size = UDim2.new(1, -50, 1, 0)
			Title.Font = Enum.Font.Gotham
			Title.Text = Text
			Title.TextColor3 = Theme.Text
			Title.TextSize = 14
			Title.TextXAlignment = Enum.TextXAlignment.Left
			
			local Check = Instance.new("Frame")
			Check.Parent = ToggleBtn
			Check.BackgroundColor3 = Toggled and Theme.Accent or Color3.fromRGB(50, 50, 55)
			Check.Position = UDim2.new(1, -26, 0.5, -8)
			Check.Size = UDim2.new(0, 16, 0, 16)
			
			local CheckCorner = Instance.new("UICorner")
			CheckCorner.CornerRadius = UDim.new(0, 4)
			CheckCorner.Parent = Check
			
			ToggleBtn.MouseButton1Click:Connect(function()
				Toggled = not Toggled
				Callback(Toggled)
				TweenService:Create(Check, TweenInfo.new(0.2), {BackgroundColor3 = Toggled and Theme.Accent or Color3.fromRGB(50, 50, 55)}):Play()
			end)
		end

		function Tab:Slider(Text, Min, Max, Default, Callback)
			local Value = Default or Min
			local SliderFrame = Instance.new("Frame")
			SliderFrame.Parent = Page
			SliderFrame.BackgroundColor3 = Theme.Element
			SliderFrame.Size = UDim2.new(1, -5, 0, 45)
			
			local Corner = Instance.new("UICorner")
			Corner.CornerRadius = UDim.new(0, 4)
			Corner.Parent = SliderFrame
			
			local Title = Instance.new("TextLabel")
			Title.Parent = SliderFrame
			Title.BackgroundTransparency = 1
			Title.Position = UDim2.new(0, 10, 0, 5)
			Title.Size = UDim2.new(1, -10, 0, 20)
			Title.Font = Enum.Font.Gotham
			Title.Text = Text
			Title.TextColor3 = Theme.Text
			Title.TextSize = 14
			Title.TextXAlignment = Enum.TextXAlignment.Left
			
			local ValueLabel = Instance.new("TextLabel")
			ValueLabel.Parent = SliderFrame
			ValueLabel.BackgroundTransparency = 1
			ValueLabel.Position = UDim2.new(1, -50, 0, 5)
			ValueLabel.Size = UDim2.new(0, 40, 0, 20)
			ValueLabel.Font = Enum.Font.Gotham
			ValueLabel.Text = tostring(Value)
			ValueLabel.TextColor3 = Theme.TextDim
			ValueLabel.TextSize = 12
			
			local Bar = Instance.new("TextButton")
			Bar.Parent = SliderFrame
			Bar.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
			Bar.Position = UDim2.new(0, 10, 0, 30)
			Bar.Size = UDim2.new(1, -20, 0, 6)
			Bar.AutoButtonColor = false
			Bar.Text = ""
			
			local BarCorner = Instance.new("UICorner")
			BarCorner.CornerRadius = UDim.new(1, 0)
			BarCorner.Parent = Bar
			
			local Fill = Instance.new("Frame")
			Fill.Parent = Bar
			Fill.BackgroundColor3 = Theme.Accent
			Fill.Size = UDim2.new((Value - Min) / (Max - Min), 0, 1, 0)
			
			local FillCorner = Instance.new("UICorner")
			FillCorner.CornerRadius = UDim.new(1, 0)
			FillCorner.Parent = Fill
			
			local function Update(Input)
				local SizeX = math.clamp((Input.Position.X - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X, 0, 1)
				Value = math.floor(Min + ((Max - Min) * SizeX))
				TweenService:Create(Fill, TweenInfo.new(0.1), {Size = UDim2.new(SizeX, 0, 1, 0)}):Play()
				ValueLabel.Text = tostring(Value)
				Callback(Value)
			end
			
			local Dragging = false
			Bar.InputBegan:Connect(function(Input)
				if Input.UserInputType == Enum.UserInputType.MouseButton1 then Dragging = true; Update(Input) end
			end)
			UserInputService.InputChanged:Connect(function(Input)
				if Dragging and Input.UserInputType == Enum.UserInputType.MouseMovement then Update(Input) end
			end)
			UserInputService.InputEnded:Connect(function(Input)
				if Input.UserInputType == Enum.UserInputType.MouseButton1 then Dragging = false end
			end)
		end

		return Tab
	end

	return Window
end

return Library
