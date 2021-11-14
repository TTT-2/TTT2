-- Traditional Chinese language strings

local L = LANG.CreateLanguage("zh_tw")

-- Compatibility language name that might be removed soon.
-- the alias name is based on the original TTT language name:
-- https://github.com/Facepunch/garrysmod/blob/master/garrysmod/gamemodes/terrortown/gamemode/lang/simpchinese.lua
L.__alias = "正體中文"

L.lang_name = "正體中文 (Traditional Chinese)"

-- General text used in various places
L.traitor    = "叛徒"
L.detective  = "探長"
L.innocent   = "無辜者"
L.last_words = "遺言"

L.terrorists = "恐怖分子"
L.spectators = "旁觀者"

L.nones = "無陣營"
L.innocents = "無辜陣營"
L.traitors = "叛徒陣營"

-- Round status messages
L.round_minplayers = "沒有足夠的玩家來開始新的回合…"
L.round_voting     = "投票進行中，新的回合將延遲到 {num} 秒後開始…"
L.round_begintime  = "新回合將在 {num} 秒後開始。請做好準備。"
L.round_selected   = "叛徒玩家已選出"
L.round_started    = "回合開始！"
L.round_restart    = "遊戲被管理員強制重新開始。"

L.round_traitors_one  = "叛徒，你得自己頂住了。"
L.round_traitors_more = "叛徒，你的隊友是： {names} 。"

L.win_time         = "時間用盡，叛徒失敗了。"
L.win_traitor      = "叛徒取得了勝利！"
L.win_innocent     = "叛徒們被擊敗了！"
L.win_nones        = "梅友仁勝利了！（平局）"
L.win_showreport   = "一起觀看觀看 {num} 秒的回合總結吧！"

L.limit_round      = "已達遊戲回合上限，接著將載入地圖 {mapname}"
L.limit_time       = "已達遊戲時間上限，接著將載入地圖 {mapname}"
L.limit_left       = "在載入地圖 {mapname} 前，還有 {num} 回合或者 {time} 分鐘的剩餘時間。"

-- Credit awards
L.credit_all       = "你的陣營因為表現獲得了 {num} 點信用點數。"
L.credit_kill      = "你殺死 {role} 獲得了 {num} 點信用點數。"

--- Karma
L.karma_dmg_full   = "你的業值為 {amount} ，因此本回合你擁有造成百分之百傷害的待遇！"
L.karma_dmg_other  = "你的業值為 {amount} ，因此本回合你造成的傷害將減少 {num} %"

--- Body identification messages
L.body_found       = "{finder} 發現了 {victim} 的屍體。 {role}"
L.body_found_team  = "{finder} 發現了 {victim} 的屍體。{role} ({team})"

-- The {role} in body_found will be replaced by one of the following:
L.body_found_t     = "他是一位叛徒！"
L.body_found_d     = "他是一位探長。"
L.body_found_i     = "他是一位無辜者。"

L.body_confirm     = "{finder} 確認了 {victim} 的死。"

L.body_call        = "{player} 呼喚探長前來檢查 {victim} 的屍體！"
L.body_call_error  = "你必須先確定該玩家的死，才能呼叫探長！"

L.body_burning     = "噢！ 這屍體著火了！"
L.body_credits     = "你在屍體上找到 {num} 點的信用點數！"

--- Menus and windows
L.close = "關閉"
L.cancel = "取消"

-- For navigation buttons
L.next = "下一個"
L.prev = "上一個"

-- Equipment buying menu
L.equip_title            = "裝備"
L.equip_tabtitle         = "購買裝備"

L.equip_status           = "購買選單"
L.equip_cost             = "你的信用點數剩下 {num} 點。"
L.equip_help_cost        = "你買的每一件裝備都消耗 1 點的信用點數。"

L.equip_help_carry       = "你只能在擁有空位時購買物品。"
L.equip_carry            = "你能攜帶這件裝備。"
L.equip_carry_own        = "你已擁有這件裝備。"
L.equip_carry_slot       = "已擁有武器欄第 {slot} 項的武器。"
L.equip_carry_minplayers = "服務器玩家數量不足以啟用這個武器。"

L.equip_help_stock       = "每回合你只能購買一件相同的物品。"
L.equip_stock_deny       = "這件物品不會再有庫存。"
L.equip_stock_ok         = "這件物品已有庫存。"

L.equip_custom           = "自訂物品新增於伺服器中。"

L.equip_spec_name        = "名字"
L.equip_spec_type        = "類型"
L.equip_spec_desc        = "描述"

L.equip_confirm          = "購買裝備"

-- Disguiser tab in equipment menu
L.disg_name      = "偽裝物"
L.disg_menutitle = "偽裝控制器"
L.disg_not_owned = "你無法持有偽裝物！"
L.disg_enable    = "執行偽裝"

L.disg_help1     = "偽裝開啟後，別人瞄準你時，將不會看見你的名字，生命以及業值。除此之外，你也能躲避探長的雷達。"
L.disg_help2     = "可直接在主選單外，使用數字鍵來切換偽裝。你也可以用控制台指令綁定一個按鍵（ttt_toggle_disguise）。"

-- Radar tab in equipment menu
L.radar_name      = "雷達"
L.radar_menutitle = "雷達控制器"
L.radar_not_owned = "你未持有雷達！"
L.radar_scan      = "執行掃描"
L.radar_auto      = "自動重複掃描"
L.radar_help      = "掃描結果將顯示 {num} 秒，接著雷達充電後你便可以再次使用。"
L.radar_charging  = "你的雷達尚在充電中！"

-- Transfer tab in equipment menu
L.xfer_name       = "傳送器"
L.xfer_menutitle  = "傳送餘額"
L.xfer_send       = "發送傳送餘額"

L.xfer_no_recip   = "接收者無效，傳送餘額轉移失敗。"
L.xfer_no_credits = "傳送餘額不足，無法轉移"
L.xfer_success    = "傳送點數成功轉移給 {player} ！"
L.xfer_received   = " {player} 給予你 {num} 點傳送餘額。"

-- Radio tab in equipment menu
L.radio_name      = "收音機"
L.radio_help      = "點擊按鈕，讓收音機播放音樂。"
L.radio_notplaced = "你必須放置收音機以播放音樂。"

-- Radio soundboard buttons
L.radio_button_scream  = "尖叫"
L.radio_button_expl    = "爆炸"
L.radio_button_pistol  = "手槍射擊"
L.radio_button_m16     = "M16步槍射擊"
L.radio_button_deagle  = "沙漠之鷹射擊"
L.radio_button_mac10   = "MAC10衝鋒槍射擊"
L.radio_button_shotgun = "散彈射擊"
L.radio_button_rifle   = "狙擊步槍射擊"
L.radio_button_huge    = "M249機槍連發"
L.radio_button_c4      = "C4嗶嗶聲"
L.radio_button_burn    = "燃燒"
L.radio_button_steps   = "腳步聲"

-- Intro screen shown after joining
L.intro_help     = "若你是遊戲初學者，可按下F1查看遊戲教學！"

-- Radiocommands/quickchat
L.quick_title   = "快速聊天按鍵"

L.quick_yes     = "是。"
L.quick_no      = "不是。"
L.quick_help    = "救命！"
L.quick_imwith  = "我和 {player} 在一起。"
L.quick_see     = "我看到了 {player} 。"
L.quick_suspect = " {player} 行跡可疑。"
L.quick_traitor = " {player} 是叛徒！"
L.quick_inno    = " {player} 是無辜者。"
L.quick_check   = "還有人活著嗎？"

-- {player} in the quickchat text normally becomes a player nickname, but can
-- also be one of the below.  Keep these lowercase.
L.quick_nobody    = "沒有人"
L.quick_disg      = "有人偽裝了"
L.quick_corpse    = "一具未搜索過的屍體"
L.quick_corpse_id = " {player} 的屍體"

--- Body search window
L.search_title  = "屍體搜索結果"
L.search_info   = "訊息"
L.search_confirm = "確認死亡"
L.search_call   = "呼叫探長"

-- Descriptions of pieces of information found
L.search_nick   = "這是 {player} 的屍體。"

L.search_role_traitor = "這個人是叛徒！"
L.search_role_det = "這個人是探長。"
L.search_role_inno = "這個人是無辜的恐怖分子。"

L.search_words  = "某些事物讓你了解到此人的遺言： {lastwords}"
L.search_armor  = "他穿戴非標準裝甲。"
L.search_disg   = "他持有一個能隱匿身份的設備"
L.search_radar  = "他持有像是雷達的物品。已經無法使用了。"
L.search_c4     = "你在他口袋中找到了一本筆記。記載著線路 {num} 是解除炸彈須剪除的一條。"

L.search_dmg_crush  = "他多處骨折。看起來是某種重物的衝擊撞死了他。"
L.search_dmg_bullet = "他很明顯是被射殺身亡的。"
L.search_dmg_fall   = "他是墜落身亡的。"
L.search_dmg_boom   = "他的傷口以及燒焦的衣物，應是爆炸導致其死亡。"
L.search_dmg_club   = "他的身體有許多擦傷打擊痕跡，明顯是被毆打致死的。"
L.search_dmg_drown  = "他身上的蛛絲馬跡顯示是溺死的。"
L.search_dmg_stab   = "他是被刺擊與揮砍後，迅速失血致死的。"
L.search_dmg_burn   = "聞起來有燒焦的恐怖分子在附近.."
L.search_dmg_tele   = "看起來他的DNA以超光速粒子之形式散亂在附近。"
L.search_dmg_car    = "他穿越馬路時被一個粗心的駕駛碾死了。"
L.search_dmg_other  = "你無法找到這恐怖份子的具體死因。"

L.search_weapon = "這顯示死者是被 {weapon} 所殺。"
L.search_head   = "最嚴重的傷口在頭部。完全沒機會叫喊。"
L.search_time   = "他大約死於你進行搜索的 {time} 前。"
L.search_dna    = "用DNA掃描器檢索兇手的DNA標本，DNA樣本大約在 {time} 前開始衰退。"

