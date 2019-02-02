----------------------------------------------
-- HUD Base class
----------------------------------------------
HUD.elements = {}
HUD.hiddenElements = {}

function HUD:AddHUDElement( elementID )
	local elem = hudelements.Get(elementID)

	if not HUD.elements[elem.type] then
		HUD.elements[elem.type] = elementID
	end
end

function HUD:GetHUDElements()
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
