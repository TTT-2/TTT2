---
-- @class ARMOR

ARMOR = {}

---
-- HANDLE ARMOR STATUS ICONS
-- init icons
-- @realm client
function ARMOR:Initialize()
    STATUS:RegisterStatus("ttt_armor_status", {
        hud = {
            Material("vgui/ttt/perks/hud_armor.png"),
            Material("vgui/ttt/perks/hud_armor_reinforced.png"),
        },
        type = "good",
        name = {
            "item_armor",
            "item_armor_reinforced",
        },
        sidebarDescription = "item_armor_sidebar",
    })
end

-- switch between icons
local function HandleArmorStatusIcons(ply)
    -- removed armor
    if ply.armor <= 0 then
        if STATUS:Active("ttt_armor_status") then
            STATUS:RemoveStatus("ttt_armor_status")
        end

        return
    end

    -- check if reinforced
    local icon_id = 1

    if GetGlobalBool("ttt_armor_dynamic", false) then
        icon_id = ply:ArmorIsReinforced() and 2 or 1
    end

    -- normal armor level change (update)
    if STATUS:Active("ttt_armor_status") then
        STATUS:SetActiveIcon("ttt_armor_status", icon_id)

        return
    end

    -- added armor if not active
    STATUS:AddStatus("ttt_armor_status", icon_id)
end

-- SERVER -> CLIENT ARMOR SYNCING
net.Receive("ttt2_sync_armor", function()
    local client = LocalPlayer()

    -- prevent error from netmessage prior to the client beeing ready
    if not IsValid(client) then
        return
    end

    client.armor = net.ReadUInt(16)

    -- UPDATE STATUS ICONS
    HandleArmorStatusIcons(client)
end)

net.Receive("ttt2_sync_armor_max", function()
    local client = LocalPlayer()

    -- prevent error from netmessage prior to the client beeing ready
    if not IsValid(client) then
        return
    end

    client.armor_max = net.ReadUInt(16)
end)
