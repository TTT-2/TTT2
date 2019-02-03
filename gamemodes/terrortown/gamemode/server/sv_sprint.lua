util.AddNetworkString("TTT2SprintToggle")

-- Set ConVars
local sprintEnabled = CreateConVar("ttt2_sprint_enabled", "1", {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "The maximum speed modifier the player will receive (Def: 0.5)")
local maxSprintMul = CreateConVar("ttt2_sprint_max", "0.5", {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "The maximum speed modifier the player will receive (Def: 0.5)")
local consumption = CreateConVar("ttt2_sprint_stamina_consumption", "0.3", {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "The speed of the stamina consumption (Def: 0.3)")
local stamreg = CreateConVar("ttt2_sprint_stamina_regeneration", "0.2", {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "The regeneration time of the stamina (Def: 0.15)")
local showCrosshair = CreateConVar("ttt2_sprint_crosshair", "0", {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Should the Crosshair be visible while sprinting? (Def: 1)")

hook.Add("SyncGlobals", "AddSprintGlobals", function()
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

	ply.sprintTS = CurTime()
	ply.sprintMultiplier = bool and (1 + maxSprintMul:GetFloat()) or nil
end)

hook.Add("Think", "TTT2PlayerSprinting", function()
	for _, ply in ipairs(player.GetAll()) do
		if not ply.sprintTS then return end

		local timeElapsed = CurTime() - ply.sprintTS

		ply.sprintProgress = ply.sprintProgress or 1

		if not ply.sprintMultiplier then
			ply.sprintProgress = math.min(ply.sprintProgress + (timeElapsed * stamreg:GetFloat() * 250), 1)
		else
			ply.sprintProgress = math.max(ply.sprintProgress - (timeElapsed * consumption:GetFloat() * 250), 0)
		end

		if ply.sprintProgress == 1 then
			ply.sprintTS = nil
			ply.isSprinting = nil
		else
			ply.sprintTS = CurTime()
		end
	end
end)
