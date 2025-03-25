---
-- Key overrides for TTT specific keyboard functions
-- @section key_manager

local IsValid = IsValid
local cvSVCheats = GetConVar("sv_cheats")

local soundUse = Sound("buttons/lightswitch2.wav")

local function SendWeaponDrop()
    RunConsoleCommand("ttt_dropweapon")

    -- Turn off weapon switch display if you had it open while dropping, to avoid
    -- inconsistencies.
    WSWITCH:Disable()
end

---
-- Called when a @{Player} presses the "+menu" bind on their keyboard, which is bound to Q by default.
-- @hook
-- @realm client
-- @ref https://wiki.facepunch.com/gmod/GM:OnSpawnMenuOpen
-- @local
function GM:OnSpawnMenuOpen()
    SendWeaponDrop()
end

---
-- Runs when a bind has been pressed. Allows to block commands.
-- @note By using the "alias" console command, this hook can be effectively circumvented
-- @note To stop the user from using +attack, +left and any other movement commands
-- of the sort, please look into using @{GM:StartCommand} instead
-- @param Player ply The @{Player} who used the command; this will always be equal to LocalPlayer
-- @param string bindName The bind command
-- @param boolean pressed If the bind was activated or deactivated
-- @return boolean Return true to prevent the bind
-- @hook
-- @realm client
-- @ref https://wiki.facepunch.com/gmod/GM:PlayerBindPress
-- @local
function GM:PlayerBindPress(ply, bindName, pressed)
    if not IsValid(ply) then
        return
    end

    if bindName == "invnext" and pressed then
        if not ply:IsSpec() then
            WSWITCH:SelectNext()
        end

        return true
    elseif bindName == "invprev" and pressed then
        if not ply:IsSpec() then
            WSWITCH:SelectPrev()
        end

        return true
    elseif bindName == "+attack" then
        if WSWITCH:PreventAttack() then
            if not pressed then
                WSWITCH:ConfirmSelection()
            end

            return true
        end
    elseif bindName == "+use" and pressed then
        -- Do old traitor button check
        if TBHUD:PlayerIsFocused() then
            if ply:KeyDown(IN_WALK) then
                -- Try to change the access to the button for your current role or team
                return TBHUD:ToggleFocused(input.IsButtonDown(KEY_LSHIFT))
            end

            -- Else try to use the button that is currently focused
            return TBHUD:UseFocused()
        end

        -- Find out if a marker is focused otherwise check normal use
        local isClientOnly = false
        local useEnt = markerVision.GetFocusedEntity()
        local isRemote = IsValid(useEnt)
        if not isRemote then
            local tr = util.TraceLine({
                start = ply:GetShootPos(),
                endpos = ply:GetShootPos() + ply:GetAimVector() * 100,
                filter = ply,
                mask = MASK_ALL,
            })

            useEnt = tr.Entity

            if not tr.Hit or not IsValid(useEnt) then
                useEnt = nil
            end

            if useEnt and isfunction(useEnt.ClientUse) then
                isClientOnly = useEnt:ClientUse()
            end
        elseif isfunction(useEnt.RemoteUse) then
            sound.ConditionalPlay(soundUse, SOUND_TYPE_INTERACT)

            isClientOnly = useEnt:RemoteUse(ply)
        end

        -- If returned true by ClientUse or RemoteUse, then dont call Use and UseOverride or RemoteUse serverside
        if isClientOnly then
            return true
        end

        if IsValid(useEnt) and (ply:IsSpec() or useEnt:IsSpecialUsableEntity()) then
            net.Start("TTT2PlayerUseEntity")
            net.WriteEntity(useEnt)
            net.WriteBool(isRemote)
            net.SendToServer()

            return true
        end
    elseif string.sub(bindName, 1, 4) == "slot" and pressed then
        local idx = tonumber(string.sub(bindName, 5, -1)) or 1

        -- If radiomenu is open, override weapon select
        if RADIO.Show then
            RADIO:SendCommand(idx)
        else
            WSWITCH:SelectSlot(idx)
        end

        return true
    elseif (bindName == "+zoom" or bindName == "toggle_zoom") and pressed then
        -- Open or close radio
        RADIO:ShowRadioCommands(not RADIO.Show)

        return true
    elseif bindName == "+voicerecord" or bindName == "-voicerecord" then
        -- This blocks the old Garry's Mod bind
        return true
    elseif bindName == "gm_showteam" and pressed and ply:IsSpec() then
        local m = VOICE.CycleMuteState()

        RunConsoleCommand("ttt_mute_team", m)

        return true
    elseif bindName == "+duck" and pressed and ply:IsSpec() then
        if not IsValid(ply:GetObserverTarget()) then
            if GAMEMODE.ForcedMouse then
                gui.EnableScreenClicker(false)

                GAMEMODE.ForcedMouse = false
            else
                gui.EnableScreenClicker(true)

                GAMEMODE.ForcedMouse = true
            end
        end
    elseif bindName == "noclip" and pressed then
        if not cvSVCheats:GetBool() then
            RunConsoleCommand("ttt_equipswitch")

            return true
        end
    elseif (bindName == "gmod_undo" or bindName == "undo") and pressed then
        RunConsoleCommand("ttt_dropammo")

        return true
    elseif bindName == "phys_swap" and pressed then
        RunConsoleCommand("ttt_quickslot", "5")
    end
end
