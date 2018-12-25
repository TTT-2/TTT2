ShopEditor = ShopEditor or {}
ShopEditor.savingKeys = {
	{key = "credits", typ = "number"},
	{key = "globalLimited", typ = "number"},
	{key = "minPlayers", typ = "number"}
}

function ShopEditor.InitDefaultData(item)
	item.credits = item.credits or 1
	item.globalLimited = item.globalLimited or 0
	item.minPlayers = item.minPlayers or 0
end

function ShopEditor.WriteItemData(messageName, name, item, plys)
	name = GetEquipmentFileName(name)

	if not name or not item then return end

	net.Start(messageName)

	net.WriteString(name)
	net.WriteUInt(item.credits, 16)
	net.WriteBit(item.globalLimited == 1)
	net.WriteUInt(item.minPlayers, 16)

	if SERVER then
		local matched = false

		for k, tbl in ipairs(CHANGED_EQUIPMENT) do
			if tbl[1] == name then
				matched = true
			end
		end

		if not matched then
			CHANGED_EQUIPMENT[#CHANGED_EQUIPMENT + 1] = {name, item}
		end

		if plys then
			net.Send(plys)
		else
			net.Broadcast()
		end
	else
		net.SendToServer()
	end
end

function ShopEditor.ReadItemData()
	local item, wep, name = GetEquipmentByName(net.ReadString())

	item = item or wep

	if not item then
		return name
	end

	item.credits = net.ReadUInt(16)
	item.globalLimited = tonumber(net.ReadBit())
	item.minPlayers = net.ReadUInt(16)

	return name, item
end
