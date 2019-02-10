-- Removed in GM13, still need it
local PANEL = {}

AccessorFunc(PANEL, "m_bBorder", "Border")
AccessorFunc(PANEL, "m_Color", "Color")

function PANEL:Init()
	local currentHUD = HUDManager.GetHUD()

	self:SetSize(ScrW() * 0.8, ScrH() * 0.8)
	self:Center()
	self:SetTitle("HUDSwitcher - " .. currentHUD)
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

	for _, hud in ipairs(huds.GetList()) do
		if hud.id == "hud_base" then continue end

		local panel = vgui.Create("DPanel", sheet)
		panel:Dock(FILL)

		panel.Paint = function(slf, w, h)
			draw.RoundedBox(4, 0, 0, w, h, Color(255, 255, 255))

			draw.DrawText(hud.id, "DermaDefault", w * 0.5, 10, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end

		HUDManager.AddHUDSettings(panel, hud)

		panel.OnRemove = function(slf)
			if hud.id then
				SQL.Save("ttt2_huds", hud.id, hud, hud.savingKeys)
			end
		end

		local leftBtn = sheet:AddSheet("", panel).Button
		leftBtn:SetSize(256, 256)

		leftBtn.Paint = function(slf, w, h)
			surface.SetMaterial(hud.previewImage)

			if hud.id == HUDManager.GetHUD() then
				surface.SetDrawColor(255, 255, 255, 255)
			else
				surface.SetDrawColor(255, 255, 255, 125)
			end

			surface.DrawTexturedRect(0, 0, w, h)
		end

		local mainPanel = self

		local oldClick = leftBtn.DoClick
		leftBtn.DoClick = function(slf)
			oldClick(slf)

			mainPanel:SetTitle("HUD Switcher - " .. hud.id)
			HUDManager.SetHUD(hud.id)
		end

		if hud.id == currentHUD then
			sheet:SetActiveButton(leftBtn)
		end
	end
end

derma.DefineControl("HUDSwitcher", "", PANEL, "DFrame")
