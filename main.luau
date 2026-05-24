local players = game:GetService("Players")
local tweenservice = game:GetService("TweenService")
local uis = game:GetService("UserInputService")

local localplayer = players.LocalPlayer

local accent = Color3.fromRGB(99, 102, 241)
local bg = Color3.fromRGB(10, 10, 12)
local surface = Color3.fromRGB(16, 16, 20)
local raised = Color3.fromRGB(22, 22, 28)
local border = Color3.fromRGB(38, 38, 48)
local textprimary = Color3.new(1, 1, 1)
local textsecondary = Color3.fromRGB(120, 120, 135)

local rng = Random.new(os.clock() * 1e6)
local chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
local charcount = #chars

local function randomstring(length)
	local result = table.create(length)
	for i = 1, length do
		result[i] = string.char(string.byte(chars, rng:NextInteger(1, charcount)))
	end
	return table.concat(result)
end

local gui = Instance.new("ScreenGui")
gui.Name = randomstring(13)
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = localplayer:WaitForChild("PlayerGui")

local main = Instance.new("Frame")
main.Name = randomstring(13)
main.Size = UDim2.new(0, 540, 0, 360)
main.Position = UDim2.new(0.5, -270, 0.5, -180)
main.BackgroundColor3 = bg
main.BorderSizePixel = 0
main.Active = true
main.Parent = gui

Instance.new("UICorner", main).CornerRadius = UDim.new(0, 16)

local mainstroke = Instance.new("UIStroke")
mainstroke.Color = border
mainstroke.Thickness = 1
mainstroke.Parent = main

local topbar = Instance.new("Frame")
topbar.Name = randomstring(13)
topbar.Size = UDim2.new(1, 0, 0, 52)
topbar.BackgroundColor3 = surface
topbar.BorderSizePixel = 0
topbar.Parent = main

Instance.new("UICorner", topbar).CornerRadius = UDim.new(0, 16)

local topbarfix = Instance.new("Frame")
topbarfix.Size = UDim2.new(1, 0, 0, 16)
topbarfix.Position = UDim2.new(0, 0, 1, -16)
topbarfix.BackgroundColor3 = surface
topbarfix.BorderSizePixel = 0
topbarfix.Parent = topbar

local topbarbottomborder = Instance.new("Frame")
topbarbottomborder.Size = UDim2.new(1, 0, 0, 1)
topbarbottomborder.Position = UDim2.new(0, 0, 1, -1)
topbarbottomborder.BackgroundColor3 = border
topbarbottomborder.BorderSizePixel = 0
topbarbottomborder.Parent = topbar

local titledot = Instance.new("Frame")
titledot.Size = UDim2.new(0, 6, 0, 6)
titledot.Position = UDim2.new(0, 18, 0.5, -3)
titledot.BackgroundColor3 = accent
titledot.BorderSizePixel = 0
titledot.Parent = topbar
Instance.new("UICorner", titledot).CornerRadius = UDim.new(1, 0)

local title = Instance.new("TextLabel")
title.BackgroundTransparency = 1
title.Size = UDim2.new(1, -90, 1, 0)
title.Position = UDim2.new(0, 32, 0, 0)
title.Text = "OpScriptsGUI"
title.Font = Enum.Font.GothamBold
title.TextSize = 14
title.TextColor3 = textprimary
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = topbar

local toggles = {}
local tabs = {}
local firsttab = nil
local activetabfn = nil

local closebtn = Instance.new("TextButton")
closebtn.Size = UDim2.new(0, 28, 0, 28)
closebtn.Position = UDim2.new(1, -44, 0.5, -14)
closebtn.BackgroundColor3 = Color3.fromRGB(36, 36, 42)
closebtn.Text = ""
closebtn.BorderSizePixel = 0
closebtn.Parent = topbar
Instance.new("UICorner", closebtn).CornerRadius = UDim.new(1, 0)

local xl1 = Instance.new("Frame")
xl1.Size = UDim2.new(0, 11, 0, 1.5)
xl1.Position = UDim2.new(0.5, -5.5, 0.5, -0.75)
xl1.BackgroundColor3 = textsecondary
xl1.BorderSizePixel = 0
xl1.Rotation = 45
xl1.Parent = closebtn

