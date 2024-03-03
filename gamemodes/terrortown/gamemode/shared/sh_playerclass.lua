DEFINE_BASECLASS("player_default")

local PLAYER = {}

PLAYER.WalkSpeed = 220
PLAYER.RunSpeed = 220
PLAYER.JumpPower = 160
PLAYER.CrouchedWalkSpeed = 0.3

-- This is needed to allow adding custom networked variables to the player entity
-- Can be useful for e.g. variables necessary for prediction like the stamina.
-- @realm shared
-- @internal
function PLAYER:SetupDataTables()
    self.Player:SetupDataTables()
end

player_manager.RegisterClass("player_ttt", PLAYER, "player_default")
