TTTFiles = {
	corpse_shd = {file = "corpse_shd_main.lua", on = "shared"},
	cl_awards = {file = "cl_awards_main.lua", on = "client"},
	cl_changes = {file = "cl_changes_main.lua", on = "client"},
	cl_chat = {file = "cl_chat_main.lua", on = "client"},
	cl_credits = {file = "cl_credits_main.lua", on = "client"},
	cl_disguise = {file = "cl_disguise_main.lua", on = "client"},
	cl_equip = {file = "cl_equip_main.lua", on = "client"},
	cl_help = {file = "cl_help_main.lua", on = "client"},
	cl_hud_item = {file = "cl_hud_item_main.lua", on = "client"},
	cl_hud = {file = "cl_hud_main.lua", on = "client"},
	cl_hudpickup = {file = "cl_hudpickup_main.lua", on = "client"},
	cl_init = {file = "cl_init_main.lua", on = "client"},
	cl_keys = {file = "cl_keys_main.lua", on = "client"},
	cl_msgstack = {file = "cl_msgstack_main.lua", on = "client"},
	cl_popups = {file = "cl_popups_main.lua", on = "client"},
	cl_radar = {file = "cl_radar_main.lua", on = "client"},
	cl_radio = {file = "cl_radio_main.lua", on = "client"},
	cl_scoreboard = {file = "cl_scoreboard_main.lua", on = "client"},
	cl_scoring = {file = "cl_scoring_main.lua", on = "client"},
	cl_scoring_events = {file = "cl_scoring_events_main.lua", on = "client"},
	cl_search = {file = "cl_search_main.lua", on = "client"},
	cl_targetid = {file = "cl_targetid_main.lua", on = "client"},
	cl_tbuttons = {file = "cl_tbuttons_main.lua", on = "client"},
	cl_tips = {file = "cl_tips_main.lua", on = "client"},
	cl_transfer = {file = "cl_transfer_main.lua", on = "client"},
	cl_voice = {file = "cl_voice_main.lua", on = "client"},
	cl_wepswitch = {file = "cl_wepswitch_main.lua", on = "client"},
	cl_shopeditor = {file = "cl_shopeditor_main.lua", on = "client"},
	equip_items_shd = {file = "equip_items_shd_main.lua", on = "shared"},
	lang_shd = {file = "lang_shd_main.lua", on = "shared"},
	player_ext_shd = {file = "player_ext_shd_main.lua", on = "shared"},
	scoring_shd = {file = "scoring_shd_main.lua", on = "shared"},
	sh_init = {file = "sh_init_main.lua", on = "shared"},
	shared = {file = "shared_main.lua", on = "shared"},
	util = {file = "util_main.lua", on = "shared"},
	vgui__coloredbox = {file = "vgui/coloredbox_main.lua", on = "client"},
	vgui__droleimage = {file = "vgui/droleimage_main.lua", on = "client"},
	vgui__simpleicon = {file = "vgui/simpleicon_main.lua", on = "client"},
	vgui__shopeditor_buttons = {file = "vgui/shopeditor_buttons_main.lua", on = "client"},
	vgui__simpleclickicon = {file = "vgui/simpleclickicon_main.lua", on = "client"},
	vgui__progressbar = {file = "vgui/progressbar_main.lua", on = "client"},
	vgui__scrolllabel = {file = "vgui/scrolllabel_main.lua", on = "client"},
	vgui__sb_main = {file = "vgui/sb_main_main.lua", on = "client"},
	vgui__sb_row = {file = "vgui/sb_row_main.lua", on = "client"},
	vgui__sb_team = {file = "vgui/sb_team_main.lua", on = "client"},
	vgui__sb_info = {file = "vgui/sb_info_main.lua", on = "client"},
	weaponry_shd = {file = "weaponry_shd_main.lua", on = "shared"}
}

if SERVER then
	local tmp = { -- don't show them for the client
		admin = {file = "admin_main.lua", on = "server"},
		corpse = {file = "corpse_main.lua", on = "server"},
		ent_replace = {file = "ent_replace_main.lua", on = "server"},
		entity = {file = "entity_main.lua", on = "server"},
		gamemsg = {file = "gamemsg_main.lua", on = "server"},
		init = {file = "init_main.lua", on = "server"},
		karma = {file = "karma_main.lua", on = "server"},
		player_ext = {file = "player_ext_main.lua", on = "server"},
		player = {file = "player_main.lua", on = "server"},
		propspec = {file = "propspec_main.lua", on = "server"},
		radar = {file = "radar_main.lua", on = "server"},
		scoring = {file = "scoring_main.lua", on = "server"},
		traitor_state = {file = "traitor_state_main.lua", on = "server"},
		voice = {file = "voice_main.lua", on = "server"},
		weaponry = {file = "weaponry_main.lua", on = "server"},
		shopeditor = {file = "shopeditor_main.lua", on = "server"}
	}

	table.Merge(TTTFiles, tmp)
end

hook.Run("TTT2ModifyFiles", TTTFiles)

if SERVER then
	for _, inc in pairs(TTTFiles) do
		if inc.on == "client" or inc.on == "shared" then
			AddCSLuaFile(inc.file)
		end
	end
end

function ttt_include(filename, relative)
	local file = TTTFiles[filename].file

	if relative then
		local splits = string.Explode("/", file)
		file = splits[#splits]
	end

	if not file then return end

	include(file)
end
