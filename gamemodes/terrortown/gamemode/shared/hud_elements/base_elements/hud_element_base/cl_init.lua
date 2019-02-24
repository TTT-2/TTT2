local surface = surface

local zero_tbl_pos = {
	x = 0,
	y = 0
}

local zero_tbl_size = {
	w = 0,
	h = 0
}

HUDELEMENT.basepos = table.Copy(zero_tbl_pos)
HUDELEMENT.pos = table.Copy(zero_tbl_pos)
HUDELEMENT.size = table.Copy(zero_tbl_size)

HUDELEMENT.defaults = {
	basepos = table.Copy(HUDELEMENT.basepos),
	size = table.Copy(HUDELEMENT.size),
	minHeight = 0,
	minWidth = 0,
	resizeableX = true,
	resizeableY = true
}

HUDELEMENT.parent = nil
HUDELEMENT.parent_is_type = nil
HUDELEMENT.children = {}

function HUDELEMENT:PreInitialize()
	-- Use this to set child<->parent relations etc, this is called before Initialized and other objects can still be uninitialized!
end

function HUDELEMENT:Initialize()
	-- use this to set default values and dont forget to call BaseClass.Initialze(self)!!
	for _, elem in ipairs(self.children) do
		local elemtbl = hudelements.GetStored(elem)
		if elemtbl then
			elemtbl:Initialize()
			elemtbl:SetDefaults()
			elemtbl:LoadData()
			elemtbl.initialized = true
		end
	end
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

	w = math.max(self.defaults.minWidth, w)
	h = math.max(self.defaults.minHeight, h)

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
	self.defaults.basepos = table.Copy(self.basepos)
	self.defaults.size = table.Copy(self.size)
end

function HUDELEMENT:Reset()
	local defaultPos = self.defaults.basepos
	local defaultSize = self.defaults.size

	if defaultPos then
		self:SetBasePos(defaultPos.x, defaultPos.y)
	end

	if defaultSize then
		self:SetSize(defaultSize.w, defaultSize.h)
	end

	self:PerformLayout()
end

local savingKeys = {
	basepos = {typ = "pos"},
	size = {typ = "size"}
}

function HUDELEMENT:GetSavingKeys()
	return table.Copy(savingKeys)
end

function HUDELEMENT:SaveData()
	SQL.Save("ttt2_hudelements", self.id, self, self:GetSavingKeys())
end

function HUDELEMENT:LoadData()
	local skeys = self:GetSavingKeys()

	-- load and initialize the elements data from database
	if SQL.CreateSqlTable("ttt2_hudelements", skeys) then
		local loaded = SQL.Load("ttt2_hudelements", self.id, self, skeys)

		if not loaded then
			SQL.Init("ttt2_hudelements", self.id, self, skeys)
		end
	end

	-- set position to loaded position
	local basepos = self:GetBasePos()
	self:SetPos(basepos.x, basepos.y)
end
