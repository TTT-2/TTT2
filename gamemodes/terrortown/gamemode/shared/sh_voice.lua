---
-- @section voice_manager

---
-- Whether or not the @{Player} can use the voice chat.
-- @note Has to be registered on both client and server to hide the UI
-- element and stop the voicechat
-- @param Player ply @{Player} who wants to use the voice chat
-- @param boolean isTeam Are they trying to use the team voice chat
-- @return[default=true] boolean Whether or not the @{Player} can use the voice chat
-- @hook
-- @realm shared
function GM:TTT2CanUseVoiceChat(ply, isTeam)
    return true
end
