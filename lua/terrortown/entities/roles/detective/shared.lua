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

	self.isPublicRole = true

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
	---
	-- @ignore
	function ROLE:AddToSettingsMenuCreditsForm(parent)
		parent:MakeSlider({
			serverConvar = "ttt_det_credits_traitordead",
			label = "label_roles_credits_traitordead",
			min = 0,
			max = 10,
			decimal = 0
		})
	end

	---
	-- @ignore
	function ROLE:AddToSettingsMenu(parent)
		local form = vgui.CreateTTT2Form(parent, "header_roles_additional")

		form:MakeCheckBox({
			serverConvar = "ttt_detective_hats",
			label = "label_detective_hats"
		})
	end
end
