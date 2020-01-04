---
-- @module TIPS
-- @desc Tips panel shown to specs

local math = math
local table = table
local pairs = pairs
local timer = timer
local IsValid = IsValid
local CreateConVar = CreateConVar

local cv_ttt_tips_enable = CreateConVar("ttt_tips_enable", "1", FCVAR_ARCHIVE)

local draw = draw
local GetTranslation = LANG.GetTranslation
local GetPTranslation = LANG.GetParamTranslation

TIPS = {}

-- Tip cycling button
PANEL = {}
PANEL.Colors = {
	default = COLOR_LGRAY,
	hover = COLOR_WHITE,
	press = COLOR_RED
}

---
-- @local
function PANEL:Paint()
	-- parent panel will deal with the normal bg, we only need to worry about
	-- mouse effects

	local c = self.Colors.default

	if self.Depressed then
		c = self.Colors.press
	elseif self.Hovered then
		c = self.Colors.hover
	end

	surface.SetDrawColor(c.r, c.g, c.b, c.a)

	self:DrawOutlinedRect()
end

derma.DefineControl("TipsButton", "Tip cycling button", PANEL, "DButton")


-- Main tip panel
local tips_bg = Color(0, 0, 0, 200)
local tip_ids = {}

for i = 1, 40 do
	tip_ids[i] = i
end

table.Shuffle(tip_ids)

local tip_params = {
	[1] = {walkkey = Key("+walk", "WALK"), usekey = Key("+use", "USE")},
	[24] = {helpkey = Key("+gm_showhelp", "F1")},
	[28] = {mutekey = Key("+gm_showteam", "F2")},
	[30] = {zoomkey = Key("+zoom", "the 'Suit Zoom' key")},
	[31] = {duckkey = Key("+duck", "DUCK")},
	[36] = {helpkey = Key("+gm_showhelp", "F1")},
}

PANEL = {}

