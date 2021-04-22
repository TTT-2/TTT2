---
-- Handling operations to display the TargetID
-- @author Mineotopia
-- @author ZenBreaker
-- @module TargetID

if SERVER then
	AddCSLuaFile()

	return
end

targetid = targetid or {}

-- Global to local variables
local bIsInitialized = false
local ParT, TryT

-- Variables for calculations
local MAX_TRACE_LENGTH = math.sqrt(3) * 32768

-- Key Parameters for doors
local key_params = {}

-- Convars for targetid
local cvDeteOnlyConfirm
local cvDeteOnlyInspect

-- Materials for targetid
local materialTButton = Material("vgui/ttt/tid/tid_big_tbutton_pointer")
local materialRing = Material("effects/select_ring")
local materialRoleUnknown = Material("vgui/ttt/tid/tid_big_role_not_known")
local materialDisguised = Material("vgui/ttt/perks/hud_disguiser.png")
local materialCorpse = Material("vgui/ttt/tid/tid_big_corpse")
local materialCredits = Material("vgui/ttt/tid/tid_credits")
local materialDetective = Material("vgui/ttt/tid/tid_detective")
local materialLocked = Material("vgui/ttt/tid/tid_locked")
local materialAutoClose = Material("vgui/ttt/tid/tid_auto_close")
local materialDoor = Material("vgui/ttt/tid/tid_big_door")
local materialDestructible = Material("vgui/ttt/tid/tid_destructible")
local materialDNATargetID = Material("vgui/ttt/dnascanner/dna_hud")

---
-- This function makes sure local variables, which use other libraries that are not yet initialized, are initialized later.
-- It gets called after all libraries are included and `cl_targetid.lua` gets included.
-- @note You don't need to call this if you want to use this library. It already gets called by `cl_targetid.lua`
-- @realm client
-- @local
function targetid.Initialize()
	if bIsInitialized then return end

	bIsInitialized = true
	ParT = LANG.GetParamTranslation
	TryT = LANG.TryTranslation
	key_params = {
		usekey = Key("+use", "USE"),
		walkkey = Key("+walk", "WALK")
	}

	cvDeteOnlyConfirm = GetConVar("ttt2_confirm_detective_only")
	cvDeteOnlyInspect = GetConVar("ttt2_inspect_detective_only")
end

---
-- This function handles finding Entities by casting a ray from a point in a direction, filtering out certain entities
-- Use this in combination with the hook @GM:TTTModifyTargetedEntity to create your own Remote Camera with TargetIDs.
-- e.g. This is used in @GM:HUDDrawTargetID before drawing the TargetIDs. Use that code as example.
-- @note This finds the next Entity, that doesn't get filtered out and can get hit by a bullet, from a position in a direction.
-- @param vector pos Position of Ray Origin.
-- @param vector dir Direction of the Ray. Should be normalized.
-- @param table filter List of all @{Entity}s that should be filtered out.
-- @return entity The Entity that got found
-- @return number The Distance between the Origin and the Entity
-- @realm client
function targetid.FindEntityAlongView(pos, dir, filter)
	local endpos = dir
	endpos:Mul(MAX_TRACE_LENGTH)
	endpos:Add(pos)

	local ent

	-- if the user is looking at a traitor button, it should always be handled with priority
	if TBHUD.focus_but and IsValid(TBHUD.focus_but.ent)
	and (TBHUD.focus_but.access or TBHUD.focus_but.admin) and TBHUD.focus_stick >= CurTime() then
		ent = TBHUD.focus_but.ent
		return ent, pos:Distance(ent:GetPos())
	end

	local trace = util.TraceLine({
		start = pos,
		endpos = endpos,
		mask = MASK_SHOT,
		filter = filter
	})

	-- this is the entity the player is looking at right now
	ent = trace.Entity

	-- if a vehicle, we identify the driver instead
	if IsValid(ent) and IsValid(ent:GetNWEntity("ttt_driver", nil)) then
		ent = ent:GetNWEntity("ttt_driver", nil)
	end

	return ent, trace.StartPos:Distance(trace.HitPos)
