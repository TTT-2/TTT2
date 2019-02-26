local base = "old_ttt_element"

DEFINE_BASECLASS(base)

HUDELEMENT.Base = base

if CLIENT then
	local surface = surface
	local draw = draw
	local math = math

	-- Constants for configuration
	local msg_sound = Sound("Hud.Hint")
	local base_spec = {
		font = "DefaultBold",
		xalign = TEXT_ALIGN_CENTER,
		yalign = TEXT_ALIGN_TOP
	}

	local text_height = 0

	local top_y = 0
	local top_x = 0

	local staytime = 12
	local max_items = 8

	local fadein = 0.1
	local fadeout = 0.6
	local movespeed = 2

	local margin = 6
	local title_margin = 8
	local msg_width = 400
	local text_width = msg_width - margin * 3
	local pad = 7
	local msgfont = "DefaultBold"
	local imageSize = 64
	local imagePad = pad
	local imageMinHeight = imageSize + 2 * pad
	local imageSubWidth = imageSize + 2 * pad

	function HUDELEMENT:Initialize()
		local width = msg_width

		top_y = margin
		top_x = ScrW() - margin - width
		text_height = draw.GetFontHeight(msgfont)

		self:SetBasePos(top_x, top_y)
		self:SetSize(width, 80)

		base_spec = {
			font = msgfont,
			xalign = TEXT_ALIGN_CENTER,
			yalign = TEXT_ALIGN_TOP
		}

		BaseClass.Initialize(self)
	end

	function HUDELEMENT:PerformLayout()
		top_x = self.pos.x
		top_y = self.pos.y

		text_height = draw.GetFontHeight(msgfont)

		BaseClass.PerformLayout(self)
	end

	local function PrepareItem(item)
		if item.image then
			item.subWidth = imageSubWidth
		end

		item.text = MSTACK:WrapText(item.text, text_width - (item.subWidth or 0), msgfont)

		if item.title then
			item.title = MSTACK:WrapText(item.title, text_width - (item.subWidth or 0), msgfont)
		else
			item.title = {}
		end

		-- Height depends on number of lines, which is equal to number of table
		-- elements of the wrapped item.text
		local item_height = #item.text * text_height + margin * (1 + #item.text)
		if item.image then
			item_height = math.max(item_height, imageMinHeight)
		end

		if #item.title > 0 then
			item_height = item_height + title_margin + #item.title * text_height + margin * (1 + #item.title)
		end

		item.move_y = -item_height

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
				draw.RoundedBox(8, top_x, y, msg_width, item_height, item.bg)

				-- Text
				item.col.a = math.Clamp(alpha, 0, item.col.a_max)

				local spec = base_spec
				spec.color = item.col

				for i = 1, #item.title do
					spec.text = item.title[i]

					local tx = top_x + (msg_width - (item.subWidth or 0)) * 0.5 + (item.subWidth or 0)
					local ty = y + margin + (i - 1) * (text_height + margin)

					spec.pos = {tx, ty}

					draw.TextShadow(spec, 1, alpha)
				end

				for i = 1, #item.text do
					spec.text = item.text[i]

					local tx = top_x + (msg_width - (item.subWidth or 0)) * 0.5 + (item.subWidth or 0)
					local ty = y + margin + (i - 1) * (text_height + margin)

					if #item.title != 0 then
						ty = ty + title_margin + margin + #item.title * (text_height + margin)
					end

					spec.pos = {tx, ty}

					draw.TextShadow(spec, 1, alpha)
				end

				-- image
				if item.image then
					surface.SetMaterial(item.image)
					surface.SetDrawColor(255, 255, 255, item.bg.a)
					surface.DrawTexturedRect(top_x + imagePad, y + imagePad, imageSize, imageSize)
				end

				if alpha == 0 then
					MSTACK.msgs[k] = nil
				end

				running_y = y + item_height
			end
		end
	end
end
