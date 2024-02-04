---
-- @class Player

local plymeta = FindMetaTable("Player")
if not plymeta then
    ErrorNoHaltWithStack("FAILED TO FIND PLAYER TABLE")

    return
end

---
-- Returns the current armor
-- @return[default=0] number armor
-- @realm shared
function plymeta:GetArmor()
    return self.armor or 0
end

---
-- Returns the current max armor
-- @return[default=100] number max armor
-- @realm shared
function plymeta:GetMaxArmor()
    return self.armor_max or 0
end

---
-- Returns whether the armor is reinforced
-- @return boolean is armor reinforced
-- @realm shared
function plymeta:ArmorIsReinforced()
    return GetGlobalBool("ttt_armor_enable_reinforced", false)
        and self:GetArmor() > GetGlobalInt("ttt_armor_threshold_for_reinforced", 0)
end