L.search_kills1 = "你找到一個名單，記載著他發現的死者： {player}"
L.search_kills2 = "你找到了一個名單，記載著他殺的這些人:"
L.search_eyes   = "透過你的探查技能，你確信他臨死前見到的最後一個人： {player} 。是兇手，還是巧合？"

-- Scoreboard
L.sb_playing    = "你正在玩的伺服是.."
L.sb_mapchange  = "地圖將於 {num} 個回合或是 {time} 後更換"

L.sb_mia        = "下落不明"
L.sb_confirmed  = "確認死亡"

L.sb_ping       = "Ping"
L.sb_deaths     = "死亡數"
L.sb_score      = "分數"
L.sb_karma      = "業值"

L.sb_info_help  = "搜索此玩家的屍體，可以獲取一些線索。"

L.sb_tag_friend = "可信任者"
L.sb_tag_susp   = "有嫌疑者"
L.sb_tag_avoid  = "應迴避者"
L.sb_tag_kill   = "已死者"
L.sb_tag_miss   = "失蹤者"

-- Equipment actions, like buying and dropping
L.buy_no_stock  = "無法購買此裝備：你已擁有它了。"
L.buy_pending   = "你已訂購此裝備，請等待配送。"
L.buy_received  = "你已收到此裝備。"

L.drop_no_room  = "你沒有足夠空間存放新武器！"

L.disg_turned_on  = "偽裝開啟！"
L.disg_turned_off = "偽裝關閉。"

-- Equipment item descriptions
L.item_passive    = "被動效果型物品"
L.item_active     = "主動操作型物品"
L.item_weapon     = "武器"

L.item_armor      = "身體裝甲"
L.item_armor_desc = [[
阻擋子彈，火焰和爆炸傷害。耐久會隨著使用而降低。

這個裝備可以購買多次。護甲達到一定閾值後防禦力會上升。]]

L.item_radar      = "雷達"
L.item_radar_desc = [[
允許你掃描生命訊號。

一旦持有，它將自動掃描。需要啟用時，可在選單設定它]]

L.item_disg       = "偽裝"
L.item_disg_desc  = [[
啟用時，你的ID將被隱藏；也可避免探長在屍體上找到死者生前見到的最後一個人。

需要啟用時：在選單裡標記偽裝選項，或是按下相關數字鍵。]]

-- C4
L.c4_hint         = "按下 {usekey} 來裝置或拆除C4。"
L.c4_disarm_warn  = "你所裝置的C4已被拆除。"
L.c4_armed        = "C4裝置成功。"
L.c4_disarmed     = "你成功拆除了C4。"
L.c4_no_room      = "你無法攜帶C4。"

L.c4_desc         = "C4爆炸！"

L.c4_arm          = "裝置C4。"
L.c4_arm_timer    = "計時器"
L.c4_arm_seconds  = "引爆秒數："
L.c4_arm_attempts = "拆除C4時，六條引線中有 {num} 條會立即引發爆炸。"

L.c4_remove_title    = "移除"
L.c4_remove_pickup   = "撿起C4"
L.c4_remove_destroy1 = "銷毀C4"
L.c4_remove_destroy2 = "確認：銷毀"

L.c4_disarm       = "拆除C4"
L.c4_disarm_cut   = "點擊以剪斷 {num} 號引線"

L.c4_disarm_owned = "剪斷引線以拆除C4。你是裝置此C4的人，細節瞭然於胸，任一條引線都可成功拆除。"
L.c4_disarm_other = "剪斷正確的引線以拆除C4。倘若你犯了錯，後果將不堪設想唷！"

L.c4_status_armed    = "裝置"
L.c4_status_disarmed = "拆除"

-- Visualizer
L.vis_name        = "顯像器"
L.vis_hint        = "按下 {usekey} 鍵撿起它（僅限於偵探）。"

L.vis_desc        = [[
可讓犯罪現場顯像化的儀器。

分析屍體，顯像出死者被殺害時的情況，但僅限於死者遭到射殺時。]]

-- Decoy
L.decoy_name      = "雷達誘餌"
L.decoy_no_room   = "你無法攜帶雷達誘餌。"
L.decoy_broken    = "你的雷達誘餌已被摧毀！"

L.decoy_short_desc        = "這個誘餌會為其他陣營顯示一個假雷達信號"
L.decoy_pickup_wrong_team = "這個誘餌屬於其他陣營，你無法撿起"

L.decoy_desc      = [[
顯示假的雷達信號給探長，探長執行DNA掃描時，將會顯示雷達誘餌的位置作為代替。]]

-- Defuser
L.defuser_name    = "拆彈器"
L.defuser_help    = " {primaryfire} 拆除目標炸彈。"

L.defuser_desc    = [[
迅速拆除一個C4。
不限制使用次數。若你持有此設備，
拆除C4時會輕鬆許多。]]

-- Flare gun
L.flare_name      = "信號槍"

L.flare_desc      = [[
可用來燒毀屍體，使它們永遠不會被發現。該武器有彈藥限制。

燃燒屍體時，會發出極度明顯的聲音。]]

-- Health station
L.hstation_name   = "醫療站"
L.hstation_hint   = "按下 {usekeu} 恢復健康。剩餘存量： {num}"
L.hstation_broken = "你的醫療站已被摧毀！"
L.hstation_help   = " {primaryfire} 裝置了一個醫療站。"

L.hstation_desc   = [[
設置後，允許人們前來治療。恢復速度相當緩慢。

所有人都可以使用，且醫療站本身也會受損。不僅如此，它亦可以檢驗每位使用者的DNA樣本。]]

-- Knife
L.knife_name      = "刀子"
L.knife_thrown    = "飛刀"

L.knife_desc      = [[
可以迅速、無聲的殺死受傷的目標，但只能使用一次。

按下右鍵即可使用飛刀。]]

-- Poltergeist
L.polter_desc     = [[
放置震動器在物體上，使它們粗暴地四處亂跑、亂跳。

能量爆炸，會使接近的人受到傷害。]]

-- Radio
L.radio_broken    = "你的收音機已被摧毀！"
L.radio_help_pri  = " {primaryfire} 裝置了收音機。"

L.radio_desc      = [[
播放音樂使人們分心、誤導。

將收音機置於某處，在選單使用收音機並播放音樂。]]

-- Silenced pistol
L.sipistol_name   = "消音手槍"

L.sipistol_desc   = [[
噪音極小的手槍。使用一般的手槍彈藥。
被害者被射殺時不會喊叫。]]


-- Newton launcher
L.newton_name     = "牛頓發射器"

L.newton_desc     = [[
推擊一個人，以換取安全距離。

彈藥無限，但射擊間隔較長。]]

-- Binoculars
L.binoc_name      = "雙筒望遠鏡"

L.binoc_desc      = [[
拉近鏡頭，可遠距離觀察並確認屍體。

不限使用次數，但確認屍體時會更花時間。]]

-- UMP
L.ump_desc        = [[
實驗型衝鋒槍，容易失去控制。

使用標準衝鋒槍彈藥。]]

-- DNA scanner
L.dna_name        = "DNA掃描器"
L.dna_identify    = "檢索屍體將能確認兇手身分。"
L.dna_notfound    = "目標上沒有DNA樣本。"
L.dna_limit       = "已達最大採集額度，新增前請先移除舊樣本。"
L.dna_decayed     = "兇手的DNA樣本發生衰變。"
L.dna_killer      = "成功採集到兇手的DNA樣本！"
L.dna_no_killer   = "DNA樣本無法檢索（兇手已斷線？）"
L.dna_armed       = "炸彈已啟動！趕緊拆除它！"
L.dna_object      = "在目標上採集到 {num} 個新DNA樣本。"
L.dna_gone        = "區域內沒偵測到可採集之DNA樣本。"

L.dna_desc        = [[
採集物體上的DNA樣本，並用其找尋對應的主人。

使用在屍體上，採集殺手的DNA並追蹤他。]]

-- Magneto stick
L.magnet_name     = "電磁棍"
L.magnet_help     = " {primaryfire} 用於屍體以將之吸附。"

-- Grenades and misc
L.grenade_smoke   = "煙霧彈"
L.grenade_fire    = "燃燒彈"

L.unarmed_name    = "收起武器"
L.crowbar_name    = "鐵撬"
L.pistol_name     = "手槍"
L.rifle_name      = "狙擊槍"
L.shotgun_name    = "散彈槍"

-- Teleporter
L.tele_name       = "傳送裝置"
L.tele_failed     = "傳送失敗"
L.tele_marked     = "傳送地點已標記"

L.tele_no_ground  = "你必須站在地面上來才能進行傳送！"
L.tele_no_crouch  = "蹲著的時候不能傳送！"
L.tele_no_mark    = "請先標記傳送地點，才能進行傳送。"

L.tele_no_mark_ground = "你必須站在地面上才能標記傳送地點！"
L.tele_no_mark_crouch = "你必須站起來才能標記傳送點！"

L.tele_help_pri   = "傳送到已標記之傳送地點"
L.tele_help_sec   = "標記傳送地點"

L.tele_desc       = [[
可以傳送到先前標記的地點。

傳送器會產生噪音，而且使用次數是有限的。]]

-- Ammo names, shown when picked up
L.ammo_pistol     = "9mm手槍彈藥"

L.ammo_smg1       = "衝鋒槍彈藥"
L.ammo_buckshot   = "散彈槍彈藥"
L.ammo_357        = "步槍彈藥"
L.ammo_alyxgun    = "沙漠之鷹彈藥"
L.ammo_ar2altfire = "信號彈藥"
L.ammo_gravity    = "搗蛋鬼彈藥"

-- Round status
L.round_wait   = "等待中"
L.round_prep   = "準備中"
L.round_active = "遊戲進行中"
L.round_post   = "回合結束"

-- Health, ammo and time area
L.overtime     = "延長時間"
L.hastemode    = "急速模式"

-- TargetID health status
L.hp_healthy   = "健康的"
L.hp_hurt      = "輕傷的"
L.hp_wounded   = "輕重傷的"
L.hp_badwnd    = "重傷的"
L.hp_death     = "近乎死亡"