---
-- @local
function PANEL:Init()
	self.IdealWidth = 450
	self.IdealHeight = 45
	self.BgColor = tips_bg

	self.NextSwitch = 0

	self.AutoDelay = 15
	self.ManualDelay = 25

	self.tiptext = vgui.Create("DLabel", self)
	self.tiptext:SetContentAlignment(5)
	self.tiptext:SetText(GetTranslation("tips_panel_title"))

	self.bwrap = vgui.Create("Panel", self)

	self.buttons = {}
	self.buttons.left = vgui.Create("TipsButton", self.bwrap)
	self.buttons.left:SetText("<")

	self.buttons.left.DoClick = function()
		self:PrevTip()
	end

	self.buttons.right = vgui.Create("TipsButton", self.bwrap)
	self.buttons.right:SetText(">")

	self.buttons.right.DoClick = function()
		self:NextTip()
	end

	self.buttons.help = vgui.Create("TipsButton", self.bwrap)
	self.buttons.help:SetText("?")
	self.buttons.help:SetConsoleCommand("ttt_helpscreen")

	self.buttons.close = vgui.Create("TipsButton", self.bwrap)
	self.buttons.close:SetText("X")
	self.buttons.close:SetConsoleCommand("ttt_tips_hide")

	self.TipIndex = math.random(#tip_ids) or 0

	self:SetTip(self.TipIndex)
end

---
-- @class PANEL
-- @section TIPS
---

---
-- Sets the current tip index
-- @param number idx
-- @realm client
-- @local
function PANEL:SetTip(idx)
	if not idx then
		self:SetVisible(false)

		return
	end

	self.TipIndex = idx

	local tip_id = tip_ids[idx]

	local text

	if tip_params[tip_id] then
		text = GetPTranslation("tip" .. tip_id, tip_params[tip_id])
	else
		text = GetTranslation("tip" .. tip_id)
	end

	self.tiptext:SetText(GetTranslation("tips_panel_tip") .. " " .. text)

	self:InvalidateLayout(true)
end

---
-- Increases the current tip index
-- @param boolean auto If this switched automatically, there will be another delay
-- than doing it manually
-- @realm client
-- @local
function PANEL:NextTip(auto)
	if not self.TipIndex then return end

	local idx = self.TipIndex + 1

	if idx > #tip_ids then
		idx = 1
	end

	self:SetTip(idx)

	self.NextSwitch = CurTime() + (auto and self.AutoDelay or self.ManualDelay)
end

---
-- Decreases the current tip index
-- @param boolean auto If this switched automatically, there will be another delay
-- than doing it manually
-- @realm client
-- @local
function PANEL:PrevTip(auto)
	if not self.TipIndex then return end

	local idx = self.TipIndex - 1

	if idx < 1 then
		idx = #tip_ids
	end

	self:SetTip(idx)

	self.NextSwitch = CurTime() + (auto and self.AutoDelay or self.ManualDelay)
end

---
-- @local
function PANEL:PerformLayout()
	local m = 8
	local off_bottom = 10

	-- need to account for voice stuff in the bottom right and the time in the
	-- bottom left
	local off_left = 260
	local off_right = 250
	local room = ScrW() - off_left - off_right
	local width = math.min(room, self.IdealWidth)

	if width < 200 then
		-- people who run 640x480 do not deserve tips
		self:SetVisible(false)

		return
	end

	local bsize = 14

	-- position buttons
	self.bwrap:SetSize(bsize * 2 + 2, bsize * 2 + 2)

	self.buttons.left:SetSize(bsize, bsize)
	self.buttons.left:SetPos(0, 0)

	self.buttons.right:SetSize(bsize, bsize)
	self.buttons.right:SetPos(bsize + 2, 0)

	self.buttons.help:SetSize(bsize, bsize)
	self.buttons.help:SetPos(0, bsize + 2)

	self.buttons.close:SetSize(bsize, bsize)
	self.buttons.close:SetPos(bsize + 2, bsize + 2)

	-- position content
	self.tiptext:SetPos(m, m)
	self.tiptext:SetTall(self.IdealHeight)
	self.tiptext:SetWide(width - m * 2 - self.bwrap:GetWide())
	self.tiptext:SizeToContentsY()

	local height = math.max(self.IdealHeight, self.tiptext:GetTall() + m * 2)

	local x = off_left + (room - width) * 0.5
	local y = ScrH() - off_bottom - height

	self:SetPos(x, y)
	self:SetSize(width, height)

	self.bwrap:SetPos(width - self.bwrap:GetWide() - m, height - self.bwrap:GetTall() - m)
end

---
-- @local
function PANEL:ApplySchemeSettings()
	for _, but in pairs(self.buttons) do
		but:SetTextColor(COLOR_WHITE)
		but:SetContentAlignment(5)
	end

	self.bwrap:SetPaintBackgroundEnabled(false)

	self.tiptext:SetFont("DefaultBold")
	self.tiptext:SetTextColor(COLOR_WHITE)
	self.tiptext:SetWrap(true)
end

---
-- @local
function PANEL:Paint(w, h)
	self.paintColor = self.BgColor

	if huds and HUDManager then
		local hud = huds.GetStored(HUDManager.GetHUD())
		if hud and isfunction(hud.popupPaint) then
			hud.popupPaint(self, w, h)

			return
		end
	end

	draw.RoundedBox(8, 0, 0, w, h, self.BgColor)
end

---
-- @local
function PANEL:Think()
	if self.NextSwitch < CurTime() then
		self:NextTip(true)
	end
end

vgui.Register("TTTTips", PANEL, "Panel")

---
-- @module TIPS
-- @section
---

-- Creation

local tips_panel

---
-- Creates the @{TIPS} menu
-- @realm client
function TIPS.Create()
	if IsValid(tips_panel) then
		tips_panel:Remove()

		tips_panel = nil
	end

	tips_panel = vgui.Create("TTTTips")

	-- workaround for layout oddities, give it a poke next tick
	timer.Simple(0.1, TIPS.Next)
end

---
-- Displays the @{TIPS} menu
-- @realm client
function TIPS.Show()
	if not cv_ttt_tips_enable:GetBool() then return end

	if not tips_panel then
		TIPS.Create()
	end

	tips_panel:SetVisible(true)
end

---
-- Hides the @{TIPS} menu
-- @realm client
function TIPS.Hide()
	if tips_panel then
		tips_panel:SetVisible(false)
	end

	if GAMEMODE.ForcedMouse then
		-- currently the only use of unlocking the mouse is screwing around with
		-- the hints, and it makes sense to lock the mouse again when closing the
		-- tips
		gui.EnableScreenClicker(false)

		GAMEMODE.ForcedMouse = false
	end
end
concommand.Add("ttt_tips_hide", TIPS.Hide)

---
-- Switches to the next tip
-- @realm client
function TIPS.Next()
	if tips_panel then
		tips_panel:NextTip()
	end
end

---
-- Switches to the previous tip
-- @realm client
function TIPS.Prev()
	if tips_panel then
		tips_panel:PrevTip()
	end
end

local function TipsCallback(cv, prev, new)
	if tobool(new) then
		if not LocalPlayer():IsSpec() then return end

		TIPS.Show()
	else
		TIPS.Hide()
	end
end
cvars.AddChangeCallback("ttt_tips_enable", TipsCallback)
