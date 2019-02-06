local surface = surface

HUDELEMENT.pos = {
	x = 0,
	y = 0
}

HUDELEMENT.size = {
	w = 0,
	h = 0
}

function HUDELEMENT:Initialize()
	self:PerformLayout()
end

function HUDELEMENT:Draw()

end

function HUDELEMENT:PerformLayout()

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
