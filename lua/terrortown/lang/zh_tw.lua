-- Traditional Chinese language strings (by TEGTianFan)

local L = LANG.CreateLanguage("zh_tw")

-- Compatibility language name that might be removed soon.
-- the alias name is based on the original TTT language name:
-- https://github.com/Facepunch/garrysmod/blob/master/garrysmod/gamemodes/terrortown/gamemode/lang/tradchinese.lua
L.__alias = "正體中文"

L.lang_name = "正體中文（Traditional Chinese）"

-- General text used in various places
L.traitor = "叛徒"
L.detective = "探長"
L.innocent = "無辜者"
L.last_words = "遺言"

L.terrorists = "恐怖分子"
L.spectators = "旁觀者"

L.nones = "無陣營"
L.innocents = "無辜陣營"
L.traitors = "叛徒陣營"

-- Round status messages
L.round_minplayers = "沒有足夠的玩家來開始新的回合..."
L.round_voting = "投票進行中，新的回合將延遲到 {num} 秒後開始..."
L.round_begintime = "新回合將在 {num} 秒後開始。請做好準備。"

L.round_traitors_one = "叛徒，你得自己頂住了。"
L.round_traitors_more = "叛徒，你的隊友是：{names}"

L.win_time = "時間用盡，叛徒失敗了。"
L.win_traitors = "叛徒取得了勝利！"
L.win_innocents = "叛徒們被擊敗了！"
L.win_nones = "無人勝出！（平局）"
L.win_showreport = "一起觀看觀看 {num} 秒的回合總結吧！"

L.limit_round = "達到回合限制。即將加載下一張地圖。"
L.limit_time = "達到時間限制。即將加載下一張地圖。"
L.limit_left_session_mode_1 = "新地圖將在 {num} 回合或 {time} 分鐘後切換。"
--L.limit_left_session_mode_2 = "{time} minutes remaining before the map changes."
--L.limit_left_session_mode_3 = "{num} round(s) remaining before the map changes."

-- Credit awards
L.credit_all = "你的陣營因為表現獲得了 {num} 點信用點數。"
L.credit_kill = "你殺死 {role} 獲得了 {num} 點信用點數。"

-- Karma
L.karma_dmg_full = "你的業值為 {amount}，因此本回合你擁有造成百分之百傷害的待遇！"
L.karma_dmg_other = "你的業值為 {amount}，因此本回合你造成的傷害將減少 {num}%"

-- Body identification messages
L.body_found = "{finder} 發現了 {victim} 的屍體。 {role}"
L.body_found_team = "{finder} 發現了 {victim} 的屍體。{role} ({team})"

-- The {role} in body_found will be replaced by one of the following:
L.body_found_traitor = "他是一位叛徒！"
L.body_found_det = "他是一位探長。"
L.body_found_inno = "他是一位無辜者。"

L.body_call = "{player} 呼喚探長前來檢查 {victim} 的屍體！"
L.body_call_error = "你必須先確定該玩家的死，才能呼叫探長！"

L.body_burning = "噢！ 這屍體著火了！"
L.body_credits = "你在屍體上找到 {num} 點的信用點數！"

-- Menus and windows
L.close = "關閉"
L.cancel = "取消"

-- For navigation buttons
L.next = "下一個"
L.prev = "上一個"

-- Equipment buying menu
L.equip_title = "裝備"
L.equip_tabtitle = "購買裝備"

L.equip_status = "購買選單"
L.equip_cost = "你的信用點數剩下 {num} 點。"
L.equip_help_cost = "你買的每一件裝備都消耗 1 點的信用點數。"

L.equip_help_carry = "你只能在擁有空位時購買物品。"
L.equip_carry = "你能攜帶這件裝備。"
L.equip_carry_own = "你已擁有這件裝備。"
L.equip_carry_slot = "已擁有武器欄第 {slot} 項的武器。"
L.equip_carry_minplayers = "服務器玩家數量不足以啟用這個武器。"

L.equip_help_stock = "每回合你只能購買一件相同的物品。"
L.equip_stock_deny = "這件物品不會再有庫存。"
L.equip_stock_ok = "這件物品已有庫存。"

L.equip_custom = "自訂物品新增於伺服器中。"

L.equip_spec_name = "名字"
L.equip_spec_type = "類型"
L.equip_spec_desc = "描述"

L.equip_confirm = "購買裝備"

-- Disguiser tab in equipment menu
L.disg_name = "偽裝物"
L.disg_menutitle = "偽裝控制器"
L.disg_not_owned = "你無法持有偽裝物！"
L.disg_enable = "執行偽裝"

L.disg_help1 = "偽裝開啟後，別人瞄準你時，將不會看見你的名字，生命以及業值。除此之外，你也能躲避探長的雷達。"
L.disg_help2 = "可直接在主選單外，使用數字鍵來切換偽裝。你也可以用控制台指令綁定一個按鍵（ttt_toggle_disguise）。"

-- Radar tab in equipment menu
L.radar_name = "雷達"
L.radar_menutitle = "雷達控制器"
L.radar_not_owned = "你未持有雷達！"
L.radar_scan = "執行掃描"
L.radar_auto = "自動重複掃描"
L.radar_help = "掃描結果將顯示 {num} 秒，接著雷達充電後你便可以再次使用。"
L.radar_charging = "你的雷達尚在充電中！"

-- Transfer tab in equipment menu
L.xfer_name = "傳送器"
L.xfer_menutitle = "傳送餘額"
L.xfer_send = "發送傳送餘額"

L.xfer_no_recip = "接收者無效，傳送餘額轉移失敗。"
L.xfer_no_credits = "傳送餘額不足，無法轉移"
L.xfer_success = "傳送點數成功轉移給 {player}！"
L.xfer_received = " {player} 給予你 {num} 點傳送餘額。"

-- Radio tab in equipment menu
L.radio_name = "收音機"

-- Radio soundboard buttons
L.radio_button_scream = "尖叫"
L.radio_button_expl = "爆炸"
L.radio_button_pistol = "手槍射擊"
L.radio_button_m16 = "M16步槍射擊"
L.radio_button_deagle = "沙漠之鷹射擊"
L.radio_button_mac10 = "MAC10衝鋒槍射擊"
L.radio_button_shotgun = "散彈射擊"
L.radio_button_rifle = "狙擊步槍射擊"
L.radio_button_huge = "M249機槍連發"
L.radio_button_c4 = "C4嗶嗶聲"
L.radio_button_burn = "燃燒"
L.radio_button_steps = "腳步聲"

-- Intro screen shown after joining
L.intro_help = "若你是遊戲初學者，可按下F1查看遊戲教學！"

-- Radiocommands/quickchat
L.quick_title = "快速聊天按鍵"

L.quick_yes = "是。"
L.quick_no = "不是。"
L.quick_help = "救命！"
L.quick_imwith = "我和 {player} 在一起。"
L.quick_see = "我看到了 {player}。"
L.quick_suspect = " {player} 行跡可疑。"
L.quick_traitor = " {player} 是叛徒！"
L.quick_inno = " {player} 是無辜者。"
L.quick_check = "還有人活著嗎？"

-- {player} in the quickchat text normally becomes a player nickname, but can
-- also be one of the below.  Keep these lowercase.
L.quick_nobody = "沒有人"
L.quick_disg = "有人偽裝了"
L.quick_corpse = "一具未搜索過的屍體"
L.quick_corpse_id = " {player} 的屍體"

-- Scoreboard
L.sb_playing = "你正在玩的伺服是.."
L.sb_mapchange_mode_0 = "地圖更換被禁用。"
L.sb_mapchange_mode_1 = "地圖將於 {num} 個回合或是 {time} 後更換"
--L.sb_mapchange_mode_2 = "Map changes in {time}"
--L.sb_mapchange_mode_3 = "Map changes in {num} rounds"

L.sb_mia = "下落不明"
L.sb_confirmed = "確認死亡"

L.sb_ping = "Ping"
L.sb_deaths = "死亡數"
L.sb_score = "分數"
L.sb_karma = "業值"

L.sb_info_help = "搜索此玩家的屍體，可以獲取一些線索。"

L.sb_tag_friend = "可信任者"
L.sb_tag_susp = "有嫌疑者"
L.sb_tag_avoid = "應迴避者"
L.sb_tag_kill = "已死者"
L.sb_tag_miss = "失蹤者"

-- Equipment actions, like buying and dropping
L.buy_no_stock = "無法購買此裝備：你已擁有它了。"
L.buy_pending = "你已訂購此裝備，請等待配送。"
L.buy_received = "你已收到此裝備。"

L.drop_no_room = "你沒有足夠空間存放新武器！"

L.disg_turned_on = "偽裝開啟！"
L.disg_turned_off = "偽裝關閉。"

-- Equipment item descriptions
L.item_passive = "被動效果型物品"
L.item_active = "主動操作型物品"
L.item_weapon = "武器"

L.item_armor = "身體裝甲"
L.item_armor_desc = [[
阻擋子彈，火焰和爆炸傷害。耐久會隨著使用而降低。

這個裝備可以購買多次。護甲達到一定閾值後防禦力會上升。]]

L.item_radar = "雷達"
L.item_radar_desc = [[
允許你掃描生命訊號。

一旦持有，它將自動掃描。需要啟用時，可在選單設定它]]

L.item_disg = "偽裝"
L.item_disg_desc = [[
啟用時，你的ID將被隱藏；也可避免探長在屍體上找到死者生前見到的最後一個人。

需要啟用時：在選單裡標記偽裝選項，或是按下相關數字鍵。]]

-- C4
L.c4_disarm_warn = "你所裝置的C4已被拆除。"
L.c4_armed = "C4裝置成功。"
L.c4_disarmed = "你成功拆除了C4。"
L.c4_no_room = "你無法攜帶C4。"

L.c4_desc = "C4爆炸！"

L.c4_arm = "裝置C4。"
L.c4_arm_timer = "計時器"
L.c4_arm_seconds = "引爆秒數："
L.c4_arm_attempts = "拆除C4時，六條引線中有 {num} 條會立即引發爆炸。"

L.c4_remove_title = "移除"
L.c4_remove_pickup = "撿起C4"
L.c4_remove_destroy1 = "銷毀C4"
L.c4_remove_destroy2 = "確認：銷毀"

L.c4_disarm = "拆除C4"
L.c4_disarm_cut = "點擊以剪斷 {num} 號引線"

L.c4_disarm_t = "剪斷引線以拆除C4。您是叛徒，當然每條引線都是安全的，但其他人可就沒那麼容易了！"
L.c4_disarm_owned = "剪斷引線以拆除C4。你是裝置此C4的人，細節瞭然於胸，任一條引線都可成功拆除。"
L.c4_disarm_other = "剪斷正確的引線以拆除C4。倘若你犯了錯，後果將不堪設想唷！"

L.c4_status_armed = "裝置"
L.c4_status_disarmed = "拆除"

-- Visualizer
L.vis_name = "顯像器"

L.vis_desc = [[
可讓犯罪現場顯像化的儀器。

分析屍體，顯像出死者被殺害時的情況，但僅限於死者遭到射殺時。]]

-- Decoy
L.decoy_name = "雷達誘餌"
L.decoy_broken = "你的雷達誘餌已被摧毀！"

L.decoy_short_desc = "這個誘餌會為其他陣營顯示一個假雷達信號"
L.decoy_pickup_wrong_team = "這個誘餌屬於其他陣營，你無法撿起"

L.decoy_desc = [[
顯示假的雷達信號給探長，探長執行DNA掃描時，將會顯示雷達誘餌的位置作為代替。]]

-- Defuser
L.defuser_name = "拆彈器"

L.defuser_desc = [[
迅速拆除一個C4。
不限制使用次數。若你持有此設備，
拆除C4時會輕鬆許多。]]

-- Flare gun
L.flare_name = "信號槍"

L.flare_desc = [[
可用來燒毀屍體，使它們永遠不會被發現。該武器有彈藥限制。

燃燒屍體時，會發出極度明顯的聲音。]]

-- Health station
L.hstation_name = "醫療站"

L.hstation_broken = "你的醫療站已被摧毀！"

L.hstation_desc = [[
設置後，允許人們前來治療。恢復速度相當緩慢。

所有人都可以使用，且醫療站本身也會受損。不僅如此，它亦可以檢驗每位使用者的DNA樣本。]]

-- Knife
L.knife_name = "刀子"
L.knife_thrown = "飛刀"

L.knife_desc = [[
可以迅速、無聲的殺死受傷的目標，但只能使用一次。

按下右鍵即可使用飛刀。]]

-- Poltergeist
L.polter_desc = [[
放置震動器在物體上，使它們粗暴地四處亂跑、亂跳。

能量爆炸，會使接近的人受到傷害。]]

-- Radio
L.radio_broken = "你的收音機已被摧毀！"

-- Silenced pistol
L.sipistol_name = "消音手槍"

L.sipistol_desc = [[
噪音極小的手槍。使用一般的手槍彈藥。

被害者被射殺時不會喊叫。]]

-- Newton launcher
L.newton_name = "牛頓發射器"

L.newton_desc = [[
推擊一個人，以換取安全距離。

彈藥無限，但射擊間隔較長。]]

-- Binoculars
L.binoc_name = "雙筒望遠鏡"

L.binoc_desc = [[
拉近鏡頭，可遠距離觀察並確認屍體。

不限使用次數，但確認屍體時會更花時間。]]

-- UMP
L.ump_desc = [[
實驗型衝鋒槍，容易失去控制。

使用標準衝鋒槍彈藥。]]

-- DNA scanner
L.dna_name = "DNA掃描器"
L.dna_notfound = "目標上沒有DNA樣本。"
L.dna_limit = "已達最大採集額度，新增前請先移除舊樣本。"
L.dna_decayed = "兇手的DNA樣本發生衰變。"
L.dna_killer = "成功採集到兇手的DNA樣本！"
L.dna_duplicate = "匹配！你的掃描儀裡已經有這個DNA樣本了。"
L.dna_no_killer = "DNA樣本無法檢索（兇手已斷線？）"
L.dna_armed = "炸彈已啟動！趕緊拆除它！"
--L.dna_object = "Collected a sample of the last owner from the object."
L.dna_gone = "區域內沒偵測到可採集之DNA樣本。"

L.dna_desc = [[
採集物體上的DNA樣本，並用其找尋對應的主人。

使用在屍體上，採集殺手的DNA並追蹤他。]]

-- Magneto stick
L.magnet_name = "電磁棍"

-- Grenades and misc
L.grenade_smoke = "煙霧彈"
L.grenade_fire = "燃燒彈"

L.unarmed_name = "收起武器"
L.crowbar_name = "鐵撬"
L.pistol_name = "手槍"
L.rifle_name = "狙擊槍"
L.shotgun_name = "散彈槍"

-- Teleporter
L.tele_name = "傳送裝置"
L.tele_failed = "傳送失敗"
L.tele_marked = "傳送地點已標記"

L.tele_no_ground = "你必須站在地面上來才能進行傳送！"
L.tele_no_crouch = "蹲著的時候不能傳送！"
L.tele_no_mark = "請先標記傳送地點，才能進行傳送。"

L.tele_no_mark_ground = "你必須站在地面上才能標記傳送地點！"
L.tele_no_mark_crouch = "你必須站起來才能標記傳送點！"

L.tele_help_pri = "傳送到已標記之傳送地點"
L.tele_help_sec = "標記傳送地點"

L.tele_desc = [[
可以傳送到先前標記的地點。

傳送器會產生噪音，而且使用次數是有限的。]]

-- Ammo names, shown when picked up
L.ammo_pistol = "9mm手槍彈藥"

L.ammo_smg1 = "衝鋒槍彈藥"
L.ammo_buckshot = "散彈槍彈藥"
L.ammo_357 = "步槍彈藥"
L.ammo_alyxgun = "沙漠之鷹彈藥"
L.ammo_ar2altfire = "信號彈藥"
L.ammo_gravity = "搗蛋鬼彈藥"

-- Round status
L.round_wait = "等待中"
L.round_prep = "準備中"
L.round_active = "遊戲進行中"
L.round_post = "回合結束"

-- Health, ammo and time area
L.overtime = "延長時間"
L.hastemode = "急速模式"

-- TargetID health status
L.hp_healthy = "健康的"
L.hp_hurt = "輕傷的"
L.hp_wounded = "輕重傷的"
L.hp_badwnd = "重傷的"
L.hp_death = "近乎死亡"

-- TargetID Karma status
L.karma_max = "名聲好"
L.karma_high = "有點粗魯"
L.karma_med = "扣扳機愛好者"
L.karma_low = "危險人物"
L.karma_min = "負人命債累累"

-- TargetID misc
L.corpse = "屍體"
--L.corpse_hint = "Press [{usekey}] to search and confirm. [{walkkey} + {usekey}] to search covertly."

L.target_disg = " （偽裝狀態）"
L.target_unid = "未確認的屍體"
L.target_unknown = "一名恐怖分子"

-- HUD buttons with hand icons that only some roles can see and use
L.tbut_single = "單獨使用"
L.tbut_reuse = "重複使用"
L.tbut_retime = "在 {num} 秒後重複使用"
L.tbut_help = "按下 [{usekey}] 鍵啟動"

-- Spectator muting of living/dead
L.mute_living = "將生存的玩家設定靜音"
L.mute_specs = "將旁觀者設定靜音"
L.mute_all = "全部靜音"
L.mute_off = "取消靜音"

-- Spectators and prop possession
L.punch_title = "重擊測量器 "
L.punch_bonus = "你的分數較低，重擊測量器上限減少 {num}"
L.punch_malus = "你的分數較高，重擊測量器上限增加 {num}！"

-- Info popups shown when the round starts
L.info_popup_innocent = [[
你是位無辜的恐怖分子！但你的周圍存在著叛徒...
你能相信誰？誰又會乘你不備殺害你？

注意背後並與同伴合作，努力生存下來！]]

L.info_popup_detective = [[
你是位探長！恐怖分子總部給予你許多特殊資源以揪出叛徒。
用它們來確保無辜者的生命，但請小心：
叛徒將優先殺害你！

按下 {menukey} 取得裝備！]]

L.info_popup_traitor_alone = [[
你是位叛徒！這回合中你沒有同伴！

殺死所有其他玩家，以獲得勝利！

按下 {menukey} 取得裝備！]]

