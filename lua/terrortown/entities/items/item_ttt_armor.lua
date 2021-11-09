if SERVER then
	AddCSLuaFile()
end

ITEM.EquipMenuData = {
	type = "item_passive",
	name = "item_armor",
	desc = "item_armor_desc"
}

ITEM.material = "vgui/ttt/icon_armor"
ITEM.CanBuy = {ROLE_TRAITOR, ROLE_DETECTIVE}
ITEM.oldId = EQUIP_ARMOR or 1
ITEM.limited = false

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
		if not GetGlobalBool("ttt_armor_classic") then return end

		local item = items.GetStored("item_ttt_armor")
		if not item then return end

		-- limit item when in classic mode
		item.limited = true
	end)

	---
	-- @ignore
	function ITEM:AddToSettingsMenu(parent)
		local form = vgui.CreateTTT2Form(parent, "header_equipment_additional")

		form:MakeHelp({
			label = "help_armor_balancing"
		})

		form:MakeCheckBox({
			serverConvar = "ttt_item_armor_block_headshots",
			label = "label_armor_block_headshots"
		})

		form:MakeCheckBox({
			serverConvar = "ttt_item_armor_block_blastdmg",
			label = "label_armor_block_blastdmg"
		})

		form:MakeHelp({
			label = "help_item_armor_classic"
		})

		form:MakeCheckBox({
			serverConvar = "ttt_armor_classic",
			label = "label_armor_classic"
		})

		form:MakeHelp({
			label = "help_item_armor_dynamic"
		})

		form:MakeSlider({
			serverConvar = "ttt_item_armor_value",
			label = "label_armor_value",
			min = 0,
			max = 100,
			decimal = 0
		})

		form:MakeSlider({
			serverConvar = "ttt_armor_damage_block_pct",
			label = "label_armor_damage_block_pct",
			min = 0,
			max = 1,
			decimal = 2
		})

		form:MakeSlider({
			serverConvar = "ttt_armor_damage_health_pct",
			label = "label_armor_damage_health_pct",
			min = 0,
			max = 1,
			decimal = 2
		})

		local enbReInf = form:MakeCheckBox({
			serverConvar = "ttt_armor_enable_reinforced",
			label = "label_armor_enable_reinforced"
		})

		form:MakeSlider({
			serverConvar = "ttt_armor_threshold_for_reinforced",
			label = "label_armor_threshold_for_reinforced",
			min = 0,
			max = 100,
			decimal = 0,
			master = enbReInf
		})
	end
end
