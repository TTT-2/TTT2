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
local materialFire = Material("vgui/ttt/tid/tid_onfire")

local cv_ttt_identify_body_woconfirm = CORPSE and CORPSE.cv.identify_body_woconfirm

hook.Add("Initialize", "TTT2TargetID", function()
    cv_ttt_identify_body_woconfirm = CORPSE.cv.identify_body_woconfirm
end)

---
-- This function makes sure local variables, which use other libraries that are not yet initialized, are initialized later.
-- It gets called after all libraries are included and `cl_targetid.lua` gets included.
-- @note You don't need to call this if you want to use this library. It already gets called by `cl_targetid.lua`
-- @internal
-- @local
-- @realm client
function targetid.Initialize()
    if bIsInitialized then
        return
    end

    bIsInitialized = true
    ParT = LANG.GetParamTranslation
    TryT = LANG.TryTranslation
    key_params = {
        primaryfire = Key("+attack", "MOUSE1"),
        secondaryfire = Key("+attack2", "MOUSE2"),
        usekey = Key("+use", "USE"),
        walkkey = Key("+walk", "WALK"),
    }
end

local PLAYER_USE_RADIUS = 80

---
-- This function handles finding Entities by casting a ray from a point in a direction, filtering out certain entities
-- Use this in combination with the hook @GM:TTTModifyTargetedEntity to create your own Remote Camera with TargetIDs.
-- e.g. This is used in @GM:HUDDrawTargetID before drawing the TargetIDs. Use that code as example.
-- @note This finds the next Entity, that doesn't get filtered out and can get hit by a bullet, from a position in a direction.
-- @param Vector pos Position of Ray Origin.
-- @param Vector dir Direction of the Ray. Should be normalized.
-- @param table filter List of all @{Entity}s that should be filtered out.
-- @return Entity The Entity that got found
-- @return number The Distance between the Origin and the Entity
-- @realm client
function targetid.FindEntityAlongView(pos, dir, filter)
    local client = LocalPlayer()

    local endpos = dir * MAX_TRACE_LENGTH
    endpos:Add(pos)

    if entspawnscript.IsEditing(client) then
        local focusedSpawn = entspawnscript.GetFocusedSpawn()
        local wepEditEnt = entspawnscript.GetSpawnInfoEntity()

        if focusedSpawn and IsValid(wepEditEnt) then
            return wepEditEnt, pos:Distance(focusedSpawn.spawn.pos)
        end
    end

    -- if the user is looking at a traitor button, it should always be handled with priority
    if
        TBHUD.focus_but
        and IsValid(TBHUD.focus_but.ent)
        and (TBHUD.focus_but.access or TBHUD.focus_but.admin)
        and TBHUD.focus_stick >= CurTime()
    then
        local ent = TBHUD.focus_but.ent

        return ent, pos:Distance(ent:GetPos())
    end

    local tracedata = {
        start = pos,
        endpos = endpos,
        filter = filter,
    }

    local trace = util.TraceLine(tracedata)

    -- if nothing is hit, check again with a different mask
    -- this will hit any solid buttons
    if not IsValid(trace.Entity) then
        tracedata.mask = bit.bor(MASK_SOLID, CONTENTS_DEBRIS, CONTENTS_PLAYERCLIP)

        trace = util.TraceLine(tracedata)
    end

    -- this is the entity the player is looking at right now
    local ent = trace.Entity
    local distance = trace.StartPos:Distance(trace.HitPos)

    -- if nothing is hit, try to look for non-solid buttons
    if not IsValid(ent) then
        --local buttons = ents.FindInCone(pos, dir, PLAYER_USE_RADIUS, 0.8)
        local buttons = ents.FindInSphere(pos, PLAYER_USE_RADIUS)

        local rayDelta = dir * PLAYER_USE_RADIUS

        for i = 1, #buttons do
            local e = buttons[i]

            if e:IsSolid() or not e:IsButton() then
                continue
            end

            local _, _, frac = util.IntersectRayWithOBB(
                pos,
                rayDelta,
                e:GetPos(),
                e:GetAngles(),
                e:GetCollisionBounds()
            )

            if not frac then
                continue
            end

            local dist = frac * PLAYER_USE_RADIUS

            if dist < distance then
                distance = dist
                ent = e
            end
        end
    end

    -- if a vehicle, we identify the driver instead
    if IsValid(ent) and ent:IsVehicle() then
        local driver = ent:GetDriver()

        if IsValid(driver) and driver ~= client then
            ent = driver
        end
    end

    return ent, distance
