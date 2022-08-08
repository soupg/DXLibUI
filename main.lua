--// DXLib UI Library //--

--[[

ADD WINDOW DEADZONES SO U CANT CLICK THROUGH WINDOWS INFRONT

some tools have a line that expands groupbox restraint according to text length, its overriden by text trimming

make tooltips work for all tools

code sections

add multiline notifications

fix colorpicker lag

add toggle keybinds

]]


--// Log Function (Temporary)
local log = "_LOG_\n"
function Log( ... )
    local temp = ""
    for i ,v in pairs( { ... } ) do
        temp = temp..tostring( v ).." "
    end
    log = log..temp.."\n"
    dx9.DrawString( { 1500 ,0 } , { 255 ,255 ,255 } , log );
end


--[[

██████╗ ███████╗███████╗██╗███╗   ██╗██╗███╗   ██╗ ██████╗     ██╗     ██╗██████╗ 
██╔══██╗██╔════╝██╔════╝██║████╗  ██║██║████╗  ██║██╔════╝     ██║     ██║██╔══██╗
██║  ██║█████╗  █████╗  ██║██╔██╗ ██║██║██╔██╗ ██║██║  ███╗    ██║     ██║██████╔╝
██║  ██║██╔══╝  ██╔══╝  ██║██║╚██╗██║██║██║╚██╗██║██║   ██║    ██║     ██║██╔══██╗
██████╔╝███████╗██║     ██║██║ ╚████║██║██║ ╚████║╚██████╔╝    ███████╗██║██████╔╝
╚═════╝ ╚══════╝╚═╝     ╚═╝╚═╝  ╚═══╝╚═╝╚═╝  ╚═══╝ ╚═════╝     ╚══════╝╚═╝╚═════╝ 
                                                                                  
]]


--// Global Dynamic Values
if _G.Lib == nil then
    _G.Lib = { 
        FontColor = { 255 , 255 , 255 }; 
        MainColor = { 25 , 25 , 25 };
        BackgroundColor = { 20 , 20 , 20 };
        AccentColor = { 255 , 50 , 255 }; 
        OutlineColor = { 40 , 40 , 40 };
        Black = { 0 , 0 , 0 };

        RainbowHue = 0; 
        CurrentRainbowColor = { 0 , 0 , 0 }; 
        LogoTick = 0;

        Active = false;

        -- Change later
        Watermark = { 
            Text = "";
            Visible = true;
            Location = { 150 , 10 };
            MouseOffset = nil;
        };

        --// Windows
        Windows = {};
        WindowCount = 0;
        DraggingWindow = nil;

        InitIndex = 0;


        --// Hook Storage
        LoadstringCaching = {};
        GetCaching = {};
        OldLoadstring = loadstring;
        OldGet = dx9.Get;

        OldPrint = print;
        OldError = error;

        --// Console Vars
        C_Location = {1000, 150}; -- Dynamic
        C_Size = {dx9.size().width / 2.95, dx9.size().height / 1.21}; -- Static
        C_Open = true;
        C_Hovering = false;
        C_Dragging = false;
        C_WinMouseOffset = nil;
        C_ErrorColor = {255,100,100};
        C_StoredLogs = {};
        C_Holding = false;

        --// First Run 
        FirstRun = nil;

        --// Notifications
        Notifications = {};

        --// Key
        Key = dx9.GetKey();

        --// Cursor
        Cursor = true;
     };
end
local Lib = _G.Lib
Lib.Key = dx9.GetKey()
local Mouse = dx9.GetMouse()

--// First Run
if Lib.FirstRun == nil then
    Lib.FirstRun = true
elseif Lib.FirstRun == true then 
    Lib.FirstRun = false
end

--[[

 ██████╗ ██╗      ██████╗ ██████╗  █████╗ ██╗         ███████╗██╗   ██╗███╗   ██╗ ██████╗███████╗
██╔════╝ ██║     ██╔═══██╗██╔══██╗██╔══██╗██║         ██╔════╝██║   ██║████╗  ██║██╔════╝██╔════╝
██║  ███╗██║     ██║   ██║██████╔╝███████║██║         █████╗  ██║   ██║██╔██╗ ██║██║     ███████╗
██║   ██║██║     ██║   ██║██╔══██╗██╔══██║██║         ██╔══╝  ██║   ██║██║╚██╗██║██║     ╚════██║
╚██████╔╝███████╗╚██████╔╝██████╔╝██║  ██║███████╗    ██║     ╚██████╔╝██║ ╚████║╚██████╗███████║
 ╚═════╝ ╚══════╝ ╚═════╝ ╚═════╝ ╚═╝  ╚═╝╚══════╝    ╚═╝      ╚═════╝ ╚═╝  ╚═══╝ ╚═════╝╚══════╝

]]


