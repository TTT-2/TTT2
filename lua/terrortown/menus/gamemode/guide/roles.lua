--- @ignore

CLGAMEMODESUBMENU.base = "base_gamemodesubmenu"

CLGAMEMODESUBMENU.priority = 99
CLGAMEMODESUBMENU.title = "submenu_guide_roles_title"

local builtinIcon = Material("vgui/ttt/vskin/markers/builtin")

local lastActive

function CLGAMEMODESUBMENU:Populate(parent)
    local rolesList = roles.GetSortedRoles()

    local scrollPanel = vgui.Create("DScrollPanel", parent)
    scrollPanel:Dock(LEFT)

    local contentArea = vgui.Create("DPanel", parent)
    contentArea:Dock(RIGHT)

    contentArea.PerformLayout = function(pnl)
        pnl:SetSize(parent:GetWide() - scrollPanel:GetWide(), parent:GetTall())
    end


    for _, roleData in pairs(rolesList) do
        if roleData.index == ROLE_NONE then
            continue
        end


        local settingsButton = vgui.Create("DSubmenuButtonTTT2", scrollPanel)
        settingsButton:Dock(TOP)
        settingsButton:SetTitle(roleData.name)
        settingsButton:SetIcon(roleData.iconMaterial, false)
        settingsButton:SetIconBadge(roleData.builtin and builtinIcon)
        settingsButton:SetIconBadgeSize(8)

        settingsButton.PerformLayout = function(panel)
            panel:SetSize(panel:GetParent():GetWide(), 50)
        end

        settingsButton.DoClick = function(slf)
            contentArea:Clear()
            local roleInfo = vgui.Create("DLabel", contentArea)
            roleInfo:Dock(TOP)
            roleInfo:DockMargin(10, 10, 10, 10)
            roleInfo:SetFont("Trebuchet24")
            roleInfo:SetText(string.format("Built-in: %s\nTeam: %s\nDescription: %s", roleData.builtin and "Yes" or "No", roleData.defaultTeam, LANG.TryTranslation("ttt2_desc_" .. roleData.name)))
            roleInfo:SetWrap(true)
            roleInfo:SetAutoStretchVertical(true)



            -- handle the set/unset of active buttons for the draw process
            if lastActive and lastActive.SetActive then
                lastActive:SetActive(false)
            end

            slf:SetActive()
            lastActive = slf
        end

    end

    scrollPanel.PerformLayout = function(pnl)
        pnl:SetSize(300, parent:GetTall())
    end
end

