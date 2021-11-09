--- @ignore

CLGAMEMODESUBMENU.base = "base_gamemodesubmenu"

CLGAMEMODESUBMENU.priority = 94
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
	local modelStates = playermodels.GetModelStates()
	local models = player_manager.AllValidModels()

	for name, data in SortedPairsByMemberValue(modelStates, "sortName") do
		local model = models[name]

		if not model then continue end

		boxCache[name] = form2:MakeImageCheckBox({
			label = name,
			model = model,
			headbox = data.hasHeadHitBox,
			initialModel = data.selected,
			initialHattable = data.hattable,
			OnModelSelected = function(_, state)
				playermodels.UpdateModel(name, playermodels.state.selected, state)
			end,
			OnModelHattable = function(_, state)
				playermodels.UpdateModel(name, playermodels.state.hattable, state)
			end
		}, base)
	end

	playermodels.OnChange("PlayermodelsUpdateTrigger", function(data)
		for name, entry in pairs(data) do
			if not IsValid(boxCache[name]) then continue end

			boxCache[name]:SetModelSelected(entry.selected)
			boxCache[name]:SetModelHattable(entry.hattable)
		end
	end)
end

function CLGAMEMODESUBMENU:PopulateButtonPanel(parent)
	local buttonReset = vgui.Create("DButtonTTT2", parent)

	buttonReset:SetText("button_reset_models")
	buttonReset:SetSize(225, 45)
	buttonReset:SetPos(parent:GetWide() - 245, 20)
	buttonReset.DoClick = function()
		playermodels.Reset()
	end
end

function CLGAMEMODESUBMENU:HasButtonPanel()
	return true
end
