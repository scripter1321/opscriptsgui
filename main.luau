local players = game:GetService("Players")
local tweenservice = game:GetService("TweenService")
local uis = game:GetService("UserInputService")
local runservice = game:GetService("RunService")

local localplayer = players.LocalPlayer

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

local theme = {
	accent        = Color3.fromRGB(99, 102, 241),
	bg            = Color3.fromRGB(10, 10, 12),
	surface       = Color3.fromRGB(16, 16, 20),
	raised        = Color3.fromRGB(22, 22, 28),
	border        = Color3.fromRGB(38, 38, 48),
	hovered       = Color3.fromRGB(30, 30, 40),
	textprimary   = Color3.new(1, 1, 1),
	textsecondary = Color3.fromRGB(120, 120, 135),
	trackoff      = Color3.fromRGB(38, 38, 48),
	thumboff      = Color3.fromRGB(155, 155, 170),
}
local function manualvertical(parent, padding, top)
	padding = padding or 10
	top = top or 0

	local function update()
		local y = top

		for _, child in ipairs(parent:GetChildren()) do
			if child:IsA("GuiObject") 
				and child.Visible 
				and not child:GetAttribute("IgnoreLayout") then
				child.Position = UDim2.new(
					child.Position.X.Scale,
					child.Position.X.Offset,
					0,
					y
				)

				y += child.AbsoluteSize.Y + padding
			end
		end

		if parent:IsA("ScrollingFrame") then
			parent.CanvasSize = UDim2.new(
				0,
				0,
				0,
				y + padding
			)
		end
	end

	parent.ChildAdded:Connect(function()
		task.defer(update)
	end)

	parent.ChildRemoved:Connect(update)

	update()

	return update
end


local function manualhorizontal(parent, padding)
	padding = padding or 10

	local function update()
		local x = 0

		for _, child in ipairs(parent:GetChildren()) do
			if child:IsA("GuiObject") and child.Visible then

				child.Position = UDim2.new(
					0,
					x,
					child.Position.Y.Scale,
					child.Position.Y.Offset
				)

				x += child.AbsoluteSize.X + padding
			end
		end
	end

	parent.ChildAdded:Connect(function()
		task.defer(update)
	end)

	update()

	return update
end

local themelist = {
	{
		name = "Dark", rainbow = false, swatchcolor = Color3.fromRGB(99, 102, 241),
		accent = Color3.fromRGB(99, 102, 241), bg = Color3.fromRGB(10, 10, 12),
		surface = Color3.fromRGB(16, 16, 20), raised = Color3.fromRGB(22, 22, 28),
		border = Color3.fromRGB(38, 38, 48), hovered = Color3.fromRGB(30, 30, 40),
		textprimary = Color3.new(1, 1, 1), textsecondary = Color3.fromRGB(120, 120, 135),
		trackoff = Color3.fromRGB(38, 38, 48), thumboff = Color3.fromRGB(155, 155, 170),
	},
	{
		name = "Light", rainbow = false, swatchcolor = Color3.fromRGB(79, 82, 221),
		accent = Color3.fromRGB(79, 82, 221), bg = Color3.fromRGB(240, 240, 248),
		surface = Color3.fromRGB(226, 226, 236), raised = Color3.fromRGB(255, 255, 255),
		border = Color3.fromRGB(195, 195, 212), hovered = Color3.fromRGB(240, 240, 252),
		textprimary = Color3.fromRGB(10, 10, 20), textsecondary = Color3.fromRGB(88, 88, 108),
		trackoff = Color3.fromRGB(190, 190, 210), thumboff = Color3.fromRGB(135, 135, 158),
	},
	{
		name = "Midnight", rainbow = false, swatchcolor = Color3.fromRGB(139, 92, 246),
		accent = Color3.fromRGB(139, 92, 246), bg = Color3.fromRGB(4, 4, 14),
		surface = Color3.fromRGB(8, 8, 22), raised = Color3.fromRGB(13, 13, 32),
		border = Color3.fromRGB(34, 34, 70), hovered = Color3.fromRGB(20, 20, 48),
		textprimary = Color3.new(1, 1, 1), textsecondary = Color3.fromRGB(122, 118, 185),
		trackoff = Color3.fromRGB(34, 34, 70), thumboff = Color3.fromRGB(145, 140, 198),
	},
	{
		name = "Rose", rainbow = false, swatchcolor = Color3.fromRGB(244, 63, 94),
		accent = Color3.fromRGB(244, 63, 94), bg = Color3.fromRGB(12, 6, 8),
		surface = Color3.fromRGB(20, 11, 15), raised = Color3.fromRGB(28, 17, 22),
		border = Color3.fromRGB(58, 28, 40), hovered = Color3.fromRGB(38, 22, 30),
		textprimary = Color3.new(1, 1, 1), textsecondary = Color3.fromRGB(182, 118, 138),
		trackoff = Color3.fromRGB(58, 28, 40), thumboff = Color3.fromRGB(195, 135, 155),
	},
	{
		name = "Rainbow", rainbow = true, swatchcolor = nil,
		accent = Color3.fromRGB(99, 102, 241), bg = Color3.fromRGB(10, 10, 12),
		surface = Color3.fromRGB(16, 16, 20), raised = Color3.fromRGB(22, 22, 28),
		border = Color3.fromRGB(38, 38, 48), hovered = Color3.fromRGB(30, 30, 40),
		textprimary = Color3.new(1, 1, 1), textsecondary = Color3.fromRGB(120, 120, 135),
		trackoff = Color3.fromRGB(38, 38, 48), thumboff = Color3.fromRGB(155, 155, 170),
	},
}

