--- @ignore

local TryT = LANG.TryTranslation
local ParT = LANG.GetParamTranslation
local DynT = LANG.GetDynamicTranslation

CLGAMEMODESUBMENU.base = "base_gamemodesubmenu"

CLGAMEMODESUBMENU.priority = 95
CLGAMEMODESUBMENU.title = "submenu_roles_roleinspect"

-- save the forms indexed by role index here to access from hook
CLGAMEMODESUBMENU.forms = {}

local function OptIndex(tbl, index)
    if tbl then
        return tbl[index]
    end
    return nil
end

function CLGAMEMODESUBMENU:Populate(parent)
    -- first add a tutorial form
    local form = vgui.CreateTTT2Form(parent, "header_roleinspect_info")

    form:MakeHelp({
        label = "help_roleinspect",
    })

    form:MakeCheckBox({
        serverConvar = "ttt2_roleinspect_enable",
        label = "label_roleinspect_enable",
    })

    self.hasData = false

    roleinspect.GetDecisions(function(roleinspectTable)
        if self.hasData then return end

        -- the provided table is the decisions table, or an empty table if the data is not available
        if #roleinspectTable == 0 then
            -- empty table, put in an appropriate message

            local labelNoContent = vgui.Create("DLabelTTT2", parent)
            labelNoContent:SetText("label_menu_not_populated")
            labelNoContent:SetFont("DermaTTT2Title")
            labelNoContent:SetPos(20, 0)
            return
        end

        self.hasData = true

        -- we've recieved data, set up UI
        for stage, stageData in pairs(roleinspectTable) do
            local stageShortName = roleinspect.GetStageName(stage)
            local stageFullName = roleinspect.GetStageFullName(stage)
            local stageForm = vgui.CreateTTT2Form(parent, "header_" .. stageFullName)

            local function MakeRoleIcon(roleIcons, role, decision, paramFmt)
                local roleData = roles.GetByIndex(role)

                local ic = roleIcons:Add("DRoleImageTTT2")
                ic:SetSize(32, 32)
                ic:SetMaterial(roleData.iconMaterial)
                ic:SetColor(roleData.color)
                ic:SetEnabled(decision.decision == ROLEINSPECT_DECISION_CONSIDER)
                ic:SetMouseInputEnabled(true)

                local params = {
                    name = roleData.name,
                    decision = roleinspect.GetDecisionFullName(decision.decision),
                    reason = decision.reason
                        .. "_d_" .. roleinspect.GetDecisionName(decision.decision)
                        ..  "_s_" .. stageShortName,
                }

                if paramFmt then
                    params = paramFmt(params)
                end

                ic:SetTooltip(DynT(
                    "tooltip_" .. stageShortName .. "_role_desc",
                    params,
                    true
                ))
                ic:SetTooltipFixedPosition(0, 32)

                return ic
            end

            if stage == ROLEINSPECT_STAGE_PRESELECT then
                -- processing the PRESELECT stage
                stageForm:MakeHelp({
                    label = "help_" .. stageFullName,
                    params = {
                        maxPlayers = stageData.extra.maxPlayers[1]
                    }
                })

                local finalRoleCounts = stageData.extra.finalRoleCounts

                -- generate an icon layout containing all of the roles processed
                local roleIcons = stageForm:MakeIconLayout()

                for role, roleInspectData in pairs(stageData.roles) do
                    local decision = roleInspectData.decisions[1]
                    MakeRoleIcon(roleIcons, role, decision, function(params)
                        params.finalCount = tostring(finalRoleCounts[role] or 0)
                    end)
                end
            elseif stage == ROLEINSPECT_STAGE_LAYERING then
                -- the LAYERING stage
                stageForm:MakeHelp({
                    label = "help_" .. stageFullName,
                    params = {
                        maxRoles = OptIndex(stageData.extra.maxRoles, 1),
                        maxBaseroles = OptIndex(stageData.extra.maxBaseroles, 1),
                    }
                })

                -- we want to create a setup similar to the normal role layering UI to present this
                local finalSelectableRoles = stageData.extra.finalSelectableRoles[1]

                -- to that end, we want to compute the layered/unlayered baseroles
                -- build a more complete availableBaseroles list
                local unlayeredBaseroles = { ROLE_INNOCENT, ROLE_TRAITOR }
                local unlayeredBaserolesInv = { [ROLE_INNOCENT] = 1, [ROLE_TRAITOR] = 2}
                for _,role in pairs(stageData.extra.afterAvailableBaseRoles[1]) do
                    unlayeredBaseroles[#unlayeredBaseroles + 1] = role
                    unlayeredBaserolesInv[role] = #unlayeredBaseroles
                end

                -- then go through effective layers and filter unlayeredBaseroles to only baseroles without layers
                local baseroleLayers = stageData.extra.afterBaseRoleLayers[1]
                for _,layer in pairs(baseroleLayers) do
                    for _,role in pairs(layer) do
                        local idx = unlayeredBaserolesInv[role]
                        table.remove(unlayeredBaseroles, idx)
                    end
                end

                local baseroleLayersForm = vgui.CreateTTT2Form(stageForm, "header_inspect_layers_baseroles")

                local function ProcessLayer(parent, layer)
                    local icons = parent:MakeIconLayout()
                    for _,role in pairs(layer) do
                        local decision
                        if role == ROLE_INNOCENT or role == ROLE_TRAITOR then
                            decision = {
                                decision = ROLEINSPECT_DECISION_CONSIDER,
                                reason = ROLEINSPECT_REASON_FORCED,
                            }
                        else
                            local roleData = stageData.roles[role]
                            decision = roleData and roleData.decisions[1] or {
                                decision = ROLEINSPECT_DECISION_NO_CONSIDER,
                                reason = ROLEINSPECT_REASON_NOT_LAYERED
                            }
                        end
                        MakeRoleIcon(icons, role, decision, function(params)
                            params.finalCount = tostring(finalSelectableRoles[role])
                        end)
                    end
                end

                -- now create the icons for each of the layers
                for _,layer in pairs(baseroleLayers) do
                    ProcessLayer(baseroleLayersForm, layer)
                end

                -- then for unlayered
                ProcessLayer(baseroleLayersForm, unlayeredBaseroles)

                -- TODO: do the same with subroles

            else
                stageForm:MakeHelp({
                    label = "help_" .. stageFullName,
                })
            end
        end

    end)
end

function CLGAMEMODESUBMENU:PopulateButtonPanel(parent)
    --[[
    local buttonReset = vgui.Create("DButtonTTT2", parent)

    buttonReset:SetText("button_reset")
    buttonReset:SetSize(100, 45)
    buttonReset:SetPos(20, 20)
    buttonReset.DoClick = function()
        rolelayering.SendDataToServer(ROLE_NONE, {})

        for subrole in pairs(self.subroleList) do
            rolelayering.SendDataToServer(subrole, {})
        end
    end
    ]]
end

function CLGAMEMODESUBMENU:HasButtonPanel()
    --return true
    return false
end