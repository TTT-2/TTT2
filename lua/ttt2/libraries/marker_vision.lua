---
-- A module that let's devs create bomb visions for any entity that is automatically synced
-- between server and client and is tied to a player and their team
-- @author Mineotopia
-- @module markerVision

if SERVER then
	AddCSLuaFile()

	util.AddNetworkString("ttt2_register_entity_removed")
end

VISIBLE_FOR_PLAYER = 0
VISIBLE_FOR_TEAM = 1
VISIBLE_FOR_ALL = 2

VISIBLE_FOR_BITS = 3

markerVision = {}

markerVision.registry = {}

---
-- Registers an entity that should be rendered on screen with a wallhack and an optional
-- UI element that works similar to targetID.
-- @param Entity ent The entity that should be rendered
-- @param Player owner The owner of the wallhack that takes their ownershipo with them on team change
-- @param number visibleFor Visibility setting: `VISIBLE_FOR_PLAYER`, `VISIBLE_FOR_TEAM`, `VISIBLE_FOR_ALL`
-- @param[opt] Color color The color of the wallhack, uses team color as fallback
-- @param[opt] table receiverList A list of players that should receive the netmessage, overwrites the default
-- @param[opt] any passThroughData any data that should be added to this radar vision, it is also synced to the client
-- @note Call on server to add entity on server and all defined clients.
-- @realm shared
function markerVision.RegisterEntity(ent, owner, visibleFor, color, receiverList, passThroughData)
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

	markerVision.registry[ent] = {
		owner = owner,
		visibleFor = visibleFor,
		color = color,
		data = passThroughData
	}
end

---
-- Returns the visibleFor flag for a provided entiy, nil if not set
-- @param Entity ent The tracked entity
-- @return number|nil The vibility flag
-- @realm shared
function markerVision.GetVisibleFor(ent)
	if not IsValid(ent) then return end

	return markerVision.registry[ent].visibleFor
end

---
-- Removes the entity from the radar vision table.
-- @param Entity ent The entity that should be removed
-- @param[opt] table receiverList A list of players that should receive the netmessage, overwrites the default
-- @note Call on server to remove entity on server and all defined clients.
-- @realm shared
function markerVision.RemoveEntity(ent, receiverList)
	if not IsValid(ent) or not markerVision.registry[ent] then return end

	local owner = markerVision.registry[ent].owner
	local visibleFor = markerVision.registry[ent].visibleFor

	markerVision.registry[ent] = nil

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

---
-- Updates the entity on the server and all related clients.
-- @param Entity ent The entity that should be updated
-- @param Player owner The owner of the wallhack that takes their ownershipo with them on team change
-- @param[opt] table receiverList A list of players that should receive the netmessage, overwrites the default
-- @note Call on server to add entity on server and all defined clients.
-- @realm shared
function markerVision.UpdateEntity(ent, owner, visibleFor)
	if not markerVision.registry[ent] then return end

	owner = owner or markerVision.registry[ent].owner
	visibleFor = visibleFor or markerVision.registry[ent].visibleFor

	markerVision.RemoveEntity(ent)
	markerVision.RegisterEntity(ent, owner, visibleFor)
end

