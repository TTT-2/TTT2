--- @ignore

local GetActiveLanguageName = LANG.GetActiveLanguageName
local TryT = LANG.TryTranslation

CLGAMEMODESUBMENU.priority = 0
CLGAMEMODESUBMENU.title = ""

function CLGAMEMODESUBMENU:Populate(parent)
	local form = vgui.CreateTTT2Form(parent, "header_shop_linker")

	local shopLink = form:MakeComboBox({
		label = "label_shop_linker_set",
		OnChange = function(_, _, _, rawdata)
			if ShopEditor.fallback[self.roleData.name] == rawdata.name then return end

			ShopEditor.fallback[self.roleData.name] = rawdata.name

			net.Start("shopFallback")
			net.WriteUInt(self.roleData.index, ROLE_BITS)
			net.WriteString(rawdata.name)
			net.SendToServer()

			ShopEditor.customShopRefresh = true
			vguihandler.Rebuild()
		end
	})

	shopLink:SetSortItems(false)

	ShopEditor.fallback[self.roleData.name] = ShopEditor.fallback[self.roleData.name] or GetGlobalString("ttt_" .. self.roleData.abbr .. "_shop_fallback")

	local fallback = ShopEditor.fallback[self.roleData.name]

	-- Add own data for creating own shop
	shopLink:AddChoice(TryT("create_own_shop"), self.roleData, fallback == self.roleData.name)

	-- Since these are no simple roles, the choices have to be added manually
	shopLink:AddChoice(TryT("shop_default"), {name = SHOP_UNSET, abbr = "shop_default", color = self.roleData.color}, fallback == SHOP_UNSET)
	shopLink:AddChoice(TryT("shop_disabled"), {name = SHOP_DISABLED, abbr = "disable", color = self.roleData.color}, fallback == SHOP_DISABLED)

	for _, roleData in pairs(self.roles) do
		if roleData.index == ROLE_NONE or roleData.index == self.roleData.index then continue end

		shopLink:AddChoice(TryT("shop_link") .. ": " .. TryT(roleData.name), roleData, fallback == roleData.name)
	end

	-- Display all items as cards for custom shop if selected and shopFallback is refreshed
	if fallback ~= self.roleData.name or ShopEditor.customShopRefresh then return end

	local sortedEquipmentList = ShopEditor.sortedEquipmentList[GetActiveLanguageName] or {}

	-- If there is no language specific sorted equipment list, create one
	if table.IsEmpty(sortedEquipmentList) then
		local items = ShopEditor.GetEquipmentForRoleAll()

		local counter = 0
		for i = 1, #items do
			local item = items[i]

			-- Only keep ttt-equipments that are cached
			if not item.ttt2_cached_material and not item.ttt2_cached_model then continue end

			counter = counter + 1

			sortedEquipmentList[counter] = item
		end

		for i = 1, #sortedEquipmentList do
			local item = sortedEquipmentList[i]
			local name = item.EquipMenuData and item.EquipMenuData.name

			item.shopTitle = TryT(name) ~= name and TryT(name) or TryT(item.PrintName) or item.id or "UNDEFINED"
		end

		table.SortByMember(sortedEquipmentList, "shopTitle", true)

		-- Save the translated and sorted list
		ShopEditor.sortedEquipmentList[GetActiveLanguageName] = sortedEquipmentList
	end

	-- Create toggelable cards to create a custom shop
	local base = form:MakeIconLayout()

	for i = 1, #sortedEquipmentList do
		local item = sortedEquipmentList[i]

		form:MakeCard({
			label = item.shopTitle,
			icon = item.ttt2_cached_material,
			initial = item.CanBuy[self.roleData.index] and MODE_ADDED or MODE_DEFAULT, -- todo: this should be the current mode
			OnChange = function(_, _, newMode)
				local isAdded = newMode == MODE_ADDED or newMode == MODE_INHERIT_ADDED

				item.CanBuy[self.roleData.index] = isAdded and self.roleData.index or nil

				net.Start("shop")
				net.WriteBool(isAdded)
				net.WriteUInt(self.roleData.index, ROLE_BITS)
				net.WriteString(item.id)
				net.SendToServer()
			end
		}, base)
	end
end
