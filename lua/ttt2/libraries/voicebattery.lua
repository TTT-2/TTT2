---
-- This is the voice battery module that handles everything related to
-- the voice drain caused by speaking.
-- @author Mineotopia
-- @module voicebattery

if SERVER then
    AddCSLuaFile()
end

---
-- @realm server
local cvVoiceDrain = CreateConVar(
    "ttt_voice_drain",
    "0",
    SERVER and { FCVAR_NOTIFY, FCVAR_ARCHIVE, FCVAR_REPLICATED } or FCVAR_REPLICATED
)

---
-- @realm server
local cvVoiceDrainNormal = CreateConVar(
    "ttt_voice_drain_normal",
    "0.2",
    SERVER and { FCVAR_NOTIFY, FCVAR_ARCHIVE, FCVAR_REPLICATED } or FCVAR_REPLICATED
)

---
-- @realm server
local cvVoiceDrainAdmin = CreateConVar(
    "ttt_voice_drain_admin",
    "0.05",
    SERVER and { FCVAR_NOTIFY, FCVAR_ARCHIVE, FCVAR_REPLICATED } or FCVAR_REPLICATED
)

---
-- @realm server
local cvVoiceDrainRecharge = CreateConVar(
    "ttt_voice_drain_recharge",
    "0.05",
    SERVER and { FCVAR_NOTIFY, FCVAR_ARCHIVE, FCVAR_REPLICATED } or FCVAR_REPLICATED
)

voicebattery = {}

voicebattery.maxCharge = 100
voicebattery.minCharge = 10

---
-- Returns true if the voice battery is enabled.
-- @return boolean Voice battery state
-- @realm shared
function voicebattery.IsEnabled()
    return cvVoiceDrain:GetBool()
end

if CLIENT then
    ---
    -- Initializes the voice battery.
    -- @realm client
    function voicebattery.InitBattery()
        voicebattery.SetCharge(voicebattery.maxCharge)
    end

    ---
    -- Returns the current charge of the voice battery.
    -- @return number The battery charge
    -- @realm client
    function voicebattery.GetCharge()
        return voicebattery.currentCharge or voicebattery.maxCharge
    end

    ---
    -- Sets the current charge of the voice battery.
    -- @param[default=0] number Charge The new battery charge
    -- @realm client
    function voicebattery.SetCharge(charge)
        voicebattery.currentCharge = charge or 0
    end

    ---
    -- Returns the current charge percentage of the voice battery.
    -- @return number The battery charge as a value from 0 to 1
    -- @realm client
    function voicebattery.GetChargePercent()
        return voicebattery.GetCharge() / voicebattery.maxCharge
    end

    ---
    -- Checks if the voice battery is charged enough to talk.
    -- @return boolean Returns true if the player can talk
    -- @realm client
    function voicebattery.IsCharged()
        return voicebattery.GetCharge() > voicebattery.minCharge
    end

    ---
    -- Returns the current voice drain recharge while not speaking.
    -- @return number The voice battery recharge rate
    -- @realm client
    function voicebattery.GetRechargeRate()
        local rate = cvVoiceDrainRecharge:GetFloat()

        if voicebattery.GetCharge() < voicebattery.minCharge then
            rate = rate * 0.5
        end

        return rate
    end

    ---
    -- Returns the current voice drain rate while speaking.
    -- @return number The voice battery drain rate
    -- @realm client
    function voicebattery.GetDrainRate()
        local client = LocalPlayer()

        if
            not IsValid(client)
            or client:IsSpec()
            or not voicebattery.IsEnabled()
            or GetRoundState() ~= ROUND_ACTIVE
        then
            return 0
        end

        local subRoleData = client:GetSubRoleData()

        if admin.IsAdmin(client) or (subRoleData.isPublicRole and subRoleData.isPolicingRole) then
            return cvVoiceDrainAdmin:GetFloat()
        else
            return cvVoiceDrainNormal:GetFloat()
        end
    end

    ---
    -- Updates the voice battery
    -- @note Called every @{GM:Tick}
    -- @realm client
    -- @internal
    function voicebattery.Tick()
        if not voicebattery.IsEnabled() then
            return
        end

        if VOICE.IsSpeaking() and not VOICE.IsRoleChatting(LocalPlayer()) then
            voicebattery.SetCharge(voicebattery.GetCharge() - voicebattery.GetDrainRate())

            if not VOICE.CanSpeak() then
                voicebattery.SetCharge(0)

                permissions.EnableVoiceChat(false)
            end
        elseif voicebattery.GetCharge() < voicebattery.maxCharge then
            voicebattery.SetCharge(
                math.min(
                    voicebattery.maxCharge,
                    voicebattery.GetCharge() + voicebattery.GetRechargeRate()
                )
            )
        end
    end
end
