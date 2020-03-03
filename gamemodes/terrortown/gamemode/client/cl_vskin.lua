---
-- A handler of the skin colors
-- @author Mineotopia

VSKIN = {}

VSKIN.colors = {
	background = Color(255, 255, 255, 255),
	accent = Color(47, 137, 221, 255),
	accent_dark = Color(18, 87, 151, 255),
	shadow = Color(0, 0, 0, 100),
	title_text = Color(255, 255, 255, 255)
}

VSKIN.params = {
	shadow_size = 4,
	header_height = 45
}

function VSKIN:GetBackgroundColor()
	return self.colors.background
end

function VSKIN:GetAccentColor()
	return self.colors.accent
end

function VSKIN:GetDarkAccentColor()
	return self.colors.accent_dark
end

function VSKIN:GetShadowColor()
	return self.colors.shadow
end

function VSKIN:GetTitleTextColor()
	return self.colors.title_text
end

function VSKIN:GetShadowSize()
	return self.params.shadow_size
end

function VSKIN:GetHeaderHeight()
	return self.params.header_height
end

-- use https://wiki.facepunch.com/gmod/Panel:InvalidateLayout on skin change
-- to run PerformLayout on all elements
