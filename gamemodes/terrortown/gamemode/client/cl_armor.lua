ARMOR = {}

-- HANDLE ARMOR STATUS ICONS
-- init icons
function ARMOR:Initialize()
	STATUS:RegisterStatus("ttt_weapon_armor", {
		hud = {
			Material("vgui/ttt/perks/hud_armor.png"),
			Material("vgui/ttt/perks/hud_armor_reinforced.png")
		},
		type = "good"
	})
end

-- switch between icons
local function HandleArmorStatusIcons(ply)
	-- removed armor
	if STATUS:Active("ttt_weapon_armor") and ply.armor == 0 then
		STATUS:RemoveStatus("ttt_weapon_armor")
	end

	-- check if reinforced
	local icon_id = 1

	if not GetGlobalBool("ttt_armor_classic", false) then
		icon_id = ply:ArmorIsReinforced() and 2 or 1
	end

	-- added armor
	if not STATUS:Active("ttt_weapon_armor") and ply.armor > 0 then
		STATUS:AddStatus("ttt_weapon_armor", icon_id)
	end

	-- normal armor level change
	if STATUS:Active("ttt_weapon_armor") then
		STATUS:SetActiveIcon("ttt_weapon_armor", icon_id)
	end
end

-- SERVER -> CLIENT ARMOR SYNCING
net.Receive("ttt2_sync_armor", function()
	local client = LocalPlayer()

	-- prevent error from netmessage prior to the client beeing ready
	if not IsValid(client) then return end

	client.armor = net.ReadUInt(16)

	-- UPDATE STATUS ICONS
	HandleArmorStatusIcons(client)
end)

net.Receive("ttt2_sync_armor_max", function()
	local client = LocalPlayer()

	-- prevent error from netmessage prior to the client beeing ready
	if not IsValid(client) then return end

	client.armor_max = net.ReadUInt(16)
end)
