local surface = surface

local zero_tbl = {
	x = 0,
	y = 0
}

HUDELEMENT.basepos = table.Copy(zero_tbl)
HUDELEMENT.pos = table.Copy(zero_tbl)
HUDELEMENT.size = table.Copy(zero_tbl)

local defaults = {
	basepos = table.Copy(zero_tbl),
	size = table.Copy(zero_tbl),
	minHeight = 0,
	minWidth = 0,
	resizeableX = true,
	resizeableY = true
}

function HUDELEMENT:GetDefaults()
	return table.Copy(defaults)
end

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

	self:SetPos(x, y)
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

	if nw then
		w = -w
	end

	if nh then
		h = -h
	end

	local defs = self:GetDefaults()

	w = math.max(defs.minWidth, w)
	h = math.max(defs.minHeight, h)

	if nw or nh then
		local basepos = self:GetBasePos()
		local pos = self:GetPos()

		if nw then
			self:SetPos(basepos.x - w, pos.y)
		end

		if nh then
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

	local minX, minY = self.pos.x, self.pos.y
	local maxX, maxY = minX + self.size.w, minY + self.size.h

	return x - range <= maxX and x + range >= minX and y - range <= maxY and y + range >= minY
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
	local defs = self:GetDefaults()

	defs.basepos = table.Copy(self.basepos)
	defs.size = table.Copy(self.size)
end

function HUDELEMENT:Reset()
	local defs = self:GetDefaults()
	local defaultPos = defs.basepos
	local defaultSize = defs.size

	self:SetBasePos(defaultPos.x, defaultPos.y)
	self:SetSize(defaultSize.w, defaultSize.h)

	self:PerformLayout()
end

local savingKeys = {
	basepos = {typ = "pos"},
	size = {typ = "size"}
}

function HUDELEMENT:GetSavingKeys()
	return table.Copy(savingKeys)
end

function HUDELEMENT:Save()

end

function HUDELEMENT:Load()
	local basepos = self:GetBasePos()

	self:SetPos(basepos.x, basepos.y)
end
