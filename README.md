
# Welcome to supgLib!

## I'm currently working on a docs website, so the info here is temporarily innacurate!

supgLib is a library for [dx9ware](https://cultofintellect.com/dx9ware/) which makes UI implementation within your scripts simple and effecient.

### Current Features
* Creation of multiple dynamic windows
* Creation of multiple dynamic tabs (per window)
* Creation of multiple dynamic group boxes (per tab)
* Easily accessible public "tools" storage (`Window.Tools.index.[Value, Name, Boundary, etc]`)
* These Tools:
	- Buttons
	- Toggles
	- Color Pickers
	- Sliders
	- Labels
	- Blanks
	- Titles
	- Borders
	- Notifications

# UI Usage

All of the tools available have lots of functions and properties which are accessible.
Below I will list an ordered list for each function. [Key List](https://cultofintellect.com/dx9ware/docs/GetKey.html) (for SetKeybind)

## Function List

```lua
Lib:SetWatermarkVisibility(Bool) --// (temporarily does not work)
Lib:SetWatermark(Text, {Location = {x, y}}) --// (temporarily does not work)
Lib:Notify("Notification Message", duration) --// Sends a notification (great when paired with OnChanged!)
Lib:CreateWindow(WindowTitle)

	Window:AddTab(TabName)
	
		Tab:Focus()
		Tab:AddGroupbox(Name, Side) --// Side can be "Left" or "Right" or "Middle"
		Tab:AddLeftGroupbox(Name)
		Tab:AddRightGroupbox(Name)
		
			Groupbox:AddButton(Text, Function) --// Function AND Text can be one-line or multi-line

			Groupbox:AddColorPicker({Index = "unique tool index", Default = {r,g,b}, Text = "Text"})
				ColorPicker:OnChanged(Function)
				ColorPicker:SetValue({r,g,b})
				ColorPicker:Show()
				ColorPicker:Hide()

			Groupbox:AddToggle({Index = "unique tool index", Default = false, Text = "Text"})
				Toggle:OnChanged(Function)
				Toggle:SetValue(Bool)
		
			Groupbox:AddSlider({Index = "unique tool index", Default = 0, Text = "Text", Min = 0, Max = 100, Suffix = "%"}
				Slider:OnChanged(Function)
				Slider:SetValue(Int)
				
			Groupbox:AddDropdown({Index = "unique tool index", Text = "Text", Default = 1, Values = {"Option 1", "Option 2", "Option 3"}})
				Dropdown:SetValues(table)
				Dropdown:Show() 
				Dropdown:Hide() 
				Dropdown:OnChanged(Func) 
				Dropdown:SetValue(val) --// Value can be a number (index of item) or string (name of item)
			
			Groupbox:AddLabel(text) --// Supports Multiline
			Groupbox:AddTitle(text) --// Does not support multiline
			Groupbox:AddBlank(sizeNum) --// Adds an empty space of said size
			Groupbox:AddBorder() --// Adds Border
```


