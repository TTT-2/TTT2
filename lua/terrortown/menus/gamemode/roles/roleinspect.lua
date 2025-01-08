--- @ignore

local table = table
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

local function MakeRoleIcon(stage, roleIcons, role, decision, paramFmt)
    local roleData = roles.GetByIndex(role)

    local ic = roleIcons:Add("DRoleImageTTT2")
    ic:SetSize(32, 32)
    ic:SetMaterial(roleData.iconMaterial)
    ic:SetColor(roleData.color)
    ic:SetEnabled(decision.decision == ROLEINSPECT_DECISION_CONSIDER)
    ic:SetMouseInputEnabled(true)

    local stageShortName = roleinspect.GetStageName(stage)

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

local function PopulatePreselectRoleStage(stage, form, stageData)
    local stageFullName = roleinspect.GetStageFullName(stage)

    form:MakeHelp({
        label = "help_" .. stageFullName,
        params = {
            maxPlayers = stageData.extra.maxPlayers[1]
        }
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
            maxRoles = OptIndex(stageData.extra.maxRoles, 1),
            maxBaseroles = OptIndex(stageData.extra.maxBaseroles, 1),
        }
    })

    -- we want to create a setup similar to the normal role layering UI to present this
    local finalSelectableRoles = stageData.extra.finalSelectableRoles[1]

    local function ComputeActualUnlayered(rawAvailable, layers, unlayeredInitial)
        local unlayered = unlayeredInitial or {}
        local unlayeredInv = {}
        for i,role in pairs(unlayered) do
            unlayeredInv[role] = i
        end

        -- actually build the base unlayered list
        for _,role in pairs(rawAvailable) do
            unlayered[#unlayered + 1] = role
            unlayeredInv[role] = #unlayered
        end

        if layers then
            -- then go through the layers to remove from the unlayered list ones which are layered
            for _,layer in pairs(layers) do
                for _,role in pairs(layer) do
                    local idx = unlayeredInv[role]
                    table.remove(unlayered, idx)
                end
            end
        end

        return unlayered
    end

    local function ProcessLayer(parent, layer)
        local icons = parent:MakeIconLayout()
        for _,role in pairs(layer) do
            local decision
            local roleData = stageData.roles[role]
            if not roleData and (role == ROLE_INNOCENT or role == ROLE_TRAITOR) then
                decision = {
                    decision = ROLEINSPECT_DECISION_CONSIDER,
                    reason = ROLEINSPECT_REASON_FORCED,
                }
            else
                decision = roleData and roleData.decisions[1] or {
                    decision = ROLEINSPECT_DECISION_NO_CONSIDER,
                    reason = ROLEINSPECT_REASON_NOT_LAYERED
                }
            end
            MakeRoleIcon(stage, icons, role, decision, function(params)
                params.finalCount = tostring(finalSelectableRoles[role])
            end)
        end
    end

    -- to that end, we want to compute the layered/unlayered baseroles
    local baseroleLayers = stageData.extra.afterBaseRoleLayers[1]
    local unlayeredBaseroles = ComputeActualUnlayered(
        stageData.extra.afterAvailableBaseRoles[1],
        baseroleLayers,
        { ROLE_INNOCENT, ROLE_TRAITOR }
    )

    -- TODO: make these layers look right

    local baseroleLayersForm = vgui.CreateTTT2Form(form, "header_inspect_layers_baseroles")

    -- now create the icons for each of the layers
    for _,layer in pairs(baseroleLayers) do
        ProcessLayer(baseroleLayersForm, layer)
    end

    -- then for unlayered
    ProcessLayer(baseroleLayersForm, unlayeredBaseroles)

    local availableSubroles = stageData.extra.afterAvailableSubRoles[1]
    local subroleLayers = stageData.extra.afterSubRoleLayers[1]

    -- generate the same thing for the subroles of each baserole
    for baserole,subroles in pairs(availableSubroles) do
        local layers = subroleLayers[baserole]
        local unlayeredSubroles = ComputeActualUnlayered(subroles, layers)
        local baseroleData = roles.GetByIndex(baserole)

        local layersForm = vgui.CreateTTT2Form(form, DynT(
            "header_inspect_layers_subroles",
            { baserole = baseroleData.name },
            true
        ))

        -- first, the layers
        if layers then
            for _,layer in pairs(layers) do
                ProcessLayer(layersForm, layer)
            end
        end

        -- then the unlayered
        ProcessLayer(layersForm, unlayeredSubroles)
    end

    -- TODO: display subroleSelectBaseroleOrder in a reasonable way

end

local function PopulateUnhandledRoleStage(stage, form, stageData)
    form:MakeHelp({
        label = "help_" .. roleinspect.GetStageFullName(stage),
    })

    -- TODO: read decisions to try to create a crude approximation of the data in
    -- the case of new stages
end

local populateStageTbl = {
    [ROLEINSPECT_STAGE_PRESELECT] = PopulatePreselectRoleStage,
    [ROLEINSPECT_STAGE_LAYERING] = PopulateLayeringRoleStage,
}

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
            labelNoContent:SetPos(20, 100)
            labelNoContent:FitContents()
            return
        end

        self.hasData = true

        -- we've recieved data, set up UI
        for stage, stageData in pairs(roleinspectTable) do
            local stageFullName = roleinspect.GetStageFullName(stage)
            local stageForm = vgui.CreateTTT2Form(parent, "header_" .. stageFullName)

            local populateFn = populateStageTbl[stage] or PopulateUnhandledRoleStage
            populateFn(stage, stageForm, stageData)
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