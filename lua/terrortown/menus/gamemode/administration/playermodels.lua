--- @ignore

CLGAMEMODESUBMENU.base = "base_gamemodesubmenu"

CLGAMEMODESUBMENU.priority = 96
CLGAMEMODESUBMENU.title = "submenu_administration_playermodels_title"

local cachedBoxes = {}

local function OnDataAvailable(data)
	for i = 1, #data do
		local name = data[i]

		if not cachedBoxes[name] then continue end

		cachedBoxes[name]:SetSelected(true)
	end
end

function CLGAMEMODESUBMENU:Populate(parent)
	local form = vgui.CreateTTT2Form(parent, "header_random_shop_administration")

	local base = form:MakeIconLayout()

	local models = player_manager.AllValidModels()

	for name, model in pairs(models) do
		cachedBoxes[name] = form:MakeImageCheckBox({
			label = name,
			model = model,
			OnSelected = function(slf, state)
				if state then
					playermodels.AddSelectedModel(name)
				else
					playermodels.RemoveSelectedModel(name)
				end
			end
		}, base)
	end

	playermodels.GetSelectedModels(OnDataAvailable)
end
