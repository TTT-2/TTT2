if SERVER then
	AddCSLuaFile()

	return
end

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
local materialShoppingRole = Material("vgui/ttt/hudhelp/shopping_role")

keyhelp = keyhelp or {}
keyhelp.keyHelpers = {}

function keyhelp.RegisterKeyHelper(binding, iconMaterial, callback)
	keyhelp.keyHelpers[#keyhelp.keyHelpers + 1] = {
		binding = binding,
		iconMaterial = iconMaterial,
		callback = callback
	}
end

function keyhelp.DrawKey(x, y, size, keyString, iconMaterial)
	local wKeyString = draw.GetTextSize(keyString, "weapon_hud_help_key")
	local wBox = math.max(size, wKeyString) + 2 * padding
	local xIcon = x + 0.5 * (wBox - size)
	local yIcon = y + padding
	local xKeyString = x + math.floor(0.5 * wBox)
	local yKeyString = y + size + 2 * padding

	draw.BlurredBox(x, y, wBox, offsetHeight + padding)
	draw.Box(x, y, wBox, offsetHeight + padding, colorBox)
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

		if not isfunction(keyHelper.callback) or not keyHelper.callback(client) then continue end

		-- handles both internal GMod bindings and TTT2 bindings
		local keyString = Key(keyHelper.binding) or stringUpper(inputGetKeyName(bindFind(keyHelper.binding))) or ""

		xBase = xBase + padding + keyhelp.DrawKey(xBase, yBase, width, keyString, keyHelper.iconMaterial)
	end
end

function keyhelp.InitializeBasicKeys()
	keyhelp.RegisterKeyHelper("gm_showhelp", materialSettings, function(client)
		return true
	end)
	keyhelp.RegisterKeyHelper("+menu_context", materialShoppingRole, function(client)
		if client:IsSpec() or not client:IsShopper() then return end

		return true
	end)
end