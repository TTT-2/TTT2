---
-- Corpse functions
-- @module CORPSE

---@class DamageInfoData
---@field ammoType number The ammo type which was used, referring to game.GetAmmoTypes()
---@field attacker Entity The attacker (character who originated the attack), for example a player or an NPC that shot the weapon. Or an Entity.
---@field baseDamage number The initial unmodified by skill level ( game.GetSkillLevel() ) damage
---@field damage number The total damage.
---@field damageBonus number The amount of bonus damage.
---@field damageCustom number Custom damage type. This is used by Day of Defeat: Source and Team Fortress 2 for extended damage info, but isn't used in Garry's Mod by default.
---@field damageForce Vector The force taken from the damage, sometimes used for knockback.
---@field damagePosition Vector The position where the damage was or is going to be applied to.
---@field damageType number A bitflag which indicates the damage type(s) of the damage.
---@field inflictor Entity The inflictor of the damage, a projectile, a weapon, or an ordinariy Entity.
---@field reportedPosition Vector The initial, unmodified position where the damage occured
---@field isBulletDamage boolean Whether the DamageInfo contained DMG_BULLET
---@field isExplosionDamage boolean Whether the DamageInfo contained DMG_BLAST
---@field isFallDamage boolean Whether the DamageInfo contained DMG_FALL

-- namespaced because we have no ragdoll metatable
CORPSE = {}

local table = table
local net = net
local player = player
local timer = timer
local util = util
local IsValid = IsValid
local ConVarExists = ConVarExists
local hook = hook

local soundsSearch = {
    Sound("player/footsteps/snow1.wav"),
    Sound("player/footsteps/snow2.wav"),
    Sound("player/footsteps/snow3.wav"),
    Sound("player/footsteps/snow4.wav"),
    Sound("player/footsteps/snow5.wav"),
    Sound("player/footsteps/snow6.wav"),
    Sound("player/footsteps/sand1.wav"),
    Sound("player/footsteps/sand2.wav"),
    Sound("player/footsteps/sand3.wav"),
    Sound("player/footsteps/sand4.wav"),
}

ttt_include("sh_corpse")

util.AddNetworkString("TTT2SendConfirmMsg")

---
-- @realm server
CORPSE.cv.announce_body_found = CreateConVar(
    "ttt_announce_body_found",
    "1",
    { FCVAR_NOTIFY, FCVAR_ARCHIVE },
    "If detective mode, announce when someone's body is found"
)

---
-- @realm server
CORPSE.cv.confirm_team = CreateConVar(
    "ttt2_confirm_team",
    "0",
    { FCVAR_NOTIFY, FCVAR_ARCHIVE },
    "Show team of confirmed player"
)

---
-- @realm server
CORPSE.cv.confirm_killlist = CreateConVar(
    "ttt2_confirm_killlist",
    "1",
    { FCVAR_NOTIFY, FCVAR_ARCHIVE },
    "Confirm players in kill list"
)

---
-- @realm server
CORPSE.cv.ragdoll_collide =
    CreateConVar("ttt_ragdoll_collide", "0", { FCVAR_NOTIFY, FCVAR_ARCHIVE })

-- networked data abstraction layer
local dti = CORPSE.dti
local config = CORPSE.cv

---
-- Sets a CORPSE found state
-- @param Entity rag
-- @param boolean state
-- @realm server
function CORPSE.SetFound(rag, state)
    --rag:SetNWBool("found", state)
    rag:SetDTBool(dti.BOOL_FOUND, state)
end

---
-- Sets a CORPSE owner's nick name
-- @param Entity rag
-- @param Player|string ply_or_name
-- @realm server
function CORPSE.SetPlayerNick(rag, ply_or_name)
    -- don't have datatable strings, so use a dt entity for common case of
    -- still-connected player, and if the player is gone, fall back to nw string
    local name = ply_or_name

    if IsValid(ply_or_name) then
        name = ply_or_name:Nick()

        rag:SetDTEntity(dti.ENT_PLAYER, ply_or_name)
    end

    rag:SetNWString("nick", name)
end

---
-- Sets a CORPSE amount of credits
-- @param Entity rag
-- @param number credits
-- @realm server
function CORPSE.SetCredits(rag, credits)
    --rag:SetNWInt("credits", credits)
    rag:SetDTInt(dti.INT_CREDITS, credits)
