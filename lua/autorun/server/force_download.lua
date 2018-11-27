-- This file forces clients to download the icons
-- If you are distributing those files via FastDL, comment out the line below.

if SERVER then
	resource.AddFile("materials/vgui/ttt/equip/coin.png")
	resource.AddFile("materials/vgui/ttt/equip/briefcase.png")
	resource.AddFile("materials/vgui/ttt/equip/package.png")

	resource.AddFile("materials/vgui/ttt/dynamic/icon_det.vmt")
	resource.AddFile("materials/vgui/ttt/dynamic/icon_traitor.vmt")
	resource.AddFile("materials/vgui/ttt/dynamic/icon_inno.vmt")

	-- dynamic
	resource.AddFile("materials/vgui/ttt/dynamic/base.vmt")
	resource.AddFile("materials/vgui/ttt/dynamic/icon_base.vmt")
	resource.AddFile("materials/vgui/ttt/dynamic/sprite_base.vmt")
end
