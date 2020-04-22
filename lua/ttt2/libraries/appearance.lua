---
-- A global appearance handler
-- @author Mineotopia

AddCSLuaFile()

-- the rest of the draw library is client only
if SERVER then return end

local cv_last_width = CreateConVar("ttt2_resolution_last_width", 1920, {FCVAR_ARCHIVE})
local cv_last_height = CreateConVar("ttt2_resolution_last_height", 1080, {FCVAR_ARCHIVE})
local cv_scale = CreateConVar("ttt2_resolution_scale", 1.0, {FCVAR_ARCHIVE})

local cv_use_global_color = CreateConVar("ttt2_use_global_color", 0, {FCVAR_ARCHIVE})
local cv_global_color_r = CreateConVar("ttt2_global_color_r", "30", {FCVAR_ARCHIVE})
local cv_global_color_g = CreateConVar("ttt2_global_color_g", "160", {FCVAR_ARCHIVE})
local cv_global_color_b = CreateConVar("ttt2_global_color_b", "160", {FCVAR_ARCHIVE})
local cv_global_color_a = CreateConVar("ttt2_global_color_a", "160", {FCVAR_ARCHIVE})

appearance = appearance or {}
appearance.callbacks = {}

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

	if oldScale == scale then return end

	cv_scale:SetFloat(scale)

	for i = 1, #appearance.callbacks do
		appearance.callbacks[i](oldScale, scale)
	end
end

---
-- This function returns the current global scale
-- @return number The scale as a floating point value
function appearance.GetGlobalScale()
	return cv_scale:GetFloat() or 1.0
end

---
-- Returns the default global scale based on the current
-- screen resolution
-- @return number The scale as a floating point value
function appearance.GetDefaultGlobalScale()
	return math.Round(ScrW() / 1920, 1)
end

---
-- Registers a callback function that is called once the scale
-- is changed
function appearance.RegisterScaleChangeCallback(fn)
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
	return Color(
		cv_global_color_r:GetInt(),
		cv_global_color_g:GetInt(),
		cv_global_color_b:GetInt(),
		cv_global_color_a:GetInt()
	)
end

---
-- Sets if the global focus color or the dyanmic color should
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
-- Helper function that returnes the correct color based on the
-- current global color settings
-- @param Color The color to validate
-- @return Color The validated color
-- @realm client
function appearance.ChooseFocusColor(clr)
	if appearance.ShouldUseGlobalFocusColor() then
		return appearance.GetFocusColor()
	else
		return clr
	end
end
