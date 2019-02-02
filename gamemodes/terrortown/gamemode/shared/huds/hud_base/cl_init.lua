----------------------------------------------
-- HUD Base class
----------------------------------------------
HUD.elements = {}
HUD.hiddenElements = {}

function HUD:ForceHUDElement( elementID )
	local elem = hudelements.Get(elementID)

	if elem.type and not HUD.elements[elem.type] then
		HUD.elements[elem.type] = elementID
	end
end

function HUD:GetForcedHUDElements()
	return HUD.elements
end

function HUD:HideHUDType( elementType )
	table.insert( hiddenElements, elementType )
end

function HUD:ShouldShow( elementType )
	return table.HasValue(hiddenElements, elementType)
end

function HUD:Initialize()
	-- Use this method to set the elements default positions etc
end

function HUD:GetHUDElements()
	local tbl = {}
	local hudelems = self:GetForcedHUDElements()

	-- loop through all types and if the hud does not provide an element take the first found instance for the typ
	for _, typ in ipairs(hudelements.GetElementTypes()) do
		tbl[#tbl + 1] = hudelems[typ] or hudelements.GetTypeElement(typ)
	end

	return tbl
end
