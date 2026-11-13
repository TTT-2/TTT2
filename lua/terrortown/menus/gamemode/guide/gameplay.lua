--- @ignore

CLGAMEMODESUBMENU.base = "base_gamemodesubmenu"

CLGAMEMODESUBMENU.priority = 100
CLGAMEMODESUBMENU.title = "submenu_guide_gameplay_title"

-- returns the default key if it is still bound to the command, otherwise the first bound key
local function GameKey(binding, defaultButton, default)
    if input.LookupKeyBinding(defaultButton) == binding then
        return default
    end

    return Key(binding, default)
end

-- returns the key name of a TTT2 binding or a fallback if it is not bound
local function BindKey(name, default)
    local key = bind.Find(name)

    if not key or key == KEY_NONE then
        return default
    end

    return string.upper(input.GetKeyName(key) or default)
end

function CLGAMEMODESUBMENU:Populate(parent)
    local keys = {
        helpkey = GameKey("gm_showhelp", KEY_F1, "F1"),
        scorekey = GameKey("+showscores", KEY_TAB, "TAB"),
        shopkey = GameKey("+menu_context", KEY_C, "C"),
        dropkey = GameKey("+menu", KEY_Q, "Q"),
        usekey = GameKey("+use", KEY_E, "E"),
        walkkey = GameKey("+walk", KEY_LALT, "ALT"),
        attackkey = GameKey("+attack", MOUSE_LEFT, "MOUSE1"),
        attack2key = GameKey("+attack2", MOUSE_RIGHT, "MOUSE2"),
        reloadkey = GameKey("+reload", KEY_R, "R"),
        duckkey = GameKey("+duck", KEY_LCONTROL, "CTRL"),
        jumpkey = GameKey("+jump", KEY_SPACE, "SPACE"),
        speedkey = GameKey("+speed", KEY_LSHIFT, "SHIFT"),
        mutekey = GameKey("gm_showteam", KEY_F2, "F2"),
        voicekey = BindKey("ttt2_voice", GameKey("+voicerecord", KEY_X, "X")),
        teamvoicekey = BindKey("ttt2_voice_team", "T"),
    }

    local sections = {
        "goal",
        "round",
        "haste",
        "roles",
        "bodies",
        "spectator",
        "possession",
        "shop",
        "karma",
        "controls",
    }

    for i = 1, #sections do
        local section = sections[i]
        local form = vgui.CreateTTT2Form(parent, "header_guide_gameplay_" .. section)

        form:MakeHelp({
            label = "help_guide_gameplay_" .. section,
            params = keys,
        })
    end
end
