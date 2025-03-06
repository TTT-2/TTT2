---
-- @class ARMOR

local plymeta = FindMetaTable("Player")
if not plymeta then
    ErrorNoHaltWithStack("FAILED TO FIND PLAYER TABLE")

    return
end

ARMOR = {}

-- SET UP NETWORK STRINGS
util.AddNetworkString("ttt2_sync_armor")
util.AddNetworkString("ttt2_sync_armor_max")

-- SET UP CONVARS
ARMOR.cv = {
    ---
    -- @realm server
    armor_on_spawn = CreateConVar("ttt_armor_on_spawn", 0, { FCVAR_NOTIFY, FCVAR_ARCHIVE }),

    ---
    -- @realm server
    armor_enable_reinforced = CreateConVar(
        "ttt_armor_enable_reinforced",
        1,
        { FCVAR_NOTIFY, FCVAR_ARCHIVE }
    ),

    ---
    -- @realm server
    armor_threshold_for_reinforced = CreateConVar(
        "ttt_armor_threshold_for_reinforced",
        50,
        { FCVAR_NOTIFY, FCVAR_ARCHIVE }
    ),

    ---
    -- @realm server
    armor_damage_block_pct = CreateConVar(
        "ttt_armor_damage_block_pct",
        0.2,
        { FCVAR_NOTIFY, FCVAR_ARCHIVE }
    ),

    ---
    -- @realm server
    armor_damage_health_pct = CreateConVar(
        "ttt_armor_damage_health_pct",
        0.7,
        { FCVAR_NOTIFY, FCVAR_ARCHIVE }
    ),

    ---
    -- @realm server
    armor_dynamic = CreateConVar("ttt_armor_dynamic", 1, { FCVAR_NOTIFY, FCVAR_ARCHIVE }),

    ---
    -- @realm server
    item_armor_value = CreateConVar("ttt_item_armor_value", 30, { FCVAR_NOTIFY, FCVAR_ARCHIVE }),

    ---
    -- @realm server
    item_armor_block_headshots = CreateConVar(
        "ttt_item_armor_block_headshots",
        1,
        { FCVAR_NOTIFY, FCVAR_ARCHIVE }
    ),

    ---
    -- @realm server
    item_armor_block_blastdmg = CreateConVar(
        "ttt_item_armor_block_blastdmg",
        0,
        { FCVAR_NOTIFY, FCVAR_ARCHIVE }
    ),

    ---
    -- @realm server
    item_armor_block_clubdmg = CreateConVar(
        "ttt_item_armor_block_clubdmg",
        0,
        { FCVAR_NOTIFY, FCVAR_ARCHIVE }
    ),
}

hook.Add("TTT2SyncGlobals", "AddArmorGlobals", function()
    SetGlobalBool(ARMOR.cv.armor_dynamic:GetName(), ARMOR.cv.armor_dynamic:GetBool())
    SetGlobalBool(
        ARMOR.cv.armor_enable_reinforced:GetName(),
        ARMOR.cv.armor_enable_reinforced:GetBool()
    )
    SetGlobalBool(
        ARMOR.cv.armor_threshold_for_reinforced:GetName(),
        ARMOR.cv.armor_threshold_for_reinforced:GetInt()
    )
end)

cvars.AddChangeCallback(ARMOR.cv.armor_dynamic:GetName(), function(cv, old, new)
    SetGlobalBool(ARMOR.cv.armor_dynamic:GetName(), tobool(tonumber(new)))
end)

cvars.AddChangeCallback(ARMOR.cv.armor_enable_reinforced:GetName(), function(cv, old, new)
    SetGlobalBool(ARMOR.cv.armor_enable_reinforced:GetName(), tobool(tonumber(new)))
end)

cvars.AddChangeCallback(ARMOR.cv.armor_threshold_for_reinforced:GetName(), function(cv, old, new)
    SetGlobalInt(ARMOR.cv.armor_threshold_for_reinforced:GetName(), tonumber(new))
end)

-- SERVERSIDE ARMOR FUNCTIONS

