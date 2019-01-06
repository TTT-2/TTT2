---- Traitor equipment menu
local GetTranslation = LANG.GetTranslation
local GetPTranslation = LANG.GetParamTranslation
local SafeTranslate = LANG.TryTranslation
local table = table
local net = net
local pairs = pairs
local ipairs = ipairs
local IsValid = IsValid
local hook = hook

-- create ClientConVars
local numColsVar = CreateClientConVar("ttt_bem_cols", 5, true, false, "Sets the number of columns in the Traitor/Detective menu's item list.")
local numRowsVar = CreateClientConVar("ttt_bem_rows", 6, true, false, "Sets the number of rows in the Traitor/Detective menu's item list.")
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

local color_bad = Color(244, 67, 54, 255)
--local color_good = Color(76, 175, 80, 255)
local color_darkened = Color(255, 255, 255, 80)

-- Buyable weapons are loaded automatically. Buyable items are defined in
-- equip_items_shd.lua

local eqframe
local dlist = nil
local curSearch = nil
Equipment = Equipment or {}

-- ----------------------------------
--     GENERAL HELPER FUNCTIONS
-- ----------------------------------

local function RolenameToRole(val)
	for k, v in pairs(GetRoles()) do
		if SafeTranslate(v.name) == val then
			return v.index
		end
	end
	return 0
end

local function ItemIsWeapon(item)
	return not tonumber(item.id)
end

local function CanCarryWeapon(item)
	return LocalPlayer():CanCarryType(item.kind)
end

-- ----------------------------------
-- PANEL OVERRIDES
-- quick, very basic override of DPanelSelect
-- ----------------------------------

local PANEL = {}
local function DrawSelectedEquipment(pnl)
	surface.SetDrawColor(255, 200, 0, 255)
	surface.DrawOutlinedRect(0, 0, pnl:GetWide(), pnl:GetTall())
end

function PANEL:SelectPanel(pnl)
	if not pnl then return end
	pnl.PaintOver = nil
	self.BaseClass.SelectPanel(self, pnl)
	if pnl then
		pnl.PaintOver = DrawSelectedEquipment
	end
end
vgui.Register("EquipSelect", PANEL, "DPanelSelect")


-- ----------------------------------
-- Creates tabel of labels showing the status of ordering prerequisites
-- ----------------------------------

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
		local cr = sel and sel.credits or 1
		return credits >= cr, " " .. cr .. " / " .. credits, GetPTranslation("equip_cost", {num = credits})
	end

	tbl.owned = vgui.Create("DLabel", parent)
	--tbl.owned:SetTooltip(GetTranslation("equip_help_carry"))
	tbl.owned:CopyPos(tbl.credits)
	tbl.owned:MoveRightOf(tbl.credits, y * 5)

	-- carry icon
	tbl.owned.img = vgui.Create("DImage", parent)
	tbl.owned.img:SetSize(32, 32)
	tbl.owned.img:CopyPos(tbl.owned)
	tbl.owned.img:MoveLeftOf(tbl.owned)
	tbl.owned.img:SetImage("vgui/ttt/equip/briefcase.png")

	tbl.owned.Check = function(s, sel)
		if ItemIsWeapon(sel) and not CanCarryWeapon(sel) then
			return false, sel.slot, GetPTranslation("equip_carry_slot", {slot = sel.slot})
		elseif not ItemIsWeapon(sel) and LocalPlayer():HasEquipmentItem(sel.id) then
			return false, "X", GetTranslation("equip_carry_own")
		else
			return true, "✔", GetTranslation("equip_carry")
		end
	end

	-- TODO add global limited
	tbl.bought = vgui.Create("DLabel", parent)
	--tbl.bought:SetTooltip(GetTranslation("equip_help_stock"))
	tbl.bought:CopyPos(tbl.credits)
	tbl.bought:MoveBelow(tbl.credits, y * 2)

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

	-- custom info
	tbl.info = vgui.Create("DLabel", parent)
	--tbl.info:SetTooltip(GetTranslation("equip_help_stock"))
	tbl.info:CopyPos(tbl.bought)
	tbl.info:MoveRightOf(tbl.bought, y * 5)

	-- stock icon
	tbl.info.img = vgui.Create("DImage", parent)
	tbl.info.img:SetSize(32, 32)
	tbl.info.img:CopyPos(tbl.info)
	tbl.info.img:MoveLeftOf(tbl.info)
	tbl.info.img:SetImage("vgui/ttt/equip/icon_info")

	tbl.info.Check = function(s, sel)
		return EquipmentIsBuyable(sel, LocalPlayer():GetTeam())
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

-- ----------------------------------
--- Create Equipment GUI / refresh
-- ----------------------------------

