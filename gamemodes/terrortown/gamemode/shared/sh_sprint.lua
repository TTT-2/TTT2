if SERVER then
	util.AddNetworkString("TTT2SprintToggle")

	-- Set ConVars
	local sprintEnabled = CreateConVar("ttt2_sprint_enabled", "1", {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Toggle Sprint (Def: 1)")
	local maxSprintMul = CreateConVar("ttt2_sprint_max", "0.5", {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "The maximum speed modifier the player will receive (Def: 0.5)")
	local consumption = CreateConVar("ttt2_sprint_stamina_consumption", "0.6", {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "The speed of the stamina consumption (per second; Def: 0.6)")
	local stamreg = CreateConVar("ttt2_sprint_stamina_regeneration", "0.3", {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "The regeneration time of the stamina (per second; Def: 0.3)")
	local showCrosshair = CreateConVar("ttt2_sprint_crosshair", "0", {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Should the Crosshair be visible while sprinting? (Def: 0)")

	hook.Add("TTT2SyncGlobals", "AddSprintGlobals", function()
		SetGlobalBool(sprintEnabled:GetName(), sprintEnabled:GetBool())
		SetGlobalFloat(maxSprintMul:GetName(), maxSprintMul:GetFloat())
		SetGlobalFloat(consumption:GetName(), consumption:GetFloat())
		SetGlobalFloat(stamreg:GetName(), stamreg:GetFloat())
		SetGlobalBool(showCrosshair:GetName(), showCrosshair:GetBool())
	end)

	cvars.AddChangeCallback(sprintEnabled:GetName(), function(name, old, new)
		SetGlobalBool(name, tobool(new))
	end, "TTT2SprintENChange")

	cvars.AddChangeCallback(maxSprintMul:GetName(), function(name, old, new)
		SetGlobalFloat(name, new)
	end, "TTT2SprintSMulChange")

	cvars.AddChangeCallback(consumption:GetName(), function(name, old, new)
		SetGlobalFloat(name, new)
	end, "TTT2SprintSCChange")

	cvars.AddChangeCallback(stamreg:GetName(), function(name, old, new)
		SetGlobalFloat(name, new)
	end, "TTT2SprintSRChange")

	cvars.AddChangeCallback(showCrosshair:GetName(), function(name, old, new)
		SetGlobalBool(name, tobool(new))
	end, "TTT2SprintCHChange")

	net.Receive("TTT2SprintToggle", function(_, ply)
		if not sprintEnabled:GetBool() or not IsValid(ply) then return end

		local bool = net.ReadBool()

		ply.oldSprintProgress = ply.sprintProgress
		ply.sprintMultiplier = bool and (1 + maxSprintMul:GetFloat()) or nil
		ply.isSprinting = bool
	end)
else
	local lastPress = 0

	local function PlayerSprint(trySprinting, bind)
		local client = LocalPlayer()

		if trySprinting and not GetGlobalBool("ttt2_sprint_enabled", true) then return end
		if not trySprinting and not client.isSprinting or trySprinting and client.isSprinting then return end
		if client.isSprinting and (client.useSprintBind and not bind or not client.useSprintBind and bind) then return end

		client.oldSprintProgress = client.sprintProgress
		client.sprintMultiplier = trySprinting and (1 + GetGlobalFloat("ttt2_sprint_max", 0)) or nil
		client.isSprinting = trySprinting
		client.useSprintBind = bind

		net.Start("TTT2SprintToggle")
		net.WriteBool(trySprinting)
		net.SendToServer()
	end

	hook.Add("KeyPress", "TTT2DoublePressSprint", function(ply, key)
		if not IsFirstTimePredicted() then return end
		if key == IN_FORWARD and not ply.isSprinting then
			local time = CurTime()

			if time - lastPress < 0.4 then
				PlayerSprint(true, false)
			end

			lastPress = time
		end
	end)

	hook.Add("KeyRelease", "TTT2EndDoublePressSprint", function(ply, key)
		if not IsFirstTimePredicted() then return end
		if key == IN_FORWARD and ply.isSprinting then
			PlayerSprint(false, false)
		end
	end)

	bind.Register("ttt2_sprint", function()
		if not LocalPlayer().preventSprint then
			PlayerSprint(true, true)
		end
	end,
	function()
		PlayerSprint(false, true)
	end, "TTT2 Bindings", "f1_bind_sprint", KEY_LSHIFT)
end

hook.Add("Think", "TTT2PlayerSprinting", function()
	local client

	if CLIENT then
		client = LocalPlayer()

		if not IsValid(client) then return end
	end

	local plys = client and {client} or player.GetAll()

	for i = 1, #plys do
		local ply = plys[i]
		local wantsToMove = ply:KeyDown(IN_FORWARD) or ply:KeyDown(IN_BACK) or ply:KeyDown(IN_MOVERIGHT) or ply:KeyDown(IN_MOVELEFT)

		if ply.sprintProgress == 1 and (not ply.isSprinting or not wantsToMove) then continue end
		if ply.sprintProgress == 0 and ply.isSprinting and wantsToMove then continue end

		local modifier = {1} -- Multiple hooking support

		if not ply.isSprinting or not wantsToMove then
			hook.Run("TTT2StaminaRegen", ply, modifier)

			ply.sprintProgress = math.min((ply.oldSprintProgress or 0) + FrameTime() * modifier[1] * GetGlobalFloat("ttt2_sprint_stamina_regeneration"), 1)
			ply.oldSprintProgress = ply.sprintProgress
		elseif wantsToMove then
			hook.Run("TTT2StaminaDrain", ply, modifier)

			ply.sprintProgress = math.max((ply.oldSprintProgress or 0) - FrameTime() * modifier[1] * GetGlobalFloat("ttt2_sprint_stamina_consumption"), 0)
			ply.oldSprintProgress = ply.sprintProgress
		end
	end
end)
