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
SWEP.ScanSuccess = 0
SWEP.ScanTime = CurTime()
SWEP.ActiveSample = 1

SWEP.MAX_ITEM = 4

SWEP.CHARGE_DELAY = 0.1
SWEP.CHARGE_RATE = 300
SWEP.MAX_CHARGE = 1250

local beep_success = Sound("buttons/blip2.wav")
local beep_match = Sound("buttons/blip1.wav")
local beep_miss = Sound("player/suit_denydevice.wav")
local dna_icon = Material("vgui/ttt/icon_wtester")
local dna_screen_success = Material("models/ttt2_dna_scanner/Check.png")
local dna_screen_fail = Material("models/ttt2_dna_scanner/Fail.png")
local dna_screen_arrow = Material("models/ttt2_dna_scanner/Arrow.png")
local dna_screen_circle = Material("models/ttt2_dna_scanner/Circle.png")

AccessorFuncDT(SWEP, "charge", "Charge")

if SERVER then
	util.AddNetworkString("TTT2ScanFeedback")
end

SWEP.NextCharge = 0

function SWEP:SetupDataTables()
	self:DTVar("Int", 0, "charge")

	return self.BaseClass.SetupDataTables(self)
end

function SWEP:Initialize()
	--debug stuff
	
	-- plys = player.GetAll()
	-- for i = 1, #plys do
	-- 	local ply = plys[i]
	-- 	if SERVER then
	-- 		self.ItemSamples[i] = ply
	-- 	else
	-- 		self.ItemSamples[i] = true
	-- 	end	
	-- end
	
	self:SetCharge(self.MAX_CHARGE)

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

	self.ActiveSample = (self.ActiveSample % self.MAX_ITEM) + 1
end

function SWEP:Reload()
	if not IsFirstTimePredicted() then return end

	self:RemoveItemSample(self.ActiveSample)
end

function SWEP:Report(successful, msg, params, oldFound)	
	if msg then
		LANG.Msg(self:GetOwner(), msg, params, MSG_MSTACK_ROLE)
	end
	
	net.Start("TTT2ScanFeedback")
	net.WriteBool(successful)
	net.WriteBool(oldFound or false)
	net.WriteUInt(self.ActiveSample, 8)
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
	if table.Count(self.ItemSamples) >= self.MAX_ITEM then
		self:Report(false, "dna_limit")
		return
	end

	local owner = self:GetOwner()

	if table.HasValue(self.ItemSamples, killer) then
		local foundIndex =  table.KeyFromValue(self.ItemSamples, killer)
		self:Report(false, "dna_duplicate", nil, true)
		self.ActiveSample = foundIndex
	else
		local index = firstFreeIndex(self.ItemSamples, self.MAX_ITEM, self.ActiveSample)
		self.ActiveSample = index
		self.ItemSamples[index] = killer

		DamageLog("SAMPLE:\t " .. owner:Nick() .. " retrieved DNA of " .. (IsValid(killer) and killer:Nick() or "<disconnected>") .. " from corpse of " .. (IsValid(corpse) and CORPSE.GetPlayerNick(corpse) or "<invalid>"))

		hook.Call("TTTFoundDNA", GAMEMODE, owner, killer, corpse)
		self:Report(true, "dna_killer")
	end

	if self:GetCharge() == self.MAX_CHARGE then
		self:PerformScan(self.ActiveSample)
	end
end

function SWEP:AddItemSample(ent)
	if table.Count(self.ItemSamples) >= self.MAX_ITEM then
		self:Report(false, "dna_limit")
		return
	end

	local owner = self:GetOwner()

	local limitExceeded = false
	for i = #ent.fingerprints, 1 do
		local ply = ent.fingerprints[i]

		if ply == 1 then
			--skip your own prints
		elseif table.HasValue(self.ItemSamples, ply) then
			self.ActiveSample  = table.KeyFromValue(self.ItemSamples, ply)

			self:Report(false, "dna_object_old", nil, true)
			return
		else
			local index = firstFreeIndex(self.ItemSamples, self.MAX_ITEM, self.ActiveSample)
			self.ActiveSample = index
			self.ItemSamples[index] = ply

			DamageLog("SAMPLE:\t " .. owner:Nick() .. " retrieved DNA of " .. (IsValid(p) and p:Nick() or "<disconnected>") .. " from " .. ent:GetClass())

			hook.Run("TTTFoundDNA", owner, p, ent)
			self:Report(true, "dna_object", {num = new})
			return
		end
	end

	self:Report(0, "dna_notfound")
