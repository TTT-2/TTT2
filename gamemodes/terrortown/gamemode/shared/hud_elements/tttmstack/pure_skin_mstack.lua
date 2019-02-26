local base = "pure_skin_element"

DEFINE_BASECLASS(base)

HUDELEMENT.Base = base

if CLIENT then
	local draw = draw
	local math = math

	-- Constants for configuration
	local msg_sound = Sound("Hud.Hint")
	local base_text_display_options = {
		font = "DefaultBold",
		xalign = TEXT_ALIGN_LEFT,
		yalign = TEXT_ALIGN_TOP
	}

	local leftPad = 15
	local text_height = 0

	local top_y = 0
	local top_x = 0

	local staytime = 12
	local max_items = 8

	local fadein = 0.1
	local fadeout = 0.6
	local movespeed = 2

	local margin = 6
	local title_bottom_margin = 15
	local msg_width = 400
	local text_width = msg_width - margin * 3
	local pad = 7
	local msgfont = "DefaultBold"
	local imagedmsgfont = "DefaultBold"
	local imageSize = 64
	local imagePad = pad
	local imageMinHeight = imageSize + 2 * pad
	local imageSubWidth = imageSize + 2 * pad

	function HUDELEMENT:Initialize()
		local width = msg_width + leftPad

		self:RecalculateBasePos()
		self:SetSize(width, 80)

		BaseClass.Initialize(self)

		self.defaults.minWidth = 250
		self.defaults.resizeableX = true
		self.defaults.resizeableY = false

		base_text_display_options = {
			font = msgfont,
			xalign = TEXT_ALIGN_LEFT,
			yalign = TEXT_ALIGN_TOP
		}
	end

	function HUDELEMENT:RecalculateBasePos()
		local width = msg_width + leftPad

		top_y = margin
		top_x = ScrW() - margin - width

		self:SetBasePos(top_x, top_y)
	end

	function HUDELEMENT:PerformLayout()
		top_x = self.pos.x
		top_y = self.pos.y

		msg_width = self.size.w
		text_width = msg_width - margin * 3

		-- invalidate previous item size calculations
		for k, v in pairs(MSTACK.msgs) do
			v.ready = false
		end

		BaseClass.PerformLayout(self)
	end

	local function PrepareItem(item)
		if item.image then
			item.subWidth = imageSubWidth
		end

		item.text_spec = table.Copy(base_text_display_options)
		item.text_spec.font_height = draw.GetFontHeight(item.text_spec.font)
		item.text = MSTACK:WrapText(item.text, text_width - (item.subWidth or 0), item.text_spec.font)

		item.title_spec = table.Copy(base_text_display_options)
		item.title_spec.font = imagedmsgfont
		item.title_spec.font_height = draw.GetFontHeight(item.title_spec.font)

		if item.title then
			item.title = MSTACK:WrapText(item.title, text_width - (item.subWidth or 0), item.title_spec.font)
		else
			item.title = {}
		end

		-- Height depends on number of lines, which is equal to number of table
		-- elements of the wrapped item.text

		local item_height = #item.text * (item.text_spec.font_height + margin) - margin + pad * 2

		if #item.title > 0 then
			item_height = item_height + title_bottom_margin + #item.title * (item.title_spec.font_height + margin) - margin
		end

		if item.image then
			item_height = math.max(item_height, imageMinHeight)
		end

		item.move_y = -item_height
		item.height = item_height

		item.ready = true
	end

	function HUDELEMENT:Draw()
		if next(MSTACK.msgs) == nil then return end -- fast empty check

		local running_y = top_y
		for k, item in pairs(MSTACK.msgs) do
			if item.time < CurTime() then
				if not item.ready then
					PrepareItem(item)
				end

				if item.sounded == false then
					LocalPlayer():EmitSound(msg_sound, 80, 250)

					item.sounded = true
				end

				-- Apply move effects to y
				local y = running_y + margin + item.move_y

				item.move_y = (item.move_y < 0) and item.move_y + movespeed or 0

				local delta = item.time + staytime - CurTime()
				delta = delta / staytime -- pct of staytime left

				-- Hurry up if we have too many
				if k >= max_items then
					delta = delta * 0.5
				end

				local alpha = 255
				-- These somewhat arcane delta and alpha equations are from gmod's
				-- HUDPickup stuff
				if delta > 1 - fadein then
					alpha = math.Clamp((1.0 - delta) * (255 / fadein), 0, 255)
				elseif delta < fadeout then
					alpha = math.Clamp(delta * (255 / fadeout), 0, 255)
				end

				-- Background box
				item.bg.a = math.Clamp(alpha, 0, item.bg.a_max)

				self:DrawBg(top_x, y, msg_width + leftPad, item.height, item.bg)

				-- Text
				item.col.a = math.Clamp(alpha, 0, item.col.a_max)
				local tx = top_x + (item.subWidth or 0) + leftPad
				local ty = y + pad

				-- draw the title text
				local title_spec = item.title_spec
				title_spec.color = item.col

				for i = 1, #item.title do
					title_spec.text = item.title[i]
					title_spec.pos = {tx, ty}

					draw.TextShadow(title_spec, 1, alpha)

					ty = ty + title_spec.font_height + margin
				end

				-- draw the normal text
				local text_spec = item.text_spec
				text_spec.color = item.col

				if #item.title > 0 then
					ty = ty + title_bottom_margin - margin -- remove old margin used for new line set in for loop above
				end

				for i = 1, #item.text do
					text_spec.text = item.text[i]
					text_spec.pos = {tx, ty}

					draw.TextShadow(text_spec, 1, alpha)

					ty = ty + text_spec.font_height + margin
				end

				-- image
				if item.image then
					surface.SetMaterial(item.image)
					surface.SetDrawColor(255, 255, 255, item.bg.a)
					surface.DrawTexturedRect(top_x + imagePad, y + imagePad, imageSize, imageSize)
				end

				self:DrawLines(top_x, y, msg_width + leftPad, item.height, item.bg.a)

				if alpha == 0 then
					MSTACK.msgs[k] = nil
				end

				running_y = y + item.height
			end
		end
	end
end
