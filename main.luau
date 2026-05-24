local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer

local gui = Instance.new("ScreenGui")
gui.Name = "OpScriptsGUI"
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 520, 0, 340)
Main.Position = UDim2.new(0.5, -260, 0.5, -170)
Main.BackgroundColor3 = Color3.fromRGB(16,16,16)
Main.BorderSizePixel = 0
Main.Active = true
Main.Parent = gui

Instance.new("UICorner", Main).CornerRadius = UDim.new(0,18)

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(45,45,45)
MainStroke.Thickness = 1.5
MainStroke.Parent = Main

local Topbar = Instance.new("Frame")
Topbar.Size = UDim2.new(1,0,0,48)
Topbar.BackgroundColor3 = Color3.fromRGB(22,22,22)
Topbar.BorderSizePixel = 0
Topbar.Parent = Main

Instance.new("UICorner", Topbar).CornerRadius = UDim.new(0,18)

local Fix = Instance.new("Frame")
Fix.Size = UDim2.new(1,0,0,20)
Fix.Position = UDim2.new(0,0,1,-20)
Fix.BackgroundColor3 = Color3.fromRGB(22,22,22)
Fix.BorderSizePixel = 0
Fix.Parent = Topbar

local Title = Instance.new("TextLabel")
Title.BackgroundTransparency = 1
Title.Size = UDim2.new(1,0,1,0)
Title.Text = "OpScriptsGUI"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.TextColor3 = Color3.new(1,1,1)
Title.Parent = Topbar

local Toggles = {}
local Tabs = {}

local Close = Instance.new("TextButton")
Close.Size = UDim2.new(0,32,0,32)
Close.Position = UDim2.new(1,-40,0.5,-16)
Close.BackgroundColor3 = Color3.fromRGB(170,0,0)
Close.Text = "X"
Close.Font = Enum.Font.GothamBold
Close.TextSize = 14
Close.TextColor3 = Color3.new(1,1,1)
Close.BorderSizePixel = 0
Close.Parent = Topbar

Instance.new("UICorner", Close).CornerRadius = UDim.new(1,0)

Close.MouseButton1Click:Connect(function()
	for _,Toggle in pairs(Toggles) do
		Toggle(false)
	end
	gui:Destroy()
end)

local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0,140,1,-48)
Sidebar.Position = UDim2.new(0,0,0,48)
Sidebar.BackgroundColor3 = Color3.fromRGB(20,20,20)
Sidebar.BorderSizePixel = 0
Sidebar.Parent = Main

local SideLayout = Instance.new("UIListLayout")
SideLayout.Padding = UDim.new(0,8)
SideLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
SideLayout.Parent = Sidebar

local SidePadding = Instance.new("UIPadding")
SidePadding.PaddingTop = UDim.new(0,12)
SidePadding.Parent = Sidebar

local Content = Instance.new("Frame")
Content.Size = UDim2.new(1,-140,1,-48)
Content.Position = UDim2.new(0,140,0,48)
Content.BackgroundTransparency = 1
Content.Parent = Main

local function CreateTitle(Text)
	Title.Text = Text
end

local function CreateTab(Name)
	local Button = Instance.new("TextButton")
	Button.Size = UDim2.new(0,120,0,40)
	Button.BackgroundColor3 = Color3.fromRGB(28,28,28)
	Button.BorderSizePixel = 0
	Button.Text = Name
	Button.Font = Enum.Font.GothamBold
	Button.TextSize = 14
	Button.TextColor3 = Color3.new(1,1,1)
	Button.Parent = Sidebar

	Instance.new("UICorner", Button).CornerRadius = UDim.new(0,10)

	local Stroke = Instance.new("UIStroke")
	Stroke.Color = Color3.fromRGB(45,45,45)
	Stroke.Parent = Button

	local Page = Instance.new("ScrollingFrame")
	Page.Size = UDim2.new(1,0,1,0)
	Page.CanvasSize = UDim2.new(0,0,0,0)
	Page.ScrollBarThickness = 4
	Page.BackgroundTransparency = 1
	Page.Visible = false
	Page.Parent = Content

	local Layout = Instance.new("UIListLayout")
	Layout.Padding = UDim.new(0,12)
	Layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	Layout.Parent = Page

	local Padding = Instance.new("UIPadding")
	Padding.PaddingTop = UDim.new(0,20)
	Padding.Parent = Page

	Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
		Page.CanvasSize = UDim2.new(0,0,0,Layout.AbsoluteContentSize.Y + 25)
	end)

	Tabs[Name] = Page

	Button.MouseButton1Click:Connect(function()
		for _,v in pairs(Content:GetChildren()) do
			if v:IsA("ScrollingFrame") then
				v.Visible = false
			end
		end
		Page.Visible = true
	end)

	return Page
end

local function CreateButton(BtnName, Tab, Callback)
	local Page = Tabs[Tab]

	local Button = Instance.new("TextButton")
	Button.Size = UDim2.new(0,260,0,50)
	Button.BackgroundColor3 = Color3.fromRGB(28,28,28)
	Button.BorderSizePixel = 0
	Button.Text = BtnName
	Button.Font = Enum.Font.GothamBold
	Button.TextSize = 15
	Button.TextColor3 = Color3.new(1,1,1)
	Button.Parent = Page

	Instance.new("UICorner", Button).CornerRadius = UDim.new(0,12)

	local Stroke = Instance.new("UIStroke")
	Stroke.Color = Color3.fromRGB(45,45,45)
	Stroke.Parent = Button

	Button.MouseEnter:Connect(function()
		TweenService:Create(Button, TweenInfo.new(0.15), {
			BackgroundColor3 = Color3.fromRGB(35,35,35)
		}):Play()
	end)

	Button.MouseLeave:Connect(function()
		TweenService:Create(Button, TweenInfo.new(0.15), {
			BackgroundColor3 = Color3.fromRGB(28,28,28)
		}):Play()
	end)

	if Callback then
		Button.MouseButton1Click:Connect(Callback)
	end

	return Button
