---
-- @class ENT
-- @desc Map settings entity
-- @section MapSettings

ENT.Type = "point"
ENT.Base = "base_point"

---
-- @realm server
function ENT:Initialize()
    timer.Simple(0, function()
        self:TriggerOutput("MapSettingsSpawned", self)
    end)
end

---
-- Sets Hammer key values on an entity.
-- @param string key The internal key name
-- @param string value The value to set
-- @realm server
function ENT:KeyValue(key, value)
    if key == "cbar_doors" then
        Dev(2, "ttt_map_settings: crowbar door unlocking = " .. value)

        local opens = (value == "1")

        GAMEMODE.crowbar_unlocks[OPEN_DOOR] = opens
        GAMEMODE.crowbar_unlocks[OPEN_ROT] = opens
    elseif key == "cbar_buttons" then
        Dev(2, "ttt_map_settings: crowbar button unlocking = " .. value)

        GAMEMODE.crowbar_unlocks[OPEN_BUT] = (value == "1")
    elseif key == "cbar_other" then
        Dev(2, "ttt_map_settings: crowbar movelinear unlocking = " .. value)

        GAMEMODE.crowbar_unlocks[OPEN_NOTOGGLE] = (value == "1")
    elseif key == "plymodel" and value ~= "" then -- can ignore if empty
        if util.IsValidModel(value) then
            Dev(2, "ttt_map_settings: set player model to be " .. value)

            util.PrecacheModel(value)

            GAMEMODE.force_plymodel = value
        else
            Dev(2, "ttt_map_settings: FAILED to set player model due to invalid path: " .. value)
        end
    elseif key == "propspec_named" or key == "propspec_allow_named" then
        Dev(2, "ttt_map_settings: propspec possessing named props = " .. value)

        GAMEMODE.propspec_allow_named = (value == "1")
    elseif
        key == "MapSettingsSpawned"
        or key == "RoundEnd"
        or key == "RoundPreparation"
        or key == "RoundStart"
    then
        self:StoreOutput(key, value)
    end
end

---
-- Called when another entity fires an event to this entity.
-- @param string name The name of the input that was triggered
-- @param Entity activator The initial cause for the input getting triggered; e.g. the player who pushed a button
-- @param Entity caller The entity that directly triggered the input; e.g. the button that was pushed
-- @param string data The data passed
-- @realm server
function ENT:AcceptInput(name, activator, caller, data)
    if name == "SetPlayerModels" then
        local mdlname = tostring(data)

        if not mdlname then
            ErrorNoHalt("ttt_map_settings: Invalid parameter to SetPlayerModels input!\n")

            return false
        elseif not util.IsValidModel(mdlname) then
            ErrorNoHalt("ttt_map_settings: Invalid model given: " .. mdlname .. "\n")

            return false
        end

        Dev(2, "ttt_map_settings: input set player model to be " .. mdlname)

        GAMEMODE.force_plymodel = Model(mdlname)

        return true
    end
end

---
-- Fire an output when the round changes.
-- @param number roundState
-- @param any data
-- @realm server
function ENT:RoundStateTrigger(roundState, data)
    if roundState == ROUND_PREP then
        self:TriggerOutput("RoundPreparation", self)
    elseif roundState == ROUND_ACTIVE then
        self:TriggerOutput("RoundStart", self)
    elseif roundState == ROUND_POST then
        -- RoundEnd has the type of win condition as param
        self:TriggerOutput("RoundEnd", self, tostring(data))
    end
end
