-- This file forces clients to download the icons
-- If you are distributing those files via FastDL, comment out the line below.

if SERVER then
	-- logo
	resource.AddFile("materials/vgui/ttt/score_logo_2.vmt")

	-- BEM
	resource.AddFile("materials/vgui/ttt/equip/coin.png")
	resource.AddFile("materials/vgui/ttt/equip/briefcase.png")
	resource.AddFile("materials/vgui/ttt/equip/package.png")

	resource.AddFile("materials/vgui/ttt/dynamic/roles/icon_disabled.vmt")
	resource.AddFile("materials/vgui/ttt/dynamic/roles/icon_inno.vmt")
	resource.AddFile("materials/vgui/ttt/dynamic/roles/icon_traitor.vmt")
	resource.AddFile("materials/vgui/ttt/dynamic/roles/icon_det.vmt")

	-- dynamic
	resource.AddFile("materials/vgui/ttt/dynamic/base.vmt")
	resource.AddFile("materials/vgui/ttt/dynamic/base_overlay.vmt")

	resource.AddFile("materials/vgui/ttt/dynamic/icon_base.vmt")
	resource.AddFile("materials/vgui/ttt/dynamic/icon_base_base.vmt")
	resource.AddFile("materials/vgui/ttt/dynamic/icon_base_base_overlay.vmt")

	resource.AddFile("materials/vgui/ttt/dynamic/sprite_base.vmt")
	resource.AddFile("materials/vgui/ttt/dynamic/sprite_base_overlay.vmt")
end
