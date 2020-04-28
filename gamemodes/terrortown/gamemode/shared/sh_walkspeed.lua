local plymeta = assert(FindMetaTable("Player"), "FAILED TO FIND ENTITY TABLE")

SPEED = SPEED or {}

if SERVER then
	---
	-- Sets the initial @{Player} speed multiplier, called in @{GM:TTTBeginRound} after (dumb) players
	-- are respawned.
	-- @realm server
	-- @internal
	function SPEED:InitPlayerSpeedMultiplier()
		local plys = player.GetAll()

		for i = 1, #plys do
			local ply = plys[i]

			ply:SetSpeedMultiplier(1.0)
		end
	end

	---
	-- Sets the speed multiplier to a fixed value
	-- @param number value The new value
	-- @realm server
	function plymeta:SetSpeedMultiplier(value)
		self:TTT2NETSetFloat("player_speed_multiplier", value)
	end

	---
	-- Increases the speed modifier by the given multiplier (the old value is multiplied with the new value)
	-- @param number value The multiplier
	-- @realm server
	function plymeta:GiveSpeedMultiplier(value)
		self:TTT2NETSetFloat("player_speed_multiplier", self:TTT2NETGetFloat("player_speed_multiplier", 1.0) * value)
	end

	---
	-- Decreases the speed modifier by the given multiplier (the old value is devided by the new value)
	-- @param number value The multiplier
	-- @realm server
	function plymeta:RemoveSpeedMultiplier(value)
		self:TTT2NETSetFloat("player_speed_multiplier", self:TTT2NETGetFloat("player_speed_multiplier", 1.0) / value)
	end
end

if CLIENT then
	---
	-- Initializes the speed system once the game is ready in @{GM:Initialize}
	-- @realm client
	function SPEED:Initialize()
		STATUS:RegisterStatus("ttt_walkspeed_status_good", {
			hud = {
				Material("vgui/ttt/perks/hud_speedrun.png")
			},
			type = "good",
			DrawInfo = function()
				return math.Round(LocalPlayer():GetSpeedMultiplier(), 1)
			end
		})

		STATUS:RegisterStatus("ttt_walkspeed_status_bad", {
			hud = {
				Material("vgui/ttt/perks/hud_speedrun.png")
			},
			type = "bad",
			DrawInfo = function()
				return math.Round(LocalPlayer():GetSpeedMultiplier(), 1)
			end
		})

		TTT2NET:OnUpdate("players", function(oldval, newval, reversePath)
			if reversePath[2] ~= "player_speed_multiplier" then return end

			if newval == 1.0 then
				STATUS:RemoveStatus("ttt_walkspeed_status_good")
				STATUS:RemoveStatus("ttt_walkspeed_status_bad")
			elseif newval > 1.0 and (not oldval or oldval <= 1.0) then
				STATUS:RemoveStatus("ttt_walkspeed_status_bad")
				STATUS:AddStatus("ttt_walkspeed_status_good")
			elseif newval < 1.0 and (not oldval or oldval >= 1.0) then
				STATUS:RemoveStatus("ttt_walkspeed_status_good")
				STATUS:AddStatus("ttt_walkspeed_status_bad")
			end
		end)
	end
end

---
-- Returns the current player speed modifier
-- @retrun number The speed modifier
-- @realm shared
function plymeta:GetSpeedMultiplier()
	return self:TTT2NETGetFloat("player_speed_multiplier", 1.0)
end
