---
-- Player spawning/dying
-- @todo rework
-- @section player_manager

local math = math
local player = player
local net = net
local IsValid = IsValid
local hook = hook

---
-- @realm server
local ttt_bots_are_spectators = CreateConVar("ttt_bots_are_spectators", "0", {FCVAR_NOTIFY, FCVAR_ARCHIVE})

---
-- @realm server
local ttt_dyingshot = CreateConVar("ttt_dyingshot", "0", {FCVAR_NOTIFY, FCVAR_ARCHIVE})

---
-- @realm server
CreateConVar("ttt_killer_dna_range", "550", {FCVAR_NOTIFY, FCVAR_ARCHIVE})

---
-- @realm server
CreateConVar("ttt_killer_dna_basetime", "100", {FCVAR_NOTIFY, FCVAR_ARCHIVE})

util.AddNetworkString("ttt2_damage_received")

---
-- First spawn on the server.
-- Called when the @{Player} spawns for the first time.
-- See @{GM:PlayerSpawn} for a hook called every @{Player} spawn.
-- @note This hook is called before the @{Player} has fully loaded, when the @{Player} is still in seeing the "Starting Lua" screen.
-- For example, trying to use the @{Entity:GetModel} function will return the default model ("player/default.mdl")
-- @param Player ply The @{Player} who spawned.
-- @hook
-- @realm server
-- @ref https://wiki.facepunch.com/gmod/GM:PlayerInitialSpawn
-- @local
function GM:PlayerInitialSpawn(ply)
	ply:InitialSpawn()

	local rstate = GetRoundState() or ROUND_WAIT

	-- We should update the traitor list, if we are not about to send it
	-- sending roles for spectators
	if rstate <= ROUND_PREP then
		SendFullStateUpdate() -- TODO needed?
	end

	-- Game has started, tell this guy (spec) where the round is at
	if rstate ~= ROUND_WAIT then
		SendRoundState(rstate, ply)

		timer.Simple(1, SendFullStateUpdate)
	end

	-- Handle spec bots
	if ply:IsBot() and ttt_bots_are_spectators:GetBool() then
		ply:SetTeam(TEAM_SPEC)
		ply:SetForceSpec(true)
	end

	-- Sync NWVars
	-- Needs to be done here, to include bots (also this wont send any net messages to the initialized player)
	ttt2net.SyncWithNWVar("body_found", { type = "bool" }, ply, "body_found")

	-- maybe show credits
	net.Start("TTT2DevChanges")
	net.Send(ply)
end

---
-- Called when a @{Player} has been validated by Steam.
-- @param string name Player name
-- @param string steamid Player SteamID
-- @hook
-- @realm server
-- @ref https://wiki.facepunch.com/gmod/GM:NetworkIDValidated
-- @local
function GM:NetworkIDValidated(name, steamid)
	-- edge case where player authed after initspawn
	local plys = player.GetAll()

	for i = 1, #plys do
		local p = plys[i]

		if not IsValid(p) or p:SteamID64() ~= steamid or not p.delay_karma_recall then continue end

		KARMA.LateRecallAndSet(p)

		return
	end
end

---
-- Called whenever a @{Player} spawns, including respawns.
-- @param Player ply The @{Player} who spawned
-- @hook
-- @realm server
-- @ref https://wiki.facepunch.com/gmod/GM:PlayerSpawn
-- @local
function GM:PlayerSpawn(ply)
	-- stop bleeding
	util.StopBleeding(ply)

	-- Some spawns may be tilted
	ply:ResetViewRoll()

	-- Clear out stuff like whether we ordered guns or what bomb code we used
	ply:ResetRoundFlags()

	-- latejoiner, send him some info
	if GetRoundState() == ROUND_ACTIVE then
		SendRoundState(GetRoundState(), ply)
	end

	ply.spawn_nick = ply:Nick()
	ply.has_spawned = true

	-- let the client do things on spawn
	net.Start("TTT_PlayerSpawned")
	net.WriteBit(ply:IsSpec())
	net.Send(ply)

	if ply:IsSpec() then
		ply:StripAll()
		ply:Spectate(OBS_MODE_ROAMING)

		return
	end

	ply:UnSpectate()

	-- ye olde hooks

	---
	-- @realm server
	hook.Run("PlayerLoadout", ply, false)

	---
	-- @realm server
	hook.Run("PlayerSetModel", ply)

	---
	-- @realm server
	hook.Run("TTTPlayerSetColor", ply)

	ply:SetupHands()

	ply:SetLastSpawnPosition(ply:GetPos())
	ply:SetLastDeathPosition(nil)

	if ply:IsActive() then
		-- a function to handle the rolespecific stuff that should be done on
		-- rolechange and respawn (while a round is active)
		ply:GetSubRoleData():GiveRoleLoadout(ply, false)

		events.Trigger(EVENT_RESPAWN, ply)
	else
		events.Trigger(EVENT_SPAWN, ply)
	end
end

---
-- Called whenever view model hands needs setting a model.
-- By default this calls @{Player:GetHandsModel} and if that fails,
-- sets the hands model according to his @{Player} model.
-- @param Player ply The @{Player} whose hands needs a model set
-- @param Entity ent The hands to set model of
-- @hook
-- @realm server
-- @ref https://wiki.facepunch.com/gmod/GM:PlayerSetHandsModel
-- @local
function GM:PlayerSetHandsModel(ply, ent)
	local simplemodel = player_manager.TranslateToPlayerModelName(ply:GetModel())
	local info = player_manager.TranslatePlayerHands(simplemodel)

	if info then
		ent:SetModel(info.model)
		ent:SetSkin(info.skin)
		ent:SetBodyGroups(info.body)
	end
end

---
-- Check if a @{Player} can spawn at a certain spawnpoint.
-- @param Player ply The @{Player} who is spawned
-- @param Entity spawnEntity The spawnpoint entity (on the map)
-- @param boolean force If this is true, it'll kill any players blocking the spawnpoint
-- @return boolean Return true to indicate that the spawnpoint is suitable (Allow for the @{Player} to spawn here), false to prevent spawning
-- @hook
-- @realm server
-- @ref https://wiki.facepunch.com/gmod/GM:IsSpawnpointSuitable
-- @local
function GM:IsSpawnpointSuitable(ply, spawnEntity, force)
	if not IsValid(ply) or not ply:IsTerror() then
		return true
	end

	return spawn.IsSpawnPointSafe(ply, spawnEntity:GetPos(), force)
end

---
-- Returns a list of all spawnable @{Entity}
-- @param boolean shuffle whether the table should be shuffled
-- @param boolean force_all used unless absolutely necessary (includes info_player_start spawns)
-- @return table
-- @deprecated Use @{spawn.GetPlayerSpawnEntities} instead
-- @realm server
function GetSpawnEnts(shouldShuffle, forceAll)
	local spawnEntities = spawn.GetPlayerSpawnEntities(forceAll)

	if shouldShuffle then
		table.Shuffle(spawnEntities)
	end

	return spawnEntities
