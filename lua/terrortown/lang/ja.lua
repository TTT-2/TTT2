-- Japanese language strings

local L = LANG.CreateLanguage("ja")

-- Compatibility language name that might be removed soon.
-- the alias name is based on the original TTT language name:
-- https://github.com/Facepunch/garrysmod/blob/master/garrysmod/gamemodes/terrortown/gamemode/lang/japanese.lua
L.__alias = "日本語"

L.lang_name = "日本語 (Japanese)"

-- General text used in various places
L.traitor = "Traitor"
L.detective = "Detective"
L.innocent = "Innocent"
L.last_words = "遺言"

L.terrorists = "テロリスト"
L.spectators = "観戦者"

L.nones = "無所属"
L.innocents = "Innocent陣営"
L.traitors = "Traitor陣営"

-- Round status messages
L.round_minplayers = "ラウンドを開始するのに必要なプレイヤーがいないようだ…"
L.round_voting = "投票中のため、{num}秒まで新しいラウンドを延期中…"
L.round_begintime = "{num}秒内にラウンドを開始する。早めに準備をしよう。"
L.round_selected = "Traitor選択完了。"
L.round_started = "ラウンド開始！"
L.round_restart = "ラウンドは管理者によってリスタートされたようだ。"

L.round_traitors_one = "Traitorよ、一人でも頑張るんだ。"
L.round_traitors_more = "Traitorよ、仲間は{names}だ。"

L.win_time = "時間切れ。Traitorの負けだ。"
L.win_traitors = "Traitorの勝利！"
L.win_innocents = "Innocentの勝利！"
L.win_nones = "引き分け！"
L.win_showreport = "さあ{num}秒の間ラウンドレポートを見てみよう。"

L.limit_round = "ラウンドリミットに達した。もうすぐロードされるだろう。"
L.limit_time = "タイムリミットに達した。もうすぐロードされるだろう。"
L.limit_left = "マップ変更するまで{num}ラウンドないし{time}分残っている。"

-- Credit awards
L.credit_all = "任務遂行により、{num}個のクレジットを受け取った。"
L.credit_kill = "{role}を始末したため{num}クレジットを受け取った。"

-- Karma
L.karma_dmg_full = "今のカルマは{amount}なので、与えられるダメージは通常だ。"
L.karma_dmg_other = "今のカルマは{amount}なので、与えられるダメージは{num}%減少してしまった。"

-- Body identification messages
L.body_found = "{finder}は{victim}の死体を見つけた. {role}"
L.body_found_team = "{finder}は{victim}の死体を見つけた. {role} ({team})"

-- The {role} in body_found will be replaced by one of the following:
L.body_found_traitor = "奴はTraitorだったな！"
L.body_found_det = "奴はDetectiveだったようだ…"
L.body_found_inno = "奴はInnocentだったようだ…"

L.body_confirm = "{finder}は{victim}の死を確認した。"

L.body_call = "{player}はDetectiveを{victim}の死体の場所に呼んだ！"
L.body_call_error = "Detectiveを呼ぶ前にこのプレイヤーの死の確認が必要だ！"

L.body_burning = "熱っ！この死体は燃えてるぞ！"
L.body_credits = "死体から{num}クレジットを拾った！"

-- Menus and windows
L.close = "閉じる"
L.cancel = "キャンセル"

-- For navigation buttons
L.next = "次へ"
L.prev = "前へ"

-- Equipment buying menu
L.equip_title = "アイテム"
L.equip_tabtitle = "アイテム購入"

L.equip_status = "注文状況"
L.equip_cost = "残り{num}クレジット"
L.equip_help_cost = "いずれの装備も購入費用は１クレジットだ（設定でクレジット消費数を設定できる）。"

L.equip_help_carry = "自分が所持してないものだけだけ買うことができるぞ。"
L.equip_carry = "この装備は持つことが可能だ。"
L.equip_carry_own = "既にこのアイテムを持っているぞ。"
L.equip_carry_slot = "既にスロット{slot}の武器を持っているぞ。"
L.equip_carry_minplayers = "この武器を使うためには今のゲーム内の最大人数を満たすまでは使えないようだ。"

L.equip_help_stock = "いくつかのアイテムはラウンド毎に1つしか買えない。"
L.equip_stock_deny = "このアイテムはもう在庫がない。"
L.equip_stock_ok = "このアイテムはまだ在庫がある。"

L.equip_custom = "このサーバーにカスタムアイテムを追加した。"

L.equip_spec_name = "名前"
L.equip_spec_type = "種類"
L.equip_spec_desc = "説明"

L.equip_confirm = "装備品購入"

-- Disguiser tab in equipment menu
L.disg_name = "変装装置"
L.disg_menutitle = "変装メニュー"
L.disg_not_owned = "変装装置はまだ持っていないぞ！"
L.disg_enable = "変装を有効にする"

L.disg_help1 = "変装している時、誰かがあなたを見てもあなたの名前、体力とカルマは表示されない。また、Detectiveのレーダーにも反応されないだろう。"
L.disg_help2 = "テンキーのEnterを押すとCキーからのメニューを使用せずに変装を切り替えできる。 開発者コンソールで「ttt_toggle_disguise」を異なるキーに割り当てることが可能。"

-- Radar tab in equipment menu
L.radar_name = "レーダー"
L.radar_menutitle = "レーダーメニュー"
L.radar_not_owned = "レーダーはまだ持っていないぞ！"
L.radar_scan = "スキャンを実行。"
L.radar_auto = "自動で繰り返し実行。"
L.radar_help = "スキャン結果を{num}秒間表示し、その後レーダーは再び新しい位置を教えてくれる。"
L.radar_charging = "レーダーチャージ中..."

-- Transfer tab in equipment menu
L.xfer_name = "譲渡"
L.xfer_menutitle = "クレジット譲渡"
L.xfer_send = "クレジット送信"

L.xfer_no_recip = "受取人が妥当ではないのでクレジットの移動は中断された。"
L.xfer_no_credits = "渡すクレジットが不足している。"
L.xfer_success = "クレジットの{player}への受け渡しを完了した。"
L.xfer_received = "{player}はあなたに{num}クレジットを渡した。"

-- Radio tab in equipment menu
L.radio_name = "ラジオ"
L.radio_help = "音を再生するためにボタンをクリックしよう。"
L.radio_notplaced = "再生するためにはラジオを置かなくてはならないぞ。"

-- Radio soundboard buttons
L.radio_button_scream = "悲鳴"
L.radio_button_expl = "爆発音"
L.radio_button_pistol = "Pistol発砲音"
L.radio_button_m16 = "M16発砲音"
L.radio_button_deagle = "Deagle発砲音"
L.radio_button_mac10 = "MAC10発砲音"
L.radio_button_shotgun = "Shotgun発砲音"
L.radio_button_rifle = "Rifle発砲音"
L.radio_button_huge = "H.U.G.E発砲音"
L.radio_button_c4 = "C4警告音"
L.radio_button_burn = "燃焼音"
L.radio_button_steps = "足音"

-- Intro screen shown after joining
L.intro_help = "このゲームは始めてかな？F1を押すとインストラクションを見れるぞ！"

-- Radiocommands/quickchat
L.quick_title = "クイックチャットキー"

L.quick_yes = "そうだ。"
L.quick_no = "違う。"
L.quick_help = "助けてくれ！"
L.quick_imwith = "{player}と一緒にいるぞ。"
L.quick_see = "{player}を監視中だ。"
L.quick_suspect = "{player}が怪しい動きをしているぞ。"
L.quick_traitor = "{player}がTraitorだ！"
L.quick_inno = "{player}はInnocentだな。"
L.quick_check = "まだ生きている奴はいるか？"

-- {player} in the quickchat text normally becomes a player nickname, but can
-- also be one of the below. Keep these lowercase.
L.quick_nobody = "いない奴"
L.quick_disg = "変装中"
L.quick_corpse = "死体"
L.quick_corpse_id = "{player}の死体"

-- Body search window
L.search_title = "調査結果"
L.search_info = "情報"
L.search_confirm = "確認済み"
L.search_call = "探偵を呼ぶ"

-- Descriptions of pieces of information found
L.search_nick = "こいつは{player}の死体だ。"

L.search_role_traitor = "こいつはTraitorだったな！"
L.search_role_det = "こいつはDetectiveだった。"
L.search_role_inno = "こいつはInnocentだった。"

L.search_words = "遺言'{lastwords}'"
L.search_armor = "ボディアーマーを着ていたようだ。"
L.search_disg = "変装をしていたようだ。"
L.search_radar = "レーダーを所持していたようだ。もう機能していないがな。"
L.search_c4 = "ポケットからメモを見つけた。それには'爆弾を解除するには{num}番のワイヤーをカットしろ'と書かれている。"

L.search_dmg_crush = "こいつの骨の多くが折れている。重たい物でもぶつかって死んだようだ。"
L.search_dmg_bullet = "こいつは撃たれて死んだようだな。"
L.search_dmg_fall = "こいつは転落死したようだな。"
L.search_dmg_boom = "こいつの傷と焼けた衣服から見ると、爆発で死んだように思えるな。"
L.search_dmg_club = "死体には打撲傷と殴られた跡がある。殴られて死んだようだな。"
L.search_dmg_drown = "死因は溺死のようだ。"
L.search_dmg_stab = "こいつは刃物に刺されて出血死したようだ。。"
L.search_dmg_burn = "この辺りにはテロリストが焼けたような臭いがするな..."
L.search_dmg_tele = "こいつのDNAはタキオン粒子の放出によってかき混ぜられたように見えるな。"
L.search_dmg_car = "このテロリストが道路を渡った際、野蛮なドライバーにでも轢かれたのか。"
L.search_dmg_other = "このテロリストの死因を特定できない。"

L.search_weapon = "{weapon}によって殺されたようだな。"
L.search_head = "致命的な傷はヘッドショットによるものだ。 叫ぶ間も無い。"
L.search_time = "こいつは調査のおおよそ{time}秒前に死んだな。"
L.search_dna = "裏切り者のDNAサンプルをDNAスキャナーで回収しなくては。DNAサンプルは今からおおよそ{time}秒で腐敗するだろう。"

L.search_kills1 = "{player}の死を立証する殺害リストを見つけた。"
L.search_kills2 = "これらの名前の載った殺害リストを見つけた:"
L.search_eyes = "探偵スキルを使用し、こいつの見た最後の人物を確認した: {player}. 裏切り者か、それとも偶然か？"

-- Scoreboard
L.sb_playing = "サーバー名"
L.sb_mapchange = "マップ変更まで{num}ラウンドか{time}秒"

L.sb_mia = "行方不明"
L.sb_confirmed = "死亡確認"

L.sb_ping = "ピング値"
L.sb_deaths = "死亡回数"
L.sb_score = "スコア"
L.sb_karma = "カルマ"

L.sb_info_help = "このプレイヤーの死体を調査すると、ここで結果を精査することができるぞ。"

L.sb_tag_friend = "仲間"
L.sb_tag_susp = "容疑者"
L.sb_tag_avoid = "避けたい者"
L.sb_tag_kill = "殺害対象"
L.sb_tag_miss = "行方不明"

-- Equipment actions, like buying and dropping
L.buy_no_stock = "この武器は品切れだ: 既にこのラウンドで購入済みだ。"
L.buy_pending = "既に注文されている、受け取りまで待とう。"
L.buy_received = "特殊装備を受け取った。"

L.drop_no_room = "空きが無いから武器を捨てるしかない。"

L.disg_turned_on = "変装完了。"
L.disg_turned_off = "変装解除。"

-- Equipment item descriptions
L.item_passive = "パッシブ効果アイテム"
L.item_active = "使用アイテム"
L.item_weapon = "武器"

L.item_armor = "Body Armor(ボディアーマー)"
L.item_armor_desc = [[
弾丸、炎、爆発によるダメージを軽減。延長時間になったら使い物にならない。
複数の購入が可能。ある特定の装甲値に達した後、アーマーは強化される。]]

L.item_radar = "Radar(レーダー)"
L.item_radar_desc = [[
生命反応を捉えることができる。

購入するとすぐに自動で探知してくれる。 設定はCキーのレーダーメニューから。]]

L.item_disg = "Disguiser(変装装置)"
L.item_disg_desc = [[
変装中はあなたのID情報を隠せます。 さらに、
獲物が最期に目撃した人物になるのも避けれます。
このメニューの変装メニュー内かテンキーのEnterで切り替え。]]

-- C4
L.c4_hint = "{usekey}を押して起動もしくは解除"
L.c4_disarm_warn = "C4が解除されてしまった。"
L.c4_armed = "爆弾は起動完了だ。"
L.c4_disarmed = "爆弾の解除に成功した。"
L.c4_no_room = "こんな狭い所ではC4は持てないぞ。"

L.c4_desc = "強力な時限爆弾。"

L.c4_arm = "C4起動"
L.c4_arm_timer = "時間"
L.c4_arm_seconds = "爆発まで:"
L.c4_arm_attempts = "解除を試みる際、６本のワイヤーの内{num}本はカットしてしまうと即爆発するので要注意だ。"

L.c4_remove_title = "撤去"
L.c4_remove_pickup = "C4を拾う"
L.c4_remove_destroy1 = "C4を破壊する"
L.c4_remove_destroy2 = "確認:破壊"

L.c4_disarm = "C4を解除"
L.c4_disarm_cut = "クリックして{num}本目のワイヤーを切断する"

