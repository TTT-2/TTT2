-- Japanese language strings

local L = LANG.CreateLanguage("ja")

-- Compatibility language name that might be removed soon.
-- the alias name is based on the original TTT language name:
-- - does not exist -
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
L.win_nones = "蜂の勝利！（つまり引き分け）"
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

L.disg_help1 = "変装している時、誰かがあなたを見てもあなたの名前、体力とカルマは表示されない。また、Detectiveのレーダーにも反応されないだろうな。"
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

L.item_armor = "ボディアーマー"
L.item_armor_desc = [[
弾丸、炎、爆発によるダメージを軽減。延長時間になったら使い物にならない。

複数の購入が可能。ある特定の装甲値に達した後、アーマーは強化される。]]

L.item_radar = "レーダー"
L.item_radar_desc = [[
生命反応を捉えることができる。

購入するとすぐに自動で探知してくれる。 設定はCキーのレーダーメニューから。]]

L.item_disg = "変装装置"
L.item_disg_desc = [[
変装中はあなたのID情報を隠せる。 さらに、獲物が最期に目撃した人物になるのも避けれる。

このメニューの変装メニュー内かテンキーのEnterで切り替えれる。]]

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
L.vis_name = "可視化装置"
L.vis_hint = "{usekey}で拾う（探偵のみ）"

L.vis_desc = [[
殺害現場を可視化してくれる機械だ。

死体を分析して被害者がどのように殺害されたかを表示するが、被害者が銃撃の傷で死んだ場合のみだ。]]

-- Decoy
L.decoy_name = "デコイ"
L.decoy_no_room = "この狭い所ではデコイは持てないようだ。"
L.decoy_broken = "デコイが破壊された！"

L.decoy_short_desc = "このデコイは別陣営のレーダーに偽のレーダー反応を示してくれるぞ。"
L.decoy_pickup_wrong_team = "別陣営からのデコイを拾うことはできないぞ。"

L.decoy_desc = [[
Detectiveに偽のレーダー反応を表示させ、彼らがあなたのDNAをスキャンしていた場合は彼らのDNAスキャナーがデコイの場所を表示するようにしてくれる。]]

-- Defuser
L.defuser_name = "除去装置"
L.defuser_help = "{primaryfire}でC4除去"

L.defuser_desc = [[
C4爆弾を即座に除去する。

使用回数は無制限。これさえ持っていればC4に気がつくのに容易だろう。]]

-- Flare gun
L.flare_name = "信号拳銃"

L.flare_desc = [[
死体を燃やすことができる。証拠隠滅に必須。弾は限られているので注意。

燃えている死体からは大きな燃焼音を発するので注意。]]

-- Health station
L.hstation_name = "回復ステーション"

L.hstation_broken = "回復ステーションが破壊された！"
L.hstation_help = "{primaryfire}で回復ステーション設置"

L.hstation_desc = [[
回復が可能な設置型の機械。

チャージは遅い。誰でも使用することができるが、耐久力があるので注意。使用者のDNAサンプルをチェックすることができる。]]

-- Knife
L.knife_name = "ナイフ"
L.knife_thrown = "ナイフ投擲"

L.knife_desc = [[
怪我した者なら即座に静かに始末できるが、一度しか使用できない。

オルトファイアで投げることができる。]]

-- Poltergeist
L.polter_desc = [[
オブジェクトにThumperを設置すると、使用者の意志に関係なくそのオブジェクトが暴れまわる。

暴れ終わった後のThumperの爆発は近くの人間にダメージを与える。]]

-- Radio
L.radio_broken = "ラジオが破壊された！"
L.radio_help_pri = "{primaryfire}でラジオを置く"

L.radio_desc = [[
注意を逸らしたり欺くために音を再生できる。

どこか適当な場所にラジオを置いてから、ショップメニュー内のラジオメニューから音を再生できる。]]

-- Silenced pistol
L.sipistol_name = "消音ピストル"

L.sipistol_desc = [[
サプレッサー付きのハンドガン。通常のピストルの弾丸を使用する。

撃たれた犠牲者は悲鳴をあげることはないだろう。]]

-- Newton launcher
L.newton_name = "ニュートンランチャー"

