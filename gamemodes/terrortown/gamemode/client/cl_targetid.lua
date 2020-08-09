---
--

local util = util
local render = render
local surface = surface
local draw = draw
local ParT = LANG.GetParamTranslation
local TryT = LANG.TryTranslation
local GetPlayers = player.GetAll
local math = math
local table = table
local IsValid = IsValid
local hook = hook

local disable_spectatorsoutline = CreateClientConVar("ttt2_disable_spectatorsoutline", "0", true, true)
local disable_overheadicons = CreateClientConVar("ttt2_disable_overheadicons", "0", true, true)

local cvDeteOnlyConfirm = GetConVar("ttt2_confirm_detective_only")
local cvDeteOnlyInspect = GetConVar("ttt2_inspect_detective_only")

surface.CreateFont("TargetID_Key", {font = "Trebuchet24", size = 26, weight = 900})
surface.CreateFont("TargetID_Title", {font = "Trebuchet24", size = 20, weight = 900})
surface.CreateFont("TargetID_Subtitle", {font = "Trebuchet24", size = 17, weight = 300})
surface.CreateFont("TargetID_Description", {font = "Trebuchet24", size = 15, weight = 300})

-- keep this font for compatibility reasons
surface.CreateFont("TargetIDSmall2", {font = "TargetID", size = 16, weight = 1000})

local minimalist = CreateClientConVar("ttt_minimal_targetid", "0", FCVAR_ARCHIVE)
local cv_draw_halo = CreateClientConVar("ttt_entity_draw_halo", "1", true, false)
local MAX_TRACE_LENGTH = math.sqrt(3) * 32768
local color_blacktrans = Color(0, 0, 0, 180)

-- cached materials for overhead icons and outlines
local propspec_outline = Material("models/props_combine/portalball001_sheet")
local base = Material("vgui/ttt/dynamic/sprite_base")
local base_overlay = Material("vgui/ttt/dynamic/sprite_base_overlay")

-- materials for targetid
local ring_tex = Material("effects/select_ring")
local icon_role_not_known = Material("vgui/ttt/tid/tid_big_role_not_known")
local icon_corpse = Material("vgui/ttt/tid/tid_big_corpse")
local icon_tbutton = Material("vgui/ttt/tid/tid_big_tbutton_pointer")
local icon_tid_credits = Material("vgui/ttt/tid/tid_credits")
local icon_tid_detective = Material("vgui/ttt/tid/tid_detective")
local icon_tid_locked = Material("vgui/ttt/tid/tid_locked")
local icon_tid_auto_close = Material("vgui/ttt/tid/tid_auto_close")
local materialDoor = Material("vgui/ttt/tid/tid_big_door")
local materialDestructible = Material("vgui/ttt/tid/tid_destructible")
local icon_tid_dna = Material("vgui/ttt/dnascanner/dna_hud")
local materialDisguised = Material("vgui/ttt/perks/hud_disguiser.png")

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
-- @ref
-- @local
function GM:AddClassHint(cls, hint)
	ClassHint[cls] = table.Copy(hint)
end

