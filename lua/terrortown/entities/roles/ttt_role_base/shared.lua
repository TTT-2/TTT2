---
-- @author Alf21
-- @author saibotk
-- @author Mineotopia
-- @class ROLE

ROLE.isAbstract = true

ROLE.score = {
    -- The multiplier that is used to calculate the score penalty
    -- that is added if this role kills a team member.
    teamKillsMultiplier = 0,

    -- The multiplier that is used to calculate the gained score
    -- by killing someone from a different team.
    killsMultiplier = 0,

    -- The amount of score points gained by confirming a body.
    bodyFoundMuliplier = 1,

    -- The amount of score points gained by surviving a round,
    -- based on the amount of dead enemy players. Only applied when
    -- in winning team.
    surviveBonusMultiplier = 0,

    -- The amount of score point lost by surviving a round, based
    -- on the amount of surviving team players. Only applied when
    -- not in winning team.
    survivePenaltyMultiplier = 0,

    -- The amount of score points granted due to a survival of the
    -- round for every teammate alive.
    aliveTeammatesBonusMultiplier = 1,

    -- Multiplier for a score for every player alive at the end of
    -- the round. Can be negative for roles that should kill everyone.
    allSurviveBonusMultiplier = 0,

    -- The amount of score points gained by being alive if the
    -- round ended with nobody winning, usually a negative number.
    timelimitMultiplier = 0,

    -- The amount of score points gained by killing yourself. Should be a
    -- negative number for most roles.
    suicideMultiplier = -1,

    -- The amount of score points gained when your team wins.
    winMultiplier = 3,
}

ROLE.karma = {
    -- The multiplier that is used to calculate the Karma penalty for a team kill.
    -- Keep in mind that the game will increase the multiplier further if it was avoidable
    -- like a kill on a public policing role.
    teamKillPenaltyMultiplier = 1,

    -- The multiplier that is used to calculate the Karma penalty for team damage.
    -- Keep in mind that the game will increase the multiplier further if it was avoidable
    -- like damage applied to a public policing role.
    teamHurtPenaltyMultiplier = 1,

    -- The multiplier that is used to change the Karma given to the killer if a player
    -- from an enemy team is killed.
    enemyKillBonusMultiplier = 1,

    -- The multiplier that is used to change the Karma given to the attacker if a player
    -- from an enemy team is damaged.
    enemyHurtBonusMultiplier = 1,
}

ROLE.conVarData = {
    -- The percentage of players that get this role.
    pct = 0.4,

    -- The maximum amount of players that get this role.
    maximum = 32,

    -- The minimum amount of players that have to be available fot this role to be selected.
    minPlayers = 1,

    -- The minimum amount of Karma needed for selection.
    minKarma = 0,

    -- Defines if the role has access to traitor buttons.
    traitorButton = 0,

    -- Sets the amount of credits the role is starting with.
    credits = 0,

    -- Defines if this role gains credits if a certain percentage of players
    -- from other teams is dead.
    creditsAwardDeadEnable = 0,

    -- Defines if this role is awarded with credits for the kill of a high profile.
    -- policing role, such as a detective.
    creditsAwardKillEnable = 0,

    -- Sets the shop for this role, by default roles have no shop set.
    shopFallback = SHOP_DISABLED,
}

-- This role variable makes the role unselectable if set to true. This might be
-- useful for roles that are applied during a round and not in the initial role
-- selection process.
ROLE.notSelectable = false

-- This variable can be used to add teams that can see the role of the
-- player with the role defined in this file. While this table can be updated
-- on runtime, it is strongly advised against. Use custom hook based
-- syncing for specific syncing.
ROLE.visibleForTeam = {}

-- This variable can be used to add roles that can can be seen by the role
-- defined in this file.
ROLE.networkRoles = {}

-- If set to true, this role doesn't know about their teammates. A normal innocent
-- for example knows that they are in team innocent, but doesn't know who else is.
-- If set to false, this player knows about the role of all their team mates.
ROLE.unknownTeam = false

-- This can be used to force prevent picking up credits from corpses. Keep in mind
-- that this only applies to shopping roles, as roles without a shop are unable to
-- pick up credits anyway.
ROLE.preventFindCredits = false

-- Normally a team can win if at least one role of the team is still alive, while no
-- other role that is able to win is alive. If this convar is set to true, this role
-- is unable to win by staying alive. A custom wincondition might be added.
ROLE.preventWin = false

-- If a player knows the role of their team mate, their role is shown overhead with
-- an icon. However this can be disabled with this role variable.
ROLE.avoidTeamIcons = false

