local surface = surface

local zero_tbl_pos = {
	x = 0,
	y = 0
}

local zero_tbl_size = {
	w = 0,
	h = 0
}

local min_size_tbl = {
	w = 0,
	h = 0
}

HUDELEMENT.basepos = table.Copy(zero_tbl_pos)
HUDELEMENT.pos = table.Copy(zero_tbl_pos)
HUDELEMENT.size = table.Copy(zero_tbl_size)
HUDELEMENT.minsize = table.Copy(min_size_tbl)
HUDELEMENT.scale = 1.0

HUDELEMENT.defaults = {
	basepos = table.Copy(HUDELEMENT.basepos),
	size = table.Copy(HUDELEMENT.size),
	minsize = table.Copy(HUDELEMENT.minsize),

	-- resize area parameters
	click_area = 20,
	click_padding = 0
}

HUDELEMENT.edit_live_data = {
	calc_new_click_area = false,
	old_row = nil,
	old_col = nil
}

HUDELEMENT.parent = nil
HUDELEMENT.parent_is_type = nil
HUDELEMENT.children = {}

function HUDELEMENT:PreInitialize()
	-- Use this to set child<->parent relations etc, this is called before Initialized and other objects can still be uninitialized!
end

function HUDELEMENT:Initialize()
	-- use this to set default values and dont forget to call BaseClass.Initialze(self)!!
	self:SetDefaults()

	for _, elem in ipairs(self.children) do
		local elemtbl = hudelements.GetStored(elem)
		if elemtbl then
			elemtbl:Initialize()
		else
			Msg("Error: HUDElement " .. (self.id or "?") .. " has unkown child element named " .. elem .. " when calling Initialize \n")
		end
	end
end

function HUDELEMENT:Draw()
	-- Override this function to draw your element
end

-- parameter overwrites
function HUDELEMENT:ShouldShow()
	return true
end

function HUDELEMENT:IsResizable()
	return true, true
end

function HUDELEMENT:AspectRatioIsLocked()
	return false
end

function HUDELEMENT:InheritParentBorder()
	return false
end
-- parameter overwrites end

--[[------------------------------
	PerformLayout()
	Desc: This function is called after all Initialize() functions.
--]]-------------------------------
function HUDELEMENT:PerformLayout()
	for _, elem in ipairs(self.children) do
		local elemtbl = hudelements.GetStored(elem)
		if elemtbl then
			elemtbl:PerformLayout()
		else
			Msg("Error: HUDElement " .. (self.id or "?") .. " has unkown child element named " .. elem .. " when calling PerformLayout \n")
		end
	end
end

function HUDELEMENT:ResolutionChanged()
	self:RecalculateBasePos()
	self:SetDefaults()
	for _, elem in ipairs(self.children) do
		local elemtbl = hudelements.GetStored(elem)
		if elemtbl then
			elemtbl:ResolutionChanged()
		else
			Msg("Error: HUDElement " .. (self.id or "?") .. " has unkown child element named " .. elem .. " when calling ResolutionChanged \n")
		end
	end
end

function HUDELEMENT:RecalculateBasePos()
	-- Use this to intialize/reinitialize your basePos (take ScrH()/ScrW() as reference to support different resolutions)
end

function HUDELEMENT:GetBasePos()
	return table.Copy(self.basepos)
end

function HUDELEMENT:SetBasePos(x, y)
	self.basepos.x = x
	self.basepos.y = y

	self:SetPos(x, y)
end

function HUDELEMENT:GetPos()
	return table.Copy(self.pos)
end

function HUDELEMENT:SetPos(x, y)
	self.pos.x = x
	self.pos.y = y
end

function HUDELEMENT:GetBorderParams()
	if self:IsParent() then
		local pos = self:GetPos()
		local size = self:GetSize()
		local children = self:GetChildren()

		local x_min, y_min, x_max, y_max = pos.x, pos.y, pos.x + size.w, pos.y + size.h

		-- iterate over children
		for _, elem_str in ipairs(self.children) do
			local elem = hudelements.GetStored(elem_str)

			local hud = huds.GetStored(HUDManager.GetHUD())

			if elem and elem:InheritParentBorder() and hud:ShouldShow(elem.type) and elem:ShouldShow() then
				local c_pos = elem:GetPos()
				local c_size = elem:GetSize()

				x_min = math.min(x_min, c_pos.x)
				y_min = math.min(y_min, c_pos.y)
				x_max = math.max(x_max, c_pos.x + c_size.w)
				y_max = math.max(y_max, c_pos.y + c_size.h)
			end
		end

		return {x = x_min, y = y_min}, {w = x_max-x_min, h = y_max-y_min}
	else
		return self:GetPos(), self:GetSize()
	end
