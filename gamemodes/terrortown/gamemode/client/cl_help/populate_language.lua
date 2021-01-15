local materialIcon = Material("vgui/ttt/vskin/helpscreen/language")

local GetActiveLanguageName = LANG.GetActiveLanguageName
local GetTranslatedLanguageName = LANG.GetTranslatedLanguageName
local TryT = LANG.TryTranslation

local function PopulateLanguagePanel(parent)
	local form = vgui.CreateTTT2Form(parent, "header_language")

	local dlang = form:MakeComboBox({
		label = "label_language_set",
		convar = "ttt_language",
		OnChange = function(slf, index, value, rawdata)

			if rawdata == "auto" and GetActiveLanguageName() == "auto" then return end

			if value == GetTranslatedLanguageName(GetActiveLanguageName()) then return end

			vguihandler.InvalidateVSkin()
			vguihandler.Rebuild()
		end
	})

	-- since these are no simple strings, the choices have to be added manually
	dlang:AddChoice(TryT("lang_server_default"), "auto", false)

	for _, lang in pairs(LANG.GetLanguages()) do
		dlang:AddChoice(GetTranslatedLanguageName(lang), lang, false)
	end

	if GetActiveLanguageName() == "auto" then
		dlang:ChooseOptionName(TryT("lang_server_default"))
	else
		dlang:ChooseOptionName(GetTranslatedLanguageName(GetActiveLanguageName()))
	end

	form:MakeHelp({
		label = "help_lang_info",
		params = {coverage = math.Round(100 * LANG.GetDefaultCoverage(GetActiveLanguageName()), 1)}
	})
end

HELPSCRN.populate["ttt2_language"] = function(helpData, id)
	local languageData = helpData:RegisterSubMenu(id)

	languageData:SetTitle("menu_language_title")
	languageData:SetDescription("menu_language_description")
	languageData:SetIcon(materialIcon)
end

HELPSCRN.subPopulate["ttt2_language"] = function(helpData, id)
	local languageData = helpData:PopulateSubMenu(id .. "_language")

	languageData:SetTitle("submenu_language_language_title")
	languageData:PopulatePanel(PopulateLanguagePanel)
end
