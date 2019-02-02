HUDELEMENT.pos = {
	x = 0,
	y = 0
}

function HUDELEMENT:Initialize()
	print("Called HUDELEMENT", self.id or "?")

	self:PerformLayout()
end

function HUDELEMENT:Draw()

end

function HUDELEMENT:PerformLayout()
	print("Called PerformLayout", self.id or "?")

end

function HUDELEMENT:GetPos()
	return pos
end

function HUDELEMENT:SetPos(x, y)
	self.pos.x = x
	self.pos.y = y
end