end

---
-- This function handles looking at spawns and adds a description
-- @param TARGET_DATA tData The object to be used in the hook
-- @realm client
function targetid.HUDDrawTargetIDSpawnEdit(tData)
    local client = LocalPlayer()

    if not entspawnscript.IsEditing(client) then
        return
    end

    local ent = tData:GetEntity()
    local wep = client:GetActiveWeapon()

    if
        not IsValid(client)
        or not IsValid(wep)
        or wep:GetClass() ~= "weapon_ttt_spawneditor"
        or not IsValid(ent)
        or ent:GetClass() ~= "ttt_spawninfo_ent"
    then
        return
    end

    local focusedSpawn = entspawnscript.GetFocusedSpawn()

    if not focusedSpawn then
        return
    end

    local spawnType = focusedSpawn.spawnType
    local entType = focusedSpawn.entType
    local ammoAmount = focusedSpawn.spawn.ammo

    -- enable targetID rendering
    tData:EnableText()
    tData:AddIcon(entspawnscript.GetIconFromSpawnType(spawnType, entType))
    tData:SetSubtitle(ParT("spawn_remove", key_params))

    if spawnType == SPAWN_TYPE_WEAPON then
        tData:SetTitle(
            TryT(entspawnscript.GetLangIdentifierFromSpawnType(spawnType, entType))
                .. ParT("spawn_weapon_ammo", { ammo = ammoAmount })
        )

        tData:AddDescriptionLine(
            TryT("spawn_type_weapon"),
            entspawnscript.GetColorFromSpawnType(SPAWN_TYPE_WEAPON)
        )

        tData:AddDescriptionLine()

        tData:AddDescriptionLine(ParT("spawn_weapon_edit_ammo", key_params))
    elseif spawnType == SPAWN_TYPE_AMMO then
        tData:SetTitle(TryT(entspawnscript.GetLangIdentifierFromSpawnType(spawnType, entType)))

        tData:AddDescriptionLine(
            TryT("spawn_type_ammo"),
            entspawnscript.GetColorFromSpawnType(SPAWN_TYPE_AMMO)
        )
    elseif spawnType == SPAWN_TYPE_PLAYER then
        tData:SetTitle(TryT(entspawnscript.GetLangIdentifierFromSpawnType(spawnType, entType)))

        tData:AddDescriptionLine(
            TryT("spawn_type_player"),
            entspawnscript.GetColorFromSpawnType(SPAWN_TYPE_PLAYER)
        )
    end
end

