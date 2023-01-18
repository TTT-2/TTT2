--- @ignore
local GetActiveLanguageName = LANG.GetActiveLanguageName
local TryT = LANG.TryTranslation
local IsEmpty = table.IsEmpty
local SortByMember = table.SortByMember
local net = net

CLSHOPMENU.base = "base_shopmenu"

CLSHOPMENU.icon = Material("vgui/ttt/vskin/roundend/info") --TODO: Material
CLSHOPMENU.title = "title_shop_info"
CLSHOPMENU.priority = 100

local function MakeCard(data, base)
	local card = base:Add("DCardShopTTT2")

	card:SetSize(128, 78)
	card:SetIcon(data.icon)
	card:SetText(data.label)
	card:SetMode(data.initial)
	card:SetCredits(1)

	card.OnModeChanged = function(slf, oldMode, newMode)
		if data and isfunction(data.OnChange) then
			data.OnChange(slf, oldMode, newMode)
		end
	end

	return card
end

function CLSHOPMENU:Populate(parent)
	local sizes = CLSHOP.sizes

	local form = vgui.Create("DScrollPanelTTT2", parent)
	form:SetVerticalScrollbarEnabled(true)
	form:SetSize(sizes.widthMainArea, 300) -- - 2 * sizes.padding)
	form:SetPos(0, 50)

	local sortedEquipmentList = ShopEditor.sortedEquipmentList[GetActiveLanguageName] or {}

	-- If there is no language specific sorted equipment list, create one
	if IsEmpty(sortedEquipmentList) then
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

		SortByMember(sortedEquipmentList, "shopTitle", true)

		-- Save the translated and sorted list
		ShopEditor.sortedEquipmentList[GetActiveLanguageName] = sortedEquipmentList
	end

	-- Create toggelable cards to create a custom shop
	local base = vgui.Create("DIconLayout", form)
	base:SetSpaceY(10)
	base:SetSpaceX(10)
	base:Dock(TOP)
	form:AddItem(base)

	for i = 1, #sortedEquipmentList do
		local item = sortedEquipmentList[i]

		MakeCard({
			label = item.shopTitle,
			icon = item.ttt2_cached_material,
			initial = item.CanBuy[roleIndex] and MODE_ADDED or MODE_DEFAULT, -- todo: this should be the current mode
			OnChange = function(_, _, newMode)
				local isAdded = newMode == MODE_ADDED or newMode == MODE_INHERIT_ADDED

				item.CanBuy[roleIndex] = isAdded and roleIndex or nil

				net.Start("shop")
				net.WriteBool(isAdded)
				net.WriteUInt(roleIndex, ROLE_BITS)
				net.WriteString(item.id)
				net.SendToServer()
			end
		}, base)
	end
end

function CLSHOPMENU:PopulateButtonPanel(parent)

end