---
-- Handles the update of the team of a player change.
-- @param Entity ent The entity that should be updated
-- @param string oldTeam The old team of the owner
-- @param string newTeam The new team of the owner
-- @realm shared
function markerVision.UpdateEntityOwnerTeam(ent, oldTeam, newTeam)
	if not markerVision.registry[ent] or markerVision.registry[ent].visibleFor ~= VISIBLE_FOR_TEAM then return end

	local owner = markerVision.registry[ent].owner
	local oldTeamPlys = GetTeamFilter(oldTeam)
	oldTeamPlys[#oldTeamPlys + 1] = owner

	markerVision.RemoveEntity(ent, oldTeamPlys)
	markerVision.RegisterEntity(ent, owner, VISIBLE_FOR_TEAM, TEAMS[newTeam].color, GetTeamFilter(newTeam, false, true))
end

if SERVER then
	---
	-- Handles the update of the team of a player change. Is called internally and should probably not be called somewhere else.
	-- @param Entity ent The entity that should be updated
	-- @param string oldTeam The old team of the owner
	-- @param string newTeam The new team of the owner
	-- @internal
	-- @realm server
	function markerVision.PlayerUpdatedTeam(ply, oldTeam, newTeam)
		for ent, data in pairs(markerVision.registry) do
			if data.visibleFor ~= VISIBLE_FOR_TEAM then continue end

			-- case 1: the owner of that targeted entity changed their team
			if data.owner ~= ply then continue end

			-- case 2: the old or the new team is the same team that the owner has
			if data.owner:GetTeam() ~= oldTeam and data.owner:GetTeam() ~= newTeam then continue end

			markerVision.UpdateEntityOwnerTeam(ent, oldTeam, newTeam)
		end
	end
end

if CLIENT then
	surface.CreateAdvancedFont("RadarVision_Title", { font = "Trebuchet24", size = 20, weight = 600 })
	surface.CreateAdvancedFont("RadarVision_Text", { font = "Trebuchet24", size = 14, weight = 300 })

	net.ReceiveStream("ttt2_register_entity_added", function(streamData)
		markerVision.RegisterEntity(streamData.ent, streamData.owner, streamData.visibleFor, streamData.color, nil, streamData.data)
	end)

	net.Receive("ttt2_register_entity_removed", function()
		markerVision.RemoveEntity(net.ReadEntity())
	end)

	---
	-- The draw function of the radar vision module.
	-- @internal
	-- @realm client
	function markerVision.Draw()
		local scale = appearance.GetGlobalScale()

		local padding = 3 * scale
		local paddingScreen = 10 * scale

		local sizeIcon = 28 * scale
		local sizeIconOffScreen = 22 * scale

		local offsetIcon = 0.5 * sizeIcon
		local offsetIconOffScreen = 0.5 * sizeIconOffScreen

		local sizeTitleIcon = 14 * scale
		local offsetTitleIcon = 0.5 * sizeTitleIcon

		local heightLineDescription = 14 * scale

		local client = LocalPlayer()
		local widthScreen = ScrW()
		local heightScreen = ScrH()
		local xScreenCenter = 0.5 * widthScreen
		local yScreenCenter = 0.5 * heightScreen

		for ent, data in pairs(markerVision.registry) do
			if not IsValid(ent) then continue end

			local posEnt = ent:GetPos() + ent:OBBCenter()
			local screenPos = posEnt:ToScreen()
			local isOffScreen = util.IsOffScreen(screenPos)
			local isOnScreenCenter = not isOffScreen
				and screenPos.x > xScreenCenter - offsetIcon and screenPos.x < xScreenCenter + offsetIcon
				and screenPos.y > yScreenCenter - offsetIcon and screenPos.y < yScreenCenter + offsetIcon
			local distanceEntity = posEnt:Distance(client:EyePos())

			-- call internal targetID functions first so the data can be modified by addons
			local mvData = MARKER_VISION_DATA:Initialize(ent, isOffScreen, isOnScreenCenter, distanceEntity)

			---
			-- now run a hook that can be used by addon devs that changes the appearance
			-- of the radar vision
			-- @realm client
			hook.Run("TTT2RenderMarkerVisionInfo", mvData)

			local params = mvData.params

			if not params.drawInfo then continue end

			local amountIcons = #params.displayInfo.icon

			if isOffScreen or not isOnScreenCenter then
				if amountIcons < 1 then continue end

				local icon = params.displayInfo.icon[1]
				local color = icon.color or COLOR_WHITE

				if screenPos.x > 100000 then
					screenPos.x = screenPos.x / 100000
				end

				if screenPos.y > 100000 then
					screenPos.y = screenPos.y / 100000
				end

				screenPos.x = math.Clamp(screenPos.x, offsetIconOffScreen + paddingScreen, widthScreen - offsetIconOffScreen - paddingScreen)
				screenPos.y = math.Clamp(screenPos.y, offsetIconOffScreen + paddingScreen, heightScreen - offsetIconOffScreen - paddingScreen)

				draw.FilteredShadowedTexture(
					screenPos.x - offsetIconOffScreen,
					screenPos.y - offsetIconOffScreen,
					sizeIconOffScreen,
					sizeIconOffScreen,
					icon.material,
					color.a,
					color
				)

				if not mvData:HasCollapsedLine() then continue end

				draw.AdvancedText(
					params.displayInfo.collapsedLine.text,
					"RadarVision_Text",
					screenPos.x + 1 * scale,
					screenPos.y + offsetIconOffScreen + padding,
					params.displayInfo.collapsedLine.color,
					TEXT_ALIGN_CENTER,
					TEXT_ALIGN_CENTER,
					true,
					scale
				)

				continue
			end

			screenPos.x = math.Clamp(screenPos.x, offsetIcon + paddingScreen, widthScreen - offsetIcon - paddingScreen)
			screenPos.y = math.Clamp(screenPos.y, offsetIcon + paddingScreen, heightScreen - offsetIcon - paddingScreen)

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
					"RadarVision_Text",
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
		end
	end

	---
	-- Add marker vision information that should be rendered on a marker vision object.
	-- @param MARKER_VISION_DATA mvData The @{MARKER_VISION_DATA} data object which contains all information
	-- @hook
	-- @realm client
	function GM:TTT2RenderMarkerVisionInfo(mvData)

	end
end
