if SERVER then
	AddCSLuaFile()
end

local math = math
local table = table

DEFINE_BASECLASS "weapon_tttbase"

SWEP.HoldType = "pistol"

if CLIENT then
	SWEP.PrintName = "dna_name"
	SWEP.Slot = 8

	SWEP.ViewModelFOV = 54
	SWEP.ViewModelFlip = false
	SWEP.UseHands = true
	SWEP.DrawCrosshair = false

	SWEP.EquipMenuData = {
		type = "item_weapon",
		desc = "dna_desc"
	}

	SWEP.Icon = "vgui/ttt/icon_wtester"
else
	--network messages
	util.AddNetworkString("TTT2ScannerFeedback")
	util.AddNetworkString("TTT2ScannerUpdate")

	-- ConVar syncing
	local dna_mode = CreateConVar("ttt2_dna_radar", "0", {FCVAR_NOTIFY, FCVAR_ARCHIVE})
	local dna_slots = CreateConVar("ttt2_dna_scanner_slots", "4", {FCVAR_NOTIFY, FCVAR_ARCHIVE})
	local dna_radar_cd = CreateConVar("ttt2_dna_radar_cooldown", "5.0", {FCVAR_NOTIFY, FCVAR_ARCHIVE})

	hook.Add("TTT2SyncGlobals", "TTT2SyncDNAScannerGlobals", function()
		SetGlobalBool(dna_mode:GetName(), dna_mode:GetBool())
		SetGlobalInt(dna_slots:GetName(), dna_slots:GetInt())
		SetGlobalFloat(dna_radar_cd:GetName(), dna_radar_cd:GetFloat())
	end)

	cvars.AddChangeCallback(dna_mode:GetName(), function(name, old, new)
		SetGlobalBool(dna_mode:GetName(), tobool(new))
	end, dna_mode:GetName())

	cvars.AddChangeCallback(dna_slots:GetName(), function(name, old, new)
		SetGlobalInt(dna_slots:GetName(), tonumber(new))
	end, dna_slots:GetName())

	cvars.AddChangeCallback(dna_radar_cd:GetName(), function(name, old, new)
		SetGlobalFloat(dna_radar_cd:GetName(), tonumber(new))
	end, dna_radar_cd:GetName())
end

SWEP.Base = "weapon_tttbase"

SWEP.ViewModel = "models/weapons/v_ttt2_dna_scanner.mdl"
SWEP.WorldModel = "models/weapons/w_ttt2_dna_scanner.mdl"

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false
SWEP.Primary.Delay = 0.5
SWEP.Primary.Ammo = "none"

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"
SWEP.Secondary.Delay = 0

SWEP.Kind = WEAPON_ROLE
SWEP.CanBuy = nil -- no longer a buyable thing
SWEP.WeaponID = AMMO_WTESTER
SWEP.InLoadoutFor = {ROLE_DETECTIVE}
SWEP.AutoSpawnable = false
SWEP.NoSights = true

SWEP.Range = 175

SWEP.ItemSamples = {}
SWEP.CachedTargets = {}
SWEP.ScanSuccess = 0
SWEP.ScanTime = CurTime()
SWEP.ActiveSample = 1
SWEP.NewSample = 1
SWEP.LastRadar = CurTime()
SWEP.RadarPos = nil

local beep_success = Sound("buttons/blip2.wav")
local beep_match = Sound("buttons/blip1.wav")
local beep_miss = Sound("player/suit_denydevice.wav")
local dna_screen_background = Material("models/ttt2_dna_scanner/screen/background")
local dna_screen_success = Material("models/ttt2_dna_scanner/screen/check")
local dna_screen_fail = Material("models/ttt2_dna_scanner/screen/fail")
local dna_screen_arrow = Material("models/ttt2_dna_scanner/screen/arrow")
local dna_screen_circle = Material("models/ttt2_dna_scanner/screen/circle")

function SWEP:Initialize()
	if CLIENT then
		self:AddHUDHelp("dna_help_primary", "dna_help_secondary", true)

		-- Create render target
		self.scannerScreenTex = GetRenderTarget( "scanner_screen_tex", 512, 512 )

		self.scannerScreenMat = CreateMaterial( "scanner_screen_mat", "UnlitGeneric", {
					["$basetexture"] = self.scannerScreenTex,
					["$basetexturetransform"] = "center .5 .5 scale 1 1 rotate 180 translate 0 0"} )
		self.scannerScreenMat:SetTexture( "$basetexture", self.scannerScreenTex )

		self:SetSubMaterial(0, "!scanner_screen_mat")

		surface.CreateAdvancedFont("DNAScannerDistanceFont", {font = "Trebuchet24", size = 32, weight = 1200})
	end

	return self.BaseClass.Initialize(self)