local xl2 = Instance.new("Frame")
xl2.Size = UDim2.new(0, 11, 0, 1.5)
xl2.Position = UDim2.new(0.5, -5.5, 0.5, -0.75)
xl2.BackgroundColor3 = textsecondary
xl2.BorderSizePixel = 0
xl2.Rotation = -45
xl2.Parent = closebtn

closebtn.MouseEnter:Connect(function()
	tweenservice:Create(closebtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(180, 40, 60)}):Play()
	tweenservice:Create(xl1, TweenInfo.new(0.15), {BackgroundColor3 = Color3.new(1,1,1)}):Play()
	tweenservice:Create(xl2, TweenInfo.new(0.15), {BackgroundColor3 = Color3.new(1,1,1)}):Play()
end)

closebtn.MouseLeave:Connect(function()
	tweenservice:Create(closebtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(36, 36, 42)}):Play()
	tweenservice:Create(xl1, TweenInfo.new(0.15), {BackgroundColor3 = textsecondary}):Play()
	tweenservice:Create(xl2, TweenInfo.new(0.15), {BackgroundColor3 = textsecondary}):Play()
end)

closebtn.MouseButton1Click:Connect(function()
	for _, t in pairs(toggles) do t(false) end
	gui:Destroy()
end)

local sidebar = Instance.new("Frame")
sidebar.Name = randomstring(13)
sidebar.Size = UDim2.new(0, 148, 1, -52)
sidebar.Position = UDim2.new(0, 0, 0, 52)
sidebar.BackgroundColor3 = surface
sidebar.BorderSizePixel = 0
sidebar.Parent = main

local sideborder = Instance.new("Frame")
sideborder.Size = UDim2.new(0, 1, 1, -52)
sideborder.Position = UDim2.new(0, 147, 0, 52)
sideborder.BackgroundColor3 = border
sideborder.BorderSizePixel = 0
sideborder.Parent = main

local sidelayout = Instance.new("UIListLayout")
sidelayout.Padding = UDim.new(0, 4)
sidelayout.SortOrder = Enum.SortOrder.LayoutOrder
sidelayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
sidelayout.Parent = sidebar

local sidepadding = Instance.new("UIPadding")
sidepadding.PaddingTop = UDim.new(0, 14)
sidepadding.Parent = sidebar

local content = Instance.new("Frame")
content.Name = randomstring(13)
content.Size = UDim2.new(1, -148, 1, -52)
content.Position = UDim2.new(0, 148, 0, 52)
content.BackgroundTransparency = 1
content.Parent = main

local tabcount = 0

local function settitle(text)
	title.Text = text
end

