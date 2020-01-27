---
--

local util = util
local render = render
local surface = surface
local draw = draw
local GetPT = LANG.GetParamTranslation
local TryT = LANG.TryTranslation
local GetPlayers = player.GetAll
local math = math
local table = table
local IsValid = IsValid
local hook = hook

local disable_spectatorsoutline = CreateClientConVar("ttt2_disable_spectatorsoutline", "0", true, true)
local disable_overheadicons = CreateClientConVar("ttt2_disable_overheadicons", "0", true, true)

surface.CreateFont("TargetID_Key", {font = "Trebuchet24", size = 26, weight = 900})
surface.CreateFont("TargetID_Title", {font = "Trebuchet24", size = 20, weight = 900})
surface.CreateFont("TargetID_Subtitle", {font = "Trebuchet24", size = 17, weight = 300})
surface.CreateFont("TargetID_Description", {font = "Trebuchet24", size = 15, weight = 300})

-- keep this font for compatibility reasons
surface.CreateFont("TargetIDSmall2", {font = "TargetID", size = 16, weight = 1000})

local minimalist = CreateClientConVar("ttt_minimal_targetid", "0", FCVAR_ARCHIVE)
local cv_draw_halo = CreateClientConVar("ttt_entity_draw_halo", "1", true, false)
local MAX_TRACE_LENGTH = math.sqrt(3) * 32768
local subtitle_color = Color(210, 210, 210)
local color_blacktrans = Color(0, 0, 0, 180)

-- cached materials for overhead icons and outlines
local propspec_outline = Material("models/props_combine/portalball001_sheet")
local base = Material("vgui/ttt/dynamic/sprite_base")
local base_overlay = Material("vgui/ttt/dynamic/sprite_base_overlay")

