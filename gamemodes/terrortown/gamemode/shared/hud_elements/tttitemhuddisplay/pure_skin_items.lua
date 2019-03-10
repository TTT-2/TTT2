-- item info
COLOR_DARKGREY = COLOR_DARKGREY or Color(100, 100, 100, 255)

local base = "pure_skin_element"

DEFINE_BASECLASS(base)

HUDELEMENT.Base = base

if CLIENT then
	surface.CreateFont("ItemInfoFont", {font = "Trebuchet24", size = 14, weight = 700})

	local const_defaults = {
						basepos = {x = 0, y = 0},
						size = {w = 64, h = 64},
						minsize = {w = 64, h = 64}
	}

	function HUDELEMENT:Initialize()
		self.scale = 1.0

		BaseClass.Initialize(self)
	end

	-- parameter overwrites
	function HUDELEMENT:IsResizable()
		return false, false
	end
	-- parameter overwrites end

	function HUDELEMENT:GetDefaults()
		const_defaults["basepos"] = { x = 20 * self.scale, y = ScrH() * 0.5}
		return const_defaults
 	end

	function HUDELEMENT:PerformLayout()
		local basepos = self:GetBasePos()

		self.scale = self:GetHUDScale()

		self:SetPos(basepos.x, basepos.y)
		self:SetSize(self.size.w, -self.size.w)

		BaseClass.PerformLayout(self)
	end

	function HUDELEMENT:ShouldDraw()
		local client = LocalPlayer()

		return client:Alive() or client:Team() == TEAM_TERROR 
	end

	function HUDELEMENT:Draw()
		local client = LocalPlayer()

		local basepos = self:GetBasePos()
		local itms = client:GetEquipmentItems()
		local pos = self:GetPos()
		local curY = basepos.y
		
		-- at first, calculate old items because they don't take care of the new ones
		for _, itemCls in ipairs(itms) do
			local item = items.GetStored(itemCls)
			if item and item.oldHud then
				curY = curY - 80
			end
		end

		-- now draw our new items automatically
		for _, itemCls in ipairs(itms) do
			local item = items.GetStored(itemCls)
			if item and item.hud then
				curY = curY - (self.size.w + self.size.w* 0.25)

				surface.SetDrawColor(36, 115, 51, 255)
				surface.DrawRect(pos.x, curY, self.size.w, self.size.w)

				surface.SetMaterial(item.hud)
				surface.SetDrawColor(255, 255, 255, 255)
				surface.DrawTexturedRect(pos.x, curY, self.size.w, self.size.w)

				self:DrawLines(pos.x, curY, self.size.w, self.size.w, 255)

				if isfunction(item.DrawInfo) then
					local info = item:DrawInfo()
					if info then
						-- right bottom corner
						local tx = pos.x + self.size.w
						local ty = curY + self.size.w
						local pad = 5 * self.scale

						surface.SetFont("ItemInfoFont")

						local infoW, infoH = surface.GetTextSize(info)
						infoW = infoW * self.scale
						infoH = infoH * self.scale

						local bx = tx - infoW * 0.5 - pad
						local by = ty - infoH * 0.5
						local bw = infoW + pad * 2

						self:DrawBg(bx, by, bw, infoH, COLOR_DARKGREY)

						self:AdvancedText(info, "ItemInfoFont", tx, ty, COLOR_WHITE, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, false, self.scale)

						self:DrawLines(bx, by, bw, infoH, 255)
					end
				end
			end
		end

		self:SetSize(self.size.w, - math.max(basepos.y - curY, self.minsize.h)  ) -- adjust the size
	end
end
