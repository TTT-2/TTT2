local pos = {
	x = 0,
	y = 0
}

function HUDMODULE:Initialize()

end

function HUDMODULE:Draw()

end

function HUDMODULE:PerformLayout()

end

function HUDMODULE:GetPos()
	return pos
end

function HUDMODULE:SetPos(x, y)
	pos.x = x
	pos.y = y
end
