-- Removed in GM13, still need it
local PANEL = {}

AccessorFunc(PANEL, "m_bBorder", "Border")
AccessorFunc(PANEL, "m_Color", "Color")

local function AddHUDSettings(panel, hudEl)
	if not IsValid(panel) or not hudEl then return end

	local tmp = table.Copy(hudEl:GetSavingKeys()) or {}
	tmp.el_pos = {typ = "el_pos", desc = "Change element's\nposition and size"}
	tmp.reset = {typ = "reset", desc = "Reset HUD's data"}

	for key, data in pairs(tmp) do
		local el
		local container

		if data.typ == "el_pos" then -- HUD edit button
			el = vgui.Create("DButton")
			el:SetText("Layout Editor")
			el:SizeToContents()

			el.DoClick = function(btn)
				HUDEditor.EditHUD(hudEl.id)
				HUDManager.HideHUDSwitcher()
			end
		elseif data.typ == "reset" then
			el = vgui.Create("DButton")
			el:SetTextColor(Color(255, 0, 0))
			el:SetText("- Reset -")
			el:SizeToContents()

			el.DoClick = function(btn)
				if hudEl then
					hudEl:Reset()
					hudEl:SaveData()
				end

				HUDManager.ShowHUDSwitcher()
			end
		elseif data.typ == "color" then
			el = vgui.Create("DColorMixer")
			el:SetSize(267, 186)

			if hudEl[key] then
				el:SetColor(hudEl[key])
			end

			function el:ValueChanged(col)
				hudEl[key] = col

				if isfunction(data.OnChange) then
					data.OnChange(hudEl, col)
				end
			end
		elseif data.typ == "scale" then
			el = vgui.Create("DNumSliderWang")
			el:SetSize(600, 20)
			el:SetMin( 0.1 )
			el:SetMax( 4.0 )
			el:SetDecimals( 1 )
			if hudEl[key] then
				el:SetDefaultValue( hudEl[key] )
				el:SetValue( math.Round(hudEl[key], 1) )
			end


			function el:OnValueChanged(val)
				val = math.Round(val, 1)
				if val ~= math.Round(hudEl[key], 1) then
					if isfunction(data.OnChange) then
						data.OnChange(hudEl, val)
					end

					hudEl[key] = val
				end
			end
		end

		if el then
			local add = false

			if not container then
				container = vgui.Create("DPanel")
				add = true
			end

			local label = vgui.Create("DLabel", container)
			label:SetText((data.desc or key) .. ":")
			label:SetTextColor(COLOR_BLACK)
			label:SetContentAlignment(5) -- center
			label:SizeToContents()
			label:DockMargin(20, 0, 0, 0)
			label:DockPadding(10, 0, 10, 0)
			label:Dock(LEFT)

			if add then
				el:SetParent(container)
			end

			el:DockPadding(10, 0, 10, 0)
			el:DockMargin(20, 0, 0, 0)
			el:Dock(LEFT)

			local w, h = el:GetSize()
			local lw, lh = label:GetSize()

			w = w + 10
			h = h + 10
			lw = lw + 10
			lh = lh + 10

			if w < lw then
				w = lw
			end

			h = h + lh

			container:SetSize(w, h)
			container:SetParent(panel)
			container:DockPadding(0, 10, 0, 10)
			container:Dock(TOP)
		end
	end
end

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
			HUDManager.HideHUDSwitcher()
		end
	end

	local dcsheet = vgui.Create("DColumnSheet", self)
	dcsheet:Dock(FILL)

	dcsheet.Navigation:SetWidth(256)

	dcsheet.OnActiveTabChanged = function(old, new)

	end

	local items = {}

	for _, hud in ipairs(huds.GetList()) do
		local panel = vgui.Create("DPanel", dcsheet)
		panel:Dock(FILL)

		panel.hudid = hud.id

		panel.Paint = function(slf, w, h)
			draw.RoundedBox(4, 0, 0, w, h, hud.disableHUDEditor and Color(255, 0, 0) or Color(155, 155, 155, 255))

			if hud.disableHUDEditor then
				draw.DrawText("! THIS HUD DOESN'T SUPPORT THE HUD EDITOR !", "DermaDefault", w * 0.5, 10, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			end
		end

		if not hud.disableHUDEditor then
			AddHUDSettings(panel, hud)

			panel.OnRemove = function(slf)
				if hud.id then
					hud:SaveData()
				end
			end
		end
		local sheet = dcsheet:AddSheet("", panel)
		table.insert(items, sheet)
		local leftBtn = sheet.Button
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

		leftBtn.DoClick = function(slf)
			local oldHUD = HUDManager.GetHUD()

			if hud.id == oldHUD then return end

			HUDManager.SetHUD(hud.id)
		end

		if hud.id == currentHUD then
			dcsheet:SetActiveButton(leftBtn)
		end
	end

	hook.Add("TTT2HUDUpdated", "TTT2HUDUpdateHUDSwitcher", function (name)
		for _, v in ipairs(items or {}) do
			if name == v.Panel.hudid then
				dcsheet:SetActiveButton(v.Button)
				self:SetTitle("HUD Switcher - " .. name)
				break
			end
		end
	end)
end

derma.DefineControl("HUDSwitcher", "", PANEL, "DFrame")
