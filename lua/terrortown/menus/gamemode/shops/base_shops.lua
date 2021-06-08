--- @ignore

local TryT = LANG.TryTranslation

CLGAMEMODESUBMENU.priority = 0
CLGAMEMODESUBMENU.title = ""

function CLGAMEMODESUBMENU:Populate(parent)
	local form = vgui.CreateTTT2Form(parent, "header_shop_linker")

	local shopLink = form:MakeComboBox({
		label = "label_shop_linker_set",
		OnChange = function(slf, index, value, rawdata)

			if self.basemenu.fallback[self.roleData.name] == rawdata.name then return end
			self.basemenu.fallback[self.roleData.name] = rawdata.name

			net.Start("shopFallback")
			net.WriteUInt(self.roleData.index, ROLE_BITS)
			net.WriteString(rawdata.name)
			net.SendToServer()

			--vguihandler.InvalidateVSkin()
			vguihandler.Rebuild()
		end
	})
	shopLink:SetSortItems(false)

	local fallback = self.basemenu.fallback[self.roleData.name] or GetGlobalString("ttt_" .. self.roleData.abbr .. "_shop_fallback")

	-- Add own Data for creating own shop
	shopLink:AddChoice(TryT("create_own_shop"), self.roleData, fallback == self.roleData.name)

	-- Since these are no simple roles, the choices have to be added manually
	shopLink:AddChoice(TryT("shop_default"), {name = SHOP_UNSET, abbr = "shop_default", color = self.roleData.color}, fallback == SHOP_UNSET)
	shopLink:AddChoice(TryT("shop_disabled"), {name = SHOP_DISABLED, abbr = "disable", color = self.roleData.color}, fallback == SHOP_DISABLED)

	for _, roleData in pairs(self.roles) do
		if roleData.index == ROLE_NONE or roleData.index == self.roleData.index then continue end
		shopLink:AddChoice(TryT("shop_link") .. ": " .. TryT(roleData.name), roleData, fallback == roleData.name)
	end

	-- Add all items for custom shop
	if fallback == self.roleData.name then
		
	end
end