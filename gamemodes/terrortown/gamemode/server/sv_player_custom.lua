---
-- logic to control player customization on the server side
-- @realm server

customization = customization or {}

customization.cv = {

    playermodels = {
        ---
        --
        -- @realm server
        enforce = CreateConVar(
            "ttt_enforce_playermodel",
            "1",
            { FCVAR_NOTIFY, FCVAR_ARCHIVE },
            "Whether or not to enforce terrorist playermodels. Set to 0 for compatibility with Enhanced Playermodel Selector"
        ),

        ---
        --
        -- @realm server
        useMap = CreateConVar(
            "ttt2_prefer_map_models",
            "1",
            { FCVAR_NOTIFY, FCVAR_ARCHIVE },
            "Whether to use a map's preferred model when available"
        ),

        ---
        --
        -- @realm server
        customModels = CreateConVar(
            "ttt2_use_custom_models",
            "0",
            { FCVAR_NOTIFY, FCVAR_ARCHIVE },
            "Whether to use custom playermodels instead of just the default"
        ),

        ---
        --
        -- @realm server
        perRound = CreateConVar(
            "ttt2_select_model_per_round",
            "1",
            { FCVAR_NOTIFY, FCVAR_ARCHIVE },
            "Whether to select a player's model each round or once per map"
        ),

        ---
        --
        -- @realm server
        uniquePerPlayer = CreateConVar(
            "ttt2_select_unique_model_per_player",
            "1",
            { FCVAR_NOTIFY, FCVAR_ARCHIVE },
            "Whether playermodels should be unique among players"
        ),
    },

    colors = {
        ---
        --
        -- @realm server
        mode = CreateConVar(
            "ttt_playercolor_mode",
            "1",
            { FCVAR_NOTIFY, FCVAR_ARCHIVE },
            "Controls the player color selection mode."
        ),
    },
}

local ttt_playercolors = {
    all = {
        COLOR_WHITE,
        COLOR_BLACK,
        COLOR_GREEN,
        COLOR_DGREEN,
        COLOR_RED,
        COLOR_YELLOW,
        COLOR_LGRAY,
        COLOR_BLUE,
        COLOR_NAVY,
        COLOR_PINK,
        COLOR_OLIVE,
        COLOR_ORANGE,
    },
    serious = {
        COLOR_WHITE,
        COLOR_BLACK,
        COLOR_NAVY,
        COLOR_LGRAY,
        COLOR_DGREEN,
        COLOR_OLIVE,
    },
}

