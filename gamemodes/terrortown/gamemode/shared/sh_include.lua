TTT2DIR = "terrortown/gamemode/"

TTTFiles = {
    -- client files
    cl_armor = { file = "cl_armor.lua", on = "client" },
    cl_awards = { file = "cl_awards.lua", on = "client" },
    cl_changes = { file = "cl_changes.lua", on = "client" },
    cl_chat = { file = "cl_chat.lua", on = "client" },
    cl_damage_indicator = { file = "cl_damage_indicator.lua", on = "client" },
    cl_equip = { file = "cl_equip.lua", on = "client" },
    cl_eventpopup = { file = "cl_eventpopup.lua", on = "client" },
    cl_help = { file = "cl_help.lua", on = "client" },
    cl_hud_editor = { file = "cl_hud_editor.lua", on = "client" },
    cl_hud_manager = { file = "cl_hud_manager.lua", on = "client" },
    cl_hudpickup = { file = "cl_hudpickup.lua", on = "client" },
    cl_inventory = { file = "cl_inventory.lua", on = "client" },
    cl_karma = { file = "cl_karma.lua", on = "client" },
    cl_keys = { file = "cl_keys.lua", on = "client" },
    cl_main = { file = "cl_main.lua", on = "client" },
    cl_msgstack = { file = "cl_msgstack.lua", on = "client" },
    cl_network_sync = { file = "cl_network_sync.lua", on = "client" },
    cl_player_ext = { file = "cl_player_ext.lua", on = "client" },
    cl_popups = { file = "cl_popups.lua", on = "client" },
    cl_radio = { file = "cl_radio.lua", on = "client" },
    cl_reroll = { file = "cl_reroll.lua", on = "client" },
    cl_scoreboard = { file = "cl_scoreboard.lua", on = "client" },
    cl_scoring = { file = "cl_scoring.lua", on = "client" },
    cl_search = { file = "cl_search.lua", on = "client" },
    cl_shop = { file = "cl_shop.lua", on = "client" },
    cl_shopeditor = { file = "cl_shopeditor.lua", on = "client" },
    cl_status = { file = "cl_status.lua", on = "client" },
    cl_marker_vision_data = { file = "cl_marker_vision_data.lua", on = "client" },
    cl_target_data = { file = "cl_target_data.lua", on = "client" },
    cl_targetid = { file = "cl_targetid.lua", on = "client" },
    cl_tbuttons = { file = "cl_tbuttons.lua", on = "client" },
    cl_tradio = { file = "cl_tradio.lua", on = "client" },
    cl_transfer = { file = "cl_transfer.lua", on = "client" },
    cl_voice = { file = "cl_voice.lua", on = "client" },
    cl_weapon_pickup = { file = "cl_weapon_pickup.lua", on = "client" },
    cl_wepswitch = { file = "cl_wepswitch.lua", on = "client" },

    -- shared files
    sh_armor = { file = "sh_armor.lua", on = "shared" },
    sh_corpse = { file = "sh_corpse.lua", on = "shared" },
    sh_decal = { file = "sh_decal.lua", on = "shared" },
    sh_door = { file = "sh_door.lua", on = "shared" },
    sh_entity = { file = "sh_entity.lua", on = "shared" },
    sh_equip_items = { file = "sh_equip_items.lua", on = "shared" },
    sh_hud_module = { file = "sh_hud_module.lua", on = "shared" },
    sh_hudelement_module = { file = "sh_hudelement_module.lua", on = "shared" },
    sh_init = { file = "sh_init.lua", on = "shared" },
    sh_inventory = { file = "sh_inventory.lua", on = "shared" },
    sh_item_module = { file = "sh_item_module.lua", on = "shared" },
    sh_lang = { file = "sh_lang.lua", on = "shared" },
    sh_main = { file = "sh_main.lua", on = "shared" },
    sh_network_sync = { file = "sh_network_sync.lua", on = "shared" },
    sh_player_ext = { file = "sh_player_ext.lua", on = "shared" },
    sh_playerclass = { file = "sh_playerclass.lua", on = "shared" },
    sh_printmessage_override = { file = "sh_printmessage_override.lua", on = "shared" },
    sh_cvar_handler = { file = "sh_cvar_handler.lua", on = "shared" },
    sh_role_module = { file = "sh_role_module.lua", on = "shared" },
    sh_rolelayering = { file = "sh_rolelayering.lua", on = "shared" },
    sh_scoring = { file = "sh_scoring.lua", on = "shared" },
    sh_shop = { file = "sh_shop.lua", on = "shared" },
    sh_shopeditor = { file = "sh_shopeditor.lua", on = "shared" },
    sh_sql = { file = "sh_sql.lua", on = "shared" },
    sh_sprint = { file = "sh_sprint.lua", on = "shared" },
    sh_voice = { file = "sh_voice.lua", on = "shared" },
    sh_speed = { file = "sh_speed.lua", on = "shared" },
    sh_weaponry = { file = "sh_weaponry.lua", on = "shared" },
    sh_marker_vision_element = { file = "sh_marker_vision_element.lua", on = "shared" },

    -- vgui client files
    vgui__cl_coloredbox = { file = "vgui/cl_coloredbox.lua", on = "client" },
    vgui__cl_droleimage = { file = "vgui/cl_droleimage.lua", on = "client" },
    vgui__cl_progressbar = { file = "vgui/cl_progressbar.lua", on = "client" },
    vgui__cl_sb_info = { file = "vgui/cl_sb_info.lua", on = "client" },
    vgui__cl_sb_main = { file = "vgui/cl_sb_main.lua", on = "client" },
    vgui__cl_sb_row = { file = "vgui/cl_sb_row.lua", on = "client" },
    vgui__cl_sb_team = { file = "vgui/cl_sb_team.lua", on = "client" },
    vgui__cl_scrolllabel = { file = "vgui/cl_scrolllabel.lua", on = "client" },
    vgui__cl_simpleclickicon = { file = "vgui/cl_simpleclickicon.lua", on = "client" },
    vgui__cl_simpleicon = { file = "vgui/cl_simpleicon.lua", on = "client" },
    vgui__cl_simpleroleicon = { file = "vgui/cl_simpleroleicon.lua", on = "client" },

    -- cl_vskin client files
    cl_vskin__default_skin = { file = "cl_vskin/default_skin.lua", on = "client" },
    cl_vskin__vgui__dpanel = { file = "cl_vskin/vgui/dpanel_ttt2.lua", on = "client" },
    cl_vskin__vgui__droleimage = { file = "cl_vskin/vgui/droleimage_ttt2.lua", on = "client" },
    cl_vskin__vgui__dframe = { file = "cl_vskin/vgui/dframe_ttt2.lua", on = "client" },
    cl_vskin__vgui__dimagecheckbox = {
        file = "cl_vskin/vgui/dimagecheckbox_ttt2.lua",
        on = "client",
    },
    cl_vskin__vgui__dmenubutton = { file = "cl_vskin/vgui/dmenubutton_ttt2.lua", on = "client" },
    cl_vskin__vgui__dsubmenubutton = {
        file = "cl_vskin/vgui/dsubmenubutton_ttt2.lua",
        on = "client",
    },
    cl_vskin__vgui__dnavpanel = { file = "cl_vskin/vgui/dnavpanel_ttt2.lua", on = "client" },
    cl_vskin__vgui__dcontentpanel = { file = "cl_vskin/vgui/dcontentpanel_ttt2.lua", on = "client" },
    cl_vskin__vgui__dshopcard = { file = "cl_vskin/vgui/dshopcard_ttt2.lua", on = "client" },
    cl_vskin__vgui__dcombocard = { file = "cl_vskin/vgui/dcombocard_ttt2.lua", on = "client" },
    cl_vskin__vgui__dbuttonpanel = { file = "cl_vskin/vgui/dbuttonpanel_ttt2.lua", on = "client" },
    cl_vskin__vgui__dcategoryheader = {
        file = "cl_vskin/vgui/dcategoryheader_ttt2.lua",
        on = "client",
    },
    cl_vskin__vgui__dcategorycollapse = {
        file = "cl_vskin/vgui/dcategorycollapse_ttt2.lua",
        on = "client",
    },
    cl_vskin__vgui__dform = { file = "cl_vskin/vgui/dform_ttt2.lua", on = "client" },
    cl_vskin__vgui__dbutton = { file = "cl_vskin/vgui/dbutton_ttt2.lua", on = "client" },
    cl_vskin__vgui__dbinder = { file = "cl_vskin/vgui/dbinder_ttt2.lua", on = "client" },
    cl_vskin__vgui__dlabel = { file = "cl_vskin/vgui/dlabel_ttt2.lua", on = "client" },
    cl_vskin__vgui__dcombobox = { file = "cl_vskin/vgui/dcombobox_ttt2.lua", on = "client" },
    cl_vskin__vgui__dcheckboxlabel = {
        file = "cl_vskin/vgui/dcheckboxlabel_ttt2.lua",
        on = "client",
    },
    cl_vskin__vgui__dnumslider = { file = "cl_vskin/vgui/dnumslider_ttt2.lua", on = "client" },
    cl_vskin__vgui__dtextentry = { file = "cl_vskin/vgui/dtextentry_ttt2.lua", on = "client" },
    cl_vskin__vgui__dbinderpanel = { file = "cl_vskin/vgui/dbinderpanel_ttt2.lua", on = "client" },
    cl_vskin__vgui__dscrollpanel = { file = "cl_vskin/vgui/dscrollpanel_ttt2.lua", on = "client" },
    cl_vskin__vgui__dvscrollbar = { file = "cl_vskin/vgui/dvscrollbar_ttt2.lua", on = "client" },
    cl_vskin__vgui__dcoloredbox = { file = "cl_vskin/vgui/dcoloredbox_ttt2.lua", on = "client" },
    cl_vskin__vgui__dcoloredtextbox = {
        file = "cl_vskin/vgui/dcoloredtextbox_ttt2.lua",
        on = "client",
    },
    cl_vskin__vgui__dtooltip = { file = "cl_vskin/vgui/dtooltip_ttt2.lua", on = "client" },
    cl_vskin__vgui__deventbox = { file = "cl_vskin/vgui/deventbox_ttt2.lua", on = "client" },
    cl_vskin__vgui__ddragbase = { file = "cl_vskin/vgui/ddragbase_ttt2.lua", on = "client" },
    cl_vskin__vgui__drolelayeringreceiver = {
        file = "cl_vskin/vgui/drolelayeringreceiver_ttt2.lua",
        on = "client",
    },
    cl_vskin__vgui__drolelayeringsender = {
        file = "cl_vskin/vgui/drolelayeringsender_ttt2.lua",
        on = "client",
    },
    cl_vskin__vgui__dsearchbar = { file = "cl_vskin/vgui/dsearchbar_ttt2.lua", on = "client" },
    cl_vskin__vgui__dsubmenulist = { file = "cl_vskin/vgui/dsubmenulist_ttt2.lua", on = "client" },
    cl_vskin__vgui__dinfoitem = { file = "cl_vskin/vgui/dinfoitem_ttt2.lua", on = "client" },
    cl_vskin__vgui__dprofilepanel = { file = "cl_vskin/vgui/dprofilepanel_ttt2.lua", on = "client" },
    cl_vskin__vgui__dweaponpreview = {
        file = "cl_vskin/vgui/dweaponpreview_ttt2.lua",
        on = "client",
    },
    cl_vskin__vgui__dpippanel = { file = "cl_vskin/vgui/dpippanel_ttt2.lua", on = "client" },
    cl_vskin__vgui__dplayergraph = { file = "cl_vskin/vgui/dplayergraph_ttt2.lua", on = "client" },
}

