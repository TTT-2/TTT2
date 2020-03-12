---
-- A vgui handler
-- @author Mineotopia

VHDL = VHDL or {}
VHDL.menuCache = {}
VHDL.callback = {}

-- Call this function to create a new frame. Clears
-- the existing frame, if a frame is already opened.
-- @warn Navigation buttons will be reinititialized when clearing
-- @return @{Panel} The created/cleared DFrameTTT2 object
function VHDL.GenerateFrame(w, h, title)
	if IsValid(VHDL.menuCache.frame) then
		return VHDL.ClearFrame()
	end

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
-- Does nothing if no frame is oped.
-- @warn Navigation buttons will be reinititialized
-- @return @{Panel} The cleared DFrameTTT2 object
function VHDL.ClearFrame()
	if not IsValid(VHDL.menuCache.frame) then return end

	VHDL.menuCache.frame:Clear()
	VHDL.menuCache.frame:InitButtons()

	return VHDL.menuCache.frame
end

---
-- Call this function to permanently close a frame, does
-- nothing if no frame is open.
-- @realm client
function VHDL.CloseFrame()
	if not IsValid(VHDL.menuCache.frame) then return end

	VHDL.menuCache.frame:SetDeleteOnClose(true)
	VHDL.menuCache.frame:Close()

	VHDL.menuCache = {}
	VHDL.callback = {}
end

---
-- Call this function to hide a frame, does nothing if no
-- frame is open. Also calls a callback function if set.
-- @realm client
function VHDL.HideFrame()
	if not IsValid(VHDL.menuCache.frame) then return end

	if isfunction(VHDL.callback["hide"]) then
		local shouldCancel = VHDL.callback["hide"](VHDL.menuCache.frame) == false

		if shouldCancel then return end
	end

	VHDL.menuCache.frame:SetDeleteOnClose(false)
	VHDL.menuCache.frame:Close()

	VHDL.menuCache.hidden = true
end

---
-- Returns if a menu is currently hidden
-- @return boolean The hide state
-- @realm client
function VHDL.IsHidden()
	return VHDL.menuCache.hidden or false
end

---
-- Call this function to unhide a frame, does nothing if no
-- frame was hidden. Also calls a callback function if set.
-- @realm client
function VHDL.UnhideFrame()
	if not VHDL.menuCache.hidden or not IsValid(VHDL.menuCache.frame) then return end

	if isfunction(VHDL.callback["unhide"]) then
		local shouldCancel = VHDL.callback["unhide"](VHDL.menuCache.frame) == false

		if shouldCancel then return end
	end

	VHDL.menuCache.frame:SetDeleteOnClose(true)
	VHDL.menuCache.frame:SetVisible(true)

	VHDL.menuCache.hidden = false
end

---
-- Returns if a menu is open or not
-- @return boolean True if a menu is open
-- @realm client
function VHDL.IsOpen()
	return IsValid(VHDL.menuCache.frame)
end

---
-- Should be called when a specific vskin variable is changed
-- so that the complete vgui element is redone
-- @param string name The name of the changed setting
-- @internal
-- @realm client
function VHDL.UpdateVSkinSetting(name)
	if not IsValid(VHDL.menuCache.frame) then return end

	if name == "blur" then
		VHDL.menuCache.frame:SetBackgroundBlur(VSKIN.ShouldBlurBackground())

		VHDL.menuCache.frame:InvalidateLayout()
	elseif name == "skin" then
		VHDL.menuCache.frame:InvalidateLayout()
	end
end

---
-- Registers a callback function for a specific event
-- @param string name The name of the event
-- @param function fn The callback function
-- @realm client
function VHDL.RegisterCallback(name, fn)
	if not isfunction(fn) then return end

	VHDL.callback[string.lower(name)] = fn
end