local reg = {}
local rainbowconn = nil
local toggleupdaters = {}
local tabsetters = {}
local settingsopen = false
local settingsbtnref = nil

local function regadd(role, obj, prop)
	if not reg[role] then reg[role] = {} end
	table.insert(reg[role], {obj, prop or "BackgroundColor3"})
end

local function applytheme(t)
	if rainbowconn then
		rainbowconn:Disconnect()
		rainbowconn = nil
	end

	for k in pairs(theme) do
		if t[k] ~= nil then
			theme[k] = t[k]
		end
	end

	local speed = TweenInfo.new(0.3, Enum.EasingStyle.Quad)

	for role, entries in pairs(reg) do
		if role ~= "accent" or not t.rainbow then
			local color = theme[role]
			if color then
				for _, entry in ipairs(entries) do
					local obj, prop = entry[1], entry[2]
					if obj and obj.Parent then
						pcall(function()
							tweenservice:Create(obj, speed, {[prop] = color}):Play()
						end)
					end
				end
			end
		end
	end

	for _, updater in ipairs(toggleupdaters) do
		pcall(updater)
	end

	for _, entry in ipairs(tabsetters) do
		pcall(function()
			entry.fn(entry.isactive())
		end)
	end

	if settingsbtnref then
		if settingsopen then
			tweenservice:Create(settingsbtnref, speed, {BackgroundColor3 = theme.accent, TextColor3 = Color3.new(1,1,1)}):Play()
		else
			tweenservice:Create(settingsbtnref, speed, {BackgroundColor3 = theme.raised, TextColor3 = theme.textsecondary}):Play()
		end
	end

	if t.rainbow then
		rainbowconn = runservice.Heartbeat:Connect(function()
			local hue = (tick() * 0.15) % 1
			local c = Color3.fromHSV(hue, 0.75, 1)
			theme.accent = c
			if reg.accent then
				for _, entry in ipairs(reg.accent) do
					local obj, prop = entry[1], entry[2]
					if obj and obj.Parent then
						pcall(function() obj[prop] = c end)
					end
				end
			end
		end)
	end
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
main.BackgroundColor3 = theme.bg
main.BorderSizePixel = 0
main.Active = true
main.Parent = gui
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 16)
regadd("bg", main)

local mainstroke = Instance.new("UIStroke")
mainstroke.Color = theme.border
mainstroke.Thickness = 1
mainstroke.Parent = main
regadd("border", mainstroke, "Color")

local topbar = Instance.new("Frame")
topbar.Name = randomstring(13)
topbar.Size = UDim2.new(1, 0, 0, 52)
topbar.BackgroundColor3 = theme.surface
topbar.BorderSizePixel = 0
topbar.Parent = main
Instance.new("UICorner", topbar).CornerRadius = UDim.new(0, 16)
regadd("surface", topbar)

local topbarfix = Instance.new("Frame")
topbarfix.Size = UDim2.new(1, 0, 0, 16)
topbarfix.Position = UDim2.new(0, 0, 1, -16)
topbarfix.BackgroundColor3 = theme.surface
topbarfix.BorderSizePixel = 0
topbarfix.Parent = topbar
regadd("surface", topbarfix)

