---
-- @class ROLEINFO

ROLEINFO = ROLEINFO or {}
ROLEINFO.data = ROLEINFO.data or {}

function ROLEINFO:MakeSyncedEntry(conVarName, iconMaterial, textCallback)
    self.data[#ROLEINFO.data + 1] = {
        conVarName = conVarName,
        iconMaterial = iconMaterial,
        textCallback = textCallback
    }
end

function ROLEINFO:RequestFromServer()

end

function ROLEINFO:ReceiveFromServer(index, value)
    local settingsElement = self.data[index]

    if not settingsElement then return end

    settingsElement.value = value

    if not isfunction(settingsElement.textCallback) then return end

    settingsElement.text = settingsElement.textCallback(value)
end

---
-- @module roleinfo

function roleinfo.NewRoleInfo()
    return table.copy(ROLEINFO)
end
