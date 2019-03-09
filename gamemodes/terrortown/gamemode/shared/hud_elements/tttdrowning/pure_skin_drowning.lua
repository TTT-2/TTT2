local base = "pure_skin_element"

DEFINE_BASECLASS(base)

HUDELEMENT.Base = base

if CLIENT then
	local x = 0
	local y = 0

	local pad_default = 14
	local bh_default = 8 -- bar height

	local w, h = w_default, h_default
	local min_w, min_h = 75, 36
	local pad = pad_default -- padding
	
	local const_defaults = {
							basepos = {x = 0, y = 0},
							size = {w = 321, h = 36},
							minsize = {w = 75, h = 36}
		}

	function HUDELEMENT:Initialize()
		pad = pad_default

		local defaults = self:GetDefaults()

		w, h = defaults.size.w, defaults.size.h
		self.basecolor = self:GetHUDBasecolor()

		self:SetBasePos(defaults.basepos.x, defaults.basepos.y)
		self:SetMinSize(defaults.minsize.w, defaults.minsize.h)
		self:SetSize(defaults.size.w, defaults.size.h)

		BaseClass.Initialize(self)
	end
	
	-- parameter overwrites
	function HUDELEMENT:IsResizable()
		return true, false
	end
	-- parameter overwrites end

	function HUDELEMENT:GetDefaults()
		const_defaults["basepos"] = { x = math.Round(ScrW() * 0.5 - self.size.w * 0.5), y = ScrH() - pad - self.size.h}
		return const_defaults
 	end

	function HUDELEMENT:ShouldDraw()
		local client = LocalPlayer()

		return HUDEditor.IsEditing or client.drowningProgress and client:Alive() and client.drowningProgress ~= -1
	end

	function HUDELEMENT:PerformLayout()
		local pos = self:GetPos()
		local size = self:GetSize()
		local scale = self:GetHUDScale()

		self.basecolor = self:GetHUDBasecolor()

		pad = pad_default * scale
		x = pos.x
		y = pos.y
		w = size.w
		h = size.h

		BaseClass.PerformLayout(self)
	end

	function HUDELEMENT:Draw()
		local client = LocalPlayer()

		-- draw bg and shadow
		self:DrawBg(x, y, w, h, self.basecolor)
	
		self:DrawBar(x + pad, y + pad, w - pad * 2, h - pad * 2, Color(36, 154, 198), HUDEditor.IsEditing and 1 or (client.drowningProgress or 1), 1)

		-- draw lines around the element
		self:DrawLines(x, y, w, h, self.basecolor.a)
	end
end
