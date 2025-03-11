if engine.ActiveGamemode() ~= "terrortown" then
    return
end

---
-- Entity Crash Catcher v2
-- This script detects entities that are moving too fast, leading to a potential server crash
-- Original by code_gs, Ambro, DarthTealc, TheEMP, and LuaTenshi; v2 by code_gs
-- GitHub: https://github.com/Kefta/Entity-Crash-Catcher
-- Facepunch: http://facepunch.com/showthread.php?t=1347114

-- Use in conjunction with these convars:
RunConsoleCommand("sv_crazyphysics_defuse", "1")
RunConsoleCommand("sv_crazyphysics_remove", "1")
--RunConsoleCommand("sv_crazyphysics_warning", "1") -- Enable if you want to be warned about bodies being removed

------------------- Script -------------------
local function DebugMessage(
    bRemove,
    Entity,
    vEntityPosition,
    aEntityRotation,
    vEntityVelocity,
    vObjectPosition --[[= "N/A"]],
    aObjectRotation --[[= "N/A"]],
    vObjectVelocity --[[ = "N/A"]]
)
    return "\n[GS CrazyPhysics] "
        .. tostring(Entity)
        .. (bRemove and " removed!" or " frozen!")
        .. "\nEntity position:\t"
        .. tostring(vEntityPosition)
        .. "\nEntity angle:\t"
        .. tostring(aEntityRotation)
        .. "\nEntity velocity:\t"
        .. tostring(vEntityVelocity)
        .. "\nPhysics object position:\t"
        .. (vObjectPosition == nil and "N/A" or tostring(vObjectPosition))
        .. "\nPhysics object rotation:\t"
        .. (aObjectRotation == nil and "N/A" or tostring(aObjectRotation))
        .. "\nPhysics object velocity:\t"
        .. (vObjectVelocity == nil and "N/A" or tostring(vObjectVelocity))
        .. "\n"
end

if CLIENT then
    net.Receive("GS_CrazyPhysics_Defuse", function()
        chat.AddText(
            DebugMessage(
                false,
                "Entity [" .. net.ReadUInt(16) .. "][" .. net.ReadString() .. "]",
                net.ReadVector(),
                net.ReadAngle(),
                net.ReadVector()
            )
        )
    end)

    net.Receive("GS_CrazyPhysics_Remove", function()
        chat.AddText(
            DebugMessage(
                true,
                "Entity [" .. net.ReadUInt(16) .. "][" .. net.ReadString() .. "]",
                net.ReadVector(),
                net.ReadAngle(),
                net.ReadVector()
            )
        )
    end)

    net.Receive("GS_CrazyPhysics_Defuse_Object", function()
        chat.AddText(
            DebugMessage(
                false,
                "Entity [" .. net.ReadUInt(16) .. "][" .. net.ReadString() .. "]",
                net.ReadVector(),
                net.ReadAngle(),
                net.ReadVector(),
                net.ReadVector(),
                net.ReadAngle(),
                net.ReadVector()
            )
        )
    end)

    net.Receive("GS_CrazyPhysics_Remove_Object", function()
        chat.AddText(
            DebugMessage(
                true,
                "Entity [" .. net.ReadUInt(16) .. "][" .. net.ReadString() .. "]",
                net.ReadVector(),
                net.ReadAngle(),
                net.ReadVector(),
                net.ReadVector(),
                net.ReadAngle(),
                net.ReadVector()
            )
        )
    end)

    return -- following code is serverside-only
end

-- Options

---
-- @realm server
local gs_crazyphysics = CreateConVar(
    "gs_crazyphysics",
    "1",
    { FCVAR_NOTIFY, FCVAR_ARCHIVE },
    "Enables Lua crazyphysics detection"
)

---
-- @realm server
local gs_crazyphysics_echo = CreateConVar(
    "gs_crazyphysics_echo",
    "0",
    { FCVAR_NOTIFY, FCVAR_ARCHIVE },
    "Inform players of ragdoll freezing/removal"
)