local topbarbottomborder = Instance.new("Frame")
topbarbottomborder.Size = UDim2.new(1, 0, 0, 1)
topbarbottomborder.Position = UDim2.new(0, 0, 1, -1)
topbarbottomborder.BackgroundColor3 = theme.border
topbarbottomborder.BorderSizePixel = 0
topbarbottomborder.Parent = topbar
regadd("border", topbarbottomborder)

local titledot = Instance.new("Frame")
titledot.Size = UDim2.new(0, 6, 0, 6)
titledot.Position = UDim2.new(0, 18, 0.5, -3)
titledot.BackgroundColor3 = theme.accent
titledot.BorderSizePixel = 0
titledot.Parent = topbar
Instance.new("UICorner", titledot).CornerRadius = UDim.new(1, 0)
regadd("accent", titledot)

local title = Instance.new("TextLabel")
title.BackgroundTransparency = 1
title.Size = UDim2.new(1, -130, 1, 0)
title.Position = UDim2.new(0, 32, 0, 0)
title.Text = "OpScriptsGUI"
title.Font = Enum.Font.GothamBold
title.TextSize = 14
title.TextColor3 = theme.textprimary
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = topbar
regadd("textprimary", title, "TextColor3")

local toggles = {}
local tabs = {}
local firsttab = nil
local activetabfn = nil
local tabcount = 0

local settingsbtn = Instance.new("TextButton")
settingsbtn.Size = UDim2.new(0, 28, 0, 28)
settingsbtn.Position = UDim2.new(1, -80, 0.5, -14)
settingsbtn.BackgroundColor3 = theme.raised
settingsbtn.Text = "⚙"
settingsbtn.Font = Enum.Font.GothamBold
settingsbtn.TextSize = 15
settingsbtn.TextColor3 = theme.textsecondary
settingsbtn.BorderSizePixel = 0
settingsbtn.Parent = topbar
Instance.new("UICorner", settingsbtn).CornerRadius = UDim.new(1, 0)
regadd("textsecondary", settingsbtn, "TextColor3")
settingsbtnref = settingsbtn

local closebtn = Instance.new("TextButton")
closebtn.Size = UDim2.new(0, 28, 0, 28)
closebtn.Position = UDim2.new(1, -44, 0.5, -14)
closebtn.BackgroundColor3 = theme.raised
closebtn.Text = ""
closebtn.BorderSizePixel = 0
closebtn.Parent = topbar
Instance.new("UICorner", closebtn).CornerRadius = UDim.new(1, 0)
regadd("raised", closebtn)

local xl1 = Instance.new("Frame")
xl1.Size = UDim2.new(0, 11, 0, 1.5)
xl1.Position = UDim2.new(0.5, -5.5, 0.5, -0.75)
xl1.BackgroundColor3 = theme.textsecondary
xl1.BorderSizePixel = 0
xl1.Rotation = 45
xl1.Parent = closebtn
regadd("textsecondary", xl1)

local xl2 = Instance.new("Frame")
xl2.Size = UDim2.new(0, 11, 0, 1.5)
xl2.Position = UDim2.new(0.5, -5.5, 0.5, -0.75)
xl2.BackgroundColor3 = theme.textsecondary
xl2.BorderSizePixel = 0
xl2.Rotation = -45
xl2.Parent = closebtn
regadd("textsecondary", xl2)

closebtn.MouseEnter:Connect(function()
	tweenservice:Create(closebtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(180, 40, 60)}):Play()
	tweenservice:Create(xl1, TweenInfo.new(0.15), {BackgroundColor3 = Color3.new(1,1,1)}):Play()
	tweenservice:Create(xl2, TweenInfo.new(0.15), {BackgroundColor3 = Color3.new(1,1,1)}):Play()
end)
closebtn.MouseLeave:Connect(function()
	tweenservice:Create(closebtn, TweenInfo.new(0.15), {BackgroundColor3 = theme.raised}):Play()
	tweenservice:Create(xl1, TweenInfo.new(0.15), {BackgroundColor3 = theme.textsecondary}):Play()
	tweenservice:Create(xl2, TweenInfo.new(0.15), {BackgroundColor3 = theme.textsecondary}):Play()
end)
closebtn.MouseButton1Click:Connect(function()
	for _, t in pairs(toggles) do t(false) end
	if rainbowconn then rainbowconn:Disconnect() end
	gui:Destroy()
end)

