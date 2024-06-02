---
-- An event popup system that works alongside the MSTACK system to display important messages
-- @author Mineotopia
-- @class EPOP

local TryT = LANG.TryTranslation

local defaultMessage = {
    title = {
        text = "testpopup_title",
    },
    subtitle = {
        text = "testpopup_subtitle",
    },
    iconTable = {},
    time = CurTime() + 5,
}

local counter = 0

EPOP = EPOP or {}
EPOP.messageQueue = EPOP.messageQueue or {}

---
-- Updates the message queue
-- @note Called every @{GM:Think}
-- @realm client
-- @internal
function EPOP:Think()
    if #self.messageQueue == 0 then
        return
    end

    local elem = self.messageQueue[1]

    if elem.time and CurTime() >= elem.time then
        EPOP:RemoveMessage(elem.id)
    end
end

---
-- Adds a popup message to the @{EPOP}
-- @param string|table title The title of the popup that will be displayed in large letters (can be a table with `text` and `color` attribute)
-- @param[opt] string|table subtitle An optional description that will be displayed below the title (can be a table with `text` and `color` attribute)
-- @param[default=4] number displayTime The render duration of the popup
-- @param[opt] table iconTable An optional set of icon materials that will be rendered below the popup
-- @param[default=true] boolean blocking If this is false, this message gets instantly replaced if a new message is added
-- @return string Returns a unique id generated for this message
-- @realm client
function EPOP:AddMessage(title, subtitle, displayTime, iconTable, blocking)
    local id = "epop_unique_id_" .. counter

    counter = counter + 1

    local queueSize = #self.messageQueue

    -- delete previous message if it is nonblocking
    if queueSize > 0 and not self.messageQueue[queueSize].blocking then
        table.remove(self.messageQueue, queueSize)

        queueSize = queueSize - 1
    end

    -- add the new message to the queue
    self.messageQueue[queueSize + 1] = {
        id = id,
        title = istable(title) and title or { text = title or "" },
        subtitle = istable(subtitle) and subtitle or { text = subtitle or "" },
        displayTime = displayTime or 4,
        iconTable = iconTable or {},
        blocking = blocking == nil and false or blocking,
    }

    -- the new element is the first one in the list and should be therefore activated
    if queueSize == 0 then
        self:ActivateMessage()
    end

    return id
end

---
-- Activates a new message by setting up all internal values
-- @internal
-- @realm client
function EPOP:ActivateMessage()
    if #self.messageQueue == 0 then
        return
    end

    local elem = self.messageQueue[1]

    elem.time = CurTime() + elem.displayTime

    Dev(1, "[TTT2] " .. elem.title.text .. " // " .. elem.subtitle.text)
end

---
-- A shortcut function to check if an @{EPOP} should be rendered
-- @return boolean Returns if the message shoould be rendered
-- @realm client
function EPOP:ShouldRender()
    return #self.messageQueue > 0
end

---
-- Returns the neweset message in the queue that should be rendered right now.
-- @return table The message table
-- @realm client
function EPOP:GetMessage()
    return self.messageQueue[1]
end

---
-- Returns the default message.
-- @return table The message table
-- @realm client
function EPOP:GetDefaultMessage()
    return table.Copy(defaultMessage)
end

---
-- Removes a message from the stack by a numeric index
-- @param number index The nimeric index
-- @realm client
function EPOP:RemoveMessageByIndex(index)
    table.remove(self.messageQueue, index)

    -- if the removed message was the first in the queue, the next one should be activated
    if index == 1 then
        EPOP:ActivateMessage()
    end
end

---
-- Instantly removed the currently displayed or a specified @{EPOP} message
-- @param[opt] string id The unique id of a message that sould be deleted. If omitted, the
-- first message in the queue gets deleted
-- @return boolean Returns true if a message got deleted
-- @realm client
function EPOP:RemoveMessage(id)
    if #self.messageQueue == 0 then
        return false
    end

    if id then
        for i = 1, #self.messageQueue do
            local elem = self.messageQueue[i]

            if elem.id ~= id then
                continue
            end

            self:RemoveMessageByIndex(i)

            return true
        end
    else
        self:RemoveMessageByIndex(1)

        return true
    end

    return false
end

---
-- Clears the whole message queue
-- @realm client
function EPOP:Clear()
    self.messageQueue = {}
end

net.Receive("ttt2_eventpopup", function()
    local title, subtitle

    if net.ReadBool() then
        title = {}

        title.text = TryT(net.ReadString())

        if net.ReadBool() then
            title.color = net.ReadColor()
        end
    end

    if net.ReadBool() then
        subtitle = {}

        subtitle.text = TryT(net.ReadString())

        if net.ReadBool() then
            subtitle.color = net.ReadColor()
        end
    end

    EPOP:AddMessage(title, subtitle, net.ReadUInt(16), nil, net.ReadBool())
end)