---
-- Function that handles the drawing of the overhead roleicons, it does not check whether
-- the icon should be drawn or not, that has to be handled prior to calling this function
-- @param @{PLAYER} ply The player to receive an overhead icon
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
	render.SetMaterial(base)
	render.DrawQuadEasy(pos, dir, 10, 10, rcolor, 180)

	-- draw border overlay
	render.SetMaterial(base_overlay)
	render.DrawQuadEasy(pos, dir, 10, 10, COLOR_WHITE, 180)

	-- draw shadow
	render.SetMaterial(ricon)
	render.DrawQuadEasy(Vector(pos.x, pos.y, pos.z + 0.2), dir, 8, 8, color_blacktrans, 180)

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

	if client:Team() == TEAM_SPEC and not disable_spectatorsoutline:GetBool() then
		cam.Start3D(EyePos(), EyeAngles())

		for i = 1, #plys do
			local ply = plys[i]
			local tgt = ply:GetObserverTarget()

			if IsValid(tgt) and tgt:GetNWEntity("spec_owner", nil) == ply then
				render.MaterialOverride(propspec_outline)
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
	if disable_overheadicons:GetBool() then return end

	for i = 1, #plys do
		local ply = plys[i]
		local rd = ply:GetSubRoleData()

		if ply:IsActive()
		and ply:IsSpecial()
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

		if scrpos == nil or IsOffScreen(scrpos) then continue end

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

	if hook.Call("HUDShouldDraw", GAMEMODE, "TTTPropSpec") then
		DrawPropSpecLabels(client)
	end

	local startpos = client:EyePos()
	local endpos = client:GetAimVector()

	endpos:Mul(MAX_TRACE_LENGTH)
	endpos:Add(startpos)

	local ent, unchangedEnt, distance

	-- if the user is looking at a traitor button, it should always be handled with priority
	if TBHUD.focus_but and IsValid(TBHUD.focus_but.ent) and (TBHUD.focus_but.access or TBHUD.focus_but.admin) and TBHUD.focus_stick >= CurTime() then
		ent = TBHUD.focus_but.ent

		distance = startpos:Distance(ent:GetPos())
	else
		local trace = util.TraceLine({
			start = startpos,
			endpos = endpos,
			mask = MASK_SHOT,
			filter = client:GetObserverMode() == OBS_MODE_IN_EYE and {client, client:GetObserverTarget()} or client
		})

		-- this is the entity the player is looking at right now
		ent = trace.Entity

		distance = trace.StartPos:Distance(trace.HitPos)
	end

	-- if a vehicle, we identify the driver instead
	if IsValid(ent) and IsValid(ent:GetNWEntity("ttt_driver", nil)) then
		ent = ent:GetNWEntity("ttt_driver", nil)
	end

	-- only add onscreen infos when the entity isn't the local player
	if ent == client then return end

	local changedEnt = hook.Run("TTTModifyTargetedEntity", ent, distance)

	if changedEnt then
		unchangedEnt = ent
		ent = changedEnt
	end

	-- make sure it is a valid entity
	if not IsValid(ent) or ent.NoTarget then return end

	-- combine data into a table to read them inside a hook
	local data = {
		ent = ent,
		unchangedEnt = unchangedEnt,
		distance = distance
	}

	-- preset a table of values that can be changed with a hook
	local params = {
		drawInfo = nil,
		drawOutline = nil,
		outlineColor = COLOR_WHITE,
		displayInfo = {
			key = nil,
			icon = {},
			title = {
				icons = {},
				text = "",
				color = COLOR_WHITE
			},
			subtitle = {
				icons = {},
				text = "",
				color = COLOR_LLGRAY
			},
			desc = {}
		},
		refPosition = {
			x = math.Round(0.5 * ScrW(), 0),
			y = math.Round(0.5 * ScrH(), 0) + 42
		}
	}

	-- call internal targetID functions first so the data can be modified by addons
	local tData = TARGET_DATA:BindTarget(data, params)

	HUDDrawTargetIDTButtons(tData)
	HUDDrawTargetIDWeapons(tData)
	HUDDrawTargetIDPlayers(tData)
	HUDDrawTargetIDRagdolls(tData)
	HUDDrawTargetIDDoors(tData)
	HUDDrawTargetIDDNAScanner(tData)

	-- now run a hook that can be used by addon devs that changes the appearance
	-- of the targetid
	hook.Run("TTTRenderEntityInfo", tData)

	-- draws an outline around the entity if defined
	if params.drawOutline and cv_draw_halo:GetBool() then
		outline.Add(data.ent, params.outlineColor, OUTLINE_MODE_VISIBLE)
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
		surface.SetDrawColor(0, 0, 0, 150)
		surface.DrawRect(key_box_x, key_box_y, key_box_w, key_box_h)

		draw.OutlinedShadowedBox(key_box_x, key_box_y, key_box_w, key_box_h, 1, COLOR_WHITE)
		draw.ShadowedText(key_string, "TargetID_Key", key_string_x, key_string_y, COLOR_WHITE, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
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

			draw.FilteredShadowedTexture(icon_x, icon_y, key_box_h, key_box_h, icon.material, color.a, color)

			icon_y = icon_y + key_box_h
		end
	end

	-- draw title
	local title_string = params.displayInfo.title.text or ""

	local _, title_string_h = draw.GetTextSize(title_string, "TargetID_Title")

	local title_string_x = params.refPosition.x + pad2
	local title_string_y = key_box_y + title_string_h - 4

	for i = 1, #params.displayInfo.title.icons do
		draw.FilteredShadowedTexture(title_string_x, title_string_y - 16, 14, 14, params.displayInfo.title.icons[i], params.displayInfo.title.color.a, params.displayInfo.title.color)

		title_string_x = title_string_x + 18
	end

	draw.ShadowedText(title_string, "TargetID_Title", title_string_x, title_string_y, params.displayInfo.title.color, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM)

	-- draw subtitle
	local subtitle_string = params.displayInfo.subtitle.text or ""

	local subtitle_string_x = params.refPosition.x + pad2
	local subtitle_string_y = key_box_y + key_box_h + 2

	for i = 1, #params.displayInfo.subtitle.icons do
		draw.FilteredShadowedTexture(subtitle_string_x, subtitle_string_y - 14, 12, 12, params.displayInfo.subtitle.icons[i], params.displayInfo.subtitle.color.a, params.displayInfo.subtitle.color)

		subtitle_string_x = subtitle_string_x + 16
	end

	draw.ShadowedText(subtitle_string, "TargetID_Subtitle", subtitle_string_x, subtitle_string_y, params.displayInfo.subtitle.color, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM)

	-- in minimalist mode, no descriptions should be shown
	local desc_line_amount, desc_line_h = 0, 0

	if not minimalist:GetBool() then
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
				draw.FilteredShadowedTexture(desc_string_x_loop, desc_string_y - 13, 11, 11, icons[j], color.a, color)

				desc_string_x_loop = desc_string_x_loop + 14
			end

			draw.ShadowedText(text, "TargetID_Description", desc_string_x_loop, desc_string_y, color, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM)
			desc_string_y = desc_string_y + desc_line_h
		end
	end

	-- draw spacer line
	local spacer_line_x = params.refPosition.x - 1
	local spacer_line_y = key_box_y

	local spacer_line_icon_l = (icon_y and icon_y or spacer_line_y) - spacer_line_y
	local spacer_line_text_l = key_box_h + ((desc_line_amount > 0) and (4 * pad + desc_line_h * desc_line_amount - 3) or 0)

	local spacer_line_l = (spacer_line_icon_l > spacer_line_text_l) and spacer_line_icon_l or spacer_line_text_l

	draw.ShadowedLine(spacer_line_x, spacer_line_y, spacer_line_x, spacer_line_y + spacer_line_l, COLOR_WHITE)
end

---
-- Add targetID info to a focused entity.
-- @param @{TARGET_DATA} tData The @{TARGET_DATA} data object which contains all information
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

local key_params = {
	usekey = Key("+use", "USE"),
	walkkey = Key("+walk", "WALK")
}

-- handle looking with DNA Scanner
function HUDDrawTargetIDDNAScanner(tData)
	local client = LocalPlayer()
	local ent = tData:GetEntity()

	if not IsValid(client:GetActiveWeapon()) or client:GetActiveWeapon():GetClass() ~= "weapon_ttt_wtester"
		or tData:GetEntityDistance() > 400 or not IsValid(ent) then return end

	-- add an empty line if there's already data in the description area
	if tData:GetAmountDescriptionLines() > 0 then
		tData:AddDescriptionLine()
	end

	if ent:IsWeapon() or ent.CanHavePrints or ent:GetNWBool("HasPrints", false)
		or ent:GetClass() == "prop_ragdoll" and CORPSE.GetPlayerNick(ent, false)
	then
		tData:AddDescriptionLine(TryT("dna_tid_possible"), COLOR_GREEN, {icon_tid_dna})
	else
		tData:AddDescriptionLine(TryT("dna_tid_impossible"), COLOR_RED, {icon_tid_dna})
	end
end

-- handle looking at doors
function HUDDrawTargetIDDoors(tData)
	local client = LocalPlayer()
	local ent = tData:GetEntity()

	if not IsValid(client) or not client:IsTerror() or not client:Alive()
	or not IsValid(ent) or not ent:IsDoor() or not ent:PlayerCanOpenDoor() or tData:GetEntityDistance() > 90 then
		return
	end

	-- enable targetID rendering
	tData:EnableText()

	tData:SetTitle(TryT("name_door"))

	if ent:UseOpensDoor() and not ent:TouchOpensDoor() then
		if ent:DoorAutoCloses() then
			tData:SetSubtitle(ParT("door_open", key_params))
		else
			tData:SetSubtitle(ent:IsDoorOpen() and ParT("door_close", key_params) or ParT("door_open", key_params))
		end

		tData:SetKey(input.GetKeyCode(key_params.usekey))
	elseif not ent:UseOpensDoor() and ent:TouchOpensDoor() then
		tData:SetSubtitle(TryT("door_open_touch"))
		tData:AddIcon(
			materialDoor,
			COLOR_LGRAY
		)
	else
		tData:SetSubtitle(ParT("door_open_touch_and_use", key_params))
		tData:SetKey(input.GetKeyCode(key_params.usekey))
	end

	if ent:IsDoorLocked() then
		tData:AddDescriptionLine(
			TryT("door_locked"),
			COLOR_ORANGE,
			{icon_tid_locked}
		)
	elseif ent:DoorAutoCloses() then
		tData:AddDescriptionLine(
			TryT("door_auto_closes"),
			COLOR_SLATEGRAY,
			{icon_tid_auto_close}
		)
	end

	if ent:DoorIsDestructible() then
		tData:AddDescriptionLine(
			ParT("door_destructible", {health = ent:GetFastSyncedHealth()}),
			COLOR_LBROWN,
			{materialDestructible}
		)
	end
end

-- handle looking at traitor buttons
function HUDDrawTargetIDTButtons(tData)
	local client = LocalPlayer()
	local ent = tData:GetEntity()

	local admin_mode = GetGlobalBool("ttt2_tbutton_admin_show", false)

	if not IsValid(client) or not client:IsTerror() or not client:Alive()
	or not IsValid(ent) or ent:GetClass() ~= "ttt_traitor_button" or tData:GetEntityDistance() > ent:GetUsableRange() then
		return
	end

	-- enable targetID rendering
	tData:EnableText()

	-- set the title of the traitor button
	tData:SetTitle(ent:GetDescription() == "?" and "Traitor Button" or TryT(ent:GetDescription()))

	-- set the subtitle and icon depending on the currently used mode
	if TBHUD.focus_but.admin and not TBHUD.focus_but.access then
		tData:AddIcon(
			icon_tbutton,
			COLOR_LGRAY
		)

		tData:SetSubtitle(TryT("tbut_help_admin"))
	else
		tData:SetKey(input.GetKeyCode(key_params.usekey))

		tData:SetSubtitle(ParT("tbut_help", key_params))
	end

	-- add description time with some general info about this specific traitor button
	if ent:GetDelay() < 0 then
		tData:AddDescriptionLine(
			TryT("tbut_single"),
			client:GetRoleColor()
		)
	elseif ent:GetDelay() == 0 then
		tData:AddDescriptionLine(
			TryT("tbut_reuse"),
			client:GetRoleColor()
		)
	else
		tData:AddDescriptionLine(
			ParT("tbut_retime", {num = ent:GetDelay()}),
			client:GetRoleColor()
		)
	end

	-- only add more information if in admin mode
	if not admin_mode or not client:IsAdmin() then return end

	local but = TBHUD.focus_but

	tData:AddDescriptionLine() -- adding empty line

	tData:AddDescriptionLine(
		"ADMIN AREA:",
		COLOR_WHITE
	)

	tData:AddDescriptionLine(
		ParT("tbut_role_toggle", {usekey = key_params.usekey, walkkey = key_params.walkkey, role = client:GetRoleString()}),
		COLOR_WHITE
	)

	tData:AddDescriptionLine(
		ParT("tbut_team_toggle", {usekey = key_params.usekey, walkkey = key_params.walkkey, team = client:GetTeam():gsub("^%l", string.upper)}),
		COLOR_WHITE
	)

	tData:AddDescriptionLine() -- adding empty line

	tData:AddDescriptionLine(
		TryT("tbut_current_config"),
		COLOR_WHITE
	)

	local l_role = but.overrideRole == nil and "tbut_default" or but.overrideRole and "tbut_allow" or "tbut_prohib"
	local l_team = but.overrideTeam == nil and "tbut_default" or but.overrideTeam and "tbut_allow" or "tbut_prohib"

	tData:AddDescriptionLine(
		ParT("tbut_role_config", {current = TryT(l_role)}) .. ", " .. ParT("tbut_team_config", {current = TryT(l_team)}),
		COLOR_LGRAY
	)

	tData:AddDescriptionLine(
		TryT("tbut_intended_config"),
		COLOR_WHITE
	)

	local l_roleIntend = but.roleIntend == "none" and "tbut_default" or but.roleIntend
	local l_teamIntend = but.teamIntend == TEAM_NONE and "tbut_default" or but.teamIntend

	tData:AddDescriptionLine(
		ParT("tbut_role_config", {current = LANG.GetRawTranslation(l_roleIntend) or l_roleIntend}) .. ", " .. ParT("tbut_team_config", {current = LANG.GetRawTranslation(l_teamIntend) or l_teamIntend}),
		COLOR_LGRAY
	)

	if not TBHUD.focus_but.admin or TBHUD.focus_but.access then return end

	tData:AddDescriptionLine() -- adding empty line

	tData:AddDescriptionLine(
		ParT("tbut_admin_mode_only", {cv = "ttt2_tbutton_admin_show"}),
		COLOR_ORANGE
	)
end

-- handle looking at weapons
function HUDDrawTargetIDWeapons(tData)
	local client = LocalPlayer()
	local ent = tData:GetEntity()

	if not IsValid(client) or not client:IsTerror() or not client:Alive()
	or not IsValid(ent) or tData:GetEntityDistance() > 100 or not ent:IsWeapon() then
		return
	end

	local dropWeapon, isActiveWeapon, switchMode = GetBlockingWeapon(client, ent)
	local kind_pickup_wep = MakeKindValid(ent.Kind)

	local weapon_name

	if not ent.GetPrintName then
		weapon_name = ent:GetPrintName() or ent.PrintName or ent:GetClass() or "..."
	else
		weapon_name = ent.PrintName or ent:GetClass() or "..."
	end

	-- enable targetID rendering
	tData:EnableText()
	tData:EnableOutline()
	tData:SetOutlineColor(client:GetRoleColor())

	-- general info
	tData:SetKey(bind.Find("ttt2_weaponswitch"))

	tData:SetTitle(TryT(weapon_name) .. " [" .. ParT("target_slot_info", {slot = kind_pickup_wep}) .. "]")

	-- set subtitle depending on the switchmode
	if switchMode == SWITCHMODE_PICKUP then
		tData:SetSubtitle(ParT("target_pickup_weapon", key_params) .. (not isActiveWeapon and ParT("target_pickup_weapon_hidden", key_params) or ""))
	elseif switchMode == SWITCHMODE_SWITCH then
		tData:SetSubtitle(ParT("target_switch_weapon", key_params) .. (not isActiveWeapon and ParT("target_switch_weapon_hidden", key_params) or ""))
	elseif switchMode == SWITCHMODE_FULLINV then
		tData:SetSubtitle(TryT("target_switch_weapon_nospace"))
	end

	-- add additional dropping info if weapon is switched
	if switchMode == SWITCHMODE_SWITCH then
		local dropWepKind = MakeKindValid(dropWeapon.Kind)
		local dropWeapon_name

		if not dropWeapon.GetPrintName then
			dropWeapon_name = dropWeapon:GetPrintName() or dropWeapon.PrintName or dropWeapon:GetClass() or "..."
		else
			dropWeapon_name = dropWeapon.PrintName or dropWeapon:GetClass() or "..."
		end

		tData:AddDescriptionLine(
			ParT("target_switch_drop_weapon_info", {slot = dropWepKind, name = TryT(dropWeapon_name)}),
			COLOR_ORANGE
		)
	end

	-- add info about full inventory
	if switchMode == SWITCHMODE_FULLINV then
		local dropWepKind = MakeKindValid(ent.Kind)

		tData:AddDescriptionLine(
			ParT("target_switch_drop_weapon_info_noslot", {slot = dropWepKind}),
			COLOR_ORANGE
		)
	end

	-- add info if your weapon can not be dropped
	if switchMode == SWITCHMODE_NOSPACE then
		tData:AddDescriptionLine(
			TryT("drop_no_room"),
			COLOR_ORANGE
		)
	end
end

-- handle looking at players
function HUDDrawTargetIDPlayers(tData)
	local client = LocalPlayer()
	local ent = tData:GetEntity()
	local obsTgt = client:GetObserverTarget()

	-- has to be a player
	if not ent:IsPlayer() then return end

	local disguised = ent:GetNWBool("disguised", false)

	-- oof TTT, why so hacky?! Sets last seen player. Dear reader I don't like this as well, but it has to stay that way
	-- for compatibility reasons. At least it is uncluttered now!
	client.last_id = disguised and nil or ent

	-- do not show information when observing a player
	if client:IsSpec() and IsValid(obsTgt) and ent == obsTgt then return end

	-- disguised players are not shown to normal players, except: same team, unknown team or to spectators
	if disguised and not (client:IsInTeam(ent) and not client:GetSubRoleData().unknownTeam or client:IsSpec()) then return end

	-- show the role of a player if it is known to the client
	local rstate = GetRoundState()
	local target_role

	-- TODO: this detective check has to be removed from here and be replaced with a general role flag
	if ent.GetSubRole and (rstate > ROUND_PREP and ent:IsDetective() or rstate == ROUND_ACTIVE and ent:IsSpecial()) then
		target_role = ent:GetSubRoleData()
	end

	-- add glowing ring around crosshair when role is known
	if target_role then
		local icon_size = 64

		draw.FilteredTexture(math.Round(0.5 * (ScrW() - icon_size)), math.Round(0.5 * (ScrH() - icon_size)), icon_size, icon_size, ring_tex, 200, target_role.color)
	end

	-- enable targetID rendering
	tData:EnableText()

	-- add title and subtitle to the focused ent
	local h_string, h_color = util.HealthToString(ent:Health(), ent:GetMaxHealth())

	tData:SetTitle(
		ent:Nick() .. " " .. (disguised and TryT("target_disg") or ""),
		disguised and COLOR_ORANGE or nil,
		disguised and {materialDisguised}
	)

	tData:SetSubtitle(
		TryT(h_string),
		h_color
	)

	-- add icon to the element
	tData:AddIcon(
		target_role and target_role.iconMaterial or icon_role_not_known,
		target_role and ent:GetRoleColor() or COLOR_SLATEGRAY
	)

	-- add karma string if karma is enabled
	if KARMA.IsEnabled() then
		local k_string, k_color = util.KarmaToString(ent:GetBaseKarma())

		tData:AddDescriptionLine(
			TryT(k_string),
			k_color
		)
	end

	-- add scoreboard tags if tag is set
	if ent.sb_tag and ent.sb_tag.txt then
		tData:AddDescriptionLine(
			TryT(ent.sb_tag.txt),
			ent.sb_tag.color
		)
	end

	-- add hints to the player
	local hint = ent.TargetIDHint

	if hint and hint.hint then
		tData:AddDescriptionLine(
			hint.fmt(ent, hint.hint),
			COLOR_LGRAY
		)
	end
end

-- handle looking ragdolls
function HUDDrawTargetIDRagdolls(tData)
	local client = LocalPlayer()
	local ent = tData:GetEntity()
	local c_wep = client:GetActiveWeapon()

	-- has to be a ragdoll
	if not IsValid(ent) or ent:GetClass() ~= "prop_ragdoll" then return end

	-- only show this if the ragdoll has a nick, else it could be a mattress
	if not CORPSE.GetPlayerNick(ent, false) then return end

	local corpse_found = CORPSE.GetFound(ent, false) or not DetectiveMode()
	local role_found = corpse_found and ent.search_result and ent.search_result.role
	local binoculars_useable = IsValid(c_wep) and c_wep:GetClass() == "weapon_ttt_binoculars" or false
	local role = roles.GetByIndex(role_found and ent.search_result.role or 1)

	-- enable targetID rendering
	tData:EnableText()
	tData:EnableOutline(tData:GetEntityDistance() <= 100)
	tData:SetOutlineColor(COLOR_YELLOW)

	-- add title and subtitle to the focused ent
	tData:SetTitle(
		corpse_found and CORPSE.GetPlayerNick(ent, "A Terrorist") or TryT("target_unid"),
		role_found and COLOR_WHITE or COLOR_YELLOW
	)

	if tData:GetEntityDistance() <= 100 then
		if cvDeteOnlyInspect:GetBool() and client:GetBaseRole() ~= ROLE_DETECTIVE then
			if client:IsActive() and client:IsShopper() and CORPSE.GetCredits(ent, 0) > 0 then
				tData:SetSubtitle(ParT("corpse_hint_inspect_only_credits", key_params))
			else
				tData:SetSubtitle(TryT("corpse_hint_no_inspect"))
			end
		elseif cvDeteOnlyConfirm:GetBool() and client:GetBaseRole() ~= ROLE_DETECTIVE then
			tData:SetSubtitle(ParT("corpse_hint_inspect_only", key_params))
		else
			tData:SetSubtitle(ParT("corpse_hint", key_params))
		end
	elseif binoculars_useable then
		tData:SetSubtitle(ParT("corpse_binoculars", {key = Key("+attack", "ATTACK")}))
	else
		tData:SetSubtitle(TryT("corpse_too_far_away"))
	end

	-- add icon to the element
	tData:AddIcon(
		role_found and role.iconMaterial or icon_corpse,
		role_found and role.color or COLOR_YELLOW
	)

	-- add hints to the corpse
	local hint = ent.TargetIDHint

	if hint and hint.hint then
		tData:AddDescriptionLine(
			hint.fmt(ent, hint.hint),
			COLOR_LGRAY
		)
	end

	-- add info if searched by detectives
	if ent.search_result and ent.search_result.detective_search and client:IsDetective() then
		tData:AddDescriptionLine(
			TryT("corpse_searched_by_detective"),
			DETECTIVE.ltcolor,
			{icon_tid_detective}
		)
	end

	-- add credits info when corpse has credits
	if client:IsActive() and client:IsShopper() and CORPSE.GetCredits(ent, 0) > 0 then
		tData:AddDescriptionLine(
			TryT("target_credits"),
			COLOR_YELLOW,
			{icon_tid_credits}
		)
	end
end
