---
-- Role inspection module. Enables admin inspection of role selection decisions.
-- @module roleinspect
roleinspect = {}

local math = math
local table = table
local player = player
local net = net
local admin = admin
local pairs = pairs
local IsValid = IsValid
local hook = hook
local playerGetAll = player.GetAll

-- enum ROLEINSPECT_STAGE
-- indicates a stage of role selection
ROLEINSPECT_STAGE_PRESELECT = 1 -- Pre-selection. This stage determines which roles are available for selection.
ROLEINSPECT_STAGE_LAYERING = 2 -- Layering. This stage refines the above based on configured role layering.
ROLEINSPECT_STAGE_FORCED = 3 -- Assigning forced roles.
ROLEINSPECT_STAGE_BASEROLES = 4 -- Assigning baseroles.
ROLEINSPECT_STAGE_SUBROLES = 5 -- Assigning subroles.

roleinspect.stageNames = {
    [ROLEINSPECT_STAGE_PRESELECT] = "roleinspect_stage_preselect",
    [ROLEINSPECT_STAGE_LAYERING] = "roleinspect_stage_layering",
    [ROLEINSPECT_STAGE_FORCED] = "roleinspect_stage_forced",
    [ROLEINSPECT_STAGE_BASEROLES] = "roleinspect_stage_baseroles",
    [ROLEINSPECT_STAGE_SUBROLES] = "roleinspect_stage_subroles",
}

-- enum ROLESELECT_DECISION
-- indicates the decision that was made about a role
ROLESELECT_DECISION_NONE = 0
ROLESELECT_DECISION_NOT_CONSIDERED = 1
ROLESELECT_DECISION_ROLE_ASSIGNED = 2
ROLESELECT_DECISION_ROLE_NOT_ASSIGNED = 3

-- enum ROLEINSPECT_REASON
-- indicates the reason that a decision was made
-- The enum values are the language string IDs for the reasons

-- Reasons for STAGE_PRESELECT
ROLEINSPECT_REASON_NOT_ENABLED = "roleinspect_reason_not_enabled" -- Role is not enabled
ROLEINSPECT_REASON_NO_PLAYERS = "roleinspect_reason_no_players" -- Role removed from consideration because there weren't enough players
ROLEINSPECT_REASON_LOW_PROPORTION = "roleinspect_reason_low_proportion" -- Role not considered because it's distribution ratio rounds to zero
ROLEINSPECT_REASON_ROLE_CHANCE = "roleinspect_reason_role_chance" -- Role not considered because the distribution chance check failed
ROLEINSPECT_REASON_ROLE_DECISION = "roleinspect_reason_role_decision" -- The role decided that it could not be distributed

-- Reasons for STAGE_LAYERING
ROLEINSPECT_REASON_LAYER = "roleinspect_reason_layer" -- Role removed from consideration because another role in its layer was chosen
ROLEINSPECT_REASON_TOO_MANY_ROLES = "roleinspect_reason_too_many_roles" -- Role removed from consideration because enough roles to satisfy playercount have already been selected

-- Reasons for STAGE_FORCED
ROLEINSPECT_REASON_FORCED = "roleinspect_reason_forced"

-- Reasons for STAGE_BASEROLES and STAGE_SUBROLES
ROLEINSPECT_REASON_CHANCE = "roleinspect_reason_chance" -- Player assigned role through random selection
ROLEINSPECT_REASON_WEIGHTED_CHANCE = "roleinspect_reason_weighted_chance" -- Player assigned role through weighted random selection

if SERVER then
    roleinspect.decisions = {}

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
        return GetOrAddTable(dstage, role, function()
            return { decisions = {}, extra = {} }
        end)
    end

    function roleinspect.Reset()
        roleinspect.decisions = {}
    end

    function roleinspect.ReportStageExtraInfo(stage, key, info)
        local dstage = GetStageTable(stage)
        local tbl = GetOrAddTable(dstage.extra, key, EmptyTable)
        tbl[#tbl + 1] = info
    end

    function roleinspect.ReportRoleExtraInfo(stage, role, key, info)
        local drole = GetRoleTable(stage, role)
        local tbl = GetOrAddTable(drole.extra, key, EmptyTable)
        tbl[#tbl + 1] = info
    end

    function roleinspect.ReportDecision(ply, role, decision, stage, reason)
        local drole = GetRoleTable(stage, role)
        local decisionTbl = drole.decisions
        decisionTbl[#decisionTbl + 1] = { ply = ply, decision = decision, reason = reason }
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