local sidebar = Instance.new("Frame")
sidebar.Name = randomstring(13)
sidebar.Size = UDim2.new(0, 148, 1, -52)
sidebar.Position = UDim2.new(0, 0, 0, 52)
sidebar.BackgroundColor3 = theme.surface
sidebar.BorderSizePixel = 0
sidebar.Parent = main
regadd("surface", sidebar)

local sideborder = Instance.new("Frame")
sideborder.Size = UDim2.new(0, 1, 1, -52)
sideborder.Position = UDim2.new(0, 147, 0, 52)
sideborder.BackgroundColor3 = theme.border
sideborder.BorderSizePixel = 0
sideborder.Parent = main
regadd("border", sideborder)

manualvertical(sidebar, 4, 14)
local content = Instance.new("Frame")
content.Name = randomstring(13)
content.Size = UDim2.new(1, -148, 1, -52)
content.Position = UDim2.new(0, 148, 0, 52)
content.BackgroundTransparency = 1
content.Parent = main

local settingspanel = Instance.new("Frame")
settingspanel.Name = randomstring(13)
settingspanel.Size = UDim2.new(1, -148, 1, -52)
settingspanel.Position = UDim2.new(0, 148, 0, 52)
settingspanel.BackgroundColor3 = theme.bg
settingspanel.BorderSizePixel = 0
settingspanel.Visible = false
settingspanel.ZIndex = 10
settingspanel.Parent = main
Instance.new("UICorner", settingspanel).CornerRadius = UDim.new(0, 16)
regadd("bg", settingspanel)

local settingstitle = Instance.new("TextLabel")
settingstitle.Size = UDim2.new(1, -32, 0, 36)
settingstitle.Position = UDim2.new(0, 20, 0, 16)
settingstitle.BackgroundTransparency = 1
settingstitle.Text = "Settings"
settingstitle.Font = Enum.Font.GothamBold
settingstitle.TextSize = 16
settingstitle.TextColor3 = theme.textprimary
settingstitle.TextXAlignment = Enum.TextXAlignment.Left
settingstitle.ZIndex = 11
settingstitle.Parent = settingspanel
regadd("textprimary", settingstitle, "TextColor3")

local themelabel = Instance.new("TextLabel")
themelabel.Size = UDim2.new(1, -32, 0, 20)
themelabel.Position = UDim2.new(0, 20, 0, 58)
themelabel.BackgroundTransparency = 1
themelabel.Text = "THEME"
themelabel.Font = Enum.Font.GothamBold
themelabel.TextSize = 10
themelabel.TextColor3 = theme.textsecondary
themelabel.TextXAlignment = Enum.TextXAlignment.Left
themelabel.ZIndex = 11
themelabel.Parent = settingspanel
regadd("textsecondary", themelabel, "TextColor3")

local swatchrow = Instance.new("Frame")
swatchrow.Size = UDim2.new(1, -40, 0, 88)
swatchrow.Position = UDim2.new(0, 20, 0, 84)
swatchrow.BackgroundTransparency = 1
swatchrow.ZIndex = 11
swatchrow.Parent = settingspanel

manualhorizontal(swatchrow, 10)

local swatchselectors = {}

