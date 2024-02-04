-- Test/gimmick lang
-- Not an example of how you should translate something. See en.lua for that.

local L = LANG.CreateLanguage("swedish_chef")

L.lang_name = "Swedish Chef (Bork)"

local gsub = string.gsub

local function Borkify(word)
    local b = string.byte(word:sub(1, 1))

    if b > 64 and b < 91 then
        return "Bork"
    end

    return "bork"
end

local realised = false

-- Upon selection, borkify every english string.
-- Even with all the string manipulation this only takes a few ms.
local function LanguageChanged(old, new)
    if realised or new ~= "swedish_chef" then return end

    local eng = LANG.GetUnsafeNamed("en")

    for k, v in pairs(eng) do
        L[k] = gsub(v, "[{}%w]+", Borkify)
    end

    realised = true
end
hook.Add("TTTLanguageChanged", "ActivateChef", LanguageChanged)

-- As fallback, non-existent indices translated on the fly.
local GetFrom = LANG.GetTranslationFromLanguage

setmetatable(L, {
    __index = function(_, k)
        return gsub(GetFrom(k, "en") or "bork", "[{}%w]+", "BORK")
    end
})
