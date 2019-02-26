TTT2DIR = "terrortown/gamemode/"

TTTFiles = {
	-- client files
	cl_awards = {file = "cl_awards.lua", on = "client"},
	cl_changes = {file = "cl_changes.lua", on = "client"},
	cl_chat = {file = "cl_chat.lua", on = "client"},
	cl_equip = {file = "cl_equip.lua", on = "client"},
	cl_help = {file = "cl_help.lua", on = "client"},
	cl_hud_manager = {file = "cl_hud_manager.lua", on = "client"},
	cl_hudpickup = {file = "cl_hudpickup.lua", on = "client"},
	cl_keys = {file = "cl_keys.lua", on = "client"},
	cl_main = {file = "cl_main.lua", on = "client"},
	cl_msgstack = {file = "cl_msgstack.lua", on = "client"},
	cl_popups = {file = "cl_popups.lua", on = "client"},
	cl_radio = {file = "cl_radio.lua", on = "client"},
	cl_scoreboard = {file = "cl_scoreboard.lua", on = "client"},
	cl_scoring = {file = "cl_scoring.lua", on = "client"},
	cl_scoring_events = {file = "cl_scoring_events.lua", on = "client"},
	cl_search = {file = "cl_search.lua", on = "client"},
	cl_shopeditor = {file = "cl_shopeditor.lua", on = "client"},
	cl_targetid = {file = "cl_targetid.lua", on = "client"},
	cl_tbuttons = {file = "cl_tbuttons.lua", on = "client"},
	cl_tips = {file = "cl_tips.lua", on = "client"},
	cl_transfer = {file = "cl_transfer.lua", on = "client"},
	cl_voice = {file = "cl_voice.lua", on = "client"},
	cl_wepswitch = {file = "cl_wepswitch.lua", on = "client"},

	-- shared files
	sh_corpse = {file = "sh_corpse.lua", on = "shared"},
	sh_equip_items = {file = "sh_equip_items.lua", on = "shared"},
	sh_hud_manager = {file = "sh_hud_manager.lua", on = "shared"},
	sh_init = {file = "sh_init.lua", on = "shared"},
	sh_lang = {file = "sh_lang.lua", on = "shared"},
	sh_main = {file = "sh_main.lua", on = "shared"},
	sh_player_ext = {file = "sh_player_ext.lua", on = "shared"},
	sh_scoring = {file = "sh_scoring.lua", on = "shared"},
	sh_shopeditor = {file = "sh_shopeditor.lua", on = "shared"},
	sh_sql = {file = "sh_sql.lua", on = "shared"},
	sh_sprint = {file = "sh_sprint.lua", on = "shared"},
	sh_util = {file = "sh_util.lua", on = "shared"},
	sh_weaponry = {file = "sh_weaponry.lua", on = "shared"},

	-- vgui client files
	vgui__cl_coloredbox = {file = "vgui/cl_coloredbox.lua", on = "client"},
	vgui__cl_droleimage = {file = "vgui/cl_droleimage.lua", on = "client"},
	vgui__cl_hudswitcher = {file = "vgui/cl_hudswitcher.lua", on = "client"},
	vgui__cl_simpleicon = {file = "vgui/cl_simpleicon.lua", on = "client"},
	vgui__cl_settings_button = {file = "vgui/vgui__cl_settings_button.lua", on = "client"},
	vgui__cl_shopeditor_buttons = {file = "vgui/cl_shopeditor_buttons.lua", on = "client"},
	vgui__cl_shopeditor_slider = {file = "vgui/cl_shopeditor_slider.lua", on = "client"},
	vgui__cl_simpleclickicon = {file = "vgui/cl_simpleclickicon.lua", on = "client"},
	vgui__cl_progressbar = {file = "vgui/cl_progressbar.lua", on = "client"},
	vgui__cl_scrolllabel = {file = "vgui/cl_scrolllabel.lua", on = "client"},
	vgui__cl_sb_main = {file = "vgui/cl_sb_main.lua", on = "client"},
	vgui__cl_sb_row = {file = "vgui/cl_sb_row.lua", on = "client"},
	vgui__cl_sb_team = {file = "vgui/cl_sb_team.lua", on = "client"},
	vgui__cl_sb_info = {file = "vgui/cl_sb_info.lua", on = "client"},
}

if SERVER then
	local tmp = { -- server files, don't show them for the client
		sv_admin = {file = "sv_admin.lua", on = "server"},
		sv_corpse = {file = "sv_corpse.lua", on = "server"},
		sv_ent_replace = {file = "sv_ent_replace.lua", on = "server"},
		sv_entity = {file = "sv_entity.lua", on = "server"},
		sv_gamemsg = {file = "sv_gamemsg.lua", on = "server"},
		sv_hud_manager = {file = "sv_hud_manager.lua", on = "server"},
		sv_main = {file = "sv_main.lua", on = "server"},
		sv_karma = {file = "sv_karma.lua", on = "server"},
		sv_player_ext = {file = "sv_player_ext.lua", on = "server"},
		sv_player = {file = "sv_player.lua", on = "server"},
		sv_propspec = {file = "sv_propspec.lua", on = "server"},
		sv_scoring = {file = "sv_scoring.lua", on = "server"},
		sv_shopeditor = {file = "sv_shopeditor.lua", on = "server"},
		sv_traitor_state = {file = "sv_traitor_state.lua", on = "server"},
		sv_voice = {file = "sv_voice.lua", on = "server"},
		sv_weaponry = {file = "sv_weaponry.lua", on = "server"},
	}

	table.Merge(TTTFiles, tmp)
end

hook.Run("TTT2ModifyFiles", TTTFiles)

if SERVER then
	for _, inc in pairs(TTTFiles) do
		if inc.on == "client" or inc.on == "shared" then
			AddCSLuaFile(TTT2DIR .. inc.on .. "/" .. inc.file)
		end
	end
end

function ttt_include(filename)
	local fd = TTTFiles[filename]

	if not fd then
		error("[TTT2][ERROR] Tried to include a not existant file" .. filename)
	end

	local file = fd.file

	if file then
		file = TTT2DIR .. fd.on .. "/" .. file
	end

	if not file then return end

	include(file)
end
