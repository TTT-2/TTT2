--- @ignore

CLGAMEMODESUBMENU.base = "base_gamemodesubmenu"

CLGAMEMODESUBMENU.priority = 97
CLGAMEMODESUBMENU.title = "submenu_administration_entspawn_title"

local updateButtons = {}
local updateCheckBoxes = {}
local updateHelpBox = nil

-- set up variable change callback
ttt2net.OnUpdate({"entspawnscript", "settings", "blacklisted"}, function(_, newval)
	local state = not tobool(newval)

	for i = 1, #updateCheckBoxes do
		local updateElem = updateCheckBoxes[i]

		if not IsValid(updateElem) then continue end

		updateElem:SetValue(state)
	end

	for i = 1, #updateButtons do
		local updateElem = updateButtons[i]

		if not IsValid(updateElem) then continue end

		updateElem:SetEnabled(state)
	end
end)

ttt2net.OnUpdate({"entspawnscript", "spawnamount"}, function(_, newval, reversePath)
	local paramType = reversePath[1]

	if not IsValid(updateHelpBox) or not paramType then return end

	updateHelpBox:GetParams()[paramType] = newval
end)


function CLGAMEMODESUBMENU:Populate(parent)
	local form = vgui.CreateTTT2Form(parent, "header_entspawn_settings")

	form:MakeHelp({
		label = "help_spawn_editor_info"
	})

	form:MakeHelp({
		label = "help_spawn_editor_enable"
	})

	updateCheckBoxes[1] = form:MakeCheckBox({
		label = "label_dynamic_spawns_enable",
		initial = not tobool(ttt2net.Get({"entspawnscript", "settings", "blacklisted"})),
		OnChange = function(_, value)
			entspawnscript.SetSetting("blacklisted", not value)
		end,
		default = true
	})

	form:MakeHelp({
		label = "help_spawn_editor_hint"
	})

	updateHelpBox = form:MakeHelp({
		label = "help_spawn_editor_spawn_amount",
		params = {
			weapon = ttt2net.Get({"entspawnscript", "spawnamount", "weapon"}) or 0,
			ammo = ttt2net.Get({"entspawnscript", "spawnamount", "ammo"}) or 0,
			player = ttt2net.Get({"entspawnscript", "spawnamount", "player"}) or 0,
			weaponrandom = ttt2net.Get({"entspawnscript", "spawnamount", "weaponrandom"}) or 0,
			weaponmelee = ttt2net.Get({"entspawnscript", "spawnamount", "weaponmelee"}) or 0,
			weaponnade = ttt2net.Get({"entspawnscript", "spawnamount", "weaponnade"}) or 0,
			weaponshotgun = ttt2net.Get({"entspawnscript", "spawnamount", "weaponshotgun"}) or 0,
			weaponheavy = ttt2net.Get({"entspawnscript", "spawnamount", "weaponheavy"}) or 0,
			weaponsniper = ttt2net.Get({"entspawnscript", "spawnamount", "weaponsniper"}) or 0,
			weaponpistol = ttt2net.Get({"entspawnscript", "spawnamount", "weaponpistol"}) or 0,
			weaponspecial = ttt2net.Get({"entspawnscript", "spawnamount", "weaponspecial"}) or 0,
			ammorandom = ttt2net.Get({"entspawnscript", "spawnamount", "ammorandom"}) or 0,
			ammodeagle = ttt2net.Get({"entspawnscript", "spawnamount", "ammodeagle"}) or 0,
			ammopistol = ttt2net.Get({"entspawnscript", "spawnamount", "ammopistol"}) or 0,
			ammomac10 = ttt2net.Get({"entspawnscript", "spawnamount", "ammomac10"}) or 0,
			ammorifle = ttt2net.Get({"entspawnscript", "spawnamount", "ammorifle"}) or 0,
			ammoshotgun = ttt2net.Get({"entspawnscript", "spawnamount", "ammoshotgun"}) or 0,
			playerrandom = ttt2net.Get({"entspawnscript", "spawnamount", "playerrandom"}) or 0
		}
	})

	-- REGISTER UNHIDE FUNCTION TO STOP SPAWN EDITOR
	HELPSCRN.menuFrame.OnShow = function(slf)
		if HELPSCRN:GetOpenMenu() ~= "administration_entspawn" then return end

		entspawnscript.StopEditing()
	end
end

function CLGAMEMODESUBMENU:PopulateButtonPanel(parent)
	local buttonReset = vgui.Create("DButtonTTT2", parent)

	buttonReset:SetText("button_reset")
	buttonReset:SetSize(100, 45)
	buttonReset:SetPos(675, 20)
	buttonReset.DoClick = function()
		entspawnscript.OnLoaded(true)
	end

	local buttonToggle = vgui.Create("DButtonTTT2", parent)

	buttonToggle:SetText("button_start_entspawn_edit")
	buttonToggle:SetSize(180, 45)
	buttonToggle:SetPos(20, 20)
	buttonToggle.DoClick = function(slf)
		entspawnscript.StartEditing()

		HELPSCRN.menuFrame:HideFrame()
	end
	buttonToggle:SetEnabled(not tobool(ttt2net.Get({"entspawnscript", "settings", "blacklisted"})))

	local buttonDelete = vgui.Create("DButtonTTT2", parent)

	buttonDelete:SetText("button_delete_all_spawns")
	buttonDelete:SetSize(195, 45)
	buttonDelete:SetPos(220, 20)
	buttonDelete.DoClick = function(slf)
		entspawnscript.DeleteAllSpawns()
	end
	buttonDelete:SetEnabled(not tobool(ttt2net.Get({"entspawnscript", "settings", "blacklisted"})))

	updateButtons[1] = buttonToggle
	updateButtons[2] = buttonDelete
end

function CLGAMEMODESUBMENU:HasButtonPanel()
	return true
end
