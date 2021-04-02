---
-- Voicechat popup
-- @module VOICE

DEFINE_BASECLASS("gamemode_base")

local GetTranslation = LANG.GetTranslation
local string = string
local math = math
local net = net
local player = player
local pairs = pairs
local timer = timer
local IsValid = IsValid
local hook = hook
local surface = surface

-- voicechat stuff
VOICE = {}

local VP_GREEN = Color(0, 200, 0)
local VP_RED = Color(200, 0, 0)
local MutedState

-- voice popups, copied from base gamemode and modified

g_VoicePanelList = nil

local function VoiceTryEnable()
	local client = LocalPlayer()

	---
	-- @realm client
	if hook.Run("TTT2CanUseVoiceChat", client, false) == false then
		return false
	end

	if not VOICE.IsSpeaking() and VOICE.CanSpeak() then
		VOICE.isTeam = false
		RunConsoleCommand("+voicerecord")

		return true
	end

	return false
end

local function VoiceTryDisable()
	if VOICE.IsSpeaking() and not VOICE.isTeam then
		RunConsoleCommand("-voicerecord")

		return true
	end

	return false
end

local function VoiceTeamTryEnable()
	local client = LocalPlayer()

	---
	-- @realm client
	if hook.Run("TTT2CanUseVoiceChat", client, true) == false then
		return false
	end

	if not IsValid(client) then return false end

	local clientrd = client:GetSubRoleData()
	local tm = client:GetTeam()

	if not VOICE.IsSpeaking() and VOICE.CanSpeak() and client:IsActive() and tm ~= TEAM_NONE
	and not TEAMS[tm].alone and not clientrd.unknownTeam and not clientrd.disabledTeamVoice then
		VOICE.isTeam = true
		RunConsoleCommand("+voicerecord")

		return true
	end

	return false
end

local function VoiceTeamTryDisable()
	if VOICE.IsSpeaking() and VOICE.isTeam then
		RunConsoleCommand("-voicerecord")

		return true
	end

	return false
end

-- register a binding for the general voicechat
bind.Register("ttt2_voice", VoiceTryEnable, VoiceTryDisable, "header_bindings_ttt2", "label_bind_voice", input.GetKeyCode(input.LookupBinding("+voicerecord") or KEY_X))

-- register a binding for the team voicechat
bind.Register("ttt2_voice_team", VoiceTeamTryEnable, VoiceTeamTryDisable, "header_bindings_ttt2", "label_bind_voice_team", input.GetKeyCode(input.LookupBinding("+speed") or KEY_LSHIFT))

-- 255 at 100
-- 5 at 5000
local function VoiceNotifyThink(pnl)
	local client = LocalPlayer()

	if not IsValid(pnl) or not IsValid(client) or not IsValid(pnl.ply)
	or not GetGlobalBool("ttt_locational_voice", false) or pnl.ply:IsSpec() or pnl.ply == client
	or client:IsActive() and pnl.ply:IsActive() and (
		client:IsInTeam(pnl.ply)
		and not pnl.ply:GetSubRoleData().unknownTeam
		and not pnl.ply:GetSubRoleData().disabledTeamVoice
		and not client:GetSubRoleData().disabledTeamVoiceRecv
	) then return end

	local d = client:GetPos():Distance(pnl.ply:GetPos())

	pnl:SetAlpha(math.max(-0.1 * d + 255, 15))
end

local PlayerVoicePanels = {}

