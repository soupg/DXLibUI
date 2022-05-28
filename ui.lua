--// supgLib DX9Ware UI //--

--[[
ADD SUPPORT FOR ROUNDING ( for now it only supports 0 )

ADD INPUT PROTECTION ( for keybinds and more )

Gav was here

ADD COLOR PICKER FUNCTION THAT GETS INDEX OF 1 - 205 FOR BOTH BAR 1 AND 2 BRUH
]]


--[[
 ██████╗ ██╗      ██████╗ ██████╗  █████╗ ██╗         ███████╗██╗   ██╗███╗   ██╗ ██████╗████████╗██╗ ██████╗ ███╗   ██╗███████╗
██╔════╝ ██║     ██╔═══██╗██╔══██╗██╔══██╗██║         ██╔════╝██║   ██║████╗  ██║██╔════╝╚══██╔══╝██║██╔═══██╗████╗  ██║██╔════╝
██║  ███╗██║     ██║   ██║██████╔╝███████║██║         █████╗  ██║   ██║██╔██╗ ██║██║        ██║   ██║██║   ██║██╔██╗ ██║███████╗
██║   ██║██║     ██║   ██║██╔══██╗██╔══██║██║         ██╔══╝  ██║   ██║██║╚██╗██║██║        ██║   ██║██║   ██║██║╚██╗██║╚════██║
╚██████╔╝███████╗╚██████╔╝██████╔╝██║  ██║███████╗    ██║     ╚██████╔╝██║ ╚████║╚██████╗   ██║   ██║╚██████╔╝██║ ╚████║███████║
 ╚═════╝ ╚══════╝ ╚═════╝ ╚═════╝ ╚═╝  ╚═╝╚══════╝    ╚═╝      ╚═════╝ ╚═╝  ╚═══╝ ╚═════╝   ╚═╝   ╚═╝ ╚═════╝ ╚═╝  ╚═══╝╚══════╝
]]


--// Log Function
local log = "_LOG_\n"
function Log( ... )
    local temp = ""
    for i ,v in pairs( { ... } ) do
        if type( v ) == "table" then
            temp = temp..unpack( v ).." "
        else
        temp = temp..tostring( v ).." "
        end
    end
    log = log..temp.."\n"
    dx9.DrawString( { 1700 ,800 } , { 255 ,255 ,255 } , log );
end
Log( "X:" , dx9.GetMouse().x , "Y:" , dx9.GetMouse().y )


--// Boundary Check (with deadzone capability!!)
function mouse_in_boundary( v1 , v2 , v3)
    if v3 ~= nil then
        if dx9.GetMouse().x > v1[1] and dx9.GetMouse().y > v1[2] and dx9.GetMouse().x < v2[1] and dx9.GetMouse().y < v2[2] then
            if dx9.GetMouse().x > v3[1] and dx9.GetMouse().y > v3[2] and dx9.GetMouse().x < v3[3] and dx9.GetMouse().y < v3[4] then
                return false
            else
                return true
            end
        else
            return false
        end
    else
        if dx9.GetMouse().x > v1[1] and dx9.GetMouse().y > v1[2] and dx9.GetMouse().x < v2[1] and dx9.GetMouse().y < v2[2] then
            return true
        else
            return false
        end
    end
end


--// RGB to Hex
function rgbToHex(rgb)
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

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Fixed the Get function lag :D
if _G.bettergetfunction == nil then
    local oldget = _G["dx9"]["Get"]
    local oldload = _G.loadstring
    _G["bettergetfunction"] = {}
    _G["bettergetfunction"]["loadcaching"] = {}
    _G["bettergetfunction"]["getaching"] = {}

    _G["loadstring"] = function(string)
        if bettergetfunction.loadcaching[string] == nil then
            oldload(string)()
        end
    end
    
    _G["dx9"]["Get"] = function(string)
        if bettergetfunction.getaching[string] == nil then
            bettergetfunction.getaching[string] = dxl.oldget(string)
        end
        return bettergetfunction.getaching[string]
    end
end

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------



--[[
██╗   ██╗ █████╗ ██████╗ ██╗ █████╗ ██████╗ ██╗     ███████╗███████╗
██║   ██║██╔══██╗██╔══██╗██║██╔══██╗██╔══██╗██║     ██╔════╝██╔════╝
██║   ██║███████║██████╔╝██║███████║██████╔╝██║     █████╗  ███████╗
╚██╗ ██╔╝██╔══██║██╔══██╗██║██╔══██║██╔══██╗██║     ██╔══╝  ╚════██║
 ╚████╔╝ ██║  ██║██║  ██║██║██║  ██║██████╔╝███████╗███████╗███████║
  ╚═══╝  ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝╚═╝  ╚═╝╚═════╝ ╚══════╝╚══════╝╚══════╝
]]

--// Making vars used to scale ui to screensize
local WinScaleX = dx9.size().width / 1920
local WinScaleY = dx9.size().height / 1017


--// Global Dynamic Values
if _G.Lib == nil then
    _G.Lib = { 
        FontColor = { 255 , 255 , 255 }; -- Static + [Changeable]
        MainColor = { 28 , 28 , 28 }; -- Static + [Changeable]
        BackgroundColor = { 20 , 20 , 20 }; -- Static + [Changeable]
        AccentColor = { 0 , 85 , 255 }; -- Static + [Changeable]
        OutlineColor = { 50 , 50 , 50 }; -- Static + [Changeable]
        Black = { 0 , 0 , 0 }; -- Static

        RainbowHue = 0; -- Dynamic
        CurrentRainbowColor = { 0 ,0 ,0 }; -- Dynamic

        FocusedWindow = nil; -- Dynamic

        Keybind = "[F5]";

        InitIndex = 0;

        WindowCount = 0; -- Dynamic

        Active = true;

        Watermark = { 
            Text = "";
            Visible = true;
            Location = { 150 , 10 };
         };

        Windows = {};
     };
end
local Lib = _G.Lib

--// Keybidn Open/Close
if ( dx9.GetKey() == Lib.Keybind ) then
    Lib.Active = not Lib.Active;
end

function Lib:SetKeybind( keybind )
    Lib.Keybind = keybind;
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
function WinCheck( Win )
    use_count = use_count + 1

    if use_count > Lib.InitIndex then Lib.InitIndex = use_count end

    if Lib.InitIndex == use_count then
        for i,v in pairs( Lib.Windows ) do
            if v.WindowNum > Win.WindowNum then
                v:Render()
            end
        end

        if Win.OpenTool then
            Win.OpenTool:Render()
        end
    end
end

--[[
██╗    ██╗██╗███╗   ██╗██████╗  ██████╗ ██╗    ██╗
██║    ██║██║████╗  ██║██╔══██╗██╔═══██╗██║    ██║
██║ █╗ ██║██║██╔██╗ ██║██║  ██║██║   ██║██║ █╗ ██║
██║███╗██║██║██║╚██╗██║██║  ██║██║   ██║██║███╗██║
╚███╔███╔╝██║██║ ╚████║██████╔╝╚██████╔╝╚███╔███╔╝
 ╚══╝╚══╝ ╚═╝╚═╝  ╚═══╝╚═════╝  ╚═════╝  ╚══╝╚══╝ 
]]