-- TargetID karma status
L.karma_max    = "名聲好"
L.karma_high   = "有點粗魯"
L.karma_med    = "扣扳機愛好者"
L.karma_low    = "危險人物"
L.karma_min    = "負人命債累累"

-- TargetID misc
L.corpse       = "屍體"
L.corpse_hint  = "按下 {usekey} 來搜索，用 {walkkey} + {usekey} 進行無聲搜索。"

L.target_disg  = " （偽裝狀態）"
L.target_unid  = "未確認的屍體"

L.target_credits = "搜索屍體以獲取未被消耗的信用點數"

-- HUD buttons with hand icons that only traitors can see
L.tbut_single  = "單獨使用"
L.tbut_reuse   = "重複使用"
L.tbut_retime  = "在 {num} 秒後重複使用"
L.tbut_help    = "按下 {key} 鍵啟動"

-- Spectator muting of living/dead
L.mute_living  = "將生存的玩家設定靜音"
L.mute_specs   = "將旁觀者設定靜音"
L.mute_all     = "全部靜音"
L.mute_off     = "取消靜音"

-- Spectators and prop possession
L.punch_title  = "重擊測量器 " --"PUNCH-O-METER"
L.punch_help   = "按下行走鍵或跳躍鍵以推撞物品；按蹲下鍵則離開物品控制。"
L.punch_bonus  = "你的分數較低，重擊測量器上限減少 {num}"
L.punch_malus  = "你的分數較高，重擊測量器上限增加 {num} ！"

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

你的同伴有:
{traitorlist}

按下{menukey}取得裝備！]]

--- Various other text
L.name_kick = "一名玩家因於此回合中改變了名字而被自動踢出遊戲。"

L.idle_popup = [[
你閒置了 {num} 秒，所以被轉往觀察者模式。當你位於此模式時，將不會在回合開始時重生。

你可在任何時間取消觀察者模式，按下 {helpkey} 並在選單取消勾選「觀察者模式」即可。當然，你也可以選擇立刻關閉它。]]

L.idle_popup_close = "什麼也不做"
L.idle_popup_off   = "立刻關閉觀察者模式"

L.idle_warning = "警告：你已閒置一段時間，將轉往觀察者模式。活著就要動！"

L.spec_mode_warning = "你位於觀察者模式故將不會在回合開始時重生。若要關閉此模式，按下F1並取消勾選「觀察者模式」即可。"

-- Tips panel
L.tips_panel_title = "提示"
L.tips_panel_tip   = "提示："

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

L.tip10 = "叛徒與探長應保持注意螢幕右上方的紅色訊息，這對你無比重要。"

L.tip11 = "若叛徒與探長能和同伴配合得好，將擁有額外的信用點數。請將它用在對的地方！"

L.tip12 = "探長的DNA掃描器可使用在武器或道具上，找到曾使用它的玩家的位置。用在屍體或C4上效果將更好！"

L.tip13 = "太靠近你殺害的人的話，DNA將殘留在屍體上，探長的DNA掃描器會以此找到你的正確位置。切記，殺了人最好將屍體藏好！"

L.tip14 = "殺人時離被害者越遠，殘留在屍體上的DNA就會越快衰變！"

L.tip15 = "你是叛徒而且想進行狙擊？試試偽裝吧！若你狙殺失準，逃到安全的地方，取消偽裝，就沒人知道是你開的槍囉！"

L.tip16 = "作為叛徒，傳送器可幫助你逃脫追蹤，並讓你得以迅速穿過整個地圖。請隨時確保有個安全的傳送標記。"

L.tip17 = "是否遇過無辜者群聚在一起而難以下手？請試試用收音機發出C4嗶嗶聲或交火聲，讓他們分散。"

L.tip18 = "叛徒可以在選單使用已放置的收音機，依序點擊想播放的聲音，就會按順序排列播放。"

L.tip19 = "探長若有多餘的信用點數，可將拆彈器交給一位可信任的無辜者，將危險的C4交給他們，自己全神貫注地調查與處決叛徒。"

L.tip20 = "探長的望遠鏡可讓你遠距離搜索並確認屍體，壞消息是叛徒總是會用誘餌欺騙你。當然，使用望遠鏡的探長全身都是破綻。"

L.tip21 = "探長的醫療站可讓受傷的玩家恢復健康，當然，其中也包括叛徒..."

L.tip22 = "治療站將遺留每位前來治療的人的DNA樣本，探長可將其用在DNA掃描器上，尋找究竟誰曾受過治療。"

L.tip23 = "與武器、C4不同，收音機並不會留下你的DNA樣本，不用擔心探長會在上頭用DNA識破你的身分。"

L.tip24 = "按下 {helpkey} 閱讀教學或變更設定，比如說，你可以永遠關掉現在所看到的提示唷～"

L.tip25 = "探長確認屍體後，相關訊息將在計分板公布，如要查看只需點擊死者之名字即可。."

L.tip26 = "計分板上，人物名字旁的放大鏡圖樣可以查看關於他的訊息，若圖樣亮著，代表是某位探長確認後的結果。"

L.tip27 = "探長調查屍體後的結果將公布在計分板，供所有玩家查看。"

L.tip28 = "觀察者可以按下 {mutekey} 循環調整對其他觀察者或遊戲中的玩家靜音。"

L.tip29 = "若伺服器有安裝其他語言，你可以在任何時間開啟F1選單，啟用不同語言。"

L.tip30 = "若要使用語音或無線電，可以按下 {zoomkey} 使用。"

L.tip31 = "作為觀察者，按下 {duckkey} 能使視角固定，可在遊戲內移動游標，也可以點擊提示欄裡的按鈕。此外，再次按下 {duckkey} 會解除之，恢復預設視角控制。"

L.tip32 = "使用撬棍時，按下右鍵可推開其他玩家。"

L.tip33 = "使用武器瞄準器射擊將些微提升你的精準度，並降低後座力。蹲下則不會。"

L.tip34 = "煙霧彈於室內相當有效，尤其是在擁擠的房間中製造混亂。"

L.tip35 = "叛徒，請記住你能搬運屍體並將它們藏起來，避開無辜者與探長的耳目。"

L.tip36 = "按下 {helpkey} 可以觀看教學，其中包含了重要的遊戲關鍵。"

L.tip37 = "在計分板上，點擊活人玩家的名字，可以選擇一個標記（如令人懷疑的或友好的）記錄這位玩家。此標誌會在你的準心指向該玩家時顯示。"

L.tip38 = "許多需放置的裝備（如C4或收音機），可以使用右鍵將其置於牆上。"

L.tip39 = "拆除C4時失誤導致的爆炸，比起直接引爆時來得小。"

L.tip40 = "若時間上顯示「急速模式」，此回合的時間會很短，但每位玩家的死亡都將延長時間（就像TF2的佔領點模式）。延長時間將迫使叛徒加緊腳步。"

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
L.report_save     = "儲存 Log.txt"
L.report_save_tip = "將事件記錄並儲存在txt檔內"
L.report_save_error  = "沒有可供儲存的事件記錄"
L.report_save_result = "事件記錄已存在："

-- Big title window
L.hilite_win_traitors = "叛徒獲得勝利"
L.hilite_win_none = "梅友仁勝利"
L.hilite_win_innocent = "無辜者獲得勝利"

L.hilite_players1 = " {numplayers} 名玩家加入遊戲， {numtraitors} 名玩家是叛徒"
L.hilite_players2 = " {numplayers} 名玩家加入遊戲，其中一人是叛徒"

L.hilite_duration = "回合持續了 {time}"

-- Columns
L.col_time   = "時間"
L.col_event  = "事件"
L.col_player = "玩家"
L.col_role   = "角色"
L.col_teams = "陣營"
L.col_kills1 = "無辜者殺敵數"
L.col_kills2 = "叛徒殺敵數"
L.col_points = "點數"
L.col_team   = "團隊紅利"
L.col_total  = "總分"

--- Awards/highlights
L.aw_sui1_title = "自殺邪教的教主"
L.aw_sui1_text  = "率先向其他自殺者展示如何自殺。"

L.aw_sui2_title = "孤獨沮喪者"
L.aw_sui2_text  = "就他一人自殺，無比哀戚。"

L.aw_exp1_title = "炸彈研究的第一把交椅"
L.aw_exp1_text  = "決心研究C4， {num} 名受試者證明了他的學說。"

L.aw_exp2_title = "田野研究"
L.aw_exp2_text  = "測試自己的抗暴性，顯然完全不夠高。"

L.aw_fst1_title = "第一滴血"
L.aw_fst1_text  = "將第一位無辜者的生命送到叛徒手上。"

L.aw_fst2_title = "愚蠢的血腥首殺"
L.aw_fst2_text  = "擊殺一名叛徒同伴而得到首殺，做得好啊！"

L.aw_fst3_title = "首殺大挫折"
L.aw_fst3_text  = "第一殺便將無辜者同伴誤認為叛徒，真是挫折啊！"

L.aw_fst4_title = "吹響號角"
L.aw_fst4_text  = "殺害一名叛徒，為無辜者陣營吹響了號角。"

L.aw_all1_title = "致命的平等"
L.aw_all1_text  = "得為所有人的死負責的無辜者。"

L.aw_all2_title = "孤獨之狼"
L.aw_all2_text  = "得為所有人的死負責的叛徒。"

L.aw_nkt1_title = "老大！我抓到一個！"
L.aw_nkt1_text  = "在一名無辜者落單時策劃一場謀殺，漂亮！"

L.aw_nkt2_title = "一石二鳥"
L.aw_nkt2_text  = "用另一具屍體證明上一槍不是巧合。"

L.aw_nkt3_title = "連續殺人魔"
L.aw_nkt3_text  = "在今天結束了三名無辜者的生命。"

L.aw_nkt4_title = "穿梭在批著羊皮的狼之間的狼"
L.aw_nkt4_text  = "將無辜者們作為晚餐吃了。共吃了 {num} 人。"

L.aw_nkt5_title = "反恐特工"
L.aw_nkt5_text  = "每一殺都能拿到報酬，現在他已經買得起豪華遊艇了！"

