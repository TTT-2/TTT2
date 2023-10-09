---
-- Corpse functions
-- @module CORPSE

-- namespaced because we have no ragdoll metatable
CORPSE = {}

local math = math
local table = table
local net = net
local player = player
local timer = timer
local util = util
local IsValid = IsValid
local ConVarExists = ConVarExists
local hook = hook

---
-- @realm server
local cvBodyfound = CreateConVar("ttt_announce_body_found", "1", {FCVAR_NOTIFY, FCVAR_ARCHIVE}, "If detective mode, announce when someone's body is found")

---
-- @realm server
local cvRagCollide = CreateConVar("ttt_ragdoll_collide", "0", {FCVAR_NOTIFY, FCVAR_ARCHIVE})

local cvDeteOnlyConfirm = GetConVar("ttt2_confirm_detective_only")
local cvDeteOnlyInspect = GetConVar("ttt2_inspect_detective_only")

ttt_include("sh_corpse")

util.AddNetworkString("TTT2SendConfirmMsg")

-- networked data abstraction layer
local dti = CORPSE.dti

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

local function IdentifyBody(ply, rag)
	if not ply:IsTerror() or not ply:Alive() then return end

	-- simplified case for those who die and get found during prep
	if GetRoundState() == ROUND_PREP then
		CORPSE.SetFound(rag, true)

		return
	end

	local roleData = ply:GetSubRoleData()

	if cvDeteOnlyInspect:GetBool() and not roleData.isPolicingRole then
		LANG.Msg(ply, "inspect_detective_only", nil, MSG_MSTACK_WARN)

		return false
	end

	---
	-- @realm server
	if not hook.Run("TTTCanIdentifyCorpse", ply, rag) then return end

	local finder = ply:Nick()
	local nick = CORPSE.GetPlayerNick(rag, "")
	local notConfirmed = not CORPSE.GetFound(rag, false)

	-- Register find
	if notConfirmed then -- will return either false or a valid ply
		local deadply = player.GetBySteamID64(rag.sid64)

		if cvDeteOnlyConfirm:GetBool() and not roleData.isPolicingRole then
			LANG.Msg(ply, "confirm_detective_only", nil, MSG_MSTACK_WARN)

			return
		end

		---
		-- @realm server
		if deadply and not deadply:Alive() and hook.Run("TTT2ConfirmPlayer", deadply, ply, rag) ~= false then
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

	if GetConVar("ttt2_confirm_killlist"):GetBool() then
		-- Handle kill list
		local ragKills = rag.kills

		for i = 1, #ragKills do
			local vicsid = ragKills[i]

			-- filter out disconnected (and bots !)
			local vic = player.GetBySteamID64(vicsid)

			-- is this an unconfirmed dead?
			if not IsValid(vic) or vic:TTT2NETGetBool("body_found", false) then continue end

			LANG.Msg("body_confirm", {finder = finder, victim = vic:Nick()})

			vic:ConfirmPlayer(false)

			-- however, do not mark body as found. This lets players find the
			-- body later and get the benefits of that
			--local vicrag = vic.server_ragdoll
			--CORPSE.SetFound(vicrag, true)
		end
	end

	-- Announce body
	if cvBodyfound:GetBool() and notConfirmed then
		local subrole = rag.was_role
		local team = rag.was_team
		local rd = roles.GetByIndex(subrole)
		local roletext = "body_found_" .. rd.abbr
		local clr = rag.role_color
		local bool = GetGlobalBool("ttt2_confirm_team")

		net.Start("TTT2SendConfirmMsg")

		if bool then
			net.WriteString("body_found_team")
		else
			net.WriteString("body_found")
		end

		net.WriteString(rag.sid == "BOT" and "" or rag.sid64)

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

		net.WriteUInt(ply.search_id and ply.search_id.eidx or 0, 8)

		net.Broadcast()
	end
end

