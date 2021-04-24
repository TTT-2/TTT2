if engine.ActiveGamemode() ~= "terrortown" then return end

-- This file forces clients to download the icons
-- If you are distributing those files via FastDL, comment out the line below.

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
resource.AddFile("materials/vgui/ttt/dynamic/roles/icon_no_team.vmt")
resource.AddFile("materials/vgui/ttt/dynamic/roles/icon_none.vmt")

resource.AddFile("materials/vgui/ttt/equip/reroll.png")

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

resource.AddFile("materials/vgui/ttt/icon_drown.vmt")

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

-- traitorbutton
resource.AddFile("materials/vgui/ttt/ttt2_hand_line.vmt") -- ttt2 traitor button hand unfocused
resource.AddFile("materials/vgui/ttt/ttt2_hand_filled.vmt") -- ttt2 traitor button hand focused
resource.AddFile("materials/vgui/ttt/ttt2_hand_outline.vmt") -- ttt2 traitor button hand outline

-- miniscoreboard indicator
resource.AddFile("materials/vgui/ttt/indirect_confirmed.vmt")
resource.AddFile("materials/vgui/ttt/revived.vmt")

-- items
resource.AddFile("materials/vgui/ttt/icon_armor.vmt") -- armor
resource.AddFile("materials/vgui/ttt/missing_equip_icon.vmt")
resource.AddFile("materials/vgui/ttt/perks/hud_disguiser.png") -- disguiser
resource.AddFile("materials/vgui/ttt/perks/hud_radar.png") -- radar

resource.AddFile("materials/vgui/ttt/perks/hud_armor.png") -- armor HUD
resource.AddFile("materials/vgui/ttt/perks/hud_armor_reinforced.png") -- armor reinforced HUD
resource.AddFile("materials/vgui/ttt/hud_armor.vmt") -- playerinfo armor
resource.AddFile("materials/vgui/ttt/hud_armor_reinforced.vmt") -- playerinfo armor reinforced

resource.AddFile("materials/vgui/ttt/hud_blocking_revival.vmt")

-- essential items
resource.AddFile("materials/vgui/ttt/icon_speedrun.vmt")
resource.AddFile("materials/vgui/ttt/perks/hud_speedrun.png")
resource.AddFile("materials/vgui/ttt/icon_nofiredmg.vmt")
resource.AddFile("materials/vgui/ttt/perks/hud_nofiredmg.png")
resource.AddFile("materials/vgui/ttt/icon_nofalldmg.vmt")
resource.AddFile("materials/vgui/ttt/perks/hud_nofalldmg.png")
resource.AddFile("materials/vgui/ttt/icon_noexplosiondmg.vmt")
resource.AddFile("materials/vgui/ttt/perks/hud_noexplosiondmg.png")
resource.AddFile("materials/vgui/ttt/icon_nodrowningdmg.vmt")
resource.AddFile("materials/vgui/ttt/perks/hud_nodrowningdmg.png")
resource.AddFile("materials/vgui/ttt/icon_nopropdmg.vmt")
resource.AddFile("materials/vgui/ttt/perks/hud_nopropdmg.png")
resource.AddFile("materials/vgui/ttt/icon_noenergydmg.vmt")
resource.AddFile("materials/vgui/ttt/perks/hud_noenergydmg.png")
resource.AddFile("materials/vgui/ttt/icon_nohazarddmg.vmt")
resource.AddFile("materials/vgui/ttt/perks/hud_nohazarddmg.png")

-- pickup symbols
resource.AddFile("materials/vgui/ttt/pickup/icon_heavy.png")
resource.AddFile("materials/vgui/ttt/pickup/icon_pistol.png")
resource.AddFile("materials/vgui/ttt/pickup/icon_nades.png")
resource.AddFile("materials/vgui/ttt/pickup/icon_special.png")
resource.AddFile("materials/vgui/ttt/pickup/icon_extra.png")
resource.AddFile("materials/vgui/ttt/pickup/icon_class.png")
resource.AddFile("materials/vgui/ttt/pickup/icon_ammo.png")

-- loading screen
resource.AddFile("materials/vgui/ttt/loadingscreen/loading.vtf")
resource.AddFile("materials/vgui/ttt/loadingscreen/img/bg.jpg")
resource.AddFile("materials/vgui/ttt/loadingscreen/img/ttt2_loading_logo.png")

-- dmgindicator themes
resource.AddFile("materials/vgui/ttt/dmgindicator/themes/default.png")
resource.AddFile("materials/vgui/ttt/dmgindicator/themes/simple.png")
resource.AddFile("materials/vgui/ttt/dmgindicator/themes/vanilla.png")