L.aw_nki1_title = "背叛死亡吧！"
L.aw_nki1_text  = "找出叛徒，將子彈送到他腦袋，簡單吧！"

L.aw_nki2_title = "申請進入正義連隊"
L.aw_nki2_text  = "成功將兩名叛徒送下地獄。"

L.aw_nki3_title = "叛徒夢到過叛徒羊嗎？"
L.aw_nki3_text  = "讓三名叛徒得到平靜。"

L.aw_nki4_title = "復仇者聯盟"
L.aw_nki4_text  = "每一殺都能拿到報酬。你已經夠格加入復仇者聯盟了！"

L.aw_fal1_title = "不，龐德先生，我希望你跳下去"
L.aw_fal1_text  = "將某人推下足以致死的高度。"

L.aw_fal2_title = "地板人"
L.aw_fal2_text  = "讓自己的身體從極端無盡的高度上落地。"

L.aw_fal3_title = "人體流星"
L.aw_fal3_text  = "讓一名玩家從高處落下，摔成爛泥。"

L.aw_hed1_title = "高效能"
L.aw_hed1_text  = "發現爆頭的樂趣，並擊殺了 {num} 名敵人。"

L.aw_hed2_title = "神經內科"
L.aw_hed2_text  = "近距離將 {num} 名玩家的腦袋取出，完成腦神經研究。"

L.aw_hed3_title = "是遊戲使我這麼做的"
L.aw_hed3_text  = "運用殺人模擬訓練的技巧，爆了 {num} 顆頭"

L.aw_cbr1_title = "鏗鏗鏗"
L.aw_cbr1_text  = "擁有相當規律的鐵撬舞動， {num} 名受害者能證明這點。"

L.aw_cbr2_title = "高登•弗里曼"
L.aw_cbr2_text  = "離開黑山，用喜愛的撬棍殺了至少 {num} 名玩家。"

L.aw_pst1_title = "死亡之握"
L.aw_pst1_text  = "用手槍殺死 {num} 名玩家前，都上前握了手。"

L.aw_pst2_title = "小口徑屠殺"
L.aw_pst2_text  = "用手槍殺了 {num} 人的小隊。我們推測他槍管裡頭有個微型散彈槍。"

L.aw_sgn1_title = "簡單模式"
L.aw_sgn1_text  = "用散彈槍近距離殺了 {num} 名玩家。"

L.aw_sgn2_title = "一千個小子彈"
L.aw_sgn2_text  = "不喜歡自己的散彈，打算送人。但已有 {num} 名受贈人無法享受禮物了。"

L.aw_rfl1_title = "瞄準，射擊！"
L.aw_rfl1_text  = "穩定的手上，那把狙擊槍奪去了 {num} 名玩家的生命。"

L.aw_rfl2_title = "我在這就看到你的頭了啦！"
L.aw_rfl2_text  = "十分瞭解他的狙擊槍，其他 {num} 名玩家隨即也瞭解了他的狙擊槍。"

L.aw_dgl1_title = "這簡直像是小型狙擊槍"
L.aw_dgl1_text  = "「沙鷹在手，天下我有！」，用沙漠之鷹殺了 {num} 名玩家。"

L.aw_dgl2_title = "老鷹大師"
L.aw_dgl2_text  = "用他手中的沙漠之鷹殺了 {num} 名玩家。"

L.aw_mac1_title = "祈禱，然後趴倒"
L.aw_mac1_text  = "用MAC10衝鋒槍殺了 {num} 名玩家，但別提他需要多少發子彈。"

L.aw_mac2_title = "大麥克的起司"
L.aw_mac2_text  = "想知道他持有兩把衝鋒槍會發生什麼事？那大概是 {num} 殺的兩倍囉？"

L.aw_sip1_title = "黑人給我閉嘴！"
L.aw_sip1_text  = "用消聲手槍射殺了 {num} 人。"

L.aw_sip2_title = "艾吉歐•奧狄托利"
L.aw_sip2_text  = "殺死 {num} 個人，但沒有任何人會聽到它們的死前呢喃。見識刺客大師的風骨吧！"

L.aw_knf1_title = "刀子懂你"
L.aw_knf1_text  = "在網路上用刀子捅人。"

L.aw_knf2_title = "你從哪弄來的啊？"
L.aw_knf2_text  = "不是叛徒，但仍然用刀子殺了一些人。"

L.aw_knf3_title = "開膛手傑克"
L.aw_knf3_text  = "在地上撿到 {num} 把匕首，並使用它們。"

L.aw_knf4_title = "我是赤屍藏人"
L.aw_knf4_text  = "通過刀子殺死了 {num} 個人。我只是個醫生。"

L.aw_flg1_title = "玩火少年"
L.aw_flg1_text  = "用燃燒彈導致 {num} 人死亡。"

L.aw_flg2_title = "汽油加上番仔火"
L.aw_flg2_text  = "使 {num} 名玩家葬身於火海。"

L.aw_hug1_title = "子彈多喔！"
L.aw_hug1_text  = "用M249機槍將子彈送到 {num} 名玩家身上。"

L.aw_hug2_title = "耐心大叔"
L.aw_hug2_text  = "從未放下M249機槍的扳機，他殺戮了 {num} 名玩家。"

L.aw_msx1_title = "啪啪啪"
L.aw_msx1_text  = "用M16步槍射殺了 {num} 名玩家。"

L.aw_msx2_title = "中距離瘋子"
L.aw_msx2_text  = "了解如何用他手中的M16，射殺了敵人。共有 {num} 名不幸的亡魂。"

L.aw_tkl1_title = "拍謝"
L.aw_tkl1_text  = "瞄準自己的隊友，並不小心扣下扳機。"

L.aw_tkl2_title = "拍謝拍謝"
L.aw_tkl2_text  = "認為自己抓到了兩次叛徒，但兩次都錯了！"

L.aw_tkl3_title = "小心業值！"
L.aw_tkl3_text  = "殺死兩個同伴已不能滿足他，三個才是他的最終目標！"

L.aw_tkl4_title = "專業賣同隊！"
L.aw_tkl4_text  = "殺了所有同伴，我的天啊！砰砰砰──"

L.aw_tkl5_title = "最佳主角"
L.aw_tkl5_text  = "扮演的是瘋子，真的，因為他殺了大多數的同伴。"

L.aw_tkl6_title = "莫非閣下是...低能兒？"
L.aw_tkl6_text  = "弄不清他屬於哪一隊，並殺死了半數以上的隊友。"

L.aw_tkl7_title = "園丁"
L.aw_tkl7_text  = "好好保護著自己的草坪，並殺死了四分之一以上的隊友。"

L.aw_brn1_title = "像小汝做菜一般"
L.aw_brn1_text  = "使用燃燒彈點燃數個玩家，將他們炸得很脆！"

L.aw_brn2_title = "火化官"
L.aw_brn2_text  = "將每一具被他殺死的受害者屍體燃燒乾淨。"

L.aw_brn3_title = "好想噴火！"
L.aw_brn3_text  = "「燒死你們！」，但地圖上已沒有燃燒彈了！因為都被他用完了。"

L.aw_fnd1_title = "驗屍官"
L.aw_fnd1_text  = "在地上發現 {num} 具屍體。"

L.aw_fnd2_title = "想全部看到！"
L.aw_fnd2_text  = "在地上發現了 {num} 具屍體，做為收藏。"

L.aw_fnd3_title = "死亡的氣味"
L.aw_fnd3_text  = "在這回合被屍體絆到了 {num} 次。"

L.aw_crd1_title = "環保官"
L.aw_crd1_text  = "在同伴屍體上找到了 {num} 點剩餘的購買點。"

L.aw_tod1_title = "沒到手的勝利"
L.aw_tod1_text  = "在他的團隊即將獲得勝利的前幾秒死去。"

L.aw_tod2_title = "人家不依啦！"
L.aw_tod2_text  = "在這回合剛開始不久即被殺害。"

--- New and modified pieces of text are placed below this point, marked with the
--- version in which they were added, to make updating translations easier.

--- v24
L.drop_no_ammo = "你彈夾內的子彈不足以丟棄成彈藥盒。"

-- 2015-05-25
L.hat_retrieve = "你撿起了一頂探長的帽子。"

-- 2017-09-03
L.sb_sortby = "排序方法:"

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
L.reroll_help = "使用 {amount} 信用點數刷新商店的裝備！"

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

L.spec_help = "點擊來觀察玩家，或對著物理道具按 {usekey} 來附身。"
L.spec_help2 = "若想離開觀察者模式，用 {helpkey} 打開菜單，在“遊戲性”選項中勾選選項。"

-- 2019-10-19
L.drop_ammo_prevented = "有什麽東西阻擋你丟出子彈。"

-- 2019-10-28
L.target_c4 = "按 [{usekey}] 打開C4菜單"
L.target_c4_armed = "按 [{usekey}] 拆除C4"
L.target_c4_armed_defuser = "按 [{usekey}] 使用拆彈器"
L.target_c4_not_disarmable = "你不能拆除存活隊友的C4"
L.c4_short_desc = "可以炸得很歡"

L.target_pickup = "按 [{usekey}] 撿起"
L.target_slot_info = "槽位：{slot}"
L.target_pickup_weapon = "按 [{usekey}] 撿起武器"
L.target_switch_weapon = "按 [{usekey}] 和當前武器交換"
L.target_pickup_weapon_hidden = "，按 [{usekey} + {walkkey}] 隱秘地撿起"
L.target_switch_weapon_hidden = "，按 [{usekey} + {walkkey}] 隱秘地交換"
L.target_switch_weapon_nospace = "沒有提供給這個武器的槽位"
L.target_switch_drop_weapon_info = "丟棄槽位 {slot} 的 {name}"
L.target_switch_drop_weapon_info_noslot = "槽位 {slot} 沒有可丟棄的武器"

L.corpse_searched_by_detective = "這個屍體被探長搜查過"
L.corpse_too_far_away = "這個屍體太遠了。"

L.radio_pickup_wrong_team = "你不能撿起其他隊伍的收音機"
L.radio_short_desc = "武器聲音，悅耳動聽"

