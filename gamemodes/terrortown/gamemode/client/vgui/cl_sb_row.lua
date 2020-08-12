---
-- @realm client
-- @section Scoreboard

---
-- @class PANEL
---

---
-- @section TTTScorePlayerRow
-- @desc Scoreboard player score row, based on sandbox version
---

ttt_include("vgui__cl_sb_info")

local GetTranslation = LANG.GetTranslation
local math = math
local table = table
local ipairs = ipairs
local IsValid = IsValid
local surface = surface
local vgui = vgui

local color_trans = Color(0, 0, 0, 0)

local ttt2_indicator_dev = "vgui/ttt/ttt2_indicator_dev"
local ttt2_indicator_vip = "vgui/ttt/ttt2_indicator_vip"
local ttt2_indicator_addondev = "vgui/ttt/ttt2_indicator_addondev"
local ttt2_indicator_admin = "vgui/ttt/ttt2_indicator_admin"
local ttt2_indicator_streamer = "vgui/ttt/ttt2_indicator_streamer"
local ttt2_indicator_heroes = "vgui/ttt/ttt2_indicator_heroes"

local dev_tbl = {
	["76561197964193008"] = true, -- Bad King Urgrain
	["76561198049831089"] = true, -- Alf21
	["76561198058039701"] = true, -- saibotk
	["76561198047819379"] = true, -- Mineotopia
	["76561198052323988"] = true -- LeBroomer
}

local vip_tbl = {
	["76561198378608300"] = true, -- SirKadeeka / $rã£
	["76561198102780049"] = true, -- Nick
	["76561198020955880"] = true, -- V3kta
	["76561198033468770"] = true, -- Dok441
	["76561198208729341"] = true, -- eBBIS
	["76561198152558244"] = true, -- Lost TheSuspect
	["76561198162764168"] = true, -- DerJohn
	["76561198132229662"] = true, -- Satton RU
	["76561198007725535"] = true, -- Skatcat
	["76561197989909602"] = true, -- Tobiti
	["76561198150260014"] = true, -- Lunex
	["76561198076404571"] = true, -- Histalek
	["76561198042086461"] = true, -- James
	["76561193814529882"] = true, -- Trystan
	["76561198114719750"] = true, -- Reispfannenfresser
	["76561198082931319"] = true, -- Henk
	["76561198049910438"] = true -- Zzzaaaccc13
}

local addondev_tbl = {
	["76561198102780049"] = true, -- Nick
	["76561197989909602"] = true, -- Tobiti
	["76561198076404571"] = true, -- Histalek
	["76561198027025876"] = true -- 8Z
}

---
-- @param string steamid64
function AddTTT2AddonDev(steamid64)
	if not steamid64 then return end

	addondev_tbl[tostring(steamid64)] = true
end

local streamer_tbl = {
	["76561198049831089"] = true,
	["76561198058039701"] = true,
	["76561198047819379"] = true, -- Mineotopia
	["76561198052323988"] = true
}

--TODO: move into heroes
local heroes_tbl = {
	["76561198000950884"] = true -- Dhalucard
}

local namecolor = {
	default = COLOR_WHITE,
	dev = Color(100, 240, 105, 255),
	vip = Color(220, 55, 55, 255),
	addondev = Color(30, 105, 30, 255),
	admin = Color(255, 210, 35, 255),
	streamer = Color(100, 70, 140, 255),
	heroes = Color(70, 125, 110, 255)
}

SB_ROW_HEIGHT = 24 --16

local iconSizes = 16

local PANEL = {}

local function _func1(ply)
	return ply:Ping()
end

local function _func2(ply)
	return ply:Deaths()
end

local function _func3(ply)
	return ply:Frags()
end

local function _func4(ply)
	return math.Round(ply:GetBaseKarma())
end

