---
-- @author Mineotopia

-- Global to local variables
local util = util
local render = render
local surface = surface
local draw = draw
local math = math
local IsValid = IsValid
local hook = hook
local targetid = targetid
local playerGetAll = player.GetAll

---
-- Make sure local TargetID Variables are initialized
--@realm client
targetid.Initialize()

---
-- @realm client
local cvMinimalisticTid = CreateConVar("ttt_minimal_targetid", "0", FCVAR_ARCHIVE)

---
-- @realm client
local cvDrawHalo = CreateConVar("ttt_entity_draw_halo", "1", FCVAR_ARCHIVE)

---
-- @realm client
local cvEnableSpectatorsoutline =
    CreateConVar("ttt2_enable_spectatorsoutline", "1", { FCVAR_ARCHIVE, FCVAR_USERINFO })

---
-- @realm client
local cvEnableOverheadicons =
    CreateConVar("ttt2_enable_overheadicons", "1", { FCVAR_ARCHIVE, FCVAR_USERINFO })

surface.CreateAdvancedFont(
    "TargetID_Key",
    { font = "Tahoma", size = 26, weight = 900, extended = true }
)
surface.CreateAdvancedFont(
    "TargetID_Title",
    { font = "Tahoma", size = 20, weight = 900, extended = true }
)
surface.CreateAdvancedFont(
    "TargetID_Subtitle",
    { font = "Tahoma", size = 17, weight = 300, extended = true }
)
surface.CreateAdvancedFont(
    "TargetID_Description",
    { font = "Tahoma", size = 15, weight = 300, extended = true }
)

-- keep this font for compatibility reasons
surface.CreateFont("TargetIDSmall2", { font = "TargetID", size = 16, weight = 1000 })

-- cache colors
local colorKeyBack = Color(0, 0, 0, 150)

-- cached materials for overhead icons and outlines
local materialPropspecOutline = Material("models/props_combine/portalball001_sheet")
local materialBase = Material("vgui/ttt/dynamic/sprite_base")
local materialBaseOverlay = Material("vgui/ttt/dynamic/sprite_base_overlay")

local scaleFactorOverHeadIcon = 10
local sizeBaseOverHeadIcon = 10
local offsetOverHeadIcon = sizeBaseOverHeadIcon + 4

local scaleOverHeadIcon = 1 / scaleFactorOverHeadIcon
local sizeOverHeadIcon = scaleFactorOverHeadIcon * sizeBaseOverHeadIcon
local shiftOverHeadIcon = 0.5 * sizeBaseOverHeadIcon
local xShiftIconOverHeadIcon = 0.15 * sizeOverHeadIcon
local yShiftIconOverHeadIcon = 0.1 * sizeOverHeadIcon
local sizeIconOverHeadIcon = 0.7 * sizeOverHeadIcon

---
-- Function that handles the drawing of the overhead roleicons, it does not check whether
-- the icon should be drawn or not, that has to be handled prior to calling this function
-- @param Player client The client entity
-- @param Player ply The player to receive an overhead icon
-- @param Material iconRole The role icon that will be drawn
-- @param Color colorRole The role color for the background
-- @realm client
function DrawOverheadRoleIcon(client, ply, iconRole, colorRole)
    if not IsValid(client) or not IsValid(ply) then
        return
    end

    local ang = client:EyeAngles()
    local pos = ply:GetPos() + ply:GetHeadPosition()
    pos.z = pos.z + offsetOverHeadIcon

    local shift = Vector(0, shiftOverHeadIcon, 0)
    shift:Rotate(ang)
    pos:Add(shift)

    ang.pitch = 90
    ang:RotateAroundAxis(ang:Up(), 90)
    ang:RotateAroundAxis(ang:Right(), 180)

    cam.Start3D2D(pos, ang, scaleOverHeadIcon)
    draw.FilteredTexture(0, 0, sizeOverHeadIcon, sizeOverHeadIcon, materialBase, 255, colorRole)
    draw.FilteredTexture(
        0,
        0,
        sizeOverHeadIcon,
        sizeOverHeadIcon,
        materialBaseOverlay,
        255,
        COLOR_WHITE
    )
    draw.FilteredShadowedTexture(
        xShiftIconOverHeadIcon,
        yShiftIconOverHeadIcon,
        sizeIconOverHeadIcon,
        sizeIconOverHeadIcon,
        iconRole,
        255,
        util.GetDefaultColor(colorRole)
    )
    cam.End3D2D()
end

local function DistanceSorter(a, b)
    local clientPos = LocalPlayer():GetPos()

    return clientPos:Distance(a.ply:GetPos()) > clientPos:Distance(b.ply:GetPos())
end