---
-- This function handles looking at traitor buttons and adds a description
-- @param TARGET_DATA tData The object to be used in the hook
-- @realm client
function targetid.HUDDrawTargetIDTButtons(tData)
    local client = LocalPlayer()
    local ent = tData:GetEntity()

    local admin_mode = GetGlobalBool("ttt2_tbutton_admin_show", false)

    if
        not IsValid(client)
        or not client:IsTerror()
        or not IsValid(ent)
        or ent:GetClass() ~= "ttt_traitor_button"
        or tData:GetEntityDistance() > ent:GetUsableRange()
    then
        return
    end

    -- enable targetID rendering
    tData:EnableText()

    -- set the title of the traitor button
    tData:SetTitle(ent:GetDescription() == "?" and "Traitor Button" or TryT(ent:GetDescription()))

    -- set the subtitle and icon depending on the currently used mode
    if TBHUD.focus_but.admin and not TBHUD.focus_but.access then
        tData:AddIcon(materialTButton, COLOR_LGRAY)

        tData:SetSubtitle(TryT("tbut_help_admin"))
    else
        tData:SetKey(input.GetKeyCode(key_params.usekey))

        tData:SetSubtitle(ParT("tbut_help", key_params))
    end

    -- add description time with some general info about this specific traitor button
    if ent:GetDelay() < 0 then
        tData:AddDescriptionLine(TryT("tbut_single"), client:GetRoleColor())
    elseif ent:GetDelay() == 0 then
        tData:AddDescriptionLine(TryT("tbut_reuse"), client:GetRoleColor())
    else
        tData:AddDescriptionLine(
            ParT("tbut_retime", { num = ent:GetDelay() }),
            client:GetRoleColor()
        )
    end

    -- only add more information if in admin mode
    if not admin_mode or not admin.IsAdmin(client) then
        return
    end

    local but = TBHUD.focus_but

    tData:AddDescriptionLine() -- adding empty line

    tData:AddDescriptionLine(TryT("tbut_adminarea"), COLOR_WHITE)

    tData:AddDescriptionLine(
        ParT("tbut_role_toggle", {
            usekey = key_params.usekey,
            walkkey = key_params.walkkey,
            role = client:GetRoleString(),
        }),
        COLOR_WHITE
    )

    tData:AddDescriptionLine(
        ParT("tbut_team_toggle", {
            usekey = key_params.usekey,
            walkkey = key_params.walkkey,
            team = TryT(client:GetTeam()),
        }),
        COLOR_WHITE
    )

    tData:AddDescriptionLine() -- adding empty line

    tData:AddDescriptionLine(TryT("tbut_current_config"), COLOR_WHITE)

    local l_role = but.overrideRole == nil and "tbut_default"
        or but.overrideRole and "tbut_allow"
        or "tbut_prohib"
    local l_team = but.overrideTeam == nil and "tbut_default"
        or but.overrideTeam and "tbut_allow"
        or "tbut_prohib"

    tData:AddDescriptionLine(
        ParT("tbut_role_config", { current = TryT(l_role) })
            .. ", "
            .. ParT("tbut_team_config", { current = TryT(l_team) }),
        COLOR_LGRAY
    )

    tData:AddDescriptionLine(TryT("tbut_intended_config"), COLOR_WHITE)

    local l_roleIntend = but.roleIntend == "none" and "tbut_default" or but.roleIntend
    local l_teamIntend = but.teamIntend == TEAM_NONE and "tbut_default" or but.teamIntend

    tData:AddDescriptionLine(
        ParT("tbut_role_config", { current = LANG.GetRawTranslation(l_roleIntend) or l_roleIntend })
            .. ", "
            .. ParT(
                "tbut_team_config",
                { current = LANG.GetRawTranslation(l_teamIntend) or l_teamIntend }
            ),
        COLOR_LGRAY
    )

    if not TBHUD.focus_but.admin or TBHUD.focus_but.access then
        return
    end

    tData:AddDescriptionLine() -- adding empty line

    tData:AddDescriptionLine(
        ParT("tbut_admin_mode_only", { cv = "ttt2_tbutton_admin_show" }),
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

    if
        not IsValid(client)
        or not client:IsTerror()
        or not IsValid(ent)
        or tData:GetEntityDistance() > 100
        or not ent:IsWeapon()
    then
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
    tData:SetKey(input.GetKeyCode(Key("+use", "USE")))
    tData:SetTitle(
        TryT(weapon_name) .. " [" .. ParT("target_slot_info", { slot = kind_pickup_wep }) .. "]"
    )

    local key_params_wep = {
        usekey = Key("+use", "USE"),
        walkkey = Key("+walk", "WALK"),
    }

    -- set subtitle depending on the switchmode
    if switchMode == SWITCHMODE_PICKUP then
        tData:SetSubtitle(
            ParT("target_pickup_weapon", key_params_wep)
                .. (
                    not isActiveWeapon and ParT("target_pickup_weapon_hidden", key_params_wep)
                    or ""
                )
        )
    elseif switchMode == SWITCHMODE_SWITCH then
        tData:SetSubtitle(
            ParT("target_switch_weapon", key_params_wep)
                .. (
                    not isActiveWeapon and ParT("target_switch_weapon_hidden", key_params_wep)
                    or ""
                )
        )
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
            ParT(
                "target_switch_drop_weapon_info",
                { slot = dropWepKind, name = TryT(dropWeapon_name) }
            ),
            COLOR_ORANGE
        )
    end

    -- add info about full inventory
    if switchMode == SWITCHMODE_FULLINV then
        tData:AddDescriptionLine(
            ParT("target_switch_drop_weapon_info_noslot", { slot = MakeKindValid(ent.Kind) }),
            COLOR_ORANGE
        )
    end

    -- add info if your weapon can not be dropped
    if switchMode == SWITCHMODE_NOSPACE then
        tData:AddDescriptionLine(TryT("drop_no_room"), COLOR_ORANGE)
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
    if not ent:IsPlayer() then
        return
    end

    local disguised = ent:GetNWBool("disguised", false)

    -- oof TTT, why so hacky?! Sets last seen player. Dear reader I don't like this as well, but it has to stay that way
    -- for compatibility reasons. At least it is uncluttered now!
    client.last_id = disguised and nil or ent

    -- do not show information when observing a player
    if client:IsSpec() and IsValid(obsTgt) and ent == obsTgt then
        return
    end

    -- disguised players are not shown to normal players, except: same team, unknown team or to spectators
    if
        disguised
        and not (
            client:IsInTeam(ent) and not client:GetSubRoleData().unknownTeam or client:IsSpec()
        )
    then
        return
    end

    -- show the role of a player if it is known to the client
    local rstate = gameloop.GetRoundState()
    local target_role

    if rstate == ROUND_ACTIVE and ent.HasRole and ent:HasRole() then
        target_role = ent:GetSubRoleData()
    end

    -- add glowing ring around crosshair when role is known
    if target_role then
        local icon_size = 64

        draw.FilteredTexture(
            math.Round(0.5 * (ScrW() - icon_size)),
            math.Round(0.5 * (ScrH() - icon_size)),
            icon_size,
            icon_size,
            materialRing,
            200,
            target_role.color
        )
    end

    -- enable targetID rendering
    tData:EnableText()

    -- add title and subtitle to the focused ent
    local h_string, h_color = util.HealthToString(ent:Health(), ent:GetMaxHealth())

    tData:SetTitle(
        ent:Nick() .. (disguised and (" " .. TryT("target_disg")) or ""),
        disguised and COLOR_ORANGE or nil,
        disguised and { materialDisguised } or nil
    )

    tData:SetSubtitle(TryT(h_string), h_color)

    -- add icon to the element
    tData:AddIcon(
        target_role and target_role.iconMaterial or materialRoleUnknown,
        target_role and ent:GetRoleColor() or COLOR_SLATEGRAY
    )

    -- add karma string if karma is enabled
    if KARMA.IsEnabled() then
        local k_string, k_color = util.KarmaToString(ent:GetBaseKarma())

        tData:AddDescriptionLine(TryT(k_string), k_color)
    end

    -- add scoreboard tags if tag is set
    if ent.sb_tag and ent.sb_tag.txt then
        tData:AddDescriptionLine(TryT(ent.sb_tag.txt), ent.sb_tag.color)
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
    if not IsValid(ent) or not ent:IsPlayerRagdoll() then
        return
    end

    local corpse_found = CORPSE.GetFound(ent, false) or not gameloop.IsDetectiveMode()
    local corpse_ply = corpse_found and CORPSE.GetPlayer(ent) or false
    local binoculars_useable = IsValid(c_wep) and c_wep:GetClass() == "weapon_ttt_binoculars"
        or false
    local role_found = (corpse_found and ent.bodySearchResult and ent.bodySearchResult.subrole)
        or (IsValid(corpse_ply) and corpse_ply:GetSubRole())
    local roleData = (IsValid(corpse_ply) and corpse_ply:GetSubRoleData())
        or roles.GetByIndex(role_found and ent.bodySearchResult.subrole or ROLE_INNOCENT)
    local roleDataClient = client:GetSubRoleData()

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
        if client:IsSpec() then
            tData:SetSubtitle(ParT("corpse_hint_spectator", key_params))
        elseif
            bodysearch.GetInspectConfirmMode() == 2
            and not (roleDataClient.isPolicingRole and roleDataClient.isPublicRole)
        then
            -- a detective added search results, this should change the targetID
            if ent.bodySearchResult and ent.bodySearchResult.base.isPublicPolicingSearch then
                tData:SetSubtitle(ParT("corpse_hint_public_policing_searched", key_params))
            else
                tData:SetSubtitle(ParT("corpse_hint_inspect_limited", key_params))
            end
            tData:AddDescriptionLine(TryT("corpse_hint_inspect_limited_details"))
        elseif
            bodysearch.GetInspectConfirmMode() == 1
            and not (roleDataClient.isPolicingRole and roleDataClient.isPublicRole)
        then
            tData:SetSubtitle(ParT("corpse_hint_inspect_limited", key_params))
            tData:AddDescriptionLine(TryT("corpse_hint_inspect_limited_details"))
        elseif
            bodysearch.GetInspectConfirmMode() == 0
            and not cv_ttt_identify_body_woconfirm:GetBool()
        then
            tData:SetSubtitle(ParT("corpse_hint_without_confirm", key_params))
        else
            tData:SetSubtitle(ParT("corpse_hint", key_params))
        end

        if ent:IsOnFire() then
            tData:AddDescriptionLine(TryT("body_burning"), COLOR_ORANGE, { materialFire })
        end
    elseif binoculars_useable then
        tData:SetSubtitle(ParT("corpse_binoculars", { key = Key("+attack", "ATTACK") }))
    else
        tData:SetSubtitle(TryT("corpse_too_far_away"))
    end

    -- add icon to the element
    tData:AddIcon(
        role_found and roleData.iconMaterial or materialCorpse,
        role_found and roleData.color or COLOR_YELLOW
    )

    -- add info if searched by detectives
    if ent.bodySearchResult and ent.bodySearchResult.base.isPublicPolicingSearch then
        tData:AddDescriptionLine(
            TryT("corpse_searched_by_detective"),
            roles.DETECTIVE.ltcolor,
            { materialDetective }
        )
    end

    -- add credits info when corpse has credits
    if bodysearch.CanTakeCredits(client, ent) then
        local creditsHint = "target_credits_on_search"
        if bodysearch.GetInspectConfirmMode() == 0 then
            creditsHint = "target_credits_on_confirm"
        end

        tData:AddDescriptionLine(TryT(creditsHint), COLOR_GOLD, { materialCredits })
    end
