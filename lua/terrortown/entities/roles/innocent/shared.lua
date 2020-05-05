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

if SERVER then
	local ttt_min_inno_pct = CreateConVar("ttt_min_inno_pct", "0.47", {FCVAR_NOTIFY, FCVAR_ARCHIVE}, "Minimum multiplicator for each player to calculate the minimum amount of innocents")

	---
	-- Returns the available amount of this role based on the given amount of available players
	-- @param number ply_count amount of available players
	-- @return number selectable amount of this role
	-- @realm server
	function ROLE:GetAvailableRoleCount(ply_count)
		return math.floor(ply_count * ttt_min_inno_pct:GetFloat())
	end
end