L.c4_disarm_owned = "ワイヤーをカットして爆弾を解除してくれ。自分の爆弾だからどのワイヤーでも安全だ。"
L.c4_disarm_other = "安全なワイヤーをカットして爆弾を解除するんだ。間違えたら即爆発だ！"

L.c4_status_armed = "起動中"
L.c4_status_disarmed = "解除済み"

-- Visualizer
L.vis_name = "Visualizer(可視化装置)"
L.vis_hint = "{usekey}で拾う（探偵のみ）"

L.vis_desc = [[
殺害現場を可視化してくれる機械。
死体を分析して被害者がどのように殺害されたかを表示しますが、
被害者が銃撃の傷で死亡した場合のみ。]]

-- Decoy
L.decoy_name = "Decoy(デコイ)"
L.decoy_no_room = "この狭い所ではデコイは持てないようだ。"
L.decoy_broken = "デコイが破壊された！"

L.decoy_short_desc = "このデコイは別陣営のレーダーに偽のレーダー反応を示してくれるぞ。"
L.decoy_pickup_wrong_team = "別陣営からのデコイを拾うことはできないぞ。"

L.decoy_desc = [[
Detectiveに偽のレーダー反応を表示させ、彼らがあなたのDNAをスキャンしていた場合は彼らのDNAスキャナーがデコイの場所を表示するようにしてくれる。]]

-- Defuser
L.defuser_name = "Defuser(除去装置)"
L.defuser_help = "{primaryfire}でC4除去"

L.defuser_desc = [[
C4爆弾を即座に除去する。
使用回数は無制限。
これさえ持っていればC4に気がつくのに容易でしょう。]]

-- Flare gun
L.flare_name = "Flare Gun(信号拳銃)"

L.flare_desc = [[
死体を燃やすことができる拳銃。証拠隠滅に必須。
弾は限られているので注意。
燃えている死体からは大きな燃焼音を発するので注意。]]

-- Health station
L.hstation_name = "Health Station(回復ステーション)"

L.hstation_broken = "回復ステーションが破壊された！"
L.hstation_help = "{primaryfire}で回復ステーション設置"

L.hstation_desc = [[
回復が可能な設置型の機械。チャージは遅く、
誰でも使用することができますが、耐久力があるので注意。
使用者のDNAサンプルをチェックすることができます。]]

-- Knife
L.knife_name = "Knife(ナイフ)"
L.knife_thrown = "ナイフ投擲"

L.knife_desc = [[
怪我した者なら即座に静かに始末できますが、
一度しか使用できません。
オルトファイアで投擲できます。]]

-- Poltergeist
L.polter_desc = [[
オブジェクトにThumperを設置すると、
使用者の意志に関係なくそのオブジェクトが暴れまわり、
暴れ終わった後のThumperの爆発は近くの人間にダメージを与えます。]]

-- Radio
L.radio_broken = "ラジオが破壊された！"
L.radio_help_pri = "{primaryfire}でラジオを置く"

L.radio_desc = [[
注意を逸らしたり欺くために音を再生できる機械。
どこか適当な場所にラジオを置いてから、
ショップメニュー内のラジオメニューから音を再生できます。]]

-- Silenced pistol
L.sipistol_name = "Silenced Pistol(消音ピストル)"

L.sipistol_desc = [[
サプレッサー付きのハンドガン。通常のピストルの弾丸を使用する。
撃たれた犠牲者は悲鳴をあげることはないだろう。]]

-- Newton launcher
L.newton_name = "Newton Launcher(ニュートンランチャー)"

L.newton_desc = [[
遠距離からでも人を弾き飛ばせる弾を発射する。
弾は無制限だが、次の弾を発射するのに時間がかかる。]]

-- Binoculars
L.binoc_name = "Binoculars(双眼鏡)"

L.binoc_desc = [[
遠く離れた距離から死体まで拡大し、確認することができる。
無制限で使用できる、確認するのに数秒かかる。]]

-- UMP
L.ump_desc = [[
ターゲットを混乱させる強力なSMG。

SMG弾を使用する。]]

-- DNA scanner
L.dna_name = "DNAスキャナー"
L.dna_notfound = "DNAサンプルは見つからなかった。"
L.dna_limit = "容器は限界に達した。古いサンプルを捨てて新しいのを加えるんだ。"
L.dna_decayed = "殺害者のDNAサンプルは腐っていたようだ。"
L.dna_killer = "死体から殺害者のDNAサンプルを入手した！"
L.dna_duplicate = "一致した！スキャナーにこのDNAが登録されたぞ。"
L.dna_no_killer = "DNAは回収されることができないようだ (殺害者はゲームを退出したんだろうか?)."
L.dna_armed = "この爆弾は稼働中だ！早く解除するんだ！"
L.dna_object = "オブジェクトから{num}個の新しいDNAサンプルを入手した。"
L.dna_gone = "このエリアにDNA反応はないようだ。"

L.dna_desc = [[
物からDNAサンプルを入手しそれらを使用してDNAの持ち主を探せる。

確認後の死体のみに使用でき、殺害者のDNAを入手して彼らを追跡できる。]]

-- Magneto stick
L.magnet_name = "マグネットスティック"
L.magnet_help = "{primaryfire}で死体を貼り付ける"

-- Grenades and misc
L.grenade_smoke = "発煙弾"
L.grenade_fire = "焼夷手榴弾"

L.unarmed_name = "無防備"
L.crowbar_name = "バール"
L.pistol_name = "ピストル"
L.rifle_name = "スナイパーライフル"
L.shotgun_name = "ショットガン"

-- Teleporter
L.tele_name = "Teleporter(テレポーター)"
L.tele_failed = "テレポートに失敗した。"
L.tele_marked = "テレポート位置を設定した。"

L.tele_no_ground = "安定した足場に立つまではテレポートはできないぞ！"
L.tele_no_crouch = "しゃがんでいるとテレポートはできないぞ！"
L.tele_no_mark = "設定した場所がないようだ。テレポートする前に移動先を設定するんだ。"

L.tele_no_mark_ground = "安定した足場に立つまではテレポート位置を設定することはできないぞ！"
L.tele_no_mark_crouch = "しゃがんでいるとテレポート位置を設定することができないぞ！"

L.tele_help_pri = "左クリックで設定した場所にテレポート"
L.tele_help_sec = "右クリックで現在地を設定"

L.tele_desc = [[
あらかじめ設定した地点にテレポートができる。

テレポートはノイズを発し、使用回数は限られている。]]

-- Ammo names, shown when picked up
L.ammo_pistol = "9mm弾"

L.ammo_smg1 = "SMG弾"
L.ammo_buckshot = "バックショット"
L.ammo_357 = "ライフル弾"
L.ammo_alyxgun = "マグナム弾"
L.ammo_ar2altfire = "火炎弾"
L.ammo_gravity = "重力弾"

-- Round status
L.round_wait = "プレイヤー待機中"
L.round_prep = "ラウンド準備中"
L.round_active = "ラウンド進行中"
L.round_post = "ラウンド終了"

-- Health, ammo and time area
L.overtime = "延長時間"
L.hastemode = "残り時間"

-- TargetID health status
L.hp_healthy = "無傷"
L.hp_hurt = "苦痛"
L.hp_wounded = "怪我"
L.hp_badwnd = "重傷"
L.hp_death = "瀕死"

-- TargetID karma status
L.karma_max = "安全"
L.karma_high = "粗野"
L.karma_med = "トリガーハッピー"
L.karma_low = "危険"
L.karma_min = "どうしようもない"

-- TargetID misc
L.corpse = "死体"
L.corpse_hint = "{usekey}を押して調査。{walkkey} + {usekey}で密かに調査。"

L.target_disg = "(変装中)"
L.target_unid = "誰かの死体"
L.target_unknown = "テロリスト"

L.target_credits = "調べて未使用クレジットを入手する"

-- HUD buttons with hand icons that only some roles can see and use
L.tbut_single = "一度きり"
L.tbut_reuse = "再使用可能"
L.tbut_retime = "{num}秒後に再使用可能"
L.tbut_help = "[{usekey}]を押して起動"

-- Spectator muting of living/dead
L.mute_living = "生存者をミュートした"
L.mute_specs = "観戦者をミュートした"
L.mute_all = "全てをミュートした"
L.mute_off = "ミュートを解除した"

-- Spectators and prop possession
L.punch_title = "パンチ・オー・メーター"
L.punch_help = "移動キーもしくはジャンプ:オブジェクト移動。しゃがみ:オブジェクトを離れる。"
L.punch_bonus = "スコアが低かったため、パンチ・オー・メーターの最大値が{num}下がった。"
L.punch_malus = "スコアが高かったため、パンチ・オー・メーターの最大値が{num}上がった！"

-- Info popups shown when the round starts
L.info_popup_innocent = [[
あなたは無実のテロリスト、Innocentだ！だが周囲にはTraitor（裏切り者）が...
あなたは誰を信用し、誰があなたを蜂の巣にするのだろうな？

背中に注意し信頼関係を築き生き延びよう！]]

L.info_popup_detective = [[
あなたは探偵だ！テロリストの本部はTraitor（裏切り者）を見つけるためにあなたに特別な力を与えた。
それらを使用しInnocent達の生存を手助けしよう、でも気をつけろ:
Traitorは真っ先にあなたを始末しようと殺意を向けているぞ！

{menukey}を押して装備を受け取るんだ！]]

L.info_popup_traitor_alone = [[
あなたはTraitor（裏切り者）だ！このラウンドでは仲間はいないようだ。

自分以外の全員始末すれば勝利だ！

{menukey}を押して特別な装備を受け取るんだ！]]

L.info_popup_traitor = [[
あなたはTraitor（裏切り者）だ！他者を全て始末するために仲間と共に協力するんだ。
だが気をつけろ、あなたの裏切り行為はバレるかもしれないぞ...

仲間達:
{traitorlist}

{menukey}を押して特別な装備を受け取るんだ！]]

-- Various other text
L.name_kick = "プレイヤーはラウンド中に名前を変更したため自動的にKickされた。"

L.idle_popup = [[
あなたは{num}秒間放置状態だったので強制的に観戦者モードに移動させられた。このモードでいる間、あなたは新しいラウンドが始まった時に参加はできない。

{helpkey}を押して設定タブでボックスのチェックを外すことでいつでも観戦者モードを切り替えることができる。今すぐに無効を選ぶこともできるぞ。]]

L.idle_popup_close = "何もしない"
L.idle_popup_off = "観戦者モード無効化"

L.idle_warning = "注意:あなたが放置状態かAFKに見えると、あなたが動きを示すまで観戦にされるぞ！"

L.spec_mode_warning = "あなたは観戦者モードなのでラウンド開始時に参加できなかった。このモードを無効にするにはF1を押して設定タブで「観戦者モード」のチェックを外そう。"

-- Tips panel
L.tips_panel_title = "ヒント"
L.tips_panel_tip = "ヒント:"

-- Tip texts
L.tip1 = "Traitorは死体に対し{walkkey}を押しながら{usekey}を押すことにより死亡を確認することなく,静かに死体を調べることができます."

L.tip2 = "タイマーを長くしてC4爆弾を起動するとInnocentが解除を試みる際に即座に爆発するワイヤーの本数が増えます.　しばしば警告音も静かにかつ少なくなります."

L.tip3 = "Detectiveは死体を探ってその人の'瞳に映された'者を知ることができます. これは死んだ者の見た最後の人物です. 被害者が後ろから撃たれていたのならその人物を殺害者と決め付けるのは早計です."

L.tip4 = "あなたの死体を発見し, 調査して確認するまではあなたの死は誰にもわかりません."

L.tip5 = "TraitorがDetectiveを始末すると, 即座にクレジットの報酬を受け取ります."

L.tip6 = "Traitorが死亡すると, 全てのDetectiveはクレジットの報酬を獲得します."

L.tip7 = "TraitorはInnocentの始末を大きく進展させた際, 報酬としてクレジットを受け取ります."

L.tip8 = "TraitorとDetectiveは他のTraitorやDetectiveの死体から未使用クレジットを入手することができます."

L.tip9 = "Poltergeistは物理オブジェクトを危険な発射物に変えることができます. 各衝撃は近くにいる者を傷つけるエネルギー波が同時に生じます."

L.tip10 = "TraitorとDetectiveは右上の赤いメッセージを見逃さないでください. それらはあなたにとって重要でしょうから."

L.tip11 = "TraitorとDetectiveは覚えておいてください, あなたはあなたと仲間がうまく働けば追加クレジットの報酬を与えられます. 必ずそのクレジットを使うのを忘れないでくださいね!"

L.tip12 = "DetectiveのDNA scannerは武器とアイテムからDNAサンプルを集めることができるようになり, そしてスキャンでそのプレイヤーの居場所を捕捉します. 死体や解除したC4からサンプルを入手できて便利ですよ!"

L.tip13 = "あなたが始末した相手の近くにいる時, あなたのDNAのいくつかは死体に残されています. そのDNAはDetectiveのDNA scannerであなたの居場所を見つけるのに使用されることがあります. ナイフで始末した後は死体を隠蔽すると良いでしょう!"

L.tip14 = "あなたが始末した相手から遠くに離れるにつれ, 死体に付着したあなたのDNAサンプルはより早く腐敗するでしょう."

L.tip15 = "あなたはTraitorで, スナイプしようとしていますか? Disguiserを試してみることを検討してください. もし外しても, 安全な場所に逃げ, Disguiserを解除すれば撃ったのがあなただと気付く者はいないでしょう."

