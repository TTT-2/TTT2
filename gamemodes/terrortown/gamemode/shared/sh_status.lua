--ttt_include("sh_status")

if CLIENT then

    STATUS = {}
    STATUS.registered = {}
    STATUS.active = {}

    function STATUS:RegisterStatus(id, data)
        if STATUS.registered[id] ~= nil then return false end --name not unique

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
        STATUS.active[id].displaytime = duration
        timer.Create(id, duration, 1, function() self:RemoveStatus(id) end)
    end

    function STATUS:RemoveStatus(id)
        if STATUS.active[id] == nil then return end

        STATUS.active[id] = nil

        if timer.Exists(id) then
            timer.Remove(id)
        end
    end

    net.Receive('ttt2_status_effect_add', function(len)
        local id = net.ReadString()
        STATUS:AddStatus(id)
    end)

    net.Receive('ttt2_status_effect_add_timed', function(len)
        local id = net.ReadString()
        local duration = net.ReadUInt(32)
        STATUS:AddTimedStatus(id, duration)
    end)

    net.Receive('ttt2_status_effect_removed', function(len)
        local id = net.ReadString()
        STATUS:RemoveStatus(id)
    end)

end


if SERVER then

    --register networkt messages
    util.AddNetworkString('ttt2_status_effect_add')
    util.AddNetworkString('ttt2_status_effect_add_timed')
    util.AddNetworkString('ttt2_status_effect_remove')

    STATUS = {}

    function STATUS:AddStatus(ply, id)
        net.Start('ttt2_status_effect_add')
        net.WriteString(id)
        net.Send(ply)
    end

    function STATUS:AddTimedStatus(ply, id, duration)
        net.Start('ttt2_status_effect_add_timed')
        net.WriteString(id)
        net.WriteUInt(32)
        net.Send(ply)
    end

    function STATUS:RemoveStatus(ply, id)
        net.Start('ttt2_status_effect_remove')
        net.WriteString(id)
        net.Send(ply)
    end
    
end