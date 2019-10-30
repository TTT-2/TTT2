ROLE.Base = "ttt_role_base"

ROLE.index = ROLE_TRAITOR

function ROLE:PreInitialize()
	ROLE.color = Color(209, 43, 39, 255)

	ROLE.abbr = "traitor"

	ROLE.defaultTeam = TEAM_TRAITOR
	ROLE.defaultEquipment = TRAITOR_EQUIPMENT

	ROLE.visibleForTraitors = true -- just for a better performance
	ROLE.builtin = true
	ROLE.surviveBonus = 0.5
	ROLE.scoreKillsMultiplier = 5
	ROLE.scoreTeamKillsMultiplier = -16
	ROLE.fallbackTable = {}

	-- conVarData
	ROLE.conVarData = {
		pct = 0.4,
		maximum = 32,
		minPlayers = 1
	}
end