local function GiveFoundCredits(ply, rag, isLongRange)
	local corpseNick = CORPSE.GetPlayerNick(rag)
	local credits = CORPSE.GetCredits(rag, 0)

	if not ply:IsActiveShopper() or ply:GetSubRoleData().preventFindCredits
		or credits == 0 or isLongRange
	then return end

	LANG.Msg(ply, "body_credits", {num = credits})

	ply:AddCredits(credits)

	CORPSE.SetCredits(rag, 0)

	ServerLog(ply:Nick() .. " took " .. credits .. " credits from the body of " .. corpseNick .. "\n")

	events.Trigger(EVENT_CREDITFOUND, ply, rag, credits)
end

local function ttt_confirm_death(ply, cmd, args)
	if not IsValid(ply) then return end

	if #args < 2 then return end

	local eidx = tonumber(args[1])
	local id = tonumber(args[2])
	local isLongRange = (args[3] and tonumber(args[3]) == 1) and true or false

	if not eidx or not id then return end

	if not ply.search_id or ply.search_id.id ~= id or ply.search_id.eidx ~= eidx then
		ply.search_id = nil

		return
	end

	local rag = Entity(eidx)

	if IsValid(rag) and (rag:GetPos():Distance(ply:GetPos()) < 128 or isLongRange) and not CORPSE.GetFound(rag, false) then
		IdentifyBody(ply, rag)

		GiveFoundCredits(ply, rag, false)
	end

	ply.search_id = nil
end
concommand.Add("ttt_confirm_death", ttt_confirm_death)

-- Call detectives to a corpse
local function ttt_call_detective(ply, cmd, args)
	if not IsValid(ply) then return end

	if #args ~= 1 then return end

	if not ply:IsActive() then return end

	local eidx = tonumber(args[1])
	if not eidx then return end

	local rag = Entity(eidx)

	if IsValid(rag) and rag:GetPos():Distance(ply:GetPos()) < 128 then
		if CORPSE.GetFound(rag, false) then
			local plyTable = util.GetFilteredPlayers(function(p)
				return p:GetSubRoleData().isPolicingRole and p:IsTerror()
			end)

			---
			-- @realm server
			hook.Run("TTT2ModifyCorpseCallRadarRecipients", plyTable, rag, ply)

			-- show indicator in radar to detectives
			net.Start("TTT_CorpseCall")
			net.WriteVector(rag:GetPos())
			net.Send(plyTable)

			LANG.MsgAll("body_call", {player = ply:Nick(), victim = CORPSE.GetPlayerNick(rag, "someone")}, MSG_MSTACK_PLAIN)

			---
			-- @realm server
			hook.Run("TTT2CalledPolicingRole", plyTable, ply, rag, CORPSE.GetPlayer(rag))
		else
			LANG.Msg(ply, "body_call_error", nil, MSG_MSTACK_WARN)
		end
	end
end
concommand.Add("ttt_call_detective", ttt_call_detective)

local function bitsRequired(num)
	local bits, max = 0, 1

	while max <= num do
		bits = bits + 1 -- increase
		max = max + max -- double
	end

	return bits
end