local function CreateEquipmentList(t)
	if not t then t = {} end
	setmetatable(t, {__index = {search = nil, role = nil}})
	if t.search == "Search..." or t.search == "" then t.search = nil end
	local ply = LocalPlayer()
	local currole = t.role
	local credits = ply:GetCredits()
	local can_order = credits > 0

	if not currole then currole = ply:GetSubRole() end

	if allowChangeVar:GetBool() then
		itemSize = itemSizeVar:GetInt()
	end

	--- icon size = 64 x 64
	if IsValid(dlist) then
		dlist:Clear()
	else
		TraitorMenuPopup() --TODO Check
		return
	end

	-- Determine if we already have equipment
	local owned_ids = {}
	for _, wep in pairs(ply:GetWeapons()) do
		if IsValid(wep) and wep:IsEquipment() then
			table.insert(owned_ids, wep:GetClass())
		end
	end

	-- Stick to one value for no equipment
	if #owned_ids == 0 then
		owned_ids = nil
	end

	local items = {}
	local tmp = GetEquipmentForRole(currole)

	for k, v in ipairs(tmp) do
		if not v.notBuyable then
			items[#items + 1] = v
		end
	end

	if #items == 0 then
		ply:ChatPrint("[TTT2][SHOP] You need to run 'shopeditor' as admin in the developer console to create a shop for this role. Link it with another shop or click on the icons to add weapons and items to the shop.")
	end

	-- temp table for sorting
	local paneltablefav = {}
	local paneltable = {}
	local steamid = ply:SteamID64()
	local col = ply:GetRoleColor()

	for k, item in pairs(items) do
		if (t.search and string.find(string.lower(item.name), string.lower(t.search))) or not t.search then
			local ic = nil

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

				local favorites = GetFavorites(steamid, currole)

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
				if ItemIsWeapon( item ) && showSlotVar:GetBool() then
					local slot = vgui.Create( "SimpleIconLabelled" )
					slot:SetIcon( "vgui/ttt/slotcap" )
					slot:SetIconColor( col or COLOR_GREY )
					slot:SetIconSize( 16 )

					slot:SetIconText( item.slot )

					slot:SetIconProperties(COLOR_WHITE,
						"DefaultBold",
						{opacity = 220, offset = 1},
					{10, 8})

					ic:AddLayer( slot )
					ic:EnableMousePassthrough( slot )
				end

				ic:SetIconSize( itemSize )
				ic:SetIcon( item.material )
			elseif item.model and item.model ~= "models/weapons/w_bugbait.mdl" then
				ic = vgui.Create( "SpawnIcon", dlist )
				ic:SetModel( item.model )
			else
				ErrorNoHalt( "Equipment item does not have model or material specified: " .. tostring(item) .. "\n" )
			end

			if ic then
				ic.item = item

				local tip = GetEquipmentTranslation(item.name, item.PrintName) .. " (" .. SafeTranslate(item.type) .. ")"
				ic:SetTooltip(tip)

				-- If we cannot order this item, darken it
				if not t.role then
					if (( not can_order ) or
						-- already owned
						table.HasValue(owned_ids, item.id) or
						(tonumber(item.id) and ply:HasEquipmentItem(tonumber(item.id))) or
						-- already carrying a weapon for this slot
						(ItemIsWeapon(item) and (not CanCarryWeapon(item))) or
						not EquipmentIsBuyable(item, ply:GetTeam()) or
						-- already bought the item before
					(item.limited and ply:HasBought(tostring(item.id)))) or
					(item.credits or 1) > ply:GetCredits() then
						ic:SetIconColor(color_darkened)
					end
				end

				if ic.favorite then
					paneltablefav[k] = ic
				else
					paneltable[k] = ic
				end
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
end

-- ----------------------------------
-- Create/Show Shop frame
-- ----------------------------------
--  dframe
--   \-> dsheet
--      \-> dequip
--         \-> dlist
--         \-> depanel
--            \-> dsearch
--         \-> dbtnpnl
--         \-> dinfobg
--            \-> dhelp
--
-- -----------------------------------

local function TraitorMenuPopup()

	local ply = LocalPlayer()

	local subrole = ply:GetSubRole()
	local fallbackRole = GetShopFallback(subrole)
	local rd = GetRoleByIndex(fallbackRole)
	local nonply = false
	local rnd = GetRoundState()

	local fallback = GetGlobalString("ttt_" .. rd.abbr .. "_shop_fallback")
	if rnd == ROUND_ACTIVE and fallback == SHOP_DISABLED then return end

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
	local dlistw = (itemSize + 2) * numCols - 2 + 15
	local dlisth = (itemSize + 2) * numRows - 2 + 15

	-- right column width
	local diw = 270

	-- frame size
	local w = dlistw + diw + m * 4
	local h = dlisth + 75

	-- Close shop if player is in round and should not be able to buy anything
	if rnd == ROUND_ACTIVE and IsValid(ply) and not ply:IsActiveShopper() then
		if eqframe and IsValid(eqframe) then eqframe:Close() end
		return
	end

	-- if the round is not active let the players choose their shop
	if rnd ~= ROUND_ACTIVE or not ply:IsTerror() then
		nonply = true
	end

	-- Close any existing traitor menu
	if eqframe and IsValid(eqframe) then eqframe:Close() end

	local credits = ply:GetCredits()
	local can_order = true
	local name = GetTranslation("equip_title")

	if GetGlobalInt("ttt2_random_shops") > 0 then
		name = name .. " (RANDOM)"
	end

	local dframe = vgui.Create("DFrame")
	dframe:SetSize(w, h)
	dframe:Center()
	dframe:SetTitle(name)
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

	--- Construct icon listing
	--- icon size = 64 x 64
	dlist = vgui.Create("EquipSelect", dequip)
	-- local dlistw = 288
	dlist:SetPos(0, 0)
	dlist:SetSize(dlistw, dlisth)
	dlist:EnableVerticalScrollbar(true)
	dlist:EnableHorizontal(true)

	CreateEquipmentList()

	local bw, bh = 100, 25

	local dsph = 30
	local drsh = 30
	local depw = diw - m

	local depanel = vgui.Create( "DPanel", dequip )
	depanel:SetSize( depw, dsph + m * 2 )
	depanel:SetPos( dlistw + m, 0 )
	depanel:SetMouseInputEnabled( true )
	depanel:SetPaintBackground( false )

	local dsearch = vgui.Create( "DTextEntry", depanel )
	dsearch:SetSize( depw - 20, dsph )
	dsearch:SetPos( 5, 5 )
	dsearch:SetUpdateOnType( true )
	dsearch:SetEditable( true )
	dsearch:SetText( "Search..." )
	dsearch:SetText( "" )
	dsearch.selectAll = true

	local dbph = bh + m * 2
	local dbpw = bw + bh + m * 2
	local dbtnpnl = vgui.Create( "DPanel", dequip )
	dbtnpnl:SetSize( dbpw, dbph )
	dbtnpnl:SetPos( dlistw + m, dequip:GetTall() - dbph - m )
	dbtnpnl:SetPaintBackground( false )


	local dconfirm = vgui.Create( "DButton", dbtnpnl )
	dconfirm:SetPos( m, m )
	dconfirm:SetSize( bw, bh )
	dconfirm:SetDisabled( true )
	dconfirm:SetText( GetTranslation( "equip_confirm" ) )

	--add a favorite button
	dfav = vgui.Create( "DButton", dbtnpnl )
	dfav:CopyPos( dconfirm )
	dfav:MoveRightOf( dconfirm )
	dfav:SetSize( bh, bh )
	dfav:SetDisabled( false )
	dfav:SetText( "" )
	dfav:SetImage( "icon16/star.png" )

	--add a cancel button
	local dcancel = vgui.Create("DButton", dframe)
	dcancel:SetPos(w - m * 3 - bw, h - bh - m * 3 - 3)
	dcancel:SetSize(bw, bh)
	dcancel:SetDisabled(false)
	dcancel:SetText(GetTranslation("close"))

	local bpx, bpy = dbtnpnl:GetPos()
	local dinfobg = vgui.Create("DPanel", dequip)
	dinfobg:SetPaintBackground(false)
	dinfobg:SetPos(dlistw + m, 40)

	local drolesel = nil

	if nonply then
		depanel:SetSize(depanel:GetWide(), depanel:GetTall() + drsh + m)

		drolesel = vgui.Create( "DComboBox", depanel )
		drolesel:SetSize( depw - 20, drsh )
		drolesel:SetPos( m, dsph + m * 2 )
		drolesel:MoveBelow( dsearch, m )

		for k, v in pairs(GetRoles()) do
			if IsShoppingRole(v.index) then
				drolesel:AddChoice( SafeTranslate(v.name) )
			end
		end

		drolesel:SetValue( "Select a role..." )

		drolesel.OnSelect = function( panel, index, value )
			print( value .."'s shop was selected!" )
			CreateEquipmentList( {role = RolenameToRole(value), search = dsearch:GetValue()} )
		end

		dinfobg:MoveBelow( depanel, m )
	end

	local _, ibgy = dinfobg:GetPos()
	dinfobg:SetSize( diw - m, bpy - ibgy )

	function dsearch:OnValueChange( text )
		if text == "" then text = nil end
		curSearch = text
		local crole = nil
		if drolesel then crole = RolenameToRole( drolesel:GetValue() ) end
		CreateEquipmentList( {search = text, role = crole} )
	end

	-- item info pane
	local dinfo = vgui.Create("ColoredBox", dinfobg)
	dinfo:SetColor(Color(90, 90, 95, 255))
	dinfo:SetPos(0, 0)
	dinfo:StretchToParent(0, 0, m * 2, m + 64)

	local dfields = {}
	local _tmp = {"name", "type", "desc"}

	for _, k in ipairs(_tmp) do
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

	local dhelp = vgui.Create("DPanel", dinfobg)
	dhelp:SetPaintBackground(false)
	dhelp:SetSize(diw, 96)
	dhelp:MoveBelow(dinfo, m)

	local update_preqs = PreqLabels(dhelp, m * 7, m * 2)

	dhelp:SizeToContents()

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
	dlist.OnActivePanelChanged = function(_, _, new)
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
	dsheet.OnTabChanged = function(_, _, new)
		if not IsValid(new) or not IsValid(dlist.SelectedPanel) or new:GetPanel() ~= dequip then return end

		can_order = update_preqs(dlist.SelectedPanel.item)

		dconfirm:SetDisabled(not can_order)
	end

	dcancel.DoClick = function()
		dframe:Close()
	end

	dfav.DoClick = function()
		local pnl = dlist.SelectedPanel
		local role = drolesel and RolenameToRole( drolesel:GetValue() ) or ply:GetSubRole()
		if not pnl or not pnl.item then return end

		local choice = pnl.item
		local weapon = choice.id
		local steamid = ply:SteamID64()

		CreateFavTable()

		if pnl.favorite then
			RemoveFavorite(steamid, role, weapon)
		else
			AddFavorite(steamid, role, weapon)
		end

		-- Reload item list
		CreateEquipmentList( {role = role, search = curSearch} )
	end

	dframe:MakePopup()
	dframe:SetKeyboardInputEnabled( false )
	eqframe = dframe
end
concommand.Add("ttt_cl_traitorpopup", TraitorMenuPopup)

-- ----------------------------------
-- Force closes the menu
-- ----------------------------------

local function ForceCloseTraitorMenu(ply, cmd, args)
	if IsValid(eqframe) then
		eqframe:Close()
	end
end
concommand.Add("ttt_cl_traitorpopup_close", ForceCloseTraitorMenu)

-- ----------------------------------
-- NET RELATED STUFF:
-- ----------------------------------

local function ReceiveEquipment()
	local ply = LocalPlayer()

	if not IsValid(ply) then return end

	ply.equipment_items = net.ReadUInt(EQUIPMENT_BITS)
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

			BUYTABLE[s] = true

			local team = ply:GetTeam()
			if team and TEAMBUYTABLE[team] then
				TEAMBUYTABLE[team][s] = true
			end
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
	local id = is_item and net.ReadUInt(EQUIPMENT_BITS) or net.ReadString()

	-- I can imagine custom equipment wanting this, so making a hook
	hook.Run("TTTBoughtItem", is_item, id)
end
net.Receive("TTT_BoughtItem", ReceiveBoughtItem)

-- ----------------------------------
-- HOOKS / GAMEMODE RELATED STUFF:
-- ----------------------------------

function GM:OnContextMenuOpen()
	if hook.Run("TTT2PreventAccessShop", client) then
		return
	end

	if IsValid(eqframe) then
		eqframe:Close()
	else
		RunConsoleCommand("ttt_cl_traitorpopup")
	end
end

-- Closes menu when roles are selected
hook.Add( "TTTBeginRound", "TTTBEMCleanUp", function()
	if IsValid(eqframe) then
		eqframe:Close()
	end
end )

-- Closes menu when round is overwritten
hook.Add( "TTTEndRound", "TTTBEMCleanUp", function()
	if IsValid(eqframe) then
		eqframe:Close()
	end
end )

-- Search text field focus hooks
local function getKeyboardFocus( pnl )
	if eqframe and IsValid(eqframe) and pnl:HasParent( eqframe ) then
		eqframe:SetKeyboardInputEnabled( true )
	end
	if pnl.selectAll then
		pnl:SelectAllText()
	end
end
hook.Add( "OnTextEntryGetFocus", "BEM_GetKeyboardFocus", getKeyboardFocus )

local function loseKeyboardFocus( pnl )
	if eqframe and IsValid(eqframe) and pnl:HasParent( eqframe ) then
		eqframe:SetKeyboardInputEnabled( false )
	end
end
hook.Add( "OnTextEntryLoseFocus", "BEM_LoseKeyboardFocus", loseKeyboardFocus )
