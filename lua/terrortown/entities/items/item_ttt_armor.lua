if SERVER then
    AddCSLuaFile()
end

ITEM.EquipMenuData = {
    type = "item_passive",
    name = "item_armor",
    desc = "item_armor_desc",
}

ITEM.material = "vgui/ttt/icon_armor"
ITEM.CanBuy = { ROLE_TRAITOR, ROLE_DETECTIVE }
ITEM.oldId = EQUIP_ARMOR or 1
ITEM.limited = false
ITEM.builtin = true

if SERVER then
    ---
    -- @ignore
    function ITEM:Equip(buyer)
        buyer:GiveArmor(GetConVar("ttt_item_armor_value"):GetInt())
    end

    ---
    -- @ignore
    function ITEM:Reset(buyer)
        buyer:RemoveArmor(GetConVar("ttt_item_armor_value"):GetInt())
    end
else -- CLIENT
    -- HANDLE ITEM CLASSIC MODE
    hook.Add("TTTBeginRound", "ttt2_base_register_armor_text", function()
        if GetGlobalBool("ttt_armor_dynamic") then
            return
        end

        local item = items.GetStored("item_ttt_armor")
        if not item then
            return
        end

        -- limit item when in classic mode
        item.limited = true
    end)

    ---
    -- @ignore
    function ITEM:AddToSettingsMenu(parent)
        local form = vgui.CreateTTT2Form(parent, "header_equipment_additional")

        form:MakeHelp({
            label = "help_item_armor_value",
        })

        form:MakeSlider({
            serverConvar = "ttt_item_armor_value",
            label = "label_armor_value",
            min = 0,
            max = 100,
            decimal = 0,
        })
    end
end
