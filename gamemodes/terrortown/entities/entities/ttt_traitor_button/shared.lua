--- Special button only for traitors and usable from range

ENT.Type = "anim"
ENT.Base = "base_anim"

function ENT:SetupDataTables()
  self:NetworkVar("Float", 0, "Delay")
  self:NetworkVar("Float", 1, "NextUseTime")
  self:NetworkVar("Bool", 0, "Locked")
  self:NetworkVar("String", 0, "Description")
  self:NetworkVar("String", 1, "Role")
  self:NetworkVar("String", 2, "Team")
  self:NetworkVar("Int", 0, "UsableRange", {KeyName = "UsableRange"})
end

function ENT:IsUsable()
  return not self:GetLocked() and self:GetNextUseTime() < CurTime()
end

---
-- Returns whether the role can use this specific button
-- @param table roleData role table
-- @return boolean
-- @realm shared
function ENT:RoleCanUse(roleData)
  local role = self:GetRole()
  local team = self:GetTeam()

  return (role == "none" or role == roleData.name) and (team == "none" or team == roleData.defaultTeam)
end