L.hstation_subtitle = "按 [{usekey}] 恢復生命"
L.hstation_charge = "剩余充能: {charge}"
L.hstation_empty = "這個醫療站沒有剩余充能"
L.hstation_maxhealth = "你的生命恢復已滿"
L.hstation_short_desc = "醫療站會逐漸回復充能"

-- 2019-11-03
L.vis_short_desc = "還原被槍殺的屍體的犯罪現場"
L.corpse_binoculars = "按 [{key}] 用望遠鏡搜查屍體"
L.binoc_progress = "搜查進度: {progress}%"

L.pickup_no_room = "你沒有存放此類武器的空間"
L.pickup_fail = "你無法撿起這個武器"
L.pickup_pending = "你已經撿起這個武器，請等撿起完成"

-- 2020-01-07
L.tbut_help_admin = "編輯叛徒按鈕設定"
L.tbut_role_toggle = "[{walkkey} + {usekey}] 切換 {role} 的按鈕權限"
L.tbut_role_config = "身份: {current}"
L.tbut_team_toggle = "[SHIFT + {walkkey} + {usekey}] 切換 {team} 的按鈕權限"
L.tbut_team_config = "陣營: {current}"
L.tbut_current_config = "當前設定:"
L.tbut_intended_config = "地圖默認設定:"
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
L.door_open_touch_and_use = "接觸門或按 [{usekey}] 開門."
L.hud_health = "生命"

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
L.menu_gameplay_description = "避免特定身份和其他遊戲相關選項"
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
L.submenu_appearance_miscellaneous_title = "其他"

L.submenu_gameplay_general_title = "通用"
L.submenu_gameplay_avoidroles_title = "避免特定身份"

L.submenu_administration_hud_title = "HUD 設置"
L.submenu_administration_randomshop_title = "隨機商店"

L.help_color_desc = "此選項啟用後，準星和目標高亮的外框會顯示一個全局通用的顏色"
L.help_scale_factor = "這個比例影響所有界面大小 (HUD, vgui 和目標高亮)。屏幕分辨率修改後會自動更新這個比例。改變此比例會重置 HUD！"
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
L.label_crosshair_gap_enable = "啟用自定義準星大小"
L.label_crosshair_gap = "自定義準星大小"
L.label_crosshair_opacity = "準星透明度"
L.label_crosshair_ironsight_opacity = "瞄準時準星透明度"
L.label_crosshair_size = "準星長度"
L.label_crosshair_thickness = "準星粗細"
L.label_crosshair_thickness_outline = "準星外框粗細"
L.label_crosshair_static_enable = "啟用靜態準星"
L.label_crosshair_dot_enable = "啟用準星中點"
L.label_crosshair_lines_enable = "啟用準星直線"
L.label_crosshair_scale_enable = "啟用武器對應準星大小"
L.label_crosshair_ironsight_low_enabled = "瞄準時降低武器模型"
L.label_damage_indicator_enable = "啟用傷害指示"
L.label_damage_indicator_mode = "選擇傷害指示主題"
L.label_damage_indicator_duration = "受傷後指示顯示時間"
L.label_damage_indicator_maxdamage = "最大透明度對應傷害值"
L.label_damage_indicator_maxalpha = "最大透明度"
L.label_performance_halo_enable = "指向特定實體時顯示外框"
L.label_performance_spec_outline_enable = "啟用被附身物品的外框"
L.label_performance_ohicon_enable = "啟用頭上身份圖標"
L.label_interface_tips_enable = "啟用觀察時屏幕下方的遊戲提示"
L.label_interface_popup = "回合開始信息持續時間"
L.label_interface_fastsw_menu = "啟用快速切換菜單"
L.label_inferface_wswitch_hide_enable = "啟用武器菜單自動關閉"
L.label_inferface_scues_enable = "回合開始或結束時播放特定聲音"
L.label_gameplay_specmode = "觀察者模式（永遠觀察）"
L.label_gameplay_fastsw = "武器快速切換"
L.label_gameplay_hold_aim = "啟用持續瞄準"
L.label_gameplay_mute = "死亡時靜音存活玩家"
L.label_gameplay_dtsprint_enable = "啟用雙擊沖刺"
L.label_gameplay_dtsprint_anykey = "沖刺時任何方向鍵都持續沖刺"
L.label_hud_default = "默認 HUD"
L.label_hud_force = "強製 HUD"

L.label_bind_weaponswitch = "撿起武器"
L.label_bind_sprint = "沖刺"
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
L.header_roleselection = "啟用身份分配"
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
L.door_destructible = "此門不可摧毀 ({health}生命)"

-- 2020-05-28
L.confirm_detective_only = "只有偵探能確認死亡。"
L.inspect_detective_only = "只有偵探能檢查屍體。"
L.corpse_hint_no_inspect = "只有偵探能檢查這個屍體。"
L.corpse_hint_inspect_only = "按 [{usekey}] 搜索。只有偵探能確認死亡。"
L.corpse_hint_inspect_only_credits = "按 [{usekey}] 獲取信用點數。只有偵探能確認死亡。"

-- 2020-06-04
L.label_bind_disguiser = "切換偽裝器"

-- 2020-06-24
L.dna_help_primary = "收集DNA樣本"
L.dna_help_secondary = "切換當前DNA"
L.dna_help_reload = "刪除當前樣本"

L.binoc_help_pri = "確認屍體"
L.binoc_help_sec = "切換放大倍率"

L.vis_help_pri = "丟棄當前設備。"

L.decoy_help_pri = "安放誘餌。"

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

L.label_bind_clscore = "啟用回合總結"
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

L.tooltip_karma_gained = "本局獲得的業值："
L.tooltip_score_gained = "本輪得分："
L.tooltip_roles_time = "存活時間："

L.tooltip_finish_score_alive_teammates = "存活的隊友：{score}"
L.tooltip_finish_score_alive_all = "存活的玩家：{score}"
L.tooltip_finish_score_timelimit = "超時：{score}"
L.tooltip_finish_score_dead_enemies = "死去的敵人：{score}"
L.tooltip_kill_score = "擊殺：{score}"
L.tooltip_bodyfound_score = "發現屍體：{score}"

L.finish_score_alive_teammates = "存活的隊友："
L.finish_score_alive_all = "存活的玩家："
L.finish_score_timelimit = "超時："
L.finish_score_dead_enemies = "死去的敵人："
L.kill_score = "擊殺："
L.bodyfound_score = "發現屍體："

L.title_event_bodyfound = "發現了一具屍體"
L.title_event_c4_disarm = "一枚C4炸藥被解除了"
L.title_event_c4_explode = "一枚C4炸藥爆炸了"
L.title_event_c4_plant = "埋設了C4炸藥"
L.title_event_creditfound = "信用點數被發現"
L.title_event_finish = "本回合已經結束"
L.title_event_game = "新回合已經開始"
L.title_event_kill = "一名玩家被殺害"
L.title_event_respawn = "一名玩家復活了"
L.title_event_rolechange = "一名玩家改變了它的角色或團隊"
L.title_event_selected = "角色被選中"
L.title_event_spawn = "一名玩家生成了"

L.desc_event_bodyfound = "{finder} ({firole} / {fiteam}) 發現了 {found} ({forole} / {foteam}) 的屍體 。屍體上有 {credits} 個信用點數。"
L.desc_event_bodyfound_headshot = "死者是被爆頭殺死的。"
L.desc_event_c4_disarm_success = "{disarmer} ({drole} / {dteam}) 成功解除了由 {owner} ({orole} / {oteam}) 放置的C4炸彈。"
L.desc_event_c4_disarm_failed = "{disarmer} ({drole} / {dteam}) 試圖解除 {owner} ({orole} / {oteam})放置的C4炸彈，最終失敗了。"
L.desc_event_c4_explode = "{owner} ({role} / {team}) 放置的C4爆炸了。"
L.desc_event_c4_plant = "{owner} ({role} / {team}) 放置了C4炸藥。"
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
L.karma_roundheal_tooltip = "完成回合獎勵"
L.karma_unknown_tooltip = "未知"

-- 2021-05-07
L.header_random_shop_administration = "設置隨機商店"
L.header_random_shop_value_administration = "平衡性設置"

L.shopeditor_name_random_shops = "啟用隨機商店"
L.shopeditor_desc_random_shops = [[隨機商店只給每個玩家提供一套有限的隨機化裝備。
陣營商店迫使一個陣營中的所有玩家擁有相同的套裝，而不是定製化。
重新投票可以讓你用信用點數獲得一套新的隨機裝備。]]
L.shopeditor_name_random_shop_items = "隨機裝備的數量"
L.shopeditor_desc_random_shop_items = "這包括那些標有“非隨機”的設備。所以請選擇一個足夠高的數字，否則你只能得到這些。"
L.shopeditor_name_random_team_shops = "啟用陣營商店"
L.shopeditor_name_random_shop_reroll = "啟用商店重選功能"
L.shopeditor_name_random_shop_reroll_cost = "每次重選的花費"
L.shopeditor_name_random_shop_reroll_per_buy = "購買後自動重選"

-- 2021-06-04
L.header_equipment_setup = "設置裝備"
L.header_equipment_value_setup = "平衡性設置"

