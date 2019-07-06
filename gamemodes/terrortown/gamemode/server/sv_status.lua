STATUS = {}

-- register networkt messages
util.AddNetworkString("ttt2_status_effect_add")
util.AddNetworkString("ttt2_status_effect_add_timed")
util.AddNetworkString("ttt2_status_effect_remove")
util.AddNetworkString("ttt2_status_effect_remove_all")

function STATUS:AddStatus(ply, id)
    net.Start("ttt2_status_effect_add")
    net.WriteString(id)
    net.Send(ply)
end

function STATUS:AddTimedStatus(ply, id, duration, showDuration)
    net.Start("ttt2_status_effect_add_timed")
    net.WriteString(id)
    net.WriteUInt(duration, 32)
    net.WriteBool(showDuration or false)
    net.Send(ply)
end

function STATUS:RemoveStatus(ply, id)
    net.Start("ttt2_status_effect_remove")
    net.WriteString(id)
    net.Send(ply)
end

function STATUS:RemoveAll(ply)
    net.Start("ttt2_status_effect_remove_all")
    net.Send(ply)
end

hook.Add("PlayerSpawn", "status_removed", function(ply)
    STATUS:RemoveAll(ply)
end)
