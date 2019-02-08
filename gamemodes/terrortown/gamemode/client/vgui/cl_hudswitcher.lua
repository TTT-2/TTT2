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

	local panel1 = vgui.Create("DPanel", sheet)
	panel1:Dock(FILL)

	panel1.Paint = function(slf, w, h)
		draw.RoundedBox(4, 0, 0, w, h, Color(0, 128, 255))
	end

	local leftBtn = sheet:AddSheet("LeftPanel", panel1, "icon16/cross.png").Button
	leftBtn.Paint = function(slf, w, h)

	end

	local panel2 = vgui.Create("DPanel", sheet)
	panel2:Dock(FILL)

	panel2.Paint = function(slf, w, h)
		draw.RoundedBox(4, 0, 0, w, h, Color(255, 128, 0))
	end

	local rightBtn = sheet:AddSheet("RightPanel", panel2, "icon16/tick.png").Button
	rightBtn.Paint = function(slf, w, h)

	end
end

derma.DefineControl("HUDSwitcher", "", PANEL, "DFrame")
