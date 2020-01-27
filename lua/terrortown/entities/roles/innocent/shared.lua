ROLE.Base = "ttt_role_base"

ROLE.index = ROLE_INNOCENT

function ROLE:PreInitialize()
	self.color = Color(80, 173, 59, 255)

	self.abbr = "inno"

	self.defaultTeam = TEAM_INNOCENT
	self.defaultEquipment = SPECIAL_EQUIPMENT

	self.builtin = true
	self.scoreKillsMultiplier = 1
	self.scoreTeamKillsMultiplier = -8
	self.unknownTeam = true
end
