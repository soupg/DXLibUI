--// BetterConsole //--

_G["print"] = Log
_G["error"] = LogError

local Con = {};
if _G.Con == nil then
    _G.Con = {
        Location = {1000, 150}; -- Dynamic

        Size = {dx9.size().width / 2.95, dx9.size().height / 1.21}; -- Static

        FontColor = {255,255,255}; -- Static + [Changeable]
        MainColor = {28,28,28}; -- Static + [Changeable]
        BackgroundColor = {20,20,20}; -- Static + [Changeable]
        AccentColor = {0,85,255}; -- Static + [Changeable]
        OutlineColor = {50,50,50}; -- Static + [Changeable]

        Black = {0,0,0}; -- Static

        ErrorColor = {255,100,100};

        WinMouseOffset = nil;

        StoredLogs = {};

        Open = true;

        Hovering = false;
    };
end
local Con = _G.Con


--// Boundary Check
function mouse_in_boundary(v1, v2)
    if dx9.GetMouse().x > v1[1] and dx9.GetMouse().y > v1[2] and dx9.GetMouse().x < v2[1] and dx9.GetMouse().y < v2[2] then
        return true
    else
        return false
    end
end

if mouse_in_boundary({Con.Location[1] + Con.Size[1] - 27, Con.Location[2] + 3}, {Con.Location[1] + Con.Size[1] - 5, Con.Location[2] + 19}) then
    if dx9.isLeftClick() then
        Con.Open = not Con.Open;
    end

    Con.Hovering = true
else
    Con.Hovering = false
end

--// Left Click Held
if dx9.isLeftClickHeld() then
    --// Drag Func
    if mouse_in_boundary({Con.Location[1] - 5, Con.Location[2] - 10}, {Con.Location[1] + Con.Size[1] + 5, Con.Location[2] + 30}) then
        if Con.WinMouseOffset == nil then
            Con.WinMouseOffset = {dx9.GetMouse().x - Con.Location[1], dx9.GetMouse().y - Con.Location[2]}
        end
        Con.Location = {dx9.GetMouse().x - Con.WinMouseOffset[1], dx9.GetMouse().y - Con.WinMouseOffset[2]}
    end
else
    Con.WinMouseOffset = nil
end

if Con.Open then
    dx9.DrawFilledBox({Con.Location[1] - 1, Con.Location[2] - 1}, {Con.Location[1] + Con.Size[1] + 1, Con.Location[2] + Con.Size[2] + 1}, Con.Black) --// Outline
    dx9.DrawFilledBox(Con.Location, {Con.Location[1] + Con.Size[1], Con.Location[2] + Con.Size[2]}, Con.AccentColor) --// Accent
    dx9.DrawFilledBox({Con.Location[1] + 1, Con.Location[2] + 1}, {Con.Location[1] + Con.Size[1] - 1, Con.Location[2] + Con.Size[2] - 1}, Con.MainColor) --// Main Outer (light gray)
    dx9.DrawFilledBox({Con.Location[1] + 5, Con.Location[2] + 20}, {Con.Location[1] + Con.Size[1] - 5, Con.Location[2] + Con.Size[2] - 5}, Con.BackgroundColor) --// Main Inner (dark gray)
    dx9.DrawBox({Con.Location[1] + 5, Con.Location[2] + 20}, {Con.Location[1] + Con.Size[1] - 5, Con.Location[2] + Con.Size[2] - 5}, Con.OutlineColor) --// Main Inner Outline 
    dx9.DrawBox({Con.Location[1] + 6, Con.Location[2] + 21}, {Con.Location[1] + Con.Size[1] - 6, Con.Location[2] + Con.Size[2] - 6}, Con.Black) --// Main Inner Outline Black
    dx9.DrawString(Con.Location, Con.FontColor, "  DX9 Console | Made by Alleexxii and supg")

    for i,v in pairs(Con.StoredLogs) do
        if string.sub(v, 1, 9) == "ERROR_TAG" then
            dx9.DrawString({Con.Location[1] + 10, Con.Location[2] + 5 + i*18}, Con.ErrorColor, string.sub(v, 10, -1))
        else
            dx9.DrawString({Con.Location[1] + 10, Con.Location[2] + 5 + i*18}, Con.FontColor, v)
        end
    end
