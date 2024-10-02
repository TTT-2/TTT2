---
-- A module that contains all functions related to playermodels
-- @author Mineotopia

if SERVER then
    AddCSLuaFile()
end

local pairs = pairs
local playerManagerAllValidModels = player_manager.AllValidModels
local playerManagerTranslateToPlayerModelName = player_manager.TranslateToPlayerModelName
local utilPrecacheModel = util.PrecacheModel
local mathRandom = math.random

local function GetPlayerSize(ply)
    local bottom, top = ply:GetHull()

    return top - bottom
end

---
-- @realm server
local cvCustomModels = CreateConVar("ttt2_use_custom_models", "0", { FCVAR_NOTIFY, FCVAR_ARCHIVE })

local initialDefaultStates = {
    selected = {
        ["css_phoenix"] = true,
        ["css_arctic"] = true,
        ["css_guerilla"] = true,
        ["css_leet"] = true,
    },
    hattable = {
        ["css_phoenix"] = true,
        ["css_arctic"] = true,
        ["monk"] = true,
        ["female01"] = true,
        ["female02"] = true,
        ["female03"] = true,
        ["female04"] = true,
        ["female05"] = true,
        ["female06"] = true,
        ["male01"] = true,
        ["male02"] = true,
        ["male03"] = true,
        ["male04"] = true,
        ["male05"] = true,
        ["male06"] = true,
        ["male07"] = true,
        ["male08"] = true,
        ["male09"] = true,
    },
}

playermodels = playermodels or {}

playermodels.accessName = "Playermodels"
playermodels.sqltable = "ttt2_playermodel_pool_changes"
playermodels.savingKeys = {
    selected = { typ = "bool", default = false },
    hattable = { typ = "bool", default = false },
}
playermodels.accessLevel = TTT2_DATABASE_ACCESS_ANY

playermodels.fallbackModel = "models/player/phoenix.mdl"

playermodels.hasHeadHitBox = {}

-- Enums for the states
playermodels.state = {
    selected = "selected",
    hattable = "hattable",
}

---
-- Updates the given value state of a provided playermodel.
-- @param string name The name of the model
-- @param string valueName The name of the variable to change. See `playermodels.state` for listed names
-- @param boolean state The selection state, `true` to enable the model
-- @realm shared
function playermodels.UpdateModel(name, valueName, state)
    database.SetValue(playermodels.accessName, name, valueName, state)
end

---
-- Checks if a provided model is in the selection pool.
-- @warning As client you must give an OnReceiveFunction as data might be gathered from the server first
-- @param string name The name of the model
-- @param[opt] function OnReceiveFunc(value) only for the client the function to be called with the returned value if the model is selectable
-- @return[opt] boolean Returns true, if the model is in the selection pool on the server only
-- @realm shared
function playermodels.IsSelectedModel(name, OnReceiveFunc)
    local _, isSelected = database.GetValue(
        playermodels.accessName,
        name,
        "selected",
        function(databaseExists, value)
            OnReceiveFunc(value)
        end
    )

    if SERVER then
        return isSelected
    end
end

---
-- Checks if a provided model is hattable.
-- @warning As client you must give an OnReceiveFunction as data might be gathered from the server first
-- @param string name The name of the model
-- @param[opt] function OnReceiveFunc(value) only for the client  the function to be called with the returned value if the model is hattable
-- @return[opt] boolean Returns true, if the model is hattable on the server only
-- @realm shared
function playermodels.IsHattableModel(name, OnReceiveFunc)
    local _, isHattable = database.GetValue(
        playermodels.accessName,
        name,
        "hattable",
        function(databaseExists, value)
            OnReceiveFunc(value)
        end
    )

    if SERVER then
        return isHattable
    end
end

---
-- Checks if a provided model has a head hitbox
-- @param string name The name of the model
-- @return boolean Returns true, if the model has a head hitbox
-- @realm shared
function playermodels.HasHeadHitBox(name)
    return ttt2net.Get({ "playermodels", "hasHeadHitBox" })[name]
end

---
-- Add a change callback to a model and a key that is called when the state of the model changes
-- @param string modelName The name of the model
-- @param string valueName The name of the variable that changes. See `playermodels.state` for listed names
-- @param function callback The callback function(newValue) that is called with the newValue, when the value changes
-- @param string identifier A chosen identifier to be able to remove the callback
-- @realm shared
function playermodels.AddChangeCallback(modelName, valueName, callback, identifier)
    database.AddChangeCallback(
        playermodels.accessName,
        modelName,
        valueName,
        function(accessName, itemName, key, oldValue, newValue)
            callback(newValue)
        end,
        identifier
    )
end

---
-- Remove a change callback of a model and a key
-- @param string modelName The name of the model
-- @param string valueName The name of the variable that changes. See `playermodels.state` for listed names
-- @param string identifier The chosen identifier to remove the callback
-- @realm shared
function playermodels.RemoveChangeCallback(modelName, valueName, identifier)
    database.RemoveChangeCallback(playermodels.accessName, modelName, valueName, identifier)
end

---
-- Reset all selected playermodels, hattability and reinitialize the database.
-- @realm shared
function playermodels.Reset()
    database.Reset(playermodels.accessName)
end

