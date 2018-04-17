function GetTraitors()
   local trs = {}
   
   for _, v in ipairs(player.GetAll()) do
      if v:HasTeamRole(TEAM_TRAITOR) then 
         table.insert(trs, v) 
      end
   end

   return trs
end

function CountTraitors()
   return #GetTraitors() 
end

---- Role state communication

-- Send every player their role
local function SendPlayerRoles()
   for _, v in pairs(player.GetAll()) do
      if v ~= nil and IsValid(v) and v.GetRole then -- prevention
         net.Start("TTT_Role")
         net.WriteUInt(v:GetRole() - 1, ROLE_BITS)
         net.Send(v)
      end
   end
end

function SendRoleListMessage(role, role_ids, ply_or_rf)
   net.Start("TTT_RoleList")
   net.WriteUInt(role - 1, ROLE_BITS)

   -- list contents
   local num_ids = #role_ids

   net.WriteUInt(num_ids, 8)

   for i = 1, num_ids do
      net.WriteUInt(role_ids[i] - 1, 7)
   end

   if ply_or_rf then 
      net.Send(ply_or_rf)
   else 
      net.Broadcast() 
   end
end

function SendRoleList(role, ply_or_rf, pred)
   local role_ids = {}
   
   for _, v in pairs(player.GetAll()) do
      if v:IsRole(role) then
         if not pred or (pred and pred(v)) then
            table.insert(role_ids, v:EntIndex())
         end
      end
   end

   SendRoleListMessage(role, role_ids, ply_or_rf)
end

function SendTeamRoleList(team, ply_or_rf, pred)
   local role_ids = {}
   
   for _, v in pairs(GetTeamRoles(team)) do
      role_ids[v.index] = {}
   end
   
   for _, v in pairs(player.GetAll()) do
      if v:HasTeamRole(team) then
         if not pred or (pred and pred(v)) then
            if team == TEAM_TRAITOR and not v:GetRoleData().visibleForTraitors then
               table.insert(role_ids[GetTeamRoles(team)[1].index], v:EntIndex())
            else
               table.insert(role_ids[v:GetRole()], v:EntIndex())
            end
         end
      end
   end
   
   for k, v in pairs(role_ids) do
      if v ~= nil then
         SendRoleListMessage(k, role_ids[k], ply_or_rf)
      end
   end
end

function SendTeamRoleSilList(team, ply_or_rf, pred)
   local role_ids = {}
   
   for _, v in pairs(player.GetAll()) do
      if v:HasTeamRole(team) then
         if not pred or (pred and pred(v)) then
            table.insert(role_ids, v:EntIndex())
         end
      end
   end

   SendRoleListMessage(GetTeamRoles(team)[1].index, role_ids, ply_or_rf)
end

-- this is purely to make sure last round's traitors/dets ALWAYS get reset
-- not happy with this, but it'll do for now
function SendInnocentList()
   -- Send innocent and detectives a list of actual innocents + traitors, while
   -- sending traitors only a list of actual innocents.
   local tmp = {}

   for _, v in pairs(ROLES) do
      tmp[v.index] = {}
   end
   
   for _, v in pairs(player.GetAll()) do
      table.insert(tmp[v:GetRole()], v:EntIndex())
   end
   
   local mergedList = {}
   local mergedListForTraitor = {}
   
   for _, role in pairs(ROLES) do
      if role ~= ROLES.DETECTIVE then -- never reset detectives -- will be later
         table.Add(mergedList, tmp[role.index])
         
         -- maybe remove second check to enable traitors that other traitors cant see ?
         if not role.visibleForTraitors and role.team ~= TEAM_TRAITOR then -- prevent resetting visible players and traitors for traitors
            table.Add(mergedListForTraitor, tmp[role.index])
         end
      end
   end
   
   table.Shuffle(mergedList)
   table.Shuffle(mergedListForTraitor)
   
   -- traitors get actual innocent, so they do not reset their traitor mates to innocence
   SendRoleListMessage(ROLES.INNOCENT.index, mergedListForTraitor, GetRoleTeamFilter(TEAM_TRAITOR))
   
   local tmpList = {}
   
   for _, v in pairs(ROLES) do
      if v.team == TEAM_TRAITOR or v.specialRoleFilter then
         if not table.HasValue(tmpList, v.team) then
            table.insert(tmpList, v.team)
         end
      end
   end
   
   -- update everyone as innocent w/ traitors and roles with special role filtering
   SendRoleListMessage(ROLES.INNOCENT.index, mergedList, GetAllRolesFilterWOTeams(tmpList))
