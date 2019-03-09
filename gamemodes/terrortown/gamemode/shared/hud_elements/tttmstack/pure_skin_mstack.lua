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

	local leftPad_default = 14

	local margin_default = 5
	local line_margin_default = 6
	local top_margin_default = 4
	local title_bottom_margin_default = 8
	local msg_width_default = 400

	local pad_default = 6
	local leftImagePad_default = 10

	local imageSize_default = 64

	local leftPad = leftPad_default

	local top_y = 0
	local top_x = 0

	local staytime = 12
	local max_items = 8

	local fadein = 0.1
	local fadeout = 0.6
	local movespeed = 2

	local margin = margin_default
	local line_margin = line_margin_default
	local top_margin = top_margin_default
	local title_bottom_margin = title_bottom_margin_default
	local msg_width = msg_width_default
	local pad = pad_default
	local leftImagePad = leftImagePad_default
	local text_width = msg_width - pad * 2 - leftPad
	local msgfont = "PureSkinMSTACKMsg"
	local imagedmsgfont = "PureSkinMSTACKImageMsg"
	local text_color = COLOR_WHITE
	local imageSize = imageSize_default
	local imageMinHeight = imageSize + 2 * pad
	local min_w, min_h = 250, 80

	local const_defaults = {
						basepos = {x = 0, y = 0},
						size = {w = 400, h = 80},
						minsize = {w = 250, h = 80}
	}

	function HUDELEMENT:Initialize()
		msg_width = msg_width_default
		margin = margin_default
		self.scale = 1.0
		self.basecolor = self:GetHUDBasecolor()

		local defaults = self:GetDefaults()

		self:SetBasePos(defaults.basepos.x, defaults.basepos.y)
		self:SetMinSize(defaults.size.w, defaults.size.h)
		self:SetSize(defaults.minsize.w, defaults.minsize.h)

		base_text_display_options = {
			font = msgfont,
			xalign = TEXT_ALIGN_LEFT,
			yalign = TEXT_ALIGN_TOP
		}

		BaseClass.Initialize(self)
	end

	-- parameter overwrites
	function HUDELEMENT:IsResizable()
		return true, false
	end
	-- parameter overwrites end

	function HUDELEMENT:GetDefaults()
		const_defaults["basepos"] = { x = ScrW() - margin - msg_width, y = margin}
		return const_defaults
 	end

	function HUDELEMENT:PerformLayout()
		top_x = self.pos.x
		top_y = self.pos.y

		self.scale = self:GetHUDScale()
		self.basecolor = self:GetHUDBasecolor()

		leftPad = leftPad_default * self.scale
		margin = margin_default * self.scale
		line_margin = line_margin_default * self.scale
		top_margin = top_margin_default * self.scale
		title_bottom_margin = title_bottom_margin_default * self.scale
		pad = pad_default * self.scale
		leftImagePad = leftImagePad_default * self.scale
		imageSize = imageSize_default * self.scale
		imageMinHeight = imageSize + 2 * pad

		msg_width = self.size.w
		text_width = msg_width - pad * 2 - leftPad

		-- invalidate previous item size calculations
		for _, v in pairs(MSTACK.msgs) do
			v.ready = false
		end

		BaseClass.PerformLayout(self)
	end

	local function PrepareItem(item, bg_color)
		local max_text_width = (msg_width - pad * 2 - leftPad) / item.scale
		local item_height = pad * 2

		item.text_spec = table.Copy(base_text_display_options)

		item.bg = item.bg and table.Copy(item.bg) or table.Copy(bg_color)
		item.bg.a_max = item.bg.a

		item.col = item.col and table.Copy(item.col) or table.Copy(text_color)
		item.col.a_max = item.col.a

		if item.image then
			max_text_width = (text_width - leftImagePad - imageSize) / item.scale
			item.text_spec.font = imagedmsgfont
			item.title_spec = table.Copy(base_text_display_options)
			item.title_spec.font = imagedmsgfont
			item.title_spec.font_height = draw.GetFontHeight(item.title_spec.font) * item.scale

			item.title_wrapped = item.title and MSTACK:WrapText(item.title, max_text_width, item.title_spec.font) or {}
			-- calculate the new height
			item_height = item_height + top_margin + title_bottom_margin + #item.title_wrapped * (item.title_spec.font_height + line_margin) - line_margin
		end

		item.text_spec.font_height = draw.GetFontHeight(item.text_spec.font) * item.scale

		item.text_wrapped = MSTACK:WrapText(item.text, max_text_width, item.text_spec.font)

		-- Height depends on number of lines, which is equal to number of table
		-- elements of the wrapped item.text
		item_height = item_height + #item.text_wrapped * (item.text_spec.font_height + line_margin) - line_margin

		if item.image then
			item_height = math.max(item_height, imageMinHeight)
		end

		item.move_y = -item_height
		item.height = item_height

		item.ready = true
	end

	function HUDELEMENT:DrawSmallMessage(item, pos_y, alpha)
		-- Background box
		self:DrawBg(top_x, pos_y, msg_width, item.height, item.bg)

		-- Text
		local tx = top_x + pad + leftPad
		local ty = pos_y + pad

		-- draw the normal text
		local text_spec = item.text_spec
		text_spec.color = item.col

		for i = 1, #item.text_wrapped do
			text_spec.text = item.text_wrapped[i]
			text_spec.pos = {tx, ty}

			--draw.TextShadow(text_spec, 1, alpha)
			self:AdvancedText(text_spec.text, text_spec.font, text_spec.pos[1], text_spec.pos[2], text_spec.color, text_spec.xalign, text_spec.yalign, true, self.scale)

			ty = ty + text_spec.font_height + line_margin
		end

		self:DrawLines(top_x, pos_y, msg_width, item.height, item.bg.a)
	end

	function HUDELEMENT:DrawMessageWithImage(item, pos_y, alpha)
		-- Background box
		self:DrawBg(top_x, pos_y, msg_width, item.height, item.bg)

		-- Text
		local tx = top_x + imageSize + pad + leftImagePad
		local ty = pos_y + pad + top_margin

		-- draw the title text
		local title_spec = item.title_spec
		title_spec.color = item.col

		for i = 1, #item.title_wrapped do
			title_spec.text = item.title_wrapped[i]
			title_spec.pos = {tx, ty}

			--draw.TextShadow(title_spec, 1, alpha)
			self:AdvancedText(title_spec.text, title_spec.font, title_spec.pos[1], title_spec.pos[2], title_spec.color, title_spec.xalign, title_spec.yalign, true, self.scale)

			ty = ty + title_spec.font_height + line_margin
		end

		ty = ty + title_bottom_margin - line_margin -- remove old margin used for new line set in for loop above

		-- draw the normal text
		local text_spec = item.text_spec
		text_spec.color = item.col

		for i = 1, #item.text_wrapped do
			text_spec.text = item.text_wrapped[i]
			text_spec.pos = {tx, ty}

			--draw.TextShadow(text_spec, 1, alpha)
			self:AdvancedText(text_spec.text, text_spec.font, text_spec.pos[1], text_spec.pos[2], text_spec.color, text_spec.xalign, text_spec.yalign, true, self.scale)

			ty = ty + text_spec.font_height + line_margin
		end

		-- image
		surface.SetMaterial(item.image)
		surface.SetDrawColor(255, 255, 255, item.bg.a)
		surface.DrawTexturedRect(top_x + pad, pos_y + pad, imageSize, imageSize)

		self:DrawLines(top_x, pos_y, msg_width, item.height, item.bg.a)
	end

	function HUDELEMENT:ShouldDraw()
		return next(MSTACK.msgs) ~= nil
	end

	function HUDELEMENT:Draw()
		local running_y = top_y
		for k, item in pairs(MSTACK.msgs) do
			if item.time < CurTime() then
				if not item.ready then
					item.scale = self.scale

					PrepareItem(item, self.basecolor)
				end

				if item.sounded == false then
					LocalPlayer():EmitSound(msg_sound, 80, 250)

					item.sounded = true
				end

				-- Apply move effects to y
				local y = running_y + line_margin + item.move_y

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

				item.bg.a = math.Clamp(alpha, 0, item.bg.a_max)
				item.col.a = math.Clamp(alpha, 0, item.col.a_max)

				if item.image then
					self:DrawMessageWithImage(item, y, alpha)
				else
					self:DrawSmallMessage(item, y, alpha)
				end

				if alpha == 0 then
					MSTACK.msgs[k] = nil
				end

				running_y = y + item.height
			end
		end
	end
end
