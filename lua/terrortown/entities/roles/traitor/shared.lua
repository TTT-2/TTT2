ROLE.Base = "ttt_role_base"

ROLE.index = ROLE_TRAITOR

---
-- @ignore
function ROLE:PreInitialize()
	self.color = Color(209, 43, 39, 255)

	self.abbr = "traitor"

	self.builtin = true

	self.defaultTeam = TEAM_TRAITOR
	self.defaultEquipment = TRAITOR_EQUIPMENT
	self.score.surviveBonusMultiplier = 0.5
	self.score.timelimitMultiplier = -0.5
	self.score.killsMultiplier = 2
	self.score.teamKillsMultiplier = -16
	self.score.bodyFoundMuliplier = 0
	self.fallbackTable = {}

	-- conVarData
	self.conVarData = {
		pct = 0.4,
		maximum = 32,
		minPlayers = 1,
		traitorButton = 1
	}
end

if CLIENT then
	hook.Add("TTT2ModifyRoleSettingsMenu_Credits", "ttt2_add_role_menu_settings_traitor", function(role, roleData, parent)
		-- only detective (sub-)roles have this convar
		if role ~= ROLE_TRAITOR then return end

		parent:MakeSlider({
			serverConvar = "ttt_credits_detectivekill",
			label = "label_roles_credits_detectivekill",
			min = 0,
			max = 5,
			decimal = 0
		})
	end)
end
