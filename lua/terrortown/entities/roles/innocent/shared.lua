ROLE.Base = "ttt_role_base"

ROLE.index = ROLE_INNOCENT

function ROLE:PreInitialize()
	ROLE.color = Color(80, 173, 59, 255)

	ROLE.abbr = "inno"

	ROLE.defaultTeam = TEAM_INNOCENT
	ROLE.defaultEquipment = SPECIAL_EQUIPMENT

	ROLE.builtin = true
	ROLE.scoreKillsMultiplier = 1
	ROLE.scoreTeamKillsMultiplier = -8
	ROLE.unknownTeam = true
end
