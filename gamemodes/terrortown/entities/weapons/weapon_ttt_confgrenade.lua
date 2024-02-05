if SERVER then
    AddCSLuaFile()
end

SWEP.HoldType = "grenade"

if CLIENT then
    SWEP.PrintName = "confgrenade_name"
    SWEP.Slot = 3

    SWEP.ViewModelFlip = false
    SWEP.ViewModelFOV = 54

    SWEP.Icon = "vgui/ttt/icon_confgrenade"
    SWEP.IconLetter = "h"
end

SWEP.Base = "weapon_tttbasegrenade"

SWEP.WeaponID = AMMO_DISCOMB
SWEP.builtin = true
SWEP.Kind = WEAPON_NADE
SWEP.spawnType = WEAPON_TYPE_NADE

SWEP.Spawnable = true
SWEP.AutoSpawnable = true

SWEP.UseHands = true
SWEP.ViewModel = "models/weapons/cstrike/c_eq_fraggrenade.mdl"
SWEP.WorldModel = "models/weapons/w_eq_fraggrenade.mdl"

SWEP.Weight = 5

---
-- really the only difference between grenade weapons: the model and the thrown ent.
-- @ignore
function SWEP:GetGrenadeName()
    return "ttt_confgrenade_proj"
end

if CLIENT then
    ---
    -- @ignore
    function SWEP:AddToSettingsMenu(parent)
        local form = vgui.CreateTTT2Form(parent, "header_equipment_additional")

        form:MakeCheckBox({
            serverConvar = "ttt_allow_discomb_jump",
            label = "label_allow_discomb_jump",
        })
    end
end