end

function SWEP:RemoveItemSample(idx)
	if not self.ItemSamples[idx] then return end

	self.ItemSamples[idx] = nil

	if CLIENT then return end

	if self.ActiveSample == idx then
		self:ClearScanState()
	end
end

if SERVER then
	function SWEP:SendScan(pos)
		local owner = self:GetOwner()
		local clear = not pos or not IsValid(owner)

		net.Start("TTT_ScanResult", owner)
		net.WriteBit(clear)

		if not clear then
			net.WriteVector(pos)
		end

		net.Send(owner)
	end

	function SWEP:ClearScanState()
		self:SendScan(nil)
	end

	local function GetScanTarget(ply)
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

	function SWEP:PerformScan(idx, repeated)
		if self:GetCharge() < self.MAX_CHARGE then return end

		local owner = self:GetOwner()
		local ply = self.ItemSamples[idx]

		if not ply or not IsValid(owner) then
			if repeated then
				self:ClearScanState()
			end

			return
		end

		local target = GetScanTarget(ply)

		if not IsValid(target) then
			LANG.Msg(self:GetOwner(), "dna_gone", nil, MSG_MSTACK_ROLE)
			self:SetCharge(self:GetCharge() - 50)

			if repeated then
				self:ClearScanState()
			end

			return
		end

		local pos = target:LocalToWorld(target:OBBCenter())

		self:SendScan(pos)

		local dist = math.ceil(owner:GetPos():Distance(pos))

		self:SetCharge(math.max(0, self:GetCharge() - math.max(50, dist * 0.5)))
	end

	function SWEP:PassiveThink()
		if self:GetCharge() < self.MAX_CHARGE and self.NextCharge < CurTime() then
			self:SetCharge(math.min(self.MAX_CHARGE, self:GetCharge() + self.CHARGE_RATE))

			self.NextCharge = CurTime() + self.CHARGE_DELAY
		elseif IsValid(self:GetOwner()) then
			self:PerformScan(self.ActiveSample, true)
		end
	end
end

-- Helper to get at a player's scanner, if he has one
local function GetTester(ply)
	if not IsValid(ply) then return end

	local tester = ply:GetActiveWeapon()

	if IsValid(tester) and tester:GetClass() == "weapon_ttt_wtester" then
		return tester
	end
end


