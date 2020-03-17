local materialIcon = Material("vgui/ttt/derma/helpscreen/language")

local function PopulateLanguagePanel(parent)
	local form = CreateForm(parent, "set_title_lang")

	local dlang = form:MakeComboBox({
		label = "set_lang",
		convar = "ttt_language",
		onSelect = function(slf, index, value, rawdata)
			VHDL.UpdateVSkinSetting("language")
		end
	})

	-- since these are no simple strings, the choices have to be added manually
	dlang:AddChoice("Server default", "auto")
	for _, lang in pairs(LANG.GetLanguages()) do
		dlang:AddChoice(string.Capitalize(lang), lang)
	end
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
