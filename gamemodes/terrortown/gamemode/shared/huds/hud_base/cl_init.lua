----------------------------------------------
-- HUD Base class
----------------------------------------------
HUD.elements = {}
HUD.hiddenElements = {}

HUD.previewImage = Material("vgui/ttt/score_logo_2")

local savingKeys = {}

function HUD:GetSavingKeys()
	return savingKeys
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
	if table.HasValue(self.hiddenElements, elementType) then
		return false
	end

	local hudelems = self:GetForcedHUDElements()

	-- hide element if its parent element is hidden
	local element = hudelems[elementType]
	local elementTbl = nil

	if not element then
		elementTbl = hudelements.GetTypeElement(elementType)
	else
		elementTbl = hudelements.GetStored(element)
	end

	if elementTbl then
		if elementTbl.togglable and not GetGlobalBool("ttt2_elem_toggled_" .. elementTbl.id, true) then
			return false
		end

		if elementTbl.disabledUnlessForced then
			return table.HasValue(hudelems, elementTbl.id)
		end

		local parent = elementTbl:GetParent()

		if elementTbl:IsChild() and parent then
			local parentTbl = hudelements.GetStored(parent)

			return self:ShouldShow(parentTbl.type)
		end

		return true
	else
		return false
	end
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

function HUD:ResolutionChanged()
	for _, elemName in ipairs(self:GetHUDElements()) do
		local elem = hudelements.GetStored(elemName)
		if elem then
			if not elem:IsChild() then
				elem:ResolutionChanged()
			end
		else
			Msg("Error: Hudelement not found during ResolutionChanged: " .. elemName)

			return
		end
	end
end

function HUD:Initialize()
	-- Initialize elements default values
	for _, v in ipairs(self:GetHUDElements()) do
		local elem = hudelements.GetStored(v)
		if elem then
			if not elem:IsChild() then
				elem:Initialize()
			end
		else
			Msg("Error: HUD " .. (self.id or "?") .. " has unknown element named " .. v .. "\n")
		end
	end

	self:PerformLayout()

	-- Initialize elements default values
	for _, v in ipairs(self:GetHUDElements()) do
		local elem = hudelements.GetStored(v)
		if elem then
			elem.initialized = true
		else
			Msg("Error: HUD " .. (self.id or "?") .. " has unknown element named " .. v .. "\n")
		end
	end
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