for i, td in ipairs(themelist) do
	local swatchbtn = Instance.new("TextButton")
	swatchbtn.Size = UDim2.new(0, 58, 0, 84)
	swatchbtn.BackgroundTransparency = 1
	swatchbtn.Text = ""
	swatchbtn.LayoutOrder = i
	swatchbtn.ZIndex = 11
	swatchbtn.Parent = swatchrow

	local circle = Instance.new("Frame")
	circle.Size = UDim2.new(0, 44, 0, 44)
	circle.Position = UDim2.new(0.5, -22, 0, 0)
	circle.BackgroundColor3 = td.swatchcolor or Color3.fromRGB(200, 200, 200)
	circle.BorderSizePixel = 0
	circle.ZIndex = 12
	circle.Parent = swatchbtn
	Instance.new("UICorner", circle).CornerRadius = UDim.new(1, 0)

	if td.rainbow then
		local grad = Instance.new("UIGradient")
		grad.Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0,    Color3.fromRGB(255, 80, 100)),
			ColorSequenceKeypoint.new(0.33, Color3.fromRGB(80, 220, 100)),
			ColorSequenceKeypoint.new(0.66, Color3.fromRGB(80, 140, 255)),
			ColorSequenceKeypoint.new(1,    Color3.fromRGB(255, 80, 100)),
		})
		grad.Rotation = 90
		grad.Parent = circle
	end

	local checkmark = Instance.new("TextLabel")
	checkmark.Size = UDim2.new(1, 0, 1, 0)
	checkmark.BackgroundTransparency = 1
	checkmark.Text = "✓"
	checkmark.Font = Enum.Font.GothamBold
	checkmark.TextSize = 18
	checkmark.TextColor3 = Color3.new(1, 1, 1)
	checkmark.ZIndex = 13
	checkmark.Visible = false
	checkmark.Parent = circle

	local circlestroke = Instance.new("UIStroke")
	circlestroke.Color = Color3.fromRGB(255, 255, 255)
	circlestroke.Thickness = 2.5
	circlestroke.Transparency = 1
	circlestroke.Parent = circle

	local namelabel = Instance.new("TextLabel")
	namelabel.Size = UDim2.new(1, 0, 0, 22)
	namelabel.Position = UDim2.new(0, 0, 0, 52)
	namelabel.BackgroundTransparency = 1
	namelabel.Text = td.name
	namelabel.Font = Enum.Font.Gotham
	namelabel.TextSize = 11
	namelabel.TextColor3 = theme.textsecondary
	namelabel.ZIndex = 12
	namelabel.Parent = swatchbtn
	regadd("textsecondary", namelabel, "TextColor3")

	local function setselfselected(v)
		tweenservice:Create(circlestroke, TweenInfo.new(0.15), {Transparency = v and 0 or 1}):Play()
		checkmark.Visible = v
	end
	table.insert(swatchselectors, setselfselected)

	if i == 1 then setselfselected(true) end

	local themedata = td
	swatchbtn.MouseButton1Click:Connect(function()
		for _, fn in ipairs(swatchselectors) do fn(false) end
		setselfselected(true)
		applytheme(themedata)
	end)
end

settingsbtn.MouseEnter:Connect(function()
	if not settingsopen then
		tweenservice:Create(settingsbtn, TweenInfo.new(0.15), {BackgroundColor3 = theme.hovered}):Play()
	end
end)
settingsbtn.MouseLeave:Connect(function()
	if not settingsopen then
		tweenservice:Create(settingsbtn, TweenInfo.new(0.15), {BackgroundColor3 = theme.raised}):Play()
	end
end)
settingsbtn.MouseButton1Click:Connect(function()
	settingsopen = not settingsopen
	settingspanel.Visible = settingsopen
	if settingsopen then
		tweenservice:Create(settingsbtn, TweenInfo.new(0.2), {BackgroundColor3 = theme.accent, TextColor3 = Color3.new(1,1,1)}):Play()
	else
		tweenservice:Create(settingsbtn, TweenInfo.new(0.2), {BackgroundColor3 = theme.raised, TextColor3 = theme.textsecondary}):Play()
	end
end)