function PANEL:Init()
	-- cannot create info card until player state is known
	self.info = nil
	self.open = false
	self.cols = {}

	self:AddColumn(GetTranslation("sb_ping"), _func1)
	self:AddColumn(GetTranslation("sb_deaths"), _func2)
	self:AddColumn(GetTranslation("sb_score"), _func3)

	if KARMA.IsEnabled() then
		self:AddColumn(GetTranslation("sb_karma"), _func4)
	end

	-- Let hooks add their custom columns
	hook.Call("TTTScoreboardColumns", nil, self)

	for _, c in ipairs(self.cols) do
		c:SetMouseInputEnabled(false)
	end

	self.tag = vgui.Create("DLabel", self)
	self.tag:SetText("")
	self.tag:SetMouseInputEnabled(false)

	self.sresult = vgui.Create("DImage", self)
	self.sresult:SetSize(iconSizes, iconSizes)
	self.sresult:SetMouseInputEnabled(false)

	self.dev = vgui.Create("DImage", self)
	self.dev:SetSize(iconSizes, iconSizes)
	self.dev:SetMouseInputEnabled(true)
	self.dev:SetKeepAspect(true)
	self.dev:SetTooltip("TTT2 Creator")

	self.vip = vgui.Create("DImage", self)
	self.vip:SetSize(iconSizes, iconSizes)
	self.vip:SetMouseInputEnabled(true)
	self.vip:SetKeepAspect(true)
	self.vip:SetTooltip("TTT2 VIP")

	self.addondev = vgui.Create("DImage", self)
	self.addondev:SetSize(iconSizes, iconSizes)
	self.addondev:SetMouseInputEnabled(true)
	self.addondev:SetKeepAspect(true)
	self.addondev:SetTooltip("TTT2 Addon Developer")

	self.admin = vgui.Create("DImage", self)
	self.admin:SetSize(iconSizes, iconSizes)
	self.admin:SetMouseInputEnabled(true)
	self.admin:SetKeepAspect(true)
	self.admin:SetTooltip("Server Admin")

	self.streamer = vgui.Create("DImage", self)
	self.streamer:SetSize(iconSizes, iconSizes)
	self.streamer:SetMouseInputEnabled(true)
	self.streamer:SetKeepAspect(true)
	self.streamer:SetTooltip("Streamer")

	self.heroes = vgui.Create("DImage", self)
	self.heroes:SetSize(iconSizes, iconSizes)
	self.heroes:SetMouseInputEnabled(true)
	self.heroes:SetKeepAspect(true)
	self.heroes:SetTooltip("TTT2 Heroes")

	self.avatar = vgui.Create("AvatarImage", self)
	self.avatar:SetSize(SB_ROW_HEIGHT, SB_ROW_HEIGHT)
	self.avatar:SetMouseInputEnabled(false)

	self.nick2 = vgui.Create("DLabel", self)
	self.nick2:SetMouseInputEnabled(false)

	self.nick3 = vgui.Create("DLabel", self)
	self.nick3:SetMouseInputEnabled(false)

	self.nick = vgui.Create("DLabel", self)
	self.nick:SetMouseInputEnabled(false)

	self.voice = vgui.Create("DImageButton", self)
	self.voice:SetSize(iconSizes, iconSizes)

	self:SetCursor("hand")
end

---
-- Adds a column
-- @param string label
-- @param function func
-- @param number width
-- @return Panel DLabel
function PANEL:AddColumn(label, func, width)
	local lbl = vgui.Create("DLabel", self)
	lbl.GetPlayerText = func
	lbl.IsHeading = false
	lbl.Width = width or 50 -- Retain compatibility with existing code

	table.insert(self.cols, lbl)

	return lbl
end

---
-- Mirror sb_main, of which it and this file both call using the
--	TTTScoreboardColumns hook, but it is useless in this file
-- Exists only so the hook wont return an error if it tries to
--	use the AddFakeColumn function of `sb_main`, which would
--	cause this file to raise a `function not found` error or others
function PANEL:AddFakeColumn()

end

