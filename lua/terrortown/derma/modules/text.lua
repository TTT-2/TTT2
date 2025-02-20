---
-- @class PANEL
-- @section TTT2:DPanel/Text

---
-- @accessor string
-- @realm client
AccessorFunc(METAPANEL, "m_FontName", "Font", nil, true)

---
-- @accessor number
-- @realm client
AccessorFunc(METAPANEL, "m_nTextAlign", "TextAlign", FORCE_NUMBER, true)

---
-- @accessor string
-- @realm client
AccessorFunc(METAPANEL, "m_TranslatedText", "TranslatedText", FORCE_STRING, true)

---
-- @accessor string
-- @realm client
AccessorFunc(METAPANEL, "m_TranslatedDescription", "TranslatedDescription", FORCE_STRING, true)

---
-- @accessor table
-- @realm client
AccessorFunc(METAPANEL, "m_TranslatedDescriptionLines", "TranslatedDescriptionLines", nil, true)

---
-- Sets the font of the panel.
-- @param string fontName The name of the font
-- @return Panel Returns the panel itself
-- @realm client
function METAPANEL:SetFont(fontName)
    self.m_FontName = fontName

    self:SetFontInternal(self.m_FontName)
    self:InvalidateLayout() -- rebuild in next frame

    return self
end

---
-- Sets the font of the description of the panel.
-- @param string fontName The name of the font
-- @return Panel Returns the panel itself
-- @realm client
function METAPANEL:SetDescriptionFont(fontName)
    self.m_DescriptionFontName = fontName

    self:InvalidateLayout() -- rebuild in next frame

    return self
end

---
-- Returns the name of the font used for the description
-- @return string The description font name
-- @realm client
function METAPANEL:GetDescriptionFont()
    return self.m_DescriptionFontName
end

---
-- Sets the text alignment in both directions.
-- @param number horizontal The horizontal text alignment
-- @param number vertical The vertical text alignment
-- @return Panel Returns the panel itself
-- @realm client
function METAPANEL:SetTextAlign(horizontal, vertical)
    self:SetHorizontalTextAlign(horizontal)
    self:SetVerticalTextAlign(vertical)

    self:InvalidateLayout() -- rebuild in next frame

    return self
end

---
-- Sets the text to a panel.
-- @param string The text of a panel, can be a language identifier
-- @param[opt] table params Translation params that should be added to the text
-- @param[default=false] boolean translateParams Should the parameters be translated as well
-- @param[default=false] boolean isShadowed Should the text be rendered with a shadow
-- @return Panel Returns the panel itself
-- @realm client
function METAPANEL:SetText(text, params, translateParams, isShadowed)
    self.m_Text = text
    self.m_TextParams = params
    self.m_bTranslateTextParams = translateParams
    self.m_bTextShadow = isShadowed

    self:InvalidateLayout() -- rebuild in next frame

    return self
end

---
-- Gets the text set to the panel.
-- @return string Rerturns the attached text
-- @realm client
function METAPANEL:GetText()
    return self.m_Text or ""
end

---
-- Checks whether a panel has any text set to it.
-- @return boolean Returns true if text is added to the panel
-- @realm client
function METAPANEL:HasText()
    return self.m_Text ~= nil
end

---
-- Returns if a panel has text params set.
-- @return boolean Returns true if a label has text params
-- @realm client
function METAPANEL:GetTextParams()
    return self.m_TextParams
end

---
-- Returns if a panel has text params set.
-- @return boolean Returns true if a label has text params
-- @realm client
function METAPANEL:HasTextParams()
    return self.m_TextParams ~= nil
end

---
-- Whether the text params should be translated.
-- @return boolean True if the text params should be translated
-- @realm client
function METAPANEL:ShouldTranslateTextParams()
    return self.m_bTranslateTextParams or LANG_DONT_TRANSLATE_PARAMS
end

---
-- Returns if the text should have a drop shadow.
-- @return boolean True if drop shadow is enabled
-- @realm client
function METAPANEL:HasTextShadow()
    return self.m_bTextShadow or DRAW_SHADOW_ENABLED
end

---
-- Sets the description to a panel.
-- @param string The description of a panel, can be a language identifier
-- @param[opt] table params Translation params that should be added to the description
-- @param[default=false] boolean translateParams Should the parameters be translated as well
-- @param[default=false] boolean isShadowed Should the description be rendered with a shadow
-- @return Panel Returns the panel itself
-- @realm client
function METAPANEL:SetDescription(description, params, translateParams, isShadowed)
    self.m_Description = description
    self.m_DescriptionParams = params
    self.m_bTranslateDescriptionParams = translateParams
    self.m_bDescriptionShadow = isShadowed

    self:InvalidateLayout() -- rebuild in next frame

    return self
end

---
-- Gets the description set to the panel.
-- @return string Rerturns the attached description
-- @realm client
function METAPANEL:GetDescription()
    return self.m_Description or ""
end

---
-- Checks whether a panel has any description set to it.
-- @return boolean Returns true if description is added to the panel
-- @realm client
function METAPANEL:HasDescription()
    return self.m_Description ~= nil
end

---
-- Returns if a panel has description params set.
-- @return boolean Returns true if a label has description params
-- @realm client
function METAPANEL:GetDescriptionParams()
    return self.m_DescriptionParams
end

---
-- Returns if a panel has description params set.
-- @return boolean Returns true if a label has description params
-- @realm client
function METAPANEL:HasDescriptionParams()
    return self.m_DescriptionParams ~= nil
end

---
-- Whether the description params should be translated.
-- @return boolean True if the description params should be translated
-- @realm client
function METAPANEL:ShouldTranslateDescriptionParams()
    return self.m_bTranslateDescriptionParams or LANG_DONT_TRANSLATE_PARAMS
end

---
-- Returns if the description should have a drop shadow.
-- @return boolean True if drop shadow is enabled
-- @realm client
function METAPANEL:HasDescriptionShadow()
    return self.m_bDescriptionShadow or DRAW_SHADOW_ENABLED
end

---
-- Appends a binding associated to that panel. They key will be appended after the
-- text. The binding can be a GMod binding or a TTT2 binding.
-- @param string binding The key binding name
-- @return Panel Returns the panel itself
-- @realm client
function METAPANEL:SetKeyBinding(binding)
    self.m_Binding = binding

    self:InvalidateLayout() -- rebuild in next frame

    return self
end

---
-- Checks whether a key binding was added to the panel.
-- @return boolean Returns true if a key binding is added
-- @realm client
function METAPANEL:HasKeyBinding()
    return self.m_Binding ~= nil
end

---
-- Returns the translated key binding if there exists one.
-- @return string The translated key binding
-- @realm client
function METAPANEL:GetTranslatedKeyBindingKey()
    local key = Key(self.m_Binding) or input.GetKeyName(bind.Find(self.m_Binding))

    if not key then
        return ""
    end

    return LANG.GetParamTranslation(
        "binding_panel_bracket",
        { binding = string.upper(LANG.TryTranslation(key)) }
    )
end
