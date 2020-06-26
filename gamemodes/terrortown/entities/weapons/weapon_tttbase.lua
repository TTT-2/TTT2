---
-- Custom weapon base, used to derive from CS one, still very similar.
-- See <a href="https://wiki.garrysmod.com/page/Category:Weapon">Weapon</a>
-- @class Weapon

local math = math
local table = table
local util = util
local IsValid = IsValid
local surface = surface
local draw = draw
local CreateClientConVar = CreateClientConVar

if SERVER then
	AddCSLuaFile()
end

if CLIENT then
	-- hud help font
	surface.CreateFont("weapon_hud_help", {font = "Trebuchet24", size = 17, weight = 600})
	surface.CreateFont("weapon_hud_help_key", {font = "Trebuchet24", size = 13, weight = 1200})
end

--   TTT SPECIAL EQUIPMENT FIELDS

-- This must be set to one of the WEAPON_ types in TTT weapons for weapon
-- carrying limits to work properly. See /gamemode/shared.lua for all possible
-- weapon categories.
SWEP.Kind = WEAPON_NONE

-- If CanBuy is a table that contains ROLE_TRAITOR and/or ROLE_DETECTIVE, those
-- players are allowed to purchase it and it will appear in their Equipment Menu
-- for that purpose. If CanBuy is nil this weapon cannot be bought.
--	Example: SWEP.CanBuy = { ROLE_TRAITOR }
-- (just setting to nil here to document its existence, don't make this buyable)
SWEP.CanBuy = nil

if CLIENT then
	-- If this is a buyable weapon (ie. CanBuy is not nil) EquipMenuData must be
	-- a table containing some information to show in the Equipment Menu. See
	-- default equipment weapons for real-world examples.
	SWEP.EquipMenuData = nil

	-- Example data:
	-- SWEP.EquipMenuData = {
	--
	--   Type tells players if it's a weapon or item
	--	 type = "Weapon",
	--
	--   Desc is the description in the menu. Needs manual linebreaks (via \n).
	--	 desc = "Text."
	-- }

	-- This sets the icon shown for the weapon in the DNA sampler, search window,
	-- equipment menu (if buyable), etc.
	SWEP.Icon = "vgui/ttt/icon_nades" -- most generic icon I guess

	-- You can make your own weapon icon using the template in:
	--	/garrysmod/gamemodes/terrortown/template/

	-- Open one of TTT's icons with VTFEdit to see what kind of settings to use
	-- when exporting to VTF. Once you have a VTF and VMT, you can
	-- resource.AddFile("materials/vgui/...") them here. GIVE YOUR ICON A UNIQUE
	-- FILENAME, or it WILL be overwritten by other servers! Gmod does not check
	-- if the files are different, it only looks at the name. I recommend you
	-- create your own directory so that this does not happen,
	-- eg. /materials/vgui/ttt/mycoolserver/mygun.vmt
end

--   MISC TTT-SPECIFIC BEHAVIOUR CONFIGURATION

-- ALL weapons in TTT must have weapon_tttbase as their SWEP.Base. It provides
-- some functions that TTT expects, and you will get errors without them.
-- Of course this is weapon_tttbase itself, so I comment this out here.
--	SWEP.Base = "weapon_tttbase"

-- If true AND SWEP.Kind is not WEAPON_EQUIP, then this gun can be spawned as
-- random weapon by a ttt_random_weapon entity.
SWEP.AutoSpawnable = false

-- Set to true if weapon can be manually dropped by players (with Q)
SWEP.AllowDrop = true

-- Set to true if weapon kills silently (no death scream)
SWEP.IsSilent = false

-- If this weapon should be given to players upon spawning, set a table of the
-- roles this should happen for here
--	SWEP.InLoadoutFor = {ROLE_TRAITOR, ROLE_DETECTIVE, ROLE_INNOCENT}
-- use the Initialize hook to be able to use custom ROLE_XXX vars

-- DO NOT set SWEP.WeaponID. Only the standard TTT weapons can have it. Custom
-- SWEPs do not need it for anything.
--	SWEP.WeaponID = nil

--   YE OLDE SWEP STUFF

if CLIENT then
	SWEP.DrawCrosshair = false
	SWEP.ViewModelFOV = 82
	SWEP.ViewModelFlip = true
	SWEP.CSMuzzleFlashes = true
end

SWEP.Base = "weapon_base"

SWEP.Category = "TTT"
SWEP.Spawnable = false

SWEP.IsGrenade = false

SWEP.Weight = 5
SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false

SWEP.Primary.Sound = Sound("Weapon_Pistol.Empty")
SWEP.Primary.Recoil = 1.5
SWEP.Primary.Damage = 1
SWEP.Primary.NumShots = 1
SWEP.Primary.Cone = 0.02
SWEP.Primary.Delay = 0.15

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"
SWEP.Primary.ClipMax = -1

SWEP.Secondary.ClipSize = 1
SWEP.Secondary.DefaultClip = 1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"
SWEP.Secondary.ClipMax = -1

SWEP.HeadshotMultiplier = 2.7

SWEP.StoredAmmo = 0
SWEP.IsDropped = false

SWEP.DeploySpeed = 1.4

SWEP.PrimaryAnim = ACT_VM_PRIMARYATTACK
SWEP.ReloadAnim = ACT_VM_RELOAD

SWEP.fingerprints = {}

-- Time needed to enter / leave the ironsight in seconds
SWEP.IronSightTime = 0.25
-- The position offset applied when entering the ironsight
SWEP.IronSightPos = Vector(0, 0, 0)
-- The rotational offset applied when entering the ironsight
SWEP.IronSightsAng = Vector(0, 0, 0)

local sparkle = CLIENT and CreateClientConVar("ttt_crazy_sparks", "0", true) or nil
local ttt2_hold_aim = CLIENT and CreateClientConVar("ttt2_hold_aim", 0, true, false, LANG.GetTranslationFromLanguage("hold_aim", "english"), 0, 1) or nil

-- crosshair
if CLIENT then
	local GetPTranslation = LANG.GetParamTranslation
	local TryT = LANG.TryTranslation

	local sights_opacity = CreateClientConVar("ttt_ironsights_crosshair_opacity", "0.8", true)
	local crosshair_brightness = CreateClientConVar("ttt_crosshair_brightness", "1.0", true)
	local crosshair_size = CreateClientConVar("ttt_crosshair_size", "1.0", true)
	local disable_crosshair = CreateClientConVar("ttt_disable_crosshair", "0", true)
	local enable_color_crosshair = CreateClientConVar("ttt_crosshair_color_enable", "0", true)
	local crosshair_color_r = CreateClientConVar("ttt_crosshair_color_r", "30", true)
	local crosshair_color_g = CreateClientConVar("ttt_crosshair_color_g", "160", true)
	local crosshair_color_b = CreateClientConVar("ttt_crosshair_color_b", "160", true)

	local enable_gap_crosshair = CreateClientConVar("ttt_crosshair_gap_enable", "0", true)
	local crosshair_gap = CreateClientConVar("ttt_crosshair_gap", "0", true)

	local crosshair_opacity = CreateClientConVar("ttt_crosshair_opacity", "1", true)
	local crosshair_static = CreateClientConVar("ttt_crosshair_static", "0", true)
	local crosshair_weaponscale = CreateClientConVar("ttt_crosshair_weaponscale", "1", true)
	local crosshair_thickness = CreateClientConVar("ttt_crosshair_thickness", "1", true)
	local crosshair_outlinethickness = CreateClientConVar("ttt_crosshair_outlinethickness", "0", true)
	local enable_dot_crosshair = CreateClientConVar("ttt_crosshair_dot", "0", true)

	local icon_help_primary = Material("vgui/ttt/hudhelp/lmb")
	local icon_help_secondary = Material("vgui/ttt/hudhelp/rmb")

	---
	-- @see https://wiki.facepunch.com/gmod/WEAPON:DrawHUD
	-- @realm client
	function SWEP:DrawHUD()
		if self.HUDHelp then
			self:DrawHelp()
		end

		local client = LocalPlayer()

		if disable_crosshair:GetBool() or not IsValid(client) or client.isSprinting and not GetGlobalBool("ttt2_sprint_crosshair", false) then return end

		local sights = not self.NoSights and self:GetIronsights()
		local x = math.floor(ScrW() * 0.5)
		local y = math.floor(ScrH() * 0.5)
		local scale = crosshair_weaponscale:GetBool() and math.max(0.2, 10 * self:GetPrimaryCone()) or 1
		local timescale = 1

		if not crosshair_static:GetBool() then
			timescale = (2 - math.Clamp((CurTime() - self:LastShootTime()) * 5, 0.0, 1.0))
		end

		local alpha = sights and sights_opacity:GetFloat() or crosshair_opacity:GetFloat()
		local bright = crosshair_brightness:GetFloat() or 1
		local gap = enable_gap_crosshair:GetBool() and math.floor(timescale * crosshair_gap:GetFloat()) or math.floor(20 * scale * timescale * (sights and 0.8 or 1))
		local thickness = crosshair_thickness:GetFloat()
		local outline = math.floor(crosshair_outlinethickness:GetFloat())
		local length = math.floor(gap + 25 * crosshair_size:GetFloat() * scale * timescale)
		local offset = thickness * 0.5

		if outline > 0 then
			surface.SetDrawColor(0, 0, 0, 255 * alpha)
			surface.DrawRect(x - length - outline, y - offset - outline, length - gap + outline * 2, thickness + outline * 2)
			surface.DrawRect(x + gap - outline, y - offset - outline, length - gap + outline * 2, thickness + outline * 2)
			surface.DrawRect(x - offset - outline, y - length - outline, thickness + outline * 2, length - gap + outline * 2)
			surface.DrawRect(x - offset - outline, y + gap - outline, thickness + outline * 2, length - gap + outline * 2)
		end

		if enable_color_crosshair:GetBool() then
			surface.SetDrawColor(crosshair_color_r:GetInt() * bright, crosshair_color_g:GetInt() * bright, crosshair_color_b:GetInt() * bright, 255 * alpha)
		else
			-- somehow it seems this can be called before my player metatable
			-- additions have loaded
			if client.GetSubRoleData then
				local col = client:GetRoleColor()

				surface.SetDrawColor(col.r * bright, col.g * bright, col.b * bright, 255 * alpha)
			else
				surface.SetDrawColor(0, 255 * bright, 0, 255 * alpha)
			end
		end

		-- draw crosshair dot
		if enable_dot_crosshair:GetBool() then
			surface.DrawRect(x - thickness * 0.5, y - thickness * 0.5, thickness, thickness)
		end

		surface.DrawRect(x - length, y - offset, length - gap, thickness)
		surface.DrawRect(x + gap, y - offset, length - gap, thickness)
		surface.DrawRect(x - offset, y - length, thickness, length - gap)
		surface.DrawRect(x - offset, y + gap, thickness, length - gap)
	end

	function SWEP:DrawKeyBox(x, y, key)
		local pad = 3
		local pad2 = pad * 2

		x = x - pad + 1
		y = y - pad2 * 0.5 + 1

		local key_box_w, key_box_h = draw.GetTextSize(key, "weapon_hud_help_key")

		key_box_w = key_box_w + 3 * pad
		key_box_h = key_box_h + pad2

		local key_box_x = x - key_box_w + 1.5 * pad
		local key_box_y = y - key_box_h + 0.5 * pad2

		surface.SetDrawColor(0, 0, 0, 150)
		surface.DrawRect(key_box_x, key_box_y, key_box_w, key_box_h)
		draw.ShadowedText(key, "weapon_hud_help_key", x, y, COLOR_WHITE, TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM)
		draw.OutlinedShadowedBox(key_box_x, key_box_y, key_box_w, key_box_h, 1, COLOR_WHITE)
	end

	---
	-- Draws a line on the screen
	-- @param number y y coordinate of the line
	-- @param string text text for the line
	-- @param Material|string|nil icon_or_key icon or description for the concerning key
	-- @realm client 
	function SWEP:DrawHelpLine(x, y, text, icon_or_key)
		local icon_size = 18
		local valid_icon = true

		if isstring(icon_or_key) then
			self:DrawKeyBox(x, y, icon_or_key)
		elseif icon_or_key then
			draw.FilteredShadowedTexture(x - icon_size + 2, y - 17, icon_size, icon_size, icon_or_key, 255, COLOR_WHITE)
		else
			valid_icon = false
		end

		draw.ShadowedText(TryT(text), "weapon_hud_help", x + 20, y, COLOR_WHITE, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM)

		return valid_icon
	end

	---
	-- Draws the help text to the bottom of the screen
	-- @realm client
	function SWEP:DrawHelp()
		local data = self.HUDHelp
		local additional_lines = data.additional_lines
		local x = ScrW() * 0.5 - data.max_length * 0.5
		local y_start = ScrH() - 25
		local y = y_start
		local delta_y = 25
		local valid_icon = false

		for i = #additional_lines, 1, -1 do
			local line = additional_lines[i]
			local drawn_icon = self:DrawHelpLine(x, y, line.text, line.icon)

			valid_icon = valid_icon or drawn_icon
			y = y - delta_y
		end

		if valid_icon then
			local line_x = x + 10

			draw.ShadowedLine(line_x, y_start + 2, line_x, y + 8, COLOR_WHITE)
		end
	end

	-- mousebuttons are enough for most weapons
	local default_key_params = {
		primaryfire = Key("+attack", "MOUSE1"),
		secondaryfire = Key("+attack2", "MOUSE2"),
		usekey = Key("+use", "USE")
	}

	---
	-- Adds a help text for the weapon to the HUD.
	-- TTT legacy function.
	-- @param string|nil primary_text first line of the help text
	-- @param string|nil secondary_text second line of the help text
	-- @param[default=false] bool translate should the text get translated
	-- @param[opt] table extra_params parameters for @{Lang.GetParamTranslation}
	-- @realm client
	function SWEP:AddHUDHelp(primary_text, secondary_text, translate, extra_params)
		local primary = primary_text
		local secondary = secondary_text

		if translate then
			extra_params = extra_params or {}
			translate_params = table.Merge(extra_params, default_key_params)
			primary = primary and GetPTranslation(primary, translate_params)
			secondary = secondary and GetPTranslation(secondary, translate_params)
		end

		--find mouse keys in the texts to add respective icons
		primary_key = primary and string.find(primary, "MOUSE1") and Key("+attack", "MOUSE1") or nil
		secondary_key = secondary and string.find(secondary, "MOUSE2") and Key("+attack2", "MOUSE2") or nil

		self:AddTTT2HUDHelp()

		if primary then
			self:AddHUDHelpLine(primary, primary_key)
		end

		if secondary then
			self:AddHUDHelpLine(secondary, secondary_key)
		end
	end

	---
	-- Adds a help text for the weapon to the HUD.
	-- @param string|nil primary_text description for primaryfire
	-- @param string|nil secondary_text description for secondaryfire
	-- @realm client
	function SWEP:AddTTT2HUDHelp(primary, secondary)
		self.HUDHelp = {}
		self.HUDHelp.additional_lines = {}
		self.HUDHelp.max_length = 0

		if primary then
			self:AddHUDHelpLine(primary, Key("+attack", "MOUSE1"))
		end

		if secondary then
			self:AddHUDHelpLine(secondary, Key("+attack2", "MOUSE2"))
		end
	end

	---
	-- Adds an additional line to the help text.
	-- @{SWEP:AddTTT2HUDHelp} needs to be called first
	-- @param string text text to be displayed on the line
	-- @param Material|string|nil icon_or_key icon or description for the concerning key
	-- @realm client
	function SWEP:AddHUDHelpLine(text, icon_or_key)
		if not self.HUDHelp then return end

		--replace MOUSE1/MOUSE2 strings with respective icons
		if isstring(icon_or_key) then
			if icon_or_key == "MOUSE1" then
				icon_or_key = icon_help_primary
			elseif icon_or_key == "MOUSE2" then
				icon_or_key = icon_help_secondary
			end
		end

		local width = draw.GetTextSize(text, "weapon_hud_help")

		self.HUDHelp.additional_lines[#self.HUDHelp.additional_lines + 1] = {text = text, icon = icon_or_key}
		self.HUDHelp.max_length = math.max(self.HUDHelp.max_length, width)
	end
end

---
-- Called if the player presses IN_ATTACK (Default: Left Mouse Button)
-- Shooting functions largely copied from weapon_cs_base
-- @param boolean worldsnd
-- @see https://wiki.facepunch.com/gmod/WEAPON:PrimaryAttack
-- @realm shared
function SWEP:PrimaryAttack(worldsnd)
	self:SetNextSecondaryFire(CurTime() + self.Primary.Delay)
	self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)

	if not self:CanPrimaryAttack() then return end

	if not worldsnd then
		self:EmitSound(self.Primary.Sound, self.Primary.SoundLevel)
	elseif SERVER then
		sound.Play(self.Primary.Sound, self:GetPos(), self.Primary.SoundLevel)
	end

	self:ShootBullet(self.Primary.Damage, self.Primary.Recoil, self.Primary.NumShots, self:GetPrimaryCone())
	self:TakePrimaryAmmo(1)

	local owner = self:GetOwner()

	if not IsValid(owner) or owner:IsNPC() or not owner.ViewPunch then return end

	owner:ViewPunch(Angle(util.SharedRandom(self:GetClass(), -0.2, -0.1, 0) * self.Primary.Recoil, util.SharedRandom(self:GetClass(), -0.1, 0.1, 1) * self.Primary.Recoil, 0))
end

---
-- @param function setnext
function SWEP:DryFire(setnext)
	if CLIENT and LocalPlayer() == self:GetOwner() then
		self:EmitSound("Weapon_Pistol.Empty")
	end

	setnext(self, CurTime() + 0.2)

	self:Reload()
end

---
-- Helper function for checking for no ammo.
-- @return boolean
-- @see https://wiki.facepunch.com/gmod/WEAPON:CanPrimaryAttack
-- @realm shared
function SWEP:CanPrimaryAttack()
	if not IsValid(self:GetOwner()) then return end

	if self:Clip1() <= 0 then
		self:DryFire(self.SetNextPrimaryFire)

		return false
	end

	return true
end

---
-- Helper function for checking for no ammo.
-- @return boolean
-- @see https://wiki.facepunch.com/gmod/WEAPON:CanSecondaryAttack
-- @realm shared
function SWEP:CanSecondaryAttack()
	if not IsValid(self:GetOwner()) then return end

	if self:Clip2() <= 0 then
		self:DryFire(self.SetNextSecondaryFire)

		return false
	end

	return true
end

local function Sparklies(attacker, tr, dmginfo)
	if not tr.HitWorld or tr.MatType ~= MAT_METAL then return end

	local eff = EffectData()
	eff:SetOrigin(tr.HitPos)
	eff:SetNormal(tr.HitNormal)

	util.Effect("cball_bounce", eff)
end

---
-- A convenience function to shoot bullets
-- @param CTakeDamageInfo dmg
-- @param number recoil
-- @param number numbul
-- @param number cone
-- @see https://wiki.facepunch.com/gmod/WEAPON:ShootBullet
-- @realm shared
function SWEP:ShootBullet(dmg, recoil, numbul, cone)
	self:SendWeaponAnim(self.PrimaryAnim)

	self:GetOwner():MuzzleFlash()
	self:GetOwner():SetAnimation(PLAYER_ATTACK1)

	local sights = self:GetIronsights()

	numbul = numbul or 1
	cone = cone or 0.01

	local bullet = {}
	bullet.Num = numbul
	bullet.Src = self:GetOwner():GetShootPos()
	bullet.Dir = self:GetOwner():GetAimVector()
	bullet.Spread = Vector(cone, cone, 0)
	bullet.Tracer = 4
	bullet.TracerName = self.Tracer or "Tracer"
	bullet.Force = 10
	bullet.Damage = dmg

	if CLIENT and sparkle:GetBool() then
		bullet.Callback = Sparklies
	end

	self:GetOwner():FireBullets(bullet)

	-- Owner can die after firebullets
	if not IsValid(self:GetOwner()) or not self:GetOwner():Alive() or self:GetOwner():IsNPC() then return end

	if game.SinglePlayer() and SERVER
	or not game.SinglePlayer() and CLIENT and IsFirstTimePredicted() then
		-- reduce recoil if ironsighting
		recoil = sights and (recoil * 0.6) or recoil

		local eyeang = self:GetOwner():EyeAngles()
		eyeang.pitch = eyeang.pitch - recoil

		self:GetOwner():SetEyeAngles(eyeang)
	end
end

---
-- @return number
function SWEP:GetPrimaryCone()
	local cone = self.Primary.Cone or 0.2

	-- 10% accuracy bonus when sighting
	return self:GetIronsights() and (cone * 0.85) or cone
end

---
-- @param Player victim
-- @param CTakeDamageInfo dmginfo
-- @return number
-- @realm shared
function SWEP:GetHeadshotMultiplier(victim, dmginfo)
	return self.HeadshotMultiplier
end

---
-- @return boolean
-- @realm shared
function SWEP:IsEquipment()
	return WEPS.IsEquipment(self)
end

---
-- This hook draws the selection icon in the weapon selection menu.
-- @see https://wiki.facepunch.com/gmod/WEAPON:DrawWeaponSelection
-- @realm client
function SWEP:DrawWeaponSelection()

end

---
-- Called if the player presses IN_ATTACK2 (Default: Right mouse button).
-- You can override it to implement special attacks, but it is usually reserved for aiming with ironsights.
-- @see https://wiki.facepunch.com/gmod/WEAPON:SecondaryAttack
-- @realm shared
function SWEP:SecondaryAttack()
	if self.NoSights or not self.IronSightsPos then return end

	local bNotIronsights = not self:GetIronsights()

	self:SetIronsights(bNotIronsights)
	self:SetZoom(bNotIronsights)
	self:SetNextSecondaryFire(CurTime() + 0.3)
end

---
-- Called when player has just switched to this weapon.
-- @return[default=true] boolean
-- @see https://wiki.facepunch.com/gmod/WEAPON:Deploy
-- @realm shared
function SWEP:Deploy()
	self:SetIronsights(false)
	self:SetZoom(false)

	return true
end

---
-- Called if the player presses IN_RELOAD
-- @see https://wiki.facepunch.com/gmod/WEAPON:Reload
-- @realm shared
function SWEP:Reload()
	if self:Clip1() == self.Primary.ClipSize or self:GetOwner():GetAmmoCount(self.Primary.Ammo) <= 0 then return end

	self:DefaultReload(self.ReloadAnim)
	self:SetIronsights(false)
	self:SetZoom(false)
end

---
-- Called when the weapon entity is reloaded on a changelevel event
-- @see https://wiki.facepunch.com/gmod/WEAPON:OnRestore
-- @realm shared
function SWEP:OnRestore()
	self.NextSecondaryAttack = 0

	self:SetIronsights(false)
	self:SetZoom(false)
end

---
-- Returns how much of primary ammo the player has
-- @return number|boolean
-- @see https://wiki.facepunch.com/gmod/WEAPON:Ammo1
-- @realm shared
function SWEP:Ammo1()
	return IsValid(self:GetOwner()) and self:GetOwner():GetAmmoCount(self.Primary.Ammo) or false
end

---
-- The OnDrop() hook is useless for this as it happens AFTER the drop. OwnerChange
-- does not occur when a drop happens for some reason. Hence this thing.
-- @realm server
function SWEP:PreDrop()
	if CLIENT or not IsValid(self:GetOwner()) or self.Primary.Ammo == "none" then return end

	local ammo = self:Ammo1()

	-- Do not drop ammo if we have another gun that uses this type
	local weps = self:GetOwner():GetWeapons()

	for i = 1, #weps do
		local w = weps[i]

		if not IsValid(w) or w == self or w:GetPrimaryAmmoType() ~= self:GetPrimaryAmmoType() then continue end

		ammo = 0
	end

	self.StoredAmmo = ammo

	if ammo > 0 then
		self:GetOwner():RemoveAmmo(ammo, self.Primary.Ammo)
	end
end

---
-- Helper function to slow down dropped weapons
-- @realm server
function SWEP:DampenDrop()
	-- For some reason gmod drops guns on death at a speed of 400 units, which
	-- catapults them away from the body. Here we want people to actually be able
	-- to find a given corpse's weapon, so we override the velocity here and call
	-- this when dropping guns on death.
	local phys = self:GetPhysicsObject()

	if IsValid(phys) then
		phys:SetVelocityInstantaneous(Vector(0, 0, - 75) + phys:GetVelocity() * 0.001)
		phys:AddAngleVelocity(phys:GetAngleVelocity() * -0.99)
	end
end

local SF_WEAPON_START_CONSTRAINED = 1

---
-- Called when a player has picked the weapon up
-- Transfers the currently stored ammo to the new player and updates the fingerprints
-- @param Player newowner
-- @see https://wiki.facepunch.com/gmod/WEAPON:Equip
-- @realm server
function SWEP:Equip(newowner)
	if self:IsOnFire() then
		self:Extinguish()
	end

	self.fingerprints = self.fingerprints or {}

	if not table.HasValue(self.fingerprints, newowner) then
		self.fingerprints[#self.fingerprints + 1] = newowner
	end

	if self:HasSpawnFlags(SF_WEAPON_START_CONSTRAINED) then
		-- If this weapon started constrained, unset that spawnflag, or the
		-- weapon will be re-constrained and float
		local flags = self:GetSpawnFlags()
		local newflags = bit.band(flags, bit.bnot(SF_WEAPON_START_CONSTRAINED))

		self:SetKeyValue("spawnflags", newflags)
	end

	if IsValid(newowner) and self.StoredAmmo > 0 and self.Primary.Ammo ~= "none" then
		local ammo = newowner:GetAmmoCount(self.Primary.Ammo)
		local given = math.min(self.StoredAmmo, self.Primary.ClipMax - ammo)

		newowner:GiveAmmo(given, self.Primary.Ammo)

		self.StoredAmmo = 0
	end
end

---
-- We were bought as special equipment, some weapons will want to do something
-- extra for their buyer
-- @param Player buyer
-- @realm server
function SWEP:WasBought(buyer)

end

---
-- Zoom in or out. Use this in combination with SetIronsights.
-- Look at weapon_ttt_m16 for an example of how to use this.
-- @param boolean zoomIn
-- @realm shared
function SWEP:SetZoom(zoomIn)

end

---
-- Sets the flag signaling whether or not the ironsights should be used
-- @param boolean b
-- @realm shared
function SWEP:SetIronsights(b)
	if b == self:GetIronsights() then return end

	self:SetIronsightsPredicted(b)
	self:SetIronsightsTime(CurTime())

	if CLIENT then
		self:CalcViewModel()
	end
end

---
-- Gets the flag signaling whether or not the ironsights should be used
-- @return boolean
-- @realm shared
function SWEP:GetIronsights()
	return self:GetIronsightsPredicted()
end

---
-- Dummy functions that will be replaced when SetupDataTables runs. These are
-- here for when that does not happen (due to e.g. stacking base classes)
-- @return[default=-1] number
-- @realm shared
function SWEP:GetIronsightsTime()
	return -1
end

---
-- Dummy functions that will be replaced when SetupDataTables runs. These are
-- here for when that does not happen (due to e.g. stacking base classes)
function SWEP:SetIronsightsTime()

end

---
-- Dummy functions that will be replaced when SetupDataTables runs. These are
-- here for when that does not happen (due to e.g. stacking base classes)
-- @return[default=false] boolean
-- @realm shared
function SWEP:GetIronsightsPredicted()
	return false
end

---
-- Dummy functions that will be replaced when SetupDataTables runs. These are
-- here for when that does not happen (due to e.g. stacking base classes)
-- @realm shared
function SWEP:SetIronsightsPredicted()

end

---
-- Called when the SWEP should set up its Data Tables.
-- Sets up the networked vars for ironsights.
-- @warning Weapons using their own DT vars will have to make sure they call this.
-- @see https://wiki.facepunch.com/gmod/WEAPON:SetupDataTables
-- @realm shared
function SWEP:SetupDataTables()
	self:NetworkVar("Bool", 3, "IronsightsPredicted")
	self:NetworkVar("Float", 3, "IronsightsTime")
end

---
-- Called when the weapon entity is created.
-- @see https://wiki.facepunch.com/gmod/WEAPON:Initialize
-- @realm shared
function SWEP:Initialize()
	if CLIENT and self:Clip1() == -1 then
		self:SetClip1(self.Primary.DefaultClip)
	elseif SERVER then
		self.fingerprints = {}

		self:SetIronsights(false)
		self:SetZoom(false)
	end

	self:SetDeploySpeed(self.DeploySpeed)

	-- compat for gmod update
	if self.SetHoldType then
		self:SetHoldType(self.HoldType or "pistol")
	end
end

---
-- @realm client
function SWEP:CalcViewModel()
	if not CLIENT or not IsFirstTimePredicted() then return end

	self.bIron = self:GetIronsights()
	self.fIronTime = self:GetIronsightsTime()
	self.fCurrentTime = CurTime()
	self.fCurrentSysTime = SysTime()
end

---
-- Called when the swep thinks.
-- @warning If you override Think in your SWEP, you should call BaseClass.Think(self) so as not to break ironsights
-- @see https://wiki.facepunch.com/gmod/WEAPON:Think
-- @realm shared
function SWEP:Think()
	self:CalcViewModel()
end

---
-- Experimental. Enables a feature that causes a player who is using his ironsights and is killed (by a gun, and not a headshot) to fire an inaccurate dying shot.
-- @return boolean
-- @see http://www.troubleinterroristtown.com/config-and-commands/convars#TOC-Other-gameplay-settings
-- @realm server
function SWEP:DyingShot()
	if not self:GetIronsights() then
		return false
	end

	self:SetIronsights(false)
	self:SetZoom(false)

	if self:GetNextPrimaryFire() > CurTime() then
		return false
	end

	-- Owner should still be alive here
	local owner = self:GetOwner()
	if not IsValid(owner) then
		return false
	end

	local punch = self.Primary.Recoil or 5

	-- Punch view to disorient aim before firing dying shot
	local eyeang = owner:EyeAngles()
	eyeang.pitch = eyeang.pitch - math.Rand(-punch, punch)
	eyeang.yaw = eyeang.yaw - math.Rand(-punch, punch)

	owner:SetEyeAngles(eyeang)

	MsgN(owner:Nick() .. " fired his DYING SHOT")

	owner.dying_wep = self

	self:PrimaryAttack(true)

	return true
end

local ttt_lowered = CreateConVar("ttt_ironsights_lowered", "1", FCVAR_ARCHIVE)
local host_timescale = GetConVar("host_timescale")
local LOWER_POS = Vector(0, 0, -2)
local IRONSIGHT_TIME = 0.25

---
-- This hook allows you to adjust view model position and angles.
-- @param Vector pos
-- @param Angle ang
-- @return Vector
-- @return Angle
-- @see https://wiki.facepunch.com/gmod/WEAPON:GetViewModelPosition
-- @realm client
function SWEP:GetViewModelPosition(pos, ang)
	if not self.IronSightsPos or self.bIron == nil then
		return pos, ang
	end

	local bIron = self.bIron
	local time = self.fCurrentTime + (SysTime() - self.fCurrentSysTime) * game.GetTimeScale() * host_timescale:GetFloat()

	if bIron then
		self.SwayScale = 0.3
		self.BobScale = 0.1
	else
		self.SwayScale = 1.0
		self.BobScale = 1.0
	end

	local fIronTime = self.fIronTime

	if not bIron and fIronTime < time - IRONSIGHT_TIME then
		return pos, ang
	end

	local mul = 1.0

	if fIronTime > time - IRONSIGHT_TIME then
		mul = math.Clamp((time - fIronTime) / IRONSIGHT_TIME, 0, 1)

		if not bIron then
			mul = 1 - mul
		end
	end

	local offset = self.IronSightsPos + (ttt_lowered:GetBool() and LOWER_POS or vector_origin)

	if self.IronSightsAng then
		ang = Angle(ang)
		ang:RotateAroundAxis(ang:Right(), self.IronSightsAng.x * mul)
		ang:RotateAroundAxis(ang:Up(), self.IronSightsAng.y * mul)
		ang:RotateAroundAxis(ang:Forward(), self.IronSightsAng.z * mul)
	end

	pos = pos + offset.x * ang:Right() * mul
	pos = pos + offset.y * ang:Forward() * mul
	pos = pos + offset.z * ang:Up() * mul

	return pos, ang
end

---
-- Tell the server about the users preference regarding holding aim or toggle aim,
-- necessary to avoid prediction issues
local function UpdateHoldAimCV()
	net.Start("TTT2UpdateHoldAimConvar")
	net.WriteBool(ttt2_hold_aim:GetBool())
	net.SendToServer()
end

hook.Add("KeyRelease", "TTT2ResetIronSights", function(ply, key)
	if key ~= IN_ATTACK2 or not IsValid(ply) then return end

	if not (CLIENT and ttt2_hold_aim:GetBool() or SERVER and ply.holdAim) then return end

	local wep = ply:GetActiveWeapon()

	if not IsValid(wep) or not wep:GetIronsights() then return end

	wep:SetIronsights(false)
	wep:SetZoom(false)
end)

if CLIENT then
	hook.Add("InitPostEntity", "TTT2InitHoldAimCV", function()
		UpdateHoldAimCV()
	end)

	cvars.AddChangeCallback("ttt2_hold_aim", function(cvar, old, new)
		UpdateHoldAimCV()
	end)
else
	net.Receive("TTT2UpdateHoldAimConvar", function(len, ply)
		ply.holdAim = net.ReadBool()
	end)
end