---
-- Updates the color for a @{Player} in the scoreboard
-- @param Player ply
-- @return Color
-- @hook
function GM:TTTScoreboardColorForPlayer(ply)
	if IsValid(ply) then
		local steamid64 = ply:SteamID64()
		if steamid64 then
			steamid64 = tostring(steamid64)
		end

		if steamid64 then
			if dev_tbl[steamid64] and GetGlobalBool("ttt_highlight_dev", true) then
				return namecolor.dev
			elseif vip_tbl[steamid64] and GetGlobalBool("ttt_highlight_vip", true) then
				return namecolor.vip
			elseif addondev_tbl[steamid64] and GetGlobalBool("ttt_highlight_addondev", true) then
				return namecolor.addondev
			end
		end

		if ply:IsAdmin() and GetGlobalBool("ttt_highlight_admins", true) then
			return namecolor.admin
		end
	end

	return namecolor.default
end

---
-- Updates the row color for a @{Player} in the scoreboard
-- @param Player ply
-- @return Color
-- @hook
function GM:TTTScoreboardRowColorForPlayer(ply)
	local col = color_trans

	if IsValid(ply) and ply.GetRoleColor and ply:GetRoleColor() and ply:GetSubRole() and ply:GetSubRole() ~= ROLE_INNOCENT then
		col = table.Copy(ply:GetRoleColor())
		col.a = 255 -- old value: 30
	end

	return col
end

local function ColorForPlayer(ply)
	if IsValid(ply) then
		local c = hook.Call("TTTScoreboardColorForPlayer", GAMEMODE, ply)

		-- verify that we got a proper color
		if c and istable(c) and c.r and c.b and c.g and c.a then
			return c
		else
			ErrorNoHalt("TTTScoreboardColorForPlayer hook returned something that isn't a color!\n")
		end
	end

	return namecolor.default
end

---
-- @param number width
-- @param number height
function PANEL:Paint(width, height)
	if not IsValid(self.Player) then return end

	--	if (self.Player:GetFriendStatus() == "friend") then
	--		color = Color(236, 181, 113, 255)
	--	end

	local ply = self.Player
	local c = hook.Call("TTTScoreboardRowColorForPlayer", GAMEMODE, ply)

	surface.SetDrawColor(clr(c))
	surface.DrawRect(0, 0, width, SB_ROW_HEIGHT)

	if ply == LocalPlayer() then
		surface.SetDrawColor(200, 200, 200, math.Clamp(math.sin(RealTime() * 2) * 50, 0, 100))
		surface.DrawRect(0, 0, width, SB_ROW_HEIGHT)
	end

	return true
end

---
-- @param Player ply
function PANEL:SetPlayer(ply)
	self.Player = ply
	self.avatar:SetPlayer(ply)

	if not self.info then
		local g = ScoreGroup(ply)
		-- TODO add teams

		if g == GROUP_TERROR and ply ~= LocalPlayer() then
			self.info = vgui.Create("TTTScorePlayerInfoTags", self)
			self.info:SetPlayer(ply)

			self:InvalidateLayout()
		elseif g == GROUP_FOUND or g == GROUP_NOTFOUND then
			self.info = vgui.Create("TTTScorePlayerInfoSearch", self)
			self.info:SetPlayer(ply)

			self:InvalidateLayout()
		end
	else
		self.info:SetPlayer(ply)

		self:InvalidateLayout()
	end

	self.voice.DoClick = function()
		if IsValid(ply) and ply ~= LocalPlayer() then
			ply:SetMuted(not ply:IsMuted())
		end
	end

	self:UpdatePlayerData()
end

---
-- @return Player
function PANEL:GetPlayer()
	return self.Player
end

