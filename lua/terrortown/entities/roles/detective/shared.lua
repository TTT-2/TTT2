ROLE.Base = "ttt_role_base"

ROLE.index = ROLE_DETECTIVE
ROLE.color = Color(31, 77, 191, 255)
ROLE.dkcolor = Color(10, 42, 123, 255)
ROLE.bgcolor = Color(255, 177, 16, 255)
ROLE.abbr = "det"
ROLE.defaultTeam = TEAM_INNOCENT
ROLE.defaultEquipment = SPECIAL_EQUIPMENT
ROLE.scoreKillsMultiplier = 1
ROLE.scoreTeamKillsMultiplier = -8
ROLE.fallbackTable = {}
ROLE.unknownTeam = true

-- conVarData
ROLE.conVarData = {
	pct = 0.13,
	maximum = 32,
	minPlayers = 8,
	minKarma = 600,

	credits = 1,
	creditsTraitorKill = 0,
	creditsTraitorDead = 1,

	togglable = true
}
