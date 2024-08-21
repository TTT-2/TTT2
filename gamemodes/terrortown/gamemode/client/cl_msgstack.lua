---
-- @class MSTACK
-- @author saibotk
-- @desc HUD stuff similar to weapon/ammo pickups but for game status messages

MSTACK = {}
MSTACK.msgs = {}
MSTACK.last = 0

-- Localise some libs
local table = table
local net = net

sound.Add({
    name = "Hud.Hint",
    channel = CHAN_STATIC,
    volume = 1.0,
    level = SNDLVL_NONE,
    pitch = 100,
    sound = "ui/hint.wav",
})

local traitor_msg_bg = Color(255, 0, 0, 255)

---
-- Adds a colored message into the message stack
-- @param string text
-- @param Color c
-- @realm client
function MSTACK:AddColoredMessage(text, c)
    local item = {}
    item.text = text
    item.col = c

    self:AddMessageEx(item)
end

---
-- Adds a message with a colored background into the message stack
-- @param string text
-- @param Color bg_clr
-- @realm client
function MSTACK:AddColoredBgMessage(text, bg_clr)
    local item = {}
    item.text = text
    item.bg = bg_clr

    self:AddMessageEx(item)
end

---
-- Adds a message with an image into the message stack
-- @param string text
-- @param Material image
-- @param string title
-- @realm client
function MSTACK:AddImagedMessage(text, image, title)
    local item = {}
    item.text = text
    item.title = title
    item.image = image

    self:AddMessageEx(item)
end

---
-- Adds a message with an image into the message stack
-- @param string text
-- @param Color bg_clr
-- @param Material image
-- @param string title
-- @realm client
function MSTACK:AddColoredImagedMessage(text, bg_clr, image, title)
    local item = {}
    item.text = text
    item.title = title
    item.bg = bg_clr
    item.image = image

    self:AddMessageEx(item)
end

---
-- Adds a custom styled message into the message stack
-- @param table item
-- @realm client
-- @internal
-- @todo add table structure
function MSTACK:AddMessageEx(item)
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

---
-- Add a given message to the stack, will be rendered in a different color if it
-- is a special traitor-only message that traitors should pay attention to.
-- Use the newer AddColoredMessage if you want special colours.
-- @param string text
-- @param boolean traitor_only
-- @realm client
function MSTACK:AddMessage(text, traitor_only)
    if traitor_only then
        self:AddColoredBgMessage(text, traitor_msg_bg)
    else
        self:AddColoredMessage(text)
    end
end

---
-- Clears the whole MStack message buffer and resets the counter to 0.
-- @realm client
function MSTACK:ClearMessages()
    MSTACK.msgs = {}
    MSTACK.last = 0
end

-- Game state message channel
local function ReceiveGameMsg()
    local text = net.ReadString()
    local special = net.ReadBit() == 1

    Dev(2, text)

    MSTACK:AddMessage(text, special)
end
net.Receive("TTT_GameMsg", ReceiveGameMsg)

local function ReceiveCustomMsg()
    local text = net.ReadString()
    local c = table.Copy(COLOR_WHITE)

    c.r = net.ReadUInt(8)
    c.g = net.ReadUInt(8)
    c.b = net.ReadUInt(8)

    Dev(2, text)

    MSTACK:AddColoredMessage(text, c)
end
net.Receive("TTT_GameMsgColor", ReceiveCustomMsg)
