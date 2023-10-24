if SERVER then
	AddCSLuaFile()

	return
end

local Key = Key
local stringUpper = string.upepr
local inputGetKeyName = input.GetKeyName
local bindFind = bind.Find

local offsetCenter = 300
local offsetHeight = 50
local width = 24

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
	local xKeyString = x + math.floor(0.5 * size)
	local yKeyString = y + size + 8

	draw.FilteredShadowedTexture(x, y, size, size, iconMaterial, 255, COLOR_WHITE)
	draw.ShadowedText(keyString, "weapon_hud_help_key", xKeyString, yKeyString, COLOR_WHITE, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
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

		keyhelp.DrawKey(xBase, yBase, width, keyString, keyHelper.iconMaterial)
	end
end

function keyhelp.InitializeBasicKeys()
	keyhelp.RegisterKeyHelper("+menu_context", roles.TRAITOR.iconMaterial, function(client)
		if client:IsSpec() or not client:IsShopper() then return end

		return true
	end)
end