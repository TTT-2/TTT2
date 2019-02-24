-- This file forces clients to download the icons
-- If you are distributing those files via FastDL, comment out the line below.

if SERVER then
	-- logo
	resource.AddFile("gamemodes/terrortown/logo.png")
	resource.AddFile("materials/vgui/ttt/score_logo_2.vmt")

	-- BEM
	resource.AddFile("materials/vgui/ttt/equip/coin.png")
	resource.AddFile("materials/vgui/ttt/equip/briefcase.png")
	resource.AddFile("materials/vgui/ttt/equip/package.png")
	resource.AddFile("materials/vgui/ttt/equip/icon_info.vmt")
	resource.AddFile("materials/vgui/ttt/equip/icon_team_limited.vmt")
	resource.AddFile("materials/vgui/ttt/equip/icon_global_limited.vmt")

	resource.AddFile("materials/vgui/ttt/dynamic/roles/icon_inno.vmt")
	resource.AddFile("materials/vgui/ttt/dynamic/roles/icon_traitor.vmt")
	resource.AddFile("materials/vgui/ttt/dynamic/roles/icon_det.vmt")

	-- ShopEditor
	resource.AddFile("materials/vgui/ttt/dynamic/roles/icon_disabled.vmt")
	resource.AddFile("materials/vgui/ttt/dynamic/roles/icon_shop_default.vmt")
	resource.AddFile("materials/vgui/ttt/dynamic/roles/icon_shop_custom.vmt")

	-- dynamic
	resource.AddFile("materials/vgui/ttt/dynamic/base.vmt")
	resource.AddFile("materials/vgui/ttt/dynamic/base_overlay.vmt")

	resource.AddFile("materials/vgui/ttt/dynamic/icon_base.vmt")
	resource.AddFile("materials/vgui/ttt/dynamic/icon_base_base.vmt")
	resource.AddFile("materials/vgui/ttt/dynamic/icon_base_base_overlay.vmt")

	resource.AddFile("materials/vgui/ttt/dynamic/sprite_base.vmt")
	resource.AddFile("materials/vgui/ttt/dynamic/sprite_base_overlay.vmt")

	-- old ttt hud items background
	resource.AddFile("materials/vgui/ttt/perks/old_ttt_bg.png")

	-- ttt vip indicator
	resource.AddFile("materials/vgui/ttt/ttt2_vip_indicator.vmt")
end
