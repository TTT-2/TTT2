---
-- A module that let's devs create bomb visions for any entity that is automatically synced
-- between server and client and is tied to a player and their team
-- @author Mineotopia
-- @module radarVision

if SERVER then
	AddCSLuaFile()

	util.AddNetworkString("ttt2_register_entity_removed")
end

VISIBLE_FOR_PLAYER = 0
VISIBLE_FOR_TEAM = 1
VISIBLE_FOR_ALL = 2

VISIBLE_FOR_BITS = 3

radarVision = {}

radarVision.registry = {}

function radarVision.RegisterEntity(ent, owner, visibleFor, color, receiverList, passThroughData)
	if SERVER then
		local plysTeam = GetTeamFilter(owner:GetTeam(), true, true)

		if #plysTeam == 0 then -- happens for TEAM_NONE for example
			visibleFor = VISIBLE_FOR_PLAYER
		end

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
			receiver = plysTeam
		end

		-- note: when VISIBLE_FOR_ALL receiver is nil, therefore SendStream uses net.Boradcast
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

	radarVision.registry[ent] = {
		owner = owner,
		visibleFor = visibleFor,
		color = color,
		data = passThroughData
	}
end

function radarVision.RemoveEntity(ent, receiverList)
	if not IsValid(ent) or not radarVision.registry[ent] then return end

	local owner = radarVision.registry[ent].owner
	local visibleFor = radarVision.registry[ent].visibleFor

	radarVision.registry[ent] = nil

	if SERVER then
		net.Start("ttt2_register_entity_removed")
		net.WriteEntity(ent)

		if visibleFor == VISIBLE_FOR_PLAYER then
			net.Send(owner)
		elseif visibleFor == VISIBLE_FOR_TEAM then
			net.Send(receiverList or GetTeamFilter(owner:GetTeam(), true, true))
		elseif visibleFor == VISIBLE_FOR_ALL then
			net.Broadcast()
		end
	end

	if CLIENT then
		marks.Remove({ent})
	end
end

function radarVision.UpdateEntity(ent, owner, visibleFor)
	if not radarVision.registry[ent] then return end

	owner = owner or radarVision.registry[ent].owner
	visibleFor = visibleFor or radarVision.registry[ent].visibleFor

	radarVision.RemoveEntity(ent)
	radarVision.RegisterEntity(ent, owner, visibleFor)
end

