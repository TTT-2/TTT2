--- @ignore

local TryT = LANG.TryTranslation

CLGAMEMODESUBMENU.priority = 0
CLGAMEMODESUBMENU.title = ""

function CLGAMEMODESUBMENU:Populate(parent)
	local form = vgui.CreateTTT2Form(parent, "header_shop_linker")

	local shopLink = form:MakeComboBox({
		label = "label_shop_linker_set",
		OnChange = function(slf, index, value, rawdata)
			if self.oldValue == value then return end
			self.oldValue = value
			--vguihandler.InvalidateVSkin()
			--vguihandler.Rebuild()
		end
	})
	shopLink:SetSortItems(false)

	--self.oldValue = TryT("shop_default")

	-- Add own Data for creating own shop
	shopLink:AddChoice(TryT("create_own_shop"), self.roleData, false)

	-- Since these are no simple roles, the choices have to be added manually
	shopLink:AddChoice(TryT("shop_default"), {name = SHOP_UNSET, abbr = "shop_default", color = self.roleData.color}, false)
	shopLink:AddChoice(TryT("shop_disabled"), {name = SHOP_DISABLED, abbr = "disable", color = self.roleData.color}, false)

	for _, roleData in pairs(self.roles) do
		if roleData.index == ROLE_NONE or roleData.index == self.roleData.index then continue end
		shopLink:AddChoice(TryT("shop_link") .. ": " .. TryT(roleData.name), roleData, false)
	end
end