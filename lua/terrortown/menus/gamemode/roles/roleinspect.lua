--- @ignore

local table = table
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

local roleIconSize = 32

local function MakeRoleIcon(stage, roleIcons, role, decision, paramFmt)
    local roleData = roles.GetByIndex(role)

    local ic = roleIcons:Add("DRoleImageTTT2")
    ic:SetSize(roleIconSize, roleIconSize)
    ic:SetMaterial(roleData.iconMaterial)
    ic:SetColor(roleData.color)
    ic:SetValue(decision.decision == ROLEINSPECT_DECISION_CONSIDER)
    ic:SetAlpha(ic:GetValue() and 255 or 200)
    if
        decision.decision == ROLEINSPECT_DECISION_NO_CONSIDER
        and (
            decision.reason == ROLEINSPECT_REASON_NOT_ENABLED
            or decision.reason == ROLEINSPECT_REASON_NOT_SELECTABLE
        )
    then
        -- if this is not considered because it's not enabled (or not selectable), reduce it's alpha significantly as well
        ic:SetAlpha(100)
    end
    ic:SetMouseInputEnabled(true)

    local stageShortName = roleinspect.GetStageName(stage)

    local params = {
        name = roleData.name,
        decision = roleinspect.GetDecisionFullName(decision.decision),
        reason = decision.reason
            .. "_d_"
            .. roleinspect.GetDecisionName(decision.decision)
            .. "_s_"
            .. stageShortName,
    }

    if paramFmt then
        params = paramFmt(params) or params
    end

    ic:SetTooltip(DynT("tooltip_" .. stageShortName .. "_role_desc", params, true))
    ic:SetTooltipFixedPosition(0, roleIconSize)

    ic.subrole = role

    return ic
end

local function PopulatePreselectRoleStage(stage, form, stageData)
    local stageFullName = roleinspect.GetStageFullName(stage)

    form:MakeHelp({
        label = "help_" .. stageFullName,
        params = {
            maxPlayers = stageData.extra.maxPlayers[1],
        },
    })

    local finalRoleCounts = stageData.extra.finalRoleCounts[1]

    -- generate an icon layout containing all of the roles processed
    local roleIcons = form:MakeIconLayout()

    for role, roleInspectData in pairs(stageData.roles) do
        local decision = roleInspectData.decisions[1]
        MakeRoleIcon(stage, roleIcons, role, decision, function(params)
            params.finalCount = tostring(finalRoleCounts[role] or 0)
        end)
    end
end

