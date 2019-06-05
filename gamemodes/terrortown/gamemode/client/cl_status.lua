STATUS = {}
STATUS.registered = {}
STATUS.active = {}

function STATUS:RegisterStatus(id, data)
    if STATUS.registered[id] ~= nil then  -- name is not unique
		return false
	end

    STATUS.registered[id] = data

    return true
end

function STATUS:AddStatus(id)
    if STATUS.registered[id] == nil then return end

    STATUS.active[id] = table.Copy(STATUS.registered[id])
end

function STATUS:AddTimedStatus(id, duration)
    if STATUS.registered[id] == nil then return end

    self:AddStatus(id)

    STATUS.active[id].displaytime = CurTime() + duration

    timer.Create(id, duration, 1, function()
		self:RemoveStatus(id)
	end)
end

function STATUS:RemoveStatus(id)
    if STATUS.active[id] == nil then return end

    STATUS.active[id] = nil

    if timer.Exists(id) then
        timer.Remove(id)
    end
end

net.Receive("ttt2_status_effect_add", function()
    STATUS:AddStatus(net.ReadString())
end)

net.Receive("ttt2_status_effect_add_timed", function()
    STATUS:AddTimedStatus(net.ReadString(), net.ReadUInt(32))
end)

net.Receive("ttt2_status_effect_removed", function()
    STATUS:RemoveStatus(net.ReadString())
end)

net.Receive("ttt2_status_effect_removed_all", function()
    for i in pairs(STATUS.active) do
        STATUS:RemoveStatus(i)
    end
end)
