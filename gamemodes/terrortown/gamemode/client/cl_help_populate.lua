---
-- MAIN MENU CONTENT

local function AddBindings(helpData)
	local bindingsData = helpData:RegisterSubMenu("ttt2_bindings")

	bindingsData:SetTitle("f1_settings_bindings_title")
	bindingsData:SetDescription("Some cool text will be here...")
	bindingsData:SetIcon(Material("vgui/ttt/dynamic/roles/icon_inno"))
end

function InternalModifyMainMenu(helpData)
	AddBindings(helpData)
end


---
-- SUB MENU CONTENT

local function AddBindingCategory(category, parent)
	local form = vgui.Create("DForm", parent)

	form:SetName(category)

	for _, binding in ipairs(bind.GetSettingsBindings()) do
		if binding.category == category then
			-- creating two grids:
			-- GRID: tooltip, bindingbutton and extra button area
			-- GRIDEXTRA: inside the last GRID box, houses default and disable buttons
			local dPGrid = vgui.Create("DGrid")
			dPGrid:SetCols(3)
			dPGrid:SetColWide(120)

			local dPGridExtra = vgui.Create("DGrid")
			dPGridExtra:SetCols(2)
			dPGridExtra:SetColWide(60)

			form:AddItem(dPGrid)

			-- Keybind Label
			local dPlabel = vgui.Create("DLabel")
			dPlabel:SetText(binding.label .. ":")
			dPlabel:SetTextColor(COLOR_BLACK)
			dPlabel:SetContentAlignment(4)
			dPlabel:SetSize(120, 25)

			dPGrid:AddItem(dPlabel)


			-- Keybind Button
			local dPBinder = vgui.Create("DBinder")
			dPBinder:SetSize(100, 25)

			local curBinding = bind.Find(binding.name)
			dPBinder:SetValue(curBinding)
			dPBinder:SetTooltip("f1_bind_description")

			dPGrid:AddItem(dPBinder)
			dPGrid:AddItem(dPGridExtra)

			-- DEFAULT Button
			local dPBindResetButton = vgui.Create("DButton")
			dPBindResetButton:SetText("f1_bind_reset_default")
			dPBindResetButton:SetSize(55, 25)
			dPBindResetButton:SetTooltip("f1_bind_reset_default_description")

			if binding.defaultKey ~= nil then
				dPBindResetButton.DoClick = function()
					bind.Set(binding.defaultKey, binding.name, true)
					dPBinder:SetValue(bind.Find(binding.name))
				end
			else
				dPBindResetButton:SetDisabled(true)
			end
			dPGridExtra:AddItem(dPBindResetButton)

			-- DISABLE Button
			local dPBindDisableButton = vgui.Create("DButton")
			dPBindDisableButton:SetText("f1_bind_disable_bind")
			dPBindDisableButton:SetSize(55, 25)
			dPBindDisableButton:SetTooltip("f1_bind_disable_description")
			dPBindDisableButton.DoClick = function()
				bind.Remove(curBinding, binding.name, true)
				dPBinder:SetValue(bind.Find(binding.name))
			end
			dPGridExtra:AddItem(dPBindDisableButton)

			-- onchange function
			function dPBinder:OnChange(num)
				bind.Remove(curBinding, binding.name, true)

				if num ~= 0 then
					bind.Add(num, binding.name, true)
				end

				LocalPlayer():ChatPrint(GetPTranslation("ttt2_bindings_new", {name = binding.name, key = input.GetKeyName(num) or "NONE"}))

				curBinding = num
			end
		end
	end

	form:Dock(TOP)
end

local subMenuFunctions = {
	["ttt2_bindings"] = function(helpData)
		local bindingsData = helpData:PopulateSubMenu("ttt2_sub_bindings")

		bindingsData:SetTitle("ttt2_bindings")
		bindingsData:PopulatePanel(function(parent)
			AddBindingCategory("TTT2 Bindings", parent)

			for k, category in ipairs(bind.GetSettingsBindingsCategories()) do
				if k > 2 then
					AddBindingCategory(category, parent)
				end
			end

			AddBindingCategory("Other Bindings", parent)
		end)
	end
}

function InternalModifySubMenu(helpData, menuId)
	print("menuId: " .. tostring(menuId))

	if not subMenuFunctions[menuId] then return end

	subMenuFunctions[menuId](helpData)
end


--[[
local tbl = {
	[1] = {
		id = "changes",
		onclick = function(slf)
			local frm = ShowChanges()

			if not frm then return end

			local oldClose = frm.OnClose

			frm.OnClose = function(slf2)
				if isfunction(oldClose) then
					oldClose(slf2)
				end

				self:Show()
			end

			menuCache.subMenu = frm
		end,
		getTitle = function()
			return "f1_settings_changes_title"
		end
	},
	[2] = {
		id = "hudSwitcher",
		onclick = function(slf)
			client.hudswitcherSettingsF1 = true
			HUDManager.ShowHUDSwitcher()
		end,
		getTitle = function()
			return "f1_settings_hudswitcher_title"
		end
	},
	[3] = {
		id = "bindings",
		getContent = self.CreateBindings,
		getTitle = function()
			return "f1_settings_bindings_title"
		end
	},
	[4] = {
		id = "interface",
		getContent = self.CreateInterfaceSettings,
		getTitle = function()
			return "f1_settings_interface_title"
		end
	},
	[5] = {
		id = "gameplay",
		getContent = self.CreateGameplaySettings,
		getTitle = function()
			return "f1_settings_gameplay_title"
		end
	},
	[6] = {
		id = "crosshair",
		getContent = self.CreateCrosshairSettings,
		getTitle = function()
			return "f1_settings_crosshair_title"
		end
	},
	[7] = {
		id = "damageIndicator",
		getContent = self.CreateDamageIndicatorSettings,
		getTitle = function()
			return "f1_settings_dmgindicator_title"
		end
	},
	[8] = {
		id = "language",
		getContent = self.CreateLanguageForm,
		getTitle = function()
			return "f1_settings_language_title"
		end
	},
	[9] = {
		id = "fallback",
		onclick = function(slf)
			self:CreateCompatibilityPanel()
		end,
		getTitle = function()
			return "f1_settings_fallback"
		end
	},
	[10] = {
		id = "administration",
		getContent = self.CreateAdministrationForm,
		shouldShow = function()
			return LocalPlayer():IsAdmin()
		end,
		getTitle = function()
			return "f1_settings_administration_title"
		end
	}
}
]]
