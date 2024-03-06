---
-- A bunch of additional functions for the sound module
-- @module sound

SOUND_TYPE_UI = 0
SOUND_TYPE_BUTTONS = 1

if SERVER then
    AddCSLuaFile()

    return
end

local cvEnableSoundUI = CreateConVar("ttt2_enable_sound_ui", "1", { FCVAR_ARCHIVE })
local cvLevelSoundUI = CreateConVar("ttt2_level_sound_ui", "1", { FCVAR_ARCHIVE })

local cvEnableSoundButtons = CreateConVar("ttt2_enable_sound_buttons", "1", { FCVAR_ARCHIVE })
local cvLevelSoundButtons = CreateConVar("ttt2_level_sound_buttons", "1", { FCVAR_ARCHIVE })

function sound.ConditionalPlay(sound, typeSound)
    local client = LocalPlayer()

    if typeSound == SOUND_TYPE_UI and cvEnableSoundUI:GetBool() then
        client:EmitSound(sound, 75 * cvLevelSoundUI:GetFloat())
    elseif typeSound == SOUND_TYPE_BUTTONS and cvEnableSoundButtons:GetBool() then
        client:EmitSound(sound, 75 * cvLevelSoundButtons:GetFloat())
    end
end
