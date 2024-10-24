---
-- Clientside language stuff
-- @note Need to build custom tables of strings. Can't use language.Add as there is no
-- way to access the translated string in Lua. Identifiers only get translated
-- when Source/gmod print them. By using our own table and our own lookup, we
-- have far more control. Maybe it's slower, but maybe not, we aren't scanning
-- strings for "#identifiers" after all.
-- @module LANG

LANG.Strings = {}

local table = table
local pairs = pairs

---
-- @realm client
local cv_ttt_language = CreateConVar("ttt_language", "auto", FCVAR_ARCHIVE)

LANG.DefaultLanguage = "en"
LANG.ActiveLanguage = LANG.DefaultLanguage

LANG.ServerLanguage = "en"

local cachedDefault = {}
local cachedActive = {}

local colorWarn = Color(255, 70, 45)

---
-- Creates a new language
-- @param string langName The new language name
-- @return table initialized language table that should be extended with translated @{string}s
-- @realm client
function LANG.CreateLanguage(langName)
    if not langName then
        return
    end

    langName = string.lower(langName)

    if not LANG.IsLanguage(langName) then
        -- Empty string is very convenient to have, so init with that.
        LANG.Strings[langName] = { [""] = "" }
    end

    if langName == LANG.DefaultLanguage then
        cachedDefault = LANG.Strings[langName]

        -- when a string is not found in the active or the default language, an
        -- error message is shown
        setmetatable(LANG.Strings[langName], {
            __index = function(tbl, name)
                return Format("[ERROR: Translation of %s not found]", name), false
            end,
        })
    end

    return LANG.Strings[langName]
end

---
-- Adds a string to a language.
-- @note Should not be used in a language file, only for
-- adding strings elsewhere, such as a SWEP script.
-- @param string langName The new language name
-- @param string stringName The string key identifier for the translated @{string}
-- @param string stringText The translated @{string} text
-- @return string The inserted stringName parameter
-- @realm client
function LANG.AddToLanguage(langName, stringName, stringText)
    langName = LANG.GetNameFromAlias(langName)

    if not LANG.IsLanguage(langName) then
        ErrorNoHalt(
            Format(
                "Failed to add '%s' to language '%s': language does not exist.\n",
                tostring(stringName),
                tostring(langName)
            )
        )

        return stringName
    end

    LANG.Strings[langName][stringName] = stringText

    return stringName
end

---
-- Returns the translated @{string} text (if available)
-- @note Simple and fastest name->string lookup
-- @param string name string key identifier for the translated @{string}
-- @return nil|string
-- @realm client
function LANG.GetTranslation(name)
    return cachedActive[name]
end

---
-- Returns the translated @{string} text (if available) or an available fallback
-- Lookup with no error upon failback, just nil. Slightly slower, but best way
-- to handle lookup of strings that may legitimately fail to exist
-- (eg. SWEP-defined).
-- @param string name string key identifier for the translated @{string}
-- @return nil|string
-- @realm client
function LANG.GetRawTranslation(name)
    return rawget(cachedActive, name) or rawget(cachedDefault, name)
end

-- A common idiom
local GetRaw = LANG.GetRawTranslation

---
-- Returns the translated @{string} text (if available) or the name parameter if not available
-- @param string name string key identifier for the translated @{string}
-- @return nil|string raw translated @{string} or the name parameter if not available
-- @realm client
function LANG.TryTranslation(name)
    return GetRaw(name) or name
end

local interp = string.Interp

---
-- Returns the translated @{string} text (if available).<br />String
-- <a href="http://lua-users.org/wiki/StringInterpolation">interpolation</a> is allowed<br />
-- Parameterised version, performs string interpolation. Slower than
-- @{LANG.GetTranslation}.
-- @param string name string key identifier for the translated @{string}
-- @param table params
-- @return nil|string The translated string
-- @realm client
-- @see LANG.GetPTranslation
function LANG.GetParamTranslation(name, params)
    -- remove the second return variable by caching it
    local trans = interp(cachedActive[name], params)

    return trans
