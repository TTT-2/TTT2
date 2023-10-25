if SERVER then
	AddCSLuaFile()

	return
end

KEYHELP_CORE = 1
KEYHELP_EXTRA = 2
KEYHELP_EQUIPMENT = 3

local Key = Key
local stringUpper = string.upper
local inputGetKeyName = input.GetKeyName
local bindFind = bind.Find

local offsetCenter = 220
local offsetHeight = 48
local width = 18
local padding = 5

local colorBox = Color(0, 0, 0, 100)

local materialSettings = Material("vgui/ttt/hudhelp/settings")
local materialMute = Material("vgui/ttt/hudhelp/mute")
local materialShoppingRole = Material("vgui/ttt/hudhelp/shopping_role")
local materialPosessing = Material("vgui/ttt/hudhelp/possessing")
local materialPlayer = Material("vgui/ttt/hudhelp/player")
local materialPlayerPrev = Material("vgui/ttt/hudhelp/player_prev")
local materialPlayerNext = Material("vgui/ttt/hudhelp/player_next")
local materialPropJump = Material("vgui/ttt/hudhelp/prop_jump")
local materialPropLeft = Material("vgui/ttt/hudhelp/prop_left")
local materialPropRight = Material("vgui/ttt/hudhelp/prop_right")
local materialPropFront = Material("vgui/ttt/hudhelp/prop_front")
local materialPropBack = Material("vgui/ttt/hudhelp/prop_back")
local materialLeaveTarget = Material("vgui/ttt/hudhelp/leave_target")

local cvEnableCore = CreateConVar("ttt2_keyhelp_show_core", "1", FCVAR_ARCHIVE)
local cvEnableExtra = CreateConVar("ttt2_keyhelp_show_extra", "0", FCVAR_ARCHIVE)
local cvEnableEquipment = CreateConVar("ttt2_keyhelp_show_equipment", "1", FCVAR_ARCHIVE)

keyhelp = keyhelp or {}
keyhelp.keyHelpers = {}

function keyhelp.RegisterKeyHelper(binding, iconMaterial, bindingType, callback)
	keyhelp.keyHelpers[#keyhelp.keyHelpers + 1] = {
		binding = binding,
		iconMaterial = iconMaterial,
		bindingType = bindingType,
		callback = callback
	}
end

function keyhelp.DrawKey(x, y, size, keyString, iconMaterial)
	local wKeyString = draw.GetTextSize(keyString, "weapon_hud_help_key")
	local wBox = math.max(size, wKeyString) + 2 * padding
	local xIcon = x + 0.5 * (wBox - size)
	local yIcon = y + padding + 2
	local xKeyString = x + math.floor(0.5 * wBox)
	local yKeyString = yIcon + size + padding

	draw.BlurredBox(x, y, wBox, offsetHeight + padding)
	draw.Box(x, y, wBox, offsetHeight + padding, colorBox) -- background color
	draw.Box(x, y, wBox, 1, colorBox) -- top line shadow
	draw.Box(x, y, wBox, 2, colorBox) -- top line shadow
	draw.Box(x, y - 2, wBox, 2, COLOR_WHITE) -- white top line
	draw.FilteredShadowedTexture(xIcon, yIcon, size, size, iconMaterial, 255, COLOR_WHITE)
	draw.ShadowedText(keyString, "weapon_hud_help_key", xKeyString, yKeyString, COLOR_WHITE, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)

	return wBox
end

function keyhelp.Draw()
	local client = LocalPlayer()

	local xBase = 0.5 * ScrW() + offsetCenter
	local yBase = ScrH() - offsetHeight

	for i = 1, #keyhelp.keyHelpers do
		local keyHelper = keyhelp.keyHelpers[i]

		if keyHelper.bindingType == KEYHELP_CORE and not cvEnableCore:GetBool()
			or keyHelper.bindingType == KEYHELP_EXTRA and not cvEnableExtra:GetBool()
			or keyHelper.bindingType == KEYHELP_EQUIPMENT and not cvEnableEquipment:GetBool()
		then continue end

		if not isfunction(keyHelper.callback) or not keyHelper.callback(client) then continue end

		-- handles both internal GMod bindings and TTT2 bindings
		local keyString = Key(keyHelper.binding) or stringUpper(inputGetKeyName(bindFind(keyHelper.binding))) or ""

		xBase = xBase + padding + keyhelp.DrawKey(xBase, yBase, width, keyString, keyHelper.iconMaterial)
	end