else
    dx9.DrawFilledBox({Con.Location[1] + 300, Con.Location[2] - 1}, {Con.Location[1] + Con.Size[1] + 1, Con.Location[2] + 23}, Con.Black) --// Outline
    dx9.DrawFilledBox({Con.Location[1] + 301, Con.Location[2]}, {Con.Location[1] + Con.Size[1],  Con.Location[2] + 22}, Con.AccentColor) --// Accent
    dx9.DrawFilledBox({Con.Location[1] + 302, Con.Location[2] + 1}, {Con.Location[1] + Con.Size[1] - 1,  Con.Location[2] + 21}, Con.MainColor) --// Main Outer (light gray)

    dx9.DrawString({Con.Location[1] + 300, Con.Location[2]}, Con.FontColor, "  DX9 Console | Made by Alleexxii and supg")
end


if Con.Hovering then
    dx9.DrawFilledBox({Con.Location[1] + Con.Size[1] - 27, Con.Location[2] + 3}, {Con.Location[1] + Con.Size[1] - 5, Con.Location[2] + 19}, Con.AccentColor) --// Outline
else
    dx9.DrawFilledBox({Con.Location[1] + Con.Size[1] - 27, Con.Location[2] + 3}, {Con.Location[1] + Con.Size[1] - 5, Con.Location[2] + 19}, Con.Black) --// Outline
end

dx9.DrawFilledBox({Con.Location[1] + Con.Size[1] - 26, Con.Location[2] + 4}, {Con.Location[1] + Con.Size[1] - 6, Con.Location[2] + 18}, Con.OutlineColor) --// Inner Line
dx9.DrawFilledBox({Con.Location[1] + Con.Size[1] - 25, Con.Location[2] + 5}, {Con.Location[1] + Con.Size[1] - 7, Con.Location[2] + 17}, Con.MainColor) --// Inner

dx9.DrawString({Con.Location[1] + Con.Size[1] - 20, Con.Location[2] - 2}, Con.FontColor, "_")

function LogError(...)
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
        if #Con.StoredLogs < 45 then
            table.insert(Con.StoredLogs, "ERROR_TAG"..temp)
        else
            table.insert(Con.StoredLogs, "ERROR_TAG"..temp)

            for i,v in pairs(Con.StoredLogs) do
                Con.StoredLogs[i] = Con.StoredLogs[i + 1]
            end
        end
    else
        for i,v in pairs(split_string) do
            if #Con.StoredLogs < 45 then
                table.insert(Con.StoredLogs, "ERROR_TAG"..v)
            else
                table.insert(Con.StoredLogs, "ERROR_TAG"..v)
    
                for i,v in pairs(Con.StoredLogs) do
                    Con.StoredLogs[i] = Con.StoredLogs[i + 1]
                end
            end
        end
    end
end

function Log(...)
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
        if #Con.StoredLogs < 45 then
            table.insert(Con.StoredLogs, temp)
        else
            table.insert(Con.StoredLogs, temp)

            for i,v in pairs(Con.StoredLogs) do
                Con.StoredLogs[i] = Con.StoredLogs[i + 1]
            end
        end
    else
        for i,v in pairs(split_string) do
            if #Con.StoredLogs < 45 then
                table.insert(Con.StoredLogs, v)
            else
                table.insert(Con.StoredLogs, v)
    
                for i,v in pairs(Con.StoredLogs) do
                    Con.StoredLogs[i] = Con.StoredLogs[i + 1]
                end
            end
        end
    end
end


Con.StoredLogs = {};
_G.Con = Con
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