L.tip16 = "Teleporterは追跡されている時にTraitorのあなたの逃走を手助けし, 大きなマップを素早く渡り歩くことができるようにします. 必ず常に安全な場所にマークしましょう."

L.tip17 = "Innocentが皆集まっていて孤立させるのは難しいですか? 何人かを引き離すためにRadioでC4の音か銃撃音の再生を試みることを検討してみてください."

L.tip18 = "TraitorがRadioを使用するには, Radioが置かれた後に装備メニューから音を再生することができます. 複数の音を再生したい場合はそこから複数のボタンをクリックして複数の音のキューを作ってください."

L.tip19 = "Detectiveは, もしクレジットが余っているのなら信頼できるInnocentにDefuserを渡してしまってもかまいません. そうすればあなたは調査の方に時間を費やし, 爆弾の解除からは離れることができます."

L.tip20 = "DetectiveのBinocularsは長距離を調べ死体の確認をできるようになります. 悪いお知らせはTraitorが死体を餌として使用したいと思っていた場合です. 当然, Binoculars使用中のDetectiveは無防備で注意散漫ですから..."

L.tip21 = "DetectiveのHealth Stationは負傷したプレイヤーを回復させます. もちろん, それらの負傷した人はTraitorかもしれないですけどね..."

L.tip22 = "Health Stationは使用した全員のDNAサンプルを記録します. DetectiveはDNA scannerでそれを使用して, 回復している人を知ることができます."

L.tip23 = "武器やC4と違い, Radioは置いたTraitorのDNAサンプルを含めません. Detectiveがそれを見つけて避難場所を吹き飛ばすことを心配する必要はありません."

L.tip24 = "{helpkey}を押すと短いチュートリアルの表示とTTTの詳細な設定を変更できます. 例えば, このTIPSを永久に非表示にもできます."

L.tip25 = "Detectiveが死体を調査すると, 結果はスコアボードで死亡した人の名前をクリックすることにより全てのプレイヤーが確認できます."

L.tip26 = "スコアボードの誰かの名前のすぐ近くの虫眼鏡アイコンはあなたがその人物の情報を調査したことを示しています. アイコンが明るければ, データはDetectiveからの追加の情報が含まれているかもしれません. "

L.tip27 = "Detectiveは, Detectiveによって調査されたニックネームの後ろの虫眼鏡の付いた死体とそれらの結果をスコアボードを通して全てのプレイヤーに示すことができます."

L.tip28 = "観戦者は{mutekey}を押すことで他の観戦者や生存者のミュートを切り替えることができます."

L.tip29 = "サーバーが追加の言語をインストールしている場合, 設定メニューからいつでも違う言語に切り替えることができます."

L.tip30 = "クイックチャットか'ラジオ'コマンドは{zoomkey}を押すことで使用できます."

L.tip31 = "観戦者は, {duckkey}を押すとマウスカーソルとこのTIPSパネルのボタンクリックを開放します. 再度{duckkey}を押すとマウスビューに戻ります."

L.tip32 = "Crowbarのセカンダリファイア(右クリック)は他のプレイヤーを押します."

L.tip33 = "武器のアイアンサイトを覗いて発砲することはわずかに精度を上昇させ, 反動を下げるでしょう. しゃがんでもそれらの効果はありません."

L.tip34 = "Smoke grenadeは屋内で効果的です, とりわけ人でいっぱいの部屋の中では混乱を招けるでしょうね."

L.tip35 = "Traitorは忘れないでください, あなたは死体を運ぶことでInnocentとDetectiveの詮索の目から彼らを隠すことができます."

L.tip36 = "{helpkey}で見ることのできるチュートリアルには最重要なキーの総覧が含まれています."

L.tip37 = "スコアボード上では, 生存しているプレイヤーの名前をクリックし, 彼らに'疑わしい'や'仲間'のようなタグを付けることができます. このタグは彼らに近づくとクロスヘアの下に表示されます."

L.tip38 = "(C4やRadioのような)置くことのできるアイテムの多くはセカンダリファイア(右クリック)で壁に固定することができます."

L.tip39 = "C4の解除失敗による爆発はタイマーがゼロに達したC4の爆発より小さいです."

L.tip40 = "ラウンドタイマーの上に'残り時間'と書かれている場合, ラウンドは数分だけ早くなりますが, あらゆる死によって追加の時間を得られます(TF2のCPのように). このモードはTraitorに動き続けるようプレッシャーをかけます."

-- Round report
L.report_title = "ラウンドレポート"

-- Tabs
L.report_tab_hilite = "ハイライト"
L.report_tab_hilite_tip = "ラウンドハイライト"
L.report_tab_events = "イベント"
L.report_tab_events_tip = "このラウンドでのイベントの記録"
L.report_tab_scores = "スコア"
L.report_tab_scores_tip = "このラウンドのみの各プレイヤーのポイント"

-- Event log saving
L.report_save = "セーブログ.txt"
L.report_save_tip = "テキストファイルにイベントログが保存された。"
L.report_save_error = "保存するイベントログのデータがない。"
L.report_save_result = "イベントログのデータが保存された:"

-- Columns
L.col_time = "時間"
L.col_event = "イベント"
L.col_player = "プレイヤー"
L.col_roles = "役職"
L.col_teams = "陣営"
L.col_kills1 = "キル数"
L.col_kills2 = "チームキル数"
L.col_points = "ポイント"
L.col_team = "チームボーナス"
L.col_total = "トータルポイント"

-- Awards/highlights
L.aw_sui1_title = "自殺カルトのリーダー"
L.aw_sui1_text = "は最初の一歩を踏み出す者になることでどうすれば良いのかを他の自殺者達に示しました."

L.aw_sui2_title = "孤独と憂鬱"
L.aw_sui2_text = "は唯一の自殺者でした."

L.aw_exp1_title = "爆発物研究証"
L.aw_exp1_text = "は爆発物の研究が認められました. {num}人の被験者を助け出しましたからね."

L.aw_exp2_title = "フィールドリサーチ"
L.aw_exp2_text = "は爆発への耐久力をテストしました. 耐久力は高くなかったようです."

L.aw_fst1_title = "まずは一匹"
L.aw_fst1_text = "はTraitor達の手に最初のInnocentの死を届けました."

L.aw_fst2_title = "1人目は人違い"
L.aw_fst2_text = "は仲間のTraitorを撃ったことでファーストキルを取りました. Good job."

L.aw_fst3_title = "初めの過ち"
L.aw_fst3_text = "は殺害1番乗りでした. 残念ながら始末したのはInnocentの仲間でしたが."

L.aw_fst4_title = "最初の衝撃"
L.aw_fst4_text = "が最初に始末したのがTraitorだったことでInnocentのテロリスト達に衝撃が走りました."

L.aw_all1_title = "真に危険な者"
L.aw_all1_text = "はこのラウンドでInnocentによる全ての死を招きました."

L.aw_all2_title = "一匹狼"
L.aw_all2_text = "はこのラウンドでTraitorによる全ての死を招きました."

L.aw_nkt1_title = "1人殺りましたよ, ボス!"
L.aw_nkt1_text = "は首尾よく1人のInnocentを始末しました. 嬉しいですね!"

L.aw_nkt2_title = "凶弾は2人へ"
L.aw_nkt2_text = "は他も始末することで最初の1人はラッキーショットではなかったことを示しました."

L.aw_nkt3_title = "シリアルトレイター"
L.aw_nkt3_text = "は今日3人のInnocentのテロリズム人生を終わらせました."

L.aw_nkt4_title = "羊のような狼達の中の狼"
L.aw_nkt4_text = "はディナーにInnocentのテロリスト達を食しました. ディナーは{num}コースでした."

L.aw_nkt5_title = "対テロ諜報員"
L.aw_nkt5_text = "は始末する度に報酬を得ました. 今や豪華なヨットを買うことができます."

L.aw_nki1_title = "この裏切り者が"
L.aw_nki1_text = "はTraitorを見つけました. Traitorを撃ちました. 簡単でしたね."

L.aw_nki2_title = "ジャスティススクワッドへの志願"
L.aw_nki2_text = "は2名のTraitorを来世へとエスコートしました."

L.aw_nki3_title = "トレイターは裏切り羊の夢を見るか?"
L.aw_nki3_text = "は3人のTraitorを寝かしつけました."

L.aw_nki4_title = "内務従業員"
L.aw_nki4_text = "は始末する度に報酬を得ました.　今や5個目のスイミングプールを買うことができます."

L.aw_fal1_title = "いや, ボンドさん, 落ちてもらうだけだ."
L.aw_fal1_text = "は高所から誰かを突き落としました."

L.aw_fal2_title = "おやすみなさい"
L.aw_fal2_text = "は彼らの体をかなりの高度から落として床にヒットさせました."

L.aw_fal3_title = "人間隕石"
L.aw_fal3_text = "は誰かを高所から落とすことによって潰しました."

L.aw_hed1_title = "効率的"
L.aw_hed1_text = "はヘッドショットの楽しさを見出して{num}人始末しました."

L.aw_hed2_title = "神経学"
L.aw_hed2_text = "はよく調べるため{num}人の頭から脳を取り除きました."

L.aw_hed3_title = "ビデオゲームの影響"
L.aw_hed3_text = "は殺人鬼シミュレーショントレーニングに傾倒して{num}人の敵をヘッドショットしました."

L.aw_cbr1_title = "ドカッ バキッ ボカッ"
L.aw_cbr1_text = "は{num}人の犠牲者に見つかった際にCrowbarを振ってみせました."

L.aw_cbr2_title = "バール好き"
L.aw_cbr2_text = "は{num}人もの脳漿をバールに浴びせました."

L.aw_pst1_title = "根気強いちっちゃなやつ"
L.aw_pst1_text = "はピストルで{num}キルを取りました. そして続いて死に至らしめるために抱きしめました."

L.aw_pst2_title = "小口径での殺戮"
L.aw_pst2_text = "はピストルで{num}人の小規模な軍隊を始末しました. おそらくバレルの中に小さなショットガンを入れていたのでしょう."

L.aw_sgn1_title = "余裕だったな"
L.aw_sgn1_text = "は負傷者にバックショット弾を命中させて, {num}人のターゲットを殺害しました."

L.aw_sgn2_title = "千の小弾"
L.aw_sgn2_text = "はバックショット弾が大嫌いなので, 全部ばら撒きました. 受け取った{num}人は人生を楽しめませんでしたが."

L.aw_rfl1_title = "ポイントアンドクリック"
L.aw_rfl1_text = "は{num}人を始末するにはライフルと安定した手が必要な全てだと示しました."

L.aw_rfl2_title = "頭, 見えてますよ"
L.aw_rfl2_text = "はライフルを理解しています. 今, 他の{num}人もライフルを理解しました."

L.aw_dgl1_title = "小さなライフルみたいだね"
L.aw_dgl1_text = "はデザートイーグルのコツを掴んで{num}人を始末しました."

L.aw_dgl2_title = "イーグルマスター"
L.aw_dgl2_text = "はデザートイーグルで{num}人を消しました."

L.aw_mac1_title = "敬虔と殺人"
L.aw_mac1_text = "はMAC10で{num}人を始末しましたが, どのくらいの弾を必要としたかは言わないでしょう."

L.aw_mac2_title = "マカロニ・アンド・チーズ"
L.aw_mac2_text = "は2挺のMAC10を上手く扱うことができたらどうなるのか驚きました.　{num}回もを2挺で?"

L.aw_sip1_title = "お静かに"
L.aw_sip1_text = "は消音ピストルで{num}人を黙らせました."

L.aw_sip2_title = "静寂のアサシン"
L.aw_sip2_text = "は{num}人を自身の死を聞き取らせずに始末しました."

L.aw_knf1_title = "ナイフは知っている"
L.aw_knf1_text = "はインターネット越しに面前の誰かを刺しました."

L.aw_knf2_title = "どこから手に入れたんだい?"
L.aw_knf2_text = "はTraitorではありませんでしたが, それでも誰かをナイフで殺害しました."

L.aw_knf3_title = "とんでもないナイフ使い"
L.aw_knf3_text = "は周囲に転がっている{num}本のナイフを見つけ, 活用しました."

L.aw_knf4_title = "世界一のナイフ使い"
L.aw_knf4_text = "はナイフで{num}人を始末しました. どうやったのかは聞かないでください."

L.aw_flg1_title = "助けに行くよ"
L.aw_flg1_text = "は{num}人の死の合図にフレアを使用しました."

L.aw_flg2_title = "フレアは炎へ"
L.aw_flg2_text = "は{num}人の男に可燃性の衣服を着ることの危険性を教えました."

L.aw_hug1_title = "大きな拡散"
L.aw_hug1_text = "はH.U.G.Eと1つになり, とにかくうまいこと{num}人に弾丸をヒットさせました."

L.aw_hug2_title = "忍耐強いパラ"
L.aw_hug2_text = "はただただ撃ち続け, そしてH.U.G.Eの忍耐は{num}人の始末で報いるのを見ました."

L.aw_msx1_title = "バタバタバタ"
L.aw_msx1_text = "はM16で{num}人排除しました."

L.aw_msx2_title = "ミドルレンジマッドネス"
L.aw_msx2_text = "が{num}人キル取っているということはM16でのターゲットの仕留め方を知っていますね."

L.aw_tkl1_title = "驚かせよう"
L.aw_tkl1_text = "はちょうど相棒の方を向いている時に指を滑らせてしまいました."

L.aw_tkl2_title = "2重の驚き"
L.aw_tkl2_text = "は2回Traitorを始末したと思っていましたが, 2回ともハズレでした."

