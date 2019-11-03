if SERVER then
	AddCSLuaFile()
end

local math = math
local table = table

DEFINE_BASECLASS "weapon_tttbase"

SWEP.HoldType = "normal"

if CLIENT then
	SWEP.PrintName = "dna_name"
	SWEP.Slot = 8

	SWEP.ViewModelFOV = 10
	SWEP.DrawCrosshair = false

	SWEP.EquipMenuData = {
		type = "item_weapon",
		desc = "dna_desc"
	}

	SWEP.Icon = "vgui/ttt/icon_wtester"
end

SWEP.Base = "weapon_tttbase"

SWEP.ViewModel = "models/weapons/v_crowbar.mdl"
SWEP.WorldModel = "models/props_lab/huladoll.mdl"

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false
SWEP.Primary.Delay = 1
SWEP.Primary.Ammo = "none"

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"
SWEP.Secondary.Delay = 2

SWEP.Kind = WEAPON_ROLE
SWEP.CanBuy = nil -- no longer a buyable thing
SWEP.WeaponID = AMMO_WTESTER
SWEP.InLoadoutFor = {ROLE_DETECTIVE}
SWEP.AutoSpawnable = false
SWEP.NoSights = true
SWEP.Range = 175
SWEP.ItemSamples = {}
SWEP.NowRepeating = nil

local MAX_ITEM = 30
SWEP.MaxItemSamples = MAX_ITEM

local CHARGE_DELAY = 0.1
local CHARGE_RATE = 3
local MAX_CHARGE = 1250

local SAMPLE_PLAYER = 1
local SAMPLE_ITEM   = 2

AccessorFuncDT(SWEP, "charge", "Charge")
AccessorFuncDT(SWEP, "last_scanned", "LastScanned")

if CLIENT then
	CreateClientConVar("ttt_dna_scan_repeat", 1, true, true)
else
	function SWEP:GetRepeating()
		local ply = self:GetOwner()

		return IsValid(ply) and ply:GetInfoNum("ttt_dna_scan_repeat", 1) == 1
	end
end

SWEP.NextCharge = 0

function SWEP:SetupDataTables()
	self:DTVar("Int", 0, "charge")
	self:DTVar("Int", 1, "last_scanned")

	return self.BaseClass.SetupDataTables(self)
end

function SWEP:Initialize()
	self:SetCharge(MAX_CHARGE)
	self:SetLastScanned(-1)

	if CLIENT then
		self:AddHUDHelp("dna_help_primary", "dna_help_secondary", true)
	end

	return self.BaseClass.Initialize(self)
end

local beep_miss = Sound("player/suit_denydevice.wav")

