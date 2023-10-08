---
-- Body search popup
-- @section body_search_manager

local net = net
local pairs = pairs
local util = util
local IsValid = IsValid
local hook = hook

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
