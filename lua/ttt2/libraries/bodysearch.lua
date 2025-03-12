---
-- Handling body search data and data processing. Is shared between the server and client
-- @author Mineotopia

---@class BaseData
---@field inspector Player The player that inspected the body
---@field isPublicPolicingSearch boolean Whether to inspector is a public policing role (this check here also includes if the player was not a spectator and the search was not covered)

---@class SceneData
---@field base BaseData The base data that is not overwritten, even if the data is merged
---@field playerModel string The string to the player model of the dead player
---@field ragOwner Player The owner of the ragdoll, in general the dead player
---@field credits number The amount of credits stored in the body
---@field searchUID number The search UID that is sued to track search requests
---@field isCovert boolean Whether the search was covered (ALT + search)
---@field isLongRange boolean Whether the search was long range (e.g. binoculars)
---@field nick string The dead player's nick
---@field subrole number The dead player's role ID
---@field roleColor Color The dead player's role color
---@field team string The dead player's team
---@field rag Entity The ragdoll that is searched
---@field eq table The equipment that the player carried before dying. Defaults to {}
---@field c4CutWire number The c4 wire the player cut, if they cut any. Defaults to -1
---@field dmgType number The damage type that killed the player. Defaults to DMG_GENERIC
---@field wep string The weapon that killed the player
---@field lastWords string The last words that were typed in the chat while being killed
---@field wasHeadshot boolean Whether the killing shot was a head shot
---@field deathTime number The death time
---@field sid64 string The dead player's SteamID64
---@field lastDamage number The last damage amount the player took before dying
---@field killFloorSurface number The ground surface where the player died
---@field killWaterLevel number The water level of the player when they were killed
---@field lastSeenEnt Player The last seen player entity
---@field killDistance number The distance to the killer when it happened as an obscured enum. Defaults to CORPSE_KILL_NO_DATA
---@field killHitGroup number The damage hitgroup of the killing blow. Default to HITGROUP_GENERIC
---@field killOrientation number The orientation to the killer when it happened as an obscured enum. Defaults to CORPSE_KILL_NO_DATA
---@field sampleDecayTime number The DNA sample decay time. Defaults to 0
---@field killEntityIDList table A table of the entity indexes of all the player the dead player killed

if SERVER then
    AddCSLuaFile()
end

CORPSE_KILL_NO_DATA = 0

CORPSE_KILL_DISTANCE_POINT_BLANK = 1
CORPSE_KILL_DISTANCE_CLOSE = 2
CORPSE_KILL_DISTANCE_FAR = 3

CORPSE_KILL_DIRECTION_FRONT = 1
CORPSE_KILL_DIRECTION_BACK = 2
CORPSE_KILL_DIRECTION_SIDE = 3

---
-- @realm shared
-- mode 0: normal behavior, everyone can search/confirm bodies
-- mode 1: only public policing roles can confirm bodies, but everyone can still see all data in the menu
-- mode 2: only public policing roles can confirm and search bodies
local cvInspectConfirmMode = CreateConVar(
    "ttt2_inspect_confirm_mode",
    "0",
    { FCVAR_NOTIFY, FCVAR_ARCHIVE, FCVAR_REPLICATED }
)

---
-- @realm shared
-- off (0): only roles which have a shop can see credits on a body
-- on (1), default: all roles can see credits on a body
-- NOTE: On is default only for compatability. Many players seem to expect it to not be the case by default,
--       so perhaps it'd be a good idea to default to off.
local cvCreditsVisibleToAll = CreateConVar(
    "ttt2_inspect_credits_always_visible",
    "1",
    { FCVAR_NOTIFY, FCVAR_ARCHIVE, FCVAR_REPLICATED }
)

local materialWeaponFallback = Material("vgui/ttt/missing_equip_icon")

bodysearch = {}

---
-- Returns the current body inspect/confirm mode that is defined on the server.
-- @note This is basically a wrapper for the convar `ttt2_inspect_confirm_mode`.
-- @return number The body inspect/confirm mode
-- @realm shared
function bodysearch.GetInspectConfirmMode()
    return cvInspectConfirmMode:GetInt()
end

---
-- Checks if a given player is allowed to take credits from a given corpse-
-- @param Player ply The player that tries to take credits
-- @param Entity rag The ragdoll where the credits should be taken from
-- @param[default=false] isLongRange Whether the search is a long range search
-- @return boolean Returns if the player is able to take credits
-- @realm shared
function bodysearch.CanTakeCredits(ply, rag, isLongRange)
    ---
    -- @realm shared
    local hookOverride = hook.Run("TTT2CanTakeCredits", ply, rag, isLongRange)
    if hookOverride ~= nil then
        return hookOverride
    end

    local credits = CORPSE.GetCredits(rag, 0)

    return ply:IsActiveShopper()
        and not ply:GetSubRoleData().preventFindCredits
        and credits > 0
        and not isLongRange
end

