-- item info
COLOR_DARKGREY = COLOR_DARKGREY or Color(100, 100, 100, 255)

local base = "pure_skin_element"

DEFINE_BASECLASS(base)

HUDELEMENT.Base = base

if CLIENT then
	surface.CreateFont("ItemInfoFont", {font = "Trebuchet24", size = 14, weight = 700})

	local size_default = 48
	local size = size_default

	function HUDELEMENT:Initialize()
		size = size_default
		self.scale = 1.0
		self.padding = 10
		
		self:RecalculateBasePos()

		self:SetMinSize(size, size)
		self:SetSize(size, -size)

		BaseClass.Initialize(self)
	end

	-- parameter overwrites
	function HUDELEMENT:IsResizable()
		return false, false
	end
	-- parameter overwrites end

	function HUDELEMENT:RecalculateBasePos()
		self:SetBasePos(self.padding * self.scale, ScrH() * 0.5)
	end

	function HUDELEMENT:PerformLayout()
		local basepos = self:GetBasePos()

		size = size_default * self.scale

		self:SetPos(basepos.x, basepos.y)
		self:SetSize(size, -size)

		BaseClass.PerformLayout(self)
	end

	function HUDELEMENT:Draw()
		local client = LocalPlayer()

		if not client:Alive() or client:Team() ~= TEAM_TERROR then return end

		local basepos = self:GetBasePos()
		local itms = client:GetEquipmentItems()
		local pos = self:GetPos()

		-- get number of new icons
		local num_icons = 0
		for _, itemCls in ipairs(itms) do
			local item = items.GetStored(itemCls)
			if item and item.hud then
				num_icons = num_icons + 1
			end
		end

		local curY = basepos.y + 0.5 * (num_icons -1) * (size + self.padding)
		
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
				curY = curY - (size + self.padding)

				surface.SetDrawColor(36, 115, 51, 255)
				surface.DrawRect(pos.x, curY, size, size)

				util.DrawFilteredTexturedRect(pos.x, curY, size, size, item.hud, 175)

				self:DrawLines(pos.x, curY, size, size, self.basecolor.a)

				if isfunction(item.DrawInfo) then
					local info = item:DrawInfo()
					if info then
						-- right bottom corner
						local tx = pos.x + size -5
						local ty = curY + size -2
						local pad = 5 * self.scale

						surface.SetFont("ItemInfoFont")

						local infoW, infoH = surface.GetTextSize(info)
						infoW = infoW * self.scale
						infoH = (infoH + 2) * self.scale

						local bx = tx - infoW * 0.5 - pad
						local by = ty - infoH * 0.5
						local bw = infoW + pad * 2

						self:DrawBg(bx, by, bw, infoH, self.basecolor)

						self:AdvancedText(info, "ItemInfoFont", tx+2, ty+2, COLOR_BLACK, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, false, self.scale)
						self:AdvancedText(info, "ItemInfoFont", tx, ty, COLOR_WHITE, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, false, self.scale)

						self:DrawLines(bx, by, bw, infoH, self.basecolor.a)
					end
				end
			end
		end

		self:SetSize(size, - ( basepos.y - curY ) ) -- adjust the size
	end
end
