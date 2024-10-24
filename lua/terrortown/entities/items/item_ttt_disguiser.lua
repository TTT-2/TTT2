---
-- Disguiser @{ITEM}
-- @module DISGUISE

local materialIconDisguiser = Material("vgui/ttt/hudhelp/item_disguiser")

DISGUISE = CLIENT and {}

if SERVER then
    AddCSLuaFile()
end

ITEM.CanBuy = { ROLE_TRAITOR }
ITEM.oldId = EQUIP_DISGUISE or 4
ITEM.builtin = true

if CLIENT then
    local trans

    ITEM.EquipMenuData = {
        type = "item_active",
        name = "item_disg",
        desc = "item_disg_desc",
    }
    ITEM.material = "vgui/ttt/icon_disguise"
    ITEM.hud = Material("vgui/ttt/perks/hud_disguiser.png")

    ITEM.sidebarDescription = "item_disguiser_sidebar"

    ---
    -- @ignore
    function ITEM:DrawInfo()
        return LocalPlayer():GetNWBool("disguised") and "status_on" or "status_off"
    end

    ---
    -- Creates the Disguiser menu on the parent panel
    -- @param Panel parent parent panel
    -- @return Panel created disguiser menu panel
    -- @realm client
    function DISGUISE.CreateMenu(parent)
        trans = trans or LANG.GetTranslation

        local dform = vgui.Create("DForm", parent)
        dform:SetLabel(trans("disg_menutitle"))
        dform:StretchToParent(0, 0, 0, 0)
        dform:SetAutoSize(false)

        local owned = LocalPlayer():HasEquipmentItem("item_ttt_disguiser")

        if not owned then
            dform:Help(trans("disg_not_owned"))

            return dform
        end

        local dcheck = vgui.Create("DCheckBoxLabel", dform)
        dcheck:SetText(trans("disg_enable"))
        dcheck:SetIndent(5)
        dcheck:SetValue(LocalPlayer():GetNWBool("disguised", false))

        dcheck.OnChange = function(s, val)
            RunConsoleCommand("ttt_set_disguise", val and "1" or "0")
        end

        dform:AddItem(dcheck)
        dform:Help(trans("disg_help1"))
        dform:Help(trans("disg_help2"))
        dform:SetVisible(true)

        return dform
    end

    hook.Add("TTTEquipmentTabs", "TTTItemDisguiser", function(dsheet)
        trans = trans or LANG.GetTranslation

        if not LocalPlayer():HasEquipmentItem("item_ttt_disguiser") then
            return
        end

        local ddisguise = DISGUISE.CreateMenu(dsheet)

        dsheet:AddSheet(
            trans("disg_name"),
            ddisguise,
            "icon16/user.png",
            false,
            false,
            trans("equip_tooltip_disguise")
        )
    end)

    hook.Add("TTT2FinishedLoading", "TTTItemDisguiserInitStatus", function()
        bind.Register("ttt2_disguiser_toggle", function()
            WEPS.DisguiseToggle(LocalPlayer())
        end, nil, "header_bindings_ttt2", "label_bind_disguiser", KEY_PAD_ENTER)

        keyhelp.RegisterKeyHelper(
            "ttt2_disguiser_toggle",
            materialIconDisguiser,
            KEYHELP_EQUIPMENT,
            "label_keyhelper_disguiser",
            function(client)
                if client:IsSpec() or not client:HasEquipmentItem("item_ttt_disguiser") then
                    return
                end

                return true
            end
        )
    end)
else -- SERVER
    -- @ignore
    local function SetDisguise(ply, cmd, args)
        if
            not IsValid(ply)
            or not ply:IsActive()
            or not ply:HasEquipmentItem("item_ttt_disguiser")
        then
            return
        end

        local state = #args == 1 and tobool(args[1])

        ---
        -- @realm server
        if hook.Run("TTTToggleDisguiser", ply, state) then
            return
        end

        ply:SetNWBool("disguised", state)

        LANG.Msg(ply, state and "disg_turned_on" or "disg_turned_off", nil, MSG_MSTACK_ROLE)
    end
    concommand.Add("ttt_set_disguise", SetDisguise)

    hook.Add("TTT2PlayerReady", "TTTItemDisguiserPlayerReady", function(ply)
        ply:SetNWVarProxy("disguised", function(ent, name, old, new)
            if not IsValid(ent) or not ent:IsPlayer() or name ~= "disguised" then
                return
            end

            if new then
                STATUS:AddStatus(ent, "item_disguiser_status")
            else
                STATUS:RemoveStatus(ent, "item_disguiser_status")
            end
        end)
    end)

    ---
    -- This hook is called once the disguiser state is about to be updated
    -- and can be used to cancel this change.
    -- @param Player ply The player whose disguising state should be changed
    -- @param boolean state The state that should be set
    -- @return nil|boolean Return true to cancel the state change
    -- @hook
    -- @realm server
    function GM:TTTToggleDisguiser(ply, state) end
end
