---
-- A handler for the skin colors
-- @author Mineotopia

AddCSLuaFile()

-- the rest of the vskin library is client only
if SERVER then return end

local cv_selectedVSkin = CreateConVar("ttt2_selected_vskin", "dark_ttt2", {FCVAR_ARCHIVE})
local cv_blurVSkin = CreateConVar("ttt2_vskin_blur", 1, {FCVAR_ARCHIVE})

vskin = vskin or {}

vskin.skins = vskin.skins or {}

vskin.selected = vskin.selected or ""

---
-- Register a new vskin
-- @param string name The unique name of your vskin
-- @param table skin The skin table
-- @realm client
function vskin.RegisterVSkin(name, skin)
	if vskin.skins[name] then
		print("[TTT2 Skin] A skin with this name already exists!")

		return
	end

	vskin.skins[name] = skin
end

---
-- Select a registered vskin
-- @param string name The unique name of the vskin, if nil the convar value is read
-- @return boolean Returns true if skin was selected
-- @realm client
function vskin.SelectVSkin(skinName)
	if not skinName then
		vskin.selected = cv_selectedVSkin:GetString()

		return true
	end

	if not vskin.skins[skinName] then
		return false
	end

	vskin.selected = skinName
	cv_selectedVSkin:SetString(skinName)

	vguihandler.UpdateVSkinSetting()

	return true
end

---
-- Returns a table of the names of all registered vskins
-- @return table The list of all names
-- @realm client
function vskin.GetVSkinList()
	local names = {}

	for name, _ in pairs(vskin.skins) do
		names[#names + 1] = name
	end

	return names
end

---
-- Returns the name of the currently selected vskin
-- @return string The name of the vskin
-- @realm client
function vskin.GetVSkinName()
	return vskin.selected
end

---
-- Returns the name of the default vskin
-- @return string The name of the vskin
-- @realm client
function vskin.GetDefaultVSkinName()
	return cv_selectedVSkin:GetDefault()
end

---
-- Sets the background blur state
-- @param [default=true] boolean state
-- @realm client
function vskin.SetBlurBackground(state)
	cv_blurVSkin:SetBool(state == nil and true or state)
end

---
-- Returns if the background of vskin elements should
-- be blurred or not
-- @realm client
function vskin.ShouldBlurBackground()
	return cv_blurVSkin:GetBool()
end

---
-- Returns the background color of the currently selected vskin
-- @return [default=Color(255, 255, 255, 255)] Color The background color
-- @realm client
function vskin.GetBackgroundColor()
	if not vskin.skins[vskin.selected] then
		return COLOR_WHITE
	end

	return vskin.skins[vskin.selected].colors.background
end

---
-- Returns the accent color of the currently selected vskin
-- @return [default=Color(255, 255, 255, 255)] Color The accent color
-- @realm client
function vskin.GetAccentColor()
	if not vskin.skins[vskin.selected] then
		return COLOR_WHITE
	end

	return vskin.skins[vskin.selected].colors.accent
end

---
-- Returns the dark accent color of the currently selected vskin
-- @return [default=Color(255, 255, 255, 255)] Color The dark accent color
-- @realm client
function vskin.GetDarkAccentColor()
	if not vskin.skins[vskin.selected] then
		return COLOR_WHITE
	end

	return vskin.skins[vskin.selected].colors.accent_dark
end

---
-- Returns the scrollbar color of the currently selected vskin
-- @return [default=Color(255, 255, 255, 255)] Color The scrollbar color
-- @realm client
function vskin.GetScrollbarColor()
	if not vskin.skins[vskin.selected] then
		return COLOR_WHITE
	end

	return vskin.skins[vskin.selected].colors.scroll
end

---
-- Returns the scrollbar track color of the currently selected vskin
-- @return [default=Color(255, 255, 255, 255)] Color The scrollbar track color
-- @realm client
function vskin.GetScrollbarTrackColor()
	if not vskin.skins[vskin.selected] then
		return COLOR_WHITE
	end

	return vskin.skins[vskin.selected].colors.scroll_track
end

---
-- Returns the shadow color of the currently selected vskin
-- @return [default=Color(255, 255, 255, 255)] Color The shadow color
-- @realm client
function vskin.GetShadowColor()
	if not vskin.skins[vskin.selected] then
		return COLOR_WHITE
	end

	return vskin.skins[vskin.selected].colors.shadow
end

---
-- Returns the title text color of the currently selected vskin
-- @return [default=Color(255, 255, 255, 255)] Color The title text color
-- @realm client
function vskin.GetTitleTextColor()
	if not vskin.skins[vskin.selected] then
		return COLOR_WHITE
	end

	return vskin.skins[vskin.selected].colors.title_text
end

---
-- Returns the shadow size of the currently selected vskin
-- @return [default=5] number The shadow size
-- @realm client
function vskin.GetShadowSize()
	if not vskin.skins[vskin.selected] then
		return 5
	end

	return vskin.skins[vskin.selected].params.shadow_size
end

---
-- Returns the header height of the currently selected vskin
-- @return [default=45] number The header height
-- @realm client
function vskin.GetHeaderHeight()
	if not vskin.skins[vskin.selected] then
		return 45
	end

	return vskin.skins[vskin.selected].params.header_height
end

---
-- Returns the collapsable height of the currently selected vskin
-- @return [default=45] number The collapsable height
-- @realm client
function vskin.GetCollapsableHeight()
	if not vskin.skins[vskin.selected] then
		return 30
	end

	return vskin.skins[vskin.selected].params.collapsable_height
end

---
-- Returns the border size of the currently selected vskin
-- @return [default=3] number The border size
-- @realm client
function vskin.GetBorderSize()
	if not vskin.skins[vskin.selected] then
		return 3
	end

	return vskin.skins[vskin.selected].params.border_size
end

---
-- Returns the corner radius of the currently selected vskin
-- @return [default=6] number The corner radius
-- @realm client
function vskin.GetCornerRadius()
	if not vskin.skins[vskin.selected] then
		return 6
	end

	return vskin.skins[vskin.selected].params.corner_radius
end