---
-- @realm server
local gs_crazyphysics_interval = CreateConVar(
    "gs_crazyphysics_interval",
    "0.1",
    { FCVAR_NOTIFY, FCVAR_ARCHIVE },
    "How often to check entities for extreme velocity"
)

---
-- @realm server
local gs_crazyphysics_speed_defuse = CreateConVar(
    "gs_crazyphysics_speed_defuse",
    "4000",
    { FCVAR_NOTIFY, FCVAR_ARCHIVE },
    "Max velocity in in/s an entity can reach before it's frozen"
)

---
-- @realm server
local gs_crazyphysics_speed_remove = CreateConVar(
    "gs_crazyphysics_speed_remove",
    "6000",
    { FCVAR_NOTIFY, FCVAR_ARCHIVE },
    "Max velocity in in/s an entity can reach before it's removed"
)

---
-- @realm server
local gs_crazyphysics_defusetime = CreateConVar(
    "gs_crazyphysics_defusetime",
    "1",
    { FCVAR_NOTIFY, FCVAR_ARCHIVE },
    "How long to freeze the entity for during diffusal"
)

-- Add entity classes you want checked
local tEntitiesToCheck = {
    "prop_ragdoll",
}

local tIdentifyEntities = {
    prop_ragdoll = true,
}
local corpseConfig = CORPSE and CORPSE.cv

hook.Add("Initialize", "TTT2GSCrazyPhysics", function()
    corpseConfig = CORPSE.cv
end)

util.AddNetworkString("GS_CrazyPhysics_Defuse")
util.AddNetworkString("GS_CrazyPhysics_Remove")
util.AddNetworkString("GS_CrazyPhysics_Defuse_Object")
util.AddNetworkString("GS_CrazyPhysics_Remove_Object")

local iEntityLen = #tEntitiesToCheck

local function SetAbsVelocity(pEntity, vAbsVelocity)
    if pEntity:GetSaveTable()["m_vecAbsVelocity"] ~= vAbsVelocity then
        -- The abs velocity won't be dirty since we're setting it here
        pEntity:RemoveEFlags(EFL_DIRTY_ABSVELOCITY)

        -- All children are invalid, but we are not
        local tChildren = pEntity:GetChildren()

        for i = 1, #tChildren do
            tChildren[i]:AddEFlags(EFL_DIRTY_ABSVELOCITY)
        end

        pEntity:SetSaveValue("m_vecAbsVelocity", vAbsVelocity)

        -- NOTE: Do *not* do a network state change in this case.
        -- m_vVelocity is only networked for the player, which is not manual mode
        local pMoveParent = pEntity:GetMoveParent()

        if IsValid(pMoveParent) then
            -- First subtract out the parent's abs velocity to get a relative
            -- velocity measured in world space
            -- Transform relative velocity into parent space
            -- FIXME
            --pEntity:SetSaveValue("m_vecVelocity", (vAbsVelocity - pMoveParent:_GetAbsVelocity()):IRotate(pMoveParent:EntityToWorldTransform()))
            pEntity:SetSaveValue("velocity", vAbsVelocity)
        else
            pEntity:SetSaveValue("velocity", vAbsVelocity)
        end
    end
end

local function KillVelocity(pEntity)
    pEntity:CollisionRulesChanged()
    pEntity:SetLocalVelocity(vector_origin) -- ::SetLocalVelocity
    pEntity:SetVelocity(vector_origin) -- ::SetBaseVelocity

    SetAbsVelocity(pEntity, vector_origin) -- ::SetAbsVelocity

    for i = 0, pEntity:GetPhysicsObjectCount() - 1 do
        local pPhysObj = pEntity:GetPhysicsObjectNum(i)
        pPhysObj:EnableMotion(false)
        pPhysObj:SetVelocity(vector_origin)
        pPhysObj:SetVelocityInstantaneous(vector_origin)
        pPhysObj:RecheckCollisionFilter()
        pPhysObj:Sleep()
    end