if SERVER then
    local tmp = { -- server files, don't show them for the client
        sv_addonchecker = { file = "sv_addonchecker.lua", on = "server" },
        sv_admin = { file = "sv_admin.lua", on = "server" },
        sv_armor = { file = "sv_armor.lua", on = "server" },
        sv_corpse = { file = "sv_corpse.lua", on = "server" },
        sv_ent_replace = { file = "sv_ent_replace.lua", on = "server" },
        sv_entity = { file = "sv_entity.lua", on = "server" },
        sv_eventpopup = { file = "sv_eventpopup.lua", on = "server" },
        sv_gamemsg = { file = "sv_gamemsg.lua", on = "server" },
        sv_hud_manager = { file = "sv_hud_manager.lua", on = "server" },
        sv_inventory = { file = "sv_inventory.lua", on = "server" },
        sv_karma = { file = "sv_karma.lua", on = "server" },
        sv_main = { file = "sv_main.lua", on = "server" },
        sv_networking = { file = "sv_networking.lua", on = "server" },
        sv_network_sync = { file = "sv_network_sync.lua", on = "server" },
        sv_player_ext = { file = "sv_player_ext.lua", on = "server" },
        sv_player = { file = "sv_player.lua", on = "server" },
        sv_propspec = { file = "sv_propspec.lua", on = "server" },
        sv_roleselection = { file = "sv_roleselection.lua", on = "server" },
        sv_scoring = { file = "sv_scoring.lua", on = "server" },
        sv_shop = { file = "sv_shop.lua", on = "server" },
        sv_shopeditor = { file = "sv_shopeditor.lua", on = "server" },
        sv_status = { file = "sv_status.lua", on = "server" },
        sv_voice = { file = "sv_voice.lua", on = "server" },
        sv_weaponry = { file = "sv_weaponry.lua", on = "server" },
    }

    table.Merge(TTTFiles, tmp)
end

---
-- @realm shared
hook.Run("TTT2ModifyFiles", TTTFiles)

if SERVER then
    for _, inc in pairs(TTTFiles) do
        if inc.on == "client" or inc.on == "shared" then
            AddCSLuaFile(TTT2DIR .. inc.on .. "/" .. inc.file)
        end
    end
end

---
-- Include a registered overwritable TTT2 file
-- @param string filename The registered filename-pseudo, but not the path
-- @realm shared
function ttt_include(filename)
    local fd = TTTFiles[filename]

    if not fd then
        error("[TTT2][ERROR] Tried to include missing file " .. filename)
    end

    local file = fd.file

    if file then
        file = TTT2DIR .. fd.on .. "/" .. file
    end

    if not file then
        return
    end

    include(file)
end

---
-- Called after creating the filetable of files that should be loaded, can be used
-- to modify which files should be loaded
-- @param table fileTbl The table of files that should be loaded
-- @hook
-- @realm shared
function GM:TTT2ModifyFiles(fileTbl) end