function PANEL:UpdatePlayerData()
	if not IsValid(self.Player) then return end

	local ply = self.Player

	for i = 1, #self.cols do
		-- Set text from function, passing the label along so stuff like text
		-- color can be changed
		self.cols[i]:SetText(self.cols[i].GetPlayerText(ply, self.cols[i]))
	end

	self.nick2:SetText(ply:Nick())
	self.nick2:SizeToContents()
	self.nick2:SetTextColor(COLOR_BLACK)

	self.nick3:SetText(ply:Nick())
	self.nick3:SizeToContents()
	self.nick3:SetTextColor(COLOR_BLACK)

	self.nick:SetText(ply:Nick())
	self.nick:SizeToContents()
	self.nick:SetTextColor(ColorForPlayer(ply))

	local steamid64 = ply:SteamID64()
	if steamid64 then
		steamid64 = tostring(steamid64)
	end

	local isdev = steamid64 and dev_tbl[steamid64] == true

	self.dev:SetVisible(isdev and GetGlobalBool("ttt_highlight_dev", true))

	if not isdev or not GetGlobalBool("ttt_highlight_dev", true) then
		self.vip:SetVisible(steamid64 and vip_tbl[steamid64] and GetGlobalBool("ttt_highlight_vip", true))
		self.addondev:SetVisible(steamid64 and addondev_tbl[steamid64] and GetGlobalBool("ttt_highlight_addondev", true))
	else
		self.vip:SetVisible(false)
		self.addondev:SetVisible(false)
	end

	self.admin:SetVisible(ply:IsAdmin() and GetGlobalBool("ttt_highlight_admins", true))
	self.streamer:SetVisible(steamid64 and streamer_tbl[steamid64] and GetGlobalBool("ttt_highlight_supporter", true))
	self.heroes:SetVisible(steamid64 and heroes_tbl[steamid64] and GetGlobalBool("ttt_highlight_supporter", true))

	local ptag = ply.sb_tag

	if ScoreGroup(ply) ~= GROUP_TERROR then
		ptag = nil
	end

	self.tag:SetText(ptag and GetTranslation(ptag.txt) or "")
	self.tag:SetTextColor(ptag and ptag.color or COLOR_WHITE)

	self.sresult:SetVisible(ply.search_result and ply.search_result.detective_search)

	-- more blue if a detective searched them
	if ply.search_result and (LocalPlayer():IsDetective() or not ply.search_result.show) then
		self.sresult:SetImageColor(Color(200, 200, 255))
	end

	-- cols are likely to need re-centering
	self:LayoutColumns()

	if self.info then
		self.info:UpdatePlayerData()
	end

	if self.Player ~= LocalPlayer() then
		local muted = self.Player:IsMuted()

		self.voice:SetImage(muted and "icon16/sound_mute.png" or "icon16/sound.png")
	else
		self.voice:Hide()
	end
end

function PANEL:ApplySchemeSettings()
	for _, v in ipairs(self.cols) do
		v:SetFont("treb_small")
		v:SetTextColor(COLOR_WHITE)
	end

	self.nick2:SetFont("treb_small")
	self.nick2:SetTextColor(COLOR_BLACK)

	self.nick3:SetFont("treb_small")
	self.nick3:SetTextColor(COLOR_BLACK)

	self.nick:SetFont("treb_small")
	self.nick:SetTextColor(ColorForPlayer(self.Player))

	local ptag = self.Player and self.Player.sb_tag
	self.tag:SetTextColor(ptag and ptag.color or COLOR_WHITE)
	self.tag:SetFont("treb_small")

	self.sresult:SetImage("icon16/magnifier.png")
	self.sresult:SetImageColor(Color(170, 170, 170, 150))

	self.dev:SetImage(ttt2_indicator_dev)
	self.dev:SetImageColor(namecolor.dev)

	self.vip:SetImage(ttt2_indicator_vip)
	self.vip:SetImageColor(namecolor.vip)

	self.addondev:SetImage(ttt2_indicator_addondev)
	self.addondev:SetImageColor(namecolor.addondev)

	self.admin:SetImage(ttt2_indicator_admin)
	self.admin:SetImageColor(namecolor.admin)

	self.streamer:SetImage(ttt2_indicator_streamer)
	self.streamer:SetImageColor(namecolor.streamer)

	self.heroes:SetImage(ttt2_indicator_heroes)
	self.heroes:SetImageColor(namecolor.heroes)
end