end

---
-- This function handles looking at traitor buttons and adds a description
-- @param TARGET_DATA tData The object to be used in the hook
-- @realm client
function targetid.HUDDrawTargetIDTButtons(tData)
	local client = LocalPlayer()
	local ent = tData:GetEntity()

	local admin_mode = GetGlobalBool("ttt2_tbutton_admin_show", false)

	if not IsValid(client) or not client:IsTerror() or not client:Alive()
	or not IsValid(ent) or ent:GetClass() ~= "ttt_traitor_button"
	or tData:GetEntityDistance() > ent:GetUsableRange() then
		return
	end

	-- enable targetID rendering
	tData:EnableText()

	-- set the title of the traitor button
	tData:SetTitle(ent:GetDescription() == "?" and "Traitor Button" or TryT(ent:GetDescription()))

	-- set the subtitle and icon depending on the currently used mode
	if TBHUD.focus_but.admin and not TBHUD.focus_but.access then
		tData:AddIcon(
			materialTButton,
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

---
-- This function handles looking at weapons and adds specific descriptions
-- @param TARGET_DATA tData The object to be used in the hook
-- @realm client
function targetid.HUDDrawTargetIDWeapons(tData)
	local client = LocalPlayer()
	local ent = tData:GetEntity()

	if not IsValid(client) or not client:IsTerror() or not client:Alive()
	or not IsValid(ent) or tData:GetEntityDistance() > 100 or not ent:IsWeapon() then
		return
	end

	local dropWeapon, isActiveWeapon, switchMode = GetBlockingWeapon(client, ent)
	local kind_pickup_wep = MakeKindValid(ent.Kind)

	local weapon_name

	if ent.GetPrintName then
		weapon_name = ent:GetPrintName()
	end

	weapon_name = weapon_name or ent.PrintName or ent:GetClass() or "..."

	-- enable targetID rendering
	tData:EnableText()
	tData:EnableOutline()
	tData:SetOutlineColor(client:GetRoleColor())

	-- general info
	tData:SetKey(bind.Find("ttt2_weaponswitch"))

	tData:SetTitle(TryT(weapon_name) .. " [" .. ParT("target_slot_info", {slot = kind_pickup_wep}) .. "]")

	local key_params_wep = {
		usekey = string.upper(input.GetKeyName(bind.Find("ttt2_weaponswitch")) or ""),
		walkkey = Key("+walk", "WALK")
	}

	-- set subtitle depending on the switchmode
	if switchMode == SWITCHMODE_PICKUP then
		tData:SetSubtitle(ParT("target_pickup_weapon", key_params_wep) .. (not isActiveWeapon and ParT("target_pickup_weapon_hidden", key_params_wep) or ""))
	elseif switchMode == SWITCHMODE_SWITCH then
		tData:SetSubtitle(ParT("target_switch_weapon", key_params_wep) .. (not isActiveWeapon and ParT("target_switch_weapon_hidden", key_params_wep) or ""))
	elseif switchMode == SWITCHMODE_FULLINV then
		tData:SetSubtitle(TryT("target_switch_weapon_nospace"))
	end

	-- add additional dropping info if weapon is switched
	if switchMode == SWITCHMODE_SWITCH then
		local dropWepKind = MakeKindValid(dropWeapon.Kind)
		local dropWeapon_name

		if dropWeapon.GetPrintName then
			dropWeapon_name = dropWeapon:GetPrintName()
		end

		dropWeapon_name = dropWeapon_name or dropWeapon.PrintName or dropWeapon:GetClass() or "..."

		tData:AddDescriptionLine(
			ParT("target_switch_drop_weapon_info", {slot = dropWepKind, name = TryT(dropWeapon_name)}),
			COLOR_ORANGE
		)
	end

	-- add info about full inventory
	if switchMode == SWITCHMODE_FULLINV then
		tData:AddDescriptionLine(
			ParT("target_switch_drop_weapon_info_noslot", {slot = MakeKindValid(ent.Kind)}),
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

---
-- This function handles looking at players and adds specific descriptions
-- @param TARGET_DATA tData The object to be used in the hook
-- @realm client
function targetid.HUDDrawTargetIDPlayers(tData)
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

	if rstate == ROUND_ACTIVE and ent.HasRole and ent:HasRole() then
		target_role = ent:GetSubRoleData()
	end

	-- add glowing ring around crosshair when role is known
	if target_role then
		local icon_size = 64

		draw.FilteredTexture(math.Round(0.5 * (ScrW() - icon_size)), math.Round(0.5 * (ScrH() - icon_size)), icon_size, icon_size, materialRing, 200, target_role.color)
	end

	-- enable targetID rendering
	tData:EnableText()

	-- add title and subtitle to the focused ent
	local h_string, h_color = util.HealthToString(ent:Health(), ent:GetMaxHealth())

	tData:SetTitle(
		ent:Nick() .. (disguised and (" " .. TryT("target_disg")) or ""),
		disguised and COLOR_ORANGE or nil,
		disguised and {materialDisguised} or nil
	)

	tData:SetSubtitle(
		TryT(h_string),
		h_color
	)

	-- add icon to the element
	tData:AddIcon(
		target_role and target_role.iconMaterial or materialRoleUnknown,
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

---
-- This function handles looking at ragdolls and adds specific descriptions
-- @param TARGET_DATA tData The object to be used in the hook
-- @realm client
function targetid.HUDDrawTargetIDRagdolls(tData)
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
	local roleData = roles.GetByIndex(role_found and ent.search_result.role or ROLE_INNOCENT)

	-- enable targetID rendering
	tData:EnableText()
	tData:EnableOutline(tData:GetEntityDistance() <= 100)
	tData:SetOutlineColor(COLOR_YELLOW)

	-- add title and subtitle to the focused ent
	tData:SetTitle(
		corpse_found and CORPSE.GetPlayerNick(ent, TryT("target_unknown")) or TryT("target_unid"),
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
		role_found and roleData.iconMaterial or materialCorpse,
		role_found and roleData.color or COLOR_YELLOW
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
			roles.DETECTIVE.ltcolor,
			{materialDetective}
		)
	end

	-- add credits info when corpse has credits
	if client:IsActive() and client:IsShopper() and CORPSE.GetCredits(ent, 0) > 0 then
		tData:AddDescriptionLine(
			TryT("target_credits"),
			COLOR_YELLOW,
			{materialCredits}
		)
	end
end


---
-- This function handles looking at doors and adds specific descriptions
-- @param TARGET_DATA tData The object to be used in the hook
-- @realm client
function targetid.HUDDrawTargetIDDoors(tData)
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
			{materialLocked}
		)
	elseif ent:DoorAutoCloses() then
		tData:AddDescriptionLine(
			TryT("door_auto_closes"),
			COLOR_SLATEGRAY,
			{materialAutoClose}
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

---
-- This function handles looking with a DNA Scanner and adds specific descriptions
-- @param TARGET_DATA tData The object to be used in the hook
-- @realm client
function targetid.HUDDrawTargetIDDNAScanner(tData)
	local client = LocalPlayer()
	local ent = tData:GetEntity()

	if not IsValid(client:GetActiveWeapon()) or client:GetActiveWeapon():GetClass() ~= "weapon_ttt_wtester"
	or tData:GetEntityDistance() > 400 or not IsValid(ent) then
		return
	end

	-- add an empty line if there's already data in the description area
	if tData:GetAmountDescriptionLines() > 0 then
		tData:AddDescriptionLine()
	end

	if ent:IsWeapon() or ent.CanHavePrints or ent:GetNWBool("HasPrints", false)
	or ent:GetClass() == "prop_ragdoll" and CORPSE.GetPlayerNick(ent, false) then
		tData:AddDescriptionLine(TryT("dna_tid_possible"), COLOR_GREEN, {materialDNATargetID})
	else
		tData:AddDescriptionLine(TryT("dna_tid_impossible"), COLOR_RED, {materialDNATargetID})
	end
end
