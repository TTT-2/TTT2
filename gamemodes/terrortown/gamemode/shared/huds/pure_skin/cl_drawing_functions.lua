local shadow_border = surface.GetTextureID("vgui/ttt/dynamic/hud_components/shadow_border")

-- x, y, width, height, color
function DrawHUDElementBg(x, y, w, h, c)
	surface.SetDrawColor(clr(c))
	surface.DrawRect(x, y, w, h)
end

-- x, y, width, height, alpha
function DrawHUDElementLines(x, y, w, h, a)
	local corner_size = 7
	local shadow_size = 4
	local edge_size = 3

	surface.SetDrawColor(255, 255, 255, a)
	surface.SetTexture(shadow_border)

	surface.DrawTexturedRectUV(x - shadow_size, y + h - edge_size, corner_size, corner_size, 3.5/63, 52.5/63,  10.5/63, 59.5/63)

	surface.DrawTexturedRectUV(x + w - edge_size, y + h - edge_size, corner_size, corner_size, 52.5/63, 52.5/63,  59.5/63, 59.5/63)

	surface.DrawTexturedRectUV(x - shadow_size, y - shadow_size, corner_size, corner_size, 3.5/63, 3.5/63,  10.5/63, 10.5/63)

	surface.DrawTexturedRectUV(x  + w - edge_size, y - shadow_size, corner_size, corner_size, 52.5/63, 3.5/63,  59.5/63, 10.4/63)

	surface.DrawTexturedRectUV(x + edge_size, y + h - edge_size, w - 2 * edge_size, corner_size, 31.5/63, 52.5/63,  32.5/63, 59.5/63)

	surface.DrawTexturedRectUV(x - shadow_size, y + edge_size, corner_size, h - 2 * edge_size, 3.5/63, 31.5/63,  10.5/63, 32.5/63)

	surface.DrawTexturedRectUV(x + w - edge_size, y + edge_size, corner_size, h - 2 * edge_size, 52.5/63, 31.5/63,  59.5/63, 32.5/63)

	surface.DrawTexturedRectUV(x + edge_size, y - shadow_size, w - 2 * edge_size, corner_size, 31.5/63, 3.5/63,  32.5/63, 10.5/63)
end