L.newton_desc = [[
遠距離からでも人を弾き飛ばせる弾を発射する。

弾は無制限だが、次の弾を発射するのに時間がかかる。]]

-- Binoculars
L.binoc_name = "双眼鏡"

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
L.tele_name = "テレポーター"
L.tele_failed = "テレポートに失敗した。"
L.tele_marked = "テレポート位置を設定した。"

L.tele_no_ground = "安定した足場に立つまではテレポートはできないぞ！"
L.tele_no_crouch = "しゃがんでいるとテレポートはできないぞ！"
L.tele_no_mark = "設定した場所がないようだ。テレポートする前に移動先を設定するんだ。"

L.tele_no_mark_ground = "安定した足場に立つまではテレポート位置を設定することはできないぞ！"
L.tele_no_mark_crouch = "しゃがんでいるとテレポート位置を設定することができないぞ！"

L.tele_help_pri = "{primaryfire}で設定した場所にテレポートする"
L.tele_help_sec = "{secondaryfire}で現在地を設定する"

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

-- Big title window
L.hilite_win_traitors = "Traitor陣営の勝利"
L.hilite_win_none = "蜂側の勝利"
L.hilite_win_innocent = "Innocent陣営の勝利"

L.hilite_players1 = "{numplayers}人のプレイヤーが参加して、彼らの内{numtraitors}人がTraitorだった。"
L.hilite_players2 = "{numplayers}人のプレイヤーが参加して、彼らの内1人だけTraitorだった。"

L.hilite_duration = "ラウンドが終わるのに{time}秒かかった。"

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

L.confgrenade_name = "Discombobulator"
L.polter_name = "ポルターガイスト"
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
L.tbut_help_admin = "traitor button設定を編集する"
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

L.menu_changelog_description = "今までのバージョンの更新点や変更点を閲覧できます。"
L.menu_guide_description = "TTT2が初めての方への説明や遊び方、役職、スタッフを紹介します。"
L.menu_bindings_description = "TTT2用の特定の機能、またはそれ対応のアドオン関連のキーを設定できます。"
L.menu_language_description = "言語を設定できます。"
L.menu_appearance_description = "外見やユーザーインターフェイスを微調整できます。"
L.menu_gameplay_description = "ある役職になることを避けたりなど、そのほか微調整ができます。"
L.menu_addons_description = "好きなように現在導入されているアドオン構成ができます。"
L.menu_legacy_description = "旧TTTのように設定ができる。その設定はTTT2にも適用されます。"
L.menu_administration_description = "HUD、ショップ、その他の設定ができます。"
L.menu_equipment_description = "クレジット設定、使用制限、使用可能なのか不可能なのかなど設定ができます。"
L.menu_shops_description = "役職へのショップの追加/削除と、その中のアイテム設定ができます。"

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

L.help_color_desc = "この設定からは、ターゲットのID、アウトラインとクロスヘアに使用されるグローバルカラーを選択できます。"
L.help_scale_factor = "この倍率は、すべてのUI要素に影響を与えます（例えばHUD、VguiやターゲットID）。画面の解像度が変更されると、自動的に更新されます。この値を変更するとHUDがリセットされます。"
L.help_hud_game_reload = "そのHUDは現在適用されていません。ゲームを再起動しよう。"
L.help_hud_special_settings = "このHUDにはそれ特有の設定があるようです。"
L.help_vskin_info = "Vスキン（vguiスキン）は、現在のメニュー要素と同様に、すべてのメニュー要素に適用されるスキンです。スキンは簡単なluaスクリプトで簡単に作成でき、色やいくつかのサイズのパラメータを変更できます。"
L.help_targetid_info = "ターゲットIDは、エンティティに焦点を設定するときに表示される情報です。基本設定パネルで固定色を設定できます。"
L.help_hud_default_desc = "すべてのプレイヤーにデフォルトのHUDを設定します。HUDをまだ選択していないプレイヤーは、デフォルトとしてこのHUDが適用されます。これにより、HUDを選択済みのプレイヤーのHUDは変更されません。"
L.help_hud_forced_desc = "すべてのプレイヤーにHUDを強制します。これにより、すべてのユーザーに対してHUD選択機能が無効になります。"
L.help_hud_enabled_desc = "これらのHUDの選択を制限するには、HUDを有効/無効にします。"
L.help_damage_indicator_desc = "ダメージインジケーターは、プレイヤーが損傷したときに表示されるオーバーレイです。新しいテーマを追加するときは、画像を「materials/vgui/ttt/damageindicator/themes/」に保存してください。"
L.help_shop_key_desc = "ラウンド終了時/準備中にスコアメニューの代わりにショップキーを押してアイテムショップを開きますか？"

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
L.label_gameplay_dtsprint_anykey = "止まるまでダブルタップ走行を止めれません"
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
L.header_roleselection = "役職割り当て有効"
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
--L.title_score_info = "Round End Info"
--L.title_score_events = "Event Timeline"

