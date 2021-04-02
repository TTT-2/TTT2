local function PlayerSprint(trySprinting, moveKey)
	if SERVER then return end

	local client = LocalPlayer()

	if trySprinting and not GetGlobalBool("ttt2_sprint_enabled", true) then return end
	if not trySprinting and not client.isSprinting or trySprinting and client.isSprinting then return end
	if client.isSprinting and (client.moveKey and not moveKey or not client.moveKey and moveKey) then return end

	client.oldSprintProgress = client.sprintProgress
	client.sprintMultiplier = trySprinting and (1 + GetGlobalFloat("ttt2_sprint_max", 0)) or nil
	client.isSprinting = trySprinting
	client.moveKey = moveKey

	net.Start("TTT2SprintToggle")
	net.WriteBool(trySprinting)
	net.SendToServer()
end

if SERVER then
	util.AddNetworkString("TTT2SprintToggle")

	-- Set ConVars

	---
	-- @realm server
	local sprintEnabled = CreateConVar("ttt2_sprint_enabled", "1", {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Toggle Sprint (Def: 1)")

	---
	-- @realm server
	local maxSprintMul = CreateConVar("ttt2_sprint_max", "0.5", {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "The maximum speed modifier the player will receive (Def: 0.5)")

	---
	-- @realm server
	local consumption = CreateConVar("ttt2_sprint_stamina_consumption", "0.6", {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "The speed of the stamina consumption (per second; Def: 0.6)")

	---
	-- @realm server
	local stamreg = CreateConVar("ttt2_sprint_stamina_regeneration", "0.3", {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "The regeneration time of the stamina (per second; Def: 0.3)")

	---
	-- @realm server
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
else -- CLIENT
	---
	-- @realm client
	local enable_doubletap_sprint = CreateConVar("ttt2_enable_doubletap_sprint", "1", {FCVAR_ARCHIVE})

	---
	-- @realm client
	local doubletap_sprint_anykey = CreateConVar("ttt2_doubletap_sprint_anykey", "1", {FCVAR_ARCHIVE})

	local lastPress = 0
	local lastPressedMoveKey = nil

	---
	-- @param Player ply
	-- @param number key
	-- @param boolean pressed
	-- @realm client
	function UpdateInputSprint(ply, key, pressed)
		if pressed then
			if ply.isSprinting or not enable_doubletap_sprint:GetBool() or ply.preventSprint then return end

			local time = CurTime()

			if lastPressedMoveKey == key and time - lastPress < 0.4 then
				PlayerSprint(true, key)
			end

			lastPressedMoveKey = key
			lastPress = time
		else
			if not ply.isSprinting then return end

			local moveKey = ply.moveKey
			local wantsToMove = ply:KeyDown(IN_FORWARD) or ply:KeyDown(IN_BACK) or ply:KeyDown(IN_MOVERIGHT) or ply:KeyDown(IN_MOVELEFT)
			local anyKey = doubletap_sprint_anykey:GetBool()

			if not moveKey or anyKey and wantsToMove or not anyKey and key ~= moveKey then return end

			PlayerSprint(false, key)
		end
	end

	bind.Register("ttt2_sprint", function()
		if not LocalPlayer().preventSprint then
			PlayerSprint(true)
		end
	end,
	function()
		PlayerSprint(false)
	end, "header_bindings_ttt2", "label_bind_sprint", KEY_LSHIFT)
end

---
-- @realm shared
function UpdateSprint()
	local client

	if CLIENT then
		client = LocalPlayer()

		if not IsValid(client) then return end
	end

	local plys = client and {client} or player.GetAll()

	for i = 1, #plys do
		local ply = plys[i]

		if not ply:OnGround() then continue end

		local wantsToMove = ply:KeyDown(IN_FORWARD) or ply:KeyDown(IN_BACK) or ply:KeyDown(IN_MOVERIGHT) or ply:KeyDown(IN_MOVELEFT)

		if ply.sprintProgress == 1 and (not ply.isSprinting or not wantsToMove) then continue end
		if ply.sprintProgress == 0 and ply.isSprinting and wantsToMove then
			ply.sprintResetDelayCounter = ply.sprintResetDelayCounter + FrameTime()

			-- If the player keeps sprinting even though they have no stamina, start refreshing stamina after 1.5 seconds automatically
			if CLIENT and ply.sprintResetDelayCounter > 1.5 then
				PlayerSprint(false, ply.moveKey)
			end

			continue
		end

		ply.sprintResetDelayCounter = 0

		local modifier = {1} -- Multiple hooking support

		if not ply.isSprinting or not wantsToMove then
			---
			-- @realm shared
			hook.Run("TTT2StaminaRegen", ply, modifier)

			ply.sprintProgress = math.min((ply.oldSprintProgress or 0) + FrameTime() * modifier[1] * GetGlobalFloat("ttt2_sprint_stamina_regeneration"), 1)
			ply.oldSprintProgress = ply.sprintProgress
		elseif wantsToMove then
			---
			-- @realm shared
			hook.Run("TTT2StaminaDrain", ply, modifier)

			ply.sprintProgress = math.max((ply.oldSprintProgress or 0) - FrameTime() * modifier[1] * GetGlobalFloat("ttt2_sprint_stamina_consumption"), 0)
			ply.oldSprintProgress = ply.sprintProgress
		end
	end
end
