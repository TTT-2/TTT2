---
-- A bunch of additional functions for the chat module
-- @module sound

if SERVER then
    AddCSLuaFile()

    return
end

---
-- Plays the chat "tick" sound.
-- @note This is overwritten so that this function respects the TTT2 convar.
-- @realm client
function chat.PlaySound()
    sound.ConditionalPlay("HudChat.Message", SOUND_TYPE_MESSAGE)
end