function SWEP:PrimaryAttack()
	self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)

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

	if not IsValid(ent) or ent:IsPlayer() then
		if CLIENT then
			owner:EmitSound(beep_miss)
		end

		return
	end

	if CLIENT then return end

	if ent:GetClass() == "prop_ragdoll" and ent.killer_sample then
		if CORPSE.GetFound(ent, false) then
			self:GatherRagdollSample(ent)
		else
			self:Report("dna_identify")
		end
	elseif ent.fingerprints and #ent.fingerprints > 0 then
		self:GatherObjectSample(ent)
	else
		self:Report("dna_notfound")
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
			self:Report("dna_decayed")

			return
		end

		local added = self:AddPlayerSample(ent, ply)

		if not added then
			self:Report("dna_limit")
		else
			self:Report("dna_killer")

			if self:GetRepeating() and self:GetCharge() == MAX_CHARGE then
				self:PerformScan(#self.ItemSamples)
			end
		end
	elseif not ply then
		-- not valid but not nil -> disconnected?
		self:Report("dna_no_killer")
	else
		self:Report("dna_notfound")
	end
end

function SWEP:GatherObjectSample(ent)
	if ent:GetClass() == "ttt_c4" and ent:GetArmed() then
		self:Report("dna_armed")
	else
		local collected, _, _ = self:AddItemSample(ent)

		if collected == -1 then
			self:Report("dna_limit")
		else
			self:Report("dna_object", {num = collected})
		end
	end
end

function SWEP:Report(msg, params)
	LANG.Msg(self:GetOwner(), msg, params)
end

function SWEP:AddPlayerSample(corpse, killer)
	if #self.ItemSamples >= self.MaxItemSamples then
		return false
	end

	local owner = self:GetOwner()

	local prnt = {
		source = corpse,
		ply = killer,
		type = SAMPLE_PLAYER,
		cls = killer:GetClass()
	}

	if not table.HasTable(self.ItemSamples, prnt) then
		self.ItemSamples[#self.ItemSamples + 1] = prnt

		DamageLog("SAMPLE:\t " .. owner:Nick() .. " retrieved DNA of " .. (IsValid(killer) and killer:Nick() or "<disconnected>") .. " from corpse of " .. (IsValid(corpse) and CORPSE.GetPlayerNick(corpse) or "<invalid>"))

		hook.Call("TTTFoundDNA", GAMEMODE, owner, killer, corpse)
	end

	return true
end

function SWEP:AddItemSample(ent)
	if #self.ItemSamples >= self.MaxItemSamples then
		return -1
	end

	table.Shuffle(ent.fingerprints)

	local new = 0
	local old = 0
	local own = 0

	local owner = self:GetOwner()

	for i = 1, #ent.fingerprints do
		local p = ent.fingerprints[i]

		local prnt = {
			source = ent,
			ply = p,
			type = SAMPLE_ITEM,
			cls = ent:GetClass()
		}

		if p == owner then
			own = own + 1
		elseif table.HasTable(self.ItemSamples, prnt) then
			old = old + 1
		else
			self.ItemSamples[#self.ItemSamples + 1] = prnt

			DamageLog("SAMPLE:\t " .. owner:Nick() .. " retrieved DNA of " .. (IsValid(p) and p:Nick() or "<disconnected>") .. " from " .. ent:GetClass())

			new = new + 1

			hook.Run("TTTFoundDNA", owner, p, ent)
		end
	end

	return new, old, own
end

function SWEP:RemoveItemSample(idx)
	if not self.ItemSamples[idx] then return end

	if self:GetLastScanned() == idx then
		self:ClearScanState()
	end

	table.remove(self.ItemSamples, idx)

	self:SendPrints(false)
end

function SWEP:SecondaryAttack()
	self:SetNextSecondaryFire(CurTime() + 0.05)

	if CLIENT then return end

	self:SendPrints(true)
end

if SERVER then
	-- Sending this all in one umsg limits the max number of samples. 17 player
	-- samples and 20 item samples (with 20 matches) has been verified as
	-- working in the old DNA sampler.
	function SWEP:SendPrints(should_open)
		local owner = self:GetOwner()
		local ItemSamples = self.ItemSamples
		local num_ItemSamples = #ItemSamples

		net.Start("TTT_ShowPrints", owner)
		net.WriteBit(should_open)
		net.WriteUInt(num_ItemSamples, 8)

		for i = 1, num_ItemSamples do
			net.WriteString(ItemSamples[i].cls)
		end

		net.Send(owner)
	end

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
		self.NowRepeating = nil

		self:SetLastScanned(-1)
		self:SendScan(nil)
	end

	local function GetScanTarget(sample)
		if not sample then return end

		local target = sample.ply

		if not IsValid(target) then return end

		-- decoys always take priority, even after death
		if IsValid(target.decoy) then
			target = target.decoy
		elseif not target:IsTerror() then
			-- fall back to ragdoll, as long as it's not destroyed
			target = target.server_ragdoll

			if not IsValid(target) then return end
		end

		return target
	end

	function SWEP:PerformScan(idx, repeated)
		if self:GetCharge() < MAX_CHARGE then return end

		local owner = self:GetOwner()
		local sample = self.ItemSamples[idx]

		if not sample or not IsValid(owner) then
			if repeated then
				self:ClearScanState()
			end

			return
		end

		local target = GetScanTarget(sample)

		if not IsValid(target) then
			self:Report("dna_gone")
			self:SetCharge(self:GetCharge() - 50)

			if repeated then
				self:ClearScanState()
			end

			return
		end

		local pos = target:LocalToWorld(target:OBBCenter())

		self:SendScan(pos)
		self:SetLastScanned(idx)

		self.NowRepeating = self:GetRepeating()

		local dist = math.ceil(owner:GetPos():Distance(pos))

		self:SetCharge(math.max(0, self:GetCharge() - math.max(50, dist * 0.5)))
	end

	function SWEP:Think()
		if self:GetCharge() < MAX_CHARGE and self.NextCharge < CurTime() then
			self:SetCharge(math.min(MAX_CHARGE, self:GetCharge() + CHARGE_RATE))

			self.NextCharge = CurTime() + CHARGE_DELAY
		elseif self.NowRepeating and IsValid(self:GetOwner()) then
			-- owner changed his mind since running last scan?
			if self:GetRepeating() then
				self:PerformScan(self:GetLastScanned(), true)
			else
				self.NowRepeating = self:GetRepeating()
			end
		end

		return true
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

	local cv_thickness

	hook.Add("Initialize", "LocalizeConVarWtester", function()
		cv_thickness = GetConVar("ttt_crosshair_thickness")
	end)

	function SWEP:DrawHUD()
		self:DrawHelp()

		local owner = self:GetOwner()
		local spos = owner:GetShootPos()
		local sdest = spos + owner:GetAimVector() * self.Range

		local tr = util.TraceLine({
			start = spos,
			endpos = sdest,
			filter = owner,
			mask = MASK_SHOT
		})

		local ent = tr.Entity

		local length = 20
		local gap = 6
		local thickness = mathfloor(cv_thickness and cv_thickness:GetFloat() or 1)
		local offset = thickness * 0.5

		local can_sample = false

		if IsValid(ent) then
			-- weapon or dropped equipment OR knife in corpse, or a ragdoll
			if ent:IsWeapon() or ent.CanHavePrints or ent:GetNWBool("HasPrints", false)
			or ent:GetClass() == "prop_ragdoll" and CORPSE.GetPlayerNick(ent, false) and CORPSE.GetFound(ent, false)
			then
				surface.SetDrawColor(0, 255, 0, 255)
				gap = 0
				can_sample = true
			else
				surface.SetDrawColor(255, 0, 0, 200)
				gap = 0
			end
		else
			surface.SetDrawColor(255, 255, 255, 200)
		end

		local x = ScrW() * 0.5
		local y = ScrH() * 0.5

		surface.DrawRect(x - length, y - offset, length - gap, thickness)
		surface.DrawRect(x + gap, y - offset, length - gap, thickness)
		surface.DrawRect(x - offset, y - length, thickness, length - gap)
		surface.DrawRect(x - offset, y + gap, thickness, length - gap)

		if ent and can_sample then
			surface.SetFont("DefaultFixedDropShadow")
			surface.SetTextColor(0, 255, 0, 255)

			surface.SetTextPos(x + length * 2, y - length * 2)
			surface.DrawText(T("dna_hud_type") .. ": " .. (ent:GetClass() == "prop_ragdoll" and T("dna_hud_body") or T("dna_hud_item")))

			surface.SetTextPos(x + length * 2, y - length * 2 + 15)
			surface.DrawText("ID:   #" .. ent:EntIndex())
		end
	end

	local basedir = "vgui/ttt/icon_"

	local function GetDisplayData(cls)
		local wep = util.WeaponForClass(cls)

		local img = basedir .. "nades"
		local name = "something"

		if cls == "player" then
			img  = basedir .. "corpse"
			name = "corpse"
		elseif wep then
			img  = wep.Icon      or img
			name = wep.PrintName or name
		end

		return img, name
	end

	local last_panel_selected = 1

	local function ShowPrintsPopup(item_prints, tester)
		local m = 10
		local bw, bh = 100, 25

		local dpanel = vgui.Create("DFrame")
		local w, h = 400, 250
		dpanel:SetSize(w, h)

		dpanel:AlignRight(5)
		dpanel:AlignBottom(5)

		dpanel:SetTitle(T("dna_menu_title"))
		dpanel:SetVisible(true)
		dpanel:ShowCloseButton(true)
		dpanel:SetMouseInputEnabled(true)

		local wrap = vgui.Create("DPanel", dpanel)
		wrap:StretchToParent(m * 0.5, m + 15, m * 0.5, m + bh)
		wrap:SetPaintBackground(false)

		-- item sample listing
		local ilist = vgui.Create("DPanelSelect", wrap)
		ilist:StretchToParent(0,0,0,0)
		ilist:EnableHorizontal(true)
		ilist:SetSpacing(1)
		ilist:SetPadding(1)

		ilist.OnActivePanelChanged = function(s, old, new)
			last_panel_selected = new and new.key or 1
		end

		ilist.OnScan = function(s, scanned_pnl)
			for k, pnl in pairs(s:GetItems()) do
				pnl:SetIconColor(COLOR_LGRAY)
			end

			scanned_pnl:SetIconColor(COLOR_WHITE)
		end

		if ilist.VBar then
			ilist.VBar:Remove()
			ilist.VBar = nil
		end

		local iscroll = vgui.Create("DHorizontalScroller", ilist)

		iscroll:SetPos(3,1)
		iscroll:SetSize(363, 66)
		iscroll:SetOverlap(1)

		iscroll.LoadFrom = function(s, tbl, layout)
			ilist:Clear(true)
			ilist.SelectedPanel = nil

			-- Scroller has no Clear()
			for k, pnl in pairs(s.Panels) do
				if IsValid(pnl) then
					pnl:Remove()
				end
			end

			s.Panels = {}

			local last_scan = tester and tester:GetLastScanned() or -1

			for i = 1, #tbl do
				local ic = vgui.Create("SimpleIcon", ilist)

				ic:SetIconSize(64)

				local img, name = GetDisplayData(v)

				ic:SetIcon(img)

				local tip = PT("dna_menu_sample", {source = TT(name) or "???"})

				ic:SetTooltip(tip)

				ic.key = i
				ic.val = tbl[i]

				if layout then
					ic:PerformLayout()
				end

				ilist:AddPanel(ic)
				s:AddPanel(ic)

				if i == last_panel_selected then
					ilist:SelectPanel(ic)
				end

				if last_scan > 0 then
					ic:SetIconColor(last_scan == i and COLOR_WHITE or COLOR_LGRAY)
				end
			end

			iscroll:InvalidateLayout()
		end

		iscroll:LoadFrom(item_prints)

		local delwrap = vgui.Create("DPanel", wrap)
		delwrap:SetPos(m, 70)
		delwrap:SetSize(370, bh)
		delwrap:SetPaintBackground(false)

		local delitem = vgui.Create("DButton", delwrap)
		delitem:SetPos(0,0)
		delitem:SetSize(bw, bh)
		delitem:SetText(T("dna_menu_remove"))

		delitem.DoClick = function()
			if not IsValid(ilist) or not IsValid(ilist.SelectedPanel) then return end

			RunConsoleCommand("ttt_wtester_remove", ilist.SelectedPanel.key)
		end

		delitem.Think = function(s)
			if IsValid(ilist) and IsValid(ilist.SelectedPanel) then
				s:SetEnabled(true)
			else
				s:SetEnabled(false)
			end
		end

		local delhlp = vgui.Create("DLabel", delwrap)
		delhlp:SetPos(bw + m, 0)
		delhlp:SetText(T("dna_menu_help1"))
		delhlp:SizeToContents()

		-- hammer out layouts
		wrap:PerformLayout()

		-- scroller needs to sort itself out so it displays all icons it should
		iscroll:PerformLayout()

		local mwrap = vgui.Create("DPanel", wrap)
		mwrap:SetPaintBackground(false)
		mwrap:SetPos(m,100)
		mwrap:SetSize(370, 90)

		local bar = vgui.Create("TTTProgressBar", mwrap)
		bar:SetSize(370, 35)
		bar:SetPos(0, 0)
		bar:CenterHorizontal()
		bar:SetMin(0)
		bar:SetMax(MAX_CHARGE)
		bar:SetValue(tester and math.min(MAX_CHARGE, tester:GetCharge()))
		bar:SetColor(COLOR_GREEN)
		bar:LabelAsPercentage()

		local state = vgui.Create("DLabel", bar)
		state:SetSize(0, 35)
		state:SetPos(10, 6)
		state:SetFont("Trebuchet22")
		state:SetText(T("dna_menu_ready"))
		state:SetTextColor(COLOR_WHITE)
		state:SizeToContents()

		local scan = vgui.Create("DButton", mwrap)
		scan:SetText(T("dna_menu_scan"))
		scan:SetSize(bw, bh)
		scan:SetPos(0, 40)
		scan:SetEnabled(false)

		scan.DoClick = function(s)
			if not IsValid(ilist) then return end

			local i = ilist.SelectedPanel

			if not IsValid(i) then return end

			RunConsoleCommand("ttt_wtester_scan", i.key)
			ilist:OnScan(i)
		end

		local dcheck = vgui.Create("DCheckBoxLabel", mwrap)
		dcheck:SetPos(0, 70)
		dcheck:SetText(T("dna_menu_repeat"))
		dcheck:SetIndent(7)
		dcheck:SizeToContents()
		dcheck:SetConVar("ttt_dna_scan_repeat")

		local scanhlp = vgui.Create("DLabel", mwrap)
		scanhlp:SetPos(bw + m, 40)
		scanhlp:SetText(T("dna_menu_help2"))
		scanhlp:SizeToContents()

		-- CLOSE
		local dbut = vgui.Create("DButton", dpanel)
		dbut:SetSize(bw, bh)
		dbut:SetPos(m, h - bh - m * 0.667)
		dbut:CenterHorizontal()
		dbut:SetText(T("close"))
		dbut.DoClick = function() dpanel:Close() end

		dpanel:MakePopup()
		dpanel:SetKeyboardInputEnabled(false)

		-- Expose updating fns
		dpanel.UpdatePrints = function(s, its)
			if IsValid(iscroll) then
				iscroll:LoadFrom(its)
			end
		end

		dpanel.Think = function(s)
			if not IsValid(bar) or not IsValid(scan) or not tester then return end

			local charge = tester:GetCharge()

			bar:SetValue(math.min(MAX_CHARGE, charge))

			if charge < MAX_CHARGE then
				bar:SetColor(COLOR_RED)

				state:SetText(T("dna_menu_charge"))
				state:SizeToContents()

				scan:SetEnabled(false)
			else
				bar:SetColor(COLOR_GREEN)

				if IsValid(ilist) and IsValid(ilist.SelectedPanel) then
					scan:SetEnabled(true)

					state:SetText(T("dna_menu_ready"))
					state:SizeToContents()
				else
					state:SetText(T("dna_menu_select"))
					state:SizeToContents()
					scan:SetEnabled(false)
				end
			end
		end

		return dpanel
	end

	local printspanel = nil

	local function RecvPrints()
		local should_open = net.ReadBit() == 1
		local num = net.ReadUInt(8)
		local item_prints = {}

		for i = 1, num do
			item_prints[i] = net.ReadString()
		end

		if should_open then
			if IsValid(printspanel) then
				printspanel:Remove()
			end

			printspanel = ShowPrintsPopup(item_prints, GetTester(LocalPlayer()))
		else
			if not IsValid(printspanel) then return end

			printspanel:UpdatePrints(item_prints)
		end
	end
	net.Receive("TTT_ShowPrints", RecvPrints)

	local beep_success = Sound("buttons/blip2.wav")

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

		surface.PlaySound(beep_success)
	end
	net.Receive("TTT_ScanResult", RecvScan)

	function SWEP:ClosePrintsPanel()
		if not IsValid(printspanel) then return end

		printspanel:Close()
	end

else -- SERVER
	local function ScanPrint(ply, cmd, args)
		local tester = GetTester(ply)

		if not IsValid(tester) then return end
		if #args ~= 1 then return end

		local i = tonumber(args[1])

		if not i then return end

		tester:PerformScan(i)
	end
	concommand.Add("ttt_wtester_scan", ScanPrint)

	local function RemoveSample(ply, cmd, args)
		local tester = GetTester(ply)

		if #args ~= 1 then return end

		local idx = tonumber(args[1])

		if not idx or not IsValid(tester) then return end

		tester:RemoveItemSample(idx)
	end
	concommand.Add("ttt_wtester_remove", RemoveSample)
end

function SWEP:OnRemove()
	if SERVER then return end

	self:ClosePrintsPanel()
end

function SWEP:OnDrop()

end

function SWEP:PreDrop()
	local owner = self:GetOwner()

	if not IsValid(owner) then return end

	owner.scanner_weapon = nil
end

function SWEP:Reload()
	return false
end

function SWEP:Deploy()
	local owner = self:GetOwner()

	if SERVER and IsValid(owner) then
		owner:DrawViewModel(false)
		owner.scanner_weapon = self
	end

	return true
end

if CLIENT then
	function SWEP:DrawWorldModel()
		if IsValid(self:GetOwner()) then return end

		self:DrawModel()
	end
end
