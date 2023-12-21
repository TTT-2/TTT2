--- @ignore

local TryT = LANG.TryTranslation

CLGAMEMODESUBMENU.priority = 0
CLGAMEMODESUBMENU.title = ""

function CLGAMEMODESUBMENU:Populate(parent)
	local equipment = self.equipment
	local accessName = ShopEditor.accessName
	local itemName = equipment.id

	if equipment.builtin then
		local form = vgui.CreateTTT2Form(parent, "header_equipment_info")
		form:MakeHelp({
			label = "equipmenteditor_desc_builtin"
		})
	end

	if not self.isItem then
		local form = vgui.CreateTTT2Form(parent, "header_equipment_weapon_spawn_setup")

		form:MakeHelp({
			label = "equipmenteditor_desc_auto_spawnable"
		})

		local master = form:MakeCheckBox({
			label = "equipmenteditor_name_auto_spawnable",
			database = DatabaseElement(accessName, itemName, "AutoSpawnable")
		})

		local entType
		local entTypeList = entspawnscript.GetEntTypeList(SPAWN_TYPE_WEAPON, {[WEAPON_TYPE_RANDOM] = true})
		local choices = {}
		for i = 1, #entTypeList do
			entType = entTypeList[i]
			choices[i] = {title = TryT(entspawnscript.GetLangIdentifierFromSpawnType(SPAWN_TYPE_WEAPON, entType)), value = entType}
		end

		form:MakeComboBox({
			label = "equipmenteditor_name_spawn_type",
			database = DatabaseElement(accessName, itemName, "spawnType"),
			choices = choices,
			master = master
		})
	end

	local form = vgui.CreateTTT2Form(parent, "header_equipment_setup")

	form:MakeHelp({
		label = "equipmenteditor_desc_kind"
	})

	form:MakeComboBox({
		label = "equipmenteditor_name_kind",
		database = DatabaseElement(accessName, itemName, "Kind"),
		choices = {
			{title = TryT("slot_weapon_melee"), value = WEAPON_MELEE},
			{title = TryT("slot_weapon_pistol"), value = WEAPON_PISTOL},
			{title = TryT("slot_weapon_heavy"), value = WEAPON_HEAVY},
			{title = TryT("slot_weapon_nade"), value = WEAPON_NADE},
			{title = TryT("slot_weapon_carry"), value = WEAPON_CARRY},
			{title = TryT("slot_weapon_unarmed"), value = WEAPON_UNARMED},
			{title = TryT("slot_weapon_special"), value = WEAPON_SPECIAL},
			{title = TryT("slot_weapon_extra"), value = WEAPON_EXTRA},
			{title = TryT("slot_weapon_class"), value = WEAPON_CLASS}
		},
		master = nil
	})

	form:MakeHelp({
		label = "equipmenteditor_desc_not_buyable"
	})

	local master = form:MakeCheckBox({
		label = "equipmenteditor_name_not_buyable",
		database = DatabaseElement(accessName, itemName, "notBuyable"),
		invert = true
	})

	form:MakeHelp({
		label = "equipmenteditor_desc_not_random"
	})

	form:MakeCheckBox({
		label = "equipmenteditor_name_not_random",
		database = DatabaseElement(accessName, itemName, "NoRandom"),
		master = master
	})

	form:MakeHelp({
		label = "equipmenteditor_desc_global_limited"
	})

	form:MakeCheckBox({
		label = "equipmenteditor_name_global_limited",
		database = DatabaseElement(accessName, itemName, "globalLimited"),
		master = master
	})

	form:MakeHelp({
		label = "equipmenteditor_desc_team_limited"
	})

	form:MakeCheckBox({
		label = "equipmenteditor_name_team_limited",
		database = DatabaseElement(accessName, itemName, "teamLimited"),
		master = master
	})

	form:MakeHelp({
		label = "equipmenteditor_desc_player_limited"
	})

	form:MakeCheckBox({
		label = "equipmenteditor_name_player_limited",
		database = DatabaseElement(accessName, itemName, "limited"),
		master = master
	})

	form:MakeHelp({
		label = "equipmenteditor_desc_allow_drop"
	})

	form:MakeCheckBox({
		label = "equipmenteditor_name_allow_drop",
		database = DatabaseElement(accessName, itemName, "AllowDrop"),
		master = nil
	})

	form:MakeHelp({
		label = "equipmenteditor_desc_drop_on_death_type"
	})

	form:MakeComboBox({
		label = "equipmenteditor_name_drop_on_death_type",
		database = DatabaseElement(accessName, itemName, "overrideDropOnDeath"),
		choices = {
			{title = TryT("drop_on_death_type_default"), value = DROP_ON_DEATH_TYPE_DEFAULT},
			{title = TryT("drop_on_death_type_force"), value = DROP_ON_DEATH_TYPE_FORCE},
			{title = TryT("drop_on_death_type_deny"), value = DROP_ON_DEATH_TYPE_DENY}
		},
		master = nil
	})

	form = vgui.CreateTTT2Form(parent, "header_equipment_value_setup")

	form:MakeSlider({
		label = "equipmenteditor_name_min_players",
		min = 0,
		max = 63,
		decimal = 0,
		database = DatabaseElement(accessName, itemName, "minPlayers"),
		master = master
	})

	form:MakeSlider({
		label = "equipmenteditor_name_credits",
		min = 0,
		max = 20,
		decimal = 0,
		database = DatabaseElement(accessName, itemName, "credits"),
		master = master
	})

	form:MakeSlider({
		label = "equipmenteditor_name_damage_scaling",
		min = 0,
		max = 8,
		decimal = 2,
		database = DatabaseElement(accessName, itemName, "damageScaling"),
		master = nil
	})


	-- Get inheritable version for weapons to access inherited functions
	if not self.isItem then
		equipment = weapons.Get(WEPS.GetClass(equipment))
	end

	-- now add custom equipment settings
	equipment:AddToSettingsMenu(parent)

	hook.Run("TTT2OnEquipmentAddToSettingsMenu", equipment, parent)
end