---
-- Called after all translucent entities are drawn.
-- See also @{GM:PostDrawOpaqueRenderables} and @{GM:PreDrawTranslucentRenderables}.
-- @3D
-- @note using this hook instead of pre/postplayerdraw because playerdraw seems to
-- happen before certain entities are drawn, which then clip over the sprite
-- @param boolean bDrawingDepth Whether the current call is writing depth
-- @param boolean bDrawingSkybox Whether the current call is drawing skybox
-- @hook
-- @realm client
-- @ref https://wiki.facepunch.com/gmod/GM:PostDrawTranslucentRenderables
-- @local
function GM:PostDrawTranslucentRenderables(bDrawingDepth, bDrawingSkybox)
    local client = LocalPlayer()
    local clientTarget = client:GetObserverTarget()
    local clientObsMode = client:GetObserverMode()
    local plys = playerGetAll()

    if client:Team() == TEAM_SPEC and cvEnableSpectatorsoutline:GetBool() then
        cam.Start3D(EyePos(), EyeAngles())

        for i = 1, #plys do
            local ply = plys[i]
            local tgt = ply:GetObserverTarget()

            if IsValid(tgt) and tgt:GetNWEntity("spec_owner", nil) == ply then
                render.MaterialOverride(materialPropspecOutline)
                render.SuppressEngineLighting(true)
                render.SetColorModulation(1, 0.5, 0)

                tgt:SetModelScale(1.05, 0)
                tgt:DrawModel()

                render.SetColorModulation(1, 1, 1)
                render.SuppressEngineLighting(false)
                render.MaterialOverride(nil)
            end
        end

        cam.End3D()
    end

    -- OVERHEAD ICONS
    if not cvEnableOverheadicons:GetBool() then
        return
    end

    local plysWithIcon = {}

    for i = 1, #plys do
        local ply = plys[i]
        local roleData = ply:GetSubRoleData()

        local shouldDrawDefault = ply:IsActive()
            and ply:HasRole()
            and (not client:IsActive() or ply:IsInTeam(client) or roleData.isPublicRole)
            and not roleData.avoidTeamIcons
            and ply ~= client
            and not (
                clientTarget == ply
                and IsPlayer(clientTarget)
                and clientObsMode == OBS_MODE_IN_EYE
            )

        ---
        -- @realm client
        local shouldDraw, material, color =
            hook.Run("TTT2ModifyOverheadIcon", ply, shouldDrawDefault)

        if shouldDraw == false or not shouldDrawDefault then
            continue
        end

        plysWithIcon[#plysWithIcon + 1] = {
            ply = ply,
            material = material or roleData.iconMaterial,
            color = color or ply:GetRoleColor(),
        }
    end

    table.sort(plysWithIcon, DistanceSorter)

    for i = 1, #plysWithIcon do
        local plyWithIcon = plysWithIcon[i]

        DrawOverheadRoleIcon(client, plyWithIcon.ply, plyWithIcon.material, plyWithIcon.color)
    end
end

---
-- Spectator labels
local function DrawPropSpecLabels(client)
    if not client:IsSpec() and gameloop.GetRoundState() ~= ROUND_POST then
        return
    end

    local tgt, scrpos, color, _
    local plys = playerGetAll()

    for i = 1, #plys do
        local ply = plys[i]

        if ply:IsSpec() then
            color = COLOR_SPEC

            tgt = ply:GetObserverTarget()

            if IsValid(tgt) and tgt:GetNWEntity("spec_owner", nil) == ply then
                scrpos = tgt:GetPos():ToScreen()
            else
                scrpos = nil
            end
        else
            local clientTarget = client:GetObserverTarget()
            if ply == client or (clientTarget == ply and IsPlayer(clientTarget)) then
                continue
            end
            _, color = util.HealthToString(ply:Health(), ply:GetMaxHealth())

            scrpos = ply:EyePos()
            scrpos.z = scrpos.z + 20
            scrpos = scrpos:ToScreen()
        end

        if scrpos == nil or util.IsOffScreen(scrpos) then
            continue
        end

        draw.AdvancedText(
            ply:Nick(),
            "PureSkinMSTACKMsg",
            scrpos.x,
            scrpos.y,
            color,
            TEXT_ALIGN_CENTER,
            TEXT_ALIGN_CENTER,
            true,
            appearance.GetGlobalScale()
        )
    end
end