end

function SendVisibleForTraitorList()
   local visibleRoles = {}
   
   for _, v in pairs(ROLES) do
      if v.team ~= TEAM_TRAITOR and v.visibleForTraitors then
         table.insert(visibleRoles, v)
      end
   end

   local tmp = {}

   for _, v in pairs(visibleRoles) do
      tmp[v.index] = {}
   end
   
   for _, v in pairs(player.GetAll()) do
      local roleData = GetRoleByIndex(v:GetRole())
      
      if roleData.team ~= TEAM_TRAITOR and roleData.visibleForTraitors then
         table.insert(tmp[roleData.index], v:EntIndex())
      end
   end
   
   for _, v in pairs(visibleRoles) do
      SendRoleListMessage(v.index, tmp[v.index], GetRoleTeamFilter(TEAM_TRAITOR))
   end
end

function SendNetworkingRolesList(role, rolesTbl)
   local networkingRoles = {}
   
   for _, v in pairs(rolesTbl) do
      if v and table.HasValue(ROLES, v) then -- theoretically not necessary, but safety first
         table.insert(networkingRoles, v)
      end
   end

   local tmp = {}

   for _, v in pairs(networkingRoles) do
      tmp[v.index] = {}
   end
   
   for _, v in pairs(player.GetAll()) do
      local roleData = GetRoleByIndex(v:GetRole())
      
      if table.HasValue(networkingRoles, roleData) then
         table.insert(tmp[roleData.index], v:EntIndex())
      end
   end
   
   for _, v in pairs(networkingRoles) do
      SendRoleListMessage(v.index, tmp[v.index], GetRoleFilter(role))
   end
end

function SendConfirmedTraitors(ply_or_rf)
   SendTeamRoleSilList(TEAM_TRAITOR, ply_or_rf, function(p) 
      return p:GetNWBool("body_found") 
   end)
end

function SendConfirmedSpecial(role, ply_or_rf)
   SendRoleList(role, ply_or_rf, function(p) 
      return p:GetNWBool("body_found")
   end)
end

function SendFullStateUpdate()
   SendInnocentList()
   
   SendVisibleForTraitorList()
   
   -- easy role filtering method
   for _, v in pairs(ROLES) do
      if v.networkRoles then
         SendNetworkingRolesList(v.index, v.networkRoles)
      end
   end
   
   -- TODO: Improve, not resending if current data is consistent
   
   -- send every traitor the specific role of traitor mates
   --for _, v in pairs(GetTeamRoles(TEAM_TRAITOR)) do
   --   SendRoleList(v.index, GetRoleTeamFilter(TEAM_TRAITOR))
   --end
   -- tell traitors who is traitor
   -- SendTeamRoleList(TEAM_TRAITOR, GetRoleTeamFilter(TEAM_TRAITOR))
   -- not useful to sync confirmed traitors here, so following to prevent
   -- issue if traitor had been updated as inno
   for _, ply in pairs(player.GetAll()) do
      if not ply:GetRoleData().specialRoleFilter then
         if ply:HasTeamRole(TEAM_TRAITOR) then
            SendTeamRoleList(TEAM_TRAITOR, ply)
         else
            SendConfirmedTraitors(ply)
         end
      else
         hook.Run("TTT2_SpecialRoleFilter", ply)
      end
   end
   
   -- everyone should know who is detective
   SendRoleList(ROLES.DETECTIVE.index)
   
   -- update players at the end, because they were overwritten as innos, except traitors
   SendPlayerRoles()
end