end

function SWEP:PrimaryAttack()
	self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)

	self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)

	local owner = self:GetOwner()

	-- will be tracing against players
	owner:LagCompensation(true)

	local spos = owner:GetShootPos()
	local sdest = spos + owner:GetAimVector() * self.Range

	local tr = util.TraceLine({
		start = spos,
		endpos = sdest,
		filter = owner,
		mask = MASK_SHOT
	})

	local ent = tr.Entity

	owner:LagCompensation(false)

	if SERVER then
		self:GatherDNA(ent)
	end
end

function SWEP:SecondaryAttack()
	if not IsFirstTimePredicted() then return end

	self:SetNextSecondaryFire(CurTime() + self.Secondary.Delay)

	self.ActiveSample = (self.ActiveSample % GetGlobalBool("ttt2_dna_scanner_slots")) + 1

	if CLIENT then
		self:RadarScan()
	end
end

function SWEP:Reload()
	if not IsFirstTimePredicted() then return end

	self:RemoveSample()
end

function SWEP:Report(successful, msg, oldFound)
	if msg then
		LANG.Msg(self:GetOwner(), msg, nil, MSG_MSTACK_ROLE)
	end

	net.Start("TTT2ScannerFeedback")
	net.WriteBool(successful)
	net.WriteBool(oldFound or false)

	if successful or oldFound then
		net.WriteUInt(self.ActiveSample, 8)
		net.WriteEntity(self.CachedTargets[self.ActiveSample])
	end

	net.Send(self:GetOwner())
end

function SWEP:GatherDNA(ent)
	if not IsValid(ent) or ent:IsPlayer() then
		self:Report(false)

		return
	end

	if ent:GetClass() == "prop_ragdoll" and ent.killer_sample then
		self:GatherRagdollSample(ent)
	elseif ent.fingerprints and #ent.fingerprints > 0 then
		self:GatherObjectSample(ent)
	else
		self:Report(false, "dna_notfound")
	end
end

function SWEP:GatherRagdollSample(ent)
	local sample = ent.killer_sample or {t = 0, killer = nil}
	local ply = sample.killer

	if not IsValid(ply) and sample.killer_sid64 then
		ply = player.GetBySteamID64(sample.killer_sid64)
	end

	if IsValid(ply) then
		if sample.t < CurTime() then
			self:Report(false, "dna_decayed")

			return
		end

		self:AddPlayerSample(ent, ply)
	elseif not ply then
		-- not valid but not nil -> disconnected?
		self:Report(false, "dna_no_killer")
	else
		self:Report(false, "dna_notfound")
	end
end

function SWEP:GatherObjectSample(ent)
	if ent:GetClass() == "ttt_c4" and ent:GetArmed() then
		self:Report(false, "dna_armed")
	else
		self:AddItemSample(ent)
	end
end

local function firstFreeIndex(tbl, max, best)
	if not tbl[best] then
		return best
	end

	for i = 1, max do
		if not tbl[i] then
			return i
		end
	end
end

function SWEP:AddPlayerSample(corpse, killer)
	if table.Count(self.ItemSamples) >= GetGlobalBool("ttt2_dna_scanner_slots") then
		self:Report(false, "dna_limit")

		return
	end

	local owner = self:GetOwner()

	if table.HasValue(self.ItemSamples, killer) then
		self.ActiveSample = table.KeyFromValue(self.ItemSamples, killer)
		self:Report(false, "dna_duplicate", true)
	else
		local index = firstFreeIndex(self.ItemSamples, GetGlobalBool("ttt2_dna_scanner_slots"), self.ActiveSample)

		self.ActiveSample = index
		self.ItemSamples[index] = killer
		self.CachedTargets[index] = self:GetScanTarget(killer)

		DamageLog("SAMPLE:\t " .. owner:Nick() .. " retrieved DNA of " .. (IsValid(killer) and killer:Nick() or "<disconnected>") .. " from corpse of " .. (IsValid(corpse) and CORPSE.GetPlayerNick(corpse) or "<invalid>"))

		hook.Call("TTTFoundDNA", GAMEMODE, owner, killer, corpse)

		self:Report(true, "dna_killer")
	end