--L.label_bind_clscore = "Opend round end screen"
--L.title_player_score = "{player}'s score:"

--L.label_show_events = "Show events from"
--L.button_show_events_you = "You"
--L.button_show_events_global = "Global"
--L.label_show_roles = "Show role distribution from"
--L.button_show_roles_begin = "Round Begin"
--L.button_show_roles_end = "Round End"

--L.hilite_win_traitors = "TEAM TRAITOR WON"
--L.hilite_win_innocents = "TEAM INNOCENT WON"
--L.hilite_win_tie = "IT IS A TIE"
--L.hilite_win_time = "TIME IS UP"

--L.tooltip_karma_gained = "Karma gained this round:"
--L.tooltip_score_gained = "Score gained this round:"
--L.tooltip_roles_time = "Roles over time:"

--L.tooltip_finish_score_alive_teammates = "Alive teammates: {score}"
--L.tooltip_finish_score_alive_all = "Alive players: {score}"
--L.tooltip_finish_score_timelimit = "Time is up: {score}"
--L.tooltip_finish_score_dead_enemies = "Dead enemies: {score}"
--L.tooltip_kill_score = "Kill: {score}"
--L.tooltip_bodyfound_score = "Bodyfound: {score}"

--L.finish_score_alive_teammates = "Alive teammates:"
--L.finish_score_alive_all = "Alive players:"
--L.finish_score_timelimit = "Time is up:"
--L.finish_score_dead_enemies = "Dead enemies:"
--L.kill_score = "Kill:"
--L.bodyfound_score = "Bodyfound:"

--L.title_event_bodyfound = "A body was found"
--L.title_event_c4_disarm = "A C4 charge was disarmed"
--L.title_event_c4_explode = "A C4 charge exploded"
--L.title_event_c4_plant = "A C4 charge was planted"
--L.title_event_creditfound = "Equipment credits were found"
--L.title_event_finish = "The round has ended"
--L.title_event_game = "A new round has started"
--L.title_event_kill = "A player was killed"
--L.title_event_respawn = "A player respawned"
--L.title_event_rolechange = "A player changed their role or team"
--L.title_event_selected = "The roles were selected"
--L.title_event_spawn = "A player spawned"

--L.desc_event_bodyfound = "{finder} ({firole} / {fiteam}) has found the body of {found} ({forole} / {foteam}). The corpse has {credits} equipment credit(s)."
--L.desc_event_bodyfound_headshot = "The dead player was killed by a headshot."
--L.desc_event_c4_disarm_success = "{disarmer} ({drole} / {dteam}) successfully disarmed the C4 placed by {owner} ({orole} / {oteam})."
--L.desc_event_c4_disarm_failed = "{disarmer} ({drole} / {dteam}) tried to disarm the C4 placed by {owner} ({orole} / {oteam}). They failed."
--L.desc_event_c4_explode = "The C4 placed by {owner} ({role} / {team}) exploded."
--L.desc_event_c4_plant = "{owner} ({role} / {team}) placed an explosive C4."
--L.desc_event_creditfound = "{finder} ({firole} / {fiteam}) has found {credits} equipment credit(s) in the corpse of {found} ({forole} / {foteam})."
--L.desc_event_finish = "The round lasted {minutes}:{seconds}. There were {alive} player(s) alive in the end."
--L.desc_event_game = "A new round has started."
--L.desc_event_respawn = "{player} has respawned."
--L.desc_event_rolechange = "{player} changed their role/team from {orole} ({oteam}) to {nrole} ({nteam})."
--L.desc_event_selected = "The teams and roles were selected for all {amount} player(s)."
--L.desc_event_spawn = "{player} has spawned."

