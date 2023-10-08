---
-- Body search popup
-- @section body_search_manager

local RT = LANG.GetRawTranslation
local table = table
local net = net
local pairs = pairs
local util = util
local IsValid = IsValid
local hook = hook

---
-- Creates a table with icons, text,... out of search_raw table
-- @param table raw
-- @return table a converted search data table
-- @realm client
function PreprocSearch(raw)
	local search = {}

	for t, d in pairs(raw) do
		search[t] = {
			img = nil,
			text = "",
			p = 10 -- sorting number
		}

		if isfunction(pfmc_tbl[t]) then
			pfmc_tbl[t](search, d, raw)
		else
			search[t] = nil
		end

		-- anything matching a type but not given a text should be removed
		if search[t] and search[t].text == "" then
			search[t] = nil
		end

		-- don't display an extra icon for the team. Merge with role desc
		if search.role and search.team then
			if GetGlobalBool("ttt2_confirm_team") then
				search.role.text = search.role.text .. " " .. search.team.text
			end

			search.team = nil
		end

		-- if there's still something here, we'll be showing it, so find an icon
		if search[t] then
			search[t].img = IconForInfoType(t, d)
		end
	end

	local itms = items.GetList()

	for i = 1, #itms do
		local item = itms[i]

		if not item.noCorpseSearch and raw["eq_" .. item.id] then
			local highest = 0

			for _, v in pairs(search) do
				highest = math.max(highest, v.p)
			end

			local text

			if item.corpseDesc then
				text = RT(item.corpseDesc) or item.corpseDesc
			else
				if item.desc then
					text = RT(item.desc)
				end

				local tmpText

				if not text and item.EquipMenuData and item.EquipMenuData.desc then
					tmpText = item.EquipMenuData.desc
					text = RT(tmpText)
				end

				if not text then
					text = item.desc or tmpText or ""
				end
			end

			-- add item to body search if flag is set
			if item.populateSearch then
				search["eq_" .. item.id] = {
					img = item.corpseIcon or item.material,
					text = text,
					p = highest + 1
				}
			end
		end
	end

	---
	-- @realm client
	hook.Run("TTTBodySearchPopulate", search, raw)

	return search
end

local function StoreSearchResult(search)
	if not search.owner then return end

	-- if existing result was not ours, it was detective's, and should not
	-- be overwritten
	local ply = search.owner

	if ply.search_result and not ply.search_result.show then return end

	ply.search_result = search

	-- this is useful for targetid
	local rag = Entity(search.eidx)
	if not IsValid(rag) then return end

	rag.search_result = search
end

local function bitsRequired(num)
	local bits, max = 0, 1

	while max <= num do
		bits = bits + 1
		max = max + max
	end

	return bits
end

net.Receive("TTT_RagdollSearch", function()
	local search = {}

	-- Basic info
	search.eidx = net.ReadUInt(16)

	local owner = Entity(net.ReadUInt(8))

	search.owner = owner

	if not IsValid(search.owner) or not search.owner:IsPlayer() or search.owner:IsTerror() then
		search.owner = nil
	end

	search.nick = net.ReadString()
	search.role_color = net.ReadColor()

	-- Equipment
	local eq = {}

	local eqAmount = net.ReadUInt(16)

	for i = 1, eqAmount do
		local eqStr = net.ReadString()

		eq[i] = eqStr
		search["eq_" .. eqStr] = true
	end

	-- Traitor things
	search.role = net.ReadUInt(ROLE_BITS)
	search.team = net.ReadString()
	search.c4 = net.ReadInt(bitsRequired(C4_WIRE_COUNT) + 1)

	-- Kill info
	search.dmg = net.ReadUInt(30)
	search.wep = net.ReadString()
	search.head = net.ReadBit() == 1
	search.dtime = net.ReadInt(16)
	search.stime = net.ReadInt(16)

	-- Players killed
	local num_kills = net.ReadUInt(8)
	if num_kills > 0 then
		local t_kills = {}

		for i = 1, num_kills do
			t_kills[i] = net.ReadUInt(8)
		end

		search.kills = t_kills
	else
		search.kills = nil
	end

	search.lastid = {idx = net.ReadUInt(8)}

	-- should we show a menu for this result?
	search.finder = net.ReadUInt(8)
	search.show = LocalPlayer():EntIndex() == search.finder

	-- last words
	local words = net.ReadString()
	search.words = (words ~= "") and words or nil

	-- long range
	search.lrng = net.ReadBit()

	search.killDistance = net.ReadUInt(2)
	search.hitGroup = net.ReadUInt(8)
	search.floorSurface = net.ReadUInt(8)
	search.waterLevel = net.ReadUInt(2)
	search.killOrientation = net.ReadUInt(2)
	search.plyModel = net.ReadString()
	search.plyModelColor = net.ReadVector()
	search.plySID64 = net.ReadString()
	search.credits = net.ReadUInt(8)
	search.lastDamage = net.ReadUInt(16)

	-- searched by detective?
	search.detective_search = net.ReadBool()

	-- set search.show_sb based on detective_search or self search
	search.show_sb = search.show or search.detective_search

	---
	-- @realm shared
	hook.Run("TTTBodySearchEquipment", search, eq)

	if search.show then
		SEARCHSCRN:Show(search)
	end

	-- cache search result in rag.search_result, e.g. useful for scoreboard
	StoreSearchResult(search)

	search = nil
end)