L.itemeditor_name_not_buyable = "可購買的裝備"
L.itemeditor_desc_not_buyable = "如果禁用，該裝備將不會顯示在商店裏。分配了這種裝備的角色仍然會獲得它。"
L.itemeditor_name_not_random = "永遠可用"
L.itemeditor_desc_not_random = "如果啟用，該裝備會在商店裏總是可用的。這在使用隨機商店時會占用一個裝備槽，並總是為這個裝備保留。"
L.itemeditor_name_global_limited = "全局限量"
L.itemeditor_desc_global_limited = "如果裝備是全局限量的，那麼它只能在單次回合中購買一次。"
L.itemeditor_name_team_limited = "陣營限量"
L.itemeditor_desc_team_limited = "如果裝備是陣營限量的，那麼它在單次回合中每陣營只能買一次。"
L.itemeditor_name_player_limited = "玩家限量"
L.itemeditor_desc_player_limited = "如果裝備是玩家限量的，那麼它在單次回合中每人只能買一次。"
L.itemeditor_name_min_players = "有多少玩家時可選擇"
L.itemeditor_name_credits = "價格以信用點數計算"

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
L.submenu_administration_rolelayering_title = "角色分層"
L.header_rolelayering_info = "角色分層信息"
L.help_rolelayering_roleselection = "角色選擇過程被分成兩個階段。在第一輪中，基礎角色被分配。基本角色是無辜者、叛徒和那些列在“基本角色層”框中的角色。第二遍是用來將這些基礎角色升級為子角色。"
L.help_rolelayering_layers = "每個層中只有一個角色被選中。首先，來自自定義層的角色從第一層開始分配，直到到達最後一層或沒有更多的角色可以被升級。無論哪種情況先發生。如果可升級的槽位仍然可用，未分層的角色也將被分配。"
L.scoreboard_voice_tooltip = "滾動以改變音量"

-- 2021-06-15
L.header_shop_linker = "設置"
L.label_shop_linker_set = "商店的設置"

-- 2021-06-18
L.xfer_team_indicator = "陣營"

-- 2021-06-25
L.searchbar_default_placeholder = "在列表中搜索..."

-- 2021-07-11
--L.spec_about_to_revive = "Spectating is limited during revival period."

-- 2021-09-01
--L.spawneditor_name = "Spawn Editor Tool"
--L.spawneditor_desc = "Used to place weapon, ammo and player spawns in the world. Can only be used by super admin."

--L.spawneditor_place = "Place spawn"
--L.spawneditor_remove = "Remove spawn"
--L.spawneditor_change = "Change spawn type (hold [SHIFT] to reverse)"
--L.spawneditor_ammo_edit = "Hold to edit ammo auto spawn on weapon spawns"

--L.spawn_weapon_random = "Random Weapon Spawn"
--L.spawn_weapon_melee = "Melee Weapon Spawn"
--L.spawn_weapon_nade = "Grenade Weapon Spawn"
--L.spawn_weapon_shotgun = "Shotgun Weapon Spawn"
--L.spawn_weapon_heavy = "Heavy Weapon Spawn"
--L.spawn_weapon_sniper = "Sniper Weapon Spawn"
--L.spawn_weapon_pistol = "Pistol Weapon Spawn"
--L.spawn_weapon_special = "Special Weapon Spawn"
--L.spawn_ammo_random = "Random ammo spawn"
--L.spawn_ammo_deagle = "Deagle ammo spawn"
--L.spawn_ammo_pistol = "Pistol ammo spawn"
--L.spawn_ammo_mac10 = "Mac10 ammo spawn"
--L.spawn_ammo_rifle = "Rifle ammo spawn"
--L.spawn_ammo_shotgun = "Shotgun ammo spawn"
--L.spawn_player_random = "Random player spawn"

--L.spawn_weapon_ammo = " (Ammo: {ammo})"

--L.spawn_weapon_edit_ammo = "Hold [{walkkey}] and press [{primaryfire} or {secondaryfire}] to increase or decrease the ammo for this weapon spawn"

--L.spawn_type_weapon = "This is a weapon spawn"
--L.spawn_type_ammo = "This is an ammunition spawn"
--L.spawn_type_player = "This is a player spawn"

--L.spawn_remove = "Press [{secondaryfire}] to remove this spawn"

--L.submenu_administration_entspawn_title = "Spawn Editor"
--L.header_entspawn_settings = "Spawn Editor Settings"
--L.button_start_entspawn_edit = "Start Spawn Edit"
--L.button_delete_all_spawns = "Delete all Spawns"

--L.label_dynamic_spawns_enable = "Enable dynamic spawns for this map"
--L.label_dynamic_spawns_global_enable = "Enable custom spawns for all maps"

--L.header_equipment_weapon_spawn_setup = "Weapon Spawn Settings"

--L.help_spawn_editor_info = [[
--The spawn editor is used to place, remove and edit spawns in the world. These spawns are for weapons, ammunition and players.

--These spawns are saved in files located in 'data/ttt/weaponspawnscripts/'. They can be deleted for a hard reset. The initial spawn files are created from spawns found on the map and in the original TTT weapon spawn scripts. Pressing the reset button always reverts to this state.

--It should be noted that this spawn system uses dynamic spawns. This is most interesting for weapons because it no longer defines a specific weapon, but a type of weapons. For example instead of a TTT shotgun spawn, there is now a general shotgun spawn where any weapon defined as shotgun can spawn. The spawn type for each weapon can be set in the equipment editor. This makes it possible for any weapon to spawn on the map, or to disable certain default weapons.

--Keep in mind that many changes only take effect after a new round has started.]]
--L.help_spawn_editor_enable = "On some maps it might be advised to use the original spawns found on the map without replacing them with the dynamic system. Disabling this checkbox only disables it for the currently active map. The dynamic system will still be used for every other map."
--L.help_spawn_editor_hint = "Hint: To leave the spawn editor, reopen the gamemode menu."
--L.help_spawn_editor_spawn_amount = [[
--There currently are {weapon} weapon spawns, {ammo} ammunition spawns and {player} player spawns on this map. Click 'start spawn edit' to change this amount.

--{weaponrandom}x Random weapon spawn
--{weaponmelee}x Melee weapon spawn
--{weaponnade}x Grenade weapon spawn
--{weaponshotgun}x Shotgun weapon spawn
--{weaponheavy}x Heavy weapon spawn
--{weaponsniper}x Sniper weapon spawn
--{weaponpistol}x Pistol weapon spawn
--{weaponspecial}x Special weapon spawn

--{ammorandom}x Random ammo spawn
--{ammodeagle}x Deagle ammo spawn
--{ammopistol}x Pistol ammo spawn
--{ammomac10}x Mac10 ammo spawn
--{ammorifle}x Rifle ammo spawn
--{ammoshotgun}x Shotgun ammo spawn

--{playerrandom}x Random player spawn]]

--L.equipmenteditor_name_auto_spawnable = "Equipment spawns randomly in world"
--L.equipmenteditor_name_spawn_type = "Select spawn type"
--L.equipmenteditor_desc_auto_spawnable = [[
--The TTT2 spawn system allows every weapon to spawn in the world. By default only weapons marked as 'AutoSpawnable' by the creator will spawn in the world, however these settings can be changed from within this menu.

--Most of the equipment is set to 'special weapon spawns' by default. This means that equipment only spawns on random weapon spawns. However it is possible to place special weapon spawns in the world or change the spawn type here to use other existing spawn types.]]

--L.pickup_error_inv_cached = "You cannot pick this up right now because your inventory is cached."

-- 2021-09-02
--L.submenu_administration_playermodels_title = "Player Models"
--L.header_playermodels_general = "General Player Model Settings"
--L.header_playermodels_selection = "Select Player Model Pool"

--L.label_enforce_playermodel = "Enforce role player model"
--L.label_use_custom_models = "Use a random selected player model"
--L.label_prefer_map_models = "Prefer map specific models over default models"
--L.label_select_model_per_round = "Select a new random model each round (only on mapchange if disabled)"

--L.help_prefer_map_models = [[
--Some maps define their own player models. By default these models have a higher priority then the models that are automatically assigned. By disabling this setting, map --specific models are disabled.

--Role specific models always have a higher priority and are unaffected by this setting.]]
--L.help_enforce_playermodel = [[
--Some roles have custom player models. This can be disabled which can be relevant for compatibility with some player model selectors.
--Random default models can still be selected, if this setting is disabled.]]
--L.help_use_custom_models = [[
--By default only the CSS Phoenix player model is assigned to all players. By enabling this option however it is possible to select a player model pool. With this setting --enabled each player will still be assigned the same player model, however it is a random model from the defined model pool.

--This selection of models can be extended by installing more player models.]]

-- 2021-10-06
--L.menu_server_addons_title = "Server Addons"
--L.menu_server_addons_description = "Serverwide admin only settings for addons."

--L.tooltip_finish_score_penalty_alive_teammates = "Alive teammates penalty: {score}"
--L.finish_score_penalty_alive_teammates = "Alive teammates penalty:"
--L.tooltip_kill_score_suicide = "Suicide: {score}"
--L.kill_score_suicide = "Suicide:"
--L.tooltip_kill_score_team = "Team kill: {score}"
--L.kill_score_team = "Team kill:"

-- 2021-10-09
--L.help_models_select = [[
--Left click on the models to add them to the player model pool. Left click again to remove them. Right clicking toggles between enabled and disabled detective hats for the focused model.

--The small indicator in the top left shows if the player model has a headshot hitbox. The icon below shows if this model is applicable for a detective hat.]]

--L.menu_roles_title = "Role Settings"
--L.menu_roles_description = "Set up the spawning, equipment credits and more."

--L.submenu_administration_roles_general_title = "General Role Settings"

--L.header_roles_info = "Role Information"
--L.header_roles_selection = "Role Selection Parameters"
--L.header_roles_tbuttons = "Role Traitor Buttons"
--L.header_roles_credits = "Role Equipment Credits"
--L.header_roles_additional = "Additonal Role Settings"
--L.header_roles_reward_credits = "Reward Equipment Credits"

