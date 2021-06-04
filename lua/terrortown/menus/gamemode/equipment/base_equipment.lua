--- @ignore

CLGAMEMODESUBMENU.priority = 0
CLGAMEMODESUBMENU.title = ""

function CLGAMEMODESUBMENU:Populate(parent)
	local item = self.item

	local form = vgui.CreateTTT2Form(parent, "header_equipment_setup")
	local form2 = vgui.CreateTTT2Form(parent, "header_equipment_value_setup")

	for key, data in SortedPairsByMemberValue(ShopEditor.savingKeys, "order", false) do
		local name = "itemeditor_name_" .. data.name
		local desc = "itemeditor_desc_" .. data.name

		if data.typ == "bool" then
			if data.b_desc then
				form:MakeHelp({
					label = desc
				})
			end

			form:MakeCheckBox({
				label = name,
				default = data.default,
				initial = item[key],
				OnChange = function(_, value)
					net.Start("TTT2SESaveItem")
					net.WriteString(item.id)
					net.WriteBool(tobool(value))
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
				initial = item[key],
				OnChange = function(_, value)
					net.Start("TTT2SESaveItem")
					net.WriteString(item.id)
					net.WriteUInt(math.Round(value), data.bits or 16)
					net.SendToServer()
				end
			})
		end
	end
end