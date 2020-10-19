
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
	self.choices = {}
	self.data = {}
	self.choiceIcons = {}
	self.selected = nil

	if self.menu then
		self.menu:Remove()
		self.menu = nil
	end
end

function PANEL:GetOptionText(id)
	return self.choices[id]
end

function PANEL:GetOptionId(name)
	return table.KeyFromValue(self.choices, name) or 1
end

function PANEL:GetOptionData(id)
	return self.data[id]
end

function PANEL:GetOptionTextByData(data)
	for id, dat in pairs(self.data) do
		if dat ~= data and dat ~= tonumber(data) then continue end

		return self:GetOptionText(id)
	end

	return data
end

function PANEL:PerformLayout()
	self.DropButton:SetSize(15, 15)
	self.DropButton:AlignRight(4)
	self.DropButton:CenterVertical()
end

function PANEL:ChooseOption(value, index)
	if self.menu then
		self.menu:Remove()
		self.menu = nil
	end

	self:SetText(value)

	self.selected = index
	self:OnSelect(index, value, self.data[index])
end

function PANEL:ChooseOptionId(index)
	self:ChooseOption(self:GetOptionText(index), index)
end

function PANEL:ChooseOptionName(name)
	self:ChooseOption(name, self:GetOptionId(name))
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
	local i = #self.choices + 1

	self.choices[i] = value

	if data then
		self.data[i] = data
	end

	if icon then
		self.choiceIcons[i] = icon
	end

	if select then
		self:ChooseOption(value, i)
	end

	return i
end

function PANEL:IsMenuOpen()
	return IsValid(self.menu) and self.menu:IsVisible()
end

function PANEL:OpenMenu(pControlOpener)
	if pControlOpener and pControlOpener == self.TextEntry then return end

	-- Don't do anything if there aren't any options..
	if #self.choices == 0 then return end

	-- If the menu still exists and hasn't been deleted
	-- then just close it and don't open a new one.
	if self.menu then
		self.menu:Remove()
		self.menu = nil
	end

	self.menu = DermaMenu(false, self)

	if self:GetSortItems() then
		local sorted = {}

		for i = 1, #self.choices do
			local choice = self.choices[i]
			local val = tostring(choice)

			if string.len(val) > 1 and val:StartWith("#") then
				val = language.GetPhrase(val:sub(2))
			end

			sorted[#sorted + 1] = {
				id = i,
				data = choice,
				label = val
			}
		end

		for k, v in SortedPairsByMemberValue(sorted, "label") do
			local option = self.menu:AddOption(v.data, function()
				self:ChooseOption(v.data, v.id)
			end)

			if self.choiceIcons[v.id] then
				option:SetIcon(self.choiceIcons[v.id])
			end
		end
	else
		for i = 1, #self.choices do
			local choice = self.choices[i]
			local option = self.menu:AddOption(choice, function()
				self:ChooseOption(choice, i)
			end)

			if self.choiceIcons[i] then
				option:SetIcon(self.choiceIcons[i])
			end
		end
	end

	local x, y = self:LocalToScreen(0, self:GetTall())

	self.menu:SetMinimumWidth(self:GetWide())
	self.menu:Open(x, y, false, self)
end

function PANEL:CloseMenu()
	if not IsValid(self.menu) then return end

	self.menu:Remove()
end

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
