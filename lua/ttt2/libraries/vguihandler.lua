---
-- A vgui handler
-- @author Mineotopia
-- @module vguihandler

if SERVER then
    AddCSLuaFile()

    return -- the rest of the vguihandler library is client only
end

local table = table

vguihandler = vguihandler
    or {
        frames = {},
        callback = {
            frame = {},
            hidden = {},
        },
    }

-- Call this function to create a new frame. Using this instead of setting the
-- frame up manually has the benefit that all basic settings are already set.
-- Additionally the frame is added to a managed list that is used to handle
-- hiding, closing and tracking menues.
-- @param number w The width of the panel
-- @param number h The height of the panel
-- @param string title The title of the panel
-- @return Panel The created/cleared DFrameTTT2 object
-- @realm client
function vguihandler.GenerateFrame(w, h, title)
    local frame = vgui.Create("DFrameTTT2")

    frame:SetSize(w, h)
    frame:Center()
    frame:SetTitle(title)

    local OriginalClose = frame.Close

    frame.Close = function(slf)
        if slf:GetDeleteOnClose() then
            table.RemoveByValue(vguihandler.frames, frame)
        end

        OriginalClose(slf)
    end

    vguihandler.frames[#vguihandler.frames + 1] = frame

    return frame
end

---
-- Hides all registered and unhidden frames.
-- @return table Returns a table of the frames that are now hidden
-- @realm client
function vguihandler.HideFrames()
    local frames = vguihandler.frames
    local hiddenFrames = {}

    for i = 1, #frames do
        local frame = frames[i]

        if frame:IsFrameHidden() then
            continue
        end

        frame:HideFrame()

        hiddenFrames[#hiddenFrames + 1] = frame
    end

    return hiddenFrames
end

---
-- Unhides frames that are listed in a table.
-- @param table A table of frames
-- @realm client
function vguihandler.ShowFrames(frames)
    for i = 1, #frames do
        local frame = frames[i]

        if not IsValid(frame) or not frame:IsFrameHidden() then
            continue
        end

        frame:ShowFrame()
    end
end

---
-- Unhides all frames that are currently registered and hidden.
-- @realm client
function vguihandler.ShowAllFrames()
    local frames = vguihandler.frames

    for i = 1, #frames do
        local frame = frames[i]

        if not frame:IsFrameHidden() then
            continue
        end

        frame:ShowFrame()
    end
end

---
-- Should be called when a specific vskin variable is changed
-- so that the complete vgui element is redone
-- @internal
-- @realm client
function vguihandler.InvalidateVSkin()
    local frames = vguihandler.frames

    for i = 1, #frames do
        frames[i]:InvalidateLayout()
    end
end

---
-- Rebuilds the whole menu without a specific changed setting.
-- @realm client
function vguihandler.Rebuild()
    local frames = vguihandler.frames

    for i = 1, #frames do
        local frame = frames[i]

        if isfunction(frame.OnRebuild) then
            frame:OnRebuild()
        end
    end

    vguihandler.InvalidateVSkin()
end

---
-- Returns if a menu is open or not
-- @return boolean True if a menu is open
-- @realm client
function vguihandler.IsOpen()
    local frames = vguihandler.frames

    for i = 1, #frames do
        if frames[i]:IsFrameHidden() then
            continue
        end

        return true
    end

    return false
end

---
-- Returns if a menu is blocking TTT2 Binds or not
-- @return boolean True if a menu is open and blocks Bindings
-- @realm client
function vguihandler.IsBlockingBindings()
    local frames = vguihandler.frames

    for i = 1, #frames do
        if frames[i]:IsFrameHidden() or not frames[i]:IsBlockingBindings() then
            continue
        end

        return true
    end

    return false
end

---
-- Draws the background behind the opened vgui menues. It is called in
-- @{GM:PostDrawHUD}.
-- @internal
-- @realm client
function vguihandler.DrawBackground()
    if not vguihandler.IsOpen() then
        return
    end

    local width = ScrW()
    local height = ScrH()

    if vskin.ShouldBlurBackground() then
        draw.BlurredBox(0, 0, width, height, 1)
    end

    if vskin.ShouldColorBackground() then
        -- for some reason the color has to be bigger than the screen to
        -- fill the entire screenspace
        draw.Box(-1, -1, width + 2, height + 2, vskin.GetScreenColor())
    end
end
