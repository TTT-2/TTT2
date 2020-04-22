---
-- A vgui handler
-- @author Mineotopia

AddCSLuaFile()

-- the rest of the draw library is client only
if SERVER then return end

vguihandler = vguihandler or {
	menuCache = {
		frame = nil,
		hidden = nil
	},
	callback = {
		frame = {},
		hidden = {}
	}
}

-- Call this function to create a new frame. Clears
-- the existing frame, if a frame is already opened.
-- @param number w The width of the panel
-- @param number h The height of the panel
-- @param string title The title of the panel
-- @param boolean forceclose Closes currently open frame
-- @warn Navigation buttons will be reinititialized when clearing
-- @return @{Panel} The created/cleared DFrameTTT2 object or nil if
-- there is already a panel open
function vguihandler.GenerateFrame(w, h, title, forceclose)
	if IsValid(vguihandler.menuCache.frame) and not forceclose then return end

	vguihandler.CloseFrame()

	vguihandler.menuCache.frame = vgui.Create("DFrameTTT2")
	vguihandler.menuCache.frame:SetSize(w, h)
	vguihandler.menuCache.frame:Center()
	vguihandler.menuCache.frame:SetTitle(title)
	vguihandler.menuCache.frame:SetVisible(true)
	vguihandler.menuCache.frame:SetDraggable(true)
	vguihandler.menuCache.frame:ShowCloseButton(true)
	vguihandler.menuCache.frame:ShowBackButton(false)
	vguihandler.menuCache.frame:SetDeleteOnClose(true)
	vguihandler.menuCache.frame:SetBackgroundBlur(vskin.ShouldBlurBackground())
	vguihandler.menuCache.frame:SetSkin("ttt2_default")

	vguihandler.menuCache.frame:MakePopup()
	vguihandler.menuCache.frame:SetKeyboardInputEnabled(false)

	return vguihandler.menuCache.frame
end

-- Call this function to clear the contents of a opened frame.
-- Does nothing if no frame is oped. Parameters are optional, old
-- values are kept if not set
-- @param number w The width of the panel
-- @param number h The height of the panel
-- @param string title The title of the panel
-- @warn Navigation buttons will be reinititialized
-- @return @{Panel} The cleared DFrameTTT2 object
function vguihandler.ClearFrame(w, h, title)
	if not IsValid(vguihandler.menuCache.frame) then return end

	if isfunction(vguihandler.callback.frame["clear"]) then
		local shouldCancel = vguihandler.callback.frame["clear"](vguihandler.menuCache.frame) == false

		if shouldCancel then return end
	end

	local oldW, oldH = vguihandler.menuCache.frame:GetSize()
	local oldTitle = vguihandler.menuCache.frame:GetTitle()

	vguihandler.menuCache.frame:Clear()
	vguihandler.menuCache.frame:InitButtons()
	vguihandler.menuCache.frame:ShowBackButton(false)

	if w ~= oldW or h ~= oldH then
		vguihandler.menuCache.frame:SetSize(w or oldW, h or oldH)
		vguihandler.menuCache.frame:Center()
	end

	if title ~= oldTitle then
		vguihandler.menuCache.frame:SetTitle(title or oldTitle)
	end

	vguihandler.callback.frame = {}

	return vguihandler.menuCache.frame
end

---
-- Call this function to permanently close a frame, does
-- nothing if no frame is open.
-- @realm client
function vguihandler.CloseFrame()
	if not IsValid(vguihandler.menuCache.frame) then return end

	if isfunction(vguihandler.callback.frame["close"]) then
		local shouldCancel = vguihandler.callback.frame["close"](vguihandler.menuCache.frame) == false

		if shouldCancel then return end
	end

	vguihandler.menuCache.frame:SetDeleteOnClose(true)
	vguihandler.menuCache.frame:Close()

	vguihandler.menuCache.frame = nil
	vguihandler.callback.frame = {}
end