-- Disables the sync of this role to the owner of the role. This means the owner doesn't
-- know about their own role. Should probably extended by custom role syncing.
ROLE.disableSync = false

-- Set this flag to true to make a role public known. This results in a
-- detective-like behavior.
ROLE.isPublicRole = false

-- A policing role is a role that works like a detective. They can be called to
-- a corpse and evil roles can be rewarded more points for them being killed.
ROLE.isPolicingRole = false

-- Omniscient roles are able to see missing in action players and therefore the haste
-- mode timer as well. This is mostly traitor-like behaviour.
ROLE.isOmniscientRole = false

-- If this is set to true, the role is unable to send messages in the team chat. If this is
-- set to false, it still could mean that the player is unable to use the team chat. If the
-- role flag `.unknownTeam` is set, the team chat can't be used either.
ROLE.disabledTeamChat = false

-- If this is set to true, the geiven role is unable to receive team chat messages.
ROLE.disabledTeamChatRecv = false

-- By setting this to true, the role is unable to write in the general chat.
ROLE.disabledGeneralChat = false

-- If this is set to true, the role is unable to speak in the team voice chat. If this is
-- set to false, it still could mean that the player is unable to use the team chat. If the
-- role flag `.unknownTeam` is set, the team chat can't be used either.
ROLE.disabledTeamVoice = false

-- If this is set to true, the given role is unable to hear team voice chat.
ROLE.disabledTeamVoiceRecv = false

---
-- This function is called before initializing a @{ROLE}, but after all
-- global variables like "ROLE_TRAITOR" have been initialized.
-- Use this function to define role attributes, which is dependant on other
-- global variables (eg. from other roles).
-- This is mostly used to register the defaultTeam, shopFallback, etc...
-- @hook
-- @realm shared
function ROLE:PreInitialize() end

---
-- This function is called after all roles have been loaded with their
-- ConVars, that are created for each role automatically, and their global
-- variables.
-- Please use this function to register your SubRole with the BaseRole, by
-- calling @{roles.SetBaseRole} and initialize any other needed data
-- (eg. @{LANG} function calls).
-- @hook
-- @realm shared
function ROLE:Initialize() end

---
-- Returns the starting credits of a @{ROLE} based on ConVar settings or default traitor settings
-- @return[default=0] number
-- @realm shared
function ROLE:GetStartingCredits()
    local cv = GetConVar("ttt_" .. self.abbr .. "_credits_starting")

    return cv and cv:GetInt() or 0
end

---
-- Returns whether a @{ROLE} is able to access the shop based on ConVar settings
-- @return[default=false] boolean
-- @realm shared
function ROLE:IsShoppingRole()
    if self.subrole == ROLE_NONE then
        return false
    end

    local shopFallback = GetGlobalString("ttt_" .. self.abbr .. "_shop_fallback")

    return shopFallback ~= SHOP_DISABLED
end

---
-- Returns whether a @{ROLE} is a BaseRole
-- @return boolean
-- @realm shared
function ROLE:IsBaseRole()
    return self.baserole == nil
end

---
-- Connects a SubRole with its BaseRole
-- @param ROLE baserole the BaseRole
-- @deprecated
-- @realm shared
function ROLE:SetBaseRole(baserole)
    ErrorNoHaltWithStack(
        "[TTT2][DEPRECATION] ROLE:SetBaseRole will be removed in the near future! You should call roles.SetBaseRole(self, ROLENAME) in the ROLE:Initialize() function!"
    )

    roles.SetBaseRole(self, baserole)
end

---
-- Returns the baserole of a specific @{ROLE}
-- @return number subrole id of the BaseRole (@{ROLE})
-- @realm shared
function ROLE:GetBaseRole()
    return self.baserole or self.index
end

---
-- Returns a list of subroles of this BaseRole (this subrole's BaseRole)
-- @return table list of @{ROLE}
-- @realm shared
function ROLE:GetSubRoles()
    local br = self:GetBaseRole()
    local tmp = {}
    local rlsList = roles.GetList()

    for k = 1, #rlsList do
        local v = rlsList[k]

        if v.baserole and v.baserole == br or v.index == br then
            tmp[#tmp + 1] = v
        end
    end

    return tmp
end

---
-- Returns whether a @{ROLE} can use traitor buttons.
-- @return boolean
-- @realm shared
function ROLE:CanUseTraitorButton()
    local cv = GetConVar("ttt_" .. self.name .. "_traitor_button")

    return cv and cv:GetBool() or false
end
