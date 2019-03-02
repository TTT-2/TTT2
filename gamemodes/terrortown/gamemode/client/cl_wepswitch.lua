-- we need our own weapon switcher because the hl2 one skips empty weapons
local table = table
local pairs = pairs
local ipairs = ipairs
local IsValid = IsValid
local CreateConVar = CreateConVar

WSWITCH = {}
WSWITCH.Show = false
WSWITCH.Selected = -1
WSWITCH.NextSwitch = -1
WSWITCH.WeaponCache = {}

WSWITCH.cv = {}
WSWITCH.cv.stay = CreateConVar("ttt_weaponswitcher_stay", "0", FCVAR_ARCHIVE)
WSWITCH.cv.fast = CreateConVar("ttt_weaponswitcher_fast", "0", FCVAR_ARCHIVE)
WSWITCH.cv.display = CreateConVar("ttt_weaponswitcher_displayfast", "0", FCVAR_ARCHIVE)

local delay = 0.03
local showtime = 3

local function InsertIfValid(dest, wep)
	if IsValid(wep) then
		table.insert(dest, wep)
	end
end

function WSWITCH:UpdateWeaponCache()
	self.WeaponCache = {}
	
	local inventory = LocalPlayer():GetInventory()
	
	for kind, convar in ipairs(ORDERED_SLOT_TABLE) do
		for k,wep in pairs(inventory[kind]) do
			InsertIfValid(self.WeaponCache, wep)
		end
	end
end

function WSWITCH:SetSelected(idx)
	self.Selected = idx

	self:UpdateWeaponCache()
end

function WSWITCH:SelectNext()
	if self.NextSwitch > CurTime() then return end

	self:Enable()

	local s = self.Selected + 1
	if s > #self.WeaponCache then
		s = 1
	end

	self:DoSelect(s)

	self.NextSwitch = CurTime() + delay
end

function WSWITCH:SelectPrev()
	if self.NextSwitch > CurTime() then return end

	self:Enable()

	local s = self.Selected - 1
	if s < 1 then
		s = #self.WeaponCache
	end

	self:DoSelect(s)

	self.NextSwitch = CurTime() + delay
end

-- Select by index
function WSWITCH:DoSelect(idx)
	self:SetSelected(idx)

	if self.cv.fast:GetBool() then
		-- immediately confirm if fastswitch is on
		self:ConfirmSelection(self.cv.display:GetBool())
	end
end

-- Numeric key access to direct slots
function WSWITCH:SelectSlot(slot)
	if not slot then return end

	self:Enable()
	self:UpdateWeaponCache()

	--slot = slot - 1

	-- find which idx in the weapon table has the slot we want
	local toselect = self.Selected

	for k, w in ipairs(self.WeaponCache) do
		if MakeKindValid(w.Kind) == slot then
			toselect = k

			break
		end
	end

	self:DoSelect(toselect)

	self.NextSwitch = CurTime() + delay
end

-- Show the weapon switcher
function WSWITCH:Enable()
	if self.Show == false then
		self.Show = true

		local wep_active = LocalPlayer():GetActiveWeapon()

		self:UpdateWeaponCache()

		-- make our active weapon the initial selection
		local toselect = 1

		for k, w in ipairs(self.WeaponCache) do
			if w == wep_active then
				toselect = k

				break
			end
		end

		self:SetSelected(toselect)
	end

	-- cache for speed, checked every Think
	self.Stay = self.cv.stay:GetBool()
end

-- Hide switcher
function WSWITCH:Disable()
	self.Show = false
end

-- Switch to the currently selected weapon
function WSWITCH:ConfirmSelection(noHide)
	if not noHide then
		self:Disable()
	end

	for k, w in ipairs(self.WeaponCache) do
		if k == self.Selected and IsValid(w) then
			input.SelectWeapon(w)

			return
		end
	end
end

-- Allow for suppression of the attack command
function WSWITCH:PreventAttack()
	return self.Show and not self.cv.fast:GetBool()
end

function WSWITCH:Think()
	if not self.Show or self.Stay then return end

	-- hide after period of inaction
	if self.NextSwitch < (CurTime() - showtime) then
		self:Disable()
	end
end

-- Instantly select a slot and switch to it, without spending time in menu
function WSWITCH:SelectAndConfirm(slot)
	if not slot then return end

	WSWITCH:SelectSlot(slot)
	WSWITCH:ConfirmSelection()
end

local function QuickSlot(ply, cmd, args)
	if not IsValid(ply) or not args or #args ~= 1 then return end

	local slot = tonumber(args)

	if not slot then return end

	local wep = ply:GetActiveWeapon()

	if IsValid(wep) then
		if MakeKindValid(wep.Kind) == slot - 1 then
			RunConsoleCommand("lastinv")
		else
			WSWITCH:SelectAndConfirm(slot)
		end
	end
end
concommand.Add("ttt_quickslot", QuickSlot)

local function SwitchToEquipment(ply, cmd, args)
	RunConsoleCommand("ttt_quickslot", "7")
end
concommand.Add("ttt_equipswitch", SwitchToEquipment)
