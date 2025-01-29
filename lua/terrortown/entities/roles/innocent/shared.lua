ROLE.Base = "ttt_role_base"

ROLE.index = ROLE_INNOCENT

---
-- @ignore
function ROLE:PreInitialize()
    self.color = Color(80, 173, 59, 255)

    self.abbr = "inno"

    self.defaultTeam = TEAM_INNOCENT
    self.defaultEquipment = SPECIAL_EQUIPMENT

    self.builtin = true
    self.score.killsMultiplier = 2
    self.score.teamKillsMultiplier = -8
    self.unknownTeam = true
end

if SERVER then
    ---
    -- @realm server
    local ttt_min_inno_pct = CreateConVar(
        "ttt_min_inno_pct",
        "0.47",
        { FCVAR_NOTIFY, FCVAR_ARCHIVE },
        "Minimum multiplicator for each player to calculate the minimum amount of innocents"
    )

    ---
    -- @ignore
    function ROLE:GetAvailableRoleCount(ply_count)
        return math.floor(ply_count * ttt_min_inno_pct:GetFloat()),
            ROLEINSPECT_REASON_LOW_PROPORTION
    end
end
