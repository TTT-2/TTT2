-- create serverside ConVars
local allowChange = CreateConVar("ttt_bem_allow_change", 1, {FCVAR_ARCHIVE, FCVAR_REPLICATED, FCVAR_SERVER_CAN_EXECUTE}, "Allow clients to change the look of the Traitor/Detective menu")
--local servercols = CreateConVar("ttt_bem_sv_cols", 4, {FCVAR_ARCHIVE, FCVAR_REPLICATED, FCVAR_SERVER_CAN_EXECUTE}, "Sets the number of columns in the Traitor/Detective menu's item list (serverside)")
CreateConVar("ttt_bem_sv_cols", 4, {FCVAR_ARCHIVE, FCVAR_REPLICATED, FCVAR_SERVER_CAN_EXECUTE}, "Sets the number of columns in the Traitor/Detective menu's item list (serverside)")
--local serverrow = CreateConVar("ttt_bem_sv_rows", 5, {FCVAR_ARCHIVE, FCVAR_REPLICATED, FCVAR_SERVER_CAN_EXECUTE}, "Sets the number of rows in the Traitor/Detective menu's item list (serverside)")
CreateConVar("ttt_bem_sv_rows", 5, {FCVAR_ARCHIVE, FCVAR_REPLICATED, FCVAR_SERVER_CAN_EXECUTE}, "Sets the number of rows in the Traitor/Detective menu's item list (serverside)")
--local serversize = CreateConVar("ttt_bem_sv_size", 64, {FCVAR_ARCHIVE, FCVAR_REPLICATED, FCVAR_SERVER_CAN_EXECUTE}, "Sets the item size in the Traitor/Detective menu's item list (serverside)")
CreateConVar("ttt_bem_sv_size", 64, {FCVAR_ARCHIVE, FCVAR_REPLICATED, FCVAR_SERVER_CAN_EXECUTE}, "Sets the item size in the Traitor/Detective menu's item list (serverside)")

-- add Favourites DB functions
AddCSLuaFile("favorites_db.lua")

if CLIENT then
	-- BEM Settings in F1 menu
	local function TTTBemSettings(tbl)
		local bemTbl = {}
		bemTbl.id = "shop"
		bemTbl.getContent = function(slf, parent)
			local dgeneral = vgui.Create("DForm", parent)
			dgeneral:SetName("General")

			dgeneral:CheckBox("Should the shop be opened/closed instead of the score menu during preparing / at the end of a round?", "ttt_bem_always_show_shop")

			dgeneral:Dock(TOP)

			-- layout section
			local dlayout = vgui.Create("DForm", parent)
			dlayout:SetName("Item List Layout")

			if allowChange:GetBool() then
				--dlayout:Help("All changes made here are clientside and will only apply to your own menu.")
				dlayout:NumSlider("Number of columns (def. 4)", "ttt_bem_cols", 1, 20, 0)
				dlayout:NumSlider("Number of rows (def. 5)", "ttt_bem_rows", 1, 20, 0)
				dlayout:NumSlider("Icon size (def. 64)", "ttt_bem_size", 32, 128, 0)
			else
				dlayout:Help("Individual changes to the Traitor/Detective menus layout are not allowed on this server. Please contact a server admin for details.")
			end

			dlayout:Dock(TOP)

			-- marker section
			local dmarker = vgui.Create("DForm", parent)
			dmarker:SetName("Item Marker Settings")

			dmarker:CheckBox("Show slot marker", "ttt_bem_marker_slot")
			dmarker:CheckBox("Show custom item marker", "ttt_bem_marker_custom")
			dmarker:CheckBox("Show favourite item marker", "ttt_bem_marker_fav")

			dmarker:Dock(TOP)
		end

		tbl[#tbl + 1] = bemTbl
	end
	hook.Add("TTT2ModifySettingsList", "BEM_TTTSettingsTab", TTTBemSettings)
end