---
-- Called from @{GM:HUDPaint} to draw @{Player} info when you hover over a @{Player} with your crosshair or mouse.
-- @hook
-- @realm client
-- @ref https://wiki.facepunch.com/gmod/GM:HUDDrawTargetID
-- @local
function GM:HUDDrawTargetID()
    local client = LocalPlayer()

    ---
    -- @realm client
    if hook.Run("HUDShouldDraw", "TTTPropSpec") then
        DrawPropSpecLabels(client)
    end

    local ent, unchangedEnt, distance
    local startpos = client:EyePos()
    local direction = client:GetAimVector()
    local filter = client:GetObserverMode() == OBS_MODE_IN_EYE
            and { client, client:GetObserverTarget() }
        or client

    ent, distance = targetid.FindEntityAlongView(startpos, direction, filter)

    ---
    -- @realm client
    local changedEnt = hook.Run("TTTModifyTargetedEntity", ent, distance)

    if changedEnt then
        unchangedEnt = ent
        ent = changedEnt
    end

    -- make sure it is a valid entity
    if not IsValid(ent) or ent.NoTarget then
        return
    end

    -- if the entity also is a focused marker vision element, then targetID should be hidden
    if ent == markerVision.GetFocusedEntity() then
        return
    end

    -- call internal targetID functions first so the data can be modified by addons
    local tData = TARGET_DATA:Initialize(ent, unchangedEnt, distance)

    targetid.HUDDrawTargetIDSpawnEdit(tData)
    targetid.HUDDrawTargetIDTButtons(tData)
    targetid.HUDDrawTargetIDWeapons(tData)
    targetid.HUDDrawTargetIDPlayers(tData)
    targetid.HUDDrawTargetIDRagdolls(tData)
    targetid.HUDDrawTargetIDButtons(tData)
    targetid.HUDDrawTargetIDDoors(tData)
    targetid.HUDDrawTargetIDDNAScanner(tData)
    targetid.HUDDrawTargetIDVehicle(tData)

    -- add hints to the focused entity (deprecated method of adding stuff to targetID)
    local hint = ent.TargetIDHint

    if hint and hint.hint then
        tData:AddDescriptionLine(hint.fmt(ent, hint.hint), COLOR_LGRAY)
    end

    ---
    -- now run a hook that can be used by addon devs that changes the appearance
    -- of the targetid
    -- @realm client
    hook.Run("TTTRenderEntityInfo", tData)

    local data = tData.data
    local params = tData.params

    -- draws an outline around the entity if defined
    if params.drawOutline and cvDrawHalo:GetBool() then
        outline.Add(
            data.ent,
            appearance.SelectFocusColor(params.outlineColor),
            OUTLINE_MODE_VISIBLE
        )
    end

    if not params.drawInfo then
        return
    end

    -- render on display text
    local pad = 4
    local pad2 = pad * 2

    -- draw key and keybox
    -- the keyboxsize gets used as reference value since in most cases a key will be rendered
    -- therefore the key size gets calculated every time, even if no key is set
    local key_string =
        string.upper(params.displayInfo.key and input.GetKeyName(params.displayInfo.key) or "")

    local key_string_w, key_string_h = draw.GetTextSize(key_string, "TargetID_Key")

    local key_box_w = key_string_w + 5 * pad
    local key_box_h = key_string_h + pad2
    local key_box_x = params.refPosition.x - key_box_w - pad2 - 2 -- -2 because of border width
    local key_box_y = params.refPosition.y

    local key_string_x = key_box_x + math.Round(0.5 * key_box_w) - 1
    local key_string_y = key_box_y + math.Round(0.5 * key_box_h) - 1

    if params.displayInfo.key then
        drawsc.Box(key_box_x, key_box_y, key_box_w, key_box_h, colorKeyBack)

        drawsc.OutlinedShadowedBox(key_box_x, key_box_y, key_box_w, key_box_h, 1, COLOR_WHITE)
        drawsc.AdvancedShadowedText(
            key_string,
            "TargetID_Key",
            key_string_x,
            key_string_y,
            COLOR_WHITE,
            TEXT_ALIGN_CENTER,
            TEXT_ALIGN_CENTER
        )
    end

    -- draw icon
    local icon_amount = #params.displayInfo.icon
    local icon_x, icon_y

    if icon_amount > 0 then
        icon_x = params.refPosition.x - key_box_h - pad2
        icon_y = params.displayInfo.key and (key_box_y + key_box_h + pad2) or key_box_y + 1

        for i = 1, icon_amount do
            local icon = params.displayInfo.icon[i]
            local color = icon.color or COLOR_WHITE

            drawsc.FilteredShadowedTexture(
                icon_x,
                icon_y,
                key_box_h,
                key_box_h,
                icon.material,
                color.a,
                color
            )

            icon_y = icon_y + key_box_h
        end
    end

    -- draw title
    local title_string = params.displayInfo.title.text or ""

    local _, title_string_h = draw.GetTextSize(title_string, "TargetID_Title")

    local title_string_x = params.refPosition.x + pad2
    local title_string_y = key_box_y + title_string_h - 4

    for i = 1, #params.displayInfo.title.icons do
        drawsc.FilteredShadowedTexture(
            title_string_x,
            title_string_y - 16,
            14,
            14,
            params.displayInfo.title.icons[i],
            params.displayInfo.title.color.a,
            params.displayInfo.title.color
        )

        title_string_x = title_string_x + 18
    end

    drawsc.AdvancedShadowedText(
        title_string,
        "TargetID_Title",
        title_string_x,
        title_string_y,
        params.displayInfo.title.color,
        TEXT_ALIGN_LEFT,
        TEXT_ALIGN_BOTTOM
    )

    -- draw subtitle
    local subtitle_string = params.displayInfo.subtitle.text or ""

    local subtitle_string_x = params.refPosition.x + pad2
    local subtitle_string_y = key_box_y + key_box_h + 2

    for i = 1, #params.displayInfo.subtitle.icons do
        drawsc.FilteredShadowedTexture(
            subtitle_string_x,
            subtitle_string_y - 14,
            12,
            12,
            params.displayInfo.subtitle.icons[i],
            params.displayInfo.subtitle.color.a,
            params.displayInfo.subtitle.color
        )

        subtitle_string_x = subtitle_string_x + 16
    end

    drawsc.AdvancedShadowedText(
        subtitle_string,
        "TargetID_Subtitle",
        subtitle_string_x,
        subtitle_string_y,
        params.displayInfo.subtitle.color,
        TEXT_ALIGN_LEFT,
        TEXT_ALIGN_BOTTOM
    )

    -- in cvMinimalisticTid mode, no descriptions should be shown
    local desc_line_amount, desc_line_h = 0, 0

    if not cvMinimalisticTid:GetBool() then
        -- draw description text
        local desc_lines = params.displayInfo.desc

        local desc_string_x = params.refPosition.x + pad2
        local desc_string_y = key_box_y + key_box_h + 8 * pad
        desc_line_h = 17
        desc_line_amount = #desc_lines

        for i = 1, desc_line_amount do
            local text = desc_lines[i].text
            local icons = desc_lines[i].icons
            local color = desc_lines[i].color
            local desc_string_x_loop = desc_string_x

            for j = 1, #icons do
                drawsc.FilteredShadowedTexture(
                    desc_string_x_loop,
                    desc_string_y - 13,
                    11,
                    11,
                    icons[j],
                    color.a,
                    color
                )

                desc_string_x_loop = desc_string_x_loop + 14
            end

            drawsc.AdvancedShadowedText(
                text,
                "TargetID_Description",
                desc_string_x_loop,
                desc_string_y,
                color,
                TEXT_ALIGN_LEFT,
                TEXT_ALIGN_BOTTOM
            )
            desc_string_y = desc_string_y + desc_line_h
        end
    end

    -- draw spacer line
    local spacer_line_x = params.refPosition.x - 1
    local spacer_line_y = key_box_y

    local spacer_line_icon_l = (icon_y and icon_y or spacer_line_y) - spacer_line_y
    local spacer_line_text_l = key_box_h
        + ((desc_line_amount > 0) and (4 * pad + desc_line_h * desc_line_amount - 3) or 0)

    local spacer_line_l = (spacer_line_icon_l > spacer_line_text_l) and spacer_line_icon_l
        or spacer_line_text_l

    drawsc.ShadowedBox(spacer_line_x, spacer_line_y, 1, spacer_line_l, COLOR_WHITE)
