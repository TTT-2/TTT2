local Equipmentnew
local SafeTranslate = LANG.TryTranslation
local ShopEditor = {}

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
				local data = v.EquipMenuData or {}
				local base = {
					id = name,
					name = name,
					PrintName = data.name or data.PrintName or v.PrintName or name,
					limited = v.LimitedStock,
					kind = v.Kind or WEAPON_NONE,
					slot = (v.Slot or 0) + 1,
					material = v.Icon or "vgui/ttt/icon_id",
					-- the below should be specified in EquipMenuData, in which case
					-- these values are overwritten
					type = "Type not specified",
					model = "models/weapons/w_bugbait.mdl",
					desc = "No description specified."
				}

				-- Force material to nil so that model key is used when we are
				-- explicitly told to do so (ie. material is false rather than nil).
				if data.modelicon then
					base.material = nil
				end

				table.Merge(base, data)
				table.insert(tbl, base)
			end
		end

		Equipmentnew = tbl
	end

	return Equipmentnew
end

function ShopEditor.CreateShopEditor()
	local w, h = 500, 450

	local frame = vgui.Create("DFrame")
	frame:SetPos(50, 50)
	frame:SetSize(w, h)
	frame:SetTitle("Shop Editor")
	frame:SetVisible(true)
	frame:SetDraggable(true)
	frame:ShowCloseButton(true)
	frame:MakePopup()

	function frame:Paint(w2, h2)
		draw.RoundedBox(0, 0, 0, w2, h2, Color(100, 100, 100))
	end

	local wMul = w / 3

	local buttonEditItems = vgui.Create("DButton", frame)
	buttonEditItems:SetText("Edit Items")
	buttonEditItems:SetPos(0, 0)
	buttonEditItems:SetSize(wMul, 450)
	buttonEditItems.DoClick = function()
		RunConsoleCommand("say", "Hi")
	end

	local buttonOptions = vgui.Create("DButton", frame)
	buttonOptions:SetText("Options")
	buttonOptions:SetPos(wMul, 0)
	buttonOptions:SetSize(wMul, 450)
	buttonOptions.DoClick = function()
		RunConsoleCommand("say", "Hi")
	end

	local buttonLinkShops = vgui.Create("DButton", frame)
	buttonLinkShops:SetText("Link / Disable / Create")
	buttonLinkShops:SetPos(wMul * 2, 0)
	buttonLinkShops:SetSize(wMul, 450)
	buttonLinkShops.DoClick = function()
		RunConsoleCommand("say", "Hi")
	end
end
net.Receive("newshop", ShopEditor.CreateShopEditor)

