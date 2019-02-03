HUDELEMENT.Base = "old_ttt_element"

if CLIENT then

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

	function HUDELEMENT:Initialize()
		self:SetPos(MSTACK.margin - MSTACK.msg_width, MSTACK.margin)

		top_y = MSTACK.margin
		top_x = ScrW() - MSTACK.margin - MSTACK.msg_width
		text_height = draw.GetFontHeight(MSTACK.msgfont)

		base_spec = {
			font = MSTACK.msgfont,
			xalign = TEXT_ALIGN_CENTER,
			yalign = TEXT_ALIGN_TOP
		}
	end

	function HUDELEMENT:PerformLayout()
		top_x = ScrW() - self.pos.x
		top_y = self.pos.y

		text_height = draw.GetFontHeight(MSTACK.msgfont)
	end

	function HUDELEMENT:Draw()
		if next(MSTACK.msgs) == nil then return end -- fast empty check

		local running_y = top_y
		for k, item in pairs(MSTACK.msgs) do
			if item.time < CurTime() then
				if item.sounded == false then
					LocalPlayer():EmitSound(msg_sound, 80, 250)

					item.sounded = true
				end

				-- Apply move effects to y
				local y = running_y + MSTACK.margin + item.move_y

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

				local height = item.height

				-- Background box
				item.bg.a = math.Clamp(alpha, 0, item.bg.a_max)
				draw.RoundedBox(8, top_x, y, MSTACK.msg_width, height, item.bg)

				-- Text
				item.col.a = math.Clamp(alpha, 0, item.col.a_max)

				local spec = base_spec
				spec.color = item.col

				for i = 1, #item.text do
					spec.text = item.text[i]

					local tx = top_x + (MSTACK.msg_width * 0.5)
					local ty = y + MSTACK.margin + (i - 1) * (text_height + MSTACK.margin)
					spec.pos = {tx, ty}

					draw.TextShadow(spec, 1, alpha)
				end

				if alpha == 0 then
					MSTACK.msgs[k] = nil
				end

				running_y = y + height
			end
		end
	end

end
