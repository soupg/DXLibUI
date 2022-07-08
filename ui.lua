--// DXLib UI Library //--

--[[

It might be a good idea to add indexing to each tool later, in case names dont work too well

Try and fix rendering bug of tools / groupboxes on tab switch

Groupbox.Visible is pretty useless as all groupboxes are visible, this is due to the restraint changes

ADD WINDOW DEADZONES SO U CANT CLICK THROUGH WINDOWS INFRONT

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


--// KeyRead (dont move anywhere lower)
local KeyRead = dx9.GetKey()
local uses = 0

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

        Active = true;

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
        FirstRun = true;

        --// Notifications
        Notifications = {};
        LatestNotif = nil; -- CHANGE (pretty useless but might come in handy some time)
     };
end
local Lib = _G.Lib

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
        end

        if Win.OpenTool then
            Win.OpenTool:Render()
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

    --// Better Loadstring DONE
    function Lib.loadstring(string)
        assert(type(string) == "string", "[Error] loadstring: First Argument needs to be a string!")

        if Lib.LoadstringCaching[string] == nil then
            Lib.LoadstringCaching[string] = Lib.OldLoadstring(string)
        else
            return Lib.LoadstringCaching[string]
        end
    end
    _G.loadstring = Lib.loadstring


    --// Better Get DONE
    function Lib.Get(string)
        assert(type(string) == "string", "[Error] Get: First Argument needs to be a string!")

        if Lib.GetCaching[string] == nil then
            Lib.GetCaching[string] = Lib.OldGet(string)
        else
            return Lib.GetCaching[string]
        end
    end
    _G.dx9.Get = Lib.Get
end


--// Better Console CHANGE : can drag minimized console using original size
function Lib:ShowConsole(...)
    if Lib.MouseInArea({Lib.C_Location[1] + Lib.C_Size[1] - 27, Lib.C_Location[2] + 3, Lib.C_Location[1] + Lib.C_Size[1] - 5, Lib.C_Location[2] + 19}) then

        --// Click Detection
        if dx9.isLeftClickHeld() then
            Lib.C_Holding = true;
        else
            if Lib.C_Holding == true then
                Lib.C_Open = not Lib.C_Open
                Lib.C_Holding = false;
            end
        end

        Lib.C_Hovering = true
    else
        Lib.C_Hovering = false
    end

    --// Left Click Held
    if dx9.isLeftClickHeld() then

        --// Drag Func
        if Lib.C_Dragging or Lib.MouseInArea({Lib.C_Location[1] - 5, Lib.C_Location[2] - 10, Lib.C_Location[1] + Lib.C_Size[1] + 5, Lib.C_Location[2] + 30}) then
            if not Lib.C_Dragging then Lib.C_Dragging = true end 

            if Lib.C_WinMouseOffset == nil then
                Lib.C_WinMouseOffset = {dx9.GetMouse().x - Lib.C_Location[1], dx9.GetMouse().y - Lib.C_Location[2]}
            end
            Lib.C_Location = {dx9.GetMouse().x - Lib.C_WinMouseOffset[1], dx9.GetMouse().y - Lib.C_WinMouseOffset[2]}
        end
    else
        Lib.C_Dragging = false
        Lib.C_WinMouseOffset = nil
    end

    if Lib.C_Open then
        dx9.DrawFilledBox({Lib.C_Location[1] - 1, Lib.C_Location[2] - 1}, {Lib.C_Location[1] + Lib.C_Size[1] + 1, Lib.C_Location[2] + Lib.C_Size[2] + 1}, Lib.Black) --// Outline
        dx9.DrawFilledBox(Lib.C_Location, {Lib.C_Location[1] + Lib.C_Size[1], Lib.C_Location[2] + Lib.C_Size[2]}, Lib.AccentColor) --// Accent
        dx9.DrawFilledBox({Lib.C_Location[1] + 1, Lib.C_Location[2] + 1}, {Lib.C_Location[1] + Lib.C_Size[1] - 1, Lib.C_Location[2] + Lib.C_Size[2] - 1}, Lib.MainColor) --// Main Outer (light gray)
        dx9.DrawFilledBox({Lib.C_Location[1] + 5, Lib.C_Location[2] + 20}, {Lib.C_Location[1] + Lib.C_Size[1] - 5, Lib.C_Location[2] + Lib.C_Size[2] - 5}, Lib.BackgroundColor) --// Main Inner (dark gray)
        dx9.DrawBox({Lib.C_Location[1] + 5, Lib.C_Location[2] + 20}, {Lib.C_Location[1] + Lib.C_Size[1] - 5, Lib.C_Location[2] + Lib.C_Size[2] - 5}, Lib.OutlineColor) --// Main Inner Outline 
        dx9.DrawBox({Lib.C_Location[1] + 6, Lib.C_Location[2] + 21}, {Lib.C_Location[1] + Lib.C_Size[1] - 6, Lib.C_Location[2] + Lib.C_Size[2] - 6}, Lib.Black) --// Main Inner Outline Black
        dx9.DrawString(Lib.C_Location, Lib.FontColor, "  Console | Mouse: "..dx9.GetMouse().x..", "..dx9.GetMouse().y) 

        for i,v in pairs(Lib.C_StoredLogs) do
            if string.sub(v, 1, 9) == "ERROR_TAG" then
                dx9.DrawString({Lib.C_Location[1] + 10, Lib.C_Location[2] + 5 + i*18}, Lib.C_ErrorColor, string.sub(v, 10, -1))
            else
                dx9.DrawString({Lib.C_Location[1] + 10, Lib.C_Location[2] + 5 + i*18}, Lib.FontColor, v)
            end
        end
    else
        dx9.DrawFilledBox({Lib.C_Location[1] + 300, Lib.C_Location[2] - 1}, {Lib.C_Location[1] + Lib.C_Size[1] + 1, Lib.C_Location[2] + 23}, Lib.Black) --// Outline
        dx9.DrawFilledBox({Lib.C_Location[1] + 301, Lib.C_Location[2]}, {Lib.C_Location[1] + Lib.C_Size[1],  Lib.C_Location[2] + 22}, Lib.AccentColor) --// Accent
        dx9.DrawFilledBox({Lib.C_Location[1] + 302, Lib.C_Location[2] + 1}, {Lib.C_Location[1] + Lib.C_Size[1] - 1,  Lib.C_Location[2] + 21}, Lib.MainColor) --// Main Outer (light gray)

        dx9.DrawString({Lib.C_Location[1] + 300, Lib.C_Location[2]}, Lib.FontColor, "  Console")
    end


    --// Minimize button
    if Lib.Hovering then
        dx9.DrawFilledBox({Lib.C_Location[1] + Lib.C_Size[1] - 27, Lib.C_Location[2] + 3}, {Lib.C_Location[1] + Lib.C_Size[1] - 5, Lib.C_Location[2] + 19}, Lib.AccentColor) --// Outline
    else
        dx9.DrawFilledBox({Lib.C_Location[1] + Lib.C_Size[1] - 27, Lib.C_Location[2] + 3}, {Lib.C_Location[1] + Lib.C_Size[1] - 5, Lib.C_Location[2] + 19}, Lib.Black) --// Outline
    end

    dx9.DrawFilledBox({Lib.C_Location[1] + Lib.C_Size[1] - 26, Lib.C_Location[2] + 4}, {Lib.C_Location[1] + Lib.C_Size[1] - 6, Lib.C_Location[2] + 18}, Lib.OutlineColor) --// Inner Line
    dx9.DrawFilledBox({Lib.C_Location[1] + Lib.C_Size[1] - 25, Lib.C_Location[2] + 5}, {Lib.C_Location[1] + Lib.C_Size[1] - 7, Lib.C_Location[2] + 17}, Lib.MainColor) --// Inner

    dx9.DrawString({Lib.C_Location[1] + Lib.C_Size[1] - 20, Lib.C_Location[2] - 2}, Lib.FontColor, "_")

    function Lib.error(...)
        local temp = "";
        for i,v in pairs({...}) do
            temp = temp..tostring(v).." "
        end
        
        local split_string = {};
        if string.gmatch(temp, "([^\n]+)") ~= nil then
            for i in ( string.gmatch(temp, "([^\n]+)") ) do
                table.insert(split_string, i)
            end    
        end

        if split_string == {} then
            if #Lib.C_StoredLogs < 45 then
                table.insert(Lib.C_StoredLogs, "ERROR_TAG"..temp)
            else
                table.insert(Lib.C_StoredLogs, "ERROR_TAG"..temp)

                for i,v in pairs(Lib.C_StoredLogs) do
                    Lib.C_StoredLogs[i] = Lib.C_StoredLogs[i + 1]
                end
            end
        else
            for i,v in pairs(split_string) do
                if #Lib.C_StoredLogs < 45 then
                    table.insert(Lib.C_StoredLogs, "ERROR_TAG"..v)
                else
                    table.insert(Lib.C_StoredLogs, "ERROR_TAG"..v)
        
                    for i,v in pairs(Lib.C_StoredLogs) do
                        Lib.C_StoredLogs[i] = Lib.C_StoredLogs[i + 1]
                    end
                end
            end
        end
    end


    function print_table(node) -- https://stackoverflow.com/a/42062321/19113503
        local cache, stack, output = {},{},{}
        local depth = 1
        local output_str = "{\n"

        while true do
            local size = 0
            for k,v in pairs(node) do
                size = size + 1
            end

            local cur_index = 1
            for k,v in pairs(node) do
                if (cache[node] == nil) or (cur_index >= cache[node]) then

                    if (string.find(output_str,"}",output_str:len())) then
                        output_str = output_str .. ",\n"
                    elseif not (string.find(output_str,"\n",output_str:len())) then
                        output_str = output_str .. "\n"
                    end

                    -- This is necessary for working with HUGE tables otherwise we run out of memory using concat on huge strings
                    table.insert(output,output_str)
                    output_str = ""

                    local key
                    if (type(k) == "number" or type(k) == "boolean") then
                        key = "["..tostring(k).."]"
                    else
                        key = "['"..tostring(k).."']"
                    end

                    if (type(v) == "number" or type(v) == "boolean") then
                        output_str = output_str .. string.rep('\t',depth) .. key .. " = "..tostring(v)
                    elseif (type(v) == "table") then
                        output_str = output_str .. string.rep('\t',depth) .. key .. " = {\n"
                        table.insert(stack,node)
                        table.insert(stack,v)
                        cache[node] = cur_index+1
                        break
                    else
                        output_str = output_str .. string.rep('\t',depth) .. key .. " = '"..tostring(v).."'"
                    end

                    if (cur_index == size) then
                        output_str = output_str .. "\n" .. string.rep('\t',depth-1) .. "}"
                    else
                        output_str = output_str .. ","
                    end
                else
                    -- close the table
                    if (cur_index == size) then
                        output_str = output_str .. "\n" .. string.rep('\t',depth-1) .. "}"
                    end
                end

                cur_index = cur_index + 1
            end

            if (size == 0) then
                output_str = output_str .. "\n" .. string.rep('\t',depth-1) .. "}"
            end

            if (#stack > 0) then
                node = stack[#stack]
                stack[#stack] = nil
                depth = cache[node] == nil and depth + 1 or depth - 1
            else
                break
            end
        end

        -- This is necessary for working with HUGE tables otherwise we run out of memory using concat on huge strings
        table.insert(output,output_str)
        output_str = table.concat(output)

        return output_str
    end


    function Lib.print(...)
        local temp = "";
        for i,v in pairs({...}) do
            if type(v) == "table" then
                temp = temp..print_table(v).." "
            else
                temp = temp..tostring(v).." "
            end
        end
        
        local split_string = {};
        if string.gmatch(temp, "([^\n]+)") ~= nil then
            for i in ( string.gmatch(temp, "([^\n]+)") ) do
                table.insert(split_string, i)
            end    
        end

        if split_string == {} then
            if #Lib.C_StoredLogs < 45 then
                table.insert(Lib.C_StoredLogs, temp)
            else
                table.insert(Lib.C_StoredLogs, temp)

                for i,v in pairs(Lib.C_StoredLogs) do
                    Lib.C_StoredLogs[i] = Lib.C_StoredLogs[i + 1]
                end
            end
        else
            for i,v in pairs(split_string) do
                if #Lib.C_StoredLogs < 45 then
                    table.insert(Lib.C_StoredLogs, v)
                else
                    table.insert(Lib.C_StoredLogs, v)
        
                    for i,v in pairs(Lib.C_StoredLogs) do
                        Lib.C_StoredLogs[i] = Lib.C_StoredLogs[i + 1]
                    end
                end
            end
        end
    end

    Lib.C_StoredLogs = {};
    _G.Lib = Lib
end


if Lib.FirstRun then
    function double_print(...)
        Lib.OldPrint(...);
        Lib.print(...);
    end

    _G.print = double_print
    _G.error = Lib.error
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

    local FontColor = params.FontColor or Lib.FontColor
    local MainColor = params.MainColor or Lib.MainColor
    local BackgroundColor = params.BackgroundColor or Lib.BackgroundColor
    local AccentColor = params.AccentColor or Lib.AccentColor
    local OutlineColor = params.OutlineColor or Lib.OutlineColor

    local StartRainbow = params.Rainbow or params.RGB or false

    local ToggleKeyPreset = "[ESCAPE]"
    if params.ToggleKey ~= nil and type(params.ToggleKey) == "string" then
        ToggleKeyPreset = string.upper(params.ToggleKey)
    end

    local resizable = params.Resizable or false

    --// Error Handling
    assert(type(WindowName) == "string" or type(WindowName) == "number", "[ERROR] CreateWindow: Window name parameter must be a string or number!")
    assert(type(FontColor) == "table" and #FontColor == 3, "[ERROR] CreateWindow: Window Color parameters must be tables with 3 RGB values!")
    assert(type(MainColor) == "table" and #MainColor == 3, "[ERROR] CreateWindow: Window Color parameters must be tables with 3 RGB values!")
    assert(type(BackgroundColor) == "table" and #BackgroundColor == 3, "[ERROR] CreateWindow: Window Color parameters must be tables with 3 RGB values!")
    assert(type(AccentColor) == "table" and #AccentColor == 3, "[ERROR] CreateWindow: Window Color parameters must be tables with 3 RGB values!")
    assert(type(OutlineColor) == "table" and #OutlineColor == 3, "[ERROR] CreateWindow: Window Color parameters must be tables with 3 RGB values!")
    assert(type(StartRainbow) == "boolean", "[ERROR] CreateWindow: Rainbow parameter must be a boolean!")
    assert(type(ToggleKeyPreset) == "string" and string.sub(ToggleKeyPreset, 1, 1) == "[", "[ERROR] CreateWindow: ToggleKey needs to have this format: [KEY]!")


    if Lib.Windows[WindowName] == nil then
        Lib.Windows[WindowName] = {
            Location = params.StartLocation or { 1300 , 300 };
            Size = params.Size or { 600 , 500 };

            Rainbow = StartRainbow;
    
            Title = WindowName;

            WinMouseOffset = nil;

            WindowNum = Lib.WindowCount + 1; 

            ID = WindowName; 

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
            KeyMemory = {};

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
        AccentColor = Lib.CurrentRainbowColor 
    else 
        AccentColor = params.AccentColor or Lib.AccentColor
    end

    --// Keybind Open / Close
    if KeyRead == Win.ToggleKey and KeyRead ~= "[ESCAPE]" and not Win.ToggleReading then
        Win.Active = not Win.Active;
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

                dx9.DrawFilledBox( Win.Location , { Win.Location[1] + Win.Size[1] , Win.Location[2] + Win.Size[2] } , AccentColor )

                dx9.DrawFilledBox( { Win.Location[1] + 1 , Win.Location[2] + 1 } , { Win.Location[1] + Win.Size[1] - 1 , Win.Location[2] + Win.Size[2] - 1 } , MainColor )

                --// Draw Corner
                if resizable then
                    dx9.DrawFilledBox( { Win.Location[1] + Win.Size[1] - 7, Win.Location[2] + Win.Size[2] - 7} , { Win.Location[1] + Win.Size[1] , Win.Location[2] + Win.Size[2] } , AccentColor )

                    dx9.DrawFilledBox( { Win.Location[1] + Win.Size[1] - 6 , Win.Location[2] + Win.Size[2] - 6 } , { Win.Location[1] + Win.Size[1] - 1 , Win.Location[2] + Win.Size[2] - 1 } , MainColor )
                end

                --// Draw Main Inner

                dx9.DrawFilledBox( { Win.Location[1] + 5 , Win.Location[2] + 20 } , { Win.Location[1] + Win.Size[1] - 5 , Win.Location[2] + Win.Size[2] - 32 } , BackgroundColor ) 

                dx9.DrawBox( { Win.Location[1] + 5 , Win.Location[2] + 20 } , { Win.Location[1] + Win.Size[1] - 5 , Win.Location[2] + Win.Size[2] - 31 } , OutlineColor ) 
                dx9.DrawBox( { Win.Location[1] + 6 , Win.Location[2] + 21 } , { Win.Location[1] + Win.Size[1] - 6 , Win.Location[2] + Win.Size[2] - 32 } , Lib.Black ) 

                dx9.DrawString( Win.Location , FontColor , "  "..TrimmedWinName)
                dx9.DrawFilledBox( { Win.Location[1] + 10 , Win.Location[2] + 49 } , { Win.Location[1] + Win.Size[1] - 10 , Win.Location[2] + Win.Size[2] - 36 } , OutlineColor )
                dx9.DrawFilledBox( { Win.Location[1] + 11 , Win.Location[2] + 50 } , { Win.Location[1] + Win.Size[1] - 11 , Win.Location[2] + Win.Size[2] - 37 } , MainColor ) 
            end

            --// Footer //--
            if true then 

                --// Watermark //--
                local Watermark = "     DXLibUI"
                local Watermark_Width = dx9.CalcTextWidth(Watermark)

                dx9.DrawBox( { Win.Location[1] + 5 , Win.Location[2] + Win.Size[2] - 28 } , { Win.Location[1] + 15 + Watermark_Width , Win.Location[2] + Win.Size[2] - 4 } , OutlineColor ) 
                dx9.DrawBox( { Win.Location[1] + 6 , Win.Location[2] + Win.Size[2] - 27 } , { Win.Location[1] + 14 + Watermark_Width , Win.Location[2] + Win.Size[2] - 5 } , Lib.Black ) 
                dx9.DrawFilledBox( { Win.Location[1] + 7 , Win.Location[2] + Win.Size[2] - 26 } , { Win.Location[1] + 13 + Watermark_Width , Win.Location[2] + Win.Size[2] - 6 } , BackgroundColor ) 

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

                    dx9.DrawBox( { FooterWidth + Win.Location[1] + 5 , Win.Location[2] + Win.Size[2] - 28 } , { FooterWidth + Win.Location[1] + 15 + Toggle_Width , Win.Location[2] + Win.Size[2] - 4 } , OutlineColor ) 

                    if Win.ToggleKeyHovering then
                        dx9.DrawBox( { FooterWidth + Win.Location[1] + 6 , Win.Location[2] + Win.Size[2] - 27 } , { FooterWidth + Win.Location[1] + 14 + Toggle_Width , Win.Location[2] + Win.Size[2] - 5 } , AccentColor ) 
                    else
                        dx9.DrawBox( { FooterWidth + Win.Location[1] + 6 , Win.Location[2] + Win.Size[2] - 27 } , { FooterWidth + Win.Location[1] + 14 + Toggle_Width , Win.Location[2] + Win.Size[2] - 5 } , Lib.Black ) 
                    end

                    dx9.DrawFilledBox( { FooterWidth + Win.Location[1] + 7 , Win.Location[2] + Win.Size[2] - 26 } , { FooterWidth + Win.Location[1] + 13 + Toggle_Width , Win.Location[2] + Win.Size[2] - 6 } , BackgroundColor ) 

                    if Win.ToggleReading then
                        dx9.DrawString( { FooterWidth + Win.Location[1] + 10 , Win.Location[2] + Win.Size[2] - 25 } , Lib.CurrentRainbowColor , Toggle)
                    else
                        dx9.DrawString( { FooterWidth + Win.Location[1] + 10 , Win.Location[2] + Win.Size[2] - 25 } , FontColor , Toggle)
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
                    if Win.ToggleReading and KeyRead ~= "[Unknown]" and KeyRead ~= "[LBUTTON]" then
                        Win.ToggleKey = KeyRead
                        Win.ToggleReading = false
                    end

                    FooterWidth = FooterWidth + Toggle_Width + 12
                end

                --// RGB //--
                if Win.FooterRGB then
                    local RGB = "RGB: OFF"
                    local RGB_Width = dx9.CalcTextWidth(RGB)
                    if Win.Rainbow then RGB = "RGB: ON" end


                    dx9.DrawBox( { FooterWidth + Win.Location[1] + 5 , Win.Location[2] + Win.Size[2] - 28 } , { FooterWidth + Win.Location[1] + 15 + RGB_Width , Win.Location[2] + Win.Size[2] - 4 } , OutlineColor ) 

                    if Win.RGBHovering then
                        dx9.DrawBox( { FooterWidth + Win.Location[1] + 6 , Win.Location[2] + Win.Size[2] - 27 } , { FooterWidth + Win.Location[1] + 14 + RGB_Width , Win.Location[2] + Win.Size[2] - 5 } , AccentColor ) 
                    else
                        dx9.DrawBox( { FooterWidth + Win.Location[1] + 6 , Win.Location[2] + Win.Size[2] - 27 } , { FooterWidth + Win.Location[1] + 14 + RGB_Width , Win.Location[2] + Win.Size[2] - 5 } , Lib.Black ) 
                    end

                    dx9.DrawFilledBox( { FooterWidth + Win.Location[1] + 7 , Win.Location[2] + Win.Size[2] - 26 } , { FooterWidth + Win.Location[1] + 13 + RGB_Width , Win.Location[2] + Win.Size[2] - 6 } , BackgroundColor ) 

                    dx9.DrawString( { FooterWidth + Win.Location[1] + 10 , Win.Location[2] + Win.Size[2] - 25 } , FontColor , RGB)


                    --// Click Detect
                    if Lib.MouseInArea( { FooterWidth + Win.Location[1] + 5 , Win.Location[2] + Win.Size[2] - 28 , FooterWidth + Win.Location[1] + 15 + RGB_Width , Win.Location[2] + Win.Size[2] - 4 }, Win.DeadZone ) then
                        
                        --// Click Detection
                        if dx9.isLeftClickHeld() then
                            Win.RGBKeyHolding = true;
                        else
                            if Win.RGBKeyHolding then
                                Log(1)
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

                    dx9.DrawBox( { FooterWidth + Win.Location[1] + 5 , Win.Location[2] + Win.Size[2] - 28 } , { FooterWidth + Win.Location[1] + 15 + Coords_Width , Win.Location[2] + Win.Size[2] - 4 } , OutlineColor ) 
                    dx9.DrawBox( { FooterWidth + Win.Location[1] + 6 , Win.Location[2] + Win.Size[2] - 27 } , { FooterWidth + Win.Location[1] + 14 + Coords_Width , Win.Location[2] + Win.Size[2] - 5 } , Lib.Black ) 
                    dx9.DrawFilledBox( { FooterWidth + Win.Location[1] + 7 , Win.Location[2] + Win.Size[2] - 26 } , { FooterWidth + Win.Location[1] + 13 + Coords_Width , Win.Location[2] + Win.Size[2] - 6 } , BackgroundColor ) 

                    dx9.DrawString( { FooterWidth + Win.Location[1] + 10 , Win.Location[2] + Win.Size[2] - 25 } , FontColor , Coords)
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
                dx9.DrawFilledBox( { Win.Location[1] + 10 + Win.TabMargin , Win.Location[2] + 25 } , { Win.Location[1] + 14 + TabLength + Win.TabMargin , Win.Location[2] + 50 } , OutlineColor )
                dx9.DrawFilledBox( { Win.Location[1] + 11 + Win.TabMargin , Win.Location[2] + 26 } , { Win.Location[1] + 13 + TabLength + Win.TabMargin , Win.Location[2] + 50 } , MainColor )
                dx9.DrawFilledBox( { Win.Location[1] + 12 + Win.TabMargin , Win.Location[2] + 27 } , { Win.Location[1] + 12 + TabLength + Win.TabMargin , Win.Location[2] + 50 } , MainColor )

                dx9.DrawFilledBox( { Win.Location[1] + 11 + Win.TabMargin , Win.Location[2] + 26 } , { Win.Location[1] + 13 + TabLength + Win.TabMargin , Win.Location[2] + 27 } , AccentColor )
            else

                --// Else
                dx9.DrawFilledBox( { Win.Location[1] + 10 + Win.TabMargin , Win.Location[2] + 26 } , { Win.Location[1] + 14 + TabLength + Win.TabMargin , Win.Location[2] + 50 } , OutlineColor )
                dx9.DrawFilledBox( { Win.Location[1] + 11 + Win.TabMargin , Win.Location[2] + 27 } , { Win.Location[1] + 13 + TabLength + Win.TabMargin , Win.Location[2] + 49 } , MainColor )
                dx9.DrawFilledBox( { Win.Location[1] + 12 + Win.TabMargin , Win.Location[2] + 28 } , { Win.Location[1] + 12 + TabLength + Win.TabMargin , Win.Location[2] + 48 } , BackgroundColor )
            end

            --// Draw Tab Name
            dx9.DrawString( { Win.Location[1] + 12 + Win.TabMargin , Win.Location[2] + 28 } , FontColor , " "..TabName )
            
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
                    dx9.DrawFilledBox( { Win.Location[1] + 20, Win.Location[2] + Tab.Leftstack } , { Win.Location[1] + (Win.Size[1] / 2) - 3, Win.Location[2] + Tab.Leftstack + Groupbox.Size[2] } , OutlineColor )
                    dx9.DrawFilledBox( { Win.Location[1] + 21, Win.Location[2] + Tab.Leftstack + 1 } , { Win.Location[1] + (Win.Size[1] / 2) - 4, Win.Location[2] + Tab.Leftstack + 3 } , AccentColor )
                    dx9.DrawFilledBox( { Win.Location[1] + 21, Win.Location[2] + Tab.Leftstack + 4 } , { Win.Location[1] + (Win.Size[1] / 2) - 4, Win.Location[2] + Tab.Leftstack + Groupbox.Size[2] - 1 } , BackgroundColor )


                    dx9.DrawString( { Win.Location[1] + ( ( Win.Size[1] / 4 + 10) ) - (dx9.CalcTextWidth(GroupboxName) / 2) , Win.Location[2] + Tab.Leftstack + 4 } , FontColor , GroupboxName )

                    Groupbox.Root = { Win.Location[1] + 21, Win.Location[2] + Tab.Leftstack + 10 }

                    Tab.Leftstack = Tab.Leftstack + Groupbox.Size[2] + 10

                    Win:SetRestraint({0, Tab.Leftstack + 35})
                elseif side == "right" then

                    --// Right Groupbox
                    dx9.DrawFilledBox( { Win.Location[1] + (Win.Size[1] / 2) + 3, Win.Location[2] + Tab.Rightstack } , { Win.Location[1] + (Win.Size[1]) - 20, Win.Location[2] + Tab.Rightstack + Groupbox.Size[2] } , OutlineColor )
                    dx9.DrawFilledBox( { Win.Location[1] + (Win.Size[1] / 2) + 4, Win.Location[2] + Tab.Rightstack + 1 } , { Win.Location[1] + (Win.Size[1]) - 21, Win.Location[2] + Tab.Rightstack + 3 } , AccentColor )
                    dx9.DrawFilledBox( { Win.Location[1] + (Win.Size[1] / 2) + 4, Win.Location[2] + Tab.Rightstack + 4 } , { Win.Location[1] + (Win.Size[1]) - 21, Win.Location[2] + Tab.Rightstack + Groupbox.Size[2] - 1 } , BackgroundColor )


                    dx9.DrawString( { ( Win.Location[1] + ( ( Win.Size[1] / 1.4 + 10) ) - (dx9.CalcTextWidth(GroupboxName) / 2)) , Win.Location[2] + Tab.Rightstack + 4 } , FontColor , GroupboxName )

                    Groupbox.Root = {  math.floor(Win.Location[1] + (Win.Size[1] / 2) + 4 + 0.5), math.floor(Win.Location[2] + Tab.Rightstack + 10 + 0.5) }

                    Tab.Rightstack = Tab.Rightstack + Groupbox.Size[2] + 10

                    Win:SetRestraint({0, Tab.Rightstack + 35})
                else

                    --// Middle Groupbox
                    local largest_stack = Tab.Leftstack
                    if Tab.Rightstack > largest_stack then largest_stack = Tab.Rightstack end

                    dx9.DrawFilledBox( { Win.Location[1] + 20, Win.Location[2] + largest_stack } , { Win.Location[1] + (Win.Size[1]) - 20, Win.Location[2] + largest_stack + Groupbox.Size[2] } , OutlineColor )
                    dx9.DrawFilledBox( { Win.Location[1] + 21, Win.Location[2] + largest_stack + 1 } , { Win.Location[1] + (Win.Size[1]) - 21, Win.Location[2] + largest_stack + 3 } , AccentColor )
                    dx9.DrawFilledBox( { Win.Location[1] + 21, Win.Location[2] + largest_stack + 4 } , { Win.Location[1] + (Win.Size[1]) - 21, Win.Location[2] + largest_stack + Groupbox.Size[2] - 1 } , BackgroundColor )


                    dx9.DrawString( { Win.Location[1] + ( ( Win.Size[1] / 2 ) ) - (dx9.CalcTextWidth(GroupboxName) / 2) , Win.Location[2] + largest_stack + 4 } , FontColor , GroupboxName )

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

                    --Groupbox.WidthRestraint = dx9.CalcTextWidth(NewButtonName) + 17 CHANGE THIS SHIT DONT WORK BRO


                    if Button.Hovering then
                        dx9.DrawFilledBox( { Groupbox.Root[1] + 4 , Groupbox.Root[2] + 19 + Groupbox.ToolSpacing } , { Groupbox.Root[1] + 4 + button_x , Groupbox.Root[2] + 22 + ((18) * n) + Groupbox.ToolSpacing } , AccentColor )
                    else
                        dx9.DrawFilledBox( { Groupbox.Root[1] + 4 , Groupbox.Root[2] + 19 + Groupbox.ToolSpacing } , { Groupbox.Root[1] + 4 + button_x , Groupbox.Root[2] + 22 + ((18) * n) + Groupbox.ToolSpacing } , Lib.Black )
                    end

                    dx9.DrawFilledBox( { Groupbox.Root[1] + 5 , Groupbox.Root[2] + 20 + Groupbox.ToolSpacing } , { Groupbox.Root[1] + 3 + button_x , Groupbox.Root[2] + 21 + ((18) * n) + Groupbox.ToolSpacing } , OutlineColor )

                    if Button.Holding == true then
                        dx9.DrawFilledBox( { Groupbox.Root[1] + 6 , Groupbox.Root[2] + 21 + Groupbox.ToolSpacing } , { Groupbox.Root[1] + 2 + button_x , Groupbox.Root[2] + 20 + ((18) * n) + Groupbox.ToolSpacing } , OutlineColor )
                    else
                        dx9.DrawFilledBox( { Groupbox.Root[1] + 6 , Groupbox.Root[2] + 21 + Groupbox.ToolSpacing } , { Groupbox.Root[1] + 2 + button_x , Groupbox.Root[2] + 20 + ((18) * n) + Groupbox.ToolSpacing } , MainColor )
                    end

                    dx9.DrawString( { Groupbox.Root[1] + 8 , Groupbox.Root[2] + 20 + Groupbox.ToolSpacing } , FontColor , NewButtonName )

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
                local Text = params.Text or params.Name

                --// Error Handling
                assert(type(Text) == "string" or type(Text) == "number", "[ERROR] AddColorPicker: Name / Text Variable must be a number or string!")
                
                --// Init-Defs
                if Groupbox.Tools[Text] == nil then
                    Groupbox.Tools[Text] = { 
                        Boundary = { 0 , 0 , 0 , 0 };
                        Value = params.Default or {0,0,0};
                        Holding = false;
                        Hovering = false;
                        AddonY = nil;

                        TopColor = params.Default or {0,0,0};
                        StoredIndex = Lib:GetIndex((params.Default or {0,0,0}))[1];
                        StoredIndex2 = Lib:GetIndex((params.Default or {0,0,0}))[2];

                        --// Bar Hovering
                        FirstBarHovering = false;
                        SecondBarHovering = false;
                    }
                end

                --// Re-Defines
                Groupbox.Tools[Text].Text = params.Text
                Picker = Groupbox.Tools[Text]

                --// SetValue
                function Picker:SetValue( value )
                    Picker.Value = value;
                    Picker.StoredIndex = Lib:GetIndex(value)[1];
                    Picker.StoredIndex2 = Lib:GetIndex(value)[2];
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
                        dx9.DrawFilledBox( { Groupbox.Root[1] + 6 , Groupbox.Root[2] + 21 + Groupbox.ToolSpacing } , { Groupbox.Root[1] + 33 , Groupbox.Root[2] + 38 + Groupbox.ToolSpacing } , AccentColor )
                    else
                        dx9.DrawFilledBox( { Groupbox.Root[1] + 6 , Groupbox.Root[2] + 21 + Groupbox.ToolSpacing } , { Groupbox.Root[1] + 33 , Groupbox.Root[2] + 38 + Groupbox.ToolSpacing } , Lib.Black )
                    end

                    dx9.DrawFilledBox( { Groupbox.Root[1] + 7 , Groupbox.Root[2] + 22 + Groupbox.ToolSpacing } , { Groupbox.Root[1] + 32 , Groupbox.Root[2] + 37 + Groupbox.ToolSpacing } , OutlineColor )

                    dx9.DrawFilledBox( { Groupbox.Root[1] + 8 , Groupbox.Root[2] + 23 + Groupbox.ToolSpacing } , { Groupbox.Root[1] + 31 , Groupbox.Root[2] + 36 + Groupbox.ToolSpacing } , Picker.Value )

                    --// Trimming Text
                    local TrimmedToggleText = params.Text;
                    if dx9.CalcTextWidth(TrimmedToggleText) >=  Groupbox.Size[1] - 45 then -- CHANGE TO ADAPT TO GROUPBOX SIZE (copy button plox)
                        repeat
                            TrimmedToggleText = TrimmedToggleText:sub(1,-2)
                        until dx9.CalcTextWidth(TrimmedToggleText) <= Groupbox.Size[1] - 45
                    end

                    --// Drawing Text
                    dx9.DrawString( { Groupbox.Root[1] + 33 , Groupbox.Root[2] + 19 + Groupbox.ToolSpacing } , FontColor , " "..TrimmedToggleText)

                    --// Boundaries and Addon
                    Picker.Boundary = { Groupbox.Root[1] + 4 , Groupbox.Root[2] + 19 + Groupbox.ToolSpacing ,  Groupbox.Root[1] + Groupbox.Size[1] - 5 , Groupbox.Root[2] + 40 + Groupbox.ToolSpacing }
                    Picker.AddonY = Groupbox.ToolSpacing

                    --// Render Picker Box
                    function Picker:Render()
                        if Win.CurrentTab ~= nil and Win.CurrentTab == TabName and Win.Active and Groupbox.Visible then
                            Win.DeadZone = { Groupbox.Root[1] + 6 , Groupbox.Root[2] + 42 + Picker.AddonY, Groupbox.Root[1] + 223 , Groupbox.Root[2] + 125 + Picker.AddonY }

                            dx9.DrawFilledBox( { Groupbox.Root[1] + 6 , Groupbox.Root[2] + 42 + Picker.AddonY } , { Groupbox.Root[1] + 223 , Groupbox.Root[2] + 125 + Picker.AddonY } , Lib.Black )
                            dx9.DrawFilledBox( { Groupbox.Root[1] + 7 , Groupbox.Root[2] + 43 + Picker.AddonY } , { Groupbox.Root[1] + 222 , Groupbox.Root[2] + 124 + Picker.AddonY } , OutlineColor )
                            dx9.DrawFilledBox( { Groupbox.Root[1] + 8 , Groupbox.Root[2] + 44 + Picker.AddonY } , { Groupbox.Root[1] + 221 , Groupbox.Root[2] + 123 + Picker.AddonY } , BackgroundColor )

                            dx9.DrawFilledBox( { Groupbox.Root[1] + 8 , Groupbox.Root[2] + 44 + Picker.AddonY } , { Groupbox.Root[1] + 221 , Groupbox.Root[2] + 46 + Picker.AddonY } , AccentColor )

                            --// DRAWING THE COLORS BRUH
                            -- Bar 1
                            if Picker.SecondBarHovering then
                                dx9.DrawFilledBox( { Groupbox.Root[1] + 10 , Groupbox.Root[2] + 49 + Picker.AddonY } , { Groupbox.Root[1] + 220 , Groupbox.Root[2] + 71 + Picker.AddonY } , AccentColor )
                            else
                                dx9.DrawFilledBox( { Groupbox.Root[1] + 10 , Groupbox.Root[2] + 49 + Picker.AddonY } , { Groupbox.Root[1] + 220 , Groupbox.Root[2] + 71 + Picker.AddonY } , Lib.Black )
                            end
                            
                            dx9.DrawFilledBox( { Groupbox.Root[1] + 11 , Groupbox.Root[2] + 50 + Picker.AddonY } , { Groupbox.Root[1] + 219 , Groupbox.Root[2] + 70 + Picker.AddonY } , OutlineColor )
                            dx9.DrawFilledBox( { Groupbox.Root[1] + 12 , Groupbox.Root[2] + 51 + Picker.AddonY } , { Groupbox.Root[1] + 218 , Groupbox.Root[2] + 69 + Picker.AddonY } , AccentColor )
                            

                            -- Bar 2
                            if Picker.FirstBarHovering then
                                dx9.DrawFilledBox( { Groupbox.Root[1] + 10 , Groupbox.Root[2] + 49 + 25 + Picker.AddonY } , { Groupbox.Root[1] + 220 , Groupbox.Root[2] + 71 + 25 + Picker.AddonY } , AccentColor )
                            else
                                dx9.DrawFilledBox( { Groupbox.Root[1] + 10 , Groupbox.Root[2] + 49 + 25 + Picker.AddonY } , { Groupbox.Root[1] + 220 , Groupbox.Root[2] + 71 + 25 + Picker.AddonY } , Lib.Black )
                            end
                            dx9.DrawFilledBox( { Groupbox.Root[1] + 11 , Groupbox.Root[2] + 50 + 25 + Picker.AddonY } , { Groupbox.Root[1] + 219 , Groupbox.Root[2] + 70 + 25 + Picker.AddonY } , OutlineColor )
                            dx9.DrawFilledBox( { Groupbox.Root[1] + 12 , Groupbox.Root[2] + 51 + 25 + Picker.AddonY } , { Groupbox.Root[1] + 218 , Groupbox.Root[2] + 69 + 25 + Picker.AddonY } , AccentColor )

                            -- Rest
                            dx9.DrawFilledBox( { Groupbox.Root[1] + 10 , Groupbox.Root[2] + 49 + 50 + Picker.AddonY } , { Groupbox.Root[1] + 113 , Groupbox.Root[2] + 71 + 50 + Picker.AddonY } , Lib.Black )
                            dx9.DrawFilledBox( { Groupbox.Root[1] + 11 , Groupbox.Root[2] + 50 + 50 + Picker.AddonY } , { Groupbox.Root[1] + 112 , Groupbox.Root[2] + 70 + 50 + Picker.AddonY } , OutlineColor )
                            dx9.DrawFilledBox( { Groupbox.Root[1] + 12 , Groupbox.Root[2] + 51 + 50 + Picker.AddonY } , { Groupbox.Root[1] + 111 , Groupbox.Root[2] + 69 + 50 + Picker.AddonY } , MainColor )

                            dx9.DrawString( { Groupbox.Root[1] + 12 , Groupbox.Root[2] + 51 + 50 + Picker.AddonY } , FontColor , " "..Lib:rgbToHex(Picker.Value))

                            dx9.DrawFilledBox( { Groupbox.Root[1] + 116 , Groupbox.Root[2] + 49 + 50 + Picker.AddonY } , { Groupbox.Root[1] + 219 , Groupbox.Root[2] + 71 + 50 + Picker.AddonY } , Lib.Black )
                            dx9.DrawFilledBox( { Groupbox.Root[1] + 117 , Groupbox.Root[2] + 50 + 50 + Picker.AddonY } , { Groupbox.Root[1] + 218 , Groupbox.Root[2] + 70 + 50 + Picker.AddonY } , OutlineColor )
                            dx9.DrawFilledBox( { Groupbox.Root[1] + 118 , Groupbox.Root[2] + 51 + 50 + Picker.AddonY } , { Groupbox.Root[1] + 217 , Groupbox.Root[2] + 69 + 50 + Picker.AddonY } , MainColor )

                            -- rgb
                            dx9.DrawString( { Groupbox.Root[1] + 118 , Groupbox.Root[2] + 51 + 50 + Picker.AddonY } , FontColor , " ".. math.floor(Picker.Value[1] + 0.5)..", ".. math.floor(Picker.Value[2] + 0.5)..", ".. math.floor(Picker.Value[3] + 0.5))

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
                                    Picker.Value = Color
                                end

                                dx9.DrawBox( { Groupbox.Root[1] + 12 + i, Groupbox.Root[2] + 51 + 25 + Picker.AddonY } , { Groupbox.Root[1] + 12 + i, Groupbox.Root[2] + 69 + 25 + Picker.AddonY }, Color )
                            end

                            dx9.DrawFilledBox( { Groupbox.Root[1] + 12 + Picker.StoredIndex2 , Groupbox.Root[2] + 50 + Picker.AddonY } , { Groupbox.Root[1] + 15 + Picker.StoredIndex2 , Groupbox.Root[2] + 70 + Picker.AddonY } , OutlineColor )
                            dx9.DrawBox( { Groupbox.Root[1] + 12 + Picker.StoredIndex2 , Groupbox.Root[2] + 49 + Picker.AddonY } , { Groupbox.Root[1] + 15 + Picker.StoredIndex2 , Groupbox.Root[2] + 71 + Picker.AddonY } , Lib.Black )

                            dx9.DrawFilledBox( { Groupbox.Root[1] + 12 + Picker.StoredIndex, Groupbox.Root[2] + 75 + Picker.AddonY } , { Groupbox.Root[1] + 15 + Picker.StoredIndex , Groupbox.Root[2] + 95 + Picker.AddonY } , OutlineColor )
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

                --// Closing Difines and Resets | Picker
                Groupbox.Tools[Text] = Picker;

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
                    dx9.DrawString( { Groupbox.Root[1] + 6 , Groupbox.Root[2] + 21 + Groupbox.ToolSpacing } , FontColor , trimmed_text)
                    dx9.DrawFilledBox( { Groupbox.Root[1] + 5 , Groupbox.Root[2] + 40 + Groupbox.ToolSpacing } , { Groupbox.Root[1] + Groupbox.Size[1] - 7, Groupbox.Root[2] + 42 + Groupbox.ToolSpacing } , AccentColor )

                    --// Expanding Groupbox
                    Groupbox.Size[2] = Groupbox.Size[2] + (7 + 18) --// CHANGE MIGHT NEED TO PUT ABOVE ALL THE STUFF
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
                    dx9.DrawFilledBox( { Groupbox.Root[1] + 5 , Groupbox.Root[2] + Groupbox.ToolSpacing + 20} , { Groupbox.Root[1] + Groupbox.Size[1] - 7, Groupbox.Root[2] + 2 + Groupbox.ToolSpacing + 20} , AccentColor )

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

            function Groupbox:AddLabel(text)

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
                    dx9.DrawString( { Groupbox.Root[1] + 8 , Groupbox.Root[2] + 20 + Groupbox.ToolSpacing } , FontColor , trimmed_text)

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
                local Name = params.Name or params.Text

                --// Error Handling
                assert(type(Name) == "string" or type(Name) == "number", "[ERROR] AddSlider: Text / Name parameter must be a string or number!")

                --// Init Def
                if Groupbox.Tools[Name] == nil then
                    Slider = { 
                        Boundary = { 0 , 0 , 0 , 0 };
                        Holding = false;
                        Value = params.Default or params.Min or 0;
                        Rounding = ( params.Rounding or 0 );
                        Suffix = ( params.Suffix or "" );
                        Hovering = false;
                    }
                    Groupbox.Tools[Name] = Slider
                end

                --// Re-Setting Values
                Slider = Groupbox.Tools[Name]
                Slider.Rounding = ( params.Rounding or 0 );
                Slider.Suffix = ( params.Suffix or "" );
    
                --// Setvalue Func
                function Slider:SetValue( num )
                    if Slider.Value ~= num then
                        Slider.Value = num
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
                        dx9.DrawFilledBox( { Groupbox.Root[1] + 4 , Groupbox.Root[2] + 34 + Groupbox.ToolSpacing } , { Groupbox.Root[1] + Groupbox.Size[1] - 6, Groupbox.Root[2] + 55 + Groupbox.ToolSpacing } , AccentColor )
                    else
                        dx9.DrawFilledBox( { Groupbox.Root[1] + 4 , Groupbox.Root[2] + 34 + Groupbox.ToolSpacing } , { Groupbox.Root[1] + Groupbox.Size[1] - 6, Groupbox.Root[2] + 55 + Groupbox.ToolSpacing } , Lib.Black )
                    end

                    dx9.DrawFilledBox( { Groupbox.Root[1] + 5 , Groupbox.Root[2] + 35 + Groupbox.ToolSpacing } , { Groupbox.Root[1] + Groupbox.Size[1] - 7 , Groupbox.Root[2] + 54 + Groupbox.ToolSpacing } , OutlineColor )

                    if Slider.Holding then
                        dx9.DrawFilledBox( { Groupbox.Root[1] + 6 , Groupbox.Root[2] + 36 + Groupbox.ToolSpacing } , { Groupbox.Root[1] + Groupbox.Size[1] - 8 , Groupbox.Root[2] + 53 + Groupbox.ToolSpacing } , OutlineColor )
                    else
                        dx9.DrawFilledBox( { Groupbox.Root[1] + 6 , Groupbox.Root[2] + 36 + Groupbox.ToolSpacing } , { Groupbox.Root[1] + Groupbox.Size[1] - 8 , Groupbox.Root[2] + 53 + Groupbox.ToolSpacing } , MainColor )
                    end

                    dx9.DrawFilledBox( { Groupbox.Root[1] + 6 , Groupbox.Root[2] + 36 + Groupbox.ToolSpacing } , { Groupbox.Root[1] + 6 + ( bar_length * val ) , Groupbox.Root[2] + 53 + Groupbox.ToolSpacing } , AccentColor )

                    --// Writing Text
                    dx9.DrawString( { Groupbox.Root[1] + 4 , Groupbox.Root[2] + 18 + Groupbox.ToolSpacing } , FontColor , Name )
                    dx9.DrawString( { Groupbox.Root[1] + 8 , Groupbox.Root[2] + 36 + Groupbox.ToolSpacing } , FontColor , temp )


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

                            Slider.Value = math.floor(((val * ( params.Max - params.Min )) + params.Min) + 0.5)
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

                --// Closing Difines and Resets | Slider
                Groupbox.Tools[Name] = Slider;

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
                local Name = params.Text or params.Name
                
                --// Error Handling
                assert(type(Name) == "string" or type(Name) == "number", "[ERROR] AddToggle: Text / Name Argument must be a string or number!")

                --// Init Defs
                if Groupbox.Tools[Name] == nil then
                    Groupbox.Tools[Name] = { 
                        Boundary = { 0 , 0 , 0 , 0 };
                        Value = params.Default or false;
                        Holding = false;
                        Hovering = false;
                    }
                end

                --// Re-Setting Toggle
                Toggle = Groupbox.Tools[Name]

                --// Set Value
                function Toggle:SetValue( value )
                    Toggle.Value = value;
                end


                --// Draw Toggle in Groupbox
                if Win.CurrentTab ~= nil and Win.CurrentTab == TabName and Win.Active and Groupbox.Visible then

                    --// Expanding Groupbox
                    Groupbox.Size[2] = Groupbox.Size[2] + 25

                    --// Drawing Toggle
                    if Toggle.Hovering then
                        dx9.DrawFilledBox( { Groupbox.Root[1] + 6 , Groupbox.Root[2] + 21 + Groupbox.ToolSpacing } , { Groupbox.Root[1] + 23 , Groupbox.Root[2] + 38 + Groupbox.ToolSpacing } , AccentColor )
                    else
                        dx9.DrawFilledBox( { Groupbox.Root[1] + 6 , Groupbox.Root[2] + 21 + Groupbox.ToolSpacing } , { Groupbox.Root[1] + 23 , Groupbox.Root[2] + 38 + Groupbox.ToolSpacing } , Lib.Black )
                    end

                    dx9.DrawFilledBox( { Groupbox.Root[1] + 7 , Groupbox.Root[2] + 22 + Groupbox.ToolSpacing } , { Groupbox.Root[1] + 22 , Groupbox.Root[2] + 37 + Groupbox.ToolSpacing } , OutlineColor )

                    if Toggle.Value then
                        dx9.DrawFilledBox( { Groupbox.Root[1] + 8 , Groupbox.Root[2] + 23 + Groupbox.ToolSpacing } , { Groupbox.Root[1] + 21 , Groupbox.Root[2] + 36 + Groupbox.ToolSpacing } , AccentColor )
                    else
                        dx9.DrawFilledBox( { Groupbox.Root[1] + 8 , Groupbox.Root[2] + 23 + Groupbox.ToolSpacing } , { Groupbox.Root[1] + 21 , Groupbox.Root[2] + 36 + Groupbox.ToolSpacing } , MainColor )
                    end

                    --// Trimming Text
                    local TrimmedToggleText = Name;
                    if dx9.CalcTextWidth(TrimmedToggleText) >= Groupbox.Size[1] - 30 then -- HERE
                        repeat
                            TrimmedToggleText = TrimmedToggleText:sub(1,-2)
                        until dx9.CalcTextWidth(TrimmedToggleText) <= Groupbox.Size[1] - 30
                    end

                    --// Drawing Text
                    dx9.DrawString( { Groupbox.Root[1] + 23 , Groupbox.Root[2] + 19 + Groupbox.ToolSpacing } , FontColor , " "..TrimmedToggleText)

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
                end

                --// Closing Difines and Resets | Toggle
                Groupbox.Tools[Name] = Toggle;

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

function Lib:Notify(text, length)

    if length == nil then length = 3 end

    local notif = {Text = text, Start = total_seconds, Length = length}

    table.insert(Lib.Notifications, notif)
end

for i,v in pairs(Lib.Notifications) do
    if v.Start < total_seconds - v.Length then
        Lib.Notifications[i] = nil
    else

        --// Notification Root
        local root = {0, 200 + (22 * i)}

        --// Text Length
        local length = dx9.CalcTextWidth(v.Text)

        --// Draw Notification
        dx9.DrawFilledBox( { root[1] + 4 , root[2] + 19 } , { root[1] + 4 + length + 12, root[2] + 22 + (18) } , Lib.Black )
        dx9.DrawFilledBox( { root[1] + 5 , root[2] + 20 } , { root[1] + 3 + length + 12, root[2] + 21 + (18) } , Lib.OutlineColor )
        dx9.DrawFilledBox( { root[1] + 6 , root[2] + 21 } , { root[1] + 2 + length + 12, root[2] + 20 + (18) } , Lib.MainColor )
        dx9.DrawFilledBox( { root[1] + 6 , root[2] + 21 } , { root[1] + 8 , root[2] + 20 + (18) } , Lib.CurrentRainbowColor )

        dx9.DrawString( { root[1] + 11 , root[2] + 20 } , Lib.FontColor , v.Text )
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
Lib.FirstRun = false

--==--==--==--==--==--==--==--==--==--==--==--==--==--==--==--==--==--==--==--==--==--==--==--==--==--==--





--local Widnow = Lib:CreateWindow({Title = "Test Window", Size = {500,500}, Resizable = true, FooterMouseCoords = true, FooterRGB = true })


--// Window 1 | More practical and large window example //--
local Window1 = Lib:CreateWindow({Title = "Normal Window", Size = {500,500}, Resizable = true })

--// Making Tabs
local Tab = Window1:AddTab("Tab 1 (main bruh)")
local Tab2 = Window1:AddTab("Tab 2")

--// Making Groupboxes
local Groupbox1 = Tab:AddGroupbox("Groupbox 1", "LeFT")
local Groupbox2 = Tab:AddGroupbox("Groupbox 2", "rIgHt")
local Groupbox3 = Tab:AddGroupbox("Middle gopbox", "MIDDLE!!!")

local gb4 = Tab:AddLeftGroupbox("Another groupbox to show stacking")
local gb5 = Tab:AddRightGroupbox("Another groupbox !")

--// Button Demo
Groupbox1:AddButton("Make Compact", function()
    Window1.Size = {0, 0}
end)

--// Border Demo
Groupbox1:AddBorder()

--// Multiline Button Demo
Groupbox1:AddButton("Multiline\nButton\nDemo", function()

end)

--// Long Ass Button Demo
Groupbox2:AddButton("Long ass button to show text cutting off when the window is too small to fix the full extent of the test :3", function()

end)

--// Title Demo
Groupbox2:AddTitle("Title Demo")

--// Colorpicker Demo
local colorpicer1 = Groupbox2:AddColorPicker({Default = {255,100,255}, Text = "A heckin short colorpicker!"})

--// Label Demo
Groupbox2:AddLabel("This is a label test\nLine 2 of the label :)\nLine 3 which will be long to show how the text cuts off, i'm assuming you realize that every element has text limiting at this point but im making this just to make sure")

--// Slider Demos
local slider1 = Groupbox2:AddSlider({Text = "Slider Demo 1", Default = 69, Min = 0, Max = 100})

local slider2 = Groupbox3:AddSlider({Text = "Slider Demo 2", Default = 0, Min = -500, Max = 500})
Groupbox3:AddLabel("The slider's value is: "..slider2.Value)

--// Toggle Demo
local toggle1 = Groupbox1:AddToggle({Text = "Test Toggle 1"})

local toggle2 = Groupbox3:AddToggle({Text = "Test Toggle 2 (RGB TOGGLE)", Default = true})
Window1.Rainbow = toggle2.Value





--// Window 2 | More simplified smaller window example //--
local Window2 = Lib:CreateWindow({Title = "Simplified Window", FooterMouseCoords = false, Rainbow = false, Size = {0, 0}})

local Tab69 = Window2:AddTab("Tab")

local Groupbox69 = Tab69:AddGroupbox("gopbox!", "MIDDLE!!!")


--// Button Demo
Groupbox69:AddButton("Notification Demo!", function()
    Lib:Notify( "im a notification!" , 1)
end)

--// Border Demo
Groupbox69:AddBorder()

--// Multiline Button Demo
Groupbox69:AddButton("Multiline\nButton\nDemo", function()
    
end)

--// Long Ass Button Demo
Groupbox69:AddButton("Long ass button to show text cutting off when the window is too small to fix the full extent of the test :3", function()

end)

--// Title Demo
Groupbox69:AddTitle("Title Demo")

--// Colorpicker Demo
local colorpicer12 = Groupbox69:AddColorPicker({Default = {255,100,255}, Text = "A heckin short colorpicker!"})

--// Label Demo
Groupbox69:AddLabel("This is a label test\nLine 2 of the label :)\nLine 3 which will be long to show how the text cuts off, i'm assuming you realize that every element has text limiting at this point but im making this just to make sure")

--// Slider Demos
local slider22 = Groupbox69:AddSlider({Text = "Slider Demo 2", Default = 0, Min = -500, Max = 500})
Groupbox69:AddLabel("The slider's value is: "..slider22.Value)

--// Toggle Demo
local toggle22 = Groupbox69:AddToggle({Text = "Test Toggle", Default = true})
