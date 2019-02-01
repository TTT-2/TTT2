----------------------------------------------
-- HUD Base class
----------------------------------------------
local elements = {}

function HUD:AddHUDElement( elementID )
	if not elements[elementID] then
		elements[elementID] = true
	end
end

function HUD:GetHUDElements()
	return elements
end

function HUD:HideHUDElement( elementID )
	elements[elementID] = false
end

function HUD:Initialize()
	-- Use this method to set the elements default positions etc
end
