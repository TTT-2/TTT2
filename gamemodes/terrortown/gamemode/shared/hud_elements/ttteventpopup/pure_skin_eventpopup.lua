local base = "pure_skin_element"

DEFINE_BASECLASS(base)

HUDELEMENT.Base = base

if CLIENT then
	local const_defaults = {
		basepos = {x = 0, y = 0},
		size = {w = 1000, h = 80},
		minsize = {w = 700, h = 80}
	}

	local titlefont = "PureSkinBar"
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
		local scale = self:GetHUDScale()

		self.basecolor = self:GetHUDBasecolor()

		-- reset item ready
		if EPOP.msg then
			EPOP.msg.ready = false
		end

		BaseClass.PerformLayout(self)
	end

	function HUDELEMENT:PrepareItem(item)
		local size = self:GetSize()
		local width_title, width_text, height_title, height_text = 0, 0

		-- wrap title if needed
		item.title_wrapped, width_title, height_title = WrapText(item.title, size.w, titlefont)

		-- wrap text if needed
		item.text_wrapped, width_text, height_text = WrapText(item.text, size.w, textfont)

		item.size.w = (width_title > width_text) and width_title or width_text
		item.size.h = height_title + height_text

		-- mark as ready
		item.ready = true
	end

	function HUDELEMENT:Draw()
		local client = LocalPlayer()
		local pos = self:GetPos()
		local size = self:GetSize()
		local x, y = pos.x, pos.y
		local w, h = size.w, size.h

		-- fallback for hud-editor
		if not EPOP.msg then
			EPOP.msg = {}
			EPOP.msg.title = "A Test Popup"
		end

		-- prepare item, caches the data of the element to improve performance
		if not EPOP.msg.ready then
			self:PrepareItem(EPOP.msg)
		end

		-- draw bg and shadow
		self:DrawBg(x, y, w, h, self.basecolor)

		-- draw lines around the element
		self:DrawLines(x, y, w, h, self.basecolor.a)
	end
end
