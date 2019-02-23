----------------------------------------------
-- HUD Base class
----------------------------------------------
HUD.elements = {}
HUD.hiddenElements = {}

HUD.previewImage = Material("vgui/ttt/score_logo_2")

function HUD:GetSavingKeys()
	return {}
end

function HUD:ForceHUDElement(elementID)
	local elem = hudelements.GetStored(elementID)

	if elem and elem.type and not self.elements[elem.type] then
		self.elements[elem.type] = elementID
	end
end

function HUD:GetForcedHUDElements()
	return self.elements
end

function HUD:HideHUDType(elementType)
	table.insert(self.hiddenElements, elementType)
end

function HUD:ShouldShow(elementType)
	return not table.HasValue(self.hiddenElements, elementType)
end

function HUD:PerformLayout()
	for _, elemName in ipairs(self:GetHUDElements()) do
		local elem = hudelements.GetStored(elemName)
		if elem then
			if not elem:IsChild() then
				elem:PerformLayout()
			end
		else
			Msg("Error: Hudelement not found during PerformLayout: " .. elemName)

			return
		end
	end
end

function HUD:Initialize()
	-- Use this method to set the elements default positions etc
end

function HUD:GetHUDElements()
	local tbl = {}
	local hudelems = self:GetForcedHUDElements()

	-- loop through all types and if the hud does not provide an element take the first found instance for the type
	for _, typ in ipairs(hudelements.GetElementTypes()) do
		if self:ShouldShow(typ) then
			tbl[#tbl + 1] = hudelems[typ] or hudelements.GetTypeElement(typ).id
		end
	end

	return tbl
end

function HUD:GetHUDElementByType(typ)
	if not typ then return end

	local hudelem = self:GetForcedHUDElements()[typ]
	if hudelem then
		hudelem = hudelements.GetStored(hudelem)
		if hudelem then
			return hudelem
		end
	end

	local allelems = hudelements.GetTypeElement(typ)
	if allelems then
		return allelems
	end
end

function HUD:Loaded()

end

function HUD:Reset()

end
