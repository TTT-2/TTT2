local materialIcon = Material("vgui/ttt/vskin/helpscreen/language")

local function PopulateLanguagePanel(parent)
	local form = CreateTTT2Form(parent, "header_language")

	local dlang = form:MakeComboBox({
		label = "label_language_set",
		convar = "ttt_language",
		OnChange = function(slf, index, value, rawdata)
			vguihandler.InvalidateVSkin()
		end
	})

	-- since these are no simple strings, the choices have to be added manually
	dlang:AddChoice("Server default", "auto")

	for _, lang in pairs(LANG.GetLanguages()) do
		dlang:AddChoice(string.Capitalize(lang), lang)
	end
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
