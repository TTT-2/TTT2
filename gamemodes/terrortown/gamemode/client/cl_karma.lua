---
-- @module KARMA

KARMA = {}

---
-- Returns whether the KARMA is enabled
-- @return boolean
-- @realm client
function KARMA.IsEnabled()
    return GetGlobalBool("ttt_karma", false)
end
