---
-- @class TBHUD
-- @desc Display of and interaction with ttt_traitor_button

local surface = surface
local pairs = pairs
local math = math
local abs = math.abs
local table = table
local net = net
local IsValid = IsValid

TBHUD = {}
TBHUD.buttons = {}
TBHUD.buttons_count = 0

TBHUD.focus_ent = nil
TBHUD.focus_stick = 0

---
-- Clears the list of stored traitor buttons
-- @realm client
function TBHUD:Clear()
	self.buttons = {}
	self.buttons_count = 0

	self.focus_ent = nil
	self.focus_stick = 0
end

---
-- Caches every available traitor button on the map for the local @{Player}
-- @realm client
function TBHUD:CacheEnts()
	local ply = LocalPlayer()

	self.buttons = {}

	if IsValid(ply) and ply:IsActive() and ply:GetSubRoleData():CanUseTraitorButton() then
		local btns = ents.FindByClass("ttt_traitor_button")

		for i = 1, #btns do
			local ent = btns[i]

			self.buttons[ent:EntIndex()] = ent
		end
	end

	self.buttons_count = table.Count(self.buttons)
end

---
-- Returns whether the local @{Player} is focussing a traitor button
-- @return boolean
-- @realm client
function TBHUD:PlayerIsFocused()
	local ply = LocalPlayer()

	return IsValid(ply) and ply:IsActive() and ply:GetSubRoleData():CanUseTraitorButton() and IsValid(self.focus_ent)
end

---
-- Runs the "ttt_use_tbutton" concommand to activate the traitor button
-- @return boolean whether the activation was successful
-- @realm client
function TBHUD:UseFocused()
	if IsValid(self.focus_ent) and self.focus_stick >= CurTime() then
		RunConsoleCommand("ttt_use_tbutton", tostring(self.focus_ent:EntIndex()))

		self.focus_ent = nil

		return true
	else
		return false
	end
end

local confirm_sound = Sound("buttons/button24.wav")

---
-- Plays a sound and caches all traitor buttons
-- @realm client
function TBHUD.ReceiveUseConfirm()
	surface.PlaySound(confirm_sound)

	TBHUD:CacheEnts()
end
net.Receive("TTT_ConfirmUseTButton", TBHUD.ReceiveUseConfirm)

--[[
local function ComputeRangeFactor(plypos, tgtpos)
	local d = tgtpos - plypos

	d = d:Dot(d)

	return d / range
end
]]--

local tbut_normal = surface.GetTextureID("vgui/ttt/ttt2_hand_line")
local tbut_focus = surface.GetTextureID("vgui/ttt/ttt2_hand_filled")
local tbut_outline = surface.GetTextureID("vgui/ttt/ttt2_hand_outline")

local size = 32
local mid = size * 0.5
local focus_range = 25

local use_key = Key("+use", "USE")

local GetTranslation = LANG.GetTranslation
local GetPTranslation = LANG.GetParamTranslation

---
-- Draws the traitor buttons on the HUD
-- @param Player client This should be the local @{Player}
-- @realm client
function TBHUD:Draw(client)
	if self.buttons_count == 0 then return end

	-- we're doing slowish distance computation here, so lots of probably
	-- ineffective micro-optimization
	local plypos = client:GetPos()
	local midscreen_x = ScrW() * 0.5
	local midscreen_y = ScrH() * 0.5
	local pos, scrpos, d
	local focus_ent
	local focus_d, focus_scrpos_x, focus_scrpos_y = 0, midscreen_x, midscreen_y
	local col = client:GetRoleColor()

	-- draw icon on HUD for every button within range
	for _, but in pairs(self.buttons) do
		if not IsValid(but) or not but.IsUsable then continue end

		pos = but:GetPos()
		scrpos = pos:ToScreen()

		if IsOffScreen(scrpos) or not but:IsUsable() then continue end

		local usableRange = but:GetUsableRange()

		d = pos - plypos
		d = d:Dot(d) / (usableRange * usableRange)

		-- draw if this button is within range, with alpha based on distance
		if d >= 1 then continue end

		surface.SetDrawColor(255, 255, 255, 200 * (1 - d))
		surface.SetTexture(tbut_normal)
		surface.DrawTexturedRect(scrpos.x - mid, scrpos.y - mid, size, size)
		
		surface.SetDrawColor(col.r, col.g, col.b, 200 * (1 - d))
		surface.SetTexture(tbut_outline)
		surface.DrawTexturedRect(scrpos.x - mid, scrpos.y - mid, size, size)

		if d <= focus_d then continue end

		local x = abs(scrpos.x - midscreen_x)
		local y = abs(scrpos.y - midscreen_y)

		if x >= focus_range
		or y >= focus_range
		or x >= focus_scrpos_x
		or y >= focus_scrpos_y
		or self.focus_stick >= CurTime() and but ~= self.focus_ent then
			continue
		end

		-- avoid constantly switching focus every frame causing
		-- 2+ buttons to appear in focus, instead "stick" to one
		-- ent for a very short time to ensure consistency
		focus_ent = but

		-- draw extra graphics and information for button when it's in-focus
		if not IsValid(focus_ent) then continue end

		self.focus_ent = focus_ent
		self.focus_stick = CurTime() + 0.1

		scrpos = focus_ent:GetPos():ToScreen()

		local sz = 16

		-- redraw in-focus version of icon
		surface.SetDrawColor(255, 255, 255, 200)
		surface.SetTexture(tbut_focus)
		surface.DrawTexturedRect(scrpos.x - mid, scrpos.y - mid, size, size)
		
		surface.SetDrawColor(col.r, col.g, col.b, 200)
		surface.SetTexture(tbut_outline)
		surface.DrawTexturedRect(scrpos.x - mid, scrpos.y - mid, size, size)

		-- description
		surface.SetTextColor(col.r, col.g, col.b, 255)
		surface.SetFont("TabLarge")

		x = scrpos.x + sz + 10
		y = scrpos.y - sz - 3

		surface.SetTextPos(x, y)
		surface.DrawText(focus_ent:GetDescription())

		y = y + 12

		surface.SetTextPos(x, y)

		if focus_ent:GetDelay() < 0 then
			surface.DrawText(GetTranslation("tbut_single"))
		elseif focus_ent:GetDelay() == 0 then
			surface.DrawText(GetTranslation("tbut_reuse"))
		else
			surface.DrawText(GetPTranslation("tbut_retime", {num = focus_ent:GetDelay()}))
		end

		y = y + 12

		surface.SetTextPos(x, y)
		surface.DrawText(GetPTranslation("tbut_help", {key = use_key}))
	end
end
