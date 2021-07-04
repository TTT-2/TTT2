--- @ignore

CLGAMEMODESUBMENU.base = "base_gamemodesubmenu"

CLGAMEMODESUBMENU.priority = 99
CLGAMEMODESUBMENU.title = "submenu_gameplay_avoidroles_title"

function CLGAMEMODESUBMENU:Populate(parent)
	local form = vgui.CreateTTT2Form(parent, "header_roleselection")

	local roles = roles.GetList()

	for i = 1, #roles do
		local v = roles[i]

		if ConVarExists("ttt_avoid_" .. v.name) then
			local rolename = v.name

			form:MakeCheckBox({
				label = rolename,
				convar = "ttt_avoid_" .. rolename
			})
		end
	end

	form:Dock(TOP)
end