end

---
-- Called to determine a spawn point for a @{Player} to spawn at.
-- @param Player ply The @{Player} who needs a spawn point
-- @return Entity The spawnpoint entity to spawn the @{Player} at
-- @hook
-- @realm server
-- @ref https://wiki.facepunch.com/gmod/GM:PlayerSelectSpawn
-- @local
function GM:PlayerSelectSpawn(ply)
	return spawn.GetRandomPlayerSpawnEntity(ply)
end

---
-- Called whenever a @{Player} spawns and must choose a model.
-- A good place to assign a model to a @{Player}.
-- @note This function may not work in your custom gamemode if you have overridden
-- your @{GM:PlayerSpawn} and you do not use self.BaseClass.PlayerSpawn or @{hook.Run}.
-- @param Player ply The @{Player} being chosen
-- @hook
-- @realm server
-- @ref https://wiki.facepunch.com/gmod/GM:PlayerSetModel
-- @local
function GM:PlayerSetModel(ply)
	if not IsValid(ply) then return end

	local mdl = ply.defaultModel or GAMEMODE.force_plymodel == "" and GetRandomPlayerModel() or GAMEMODE.force_plymodel

	ply:SetModel(mdl) -- this will call the overwritten internal function to modify the model

	-- Always clear color state, may later be changed in TTTPlayerSetColor
	ply:SetColor(COLOR_WHITE)
end

---
-- Called when a @{Player} spawns and updates the @{Color}
-- @param Player ply
-- @hook
-- @realm server
function GM:TTTPlayerSetColor(ply)
	local c = COLOR_WHITE

	if GAMEMODE.playercolor then
		-- If this player has a colorable model, always use the same color as all
		-- other colorable players, so color will never be the factor that lets
		-- you tell players apart.
		c = GAMEMODE.playercolor
	end

	ply:SetPlayerColor(Vector(c.r / 255.0, c.g / 255.0, c.b / 255.0))
end

---
-- Determines if the @{Player} can kill themselves using the concommands "kill" or "explode".
-- Only active players can use kill cmd
-- @param Player ply
-- @return boolean True if they can suicide.
-- @hook
-- @realm server
-- @ref https://wiki.facepunch.com/gmod/GM:CanPlayerSuicide
-- @local
function GM:CanPlayerSuicide(ply)
	return ply:IsTerror()
end

---
-- Called whenever a @{Player} attempts to either turn on or off their flashlight,
-- returning false will deny the change.
-- @note Also gets called when using @{Player:Flashlight}
-- @param Player ply The @{Player} who attempts to change their flashlight state.
-- @param boolean on The new state the @{Player} requested, true for on, false for off.
-- @return boolean Can toggle the flashlight or not
-- @hook
-- @realm server
-- @ref https://wiki.facepunch.com/gmod/GM:PlayerSwitchFlashlight
-- @local
function GM:PlayerSwitchFlashlight(ply, on)
	if not IsValid(ply) then
		return false
	end

	-- add the flashlight "effect" here, and then deny the switch
	-- this prevents the sound from playing, fixing the exploit
	-- where weapon sound could be silenced using the flashlight sound
	if on and ply:IsTerror() then
		ply:AddEffects(EF_DIMLIGHT)
	else
		ply:RemoveEffects(EF_DIMLIGHT)
	end

	return false
end

---
-- Determines if the @{Player} can spray using the "impulse 201" console command.
-- @note This is blocked if a @{Player} isn't a terrorist
-- @param Player ply
-- @return boolean Return false to allow spraying, return true to prevent spraying.
-- @hook
-- @realm server
-- @ref https://wiki.facepunch.com/gmod/GM:PlayerSpray
-- @local
function GM:PlayerSpray(ply)
	if not IsValid(ply) or not ply:IsTerror() then
		return true -- block
	end
end

---
-- Triggered when the @{Player} presses use on an object.
-- Continuously runs until USE is released but will not activate other Entities
-- until the USE key is released; dependent on activation type of the @{Entity}.
-- @note This is just allowed for terrorists
-- @param Player ply The @{Player} pressing the "use" key.
-- @param Entity ent The entity which the @{Player} is looking at / activating USE on.
-- @return boolean Return false if the @{Player} is not allowed to USE the entity.
-- Do not return true if using a hook, otherwise other mods may not get a chance to block a @{Player}'s use.
-- @hook
-- @realm server
-- @ref https://wiki.facepunch.com/gmod/GM:PlayerUse
-- @local
function GM:PlayerUse(ply, ent)
	return ply:IsTerror()
end

---
-- Called whenever a @{Player} pressed a key included within the IN keys.
-- For a more general purpose function that handles all kinds of input, see @{GM:PlayerButtonDown}
-- @warning Due to this being a predicted hook, @{ParticleEffects} created only serverside
-- from this hook will not be networked to the client, so make sure to do that on both realms
-- @predicted
-- @param Player ply The @{Player} pressing the key. If running client-side, this will always be @{LocalPlayer}
-- @param number key The key that the @{Player} pressed using <a href="https://wiki.garrysmod.com/page/Enums/IN">IN_Enums</a>.
-- @hook
-- @realm server
-- @ref https://wiki.facepunch.com/gmod/GM:KeyPress
-- @local
function GM:KeyPress(ply, key)
	if not IsValid(ply) then return end

	-- Spectator keys
	if not ply:IsSpec() or ply:GetRagdollSpec() then return end

	if ply.propspec then
		return PROPSPEC.Key(ply, key)
	end

	ply:ResetViewRoll()

	if key == IN_ATTACK then
		-- snap to random guy
		ply:Spectate(OBS_MODE_ROAMING)
		ply:SetEyeAngles(angle_zero) -- After exiting propspec, this could be set to awkward values
		ply:SpectateEntity(nil)

		local alive = util.GetAlivePlayers()

		local alive_count = #alive
		if alive_count < 1 then return end

		local target = alive[math.random(alive_count)]

		if IsValid(target) then
			--ply:SetPos(target:EyePos())
			--ply:SetEyeAngles(target:EyeAngles())
			ply:Spectate(OBS_MODE_IN_EYE)
			ply:SpectateEntity(target)
		end
	elseif key == IN_ATTACK2 then
		-- spectate either the next guy or a random guy in chase
		local target = util.GetNextAlivePlayer(ply:GetObserverTarget())

		if IsValid(target) then
			ply:Spectate(ply.spec_mode or OBS_MODE_IN_EYE)
			ply:SpectateEntity(target)
		end
	elseif key == IN_DUCK then
		local pos = ply:GetPos()
		local ang = ply:EyeAngles()

		local target = ply:GetObserverTarget()

		-- Only set the spectator's position to the player they are spectating if they are in chase or eye mode.
		-- They can use the reload key if they want to return to the person they're spectating
		if IsValid(target) and target:IsPlayer() and ply:GetObserverMode() ~= OBS_MODE_ROAMING then
			pos = target:EyePos()
			ang = target:EyeAngles()
		end

		-- reset
		ply:Spectate(OBS_MODE_ROAMING)
		ply:SpectateEntity(nil)

		ply:SetPos(pos)
		ply:SetEyeAngles(ang)

		return true
	elseif key == IN_JUMP then
		-- unfuck if you're on a ladder etc
		if ply:GetMoveType() ~= MOVETYPE_NOCLIP then
			ply:SetMoveType(MOVETYPE_NOCLIP)
		end
	elseif key == IN_RELOAD then
		local tgt = ply:GetObserverTarget()

		if not IsValid(tgt) or not tgt:IsPlayer() then return end

		if not ply.spec_mode or ply.spec_mode == OBS_MODE_IN_EYE then
			ply.spec_mode = OBS_MODE_CHASE
		elseif ply.spec_mode == OBS_MODE_CHASE then
			ply.spec_mode = OBS_MODE_IN_EYE
		end
		-- roam stays roam

		ply:Spectate(ply.spec_mode)
	end