L.aw_tkl3_title = "カルマ重視"
L.aw_tkl3_text = "はチームメイトを2人始末した後も止められませんでした. 3はラッキーナンバーですから."

L.aw_tkl4_title = "チームキラー"
L.aw_tkl4_text = "はチーム全員を始末しました. BANしましょうよ!"

L.aw_tkl5_title = "ロールプレイヤー"
L.aw_tkl5_text = "は狂人のロールプレイをしていました, 本当にね. それはなぜならチームの多くを始末したからです."

L.aw_tkl6_title = "ばか"
L.aw_tkl6_text = "は彼らがどちら側かを理解できず, 半数を超える仲間を始末しました."

L.aw_tkl7_title = "レッドネック"
L.aw_tkl7_text = "はチームメイトの4分の1以上を始末したことで十分な縄張りを守りました."

L.aw_brn1_title = "おばあちゃんのお料理レシピ"
L.aw_brn1_text = "は何人かを良い感じのクリスプに揚げました."

L.aw_brn2_title = "パイロイド"
L.aw_brn2_text = "は燃えている多くの犠牲者の後ろで高笑いしているのを聞かれました."

L.aw_brn3_title = "ピュロスの焼却"
L.aw_brn3_text = "はIncendiary grenadeを使い切りましたが全員を燃やしてやりました! どうやって対処するのでしょう!?"

L.aw_fnd1_title = "検死官"
L.aw_fnd1_text = "は{num}人の転がっている死体を発見しました."

L.aw_fnd2_title = "めざせテロリストマスター"
L.aw_fnd2_text = "はコレクションのために{num}人の死体を発見しました."

L.aw_fnd3_title = "死の芳香"
L.aw_fnd3_text = "はこのラウンドで奇遇にも{num}回死体を発見しました."

L.aw_crd1_title = "リサイクル屋"
L.aw_crd1_text = "は死体から{num}未使用クレジットをあさりました."

L.aw_tod1_title = "ピュロスの勝利"
L.aw_tod1_text = "はチームがラウンドを勝利するたった数秒前に死亡しました."

L.aw_tod2_title = "クソゲー"
L.aw_tod2_text = "はラウンド開始してすぐに死亡しました."

-- New and modified pieces of text are placed below this point, marked with the
-- version in which they were added, to make updating translations easier.

-- v24
L.drop_no_ammo = "弾薬箱として捨てるのに武器に装填されている弾がないようだ。"

-- 2015-05-25
L.hat_retrieve = "Detectiveの帽子を拾った。"

-- 2017-09-03
L.sb_sortby = "並び変え順:"

-- 2018-07-24
L.equip_tooltip_main = "装備品一覧"
L.equip_tooltip_radar = "レーダーメニュー"
L.equip_tooltip_disguise = "変装メニュー"
L.equip_tooltip_radio = "ラジオメニュー"
L.equip_tooltip_xfer = "クレジット譲渡"
L.equip_tooltip_reroll = "アイテムスロット"

L.confgrenade_name = "ディスコンボビュレーター"
L.polter_name = "Poltergeist(ポルターガイスト)"
L.stungun_name = "UMP-プロトタイプ"

L.knife_instant = "斬殺"

L.binoc_zoom_level = "拡大レベル"
L.binoc_body = "死体が検出された。"

L.idle_popup_title = "放置"

-- 2019-01-31
L.create_own_shop = "オリジナルのショップを作成"
L.shop_link = "リンク先"
L.shop_disabled = "ショップ使用不可"
L.shop_default = "デフォルトのショップを使用"

-- 2019-05-05
L.reroll_name = "スロット"
L.reroll_menutitle = "スロットアイテム"
L.reroll_no_credits = "回すのに{amount}個のクレジットが必要だ"
L.reroll_button = "スロット開始"
L.reroll_help = "ショップから{amount}個のクレジットを使用し、新しいアイテムを得よう！"

-- 2019-05-06
L.equip_not_alive = "右から役職を選択し、使用可能なアイテムを閲覧できる。お気に入り登録を忘れずに！"

-- 2019-06-27
L.shop_editor_title = "ショップエディタ"
L.shop_edit_items_weapong = "アイテムエディタ/ウェポンエディタ"
L.shop_edit = "ショップ編集"
L.shop_settings = "設定"
L.shop_select_role = "役職選択"
L.shop_edit_items = "アイテム編集"
L.shop_edit_shop = "ショップ編集"
L.shop_create_shop = "カスタムショップ作成"
L.shop_selected = "{role}を選択"
L.shop_settings_desc = "値を変更してランダムショップのConvarsを調整。変更を保存することをお忘れなく！"

L.bindings_new = " {name} が新しくキー設定された: {key} "

L.hud_default_failed = " {hudname} を新しく設定できなかった。これを行う権限がないか、このHUDが存在しないようだ。"
L.hud_forced_failed = " {hudname} を固定できなかった。これを行う権限がないか、このHUD が存在しないようだ。"
L.hud_restricted_failed = " {hudname} を制限できなかった。あなたはそれを行う権限がないようだ。"

L.shop_role_select = "役職選択"
L.shop_role_selected = "{roles}のショップを選択した"
L.shop_search = "検索"

L.spec_help = "プレイヤー達を観戦する場合はクリックするか、{usekey}を押して、オブジェクトに憑依できる。"
L.spec_help2 = "観戦者モードをやめるには、{helpkey}でメニューを開き、「ゲーム設定」から観戦者モードを切り替えよう。"

-- 2019-10-19
L.drop_ammo_prevented = "何かが弾を捨てるのを妨げているようだ。"

-- 2019-10-28
L.target_c4 = "[{usekey}]でC4メニューを開く"
L.target_c4_armed = "[{usekey}]でC4を解除する"
L.target_c4_armed_defuser = "[{usekey}]で除去装置を使う"
L.target_c4_not_disarmable = "あなたは生存しているチームメイトのC4を解除することはできない。"
L.c4_short_desc = "巨大な爆発を引き起こす"

L.target_pickup = "[{usekey}]で拾う"
L.target_slot_info = "スロット: {slot}"
L.target_pickup_weapon = "[{usekey}]で武器を拾う"
L.target_switch_weapon = "[{usekey}]で今手に持っている武器と交換"
L.target_pickup_weapon_hidden = ", [{usekey} + {walkkey}]で隠密に拾う"
L.target_switch_weapon_hidden = ", [{usekey} + {walkkey}]で隠密に交換"
L.target_switch_weapon_nospace = "この武器のインベントリがないな。"
L.target_switch_drop_weapon_info = "{name}をスロット{slot}から捨てる"
L.target_switch_drop_weapon_info_noslot = "スロット{slot}には捨てるものがないな。"

L.corpse_searched_by_detective = "Detectiveにより調査済み"
L.corpse_too_far_away = "その死体から遠すぎる。"

L.radio_pickup_wrong_team = "別陣営が所有するラジオは使えないようだ。"
L.radio_short_desc = "銃声こそ音楽だ"

L.hstation_subtitle = "[{usekey}]で回復する."
L.hstation_charge = "回復ステーションのエネルギー量: {charge}"
L.hstation_empty = "もうこの回復ステーションにはエネルギーがないようだ。"
L.hstation_maxhealth = "体力はすでに満タンだぞ。"
L.hstation_short_desc = "回復ステーションは時間経過とともにゆっくりチャージする。"

-- 2019-11-03
L.vis_short_desc = "被害者が射殺されたときのみ殺害現場を可視化してくれる。"
L.corpse_binoculars = "[{key}]で双眼鏡を用いて死体を確認する。"
L.binoc_progress = "検索の進行状況: {progress}%"

L.pickup_fail = "これは拾えないようだ。"
L.pickup_no_room = "この武器の種類のインベントリに空きがないようだ。"
L.pickup_pending = "既に武器を拾っている、受け取りまで少し待とう。"

-- 2020-01-07
L.tbut_help_admin = "Traitorトラップ設定を編集する"
L.tbut_role_toggle = "[{walkkey} + {usekey}]で{role}に切り替える"
L.tbut_role_config = "役職:{current}"
L.tbut_team_toggle = "[SHIFT + {walkkey} + {usekey}]で{team}に切り替える"
L.tbut_team_config = "陣営:{current}"
L.tbut_current_config = "現在の設定:"
L.tbut_intended_config = "マップ制作者による意図された設定:"
L.tbut_admin_mode_only = "'{cv}''1'にセットしているため、あなたにしか見えない。"
L.tbut_allow = "許可"
L.tbut_prohib = "禁止"
L.tbut_default = "デフォルト"

-- 2020-02-09
L.name_door = "ドア"
L.door_open = " [{usekey}] でドアを開ける。"
L.door_close = " [{usekey}] でドアを閉める。"
L.door_locked = "このドアはかぎが掛かっているようだ。"

-- 2020-02-11
L.automoved_to_spec = "（緊急メッセージ）しばらくAFK状態だったため、観戦者になったぞ。"
L.mute_team = "{team}がミュートされた。"

-- 2020-02-16
L.door_auto_closes = "このドアは自動で閉まるようだ。"
L.door_open_touch = "触れるとドアが開くようだ。"
L.door_open_touch_and_use = "このドアは触れるか、[{usekey}] で開くようだ。"
L.hud_health = "HP"

-- 2020-03-09
L.help_title = "ヘルプと設定"

L.menu_changelog_title = "変更履歴"
L.menu_guide_title = "TTT2ガイド"
L.menu_bindings_title = "キー設定"
L.menu_language_title = "言語"
L.menu_appearance_title = "外見設定"
L.menu_gameplay_title = "ゲーム設定"
L.menu_addons_title = "TTT2専用アドオン設定"
L.menu_legacy_title = "TTT対応アドオン設定"
L.menu_administration_title = "管理者用設定"
L.menu_equipment_title = "装備編集"
L.menu_shops_title = "ショップ編集"

L.menu_changelog_description = "今までのバージョンの更新点や\n変更点を閲覧。"
L.menu_guide_description = "TTT2が初めての方への説明、遊び方、役職やスタッフをご紹介。"
L.menu_bindings_description = "TTT2用の特定の機能、\nまたはそれ対応のアドオン関連のキーを設定。"
L.menu_language_description = "言語を設定できます。"
L.menu_appearance_description = "外見やユーザーインターフェイスを\n微調整できます。"
L.menu_gameplay_description = "ある役職になることを避けたりなど、\nそのほかの微調整ができます。"
L.menu_addons_description = "個人のお好きで、現在導入されている\nアドオン構成ができます。"
L.menu_legacy_description = "旧TTTのように設定ができ、\nその設定はTTT2にも適用されます。"
L.menu_administration_description = "HUD、ショップやその他の設定。"
L.menu_equipment_description = "クレジット設定、使用制限、\n使用の有無などを設定。"
L.menu_shops_description = "役職へのショップの追加/削除と、\nその内のアイテム設定が変更できます。"

L.submenu_guide_gameplay_title = "ゲーム設定"
L.submenu_guide_roles_title = "役職"
L.submenu_guide_equipment_title = "装備"

L.submenu_bindings_bindings_title = "キー設定"

L.submenu_language_language_title = "言語"

L.submenu_appearance_general_title = "基本"
L.submenu_appearance_hudswitcher_title = "HUD切替"
L.submenu_appearance_vskin_title = "Vスキン"
L.submenu_appearance_targetid_title = "ターゲットID"
L.submenu_appearance_shop_title = "ショップ設定"
L.submenu_appearance_crosshair_title = "クロスヘア"
L.submenu_appearance_dmgindicator_title = "ダメージインジケータ"
L.submenu_appearance_performance_title = "パフォーマンス"
L.submenu_appearance_interface_title = "インターフェイス"
L.submenu_appearance_miscellaneous_title = "その他"

L.submenu_gameplay_general_title = "基本設定"
L.submenu_gameplay_avoidroles_title = "役職設定"

L.submenu_administration_hud_title = "HUD設定"
L.submenu_administration_randomshop_title = "ランダムショップ"

L.help_color_desc = "ターゲットのID、アウトラインとクロスヘアに\n使用されるグローバルカラーを選択"
L.help_scale_factor = "この倍率は、すべてのUI要素に影響を与えます（例えばHUD、VguiやターゲットID）。画面の解像度が変更されると、自動的に更新される。この値を変更するとHUDがリセットされる。"
L.help_hud_game_reload = "そのHUDは現在適用されていないようだ。ゲームを再起動しよう。"
L.help_hud_special_settings = "このHUDにはそれ特有の設定があるようだ。"
L.help_vskin_info = "Vスキン（vguiスキン）は、現在のメニュー要素と同様に、すべてのメニュー要素に適用されるスキン。スキンは簡単なluaスクリプトで簡単に作成でき、色やいくつかのサイズのパラメータを変更可能。"
L.help_targetid_info = "ターゲットIDは、エンティティに焦点を設定するときに表示される情報。基本設定パネルで固定色を設定可能。"
L.help_hud_default_desc = "すべてのプレイヤーにデフォルトのHUDを設定する。HUDをまだ選択していないプレイヤーは、デフォルトとしてこのHUDが適用される。これにより、HUDを選択済みのプレイヤーのHUDは変更されない。"
L.help_hud_forced_desc = "全てのプレイヤーにHUDを固定します。これにより、すべてのユーザーに対してHUD選択機能が無効になる。"
L.help_hud_enabled_desc = "これらのHUDの選択を制限するには、HUDを有効/無効にしましょう。"
L.help_damage_indicator_desc = "ダメージインジケーターは、プレイヤーが損傷したときに表示されるオーバーレイ。新しいテーマを追加するときは、画像を「materials/vgui/ttt/damageindicator/themes/」に保存。"
L.help_shop_key_desc = "ラウンド終了時/準備中にスコアメニューの代わりに\nショップキー（C）を押してアイテムショップを開く"

