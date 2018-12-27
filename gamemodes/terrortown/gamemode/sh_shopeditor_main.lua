ShopEditor = ShopEditor or {}
ShopEditor.savingKeys = {
	credits = {typ = "number", bits = 8, default = 1}, -- from 0 to 255 (2^8 - 1)
	minPlayers = {typ = "number", bits = 6}, -- from 0 to 63 (2^6 - 1)
	--globalLimited = {typ = "bool"}, -- 0 and 1
	limited = {typ = "bool"}, -- 0 and 1
}

function ShopEditor.InitDefaultData(item)
	if not item then return end

	for key, data in pairs(ShopEditor.savingKeys) do
		if not item[key] then
			if data.typ == "number" then
				item[key] = data.default or 0
			elseif data.typ == "bool" then
				item[key] = data.default or false
			else
				item[key] = data.default or ""
			end
		end
	end
end

function ShopEditor.WriteItemData(messageName, name, item, plys)
	name = GetEquipmentFileName(name)

	if not name or not item then return end

	net.Start(messageName)
	net.WriteString(name)

	for key, data in pairs(ShopEditor.savingKeys) do
		if data.typ == "number" then
			net.WriteUInt(item[key], data.bits or 16)
		elseif data.typ == "bool" then
			net.WriteBit(item[key])
		else
			net.WriteString(item[key])
		end
	end

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

	for key, data in pairs(ShopEditor.savingKeys) do
		if data.typ == "number" then
			item[key] = net.ReadUInt(data.bits or 16)
		elseif data.typ == "bool" then
			item[key] = tobool(net.ReadBit())
		else
			item[key] = net.ReadString()
		end
	end

	return name, item
end
