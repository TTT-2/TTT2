---
-- @author Mineotopia
-- @class RADAR_DATA

RADAR_DATA = {}

---
-- Initializes the @{RADAR_DATA} object
-- @param Entity ent The focused Entity
-- @param boolean isOffScreen If the radar is off screen or on screen
-- @param number distance The distance to the focused entity
-- @return RADAR_DATA The object to be used in the hook
-- @internal
-- @realm client
function RADAR_DATA:Initialize(ent, isOffScreen, distance)
	-- combine data into a table to read them inside a hook
	local data = {
		ent = ent,
		isOffScreen = isOffScreen,
		distance = distance
	}

	-- preset a table of values that can be changed with a hook
	local params = {
		drawInfo = nil,
		displayInfo = {
			icon = {},
			title = {
				icons = {},
				text = "",
				color = COLOR_WHITE
			},
			desc = {}
		}
	}

	return RADAR_DATA:BindTarget(data, params)
end


---
-- Binds two target data tables to the @{RADAR_DATA} object
-- @param table data The data table about the focused entity
-- @param table params The default table with the params that should be modified by the hook
-- @return RADAR_DATA The object to be used in the hook
-- @internal
-- @realm client
function RADAR_DATA:BindTarget(data, params)
	self.data = data
	self.params = params

	return self
end

---
-- Returns the currently focused entity
-- @return Entity The focused entity
-- @realm client
function RADAR_DATA:GetEntity()
	return self.data.ent
end

---
-- Returns if the radar entity is off screen
-- @return boolean Whether it is off screen
-- @realm client
function RADAR_DATA:IsOffScreen()
	return self.data.isOffScreen
end

---
-- Returns the distance to the focused entity
-- @return number The distance to the focused entity
-- @realm client
function RADAR_DATA:GetEntityDistance()
	return self.data.distance
end

---
-- Enables/Disables the radar vision text and icons, can't be enabled if set
-- to false from another call
-- @param[default=true] boolean enableText A boolean defining the text state
-- @realm client
function RADAR_DATA:EnableText(enableText)
	-- only set if not already set to false
	if self.params.drawInfo == false then return end

	-- set to true if true or nil, but keep false
	self.params.drawInfo = (enableText == nil) and true or enableText
end

---
-- Adds a icon to the icon list on the left side of the radar vision element.
-- @param Material material The material of the icon that should be rendered
-- @param[default=Color(255, 255, 255, 255)] Color color The color of the icon
-- @return number The amount of icons that are currently in the table
-- @realm client
function RADAR_DATA:AddIcon(material, color)
	local amount = #self.params.displayInfo.icon + 1

	self.params.displayInfo.icon[amount] = {
		material = material,
		color = IsColor(color) and color or COLOR_WHITE
	}

	return amount
end

---
-- Sets the title of the specific radar vision element
-- @param[default=""] string text The text that should be displayed
-- @param[default=Color(255, 255, 255, 255)] Color color The color of the line
-- @param[opt] table inline_icons A table of materials that should be rendered in front of the text
-- @realm client
function RADAR_DATA:SetTitle(text, color, inline_icons)
	self.params.displayInfo.title = {
		text = text or "",
		color = IsColor(color) and color or COLOR_WHITE,
		icons = inline_icons or {}
	}
end

---
-- Adds a line of text to the description area of the radar vision element
-- @param[default=""] string text The text that should be displayed
-- @param[default=Color(255, 255, 255, 255)] Color color The color of the line
-- @param[opt] table inline_icons A table of materials that should be rendered in front of the text
-- @return number The amount of description lines that are currently in the table
-- @realm client
function RADAR_DATA:AddDescriptionLine(text, color, inline_icons)
	local amount = #self.params.displayInfo.desc + 1

	self.params.displayInfo.desc[amount] = {
		text = text or "",
		color = IsColor(color) and color or COLOR_WHITE,
		icons = inline_icons or {}
	}

	return amount
end

---
-- Sets the collapsed line that is shown at greater distance of the specific radar vision element
-- @param[default=""] string text The text that should be displayed
-- @param[default=Color(255, 255, 255, 255)] Color color The color of the line
-- @realm client
function RADAR_DATA:SetCollapsedLine(text, color)
	self.params.displayInfo.collapsedLine = {
		text = text or "",
		color = IsColor(color) and color or COLOR_WHITE
	}
end

---
-- Returns whether or not a title has been set
-- @return boolean True if a title is set
-- @realm client
function RADAR_DATA:HasTitle()
	return self.params.displayInfo.title and self.params.displayInfo.title.text ~= ""
end

---
-- Returns the amount of set description lines
-- @return number Amount of existing description lines
-- @realm client
function RADAR_DATA:GetAmountDescriptionLines()
	return #self.params.displayInfo.desc
end

---
-- Returns the amount of set icons
-- @return number Amount of existing icons
-- @realm client
function RADAR_DATA:GetAmountIcons()
	return #self.params.displayInfo.icon
end

---
-- Returns whether or not a collapsed line has been set
-- @return boolean True if a title is set
-- @realm client
function RADAR_DATA:HasCollapsedLine()
	return self.params.displayInfo.collapsedLine and self.params.displayInfo.collapsedLine.text ~= ""
end

---
-- Returns the raw data tables of the radar vision element to me modified by experienced users
-- @return table,table The table of the entity data, the table of the radar vision element parameters
-- @realm client
function RADAR_DATA:GetRaw()
	return self.data, self.params
end
