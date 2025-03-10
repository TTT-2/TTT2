---
-- A bunch of functions that handle all buttons found on a map
-- @author Mineotopia
-- @module button

if SERVER then
    AddCSLuaFile()
end

button = {}

local validButtons = {
    "func_button",
    "func_rot_button",
}

if SERVER then
    ---
    -- Setting up all buttons found on a map, this is done on every map reset (on prepare round).
    -- @internal
    -- @realm server
    function button.SetUp()
        local buttonList = {}

        for i = 1, #validButtons do
            local classButton = validButtons[i]
            local buttonsTable = ents.FindByClass(classButton)

            buttonList[classButton] = buttonsTable

            for j = 1, #buttonsTable do
                local foundButton = buttonsTable[j]

                foundButton:SetNW2Int("button_class", i)
            end
        end

        ---
        -- @realm server
        hook.Run("TTT2PostButtonInitialization", buttonList)
    end

    ---
    -- Hook that is called after all buttons were initialized on the map. This happens after
    -- a map cleanup when a new round starts or when the list is rebuilt after a hotreload.
    -- @param table buttonList A table with all buttons found on the map
    -- @hook
    -- @realm server
    function GM:TTT2PostButtonInitialization(buttonList) end
end

---
-- Checks if a given button entity has the provided class.
-- @note This is checked like this, because buttons and levers
-- lose their specific class name on the client and therefore use custom
-- syncing here.
-- @param Entity ent The button entity that should be checked
-- @param string class The class name
-- @return boolean Returns true if the entity matches the provided class name
-- @realm shared
function button.IsClass(ent, class)
    local classID = ent:GetNW2Int("button_class")

    if not classID or classID > #validButtons then
        return
    end

    return validButtons[classID] == class
end
