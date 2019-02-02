----------------------------------------------
-- HUD Base class
----------------------------------------------
HUD.elements = {}
HUD.hiddenElements = {}

function HUD:ForceHUDElement( elementID )
	local elem = hudelements.Get(elementID)

	if elem.type and not self.elements[elem.type] then
		self.elements[elem.type] = elementID
	end
end

function HUD:GetForcedHUDElements()
	return self.elements
end

function HUD:HideHUDType( elementType )
	table.insert( hiddenElements, elementType )
end

function HUD:ShouldShow( elementType )
	return not table.HasValue(hiddenElements, elementType)
end

function HUD:Initialize()
	print("Called HUD", self.id or "?")

	-- Use this method to set the elements default positions etc
	-- Initialize elements default values
	for _, v in ipairs(self:GetHUDElements()) do
		local elem = hudelements.GetStored(v)
		if elem then
			elem:Initialize()
		else
			Msg("Error: HUD has unkown element named " .. v .. "\n")
		end
	end
end

function HUD:GetHUDElements()
	local tbl = {}
	local hudelems = self:GetForcedHUDElements()

	-- loop through all types and if the hud does not provide an element take the first found instance for the type
	for _, typ in ipairs(hudelements.GetElementTypes()) do
		tbl[#tbl + 1] = hudelems[typ] or hudelements.GetTypeElement(typ)
	end

	return tbl
end
