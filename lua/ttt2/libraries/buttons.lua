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

local function UpdateStates(foundButtons)
    for class, list in pairs(foundButtons) do
        for i = 1, #list do
            local ent = list[i]

            if not IsValid(ent) then
                continue
            end

            if class == "func_button" then
                ent:SetDefaultButton(true)
            end

            if class == "func_rot_button" then
                ent:SetRotatingButton(true)
            end

            ent:SetNotSolid(false)
        end
    end
end

if SERVER then
    local foundButtons = {}

    function button.SetUp()
        for i = 1, #validButtons do
            local classButton = validButtons[i]

            foundButtons[classButton] = ents.FindByClass(classButton)
        end

        -- sync to client and set state
        UpdateStates(foundButtons)
        net.SendStream("TTT2SyncButtonEntities", foundButtons)
    end

    function button.SyncToClient(ply)
        net.SendStream("TTT2SyncButtonEntities", foundButtons, ply)
    end
end

if CLIENT then
    net.ReceiveStream("TTT2SyncButtonEntities", function(foundButtons)
        UpdateStates(foundButtons)
    end)
end