--L.help_roles_default_team = "Default team: {team}"
--L.help_roles_unselectable = "This role is not selectable. This means it is not considered in the role selection. Most of the times this means that this is a role that is manually applied during the round through an event like a revival, a sidekick deagle or something similar."
--L.help_roles_selectable = "This role is selectable. This means if all criteria is met, this role is considered in the role selection process."
--L.help_roles_credits = "Equipment credits are used to buy equipment in the shop. It mostly makes sense to give only those roles that have access to the shop credits. However since it is possible to loot credits from corpses, it could also be an idea to give starting credits to roles as a reward for their killer."
--L.help_roles_selection_short = "The role distribution per player defines the percentage of players that are assigned this role. If for example the value is set to '0.2' every fifth player receives this role."
--L.help_roles_selection = [[
--The role distribution per player defines the percentage of players that are assigned this role. If for example the value is set to '0.2' every fifth player receives this role. This also means that at least 5 players are needed for this role to be selected at all.
--Keep in mind that all of this only applies if the role is considered for selection.

--The aforementioned role distribution has a special integration with the lower limit of players. If the role is considered for selection and the minimum value is below the value given by the distribution factor, but the amount of players is equal or greater than the lower limit, a single player can still receive this role. The distribution setting then holds true again for the second player to receive this role.]]
--L.help_roles_award_info = "Some roles (if enabled in their credits settings) receive equipment credits if a certain percentage of adversaries has died. Those values can be tweaked here."
--L.help_roles_award_pct = "When this percentage of other players are dead, players are awarded more credits."
--L.help_roles_award_repeat = "Whether the credit award is handed out multiple times. If for example you set the percentage to '0.25', and enable this, players will be awarded credits at '25%' killed, '50%' killed, and '75%' killed."
--L.help_roles_advanced_warning = "WARNING: These are advanced settings that can completely mess up your role selection. When in doubt keep all values at '0'. This value means that no limits are applied and the role selection is trying to assign as many roles as possible."
--L.help_roles_max_roles = [[
--The roles category contains every role in TTT2. By default there is no limit on how many different roles can be assigned. However here are two different ways to limit them.

--1. Limit them by a fixed amount.
--2. Limit them by a percentage.

--The latter is only used if the fixed amount is '0' and sets an upper limit based on the set percentage of available players.]]
--L.help_roles_max_baseroles = [[
--Baseroles are only those role others inherit from. For example the Innocent role is a baserole, while a Pharaoh is a sub role of this role. By default there is no limit on how many different baseroles can be assigned. However here are two different ways to limit them.

--1. Limit them by a fixed amount.
--2. Limit them by a percentage.

--The latter is only used if the fixed amount is '0' and sets an upper limit based on the set percentage of available players.]]

--L.label_roles_enabled = "Enable role"
--L.label_roles_min_inno_pct = "Innocent distribution per player"
--L.label_roles_pct = "Role distribution per player"
--L.label_roles_max = "Upper limit of players assigned for this role"
--L.label_roles_random = "Chance this role is selected"
--L.label_roles_min_players = "Lower limit of players to consider selection"
--L.label_roles_tbutton = "Role can use Traitor buttons"
--L.label_roles_credits_starting = "Starting credits"
--L.label_roles_credits_award_pct = "Credit reward percentage"
--L.label_roles_credits_award_size = "Credit reward size"
--L.label_roles_credits_award_repeat = "Credit reward repeat"
--L.label_roles_newroles_enabled = "Enable custom roles"
--L.label_roles_max_roles = "Upper role limit"
--L.label_roles_max_roles_pct = "Upper role limit by percentage"
--L.label_roles_max_baseroles = "Upper baserole limit"
--L.label_roles_max_baseroles_pct = "Upper baserole limit by percentage"
--L.label_detective_hats = "Enable hats for policing roles like the Detective (if player model allows hat)"

--L.ttt2_desc_innocent = "An Innocent has no special abilities. They have to find the evil ones among the terrorists and kill them. But they have to be careful not to kill their fellow team mates."
--L.ttt2_desc_traitor = "The Traitor is the adversary of the innocent. They have an equipment menu with which they are be able to buy special equipment. They have to kill everyone but their team mates."
--L.ttt2_desc_detective = "The Detective is the one whom the Innocents can trust. But who even is an Innocent? The mighty Detective has to find all the evil terrorists. The equipment in their shop may help them with this task."

-- 2021-10-10
--L.button_reset_models = "Reset Player Models"

-- 2021-10-13
--L.help_roles_credits_award_kill = "Another way of gaining credits is by killing high value players with a 'public role' such as a Detective. If the killer's role has this enabled, they gain the below defined amount of credits."
--L.help_roles_credits_award = [[
--There are two different ways to be awarded credits in base TTT2:

--1. If a certain percentage of the enemy team is dead, the whole team is awarded credits.
--2. If a player killed a high value play with a 'public role' such as a Detective, the killer is awarded.

--Please note that this still can be enabled/disabled for every role even if the whole team is awarded. If for example team Innocent is awarded, but the Innocent role has this disabled, only the Detective will receive their credits.
--The balancing values for this feature can be set in 'Administration' -> 'General Role Settings'.]]
--L.help_detective_hats = [[
--Policing roles such as the Detective may wear hats to show their authority. They lose them on death or if damaged at the head.

--Some player models do not support hats by default. You can change this in 'Administration' -> 'Player Models']]

--L.label_roles_credits_award_kill = "Credit reward for kill size"
--L.label_roles_credits_dead_award = "Enable credits award for certain percentage of dead enemies"
--L.label_roles_credits_kill_award = "Enable credits award for high value player kill"
--L.label_roles_min_karma = "Lower limit of Karma to consider selection"

-- 2021-11-07
--L.submenu_administration_administration_title = "Administration"
--L.submenu_administration_voicechat_title = "Voicechat / Textchat"
--L.submenu_administration_round_setup_title = "Round Setup"
--L.submenu_administration_mapentities_title = "Map Entities"
--L.submenu_administration_inventory_title = "Inventory"
--L.submenu_administration_karma_title = "Karma"
--L.submenu_administration_sprint_title = "Sprinting"
--L.submenu_administration_playersettings_title = "Player Settings"

--L.header_roles_special_settings = "Special Role Settings"
--L.header_equipment_additional = "Additional Equipment Settings"
--L.header_administration_general = "General Administrative Settings"
--L.header_administration_logging = "Logging"
--L.header_administration_misc = "Miscellaneous"
--L.header_entspawn_plyspawn = "Player Spawn Settings"
--L.header_voicechat_general = "General Voicechat Settings"
--L.header_voicechat_battery = "Voicechat Battery"
--L.header_voicechat_locational = "Locational Voicechat"
--L.header_playersettings_plyspawn = "Player Spawn Settings"
--L.header_round_setup_prep = "Round: Preparing"
--L.header_round_setup_round = "Round: Active"
--L.header_round_setup_post = "Round: Post"
--L.header_round_setup_map_duration = "Map Session"
--L.header_textchat = "Textchat"
--L.header_round_dead_players = "Dead Player Settings"
--L.header_administration_scoreboard = "Scoreboard Settings"
--L.header_hud_toggleable = "Toggleable HUD Elements"
--L.header_mapentities_prop_possession = "Prop Possession"
--L.header_mapentities_doors = "Doors"
--L.header_karma_tweaking = "Karma Tweaking"
--L.header_karma_kick = "Karma Kick and Ban"
--L.header_karma_logging = "Karma Logging"
--L.header_inventory_gernal = "Inventory Size"
--L.header_inventory_pickup = "Inventory Weapon Pickup"
--L.header_sprint_general = "Sprint Settings"
--L.header_playersettings_armor = "Armor System Settings"

