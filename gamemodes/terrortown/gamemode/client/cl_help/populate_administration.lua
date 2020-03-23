local materialIcon = Material("vgui/ttt/vskin/helpscreen/guide")

local function PopulateHUDPanel(parent)
	local form = CreateForm(parent, "header_hud_administration")

	local restrictedHUDs = HUDManager.GetModelValue("restrictedHUDs")
	local hudList = huds.GetList()
	local validHUDsDefault = {}
	local validHUDsRestriction = {[1] = "None"}

	for i = 1, #hudList do
		validHUDsDefault[#validHUDsDefault + 1] = hudList[i].id
		validHUDsRestriction[#validHUDsRestriction + 1] = hudList[i].id
	end

	form:MakeHelp({
		label = "help_hud_default_desc"
	})

	form:MakeComboBox({
		label = "label_hud_default",
		choices = validHUDsDefault,
		selectName = HUDManager.GetModelValue("defaultHUD") or "None",
		onSelect = function(_, _, value)
			net.Start("TTT2DefaultHUDRequest")
			net.WriteString(value == "None" and "" or value)
			net.SendToServer()
		end
	})

	form:MakeHelp({
		label = "help_hud_forced_desc"
	})

	form:MakeComboBox({
		label = "label_hud_force",
		choices = validHUDsRestriction,
		selectName = HUDManager.GetModelValue("forcedHUD") or "None",
		onSelect = function(_, _, value)
			net.Start("TTT2ForceHUDRequest")
			net.WriteString(value == "None" and "" or value)
			net.SendToServer()
		end
	})

	local form2 = CreateForm(parent, "header_hud_enabled")

	form2:MakeHelp({
		label = "help_hud_enabled_desc"
	})

	for i = 1, #hudList do
		local hud = hudList[i]

		form2:MakeCheckBox({
			label = hud.id,
			initial = not table.HasValue(restrictedHUDs, hud.id),
			onChange = function(_, value)
				net.Start("TTT2RestrictHUDRequest")
				net.WriteString(hud.id)
				net.WriteBool(not value)
				net.SendToServer()
			end
		})
	end
end

HUDManager.OnUpdateAttribute("restrictedHUDs", function()
	if HELPSCRN:GetOpenMenu() ~= "ttt2_administration_hud" then return end

	-- rebuild the content area so that data is refreshed
	-- based on the newly restricted HUDs
	VHDL.Rebuild()
end)

local function PopulateRandomShopPanel(parent)

end

---
-- Function to populate main menu
-- @param table helpData The main menu data object
-- @param string id The unique id of this menu element
-- @internal
-- @realm client
HELPSCRN.populate["ttt2_administration"] = function(helpData, id)
	local administrationData = helpData:RegisterSubMenu(id)

	administrationData:SetTitle("menu_administration_title")
	administrationData:SetDescription("menu_administration_description")
	administrationData:SetIcon(materialIcon)

	administrationData:AdminOnly(true)
end

---
-- Function to populate sub menu
-- @param table helpData The sub menu data object
-- @param string id The unique id of this menu element
-- @internal
-- @realm client
HELPSCRN.subPopulate["ttt2_administration"] = function(helpData, id)
	local hudData = helpData:PopulateSubMenu(id .. "_hud")

	hudData:SetTitle("submenu_administration_hud_title")
	hudData:PopulatePanel(PopulateHUDPanel)

	local shopData = helpData:PopulateSubMenu(id .. "_random_shop")

	shopData:SetTitle("submenu_administration_random_shop")
	shopData:PopulatePanel(PopulateRandomShopPanel)
end
