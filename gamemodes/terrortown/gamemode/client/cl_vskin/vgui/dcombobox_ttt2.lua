---
-- @class PANEL
-- @section DComboBoxTTT2

local PANEL = {}

Derma_Hook(PANEL, "Paint", "Paint", "ComboBoxTTT2")

Derma_Install_Convar_Functions(PANEL)

---
-- @accessor boolean
-- @realm client
AccessorFunc(PANEL, "m_bDoSort", "SortItems", FORCE_BOOL)

---
-- @ignore
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

    self.choices = {}
    self.titleIndices = {}
    self.valueIndices = {}

    self.valueType = nil

    self.slaves = {}

    local value, _ = self:GetSelected()

    self:UpdateSlaves(value ~= nil)
end

---
-- @param Panel slave
-- @realm client
function PANEL:AddSlave(slave)
    if not IsValid(slave) then
        return
    end

    self.slaves[#self.slaves + 1] = slave

    local value, _ = self:GetSelected()

    slave:SetEnabled(value ~= nil)
end

---
-- @param boolean val
-- @realm client
function PANEL:UpdateSlaves(val)
    for i = 1, #self.slaves do
        self.slaves[i]:SetEnabled(val)
    end
end

---
-- @ignore
function PANEL:PerformLayout()
    self.DropButton:SetSize(15, 15)
    self.DropButton:AlignRight(4)
    self.DropButton:CenterVertical()
end

---
-- @realm client
function PANEL:Clear()
    self:SetText("")

    self.choices = {}
    self.titleIndices = {}
    self.valueIndices = {}
    self.selected = nil
    self.valueType = nil

    self:CloseMenu()
end

---
-- Stores the type of value that is currently used
-- @param any value the value to store the type of
-- @realm client
function PANEL:StoreValueType(value)
    -- Save value type of first entry for conversion
    if self.valueType == nil then
        self.valueType = type(value)
    end
end

---
-- Converts the value to the current used type
-- @param any value the value to convert to a string or number
-- @return any
-- @realm client
function PANEL:ConvertValue(value)
    if self.valueType == "string" then
        return tostring(value)
    elseif self.valueType == "number" then
        return tonumber(value)
    else
        return value
    end
end

---
-- Gets the displayed Text if one is set, otherwise the value like in the original DComboBox
-- @note this doesnt necessarily get the value used to set conVars, use `PANEL:GetOptionValue(index)` instead
-- @param number index the option id
-- @return string
-- @realm client
function PANEL:GetOptionText(index)
    local choice = self.choices[index]

    if not choice then
        return
    end

    return choice.title or choice.value
end

---
-- @param number index the option id
-- @return string|number a value that is indexable
-- @realm client
function PANEL:GetOptionValue(index)
    return self.choices[index].value
end

---
-- @param number index the option id
-- @return any
-- @realm client
function PANEL:GetOptionData(index)
    return self.choices[index].data
end

---
-- @param string|number value should be indexable
-- @return number
-- @realm client
function PANEL:GetOptionID(value)
    return self.valueIndices[self:ConvertValue(value)] or 1
end

---
-- @param string title
-- @return number
-- @realm client
function PANEL:GetOptionTitleID(title)
    return self.titleIndices[title] or 1
end

---
-- @param any data
-- @return any
-- @realm client
function PANEL:GetOptionTextByData(data)
    local choices = self.choices
    local choicesSize = #choices

    for index = 1, choicesSize do
        local choiceData = choices[index].data

        if choiceData ~= data and choiceData ~= tonumber(data) then
            continue
        end

        return self:GetOptionText(index)
    end

    return
end

---
-- @param string title
-- @param string|number value should be indexable
-- @param boolean select
-- @param string icon
-- @param any data additional data that you might want to use
-- @return number index
-- @realm client
function PANEL:AddChoice(title, value, select, icon, data)
    if istable(value) or isbool(value) then
        ErrorNoHaltWithStack(
            "[TTT2] dcombobox_ttt2 AddChoice format changed to PANEL:AddChoice(title, value, select, icon, data)\n For any table data use the last parameter.\n"
        )

        return
    end

    self:StoreValueType(value)
    value = self:ConvertValue(value)

    local index = #self.choices + 1

    self.choices[index] = {
        title = title,
        value = value,
        icon = icon,
        data = data,
    }

    -- Index tables for fast access
    self.titleIndices[title] = index
    self.valueIndices[value] = index

    if select then
        self:ChooseOptionID(index, true)
    end

    return index
end

---
-- @param number index the option id
-- @param[default=false] boolean ignoreCallbackEnabledVars To avoid endless loops, separated setting of convars and UI values
-- @realm client
function PANEL:ChooseOptionID(index, ignoreCallbackEnabledVars)
    local choices = self.choices

    if index > #choices then
        ErrorNoHaltWithStack("[TTT2] PANEL:ChooseOptionID failed, exceeding index size of choices.")

        return
    end

    local choice = choices[index]
    local value = self:ConvertValue(choice.value)

    self.selected = index

    self:SetText(choice.title)
    self:OnSelect(index, value, choice.data)

    self:UpdateSlaves(value ~= nil)

    self:CloseMenu()

    if ignoreCallbackEnabledVars then
        return
    end

    self:SetCallbackEnabledVarValues(value)
end

---
-- @note this chooses the the set value like in the original DComboBox
-- @param string|number value should be indexable e.g. the value used to set conVars
-- @param[default=false] boolean ignoreConVar To avoid endless loops, separated setting of convars and UI values
-- @realm client
function PANEL:ChooseOptionValue(value, ignoreConVar)
    self:ChooseOptionID(self:GetOptionID(value), ignoreConVar)
end

---
-- @note this chooses the displayed text rather than the set value like in the original DComboBox
-- So use `PANEL:ChooseOptionValue` for the old behaviour
-- @param string name the displayed text
-- @param[default=false] boolean ignoreConVar To avoid endless loops, separated setting of convars and UI values
-- @realm client
function PANEL:ChooseOptionName(name, ignoreConVar)
    self:ChooseOptionID(self:GetOptionTitleID(name), ignoreConVar)
end

---
-- Choose option by index, title is not settable
-- @param[opt] string title is unused as it cant be set anymore
-- @param number index the option id
-- @param[default=false] boolean ignoreConVar To avoid endless loops, separated setting of convars and UI values
-- @realm client
-- @deprecated Giving titles is not possible anymore. Use `PANEL:ChooseOptionID` instead
function PANEL:ChooseOption(title, index, ignoreConVar)
    self:ChooseOptionID(index, ignoreConVar)
end

---
-- @return number
-- @realm client
function PANEL:GetSelectedID()
    return self.selected
end

---
-- @note this returns the set value not the displayed text, like in the combobox
-- @warning the second return-argument is the additional data that is given not what was before the set value, which is now given in the first return argument
-- @return string the set value
-- @return any the additional data if given
-- @realm client
function PANEL:GetSelected()
    if not self.selected then
        return
    end

    return self:GetOptionValue(self.selected), self:GetOptionData(self.selected)
end

---
-- @param number index
-- @param string|number value is indexable
-- @param any data
-- @realm client
function PANEL:OnSelect(index, value, data) end

---
-- @return boolean
-- @realm client
function PANEL:DoClick()
    if self:IsMenuOpen() then
        self:CloseMenu()
    end

    self:OpenMenu()
end

---
-- @return boolean
-- @realm client
function PANEL:IsMenuOpen()
    return IsValid(self.menu) and self.menu:IsVisible()
end

---
-- @param Panel pControlOpener
-- @realm client
function PANEL:OpenMenu(pControlOpener)
    if pControlOpener and pControlOpener == self.TextEntry then
        return
    end

    -- Do a table Copy if you want to sort items
    local sortItems = self:GetSortItems()
    local choices = sortItems and table.Copy(self.choices) or self.choices
    local choicesSize = #choices

    -- Don't do anything if there aren't any options..
    if choicesSize == 0 then
        return
    end

    -- If the menu still exists and hasn't been deleted
    -- then just close it and open a new one.
    self:CloseMenu()

    self.menu = DermaMenu(false, self)

    if sortItems then
        -- Convert Gmod Strings
        for i = 1, choicesSize do
            local choice = choices[i]
            local title = choice.title

            if string.len(title) > 1 and title:StartWith("#") then
                title = language.GetPhrase(title:sub(2))
            end

            choice.title = title
        end

        -- Sort by title
        table.SortByMember(choices, "title", true)
    end

    for index = 1, choicesSize do
        local choice = choices[index]
        local option = self.menu:AddOption(choice.title, function()
            self:SetValue(choice.value, false)
        end)

        if choice.icon then
            option:SetIcon(choice.icon)
        end
    end

    local x, y = self:LocalToScreen(0, self:GetTall())

    self.menu:SetMinimumWidth(self:GetWide())
    self.menu:Open(x, y, false, self)
end

---
-- @realm client
function PANEL:CloseMenu()
    if IsValid(self.menu) then
        self.menu:Remove()
        self.menu = nil
    end
end

---
-- @warning this doesnt set the displayed text like before, but the value and selects an option
-- @param string|number value should be indexable
-- @param boolean ignoreConVar To avoid endless loops, separated setting of convars and UI values
-- @realm client
function PANEL:SetValue(value, ignoreConVar)
    self:ChooseOptionValue(value, ignoreConVar)
end

local callbackEnabledVarTracker = 0
---
-- @param Panel panel to set the value of
-- @param string conVar name of the convar
local function AddConVarChangeCallback(panel, conVar)
    callbackEnabledVarTracker = callbackEnabledVarTracker + 1
    local myIdentifierString = "TTT2ComboboxConVarChangeCallback"
        .. tostring(callbackEnabledVarTracker)

    local callback = function(conVarName, oldValue, newValue)
        if not IsValid(panel) then
            -- We need to remove the callback in a timer, because otherwise the ConVar change callback code
            -- will throw an error while looping over the callbacks.
            -- This happens, because the callback is removed from the same table that is iterated over.
            -- Thus, the table size changes while iterating over it and leads to a nil callback as the last entry.
            timer.Simple(0, function()
                cvars.RemoveChangeCallback(conVarName, myIdentifierString)
            end)

            return
        end

        panel:SetValue(newValue, true)
    end

    cvars.AddChangeCallback(conVar, callback, myIdentifierString)
end

---
-- @param string conVarName
-- @realm client
function PANEL:SetConVar(conVarName)
    if not ConVarExists(conVarName or "") then
        return
    end

    local conVar = GetConVar(conVarName)
    self.conVar = conVar

    self:SetValue(conVar:GetString(), true)
    self:SetDefaultValue(conVar:GetDefault())

    AddConVarChangeCallback(self, conVarName)
end

---
-- @param string conVarName
-- @realm client
function PANEL:SetServerConVar(conVarName)
    if not conVarName or conVarName == "" then
        return
    end

    self.serverConVar = conVarName

    cvars.ServerConVarGetValue(conVarName, function(wasSuccess, value, default)
        if wasSuccess and IsValid(self) then
            self:SetValue(value, true)
            self:SetDefaultValue(default)
        end
    end)

    AddConVarChangeCallback(self, conVarName)
end

---
-- @param table databaseInfo containing {name, itemName, key}
-- @realm client
function PANEL:SetDatabase(databaseInfo)
    if not istable(databaseInfo) then
        return
    end

    local name = databaseInfo.name
    local itemName = databaseInfo.itemName
    local key = databaseInfo.key

    if not name or not itemName or not key then
        return
    end

    self.databaseInfo = databaseInfo

    database.GetValue(name, itemName, key, function(databaseExists, value)
        if databaseExists then
            self:SetValue(value, true)
        end
    end)

    self:SetDefaultValue(database.GetDefaultValue(name, itemName, key))

    callbackEnabledVarTracker = callbackEnabledVarTracker + 1
    local myIdentifierString = "TTT2ComboboxDatabaseChangeCallback"
        .. tostring(callbackEnabledVarTracker)

    local function OnDatabaseChangeCallback(_name, _itemName, _key, oldValue, newValue)
        if not IsValid(self) then
            database.RemoveChangeCallback(name, itemName, key, myIdentifierString)

            return
        end

        self:SetValue(newValue, true)
    end

    database.AddChangeCallback(name, itemName, key, OnDatabaseChangeCallback, myIdentifierString)
end

---
-- @param string value
-- @realm client
function PANEL:SetCallbackEnabledVarValues(value)
    if self.conVar then
        self.conVar:SetString(tostring(value))
    end

    if self.serverConVar then
        cvars.ChangeServerConVar(self.serverConVar, tostring(value))
    end

    if self.databaseInfo then
        database.SetValue(
            self.databaseInfo.name,
            self.databaseInfo.itemName,
            self.databaseInfo.key,
            value
        )
    end
end

---
-- @param string|number value
-- @realm client
function PANEL:SetDefaultValue(value)
    local hasDefault = false

    if isstring(value) or isnumber(value) then
        self:StoreValueType(value)
        self.default = self:ConvertValue(value)
        hasDefault = true
    else
        self.default = nil
    end

    local reset = self:GetResetButton()

    if ispanel(reset) then
        reset.noDefault = not hasDefault
    end
end

---
-- @return number defaultValue
-- @realm client
function PANEL:GetDefaultValue()
    return self.default
end

---
-- @realm client
function PANEL:ResetToDefaultValue()
    local default = self:GetDefaultValue()

    if not default then
        return
    end

    self:SetValue(default, false)
end

---
-- @param Panel reset
-- @realm client
function PANEL:SetResetButton(reset)
    if not ispanel(reset) then
        return
    end

    self.resetButton = reset

    reset.DoClick = function(slf)
        self:ResetToDefaultValue()
    end

    reset.noDefault = self.default == nil
end

---
-- @return Panel reset
-- @realm client
function PANEL:GetResetButton()
    return self.resetButton
end

derma.DefineControl("DComboBoxTTT2", "", PANEL, "DButtonTTT2")