end

function keyhelp.InitializeBasicKeys()
	keyhelp.RegisterKeyHelper("gm_showhelp", materialSettings, KEYHELP_CORE, function(client)
		return true
	end)
	keyhelp.RegisterKeyHelper("gm_showteam", materialMute, KEYHELP_CORE, function(client)
		if not client:IsSpec() then return end

		return true
	end)
	keyhelp.RegisterKeyHelper("+menu_context", materialShoppingRole, KEYHELP_CORE, function(client)
		if client:IsSpec() or not client:IsShopper() then return end

		return true
	end)
	keyhelp.RegisterKeyHelper("+use", materialPosessing, KEYHELP_CORE, function(client)
		if not client:IsSpec() or IsValid(client:GetObserverTarget()) then return end

		return true
	end)
	keyhelp.RegisterKeyHelper("+use", materialPlayer, KEYHELP_CORE, function(client)
		if not client:IsSpec() or IsValid(client:GetObserverTarget()) then return end

		return true
	end)
	keyhelp.RegisterKeyHelper("+attack", materialPlayerPrev, KEYHELP_CORE, function(client)
		if not client:IsSpec() then return end

		local target = client:GetObserverTarget()

		if not IsValid(target) or not target:IsPlayer() then return end

		return true
	end)
	keyhelp.RegisterKeyHelper("+attack2", materialPlayerNext, KEYHELP_CORE, function(client)
		if not client:IsSpec() then return end

		local target = client:GetObserverTarget()

		if not IsValid(target) or not target:IsPlayer() then return end

		return true
	end)
	keyhelp.RegisterKeyHelper("+attack2", materialPlayerNext, KEYHELP_CORE, function(client)
		if not client:IsSpec() or IsValid(client:GetObserverTarget()) then return end

		return true
	end)
	keyhelp.RegisterKeyHelper("+jump", materialPropJump, KEYHELP_CORE, function(client)
		if not client:IsSpec() then return end

		local target = client:GetObserverTarget()

		if not IsValid(target) or target:IsPlayer() or target:GetNWEntity("spec_owner", nil) ~= client then return end

		return true
	end)
	keyhelp.RegisterKeyHelper("+moveleft", materialPropLeft, KEYHELP_CORE, function(client)
		if not client:IsSpec() then return end

		local target = client:GetObserverTarget()

		if not IsValid(target) or target:IsPlayer() or target:GetNWEntity("spec_owner", nil) ~= client then return end

		return true
	end)
	keyhelp.RegisterKeyHelper("+moveright", materialPropRight, KEYHELP_CORE, function(client)
		if not client:IsSpec() then return end

		local target = client:GetObserverTarget()

		if not IsValid(target) or target:IsPlayer() or target:GetNWEntity("spec_owner", nil) ~= client then return end

		return true
	end)
	keyhelp.RegisterKeyHelper("+forward", materialPropFront, KEYHELP_CORE, function(client)
		if not client:IsSpec() then return end

		local target = client:GetObserverTarget()

		if not IsValid(target) or target:IsPlayer() or target:GetNWEntity("spec_owner", nil) ~= client then return end

		return true
	end)
	keyhelp.RegisterKeyHelper("+back", materialPropBack, KEYHELP_CORE, function(client)
		if not client:IsSpec() then return end

		local target = client:GetObserverTarget()

		if not IsValid(target) or target:IsPlayer() or target:GetNWEntity("spec_owner", nil) ~= client then return end

		return true
	end)
	keyhelp.RegisterKeyHelper("+duck", materialLeaveTarget, KEYHELP_CORE, function(client)
		if not client:IsSpec() or not IsValid(client:GetObserverTarget()) then return end

		return true
	end)
end