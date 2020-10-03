ROLE.Base = "ttt_role_base"

ROLE.index = ROLE_NONE

function ROLE:PreInitialize()
	self.color = Color(91, 94, 99, 255)

	self.abbr = "none"

	self.defaultTeam = TEAM_NONE
	self.defaultEquipment = {}

	self.builtin = true
	self.scoreKillsMultiplier = 0
	self.scoreTeamKillsMultiplier = 0
	self.notSelectable = true
end
