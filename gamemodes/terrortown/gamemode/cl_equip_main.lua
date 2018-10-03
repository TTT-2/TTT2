-- TODO
ERROR
---- Traitor equipment menu
local GetTranslation = LANG.GetTranslation
local GetPTranslation = LANG.GetParamTranslation

-- create ClientConVars
local numColsVar = CreateClientConVar("ttt_bem_cols", 4, true, false, "Sets the number of columns in the Traitor/Detective menu's item list.")
local numRowsVar = CreateClientConVar("ttt_bem_rows", 5, true, false, "Sets the number of rows in the Traitor/Detective menu's item list.")
local itemSizeVar = CreateClientConVar("ttt_bem_size", 64, true, false, "Sets the item size in the Traitor/Detective menu's item list.")
local showCustomVar = CreateClientConVar("ttt_bem_marker_custom", 1, true, false, "Should custom items get a marker?")
local showFavoriteVar = CreateClientConVar("ttt_bem_marker_fav", 1, true, false, "Should favorite items get a marker?")
local showSlotVar = CreateClientConVar("ttt_bem_marker_slot", 1, true, false, "Should items get a slot-marker?")

-- get serverside ConVars
local allowChangeVar = GetConVar("ttt_bem_allow_change")
local serverColsVar = GetConVar("ttt_bem_sv_cols")
local serverRowsVar = GetConVar("ttt_bem_sv_rows")
local serverSizeVar = GetConVar("ttt_bem_sv_size")

-- add favorites DB functions
include("favorites_db.lua")

-- Buyable weapons are loaded automatically. Buyable items are defined in
-- equip_items_shd.lua

Equipment = Equipment or {}

