--- @ignore

CLGAMEMODESUBMENU.base = "base_gamemodesubmenu"

CLGAMEMODESUBMENU.priority = 99
CLGAMEMODESUBMENU.title = "submenu_guide_roles_title"

function CLGAMEMODESUBMENU:Populate(parent)
	local line1 = vgui.Create("DLabel", parent)
	line1:SetPos(40, 40)
	line1:SetFont("DermaLarge")
	line1:SetText("Nothing here yet!")
	line1:SizeToContents()

	local line2 = vgui.Create("DLabel", parent)
	line2:SetPos(40, 40)
	line2:MoveBelow(line1, 10)
	line2:SetFont("Trebuchet24")
	line2:SetText("This is work in progress, help us by contributing to the project on GitHub.")
	line2:SizeToContents()
end