end

---
-- Translates a given string and automatically decides between param translation and normal
-- translation based on the given data. Can also translate the params if so desired.
-- @param string name string key identifier for the translated @{string}
-- @param[opt] table params The params that can be insterted into the translated string
-- @param[opt] boolean translateParams Whether the params should be translated as well
-- @return string The translated string
-- @realm client
function LANG.GetDynamicTranslation(name, params, translateParams)
    -- process params (translation)
    if params and translateParams then
        for k, v in pairs(params) do
            params[k] = LANG.TryTranslation(v)
        end
    end

    if params then
        return LANG.GetParamTranslation(name, params)
    else
        return LANG.TryTranslation(name)
    end
end

---
-- Returns the translated @{string} text (if available).<br />String
-- <a href="http://lua-users.org/wiki/StringInterpolation">interpolation</a> is allowed<br />
-- Parameterised version, performs string interpolation. Slower than
-- @{LANG.GetTranslation}.
-- @param string name string key identifier for the translated @{string}
-- @param any params
-- @return nil|string
-- @realm client
-- @see LANG.GetParamTranslation
-- @function LANG.GetPTranslation(name, params)
LANG.GetPTranslation = LANG.GetParamTranslation

---
-- Returns the translated @{string} text of a given language (if available)
-- @param string name string key identifier for the translated @{string}
-- @param string langName The language name
-- @return nil|string
-- @realm client
function LANG.GetTranslationFromLanguage(name, langName)
    if langName == nil then
        return
    end

    return rawget(LANG.Strings[string.lower(langName)], name)
end

---
-- Returns the translated name of the given language.
-- @param string langName The identifier of the language
-- @return string The translated name of the language
-- @realm client
function LANG.GetTranslatedLanguageName(langName)
    return LANG.GetTranslationFromLanguage("lang_name", langName) or ""
end

---
-- Returns the currently cached language table
-- @note Ability to perform lookups in the current language table directly is of
-- interest to consumers in draw/think hooks. Grabbing a translation directly
-- from the table is very fast, and much simpler than a local caching solution.
-- Modifying it would typically be a bad idea.
-- @return table
-- @realm client
function LANG.GetUnsafeLanguageTable()
    return cachedActive
end

---
-- Caused by a recent rename of the language names, old addons lost compatibility.
-- To prevent annoyance, a compatibility mode is introduced.
-- @note Returns provided langName if no alias was found.
-- @param string langName The string key identifier of the language
-- @return string|nil The language name in the new format
-- @internal
-- @realm client
function LANG.GetNameFromAlias(langName)
    if langName == nil then
        return
    end

    langName = string.lower(langName)

    if LANG.IsLanguage(langName) then
        return langName
    end

    for name, tbl in pairs(LANG.Strings) do
        if tbl.__alias and string.lower(tbl.__alias) == langName then
            Dev(
                1,
                "[DEPRECATION WARNING]: Language name identifier deprecated, please switch from '"
                    .. langName
                    .. "' to '"
                    .. name
                    .. "'."
            )

            return name
        end
    end

    return langName
end

---
-- Returns the reference to a language table if it exists.
-- @param string langName The string key identifier of the language
-- @return nil|table
-- @realm client
function LANG.GetUnsafeNamed(langName)
    langName = LANG.GetNameFromAlias(langName)

    if not LANG.IsLanguage(langName) then
        ErrorNoHaltWithStack(
            Format("Failed to get '%s': language does not exist.\n", tostring(langName))
        )

        return
    end

    return LANG.Strings[langName]
end

---
-- Returns the reference to a language table if it exists, creates a new language if it did not exist.
-- @param string langName The string key identifier of the language
-- @return nil|table
-- @realm client
function LANG.GetLanguageTableReference(langName)
    langName = LANG.GetNameFromAlias(langName)

    if not LANG.IsLanguage(langName) then
        LANG.CreateLanguage(langName)
    end

    return LANG.Strings[langName]
end