end

---
-- Runs when a IN key was released by a player.
-- For a more general purpose @{function} that handles all kinds of input, see @{GM:PlayerButtonUp}
-- @predicted
-- @param Player ply The @{Player} pressing the key. If running client-side, this will always be @{LocalPlayer}
-- @param number key The key that the @{Player} pressed using <a href="https://wiki.garrysmod.com/page/Enums/IN">IN_Enums</a>.
-- @hook
-- @realm server
-- @ref https://wiki.facepunch.com/gmod/GM:KeyRelease
-- @local
function GM:KeyRelease(ply, key)
	if key ~= IN_USE or not IsValid(ply) or not ply:IsTerror() then return end

	-- see if we need to do some custom usekey overriding
	local tr = util.TraceLine({
		start = ply:GetShootPos(),
		endpos = ply:GetShootPos() + ply:GetAimVector() * 100,
		filter = ply,
		mask = MASK_SHOT
	})

	if not tr.Hit or not IsValid(tr.Entity) then return end

	if tr.Entity.CanUseKey and tr.Entity.UseOverride then
		local phys = tr.Entity:GetPhysicsObject()

		if IsValid(phys) and not phys:HasGameFlag(FVPHYSICS_PLAYER_HELD) then
			tr.Entity:UseOverride(ply)

			return true
		else
			-- do nothing, can't +use held objects
			return true
		end
	elseif tr.Entity.player_ragdoll then
		CORPSE.ShowSearch(ply, tr.Entity, ply:KeyDown(IN_WALK) or ply:KeyDownLast(IN_WALK)) -- Body Corpse Search Identify TODO

		return true
	end
end

---
-- Normally all dead players are blocked from IN_USE on the server, meaning we
-- can't let them search bodies. This sucks because searching bodies is
-- fun. Hence on the client we override +use for specs and use this instead.
local function SpecUseKey(ply, cmd, arg)
	if not IsValid(ply) or not ply:IsSpec() then return end

	-- longer range than normal use
	local tr = util.QuickTrace(ply:GetShootPos(), ply:GetAimVector() * 128, ply)

	if not tr.Hit or not IsValid(tr.Entity) then return end

	if tr.Entity.player_ragdoll then
		if not ply:KeyDown(IN_WALK) then
			CORPSE.ShowSearch(ply, tr.Entity)
		else
			ply:Spectate(OBS_MODE_IN_EYE)
			ply:SpectateEntity(tr.Entity)
		end
	elseif tr.Entity:IsPlayer() and tr.Entity:IsActive() then
		ply:Spectate(ply.spec_mode or OBS_MODE_IN_EYE)
		ply:SpectateEntity(tr.Entity)
	else
		PROPSPEC.Target(ply, tr.Entity)
	end
end
concommand.Add("ttt_spec_use", SpecUseKey)

---
-- Called when a @{Player} leaves the server. See the <a href="https://wiki.garrysmod.com/page/Game_Events">player_disconnect gameevent</a> for a shared version of this hook.
-- @param Player ply
-- @hook
-- @realm server
-- @ref https://wiki.facepunch.com/gmod/GM:PlayerDisconnected
-- @local
function GM:PlayerDisconnected(ply)
	if IsValid(ply) then
		-- Kill the player when necessary
		if ply:IsTerror() and ply:Alive() then
			ply:Kill()
		end

		-- TODO ?
		-- Prevent the disconnected player from being in the resends
		ply:SetRole(ROLE_NONE)
	end

	if GetRoundState() ~= ROUND_PREP then
		TTT2NETTABLE[ply] = nil

		SendFullStateUpdate()
	end

	if KARMA.IsEnabled() then
		KARMA.Remember(ply)
	end

	ttt2net.ResetClient(ply)
end

---
-- Death affairs
local function CreateDeathEffect(ent, marked)
	local pos = ent:GetPos() + Vector(0, 0, 20)
	local jit = 35.0
	local jitter = Vector(math.Rand(-jit, jit), math.Rand(-jit, jit), 0)

	util.PaintDown(pos + jitter, "Blood", ent)

	if marked then
		util.PaintDown(pos, "Cross", ent)
	end
end

local deathsounds = {
	Sound("player/death1.wav"),
	Sound("player/death2.wav"),
	Sound("player/death3.wav"),
	Sound("player/death4.wav"),
	Sound("player/death5.wav"),
	Sound("player/death6.wav"),
	Sound("vo/npc/male01/pain07.wav"),
	Sound("vo/npc/male01/pain08.wav"),
	Sound("vo/npc/male01/pain09.wav"),
	Sound("vo/npc/male01/pain04.wav"),
	Sound("vo/npc/Barney/ba_pain06.wav"),
	Sound("vo/npc/Barney/ba_pain07.wav"),
	Sound("vo/npc/Barney/ba_pain09.wav"),
	Sound("vo/npc/Barney/ba_ohshit03.wav"), --heh
	Sound("vo/npc/Barney/ba_no01.wav"),
	Sound("vo/npc/male01/no02.wav"),
	Sound("hostage/hpain/hpain1.wav"),
	Sound("hostage/hpain/hpain2.wav"),
	Sound("hostage/hpain/hpain3.wav"),
	Sound("hostage/hpain/hpain4.wav"),
	Sound("hostage/hpain/hpain5.wav"),
	Sound("hostage/hpain/hpain6.wav")
}
local deathsounds_count = #deathsounds

local function PlayDeathSound(victim)
	if not IsValid(victim) then return end

	sound.Play(deathsounds[math.random(deathsounds_count)], victim:GetShootPos(), 90, 100)
end