--// Create Window Function
function Lib:CreateWindow( index )
    if Lib.Windows[index] == nil then
        Lib.Windows[index] = { 
            Location = { 1300 , 300 }; -- Dynamic

            Size = { 550 , 600 }; -- Static

            Rainbow = false; -- Dynamic + [Changeable]
    
            Name = index; -- Dynamic + [Changeable]

            ID = index; -- Static

            WinMouseOffset = nil; -- Dynamic

            WindowNum = Lib.WindowCount + 1; -- Static

            Tabs = {}; -- Dynamic

            CurrentTab = "none"; -- Dynamic

            TabMargin = 0; -- REALLY DYNAMIC OMG

            OpenTool = nil; -- Dynamic, this makes it so only one tool can be open (colorpicker and dropdown wise)

            DeadZone = nil; -- Zone in which clicks are not registered unless they're in a rendered form

            Tools = {};
         }
        Lib.WindowCount = Lib.WindowCount + 1
    end
    local Win = Lib.Windows[index]

    --// Left Click Held
    if dx9.isLeftClickHeld() and Lib.Active then

        --// Drag Func
        if mouse_in_boundary( { Win.Location[1] - 5 , Win.Location[2] - 10 } , { Win.Location[1] + Win.Size[1] + 5 , Win.Location[2] + 30 } ) then
            if Lib.FocusedWindow == nil or Lib.FocusedWindow == Win.ID then
                Lib.FocusedWindow = Win.ID
                if Win.WinMouseOffset == nil then
                    Win.WinMouseOffset = { dx9.GetMouse().x - Win.Location[1] , dx9.GetMouse().y - Win.Location[2] }
                end
                Win.Location = { dx9.GetMouse().x - Win.WinMouseOffset[1] , dx9.GetMouse().y - Win.WinMouseOffset[2] }
            else
                if Win.WindowNum > Lib.Windows[Lib.FocusedWindow].WindowNum then
                    Lib.FocusedWindow = Win.ID
                else
                    Win.WinMouseOffset = nil
                    Lib.FocusedWindow = nil
                end
            end
        end
        
        --// Tab Click Func
        for _ , t in next , Win.Tabs do
            if mouse_in_boundary( { t.Boundary[1] , t.Boundary[2] } , { t.Boundary[3] , t.Boundary[4] } ) then
                Win.CurrentTab = t.Name;
            end
        end
    else
        Win.WinMouseOffset = nil
        Lib.FocusedWindow = nil
    end


    --// Display Window //--
    local TrimmedWinName = Win.Name;
    if dx9.CalcTextWidth(TrimmedWinName) >=  540 then
        repeat
            TrimmedWinName = TrimmedWinName:sub(1,-2)
        until dx9.CalcTextWidth(TrimmedWinName) <= 540
    end

    function Win:Render()
        if Lib.Active then
            dx9.DrawFilledBox( { Win.Location[1] - 1 , Win.Location[2] - 1 } , { Win.Location[1] + Win.Size[1] + 1 , Win.Location[2] + Win.Size[2] + 1 } , Lib.Black ) --// Outline
            if Win.Rainbow == true then
                dx9.DrawFilledBox( Win.Location , { Win.Location[1] + Win.Size[1] , Win.Location[2] + Win.Size[2] } , Lib.CurrentRainbowColor ) --// Accent ( Rainbow )
            else
                dx9.DrawFilledBox( Win.Location , { Win.Location[1] + Win.Size[1] , Win.Location[2] + Win.Size[2] } , Lib.AccentColor ) --// Accent
            end
            dx9.DrawFilledBox( { Win.Location[1] + 1 , Win.Location[2] + 1 } , { Win.Location[1] + Win.Size[1] - 1 , Win.Location[2] + Win.Size[2] - 1 } , Lib.MainColor ) --// Main Outer ( light gray )
            dx9.DrawFilledBox( { Win.Location[1] + 5 , Win.Location[2] + 20 } , { Win.Location[1] + Win.Size[1] - 5 , Win.Location[2] + Win.Size[2] - 5 } , Lib.BackgroundColor ) --// Main Inner ( dark gray )

            dx9.DrawBox( { Win.Location[1] + 5 , Win.Location[2] + 20 } , { Win.Location[1] + Win.Size[1] - 5 , Win.Location[2] + Win.Size[2] - 5 } , Lib.OutlineColor ) --// Main Inner Outline 
            dx9.DrawBox( { Win.Location[1] + 6 , Win.Location[2] + 21 } , { Win.Location[1] + Win.Size[1] - 6 , Win.Location[2] + Win.Size[2] - 6 } , Lib.Black ) --// Main Inner Outline Black

            dx9.DrawString( Win.Location , Lib.FontColor , "  "..TrimmedWinName)
            dx9.DrawFilledBox( { Win.Location[1] + 10 , Win.Location[2] + 49 } , { Win.Location[1] + Win.Size[1] - 10 , Win.Location[2] + Win.Size[2] - 10 } , Lib.OutlineColor ) --// Main Tab Box Outline
            dx9.DrawFilledBox( { Win.Location[1] + 11 , Win.Location[2] + 50 } , { Win.Location[1] + Win.Size[1] - 11 , Win.Location[2] + Win.Size[2] - 11 } , Lib.MainColor ) --// Main Tab Box
        end
    end
    Win:Render()

    --// Change Name Function
    function Win:SetWindowTitle( title )
        Win.Name = title
    end

    --// Set Window to RGB Function
    function Win:SetRGB( bool )
        Win.Rainbow = bool
    end
    

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
        local Tab = {}
        if Win.Tabs[TabName] == nil then
            Tab = { 
                Name = TabName;
                Boundary = { 0 ,0 ,0 ,0 };
                Groupboxes = {};

                rightstack = 60;
                leftstack = 60;
             };
            Win.Tabs[TabName] = Tab;
        else

        end
        Tab = Win.Tabs[TabName];
        
        Win.Tabs[TabName].Name = TabName;
        

        local TabLength = dx9.CalcTextWidth( TabName ) + 7

        -- Focus first tab
        if Win.CurrentTab == "none" then Win.CurrentTab = Tab.Name end
        
        --// Display Tab
        if Lib.Active and Win.Tabs[TabName].Name == TabName then
            if Win.TabMargin + TabLength + 3 < 530 then
                if Win.CurrentTab ~= nil and Win.CurrentTab == Tab.Name then
                    dx9.DrawFilledBox( { Win.Location[1] + 10 + Win.TabMargin , Win.Location[2] + 26 } , { Win.Location[1] + 14 + TabLength + Win.TabMargin , Win.Location[2] + 50 } , Lib.OutlineColor )
                    dx9.DrawFilledBox( { Win.Location[1] + 11 + Win.TabMargin , Win.Location[2] + 27 } , { Win.Location[1] + 13 + TabLength + Win.TabMargin , Win.Location[2] + 50 } , Lib.MainColor )
                    dx9.DrawFilledBox( { Win.Location[1] + 12 + Win.TabMargin , Win.Location[2] + 28 } , { Win.Location[1] + 12 + TabLength + Win.TabMargin , Win.Location[2] + 50 } , Lib.MainColor )
                else
                    dx9.DrawFilledBox( { Win.Location[1] + 10 + Win.TabMargin , Win.Location[2] + 26 } , { Win.Location[1] + 14 + TabLength + Win.TabMargin , Win.Location[2] + 50 } , Lib.OutlineColor )
                    dx9.DrawFilledBox( { Win.Location[1] + 11 + Win.TabMargin , Win.Location[2] + 27 } , { Win.Location[1] + 13 + TabLength + Win.TabMargin , Win.Location[2] + 49 } , Lib.MainColor )
                    dx9.DrawFilledBox( { Win.Location[1] + 12 + Win.TabMargin , Win.Location[2] + 28 } , { Win.Location[1] + 12 + TabLength + Win.TabMargin , Win.Location[2] + 48 } , Lib.BackgroundColor )
                end
                
                dx9.DrawString( { Win.Location[1] + 12 + Win.TabMargin , Win.Location[2] + 28 } , Lib.FontColor , " "..Tab.Name )
                
                Tab.Boundary = { Win.Location[1] + 10 + Win.TabMargin , Win.Location[2] + 26 , Win.Location[1] + 14 + TabLength + Win.TabMargin , Win.Location[2] + 50 }
                Win.TabMargin = Win.TabMargin + TabLength + 3
            end
        end

        --[[
         ██████╗ ██████╗  ██████╗ ██╗   ██╗██████╗ ██████╗  ██████╗ ██╗  ██╗
        ██╔════╝ ██╔══██╗██╔═══██╗██║   ██║██╔══██╗██╔══██╗██╔═══██╗╚██╗██╔╝
        ██║  ███╗██████╔╝██║   ██║██║   ██║██████╔╝██████╔╝██║   ██║ ╚███╔╝ 
        ██║   ██║██╔══██╗██║   ██║██║   ██║██╔═══╝ ██╔══██╗██║   ██║ ██╔██╗ 
        ╚██████╔╝██║  ██║╚██████╔╝╚██████╔╝██║     ██████╔╝╚██████╔╝██╔╝ ██╗
        ╚═════╝ ╚═╝  ╚═╝ ╚═════╝  ╚═════╝ ╚═╝     ╚═════╝  ╚═════╝ ╚═╝  ╚═╝                                                             
        ]]

        function Tab:AddGroupbox(name , side)
            local Groupbox = {}
            if  Tab.Groupboxes[name] == nil then
                Groupbox = { 
                    Name = name; -- Static + [Changeable]
                    Side = side; -- Static + [Changeable]
                    Vertical = 30; -- Dynamic
                    ToolSpacing = 0;

                    Visible = true;

                    Tools = {};
                    Root = {};
                 };
                Tab.Groupboxes[name] = Groupbox
            end
            Tab.Groupboxes[name].Name = name
            Groupbox = Tab.Groupboxes[name]
            Groupbox.Side = side

            --// Display Groupbox
            if Win.CurrentTab ~= nil and Win.CurrentTab == Tab.Name and Lib.Active and Tab.rightstack + Groupbox.Vertical + 10 < 600 then
                Groupbox.Visible = true
                if Groupbox.Side == "Left" then 
                    dx9.DrawFilledBox( { Win.Location[1] + 20 , Win.Location[2] + Tab.leftstack } , { Win.Location[1] + 270 , Win.Location[2] + Tab.leftstack + Groupbox.Vertical } , Lib.OutlineColor )
                    if Win.Rainbow == true then 
                        dx9.DrawFilledBox( { Win.Location[1] + 21 , Win.Location[2] + Tab.leftstack + 1 } , { Win.Location[1] + 269 , Win.Location[2] + Tab.leftstack + 3 } , Lib.CurrentRainbowColor )
                    else
                        dx9.DrawFilledBox( { Win.Location[1] + 21 , Win.Location[2] + Tab.leftstack + 1 } , { Win.Location[1] + 269 , Win.Location[2] + Tab.leftstack + 3 } , Lib.AccentColor )
                    end
                    dx9.DrawFilledBox( { Win.Location[1] + 21 , Win.Location[2] + Tab.leftstack + 4 } , { Win.Location[1] + 269 , Win.Location[2] + Tab.leftstack + Groupbox.Vertical - 1 } , Lib.BackgroundColor )


                    dx9.DrawString( { Win.Location[1] + 145 - (dx9.CalcTextWidth(Groupbox.Name) / 2) , Win.Location[2] + Tab.leftstack + 4 } , Lib.FontColor , Groupbox.Name )

                    Groupbox.Root = { Win.Location[1] + 21 , Win.Location[2] + Tab.leftstack + 10 }
                    Tab.leftstack = Tab.leftstack + Groupbox.Vertical + 10
                else
                    dx9.DrawFilledBox( { Win.Location[1] + 280 , Win.Location[2] + Tab.rightstack } , { Win.Location[1] + 530 , Win.Location[2] + Tab.rightstack + Groupbox.Vertical } , Lib.OutlineColor )
                    if Win.Rainbow == true then 
                        dx9.DrawFilledBox( { Win.Location[1] + 281 , Win.Location[2] + Tab.rightstack + 1 } , { Win.Location[1] + 529 , Win.Location[2] + Tab.rightstack + 3 } , Lib.CurrentRainbowColor )
                    else
                        dx9.DrawFilledBox( { Win.Location[1] + 281 , Win.Location[2] + Tab.rightstack + 1 } , { Win.Location[1] + 529 , Win.Location[2] + Tab.rightstack + 3 } , Lib.AccentColor )
                    end
                    dx9.DrawFilledBox( { Win.Location[1] + 281 , Win.Location[2] + Tab.rightstack + 4 } , { Win.Location[1] + 529 , Win.Location[2] + Tab.rightstack + Groupbox.Vertical - 1 } , Lib.BackgroundColor )


                    dx9.DrawString( { Win.Location[1] + 405 - (dx9.CalcTextWidth(Groupbox.Name) / 2) , Win.Location[2] + Tab.rightstack + 4 } , Lib.FontColor , Groupbox.Name )

                    Groupbox.Root = { Win.Location[1] + 281 , Win.Location[2] + Tab.rightstack + 10 }
                    Tab.rightstack = Tab.rightstack + Groupbox.Vertical + 10
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

            function Groupbox:AddButton( btn_name , func )
                local idx = "btn_"..btn_name
                local Button = {}
                
                if Groupbox.Tools[idx] == nil then
                    Button = { 
                        Name = btn_name;
                        Function = func;
                        Boundary = { 0 ,0 ,0 ,0 };
                        Holding = false;
                        Hovering = false;
                     }
                    Groupbox.Tools[idx] = Button
                end
                Groupbox.Tools[idx].Name = btn_name
                Groupbox.Tools[idx].Function = func

                Button = Groupbox.Tools[idx]

                --// Draw Button in Groupbox
                if Win.CurrentTab ~= nil and Win.CurrentTab == Tab.Name and Lib.Active and Groupbox.Visible then

                    local n = 0;
                    local NewButtonName = "";
                    if string.gmatch(Button.Name, "([^\n]+)") ~= nil then
                        for i in (string.gmatch(Button.Name, "([^\n]+)")) do

                            local temp = i;
                            if dx9.CalcTextWidth(temp) >=  230 then
                                repeat
                                    temp = temp:sub(1,-2)
                                until dx9.CalcTextWidth(temp) <= 230
                            end

                            NewButtonName = NewButtonName..temp.."\n"
                            n = n + 1
                        end
                    else
                        NewButtonName = Button.Name
                        n = 1
                    end
                    
                    Groupbox.Vertical = Groupbox.Vertical + (7 + (18 * n))

                    if Button.Hovering then
                        if Win.Rainbow == true then 
                            dx9.DrawFilledBox( { Groupbox.Root[1] + 4 , Groupbox.Root[2] + 19 + Groupbox.ToolSpacing } , { Groupbox.Root[1] + 243 , Groupbox.Root[2] + 22 + ((18 + Groupbox.ToolSpacing) * n) } , Lib.CurrentRainbowColor )
                        else
                            dx9.DrawFilledBox( { Groupbox.Root[1] + 4 , Groupbox.Root[2] + 19 + Groupbox.ToolSpacing } , { Groupbox.Root[1] + 243 , Groupbox.Root[2] + 22 + ((18 + Groupbox.ToolSpacing) * n) } , Lib.AccentColor )
                        end
                    else
                        dx9.DrawFilledBox( { Groupbox.Root[1] + 4 , Groupbox.Root[2] + 19 + Groupbox.ToolSpacing } , { Groupbox.Root[1] + 243 , Groupbox.Root[2] + 22 + ((18 + Groupbox.ToolSpacing) * n) } , Lib.Black )
                    end

                    dx9.DrawFilledBox( { Groupbox.Root[1] + 5 , Groupbox.Root[2] + 20 + Groupbox.ToolSpacing } , { Groupbox.Root[1] + 242 , Groupbox.Root[2] + 21 + ((18 + Groupbox.ToolSpacing) * n) } , Lib.OutlineColor )

                    if Button.Holding == true then
                        dx9.DrawFilledBox( { Groupbox.Root[1] + 6 , Groupbox.Root[2] + 21 + Groupbox.ToolSpacing } , { Groupbox.Root[1] + 241 , Groupbox.Root[2] + 20 + ((18 + Groupbox.ToolSpacing) * n) } , Lib.OutlineColor )
                    else
                        dx9.DrawFilledBox( { Groupbox.Root[1] + 6 , Groupbox.Root[2] + 21 + Groupbox.ToolSpacing } , { Groupbox.Root[1] + 241 , Groupbox.Root[2] + 20 + ((18 + Groupbox.ToolSpacing) * n) } , Lib.MainColor )
                    end

                    dx9.DrawString( { Groupbox.Root[1] + 8 , Groupbox.Root[2] + 20 + Groupbox.ToolSpacing } , Lib.FontColor , NewButtonName )

                    Button.Boundary = { Groupbox.Root[1] + 4 , Groupbox.Root[2] + 19 + Groupbox.ToolSpacing , Groupbox.Root[1] + 243 , Groupbox.Root[2] + 22 + ((18 + Groupbox.ToolSpacing) * n) }

                    Groupbox.ToolSpacing = Groupbox.ToolSpacing + (7 + (18 * n))

                    --// Click Detect
                    if mouse_in_boundary( { Button.Boundary[1] , Button.Boundary[2] } , { Button.Boundary[3] , Button.Boundary[4] }, Win.DeadZone ) then
                        --// Click Detection
                        if dx9.isLeftClickHeld() then
                            Button.Holding = true;
                        else
                            if Button.Holding == true then
                                Button.Function();
                                Button.Holding = false;
                            end
                        end

                        --// Hover Detection
                        Button.Hovering = true;
                    else
                        Button.Hovering = false;
                        Button.Holding = false;
                    end
                end

                --// Closing Difines and Resets | Button
                Groupbox.Tools[idx] = Button;

                WinCheck( Win )
                return Button;
            end


            --[[
             ██████╗ ██████╗ ██╗      ██████╗ ██████╗     ██████╗ ██╗ ██████╗██╗  ██╗███████╗██████╗ 
            ██╔════╝██╔═══██╗██║     ██╔═══██╗██╔══██╗    ██╔══██╗██║██╔════╝██║ ██╔╝██╔════╝██╔══██╗
            ██║     ██║   ██║██║     ██║   ██║██████╔╝    ██████╔╝██║██║     █████╔╝ █████╗  ██████╔╝
            ██║     ██║   ██║██║     ██║   ██║██╔══██╗    ██╔═══╝ ██║██║     ██╔═██╗ ██╔══╝  ██╔══██╗
            ╚██████╗╚██████╔╝███████╗╚██████╔╝██║  ██║    ██║     ██║╚██████╗██║  ██╗███████╗██║  ██║
            ╚═════╝ ╚═════╝ ╚══════╝ ╚═════╝ ╚═╝  ╚═╝    ╚═╝     ╚═╝ ╚═════╝╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝

            :AddColorPicker(index, {Text = "Color Picker", Default = {0, 0, 0} } )                                                                      
            ]]

            function Groupbox:AddColorPicker( index , params ) 
                local Picker = {}
                
                if Groupbox.Tools[index] == nil then
                    Picker = { 
                        Boundary = { 0 , 0 , 0 , 0 };
                        Value = params.Default or {0,0,0};
                        Holding = false;
                        Changed = true;
                        Hovering = false;
                        AddonY = nil;

                        TopColor = params.Default or {0,0,0};
                        StoredIndex = 103;
                        StoredIndex2 = 1;
                     }
                    Groupbox.Tools[index] = Picker
                end
                Groupbox.Tools[index].Text = params.Text
                Picker = Groupbox.Tools[index]


                function Picker:SetValue( value )
                    Picker.Value = value;
                    Picker.Changed = true;
                end

                function Picker:Show()
                    Win.OpenTool = Picker
                end

                function Picker:Hide()
                    Win.OpenTool = nil 
                    Win.DeadZone = nil
                end

                --// Draw Color Picker in Groupbox
                if Win.CurrentTab ~= nil and Win.CurrentTab == Tab.Name and Lib.Active and Groupbox.Visible then

                    if Picker.Hovering then
                        if Win.Rainbow then 
                            dx9.DrawFilledBox( { Groupbox.Root[1] + 6 , Groupbox.Root[2] + 21 + Groupbox.ToolSpacing } , { Groupbox.Root[1] + 33 , Groupbox.Root[2] + 38 + Groupbox.ToolSpacing } , Lib.CurrentRainbowColor )
                        else
                            dx9.DrawFilledBox( { Groupbox.Root[1] + 6 , Groupbox.Root[2] + 21 + Groupbox.ToolSpacing } , { Groupbox.Root[1] + 33 , Groupbox.Root[2] + 38 + Groupbox.ToolSpacing } , Lib.AccentColor )
                        end
                    else
                        dx9.DrawFilledBox( { Groupbox.Root[1] + 6 , Groupbox.Root[2] + 21 + Groupbox.ToolSpacing } , { Groupbox.Root[1] + 33 , Groupbox.Root[2] + 38 + Groupbox.ToolSpacing } , Lib.Black )
                    end

                    dx9.DrawFilledBox( { Groupbox.Root[1] + 7 , Groupbox.Root[2] + 22 + Groupbox.ToolSpacing } , { Groupbox.Root[1] + 32 , Groupbox.Root[2] + 37 + Groupbox.ToolSpacing } , Lib.OutlineColor )

                    dx9.DrawFilledBox( { Groupbox.Root[1] + 8 , Groupbox.Root[2] + 23 + Groupbox.ToolSpacing } , { Groupbox.Root[1] + 31 , Groupbox.Root[2] + 36 + Groupbox.ToolSpacing } , Picker.Value )

                    local TrimmedToggleText = params.Text;
                    if dx9.CalcTextWidth(TrimmedToggleText) >=  205 then
                        repeat
                            TrimmedToggleText = TrimmedToggleText:sub(1,-2)
                        until dx9.CalcTextWidth(TrimmedToggleText) <= 205
                    end

                    dx9.DrawString( { Groupbox.Root[1] + 33 , Groupbox.Root[2] + 19 + Groupbox.ToolSpacing } , Lib.FontColor , " "..TrimmedToggleText)

                    Picker.Boundary = { Groupbox.Root[1] + 4 , Groupbox.Root[2] + 19 + Groupbox.ToolSpacing , Groupbox.Root[1] + 243 , Groupbox.Root[2] + 40 + Groupbox.ToolSpacing }

                    Picker.AddonY = Groupbox.ToolSpacing

                    function Picker:Render()
                        if Win.CurrentTab ~= nil and Win.CurrentTab == Tab.Name and Lib.Active and Groupbox.Visible then
                            Win.DeadZone = { Groupbox.Root[1] + 6 , Groupbox.Root[2] + 42 + Picker.AddonY, Groupbox.Root[1] + 223 , Groupbox.Root[2] + 125 + Picker.AddonY }
                            dx9.DrawFilledBox( { Groupbox.Root[1] + 6 , Groupbox.Root[2] + 42 + Picker.AddonY } , { Groupbox.Root[1] + 223 , Groupbox.Root[2] + 125 + Picker.AddonY } , Lib.Black )
                            dx9.DrawFilledBox( { Groupbox.Root[1] + 7 , Groupbox.Root[2] + 43 + Picker.AddonY } , { Groupbox.Root[1] + 222 , Groupbox.Root[2] + 124 + Picker.AddonY } , Lib.OutlineColor )
                            dx9.DrawFilledBox( { Groupbox.Root[1] + 8 , Groupbox.Root[2] + 44 + Picker.AddonY } , { Groupbox.Root[1] + 221 , Groupbox.Root[2] + 123 + Picker.AddonY } , Lib.BackgroundColor )

                            if Win.Rainbow then
                                dx9.DrawFilledBox( { Groupbox.Root[1] + 8 , Groupbox.Root[2] + 44 + Picker.AddonY } , { Groupbox.Root[1] + 221 , Groupbox.Root[2] + 46 + Picker.AddonY } , Lib.CurrentRainbowColor )
                            else
                                dx9.DrawFilledBox( { Groupbox.Root[1] + 8 , Groupbox.Root[2] + 44 + Picker.AddonY } , { Groupbox.Root[1] + 221 , Groupbox.Root[2] + 46 + Picker.AddonY } , Lib.AccentColor )
                            end

                            --// DRAWING THE COLORS BRUH
                            -- Bar 1
                            dx9.DrawFilledBox( { Groupbox.Root[1] + 10 , Groupbox.Root[2] + 49 + Picker.AddonY } , { Groupbox.Root[1] + 219 , Groupbox.Root[2] + 71 + Picker.AddonY } , Lib.Black )
                            dx9.DrawFilledBox( { Groupbox.Root[1] + 11 , Groupbox.Root[2] + 50 + Picker.AddonY } , { Groupbox.Root[1] + 218 , Groupbox.Root[2] + 70 + Picker.AddonY } , Lib.OutlineColor )
                            dx9.DrawFilledBox( { Groupbox.Root[1] + 12 , Groupbox.Root[2] + 51 + Picker.AddonY } , { Groupbox.Root[1] + 217 , Groupbox.Root[2] + 69 + Picker.AddonY } , Lib.AccentColor )
                            

                            -- Bar 2
                            dx9.DrawFilledBox( { Groupbox.Root[1] + 10 , Groupbox.Root[2] + 49 + 25 + Picker.AddonY } , { Groupbox.Root[1] + 219 , Groupbox.Root[2] + 71 + 25 + Picker.AddonY } , Lib.Black )
                            dx9.DrawFilledBox( { Groupbox.Root[1] + 11 , Groupbox.Root[2] + 50 + 25 + Picker.AddonY } , { Groupbox.Root[1] + 218 , Groupbox.Root[2] + 70 + 25 + Picker.AddonY } , Lib.OutlineColor )
                            dx9.DrawFilledBox( { Groupbox.Root[1] + 12 , Groupbox.Root[2] + 51 + 25 + Picker.AddonY } , { Groupbox.Root[1] + 217 , Groupbox.Root[2] + 69 + 25 + Picker.AddonY } , Lib.AccentColor )

                            -- Rest
                            dx9.DrawFilledBox( { Groupbox.Root[1] + 10 , Groupbox.Root[2] + 49 + 50 + Picker.AddonY } , { Groupbox.Root[1] + 113 , Groupbox.Root[2] + 71 + 50 + Picker.AddonY } , Lib.Black )
                            dx9.DrawFilledBox( { Groupbox.Root[1] + 11 , Groupbox.Root[2] + 50 + 50 + Picker.AddonY } , { Groupbox.Root[1] + 112 , Groupbox.Root[2] + 70 + 50 + Picker.AddonY } , Lib.OutlineColor )
                            dx9.DrawFilledBox( { Groupbox.Root[1] + 12 , Groupbox.Root[2] + 51 + 50 + Picker.AddonY } , { Groupbox.Root[1] + 111 , Groupbox.Root[2] + 69 + 50 + Picker.AddonY } , Lib.MainColor )

                            dx9.DrawString( { Groupbox.Root[1] + 12 , Groupbox.Root[2] + 51 + 50 + Picker.AddonY } , Lib.FontColor , " "..rgbToHex(Picker.Value))

                            dx9.DrawFilledBox( { Groupbox.Root[1] + 116 , Groupbox.Root[2] + 49 + 50 + Picker.AddonY } , { Groupbox.Root[1] + 219 , Groupbox.Root[2] + 71 + 50 + Picker.AddonY } , Lib.Black )
                            dx9.DrawFilledBox( { Groupbox.Root[1] + 117 , Groupbox.Root[2] + 50 + 50 + Picker.AddonY } , { Groupbox.Root[1] + 218 , Groupbox.Root[2] + 70 + 50 + Picker.AddonY } , Lib.OutlineColor )
                            dx9.DrawFilledBox( { Groupbox.Root[1] + 118 , Groupbox.Root[2] + 51 + 50 + Picker.AddonY } , { Groupbox.Root[1] + 217 , Groupbox.Root[2] + 69 + 50 + Picker.AddonY } , Lib.MainColor )

                            -- rgb
                            dx9.DrawString( { Groupbox.Root[1] + 118 , Groupbox.Root[2] + 51 + 50 + Picker.AddonY } , Lib.FontColor , " ".. math.floor(Picker.Value[1] + 0.5)..", ".. math.floor(Picker.Value[2] + 0.5)..", ".. math.floor(Picker.Value[3] + 0.5))

                            --// AIDS BELOW
                            local FirstBarHue = 0
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

                                if dx9.isLeftClickHeld() and mouse_in_boundary({ Groupbox.Root[1] + 12 + i , Groupbox.Root[2] + 51 + Picker.AddonY}, { Groupbox.Root[1] + 217 + i , Groupbox.Root[2] + 69 + Picker.AddonY }) then
                                    Picker.StoredIndex2 = i
                                end

                                if Picker.StoredIndex2 == i then Picker.TopColor = CurrentRainbowColor end

                                dx9.DrawBox( { Groupbox.Root[1] + 12 + i , Groupbox.Root[2] + 51 + Picker.AddonY } , { Groupbox.Root[1] + 12 + i , Groupbox.Root[2] + 69 + Picker.AddonY }, CurrentRainbowColor)
                            end

                            local SecondBarHue = 0
                            for i = 1, 205 do 
                                local Color = {0,0,0}

                                if SecondBarHue > 510 then
                                    SecondBarHue = 0        
                                end

                                if SecondBarHue < 255 then
                                    Color = { Picker.TopColor[1] * (SecondBarHue/255)  , Picker.TopColor[2] * (SecondBarHue/255) , Picker.TopColor[3] * (SecondBarHue/255) }
                                else
                                    Color = { Picker.TopColor[1] + (SecondBarHue - 255)  , Picker.TopColor[2] + (SecondBarHue - 255) , Picker.TopColor[3] + (SecondBarHue - 255) }
                                end

                                SecondBarHue = SecondBarHue + 2.5

                                if Color[1] > 255 then Color[1] = 255 end
                                if Color[2] > 255 then Color[2] = 255 end
                                if Color[3] > 255 then Color[3] = 255 end

                                if dx9.isLeftClickHeld() and mouse_in_boundary({ Groupbox.Root[1] + 12 + i, Groupbox.Root[2] + 51 + 25 + Picker.AddonY }, { Groupbox.Root[1] + 217 + i, Groupbox.Root[2] + 69 + 25 + Picker.AddonY }) then
                                    if i < 5 then 
                                        Picker.StoredIndex = 1 
                                    elseif i >= 100 and i <= 106 then
                                        Picker.StoredIndex = 103
                                    elseif i > 200 then 
                                        Picker.StoredIndex = 205
                                    else 
                                        Picker.StoredIndex = i 
                                    end
                                end

                                if Picker.StoredIndex == i then Picker:SetValue(Color) end

                                dx9.DrawBox( { Groupbox.Root[1] + 12 + i, Groupbox.Root[2] + 51 + 25 + Picker.AddonY } , { Groupbox.Root[1] + 12 + i, Groupbox.Root[2] + 69 + 25 + Picker.AddonY }, Color )
                            end

                            dx9.DrawBox( { Groupbox.Root[1] + 10 + Picker.StoredIndex2 , Groupbox.Root[2] + 49 + Picker.AddonY } , { Groupbox.Root[1] + 14 + Picker.StoredIndex2 , Groupbox.Root[2] + 71 + Picker.AddonY } , Lib.Black )
                            dx9.DrawFilledBox( { Groupbox.Root[1] + 11 + Picker.StoredIndex2 , Groupbox.Root[2] + 50 + Picker.AddonY } , { Groupbox.Root[1] + 13 + Picker.StoredIndex2 , Groupbox.Root[2] + 70 + Picker.AddonY } , Lib.OutlineColor )

                            dx9.DrawBox( { Groupbox.Root[1] + 10 + Picker.StoredIndex, Groupbox.Root[2] + 74 + Picker.AddonY } , { Groupbox.Root[1] + 14 + Picker.StoredIndex , Groupbox.Root[2] + 96 + Picker.AddonY } , Lib.Black )
                            dx9.DrawFilledBox( { Groupbox.Root[1] + 11 + Picker.StoredIndex, Groupbox.Root[2] + 75 + Picker.AddonY } , { Groupbox.Root[1] + 13 + Picker.StoredIndex , Groupbox.Root[2] + 95 + Picker.AddonY } , Lib.OutlineColor )
                        end
                    end

                    Groupbox.Vertical = Groupbox.Vertical + 25
                    Groupbox.ToolSpacing = Groupbox.ToolSpacing + 25

                    --// Click Detect
                    if mouse_in_boundary( { Picker.Boundary[1] , Picker.Boundary[2] } , { Picker.Boundary[3] , Picker.Boundary[4] }, Win.DeadZone ) then
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
                        func()
                    end
                end

                --// Closing Difines and Resets | Picker
                Groupbox.Tools[index] = Picker;
                Win.Tools[index] = Picker;

                WinCheck( Win )
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
                if Win.CurrentTab ~= nil and Win.CurrentTab == Tab.Name and Lib.Active and Groupbox.Visible then

                    Groupbox.Vertical = Groupbox.Vertical + (7 + 18)

                    dx9.DrawString( { Groupbox.Root[1] + 6 , Groupbox.Root[2] + 21 + Groupbox.ToolSpacing } , Lib.FontColor , text)

                    if Win.Rainbow == true then
                        dx9.DrawFilledBox( { Groupbox.Root[1] + 5 , Groupbox.Root[2] + 40 + Groupbox.ToolSpacing } , { Groupbox.Root[1] + 242 , Groupbox.Root[2] + 42 + Groupbox.ToolSpacing } , Lib.CurrentRainbowColor )
                    else
                        dx9.DrawFilledBox( { Groupbox.Root[1] + 5 , Groupbox.Root[2] + 40 + Groupbox.ToolSpacing } , { Groupbox.Root[1] + 242 , Groupbox.Root[2] + 42 + Groupbox.ToolSpacing } , Lib.AccentColor )
                    end

                    Groupbox.ToolSpacing = Groupbox.ToolSpacing + (7 + 18)
                end
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
                if Win.CurrentTab ~= nil and Win.CurrentTab == Tab.Name and Lib.Active and Groupbox.Visible then
                    Groupbox.Vertical = Groupbox.Vertical + size

                    Groupbox.ToolSpacing = Groupbox.ToolSpacing + size
                end
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

            function Groupbox:AddLabel(text)

                --// Draw Label in Groupbox
                if Win.CurrentTab ~= nil and Win.CurrentTab == Tab.Name and Lib.Active and Groupbox.Visible then

                    local n = 0;
                    if string.gmatch(text, "([^\n]+)") ~= nil then
                        for i in (string.gmatch(text, "([^\n]+)")) do
                            n = n + 1
                        end
                    else
                        n = 1
                    end

                    Groupbox.Vertical = Groupbox.Vertical + (7 + (18 * n))

                    dx9.DrawString( { Groupbox.Root[1] + 8 , Groupbox.Root[2] + 20 + Groupbox.ToolSpacing } , Lib.FontColor , text)

                    Groupbox.ToolSpacing = Groupbox.ToolSpacing + (7 + (18 * n))
                end
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
                        Changed = false;
                     }
                    Groupbox.Tools[index] = Input
                end
                Input = Groupbox.Tools[index]
                Input.Text = params.Text;
                Input.Rounding = ( params.Rounding or 0 );
                Input.Suffix = ( params.Suffix or "" );

                
                WinCheck( Win )
                return Input;
            end


            --[[
            ███████╗██╗     ██╗██████╗ ███████╗██████╗ 
            ██╔════╝██║     ██║██╔══██╗██╔════╝██╔══██╗
            ███████╗██║     ██║██║  ██║█████╗  ██████╔╝
            ╚════██║██║     ██║██║  ██║██╔══╝  ██╔══██╗
            ███████║███████╗██║██████╔╝███████╗██║  ██║
            ╚══════╝╚══════╝╚═╝╚═════╝ ╚══════╝╚═╝  ╚═╝
            :AddSlider( index , {Text = "Text", Min = 0, Max = 100, Default = 50} )
            ]]

            function Groupbox:AddSlider( index , params )
                local Slider = {}
                
                if Groupbox.Tools[index] == nil then
                    Slider = { 
                        Text = params.Text;
                        Boundary = { 0 ,0 ,0 ,0 };
                        Holding = false;
                        Value = params.Default or params.Min or 0;
                        Rounding = ( params.Rounding or 0 );
                        Suffix = ( params.Suffix or "" );
                        Changed = false;
                        Hovering = false;
                     }
                    Groupbox.Tools[index] = Slider
                end
                Slider = Groupbox.Tools[index]
                Slider.Text = params.Text;
                Slider.Rounding = ( params.Rounding or 0 );
                Slider.Suffix = ( params.Suffix or "" );
    
                function Slider:SetValue( num )
                    if Slider.Value ~= num then
                        Slider.Changed = true;
                        Slider.Value = num
                    end
                end


                --// Draw Slider in Groupbox
                if Win.CurrentTab ~= nil and Win.CurrentTab == Tab.Name and Lib.Active and Groupbox.Visible then
                    local temp = math.floor( Slider.Value )..Slider.Suffix.."/"..params.Max..Slider.Suffix
                    local bar_length = 235

                    local val = ( 1 / ( ( params.Max - params.Min ) / (Slider.Value - params.Min) )  )
                    if val >= .98 then val = 1 end
                    if val <= .02 then val = 0 end

                    Groupbox.Vertical = Groupbox.Vertical + 40

                    if Slider.Hovering then
                        if Win.Rainbow == true then 
                            dx9.DrawFilledBox( { Groupbox.Root[1] + 4 , Groupbox.Root[2] + 34 + Groupbox.ToolSpacing } , { Groupbox.Root[1] + 243 , Groupbox.Root[2] + 55 + Groupbox.ToolSpacing } , Lib.CurrentRainbowColor )
                        else
                            dx9.DrawFilledBox( { Groupbox.Root[1] + 4 , Groupbox.Root[2] + 34 + Groupbox.ToolSpacing } , { Groupbox.Root[1] + 243 , Groupbox.Root[2] + 55 + Groupbox.ToolSpacing } , Lib.AccentColor )
                        end
                    else
                        dx9.DrawFilledBox( { Groupbox.Root[1] + 4 , Groupbox.Root[2] + 34 + Groupbox.ToolSpacing } , { Groupbox.Root[1] + 243 , Groupbox.Root[2] + 55 + Groupbox.ToolSpacing } , Lib.Black )
                    end

                    dx9.DrawFilledBox( { Groupbox.Root[1] + 5 , Groupbox.Root[2] + 35 + Groupbox.ToolSpacing } , { Groupbox.Root[1] + 242 , Groupbox.Root[2] + 54 + Groupbox.ToolSpacing } , Lib.OutlineColor )

                    if Slider.Holding then
                        dx9.DrawFilledBox( { Groupbox.Root[1] + 6 , Groupbox.Root[2] + 36 + Groupbox.ToolSpacing } , { Groupbox.Root[1] + 241 , Groupbox.Root[2] + 53 + Groupbox.ToolSpacing } , Lib.OutlineColor )
                    else
                        dx9.DrawFilledBox( { Groupbox.Root[1] + 6 , Groupbox.Root[2] + 36 + Groupbox.ToolSpacing } , { Groupbox.Root[1] + 241 , Groupbox.Root[2] + 53 + Groupbox.ToolSpacing } , Lib.MainColor )
                    end

                    if Win.Rainbow == true then 
                        dx9.DrawFilledBox( { Groupbox.Root[1] + 6 , Groupbox.Root[2] + 36 + Groupbox.ToolSpacing } , { Groupbox.Root[1] + 6 + ( bar_length * val ) , Groupbox.Root[2] + 53 + Groupbox.ToolSpacing } , Lib.CurrentRainbowColor )
                    else
                        dx9.DrawFilledBox( { Groupbox.Root[1] + 6 , Groupbox.Root[2] + 36 + Groupbox.ToolSpacing } , { Groupbox.Root[1] + 6 + ( bar_length * val ) , Groupbox.Root[2] + 53 + Groupbox.ToolSpacing } , Lib.AccentColor )
                    end

                    dx9.DrawString( { Groupbox.Root[1] + 4 , Groupbox.Root[2] + 18 + Groupbox.ToolSpacing } , Lib.FontColor , params.Text )

                    dx9.DrawString( { Groupbox.Root[1] + 8 , Groupbox.Root[2] + 36 + Groupbox.ToolSpacing } , Lib.FontColor , temp )

                    Slider.Boundary = { Groupbox.Root[1] + 6 , Groupbox.Root[2] + 36 + Groupbox.ToolSpacing , Groupbox.Root[1] + 241 , Groupbox.Root[2] + 53 + Groupbox.ToolSpacing }

                    Groupbox.ToolSpacing = Groupbox.ToolSpacing + 40

                    --// Hovering
                    if mouse_in_boundary( { Slider.Boundary[1] , Slider.Boundary[2] } , { Slider.Boundary[3] , Slider.Boundary[4] }, Win.DeadZone ) then
                        --// Click Detection
                        if dx9.isLeftClickHeld() then
                            Slider.Holding = true;

                            local bar_length = 234

                            local cursor = ( ( dx9.GetMouse().x ) - ( Groupbox.Root[1] + 6 ) )

                            local val = 1 / ( bar_length/cursor )
                            if val >= .98 then val = 1 end
                            if val <= .02 then val = 0 end
                            Slider.Value = (val * ( params.Max - params.Min )) + params.Min
                            
                            Slider.Changed = true;
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
                end

                function Slider:OnChanged( func )
                    if Slider.Changed then
                        Slider.Changed = false
                        func()
                    end
                end

                --// Closing Difines and Resets | Slider
                Groupbox.Tools[index] = Slider;
                Win.Tools[index] = Slider;

                WinCheck( Win )
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

            function Groupbox:AddToggle( index , params ) 
                local Toggle = {}
                
                if Groupbox.Tools[index] == nil then
                    Toggle = { 
                        Text = params.Text or index;
                        Boundary = { 0 ,0 ,0 ,0 };
                        Value = params.Default or false;
                        Holding = false;
                        Changed = false;
                        Hovering = false;
                    }
                    Groupbox.Tools[index] = Toggle
                end
                Groupbox.Tools[index].Text = params.Text
                Toggle = Groupbox.Tools[index]


                function Toggle:SetValue( value )
                    Toggle.Value = value;
                    Toggle.Changed = true;
                end


                --// Draw Toggle in Groupbox
                if Win.CurrentTab ~= nil and Win.CurrentTab == Tab.Name and Lib.Active and Groupbox.Visible then
                    Groupbox.Vertical = Groupbox.Vertical + 25

                    if Toggle.Hovering then
                        if Win.Rainbow then 
                            dx9.DrawFilledBox( { Groupbox.Root[1] + 6 , Groupbox.Root[2] + 21 + Groupbox.ToolSpacing } , { Groupbox.Root[1] + 23 , Groupbox.Root[2] + 38 + Groupbox.ToolSpacing } , Lib.CurrentRainbowColor )
                        else
                            dx9.DrawFilledBox( { Groupbox.Root[1] + 6 , Groupbox.Root[2] + 21 + Groupbox.ToolSpacing } , { Groupbox.Root[1] + 23 , Groupbox.Root[2] + 38 + Groupbox.ToolSpacing } , Lib.AccentColor )
                        end
                    else
                        dx9.DrawFilledBox( { Groupbox.Root[1] + 6 , Groupbox.Root[2] + 21 + Groupbox.ToolSpacing } , { Groupbox.Root[1] + 23 , Groupbox.Root[2] + 38 + Groupbox.ToolSpacing } , Lib.Black )
                    end

                    dx9.DrawFilledBox( { Groupbox.Root[1] + 7 , Groupbox.Root[2] + 22 + Groupbox.ToolSpacing } , { Groupbox.Root[1] + 22 , Groupbox.Root[2] + 37 + Groupbox.ToolSpacing } , Lib.OutlineColor )

                    if Toggle.Value then
                        if Win.Rainbow then 
                            dx9.DrawFilledBox( { Groupbox.Root[1] + 8 , Groupbox.Root[2] + 23 + Groupbox.ToolSpacing } , { Groupbox.Root[1] + 21 , Groupbox.Root[2] + 36 + Groupbox.ToolSpacing } , Lib.CurrentRainbowColor )
                        else
                            dx9.DrawFilledBox( { Groupbox.Root[1] + 8 , Groupbox.Root[2] + 23 + Groupbox.ToolSpacing } , { Groupbox.Root[1] + 21 , Groupbox.Root[2] + 36 + Groupbox.ToolSpacing } , Lib.AccentColor )
                        end
                    else
                        dx9.DrawFilledBox( { Groupbox.Root[1] + 8 , Groupbox.Root[2] + 23 + Groupbox.ToolSpacing } , { Groupbox.Root[1] + 21 , Groupbox.Root[2] + 36 + Groupbox.ToolSpacing } , Lib.MainColor )
                    end

                    local TrimmedToggleText = Toggle.Text;
                    if dx9.CalcTextWidth(TrimmedToggleText) >= 215 then
                        repeat
                            TrimmedToggleText = TrimmedToggleText:sub(1,-2)
                        until dx9.CalcTextWidth(TrimmedToggleText) <= 215
                    end

                    dx9.DrawString( { Groupbox.Root[1] + 23 , Groupbox.Root[2] + 19 + Groupbox.ToolSpacing } , Lib.FontColor , " "..TrimmedToggleText)

                    Toggle.Boundary = { Groupbox.Root[1] + 4 , Groupbox.Root[2] + 19 + Groupbox.ToolSpacing , Groupbox.Root[1] + 243 , Groupbox.Root[2] + 40 + Groupbox.ToolSpacing }

                    Groupbox.ToolSpacing = Groupbox.ToolSpacing + 25

                    
                    --// Click Detect Toggle
                    if mouse_in_boundary( { Toggle.Boundary[1] , Toggle.Boundary[2] } , { Toggle.Boundary[3] , Toggle.Boundary[4] }, Win.DeadZone ) then
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
                end


                --// Toggle Onchanged
                function Toggle:OnChanged( func )
                    if Toggle.Changed then
                        Toggle.Changed = false
                        func()
                    end
                end

                --// Closing Difines and Resets | Toggle
                Groupbox.Tools[index] = Toggle;
                Win.Tools[index] = Toggle;

                WinCheck( Win )
                return Toggle;
            end


            --// Closing Difines and Resets | Groupbox
            Groupbox.Vertical = 30;
            Groupbox.ToolSpacing = 0;

            Tab.Groupboxes[name] = Groupbox;

            WinCheck( Win )
            return Groupbox;
        end
    


        --// Add Left Groupbox Function
        function Tab:AddLeftGroupbox( name )
            return Tab:AddGroupbox( name , "Left" )
        end

        --// Add Right Groupbox Function
        function Tab:AddRightGroupbox( name )
            return Tab:AddGroupbox( name , "Right" )
        end

        function Tab:Focus()
            Win.CurrentTab = Tab.Name;
        end

        --// Closing Difines and Resets | Tab
        Win.Tabs[TabName] = Tab;

        Tab.leftstack = 60;
        Tab.rightstack = 60;
        
        WinCheck( Win )

        return Tab;
    end

    --// Closing Difines and Resets | Window
    Lib.Windows[index] = Win

    Win.TabMargin = 0
    Win.Tools = {};

    return( Win )
