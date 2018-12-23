ShopEditor = ShopEditor or {}
ShopEditor.savingKeys = {
	"credits",
	"globalLimited",
	"minPlayers"
}

function ShopEditor.InitDefaultData(item)
	item.credits = item.credits or 1
	item.globalLimited = item.globalLimited or 0
	item.minPlayers = item.minPlayers or 0
end

function ShopEditor.WriteItemData(messageName, name, item, plys)
	name = GetEquipmentFileName(name)

	net.Start(messageName)

	net.WriteString(name)
	net.WriteUInt(item.credits, 16)
	net.WriteBit(item.globalLimited == 1)
	net.WriteUInt(item.minPlayers, 16)

	if SERVER then
		local key

		for k, tbl in ipairs(CHANGED_EQUIPMENT) do
			if tbl[1] == name then
				key = k
			end
		end

		if not key then
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
	local eq = net.ReadString()
	local equip = GetEquipmentFileName(eq)

	local item = GetEquipmentItemByFileName(equip)
	if not item then
		item = GetWeaponNameByFileName(equip)
		if item then
			item = weapons.GetStored(item)
		end
	end

	if not item then
		return equip
	end

	item.credits = net.ReadUInt(16)
	item.globalLimited = tonumber(net.ReadBit())
	item.minPlayers = net.ReadUInt(16)

	return equip, item
end
