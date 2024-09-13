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
        for i = 1, #validButtons do
            local classButton = validButtons[i]
            local buttonsTable = ents.FindByClass(classButton)

            for j = 1, #buttonsTable do
                local foundButton = buttonsTable[j]

                foundButton:SetNotSolid(false)
                foundButton:SetSolid(SOLID_BSP)

                foundButton:SetNWInt("button_class", i)
            end
        end
    end
end

function button.IsClass(ent, class)
    local classID = ent:GetNWInt("button_class")

    if not classID or classID > #validButtons then
        return
    end

    return validButtons[classID] == class
end
