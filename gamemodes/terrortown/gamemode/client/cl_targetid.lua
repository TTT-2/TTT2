---
-- @author Mineotopia

-- Global to local variables
local util = util
local render = render
local surface = surface
local draw = draw
local GetPlayers = player.GetAll
local math = math
local table = table
local IsValid = IsValid
local hook = hook
local targetid = targetid

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
local cvEnableSpectatorsoutline = CreateConVar("ttt2_cvEnableSpectatorsoutline", "1", {FCVAR_ARCHIVE, FCVAR_USERINFO})

---
-- @realm client
local cvEnableOverheadicons = CreateConVar("ttt2_cvEnableOverheadicons", "1", {FCVAR_ARCHIVE, FCVAR_USERINFO})

surface.CreateAdvancedFont("TargetID_Key", {font = "Trebuchet24", size = 26, weight = 900})
surface.CreateAdvancedFont("TargetID_Title", {font = "Trebuchet24", size = 20, weight = 900})
surface.CreateAdvancedFont("TargetID_Subtitle", {font = "Trebuchet24", size = 17, weight = 300})
surface.CreateAdvancedFont("TargetID_Description", {font = "Trebuchet24", size = 15, weight = 300})

-- keep this font for compatibility reasons
surface.CreateFont("TargetIDSmall2", {font = "TargetID", size = 16, weight = 1000})

-- cache colors
local colorBlacktrans = Color(0, 0, 0, 180)
local colorKeyBack = Color(0, 0, 0, 150)

-- cached materials for overhead icons and outlines
local materialPropspecOutline = Material("models/props_combine/portalball001_sheet")
local materialBase = Material("vgui/ttt/dynamic/sprite_base")
local materialBaseOverlay = Material("vgui/ttt/dynamic/sprite_base_overlay")

---
-- Returns the localized ClassHint table
-- Access for servers to display hints using their own HUD/UI.
-- @return table
-- @hook
-- @realm client
function GM:GetClassHints()
	return ClassHint
end

---
-- Sets an index of the localized ClassHint table
-- @note Basic access for servers to add/modify hints. They override hints stored on
-- the entities themselves.
-- @param string cls
-- @param table hint
-- @hook
-- @realm client
-- @local
function GM:AddClassHint(cls, hint)
	ClassHint[cls] = table.Copy(hint)
end

---
-- Function that handles the drawing of the overhead roleicons, it does not check whether
-- the icon should be drawn or not, that has to be handled prior to calling this function
-- @param Player ply The player to receive an overhead icon
-- @param Material ricon
-- @param Color rcolor
-- @realm client
function DrawOverheadRoleIcon(ply, ricon, rcolor)
	local client = LocalPlayer()
	if ply == client then return end

	-- get position of player
	local pos = ply:GetPos()
	pos.z = pos.z + 80

	-- get eye angle of player
	local ea = ply:EyeAngles()
	ea.pitch = 0

	-- shift overheadicon in eyedirection of player
	local shift = Vector(6, 0, 0)
	shift:Rotate(ea)
	pos:Add(shift)

	local dir = client:GetForward() * -1

	-- start linear filter
	render.PushFilterMag(TEXFILTER.LINEAR)
	render.PushFilterMin(TEXFILTER.LINEAR)

	-- draw color
	render.SetMaterial(materialBase)
	render.DrawQuadEasy(pos, dir, 10, 10, rcolor, 180)

	-- draw border overlay
	render.SetMaterial(materialBaseOverlay)
	render.DrawQuadEasy(pos, dir, 10, 10, COLOR_WHITE, 180)

	-- draw shadow
	render.SetMaterial(ricon)
	render.DrawQuadEasy(Vector(pos.x, pos.y, pos.z + 0.2), dir, 8, 8, colorBlacktrans, 180)

	-- draw icon
	render.SetMaterial(ricon)
	render.DrawQuadEasy(Vector(pos.x, pos.y, pos.z + 0.5), dir, 8, 8, COLOR_WHITE, 180)

	-- stop linear filter
	render.PopFilterMag()
	render.PopFilterMin()
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
	local plys = GetPlayers()

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
	if not cvEnableOverheadicons:GetBool() then return end

	for i = 1, #plys do
		local ply = plys[i]
		local rd = ply:GetSubRoleData()

		if ply:IsActive()
		and ply:HasRole()
		and (not client:IsActive() or ply:IsInTeam(client) or ply:IsDetective())
		and not rd.avoidTeamIcons
		then
			DrawOverheadRoleIcon(ply, rd.iconMaterial, ply:GetRoleColor())
		end
	end
end