---
-- Called when a @{Player} starts using voice chat.
-- @param Player ply @{Player} who started using voice chat
-- @hook
-- @realm client
-- @ref https://wiki.facepunch.com/gmod/GM:PlayerStartVoice
-- @local
function GM:PlayerStartVoice(ply)
	if not IsValid(ply) then return end

	local client = LocalPlayer()

	if not IsValid(g_VoicePanelList) or not IsValid(client) then return end

	-- There'd be an extra one if voice_loopback is on, so remove it.
	GAMEMODE:PlayerEndVoice(ply, true)

	-- Tell server this is global
	if client == ply then
		local tm = client:GetTeam()

		local isGlobal = not VOICE.isTeam
		client[tm .. "_gvoice"] = isGlobal

		net.Start("TTT2RoleGlobalVoice")
		net.WriteBool(isGlobal)
		net.SendToServer()

		VOICE.SetSpeaking(true)
	end

	local pnl = g_VoicePanelList:Add("VoiceNotify")
	pnl:Setup(ply)
	pnl:Dock(TOP)

	local oldThink = pnl.Think

	pnl.Think = function(s)
		oldThink(s)

		VoiceNotifyThink(s)
	end

	local shade = Color(0, 0, 0, 150)

	-- TODO recreate all voice panels on HUD switch
	local paintFn = function(s, w, h)
		if not IsValid(s.ply) then return end

		draw.RoundedBox(4, 0, 0, w, h, s.Color)
		draw.RoundedBox(4, 1, 1, w - 2, h - 2, shade)
	end

	if huds and HUDManager then
		local hud = huds.GetStored(HUDManager.GetHUD())
		if hud then
			paintFn = hud.VoicePaint or paintFn
		end
	end

	pnl.Paint = paintFn

	-- roles things
	local tm = client:GetTeam()
	local clrd = client:GetSubRoleData()

	if client:IsActive() and tm ~= TEAM_NONE and not clrd.unknownTeam and not clrd.disabledTeamVoice and not TEAMS[tm].alone then
		if ply == client then
			if not client[tm .. "_gvoice"] then
				pnl.Color = TEAMS[tm].color
			end
		elseif ply:IsInTeam(client) and not (ply:GetSubRoleData().disabledTeamVoice or clrd.disabledTeamVoiceRecv) then
			if not ply[tm .. "_gvoice"] then
				pnl.Color = TEAMS[tm].color
			end
		end
	end

	if ply:IsActive() and ply:GetBaseRole() == ROLE_DETECTIVE then
		pnl.Color = roles.DETECTIVE.color
	end

	---
	-- @realm client
	pnl.Color = hook.Run("TTT2ModifyVoiceChatColor", ply) or pnl.Color

	PlayerVoicePanels[ply] = pnl

	local plyrd = ply:GetSubRoleData()

	-- run ear gesture
	if not (ply:IsActive() and not plyrd.unknownTeam and not plyrd.disabledTeamVoice and not clrd.disabledTeamVoiceRecv) or (tm ~= TEAM_NONE and not TEAMS[tm].alone) and ply[tm .. "_gvoice"] then
		ply:AnimPerformGesture(ACT_GMOD_IN_CHAT)
	end
end

local function ReceiveVoiceState()
	local idx = net.ReadUInt(7) + 1 -- we -1 serverside
	local isGlobal = net.ReadBit() == 1

	-- prevent glitching due to chat starting/ending across round boundary
	if GAMEMODE.round_state ~= ROUND_ACTIVE then return end

	local lply = LocalPlayer()
	if not IsValid(lply) then return end

	local ply = player.GetByID(idx)

	if not IsValid(ply) or not ply.GetSubRoleData then return end

	local plyrd = ply:GetSubRoleData()

	if not ply:IsActive() or plyrd.unknownTeam or plyrd.disabledTeamVoice or lply:GetSubRoleData().disabledTeamVoiceRecv then return end

	local tm = ply:GetTeam()

	if tm == TEAM_NONE or TEAMS[tm].alone then return end

	ply[tm .. "_gvoice"] = isGlobal

	if not IsValid(PlayerVoicePanels[ply]) then return end

	PlayerVoicePanels[ply].Color = isGlobal and VP_GREEN or (ply:GetRoleColor() or VP_RED)
end
net.Receive("TTT_RoleVoiceState", ReceiveVoiceState)

local function VoiceClean()
	if not PlayerVoicePanels then return end

	for ply, pnl in pairs(PlayerVoicePanels) do
		if IsValid(pnl) and IsValid(ply) then continue end

		GAMEMODE:PlayerEndVoice(ply)
	end
end
timer.Create("VoiceClean", 10, 0, VoiceClean)

---
-- Called when @{Player} stops using voice chat.
-- @param Player ply @{Player} who stopped talking
-- @param boolean no_reset whether the stored voice state shouldn't reset
-- @hook
-- @realm client
-- @ref https://wiki.facepunch.com/gmod/GM:PlayerEndVoice
-- @local
function GM:PlayerEndVoice(ply, no_reset)
	if IsValid(PlayerVoicePanels[ply]) then
		PlayerVoicePanels[ply]:Remove()

		PlayerVoicePanels[ply] = nil
	end

	if IsValid(ply) and not no_reset then
		local tm = ply:GetTeam()

		if tm ~= TEAM_NONE and not TEAMS[tm].alone then
			ply[tm .. "_gvoice"] = false
		end
	end

	if ply == LocalPlayer() then
		VOICE.SetSpeaking(false)
	end
end

local function CreateVoiceVGUI()
	g_VoicePanelList = vgui.Create("DPanel")
	g_VoicePanelList:ParentToHUD()
	g_VoicePanelList:SetPos(25, 25)
	g_VoicePanelList:SetSize(200, ScrH() - 200)
	g_VoicePanelList:SetPaintBackground(false)

	MutedState = vgui.Create("DLabel")
	MutedState:SetPos(ScrW() - 200, ScrH() - 50)
	MutedState:SetSize(200, 50)
	MutedState:SetFont("Trebuchet18")
	MutedState:SetText("")
	MutedState:SetTextColor(Color(240, 240, 240, 250))
	MutedState:SetVisible(false)
end
hook.Add("InitPostEntity", "CreateVoiceVGUI", CreateVoiceVGUI)

