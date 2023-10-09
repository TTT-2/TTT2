---
-- Body search popup
-- @section body_search_manager

local net = net
local pairs = pairs
local util = util
local IsValid = IsValid
local hook = hook

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

	local searchUID = net.ReadUInt(16)
	local credits = net.ReadUInt(8)

	-- update credits on victrim table
	local victimEnt = player.GetBySteamID64(tbl.victim)
	if IsValid(victimEnt) then
		victimEnt.searchResultData.credits = credits
	end

	-- checking for bots
	if sid64 == "" then
		sid64 = nil
	end

	local img = draw.GetAvatarMaterial(sid64, "medium")

	---
	-- @realm client
	hook.Run("TTT2ConfirmedBody", tbl.finder, tbl.victim)

	MSTACK:AddColoredImagedMessage(LANG.GetParamTranslation(msgName, tbl), clr, img)

	if (IsValid(SEARCHSCRN.menuFrame) and SEARCHSCRN.data.searchUID == searchUID) then
		SEARCHSCRN:PlayerWasConfirmed(credits == 0)
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

function SEARCHSCRN:PlayerWasConfirmed(tookCredits)
	self.buttonConfirm:SetEnabled(false)
	self.buttonConfirm:SetText("search_confirmed")
	self.buttonConfirm:SetIcon(nil)

	if not LocalPlayer():IsSpec() then
		self.buttonReport:SetEnabled(true)
	end

	-- remove hint about player needing to confirm corpse
	local confirmBox = self.infoBoxes["detective_call_confirm"]
	if IsValid(confirmBox) then
		confirmBox:Remove()
	end

	-- if credits were taken, remove credit box
	local creditBox = self.infoBoxes["credits"]
	if IsValid(creditBox) and tookCredits then
		creditBox:Remove()
	end
end

function SEARCHSCRN:MakeInfoItem(parent, name, data, height)
	local box = vgui.Create("DInfoItemTTT2", parent)
	box:SetSize(self.sizes.widthContentBox, height or self.sizes.heightInfoItem)
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
		frame = vguihandler.GenerateFrame(self.sizes.width, self.sizes.height, {body = "search_title", params = {player = data.nick}}, true)
	end

	frame:SetPadding(self.sizes.padding, self.sizes.padding, self.sizes.padding, self.sizes.padding)

	-- any keypress closes the frame
	frame:SetKeyboardInputEnabled(true)
	frame.OnKeyCodePressed = util.BasicKeyHandler

	self.data = data
	self.menuFrame = frame

	local rd = roles.GetByIndex(data.subrole)

	local contentBox = vgui.Create("DPanelTTT2", frame)
	contentBox:SetSize(self.sizes.widthMainArea, self.sizes.heightMainArea)
	contentBox:Dock(TOP)

	local profileBox = vgui.Create("DProfilePanelTTT2", contentBox)
	profileBox:SetSize(self.sizes.widthProfileArea, self.sizes.heightMainArea)
	profileBox:Dock(LEFT)
	profileBox:SetModel(data.playerModel)
	profileBox:SetPlayerIconBySteamID64(data.sid64)
	profileBox:SetPlayerRoleColor(data.roleColor)
	profileBox:SetPlayerRoleIcon(rd.iconMaterial)
	profileBox:SetPlayerRoleString(rd.name)
	profileBox:SetPlayerTeamString(data.team)

	-- ADD STATUS BOX AND ITS CONTENT
	local contentAreaScroll = vgui.Create("DScrollPanelTTT2", contentBox)
	contentAreaScroll:SetVerticalScrollbarEnabled(true)
	contentAreaScroll:SetSize(self.sizes.widthContentArea, self.sizes.heightMainArea)
	contentAreaScroll:Dock(RIGHT)

	-- POPULATE WITH SPECIAL INFORMATION
	if data.ragOwner and IsValid(data.ragOwner) and not data.ragOwner:TTT2NETGetBool("body_found", false) then
		-- a detective can only be called AFTER a body was confirmed

		self:MakeInfoItem(contentAreaScroll, "detective_call_confirm", {
			text = {
				title = {
					body = "search_title_detective_call_confirm",
					params = nil
				},
				text = {{
					body = "search_detective_call_confirm",
					params = nil
				}}
			},
			colorBox = roles.DETECTIVE.ltcolor
		}, 62)
	end

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
			self:MakeInfoItem(contentAreaScroll, Material(v.img), {title = v.title, text = v.text})
		else
			self:MakeInfoItem(contentAreaScroll, Material(v.img), {title = v.title, text = {{body = v.text}}})
		end
	end

	-- BUTTONS
	local buttonArea = vgui.Create("DButtonPanelTTT2", frame)
	buttonArea:SetSize(self.sizes.width, self.sizes.heightBottomButtonPanel)
	buttonArea:Dock(BOTTOM)

	local buttonReport = vgui.Create("DButtonTTT2", buttonArea)
	buttonReport:SetText("search_call")
	buttonReport:SetSize(self.sizes.widthButton, self.sizes.heightButton)
	buttonReport:SetPos(0, self.sizes.padding + 1)
	buttonReport.DoClick = function(btn)
		bodysearch.ClientReportsCorpse(data.rag)
	end
	buttonReport:SetIcon(roles.DETECTIVE.iconMaterial, true, 16)

	if client:IsSpec() or data.ragOwner and IsValid(data.ragOwner) and not data.ragOwner:TTT2NETGetBool("body_found", false) then
		buttonReport:SetEnabled(false)
	end

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
	elseif data.ragOwner and IsValid(data.ragOwner) and data.ragOwner:TTT2NETGetBool("body_found", false) then
		buttonConfirm:SetEnabled(false)
		buttonConfirm:SetText("search_confirmed")
		buttonConfirm:SetSize(self.sizes.widthButton, self.sizes.heightButton)
		buttonConfirm:SetPos(self.sizes.widthMainArea - self.sizes.widthButton, self.sizes.padding + 1)
	elseif data.credits > 0 and client:IsActiveShopper() and not client:GetSubRoleData().preventFindCredits then
		if data.credits == 1 then
			buttonConfirm:SetText("search_confirm_credit")
		else
			buttonConfirm:SetText("search_confirm_credits")
		end
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
		bodysearch.ClientConfirmsCorpse(data.rag, data.searchUID, data.lrng)

		-- call this function locally to give the user an instant feedback
		-- the same function will be called again after the server processed
		-- the confirmation and reported back to the clients
		self:PlayerWasConfirmed(btn.player_can_take_credits)
	end

	-- cache button references for external interaction
	self.buttonReport = buttonReport
	self.buttonConfirm = buttonConfirm
end

function SEARCHSCRN:Close()
	if not IsValid(self.menuFrame) then return end

	self.menuFrame:CloseFrame()
end