local function createtab(name)
	tabcount += 1

	local btn = Instance.new("TextButton")
	btn.Name = randomstring(13)
	btn.Size = UDim2.new(0, 128, 0, 38)
	btn.BackgroundColor3 = raised
	btn.BackgroundTransparency = 1
	btn.BorderSizePixel = 0
	btn.Text = ""
	btn.LayoutOrder = tabcount
	btn.Parent = sidebar
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)

	local indicator = Instance.new("Frame")
	indicator.Size = UDim2.new(0, 3, 0.5, 0)
	indicator.Position = UDim2.new(0, 0, 0.25, 0)
	indicator.BackgroundColor3 = accent
	indicator.BackgroundTransparency = 1
	indicator.BorderSizePixel = 0
	indicator.Parent = btn
	Instance.new("UICorner", indicator).CornerRadius = UDim.new(1, 0)

	local btnlabel = Instance.new("TextLabel")
	btnlabel.Size = UDim2.new(1, -14, 1, 0)
	btnlabel.Position = UDim2.new(0, 14, 0, 0)
	btnlabel.BackgroundTransparency = 1
	btnlabel.Text = name
	btnlabel.Font = Enum.Font.Gotham
	btnlabel.TextSize = 13
	btnlabel.TextColor3 = textsecondary
	btnlabel.TextXAlignment = Enum.TextXAlignment.Left
	btnlabel.Parent = btn

	local page = Instance.new("ScrollingFrame")
	page.Name = randomstring(13)
	page.Size = UDim2.new(1, 0, 1, 0)
	page.CanvasSize = UDim2.new(0, 0, 0, 0)
	page.ScrollBarThickness = 3
	page.ScrollBarImageColor3 = accent
	page.BackgroundTransparency = 1
	page.Visible = false
	page.Parent = content

	local layout = Instance.new("UIListLayout")
	layout.Padding = UDim.new(0, 10)
	layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	layout.Parent = page

	local pagepadding = Instance.new("UIPadding")
	pagepadding.PaddingTop = UDim.new(0, 18)
	pagepadding.Parent = page

	layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
		page.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 25)
	end)

	tabs[name] = page

	local function setactive(active)
		if active then
			tweenservice:Create(indicator, TweenInfo.new(0.2), {BackgroundTransparency = 0}):Play()
			tweenservice:Create(btn, TweenInfo.new(0.2), {BackgroundTransparency = 0, BackgroundColor3 = raised}):Play()
			tweenservice:Create(btnlabel, TweenInfo.new(0.2), {TextColor3 = textprimary}):Play()
		else
			tweenservice:Create(indicator, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play()
			tweenservice:Create(btn, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play()
			tweenservice:Create(btnlabel, TweenInfo.new(0.2), {TextColor3 = textsecondary}):Play()
		end
	end

	btn.MouseButton1Click:Connect(function()
		for _, v in pairs(content:GetChildren()) do
			if v:IsA("ScrollingFrame") then v.Visible = false end
		end
		if activetabfn then activetabfn(false) end
		activetabfn = setactive
		setactive(true)
		page.Visible = true
	end)

	btn.MouseEnter:Connect(function()
		if activetabfn ~= setactive then
			tweenservice:Create(btn, TweenInfo.new(0.12), {BackgroundTransparency = 0, BackgroundColor3 = Color3.fromRGB(26, 26, 32)}):Play()
			tweenservice:Create(btnlabel, TweenInfo.new(0.12), {TextColor3 = Color3.fromRGB(180, 180, 195)}):Play()
		end
	end)

	btn.MouseLeave:Connect(function()
		if activetabfn ~= setactive then
			tweenservice:Create(btn, TweenInfo.new(0.12), {BackgroundTransparency = 1}):Play()
			tweenservice:Create(btnlabel, TweenInfo.new(0.12), {TextColor3 = textsecondary}):Play()
		end
	end)

	if not firsttab then
		firsttab = true
		activetabfn = setactive
		setactive(true)
		page.Visible = true
	end

	return page
end

local function createbutton(btnname, tab, callback)
	local page = tabs[tab]
	if not page then page = createtab(tab) end

	local wrap = Instance.new("Frame")
	wrap.Name = randomstring(13)
	wrap.Size = UDim2.new(0, 300, 0, 48)
	wrap.BackgroundColor3 = raised
	wrap.BorderSizePixel = 0
	wrap.Parent = page
	Instance.new("UICorner", wrap).CornerRadius = UDim.new(0, 10)

	local wrapstroke = Instance.new("UIStroke")
	wrapstroke.Color = border
	wrapstroke.Thickness = 1
	wrapstroke.Parent = wrap

	local leftbar = Instance.new("Frame")
	leftbar.Size = UDim2.new(0, 3, 0.5, 0)
	leftbar.Position = UDim2.new(0, 0, 0.25, 0)
	leftbar.BackgroundColor3 = accent
	leftbar.BackgroundTransparency = 1
	leftbar.BorderSizePixel = 0
	leftbar.Parent = wrap
	Instance.new("UICorner", leftbar).CornerRadius = UDim.new(1, 0)

	local btn = Instance.new("TextButton")
	btn.Name = randomstring(13)
	btn.Size = UDim2.new(1, 0, 1, 0)
	btn.BackgroundTransparency = 1
	btn.Text = btnname
	btn.Font = Enum.Font.Gotham
	btn.TextSize = 14
	btn.TextColor3 = textprimary
	btn.BorderSizePixel = 0
	btn.Parent = wrap

	btn.MouseEnter:Connect(function()
		tweenservice:Create(wrap, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(28, 28, 36)}):Play()
		tweenservice:Create(leftbar, TweenInfo.new(0.15), {BackgroundTransparency = 0}):Play()
		tweenservice:Create(wrapstroke, TweenInfo.new(0.15), {Color = accent}):Play()
	end)

	btn.MouseLeave:Connect(function()
		tweenservice:Create(wrap, TweenInfo.new(0.15), {BackgroundColor3 = raised}):Play()
		tweenservice:Create(leftbar, TweenInfo.new(0.15), {BackgroundTransparency = 1}):Play()
		tweenservice:Create(wrapstroke, TweenInfo.new(0.15), {Color = border}):Play()
	end)

	if callback then
		btn.MouseButton1Click:Connect(callback)
	end

	return btn
end

local function createtoggle(name, tab, callback)
	local page = tabs[tab]
	if not page then page = createtab(tab) end

	local enabled = false

	local wrap = Instance.new("Frame")
	wrap.Name = randomstring(13)
	wrap.Size = UDim2.new(0, 300, 0, 56)
	wrap.BackgroundColor3 = raised
	wrap.BorderSizePixel = 0
	wrap.Parent = page
	Instance.new("UICorner", wrap).CornerRadius = UDim.new(0, 10)

	local wrapstroke = Instance.new("UIStroke")
	wrapstroke.Color = border
	wrapstroke.Thickness = 1
	wrapstroke.Parent = wrap

	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(0.65, 0, 1, 0)
	label.Position = UDim2.new(0, 16, 0, 0)
	label.BackgroundTransparency = 1
	label.Text = name
	label.Font = Enum.Font.Gotham
	label.TextSize = 14
	label.TextColor3 = textprimary
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Parent = wrap

	local track = Instance.new("Frame")
	track.Size = UDim2.new(0, 44, 0, 24)
	track.Position = UDim2.new(1, -60, 0.5, -12)
	track.BackgroundColor3 = Color3.fromRGB(38, 38, 48)
	track.BorderSizePixel = 0
	track.Parent = wrap
	Instance.new("UICorner", track).CornerRadius = UDim.new(1, 0)

	local thumb = Instance.new("Frame")
	thumb.Size = UDim2.new(0, 18, 0, 18)
	thumb.Position = UDim2.new(0, 3, 0.5, -9)
	thumb.BackgroundColor3 = Color3.fromRGB(160, 160, 175)
	thumb.BorderSizePixel = 0
	thumb.Parent = track
	Instance.new("UICorner", thumb).CornerRadius = UDim.new(1, 0)

	local trackbtn = Instance.new("TextButton")
	trackbtn.Size = UDim2.new(1, 0, 1, 0)
	trackbtn.BackgroundTransparency = 1
	trackbtn.Text = ""
	trackbtn.Parent = track

	local function update()
		if enabled then
			tweenservice:Create(track, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {BackgroundColor3 = accent}):Play()
			tweenservice:Create(thumb, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
				Position = UDim2.new(0, 23, 0.5, -9),
				BackgroundColor3 = Color3.new(1, 1, 1)
			}):Play()
			tweenservice:Create(wrapstroke, TweenInfo.new(0.2), {Color = accent}):Play()
		else
			tweenservice:Create(track, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {BackgroundColor3 = Color3.fromRGB(38, 38, 48)}):Play()
			tweenservice:Create(thumb, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
				Position = UDim2.new(0, 3, 0.5, -9),
				BackgroundColor3 = Color3.fromRGB(160, 160, 175)
			}):Play()
			tweenservice:Create(wrapstroke, TweenInfo.new(0.2), {Color = border}):Play()
		end
	end

	toggles[name] = function(value)
		if value ~= nil then
			enabled = value
			update()
		end
		return enabled
	end

	trackbtn.MouseButton1Click:Connect(function()
		enabled = not enabled
		update()
		if callback then
			task.spawn(function()
				callback(function() return enabled end)
			end)
		end
	end)

	update()

	return {
		set = function(v) enabled = v update() end,
		get = function() return enabled end
	}
