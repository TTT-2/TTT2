---
-- @class PANEL
-- @section DFormTTT2

local PANEL = {}

DEFINE_BASECLASS("DCollapsibleCategoryTTT2")

---
-- @accessor boolean
-- @realm client
AccessorFunc(PANEL, "m_bSizeToContents", "AutoSize", FORCE_BOOL)

---
-- @accessor number
-- @realm client
AccessorFunc(PANEL, "m_iSpacing", "Spacing")

---
-- @accessor number
-- @realm client
AccessorFunc(PANEL, "m_Padding", "Padding")

local materialReset = Material("vgui/ttt/vskin/icon_reset")
local materialDisable = Material("vgui/ttt/vskin/icon_disable")

---
-- @ignore
function PANEL:Init()
	self.items = {}

	self:SetSpacing(4)
	self:SetPadding(10)

	self:SetPaintBackground(true)

	self:SetMouseInputEnabled(true)
	self:SetKeyboardInputEnabled(true)
end

---
-- @param string name
-- @realm client
function PANEL:SetName(name)
	self:SetLabel(name)
end

---
-- @realm client
function PANEL:Clear()
	for i = 1, #self.items do
		local item = self.items[i]

		if not IsValid(item) then continue end

		item:Remove()
	end

	self.items = {}
end

