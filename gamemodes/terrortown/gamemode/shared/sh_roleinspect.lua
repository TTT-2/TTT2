---
-- Role inspection module. Enables admin inspection of role selection decisions.
-- @module roleinspect
roleinspect = {}

local table = table
local net = net
local admin = admin

-- enum ROLEINSPECT_STAGE
-- indicates a stage of role selection
ROLEINSPECT_STAGE_PRESELECT = 1 -- Pre-selection. This stage determines which roles are available for selection.
ROLEINSPECT_STAGE_LAYERING = 2 -- Layering. This stage refines the above based on configured role layering.
ROLEINSPECT_STAGE_FORCED = 3 -- Assigning forced roles.
ROLEINSPECT_STAGE_BASEROLES = 4 -- Assigning baseroles.
ROLEINSPECT_STAGE_SUBROLES = 5 -- Assigning subroles.
ROLEINSPECT_STAGE_FINAL = 6 -- Final roles.

roleinspect.stageNames = {
    [ROLEINSPECT_STAGE_PRESELECT] = "preselect",
    [ROLEINSPECT_STAGE_LAYERING] = "layering",
    [ROLEINSPECT_STAGE_FORCED] = "forced",
    [ROLEINSPECT_STAGE_BASEROLES] = "baseroles",
    [ROLEINSPECT_STAGE_SUBROLES] = "subroles",
    [ROLEINSPECT_STAGE_FINAL] = "final"
}

function roleinspect.GetStageName(stage)
    return roleinspect.stageNames[stage]
end

function roleinspect.GetStageFullName(stage)
    return "roleinspect_stage_" .. roleinspect.stageNames[stage]
end

-- enum ROLESELECT_DECISION
-- indicates the decision that was made about a role
ROLEINSPECT_DECISION_NONE = 0
ROLEINSPECT_DECISION_CONSIDER = 1
ROLEINSPECT_DECISION_NO_CONSIDER = 2
ROLEINSPECT_DECISION_ROLE_ASSIGNED = 3
ROLEINSPECT_DECISION_ROLE_NOT_ASSIGNED = 4

roleinspect.decisionNames = {
    [ROLEINSPECT_DECISION_NONE] = "none",
    [ROLEINSPECT_DECISION_CONSIDER] = "consider",
    [ROLEINSPECT_DECISION_NO_CONSIDER] = "no_consider",
    [ROLEINSPECT_DECISION_ROLE_ASSIGNED] = "role_assigned",
    [ROLEINSPECT_DECISION_ROLE_NOT_ASSIGNED] = "role_not_assigned",
}

function roleinspect.GetDecisionName(decision)
    return roleinspect.decisionNames[decision]
end

function roleinspect.GetDecisionFullName(decision)
    return "roleinspect_decision_" .. roleinspect.decisionNames[decision]
end


-- enum ROLEINSPECT_REASON
-- indicates the reason that a decision was made
-- The enum values are the language string IDs for the reasons

ROLEINSPECT_REASON_PASSED = "roleinspect_reason_passed" -- All checks passed, this role can move on

-- Reasons for STAGE_PRESELECT
ROLEINSPECT_REASON_NOT_ENABLED = "roleinspect_reason_not_enabled" -- Role is not enabled
ROLEINSPECT_REASON_NO_PLAYERS = "roleinspect_reason_no_players" -- Role removed from consideration because there weren't enough players
ROLEINSPECT_REASON_LOW_PROPORTION = "roleinspect_reason_low_proportion" -- Role not considered because it's distribution ratio rounds to zero
ROLEINSPECT_REASON_ROLE_CHANCE = "roleinspect_reason_role_chance" -- Role not considered because the distribution chance check failed
ROLEINSPECT_REASON_NOT_SELECTABLE = "roleinspect_reason_not_selectable" -- Role was marked notSelectable
ROLEINSPECT_REASON_ROLE_DECISION = "roleinspect_reason_role_decision" -- The role decided that it could not be distributed