---
-- See if we should award credits now
local function CheckCreditAward(victim, attacker)
	if GetRoundState() ~= ROUND_ACTIVE then return end

	if not IsValid(victim) then return end

	if not IsValid(attacker) or not attacker:IsPlayer() or not attacker:IsActive() then return end

	---
	-- @realm server
	local ret = hook.Run("TTT2CheckCreditAward", victim, attacker)
	if ret == false then return end

	local rd = attacker:GetSubRoleData()

	-- DET KILLED ANOTHER TEAM AWARD
	if attacker:GetBaseRole() == ROLE_DETECTIVE and not victim:IsInTeam(attacker) then
		local amt = math.ceil(ConVarExists("ttt_" .. rd.abbr .. "_credits_traitordead") and GetConVar("ttt_" .. rd.abbr .. "_credits_traitordead"):GetInt() or 1)

		if amt > 0 then
			local plys = player.GetAll()

			for i = 1, #plys do
				local ply = plys[i]

				if ply:IsActive() and ply:IsShopper() and ply:GetBaseRole() == ROLE_DETECTIVE then
					ply:AddCredits(amt)
				end
			end

			LANG.Msg(GetRoleChatFilter(ROLE_DETECTIVE, true), "credit_all", {num = amt})
		end
	end

	-- TRAITOR AWARD
	if (attacker:GetTeam() == TEAM_TRAITOR or rd.traitorCreditAward) and not victim:IsInTeam(attacker) and (not GAMEMODE.AwardedCredits or GetConVar("ttt_credits_award_repeat"):GetBool()) then
		local terror_alive = 0
		local terror_dead = 0
		local terror_total = 0

		local plys = player.GetAll()

		for i = 1, #plys do
			local ply = plys[i]

			if ply:IsInTeam(attacker) then continue end

			if ply:IsTerror() then
				terror_alive = terror_alive + 1
			elseif ply:IsDeadTerror() then
				terror_dead = terror_dead + 1
			end
		end

		-- we check this at the death of an innocent who is still technically
		-- Alive(), so add one to dead count and sub one from living
		terror_dead = terror_dead + 1
		terror_alive = math.max(terror_alive - 1, 0)
		terror_total = terror_dead + terror_alive

		-- Only repeat-award if we have reached the pct again since last time
		if GAMEMODE.AwardedCredits then
			terror_dead = terror_dead - GAMEMODE.AwardedCreditsDead
		end

		local pct = terror_dead / terror_total

		if not ConVarExists("ttt_credits_award_pct") or pct >= GetConVar("ttt_credits_award_pct"):GetFloat() then
			-- Traitors have killed sufficient people to get an award
			local amt = math.ceil(ConVarExists("ttt_credits_award_size") and GetConVar("ttt_credits_award_size"):GetFloat() or 0)

			-- If size is 0, awards are off
			if amt > 0 then
				for k = 1, #plys do
					local ply = plys[k]

					if ply:IsActive() and ply:IsShopper() and ply:IsInTeam(attacker) and not ply:GetSubRoleData().preventKillCredits then
						ply:AddCredits(amt)

						--LANG.Msg(GetRoleTeamFilter(TEAM_TRAITOR, true), "credit_kill_all", {num = amt})
						LANG.Msg(ply, "credit_all", {num = amt}, MSG_MSTACK_ROLE)
					end
				end
			end

			GAMEMODE.AwardedCredits = true
			GAMEMODE.AwardedCreditsDead = terror_dead + GAMEMODE.AwardedCreditsDead
		end
	end
end

---
-- Handles the @{Player}'s death.<br />
-- This hook is not called if the @{Player} is killed by @{Player:KillSilent}.
-- See @{GM:PlayerSilentDeath} for that.
-- <ul>
-- <li>@{GM:PlayerDeath} is called after this hook</li>
-- <li>@{GM:PostPlayerDeath} is called after that</li>
-- </ul>
-- @note @{Player:Alive} returns true when this is called
-- @param Player ply
-- @param Player|Entity attacker @{Player} or @{Entity} that killed the @{Player}
-- @param DamageInfo dmginfo
-- @hook
-- @realm server
-- @ref https://wiki.facepunch.com/gmod/GM:DoPlayerDeath
-- @local
function GM:DoPlayerDeath(ply, attacker, dmginfo)
	if ply:IsSpec() then return end

	-- Experimental: Fire a last shot if ironsighting and not headshot
	if ttt_dyingshot:GetBool() then
		local wep = ply:GetActiveWeapon()

		if IsValid(wep) and wep.DyingShot and not ply.was_headshot and dmginfo:IsBulletDamage() then
			local fired = wep:DyingShot()
			if fired then return end
		end

		-- Note that funny things can happen here because we fire a gun while the
		-- player is dead. Specifically, this DoPlayerDeath is run twice for
		-- him. This is ugly, and we have to return the first one to prevent crazy
		-- shit.
	end

	-- Drop all weapons
	local weps = ply:GetWeapons()

	for i = 1, #weps do
		local wep = weps[i]

		WEPS.DropNotifiedWeapon(ply, wep, true) -- with ammo in them

		if isfunction(wep.DampenDrop) then
			wep:DampenDrop()
		end
	end

	if IsValid(ply.hat) then
		ply.hat:Drop()
	end

	-- Create ragdoll and hook up marking effects
	local rag = CORPSE.Create(ply, attacker, dmginfo)

	ply.server_ragdoll = rag -- nil if clientside

	CreateDeathEffect(ply, false)

	util.StartBleeding(rag, dmginfo:GetDamage(), 15)

	-- Score only when there is a round active.
	if GetRoundState() == ROUND_ACTIVE then
		events.Trigger(EVENT_KILL, ply, attacker, dmginfo)

		if IsValid(attacker) and attacker:IsPlayer() then
			attacker:RecordKill(ply)

			DamageLog(Format("KILL:\t %s [%s] killed %s [%s]", attacker:Nick(), attacker:GetRoleString(), ply:Nick(), ply:GetRoleString()))
		else
			DamageLog(Format("KILL:\t <something/world> killed %s [%s]", ply:Nick(), ply:GetRoleString()))
		end

		KARMA.Killed(attacker, ply, dmginfo)
	end

	-- Clear out any weapon or equipment we still have
	ply:StripAll()

	-- Tell the client to send their chat contents
	ply:SendLastWords(dmginfo)

	local killwep = util.WeaponFromDamage(dmginfo)

	-- headshots, knife damage, and weapons tagged as silent all prevent death
	-- sound from occurring
	if not ply.was_headshot and not dmginfo:IsDamageType(DMG_SLASH) and not (IsValid(killwep) and killwep.IsSilent) then
		PlayDeathSound(ply)
	end

	-- Credits
	CheckCreditAward(ply, attacker)

	-- Check for TEAM killing ANOTHER TEAM to send credit rewards
	if IsValid(attacker) and attacker:IsPlayer() and attacker:IsShopper() then
		local reward = 0
		local rd = attacker:GetSubRoleData()

		-- if traitor team kills another team
		if attacker:IsActive() and attacker:IsShopper() and not attacker:IsInTeam(ply) then
			if attacker:GetTeam() == TEAM_TRAITOR then
				reward = math.ceil(ConVarExists("ttt_credits_" .. rd.name .. "kill") and GetConVar("ttt_credits_" .. rd.name .. "kill"):GetInt() or 0)
			else
				local vrd = ply:GetSubRoleData()
				local b = false

				if vrd ~= TRAITOR then
					b = ConVarExists("ttt_" .. rd.name .. "_credits_" .. vrd.name .. "kill")
				end

				if b then -- special role killing award
					reward = math.ceil(ConVarExists("ttt_" .. rd.name .. "_credits_" .. vrd.name .. "kill") and GetConVar("ttt_" .. rd.name .. "_credits_" .. vrd.name .. "kill"):GetInt() or 0)
				else -- give traitor killing award if killing another role
					reward = math.ceil(ConVarExists("ttt_" .. rd.name .. "_credits_" .. roles.TRAITOR.name .. "kill") and GetConVar("ttt_" .. rd.name .. "_credits_" .. roles.TRAITOR.name .. "kill"):GetInt() or 0)
				end
			end
		end

		if reward > 0 then
			attacker:AddCredits(reward)

			LANG.Msg(attacker, "credit_kill", {num = reward, role = LANG.NameParam(ply:GetRoleString())}, MSG_MSTACK_ROLE) -- TODO rework
		end
	end
