ROLE.Base = "ttt_role_base"

ROLE.index = ROLE_TRAITOR

function ROLE:PreInitialize()
	self.color = Color(209, 43, 39, 255)

	self.abbr = "traitor"

	self.defaultTeam = TEAM_TRAITOR
	self.defaultEquipment = TRAITOR_EQUIPMENT

	self.visibleForTraitors = true -- just for a better performance
	self.builtin = true
	self.surviveBonus = 0.5
	self.scoreKillsMultiplier = 5
	self.scoreTeamKillsMultiplier = -16
	self.fallbackTable = {}

	-- conVarData
	self.conVarData = {
		pct = 0.4,
		maximum = 32,
		minPlayers = 1,
		traitorButton = 1
	}
end
