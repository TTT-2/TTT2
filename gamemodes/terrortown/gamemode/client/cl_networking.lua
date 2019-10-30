local function TTT2UpdatePlayerConfirmed()
	local ply = net.ReadEntity()
	if not IsValid(ply) then return end

	ply:ConfirmPlayer(net.ReadBool())
end
net.Receive("TTT2ConfirmPlayer", TTT2UpdatePlayerConfirmed)

local function TTT2UpdateBodyFound()
	local ply = net.ReadEntity()
	if not IsValid(ply) then return end

	ply:SetNetworkingData("bodyFound", net.ReadBool())
end
net.Receive("TTT2UpdateBodyFound", TTT2UpdateBodyFound)
