-- Removed in GM13, still need it
local PANEL = {}

AccessorFunc(PANEL, "m_bBorder", "Border")
AccessorFunc(PANEL, "m_Color", "Color")

function PANEL:Init()
	self:SetSize(ScrW() * 0.8, ScrH() * 0.8)
	self:Center()
	self:SetTitle("HUDSwitcher")
	self:SetVisible(true)
	self:ShowCloseButton(true)
	self:SetMouseInputEnabled(true)
	self:SetDeleteOnClose(true)

	self.OnClose = function(slf)
		if not slf.forceClosing then
			HUDManager.ShowHUDSwitcher(false)
		end
	end

	local sheet = vgui.Create("DColumnSheet", self)
	sheet:Dock(FILL)

	sheet.OnActiveTabChanged = function(old, new)

	end

	for _, hud in ipairs(huds.GetList()) do
		local panel = vgui.Create("DPanel", sheet)
		panel:Dock(FILL)

		panel.Paint = function(slf, w, h)
			draw.RoundedBox(4, 0, 0, w, h, Color(0, 128, 255))
		end

		local leftBtn = sheet:AddSheet("", panel).Button
		leftBtn:SetSize(256, 256)

		leftBtn.Paint = function(slf, w, h)
			surface.SetMaterial(hud.previewImage)
			surface.SetDrawColor(255, 255, 255, 255)
			surface.DrawTexturedRect(0, 0, w, h)
		end
	end
end

derma.DefineControl("HUDSwitcher", "", PANEL, "DFrame")
