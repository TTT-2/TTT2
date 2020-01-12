local draw = draw
local surface = surface
local math = math

local base = "base_stacking_element"

DEFINE_BASECLASS(base)

HUDELEMENT.Base = base

if CLIENT then
	local width = 200
	local element_height = 27
	local font = "PureSkinMSTACKMsg"
	local tipsize = element_height
	local margin = 5
	local pad = 8
	local color_tip = Color(205, 155, 0, 255)

	HUDELEMENT.SlotIcons = {[WEAPON_HEAVY] = Material("vgui/ttt/pickup/icon_heavy.png"),
		[WEAPON_PISTOL] = Material("vgui/ttt/pickup/icon_pistol.png"),
		[WEAPON_NADE] = Material("vgui/ttt/pickup/icon_nades.png"),
		[WEAPON_SPECIAL] = Material("vgui/ttt/pickup/icon_special.png"),
		[WEAPON_EXTRA] = Material("vgui/ttt/pickup/icon_extra.png"),
		[WEAPON_CLASS] = Material("vgui/ttt/pickup/icon_class.png")
	}

	HUDELEMENT.icon_item = Material("vgui/ttt/pickup/icon_special.png")
	HUDELEMENT.icon_ammo = Material("vgui/ttt/pickup/icon_ammo.png")

	local const_defaults = {
		basepos = {x = 0, y = 0},
		size = {w = width, h = -element_height},
		minsize = {w = width, h = element_height}
	}

	function HUDELEMENT:PreInitialize()
		self.drawer = hudelements.GetStored("pure_skin_element")
	end

	function HUDELEMENT:Initialize()
		self.scale = 1.0
		self.basecolor = self:GetHUDBasecolor()
		self.element_height = element_height * self.scale
		self.margin = margin * self.scale
		self.pad = pad * self.scale
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
		self.element_height = element_height * self.scale
		self.margin = margin * self.scale
		self.pad = pad * self.scale
		self.tipsize = tipsize * self.scale

		BaseClass.PerformLayout(self)
	end

	function HUDELEMENT:DrawBar(x, y, w, h, alpha, item)

		-- draw bg and shadow
		local barColor = Color(self.basecolor.r, self.basecolor.g, self.basecolor.b, alpha)
		self.drawer:DrawBg(x, y, w, h, barColor)

		--draw tip
		local tipColor = COLOR_WHITE
		local icon = self.icon_item

		if item.type == PICKUP_WEAPON then
			tipColor = LocalPlayer():GetRoleColor()
			icon = self.SlotIcons[item.kind] or self.icon_item
		elseif item.type == PICKUP_AMMO then
			tipColor = color_tip
			icon = self.icon_ammo
		end

		-- Draw the colour tip
		surface.SetDrawColor(tipColor.r, tipColor.g, tipColor.b, alpha)
		surface.DrawRect(x, y, self.tipsize, h)

		--draw icon
		draw.FilteredShadowedTexture(x, y, h, h, icon, math.Round(alpha * 0.75), util.GetDefaultColor(tipColor), self.scale)

		-- draw lines around the element
		self.drawer:DrawLines(x, y, w, h, alpha)

		--draw name text
		local fontColor = util.GetDefaultColor(self.basecolor)
		fontColor = Color(fontColor.r, fontColor.g, fontColor.b, alpha)

		draw.AdvancedText(item.name, font, x + self.tipsize + self.pad, y + h * 0.5, fontColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, true, self.scale)

		--draw amount text
		if item.amount then
			draw.AdvancedText(item.amount, font, x + w - self.pad, y + h * 0.5, fontColor, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER, true, self.scale)
		end
	end

	function HUDELEMENT:ShouldDraw()
		return PICKUP.items ~= nil or HUDEditor.IsEditing
	end

	function HUDELEMENT:Draw()
		local pickupList = {}
		local i = 0

		for k, v in pairs(PICKUP.items) do
			if v.time < CurTime() then
				i = i + 1

				pickupList[i] = {h = self.element_height}
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