L.info_popup_traitor = [[
你是位叛徒！和其他叛徒合作殺害其他所有人，以獲得勝利。
但請小心，你的身份可能會暴露...

你的同伴有：
{traitorlist}

按下{menukey}取得裝備！]]

-- Various other text
L.name_kick = "一名玩家因於此回合中改變了名字而被自動踢出遊戲。"

L.idle_popup = [[
你閒置了 {num} 秒，所以被轉往觀察者模式。當你位於此模式時，將不會在回合開始時重生。

你可在任何時間取消觀察者模式，按下 {helpkey} 並在選單取消勾選「觀察者模式」即可。當然，你也可以選擇立刻關閉它。]]

L.idle_popup_close = "什麼也不做"
L.idle_popup_off = "立刻關閉觀察者模式"

L.idle_warning = "警告：你已閒置一段時間，將轉往觀察者模式。活著就要動！"

L.spec_mode_warning = "你位於觀察者模式故將不會在回合開始時重生。若要關閉此模式，按下F1並取消勾選「觀察者模式」即可。"

-- Tips panel
L.tips_panel_title = "提示"
L.tips_panel_tip = "提示："

-- Tip texts
L.tip1 = "叛徒不用確認其死亡即可悄悄檢查屍體，只需對著屍體按著 {walkkey} 鍵後再按 {usekey} 鍵即可。"

L.tip2 = "將C4爆炸時間設置更長，可增加引線數量，使拆彈者失敗之可能性大幅上升，且能讓C4的嗶嗶聲更輕柔、更緩慢。"

L.tip3 = "探長能在屍體查出誰是「死者最後看見的人」。若是遭到背後攻擊，最後看見的將不會是兇手。"

L.tip4 = "被你的屍體被發現並確認之前，沒人知道你已經死亡。"

L.tip5 = "叛徒殺死探長時，會立即得到一點的信用點數。"

L.tip6 = "一名叛徒死後，所以探長將得到一點的信用點數作為獎勵。"

L.tip7 = "叛徒殺害無辜者，有了絕好進展時，所有叛徒將獲得一點的信用點數作為獎勵。"

L.tip8 = "叛徒和探長能從夥伴屍體上，取得未被消耗的信用點數。"

L.tip9 = "搗蛋鬼將使物體變得極其危險。搗蛋鬼調整過的物體將產生爆炸能量傷害接近它的人。"

--L.tip10 = "As a shopping role, keep in mind you are rewarded extra equipment credits if you and your comrades perform well. Make sure you remember to spend them!"

L.tip11 = "探長的DNA掃描器可使用在武器或道具上，找到曾使用它的玩家的位置。用在屍體或C4上效果將更好！"

L.tip12 = "太靠近你殺害的人的話，DNA將殘留在屍體上，探長的DNA掃描器會以此找到你的正確位置。切記，殺了人最好將屍體藏好！"

L.tip13 = "殺人時離被害者越遠，殘留在屍體上的DNA就會越快衰變！"

--L.tip14 = "Are you going sniping? Consider buying the Disguiser. If you miss a shot, run away to a safe spot, disable the Disguiser, and no one will know it was you who was shooting at them."

--L.tip15 = "If you have a Teleporter, it can help you escape when chased, and allows you to quickly travel across a big map. Make sure you always have a safe position marked."

L.tip16 = "是否遇過無辜者群聚在一起而難以下手？請試試用收音機發出C4嗶嗶聲或交火聲，讓他們分散。"

--L.tip17 = "Using the Radio, you can play sounds by looking at its placement marker after the radio has been placed. Queue up multiple sounds by clicking multiple buttons in the order you want them."

L.tip18 = "探長若有多餘的信用點數，可將拆彈器交給一位可信任的無辜者，將危險的C4交給他們，自己全神貫注地調查與處決叛徒。"

L.tip19 = "探長的望遠鏡可讓你遠距離搜索並確認屍體，壞消息是叛徒總是會用誘餌欺騙你。當然，使用望遠鏡的探長全身都是破綻。"

L.tip20 = "探長的醫療站可讓受傷的玩家恢復健康，當然，其中也包括叛徒..."

L.tip21 = "治療站將遺留每位前來治療的人的DNA樣本，探長可將其用在DNA掃描器上，尋找究竟誰曾受過治療。"

L.tip22 = "與武器、C4不同，收音機並不會留下你的DNA樣本，不用擔心探長會在上頭用DNA識破你的身分。"

--L.tip23 = "Press {helpkey} to view a short tutorial or modify some TTT-specific settings."

L.tip24 = "探長確認屍體後，相關訊息將在計分板公布，如要查看只需點擊死者之名字即可。"

L.tip25 = "計分板上，人物名字旁的放大鏡圖樣可以查看關於他的訊息，若圖樣亮著，代表是某位探長確認後的結果。"

--L.tip26 = "Corpses with a magnifying glass below the nickname have been searched by a Detective and their results are available to all players via the scoreboard."

L.tip27 = "觀察者可以按下 {mutekey} 循環調整對其他觀察者或遊戲中的玩家靜音。"

--L.tip28 = "You can switch to a different language at any time in the Settings menu by pressing {helpkey}."

L.tip29 = "若要使用語音或無線電，可以按下 {zoomkey} 使用。"

L.tip30 = "使用撬棍時，按下右鍵可推開其他玩家。"

L.tip31 = "使用武器瞄準器射擊將些微提升你的精準度，並降低後座力。蹲下則不會。"

L.tip32 = "煙霧彈於室內相當有效，尤其是在擁擠的房間中製造混亂。"

L.tip33 = "叛徒，請記住你能搬運屍體並將它們藏起來，避開無辜者與探長的耳目。"

L.tip34 = "在計分板上，點擊活人玩家的名字，可以選擇一個標記（如令人懷疑的或友好的）記錄這位玩家。此標誌會在你的準心指向該玩家時顯示。"

L.tip35 = "許多需放置的裝備（如C4或收音機），可以使用右鍵將其置於牆上。"

L.tip36 = "拆除C4時失誤導致的爆炸，比起直接引爆時來得小。"

--L.tip37 = "If it says 'HASTE MODE' above the round timer, the round will at first be only a few minutes long, but with every death the available time increases. This mode puts the pressure on the traitors to keep things moving."

-- Round report
L.report_title = "回合報告"

-- Tabs
L.report_tab_hilite = "重頭戲"
L.report_tab_hilite_tip = "回合重頭戲"
L.report_tab_events = "事件"
L.report_tab_events_tip = "發生在此回合的指標性事件"
L.report_tab_scores = "分數"
L.report_tab_scores_tip = "本回合單一玩家獲得的點數"

-- Event log saving
L.report_save = "儲存 Log.txt"
L.report_save_tip = "將事件記錄並儲存在txt檔內"
L.report_save_error = "沒有可供儲存的事件記錄"
L.report_save_result = "事件記錄已存在："

-- Columns
L.col_time = "時間"
L.col_event = "事件"
L.col_player = "玩家"
L.col_roles = "角色"
L.col_teams = "陣營"
L.col_kills1 = "無辜者殺敵數"
L.col_kills2 = "叛徒殺敵數"
L.col_points = "點數"
L.col_team = "團隊紅利"
L.col_total = "總分"

-- Awards/highlights
L.aw_sui1_title = "自殺邪教的教主"
L.aw_sui1_text = "率先向其他自殺者展示如何自殺。"

L.aw_sui2_title = "孤獨沮喪者"
L.aw_sui2_text = "就他一人自殺，無比哀戚。"

L.aw_exp1_title = "炸彈研究的第一把交椅"
L.aw_exp1_text = "決心研究C4， {num} 名受試者證明了他的學說。"

L.aw_exp2_title = "田野研究"
L.aw_exp2_text = "測試自己的抗暴性，顯然完全不夠高。"

L.aw_fst1_title = "第一滴血"
L.aw_fst1_text = "將第一位無辜者的生命送到叛徒手上。"

L.aw_fst2_title = "愚蠢的血腥首殺"
L.aw_fst2_text = "擊殺一名叛徒同伴而得到首殺，做得好啊！"

L.aw_fst3_title = "首殺大挫折"
L.aw_fst3_text = "第一殺便將無辜者同伴誤認為叛徒，真是挫折啊！"

L.aw_fst4_title = "吹響號角"
L.aw_fst4_text = "殺害一名叛徒，為無辜者陣營吹響了號角。"

L.aw_all1_title = "致命的平等"
L.aw_all1_text = "得為所有人的死負責的無辜者。"

L.aw_all2_title = "孤獨之狼"
L.aw_all2_text = "得為所有人的死負責的叛徒。"

L.aw_nkt1_title = "老大！我抓到一個！"
L.aw_nkt1_text = "在一名無辜者落單時策劃一場謀殺，漂亮！"

L.aw_nkt2_title = "一石二鳥"
L.aw_nkt2_text = "用另一具屍體證明上一槍不是巧合。"

L.aw_nkt3_title = "連續殺人魔"
L.aw_nkt3_text = "在今天結束了三名無辜者的生命。"

L.aw_nkt4_title = "穿梭在批著羊皮的狼之間的狼"
L.aw_nkt4_text = "將無辜者們作為晚餐吃了。共吃了 {num} 人。"

L.aw_nkt5_title = "反恐特工"
L.aw_nkt5_text = "每一殺都能拿到報酬，現在他已經買得起豪華遊艇了！"

L.aw_nki1_title = "背叛死亡吧！"
L.aw_nki1_text = "找出叛徒，將子彈送到他腦袋，簡單吧！"

L.aw_nki2_title = "申請進入正義連隊"
L.aw_nki2_text = "成功將兩名叛徒送下地獄。"

L.aw_nki3_title = "叛徒夢到過叛徒羊嗎？"
L.aw_nki3_text = "讓三名叛徒得到平靜。"

L.aw_nki4_title = "復仇者聯盟"
L.aw_nki4_text = "每一殺都能拿到報酬。你已經夠格加入復仇者聯盟了！"

L.aw_fal1_title = "不，龐德先生，我希望你跳下去"
L.aw_fal1_text = "將某人推下足以致死的高度。"

L.aw_fal2_title = "地板人"
L.aw_fal2_text = "讓自己的身體從極端無盡的高度上落地。"

L.aw_fal3_title = "人體流星"
L.aw_fal3_text = "讓一名玩家從高處落下，摔成爛泥。"

L.aw_hed1_title = "高效能"
L.aw_hed1_text = "發現爆頭的樂趣，並擊殺了 {num} 名敵人。"

L.aw_hed2_title = "神經內科"
L.aw_hed2_text = "近距離將 {num} 名玩家的腦袋取出，完成腦神經研究。"

L.aw_hed3_title = "是遊戲使我這麼做的"
L.aw_hed3_text = "運用殺人模擬訓練的技巧，爆了 {num} 顆頭"

L.aw_cbr1_title = "鏗鏗鏗"
L.aw_cbr1_text = "擁有相當規律的鐵撬舞動， {num} 名受害者能證明這點。"

L.aw_cbr2_title = "高登•弗里曼"
L.aw_cbr2_text = "離開黑山，用喜愛的撬棍殺了至少 {num} 名玩家。"

L.aw_pst1_title = "死亡之握"
L.aw_pst1_text = "用手槍殺死 {num} 名玩家前，都上前握了手。"

L.aw_pst2_title = "小口徑屠殺"
L.aw_pst2_text = "用手槍殺了 {num} 人的小隊。我們推測他槍管裡頭有個微型散彈槍。"

L.aw_sgn1_title = "簡單模式"
L.aw_sgn1_text = "用散彈槍近距離殺了 {num} 名玩家。"

L.aw_sgn2_title = "一千個小子彈"
L.aw_sgn2_text = "不喜歡自己的散彈，打算送人。但已有 {num} 名受贈人無法享受禮物了。"

L.aw_rfl1_title = "瞄準，射擊！"
L.aw_rfl1_text = "穩定的手上，那把狙擊槍奪去了 {num} 名玩家的生命。"

L.aw_rfl2_title = "我在這就看到你的頭了啦！"
L.aw_rfl2_text = "十分瞭解他的狙擊槍，其他 {num} 名玩家隨即也瞭解了他的狙擊槍。"

L.aw_dgl1_title = "這簡直像是小型狙擊槍"
L.aw_dgl1_text = "「沙鷹在手，天下我有！」，用沙漠之鷹殺了 {num} 名玩家。"

L.aw_dgl2_title = "老鷹大師"
L.aw_dgl2_text = "用他手中的沙漠之鷹殺了 {num} 名玩家。"

L.aw_mac1_title = "祈禱，然後趴倒"
L.aw_mac1_text = "用MAC10衝鋒槍殺了 {num} 名玩家，但別提他需要多少發子彈。"

L.aw_mac2_title = "大麥克的起司"
L.aw_mac2_text = "想知道他持有兩把衝鋒槍會發生什麼事？那大概是 {num} 殺的兩倍囉？"

L.aw_sip1_title = "黑人給我閉嘴！"
L.aw_sip1_text = "用消聲手槍射殺了 {num} 人。"

L.aw_sip2_title = "艾吉歐•奧狄托利"
L.aw_sip2_text = "殺死 {num} 個人，但沒有任何人會聽到它們的死前呢喃。見識刺客大師的風骨吧！"

L.aw_knf1_title = "刀子懂你"
L.aw_knf1_text = "在網路上用刀子捅人。"

L.aw_knf2_title = "你從哪弄來的啊？"
L.aw_knf2_text = "不是叛徒，但仍然用刀子殺了一些人。"

L.aw_knf3_title = "開膛手傑克"
L.aw_knf3_text = "在地上撿到 {num} 把匕首，並使用它們。"

L.aw_knf4_title = "我是赤屍藏人"
L.aw_knf4_text = "通過刀子殺死了 {num} 個人。我只是個醫生。"

L.aw_flg1_title = "玩火少年"
L.aw_flg1_text = "用燃燒彈導致 {num} 人死亡。"

L.aw_flg2_title = "汽油加上番仔火"
L.aw_flg2_text = "使 {num} 名玩家葬身於火海。"

L.aw_hug1_title = "子彈多喔！"
L.aw_hug1_text = "用M249機槍將子彈送到 {num} 名玩家身上。"

L.aw_hug2_title = "耐心大叔"
L.aw_hug2_text = "從未放下M249機槍的扳機，他殺戮了 {num} 名玩家。"

L.aw_msx1_title = "啪啪啪"
L.aw_msx1_text = "用M16步槍射殺了 {num} 名玩家。"

L.aw_msx2_title = "中距離瘋子"
L.aw_msx2_text = "了解如何用他手中的M16，射殺了敵人。共有 {num} 名不幸的亡魂。"

L.aw_tkl1_title = "拍謝"
L.aw_tkl1_text = "瞄準自己的隊友，並不小心扣下扳機。"

L.aw_tkl2_title = "拍謝拍謝"
L.aw_tkl2_text = "認為自己抓到了兩次叛徒，但兩次都錯了！"

L.aw_tkl3_title = "小心業值！"
L.aw_tkl3_text = "殺死兩個同伴已不能滿足他，三個才是他的最終目標！"

L.aw_tkl4_title = "專業賣同隊！"
L.aw_tkl4_text = "殺了所有同伴，我的天啊！砰砰砰──"

L.aw_tkl5_title = "最佳主角"
L.aw_tkl5_text = "扮演的是瘋子，真的，因為他殺了大多數的同伴。"

L.aw_tkl6_title = "莫非閣下是...低能兒？"
L.aw_tkl6_text = "弄不清他屬於哪一隊，並殺死了半數以上的隊友。"

L.aw_tkl7_title = "園丁"
L.aw_tkl7_text = "好好保護著自己的草坪，並殺死了四分之一以上的隊友。"

L.aw_brn1_title = "像小汝做菜一般"
L.aw_brn1_text = "使用燃燒彈點燃數個玩家，將他們炸得很脆！"

L.aw_brn2_title = "火化官"
L.aw_brn2_text = "將每一具被他殺死的受害者屍體燃燒乾淨。"

L.aw_brn3_title = "好想噴火！"
L.aw_brn3_text = "「燒死你們！」，但地圖上已沒有燃燒彈了！因為都被他用完了。"

L.aw_fnd1_title = "驗屍官"
L.aw_fnd1_text = "在地上發現 {num} 具屍體。"

L.aw_fnd2_title = "想全部看到！"
L.aw_fnd2_text = "在地上發現了 {num} 具屍體，做為收藏。"

L.aw_fnd3_title = "死亡的氣味"
L.aw_fnd3_text = "在這回合被屍體絆到了 {num} 次。"

L.aw_crd1_title = "環保官"
L.aw_crd1_text = "在同伴屍體上找到了 {num} 點剩餘的購買點。"

L.aw_tod1_title = "沒到手的勝利"
L.aw_tod1_text = "在他的團隊即將獲得勝利的前幾秒死去。"

L.aw_tod2_title = "人家不依啦！"
L.aw_tod2_text = "在這回合剛開始不久即被殺害。"

-- New and modified pieces of text are placed below this point, marked with the
-- version in which they were added, to make updating translations easier.

-- v24
L.drop_no_ammo = "你彈夾內的子彈不足以丟棄成彈藥盒。"

-- 2015-05-25
L.hat_retrieve = "你撿起了一頂探長的帽子。"

-- 2017-09-03
L.sb_sortby = "排序方法："

-- 2018-07-24
L.equip_tooltip_main = "裝備菜單"
L.equip_tooltip_radar = "雷達控製"
L.equip_tooltip_disguise = "偽裝器控製"
L.equip_tooltip_radio = "收音機控製"
L.equip_tooltip_xfer = "轉移信用點數"
L.equip_tooltip_reroll = "重選裝備"

L.confgrenade_name = "眩暈彈"
L.polter_name = "促狹鬼"
L.stungun_name = "實驗型 UMP"

L.knife_instant = "必殺"

L.binoc_zoom_level = "放大"
L.binoc_body = "發現屍體"

L.idle_popup_title = "掛機"

-- 2019-01-31
L.create_own_shop = "新建商店"
L.shop_link = "連接"
L.shop_disabled = "禁用商店"
L.shop_default = "使用默認商店"

