---- HUD stuff similar to weapon/ammo pickups but for game status messages

-- This is some of the oldest TTT code, and some of the first Lua code I ever
-- wrote. It's not the greatest.

MSTACK = {}
MSTACK.msgs = {}
MSTACK.last = 0

-- Localise some libs
local table = table
local surface = surface
local draw = draw
local ipairs = ipairs
local net = net

-- Text colors to render the messages in
local msgcolors = {
	traitor_text = COLOR_RED,
	generic_text = COLOR_WHITE,

	generic_bg = Color(0, 0, 0, 200)
}

function MSTACK:AddColoredMessage(text, c)
	local item = {}
	item.text = text
	item.col = c
	item.bg = msgcolors.generic_bg

	self:AddMessageEx(item)
end

function MSTACK:AddColoredBgMessage(text, bg_clr)
	local item = {}
	item.text = text
	item.col = msgcolors.generic_text
	item.bg = bg_clr

	self:AddMessageEx(item)
end

function MSTACK:AddImagedMessage(text, c, image, title)
	local item = {}
	item.text = text
	item.title = title
	item.col = c
	item.bg = msgcolors.generic_bg
	item.image = image

	self:AddMessageEx(item)
end

function MSTACK:AddColoredImagedMessage(text, bg_clr, image, title)
	local item = {}
	item.text = text
	item.title = title
	item.col = msgcolors.generic_text
	item.bg = bg_clr
	item.image = image

	self:AddMessageEx(item)
end

-- Internal
function MSTACK:AddMessageEx(item)
	item.col = table.Copy(item.col or msgcolors.generic_text)
	item.col.a_max = item.col.a

	item.bg = table.Copy(item.bg or msgcolors.generic_bg)
	item.bg.a_max = item.bg.a

	item.time = CurTime()
	item.sounded = false

	-- Stagger the fading a bit
	if self.last > item.time - 1 then
		item.time = self.last + 1
	end

	-- Insert at the top
	table.insert(self.msgs, 1, item)

	self.last = item.time
end

-- Add a given message to the stack, will be rendered in a different color if it
-- is a special traitor-only message that traitors should pay attention to.
-- Use the newer AddColoredMessage if you want special colours.
function MSTACK:AddMessage(text, traitor_only)
	-- TODO msgcolors.traitor_bg never defined!
	self:AddColoredBgMessage(text, traitor_only and msgcolors.traitor_bg or msgcolors.generic_bg)
end

-- Oh joy, I get to write my own wrapping function. Thanks Lua!
-- Splits a string into a table of strings that are under the given width.
function MSTACK:WrapText(text, width, font)
	surface.SetFont(font or "DefaultBold")

	-- Any wrapping required?
	local w = surface.GetTextSize(text)

	if w <= width then
		return {text} -- Nope, but wrap in table for uniformity
	end

	local words = string.Explode(" ", text) -- No spaces means you're screwed
	local lines = {""}

	for i, wrd in ipairs(words) do
		local l = #lines
		local added = lines[l] .. " " .. wrd

		w = surface.GetTextSize(added)

		if w > width then
			table.insert(lines, wrd) -- New line needed
		else
			lines[l] = added -- Safe to tack it on
		end
	end

	return lines
end

-- Game state message channel
local function ReceiveGameMsg()
	local text = net.ReadString()
	local special = net.ReadBit() == 1

	print(text)

	MSTACK:AddMessage(text, special)
end
net.Receive("TTT_GameMsg", ReceiveGameMsg)

local function ReceiveCustomMsg()
	local text = net.ReadString()
	local c = Color(255, 255, 255)

	c.r = net.ReadUInt(8)
	c.g = net.ReadUInt(8)
	c.b = net.ReadUInt(8)

	print(text)

	MSTACK:AddColoredMessage(text, c)
end
net.Receive("TTT_GameMsgColor", ReceiveCustomMsg)