if SERVER then
    local mathMax = math.max
    local mathRound = math.Round
    local mathFloor = math.floor

    local cv_ttt2_confirm_killlist = CORPSE and CORPSE.cv.confirm_killlist

    hook.Add("Initialize", "TTT2BodySearch", function()
        cv_ttt2_confirm_killlist = CORPSE.cv.confirm_killlist
    end)

    util.AddNetworkString("ttt2_client_reports_corpse")
    util.AddNetworkString("ttt2_client_confirm_corpse")
    util.AddNetworkString("ttt2_credits_were_taken")

    net.Receive("ttt2_client_confirm_corpse", function(_, ply)
        if not IsValid(ply) then
            return
        end

        local rag = net.ReadEntity()
        local searchUID = net.ReadUInt(16)
        local isLongRange = net.ReadBool()
        local creditsOnly = net.ReadBool()

        -- if the search ID doesn't match the ID cached on the player, this search is not
        -- valid and should be discarded
        if ply.searchID ~= searchUID then
            ply.searchID = nil

            return
        end

        -- the search ID should always be set back to nil after a body was confirmed
        -- meaning that the search procedure was ended and the UID is no longer needed
        ply.searchID = nil

        if creditsOnly then
            bodysearch.GiveFoundCredits(ply, rag, false, searchUID)

            return
        end

        if
            IsValid(rag)
            and (rag:GetPos():Distance(ply:GetPos()) < 128 or isLongRange)
            and not CORPSE.GetFound(rag, false)
        then
            CORPSE.IdentifyBody(ply, rag, searchUID)

            bodysearch.GiveFoundCredits(ply, rag, false, searchUID)
        end
    end)

    net.Receive("ttt2_client_reports_corpse", function(_, ply)
        if not IsValid(ply) or not ply:IsActive() then
            return
        end

        local rag = net.ReadEntity()

        if not IsValid(rag) or rag:GetPos():Distance(ply:GetPos()) > 128 then
            return
        end

        -- in mode 0 the body has to be confirmed to call a detective
        if cvInspectConfirmMode:GetInt() == 0 and not CORPSE.GetFound(rag, false) then
            return
        end

        local plyTable = util.GetFilteredPlayers(function(p)
            local roleData = p:GetSubRoleData()

            return roleData.isPolicingRole and roleData.isPublicRole and p:IsTerror()
        end)

        ---
        -- @realm server
        hook.Run("TTT2ModifyCorpseCallRadarRecipients", plyTable, rag, ply)

        -- show indicator in radar to detectives
        net.Start("TTT_CorpseCall")
        net.WriteVector(rag:GetPos())
        net.Send(plyTable)

        LANG.MsgAll(
            "body_call",
            { player = ply:Nick(), victim = CORPSE.GetPlayerNick(rag, "someone") },
            MSG_MSTACK_PLAIN
        )

        ---
        -- @realm server
        hook.Run("TTT2CalledPolicingRole", plyTable, ply, rag, CORPSE.GetPlayer(rag))
    end)

    ---
    -- Gives the credits from a ragdoll to a player that is searching the ragdoll. It checks
    -- whether the player is able to take those credits or not.
    -- @param Player ply The player that should receive those credits
    -- @param Entity rag The ragdoll entity that is searched
    -- @param[default=false] boolean isLongRange Whether the search is long or short range
    -- @param[default=0] number searchUID The UID from this body search, can be ignored if not called from within UI
    -- @realm server
    function bodysearch.GiveFoundCredits(ply, rag, isLongRange, searchUID)
        if bodysearch.CanTakeCredits(ply, rag, isLongRange) == false then
            return
        end

        ---
        -- @realm shared
        if hook.Run("TTT2GiveFoundCredits", ply, rag) == false then
            return false
        end

        local corpseNick = CORPSE.GetPlayerNick(rag)
        local credits = CORPSE.GetCredits(rag, 0)

        LANG.Msg(ply, "body_credits", { num = credits })

        ply:AddCredits(credits)

        CORPSE.SetCredits(rag, 0)

        ServerLog(
            ply:Nick() .. " took " .. credits .. " credits from the body of " .. corpseNick .. "\n"
        )

        events.Trigger(EVENT_CREDITFOUND, ply, rag, credits)

        ---
        -- @realm server
        hook.Run("TTT2OnGiveFoundCredits", ply, rag, credits)

        -- update clients so their UIs can be updated
        net.Start("ttt2_credits_were_taken")
        net.WriteUInt(searchUID or 0, 16)
        net.Broadcast()
    end

    ---
    -- Assimilates the scene data from the player death. Uses multiple sources of data collected in different
    -- hooks and puts them all inside the sceneData table that is returned. The table has a few entries that are
    -- always present if scene data is collected. Some more in-depth information might depend on the role of
    -- the player that is currently searching the body.
    -- @param Player inspector The player that searches the corpse
    -- @param Entity rag The ragdoll entity that is searched
    -- @param[default=false] boolean isCovert Whether the body search is covert or announced
    -- @param[default=false] boolean isLongRange Whether the search is long or short range
    -- @return table The scene data table
    -- @realm server
    function bodysearch.AssimilateSceneData(inspector, rag, isCovert, isLongRange)
        local sceneData = {}
        local inspectorRoleData = inspector:GetSubRoleData()
        local isPublicPolicingSearch = inspectorRoleData.isPolicingRole
            and inspectorRoleData.isPublicRole

        -- data that is available to everyone and is not overwritten on data update on the client
        sceneData.base = {}
        sceneData.base.inspector = inspector
        sceneData.base.isPublicPolicingSearch = isPublicPolicingSearch
            and inspector:IsActive()
            and not isCovert

        sceneData.playerModel = rag.scene.plyModel or ""
        sceneData.ragOwner = player.GetBySteamID64(rag.sid64)
        sceneData.credits = CORPSE.GetCredits(rag, 0)
        sceneData.searchUID = mathFloor(rag:EntIndex() + (rag.time or 0))

        sceneData.isCovert = isCovert
        sceneData.isLongRange = isLongRange

        -- if a non-public or non-policing role tries to search a body in mode 2, nothing happens
        if
            cvInspectConfirmMode:GetInt() == 2
            and not isPublicPolicingSearch
            and not inspector:IsSpec()
        then
            return sceneData
        end

        sceneData.nick = CORPSE.GetPlayerNick(rag)
        sceneData.subrole = rag.was_role
        sceneData.roleColor = rag.role_color
        sceneData.team = rag.was_team

        if not sceneData.nick or not sceneData.subrole or not sceneData.team then
            return
        end

        sceneData.rag = rag
        sceneData.eq = rag.equipment or {}
        sceneData.c4CutWire = rag.bomb_wire or -1
        sceneData.dmgType = rag.dmgtype or DMG_GENERIC
        sceneData.wep = rag.dmgwep or ""
        sceneData.lastWords = rag.last_words
        sceneData.wasHeadshot = rag.was_headshot or false
        sceneData.deathTime = rag.time or 0
        sceneData.sid64 = CORPSE.GetPlayerSID64(rag)
        sceneData.lastDamage = mathRound(mathMax(0, rag.scene.lastDamage or 0))
        sceneData.killFloorSurface = rag.scene.floorSurface or 0
        sceneData.killWaterLevel = rag.scene.waterLevel or 0

        -- only add last seen id if searched by public policing role
        if isPublicPolicingSearch then
            sceneData.lastSeenEnt = rag.lastid and rag.lastid.ent or nil
        end

        sceneData.killDistance = CORPSE_KILL_NO_DATA
        if rag.scene.hit_trace and isvector(rag.scene.hit_trace.StartPos) then
            local rawKillDistance =
                rag.scene.hit_trace.StartPos:Distance(rag.scene.hit_trace.HitPos)
            if rawKillDistance < 200 then
                sceneData.killDistance = CORPSE_KILL_DISTANCE_POINT_BLANK
            elseif rawKillDistance < 700 then
                sceneData.killDistance = CORPSE_KILL_DISTANCE_CLOSE
            else
                sceneData.killDistance = CORPSE_KILL_DISTANCE_FAR
            end
        end

        sceneData.killHitGroup = HITGROUP_GENERIC
        if rag.scene.hit_group and rag.scene.hit_group > 0 then
            sceneData.killHitGroup = rag.scene.hit_group
        end

        sceneData.killOrientation = CORPSE_KILL_NO_DATA
        if
            rag.scene.hit_trace
            and isangle(rag.scene.hit_trace.StartAng)
            and rag.scene.damageInfoData.isBulletDamage
        then
            local rawKillAngle = math.abs(
                math.AngleDifference(rag.scene.hit_trace.StartAng.yaw, rag.scene.victim.aim_yaw)
            )

            if rawKillAngle < 45 then
                sceneData.killOrientation = CORPSE_KILL_DIRECTION_BACK
            elseif rawKillAngle < 135 then
                sceneData.killOrientation = CORPSE_KILL_DIRECTION_SIDE
            else
                sceneData.killOrientation = CORPSE_KILL_DIRECTION_FRONT
            end
        end

        sceneData.sampleDecayTime = 0
        if rag.killer_sample then
            sceneData.sampleDecayTime = rag.killer_sample.t
        end

        -- build list of people this player killed, but only if convar is enabled
        sceneData.killEntityIDList = {}
        if cv_ttt2_confirm_killlist:GetBool() then
            local ragKills = rag.kills or {}

            for i = 1, #ragKills do
                local victimSIDs = ragKills[i]

                -- also send disconnected players as a marker
                local vic = player.GetBySteamID64(victimSIDs)

                sceneData.killEntityIDList[#sceneData.killEntityIDList + 1] = IsValid(vic)
                        and vic:EntIndex()
                    or -1
            end
        end

        return sceneData
    end

    ---
    -- Streams the provided scene data to the given clients, is broadcasted if no client is defined.
    -- @param SceneData sceneData The scene data table that should be streamed to the client(s)
    -- @param[opt] table|player client Optional, use it to send a stream to a single client or a group of clients
    -- @realm server
    function bodysearch.StreamSceneData(sceneData, client)
        net.SendStream("TTT2_BodySearchData", sceneData, client)
    end

    ---
    -- Called after a player has been given credits for searching a corpse.
    -- @param Player ply The player that searched the corpse
    -- @param Entity rag The ragdoll that was searched
    -- @param number credits The amount of credits that were given
    -- @hook
    -- @realm server
    function GM:TTT2OnGiveFoundCredits(ply, rag, credits) end
end

if CLIENT then
    -- cache functions
    local utilSimpleTime = util.SimpleTime
    local CurTime = CurTime
    local utilBitSet = util.BitSet
    local mathMax = math.max
    local table = table
    local IsValid = IsValid
    local pairs = pairs

    net.ReceiveStream("TTT2_BodySearchData", function(searchStreamData)
        local eq = {} -- placeholder for the hook, not used right now
        ---
        -- @realm shared
        hook.Run("TTTBodySearchEquipment", searchStreamData, eq)

        searchStreamData.show = LocalPlayer() == searchStreamData.base.inspector
        -- add this hack here to keep compatibility to the old scoreboard
        searchStreamData.show_sb = searchStreamData.show
            or searchStreamData.base.isPublicPolicingSearch

        -- cache search result in rag.bodySearchResult, e.g. useful for scoreboard
        bodysearch.StoreSearchResult(searchStreamData)

        if searchStreamData.show then
            -- if there is more elaborate data already available
            -- confirming this body, then this should be used instead
            if bodysearch.PlayerHasDetailedSearchResult(searchStreamData.ragOwner) then
                SEARCHSCREEN:Show(bodysearch.GetSearchResult(searchStreamData.ragOwner))
            else
                SEARCHSCREEN:Show(searchStreamData)
            end
        end
    end)

    local damageToText = {
        ["crush"] = DMG_CRUSH,
        ["bullet"] = DMG_BULLET,
        ["fall"] = DMG_FALL,
        ["boom"] = DMG_BLAST,
        ["club"] = DMG_CLUB,
        ["drown"] = DMG_DROWN,
        ["stab"] = DMG_SLASH,
        ["burn"] = DMG_BURN,
        ["teleport"] = DMG_SONIC,
        ["car"] = DMG_VEHICLE,
    }

    local damageFromType = {
        ["bullet"] = DMG_BULLET,
        ["rock"] = DMG_CRUSH,
        ["splode"] = DMG_BLAST,
        ["fall"] = DMG_FALL,
        ["fire"] = DMG_BURN,
        ["drown"] = DMG_DROWN,
    }

    local distanceToText = {
        [CORPSE_KILL_DISTANCE_POINT_BLANK] = "search_kill_distance_point_blank",
        [CORPSE_KILL_DISTANCE_CLOSE] = "search_kill_distance_close",
        [CORPSE_KILL_DISTANCE_FAR] = "search_kill_distance_far",
    }

    local orientationToText = {
        [CORPSE_KILL_DIRECTION_FRONT] = "search_kill_from_front",
        [CORPSE_KILL_DIRECTION_BACK] = "search_kill_from_back",
        [CORPSE_KILL_DIRECTION_SIDE] = "search_kill_from_side",
    }

    local floorIDToText = {
        [MAT_ANTLION] = "search_floor_antlionss",
        [MAT_BLOODYFLESH] = "search_floor_bloodyflesh",
        [MAT_CONCRETE] = "search_floor_concrete",
        [MAT_DIRT] = "search_floor_dirt",
        [MAT_EGGSHELL] = "search_floor_eggshell",
        [MAT_FLESH] = "search_floor_flesh",
        [MAT_GRATE] = "search_floor_grate",
        [MAT_ALIENFLESH] = "search_floor_alienflesh",
        [MAT_SNOW] = "search_floor_snow",
        [MAT_PLASTIC] = "search_floor_plastic",
        [MAT_METAL] = "search_floor_metal",
        [MAT_SAND] = "search_floor_sand",
        [MAT_FOLIAGE] = "search_floor_foliage",
        [MAT_COMPUTER] = "search_floor_computer",
        [MAT_SLOSH] = "search_floor_slosh",
        [MAT_TILE] = "search_floor_tile",
        [MAT_GRASS] = "search_floor_grass",
        [MAT_VENT] = "search_floor_vent",
        [MAT_WOOD] = "search_floor_wood",
        [MAT_DEFAULT] = "search_floor_default",
        [MAT_GLASS] = "search_floor_glass",
        [MAT_WARPSHIELD] = "search_floor_warpshield",
    }

    local hitgroup_to_text = {
        [HITGROUP_HEAD] = "search_hitgroup_head",
        [HITGROUP_CHEST] = "search_hitgroup_chest",
        [HITGROUP_STOMACH] = "search_hitgroup_stomach",
        [HITGROUP_RIGHTARM] = "search_hitgroup_rightarm",
        [HITGROUP_LEFTARM] = "search_hitgroup_leftarm",
        [HITGROUP_RIGHTLEG] = "search_hitgroup_rightleg",
        [HITGROUP_LEFTLEG] = "search_hitgroup_leftleg",
        [HITGROUP_GEAR] = "search_hitgroup_gear",
    }

    local function DamageToText(dmg)
        for key, value in pairs(damageToText) do
            if utilBitSet(dmg, value) then
                return key
            end
        end

        if utilBitSet(dmg, DMG_DIRECT) then
            return "burn"
        end

        return "other"
    end

    local DataToText = {
        last_words = function(data)
            if not data.lastWords or data.lastWords == "" then
                return
            end

            -- only append "--" if there's no ending interpunction
            local final = string.match(data.lastWords, "[\\.\\!\\?]$") ~= nil

            return {
                title = {
                    body = "search_title_words",
                    params = nil,
                },
                text = {
                    {
                        body = "search_words",
                        params = { lastwords = data.lastWords .. (final and "" or "--.") },
                    },
                },
            }
        end,
        c4_disarm = function(data)
            if not data.c4CutWire or data.c4CutWire <= 0 then
                return
            end

            return {
                title = {
                    body = "search_title_c4",
                    params = nil,
                },
                text = {
                    {
                        body = "search_c4",
                        params = { num = data.c4CutWire },
                    },
                },
            }
        end,
        dmg = function(data)
            if not data.dmgType then
                return
            end

            local rawText = {
                title = {
                    body = "search_title_dmg_" .. DamageToText(data.dmgType),
                    params = { amount = data.lastDamage },
                },
                text = {
                    {
                        body = "search_dmg_" .. DamageToText(data.dmgType),
                        params = nil,
                    },
                },
            }

            if data.killOrientation ~= CORPSE_KILL_NO_DATA then
                rawText.text[#rawText.text + 1] = {
                    body = orientationToText[data.killOrientation],
                    params = nil,
                }
            end

            if data.wasHeadshot then
                rawText.text[#rawText.text + 1] = {
                    body = "search_head",
                    params = nil,
                }
            end

            return rawText
        end,
        wep = function(data)
            if not data.wep then
                return
            end

            local wep = util.WeaponForClass(data.wep)

            local wname = wep and wep.PrintName

            if not wname then
                return
            end

            local rawText = {
                title = {
                    body = wname,
                    params = nil,
                },
                text = {
                    {
                        body = "search_weapon",
                        params = { weapon = wname },
                    },
                },
            }

            if data.dist ~= CORPSE_KILL_NO_DATA then
                rawText.text[#rawText.text + 1] = {
                    body = distanceToText[data.killDistance],
                    params = nil,
                }
            end

            if data.killHitGroup > 0 then
                rawText.text[#rawText.text + 1] = {
                    body = hitgroup_to_text[data.killHitGroup],
                    params = nil,
                }
            end

            return rawText
        end,
        death_time = function(data)
            if not data.deathTime then
                return
            end

            return {
                title = {
                    body = "search_title_time",
                    params = nil,
                },
                text = {
                    {
                        body = "search_time",
                        params = nil,
                    },
                },
            }
        end,
        dna_time = function(data)
            if not data.sampleDecayTime or data.sampleDecayTime - CurTime() <= 0 then
                return
            end

            return {
                title = {
                    body = "search_title_dna",
                    params = nil,
                },
                text = {
                    {
                        body = "search_dna",
                        params = nil,
                    },
                },
            }
        end,
        kill_list = function(data)
            if not data.killEntityIDList then
                return
            end

            local num = table.Count(data.killEntityIDList)

            if num == 1 then
                local vic = Entity(data.killEntityIDList[1])
                local disconnected = data.killEntityIDList[1] == -1

                if disconnected or IsValid(vic) and vic:IsPlayer() then
                    return {
                        title = {
                            body = "search_title_kills",
                            params = nil,
                        },
                        text = {
                            {
                                body = "search_kills1",
                                params = {
                                    player = disconnected and "<Disconnected>" or vic:Nick(),
                                },
                            },
                        },
                    }
                end
            elseif num > 1 then
                local nicks = {}

                for k, idx in pairs(data.killEntityIDList) do
                    local vic = Entity(idx)
                    local disconnected = idx == -1

                    if disconnected or IsValid(vic) and vic:IsPlayer() then
                        nicks[#nicks + 1] = disconnected and "<Disconnected>" or vic:Nick()
                    end
                end

                return {
                    title = {
                        body = "search_title_kills",
                        params = nil,
                    },
                    text = {
                        {
                            body = "search_kills2",
                            params = { player = table.concat(nicks, ", ", 1) },
                        },
                    },
                }
            end
        end,
        last_id = function(data)
            if not IsValid(data.lastSeenEnt) or not data.lastSeenEnt:IsPlayer() then
                return
            end

            return {
                title = {
                    body = "search_title_eyes",
                    params = nil,
                },
                text = {
                    {
                        body = "search_eyes",
                        params = { player = data.lastSeenEnt:Nick() },
                    },
                },
            }
        end,
        floor_surface = function(data)
            if not data.killFloorSurface or not floorIDToText[data.killFloorSurface] then
                return
            end

            return {
                title = {
                    body = "search_title_floor",
                    params = nil,
                },
                text = {
                    {
                        body = floorIDToText[data.killFloorSurface],
                        params = nil,
                    },
                },
            }
        end,
        credits = function(data)
            if not data.credits or data.credits == 0 then
                return
            end

            -- special case: mode 2, only shopping roles can see credits
            local client = LocalPlayer()
            if
                (cvInspectConfirmMode:GetInt() == 2 or not cvCreditsVisibleToAll:GetBool())
                and not bodysearch.CanTakeCredits(client, data.rag)
            then
                return
            end

            return {
                title = {
                    body = "search_title_credits",
                    params = { credits = data.credits },
                },
                text = {
                    {
                        body = "search_credits",
                        params = { credits = data.credits },
                    },
                },
            }
        end,
        water_level = function(data)
            if not data.killWaterLevel or data.killWaterLevel == 0 then
                return
            end

            return {
                title = {
                    body = "search_title_water",
                    params = { level = data.killWaterLevel },
                },
                text = {
                    {
                        body = "search_water_" .. data.killWaterLevel,
                        params = nil,
                    },
                },
            }
        end,
    }

    local materialDamage = {
        ["bullet"] = Material("vgui/ttt/icon_bullet"),
        ["rock"] = Material("vgui/ttt/icon_rock"),
        ["splode"] = Material("vgui/ttt/icon_splode"),
        ["fall"] = Material("vgui/ttt/icon_fall"),
        ["fire"] = Material("vgui/ttt/icon_fire"),
        ["drown"] = Material("vgui/ttt/icon_drown"),
        ["generic"] = Material("vgui/ttt/icon_skull"),
    }

    local materialWaterLevel = {
        [1] = Material("vgui/ttt/icon_water_1"),
        [2] = Material("vgui/ttt/icon_water_2"),
        [3] = Material("vgui/ttt/icon_water_3"),
    }

    local materialHeadShot = Material("vgui/ttt/icon_head")
    local materialDeathTime = Material("vgui/ttt/icon_time")
    local materialCredits = Material("vgui/ttt/icon_credits")
    local materialDNA = Material("vgui/ttt/icon_wtester")
    local materialFloor = Material("vgui/ttt/icon_floor")
    local materialC4Disarm = Material("vgui/ttt/icon_code")
    local materialLastID = Material("vgui/ttt/icon_lastid")
    local materialKillList = Material("vgui/ttt/icon_list")
    local materialLastWords = Material("vgui/ttt/icon_halp")

    local function DamageToIconMaterial(data)
        -- handle headshots first
        if data.wasHeadshot then
            return materialHeadShot
        end

        -- the damage type
        local dmg = data.dmgType

        -- handle most generic damage types
        for key, value in pairs(damageFromType) do
            if utilBitSet(dmg, value) then
                return materialDamage[key]
            end
        end

        -- special case handling with a fallback for generic damage
        if utilBitSet(dmg, DMG_DIRECT) then
            return materialDamage["fire"]
        else
            return materialDamage["generic"]
        end
    end

    local function TypeToMaterial(type, data)
        if type == "wep" then
            local wep = util.WeaponForClass(data.wep)

            -- in most cases the inflictor is a weapon and the weapon has a cached
            -- material that can be used
            if wep.iconMaterial then
                return wep.iconMaterial

            -- sometimes the projectile is a custom entity that kills the player
            -- which means it is not a weapon with a cached material
            else
                local mat = Material(wep.Icon)

                if not mat:IsError() then
                    return mat
                end

                -- as a fallback use this missing texture icon
                return materialWeaponFallback
            end
        elseif type == "dmg" then
            return DamageToIconMaterial(data)
        elseif type == "death_time" then
            return materialDeathTime
        elseif type == "credits" then
            return materialCredits
        elseif type == "dna_time" then
            return materialDNA
        elseif type == "floor_surface" then
            return materialFloor
        elseif type == "water_level" then
            return materialWaterLevel[data.killWaterLevel]
        elseif type == "c4_disarm" then
            return materialC4Disarm
        elseif type == "last_id" then
            return materialLastID
        elseif type == "kill_list" then
            return materialKillList
        elseif type == "last_words" then
            return materialLastWords
        end
    end

    local function TypeToIconText(type, data)
        if type == "death_time" then
            return function()
                return utilSimpleTime(CurTime() - data.deathTime, "%02i:%02i")
            end
        elseif type == "dna_time" then
            return function()
                return utilSimpleTime(mathMax(0, data.sampleDecayTime - CurTime()), "%02i:%02i")
            end
        end
    end

    local function TypeToColor(type, data)
        if type == "dna_time" then
            return roles.DETECTIVE.color
        elseif type == "credits" then
            return COLOR_GOLD
        end
    end

    bodysearch.searchResultOrder = {
        "wep",
        "dmg",
        "death_time",
        "credits",
        "dna_time",
        "floor_surface",
        "water_level",
        "c4_disarm",
        "last_id",
        "kill_list",
        "last_words",
    }

    ---
    -- Generate the search box data from the provided data for a given type.
    -- @note This function is used to populate the UI of the bodysearch menu. You probably don't want to use this.
    -- @param string type The element type identifier
    -- @param SceneData sceneData The scene data that is provided to get the box contents
    -- @return nil|table Returns `nil` if no data for the given type is available, table with box content if available
    -- @realm client
    function bodysearch.GetContentFromData(type, sceneData)
        -- make sure type is valid
        if not isfunction(DataToText[type]) then
            return
        end

        local text = DataToText[type](sceneData)

        -- DataToText checks if criteria for display is met, no box should be
        -- shown if criteria is not met.
        if not text then
            return
        end

        return {
            iconMaterial = TypeToMaterial(type, sceneData),
            iconText = TypeToIconText(type, sceneData),
            colorBox = TypeToColor(type, sceneData),
            text = text,
        }
    end

    ---
    -- Creates a table with icons, text,... out of raw table for the scoreboard
    -- @param table raw The raw data
    -- @return table A converted search data table
    -- @deprecated This function only functions as a fallback for the old scoreboard. Do not use this!
    -- @note This function is old and should be redone on a scoreboard rework
    -- @realm client
    function bodysearch.PreprocSearch(raw)
        local search = {}

        local index = 1

        for i = 1, #bodysearch.searchResultOrder do
            local type = bodysearch.searchResultOrder[i]
            local searchData = bodysearch.GetContentFromData(type, raw)

            if not searchData then
                continue
            end

            -- a workaround to build the text for the scoreboard
            local text = searchData.text.text

            -- only use the first text entry here
            local transText = LANG.GetDynamicTranslation(text[1].body, text[1].params, true)

            if searchData.iconMaterial then
                -- note: GetName only returns the material name. This fails if the addon uses a
                -- png for its material, we therefore have to check if the material exists on disk
                local materialFile = searchData.iconMaterial:GetName()

                if file.Exists("materials/" .. materialFile .. ".png", "GAME") then
                    materialFile = materialFile .. ".png"
                elseif file.Exists("materials/" .. materialFile .. ".jpg", "GAME") then
                    materialFile = materialFile .. ".jpg"
                elseif file.Exists("materials/" .. materialFile .. ".jpeg", "GAME") then
                    materialFile = materialFile .. ".jpeg"
                end

                search[type] = {
                    img = materialFile,
                    text = transText,
                    p = index, -- sorting number
                }

                index = index + 1
            end

            -- special cases with icon text
            local iconTextFn = TypeToIconText(type, raw)
            if isfunction(iconTextFn) then
                search[type].text_icon = iconTextFn()
            end
        end

        ---
        -- @realm client
        hook.Run("TTTBodySearchPopulate", search, raw)

        return search
    end

    ---
    -- This function handles the storing of the streamed search result data.
    -- New data will append/overwrite existing data, but not remove it.
    -- This functions considers the roles and the settings of the local player and the player that
    -- inspected the body.
    -- @param SceneData newData The table of scene data that should be stored
    -- @note The data is stored as `bodySearchResult` on the ragdoll and the owner of the ragdoll
    -- @realm client
    function bodysearch.StoreSearchResult(newData)
        if not newData.ragOwner then
            return
        end

        local ply = newData.ragOwner
        local rag = newData.rag

        -- do not store if searching player (client) is spectator
        if LocalPlayer():IsSpec() then
            return
        end

        -- retrieve existing data
        local oldData = ply.bodySearchResult or {}

        -- keep the original finder info if previously searched by public policing role
        -- if the currently stored search result is by a public policing role, it should be kept
        -- it can be overwritten by another public policing role though
        -- data can still be updated, but the previous base is kept
        local previousOldDataBase
        if oldData.base and oldData.base.isPublicPolicingSearch then
            previousOldDataBase = table.Copy(oldData.base)
        end

        -- merge new data into old data
        -- this is useful if a player had good data on a body from another source
        -- and now gets updated info on it as it now only replaces the newly added
        -- entries
        table.Merge(oldData, newData)

        oldData.base = previousOldDataBase or oldData.base

        ply.bodySearchResult = oldData

        -- also store data in the ragdoll for targetID
        if not IsValid(rag) then
            return
        end

        rag.bodySearchResult = oldData
    end

    ---
    -- Checks if the local player has a detailed search result of a given player.
    -- @param Player ply Then player whose search result should be checked
    -- @return boolean Returns if the local player has a detailed search result
    -- @realm client
    function bodysearch.PlayerHasDetailedSearchResult(ply)
        return IsValid(ply)
            and ply.bodySearchResult
            and ply.bodySearchResult.base
            and ply.bodySearchResult.base.isPublicPolicingSearch
    end

    ---
    -- Returns the reference to the search result of a given player
    -- @param Player ply Then player whose search result should be returned
    -- @return table The search result that is available for this player
    -- @realm client
    function bodysearch.GetSearchResult(ply)
        -- initialize the table if not set so that a valid reference can be returned
        ply.bodySearchResult = ply.bodySearchResult or {}

        return ply.bodySearchResult
    end

    ---
    -- Resets the body search result of a given player.
    -- @param Player ply Then player whose search result should be reset
    -- @realm client
    function bodysearch.ResetSearchResult(ply)
        if not IsValid(ply) then
            return
        end

        ply.bodySearchResult = nil
    end

    ---
    -- Used to trigger the confirmation of a corpse. This might announce that a body was found to the
    -- whole server, depending on the server settings. The server ignores this request if the player
    -- is not allowed to confirm the corpse. The searching player receives credits if they are able to.
    -- @param Entity rag The ragdoll entity whose owner should be confirmed
    -- @param[default=0] number searchUID The UID of the search, used for keeping track of searches in the UI
    -- @param[default=false] boolean isLongRange Whether the search is a long range search
    -- @param[default=false] boolean playerCanTakeCredits Whether or not the player could be able to take credits
    -- @realm client
    function bodysearch.ClientConfirmsCorpse(rag, searchUID, isLongRange, playerCanTakeCredits)
        local clientRoleData = LocalPlayer():GetSubRoleData()
        local creditsOnly = playerCanTakeCredits
            and cvInspectConfirmMode:GetInt() > 0
            and not (clientRoleData.isPolicingRole and clientRoleData.isPublicRole)

        net.Start("ttt2_client_confirm_corpse")
        net.WriteEntity(rag)
        net.WriteUInt(searchUID or 0, 16)
        net.WriteBool(isLongRange or false)
        net.WriteBool(creditsOnly or false)
        net.SendToServer()
    end

    ---
    -- Reports the body as dead. Functions as call for public poling roles so that they know where the corpse
    -- can be found. The server ignores this request if the player is not allowed to report the corpse.
    -- @param Entity rag The ragdoll entity which should be reported
    -- @note: Reporting is what previously was called "call detective"
    -- @realm client
    function bodysearch.ClientReportsCorpse(rag)
        net.Start("ttt2_client_reports_corpse")
        net.WriteEntity(rag)
        net.SendToServer()
    end

    ---
    -- Helper function that checks if the body of a given player was confirmed.
    -- @param Player ragOwner The dead player whose body might be confirmed
    -- @return boolean Returns if their corpse was confirmed
    -- @realm client
    function bodysearch.IsConfirmed(ragOwner)
        return IsValid(ragOwner) and ragOwner:TTT2NETGetBool("body_found", false)
    end

    ---
    -- Checks if the local player can confirm the body. Depends on the local player and the
    -- current body search mode.
    -- @return boolean Returns if the local player can confirm the body
    -- @realm client
    function bodysearch.CanConfirmBody()
        local client = LocalPlayer()

        if client:IsSpec() then
            return false
        end

        -- in mode 0 everyone can confirm corpses
        if cvInspectConfirmMode:GetInt() == 0 then
            return true
        end

        local roleData = client:GetSubRoleData()

        -- in mode 1 and 2 only public policing roles can confirm corpses
        if roleData.isPolicingRole and roleData.isPublicRole then
            return true
        end

        return false
    end

    ---
    -- Checks if the local player can report the body. Depends on the local player, the dead
    -- player and the current body search mode.
    -- @param Player ragOwner The dead player whose body might be reported
    -- @return boolean Returns if the local player can report the body
    -- @note: Reporting is what previously was called "call detective"
    -- @realm client
    function bodysearch.CanReportBody(ragOwner)
        local client = LocalPlayer()

        if client:IsSpec() then
            return false
        end

        -- in mode 0 the ragdoll has to be found to report body
        if cvInspectConfirmMode:GetInt() == 0 and not bodysearch.IsConfirmed(ragOwner) then
            return false
        end

        return true
    end

    -- HOOKS --

    ---
    -- This hook can be used to populate the body search panel.
    -- @param table search The search data table
    -- @param table raw The raw search data
    -- @hook
    -- @realm client
    function GM:TTTBodySearchPopulate(search, raw) end

    ---
    -- This hook can be used to modify the equipment info of a corpse.
    -- @param table search The search data table
    -- @param table equip The raw equipment table
    -- @hook
    -- @realm client
    function GM:TTTBodySearchEquipment(search, equip) end

    ---
    -- This hook is called right before the killer found @{MSTACK} notification
    -- is added.
    -- @param string finder The nickname of the finder
    -- @param string victim The nickname of the victim
    -- @hook
    -- @realm client
    function GM:TTT2ConfirmedBody(finder, victim) end
end

---
-- Use this hook to prevent the transfer of credits from a body to a player. Is also used
-- on the client to check if the player is able to take the credits and update the UI.
-- @param Entity rag The ragdoll that is inspected
-- @param Player ply The player attempting to find credits from ragdoll
-- @return nil|boolean Return false to prevent transfer
-- @hook
-- @realm shared
function GM:TTT2CheckFindCredits(ply, rag) end
