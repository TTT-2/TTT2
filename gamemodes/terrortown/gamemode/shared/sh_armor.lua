local plymeta = FindMetaTable("Player")
if not plymeta then
	Error("FAILED TO FIND PLAYER TABLE")

	return
end


-- SHARED ARMOR FUNCTIONS
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
-- Returns wether the armor is reinforced
-- @return boolean is armor reinforced
-- @realm shared
function plymeta:ArmorIsReinforced()
	return self.armor_is_reinforced or false
end
