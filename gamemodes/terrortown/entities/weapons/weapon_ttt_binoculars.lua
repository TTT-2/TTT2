---
-- @class SWEP
-- @section weapon_ttt_binoculars

if SERVER then
	AddCSLuaFile()
end

DEFINE_BASECLASS "weapon_tttbase"

SWEP.HoldType = "normal"

if CLIENT then
	SWEP.PrintName = "binoc_name"
	SWEP.Slot = 7

	SWEP.ViewModelFOV = 10
	SWEP.ViewModelFlip = false
	SWEP.DrawCrosshair = false

	SWEP.EquipMenuData = {
		type = "item_weapon",
		desc = "binoc_desc"
	}

	SWEP.Icon = "vgui/ttt/icon_binoc"
end

SWEP.Base = "weapon_tttbase"

SWEP.ViewModel = "models/weapons/v_crowbar.mdl"
SWEP.WorldModel = "models/props/cs_office/paper_towels.mdl"

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"
SWEP.Primary.Delay = 1.0

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = true
SWEP.Secondary.Ammo = "none"
SWEP.Secondary.Delay = 0.2

SWEP.Kind = WEAPON_EQUIP2
SWEP.CanBuy = {ROLE_DETECTIVE} -- only detectives can buy
SWEP.WeaponID = AMMO_BINOCULARS

SWEP.AllowDrop = true

SWEP.ZoomLevels = {
	0,
	30,
	20,
	10
}

SWEP.ProcessingDelay = 5

---
-- @ignore
function SWEP:SetupDataTables()
	self:NetworkVar("Bool", 0, "Processing")
	self:NetworkVar("Float", 0, "StartTime")
	self:NetworkVar("Int", 0, "Zoom")

	return self.BaseClass.SetupDataTables(self)
end

---
-- @ignore
function SWEP:PrimaryAttack()
	self:SetNextPrimaryFire(CurTime() + 0.1)

	if not self:IsTargetingCorpse() or self:GetProcessing() then return end

	self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)

	if SERVER then
		self:SetProcessing(true)
		self:SetStartTime(CurTime())
	end
end

local click = Sound("weapons/sniper/sniper_zoomin.wav")

---
-- @ignore
function SWEP:SecondaryAttack()
	self:SetNextSecondaryFire(CurTime() + self.Secondary.Delay)

	if CLIENT and IsFirstTimePredicted() then
		LocalPlayer():EmitSound(click)
	end

	self:CycleZoom()
end

---
-- @ignore
function SWEP:SetZoomLevel(level)
	if CLIENT then return end

	local owner = self:GetOwner()

	self:SetZoom(level)

	owner:SetFOV(self.ZoomLevels[level], 0.3)
	owner:DrawViewModel(false)
end

---
-- @ignore
function SWEP:CycleZoom()
	self:SetZoom(self:GetZoom() + 1)

	if not self.ZoomLevels[self:GetZoom()] then
		self:SetZoom(1)
	end

	self:SetZoomLevel(self:GetZoom())
end

---
-- @ignore
function SWEP:PreDrop()
	self:SetZoomLevel(1)

	self:SetProcessing(false)

	return self.BaseClass.PreDrop(self)
end

---
-- @ignore
function SWEP:Holster()
	self:SetZoomLevel(1)

	self:SetProcessing(false)

	return true
end

---
-- @ignore
function SWEP:Deploy()
	if SERVER and IsValid(self:GetOwner()) then
		self:GetOwner():DrawViewModel(false)
	end

	self:SetZoomLevel(1)

	return true
end

---
-- @ignore
function SWEP:Reload()
	return false
end

---
-- @return boolean
-- @realm shared
function SWEP:IsTargetingCorpse()
	local tr = self:GetOwner():GetEyeTrace(MASK_SHOT)
	local ent = tr.Entity

	return IsValid(ent) and ent:GetClass() == "prop_ragdoll" and CORPSE.GetPlayerNick(ent, false) ~= false