---
-- Returns a copy of a selected language table.
-- @note Safe and slow access, not sure if it's ever useful.
-- @param string langName The language name
-- @return table
-- @realm client
function LANG.GetLanguageTable(langName)
    langName = LANG.GetNameFromAlias(langName) or LANG.ActiveLanguage

    local cpy = table.Copy(LANG.Strings[langName])

    LANG.SetFallback(cpy)

    return cpy
end

---
-- Initializes a fallback table for a given language table.
-- @param table tbl
-- @realm client
function LANG.SetFallback(tbl)
    -- languages may deal with this themselves, or may already have the fallback
    local m = getmetatable(tbl)

    if m and m.__index then
        return
    end

    -- Set the __index of the metatable to use the default lang, which makes any
    -- keys not found in the table to be looked up in the default. This is faster
    -- than using branching ("return lang[x] or default[x] or errormsg") and
    -- allows fallback to occur even when consumer code directly accesses the
    -- lang table for speed (eg. in a rendering hook).
    setmetatable(tbl, {
        __index = cachedDefault,
    })
end

---
-- Switches the active language
-- @param string langName The new language name
-- @realm client
function LANG.SetActiveLanguage(langName)
    if langName == nil then
        return
    end

    langName = LANG.GetNameFromAlias(langName)

    if LANG.IsLanguage(langName) then
        local oldName = LANG.ActiveLanguage

        LANG.ActiveLanguage = langName

        -- cache ref to table to avoid hopping through LANG and Strings every time
        cachedActive = LANG.Strings[langName]

        -- set the default lang as fallback, if it hasn't yet
        LANG.SetFallback(cachedActive)

        -- some interface elements will want to know so they can update themselves
        if oldName ~= langName then
            ---
            -- @realm client
            hook.Run("TTTLanguageChanged", oldName, langName)
        end
    else
        Dev(
            1,
            Format(
                "The language '%s' does not exist on this server. Falling back to English...",
                langName
            )
        )

        -- fall back to default if possible
        if langName ~= LANG.DefaultLanguage then
            LANG.SetActiveLanguage(LANG.DefaultLanguage)
        end
    end
end

---
-- Initializes the language service
-- @realm client
-- @internal
function LANG.Init()
    local langName = cv_ttt_language and cv_ttt_language:GetString() or LANG.ServerLanguage

    -- if we want to use the server language, we'll be switching to it as soon as
    -- we hear from the server which one it is, for now use default
    if LANG.IsServerDefault(langName) then
        langName = LANG.ServerLanguage
    end

    LANG.SetActiveLanguage(langName)
end

---
-- Returns whether the given language name is the default server language
-- @param string langName The language name
-- @return boolean
-- @realm client
function LANG.IsServerDefault(langName)
    langName = string.lower(langName)

    return langName == "server default" or langName == "auto"
end

---
-- Returns whether the given language is a valid language (already exists)
-- @param string langName The language name
-- @return table The language table, same as @{LANG.GetUnsafeNamed}, but without
-- @{nil} check and without automatic string lowering
-- @realm client
function LANG.IsLanguage(langName)
    if not langName then
        return
    end

    return LANG.Strings[string.lower(langName)] ~= nil
end

local function LanguageChanged(cv, old, new)
    if new and new ~= LANG.ActiveLanguage then
        if LANG.IsServerDefault(new) then
            new = LANG.ServerLanguage
        end

        LANG.SetActiveLanguage(new)
    end
end
cvars.AddChangeCallback("ttt_language", LanguageChanged)

local function ForceReload()
    LANG.SetActiveLanguage(LANG.DefaultLanguage)
end
concommand.Add("ttt_reloadlang", ForceReload)