end

---
-- Called when a @{Player} is killed by @{Player:Kill} or any other normal means.
-- This hook is not called if the @{Player} is killed by @{Player:KillSilent}. See @{GM:PlayerSilentDeath} for that.
-- <ul>
-- <li>@{GM:DoPlayerDeath} is called before this hook.</li>
-- <li>@{GM:PostPlayerDeath} is called after that</li>
-- </ul>
-- See @{Player:LastHitGroup} if you need to get the last hit hitgroup of the @{Player}.
-- @note @{Player:Alive} will return true in this hook
-- @param Player victom The @{Player} who died
-- @param Entity infl @{Entity} used to kill the victim
-- @param Player|Entity attacker @{Player} or @{Entity} that killed the victim
-- @hook
-- @realm server
-- @ref https://wiki.facepunch.com/gmod/GM:PlayerDeath
-- @local
function GM:PlayerDeath(victim, infl, attacker)
	victim:SetLastDeathPosition(victim:GetPos())
	victim:IncreaseRoundDeathCounter()

	-- stop bleeding
	util.StopBleeding(victim)

	-- tell no one
	self:PlayerSilentDeath(victim)

	-- a function to handle the rolespecific stuff that should be done on
	-- rolechange and respawn (while a round is active)
	if victim:IsActive() then
		victim:GetSubRoleData():RemoveRoleLoadout(victim, false)
	end

	victim:SetTeam(TEAM_SPEC)
	victim:Freeze(false)
	victim:SetRagdollSpec(true)
	victim:Spectate(OBS_MODE_IN_EYE)

	local rag_ent = victim.server_ragdoll or victim:GetRagdollEntity()

	victim:SpectateEntity(rag_ent)
	victim:Flashlight(false)
	victim:Extinguish()

	net.Start("TTT_PlayerDied")
	net.Send(victim)

	---
	-- @realm server
	if HasteMode() and GetRoundState() == ROUND_ACTIVE and not hook.Run("TTT2ShouldSkipHaste", victim, attacker) then
		IncRoundEnd(GetConVar("ttt_haste_minutes_per_death"):GetFloat() * 60)
	end

	if IsValid(attacker) and attacker:IsPlayer() and attacker ~= victim and attacker:IsActive() then
		victim.killerSpec = attacker
	end

	---
	-- @realm server
	hook.Run("TTT2PostPlayerDeath", victim, infl, attacker)
end

---
-- Called when the @{Player} is killed by @{Player:KillSilent}.
-- The player is already considered dead when this hook is called.
-- @param Player victim The player who was killed
-- @hook
-- @ref https://wiki.facepunch.com/gmod/GM:PlayerSilentDeath
-- @realm server
function GM:PlayerSilentDeath(victim)
	victim:SetLastDeathPosition(victim:GetPos())
	victim:IncreaseRoundDeathCounter()
end

---
-- Returns whether or not the default death sound should be muted.
-- @return[default=true] boolean Mute death sound
-- @note Used here to kill the hl2 beep
-- @hook
-- @realm server
-- @ref https://wiki.facepunch.com/gmod/GM:PlayerDeathSound
-- @local
function GM:PlayerDeathSound()
	return true
end

---
-- Called right after @{GM:DoPlayerDeath}, @{GM:PlayerDeath} and @{GM:PlayerSilentDeath}.<br />
-- This hook will be called for all deaths, including @{Player:KillSilent}
-- @note The @{Player} is considered dead when this is hook is called, @{Player:Alive} will return false.
-- @param Player ply
-- @hook
-- @realm server
-- @ref https://wiki.facepunch.com/gmod/GM:PostPlayerDeath
-- @local
function GM:PostPlayerDeath(ply)
	-- endless respawn player if he dies in preparing time
	if GetRoundState() ~= ROUND_PREP or not GetConVar("ttt2_prep_respawn"):GetBool() then return end

	timer.Simple(1, function()
		if not IsValid(ply) then return end

		ply:SpawnForRound(true)

		---
		-- @realm server
		hook.Run("PlayerLoadout", ply, false)
	end)
end

---
-- Called whenever a @{Player} is a forced spectator, in each server @{GM:Tick}
-- @param Player ply
-- @hook
-- @realm server
-- @see GM:PlayerDeathThink
function GM:SpectatorThink(ply)
	-- when spectating a ragdoll after death
	if ply:GetRagdollSpec() then
		local to_switch, to_chase, to_roam = 2, 5, 8
		local elapsed = CurTime() - ply.spec_ragdoll_start
		local clicked = ply:KeyPressed(IN_ATTACK)

		-- After first click, go into chase cam, then after another click, to into
		-- eye mode. If no clicks made, go into chase after X secs, and eye mode after Y.
		-- Don't switch for a second in case the player was shooting when he died,
		-- this would make him accidentally switch out of ragdoll cam.

		local m = ply:GetObserverMode()

		if m == OBS_MODE_CHASE and clicked or elapsed > to_roam then

			-- free roam mode
			ply:SetRagdollSpec(false)

			if ply.killerSpec and IsValid(ply.killerSpec) and ply.killerSpec:IsPlayer() and ply.killerSpec:IsActive() then
				ply:Spectate(OBS_MODE_IN_EYE)
				ply:SpectateEntity(ply.killerSpec)
			else
				ply:Spectate(OBS_MODE_ROAMING)

				-- move to spectator spawn if mapper defined any
				local spec_spawns = ents.FindByClass("ttt_spectator_spawn")
				local spec_spawns_count = #spec_spawns

				if spec_spawns_count > 0 then
					local spawnPoint = spec_spawns[math.random(spec_spawns_count)]

					ply:SetPos(spawnPoint:GetPos())
					ply:SetEyeAngles(spawnPoint:GetAngles())
				end
			end
		elseif m == OBS_MODE_IN_EYE and clicked and elapsed > to_switch or elapsed > to_chase then
			-- start following ragdoll
			ply:Spectate(OBS_MODE_CHASE)
		end

		if not IsValid(ply.server_ragdoll) then
			ply:SetRagdollSpec(false)
		end

		-- when roaming and messing with ladders
	elseif ply:GetMoveType() < MOVETYPE_NOCLIP and ply:GetMoveType() > 0 or ply:GetMoveType() == MOVETYPE_LADDER then
		ply:Spectate(OBS_MODE_ROAMING)
	end

	-- when spectating a player
	if ply:GetObserverMode() ~= OBS_MODE_ROAMING and not ply.propspec and not ply:GetRagdollSpec() then
		local tgt = ply:GetObserverTarget()

		if IsValid(tgt) and tgt:IsPlayer() then
			if not tgt:IsTerror() or not tgt:Alive() then
				-- stop speccing as soon as target dies
				ply:Spectate(OBS_MODE_ROAMING)
				ply:SpectateEntity(nil)
			elseif GetRoundState() == ROUND_ACTIVE then
				-- Sync position to target. Uglier than parenting, but unlike
				-- parenting this is less sensitive to breakage: if we are
				-- no longer spectating, we will never sync to their position.
				ply:SetPos(tgt:GetPos())
			end
		end
	end
