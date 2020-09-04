if engine.ActiveGamemode() ~= "terrortown" then return end

-- create serverside ConVars
local allowChange = CreateConVar("ttt_bem_allow_change", 1, SERVER and {FCVAR_ARCHIVE, FCVAR_REPLICATED} or FCVAR_REPLICATED, "Allow clients to change the look of the Traitor/Detective menu")
CreateConVar("ttt_bem_sv_cols", 4, SERVER and {FCVAR_ARCHIVE, FCVAR_REPLICATED} or FCVAR_REPLICATED, "Sets the number of columns in the Traitor/Detective menu's item list (serverside)")
CreateConVar("ttt_bem_sv_rows", 5, SERVER and {FCVAR_ARCHIVE, FCVAR_REPLICATED} or FCVAR_REPLICATED, "Sets the number of rows in the Traitor/Detective menu's item list (serverside)")
CreateConVar("ttt_bem_sv_size", 64, SERVER and {FCVAR_ARCHIVE, FCVAR_REPLICATED} or FCVAR_REPLICATED, "Sets the item size in the Traitor/Detective menu's item list (serverside)")

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

			dgeneral:CheckBox(LANG.GetTranslation("f1_settings_shop_desc_shopopen"), "ttt_bem_always_show_shop")
			dgeneral:CheckBox(LANG.GetTranslation("f1_settings_shop_desc_double_click"), "ttt_bem_enable_doubleclick_buy")

			dgeneral:Dock(TOP)

			-- layout section
			local dlayout = vgui.Create("DForm", parent)
			dlayout:SetName(LANG.GetTranslation("f1_settings_shop_title_layout"))

			if allowChange:GetBool() then
				--dlayout:Help("All changes made here are clientside and will only apply to your own menu.")
				dlayout:NumSlider(LANG.GetTranslation("f1_settings_shop_desc_num_columns") .. " (def. 4)", "ttt_bem_cols", 1, 20, 0)
				dlayout:NumSlider(LANG.GetTranslation("f1_settings_shop_desc_num_rows") .. " (def. 5)", "ttt_bem_rows", 1, 20, 0)
				dlayout:NumSlider(LANG.GetTranslation("f1_settings_shop_desc_item_size") .. " (def. 64)", "ttt_bem_size", 32, 128, 0)
			else
				dlayout:Help(LANG.GetTranslation("f1_shop_restricted"))
			end

			dlayout:Dock(TOP)

			-- marker section
			local dmarker = vgui.Create("DForm", parent)
			dmarker:SetName(LANG.GetTranslation("f1_settings_shop_title_marker"))

			dmarker:CheckBox(LANG.GetTranslation("f1_settings_shop_desc_show_slot"), "ttt_bem_marker_slot")
			dmarker:CheckBox(LANG.GetTranslation("f1_settings_shop_desc_show_custom"), "ttt_bem_marker_custom")
			dmarker:CheckBox(LANG.GetTranslation("f1_settings_shop_desc_show_favourite"), "ttt_bem_marker_fav")

			dmarker:Dock(TOP)
		end
		bemTbl.getTitle = function()
			return LANG.GetTranslation("f1_settings_shop_title")
		end

		tbl[#tbl + 1] = bemTbl
	end
	hook.Add("TTT2ModifySettingsList", "BEM_TTTSettingsTab", TTTBemSettings)
end
