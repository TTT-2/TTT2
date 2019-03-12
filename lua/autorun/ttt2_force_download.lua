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

	-- pureSkin Hud border and shadow
	resource.AddFile("materials/vgui/ttt/dynamic/hud_components/shadow_border.vmt")

	-- target icon
	resource.AddFile("materials/vgui/ttt/target_icon.vmt")

	-- watching icon
	resource.AddFile("materials/vgui/ttt/watching_icon.vmt")

	-- credit icons
	resource.AddFile("materials/vgui/ttt/equip/credits_default.vmt")
	resource.AddFile("materials/vgui/ttt/equip/credits_zero.vmt")

	-- old ttt hud preview
	resource.AddFile("materials/vgui/ttt/huds/old_ttt/preview.png")

	-- pure skin hud preview
	resource.AddFile("materials/vgui/ttt/huds/pure_skin/preview.png")

	-- ttt indicators
	resource.AddFile("materials/vgui/ttt/ttt2_indicator_dev.vmt") -- ttt2 dev
	resource.AddFile("materials/vgui/ttt/ttt2_indicator_vip.vmt") -- vip
	resource.AddFile("materials/vgui/ttt/ttt2_indicator_addondev.vmt") -- ttt2 addon dev
	resource.AddFile("materials/vgui/ttt/ttt2_indicator_admin.vmt") -- server admin
	resource.AddFile("materials/vgui/ttt/ttt2_indicator_streamer.vmt") -- streamer
	resource.AddFile("materials/vgui/ttt/ttt2_indicator_heroes.vmt") -- ttt2 heroes

	-- miniscoreboard indicator
	resource.AddFile("materials/vgui/ttt/indirect_confirmed.vmt")
	resource.AddFile("materials/vgui/ttt/revived.vmt")

	-- ITEMs
	resource.AddFile("materials/vgui/ttt/icon_armor.vmt") -- armor
	resource.AddFile("materials/vgui/ttt/perks/hud_armor.png") -- armor HUD
	resource.AddFile("materials/vgui/ttt/perks/hud_disguiser.png") -- disguiser
	resource.AddFile("materials/vgui/ttt/perks/hud_radar.png") -- radar
end
