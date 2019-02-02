util.AddNetworkString("TTT2RequestHUD")

net.Receive("TTT2RequestHUD", function(len, ply)
	local hudname = net.ReadString() -- new requested HUD
	local oldHUD = net.ReadString() -- current HUD as fallback

	local restrictions = {}
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
		hudname = "old_ttt"
	end

	net.Start("TTT2RequestHUD")
	net.WriteString(hudname)
	net.Send(ply)
end)
