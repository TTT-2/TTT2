
local PANEL = {}

Derma_Hook(PANEL, "Paint", "Paint", "ComboBoxTTT2")

Derma_Install_Convar_Functions(PANEL)

AccessorFunc(PANEL, "m_bDoSort", "SortItems", FORCE_BOOL)

function PANEL:Init()
	self.DropButton = vgui.Create("DPanel", self)
	self.DropButton:SetMouseInputEnabled(false)
	self.DropButton.ComboBox = self

	self.DropButton.Paint = function(panel, w, h)
		derma.SkinHook("Paint", "ComboDownArrow", panel, w, h)
	end

	self:SetTall(22)
	self:Clear()

	self:SetContentAlignment(4)
	self:SetTextInset(8, 0)
	self:SetIsMenu(true)
	self:SetSortItems(true)

	self:SetFont("DermaTTT2Text")
end

function PANEL:Clear()
	self:SetText("")
	self.Choices = {}
	self.Data = {}
	self.ChoiceIcons = {}
	self.selected = nil

	if self.Menu then
		self.Menu:Remove()
		self.Menu = nil
	end
end

function PANEL:GetOptionText(id)
	return self.Choices[id]
end

function PANEL:GetOptionId(name)
	return table.KeyFromValue(self.Choices, name) or 1
end

function PANEL:GetOptionData(id)
	return self.Data[id]
end

function PANEL:GetOptionTextByData(data)
	for id, dat in pairs(self.Data) do
		if dat ~= data then continue end

		return self:GetOptionText(id)
	end

	-- Try interpreting it as a number
	for id, dat in pairs(self.Data) do
		if dat ~= tonumber(data) then continue end

		return self:GetOptionText(id)
	end

	-- In case we fail
	return data
end

function PANEL:PerformLayout()
	self.DropButton:SetSize(15, 15)
	self.DropButton:AlignRight(4)
	self.DropButton:CenterVertical()
end

function PANEL:ChooseOption(value, index)
	if self.Menu then
		self.Menu:Remove()
		self.Menu = nil
	end

	self:SetText(value)

	-- This should really be the here, but it is too late now and
	-- convar changes are handled differently by different child
	-- elements
	-- self:ConVarChanged(self.Data[index])
	self.selected = index
	self:OnSelect(index, value, self.Data[index])
end

function PANEL:ChooseOptionId(index)
	local name = self:GetOptionText(index)

	self:ChooseOption(name, index)
end

function PANEL:ChooseOptionName(name)
	local index = self:GetOptionId(name)

	self:ChooseOption(name, index)
end

function PANEL:GetSelectedId()
	return self.selected
end

function PANEL:GetSelected()
	if not self.selected then return end

	return self:GetOptionText(self.selected), self:GetOptionData(self.selected)
end

function PANEL:OnSelect(index, value, data)

end

function PANEL:AddChoice(value, data, select, icon)
	local i = table.insert(self.Choices, value)

	if data then
		self.Data[i] = data
	end

	if icon then
		self.ChoiceIcons[i] = icon
	end

	if select then
		self:ChooseOption(value, i)
	end

	return i
end

function PANEL:IsMenuOpen()
	return IsValid(self.Menu) and self.Menu:IsVisible()
end

function PANEL:OpenMenu(pControlOpener)
	if pControlOpener and pControlOpener == self.TextEntry then
		return
	end

	-- Don't do anything if there aren't any options..
	if #self.Choices == 0 then return end

	-- If the menu still exists and hasn't been deleted
	-- then just close it and don't open a new one.
	if IsValid(self.Menu) then
		self.Menu:Remove()
		self.Menu = nil
	end

	self.Menu = DermaMenu(false, self)

	if self:GetSortItems() then
		local sorted = {}

		for k, v in pairs(self.Choices) do
			local val = tostring(v) --tonumber(v) || v -- This would make nicer number sorting, but SortedPairsByMemberValue doesn't seem to like number-string mixing
			if string.len(val) > 1 and not tonumber(val) and val:StartWith("#") then
				val = language.GetPhrase(val:sub(2))
			end

			table.insert(sorted, {id = k, data = v, label = val})
		end

		for k, v in SortedPairsByMemberValue(sorted, "label") do
			local option = self.Menu:AddOption(v.data, function()
				self:ChooseOption(v.data, v.id)
			end)

			if self.ChoiceIcons[v.id] then
				option:SetIcon(self.ChoiceIcons[v.id])
			end
		end
	else
		for k, v in pairs(self.Choices) do
			local option = self.Menu:AddOption(v, function()
				self:ChooseOption(v, k)
			end)

			if self.ChoiceIcons[k] then
				option:SetIcon(self.ChoiceIcons[k])
			end
		end
	end

	local x, y = self:LocalToScreen(0, self:GetTall())

	self.Menu:SetMinimumWidth(self:GetWide())
	self.Menu:Open(x, y, false, self)
end

function PANEL:CloseMenu()
	if not IsValid(self.Menu) then return end

	self.Menu:Remove()
end

-- This really should use a convar change hook
function PANEL:CheckConVarChanges()
	if not self.m_strConVar then return end

	local strValue = GetConVar(self.m_strConVar):GetString()

	if self.m_strConVarValue == strValue then return end

	self.m_strConVarValue = strValue

	self:SetValue(self:GetOptionTextByData(self.m_strConVarValue))
end

function PANEL:Think()
	self:CheckConVarChanges()
end

function PANEL:SetValue(strValue)
	self:SetText(strValue)
end

function PANEL:DoClick()
	if self:IsMenuOpen() then
		return self:CloseMenu()
	end

	self:OpenMenu()
end

derma.DefineControl("DComboBoxTTT2", "", PANEL, "DButtonTTT2")
