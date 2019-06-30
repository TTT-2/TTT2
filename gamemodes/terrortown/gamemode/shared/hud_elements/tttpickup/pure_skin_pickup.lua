local draw = draw
local surface = surface
local math = math
local IsValid = IsValid
local TryTranslation = LANG.TryTranslation

local base = "base_stacking_element"

DEFINE_BASECLASS(base)

HUDELEMENT.Base = base

if CLIENT then
	local width = 200
	local elemheight = 20
	local font = "DefaultBold"
	local bordersize = 8
	local tipsize = elemheight - 4
	local margin = 10
	local pad = 8

	HUDELEMENT.barcorner = surface.GetTextureID("gui/corner8")
	HUDELEMENT.PickupHistoryTop = ScrH() / 2

	local const_defaults = {
		basepos = {x = 0, y = 0},
		size = {w = width, h = -elemheight},
		minsize = {w = width, h = elemheight}
	}

	function HUDELEMENT:PreInitialize()
		self.drawer = hudelements.GetStored("pure_skin_element")
	end

	function HUDELEMENT:Initialize()
		self.scale = 1.0
		self.basecolor = self:GetHUDBasecolor()
		self.elemheight = elemheight * self.scale
		self.margin = margin * self.scale
		self.pad = pad * self.scale
		self.bordersize = bordersize * self.scale
		self.tipsize = tipsize * self.scale

		BaseClass.Initialize(self)
	end

	function HUDELEMENT:IsResizable()
		return true, false
	end

	function HUDELEMENT:GetDefaults()
		const_defaults["basepos"] = {x = ScrW() - self.size.w - self.margin * 2, y = ScrH() / 2}

		return const_defaults
	end

	function HUDELEMENT:PerformLayout()
		self.scale = self:GetHUDScale()
		self.basecolor = self:GetHUDBasecolor()
		self.elemheight = elemheight * self.scale
		self.margin = margin * self.scale
		self.pad = pad * self.scale
		self.bordersize = bordersize * self.scale
		self.tipsize = tipsize * self.scale

		BaseClass.PerformLayout(self)
	end


	function HUDELEMENT:DrawBar(x, y, w, h, alpha, item)

		local barColor = Color(self.basecolor.r, self.basecolor.g, self.basecolor.b, alpha)
		draw.RoundedBox(self.bordersize, x, y, w, h, barColor)

		surface.SetTexture(self.barcorner)

		surface.SetDrawColor(item.color.r, item.color.g, item.color.b, alpha)
		surface.DrawTexturedRectRotated(x + self.bordersize * 0.5, y + self.bordersize * 0.5, self.bordersize, self.bordersize, 0)
		surface.DrawTexturedRectRotated(x + self.bordersize * 0.5, y + h - self.bordersize * 0.5, self.bordersize, self.bordersize, 90)
		surface.DrawRect(x, y + self.bordersize, self.bordersize, h - self.bordersize * 2)
		surface.DrawRect(x + self.bordersize, y, self.tipsize, h)

		draw.SimpleText(item.name, font, x + self.tipsize + self.bordersize + self.pad + 2, y + h * 0.5 + 2, Color(0, 0, 0, alpha * 0.75), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		draw.SimpleText(item.name, font, x + self.tipsize + self.bordersize + self.pad, y + h * 0.5, Color(255, 255, 255, alpha), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

		if item.amount then
			draw.SimpleText(item.amount, font, x + w - self.pad, y + h * 0.5 + 2, Color(0, 0, 0, alpha * 0.75), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
			draw.SimpleText(item.amount, font, x + w - self.pad, y + h * 0.5, Color(255, 255, 255, alpha), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
		end
	end

	function HUDELEMENT:ShouldDraw()
		return PICKUP.items ~= nil or HUDEditor.IsEditing
	end

	function HUDELEMENT:Draw()
		local pickupList = {}

		for k, v in pairs(PICKUP.items) do
			if v.time < CurTime() then
				table.insert(pickupList, {h = self.elemheight})
			end
		end

		self:SetElements(pickupList)
		self:SetElementMargin(self.margin)

		BaseClass.Draw(self)

		PICKUP.RemoveOutdatedValues()
	end

	function HUDELEMENT:DrawElement(i, x, y, w, h)	
		local item = PICKUP.items[i]

		local alpha = 255
		local delta = (item.time + item.holdtime - CurTime()) / item.holdtime
		local colordelta = math.Clamp(delta, 0.6, 0.7)

		if delta > 1 - item.fadein then
			alpha = math.Clamp((1.0 - delta) * (255 / item.fadein), 1, 255)
		elseif delta < item.fadeout then
			alpha = math.Clamp(delta * (255 / item.fadeout), 0, 255)
		end

		local shiftX = x + w - self.size.w * (alpha / 255)

		self:DrawBar(shiftX, y, w, h, alpha, item)

		--mark item for removal
		if alpha == 0 then
			item.remove = true
		end
	end
end
