--- @ignore

CLSHOPMENU.base = "base_shopmenu"

CLSHOPMENU.icon = Material("vgui/ttt/vskin/roundend/info") --TODO: Material
CLSHOPMENU.title = "title_shop_info"
CLSHOPMENU.priority = 100

function CLSHOPMENU:Populate(parent)
	local sizes = CLSHOP.sizes

	local frameBoxes = vgui.Create("DIconLayout", parent)
	frameBoxes:Dock(FILL)
end

function CLSHOPMENU:PopulateButtonPanel(parent)

end