-- materials for targetid
local ring_tex = Material("effects/select_ring")
local icon_role_not_known = Material("vgui/ttt/dynamic/roles/icon_role_not_known")
local icon_corpse = Material("vgui/ttt/dynamic/roles/icon_corpse")
local icon_tbutton = Material("vgui/ttt/dynamic/icon_button_pointer")

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
-- Function that handles the drawing of the overhead roleicons, it does not check wether
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
-- @ref https://wiki.garrysmod.com/page/GM/PostDrawTranslucentRenderables
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
	if disable_overheadicons:GetBool() or not client:IsSpecial() then return end

	for i = 1, #plys do
		local ply = plys[i]
		local rd = ply:GetSubRoleData()

		if ply:IsActive()
		and ply:IsSpecial()
		and (not client:IsActive() or ply:IsInTeam(client))
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
-- @ref https://wiki.garrysmod.com/page/GM/HUDDrawTargetID
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

	local ent, distance

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

	-- make sure it is a valid entity
	if not IsValid(ent) or ent.NoTarget then return end

	-- if a vehicle, we identify the driver instead
	if IsValid(ent:GetNWEntity("ttt_driver", nil)) then
		ent = ent:GetNWEntity("ttt_driver", nil)
	end

	-- only add onscreen infos when the entity isn't the local player
	if ent == client then return end

	-- combine data into a table to read them inside a hook
	local data = {
		ent = ent,
		distance = distance
	}

	-- preset a table of values that can be changes with a hook
	local params = {
		drawInfo = false,
		drawOutline = false,
		outlineColor = COLOR_WHITE,
		displayInfo = {
			key = nil,
			icon = {},
			iconColor = COLOR_WHITE,
			title = {text = "", color = COLOR_WHITE},
			subtitle = {text = "", color = subtitle_color},
			desc = {}
		},
		ref_position = {
			x = math.Round(0.5 * ScrW(), 0),
			y = math.Round(0.5 * ScrH(), 0) + 42
		}
	}

	-- call internal targetID functions first
	HUDDrawTargetIDTButtons(data, params)
	HUDDrawTargetIDWeapons(data, params)
	HUDDrawTargetIDPlayers(data, params)
	HUDDrawTargetIDRagdolls(data, params)

	-- now run a hook that can be used by addon devs that changes the appearance
	-- of the targetid
	hook.Run("TTTRenderEntityInfo", data, params)

	-- drawn an outline around the entity if defined
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
	local key_box_x = params.ref_position.x - key_box_w - pad2 - 2 -- -2 because of border width
	local key_box_y = params.ref_position.y

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
		icon_x = params.ref_position.x - key_box_h - pad2
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

	local title_string_x = params.ref_position.x + pad2
	local title_string_y = key_box_y + title_string_h - 4

	draw.ShadowedText(title_string, "TargetID_Title", title_string_x, title_string_y, params.displayInfo.title.color, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM)

	-- draw subtitle
	local subtitle_string = params.displayInfo.subtitle.text or ""

	local subtitle_string_x = params.ref_position.x + pad2
	local subtitle_string_y = key_box_y + key_box_h + 2

	draw.ShadowedText(subtitle_string, "TargetID_Subtitle", subtitle_string_x, subtitle_string_y, params.displayInfo.subtitle.color, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM)

	-- in minimalist mode, no descriptions should be shown
	if minimalist:GetBool() then return end

	-- draw description text
	local desc_lines = params.displayInfo.desc

	local desc_string_x = params.ref_position.x + pad2
	local desc_string_y = key_box_y + key_box_h + 4 * pad
	local desc_line_h = 17
	local desc_line_amount = #desc_lines

	for i = 1, desc_line_amount do
		local text = desc_lines[i].text or ""
		local color = desc_lines[i].color or COLOR_WHITE

		draw.ShadowedText(text, "TargetID_Description", desc_string_x, desc_string_y, color, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)

		desc_string_y = desc_string_y + desc_line_h
	end

	-- draw spacer line
	local spacer_line_x = params.ref_position.x - 1
	local spacer_line_y = key_box_y

	local spacer_line_icon_l = (icon_y and icon_y or spacer_line_y) - spacer_line_y
	local spacer_line_text_l = key_box_h + ((desc_line_amount > 0) and (4 * pad + desc_line_h * desc_line_amount - 3) or 0)

	local spacer_line_l = (spacer_line_icon_l > spacer_line_text_l) and spacer_line_icon_l or spacer_line_text_l

	draw.ShadowedLine(spacer_line_x, spacer_line_y, spacer_line_x, spacer_line_y + spacer_line_l, COLOR_WHITE)
end

local key_params = {
	usekey = Key("+use", "USE"),
	walkkey = Key("+walk", "WALK")
}

