local shadow_border = Material("vgui/ttt/dynamic/hud_components/shadow_border.png" )
shadow_border = surface.GetTextureID("vgui/ttt/dynamic/hud_components/shadow_border")

-- x, y, width, height, color
function DrawHUDElementBg(x, y, w, h, c)	
	surface.SetDrawColor(clr(c))
	surface.DrawRect(x, y, w, h)
end

-- x, y, width, height, alpha
function DrawHUDElementLines(x, y, w, h)
	local corner_size = 7
	local shadow_size = 4
	local edge_size = 3

	surface.SetDrawColor( 255, 255, 255, 255 )
	--surface.SetMaterial( shadow_border )
	surface.SetTexture( shadow_border )
	
	surface.DrawTexturedRectUV( x - shadow_size, y + h - edge_size, corner_size, corner_size, 3/63, 52/63,  10/63, 59/63 )
	
	surface.DrawTexturedRectUV( x + w - edge_size, y + h - edge_size, corner_size, corner_size, 52/63, 52/63,  59/63, 59/63 )
	
	surface.DrawTexturedRectUV( x - shadow_size, y - shadow_size, corner_size, corner_size, 3/63, 3/63,  10/63, 10/63)
	
	surface.DrawTexturedRectUV( x  + w - edge_size, y - shadow_size, corner_size, corner_size, 52/63, 3/63,  59/63, 10/63 )
	
	surface.DrawTexturedRectUV( x + edge_size, y + h - edge_size, w - 2 * edge_size, corner_size, 32/63, 52/63,  33/63, 59/63 )
	
	surface.DrawTexturedRectUV( x - shadow_size, y + edge_size, corner_size, h - 2 * edge_size, 3/63, 32/63,  10/63, 33/63 )
	
	surface.DrawTexturedRectUV( x + w - edge_size, y + edge_size, corner_size, h - 2 * edge_size, 52/63, 32/63,  59/63, 33/63 )
	
	surface.DrawTexturedRectUV( x + edge_size, y - shadow_size, w - 2 * edge_size, corner_size, 32/63, 3/63,  33/63, 10/63 )
	
end