end

local confirm = Sound("npc/turret_floor/click1.wav")

---
-- @realm shared
function SWEP:IdentifyCorpse()
	local owner = self:GetOwner()

	if SERVER then
		local tr = owner:GetEyeTrace(MASK_SHOT)

		CORPSE.ShowSearch(owner, tr.Entity, false, true)
	elseif IsFirstTimePredicted() then
		LocalPlayer():EmitSound(confirm)
	end
end

---
-- @ignore
function SWEP:Think()
	BaseClass.Think(self)

	if not self:GetProcessing() then return end

	if not self:IsTargetingCorpse() then
		self:SetProcessing(false)
		self:SetStartTime(0)

		return
	end

	if CurTime() > (self:GetStartTime() + self.ProcessingDelay) then
		self:IdentifyCorpse()

		self:SetProcessing(false)
		self:SetStartTime(0)
	end
end

if CLIENT then
	local TryT = LANG.TryTranslation
	local GetPT = LANG.GetParamTranslation
	local mathRound = math.Round
	local mathClamp = math.Clamp

	local hud_color = Color(60, 220, 20, 255)

	local cv_thickness

	---
	-- @ignore
	function SWEP:OnRemove()
		local owner = self:GetOwner()

		if not IsValid(owner) or owner ~= LocalPlayer() or not owner:Alive() then return end

		RunConsoleCommand("lastinv")
	end

	---
	-- @ignore
	function SWEP:Initialize()
		self:AddTTT2HUDHelp("binoc_help_pri", "binoc_help_sec")
		cv_thickness = GetConVar("ttt_crosshair_thickness")

		return self.BaseClass.Initialize(self)
	end

	---
	-- @ignore
	function SWEP:DrawWorldModel()
		if IsValid(self:GetOwner()) then return end

		self:DrawModel()
	end

	---
	-- @ignore
	function SWEP:AdjustMouseSensitivity()
		if self:GetZoom() > 0 then
			return 1 / self:GetZoom()
		end

		return -1
	end

	hook.Add("TTTRenderEntityInfo", "HUDDrawTargetIDBinocular", function(tData)
		local client = LocalPlayer()
		local ent = tData:GetEntity()

		if not IsValid(client) or not client:IsTerror() or not client:Alive() then return end

		local c_wep = client:GetActiveWeapon()

		if not IsValid(c_wep) then return end

		if not IsValid(ent) or ent:GetClass() ~= "prop_ragdoll" or c_wep:GetClass() ~= "weapon_ttt_binoculars" then return end

		-- draw progress
		if not c_wep:GetProcessing() then return end

		local progress = mathRound(mathClamp((CurTime() - c_wep:GetStartTime()) / c_wep.ProcessingDelay * 100, 0, 100))

		tData:AddDescriptionLine(
			GetPT("binoc_progress", {progress = progress}),
			hud_color
		)
	end)

	---
	-- @ignore
	function SWEP:DrawHUD()
		self:DrawHelp()

		local length = 35
		local gap = 15
		local thickness = math.floor(cv_thickness and cv_thickness:GetFloat() or 1)
		local offset = thickness * 0.5

		surface.SetDrawColor(clr(hud_color))

		-- change scope when looking at corpse
		if self:IsTargetingCorpse() then
			gap = thickness * 2
		end

		local x = ScrW() * 0.5
		local y = ScrH() * 0.5

		surface.DrawRect(x - length, y - offset, length - gap, thickness)
		surface.DrawRect(x + gap, y - offset, length - gap, thickness)
		surface.DrawRect(x - offset, y - length, thickness, length - gap)
		surface.DrawRect(x - offset, y + gap, thickness, length - gap)

		draw.ShadowedText(TryT("binoc_zoom_level") .. ": " .. self:GetZoom(), "TargetID_Description", x + length + 10, y - length, hud_color, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
	end
end
