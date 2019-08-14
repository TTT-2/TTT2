STATUS = {}
STATUS.registered = {}
STATUS.active = {}

function STATUS:RegisterStatus(id, data)
    if STATUS.registered[id] ~= nil then  -- name is not unique
		return false
    end
    
    -- support single and multible icons per status effect
    if data.hud.GetTexture then
        data.hud = {data.hud}
    end

    STATUS.registered[id] = data

    return true
end

function STATUS:AddStatus(id, active_icon)
    if STATUS.registered[id] == nil then return end

    STATUS.active[id] = table.Copy(STATUS.registered[id])
    self:SetActiveIcon(id, active_icon or 1)
end

function STATUS:AddTimedStatus(id, duration, showDuration, active_icon)
    if STATUS.registered[id] == nil then return end

    self:AddStatus(id, active_icon)

    STATUS.active[id].displaytime = CurTime() + duration

    timer.Create(id, duration, 1, function()
		self:RemoveStatus(id)
    end)
    
    if showDuration then
        STATUS.active[id].DrawInfo = function(self) return tostring(math.Round(math.max(0, self.displaytime - CurTime()))) end
    end
end

function STATUS:SetActiveIcon(id, active_icon)
    if STATUS.active[id] == nil then return end

    local max_amount = (self.registered[id].hud.GetTexture) and 1 or #STATUS.registered[id].hud

    if active_icon < 1 or active_icon > max_amount then
        active_icon = 1
    end

    STATUS.active[id].active_icon = active_icon
end

function STATUS:Registered(id)
    return (STATUS.registered[id] ~= nil) and true or false
end

function STATUS:Active(id)
    return (STATUS.active[id] ~= nil) and true or false
end

function STATUS:RemoveStatus(id)
    if STATUS.active[id] == nil then return end

    STATUS.active[id] = nil

    if timer.Exists(id) then
        timer.Remove(id)
    end
end

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
