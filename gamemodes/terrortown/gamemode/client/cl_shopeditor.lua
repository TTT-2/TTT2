---
-- @module ShopEditor

local Equipmentnew

local net = net

ShopEditor = ShopEditor or {}

-- Contains fallback data inbetween rebuilds and if custom shop needs a refresh or data is updated
ShopEditor.fallback = {}
ShopEditor.customShopRefresh = false

---
-- Returns a list of every available equipment
-- @return table
-- @realm client
function ShopEditor.GetEquipmentForRoleAll()
	-- need to build equipment cache?
	if Equipmentnew ~= nil then
		return Equipmentnew
	end

	-- start with all the non-weapon goodies
	local tbl = {}

	local eject = {
		weapon_fists = true,
		weapon_ttt_unarmed = true,
		bobs_blacklisted = true,
	}

	---
	-- @realm client
	-- stylua: ignore
	hook.Run("TTT2ModifyShopEditorIgnoreEquip", eject) -- possibility to modify from externally

	local itms = items.GetList()

	-- find buyable items to load info from
	for i = 1, #itms do
		local eq = itms[i]
		local name = WEPS.GetClass(eq)

		if name
			and not eq.Duplicated
			and not string.match(name, "base")
			and not eject[name]
		then
			if eq.id then
				tbl[#tbl + 1] = eq
			else
				ErrorNoHaltWithStack("[TTT2][SHOPEDITOR][ERROR] Item without id:\n")
				PrintTable(eq)
			end
		end
	end

	-- find buyable weapons to load info from
	local weps = weapons.GetList()

	for i = 1, #weps do
		local eq = weps[i]
		local name = WEPS.GetClass(eq)

		if name
			and not eq.Duplicated
			and not string.match(name, "base")
			and not string.match(name, "event")
			and not eject[name]
		then
			-- @realm client
			-- stylua: ignore
			if hook.Run("TTT2RegisterWeaponID", eq) then
				tbl[#tbl + 1] = eq
			else
				ErrorNoHaltWithStack("[TTT2][SHOPEDITOR][ERROR] Weapon without id.\n")
			end
		end
	end

	Equipmentnew = tbl

	return Equipmentnew
end

local function shopFallbackAnsw(len)
	local subrole = net.ReadUInt(ROLE_BITS)
	local fallback = net.ReadString()
	local roleData = roles.GetByIndex(subrole)

	ShopEditor.fallback[roleData.name] = fallback

	-- reset everything
	Equipment[subrole] = {}

	local itms = items.GetList()

	for i = 1, #itms do
		local v = itms[i]
		local canBuy = v.CanBuy

		if not canBuy then continue end

		canBuy[subrole] = nil
	end

	local weps = weapons.GetList()

	for i = 1, #weps do
		local v = weps[i]
		local canBuy = v.CanBuy

		if not canBuy then continue end

		canBuy[subrole] = nil
	end

	if fallback == SHOP_UNSET then
		local flbTbl = roleData.fallbackTable

		if not flbTbl then return end

		-- set everything
		for i = 1, #flbTbl do
			local eq = flbTbl[i]

			local equip = not items.IsItem(eq.id) and weapons.GetStored(eq.id) or items.GetStored(eq.id)
			if equip then
				equip.CanBuy = equip.CanBuy or {}
				equip.CanBuy[subrole] = subrole
			end

			Equipment[subrole][#Equipment[subrole] + 1] = eq
		end
	end
end
net.Receive("shopFallbackAnsw", shopFallbackAnsw)

local function shopFallbackReset(len)
	local itms = items.GetList()

	for i = 1, #itms do
		itms[i].CanBuy = {}
	end

	local weps = weapons.GetList()

	for i = 1, #weps do
		weps[i].CanBuy = {}
	end

	local rlsList = roles.GetList()

	for i = 1, #rlsList do
		local rd = rlsList[i]
		local subrole = rd.index
		local fb = GetGlobalString("ttt_" .. rd.abbr .. "_shop_fallback")

		-- reset everything
		Equipment[subrole] = {}

		if fb == SHOP_UNSET then
			local roleData = roles.GetByIndex(subrole)
			local flbTbl = roleData.fallbackTable

			if not flbTbl then continue end

			-- set everything
			for k = 1, #flbTbl do
				local eq = flbTbl[k]

				local equip = not items.IsItem(eq.id) and weapons.GetStored(eq.id) or items.GetStored(eq.id)
				if equip then
					equip.CanBuy = equip.CanBuy or {}
					equip.CanBuy[subrole] = subrole
				end

				Equipment[subrole][#Equipment[subrole] + 1] = eq
			end
		end
	end
end
net.Receive("shopFallbackReset", shopFallbackReset)

local function shopFallbackRefresh()
	-- Refresh F1 menu to show actual custom shop after ShopFallbackRefresh
	if ShopEditor.customShopRefresh then
		ShopEditor.customShopRefresh = false
		vguihandler.Rebuild()
	end
end
net.Receive("shopFallbackRefresh", shopFallbackRefresh)

---
-- This hook can be used to hinder weapons from being rendered in the shopeditor.
-- @param table blockedWeapons A hashtable with the classnames of blocked weapons
-- @hook
-- @realm client
function GM:TTT2ModifyShopEditorIgnoreEquip(blockedWeapons)

end