---
-- Get a copy of all available languages (keys in the Strings tbl)
-- @return table
-- @realm client
function LANG.GetLanguages()
    local langs = {}

    for lang, strings in pairs(LANG.Strings) do
        langs[#langs + 1] = lang
    end

    return langs
end

---
-- Table of styles that can take a string and display it in some position,
-- colour, etc.
LANG.Styles = {
    [MSG_MSTACK_ROLE] = function(text)
        MSTACK:AddColoredBgMessage(text, LocalPlayer():GetRoleColor())

        Dev(2, "[TTT2] Role:	" .. text)
    end,

    [MSG_MSTACK_WARN] = function(text)
        MSTACK:AddColoredBgMessage(text, colorWarn)

        Dev(2, "[TTT2] Warn:	" .. text)
    end,

    [MSG_MSTACK_PLAIN] = function(text)
        MSTACK:AddMessage(text)

        Dev(2, "[TTT2]:	" .. text)
    end,

    [MSG_CHAT_ROLE] = function(text)
        chat.AddText(LocalPlayer():GetRoleColor(), text)
    end,

    [MSG_CHAT_WARN] = function(text)
        chat.AddText(colorWarn, text)
    end,

    [MSG_CHAT_PLAIN] = chat.AddText,

    [MSG_CONSOLE] = print,
}

LANG.StylesOld = {
    default = LANG.Styles[MSG_MSTACK_PLAIN],
    rolecolour = LANG.Styles[MSG_MSTACK_ROLE],
    chat_warn = LANG.Styles[MSG_CHAT_WARN],
    chat_plain = LANG.Styles[MSG_CHAT_PLAIN],
}

---
-- Table mapping message name => message style name. If no message style is
-- defined, the default style is used. This is the case for the vast majority of
-- messages at the time of writing.
LANG.MsgStyle = {}

---
-- Access of message styles
-- @param string name style name
-- @param number mode The print mode
-- @return function style table
-- @realm client
function LANG.GetStyle(name, mode)
    -- use this as a fallback in case a style is registered
    if LANG.MsgStyle[name] then
        return LANG.MsgStyle[name]
    end

    if mode and LANG.Styles[mode] then
        return LANG.Styles[mode]
    end

    return LANG.Styles[MSG_MSTACK_PLAIN]
end

---
-- Set a style by name or directly as style-function
-- @param string name style name
-- @param string|number|function style style name or @{function}
-- @realm client
function LANG.SetStyle(name, style)
    if isnumber(style) then
        style = LANG.Styles[style]
    elseif isstring(style) then
        style = LANG.StylesOld[style]
    end

    LANG.MsgStyle[name] = style
end

---
-- Runs the style function for a given text
-- @param string text
-- @param function style
-- @realm client
function LANG.ShowStyledMsg(text, style)
    style(text)
end

---
-- Styles a previously translated message
-- @param string name the requested translation identifier (key)
-- @param table params
-- @param number mode The print mode
-- @realm client
function LANG.ProcessMsg(name, params, mode)
    local raw = LANG.TryTranslation(name)
    local text = raw

    if params then
        -- some of our params may be string names themselves
        for k, v in pairs(params) do
            if isstring(v) then
                local name2 = LANG.GetNameParam(v)

                if name2 then
                    params[k] = LANG.GetTranslation(name2)
                end
            end
        end

        text = interp(raw, params)
    end

    LANG.ShowStyledMsg(text, LANG.GetStyle(name, mode))
end

---
-- Returns the coverage in percent of the given language compared to the
-- default language (english).
-- @param string langName The name of the language in question
-- @return number The coverage in percent
-- @realm client
function LANG.GetDefaultCoverage(langName)
    -- if language is set to auto, get server default
    if langName == "auto" then
        langName = LANG.ServerLanguage
    end

    local englishTbl = LANG.Strings[LANG.DefaultLanguage]

    langName = LANG.GetNameFromAlias(langName)

    return table.GetEqualEntriesAmount(LANG.Strings[langName], englishTbl) / table.Count(englishTbl)
end

---
-- Returns the identifier of the currently active language.
-- @return string The name of the active language
-- @realm client
function LANG.GetActiveLanguageName()
    return cv_ttt_language:GetString()
end

---
-- This hook is called after the language was changed.
-- @param string oldLang The name of the old language
-- @param string newLang The name of the new language
-- @hook
-- @realm client
function GM:TTTLanguageChanged(oldLang, newLang) end
