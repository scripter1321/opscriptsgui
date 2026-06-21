# OpScriptsGUI

A clean Roblox UI library made in Luau.

## Features

- Clean modern UI
- Tabs
- Buttons
- Toggles
- Draggable UI
- Resizable UI
- Scrollable tabs
- Invalid Tab Callbacks
- Close button
- Lightweight
- Easy to customize
- Loading

---

# Installation

Load the library:

```lua
local gui = loadstring(game:HttpGet(
	"https://raw.githubusercontent.com/scripter1321/opscriptsgui/main/main.luau?nocache=" .. tick()
))()
```

Using `nocache` is recommended so updates apply instantly.

---

# Create Title

```lua
gui.CreateTitle("My Hub")
```

Changes the topbar title.
Arguments:

| Argument | Type | Description |
|---|---|---|
| Name | string | Title Name |


---

# Loading Screen
```lua
gui.Loading()
```
Makes a clean loading screen that waits a bit to load

---

# Create Tabs

```lua
gui.CreateTab("Player")
gui.CreateTab("Misc")
gui.CreateTab("Teleports")
```

Arguments:

| Argument | Type | Description |
|---|---|---|
| Name | string | Tab name |

The `Main` tab is created automatically.

---
# lockgameid 
```lua
gui.lockgameid(GameID (Num)
```
Arguments:
| Argument | Type | Description |
|---|---|---|
| Id | Number | GameID |

Will let the script only run on the game you set.
---

# Create Buttons

```lua
gui.CreateButton("Example Button", "Main", function()
	print("Button Pressed")
end)
```

Arguments:

| Argument | Type | Description |
|---|---|---|
| BtnName | string | Button text |
| Tab | string | Tab name |
| Callback | function | Function ran when clicked |

---

# Create Toggles

```lua
gui.CreateToggle("Auto Farm", "Main", function(GetToggle)
	while GetToggle() do
		print("Farming")
		task.wait(1)
	end
end)
```

Arguments:

| Argument | Type | Description |
|---|---|---|
| Name | string | Toggle text |
| Tab | string | Tab name |
| Callback | function | Function ran while enabled |

`GetToggle()` returns whether the toggle is enabled or disabled.

---

# Get Toggle State

```lua
print(gui.GetToggle("Auto Farm"))
```

Returns:

```lua
true / false
```

---

# Full Example

```lua
local gui = loadstring(game:HttpGet(
	"https://raw.githubusercontent.com/scripter1321/opscriptsgui/main/main.luau?nocache=" .. tick()
))()
gui.Loading() -- gui.Loading() will create a nice loading gui, its a little buggy for now, but it works.
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
gui.CreateButton("Invalid Tab Button", "Invalid Tab", function() -- this is a fallback example. it will automattically make any tabs that arent made yet but are requested.
	print("Invalid Tab Button Pressed")
end)
```

---

# Features Overview

## Draggable UI

Drag the topbar to move the UI around.

---

## Resizable UI

Drag the bottom-right corner to resize the UI.

---

## Scrollable Tabs

Tabs automatically scroll when content exceeds the page size.

---

## Auto Toggle Shutdown

When the close button is pressed:

- All toggles automatically disable
- All toggle loops stop
- GUI fully destroys itself

---

# Cache Fix

Recommended loadstring:

```lua
local gui = loadstring(game:HttpGet(
	"https://raw.githubusercontent.com/scripter1321/opscriptsgui/main/main.luau?nocache=" .. tick()
))()
```
# Known issues:
When x pressed, toggles stay on.
