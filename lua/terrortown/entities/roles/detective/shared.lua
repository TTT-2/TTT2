ROLE.Base = "ttt_role_base"

ROLE.index = ROLE_DETECTIVE

---
-- @ignore
function ROLE:PreInitialize()
	self.color = Color(31, 77, 191, 255)

	self.abbr = "det"

	self.defaultTeam = TEAM_INNOCENT
	self.defaultEquipment = SPECIAL_EQUIPMENT

	self.score.killsMultiplier = 8
	self.score.teamKillsMultiplier = -8
	self.score.bodyFoundMuliplier = 3
	self.fallbackTable = {}
	self.unknownTeam = true

	-- conVarData
	self.conVarData = {
		pct = 0.13,
		maximum = 32,
		minPlayers = 8,
		minKarma = 600,

		credits = 1,
		creditsTraitorKill = 0,
		creditsTraitorDead = 1,

		togglable = true
	}
end

hook.Add("TTT2SpecialRoleSyncing", "TTT2DetectiveVisible", function(ply, target)
	if target:GetBaseRole() ~= ROLE_DETECTIVE then return end

	ply:TTT2NETSetUInt("subrole", ROLE_DETECTIVE, ROLE_BITS, target)
	ply:TTT2NETSetString("team", TEAM_INNOCENT, target)
end)