end

---
-- Called whenever a @{Player} is a forced spectator, in each server @{GM:Tick}
-- @param Player ply
-- @hook
-- @realm server
-- @see GM:SpectatorThink
-- @function GM:PlayerDeathThink(ply)
GM.PlayerDeathThink = GM.SpectatorThink

---
-- Called when a @{Player} has been hit by a trace and damaged (such as from a bullet).
-- Returning true overrides the damage handling and prevents @{GM:ScalePlayerDamage} from being called.
-- @param Player ply The @{Player} that has been hit
-- @param DamageInfo dmginfo The damage info of the bullet
-- @param Vector dir Normalized vector direction of the bullet's path
-- @param table trace The trace of the bullet's path, see
-- <a href="https://wiki.garrysmod.com/page/Structures/TraceResult">TraceResult structure</a>
-- @return boolean Override engine handling
-- @hook
-- @realm server
-- @ref https://wiki.facepunch.com/gmod/GM:PlayerTraceAttack
-- @local
function GM:PlayerTraceAttack(ply, dmginfo, dir, trace)
	if IsValid(ply.hat) and trace.HitGroup == HITGROUP_HEAD then
		ply.hat:Drop(dir)
	end

	ply.hit_trace = trace

	return false
end

---
-- Called when a @{Player} has been hurt by an explosion. Override to disable default sound effect.
-- @param Player ply @{Player} who has been hurt
-- @param DamageInfo dmginfo Damage info from explsion
-- @hook
-- @realm server
-- @ref https://wiki.facepunch.com/gmod/GM:OnDamagedByExplosion
-- @local
function GM:OnDamagedByExplosion(ply, dmginfo)

end

---
-- This hook allows you to change how much damage a @{Player} receives when one takes damage to a specific body part.
-- @note This is not called for all damage a @{Player} receives ( For example fall damage or NPC melee damage ),
-- so you should use @{GM:EntityTakeDamage} instead if you need to detect ALL damage.
-- @param Player ply The @{Player} taking damage
-- @param number hitgroup The hitgroup where the @{Player} took damage. See
-- <a href="https://wiki.garrysmod.com/page/Enums/HITGROUP">HITGROUP_Enums</a>
-- @param DamageInfo dmginfo The damage info
-- @return boolean Return true to prevent damage that this hook is called for, stop blood particle effects and blood decals.<br />
-- It is possible to return true only on client ( This will work only in multiplayer ) to stop the effects but still take damage.
-- @hook
-- @realm server
-- @ref https://wiki.facepunch.com/gmod/GM:ScalePlayerDamage
-- @local
function GM:ScalePlayerDamage(ply, hitgroup, dmginfo)
	if ply:IsPlayer() and dmginfo:GetAttacker():IsPlayer() and GetRoundState() == 2 then
		dmginfo:ScaleDamage(0)
	end

	ply.was_headshot = false

	-- actual damage scaling
	if hitgroup == HITGROUP_HEAD then
		-- headshot if it was dealt by a bullet
		ply.was_headshot = dmginfo:IsBulletDamage()

		local wep = util.WeaponFromDamage(dmginfo)

		if IsValid(wep) then
			local s = wep:GetHeadshotMultiplier(ply, dmginfo) or 2

			dmginfo:ScaleDamage(s)
		end
	elseif hitgroup == HITGROUP_LEFTARM
	or hitgroup == HITGROUP_RIGHTARM
	or hitgroup == HITGROUP_LEFTLEG
	or hitgroup == HITGROUP_RIGHTLEG
	or hitgroup == HITGROUP_GEAR
	then
		dmginfo:ScaleDamage(0.55)
	end

	-- Keep ignite-burn damage etc on old levels
	if dmginfo:IsDamageType(DMG_DIRECT)
	or dmginfo:IsExplosionDamage()
	or dmginfo:IsDamageType(DMG_FALL)
	or dmginfo:IsDamageType(DMG_PHYSGUN)
	then
		dmginfo:ScaleDamage(2)
	end
end

---
-- Called when a @{Player} takes damage from falling, allows to override the damage.
-- @note The GetFallDamage hook does not get called until around 600 speed, which is a
-- rather high drop already. Hence we do our own fall damage handling in
-- OnPlayerHitGround.
-- @param Player ply
-- @param number speed
-- @return[default=0] number
-- @hook
-- @realm server
-- @ref https://wiki.facepunch.com/gmod/GM:GetFallDamage
-- @local
function GM:GetFallDamage(ply, speed)
	return 0
end

local fallsounds = {
	Sound("player/damage1.wav"),
	Sound("player/damage2.wav"),
	Sound("player/damage3.wav")
}
local fallsounds_count = #fallsounds