---
-- Server only functions from here on
if CLIENT then
    return
end

---
-- Returns an indexed table with all the models that are in the selection pool.
-- @return table An indexed table with all selected player models
-- @realm server
function playermodels.GetSelectedModels()
    local playerModelPoolNames = {}

    for name in pairs(playerManagerAllValidModels()) do
        if playermodels.IsSelectedModel(name) then
            playerModelPoolNames[#playerModelPoolNames + 1] = name
        end
    end

    return playerModelPoolNames
end

---
-- Initializes the modelstates. This adds all models and sets the default models to true, if it
-- is the first init on this server.
-- @internal
-- @realm server
function playermodels.Initialize()
    if
        not database.Register(
            playermodels.sqltable,
            playermodels.accessName,
            playermodels.savingKeys,
            playermodels.accessLevel
        )
    then
        return false
    end

    for name in pairs(playerManagerAllValidModels()) do
        for key, defaultStates in pairs(initialDefaultStates) do
            local state = defaultStates[name]

            if state ~= nil then
                database.SetDefaultValue(playermodels.accessName, name, key, state)
            end
        end
    end

    playermodels.InitializeHeadHitBoxes()

    return true
end

---
-- Tests each model for headshot hitboxes by applying it to a testing entity and then
-- checking all its bones.
-- @note Do not use before @{GM:InitPostEntity} has been called, otherwise the server will crash!
-- @realm server
function playermodels.InitializeHeadHitBoxes()
    local testingEnt = ents.Create("ttt_model_tester")

    for name, model in pairs(playerManagerAllValidModels()) do
        testingEnt:SetModel(model)

        for i = 1, testingEnt:GetHitBoxCount(0) do
            if testingEnt:GetHitBoxHitGroup(i - 1, 0) == HITGROUP_HEAD then
                playermodels.hasHeadHitBox[name] = true

                break
            end

            playermodels.hasHeadHitBox[name] = false
        end
    end

    ttt2net.Set({ "playermodels", "hasHeadHitBox" }, { type = "table" }, playermodels.hasHeadHitBox)

    testingEnt:Remove()
end

---
-- Precaches all valid playermodels to make sure that rendering the model can be done
-- without an initial lag. This is especially important for menus where multiple
-- models are rendered.
-- @internal
-- @realm server
function playermodels.PrecacheModels()
    for _, model in pairs(playerManagerAllValidModels()) do
        utilPrecacheModel(model)
    end
end

---
-- Selects a random playermodel from the available list of existing playermodels
-- @return Model model The selected playermodel
-- @realm server
function playermodels.GetRandomPlayerModel()
    local availableModels = playermodels.GetSelectedModels()
    local sizeAvailableModels = #availableModels

    if cvCustomModels:GetBool() and sizeAvailableModels > 0 then
        local modelPaths = playerManagerAllValidModels()
        local randomModel = availableModels[mathRandom(sizeAvailableModels)]

        return Model(modelPaths[randomModel])
    else
        return Model(playermodels.fallbackModel)
    end
end

---
-- Finds the location and angle of the hat.
-- @param Player ply The player whose hat position should be found
-- @return Vector pos The location of the attach point.
-- @return Angle ang The angle of the attach point.
-- @realm shared
function playermodels.GetHatPosition(ply)
    local pos, ang
    if IsValid(ply) then
        local bone = ply:LookupBone("ValveBiped.Bip01_Head1")
        if bone then
            pos, ang = ply:GetBonePosition(bone)
        else
            pos, ang = ply:GetPos(), ply:GetAngles()
            pos.z = pos.z + GetPlayerSize(ply).z
        end
    end

    return pos, ang
end

---
-- Applies a detective hat to the provided player. Doesn't check if the player's model
-- allows a hat. Use the Filter function for this.
-- @param Player ply The player that should receive the hat
-- @param[opt] function Filter The filter function that has to return true to apply a hat
-- @param[opt] string hatName The class name of the hat entity, if different from the detective's hat.
-- @realm server
function playermodels.ApplyPlayerHat(ply, Filter, hatName)
    if IsValid(ply.hat) or (isfunction(Filter) and not Filter(ply)) then
        return
    end

    local hat = ents.Create(hatName or "ttt_hat_deerstalker")

    if not IsValid(hat) then
        return
    end

    local pos, ang = playermodels.GetHatPosition(ply)
    hat:SetPos(pos)
    hat:SetAngles(ang)
    hat:SetParent(ply)

    if isfunction(hat.EquipTo) then
        hat:EquipTo(ply)
    end
    ply.hat = hat

    hat:Spawn()
end

---
-- Removes the detective hat from the player.
-- @param Player ply The player whose hat should be removed
-- @realm server
function playermodels.RemovePlayerHat(ply)
    if not IsValid(ply.hat) then
        return
    end

    SafeRemoveEntity(ply.hat)

    ply.hat = nil
end

---
-- Checks whether a playermodel can have a hat.
-- @param Player ply The players whose model should be checked
-- @return boolean Returns true if the player's model can have a detective hat
-- @realm server
function playermodels.PlayerCanHaveHat(ply)
    return playermodels.IsHattableModel(playerManagerTranslateToPlayerModelName(ply:GetModel()))
end