function radarVision.UpdateEntityOwnerTeam(ent, oldTeam, newTeam)
	if not radarVision.registry[ent] or radarVision.registry[ent].visibleFor ~= VISIBLE_FOR_TEAM then return end

	local owner = radarVision.registry[ent].owner
	local oldTeamPlys = GetTeamFilter(oldTeam)
	oldTeamPlys[#oldTeamPlys + 1] = owner

	radarVision.RemoveEntity(ent, oldTeamPlys)
	radarVision.RegisterEntity(ent, owner, VISIBLE_FOR_TEAM, TEAMS[newTeam].color, GetTeamFilter(newTeam, false, true))
end

if SERVER then
	function radarVision.PlayerUpdatedTeam(ply, oldTeam, newTeam)
		for ent, data in pairs(radarVision.registry) do
			if data.visibleFor ~= VISIBLE_FOR_TEAM then continue end

			-- case 1: the owner of that targeted entity changed their team
			if data.owner ~= ply then continue end

			-- case 2: the old or the new team is the same team that the owner has
			if data.owner:GetTeam() ~= oldTeam and data.owner:GetTeam() ~= newTeam then continue end

			radarVision.UpdateEntityOwnerTeam(ent, oldTeam, newTeam)
		end
	end
end

if CLIENT then
	surface.CreateAdvancedFont("RadarVision_Title", { font = "Trebuchet24", size = 20, weight = 600 })
	surface.CreateAdvancedFont("BombVision_Text", { font = "Trebuchet24", size = 14, weight = 300 })

	net.ReceiveStream("ttt2_register_entity_added", function(streamData)
		radarVision.RegisterEntity(streamData.ent, streamData.owner, streamData.visibleFor, streamData.color, nil, streamData.data)
	end)

	net.Receive("ttt2_register_entity_removed", function()
		radarVision.RemoveEntity(net.ReadEntity())
	end)

	function radarVision.Draw()
		local scale = appearance.GetGlobalScale()

		local padding = 3 * scale

		local sizeIcon = 32 * scale
		local sizeIconOffScreen = 24 * scale

		local offsetIcon = 0.5 * sizeIcon
		local offsetIconOffScreen = 0.5 * sizeIconOffScreen

		local sizeTitleIcon = 14 * scale
		local offsetTitleIcon = 0.5 * sizeTitleIcon

		local heightLineDescription = 14 * scale

		for ent, data in pairs(radarVision.registry) do
			if not IsValid(ent) then continue end

			local screenPos = ent:GetPos():ToScreen()
			local isOffScreen = util.IsOffScreen(screenPos)
			local distanceEntity = ent:GetPos():Distance(LocalPlayer():EyePos())

			-- call internal targetID functions first so the data can be modified by addons
			local rData = RADAR_DATA:Initialize(ent, isOffScreen, distanceEntity)

			---
			-- now run a hook that can be used by addon devs that changes the appearance
			-- of the radar vision
			-- @realm client
			hook.Run("TTT2RenderRadarInfo", rData)

			local params = rData.params

			if not params.drawInfo then continue end

			local amountIcons = #params.displayInfo.icon

			if isOffScreen then
				if amountIcons < 1 then continue end

				local icon = params.displayInfo.icon[1]
				local color = icon.color or COLOR_WHITE

				screenPos.x = math.Clamp(screenPos.x, offsetIconOffScreen, ScrW() - offsetIconOffScreen)
				screenPos.y = math.Clamp(screenPos.y, offsetIconOffScreen, ScrH() - offsetIconOffScreen)

				draw.FilteredShadowedTexture(
					screenPos.x - offsetIconOffScreen,
					screenPos.y - offsetIconOffScreen,
					sizeIconOffScreen,
					sizeIconOffScreen,
					icon.material,
					color.a,
					color
				)

				return
			end

			-- draw Icons
			local xIcon, yIcon

			if amountIcons > 0 then
				xIcon = screenPos.x - offsetIcon
				yIcon = screenPos.y - offsetIcon

				for i = 1, amountIcons do
					local icon = params.displayInfo.icon[i]
					local color = icon.color or COLOR_WHITE

					draw.FilteredShadowedTexture(
						xIcon,
						yIcon,
						sizeIcon,
						sizeIcon,
						icon.material,
						color.a,
						color
					)

					yIcon = sizeIcon + padding
				end
			end

			-- draw title
			local stringTitle = params.displayInfo.title.text

			local xStringTitle = screenPos.x + offsetIcon + padding
			local yStringTitle = screenPos.y

			for i = 1, #params.displayInfo.title.icons do
				drawsc.FilteredShadowedTexture(
					xStringTitle,
					yStringTitle - offsetTitleIcon,
					sizeTitleIcon,
					sizeTitleIcon,
					params.displayInfo.title.icons[i],
					params.displayInfo.title.color.a,
					params.displayInfo.title.color
				)

				xStringTitle = xStringTitle + 18 * scale
			end

			draw.AdvancedText(
				stringTitle,
				"RadarVision_Title",
				xStringTitle,
				yStringTitle - 2 * scale,
				params.displayInfo.title.color,
				TEXT_ALIGN_LEFT,
				TEXT_ALIGN_CENTER,
				true,
				scale
			)

			-- draw description
			if util.HammerUnitsToMeters(distanceEntity) <= 15 then
				local linesDescription = params.displayInfo.desc
				local amountLinesDescription = #linesDescription

				local xStringDescription = screenPos.x + offsetIcon + padding

				for i = 1, amountLinesDescription do
					local text = linesDescription[i].text
					local icons = linesDescription[i].icons
					local color = linesDescription[i].color

					local xStringDescriptionShifted = xStringDescription
					local yStringDescription = yStringTitle + i * heightLineDescription

					for j = 1, #icons do
						draw.FilteredShadowedTexture(
							xStringDescriptionShifted,
							yStringDescription - 13,
							11,
							11,
							icons[j],
							color.a,
							color
						)

						xStringDescriptionShifted = xStringDescriptionShifted + 14
					end

					draw.AdvancedText(
						text,
						"BombVision_Text",
						xStringDescriptionShifted,
						yStringDescription,
						color,
						TEXT_ALIGN_LEFT,
						TEXT_ALIGN_CENTER,
						true,
						scale
					)

					yStringDescription = yStringDescription + heightLineDescription
				end
			else
				if not rData:HasCollapsedLine() then continue end

				draw.AdvancedText(
					params.displayInfo.collapsedLine.text,
					"BombVision_Text",
					screenPos.x + offsetIcon + padding,
					yStringTitle + heightLineDescription,
					params.displayInfo.collapsedLine.color,
					TEXT_ALIGN_LEFT,
					TEXT_ALIGN_CENTER,
					true,
					scale
				)
			end
		end
	end
end