-- handle looking at traitor buttons
function HUDDrawTargetIDTButtons(data, params)
	local client = LocalPlayer()
	local admin_mode = GetConVar("ttt2_tbutton_admin_show")

	if not IsValid(client) or not client:IsTerror() or not client:Alive()
	or data.ent:GetClass() ~= "ttt_traitor_button" or data.distance > data.ent:GetUsableRange() then
		return
	end

	params.drawInfo = true

	if TBHUD.focus_but.admin and not TBHUD.focus_but.access then
		params.displayInfo.icon[#params.displayInfo.icon + 1] = {
			material = icon_tbutton,
			color = COLOR_LGRAY
		}
		params.displayInfo.subtitle.text = TryT("tbut_help_admin")
	else
		params.displayInfo.key = input.GetKeyCode(key_params.usekey)
		params.displayInfo.subtitle.text = GetPT("tbut_help", key_params)
	end

	params.displayInfo.title.text = data.ent:GetDescription() == "?" and "Traitor Button" or data.ent:GetDescription()

	local special_info
	if data.ent:GetDelay() < 0 then
		special_info = TryT("tbut_single")
	elseif data.ent:GetDelay() == 0 then
		special_info = TryT("tbut_reuse")
	else
		special_info = GetPT("tbut_retime", {num = data.ent:GetDelay()})
	end

	params.displayInfo.desc[#params.displayInfo.desc + 1] = {
		text = special_info,
		color = client:GetRoleColor()
	}

	if not admin_mode:GetBool() or not client:IsAdmin() then return end

	local but = TBHUD.focus_but

	params.displayInfo.desc[#params.displayInfo.desc + 1] = {
		text = "",
		color = COLOR_WHITE
	}

	params.displayInfo.desc[#params.displayInfo.desc + 1] = {
		text = "ADMIN AREA:",
		color = COLOR_WHITE
	}

	params.displayInfo.desc[#params.displayInfo.desc + 1] = {
		text = GetPT("tbut_role_toggle", {usekey = key_params.usekey, walkkey = key_params.walkkey, role = client:GetRoleString()}),
		color = COLOR_WHITE
	}

	params.displayInfo.desc[#params.displayInfo.desc + 1] = {
		text = GetPT("tbut_team_toggle", {usekey = key_params.usekey, walkkey = key_params.walkkey, team = client:GetTeam():gsub("^%l", string.upper)}),
		color = COLOR_WHITE
	}

	params.displayInfo.desc[#params.displayInfo.desc + 1] = {
		text = "",
		color = COLOR_WHITE
	}

	params.displayInfo.desc[#params.displayInfo.desc + 1] = {
		text = TryT("tbut_current_config"),
		color = COLOR_WHITE
	}

	local l_role = but.overrideRole == nil and "tbut_default" or but.overrideRole and "tbut_allow" or "tbut_prohib"
	local l_team = but.overrideTeam == nil and "tbut_default" or but.overrideTeam and "tbut_allow" or "tbut_prohib"

	params.displayInfo.desc[#params.displayInfo.desc + 1] = {
		text = GetPT("tbut_role_config", {current = TryT(l_role)}) .. ", " .. GetPT("tbut_team_config", {current = TryT(l_team)}),
		color = COLOR_LGRAY
	}

	params.displayInfo.desc[#params.displayInfo.desc + 1] = {
		text = TryT("tbut_intended_config"),
		color = COLOR_WHITE
	}

	local l_roleIntend = but.roleIntend == "none" and "tbut_default" or but.roleIntend
	local l_teamIntend = but.teamIntend == TEAM_NONE and "tbut_default" or but.teamIntend

	params.displayInfo.desc[#params.displayInfo.desc + 1] = {
		text = GetPT("tbut_role_config", {current = LANG.GetRawTranslation(l_roleIntend) or l_roleIntend}) .. ", " .. GetPT("tbut_team_config", {current = LANG.GetRawTranslation(l_teamIntend) or l_teamIntend}),
		color = COLOR_LGRAY
	}

	if not TBHUD.focus_but.admin or TBHUD.focus_but.access then return end

	params.displayInfo.desc[#params.displayInfo.desc + 1] = {
		text = "",
		color = COLOR_WHITE
	}

	params.displayInfo.desc[#params.displayInfo.desc + 1] = {
		text = GetPT("tbut_admin_mode_only", {cv = admin_mode:GetName()}),
		color = COLOR_ORANGE
	}
end