end

function SWEP:AddItemSample(ent)
	if table.Count(self.ItemSamples) >= GetGlobalBool("ttt2_dna_scanner_slots") then
		self:Report(false, "dna_limit")
		return
	end

	local owner = self:GetOwner()

	for i = #ent.fingerprints, 1 do
		local ply = ent.fingerprints[i]

		if ply == self:GetOwner() then continue end

		if table.HasValue(self.ItemSamples, ply) then
			self.ActiveSample  = table.KeyFromValue(self.ItemSamples, ply)

			self:Report(false, "dna_duplicate", true)

			return
		else
			local index = firstFreeIndex(self.ItemSamples, GetGlobalBool("ttt2_dna_scanner_slots"), self.ActiveSample)

			self.ActiveSample = index
			self.ItemSamples[index] = ply
			self.CachedTargets[index] = self:GetScanTarget(ply)

			DamageLog("SAMPLE:\t " .. owner:Nick() .. " retrieved DNA of " .. (IsValid(p) and p:Nick() or "<disconnected>") .. " from " .. ent:GetClass())

			hook.Run("TTTFoundDNA", owner, p, ent)

			self:Report(true, "dna_object")

			return
		end
	end

	self:Report(false, "dna_notfound")
end

function SWEP:RemoveSample()
	local idx = self.ActiveSample

	if not self.ItemSamples[idx] then return end

	self.ItemSamples[idx] = nil

	if CLIENT then
		self:RadarScan()

		return
	else
		self.CachedTargets[idx] = nil
	end
end

function SWEP:PassiveThink()
	if not IsValid(self:GetOwner()) then return end

	if SERVER then
		self:UpdateTargets()

		return
	end

	if GetGlobalBool("ttt2_dna_radar") and self.LastRadar + GetGlobalFloat("ttt2_dna_radar_cooldown") < CurTime() then
		local target = self.ItemSamples[self.ActiveSample]

		if not IsValid(target) then return end

		self.RadarPos = target:LocalToWorld(target:OBBCenter())
		self.LastRadar = CurTime()

		self:RadarScan()
	end
end

if SERVER then
	function SWEP:GetScanTarget(ply)
		if not IsValid(ply) then return end

		-- decoys always take priority, even after death
		if IsValid(ply.decoy) then
			ply = ply.decoy
		elseif not ply:IsTerror() then
			-- fall back to ragdoll, as long as it's not destroyed
			ply = ply.server_ragdoll

			if not IsValid(ply) then return end
		end

		return ply
	end

	function SWEP:UpdateTargets()
		for i = 1, GetGlobalBool("ttt2_dna_scanner_slots") do
			local ply = self.ItemSamples[i]

			if not IsValid(ply) then continue end

			local target = self:GetScanTarget(ply)

			if target ~= self.CachedTargets[i] then
				self.CachedTargets[i] = target

				net.Start("TTT2ScannerUpdate")
				net.WriteUInt(i, 8)
				net.WriteEntity(target)
				net.Send(self:GetOwner())
			end
		end
	end
