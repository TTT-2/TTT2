---
-- @module LANG
-- @desc Clientside language stuff
-- @note Need to build custom tables of strings. Can't use language.Add as there is no
-- way to access the translated string in Lua. Identifiers only get translated
-- when Source/gmod print them. By using our own table and our own lookup, we
-- have far more control. Maybe it's slower, but maybe not, we aren't scanning
-- strings for "#identifiers" after all.

LANG.Strings = {}

local table = table
local pairs = pairs
local CreateConVar = CreateConVar

local ttt_language = CreateConVar("ttt_language", "auto", FCVAR_ARCHIVE)

LANG.DefaultLanguage = "english"
LANG.ActiveLanguage = LANG.DefaultLanguage

LANG.ServerLanguage = "english"

local cached_default = {}
local cached_active = {}

local warn_color = Color(255, 70, 45)

---
-- Creates a new language
-- @param string lang_name the new language name
-- @return table initialized language table that should be extended with translated @{string}s
-- @realm client
function LANG.CreateLanguage(lang_name)
	if not lang_name then return end

	lang_name = string.lower(lang_name)

	if not LANG.IsLanguage(lang_name) then
		-- Empty string is very convenient to have, so init with that.
		LANG.Strings[lang_name] = {[""] = ""}
	end

	if lang_name == LANG.DefaultLanguage then
		cached_default = LANG.Strings[lang_name]

		-- when a string is not found in the active or the default language, an
		-- error message is shown
		setmetatable(LANG.Strings[lang_name], {
			__index = function(tbl, name)
				return Format("[ERROR: Translation of %s not found]", name), false
			end
		})
	end

	return LANG.Strings[lang_name]
end

---
-- Adds a string to a language.
-- @note Should not be used in a language file, only for
-- adding strings elsewhere, such as a SWEP script.
-- @param string lang_name the new language name
-- @param string string_name the string key identifier for the translated @{string}
-- @param string string_text the translated @{string} text
-- @return string the inserted string_name parameter
-- @realm client
function LANG.AddToLanguage(lang_name, string_name, string_text)
	lang_name = lang_name and string.lower(lang_name) or nil

	if not LANG.IsLanguage(lang_name) then
		ErrorNoHalt(Format("Failed to add '%s' to language '%s': language does not exist.\n", tostring(string_name), tostring(lang_name)))

		return string_name
	end

	LANG.Strings[lang_name][string_name] = string_text

	return string_name
end

---
-- Returns the translated @{string} text (if available)
-- @note Simple and fastest name->string lookup
-- @param string name string key identifier for the translated @{string}
-- @return nil|string
-- @realm client
function LANG.GetTranslation(name)
	return cached_active[name]
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
	return rawget(cached_active, name) or rawget(cached_default, name)
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
	local trans = interp(cached_active[name], params)

	return trans
end

---
-- @function LANG.GetPTranslation(name, params)
-- @desc Returns the translated @{string} text (if available).<br />String
-- <a href="http://lua-users.org/wiki/StringInterpolation">interpolation</a> is allowed<br />
-- Parameterised version, performs string interpolation. Slower than
-- @{LANG.GetTranslation}.
-- @param string name string key identifier for the translated @{string}
-- @return nil|string
-- @realm client
-- @see LANG.GetParamTranslation
LANG.GetPTranslation = LANG.GetParamTranslation

---
-- Returns the translated @{string} text of a given language (if available)
-- @param string name string key identifier for the translated @{string}
-- @param string lang_name the language name
-- @return nil|string
-- @realm client
function LANG.GetTranslationFromLanguage(name, lang_name)
	return rawget(LANG.Strings[lang_name], name)
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
	return cached_active
end

---
-- Returns the reference to a language table if it exists
-- @param string name string key identifier for the language
-- @return nil|table
-- @realm client
function LANG.GetUnsafeNamed(lang_name)
	lang_name = lang_name and string.lower(lang_name) or nil

	if not LANG.IsLanguage(lang_name) then
		ErrorNoHalt(Format("Failed to get '%s': language does not exist.\n", tostring(lang_name)))

		return
	end

	return LANG.Strings[lang_name]
end

---
-- Returns the reference to a language table if it exists, creates a new language if it did not exist
-- @param string name string key identifier for the language
-- @return nil|table
-- @realm client
function LANG.GetLanguageTableReference(lang_name)
	lang_name = lang_name and string.lower(lang_name) or nil

	if not LANG.IsLanguage(lang_name) then
		LANG.CreateLanguage(lang_name)
	end

	return LANG.Strings[lang_name]
end

---
-- Returns a copy of a selected language table
-- @note Safe and slow access, not sure if it's ever useful.
-- @param string lang_name the language name
-- @return table
-- @realm client
function LANG.GetLanguageTable(lang_name)
	lang_name = lang_name or LANG.ActiveLanguage

	local cpy = table.Copy(LANG.Strings[lang_name])

	SetFallback(cpy)

	return cpy
end

---
-- Initializes a fallback table for a given language table
-- @param table tbl
-- @realm client
function SetFallback(tbl)
	-- languages may deal with this themselves, or may already have the fallback
	local m = getmetatable(tbl)

	if m and m.__index then return end

	-- Set the __index of the metatable to use the default lang, which makes any
	-- keys not found in the table to be looked up in the default. This is faster
	-- than using branching ("return lang[x] or default[x] or errormsg") and
	-- allows fallback to occur even when consumer code directly accesses the
	-- lang table for speed (eg. in a rendering hook).
	setmetatable(tbl, {
		__index = cached_default
	})
