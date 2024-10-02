---
-- A bunch of additional functions for the sound module
-- @module sound

SOUND_TYPE_INTERACT = 0
SOUND_TYPE_BUTTONS = 1
SOUND_TYPE_MESSAGE = 2

if SERVER then
    AddCSLuaFile()

    return
end

---
-- @realm client
local cvEnableSoundInteract = CreateConVar("ttt2_enable_sound_interact", "1", { FCVAR_ARCHIVE })
---
-- @realm client
local cvLevelSoundInteract = CreateConVar("ttt2_level_sound_interact", "1", { FCVAR_ARCHIVE })

---
-- @realm client
local cvEnableSoundButtons = CreateConVar("ttt2_enable_sound_buttons", "1", { FCVAR_ARCHIVE })
---
-- @realm client
local cvLevelSoundButtons = CreateConVar("ttt2_level_sound_buttons", "1", { FCVAR_ARCHIVE })

---
-- @realm client
local cvEnableSoundMessage = CreateConVar("ttt2_enable_sound_message", "0", { FCVAR_ARCHIVE })
---
-- @realm client
local cvLevelSoundMessage = CreateConVar("ttt2_level_sound_message", "1", { FCVAR_ARCHIVE })

---
-- Plays the sound only if the provided type is enabled on the client.
-- @param string sound The sound to play; this should either be a sound script name or a file path relative to the `sound/` folder
-- @param number typeSound The sound type. Can be `SOUND_TYPE_INTERACT`, `SOUND_TYPE_BUTTONS` or `SOUND_TYPE_MESSAGE`
-- @realm client
function sound.ConditionalPlay(sound, typeSound)
    local client = LocalPlayer()

    if typeSound == SOUND_TYPE_INTERACT and cvEnableSoundInteract:GetBool() then
        client:EmitSound(sound, 75 * cvLevelSoundInteract:GetFloat())
    elseif typeSound == SOUND_TYPE_BUTTONS and cvEnableSoundButtons:GetBool() then
        client:EmitSound(sound, 75 * cvLevelSoundButtons:GetFloat())
    elseif typeSound == SOUND_TYPE_MESSAGE and cvEnableSoundMessage:GetBool() then
        client:EmitSound(sound, 75 * cvLevelSoundMessage:GetFloat())
    end
end