---
-- @param Panel left
-- @param Panel right
-- @param Panel reset
-- @realm client
function PANEL:AddItem(left, right, reset)
	self:InvalidateLayout()

	local panel = vgui.Create("DSizeToContents", self)

	panel:SetSizeX(false)
	panel:Dock(TOP)
	panel:DockPadding(10, 10, 10, 0)
	panel:InvalidateLayout()

	if IsValid(reset) then
		reset:SetParent(panel)
		reset:Dock(RIGHT)
	end

	if IsValid(right) then
		left:SetParent(panel)
		left:Dock(LEFT)
		left:InvalidateLayout(true)
		left:SetSize(350, 20)

		right:SetParent(panel)
		right:SetPos(350, 0)
		right:InvalidateLayout(true)
	elseif IsValid(left) then
		left:SetParent(panel)
		left:Dock(TOP)
	end

	self.items[#self.items + 1] = panel
end

---
-- overwrites the base function with an empty function
-- @realm client
function PANEL:Rebuild()

end

-- FUNCTIONS TO POPULATE THE FORM

local function MakeReset(parent)
	local reset = vgui.Create("DButtonTTT2", parent)

	reset:SetText("button_default")
	reset:SetSize(32, 32)

	reset.Paint = function(slf, w, h)
		derma.SkinHook("Paint", "FormButtonIconTTT2", slf, w, h)

		return true
	end

	reset.material = materialReset

	return reset
end

---
-- Adds a checkbox to the form
-- @param table data The data for the checkbox
-- @return Panel The created checkbox
-- @realm client
function PANEL:MakeCheckBox(data)
	local left = vgui.Create("DCheckBoxLabelTTT2", self)

	local reset = MakeReset(self)
	left:SetResetButton(reset)

	left:SetText(data.label)
	left:SetParams(data.params)

	-- Set default if possible even if the convar could still overwrite it
	left:SetDefaultValue(data.default)
	left:SetConVar(data.convar)
	left:SetServerConVar(data.serverConvar)

	left:SetTall(32)

	if not data.convar and not data.serverConvar and data.initial then
		left:SetValue(data.initial)
	end

	left.OnValueChanged = function(slf, value)
		if isfunction(data.OnChange) then
			data.OnChange(slf, value)
		end
	end


	self:AddItem(left, nil, reset)

	if IsValid(data.master) and isfunction(data.master.AddSlave) then
		data.master:AddSlave(left)
		data.master:AddSlave(reset)
	end

	return left
end

---
-- Adds a slider to the form
-- @param table data The data for the slider
-- @return Panel The created slider
-- @realm client
function PANEL:MakeSlider(data)
	local left = vgui.Create("DLabelTTT2", self)

	left:SetText(data.label)

	left.Paint = function(slf, w, h)
		derma.SkinHook("Paint", "FormLabelTTT2", slf, w, h)

		return true
	end

	local right = vgui.Create("DNumSliderTTT2", self)

	local reset = MakeReset(self)
	right:SetResetButton(reset)

	right:SetMinMax(data.min, data.max)

	if data.decimal ~= nil then
		right:SetDecimals(data.decimal)
	end

	-- Set default if possible even if the convar could still overwrite it
	right:SetDefaultValue(data.default)
	right:SetConVar(data.convar)
	right:SetServerConVar(data.serverConvar)
	right:SizeToContents()

	if not data.convar and not data.serverConvar and data.initial then
		right:SetValue(data.initial)
	end

	right.OnValueChanged = function(slf, value)
		if isfunction(data.OnChange) then
			data.OnChange(slf, value)
		end
	end

	right:SetTall(32)
	right:Dock(TOP)


	self:AddItem(left, right, reset)

	if IsValid(data.master) and isfunction(data.master.AddSlave) then
		data.master:AddSlave(left)
		data.master:AddSlave(right)
		data.master:AddSlave(reset)
	end

	return left
end

---
-- Adds a combobox to the form
-- @param table data The data for the combobox
-- @note Structure of data = {
-- label, default, choices = { [1] = {title, value, select, icon, additionalData}, [2] = ...},
-- conVar, serverConVar, selectId or selectTitle or selectValue,
-- function OnChange(value, additionalData, dropDownPanel), master = { function AddSlave(self, slave) }
-- }
-- @note If ConVars are used the values are always strings, so make sure, that you used strings for values, when setting up choices
-- @return Panel The created combobox
-- @return Panel The created label
-- @realm client
function PANEL:MakeComboBox(data)
	local left = vgui.Create("DLabelTTT2", self)

	left:SetText(data.label)

	left.Paint = function(slf, w, h)
		derma.SkinHook("Paint", "FormLabelTTT2", slf, w, h)

		return true
	end

	local right = vgui.Create("DComboBoxTTT2", self)

	local reset = MakeReset(self)
	right:SetResetButton(reset)
	right:SetDefaultValue(data.default) -- Set default if possible even if the convar could still overwrite it

	if data.choices then
		for i = 1, #data.choices do
			local choice = data.choices[i]

			if istable(choice) then
				right:AddChoice(choice.title, choice.value, choice.select, choice.icon, choice.data)
			else
				-- Support old simple structure
				right:AddChoice(choice, choice)
			end
		end
	end

	local conVar = data.convar or data.conVar
	right:SetConVar(conVar)

	local serverConVar = data.serverConvar or data.serverConVar
	right:SetServerConVar(serverConVar)

	-- Only choose an option, if no conVars are set
	if not isstring(conVar) and not isstring(serverConVar) then
		if data.selectId then
			right:ChooseOptionId(data.selectId, true)
		elseif data.selectName or data.selectTitle then
			right:ChooseOptionName(data.selectName or data.selectTitle, true)
		elseif data.selectValue then
			right:ChooseOptionValue(data.selectValue, true)
		end
	end

	right.OnSelect = function(slf, index, value, additionalData)
		if data and isfunction(data.OnChange) then
			data.OnChange(value, additionalData, slf)
		end
	end

	right:SetTall(32)
	right:Dock(TOP)

	self:AddItem(left, right, reset)

	if IsValid(data.master) and isfunction(data.master.AddSlave) then
		data.master:AddSlave(left)
		data.master:AddSlave(right)
		data.master:AddSlave(reset)
	end

	return right, left
end

---
-- Adds a binder to the form
-- @param table data The data for the binder
-- @return Panel The created binder
-- @return Panel The created label
-- @realm client
function PANEL:MakeBinder(data)
	local left = vgui.Create("DLabelTTT2", self)

	left:SetText(data.label)

	left.Paint = function(slf, w, h)
		derma.SkinHook("Paint", "FormLabelTTT2", slf, w, h)

		return true
	end

	local right = vgui.Create("DBinderPanelTTT2", self)

	right.binder:SetValue(data.select)

	right.binder.OnChange = function(slf, keyNum)
		if isfunction(data.OnChange) then
			data.OnChange(slf, keyNum)
		end
	end

	right.disable.DoClick = function(slf)
		if isfunction(data.OnDisable) then
			data.OnDisable(slf, right.binder)
		end
	end

	right.disable.material = materialDisable

	right:SetTall(32)
	right:Dock(TOP)

	local reset = MakeReset(self)

	if data.default ~= nil then
		reset.DoClick = function(slf)
			right.binder:SetValue(data.default)
		end
	else
		reset.noDefault = true
	end

	self:AddItem(left, right, reset)

	if IsValid(data.master) and isfunction(data.master.AddSlave) then
		data.master:AddSlave(left)
		data.master:AddSlave(right)
		data.master:AddSlave(reset)
	end

	return right, left
end

---
-- Adds a helpbox to the form
-- @param table data The data for the helpbox
-- @return Panel The created helpbox
-- @realm client
function PANEL:MakeHelp(data)
	local left = vgui.Create("DLabelTTT2", self)

	left:SetText(data.label)
	left:SetParams(data.params)
	left:SetContentAlignment(7)
	left:SetAutoStretchVertical(true)

	left.paddingX = 10
	left.paddingY = 5

	left.Paint = function(slf, w, h)
		derma.SkinHook("Paint", "HelpLabelTTT2", slf, w, h)

		return true
	end

	-- make sure the height is based on the amount of text inside
	left.PerformLayout = function(slf, w, h)
		local textTranslated = LANG.GetParamTranslation(slf:GetText(), LANG.TryTranslation(slf:GetParams()))

		local textWrapped = draw.GetWrappedText(
			textTranslated,
			w - 2 * slf.paddingX,
			slf:GetFont()
		)
		local _, heightText = draw.GetTextSize("", slf:GetFont())

		slf:SetSize(w, heightText * #textWrapped + 2 * slf.paddingY)
	end

	self:AddItem(left, nil)

	left:InvalidateLayout(true)

	return left
end

-- Adds a colormixer to the form
-- @param table data The data for the colormixer
-- @return Panel The created colormixer
-- @return Panel The created label
-- @realm client
function PANEL:MakeColorMixer(data)
	local left = vgui.Create("DLabelTTT2", self)
	local right = vgui.Create("DPanel", self)

	left:SetTall(data.height or 240)
	right:SetTall(data.height or 240)

	right:Dock(TOP)
	right:DockPadding(10, 10, 10, 10)

	left:SetText(data.label)

	local colorMixer = vgui.Create("DColorMixer", right)

	colorMixer:SetColor(data.initial or COLOR_WHITE)
	colorMixer:SetAlphaBar(data.showAlphaBar or false)
	colorMixer:SetPalette(data.showPalette or false)
	colorMixer:Dock(FILL)

	colorMixer.ValueChanged = function(slf, color)
		if isfunction(data.OnChange) then
			data.OnChange(slf, color)
		end
	end

	left.Paint = function(slf, w, h)
		derma.SkinHook("Paint", "FormLabelTTT2", slf, w, h)

		return true
	end

	right.Paint = function(slf, w, h)
		derma.SkinHook("Paint", "FormBoxTTT2", slf, w, h)

		return true
	end

	right.SetEnabled = function(slf, enabled)
		slf.m_bDisabled = not enabled

		if enabled then
			slf:SetMouseInputEnabled(true)
		else
			slf:SetMouseInputEnabled(false)
		end

		-- update colormixer as well
		colorMixer:SetDisabled(not enabled)
	end

	self:AddItem(left, right)

	if IsValid(data.master) and isfunction(data.master.AddSlave) then
		data.master:AddSlave(left)
		data.master:AddSlave(right)
	end

	return right, left
end

-- Adds a panel to the form
-- @return Panel The created panel
-- @realm client
function PANEL:MakePanel()
	local panel = vgui.Create("DPanelTTT2", self)

	self:AddItem(panel)

	return panel
end

---
-- Adds a new card to the form.
-- @param table data The data for the card
-- @param PANEL base The base Panel (DIconLayout) where this card will be added
-- @return Panel The created card
-- @realm client
function PANEL:MakeCard(data, base)
	local card = base:Add("DCardTTT2")

	card:SetSize(238, 78)
	card:SetIcon(data.icon)
	card:SetText(data.label)
	card:SetMode(data.initial)

	card.OnModeChanged = function(slf, oldMode, newMode)
		if data and isfunction(data.OnChange) then
			data.OnChange(slf, oldMode, newMode)
		end
	end

	return card
end

---
-- Adds a new image check box to the form.
-- @param table data The data for the image check box
-- @param PANEL base The base Panel (DIconLayout) where this image check box will be added
-- @return Panel The created image check box
-- @realm client
function PANEL:MakeImageCheckBox(data, base)
	local box = base:Add("DImageCheckBoxTTT2")

	box:SetSize(238, 175)
	box:SetModel(data.model)
	box:SetHeadBox(data.headbox or false)
	box:SetText(data.label)

	if isfunction(data.OnModelSelected) then
		box.OnModelSelected = function(slf, userTriggered, state)
			if not userTriggered then return end

			data.OnModelSelected(slf, state)
		end
	end

	if isfunction(data.OnModelHattable) then
		box.OnModelHattable = function(slf, userTriggered, state)
			if not userTriggered then return end

			data.OnModelHattable(slf, state)
		end
	end

	return box
end

-- Adds an icon layout to the form
-- @param[default=10] number spacing The spacing between the elements
-- @return Panel The created panel
-- @realm client
function PANEL:MakeIconLayout(spacing)
	local panel = vgui.Create("DIconLayout", self)

	panel:SetSpaceY(spacing or 10)
	panel:SetSpaceX(spacing or 10)

	self:AddItem(panel)

	return panel
end

derma.DefineControl("DFormTTT2", "", PANEL, "DCollapsibleCategoryTTT2")

-- SIMPLE WRAPPER FUNCTION

---
-- Creates a collapsable form used for menu sections
-- @param Panel parent The parent panel
-- @param string name The name of the collapsable form,
-- can be a language identifier
-- @return Panel The created collapsable form
-- @realm client
function vgui.CreateTTT2Form(parent, name)
	local form = vgui.Create("DFormTTT2", parent)

	form:SetName(name)
	form:Dock(TOP)

	return form
end
