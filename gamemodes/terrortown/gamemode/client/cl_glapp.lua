---
-- A global appearance handler
-- @author Mineotopia

local cv_last_width = CreateConVar("ttt2_resolution_last_width", 1920, {FCVAR_ARCHIVE})
local cv_last_height = CreateConVar("ttt2_resolution_last_height", 1080, {FCVAR_ARCHIVE})
local cv_scale = CreateConVar("ttt2_resolution_scale", 1.0, {FCVAR_ARCHIVE})

local cv_use_global_color = CreateConVar("ttt2_use_global_color", 0, {FCVAR_ARCHIVE})
local cv_global_color_r = CreateConVar("ttt2_global_color_r", "30", {FCVAR_ARCHIVE})
local cv_global_color_g = CreateConVar("ttt2_global_color_g", "160", {FCVAR_ARCHIVE})
local cv_global_color_b = CreateConVar("ttt2_global_color_b", "160", {FCVAR_ARCHIVE})
local cv_global_color_a = CreateConVar("ttt2_global_color_a", "160", {FCVAR_ARCHIVE})

GLAPP = GLAPP or {}
GLAPP.callbacks = {}

---
-- This function should be called when the resolution is updated. It
-- is needed to handle automatic scale setting of all UI elements
-- @param number width The new width
-- @param number height The new height
-- @internal
-- @realm client
function GLAPP.UpdateResolution(width, height)
	GLAPP.SetGlobalScale(GLAPP.GetGlobalScale() * width / GLAPP.GetLastWidth())

	cv_last_width:SetInt(width)
	cv_last_height:SetInt(height)
end

---
-- Returns the last stored screen width
-- @return number The last stored width
-- @realm client
function GLAPP.GetLastWidth()
	return cv_last_width:GetInt() or 0
end

---
-- Returns the last stored screen height
-- @return number The last stored height
-- @realm client
function GLAPP.GetLastHeight()
	return cv_last_height:GetInt() or 0
end

---
-- This function updates the global scale of all UI elements
-- @param number scale The scale as a floating point value
-- @realm client
function GLAPP.SetGlobalScale(scale)
	scale = math.Round(scale, 1)

	local oldScale = GLAPP.GetGlobalScale()

	if oldScale == scale then return end

	cv_scale:SetFloat(scale)

	for i = 1, #GLAPP.callbacks do
		GLAPP.callbacks[i](oldScale, scale)
	end
end

---
-- This function returns the current global scale
-- @return number The scale as a floating point value
function GLAPP.GetGlobalScale()
	return cv_scale:GetFloat() or 1.0
end

---
-- Registers a callback function that is called once the scale
-- is changed
function GLAPP.RegisterScaleChangeCallback(fn)
	GLAPP.callbacks[#GLAPP.callbacks + 1] = fn
end

---
-- Sets the focus color for the client
-- @param Color clr The new focus color
-- @realm client
function GLAPP.SetFocusColor(clr)
	cv_global_color_r:SetInt(clr.r)
	cv_global_color_g:SetInt(clr.g)
	cv_global_color_b:SetInt(clr.b)
	cv_global_color_a:SetInt(clr.a)
end

---
-- Returns the current focus color
-- @return Color The current focus color
-- @realm client
function GLAPP.GetFocusColor()
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
function GLAPP.SetUseGlobalFocusColor(state)
	cv_use_global_color:SetBool(state == nil and true or state)
end

---
-- Returns whether the global color should be used or not
-- @return boolean The color state
-- @realm client
function GLAPP.ShouldUseGlobalFocusColor()
	return cv_use_global_color:GetBool()
end

---
-- Helper function that returnes the correct color based on the
-- current global color settings
-- @param Color The color to validate
-- @return Color The validated color
-- @realm client
function GLAPP.ValidateFocusColor(clr)
	if GLAPP.ShouldUseGlobalFocusColor() then
		return GLAPP.GetFocusColor()
	else
		return clr
	end
end