local function PopulateLayeringRoleStage(stage, form, stageData)
    local stageFullName = roleinspect.GetStageFullName(stage)

    form:MakeHelp({
        label = "help_" .. stageFullName,
        params = {
            maxRoles = OptIndex(stageData.extra.maxRoles, 1) or "N/A",
            maxBaseroles = OptIndex(stageData.extra.maxBaseroles, 1) or "N/A",
        },
    })

    -- we want to create a setup similar to the normal role layering UI to present this
    local finalSelectableRoles = stageData.extra.finalSelectableRoles[1]

    local function FindIndex(tbl, value)
        for i = 1, #tbl do
            if value == tbl[i] then
                return i
            end
        end
    end

    local function ComputeActualUnlayered(rawAvailable, layers, unlayeredInitial)
        local unlayered = unlayeredInitial or {}
        -- actually build the base unlayered list
        for _, role in pairs(rawAvailable) do
            unlayered[#unlayered + 1] = role
        end

        if layers then
            -- then go through the layers to remove from the unlayered list ones which are layered
            local k = 1
            while k <= #layers do
                local layer = layers[k]
                local i = 1
                while i <= #layer do
                    local role = layer[i]
                    local idx = FindIndex(unlayered, role)

                    if idx then
                        table.remove(unlayered, idx)
                        i = i + 1
                    else
                        -- the role wasn't in the raw set of available roles, so
                        -- isn't a candidate and shouldn't be shown in the layers ui
                        table.remove(layer, i)
                    end
                end

                -- make sure to remove newly-empty layers
                if #layer == 0 then
                    table.remove(layers, k)
                else
                    k = k + 1
                end
            end
        end

        return unlayered
    end

    local function ProcessLayer(icons, layer)
        for _, role in pairs(layer) do
            local decision
            local roleData = stageData.roles[role]
            if not roleData and (role == ROLE_INNOCENT or role == ROLE_TRAITOR) then
                decision = {
                    decision = ROLEINSPECT_DECISION_CONSIDER,
                    reason = ROLEINSPECT_REASON_FORCED,
                }
            else
                decision = roleData and roleData.decisions[1]
                    or {
                        decision = ROLEINSPECT_DECISION_NO_CONSIDER,
                        reason = ROLEINSPECT_REASON_NOT_LAYERED,
                    }
            end
            MakeRoleIcon(stage, icons, role, decision, function(params)
                params.finalCount = tostring(finalSelectableRoles[role] or 0)
            end)
        end
    end

    local function PresentLayers(parent, layers, unlayered)
        local layout = parent:MakeIconLayout()

        if layers then
            -- first, layers
            local layersIcons = layout:Add("DRoleLayeringReceiverTTT2")
            layersIcons:SetLeftMargin(108)
            layersIcons:Dock(TOP)
            layersIcons:SetPadding(5)
            layersIcons:SetLayers(layers)
            layersIcons:SetChildSize(roleIconSize, roleIconSize)

            for _, layer in pairs(layers) do
                ProcessLayer(layersIcons, layer)
            end
        end

        if #unlayered > 0 then
            -- then unlayered
            local unlayeredIcons = layout:Add("DRoleLayeringSenderTTT2")
            unlayeredIcons:SetLeftMargin(108)
            unlayeredIcons:Dock(TOP)
            unlayeredIcons:SetPadding(5)
            unlayeredIcons:SetChildSize(roleIconSize, roleIconSize)

            ProcessLayer(unlayeredIcons, unlayered)
        end
    end

    -- to that end, we want to compute the layered/unlayered baseroles
    local baseroleLayers = stageData.extra.afterBaseRoleLayers[1]
    local unlayeredBaseroles = ComputeActualUnlayered(
        stageData.extra.afterAvailableBaseRoles[1],
        baseroleLayers,
        { ROLE_INNOCENT, ROLE_TRAITOR }
    )

    local baseroleLayersForm = vgui.CreateTTT2Form(form, "header_inspect_layers_baseroles")
    baseroleLayersForm:SetExpanded(false) -- default to being collapsed

    -- now create the icons for each of the layers
    PresentLayers(baseroleLayersForm, baseroleLayers, unlayeredBaseroles)

    -- present subroleSelectBaseroleOrder
    local subroleSelectBaseroleOrder = stageData.extra.subroleSelectBaseroleOrder

    if subroleSelectBaseroleOrder then
        local orderForm = vgui.CreateTTT2Form(form, "header_inspect_layers_order")
        orderForm:MakeHelp({
            label = "help_inspect_layers_order",
        })
        orderForm:SetExpanded(false) -- default to being collapsed
        orderForm = orderForm:MakeIconLayout()
        orderForm:SetBorder(5)
        orderForm:SetSpaceX(5)
        orderForm:SetSpaceY(5)
        orderForm:SetStretchHeight(true)

        for i = 1, #subroleSelectBaseroleOrder do
            local orderItem = subroleSelectBaseroleOrder[i]
            local baseroleData = roles.GetByIndex(orderItem.baserole)
            local subroleData = roles.GetByIndex(orderItem.subrole)

            local entry = vgui.Create("DPiPPanelTTT2", orderForm)
            entry:SetPadding(4)
            entry:SetOuterOffset(4)

            -- first added panel is the main one
            local ic = entry:Add("DRoleImageTTT2")
            ic:SetSize(roleIconSize, roleIconSize)
            ic:SetMaterial(baseroleData.iconMaterial)
            ic:SetColor(baseroleData.color)
            ic:SetValue(true)
            ic:SetMouseInputEnabled(true)
            ic:SetTooltip(
                DynT("tooltip_inspect_layers_baserole", { name = baseroleData.name }, true)
            )
            ic:SetTooltipFixedPosition(0, roleIconSize)

            -- align bottom-right, preferred-axis X
            ic = entry:Add("DRoleImageTTT2", RIGHT, BOTTOM)
            ic:SetSize(roleIconSize * 2 / 3, roleIconSize * 2 / 3)
            ic:SetMaterial(subroleData.iconMaterial)
            ic:SetColor(subroleData.color)
            ic:SetValue(true)
            ic:SetMouseInputEnabled(true)
            ic:SetTooltip(DynT("tooltip_inspect_layers_subrole", { name = subroleData.name }, true))
            ic:SetTooltipFixedPosition(0, roleIconSize * 2 / 3)
        end
    end

    local availableSubroles = OptIndex(stageData.extra.afterAvailableSubRoles, 1)
    local subroleLayers = OptIndex(stageData.extra.afterSubRoleLayers, 1)

    if availableSubroles and subroleLayers then
        -- generate the same thing for the subroles of each baserole
        for baserole, subroles in pairs(availableSubroles) do
            local layers = subroleLayers[baserole]
            local unlayeredSubroles = ComputeActualUnlayered(subroles, layers)
            local baseroleData = roles.GetByIndex(baserole)

            local layersForm = vgui.CreateTTT2Form(
                form,
                DynT("header_inspect_layers_subroles", { baserole = baseroleData.name }, true)
            )
            layersForm:SetExpanded(false) -- default to being collapsed

            PresentLayers(layersForm, layers, unlayeredSubroles)
        end
    end
end

local function PopulateBaserolesStage(stage, form, stageData)
    local stageFullName = roleinspect.GetStageFullName(stage)

    form:MakeHelp({
        label = "help_" .. stageFullName,
        params = {},
    })

    -- go through the assignment order to display selection info
    for i, assignment in pairs(stageData.extra.assignOrder) do
        -- assignment has amount, players, role
        local role = assignment.role
        local roleData = roles.GetByIndex(role)

        local itemForm = vgui.CreateTTT2Form(
            form,
            DynT("header_inspect_baseroles_order", { name = roleData.name }, true)
        )
        itemForm:SetExpanded(false) -- default to being collapsed

        local recordedRoleData = stageData.roles[role]
        local decisions = recordedRoleData.decisions
        local playerWeights = OptIndex(recordedRoleData.extra.playerWeights, 1)

        if playerWeights then
            -- derandomization is enabled, weights are in play
            local playerGraph = vgui.Create("DPlayerGraphTTT2", itemForm)
            playerGraph:Dock(TOP)

            for k = 1, #assignment.players do
                local ply = assignment.players[k]

                local isHighlight = false
                for j = 1, #decisions do
                    local dec = decisions[j]
                    if dec.ply == ply then
                        isHighlight = true
                        break
                    end
                end

                playerGraph:AddPlayer(ply, playerWeights[ply], isHighlight)
            end
        else
            -- derandomization is not enabled, weights are not in play
            -- just show a list of players assigned the role
            local layout = itemForm:MakeIconLayout()

            for k = 1, #assignment.players do
                local ply = assignment.players[k]

                local isHighlight = false
                for j = 1, #decisions do
                    local dec = decisions[j]
                    if dec.ply == ply then
                        isHighlight = true
                        break
                    end
                end

                local plyIcon = vgui.Create("SimpleIconAvatar", layout)
                plyIcon:SetPlayer(ply)
                plyIcon:SetTooltip(ply:GetName())
                plyIcon:SetMouseInputEnabled(true)
                plyIcon:SetAlpha(isHighlight and 255 or 75)
                plyIcon:SetAvatarSize(roleIconSize)
                plyIcon:SetIconSize(roleIconSize, roleIconSize)
                plyIcon:SetSize(roleIconSize, roleIconSize)
            end
        end
    end
end

local function PopulateSubrolesStage(stage, form, stageData)
    local stageFullName = roleinspect.GetStageFullName(stage)

    form:MakeHelp({
        label = "help_" .. stageFullName,
        params = {},
    })

    -- go through the assignment order to display selection info
    for i, assignment in pairs(stageData.extra.upgradeOrder) do
        -- assignment has baserole, subroles, players
        local baserole = assignment.baserole
        local baseroleData = roles.GetByIndex(baserole)

        local baseroleForm = vgui.CreateTTT2Form(
            form,
            DynT("header_inspect_upgrade_order", { name = baseroleData.name }, true)
        )
        baseroleForm:SetExpanded(false) -- default to being collapsed

        local recBaseroleData = stageData.roles[baserole]
        if not recBaseroleData then
            local lbl = vgui.Create("DLabelTTT2", baseroleForm)
            lbl:Dock(TOP)
            lbl:SetText("label_inspect_no_subroles")
            continue
        end
        for j, brAssignment in pairs(recBaseroleData.extra.subroleOrder) do
            local subrole = brAssignment.subrole
            local subroleData = roles.GetByIndex(subrole)
            local srPlys = brAssignment.players
            local recSubroleData = stageData.roles[subrole]
            local decisions = recSubroleData.decisions
            local playerWeights = OptIndex(recSubroleData.extra.playerWeights, 1)

            local subroleForm = vgui.CreateTTT2Form(
                baseroleForm,
                DynT("header_inspect_subroles_order", { name = subroleData.name }, true)
            )

            local function PlyIsHighlighted(ply)
                local isHighlight = false
                for l = 1, #decisions do
                    local dec = decisions[l]
                    if dec.ply == ply then
                        isHighlight = true
                        break
                    end
                end
                return isHighlight
            end

            if playerWeights then
                -- derandomization is enabled, weights are in play
                local playerGraph = vgui.Create("DPlayerGraphTTT2", subroleForm)
                playerGraph:Dock(TOP)

                for k = 1, #srPlys do
                    local ply = srPlys[k]
                    local isHighlight = PlyIsHighlighted(ply)

                    playerGraph:AddPlayer(ply, playerWeights[ply], isHighlight)
                end
            else
                -- derandomization is not enabled, weights are not in play
                -- just show a list of players assigned the role
                local layout = subroleForm:MakeIconLayout()

                for k = 1, #srPlys do
                    local ply = srPlys[k]
                    local isHighlight = PlyIsHighlighted(ply)

                    local plyIcon = vgui.Create("SimpleIconAvatar", layout)
                    plyIcon:SetPlayer(ply)
                    plyIcon:SetTooltip(ply:GetName())
                    plyIcon:SetMouseInputEnabled(true)
                    plyIcon:SetAlpha(isHighlight and 255 or 75)
                    plyIcon:SetAvatarSize(roleIconSize)
                    plyIcon:SetIconSize(roleIconSize, roleIconSize)
                    plyIcon:SetSize(roleIconSize, roleIconSize)
                end
            end
        end
    end
end

local function PopulateFinalStage(stage, form, stageData)
    local stageFullName = roleinspect.GetStageFullName(stage)

    form:MakeHelp({
        label = "help_" .. stageFullName,
        params = {},
    })

    local finalOrderList = form:MakeIconLayout()

    local finalRoles = stageData.extra.afterFinalRoles[1]

    for ply, role in pairs(finalRoles) do
        local roleData = roles.GetByIndex(role)

        local entry = vgui.Create("DPiPPanelTTT2", finalOrderList)
        entry:SetPadding(4)
        entry:SetOuterOffset(4)

        -- first added panel is the main one (player is the main icon)
        local plyIcon = entry:Add("SimpleIconAvatar")
        plyIcon:SetPlayer(ply)
        plyIcon:SetTooltip(ply:GetName())
        plyIcon:SetMouseInputEnabled(true)
        plyIcon:SetAvatarSize(roleIconSize)
        plyIcon:SetIconSize(roleIconSize, roleIconSize)
        plyIcon:SetSize(roleIconSize, roleIconSize)

        -- align bottom-right, preferred-axis X
        ic = entry:Add("DRoleImageTTT2", RIGHT, BOTTOM)
        ic:SetSize(roleIconSize * 2 / 3, roleIconSize * 2 / 3)
        ic:SetMaterial(roleData.iconMaterial)
        ic:SetColor(roleData.color)
        ic:SetValue(true)
        ic:SetMouseInputEnabled(true)
        ic:SetTooltip(roleData.name)
        ic:SetTooltipFixedPosition(0, roleIconSize * 2 / 3)
    end
end

local populateStageTbl = {
    [ROLEINSPECT_STAGE_PRESELECT] = PopulatePreselectRoleStage,
    [ROLEINSPECT_STAGE_LAYERING] = PopulateLayeringRoleStage,
    [ROLEINSPECT_STAGE_BASEROLES] = PopulateBaserolesStage,
    [ROLEINSPECT_STAGE_SUBROLES] = PopulateSubrolesStage,
    [ROLEINSPECT_STAGE_FINAL] = PopulateFinalStage,
}

local function PopulateUnhandledRoleStage(stage, form, stageData)
    form:MakeHelp({
        label = "help_" .. roleinspect.GetStageFullName(stage),
    })

    form:MakeHelp({
        label = "help_roleinspect_unknown_stage",
    })
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
        if self.hasData then
            return
        end

        -- the provided table is the decisions table, or an empty table if the data is not available
        if #roleinspectTable == 0 then
            -- empty table, put in an appropriate message

            local labelHolder = vgui.Create("DPanelTTT2", parent)
            labelHolder:Dock(TOP)
            labelHolder:DockMargin(20, 20, 20, 20)
            local labelNoContent = vgui.Create("DLabelTTT2", labelHolder)
            labelNoContent:SetText("label_roleinspect_no_data")
            labelNoContent:SetFont("DermaTTT2Title")
            labelNoContent:Dock(FILL)
            return
        end

        self.hasData = true

        -- we've recieved data, set up UI
        for stage, stageData in pairs(roleinspectTable) do
            local stageFullName = roleinspect.GetStageFullName(stage)
            local stageForm = vgui.CreateTTT2Form(parent, "header_" .. stageFullName)
            stageForm:SetExpanded(false) -- default to being collapsed

            local populateFn = populateStageTbl[stage] or PopulateUnhandledRoleStage
            populateFn(stage, stageForm, stageData)
        end
    end)
end

function CLGAMEMODESUBMENU:HasButtonPanel()
    return false
end
