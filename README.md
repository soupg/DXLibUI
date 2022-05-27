
# Welcome to supgLib!

supgLib is a library for [dx9ware](https://cultofintellect.com/dx9ware/) which makes UI implementation within your scripts simple and effecient.

### Current Features
- Creation of multiple dynamic windows
- Creation of multiple dynamic tabs (per window)
- Creation of multiple dynamic group boxes (per tab)
- Creation of multiple dynamic buttons, toggles and sliders (per group box)
- Easily accessible public "tools" storage (`Window.Tools.index.[Value, Name, Boundary, etc]`)

# UI Usage

All of the tools available have lots of functions and properties which are accessible.
Below I will list an ordered list for each function. [Key List](https://cultofintellect.com/dx9ware/docs/GetKey.html) (for SetKeybind)

## Function List

```lua
Lib:SetWatermarkVisibility(Bool)
Lib:SetWatermark(Text, {Location = {x, y}})
Lib:SetKeybind("[KEY]")
Lib:CreateWindow(WindowTitle)

	Window:SetWindowTitle(NewTitle)
	Window:AddTab(TabName)
	
		Tab:Focus()
		Tab:AddGroupbox(Name, Side) --// Side can be "Left" or "Right" | I recommend using the two functions below instead
		Tab:AddLeftGroupbox(Name)
		Tab:AddRightGroupbox(Name)
		
		Groupbox:AddButton(Text, Function) --// Function AND Text can be one-line or multi-line

		Groupbox:AddColorPicker(index, {Default = {r,g,b}, Text = "Text"})
			ColorPicker:OnChanged(Function)
			ColorPicker:SetValue({r,g,b})
			ColorPicker:Show()
			ColorPicker:Hide()

		Groupbox:AddToggle(index, {Default = false, Text = "Text"})
			Toggle:OnChanged(Function)
			Toggle:SetValue(Bool)
		
		Groupbox:AddSlider(index, {Default = 0, Text = "Text", Min = 0, Max = 100, Suffix = "%"}
			Slider:OnChanged(Function)
			Slider:SetValue(Int)
			
		Groupbox:AddLabel(text) --// Supports Multiline
		Groupbox:AddTitle(text) --// Does not support multiline
		Groupbox:AddBlank(sizeNum) --// Adds an empty space of said size
```

## Accessing Values

Nearly all the tools used in supgLib have globally accessible properties. Any indexed item can be accessed like so

```lua
local item = Window.Tools.index --// The index was set by you when making the tool
```

Lets do an example on a toggle

```lua
local Toggle = Groupbox:AddToggle("toggle_1", {Default = false, Text = "Toggle 1"})

--// Accessing the Window.Tools.toggle_1 var is the same as accessing "Toggle" itself
--// Here is what's stored in most toggles:
Local Toggle = {
	Text = params.Text; --// Sets Toggle.Text to passed in text parameter
	Boundary = {0,0,0,0}; --// Sets actual boundary later in the script
	Value = params.Default or false; --// Sets value to the preset or false initially
	Holding = false; --// Variable that determines if mouse is holding the toggle
}
--// If you wanted to change a toggle's text value, you could simply do this
Toggle.Text = "New Text"
--// Same with the value. If you want to check if the toggle is on, do this
if Toggle.Value then
	print("Im ON!")
end
```

This was simply the toggle example, each tool in supgLib has its own set of dynamic properties which you can change to your liking. Just don't mess with anything too important and you'll be fine.

# Credits

- supg#1013 | Lead UI Developer
- Alleexxii#3440 | UI Functions Developer
- Linora | UI Design Concept

# Demo Script

Here is a small demo script I made that showcases nearly all of supgLib's functions. Feel free to use and edit this however you like.

```lua
--// Loading UI
if  _G.supgLib == nil  then
	_G.supgLib = loadstring(dx9.Get("https://raw.githubusercontent.com/soupg/supg_ui/main/ui.lua"))
end  
_G.supgLib()

--// Building UI
Lib:SetWatermark("Watermark name", {Location = {400, 10}})
Lib:SetKeybind("[F5]") --// Sets keynind to F5

--// Creating a Window
local Window = Lib:CreateWindow("Window 1")

--// Creating Tabs
local Tab1 = Window:AddTab("Tab 1")
local Tab2 = Window:AddTab("Tab 2")

--// Creating Groupboxes
local Groupbox1 = Tab1:AddLeftGroupbox("GroupBox 1") 
local Groupbox2 = Tab1:AddRightGroupbox("GroupBox 2")
local Groupbox3 = Tab1:AddLeftGroupbox("GroupBox 3") 
local Groupbox4 = Tab1:AddRightGroupbox("GroupBox 4")

--// Adding a Button
Groupbox1:AddButton("Randomize Window Name", function()
    Window:SetWindowTitle("Random Title "..math.random(1000, 9999))
end)

--// Adding a Toggle
local Toggle1 = Groupbox1:AddToggle("rgb_toggle", {Default = false, Text = "Toggle RGB UI"})

Toggle1:OnChanged(function()
    Window:SetRGB(Toggle1.Value)
end)

--// Adding a Button
Groupbox2:AddButton("Make RGB Toggle True", function() 
    Toggle1:SetValue(true)
end)

--// Adding a Toggle
local Toggle2 = Groupbox2:AddToggle("watermarktoggle", {Default = true, Text = "Toggle Watermark"})

Toggle2:OnChanged(function()
    Lib:SetWatermarkVisibility(Toggle2.Value)
end)

--// Adding 2 Sliders
local slider = Groupbox1:AddSlider("slider1", {Default = 0, Text = "Test Slider", Min = 0, Max = 100, Rounding = 0})
local slider2 = Groupbox1:AddSlider("slider2", {Default = 69, Text = "Second Slider", Min = 0, Max = 100, Rounding = 0})

--// Adding 3 Buttons to Control a Slider
Groupbox2:AddButton("Set Slider to 1%", function() 
    slider:SetValue(1)
end)

Groupbox2:AddButton("Set Slider to 50%", function() 
    slider:SetValue(50)
end)

Groupbox2:AddButton("Set Slider to 100%", function() 
    slider:SetValue(100)
end)
```