end

--// Watermark
if Lib.Watermark.Visible then
    dx9.DrawFilledBox( { Lib.Watermark.Location[1] , Lib.Watermark.Location[2] } , { Lib.Watermark.Location[1] + 302 , Lib.Watermark.Location[2] + 22 } , Lib.Black )
    dx9.DrawFilledBox( { Lib.Watermark.Location[1]+1 , Lib.Watermark.Location[2]+1 } , { Lib.Watermark.Location[1] + 301 , Lib.Watermark.Location[2] + 21 } , Lib.CurrentRainbowColor )
    dx9.DrawFilledBox( { Lib.Watermark.Location[1]+2 , Lib.Watermark.Location[2]+2 } , { Lib.Watermark.Location[1] + 300 , Lib.Watermark.Location[2] + 20 } , Lib.MainColor )

    dx9.DrawString( { Lib.Watermark.Location[1]+2 , Lib.Watermark.Location[2]+2 } , Lib.FontColor , " "..Lib.Watermark.Text )
end

function Lib:SetWatermarkVisibility( bool )
    Lib.Watermark.Visible = bool
end

function Lib:SetWatermark( text , args )
    Lib.Watermark.Text = text;
    if args.Location ~= nil then Lib.Watermark.Location = args.Location end
end

--// Rainbow Tick
do
    if Lib.RainbowHue >= 765 then
        Lib.RainbowHue = 0
    else
        Lib.RainbowHue = Lib.RainbowHue + 1
    end

    if Lib.RainbowHue <= 255 then
        Lib.CurrentRainbowColor = { 255 - Lib.RainbowHue , Lib.RainbowHue , 0 }
    elseif Lib.RainbowHue <= 510 then
        Lib.CurrentRainbowColor = { 0 , 510 - Lib.RainbowHue , Lib.RainbowHue - 255 }
    else
        Lib.CurrentRainbowColor = { Lib.RainbowHue - 510 , 0 , 765 - Lib.RainbowHue }
    end
end
