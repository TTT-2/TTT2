---
--

local util = util
local render = render
local surface = surface
local draw = draw
local GetPTranslation = LANG.GetParamTranslation
local GetRaw = LANG.GetRawTranslation
local TryT = LANG.TryTranslation
local GetLang = LANG.GetUnsafeLanguageTable
local GetPlayers = player.GetAll
local math = math
local table = table
local ipairs = ipairs
local IsValid = IsValid
local CreateConVar = CreateConVar
local hook = hook

local disable_spectatorsoutline = CreateClientConVar("ttt2_disable_spectatorsoutline", "0", true, true)
local disable_overheadicons = CreateClientConVar("ttt2_disable_overheadicons", "0", true, true)

local key_params = {
	usekey = Key("+use", "USE"),
	walkkey = Key("+walk", "WALK")
}

local ClassHint = {
	prop_ragdoll = {
		name = "corpse",
		hint = "corpse_hint",

		fmt = function(ent, txt)
			return GetPTranslation(txt, key_params)
		end
	}
}

-- cached materials for overhead icons and outlines
local propspec_outline = Material("models/props_combine/portalball001_sheet")
local base = Material("vgui/ttt/dynamic/sprite_base")
local base_overlay = Material("vgui/ttt/dynamic/sprite_base_overlay")

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

local color_blacktrans = Color(0, 0, 0, 180)

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

	if disable_overheadicons:GetBool() then return end

	-- OVERHEAD ICONS
	if client:IsSpecial() then
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
end

---
-- Spectator labels
local function DrawPropSpecLabels(client)
	if not client:IsSpec() and GetRoundState() ~= ROUND_POST then return end

	surface.SetFont("TabLarge")

	local tgt, scrpos, text
	local w = 0

	for _, ply in ipairs(player.GetAll()) do
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

		if scrpos and not IsOffScreen(scrpos) then
			text = ply:Nick()
			w = surface.GetTextSize(text)

			surface.SetTextPos(scrpos.x - w * 0.5, scrpos.y)
			surface.DrawText(text)
		end
	end
end

surface.CreateFont("TargetID_Key", {font = "Trebuchet24", size = 26, weight = 900})
surface.CreateFont("TargetID_Title", {font = "Trebuchet24", size = 22, weight = 900})
surface.CreateFont("TargetID_Subtitle", {font = "Trebuchet24", size = 16, weight = 600})
surface.CreateFont("TargetID_Description", {font = "Trebuchet24", size = 16, weight = 400})

local subtitle_color = Color(210, 210, 210)

local minimalist = CreateConVar("ttt_minimal_targetid", "0", FCVAR_ARCHIVE)
local magnifier_mat = Material("icon16/magnifier.png")
local ring_tex = surface.GetTextureID("effects/select_ring")
local rag_color = Color(200, 200, 200, 255)
local MAX_TRACE_LENGTH = math.sqrt(3) * 32768

local cv_draw_halo = CreateClientConVar("ttt_weapon_switch_draw_halo", "1", true, false)