local function createtab(name)
	tabcount += 1

	local btn = Instance.new("TextButton")
	btn.Name = randomstring(13)
	btn.Size = UDim2.new(0, 128, 0, 38)
	btn.BackgroundColor3 = theme.raised
	btn.BackgroundTransparency = 1
	btn.BorderSizePixel = 0
	btn.Text = ""
	btn.LayoutOrder = tabcount
	btn.Parent = sidebar
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)

	local indicator = Instance.new("Frame")
	indicator.Size = UDim2.new(0, 3, 0.5, 0)
	indicator.Position = UDim2.new(0, 0, 0.25, 0)
	indicator.BackgroundColor3 = theme.accent
	indicator.BackgroundTransparency = 1
	indicator.BorderSizePixel = 0
	indicator.Parent = btn
	Instance.new("UICorner", indicator).CornerRadius = UDim.new(1, 0)
	regadd("accent", indicator)

	local btnlabel = Instance.new("TextLabel")
	btnlabel.Size = UDim2.new(1, -14, 1, 0)
	btnlabel.Position = UDim2.new(0, 14, 0, 0)
	btnlabel.BackgroundTransparency = 1
	btnlabel.Text = name
	btnlabel.Font = Enum.Font.Gotham
	btnlabel.TextSize = 13
	btnlabel.TextColor3 = theme.textsecondary
	btnlabel.TextXAlignment = Enum.TextXAlignment.Left
	btnlabel.Parent = btn

	local page = Instance.new("ScrollingFrame")
	page.Name = randomstring(13)
	page.Size = UDim2.new(1, 0, 1, 0)
	page.CanvasSize = UDim2.new(0, 0, 0, 0)
	page.ScrollBarThickness = 3
	page.ScrollBarImageColor3 = theme.accent
	page.BackgroundTransparency = 1
	page.Visible = false
	page.Parent = content
	regadd("accent", page, "ScrollBarImageColor3")

	manualvertical(page, 10, 18)

	tabs[name] = page

	local function setactive(active)
		if active then
			tweenservice:Create(indicator, TweenInfo.new(0.2), {BackgroundTransparency = 0}):Play()
			tweenservice:Create(btn, TweenInfo.new(0.2), {BackgroundTransparency = 0, BackgroundColor3 = theme.raised}):Play()
			tweenservice:Create(btnlabel, TweenInfo.new(0.2), {TextColor3 = theme.textprimary}):Play()
		else
			tweenservice:Create(indicator, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play()
			tweenservice:Create(btn, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play()
			tweenservice:Create(btnlabel, TweenInfo.new(0.2), {TextColor3 = theme.textsecondary}):Play()
		end
	end

	table.insert(tabsetters, {
		fn = setactive,
		isactive = function() return activetabfn == setactive end
	})

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
			tweenservice:Create(btn, TweenInfo.new(0.12), {BackgroundTransparency = 0, BackgroundColor3 = theme.hovered}):Play()
			tweenservice:Create(btnlabel, TweenInfo.new(0.12), {TextColor3 = theme.textprimary}):Play()
		end
	end)
	btn.MouseLeave:Connect(function()
		if activetabfn ~= setactive then
			tweenservice:Create(btn, TweenInfo.new(0.12), {BackgroundTransparency = 1}):Play()
			tweenservice:Create(btnlabel, TweenInfo.new(0.12), {TextColor3 = theme.textsecondary}):Play()
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
	wrap.Size = UDim2.new(0, 310, 0, 46)
	wrap.BackgroundColor3 = theme.raised
	wrap.BorderSizePixel = 0
	wrap.Parent = page
	wrap.AnchorPoint = Vector2.new(0.5,0)
	wrap.Position = UDim2.new(0.5,0,0,0)
	Instance.new("UICorner", wrap).CornerRadius = UDim.new(0, 10)
	regadd("raised", wrap)


	local wrapstroke = Instance.new("UIStroke")
	wrapstroke.Color = theme.border
	wrapstroke.Thickness = 1
	wrapstroke.Parent = wrap
	regadd("border", wrapstroke, "Color")

	local btn = Instance.new("TextButton")
	btn.Name = randomstring(13)
	btn.Size = UDim2.new(1, -48, 1, 0)
	btn.Position = UDim2.new(0, 16, 0, 0)
	btn.BackgroundTransparency = 1
	btn.Text = btnname
	btn.Font = Enum.Font.Gotham
	btn.TextSize = 14
	btn.TextColor3 = theme.textprimary
	btn.TextXAlignment = Enum.TextXAlignment.Left
	btn.BorderSizePixel = 0
	btn.Parent = wrap
	regadd("textprimary", btn, "TextColor3")

	local arrow = Instance.new("TextLabel")
	arrow.Size = UDim2.new(0, 28, 1, 0)
	arrow.Position = UDim2.new(1, -34, 0, 0)
	arrow.BackgroundTransparency = 1
	arrow.Text = "›"
	arrow.Font = Enum.Font.GothamBold
	arrow.TextSize = 22
	arrow.TextColor3 = theme.textsecondary
	arrow.BorderSizePixel = 0
	arrow.Parent = wrap
	regadd("textsecondary", arrow, "TextColor3")

	local hitbox = Instance.new("TextButton")
	hitbox.Size = UDim2.new(1, 0, 1, 0)
	hitbox.BackgroundTransparency = 1
	hitbox.Text = ""
	hitbox.BorderSizePixel = 0
	hitbox.Parent = wrap

	hitbox.MouseEnter:Connect(function()
		tweenservice:Create(wrap, TweenInfo.new(0.15), {BackgroundColor3 = theme.hovered}):Play()
		tweenservice:Create(wrapstroke, TweenInfo.new(0.15), {Color = theme.accent}):Play()
		tweenservice:Create(arrow, TweenInfo.new(0.15), {TextColor3 = theme.accent}):Play()
	end)
	hitbox.MouseLeave:Connect(function()
		tweenservice:Create(wrap, TweenInfo.new(0.15), {BackgroundColor3 = theme.raised}):Play()
		tweenservice:Create(wrapstroke, TweenInfo.new(0.15), {Color = theme.border}):Play()
		tweenservice:Create(arrow, TweenInfo.new(0.15), {TextColor3 = theme.textsecondary}):Play()
	end)

	if callback then
		hitbox.MouseButton1Click:Connect(callback)
	end

	return btn
end

local function createtoggle(name, tab, callback)
	local page = tabs[tab]
	if not page then page = createtab(tab) end

	local enabled = false

	local wrap = Instance.new("Frame")
	wrap.Name = randomstring(13)
	wrap.Size = UDim2.new(0, 310, 0, 60)
	wrap.BackgroundColor3 = theme.raised
	wrap.BorderSizePixel = 0
	wrap.Parent = page
	wrap.AnchorPoint = Vector2.new(0.5,0)
	wrap.Position = UDim2.new(0.5,0,0,0)
	Instance.new("UICorner", wrap).CornerRadius = UDim.new(0, 10)
	regadd("raised", wrap)

	local wrapstroke = Instance.new("UIStroke")
	wrapstroke.Color = theme.border
	wrapstroke.Thickness = 1
	wrapstroke.Parent = wrap

	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(0.6, 0, 1, 0)
	label.Position = UDim2.new(0, 16, 0, 0)
	label.BackgroundTransparency = 1
	label.Text = name
	label.Font = Enum.Font.Gotham
	label.TextSize = 14
	label.TextColor3 = theme.textprimary
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Parent = wrap
	regadd("textprimary", label, "TextColor3")

	local track = Instance.new("Frame")
	track.Size = UDim2.new(0, 50, 0, 26)
	track.Position = UDim2.new(1, -66, 0.5, -13)
	track.BackgroundColor3 = theme.trackoff
	track.BorderSizePixel = 0
	track.Parent = wrap
	Instance.new("UICorner", track).CornerRadius = UDim.new(1, 0)

	local thumb = Instance.new("Frame")
	thumb.Size = UDim2.new(0, 20, 0, 20)
	thumb.Position = UDim2.new(0, 3, 0.5, -10)
	thumb.BackgroundColor3 = theme.thumboff
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
			tweenservice:Create(track, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {BackgroundColor3 = theme.accent}):Play()
			tweenservice:Create(thumb, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
				Position = UDim2.new(0, 27, 0.5, -10),
				BackgroundColor3 = Color3.new(1, 1, 1)
			}):Play()
			tweenservice:Create(wrapstroke, TweenInfo.new(0.2), {Color = theme.accent}):Play()
		else
			tweenservice:Create(track, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {BackgroundColor3 = theme.trackoff}):Play()
			tweenservice:Create(thumb, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
				Position = UDim2.new(0, 3, 0.5, -10),
				BackgroundColor3 = theme.thumboff
			}):Play()
			tweenservice:Create(wrapstroke, TweenInfo.new(0.2), {Color = theme.border}):Play()
		end
	end

	table.insert(toggleupdaters, update)

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