net.Receive("TTT2SendConfirmMsg", function()
	local msgName = net.ReadString()
	local sid64 = net.ReadString()
	local clr = Color(net.ReadUInt(8), net.ReadUInt(8), net.ReadUInt(8), net.ReadUInt(8))
	local bool = net.ReadBool()

	local tbl = {}
	tbl.finder = net.ReadString()
	tbl.victim = net.ReadString()
	tbl.role = LANG.GetTranslation(net.ReadString())

	if bool then
		tbl.team = LANG.GetTranslation(net.ReadString())
	end

	eidx = net.ReadUInt(8)

	-- checking for bots
	if sid64 == "" then
		sid64 = nil
	end

	local img = draw.GetAvatarMaterial(sid64, "medium")

	---
	-- @realm client
	hook.Run("TTT2ConfirmedBody", tbl.finder, tbl.victim)

	MSTACK:AddColoredImagedMessage(LANG.GetParamTranslation(msgName, tbl), clr, img)

	if (IsValid(SEARCHSCRN.menuFrame) and SEARCHSCRN.menuFrame.data.idx == edix) then
		SEARCHSCRN.buttonConfirm:SetEnabled(false)
		SEARCHSCRN.buttonConfirm:SetText("search_confirmed")
		SEARCHSCRN.buttonConfirm:SetIcon(nil)
	end
end)





---
-- @class SEARCHSCRN
SEARCHSCRN = SEARCHSCRN or {}
SEARCHSCRN.sizes = SEARCHSCRN.sizes or {}
SEARCHSCRN.menuFrame = SEARCHSCRN.menuFrame or nil
SEARCHSCRN.data = SEARCHSCRN.data or {}
SEARCHSCRN.infoBoxes = {}

function SEARCHSCRN:CalculateSizes()
	self.sizes.width = 600
	self.sizes.height = 500
	self.sizes.padding = 10

	self.sizes.heightButton = 45
	self.sizes.widthButton = 160
	self.sizes.widthButtonCredits = 210
	self.sizes.widthButtonClose = 100
	self.sizes.heightBottomButtonPanel = self.sizes.heightButton + self.sizes.padding + 1

	self.sizes.widthMainArea = self.sizes.width - 2 * self.sizes.padding
	self.sizes.heightMainArea = self.sizes.height - self.sizes.heightBottomButtonPanel - 3 * self.sizes.padding - vskin.GetHeaderHeight() - vskin.GetBorderSize()

	self.sizes.widthProfileArea = 200

	self.sizes.widthContentArea = self.sizes.width - self.sizes.widthProfileArea - 3 * self.sizes.padding
	self.sizes.widthContentBox = self.sizes.widthContentArea - 2 * self.sizes.padding - 100

	self.sizes.heightInfoItem = 78
end

function SEARCHSCRN:MakeInfoItem(parent, name, data)
	local box = vgui.Create("DInfoItemTTT2", parent)
	box:SetSize(self.sizes.widthContentBox, self.sizes.heightInfoItem)
	box:Dock(TOP)
	box:DockMargin(0, 0, 0, self.sizes.padding)
	box:SetData(data)

	-- cache reference to box
	self.infoBoxes[name] = box

	return box
end

