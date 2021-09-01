--- @ignore

CLGAMEMODESUBMENU.base = "base_gamemodesubmenu"

CLGAMEMODESUBMENU.priority = 96
CLGAMEMODESUBMENU.title = "submenu_administration_playermodels_title"

function CLGAMEMODESUBMENU:Populate(parent)
	local form = vgui.CreateTTT2Form(parent, "header_random_shop_administration")

	local base = form:MakeIconLayout()

	local models = player_manager.AllValidModels()

	for name, model in pairs(models) do
		form:MakeImageCheckBox({
			label = name,
			model = model,
			OnSelected = function(slf)
				print("selected model " .. name)
			end
		}, base)
	end
end
