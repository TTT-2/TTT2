---
-- A bunch of additional functions for the sound module
-- @module sound

SOUND_TYPE_UI = 0
SOUND_TYPE_BUTTONS = 1
SOUND_TYPE_MESSAGE = 2

if SERVER then
    AddCSLuaFile()

    return
end

local cvEnableSoundUI = CreateConVar("ttt2_enable_sound_ui", "1", { FCVAR_ARCHIVE })
local cvLevelSoundUI = CreateConVar("ttt2_level_sound_ui", "1", { FCVAR_ARCHIVE })

local cvEnableSoundButtons = CreateConVar("ttt2_enable_sound_buttons", "1", { FCVAR_ARCHIVE })
local cvLevelSoundButtons = CreateConVar("ttt2_level_sound_buttons", "1", { FCVAR_ARCHIVE })

local cvEnableSoundMessage = CreateConVar("ttt2_enable_sound_message", "1", { FCVAR_ARCHIVE })
local cvLevelSoundMessage = CreateConVar("ttt2_level_sound_message", "1", { FCVAR_ARCHIVE })

function sound.ConditionalPlay(sound, typeSound)
    local client = LocalPlayer()

    if typeSound == SOUND_TYPE_UI and cvEnableSoundUI:GetBool() then
        client:EmitSound(sound, 75 * cvLevelSoundUI:GetFloat())
    elseif typeSound == SOUND_TYPE_BUTTONS and cvEnableSoundButtons:GetBool() then
        client:EmitSound(sound, 75 * cvLevelSoundButtons:GetFloat())
    elseif typeSound == SOUND_TYPE_MESSAGE and cvEnableSoundMessage:GetBool() then
        client:EmitSound(sound, 75 * cvLevelSoundMessage:GetFloat())
    end
end

function chat.PlaySound()
    sound.ConditionalPlay("HudChat.Message", SOUND_TYPE_MESSAGE)
end