---
-- Called when a @{Player} makes contact with the ground.
-- @predicted
-- @param Player ply
-- @param boolean in_water Did the @{Player} land in water?
-- @param boolean on_floater Did the @{Player} land on an object floating in the water?
-- @param number speed The speed at which the @{Player} hit the ground
-- @return boolean Return true to suppress default action
-- @hook
-- @realm server
-- @ref https://wiki.facepunch.com/gmod/GM:OnPlayerHitGround
-- @local
function GM:OnPlayerHitGround(ply, in_water, on_floater, speed)
	if in_water or speed < 450 or not IsValid(ply) then return end

	-- Everything over a threshold hurts you, rising exponentially with speed
	local damage = math.pow(0.05 * (speed - 420), 1.75)

	-- I don't know exactly when on_floater is true, but it's probably when
	-- landing on something that is in water.
	if on_floater then
		damage = damage * 0.5
	end

	-- if we fell on a dude, that hurts (him)
	local ground = ply:GetGroundEntity()

	if IsValid(ground) and ground:IsPlayer() then
		if math.floor(damage) > 0 then
			local att = ply

			-- if the faller was pushed, that person should get attrib
			local push = ply.was_pushed

			if push and math.max(push.t or 0, push.hurt or 0) > CurTime() - 4 then
				att = push.att
			end

			local dmg = DamageInfo()

			if att == ply then
				-- hijack physgun damage as a marker of this type of kill
				dmg:SetDamageType(DMG_CRUSH + DMG_PHYSGUN)
			else
				-- if attributing to pusher, show more generic crush msg for now
				dmg:SetDamageType(DMG_CRUSH)
			end

			dmg:SetAttacker(att)
			dmg:SetInflictor(att)
			dmg:SetDamageForce(Vector(0, 0, -1))
			dmg:SetDamage(damage)

			ground:TakeDamageInfo(dmg)
		end

		-- our own falling damage is cushioned
		damage = damage / 3
	end

	if math.floor(damage) > 0 then
		local dmg = DamageInfo()

		dmg:SetDamageType(DMG_FALL)
		dmg:SetAttacker(game.GetWorld())
		dmg:SetInflictor(game.GetWorld())
		dmg:SetDamageForce(Vector(0, 0, 1))
		dmg:SetDamage(damage)

		ply:TakeDamageInfo(dmg)

		-- play CS:S fall sound if we got somewhat significant damage
		if damage > 5 then
			sound.Play(fallsounds[math.random(fallsounds_count)], ply:GetShootPos(), 55 + math.Clamp(damage, 0, 50), 100)
		end
	end
end

---
-- @realm server
local ttt_postdm = CreateConVar("ttt_postround_dm", "0", {FCVAR_NOTIFY, FCVAR_ARCHIVE})

---
-- Returns whether PVP is allowed
-- @return boolean
-- @hook
-- @realm server
function GM:AllowPVP()
	local rs = GetRoundState()

	return rs ~= ROUND_PREP and (rs ~= ROUND_POST or ttt_postdm:GetBool())
end

---
-- Called when an entity takes damage. You can modify all parts of the damage info in this hook.
-- @param Entity ent The @{Entity} taking damage
-- @param DamageInfo dmginfo Damage info
-- @return boolean Return true to completely block the damage event
-- @note e.g. no damage during prep, etc
-- @hook
-- @realm server
-- @ref https://wiki.facepunch.com/gmod/GM:EntityTakeDamage
-- @local
function GM:EntityTakeDamage(ent, dmginfo)
	if not IsValid(ent) then return end

	door.HandleDamage(ent, dmginfo)
	door.HandlePropDamage(ent, dmginfo)

	local att = dmginfo:GetAttacker()

	---
	-- @realm server
	if not hook.Run("AllowPVP") then
		-- if player vs player damage, or if damage versus a prop, then zero
		if ent:IsExplosive() or ent:IsPlayer() and IsValid(att) and att:IsPlayer() then
			dmginfo:ScaleDamage(0)
			dmginfo:SetDamage(0)
		end
	elseif ent:IsPlayer() then
		---
		-- @realm server
		hook.Run("PlayerTakeDamage", ent, dmginfo:GetInflictor(), att, dmginfo:GetDamage(), dmginfo)
	elseif ent:IsExplosive() then
		-- When a barrel hits a player, that player damages the barrel because
		-- Source physics. This gives stupid results like a player who gets hit
		-- with a barrel being blamed for killing himself or even his attacker.
		if IsValid(att)
		and att:IsPlayer()
		and dmginfo:IsDamageType(DMG_CRUSH)
		and IsValid(ent:GetPhysicsAttacker())
		then
			dmginfo:SetAttacker(ent:GetPhysicsAttacker())
			dmginfo:ScaleDamage(0)
			dmginfo:SetDamage(0)
		end
	elseif ent.is_pinned and ent.OnPinnedDamage then
		ent:OnPinnedDamage(dmginfo)

		dmginfo:SetDamage(0)
	end
end

---
-- Called by @{GM:EntityTakeDamage}
-- @param Entity ent The @{Entity} taking damage
-- @param Entity infl the inflictor
-- @param Player|Entity att the attacker
-- @param number amount amount of damage
-- @param DamageInfo dmginfo Damage info
-- @hook
-- @realm server
-- @ref https://wiki.facepunch.com/gmod/GM:EntityTakeDamage
function GM:PlayerTakeDamage(ent, infl, att, amount, dmginfo)
	-- Change damage attribution if necessary
	if infl or att then
		local hurter, owner, owner_time

		-- fall back to the attacker if there is no inflictor
		if IsValid(infl) then
			hurter = infl
		elseif IsValid(att) then
			hurter = att
		end

		-- have a damage owner?
		if hurter and IsValid(hurter:GetDamageOwner()) then
			owner, owner_time = hurter:GetDamageOwner()

		-- barrel bangs can hurt us even if we threw them, but that's our fault
		elseif hurter and ent == hurter:GetPhysicsAttacker() and dmginfo:IsDamageType(DMG_BLAST) then
			owner = ent
		elseif hurter and hurter:IsVehicle() and IsValid(hurter:GetDriver()) then
			owner = hurter:GetDriver()
		end

		-- if we were hurt by a trap OR by a non-ply ent, and we were pushed
		-- recently, then our pusher is the attacker
		if owner_time or not IsValid(att) or not att:IsPlayer() then
			local push = ent.was_pushed

			if push and IsValid(push.att) and push.t then
				-- push must be within the last 5 seconds, and must be done
				-- after the trap was enabled (if any)
				owner_time = owner_time or 0

				local t = math.max(push.t or 0, push.hurt or 0)

				if t > owner_time and t > CurTime() - 4 then
					owner = push.att

					-- pushed by a trap?
					if IsValid(push.infl) then
						dmginfo:SetInflictor(push.infl)
					end

					-- for slow-hurting traps we do leech-like damage timing
					push.hurt = CurTime()
				end
			end
		end

		-- if we are being hurt by a physics object, we will take damage from
		-- the world entity as well, which screws with damage attribution so we
		-- need to detect and work around that
		if IsValid(owner) and dmginfo:IsDamageType(DMG_CRUSH) then
			-- we should be able to use the push system for this, as the cases are
			-- similar: event causes future damage but should still be attributed
			-- physics traps can also push you to your death, for example
			local push = ent.was_pushed or {}

			-- if we already blamed this on a pusher, no need to do more
			-- else we override whatever was in was_pushed with info pointing
			-- at our damage owner
			if push.att ~= owner then
				owner_time = owner_time or CurTime()

				push.att = owner
				push.t = owner_time
				push.hurt = CurTime()

				-- store the current inflictor so that we can attribute it as the
				-- trap used by the player in the event
				if IsValid(infl) then
					push.infl = infl
				end

				-- make sure this is set, for if we created a new table
				ent.was_pushed = push
			end
		end

		-- make the owner of the damage the attacker
		att = IsValid(owner) and owner or att

		dmginfo:SetAttacker(att)
	end

	-- scale phys damage caused by props
	if dmginfo:IsDamageType(DMG_CRUSH) and IsValid(att) and not dmginfo:IsDamageType(DMG_PHYSGUN) then
		-- player falling on player, or player hurt by prop?
		-- this is prop-based physics damage
		dmginfo:ScaleDamage(0.25)

		-- if the prop is held, no damage
		if IsValid(infl) and IsValid(infl:GetOwner()) and infl:GetOwner():IsPlayer() then
			dmginfo:ScaleDamage(0)
			dmginfo:SetDamage(0)
		end
	end

	-- handle fire attacker
	if ent.ignite_info and dmginfo:IsDamageType(DMG_DIRECT) then
		local datt = dmginfo:GetAttacker()

		if not IsValid(datt) or not datt:IsPlayer() then
			local ignite = ent.ignite_info

			if IsValid(ignite.att) and IsValid(ignite.infl) then
				dmginfo:SetAttacker(ignite.att)
				dmginfo:SetInflictor(ignite.infl)
			end
		end
	end

	-- try to work out if this was push-induced leech-water damage (common on
	-- some popular maps like dm_island17)
	if ent.was_pushed
	and ent == att
	and dmginfo:GetDamageType() == DMG_GENERIC
	and util.BitSet(util.PointContents(dmginfo:GetDamagePosition()), CONTENTS_WATER)
	then
		local t = math.max(ent.was_pushed.t or 0, ent.was_pushed.hurt or 0)

		if t > CurTime() - 3 then
			dmginfo:SetAttacker(ent.was_pushed.att)

			ent.was_pushed.hurt = CurTime()
		end
	end

	-- start painting blood decals
	util.StartBleeding(ent, dmginfo:GetDamage(), 5)

	-- handle damage scaling by karma
	if IsValid(att) and att:IsPlayer() and GetRoundState() == ROUND_ACTIVE and math.floor(dmginfo:GetDamage()) > 0 then
		if KARMA.IsEnabled() and ent ~= att and not dmginfo:IsDamageType(DMG_SLASH) then
			-- scale everything to karma damage factor except the knife, because it assumes a kill
			dmginfo:ScaleDamage(att:GetDamageFactor())
		end

		-- before the karma is calculated, but after all other damage hooks / damage change is processed,
		-- the armor system should come into place (GM functions are called last)
		ARMOR:HandlePlayerTakeDamage(ent, infl, att, amount, dmginfo)

		if ent ~= att then
			-- process the effects of the damage on karma
			KARMA.Hurt(att, ent, dmginfo)

			DamageLog(Format("DMG: \t %s [%s] damaged %s [%s] for %d dmg", att:Nick(), att:GetRoleString(), ent:Nick(), ent:GetRoleString(), math.Round(dmginfo:GetDamage())))
		end
	end

	-- send damage information to client
	net.Start("ttt2_damage_received")
	net.WriteFloat(amount)
	net.Send(ent)
