---
-- disguiser @{ITEM}
-- @module DISGUISE
-- @see ITEM

DISGUISE = CLIENT and {}

if SERVER then
	AddCSLuaFile()
end

ITEM.hud = Material("vgui/ttt/perks/hud_disguiser.png")
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

	---
	-- Draws the disguise info on screen for the disguised @{Player}
	-- @param Player client the client
	-- @realm client
	function DISGUISE.Draw(client)
		if not client or not client:IsActive() or not client:GetNWBool("disguised", false) then return end

		trans = trans or LANG.GetTranslation

		surface.SetFont("TabLarge")
		surface.SetTextColor(255, 0, 0, 230)

		local text = trans("disg_hud")
		local _, h = surface.GetTextSize(text)

		surface.SetTextPos(36, ScrH() - 160 - h)
		surface.DrawText(text)
	end

	hook.Add("HUDPaint", "TTTItemDisguiser", function()
		local client = LocalPlayer()

		if client:Alive() and client:Team() ~= TEAM_SPEC and hook.Call("HUDShouldDraw", GAMEMODE, "TTTDisguise") then
			DISGUISE.Draw(client)
		end
	end)

	hook.Add("TTTEquipmentTabs", "TTTItemDisguiser", function(dsheet)
		trans = trans or LANG.GetTranslation

		if not LocalPlayer():HasEquipmentItem("item_ttt_disguiser") then return end

		local ddisguise = DISGUISE.CreateMenu(dsheet)

		dsheet:AddSheet(trans("disg_name"), ddisguise, "icon16/user.png", false, false, trans("equip_tooltip_disguise"))
	end)
else
	local function SetDisguise(ply, cmd, args)
		if not IsValid(ply) or not ply:IsActive() and ply:HasTeam(TEAM_TRAITOR) then return end

		if not ply:HasEquipmentItem("item_ttt_disguiser") then return end

		local state = #args == 1 and tobool(args[1])

		if hook.Run("TTTToggleDisguiser", ply, state) then return end

		ply:SetNWBool("disguised", state)

		LANG.Msg(ply, state and "disg_turned_on" or "disg_turned_off")
	end
	concommand.Add("ttt_set_disguise", SetDisguise)
end
