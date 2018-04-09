-- create serverside ConVars
local allowChange = CreateConVar("ttt_bem_allow_change", 1, {FCVAR_ARCHIVE, FCVAR_REPLICATED, FCVAR_SERVER_CAN_EXECUTE}, "Allow clients to change the look of the Traitor/Detective menu")
local servercols = CreateConVar("ttt_bem_sv_cols", 4, {FCVAR_ARCHIVE, FCVAR_REPLICATED, FCVAR_SERVER_CAN_EXECUTE}, "Sets the number of columns in the Traitor/Detective menu's item list (serverside)")
local serverrow = CreateConVar("ttt_bem_sv_rows", 5, {FCVAR_ARCHIVE, FCVAR_REPLICATED, FCVAR_SERVER_CAN_EXECUTE}, "Sets the number of rows in the Traitor/Detective menu's item list (serverside)")
local serversize = CreateConVar("ttt_bem_sv_size", 64, {FCVAR_ARCHIVE, FCVAR_REPLICATED, FCVAR_SERVER_CAN_EXECUTE}, "Sets the item size in the Traitor/Detective menu's item list (serverside)")

-- add Favourites DB functions
AddCSLuaFile("favorites_db.lua")

if CLIENT then
	-- BEM Settings in F1 menu
	hook.Add("TTTSettingsTabs", "BEM_TTTSettingsTab", function(dtabs)
		local padding = dtabs:GetPadding()
		padding = padding * 2

		local dsettings = vgui.Create("DPanelList", dtabs)
		dsettings:StretchToParent(0,0,padding,0)
		dsettings:EnableVerticalScrollbar(true)
		dsettings:SetPadding(10)
		dsettings:SetSpacing(10)

		-- info text
		local dlabel = vgui.Create("DLabel", dsettings)
		dlabel:SetText("All changes made here are clientside and will only apply to your own menu!")
		dlabel:SetTextColor(Color(0, 0, 0, 255))
		dsettings:AddItem(dlabel)

		-- layout section
		local dlayout = vgui.Create("DForm", dsettings)
		dlayout:SetName("Item List Layout")

		if allowChange:GetBool() then
			--dlayout:Help("All changes made here are clientside and will only apply to your own menu.")
			dlayout:NumSlider("Number of columns (def. 4)", "ttt_bem_cols", 1, 20, 0)
			dlayout:NumSlider("Number of rows (def. 5)", "ttt_bem_rows", 1, 20, 0)
			dlayout:NumSlider("Icon size (def. 64)", "ttt_bem_size", 32, 128, 0)
		else
			dlayout:Help("Individual changes to the Traitor/Detective menus layout are not allowed on this server. Please contact a server admin for details.")
		end

		dsettings:AddItem(dlayout)

		-- marker section
		local dmarker = vgui.Create("DForm", dsettings)
		dmarker:SetName("Item Marker Settings")

		dmarker:CheckBox("Show slot marker", "ttt_bem_marker_slot")
		dmarker:CheckBox("Show custom item marker", "ttt_bem_marker_custom")
		dmarker:CheckBox("Show favourite item marker", "ttt_bem_marker_fav")

		dsettings:AddItem(dmarker)

		dtabs:AddSheet("BEM settings", dsettings, "icon16/cog.png", false, false, "Better Equipment Menu Settings")
	end)
end