if _G.betterdebugrun == nil then
    local havethesamestructionchild = {"FindFirstChild","FindFirstChildOfClass","FindFirstDescendant"}

    for i,v in pairs(havethesamestructionchild) do
        local old = _G["dx9"][v]
        _G["dx9"][v] = function(...)
            local args = {...}
            if type(args[1]) ~= "number" then
                error("[Error] "..v..": First Argument needs to be a number! (Instance)" .. "\n" .. debug.traceback() .. "\n")
            return
            end
            if type(args[2]) ~= "string" then
                error("[Error] "..v..": Second Argument needs to be a string!" .. "\n" .. debug.traceback() .. "\n")
                return
            end
            return old(...)
        end
    end

    local havethesamestruction = {"GetName","GetAllParts","GetCFrame","GetChildren","GetPosition","GetParent","GetTeam","GetTeamColour","GetCharacter","GetAdornee","GetType","GetImageLabelPosition","GetNumValue","GetStringValue","GetBoolValue"}
    local custommessages = {
        ["GetCharacter"] = ": First Argument needs to be a player instance!",
        ["GetTeam"] = ": First Argument needs to be a player instance!",
        ["GetTeamColour"] = ": First Argument needs to be a player instance!",
        ["GetNumValue"] = ": First Argument needs to be a IntValue Instance!",
    }
    for i,v in pairs(havethesamestruction) do
        local old = _G["dx9"][v]
        _G["dx9"][v] = function(...)
            local args = {...}
            if type(args[1]) ~= "number" then
                local messagethign = custommessages[v] or ": First Argument needs to be a number (Instance)!"
                error("[Error] "..v..messagethign .. "\n" .. debug.traceback() .. "\n")
            return
            end
            return old(...)
        end
    end

    local old = _G["dx9"]["Teleport"]
    _G["dx9"]["Teleport"] = function(...)
        local args = {...}
        if type(args[1]) ~= "number" then
            error("[Error] ".."Teleport"..": First Argument needs to be a number! (Instance)" .. "\n" .. debug.traceback() .. "\n")
        return
        end
        if type(args[2]) ~= "table" then
            error("[Error] ".."Teleport"..": Second Argument needs to be a table!" .. "\n" .. debug.traceback() .. "\n")
            return
        end
        return old(...)
    end

    local old = _G["dx9"]["SetAimbotValue"]
    _G["dx9"]["SetAimbotValue"] = function(...)
        local args = {...}
        if type(args[1]) ~= "string" then
            error("[Error] ".."SetAimbotValue"..": First Argument needs to be a string!" .. "\n" .. debug.traceback() .. "\n")
        return
        end
        if type(args[2]) ~= "number" then
            error("[Error] ".."SetAimbotValue"..": Second Argument needs to be a Number!" .. "\n" .. debug.traceback() .. "\n")
            return
        end
        return old(...)
    end

    local old = _G["dx9"]["get_info"]
    _G["dx9"]["get_info"] = function(...)
        local args = {...}
        if type(args[1]) ~= "string" then
            error("[Error] ".."get_info"..": First Argument needs to be a string!" .. "\n" .. debug.traceback() .. "\n")
        return
        end
        if type(args[2]) ~= "string" then
            error("[Error] ".."get_info"..": Second Argument needs to be a string!" .. "\n" .. debug.traceback() .. "\n")
            return
        end
        return old(...)
    end

    local old = _G["dx9"]["get_player"]
    _G["dx9"]["get_player"] = function(...)
        local args = {...}
        if type(args[1]) ~= "string" then
            error("[Error] ".."get_player"..": First Argument needs to be a string!" .. "\n" .. debug.traceback() .. "\n")
        return
        end
        return old(...)
    end

    for i,v in pairs({"FirstPersonAim","ThirdPersonAim"}) do
        local old = _G["dx9"][v]
        _G["dx9"][v] = function(...)
            local args = {...}
            if type(args[1]) ~= "table" then
                error("[Error] "..v..": First Argument needs to be a table!" .. "\n" .. debug.traceback() .. "\n")
                return
            end
            if type(args[2]) ~= "number" then
                error("[Error] "..v..": Second Argument needs to be a number!" .. "\n" .. debug.traceback() .. "\n")
                return
            end
            if type(args[3]) ~= "number" then
                error("[Error] "..v..": Third Argument needs to be a number!" .. "\n" .. debug.traceback() .. "\n")
                return
            end
            return old(...)
        end
    end

    for i,v in pairs({"DrawFilledBox","DrawLine","DrawBox"}) do
        local old = _G["dx9"][v]
        _G["dx9"][v] = function(...)
            local args = {...}
            if type(args[1]) ~= "table" then
                error("[Error] "..v..": First Argument needs to be a table!" .. "\n" .. debug.traceback() .. "\n")
                return
            end
            if type(args[2]) ~= "table" then
                error("[Error] "..v..": Second Argument needs to be a table!" .. "\n" .. debug.traceback() .. "\n")
                return
            end
            if type(args[3]) ~= "table" then
                error("[Error] "..v..": Third Argument needs to be a table!" .. "\n" .. debug.traceback() .. "\n")
                return
            end
            return old(...)
        end
    end

    local old = _G["dx9"]["DrawCircle"]
    _G["dx9"]["DrawCircle"] = function(...)
        local args = {...}
        local v = "DrawCircle"
        if type(args[1]) ~= "table" then
            error("[Error] "..v..": First Argument needs to be a table!" .. "\n" .. debug.traceback() .. "\n")
            return
        end
        if type(args[2]) ~= "table" then
            error("[Error] "..v..": Second Argument needs to be a table!" .. "\n" .. debug.traceback() .. "\n")
            return
        end
        if type(args[3]) ~= "number" then
            error("[Error] "..v..": Third Argument needs to be a number!" .. "\n" .. debug.traceback() .. "\n")
            return
        end
        return old(...)
    end

    local old = _G["dx9"]["DrawString"]
    _G["dx9"]["DrawString"] = function(...)
        local args = {...}
        local v = "DrawString"
        if type(args[1]) ~= "table" then
            error("[Error] "..v..": First Argument needs to be a table!" .. "\n" .. debug.traceback() .. "\n")
            return
        end
        if type(args[2]) ~= "table" then
            error("[Error] "..v..": Second Argument needs to be a table!" .. "\n" .. debug.traceback() .. "\n")
            return
        end
        if type(args[3]) ~= "string" then
            error("[Error] "..v..": Third Argument needs to be a string!" .. "\n" .. debug.traceback() .. "\n")
            return
        end
        return old(...)
    end

    local old = _G["dx9"]["Box3d"]
    _G["dx9"]["Box3d"] = function(...)
        local args = {...}
        local v = "Box3d"
        if type(args[1]) ~= "table" then
            error("[Error] "..v..": First Argument needs to be a table!" .. "\n" .. debug.traceback() .. "\n")
            return
        end
        if type(args[2]) ~= "table" then
            error("[Error] "..v..": Second Argument needs to be a table!" .. "\n" .. debug.traceback() .. "\n")
            return
        end
        if type(args[3]) ~= "table" then
            error("[Error] "..v..": Third Argument needs to be a table!" .. "\n" .. debug.traceback() .. "\n")
            return
        end
        if type(args[4]) ~= "table" then
            error("[Error] "..v..": Fourth Argument needs to be a table!" .. "\n" .. debug.traceback() .. "\n")
            return
        end
        if type(args[5]) ~= "table" then
            error("[Error] "..v..": Fifth Argument needs to be a table!" .. "\n" .. debug.traceback() .. "\n")
            return
        end
        return old(...)
    end

    local old = _G["dx9"]["WorldToScreen"]
    _G["dx9"]["WorldToScreen"] = function(...)
        local args = {...}
        local v = "WorldToScreen"
        if type(args[1]) ~= "table" then
            error("[Error] "..v..": First Argument needs to be a table!" .. "\n" .. debug.traceback() .. "\n")
            return
        end
        return old(...)
    end
    _G.betterdebugrun = {}
end