function SendRoleReset(ply_or_rf)
   local plys = player.GetAll()

   net.Start("TTT_RoleList")
   net.WriteUInt(ROLES.INNOCENT.index - 1, ROLE_BITS)

   net.WriteUInt(#plys, 8)
   for _, v in pairs(plys) do
      net.WriteUInt(v:EntIndex() - 1, 7)
   end

   if ply_or_rf then 
      net.Send(ply_or_rf)
   else 
      net.Broadcast() 
   end
end

---- Console commands

local function request_rolelist(ply)
   -- Client requested a state update. Note that the client can only use this
   -- information after entities have been initialized (e.g. in InitPostEntity).
   if GetRoundState() ~= ROUND_WAIT then
      SendRoleReset(ply) -- reset every player for ply
      
      -- now everyone is inno
      SendVisibleForTraitorList()
   
      -- easy role filtering method
      for _, v in pairs(ROLES) do
         if v.networkRoles then
            SendNetworkingRolesList(v.index, v.networkRoles)
         end
      end
      
      -- just send detectives to all
      SendRoleList(ROLES.DETECTIVE.index, ply)

      -- update traitors
      if not ply:GetRoleData().specialRoleFilter then
         if ply:HasTeamRole(TEAM_TRAITOR) then
            SendTeamRoleList(TEAM_TRAITOR, ply)
         else
            SendConfirmedTraitors(ply)
         end
      else
         hook.Run("TTT2_SpecialRoleFilter", ply)
      end
      
      -- update own role for ply
      if ply.GetRole then -- prevention
         net.Start("TTT_Role")
         net.WriteUInt(ply:GetRole() - 1, ROLE_BITS)
         net.Send(ply)
      end
   end
end
concommand.Add("_ttt_request_rolelist", request_rolelist)

-- override
local function force_terror(ply)
   ply:SetRole(ROLES.INNOCENT.index)
   ply:UnSpectate()
   ply:SetTeam(TEAM_TERROR)

   ply:StripAll()

   ply:Spawn()
   ply:PrintMessage(HUD_PRINTTALK, "You are now on the terrorist team.")

   SendFullStateUpdate()
end
concommand.Add("ttt_force_terror", force_terror, nil, nil, FCVAR_CHEAT)

-- override
local function force_traitor(ply)
   ply:SetRole(ROLES.TRAITOR.index)

   SendFullStateUpdate()
end
concommand.Add("ttt_force_traitor", force_traitor, nil, nil, FCVAR_CHEAT)

-- override
local function force_detective(ply)
   ply:SetRole(ROLES.DETECTIVE.index)

   SendFullStateUpdate()
end
concommand.Add("ttt_force_detective", force_detective, nil, nil, FCVAR_CHEAT)

local function force_role(ply, cmd, args, argStr)
   local role = tonumber(args[1])
   local i = 0
   
   for _, v in pairs(ROLES) do
      i = i + 1
   end
   
   if role ~= nil and role ~= 0 and role <= i then
      ply:SetRole(role)

      SendFullStateUpdate()

      ply:ChatPrint("You changed to '" .. GetRoleByIndex(role).printName .. "' (role: " .. role .. ")")
   end
end
concommand.Add("ttt_force_role", force_role, nil, nil, FCVAR_CHEAT)

local function get_role(ply)
   net.Start("TTT2_Test_role")
   net.Send(ply)
end
concommand.Add("get_role", get_role)

local function toggle_role(ply, cmd, args, argStr)
   if ply:IsAdmin() then
      local role = tonumber(args[1])
      local roleData = GetRoleByIndex(role)
      local currentState = not GetConVar("ttt_" .. roleData.name .. "_enabled"):GetBool()

      local word = currentState and "disabled" or "enabled"

      SetConVar("ttt_" .. roleData.name .. "_enabled"):SetBool(currentState)

      -- currently not necessary because [role].disabled is only relevant for the server
      --[[
      for _, p in pairs(player.GetAll()) do
         UpdateRoleData(p, false)
      end
      ]]--

      ply:ChatPrint("You " .. word .. " role with index '" .. role .. "(" .. roleData.printName .. ")'. This will take effect in the next role selection!")
   end
end
concommand.Add("ttt_toggle_role", toggle_role)

local function force_spectate(ply, cmd, arg)
   if IsValid(ply) then
      if #arg == 1 and tonumber(arg[1]) == 0 then
         ply:SetForceSpec(false)
      else
         if not ply:IsSpec() then
            ply:Kill()
         end

         GAMEMODE:PlayerSpawnAsSpectator(ply)
         
         ply:SetTeam(TEAM_SPEC)
         ply:SetForceSpec(true)
         ply:Spawn()

         ply:SetRagdollSpec(false) -- dying will enable this, we don't want it here
      end
   end
end
concommand.Add("ttt_spectate", force_spectate)

net.Receive("TTT_Spectate", function(l, pl)
   force_spectate(pl, nil, {net.ReadBool() and 1 or 0})
end)

local function roles_index(ply)
   if ply:IsAdmin() then
      ply:ChatPrint("[TTT2] roles_index...")
      ply:ChatPrint("----------------")
      ply:ChatPrint("[Role] | [Index]")
      
      for _, v in pairs(GetSortedRoles()) do
         ply:ChatPrint(v.printName .. " | " .. v.index)
      end
      
      ply:ChatPrint("----------------")
   end
end
concommand.Add("ttt_roles_index", roles_index)
