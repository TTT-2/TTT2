---
-- Credit transfer tab for equipment menu
-- @section shop_reroll

local GetTranslation = LANG.GetTranslation
local GetParamTranslation = LANG.GetParamTranslation
local vgui = vgui

---
-- Initializes the reroll menu
-- @param Panel parent the shop menu
-- @return Panel
-- @realm client
-- @internal
function CreateRerollMenu(parent)
    local client = LocalPlayer()

    local dform = vgui.Create("DForm", parent)
    dform:SetLabel(GetTranslation("reroll_menutitle"))
    dform:StretchToParent(0, 0, 0, 0)
    dform:SetAutoSize(false)

    local cost = GetGlobalInt("ttt2_random_shop_reroll_cost")

    if client:GetCredits() < cost then
        dform:Help(GetParamTranslation("reroll_no_credits", { amount = cost }))

        return dform
    end

    local bw, bh = 100, 20

    local dsubmit = vgui.Create("DButton", dform)
    dsubmit:SetSize(bw, bh)
    dsubmit:SetEnabled(true)
    dsubmit:SetText(GetTranslation("reroll_button"))

    dsubmit.DoClick = function(s)
        if not shop.TryRerollShop(client) then
            return
        end

        RunConsoleCommand("ttt_cl_traitorpopup")

        timer.Simple(0.1, function()
            RunConsoleCommand("ttt_cl_traitorpopup")
        end)
    end

    dsubmit.Think = function(s)
        if client:GetCredits() < cost or not GetGlobalBool("ttt2_random_shop_reroll") then
            s:SetEnabled(false)
        end
    end

    dform:AddItem(dsubmit)
    dform:Help(GetParamTranslation("reroll_help", { amount = cost }))

    return dform
end
