-- item info
COLOR_DARKGREY = COLOR_DARKGREY or Color(100, 100, 100, 255)

local base = "pure_skin_element"

DEFINE_BASECLASS(base)

HUDELEMENT.Base = base

if CLIENT then
	local padding = 10
	local color_badstatus = Color(183, 54, 47)
	local color_goodstatus = Color(36, 115, 51)

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
		const_defaults["basepos"] = {
			x = self.padding,
			y = ScrH() * 0.5
		}

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

	function HUDELEMENT:DrawIcon(curY, item)
		local pos = self:GetPos()
		local size = self:GetSize()

		if not item.hud_color then
			item.hud_color = self.basecolor
		end

		local fontColor = util.GetDefaultColor(item.hud_color)
		local iconAlpha = fontColor.r > 60 and 175 or 250

		curY = curY - size.w

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

		local hud_icon = item.hud.GetTexture and item.hud or item.hud[item.active_icon]

		draw.FilteredShadowedTexture(pos.x, curY, size.w, size.w, hud_icon, iconAlpha, fontColor, self.scale)

		self:DrawLines(pos.x, curY, size.w, size.w, item.hud_color.a * factor)

		if isfunction(item.DrawInfo) then
			local info = item:DrawInfo()
			if info then
				-- right bottom corner
				local tx = pos.x + size.w - 5
				local ty = curY +  size.w - 1
				local pad = 5 * self.scale

				surface.SetFont("PureSkinItemInfo")

				local infoW, infoH = surface.GetTextSize(info)
				infoW = infoW * self.scale
				infoH = (infoH + 2) * self.scale

				local bx = tx - infoW * 0.5 - pad
				local by = ty - infoH * 0.5
				local bw = infoW + pad * 2

				self:DrawBg(bx, by, bw, infoH, item.hud_color)

				draw.AdvancedText(info, "PureSkinItemInfo", tx, ty, fontColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, false, self.scale)

				self:DrawLines(bx, by, bw, infoH, item.hud_color.a)
			end
		end

		return curY - self.padding
	end

	function HUDELEMENT:Draw()
		local client = LocalPlayer()

		local basepos = self:GetBasePos()
		local itms = client:GetEquipmentItems()

		-- get number of new icons
		local num_icons = 0
		local num_items = 0

		for i = 1, #itms do
			local item = items.GetStored(itms[i])

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

		local linespace = ((num_status > 0) and (num_items > 0)) and 25 or 0
		local height = math.max(num_icons, 1) * self.size.w + math.max(num_icons -1, 0) * ((num_icons > 1) and self.padding or 0) + linespace
		local startY = basepos.y + 0.5 * self.size.w + 0.5 * height
		local curY = startY

		-- draw status
		for _, status in pairs(STATUS.active) do
			if status.type == "bad" then
				status.hud_color = color_badstatus
			end

			if status.type == "good" then
				status.hud_color = color_goodstatus
			end

			if status.type == "default" then
				status.hud_color = Color(self.basecolor.r, self.basecolor.g, self.basecolor.b)
			end

			-- fallback
			if status.type == nil and status.hud_color == nil then
				status.hud_color = Color(self.basecolor.r, self.basecolor.g, self.basecolor.b)
			end

			curY = self:DrawIcon(curY, status)
		end

		-- draw spacer
		if num_status > 0 and num_items > 0 then
			curY = curY - 16

			local pos = self:GetPos()
			local size = self:GetSize()

			surface.SetDrawColor(self.basecolor)
			surface.DrawRect(pos.x, curY + self.padding * 0.5 + 8, size.w, 2)
		end

		-- draw items
		for i = 1, #itms do
			local item = items.GetStored(itms[i])
			if not item or not item.hud then continue end

			item.hud_color = Color(self.basecolor.r, self.basecolor.g, self.basecolor.b)
			curY = self:DrawIcon(curY, item)
		end

		self:SetSize(self.size.w, - math.max(height, self.minsize.h)) -- adjust the size
		self:SetPos(basepos.x, startY - height)
	end
end
