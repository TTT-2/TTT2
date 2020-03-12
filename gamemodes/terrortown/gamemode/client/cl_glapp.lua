---
-- A global appearance handler
-- @author Mineotopia

local cv_use_global_color = CreateConVar("ttt2_use_global_color", 0, true)
local cv_global_color_r = CreateConVar("ttt2_global_color_r", "30", true)
local cv_global_color_g = CreateConVar("ttt2_global_color_g", "160", true)
local cv_global_color_b = CreateConVar("ttt2_global_color_b", "160", true)

GLAPP = GLAPP or {}

function GLAPP.SetGlobalScale(scale)

end

function GLAPP.GetGlobalScale()

end

function GLAPP.SetFocusColor(clr)
	cv_global_color_r:SetInt(clr.r)
	cv_global_color_g:SetInt(clr.g)
	cv_global_color_b:SetInt(clr.b)
end

function GLAPP.GetFocusColor()
	return Color(
		cv_global_color_r:GetInt(),
		cv_global_color_g:GetInt(),
		cv_global_color_b:GetInt()
	)
end

function GLAPP.SetUseGlobalColor(state)
	cv_use_global_color:GetBool(state == nil and true or false)
end

function GLAPP.ShouldUseGlobalColor()
	return cv_use_global_color:GetBool()
end
