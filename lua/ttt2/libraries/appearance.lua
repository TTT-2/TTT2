---
-- A global appearance handler
-- @author Mineotopia
-- @module appearance

if SERVER then
    AddCSLuaFile()

    return -- the rest of the appearance library is client only
end

---
-- @realm client
local cv_last_width = CreateConVar("ttt2_resolution_last_width", 1920, { FCVAR_ARCHIVE })

---
-- @realm client
local cv_last_height = CreateConVar("ttt2_resolution_last_height", 1080, { FCVAR_ARCHIVE })

---
-- @realm client
local cv_scale = CreateConVar("ttt2_resolution_scale", 1.0, { FCVAR_ARCHIVE })

---
-- @realm client
local cv_use_global_color = CreateConVar("ttt2_use_global_color", 0, { FCVAR_ARCHIVE })

---
-- @realm client
local cv_global_color_r = CreateConVar("ttt2_global_color_r", "30", { FCVAR_ARCHIVE })

---
-- @realm client
local cv_global_color_g = CreateConVar("ttt2_global_color_g", "160", { FCVAR_ARCHIVE })

---
-- @realm client
local cv_global_color_b = CreateConVar("ttt2_global_color_b", "160", { FCVAR_ARCHIVE })

---
-- @realm client
local cv_global_color_a = CreateConVar("ttt2_global_color_a", "160", { FCVAR_ARCHIVE })

local function SetCachedColor()
    appearance.focusColor = Color(
        cv_global_color_r:GetInt(),
        cv_global_color_g:GetInt(),
        cv_global_color_b:GetInt(),
        cv_global_color_a:GetInt()
    )
end

appearance = appearance or {}
appearance.callbacks = {}
appearance.focusColor = nil

---
-- This function should be called when the resolution is updated. It
-- is needed to handle automatic scale setting of all UI elements
-- @param number width The new width
-- @param number height The new height
-- @internal
-- @realm client
function appearance.UpdateResolution(width, height)
    appearance.SetGlobalScale(appearance.GetGlobalScale() * width / appearance.GetLastWidth())

    cv_last_width:SetInt(width)
    cv_last_height:SetInt(height)
end

---
-- Returns the last stored screen width
-- @return number The last stored width
-- @realm client
function appearance.GetLastWidth()
    return cv_last_width:GetInt() or 0
end

---
-- Returns the last stored screen height
-- @return number The last stored height
-- @realm client
function appearance.GetLastHeight()
    return cv_last_height:GetInt() or 0
end

---
-- This function updates the global scale of all UI elements
-- @param number scale The scale as a floating point value
-- @realm client
function appearance.SetGlobalScale(scale)
    local oldScale = appearance.GetGlobalScale()

    if oldScale == scale then
        return
    end

    cv_scale:SetFloat(scale)

    local appearanceCallbacks = appearance.callbacks

    for i = 1, #appearanceCallbacks do
        appearanceCallbacks[i](oldScale, scale)
    end
end

---
-- This function returns the current global scale
-- @return number The scale as a floating point value
-- @realm client
function appearance.GetGlobalScale()
    return cv_scale:GetFloat() or 1.0
end

---
-- Returns the default global scale based on the current
-- screen resolution in reference to a 1080p based design
-- @return number The scale as a floating point value
-- @realm client
function appearance.GetDefaultGlobalScale()
    return math.Round(ScrW() / 1920, 1)
end

---
-- Registers a callback function that is called once the scale
-- is changed
-- @param function fn The callback function
-- @realm client
function appearance.RegisterScaleChangeCallback(fn)
    if not isfunction(fn) or table.HasValue(appearance.callbacks, fn) then
        return
    end

    appearance.callbacks[#appearance.callbacks + 1] = fn
end

---
-- Sets the focus color for the client
-- @param Color clr The new focus color
-- @realm client
function appearance.SetFocusColor(clr)
    cv_global_color_r:SetInt(clr.r)
    cv_global_color_g:SetInt(clr.g)
    cv_global_color_b:SetInt(clr.b)
    cv_global_color_a:SetInt(clr.a)
end

---
-- Returns the current focus color
-- @return Color The current focus color
-- @realm client
function appearance.GetFocusColor()
    if not IsColor(appearance.focusColor) then
        SetCachedColor()
    end

    return appearance.focusColor
end

cvars.AddChangeCallback(cv_global_color_r:GetName(), function(cv, old, new)
    SetCachedColor()
end)
cvars.AddChangeCallback(cv_global_color_g:GetName(), function(cv, old, new)
    SetCachedColor()
end)
cvars.AddChangeCallback(cv_global_color_b:GetName(), function(cv, old, new)
    SetCachedColor()
end)
cvars.AddChangeCallback(cv_global_color_a:GetName(), function(cv, old, new)
    SetCachedColor()
end)

---
-- Sets if the global focus color or the dynamic color should
-- be used
-- @param boolean state The new use state
-- @realm client
function appearance.SetUseGlobalFocusColor(state)
    cv_use_global_color:SetBool(state == nil and true or state)
end

---
-- Returns whether the global color should be used or not
-- @return boolean The color state
-- @realm client
function appearance.ShouldUseGlobalFocusColor()
    return cv_use_global_color:GetBool()
end

---
-- Helper function that returns the correct color based on the
-- current global color settings
-- @param Color The color that is used as a fallback
-- @return Color The chosen color
-- @realm client
function appearance.SelectFocusColor(clr)
    if appearance.ShouldUseGlobalFocusColor() then
        return appearance.GetFocusColor()
    end

    return clr
end