end

local function IdentifyCorpse(pCorpse)
    if CORPSE.GetFound(pCorpse, false) then
        return
    end

    CORPSE.SetFound(pCorpse, true)

    local pPlayer = pCorpse:GetDTEntity(CORPSE.dti.ENT_PLAYER)
    local nRole = ROLE_NONE
    local nTeam = TEAM_NONE

    if IsValid(pPlayer) then
        pPlayer:TTT2NETSetBool("body_found", true)

        nRole = pCorpse.was_role or pPlayer:GetSubRole()
        nTeam = pCorpse.was_team or pPlayer:GetTeam()
        --[[
        if nRole == ROLE_TRAITOR then
            SendConfirmedTraitors(GetInnocentFilter(false))
        end
        ]]
        --
        SendFullStateUpdate()
    else
        local sSteamID = pCorpse.sid64

        if sSteamID then
            pPlayer = player.GetBySteamID64(sSteamID)

            if IsValid(pPlayer) then
                pPlayer:TTT2NETSetBool("body_found", true)

                nRole = pCorpse.was_role or pPlayer:GetSubRole()
                nTeam = pCorpse.was_team or pPlayer:GetTeam()
                --[[
                if nRole == ROLE_TRAITOR then
                    SendConfirmedTraitors(GetInnocentFilter(false))
                end
                ]]
                --
                SendFullStateUpdate()
            end
        end
    end

    if corpseConfig.announce_body_found:GetBool() then
        if corpseConfig.confirm_team:GetBool() then -- TODO adjust the new messages
            LANG.Msg("body_found", {
                finder = "The Server",
                victim = CORPSE.GetPlayerNick(pCorpse, nil) or pPlayer:GetName(),
                role = LANG.Param("body_found_" .. roles.GetByIndex(nRole).abbr),
                team = LANG.Param(nTeam),
            })
        else
            LANG.Msg("body_found", {
                finder = "The Server",
                victim = CORPSE.GetPlayerNick(pCorpse, nil) or pPlayer:GetName(),
                role = LANG.Param("body_found_" .. roles.GetByIndex(nRole).abbr),
            })
        end
    end

    if corpseConfig.confirm_killlist:GetBool() then
        local tKills = pCorpse.kills
        if tKills then
            for i = 1, #tKills do
                local pVictim = player.GetBySteamID64(tKills[i])

                if not IsValid(pVictim) or pVictim:TTT2NETGetBool("body_found") then
                    continue
                end

                pVictim:TTT2NETSetBool("body_found", true)

                LANG.Msg("body_confirm", {
                    finder = "The Server",
                    victim = pVictim:GetName(),
                })
            end
        end
    end
end

local function SendMessage(
    bRemove,
    bCheckObjectVel,
    pEntity,
    vEntityPos,
    aEntityRot,
    vEntityVel,
    vObjectPos,
    aObjectRot,
    vObjectVel
)
    ServerLog(
        DebugMessage(
            bRemove,
            pEntity,
            vEntityPos,
            aEntityRot,
            vEntityVel,
            vObjectPos,
            aObjectRot,
            vObjectVel
        )
    )

    if gs_crazyphysics_echo:GetBool() then
        net.Start(
            bRemove
                    and (bCheckObjectVel and "GS_CrazyPhysics_Remove_Object" or "GS_CrazyPhysics_Remove")
                or (bCheckObjectVel and "GS_CrazyPhysics_Defuse_Object" or "GS_CrazyPhysics_Defuse")
        )

        net.WriteUInt(pEntity:EntIndex(), 16)
        net.WriteString(pEntity:GetClass())
        net.WriteVector(vEntityPos)
        net.WriteAngle(aEntityRot)
        net.WriteVector(vEntityVel)

        if bCheckObjectVel then
            net.WriteVector(vObjectPos)
            net.WriteAngle(aObjectRot)
            net.WriteVector(vObjectVel)
        end

        net.Broadcast()
    end
