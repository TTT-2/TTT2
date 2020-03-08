

--- IDEE
-- alles cl_help zeug komm in einen ordner
-- bisherige hauptdateien bleiben vom inhalt gleich
-- content datei erstellt function table, importiert dann weitere dateien


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
