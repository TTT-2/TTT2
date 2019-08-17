---
--

local util = util
local surface = surface
local draw = draw
local GetPTranslation = LANG.GetParamTranslation
local GetRaw = LANG.GetRawTranslation
local GetLang = LANG.GetUnsafeLanguageTable
local GetPlayers = player.GetAll
local math = math
local table = table
local ipairs = ipairs
local IsValid = IsValid
local CreateConVar = CreateConVar
local hook = hook

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

-- "T" indicator above traitors
indicator_col = Color(255, 255, 255, 130)

local propspec_outline = Material("models/props_combine/portalball001_sheet")
local base = Material("vgui/ttt/dynamic/sprite_base")
local base_overlay = Material("vgui/ttt/dynamic/sprite_base_overlay")

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

	if client:IsSpecial() then
		dir = (client:GetForward() * -1)
		for i = 1, #plys do
			local ply = plys[i]
			local rd = ply:GetSubRoleData()
			
			local pos = ply:GetBonePosition(6)
			pos.z = pos.z + 20
			
			local ea = ply:EyeAngles()
			ea.pitch = 0
			local shift = Vector(2,0,0)
			shift:Rotate(ea)
			pos:Add(shift)
			
			if ply ~= client
			and ply:IsActive()
			and ply:IsSpecial()
			and (not client:IsActive() or ply:IsInTeam(client))
			and not ply:GetSubRoleData().avoidTeamIcons
			then
				local icon = Material("vgui/ttt/dynamic/roles/icon_" .. rd.abbr)
				local incol = ply:GetRoleColor()

				-- start linear filter
				render.PushFilterMag( TEXFILTER.LINEAR )
				render.PushFilterMin( TEXFILTER.LINEAR )

				-- draw color
				render.SetMaterial(base)
				render.DrawQuadEasy(pos, dir, 10, 10, incol, 180)

				-- draw border overlay
				render.SetMaterial(base_overlay)
				render.DrawQuadEasy(pos, dir, 10, 10, Color(255, 255, 255, 255), 180)

				-- draw shadow
				render.SetMaterial(icon)
				render.DrawQuadEasy(Vector(pos.x, pos.y, pos.z+ 0.2), dir, 8, 8, Color(0, 0, 0, 180), 180)

				-- draw icon
				render.SetMaterial(icon)
				render.DrawQuadEasy(Vector(pos.x, pos.y, pos.z + 0.5), dir, 8, 8, Color(255, 255, 255, 255), 180)

				-- stop linear filter
				render.PopFilterMag()
				render.PopFilterMin()
			end
		end
	end

	if client:Team() == TEAM_SPEC then
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

-- Crosshair affairs

surface.CreateFont("TargetIDSmall2", {font = "TargetID", size = 16, weight = 1000})

local minimalist = CreateConVar("ttt_minimal_targetid", "0", FCVAR_ARCHIVE)
local magnifier_mat = Material("icon16/magnifier.png")
local ring_tex = surface.GetTextureID("effects/select_ring")
local rag_color = Color(200, 200, 200, 255)
local MAX_TRACE_LENGTH = math.sqrt(3) * 32768

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

	local ent = trace.Entity

	if not IsValid(ent) or ent.NoTarget then return end

	-- some bools for caching what kind of ent we are looking at
	local target_role
	local target_corpse = false
	local text = nil
	local color = COLOR_WHITE

	-- if a vehicle, we identify the driver instead
	if IsValid(ent:GetNWEntity("ttt_driver", nil)) then
		ent = ent:GetNWEntity("ttt_driver", nil)

		if ent == client then return end
	end

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
end
