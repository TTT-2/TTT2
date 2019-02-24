util.AddNetworkString("TTT2RequestHUD")
util.AddNetworkString("TTT2ReceiveHUD")

HUDManager.restrictedHUDs = HUDManager.restrictedHUDs or {}

net.Receive("TTT2RequestHUD", function(len, ply)
	local hudname = net.ReadString() -- new requested HUD
	local oldHUD = net.ReadString() -- current HUD as fallback

	if HUDManager.forcedHUD and not huds.GetStored(HUDManager.forcedHUD) then
		HUDManager.forcedHUD = nil
	end

	if not HUDManager.forcedHUD then
		local restrictions = HUDManager.restrictedHUDs
		local restricted

		for _, v in ipairs(restrictions) do
			if v == hudname then
				restricted = true

				break
			end
		end

		if restricted then
			restricted = nil

			hudname = oldHUD

			for _, v in ipairs(restrictions) do
				if v == hudname then
					restricted = true

					break
				end
			end
		end

		if restricted then
			local defaultHUD = huds.GetStored(HUDManager.defaultHUD)
			if not defaultHUD then
				HUDManager.defaultHUD = "pure_skin"
			end

			hudname = HUDManager.defaultHUD
		end
	end

	net.Start("TTT2ReceiveHUD")
	net.WriteString(HUDManager.forcedHUD or hudname)
	net.Send(ply)
end)
