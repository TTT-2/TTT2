local surface = surface

HUDELEMENT.pos = {
	x = 0,
	y = 0
}

HUDELEMENT.size = {
	w = 0,
	h = 0
}

HUDELEMENT.defaults = {
	pos = table.Copy(HUDELEMENT.pos),
	size = table.Copy(HUDELEMENT.size)
}

HUDELEMENT.parent = nil
HUDELEMENT.parent_is_type = nil
HUDELEMENT.children = {}

function HUDELEMENT:Initialize()
	-- Use this to set default values or set child relations.
end

function HUDELEMENT:Draw()
	-- Override this function to draw your element
end

--[[------------------------------
	PerformLayout()
	Desc: This function is called after all Initialize() functions.
--]]-------------------------------
function HUDELEMENT:PerformLayout()
	for elem in ipairs(self.children) do
		local elemtbl = hudelements.GetStored(elem)
		if elemtbl then
			elemtbl:PerformLayout()
		end
	end
end

function HUDELEMENT:GetPos()
	return self.pos
end

function HUDELEMENT:SetPos(x, y)
	self.pos.x = x
	self.pos.y = y
end

function HUDELEMENT:GetSize()
	return self.size
end

function HUDELEMENT:SetSize(w, h)
	self.size.w = w
	self.size.h = h
end

function HUDELEMENT:GetParent()
	return self.parent, self.parent_is_type
end

--[[------------------------------
	SetParent()
	Desc: This function is used internally and only has the full effect if called by the
		  hudelements.RegisterChildRelation() function.
		  INTERNAL FUNCTION!!!
--]]-------------------------------
function HUDELEMENT:SetParent(parent, is_type)
	self.parent = parent
	self.parent_is_type = is_type
end

function HUDELEMENT:AddChild(elementid)
	if not table.HasValue(self.children, elementid) then
		table.insert(self.children, elementid)
	end
end

function HUDELEMENT:IsChild()
	return self.parent ~= nil
end

function HUDELEMENT:IsParent()
	return #self.children > 0
end

function HUDELEMENT:GetChildren()
	return self.children
end

function HUDELEMENT:IsInPos(x, y)
	local minX, minY = self.pos.x, self.pos.y
	local maxX, maxY = minX + self.size.w, minY + self.size.h

	return x <= maxX and x >= minX and y <= maxY and y >= minY
end

function HUDELEMENT:DrawSize()
	local x, y, w, h = self.pos.x, self.pos.y, self.size.w, self.size.h

	surface.SetDrawColor(255, 0, 0, 255)
	surface.DrawLine(x - 1, y - 1, x + w + 1, y - 1) -- top
	surface.DrawLine(x + w + 1, y - 1, x + w + 1, y + h + 1) -- right
	surface.DrawLine(x - 1, y + h + 1, x + w + 1, y + h + 1) -- bottom
	surface.DrawLine(x - 1, y - 1, x - 1, y + h + 1) -- left
end

function HUDELEMENT:SetDefaults()
	self.defaults.pos = table.Copy(self.pos)
	self.defaults.size = table.Copy(self.size)
end

function HUDELEMENT:Reset()
	local defaultPos = self.defaults.pos
	local defaultSize = self.defaults.size

	self:SetPos(defaultPos.x, defaultPos.y)
	self:SetSize(defaultSize.w, defaultSize.h)

	self:PerformLayout()
end

HUDELEMENT.savingKeys = {
	pos = {typ = "pos"},
	size = {typ = "size"}
}

function HUDELEMENT:Save()

end

function HUDELEMENT:Load()

end
