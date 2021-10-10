--- @ignore

CLGAMEMODESUBMENU.base = "base_gamemodesubmenu"

CLGAMEMODESUBMENU.priority = 96
CLGAMEMODESUBMENU.title = "submenu_administration_playermodels_title"

local boxCache = {}

local function OnDataUpdated(data)
	-- first iterate over all and disable them
	for _, box in pairs(boxCache) do
		box:SetSelected(false)
	end

	-- then enable the now selected ones
	for i = 1, #data do
		boxCache[data[i]]:SetSelected(true)
	end
end

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
			initial = playermodels.HasSelectedModel(name),
			OnSelected = function(slf, state)
				playermodels.UpdateModelState(name, state)
			end
		}, base)
	end

	playermodels.AddChangeCallback(OnDataUpdated)
end
