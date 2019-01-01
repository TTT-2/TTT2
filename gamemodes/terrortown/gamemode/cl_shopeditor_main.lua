ttt_include("vgui__shopeditor_buttons")
ttt_include("vgui__shopeditor_slider")

local COLOR_GREY = COLOR_GREY or Color(120, 120, 120, 255)

local Equipmentnew
local SafeTranslate = LANG.TryTranslation

local math = math
local table = table
local net = net
local pairs = pairs
local ipairs = ipairs
local IsValid = IsValid

function ShopEditor.ItemIsWeapon(item)
	return not tonumber(item.id)
end

function ShopEditor.GetEquipmentForRoleAll()
	-- need to build equipment cache?
	if not Equipmentnew then
		-- start with all the non-weapon goodies
		local tbl = ALL_ITEMS

		local eject = {
			"weapon_fists",
			"weapon_ttt_unarmed",
			"weapon_zm_carry",
			"bobs_blacklisted"
		}

		hook.Run("TTT2ModifyShopEditorIgnoreSWEPs", eject) -- possibility to modify from externally

		-- find buyable weapons to load info from
		for _, v in ipairs(weapons.GetList()) do
			local name = WEPS.GetClass(v)

			if name
			and not v.Doublicated
			and not string.match(name, "base")
			and not string.match(name, "event")
			and not table.HasValue(eject, name)
			then
				table.insert(tbl, v)
			end
		end

		Equipmentnew = tbl
	end

	return Equipmentnew
end

function ShopEditor.CreateItemList(frame, w, h, items, onClick, updateListItems)
	if not items or not onClick and not updateListItems then return end

	local ply = LocalPlayer()

	-- Construct icon listing
	local dlist = vgui.Create("EquipSelect", frame)
	dlist:SetPos(0, 25)
	dlist:SetSize(w, h - 45)
	dlist:EnableVerticalScrollbar(true)
	dlist:EnableHorizontal(true)
	dlist:SetPadding(4)

	for _, item in pairs(items) do
		local ic

		-- Create icon panel
		if item.material and item.material ~= "vgui/ttt/icon_id" then
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
			ic:SetIcon(item.material)
		elseif item.model and item.model ~= "models/weapons/w_bugbait.mdl" then
			ic = vgui.Create("SpawnIcon", dlist)
			ic:SetModel(item.model)
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

			local tip = GetEquipmentTranslation(item.name, item.PrintName) .. " (" .. SafeTranslate(item.type) .. ")"

			ic:SetTooltip(tip)

			dlist:AddPanel(ic)
		end
	end

	ply.shopeditor = dlist

	return dlist
end

-- ITEM EDITOR

function ShopEditor.EditItem(item)
	local ply = LocalPlayer()

	if IsValid(ply.shopeditor_itemframes) then
		ply.shopeditor_itemframes:Close()
	end

	local w, h = ScrW() / 4, ScrH() / 4

	local frame = vgui.Create("DFrame")
	frame:SetSize(w, h)
	frame:Center()
	frame:SetTitle("Item Editor")
	frame:SetVisible(true)
	frame:SetDraggable(true)
	frame:ShowCloseButton(true)
	frame:SetMouseInputEnabled(true)

	function frame:Paint(w2, h2)
		draw.RoundedBox(0, 0, 0, w2, h2, Color(100, 100, 100))
	end

	function frame:OnClose()
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
	saveButton:SetText("Save")
	saveButton:SizeToContents()

	saveButton.DoClick = function()
		local wTable = {
			id = item.id,
			name = item.name
		}

		for key, data in pairs(ShopEditor.savingKeys) do
			if not wTable[key] then
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
		end

		local name

		if tonumber(wTable.id) then
			name = wTable.name
		else
			name = wTable.id
		end

		if name then
			ShopEditor.WriteItemData("TTT2SESaveItem", name, wTable)
		end
	end

	frame:MakePopup()
	frame:SetKeyboardInputEnabled(false)

	ply.shopeditor_itemframes = frame
end

net.Receive("TTT2SESaveItem", function()
	ShopEditor.ReadItemData()
end)

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
	frame:SetTitle("Shop Editor -> Edit Items")
	frame:SetVisible(true)
	frame:SetDraggable(true)
	frame:ShowCloseButton(true)
	frame:SetMouseInputEnabled(true)

	function frame:Paint(w2, h2)
		draw.RoundedBox(0, 0, 0, w2, h2, Color(100, 100, 100))
	end

	function frame:OnClose()
		ply.shopeditor_frame = nil

		if IsValid(ply.shopeditor_itemframes) then
			ply.shopeditor_itemframes:Close()
		end

		ply.shopeditor_itemframes = nil
		ply.shopeditor = nil
	end

	local items = ShopEditor.GetEquipmentForRoleAll()

	SortEquipmentTable(items)

	ShopEditor.CreateItemList(frame, w, h, items, function(s)
		ShopEditor.EditItem(s.item)
	end)

	frame:MakePopup()
	frame:SetKeyboardInputEnabled(false)

	ply.shopeditor_frame = frame
