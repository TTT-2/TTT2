---
-- @module ShopEditor

ttt_include("vgui__cl_shopeditor_buttons")
ttt_include("vgui__cl_shopeditor_slider")

local COLOR_GREY = COLOR_GREY or Color(120, 120, 120, 255)
local itemBoxColor = Color(100, 100, 100)

local Equipmentnew
local SafeTranslate = LANG.TryTranslation

local math = math
local table = table
local net = net
local pairs = pairs
local IsValid = IsValid

ShopEditor = ShopEditor or {}

-- Contains fallback data inbetween rebuilds and if custom shop needs a refresh or data is updated
ShopEditor.fallback = {}
ShopEditor.customShopRefresh = false

---
-- Returns whether the given equipment is not an @{ITEM} (so whether it's a @{Weapon})
-- @param ITEM|Weapon item
-- @return boolean
-- @realm client
function ShopEditor.ItemIsWeapon(item)
	return not items.IsItem(item.id)
end

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
		weapon_zm_carry = true,
		bobs_blacklisted = true
	}

	---
	-- @realm client
	hook.Run("TTT2ModifyShopEditorIgnoreEquip", eject) -- possibility to modify from externally

	local itms = items.GetList()

	-- find buyable items to load info from
	for i = 1, #itms do
		local v = itms[i]
		local name = WEPS.GetClass(v)

		if name
		and not v.Doublicated
		and not string.match(name, "base")
		and not eject[name]
		then
			if v.id then
				tbl[#tbl + 1] = v
			else
				ErrorNoHalt("[TTT2][SHOPEDITOR][ERROR] Item without id:")
				PrintTable(v)
			end
		end
	end

	-- find buyable weapons to load info from
	local weps = weapons.GetList()

	for i = 1, #weps do
		local v = weps[i]
		local name = WEPS.GetClass(v)

		if name
		and not v.Doublicated
		and not string.match(name, "base")
		and not string.match(name, "event")
		and not eject[name]
		then
			if v.id then
				tbl[#tbl + 1] = v
			else
				ErrorNoHalt("[TTT2][SHOPEDITOR][ERROR] Weapon without id:")
				PrintTable(v)
			end
		end
	end

	Equipmentnew = tbl

	return Equipmentnew
end

---
-- Creates the item list for a @{Panel}
-- @param Panel frame
-- @param number w width
-- @param number h height
-- @param table itms @{table} of @{ITEM}s and @{Weapon}s
-- @param function onClick
-- @param function updateListItems
-- @return Panel dlist
-- @realm client
-- @internal
function ShopEditor.CreateItemList(frame, w, h, itms, onClick, updateListItems)
	if not itms or not onClick and not updateListItems then return end

	local ply = LocalPlayer()

	-- Construct icon listing
	local dlist = vgui.Create("EquipSelect", frame)
	dlist:SetPos(0, 25)
	dlist:SetSize(w, h - 45)
	dlist:EnableVerticalScrollbar(true)
	dlist:EnableHorizontal(true)
	dlist:SetPadding(4)

	for _, item in pairs(itms) do
		local ic

		-- Create icon panel
		if item.ttt2_cached_material then
			if not ShopEditor.ItemIsWeapon(item) then
				ic = vgui.Create("SimpleClickIcon", dlist)
			else
				ic = vgui.Create("LayeredClickIcon", dlist)
			end

			-- Slot marker icon
			if ShopEditor.ItemIsWeapon(item) then
				local slot = vgui.Create("SimpleClickIconLabelled")
				slot:SetIcon("vgui/ttt/slotcap")
				slot:SetIconColor(COLOR_GREY)
				slot:SetIconSize(16)
				slot:SetIconText(item.slot)
				slot:SetIconProperties(COLOR_WHITE, "DefaultBold", {opacity = 220, offset = 1}, {10, 8})

				ic:AddLayer(slot)
				ic:EnableMousePassthrough(slot)
			end

			ic:SetIconSize(64)
			ic:SetMaterial(item.ttt2_cached_material)
		elseif item.ttt2_cached_model then
			ic = vgui.Create("SpawnIcon", dlist)
			ic:SetModel(item.ttt2_cached_model)
		end

		if ic then
			ic.item = item

			ic.OnClick = function(s)
				if onClick then
					onClick(s)
				end

				if updateListItems then
					updateListItems(dlist)
				end
			end

			local tip = (GetEquipmentTranslation(item.EquipMenuData and item.EquipMenuData.name or nil, item.PrintName) or item.id or "UNDEFINED") .. " (" .. (SafeTranslate(item.type or item.EquipMenuData and item.EquipMenuData.type or nil) or "UNDEFINED") .. ")"

			ic:SetTooltip(tip)

			dlist:AddPanel(ic)
		end
	end

	ply.shopeditor = dlist

	return dlist
end

-- ITEM EDITOR

---
-- Creates the @{ITEM} Editor @{Panel}
-- @param ITEM|Weapon item
-- @realm client
-- @internal
function ShopEditor.EditItem(item)
	local ply = LocalPlayer()

	if IsValid(ply.shopeditor_itemframes) then
		ply.shopeditor_itemframes:Close()
	end

	local w, h = ScrW() * 0.25, ScrH() * 0.25

	local frame = vgui.Create("DFrame")
	frame:SetSize(w, h)
	frame:Center()
	frame:SetTitle(LANG.GetTranslation("shop_edit_items"))
	frame:SetVisible(true)
	frame:SetDraggable(true)
	frame:ShowCloseButton(true)
	frame:SetMouseInputEnabled(true)

	frame.Paint = function(slf, w2, h2)
		draw.RoundedBox(0, 0, 0, w2, h2, itemBoxColor)
	end

	frame.OnClose = function(slf)
		ply.shopeditor_itemframes = nil
	end

	local tmp = {}

	for key, data in pairs(ShopEditor.savingKeys) do
		local el

		if data.typ == "number" then
			local max = data.bits and (2 ^ data.bits - 1) or 65535

			local slider = vgui.Create("DNumSliderWang", frame)
			slider:SetSize(w, 20)
			slider:SetMin(0)
			slider:SetMax(max)
			slider:SetDecimals(0)
			slider:SetAutoFocus(true)

			el = slider
		elseif data.typ == "bool" then
			local checkbox = vgui.Create("DCheckBoxLabel", frame)

			el = checkbox
		end

		el:SetText("." .. key)
		el:SetValue(item[key])
		el:Dock(TOP)
		el:DockMargin(4, 0, 0, 0)

		if data.typ == "bool" then
			el:SizeToContents()
		end

		tmp[key] = el
	end

	-- save button
	local saveButton = vgui.Create("DButton", frame)
	saveButton:SetFont("Trebuchet22")
	saveButton:SetText(LANG.GetTranslation("button_save"))
	saveButton:Dock(BOTTOM)

	saveButton.DoClick = function()
		local wTable = {
			id = item.id,
			name = item.name
		}

		for key, data in pairs(ShopEditor.savingKeys) do
			if wTable[key] then continue end

			if IsValid(tmp[key]) then
				if data.typ == "number" then
					wTable[key] = math.Round(tmp[key]:GetValue())
				elseif data.typ == "bool" then
					wTable[key] = tmp[key]:GetChecked()
				else
					wTable[key] = tmp[key]:GetValue()
				end
			else
				wTable[key] = item[key]
			end
		end

		ShopEditor.WriteItemData("TTT2SESaveItem", wTable.id, wTable)
	end

	frame:MakePopup()
	frame:SetKeyboardInputEnabled(false)

	ply.shopeditor_itemframes = frame
end

net.Receive("TTT2SESaveItem", function()
	ShopEditor.ReadItemData()
end)

---
-- Creates the list of @{ITEM}s and @{Weapon}s
-- @realm client
-- @internal
function ShopEditor.CreateItemEditor()
	local ply = LocalPlayer()
	local w, h = ScrW() - 100, ScrH() - 100

	local frame = vgui.Create("ShopEditorChildFrame")
	frame:SetPrevFunc(function()
		if IsValid(ply.shopeditor_frame) then
			ply.shopeditor_frame:Close()
		end

		ply.shopeditor_frame = nil

		ShopEditor.CreateShopEditor()
	end)

	frame:SetSize(w, h)
	frame:Center()
	frame:SetTitle(LANG.GetTranslation("shop_editor_title") .. " -> " .. LANG.GetTranslation("shop_edit_items"))
	frame:SetVisible(true)
	frame:SetDraggable(true)
	frame:ShowCloseButton(true)
	frame:SetMouseInputEnabled(true)

	frame.Paint = function(slf, w2, h2)
		draw.RoundedBox(0, 0, 0, w2, h2, itemBoxColor)
	end

	frame.OnClose = function(slf)
		ply.shopeditor_frame = nil

		if IsValid(ply.shopeditor_itemframes) then
			ply.shopeditor_itemframes:Close()
		end

		ply.shopeditor_itemframes = nil
		ply.shopeditor = nil
	end

	local itms = ShopEditor.GetEquipmentForRoleAll()

	SortEquipmentTable(itms)

	ShopEditor.CreateItemList(frame, w, h, itms, function(s)
		ShopEditor.EditItem(s.item)
	end)

	frame:MakePopup()
	frame:SetKeyboardInputEnabled(false)

	ply.shopeditor_frame = frame
end

-- SHOP LINKER

---
-- Creates a list of @{ROLE}s
-- @param Panel frame
-- @param number w width
-- @param number h height
-- @param table rls @{table} of @{ROLE}s
-- @param function onClick
-- @param ROLE defaultRoleData
-- @return Panel dlist
-- @realm client
-- @internal
function ShopEditor.CreateRolesList(frame, w, h, rls, onClick, defaultRoleData)
	-- Construct icon listing
	local dlist = vgui.Create("EquipSelect", frame)
	dlist:SetPos(0, 25)
	dlist:SetSize(w, h - 45)
	dlist:EnableVerticalScrollbar(true)
	dlist:EnableHorizontal(true)
	dlist:SetPadding(4)

	for _, roleData in pairs(rls) do
		local ic = vgui.Create("SimpleRoleIcon", dlist)

		ic:SetIcon("vgui/ttt/dynamic/icon_base")
		ic:SetIconSize(64)
		ic:SetIconColor(roleData.color)

		ic.Icon:SetImage2("vgui/ttt/dynamic/icon_base_base")
		ic.Icon:SetImageOverlay("vgui/ttt/dynamic/icon_base_base_overlay")

		ic.roleData = roleData

		if defaultRoleData and roleData == defaultRoleData then
			ic.Icon:SetRoleIconImage("vgui/ttt/dynamic/roles/icon_shop_custom")
			ic:SetTooltip(SafeTranslate("create_own_shop"))
		else
			if roleData.name == SHOP_DISABLED then
				ic.Icon:SetRoleIconImage("vgui/ttt/dynamic/roles/icon_disabled")
				ic:SetTooltip(SafeTranslate("shop_disabled"))
			elseif roleData.name == SHOP_UNSET then
				ic.Icon:SetRoleIconImage("vgui/ttt/dynamic/roles/icon_shop_default")
				ic:SetTooltip(SafeTranslate("shop_default"))
			else
				ic.Icon:SetRoleIconImage(roleData.icon)
				ic:SetTooltip(SafeTranslate("shop_link") .. ": " .. SafeTranslate(roleData.name))
			end
		end

		dlist:AddPanel(ic)

		local oldFn = ic.OnMousePressed

		ic.OnMousePressed = function(slf, mcode)
			if mcode == MOUSE_LEFT then
				onClick(slf)
			end

			oldFn(slf)
		end
	end

	return dlist
end

---
-- Creates the shop editor @{Panel} for a specific @{ROLE}
-- @param ROLE roleData
-- @param function onCreate
-- @realm client
-- @internal
function ShopEditor.CreateOwnShopEditor(roleData, onCreate)
	local ply = LocalPlayer()
	local w, h = ScrW() - 100, ScrH() - 100

	local frame = vgui.Create("ShopEditorChildFrame")
	frame:SetPrevFunc(function()
		if IsValid(ply.shopeditor_frame) then
			ply.shopeditor_frame:Close()
		end

		ply.shopeditor_frame = nil

		ShopEditor.CreateLinkWithRole(roleData)
	end)

	frame:SetSize(w, h)
	frame:Center()
	frame:SetTitle(LANG.GetTranslation("shop_editor_title") .. " -> " .. LANG.GetParamTranslation("shop_selected", {role = roleData.name}) .. " -> " .. LANG.GetTranslation("shop_create_shop"))
	frame:SetVisible(true)
	frame:SetDraggable(true)
	frame:ShowCloseButton(true)
	frame:SetMouseInputEnabled(true)

	frame.Paint = function(slf, w2, h2)
		draw.RoundedBox(0, 0, 0, w2, h2, itemBoxColor)
	end

	frame.OnClose = function(slf)
		ply.shopeditor_frame = nil
		ply.shopeditor = nil
	end

	local itms = ShopEditor.GetEquipmentForRoleAll()

	SortEquipmentTable(itms)

	ShopEditor.CreateItemList(frame, w, h, itms, function(slf)
		local eq = not items.IsItem(slf.item) and weapons.GetStored(slf.item.id) or items.GetStored(slf.item.id)
		if not eq then return end

		eq.CanBuy = eq.CanBuy or {}

		if eq.CanBuy[roleData.index] then
			eq.CanBuy[roleData.index] = nil

			-- remove
			net.Start("shop")
			net.WriteBool(false)
			net.WriteUInt(roleData.index, ROLE_BITS)
			net.WriteString(eq.id)
			net.SendToServer()
		else
			eq.CanBuy[roleData.index] = roleData.index

			-- add
			net.Start("shop")
			net.WriteBool(true)
			net.WriteUInt(roleData.index, ROLE_BITS)
			net.WriteString(eq.id)
			net.SendToServer()
		end
	end,
	function(slf)
		for _, v in pairs(slf:GetItems()) do
			local eq = not items.IsItem(v.item) and weapons.GetStored(v.item.id) or items.GetStored(v.item.id)
			if not eq then continue end

			eq.CanBuy = eq.CanBuy or {}

			if eq.CanBuy[roleData.index] then
				v:Toggle(true)
			else
				v:Toggle(false)
			end
		end
	end)

	if ply.shopeditor then
		ply.shopeditor.selectedRole = roleData.index
	end

	frame:MakePopup()
	frame:SetKeyboardInputEnabled(false)

	if onCreate then
		onCreate()
	end

	ply.shopeditor_frame = frame
end

---
-- Creates another list of @{ROLE}s without the last selected @{ROLE}
-- @param ROLE roleData
-- @realm client
-- @internal
function ShopEditor.CreateLinkWithRole(roleData)
	local ply = LocalPlayer()
	local w, h = ScrW() - 100, ScrH() / 3

	local frame = vgui.Create("ShopEditorChildFrame")
	frame:SetPrevFunc(function()
		if IsValid(ply.shopeditor_frame) then
			ply.shopeditor_frame:Close()
		end

		ply.shopeditor_frame = nil

		ShopEditor.CreateShopLinker()
	end)
	frame:SetSize(w, h)
	frame:Center()
	frame:SetTitle(LANG.GetTranslation("shop_editor_title") .. " -> " .. LANG.GetParamTranslation("shop_selected", {role = roleData.name}) .. " -> " .. LANG.GetTranslation("shop_edit_shop"))
	frame:SetVisible(true)
	frame:SetDraggable(true)
	frame:ShowCloseButton(true)
	frame:SetMouseInputEnabled(true)

	frame.Paint = function(slf, w2, h2)
		draw.RoundedBox(0, 0, 0, w2, h2, itemBoxColor)
	end

	frame.OnClose = function(slf)
		ply.shopeditor_frame = nil
		ply.shopeditor = nil
	end

	local rls = roles.GetSortedRoles()

	table.insert(rls, 1, {name = SHOP_UNSET, abbr = "shop_default", color = roleData.color})
	table.insert(rls, 1, {name = SHOP_DISABLED, abbr = "disable", color = roleData.color})

	-- remove none role and own shop (to change the position)
	local i = 0

	while i < #rls do
		i = i + 1

		local index = rls[i].index

		if index == ROLE_NONE or index == roleData.index then
			table.remove(rls, i)

			i = i - 1
		end
	end

	-- add the own shop into the first position
	table.insert(rls, 1, roleData)

	local dlist = ShopEditor.CreateRolesList(frame, w, h, rls, function(s)
		local oldFallback = GetGlobalString("ttt_" .. roleData.abbr .. "_shop_fallback")

		if s.roleData.name == SHOP_DISABLED or s.roleData.name == SHOP_UNSET or s.roleData.name ~= roleData.name then
			if s.roleData.name ~= oldFallback then
				net.Start("shopFallback")
				net.WriteUInt(roleData.index, ROLE_BITS)
				net.WriteString(s.roleData.name)
				net.SendToServer()
			end

			if IsValid(frame) then
				frame:Close()
			end

			ShopEditor.CreateShopEditor()
		else -- own shop
			if IsValid(frame) then
				frame:Close()
			end

			ShopEditor.CreateOwnShopEditor(roleData, function()
				if s.roleData.name ~= oldFallback then
					net.Start("shopFallback")
					net.WriteUInt(roleData.index, ROLE_BITS)
					net.WriteString(s.roleData.name)
					net.SendToServer()
				else
					ShopEditor.ShopFallbackRefresh()
				end
			end)
		end
	end, roleData)

	if dlist then
		local oldFallback = GetGlobalString("ttt_" .. roleData.abbr .. "_shop_fallback")

		for _, v in pairs(dlist:GetItems()) do
			if v.roleData.name == oldFallback then
				v:Toggle(true)
			end
		end
	end

	frame:MakePopup()
	frame:SetKeyboardInputEnabled(false)

	ply.shopeditor_frame = frame
end

---
-- Creates the first instance of @{ROLE} selection for the shop linking
-- @realm client
-- @internal
function ShopEditor.CreateShopLinker()
	local ply = LocalPlayer()
	local w, h = ScrW() - 100, ScrH() / 3

	local frame = vgui.Create("ShopEditorChildFrame")
	frame:SetPrevFunc(function()
		if IsValid(ply.shopeditor_frame) then
			ply.shopeditor_frame:Close()
		end

		ply.shopeditor_frame = nil

		ShopEditor.CreateShopEditor()
	end)
	frame:SetSize(w, h)
	frame:Center()
	frame:SetTitle(LANG.GetTranslation("shop_editor_title") .. " -> " .. LANG.GetTranslation("shop_select_role"))
	frame:SetVisible(true)
	frame:SetDraggable(true)
	frame:ShowCloseButton(true)
	frame:SetMouseInputEnabled(true)

	frame.Paint = function(slf, w2, h2)
		draw.RoundedBox(0, 0, 0, w2, h2, itemBoxColor)
	end

	frame.OnClose = function(slf)
		ply.shopeditor_frame = nil
	end

	local rls = roles.GetSortedRoles()

	-- remove none role
	for k = 1, #rls do
		if rls[k].index == ROLE_NONE then
			table.remove(rls, k)

			break
		end
	end

	ShopEditor.CreateRolesList(frame, w, h, rls, function(s)
		if IsValid(ply.shopeditor_frame) then
			ply.shopeditor_frame:Close()
		end

		ShopEditor.CreateLinkWithRole(s.roleData)
	end)

	frame:MakePopup()
	frame:SetKeyboardInputEnabled(false)

	ply.shopeditor_frame = frame
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

---
-- Refreshes the shop and toggles (de-/activates) the items
-- @realm client
-- @internal
function ShopEditor.ShopFallbackRefresh()
	local wshop = LocalPlayer().shopeditor

	-- Refresh F1 menu to show actual custom shop after ShopFallbackRefresh
	if ShopEditor.customShopRefresh then
		ShopEditor.customShopRefresh = false
		vguihandler.Rebuild()
	end

	-- Old Shopeditor refresh
	if not wshop or not wshop.GetItems or not wshop.selectedRole then return end

	for _, v in pairs(wshop:GetItems()) do
		if not v.item then continue end

		local equip = not items.IsItem(v.item.id) and weapons.GetStored(v.item.id) or items.GetStored(v.item.id)

		if not equip then continue end

		equip.CanBuy = equip.CanBuy or {}

		if equip.CanBuy[wshop.selectedRole] then
			v:Toggle(true)
		else
			v:Toggle(false)
		end
	end
end
net.Receive("shopFallbackRefresh", ShopEditor.ShopFallbackRefresh)

-- OPTION WINDOW

---
-- Creates the option @{Panel} for the shop editor
-- @realm client
-- @internal
function ShopEditor.ShowOptions()
	local ply = LocalPlayer()
	local w, h = ScrW() * 0.5, ScrH() * 0.5

	local frame = vgui.Create("ShopEditorChildFrame")
	frame:SetPrevFunc(function()
		if IsValid(ply.shopeditor_frame) then
			ply.shopeditor_frame:Close()
		end

		ply.shopeditor_frame = nil

		ShopEditor.CreateShopEditor()
	end)

	frame:SetSize(w, h)
	frame:Center()
	frame:SetTitle(LANG.GetTranslation("shop_editor_title") .. " -> " .. LANG.GetTranslation("shop_settings"))
	frame:SetVisible(true)
	frame:SetDraggable(true)
	frame:ShowCloseButton(true)
	frame:SetMouseInputEnabled(true)

	frame.Paint = function(slf, w2, h2)
		draw.RoundedBox(0, 0, 0, w2, h2, itemBoxColor)
	end

	frame.OnClose = function(slf)
		ply.shopeditor_frame = nil
	end

	local help = vgui.Create("DLabel", frame)
	help:SetText(LANG.GetTranslation("shop_settings_desc"))
	help:DockMargin(20, 0, 0, 0)
	help:SetFont("DermaDefaultBold")
	help:SetSize(w, 50)
	help:Dock(TOP)

	local tmp = {}

	for key, data in pairs(ShopEditor.cvars) do
		local el

		if data.typ == "number" then
			local max = data.bits and (2 ^ data.bits - 1) or 65535

			local slider = vgui.Create("DNumSliderWang", frame)
			slider:SetSize(100, 20)
			slider:SetMin(0)
			slider:SetMax(max)
			slider:SetDecimals(0)
			slider:SetAutoFocus(true)

			el = slider
		elseif data.typ == "bool" then
			local checkbox = vgui.Create("DCheckBoxLabel", frame)

			el = checkbox
		end

		el:SetText(key)
		el:SetValue(GetGlobalInt(key))
		el:Dock(TOP)
		el:DockMargin(4, 0, 0, 0)

		if data.typ == "bool" then
			el:SizeToContents()
		end

		tmp[key] = el

		local space = vgui.Create("DLabel", frame)
		space:SetText("")
		space:Dock(TOP)
		space:SetSize(20, 10)
	end

	-- save button
	local saveButton = vgui.Create("DButton", frame)
	saveButton:SetFont("Trebuchet22")
	saveButton:SetText(LANG.GetTranslation("button_save"))
	saveButton:Dock(BOTTOM)

	saveButton.DoClick = function()
		for key, data in pairs(ShopEditor.cvars) do
			if not IsValid(tmp[key]) then continue end

			net.Start("TTT2UpdateCVar")
			net.WriteString(key)

			if data.typ == "number" then
				net.WriteString(tostring(math.Round(tmp[key]:GetValue())))
			elseif data.typ == "bool" then
				net.WriteString(tmp[key]:GetChecked() and "1" or "0")
			else
				net.WriteString(tmp[key]:GetValue())
			end

			net.SendToServer()
		end
	end

	frame:MakePopup()
	frame:SetKeyboardInputEnabled(false)

	ply.shopeditor_frame = frame
end

-- MAIN WINDOW

---
-- Creates the main instance of the shop editor
-- @realm client
function ShopEditor.CreateShopEditor()
	local ply = LocalPlayer()

	if IsValid(ply.shopeditor_frame) then
		ply.shopeditor_frame:Close()

		ply.shopeditor_frame = nil -- fix some edge cases

		return
	end

	local w, h = ScrW() - 100, 200
	local topP = 25

	local frame = vgui.Create("DFrame")
	frame:SetSize(w, h)
	frame:Center()
	frame:SetTitle(LANG.GetTranslation("shop_editor_title"))
	frame:SetVisible(true)
	frame:SetDraggable(true)
	frame:ShowCloseButton(true)
	frame:SetMouseInputEnabled(true)

	frame.Paint = function(slf, w2, h2)
		draw.RoundedBox(0, 0, 0, w2, h2, itemBoxColor)
	end

	frame.OnClose = function(slf)
		ply.shopeditor_frame = nil
	end

	h = h - topP

	local wMul = w / 3

	local buttonEditItems = vgui.Create("DButton", frame)
	buttonEditItems:SetText(LANG.GetTranslation("shop_edit_items_weapong"))
	buttonEditItems:SetPos(0, topP)
	buttonEditItems:SetSize(wMul, h)

	buttonEditItems.DoClick = function()
		frame:Close()

		ShopEditor.CreateItemEditor()
	end

	local buttonLinkShops = vgui.Create("DButton", frame)
	buttonLinkShops:SetText(LANG.GetTranslation("shop_edit"))
	buttonLinkShops:SetPos(wMul, topP)
	buttonLinkShops:SetSize(wMul, h)

	buttonLinkShops.DoClick = function()
		frame:Close()

		ShopEditor.CreateShopLinker()
	end

	local buttonOptions = vgui.Create("DButton", frame)
	buttonOptions:SetText(LANG.GetTranslation("shop_settings"))
	buttonOptions:SetPos(wMul * 2, topP)
	buttonOptions:SetSize(wMul, h)

	buttonOptions.DoClick = function()
		frame:Close()

		ShopEditor.ShowOptions()
	end

	frame:MakePopup()
	frame:SetKeyboardInputEnabled(false)

	ply.shopeditor_frame = frame
end
net.Receive("newshop", ShopEditor.CreateShopEditor)