--// Mouse in area check
function Lib.MouseInArea(area, deadzone)
    assert(type(area) == "table" and #area == 4, "[Error] MouseInArea: First Argument needs to be a table with 4 values!")

    if deadzone ~= nil then
        if dx9.GetMouse().x > area[1] and dx9.GetMouse().y > area[2] and dx9.GetMouse().x < area[3] and dx9.GetMouse().y < area[4] then
            if dx9.GetMouse().x > deadzone[1] and dx9.GetMouse().y > deadzone[2] and dx9.GetMouse().x < deadzone[3] and dx9.GetMouse().y < deadzone[4] then
                return false
            else
                return true
            end
        else
            return false
        end
    else
        if dx9.GetMouse().x > area[1] and dx9.GetMouse().y > area[2] and dx9.GetMouse().x < area[3] and dx9.GetMouse().y < area[4] then
            return true
        else
            return false
        end
    end
end


--// RGB to Hex
function Lib:rgbToHex(rgb)
    local hexadecimal = '#'

    for key, value in pairs(rgb) do
        local hex = ''

        while(value > 0)do
            local index = math.fmod(value, 16) + 1
            value = math.floor(value / 16)
            hex = string.sub('0123456789ABCDEF', index, index) .. hex            
        end

        if(string.len(hex) == 0)then
            hex = '00'

        elseif(string.len(hex) == 1)then
            hex = '0' .. hex
        end

        hexadecimal = hexadecimal .. hex
    end
    return hexadecimal
end


--// Get Index From RGB (THIS SHIT TOOK FUCKING 5 HOURS TO MAKE OMG (actually like 2 hours but it felt like 5))
function Lib:GetIndex(clr)
    local FirstBarHue = 0
    local CurrentRainbowColor

    for i = 1, 205 do 

        if FirstBarHue > 1530 then
            FirstBarHue = 0        
        end

        if FirstBarHue <= 255 then
            CurrentRainbowColor = {255, FirstBarHue, 0}
        elseif FirstBarHue <= 510 then
            CurrentRainbowColor = {510 - FirstBarHue, 255, 0}
        elseif FirstBarHue <= 765 then
            CurrentRainbowColor = {0, 255, FirstBarHue - 510}
        elseif FirstBarHue <= 1020 then
            CurrentRainbowColor = {0, 1020 - FirstBarHue, 255}
        elseif FirstBarHue <= 1275 then
            CurrentRainbowColor = {FirstBarHue - 1020, 0, 255}
        elseif FirstBarHue <= 1530 then
            CurrentRainbowColor = {255, 0, 1530 - FirstBarHue}
        end

        FirstBarHue = FirstBarHue + 7.5

        
        local SecondBarHue = 0
        for v = 1, 205 do 
            local Color = {0,0,0}

            if SecondBarHue > 765 then
                SecondBarHue = 0   
            end

            if SecondBarHue < 255 then
                Color = { CurrentRainbowColor[1] * (SecondBarHue / 255)  , CurrentRainbowColor[2] * (SecondBarHue / 255) , CurrentRainbowColor[3] * (SecondBarHue / 255) }
            elseif SecondBarHue < 510 then
                Color = { CurrentRainbowColor[1] + (SecondBarHue - 255)  , CurrentRainbowColor[2] + (SecondBarHue - 255) , CurrentRainbowColor[3] + (SecondBarHue - 255) }
            else
                Color = { (255 - (SecondBarHue - 510))  , (255 - (SecondBarHue - 510)) , (255 - (SecondBarHue - 510)) }
            end

            SecondBarHue = SecondBarHue + 3.75

            if Color[1] > 255 then Color[1] = 255 end
            if Color[2] > 255 then Color[2] = 255 end
            if Color[3] > 255 then Color[3] = 255 end

            local r1 = Color[1]
            local r2 = clr[1]
            local g1 = Color[2]
            local g2 = clr[2]
            local b1 = Color[3]
            local b2 = clr[3]

            if (r1 > (r2 - 2) and r1 < (r2 + 2)) and (g1 > (g2 - 2) and g1 < (g2 + 2)) and (b1 > (b2 - 2) and b1 < (b2 + 2)) then
                return {v,i}
            end
        end
    end
end



--[[
██╗    ██╗██╗███╗   ██╗ ██████╗██╗  ██╗███████╗ ██████╗██╗  ██╗
██║    ██║██║████╗  ██║██╔════╝██║  ██║██╔════╝██╔════╝██║ ██╔╝
██║ █╗ ██║██║██╔██╗ ██║██║     ███████║█████╗  ██║     █████╔╝ 
██║███╗██║██║██║╚██╗██║██║     ██╔══██║██╔══╝  ██║     ██╔═██╗ 
╚███╔███╔╝██║██║ ╚████║╚██████╗██║  ██║███████╗╚██████╗██║  ██╗
 ╚══╝╚══╝ ╚═╝╚═╝  ╚═══╝ ╚═════╝╚═╝  ╚═╝╚══════╝ ╚═════╝╚═╝  ╚═╝
]]


local use_count = 0

function Lib:WinCheck( Win )
    
    use_count = use_count + 1
    
    if use_count > Lib.InitIndex then Lib.InitIndex = use_count end
    
    if Lib.InitIndex == use_count then
        for i,v in pairs( Lib.Windows ) do
            if v.WindowNum > Win.WindowNum then
                v:Render()
            end

            if v.OpenTool then
                v.OpenTool:Render()
            end
        end

        --// Cursor
        if Lib.Cursor and Lib.Active then
            dx9.DrawCircle({Mouse.x, Mouse.y}, Lib.Black, 3)
            dx9.DrawCircle({Mouse.x, Mouse.y}, Lib.CurrentRainbowColor, 2)
        end
    end
end


--[[
██╗  ██╗ ██████╗  ██████╗ ██╗  ██╗███████╗
██║  ██║██╔═══██╗██╔═══██╗██║ ██╔╝██╔════╝
███████║██║   ██║██║   ██║█████╔╝ ███████╗
██╔══██║██║   ██║██║   ██║██╔═██╗ ╚════██║
██║  ██║╚██████╔╝╚██████╔╝██║  ██╗███████║
╚═╝  ╚═╝ ╚═════╝  ╚═════╝ ╚═╝  ╚═╝╚══════╝
]]


if Lib.FirstRun then

    --// Better Loadstring
    function Lib.loadstring(string)
        assert(type(string) == "string", "[Error] loadstring: First Argument needs to be a string!")

        if Lib.LoadstringCaching[string] == nil then
            Lib.LoadstringCaching[string] = Lib.OldLoadstring(string)
        else
            return Lib.LoadstringCaching[string]
        end
    end
    _G.loadstring = Lib.loadstring


    --// Better Get
    function Lib.Get(string)
        assert(type(string) == "string", "[Error] Get: First Argument needs to be a string!")

        if Lib.GetCaching[string] == nil then
            Lib.GetCaching[string] = Lib.OldGet(string)
        else
            return Lib.GetCaching[string]
        end
    end
    _G.dx9.Get = Lib.Get

    --// Hooking Draw Funcs
    for i,v in pairs({"DrawFilledBox", "DrawLine", "DrawBox"}) do
        local old = _G["dx9"][v]
        _G["dx9"][v] = function(...)
            local args = {...}

            if args[1][1] + args[1][2] == 0 then return end
            if args[2][1] + args[2][2] == 0 then return end

            return old(...)
        end
    end

    local old = _G["dx9"]["DrawCircle"]
    _G["dx9"]["DrawCircle"] = function(...)
        local args = {...}

        if args[1][1] + args[1][2] == 0 then return end

        return old(...)
    end

    local old = _G["dx9"]["DrawString"]
    _G["dx9"]["DrawString"] = function(...)
        local args = {...}

        if args[1][1] + args[1][2] == 0 then return end

        return old(...)
    end
end


--[[

██╗     ██╗██████╗ ██████╗  █████╗ ██████╗ ██╗   ██╗
██║     ██║██╔══██╗██╔══██╗██╔══██╗██╔══██╗╚██╗ ██╔╝
██║     ██║██████╔╝██████╔╝███████║██████╔╝ ╚████╔╝ 
██║     ██║██╔══██╗██╔══██╗██╔══██║██╔══██╗  ╚██╔╝  
███████╗██║██████╔╝██║  ██║██║  ██║██║  ██║   ██║   
╚══════╝╚═╝╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝   ╚═╝   

]]




--[[

██╗    ██╗██╗███╗   ██╗██████╗  ██████╗ ██╗    ██╗
██║    ██║██║████╗  ██║██╔══██╗██╔═══██╗██║    ██║
██║ █╗ ██║██║██╔██╗ ██║██║  ██║██║   ██║██║ █╗ ██║
██║███╗██║██║██║╚██╗██║██║  ██║██║   ██║██║███╗██║
╚███╔███╔╝██║██║ ╚████║██████╔╝╚██████╔╝╚███╔███╔╝
 ╚══╝╚══╝ ╚═╝╚═╝  ╚═══╝╚═════╝  ╚═════╝  ╚══╝╚══╝ 

]]


function Lib:CreateWindow( params ) --// Title, FontColor, MainColor, BackgroundColor, AccentColor, OutlineColor, Rainbow, ToggleKey, Size, StartLocation, Resizable, FooterToggle, FooterRGB, FooterMouseCoords

    assert(type(params) == "table", "[Error] CreateWindow: Parameter must be a table!")

    local WindowName = params.Name or params.Title

    local StartRainbow = params.Rainbow or params.RGB or false

    local ToggleKeyPreset = "[ESCAPE]"
    if params.ToggleKey ~= nil and type(params.ToggleKey) == "string" then
        ToggleKeyPreset = string.upper(params.ToggleKey)
    end

    local resizable = params.Resizable or false

    --// Error Handling
    assert(type(WindowName) == "string" or type(WindowName) == "number", "[ERROR] CreateWindow: Window name parameter must be a string or number!")
    assert(type(StartRainbow) == "boolean", "[ERROR] CreateWindow: Rainbow parameter must be a boolean!")
    assert(type(ToggleKeyPreset) == "string" and string.sub(ToggleKeyPreset, 1, 1) == "[", "[ERROR] CreateWindow: ToggleKey needs to have this format: [KEY]!")


    if Lib.Windows[WindowName] == nil then
        Lib.Windows[WindowName] = {
            Location = params.StartLocation or { 100 , 100 };
            Size = params.Size or { 600 , 500 };

            Rainbow = StartRainbow;
    
            Title = WindowName;

            WinMouseOffset = nil;

            WindowNum = Lib.WindowCount + 1; 

            ID = params.Index or WindowName; 

            --// Tab Stuff
            Tabs = {};
            CurrentTab = nil;
            TabMargin = 0;

            --// Dragging / Resizing
            Dragging = false;
            Resizing = false;

            --// Toggle Key 
            ToggleKeyHolding = false;
            ToggleKeyHovering = false;
            ToggleKey = ToggleKeyPreset;
            ToggleReading = false;

            --// RGB Key
            RGBKeyHolding = false;
            RGBKeyHovering = false;

            --// Active 
            Active = true;

            --// Footer
            FooterToggle = true;
            FooterRGB = true;
            FooterMouseCoords = true;

            --// Size Restraint
            Restraint = {160,200};
            InitIndex = 0;

            --// Deadzone 
            DeadZone = nil;

            --// Tools 
            OpenTool = nil;

            --// Color
            FontColor = params.FontColor or Lib.FontColor;
            MainColor = params.MainColor or Lib.MainColor;
            BackgroundColor = params.BackgroundColor or Lib.BackgroundColor;
            AccentColor = params.AccentColor or Lib.AccentColor;
            OutlineColor = params.OutlineColor or Lib.OutlineColor
        }

        Lib.WindowCount = Lib.WindowCount + 1
    end

    local Win = Lib.Windows[WindowName]
    local FooterWidth = 0

    if params.FooterToggle == nil or params.FooterToggle then Win.FooterToggle = true else Win.FooterToggle = false end
    if params.FooterRGB == nil or params.FooterRGB then Win.FooterRGB = true else Win.FooterRGB = false end
    if params.FooterMouseCoords == nil or params.FooterMouseCoords then Win.FooterMouseCoords = true else Win.FooterMouseCoords = false end

    --// Restraints
    function Win:SetRestraint(table)
        if table[1] > Win.Restraint[1] then 
            Win.Restraint[1] = table[1] 
        end

        if table[2] > Win.Restraint[2] then 
            Win.Restraint[2] = table[2] 
        end
    end

    if Win.Size[1] < Win.Restraint[1] then
        Win.Size[1] = Win.Restraint[1]
    end

    if Win.Size[2] < Win.Restraint[2] then
        Win.Size[2] = Win.Restraint[2]
    end

    --// Title Change
    Win.Title = WindowName 

    --// Accent to rainbow change
    if Win.Rainbow then 
        Win.AccentColor = Lib.CurrentRainbowColor 
    else 
        Win.AccentColor = Win.AccentColor or Lib.AccentColor
    end

    --// Keybind Open / Close
    if Lib.Key == Win.ToggleKey and Lib.Key ~= "[ESCAPE]" and not Win.ToggleReading then
        Win.Active = not Win.Active
    end

    if Win.Active then
        Lib.Active = true
    else
        Lib.Active = false
    end

    --// Left Click Held
    if dx9.isLeftClickHeld() and Win.Active then

        --// Drag Func
        if not Win.Resizing and (Win.Dragging or Lib.MouseInArea( { Win.Location[1] - 2 , Win.Location[2] - 2 , Win.Location[1] + Win.Size[1] + 2 , Win.Location[2] + 22 } )) then
            
            --// Window Dragging
            if Lib.DraggingWindow == nil or Lib.DraggingWindow == Win.ID then
                Lib.DraggingWindow = Win.ID

                if not Win.Dragging then Win.Dragging = true end 

                if Win.WinMouseOffset == nil then
                    Win.WinMouseOffset = { dx9.GetMouse().x - Win.Location[1] , dx9.GetMouse().y - Win.Location[2] }
                end

                Win.Location = { dx9.GetMouse().x - Win.WinMouseOffset[1] , dx9.GetMouse().y - Win.WinMouseOffset[2] }
            else
                if Win.WindowNum > Lib.Windows[Lib.DraggingWindow].WindowNum then
                    Lib.DraggingWindow = Win.ID
                else
                    Win.WinMouseOffset = nil
                    Lib.DraggingWindow = nil
                end
            end

        elseif not Win.Dragging and resizable and (Win.Resizing or Lib.MouseInArea({ Win.Location[1] + Win.Size[1] - 10, Win.Location[2] + Win.Size[2] - 10 , Win.Location[1] + Win.Size[1] + 3, Win.Location[2] + Win.Size[2] + 3} )) then
            
            --// Window Resizing
            if not Win.Resizing then Win.Resizing = true end
            
            local x = ( dx9.GetMouse().x - Win.Location[1] )
            local y = ( dx9.GetMouse().y - Win.Location[2] )

            if x < Win.Restraint[1] then x = Win.Restraint[1] end
            if y < Win.Restraint[2] then y = Win.Restraint[2] end

            Win.Size = { x, y }
            
        else

            --// Tab Click Func 
            for i, t in pairs(Win.Tabs) do
                if Lib.MouseInArea( { t.Boundary[1] , t.Boundary[2] , t.Boundary[3] , t.Boundary[4] } ) and not Win.Dragging then
                    Win.CurrentTab = i;
                end
            end
        end
    else
        Win.Resizing = false
        Win.Dragging = false
        Win.WinMouseOffset = nil
        Lib.DraggingWindow = nil
    end

    --// Borders
    if Win.Location[1] < 0 then Win.Location[1] = 0 end
    --if Win.Location[2] < 0 then Win.Location[2] = 0 end
    --if Win.Location[1] + Win.Size[1] > dx9.size().width then Win.Location[1] = dx9.size().width - Win.Size[1] end
    --if Win.Location[2] + Win.Size[2] > dx9.size().height then Win.Location[2] = dx9.size().height - Win.Size[2] end

    --// Display Window //--

    --// Trimming Window Name
    local TrimmedWinName = Win.Title;
    if dx9.CalcTextWidth(TrimmedWinName) >=  Win.Size[1] - 25 then -- CHANGE | Might need adjustments over time
        repeat
            TrimmedWinName = TrimmedWinName:sub(1, -2)
        until dx9.CalcTextWidth(TrimmedWinName) <= Win.Size[1] - 25
    end

    --// Render Window
    function Win:Render()
        if Win.Active then

            --// Drawing Main Box
            if true then

                --// Draw Main Outer
                dx9.DrawFilledBox( { Win.Location[1] - 1 , Win.Location[2] - 1 } , { Win.Location[1] + Win.Size[1] + 1 , Win.Location[2] + Win.Size[2] + 1 } , Lib.Black ) 

                dx9.DrawFilledBox( Win.Location , { Win.Location[1] + Win.Size[1] , Win.Location[2] + Win.Size[2] } , Win.AccentColor )

                dx9.DrawFilledBox( { Win.Location[1] + 1 , Win.Location[2] + 1 } , { Win.Location[1] + Win.Size[1] - 1 , Win.Location[2] + Win.Size[2] - 1 } , Win.MainColor )

                --// Draw Corner
                if resizable then
                    dx9.DrawFilledBox( { Win.Location[1] + Win.Size[1] - 7, Win.Location[2] + Win.Size[2] - 7} , { Win.Location[1] + Win.Size[1] , Win.Location[2] + Win.Size[2] } , Win.AccentColor )

                    dx9.DrawFilledBox( { Win.Location[1] + Win.Size[1] - 6 , Win.Location[2] + Win.Size[2] - 6 } , { Win.Location[1] + Win.Size[1] - 1 , Win.Location[2] + Win.Size[2] - 1 } , Win.MainColor )
                end

                --// Draw Main Inner

                dx9.DrawFilledBox( { Win.Location[1] + 5 , Win.Location[2] + 20 } , { Win.Location[1] + Win.Size[1] - 5 , Win.Location[2] + Win.Size[2] - 32 } , Win.BackgroundColor ) 

                dx9.DrawBox( { Win.Location[1] + 5 , Win.Location[2] + 20 } , { Win.Location[1] + Win.Size[1] - 5 , Win.Location[2] + Win.Size[2] - 31 } , Win.OutlineColor ) 
                dx9.DrawBox( { Win.Location[1] + 6 , Win.Location[2] + 21 } , { Win.Location[1] + Win.Size[1] - 6 , Win.Location[2] + Win.Size[2] - 32 } , Lib.Black ) 

                dx9.DrawString( Win.Location , Win.FontColor , "  "..TrimmedWinName)
                dx9.DrawFilledBox( { Win.Location[1] + 10 , Win.Location[2] + 49 } , { Win.Location[1] + Win.Size[1] - 10 , Win.Location[2] + Win.Size[2] - 36 } , Win.OutlineColor )
                dx9.DrawFilledBox( { Win.Location[1] + 11 , Win.Location[2] + 50 } , { Win.Location[1] + Win.Size[1] - 11 , Win.Location[2] + Win.Size[2] - 37 } , Win.MainColor ) 
            end

            --// Footer //--
            if true then 

                --// Watermark //--
                local Watermark = "     DXLibUI"
                local Watermark_Width = dx9.CalcTextWidth(Watermark)

                dx9.DrawBox( { Win.Location[1] + 5 , Win.Location[2] + Win.Size[2] - 28 } , { Win.Location[1] + 15 + Watermark_Width , Win.Location[2] + Win.Size[2] - 4 } , Win.OutlineColor ) 
                dx9.DrawBox( { Win.Location[1] + 6 , Win.Location[2] + Win.Size[2] - 27 } , { Win.Location[1] + 14 + Watermark_Width , Win.Location[2] + Win.Size[2] - 5 } , Lib.Black ) 
                dx9.DrawFilledBox( { Win.Location[1] + 7 , Win.Location[2] + Win.Size[2] - 26 } , { Win.Location[1] + 13 + Watermark_Width , Win.Location[2] + Win.Size[2] - 6 } , Win.BackgroundColor ) 

                dx9.DrawString( { Win.Location[1] + 10 , Win.Location[2] + Win.Size[2] - 25 } , Lib.CurrentRainbowColor , Watermark)
                FooterWidth = FooterWidth + Watermark_Width + 12

                --// Epic Logo
                local epic = Lib.LogoTick / 10

                local TL = { Win.Location[1] + 12 + epic , Win.Location[2] + Win.Size[2] - 20 }
                local TR = { Win.Location[1] + 20 , Win.Location[2] + Win.Size[2] - 20 + epic }
                local BL = { Win.Location[1] + 12 , Win.Location[2] + Win.Size[2] - 12 - epic }
                local BR = { Win.Location[1] + 20 - epic , Win.Location[2] + Win.Size[2] - 12 }

                dx9.DrawLine({TL[1], TL[2]}, {TR[1], TR[2]}, Lib.CurrentRainbowColor) -- Top
                dx9.DrawLine({BL[1], BL[2]}, {BR[1], BR[2]}, Lib.CurrentRainbowColor) -- Bottom
                dx9.DrawLine({TR[1], TR[2]}, {BR[1], BR[2]}, Lib.CurrentRainbowColor) -- Right
                dx9.DrawLine({BL[1], BL[2]}, {TL[1], TL[2]}, Lib.CurrentRainbowColor) -- Left


                --// Toggle Key //--
                if Win.FooterToggle then
                    local Toggle = "UI Toggle: "..Win.ToggleKey
                    if Win.ToggleKey == "[ESCAPE]" then Toggle = "UI Toggle: [NONE]" end


                    if Win.ToggleReading then Toggle = "Reading Key..." end

                    local Toggle_Width = dx9.CalcTextWidth(Toggle)

                    dx9.DrawBox( { FooterWidth + Win.Location[1] + 5 , Win.Location[2] + Win.Size[2] - 28 } , { FooterWidth + Win.Location[1] + 15 + Toggle_Width , Win.Location[2] + Win.Size[2] - 4 } , Win.OutlineColor ) 

                    if Win.ToggleKeyHovering then
                        dx9.DrawBox( { FooterWidth + Win.Location[1] + 6 , Win.Location[2] + Win.Size[2] - 27 } , { FooterWidth + Win.Location[1] + 14 + Toggle_Width , Win.Location[2] + Win.Size[2] - 5 } , Win.AccentColor ) 
                    else
                        dx9.DrawBox( { FooterWidth + Win.Location[1] + 6 , Win.Location[2] + Win.Size[2] - 27 } , { FooterWidth + Win.Location[1] + 14 + Toggle_Width , Win.Location[2] + Win.Size[2] - 5 } , Lib.Black ) 
                    end

                    dx9.DrawFilledBox( { FooterWidth + Win.Location[1] + 7 , Win.Location[2] + Win.Size[2] - 26 } , { FooterWidth + Win.Location[1] + 13 + Toggle_Width , Win.Location[2] + Win.Size[2] - 6 } , Win.BackgroundColor ) 

                    if Win.ToggleReading then
                        dx9.DrawString( { FooterWidth + Win.Location[1] + 10 , Win.Location[2] + Win.Size[2] - 25 } , Lib.CurrentRainbowColor , Toggle)
                    else
                        dx9.DrawString( { FooterWidth + Win.Location[1] + 10 , Win.Location[2] + Win.Size[2] - 25 } , Win.FontColor , Toggle)
                    end
                    
                    --// Click Detect //--
                    if Lib.MouseInArea( { FooterWidth + Win.Location[1] + 5 , Win.Location[2] + Win.Size[2] - 28 , FooterWidth + Win.Location[1] + 15 + Toggle_Width , Win.Location[2] + Win.Size[2] - 4 }, Win.DeadZone ) then
                        
                        --// Click Detection
                        if dx9.isLeftClickHeld() and not Win.ToggleReading then
                            Win.ToggleKeyHolding = true;
                        else
                            if Win.ToggleKeyHolding and not Win.ToggleReading then
                                Win.ToggleReading = true;

                                Win.ToggleKeyHolding = false;
                            end
                        end

                        --// Hover Detection
                        Win.ToggleKeyHovering = true;
                    else
                        if dx9.isLeftClickHeld() and Win.ToggleReading then
                            Win.ToggleReading = false
                        end
                        Win.ToggleKeyHovering = false;
                        Win.ToggleKeyHolding = false;
                    end
                    

                    --// Toggle Key Set Detect
                    if Win.ToggleReading and Lib.Key ~= "[Unknown]" and Lib.Key ~= "[LBUTTON]" then
                        Win.ToggleKey = Lib.Key
                        Win.ToggleReading = false
                    end

                    FooterWidth = FooterWidth + Toggle_Width + 12
                end

                --// RGB //--
                if Win.FooterRGB then
                    local RGB = "RGB: OFF"
                    local RGB_Width = dx9.CalcTextWidth(RGB)
                    if Win.Rainbow then RGB = "RGB: ON" end


                    dx9.DrawBox( { FooterWidth + Win.Location[1] + 5 , Win.Location[2] + Win.Size[2] - 28 } , { FooterWidth + Win.Location[1] + 15 + RGB_Width , Win.Location[2] + Win.Size[2] - 4 } , Win.OutlineColor ) 

                    if Win.RGBHovering then
                        dx9.DrawBox( { FooterWidth + Win.Location[1] + 6 , Win.Location[2] + Win.Size[2] - 27 } , { FooterWidth + Win.Location[1] + 14 + RGB_Width , Win.Location[2] + Win.Size[2] - 5 } , Win.AccentColor ) 
                    else
                        dx9.DrawBox( { FooterWidth + Win.Location[1] + 6 , Win.Location[2] + Win.Size[2] - 27 } , { FooterWidth + Win.Location[1] + 14 + RGB_Width , Win.Location[2] + Win.Size[2] - 5 } , Lib.Black ) 
                    end

                    dx9.DrawFilledBox( { FooterWidth + Win.Location[1] + 7 , Win.Location[2] + Win.Size[2] - 26 } , { FooterWidth + Win.Location[1] + 13 + RGB_Width , Win.Location[2] + Win.Size[2] - 6 } , Win.BackgroundColor ) 

                    dx9.DrawString( { FooterWidth + Win.Location[1] + 10 , Win.Location[2] + Win.Size[2] - 25 } , Win.FontColor , RGB)


                    --// Click Detect
                    if Lib.MouseInArea( { FooterWidth + Win.Location[1] + 5 , Win.Location[2] + Win.Size[2] - 28 , FooterWidth + Win.Location[1] + 15 + RGB_Width , Win.Location[2] + Win.Size[2] - 4 }, Win.DeadZone ) then
                        
                        --// Click Detection
                        if dx9.isLeftClickHeld() then
                            Win.RGBKeyHolding = true;
                        else
                            if Win.RGBKeyHolding then
                                Win.Rainbow = not Win.Rainbow
                                Win.RGBKeyHolding = false;
                            end
                        end

                        --// Hover Detection
                        Win.RGBHovering = true;
                    else
                        Win.RGBHovering = false;
                        Win.RGBKeyHolding = false;
                    end


                    FooterWidth = FooterWidth + RGB_Width + 12
                end

                --// Mouse Coords //--
                if Win.FooterMouseCoords then
                    local Coords = "Mouse: "..dx9.GetMouse().x..", "..dx9.GetMouse().y
                    local Coords_Width = dx9.CalcTextWidth(Coords)

                    dx9.DrawBox( { FooterWidth + Win.Location[1] + 5 , Win.Location[2] + Win.Size[2] - 28 } , { FooterWidth + Win.Location[1] + 15 + Coords_Width , Win.Location[2] + Win.Size[2] - 4 } , Win.OutlineColor ) 
                    dx9.DrawBox( { FooterWidth + Win.Location[1] + 6 , Win.Location[2] + Win.Size[2] - 27 } , { FooterWidth + Win.Location[1] + 14 + Coords_Width , Win.Location[2] + Win.Size[2] - 5 } , Lib.Black ) 
                    dx9.DrawFilledBox( { FooterWidth + Win.Location[1] + 7 , Win.Location[2] + Win.Size[2] - 26 } , { FooterWidth + Win.Location[1] + 13 + Coords_Width , Win.Location[2] + Win.Size[2] - 6 } , Win.BackgroundColor ) 

                    dx9.DrawString( { FooterWidth + Win.Location[1] + 10 , Win.Location[2] + Win.Size[2] - 25 } , Win.FontColor , Coords)
                    FooterWidth = FooterWidth + 116 + 12
                end

                
            end
        end
    end
    Win:Render()

    --[[
    ████████╗ █████╗ ██████╗ 
    ╚══██╔══╝██╔══██╗██╔══██╗
       ██║   ███████║██████╔╝
       ██║   ██╔══██║██╔══██╗
       ██║   ██║  ██║██████╔╝
       ╚═╝   ╚═╝  ╚═╝╚═════╝                   
    ]]
    
    --// Add Tab Function
    function Win:AddTab( TabName )

        --// Pre-Defs
        local Tab = {}

        --// Init-Defs
        if Win.Tabs[TabName] == nil then
            Win.Tabs[TabName] = { 
                Boundary = { 0 , 0 , 0 , 0 };
                Groupboxes = {};

                Leftstack = 60;
                Rightstack = 60;
             };
        end

        --// Re-Defining
        Tab = Win.Tabs[TabName]; 

        --// Setting TabLength
        local TabLength = dx9.CalcTextWidth( TabName ) + 7
        
        --// Set Restraint
        Win:SetRestraint({Win.TabMargin + TabLength + 24, 0})

        --// Display Tab
        if Win.Active then
            if Win.CurrentTab ~= nil and Win.CurrentTab == TabName then 

                --// If tab selected
                dx9.DrawFilledBox( { Win.Location[1] + 10 + Win.TabMargin , Win.Location[2] + 25 } , { Win.Location[1] + 14 + TabLength + Win.TabMargin , Win.Location[2] + 50 } , Win.OutlineColor )
                dx9.DrawFilledBox( { Win.Location[1] + 11 + Win.TabMargin , Win.Location[2] + 26 } , { Win.Location[1] + 13 + TabLength + Win.TabMargin , Win.Location[2] + 50 } , Win.MainColor )
                dx9.DrawFilledBox( { Win.Location[1] + 12 + Win.TabMargin , Win.Location[2] + 27 } , { Win.Location[1] + 12 + TabLength + Win.TabMargin , Win.Location[2] + 50 } , Win.MainColor )

                dx9.DrawFilledBox( { Win.Location[1] + 11 + Win.TabMargin , Win.Location[2] + 26 } , { Win.Location[1] + 13 + TabLength + Win.TabMargin , Win.Location[2] + 27 } , Win.AccentColor )
            else

                --// Else
                dx9.DrawFilledBox( { Win.Location[1] + 10 + Win.TabMargin , Win.Location[2] + 26 } , { Win.Location[1] + 14 + TabLength + Win.TabMargin , Win.Location[2] + 50 } , Win.OutlineColor )
                dx9.DrawFilledBox( { Win.Location[1] + 11 + Win.TabMargin , Win.Location[2] + 27 } , { Win.Location[1] + 13 + TabLength + Win.TabMargin , Win.Location[2] + 49 } , Win.MainColor )
                dx9.DrawFilledBox( { Win.Location[1] + 12 + Win.TabMargin , Win.Location[2] + 28 } , { Win.Location[1] + 12 + TabLength + Win.TabMargin , Win.Location[2] + 48 } , Win.BackgroundColor )
            end

            --// Draw Tab Name
            dx9.DrawString( { Win.Location[1] + 12 + Win.TabMargin , Win.Location[2] + 28 } , Win.FontColor , " "..TabName )
            
            --// Defining Boundaries and Setting Margin
            Tab.Boundary = { Win.Location[1] + 10 + Win.TabMargin , Win.Location[2] + 26 , Win.Location[1] + 14 + TabLength + Win.TabMargin , Win.Location[2] + 50 }
            Win.TabMargin = Win.TabMargin + TabLength + 3
        end



        --[[
         ██████╗ ██████╗  ██████╗ ██╗   ██╗██████╗ ██████╗  ██████╗ ██╗  ██╗
        ██╔════╝ ██╔══██╗██╔═══██╗██║   ██║██╔══██╗██╔══██╗██╔═══██╗╚██╗██╔╝
        ██║  ███╗██████╔╝██║   ██║██║   ██║██████╔╝██████╔╝██║   ██║ ╚███╔╝ 
        ██║   ██║██╔══██╗██║   ██║██║   ██║██╔═══╝ ██╔══██╗██║   ██║ ██╔██╗ 
        ╚██████╔╝██║  ██║╚██████╔╝╚██████╔╝██║     ██████╔╝╚██████╔╝██╔╝ ██╗
        ╚═════╝ ╚═╝  ╚═╝ ╚═════╝  ╚═════╝ ╚═╝     ╚═════╝  ╚═════╝ ╚═╝  ╚═╝                                                             
        ]]

        function Tab:AddGroupbox(GroupboxName, side)

            --// Error Handling
            assert(type(GroupboxName) == "string" or type(GroupboxName) == "number", "[ERROR] AddGroupbox: First Argument (groupbox name) must be a string or number!")
            side = string.lower(side)

            local Groupbox = {}
            if Tab.Groupboxes[GroupboxName] == nil then
                Tab.Groupboxes[GroupboxName] = { 
                    ToolSpacing = 0;

                    Visible = true;

                    Tools = {};
                    Root = {};

                    Size = {0, 30};
                    WidthRestraint = dx9.CalcTextWidth(GroupboxName) + 50
                };
            end
            Groupbox = Tab.Groupboxes[GroupboxName]

            --// Adjusting Restraint
            if dx9.CalcTextWidth(GroupboxName) + 50 > Groupbox.WidthRestraint then 
                Groupbox.WidthRestraint = dx9.CalcTextWidth(GroupboxName) + 50 
            end

            --// Setting a width restraint (according to groupbox length)
            if side == "right" or side == "left" then
                Groupbox.Size[1] = (Win.Size[1] / 2) - 23
                
                Win:SetRestraint({Groupbox.WidthRestraint * 2, 0})
            else
                Groupbox.Size[1] = (Win.Size[1]) - 40
                Win:SetRestraint({Groupbox.WidthRestraint , 0})
            end
            
            --dx9.DrawBox({Groupbox.Root[1], Groupbox.Root[2]}, {Groupbox.Root[1] + Groupbox.Size[1], Groupbox.Root[2] + Groupbox.Size[2]}, {0, 255, 0}) CHANGE: this lets you view groupbox hitboxes

            --// Display Groupbox
            if Win.CurrentTab ~= nil and Win.CurrentTab == TabName and Win.Active then
                Groupbox.Visible = true

                if side == "left" then

                    --// Left Groupbox
                    dx9.DrawFilledBox( { Win.Location[1] + 20, Win.Location[2] + Tab.Leftstack } , { Win.Location[1] + (Win.Size[1] / 2) - 3, Win.Location[2] + Tab.Leftstack + Groupbox.Size[2] } , Win.OutlineColor )
                    dx9.DrawFilledBox( { Win.Location[1] + 21, Win.Location[2] + Tab.Leftstack + 1 } , { Win.Location[1] + (Win.Size[1] / 2) - 4, Win.Location[2] + Tab.Leftstack + 3 } , Win.AccentColor )
                    dx9.DrawFilledBox( { Win.Location[1] + 21, Win.Location[2] + Tab.Leftstack + 4 } , { Win.Location[1] + (Win.Size[1] / 2) - 4, Win.Location[2] + Tab.Leftstack + Groupbox.Size[2] - 1 } , Win.BackgroundColor )


                    dx9.DrawString( { Win.Location[1] + ( ( Win.Size[1] / 4 + 10) ) - (dx9.CalcTextWidth(GroupboxName) / 2) , Win.Location[2] + Tab.Leftstack + 4 } , Win.FontColor , GroupboxName )

                    Groupbox.Root = { Win.Location[1] + 21, Win.Location[2] + Tab.Leftstack + 10 }

                    Tab.Leftstack = Tab.Leftstack + Groupbox.Size[2] + 10

                    Win:SetRestraint({0, Tab.Leftstack + 35})
                elseif side == "right" then

                    --// Right Groupbox
                    dx9.DrawFilledBox( { Win.Location[1] + (Win.Size[1] / 2) + 3, Win.Location[2] + Tab.Rightstack } , { Win.Location[1] + (Win.Size[1]) - 20, Win.Location[2] + Tab.Rightstack + Groupbox.Size[2] } , Win.OutlineColor )
                    dx9.DrawFilledBox( { Win.Location[1] + (Win.Size[1] / 2) + 4, Win.Location[2] + Tab.Rightstack + 1 } , { Win.Location[1] + (Win.Size[1]) - 21, Win.Location[2] + Tab.Rightstack + 3 } , Win.AccentColor )
                    dx9.DrawFilledBox( { Win.Location[1] + (Win.Size[1] / 2) + 4, Win.Location[2] + Tab.Rightstack + 4 } , { Win.Location[1] + (Win.Size[1]) - 21, Win.Location[2] + Tab.Rightstack + Groupbox.Size[2] - 1 } , Win.BackgroundColor )


                    dx9.DrawString( { ( Win.Location[1] + ( ( Win.Size[1] / 1.4 + 10) ) - (dx9.CalcTextWidth(GroupboxName) / 2)) , Win.Location[2] + Tab.Rightstack + 4 } , Win.FontColor , GroupboxName )

                    Groupbox.Root = {  math.floor(Win.Location[1] + (Win.Size[1] / 2) + 4 + 0.5), math.floor(Win.Location[2] + Tab.Rightstack + 10 + 0.5) }

                    Tab.Rightstack = Tab.Rightstack + Groupbox.Size[2] + 10

                    Win:SetRestraint({0, Tab.Rightstack + 35})
                else

                    --// Middle Groupbox
                    local largest_stack = Tab.Leftstack
                    if Tab.Rightstack > largest_stack then largest_stack = Tab.Rightstack end

                    dx9.DrawFilledBox( { Win.Location[1] + 20, Win.Location[2] + largest_stack } , { Win.Location[1] + (Win.Size[1]) - 20, Win.Location[2] + largest_stack + Groupbox.Size[2] } , Win.OutlineColor )
                    dx9.DrawFilledBox( { Win.Location[1] + 21, Win.Location[2] + largest_stack + 1 } , { Win.Location[1] + (Win.Size[1]) - 21, Win.Location[2] + largest_stack + 3 } , Win.AccentColor )
                    dx9.DrawFilledBox( { Win.Location[1] + 21, Win.Location[2] + largest_stack + 4 } , { Win.Location[1] + (Win.Size[1]) - 21, Win.Location[2] + largest_stack + Groupbox.Size[2] - 1 } , Win.BackgroundColor )


                    dx9.DrawString( { Win.Location[1] + ( ( Win.Size[1] / 2 ) ) - (dx9.CalcTextWidth(GroupboxName) / 2) , Win.Location[2] + largest_stack + 4 } , Win.FontColor , GroupboxName )

                    Groupbox.Root = { Win.Location[1] + 21, Win.Location[2] + largest_stack + 10 }

                    Tab.Leftstack = largest_stack + Groupbox.Size[2] + 10
                    Tab.Rightstack = largest_stack + Groupbox.Size[2] + 10

                    Win:SetRestraint({0, largest_stack + Groupbox.Size[2] + 45})               
                end
                

            else
                Groupbox.Visible = false
            end


            --[[
            ██████╗ ██╗   ██╗████████╗████████╗ ██████╗ ███╗   ██╗
            ██╔══██╗██║   ██║╚══██╔══╝╚══██╔══╝██╔═══██╗████╗  ██║
            ██████╔╝██║   ██║   ██║      ██║   ██║   ██║██╔██╗ ██║
            ██╔══██╗██║   ██║   ██║      ██║   ██║   ██║██║╚██╗██║
            ██████╔╝╚██████╔╝   ██║      ██║   ╚██████╔╝██║ ╚████║
            ╚═════╝  ╚═════╝    ╚═╝      ╚═╝    ╚═════╝ ╚═╝  ╚═══╝                                              
            ]]

            function Groupbox:AddButton( ButtonName , ButtonFunc )
                local idx = "btn_"..ButtonName
                local Button = {}

                if Groupbox.Tools[idx] == nil then
                    Groupbox.Tools[idx] = { 
                        Boundary = { 0 ,0 ,0 ,0 };
                        Holding = false;
                        Hovering = false;
                    }
                end

                Button = Groupbox.Tools[idx]

                --// Draw Button in Groupbox
                if Win.CurrentTab ~= nil and Win.CurrentTab == TabName and Win.Active and Groupbox.Visible then

                    --// Accounting for \n (to make buttons multiline)
                    local n = 0;
                    local NewButtonName = "";
                    if string.gmatch(ButtonName, "([^\n]+)") ~= nil then
                        for i in (string.gmatch(ButtonName, "([^\n]+)")) do

                            local temp = i;
                            if dx9.CalcTextWidth(temp) >=  Groupbox.Size[1] - 20 then
                                repeat
                                    temp = temp:sub(1,-2)
                                until dx9.CalcTextWidth(temp) <= Groupbox.Size[1] - 20
                            end

                            NewButtonName = NewButtonName..temp.."\n"
                            n = n + 1
                        end
                    else
                        NewButtonName = ButtonName
                        n = 1
                    end
                    
                    Groupbox.Size[2] = Groupbox.Size[2] + (7 + (18 * n))

                    --// Calculating button X size
                    local button_x = dx9.CalcTextWidth(NewButtonName) + 7

                    if Groupbox.Size[1] - 10 > button_x then button_x = Groupbox.Size[1] - 10 end

                    if Button.Hovering then
                        dx9.DrawFilledBox( { Groupbox.Root[1] + 4 , Groupbox.Root[2] + 19 + Groupbox.ToolSpacing } , { Groupbox.Root[1] + 4 + button_x , Groupbox.Root[2] + 22 + ((18) * n) + Groupbox.ToolSpacing } , Win.AccentColor )
                    else
                        dx9.DrawFilledBox( { Groupbox.Root[1] + 4 , Groupbox.Root[2] + 19 + Groupbox.ToolSpacing } , { Groupbox.Root[1] + 4 + button_x , Groupbox.Root[2] + 22 + ((18) * n) + Groupbox.ToolSpacing } , Lib.Black )
                    end

                    dx9.DrawFilledBox( { Groupbox.Root[1] + 5 , Groupbox.Root[2] + 20 + Groupbox.ToolSpacing } , { Groupbox.Root[1] + 3 + button_x , Groupbox.Root[2] + 21 + ((18) * n) + Groupbox.ToolSpacing } , Win.OutlineColor )

                    if Button.Holding == true then
                        dx9.DrawFilledBox( { Groupbox.Root[1] + 6 , Groupbox.Root[2] + 21 + Groupbox.ToolSpacing } , { Groupbox.Root[1] + 2 + button_x , Groupbox.Root[2] + 20 + ((18) * n) + Groupbox.ToolSpacing } , Win.OutlineColor )
                    else
                        dx9.DrawFilledBox( { Groupbox.Root[1] + 6 , Groupbox.Root[2] + 21 + Groupbox.ToolSpacing } , { Groupbox.Root[1] + 2 + button_x , Groupbox.Root[2] + 20 + ((18) * n) + Groupbox.ToolSpacing } , Win.MainColor )
                    end

                    dx9.DrawString( { Groupbox.Root[1] + 8 , Groupbox.Root[2] + 20 + Groupbox.ToolSpacing } , Win.FontColor , NewButtonName )

                    --// Boundary and toolspacing
                    Button.Boundary = { Groupbox.Root[1] + 4 , Groupbox.Root[2] + 19 + Groupbox.ToolSpacing , Groupbox.Root[1] + 4 + button_x , Groupbox.Root[2] + 22 + ((18) * n) + Groupbox.ToolSpacing }

                    Groupbox.ToolSpacing = Groupbox.ToolSpacing + (7 + (18 * n))

                    --// Click Detect
                    if Lib.MouseInArea( { Button.Boundary[1] , Button.Boundary[2] , Button.Boundary[3] , Button.Boundary[4] }, Win.DeadZone ) and not Win.Dragging then

                        --// Click Detection
                        if dx9.isLeftClickHeld() then
                            Button.Holding = true;
                        else
                            if Button.Holding == true then
                                if ButtonFunc ~= nil then ButtonFunc() end
                                Button.Holding = false;
                            end
                        end

                        --// Hover Detection
                        Button.Hovering = true;
                    else
                        Button.Hovering = false;
                        Button.Holding = false;
                    end

                    function Button:AddTooltip(string)
                        if Button.Hovering then
                            -- HERE
                        end
                    end
                end

                --// Closing Difines and Resets | Button
                Groupbox.Tools[idx] = Button;

                Lib:WinCheck( Win )
                return Button;
            end


            --[[
             ██████╗ ██████╗ ██╗      ██████╗ ██████╗     ██████╗ ██╗ ██████╗██╗  ██╗███████╗██████╗ 
            ██╔════╝██╔═══██╗██║     ██╔═══██╗██╔══██╗    ██╔══██╗██║██╔════╝██║ ██╔╝██╔════╝██╔══██╗
            ██║     ██║   ██║██║     ██║   ██║██████╔╝    ██████╔╝██║██║     █████╔╝ █████╗  ██████╔╝
            ██║     ██║   ██║██║     ██║   ██║██╔══██╗    ██╔═══╝ ██║██║     ██╔═██╗ ██╔══╝  ██╔══██╗
            ╚██████╗╚██████╔╝███████╗╚██████╔╝██║  ██║    ██║     ██║╚██████╗██║  ██╗███████╗██║  ██║
            ╚═════╝ ╚═════╝ ╚══════╝ ╚═════╝ ╚═╝  ╚═╝    ╚═╝     ╚═╝ ╚═════╝╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝
            :AddColorPicker({Text = "Color Picker", Default = {0, 0, 0} } )                                                                      
            ]]

            function Groupbox:AddColorPicker(params)

                --// Pre-Defs
                local Picker = {}
                local Text = params.Text or params.Name or params.Index
                local Index = params.Index or Text

                --// Error Handling
                assert(type(Text) == "string" or type(Text) == "number", "[ERROR] AddColorPicker: Name / Text Variable must be a number or string!")
                
                --// Init-Defs
                if Groupbox.Tools[Index] == nil then
                    Groupbox.Tools[Index] = { 
                        Boundary = { 0 , 0 , 0 , 0 };
                        Value = params.Default or {0,0,0};
                        Holding = false;
                        Hovering = false;
                        AddonY = nil;
                        Changed = true;

                        TopColor = params.Default or {0,0,0};
                        StoredIndex = Lib:GetIndex((params.Default or {0,0,0}))[1];
                        StoredIndex2 = Lib:GetIndex((params.Default or {0,0,0}))[2];

                        --// Bar Hovering
                        FirstBarHovering = false;
                        SecondBarHovering = false;
                    }
                end

                --// Re-Defines
                Groupbox.Tools[Index].Text = Text
                Picker = Groupbox.Tools[Index]

                --// SetValue
                function Picker:SetValue( value )
                    Picker.Value = value;
                    Picker.StoredIndex = Lib:GetIndex(value)[1];
                    Picker.StoredIndex2 = Lib:GetIndex(value)[2];
                    Picker.Changed = true 
                end

                --// Picker Show / Hide
                function Picker:Show()
                    Win.OpenTool = Picker
                end

                function Picker:Hide()
                    Win.OpenTool = nil 
                    Win.DeadZone = nil
                end

                --// Draw Color Picker in Groupbox
                if Win.CurrentTab ~= nil and Win.CurrentTab == TabName and Win.Active and Groupbox.Visible then

                    --// Draw Color Picker
                    if Picker.Hovering then
                        dx9.DrawFilledBox( { Groupbox.Root[1] + 6 , Groupbox.Root[2] + 21 + Groupbox.ToolSpacing } , { Groupbox.Root[1] + 33 , Groupbox.Root[2] + 38 + Groupbox.ToolSpacing } , Win.AccentColor )
                    else
                        dx9.DrawFilledBox( { Groupbox.Root[1] + 6 , Groupbox.Root[2] + 21 + Groupbox.ToolSpacing } , { Groupbox.Root[1] + 33 , Groupbox.Root[2] + 38 + Groupbox.ToolSpacing } , Lib.Black )
                    end

                    dx9.DrawFilledBox( { Groupbox.Root[1] + 7 , Groupbox.Root[2] + 22 + Groupbox.ToolSpacing } , { Groupbox.Root[1] + 32 , Groupbox.Root[2] + 37 + Groupbox.ToolSpacing } , Win.OutlineColor )

                    dx9.DrawFilledBox( { Groupbox.Root[1] + 8 , Groupbox.Root[2] + 23 + Groupbox.ToolSpacing } , { Groupbox.Root[1] + 31 , Groupbox.Root[2] + 36 + Groupbox.ToolSpacing } , Picker.Value )

                    --// Trimming Text
                    local TrimmedToggleText = Text;
                    if dx9.CalcTextWidth(TrimmedToggleText) >=  Groupbox.Size[1] - 45 then 
                        repeat
                            TrimmedToggleText = TrimmedToggleText:sub(1,-2)
                        until dx9.CalcTextWidth(TrimmedToggleText) <= Groupbox.Size[1] - 45
                    end

                    --// Drawing Text
                    dx9.DrawString( { Groupbox.Root[1] + 33 , Groupbox.Root[2] + 19 + Groupbox.ToolSpacing } , Win.FontColor , " "..TrimmedToggleText)

                    --// Boundaries and Addon
                    Picker.Boundary = { Groupbox.Root[1] + 4 , Groupbox.Root[2] + 19 + Groupbox.ToolSpacing ,  Groupbox.Root[1] + Groupbox.Size[1] - 5 , Groupbox.Root[2] + 40 + Groupbox.ToolSpacing }
                    Picker.AddonY = Groupbox.ToolSpacing

                    --// Render Picker Box
                    function Picker:Render()
                        if Win.CurrentTab ~= nil and Win.CurrentTab == TabName and Win.Active and Groupbox.Visible then
                            Win.DeadZone = { Groupbox.Root[1] + 6 , Groupbox.Root[2] + 42 + Picker.AddonY, Groupbox.Root[1] + 223 , Groupbox.Root[2] + 125 + Picker.AddonY }

                            dx9.DrawFilledBox( { Groupbox.Root[1] + 6 , Groupbox.Root[2] + 42 + Picker.AddonY } , { Groupbox.Root[1] + 223 , Groupbox.Root[2] + 125 + Picker.AddonY } , Lib.Black )
                            dx9.DrawFilledBox( { Groupbox.Root[1] + 7 , Groupbox.Root[2] + 43 + Picker.AddonY } , { Groupbox.Root[1] + 222 , Groupbox.Root[2] + 124 + Picker.AddonY } , Win.OutlineColor )
                            dx9.DrawFilledBox( { Groupbox.Root[1] + 8 , Groupbox.Root[2] + 44 + Picker.AddonY } , { Groupbox.Root[1] + 221 , Groupbox.Root[2] + 123 + Picker.AddonY } , Win.BackgroundColor )

                            dx9.DrawFilledBox( { Groupbox.Root[1] + 8 , Groupbox.Root[2] + 44 + Picker.AddonY } , { Groupbox.Root[1] + 221 , Groupbox.Root[2] + 46 + Picker.AddonY } , Win.AccentColor )

                            --// DRAWING THE COLORS BRUH
                            -- Bar 1
                            if Picker.SecondBarHovering then
                                dx9.DrawFilledBox( { Groupbox.Root[1] + 10 , Groupbox.Root[2] + 49 + Picker.AddonY } , { Groupbox.Root[1] + 220 , Groupbox.Root[2] + 71 + Picker.AddonY } , Win.AccentColor )
                            else
                                dx9.DrawFilledBox( { Groupbox.Root[1] + 10 , Groupbox.Root[2] + 49 + Picker.AddonY } , { Groupbox.Root[1] + 220 , Groupbox.Root[2] + 71 + Picker.AddonY } , Lib.Black )
                            end
                            
                            dx9.DrawFilledBox( { Groupbox.Root[1] + 11 , Groupbox.Root[2] + 50 + Picker.AddonY } , { Groupbox.Root[1] + 219 , Groupbox.Root[2] + 70 + Picker.AddonY } , Win.OutlineColor )
                            dx9.DrawFilledBox( { Groupbox.Root[1] + 12 , Groupbox.Root[2] + 51 + Picker.AddonY } , { Groupbox.Root[1] + 218 , Groupbox.Root[2] + 69 + Picker.AddonY } , Win.AccentColor )
                            

                            -- Bar 2
                            if Picker.FirstBarHovering then
                                dx9.DrawFilledBox( { Groupbox.Root[1] + 10 , Groupbox.Root[2] + 49 + 25 + Picker.AddonY } , { Groupbox.Root[1] + 220 , Groupbox.Root[2] + 71 + 25 + Picker.AddonY } , Win.AccentColor )
                            else
                                dx9.DrawFilledBox( { Groupbox.Root[1] + 10 , Groupbox.Root[2] + 49 + 25 + Picker.AddonY } , { Groupbox.Root[1] + 220 , Groupbox.Root[2] + 71 + 25 + Picker.AddonY } , Lib.Black )
                            end
                            dx9.DrawFilledBox( { Groupbox.Root[1] + 11 , Groupbox.Root[2] + 50 + 25 + Picker.AddonY } , { Groupbox.Root[1] + 219 , Groupbox.Root[2] + 70 + 25 + Picker.AddonY } , Win.OutlineColor )
                            dx9.DrawFilledBox( { Groupbox.Root[1] + 12 , Groupbox.Root[2] + 51 + 25 + Picker.AddonY } , { Groupbox.Root[1] + 218 , Groupbox.Root[2] + 69 + 25 + Picker.AddonY } , Win.AccentColor )

                            -- Rest
                            dx9.DrawFilledBox( { Groupbox.Root[1] + 10 , Groupbox.Root[2] + 49 + 50 + Picker.AddonY } , { Groupbox.Root[1] + 113 , Groupbox.Root[2] + 71 + 50 + Picker.AddonY } , Lib.Black )
                            dx9.DrawFilledBox( { Groupbox.Root[1] + 11 , Groupbox.Root[2] + 50 + 50 + Picker.AddonY } , { Groupbox.Root[1] + 112 , Groupbox.Root[2] + 70 + 50 + Picker.AddonY } , Win.OutlineColor )
                            dx9.DrawFilledBox( { Groupbox.Root[1] + 12 , Groupbox.Root[2] + 51 + 50 + Picker.AddonY } , { Groupbox.Root[1] + 111 , Groupbox.Root[2] + 69 + 50 + Picker.AddonY } , Win.MainColor )

                            dx9.DrawString( { Groupbox.Root[1] + 12 , Groupbox.Root[2] + 51 + 50 + Picker.AddonY } , Win.FontColor , " "..Lib:rgbToHex(Picker.Value))

                            dx9.DrawFilledBox( { Groupbox.Root[1] + 116 , Groupbox.Root[2] + 49 + 50 + Picker.AddonY } , { Groupbox.Root[1] + 219 , Groupbox.Root[2] + 71 + 50 + Picker.AddonY } , Lib.Black )
                            dx9.DrawFilledBox( { Groupbox.Root[1] + 117 , Groupbox.Root[2] + 50 + 50 + Picker.AddonY } , { Groupbox.Root[1] + 218 , Groupbox.Root[2] + 70 + 50 + Picker.AddonY } , Win.OutlineColor )
                            dx9.DrawFilledBox( { Groupbox.Root[1] + 118 , Groupbox.Root[2] + 51 + 50 + Picker.AddonY } , { Groupbox.Root[1] + 217 , Groupbox.Root[2] + 69 + 50 + Picker.AddonY } , Win.MainColor )

                            -- rgb
                            dx9.DrawString( { Groupbox.Root[1] + 118 , Groupbox.Root[2] + 51 + 50 + Picker.AddonY } , Win.FontColor , " ".. math.floor(Picker.Value[1] + 0.5)..", ".. math.floor(Picker.Value[2] + 0.5)..", ".. math.floor(Picker.Value[3] + 0.5))

                            --// AIDS BELOW
                            local FirstBarHue = 0
                            local CurrentRainbowColor

                            for i = 1, 205 do 

                                if FirstBarHue > 1530 then
                                    FirstBarHue = 0        
                                end

                                if FirstBarHue <= 255 then
                                    CurrentRainbowColor = {255, FirstBarHue, 0}
                                elseif FirstBarHue <= 510 then
                                    CurrentRainbowColor = {510 - FirstBarHue, 255, 0}
                                elseif FirstBarHue <= 765 then
                                    CurrentRainbowColor = {0, 255, FirstBarHue - 510}
                                elseif FirstBarHue <= 1020 then
                                    CurrentRainbowColor = {0, 1020 - FirstBarHue, 255}
                                elseif FirstBarHue <= 1275 then
                                    CurrentRainbowColor = {FirstBarHue - 1020, 0, 255}
                                elseif FirstBarHue <= 1530 then
                                    CurrentRainbowColor = {255, 0, 1530 - FirstBarHue}
                                end

                                FirstBarHue = FirstBarHue + 7.5

                                if Lib.MouseInArea({ Groupbox.Root[1] + 12 , Groupbox.Root[2] + 51 + Picker.AddonY , Groupbox.Root[1] + 217, Groupbox.Root[2] + 69 + Picker.AddonY }) then
                                    Picker.SecondBarHovering = true

                                    if dx9.isLeftClickHeld() and Lib.MouseInArea({ Groupbox.Root[1] + 12 + i , Groupbox.Root[2] + 51 + Picker.AddonY, Groupbox.Root[1] + 15 + i , Groupbox.Root[2] + 69 + Picker.AddonY }) and not Win.Dragging then
                                        if i < 5 then 
                                            Picker.StoredIndex2 = 1 
                                        elseif i > 200 then 
                                            Picker.StoredIndex2 = 205
                                        else 
                                            Picker.StoredIndex2 = i 
                                        end
                                    end
                                else
                                    Picker.SecondBarHovering = false
                                end

                                if Picker.StoredIndex2 == i then Picker.TopColor = CurrentRainbowColor end

                                dx9.DrawBox( { Groupbox.Root[1] + 12 + i , Groupbox.Root[2] + 51 + Picker.AddonY } , { Groupbox.Root[1] + 12 + i , Groupbox.Root[2] + 69 + Picker.AddonY }, CurrentRainbowColor)
                            end

                            local SecondBarHue = 0
                            for i = 1, 205 do 
                                local Color = {0,0,0}

                                --if SecondBarHue > 765
                                if SecondBarHue > 765 then
                                    SecondBarHue = 0  
                                end

                                if SecondBarHue < 255 then
                                    Color = { Picker.TopColor[1] * (SecondBarHue / 255)  , Picker.TopColor[2] * (SecondBarHue / 255) , Picker.TopColor[3] * (SecondBarHue / 255) }
                                elseif SecondBarHue < 510 then
                                    Color = { Picker.TopColor[1] + (SecondBarHue - 255)  , Picker.TopColor[2] + (SecondBarHue - 255) , Picker.TopColor[3] + (SecondBarHue - 255) }
                                else
                                    Color = { (255 - (SecondBarHue - 510))  , (255 - (SecondBarHue - 510)) , (255 - (SecondBarHue - 510)) }
                                end

                                SecondBarHue = SecondBarHue + 3.75

                                if Color[1] > 255 then Color[1] = 255 end
                                if Color[2] > 255 then Color[2] = 255 end
                                if Color[3] > 255 then Color[3] = 255 end

                                if Lib.MouseInArea({ Groupbox.Root[1] + 12 , Groupbox.Root[2] + 51 + 25 + Picker.AddonY , Groupbox.Root[1] + 217, Groupbox.Root[2] + 69 + 25 + Picker.AddonY }) then
                                    Picker.FirstBarHovering = true

                                    if dx9.isLeftClickHeld() and Lib.MouseInArea({ Groupbox.Root[1] + 12 + i, Groupbox.Root[2] + 51 + 25 + Picker.AddonY , Groupbox.Root[1] + 15 + i, Groupbox.Root[2] + 69 + 25 + Picker.AddonY }) and not Win.Dragging then
                                        if i < 5 then 
                                            Picker.StoredIndex = 1
                                        elseif i >= 66 and i <= 72 then
                                            Picker.StoredIndex = 69
                                        elseif i >= 134 and i <= 140 then
                                            Picker.StoredIndex = 137 
                                        elseif i > 200 then 
                                            Picker.StoredIndex = 205
                                        else 
                                            Picker.StoredIndex = i 
                                        end
                                    end
                                else
                                    Picker.FirstBarHovering = false
                                end

                                if Picker.StoredIndex == i then 
                                    if Color ~= Picker.Value then
                                        Picker.Value = Color
                                        Picker.Changed = true 
                                    end
                                end

                                dx9.DrawBox( { Groupbox.Root[1] + 12 + i, Groupbox.Root[2] + 51 + 25 + Picker.AddonY } , { Groupbox.Root[1] + 12 + i, Groupbox.Root[2] + 69 + 25 + Picker.AddonY }, Color )
                            end

                            dx9.DrawFilledBox( { Groupbox.Root[1] + 12 + Picker.StoredIndex2 , Groupbox.Root[2] + 50 + Picker.AddonY } , { Groupbox.Root[1] + 15 + Picker.StoredIndex2 , Groupbox.Root[2] + 70 + Picker.AddonY } , Win.OutlineColor )
                            dx9.DrawBox( { Groupbox.Root[1] + 12 + Picker.StoredIndex2 , Groupbox.Root[2] + 49 + Picker.AddonY } , { Groupbox.Root[1] + 15 + Picker.StoredIndex2 , Groupbox.Root[2] + 71 + Picker.AddonY } , Lib.Black )

                            dx9.DrawFilledBox( { Groupbox.Root[1] + 12 + Picker.StoredIndex, Groupbox.Root[2] + 75 + Picker.AddonY } , { Groupbox.Root[1] + 15 + Picker.StoredIndex , Groupbox.Root[2] + 95 + Picker.AddonY } , Win.OutlineColor )
                            dx9.DrawBox( { Groupbox.Root[1] + 12 + Picker.StoredIndex, Groupbox.Root[2] + 74 + Picker.AddonY } , { Groupbox.Root[1] + 15 + Picker.StoredIndex , Groupbox.Root[2] + 96 + Picker.AddonY } , Lib.Black )
                        end
                    end

                    --// Expand Groupbox
                    Groupbox.Size[2] = Groupbox.Size[2] + 25
                    Groupbox.ToolSpacing = Groupbox.ToolSpacing + 25

                    --// Click Detect
                    if Lib.MouseInArea( { Picker.Boundary[1] , Picker.Boundary[2] , Picker.Boundary[3] , Picker.Boundary[4] }, Win.DeadZone ) and not Win.Dragging then
                        
                        --// Click Detection
                        if dx9.isLeftClickHeld() then
                            Picker.Holding = true;
                        else
                            if Picker.Holding == true then
                                if Win.OpenTool == Picker then Picker:Hide() else Picker:Show() end
                                Picker.Holding = false;
                            end
                        end

                        --// Hover Detection
                        Picker.Hovering = true;
                    else
                        Picker.Hovering = false;
                        Picker.Holding = false;
                    end
                end

                --// Picker Onchanged
                function Picker:OnChanged( func )
                    if Picker.Changed then
                        Picker.Changed = false
                        func(Picker.Value)
                    end
                    return Picker;
                end

                --// Closing Difines and Resets | Picker
                Groupbox.Tools[Index] = Picker;

                Lib:WinCheck( Win ) 
                return Picker;
            end


            --[[
            ████████╗██╗████████╗██╗     ███████╗
            ╚══██╔══╝██║╚══██╔══╝██║     ██╔════╝
               ██║   ██║   ██║   ██║     █████╗  
               ██║   ██║   ██║   ██║     ██╔══╝  
               ██║   ██║   ██║   ███████╗███████╗
               ╚═╝   ╚═╝   ╚═╝   ╚══════╝╚══════╝
            :AddTitle(text)                        
            ]]

            function Groupbox:AddTitle(text)

                --// Draw Title in Groupbox
                if Win.CurrentTab ~= nil and Win.CurrentTab == TabName and Win.Active and Groupbox.Visible then
                    
                    --// Trimming Text
                    local trimmed_text = text;
                    if dx9.CalcTextWidth(text) >=  Groupbox.Size[1] - 15 then
                        repeat
                            trimmed_text = trimmed_text:sub(1,-2)
                        until dx9.CalcTextWidth(trimmed_text) <= Groupbox.Size[1] - 15
                    end

                    --// Displaying Title
                    dx9.DrawString( { Groupbox.Root[1] + 6 , Groupbox.Root[2] + 21 + Groupbox.ToolSpacing } , Win.FontColor , trimmed_text)
                    dx9.DrawFilledBox( { Groupbox.Root[1] + 5 , Groupbox.Root[2] + 40 + Groupbox.ToolSpacing } , { Groupbox.Root[1] + Groupbox.Size[1] - 7, Groupbox.Root[2] + 42 + Groupbox.ToolSpacing } , Win.AccentColor )

                    --// Expanding Groupbox
                    Groupbox.Size[2] = Groupbox.Size[2] + (7 + 18)
                    Groupbox.ToolSpacing = Groupbox.ToolSpacing + (7 + 18)
                end

                Lib:WinCheck( Win )
            end



            --[[
            ██████╗  ██████╗ ██████╗ ██████╗ ███████╗██████╗ 
            ██╔══██╗██╔═══██╗██╔══██╗██╔══██╗██╔════╝██╔══██╗
            ██████╔╝██║   ██║██████╔╝██║  ██║█████╗  ██████╔╝
            ██╔══██╗██║   ██║██╔══██╗██║  ██║██╔══╝  ██╔══██╗
            ██████╔╝╚██████╔╝██║  ██║██████╔╝███████╗██║  ██║
            ╚═════╝  ╚═════╝ ╚═╝  ╚═╝╚═════╝ ╚══════╝╚═╝  ╚═╝
            :AddBorder()
            ]]
            function Groupbox:AddBorder()

                --// Draw Border in Groupbox
                if Win.CurrentTab ~= nil and Win.CurrentTab == TabName and Win.Active and Groupbox.Visible then
            
                    --// Displaying Border
                    dx9.DrawFilledBox( { Groupbox.Root[1] + 5 , Groupbox.Root[2] + Groupbox.ToolSpacing + 20} , { Groupbox.Root[1] + Groupbox.Size[1] - 7, Groupbox.Root[2] + 2 + Groupbox.ToolSpacing + 20} , Win.AccentColor )

                    --// Expanding Groupbox
                    Groupbox.Size[2] = Groupbox.Size[2] + 8
                    Groupbox.ToolSpacing = Groupbox.ToolSpacing + 8
                end

                Lib:WinCheck( Win )
            end

            --[[
            ██████╗ ██╗      █████╗ ███╗   ██╗██╗  ██╗
            ██╔══██╗██║     ██╔══██╗████╗  ██║██║ ██╔╝
            ██████╔╝██║     ███████║██╔██╗ ██║█████╔╝ 
            ██╔══██╗██║     ██╔══██║██║╚██╗██║██╔═██╗ 
            ██████╔╝███████╗██║  ██║██║ ╚████║██║  ██╗
            ╚═════╝ ╚══════╝╚═╝  ╚═╝╚═╝  ╚═══╝╚═╝  ╚═╝
            :AddBlank(size)                                  
            ]]

            function Groupbox:AddBlank(size)

                --// Draw Blank in Groupbox
                if Win.CurrentTab ~= nil and Win.CurrentTab == TabName and Win.Active and Groupbox.Visible then

                    --// Expanding Groupbox
                    Groupbox.Size[2] = Groupbox.Size[2] + size
                    Groupbox.ToolSpacing = Groupbox.ToolSpacing + size
                end

                Lib:WinCheck( Win )
            end


            --[[
            ██╗      █████╗ ██████╗ ███████╗██╗     
            ██║     ██╔══██╗██╔══██╗██╔════╝██║     
            ██║     ███████║██████╔╝█████╗  ██║     
            ██║     ██╔══██║██╔══██╗██╔══╝  ██║     
            ███████╗██║  ██║██████╔╝███████╗███████╗
            ╚══════╝╚═╝  ╚═╝╚═════╝ ╚══════╝╚══════╝
            :AddLabel(text)                                
            ]]

            function Groupbox:AddLabel(text, color)
                if color == nil then color = {255, 255, 255} end
                
                --// Draw Label in Groupbox
                if Win.CurrentTab ~= nil and Win.CurrentTab == TabName and Win.Active and Groupbox.Visible then

                    --// Trimming Text
                    local n = 0;
                    local trimmed_text = "";
                    
                    if string.gmatch(text, "([^\n]+)") ~= nil then
                        for i in (string.gmatch(text, "([^\n]+)")) do

                            local temp = i;
                            if dx9.CalcTextWidth(temp) >=  Groupbox.Size[1] - 20 then
                                repeat
                                    temp = temp:sub(1,-2)
                                until dx9.CalcTextWidth(temp) <= Groupbox.Size[1] - 20
                            end

                            trimmed_text = trimmed_text..temp.."\n"
                            n = n + 1
                        end
                    else
                        trimmed_text = text
                        n = 1
                    end

                    --// Drawing Label
                    dx9.DrawString( { Groupbox.Root[1] + 8 , Groupbox.Root[2] + 20 + Groupbox.ToolSpacing } , color , trimmed_text)

                    --// End Statements
                    Groupbox.Size[2] = Groupbox.Size[2] + (7 + (18 * n))
                    Groupbox.ToolSpacing = Groupbox.ToolSpacing + (7 + (18 * n))
                end

                Lib:WinCheck( Win )
            end


            --[[
            ██╗███╗   ██╗██████╗ ██╗   ██╗████████╗
            ██║████╗  ██║██╔══██╗██║   ██║╚══██╔══╝
            ██║██╔██╗ ██║██████╔╝██║   ██║   ██║   
            ██║██║╚██╗██║██╔═══╝ ██║   ██║   ██║   
            ██║██║ ╚████║██║     ╚██████╔╝   ██║   
            ╚═╝╚═╝  ╚═══╝╚═╝      ╚═════╝    ╚═╝   
            :AddInput( "index" , { Default = "Default" , Text = "Input" , Placeholder = "Placeholder Text" , MaxLength = nil } )                               
            ]]

            function Groupbox:AddInput( index , params )
                local Input = {}
                
                if Groupbox.Tools[index] == nil then
                    Input = { 
                        Text = params.Text;
                        Placeholder = params.Placeholder or nil;
                        Boundary = { 0 ,0 ,0 ,0 };
                        Holding = false;
                        Value = params.Default or "";
                        Rounding = ( params.Rounding or 0 );
                        Suffix = ( params.Suffix or "" );
                    }
                    Groupbox.Tools[index] = Input
                end
                Input = Groupbox.Tools[index]
                Input.Text = params.Text;
                Input.Rounding = ( params.Rounding or 0 );
                Input.Suffix = ( params.Suffix or "" );

                
                Lib:WinCheck( Win )
                return Input;
            end

            --[[
            ██████╗ ██████╗  ██████╗ ██████╗ ██████╗  ██████╗ ██╗    ██╗███╗   ██╗
            ██╔══██╗██╔══██╗██╔═══██╗██╔══██╗██╔══██╗██╔═══██╗██║    ██║████╗  ██║
            ██║  ██║██████╔╝██║   ██║██████╔╝██║  ██║██║   ██║██║ █╗ ██║██╔██╗ ██║
            ██║  ██║██╔══██╗██║   ██║██╔═══╝ ██║  ██║██║   ██║██║███╗██║██║╚██╗██║
            ██████╔╝██║  ██║╚██████╔╝██║     ██████╔╝╚██████╔╝╚███╔███╔╝██║ ╚████║
            ╚═════╝ ╚═╝  ╚═╝ ╚═════╝ ╚═╝     ╚═════╝  ╚═════╝  ╚══╝╚══╝ ╚═╝  ╚═══╝
            :AddDropdown({Index = "", Text = "Dropdown", Default = 1, Values = {"Option 1", "Option 2"}})
                Dropdown:SetValues()
                Dropdown:Show() -
                Dropdown:Hide() -
                Dropdown:OnChanged(Func) -
                Dropdown:SetValue(val) -- CHECK IF THIS TAKES NUMBER OR STRING
            ]]

            function Groupbox:AddDropdown(params)

                --// Pre-Defs
                local Dropdown = {}
                local Name = params.Name or params.Text or params.Index
                local Index = params.Index or Name
                local Values = params.Values or params.Table or params.List

                --// Error Handling
                assert(type(Name) == "string" or type(Name) == "number", "[ERROR] AddDropdown: Text / Name parameter must be a string or number!")
                assert(type(Values) == "table" and #Values > 0, "[ERROR] AddDropdown: Values argument must be a table larger than 0!")
                
                if Groupbox.Tools[Index] == nil then
                    Dropdown = { 
                        Name = Name;
                        Boundary = { 0 , 0 , 0 , 0 };
                        Holding = false;

                        --// Value Stuff
                        Value = ""; -- CHANGE | Might need to be changed later
                        ValueIndex = params.Default or 1; -- CHANGE | Needs to actually set the value to the index thing
                        Values = Values;
                        HoveredValue = nil;

                        Hovering = false;
                        Changed = false;
                        AddonY = nil;
                    }
                    Groupbox.Tools[Index] = Dropdown
                end

                --// Re-Setting Values
                Dropdown = Groupbox.Tools[Index]

                --// Setting / clearing values
                if Dropdown.ValueIndex > #Dropdown.Values then Dropdown.ValueIndex = #Dropdown.Values end
                if Dropdown.Values[Dropdown.ValueIndex] ~= nil then Dropdown.Value = Dropdown.Values[Dropdown.ValueIndex] end

                --// Set Value
                function Dropdown:SetValue( value ) -- CHANGE
                    for i,v in ipairs(Dropdown.Values) do
                        if v == value then
                            Dropdown.ValueIndex = i
                            return
                        end
                    end

                    if Dropdown.Values[tonumber(value)] then Dropdown.ValueIndex = tonumber(value) end
                end

                --// Set Values
                function Dropdown:SetValues( table )
                    if type(table) == "table" and #table > 0 then
                        Dropdown.Values = table
                    end
                end

                --// Picker Show / Hide
                function Dropdown:Show()
                    Win.OpenTool = Dropdown
                end

                function Dropdown:Hide()
                    Win.OpenTool = nil 
                    Win.DeadZone = nil
                end

        
                --// Draw Dropdown in Groupbox
                if Win.CurrentTab ~= nil and Win.CurrentTab == TabName and Win.Active and Groupbox.Visible then


                    --// Trimming Text
                    local TrimmedText = Name;
                    if dx9.CalcTextWidth(TrimmedText) >=  Groupbox.Size[1] - 20 then 
                        repeat
                            TrimmedText = TrimmedText:sub(1,-2)
                        until dx9.CalcTextWidth(TrimmedText) <= Groupbox.Size[1] - 20
                    end                    

                    --// Calculating button X size
                    local dropdown_x = dx9.CalcTextWidth(TrimmedText) + 7

                    if Groupbox.Size[1] - 10 > dropdown_x then dropdown_x = Groupbox.Size[1] - 10 end

                    if Dropdown.Hovering or Win.OpenTool == Dropdown then
                        dx9.DrawFilledBox( { Groupbox.Root[1] + 4 , Groupbox.Root[2] + 19 + 15 + Groupbox.ToolSpacing } , { Groupbox.Root[1] + 4 + dropdown_x , Groupbox.Root[2] + 22 + 15 + (18) + Groupbox.ToolSpacing } , Win.AccentColor )
                    else
                        dx9.DrawFilledBox( { Groupbox.Root[1] + 4 , Groupbox.Root[2] + 19 + 15 + Groupbox.ToolSpacing } , { Groupbox.Root[1] + 4 + dropdown_x , Groupbox.Root[2] + 22 + 15 + (18) + Groupbox.ToolSpacing } , Lib.Black )
                    end

                    dx9.DrawFilledBox( { Groupbox.Root[1] + 5 , Groupbox.Root[2] + 20 + 15 + Groupbox.ToolSpacing } , { Groupbox.Root[1] + 3 + dropdown_x , Groupbox.Root[2] + 21 + 15 + (18) + Groupbox.ToolSpacing } , Win.OutlineColor )

                    if Dropdown.Holding == true then
                        dx9.DrawFilledBox( { Groupbox.Root[1] + 6 , Groupbox.Root[2] + 21 + 15 + Groupbox.ToolSpacing } , { Groupbox.Root[1] + 2 + dropdown_x , Groupbox.Root[2] + 20 + 15 + (18) + Groupbox.ToolSpacing } , Win.OutlineColor )
                    else
                        dx9.DrawFilledBox( { Groupbox.Root[1] + 6 , Groupbox.Root[2] + 21 + 15 + Groupbox.ToolSpacing } , { Groupbox.Root[1] + 2 + dropdown_x , Groupbox.Root[2] + 20 + 15 + (18) + Groupbox.ToolSpacing } , Win.MainColor )
                    end

                    --// Draw Selection
                    if Dropdown.Value ~= nil then

                        --// Trimming Value
                        local TrimmedValue = Dropdown.Value;
                        if dx9.CalcTextWidth(TrimmedValue) >=  Groupbox.Size[1] - 30 then 
                            repeat
                                TrimmedValue = TrimmedValue:sub(1,-2)
                            until dx9.CalcTextWidth(TrimmedValue) <= Groupbox.Size[1] - 30
                        end
                        dx9.DrawString( { Groupbox.Root[1] + 8 , Groupbox.Root[2] + 20 + 15 + Groupbox.ToolSpacing } , Win.FontColor , TrimmedValue )
                    end

                    --// Draw Name
                    dx9.DrawString( { Groupbox.Root[1] + 5 , Groupbox.Root[2] + 17 + Groupbox.ToolSpacing } , Win.FontColor , TrimmedText )

                    --// Draw Dropdown Indicator
                    local root = {Groupbox.Root[1] + Groupbox.Size[1] - 17, Groupbox.Root[2] + 44.5 + Groupbox.ToolSpacing}

                    if Win.OpenTool == Dropdown then
                        dx9.DrawCircle(root, Lib.Black, 6)
                        dx9.DrawCircle(root, Win.AccentColor, 5)
                        dx9.DrawCircle(root, Win.OutlineColor, 4)

                    elseif Dropdown.Hovering then
                        dx9.DrawCircle(root, Lib.Black, 4)
                        dx9.DrawCircle(root, Win.AccentColor, 3)
                        dx9.DrawCircle(root, Win.OutlineColor, 2)
                    else
                        dx9.DrawCircle(root, Lib.Black, 5)
                        dx9.DrawCircle(root, Win.OutlineColor, 4)
                    end

                    
                    --// Boundary and toolspacing
                    Dropdown.Boundary = { Groupbox.Root[1] + 4 , Groupbox.Root[2] + 19 + 15 + Groupbox.ToolSpacing , Groupbox.Root[1] + 4 + dropdown_x , Groupbox.Root[2] + 22 + 15 + ((18)) + Groupbox.ToolSpacing }

                    Dropdown.AddonY = Groupbox.ToolSpacing

                    --// Render Box CHANGE
                    function Dropdown:Render()
                        if Win.CurrentTab ~= nil and Win.CurrentTab == TabName and Win.Active and Groupbox.Visible then
                            Win.DeadZone = { Groupbox.Root[1] + 4 , Groupbox.Root[2] + Dropdown.AddonY - 13 + 66, Groupbox.Root[1] + 4 + dropdown_x , Groupbox.Root[2] - 11 + 67 + (21 * #Dropdown.Values) + Dropdown.AddonY }

                            
                            dx9.DrawFilledBox( { Groupbox.Root[1] + 4 , Groupbox.Root[2] + Dropdown.AddonY - 13 + 66} , { Groupbox.Root[1] + 4 + dropdown_x , Groupbox.Root[2] - 11 + 67 + (21 * #Dropdown.Values) + Dropdown.AddonY } , Win.AccentColor )
                            dx9.DrawFilledBox( { Groupbox.Root[1] + 5 , Groupbox.Root[2] + Dropdown.AddonY - 13 + 66} , { Groupbox.Root[1] + 3 + dropdown_x , Groupbox.Root[2] - 12 + 67 + (21 * #Dropdown.Values) + Dropdown.AddonY } , Win.OutlineColor )
                            dx9.DrawFilledBox( { Groupbox.Root[1] + 6 , Groupbox.Root[2] + Dropdown.AddonY - 12 + 66} , { Groupbox.Root[1] + 2 + dropdown_x , Groupbox.Root[2] - 13 + 67 + (21 * #Dropdown.Values) + Dropdown.AddonY } , Win.BackgroundColor )
                            
                            --// Displaying Options in Dropdown
                            for i,v in ipairs(Dropdown.Values) do

                                if Dropdown.HoveredValue == v then
                                    dx9.DrawBox( { Groupbox.Root[1] + 6 , Groupbox.Root[2] + Dropdown.AddonY - 11 + 45 + (21 * i) } , { Groupbox.Root[1] + 2 + dropdown_x , Groupbox.Root[2] - 12 + 66 + (21 * i) + Dropdown.AddonY } , Win.AccentColor )
                                else
                                    dx9.DrawBox( { Groupbox.Root[1] + 6 , Groupbox.Root[2] + Dropdown.AddonY - 11 + 45 + (21 * i) } , { Groupbox.Root[1] + 2 + dropdown_x , Groupbox.Root[2] - 12 + 66 + (21 * i) + Dropdown.AddonY } , Win.OutlineColor )
                                end
                                
                                --// Trimming Value
                                local TrimmedText = v;
                                if dx9.CalcTextWidth(TrimmedText) >=  Groupbox.Size[1] - 30 then 
                                    repeat
                                        TrimmedText = TrimmedText:sub(1,-2)
                                    until dx9.CalcTextWidth(TrimmedText) <= Groupbox.Size[1] - 30
                                end

                                if Dropdown.Value == v then
                                    dx9.DrawString( { Groupbox.Root[1] + 8 , Groupbox.Root[2] + Dropdown.AddonY - 32 + 66 + (21 * i) }, Win.AccentColor, TrimmedText )
                                else
                                    dx9.DrawString( { Groupbox.Root[1] + 8 , Groupbox.Root[2] + Dropdown.AddonY - 32 + 66 + (21 * i) }, Win.FontColor, TrimmedText )
                                end
                            end
                        
                        end
                    end

                    --// Expand Groupbox
                    Groupbox.ToolSpacing = Groupbox.ToolSpacing + 25 + 15
                    Groupbox.Size[2] = Groupbox.Size[2] + 25 + 15

                    --// Click Detect
                    if Lib.MouseInArea( { Dropdown.Boundary[1] , Dropdown.Boundary[2] , Dropdown.Boundary[3] , Dropdown.Boundary[4] }, Win.DeadZone ) and not Win.Dragging then
                        Dropdown.HoveredValue = nil;

                        --// Click Detection
                        if dx9.isLeftClickHeld() then
                            Dropdown.Holding = true;
                        else
                            if Dropdown.Holding == true then
                                if Win.OpenTool == Dropdown then Dropdown:Hide() else Dropdown:Show() end
                                Dropdown.Holding = false;
                            end
                        end

                        --// Hover Detection
                        Dropdown.Hovering = true;
                    elseif Win.OpenTool == Dropdown and Lib.MouseInArea(Win.DeadZone) then
                        local offset = Mouse.y - Win.DeadZone[2]
                        local index = math.floor(offset / 21) + 1

                        Dropdown.HoveredValue = Dropdown.Values[index]

                        if dx9.isLeftClickHeld() and Dropdown.ValueIndex ~= index then
                            Dropdown.ValueIndex = index
                            Dropdown.Changed = true
                        end
                    else
                        Dropdown.HoveredValue = nil;
                        Dropdown.Hovering = false;
                        Dropdown.Holding = false;
                    end

                    function Dropdown:AddTooltip(str)
                        local n = 0; -- Line Count
                        local Tooltip = "";

                        if string.gmatch(str, "([^\n]+)") ~= nil then
                            for i in (string.gmatch(str, "([^\n]+)")) do
                                Tooltip = Tooltip..i.."\n"
                                n = n + 1
                            end
                        else
                            Tooltip = str
                            n = 1
                        end

                        if Dropdown.Hovering then
                            dx9.DrawFilledBox({Mouse.x - 1, Mouse.y + 1}, {Mouse.x + dx9.CalcTextWidth(Tooltip) + 5, Mouse.y - (18 * n) - 1}, Win.AccentColor)
                            dx9.DrawFilledBox({Mouse.x, Mouse.y}, {Mouse.x + dx9.CalcTextWidth(Tooltip) + 4, Mouse.y - (18 * n)}, Win.OutlineColor)

                            dx9.DrawString({Mouse.x + 2, Mouse.y - (18 * n)}, Win.FontColor, str)
                        end

                        return Dropdown
                    end
                end

                --// Dropdown Onchanged
                function Dropdown:OnChanged( func )
                    if Dropdown.Changed then
                        Dropdown.Changed = false
                        func(Dropdown.Values[Dropdown.ValueIndex])
                    end
                    return Dropdown;
                end

                --// Closing Difines and Resets | Dropdown
                Groupbox.Tools[Index] = Dropdown;

                Lib:WinCheck( Win )
                return Dropdown;
            end


            --[[
            ███████╗██╗     ██╗██████╗ ███████╗██████╗ 
            ██╔════╝██║     ██║██╔══██╗██╔════╝██╔══██╗
            ███████╗██║     ██║██║  ██║█████╗  ██████╔╝
            ╚════██║██║     ██║██║  ██║██╔══╝  ██╔══██╗
            ███████║███████╗██║██████╔╝███████╗██║  ██║
            ╚══════╝╚══════╝╚═╝╚═════╝ ╚══════╝╚═╝  ╚═╝
            :AddSlider( index , {Text = "Text", Min = 0, Max = 100, Default = 50, Rounding = 0, Suffix = ""} )
            ]]

            function Groupbox:AddSlider( params )
                
                --// Pre-Defs
                local Slider = {}
                local Name = params.Name or params.Text or params.Index
                local Index = params.Index or Name

                --// Error Handling
                assert(type(Name) == "string" or type(Name) == "number", "[ERROR] AddSlider: Text / Name parameter must be a string or number!")

                --// Init Def
                if Groupbox.Tools[Index] == nil then
                    Slider = { 
                        Name = Name;
                        Boundary = { 0 , 0 , 0 , 0 };
                        Holding = false;
                        Value = params.Default or params.Min or 0;
                        Rounding = ( params.Rounding or 0 );
                        Suffix = ( params.Suffix or "" );
                        Hovering = false;
                        Changed = false;
                    }
                    Groupbox.Tools[Index] = Slider
                end

                --// Re-Setting Values
                Slider = Groupbox.Tools[Index]
                Slider.Rounding = ( params.Rounding or 0 );
                Slider.Suffix = ( params.Suffix or "" );
    
                --// Setvalue Func
                function Slider:SetValue( num )
                    if Slider.Value ~= num then
                        Slider.Value = num;
                        Slider.Changed = true;
                    end
                end

                --// Draw Slider in Groupbox
                if Win.CurrentTab ~= nil and Win.CurrentTab == TabName and Win.Active and Groupbox.Visible then

                    --// Bar Defs
                    local temp = Slider.Value..Slider.Suffix.."/"..params.Max..Slider.Suffix
                    local bar_length = Groupbox.Size[1] - 14

                    local val = ( 1 / ( ( params.Max - params.Min ) / (Slider.Value - params.Min) )  )
                    if val >= .98 then val = 1 end
                    if val <= .02 then val = 0 end

                    --// Expanding Groupbox
                    Groupbox.Size[2] = Groupbox.Size[2] + 40

                    --// Drawing Slider
                    if Slider.Hovering then
                        dx9.DrawFilledBox( { Groupbox.Root[1] + 4 , Groupbox.Root[2] + 34 + Groupbox.ToolSpacing } , { Groupbox.Root[1] + Groupbox.Size[1] - 6, Groupbox.Root[2] + 55 + Groupbox.ToolSpacing } , Win.AccentColor )
                    else
                        dx9.DrawFilledBox( { Groupbox.Root[1] + 4 , Groupbox.Root[2] + 34 + Groupbox.ToolSpacing } , { Groupbox.Root[1] + Groupbox.Size[1] - 6, Groupbox.Root[2] + 55 + Groupbox.ToolSpacing } , Lib.Black )
                    end

                    dx9.DrawFilledBox( { Groupbox.Root[1] + 5 , Groupbox.Root[2] + 35 + Groupbox.ToolSpacing } , { Groupbox.Root[1] + Groupbox.Size[1] - 7 , Groupbox.Root[2] + 54 + Groupbox.ToolSpacing } , Win.OutlineColor )

                    if Slider.Holding then
                        dx9.DrawFilledBox( { Groupbox.Root[1] + 6 , Groupbox.Root[2] + 36 + Groupbox.ToolSpacing } , { Groupbox.Root[1] + Groupbox.Size[1] - 8 , Groupbox.Root[2] + 53 + Groupbox.ToolSpacing } , Win.OutlineColor )
                    else
                        dx9.DrawFilledBox( { Groupbox.Root[1] + 6 , Groupbox.Root[2] + 36 + Groupbox.ToolSpacing } , { Groupbox.Root[1] + Groupbox.Size[1] - 8 , Groupbox.Root[2] + 53 + Groupbox.ToolSpacing } , Win.MainColor )
                    end

                    dx9.DrawFilledBox( { Groupbox.Root[1] + 6 , Groupbox.Root[2] + 36 + Groupbox.ToolSpacing } , { Groupbox.Root[1] + 6 + ( bar_length * val ) , Groupbox.Root[2] + 53 + Groupbox.ToolSpacing } , Win.AccentColor )

                    --// Writing Text
                    dx9.DrawString( { Groupbox.Root[1] + 4 , Groupbox.Root[2] + 18 + Groupbox.ToolSpacing } , Win.FontColor , Slider.Name )
                    dx9.DrawString( { Groupbox.Root[1] + 8 , Groupbox.Root[2] + 36 + Groupbox.ToolSpacing } , Win.FontColor , temp )


                    --// Setting Boundary
                    Slider.Boundary = { Groupbox.Root[1] + 6 , Groupbox.Root[2] + 36 + Groupbox.ToolSpacing , Groupbox.Root[1] + Groupbox.Size[1] - 8 , Groupbox.Root[2] + 53 + Groupbox.ToolSpacing }

                    --// end Statements
                    Groupbox.ToolSpacing = Groupbox.ToolSpacing + 40


                    --// If Mouse in Area
                    if Lib.MouseInArea( { Slider.Boundary[1] , Slider.Boundary[2] , Slider.Boundary[3] , Slider.Boundary[4] }, Win.DeadZone ) and not Win.Dragging then

                        --// Click Detection
                        if dx9.isLeftClickHeld() then
                            Slider.Holding = true;

                            local bar_length = Groupbox.Size[1] - 14

                            local cursor = ( ( dx9.GetMouse().x ) - ( Groupbox.Root[1] + 6 ) )

                            local val = 1 / ( bar_length/cursor )
                            if val >= .98 then val = 1 end
                            if val <= .02 then val = 0 end

                            --// Change Check
                            local value = math.floor(((val * ( params.Max - params.Min )) + params.Min) * (10^(params.Rounding or 0)) + 0.5) / (10^(params.Rounding or 0))

                            if value ~= Slider.Value then 
                                Slider.Value = value
                                Slider.Changed = true 
                            end
                        else
                            if Slider.Holding == true then
                                Slider.Holding = false;
                            end
                        end

                        Slider.Hovering = true;
                    else
                        Slider.Hovering = false;
                        Slider.Holding = false;
                    end

                    function Slider:AddTooltip(str)
                        local n = 0; -- Line Count
                        local Tooltip = "";

                        if string.gmatch(str, "([^\n]+)") ~= nil then
                            for i in (string.gmatch(str, "([^\n]+)")) do
                                Tooltip = Tooltip..i.."\n"
                                n = n + 1
                            end
                        else
                            Tooltip = str
                            n = 1
                        end

                        if Slider.Hovering then
                            dx9.DrawFilledBox({Mouse.x - 1, Mouse.y + 1}, {Mouse.x + dx9.CalcTextWidth(Tooltip) + 5, Mouse.y - (18 * n) - 1}, Win.AccentColor)
                            dx9.DrawFilledBox({Mouse.x, Mouse.y}, {Mouse.x + dx9.CalcTextWidth(Tooltip) + 4, Mouse.y - (18 * n)}, Win.OutlineColor)

                            dx9.DrawString({Mouse.x + 2, Mouse.y - (18 * n)}, Win.FontColor, str)
                        end

                        return Slider
                    end
                end

                --// Slider OnChanged
                function Slider:OnChanged( func )
                    if Slider.Changed then
                        Slider.Changed = false
                        func(Slider.Value)
                    end
                    return Slider;
                end

                --// Closing Difines and Resets | Slider
                Groupbox.Tools[Index] = Slider;

                Lib:WinCheck( Win )
                return Slider;
            end


            --[[
            ████████╗ ██████╗  ██████╗  ██████╗ ██╗     ███████╗
            ╚══██╔══╝██╔═══██╗██╔════╝ ██╔════╝ ██║     ██╔════╝
               ██║   ██║   ██║██║  ███╗██║  ███╗██║     █████╗  
               ██║   ██║   ██║██║   ██║██║   ██║██║     ██╔══╝  
               ██║   ╚██████╔╝╚██████╔╝╚██████╔╝███████╗███████╗
               ╚═╝    ╚═════╝  ╚═════╝  ╚═════╝ ╚══════╝╚══════╝
            :AddToggle( index , { Default = true , Text = "Toggle" } )                                  
            ]]

            function Groupbox:AddToggle( params ) 
                
                --// Pre-Defs
                local Toggle = {}
                local Name = params.Text or params.Name or params.Index
                local Index = params.Index or Name
                
                --// Error Handling
                assert(type(Name) == "string" or type(Name) == "number", "[ERROR] AddToggle: Text / Name Argument must be a string or number!")

                --// Init Defs
                if Groupbox.Tools[Index] == nil then
                    Groupbox.Tools[Index] = { 
                        Boundary = { 0 , 0 , 0 , 0 };
                        Value = params.Default or false;
                        Holding = false;
                        Hovering = false;
                        Changed = false;
                        Name = Name;
                    }
                end

                --// Re-Setting Toggle
                Toggle = Groupbox.Tools[Index]

                --// Set Value
                function Toggle:SetValue( value )
                    Toggle.Value = value;
                    Toggle.Changed = true;
                end


                --// Draw Toggle in Groupbox
                if Win.CurrentTab ~= nil and Win.CurrentTab == TabName and Win.Active and Groupbox.Visible then

                    --// Expanding Groupbox
                    Groupbox.Size[2] = Groupbox.Size[2] + 25

                    --// Drawing Toggle
                    if Toggle.Hovering then
                        dx9.DrawFilledBox( { Groupbox.Root[1] + 6 , Groupbox.Root[2] + 21 + Groupbox.ToolSpacing } , { Groupbox.Root[1] + 23 , Groupbox.Root[2] + 38 + Groupbox.ToolSpacing } , Win.AccentColor )
                    else
                        dx9.DrawFilledBox( { Groupbox.Root[1] + 6 , Groupbox.Root[2] + 21 + Groupbox.ToolSpacing } , { Groupbox.Root[1] + 23 , Groupbox.Root[2] + 38 + Groupbox.ToolSpacing } , Lib.Black )
                    end

                    dx9.DrawFilledBox( { Groupbox.Root[1] + 7 , Groupbox.Root[2] + 22 + Groupbox.ToolSpacing } , { Groupbox.Root[1] + 22 , Groupbox.Root[2] + 37 + Groupbox.ToolSpacing } , Win.OutlineColor )

                    if Toggle.Value then
                        dx9.DrawFilledBox( { Groupbox.Root[1] + 8 , Groupbox.Root[2] + 23 + Groupbox.ToolSpacing } , { Groupbox.Root[1] + 21 , Groupbox.Root[2] + 36 + Groupbox.ToolSpacing } , Win.AccentColor )
                    else
                        dx9.DrawFilledBox( { Groupbox.Root[1] + 8 , Groupbox.Root[2] + 23 + Groupbox.ToolSpacing } , { Groupbox.Root[1] + 21 , Groupbox.Root[2] + 36 + Groupbox.ToolSpacing } , Win.MainColor )
                    end

                    --// Trimming Text
                    local TrimmedToggleText = Toggle.Name;
                    if dx9.CalcTextWidth(TrimmedToggleText) >= Groupbox.Size[1] - 30 then
                        repeat
                            TrimmedToggleText = TrimmedToggleText:sub(1,-2)
                        until dx9.CalcTextWidth(TrimmedToggleText) <= Groupbox.Size[1] - 30
                    end

                    --// Drawing Text
                    dx9.DrawString( { Groupbox.Root[1] + 23 , Groupbox.Root[2] + 19 + Groupbox.ToolSpacing } , Win.FontColor , " "..TrimmedToggleText)

                    --// Setting Boundary
                    Toggle.Boundary = { Groupbox.Root[1] + 4 , Groupbox.Root[2] + 19 + Groupbox.ToolSpacing , Groupbox.Root[1] + Groupbox.Size[1] - 5, Groupbox.Root[2] + 40 + Groupbox.ToolSpacing }

                    --// Tool Spacing
                    Groupbox.ToolSpacing = Groupbox.ToolSpacing + 25

                    
                    --// Click Detect Toggle
                    if Lib.MouseInArea( { Toggle.Boundary[1] , Toggle.Boundary[2] , Toggle.Boundary[3] , Toggle.Boundary[4] }, Win.DeadZone ) and not Win.Dragging then
                        
                        --// Click Detection
                        if dx9.isLeftClickHeld() then
                            Toggle.Holding = true;
                        else
                            if Toggle.Holding == true then
                                Toggle:SetValue( not Toggle.Value )
                                Toggle.Holding = false;
                            end
                        end

                        --// Hover Detection
                        Toggle.Hovering = true;
                    else
                        Toggle.Hovering = false;
                        Toggle.Holding = false;
                    end

                    function Toggle:AddTooltip(str)
                        local n = 0; -- Line Count
                        local Tooltip = "";

                        if string.gmatch(str, "([^\n]+)") ~= nil then
                            for i in (string.gmatch(str, "([^\n]+)")) do
                                Tooltip = Tooltip..i.."\n"
                                n = n + 1
                            end
                        else
                            Tooltip = str
                            n = 1
                        end

                        if Toggle.Hovering then
                            dx9.DrawFilledBox({Mouse.x - 1, Mouse.y + 1}, {Mouse.x + dx9.CalcTextWidth(Tooltip) + 5, Mouse.y - (18 * n) - 1}, Win.AccentColor)
                            dx9.DrawFilledBox({Mouse.x, Mouse.y}, {Mouse.x + dx9.CalcTextWidth(Tooltip) + 4, Mouse.y - (18 * n)}, Win.OutlineColor)

                            dx9.DrawString({Mouse.x + 2, Mouse.y - (18 * n)}, Win.FontColor, str)
                        end

                        return Toggle
                    end
                end

                --// Toggle Onchanged
                function Toggle:OnChanged( func )
                    if Toggle.Changed then
                        Toggle.Changed = false
                        func(Toggle.Value)
                    end
                    return Toggle;
                end

                --// Closing Difines and Resets | Toggle
                Groupbox.Tools[Index] = Toggle;

                Lib:WinCheck( Win )
                return Toggle;
            end



            --// Closing Difines and Resets | Groupbox
            Groupbox.Size[2] = 30;
            Groupbox.ToolSpacing = 0;

            Tab.Groupboxes[GroupboxName] = Groupbox;
 
            Lib:WinCheck( Win )
            return Groupbox;
        end





        --// Add Left Groupbox Function
        function Tab:AddLeftGroupbox( name )
            return Tab:AddGroupbox( name , "left" )
        end

        --// Add Right Groupbox Function
        function Tab:AddRightGroupbox( name )
            return Tab:AddGroupbox( name , "right" )
        end

        --// Add Middle Groupbox Function
        function Tab:AddMiddleGroupbox( name )
            return Tab:AddGroupbox( name , "middle" )
        end

        --// Focus Tab
        function Tab:Focus()
            Win.CurrentTab = TabName;
        end

        --// Closing and Resets | Tab
        Tab.Leftstack = 60;
        Tab.Rightstack = 60;

        Win.Tabs[TabName] = Tab;
        
        Lib:WinCheck( Win )

        return Tab;
    end


    --// Closing Difines and Resets | Window
    Win.TabMargin = 0
    Win.Restraint = {FooterWidth + 12, 200}
    Lib.Windows[WindowName] = Win

    FooterWidth = 0
    
    return Win
end


--[[
███╗   ██╗ ██████╗ ████████╗██╗███████╗██╗   ██╗
████╗  ██║██╔═══██╗╚══██╔══╝██║██╔════╝╚██╗ ██╔╝
██╔██╗ ██║██║   ██║   ██║   ██║█████╗   ╚████╔╝ 
██║╚██╗██║██║   ██║   ██║   ██║██╔══╝    ╚██╔╝  
██║ ╚████║╚██████╔╝   ██║   ██║██║        ██║   
╚═╝  ╚═══╝ ╚═════╝    ╚═╝   ╚═╝╚═╝        ╚═╝   
]]

local total_seconds = os.clock() --(os.date("*t").hour * 3600) + (os.date("*t").min * 60) + (os.date("*t").sec)

function Lib:Notify(text, length, color)

    if length == nil then length = 3 end
    if color == nil then color = Lib.FontColor end

    local notif = {Text = text, Start = total_seconds, Length = length, Color = color}

    table.insert(Lib.Notifications, notif)
end

for i,v in pairs(Lib.Notifications) do
    if v.Start < total_seconds - v.Length then
        Lib.Notifications[i] = nil

        --// Pushing Items Down
        for d,f in pairs(Lib.Notifications) do
           if f ~= nil and d-1 ~= 0 then
            Lib.Notifications[d-1] = f
           end
        end

        --// Resseting Last Item
        if #Lib.Notifications ~= 0 then
            Lib.Notifications[#Lib.Notifications] = nil
        end
    elseif v ~= nil then

        --// Notification Root
        local root = {0, 200 + (22 * i)}

        --// Text Length
        local length = dx9.CalcTextWidth(v.Text)

        --// Draw Notification
        dx9.DrawFilledBox( { root[1] + 4 , root[2] + 19 } , { root[1] + 4 + length + 12, root[2] + 22 + (18) } , Lib.Black )
        dx9.DrawFilledBox( { root[1] + 5 , root[2] + 20 } , { root[1] + 3 + length + 12, root[2] + 21 + (18) } , Lib.OutlineColor )
        dx9.DrawFilledBox( { root[1] + 6 , root[2] + 21 } , { root[1] + 2 + length + 12, root[2] + 20 + (18) } , Lib.MainColor )
        dx9.DrawFilledBox( { root[1] + 6 , root[2] + 21 } , { root[1] + 8 , root[2] + 20 + ((total_seconds - v.Start) * (18/v.Length)) } , Lib.CurrentRainbowColor )

        dx9.DrawString( { root[1] + 11 , root[2] + 20 } , v.Color , v.Text )
    end
end


--// Rainbow Tick
do
    if Lib.RainbowHue > 1530 then
        Lib.RainbowHue = 0  
    else
        Lib.RainbowHue = Lib.RainbowHue + 3
    end

    if Lib.RainbowHue <= 255 then
        Lib.CurrentRainbowColor = {255, Lib.RainbowHue, 0}
    elseif Lib.RainbowHue <= 510 then
        Lib.CurrentRainbowColor = {510 - Lib.RainbowHue, 255, 0}
    elseif Lib.RainbowHue <= 765 then
        Lib.CurrentRainbowColor = {0, 255, Lib.RainbowHue - 510}
    elseif Lib.RainbowHue <= 1020 then
        Lib.CurrentRainbowColor = {0, 1020 - Lib.RainbowHue, 255}
    elseif Lib.RainbowHue <= 1275 then
        Lib.CurrentRainbowColor = {Lib.RainbowHue - 1020, 0, 255}
    elseif Lib.RainbowHue <= 1530 then
        Lib.CurrentRainbowColor = {255, 0, 1530 - Lib.RainbowHue}
    end
end


--// Logo Tick
if Lib.LogoTick > 80 then
    Lib.LogoTick = 0
else
    Lib.LogoTick = Lib.LogoTick + 1
end


--// End Statements
_G.Lib = Lib
return Lib
