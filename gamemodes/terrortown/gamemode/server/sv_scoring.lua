---
-- Customized scoring, this is deprecated and is only used as a
-- compatbility bridge to old addons.
-- @module SCORE

SCORE = SCORE or {}
SCORE.Events = SCORE.Events or {}

---
-- Adds an event to the synced event table
-- @param table entry
-- @param boolean t_override the time override
-- @realm server
-- @deprecated
function SCORE:AddEvent(entry, t_override)
    entry.t = t_override or CurTime()

    self.Events[#self.Events + 1] = entry
end