---
-- @note In TTT (and before the playermodel rework) this is marked "shared" realm, and the
-- associated playercolor_mode cvar  is likewise. The rework moved both to be server-only, since all
-- meaningful interaction with it occurs on the server exclusively.
-- @param string model The selected (default) playermodel
-- @hook
-- @realm server
function GM:TTTPlayerColor(model)
    local mode = customization.cv.colors.mode:GetInt()

    if mode == 1 then
        return ttt_playercolors.serious[math.random(#ttt_playercolors.serious)]
    elseif mode == 2 then
        return ttt_playercolors.all[math.random(#ttt_playercolors.all)]
    elseif mode == 3 then
        return Color(math.random(0, 255), math.random(0, 255), math.random(0, 255))
    end

    -- No coloring
    return COLOR_WHITE
end

local plySelectedModels
local plyUsedModels

local function RandomUniqueModel()
    plyUsedModels = plyUsedModels or {}
    local pm = nil

    -- select a playermodel which hasn't been used before
    local i = #playermodels.GetSelectedModels() -- i means we only attempt at #playermodels times, before figuring there are no remaining options
    while i > 0 and (not pm or plyUsedModels[pm]) do
        pm = playermodels.GetRandomPlayerModel()
        i = i - 1
    end

    if not pm or i == 0 then
        -- we reached the iteration limit; likely all models are used, so start reusing
        plyUsedModels = {}
        return RandomUniqueModel()
    end

    return pm
end

---
-- Called to get the default player display information (model/color) for this map.
-- The returned settings will be overridden when the round starts by
-- @{TTT2GetDefaultPlayerDisplayForRound}.
-- @return string,Color the model,color pair for the default display
-- @hook
-- @realm server
function GM:TTT2GetDefaultPlayerDisplay()
    local pm = playermodels.GetRandomPlayerModel()
    return pm, hook.Run("TTTPlayerColor", pm)
end

function GM:TTT2GetDefaultPlayerDisplayForRound()
    local pm = self.playermodel

    -- clear the per-player selected models table
    plySelectedModels = nil

    if
        customization.cv.playermodels.useMap:GetBool()
        and self.force_plymodel
        and self.force_plymodel ~= ""
    then
        -- server wants map-configured playermodel and the map specified a playermodel,
        -- respect that by default
        pm = self.force_plymodel
    elseif customization.cv.playermodels.perRound:GetBool() then
        -- server wants new playermodels each round, choose a new default
        pm = playermodels.GetRandomPlayerModel()

        if customization.cv.playermodels.uniquePerPlayer:GetBool() then
            -- we want to set a unique playermodel for each player as well
            plySelectedModels = {}
            local plys = player.GetAll()
            for i = 1, #plys do
                if not plys[i]:IsTerror() then
                    continue
                end

                plySelectedModels[plys[i]] = RandomUniqueModel()
            end
        end
    end

    local color = self.playercolor

    if pm ~= self.playermodel then
        -- the playermodel got changed, so we also want to recompute color
        color = hook.Run("TTTPlayerColor", pm)
    end

    return pm, color
end

---
-- Called whenever a @{Player} spawns and must choose a model.
-- A good place to assign a model to a @{Player}.
-- @note This function may not work in your custom gamemode if you have overridden
-- your @{GM:PlayerSpawn} and you do not use self.BaseClass.PlayerSpawn or @{hook.Run}.
-- @param Player ply The @{Player} being chosen
-- @hook
-- @realm server
-- @ref https://wiki.facepunch.com/gmod/GM:PlayerSetModel
-- @local
function GM:PlayerSetModel(ply)
    -- The player modes has to be applied here since some player model selectors overwrite
    -- this hook to suppress the TTT2 player models. If the model is assigned elsewhere, it
    -- breaks with external model selectors.
    if not IsValid(ply) then
        return
    end

    -- We need to clear subrole models at some point; we'll do it here
    ply:SetSubRoleModel(nil)

    local pm = plySelectedModels and plySelectedModels[ply]

    if
        not pm
        and customization.cv.playermodels.perRound:GetBool()
        and customization.cv.playermodels.uniquePerPlayer:GetBool()
    then
        -- plySelectedModels doesn't have this player's model, but a unique one was requested for
        -- each round. Compute it now.
        pm = RandomUniqueModel()
        plySelectedModels = plySelectedModels or {}
        plySelectedModels[ply] = pm
    end

    ply:SetModel(pm)
    -- Always reset the color, which may (will) be later changed by TTTPlayerSetColor
    ply:SetColor(COLOR_WHITE)
end

---
-- Called whenever view model hands needs setting a model.
-- By default this calls @{Player:GetHandsModel} and if that fails,
-- sets the hands model according to his @{Player} model.
-- @param Player ply The @{Player} whose hands needs a model set
-- @param Entity ent The hands to set model of
-- @hook
-- @realm server
-- @ref https://wiki.facepunch.com/gmod/GM:PlayerSetHandsModel
-- @local
function GM:PlayerSetHandsModel(ply, ent)
    local simplemodel = player_manager.TranslateToPlayerModelName(ply:GetModel())
    local info = player_manager.TranslatePlayerHands(simplemodel)

    if info then
        ent:SetModel(info.model)
        ent:SetSkin(info.skin)
        ent:SetBodyGroups(info.body)
    end
end

---
-- Called when a @{Player} spawns and updates the @{Color}
-- @param Player ply
-- @hook
-- @realm server
function GM:TTTPlayerSetColor(ply)
    local c = COLOR_WHITE

    if GAMEMODE.playercolor then
        -- If we have a playercolor, by default we should set it for ALL players.
        c = GAMEMODE.playercolor
    end

    ply:SetPlayerColor(Vector(c.r / 255.0, c.g / 255.0, c.b / 255.0))
end

---
-- @param ply Player the player to update
-- @param doSetModel boolean true if the player's model should be explicitly set
function GM:TTT2UpdateSubrolePlayermodel(ply, doSetModel)
    -- doSetModel is false when the 'oldSubrole' local of the caller is unset. The original coments
    -- there indicated that this meant that the player isn't already spawned, which causes problems.
    -- I am unsure what problems, exactly, though it likely has to do with some part of the work
    -- done in plymeta:SetModel.
    if doSetModel and customization.cv.playermodels.enforce:GetBool() then
        ply:SetModel(ply:GetSubRoleModel())
    end

    -- Always clear color state before invoking TTTPlayerSetColor
    ply:SetColor(COLOR_WHITE)
    hook.Run("TTTPlayerSetColor", ply)
end
