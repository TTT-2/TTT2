local net = net

local plymeta = FindMetaTable("Player")
if not plymeta then
	Error("FAILED TO FIND PLAYER TABLE")

	return
end

---
-- Applies a animation gesture
-- @param ACT act The @{ACT} or sequence that should be played
-- @param number weight The weight this slot should be set to. Value must be ranging from 0 to 1.
-- @realm client
-- @see https://wiki.garrysmod.com/page/Player/AnimRestartGesture
-- @see https://wiki.garrysmod.com/page/Player/AnimSetGestureWeight
function plymeta:AnimApplyGesture(act, weight)
	self:AnimRestartGesture(GESTURE_SLOT_CUSTOM, act, true) -- true = autokill
	self:AnimSetGestureWeight(GESTURE_SLOT_CUSTOM, weight)
end

local function MakeSimpleRunner(act)
	return function(ply, w)
		-- just let this gesture play itself and get out of its way
		if w == 0 then
			ply:AnimApplyGesture(act, 1)

			return 1
		else
			return 0
		end
	end
end

-- act -> gesture runner fn
local act_runner = {
	-- ear grab needs weight control
	-- sadly it's currently the only one
	[ACT_GMOD_IN_CHAT] = function(ply, w)
		local dest = ply:IsSpeaking() and 1 or 0

		w = math.Approach(w, dest, FrameTime() * 10)
		if w > 0 then
			ply:AnimApplyGesture(ACT_GMOD_IN_CHAT, w)
		end

		return w
	end
}

-- Insert all the "simple" gestures that do not need weight control
local gestTbl = {
	ACT_GMOD_GESTURE_AGREE,
	ACT_GMOD_GESTURE_DISAGREE,
	ACT_GMOD_GESTURE_WAVE,
	ACT_GMOD_GESTURE_BECON,
	ACT_GMOD_GESTURE_BOW,
	ACT_GMOD_TAUNT_SALUTE,
	ACT_GMOD_TAUNT_CHEER,
	ACT_SIGNAL_FORWARD,
	ACT_SIGNAL_HALT,
	ACT_SIGNAL_GROUP,
	ACT_GMOD_GESTURE_ITEM_PLACE,
	ACT_GMOD_GESTURE_ITEM_DROP,
	ACT_GMOD_GESTURE_ITEM_GIVE
}

for _i = 1, #gestTbl do
	local a = gestTbl[_i]

	act_runner[a] = MakeSimpleRunner(a)
end

---
-- @realm client
local cv_ttt_show_gestures = CreateConVar("ttt_show_gestures", "1", FCVAR_ARCHIVE)

---
-- Perform the gesture using the GestureRunner system. If custom_runner is
-- non-nil, it will be used instead of the default runner for the act.
-- @param ACT act The @{ACT} or sequence that should be played
-- @param table custom_runner
-- @return boolean success?
-- @realm client
function plymeta:AnimPerformGesture(act, custom_runner)
	if not cv_ttt_show_gestures or cv_ttt_show_gestures:GetInt() == 0 then return end

	local runner = custom_runner or act_runner[act]
	if not runner then
		return false
	end

	self.GestureWeight = 0
	self.GestureRunner = runner

	return true
end

---
-- Perform a gesture update
-- @realm client
function plymeta:AnimUpdateGesture()
	if not self.GestureRunner then return end

	self.GestureWeight = self:GestureRunner(self.GestureWeight)

	if self.GestureWeight <= 0 then
		self.GestureRunner = nil
	end
end

---
-- @hook
-- @param Player ply The player to update the animation info for.
-- @param Vector vel The player's velocity.
-- @param number maxseqgroundspeed Speed of the animation - used for playback rate scaling.
-- @return any ?
-- @realm client
function GM:UpdateAnimation(ply, vel, maxseqgroundspeed)
	ply:AnimUpdateGesture()

	return self.BaseClass.UpdateAnimation(self, ply, vel, maxseqgroundspeed)
end

---
-- @param Player ply
-- @hook
-- @realm client
function GM:GrabEarAnimation(ply)

end

