local surface = surface

HUDELEMENT.basepos = {
	x = 0,
	y = 0
}

HUDELEMENT.pos = {
	x = 0,
	y = 0
}

HUDELEMENT.size = {
	w = 0,
	h = 0
}

HUDELEMENT.defaults = {
	basepos = table.Copy(HUDELEMENT.basepos),
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
	for _, elem in ipairs(self.children) do
		local elemtbl = hudelements.GetStored(elem)
		if elemtbl then
			elemtbl:PerformLayout()
		end
	end
end

function HUDELEMENT:GetBasePos()
	return self.basepos
end

function HUDELEMENT:SetBasePos(x, y)
	self.basepos.x = x
	self.basepos.y = y
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
	local nw, nh = w < 0, h < 0
	if nw or nh then
		local basepos = self:GetBasePos()
		local pos = self:GetPos()

		if nw then
			w = -w

			self:SetPos(basepos.x - w, pos.y)
		end

		if nh then
			h = -h

			self:SetPos(pos.x, basepos.y - h)
		end
	end

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

function HUDELEMENT:IsInRange(x, y, range)
	range = range or 0

	local x, y = self.pos.x, self.pos.y
	local w, h = self.size.w, self.size.h

	return x - range <= x + w and x + range >= x and y - range <= y + h and y + range >= y
end

function HUDELEMENT:IsInPos(x, y)
	return self:IsInRange(x, y)
end

function HUDELEMENT:DrawSize()
	local x, y, w, h = self.pos.x, self.pos.y, self.size.w, self.size.h

	surface.SetDrawColor(255, 0, 0, 255)
	surface.DrawLine(x - 1, y - 1, x + w + 1, y - 1) -- top
	surface.DrawLine(x - 2, y - 2, x + w + 2, y - 2) -- top

	surface.DrawLine(x + w + 1, y - 1, x + w + 1, y + h + 1) -- right
	surface.DrawLine(x + w + 2, y - 2, x + w + 2, y + h + 2) -- right

	surface.DrawLine(x - 1, y + h + 1, x + w + 1, y + h + 1) -- bottom
	surface.DrawLine(x - 2, y + h + 2, x + w + 2, y + h + 2) -- bottom

	surface.DrawLine(x - 1, y - 1, x - 1, y + h + 1) -- left
	surface.DrawLine(x - 2, y - 2, x - 2, y + h + 2) -- left

	draw.DrawText(self.id, "DermaDefault", x + w * 0.5, y + h * 0.5 - 7, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
end

function HUDELEMENT:SetDefaults()
	self.defaults.basepos = table.Copy(self.basepos)
	self.defaults.size = table.Copy(self.size)
end

function HUDELEMENT:Reset()
	local defaultPos = self.defaults.basepos
	local defaultSize = self.defaults.size

	self:SetBasePos(defaultPos.x, defaultPos.y)
	self:SetPos(defaultPos.x, defaultPos.y)
	self:SetSize(defaultSize.w, defaultSize.h)

	self:PerformLayout()
end

local savingKeys = {
	basepos = {typ = "pos"},
	size = {typ = "size"}
}

function HUDELEMENT:GetSavingKeys()
	return savingKeys
end

function HUDELEMENT:Save()

end

function HUDELEMENT:Load()
	local basepos = self:GetBasePos()

	self:SetPos(basepos.x, basepos.y)
end
