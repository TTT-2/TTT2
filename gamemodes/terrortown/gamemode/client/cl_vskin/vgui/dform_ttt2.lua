
local PANEL = {}

DEFINE_BASECLASS("DCollapsibleCategoryTTT2")

AccessorFunc(PANEL, "m_bSizeToContents",	"AutoSize", FORCE_BOOL)
AccessorFunc(PANEL, "m_iSpacing",			"Spacing")
AccessorFunc(PANEL, "m_Padding",			"Padding")

function PANEL:Init()
	self.Items = {}

	self:SetSpacing(4)
	self:SetPadding(10)

	self:SetPaintBackground(true)

	self:SetMouseInputEnabled(true)
	self:SetKeyboardInputEnabled(true)
end

function PANEL:SetName(name)
	self:SetLabel(name)
end

function PANEL:Clear()
	for k, v in pairs(self.Items) do
		if IsValid(v) then
			v:Remove()
		end
	end

	self.Items = {}
end

function PANEL:AddItem(left, right, drawBackground)
	self:InvalidateLayout()

	local Panel = vgui.Create("DSizeToContents", self)

	Panel:SetSizeX(false)
	Panel:Dock(TOP)
	Panel:DockPadding(10, 10, 10, 0)
	Panel:InvalidateLayout()

	if IsValid(right) then
		left:SetParent(Panel)
		left:Dock(LEFT)
		left:InvalidateLayout(true)
		left:SetSize(312, 20)

		right:SetParent(Panel)
		right:SetPos(312, 0)
		right:InvalidateLayout(true)
	elseif IsValid(left) then
		left:SetParent(Panel)
		left:Dock(TOP)
	end

	if drawBackground then
		Panel:DockMargin(10, 10, 10, 10)

		Panel.Paint = function(slf, w, h)
			derma.SkinHook("Paint", "FormLabelTTT2", slf, w - 13, h)

			return true
		end
	end

	self.Items[#self.Items + 1] = Panel
end

function PANEL:TextEntry(strLabel, strConVar)
	local left = vgui.Create("DLabelTTT2", self)

	left:SetText(strLabel)
	left:SetDark(true)

	local right = vgui.Create("DTextEntry", self)

	right:SetConVar(strConVar)
	right:Dock(TOP)

	self:AddItem(left, right)

	return right, left
end

function PANEL:NumberWang(strLabel, strConVar, numMin, numMax, numDecimals)
	local left = vgui.Create("DLabelTTT2", self)

	left:SetText(strLabel)
	left:SetDark(true)

	local right = vgui.Create("DNumberWang", self)

	right:SetMinMax(numMin, numMax)

	if numDecimals ~= nil then
		right:SetDecimals(numDecimals)
	end

	right:SetConVar(strConVar)
	right:SizeToContents()

	self:AddItem(left, right)

	return right, left
end

function PANEL:ControlHelp(strHelp)
	local Panel = vgui.Create("DSizeToContents", self)

	Panel:SetSizeX(false)
	Panel:Dock(TOP)
	Panel:InvalidateLayout()

	local left = vgui.Create("DLabelTTT2", Panel)

	left:SetDark(true)
	left:SetWrap(true)
	left:SetTextInset(0, 0)
	left:SetText(strHelp)
	left:SetContentAlignment(5)
	left:SetAutoStretchVertical(true)
	left:DockMargin(32, 0, 32, 8)
	left:Dock(TOP)
	left:SetTextColor(self:GetSkin().Colours.Tree.Hover)

	self.Items[#self.Items + 1] = Panel

	return left
end

--[[---------------------------------------------------------
	Note: If you're running a console command like "maxplayers 10" you
	need to add the "10" to the arguments, like so
	Button("LabelName", "maxplayers", "10")
-----------------------------------------------------------]]
function PANEL:Button(strName, strConCommand, ...)
	local left = vgui.Create("DButton", self)

	if strConCommand then
		left:SetConsoleCommand(strConCommand, ...)
	end

	left:SetText(strName)
	self:AddItem(left, nil)

	return left
end

function PANEL:PanelSelect()
	local left = vgui.Create("DPanelSelect", self)

	self:AddItem(left, nil)

	return left
end

function PANEL:ListBox(strLabel)
	local left

	if strLabel then
		left = vgui.Create("DLabelTTT2", self)

		left:SetText(strLabel)
		left:SetDark(true)

		self:AddItem(left)
	end

	local right = vgui.Create("DListBox", self)
	right.Stretch = true

	self:AddItem(right)

	return right, left
end

function PANEL:Rebuild()

end

-- FUNCTIONS TO POPULATE THE FORM

---
-- Adds a checkbox to the form
-- @param table data The data for the checkbox
-- @return @{Panel} The created checkbox
-- @realm client
function PANEL:MakeCheckBox(data)
	local left = vgui.Create("DCheckBoxLabelTTT2", self)

	left:SetText(data.label)
	left:SetConVar(data.convar)

	left:SetTall(32)

	left:SetValue(data.initial)

	left.OnChange = function(slf, value)
		if isfunction(data.onChange) then
			data.onChange(slf, value)
		end
	end

	self:AddItem(left, nil)

	if IsValid(data.master) and isfunction(data.master.AddSlave) then
		data.master:AddSlave(left)
	end

	return left
end

---
-- Adds a slider to the form
-- @param table data The data for the slider
-- @return @{Panel} The created slider
-- @realm client
function PANEL:MakeSlider(data)
	local left = vgui.Create("DNumSliderTTT2", self)

	left:SetText(data.label)
	left:SetMinMax(data.min, data.max)

	if data.decimal ~= nil then
		left:SetDecimals(data.decimal)
	end

	left:SetConVar(data.convar)
	left:SizeToContents()

	left:SetValue(data.initial)

	left.OnValueChanged = function(slf, value)
		if isfunction(data.onValueChanged) then
			data.onValueChanged(slf, value)
		end
	end

	self:AddItem(left, nil)

	if IsValid(data.master) and isfunction(data.master.AddSlave) then
		data.master:AddSlave(left)
	end

	return left
end

---
-- Adds a combobox to the form
-- @param table data The data for the combobox
-- @return @{Panel}, @{Panel} The created combobox, The created label
-- @realm client
function PANEL:MakeComboBox(data)
	local left = vgui.Create("DLabelTTT2", self)

	left:SetText(data.label)

	local right = vgui.Create("DComboBoxTTT2", self)

	if data.choices then
		for i = 1, #data.choices do
			right:AddChoice(data.choices[i])
		end
	end

	if data.selectId then
		right:ChooseOptionId(data.selectId)
	elseif data.selectName then
		right:ChooseOptionName(data.selectName)
	end

	right.OnSelect = function(slf, index, value, rawdata)
		if slf.m_strConVar then
			RunConsoleCommand(slf.m_strConVar, tostring(rawdata or value))
		end

		if isfunction(data.onSelect) then
			data.onSelect(slf, index, value, rawdata)
		end
	end

	right:SetConVar(data.convar)
	right:SetTall(32)
	right:Dock(TOP)

	left.Paint = function(slf, w, h)
		derma.SkinHook("Paint", "FormLabelTTT2", slf, w, h)

		return true
	end

	self:AddItem(left, right)

	if IsValid(data.master) and isfunction(data.master.AddSlave) then
		data.master:AddSlave(left)
		data.master:AddSlave(right)
	end

	return right, left
end

---
-- Adds a helpbox to the form
-- @param table data The data for the helpbox
-- @return @{Panel} The created helpbox
-- @realm client
function PANEL:MakeHelp(data)
	local left = vgui.Create("DLabelTTT2", self)

	left:SetText(data.label)
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
		local textTranslated = LANG.TryTranslation(slf:GetText())

		local textWrapped = draw.GetWrappedText(
			textTranslated,
			w - 2 * slf.paddingX,
			slf:GetFont()
		)
		local _, heightText = draw.GetTextSize(textTranslated, slf:GetFont())

		slf:SetSize(w, heightText * #textWrapped + 2 * slf.paddingY)
	end

	self:AddItem(left, nil)

	left:InvalidateLayout(true)

	return left
end

-- Adds a colormixer to the form
-- @param table data The data for the colormixer
-- @return @{Panel}, @{Panel} The created colormixer, The created label
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
		if isfunction(data.onChange) then
			data.onChange(slf, color)
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

derma.DefineControl("DFormTTT2", "", PANEL, "DCollapsibleCategoryTTT2")

-- SIMPLE WRAPPER FUNCTION

---
-- Creates a collapsable form used for menu sections
-- @param @{Panel} parent The parent panel
-- @param string name The name of the collapsable form,
-- can be a language identifier
-- @realm client
function CreateForm(parent, name)
	local form = vgui.Create("DFormTTT2", parent)

	form:SetName(name)
	form:Dock(TOP)

	return form
end
