if SERVER then
	util.AddNetworkString("TTT2SprintToggle")

	-- Set ConVars
	local sprintEnabled = CreateConVar("ttt2_sprint_enabled", "1", {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Toggle Sprint (Def: 0.5)")
	local maxSprintMul = CreateConVar("ttt2_sprint_max", "0.5", {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "The maximum speed modifier the player will receive (Def: 0.5)")
	local consumption = CreateConVar("ttt2_sprint_stamina_consumption", "0.6", {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "The speed of the stamina consumption (per second; Def: 0.6)")
	local stamreg = CreateConVar("ttt2_sprint_stamina_regeneration", "0.3", {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "The regeneration time of the stamina (per second; Def: 0.3)")
	local showCrosshair = CreateConVar("ttt2_sprint_crosshair", "0", {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Should the Crosshair be visible while sprinting? (Def: 1)")

	hook.Add("TTT2SyncGlobals", "AddSprintGlobals", function()
		SetGlobalBool(sprintEnabled:GetName(), sprintEnabled:GetBool())
		SetGlobalFloat(maxSprintMul:GetName(), maxSprintMul:GetFloat())
		SetGlobalFloat(consumption:GetName(), consumption:GetFloat())
		SetGlobalFloat(stamreg:GetName(), stamreg:GetFloat())
		SetGlobalBool(showCrosshair:GetName(), showCrosshair:GetBool())
	end)

	cvars.AddChangeCallback(sprintEnabled:GetName(), function(name, old, new)
		SetGlobalFloat(name, new)
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
		SetGlobalBool(name, new)
	end, "TTT2SprintCHChange")

	net.Receive("TTT2SprintToggle", function(_, ply)
		if not sprintEnabled:GetBool() or not IsValid(ply) then return end

		local bool = net.ReadBool()

		ply.oldSprintProgress = ply.sprintProgress
		ply.sprintMultiplier = bool and (1 + maxSprintMul:GetFloat()) or nil
		ply.isSprinting = bool
		ply.sprintTS = CurTime()
	end)
else
	local function PlayerSprint(bool)
		local client = LocalPlayer()

		if bool and not GetGlobalBool("ttt2_sprint_enabled", true) or not bool and not client.isSprinting then return end

		client.oldSprintProgress = client.sprintProgress
		client.sprintMultiplier = bool and (1 + GetGlobalFloat("ttt2_sprint_max", 0)) or nil
		client.isSprinting = bool
		client.sprintTS = CurTime()

		net.Start("TTT2SprintToggle")
		net.WriteBool(bool)
		net.SendToServer()

		if bool then
			if not GetGlobalBool("ttt2_sprint_crosshair", true) then
				client.oldCrosshairSize = GetConVar("ttt_crosshair_size"):GetFloat() or 1

				RunConsoleCommand("ttt_crosshair_size", 0)
			end
		else
			RunConsoleCommand("ttt_crosshair_size", client.oldCrosshairSize or 1)
		end
	end

	bind.Register("ttt2_sprint", function()
		if not LocalPlayer().preventSprint then
			PlayerSprint(true)
		end
	end,
	function()
		PlayerSprint(false)
	end)

	bind.AddSettingsBinding("ttt2_sprint", "TTT2 Sprint")
end

hook.Add("Think", "TTT2PlayerSprinting", function()
	local client

	if CLIENT then
		client = LocalPlayer()

		if not IsValid(client) then return end
	end

	local plys = client and {client} or player.GetAll()

	for _, ply in ipairs(plys) do
		if not ply.sprintTS then continue end

		local timeElapsed = CurTime() - ply.sprintTS

		if not ply.sprintMultiplier then
			ply.sprintProgress = math.min(ply.oldSprintProgress + timeElapsed * GetGlobalFloat("ttt2_sprint_stamina_regeneration"), 1)
		else
			ply.sprintProgress = math.max(ply.oldSprintProgress - timeElapsed * GetGlobalFloat("ttt2_sprint_stamina_consumption"), 0)
		end

		if ply.sprintProgress == 1 then
			ply.sprintTS = nil
		end
	end
end)
