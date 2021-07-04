--- @ignore

CLGAMEMODESUBMENU.base = "base_gamemodesubmenu"

CLGAMEMODESUBMENU.priority = 99
CLGAMEMODESUBMENU.title = "submenu_administration_randomshop_title"

function CLGAMEMODESUBMENU:Populate(parent)
	local form = vgui.CreateTTT2Form(parent, "header_random_shop_administration")
	local form2 = vgui.CreateTTT2Form(parent, "header_random_shop_value_administration")

	for convar, data in SortedPairsByMemberValue(ShopEditor.cvars, "order", false) do
		local convarName = tostring(convar)
		local name = "shopeditor_name_" .. data.name
		local desc = "shopeditor_desc_" .. data.name

		if data.typ == "bool" then
			if data.b_desc then
				form:MakeHelp({
					label = desc
				})
			end

			form:MakeCheckBox({
				label = name,
				default = data.default,
				initial = GetGlobalBool(convarName),
				OnChange = function(_, value)
					net.Start("TTT2UpdateCVar")
					net.WriteString(convarName)
					net.WriteString(value and "1" or "0")
					net.SendToServer()
				end
			})
		elseif data.typ == "number" then
			if data.b_desc then
				form2:MakeHelp({
					label = desc
				})
			end

			form2:MakeSlider({
				label = name,
				min = data.min,
				max = data.max,
				decimal = 0,
				default = data.default,
				initial = GetGlobalInt(convarName),
				OnChange = function(_, value)
					net.Start("TTT2UpdateCVar")
					net.WriteString(convarName)
					net.WriteString(tostring(value))
					net.SendToServer()
				end
			})
		end
	end
end