---
-- Send a usermessage to client containing search results.
-- @param Player ply The player that is inspection the ragdoll
-- @param Entity rag The ragdoll that is inspected
-- @param boolean isCovert Is the search hidden
-- @param boolean isLongRange Is the search performed from a long range
-- @realm server
function CORPSE.ShowSearch(ply, rag, isCovert, isLongRange)
	if not IsValid(ply) or not IsValid(rag) then return end

	local roleData = ply:GetSubRoleData()

	if cvDeteOnlyInspect:GetBool() and not roleData.isPolicingRole then
		LANG.Msg(ply, "inspect_detective_only", nil, MSG_MSTACK_WARN)

		GiveFoundCredits(ply, rag, isLongRange)

		return
	end

	if rag:IsOnFire() then
		LANG.Msg(ply, "body_burning", nil, MSG_CHAT_WARN)

		return
	end

	---
	-- @realm server
	if not hook.Run("TTTCanSearchCorpse", ply, rag, isCovert, isLongRange) then return end

	-- init a heap of data we'll be sending
	local nick = CORPSE.GetPlayerNick(rag)
	local subrole = rag.was_role
	local role_color = rag.role_color
	local team = rag.was_team
	local eq = rag.equipment or {}
	local c4 = rag.bomb_wire or - 1
	local dmg = rag.dmgtype or DMG_GENERIC
	local wep = rag.dmgwep or ""
	local words = rag.last_words or ""
	local hshot = rag.was_headshot or false
	local dtime = rag.time or 0

	-- prepare additional corpse information
	local killDistance = CORPSE_KILL_NONE
	if rag.scene.hit_trace then
		local rawKillDistance = rag.scene.hit_trace.StartPos:Distance(rag.scene.hit_trace.HitPos)
		if rawKillDistance < 200 then
			killDistance = CORPSE_KILL_POINT_BLANK
		elseif rawKillDistance >= 700 then
			killDistance = CORPSE_KILL_FAR
		elseif rawKillDistance >= 200 then
			killDistance = CORPSE_KILL_CLOSE
		end
	end

	local killHitGroup = HITGROUP_GENERIC
	if rag.scene.hit_group and rag.scene.hit_group > 0 then
		killHitGroup = rag.scene.hit_group
	end

	local killFloorSurface = rag.scene.floorSurface or 0
	local killWaterLevel = rag.scene.waterLevel or 0

	local killAngle = CORPSE_KILL_NONE
	if rag.scene.hit_trace then
		local rawKillAngle = math.abs(math.AngleDifference(rag.scene.hit_trace.StartAng.yaw, rag.scene.victim.aim_yaw))

		if rawKillAngle < 45 then
			killAngle = CORPSE_KILL_BACK
		elseif rawKillAngle < 135 then
			killAngle = CORPSE_KILL_SIDE
		else
			killAngle = CORPSE_KILL_FRONT
		end
	end

	local plyModel = rag.scene.plyModel or ""
	local plyModelColor = rag.scene.plyModelColor or COLOR_WHITE
	local plySID64 = rag.scene.plySID64 or ""
	local lastDamage = math.max(0, rag.scene.lastDamage)

	local owner = player.GetBySteamID64(rag.sid64)
	owner = IsValid(owner) and owner:EntIndex() or -1

	-- basic sanity check
	if not nick or not eq or not subrole or not team then return end

	if GetConVar("ttt_identify_body_woconfirm"):GetBool() and DetectiveMode() and not isCovert then
		IdentifyBody(ply, rag)
	end

	-- only give credits if body is also confirmed
	if not isCovert then
		GiveFoundCredits(ply, rag, isLongRange)
	end

	-- cache credits of corpse here, AFTER one might has taken them
	local credits = CORPSE.GetCredits(rag, 0)

	-- time of death relative to current time (saves bits)
	if dtime ~= 0 then
		dtime = dtime
	end

	-- identifier so we know whether a ttt_confirm_death was legit
	ply.search_id = {eidx = rag:EntIndex(), id = rag:EntIndex() + math.floor(dtime)}

	-- time of dna sample decay relative to current time
	local stime = 0

	if rag.killer_sample then
		stime = rag.killer_sample.t
	end

	-- build list of people this player killed, but only if convar is enabled
	local kill_entids = {}
	if GetConVar("ttt2_confirm_killlist"):GetBool() then
		local ragKills = rag.kills

		for i = 1, #ragKills do
			local vicsid = ragKills[i]

			-- also send disconnected players as a marker
			local vic = player.GetBySteamID64(vicsid)

			kill_entids[#kill_entids + 1] = IsValid(vic) and vic:EntIndex() or -1
		end
	end

	local lastid = -1

	if rag.lastid and ply:IsActive() and roleData.isPolicingRole then
		-- if the person this victim last id'd has since disconnected, send -1 to
		-- indicate this
		lastid = IsValid(rag.lastid.ent) and rag.lastid.ent:EntIndex() or - 1
	end

	-- Send a message with basic info
	net.Start("TTT_RagdollSearch")
	net.WriteUInt(rag:EntIndex(), 16) -- 16 bits
	net.WriteUInt(owner, 8) -- 128 max players. (8 bits)
	net.WriteString(nick)
	net.WriteColor(role_color)

	net.WriteUInt(#eq, 16) -- Equipment (16 = max.)

	for i = 1, #eq do
		net.WriteString(eq[i])
	end

	net.WriteUInt(subrole, ROLE_BITS) -- (... bits)
	net.WriteString(team)
	net.WriteInt(c4, bitsRequired(C4_WIRE_COUNT) + 1) -- -1 -> 2^bits (default c4: 4 bits)
	net.WriteUInt(dmg, 30) -- DMG_BUCKSHOT is the highest. (30 bits)
	net.WriteString(wep)
	net.WriteBit(hshot) -- (1 bit)
	net.WriteInt(dtime, 16)
	net.WriteInt(stime, 16)

	net.WriteUInt(#kill_entids, 8)

	for i = 1, #kill_entids do
		net.WriteUInt(kill_entids[i], 8) -- first game.MaxPlayers() of entities are for players.
	end

	net.WriteUInt(lastid, 8)

	-- Who found this, so if we get this from a detective we can decide not to
	-- show a window
	net.WriteUInt(ply:EntIndex(), 8)
	net.WriteString(words)

	net.WriteBit(isLongRange)

	net.WriteUInt(killDistance, 2)
	net.WriteUInt(killHitGroup, 8)
	net.WriteUInt(killFloorSurface, 8)
	net.WriteUInt(killWaterLevel, 2)
	net.WriteUInt(killAngle, 2)
	net.WriteString(plyModel)
	net.WriteVector(plyModelColor)
	net.WriteString(plySID64)
	net.WriteUInt(credits, 8)
	net.WriteUInt(lastDamage, 16)

	-- 133 + string data + #kill_entids * 8 + team + 1
	-- 200 + ?

	-- workaround to make sure only detective searches are added to the scoreboard
	net.WriteBool(ply:IsActive() and roleData.isPolicingRole and not isCovert)

	-- If searched publicly, send to all, else just the finder
	if not isCovert then
		net.Broadcast()
	else
		net.Send(ply)
	end
end

---
-- Returns a sample for use in dna scanner if the kill fits certain constraints,
-- else returns nil
-- @param Player victim
-- @param Player attacker
-- @param DamageInfo dmg
-- @return table sample
-- @realm server
local function GetKillerSample(victim, attacker, dmg)
	-- only guns and melee damage, not explosions
	if not dmg:IsBulletDamage() and not dmg:IsDamageType(DMG_SLASH) and not dmg:IsDamageType(DMG_CLUB) then return end

	if not IsValid(victim) or not IsValid(attacker) or not attacker:IsPlayer() then return end

	-- NPCs for which a player is damage owner (meaning despite the NPC dealing
	-- the damage, the attacker is a player) should not cause the player's DNA to
	-- end up on the corpse.
	local infl = dmg:GetInflictor()

	if IsValid(infl) and infl:IsNPC() then return end

	local dist = victim:GetPos():Distance(attacker:GetPos())

	if not ConVarExists("ttt_killer_dna_range") or dist > GetConVar("ttt_killer_dna_range"):GetInt() then return end

	local sample = {}
	sample.killer = attacker
	sample.killer_sid = attacker:SteamID64()
	sample.killer_sid64 = attacker:SteamID64()
	sample.victim = victim
	sample.t = CurTime() + (-1 * (0.019 * dist) ^ 2 + (ConVarExists("ttt_killer_dna_basetime") and GetConVar("ttt_killer_dna_basetime"):GetInt() or 0))

	return sample
end

local crimescene_keys = {
	"Fraction",
	"HitBox",
	"Normal",
	"HitPos",
	"StartPos"
}

local poseparams = {
	"aim_yaw",
	"move_yaw",
	"aim_pitch"
}

local function GetSceneDataFromPlayer(ply)
	local data = {
		pos = ply:GetPos(),
		ang = ply:GetAngles(),
		sequence = ply:GetSequence(),
		cycle = ply:GetCycle()
	}

	for i = 1, #poseparams do
		local param = poseparams[i]

		data[param] = ply:GetPoseParameter(param)
	end

	return data
end

local function GetSceneData(victim, attacker, dmginfo)
	-- only for guns for now, hull traces don't work well etc
	if not dmginfo:IsBulletDamage() then return end

	local scene = {}

	if victim.hit_trace then
		scene.hit_trace = table.CopyKeys(victim.hit_trace, crimescene_keys)
	else
		return scene
	end

	scene.victim = GetSceneDataFromPlayer(victim)

	if IsValid(attacker) and attacker:IsPlayer() then
		scene.killer = GetSceneDataFromPlayer(attacker)

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

	scene.waterLevel = victim:WaterLevel();
	scene.hitGroup = victim:LastHitGroup()
	scene.floorSurface = 0
	local groundTrace = util.TraceLine({
		start = victim:GetPos(),
		endpos = victim:GetPos() + Vector(0, 0, -100)
	})
	if groundTrace.Hit then
		scene.floorSurface = groundTrace.MatType
	end
	scene.plyModel = victim:GetModel()
	scene.plyModelColor = victim:GetPlayerColor()
	scene.plySID64 = victim:SteamID64()
	scene.lastDamage = dmginfo:GetDamage()

	return scene
end

realdamageinfo = 0

---
-- Creates client or server ragdoll depending on settings
-- @param Player ply
-- @param Player attacker
-- @param DamageInfo dmginfo
-- @return Entity the CORPSE
-- @realm server
function CORPSE.Create(ply, attacker, dmginfo)
	if not IsValid(ply) then return end

	local efn = ply.effect_fn
	ply.effect_fn = nil

	local rag = ents.Create("prop_ragdoll")
	if not IsValid(rag) then return end

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
			if not IsValid(rag) then return end

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
	if cvRagCollide:GetBool() then return end

	if IsValid(ent1) and IsValid(ent2)
	and ent1:IsRagdoll() and ent2:IsRagdoll()
	and ent1.GetCollisionGroup and ent1:GetCollisionGroup() == COLLISION_GROUP_WEAPON
	and ent2.GetCollisionGroup and ent2:GetCollisionGroup() == COLLISION_GROUP_WEAPON
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
function GM:TTT2CalledPolicingRole(policingPlys, finder, ragdoll, deadply)

end

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
function GM:TTT2ConfirmPlayer(ply, rag)

end

---
-- Called when a player finds a ragdoll. They must be able to inspect the body
-- (@{GM:TTTCanIdentifyCorpse}), but not to confirm it (@{GM:TTT2ConfirmPlayer}).
-- @note The dead player may have disconnected after dying.
-- @param Player ply The player that found the corpse
-- @param Player deadply The player whose ragdoll was found
-- @param Entity rag The ragdoll that was found
-- @hook
-- @realm server
function GM:TTTBodyFound(ply, deadply, rag)

end

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
function GM:TTT2SetCorpseFound(deadply, ply, rag)

end

---
-- This hook is called after a players pressed the "call detective" button and
-- all requirements were met. It can be used to modify the table of players that
-- should receive the corpse radar ping.
-- @param Player notifiedPlayers The table of players that will be notified
-- @param Entity rag The ragdoll whose coordinates are about to be sent
-- @param Player ply The player that pressed the "call detective" button
-- @hook
-- @realm server
function GM:TTT2ModifyCorpseCallRadarRecipients(notifiedPlayers, rag, ply)

end

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
function GM:TTT2ModifyRagdollVelocity(deadply, rag, velocity)

end

---
-- Called after a dead player's corpse has been created and initialized. Modify the corpse table
-- to add/change corpse information, perhaps for use in search-related hooks.
-- @param Entity rag The newly created ragdoll
-- @param Player deadply The dead player whose ragdoll was created
-- @hook
-- @realm server
function GM:TTTOnCorpseCreated(rag, deadply)

end
