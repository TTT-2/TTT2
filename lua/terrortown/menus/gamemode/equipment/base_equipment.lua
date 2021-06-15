--- @ignore

CLGAMEMODESUBMENU.priority = 0
CLGAMEMODESUBMENU.title = ""

local function Invert(data, value)
	if data.inverted then
		return not value
	else
		return value
	end
end

function CLGAMEMODESUBMENU:Populate(parent)
	local item = self.item

	local form = vgui.CreateTTT2Form(parent, "header_equipment_setup")
	local form2 = vgui.CreateTTT2Form(parent, "header_equipment_value_setup")

	local buyableRef

	for key, data in SortedPairsByMemberValue(ShopEditor.savingKeys, "order", false) do
		local name = "itemeditor_name_" .. data.name
		local desc = "itemeditor_desc_" .. data.name

		if data.typ == "bool" then
			if data.b_desc then
				form:MakeHelp({
					label = desc
				})
			end

			local cb = form:MakeCheckBox({
				label = name,
				default = Invert(data, item.defaultValues[key]),
				initial = Invert(data, item[key]),
				OnChange = function(_, value)
					net.Start("TTT2SESaveItem")
					net.WriteString(item.id)
					net.WriteUInt(1, ShopEditor.savingKeysBitCount or 16)
					net.WriteString(key)
					net.WriteBool(Invert(data, tobool(value)))
					net.SendToServer()
				end,
				master = buyableRef
			})

			-- store reference if buyable button
			if data.name == "not_buyable" then
				buyableRef = cb
			end
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
				default = item.defaultValues[key],
				initial = item[key],
				OnChange = function(_, value)
					net.Start("TTT2SESaveItem")
					net.WriteString(item.id)
					net.WriteUInt(1, ShopEditor.savingKeysBitCount or 16)
					net.WriteString(key)
					net.WriteUInt(math.Round(value), data.bits or 16)
					net.SendToServer()
				end,
				master = buyableRef
			})
		end
	end
end