---
-- Spectator labels
local function DrawPropSpecLabels(client)
	if not client:IsSpec() and GetRoundState() ~= ROUND_POST then return end

	surface.SetFont("TabLarge")

	local tgt, scrpos, text
	local w = 0
	local plys = player.GetAll()

	for i = 1, #plys do
		local ply = plys[i]

		if ply:IsSpec() then
			surface.SetTextColor(220, 200, 0, 120)

			tgt = ply:GetObserverTarget()

			if IsValid(tgt) and tgt:GetNWEntity("spec_owner", nil) == ply then
				scrpos = tgt:GetPos():ToScreen()
			else
				scrpos = nil
			end
		else
			local _, healthcolor = util.HealthToString(ply:Health(), ply:GetMaxHealth())

			surface.SetTextColor(clr(healthcolor))

			scrpos = ply:EyePos()
			scrpos.z = scrpos.z + 20
			scrpos = scrpos:ToScreen()
		end

		if scrpos == nil or util.IsOffScreen(scrpos) then continue end

		text = ply:Nick()
		w = surface.GetTextSize(text)

		surface.SetTextPos(scrpos.x - w * 0.5, scrpos.y)
		surface.DrawText(text)
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
	local filter = client:GetObserverMode() == OBS_MODE_IN_EYE and {client, client:GetObserverTarget()} or client

	ent, distance = targetid.FindEntityAlongView(startpos, direction, filter)

	---
	-- @realm client
	local changedEnt = hook.Run("TTTModifyTargetedEntity", ent, distance)

	if changedEnt then
		unchangedEnt = ent
		ent = changedEnt
	end

	-- make sure it is a valid entity
	if not IsValid(ent) or ent.NoTarget then return end

	-- call internal targetID functions first so the data can be modified by addons
	local tData = TARGET_DATA:Initialize(ent, unchangedEnt, distance)

	targetid.HUDDrawTargetIDTButtons(tData)
	targetid.HUDDrawTargetIDWeapons(tData)
	targetid.HUDDrawTargetIDPlayers(tData)
	targetid.HUDDrawTargetIDRagdolls(tData)
	targetid.HUDDrawTargetIDDoors(tData)
	targetid.HUDDrawTargetIDDNAScanner(tData)

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

	if not params.drawInfo then return end

	-- render on display text
	local pad = 4
	local pad2 = pad * 2

	-- draw key and keybox
	-- the keyboxsize gets used as reference value since in most cases a key will be rendered
	-- therefore the key size gets calculated every time, even if no key is set
	local key_string = string.upper(params.displayInfo.key and input.GetKeyName(params.displayInfo.key) or "")

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
		drawsc.AdvancedShadowedText(key_string, "TargetID_Key", key_string_x, key_string_y, COLOR_WHITE, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
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

			drawsc.FilteredShadowedTexture(icon_x, icon_y, key_box_h, key_box_h, icon.material, color.a, color)

			icon_y = icon_y + key_box_h
		end
	end

	-- draw title
	local title_string = params.displayInfo.title.text or ""

	local _, title_string_h = draw.GetTextSize(title_string, "TargetID_Title")

	local title_string_x = params.refPosition.x + pad2
	local title_string_y = key_box_y + title_string_h - 4

	for i = 1, #params.displayInfo.title.icons do
		drawsc.FilteredShadowedTexture(title_string_x, title_string_y - 16, 14, 14, params.displayInfo.title.icons[i], params.displayInfo.title.color.a, params.displayInfo.title.color)

		title_string_x = title_string_x + 18
	end

	drawsc.AdvancedShadowedText(title_string, "TargetID_Title", title_string_x, title_string_y, params.displayInfo.title.color, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM)

	-- draw subtitle
	local subtitle_string = params.displayInfo.subtitle.text or ""

	local subtitle_string_x = params.refPosition.x + pad2
	local subtitle_string_y = key_box_y + key_box_h + 2

	for i = 1, #params.displayInfo.subtitle.icons do
		drawsc.FilteredShadowedTexture(subtitle_string_x, subtitle_string_y - 14, 12, 12, params.displayInfo.subtitle.icons[i], params.displayInfo.subtitle.color.a, params.displayInfo.subtitle.color)

		subtitle_string_x = subtitle_string_x + 16
	end

	drawsc.AdvancedShadowedText(subtitle_string, "TargetID_Subtitle", subtitle_string_x, subtitle_string_y, params.displayInfo.subtitle.color, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM)

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
				drawsc.FilteredShadowedTexture(desc_string_x_loop, desc_string_y - 13, 11, 11, icons[j], color.a, color)

				desc_string_x_loop = desc_string_x_loop + 14
			end

			drawsc.AdvancedShadowedText(text, "TargetID_Description", desc_string_x_loop, desc_string_y, color, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM)
			desc_string_y = desc_string_y + desc_line_h
		end
	end

	-- draw spacer line
	local spacer_line_x = params.refPosition.x - 1
	local spacer_line_y = key_box_y

	local spacer_line_icon_l = (icon_y and icon_y or spacer_line_y) - spacer_line_y
	local spacer_line_text_l = key_box_h + ((desc_line_amount > 0) and (4 * pad + desc_line_h * desc_line_amount - 3) or 0)

	local spacer_line_l = (spacer_line_icon_l > spacer_line_text_l) and spacer_line_icon_l or spacer_line_text_l

	drawsc.ShadowedBox(spacer_line_x, spacer_line_y, 1, spacer_line_l, Z)
end

---
-- Add targetID info to a focused entity.
-- @param TARGET_DATA tData The @{TARGET_DATA} data object which contains all information
-- @hook
-- @realm client
function GM:TTTRenderEntityInfo(tData)

end

---
-- Change the focused entity used for targetID.
-- @param Entity ent The focuces entity that should be changed
-- @param number distance The distance to the focused entity
-- @return Entity The new entity to replace the real one
-- @hook
-- @realm client
function GM:TTTModifyTargetedEntity(ent, distance)

end

---
-- Change the starting position for the trace that looks for entites.
-- @param Vector startpos The current startpos of the trace to find an entity
-- @param Vector endpos The current endpos of the trace to find an entity
-- @return Vector, Vector The new startpos for the trace, the new endpos for the trace
-- @hook
-- @realm client
function GM:TTTModifyTargetTracedata(startpos, endpos)

end