end

function HUDELEMENT:SetMinSize(w, h)
	self.minsize.w = w
	self.minsize.h = h
end

function HUDELEMENT:GetMinSize()
	return table.Copy(self.minsize)
end

function HUDELEMENT:GetSize()
	return table.Copy(self.size)
end

function HUDELEMENT:SetSize(w, h)
	w = math.Round(w)
	h = math.Round(h)

	local nw, nh = w < 0, h < 0

	if nw then
		w = -w
	end

	if nh then
		h = -h
	end

	if self.minsize then
		w = math.max(self.minsize.w, w)
		h = math.max(self.minsize.h, h)
	end

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
	return table.Copy(self.children)
end

function HUDELEMENT:IsInRange(x, y, range)
	range = range or 0

	local minX, minY = self.pos.x, self.pos.y
	local maxX, maxY = minX + self.size.w, minY + self.size.h

	return x - range <= maxX and x + range >= minX and y - range <= maxY and y + range >= minY
end

function HUDELEMENT:IsInPos(x, y)
	return self:IsInRange(x,y,0)
end

function HUDELEMENT:OnHovered(x, y)
	if self:IsChild() then -- children are not resizeable
		return {false, false, false}, {false, false, false}
	end

	local minX, minY = self.pos.x, self.pos.y
	local maxX, maxY = minX + self.size.w, minY + self.size.h

	local c_pad, c_area = self.defaults.click_padding, self.defaults.click_area
	local res_x, res_y = self:IsResizable()

	local row, col

	-- ROWS
	if res_y then
		row = {
			y > minY + c_pad and y < minY + c_pad + c_area, -- top row
			y > minY + 2*c_pad + c_area and y < maxY - 2*c_pad - c_area, -- center column
			y > maxY - c_pad - c_area and y < maxY - c_pad -- right column
		}
	else
		row = {
			false, -- top row
			y > minY + c_pad and y < maxY - c_pad, -- center column
			false -- right column
		}
	end

	-- COLUMS
	if res_x then
		col = {
			x > minX + c_pad and x < minX + c_pad + c_area, -- left column
			x > minX + 2*c_pad + c_area and x < maxX - 2*c_pad - c_area, -- center column
			x > maxX - c_pad - c_area and x < maxX - c_pad -- right column
		}
	else
		col = {
			false, -- left column
			x > minX + c_pad and x < maxX - c_pad, -- center column
			false -- right column
		}
	end

	-- locked aspect ratio has to be a special case to not break movement
	if self:AspectRatioIsLocked() then
		-- ignore if mouse is on center
		if (not (row[2] and col[2])) then
			row[2] = false
			col[2] = false
		end
	end


	return row, col
end

function HUDELEMENT:DrawHowered(x, y)
	if not self:IsInPos(x, y) then
		return false
	end

	local minX, minY = self.pos.x, self.pos.y
	local maxX, maxY = minX + self.size.w, minY + self.size.h
	local c_pad, c_area = self.defaults.click_padding, self.defaults.click_area
	local res_x, res_y = self:IsResizable()

	local row, col = self:OnHovered(x, y)
	local x1, x2, y1, y2 = 0, 0, 0, 0

	if row[1] then -- resizeable in all directions
		y1 = minY + c_pad
		y2 = minY + c_pad + c_area
	elseif row[2] and (col[1] or col[3]) and not res_y then -- only resizeable in X
		y1 = minY + c_pad
		y2 = maxY - c_pad
	elseif row[2] and not res_y then -- only resizeable in X / show center area
		y1 = minY + c_pad
		y2 = maxY - c_pad
	elseif row[2] then -- resizeable in all directions / show center area
		y1 = minY + 2*c_pad + c_area
		y2 = maxY - 2*c_pad - c_area
	elseif row[3] then -- resizeable in all directions
		y1 = maxY - c_pad - c_area
		y2 = maxY - c_pad
	end

	if col[1] then -- resizeable in all directions
		x1 = minX + c_pad
		x2 = minX + c_pad + c_area
	elseif col[2] and (row[1] or row[3]) and not res_x then -- only resizeable in Y
		x1 = minX + c_pad
		x2 = maxX - c_pad
	elseif col[2] and not res_x then -- only resizeable in Y / show center area
		x1 = minX + c_pad
		x2 = maxX - c_pad
	elseif col[2] then -- resizeable in all directions / show center area
		x1 = minX + 2*c_pad + c_area
		x2 = maxX - 2*c_pad - c_area
	elseif col[3] then -- resizeable in all directions
		x1 = maxX - c_pad - c_area
		x2 = maxX - c_pad
	end

	-- set color
	if (row[2] and col[2]) then
		surface.SetDrawColor(20, 150, 245, 155)
	else
		surface.SetDrawColor(245, 30, 80, 155)
	end

	-- draw rect
	surface.DrawRect(x1, y1, x2 - x1, y2 - y1)
