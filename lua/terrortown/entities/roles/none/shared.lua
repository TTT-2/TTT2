ROLE.Base = "ttt_role_base"

ROLE.index = ROLE_NONE

---
-- @ignore
function ROLE:PreInitialize()
    self.color = COLOR_WARMGRAY

    self.abbr = "none"

    self.defaultTeam = TEAM_NONE
    self.defaultEquipment = {}

    self.builtin = true
    self.notSelectable = true
end
