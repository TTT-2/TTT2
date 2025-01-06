---
-- A module that let's devs create marker visions for any entity that is automatically synced
-- between server and client and is tied to a player and their team
-- @author Mineotopia
-- @module markerVision

if SERVER then
    AddCSLuaFile()

    util.AddNetworkString("ttt2_marker_vision_entity_removed")
end

VISIBLE_FOR_PLAYER = 0
VISIBLE_FOR_ROLE = 1
VISIBLE_FOR_TEAM = 2
VISIBLE_FOR_ALL = 3

VISIBLE_FOR_BITS = 3

markerVision = {}

markerVision.registry = {}
markerVision.focussedMarkers = {}

---
-- Creates a new marker vision object for the entity.
-- @note This does not sync to the client, @{MARKER_VISION_ELEMENT:SyncToClients}
-- has to be called on it first
-- @param Entity ent The entity which should receive the marker vision element
-- @param string identifier The unique identifier of this marker vision element
-- @return MARKER_VISION_ELEMENT The marker vision object that was created
-- @realm shared
function markerVision.Add(ent, identifier)
    local _, index = markerVision.Get(ent, identifier)

    if index ~= -1 then
        table.remove(markerVision.registry, index)
    end

    local mvObject = table.Copy(MARKER_VISION_ELEMENT)
    mvObject:SetEnt(ent)
    mvObject:SetIdentifier(identifier)

    markerVision.registry[#markerVision.registry + 1] = mvObject

    return mvObject
end

---
-- Returns the marker vision element if it exists.
-- @param Entity ent The entity which should receive the marker vision element
-- @param string identifier The unique identifier of this marker vision element
-- @return MARKER_VISION_ELEMENT The marker vision object
-- @return number The position in the table, -1 if not found
-- @realm shared
function markerVision.Get(ent, identifier)
    for i = 1, #markerVision.registry do
        local mvObject = markerVision.registry[i]

        if mvObject:IsObjectFor(ent, identifier) then
            return mvObject, i
        end
    end

    return nil, -1
end

---
-- Removes the marker vision element if it exists.
-- @param Entity ent The entity which should receive the marker vision element
-- @note If called on the server, it is also removed on the client
-- @param string identifier The unique identifier of this marker vision element
-- @realm shared
function markerVision.Remove(ent, identifier)
    local _, index = markerVision.Get(ent, identifier)

    if index == -1 then
        return
    end

    table.remove(markerVision.registry, index)

    -- to simplify the networking and to prevent any artefacts due to
    -- role changes, a removal is broadcasted to everyone
    if SERVER then
        net.Start("ttt2_marker_vision_entity_removed")
        net.WriteEntity(ent)
        net.WriteString(identifier)
        net.Broadcast()
    end

    if CLIENT then
        marks.Remove({ ent })
    end
end

local entmeta = assert(FindMetaTable("Entity"), "[TTT2] FAILED TO FIND ENTITY TABLE")

---
-- Creates a new marker vision object for the entity.
-- @note This does not sync to the client, @{MARKER_VISION_ELEMENT:SyncToClients}
-- has to be called on it first
-- @param string identifier The unique identifier of this marker vision element
-- @return MARKER_VISION_ELEMENT The marker vision object that was created
-- @realm shared
function entmeta:AddMarkerVision(identifier)
    return markerVision.Add(self, identifier)
end

---
-- Returns the marker vision element if it exists.
-- @param string identifier The unique identifier of this marker vision element
-- @return MARKER_VISION_ELEMENT The marker vision object
-- @realm shared
function entmeta:GetMarkerVision(identifier)
    return markerVision.Get(self, identifier)
end

---
-- Removes the marker vision element if it exists.
-- @note If called on the server, it is also removed on the client
-- @param string identifier The unique identifier of this marker vision element
-- @realm shared
function entmeta:RemoveMarkerVision(identifier)
    markerVision.Remove(self, identifier)
end

if SERVER then
    ---
    -- Handles the update of the team of a player change. Is called internally and should
    -- probably not be called somewhere else.
    -- @param Entity ent The entity that should be updated
    -- @param string oldTeam The old team of the owner
    -- @param string newTeam The new team of the owner
    -- @internal
    -- @realm server
    function markerVision.PlayerUpdatedTeam(ply, oldTeam, newTeam)
        for i = 1, #markerVision.registry do
            local mvObject = markerVision.registry[i]
            local mvObjectData = mvObject.data

            if mvObjectData.visibleFor ~= VISIBLE_FOR_TEAM then
                continue
            end

            -- case 1: the owner is a player and they are the one that changed their team
            -- this means that the entity is taken to the new team
            if IsPlayer(mvObjectData.owner) and mvObjectData.owner == ply then
                -- nothing needs to be updated here, the new receiver list is generated
                -- in SyncToClients
                mvObject:SyncToClients()

                continue
            end

            -- case 2: it is bound to the team and the player's new/old team matches
            -- note: in this case the owner is no entity, but a team
            if mvObjectData.owner == oldTeam or mvObjectData.owner == newTeam then
                -- nothing needs to be updated here, the new receiver list is generated
                -- in SyncToClients
                mvObject:SyncToClients()

                continue
            end
        end
    end

    ---
    -- Handles the update of the role of a player change. Is called internally and should
    -- probably not be called somewhere else.
    -- @param Entity ent The entity that should be updated
    -- @param number oldRole The old role of the owner
    -- @param number newRole The new role of the owner
    -- @internal
    -- @realm server
    function markerVision.PlayerUpdatedRole(ply, oldRole, newRole)
        for i = 1, #markerVision.registry do
            local mvObject = markerVision.registry[i]
            local mvObjectData = mvObject.data

            if mvObjectData.visibleFor ~= VISIBLE_FOR_ROLE then
                continue
            end

            -- case 1: the owner is a player and they are the one that changed their role
            -- this means that the entity is taken to the new role
            if IsPlayer(mvObjectData.owner) and mvObjectData.owner == ply then
                -- nothing needs to be updated here, the new receiver list is generated
                -- in SyncToClients
                mvObject:SyncToClients()

                continue
            end

            -- case 2: it is bound to the role and the player's new/old role matches
            -- note: in this case the owner is no entity, but a role
            if mvObjectData.owner == oldRole or mvObjectData.owner == newRole then
                -- nothing needs to be updated here, the new receiver list is generated
                -- in SyncToClients
                mvObject:SyncToClients()

                continue
            end
        end
    end
end

if CLIENT then
    net.ReceiveStream("ttt2_marker_vision_entity", function(streamData)
        -- handle existing data on the client, the existing one will be updated
        if IsValid(markerVision.Get(streamData.ent, streamData.identifier)) then
            markerVision.Remove(streamData.ent, streamData.identifier)
        end

        local mvObject = markerVision.Add(streamData.ent, streamData.identifier)
        mvObject:SetOwner(streamData.owner)
        mvObject:SetVisibleFor(streamData.visibleFor)
        mvObject:SetColor(streamData.color)

        -- add mark to entity
        marks.Add({ streamData.ent }, mvObject:GetColor())
    end)

    net.Receive("ttt2_marker_vision_entity_removed", function()
        markerVision.Remove(net.ReadEntity(), net.ReadString())
    end)

    surface.CreateAdvancedFont(
        "RadarVision_Title",
        { font = "Tahoma", size = 20, weight = 600, extended = true }
    )
    surface.CreateAdvancedFont(
        "RadarVision_Subtitle",
        { font = "Tahoma", size = 17, weight = 300, extended = true }
    )
    surface.CreateAdvancedFont(
        "RadarVision_Text",
        { font = "Tahoma", size = 14, weight = 300, extended = true }
    )

    ---
    -- This gets the currently focussed closest entity.
    -- @realm client
    function markerVision.GetFocusedEntity()
        local closestEntTbl = markerVision.focussedMarkers[1] or {}

        for i = 2, #markerVision.focussedMarkers do
            local entTbl = markerVision.focussedMarkers[i]
            if entTbl.screenDistanceSquared < closestEntTbl.screenDistanceSquared then
                closestEntTbl = entTbl
            end
        end

        markerVision.focussedMarkers = { closestEntTbl }

        return closestEntTbl.entity
    end

    ---
    -- The draw function of the radar vision module.
    -- @internal
    -- @realm client
    function markerVision.Draw()
        local scale = appearance.GetGlobalScale()

        local padding = 4 * scale
        local paddingScreen = 10 * scale

        local sizeIcon = 28 * scale
        local sizeIconOffScreen = 22 * scale

        local offsetIcon = 0.5 * sizeIcon
        local offsetIconOffScreen = 0.5 * sizeIconOffScreen

        local sizeTitleIcon = 14 * scale
        local offsetTitleIcon = 0.5 * sizeTitleIcon

        local sizeSubtitleIcon = 12 * scale
        local offsetSubtitleIcon = 0.5 * sizeSubtitleIcon

        local offsetSubtitle = 8 * scale

        local heightLineDescription = 14 * scale

        local client = LocalPlayer()
        local widthScreen = ScrW()
        local heightScreen = ScrH()
        local xScreenCenter = 0.5 * widthScreen
        local yScreenCenter = 0.5 * heightScreen

        markerVision.focussedMarkers = {}

        for i = 1, #markerVision.registry do
            local mvObject = markerVision.registry[i]
            local ent = mvObject.data.ent

            if not IsValid(ent) then
                continue
            end

            local posEnt = ent:GetPos() + ent:OBBCenter()
            local screenPos = posEnt:ToScreen()
            local isOffScreen = util.IsOffScreen(screenPos)
            local screenDistSquared = (screenPos.x - xScreenCenter) ^ 2
                + (screenPos.y - yScreenCenter) ^ 2
            local isOnScreenCenter = not isOffScreen and screenDistSquared < offsetIcon ^ 2
            local distanceEntity = posEnt:Distance(client:EyePos())

            -- call internal targetID functions first so the data can be modified by addons
            local mvData = MARKER_VISION_DATA:Initialize(
                ent,
                isOffScreen,
                isOnScreenCenter,
                distanceEntity,
                mvObject
            )

            ---
            -- now run a hook that can be used by addon devs that changes the appearance
            -- of the radar vision
            -- @realm client
            hook.Run("TTT2RenderMarkerVisionInfo", mvData)

            local params = mvData.params

            if not params.drawInfo then
                continue
            end

            if isOnScreenCenter then
                markerVision.focussedMarkers[#markerVision.focussedMarkers + 1] = {
                    entity = ent,
                    screenDistanceSquared = screenDistSquared,
                }
            end

            local amountIcons = #params.displayInfo.icon

            if isOffScreen or not isOnScreenCenter then
                if amountIcons < 1 then
                    continue
                end

                local icon = params.displayInfo.icon[1]
                local color = icon.color or COLOR_WHITE

                if screenPos.x > 100000 then
                    screenPos.x = screenPos.x / 100000
                end

                if screenPos.y > 100000 then
                    screenPos.y = screenPos.y / 100000
                end

                screenPos.x = math.Clamp(
                    screenPos.x,
                    offsetIconOffScreen + paddingScreen,
                    widthScreen - offsetIconOffScreen - paddingScreen
                )
                screenPos.y = math.Clamp(
                    screenPos.y,
                    offsetIconOffScreen + paddingScreen,
                    heightScreen - offsetIconOffScreen - paddingScreen
                )

                draw.FilteredShadowedTexture(
                    screenPos.x - offsetIconOffScreen,
                    screenPos.y - offsetIconOffScreen,
                    sizeIconOffScreen,
                    sizeIconOffScreen,
                    icon.material,
                    color.a,
                    color
                )

                if not mvData:HasCollapsedLine() then
                    continue
                end

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

            screenPos.x = math.Round(
                math.Clamp(
                    screenPos.x,
                    offsetIcon + paddingScreen,
                    widthScreen - offsetIcon - paddingScreen
                )
            )
            screenPos.y = math.Round(
                math.Clamp(
                    screenPos.y,
                    offsetIcon + paddingScreen,
                    heightScreen - offsetIcon - paddingScreen
                )
            )

            -- draw Icons
            local xIcon, yIcon

            if amountIcons > 0 then
                xIcon = screenPos.x - offsetIcon
                yIcon = screenPos.y - offsetIcon

                for j = 1, amountIcons do
                    local icon = params.displayInfo.icon[j]
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

            -- check if a subtitle is set because that shifts multiple things around
            local hasSubtitle = mvData:HasSubtitle()

            -- draw title
            local stringTitle = params.displayInfo.title.text

            local xStringTitle = screenPos.x + offsetIcon + padding
            local yStringTitle = hasSubtitle and (screenPos.y - offsetSubtitle) or screenPos.y

            for j = 1, #params.displayInfo.title.icons do
                drawsc.FilteredShadowedTexture(
                    xStringTitle,
                    yStringTitle - offsetTitleIcon,
                    sizeTitleIcon,
                    sizeTitleIcon,
                    params.displayInfo.title.icons[j],
                    params.displayInfo.title.color.a,
                    params.displayInfo.title.color
                )

                xStringTitle = xStringTitle + sizeTitleIcon + 4 * scale
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

            -- draw subtitle
            if hasSubtitle then
                local stringSubtitle = params.displayInfo.subtitle.text

                local xStringSubtitle = xStringTitle
                local yStringSubtitle = screenPos.y + offsetSubtitle

                for j = 1, #params.displayInfo.subtitle.icons do
                    drawsc.FilteredShadowedTexture(
                        xStringSubtitle,
                        yStringSubtitle - offsetSubtitleIcon,
                        sizeSubtitleIcon,
                        sizeSubtitleIcon,
                        params.displayInfo.subtitle.icons[j],
                        params.displayInfo.subtitle.color.a,
                        params.displayInfo.subtitle.color
                    )

                    xStringSubtitle = xStringSubtitle + sizeSubtitleIcon + 4 * scale
                end

                drawsc.AdvancedShadowedText(
                    stringSubtitle,
                    "RadarVision_Subtitle",
                    xStringSubtitle,
                    yStringSubtitle,
                    params.displayInfo.subtitle.color,
                    TEXT_ALIGN_LEFT,
                    TEXT_ALIGN_CENTER
                )
            end

            -- draw description
            local linesDescription = params.displayInfo.desc
            local amountLinesDescription = #linesDescription

            local xStringDescription = screenPos.x + offsetIcon + padding

            for j = 1, amountLinesDescription do
                local text = linesDescription[j].text
                local icons = linesDescription[j].icons
                local color = linesDescription[j].color

                local xStringDescriptionShifted = xStringDescription
                local yStringDescription = yStringTitle
                    + j * heightLineDescription
                    + (hasSubtitle and 3 * offsetSubtitle or 0)

                for k = 1, #icons do
                    draw.FilteredShadowedTexture(
                        xStringDescriptionShifted,
                        yStringDescription - 13,
                        11,
                        11,
                        icons[k],
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
    function GM:TTT2RenderMarkerVisionInfo(mvData) end
end