-- 2019-05-05
L.reroll_name = "重選"
L.reroll_menutitle = "重選裝備"
L.reroll_no_credits = "你需要花費 {amount} 信用點數進行重選！"
L.reroll_button = "重選"
L.reroll_help = "使用 {amount} 積分在你的商店裡獲得新的隨機裝備！"

-- 2019-05-06
L.equip_not_alive = "在右側選擇身份來查看這個身份的全部裝備。不要忘記標記最愛裝備！"

-- 2019-06-27
L.shop_editor_title = "商店編輯器"
L.shop_edit_items_weapong = "修改武器/道具"
L.shop_edit = "修改商店"
L.shop_settings = "設置"
L.shop_select_role = "選擇身份"
L.shop_edit_items = "修改道具"
L.shop_edit_shop = "修改商店"
L.shop_create_shop = "新建自定義商店"
L.shop_selected = "選中 {role}"
L.shop_settings_desc = "改變數值來適應隨機商店參數。不要忘記保存！"

L.bindings_new = "{name} 的新按鍵：{key}"

L.hud_default_failed = "未能將界面 {hudname} 設為默認。你沒有權限，或這個界面不存在。"
L.hud_forced_failed = "未能將界面 {hudname} 設為強製。你沒有權限，或這個界面不存在。"
L.hud_restricted_failed = "未能將界面 {hudname} 設為限製。你沒有權限，或這個界面不存在。"

L.shop_role_select = "選擇身份"
L.shop_role_selected = "選中了 {role} 的商店！"
L.shop_search = "搜索"

-- 2019-10-19
L.drop_ammo_prevented = "有什麽東西阻擋你丟出子彈。"

-- 2019-10-28
L.target_c4 = "按 [{usekey}] 打開C4菜單"
L.target_c4_armed = "按 [{usekey}] 拆除C4"
L.target_c4_armed_defuser = "按 [{primaryfire}] 使用拆彈器"
L.target_c4_not_disarmable = "你不能拆除存活隊友的C4"
L.c4_short_desc = "可以炸得很歡"

L.target_pickup = "按 [{usekey}] 撿起"
L.target_slot_info = "槽位：{slot}"
L.target_pickup_weapon = "按 [{usekey}] 撿起武器"
L.target_switch_weapon = "按 [{usekey}] 和當前武器交換"
L.target_pickup_weapon_hidden = "按 [{walkkey} + {usekey}] 隱秘地撿起"
L.target_switch_weapon_hidden = "按 [{walkkey} + {usekey}] 隱秘地交換"
L.target_switch_weapon_nospace = "沒有提供給這個武器的槽位"
L.target_switch_drop_weapon_info = "丟棄槽位 {slot} 的 {name}"
L.target_switch_drop_weapon_info_noslot = "槽位 {slot} 沒有可丟棄的武器"

--L.corpse_searched_by_detective = "This corpse was searched by a public policing role"
L.corpse_too_far_away = "這個屍體太遠了。"

L.radio_short_desc = "武器聲音，悅耳動聽"

L.hstation_subtitle = "按 [{usekey}] 恢復生命"
L.hstation_charge = "剩余充能：{charge}"
L.hstation_empty = "這個醫療站沒有剩余充能"
L.hstation_maxhealth = "你的生命恢復已滿"
L.hstation_short_desc = "醫療站會逐漸回復充能"

-- 2019-11-03
L.vis_short_desc = "還原被槍殺的屍體的犯罪現場"
L.corpse_binoculars = "按 [{key}] 用望遠鏡搜查屍體"
L.binoc_progress = "搜查進度：{progress}%"

L.pickup_no_room = "你沒有存放此類武器的空間"
L.pickup_fail = "你無法撿起這個武器"
L.pickup_pending = "你已經撿起這個武器，請等撿起完成"

-- 2020-01-07
L.tbut_help_admin = "編輯叛徒按鈕設定"
L.tbut_role_toggle = "[{walkkey} + {usekey}] 切換 {role} 的按鈕權限"
L.tbut_role_config = "身份：{current}"
--L.tbut_team_toggle = "[SHIFT + {walkkey} + {usekey}] to toggle this button for {team}"
L.tbut_team_config = "陣營：{current}"
L.tbut_current_config = "當前設定："
L.tbut_intended_config = "地圖默認設定："
L.tbut_admin_mode_only = "只有你看得到這個，因為你是管理員而且 '{cv}' 目前被設為 '1'"
L.tbut_allow = "允許"
L.tbut_prohib = "禁止"
L.tbut_default = "默認"

-- 2020-02-09
L.name_door = "門"
L.door_open = "按 [{usekey}] 開門"
L.door_close = "按 [{usekey}] 關門"
L.door_locked = "此門被鎖上了"

-- 2020-02-11
L.automoved_to_spec = "（自動消息）我因為掛機而被移到了觀察者。"
L.mute_team = "靜音 {team}"

-- 2020-02-16
L.door_auto_closes = "此門會自動關閉"
L.door_open_touch = "此門接觸後會自動開啟"
L.door_open_touch_and_use = "接觸門或按 [{usekey}] 開門。"

-- 2020-03-09
L.help_title = "幫助和設定"

L.menu_changelog_title = "更新內容"
L.menu_guide_title = "TTT2 向導"
L.menu_bindings_title = "鍵位綁定"
L.menu_language_title = "語言"
L.menu_appearance_title = "外觀"
L.menu_gameplay_title = "遊戲性"
L.menu_addons_title = "插件"
L.menu_legacy_title = "舊式插件"
L.menu_administration_title = "管理"
L.menu_equipment_title = "編輯裝備"
L.menu_shops_title = "編輯商店"

L.menu_changelog_description = "最近版本的一系列優化和改動"
L.menu_guide_description = "幫助你開始遊玩 TTT2 並解釋玩法和身份等內容"
L.menu_bindings_description = "將 TTT2 和其插件的功能綁到你想要的鍵位"
L.menu_language_description = "選擇遊戲語言"
L.menu_appearance_description = "調整界面的樣式和性能"
--L.menu_gameplay_description = "Tweak voice and sound volume, accessibility settings, and gameplay settings."
L.menu_addons_description = "配置本地插件"
L.menu_legacy_description = "舊TTT的菜單，應該已被導入新系統"
L.menu_administration_description = "界面和商店的通用管理菜單"
L.menu_equipment_description = "設置裝備的價格，限製，可用性等"
L.menu_shops_description = "給身份添加菜單和裝備"

L.submenu_guide_gameplay_title = "玩法"
L.submenu_guide_roles_title = "身份"
L.submenu_guide_equipment_title = "裝備"

L.submenu_bindings_bindings_title = "鍵位綁定"

L.submenu_language_language_title = "語言"

L.submenu_appearance_general_title = "通用"
L.submenu_appearance_hudswitcher_title = "HUD 切換器"
L.submenu_appearance_vskin_title = "VSkin"
L.submenu_appearance_targetid_title = "目標高亮"
L.submenu_appearance_shop_title = "商店設置"
L.submenu_appearance_crosshair_title = "準星"
L.submenu_appearance_dmgindicator_title = "傷害指示"
L.submenu_appearance_performance_title = "性能"
L.submenu_appearance_interface_title = "界面"

L.submenu_gameplay_general_title = "通用"

L.submenu_administration_hud_title = "HUD 設置"
L.submenu_administration_randomshop_title = "隨機商店"

L.help_color_desc = "此選項啟用後，準星和目標高亮的外框會顯示一個全局通用的顏色"
L.help_scale_factor = "這個比例影響所有界面大小（HUD， vgui 和目標高亮）。屏幕分辨率修改後會自動更新這個比例。改變此比例會重置 HUD！"
L.help_hud_game_reload = "這個 HUD 當前無法使用，必須先重新加載遊戲。"
L.help_hud_special_settings = "以下是當前 HUD 的專用設定。"
L.help_vskin_info = "VSkin（vgui 皮膚）是應用在所有菜單界面（包括這個）的皮膚。皮膚可以用一個簡單的 Lua 腳本創建，並能改變顏色，大小等參數。"
L.help_targetid_info = "目標高亮（TargetID）是顯示在實體和玩家下面的信息。可以在通用菜單啟用全局顏色。"
L.help_hud_default_desc = "設置全體玩家的默認 HUD。未選擇 HUD 的玩家會使用這個，但已經選擇其他 HUD 的玩家不會受影響。"
L.help_hud_forced_desc = "強製選擇一個 HUD。這會阻止玩家選擇其他 HUD。"
L.help_hud_enabled_desc = "啟用/禁用 HUD 來限製玩家選擇它們。"
L.help_damage_indicator_desc = "傷害指示是收到傷害時屏幕上出現的標記。若要添加新的主題，請把 png 文件放置在 'materials/vgui/ttt/damageindicator/themes/' 文件夾中。"
L.help_shop_key_desc = "在回合開始/結束時，按商店鍵是否打開商店而不是計分板？"

L.label_menu_menu = "菜單"
L.label_menu_admin_spacer = "管理員選項"
L.label_language_set = "選擇語言"
L.label_global_color_enable = "啟用全局顏色"
L.label_global_color = "全局顏色"
L.label_global_scale_factor = "全局大小比例"
L.label_hud_select = "選擇 HUD"
L.label_vskin_select = "選擇 VSkin"
L.label_blur_enable = "選擇 VSkin 背景模糊"
L.label_color_enable = "選擇 VSkin 背景顏色"
L.label_minimal_targetid = "簡易目標高亮（沒有業值，提示等）"
L.label_shop_always_show = "一直顯示商店"
L.label_shop_double_click_buy = "啟用來雙擊購買商店裝備"
L.label_shop_num_col = "商店列數"
L.label_shop_num_row = "商店行數"
L.label_shop_item_size = "圖標大小"
L.label_shop_show_slot = "顯示裝備槽位"
L.label_shop_show_custom = "顯示自定義標記"
L.label_shop_show_fav = "顯示最愛標記"
L.label_crosshair_enable = "啟用十字準星"
L.label_crosshair_opacity = "準星透明度"
L.label_crosshair_ironsight_opacity = "瞄準時準星透明度"
L.label_crosshair_size = "準星長度"
L.label_crosshair_thickness = "準星粗細"
L.label_crosshair_thickness_outline = "準星外框粗細"
--L.label_crosshair_scale_enable = "Enable dynamic crosshair scale"
L.label_crosshair_ironsight_low_enabled = "瞄準時降低武器模型"
L.label_damage_indicator_enable = "啟用傷害指示"
L.label_damage_indicator_mode = "選擇傷害指示主題"
L.label_damage_indicator_duration = "受傷後指示顯示時間"
L.label_damage_indicator_maxdamage = "最大透明度對應傷害值"
L.label_damage_indicator_maxalpha = "最大透明度"
L.label_performance_halo_enable = "指向特定實體時顯示外框"
L.label_performance_spec_outline_enable = "啟用被附身物品的外框"
L.label_performance_ohicon_enable = "啟用頭上身份圖標"
L.label_interface_popup = "回合開始信息持續時間"
L.label_interface_fastsw_menu = "啟用快速切換菜單"
L.label_inferface_wswitch_hide_enable = "啟用武器菜單自動關閉"
L.label_inferface_scues_enable = "回合開始或結束時播放特定聲音"
L.label_gameplay_specmode = "觀察者模式（永遠觀察）"
L.label_gameplay_fastsw = "武器快速切換"
L.label_gameplay_hold_aim = "啟用持續瞄準"
L.label_gameplay_mute = "死亡時靜音存活玩家"
L.label_hud_default = "默認 HUD"
L.label_hud_force = "強製 HUD"

L.label_bind_voice = "全局語言"
L.label_bind_voice_team = "團隊語言"

L.label_hud_basecolor = "基礎顏色"

L.label_menu_not_populated = "這個子菜單什麽都沒有。"

L.header_bindings_ttt2 = "TTT2 鍵位"
L.header_bindings_other = "其他鍵位"
L.header_language = "語言設置"
L.header_global_color = "選擇全局顏色"
L.header_hud_select = "選擇 HUD"
L.header_hud_customize = "自定義 HUD"
L.header_vskin_select = "選擇並自定義 VSkin"
L.header_targetid = "目標高亮設置"
L.header_shop_settings = "裝備菜單設置"
L.header_shop_layout = "裝備頁面布局"
L.header_shop_marker = "裝備標記設置"
L.header_crosshair_settings = "準星設置"
L.header_damage_indicator = "傷害指示設置"
L.header_performance_settings = "性能設置"
L.header_interface_settings = "界面設置"
L.header_gameplay_settings = "遊戲性設置"
L.header_hud_administration = "選擇默認和強製 HUD"
L.header_hud_enabled = "啟用/禁用 HUDs"

L.button_menu_back = "返回"
L.button_none = "無"
L.button_press_key = "按任何鍵"
L.button_save = "保存"
L.button_reset = "重置"
L.button_close = "關閉"
L.button_hud_editor = "HUD 編輯器"

-- 2020-04-20
L.item_speedrun = "疾跑如風"
L.item_speedrun_desc = [[讓你的移動速度提高 50%！]]
L.item_no_explosion_damage = "防爆部隊"
L.item_no_explosion_damage_desc = [[讓你免疫爆炸傷害。]]
L.item_no_fall_damage = "金剛不敗腿"
L.item_no_fall_damage_desc = [[讓你免疫摔落傷害。]]
L.item_no_fire_damage = "消防員"
L.item_no_fire_damage_desc = [[讓你免疫火焰傷害。]]
L.item_no_hazard_damage = "防化部隊"
L.item_no_hazard_damage_desc = [[讓你免疫硫酸，輻射和毒氣傷害。]]
L.item_no_energy_damage = "電男"
L.item_no_energy_damage_desc = [[讓你免疫激光，電漿和電磁傷害。]]
L.item_no_prop_damage = "頭鐵"
L.item_no_prop_damage_desc = [[讓你免疫物品傷害。]]
L.item_no_drown_damage = "潛水員"
L.item_no_drown_damage_desc = [[讓你免疫溺水傷害。]]

-- 2020-04-21
L.dna_tid_possible = "可以掃描"
L.dna_tid_impossible = "無法掃描"
L.dna_screen_ready = "無 DNA"
L.dna_screen_match = "配對成功"

-- 2020-04-30
L.message_revival_canceled = "復活取消。"
L.message_revival_failed = "復活失敗。"
L.message_revival_failed_missing_body = "因為你的屍體不存在，復活失敗了。"
L.hud_revival_title = "復活剩余時間："
L.hud_revival_time = "{time}秒"

-- 2020-05-03
L.door_destructible = "此門不可摧毀（{health}生命）"

-- 2020-05-28
--L.corpse_hint_inspect_limited = "Press [{usekey}] to search. [{walkkey} + {usekey}] to only view search UI."

-- 2020-06-04
L.label_bind_disguiser = "切換偽裝器"

-- 2020-06-24
L.dna_help_primary = "收集DNA樣本"
L.dna_help_secondary = "切換當前DNA"
L.dna_help_reload = "刪除當前樣本"

L.binoc_help_pri = "確認屍體"
L.binoc_help_sec = "切換放大倍率"

L.vis_help_pri = "丟棄當前設備。"

-- 2020-08-07
L.pickup_error_spec = "作為觀察者你無法撿起這個。"
L.pickup_error_owns = "你已經有這個武器，無法再次撿起"
L.pickup_error_noslot = "你沒有對應空槽位，無法撿起這個"

-- 2020-11-02
L.lang_server_default = "服務器默認"
L.help_lang_info = [[
該語言翻譯已經{coverage}%，未翻譯的文本將會用英語作為默認的參考。

請記住，這些翻譯是基於社區提供的。如果有遺漏或不正確的地方，請自行修改。]]

-- 2021-04-13
L.title_score_info = "回合總結"
L.title_score_events = "事件時間表"

L.label_bind_clscore = "打開回合總結"
L.title_player_score = "{player}的評分："

L.label_show_events = "顯示相關的事件："
L.button_show_events_you = "你"
L.button_show_events_global = "全局"
L.label_show_roles = "顯示角色分配，當"
L.button_show_roles_begin = "回合開始時"
L.button_show_roles_end = "回合結束時"

L.hilite_win_traitors = "叛徒獲勝"
L.hilite_win_innocents = "無辜者獲勝"
L.hilite_win_tie = "達成共識"
L.hilite_win_time = "時間已到"

L.tooltip_karma_gained = "本局的人品值變化："
L.tooltip_score_gained = "本局得分變化："
L.tooltip_roles_time = "本局的角色變化："

--L.tooltip_finish_score_win = "Win: {score}"
L.tooltip_finish_score_alive_teammates = "存活的隊友：{score}"
L.tooltip_finish_score_alive_all = "存活的玩家：{score}"
L.tooltip_finish_score_timelimit = "超時：{score}"
L.tooltip_finish_score_dead_enemies = "死去的敵人：{score}"
L.tooltip_kill_score = "擊殺：{score}"
L.tooltip_bodyfound_score = "發現屍體：{score}"

--L.finish_score_win = "Win:"
L.finish_score_alive_teammates = "存活的隊友："
L.finish_score_alive_all = "存活的玩家："
L.finish_score_timelimit = "超時："
L.finish_score_dead_enemies = "死去的敵人："
L.kill_score = "擊殺："
L.bodyfound_score = "發現屍體："

L.title_event_bodyfound = "發現了一具屍體"
L.title_event_c4_disarm = "一枚C4被解除了"
L.title_event_c4_explode = "一枚C4爆炸了"
L.title_event_c4_plant = "放置了一枚C4"
L.title_event_creditfound = "信用點數被發現"
L.title_event_finish = "本回合已經結束"
L.title_event_game = "新回合已經開始"
L.title_event_kill = "一名玩家被殺害"
L.title_event_respawn = "一名玩家復活了"
L.title_event_rolechange = "一名玩家改變了它的角色或團隊"
L.title_event_selected = "角色分配"
L.title_event_spawn = "一名玩家生成了"

