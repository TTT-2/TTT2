--- @ignore

CLGAMEMODESUBMENU.base = "base_gamemodesubmenu"

CLGAMEMODESUBMENU.priority = 96
CLGAMEMODESUBMENU.title = "submenu_administration_playermodels_title"

local boxCache = {}

function CLGAMEMODESUBMENU:Populate(parent)
	local form = vgui.CreateTTT2Form(parent, "header_playermodels_general")

	form:MakeHelp({
		label = "help_enforce_playermodel"
	})

	form:MakeCheckBox({
		label = "label_enforce_playermodel",
		serverConvar = "ttt_enforce_playermodel"
	})

	form:MakeHelp({
		label = "help_prefer_map_models"
	})

	form:MakeCheckBox({
		label = "label_prefer_map_models",
		serverConvar = "ttt2_prefer_map_models"
	})

	form:MakeHelp({
		label = "help_use_custom_models"
	})

	local customModelsEnb = form:MakeCheckBox({
		label = "label_use_custom_models",
		serverConvar = "ttt2_use_custom_models"
	})

	form:MakeCheckBox({
		label = "label_select_model_per_round",
		serverConvar = "ttt2_select_model_per_round",
		master = customModelsEnb
	})

	local form2 = vgui.CreateTTT2Form(parent, "header_playermodels_selection")

	form2:MakeHelp({
		label = "help_models_select"
	})

	local base = form2:MakeIconLayout()
	local models = player_manager.AllValidModels()
	local headBoxes = playermodels.GetHeadHitBoxModelNameList()

	for name, model in pairs(models) do
		boxCache[name] = form2:MakeImageCheckBox({
			label = name,
			model = model,
			headbox = headBoxes[name],
			initialModel = playermodels.IsSelectedModel(name),
			initialHattable = playermodels.IsHattableModel(name),
			OnModelSelected = function(_, state)
				print("update selection", state)
				playermodels.UpdateModelSelected(name, state)
			end,
			OnModelHattable = function(_, state)
				print("update hattable", state)
				playermodels.UpdateModelHattable(name, state)
			end
		}, base)
	end

	playermodels.OnChange("PlayermodelsUpdateTrigger", function(data)
		for name, entry in pairs(data) do
			boxCache[name]:SetModelSelected(entry.selected)
		end
	end)
end