local function settitle(text)
	title.Text = text
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
	frame.BackgroundColor3 = theme.surface
	frame.BorderSizePixel = 0
	frame.Parent = loadgui
	Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 14)

	local framestroke = Instance.new("UIStroke")
	framestroke.Color = theme.border
	framestroke.Thickness = 1
	framestroke.Parent = frame

	local loadlabel = Instance.new("TextLabel")
	loadlabel.Size = UDim2.new(1, 0, 0, 40)
	loadlabel.Position = UDim2.new(0, 0, 0, 22)
	loadlabel.BackgroundTransparency = 1
	loadlabel.Font = Enum.Font.GothamBold
	loadlabel.TextSize = 15
	loadlabel.TextColor3 = theme.textprimary
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
	progressfill.BackgroundColor3 = theme.accent
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
local function hardcodegame(id)
	if game.PlaceId ~= id then
		settitle("Wrong Game")

		createbutton(
			"You have entered the wrong game.",
			"Main",
			function() end
		)

		error(("Wrong Game (Expected %d, Got %d)"):format(id, game.PlaceId))
	end
end

return {
	CreateTitle = settitle,
	CreateTab = createtab,
	CreateButton = createbutton,
	CreateToggle = createtoggle,
	GetToggle = gettoggle,
	Loading = loading,
	HardcodeGame = hardcodegame
}