end

---
-- Add targetID info to a focused entity.
-- @param TARGET_DATA tData The @{TARGET_DATA} data object which contains all information
-- @hook
-- @realm client
function GM:TTTRenderEntityInfo(tData) end

---
-- Change the focused entity used for targetID.
-- @param Entity ent The focuces entity that should be changed
-- @param number distance The distance to the focused entity
-- @return Entity The new entity to replace the real one
-- @hook
-- @realm client
function GM:TTTModifyTargetedEntity(ent, distance) end

---
-- Change the starting position for the trace that looks for entites.
-- @param Vector startpos The current startpos of the trace to find an entity
-- @param Vector endpos The current endpos of the trace to find an entity
-- @return Vector, Vector The new startpos for the trace, the new endpos for the trace
-- @hook
-- @realm client
function GM:TTTModifyTargetTracedata(startpos, endpos) end

---
-- Can be used to modify, disable or add an overhead icon of a player.
-- @param Player ply The player whose overhead icon should be modified
-- @param boolean shouldDrawDefault Defines if the overhead icon would draw normally
-- @return boolean Return false to prevent overhead icon draw
-- @return Material The material for the overhead icon (normally the role icon)
-- @return Color The color of the overhead icon backdrop
-- @hook
-- @realm client
function GM:TTT2ModifyOverheadIcon(ply, shouldDrawDefault) end
