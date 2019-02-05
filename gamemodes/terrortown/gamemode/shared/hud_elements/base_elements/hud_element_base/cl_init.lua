HUDELEMENT.pos = {
	x = 0,
	y = 0
}

HUDELEMENT.maxPos = {
	x = 0,
	y = 0
}

HUDELEMENT.minPos = {
	x = 0,
	y = 0
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

function HUDELEMENT:IsInPos(x, y)
	return self.maxPos.x >= x and self.minPos.x <= x and self.maxPos.y >= y and self.minPos.y <= y
end
