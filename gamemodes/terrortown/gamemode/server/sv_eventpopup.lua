---
-- @class EPOP

util.AddNetworkString("ttt2_eventpopup")

EPOP = EPOP or {}

---
-- Adds a translated popup message to the @{EPOP}
-- @param nil|table|Player plys A table of player that should receive this popup, broadcasts it if nil
-- @param string|table title The title of the popup that will be displayed in large letters (can be a table with `text` and `color` attribute)
-- @param[opt] string|table subtitle An optional description that will be displayed below the title (can be a table with `text` and `color` attribute)
-- @param[default=4] number displayTime The render duration of the popup
-- @param[default=false] boolean blocking If this is false, this message gets instantly replaced if a new message is added
-- @realm server
function EPOP:AddMessage(plys, title, subtitle, displayTime, blocking)
    if not title and not subtitle then
        return
    end

    net.Start("ttt2_eventpopup")

    if title then
        title = istable(title) and title or { text = title }

        net.WriteBool(true)
        net.WriteString(title.text)

        if IsColor(title.color) then
            net.WriteBool(true)
            net.WriteColor(title.color)
        else
            net.WriteBool(false)
        end
    else
        net.WriteBool(false)
    end

    if subtitle then
        subtitle = istable(subtitle) and subtitle or { text = subtitle }

        net.WriteBool(true)
        net.WriteString(subtitle.text)

        if IsColor(subtitle.color) then
            net.WriteBool(true)
            net.WriteColor(subtitle.color)
        else
            net.WriteBool(false)
        end
    else
        net.WriteBool(false)
    end

    net.WriteUInt(displayTime or 4, 16)
    net.WriteBool(blocking == true)

    if plys then
        net.Send(plys)
    else
        net.Broadcast()
    end
end
