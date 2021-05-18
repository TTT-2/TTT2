---
-- All replicated convars are handled in this file

---
-- @realm shared
CreateConVar("ttt2_confirm_detective_only", "0", {FCVAR_NOTIFY, FCVAR_ARCHIVE, FCVAR_REPLICATED})

---
-- @realm shared
CreateConVar("ttt2_inspect_detective_only", "0", {FCVAR_NOTIFY, FCVAR_ARCHIVE, FCVAR_REPLICATED})

---
-- @realm shared
CreateConVar("ttt2_radar_charge_time", "30", {FCVAR_NOTIFY, FCVAR_ARCHIVE, FCVAR_REPLICATED})

---
-- @realm shared
CreateConVar("ttt2_rolecheck_all_evil_roles", "1", {FCVAR_ARCHIVE, FCVAR_NOTIFY, FCVAR_REPLICATED})
