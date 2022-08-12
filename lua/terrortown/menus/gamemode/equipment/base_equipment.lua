--- @ignore

local TryT = LANG.TryTranslation

CLGAMEMODESUBMENU.priority = 0
CLGAMEMODESUBMENU.title = ""

function CLGAMEMODESUBMENU:Populate(parent)
	local equipment = self.equipment
	local accessName = ShopEditor.accessName
	local itemName = equipment.id

	if not self.isItem then
		local form = vgui.CreateTTT2Form(parent, "header_equipment_weapon_spawn_setup")

		form:MakeHelp({
			label = "equipmenteditor_desc_auto_spawnable"
		})

		local master = form:MakeCheckBox({
			label = "equipmenteditor_name_auto_spawnable",
			database = {name = accessName, itemName = itemName, key = "AutoSpawnable"}
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
			database = {name = accessName, itemName = itemName, key = "spawnType"},
			choices = choices,
			master = master
		})
	end

	local form = vgui.CreateTTT2Form(parent, "header_equipment_setup")

	form:MakeHelp({
		label = "equipmenteditor_desc_not_buyable"
	})

	local master = form:MakeCheckBox({
		label = "equipmenteditor_name_not_buyable",
		database = {name = accessName, itemName = itemName, key = "notBuyable"},
		invert = true
	})

	form:MakeHelp({
		label = "equipmenteditor_desc_not_random"
	})

	form:MakeCheckBox({
		label = "equipmenteditor_name_not_random",
		database = {name = accessName, itemName = itemName, key = "NoRandom"},
		master = master
	})

	form:MakeHelp({
		label = "equipmenteditor_desc_global_limited"
	})

	form:MakeCheckBox({
		label = "equipmenteditor_name_global_limited",
		database = {name = accessName, itemName = itemName, key = "globalLimited"},
		master = master
	})

	form:MakeHelp({
		label = "equipmenteditor_desc_team_limited"
	})

	form:MakeCheckBox({
		label = "equipmenteditor_name_team_limited",
		database = {name = accessName, itemName = itemName, key = "teamLimited"},
		master = master
	})

	form:MakeHelp({
		label = "equipmenteditor_desc_player_limited"
	})

	form:MakeCheckBox({
		label = "equipmenteditor_name_player_limited",
		database = {name = accessName, itemName = itemName, key = "limited"},
		master = master
	})

	form = vgui.CreateTTT2Form(parent, "header_equipment_value_setup")

	form:MakeSlider({
		label = "equipmenteditor_name_min_players",
		min = 0,
		max = 63,
		decimal = 0,
		database = {name = accessName, itemName = itemName, key = "minPlayers"},
		master = master
	})

	form:MakeSlider({
		label = "equipmenteditor_name_credits",
		min = 0,
		max = 20,
		decimal = 0,
		database = {name = accessName, itemName = itemName, key = "credits"},
		master = master
	})

	-- Get inheritable version for weapons to access inherited functions
	if not self.isItem then
		equipment = weapons.Get(WEPS.GetClass(equipment))
	end

	-- now add custom equipment settings
	equipment:AddToSettingsMenu(parent)
end