else
	local TryT = LANG.TryTranslation
	local screen_bgcolor = Color(220, 220, 220, 255)
	local screen_fontcolor = Color(144, 210, 235, 255)

	local function DrawTexturedRectRotatedPoint( x, y, w, h, rot, x0, y0 )
		local c = math.cos( math.rad( rot ) )
		local s = math.sin( math.rad( rot ) )

		local newx = y0 * s - x0 * c
		local newy = y0 * c + x0 * s

		surface.DrawTexturedRectRotated( x + newx, y + newy, w, h, rot )
	end

	function SWEP:FillScannerScreen()
		local showFeedback = CurTime() > self.ScanTime + 0.5
		local target = self.ItemSamples[self.ActiveSample]

		-- Draw to the render target
		render.PushRenderTarget( self.scannerScreenTex )
		render.Clear(screen_bgcolor.r, screen_bgcolor.g, screen_bgcolor.b, screen_bgcolor.a, true, true)

		cam.Start2D()

		--draw background
		draw.FilteredTexture(0, 0, 512, 512, dna_screen_background, 255, COLOR_WHITE)

		--draw current slot
		local identifier = string.char(64 + self.ActiveSample)

		draw.AdvancedText(identifier, "DNAScannerDistanceFont", 65, 64, screen_fontcolor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER , false, 1.75)

		if showFeedback then
			if IsValid(target) and IsValid(self:GetOwner()) then
				local targetPos = GetGlobalBool("ttt2_dna_radar") and self.RadarPos or target:LocalToWorld(target:OBBCenter())
				local scannerPos = self.Owner:GetPos()
				local vectorToPos = targetPos - scannerPos
				local angleToPos = vectorToPos:Angle()
				local arrowRotation = angleToPos.yaw - EyeAngles().yaw
				local distance = math.max(LocalPlayer():GetPos():Distance(targetPos) - 47, 0)

				surface.SetDrawColor( 96, 255, 96 , 255)
				surface.SetMaterial( dna_screen_arrow )
				DrawTexturedRectRotatedPoint( 256, 256, 120, 120, arrowRotation, 0, -130 )

				draw.AdvancedText(math.Round(distance), "DNAScannerDistanceFont", 256, 256, screen_fontcolor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER , false, 2.25)

				draw.FilteredTexture(146, 146, 220, 220, dna_screen_circle, 255, screen_fontcolor)
			else
				draw.AdvancedText(TryT("dna_screen_ready"), "DNAScannerDistanceFont", 256, 256, screen_fontcolor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER , false, 2.5)
			end
		else
			if self.ScanSuccess == 1 then
				draw.FilteredTexture(192, 192, 128, 128, dna_screen_success, 255, screen_fontcolor)
			elseif self.ScanSuccess == 2 then
				draw.AdvancedText(TryT("dna_screen_match"), "DNAScannerDistanceFont", 256, 256, screen_fontcolor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER , false, 2.5)
			else
				draw.FilteredTexture(192, 192, 128, 128, dna_screen_fail, 255, screen_fontcolor)
			end
		end

		cam.End2D()

		render.PopRenderTarget()
	end

	function SWEP:PreDrawViewModel()
		self:FillScannerScreen()
		self.Owner:GetViewModel():SetSubMaterial(0, "!scanner_screen_mat")
	end

	function SWEP:PostDrawViewModel()
		self.Owner:GetViewModel():SetSubMaterial(0, nil)
	end

	function SWEP:DrawWorldModel()
		self:FillScannerScreen()
		self:DrawModel()
	end

	function SWEP:RadarScan()
		local target = self.ItemSamples[self.ActiveSample]

		if not IsValid(target) or not GetGlobalBool("ttt2_dna_radar") then
			RADAR.samples = {}
			RADAR.samples_count = 0
			self.RadarPos = nil

			return
		end

		self.RadarPos = target:LocalToWorld(target:OBBCenter())
		RADAR.samples = {{pos = self.RadarPos}}
		RADAR.samples_count = 1
	end

	local function ScannerFeedback()
		if not LocalPlayer():HasWeapon("weapon_ttt_wtester") then return end

		local scanner = LocalPlayer():GetWeapon("weapon_ttt_wtester")

		local successful = net.ReadBool()
		local oldFound = net.ReadBool()

		if successful or oldFound then
			scanner.ActiveSample = net.ReadUInt(8)
			scanner.ItemSamples[scanner.ActiveSample] = net.ReadEntity()
			scanner.NewSample = scanner.ActiveSample

			scanner:RadarScan()
		end

		scanner.ScanTime = CurTime()

		if successful then
			scanner:EmitSound(beep_success)
			scanner.ScanSuccess = 1
		elseif oldFound then
			scanner:EmitSound(beep_match)
			scanner.ScanSuccess = 2
		else
			scanner:EmitSound(beep_miss)
			scanner.ScanSuccess = 0
		end
	end
	net.Receive("TTT2ScannerFeedback", ScannerFeedback)

	local function ScannerUpdate()
		local client = LocalPlayer()

		if not client:HasWeapon("weapon_ttt_wtester") then return end

		local scanner = client:GetWeapon("weapon_ttt_wtester")
		local idx  = net.ReadUInt(8)

		scanner.ItemSamples[idx] = net.ReadEntity()
	end
	net.Receive("TTT2ScannerUpdate", ScannerUpdate)
end