L.desc_event_bodyfound = "{finder} ({firole} / {fiteam}) 發現了 {found} ({forole} / {foteam}) 的屍體。屍體上有 {credits} 個信用點數。"
L.desc_event_bodyfound_headshot = "受害者被爆頭致死。"
L.desc_event_c4_disarm_success = "{disarmer} ({drole} / {dteam})成功解除了由{owner} ({orole} / {oteam})放置的C4。"
L.desc_event_c4_disarm_failed = "{disarmer}({drole}/{dteam})試圖解除{owner}({orole}/{oteam})武裝的C4。他們失敗了。"
L.desc_event_c4_explode = "由 {owner} ({role} / {team}) 放置的C4爆炸了。"
L.desc_event_c4_plant = "{owner} ({role} / {team}) 放置了一個爆炸性的C4。"
L.desc_event_creditfound = "{finder} ({firole} / {fiteam}) 在 {found} ({forole} / {foteam}) 的屍體中找到了 {credits} 個信用點數。"
L.desc_event_finish = "該回合持續了 {minutes}:{seconds}。 有 {alive} 個玩家活到了最後。"
L.desc_event_game = "新的回合已經開始。"
L.desc_event_respawn = "{player} 復活了。"
L.desc_event_rolechange = "{player} 將自己從 {orole} ({oteam}) 改為了 {nrole} ({nteam})。"
L.desc_event_selected = "所有 {amount} 名玩家的陣營和角色都已選定。"
L.desc_event_spawn = "{player} 生成了。"

-- Name of a trap that killed us that has not been named by the mapper
L.trap_something = "某件物品"

-- Kill events
L.desc_event_kill_suicide = "是自殺的"
L.desc_event_kill_team = "是被隊友殺的"

L.desc_event_kill_blowup = "{victim} ({vrole} / {vteam}) 被自己炸飛。"
L.desc_event_kill_blowup_trap = "{victim} ({vrole} / {vteam}) 被 {trap} 炸飛。"

L.desc_event_kill_tele_self = "{victim} ({vrole} / {vteam}) 被自己給傳送殺了。"
L.desc_event_kill_sui = "{victim} ({vrole} / {vteam}) 受不了然後自殺了！"
L.desc_event_kill_sui_using = "{victim} ({vrole} / {vteam}) 用 {tool} 殺了自己。"

L.desc_event_kill_fall = "{victim} ({vrole} / {vteam}) 摔死了。"
L.desc_event_kill_fall_pushed = "{victim} ({vrole} / {vteam}) 因為 {attacker} 而摔死了。"
L.desc_event_kill_fall_pushed_using = "{victim} ({vrole} / {vteam}) 被 {attacker} ({arole} / {ateam}) 用 {trap} 推下摔死。"

L.desc_event_kill_shot = "{victim} ({vrole} / {vteam}) 被 {attacker}射殺。"
L.desc_event_kill_shot_using = "{victim} ({vrole} / {vteam}) 被 {attacker} ({arole} / {ateam}) 用 {weapon} 射殺。"

L.desc_event_kill_drown = "{victim} ({vrole} / {vteam}) 被 {attacker} 推入水中溺死。"
L.desc_event_kill_drown_using = "{victim} ({vrole} / {vteam}) 被 {attacker} ({arole} / {ateam}) 用 {trap} 推入水中溺死。"

L.desc_event_kill_boom = "{victim} ({vrole} / {vteam}) 被 {attacker} 炸死。"
L.desc_event_kill_boom_using = "{victim} ({vrole} / {vteam}) 被 {attacker} ({arole} / {ateam}) 用 {trap} 炸爛。"

L.desc_event_kill_burn = "{victim} ({vrole} / {vteam}) 被 {attacker} 燒死。"
L.desc_event_kill_burn_using = "{victim} ({vrole} / {vteam}) 被 {attacker} ({arole} / {ateam}) 用 {trap} 燒成焦屍。"

L.desc_event_kill_club = "{victim} ({vrole} / {vteam}) 被 {attacker} 打死。"
L.desc_event_kill_club_using = "{victim} ({vrole} / {vteam}) 被 {attacker} ({arole} / {ateam}) 用 {trap} 打成爛泥。"

L.desc_event_kill_slash = "{victim} ({vrole} / {vteam}) 被 {attacker} 砍死。"
L.desc_event_kill_slash_using = "{victim} ({vrole} / {vteam}) 被 {attacker} ({arole} / {ateam}) 用 {trap} 砍成兩半。"

L.desc_event_kill_tele = "{victim} ({vrole} / {vteam}) 被 {attacker} 傳送殺。"
L.desc_event_kill_tele_using = "{victim} ({vrole} / {vteam}) 被 {attacker} ({arole} / {ateam}) 用 {trap} 傳送時之能量分裂成原子。"

L.desc_event_kill_goomba = "{victim} ({vrole} / {vteam}) 被 {attacker} ({arole} / {ateam}) 用巨大物體壓爛。"

L.desc_event_kill_crush = "{victim} ({vrole} / {vteam}) 被 {attacker} 壓爛。"
L.desc_event_kill_crush_using = "{victim} ({vrole} / {vteam}) 被 {attacker} ({arole} / {ateam}) 用 {trap} 壓碎。"

L.desc_event_kill_other = "{victim} ({vrole} / {vteam}) 被 {attacker} 殺死。"
L.desc_event_kill_other_using = "{victim} ({vrole} / {vteam}) 被 {attacker} ({arole} / {ateam}) 用 {trap} 殺死。"

-- 2021-04-20
L.none = "無角色"

-- 2021-04-24
L.karma_teamkill_tooltip = "擊殺隊友"
L.karma_teamhurt_tooltip = "對隊友造成傷害"
L.karma_enemykill_tooltip = "擊殺敵人"
L.karma_enemyhurt_tooltip = "對敵人造成傷害"
L.karma_cleanround_tooltip = "絕對中立"
L.karma_roundheal_tooltip = "人品值回合獎勵"
L.karma_unknown_tooltip = "未知"

-- 2021-05-07
L.header_random_shop_administration = "隨機商店設置"
L.header_random_shop_value_administration = "平衡性設置"

L.shopeditor_name_random_shops = "啟用隨機商店"
L.shopeditor_desc_random_shops = [[隨機商店只給每個玩家提供一套有限的隨機化裝備。
陣營商店迫使一個陣營中的所有玩家擁有相同的套裝，而不是定制化。
重新投票可以讓你用積分獲得一套新的隨機裝備。]]
L.shopeditor_name_random_shop_items = "隨機裝備的數量"
L.shopeditor_desc_random_shop_items = "這包括那些標有“非隨機”的設備。所以請選擇一個足夠高的數字，否則你只能得到這些。"
L.shopeditor_name_random_team_shops = "啟用陣營商店"
L.shopeditor_name_random_shop_reroll = "啟用商店重選功能"
L.shopeditor_name_random_shop_reroll_cost = "每次重選的花費"
L.shopeditor_name_random_shop_reroll_per_buy = "購買後自動重選"

-- 2021-06-04
L.header_equipment_setup = "裝備設置"
L.header_equipment_value_setup = "平衡性設置"

L.equipmenteditor_name_not_buyable = "可以購買"
L.equipmenteditor_desc_not_buyable = "如果禁用，該裝備將不會顯示在商店裡。分配了這種裝備的角色仍然會獲得它。"
L.equipmenteditor_name_not_random = "永遠可用"
L.equipmenteditor_desc_not_random = "如果啟用，該裝備在商店中始終可用。當隨機商店被啟用時，它會佔用一個可用的隨機槽，並總是為這個裝備保留它。"
L.equipmenteditor_name_global_limited = "全局限量"
L.equipmenteditor_desc_global_limited = "如果啟用，該裝備只能在回合中購買一次。"
L.equipmenteditor_name_team_limited = "陣營限量"
L.equipmenteditor_desc_team_limited = "如果啟用，該裝備在回合中每個陣營只能購買一次。"
L.equipmenteditor_name_player_limited = "玩家限量"
L.equipmenteditor_desc_player_limited = "如果啟用，每個玩家在回合中只能購買一次。"
L.equipmenteditor_name_min_players = "購買該裝備時最低玩家數量"
L.equipmenteditor_name_credits = "價格以積分計算"

-- 2021-06-08
L.equip_not_added = "未添加"
L.equip_added = "已添加"
L.equip_inherit_added = "已添加（繼承）"
L.equip_inherit_removed = "移除（繼承）"

-- 2021-06-09
L.layering_not_layered = "未分層"
L.layering_layer = "{layer}層"
L.header_rolelayering_role = "{role} 層"
L.header_rolelayering_baserole = "基礎層"
L.submenu_roles_rolelayering_title = "角色分層"
L.header_rolelayering_info = "角色分層信息"
L.help_rolelayering_roleselection = [[角色選擇過程被分成兩個階段。在第一輪中，基礎角色被分配。基本角色是無辜者、叛徒和那些列在“基本角色層”框中的角色。第二遍是用來將這些基礎角色升級為子角色。]]
L.help_rolelayering_layers = [[每個層中只有一個角色被選中。首先，來自自定義層的角色從第一層開始分配，直到到達最後一層或沒有更多的角色可以被升級。無論哪種情況先發生。如果可升級的槽位仍然可用，未分層的角色也將被分配。]]
L.scoreboard_voice_tooltip = "滾動以改變音量"

-- 2021-06-15
L.header_shop_linker = "設置"
L.label_shop_linker_set = "商店的設置"

-- 2021-06-18
L.xfer_team_indicator = "陣營"

-- 2021-06-25
L.searchbar_default_placeholder = "在列表中搜索..."

-- 2021-07-11
L.spec_about_to_revive = "在復活時，觀察將被限製。"

-- 2021-09-01
L.spawneditor_name = "生成點編輯器工具"
L.spawneditor_desc = "用於在地圖中放置武器，彈藥和玩家生成位置。只能由超級管理員使用。"

L.spawneditor_place = "左鍵放置生成點"
L.spawneditor_remove = "右鍵刪除生成點"
L.spawneditor_change = "更改生成類型（按住 [SHIFT] 以反轉）"
L.spawneditor_ammo_edit = "按住編輯武器生成時自動生成的彈藥數量。"

L.spawn_weapon_random = "隨機武器生成"
L.spawn_weapon_melee = "近戰武器生成"
L.spawn_weapon_nade = "手榴彈武器生成"
L.spawn_weapon_shotgun = "霰彈槍武器生成"
L.spawn_weapon_heavy = "重武器生成"
L.spawn_weapon_sniper = "狙擊武器生成"
L.spawn_weapon_pistol = "手槍武器生成"
L.spawn_weapon_special = "特殊武器生成"
L.spawn_ammo_random = "隨機彈藥生成"
L.spawn_ammo_deagle = "沙漠之鷹彈藥生成"
L.spawn_ammo_pistol = "手槍彈藥生成"
L.spawn_ammo_mac10 = "沖鋒槍彈藥生成"
L.spawn_ammo_rifle = "狙擊槍彈藥生成"
L.spawn_ammo_shotgun = "霰彈槍彈藥生成"
L.spawn_player_random = "隨機玩家生成"

L.spawn_weapon_ammo = "（彈藥：{ammo}）"

L.spawn_weapon_edit_ammo = "按住 [{walkkey}]並按 [{primaryfire} 或 {secondaryfire}] 以增加或減少此武器生成的彈藥量"

L.spawn_type_weapon = "這是個武器生成點"
L.spawn_type_ammo = "這是個彈藥生成點"
L.spawn_type_player = "這是個玩家生成點"

L.spawn_remove = "按 [{secondaryfire}] 刪除此生成點"

L.submenu_administration_entspawn_title = "生成點編輯器"
L.header_entspawn_settings = "生成點編輯器設置"
L.button_start_entspawn_edit = "開始生成點編輯"
L.button_delete_all_spawns = "刪除所有生成點位置"

L.label_dynamic_spawns_enable = "為該地圖啟用動態生成"
L.label_dynamic_spawns_global_enable = "為所有地圖啟用自定義生成"

L.header_equipment_weapon_spawn_setup = "武器生成設置"

L.help_spawn_editor_info = [[
生成編輯器是用來放置，移除和編輯世界上的生成點。這些生成點是為武器，彈藥和玩家準備的。

這些生成點被保存在位於"data/ttt/weaponspawnscripts/"的文件中。它們可以被刪除以進行硬重置。最初的生成文件是由地圖上和原始TTT武器生成腳本中的生成創建的。按下重置按鈕總是會恢復到這個狀態。

應該注意的是，這個生成系統使用動態生成。這將使武器生成系統更加有趣，因為它不再定義一個特定的武器。而是定義一種武器類型。例如，現在不是生成TTT自帶的霰彈槍，而是生成被分類成霰彈槍的武器，任何定義為霰彈槍的武器都可以生成。每個武器的生成類型可以在裝備編輯器中設置，這使得任何武器都可以在地圖上生成，或者禁用某些默認武器。

請記住，更改只有在新的一輪開始後才會生效。]]
L.help_spawn_editor_enable = "在某些地圖上，可能會建議使用在地圖自帶的原始生成點，而不用動態系統來取代它們。禁用這個複選框只對當前活動地圖禁用。其他地圖仍將使用動態系統。"
L.help_spawn_editor_hint = "提示：要離開生成編輯器，重新打開遊戲模式菜單。"
L.help_spawn_editor_spawn_amount = [[
目前在這張地圖上有 {weapon} 個武器生成點，{ammo} 個彈藥生成點和 {player} 個玩家生成點。
點擊'開始編輯生成'來改變這個生成。

{weaponrandom}x 隨機武器生成
{weaponmelee}x 近戰類武器生成
{weaponnade}x 爆炸物類武器生成
{weaponshotgun}x 霰彈類武器生成
{weaponheavy}x 重型類武器生成
{weaponsniper}x 狙擊類武器生成
{weaponpistol}x 手槍類武器生成
{weaponspecial}x 特殊武器生成

{ammorandom}x 隨機彈藥生成
{ammodeagle}x 沙漠之鷹彈藥生成
{ammopistol}x 手槍彈藥生成
{ammomac10}x Mac10彈藥生成器
{ammorifle}x 狙擊槍彈藥生成
{ammoshotgun}x 霰彈槍彈藥生成

{playerrandom} x 玩家隨機位置生成]]

L.equipmenteditor_name_auto_spawnable = "設備在地圖中隨機產生"
L.equipmenteditor_name_spawn_type = "選擇生成類型"
L.equipmenteditor_desc_auto_spawnable = [[
TTT2的生成系統允許每種武器在世界中生成，默認情況下，只有被創造者標記為'自動生成'的武器才會在世界中生成，但這些設置可以在該菜單中更改。

大多數裝備在默認情況下被設置為'特殊武器生成'。這意味著它們只在隨機武器生成點上生成。然而，我們可以在地圖中放置特殊的武器生成點，或者改變生成點的生成類型，以使用其他現有的生成類型。]]

L.pickup_error_inv_cached = "你現在不能拿起這個，因為你的庫存被緩存了。"

-- 2021-09-02
L.submenu_administration_playermodels_title = "玩家模型"
L.header_playermodels_general = "通用玩家模型設置"
L.header_playermodels_selection = "選擇玩家模型庫"

L.label_enforce_playermodel = "強製設置玩家模型"
L.label_use_custom_models = "使用一個隨機選擇的玩家模型"
L.label_prefer_map_models = "優先選擇地圖特定模型而不是默認模型"
L.label_select_model_per_round = "每輪選擇一個新的隨機模型（如果禁用，則僅在地圖變更時）"
--L.label_select_unique_model_per_round = "Select a random unique model for each player"

L.help_prefer_map_models = [[
有些地圖定義了他們自己的玩家模型，默認情況下。這些模型的優先級比自動分配的模型高。如果禁用此設置。地圖自帶的玩家模型將被禁用，

角色的特定模型總是有更高的優先權。不受這個設置的影響。]]
L.help_enforce_playermodel = [[
有些角色有自定義的玩家模型。但是它可以被禁用，可能會導致玩家模型選擇器的兼容出現問題。
如果這個設置被禁用，仍然可以選擇默認的隨機模型。]]
L.help_use_custom_models = [[
默認情況下，只有CS起源版鳳凰戰士的模型被分配給所有玩家，然而，如果啟用這個選項，將使用玩家模型庫，啟用此設置後，每個玩家將被分配到相同的玩家模型，但這些模型將從模型庫中選擇。

模型選擇可通過安裝更多的玩家模型來擴展。]]

-- 2021-10-06
L.menu_server_addons_title = "服務器插件"
L.menu_server_addons_description = "服務器端管理員專用的插件設置。"

L.tooltip_finish_score_penalty_alive_teammates = "存活隊友處罰：{score}"
L.finish_score_penalty_alive_teammates = "存活隊友處罰："
L.tooltip_kill_score_suicide = "自殺：{score}"
L.kill_score_suicide = "自殺："
L.tooltip_kill_score_team = "擊殺隊友：{score}"
L.kill_score_team = "擊殺隊友："

-- 2021-10-09
L.help_models_select = [[
左鍵點擊模型，將其添加到玩家模型庫中。再次以左鍵刪除它們。右鍵可在所關注的模型的啟用和禁用偵探帽之間進行切換。

左上角的小指示器顯示玩家模型是否有頭部的命中箱，下面的圖標顯示了這個模型是否可佩戴偵探帽。]]

L.menu_roles_title = "角色設置"
L.menu_roles_description = "設置生成概率、裝備積分及更多。"

L.submenu_roles_roles_general_title = "通用角色設置"

L.header_roles_info = "角色信息"
L.header_roles_selection = "角色選擇概率"
L.header_roles_tbuttons = "角色叛徒按鈕"
L.header_roles_credits = "角色裝備積分"
L.header_roles_additional = "附加角色設置"
L.header_roles_reward_credits = "獎勵裝備積分"

