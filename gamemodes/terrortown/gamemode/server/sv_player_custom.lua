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
}