function GetEquipmentForRole(subrole)
	local fallbackTable = GetShopFallbackTable(subrole)
	if fallbackTable then
		return fallbackTable
	end

	local fallback = GetShopFallback(subrole)

	-- need to build equipment cache?
	if not Equipment[fallback] then
		-- start with all the non-weapon goodies
		local tbl = table.Copy(EquipmentItems[fallback])

		-- find buyable weapons to load info from
		for _, v in ipairs(weapons.GetList()) do
			if v and not v.Doublicated and v.CanBuy and table.HasValue(v.CanBuy, fallback) then
				local data = v.EquipMenuData or {}
				local base = {
					id = WEPS.GetClass(v),
					name = v.ClassName or "Unnamed",
					PrintName = data.name or data.PrintName or v.PrintName or v.ClassName or "Unnamed",
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

		-- mark custom items
		for _, i in ipairs(tbl) do
			if i and i.id then
				i.custom = not table.HasValue(DefaultEquipment[fallback], i.id) -- TODO
			end
		end

		Equipment[fallback] = tbl
	end

	return Equipment[fallback] or {}
end

local function ItemIsWeapon(item)
	return not tonumber(item.id)
end

local function CanCarryWeapon(item)
	return LocalPlayer():CanCarryType(item.kind)
end

local color_bad = Color(244, 67, 54, 255)
--local color_good = Color(76, 175, 80, 255)

-- Creates tabel of labels showing the status of ordering prerequisites
local function PreqLabels(parent, x, y)
	local tbl = {}

	tbl.credits = vgui.Create("DLabel", parent)
	--tbl.credits:SetTooltip(GetTranslation("equip_help_cost"))
	tbl.credits:SetPos(x, y)
	-- coins icon
	tbl.credits.img = vgui.Create("DImage", parent)
	tbl.credits.img:SetSize(32, 32)
	tbl.credits.img:CopyPos(tbl.credits)
	tbl.credits.img:MoveLeftOf(tbl.credits)
	tbl.credits.img:SetImage("vgui/ttt/equip/coin.png")

	-- remaining credits text
	tbl.credits.Check = function(s, sel)
		local credits = LocalPlayer():GetCredits()

		return credits > 0, " " .. credits, GetPTranslation("equip_cost", {num = credits})
	end

	tbl.owned = vgui.Create("DLabel", parent)
	--tbl.owned:SetTooltip(GetTranslation("equip_help_carry"))
	tbl.owned:CopyPos(tbl.credits)
	tbl.owned:MoveRightOf(tbl.credits, y * 3)
	-- carry icon
	tbl.owned.img = vgui.Create("DImage", parent)
	tbl.owned.img:SetSize(32, 32)
	tbl.owned.img:CopyPos(tbl.owned)
	tbl.owned.img:MoveLeftOf(tbl.owned)
	tbl.owned.img:SetImage("vgui/ttt/equip/briefcase.png")

	tbl.owned.Check = function(s, sel)
		if ItemIsWeapon(sel) and (not CanCarryWeapon(sel) or not SWEPIsBuyable(tostring(sel.id))) then -- TODO add indicator for "SWEPIsBuyable(wepCls)"
			return false, sel.slot, GetPTranslation("equip_carry_slot", {slot = sel.slot})
		elseif not ItemIsWeapon(sel) and LocalPlayer():HasEquipmentItem(sel.id) then
			return false, "X", GetTranslation("equip_carry_own")
		else
			return true, "✔", GetTranslation("equip_carry")
		end
	end

	tbl.bought = vgui.Create("DLabel", parent)
	--tbl.bought:SetTooltip(GetTranslation("equip_help_stock"))
	tbl.bought:CopyPos(tbl.owned)
	tbl.bought:MoveRightOf(tbl.owned, y * 3)
	-- stock icon
	tbl.bought.img = vgui.Create("DImage", parent)
	tbl.bought.img:SetSize(32, 32)
	tbl.bought.img:CopyPos(tbl.bought)
	tbl.bought.img:MoveLeftOf(tbl.bought)
	tbl.bought.img:SetImage("vgui/ttt/equip/package.png")

	tbl.bought.Check = function(s, sel)
		if sel.limited and LocalPlayer():HasBought(tostring(sel.id)) then
			return false, "X", GetTranslation("equip_stock_deny")
		else
			return true, "✔", GetTranslation("equip_stock_ok")
		end
	end

	for _, pnl in pairs(tbl) do
		pnl:SetFont("DermaLarge")
	end

	return function(selected)
		local allow = true

		for _, pnl in pairs(tbl) do
			local result, text, tooltip = pnl:Check(selected)

			pnl:SetTextColor(result and COLOR_WHITE or color_bad)
			pnl:SetText(text)
			pnl:SizeToContents()
			pnl:SetTooltip(tooltip)

			pnl.img:SetImageColor(result and COLOR_WHITE or color_bad)
			pnl.img:SetTooltip(tooltip)

			allow = allow and result
		end

		return allow
	end
end

-- quick, very basic override of DPanelSelect
local PANEL = {}

local function DrawSelectedEquipment(pnl)
	surface.SetDrawColor(255, 200, 0, 255)
	surface.DrawOutlinedRect(0, 0, pnl:GetWide(), pnl:GetTall())
end

function PANEL:SelectPanel(pnl)
	if not IsValid(pnl) then return end

	self.BaseClass.SelectPanel(self, pnl)

	if pnl then
		pnl.PaintOver = DrawSelectedEquipment
	end
end
vgui.Register("EquipSelect", PANEL, "DPanelSelect") -- DIconLayout?

local SafeTranslate = LANG.TryTranslation
local color_darkened = Color(255, 255, 255, 80)
local eqframe

local function TraitorMenuPopup()
	local ply = LocalPlayer()

	if not IsValid(ply) or not ply:IsActiveShopper() then return end

	local subrole = ply:GetSubRole()
	local fallbackRole = GetShopFallback(subrole)
	local rd = GetRoleByIndex(fallbackRole)

	local fallback = GetConVar("ttt_" .. rd.abbr .. "_shop_fallback"):GetString()
	if fallback == SHOP_DISABLED then return end

	-- calculate dimensions
	local numCols = serverColsVar:GetInt()
	local numRows = serverRowsVar:GetInt()
	local itemSize = serverSizeVar:GetInt()

	if allowChangeVar:GetBool() then
		numCols = numColsVar:GetInt()
		numRows = numRowsVar:GetInt()
		itemSize = itemSizeVar:GetInt()
	end

	-- margin
	local m = 5
	-- item list width
	local dlistw = ((itemSize + 2) * numCols) - 2 + 15
	local dlisth = ((itemSize + 2) * numRows) - 2 + 15
	-- right column width
	local diw = 270
	-- frame size
	local w = dlistw + diw + (m * 4)
	local h = dlisth + 75

	-- Close any existing traitor menu
	if eqframe and IsValid(eqframe) then
		eqframe:Close()

		return
	end

	local credits = ply:GetCredits()
	local can_order = credits > 0

	local dframe = vgui.Create("DFrame")
	dframe:SetSize(w, h)
	dframe:Center()
	dframe:SetTitle(GetTranslation("equip_title"))
	dframe:SetVisible(true)
	dframe:ShowCloseButton(true)
	dframe:SetMouseInputEnabled(true)
	dframe:SetDeleteOnClose(true)

	local dsheet = vgui.Create("DPropertySheet", dframe)

	-- Add a callback when switching tabs
	local oldfunc = dsheet.SetActiveTab

	dsheet.SetActiveTab = function(self, new)
		if not IsValid(new) then return end

		if self.m_pActiveTab ~= new and self.OnTabChanged then
			self:OnTabChanged(self.m_pActiveTab, new)
		end

		oldfunc(self, new)
	end

	dsheet:SetPos(0, 0)
	dsheet:StretchToParent(m, m + 25, m, m)

	local padding = dsheet:GetPadding()

	local dequip = vgui.Create("DPanel", dsheet)
	dequip:SetPaintBackground(false)
	dequip:StretchToParent(padding, padding, padding, padding)

	-- Determine if we already have equipment
	local owned_ids = {}

	for _, wep in pairs(ply:GetWeapons()) do
		if IsValid(wep) and wep:IsEquipment() then
			table.insert(owned_ids, wep.ClassName)
		end
	end

	-- Stick to one value for no equipment
	if #owned_ids == 0 then
		owned_ids = nil
	end

	--- Construct icon listing
	--- icon size = 64 x 64
	local dlist = vgui.Create("EquipSelect", dequip)
	-- local dlistw = 288
	dlist:SetPos(0, 0)
	dlist:SetSize(dlistw, dlisth)
	dlist:EnableVerticalScrollbar(true)
	dlist:EnableHorizontal(true)

	local items = GetEquipmentForRole(subrole)

	SortEquipmentTable(items)

	if #items == 0 then
		ply:ChatPrint("[TTT2][SHOP] You need to run 'weaponshop' in the developer console to create a shop for this role. Link it with another shop or click on the icons to add weapons and items to the shop.")
	end

	-- temp table for sorting
	local paneltablefav = {}
	local paneltable = {}

	for k, item in ipairs(items) do
		local ic

		-- Create icon panel
		if item.material and item.material ~= "vgui/ttt/icon_id" then
			ic = vgui.Create("LayeredIcon", dlist)

			if item.custom and showCustomVar:GetBool() then
				-- Custom marker icon
				local marker = vgui.Create("DImage")
				marker:SetImage("vgui/ttt/custom_marker")

				marker.PerformLayout = function(s)
					s:AlignBottom(2)
					s:AlignRight(2)
					s:SetSize(16, 16)
				end

				marker:SetTooltip(GetTranslation("equip_custom"))

				ic:AddLayer(marker)
				ic:EnableMousePassthrough(marker)
			end

			-- Favorites marker icon
			ic.favorite = false

			local favorites = GetFavorites(ply:SteamID(), ply:GetSubRole())

			if favorites and IsFavorite(favorites, item.id) then
				ic.favorite = true

				if showFavoriteVar:GetBool() then
					local star = vgui.Create("DImage")
					star:SetImage("icon16/star.png")

					star.PerformLayout = function(s)
						s:AlignTop(2)
						s:AlignRight(2)
						s:SetSize(12, 12)
					end

					star:SetTooltip("Favorite")

					ic:AddLayer(star)
					ic:EnableMousePassthrough(star)
				end
			end

			-- Slot marker icon
			if ItemIsWeapon(item) and showSlotVar:GetBool() then
				local slot = vgui.Create("SimpleIconLabelled")
				slot:SetIcon("vgui/ttt/slotcap")
				slot:SetIconColor(ply:GetSubRoleData().color or COLOR_GREY)
				slot:SetIconSize(16)
				slot:SetIconText(item.slot)
				slot:SetIconProperties(COLOR_WHITE, "DefaultBold", {opacity = 220, offset = 1}, {10, 8})

				ic:AddLayer(slot)
				ic:EnableMousePassthrough(slot)
			end

			ic:SetIconSize(itemSize)
			ic:SetIcon(item.material)
		elseif item.model and item.model ~= "models/weapons/w_bugbait.mdl" then
			ic = vgui.Create("SpawnIcon", dlist)
			ic:SetModel(item.model)
		end

		if ic then
			ic.item = item

			local tip = GetEquipmentTranslation(item.name, item.PrintName) .. " (" .. SafeTranslate(item.type) .. ")"

			ic:SetTooltip(tip)

			-- If we cannot order this item, darken it
			if (not can_order or
				-- already owned
				table.HasValue(owned_ids, item.id) or
				tonumber(item.id) and ply:HasEquipmentItem(tonumber(item.id)) or
				-- already carrying a weapon for this slot
				ItemIsWeapon(item) and (not CanCarryWeapon(item) or not SWEPIsBuyable(tostring(item.id))) or
				-- already bought the item before
			item.limited and ply:HasBought(tostring(item.id))) then
				ic:SetIconColor(color_darkened)
			end

			if ic.favorite then
				paneltablefav[k] = ic
			else
				paneltable[k] = ic
			end
		end
	end

	-- add favorites first
	for _, panel in pairs(paneltablefav) do
		dlist:AddPanel(panel)
	end

	-- non favorites second
	for _, panel in pairs(paneltable) do
		dlist:AddPanel(panel)
	end

	local bw, bh = 100, 25

	-- Whole right column
	local dih = (h - bh - m * 5)

	-- local diw = w - dlistw - m*6 - 2
	local dinfobg = vgui.Create("DPanel", dequip)
	dinfobg:SetPaintBackground(false)
	dinfobg:SetSize(diw - m, dih)
	dinfobg:SetPos(dlistw + m, 0)

	-- item info pane
	local dinfo = vgui.Create("ColoredBox", dinfobg)
	dinfo:SetColor(Color(90, 90, 95))
	dinfo:SetPos(0, 0)
	dinfo:StretchToParent(0, 0, m * 2, 105)

	local dfields = {}

	for _, k in ipairs({"name", "type", "desc"}) do
		dfields[k] = vgui.Create("DLabel", dinfo)
		dfields[k]:SetTooltip(GetTranslation("equip_spec_" .. k))
		dfields[k]:SetPos(m * 3, m * 2)
		dfields[k]:SetWidth(diw - m * 6)
	end

	dfields.name:SetFont("TabLarge")

	dfields.type:SetFont("DermaDefault")
	dfields.type:MoveBelow(dfields.name)

	dfields.desc:SetFont("DermaDefaultBold")
	dfields.desc:SetContentAlignment(7)
	dfields.desc:MoveBelow(dfields.type, 1)

	--local iw, ih = dinfo:GetSize()

	local dhelp = vgui.Create("DPanel", dinfobg)
	dhelp:SetPaintBackground(false)
	dhelp:SetSize(diw, 64)
	dhelp:MoveBelow(dinfo, m)

	local update_preqs = PreqLabels(dhelp, m * 7, m * 2)

	dhelp:SizeToContents()

	local dconfirm = vgui.Create("DButton", dinfobg)
	dconfirm:SetPos(0, dih - bh * 2)
	dconfirm:SetSize(bw, bh)
	dconfirm:SetDisabled(true)
	dconfirm:SetText(GetTranslation("equip_confirm"))

	dsheet:AddSheet(GetTranslation("equip_tabtitle"), dequip, "icon16/bomb.png", false, false, GetTranslation("equip_tooltip_main"))

	-- Item control
	if ply:HasEquipmentItem(EQUIP_RADAR) then
		local dradar = RADAR.CreateMenu(dsheet, dframe)

		dsheet:AddSheet(GetTranslation("radar_name"), dradar, "icon16/magnifier.png", false, false, GetTranslation("equip_tooltip_radar"))
	end

	if ply:HasEquipmentItem(EQUIP_DISGUISE) then
		local ddisguise = DISGUISE.CreateMenu(dsheet)

		dsheet:AddSheet(GetTranslation("disg_name"), ddisguise, "icon16/user.png", false, false, GetTranslation("equip_tooltip_disguise"))
	end

	-- Weapon/item control
	if IsValid(ply.radio) or ply:HasWeapon("weapon_ttt_radio") then
		local dradio = TRADIO.CreateMenu(dsheet)

		dsheet:AddSheet(GetTranslation("radio_name"), dradio, "icon16/transmit.png", false, false, GetTranslation("equip_tooltip_radio"))
	end

	-- Credit transferring
	if credits > 0 then
		local dtransfer = CreateTransferMenu(dsheet)

		dsheet:AddSheet(GetTranslation("xfer_name"), dtransfer, "icon16/group_gear.png", false, false, GetTranslation("equip_tooltip_xfer"))
	end

	hook.Run("TTTEquipmentTabs", dsheet)

	-- couple panelselect with info
	dlist.OnActivePanelChanged = function(self, _, new)
		if not IsValid(new) then return end

		if new.item then
			for k, v in pairs(new.item) do
				if dfields[k] then
					if k == "name" and new.item.PrintName then
						dfields[k]:SetText(GetEquipmentTranslation(new.item.name, new.item.PrintName))
					else
						dfields[k]:SetText(SafeTranslate(v))
					end

					dfields[k]:SetAutoStretchVertical(true)
					dfields[k]:SetWrap(true)
				end
			end
		end

		-- Trying to force everything to update to
		-- the right size is a giant pain, so just
		-- force a good size.
		dfields.desc:SetTall(70)

		can_order = update_preqs(new.item)

		dconfirm:SetDisabled(not can_order)
	end

	-- select first
	dlist:SelectPanel(dlist:GetItems()[1])

	-- prep confirm action
	dconfirm.DoClick = function()
		local pnl = dlist.SelectedPanel

		if not pnl or not pnl.item then return end

		local choice = pnl.item

		RunConsoleCommand("ttt_order_equipment", choice.id)

		dframe:Close()
	end

	-- update some basic info, may have changed in another tab
	-- specifically the number of credits in the preq list
	dsheet.OnTabChanged = function(s, old, new)
		if not IsValid(new) or not IsValid(dlist.SelectedPanel) then return end

		if new:GetPanel() == dequip then
			can_order = update_preqs(dlist.SelectedPanel.item)

			dconfirm:SetDisabled(not can_order)
		end
	end

	local dcancel = vgui.Create("DButton", dframe)
	dcancel:SetPos(w - 13 - bw, h - bh - 16)
	dcancel:SetSize(bw, bh)
	dcancel:SetDisabled(false)
	dcancel:SetText(GetTranslation("close"))

	dcancel.DoClick = function()
		dframe:Close()
	end

	function file.AppendLine(filename, addme)
		data = file.Read(filename)
		if data then
			file.Write(filename, data .. "\n" .. tostring(addme))
		else
			file.Write(filename, tostring(addme))
		end
	end

	--add as favorite button
	dfav = vgui.Create("DButton", dinfobg)
	dfav:SetPos(0, dih - bh * 2)
	dfav:MoveRightOf(dconfirm)
	dfav:SetSize(bh, bh)
	dfav:SetDisabled(false)
	dfav:SetText("")
	dfav:SetImage("icon16/star.png")

	dfav.DoClick = function()
		local ply2 = LocalPlayer()
		local subrole2 = ply2:GetSubRole()
		local guid = ply2:SteamID()
		local pnl = dlist.SelectedPanel

		if not pnl or not pnl.item then return end

		local choice = pnl.item
		local weapon = choice.id

		CreateFavTable()

		if pnl.favorite then
			RemoveFavorite(guid, subrole2, weapon)
		else
			AddFavorite(guid, subrole2, weapon)
		end
	end

	dframe:MakePopup()
	dframe:SetKeyboardInputEnabled(false)

	eqframe = dframe
end
concommand.Add("ttt_cl_traitorpopup", TraitorMenuPopup)

local function ForceCloseTraitorMenu(ply, cmd, args)
	if IsValid(eqframe) then
		eqframe:Close()
	end
end
concommand.Add("ttt_cl_traitorpopup_close", ForceCloseTraitorMenu)

function GM:OnContextMenuOpen()
	local client = LocalPlayer()
	local r = GetRoundState()

	if r == ROUND_ACTIVE and (not client:IsShopper() or hook.Run("TTT2PreventAccessShop", client)) then
		return
	elseif r == ROUND_POST or r == ROUND_PREP then
		CLSCORE:Toggle()

		return
	end

	if IsValid(eqframe) then
		eqframe:Close()
	else
		RunConsoleCommand("ttt_cl_traitorpopup")
	end
end

local function ReceiveEquipment()
	local ply = LocalPlayer()

	if not IsValid(ply) then return end

	ply.equipment_items = net.ReadUInt(16)
end
net.Receive("TTT_Equipment", ReceiveEquipment)

local function ReceiveCredits()
	local ply = LocalPlayer()

	if not IsValid(ply) then return end

	ply.equipment_credits = net.ReadUInt(8)
end
net.Receive("TTT_Credits", ReceiveCredits)

local r = 0
local function ReceiveBought()
	local ply = LocalPlayer()

	if not IsValid(ply) then return end

	ply.bought = {}

	local num = net.ReadUInt(8)

	for i = 1, num do
		local s = net.ReadString()

		if s ~= "" then
			table.insert(ply.bought, s)
		end
	end

	-- This usermessage sometimes fails to contain the last weapon that was
	-- bought, even though resending then works perfectly. Possibly a bug in
	-- bf_read. Anyway, this hack is a workaround: we just request a new umsg.
	if num ~= #ply.bought and r < 10 then -- r is an infinite loop guard
		RunConsoleCommand("ttt_resend_bought")

		r = r + 1
	else
		r = 0
	end
end
net.Receive("TTT_Bought", ReceiveBought)

-- Player received the item he has just bought, so run clientside init
local function ReceiveBoughtItem()
	local is_item = net.ReadBit() == 1
	local id = is_item and net.ReadUInt(16) or net.ReadString()

	-- I can imagine custom equipment wanting this, so making a hook
	hook.Run("TTTBoughtItem", is_item, id)
end
net.Receive("TTT_BoughtItem", ReceiveBoughtItem)
