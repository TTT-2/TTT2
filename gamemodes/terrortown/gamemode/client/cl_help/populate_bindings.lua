local function AddBindingCategory(category, parent)
	local form = vgui.Create("DFormTTT2", parent)

	form:SetName(category)

	local bindings = bind.GetSettingsBindings()

	for i = 1, #bindings do
		local binding = bindings[i]

		if binding.category == category then
			-- creating two grids:
			-- GRID: tooltip, bindingbutton and extra button area
			-- GRIDEXTRA: inside the last GRID box, houses default and disable buttons
			local dPGrid = vgui.Create("DGrid")
			dPGrid:SetCols(1)
			dPGrid:SetColWide(1000)

			--local dPGridExtra = vgui.Create("DGrid")
			--dPGridExtra:SetCols(2)

			form:AddItem(dPGrid)

			local dPanel = vgui.Create("DPanel")
			dPanel:SetSize(1000, 1000)
			--dPanel:SizeToChildren(false, true)
			dPGrid:AddItem(dPanel)

			-- Keybind Label
			local dPlabel = vgui.Create("DLabel", dPanel)
			dPlabel:SetText(binding.label .. ":")
			dPlabel:SetTextColor(COLOR_BLACK)
			dPlabel:SetContentAlignment(4)
			dPlabel:SetSize(150, 35)
			dPlabel:DockMargin(0, 0, 15, 0)
			--dPGrid:AddItem(dPlabel)


			-- Keybind Button
			local dPBinder = vgui.Create("DBinderTTT2", dPanel)
			dPBinder:SetSize(150, 35)
			dPBinder:SetPos(165, 0)
			--dPBinder:DockMargin(0, 0, 15, 0)

			local curBinding = bind.Find(binding.name)
			dPBinder:SetValue(curBinding)
			dPBinder:SetTooltip("f1_bind_description")

			--dPGrid:AddItem(dPBinder)
			--dPGrid:AddItem(dPGridExtra)

			-- DEFAULT Button
			local dPBindDefaultButton = vgui.Create("DButtonTTT2", dPanel)
			dPBindDefaultButton:SetText("button_bind_default")
			dPBindDefaultButton:SetSize(75, 35)
			dPBindDefaultButton:SetPos(350, 0)
			--dPBindDefaultButton:DockMargin(0, 0, 15, 0)
			dPBindDefaultButton:SetTooltip("f1_bind_reset_default_description")

			if binding.defaultKey ~= nil then
				dPBindDefaultButton.DoClick = function()
					bind.Set(binding.defaultKey, binding.name, true)
					dPBinder:SetValue(bind.Find(binding.name))
				end
			else
				dPBindDefaultButton:SetDisabled(true)
			end
			--dPGridExtra:AddItem(dPBindDefaultButton)

			-- DISABLE Button
			local dPBindDisableButton = vgui.Create("DButtonTTT2", dPanel)
			dPBindDisableButton:SetText("button_bind_disable")
			dPBindDisableButton:SetSize(75, 35)
			dPBindDisableButton:SetPos(440, 0)
			dPBindDisableButton:SetTooltip("f1_bind_disable_description")
			dPBindDisableButton.DoClick = function()
				bind.Remove(curBinding, binding.name, true)
				dPBinder:SetValue(bind.Find(binding.name))
			end
			--dPGridExtra:AddItem(dPBindDisableButton)

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

---
-- Function to populate main menu
-- @param table helpData The main menu data object
-- @param string id The unique id of this menu element
-- @internal
-- @realm client
HELPSCRN.populate["ttt2_bindings"] = function(helpData, id)
	local bindingsData = helpData:RegisterSubMenu(id)

	bindingsData:SetTitle("menu_bindings_title")
	bindingsData:SetDescription("menu_bindings_description")
	bindingsData:SetIcon(Material("vgui/ttt/dynamic/roles/icon_inno"))
end

---
-- Function to populate sub menu
-- @param table helpData The sub menu data object
-- @param string id The unique id of this menu element
-- @internal
-- @realm client
HELPSCRN.subPopulate["ttt2_bindings"] = function(helpData, id)
	local bindingsData = helpData:PopulateSubMenu(id .. "_bindings")

	bindingsData:SetTitle("submenu_bindings_bindings_title")
	bindingsData:PopulatePanel(function(parent)
		AddBindingCategory("TTT2 Bindings", parent)

		local categories = bind.GetSettingsBindingsCategories()

		for i = 1, #categories do
			local category = categories[i]

			if i > 2 then
				AddBindingCategory(category, parent)
			end
		end

		AddBindingCategory("Other Bindings", parent)
	end)
end