function PANEL:LayoutColumns()
	local cx = self:GetWide()

	for _, v in ipairs(self.cols) do
		v:SizeToContents()

		cx = cx - v.Width

		v:SetPos(cx - v:GetWide() * 0.5, (SB_ROW_HEIGHT - v:GetTall()) * 0.5)
	end

	self.tag:SizeToContents()

	cx = cx - 90

	self.tag:SetPos(cx - self.tag:GetWide() * 0.5, (SB_ROW_HEIGHT - self.tag:GetTall()) * 0.5)

	self.sresult:SetPos(cx - 8, (SB_ROW_HEIGHT - iconSizes) * 0.5)

	local x = self.nick:GetPos()
	local w = self.nick:GetSize()

	local i = 0
	local mgn = 10

	local tx = x + w + mgn
	local ty = (SB_ROW_HEIGHT - iconSizes) * 0.5

	if self.dev:IsVisible() then
		self.dev:SetPos(tx + (iconSizes + mgn) * i, ty)

		i = i + 1
	end

	if self.vip:IsVisible() then
		self.vip:SetPos(tx + (iconSizes + mgn) * i, ty)

		i = i + 1
	end

	if self.addondev:IsVisible() then
		self.addondev:SetPos(tx + (iconSizes + mgn) * i, ty)

		i = i + 1
	end

	if self.admin:IsVisible() then
		self.admin:SetPos(tx + (iconSizes + mgn) * i, ty)

		i = i + 1
	end

	if self.streamer:IsVisible() then
		self.streamer:SetPos(tx + (iconSizes + mgn) * i, ty)

		i = i + 1
	end

	if self.heroes:IsVisible() then
		self.heroes:SetPos(tx + (iconSizes + mgn) * i, ty)

		i = i + 1
	end
end

function PANEL:PerformLayout()
	self.avatar:SetPos(0, 0)
	self.avatar:SetSize(SB_ROW_HEIGHT, SB_ROW_HEIGHT)

	local fw = sboard_panel.ply_frame:GetWide()

	self:SetWide(sboard_panel.ply_frame.scroll.Enabled and (fw - iconSizes) or fw)

	if not self.open then
		self:SetSize(self:GetWide(), SB_ROW_HEIGHT)

		if self.info then
			self.info:SetVisible(false)
		end
	elseif self.info then
		self:SetSize(self:GetWide(), 100 + SB_ROW_HEIGHT)

		self.info:SetVisible(true)
		self.info:SetPos(5, SB_ROW_HEIGHT + 5)
		self.info:SetSize(self:GetWide(), 100)
		self.info:PerformLayout()

		self:SetSize(self:GetWide(), SB_ROW_HEIGHT + self.info:GetTall())
	end

	local ty = (SB_ROW_HEIGHT - self.nick:GetTall()) * 0.5

	self.nick2:SizeToContents()
	self.nick2:SetPos(SB_ROW_HEIGHT + 11, ty + 1)

	self.nick3:SizeToContents()
	self.nick3:SetPos(SB_ROW_HEIGHT + 10, ty)

	self.nick:SizeToContents()
	self.nick:SetPos(SB_ROW_HEIGHT + 10, ty)

	self:LayoutColumns()

	self.voice:SetVisible(not self.open)
	self.voice:SetSize(iconSizes, iconSizes)
	self.voice:DockMargin(4, 4, 4, 4)
	self.voice:Dock(RIGHT)
end

---
-- @param number x
-- @param number y
function PANEL:DoClick(x, y)
	self:SetOpen(not self.open)
end

---
-- @param boolean o
function PANEL:SetOpen(o)
	if self.open then
		surface.PlaySound("ui/buttonclickrelease.wav")
	else
		surface.PlaySound("ui/buttonclick.wav")
	end

	self.open = o

	self:PerformLayout()
	self:GetParent():PerformLayout()

	sboard_panel:PerformLayout()
end

function PANEL:DoRightClick()
	local menu = DermaMenu()
	menu.Player = self:GetPlayer()

	local close = hook.Call("TTTScoreboardMenu", nil, menu)
	if close then
		menu:Remove()

		return
	end

	menu:Open()
end

vgui.Register("TTTScorePlayerRow", PANEL, "DButton")
