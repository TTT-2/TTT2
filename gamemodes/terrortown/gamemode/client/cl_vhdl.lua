---
-- A vgui handler
-- @author Mineotopia

VHDL = VHDL or {
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
function VHDL.GenerateFrame(w, h, title, forceclose)
	if IsValid(VHDL.menuCache.frame) and not forceclose then return end

	VHDL.CloseFrame()

	VHDL.menuCache.frame = vgui.Create("DFrameTTT2")
	VHDL.menuCache.frame:SetSize(w, h)
	VHDL.menuCache.frame:Center()
	VHDL.menuCache.frame:SetTitle(title)
	VHDL.menuCache.frame:SetVisible(true)
	VHDL.menuCache.frame:SetDraggable(true)
	VHDL.menuCache.frame:ShowCloseButton(true)
	VHDL.menuCache.frame:ShowBackButton(false)
	VHDL.menuCache.frame:SetDeleteOnClose(true)
	VHDL.menuCache.frame:SetBackgroundBlur(VSKIN.ShouldBlurBackground())
	VHDL.menuCache.frame:SetSkin("ttt2_default")

	VHDL.menuCache.frame:MakePopup()
	VHDL.menuCache.frame:SetKeyboardInputEnabled(false)

	return VHDL.menuCache.frame
end

-- Call this function to clear the contents of a opened frame.
-- Does nothing if no frame is oped. Parameters are optional, old
-- values are kept if not set
-- @param number w The width of the panel
-- @param number h The height of the panel
-- @param string title The title of the panel
-- @warn Navigation buttons will be reinititialized
-- @return @{Panel} The cleared DFrameTTT2 object
function VHDL.ClearFrame(w, h, title)
	if not IsValid(VHDL.menuCache.frame) then return end

	if isfunction(VHDL.callback.frame["clear"]) then
		local shouldCancel = VHDL.callback.frame["clear"](VHDL.menuCache.frame) == false

		if shouldCancel then return end
	end

	local oldW, oldH = VHDL.menuCache.frame:GetSize()
	local oldTitle = VHDL.menuCache.frame:GetTitle()

	VHDL.menuCache.frame:Clear()
	VHDL.menuCache.frame:InitButtons()
	VHDL.menuCache.frame:ShowBackButton(false)

	if w ~= oldW or h ~= oldH then
		VHDL.menuCache.frame:SetSize(w or oldW, h or oldH)
		VHDL.menuCache.frame:Center()
	end

	if title ~= oldTitle then
		VHDL.menuCache.frame:SetTitle(title or oldTitle)
	end

	VHDL.callback.frame = {}

	return VHDL.menuCache.frame
end

---
-- Call this function to permanently close a frame, does
-- nothing if no frame is open.
-- @realm client
function VHDL.CloseFrame()
	if not IsValid(VHDL.menuCache.frame) then return end

	if isfunction(VHDL.callback.frame["close"]) then
		local shouldCancel = VHDL.callback.frame["close"](VHDL.menuCache.frame) == false

		if shouldCancel then return end
	end

	VHDL.menuCache.frame:SetDeleteOnClose(true)
	VHDL.menuCache.frame:Close()

	VHDL.menuCache.frame = nil
	VHDL.callback.frame = {}
end

---
-- Call this function to hide a frame, does nothing if no
-- frame is open. Also calls a callback function if set.
-- @realm client
function VHDL.HideFrame()
	if not IsValid(VHDL.menuCache.frame) or IsValid(VHDL.menuCache.hidden) then return end

	if isfunction(VHDL.callback.frame["hide"]) then
		local shouldCancel = VHDL.callback.frame["hide"](VHDL.menuCache.frame) == false

		if shouldCancel then return end
	end

	VHDL.menuCache.frame:SetDeleteOnClose(false)
	VHDL.menuCache.frame:Close()

	-- move frame to hidden
	VHDL.menuCache.hidden = VHDL.menuCache.frame
	VHDL.menuCache.frame = nil

	VHDL.callback.hidden = VHDL.callback.frame
	VHDL.callback.frame = {}
end

---
-- Returns if a menu is currently hidden
-- @return boolean The hide state
-- @realm client
function VHDL.IsHidden()
	return IsValid(VHDL.menuCache.hidden) or false
end

---
-- Call this function to unhide a frame, does nothing if no
-- frame was hidden. Also calls a callback function if set.
-- @realm client
function VHDL.UnhideFrame()
	if not IsValid(VHDL.menuCache.hidden) then return end

	if isfunction(VHDL.callback.hidden["unhide"]) then
		local shouldCancel = VHDL.callback.hidden["unhide"](VHDL.menuCache.hidden) == false

		if shouldCancel then return end
	end

	-- close frame if there was one opened while being hidden
	VHDL.CloseFrame()

	-- if closing failed (can be stopped by callback), hiding
	-- also fails
	if IsValid(VHDL.menuCache.frame) then return end

	VHDL.menuCache.hidden:SetDeleteOnClose(true)
	VHDL.menuCache.hidden:SetVisible(true)

	-- move frame from hidden to active frame
	VHDL.menuCache.frame = VHDL.menuCache.hidden
	VHDL.menuCache.hidden = nil

	VHDL.callback.frame = VHDL.callback.hidden
	VHDL.callback.hidden = {}
end

---
-- Returns if a menu is open or not
-- @return boolean True if a menu is open
-- @realm client
function VHDL.IsOpen()
	return IsValid(VHDL.menuCache.frame) or false
end

local function InternalUpdateVSkinSetting(name, panel)
	if name == "blur" then
		panel:SetBackgroundBlur(VSKIN.ShouldBlurBackground())

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
function VHDL.UpdateVSkinSetting(name)
	if IsValid(VHDL.menuCache.frame) then
		InternalUpdateVSkinSetting(name, VHDL.menuCache.frame)
	end

	if IsValid(VHDL.menuCache.hidden) then
		InternalUpdateVSkinSetting(name, VHDL.menuCache.hidden)
	end
end

---
-- Rebuilds the whole menu without a specific changed settings
-- @realm client
function VHDL.Rebuild()
	if isfunction(VHDL.callback.frame["rebuild"]) then
		VHDL.callback.frame["rebuild"](VHDL.menuCache.frame)
	end

	if isfunction(VHDL.callback.hidden["rebuild"]) then
		VHDL.callback.hidden["rebuild"](VHDL.menuCache.hidden)
	end

	VHDL.UpdateVSkinSetting("general_rebuild")
end

---
-- Registers a callback function for a specific event
-- @param string name The name of the event
-- @param function fn The callback function
-- @realm client
function VHDL.RegisterCallback(name, fn)
	if not isfunction(fn) then return end

	VHDL.callback.frame[string.lower(name)] = fn
end
