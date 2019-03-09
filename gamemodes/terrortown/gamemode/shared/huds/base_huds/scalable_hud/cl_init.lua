local surface = surface

local base = "hud_base"

DEFINE_BASECLASS(base)

HUD.Base = base

local defaultColor = Color(49, 71, 94)
local defaultScale = 1.0

local savingKeys

function HUD:GetSavingKeys()
	if not savingKeys then
		savingKeys = BaseClass.GetSavingKeys(self)
		savingKeys.basecolor = {
			typ = "color",
			desc = "BaseColor",
			OnChange = function(slf, col) 
				self:PerformLayout()
			end
		}
		savingKeys.scale = {
			typ = "scale",
			desc = "Reset Positions and set HUD Scale",
			OnChange = function(slf, val)
				local scaleMultiplier = val / self.scale
				self:ApplyScale(scaleMultiplier)
				self:SaveData()
			end	
		}
	end

	return table.Copy(savingKeys)
end

HUD.basecolor = defaultColor
HUD.scale = defaultScale

function HUD:Loaded()
	for _, elem in ipairs(self:GetElements()) do
		local el = hudelements.GetStored(elem)
		if el then
			local min_size = el.defaults.minsize
			el:SetMinSize(min_size.w * self.scale, min_size.h * self.scale)
			el:PerformLayout()
		end
	end
end

function HUD:ApplyScale(scale)
	for _, elem in ipairs(self:GetElements()) do
		local el = hudelements.GetStored(elem)
		if el then
			local size = el:GetSize()
			local min_size = el:GetMinSize()
			el:SetMinSize(min_size.w * scale, min_size.h * scale)
			el:SetSize(size.w * scale, size.h * scale)
			el:PerformLayout()      --code from here will be replaced by a Reset call
			el:RecalculateBasePos()
			el:PerformLayout()
		end
	end
end

function HUD:Reset()
	self.basecolor = defaultColor
	BaseClass.Reset(self)

	self:ApplyScale(self.scale)
end