local function PlayerSprint(bool)
	local client = LocalPlayer()

	if bool and not GetGlobalBool("ttt2_sprint_enabled", true) or not bool and not client.isSprinting then return end

	client.sprintMultiplier = bool and (1 + GetGlobalFloat("ttt2_sprint_max", 0)) or nil
	client.sprintTS = CurTime()

	net.Start("TTT2SprintToggle")
	net.WriteBool(bool)
	net.SendToServer()

	if bool then
		if GetGlobalBool("ttt2_sprint_crosshair", true) then
			client.oldCrosshairSize = GetConVar("ttt_crosshair_size"):GetFloat()

			RunConsoleCommand("ttt_crosshair_size", 0)
		end
	else
		RunConsoleCommand("ttt_crosshair_size", client.oldCrosshairSize or 1)
	end

	client.isSprinting = bool
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

hook.Add("Think", "TTT2PlayerSprinting", function()
	local client = LocalPlayer()

	if not client.sprintTS then return end

	local timeElapsed = CurTime() - client.sprintTS

	if not client.isSprinting then
		local regeneration = GetGlobalFloat("ttt2_sprint_stamina_regeneration", 0.15)

		client.sprintProgress = math.min(client.sprintProgress + (timeElapsed * regeneration * 250), 1)
	else
		local consumption = GetGlobalFloat("ttt2_sprint_stamina_consumption", 0.3)

		client.sprintProgress = math.max(client.sprintProgress - (timeElapsed * consumption * 250), 0)
	end

	if client.sprintProgress == 1 then
		client.sprintTS = nil
		client.isSprinting = nil
	else
		client.sprintTS = CurTime()
	end
end)
