--- @ignore

local function AddBindingCategory(category, parent)
    local client = LocalPlayer()

    local form = vgui.CreateTTT2Form(parent, category)

    local bindings = bind.GetSettingsBindings()

    for i = 1, #bindings do
        local binding = bindings[i]

        if binding.category ~= category then
            continue
        end

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
                if currentBinding == keyNum then
                    return
                end

                bind.Remove(currentBinding, binding.name, true)

                if keyNum ~= 0 then
                    bind.Add(keyNum, binding.name, true)
                end

                local key = keyNum ~= 0 and string.upper(input.GetKeyName(keyNum))
                    or LANG.GetTranslation("button_none")

                client:ChatPrint(LANG.GetParamTranslation("bindings_new", {
                    name = binding.name,
                    key = key,
                }))

                currentBinding = keyNum
            end,
            enableRun = true,
            OnClickRun = function(button)
                local bindingData = bind.registry[binding.name]

                if not bindingData or not isfunction(bindingData.OnPressed) then
                    return
                end

                bindingData.OnPressed()

                -- run the release key binding a moment later
                timer.Simple(0.1, function()
                    if not bindingData or not isfunction(bindingData.OnReleased) then
                        return
                    end

                    bindingData.OnReleased()
                end)
            end,
        })
    end
end

CLGAMEMODESUBMENU.base = "base_gamemodesubmenu"

CLGAMEMODESUBMENU.priority = 100
CLGAMEMODESUBMENU.title = "submenu_bindings_bindings_title"

function CLGAMEMODESUBMENU:Populate(parent)
    local categories = bind.GetSettingsBindingsCategories()

    for i = 1, #categories do
        AddBindingCategory(categories[i], parent)
    end
end
