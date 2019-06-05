-- item info
COLOR_DARKGREY = COLOR_DARKGREY or Color(100, 100, 100, 255)

local base = "pure_skin_element"

DEFINE_BASECLASS(base)

HUDELEMENT.Base = base

if CLIENT then
	surface.CreateFont("ItemInfoFont", {font = "Trebuchet24", size = 14, weight = 700})

	local padding = 10

	local const_defaults = {
		basepos = {x = 0, y = 0},
		size = {w = 48, h = 48},
		minsize = {w = 48, h = 48}
	}

	function HUDELEMENT:Initialize()
		self.scale = 1.0
		self.basecolor = self:GetHUDBasecolor()
		self.padding = padding

		BaseClass.Initialize(self)
	end

	-- parameter overwrites
	function HUDELEMENT:IsResizable()
		return false, false
	end
	-- parameter overwrites end

	function HUDELEMENT:GetDefaults()
		const_defaults["basepos"] = {x = self.padding, y = ScrH() * 0.5}

		return const_defaults
	end

	function HUDELEMENT:PerformLayout()
		self.scale = self:GetHUDScale()
		self.basecolor = self:GetHUDBasecolor()
		self.padding = padding * self.scale

		BaseClass.PerformLayout(self)
	end

	function HUDELEMENT:ShouldDraw()
		local client = LocalPlayer()

		return client:Alive() or client:Team() == TEAM_TERROR
	end

	function HUDELEMENT:DrawItem(curY, item)
		local pos = self:GetPos()
		local size = self:GetSize()

		if item.hud_color == nil then item.hud_color = self.basecolor end

		curY = curY - (size.w + self.padding)

		local factor = 1
		if item.displaytime then -- start blinking in last 5 seconds
			local time_left = item.displaytime - CurTime()

			if time_left < 5 then
				local num = 0.5 * math.pi + (-1.4 * time_left + 7) * math.pi
				factor = 0.5 * (math.sin(num) + 1)
			end
		end

		surface.SetDrawColor(item.hud_color.r, item.hud_color.g, item.hud_color.b, math.Round(factor * 255))
		surface.DrawRect(pos.x, curY, size.w, size.w)

		util.DrawFilteredTexturedRect(pos.x, curY, size.w, size.w, item.hud, 175)

		self:DrawLines(pos.x, curY, size.w, size.w, item.hud_color.a * factor)

		if isfunction(item.DrawInfo) then
			local info = item:DrawInfo()
			if info then
				-- right bottom corner
				local tx = pos.x + size.w - 5
				local ty = curY +  size.w - 2
				local pad = 5 * self.scale

				surface.SetFont("ItemInfoFont")

				local infoW, infoH = surface.GetTextSize(info)
				infoW = infoW * self.scale
				infoH = (infoH + 2) * self.scale

				local bx = tx - infoW * 0.5 - pad
				local by = ty - infoH * 0.5
				local bw = infoW + pad * 2

				self:DrawBg(bx, by, bw, infoH, item.hud_color)

				self:AdvancedText(info, "ItemInfoFont", tx, ty, self:GetDefaultFontColor(item.hud_color), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, false, self.scale)

				self:DrawLines(bx, by, bw, infoH, item.hud_color.a)
			end
		end

		return curY
	end

	function HUDELEMENT:Draw()
		local client = LocalPlayer()

		local basepos = self:GetBasePos()
		local itms = client:GetEquipmentItems()

		-- get number of new icons
		local num_icons = 0

		local num_items = 0
		for _, itemCls in ipairs(itms) do
			local item = items.GetStored(itemCls)

			if item and item.hud then
				num_items = num_items + 1
			end
		end
		num_icons = num_icons + num_items

		local num_status = 0
		for _, status in pairs(STATUS.active) do
			num_status = num_status + 1
		end
		num_icons = num_icons + num_status

		local curY = basepos.y + 0.5 * ( (num_icons -1) * (self.size.w + self.padding) + ((num_status > 0) and 25 or 0))

		-- draw status
		for _, status in pairs(STATUS.active) do
			if status.type == 'bad' then
				status.hud_color = Color(183, 54, 47)
			end
			curY = self:DrawItem(curY, status)
		end

		-- draw spacer
		if num_status > 0 and num_items > 0 then
			curY = curY - 16
			local pos = self:GetPos()
			local size = self:GetSize()
			surface.SetDrawColor(self.basecolor)
			surface.DrawRect(pos.x, curY - self.padding * 0.5 + 8, size.w, 2)
		end
		
		-- draw items
		for _, itemCls in ipairs(itms) do
			local item = items.GetStored(itemCls)

			if item and item.hud then
				item.hud_color = self.basecolor
				curY = self:DrawItem(curY, item)
			end
		end

		self:SetSize(self.size.w, - math.max(basepos.y - curY, self.minsize.h)) -- adjust the size
	end
end
