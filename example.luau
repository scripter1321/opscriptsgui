local gui = loadstring(game:HttpGet(
	"https://raw.githubusercontent.com/scripter1321/opscriptsgui/main/main.luau?nocache=" .. tick()
))()

gui.CreateTitle("Test")
gui.CreateTab("Other") --  to create a tab, use CreateTab
-- main tab is a starter tab, the script auto makes it.
gui.CreateToggle("Example Toggle", "Main", function(GetToggle) -- first arg=Button name, second arg=tab name, third arg=function
	while GetToggle() do
		print("Example Toggle On")
		task.wait(1)
	end
end)
gui.CreateButton("Example Button", "Main", function() -- first arg=Button name, second arg=tab name, third arg=function
	print("example button pressed")
end)
gui.CreateButton("Other Tab Button", "Other", function()
	print("other tab button pressed")
end)
