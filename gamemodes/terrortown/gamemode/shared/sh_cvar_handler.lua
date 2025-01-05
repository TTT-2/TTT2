---
-- All replicated convars are handled in this file

-- @realm shared
CreateConVar("ttt2_radar_charge_time", "30", { FCVAR_NOTIFY, FCVAR_ARCHIVE, FCVAR_REPLICATED })

-- @realm shared
CreateConVar("ttt_spec_prop_control", "1", { FCVAR_NOTIFY, FCVAR_ARCHIVE, FCVAR_REPLICATED })

---
-- @realm shared
CreateConVar(
    "ttt_bem_allow_change",
    1,
    { FCVAR_ARCHIVE, FCVAR_REPLICATED },
    "Allow clients to change the look of the Traitor/Detective menu"
)

---
-- @realm shared
CreateConVar(
    "ttt_bem_sv_cols",
    4,
    { FCVAR_ARCHIVE, FCVAR_REPLICATED },
    "Sets the number of columns in the Traitor/Detective menu's item list (serverside)"
)

---
-- @realm shared
CreateConVar(
    "ttt_bem_sv_rows",
    5,
    { FCVAR_ARCHIVE, FCVAR_REPLICATED },
    "Sets the number of rows in the Traitor/Detective menu's item list (serverside)"
)

---
-- @realm shared
CreateConVar(
    "ttt_bem_sv_size",
    64,
    { FCVAR_ARCHIVE, FCVAR_REPLICATED },
    "Sets the item size in the Traitor/Detective menu's item list (serverside)"
)