-- handle looking at weapons
function HUDDrawTargetIDWeapons(data, params)
	local client = LocalPlayer()

	if not IsValid(client) or not client:IsTerror() or not client:Alive()
	or data.distance > 100 or not data.ent:IsWeapon() then
		return
	end

	local dropWeapon, isActiveWeapon, switchMode = GetBlockingWeapon(client, data.ent)
	local kind_pickup_wep = MakeKindValid(data.ent.Kind)

	local weapon_name

	if not data.ent.GetPrintName then
		weapon_name = data.ent:GetPrintName() or data.ent.PrintName or data.ent:GetClass() or "..."
	else
		weapon_name = data.ent.PrintName or data.ent:GetClass() or "..."
	end

	params.drawInfo = true
	params.displayInfo.key = bind.Find("ttt2_weaponswitch")
	params.displayInfo.title.text = TryT(weapon_name) .. " [" .. GetPT("target_slot_info", {slot = kind_pickup_wep}) .. "]"

	if switchMode == SWITCHMODE_PICKUP then
		params.displayInfo.subtitle.text = GetPT("target_pickup_weapon", key_params) .. (not isActiveWeapon and GetPT("target_pickup_weapon_hidden", key_params) or "")
	elseif switchMode == SWITCHMODE_SWITCH then
		params.displayInfo.subtitle.text = GetPT("target_switch_weapon", key_params) .. (not isActiveWeapon and GetPT("target_switch_weapon_hidden", key_params) or "")
	elseif switchMode == SWITCHMODE_FULLINV then
		params.displayInfo.subtitle.text = TryT("target_switch_weapon_nospace")
	end

	if switchMode == SWITCHMODE_SWITCH then
		local dropWepKind = MakeKindValid(dropWeapon.Kind)
		local dropWeapon_name

		if not dropWeapon.GetPrintName then
			dropWeapon_name = dropWeapon:GetPrintName() or dropWeapon.PrintName or dropWeapon:GetClass() or "..."
		else
			dropWeapon_name = dropWeapon.PrintName or dropWeapon:GetClass() or "..."
		end

		params.displayInfo.desc[#params.displayInfo.desc + 1] = {
			text = GetPT("target_switch_drop_weapon_info", {slot = dropWepKind, name = TryT(dropWeapon_name)}),
			color = COLOR_ORANGE
		}
	end

	if switchMode == SWITCHMODE_FULLINV then
		local dropWepKind = MakeKindValid(data.ent.Kind)

		params.displayInfo.desc[#params.displayInfo.desc + 1] = {
			text = GetPT("target_switch_drop_weapon_info_noslot", {slot = dropWepKind}),
			color = COLOR_ORANGE
		}
	end

	if switchMode == SWITCHMODE_NOSPACE then
		params.displayInfo.desc[#params.displayInfo.desc + 1] = {
			text = TryT("drop_no_room"),
			color = COLOR_ORANGE
		}
	end

	params.drawOutline = true
	params.outlineColor = client:GetRoleColor()
end

-- handle looking at players
function HUDDrawTargetIDPlayers(data, params)
	local client = LocalPlayer()
	local obsTgt = client:GetObserverTarget()

	-- has to be a player
	if not data.ent:IsPlayer() then return end

	local disguised = data.ent:GetNWBool("disguised", false)

	-- oof TTT, why so hacky?! Sets last seen player. Dear reader I don't like this as well, but it has to stay that way
	-- for compatibility reasons. At least it is uncluttered now!
	client.last_id = disguised and nil or data.ent

	-- do not show information when observing a player
	if client:IsSpec() and IsValid(obsTgt) and data.ent == obsTgt then return end

	-- disguised players are not shown to normal players, except: same team, unknown team or to spectators
	if disguised and not (client:IsInTeam(data.ent) and not client:GetSubRoleData().unknownTeam or client:IsSpec()) then return end

	-- show the role of a player if it is known to the client
	local rstate = GetRoundState()
	local target_role

	-- TODO: this detective check has to be removed from here
	if data.ent.GetSubRole and (rstate > ROUND_PREP and data.ent:IsDetective() or rstate == ROUND_ACTIVE and data.ent:IsSpecial()) then
		target_role = data.ent:GetSubRoleData()
	end

	-- add glowing ring around crosshair when role is known
	if target_role then
		local icon_size = 64

		draw.FilteredTexture(math.Round(0.5 * (ScrW() - icon_size)), math.Round(0.5 * (ScrH() - icon_size)), icon_size, icon_size, ring_tex, 200, target_role.color)
	end

	params.drawInfo = true
	params.displayInfo.icon = {
		{
			material = target_role and target_role.iconMaterial or icon_role_not_known,
			color = target_role and data.ent:GetRoleColor() or COLOR_SLATEGRAY
		}
	}

	local h_string, h_color = util.HealthToString(data.ent:Health(), data.ent:GetMaxHealth())

	params.displayInfo.title.text = data.ent:Nick()
	params.displayInfo.subtitle.text = TryT(h_string)
	params.displayInfo.subtitle.color = h_color

	-- add karma string if karma is enabled
	if KARMA.IsEnabled() then
		local k_string, k_color = util.KarmaToString(data.ent:GetBaseKarma())

		params.displayInfo.desc[#params.displayInfo.desc + 1] = {
			text = TryT(k_string),
			color = k_color
		}
	end

	-- add scoreboard tags if tag is set
	if data.ent.sb_tag and data.ent.sb_tag.txt then
		params.displayInfo.desc[#params.displayInfo.desc + 1] = {
			text = TryT(data.ent.sb_tag.txt),
			color = data.ent.sb_tag.color
		}
	end

	-- add hints to the player
	local hint = data.ent.TargetIDHint
	if hint and hint.hint then
		params.displayInfo.desc[#params.displayInfo.desc + 1] = {
			text = hint.fmt(data.ent, hint.hint),
			color = COLOR_LGRAY
		}
	end

	-- we can now add the disguised info to the playername since a previous check already returned
	-- the code for players in other teams
	if disguised then
		params.displayInfo.title.text = params.displayInfo.title.text .. " " .. string.upper(TryT("target_disg"))
		params.displayInfo.title.color = COLOR_RED
	end