---
-- Call this function to hide a frame, does nothing if no
-- frame is open. Also calls a callback function if set.
-- @realm client
function vguihandler.HideFrame()
	if not IsValid(vguihandler.menuCache.frame) or IsValid(vguihandler.menuCache.hidden) then return end

	if isfunction(vguihandler.callback.frame["hide"]) then
		local shouldCancel = vguihandler.callback.frame["hide"](vguihandler.menuCache.frame) == false

		if shouldCancel then return end
	end

	vguihandler.menuCache.frame:SetDeleteOnClose(false)
	vguihandler.menuCache.frame:Close()

	-- move frame to hidden
	vguihandler.menuCache.hidden = vguihandler.menuCache.frame
	vguihandler.menuCache.frame = nil

	vguihandler.callback.hidden = vguihandler.callback.frame
	vguihandler.callback.frame = {}
end

---
-- Returns if a menu is currently hidden
-- @return boolean The hide state
-- @realm client
function vguihandler.IsHidden()
	return IsValid(vguihandler.menuCache.hidden) or false
end

---
-- Call this function to unhide a frame, does nothing if no
-- frame was hidden. Also calls a callback function if set.
-- @realm client
function vguihandler.UnhideFrame()
	if not IsValid(vguihandler.menuCache.hidden) then return end

	if isfunction(vguihandler.callback.hidden["unhide"]) then
		local shouldCancel = vguihandler.callback.hidden["unhide"](vguihandler.menuCache.hidden) == false

		if shouldCancel then return end
	end

	-- close frame if there was one opened while being hidden
	vguihandler.CloseFrame()

	-- if closing failed (can be stopped by callback), hiding
	-- also fails
	if IsValid(vguihandler.menuCache.frame) then return end

	vguihandler.menuCache.hidden:SetDeleteOnClose(true)
	vguihandler.menuCache.hidden:SetVisible(true)

	-- move frame from hidden to active frame
	vguihandler.menuCache.frame = vguihandler.menuCache.hidden
	vguihandler.menuCache.hidden = nil

	vguihandler.callback.frame = vguihandler.callback.hidden
	vguihandler.callback.hidden = {}
end

---
-- Returns if a menu is open or not
-- @return boolean True if a menu is open
-- @realm client
function vguihandler.IsOpen()
	return IsValid(vguihandler.menuCache.frame) or false
end

local function InternalUpdateVSkinSetting(name, panel)
	if name == "blur" then
		panel:SetBackgroundBlur(vskin.ShouldBlurBackground())

		panel:InvalidateLayout()
	elseif name == "skin" then
		panel:InvalidateLayout()
	elseif name == "language" then
		panel:InvalidateLayout()
	elseif name == "general_rebuild" then
		panel:InvalidateLayout()
	end
end

---
-- Should be called when a specific vskin variable is changed
-- so that the complete vgui element is redone
-- @param string name The name of the changed setting
-- @internal
-- @realm client
function vguihandler.UpdateVSkinSetting(name)
	if IsValid(vguihandler.menuCache.frame) then
		InternalUpdateVSkinSetting(name, vguihandler.menuCache.frame)
	end

	if IsValid(vguihandler.menuCache.hidden) then
		InternalUpdateVSkinSetting(name, vguihandler.menuCache.hidden)
	end
end

---
-- Rebuilds the whole menu without a specific changed settings
-- @realm client
function vguihandler.Rebuild()
	if isfunction(vguihandler.callback.frame["rebuild"]) then
		vguihandler.callback.frame["rebuild"](vguihandler.menuCache.frame)
	end

	if isfunction(vguihandler.callback.hidden["rebuild"]) then
		vguihandler.callback.hidden["rebuild"](vguihandler.menuCache.hidden)
	end

	vguihandler.UpdateVSkinSetting("general_rebuild")
end

---
-- Registers a callback function for a specific event
-- @param string name The name of the event
-- @param function fn The callback function
-- @realm client
function vguihandler.RegisterCallback(name, fn)
	if not isfunction(fn) then return end

	vguihandler.callback.frame[string.lower(name)] = fn
end
