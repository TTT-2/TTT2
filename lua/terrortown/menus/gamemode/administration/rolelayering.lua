CLGAMEMODESUBMENU.base = "base_gamemodesubmenu"

CLGAMEMODESUBMENU.priority = 98
CLGAMEMODESUBMENU.title = "submenu_administration_rolelayering_title"

-- save the forms indexed by role index here to access from hook
CLGAMEMODESUBMENU.forms = {}

local menuReference

function CLGAMEMODESUBMENU:Populate(parent)
	self.baseroleList, self.subroleList = rolelayering.GetLayerableBaserolesWithSubroles()

	-- clear the form table because there might be old data
	self.forms = {}

	self.forms[ROLE_NONE] = vgui.CreateTTT2Form(parent, "baserole_layer")

	rolelayering.RequestDataFromServer(ROLE_NONE)

	for subrole in pairs(self.subroleList) do
		if subrole == roleIndex then continue end

		self.forms[subrole] = vgui.CreateTTT2Form(parent, roles.GetByIndex(subrole).name .. "_layers")

		rolelayering.RequestDataFromServer(subrole)
	end

	-- cache the menu reference
	menuReference = self
end

function CLGAMEMODESUBMENU:PopulateButtonPanel(parent)
	local buttonEditor = vgui.Create("DButtonTTT2", parent)

	buttonEditor:SetText("button_reset")
	buttonEditor:SetSize(100, 45)
	buttonEditor:SetPos(675, 20)
	buttonEditor.DoClick = function(btn)
		--todo
	end
end

function CLGAMEMODESUBMENU:HasButtonPanel()
	return true
end

-- todo:
-- get reference over vgui handler
-- check if open menu is the correct menu
hook.Add("TTT2ReceivedRolelayerData", "received_layer_data", function(role, layerTable)
	if not menuReference then return end

	local roleList, leftRoles = {}, {}

	if role == ROLE_NONE then
		roleList = menuReference.baseroleList
	else
		roleList = menuReference.subroleList[role]
	end

	-- a layer wouldn't make any sense if there are less than 2 available entries / related roles
	if #roleList < 2 then return end

	for cRoles = 1, #roleList do
		local subrole = roleList[cRoles]

		-- don't insert roles that are getting automatically / statically selected
		if subrole == ROLE_TRAITOR or subrole == ROLE_INNOCENT then continue end

		local found = false

		for cLayer = 1, #layerTable do
			local currentLayer = layerTable[cLayer]

			for cEntry = 1, #currentLayer do
				if currentLayer[cEntry] == subrole then
					found = true

					break
				end
			end

			if found then break end
		end

		if found then continue end

		leftRoles[#leftRoles + 1] = subrole
	end

	local basePanel = menuReference.forms[role]:MakePanel()

	local dragbaseScrollPanel = vgui.Create("DScrollPanel", basePanel)
	dragbaseScrollPanel:Dock(FILL)

	-- modify the canvas
	local canvas = dragbaseScrollPanel:Add("DDraggableRolesLayerReceiver")
	canvas:SetLeftMargin(100)
	canvas:Dock(TOP)
	canvas:InitRoles(layerTable)

	-- 9 icons per row
	local rowAmount = math.ceil(#leftRoles / 9)

	local draggableRolesBase = vgui.Create("DDraggableRolesLayerSender", basePanel)
	draggableRolesBase:SetLeftMargin(100)
	draggableRolesBase:Dock(TOP)
	draggableRolesBase:SetTall(rowAmount * 64 + (rowAmount + 1) * 5) -- iconsSize (64) + 2 * padding (5)
	draggableRolesBase:SetPadding(5)
	draggableRolesBase:SetReceiver(canvas)

	for i = 1, #leftRoles do
		local subrole = leftRoles[i]
		local roleData = roles.GetByIndex(subrole)

		local ic = vgui.Create("DRoleImage", draggableRolesBase)
		ic:SetSize(64, 64)
		ic:SetImage("vgui/ttt/dynamic/icon_base")
		ic:SetImageColor(roleData.color)

		ic:SetImage2("vgui/ttt/dynamic/icon_base_base")
		ic:SetImageOverlay("vgui/ttt/dynamic/icon_base_base_overlay")

		ic.subrole = subrole

		ic:SetRoleIconImage(roleData.icon)
		ic:SetTooltip(LANG.TryTranslation(roleData.name))
		ic:Droppable("layerPanel")

		draggableRolesBase:AddPanel(ic)
	end

	canvas:SetSender(draggableRolesBase)

	basePanel:SetTall(100)

	print("roles: " .. role)
	print("ROLE LIST")
	PrintTable(roleList or {})
	print("LEFT ROLES")
	PrintTable(leftRoles or {})
end)
