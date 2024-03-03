---
-- @author Mineotopia
-- @class STATUS

STATUS = {}
STATUS.registered = {}
STATUS.active = {}

---
-- Registers a @{STATUS}
-- @param string id The index of the new status
-- @param table data
-- @return boolean whether the creation was successfully
-- @note structure of data = {Material|table hud, string type, string|table name, string sidebarDescription, function DrawInfo()}
-- Elements with the additional option of a table can be used to switch between different states
-- of a given status @{STATUS:SetActiveIcon}.
-- @realm client
function STATUS:RegisterStatus(id, data)
    if STATUS.registered[id] ~= nil then -- name is not unique
        return false
    end

    -- support single and multible icons per status effect
    if data.hud.GetTexture then
        data.hud = { data.hud }
    end

    STATUS.registered[id] = data

    return true
end

---
-- Adds a status to the currently active ones
-- @param string id The id of the registered @{STATUS}
-- @param[default=1] number active_icon The numeric id of a specific status icon
-- @realm client
function STATUS:AddStatus(id, active_icon)
    if STATUS.registered[id] == nil then
        return
    end

    STATUS.active[id] = table.Copy(STATUS.registered[id])

    self:SetActiveIcon(id, active_icon or 1)
end

---
-- Adds a timed status to the currently active ones
-- @param string id The id of the registered @{STATUS}
-- @param number duration The duration of the @{STATUS}. If the time elapsed,
-- the @{STATUS} will be removed automatically
-- @param[default=false] boolean showDuration Whether the duration should be shown
-- @param[default=1] number active_icon The numeric id of a specific status icon
-- @realm client
function STATUS:AddTimedStatus(id, duration, showDuration, active_icon)
    if self.registered[id] == nil or duration == 0 then
        return
    end

    self:AddStatus(id, active_icon)

    self.active[id].displaytime = CurTime() + duration

    timer.Create(id, duration, 1, function()
        if not self then
            return
        end

        self:RemoveStatus(id)
    end)

    if showDuration then
        self.active[id].DrawInfo = function(slf)
            return tostring(math.ceil(math.max(0, slf.displaytime - CurTime())))
        end
    end
end

---
-- Changes the active icon for a specifiv active effect for a given @{Player}
-- @param string id The id of the registered @{STATUS}
-- @param[default=1] number active_icon The numeric id of a specific status icon
-- @realm client
function STATUS:SetActiveIcon(id, active_icon)
    if STATUS.active[id] == nil then
        return
    end

    local max_amount = self.registered[id].hud.GetTexture and 1 or #STATUS.registered[id].hud

    if not active_icon or active_icon < 1 or active_icon > max_amount then
        active_icon = 1
    end

    STATUS.active[id].active_icon = active_icon
end

---
-- Checks if a @{STATUS} is registered
-- @param string id The index of the status
-- @return boolean Whether the status is registered
-- @realm client
function STATUS:Registered(id)
    return (STATUS.registered[id] ~= nil) and true or false
end

---
-- Checks if a @{STATUS} is active
-- @param string id The index of the status
-- @return boolean Whether the status is active
-- @realm client
function STATUS:Active(id)
    return (STATUS.active[id] ~= nil) and true or false
end

---
-- Removes a currently active status
-- @param string id The id of the registered @{STATUS}
-- @realm client
function STATUS:RemoveStatus(id)
    if STATUS.active[id] == nil then
        return
    end

    STATUS.active[id] = nil

    if timer.Exists(id) then
        timer.Remove(id)
    end
end

---
-- Clears the list of currently active @{STATUS}
-- @see STATUS:RemoveStatus
-- @realm client
function STATUS:RemoveAll()
    for i in pairs(STATUS.active) do
        STATUS:RemoveStatus(i)
    end
end

net.Receive("ttt2_status_effect_add", function()
    STATUS:AddStatus(net.ReadString(), net.ReadUInt(8))
end)

net.Receive("ttt2_status_effect_set_id", function()
    STATUS:SetActiveIcon(net.ReadString(), net.ReadUInt(8))
end)

net.Receive("ttt2_status_effect_add_timed", function()
    STATUS:AddTimedStatus(net.ReadString(), net.ReadUInt(32), net.ReadBool(), net.ReadUInt(8))
end)

net.Receive("ttt2_status_effect_remove", function()
    STATUS:RemoveStatus(net.ReadString())
end)

net.Receive("ttt2_status_effect_remove_all", function()
    STATUS:RemoveAll()
end)
