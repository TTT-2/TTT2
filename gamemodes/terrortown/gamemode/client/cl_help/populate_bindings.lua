local materialIcon = Material("vgui/ttt/vskin/helpscreen/bindings")

local function AddBindingCategory(category, parent)
	local client = LocalPlayer()

	local form = CreateTTT2Form(parent, category)

	local bindings = bind.GetSettingsBindings()

	for i = 1, #bindings do
		local binding = bindings[i]

		if binding.category ~= category then continue end

		local currentBinding = bind.Find(binding.name)

		form:MakeBinder({
			label = binding.label,
			select = currentBinding,
			default = binding.defaultKey,
			OnDisable = function(slf, binder)
				bind.Remove(currentBinding, binding.name, true)

				binder:SetValue(bind.Find(binding.name))
			end,
			OnChange = function(slf, keyNum)
				if currentBinding == keyNum then return end

				bind.Remove(currentBinding, binding.name, true)

				if keyNum ~= 0 then
					bind.Add(keyNum, binding.name, true)
				end

				local key = keyNum ~= 0 and string.upper(input.GetKeyName(keyNum)) or LANG.GetTranslation("button_none")

				client:ChatPrint(
					LANG.GetParamTranslation("bindings_new", {
						name = binding.name,
						key = key
					})
				)

				currentBinding = keyNum
			end
		})
	end
end

HELPSCRN.populate["ttt2_bindings"] = function(helpData, id)
	local bindingsData = helpData:RegisterSubMenu(id)

	bindingsData:SetTitle("menu_bindings_title")
	bindingsData:SetDescription("menu_bindings_description")
	bindingsData:SetIcon(materialIcon)
end

HELPSCRN.subPopulate["ttt2_bindings"] = function(helpData, id)
	local bindingsData = helpData:PopulateSubMenu(id .. "_bindings")

	bindingsData:SetTitle("submenu_bindings_bindings_title")
	bindingsData:PopulatePanel(function(parent)
		local categories = bind.GetSettingsBindingsCategories()

		for i = 1, #categories do
			AddBindingCategory(categories[i], parent)
		end
	end)
end
