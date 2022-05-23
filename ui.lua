--// Supg's DX9Ware UI Win | Open Source //--
--[[
ADD TAB LIMIT THING


]]

--// Presets
local game = dx9.GetDatamodel();
local Workspace = dx9.FindFirstChild(game,"Workspace");
local Mouse = dx9.GetMouse();
local LocalPlayer = dx9.get_localplayer();
local Players = dx9.get_players();

--[[
 ██████╗ ██╗      ██████╗ ██████╗  █████╗ ██╗         ███████╗██╗   ██╗███╗   ██╗ ██████╗████████╗██╗ ██████╗ ███╗   ██╗███████╗
██╔════╝ ██║     ██╔═══██╗██╔══██╗██╔══██╗██║         ██╔════╝██║   ██║████╗  ██║██╔════╝╚══██╔══╝██║██╔═══██╗████╗  ██║██╔════╝
██║  ███╗██║     ██║   ██║██████╔╝███████║██║         █████╗  ██║   ██║██╔██╗ ██║██║        ██║   ██║██║   ██║██╔██╗ ██║███████╗
██║   ██║██║     ██║   ██║██╔══██╗██╔══██║██║         ██╔══╝  ██║   ██║██║╚██╗██║██║        ██║   ██║██║   ██║██║╚██╗██║╚════██║
╚██████╔╝███████╗╚██████╔╝██████╔╝██║  ██║███████╗    ██║     ╚██████╔╝██║ ╚████║╚██████╗   ██║   ██║╚██████╔╝██║ ╚████║███████║
 ╚═════╝ ╚══════╝ ╚═════╝ ╚═════╝ ╚═╝  ╚═╝╚══════╝    ╚═╝      ╚═════╝ ╚═╝  ╚═══╝ ╚═════╝   ╚═╝   ╚═╝ ╚═════╝ ╚═╝  ╚═══╝╚══════╝
]]


local log = "_LOG_\n"
function Log(...)
    local temp = ""
    for i,v in pairs({...}) do
        temp = temp..tostring(v).." "
    end
    log = log..temp.."\n"
    dx9.DrawString({1700,800}, {255,255,255}, log);
end

Log("X:", dx9.GetMouse().x, "Y:", dx9.GetMouse().y)


--// Boundary Check
function mouse_in_boundary(v1, v2)
    if Mouse.x > v1[1] and Mouse.y > v1[2] and Mouse.x < v2[1] and Mouse.y < v2[2] then
        return true
    else
        return false
    end
end


--[[
██╗   ██╗ █████╗ ██████╗ ██╗ █████╗ ██████╗ ██╗     ███████╗███████╗
██║   ██║██╔══██╗██╔══██╗██║██╔══██╗██╔══██╗██║     ██╔════╝██╔════╝
██║   ██║███████║██████╔╝██║███████║██████╔╝██║     █████╗  ███████╗
╚██╗ ██╔╝██╔══██║██╔══██╗██║██╔══██║██╔══██╗██║     ██╔══╝  ╚════██║
 ╚████╔╝ ██║  ██║██║  ██║██║██║  ██║██████╔╝███████╗███████╗███████║
  ╚═══╝  ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝╚═╝  ╚═╝╚═════╝ ╚══════╝╚══════╝╚══════╝
]]


--// Global Dynamic Values
if _G.Lib == nil then
    _G.Lib = {
        FontColor = {255,255,255}; -- Static + [Changeable]
        MainColor = {28,28,28}; -- Static + [Changeable]
        BackgroundColor = {20,20,20}; -- Static + [Changeable]
        AccentColor = {0,85,255}; -- Static + [Changeable]
        OutlineColor = {50,50,50}; -- Static + [Changeable]

        Black = {0,0,0}; -- Static

        RainbowHue = 0; -- Dynamic
        CurrentRainbowColor = {0,0,0}; -- Dynamic

        FocusedWindow = nil; -- Dynamic

        WindowCount = 0; -- Dynamic
    };
end
local Lib = _G.Lib

Log("GLobals Created")


