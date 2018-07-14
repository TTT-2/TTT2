Equipment = Equipment or {}

function GetEquipmentForRole(role)
	local fallbackTable = GetShopFallbackTable(role)
	if fallbackTable then
		return fallbackTable
	end

	local fallback = GetShopFallback(role)
	
	-- need to build equipment cache?
	if not Equipment[fallback] then
		-- start with all the non-weapon goodies
		local tbl = table.Copy(EquipmentItems[fallback])

		-- find buyable weapons to load info from
		for _, v in ipairs(weapons.GetList()) do
			if v and not v.Doublicated and v.CanBuy and table.HasValue(v.CanBuy, fallback) then
				local data = v.EquipMenuData or {}
				local base = {
					id		 = WEPS.GetClass(v),
					name	 = v.ClassName or "Unnamed",
					PrintName= data.name or data.PrintName or v.PrintName or v.ClassName or "Unnamed",
					limited	 = v.LimitedStock,
					kind	 = v.Kind or WEAPON_NONE,
					slot	 = (v.Slot or 0) + 1,
					material = v.Icon or "vgui/ttt/icon_id",
					-- the below should be specified in EquipMenuData, in which case
					-- these values are overwritten
					type	 = "Type not specified",
					model	 = "models/weapons/w_bugbait.mdl",
					desc	 = "No description specified."
				}

				-- Force material to nil so that model key is used when we are
				-- explicitly told to do so (ie. material is false rather than nil).
				if data.modelicon then
					base.material = nil
				end

				table.Merge(base, data)
				table.insert(tbl, base)
			end
		end

		-- mark custom items
		for _, i in pairs(tbl) do
			if i and i.id then
				i.custom = not table.HasValue(DefaultEquipment[fallback], i.id) -- TODO
			end
		end

		Equipment[fallback] = tbl
	end
	
	return Equipment[fallback] or {}
end

if not hook.Run("TTT_PreventUseMainShopSystem") then
	include("cl_equip_main.lua")
end
