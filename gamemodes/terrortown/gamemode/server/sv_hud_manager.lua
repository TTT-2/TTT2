if not HUDManager then return end

HUDManager.restrictedHUDs = {}

util.AddNetworkString("TTT2RequestHUD")

net.Receive("TTT2RequestHUD", function(len, ply)
	if HUDManager.forcedHUD and not huds.GetStored(HUDManager.forcedHUD) then
		HUDManager.forcedHUD = nil
	end

	if not HUDManager.forcedHUD then
		local hudname = net.ReadString() -- new requested HUD
		local oldHUD = net.ReadString() -- current HUD as fallback

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
				HUDManager.defaultHUD = "old_ttt"
			end

			hudname = HUDManager.defaultHUD
		end
	end

	net.Start("TTT2RequestHUD")
	net.WriteString(HUDManager.forcedHUD or hudname)
	net.Send(ply)
end)