function ShopEditor.newshop()
	local sr = GetShopRoles()[1]
	local selectedRole = sr.index
	local state = true
	local w, h = 500, 450
	local descW = 300

	local DermaPanel = vgui.Create("DFrame")
	DermaPanel:SetPos(50, 50)
	DermaPanel:SetSize(w + descW, h)
	DermaPanel:SetTitle("Shop Editor")
	DermaPanel:SetVisible(true)
	DermaPanel:SetDraggable(true)
	DermaPanel:ShowCloseButton(true)
	DermaPanel:MakePopup()

	function DermaPanel:Paint(w2, h2)
		draw.RoundedBox(0, 0, 0, w2, h2, Color(100, 100, 100))
	end

	function DermaPanel:OnClose()
		LocalPlayer().shopeditor = nil
	end

	local DScrollPanel = vgui.Create("DScrollPanel", DermaPanel)
	DScrollPanel:SetSize(w - 100, h - 45)
	DScrollPanel:Center()

	local sbar = DScrollPanel:GetVBar()
	function sbar:Paint(w2, h2)
		draw.RoundedBox(0, 0, 0, w2, h2, Color(0, 0, 0, 100))
	end

	function sbar.btnUp:Paint(w2, h2)
		draw.RoundedBox(0, 0, 0, w2, h2, Color(200, 100, 0))
	end

	function sbar.btnDown:Paint(w2, h2)
		draw.RoundedBox(0, 0, 0, w2, h2, Color(200, 100, 0))
	end

	function sbar.btnGrip:Paint(w2, h2)
		draw.RoundedBox(0, 0, 0, w2, h2, Color(100, 200, 0))
	end

	-- Construct icon listing
	local dlist = vgui.Create("EquipSelect", DermaPanel)
	dlist:SetPos(0, 20)
	dlist:SetSize(w, h - 45)
	dlist:EnableVerticalScrollbar(true)
	dlist:EnableHorizontal(true)
	dlist:SetPadding(4)

	dlist.selectedRole = selectedRole

	local menu = vgui.Create("DComboBox")
	menu:SetParent(DermaPanel)
	menu:SetPos(0, h - 25)
	menu:SetSize(w, 25)
	menu:SetValue(sr.name)

	for _, v in pairs(GetRoles()) do
		if v ~= INNOCENT then
			menu:AddChoice(v.name, v.index)
		end
	end

	local ply = LocalPlayer()
	local items = ShopEditor.GetEquipmentForRoleAll()

	SortEquipmentTable(items)

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
				slot:SetIconColor(sr.color or COLOR_GREY)
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

			function ic:UpdateCheck()
				if not dlist.selectedRole then return end

				local is_item = tonumber(ic.item.id)
				if is_item then
					EquipmentItems[dlist.selectedRole] = EquipmentItems[dlist.selectedRole] or {}

					if EquipmentTableHasValue(EquipmentItems[dlist.selectedRole], ic.item) then
						ic:Toggle(true)
					else
						ic:Toggle(false)
					end
				else
					local wepTbl = weapons.GetStored(ic.item.id)
					if wepTbl then
						wepTbl.CanBuy = wepTbl.CanBuy or {}

						if table.HasValue(wepTbl.CanBuy, dlist.selectedRole) then
							ic:Toggle(true)
						else
							ic:Toggle(false)
						end
					end
				end
			end

			ic.OnClick = function()
				if not dlist.selectedRole or not state then return end

				local is_item = tonumber(ic.item.id)
				if is_item then
					EquipmentItems[dlist.selectedRole] = EquipmentItems[dlist.selectedRole] or {}

					if EquipmentTableHasValue(EquipmentItems[dlist.selectedRole], ic.item) then
						for k, eq in pairs(EquipmentItems[dlist.selectedRole]) do
							if eq.id == ic.item.id then
								table.remove(EquipmentItems[dlist.selectedRole], k)

								break
							end
						end

						-- remove
						net.Start("shop")
						net.WriteBool(false)
						net.WriteUInt(dlist.selectedRole, ROLE_BITS)
						net.WriteString(ic.item.name)
						net.SendToServer()
					else
						table.insert(EquipmentItems[dlist.selectedRole], ic.item)

						-- add
						net.Start("shop")
						net.WriteBool(true)
						net.WriteUInt(dlist.selectedRole, ROLE_BITS)
						net.WriteString(ic.item.name)
						net.SendToServer()
					end
				else
					local wepTbl = weapons.GetStored(ic.item.id)
					if wepTbl then
						wepTbl.CanBuy = wepTbl.CanBuy or {}

						if table.HasValue(wepTbl.CanBuy, dlist.selectedRole) then
							for k, v in ipairs(wepTbl.CanBuy) do
								if v == dlist.selectedRole then
									table.remove(wepTbl.CanBuy, k)

									break
								end
							end

							-- remove
							net.Start("shop")
							net.WriteBool(false)
							net.WriteUInt(dlist.selectedRole, ROLE_BITS)
							net.WriteString(ic.item.id)
							net.SendToServer()
						else
							table.insert(wepTbl.CanBuy, dlist.selectedRole)

							-- add
							net.Start("shop")
							net.WriteBool(true)
							net.WriteUInt(dlist.selectedRole, ROLE_BITS)
							net.WriteString(ic.item.id)
							net.SendToServer()
						end
					end
				end

				for _, v in pairs(dlist:GetItems()) do
					if v.UpdateCheck then
						v:UpdateCheck()
					end
				end
			end

			local tip = GetEquipmentTranslation(item.name, item.PrintName) .. " (" .. SafeTranslate(item.type) .. ")"

			ic:SetTooltip(tip)

			dlist:AddPanel(ic)
		end
	end

	ply.shopeditor = dlist

	-- first init
	for _, v in pairs(dlist:GetItems()) do
		if v.UpdateCheck then
			v:UpdateCheck()
		end
	end

	-- draw settings
	local fbmenu = vgui.Create("DComboBox")
	fbmenu:SetParent(DermaPanel)
	fbmenu:SetPos(5 + w, 25)
	fbmenu:SetSize(descW - 10, 25)

	function fbmenu:RefreshChoices()
		-- clear old data
		self:Clear()

		local rd = GetRoleByIndex(dlist.selectedRole)
		local fallback = GetGlobalString("ttt_" .. rd.abbr .. "_shop_fallback")
		local fb = GetRoleByName(fallback)

		-- update state
		if fallback == SHOP_DISABLED or fallback == SHOP_UNSET and rd.fallbackTable then
			state = false
		else
			state = true
		end

		self:AddChoice("Use own shop", {name = rd.name, data = rd.name})

		-- add linked or own shop choice
		for _, v in pairs(GetShopRoles()) do
			if v.index ~= dlist.selectedRole then
				self:AddChoice("Link with " .. v.name, {name = v.name, data = v.name})
			end
		end

		-- add default choice
		if rd.fallbackTable then
			self:AddChoice("Default Role Equipment", {name = rd.name, data = SHOP_UNSET})
		end

		self:AddChoice("Disable shop", {name = rd.name, data = SHOP_DISABLED})

		-- set default value
		if fallback == SHOP_DISABLED then
			self:SetValue("Disabled shop")
		elseif not state then
			self:SetValue("Default Role Equipment")
		else
			self:SetValue(dlist.selectedRole == fb.index and "Using own shop" or ("Linked with " .. fb.name))
		end

		-- generally update
		for _, v in pairs(dlist:GetItems()) do
			if v.UpdateCheck then
				v:UpdateCheck()
			end
		end

		-- disable if not needed
		if not state or fb.index ~= dlist.selectedRole then
			for _, v in pairs(dlist:GetItems()) do
				if v.Toggle then
					v:Toggle(false)
				end
			end
		end
	end

	fbmenu:RefreshChoices()

	function fbmenu:OnSelect(_, _, data)
		local rd = GetRoleByIndex(dlist.selectedRole)
		local oldFallback = GetGlobalString("ttt_" .. rd.abbr .. "_shop_fallback")

		if data.data ~= oldFallback then
			net.Start("shopFallback")
			net.WriteUInt(dlist.selectedRole, ROLE_BITS)
			net.WriteString(data.data)
			net.SendToServer()

			if data.data == SHOP_DISABLED or data.data == SHOP_UNSET or data.data ~= GetRoleByIndex(dlist.selectedRole).name then
				state = false
			else
				state = true
			end

			for _, v in pairs(dlist:GetItems()) do
				if v.Toggle then
					v:Toggle(false)
				end
			end
		end
	end

	function menu:OnSelect(_, _, data)
		dlist.selectedRole = data

		fbmenu:RefreshChoices()
	end
end
--net.Receive("newshop", ShopEditor.newshop)

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

function ShopEditor.shopFallbackRefresh(len)
	local wshop = LocalPlayer().shopeditor

	if wshop and wshop.GetItems then
		if not wshop.selectedRole then return end

		for _, v in pairs(wshop:GetItems()) do
			if v.item and v.UpdateCheck then
				local is_item = tonumber(v.item.id)
				if is_item then
					EquipmentItems[wshop.selectedRole] = EquipmentItems[wshop.selectedRole] or {}

					if EquipmentTableHasValue(EquipmentItems[wshop.selectedRole], v.item) then
						v:Toggle(true)
					else
						v:Toggle(false)
					end
				else
					local wepTbl = weapons.GetStored(v.item.id)
					if wepTbl then
						wepTbl.CanBuy = wepTbl.CanBuy or {}

						if table.HasValue(wepTbl.CanBuy, wshop.selectedRole) then
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
