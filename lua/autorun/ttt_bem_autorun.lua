if engine.ActiveGamemode() ~= "terrortown" then return end

-- create serverside ConVars

---
-- @realm shared
CreateConVar("ttt_bem_allow_change", 1, SERVER and {FCVAR_ARCHIVE, FCVAR_REPLICATED} or FCVAR_REPLICATED, "Allow clients to change the look of the Traitor/Detective menu")

---
-- @realm shared
CreateConVar("ttt_bem_sv_cols", 4, SERVER and {FCVAR_ARCHIVE, FCVAR_REPLICATED} or FCVAR_REPLICATED, "Sets the number of columns in the Traitor/Detective menu's item list (serverside)")

---
-- @realm shared
CreateConVar("ttt_bem_sv_rows", 5, SERVER and {FCVAR_ARCHIVE, FCVAR_REPLICATED} or FCVAR_REPLICATED, "Sets the number of rows in the Traitor/Detective menu's item list (serverside)")

---
-- @realm shared
CreateConVar("ttt_bem_sv_size", 64, SERVER and {FCVAR_ARCHIVE, FCVAR_REPLICATED} or FCVAR_REPLICATED, "Sets the item size in the Traitor/Detective menu's item list (serverside)")

-- add Favourites DB functions
AddCSLuaFile("favorites_db.lua")
