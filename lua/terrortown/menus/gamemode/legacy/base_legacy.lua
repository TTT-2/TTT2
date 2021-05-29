--- @ignore

CLGAMEMODESUBMENU.priority = 0
CLGAMEMODESUBMENU.title = ""

function CLGAMEMODESUBMENU:Populate(parent)
	local psizeX, psizeY = parent:GetSize()
	local ppadLeft, _, ppadRight, _ = parent:GetDockPadding()

	self.panel:SetParent(parent)
	self.panel:SetSize(
		psizeX - ppadLeft - ppadRight,
		psizeY - 2 * HELPSCRN.padding
	)
	self.panel:Dock(FILL)
end
