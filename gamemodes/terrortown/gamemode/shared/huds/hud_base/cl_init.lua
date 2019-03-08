----------------------------------------------
-- HUD Base class
----------------------------------------------
HUD.elements = {}
HUD.disabledTypes = {}

HUD.previewImage = Material("vgui/ttt/score_logo_2")

local savingKeys = {}

function HUD:GetSavingKeys()
	return savingKeys
end

function HUD:ForceElement(elementID)
	local elem = hudelements.GetStored(elementID)

	if elem and elem.type and not self.elements[elem.type] then
		self.elements[elem.type] = elementID
	end
end

function HUD:GetForcedElements()
	return self.elements
end

function HUD:HideType(elementType)
	table.insert(self.disabledTypes, elementType)
end

function HUD:ShouldShow(elementType)
	local el = self:GetElementByType(elementType)
	if el then
		if el.togglable and not GetGlobalBool("ttt2_elem_toggled_" .. el.id, true) then
			return false
		end

		local parent = el:GetParent()

		if el:IsChild() and parent then
			local parentTbl = hudelements.GetStored(parent)

			return self:ShouldShow(parentTbl.type)
		end

		return true
	else
		return false
	end
end

function HUD:PerformLayout()
	for _, elemName in ipairs(self:GetElements()) do
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
	for _, elemName in ipairs(self:GetElements()) do
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
	self:PerformLayout()
end

function HUD:Initialize()
	-- Initialize elements default values
	for _, v in ipairs(self:GetElements()) do
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
	for _, v in ipairs(self:GetElements()) do
		local elem = hudelements.GetStored(v)
		if elem then
			elem.initialized = true
		else
			Msg("Error: HUD " .. (self.id or "?") .. " has unknown element named " .. v .. "\n")
		end
	end
end

function HUD:GetElementByType(elementType)
	if table.HasValue(self.disabledTypes, elementType) then
		return nil
	end

	local hudelems = self:GetForcedElements()

	-- hide element if its parent element is hidden
	local element = hudelems[elementType]
	local elementTbl = nil

	if not element then
		elementTbl = hudelements.GetTypeElement(elementType)
	else
		elementTbl = hudelements.GetStored(element)
	end

	if elementTbl then
		if elementTbl.disabledUnlessForced then
			return table.HasValue(hudelems, elementTbl.id) and elementTbl or nil
		end

		local parent = elementTbl:GetParent()

		if elementTbl:IsChild() and parent then
			local parentTbl = hudelements.GetStored(parent)

			return self:HasElementType(parentTbl.type) and elementTbl or nil
		end

		return elementTbl
	else
		return nil
	end
end

function HUD:HasElementType(elementType)
	return self:GetElementByType(elementType) ~= nil
end

function HUD:GetElements()
	-- loop through all types and if the hud does not provide an element take the first found instance for the type
	local children, parents = {}, {}
	for _, typ in ipairs(hudelements.GetElementTypes()) do
		local el = self:GetElementByType(typ)
		if el then
			if el:IsChild() then
				children[#children + 1] = el.id
			else
				parents[#parents + 1] = el.id
			end
		end
	end

	-- merge into children because they should be drawn first
	table.Add(children, parents)

	return children
end

function HUD:Loaded()

end

function HUD:Reset()
	for _, elemName in ipairs(self:GetElements()) do
		local elem = hudelements.GetStored(elemName)
		if elem then
			if not elem:IsChild() then
				elem:Reset()
			end
		else
			Msg("Error: Hudelement not found during Reset: " .. elemName)

			return
		end
	end
end

function HUD:SaveData()

	-- save data of all elements of this hud
	for _, elem in ipairs(self:GetElements()) do
		local el = hudelements.GetStored(elem)
		if el then
			el:SaveData()
		end
	end

	SQL.Save("ttt2_huds", self.id, self, self:GetSavingKeys())
end

function HUD:LoadData()
	local skeys = self:GetSavingKeys()

	-- load data of all elements in this hud
	for _, elem in ipairs(self:GetElements()) do
		local el = hudelements.GetStored(elem)
		if el then
			el:LoadData()
		end
	end

	-- load and initialize all HUD data from database
	if SQL.CreateSqlTable("ttt2_huds", skeys) then
		local loaded = SQL.Load("ttt2_huds", self.id, self, skeys)

		if not loaded then
			SQL.Init("ttt2_huds", self.id, self, skeys)
		end
	end
end
