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

if CLIENT then
	hook.Add("TTT2ModifyRoleSettingsMenu_Credits", "ttt2_add_role_menu_settings_detective", function(role, roleData, parent)
		-- only detective (sub-)roles have this convar
		if role ~= ROLE_DETECTIVE and roleData.baserole ~= ROLE_DETECTIVE then return end

		parent:MakeSlider({
			serverConvar = "ttt_" .. roleData.abbr .. "_credits_traitordead",
			label = "label_roles_credits_traitordead",
			min = 0,
			max = 10,
			decimal = 0
		})
	end)
end