end

---
-- Called whenever an @{NPC} is killed
-- @param NPC npc The killed @{NPC}
-- @param Entity|Player The NPCs attacker, the @{Entity} that gets the kill credit, for example a @{Player} or an @{NPC}.
-- @param Entity inflictor Death inflictor. The @{Entity} that did the killing. Not necessarily a @{Weapon}.
-- @hook
-- @realm server
-- @ref https://wiki.facepunch.com/gmod/GM:OnNPCKilled
-- @local
function GM:OnNPCKilled(npc, attacker, inflictor)

end

---
-- Called when a @{Player} executes gm_showhelp console command. ( Default bind is F1 )
-- @param Player ply @{Player} who executed the command
-- @hook
-- @realm server
-- @ref https://wiki.facepunch.com/gmod/GM:ShowHelp
-- @local
function GM:ShowHelp(ply)
	if not IsValid(ply) then return end

	ply:ConCommand("ttt_helpscreen")
end

---
-- Request a @{Player} to join the team. This function will check if the team is available to join or not.<br />
-- This hook is called when the @{Player} runs "changeteam" in the console.<br />
-- To prevent the @{Player} from changing teams, see @{GM:PlayerCanJoinTeam}
-- @param Player ply The @{Player} to try to put into a team
-- @param number teamid Team to put the @{Player} into if the checks succeeded
-- @hook
-- @realm server
-- @ref https://wiki.facepunch.com/gmod/GM:PlayerRequestTeam
-- @local
function GM:PlayerRequestTeam(ply, teamid)

end

---
-- Called when a @{Player} enters a vehicle.<br />
-- Called just after @{GM:CanPlayerEnterVehicle}.<br />
-- See also @{GM:PlayerLeaveVehicle}.
-- @note Implementing stuff that should already be in gmod, chpt. 389
-- @param Player ply @{Player} who entered vehicle
-- @param Vehicle vehicle Vehicle the @{Player} entered
-- @param number role
-- @hook
-- @realm server
-- @ref https://wiki.facepunch.com/gmod/GM:PlayerEnteredVehicle
-- @local
function GM:PlayerEnteredVehicle(ply, vehicle, role)
	if not IsValid(vehicle) then return end

	vehicle:SetNWEntity("ttt_driver", ply)
end

---
-- Called when a @{Player} leaves a vehicle.
-- @note For vehicles with exit animations, this will be called at the end of the animation, not at the start!
-- @param Player ply @{Player} who left a vehicle.
-- @param Vehicle vehicle Vehicle the @{Player} left.
-- @hook
-- @realm server
-- @ref https://wiki.facepunch.com/gmod/GM:PlayerLeaveVehicle
-- @local
function GM:PlayerLeaveVehicle(ply, vehicle)
	if not IsValid(vehicle) then return end

	-- setting nil will not do anything, so bogusify
	vehicle:SetNWEntity("ttt_driver", vehicle)
end

---
-- Called when a @{Player} tries to pick up something using the "use" key, return to override.
-- See @{GM:GravGunPickupAllowed} for the Gravity Gun pickup variant.
-- @param Player ply The @{Player} trying to pick up something.
-- @param Entity ent The @{Entity} the @{Player} attempted to pick up.
-- @return[default=false] boolean Allow the @{Player} to pick up the @{Entity} or not.
-- @hook
-- @realm server
-- @ref https://wiki.facepunch.com/gmod/GM:AllowPlayerPickup
-- @local
function GM:AllowPlayerPickup(ply, ent)
	return false
end

---
-- Allows to suppress player taunts.
-- @note Disable taunts, we don't have a system for them (camera freezing etc).<br />
-- Mods/plugins that add such a system should override this.
-- @param Player ply @{Player} who tried to taunt
-- @param number act Act ID of the taunt player tries to do, see <a href="https://wiki.garrysmod.com/page/Enums/ACT">ACT_Enums</a>
-- @return[default=false] boolean Return false to disallow player taunting
-- @hook
-- @realm server
-- @ref https://wiki.facepunch.com/gmod/GM:PlayerShouldTaunt
-- @local
function GM:PlayerShouldTaunt(ply, act)
	return false
end
