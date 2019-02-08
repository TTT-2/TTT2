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

	sheet.Navigation:SetWidth(256)

	sheet.OnActiveTabChanged = function(old, new)

	end

	local currentHUD = HUDManager.GetHUD()

	for _, hud in ipairs(huds.GetList()) do
		if hud.id == "hud_base" then continue end

		local panel = vgui.Create("DPanel", sheet)
		panel:Dock(FILL)

		panel.Paint = function(slf, w, h)
			draw.RoundedBox(4, 0, 0, w, h, Color(0, 128, 255))
			draw.DrawText(hud.id, "DermaDefault", w * 0.5, h * 0.5, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end

		local leftBtn = sheet:AddSheet("", panel).Button
		leftBtn:SetSize(256, 256)

		leftBtn.Paint = function(slf, w, h)
			surface.SetMaterial(hud.previewImage)

			if hud.id == HUDManager.GetHUD() then
				surface.SetDrawColor(255, 255, 255, 255)
			else
				surface.SetDrawColor(255, 255, 255, 100)
			end

			surface.DrawTexturedRect(0, 0, w, h)
		end

		local oldClick = leftBtn.DoClick
		leftBtn.DoClick = function(slf)
			oldClick(slf)

			HUDManager.SetHUD(hud.id)
		end

		if hud.id == currentHUD then
			sheet:SetActiveButton(leftBtn)
		end
	end
end

derma.DefineControl("HUDSwitcher", "", PANEL, "DFrame")
