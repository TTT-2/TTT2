local plymeta = FindMetaTable("Player")
if not plymeta then
	Error("FAILED TO FIND PLAYER TABLE")

	return
end

ARMOR = {}


-- SET UP NETWORK STRINGS
util.AddNetworkString("ttt2_sync_armor")
util.AddNetworkString("ttt2_sync_armor_max")


-- SET UP CONVARS
ARMOR.cv = {}
ARMOR.cv.armor_on_spawn = CreateConVar("ttt_armor_on_spawn", 0, {FCVAR_NOTIFY, FCVAR_ARCHIVE})
ARMOR.cv.armor_is_reinforced_enabled = CreateConVar("ttt_armor_is_reinforced_enabled", 1, {FCVAR_NOTIFY, FCVAR_ARCHIVE})
ARMOR.cv.armor_threshold_for_reinforced = CreateConVar("ttt_armor_threshold_for_reinforced", 50, {FCVAR_NOTIFY, FCVAR_ARCHIVE})
ARMOR.cv.armor_damage_block_pct = CreateConVar("ttt_armor_damage_block_pct", 0.2, {FCVAR_NOTIFY, FCVAR_ARCHIVE})
ARMOR.cv.armor_damage_health_pct = CreateConVar("ttt_armor_damage_health_pct", 0.7, {FCVAR_NOTIFY, FCVAR_ARCHIVE})
ARMOR.cv.armor_classic = CreateConVar("ttt_armor_classic", 0, {FCVAR_NOTIFY, FCVAR_ARCHIVE})
ARMOR.cv.item_armor_value = CreateConVar("ttt_item_armor_value", 30, {FCVAR_NOTIFY, FCVAR_ARCHIVE})

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
-- Sets the @{ARMOR} to a specific value that is capped by the max armor value
-- @param number armor the new armor to be set
-- @realm server
function plymeta:SetArmorValue(armor)
	self.armor = math.Clamp(armor, 0, self:GetMaxArmor())
	self.armor_is_reinforced = ARMOR.cv.armor_is_reinforced_enabled:GetBool() and self:GetArmor() > ARMOR.cv.armor_threshold_for_reinforced:GetInt()

	net.Start("ttt2_sync_armor")
	net.WriteUInt(math.Round(self.armor), 16)
	net.WriteBool(self.armor_is_reinforced)
	net.Send(self)
end

---
-- Sets the max @{ARMOR} to a specific value
-- @param number armor_max the new max armor to be set
-- @realm server
function plymeta:SetMaxArmor(armor_max)
	self.armor_max = math.max(armor_max, 0)

	net.Start("ttt2_sync_armor_max")
	net.WriteUInt(math.Round(armor_max), 16)
	net.Send(self)
end

---
-- Sets the @{ARMOR} to a specific value while also increasing (if necessary) the max value
-- @param number armor the new armor to be set
-- @realm server
function plymeta:SetArmor(armor)
	if armor > self:GetMaxArmor() then
		self:SetMaxArmor(armor)
	end

	self:SetArmorValue(armor)
end

---
-- Increases the @{ARMOR} directly about a specific value
-- @param number increaseby the amount to be increased
-- @realm server
function plymeta:IncreaseArmor(increaseby)
	self:SetArmor(self:GetArmor() + math.max(increaseby, 0))
end

---
-- Decreases the @{ARMOR} directly about a specific value
-- @param number decreaseby the amount to be decreased
-- @realm server
function plymeta:DecreaseArmor(decreaseby)
	self:SetArmor(math.max(self:GetArmor() - math.max(decreaseby, 0), 0))
end

---
-- Decreases the @{ARMOR} about a scaled specific value depending on the current max value
-- @param number remove the amount to be decreased
-- @realm server
function plymeta:RemoveArmor(remove)
	if self:GetMaxArmor() == 0 then
		self:SetArmor(0)
	end

	local multiplier = self:GetArmor() / self:GetMaxArmor()

	self:DecreaseArmor(remove * multiplier)
end

---
-- Resets the @{ARMOR} value including the max value, called in @{GM:PlayerSpawn}
-- @realm server
function plymeta:ResetArmor()
	self:SetArmor(0)
end

---
-- Sets the initial @{Player} Armor, called in @{GM:TTTBeginRound}
-- @realm server
-- @internal
function ARMOR:InitPlayerArmor()
	for _, p in ipairs(player.GetAll()) do
		if p:IsTerror() then
			p:SetArmor(self.cv.armor_on_spawn:GetInt())
		end
	end
end

---
-- Handles the @{ARMOR} of a @{Player}, called by @{GM:PlayerTakeDamage}
-- @param Player ply The @{Player} taking damage
-- @param Entity infl The inflictor
-- @param Player|Entity att The attacker
-- @param number amount Amount of damage
-- @param CTakeDamageInfo dmginfo Damage info
-- @realm server
-- @internal
function ARMOR:HandlePlayerTakeDamage(ply, infl, att, amount, dmginfo)
	-- fallback for players who prefer the vanilla armor
	if self.cv.armor_classic:GetBool() and ply:GetArmor() > 0 then
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
	local armor = ply:GetArmor()

	-- normal damage handling when no armor is available
	if armor == 0 then return end

	self.cv.armor_factor = self.cv.armor_damage_block_pct:GetFloat()
	self.cv.health_factor = self.cv.armor_damage_health_pct:GetFloat()

	if ply:ArmorIsReinforced() then
		self.cv.health_factor = self.cv.health_factor - 0.15
	end

	ply:DecreaseArmor(self.cv.armor_factor * damage)

	local new_damage = self.cv.health_factor * damage - math.min(armor, 0)
	dmginfo:SetDamage(new_damage)
end
