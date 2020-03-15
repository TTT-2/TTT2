local materialIcon = Material("vgui/ttt/derma/helpscreen/language")

local function PopulateLanguagePanel(parent)
	local form = vgui.Create("DFormTTT2", parent)
	form:SetName("set_title_lang")

	local dlang = form:ComboBox("set_lang", "ttt_language")

	dlang:AddChoice("Server default", "auto")

	for _, lang in pairs(LANG.GetLanguages()) do
		dlang:AddChoice(string.Capitalize(lang), lang)
	end

	dlang.OnSelect = function(idx, val, data)
		RunConsoleCommand("ttt_language", data)

		VHDL.UpdateVSkinSetting("language")
	end

	form:Dock(TOP)
end

---
-- Function to populate main menu
-- @param table helpData The main menu data object
-- @param string id The unique id of this menu element
-- @internal
-- @realm client
HELPSCRN.populate["ttt2_language"] = function(helpData, id)
	local languageData = helpData:RegisterSubMenu(id)

	languageData:SetTitle("menu_anguage_title")
	languageData:SetDescription("menu_anguage_description")
	languageData:SetIcon(materialIcon)
end

---
-- Function to populate sub menu
-- @param table helpData The sub menu data object
-- @param string id The unique id of this menu element
-- @internal
-- @realm client
HELPSCRN.subPopulate["ttt2_language"] = function(helpData, id)
	local languageData = helpData:PopulateSubMenu(id .. "_language")

	languageData:SetTitle("submenu_language_language_title")
	languageData:PopulatePanel(PopulateLanguagePanel)
end
