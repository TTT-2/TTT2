---
-- logic to control player customization on the server side
-- @realm server

customization = customization or {}

customization.cv = {

    enforcePlayermodel = CreateConVar(
        "ttt_enforce_playermodel",
        "1",
        { FCVAR_NOTIFY, FCVAR_ARCHIVE }
    ),

    useMapPlayermodel = CreateConVar(
        "ttt2_prefer_map_models",
        "1",
        { FCVAR_NOTIFY, FCVAR_ARCHIVE }
    ),

    -- use_custom_models?

    allowPlayerCustom = CreateConVar(
        "ttt2_allow_player_customization",
        "0",
        { FCVAR_NOTIFY, FCVAR_ARCHIVE }
    ),
}
