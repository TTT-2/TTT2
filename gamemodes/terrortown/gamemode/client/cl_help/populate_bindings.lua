local materialIcon = Material("vgui/ttt/vskin/helpscreen/bindings")

local function AddBindingCategory(category, parent)
	local client = LocalPlayer()

	local form = CreateForm(parent, category)

	local bindings = bind.GetSettingsBindings()

	for i = 1, #bindings do
		local binding = bindings[i]

		if binding.category ~= category then continue end

		local currentBinding = bind.Find(binding.name)

		form:MakeBinder({
			label = binding.label,
			select = currentBinding,
			default = binding.defaultKey,
			onDisable = function(slf, binder)
				bind.Remove(currentBinding, binding.name, true)

				binder:SetValue(bind.Find(binding.name))
			end,
			onChange = function(slf, keyNum)
				if currentBinding == keyNum then return end

				bind.Remove(currentBinding, binding.name, true)

				if keyNum ~= 0 then
					bind.Add(keyNum, binding.name, true)
				end

				local key = keyNum ~= 0 and string.upper(input.GetKeyName(keyNum)) or LANG.GetTranslation("button_none")

				client:ChatPrint(
					LANG.GetParamTranslation("ttt2_bindings_new", {
						name = binding.name,
						key = key
					})
				)

				currentBinding = keyNum
			end
		})
	end
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
	bindingsData:SetIcon(materialIcon)
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