L.label_menu_menu = "メニュー"
L.label_menu_admin_spacer = "管理者用（通常のプレイヤーには非表示）"
L.label_language_set = "言語を選ぼう"
L.label_global_color_enable = "グローバルカラー有効"
L.label_global_color = "グローバルカラー"
L.label_global_scale_factor = "尺度"
L.label_hud_select = "HUD選択"
L.label_vskin_select = "Vスキン選択"
L.label_blur_enable = "Vスキンの背景のぼかしを有効"
L.label_color_enable = "Vスキンの背景の色を有効"
L.label_minimal_targetid = "クロスヘア下のターゲットIDを最小限にする（カルマ、ヒントなど非表示）"
L.label_shop_always_show = "常時ショップを表示"
L.label_shop_double_click_buy = "ダブルクリックでショップのアイテムを購入できることを有効"
L.label_shop_num_col = "列数"
L.label_shop_num_row = "行数"
L.label_shop_item_size = "アイコンの大きさ"
L.label_shop_show_slot = "スロットマーカーを表示"
L.label_shop_show_custom = "カスタムアイテムマーカーを表示"
L.label_shop_show_fav = "お気に入りアイテムマーカーを表示"
L.label_crosshair_enable = "クロスヘアあり"
L.label_crosshair_gap_enable = "カスタムクロスヘアギャップあり"
L.label_crosshair_gap = "カスタムクロスヘアギャップ"
L.label_crosshair_opacity = "クロスヘア不透明度"
L.label_crosshair_ironsight_opacity = "アイアンサイトのクロスヘアの不透明度"
L.label_crosshair_size = "クロスヘアの大きさ"
L.label_crosshair_thickness = "クロスヘアの太さ"
L.label_crosshair_thickness_outline = "クロスヘアの外枠の太さ"
L.label_crosshair_static_enable = "スタティッククロスヘアを有効"
L.label_crosshair_dot_enable = "クロスヘアドットを有効"
L.label_crosshair_lines_enable = "クロスヘアラインを有効"
L.label_crosshair_scale_enable = "武器依存の武器スケールを有効にする"
L.label_crosshair_ironsight_low_enabled = "アイアンサイトを使用する場合は武器を提げる"
L.label_damage_indicator_enable = "ダメージインジケーターを有効"
L.label_damage_indicator_mode = "ダメージインジケーターのテーマを選択"
L.label_damage_indicator_duration = "命中後にダメージインジケーターが表示される秒数"
L.label_damage_indicator_maxdamage = "最大不透明度に必要なダメージ"
L.label_damage_indicator_maxalpha = "ダメージインジケーター最大不透明度"
L.label_performance_halo_enable = "いくつかのエンティティを見ている間に、それらにアウトラインが表示されることを有効"
L.label_performance_spec_outline_enable = "操作しているオブジェクトのアウトラインを有効"
L.label_performance_ohicon_enable = "頭の上の役職アイコンを有効"
L.label_interface_tips_enable = "観戦中画面の下部にゲームヒントを表示"
L.label_interface_popup = "ラウンド開始時にポップアップを表示"
L.label_interface_fastsw_menu = "高速武器スイッチでメニューを有効"
L.label_inferface_wswitch_hide_enable = "武器の切り替えメニューが自動で閉じることを有効"
L.label_inferface_scues_enable = "ラウンド開始や終了後に音を鳴らす"
L.label_gameplay_specmode = "観戦者モード（常時観戦者になれます）"
L.label_gameplay_fastsw = "高速武器スイッチ"
L.label_gameplay_hold_aim = "Aimの固定を有効"
L.label_gameplay_mute = "死んだとき生存者のボイスチャットをミュートにする"
L.label_gameplay_dtsprint_enable = "タブルタップ走行を有効"
L.label_gameplay_dtsprint_anykey = "止まるまでダブルタップ走行を止めない"
L.label_hud_default = "デフォルトHUD"
L.label_hud_force = "強制的HUD"

L.label_bind_weaponswitch = "武器を拾う"
L.label_bind_sprint = "ダッシュ"
L.label_bind_voice = "通常ボイスチャット"
L.label_bind_voice_team = "チームボイスチャット"

L.label_hud_basecolor = "基本色"

L.label_menu_not_populated = "このサブメニューには、コンテンツが含まれていないようだ。"

L.header_bindings_ttt2 = "TTT2対応キー設定"
L.header_bindings_other = "その他"
L.header_language = "言語設定"
L.header_global_color = "全体色を選択"
L.header_hud_select = "HUD選択"
L.header_hud_customize = "HUDカスタマイズ"
L.header_vskin_select = "Vスキン設定"
L.header_targetid = "ターゲットID設定"
L.header_shop_settings = "アイテムショップ設定"
L.header_shop_layout = "アイテムリストレイアウト"
L.header_shop_marker = "アイテムマーカー設定"
L.header_crosshair_settings = "クロスヘア設定"
L.header_damage_indicator = "ダメージインジケータ設定"
L.header_performance_settings = "パフォーマンス設定"
L.header_interface_settings = "インターフェイス設定"
L.header_gameplay_settings = "ゲーム設定"
L.header_roleselection = "あまりなりたくない役職を選択(必ずならないわけではありません)"
L.header_hud_administration = "デフォルトと強制的HUDを選択"
L.header_hud_enabled = "HUD 有効/無効"

L.button_menu_back = "戻る"
L.button_none = "無し"
L.button_press_key = "押す"
L.button_save = "セーブ"
L.button_reset = "リセット"
L.button_close = "閉じる"
L.button_hud_editor = "HUDエディタ"

-- 2020-04-20
L.item_speedrun = "走行強化"
L.item_speedrun_desc = [[足が通常の５０％程早くなる。]]
L.item_no_explosion_damage = "爆死無効"
L.item_no_explosion_damage_desc = [[爆破ダメージを無効にする。]]
L.item_no_fall_damage = "転落死無効"
L.item_no_fall_damage_desc = [[落下ダメージを無効にする。]]
L.item_no_fire_damage = "燃焼無効"
L.item_no_fire_damage_desc = [[炎によるダメージを無効にする。]]
L.item_no_hazard_damage = "放射能無効"
L.item_no_hazard_damage_desc = [[毒や放射能によるダメージを無効にする。]]
L.item_no_energy_damage = "感電無効"
L.item_no_energy_damage_desc = [[電気やビームによるダメージを無効にする。]]
L.item_no_prop_damage = "圧死無効"
L.item_no_prop_damage_desc = [[物によるダメージを無効にする。]]
L.item_no_drown_damage = "溺死無効"
L.item_no_drown_damage_desc = [[溺れるダメージを無効にする。]]

-- 2020-04-21
L.dna_tid_possible = "スキャン可能"
L.dna_tid_impossible = "スキャン不可能"
L.dna_screen_ready = "No DNA"
L.dna_screen_match = "Match"

-- 2020-04-30
L.message_revival_canceled = "蘇生が中断されたようだ。"
L.message_revival_failed = "蘇生は失敗みたいだ。"
L.message_revival_failed_missing_body = "長い時間死体のそばにとどまらなかったから、蘇生できなかったようだ。"
L.hud_revival_title = "復活するまで:"
L.hud_revival_time = "{time}秒"

-- 2020-05-03
L.door_destructible = "ドアが破損している({health}HP)"

-- 2020-05-28
L.confirm_detective_only = "Detectiveにしか死体を確認できないようだ。"
L.inspect_detective_only = "Detectiveにしか死体を検査できないようだ。"
L.corpse_hint_no_inspect = "Detectiveにしかこの死体を探せないようだ。"
L.corpse_hint_inspect_only = "[{usekey}] で探す。Detectiveにしか死体を確認できないようだ。"
L.corpse_hint_inspect_only_credits = "[{usekey}] でクレジットを受け取る。Detectiveにしかこの死体を探せないようだ。"

-- 2020-06-04
L.label_bind_disguiser = "変装する"

-- 2020-06-24
L.dna_help_primary = "DNAサンプルを集める"
L.dna_help_secondary = "DNAスロットを切り替え"
L.dna_help_reload = "サンプル消去"

L.binoc_help_pri = "死体を確認する"
L.binoc_help_sec = "ズームレベル変更"

L.vis_help_pri = "可視化装置を落とす"

L.decoy_help_pri = "デコイを設置する"

-- 2020-08-07
L.pickup_error_spec = "観戦者のためこれは拾えないようだ。"
L.pickup_error_owns = "すでにこの武器を持っているため拾えないようだ。"
L.pickup_error_noslot = "空いているスロットがないため拾えないようだ。"

-- 2020-11-02
L.lang_server_default = "サーバーデフォルト"
L.help_lang_info = [[
この翻訳は、英語が既定の参照として使用された {coverage}% です。

これらの翻訳はコミュニティによって作成されています。何かが欠けているか、間違っている場合は、自由に貢献してください。]]

-- 2021-04-13
L.title_score_info = "ラウンド情報"
L.title_score_events = "イベント履歴"

L.label_bind_clscore = "ラウンドレポートを開く"
L.title_player_score = "{player}'の得点:"

L.label_show_events = "イベント範囲"
L.button_show_events_you = "個人"
L.button_show_events_global = "全体"
L.label_show_roles = "役職の配布を表示"
L.button_show_roles_begin = "ラウンド開始"
L.button_show_roles_end = "ラウンド終了"

L.hilite_win_traitors = "Traitor陣営の勝利"
L.hilite_win_innocents = "Innocent陣営の勝利"
L.hilite_win_tie = "引き分け"
L.hilite_win_time = "時間切れ"

L.tooltip_karma_gained = "このラウンドのカルマ上昇値:"
L.tooltip_score_gained = "このラウンドの得点上昇値:"
L.tooltip_roles_time = "役職の延長時間:"

L.tooltip_finish_score_alive_teammates = "生存したチームメイト:{score}"
L.tooltip_finish_score_alive_all = "生存者:{score}"
L.tooltip_finish_score_timelimit = "時間切れ:{score}"
L.tooltip_finish_score_dead_enemies = "敵の死亡:{score}"
L.tooltip_kill_score = "殺害:{score}"
L.tooltip_bodyfound_score = "死体発見:{score}"

L.finish_score_alive_teammates = "生存したチームメイト:"
L.finish_score_alive_all = "生存者:"
L.finish_score_timelimit = "時間切れ:"
L.finish_score_dead_enemies = "敵の死亡:"
L.kill_score = "殺害:"
L.bodyfound_score = "死体発見:"

L.title_event_bodyfound = "死体が発見された"
L.title_event_c4_disarm = "C4が解除された"
L.title_event_c4_explode = "C4が起爆された"
L.title_event_c4_plant = "C4が設置された"
L.title_event_creditfound = "クレジットを得た"
L.title_event_finish = "ラウンド終了"
L.title_event_game = "新しいラウンドの開始"
L.title_event_kill = "プレイヤーが殺された"
L.title_event_respawn = "プレイヤーが生き返った"
L.title_event_rolechange = "プレイヤーの役職/陣営が変わった"
L.title_event_selected = "役職が配布された"
L.title_event_spawn = "プレイヤーが出現した"

L.desc_event_bodyfound = "{finder} ({firole} / {fiteam}) has found the body of {found} ({forole} / {foteam}). The corpse has {credits} equipment credit(s)."
L.desc_event_bodyfound_headshot = "頭を撃ち抜かれて殺された。"
L.desc_event_c4_disarm_success = "{disarmer} ({drole} / {dteam})は{owner} ({orole} / {oteam})が設置したC4の解除に成功した。"
L.desc_event_c4_disarm_failed = "{disarmer} ({drole} / {dteam})は{owner} ({orole} / {oteam})が設置したC4の解除に失敗した。"
L.desc_event_c4_explode = "{owner} ({role} / {team})によって設置されたC4が爆発した。"
L.desc_event_c4_plant = "{owner} ({role} / {team})はC4を設置した。"
L.desc_event_creditfound = "{finder} ({firole} / {fiteam})は{credits}個のクレジットを{found} ({forole} / {foteam})から得た。"
L.desc_event_finish = "ラウンド継続時間は{minutes}:{seconds}。生存者は{alive}人。"
L.desc_event_game = "ラウンドが開始された。"
L.desc_event_respawn = "{player}が生き返った。"
L.desc_event_rolechange = "{player}が{orole} ({oteam})から{nrole} ({nteam})へと変わった。"
L.desc_event_selected = "陣営と役職が全ての{amount}人のプレイヤーに配布された。"
L.desc_event_spawn = "{player}が出現した。"

-- Name of a trap that killed us that has not been named by the mapper
L.trap_something = "何か"

-- Kill events
L.desc_event_kill_suicide = "自殺してしまった。"
L.desc_event_kill_team = "味方を殺してしまった。"

L.desc_event_kill_blowup = "{victim}({vrole}/{vteam})は吹き飛んだ。"
L.desc_event_kill_blowup_trap = "{victim}({vrole}/{vteam})は{trap}によって吹き飛ばされた。"

L.desc_event_kill_tele_self = "{victim}({vrole}/{vteam})は手榴弾で自爆した。"
L.desc_event_kill_sui = "{victim}({vrole}/{vteam})は何かを受け入れられず自殺した。"
L.desc_event_kill_sui_using = "{victim}({vrole}/{vteam})は{tool}を使用して自殺した。"