end

local flNextCheck = 0

hook.Add("Think", "GS_CrazyPhysics", function()
    if not gs_crazyphysics:GetBool() then
        return
    end

    local flCurTime = CurTime()

    if flNextCheck > flCurTime then
        return
    end

    flNextCheck = flCurTime + gs_crazyphysics_interval:GetFloat()

    local flRemoveSpeed = gs_crazyphysics_speed_remove:GetFloat()
    flRemoveSpeed = flRemoveSpeed * flRemoveSpeed

    local flDefuseSpeed = gs_crazyphysics_speed_defuse:GetFloat()
    flDefuseSpeed = flDefuseSpeed * flDefuseSpeed

    for i = 1, iEntityLen do
        local sClass = tEntitiesToCheck[i]
        local tEntities = ents.FindByClass(sClass)

        for i2 = 1, #tEntities do
            local pEntity = tEntities[i2]
            local vEntityVel = pEntity:GetVelocity() -- ::GetAbsVelocity
            local flEntityVel = vEntityVel:LengthSqr()
            local pPhysObj = pEntity:GetPhysicsObject()
            local bCheckObjectVel = IsValid(pPhysObj)
            local vObjectVel, flObjectVel

            if bCheckObjectVel then
                vObjectVel = pPhysObj:GetVelocity()
                flObjectVel = vObjectVel:LengthSqr()
            end

            if flEntityVel >= flRemoveSpeed or bCheckObjectVel and flObjectVel >= flRemoveSpeed then
                KillVelocity(pEntity)

                pEntity:Remove()

                if tIdentifyEntities[sClass] then
                    IdentifyCorpse(pEntity)
                end

                local vObjectPos, aObjectRot

                if bCheckObjectVel then
                    vObjectPos = pPhysObj:GetPos()
                    aObjectRot = pPhysObj:GetAngles()
                end

                SendMessage(
                    true,
                    bCheckObjectVel,
                    pEntity,
                    pEntity:GetPos(),
                    pEntity:GetAngles(),
                    vEntityVel,
                    vObjectPos,
                    aObjectRot,
                    vObjectVel
                )
            elseif
                flEntityVel >= flDefuseSpeed or bCheckObjectVel and flObjectVel >= flDefuseSpeed
            then
                KillVelocity(pEntity)

                timer.Simple(gs_crazyphysics_defusetime:GetFloat(), function()
                    if not IsValid(pEntity) then
                        return
                    end

                    pEntity:SetLocalVelocity(vector_origin) -- ::SetLocalVelocity
                    pEntity:SetVelocity(vector_origin) -- ::SetBaseVelocity

                    SetAbsVelocity(pEntity, vector_origin) -- ::SetAbsVelocity

                    for i3 = 0, pEntity:GetPhysicsObjectCount() - 1 do
                        local pPhysObj2 = pEntity:GetPhysicsObjectNum(i3)
                        pPhysObj2:EnableMotion(true)
                        pPhysObj2:SetVelocity(vector_origin)
                        pPhysObj2:SetVelocityInstantaneous(vector_origin)
                        pPhysObj2:Wake()
                        pPhysObj2:RecheckCollisionFilter()
                    end

                    pEntity:CollisionRulesChanged()
                end)

                local vObjectPos, aObjectRot

                if bCheckObjectVel then
                    vObjectPos = pPhysObj:GetPos()
                    aObjectRot = pPhysObj:GetAngles()
                end

                SendMessage(
                    false,
                    bCheckObjectVel,
                    pEntity,
                    pEntity:GetPos(),
                    pEntity:GetAngles(),
                    vEntityVel,
                    vObjectPos,
                    aObjectRot,
                    vObjectVel
                )
            end
        end
    end
end)