end

---
-- This function handles looking at buttons and adds specific descriptions
-- @param TARGET_DATA tData The object to be used in the hook
-- @realm client
function targetid.HUDDrawTargetIDButtons(tData)
    local client = LocalPlayer()
    local ent = tData:GetEntity()

    if not IsValid(client) or not client:IsTerror() or not IsValid(ent) then
        return
    end

    -- button is supposed to be invisible
    if ent:GetNoDraw() or ent:GetRenderMode() == RENDERMODE_NONE then
        return
    end

    -- check if parent is button (for prop models parented to buttons and such)
    if not ent:IsButton() then
        ent = ent:GetMoveParent()

        if not IsValid(ent) or not ent:IsButton() then
            return
        end
    end

    if tData:GetEntityDistance() > 100 then
        return
    end

    -- enable targetID rendering
    tData:EnableText()
    tData:EnableOutline()
    tData:SetOutlineColor(client:GetRoleColor())

    tData:SetKey(input.GetKeyCode(key_params.usekey))

    if ent:IsDefaultButton() then
        tData:SetTitle(TryT("name_button_default"))
        tData:SetSubtitle(ParT("button_default", key_params))
    end

    if ent:IsRotatingButton() then
        tData:SetTitle(TryT("name_button_rotating"))
        tData:SetSubtitle(ParT("button_rotating", key_params))
    end