-- Name of a trap that killed us that has not been named by the mapper
L.trap_something = "何か"

-- Kill events
--L.desc_event_kill_suicide = "It was suicide."
--L.desc_event_kill_team = "It was a team kill."

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
--L.none = "No Role"

-- 2021-04-24
--L.karma_teamkill_tooltip = "Teamkills"
--L.karma_teamhurt_tooltip = "Team damaged"
--L.karma_enemykill_tooltip = "Enemykills"
--L.karma_enemyhurt_tooltip = "Enemy damaged"
--L.karma_cleanround_tooltip = "Clean round"
--L.karma_roundheal_tooltip = "Roundheal"
--L.karma_unknown_tooltip = "Unknown"

-- 2021-05-07
--L.header_random_shop_administration = "Setup Random Shop"
--L.header_random_shop_value_administration = "Balance Settings"

--L.shopeditor_name_random_shops = "Enable random shops"
--L.shopeditor_desc_random_shops = [[Random shops give every player only a limited randomized set of all available equipments.
--Team shops force all players in one team to have the same set instead of individual ones.
--Rerolling allows you to get a new randomized set of equipment for credits.]]
--L.shopeditor_name_random_shop_items = "Number of random equipments"
--L.shopeditor_desc_random_shop_items = "This includes equipments, which are marked with .noRandom. So choose a high enough number or you only get those."
--L.shopeditor_name_random_team_shops = "Enable team shops"
--L.shopeditor_name_random_shop_reroll = "Enable shop reroll availability"
--L.shopeditor_name_random_shop_reroll_cost = "Cost per reroll"
--L.shopeditor_name_random_shop_reroll_per_buy = "Auto reroll after buy"

-- 2021-06-04
--L.header_equipment_setup = "Setup Equipment"
--L.header_equipment_value_setup = "Balance Settings"

--L.itemeditor_name_not_buyable = "Equipment buyable"
--L.itemeditor_desc_not_buyable = "If disabled the equipment will not show in the shop. Roles that have this equipment assigned will still receive it."
--L.itemeditor_name_not_random = "Aways available in shop"
--L.itemeditor_desc_not_random = "If enabled, the equipment is always available in the shop. This is relevant when using the random shop. It takes one available random slot and always reserves it for this equipment."
--L.itemeditor_name_global_limited = "Global limited amount"
--L.itemeditor_desc_global_limited = "If equipment is global limited, it can be bought only once on the server in the active round."
--L.itemeditor_name_team_limited = "Team limited amount"
--L.itemeditor_desc_team_limited = "If equipment is team limited, it can be bought only once per team in the active round."
--L.itemeditor_name_player_limited = "Player limited amount"
--L.itemeditor_desc_player_limited = "If equipment is player limited, it can be bought only once per player in the active round."
--L.itemeditor_name_min_players = "Minimum amount of players for selection"
--L.itemeditor_name_credits = "Price in credits"

-- 2021-06-08
--L.equip_not_added = "not added"
--L.equip_added = "added"
--L.equip_inherit_added = "added (inherit)"
--L.equip_inherit_removed = "removed (inherit)"

-- 2021-06-09
--L.layering_not_layered = "Not layered"
--L.layering_layer = "Layer {layer}"
--L.header_rolelayering_role = "{role} layer"
--L.header_rolelayering_baserole = "Baserole layer"
--L.submenu_administration_rolelayering_title = "Role Layering"
--L.header_rolelayering_info = "Role layering information"
--L.help_rolelayering_roleselection = "TThe role selection process is split into two passes. In the first pass base roles are disctributed. Baseroles are innocent, traitor and those listed in the 'base role layer' box below. The second pass is used to upgrade those baseroles to a subrole."
--L.help_rolelayering_layers = "From each layer only one role is selected. First the roles from the custom layers are distributed starting from the first layer until the last is reached or no more roles can be upgraded. Whichever happens first. If upgradeable slots are still available, the unlayered roles will be distributed as well."
--L.scoreboard_voice_tooltip = "Scroll to change the volume"

--2021-06-15
--L.header_shop_linker = "Settings"
--L.label_shop_linker_set = "Shopsetting"

--2021-08-18
--L.xfer_team_indicator = "Team"
