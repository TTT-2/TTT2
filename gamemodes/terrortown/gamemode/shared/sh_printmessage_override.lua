---
-- Overwrites of the default PrintMessage function.
-- This overwrite fixes some limitations with the default system (usage of
-- archaic <a href="https://wiki.facepunch.com/gmod/umsg">umsg</a> system) while
-- also moving `HUD_PRINTCENTER` to the EPOP system.
-- @author Mineotopia
-- @section PrintMessage

local plymeta = assert(FindMetaTable("Player"), "FAILED TO FIND PLAYER TABLE")

if SERVER then
    ---
    -- Displays a message in the chat, console, or center of screen of every player / the defined players.
    -- @param number type Which type of message should be sent to the players (see <a href="https://wiki.facepunch.com/gmod/Enums/HUD">Enums/HUD</a>)
    -- @param string message Message to be sent to the players
    -- @param table|Player A table of players or a single player to receive the message, is broadcasted if set to nil
    -- @realm server
    function PrintMessage(type, message, plys)
        if type == HUD_PRINTNOTIFY or type == HUD_PRINTCONSOLE then
            LANG.Msg(plys, message, nil, MSG_CONSOLE)
        elseif type == HUD_PRINTTALK then
            LANG.Msg(plys, message, nil, MSG_CHAT_PLAIN)
        elseif type == HUD_PRINTCENTER then
            EPOP:AddMessage(plys, message, nil, 6, true)
        end
    end
else -- CLIENT
    ---
    -- Displays a message in the chat, console, or center of screen of the local player.
    -- @param number type Which type of message should be sent to the players (see <a href="https://wiki.facepunch.com/gmod/Enums/HUD">Enums/HUD</a>)
    -- @param string message Message to be sent to the players
    -- @realm client
    function PrintMessage(type, message)
        if type == HUD_PRINTNOTIFY or type == HUD_PRINTCONSOLE then
            LANG.Msg(message, nil, MSG_CONSOLE)
        elseif type == HUD_PRINTTALK then
            LANG.Msg(message, nil, MSG_CHAT_PLAIN)
        elseif type == HUD_PRINTCENTER then
            EPOP:AddMessage(message, nil, 6, nil, true)
        end
    end
end

---
-- @class Player

---
-- Displays a message either in their chat, console, or center of the screen.
-- @param number type The type of the message that should be displayed on then screen of the player (see <a href="https://wiki.facepunch.com/gmod/Enums/HUD">Enums/HUD</a>)
-- @param string message Message to be displayed on the screen on the player
-- @realm shared
function plymeta:PrintMessage(type, message)
    PrintMessage(type, message, self)
end