L.desc_event_kill_fall = "{victim}({vrole}/{vteam})は転落死した。"
L.desc_event_kill_fall_pushed = "{victim}({vrole}/{vteam})は{attacker}に押されて転落死。"
L.desc_event_kill_fall_pushed_using = "{victim}({vrole}/{vteam})は{attacker}({arole}/{ateam})に{trap}で押されて転落死。"

L.desc_event_kill_shot = "{victim}({vrole}/{vteam})は{attacker}に撃たれた。"
L.desc_event_kill_shot_using = "{victim}({vrole}/{vteam})は{attacker}({arole}/{ateam})に{weapon}で撃たれた。"

L.desc_event_kill_drown = "{victim}({vrole}/{vteam})は{attacker}によって溺死させられた。"
L.desc_event_kill_drown_using = "{victim}({vrole}/{vteam})は{attacker}({arole}/{ateam})が{trap}を起動したことにより溺死させられた。"

L.desc_event_kill_boom = "{victim}({vrole}/{vteam})は{attacker}によって爆破された。"
L.desc_event_kill_boom_using = "{victim}({vrole}/{vteam})は{attacker}({arole}/{ateam})の使用した{trap}によって吹き飛ばされた。"

L.desc_event_kill_burn = "{victim}({vrole}/{vteam})は{attacker}によって焼かれた。"
L.desc_event_kill_burn_using = "{victim}({vrole}/{vteam})は{attacker}({arole}/{ateam})の仕組んだ{trap}により燃やされた。"

L.desc_event_kill_club = "{victim}({vrole}/{vteam})は{attacker}によって殴られた。"
L.desc_event_kill_club_using = "{victim}({vrole}/{vteam})は{attacker}({arole}/{ateam})の{trap}でしたたかに殴り殺された。"

L.desc_event_kill_slash = "{victim}({vrole}/{vteam})は{attacker}に刺された。"
L.desc_event_kill_slash_using = "{victim}({vrole}/{vteam})は{attacker}({arole}/{ateam})に{trap}で切り刻まれた。"

L.desc_event_kill_tele = "{victim}({vrole}/{vteam})は{attacker}により手榴弾で爆殺された。"
L.desc_event_kill_tele_using = "{victim}({vrole}/{vteam})は{attacker}({arole}/{ateam})が仕掛けた{trap}により粉々にされた。"

L.desc_event_kill_goomba = "{victim}({vrole}/{vteam})は巨大な{attacker}({arole}/{ateam})により踏み潰された。"

L.desc_event_kill_crush = "{victim}({vrole}/{vteam})は{attacker}により押し潰された。"
L.desc_event_kill_crush_using = "{victim}({vrole}/{vteam})は{attacker}({arole}/{ateam})の{trap}により押し潰された。"

L.desc_event_kill_other = "{victim}({vrole}/{vteam})は{attacker}により殺害された。"
L.desc_event_kill_other_using = "{victim}({vrole}/{vteam})は{attacker}({arole}/{ateam})の使用した{trap}により殺害された。"

-- 2021-04-20
L.none = "無職"

-- 2021-04-24
L.karma_teamkill_tooltip = "チーム殺害数"
L.karma_teamhurt_tooltip = "チームダメージ値"
L.karma_enemykill_tooltip = "殺害数"
L.karma_enemyhurt_tooltip = "ダメージ値"
L.karma_cleanround_tooltip = "ラウンド整理"
L.karma_roundheal_tooltip = "ラウンド復帰"
L.karma_unknown_tooltip = "不明"

-- 2021-05-07
L.header_random_shop_administration = "ランダムショップセットアップ"
L.header_random_shop_value_administration = "バランス設定"

L.shopeditor_name_random_shops = "ランダムショップ有効"
L.shopeditor_desc_random_shops = [[ランダムショップは限られた、使用可能なランダムアイテムを付与する。
陣営ショップは、一つの陣営の全てのプレイヤーに、個々のセットではなく同じセットを持つことを強制する。
クレジットを使用することで回せる、スロットにより、新しくランダムなアイテムを得ることができる。]]
L.shopeditor_name_random_shop_items = "ランダムアイテム数"
L.shopeditor_desc_random_shop_items = "これがアイテムに含まれていたら、ランダム無効アイテムに含まれる。だから、十分に高い数を選択するか、あなただけが得る。"
L.shopeditor_name_random_team_shops = "陣営ショップ有効"
L.shopeditor_name_random_shop_reroll = "スロットショップ有効"
L.shopeditor_name_random_shop_reroll_cost = "スロットコスト"
L.shopeditor_name_random_shop_reroll_per_buy = "購入直後の自動スロット"

-- 2021-06-04
L.header_equipment_setup = "セットアップ"
L.header_equipment_value_setup = "バランス設定"

L.equipmenteditor_name_not_buyable = "購入可能"
L.equipmenteditor_desc_not_buyable = "無効の場合、ショップに表示されないようになる。\nこのアイテムが割り当てられている役職は引き続きそれを受け取ります。"
L.equipmenteditor_name_not_random = "常時購入可能"
L.equipmenteditor_desc_not_random = "有効の場合、常時このアイテムがショップに表示されるようになり、ランダムショップの影響は受けません。\n１つの使用可能なランダムスロットを取り、常にこのアイテムのためにそれが予約されます。"
L.equipmenteditor_name_global_limited = "全体的な使用制限"
L.equipmenteditor_desc_global_limited = "有効の場合、一つ買ったら次のラウンドまで他の者たちは買うことはできません。"
L.equipmenteditor_name_team_limited = "陣営による使用制限"
L.equipmenteditor_desc_team_limited = "有効の場合、一つ買ったら次のラウンドまで他のチームメイトは買うことはできません。"
L.equipmenteditor_name_player_limited = "使用制限"
L.equipmenteditor_desc_player_limited = "有効の場合、一つ買ったら次のラウンドまで買うことはできません。"
L.equipmenteditor_name_min_players = "必要プレイヤー人数"
L.equipmenteditor_name_credits = "クレジット消費数"

-- 2021-06-08
L.equip_not_added = "除外"
L.equip_added = "追加"
L.equip_inherit_added = "(inherit)を追加した"
L.equip_inherit_removed = "(inherit)を除外した"

-- 2021-06-09
L.layering_not_layered = "ノンレイヤード"
L.layering_layer = "レイヤー{layer}"
L.header_rolelayering_role = "{role}レイヤー"
L.header_rolelayering_baserole = "基本役職レイヤー"
L.submenu_administration_rolelayering_title = "役職レイヤー"
L.header_rolelayering_info = "役職レイヤー情報"
L.help_rolelayering_roleselection = "役職の選択プロセスは、２つのパスに分割される。一つ目は基本役職が配布されている。\n基本役職とは、Innocent、Traitor、および下の「基本役職レイヤー」ボックスにリストされている役職のこと。\n二つ目は、これらの基本役職を副役職にアップグレードするために使用される。"
L.help_rolelayering_layers = "各レイヤーから１つの役職のみが選択される。最初に、カスタムレイヤーの役職が、\n最初のレイヤーから最後のレイヤーに到達するまで、またはアップグレードできない役職まで配布される。どちらが最初に起ころうとも。\nアップグレード可能なスロットがまだ使用可能な場合は、階層化されていない役職も同様に配布される。"
L.scoreboard_voice_tooltip = "音量を変更"

--2021-06-15
L.header_shop_linker = "設定"
L.label_shop_linker_set = "ショップ設定"

--2021-06-18
L.xfer_team_indicator = "陣営"

-- 2021-06-25
L.searchbar_default_placeholder = "検索..."

-- 2021-07-11
L.spec_about_to_revive = "蘇生中のため行動が制限されています。"

-- 2021-09-01
L.spawneditor_name = "スポーンエディタツール"
L.spawneditor_desc = "武器、弾薬やプレイヤーのスポーン位置を設定できます。\nこちらは管理者にしか使用できないため注意。"

L.spawneditor_place = "スポーン位置設置"
L.spawneditor_remove = "スポーン位置削除"
L.spawneditor_change = "スポーンタイプを変更([SHIFT]を押しながらだと逆になります)"
L.spawneditor_ammo_edit = "押しながらだと位置を変更"

L.spawn_weapon_random = "おまかせ武器"
L.spawn_weapon_melee = "近接武器"
L.spawn_weapon_nade = "グレネード"
L.spawn_weapon_shotgun = "ショットガン"
L.spawn_weapon_heavy = "重機関銃"
L.spawn_weapon_sniper = "スナイパー"
L.spawn_weapon_pistol = "ピストル"
L.spawn_weapon_special = "特殊武器"
L.spawn_ammo_random = "おまかせ弾薬"
L.spawn_ammo_deagle = "マグナム弾"
L.spawn_ammo_pistol = "9mm弾"
L.spawn_ammo_mac10 = "SMG弾"
L.spawn_ammo_rifle = "ライフル弾"
L.spawn_ammo_shotgun = "バックショット"
L.spawn_player_random = "プレイヤースポーン"

L.spawn_weapon_ammo = " (弾薬:{ammo})"

L.spawn_weapon_edit_ammo = "[{walkkey}]を押しながら[{primaryfire}又は{secondaryfire}]を押すとこちらのスポーンの弾薬を増加又は減少させることができます。"

L.spawn_type_weapon = "武器スポーン"
L.spawn_type_ammo = "弾薬スポーン"
L.spawn_type_player = "プレイヤースポーン"

L.spawn_remove = "[{secondaryfire}]でこのスポーンを削除"

L.submenu_administration_entspawn_title = "スポーンエディタ"
L.header_entspawn_settings = "設定"
L.button_start_entspawn_edit = "始める"
L.button_delete_all_spawns = "全てのスポーン位置を削除"

L.label_dynamic_spawns_enable = "このマップでの動的スポーンを有効"
L.label_dynamic_spawns_global_enable = "全てのマップのカスタムスポーンを有効"

L.header_equipment_weapon_spawn_setup = "武器スポーン設定"

L.help_spawn_editor_info = [[
スポーンエディタとは、マップ上に武器、弾薬、またはプレイヤーのスポーン位置を自由に設置することができるツールです。
このようなスポーン位置のデータは「data/ttt/weaponspawnscripts/」へ保存されます。ハード リセットの場合は削除できます。
最初のスポーンファイルは、マップ上のスポーンとオリジナルのTTT武器スポーンスクリプトから作成されます。リセットボタンを押すことで元に戻せます。
このスポーンシステムは動的スポーンを使用する点に注意してください。これは、特定の武器ではなく、武器の種類の方を優先します。
例えば、デフォルトからあるショットガンの代わりに、ショットガン系武器がスポーンするようになります。
各武器のスポーン種類は、装備編集で設定できます。これにより、任意の武器がマップ上でスポーンしたり、特定のデフォルトの武器を無効にすることが可能になります。
多くの変更は、新しいラウンドが開始された後にのみ有効になります。]]
L.help_spawn_editor_enable = "マップによっては、動的システムに置き換えることなく、マップに元々設定されてあるスポーン設定を使用することをお勧めします。\nこのチェックボックスを無効にすると、現在有効なマップに対してのみ無効になります。動的システムは、他の全てのマップに対して引き続き使用されます。"
L.help_spawn_editor_hint = "スポーンエディタを終了したい場合は設定画面を再度開いてください。"
L.help_spawn_editor_spawn_amount = [[
このマップには{weapon}個の武器、{ammo}個の弾薬と{player}人のスポーン位置が設定されています。変更したい場合は'始める'を押しましょう。

{weaponrandom}xおまかせ武器
{weaponmelee}x近接武器
{weaponnade}xグレネード
{weaponshotgun}xショットガン
{weaponheavy}x重機関銃
{weaponsniper}xスナイパー
{weaponpistol}xピストル
{weaponspecial}x特殊武器

{ammorandom}xおまかせ弾薬
{ammodeagle}xマグナム弾
{ammopistol}x9mm弾
{ammomac10}xSMG弾
{ammorifle}xライフル弾
{ammoshotgun}xバックショット

{playerrandom}xプレイヤースポーン位置]]

L.equipmenteditor_name_auto_spawnable = "ワールド内にランダムでスポーンするようにする"
L.equipmenteditor_name_spawn_type = "スポーンタイプ選択"
L.equipmenteditor_desc_auto_spawnable = [[
TTT2スポーンシステムは、すべての武器がマップ上でスポーンすることを可能にします。
デフォルトでは、その武器の製作者が「AutoSpawnable」とマークした武器だけマップに生成されますが、
これらの設定はこのメニューから変更できます。ほとんどの装備は、デフォルトで「特殊武器」に設定されています。
つまり、装備がランダム武器のスポーン位置にのみ生成されるということです。しかし、マップ上に特殊な武器のスポーンを配置したり、
他の既存のスポーンタイプを使用するためにここでスポーンタイプを変更することは可能です。]]

L.pickup_error_inv_cached = "インベントリに空きがないため拾うことはできません。"

-- 2021-09-02
L.submenu_administration_playermodels_title = "プレイヤーモデル"
L.header_playermodels_general = "プレイヤーモデル基本設定"
L.header_playermodels_selection = "プレイヤーモデル選択"

L.label_enforce_playermodel = "プレイヤーモデルを固定させる"
L.label_use_custom_models = "おまかせなプレイヤーモデルを選択させる"
L.label_prefer_map_models = "デフォルトプレイヤーモデルよりもマップ固有のプレイヤーモデルを優先"
L.label_select_model_per_round = "新しいプレイヤーモデルを各ラウンドごとに選択(無効の場合はマップ変更時のみ)"

