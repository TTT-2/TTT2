--- @ignore

local TryT = LANG.TryTranslation

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
	local equipment = self.equipment
	local forms = {}
	local form
	local masterRefs = {}

	for key, data in SortedPairsByMemberValue(ShopEditor.savingKeys, "order", false) do
		if self.isItem and not data.showForItem then continue end

		form = forms[data.group or 1]

		if not form then
			form = vgui.CreateTTT2Form(parent, ShopEditor.groupTitles[data.group])
			forms[data.group or 1] = form
		end

		local name = "equipmenteditor_name_" .. data.name
		local desc = "equipmenteditor_desc_" .. data.name

		if data.b_desc then
			form:MakeHelp({
				label = desc
			})
		end

		local option

		if data.typ == "bool" then
			option = form:MakeCheckBox({
				label = name,
				default = Invert(data, equipment.defaultValues[key]),
				initial = Invert(data, equipment[key]),
				OnChange = function(_, value)
					net.Start("TTT2SESaveItem")
					net.WriteString(equipment.id)
					net.WriteUInt(1, ShopEditor.savingKeysBitCount or 16)
					net.WriteString(key)
					net.WriteBool(Invert(data, tobool(value)))
					net.SendToServer()
				end,
				master = data.master and masterRefs[data.master]
			})
		elseif data.typ == "number" then
			if data.subtype == "enum" then
				option = form:MakeComboBox({
					label = name,
					default = TryT(data.lookupNamesFunc(equipment.defaultValues[key])),
					OnChange = function(_, _, _, enum)
						net.Start("TTT2SESaveItem")
						net.WriteString(equipment.id)
						net.WriteUInt(1, ShopEditor.savingKeysBitCount or 16)
						net.WriteString(key)
						net.WriteUInt(math.Round(enum), data.bits or 16)
						net.SendToServer()
					end,
					master = data.master and masterRefs[data.master]
				})

				local enum
				for i = 1, #data.choices do
					enum = data.choices[i]
					option:AddChoice(TryT(data.lookupNamesFunc(enum)), enum, equipment[key] == enum)
				end
			else
				option = form:MakeSlider({
					label = name,
					min = data.min,
					max = data.max,
					decimal = 0,
					default = equipment.defaultValues[key],
					initial = equipment[key],
					OnChange = function(_, value)
						net.Start("TTT2SESaveItem")
						net.WriteString(equipment.id)
						net.WriteUInt(1, ShopEditor.savingKeysBitCount or 16)
						net.WriteString(key)
						net.WriteUInt(math.Round(value), data.bits or 16)
						net.SendToServer()
					end,
					master = data.master and masterRefs[data.master]
				})
			end
		end

		masterRefs[key] = option
	end

	-- now add custom equipment settings
	equipment:AddToSettingsMenu(parent)
end