end

-- SHOP LINKER
function ShopEditor.CreateRolesList(frame, w, h, roles, onClick, defaultRoleData)
	-- Construct icon listing
	local dlist = vgui.Create("EquipSelect", frame)
	dlist:SetPos(0, 25)
	dlist:SetSize(w, h - 45)
	dlist:EnableVerticalScrollbar(true)
	dlist:EnableHorizontal(true)
	dlist:SetPadding(4)

	for _, roleData in pairs(roles) do
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
				ic.Icon:SetRoleIconImage("vgui/ttt/dynamic/roles/icon_" .. roleData.abbr)
				ic:SetTooltip(SafeTranslate("shop_link") .. ": " .. SafeTranslate(roleData.name))
			end
		end

		dlist:AddPanel(ic)

		local oldFn = ic.OnMousePressed
		function ic:OnMousePressed(mcode)
			if mcode == MOUSE_LEFT then
				onClick(self)
			end

			oldFn(self)
		end
	end

	return dlist
end

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
	frame:SetTitle("Shop Editor -> Selected " .. roleData.name .. " -> Create Own Shop")
	frame:SetVisible(true)
	frame:SetDraggable(true)
	frame:ShowCloseButton(true)
	frame:SetMouseInputEnabled(true)

	function frame:Paint(w2, h2)
		draw.RoundedBox(0, 0, 0, w2, h2, Color(100, 100, 100))
	end

	function frame:OnClose()
		ply.shopeditor_frame = nil
		ply.shopeditor = nil
	end

	local items = ShopEditor.GetEquipmentForRoleAll()

	SortEquipmentTable(items)

	ShopEditor.CreateItemList(frame, w, h, items, function(slf)
		if tonumber(slf.item.id) then -- is item ?
			EquipmentItems[roleData.index] = EquipmentItems[roleData.index] or {}

			if EquipmentTableHasValue(EquipmentItems[roleData.index], slf.item) then
				for k, eq in pairs(EquipmentItems[roleData.index]) do
					if eq.id == slf.item.id then
						table.remove(EquipmentItems[roleData.index], k)

						break
					end
				end

				-- remove
				net.Start("shop")
				net.WriteBool(false)
				net.WriteUInt(roleData.index, ROLE_BITS)
				net.WriteString(slf.item.name)
				net.SendToServer()
			else
				table.insert(EquipmentItems[roleData.index], slf.item)

				-- add
				net.Start("shop")
				net.WriteBool(true)
				net.WriteUInt(roleData.index, ROLE_BITS)
				net.WriteString(slf.item.name)
				net.SendToServer()
			end
		else
			local wep = weapons.GetStored(slf.item.id)
			if wep then
				wep.CanBuy = wep.CanBuy or {}

				if table.HasValue(wep.CanBuy, roleData.index) then
					for k, v in ipairs(wep.CanBuy) do
						if v == roleData.index then
							table.remove(wep.CanBuy, k)

							break
						end
					end

					-- remove
					net.Start("shop")
					net.WriteBool(false)
					net.WriteUInt(roleData.index, ROLE_BITS)
					net.WriteString(wep.id)
					net.SendToServer()
				else
					table.insert(wep.CanBuy, roleData.index)

					-- add
					net.Start("shop")
					net.WriteBool(true)
					net.WriteUInt(roleData.index, ROLE_BITS)
					net.WriteString(wep.id)
					net.SendToServer()
				end
			end
		end
	end,
	function(slf)
		for _, v in pairs(slf:GetItems()) do
			local is_item = tonumber(v.item.id)
			if is_item then
				EquipmentItems[roleData.index] = EquipmentItems[roleData.index] or {}

				if EquipmentTableHasValue(EquipmentItems[roleData.index], v.item) then
					v:Toggle(true)
				else
					v:Toggle(false)
				end
			else
				local wep = weapons.GetStored(v.item.id)
				if wep then
					wep.CanBuy = wep.CanBuy or {}

					if table.HasValue(wep.CanBuy, roleData.index) then
						v:Toggle(true)
					else
						v:Toggle(false)
					end
				end
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
	frame:SetTitle("Shop Editor -> Selected " .. roleData.name .. " -> Edit Shop")
	frame:SetVisible(true)
	frame:SetDraggable(true)
	frame:ShowCloseButton(true)
	frame:SetMouseInputEnabled(true)

	function frame:Paint(w2, h2)
		draw.RoundedBox(0, 0, 0, w2, h2, Color(100, 100, 100))
	end

	function frame:OnClose()
		ply.shopeditor_frame = nil
		ply.shopeditor = nil
	end

	local roles = GetSortedRoles()

	table.insert(roles, 1, {name = SHOP_UNSET, abbr = "shop_default", color = roleData.color})
	table.insert(roles, 1, {name = SHOP_DISABLED, abbr = "disable", color = roleData.color})

	-- remove innocents
	local key

	for k, v in ipairs(roles) do
		if v == INNOCENT then
			key = k
		end
	end

	table.remove(roles, key)

	-- change position of own shop
	for k, v in ipairs(roles) do
		if v == roleData then
			key = k
		end
	end

	table.remove(roles, key)

	table.insert(roles, 1, roleData)

	local dlist = ShopEditor.CreateRolesList(frame, w, h, roles, function(s)
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
					ShopEditor.shopFallbackRefresh()
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
	frame:SetTitle("Shop Editor -> Select Role")
	frame:SetVisible(true)
	frame:SetDraggable(true)
	frame:ShowCloseButton(true)
	frame:SetMouseInputEnabled(true)

	function frame:Paint(w2, h2)
		draw.RoundedBox(0, 0, 0, w2, h2, Color(100, 100, 100))
	end

	function frame:OnClose()
		ply.shopeditor_frame = nil
	end

	local roles = GetSortedRoles()

	local key

	for k, v in ipairs(roles) do
		if v == INNOCENT then
			key = k
		end
	end

	table.remove(roles, key)

	ShopEditor.CreateRolesList(frame, w, h, roles, function(s)
		if IsValid(ply.shopeditor_frame) then
			ply.shopeditor_frame:Close()
		end

		ShopEditor.CreateLinkWithRole(s.roleData)
	end)

	frame:MakePopup()
	frame:SetKeyboardInputEnabled(false)

	ply.shopeditor_frame = frame
end

function ShopEditor.shopFallbackAnsw(len)
	local subrole = net.ReadUInt(ROLE_BITS)
	local fb = net.ReadString()

	-- reset everything
	EquipmentItems[subrole] = {}
	Equipment[subrole] = {}

	for _, v in ipairs(weapons.GetList()) do
		if v.CanBuy then
			for k, vi in ipairs(v.CanBuy) do
				if vi == subrole then
					table.remove(v.CanBuy, k) -- TODO does it work?

					break
				end
			end
		end
	end

	if fb == SHOP_UNSET then
		local roleData = GetRoleByIndex(subrole)
		if roleData.fallbackTable then
			-- set everything
			for _, eq in ipairs(roleData.fallbackTable) do
				local is_item = tonumber(eq.id)
				if is_item then
					table.insert(EquipmentItems[subrole], eq)
				else
					local wep = weapons.GetStored(eq.id)
					if wep then
						wep.CanBuy = wep.CanBuy or {}

						table.insert(wep.CanBuy, subrole)
					end
				end

				table.insert(Equipment[subrole], eq)
			end
		end
	end
end
net.Receive("shopFallbackAnsw", ShopEditor.shopFallbackAnsw)

function ShopEditor.shopFallbackReset(len)
	for _, v in ipairs(weapons.GetList()) do
		v.CanBuy = {}
	end

	for _, rd in pairs(GetRoles()) do
		local subrole = rd.index
		local fb = GetGlobalString("ttt_" .. rd.abbr .. "_shop_fallback")

		-- reset everything
		EquipmentItems[subrole] = {}
		Equipment[subrole] = {}

		if fb == SHOP_UNSET then
			local roleData = GetRoleByIndex(subrole)
			if roleData.fallbackTable then
				-- set everything
				for _, eq in ipairs(roleData.fallbackTable) do
					local is_item = tonumber(eq.id)
					if is_item then
						table.insert(EquipmentItems[subrole], eq)
					else
						local wepTbl = weapons.GetStored(eq.id)
						if wepTbl then
							wepTbl.CanBuy = wepTbl.CanBuy or {}

							table.insert(wepTbl.CanBuy, subrole)
						end
					end

					table.insert(Equipment[subrole], eq)
				end
			end
		end
	end
end
net.Receive("shopFallbackReset", ShopEditor.shopFallbackReset)

function ShopEditor.shopFallbackRefresh()
	local wshop = LocalPlayer().shopeditor

	if wshop and wshop.GetItems then
		if not wshop.selectedRole then return end

		for _, v in pairs(wshop:GetItems()) do
			if v.item then
				local is_item = tonumber(v.item.id)
				if is_item then
					EquipmentItems[wshop.selectedRole] = EquipmentItems[wshop.selectedRole] or {}

					if EquipmentTableHasValue(EquipmentItems[wshop.selectedRole], v.item) then
						v:Toggle(true)
					else
						v:Toggle(false)
					end
				else
					local wep = weapons.GetStored(v.item.id)
					if wep then
						wep.CanBuy = wep.CanBuy or {}

						if table.HasValue(wep.CanBuy, wshop.selectedRole) then
							v:Toggle(true)
						else
							v:Toggle(false)
						end
					end
				end
			end
		end
	end
end
net.Receive("shopFallbackRefresh", ShopEditor.shopFallbackRefresh)

-- OPTION WINDOW
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
	frame:SetTitle("Shop Editor -> Options")
	frame:SetVisible(true)
	frame:SetDraggable(true)
	frame:ShowCloseButton(true)
	frame:SetMouseInputEnabled(true)

	function frame:Paint(w2, h2)
		draw.RoundedBox(0, 0, 0, w2, h2, Color(100, 100, 100))
	end

	function frame:OnClose()
		ply.shopeditor_frame = nil
	end

	local tmp = {}
	local tbl = {
		ttt2_random_shops = {typ = "number"}
	}

	for key, data in pairs(tbl) do
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

		el:SetText("ConVar: " .. key)
		el:SetValue(GetGlobalInt(key))
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
	saveButton:SetText("Save")
	saveButton:Dock(BOTTOM)

	saveButton.DoClick = function()
		for key, data in pairs(tbl) do
			net.Start("TTT2UpdateCVar")
			net.WriteString(key)

			if IsValid(tmp[key]) then
				if data.typ == "number" then
					net.WriteString(tostring(math.Round(tmp[key]:GetValue())))
				elseif data.typ == "bool" then
					net.WriteString(tostring(tonumber(tmp[key]:GetChecked())))
				else
					net.WriteString(tmp[key]:GetValue())
				end
			end

			net.SendToServer()
		end
	end

	frame:MakePopup()
	frame:SetKeyboardInputEnabled(false)

	ply.shopeditor_frame = frame
end

-- MAIN WINDOW

function ShopEditor.CreateShopEditor()
	local ply = LocalPlayer()

	if IsValid(ply.shopeditor_frame) then
		ply.shopeditor_frame:Close()

		return
	end

	local w, h = ScrW() - 100, 200
	local topP = 25

	local frame = vgui.Create("DFrame")
	frame:SetSize(w, h)
	frame:Center()
	frame:SetTitle("Shop Editor")
	frame:SetVisible(true)
	frame:SetDraggable(true)
	frame:ShowCloseButton(true)
	frame:SetMouseInputEnabled(true)

	function frame:Paint(w2, h2)
		draw.RoundedBox(0, 0, 0, w2, h2, Color(100, 100, 100))
	end

	function frame:OnClose()
		ply.shopeditor_frame = nil
	end

	h = h - topP

	local wMul = w / 3

	local buttonEditItems = vgui.Create("DButton", frame)
	buttonEditItems:SetText("Edit Items / Weapons")
	buttonEditItems:SetPos(0, topP)
	buttonEditItems:SetSize(wMul, h)

	buttonEditItems.DoClick = function()
		frame:Close()

		ShopEditor.CreateItemEditor()
	end

	local buttonLinkShops = vgui.Create("DButton", frame)
	buttonLinkShops:SetText("Edit Shops")
	buttonLinkShops:SetPos(wMul, topP)
	buttonLinkShops:SetSize(wMul, h)

	buttonLinkShops.DoClick = function()
		frame:Close()

		ShopEditor.CreateShopLinker()
	end

	local buttonOptions = vgui.Create("DButton", frame)
	buttonOptions:SetText("Options")
	buttonOptions:SetPos(wMul * 2, topP)
	buttonOptions:SetSize(wMul, h)

	buttonOptions.DoClick = function()
		ShopEditor.ShowOptions()
	end

	frame:MakePopup()
	frame:SetKeyboardInputEnabled(false)

	ply.shopeditor_frame = frame
end
net.Receive("newshop", ShopEditor.CreateShopEditor)