--L.help_killer_dna_range = "When a player is killed by another player a DNA fingerprint is left on their body. The max range convar defines the maximum distance in hammer units for DNA samples to be left. If the killer is further away, then no sample is left at the corpse."
--L.help_killer_dna_basetime = "The basetime in seconds until a DNA sample is decayed. A factor of the squared killer distance is substracted from this basetime."
--L.help_dna_radar = "The TTT2 DNA scanner shows the exact distance and direction of the selected DNA sample if equipped. However, there is also a classic DNA scanner mode that updates the selected sample with an in-world rendering everytime the cooldown has passed."
--L.help_idle = "The idle mode is used to move idle players into a forced spectator mode. To leave this mode again, they have to disable 'enforce spectator mode' in their 'gameplay' settings."
--L.help_namechange_kick = [[
--If a player changes their name during a round, this can be abused to evade being killed. Therefore it is prohibited to change the nickname during an active round.

--If the bantime is greater than 0, the player will be unable to reconnect to the server until that time has passed.]]
--L.help_damage_log = "Each time a player is damaged, a damage log entry is added to the console if enabled. This can also be stored to disk after a round has ended. The file is located at 'data/terrortown/logs/'"
--L.help_spawn_waves = [[
--If this variable is set to 0, all players are spawned at once. For servers with huge amounts of players, it can be beneficial to spawn the players in waves. The spawn wave interval is the time between each spawn wave. A spawn wave always spawns as many players as there are valid spawn points.

--Note: Make sure that the preparing time is long enough for the desired amount of spawn waves.]]
--L.help_voicechat_battery = [[
--Voicechatting with enabled voice chat battery reduces this meter. When it's empty the player can't voicechat and must wait for a few seconds for it to recharge. This can help to prevent excessive voicechat usage.

--Note: 'Tick' refers to a game tick, ie. 1/66th of a second.]]
--L.help_ply_spawn = "Player parameters that are used on player (re-)spawn."
--L.help_haste_mode = [[
--Haste mode balances the game by increasing the round time with every dead player. Only roles that see missing in action players can see the real round time. Every other role can only see the haste mode starting time.

--If haste mode is enabled, the fixed round time is ignored.]]
--L.help_round_limit = "After one of the set limit conditions is met, a mapchange is triggered."
--L.help_armor_balancing = "The following values can be used to balance the armor."
--L.help_item_armor_classic = "If classic armor mode is enabled, only the previous settings matter. Classic armor mode means that a player can only buy armor once in a round and that this armor blocks 30% of the incoming bullet and crowbar damage until they die."
--L.help_item_armor_dynamic = [[
-- Dynamic armor is the TTT2 approach to make armor more interesting. The amount of armor that can be bought is now unlimited and the armor value stacks. Getting damaged decreases the armor value. The armor value per baught armor item is set in the 'Equipment Settings' of said item.

--When taking damage, a certain percentage of this damage is converted into armor damage, a different percentage is still applied to the player and the rest vanishes.

--If reinforced armor is enabled, the damage applied to the player is decreased by 15% as long as the armor value is above the reinforcement threshold.]]
--L.help_sherlock_mode = "The sherlock mode is the classic TTT mode. If the sherlock mode is disabled, dead bodies can not be confirmed, the scoreboard shows everyone as alive and the spectators can talk to the living players."
--L.help_prop_possession = [[
--Prop possession can be used by spectators to possess props lying in the world and use the slowly recharging 'punch-o-meter' to move said prop around.

--The maximum value of the 'punch-o-meter' consists of a possession base value, where the kills/deaths difference clamped inbetween two defined limmits is added. The meter slowly recharges over time. The set recharge time is the time needed to recharge a single point in the 'punch-o-meter'.]]
--L.help_karma = "Karma is used to reduce random killing. Players start with a certain amount of Karma, and lose it when they damage/kill team mates. The amount they lose is dependent on the Karma of the person they hurt or killed. Lower Karma reduces damage given."
--L.help_karma_strict = "If strict Karma is enabled, the damage penalty increases more quickly as Karma goes down. When it is off, the damage penalty is very low when people stay above 800. Enabling strict mode makes Karma play a larger role in discouraging any unnecessary kills, while disabling it results in a more “loose” game where Karma only hurts players who constantly teamkill."
--L.help_karma_max = "Setting the value of the max Karma above 1000 doesn't give a damage bonus to players with more that 1000 Karma. It can be used as a Karma buffer."
--L.help_karma_ratio = "The ratio of the damage that is used to compute how much of the victim's Karma is subtracted from the attacker's if both are in the same team. If a team kill happens, a further penalty is applied."
--L.help_karma_traitordmg_ratio = "The ratio of the damage that is used to compute how much of the victim's Karma is subtracted from the attacker's if both are in different teams. If a team kill happens, a further bonus is applied."
--L.help_karma_bonus = "There are also two different passive ways to gain Karma during a round. First a round heal is applied to every player. Then a secondary clean bonus is given if no teammates were hurt or killed."
--L.help_karma_clean_half = [[
--When a player's Karma is above the starting level (meaning the Karma max has been configured to be higher than that), all their Karma increases will be reduced based on how far their Karma is above that starting level. So it goes up slower the higher it is.

--This reduction goes in a curve of exponential decay: initially it's fast, and it slows down as the increment gets smaller. This convar sets at what point the bonus has been halved (so the half-life). With the default value of 0.25, if a the starting amount of Karma is 1000 and the max 1500, and a player has Karma 1125 ((1500 - 1000) * 0.25 = 125), then his clean round bonus will be 30 / 2 = 15. So to make the bonus go down faster you’d set this convar lower, to make it go down slower you’d increase it towards 1.]]
--L.help_max_slots = "Sets the maximum amount of weapons per slot. '-1' means that there is no limit."
--L.help_item_armor_value = "This is the armor value given by a the armor item in dynamic mode. If classic mode is enabled (see 'Administration' -> 'Player Settings') then every value greater than 0 is counted as existing armor."

--L.label_killer_dna_range = "Max kill range to leave DNA"
--L.label_killer_dna_basetime = "Sample life base time"
--L.label_dna_scanner_slots = "DNA sample slots"
--L.label_dna_radar = "Enable classic DNA scanner mode"
--L.label_dna_radar_cooldown = "DNA scanner cooldown"
--L.label_radar_charge_time = "Recharge time after a radar sample"
--L.label_crowbar_shove_delay = "Cooldown after crowbar push"
--L.label_idle = "Enable idle mode"
--L.label_idle_limit = "Maximal idle time in seconds"
--L.label_namechange_kick = "Enable name change kick"
--L.label_namechange_bantime = "Banned time in minutes after kick"
--L.label_log_damage_for_console = "Enable damage logging in console"
--L.label_damagelog_save = "Save damage log to disk"
--L.label_debug_preventwin = "Prevent any win condition [debug]"
--L.label_bots_are_spectators = "Bots are always spectators"
--L.label_tbutton_admin_show = "Show traitor buttons to admins"
--L.label_ragdoll_carrying = "Enable ragdoll carrying"
--L.label_prop_throwing = "Enable prop throwing"
--L.label_ragdoll_pinning = "Enable ragdoll pinning for non-Innocent roles"
--L.label_ragdoll_pinning_innocents = "Enable ragdoll pinning for Innocent roles"
--L.label_weapon_carrying = "Enable weapon carrying"
--L.label_weapon_carrying_range = "Weapon carry range"
--L.label_prop_carrying_force = "Prop pickup force"
--L.label_teleport_telefrags = "Kill blocking player(s) when teleporting (telefrag)"
--L.label_allow_discomb_jump = "Allow disco jump for grenade thrower"
--L.label_spawn_wave_interval = "Spawn wave interval in seconds"
--L.label_voice_enable = "Enable voicechat"
--L.label_voice_drain = "Enable the voicechat battery feature"
--L.label_voice_drain_normal = "Drain per tick for normal players"
--L.label_voice_drain_admin = "Drain per tick for admins and public policing roles"
--L.label_voice_drain_recharge = "Recharge rate per tick of not voicechatting"
--L.label_locational_voice = "Enable locational 3D voicechat sound for living players"
--L.label_armor_on_spawn = "Player armor on (re-)spawn"
--L.label_prep_respawn = "Enable instant respawn during preparing phase"
--L.label_preptime_seconds = "Preparing time in seconds"
--L.label_firstpreptime_seconds = "First preparing time in seconds"
--L.label_roundtime_minutes = "Fixed round time in minutes"
--L.label_haste = "Enable haste mode"
--L.label_haste_starting_minutes = "Haste mode starting time in minutes"
--L.label_haste_minutes_per_death = "Haste reward in minutes per death"
--L.label_posttime_seconds = "Postround time in seconds"
--L.label_round_limit = "Upper limit of rounds"
--L.label_time_limit_minutes = "Upper limit of playtime in minutes"
--L.label_nade_throw_during_prep = "Enable nade throwing during preparing time"
--L.label_postround_dm = "Enable deathmatch after round ended"
--L.label_spectator_chat = "Enable spectators chatting with everybody"
--L.label_lastwords_chatprint = "Print last words to chat if killed while typing"
--L.label_identify_body_woconfirm = "Identify corpse without pressing the 'confirm' button"
--L.label_announce_body_found = "Announce that a body was found"
--L.label_confirm_killlist = "Announce kill list of confirmed corpse"
--L.label_inspect_detective_only = "Limit corpse inspection to policing roles"
--L.label_confirm_detective_only = "Limit corpse confirmation to policing roles"
--L.label_dyingshot = "Shoot on death if in ironsights [experimental]"
--L.label_armor_block_headshots = "Enable armor blocking headshots"
--L.label_armor_block_blastdmg = "Enable armor blocking blast damage"
--L.label_armor_dynamic = "Enable dynamic armor"
--L.label_armor_value = "Armor given by the armor item"
--L.label_armor_damage_block_pct = "Damage percentage taken by armor"
--L.label_armor_damage_health_pct = "Damage percentage taken by player"
--L.label_armor_enable_reinforced = "Enable reinforced armor"
--L.label_armor_threshold_for_reinforced = "Reinforced armor threshold"
--L.label_sherlock_mode = "Enable sherlock mode"
--L.label_highlight_admins = "Highlight server admins"
--L.label_highlight_dev = "Highlight TTT2 developer"
--L.label_highlight_vip = "Highlight VIP"
--L.label_highlight_addondev = "Highlight TTT2 addon developer"
--L.label_highlight_supporter = "Highlight other supporters"
--L.label_enable_hud_element = "Enable {elem} HUD element"
--L.label_spec_prop_control = "Enable prop possession"
--L.label_spec_prop_base = "Possession base value"
--L.label_spec_prop_maxpenalty = "Lower possession bonus limit"
--L.label_spec_prop_maxbonus = "Upper possession bonus limit"
--L.label_spec_prop_force = "Possession push force"
--L.label_spec_prop_rechargetime = "Recharge time in seconds"
--L.label_doors_force_pairs = "Force close-by doors as double doors"
--L.label_doors_destructible = "Enable destructible doors"
--L.label_doors_locked_indestructible = "Initially locked doors are indestructible"
--L.label_doors_health = "Door health"
--L.label_doors_prop_health = "Door prop health"
--L.label_minimum_players = "Minimum player amount to start round"
--L.label_karma = "Enable Karma"
--L.label_karma_strict = "Enable strict Karma"
--L.label_karma_starting = "Starting Karma"
--L.label_karma_max = "Maximum Karma"
--L.label_karma_ratio = "Penalty ratio for team damage"
--L.label_karma_kill_penalty = "Kill penalty for team kill"
--L.label_karma_round_increment = "Round heal"
--L.label_karma_clean_bonus = "Clean round bonus"
--L.label_karma_traitordmg_ratio = "Bonus ratio for other team damage"
--L.label_karma_traitorkill_bonus = "Kill bonus for other team kill"
--L.label_karma_clean_half = "Clean bonus reduction"
--L.label_karma_persist = "Karma persists over map changes"
--L.label_karma_low_autokick = "Automatically kick players with low Karma"
--L.label_karma_low_amount = "Low Karma threshold"
--L.label_karma_low_ban = "Ban picked players with low Karma"
--L.label_karma_low_ban_minutes = "Ban time in minutes"
--L.label_karma_debugspam = "Enable debug output to console about Karma changes"
--L.label_max_melee_slots = "Max melee slots"
--L.label_max_secondary_slots = "Max secondary slots"
--L.label_max_primary_slots = "Max primary slots"
--L.label_max_nade_slots = "Max nade slots"
--L.label_max_carry_slots = "Max carry slots"
--L.label_max_unarmed_slots = "Max unarmed slots"
--L.label_max_special_slots = "Max special slots"
--L.label_max_extra_slots = "Max extra slots"
--L.label_weapon_autopickup = "Enable automatic weapon pickup"
--L.label_sprint_enabled = "Enable sprinting"
--L.label_sprint_max = "Max sprinting stamina"
--L.label_sprint_stamina_consumption = "Stamina consumtion factor"
--L.label_sprint_stamina_regeneration = "Stamina regeneration factor"
--L.label_sprint_crosshair = "Show crosshair while sprinting"
--L.label_crowbar_unlocks = "Primary attack can be used as interaction (i.e. unlocking)"
--L.label_crowbar_pushforce = "Crowbar push force"
