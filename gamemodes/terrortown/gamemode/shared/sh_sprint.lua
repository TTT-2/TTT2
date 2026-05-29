---
---@class SPRINT
SPRINT = {
    -- Set up ConVars
    convars = {
        -- @realm shared
        enabled = CreateConVar(
            "ttt2_sprint_enabled",
            "1",
            { FCVAR_ARCHIVE, FCVAR_NOTIFY, FCVAR_REPLICATED },
            "Toggle Sprint (Def: 1)"
        ),
        -- @realm shared
        multiplier = CreateConVar(
            "ttt2_sprint_max",
            "0.5",
            { FCVAR_ARCHIVE, FCVAR_NOTIFY, FCVAR_REPLICATED },
            "The speed modifier the player will receive. Will be added on top of 1, so 0.5 => 1.5 speed. (Def: 0.5)"
        ),
        -- @realm shared
        consumption = CreateConVar(
            "ttt2_sprint_stamina_consumption",
            "0.6",
            { FCVAR_ARCHIVE, FCVAR_NOTIFY, FCVAR_REPLICATED },
            "The speed of the stamina consumption (per second; Def: 0.6)"
        ),
        -- @realm shared
        regeneration = CreateConVar(
            "ttt2_sprint_stamina_regeneration",
            "0.3",
            { FCVAR_ARCHIVE, FCVAR_NOTIFY, FCVAR_REPLICATED },
            "The regeneration time of the stamina (per second; Def: 0.3)"
        ),
        -- @realm shared
        cooldown = CreateConVar(
            "ttt2_sprint_stamina_cooldown",
            "0.8",
            { FCVAR_ARCHIVE, FCVAR_NOTIFY, FCVAR_REPLICATED },
            "Time before stamina begins regenerating after sprinting (in seconds; Def: 0.8)"
        ),
        -- @realm shared
        forwards_only = CreateConVar(
            "ttt2_sprint_forwards_only",
            "1",
            { FCVAR_ARCHIVE, FCVAR_NOTIFY, FCVAR_REPLICATED },
            "Disallow sprinting backwards or laterally (Def: 1)"
        ),
    },
}

---
-- Checks if the player is pressing any movement keys and the sprint key at the same time.
-- @param Player ply
-- @return boolean
-- @realm shared
function SPRINT:PlayerWantsToSprint(ply)
    local inSprint = ply:KeyDown(IN_SPEED)

    local inMovement

    if self.convars.forwards_only:GetBool() then
        inMovement = ply:KeyDown(IN_FORWARD) and not ply:KeyDown(IN_BACK)
    else
        inMovement = ply:KeyDown(IN_FORWARD)
            or ply:KeyDown(IN_BACK)
            or ply:KeyDown(IN_MOVERIGHT)
            or ply:KeyDown(IN_MOVELEFT)
    end

    return inSprint and inMovement
end

---
-- Checks if the player wants to sprint and actually can sprint.
-- @param Player ply
-- @return boolean
-- @realm shared
function SPRINT:IsSprinting(ply)
    return self.convars.enabled:GetBool()
        and self:PlayerWantsToSprint(ply)
        and ply:GetSprintStamina() > 0
        and not ply:IsInIronsights()
end

---
-- Calculates the new stamina values for a given player.
-- @param Player ply
-- @realm shared
function SPRINT:HandleStaminaCalculation(ply)
    local staminaRegeneratonRate = self.convars.regeneration:GetFloat()
    local staminaConsumptionRate = self.convars.consumption:GetFloat()
    local staminaCooldownTime = self.convars.cooldown:GetFloat()

    local sprintStamina = ply:GetSprintStamina()
    local playerWantsToSprint = self:PlayerWantsToSprint(ply) and not ply:IsInIronsights()

    if
        (sprintStamina == 1 and not playerWantsToSprint)
        or (sprintStamina == 0 and playerWantsToSprint)
    then
        return
    end

    -- Note: This is a table, because it is passed by reference and multiple addons can adjust the value.
    local rateModifier = { 1 }
    local newStamina = sprintStamina

    if playerWantsToSprint then
        ---
        -- @realm shared
        hook.Run("TTT2StaminaDrain", ply, rateModifier)

        newStamina =
            math.max(sprintStamina - FrameTime() * rateModifier[1] * staminaConsumptionRate, 0)

        if staminaCooldownTime > 0 then
            ply:SetSprintCooldownTime(CurTime() + staminaCooldownTime)
        end
    elseif staminaCooldownTime <= 0 or CurTime() > ply:GetSprintCooldownTime() then
        ---
        -- @realm shared
        hook.Run("TTT2StaminaRegen", ply, rateModifier)

        newStamina =
            math.min(sprintStamina + FrameTime() * rateModifier[1] * staminaRegeneratonRate, 1)
    end

    ply:SetSprintStamina(newStamina)
end

---
-- Calculates the sprint speed multiplier value for a given player.
-- @param Player ply
-- @realm shared
function SPRINT:HandleSpeedMultiplierCalculation(ply)
    if not self:IsSprinting(ply) then
        return 1
    end

    local sprintMultiplierModifier = { 1 }

    ---
    -- @realm shared
    hook.Run("TTT2PlayerSprintMultiplier", ply, sprintMultiplierModifier)

    return (1 + self.convars.multiplier:GetFloat()) * sprintMultiplierModifier[1]
end

---
-- A hook that is called once every frame/tick to modify the stamina regeneration.
-- @note This hook is predicted and should be therefore run on both server and client.
-- @param Player ply The player whose modifier should be set
-- @param table modifierTbl The table in which the modifier can be changed
-- @hook
-- @realm shared
function GM:TTT2StaminaRegen(ply, modifierTbl) end

---
-- A hook that is called once every frame/tick to modify the stamina drain.
-- @note This hook is predicted and should be therefore run on both server and client.
-- @param Player ply The player whose modifier should be set
-- @param table modifierTbl The table in which the modifier can be changed
-- @hook
-- @realm shared
function GM:TTT2StaminaDrain(ply, modifierTbl) end