L.help_roles_default_team = "默認團隊：{team}"
L.help_roles_unselectable = "這個角色是不可選擇的。這意味著它在角色選擇系統中不被考慮。大多數情況下，這意味著這是回合中通過某個事件（如復活為殭屍，副手老鷹或類似的東西）手動應用的角色。"
L.help_roles_selectable = "這個角色是可選擇的，這意味著如果滿足所有的標準，這個角色在角色選擇過程中會被考慮。"
L.help_roles_credits = "裝備積分用於在商店購買裝備。大多數情況下，只給那些可以進入商店的角色信用額度是有意義的。然而，由於可從屍體上偷取積分，也可以考慮給角色提供起始積分，作為給加害者的獎勵。"
L.help_roles_selection_short = "每個玩家的角色分佈定義了被分配到這個角色的玩家的百分比。例如，如果該值被設置為'0.2'，那麼每五名玩家中就有一人會變為此角色。"
L.help_roles_selection = [[
每個玩家的角色分配定義了被分配到這個角色的玩家的百分比。例如，如果該值被設置為 "0.2"，那麼每五個玩家就會得到這個角色。這也意味著，至少需要5名玩家才能分配到這個角色。
請記住，所有這些都只適用於該角色被考慮分配過程。

前面提到的角色分配與玩家的下限有一個特殊的整合。如果該角色被考慮用於分配，且最小值低於分配係數所給的值，但玩家數量等於或大於下限，則單個玩家仍可獲得該角色。然後分配過程對第二個玩家照常進行。]]
L.help_roles_award_info = "部分角色（如果在他們的積分設置中啟用）在一定比例的對手死亡後會獲得裝備積分，該數值可在這裡進行調整。"
L.help_roles_award_pct = "當這個百分比的敵人死亡後，特定的角色會獲得積分。"
L.help_roles_award_repeat = "積分獎勵是否會多次發放。例如，如果你將百分比設置為'0.25'，並啟用此功能，玩家將在死亡人數到達全玩家的'25%'，'50%'和'75%'時獲得積分。"
L.help_roles_advanced_warning = "警告：這些是高級設置，可以完全擾亂角色分配過程。如果有疑問，請將所有值保持在 '0'。這個值意味著不應用任何限制，角色分配將嘗試分配盡可能多的角色。"
L.help_roles_max_roles = [[
角色類別包含TTT2中的每個角色。默認情況下，對於可以分配多少個不同的角色沒有限制。然而，這裡有兩種不同的方法來限制它們。

1.用一個固定的數值限制。
2.通過百分比限制。

後者僅在固定數值為'0'時使用，並根據設定的可用玩家百分比設置上限。]]
L.help_roles_max_baseroles = [[
基礎角色只是那些其他角色所繼承的角色陣營。例如，"無辜者"角色是一個基礎角色，而"法老"是這個角色的一個子角色。默認情況下，對於可以分配多少個不同的角色沒有限制。然而，這裡有兩種不同的方法來限制它們。

1.用一個固定的數值限制。
2.通過百分比限制。

後者只在固定數值為'0'時使用，並根據設定的可用玩家百分比設置上限。]]

L.label_roles_enabled = "啟用角色"
L.label_roles_min_inno_pct = "每個玩家所分配的無辜者角色比例"
L.label_roles_pct = "每位玩家的角色分配"
L.label_roles_max = "分配到該角色的玩家上限"
L.label_roles_random = "分配到該角色的可能性"
L.label_roles_min_players = "分配到該角色的最低下限"
L.label_roles_tbutton = "是否可使用叛徒按鈕"
L.label_roles_credits_starting = "初始裝備積分"
L.label_roles_credits_award_pct = "積分獎勵報酬率"
L.label_roles_credits_award_size = "積分獎勵比例"
L.label_roles_credits_award_repeat = "重複學積分獎勵"
L.label_roles_newroles_enabled = "啟用自定義角色"
L.label_roles_max_roles = "角色上限"
L.label_roles_max_roles_pct = "按百分比計算角色上限"
L.label_roles_max_baseroles = "基礎角色上限"
L.label_roles_max_baseroles_pct = "按百分比計算基礎角色上限"
L.label_detective_hats = "為像偵探這樣的警察角色啟用帽子（如果玩家模型允許戴帽子）。"

L.ttt2_desc_innocent = "無辜者沒有特殊能力。他們必須在恐怖分子中找到邪惡的人並殺死他們。但他們必須小心，不要誤殺自己的同伴。"
L.ttt2_desc_traitor = "叛徒是無辜者的敵人。他們有一個裝備菜單，可以購買特殊裝備。他們必須殺死所有的人，除了他們的隊友。"
L.ttt2_desc_detective = "偵探是無辜者們最信任的人。但誰是無辜者？強大的偵探必須要找到所有圖謀不軌恐怖分子。他們商店裡的設備可能會幫助他們完成這項任務。"

-- 2021-10-10
L.button_reset_models = "重置玩家模型"

-- 2021-10-13
L.help_roles_credits_award_kill = "另一種獲得積分的方式是通過殺死為'公開角色'（如偵探）的高價值玩家。如果非無辜者陣營的角色啟用了這個功能，他們就會獲得以下規定的積分。"
L.help_roles_credits_award = [[
在TTT2中，有兩種不同的方式可以獲得積分：

1.如果敵方隊伍中有一定比例的人死亡，整個隊伍將會獎勵積分。
2.如果一個玩家用'公開角色'（如偵探）殺死了一個高價值的角色，那麼這位玩家就會得到獎勵。

請注，，即使全隊都會獲得獎勵，這仍然可以為每個角色啟用/禁用。例如，如果'無辜者'陣營被獎勵，但無辜者角色的裝備商店被禁用，所以只有偵探會收到積分。
這個功能的平衡值可以在'管理'->'通用角色設置'中設置。]]
L.help_detective_hats = [[
偵探等警察角色可以戴帽子以顯示其權威。他們在死亡時或頭部受損時將失去帽子。

部分玩家模型默認不支持帽子。你可以在'管理'->'玩家模型'中改變這一點。]]

L.label_roles_credits_award_kill = "Credit reward amount for the kill"
L.label_roles_credits_dead_award = "啟用對依據一定比例敵人死亡數提供積分獎勵"
L.label_roles_credits_kill_award = "啟用對擊殺高價值角色時提供積分獎勵"
L.label_roles_min_karma = "分配角色時玩家的最低人品值"

-- 2021-11-07
L.submenu_administration_administration_title = "管理"
L.submenu_administration_voicechat_title = "語音聊天/文本聊天"
L.submenu_administration_round_setup_title = "回合設置"
L.submenu_administration_mapentities_title = "地圖實體"
L.submenu_administration_inventory_title = "庫存"
L.submenu_administration_karma_title = "人品值"
L.submenu_administration_sprint_title = "衝刺"
L.submenu_administration_playersettings_title = "玩家設定"

L.header_roles_special_settings = "特殊角色設定"
L.header_equipment_additional = "額外裝備設置"
L.header_administration_general = "通用管理設置"
L.header_administration_logging = "日誌"
L.header_administration_misc = "雜項"
L.header_entspawn_plyspawn = "玩家生成設置"
L.header_voicechat_general = "通用語音聊天設置"
L.header_voicechat_battery = "語音聊天電池"
L.header_voicechat_locational = "基於玩家位置範圍語音"
L.header_playersettings_plyspawn = "玩家生成設置"
L.header_round_setup_prep = "回合：準備階段"
L.header_round_setup_round = "回合：進行階段"
L.header_round_setup_post = "回合：結束階段"
L.header_round_setup_map_duration = "地圖持續時間"
L.header_textchat = "文本聊天"
L.header_round_dead_players = "死亡玩家設置"
L.header_administration_scoreboard = "記分版設置"
L.header_hud_toggleable = "可切換的HUD元素"
L.header_mapentities_prop_possession = "Prop附體"
L.header_mapentities_doors = "門"
L.header_karma_tweaking = "人品值調整"
L.header_karma_kick = "人品值踢出和封禁"
L.header_karma_logging = "人品值記錄"
L.header_inventory_gernal = "庫存大小"
L.header_inventory_pickup = "庫存武器拾取"
L.header_sprint_general = "衝刺設置"
L.header_playersettings_armor = "護甲系統設置"

L.help_killer_dna_range = "當玩家被其他玩家殺死時，會在他們身上留下DNA指紋，最大範圍convar定義了留下DNA樣本的最大距離，以錘子編輯器為單位，如果殺手在更遠的地方，那麼就不會在屍體上留下樣本。"
L.help_killer_dna_basetime = "直到DNA樣本衰變的基本時間，以秒為單位，從這個基準時間中減去一個殺手距離的平方係數。"
L.help_dna_radar = "如果配備了TTT2 DNA掃描器，會顯示所選DNA樣本的確切距離和方向。然而，也有一種經典的DNA掃描器模式，每次冷卻時間過後都會用世界範圍的渲染來更新所選的樣本。"
L.help_idle = "挂機模式是用來將挂機的玩家轉移到一個強制的旁觀者模式。要再次離開這個模式，他們必須在他們的'遊戲'設置中禁用'強制旁觀模式'。"
L.help_namechange_kick = [[
如果玩家在回合中改變他們的名字，這可能會被濫用來提供信息。因此，禁止在進行中的回合改變暱稱。

如果被封禁時間大於0，該玩家將無法重新連接到服務器，直到該時間結束。]]
L.help_damage_log = "每次玩家受到傷害時，就會在控製臺中添加一個傷害日誌條目。這也可以在一個回合結束後存儲到磁盤上。該文件位於'data/terrortown/logs/'"
L.help_spawn_waves = [[
如果這個變量被設置為0，所有玩家將會同時生成。對於擁有大量玩家的服務器來說，一波一波地生成玩家可能是有益的。生成波的時間間隔是指每個生成波之間的時間，一個生成波總是產生與會生成與生成點相同數量的玩家。

注意：確保准備時間足夠長，以達到所需的生成波數量。]]
L.help_voicechat_battery = [[
在啟用語音聊天電池的情況下，語音聊天會減少電量。當電量耗盡時，玩家將不能語音聊天。必須等待幾秒鐘來充電。這可以幫助防止過度使用語音聊天。

注意：'Tick'指的是遊戲中的Tick，即1/66秒的時間。]]
L.help_ply_spawn = "在玩家（重新）產生時使用的玩家設定。"
L.help_haste_mode = [[
急速模式通過增加在玩家死亡時增加回合時間來平衡遊戲。只有看到回合中失蹤的玩家的角色才能看到真正的回合時間，其他角色只能看到急速模式的起始時間。

如果急速模式被啟用，固定的回合時間將被忽略。]]
L.help_round_limit = "在滿足設定的限製條件之一後，將會更換地圖。"
L.help_armor_balancing = "以下數值可以用來平衡護甲。"
L.help_item_armor_classic = "如果啟用了經典護甲模式，只有之前的設置才是生效的。經典護甲模式意味著玩家在一個回合中只能購買一次護甲，並且這個盔甲可以阻擋30%的子彈和撬棍的傷害，直到他們死亡。"
L.help_item_armor_dynamic = [[
動態護甲是TTT2的新系統，使護甲系統更加有趣。現在可以購買的護甲數量是無限的，而且護甲的效果可以疊加。受到傷害會降低護甲值，每件物品的護甲值是在該物品的"裝備設置"中設置的。

當受到傷害時。這個傷害的一定比例會轉化為護甲傷害，不同的比例仍然適用於玩家，其余的則會消失。

如果強化護甲被啟用，只要護甲值高於強化閾值，施加給玩家的傷害就會減少15%。]]
L.help_sherlock_mode = "偵探模式是經典的TTT模式。如果偵探模式被禁用，屍體將被確認，記分牌上顯示每個人都活著，觀察者可以與活著的玩家交談。"
L.help_prop_possession = [[
觀察者可以使用道具附身來附身於躺在世界中的道具，並使用緩慢充能的'重擊測量器'來移動上述道具。

'重擊測量器'的最大值由一個基礎值和其他判斷值組成，其中擊殺數/死亡數將影響該值。隨著時間的推移，能量條會慢慢充電。設定的充電時間是為'重擊測量器'中的一個點進行充電所需的時間。]]
L.help_karma = "玩家有一定量的初始人品值，傷害/殺死隊友時會失去人品。失去的數值取決於他們傷害或殺死的人的人品值，對方人品越低，損失的人品越低。"
L.help_karma_strict = "如果嚴格人品模式被啟用，傷害懲罰會隨著人品值的減少快速增加。非嚴格模式下，人品值保持在 800 以上時的傷害懲罰非常低。啟用嚴格模式使人品值在阻止任何不必要的擊殺方面發揮更大的作用，而禁用它則導致一個更寬鬆的遊戲範圍，人品系統只會影響不斷擊殺隊友的玩家。"
L.help_karma_max = "將最大人品值設置為1000以上，不會給人品值超過1000的玩家提供傷害加成，它可以作為一個人品值緩衝區。"
L.help_karma_ratio = "用於計算如果雙方在同一個團隊中，受害者的業值被減去多少的傷害比例。如果發生擊殺友軍事件，會有進一步的懲罰。"
L.help_karma_traitordmg_ratio = "如果雙方在不同的隊伍中，用來計算受害者的業值被減去多少的傷害比率。如果發生擊殺事件，會有進一步的獎勵。"
L.help_karma_bonus = "在一個回合中也有兩種不同的被動方式來獲得業值。首先，一個回合的回復會應用於每個玩家。然後，如果沒有傷害隊友或擊殺，會有一個二次回復的獎勵。"
L.help_karma_clean_half = [[
當玩家的業值高於起始水平時（意味著業值最大值已被配置為高於該水平），他們所有的業值增加將根據其業值高於起始水平的程度而減少。因此，它越高，增加的速度就越慢。

這種減少是以指數衰減的曲線進行的：最初速度很快，隨著增量的變小，速度也會變慢。這個控製臺指令設定了獎金減半的時間點（即半衰期）。在默認值為0.25的情況下，如果業值的起始值為1000，最大值為1500，而玩家有1125((1500-1000)*0.25=125)業值，那麽他的無誤殺輪獎勵將是30/2=15。因此，為了使值下降得更快，你應該把該設置得更低，為了使它下降得更慢，你應該把它增加到1。]]
L.help_max_slots = "設置每個插槽的最大武器數量。'-1'表示沒有限製。"
L.help_item_armor_value = "這是動態模式下的護甲項目給出的護甲值。如果啟用了經典模式（見'管理'->'玩家設置'），那麽每一個大於0的值都被算作護甲。"

L.label_killer_dna_range = "留下DNA的最大擊殺範圍"
L.label_killer_dna_basetime = "樣本存活基礎時間"
L.label_dna_scanner_slots = "DNA樣本插槽"
L.label_dna_radar = "啟用經典DNA掃描模式"
L.label_dna_radar_cooldown = "DNA掃描儀的冷卻時間"
L.label_radar_charge_time = "雷達採樣後的充電時間"
L.label_crowbar_shove_delay = "撬棍推動玩家後的冷卻時間"
L.label_idle = "啟用掛機模式"
L.label_idle_limit = "最長可掛機時間（秒）"
L.label_namechange_kick = "啟用改名踢出"
L.label_namechange_bantime = "踢出後封禁的時間，以分鐘為單位"
L.label_log_damage_for_console = "啟用控製臺的傷害記錄"
L.label_damagelog_save = "將傷害日誌保存到磁盤上"
L.label_debug_preventwin = "禁用回合結束[debug]"
L.label_bots_are_spectators = "機器人永遠是觀察者"
L.label_tbutton_admin_show = "向管理員顯示叛徒按鈕"
L.label_ragdoll_carrying = "啟用布娃娃搬運"
L.label_prop_throwing = "啟用道具投擲"
L.label_weapon_carrying = "啟用武器搬運"
L.label_weapon_carrying_range = "武器搬運範圍"
L.label_prop_carrying_force = "Prop推進力"
L.label_teleport_telefrags = "在傳送時殺死被封禁的玩家"
L.label_allow_discomb_jump = "允許手榴彈發射器進行迪斯科跳躍"
L.label_spawn_wave_interval = "生成的間隔時間，以秒為單位"
L.label_voice_enable = "啟用語音聊天"
L.label_voice_drain = "啟用語音聊天的電池功能"
L.label_voice_drain_normal = "普通玩家的每滴答消耗量"
L.label_voice_drain_admin = "讓管理員和公共警察角色的電池會耗盡"
L.label_voice_drain_recharge = "不進行語音聊天時每滴答的充能率"
L.label_locational_voice = "為活著的玩家啟用近距離語音聊天功能"
--L.label_locational_voice_prep = "Enable proximity voice chat during preparing phase"
--L.label_locational_voice_range = "Proximity voice chat range"
L.label_armor_on_spawn = "玩家在重生時的默認護甲量"
L.label_prep_respawn = "在準備階段啟用即時重生"
L.label_preptime_seconds = "準備時間（秒）"
L.label_firstpreptime_seconds = "首局準備時間（秒）"
L.label_roundtime_minutes = "固定回合時間（分鐘）"
L.label_haste = "啟用急速模式"
L.label_haste_starting_minutes = "急速模式開始時間（分鐘）"
L.label_haste_minutes_per_death = "玩家死亡給予的額外時間（分鐘）"
L.label_posttime_seconds = "回合後時間，以秒為單位"
L.label_round_limit = "回合數上限"
L.label_time_limit_minutes = "遊戲時間上限，以分鐘為單位"
L.label_nade_throw_during_prep = "在準備時間內允許投擲手榴彈"
L.label_postround_dm = "回合結束後啟用死亡競賽"
L.label_spectator_chat = "啟用觀察者與大家聊天的功能"
L.label_lastwords_chatprint = "如果在打字時被殺，則發出最後一句話至聊天室"
L.label_identify_body_woconfirm = "不按'確認'按鈕識別屍體"
--L.label_announce_body_found = "Announce that a body was found when the body was confirmed"
L.label_confirm_killlist = "宣布確認屍體時，該屍體的擊殺名單"
L.label_dyingshot = "如果玩家在瞄準中，則在死亡時開槍[試驗性]"
L.label_armor_block_headshots = "啟用護甲阻擋爆頭傷害"
L.label_armor_block_blastdmg = "啟用護甲阻擋爆炸傷害"
L.label_armor_dynamic = "啟用動態裝甲"
L.label_armor_value = "護甲物品所賦予的護甲"
L.label_armor_damage_block_pct = "護甲承受的傷害百分比"
L.label_armor_damage_health_pct = "玩家承受的傷害百分比"
L.label_armor_enable_reinforced = "啟用強化護甲"
L.label_armor_threshold_for_reinforced = "強化護甲閾值"
L.label_sherlock_mode = "啟用偵探模式"
L.label_highlight_admins = "突出服務器管理員"
L.label_highlight_dev = "突出顯示TTT2開發者"
L.label_highlight_vip = "突出顯示TTT2支持者"
L.label_highlight_addondev = "突出顯示TTT2附加組件的開發者"
L.label_highlight_supporter = "突出顯示其他人"
L.label_enable_hud_element = "啟用{elem}HUD元素"
L.label_spec_prop_control = "啟用Prop附體"
L.label_spec_prop_base = "附體時的基礎值"
L.label_spec_prop_maxpenalty = "降低附體獎金下限"
L.label_spec_prop_maxbonus = "提高附體獎金上限"
L.label_spec_prop_force = "附體時推動力"
L.label_spec_prop_rechargetime = "充能時間（秒）"
L.label_doors_force_pairs = "強迫讓只能關閉的門變為正常門"
L.label_doors_destructible = "啟用破壞門系統"
L.label_doors_locked_indestructible = "初始鎖定的門是不可摧毀的"
L.label_doors_health = "門的生命值"
L.label_doors_prop_health = "被破壞的門生命值"
L.label_minimum_players = "開始遊戲的最低玩家數量"
L.label_karma = "啟用人品值"
L.label_karma_strict = "啟用嚴格的人品值"
L.label_karma_starting = "初始人品值"
L.label_karma_max = "最大人品值"
L.label_karma_ratio = "團隊傷害的懲罰比例"
L.label_karma_kill_penalty = "擊殺隊友的懲罰"
L.label_karma_round_increment = "回合結束時所給予的人品值"
L.label_karma_clean_bonus = "無誤殺回合獎勵"
L.label_karma_traitordmg_ratio = "傷害其他團隊玩家的獎勵比例"
L.label_karma_traitorkill_bonus = "擊殺其他團隊玩家的獎勵"
L.label_karma_clean_half = "無誤殺獎勵減少比例"
L.label_karma_persist = "人品值在地圖更換後依然保留"
L.label_karma_low_autokick = "自動踢掉低人品值的玩家"
L.label_karma_low_amount = "低人品值閾值"
L.label_karma_low_ban = "封禁選中的最低人品值玩家"
L.label_karma_low_ban_minutes = "封禁時間（分鐘）"
L.label_karma_debugspam = "啟用關於人品值變化的調試輸出到控制台"
L.label_max_melee_slots = "近戰槽位最多可攜帶"
L.label_max_secondary_slots = "輔助槽位最多可攜帶"
L.label_max_primary_slots = "主要插槽最多可攜帶"
L.label_max_nade_slots = "最大手榴彈插槽"
L.label_max_carry_slots = "攜帶槽位最多可攜帶"
L.label_max_unarmed_slots = "非武裝槽位最多可攜帶"
L.label_max_special_slots = "特殊槽位最多可攜帶"
L.label_max_extra_slots = "額外槽位最多可攜帶"
L.label_weapon_autopickup = "啟用自動武器拾取"
L.label_sprint_enabled = "啟用沖刺功能"
--L.label_sprint_max = "Speed boost factor"
L.label_sprint_stamina_consumption = "體力消耗系數"
L.label_sprint_stamina_regeneration = "體力恢復系數"
L.label_crowbar_unlocks = "主要攻擊鍵可以作為互動（即解鎖）使用"
L.label_crowbar_pushforce = "撬棍推動力"