end

---
-- Switches the active language
-- @param string lang_name the new language name
-- @realm client
function LANG.SetActiveLanguage(lang_name)
	lang_name = lang_name and string.lower(lang_name) or nil

	if LANG.IsLanguage(lang_name) then
		local old_name = LANG.ActiveLanguage

		LANG.ActiveLanguage = lang_name

		-- cache ref to table to avoid hopping through LANG and Strings every time
		cached_active = LANG.Strings[lang_name]

		-- set the default lang as fallback, if it hasn't yet
		SetFallback(cached_active)

		-- some interface elements will want to know so they can update themselves
		if old_name ~= lang_name then
			hook.Call("TTTLanguageChanged", GAMEMODE, old_name, lang_name)
		end
	else
		MsgN(Format("The language '%s' does not exist on this server. Falling back to English...", lang_name))

		-- fall back to default if possible
		if lang_name ~= LANG.DefaultLanguage then
			LANG.SetActiveLanguage(LANG.DefaultLanguage)
		end
	end
end

---
-- Initializes the language service
-- @realm client
-- @internal
function LANG.Init()
	local lang_name = ttt_language and ttt_language:GetString() or LANG.ServerLanguage

	-- if we want to use the server language, we'll be switching to it as soon as
	-- we hear from the server which one it is, for now use default
	if LANG.IsServerDefault(lang_name) then
		lang_name = LANG.ServerLanguage
	end

	LANG.SetActiveLanguage(lang_name)
end

---
-- Returns whether the given language name is the default server language
-- @param string lang_name the language name
-- @return boolean
-- @realm client
function LANG.IsServerDefault(lang_name)
	lang_name = string.lower(lang_name)

	return lang_name == "server default" or lang_name == "auto"
end

---
-- Returns whether the given language is a valid language (already exists)
-- @param string lang_name the language name
-- @return table the language table, same as @{LANG.GetUnsafeNamed}, but without
-- @{nil} check and without automatic string lowering
-- @realm client
function LANG.IsLanguage(lang_name)
	if not lang_name then return end

	return LANG.Strings[string.lower(lang_name)] ~= nil
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
	LANG.SetActiveLanguage("english")
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

		print("[TTT2] Role:	" .. text)
	end,

	[MSG_MSTACK_WARN] = function(text)
		MSTACK:AddColoredBgMessage(text, warn_color)

		print("[TTT2] Warn:	" .. text)
	end,

	[MSG_MSTACK_PLAIN] = function(text)
		MSTACK:AddMessage(text)

		print("[TTT2]:	" .. text)
	end,

	[MSG_CHAT_ROLE] = function(text)
		chat.AddText(LocalPlayer():GetRoleColor(), text)
	end,

	[MSG_CHAT_WARN] = function(text)
		chat.AddText(warn_color, text)
	end,

	[MSG_CHAT_PLAIN] = chat.AddText,

	[MSG_CONSOLE] = print
}

LANG.StylesOld = {
	default = LANG.Styles[MSG_MSTACK_PLAIN],
	rolecolour = LANG.Styles[MSG_MSTACK_ROLE],
	chat_warn = LANG.Styles[MSG_CHAT_WARN],
	chat_plain = LANG.Styles[MSG_CHAT_PLAIN]
}

---
-- Table mapping message name => message style name. If no message style is
-- defined, the default style is used. This is the case for the vast majority of
-- messages at the time of writing.
LANG.MsgStyle = {}

---
-- Access of message styles
-- @param string name style name
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
-- @realm client
function LANG.ProcessMsg(name, params, mode)
	local raw = LANG.TryTranslation(name)
	local text = raw

	if params then
		-- some of our params may be string names themselves
		for k, v in pairs(params) do
			if isstring(v) then
				local name2 = LANG.GetNameParam(v)

				--if not name2 then
				-- TODO test, string to bool?
				--else
				if name2 then
					params[k] = LANG.GetTranslation(name2)
				end
			end
		end

		text = interp(raw, params)
	end

	LANG.ShowStyledMsg(text, LANG.GetStyle(name, mode))
end

-- Message style declarations

-- Rather than having a big list of LANG.SetStyle calls, we specify it the other
-- way around here and churn through it in code. This is convenient because
-- we're doing it en-masse for some random interface things spread out over the
-- place.
--
-- Styles of custom SWEP messages and such should use LANG.SetStyle in their
-- script. The SWEP stuff here might be moved out to the SWEPS too.

-- TODO the remaining messages here are moved to their fitting ents as soon as 
-- we move them all into our main repo

local styledmessages = {
	rolecolour = { -- TODO move to teleporter
		"tele_failed",
		"tele_no_mark",
		"tele_marked"
	},

	chat_warn = { -- TODO move to teleporter
		"tele_no_ground",
		"tele_no_crouch",
		"tele_no_mark_ground",
		"tele_no_mark_crouch"
	}
}

local set_style = LANG.SetStyle

for style, msgs in pairs(styledmessages) do
	for _, name in pairs(msgs) do
		set_style(name, style)
	end
end