end

local function CreateToggle(Name, Tab, Callback)
	local Page = Tabs[Tab]

	local Enabled = false

	local ToggleFrame = Instance.new("Frame")
	ToggleFrame.Size = UDim2.new(0,280,0,60)
	ToggleFrame.BackgroundColor3 = Color3.fromRGB(24,24,24)
	ToggleFrame.BorderSizePixel = 0
	ToggleFrame.Parent = Page

	Instance.new("UICorner", ToggleFrame).CornerRadius = UDim.new(0,14)

	local ToggleText = Instance.new("TextLabel")
	ToggleText.Size = UDim2.new(0.7,0,1,0)
	ToggleText.Position = UDim2.new(0,15,0,0)
	ToggleText.BackgroundTransparency = 1
	ToggleText.Text = Name
	ToggleText.Font = Enum.Font.GothamBold
	ToggleText.TextSize = 16
	ToggleText.TextColor3 = Color3.new(1,1,1)
	ToggleText.TextXAlignment = Enum.TextXAlignment.Left
	ToggleText.Parent = ToggleFrame

	local ToggleButton = Instance.new("TextButton")
	ToggleButton.Size = UDim2.new(0,70,0,32)
	ToggleButton.Position = UDim2.new(1,-85,0.5,-16)
	ToggleButton.BackgroundColor3 = Color3.fromRGB(45,45,45)
	ToggleButton.Text = "OFF"
	ToggleButton.Font = Enum.Font.GothamBold
	ToggleButton.TextSize = 14
	ToggleButton.TextColor3 = Color3.new(1,1,1)
	ToggleButton.Parent = ToggleFrame

	Instance.new("UICorner", ToggleButton).CornerRadius = UDim.new(1,0)

	local function Update()
		if Enabled then
			ToggleButton.BackgroundColor3 = Color3.fromRGB(0,170,127)
			ToggleButton.Text = "ON"
		else
			ToggleButton.BackgroundColor3 = Color3.fromRGB(45,45,45)
			ToggleButton.Text = "OFF"
		end
	end

	local function GetToggle()
		return Enabled
	end

	Toggles[Name] = function(Value)
		if Value ~= nil then
			Enabled = Value
			Update()
		end
		return Enabled
	end

	ToggleButton.MouseButton1Click:Connect(function()
		Enabled = not Enabled
		Update()

		if Enabled and Callback then
			task.spawn(function()
				Callback(function()
					return Enabled
				end)
			end)
		end
	end)

	Update()

	return {
		Button = ToggleButton,
		Get = GetToggle,
		Set = function(Value)
			Enabled = Value
			Update()
		end
	}
end

local function GetToggle(Name)
	if Toggles[Name] then
		return Toggles[Name]()
	end
	return false
end

local function Loading()
	local Players = game:GetService("Players")
	local LocalPlayer = Players.LocalPlayer

	local LoadingGui = Instance.new("ScreenGui")
	LoadingGui.Name = "LoadingGUI"
	LoadingGui.ResetOnSpawn = false
	LoadingGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

	local LoadingFrame = Instance.new("Frame")
	LoadingFrame.Size = UDim2.new(0, 420, 0, 160)
	LoadingFrame.Position = UDim2.new(0.5, -210, 0.5, -80)
	LoadingFrame.BackgroundColor3 = Color3.fromRGB(16, 16, 16)
	LoadingFrame.BorderSizePixel = 0
	LoadingFrame.Parent = LoadingGui

	Instance.new("UICorner", LoadingFrame).CornerRadius = UDim.new(0, 18)

	local Stroke = Instance.new("UIStroke")
	Stroke.Color = Color3.fromRGB(45, 45, 45)
	Stroke.Thickness = 1.5
	Stroke.Parent = LoadingFrame

	local Text = Instance.new("TextLabel")
	Text.Size = UDim2.new(1, 0, 1, 0)
	Text.BackgroundTransparency = 1
	Text.Font = Enum.Font.GothamBold
	Text.TextSize = 18
	Text.TextColor3 = Color3.new(1, 1, 1)
	Text.Parent = LoadingFrame

	local Steps = {
		"Loading.",
		"Loading..",
		"Loading...",
		"Loaded!"
	}

	for i = 1, #Steps do
		Text.Text = Steps[i]
		task.wait(0.8)
	end

	task.wait(0.3)
	LoadingGui:Destroy()
end

local MainTab = CreateTab("Main")
MainTab.Visible = true

local dragging
local dragInput
local dragStart
local startPos

Topbar.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		dragStart = input.Position
		startPos = Main.Position
	end
end)

Topbar.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement then
		dragInput = input
	end
end)

UIS.InputChanged:Connect(function(input)
	if input == dragInput and dragging then
		local delta = input.Position - dragStart
		Main.Position = UDim2.new(
			startPos.X.Scale,
			startPos.X.Offset + delta.X,
			startPos.Y.Scale,
			startPos.Y.Offset + delta.Y
		)
	end
end)

return {
	CreateTitle = CreateTitle,
	CreateTab = CreateTab,
	CreateButton = CreateButton,
	CreateToggle = CreateToggle,
	GetToggle = GetToggle,
	Loading = Loading
}
