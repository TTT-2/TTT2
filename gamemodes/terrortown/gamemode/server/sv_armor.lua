local plymeta = FindMetaTable("Player")
if not plymeta then
	Error("FAILED TO FIND PLAYER TABLE")

	return
end


-- SET UP NETWORK STRINGS
util.AddNetworkString("ttt2_sync_armor")
util.AddNetworkString("ttt2_sync_armor_max")


-- SET UP CONVARS
local cv_armor_on_spawn = CreateConVar('ttt_armor_on_spawn', 0, {FCVAR_NOTIFY, FCVAR_ARCHIVE})
local cv_armor_is_reinforced_enabled = CreateConVar('ttt_armor_is_reinforced_enabled', 1, {FCVAR_NOTIFY, FCVAR_ARCHIVE})
local cv_armor_threshold_for_reinforced = CreateConVar('ttt_armor_threshold_for_reinforced', 50, {FCVAR_NOTIFY, FCVAR_ARCHIVE})
local cv_armor_damage_block_pct = CreateConVar('ttt_armor_damage_block_pct', 0.2, {FCVAR_NOTIFY, FCVAR_ARCHIVE})
local cv_armor_damage_health_pct = CreateConVar('ttt_armor_damage_health_pct', 0.7, {FCVAR_NOTIFY, FCVAR_ARCHIVE})
local cv_armor_classic = CreateConVar('ttt_armor_classic', 0, {FCVAR_NOTIFY, FCVAR_ARCHIVE})
local cv_item_armor_value = CreateConVar('ttt_item_armor_value', 30, {FCVAR_NOTIFY, FCVAR_ARCHIVE})

cvars.AddChangeCallback("ttt_armor_classic", function(cv, old, new)
    SetGlobalBool("ttt_armor_classic", tobool(tonumber(new)))
end)
cvars.AddChangeCallback("ttt_armor_is_reinforced_enabled", function(cv, old, new)
    SetGlobalBool("ttt_armor_is_reinforced_enabled", tobool(tonumber(new)))
end)
cvars.AddChangeCallback("ttt_armor_threshold_for_reinforced", function(cv, old, new)
    SetGlobalInt("ttt_armor_threshold_for_reinforced", tonumber(new))
end)


-- SERVERSIDE ARMOR FUNCTIONS
---
-- Sets the armor to a specific value
-- @param number armor the new armor to be set
-- @realm server
function plymeta:SetArmor(armor)
    self.armor = armor
    self.armor_is_reinforced = cv_armor_is_reinforced_enabled:GetBool() and self:Armor() > cv_armor_threshold_for_reinforced:GetInt()

    net.Start("ttt2_sync_armor")
    net.WriteUInt(math.Round(self.armor), 16)
    net.WriteBool(self.armor_is_reinforced)
    net.Send(self)
end

---
-- Sets the max armor to a specific value
-- @param number armor_max the new max armor to be set
-- @realm server
function plymeta:SetMaxArmor(armor_max)
    self.armor_max = armor_max

    net.Start("ttt2_sync_armor_max")
    net.WriteUInt(math.Round(armor_max), 16)
    net.Send(self)
end

---
-- Increases the armor about a specific value
-- @param number increaseby the amount to be increased
-- @realm server
function plymeta:IncreaseArmor(increaseby)
    self:SetArmor(self:Armor() + math.max(increaseby, 0))
end

---
-- Decreases the armor about a specific value
-- @param number decreaseby the amount to be decreased
-- @realm server
function plymeta:DecreaseArmor(decreaseby)
    self:SetArmor(math.max(self:Armor() - math.max(decreaseby, 0), 0))
end

---
-- Resets the armor value
-- @realm server
function plymeta:ResetArmor()
    self:SetArmor(0)
end

---
-- Handles the armor of a @{Player}, called by @{GM:PlayerTakeDamage}
-- @param Entity ent The @{Entity} taking damage
-- @param Entity infl the inflictor
-- @param Player|Entity att the attacker
-- @param number amount amount of damage
-- @param CTakeDamageInfo dmginfo Damage info
-- @realm server
-- @internal
function HandlePlayerArmorSystem(ply, infl, att, amount, dmginfo)
	-- some entities cause this hook to be triggered, ignore 0 damage events
	if dmginfo:GetDamage() <= 0 then return end

	-- fallback for players who prefer the vanilla armor
    if cv_armor_classic:GetBool() and ply:Armor() > 0 then
        -- classic armor only shields from bullet/crowbar damage
        if dmginfo:IsDamageType(DMG_BULLET) or dmginfo:IsDamageType(DMG_CLUB) then
            dmginfo:ScaleDamage(0.7)
        end
		
		return
	end

	-- handle different damage type factors, only these four damage types are valid
	if not dmginfo:IsDamageType(DMG_BULLET) and not dmginfo:IsDamageType(DMG_CLUB)
		and not dmginfo:IsDamageType(DMG_BURN) and not dmginfo:IsDamageType(DMG_BLAST)
	then return end

	-- calculate damage
	local damage = dmginfo:GetDamage()
	local armor = ply:Armor()

	-- normal damage handling when no armor is available
	if armor == 0 then return end

	local cv_armor_factor = cv_armor_damage_block_pct:GetFloat()
	local cv_health_factor = cv_armor_damage_health_pct:GetFloat()
	
	if ply:ArmorIsReinforced() then
		cv_health_factor = cv_health_factor - 0.15
	end

	armor = armor - cv_armor_factor * damage
	ply:SetArmor(math.max(armor, 0))
	
	local new_damage = cv_health_factor * damage - math.min(armor, 0)
	dmginfo:SetDamage(new_damage)
end

hook.Add("TTTBeginRound", "ttt2_player_set_armor_beginround", function(ply)
    for _, p in ipairs(player.GetAll()) do
        if p:IsTerror() then 
            p:SetArmor(cv_armor_on_spawn:GetInt())
        end
    end
end)