end

local function gettoggle(name)
	if toggles[name] then return toggles[name]() end
	return false
end

local function loading()
	if _G.__opgui_loading then return end
	_G.__opgui_loading = true

	local loadgui = Instance.new("ScreenGui")
	loadgui.Name = randomstring(13)
	loadgui.Parent = localplayer:WaitForChild("PlayerGui")

	local frame = Instance.new("Frame")
	frame.Name = randomstring(13)
	frame.Size = UDim2.new(0, 340, 0, 110)
	frame.Position = UDim2.new(0.5, -170, 0.5, -55)
	frame.BackgroundColor3 = surface
	frame.BorderSizePixel = 0
	frame.Parent = loadgui
	Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 14)

	local framestroke = Instance.new("UIStroke")
	framestroke.Color = border
	framestroke.Thickness = 1
	framestroke.Parent = frame

	local loadlabel = Instance.new("TextLabel")
	loadlabel.Size = UDim2.new(1, 0, 0, 40)
	loadlabel.Position = UDim2.new(0, 0, 0, 22)
	loadlabel.BackgroundTransparency = 1
	loadlabel.Font = Enum.Font.GothamBold
	loadlabel.TextSize = 15
	loadlabel.TextColor3 = textprimary
	loadlabel.Parent = frame

	local progressbg = Instance.new("Frame")
	progressbg.Size = UDim2.new(0.78, 0, 0, 3)
	progressbg.Position = UDim2.new(0.11, 0, 1, -22)
	progressbg.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
	progressbg.BorderSizePixel = 0
	progressbg.Parent = frame
	Instance.new("UICorner", progressbg).CornerRadius = UDim.new(1, 0)

	local progressfill = Instance.new("Frame")
	progressfill.Size = UDim2.new(0, 0, 1, 0)
	progressfill.BackgroundColor3 = accent
	progressfill.BorderSizePixel = 0
	progressfill.Parent = progressbg
	Instance.new("UICorner", progressfill).CornerRadius = UDim.new(1, 0)

	local steps = {"loading.", "loading..", "loading...", "loaded!"}

	for i = 1, #steps do
		loadlabel.Text = steps[i]
		tweenservice:Create(progressfill, TweenInfo.new(0.65, Enum.EasingStyle.Quad), {
			Size = UDim2.new(i / #steps, 0, 1, 0)
		}):Play()
		task.wait(0.8)
	end

	task.wait(0.25)
	tweenservice:Create(frame, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
	task.wait(0.35)
	loadgui:Destroy()
end

local dragging = false
local dragstart
local startpos
local activetouchid = nil

local function begindrag(pos)
	dragging = true
	dragstart = pos
	startpos = main.Position
end

local function enddrag()
	dragging = false
	activetouchid = nil
end

local function movedrag(pos)
	if not dragging then return end
	local delta = pos - dragstart
	local vp = workspace.CurrentCamera.ViewportSize
	main.Position = UDim2.new(0,
		math.clamp(startpos.X.Offset + delta.X, 0, vp.X - main.AbsoluteSize.X),
		0,
		math.clamp(startpos.Y.Offset + delta.Y, 0, vp.Y - main.AbsoluteSize.Y)
	)
end

topbar.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		begindrag(input.Position)
	elseif input.UserInputType == Enum.UserInputType.Touch and not activetouchid then
		activetouchid = input
		begindrag(input.Position)
	end
end)

uis.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		enddrag()
	elseif input.UserInputType == Enum.UserInputType.Touch and input == activetouchid then
		enddrag()
	end
end)

uis.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement then
		movedrag(input.Position)
	elseif input.UserInputType == Enum.UserInputType.Touch and input == activetouchid then
		movedrag(input.Position)
	end
end)

return {
	CreateTitle = settitle,
	CreateTab = createtab,
	CreateButton = createbutton,
	CreateToggle = createtoggle,
	GetToggle = gettoggle,
	Loading = loading
}