-- 2022-07-02
L.header_playersettings_falldmg = "摔落傷害設置"

L.label_falldmg_enable = "啟用摔落傷害"
L.label_falldmg_min_velocity = "發生摔落傷害的最小速度閾值"
L.label_falldmg_exponent = "與速度相關的摔落傷害增加指數"

L.help_falldmg_exponent = [[
該值修改了隨著玩家撞擊地面的速度而以指數方式增加的摔落傷害。

更改此值時請小心。設置得太高，即使是二階階梯的高度也會致命，而設置得太低，玩家從五樓跳下來時也安然無恙。]]

-- 2023-02-08
L.testpopup_title = "一個測試彈出窗口，現在有一個多行標題，多好啊！"
L.testpopup_subtitle = "好吧，你好！這是一個帶有一些特殊信息的花式彈出窗口。文字也可以是多行的，多好啊！呃，如果我有什麼想法的話，我可以添加這麼多的文字..."

L.hudeditor_chat_hint1 = "[TTT2][INFO] 將鼠標懸停在一個元素上，按住[LMB]並移動鼠標來移動或調整其大小。"
L.hudeditor_chat_hint2 = "[TTT2][INFO] 按住ALT鍵進行對稱調整大小。"
L.hudeditor_chat_hint3 = "[TTT2][INFO] 按住SHIFT鍵，在軸上移動並保持長寬比。"
L.hudeditor_chat_hint4 = "[TTT2][INFO] 按[RMB] -> 'Close' 來退出HUD編輯器！"

L.guide_nothing_title = "這裡暫時什麼都沒有！"
L.guide_nothing_desc = "這是一項正在進行中的工作，通過在GitHub上為項目做貢獻來幫助我們。"

L.sb_rank_tooltip_developer = "TTT2開發者"
L.sb_rank_tooltip_vip = "TTT2支持者"
L.sb_rank_tooltip_addondev = "TTT2附加組件開發者"
L.sb_rank_tooltip_admin = "服務器管理員"
L.sb_rank_tooltip_streamer = "主播"
L.sb_rank_tooltip_heroes = "TTT2 英雄"
L.sb_rank_tooltip_team = "陣營"

L.tbut_adminarea = "管理區:"

-- 2023-08-10
L.equipmenteditor_name_damage_scaling = "傷害縮放"

-- 2023-08-11
L.equipmenteditor_name_allow_drop = "允許丟棄"
L.equipmenteditor_desc_allow_drop = "如果啟用，玩家可以自由地丟棄裝備。"

L.equipmenteditor_name_drop_on_death_type = "死亡時丟棄"
L.equipmenteditor_desc_drop_on_death_type = "嘗試覆蓋玩家死亡時裝備是否被丟棄的操作。"

L.drop_on_death_type_default = "默認（由武器定義）"
L.drop_on_death_type_force = "強制死亡時丟棄"
L.drop_on_death_type_deny = "拒絕死亡時丟棄"

-- 2023-08-26
L.equipmenteditor_name_kind = "裝備槽"
L.equipmenteditor_desc_kind = "裝備將佔用的庫存槽。"

L.slot_weapon_melee = "近戰槽"
L.slot_weapon_pistol = "手槍槽"
L.slot_weapon_heavy = "重型槽"
L.slot_weapon_nade = "手雷槽"
L.slot_weapon_carry = "攜帶槽"
L.slot_weapon_unarmed = "空手槽"
L.slot_weapon_special = "特殊槽"
L.slot_weapon_extra = "額外槽"
L.slot_weapon_class = "職業槽"

-- 2023-10-04
--L.label_voice_duck_spectator = "Muffle spectator voices"
--L.label_voice_duck_spectator_amount = "Spectator voice muffle amount"
--L.label_voice_scaling = "Voice Volume Scaling Mode"
--L.label_voice_scaling_mode_linear = "Linear"
--L.label_voice_scaling_mode_power4 = "Power 4"
--L.label_voice_scaling_mode_log = "Logarithmic"

-- 2023-10-07
L.search_title = "屍體搜索結果 - {player}"
L.search_info = "訊息"
L.search_confirm = "確認死亡"
--L.search_confirm_credits = "Confirm (+{credits} Credit(s))"
--L.search_take_credits = "Take {credits} Credit(s)"
--L.search_confirm_forbidden = "Confirm forbidden"
--L.search_confirmed = "Death Confirmed"
--L.search_call = "Report Death"
--L.search_called = "Death Reported"

--L.search_team_role_unknown = "???"

L.search_words = "某些事物讓你了解到此人的遺言： {lastwords}"
L.search_armor = "他穿戴非標準裝甲。"
L.search_disguiser = "他持有一個能隱匿身份的設備"
L.search_radar = "他持有像是雷達的物品。已經無法使用了。"
L.search_c4 = "你在他口袋中找到了一本筆記。記載著線路 {num} 是解除炸彈須剪除的一條。"

L.search_dmg_crush = "他多處骨折。看起來是某種重物的衝擊撞死了他。"
L.search_dmg_bullet = "他很明顯是被射殺身亡的。"
L.search_dmg_fall = "他是墜落身亡的。"
L.search_dmg_boom = "他的傷口以及燒焦的衣物，應是爆炸導致其死亡。"
L.search_dmg_club = "他的身體有許多擦傷打擊痕跡，明顯是被毆打致死的。"
L.search_dmg_drown = "他身上的蛛絲馬跡顯示是溺死的。"
L.search_dmg_stab = "他是被刺擊與揮砍後，迅速失血致死的。"
L.search_dmg_burn = "聞起來有燒焦的恐怖分子在附近.."
L.search_dmg_teleport = "看起來他的DNA以超光速粒子之形式散亂在附近。"
L.search_dmg_car = "他穿越馬路時被一個粗心的駕駛碾死了。"
L.search_dmg_other = "你無法找到這恐怖份子的具體死因。"

--L.search_floor_antlions = "There are still antlions all over the body. The floor must be covered with them."
--L.search_floor_bloodyflesh = "The blood on this body looks old and disgusting. There are even small bits of bloody flesh stuck to their shoes."
--L.search_floor_concrete = "Gray dust covers their shoes and knees. Looks as if the crime scene had a concrete floor."
--L.search_floor_dirt = "It smells earthy. It probably stems from the dirt that clings to the victims shoes."
--L.search_floor_eggshell = "Disgusting looking white specks cover the body of the victim. It looks like egg shells."
--L.search_floor_flesh = "The victim's clothing feels kinda moist. As if they fell onto a wet surface. Like a fleshy surface, or the sandy ground of a water body."
--L.search_floor_grate = "The skin of the victim looks like a steak. Thick lines arranged in a grid are visible all over them. Did they rest on a grate?"
--L.search_floor_alienflesh = "Alien flesh, you think? Sounds kinda outlandish. But your detective helper book lists it as a possible floor surface."
--L.search_floor_snow = "On first glance their clothing only feels wet and ice-cold. But once you see the white foam on the rims you understand. It's snow!"
--L.search_floor_plastic = "'Ouch, that has to hurt.' Their body is covered in burns. They look like those you get when sliding over a plastic surface."
--L.search_floor_metal = "At least they can't get tetanus now that they are dead. Rust covers their wounds. They probably died on a metal surface."
--L.search_floor_sand = "Small little rough rocks are stuck to their cold body. Like coarse sand from a beach. Argh, it gets everywhere!"
--L.search_floor_foliage = "Nature is wonderful. The victim's bloody wounds are covered with enough foliage that they are almost hidden."
--L.search_floor_computer = "Beep-boop. Their body is covered in computer surface! How does this look, you might ask? Well, duh!"
--L.search_floor_slosh = "Wet and maybe even a bit slimy. Their whole body is covered with it and their clothes are soaked. It stinks!"
--L.search_floor_tile = "Small shards are stuck to their skin. Like shards from floor tiles that shattered on impact."
--L.search_floor_grass = "It smells like fresh cut grass. The smell almost overpowers the smell of blood and death."
--L.search_floor_vent = "You feel a fresh gust of air when you touch their body. Did they die in a vent and take the air with them?"
--L.search_floor_wood = "What's nicer than sitting on a hardwood floor and dwelling in thoughts? At least lot lying dead on a wooden floor!"
--L.search_floor_default = "That seems so basic, so normal. Almost default. You can't tell anything about the kind of surface."
--L.search_floor_glass = "Their body is covered with many bloody cuts. In some of them glass shards are stuck and look rather threatening to you."
--L.search_floor_warpshield = "A floor made out of warpshield? Yep, we are as confused as you were. But our notes clearly state it. Warpshield."

--L.search_water_1 = "The victim's shoes are wet, but the rest seems dry. They were probably killed with their feet in water."
--L.search_water_2 = "The victim's shoes are trousers are soaked through. Did they wander through water before they were killed?"
--L.search_water_3 = "The whole body is wet and swollen. They probably died while they were completely submerged."

L.search_weapon = "這顯示死者是被 {weapon} 所殺。"
L.search_head = "最嚴重的傷口在頭部。完全沒機會叫喊。"
--L.search_time = "They died a while before you conducted the search."
--L.search_dna = "Retrieve a sample of the killer's DNA with a DNA Scanner. The DNA sample will decay after a while."

L.search_kills1 = "你找到一個名單，記載著他發現的死者：{player}"
L.search_kills2 = "你找到了一個名單，記載著他殺的這些人：{player}"
L.search_eyes = "透過你的探查技能，你確信他臨死前見到的最後一個人： {player}。是兇手，還是巧合？"

--L.search_credits = "The victim has {credits} equipment credit(s) in their pocket. A shopping role might take them and put them to good use. Keep an eye out!"

--L.search_kill_distance_point_blank = "It was a point blank attack."
--L.search_kill_distance_close = "The attack came from a short distance."
--L.search_kill_distance_far = "The attack came from a long distance away."

--L.search_kill_from_front = "The victim was shot from the front."
--L.search_kill_from_back = "The victim was shot from behind."
--L.search_kill_from_side = "The victim was shot from the side."

--L.search_hitgroup_head = "The projectile was found in their head."
--L.search_hitgroup_chest = "The projectile was found in their chest."
--L.search_hitgroup_stomach = "The projectile was found in their stomach."
--L.search_hitgroup_rightarm = "The projectile was found in their right arm."
--L.search_hitgroup_leftarm = "The projectile was found in their left arm."
--L.search_hitgroup_rightleg = "The projectile was found in their right leg."
--L.search_hitgroup_leftleg = "The projectile was found in their left leg."
--L.search_hitgroup_gear = "The projectile was found in their hip."

--L.search_policingrole_report_confirm = [[
--A public policing role can only be called to a dead body after the corpse was confirmed dead.]]
--L.search_policingrole_confirm_disabled_1 = [[
--The corpse can only be confirmed by a public policing role. Report the body to let them know!]]
--L.search_policingrole_confirm_disabled_2 = [[
--The corpse can only be confirmed by a public policing role. Report the body to let them know!
--You can see the information in here after they confirmed it.]]
--L.search_spec = [[
--As a spectator you are able to see all information of a corpse, but unable to interact with the UI.]]

--L.search_title_words = "Victim's last words"
--L.search_title_c4 = "Defusion mishap"
--L.search_title_dmg_crush = "Crush damage ({amount} HP)"
--L.search_title_dmg_bullet = "Bullet damage ({amount} HP)"
--L.search_title_dmg_fall = "Fall damage ({amount} HP)"
--L.search_title_dmg_boom = "Explosion damage ({amount} HP)"
--L.search_title_dmg_club = "Club damage ({amount} HP)"
--L.search_title_dmg_drown = "Drowning damage ({amount} HP)"
--L.search_title_dmg_stab = "Stabbing damage ({amount} HP)"
--L.search_title_dmg_burn = "Burning damage ({amount} HP)"
--L.search_title_dmg_teleport = "Teleport damage ({amount} HP)"
--L.search_title_dmg_car = "Car accident ({amount} HP)"
--L.search_title_dmg_other = "Unknown damage ({amount} HP)"
--L.search_title_time = "Death time"
--L.search_title_dna = "DNA sample decay"
--L.search_title_kills = "The victim's kill list"
--L.search_title_eyes = "The killer's shadow"
--L.search_title_floor = "Floor of the crime scene"
--L.search_title_credits = "{credits} Equipment credit(s)"
--L.search_title_water = "Water level {level}"
--L.search_title_policingrole_report_confirm = "Confirm to report death"
--L.search_title_policingrole_confirm_disabled = "Report corpse"
--L.search_title_spectator = "You are a spectator"

--L.target_credits_on_confirm = "Confirm to receive unspent credits"
--L.target_credits_on_search = "Search to receive unspent credits"
--L.corpse_hint_no_inspect_details = "Only public policing roles can find information on this body."
--L.corpse_hint_inspect_limited_details = "Only public policing roles can confirm the body."
--L.corpse_hint_spectator = "Press [{usekey}] to view search UI"
--L.corpse_hint_public_policing_searched = "Press [{usekey}] to view search results from public policing role"

--L.label_inspect_confirm_mode = "Select body search mode"
--L.choice_inspect_confirm_mode_0 = "mode 0: standard TTT"
--L.choice_inspect_confirm_mode_1 = "mode 1: limited confirm"
--L.choice_inspect_confirm_mode_2 = "mode 2: limited search"
--L.help_inspect_confirm_mode = [[
--There are three different body search/confirm modes in this gamemode. The selection of this mode has huge influences to the importance of public policing roles like the detective.
--
--mode 0: This is standard TTT behavior. Everyone can search and confirm bodies. To report a body or to take the credits from it, the body first has to be confirmed. This makes it a bit harder for shopping roles to sneakily steal credits. However innocent players that want to report the body to call a public policing player need to confirm first as well.
--
--mode 1: This mode increases the importance of public policing roles by limiting the confirmation option to them. This also means that taking credits and reporting bodies is now also possible before confirming a body. Everybody can still search dead bodies and find the information, but they are unable to announce the found information.
--
--mode 2: This mode is yet a bit more strict than mode 1. In this mode the search ability is removed as well from normal players. This means that reporting a dead body to a public policing player is now the only way to get any information from dead bodies.]]

-- 2023-10-19
--L.label_grenade_trajectory_ui = "Grenade trajectory indicator"

-- 2023-10-23
--L.label_hud_pulsate_health_enable = "Pulsate healthbar when below 25% health"
--L.header_hud_elements_customize = "Customize the HUD-Elements"
--L.help_hud_elements_special_settings = "These are specific settings for the used HUD-Elements."

-- 2023-10-25
--L.help_keyhelp = [[
--Key bind helper is a UI element that always shows relevant keybindings to the player, which is especially helpful for new players. There are three different types of key bindings:
--
--Core: These contain the most important bindings found in TTT2. Without them the game is hard to play to its full potential.
--Extra: Similar to core, but you don't always need them. They contain stuff like chat, voice or flashlight. It might be helpful for new players to enable this.
--Equipment: Some equipment items have their own bindings, these are shown in this category.
--
--Disabled categories are still shown when the scoreboard is visible]]

--L.label_keyhelp_show_core = "Enable always showing the core bindings"
--L.label_keyhelp_show_extra = "Enable always showing the extra bindings"
--L.label_keyhelp_show_equipment = "Enable always showing the equipment bindings"

--L.header_interface_keys = "Key helper settings"
--L.header_interface_wepswitch = "Weapon switch UI settings"

