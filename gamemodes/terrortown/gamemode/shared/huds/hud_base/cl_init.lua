----------------------------------------------
-- HUD Base class
----------------------------------------------
HUD.elements = {}
HUD.hiddenElements = {}

HUD.previewImage = Material("vgui/ttt/score_logo_2")

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

HUD.savingKeys = {}

function HUD:Initialize()
	print("Called HUD", self.id or "?")

	-- load and initialize all HUD data from database
	if SQL.CreateSqlTable("ttt2_huds", self.savingKeys) then
		local loaded = SQL.Load("ttt2_huds", self.id, self, self.savingKeys)

		if not loaded then
			SQL.Init("ttt2_huds", self.id, self, self.savingKeys)
		end
	end

	-- Use this method to set the elements default positions etc
	-- Initialize elements default values
	for _, v in ipairs(self:GetHUDElements()) do
		local elem = hudelements.GetStored(v)
		if elem then
			elem:Initialize()
			elem:SetDefaults()

			-- load and initialize all HUDELEMENT data from database
			if SQL.CreateSqlTable("ttt2_hudelements", elem.savingKeys) then
				local loaded = SQL.Load("ttt2_hudelements", elem.id, elem, elem.savingKeys)

				if not loaded then
					SQL.Init("ttt2_hudelements", elem.id, elem, elem.savingKeys)
				end
			end

			elem:Load()

			elem.initialized = true
		else
			Msg("Error: HUD " .. (self.id or "?") .. " has unkown element named " .. v .. "\n")
		end
	end

	self:PerformLayout()
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