end

-- handle looking ragdolls
function HUDDrawTargetIDRagdolls(data, params)
	local client = LocalPlayer()
	local c_wep = client:GetActiveWeapon()

	-- has to be a ragdoll
	if data.ent:GetClass() ~= "prop_ragdoll" then return end

	-- only show this if the ragdoll has a nick, else it could be a mattress
	if not CORPSE.GetPlayerNick(data.ent, false) then return end

	local corpse_found = CORPSE.GetFound(data.ent, false) or not DetectiveMode()
	local role_found = corpse_found and data.ent.search_result and data.ent.search_result.role
	local binoculars_useable = IsValid(c_wep) and c_wep:GetClass() == "weapon_ttt_binoculars" or false

	params.drawInfo = true
	params.displayInfo.icon = {
		{
			material = role_found and roles.GetByIndex(data.ent.search_result.role).iconMaterial or icon_corpse,
			color = COLOR_YELLOW
		}
	}

	params.displayInfo.title.text = corpse_found and CORPSE.GetPlayerNick(data.ent, "A Terrorist") or TryT("target_unid")
	params.displayInfo.title.color = COLOR_YELLOW

	if data.distance <= 100 then
		params.displayInfo.subtitle.text = GetPT("corpse_hint", key_params)
	elseif binoculars_useable then
		params.displayInfo.subtitle.text = GetPT("corpse_binoculars", {key = Key("+attack", "ATTACK")})
	else
		params.displayInfo.subtitle.text = TryT("corpse_too_far_away")
	end

	-- add hints to the corpse
	local hint = data.ent.TargetIDHint
	if hint and hint.hint then
		params.displayInfo.desc[#params.displayInfo.desc + 1] = {
			text = hint.fmt(data.ent, hint.hint),
			color = COLOR_LGRAY
		}
	end

	-- add info if searched by detectives
	if data.ent.search_result and data.ent.search_result.detective_search and client:IsDetective() then
		params.displayInfo.desc[#params.displayInfo.desc + 1] = {
			text = TryT("corpse_searched_by_detective"),
			color = DETECTIVE.ltcolor
		}
	end

	-- add credits info when corpse has credits
	if client:IsActive() and client:IsShopper() and CORPSE.GetCredits(data.ent, 0) > 0 then
		params.displayInfo.desc[#params.displayInfo.desc + 1] = {
			text = TryT("target_credits"),
			color = COLOR_YELLOW
		}
	end

	-- add outline when ragdoll is reachable
	params.drawOutline = binoculars_useable or data.distance <= 100
	params.outlineColor = COLOR_YELLOW
end
