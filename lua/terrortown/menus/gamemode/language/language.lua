--- @ignore

local GetActiveLanguageName = LANG.GetActiveLanguageName
local GetTranslatedLanguageName = LANG.GetTranslatedLanguageName
local TryT = LANG.TryTranslation

CLGAMEMODESUBMENU.base = "base_gamemodesubmenu"

CLGAMEMODESUBMENU.priority = 100
CLGAMEMODESUBMENU.title = "submenu_language_language_title"

function CLGAMEMODESUBMENU:Populate(parent)
    local form = vgui.CreateTTT2Form(parent, "header_language")

    local choices = {}
    local activeLanguageName = GetActiveLanguageName()

    choices[1] = {
        title = TryT("lang_server_default"),
        value = "auto",
        select = activeLanguageName == "auto",
    }

    for _, lang in pairs(LANG.GetLanguages()) do
        choices[#choices + 1] = {
            title = GetTranslatedLanguageName(lang),
            value = lang,
            select = activeLanguageName == lang,
        }
    end

    form:MakeComboBox({
        label = "label_language_set",
        convar = "ttt_language",
        choices = choices,
        OnChange = function(value)
            vguihandler.InvalidateVSkin()
            vguihandler.Rebuild()
        end,
    })

    form:MakeHelp({
        label = "help_lang_info",
        params = { coverage = math.Round(100 * LANG.GetDefaultCoverage(activeLanguageName), 1) },
    })
end
