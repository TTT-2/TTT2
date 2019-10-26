local base = "pure_skin_element"

DEFINE_BASECLASS(base)

HUDELEMENT.Base = base

if CLIENT then
	local const_defaults = {
		basepos = {x = 0, y = 0},
		size = {w = 1000, h = 86},
		minsize = {w = 500, h = 86}
	}

	local pad = 14

	local titlefont = "PureSkinRole"
	local textfont = "PureSkinMSTACKMsg"

	function HUDELEMENT:Initialize()
		self.pad = pad
		self.basecolor = self:GetHUDBasecolor()

		BaseClass.Initialize(self)
	end

	-- parameter overwrites
	function HUDELEMENT:IsResizable()
		return true, false
	end
	-- parameter overwrites end

	function HUDELEMENT:GetDefaults()
		const_defaults["basepos"] = {x = math.Round((ScrW() - self.size.w) * 0.5), y = math.Round((ScrH() - self.size.h) * 0.5) - 250}

		return const_defaults
	end

	function HUDELEMENT:ShouldDraw()
		local client = LocalPlayer()

		return HUDEditor.IsEditing or client:Alive() and EPOP:ShouldRender()
	end

	function HUDELEMENT:PerformLayout()
		self.scale = self:GetHUDScale()
		self.pad = pad * self.scale

		self.basecolor = self:GetHUDBasecolor()

		-- reset item ready
		if EPOP.msg then
			EPOP.msg.ready = false
		end

		BaseClass.PerformLayout(self)
	end

	function HUDELEMENT:PrepareItem(item)
		local size = self:GetSize()
		local pos = self:GetPos()
		local width_title, width_text, height_title, height_text = 0, 0, 0, 0

		-- wrap title if needed
		item.title_wrapped, width_title, height_title = WrapText(item.title, size.w - 2 * self.pad, titlefont)

		-- wrap text if needed
		item.text_wrapped, width_text, height_text = WrapText(item.text, size.w - 2 * self.pad, textfont)

		item.size = {}
		item.size.w = ((width_title > width_text) and width_title or width_text) + 2 * self.pad
		item.size.h = height_title + 2 * self.pad + height_text + ((height_text > 0) and self.pad or 0)

		item.pos = {}
		item.pos.y = pos.y
		item.pos.x = pos.x + math.Round(0.5 * (size.w - item.size.w))
		item.pos.center_x = pos.x + math.Round(0.5 * size.w)

		-- precalculate text positions
		local height_title_line = height_title / #item.title_wrapped
		local height_text_line = height_text / #item.text_wrapped

		item.pos.title_y = {}
		for i = 1, #item.title_wrapped do
			table.insert(item.pos.title_y, pos.y + self.pad + (i - 1) * height_title_line)
		end
		item.pos.text_y = {}
		for i = 1, #item.text_wrapped do
			table.insert(item.pos.text_y, item.pos.title_y[#item.pos.title_y] + height_title_line + self.pad + (i - 1) * height_text_line)
		end

		-- mark as ready
		item.ready = true
	end

	function HUDELEMENT:Draw()
		local msg = EPOP.msg

		-- fallback for hud-editor
		if not msg then
			msg = {}
			msg.title = "A Test Popup, now with a multiline title, how NICE."
			msg.text = "Well, hello there! This is a fancy popup with some special information. The text can be also multiline, how fancy! Ugh, I could add so much more text if I'd had any ideas..."
		end

		-- prepare item, caches the data of the element to improve performance
		if not msg.ready then
			self:PrepareItem(msg)
		end

		-- draw bg and shadow
		self:DrawBg(msg.pos.x, msg.pos.y, msg.size.w, msg.size.h, self.basecolor)

		-- draw content
		for i = 1, #msg.title_wrapped do
			draw.AdvancedText(msg.title_wrapped[i], titlefont, msg.pos.center_x, msg.pos.title_y[i], self:GetDefaultFontColor(self.basecolor), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, true, self.scale)
		end
		for i = 1, #msg.text_wrapped do
			draw.AdvancedText(msg.text_wrapped[i], textfont, msg.pos.center_x, msg.pos.text_y[i], self:GetDefaultFontColor(self.basecolor), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, true, self.scale)
		end

		-- draw lines around the element
		self:DrawLines(msg.pos.x, msg.pos.y, msg.size.w, msg.size.h, self.basecolor.a)
	end
end
