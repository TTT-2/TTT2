---
-- A module that let's devs create bomb visions for any entity that is automatically synced
-- between server and client and is tied to a player and their team
-- @author Mineotopia
-- @module bombVision

if SERVER then
	AddCSLuaFile()

	util.AddNetworkString("ttt2_register_entity_added")
	util.AddNetworkString("ttt2_register_entity_removed")
end

VISIBLE_FOR_PLAYER = 0
VISIBLE_FOR_TEAM = 1
VISIBLE_FOR_ALL = 2

VISIBLE_FOR_BITS = 3

bombVision = {}

bombVision.registry = {}

function bombVision.RegisterEntity(ent, owner, visibleFor, color, receiverList, passThroughData)
	bombVision.registry[ent] = {
		owner = owner,
		visibleFor = visibleFor,
		color = color,
		data = passThroughData
	}

	if SERVER then
		local streamTable = {
			ent = ent,
			owner = owner,
			visibleFor = visibleFor,
			color = color,
			data = passThroughData
		}

		local receiver

		if visibleFor == VISIBLE_FOR_PLAYER then
			receiver = owner
		elseif visibleFor == VISIBLE_FOR_TEAM then
			receiver = GetTeamFilter(owner:GetTeam(), false, true)
		end

		net.SendStream("ttt2_register_entity_added", streamTable, receiverList or receiver)
	end

	if CLIENT then
		if visibleFor == VISIBLE_FOR_ALL then
			color = color or TEAMS[TEAM_INNOCENT].color
		else
			color = color or TEAMS[LocalPlayer():GetTeam()].color
		end

		marks.Add({ent}, color)
	end
end

function bombVision.RemoveEntity(ent, receiverList)
	if not IsValid(ent) then return end

	local owner = bombVision.registry[ent].owner
	local visibleFor = bombVision.registry[ent].visibleFor

	bombVision.registry[ent] = nil

	if SERVER then
		if visibleFor == VISIBLE_FOR_PLAYER then
			net.Send(owner)
		elseif visibleFor == VISIBLE_FOR_TEAM then
			net.Send(receiverList or GetTeamFilter(owner:GetTeam(), false, true))
		elseif visibleFor == VISIBLE_FOR_ALL then
			net.Broadcast()
		end
	end

	if CLIENT then
		marks.Remove({ent})
	end
end

function bombVision.UpdateEntity(ent, owner, visibleFor)
	if not bombVision.registry[ent] then return end

	owner = owner or bombVision.registry[ent].owner
	visibleFor = visibleFor or bombVision.registry[ent].visibleFor

	bombVision.RemoveEntity(ent)
	bombVision.RegisterEntity(ent, owner, visibleFor)
end

function bombVision.UpdateEntityOwnerTeam(ent, oldTeam, newTeam)
	if not bombVision.registry[ent] or bombVision.registry[ent].visibleFor ~= VISIBLE_FOR_TEAM then return end

	local owner = bombVision.registry[ent].owner
	local oldTeamPlys = GetTeamFilter(oldTeam)
	oldTeamPlys[#oldTeamPlys + 1] = owner

	bombVision.RemoveEntity(ent, oldTeamPlys)
	bombVision.RegisterEntity(ent, owner, VISIBLE_FOR_TEAM, TEAMS[newTeam].color, GetTeamFilter(newTeam, false, true))
end

if SERVER then
	function bombVision.PlayerUpdatedTeam(ply, oldTeam, newTeam)
		for ent, data in pairs(bombVision.registry) do
			print(ent)
			if data.owner ~= ply or data.visibleFor ~= VISIBLE_FOR_TEAM then continue end

			bombVision.UpdateEntityOwnerTeam(ent, oldTeam, newTeam)
		end
	end
end

if CLIENT then
	net.ReceiveStream("ttt2_register_entity_added", function(streamData)
		bombVision.RegisterEntity(streamData.ent, streamData.owner, streamData.visibleFor, streamData.color, nil, streamData.data)
	end)

	net.Receive("ttt2_register_entity_removed", function()
		bombVision.RemoveEntity(net.ReadEntity())
	end)

	function bombVision.Draw()
		for ent, data in pairs(bombVision.registry) do
			if not IsValid(ent) then continue end

			local screenPos = ent:GetPos():ToScreen()
			local isOffScreen = util.IsOffScreen(screenPos)

			screenPos.x = math.Clamp(screenPos.x, 0, ScrW())
			screenPos.y = math.Clamp(screenPos.y, 0, ScrH())

			draw.Box(screenPos.x, screenPos.y, 20, 20, COLOR_BLACK)
		end
	end
end