L.help_prefer_map_models = [[
一部のマップは、専用のプレイヤーモデルを固定します。デフォルトでは、
これらのモデルは自動的に割り当てられるモデルより高い優先順位を持ちます。この設定を無効にすると、
マップ特有のモデルが無効になります。
役職固有のモデルはこれらよりも高い優先度を持ち、この設定の影響を受けません。]]

L.help_enforce_playermodel = [[
一部の役職には、カスタムプレイヤーモデルが用意されています。これは、
一部のプレイヤーモデル選択との互換性に関連する可能性があるモデルを無効にすることができます。
この設定が無効になっている場合は、ランダムなデフォルトモデルを選択できます。]]
L.help_use_custom_models = [[
デフォルトでは、全てのプレイヤーに割り当てられるのは CSSフェニックスのプレイヤーモデルのみです。
また、この設定を有効にすると、プレイヤーモデル選択を使用できます。この設定を有効にすると、
全プレイヤーは同じプレイヤーモデルになりますが、固定されたモデルの内のモデルにおまかせでなります。
このプレイヤーモデル選択は、より多くのプレイヤーモデルをインストールすることで拡張できます。]]

-- 2021-10-06
L.menu_server_addons_title = "サーバーアドオン"
L.menu_server_addons_description = "管理者権限を所持する人専用の\nアドオン編集機能です。"

L.tooltip_finish_score_penalty_alive_teammates = "生存チームメイトペナルティ:{score}"
L.finish_score_penalty_alive_teammates = "生存チームメイトペナルティ:"
L.tooltip_kill_score_suicide = "自殺:{score}"
L.kill_score_suicide = "自殺:"
L.tooltip_kill_score_team = "チームキル:{score}"
L.kill_score_team = "チームキル:"

-- 2021-10-09
L.help_models_select = [[
モデルを左クリックして、プレイヤーモデル選択に追加します。それらを削除するにはもう一度左クリック。
右クリックすると、特定のモデルの探偵帽子の有効/無効が切り替わります。
左上の小さなインジケータは、プレーヤーモデルにヘッドショット判定があるかどうかを示します。
下のアイコンは、このモデルが探偵帽子を装着できるのかどうかを示しています。]]

L.menu_roles_title = "役職設定"
L.menu_roles_description = "出現の有無、初期クレジット数などを\n役職ごとに設定できます。"

L.submenu_administration_roles_general_title = "役職基本設定"

L.header_roles_info = "役職情報"
L.header_roles_selection = "比率"
L.header_roles_tbuttons = "Traitorトラップ"
L.header_roles_credits = "初期クレジット数"
L.header_roles_additional = "固有設定"
L.header_roles_reward_credits = "クレジット報酬"

L.help_roles_default_team = "デフォルト陣営:{team}"
L.help_roles_unselectable = "この役職は選択不可能です。つまり、役職を配布するときには含まれていません。ほとんどの場合、復活、Sidekick Deagle、\nまたは似たようなイベントを通じてラウンド中に手動で適用される役職であることを意味します。"
L.help_roles_selectable = "この役職は選択可能です。つまり、全ての基準が満たされている場合、ラウンド開始時にこの役職は配布されます。"
L.help_roles_credits = "クレジットは、ショップでアイテムを購入するための物です。ショップを使用できる役職は限定されています。\nまた、死体からクレジットをもらうことができ、敵を倒すと報酬でクレジットが与えられます。"
L.help_roles_selection_short = "プレイヤー一人あたりの役職配分は、この役職が割り当てられているプレイヤーの割合を定義します。\n例えば、値が'0.2'に設定されている場合、5番目のプレイヤーがこの役職を受け取ります。"
L.help_roles_selection = [[
プレイヤー一人あたりの役職配分は、この役職が割り当てられているプレイヤーの割合を定義します。
例えば、値が'0.2'に設定されている場合、5番目のプレイヤーがこの役職を受け取ります。
この役職が選択されるには、少なくとも5人のプレイヤーが必要です。
このすべては、役職が選択対象と見なされる場合にのみ適用されます。
前述の役職配布は、プレイヤーの下限との特別な統合を持っています。
役職が選択対象と見なされ、最小値は分布係数によって指定された値を下回っていますが、
プレイヤー人数が下限以上の場合、1人のプレイヤーがこの役職を引き続き受けることができます。
この役職を受け取る2番目のプレイヤーの配布設定は、再度trueになります。]]
L.help_roles_award_info = "一定の割合の敵が死亡した場合、一部の役職(クレジット設定で有効になっている場合)はクレジットを受け取ります。これらの値は、こちらで調整できます。"
L.help_roles_award_pct = "他のプレイヤーの内この割合が死んでいるとき、プレイヤーはより多くのクレジットを授与されます。"
L.help_roles_award_repeat = "クレジット報酬自体の回数。例えば、パーセンテージを「0.25」に設定してこれを有効にすると、\nプレイヤーは「25%」が死亡、「50%」が死亡、「75%」が死亡した時にクレジットが授与されます。"
L.help_roles_advanced_warning = "警告:これらは、あなたの役職選択を完全に台無しにすることができる高度な設定です。疑わしい場合は、\nすべての値を'0'にすることをお勧めします。この値は、制限が適用されず、役職の選択ができるだけ多くの役職を割り当てようとしていることを意味します。"
L.help_roles_max_roles = [[
役職カテゴリには、TTT2のすべてのロールが含まれています。デフォルトでは、割り当て可能な、異なる役職の数に制限はありません。ただし、それらを制限する2つの異なる方法があります。

1. 固定数で制限
2. パーセンテージで制限

後者は、固定値が「0」の場合にのみ使用され、利用可能なプレイヤーの設定されたパーセンテージに基づいて上限を設定します。]]
L.help_roles_max_baseroles = [[
基本役職は、他のユーザーが継承する役職のみです。例えば、Innocentは基本役職ですが、Pharaohはこの役職のサブ役職です。
デフォルトでは、割り当て可能な異なる基本役職の数に制限はありません。ただし、それらを制限する2つの異なる方法があります。

1. 固定数で制限
2. パーセンテージで制限

後者は、固定値が「0」の場合にのみ使用され、利用可能なプレイヤーの設定されたパーセンテージに基づいて上限を設定します。]]

L.label_roles_enabled = "追加する"
L.label_roles_min_inno_pct = "比率"
L.label_roles_pct = "比率"
L.label_roles_max = "追加されるこの役職の数"
L.label_roles_random = "選択確率"
L.label_roles_min_players = "追加されるために必要な最低人数"
L.label_roles_tbutton = "Traitorトラップ"
L.label_roles_credits_starting = "初期クレジット数"
L.label_roles_credits_award_pct = "報酬クレジット比率"
L.label_roles_credits_award_size = "報酬クレジット数"
L.label_roles_credits_award_repeat = "報酬の回数"
L.label_roles_newroles_enabled = "カスタム役職を有効"
L.label_roles_max_roles = "役職上限"
L.label_roles_max_roles_pct = "カスタム役職比率"
L.label_roles_max_baseroles = "基本役職上限"
L.label_roles_max_baseroles_pct = "基本役職比率"
L.label_detective_hats = "探偵用帽子を装着(モデルによって無効になる時があります)"

L.ttt2_desc_innocent = "何も特徴がなく、あるのは己の銃スキルと推理能力のみ。テロリストたちに紛れている裏切り者を探して殺しましょう！\nしかし、仲間は殺さないように注意が必要ですよ。"
L.ttt2_desc_traitor = "テロリストたちに紛れている裏切者。専用のショップから特殊アイテムを購入することができます。\nそれを用いながら、仲間と力を合わせて敵を皆殺しにしましょう。"
L.ttt2_desc_detective = "Innocent陣営に所属し、唯一の確白。専用のショップから特殊アイテムを購入することができます。\nそれを用いながら、誰がTraitorなのか推理して勝利へ導きましょう。"

-- 2021-10-10
L.button_reset_models = "リセット"

-- 2021-10-13
L.help_roles_credits_award_kill = "クレジットを獲得するもう一つの方法は、Detectiveのような確白の役職のプレイヤーを殺すことです。\nそうすることで、以下の設定されたクレジット数を得ます。"
L.help_roles_credits_award = [[
基本的に、TTT2でクレジットを得るには、次の2つの方法があります。

1. 敵チームの一定の割合が死んだ場合、チーム全体にクレジットが与えられる
2. プレイヤーがDetectiveのような確白の役職を殺した場合、殺害者に与えられる

チーム全体が授与された場合でも、この機能は、すべての役職で有効/無効にすることができます。例えば、
Innocent陣営に授与される時、Innocentがこの設定で無効になっている場合、Detectiveだけがクレジットを受け取ります。
この機能のバランスの値は、「管理者用設定」->「基本役職設定」で設定できます。]]
L.help_detective_hats = [[
Detectiveなどの役職は、彼らの権限を示すかのように帽子をかぶります。死亡、または頭に傷を負った場合に帽子を失います。
一部のプレイヤーモデルは、デフォルトでは帽子装着には対応しておりません。「管理者用設定」->「プレイヤーモデル」から設定できます。]]

L.label_roles_credits_award_kill = "クレジット報酬"
L.label_roles_credits_dead_award = "一定の割合の敵の死亡によるクレジット報酬を有効"
L.label_roles_credits_kill_award = "Detectiveのような役職の殺害によるクレジット報酬を有効"
L.label_roles_min_karma = "選択を検討するカルマの下限"

-- 2021-11-07
L.submenu_administration_administration_title = "管理"
L.submenu_administration_voicechat_title = "ボイスチャット/テキストチャット"
L.submenu_administration_round_setup_title = "ラウンドセットアップ"
L.submenu_administration_mapentities_title = "マップエンティティ"
L.submenu_administration_inventory_title = "インベントリ"
L.submenu_administration_karma_title = "カルマ"
L.submenu_administration_sprint_title = "走行"
L.submenu_administration_playersettings_title = "プレイヤー設定"

L.header_roles_special_settings = "特殊役職設定"
L.header_equipment_additional = "追加装備設定"
L.header_administration_general = "管理基本設定"
L.header_administration_logging = "記録"
L.header_administration_misc = "その他"
L.header_entspawn_plyspawn = "プレイヤースポーン設定"
L.header_voicechat_general = "ボイスチャット基本設定"
L.header_voicechat_battery = "ボイスチャットバッテリー"
L.header_voicechat_locational = "ロケーションボイスチャット"
L.header_playersettings_plyspawn = "プレイヤースポーン設定"
L.header_round_setup_prep = "ラウンド:準備中"
L.header_round_setup_round = "ラウンド:継続中"
L.header_round_setup_post = "ラウンド:終了"
L.header_round_setup_map_duration = "マップセッション"
L.header_textchat = "テキストチャット"
L.header_round_dead_players = "死人設定"
L.header_administration_scoreboard = "スコアボード設定"
L.header_hud_toggleable = "切り替え可能なHUD要素"
L.header_mapentities_prop_possession = "オブジェクト憑依"
L.header_mapentities_doors = "ドア"
L.header_karma_tweaking = "カルマ調整"
L.header_karma_kick = "カルマキックとBAN"
L.header_karma_logging = "カルマ記録"
L.header_inventory_gernal = "インベントリの大きさ"
L.header_inventory_pickup = "インベントリへの武器拾得"
L.header_sprint_general = "走行設定"
L.header_playersettings_armor = "アーマーシステム設定"