end

function HUDELEMENT:GetClickedArea(x, y, alt_pressed)
	alt_pressed = alt_pressed or false

	local row, col
	if self.edit_live_data.calc_new_click_area then
		if not self:IsInPos(x, y) then
			return false
		end

		row, col = self:OnHovered(x, y)
		self.edit_live_data.old_row = row
		self.edit_live_data.old_col = col

		self.edit_live_data.calc_new_click_area = false
	else
		row = self.edit_live_data.old_row
		col = self.edit_live_data.old_col
	end

	if (row == nil or col == nil) then
		return false
	end

	-- cache for shorter access
	local x_p = col[3] and (row[1] or row[2] or row[3])
	local x_m = col[1] and (row[1] or row[2] or row[3])
	local y_p = row[3] and (col[1] or col[2] or col[3])
	local y_m = row[1] and (col[1] or col[2] or col[3])

	local ret_transform_axis = {
		x_p = x_p or (alt_pressed and x_m) or false,
		x_m = x_m or (alt_pressed and x_p) or false,
		y_p = y_p or (alt_pressed and y_m) or false,
		y_m = y_m or (alt_pressed and y_p) or false,
		edge = (col[1] or col[3]) and (row[1] or row[3]),
		direction_x = x_p and 1 or -1,
		direction_y = y_p and 1 or -1,
		move = row[2] and col[2]
	}

	return ret_transform_axis
end

-- the active area should only be changed on mouse click
function HUDELEMENT:SetMouseClicked(mouse_clicked, x, y)
	if self:IsInPos(x, y) then
		self.edit_live_data.calc_new_click_area = mouse_clicked or self.edit_live_data.calc_new_click_area
	end
end

function HUDELEMENT:DrawSize()
	local x, y, w, h = self.pos.x, self.pos.y, self.size.w, self.size.h

	surface.SetDrawColor(255, 0, 0, 255)
	surface.DrawLine(x, y, x + w, y) -- top
	surface.DrawLine(x + 1, y + 1, x + w - 1, y + 1) -- top

	surface.DrawLine(x + w, y, x + w, y + h) -- right
	surface.DrawLine(x + w - 1, y + 1, x + w - 1, y + h - 1) -- right

	surface.DrawLine(x, y + h, x + w, y + h) -- bottom
	surface.DrawLine(x + 1, y + h - 1, x + w - 1, y + h - 1) -- bottom

	surface.DrawLine(x, y, x, y + h) -- left
	surface.DrawLine(x + 1, y + 1, x + 1, y + h - 1) -- left

	draw.DrawText(self.id, "DermaDefault", x + w * 0.5, y + h * 0.5 - 7, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
end

function HUDELEMENT:SetDefaults()
	self.defaults.basepos = table.Copy(self.basepos)
	self.defaults.size = table.Copy(self.size)
	self.defaults.minsize = table.Copy(self.minsize)
end

function HUDELEMENT:Reset()
	local defaultPos = self.defaults.basepos
	local defaultSize = self.defaults.size
	local defaultMinSize = self.defaults.minsize

	if defaultPos then
		self:SetBasePos(defaultPos.x, defaultPos.y)
	end

	if defaultMinSize then
		self:SetMinSize(defaultMinSize.w, defaultMinSize.h)
	end

	if defaultSize then
		self:SetSize(defaultSize.w, defaultSize.h)
	end

	self.scale = 1.0

	for _, elem in ipairs(self.children) do
		local elemtbl = hudelements.GetStored(elem)
		if elemtbl then
			elemtbl:Reset()
		else
			Msg("Error: HUDElement " .. (self.id or "?") .. " has unkown child element named " .. elem .. " when calling Reset \n")
		end
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