--local MuteStates = {MUTE_NONE, MUTE_TERROR, MUTE_ALL, MUTE_SPEC}

local MuteText = {
	[MUTE_NONE] = "",
	[MUTE_TERROR] = "mute_living",
	[MUTE_ALL] = "mute_all",
	[MUTE_SPEC] = "mute_specs"
}

local function SetMuteState(state)
	if not MutedState then return end

	MutedState:SetText(string.upper(GetTranslation(MuteText[state])))
	MutedState:SetVisible(state ~= MUTE_NONE)
end

local mute_state = MUTE_NONE

---
-- Switches the mute state to the next in the list or to the given one
-- @param number force_state
-- @return number the new mute_state
-- @realm client
function VOICE.CycleMuteState(force_state)
	mute_state = force_state or next(MuteText, mute_state)

	if not mute_state then
		mute_state = MUTE_NONE
	end

	SetMuteState(mute_state)

	return mute_state
end

VOICE.battery_max = 100
VOICE.battery_min = 10

---
-- Initializes the voice battery
-- @realm client
function VOICE.InitBattery()
	LocalPlayer().voice_battery = VOICE.battery_max
end

local function GetRechargeRate()
	local r = GetGlobalFloat("ttt_voice_drain_recharge", 0.05)

	if LocalPlayer().voice_battery < VOICE.battery_min then
		r = r * 0.5
	end

	return r
end

local function GetDrainRate()
	local ply = LocalPlayer()

	if not IsValid(ply) or ply:IsSpec() or not GetGlobalBool("ttt_voice_drain", false) or GetRoundState() ~= ROUND_ACTIVE then
		return 0
	end

	if ply:IsAdmin() or ply:IsDetective() then
		return GetGlobalFloat("ttt_voice_drain_admin", 0)
	else
		return GetGlobalFloat("ttt_voice_drain_normal", 0)
	end
end

local function IsRoleChatting(ply)
	local tm = ply:GetTeam()
	local plyrd = ply:GetSubRoleData()

	return ply:IsActive()
	and not plyrd.unknownTeam
	and not plyrd.disabledTeamVoice
	and not LocalPlayer():GetSubRoleData().disabledTeamVoiceRecv
	and tm ~= TEAM_NONE and not TEAMS[tm].alone
	and not ply[tm .. "_gvoice"]
end

---
-- Updates the voice battery
-- @note Called every @{GM:Tick}
-- @realm client
-- @internal
function VOICE.Tick()
	if not GetGlobalBool("ttt_voice_drain", false) then return end

	local client = LocalPlayer()

	if VOICE.IsSpeaking() and not IsRoleChatting(client) then
		client.voice_battery = client.voice_battery - GetDrainRate()

		if not VOICE.CanSpeak() then
			client.voice_battery = 0

			RunConsoleCommand("-voicerecord")
		end
	elseif client.voice_battery < VOICE.battery_max then
		client.voice_battery = client.voice_battery + GetRechargeRate()
	end
end

---
-- Returns whether the local @{Player} is speaking
-- @note @{Player:IsSpeaking} does not work for local @{Player}
-- @return boolean
-- @realm client
function VOICE.IsSpeaking()
	return LocalPlayer().speaking
end

---
-- Sets whether the local @{Player} is speaking
-- @param boolean state
-- @realm client
function VOICE.SetSpeaking(state)
	LocalPlayer().speaking = state
end

---
-- Returns whether the local @{Player} is able to speak
-- @return boolean
-- @realm client
function VOICE.CanSpeak()
	if not GetGlobalBool("sv_voiceenable", true) then
		return false
	end

	if not GetGlobalBool("ttt_voice_drain", false) then
		return true
	end

	local client = LocalPlayer()

	return client.voice_battery > VOICE.battery_min or IsRoleChatting(client)
end

local speaker = surface.GetTextureID("voice/icntlk_sv")

---
-- Draws a popup displaying the speaking @{Player}s
-- @param Player client This should be the local @{Player}
-- @return boolean
-- @realm client
-- @internal
function VOICE.Draw(client)
	local b = client.voice_battery

	if not b or not VOICE.battery_max or b >= VOICE.battery_max then return end

	local x, y = 25, 10
	local w, h = 200, 6

	if b < VOICE.battery_min and CurTime() % 0.2 < 0.1 then
		surface.SetDrawColor(200, 0, 0, 155)
	else
		surface.SetDrawColor(0, 200, 0, 255)
	end

	surface.DrawOutlinedRect(x, y, w, h)

	surface.SetTexture(speaker)
	surface.DrawTexturedRect(5, 5, 16, 16)

	x = x + 1
	y = y + 1
	w = w - 2
	h = h - 2

	surface.SetDrawColor(0, 200, 0, 150)
	surface.DrawRect(x, y, w * math.Clamp((client.voice_battery - 10) / 90, 0, 1), h)
end
