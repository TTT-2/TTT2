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
	self.isPolicingRole = true

	-- conVarData
	self.conVarData = {
		pct = 0.13,
		maximum = 32,
		minPlayers = 8,
		minKarma = 600,

		credits = 1,
		creditsAwardDeadEnable = 1,
		creditsAwardKillEnable = 0,

		togglable = true
	}
end

if SERVER then
	function ROLE:GiveRoleLoadout(ply)
		ply:GiveEquipmentWeapon("weapon_ttt_wtester")
	end

	function ROLE:RemoveRoleLoadout(ply, isRoleChange)
		ply:RemoveEquipmentWeapon("weapon_ttt_wtester")
	end
else
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