--L.label_keyhelper_help = "open gamemode menu"
--L.label_keyhelper_mutespec = "cycle spectator mute mode"
--L.label_keyhelper_shop = "open equipment shop"
--L.label_keyhelper_show_pointer = "free mouse pointer"
--L.label_keyhelper_possess_focus_entity = "possess focused entity"
--L.label_keyhelper_spec_focus_player = "spectate focused player"
--L.label_keyhelper_spec_previous_player = "previous player"
--L.label_keyhelper_spec_next_player = "next player"
--L.label_keyhelper_spec_player = "spectate random player"
--L.label_keyhelper_possession_jump = "prop: jump"
--L.label_keyhelper_possession_left = "prop: left"
--L.label_keyhelper_possession_right = "prop: right"
--L.label_keyhelper_possession_forward = "prop: forward"
--L.label_keyhelper_possession_backward = "prop: backward"
--L.label_keyhelper_free_roam = "leave object and roam free"
--L.label_keyhelper_flashlight = "toggle flashlight"
--L.label_keyhelper_quickchat = "open quickchat"
--L.label_keyhelper_voice_global = "global voice chat"
--L.label_keyhelper_voice_team = "team voice chat"
--L.label_keyhelper_chat_global = "global chat"
--L.label_keyhelper_chat_team = "team chat"
--L.label_keyhelper_show_all = "show all"
--L.label_keyhelper_disguiser = "toggle disguiser"
--L.label_keyhelper_save_exit = "save and exit"
--L.label_keyhelper_spec_third_person = "toggle third person view"

-- 2023-10-26
--L.item_armor_reinforced = "Reinforced Armor"
--L.item_armor_sidebar = "Armor protects you against bullets penetrating your body. But not forever."
--L.item_disguiser_sidebar = "The disguiser protects your identity by not showing your name to other players."
--L.status_speed_name = "Speed Multiplier"
--L.status_speed_description_good = "You are faster than normal. Items, equipment or effects can influence this."
--L.status_speed_description_bad = "You are slower than normal. Items, equipment or effects can influence this."

--L.status_on = "on"
--L.status_off = "off"

--L.crowbar_help_primary = "Attack"
--L.crowbar_help_secondary = "Push players"

-- 2023-10-27
--L.help_HUD_enable_description = [[
--Some HUD elements like the key helper or sidebar show detailed information when the scoreboard is open. This can be disabled to reduce clutter.]]
--L.label_HUD_enable_description = "Enable descriptions when scoreboard is open"
--L.label_HUD_enable_box_blur = "Enable UI box background blur"

-- 2023-10-28
--L.submenu_gameplay_voiceandvolume_title = "Voice & Volume"
--L.header_soundeffect_settings = "Sound Effects"
--L.header_voiceandvolume_settings = "Voice & Volume Settings"

-- 2023-11-06
--L.drop_reserve_prevented = "Something prevents you from dropping your reserve ammo."
--L.drop_no_reserve = "Insufficient ammo in your reserve to drop as an ammo box."
--L.drop_no_room_ammo = "You have no room here to drop your ammo!"

-- 2023-11-14
--L.hat_deerstalker_name = "Detective's Hat"

-- 2023-11-16
--L.help_prop_spec_dash = [[
--Propspec dashes are movements into the direction of the aim vector. They can be of higher force than the normal movement. Higher force also means higher base value consumption.
--
--This variable is a multiplier of the push force.]]
--L.label_spec_prop_dash = "Dash force multiplier"
--L.label_keyhelper_possession_dash = "prop: dash in view direction"
--L.label_keyhelper_weapon_drop = "drop selected weapon if possible"
--L.label_keyhelper_ammo_drop = "drop reserved ammo from selected weapon"

-- 2023-12-07
--L.c4_help_primary = "Place the C4"
--L.c4_help_secondary = "Stick to surface"

-- 2023-12-11
--L.magneto_help_primary = "Push entity"
--L.magneto_help_secondary = "Pull / pickup entity"
--L.knife_help_primary = "Stab"
--L.knife_help_secondary = "Throw knife"
--L.polter_help_primary = "Fire thumper"
--L.polter_help_secondary = "Charge long range shot"

-- 2023-12-12
--L.newton_help_primary = "Knockback shot"
--L.newton_help_secondary = "Charged knockback shot"

-- 2023-12-13
--L.vis_no_pickup = "Only public policing roles can pick up the visualizer"
--L.newton_force = "FORCE"
--L.defuser_help_primary = "Defuse targeted C4"
--L.radio_help_primary = "Place the Radio"
--L.radio_help_secondary = "Stick to surface"
--L.hstation_help_primary = "Place the Health Station"
--L.flaregun_help_primary = "Burn body/entity"

-- 2023-12-14
--L.marker_vision_owner = "Owner: {owner}"
--L.marker_vision_distance = "Distance: {distance}"
--L.marker_vision_distance_collapsed = "{distance}"

--L.c4_marker_vision_time = "Detonation time: {time}"
--L.c4_marker_vision_collapsed = "{time} / {distance}"

--L.c4_marker_vision_safe_zone = "Bomb safe zone"
--L.c4_marker_vision_damage_zone = "Bomb damage zone"
--L.c4_marker_vision_kill_zone = "Bomb kill zone"

--L.beacon_marker_vision_player = "Tracked Player"
--L.beacon_marker_vision_player_tracked = "This player is tracked by a Beacon"

-- 2023-12-18
--L.beacon_help_pri = "Throw Beacon on the ground"
--L.beacon_help_sec = "Stick Beacon to surface"
--L.beacon_name = "Beacon"
--L.beacon_desc = [[
--Broadcasts player locations to everyone in a sphere around this beacon.
--
--Use to keep track of locations on the map that are hard to see.]]

--L.msg_beacon_destroyed = "One of your beacons has been destroyed!"
--L.msg_beacon_death = "A player died in close proximity to one of your beacons."

--L.beacon_short_desc = "Beacons are used by policing roles to add local wallhacks around them"

--L.entity_pickup_owner_only = "Only the owner can pick this up"

L.body_confirm_one = "{finder} 確認了 {victim} 的死。"
--L.body_confirm_more = "{finder} confirmed the {count} deaths of: {victims}."

-- 2023-12-19
--L.builtin_marker = "Built-in."
--L.equipmenteditor_desc_builtin = "This equipment is built-in, it comes with TTT2!"
--L.help_roles_builtin = "This role is built-in, it comes with TTT2!"
--L.header_equipment_info = "Equipment information"

-- 2023-12-20
--L.equipmenteditor_desc_damage_scaling = [[Multiplies the base damage value of a weapon by this factor.
--For a shotgun, this would affect each pellet.
--For a rifle, this would affect just the bullet.
--For the poltergeist, this would affect each "thump" and the final explosion.
--
--0.5 = Deal half the amount of damage.
--2 = Deal twice the amount of damage.
--
--Note: Some weapons might not use this value which causes this multiplier to be ineffective.]]

-- 2023-12-24
--L.submenu_gameplay_accessibility_title = "Accessibility"

--L.header_accessibility_settings = "Accessibility Settings"

--L.label_enable_dynamic_fov = "Enable dynamic FOV change"
--L.label_enable_bobbing = "Enable view bobbing"
--L.label_enable_bobbing_strafe = "Enable view bobbing when strafing"

--L.help_enable_dynamic_fov = "Dynamic FOV is applied depending on the player's speed. When a player is sprinting for example, the FOV is increased to visualize the speed."
--L.help_enable_bobbing_strafe = "View bobbing is the slight camera shake while walking, swimming or falling."

--L.binoc_help_reload = "Clear target."
--L.cl_sb_row_sresult_direct_conf = "Direct confirmation"
--L.cl_sb_row_sresult_pub_police = "Public policing role confirmation"

-- 2024-01-05
--L.label_crosshair_thickness_outline_enable = "Enable crosshair outline"
--L.label_crosshair_outline_high_contrast = "Enable outline high contrast color"
--L.label_crosshair_mode = "Crosshair mode"
--L.label_crosshair_static_length = "Enable static crosshair line length"

--L.choice_crosshair_mode_0 = "Lines and dot"
--L.choice_crosshair_mode_1 = "Lines only"
--L.choice_crosshair_mode_2 = "Dot only"

--L.help_crosshair_scale_enable = [[
--Dynamic crosshair enables scaling the crosshair depending on the weapon's cone. The cone is influenced by the weapon's base accuracy, multiplied with external factors such as jumping and sprinting.
--
--If the line length is kept static, only the gap scales with cone changes.]]

--L.header_weapon_settings = "Weapon Settings"

-- 2024-01-24
--L.grenade_fuse = "FUSE"

-- 2024-01-25
--L.header_roles_magnetostick = "Magneto Stick"
--L.label_roles_ragdoll_pinning = "Enable ragdoll pinning"
--L.magneto_stick_help_carry_rag_pin = "Pin ragdoll"
--L.magneto_stick_help_carry_rag_drop = "Put down ragdoll"
--L.magneto_stick_help_carry_prop_release = "Release prop"
--L.magneto_stick_help_carry_prop_drop = "Put down prop"

-- 2024-01-27
L.decoy_help_primary = "安放誘餌"
--L.decoy_help_secondary = "Stick Decoy to surface"


--L.marker_vision_visible_for_0 = "Visible for you"
--L.marker_vision_visible_for_1 = "Visible for your role"
--L.marker_vision_visible_for_2 = "Visible for your team"
--L.marker_vision_visible_for_3 = "Visible for everyone"

-- 2024-02-14
--L.throw_no_room = "You have no space here to drop this device"

-- 2024-03-04
--L.use_entity = "Press [{usekey}] to use"

-- 2024-03-06
--L.submenu_gameplay_sounds_title = "Client-Sounds"

--L.header_sounds_settings = "UI Sound Settings"

--L.help_enable_sound_interact = "Interaction sounds are those sounds that are played when opening an UI. Such a sound is played for example when interacting with the radio marker."
--L.help_enable_sound_buttons = "Button sounds are clicky sounds that are played when clicking a button."
--L.help_enable_sound_message = "Message or notification sounds are played for chat messages and notifications. They can be quite obnoxious."

--L.label_enable_sound_interact = "Enable interaction sounds"
--L.label_enable_sound_buttons = "Enable button sounds"
--L.label_enable_sound_message = "Enable message sounds"

--L.label_level_sound_interact = "Interaction sound level multiplier"
--L.label_level_sound_buttons = "Button sound level multiplier"
--L.label_level_sound_message = "Message sound level multiplier"

-- 2024-03-07
--L.label_crosshair_static_gap_length = "Enable static crosshair gap size"
--L.label_crosshair_size_gap = "Crosshair gap size multiplier"

-- 2024-03-31
--L.help_locational_voice = "Proximity chat is TTT2's implementation of locational 3D voice. Players are only audible in a set radius around them and become quieter the farther away they are."
--L.help_locational_voice_prep = [[By default the proximity chat is disabled in the preparing phase. If this option enabled, proximity chat is also enabled in the preparing phase.
--
--Note: Proximity chat is always disabled during the post round phase.]]
--L.help_voice_duck_spectator = "Muffling spectators makes other spectators quieter in comparison to living players. This can be useful if you want to listen closely to the discussions of the living players."

--L.help_equipmenteditor_configurable_clip = [[The configurable size defines the amount of uses the weapon has when bought in the shop or spawned in the world.
--
--Note: This setting is only available for weapons that enable this feature.]]
--L.label_equipmenteditor_configurable_clip = "Configurable clip size"

-- 2024-04-06
--L.help_locational_voice_range = [[This option constrains the maximum range at which players can hear each other. It does not change how the volume decreases with distance but rather sets a hard cut-off point.
--
--Set to 0 to disable this cut-off.]]

-- 2024-04-07
--L.help_voice_activation = [[Changes the way your microphone is activated for global voice chat. These all use your 'Global Voice Chat' keybinding. Team voice chat is always push-to-talk.
--
--Push-to-Talk: Hold down the key to talk.
--Push-to-Mute: Your mic is always on, hold down the key to mute yourself.
--Toggle: Press the key to toggle your mic on/off.
--Toggle (Activate on Join): Like 'Toggle' but your mic gets activated when joining the server.]]
--L.label_voice_activation = "Voice Chat Activation Mode"
--L.label_voice_activation_mode_ptt = "Push to Talk"
--L.label_voice_activation_mode_ptm = "Push to Mute"
--L.label_voice_activation_mode_toggle_disabled = "Toggle"
--L.label_voice_activation_mode_toggle_enabled = "Toggle (Activate on Join)"

-- 2024-04-08
--L.label_inspect_credits_always = "Allow all players to see credits on dead bodies"
--L.help_inspect_credits_always = [[
--When shopping roles die, their credits can be picked up by other players with shopping roles.
--
--When this option is disabled, only players that can pick up credits can see them on a body.
--When enabled, all players can see credits on a body.]]

-- 2024-05-13
--L.menu_commands_title = "Admin Commands"
--L.menu_commands_description = "Change maps, spawn bots and edit player roles."

--L.submenu_commands_maps_title = "Maps"

--L.header_maps_prefixes = "Enable/Disable Maps by their Prefix"
--L.header_maps_select = "Select and Change Maps"

--L.button_change_map = "Change Map"

-- 2024-05-20
--L.submenu_commands_commands_title = "Commands"

--L.header_commands_round_restart = "Round Restart"
--L.header_commands_player_slay = "Slay Player"
--L.header_commands_player_teleport = "Teleport Player to Focused Point"
--L.header_commands_player_respawn = "Respawn Player at Focused Point"
--L.header_commands_player_add_credits = "Add Equipment Credits"
--L.header_commands_player_set_health = "Set Health"
--L.header_commands_player_set_armor = "Set Armor"

--L.label_button_round_restart = "round restart"
--L.label_button_player_slay = "slay player"
--L.label_button_player_teleport = "teleport player"
--L.label_button_player_respawn = "respawn player"
--L.label_button_player_add_credits = "add credits"
--L.label_button_player_set_health = "set health"
--L.label_button_player_set_armor = "set armor"

--L.label_slider_add_credits = "Set credit amount"
--L.label_slider_set_health = "Set health"
--L.label_slider_set_armor = "Set armor"

--L.label_player_select = "Select affected player"
--L.label_execute_command = "Execute command"

-- 2024-05-22
--L.tip38 = "You can pick up focused weapons by pressing {usekey}. It will automatically drop you blocking weapon."
--L.tip39 = "You can change your key bindings in the bindings menu, located in the Settings menu opened with {helpkey}."
--L.tip40 = "On the left side of your screen are icons showing current equipment or status effects applied to you."
--L.tip41 = "If you open your scoreboard, the sidebar and key helper show additional information."
--L.tip42 = "The key helper at the bottom of your screen shows relevant bindings available to you at that moment."
--L.tip43 = "The icon next to the name of a confirmed corpse shows the role of the deceased player."

--L.header_loadingscreen = "Loading Screen"

--L.help_enable_loadingscreen = "The loading screen is shown when the map refreshes after a round. It is introduced to hide the visible and audible lag that appears on big maps. It is also used to show gameplay tips."

--L.label_enable_loadingscreen = "Enable the loading screen"
--L.label_enable_loadingscreen_tips = "Enable tips on loading screen"

-- 2024-05-25
--L.help_round_restart_reset = [[
--Restart a round or reset the level.
--
--Restarting a round only restarts the current round so you can start over. Resetting the level clears everything so that the game starts new as if it is fresh after a map change.]]

--L.label_button_level_reset = "reset level"

--L.loadingscreen_round_restart_title = "Starting new round"
--L.loadingscreen_round_restart_subtitle_limits_mode_0 = "you're playing on {map}"
--L.loadingscreen_round_restart_subtitle_limits_mode_1 = "you're playing on {map} for another {rounds} round(s) or {time}"
--L.loadingscreen_round_restart_subtitle_limits_mode_2 = "you're playing on {map} for {time}"
--L.loadingscreen_round_restart_subtitle_limits_mode_3 = "you're playing on {map} for another {rounds} round(s)"

-- 2024-06-23
--L.header_roles_derandomize = "Role Derandomization"

--L.help_roles_derandomize = [[
--Role derandomization can be used to make role distribution feel more fair over the course of a session.
--
--In essence, when it is enabled, a player's chance of receiving a role increases while they have not been assigned that role. While this can feel more fair, this also enables metagaming, where a player can guess that another will be traitor-aligned based on the fact that they have not been traitor aligned in several rounds. Do not enable this option if this is undesirable.
--
--There are 4 modes:
--
--mode 0: Disabled - No derandomization is done.
--
--mode 1: Base roles only - Derandomization is performed for base roles only. Subroles will be selected randomly. These are roles like Innocent and Traitor.
--
--mode 2: Subroles only - Derandomization is performed for subroles only. Base roles will be selected randomly. Note that subroles are only assigned to players which have already been selected for their base role.
--
--mode 3: Base roles AND subroles - Derandomization is performed for both base roles and subroles.]]
--L.label_roles_derandomize_mode = "Derandomization mode"
--L.label_roles_derandomize_mode_none = "mode 0: Disabled"
--L.label_roles_derandomize_mode_base_only = "mode 1: Base roles only"
--L.label_roles_derandomize_mode_sub_only = "mode 2: Subroles only"
--L.label_roles_derandomize_mode_base_and_sub = "mode 3: Base roles AND subroles"

--L.help_roles_derandomize_min_weight = [[
--Derandomization is performed by making the random player selections during role distribution use a weight associated with each role for each player, and that weight increases by 1 each time the player does not get assigned that role. These weights are not persisted between connections, or across maps.
--
--Each time a player is assigned a role, the corresponding weight is reset to this minimum weight. This weight does not have any absolute meaning; it can only be interpreted with respect to other weights.
--
--For example, given player A with a weight of 1, and player B with a weight of 5, player B is 5 times more likely than player A to be selected. However, if player A had a weight of 4, player B is only 5/4 times more likely to be selected.
--
--The minimum weight, therefore, effectively controls how much each round affects a player's chance at being selected, with higher values causing it to be affected less. The default value of 1 means that each round causes a fairly significant increase in chance, and conversely, that it is extremely unlikely that a player will get the same role twice in a row.
--
--Changes to this value will not take effect until players reconnect or the map changes.]]
--L.label_roles_derandomize_min_weight = "Derandomization minimum weight"