local function TTT_PerformGesture()
	local ply = net.ReadEntity()
	local act = net.ReadUInt(16)

	if not IsValid(ply) or act == nil then return end

	ply:AnimPerformGesture(act)
end
net.Receive("TTT_PerformGesture", TTT_PerformGesture)

local function StartDrowning()
	local client = LocalPlayer()
	if not IsValid(client) then return end

	local bool = net.ReadBool()

	client:StartDrowning(bool, bool and net.ReadUInt(16), bool and net.ReadUInt(16))
end
net.Receive("StartDrowning", StartDrowning)

local function TargetPlayer()
	local client = LocalPlayer()
	local target = net.ReadEntity()

	if not IsValid(client) then return end

	if not IsValid(target) or not target:IsPlayer() or target:IsWorld() then
		target = nil
	end

	if target == nil or IsValid(target) and target:IsActive() and target:Alive() then
		client:SetTargetPlayer(target)
	end
end
net.Receive("TTT2TargetPlayer", TargetPlayer)

---
-- SetupMove is called before the engine process movements. This allows us
-- to override the players movement.
-- @param Player ply The @{Player} that sets up its movement
-- @param MoveData mv The move data to override/use
-- @param CUserCmd cmd The command data
-- @hook
-- @realm client
-- @ref https://wiki.facepunch.com/gmod/GM:SetupMove
-- @local
function GM:SetupMove(ply, mv, cmd)
	if not IsValid(ply) or ply:IsReady() then return end

	ply.isReady = true

	net.Start("TTT2SetPlayerReady")
	net.SendToServer()

	---
	-- @realm shared
	hook.Run("TTT2PlayerReady", ply)

	-- check if a resolution change happened while
	-- the gamemode was inactive
	oldScrW = appearance.GetLastWidth()
	oldScrH = appearance.GetLastHeight()

	if oldScrH ~= ScrH() or oldScrW ~= ScrW() then
		---
		-- @realm client
		hook.Run("OnScreenSizeChanged", oldScrW, oldScrH)
	end
end

---
-- Sets a revival reason that is displayed in the revival HUD element.
-- It supports a language identifier for translated strings.
-- @param[default=nil] string name The text or the language identifer, nil to reset
-- @param[opt] table params The params table used for @{LANG.GetParamTranslation}
-- @realm client
function plymeta:SetRevivalReason(name, params)
	self.revivalReason = {}
	self.revivalReason.name = name
	self.revivalReason.params = params
end

net.Receive("TTT2SetRevivalReason", function()
	local client = LocalPlayer()

	if not IsValid(client) then return end

	local isReset = net.ReadBool()
	local name, params

	if not isReset then
		name = net.ReadString()

		local paramsAmount = net.ReadUInt(8)

		if paramsAmount > 0 then
			params = {}

			for i = 1, paramsAmount do
				params[net.ReadString()] = net.ReadString()
			end
		end
	end

	client:SetRevivalReason(name, params)
end)

-- plays an error sound only on the local player, not for all players
net.Receive("TTT2RevivalStopped", function()
	LocalPlayer():EmitSound("buttons/button8.wav")
end)

net.Receive("TTT2RevivalUpdate_IsReviving", function()
	LocalPlayer().isReviving = net.ReadBool()
end)

net.Receive("TTT2RevivalUpdate_IsBlockingRevival", function()
	LocalPlayer().isBlockingRevival = net.ReadBool()
end)

net.Receive("TTT2RevivalUpdate_RevivalStartTime", function()
	LocalPlayer().revivalStartTime = net.ReadFloat()
end)

net.Receive("TTT2RevivalUpdate_RevivalDuration", function()
	LocalPlayer().revivalDurarion = net.ReadFloat()
end)

---
-- Returns if a player has a revival reason set.
-- @return[default=false] boolean Returns if a player has a revival reason
-- @realm client
function plymeta:HasRevivalReason()
	return (self.revivalReason and self.revivalReason.name and self.revivalReason.name ~= "") or false
end

---
-- Returns the current revival reason.
-- @return[default={}] table The revival reason table
-- @realm client
function plymeta:GetRevivalReason()
	return self.revivalReason or {}
end
