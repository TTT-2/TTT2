local function PopulateLanguagePanel(parent)
	local form = vgui.Create("DForm", parent)
	form:SetName("set_title_lang")

	local dlang = vgui.Create("DComboBox", form)
	dlang:SetConVar("ttt_language")
	dlang:AddChoice("Server default", "auto")

	for _, lang in pairs(LANG.GetLanguages()) do
		dlang:AddChoice(string.Capitalize(lang), lang)
	end

	-- Why is DComboBox not updating the cvar by default?
	dlang.OnSelect = function(idx, val, data)
		RunConsoleCommand("ttt_language", data)
	end

	dlang.Think = dlang.ConVarStringThink

	form:Help("set_lang")
	form:AddItem(dlang)

	form:Dock(FILL)
end

---
-- Function to populate main menu
-- @param table helpData The main menu data object
-- @param string id The unique id of this menu element
-- @internal
-- @realm client
HELPSCRN.populate["ttt2_language"] = function(helpData, id)
	local languageData = helpData:RegisterSubMenu(id)

	languageData:SetTitle("f1_settings_language_title")
	languageData:SetDescription("Some cool text will be here...")
	languageData:SetIcon(Material("vgui/ttt/dynamic/roles/icon_inno"))
end

---
-- Function to populate sub menu
-- @param table helpData The sub menu data object
-- @param string id The unique id of this menu element
-- @internal
-- @realm client
HELPSCRN.subPopulate["ttt2_language"] = function(helpData, id)
	local languageData = helpData:PopulateSubMenu(id .. "_language")

	languageData:SetTitle("ttt2_language")
	languageData:PopulatePanel(PopulateLanguagePanel)
end