if CLIENT then
	local T = LANG.GetTranslation
	local PT = LANG.GetParamTranslation
	local TT = LANG.TryTranslation
	local mathfloor = math.floor

	-- target ID function
	hook.Add("TTTRenderEntityInfo", "TTT2DNAScannerInfo", function(tData)
		local client = LocalPlayer()
		local ent = tData:GetEntity()
		
		if not IsValid(client:GetActiveWeapon()) or client:GetActiveWeapon():GetClass() ~= "weapon_ttt_wtester" or tData:GetEntityDistance() > 400 or not IsValid(ent) then return end

		local weapon = client:GetActiveWeapon()
		local distance = tData:GetEntityDistance()
		
		-- add an empty line if there's already data in the description area
		if tData:GetAmountDescriptionLines() > 0 then
			tData:AddDescriptionLine()
		end
		
		if ent:IsWeapon() or ent.CanHavePrints or ent:GetNWBool("HasPrints", false)
		or ent:GetClass() == "prop_ragdoll" and CORPSE.GetPlayerNick(ent, false)
		then
			tData:AddDescriptionLine("Scan possible", COLOR_GREEN, {dna_icon})
		else
			tData:AddDescriptionLine("No scan possible", COLOR_RED, {dna_icon})
		end
	end)

	local function RecvScan()
		local clear = net.ReadBit() == 1

		if clear then
			RADAR.samples = {}
			RADAR.samples_count = 0

			return
		end

		local target_pos = net.ReadVector()

		if not target_pos then return end

		RADAR.samples = {{pos = target_pos}}
		RADAR.samples_count = 1
	end
	net.Receive("TTT_ScanResult", RecvScan)

	local function ScanFeedback()
		if not LocalPlayer():HasWeapon("weapon_ttt_wtester") then return end
		
		local scanner = LocalPlayer():GetWeapon("weapon_ttt_wtester")

		local successful = net.ReadBool()
		local oldFound = net.ReadBool()
		
		if successful or oldFound then
			scanner.ActiveSample = net.ReadUInt(8)
		end
		scanner.ScanTime = CurTime()

		if successful then
			scanner.ItemSamples[scanner.ActiveSample] = true
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
	net.Receive("TTT2ScanFeedback", ScanFeedback)
	
	local function DrawTexturedRectRotatedPoint( x, y, w, h, rot, x0, y0 )
	
		local c = math.cos( math.rad( rot ) )
		local s = math.sin( math.rad( rot ) )
		
		local newx = y0 * s - x0 * c
		local newy = y0 * c + x0 * s
		
		surface.DrawTexturedRectRotated( x + newx, y + newy, w, h, rot )
		
	end

	function SWEP:FillScannerScreen()
		-- Draw to the render target
		render.PushRenderTarget( self.scannerScreenTex )
		render.Clear(220, 220, 220, 255, true, true)
		cam.Start2D()
		
		local showFeedback = CurTime() > self.ScanTime + 0.5
		
		if showFeedback then
			if RADAR.samples_count > 0  then
				local targetPos = RADAR.samples[1].pos
				local scannerPos = self:GetPos()
				local vectorToPos = targetPos - scannerPos
				local angleToPos = vectorToPos:Angle()
				local arrowRotation = angleToPos.yaw - EyeAngles().yaw

				local distance = LocalPlayer():GetPos():Distance(targetPos)
				surface.SetDrawColor( 236, 174, 23, 255 )
				surface.SetMaterial( dna_screen_arrow )
				DrawTexturedRectRotatedPoint( 256, 256, 190, 190, arrowRotation, 0, -170 )
				draw.AdvancedText( math.Round(distance), "DNAScannerDistanceFont", 256, 256, Color(50, 50, 50), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER , false, 3)

				surface.SetDrawColor( 50, 50, 50, 255 )
				surface.SetMaterial( dna_screen_circle )
				surface.DrawTexturedRect( 116, 116, 276, 276 )	
			else
				draw.AdvancedText( "Ready", "DNAScannerDistanceFont", 256, 256, Color(50, 50, 50), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER , false, 3)
			end
		else
			if self.ScanSuccess == 1 then
				surface.SetDrawColor( 50, 50, 50, 255 )
				surface.SetMaterial( dna_screen_success )
				surface.DrawTexturedRect( 192, 192, 128, 128 )
			elseif self.ScanSuccess == 2 then
				draw.AdvancedText( "Match", "DNAScannerDistanceFont", 256, 256, Color(50, 50, 50), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER , false, 3)
			else
				surface.SetDrawColor( 50, 50, 50, 255 )
				surface.SetMaterial( dna_screen_fail )
				surface.DrawTexturedRect( 192, 192, 128, 128 )	
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

else -- SERVER

	hook.Add("Tick", "TTT2DNAScannerThink", function()
		if CLIENT then return end
		
		plys = player.GetAll()

		for i = 1, #plys do
			-- Run DNA Scanner think also when it is not deployed
			local ply = plys[i]
			if IsValid(ply) and ply:HasWeapon("weapon_ttt_wtester") then
				ply:GetWeapon("weapon_ttt_wtester"):PassiveThink()
			end
		end
	end)
end