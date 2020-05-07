---
-- @class PANEL
-- @realm client
-- @section HUDSwitcher

local vgui = vgui

local PANEL = {}

---
-- @function GetBorder()
-- @return boolean
--
---
-- @function SetBorder(border)
-- @param boolean border
---
AccessorFunc(PANEL, "m_bBorder", "Border")

---
-- @function GetColor()
-- @return Color
--
---
-- @function SetColor(color)
-- @param Color color
---
AccessorFunc(PANEL, "m_Color", "Color")

---
-- @param Panel panel
-- @param HUDELEMENT hudEl
local function AddHUDSettings(panel, hudEl)
	if not IsValid(panel) or not hudEl then return end

	local tmp = table.Copy(hudEl:GetSavingKeys()) or {}
	tmp.el_pos = {typ = "el_pos", desc = LANG.GetTranslation("f1_settings_hudswitcher_desc_layout_editor")}
	tmp.reset = {typ = "reset", desc = LANG.GetTranslation("f1_settings_hudswitcher_desc_reset")}

	for key, data in pairs(tmp) do
		local el
		local container

		if data.typ == "el_pos" then -- HUD edit button
			el = vgui.Create("DButton")
			el:SetText(LANG.GetTranslation("f1_settings_hudswitcher_button_layout_editor"))
			el:SizeToContents()

			el.DoClick = function(btn)
				HUDEditor.EditHUD(hudEl.id)
				HUDManager.HideHUDSwitcher()
			end
		elseif data.typ == "reset" then
			el = vgui.Create("DButton")
			el:SetTextColor(Color(255, 0, 0))
			el:SetText("- " .. LANG.GetTranslation("f1_settings_hudswitcher_button_reset") .. " -")
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
		elseif data.typ == "number" then
			el = vgui.Create("DNumSliderWang")
			el:SetSize(600, 20)
			el:SetMin(0.1)
			el:SetMax(4.0)
			el:SetDecimals(1)

			if hudEl[key] then
				el:SetDefaultValue(hudEl[key])
				el:SetValue(math.Round(hudEl[key], 1))
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
	self:SetTitle(LANG.GetTranslation("f1_settings_hudswitcher_title") .. " - " .. currentHUD)
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

	local sheets = {}
	local hudLists = huds.GetList()
	local restrictedHUDs = ttt2net.GetGlobal({"hud_manager", "restrictedHUDs"})
	local colorHUDBoxEnabled = Color(155, 155, 155, 255)
	local colorHUDBoxDisabled = Color(255, 0, 0)

	for i = 1, #hudLists do
		local hud = hudLists[i]

		if table.HasValue(restrictedHUDs, hud.id) then continue end

		local panel = vgui.Create("DPanel", dcsheet)
		panel:Dock(FILL)

		panel.hudid = hud.id

		panel.Paint = function(slf, w, h)
			draw.RoundedBox(4, 0, 0, w, h, hud.disableHUDEditor and colorHUDBoxDisabled or colorHUDBoxEnabled)

			if hud.disableHUDEditor then
				draw.DrawText(LANG.GetTranslation("f1_settings_hudswitcher_desc_hud_not_supported"), "DermaDefault", w * 0.5, 10, COLOR_WHITE, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
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

		sheets[#sheets + 1] = sheet

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

	hook.Add("TTT2HUDUpdated", "TTT2HUDUpdateHUDSwitcher", function(name)
		if not sheets then return end

		for i = 1, #sheets do
			local v = sheets[i]

			if name ~= v.Panel.hudid then continue end

			dcsheet:SetActiveButton(v.Button)

			self:SetTitle(LANG.GetTranslation("f1_settings_hudswitcher_title") .. " - " .. name)

			break
		end
	end)
end

derma.DefineControl("HUDSwitcher", "", PANEL, "DFrame")
