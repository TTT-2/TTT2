---
-- Disguiser @{ITEM}
-- @module DISGUISE

DISGUISE = CLIENT and {}

if SERVER then
	AddCSLuaFile()
end

ITEM.EquipMenuData = {
	type = "item_active",
	name = "item_disg",
	desc = "item_disg_desc"
}
ITEM.material = "vgui/ttt/icon_disguise"
ITEM.CanBuy = {ROLE_TRAITOR}
ITEM.oldId = EQUIP_DISGUISE or 4

if CLIENT then
	local trans

	---
	-- Creates the Disguiser menu on the parent panel
	-- @param Panel parent parent panel
	-- @return Panel created disguiser menu panel
	-- @realm client
	function DISGUISE.CreateMenu(parent)
		trans = trans or LANG.GetTranslation

		local dform = vgui.Create("DForm", parent)
		dform:SetName(trans("disg_menutitle"))
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

		if not LocalPlayer():HasEquipmentItem("item_ttt_disguiser") then return end

		local ddisguise = DISGUISE.CreateMenu(dsheet)

		dsheet:AddSheet(trans("disg_name"), ddisguise, "icon16/user.png", false, false, trans("equip_tooltip_disguise"))
	end)

	hook.Add("Initialize", "TTTItemDisguiserInitStatus", function()
		STATUS:RegisterStatus("item_disguiser_status", {
			hud = Material("vgui/ttt/perks/hud_disguiser.png"),
			type = "good"
		})

		bind.Register("ttt2_disguiser_toggle", function()
			WEPS.DisguiseToggle(LocalPlayer())
		end,
		nil, "header_bindings_ttt2", "label_bind_disguiser", KEY_PAD_ENTER)
	end)
else -- SERVER
	local function SetDisguise(ply, cmd, args)
		if not IsValid(ply) or not ply:IsActive() or not ply:HasEquipmentItem("item_ttt_disguiser") then return end

		local state = #args == 1 and tobool(args[1])

		---
		-- @realm server
		if hook.Run("TTTToggleDisguiser", ply, state) then return end

		ply:SetNWBool("disguised", state)

		LANG.Msg(ply, state and "disg_turned_on" or "disg_turned_off", nil, MSG_MSTACK_ROLE)
	end
	concommand.Add("ttt_set_disguise", SetDisguise)

	hook.Add("TTT2PlayerReady", "TTTItemDisguiserPlayerReady", function(ply)
		ply:SetNWVarProxy("disguised", function(ent, name, old, new)
			if not IsValid(ent) or not ent:IsPlayer() or name ~= "disguised" then return end

			if new then
				STATUS:AddStatus(ent, "item_disguiser_status")
			else
				STATUS:RemoveStatus(ent, "item_disguiser_status")
			end
		end)
	end)
end