---
-- Called from @{GM:HUDPaint} to draw @{Player} info when you hover over a @{Player} with your crosshair or mouse.
-- @hook
-- @realm client
-- @ref https://wiki.garrysmod.com/page/GM/HUDDrawTargetID
-- @local
function GM:HUDDrawTargetID()
	local client = LocalPlayer()
	local L = GetLang()

	if hook.Call("HUDShouldDraw", GAMEMODE, "TTTPropSpec") then
		DrawPropSpecLabels(client)
	end

	local startpos = client:EyePos()

	local endpos = client:GetAimVector()
	endpos:Mul(MAX_TRACE_LENGTH)
	endpos:Add(startpos)

	local trace = util.TraceLine({
		start = startpos,
		endpos = endpos,
		mask = MASK_SHOT,
		filter = client:GetObserverMode() == OBS_MODE_IN_EYE and {client, client:GetObserverTarget()} or client
	})

	-- this is the entity the player is looking at right now
	local ent = trace.Entity
	local distance = trace.StartPos:Distance(trace.HitPos)

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
		drawText = false,
		drawOutline = false,
		outlineColor = COLOR_WHITE,
		displayInfo = {
			key = nil,
			title = {text = "", color = COLOR_WHITE},
			subtitle = {text = "", color = subtitle_color},
			desc = {}
		}
	}

	-- now run a hook that can be used by addon devs that changes the appearance
	-- of the targetid
	hook.Run("TTTRenderEntityInfo", data, params)

	-- drawn an outline around the entity if defined
	if params.drawOutline and cv_draw_halo:GetBool() then
		outline.Add(data.ent, params.outlineColor, OUTLINE_MODE_VISIBLE)
	end

	if not params.drawText then return end

	local center_x = math.Round(0.5 * ScrW(), 0)
	local center_y = math.Round(0.5 * ScrH(), 0)

	-- render on display text
	local pad = 4

	-- draw key and keybox
	local key_string = string.upper(input.GetKeyName(params.displayInfo.key) or "")

	local key_string_w, key_string_h = draw.GetTextSize(key_string, "TargetID_Key")

	local key_box_w = key_string_w + 5 * pad
	local key_box_h = key_string_h + 2 * pad
	local key_box_x = center_x - key_box_w - 2 * pad - 2 -- -2 because of border width
	local key_box_y = center_y + 4 * pad

	local key_string_x = key_box_x + math.Round(0.5 * key_box_w) - 1
	local key_string_y = key_box_y + math.Round(0.5 * key_box_h) - 1

	draw.OutlinedShadowedBox(key_box_x, key_box_y, key_box_w, key_box_h, 1, COLOR_WHITE)
	draw.ShadowedText(key_string, "TargetID_Key", key_string_x, key_string_y, COLOR_WHITE, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

	-- draw spacer line
	local spacer_line_x = center_x - 1
	local spacer_line_y = key_box_y
	local spacer_line_l = key_box_h

	draw.DrawShadowedLine(spacer_line_x, spacer_line_y, spacer_line_x, spacer_line_y + spacer_line_l, COLOR_WHITE)

	-- draw title
	local title_string = params.displayInfo.title.text or ""

	local title_string_w, title_string_h = draw.GetTextSize(title_string, "TargetID_Title")

	local title_string_x = center_x + 2 * pad
	local title_string_y = key_box_y + title_string_h - 4

	draw.ShadowedText(title_string, "TargetID_Title", title_string_x, title_string_y, params.displayInfo.title.color, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM)

	-- draw subtitle
	local subtitle_string = params.displayInfo.subtitle.text or ""

	local subtitle_string_w, title_string_h = draw.GetTextSize(subtitle_string, "TargetID_Subtitle")

	local subtitle_string_x = center_x + 2 * pad
	local subtitle_string_y = key_box_y + key_box_h + 2

	draw.ShadowedText(subtitle_string, "TargetID_Subtitle", subtitle_string_x, subtitle_string_y, params.displayInfo.subtitle.color, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM)

	-- draw description text
	local desc_string_x = center_x
	local desc_string_y = key_box_y + key_box_h + 4 * pad

	for i = 1, #params.displayInfo.desc do
		local text = params.displayInfo.desc[i].text
		local color = params.displayInfo.desc[i].color

		draw.ShadowedText(text, "TargetID_Description", desc_string_x, desc_string_y, color, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)

		desc_string_y = desc_string_y + 20
	end



	-- END TODO

	--[[
	-- some bools for caching what kind of ent we are looking at
	local target_role
	local target_corpse = false
	local text = nil
	local color = COLOR_WHITE

	

	local cls = ent:GetClass()
	local minimal = minimalist:GetBool()
	local hint = not minimal and (ent.TargetIDHint or ClassHint[cls])

	if ent:IsPlayer() then
		local obsTgt = client:GetObserverTarget()

		if client:IsSpec() and IsValid(obsTgt) and ent == obsTgt then
			return
		elseif ent:GetNWBool("disguised", false) then
			client.last_id = nil

			if client:IsInTeam(ent) and not client:GetSubRoleData().unknownTeam or client:IsSpec() then
				text = ent:Nick() .. L.target_disg
			else
				-- Do not show anything
				return
			end

			color = COLOR_RED
		else
			text = ent:Nick()
			client.last_id = ent
		end

		local _ -- Stop global clutter

		-- in minimalist targetID, colour nick with health level
		if minimal then
			_, color = util.HealthToString(ent:Health(), ent:GetMaxHealth())
		end

		local rstate = GetRoundState()

		if ent.GetSubRole and (rstate > ROUND_PREP and ent:IsDetective() or rstate == ROUND_ACTIVE and ent:IsSpecial()) then
			target_role = ent:GetSubRole()
		end
	elseif cls == "prop_ragdoll" then
		-- only show this if the ragdoll has a nick, else it could be a mattress
		if not CORPSE.GetPlayerNick(ent, false) then return end

		target_corpse = true

		if CORPSE.GetFound(ent, false) or not DetectiveMode() then
			text = CORPSE.GetPlayerNick(ent, "A Terrorist")
		else
			text = L.target_unid
			color = COLOR_YELLOW
		end
	elseif not hint then
		-- Not something to ID and not something to hint about
		return
	end

	local x_orig = ScrW() * 0.5
	local x = x_orig
	local y = ScrH() * 0.5
	local w, h = 0, 0 -- text width/height, reused several times

	if target_role then
		surface.SetTexture(ring_tex)

		local c = roles.GetByIndex(target_role).color

		surface.SetDrawColor(c.r, c.g, c.b, 200)
		surface.DrawTexturedRect(x - 32, y - 32, 64, 64)
	end

	y = y + 30

	local font = "TargetID"

	surface.SetFont(font)

	-- Draw main title, ie. nickname
	if text then
		w, h = surface.GetTextSize(text)
		x = x - w * 0.5

		draw.SimpleText(text, font, x + 1, y + 1, COLOR_BLACK)
		draw.SimpleText(text, font, x, y, color)

		-- for ragdolls searched by detectives, add icon
		if ent.search_result and client:IsDetective() then

			-- if I am detective and I know a search result for this corpse, then I
			-- have searched it or another detective has
			surface.SetMaterial(magnifier_mat)
			surface.SetDrawColor(200, 200, 255, 255)
			surface.DrawTexturedRect(x + w + 5, y, 16, 16)
		end

		y = y + h + 4
	end

	-- Minimalist target ID only draws a health-coloured nickname, no hints, no
	-- karma, no tag
	if minimal then return end

	-- Draw subtitle: health or type
	local c = rag_color

	if ent:IsPlayer() then
		text, c = util.HealthToString(ent:Health(), ent:GetMaxHealth())

		-- HealthToString returns a string id, need to look it up
		text = L[text]
	elseif hint then
		text = GetRaw(hint.name) or hint.name
	else
		return
	end

	font = "TargetIDSmall2"

	surface.SetFont(font)

	w, h = surface.GetTextSize(text)
	x = x_orig - w * 0.5

	draw.SimpleText(text, font, x + 1, y + 1, COLOR_BLACK)
	draw.SimpleText(text, font, x, y, c)

	font = "TargetIDSmall"
	surface.SetFont(font)

	-- Draw second subtitle: karma
	if ent:IsPlayer() and KARMA.IsEnabled() then
		text, c = util.KarmaToString(ent:GetBaseKarma())

		text = L[text]

		w, h = surface.GetTextSize(text)
		y = y + h + 5
		x = x_orig - w * 0.5

		draw.SimpleText(text, font, x + 1, y + 1, COLOR_BLACK)
		draw.SimpleText(text, font, x, y, c)
	end

	-- Draw key hint
	if hint and hint.hint then
		if not hint.fmt then
			text = GetRaw(hint.hint) or hint.hint
		else
			text = hint.fmt(ent, hint.hint)
		end

		w, h = surface.GetTextSize(text)
		x = x_orig - w * 0.5
		y = y + h + 5

		draw.SimpleText(text, font, x + 1, y + 1, COLOR_BLACK)
		draw.SimpleText(text, font, x, y, COLOR_LGRAY)
	end

	text = nil

	if target_role then
		local rd = roles.GetByIndex(target_role)

		text = L["target_" .. rd.name]
		c = IsValid(ent) and ent:GetRoleColor() or rd.color
	end

	if ent.sb_tag and ent.sb_tag.txt then
		text = L[ent.sb_tag.txt]
		c = ent.sb_tag.color
	elseif target_corpse and client:IsActive() and client:IsShopper() and CORPSE.GetCredits(ent, 0) > 0 then
		text = L.target_credits
		c = COLOR_YELLOW
	end

	if text then
		w, h = surface.GetTextSize(text)
		x = x_orig - w * 0.5
		y = y + h + 5

		draw.SimpleText(text, font, x + 1, y + 1, COLOR_BLACK)
		draw.SimpleText(text, font, x, y, c)
	end
	--]]
end


-- handle looking at weapons
hook.Add("TTTRenderEntityInfo", "TTT2HighlightWeapons", function(data, params)
	local client = LocalPlayer()

	if data.distance > 100 or not data.ent:IsWeapon() then return end
	if not IsValid(client) or not client:IsTerror() or not client:Alive() then return end

	local weapon_name
	if not data.ent.GetPrintName then
		weapon_name = data.ent:GetPrintName() or data.ent.PrintName or data.ent:GetClass() or "..."
	else
		weapon_name = data.ent.PrintName or data.ent:GetClass() or "..."
	end

	params.drawText = true
	params.displayInfo.key = bind.Find("ttt2_weaponswitch")
	params.displayInfo.title.text = TryT(weapon_name)
	params.displayInfo.subtitle.text = TryT('target_switch_weapon')

	params.drawOutline = true
	params.outlineColor = client:GetRoleColor()
end)

-- handle looking at players
hook.Add("TTTRenderEntityInfo", "TTT2HighlightPlayers", function(data, params)
	local client = LocalPlayer()
	local obsTgt = client:GetObserverTarget()

	-- has to be a player
	if not data.ent:IsPlayer() then return end

	-- do not show information when observing a player
	if client:IsSpec() and IsValid(obsTgt) and data.ent == obsTgt then return end

	local disguised = data.ent:GetNWBool("disguised", false)

	-- disguised players are not shown to normal players, except: same team, unknown team or to spectators
	if disguised and not (client:IsInTeam(ent) and not client:GetSubRoleData().unknownTeam or client:IsSpec()) then return end

	-- show the role of a player if it is known to the client
	local rstate = GetRoundState()
	local target_role

	-- TODO: this detective check has to be removed from here
	if data.ent.GetSubRole and (rstate > ROUND_PREP and data.ent:IsDetective() or rstate == ROUND_ACTIVE and data.ent:IsSpecial()) then
		target_role = data.ent:GetSubRole()
	end


	-- TODO generate text
	--text = ent:Nick() .. L.target_disg

	-- oof TTT, why so hacky?! Set last seen player, dear ready I don't like this at well, but it has to stay that way
	-- for compatibility reasons. At least it is uncluttered now!
	if disguised then
		client.last_id = nil
	else
		client.last_id = data.ent
	end
end)


-- handle looking ragdolls
hook.Add("TTTRenderEntityInfo", "TTT2HighlightRagdolls", function(data, params)
	local client = LocalPlayer()

	if data.ent:GetClass() ~= "prop_ragdoll" then return end

	-- only show this if the ragdoll has a nick, else it could be a mattress
	if not CORPSE.GetPlayerNick(data.ent, false) then return end

	-- TODO text
	--if CORPSE.GetFound(ent, false) or not DetectiveMode() then
	--	text = CORPSE.GetPlayerNick(ent, "A Terrorist")
	--else
	--	text = L.target_unid
	--	color = COLOR_YELLOW
	--end
end)