--[[
██╗   ██╗██╗    ███████╗██╗   ██╗███╗   ██╗ ██████╗████████╗██╗ ██████╗ ███╗   ██╗███████╗
██║   ██║██║    ██╔════╝██║   ██║████╗  ██║██╔════╝╚══██╔══╝██║██╔═══██╗████╗  ██║██╔════╝
██║   ██║██║    █████╗  ██║   ██║██╔██╗ ██║██║        ██║   ██║██║   ██║██╔██╗ ██║███████╗
██║   ██║██║    ██╔══╝  ██║   ██║██║╚██╗██║██║        ██║   ██║██║   ██║██║╚██╗██║╚════██║
╚██████╔╝██║    ██║     ╚██████╔╝██║ ╚████║╚██████╗   ██║   ██║╚██████╔╝██║ ╚████║███████║
 ╚═════╝ ╚═╝    ╚═╝      ╚═════╝ ╚═╝  ╚═══╝ ╚═════╝   ╚═╝   ╚═╝ ╚═════╝ ╚═╝  ╚═══╝╚══════╝
]]

--// Create Window Function
function Lib:CreateWindow(index)
    Log(index, "| Creating Window...")
    -- If indexed window missing, create a new one
    if _G[index] == nil then
        _G[index] = {
            Location = {1300, 300}; -- Dynamic

            Size = {550, 600}; -- Static

            Rainbow = false; -- Dynamic + [Changeable]
    
            Name = index; -- Dynamic + [Changeable]

            ID = index; -- Static

            WinMouseOffset = nil; -- Dynamic

            WindowNum = Lib.WindowCount + 1; -- Static

            Tabs = {}; -- Dynamic

            CurrentTab = nil; -- Dynamic

            TabMargin = 0; -- REALLY DYNAMIC OMG
        }
        Lib.WindowCount = Lib.WindowCount + 1
    end
    local Win = _G[index]

    --// Left Click Held
    if dx9.isLeftClickHeld() then

        --// Drag Func
        if mouse_in_boundary({Win.Location[1] - 5, Win.Location[2] - 10}, {Win.Location[1] + Win.Size[1] + 5, Win.Location[2] + 30}) then
            if Lib.FocusedWindow == nil or Lib.FocusedWindow == Win.ID then
                Lib.FocusedWindow = Win.ID
                if Win.WinMouseOffset == nil then
                    Win.WinMouseOffset = {Mouse.x - Win.Location[1], Mouse.y - Win.Location[2]}
                end
                Win.Location = {Mouse.x - Win.WinMouseOffset[1], Mouse.y - Win.WinMouseOffset[2]}
            else
                if Win.WindowNum > _G[Lib.FocusedWindow].WindowNum then
                    Lib.FocusedWindow = Win.ID
                else
                    Win.WinMouseOffset = nil
                    Lib.FocusedWindow = nil
                end
            end
        end
        
        Log(Win.CurrentTab)
        --// Tab Click
        for _, t in next, Win.Tabs do
            if mouse_in_boundary({t.Boundary[1], t.Boundary[2]}, {t.Boundary[3], t.Boundary[4]}) then
                Log("Click: ", t.Name)
                Win.CurrentTab = t.Name;
            end
        end
    else
        Win.WinMouseOffset = nil
        Lib.FocusedWindow = nil
    end

    --// Display Window //--

    --// Main Window
    dx9.DrawFilledBox({Win.Location[1] - 1, Win.Location[2] - 1}, {Win.Location[1] + Win.Size[1] + 1, Win.Location[2] + Win.Size[2] + 1}, Lib.Black) --// Outline
    if Win.Rainbow == true then
        dx9.DrawFilledBox(Win.Location, {Win.Location[1] + Win.Size[1], Win.Location[2] + Win.Size[2]}, Lib.CurrentRainbowColor) --// Accent (Rainbow)
    else
        dx9.DrawFilledBox(Win.Location, {Win.Location[1] + Win.Size[1], Win.Location[2] + Win.Size[2]}, Lib.AccentColor) --// Accent
    end
    dx9.DrawFilledBox({Win.Location[1] + 1, Win.Location[2] + 1}, {Win.Location[1] + Win.Size[1] - 1, Win.Location[2] + Win.Size[2] - 1}, Lib.MainColor) --// Main Outer (light gray)
    dx9.DrawFilledBox({Win.Location[1] + 5, Win.Location[2] + 20}, {Win.Location[1] + Win.Size[1] - 5, Win.Location[2] + Win.Size[2] - 5}, Lib.BackgroundColor) --// Main Inner (dark gray)
    dx9.DrawBox({Win.Location[1] + 5, Win.Location[2] + 20}, {Win.Location[1] + Win.Size[1] - 5, Win.Location[2] + Win.Size[2] - 5}, Lib.OutlineColor) --// Main Inner Outline
    dx9.DrawString(Win.Location, Lib.FontColor, " "..Win.Name.." | WinNum: "..Win.WindowNum)
    dx9.DrawFilledBox({Win.Location[1] + 10, Win.Location[2] + 49}, {Win.Location[1] + Win.Size[1] - 10, Win.Location[2] + Win.Size[2] - 10}, Lib.Black) --// Main Tab Box Outline
    dx9.DrawFilledBox({Win.Location[1] + 11, Win.Location[2] + 50}, {Win.Location[1] + Win.Size[1] - 11, Win.Location[2] + Win.Size[2] - 11}, Lib.MainColor) --// Main Tab Box




    --// Change Name Function
    function Win:SetWindowTitle(title)
        Win.Name = title
    end

    function Win:SetRGB(bool)
        Win.Rainbow = bool
    end
    
    --// Add Tab Function
    function Win:AddTab(TabName, TabLength)
        local Tab = {}
        if Win.Tabs[TabName] == nil then
            Tab = {
                Name = TabName;
                Boundary = {0,0,0,0};
                Length = TabLength;
                Groupboxes = {};
            };
            Win.Tabs[TabName] = Tab;
        end
        Win.Tabs[TabName].Length = TabLength;
        Win.Tabs[TabName].Name = TabName;

        Tab = Win.Tabs[TabName];
        Log(Tab)

        --// Display 
        if Win.CurrentTab ~= nil and Win.CurrentTab == Tab.Name then
            dx9.DrawFilledBox({Win.Location[1] + 10 + Win.TabMargin, Win.Location[2] + 26}, {Win.Location[1] + 14 + Tab.Length + Win.TabMargin, Win.Location[2] + 50}, Lib.Black)
            dx9.DrawFilledBox({Win.Location[1] + 11 + Win.TabMargin, Win.Location[2] + 27}, {Win.Location[1] + 13 + Tab.Length + Win.TabMargin, Win.Location[2] + 50}, Lib.MainColor)
            dx9.DrawFilledBox({Win.Location[1] + 12 + Win.TabMargin, Win.Location[2] + 28}, {Win.Location[1] + 12 + Tab.Length + Win.TabMargin, Win.Location[2] + 50}, Lib.MainColor)
        else
            dx9.DrawFilledBox({Win.Location[1] + 10 + Win.TabMargin, Win.Location[2] + 26}, {Win.Location[1] + 14 + Tab.Length + Win.TabMargin, Win.Location[2] + 50}, Lib.Black)
            dx9.DrawFilledBox({Win.Location[1] + 11 + Win.TabMargin, Win.Location[2] + 27}, {Win.Location[1] + 13 + Tab.Length + Win.TabMargin, Win.Location[2] + 49}, Lib.MainColor)
            dx9.DrawFilledBox({Win.Location[1] + 12 + Win.TabMargin, Win.Location[2] + 28}, {Win.Location[1] + 12 + Tab.Length + Win.TabMargin, Win.Location[2] + 48}, Lib.BackgroundColor)
        end
        
        dx9.DrawString({Win.Location[1] + 12 + Win.TabMargin, Win.Location[2] + 28}, Lib.FontColor, " "..Tab.Name)
        
        Win.Tabs[TabName].Boundary = {Win.Location[1] + 10 + Win.TabMargin, Win.Location[2] + 26, Win.Location[1] + 14 + Tab.Length + Win.TabMargin, Win.Location[2] + 50}
        Win.TabMargin = Win.TabMargin + Tab.Length + 4

        function Tab:AddGroupbox(name, side)
            local Groupbox = {
                Name = name; -- Static + [Changeable]
                Side = "Left"; -- Static + [Changeable]
                Vertical = 30; -- Dynamic
            };
            
            if side == 1 then 
                Groupbox.Side = "Left" 
            else 
                Groupbox.Side = "Right" 
            end

            Tab.Groupboxes[name] = Groupbox;
            return Groupbox;
        end

        --// Display Groupboxes
        if Win.CurrentTab ~= nil and Win.CurrentTab == Tab.Name then
            if Tab.Groupboxes ~= nil and Tab.Groupboxes ~= {} then
                local rightstack = 60
                local leftstack = 60
                for i,v in pairs(Tab.Groupboxes) do
                    if v.Side == "Left" then 
                        dx9.DrawFilledBox({Win.Location[1] + 20, Win.Location[2] + leftstack}, {Win.Location[1] + 270, Win.Location[2] + leftstack + v.Vertical}, Lib.Black)
                        if Win.Rainbow == true then 
                            dx9.DrawFilledBox({Win.Location[1] + 21, Win.Location[2] + leftstack + 1}, {Win.Location[1] + 269, Win.Location[2] + leftstack + 3}, Lib.CurrentRainbowColor)
                        else
                            dx9.DrawFilledBox({Win.Location[1] + 21, Win.Location[2] + leftstack + 1}, {Win.Location[1] + 269, Win.Location[2] + leftstack + 3}, Lib.AccentColor)
                        end
                        dx9.DrawFilledBox({Win.Location[1] + 21, Win.Location[2] + leftstack + 4}, {Win.Location[1] + 269, Win.Location[2] + leftstack + v.Vertical - 1}, Lib.BackgroundColor)

                        dx9.DrawString({Win.Location[1] + 21, Win.Location[2] + leftstack + 4}, Lib.FontColor, " "..v.Name)

                        leftstack = leftstack + v.Vertical + 10
                    else
                        dx9.DrawFilledBox({Win.Location[1] + 280, Win.Location[2] + rightstack}, {Win.Location[1] + 530, Win.Location[2] + rightstack + v.Vertical}, Lib.Black)
                        if Win.Rainbow == true then 
                            dx9.DrawFilledBox({Win.Location[1] + 281, Win.Location[2] + rightstack + 1}, {Win.Location[1] + 529, Win.Location[2] + rightstack + 3}, Lib.CurrentRainbowColor)
                        else
                            dx9.DrawFilledBox({Win.Location[1] + 281, Win.Location[2] + rightstack + 1}, {Win.Location[1] + 529, Win.Location[2] + rightstack + 3}, Lib.AccentColor)
                        end
                        dx9.DrawFilledBox({Win.Location[1] + 281, Win.Location[2] + rightstack + 4}, {Win.Location[1] + 529, Win.Location[2] + rightstack + v.Vertical - 1}, Lib.BackgroundColor)

                        dx9.DrawString({Win.Location[1] + 281, Win.Location[2] + rightstack + 4}, Lib.FontColor, " "..v.Name)

                        rightstack = rightstack + v.Vertical + 10
                    end
                end
            end
        end

        Win.Tabs[TabName] = Tab;
        return Tab;
    end

    --// Reset and Startup Insurance
    Win.TabMargin = 0
    if Win.Tabs[1] ~= nil and Win.TabSelected == nil then
        Win.TabSelected = Win.Tabs[1].Name
    end
    return(Win)
end




--// Rainbow Tick
do
    if Lib.RainbowHue >= 765 then
        Lib.RainbowHue = 0
    else
        Lib.RainbowHue = Lib.RainbowHue + 1
    end

    if Lib.RainbowHue <= 255 then
        Lib.CurrentRainbowColor = {255 - Lib.RainbowHue, Lib.RainbowHue, 0}
    elseif Lib.RainbowHue <= 510 then
        Lib.CurrentRainbowColor = {0, 510 - Lib.RainbowHue, Lib.RainbowHue - 255}
    else
        Lib.CurrentRainbowColor = {Lib.RainbowHue - 510, 0, 765 - Lib.RainbowHue}
    end
end

return Lib;