---
-- Sets the initial @{Player} Armor, called in @{GM:TTTBeginRound} after (dumb) players
-- are respawned. Therefore no armor has to be reset and it is safe that the player
-- receives their armor.
-- @realm server
-- @internal
function ARMOR:InitPlayerArmor()
    local plys = player.GetAll()

    for i = 1, #plys do
        local ply = plys[i]

        if not ply:IsTerror() then
            continue
        end

        ply:GiveArmor(self.cv.armor_on_spawn:GetInt())
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
    local armor = ply:GetArmor()

    -- normal damage handling when no armor is available
    if armor == 0 then
        return
    end

    -- handle if headshots should be ignored by the armor
    if ply:LastHitGroup() == HITGROUP_HEAD and not self.cv.item_armor_block_headshots:GetBool() then
        return
    end

    -- handle different damage type factors, only these four damage types are valid
    if
        not dmginfo:IsDamageType(DMG_BULLET)
        and not dmginfo:IsDamageType(DMG_CLUB)
        and not dmginfo:IsDamageType(DMG_BURN)
        and not dmginfo:IsDamageType(DMG_BLAST)
    then
        return
    end

    -- handle if blast damage should be ignored by the armor
    if dmginfo:IsDamageType(DMG_BLAST) and not self.cv.item_armor_block_blastdmg:GetBool() then
        return
    end

    -- handle if crowbar damage should be ignored by the armor
    if dmginfo:IsDamageType(DMG_CLUB) and not self.cv.item_armor_block_clubdmg:GetBool() then
        return
    end

    -- fallback for players who prefer the vanilla armor
    if not self.cv.armor_dynamic:GetBool() then
        -- classic armor only shields from bullet damage
        if dmginfo:IsDamageType(DMG_BULLET) then
            dmginfo:ScaleDamage(0.7)
        end

        return
    end

    -- calculate damage
    local damage = dmginfo:GetDamage()

    self.cv.armor_factor = self.cv.armor_damage_block_pct:GetFloat()
    self.cv.health_factor = self.cv.armor_damage_health_pct:GetFloat()

    if ply:ArmorIsReinforced() then
        self.cv.health_factor = self.cv.health_factor - 0.15
    end

    local armorDamage = self.cv.armor_factor * damage

    ply:DecreaseArmorValue(armorDamage)

    -- Describes the maximum amount of damage that our current armor can endure.
    -- This might exceed the actual damage, so we need to limit this.
    local damageReduced = math.min(damage, armor / self.cv.armor_factor)

    dmginfo:SetDamage(damageReduced * self.cv.health_factor + damage - damageReduced)
end

---
-- Handles the @{ARMOR} of a @{Player}, called by @{GM:PlayerTakeDamage}
-- @param Player ply The @{Player} taking damage
-- @param Entity infl The inflictor
-- @param Player|Entity att The attacker
-- @param number amount Amount of damage
-- @param CTakeDamageInfo dmginfo Damage info
-- @realm server
-- @hook
function GM:TTT2ArmorHandlePlayerTakeDamage(ply, infl, att, amount, dmginfo)
    return ARMOR:HandlePlayerTakeDamage(ply, infl, att, amount, dmginfo)
end

---
-- @class Player

---
-- Sets the @{ARMOR} to a specific value that is capped by the maximum armor value.
-- @param number armor The new armor to be set
-- @realm server
function plymeta:SetArmor(armor)
    self.armor = math.Clamp(math.Round(armor), 0, self:GetMaxArmor())

    net.Start("ttt2_sync_armor")
    net.WriteUInt(self.armor, 16)
    net.Send(self)
end

---
-- Sets the max @{ARMOR} value to a specific value.
-- @param number armor_max The new max armor to be set
-- @realm server
function plymeta:SetMaxArmor(armor_max)
    self.armor_max = math.max(math.Round(armor_max), 0)

    net.Start("ttt2_sync_armor_max")
    net.WriteUInt(self.armor_max, 16)
    net.Send(self)

    -- make sure armor is always smaller than the max armor
    self:SetArmor(math.min(self.armor_max, self:GetArmor()))
end

---
-- Increases the @{ARMOR} directly about a specific value, while also increasing the maximum
-- armor value. Mostly used when an armor item is given.
-- @param number armor The amount to be increased
-- @realm server
function plymeta:GiveArmor(armor)
    self:IncreaseMaxArmorValue(armor)
    self:IncreaseArmorValue(armor)
end

---
-- Decreases the @{ARMOR} about a scaled specific value depending on the current max value,
-- while the maximum armor value gets decreased too.
-- @param number remove The amount to be decreased
-- @realm server
function plymeta:RemoveArmor(armor)
    self:DecreaseMaxArmorValue(armor)
end

---
-- Decreases the @{ARMOR} directly about a specific value while keeping the max value.
-- To remove a player's armor(item), @{plymeta:RemoveArmor()} should be used!
-- @param number armor The amount to be decreased
-- @realm server
function plymeta:DecreaseArmorValue(armor)
    self:SetArmor(self:GetArmor() - math.max(armor, 0))
end

---
-- Increases the @{ARMOR} directly about a specific value while keeping the max value.
-- To add a player's armor(item), @{plymeta:GiveArmor()} should be used!
-- @param number armor The amount to be increased
-- @realm server
function plymeta:IncreaseArmorValue(armor)
    self:SetArmor(self:GetArmor() + math.max(armor, 0))
end

---
-- Decreases the maximum @{ARMOR} directly about a specific value.
-- @param number armor The amount to be decreased
-- @realm server
function plymeta:DecreaseMaxArmorValue(armor)
    self:SetMaxArmor(self:GetMaxArmor() - math.max(armor, 0))
end

---
-- Increases the maximum @{ARMOR} directly about a specific value.
-- @param number armor The amount to be increased
-- @realm server
function plymeta:IncreaseMaxArmorValue(armor)
    self:SetMaxArmor(self:GetMaxArmor() + math.max(armor, 0))
end

---
-- Resets the @{ARMOR} value including the max value, called in @{GM:PlayerSpawn}.
-- @realm server
-- @internal
function plymeta:ResetArmor()
    self:SetArmor(0)
    self:SetMaxArmor(0)
end