-- target ID icons
resource.AddFile("materials/vgui/ttt/tid/tid_big_role_not_known.vmt")
resource.AddFile("materials/vgui/ttt/tid/tid_big_corpse.vmt")
resource.AddFile("materials/vgui/ttt/tid/tid_big_tbutton_pointer.vmt")
resource.AddFile("materials/vgui/ttt/tid/tid_big_door.vmt")

-- target ID inline icons
resource.AddFile("materials/vgui/ttt/tid/tid_credits.vmt")
resource.AddFile("materials/vgui/ttt/tid/tid_detective.vmt")
resource.AddFile("materials/vgui/ttt/tid/tid_locked.vmt")
resource.AddFile("materials/vgui/ttt/tid/tid_auto_close.vmt")
resource.AddFile("materials/vgui/ttt/tid/tid_destructible.vmt")

-- derma skin graphics
resource.AddFile("materials/vgui/ttt/vskin/icon_close.vmt")
resource.AddFile("materials/vgui/ttt/vskin/icon_back.vmt")
resource.AddFile("materials/vgui/ttt/vskin/icon_collapse_closed.vmt")
resource.AddFile("materials/vgui/ttt/vskin/icon_collapse_opened.vmt")
resource.AddFile("materials/vgui/ttt/vskin/icon_reset.vmt")
resource.AddFile("materials/vgui/ttt/vskin/icon_disable.vmt")
resource.AddFile("materials/vgui/ttt/vskin/rhombus.vmt")
resource.AddFile("materials/vgui/ttt/vskin/helpscreen/addons.vmt")
resource.AddFile("materials/vgui/ttt/vskin/helpscreen/appearance.vmt")
resource.AddFile("materials/vgui/ttt/vskin/helpscreen/bindings.vmt")
resource.AddFile("materials/vgui/ttt/vskin/helpscreen/changelog.vmt")
resource.AddFile("materials/vgui/ttt/vskin/helpscreen/gameplay.vmt")
resource.AddFile("materials/vgui/ttt/vskin/helpscreen/guide.vmt")
resource.AddFile("materials/vgui/ttt/vskin/helpscreen/language.vmt")
resource.AddFile("materials/vgui/ttt/vskin/helpscreen/legacy.vmt")
resource.AddFile("materials/vgui/ttt/vskin/helpscreen/equipment.vmt")
resource.AddFile("materials/vgui/ttt/vskin/helpscreen/shops.vmt")
resource.AddFile("materials/vgui/ttt/vskin/helpscreen/administration.vmt")
resource.AddFile("materials/vgui/ttt/vskin/roundend/events.vmt")
resource.AddFile("materials/vgui/ttt/vskin/roundend/info.vmt")
resource.AddFile("materials/vgui/ttt/vskin/events/base_event.vmt")
resource.AddFile("materials/vgui/ttt/vskin/events/bodyfound.vmt")
resource.AddFile("materials/vgui/ttt/vskin/events/c4disarm.vmt")
resource.AddFile("materials/vgui/ttt/vskin/events/c4explode.vmt")
resource.AddFile("materials/vgui/ttt/vskin/events/c4plant.vmt")
resource.AddFile("materials/vgui/ttt/vskin/events/creditfound.vmt")
resource.AddFile("materials/vgui/ttt/vskin/events/finish.vmt")
resource.AddFile("materials/vgui/ttt/vskin/events/game.vmt")
resource.AddFile("materials/vgui/ttt/vskin/events/kill.vmt")
resource.AddFile("materials/vgui/ttt/vskin/events/respawn.vmt")
resource.AddFile("materials/vgui/ttt/vskin/events/rolechange.vmt")
resource.AddFile("materials/vgui/ttt/vskin/events/selected.vmt")
resource.AddFile("materials/vgui/ttt/vskin/events/spawn.vmt")

-- dna scanner icons, mats and models
resource.AddFile("models/weapons/v_ttt2_dna_scanner.mdl")
resource.AddFile("models/weapons/w_ttt2_dna_scanner.mdl")
resource.AddFile("materials/models/ttt2_dna_scanner/camera.vmt")
resource.AddFile("materials/models/ttt2_dna_scanner/screen.vmt")
resource.AddFile("materials/models/ttt2_dna_scanner/screen/arrow.vmt")
resource.AddFile("materials/models/ttt2_dna_scanner/screen/background.vmt")
resource.AddFile("materials/models/ttt2_dna_scanner/screen/check.vmt")
resource.AddFile("materials/models/ttt2_dna_scanner/screen/circle.vmt")
resource.AddFile("materials/models/ttt2_dna_scanner/screen/fail.vmt")
resource.AddFile("materials/vgui/ttt/dnascanner/dna_hud.vmt")

-- b-draw icons
resource.AddFile("materials/vgui/ttt/b-draw/icon_avatar_bot.vmt")
resource.AddFile("materials/vgui/ttt/b-draw/icon_avatar_default.vmt")
