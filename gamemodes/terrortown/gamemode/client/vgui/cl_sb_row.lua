---- Scoreboard player score row, based on sandbox version

ttt_include("vgui__cl_sb_info")

local GetTranslation = LANG.GetTranslation
local math = math
local table = table
local ipairs = ipairs
local IsValid = IsValid
local surface = surface
local vgui = vgui

local ttt2_indicator_dev = "vgui/ttt/ttt2_indicator_dev"
local ttt2_indicator_vip = "vgui/ttt/ttt2_indicator_vip"
local ttt2_indicator_addondev = "vgui/ttt/ttt2_indicator_addondev"
local ttt2_indicator_admin = "vgui/ttt/ttt2_indicator_admin"

local dev_tbl = {
	["76561197964193008"] = true,
	["76561198049831089"] = true,
	["76561198058039701"] = true,
	["76561198047819379"] = true
}

local vip_tbl = {
	["76561198378608300"] = true, -- SirKadeeka
	["76561198102780049"] = true, -- Nick
	["76561198052323988"] = true, -- LeBroomer
	["76561198020955880"] = true  -- V3kta
}

local addondev_tbl = {}

function AddTTT2AddonDev(steamid)
	if not steamid then return end

	addondev_tbl[tostring(steamid)] = true
end

local namecolor = {
	default = COLOR_WHITE,
	dev = Color(100, 240, 105, 255),
	vip = Color(220, 55, 55, 255),
	addondev = Color(30, 105, 300, 255),
	admin = Color(255, 210, 35, 255)
}

SB_ROW_HEIGHT = 24 --16

local iconSizes = 16

local PANEL = {}

local _func1 = function(ply)
	return ply:Ping()
end

local _func2 = function(ply)
	return ply:Deaths()
end

local _func3 = function(ply)
	return ply:Frags()
end

local _func4 = function(ply)
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
	self.addondev:SetTooltip("TTT2 Addondev")

	self.admin = vgui.Create("DImage", self)
	self.admin:SetSize(iconSizes, iconSizes)
	self.admin:SetMouseInputEnabled(true)
	self.admin:SetKeepAspect(true)
	self.admin:SetTooltip("Server Admin")

	self.avatar = vgui.Create("AvatarImage", self)
	self.avatar:SetSize(SB_ROW_HEIGHT, SB_ROW_HEIGHT)
	self.avatar:SetMouseInputEnabled(false)

	self.nick = vgui.Create("DLabel", self)
	self.nick:SetMouseInputEnabled(false)

	self.nick2 = vgui.Create("DLabel", self)
	self.nick2:SetMouseInputEnabled(false)

	self.nick3 = vgui.Create("DLabel", self)
	self.nick3:SetMouseInputEnabled(false)

	self.voice = vgui.Create("DImageButton", self)
	self.voice:SetSize(iconSizes, iconSizes)

	self:SetCursor("hand")
end

function PANEL:AddColumn(label, func, width)
	local lbl = vgui.Create("DLabel", self)
	lbl.GetPlayerText = func
	lbl.IsHeading = false
	lbl.Width = width or 50 -- Retain compatibility with existing code

	table.insert(self.cols, lbl)

	return lbl
end

-- Mirror sb_main, of which it and this file both call using the
--	TTTScoreboardColumns hook, but it is useless in this file
-- Exists only so the hook wont return an error if it tries to
--	use the AddFakeColumn function of `sb_main`, which would
--	cause this file to raise a `function not found` error or others
function PANEL:AddFakeColumn()

end

function GM:TTTScoreboardColorForPlayer(ply)
	if IsValid(ply) then
		local steamid = ply:SteamID64()
		if steamid then
			steamid = tostring(steamid)
		end

		if steamid then
			if dev_tbl[steamid] then
				return namecolor.dev
			elseif vip_tbl[steamid] then
				return namecolor.vip
			elseif addondev_tbl[steamid] then
				return namecolor.addondev
			end
		end

		if ply:IsAdmin() and GetGlobalBool("ttt_highlight_admins", true) then
			return namecolor.admin
		end
	end

	return namecolor.default
end

function GM:TTTScoreboardRowColorForPlayer(ply)
	local col = Color(0, 0, 0, 0)

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
		if c and type(c) == "table" and c.r and c.b and c.g and c.a then
			return c
		else
			ErrorNoHalt("TTTScoreboardColorForPlayer hook returned something that isn't a color!\n")
		end
	end

	return namecolor.default
end

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

	self.nick:SetText(ply:Nick())
	self.nick:SizeToContents()
	self.nick:SetTextColor(ColorForPlayer(ply))

	self.nick2:SetText(ply:Nick())
	self.nick2:SizeToContents()
	self.nick2:SetTextColor(COLOR_BLACK)

	self.nick3:SetText(ply:Nick())
	self.nick3:SizeToContents()
	self.nick3:SetTextColor(CCOLOR_BLACK)

	local steamid = ply:SteamID64()
	if steamid then
		steamid = tostring(steamid)
	end

	local isdev = steamid and dev_tbl[steamid] == true

	self.dev:SetVisible(isdev)

	if not isdev then
		self.vip:SetVisible(steamid and vip_tbl[steamid] == true or false)
		self.addondev:SetVisible(steamid and addondev_tbl[steamid] == true or false)
	else
		self.vip:SetVisible(false)
		self.addondev:SetVisible(false)
	end

	self.admin:SetVisible(ply:IsAdmin())

	local ptag = ply.sb_tag

	if ScoreGroup(ply) ~= GROUP_TERROR then
		ptag = nil
	end

	self.tag:SetText(ptag and GetTranslation(ptag.txt) or "")
	self.tag:SetTextColor(ptag and ptag.color or COLOR_WHITE)

	self.sresult:SetVisible(ply.search_result ~= nil)

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

	self.nick:SetFont("treb_small")
	self.nick:SetTextColor(ColorForPlayer(self.Player))

	self.nick2:SetFont("treb_small")
	self.nick2:SetTextColor(COLOR_BLACK)

	self.nick3:SetFont("treb_small")
	self.nick3:SetTextColor(COLOR_BLACK)

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

	self.nick:SizeToContents()
	self.nick:SetPos(SB_ROW_HEIGHT + 10, (SB_ROW_HEIGHT - self.nick:GetTall()) * 0.5)

	self.nick2:SizeToContents()
	self.nick2:SetPos(SB_ROW_HEIGHT + 11, (SB_ROW_HEIGHT - self.nick:GetTall()) * 0.5 + 1)

	self.nick3:SizeToContents()
	self.nick3:SetPos(SB_ROW_HEIGHT + 9, (SB_ROW_HEIGHT - self.nick:GetTall()) * 0.5 - 1)

	self:LayoutColumns()

	self.voice:SetVisible(not self.open)
	self.voice:SetSize(iconSizes, iconSizes)
	self.voice:DockMargin(4, 4, 4, 4)
	self.voice:Dock(RIGHT)
end

function PANEL:DoClick(x, y)
	self:SetOpen(not self.open)
end

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