end

---
-- This function handles looking at doors and adds specific descriptions
-- @param TARGET_DATA tData The object to be used in the hook
-- @realm client
function targetid.HUDDrawTargetIDDoors(tData)
    local client = LocalPlayer()
    local ent = tData:GetEntity()

    if not IsValid(client) or not client:IsTerror() or not IsValid(ent) then
        return
    end

    -- door is supposed to be invisible
    if ent:GetNoDraw() or ent:GetRenderMode() == RENDERMODE_NONE then
        return
    end

    -- check if parent is door (for doors with breakable glass and such)
    if not ent:IsDoor() then
        ent = ent:GetMoveParent()

        if not IsValid(ent) or not ent:IsDoor() then
            return
        end
    end

    if not ent:PlayerCanOpenDoor() or tData:GetEntityDistance() > 90 then
        return
    end

    -- enable targetID rendering
    tData:EnableText()

    tData:SetTitle(TryT("name_door"))

    if ent:UseOpensDoor() and not ent:TouchOpensDoor() then
        if ent:DoorAutoCloses() then
            tData:SetSubtitle(ParT("door_open", key_params))
        else
            tData:SetSubtitle(
                ent:IsDoorOpen() and ParT("door_close", key_params) or ParT("door_open", key_params)
            )
        end

        tData:SetKey(input.GetKeyCode(key_params.usekey))
    elseif not ent:UseOpensDoor() and ent:TouchOpensDoor() then
        tData:SetSubtitle(TryT("door_open_touch"))
        tData:AddIcon(materialDoor, COLOR_LGRAY)
    else
        tData:SetSubtitle(ParT("door_open_touch_and_use", key_params))
        tData:SetKey(input.GetKeyCode(key_params.usekey))
    end

    if ent:IsDoorLocked() then
        tData:AddDescriptionLine(TryT("door_locked"), COLOR_ORANGE, { materialLocked })
    elseif ent:DoorAutoCloses() then
        tData:AddDescriptionLine(TryT("door_auto_closes"), COLOR_SLATEGRAY, { materialAutoClose })
    end

    if ent:DoorIsDestructible() then
        tData:AddDescriptionLine(
            ParT("door_destructible", { health = math.ceil(ent:GetFastSyncedHealth()) }),
            COLOR_LBROWN,
            { materialDestructible }
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

    if
        not IsValid(client:GetActiveWeapon())
        or client:GetActiveWeapon():GetClass() ~= "weapon_ttt_wtester"
        or tData:GetEntityDistance() > 400
        or not IsValid(ent)
    then
        return
    end

    -- add an empty line if there's already data in the description area
    if tData:GetAmountDescriptionLines() > 0 then
        tData:AddDescriptionLine()
    end

    if
        ent:IsWeapon()
        or ent.CanHavePrints
        or ent:GetNWBool("HasPrints", false)
        or ent:IsPlayerRagdoll()
    then
        tData:AddDescriptionLine(TryT("dna_tid_possible"), COLOR_GREEN, { materialDNATargetID })
    else
        tData:AddDescriptionLine(TryT("dna_tid_impossible"), COLOR_RED, { materialDNATargetID })
    end
end

---
-- This function handles looking at usable vehicles
-- @param TARGET_DATA tData The object to be used in the hook
-- @realm client
function targetid.HUDDrawTargetIDVehicle(tData)
    local client = LocalPlayer()
    local ent = tData:GetEntity()

    if
        not IsValid(client)
        or not client:IsTerror()
        or client:InVehicle()
        or not IsValid(ent)
        or not ent:IsVehicle()
        or tData:GetEntityDistance() > 100
    then
        return
    end

    -- enable targetID rendering
    tData:EnableText()
    tData:EnableOutline()
    tData:SetOutlineColor(client:GetRoleColor())

    tData:SetKey(input.GetKeyCode(key_params.usekey))

    tData:SetTitle(TryT(ent.PrintName or "name_vehicle"))
    tData:SetSubtitle(ParT("vehicle_enter", key_params))
end
