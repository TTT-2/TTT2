util.AddNetworkString("TTT2RequestHUD")

net.Receive("TTT2RequestHUD", function(len, ply)
	local hudname = net.ReadString()

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

		hudname = ply:GetSavedHUD()

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

	ply:SaveHUD(hudname)

	net.Start("TTT2RequestHUD")
	net.WriteString(hudname)
	net.Send(ply)
end)