-- 2024-08-17
--L.name_button_default = "Button"
--L.name_button_rotating = "Lever"

--L.button_default = "Press [{usekey}] to trigger"
--L.button_rotating = "Press [{usekey}] to flip"

--L.undefined_key = "???"

-- 2024-08-18
--L.header_commands_player_force_role = "Force Player Role"

--L.label_button_player_force_role = "force role"

--L.label_player_role = "Select role"

-- 2024-09-16
--L.help_enable_loadingscreen_server = [[
--The loading screen settings also exist on the client. They are hidden if disabled on the server.
--
--The minimum display time is there to give the player time to read the tips. If the reload of the map takes longer than the minimum time, the loading screen is shown as long as it needs to be. In general a reload time of 0.5 to 1 second is to be expected.]]

--L.label_enable_loadingscreen_server = "Enable the loading screen serverwide"
--L.label_loadingscreen_min_duration = "Minimum loading screen display time"

-- 2024-09-18
--L.label_keyhelper_leave_vehicle = "leave vehicle"
--L.name_vehicle = "Vehicle"
--L.vehicle_enter = "Press [{usekey}] to enter vehicle"

-- 2024-11-27
--L.corpse_hint_without_confirm = "Press [{usekey}] to search."

-- 2025-01-05
--L.help_session_limits_mode = [[
--There are four different session limit modes you can choose from:
--
--mode 0: No session limits. TTT2 will not end the session and will not trigger a map change.
--
--mode 1: Default TTT2 mode. A map change will trigger if either the session time or session round count runs out.
--
--mode 2: Only time limit. A map change will only trigger if the session time runs out.
--
--mode 3: Only round limit. A map change will only trigger if the session round count runs out.]]
--L.label_session_limits_mode = "Set session limit mode"
--L.choice_session_limits_mode_0 = "mode 0: no session limits"
--L.choice_session_limits_mode_1 = "mode 1: time and round limit"
--L.choice_session_limits_mode_2 = "mode 2: only time limit"
--L.choice_session_limits_mode_3 = "mode 3: only round limit"

-- 2024-12-30
--L.searchbar_roles_placeholder = "Search roles..."
--L.label_menu_search_no_items = "No items matched your search."

--L.submenu_roles_overview_title = "Roles Overview (READ ME)"

-- Is there a way to ahve some sort of external file that's possibly-localized?
--L.roles_overview_html = [[
--<h1>Overview</h1>
--
--One of TTT2's core mechanics are <em>roles</em>. They control what your
--goals are, who your teammates are, and what you can do. The way that they
--are distributed to players is thus very important. The role distribution
--system is very complicated, and submenus in this menu control almost every
--aspect of that system. For many of the options available, understanding how
--the distribution system as a whole works can be crucial to being able to make
--the changes you want for your server.
--
--<h2>Terminology</h2>
--
--<ul>
--<li><em>Role</em> &mdash; The role assigned to a player at round start,
--e.g. <em>Traitor</em>, <em>Innocent</em>, <em>Necromancer</em>, etc.</li>
--<li><em>Base role</em> &mdash; A <em>role</em>
--selected first, that acts as a kind of high-level template for the final
--role a player will recieve. <em>Base roles</em> can be final roles. Ex.
--<em>Innocent</em>, <em>Traitor</em>, <em>Pirate</em></li>
--<li><em>Subrole</em> &mdash; A <em>role</em> assigned as a
--refinement of a <em>base role</em>. Each possible <em>subrole</em> is
--associated with a <em>base role</em>, such that a player must have been
--assigned the appropriate <em>base role</em> for them to end up with a
--<em>subrole</em>. Ex. <em>Detective</em> (Innocent subrole), <em>Hitman</em>
--(Traitor subrole), <em>Survivalist</em> (Innocent subrole), etc.</li>
--</ul>
--
--<h2>The Algorithm</h2>
--
--<em>Implementation is</em> <code>roleselection.SelectRoles</code>
--
--<ol>
--
--<li>
--<p>
--Determine the number of players that can be given each role.
--<em>Innocent</em> and <em>Traitor</em> always have available slots.
--</p>
--<p>
--All roles (both base and subroles) get the computed here. Subroles
--only have selectable slots if their corresponding base roles do.
--</p>
--<p>
--Each role is assigned a chance that it's distributed. If that chance
--fails, this step sets the possible number of players with this role to zero.
--</p>
--<p>
--<em>Implemented in</em>
--<code>roleselection.GetAllSelectableRolesList</code>
--</p>
--</li>
--
--<li>
--<p>
--Select the roles that will actually be distributed, limited by the
--layer configuration and configured maximum number of roles. This process
--is sufficiently complicated to be worthy of its own section; details
--are in the next section.
--</p>
--<p>
--<em>Implemented in</em>
--<code>roleselection.GetSelectableRolesList</code>
--</p>
--</li>
--
--<li>
--<p>
--Assign forced roles (those that were asked by some external code or addon).
--There is also some extra logic to deal with the case where a player was assigned
--multiple forced roles. This is not commonly used, but is included for completeness.
--</p>
--</li>
--
--<li>
--<p>
--Randomly shuffle the list of players. Though this likely doesn't
--meaningfully impact the role distribution, it guarantees that there is no
--dependence on player join order.
--</p>
--</li>
--
--<li>
--<p>
--For each selectable base role (in order <em>Traitor</em>,
--<em>Innocent</em>, remaining base roles):
--</p>
--<ol type="a">
--<li>
--<p>
--Assign up to the allowed number of players to the base role. (this
--will be detailed later)
--</p>
--<p><em>Implemented in</em> <code>SelectBaseRolePlayers</code></p>
--</li>
--<li>
--<p>
--If the base role is not <em>Innocent</em>, try to "upgrade" players
--with that base role to possible subroles. (this will also be detailed
--later)
--</p>
--<p><em>Implemented in</em> <code>UpgradeRoles</code></p>
--</li>
--</ol>
--</li>
--
--<li>
--<p>
--All players not yet assigned a role are assigned <em>Innocent</em>.
--</p>
--</li>
--
--<li>
--<p>
--All players with the <em>Innocent</em> base role have their role
--"upgraded" exactly as in step 5b.
--</p>
--</li>
--
--<li>
--<p>
--The hook <code>TTT2ModifyFinalRoles</code> is called to allow other
--addons to affect final roles.
--</p>
--</li>
--
--<li>
--<p>
--Role weights for each player are updated according to their final role.
--(if the player's final role is a subrole, their corresponding base role
--is also updated)
--</p>
--</li>
--
--</ol>
--
--<h3>
--Role Layering (a.k.a. <code>roleselection.GetSelectableRolesList</code>)
--</h3>
--
--<p>Role layering is the most controllable part of role distribution, and
--historically the worst explained. In short, <em>role layering</em>
--determines <em>what</em> roles can be distributed, but NOT <em>how</em>.</p>
--
--<p>The algorithm is as follows:</p>
--<ol>
--<li>
--<p>For each base role layer configured (as long as there are enough
--players that more roles are needed):</p>
--<ol type="a">
--<li>
--<p>
--Remove all roles in the layer with no available player slots.
--(this will remove roles which were previously randomly decided
--to not be distributed)
--</p>
--</li>
--<li>
--<p>
--Select one role from what's left of the layer at random.
--</p>
--</li>
--<li>
--<p>
--Add the role to the final list of candidate base roles.
--</p>
--</li>
--</ol>
--</li>
--<li>
--<p>Randomly iterate non-layered base roles. For each such base role,
--add the role to the final candidate list.</p>
--</li>
--<li>
--<p>Modify each candidate base role's available slots so that the sum is the
--total number of players, preferring candidates added first.</p>
--</li>
--<li>
--<p>Now, subroles. Evaluate once per selectable subrole (including all
--layered and unlayered subroles for all base roles in the base role
--candidate list):</p>
--<ol type="a">
--<li>
--<p>Randomly select a base role candidate.</p>
--</li>
--<li>
--<p>
--If there are any layers defined for that base role: Select a random
--subrole from the first available layer. Remove the layer.
--</p>
--<p>
--If there are no layers defined for that base role: Select a random
--subrole from the unlayered subroles. Remove that subrole from the
--unlayered list.
--</p>
--</li>
--<li>
--<p>Add the selected subrole to the final candidate list.</p>
--</li>
--<li>
--<p>
--If the base role has no more subrole layers or subroles: Remove the
--base role from further consideration (for this loop ONLY. It stays
--in the candidate list.)
--</p>
--</li>
--</ol>
--</li>
--<li>
--<p>The base role and subrole candidate lists now contain the roles which
--will be assigned.</p>
--</li>
--</ol>
--
--<h3>Base role Selection (a.k.a. <code>SelectBaseRolePlayers</code>)</h3>
--
--<p>Recall that we assign ALL players to ONE base role.</p>
--<p>As long as there are players to assign, and more available slots to
--assign:</p>
--<ol>
--<li>
--<p>Select a player to assign the role to.</p>
--<p>
--If <em>role derandomization</em> (see <em>Role Derandomization</em>
--section in <em>General Role Settings</em> submenu) is set to "base roles
--only" or "base roles AND subroles": Select a random player from the
--available ones taking into account the weight associated with this base
--role. (think of it as if each player occurs multiple times in the list,
--according to the weight)
--</p>
--<p>
--If <em>role derandomization</em> is set to "disabled" or "subroles
--only": Select a random player from the available onse, with equal
--probability.
--</p>
--</li>
--
--<li>
--<p>
--If the selected player has enough karma for the role, there are not
--enough players to fill all slots, a 1/3 chance passes, or the target
--base role is <em>Innocent</em>: Remove the player from the list of
--available players and assign the player the base role.
--</p>
--</li>
--</ol>
--
--<h3>Subrole Selection (a.k.a. <code>UpgradeRoles</code>)</h3>
--
--<p>This is <em>very</em> similar to base role selection.</p>
--<p>When upgrading roles, ALL subroles associated with a base role are
--processed together, and the same so goes to all players with that base role.</p>
--<p>Only subroles that have assignable slots that are not filled are
--considered. (this is relevant in the presence of forced subroles)</p>
--
--<p>As long as there are players to assign, and more subroles which
--are assignable:</p>
--<ol>
--<li>
--<p>Select a player to assign the role to.</p>
--<p>
--If <em>role derandomization</em> is set to "subroles only" or
--"base roles AND subroles": Select a random player from the available ones
--taking into account the weight associated with this subrole.
--</p>
--<p>
--If <em>role derandomization</em> is set to "disabled" or "base roles
--only": Select a random player from the available ones, with equal
--probability.
--</p>
--</li>
--
--<li>
--<p>
--If the selected player has enough karma for the role, there are not
--enough players to fill all slots, or a 1/3 chance passes (this is the
--same condition as above, and in the code, is a shared function): Remove
--the player from the list of available players and assign the player the
--subrole. If the subrole has had all available slots filled, remove it
--from consideration.
--</p>
--</li>
--</ol>
--
--]]

-- 2025-01-07
--L.graph_sort_mode_none = "No Sorting"
--L.graph_sort_mode_highlight_order = "Highlighted First"
--L.graph_sort_mode_value_asc = "Ascending"
--L.graph_sort_mode_value_desc = "Descending"
--L.graph_sort_mode_player_name = "Player Name"

--L.submenu_roles_roleinspect = "Role Distribution Inspection"
--L.header_roleinspect_info = "Role Distribution Inspection"
--L.help_roleinspect = [[When this is enabled, information about the decisions made during role distribution is collected. If any such information is available, it is displayed on this page.
--
--This information is only ever available for the last round which was started on this map with the option enabled.
--
--Must be enabled when role distribution happens (when the round starts) to take effect.]]
--L.label_roleinspect_enable = "Enable capturing role distribution inspection information"
--L.label_roleinspect_no_data = "No role inspection data is available."
--L.help_roleinspect_unknown_stage = "Unknown stage when rendering UI. Please open an issue."

-- Decisions
--L.roleinspect_decision_none = "No decision was made."
--L.roleinspect_decision_consider = "The role will be considered."
--L.roleinspect_decision_no_consider = "The role will not be considered."
--L.roleinspect_decision_role_assigned = "The role is assigned."
--L.roleinspect_decision_role_not_assigned = "The role is not assigned."

-- ROLEINSPECT_STAGE_PRESELECT
--L.header_roleinspect_stage_preselect = "Stage 1: Preselection"
--L.help_roleinspect_stage_preselect = [[
--This stage determines the number of players that can be assigned each role. Roles with 0 possible players are not considered further.
--
--Hover over each role icon for details about that role.
--
--Max players: {maxPlayers}]]
--L.tooltip_preselect_role_desc = [[
--Role: {name}
--Decision: {decision}
--Reason: {reason}
--# of Players: {finalCount}]]

-- Reasons
-- REASON_FORCED for a CONSIDER decision in PRESELECT == Role is a builtin
--L.roleinspect_reason_forced_d_consider_s_preselect = "This is a builtin role, and will always be considered."
--L.roleinspect_reason_passed_d_consider_s_preselect = "All requirements are met and all checks passed."
--L.roleinspect_reason_not_selectable_d_no_consider_s_preselect = "The role is not selectable."
--L.roleinspect_reason_not_enabled_d_no_consider_s_preselect = "The role is not enabled."
--L.roleinspect_reason_role_chance_d_no_consider_s_preselect = "The random check for whether the role should appear failed."
--L.roleinspect_reason_no_players_d_no_consider_s_preselect = "There are not enough players for this role to be considered."
--L.roleinspect_reason_role_decision_d_no_consider_s_preselect = "The role distribution decided it was not selectable, and provided no more detailed information."

-- ROLEINSPECT_STAGE_LAYERING
--L.header_roleinspect_stage_layering = "Stage 2: Layering"
--L.help_roleinspect_stage_layering = [[
--This stage distributes candidate roles among player slots. This is also where Role Layering is applied.
--
--The layers shown here will be different than those configured:
--- Roles that did not pass the previous stage are not shown
--- Layers with no candidate roles are not shown (and layers are renumbered)
--
--Hover over each role for details about that role.
--
--Max roles: {maxRoles}
--Max base roles: {maxBaseroles}]]
--L.header_inspect_layers_baseroles = "Base role layers"
--L.header_inspect_layers_subroles = "{baserole} subrole layers"
--L.tooltip_layering_role_desc = [[
--Role: {name}
--Decision: {decision}
--Reason: {reason}
--# of Players: {finalCount}]]
--L.header_inspect_layers_order = "Subrole selection order"
--L.help_inspect_layers_order = [[
--When selecting available subroles, first a base role is selected (shown as the large icon). Then, a subrole is selected according to layering (shown as the small icon).
--
--This is important because there is a maximum number of roles (either explicitly, or because of player count). Once player slots or role slots are filled, assignment stops and all remaining roles are not used.]]
--L.tooltip_inspect_layers_baserole = "Base role: {name}"
--L.tooltip_inspect_layers_subrole = "Selected subrole: {name}"

-- Reasons

--L.roleinspect_reason_layer_d_consider_s_layering = "This is the selected role for this layer."
--L.roleinspect_reason_layer_d_no_consider_s_layering = "Another role from this layer was selected."
--L.roleinspect_reason_not_layered_d_consider_s_layering = "This role was selected after all layers were."
--L.roleinspect_reason_no_players_d_no_consider_s_layering = "Other roles filled all player slots."
--L.roleinspect_reason_too_many_roles_d_no_consider_s_layering = "Other roles filled all role slots."

-- ROLEINSPECT_STAGE_BASEROLES
--L.header_roleinspect_stage_baseroles = "Stage 3: Base role Assignment"
--L.help_roleinspect_stage_baseroles = [[
--This stage assigns base roles to players. If derandomization is enabled, players' role weights are considered, and displayed below in a chart.
--
--Each section shows all players which were considered for that base role, with the highlighted ones being the ones actually selected.]]
--L.header_inspect_baseroles_order = "{name} assignment"

-- ROLEINSPECT_STAGE_SUBROLES
--L.header_roleinspect_stage_subroles = "Stage 4: Subrole Upgrading"
--L.help_roleinspect_stage_subroles = [[
--This stage upgrades players to subroles, from previously assigned base roles.
--
--Information is presented as in the base roles stage above. Each base role is upgraded separately.]]
--L.header_inspect_upgrade_order = "Upgrading from {name}"
--L.header_inspect_subroles_order = "Subrole {name}"
--L.label_inspect_no_subroles = "No subroles were selectable."

-- ROLEINSPECT_STAGE_FINAL
--L.header_roleinspect_stage_final = "Final Roles"
--L.help_roleinspect_stage_final = [[
--This shows the final role assignments. These may have been modified by a hook after subroles were assigned.]]

-- 2025-01-19
--L.help_rolelayering_enable = "The red and green border around the icon shows if the role is currently enabled. Right click on an icon to quickly enable/disable that role."

-- 2025-01-20
--L.label_hud_show_team_name = "Enable showing team name next to role name"

-- 2025-01-31
--L.radio_desc = [[
--Plays sounds to distract or deceive.
--
--Place the radio somewhere, and then remotely interact with it to choose sounds to play.]]

-- 2025-02-13
--L.help_c4_radius = [[
--C4 uses two different zones to calculate the damage of its explosion:
--
--Players within the "kill zone" will receive the full damage of the devastating explosion.
--
--Players within the "damage zone" (and outside the "kill zone") will receive a percentage of the damage based on their position between the borders of both zones.]]

--L.label_c4_radius_inner = "C4 Kill Zone radius"
--L.label_c4_radius = "C4 Damage Zone radius"

-- 2025-02-21
--L.length_in_meters = "{length}m"
--L.length_in_yards = "{length}yd"
--L.length_in_feet = "{length}ft"

--L.label_distance_unit = "Preferred unit of length for distance displays"
--L.choice_distance_unit_0 = "Inches"
--L.choice_distance_unit_1 = "Meters"
--L.choice_distance_unit_2 = "Yards"
--L.choice_distance_unit_3 = "Feet"

-- 2025-03-06
--L.label_armor_block_clubdmg = "Enable armor blocking crowbar damage"

-- 2025-03-10
--L.label_sprint_stamina_cooldown = "Stamina cooldown time"
--L.label_sprint_stamina_forwards_only = "Disallow sprinting backwards or laterally"
