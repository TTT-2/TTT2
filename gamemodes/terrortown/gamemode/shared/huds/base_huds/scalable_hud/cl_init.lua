local base = "hud_base"
local defaultColor = Color(49, 71, 94)
local defaultScale = 1.0

local savingKeys

DEFINE_BASECLASS(base)

HUD.Base = base
HUD.basecolor = defaultColor
HUD.scale = defaultScale

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
				--local scaleMultiplier = val / self.scale
				self.scale = val

				self:Reset()
				self:SaveData()
			end
		}
	end

	return table.Copy(savingKeys)
end

function HUD:LoadData()
	BaseClass.LoadData(self)

	for _, elem in ipairs(self:GetElements()) do
		local el = hudelements.GetStored(elem)
		if el then
			local min_size = el:GetDefaults().minsize

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
			el:PerformLayout()

			--reset position to new calculated default position
			local defaultPos = el:GetDefaults().basepos

			el:SetBasePos(defaultPos.x, defaultPos.y)
			el:PerformLayout()
		end
	end
end

function HUD:Reset()
	self.basecolor = defaultColor
	
	BaseClass.Reset(self)

	self:ApplyScale(self.scale)
end