-- Reasons for STAGE_LAYERING
ROLEINSPECT_REASON_LAYER = "roleinspect_reason_layer" -- Role selected from layer, or removed because another role was chosen
-- ROLEINSPECT_REASON_NO_PLAYERS can also appear here if we ran out of playercount during allocation
ROLEINSPECT_REASON_TOO_MANY_ROLES = "roleinspect_reason_too_many_roles" -- Role removed from consideration because enough roles to satisfy playercount have already been selected
ROLEINSPECT_REASON_NOT_LAYERED = "roleinspect_reason_not_layered" -- Role was selected from the non-layered pool

-- Reasons for STAGE_FORCED
ROLEINSPECT_REASON_FORCED = "roleinspect_reason_forced"

-- Reasons for STAGE_BASEROLES and STAGE_SUBROLES
ROLEINSPECT_REASON_CHANCE = "roleinspect_reason_chance" -- Player assigned role through random selection
ROLEINSPECT_REASON_WEIGHTED_CHANCE = "roleinspect_reason_weighted_chance" -- Player assigned role through weighted random selection
ROLEINSPECT_REASON_NOT_ASSIGNED = "roleinspect_reason_not_assigned" -- Player assigned a role because they were not otherwise assigned one

if SERVER then
    roleinspect.decisions = {}
    roleinspect.cvar = CreateConVar("ttt2_roleinspect_enable", "0", { FCVAR_ARCHIVE, FCVAR_NOTIFY })

    function roleinspect.GetDecisions(callback)
        callback(roleinspect.decisions)
    end

    local function EmptyTable()
        return {}
    end

    local function GetOrAddTable(tbl, key, createDefault)
        local newTbl = tbl[key]
        if not newTbl then
            newTbl = createDefault()
            tbl[key] = newTbl
        end
        return newTbl
    end

    local function GetStageTable(stage)
        return GetOrAddTable(roleinspect.decisions, stage, function()
            return { roles = {}, extra = {} }
        end)
    end

    local function GetRoleTable(stage, role)
        local dstage = GetStageTable(stage)
        return GetOrAddTable(dstage.roles, role, function()
            return { decisions = {}, extra = {} }
        end)
    end

    local function MaybeClone(data)
        if type(data) == "table" then
            return table.FullCopy(data)
        end
        return data
    end

    -- TODO: make roleinspection conditional on whether a client wants it

    local riEnabled = false

    function roleinspect.Reset()
        roleinspect.decisions = {}
        riEnabled = roleinspect.cvar:GetBool()
    end

    function roleinspect.ReportStageExtraInfo(stage, key, info)
        if not riEnabled then return end
        local dstage = GetStageTable(stage)
        local tbl = GetOrAddTable(dstage.extra, key, EmptyTable)
        tbl[#tbl + 1] = MaybeClone(isfunction(info) and info() or info)
    end

    function roleinspect.ReportRoleExtraInfo(stage, role, key, info)
        if not riEnabled then return end
        local drole = GetRoleTable(stage, role)
        local tbl = GetOrAddTable(drole.extra, key, EmptyTable)
        tbl[#tbl + 1] = MaybeClone(isfunction(info) and info() or info)
    end

    function roleinspect.ReportDecision(stage, role, ply, decision, reason, extra)
        if not riEnabled then return end
        local drole = GetRoleTable(stage, role)
        local decisionTbl = drole.decisions
        decisionTbl[#decisionTbl + 1] = {
            ply = ply,
            decision = decision,
            reason = reason,
            extra = MaybeClone(isfunction(extra) and extra() or extra)
        }
    end

    util.AddNetworkString("TTT2SyncRoleInspectInfo")
    net.Receive("TTT2SyncRoleInspectInfo", function(len, ply)
        if not admin.IsAdmin(ply) then
            -- send back an empty table so we always respond
            net.SendStream("TTT2SyncRoleInspectInfo", {}, { ply })
        end

        -- otherwise, send back the full decision table
        net.SendStream("TTT2SyncRoleInspectInfo", roleinspect.decisions, { ply })
    end)
end

if CLIENT then
    local recvCallbacks = {}

    function roleinspect.GetDecisions(callback)
        recvCallbacks[#recvCallbacks + 1] = callback

        net.Start("TTT2SyncRoleInspectInfo")
        net.SendToServer()
    end

    net.ReceiveStream("TTT2SyncRoleInspectInfo", function(data)
        while #recvCallbacks > 0 do
            recvCallbacks[1](data)
            table.remove(recvCallbacks, 1)
        end
    end)
end
