--- @ignore

CLGAMEMODESUBMENU.base = "base_gamemodesubmenu"

CLGAMEMODESUBMENU.priority = 98
CLGAMEMODESUBMENU.title = "submenu_commands_maps_title"

local comboBase

function CLGAMEMODESUBMENU:Populate(parent)
    local prefixes = map.GetPrefixes()
    local maps = map.GetList()

    local form = vgui.CreateTTT2Form(parent, "header_maps_prefixes")

    for i = 1, #prefixes do
        form:MakeCheckBox({
            label = prefixes[i],
            serverConvar = "ttt2_enable_map_prefix_" .. prefixes[i],
            OnChange = function(_, value)
                -- set global bool on the client to bridge network delay
                SetGlobalBool("ttt2_enable_map_prefix_" .. prefixes[i], value)

                vguihandler.Rebuild()
            end,
        })
    end

    local form2 = vgui.CreateTTT2Form(parent, "header_maps_select")

    -- Create combo boxes to select element from
    comboBase = form2:MakeIconLayout()

    for i = 1, #maps do
        local mapName = maps[i]
        local prefix = map.GetPrefix(mapName)

        form2:MakeComboCard({
            icon = map.GetIcon(mapName),
            label = mapName,
            tag = prefix,
            colorTag = util.StringToColor(prefix or ""),
        }, comboBase)
    end
end

function CLGAMEMODESUBMENU:PopulateButtonPanel(parent)
    local buttonChange = vgui.Create("DButtonTTT2", parent)

    buttonChange:SetText("button_change_map")
    buttonChange:SetSize(175, 45)
    buttonChange:SetPos(parent:GetWide() - 195, 20)
    buttonChange.DoClick = function(btn)
        if not comboBase.checked then
            return
        end

        local mapName = comboBase.checked:GetText()

        map.ChangeLevel(mapName)
    end
    buttonChange:SetEnabled(true)
end

function CLGAMEMODESUBMENU:HasButtonPanel()
    return true
end
