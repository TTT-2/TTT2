local surface = surface

HUDELEMENT.pos = {
	x = 0,
	y = 0
}

HUDELEMENT.size = {
	w = 0,
	h = 0
}

HUDELEMENT.parent = nil
HUDELEMENT.parent_is_type = nil
HUDELEMENT.children = {}

function HUDELEMENT:Initialize()
	self:PerformLayout()
end

function HUDELEMENT:Draw()

end

function HUDELEMENT:PerformLayout()
	for elem in self.children do
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