function SEARCHSCRN:Show(data)
	local client = LocalPlayer()

	self:CalculateSizes()

	local frame = self.menuFrame

	-- IF MENU ELEMENT DOES NOT ALREADY EXIST, CREATE IT
	if IsValid(frame) then
		frame:ClearFrame(nil, nil, "search_title")
	else
		frame = vguihandler.GenerateFrame(self.sizes.width, self.sizes.height, "search_title", true)
	end

	frame:SetPadding(self.sizes.padding, self.sizes.padding, self.sizes.padding, self.sizes.padding)

	-- any keypress closes the frame
	frame:SetKeyboardInputEnabled(true)
	frame.OnKeyCodePressed = util.BasicKeyHandler

	self.menuFrame = frame

	frame.data = data

	local rd = roles.GetByIndex(data.role)

	local contentBox = vgui.Create("DPanelTTT2", frame)
	contentBox:SetSize(self.sizes.widthMainArea, self.sizes.heightMainArea)
	contentBox:Dock(TOP)

	local profileBox = vgui.Create("DProfilePanelTTT2", contentBox)
	profileBox:SetSize(self.sizes.widthProfileArea, self.sizes.heightMainArea)
	profileBox:Dock(LEFT)
	profileBox:SetModel(data.plyModel, data.plyModelColor)
	profileBox:SetPlayerIconBySteamID64(data.plySID64)
	profileBox:SetPlayerRoleColor(data.role_color)
	profileBox:SetPlayerRoleIcon(rd.iconMaterial)
	profileBox:SetPlayerRoleString(rd.name)
	profileBox:SetPlayerTeamString(data.team)

	-- ADD STATUS BOX AND ITS CONTENT
	local contentAreaScroll = vgui.Create("DScrollPanelTTT2", contentBox)
	contentAreaScroll:SetVerticalScrollbarEnabled(true)
	contentAreaScroll:SetSize(self.sizes.widthContentArea, self.sizes.heightMainArea)
	contentAreaScroll:Dock(RIGHT)

	-- POPULATE WITH INFORMATION
	for i = 1, #bodysearch.searchResultOrder do
		local searchResultName = bodysearch.searchResultOrder[i]
		local searchResultData = bodysearch.GetContentFromData(searchResultName, data)

		if not searchResultData then continue end

		self:MakeInfoItem(contentAreaScroll, searchResultName, searchResultData)
	end


	--[[
	-- weapon information
	local wep_data = bodysearch.GetDescriptionFromData("wep", {wep = data.wep, dist = data.kill_distance, hit_group = data.kill_hitgroup})
	if (wep_data) then
		self:MakeInfoItem(contentAreaScroll, WeaponToIconMaterial(data.wep), wep_data)
	end

	-- damage information
	local damage_icon = DamageToIconMaterial(data.dmg)
	if (data.head) then
		damage_icon = Material("vgui/ttt/icon_head")
	end
	self:MakeInfoItem(contentAreaScroll, damage_icon, bodysearch.GetDescriptionFromData("dmg", {dmg = data.dmg, ori = data.kill_angle, head = data.head, last_damage = data.last_damage}))

	-- time information
	self:MakeInfoItem(contentAreaScroll, Material("vgui/ttt/icon_time"), bodysearch.GetDescriptionFromData("death_time", {}), nil, data.dtime)

	-- credit information
	local credit_box
	if (data.credits > 0) then
		credit_box = self:MakeInfoItem(contentAreaScroll, Material("vgui/ttt/icon_credits"), bodysearch.GetDescriptionFromData("credits", {credits = data.credits}), COLOR_GOLD)
	end

	-- dna sample information
	if (data.stime - CurTime() > 0) then
		self:MakeInfoItem(contentAreaScroll, Material("vgui/ttt/icon_wtester"), bodysearch.GetDescriptionFromData("dna_time", {}), roles.DETECTIVE.ltcolor, data.stime):SetLiveTimeInverted(true)
	end

	-- floor surface information
	local floor_data = data.kill_floor_surface
	if (floor_data) then
		self:MakeInfoItem(contentAreaScroll, Material("vgui/ttt/icon_floor"), bodysearch.GetDescriptionFromData("floor_surface", {floor = floor_data}))
	end

	-- water death information
	local water_data = bodysearch.GetDescriptionFromData("water_level", {water_level = data.kill_water_level})
	if (water_data) then
		self:MakeInfoItem(contentAreaScroll, Material("vgui/ttt/icon_water_" .. data.kill_water_level), water_data)
	end

	-- c4 information
	local c4_data = bodysearch.GetDescriptionFromData("c4_disarm", {c4wire = data.c4})
	if (c4_data) then
		self:MakeInfoItem(contentAreaScroll, Material("vgui/ttt/icon_code"), c4_data)
	end

	-- last id information
	local lastid_data = bodysearch.GetDescriptionFromData("last_id", {idx = data.idx})
	if (lastid_data) then
		self:MakeInfoItem(contentAreaScroll, Material("vgui/ttt/icon_lastid"), lastid_data)
	end

	-- kill list information
	local killlist_data = bodysearch.GetDescriptionFromData("kill_list", {kills = data.kills})
	if (killlist_data) then
		self:MakeInfoItem(contentAreaScroll, Material("vgui/ttt/icon_list"), killlist_data)
	end

	-- last words information
	local last_words_data = bodysearch.GetDescriptionFromData("last_words", {words = data.words})
	if (last_words_data) then
		self:MakeInfoItem(contentAreaScroll, Material("vgui/ttt/icon_halp"), last_words_data)
	end]]

	-- additional information by other addons
	local search_add = {}
	---
	-- @realm client
	hook.Run("TTTBodySearchPopulate", search_add, search)
	for _, v in pairs(search_add) do
		if (istable(v.text)) then
			self:MakeInfoItem(contentAreaScroll, Material(v.img), {title = v.title, text = text})
		else
			self:MakeInfoItem(contentAreaScroll, Material(v.img), {title = v.title, text = {{body = v.text}}})
		end
	end

	-- BUTTONS
	local buttonArea = vgui.Create("DButtonPanelTTT2", frame)
	buttonArea:SetSize(self.sizes.width, self.sizes.heightBottomButtonPanel)
	buttonArea:Dock(BOTTOM)

	local buttonCall = vgui.Create("DButtonTTT2", buttonArea)
	buttonCall:SetText("search_call")
	buttonCall:SetSize(self.sizes.widthButton, self.sizes.heightButton)
	buttonCall:SetPos(0, self.sizes.padding + 1)
	buttonCall.DoClick = function(btn)
		RunConsoleCommand("ttt_call_detective", data.eidx)
	end
	buttonCall:SetIcon(roles.DETECTIVE.iconMaterial, true, 16)

	local buttonConfirm = vgui.Create("DButtonTTT2", buttonArea)

	if client:IsSpec() then
		local text = "search_confirm"
		if (data.owner and IsValid(data.owner) and data.owner:TTT2NETGetBool("body_found", false)) then
			text = "search_confirmed"
		end

		buttonConfirm:SetEnabled(false)
		buttonConfirm:SetText(text)
		buttonConfirm:SetSize(self.sizes.widthButton, self.sizes.heightButton)
		buttonConfirm:SetPos(self.sizes.widthMainArea - self.sizes.widthButton, self.sizes.padding + 1)
	elseif data.owner and IsValid(data.owner) and data.owner:TTT2NETGetBool("body_found", false) then
		buttonConfirm:SetEnabled(false)
		buttonConfirm:SetText("search_confirmed")
		buttonConfirm:SetSize(self.sizes.widthButton, self.sizes.heightButton)
		buttonConfirm:SetPos(self.sizes.widthMainArea - self.sizes.widthButton, self.sizes.padding + 1)
	elseif data.credits > 0 and client:IsActiveShopper() and not client:GetSubRoleData().preventFindCredits then
		buttonConfirm:SetText("search_confirm_credits")
		buttonConfirm:SetParams({credits = data.credits})
		buttonConfirm:SetSize(self.sizes.widthButtonCredits, self.sizes.heightButton)
		buttonConfirm:SetPos(self.sizes.widthMainArea - self.sizes.widthButtonCredits, self.sizes.padding + 1)
		buttonConfirm:SetIcon(Material("vgui/ttt/icon_credits_transparent"))

		buttonConfirm.player_can_take_credits = true
	else
		buttonConfirm:SetText("search_confirm")
		buttonConfirm:SetSize(self.sizes.widthButton, self.sizes.heightButton)
		buttonConfirm:SetPos(self.sizes.widthMainArea - self.sizes.widthButton, self.sizes.padding + 1)
	end
	buttonConfirm.DoClick = function(btn)
		RunConsoleCommand("ttt_confirm_death", data.eidx, data.eidx + data.dtime, data.lrng)

		local creditBox = self.infoBoxes["credits"]

		if (IsValid(creditBox) and btn.player_can_take_credits) then
			creditBox:Remove()
		end
	end

	self.buttonConfirm = buttonConfirm
end

function SEARCHSCRN:Close()
	if not IsValid(self.menuFrame) then return end

	self.menuFrame:CloseFrame()
end