L.help_killer_dna_range = "プレイヤーが他のプレイヤーに殺されると、DNAが自分の体に残されます。最大範囲の設定は、\n残されたDNAサンプルの最大距離をハンマー単位で定義します。殺人犯がさらに離れている場合、死体にサンプルは残っていません。"
L.help_killer_dna_basetime = "DNAサンプルが消滅するまでの時間(秒)。殺害者までの距離の係数は、この基準時間により変化します。"
L.help_dna_radar = "TTT2版DNAスキャナーは、選択したDNAサンプルの正確な距離と方向を示します(装備されている場合のみ)。\nただし、クールダウンが経過する度に、選択したサンプルをマップのレンダリングで更新する従来のDNAスキャナーモードもあります。"
L.help_idle = "放置状態のプレイヤーを強制的に観戦状態に移動させるための機能です。この状態を再度終了するには、「ゲーム設定」の「観戦者モード」を無効にする必要があります。"
L.help_namechange_kick = [[
プレイヤーがラウンド中に名前を変更した場合、これは殺されるのを避けるために悪用される可能性があります。
そのため、ラウンド開始中にニックネームを変更することは禁止されています。
禁止時間が0より大きい場合、プレイヤーはその時間が経過するまでサーバーに再接続できません。]]
L.help_damage_log = "プレーヤーがダメージを受けるたびに、有効になっている場合は、ダメージログエントリがコンソールに追加されます。\nラウンド終了後にディスクに保存することもできます。ファイルは「data/terrortown/log/」に保存されています。"
L.help_spawn_waves = [[
0に設定すると、すべてのプレイヤーが一度にスポーンされます。大人数のプレイヤーがいるサーバーでは、ウェーブ間隔でプレイヤーをスポーンさせるのが良いでしょう。
スポーンウェーブ間隔は、各スポーンウェーブの間の時間です。スポーンウェーブは、スポーンポイントの数だけプレイヤーをスポーンさせます。
注意 : 準備時間が希望する量のスポーンウェーブに十分な長さであることを確認してください。]]
L.help_voicechat_battery = [[
音声チャットが有効な音声チャットバッテリーで、このメーターを減らします。空の場合、プレイヤーはチャットを音声にすることはできませんし、
チャージするためには数秒待つ必要があります。これは主に過度のボイスチャットの使用を防ぐのに役立ちます。
注意 :「チック」とは、ゲームのチックを指します(1/66秒)。]]
L.help_ply_spawn = "プレイヤーリスポーンで使用されるプレイヤーのパラメータ。"
L.help_haste_mode = [[
HASTEモードは、プレイヤーが一人死亡するたびのラウンド時間追加により、ゲームのバランスを取ります。
Traitor陣営の役職、又は観戦者のみが、実際のラウンド時間を見ることができます。他の役職は見れません。
HASTEモードが有効になっている場合、通常ラウンド時間は無視されます。]]
L.help_round_limit = "設定された制限条件の1つが満たされると、マップ変更が開始されます。"
L.help_armor_balancing = "アーマーのバランス調整ができる機能です。"
L.help_item_armor_classic = "クラシックアーマーモードは、プレイヤーがラウンドで一度だけボディアーマーを購入することができ、\nアーマーは弾丸とバールによるダメージの30%を軽減できます。"
L.help_item_armor_dynamic = [[
動的アーマーモードは購入できるアーマーの量は無制限で、アーマー値の重複が可能なモードです。
ダメージを受けると、アーマーの値が減少します。購入したアーマーの耐久値は、上記項目の「装備設定」に設定されています。
ダメージを受けると、このダメージの一定の割合だけアーマーへのダメージに変換され、プレイヤーに対しては異なる割合が適用され、残りは消滅します。
強化アーマーが有効な場合、耐久値が補強しきい値を超える限り、プレイヤーに与えるダメージは15%減少します。]]
L.help_sherlock_mode = "シャーロックモードは、古典的なTTTモードです。シャーロックモードが無効になっている場合、\n死体は確認できず、スコアボードは生きている全ての人を示し、観戦者は生存者と会話が可能です。"
L.help_prop_possession = [[
オブジェクト憑依は、観戦者がマップに存在するオブジェクトに憑依し、
ゆっくりとチャージされていく「パンチ・オー・メーター」を使用して、そのオブジェクトを操作できる機能です。
「パンチ・オー・メーター」の最大値は、2つの定義された制限の間に遮断された死量/死の差が追加される基本的憑依値で構成されています。
メーターは時間の経過とともにゆっくりチャージされます。セットの再チャージ時間は、「パンチ・オー・メーター」の単一ポイントをチャージするのに必要な時間です。]]
L.help_karma = "カルマは無差別殺害を減らすための機能です。プレイヤーは一定のカルマから始まり、チームメイトにダメージを与える、又は殺すと減っていきます。\n減少量は、与えたダメージ量や、殺害数に応じて変化します。カルマが少ないほど与えるダメージが減っていきます。"
L.help_karma_strict = "厳密なカルマが有効になっている場合、カルマが減少するとダメージペナルティが増加します。無効の場合、\nプレイヤーがカルマ値800を超えていると、ダメージペナルティはかなり低くなります。厳密なカルマモードを有効にすると、\nカルマは不必要なキルを阻止する上でより大きな役割を果たし、それを無効にすると、カルマは常にチームキルするプレイヤーを傷つけるだけの緩いゲームになります。"
L.help_karma_max = "1000以上の最大値カルマの値を設定しても、その1000カルマ以上のプレイヤーにダメージボーナスは与えられません。カルマバッファーとして使用できます。"
L.help_karma_ratio = "両者が同じ陣営にいる場合に、カルマを加害者から差し引く量を計算するためのダメージ比率。チームキルが発生した場合は、さらにペナルティが適用されます。"
L.help_karma_traitordmg_ratio = "両者が異なる陣営にいる場合に、加害者のカルマの量を攻撃者から差し引く計算するためのダメージ比率。\nチームキルが発生した場合は、さらにボーナスが適用されます。"
L.help_karma_bonus = "ラウンド中にカルマを獲得する2つの異なる受動的な方法もあります。まず、ラウンド復帰はすべてのプレイヤーに適用されます。\nその後、チームメイトがダメージを受けなかったり殺されたりしなかった場合、二次的な整理ボーナスが与えられます。"
L.help_karma_clean_half = [[
プレイヤーのカルマが開始レベルを超えている場合(カルマの最大値がそれより高く設定されている場合)、\nカルマがその開始レベルをどれだけ上回っているかによって、全てのカルマの増加が減少。高いほど遅く上がります。\nこの減少は指数的な減衰の曲線に入ります。最初は速く増分が小さくなるにつれて減速します。この設定は、ボーナスが半分になった時点で設定されます(所謂半減期)。\nデフォルト値が0.25だと、カルマの開始量が1000と最大1500 で、プレイヤーがカルマ 1125 ((1500 - 1000) * 0.25 = 125 を持つ場合、\nラウンド整理ボーナスは30/2 = 15になります。つまり、ボーナスをより速く下げるために、この設定を低く設定し、それが遅くなるように、1に向かってそれを増やすでしょう。]]
L.help_max_slots = "スロットあたりの武器の最大量を設定します。'-1' は制限がないということです。"
L.help_item_armor_value = "これは、ダイナミックモードでアーマーアイテムによって与えられるアーマー値です。クラシックモードが\n有効になっている場合(「管理」->'プレイヤー設定'を参照)、0より大きいすべての値が既存のアーマーとしてカウントされます。"

L.label_killer_dna_range = "DNAが残る最大殺害距離"
L.label_killer_dna_basetime = "DNAサンプル基本的残存時間"
L.label_dna_scanner_slots = "DNAサンプルスロット"
L.label_dna_radar = "従来のDNAスキャナモード有効"
L.label_dna_radar_cooldown = "DNAスキャナークールダウン"
L.label_radar_charge_time = "レーダーサンプル後のチャージ時間"
L.label_crowbar_shove_delay = "再度バールで押せるまでのクールダウン"
L.label_idle = "放置状態を有効"
L.label_idle_limit = "放置時間になるまでの時間(秒)"
L.label_namechange_kick = "名前変更したら自動的にキック"
L.label_namechange_bantime = "キック後の禁止時間(分)"
L.label_log_damage_for_console = "コンソール上のダメージログを有効"
L.label_damagelog_save = "ダメージログをディスクに保存する"
L.label_debug_preventwin = "勝利させないようにする[デバッグ]"
L.label_bots_are_spectators = "Botは観戦者状態にする"
L.label_tbutton_admin_show = "管理者側にTraitorトラップを表示"
L.label_ragdoll_carrying = "Ragdollの運搬を有効"
L.label_prop_throwing = "オブジェクトを投げることを有効"
L.label_ragdoll_pinning = "Innocent以外の役職に対してRagdollの張り付けを有効"
L.label_ragdoll_pinning_innocents = "InnocentのRagdollの張り付けを有効"
L.label_weapon_carrying = "武器の運搬を有効"
L.label_weapon_carrying_range = "武器を運べるまでの距離"
L.label_prop_carrying_force = "オブジェクト拾得力"
L.label_teleport_telefrags = "テレポートした瞬間にテレポート位置にいる人を自動的に殺害"
L.label_allow_discomb_jump = "ディスコンボビュレーターによるジャンプ"
L.label_spawn_wave_interval = "スポーンウェーブインターバル(秒)"
L.label_voice_enable = "ボイスチャットの有無"
L.label_voice_drain = "ボイスチャットのバッテリーの有無"
L.label_voice_drain_normal = "通常プレイヤーのボイスチャットのバッテリーのチックあたりの減少値"
L.label_voice_drain_admin = "管理者および確白役職のボイスチャットのバッテリーのチックあたりの減少値"
L.label_voice_drain_recharge = "ボイスチャットではないチックあたりのチャージ率"
L.label_locational_voice = "生存者の3Dボイスチャット音を有効"
L.label_armor_on_spawn = "全プレイヤーアーマー装着"
L.label_prep_respawn = "ラウンド準備中時のリスポーンを有効"
L.label_preptime_seconds = "ラウンド準備時間(秒)"
L.label_firstpreptime_seconds = "初めのラウンド準備時間(秒)"
L.label_roundtime_minutes = "通常ラウンド時間(分)"
L.label_haste = "Hasteモード有効"
L.label_haste_starting_minutes = "Hasteモード有の場合のラウンド時間(分)"
L.label_haste_minutes_per_death = "一人死ぬごとに追加される時間(分)"
L.label_posttime_seconds = "ラウンド終了時間"
L.label_round_limit = "ラウンド最大数"
L.label_time_limit_minutes = "ラウンド時間の上限(分)"
L.label_nade_throw_during_prep = "ラウンド準備時間中のグレネード投擲を可能にする"
L.label_postround_dm = "ラウンド終了時間中のデスマッチを有効"
L.label_spectator_chat = "観戦者同士でのチャットの有無"
L.label_lastwords_chatprint = "タイピング中に殺されたら遺言を送信する"
L.label_identify_body_woconfirm = "'確認'ボタン無しで死体を特定"
L.label_announce_body_found = "死体発見時の報告"
L.label_confirm_killlist = "確認済みの死体のリストの報告"
L.label_inspect_detective_only = "死体検査を確白役職にしかできないようにする"
L.label_confirm_detective_only = "死体確認を確白役職にしかできないようにする"
L.label_dyingshot = "アイアンサイト中で死に撃つ[実験的]"
L.label_armor_block_headshots = "ヘッドショットへの耐久"
L.label_armor_block_blastdmg = "爆破ダメージへの耐久"
L.label_armor_dynamic = "動的アーマー"
L.label_armor_value = "アーマーをショップの方のアーマーでもらえるようにする"
L.label_armor_damage_block_pct = "アーマー自体がダメージ比率"
L.label_armor_damage_health_pct = "プレイヤーが受けるダメージ比率"
L.label_armor_enable_reinforced = "強化アーマーを有効"
L.label_armor_threshold_for_reinforced = "強化アーマーのしきい値"
L.label_sherlock_mode = "シャーロックモードを有効"
L.label_highlight_admins = "サーバー管理者のハイライト"
L.label_highlight_dev = "TTT2開発者ハイライト"
L.label_highlight_vip = "VIPのハイライト"
L.label_highlight_addondev = "TTT2アドオン開発者のハイライト"
L.label_highlight_supporter = "他のサポーターのハイライト"
L.label_enable_hud_element = "{elem}のHUD要素を有効"
L.label_spec_prop_control = "オブジェクト憑依"
L.label_spec_prop_base = "基本的憑依価値"
L.label_spec_prop_maxpenalty = "憑依ボーナス最低制限"
L.label_spec_prop_maxbonus = "上限所有ボーナス限度額"
L.label_spec_prop_force = "オブジェクト憑依のプッシュ力"
L.label_spec_prop_rechargetime = "再チャージ時間(秒)"
L.label_doors_force_pairs = "二重ドアとして強制的に閉じる"
L.label_doors_destructible = "ドアの損傷を有効"
L.label_doors_locked_indestructible = "鍵がかかっているドアへの破壊ができないようにする"
L.label_doors_health = "ドアの体力"
L.label_doors_prop_health = "ドア系オブジェクトの体力"
L.label_minimum_players = "ラウンド開始に必要な最低人数"
L.label_karma = "カルマを有効"
L.label_karma_strict = "厳密なカルマを有効にする"
L.label_karma_starting = "初期カルマ"
L.label_karma_max = "カルマ最大値"
L.label_karma_ratio = "チームへのダメージによるカルマ減少率"
L.label_karma_kill_penalty = "チームキルによるカルマ減少率"
L.label_karma_round_increment = "ラウンド復帰"
L.label_karma_clean_bonus = "ラウンド整理ボーナス"
L.label_karma_traitordmg_ratio = "敵ダメージによるボーナス"
L.label_karma_traitorkill_bonus = "敵のキルボーナス"
L.label_karma_clean_half = "カルマ整理による削減"
L.label_karma_persist = "カルマはマップの変更後でも持続"
L.label_karma_low_autokick = "低カルマ値の人を自動でキック"
L.label_karma_low_amount = "低カルマ値のしきい値"
L.label_karma_low_ban = "BANされるまでのカルマ値"
L.label_karma_low_ban_minutes = "BAN継続時間"
L.label_karma_debugspam = "カルマの変更に関するコンソールへのデバッグ出力を有効にする"
L.label_max_melee_slots = "近接武器スロット最大値"
L.label_max_secondary_slots = "セカンダリー武器スロット最大値"
L.label_max_primary_slots = "プライマリー武器スロット最大値"
L.label_max_nade_slots = "グレネード系スロット最大値"
L.label_max_carry_slots = "運搬系スロット最大値"
L.label_max_unarmed_slots = "無防備スロット最大値"
L.label_max_special_slots = "特殊アイテムスロット最大値"
L.label_max_extra_slots = "その他スロット最大値"
L.label_weapon_autopickup = "自動で武器を拾う"
L.label_sprint_enabled = "走行を有効"
L.label_sprint_max = "走行用スタミナ最大値"
L.label_sprint_stamina_consumption = "スタミナ消費率"
L.label_sprint_stamina_regeneration = "スタミナ再生率"
L.label_sprint_crosshair = "走行中のクロスヘアの表示"
L.label_crowbar_unlocks = "バールによる鍵解除"
L.label_crowbar_pushforce = "バールで押す力"
