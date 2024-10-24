---
---@class SPEED

SPEED = {}

---
-- Handles the speed calculation based on the @{GM:TTTPlayerSpeedModifier} hook
-- @param Player ply The player whose speed should be changed
-- @param CMoveData moveData The move data
-- @internal
-- @realm shared
function SPEED:HandleSpeedCalculation(ply, moveData)
    if not ply:IsTerror() then
        return
    end

    local baseMultiplier = 1
    local isSlowed = false

    -- Slow down ironsighters
    if ply:IsInIronsights() then
        baseMultiplier = 120 / 220
        isSlowed = true
    end

    local speedMultiplierModifier = { 1 }

    ---
    -- @realm shared
    local returnMultiplier = hook.Run(
        "TTTPlayerSpeedModifier",
        ply,
        isSlowed,
        moveData,
        speedMultiplierModifier
    ) or 1

    local oldval = ply:GetSpeedMultiplier()
    ply.speedModifier = baseMultiplier * returnMultiplier * speedMultiplierModifier[1]

    if SERVER then
        return
    end

    local newval = math.Round(ply.speedModifier, 1)

    if newval == 1.0 then
        STATUS:RemoveStatus("ttt_speed_status_good")
        STATUS:RemoveStatus("ttt_speed_status_bad")
    elseif newval > 1.0 and oldval <= 1.0 then
        STATUS:RemoveStatus("ttt_speed_status_bad")
        STATUS:AddStatus("ttt_speed_status_good")
    elseif newval < 1.0 and oldval >= 1.0 then
        STATUS:RemoveStatus("ttt_speed_status_good")
        STATUS:AddStatus("ttt_speed_status_bad")
    end
end

---
-- A hook to modify the player speed.
-- @note This hook is predicted and should be therefore added on both server and client.
-- @param Player ply The player whose speed should be modified
-- @param boolean isSlowed Is true if the player uses iron sights
-- @param CMoveData moveData The move data
-- @param table speedMultiplierModifier The speed modifier table. Modify the first table entry to change the player speed
-- @return[deprecated] number The deprecated way of changing the player speed
-- @hook
-- @realm shared
function GM:TTTPlayerSpeedModifier(ply, isSlowed, moveData, speedMultiplierModifier) end

if CLIENT then
    ---
    -- Initializes the speed system once the game is ready.
    -- It is called in @{GM:Initialize}.
    -- @realm client
    function SPEED:Initialize()
        STATUS:RegisterStatus("ttt_speed_status_good", {
            hud = {
                Material("vgui/ttt/perks/hud_speedrun.png"),
            },
            type = "good",
            DrawInfo = function()
                return math.Round(LocalPlayer():GetSpeedMultiplier(), 1)
            end,
            name = "status_speed_name",
            sidebarDescription = "status_speed_description_good",
        })

        STATUS:RegisterStatus("ttt_speed_status_bad", {
            hud = {
                Material("vgui/ttt/perks/hud_speedrun.png"),
            },
            type = "bad",
            DrawInfo = function()
                return math.Round(LocalPlayer():GetSpeedMultiplier(), 1)
            end,
            name = "status_speed_name",
            sidebarDescription = "status_speed_description_bad",
        })
    end
end

---
---@class Player
local plymeta = assert(FindMetaTable("Player"), "FAILED TO FIND ENTITY TABLE")

---
-- Returns the current player speed modifier
-- @return number The speed modifier
-- @realm shared
function plymeta:GetSpeedMultiplier()
    return self.speedModifier or 1.0
end