end

---
-- Identifies the corpse, registers it and announces it to the players, if possible.
-- @param Player ply The player that tries to identify the body
-- @param Entity rag The ragdoll entity that is searched
-- @param[default=0] number searchUID The unique search ID that is used to keep track of the search for the UI
-- @realm server
function CORPSE.IdentifyBody(ply, rag, searchUID)
    if not ply:IsTerror() or not ply:Alive() then
        return
    end

    -- simplified case for those who die and get found during prep
    if gameloop.GetRoundState() == ROUND_PREP then
        CORPSE.SetFound(rag, true)

        return
    end

    ---
    -- @realm server
    if not hook.Run("TTTCanIdentifyCorpse", ply, rag) then
        return
    end

    local finder = ply:Nick()
    local nick = CORPSE.GetPlayerNick(rag, "")
    local notConfirmed = not CORPSE.GetFound(rag, false)

    -- Register find
    if notConfirmed then -- will return either false or a valid ply
        local deadply = player.GetBySteamID64(rag.sid64)

        ---
        -- @realm server
        if
            deadply
            and not deadply:Alive()
            and hook.Run("TTT2ConfirmPlayer", deadply, ply, rag) ~= false
        then
            deadply:ConfirmPlayer(true)

            SendPlayerToEveryone(deadply)
        end

        events.Trigger(EVENT_BODYFOUND, ply, rag)

        ---
        -- @realm server
        hook.Run("TTTBodyFound", ply, deadply, rag)

        ---
        -- @realm server
        if hook.Run("TTT2SetCorpseFound", deadply, ply, rag) ~= false then
            CORPSE.SetFound(rag, true)
        end
    end

    -- Announce body
    if config.announce_body_found:GetBool() and notConfirmed then
        local subrole = rag.was_role
        local team = rag.was_team
        local rd = roles.GetByIndex(subrole)
        local roletext = "body_found_" .. rd.abbr
        local clr = rag.role_color
        local bool = config.confirm_team:GetBool()

        net.Start("TTT2SendConfirmMsg")

        if bool then
            net.WriteString("body_found_team")
        else
            net.WriteString("body_found")
        end

        net.WriteString(rag.sid64)

        -- color
        net.WriteUInt(clr.r, 8)
        net.WriteUInt(clr.g, 8)
        net.WriteUInt(clr.b, 8)
        net.WriteUInt(clr.a, 8)

        net.WriteBool(bool)

        net.WriteString(finder)
        net.WriteString(nick)
        net.WriteString(roletext)

        if bool then
            net.WriteString(team)
        end

        -- send searchUID to update UI buttons on client
        net.WriteUInt(searchUID or 0, 16)

        net.Broadcast()
    end

    if config.confirm_killlist:GetBool() then
        -- Handle kill list
        local ragKills = rag.kills

        local killnicks = {}
        for i = 1, #ragKills do
            local victimSIDs = ragKills[i]

            -- filter out disconnected (and bots !)
            local vic = player.GetBySteamID64(victimSIDs)

            -- is this an unconfirmed dead?
            if not IsValid(vic) or vic:TTT2NETGetBool("body_found", false) then
                continue
            end

            killnicks[#killnicks + 1] = vic:Nick()

            vic:ConfirmPlayer(false)

            -- however, do not mark body as found. This lets players find the
            -- body later and get the benefits of that
            --local vicrag = vic.server_ragdoll
            --CORPSE.SetFound(vicrag, true)
        end

        if #killnicks == 1 then
            LANG.Msg("body_confirm_one", { finder = finder, victim = killnicks[1] })
        elseif #killnicks > 1 then
            table.sort(killnicks, function(a, b)
                return a and b and a:upper() < b:upper()
            end)

            local names = killnicks[1]
            for k = 2, #killnicks do
                names = names .. ", " .. killnicks[k]
            end

            LANG.Msg("body_confirm_more", { finder = finder, victims = names, count = #killnicks })
        end
    end
end

---
-- Send a usermessage to client containing search results.
-- @param Player ply The player that is inspecting the ragdoll
-- @param Entity rag The ragdoll that is inspected
-- @param boolean isCovert Is the search hidden
-- @param boolean isLongRange Is the search performed from a long range
-- @realm server
function CORPSE.ShowSearch(ply, rag, isCovert, isLongRange)
    if not IsValid(ply) or not IsValid(rag) then
        return
    end

    -- prevent search for anyone if the body is burning
    if rag:IsOnFire() and ply:IsTerror() then
        LANG.Msg(ply, "body_burning", nil, MSG_MSTACK_WARN)

        return
    end

    ---
    -- @realm server
    if not hook.Run("TTTCanSearchCorpse", ply, rag, isCovert, isLongRange) then
        return
    end

    local sceneData = bodysearch.AssimilateSceneData(ply, rag, isCovert, isLongRange)

    -- only in mode 0 everyone can confirm by pressing E
    if bodysearch.GetInspectConfirmMode() == 0 or sceneData.base.isPublicPolicingSearch then
        -- only give credits if body is also confirmed
        if not isCovert then
            bodysearch.GiveFoundCredits(ply, rag, isLongRange, sceneData.searchUID)
        end

        if
            config.identify_body_woconfirm:GetBool()
            and gameloop.IsDetectiveMode()
            and not isCovert
        then
            CORPSE.IdentifyBody(ply, rag, sceneData.searchUID)
        end
    elseif not isCovert then
        -- in mode 1 and 2 every active shopping role can take credits
        bodysearch.GiveFoundCredits(ply, rag, isLongRange, sceneData.searchUID)
    end

    -- cache credits of corpse here, AFTER one might has taken them
    sceneData.credits = CORPSE.GetCredits(rag, 0)

    -- identifier so we know whether a ttt_confirm_death was legit
    ply.searchID = sceneData.searchUID

    -- play sound when the body was searched
    if ply:IsTerror() and not isCovert and not isLongRange then
        -- note: These sounds are pretty quiet and are therefore played thrice to increase the volume
        local soundSelected = table.Random(soundsSearch)

        rag:EmitSound(soundSelected, 100)
        rag:EmitSound(soundSelected, 100)
        rag:EmitSound(soundSelected, 100)
    end

    local roleData = ply:GetSubRoleData()
    if ply:IsActive() and roleData.isPolicingRole and roleData.isPublicRole and not isCovert then
        bodysearch.StreamSceneData(sceneData)
    else
        bodysearch.StreamSceneData(sceneData, ply)
    end
end

---
-- Returns a sample for use in dna scanner if the kill fits certain constraints,
-- else returns nil
-- @param Player victim
-- @param Player attacker
-- @param CTakeDamageInfo dmg
-- @return table sample
-- @realm server
local function GetKillerSample(victim, attacker, dmg)
    -- only guns and melee damage, not explosions
    if
        not dmg:IsBulletDamage()
        and not dmg:IsDamageType(DMG_SLASH)
        and not dmg:IsDamageType(DMG_CLUB)
    then
        return
    end

    if not IsValid(victim) or not IsValid(attacker) or not attacker:IsPlayer() then
        return
    end

    -- NPCs for which a player is damage owner (meaning despite the NPC dealing
    -- the damage, the attacker is a player) should not cause the player's DNA to
    -- end up on the corpse.
    local infl = dmg:GetInflictor()

    if IsValid(infl) and infl:IsNPC() then
        return
    end

    local dist = victim:GetPos():Distance(attacker:GetPos())

    if
        not ConVarExists("ttt_killer_dna_range")
        or dist > GetConVar("ttt_killer_dna_range"):GetInt()
    then
        return
    end

    local sample = {}
    sample.killer = attacker
    sample.killer_sid = attacker:SteamID64()
    sample.killer_sid64 = attacker:SteamID64()
    sample.victim = victim
    sample.t = CurTime()
        + (
            -1 * (0.019 * dist) ^ 2
            + (
                ConVarExists("ttt_killer_dna_basetime")
                    and GetConVar("ttt_killer_dna_basetime"):GetInt()
                or 0
            )
        )

    return sample
end

local crimescene_keys = {
    "Fraction",
    "HitBox",
    "Normal",
    "HitPos",
    "StartPos",
}

local poseparams = {
    "aim_yaw",
    "move_yaw",
    "aim_pitch",
}

local function GetSceneDataFromPlayer(ply)
    local data = {
        pos = ply:GetPos(),
        ang = ply:GetAngles(),
        sequence = ply:GetSequence(),
        cycle = ply:GetCycle(),
    }

    for i = 1, #poseparams do
        local param = poseparams[i]

        data[param] = ply:GetPoseParameter(param)
    end

    return data
end

---

---
-- Clones a CTakeDamageInfo into a table called DamageInfoData
-- @param CTakeDamageInfo dmginfo
-- @return DamageInfoData The damage info data table
-- @realm server
function CreateDamageInfoData(dmginfo)
    return {
        ammoType = dmginfo:GetAmmoType(),
        attacker = dmginfo:GetAttacker(),
        baseDamage = dmginfo:GetBaseDamage(),
        damage = dmginfo:GetDamage(),
        damageBonus = dmginfo:GetDamageBonus(),
        damageCustom = dmginfo:GetDamageCustom(),
        damageForce = dmginfo:GetDamageForce(),
        damagePosition = dmginfo:GetDamagePosition(),
        damageType = dmginfo:GetDamageType(),
        inflictor = dmginfo:GetInflictor(),
        maxDamage = dmginfo:GetMaxDamage(),
        reportedPosition = dmginfo:GetReportedPosition(),
        isBulletDamage = dmginfo:IsBulletDamage(),
        isExplosionDamage = dmginfo:IsExplosionDamage(),
        isFallDamage = dmginfo:IsFallDamage(),
    }
end

local function GetSceneData(victim, attacker, dmginfo)
    local scene = {}

    scene.damageInfoData = CreateDamageInfoData(dmginfo)

    if victim.hit_trace then
        scene.hit_trace = table.CopyKeys(victim.hit_trace, crimescene_keys)
    end

    scene.waterLevel = victim:WaterLevel()
    scene.hitGroup = victim:LastHitGroup()
    scene.floorSurface = 0
    local groundTrace = util.TraceLine({
        start = victim:GetPos(),
        endpos = victim:GetPos() + Vector(0, 0, -100),
    })
    if groundTrace.Hit then
        scene.floorSurface = groundTrace.MatType
    end
    scene.plyModel = victim:GetModel()
    scene.plySID64 = victim:SteamID64()
    scene.lastDamage = dmginfo:GetDamage()

    scene.victim = GetSceneDataFromPlayer(victim)

    if IsValid(attacker) and attacker:IsPlayer() then
        scene.killer = GetSceneDataFromPlayer(attacker)

        if not scene.hit_trace then
            return scene
        end

        local att = attacker:LookupAttachment("anim_attachment_RH")
        local angpos = attacker:GetAttachment(att)

        if not angpos then
            scene.hit_trace.StartPos = attacker:GetShootPos()
            scene.hit_trace.StartAng = attacker:EyeAngles()
        else
            scene.hit_trace.StartPos = angpos.Pos
            scene.hit_trace.StartAng = angpos.Ang
        end
    end

    return scene
end

realdamageinfo = 0

---
-- Creates client or server ragdoll depending on settings
-- @param Player ply
-- @param Player attacker
-- @param CTakeDamageInfo dmginfo
-- @param boolean realPlayerCorpse Set to true if this is a real player corpse
-- @return Entity the CORPSE
-- @realm server
function CORPSE.Create(ply, attacker, dmginfo, realPlayerCorpse)
    if not IsValid(ply) then
        return
    end

    local efn = ply.effect_fn
    ply.effect_fn = nil

    local rag = ents.Create("prop_ragdoll")
    if not IsValid(rag) then
        return
    end

    rag:SetNWBool("real_player_corpse", realPlayerCorpse or false)

    rag:SetPos(ply:GetPos())
    rag:SetModel(ply:GetModel())
    rag:SetSkin(ply:GetSkin())
    rag:SetAngles(ply:GetAngles())
    rag:SetColor(ply:GetColor())

    rag:Spawn()
    rag:Activate()

    -- nonsolid to players, but can be picked up and shot
    rag:SetCollisionGroup(COLLISION_GROUP_WEAPON)
    rag:SetCustomCollisionCheck(true)

    -- flag this ragdoll as being a player's
    rag.player_ragdoll = true
    rag.sid = ply:SteamID()
    rag.sid64 = ply:SteamID64()
    rag.uqid = ply:UniqueID() -- backwards compatibility use rag.sid64 instead

    -- network data
    CORPSE.SetPlayerNick(rag, ply)
    CORPSE.SetFound(rag, false)
    CORPSE.SetCredits(rag, ply:GetCredits())

    -- if someone searches this body they can find info on the victim and the
    -- death circumstances
    rag.equipment = table.Copy(ply:GetEquipmentItems())
    rag.was_role = ply:GetSubRole()
    rag.role_color = ply:GetRoleColor()

    rag.was_team = ply:GetTeam()
    rag.bomb_wire = ply.bomb_wire
    rag.dmgtype = dmginfo:GetDamageType()

    local wep = util.WeaponFromDamage(dmginfo)
    ---@cast wep -nil
    rag.dmgwep = IsValid(wep) and wep:GetClass() or ""

    rag.was_headshot = ply.was_headshot and dmginfo:IsBulletDamage()
    rag.time = CurTime()
    rag.kills = table.Copy(ply.kills)
    rag.killer_sample = GetKillerSample(ply, attacker, dmginfo)

    -- crime scene data
    rag.scene = GetSceneData(ply, attacker, dmginfo)

    -- position the bones
    local num = (rag:GetPhysicsObjectCount() - 1)
    local v = ply:GetVelocity()

    -- bullets have a lot of force, which feels better when shooting props,
    -- but makes bodies fly, so dampen that here
    if dmginfo:IsDamageType(DMG_BULLET) or dmginfo:IsDamageType(DMG_SLASH) then
        v:Mul(0.2)
    end

    ---
    -- @realm server
    hook.Run("TTT2ModifyRagdollVelocity", ply, rag, v)

    for i = 0, num do
        local bone = rag:GetPhysicsObjectNum(i)

        if IsValid(bone) then
            local bp, ba = ply:GetBonePosition(rag:TranslatePhysBoneToBone(i))

            if bp and ba then
                bone:SetPos(bp)
                bone:SetAngles(ba)
            end

            -- not sure if this will work:
            bone:SetVelocity(v)
        end
    end

    -- create advanced death effects (knives)
    if efn then
        -- next frame, after physics is happy for this ragdoll
        timer.Simple(0, function()
            if not IsValid(rag) then
                return
            end

            efn(rag)
        end)
    end

    ---
    -- @realm server
    hook.Run("TTTOnCorpseCreated", rag, ply)

    return rag -- we'll be speccing this
end

---
-- Checks if the ragdoll of a player was headshot.
-- @param Entity rag The ragdoll
-- @return boolean Returns if the player was headshot
-- @realm server
function CORPSE.WasHeadshot(rag)
    return IsValid(rag) and rag.was_headshot
end

---
-- Returns the death time (@{CurTime()}) of the ragdoll's player.
-- @param Entity rag The ragdoll
-- @return number The death time, 0 if the ragdol is not valid
-- @realm server
function CORPSE.GetPlayerDeathTime(rag)
    return rag.time or 0
end

---
-- Returns the SteamID64 of a ragdoll's player.
-- @param Entity rag The ragdoll
-- @return string The SteamID64, "" if the ragdol is not valid
-- @realm server
function CORPSE.GetPlayerSID64(rag)
    return rag.sid64 or ""
end

---
-- Returns the role of the ragdoll's player.
-- @param Entity rag The ragdoll
-- @return number The role, @{ROLE_INNOCENT} if the ragdol is not valid
-- @realm server
function CORPSE.GetPlayerRole(rag)
    return rag.was_role or ROLE_INNOCENT
end

---
-- Returns the team of the ragdoll's player.
-- @param Entity rag The ragdoll
-- @return string The team, @{TEAM_INNOCENT} if the ragdol is not valid
-- @realm server
function CORPSE.GetPlayerTeam(rag)
    return rag.was_team or TEAM_INNOCENT
end

hook.Add("ShouldCollide", "TTT2RagdollCollide", function(ent1, ent2)
    if config.ragdoll_collide:GetBool() then
        return
    end

    if
        IsValid(ent1)
        and IsValid(ent2)
        and ent1:IsPlayerRagdoll()
        and ent2:IsPlayerRagdoll()
        and ent1.GetCollisionGroup
        and ent1:GetCollisionGroup() == COLLISION_GROUP_WEAPON
        and ent2.GetCollisionGroup
        and ent2:GetCollisionGroup() == COLLISION_GROUP_WEAPON
    then
        return false
    end
end)

---
-- This hook is called after the policing players were called to a ragdoll.
-- @note If you want to modify the called players, use the
-- @{GM:TTT2ModifyCorpseCallRadarRecipients} hook.
-- @param table policingPlys An indexed table of the players that are called to the corpse
-- @param Player finder The player that called the policing players
-- @param Entity ragdoll The body of the dead player
-- @param Player deadply The dead player
-- @hook
-- @realm server
function GM:TTT2CalledPolicingRole(policingPlys, finder, ragdoll, deadply) end

---
-- Checks whether a @{Player} is able to identify a @{CORPSE}.
-- @note removed boolean "was_traitor". Team is available with `corpse.was_team`
-- @param Player ply The player that tries to identify the corpse
-- @param Entity rag The ragdoll that was found
-- @return[default=true] boolean Return true to allow corpse identification, false to block
-- @hook
-- @realm server
function GM:TTTCanIdentifyCorpse(ply, rag)
    return true
end

---
-- Checks whether a player is able to confirm the role of a corpse after they
-- inspected the dead body.
-- @param Player ply The player that tries to confirm the corpse
-- @param Entity rag The ragdoll that was found
-- @param[default=nil] boolean Return false to block confirmation
-- @hook
-- @realm server
function GM:TTT2ConfirmPlayer(ply, rag) end

---
-- Called when a player finds a ragdoll. They must be able to inspect the body
-- (@{GM:TTTCanIdentifyCorpse}), but not to confirm it (@{GM:TTT2ConfirmPlayer}).
-- @note The dead player may have disconnected after dying.
-- @param Player ply The player that found the corpse
-- @param Player deadply The player whose ragdoll was found
-- @param Entity rag The ragdoll that was found
-- @hook
-- @realm server
function GM:TTTBodyFound(ply, deadply, rag) end

---
-- Used to block updating the state of the corpse. Normally a confirmed
-- body is globally broadcasted as deadplayer (as seen in the scoreboard
-- for example).
-- @note The dead player may have disconnected after dying.
-- @param Player deadply The player whose ragdoll was found
-- @param Player ply The player that found the corpse
-- @param Entity rag The ragdoll that was found
-- @return nil|boolean Return false to block the update of the shared
-- corpse found variable
-- @hook
-- @realm server
function GM:TTT2SetCorpseFound(deadply, ply, rag) end

---
-- This hook is called after a players pressed the "call detective" button and
-- all requirements were met. It can be used to modify the table of players that
-- should receive the corpse radar ping.
-- @param Player notifiedPlayers The table of players that will be notified
-- @param Entity rag The ragdoll whose coordinates are about to be sent
-- @param Player ply The player that pressed the "call detective" button
-- @hook
-- @realm server
function GM:TTT2ModifyCorpseCallRadarRecipients(notifiedPlayers, rag, ply) end

---
-- Checks whether a @{Player} is able to search a @{CORPSE} based on their position.
-- The search opens a popup for the searching player with all of the player information.
-- @note removed last param is_traitor -> accessable with `corpse.was_team`
-- @param Player ply The player that tries to search the corpse
-- @param Entity rag The ragdoll that should be searched
-- @param boolean isCovert Is the search hidden
-- @param boolean isLongRange Is the search performed from a long range
-- @return[default=true] boolean Return false to block search
-- @hook
-- @realm server
function GM:TTTCanSearchCorpse(ply, rag, isCovert, isLongRange)
    return true
end

---
-- Called after the ragdoll velocity is changed on the creation of the corpse.
-- @param Player deadply The dead player whose corpse got created
-- @param Entity rag The newly created corpse
-- @param Vector velocity The velocity vector of the corpse
-- @hook
-- @realm server
function GM:TTT2ModifyRagdollVelocity(deadply, rag, velocity) end

---
-- Called after a dead player's corpse has been created and initialized. Modify the corpse table
-- to add/change corpse information, perhaps for use in search-related hooks.
-- @param Entity rag The newly created ragdoll
-- @param Player deadply The dead player whose ragdoll was created
-- @hook
-- @realm server
function GM:TTTOnCorpseCreated(rag, deadply) end
