---
-- @module STATUS

STATUS = {}

-- register networkt messages
util.AddNetworkString("ttt2_status_effect_add")
util.AddNetworkString("ttt2_status_effect_set_id")
util.AddNetworkString("ttt2_status_effect_add_timed")
util.AddNetworkString("ttt2_status_effect_remove")
util.AddNetworkString("ttt2_status_effect_remove_all")

---
-- Adds a status for a given @{Player}
-- @param Player ply The @{Player} that should receive this status update
-- @param string id The id of the registered @{STATUS}
-- @param[default=1] number active_icon The numeric id of a specific status icon
-- @realm server
function STATUS:AddStatus(ply, id, active_icon)
    net.Start("ttt2_status_effect_add")
    net.WriteString(id)
    net.WriteUInt(active_icon or 1, 8)
    net.Send(ply)
end

---
-- Changes the active icon for a specifiv active effect for a given @{Player}
-- @param Player ply The @{Player} that should receive this status update
-- @param string id The id of the registered @{STATUS}
-- @param[default=1] number active_icon The numeric id of a specific status icon
-- @realm server
function STATUS:SetActiveIcon(ply, id, active_icon)
    net.Start("ttt2_status_effect_set_id")
    net.WriteString(id)
    net.WriteUInt(active_icon or 1, 8)
    net.Send(ply)
end

---
-- Adds a times status for a given @{Player}
-- @param Player ply The @{Player} that should receive this status update
-- @param string id The id of the registered @{STATUS}
-- @param number duration The duration of the @{STATUS}. If the time elapsed,
-- the @{STATUS} will be removed automatically
-- @param[default=false] boolean showDuration Whether the duration should be shown
-- @param[default=1] number active_icon The numeric id of a specific status icon
-- @realm server
function STATUS:AddTimedStatus(ply, id, duration, showDuration, active_icon)
    net.Start("ttt2_status_effect_add_timed")
    net.WriteString(id)
    net.WriteUInt(duration, 32)
    net.WriteBool(showDuration or false)
    net.WriteUInt(active_icon or 1, 8)
    net.Send(ply)
end

---
-- Removes a status for a given @{Player}
-- @param Player ply The @{Player} that should receive this status update
-- @param string id The id of the registered @{STATUS}
-- @realm server
function STATUS:RemoveStatus(ply, id)
    net.Start("ttt2_status_effect_remove")
    net.WriteString(id)
    net.Send(ply)
end

---
-- Removes each status for a given @{Player}
-- @param Player ply The @{Player} that should receive this status update
-- @realm server
function STATUS:RemoveAll(ply)
    net.Start("ttt2_status_effect_remove_all")
    net.Send(ply)
end

hook.Add("PlayerSpawn", "status_removed", function(ply)
    STATUS:RemoveAll(ply)
end)
