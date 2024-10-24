--- @ignore

local TryT = LANG.TryTranslation

CLGAMEMODESUBMENU.priority = 0
CLGAMEMODESUBMENU.title = ""

function CLGAMEMODESUBMENU:Populate(parent)
    local equipment = self.equipment
    local accessName = ShopEditor.accessName
    local itemName = equipment.id

    if equipment.builtin then
        local form = vgui.CreateTTT2Form(parent, "header_equipment_info")
        form:MakeHelp({
            label = "equipmenteditor_desc_builtin",
        })
    end

    if not self.isItem then
        local form = vgui.CreateTTT2Form(parent, "header_equipment_weapon_spawn_setup")

        form:MakeHelp({
            label = "equipmenteditor_desc_auto_spawnable",
        })

        local master = form:MakeCheckBox({
            label = "equipmenteditor_name_auto_spawnable",
            database = DatabaseElement(accessName, itemName, "AutoSpawnable"),
        })

        local entType
        local entTypeList =
            entspawnscript.GetEntTypeList(SPAWN_TYPE_WEAPON, { [WEAPON_TYPE_RANDOM] = true })
        local choices = {}
        for i = 1, #entTypeList do
            entType = entTypeList[i]
            choices[i] = {
                title = TryT(
                    entspawnscript.GetLangIdentifierFromSpawnType(SPAWN_TYPE_WEAPON, entType)
                ),
                value = entType,
            }
        end

        form:MakeComboBox({
            label = "equipmenteditor_name_spawn_type",
            database = DatabaseElement(accessName, itemName, "spawnType"),
            choices = choices,
            master = master,
        })
    end

    local form = vgui.CreateTTT2Form(parent, "header_equipment_setup")

    if not self.isItem then
        form:MakeHelp({
            label = "equipmenteditor_desc_kind",
        })

        form:MakeComboBox({
            label = "equipmenteditor_name_kind",
            database = DatabaseElement(accessName, itemName, "Kind"),
            choices = {
                { title = TryT("slot_weapon_melee"), value = WEAPON_MELEE },
                { title = TryT("slot_weapon_pistol"), value = WEAPON_PISTOL },
                { title = TryT("slot_weapon_heavy"), value = WEAPON_HEAVY },
                { title = TryT("slot_weapon_nade"), value = WEAPON_NADE },
                { title = TryT("slot_weapon_carry"), value = WEAPON_CARRY },
                { title = TryT("slot_weapon_special"), value = WEAPON_SPECIAL },
                { title = TryT("slot_weapon_extra"), value = WEAPON_EXTRA },
                { title = TryT("slot_weapon_class"), value = WEAPON_CLASS },
            },
        })
    end

    form:MakeHelp({
        label = "equipmenteditor_desc_not_buyable",
    })

    local master = form:MakeCheckBox({
        label = "equipmenteditor_name_not_buyable",
        database = DatabaseElement(accessName, itemName, "notBuyable"),
        invert = true,
    })

    form:MakeHelp({
        label = "equipmenteditor_desc_not_random",
        master = master,
    })

    form:MakeCheckBox({
        label = "equipmenteditor_name_not_random",
        database = DatabaseElement(accessName, itemName, "NoRandom"),
        master = master,
    })

    form:MakeHelp({
        label = "equipmenteditor_desc_global_limited",
        master = master,
    })

    form:MakeCheckBox({
        label = "equipmenteditor_name_global_limited",
        database = DatabaseElement(accessName, itemName, "globalLimited"),
        master = master,
    })

    form:MakeHelp({
        label = "equipmenteditor_desc_team_limited",
        master = master,
    })

    form:MakeCheckBox({
        label = "equipmenteditor_name_team_limited",
        database = DatabaseElement(accessName, itemName, "teamLimited"),
        master = master,
    })

    form:MakeHelp({
        label = "equipmenteditor_desc_player_limited",
        master = master,
    })

    form:MakeCheckBox({
        label = "equipmenteditor_name_player_limited",
        database = DatabaseElement(accessName, itemName, "limited"),
        master = master,
    })

    form:MakeSlider({
        label = "equipmenteditor_name_min_players",
        min = 0,
        max = 63,
        decimal = 0,
        database = DatabaseElement(accessName, itemName, "minPlayers"),
        master = master,
    })

    form:MakeSlider({
        label = "equipmenteditor_name_credits",
        min = 0,
        max = 20,
        decimal = 0,
        database = DatabaseElement(accessName, itemName, "credits"),
        master = master,
    })

    if not self.isItem then
        local form2 = vgui.CreateTTT2Form(parent, "header_equipment_value_setup")

        form2:MakeHelp({
            label = "equipmenteditor_desc_allow_drop",
        })

        form2:MakeCheckBox({
            label = "equipmenteditor_name_allow_drop",
            database = DatabaseElement(accessName, itemName, "AllowDrop"),
        })

        form2:MakeHelp({
            label = "equipmenteditor_desc_drop_on_death_type",
        })

        form2:MakeComboBox({
            label = "equipmenteditor_name_drop_on_death_type",
            database = DatabaseElement(accessName, itemName, "overrideDropOnDeath"),
            choices = {
                { title = TryT("drop_on_death_type_default"), value = DROP_ON_DEATH_TYPE_DEFAULT },
                { title = TryT("drop_on_death_type_force"), value = DROP_ON_DEATH_TYPE_FORCE },
                { title = TryT("drop_on_death_type_deny"), value = DROP_ON_DEATH_TYPE_DENY },
            },
        })

        form2:MakeHelp({
            label = "equipmenteditor_desc_damage_scaling",
        })

        form2:MakeSlider({
            label = "equipmenteditor_name_damage_scaling",
            min = 0,
            max = 8,
            decimal = 2,
            database = DatabaseElement(accessName, itemName, "damageScaling"),
        })

        if equipment.EnableConfigurableClip then
            form2:MakeHelp({
                label = "help_equipmenteditor_configurable_clip",
            })

            form2:MakeSlider({
                label = "label_equipmenteditor_configurable_clip",
                min = 1,
                max = 20,
                decimal = 0,
                database = DatabaseElement(accessName, itemName, "ConfigurableClip"),
            })
        end
    end

    local equipmentClass = WEPS.GetClass(equipment)

    -- Get inheritable version for weapons to access inherited functions
    if not self.isItem then
        equipment = weapons.Get(equipmentClass)
    end

    -- now add custom equipment settings
    if isfunction(equipment.AddToSettingsMenu) then
        equipment:AddToSettingsMenu(parent)
    else
        Dev(
            1,
            "Weapon / item '"
                .. equipmentClass
                .. "' doesn't use the weapon_tttbase / item_base and can therefore add no custom settings to the settings panel."
        )
    end

    hook.Run("TTT2OnEquipmentAddToSettingsMenu", equipment, parent)
end
