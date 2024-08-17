---
-- A bunch of functions that handle all buttons found on a map
-- @author Mineotopia
-- @module button

if SERVER then
    AddCSLuaFile()
end

button = {}

local validButtons = {
    "func_rot_button",
}

local function UpdateStates(foundButtons)
    for class, list in pairs(foundButtons) do
        for i = 1, #list do
            local ent = list[i]

            if not IsValid(ent) then
                continue
            end

            if class == "func_rot_button" then
                ent:SetRotatingButton(true)
            end

            ent:SetNotSolid(false)

            if SERVER then
                entityOutputs.RegisterMapEntityOutput(ent, "OnOut", "TTT2TestHook")
                entityOutputs.RegisterMapEntityOutput(ent, "OnIn", "TTT2TestHook2")
            end
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

        print("found buttons on server")
        PrintTable(foundButtons)

        -- sync to client and set state
        UpdateStates(foundButtons)
        net.SendStream("TTT2SyncButtonEntities", foundButtons)
    end

    function button.SyncToClient(ply)
        net.SendStream("TTT2SyncButtonEntities", foundButtons, ply)
    end

    function GM:TTT2TestHook(doorEntity, activator)
        print("OnOut Triggered", doorEntity, activator)
    end
    function GM:TTT2TestHook2(doorEntity, activator)
        print("OnIn Triggered", doorEntity, activator)
    end
end

if CLIENT then
    net.ReceiveStream("TTT2SyncButtonEntities", function(foundButtons)
        print("received found button stream")
        PrintTable(foundButtons)

        UpdateStates(foundButtons)
    end)
end
