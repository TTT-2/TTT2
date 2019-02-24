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
			draw.RoundedBox(4, 0, 0, w, h, hud.disableHUDEditor and Color(255, 0, 0) or Color(255, 255, 255))

			if hud.disableHUDEditor then
				draw.DrawText("! THIS HUD DOESN'T SUPPORT THE HUD EDITOR !", "DermaDefault", w * 0.5, 10, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			end
		end

		if not hud.disableHUDEditor then
			HUDManager.AddHUDSettings(panel, hud)

			panel.OnRemove = function(slf)
				if hud.id then
					SQL.Save("ttt2_huds", hud.id, hud, hud:GetSavingKeys())
				end
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
			local oldHUD = HUDManager.GetHUD()

			if hud.id == oldHUD then return end

			local oldHUDEl = huds.GetStored(oldHUD)
			if oldHUDEl then
				SQL.Save("ttt2_huds", oldHUD, oldHUDEl, oldHUDEl:GetSavingKeys())
			end

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
