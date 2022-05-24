
# Welcome to supgLib!

supgLib is a library for [dx9ware](https://cultofintellect.com/dx9ware/) which makes UI implementation within your scripts simple and effecient.

### Current Features
- Creation of multiple dynamic windows
- Creation of multiple dynamic tabs (per window)
- Creation of multiple dynamic group boxes (per tab)
- Creation of multiple dynamic buttons, toggles and sliders (per group box)
- Easily accessible public "tools" storage (`Window.Tools.index.[Value, Name, Boundary, etc]`)

# Getting Started

To begin using the library, simply paste in this snippet of code at the top of your code editor.
```lua
if  _G.supgLib == nil  then
	_G.supgLib = loadstring(dx9.Get("https://raw.githubusercontent.com/soupg/supg_ui/main/ui.lua"))
end  
_G.supgLib()
```
You can edit public Lib properties such as watermark and keybind like so
```lua
Lib:SetWatermark("Watermark Text", {Location = {1100, 10}}) --// Sets watermark text and location
Lib:SetWatermarkVisibility(false) --// Changes watermark visibility to true/false
Lib:SetKeybind("[A]") --// Changes library keybind
```
## Creating a window
With supgLib, you can create multiple windows, each having their own collection of tabs, groups, and tools.
Because of this, its required that you 'attach' your window to a varaible.
```lua
local  Window = Lib:CreateWindow("Window Name") --// Creates and displays a window
local  Window2 = Lib:CreateWindow("Window Name 2") --// Creates and displays a second stand-

Window:SetWindowTitle("New Window Name") --// Changes a window's name
Window:AddTab("Tab Name", tabLength) --// Creates a tab in the window, tabLength needs to be an integer
```
By defining windows in such a way, you can access a window's properties. Here are some common window properties:
```lua
Window.Location
Window.Size
Window.Rainbow --// Whether the window is color-changing or not
Window.WindowNum --// The # of the window (1, 2, 3, etc... depending on window count)
Window.Tabs
Window.CurrentTab --// Returns a name of the selected tab
Window.Tools --// Returns all window tools such as buttons, toggles, sliders, and more. This method is very useful.
```
## Creating a tab
Tabs help the UI keep content organized. Each tab contains a collection of group boxes, and those group boxes contain the actual tools such as buttons and toggles.
```lua
local  Tab = Window:AddTab("Tab Name", tabLength) --// Tablength should be scaled based of the name
local  Tab2 = Window:AddTab("Tab Name 2", tabLength) --// Second stand-alone tab
Tab2:Focus() --// Opens the second tab and sets the Window.CurrentTab property to the tab name

local  Groupbox1 = Tab1:AddLeftGroupbox("GroupBox 1") --// Creates a groupbox on the LEFT side of tab 1
local  Groupbox2 = Tab1:AddRightGroupbox("GroupBox 2")--// Creates a groupbox on the RIGHT side of tab 1
```
The group boxes created above will serve as storage containers for our tools. Soon we will create buttons, toggles, and more to populate the group boxes.
## Adding buttons, toggles, and sliders to group boxes
Each group box can be seen as a container that stores a tool.
```lua
local  Groupbox1 = Tab1:AddLeftGroupbox("GroupBox 1") --// Left Group Box
local  Groupbox2 = Tab1:AddRightGroupbox("GroupBox 2") --// Right Group Box

--// Button
Groupbox1:AddButton("Button Text", function()
	--// Everything here will be executed on button click
	print("Button Clicked")
end)

--// Toggle | index should be a unique ID which will be used for Window.Tools.index
local  Toggle = Groupbox1:AddToggle("index", {Default = false, Text = "Toggle Text"})

-- OnChanged function (runs each time the toggle state changes)
Toggle:OnChanged(function()
	print("Toggle State Changed")
end)

local toggled = Toggle.Value --// Toggle.Value accesses the toggle's state

--// Slider | index should be a unique ID which will be used for Window.Tools.index
local  Slider = Groupbox1:AddSlider("index", {Default = 0, Text = "Slider Text", Min = 0, Max = 100, Suffix = ""}) -- Without Suffix: [10/100] | With "%" Suffix: [10%/100%]

-- Similarely to a toggle, a slider also has a :OnChanged function (not demonstrated)
local slider_value = Slider.Value -- Accessable slider value
```
As shown above, all of the tools available have lots of functions and properties which are accessible.
Below I will list an ordered list for each function. [Key List](https://cultofintellect.com/dx9ware/docs/GetKey.html) (for SetKeybind)
## Function List
```lua
Lib:SetWatermarkVisibility(Bool)
Lib:SetWatermark(Text, {Location = {x, y}})
Lib:SetKeybind("[KEY]")
Lib:CreateWindow(WindowTitle)

	Window:SetWindowTitle(NewTitle)
	Window:AddTab(TabName, TabLengthInt)
	
		Tab:Focus()
		Tab:AddGroupbox(Name, Side) --// Side can be "Left" or "Right" | I recommend using the two functions below instead
		Tab:AddLeftGroupbox(Name)
		Tab:AddRightGroupbox(Name)
		
		Groupbox:AddButton(Text, Function) --// Function can by one-line or multi-line

		Groupbox:AddToggle(index, {Default = false, Text = "Text"})
			Toggle:OnChanged(Function)
			Toggle:SetValue(Bool)
		
		Groupbox:AddSlider(index, {Default = 0, Text = "Text", Min = 0, Max = 100, Suffix = "%"}
			Slider:OnChanged(Function)
			Slider:SetValue(Int)
```
## Accessing Values
Nearly all the tools used in supgLib have globally accessible properties. Any indexed item can be accessed like so
```lua
local item = Window.Tools.index
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
The library was fully made by supg from scratch, but as some may notice it was heavily inspired by Linora Lib. I love the way it looks so I based this library off of Linora. Huge credit to the creator of that library as it's amazing. Also credit to Alleexxii for helping with a lot of things overall.

# Demo Script
Here is a small demo script I made that showcases nearly all of supgLib's functions. Feel free to use and edit this however you like.
```lua
--// Loading UI
if _G.supgLib == nil  then
	_G.supgLib = loadstring(dx9.Get("https://raw.githubusercontent.com/soupg/supg_ui/main/ui.lua"))
end  
_G.supgLib()


--// Building UI
Lib:SetWatermark("Watermark name", {Location = {400, 10}})
Lib:SetKeybind("[F5]") --// Sets keynind to F5

--// Creating a Window
local Window = Lib:CreateWindow("Window 1")

--// Creating Tabs
local Tab1 = Window:AddTab("Tab 1", 50)
local Tab2 = Window:AddTab("Tab 2", 50)

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

