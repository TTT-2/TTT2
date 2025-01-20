--- @ignore

local TryT = LANG.TryTranslation
local ParT = LANG.GetParamTranslation

CLGAMEMODESUBMENU.base = "base_gamemodesubmenu"

CLGAMEMODESUBMENU.priority = 96
CLGAMEMODESUBMENU.title = "submenu_roles_rolelayering_title"
CLGAMEMODESUBMENU.searchable = false

-- save the forms indexed by role index here to access from hook
CLGAMEMODESUBMENU.forms = {}

function CLGAMEMODESUBMENU:Populate(parent)
    -- first add a tutorial form
    local form = vgui.CreateTTT2Form(parent, "header_rolelayering_info")

    form:MakeHelp({
        label = "help_rolelayering_roleselection",
    })

    form:MakeHelp({
        label = "help_rolelayering_layers",
    })

    form:MakeHelp({
        label = "help_rolelayering_enable",
    })

    self.baseroleList, self.subroleList = rolelayering.GetLayerableBaserolesWithSubroles()

    -- clear the form table because there might be old data
    self.forms = {}

    self.forms[ROLE_NONE] = vgui.CreateTTT2Form(parent, "header_rolelayering_baserole")

    rolelayering.RequestDataFromServer(ROLE_NONE)

    for subrole in pairs(self.subroleList) do
        self.forms[subrole] = vgui.CreateTTT2Form(
            parent,
            ParT("header_rolelayering_role", { role = TryT(roles.GetByIndex(subrole).name) })
        )

        rolelayering.RequestDataFromServer(subrole)
    end
end

function CLGAMEMODESUBMENU:PopulateButtonPanel(parent)
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
end

function CLGAMEMODESUBMENU:HasButtonPanel()
    return true
end

hook.Add("TTT2ReceivedRolelayerData", "received_layer_data", function(role, layerTable)
    local menuReference = HELPSCRN.submenuClass

    if not menuReference or HELPSCRN:GetOpenMenu() ~= "roles_rolelayering" then
        return
    end

    menuReference.forms[role]:Clear()

    local roleList, leftRoles = {}, {}

    if role == ROLE_NONE then
        roleList = menuReference.baseroleList
    else
        roleList = menuReference.subroleList[role]
    end

    -- a layer wouldn't make any sense if there are less than 2 available entries / related roles
    if #roleList < 2 then
        return
    end

    for cRoles = 1, #roleList do
        local subrole = roleList[cRoles]

        -- don't insert roles that are getting automatically / statically selected
        if subrole == ROLE_TRAITOR or subrole == ROLE_INNOCENT then
            continue
        end

        local found = false

        for cLayer = 1, #layerTable do
            local currentLayer = layerTable[cLayer]

            for cEntry = 1, #currentLayer do
                if currentLayer[cEntry] == subrole then
                    found = true

                    break
                end
            end

            if found then
                break
            end
        end

        if found then
            continue
        end

        leftRoles[#leftRoles + 1] = subrole
    end

    local basePanel = menuReference.forms[role]:MakeIconLayout()

    local dragSender = basePanel:Add("DRoleLayeringSenderTTT2")
    dragSender:SetLeftMargin(108)
    dragSender:Dock(TOP)
    dragSender:SetPadding(5)
    dragSender:MakeDroppable("drop_group_" .. role)

    -- modify the dragReceiver
    local dragReceiver = basePanel:Add("DRoleLayeringReceiverTTT2")
    dragReceiver:SetLeftMargin(108)
    dragReceiver:Dock(TOP)
    dragReceiver:SetPadding(5)
    dragReceiver:MakeDroppable("drop_group_" .. role)
    dragReceiver:InitRoles(layerTable)
    dragReceiver.OnLayerUpdated = function(slf)
        rolelayering.SendDataToServer(role, slf.layerList)
    end

    dragSender:SetReceiver(dragReceiver)

    for i = 1, #leftRoles do
        local subrole = leftRoles[i]
        local roleData = roles.GetByIndex(subrole)

        local ic = vgui.Create("DRoleImageTTT2", dragSender)
        ic:SetSize(64, 64)
        ic:SetMaterial(roleData.iconMaterial)
        ic:SetColor(roleData.color)
        ic:SetTooltip(roleData.name)
        ic:SetTooltipFixedPosition(0, 64)
        ic:SetServerConVar("ttt_" .. roleData.name .. "_enabled")
        ic:SetIsActiveIndicator(true)

        ic.subrole = subrole

        dragSender:Add(ic)
    end

    dragReceiver:SetSender(dragSender)
end)
