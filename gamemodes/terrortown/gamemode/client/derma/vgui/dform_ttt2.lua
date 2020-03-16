
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

function PANEL:ComboBox(strLabel, strConVar)
	local left = vgui.Create("DLabelTTT2", self)

	left:SetText(strLabel)
	left:SetDark(true)

	local right = vgui.Create("DComboBoxTTT2", self)

	right:SetConVar(strConVar)
	right:SetTall(32)
	right:Dock(TOP)

	function right:OnSelect(index, value, data)
		if not self.m_strConVar then return end

		RunConsoleCommand(self.m_strConVar, tostring(data or value))
	end

	left.Paint = function(slf, w, h)
		derma.SkinHook("Paint", "FormLabelTTT2", slf, w, h)

		return true
	end

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

function PANEL:NumSlider(strLabel, strConVar, numMin, numMax, numDecimals)
	local left = vgui.Create("DNumSlider", self)

	left:SetText(strLabel)
	left:SetMinMax(numMin, numMax)

	if numDecimals ~= nil then
		left:SetDecimals(numDecimals)
	end

	left:SetConVar(strConVar)
	left:SizeToContents()

	left.TextArea.Paint = function(slf, w, h)
		derma.SkinHook("Paint", "SliderTextAreaTTT2", slf, w, h)

		return true
	end

	left.Label.Paint = function(slf, w, h)
		derma.SkinHook("Paint", "FormLabelTTT2", slf, w, h)

		return true
	end

	left.SetDisabled = function(slf, bDisabled)
		slf.m_bDisabled = bDisabled

		if bDisabled then
			slf:SetAlpha(50)
			slf:SetMouseInputEnabled(false)
		else
			slf:SetAlpha(255)
			slf:SetMouseInputEnabled(true)
		end
	end

	left.TextArea:SetFont("DermaTTT2Text")
	left.Label:SetFont("DermaTTT2Text")

	self:AddItem(left, nil)

	return left
end

function PANEL:ColorMixer(strLabel, defaultColor, showAlphaBar, showPalette)
	local left = vgui.Create("DLabelTTT2", self)

	left:SetText(strLabel)
	left:SetDark(true)

	local right = vgui.Create("DColorMixer", self)

	right:SetColor(defaultColor or COLOR_WHITE)
	right:SetAlphaBar(showAlphaBar or false)
	right:SetPalette(showPalette or false)
	right:SetTall(200)
	right:DockMargin(10, 10, 10, 10)

	right.PerformLayout = function(slf, w, h)
		local parentW = slf:GetParent():GetSize()
		local _, _, parentPadRight = slf:GetParent():GetDockPadding()
		local posX = slf:GetPos()

		slf:SetWide(parentW - parentPadRight - posX)
	end

	self:AddItem(left, right)

	return right, left
end

function PANEL:CheckBox(strLabel, strConVar)
	local left = vgui.Create("DCheckBoxLabelTTT2", self)

	left:SetText(strLabel)
	left:SetConVar(strConVar)

	left:SetTall(32)

	self:AddItem(left, nil)

	return left
end

function PANEL:Help(strHelp)
	local left = vgui.Create("DLabelTTT2", self)

	left:SetText(strHelp)
	left:SetContentAlignment(7)
	left:SetAutoStretchVertical(true)

	left.paddingX = 10
	left.paddingY = 5

	left.Paint = function(slf, w, h)
		derma.SkinHook("Paint", "HelpLabelTTT2", slf, w, h)

		return true
	end

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
	if strLabel then
		local left = vgui.Create("DLabelTTT2", self)

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

-- No example for this control
function PANEL:GenerateExample(class, tabs, w, h)

end

derma.DefineControl("DFormTTT2", "", PANEL, "DCollapsibleCategoryTTT2")
