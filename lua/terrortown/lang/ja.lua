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

L.round_traitors_one = "Traitorよ、一人でも頑張るんだ。"
L.round_traitors_more = "Traitorよ、仲間は{names}だ。"

L.win_time = "時間切れ。Traitorの負けだ。"
L.win_traitors = "Traitorの勝利！"
L.win_innocents = "Innocentの勝利！"
L.win_nones = "引き分け！"
L.win_showreport = "さあ{num}秒の間ラウンドレポートを見てみよう。"

L.limit_round = "ラウンドリミットに達した。もうすぐロードされるだろう。"
L.limit_time = "タイムリミットに達した。もうすぐロードされるだろう。"
L.limit_left_session_mode_1 = "マップ変更するまで{num}ラウンドないし{time}分残っている。"
--L.limit_left_session_mode_2 = "{time} minutes remaining before the map changes."
--L.limit_left_session_mode_3 = "{num} round(s) remaining before the map changes."

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
-- also be one of the below.  Keep these lowercase.
L.quick_nobody = "いない奴"
L.quick_disg = "変装中"
L.quick_corpse = "死体"
L.quick_corpse_id = "{player}の死体"

-- Scoreboard
L.sb_playing = "サーバー名"
L.sb_mapchange_mode_0 = "セッションの制限を無くしました。"
L.sb_mapchange_mode_1 = "マップ変更まで{num}ラウンドか{time}秒"
--L.sb_mapchange_mode_2 = "Map changes in {time}"
--L.sb_mapchange_mode_3 = "Map changes in {num} rounds"

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
L.buy_no_stock = "この武器は品切れだ。既にこのラウンドで購入済みだ。"
L.buy_pending = "既に注文されている、受け取りまで待とう。"
L.buy_received = "特殊装備を受け取った。"

L.drop_no_room = "こんな狭い所じゃあ捨てれないぞ。"

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
変装中はあなたのID情報を隠せます。 さらに、獲物が最期に目撃した人物になるのも避けれます。

このメニューの変装メニュー内かテンキーのEnterで切り替え。]]

-- C4
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

L.c4_disarm_t = "ワイヤーを切って爆弾を解除するんだ。Traitorならどのワイヤーでも安全だが、Innocentならそう簡単にはいかないぞ！"
L.c4_disarm_owned = "ワイヤーをカットして爆弾を解除してくれ。自分の爆弾だからどのワイヤーでも安全だ。"
L.c4_disarm_other = "安全なワイヤーをカットして爆弾を解除するんだ。間違えたら即爆発だ！"

L.c4_status_armed = "起動中"
L.c4_status_disarmed = "解除済み"

-- Visualizer
L.vis_name = "可視化装置"

L.vis_desc = [[
殺害現場を可視化してくれる機械。

死体を分析して被害者がどのように殺害されたかを表示しますが、被害者が銃撃の傷で死亡した場合のみ。]]

-- Decoy
L.decoy_name = "デコイ"
L.decoy_broken = "デコイが破壊された！"

L.decoy_short_desc = "このデコイは別陣営のレーダーに偽のレーダー反応を示してくれるぞ。"
L.decoy_pickup_wrong_team = "別陣営からのデコイを拾うことはできないぞ。"

L.decoy_desc = [[
Detectiveに偽のレーダー反応を表示させ、彼らがあなたのDNAをスキャンしていた場合は彼らのDNAスキャナーがデコイの場所を表示するようにしてくれる。]]

-- Defuser
L.defuser_name = "C4除去装置"

L.defuser_desc = [[
C4爆弾を即座に除去する。

使用回数は無制限。これさえ持っていればC4に気がつくのに容易でしょう。]]

-- Flare gun
L.flare_name = "信号拳銃"

L.flare_desc = [[
死体を燃やすことができる拳銃。証拠隠滅に必須。

弾は限られているので注意。燃えている死体からは大きな燃焼音を発するので注意。]]

-- Health station
L.hstation_name = "回復ステーション"

L.hstation_broken = "回復ステーションが破壊された！"

L.hstation_desc = [[
回復が可能な設置型の機械。チャージは遅く、

誰でも使用することができますが、耐久力があるので注意。使用者のDNAサンプルをチェックすることができます。]]

-- Knife
L.knife_name = "ナイフ"
L.knife_thrown = "ナイフ投擲"

L.knife_desc = [[
怪我した者なら即座に静かに始末できますが、一度しか使用できません。

オルトファイアで投擲できます。]]

-- Poltergeist
L.polter_desc = [[
エンティティにThumperを設置すると、使用者の意志に関係なくそのエンティティが暴れまわり、

暴れ終わった後のThumperの爆発は近くの人間にダメージを与えます。]]

-- Radio
L.radio_broken = "ラジオが破壊された！"

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
L.dna_object = "対象のエンティティから最後の所有者のサンプルを回収する"
L.dna_gone = "このエリアにDNA反応はないようだ。"

L.dna_desc = [[
物からDNAサンプルを入手しそれらを使用してDNAの持ち主を探せる。

確認後の死体のみに使用でき、殺害者のDNAを入手して彼らを追跡できる。]]

-- Magneto stick
L.magnet_name = "マグネットスティック"

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

-- TargetID Karma status
L.karma_max = "安全"
L.karma_high = "粗野"
L.karma_med = "トリガーハッピー"
L.karma_low = "危険"
L.karma_min = "どうしようもない"

-- TargetID misc
L.corpse = "死体"
L.corpse_hint = "[{usekey}]で死体を確認する。[{walkkey} + {usekey}]で隠密に確認する。"

L.target_disg = "(変装中)"
L.target_unid = "誰かの死体"
L.target_unknown = "テロリスト"

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
L.tip1 = "Traitorは死体に向かって{walkkey}を押しながら{usekey}を押すと、死亡確認せずに静かに死体を調べることができます。"

L.tip2 = "タイマーを長くしたC4爆弾を起動すると、解除する際のワイヤーの本数が増えます。また、警告音も静かになります。。"

L.tip3 = "Detectiveのみ死体を検査することでその人が最後に見た者を知ることができます。 ただし、被害者が後ろから撃たれていたのなら、その人物を殺害者と決め付けるのは早とちりです。"

L.tip4 = "死体確認されるまで、その人は行方不明扱いとなります。"

L.tip5 = "TraitorがDetectiveを始末することで、報酬としてクレジットを受け取ります。"

L.tip6 = "Traitorが死亡する時、全てのDetectiveは報酬としてクレジットを受け取ります。"

L.tip7 = "TraitorはInnocentをある程度始末したとき、 報酬としてクレジットを受け取ります。"

L.tip8 = "TraitorとDetectiveは他のTraitorやDetectiveの死体から未使用のクレジットを入手することができます。"

L.tip9 = "Poltergeistはエンティティを危険な発射物に変えることができます。 その時の衝撃波は近くにいる者を傷つけていきます。"

L.tip10 = "ショップを使用できる役職はあなたや仲間が何かしら貢献した場合、追加のクレジットを贈呈されることを記憶しておきましょう。それを有効に使うことを忘れずに！"

L.tip11 = "DetectiveのDNAスキャナーは武器とアイテムからDNAサンプルを集めることができ、そのサンプルが付着したプレイヤーの居場所を捕捉してくれます。死体や解除したC4からもサンプルを入手できる。"

L.tip12 = "もしあなたが始末した相手の近くにいた場合、あなたのDNAのいくつかは死体に残されています。そのDNAはDetectiveのDNAスキャナーにより居場所を補足されてしまう危険性があるため、死体はなるべく証拠隠滅しよう。"

L.tip13 = "あなたが始末した相手から遠くに離れるにつれ、死体に付着したあなたのDNAサンプルはより早く腐敗するでしょう。"

L.tip14 = "狙撃を試みるつもりですか？変装装置の購入を検討してみてはいかがでしょうか。外した場合は安全な場所に逃げて変装を解いてください。そうすれば撃った人があなただと誰も気づかなくなるでしょう。"

L.tip15 = "テレポーターを使うことで、追跡から逃れるときに役立ち、巨大なマップを素早く移動することができます。なるべく安全な位置にマークしておくようにしておいてください。"

L.tip16 = "Innocentが皆集まっていて孤立させるのは難しいですか？それならば、何人かを引き離すためにラジオでC4の音か銃撃音を鳴らし、場を混乱させてみましょう。"

L.tip17 = "ラジオを使用すると、ラジオを配置した後の配置マーカーを見てサウンドを再生できます。複数のサウンドをキューに入れるには、必要な順序で複数のボタンをクリックします。"

L.tip18 = "Detectiveは、もしクレジットが余っているのなら信頼できるInnocentにC4除去装置を渡してしまってもかまいません。そうすればあなたは調査の方に時間を費やし、C4の解除からは離れることができます。"

L.tip19 = "Detectiveの双眼鏡は遠い所にある死体の確認ができるようになります。しかし、Traitorが死体を餌として使用する場面には要注意。なぜなら、双眼鏡使用中のDetectiveは無防備で注意散漫ですから..."

L.tip20 = "DetectiveのHealth Stationは負傷したプレイヤーを回復させます. もちろん, それらの負傷した人はTraitorかもしれないですけどね..."

L.tip21 = "Health Stationは使用した全員のDNAサンプルを記録します. DetectiveはDNA scannerでそれを使用して, 回復している人を知ることができます."

L.tip22 = "武器やC4と違い, Radioは置いたTraitorのDNAサンプルを含めません. Detectiveがそれを見つけて避難場所を吹き飛ばすことを心配する必要はありません."

L.tip23 = "{helpkey}でチュートリアルやTTT固有の設定を閲覧することができます。"

L.tip24 = "Detectiveが死体を調査すると, 結果はスコアボードで死亡した人の名前をクリックすることにより全てのプレイヤーが確認できます."

L.tip25 = "スコアボードの誰かの名前のすぐ近くの虫眼鏡アイコンはあなたがその人物の情報を調査したことを示しています. アイコンが明るければ, データはDetectiveからの追加の情報が含まれているかもしれません. "

L.tip26 = "ニックネームの下に虫眼鏡が表示されている死体は、Detectiveによって既に確認済みのことであり、結果はスコアボードを通じて全プレイヤーが閲覧することができます。"

L.tip27 = "観戦者は{mutekey}を押すことで他の観戦者や生存者のミュートを切り替えることができます."

L.tip28 = "{helpkey}により開くことができる設定メニューからいつでも言語を変えることができます。"

L.tip29 = "クイックチャットか'ラジオ'コマンドは{zoomkey}を押すことで使用できます."

L.tip30 = "Crowbarのセカンダリファイア(右クリック)は他のプレイヤーを押します."

L.tip31 = "武器のアイアンサイトを覗いて発砲することはわずかに精度を上昇させ, 反動を下げるでしょう. しゃがんでもそれらの効果はありません."

L.tip32 = "Smoke grenadeは屋内で効果的です, とりわけ人でいっぱいの部屋の中では混乱を招けるでしょうね."

L.tip33 = "Traitorは忘れないでください, あなたは死体を運ぶことでInnocentとDetectiveの詮索の目から彼らを隠すことができます."

L.tip34 = "スコアボード上では, 生存しているプレイヤーの名前をクリックし, 彼らに'疑わしい'や'仲間'のようなタグを付けることができます. このタグは彼らに近づくとクロスヘアの下に表示されます."

L.tip35 = "(C4やRadioのような)置くことのできるアイテムの多くはセカンダリファイア(右クリック)で壁に固定することができます."

L.tip36 = "C4の解除失敗による爆発はタイマーがゼロに達したC4の爆発より小さいです."

L.tip37 = "ラウンドタイマーの上に「HASTE MODE」と表示されている場合、ラウンドの長さは最初は数分程度ですが、一人死ぬことに時間が増えます。このモードはTraitor達にプレッシャーをなるべくかけるように実装されています。"

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
L.aw_sui1_text = "は最初の一歩を踏み出す者になることでどうすれば良いのかを他の自殺者達に示しました。"

L.aw_sui2_title = "孤独と憂鬱"
L.aw_sui2_text = "は孤独な自殺者でした。"

L.aw_exp1_title = "爆発物研究証"
L.aw_exp1_text = "は爆発物の研究が認められました。{num}人の被験者を助け出しましたからね。"

L.aw_exp2_title = "フィールドリサーチ"
L.aw_exp2_text = "は爆発への耐久力をテストしました。耐久力は高くなかったようです。"

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

L.aw_rfl2_title = "尻隠して頭隠さず"
L.aw_rfl2_text = "はライフルを理解しています. 今, 他の{num}人もライフルを理解しました."

L.aw_dgl1_title = "小さなライフルみたいだね"
L.aw_dgl1_text = "はデザートイーグルのコツを掴んで{num}人を始末しました."

L.aw_dgl2_title = "イーグルマスター"
L.aw_dgl2_text = "はデザートイーグルで{num}人を消しました."

L.aw_mac1_title = "敬虔と殺人"
L.aw_mac1_text = "はMAC10で{num}人を始末しましたが, どのくらいの弾を必要としたかは言わないでしょう."

L.aw_mac2_title = "マカロニ・アンド・チーズ"
L.aw_mac2_text = "は2挺のMAC10を上手く扱うことができたらどうなるのか驚きました.　{num}回もを2挺で?"

L.aw_sip1_title = "静粛に"
L.aw_sip1_text = "は消音ピストルで{num}人を黙らせました."

L.aw_sip2_title = "静寂の暗殺者"
L.aw_sip2_text = "は{num}人を自身の死を聞き取らせずに始末しました."

L.aw_knf1_title = "ナイフは知っている"
L.aw_knf1_text = "はインターネット越しに面前の誰かを刺しました."

L.aw_knf2_title = "どこから手に入れたんだい？"
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
L.aw_msx1_text = "はM16で{num}人殺害しました。"

L.aw_msx2_title = "ミドルレンジマッドネス"
L.aw_msx2_text = "が{num}人キル取っているということはM16でのターゲットの仕留め方を知っていますね."

L.aw_tkl1_title = "驚かせよう"
L.aw_tkl1_text = "はちょうど相棒の方を向いている時に指を滑らせてしまいました."

L.aw_tkl2_title = "2重の驚き"
L.aw_tkl2_text = "は2回Traitorを始末したと思っていましたが, 2回ともハズレでした."

L.aw_tkl3_title = "カルマ重視"
L.aw_tkl3_text = "はチームメイトを2人始末した後も止められませんでした. 3はラッキーナンバーですから."

L.aw_tkl4_title = "チームキラー"
L.aw_tkl4_text = "はチーム全員を始末しました。こんな奴BANしてしまおう！"

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
L.equip_tooltip_reroll = "リロール装備"

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
L.reroll_menutitle = "リロール装備"
L.reroll_no_credits = "回すのに{amount}個のクレジットが必要だ"
L.reroll_button = "スロット開始"
L.reroll_help = "{amount}クレジットを使うことでショップからランダムに装備のセットを得ることができます。"

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
L.shop_role_selected = "{role}のショップを選択した"
L.shop_search = "検索"

-- 2019-10-19
L.drop_ammo_prevented = "何かが弾を捨てるのを妨げているようだ。"

-- 2019-10-28
L.target_c4 = "[{usekey}]でC4メニューを開く"
L.target_c4_armed = "[{usekey}]でC4を解除する"
L.target_c4_armed_defuser = "[{primaryfire}]で除去装置を使う"
L.target_c4_not_disarmable = "あなたは生存しているチームメイトのC4を解除することはできない。"
L.c4_short_desc = "巨大な爆発を引き起こす"

L.target_pickup = "[{usekey}]で拾う"
L.target_slot_info = "スロット: {slot}"
L.target_pickup_weapon = "[{usekey}]で武器を拾う"
L.target_switch_weapon = "[{usekey}]で今手に持っている武器と交換"
L.target_pickup_weapon_hidden = ", [{walkkey} + {usekey}]で隠密に拾う"
L.target_switch_weapon_hidden = ", [{walkkey} + {usekey}]で隠密に交換"
L.target_switch_weapon_nospace = "この武器のインベントリがないな。"
L.target_switch_drop_weapon_info = "{name}をスロット{slot}から捨てる"
L.target_switch_drop_weapon_info_noslot = "スロット{slot}には捨てるものがないな。"

L.corpse_searched_by_detective = "この死体は既に探偵系役職に確認済みです。"
L.corpse_too_far_away = "その死体から遠すぎる。"

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

L.pickup_no_room = "ここじゃあ狭くて拾えやしない。"
L.pickup_fail = "これは拾えないようだ。"
L.pickup_pending = "既に武器を拾っている、受け取りまで少し待とう。"

-- 2020-01-07
L.tbut_help_admin = "Traitorトラップ設定を編集する"
L.tbut_role_toggle = "[{walkkey} + {usekey}]で{role}に切り替える"
L.tbut_role_config = "役職:{current}"
L.tbut_team_toggle = "[SHIFT + {walkkey} + {usekey}] to toggle this button for {team}"
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
L.menu_gameplay_description = "音声と音量、アクセシビリティ設定、\nゲームプレイ設定を微調整します。"
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

L.submenu_gameplay_general_title = "基本設定"

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
L.label_crosshair_opacity = "クロスヘア不透明度"
L.label_crosshair_ironsight_opacity = "アイアンサイトのクロスヘアの不透明度"
L.label_crosshair_size = "クロスヘアの大きさ"
L.label_crosshair_thickness = "クロスヘアの太さ"
L.label_crosshair_thickness_outline = "クロスヘアの外枠の太さ"
L.label_crosshair_scale_enable = "ダイナミッククロスヘアスケールを有効にする"
L.label_crosshair_ironsight_low_enabled = "アイアンサイトを使用する場合は武器を提げる"
L.label_damage_indicator_enable = "ダメージインジケーターを有効"
L.label_damage_indicator_mode = "ダメージインジケーターのテーマを選択"
L.label_damage_indicator_duration = "命中後にダメージインジケーターが表示される秒数"
L.label_damage_indicator_maxdamage = "最大不透明度に必要なダメージ"
L.label_damage_indicator_maxalpha = "ダメージインジケーター最大不透明度"
L.label_performance_halo_enable = "いくつかのエンティティを見ている間に、それらにアウトラインが表示されることを有効"
L.label_performance_spec_outline_enable = "操作しているエンティティのアウトラインを有効"
L.label_performance_ohicon_enable = "頭の上の役職アイコンを有効"
L.label_interface_popup = "ラウンド開始時にポップアップを表示"
L.label_interface_fastsw_menu = "高速武器スイッチでメニューを有効"
L.label_inferface_wswitch_hide_enable = "武器の切り替えメニューが自動で閉じることを有効"
L.label_inferface_scues_enable = "ラウンド開始や終了後に音を鳴らす"
L.label_gameplay_specmode = "観戦者モード（常時観戦者になれます）"
L.label_gameplay_fastsw = "高速武器スイッチ"
L.label_gameplay_hold_aim = "Aimの固定を有効"
L.label_gameplay_mute = "死んだとき生存者のボイスチャットをミュートにする"
L.label_hud_default = "デフォルトHUD"
L.label_hud_force = "強制的HUD"

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
L.corpse_hint_inspect_limited = "[{usekey}]で確認できます。[{walkkey} + {usekey}]でUIのみ確認することができます。"

-- 2020-06-04
L.label_bind_disguiser = "変装する"

-- 2020-06-24
L.dna_help_primary = "DNAサンプルを集める"
L.dna_help_secondary = "DNAスロットを切り替え"
L.dna_help_reload = "サンプル消去"

L.binoc_help_pri = "死体を確認する"
L.binoc_help_sec = "ズームレベル変更"

L.vis_help_pri = "可視化装置を落とす"

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

L.tooltip_karma_gained = "本ラウンドのカルマ変動:"
L.tooltip_score_gained = "本ラウンドのスコア変動:"
L.tooltip_roles_time = "本ラウンドの役職変更:"

--L.tooltip_finish_score_win = "Win: {score}"
L.tooltip_finish_score_alive_teammates = "生存したチームメイト:{score}"
L.tooltip_finish_score_alive_all = "生存者:{score}"
L.tooltip_finish_score_timelimit = "時間切れ:{score}"
L.tooltip_finish_score_dead_enemies = "敵の死亡:{score}"
L.tooltip_kill_score = "殺害:{score}"
L.tooltip_bodyfound_score = "死体発見:{score}"

--L.finish_score_win = "Win:"
L.finish_score_alive_teammates = "生存したチームメイト:"
L.finish_score_alive_all = "生存者:"
L.finish_score_timelimit = "時間切れ:"
L.finish_score_dead_enemies = "敵の死亡:"
L.kill_score = "殺害:"
L.bodyfound_score = "死体発見:"

L.title_event_bodyfound = "死体が発見された"
L.title_event_c4_disarm = "C4が解除された"
L.title_event_c4_explode = "C4が爆発した"
L.title_event_c4_plant = "C4が起動した"
L.title_event_creditfound = "クレジットを得た"
L.title_event_finish = "ラウンド終了"
L.title_event_game = "新しいラウンドの開始"
L.title_event_kill = "プレイヤーが殺された"
L.title_event_respawn = "プレイヤーが生き返った"
L.title_event_rolechange = "プレイヤーの役職/陣営が変わった"
L.title_event_selected = "役職が配布された"
L.title_event_spawn = "プレイヤーが出現した"

L.desc_event_bodyfound = "{finder} ({firole} / {fiteam})が{found} ({forole} / {foteam})の死体を見つけ、その死体には{credits}個のクレジットがあった。"
L.desc_event_bodyfound_headshot = "こいつはヘッドショットされている。"
L.desc_event_c4_disarm_success = "{disarmer} ({drole} / {dteam})は{owner} ({orole} / {oteam})により起動されたC4を解除した。"
L.desc_event_c4_disarm_failed = "{disarmer} ({drole} / {dteam})は{owner} ({orole} / {oteam})により起動されたC4を解除を試みたが、失敗したようだ。"
L.desc_event_c4_explode = "{owner} ({role} / {team})によるC4が爆破した。"
L.desc_event_c4_plant = "{owner} ({role} / {team})がC4を爆破した。"
L.desc_event_creditfound = "{finder} ({firole} / {fiteam})は{credits}個のクレジットを{found} ({forole} / {foteam})から得た。"
L.desc_event_finish = "ラウンド継続時間は{minutes}:{seconds}。生存者は{alive}人。"
L.desc_event_game = "ラウンドが開始された。"
L.desc_event_respawn = "{player}が生き返った。"
L.desc_event_rolechange = "{player}が{orole} ({oteam})から{nrole} ({nteam})へと変わった。"
L.desc_event_selected = "チームと役職が総勢{amount}人に配布された。"
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
L.karma_teamkill_tooltip = "チームメイトの殺害"
L.karma_teamhurt_tooltip = "チームメイトへの損傷"
L.karma_enemykill_tooltip = "敵の殺害"
L.karma_enemyhurt_tooltip = "ダメージ値"
L.karma_cleanround_tooltip = "ラウンド整理"
L.karma_roundheal_tooltip = "カルマ復旧"
L.karma_unknown_tooltip = "不明"

-- 2021-05-07
L.header_random_shop_administration = "ランダムショップ設定"
L.header_random_shop_value_administration = "バランス設定"

L.shopeditor_name_random_shops = "ランダムショップ有効"
L.shopeditor_desc_random_shops = [[ランダムショップは、全プレイヤーに利用可能なすべての装備の限定的なランダムセットが提供してくれます。
チームショップは、個々のプレイヤーではなく、チーム内の全プレイヤーに同じセットを提供してくれます。
リロールすることで、クレジットと引き換えに新しいランダムな拡張パーツセットを手に入れることができます。]]
L.shopeditor_name_random_shop_items = "ランダムアイテム数"
L.shopeditor_desc_random_shop_items = "これにはショップ有効とマークされている装備が含まれています。したがって、十分に高い数値を選択するか、それらしか取得できません。"
L.shopeditor_name_random_team_shops = "陣営ショップ有効"
L.shopeditor_name_random_shop_reroll = "スロットショップ有効"
L.shopeditor_name_random_shop_reroll_cost = "スロットコスト"
L.shopeditor_name_random_shop_reroll_per_buy = "購入直後の自動スロット"

-- 2021-06-04
L.header_equipment_setup = "装備設定"
L.header_equipment_value_setup = "バランス設定"

L.equipmenteditor_name_not_buyable = "購入の可否"
L.equipmenteditor_desc_not_buyable = "無効の場合、ショップに表示されないようになる。\nこのアイテムが割り当てられている役職は引き続きそれを受け取ります。"
L.equipmenteditor_name_not_random = "常時購入可能"
L.equipmenteditor_desc_not_random = "有効にすると、装備は常にショップで入手できます。ランダムショップを有効にすることで、利用可能なランダムスロットが1つ取り、常にこの拡張パーツ用に予約されます。"
L.equipmenteditor_name_global_limited = "全体的な使用制限"
L.equipmenteditor_desc_global_limited = "有効にすることで、サーバー内において一度だけ装備を購入できます。"
L.equipmenteditor_name_team_limited = "陣営による使用制限"
L.equipmenteditor_desc_team_limited = "有効にすることで、陣営ごとに一度だけ装備を購入できます。"
L.equipmenteditor_name_player_limited = "使用制限"
L.equipmenteditor_desc_player_limited = "有効にすることで、プレイヤーごとに一度だけ装備を購入できます。"
L.equipmenteditor_name_min_players = "購入できるまでの最小人数"
L.equipmenteditor_name_credits = "クレジット消費数"

-- 2021-06-08
L.equip_not_added = "除外"
L.equip_added = "追加"
L.equip_inherit_added = "(inherit)を追加した"
L.equip_inherit_removed = "(inherit)を除外した"

-- 2021-06-09
L.layering_not_layered = "ノンレイヤード"
L.layering_layer = "レイヤー{layer}"
L.header_rolelayering_role = "{role}のレイヤリング"
L.header_rolelayering_baserole = "基本役職のレイヤリング"
L.submenu_roles_rolelayering_title = "役職レイヤー"
L.header_rolelayering_info = "役職レイヤー情報"
L.help_rolelayering_roleselection = [[役職の配布プロセスは、2つのステージに分かれています。最初の段階では、Innocent、Traitor、および下の「基本役職レイヤー」ボックスにリストされている基本の役職が配布されます。第2ステージは、これらの基本役職をサブ役職にアップグレードするために使用されます。]]
L.help_rolelayering_layers = [[各レイヤーからは、1つの役職のみが選択されます。まず、カスタムレイヤーにおける役職は、最初のレイヤーから最後のレイヤーに到達するか、それ以上の役職をアップグレードできなくなるまで分散されます。どちらが先であっても、アップグレード可能なスロットがまだ利用可能な場合は、階層化されていない役職も分散されます。]]
L.scoreboard_voice_tooltip = "音量を変更"

-- 2021-06-15
L.header_shop_linker = "設定"
L.label_shop_linker_set = "ショップ設定"

-- 2021-06-18
L.xfer_team_indicator = "陣営"

-- 2021-06-25
L.searchbar_default_placeholder = "検索"

-- 2021-07-11
L.spec_about_to_revive = "蘇生中のため行動が制限されています。"

-- 2021-09-01
L.spawneditor_name = "スポーンエディタツール"
L.spawneditor_desc = "武器、弾薬やプレイヤーのスポーン位置を設定できます。\nこちらは管理者にしか使用できないため注意。"

L.spawneditor_place = "スポーン位置設置"
L.spawneditor_remove = "スポーン位置削除"
L.spawneditor_change = "スポーンタイプを変更([SHIFT]を押しながらだと逆になります)"
L.spawneditor_ammo_edit = "武器のスポーンを長押しして、弾薬の自動生成を編集する"

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

L.spawn_weapon_ammo = "(弾薬:{ammo})"

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
L.label_dynamic_spawns_global_enable = "全マップにおける動的スポーンを有効"

L.header_equipment_weapon_spawn_setup = "武器スポーン設定"

L.help_spawn_editor_info = [[
スポーンエディタは、ワールド内のスポーン位置を配置、削除、編集するために使用されます。これらのスポーンは、武器、弾薬、プレイヤー用です。

これらのスポーン位置は 'data/ttt/weaponspawnscripts/' にあるファイルに保存される。これらは、ハードリセットのために削除できます。初期スポーン ファイルは、マップ上および元の TTT 武器スポーン スクリプトで見つかったスポーンから作成されます。リセットボタンを押すと、初期状態に戻ります。

このスポーン システムは動的スポーンを使用することに注意してください。これは、特定の武器を定義するのではなく、武器の種類を定義するため、武器にとって最も興味深いものです。例えば、TTTショットガンのスポーンの代わりに、ショットガンと定義された任意の武器がスポーンできる一般的なショットガンのスポーンが存在するようになりました。各武器のスポーンタイプは「装備の編集」メニューで設定できます。これにより、任意の武器がマップ上にスポーンしたり、特定のデフォルトの武器を無効にしたりすることが可能になります。

多くの変更箇所は、新しいラウンドが開始された後にのみ有効になることに注意してください。]]
L.help_spawn_editor_enable = "一部のマップでは、マップ上で見つかった元のスポーンを動的システムに置き換えずに使用することをお勧めします。このオプションを以下で変更すると、現在有効なマップにのみ影響するため、他の全マップでは動的システムが使用されます。"
L.help_spawn_editor_hint = "スポーンエディタを終了したい場合は設定画面を再度開いてください。"
L.help_spawn_editor_spawn_amount = [[
このマップには {weapon} 個の武器、{ammo} 個の弾薬と {player} 人のスポーン位置が設定されています。
変更したい場合は'始める'を押しましょう。

{weaponrandom}x おまかせ武器
{weaponmelee}x 近接武器
{weaponnade}x グレネード
{weaponshotgun}x ショットガン
{weaponheavy}x 重機関銃
{weaponsniper}x スナイパー
{weaponpistol}x ピストル
{weaponspecial}x 特殊武器

{ammorandom}x おまかせ弾薬
{ammodeagle}x マグナム弾
{ammopistol}x 9mm弾
{ammomac10}x SMG弾
{ammorifle}x ライフル弾
{ammoshotgun}x バックショット

{playerrandom}xプレイヤースポーン位置]]

L.equipmenteditor_name_auto_spawnable = "ワールド内にランダムでスポーンするようにする"
L.equipmenteditor_name_spawn_type = "スポーンタイプ選択"
L.equipmenteditor_desc_auto_spawnable = [[
TTT2スポーンシステムにより、すべての武器がワールドにスポーンします。デフォルトでは、作成者によって「AutoSpawnable」とマークされた武器のみがワールドにスポーンしますが、これはこのメニュー内から変更できます。

ほとんどの装備はデフォルトで「特殊武器のスポーン」に設定されています。つまり、装備はランダムな武器のスポーンにのみスポーンします。ただし、ワールドに特別な武器のスポーンを配置したり、ここでスポーンタイプを変更して他の既存のスポーンタイプを使用したりすることも可能です。]]

L.pickup_error_inv_cached = "インベントリに空きがないため拾うことはできません。"

-- 2021-09-02
L.submenu_administration_playermodels_title = "プレイヤーモデル"
L.header_playermodels_general = "プレイヤーモデル基本設定"
L.header_playermodels_selection = "プレイヤーモデル選択"

L.label_enforce_playermodel = "プレイヤーモデルを固定させる"
L.label_use_custom_models = "プレイヤーモデルをランダムに選択する"
L.label_prefer_map_models = "デフォルトプレイヤーモデルよりもマップ固有のプレイヤーモデルを優先"
L.label_select_model_per_round = "ラウンドごとに新しいプレイヤーモデルを選択"
L.label_select_unique_model_per_round = "プレイヤーごとに固有のランダムなプレイヤーモデルを選択"

L.help_prefer_map_models = [[
一部のマップでは、独自のプレイヤーモデルが定義されています。デフォルトでは、これらのプレイヤーモデルの優先度は、自動的に割り当てられるプレイヤーモデルよりも高くなります。この設定を無効にすると、マップ固有のプレイヤーモデルが無効になります。

役職固有のプレイヤーモデルは常に優先度が高く、この設定の影響を受けません。]]
L.help_enforce_playermodel = [[
一部の役職には、カスタムのプレイヤーモデルがあります。これらは無効にすることができ、一部のプレイヤーモデルセレクターとの互換性に関連する場合があります。

この設定が無効になっている場合でも、ランダムにデフォルトモデルを選択されます。]]
L.help_use_custom_models = [[
デフォルトでは、CS:S Phoenix プレイヤーモデルのみがすべてのプレイヤーに割り当てられます。ただし、このオプションを有効にすると、プレイヤーモデルプールを選択することができます。この設定を有効にしても、各プレイヤーに同じプレイヤーモデルが割り当てられますが、定義されたモデルプールからのランダムなモデルです。

このモデルの選択肢は、より多くのプレイヤーモデルを導入することで拡張できます。]]

-- 2021-10-06
L.menu_server_addons_title = "サーバーアドオン"
L.menu_server_addons_description = "サーバー側のみ機能するアドオンの設定を弄ることができます"

L.tooltip_finish_score_penalty_alive_teammates = "生存チームメイトペナルティ:{score}"
L.finish_score_penalty_alive_teammates = "生存チームメイトペナルティ:"
L.tooltip_kill_score_suicide = "自殺:{score}"
L.kill_score_suicide = "自殺:"
L.tooltip_kill_score_team = "チームキル:{score}"
L.kill_score_team = "チームキル:"

-- 2021-10-09
L.help_models_select = [[
モデルを左クリックして、プレイヤーモデルプールに追加します。もう一度左クリックして削除します。右クリックすると、フォーカスされたモデルの有効な検出ハットと無効な検出ハットが切り替わります。

左上の小さなインジケーターは、プレイヤーモデルにヘッドヒットボックスがあるかどうかを示しています。下のアイコンは、このモデルが探偵帽に適用できるかどうかを示しています。]]

L.menu_roles_title = "役職設定"
L.menu_roles_description = "出現の有無、初期クレジット数などを\n役職ごとに設定できます。"

L.submenu_roles_roles_general_title = "役職基本設定"

L.header_roles_info = "役職情報"
L.header_roles_selection = "比率"
L.header_roles_tbuttons = "トラップアクセス"
L.header_roles_credits = "初期クレジット数"
L.header_roles_additional = "固有設定"
L.header_roles_reward_credits = "クレジット報酬"

L.help_roles_default_team = "デフォルト陣営:{team}"
L.help_roles_unselectable = "この役職は配布できず、役職の配布プロセスでは考慮されません。ほとんどの場合、これは蘇生やサイドキック・ディーグルなどのイベントを通じてラウンド中に手動で割り当てられる役職であることを意味します。"
L.help_roles_selectable = "この役職は分散可能です。すべての条件が満たされた場合、この役職は役職の配布プロセスで考慮されます。"
L.help_roles_credits = "拡張パーツクレジットは、ショップで拡張パーツを購入するために使用されます。ほとんどの場合、ショップにアクセスできる役割に対してのみそれらを与えるのが理にかなっています。ただし、死体にクレジットを見つけることができるため、殺人者への報酬として役職に開始クレジットを与えることもできます。"
L.help_roles_selection_short = "プレイヤーごとの役職配分は、この役職が割り当てられるプレイヤーの割合を定義します。例えば、値が「0.2」に設定されている場合、5人ごとにこの役職を受け取ります。"
L.help_roles_selection = [[
プレイヤーごとの役職配分は、この役職が割り当てられるプレイヤーの割合を定義します。例えば、値が「0.2」に設定されている場合、5人ごとにこの役職を受け取ります。これは、この役職を分散させるためには、少なくとも5人のプレイヤーが必要であることも意味します。
これらはすべて、役職が配布プロセスで考慮される場合にのみ適用されることに注意してください。

前述の役割配分は、プレイヤーの下限と特別な統合をしています。役職が分配対象として考慮され、最小値が分配係数によって与えられた値を下回っているが、プレイヤーの数が下限以上である場合でも、1人のプレイヤーがこの役職を受け取ることができます。その後、配布プロセスは2番目のプレイヤーに対して通常どおり機能します。]]
L.help_roles_award_info = "一部の役職(クレジット設定で有効になっている場合)は、一定の割合の敵が死亡した場合に拡張パーツクレジットを受け取ります。関連する値はここで調整できます。"
L.help_roles_award_pct = "この割合の敵が倒されると、特定の役割に拡張パーツクレジットが付与されます。"
L.help_roles_award_repeat = "クレジットの授与が複数回行われるかどうか。例えば、パーセンテージが「0.25」に設定されていて、この設定が有効になっている場合、プレイヤーはそれぞれ「25%」、「50%」、「75%」の敵を倒した時点でクレジットが与えられます。"
L.help_roles_advanced_warning = "警告: これらは、役職の配布プロセスを完全に台無しにする可能性のある詳細設定です。疑わしい場合は、すべての値を '0' に保ちます。この値は、制限が適用されず、役職の配布ができるだけ多くの役職を割り当てようとすることを意味します。"
L.help_roles_max_roles = [[
ここでの役職という用語には、基本役職とサブ役職の両方が含まれます。デフォルトでは、割り当てることができるさまざまな役職の数に制限はありません。ただし、ここではそれらを制限するための2つの異なる方法があります。

1.固定量による制限
2.パーセンテージによる制限

後者は、固定値が「0」で、利用可能なプレイヤーの設定されたパーセンテージに基づいて上限を設定する場合にのみ使用されます。]]
L.help_roles_max_baseroles = [[
基本役職は、他のユーザーが継承する役職のみです。例えば、Innocentの役割は基本の役割であり、Pharaohはこの役割のサブ役職です。デフォルトでは、割り当てることができる基本役職の数に制限はありません。ただし、ここではそれらを制限するための2つの異なる方法があります。

1.固定量による制限
2.パーセンテージによる制限

後者は、固定値が「0」で、利用可能なプレイヤーの設定されたパーセンテージに基づいて上限を設定する場合にのみ使用されます。]]

L.label_roles_enabled = "追加する"
L.label_roles_min_inno_pct = "比率"
L.label_roles_pct = "比率"
L.label_roles_max = "追加されるこの役職の数"
L.label_roles_random = "この役職が配布される確率"
L.label_roles_min_players = "配布されるまでのプレイヤーの最小人数"
L.label_roles_tbutton = "Traitorトラップ"
L.label_roles_credits_starting = "初期クレジット数"
L.label_roles_credits_award_pct = "報酬クレジット比率"
L.label_roles_credits_award_size = "報酬クレジット数"
L.label_roles_credits_award_repeat = "報酬の回数"
L.label_roles_newroles_enabled = "カスタム役職を有効"
L.label_roles_max_roles = "役職上限"
L.label_roles_max_roles_pct = "カスタム役職比率"
L.label_roles_max_baseroles = "基本役職の上限"
L.label_roles_max_baseroles_pct = "パーセンテージによる基本役職の上限"
L.label_detective_hats = "Detectiveのように探偵帽を装着されるようにする"

L.ttt2_desc_innocent = "Innocentには特別な能力はありません。彼らはテロリストの中から邪悪な者を見つけ出し、殺さなければなりません。しかし、彼らはチームメイトを殺さないように注意しなければなりません。"
L.ttt2_desc_traitor = "TraitorはInnocentの敵です。彼らは特別な機器を購入することができる機器メニューを持っています。彼らはチームメイト以外の全員を殺さなければなりません。"
L.ttt2_desc_detective = "Innocent陣営に所属し、唯一の確白。専用のショップから特殊アイテムを購入することができます。\nそれを用いながら、誰がTraitorなのか推理して勝利へ導きましょう。"

-- 2021-10-10
L.button_reset_models = "リセット"

-- 2021-10-13
L.help_roles_credits_award_kill = "クレジットを獲得するもう一つの方法は、Detectiveのような確白の役職のプレイヤーを殺すことです。\nそうすることで、以下の設定されたクレジット数を得ます。"
L.help_roles_credits_award = [[
基本的にTTT2でクレジットが付与されるには、2つの異なる方法があります。

1. 敵チームの一定の割合が死亡した場合、チーム全体にクレジットが付与される
2. プレイヤーが探偵などの「公的な役割」を持つ価値の高いプレイヤーを殺した場合、殺人者にはクレジットが与えられる

これは、チーム全体が授与された場合でも、すべての役職で有効/無効にできることに注意してください。例えば、Innocent陣営が授与されたが、Innocentの役職がこれを無効にしている場合、Detectiveだけがクレジットを受け取ります。
この機能のバランス調整値は、「管理」から「一般役職設定」で設定できます。]]
L.help_detective_hats = [[
Detectiveのような役職は、彼らの権威を示すために帽子をかぶっているかもしれません。彼らは死亡したとき、または頭が損傷した場合にそれを失います。

一部のプレイヤーモデルは、デフォルトで帽子を装着できません。これは、「管理」->「プレーヤーモデル」で変更できます]]

L.label_roles_credits_award_kill = "殺害によるクレジット報酬"
L.label_roles_credits_dead_award = "一定の割合の敵の死亡によるクレジット報酬を有効"
L.label_roles_credits_kill_award = "Detectiveのような役職の殺害によるクレジット報酬を有効"
L.label_roles_min_karma = "分布を考慮するカルマの下限値"

-- 2021-11-07
L.submenu_administration_administration_title = "管理"
L.submenu_administration_voicechat_title = "ボイスチャット/テキストチャット"
L.submenu_administration_round_setup_title = "ラウンド設定"
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
L.header_voicechat_general = "ボイスチャット関連設定"
L.header_voicechat_battery = "ボイスチャットバッテリー"
L.header_voicechat_locational = "間近のボイスチャット"
L.header_playersettings_plyspawn = "プレイヤースポーン設定"
L.header_round_setup_prep = "ラウンド:準備中"
L.header_round_setup_round = "ラウンド:継続中"
L.header_round_setup_post = "ラウンド:終了"
L.header_round_setup_map_duration = "マップセッション"
L.header_textchat = "テキストチャット"
L.header_round_dead_players = "死人設定"
L.header_administration_scoreboard = "スコアボード設定"
L.header_hud_toggleable = "切り替え可能なHUD要素"
L.header_mapentities_prop_possession = "エンティティ憑依"
L.header_mapentities_doors = "ドア"
L.header_karma_tweaking = "カルマ調整"
L.header_karma_kick = "カルマキックとBAN"
L.header_karma_logging = "カルマ記録"
L.header_inventory_gernal = "インベントリの大きさ"
L.header_inventory_pickup = "インベントリへの武器拾得"
L.header_sprint_general = "走行設定"
L.header_playersettings_armor = "アーマーシステム設定"

L.help_killer_dna_range = "プレイヤーが他のプレイヤーに殺されると、DNAサンプルが体に残ります。以下の設定は、DNAサンプルが残される最大距離をハンマー単位で定義しています。被害者が死亡したときに殺人者がこの値よりも離れている場合、死体にはサンプルは残りません。"
L.help_killer_dna_basetime = "DNAサンプルが崩壊するまでの基本時間(秒単位)(キラーが0ハンマーユニット離れている場合)です。殺人者が遠くに行けば行くほど、DNAサンプルが崩壊するまでの時間が短くなります。"
L.help_dna_radar = "TTT2におけるDNAスキャナーは、選択したDNAサンプルが装備されている場合、正確な距離と方向を表示します。ただし、クールダウンが経過するたびに選択したサンプルをインワールドレンダリングで更新するクラシックなDNAスキャナーモードもあります。"
L.help_idle = "待機モードは、待機状態のプレイヤーを強制的に観戦モードに移動させるために使用されます。このモードを終了するには、「ゲームプレイ」メニューでモードを無効にする必要があります。"
L.help_namechange_kick = [[
ラウンド中の名称変更は悪用される可能性があります。したがって、これはデフォルトで禁止されており、違反したプレーヤーがサーバーから追放されることにつながります。

禁止時間が0より大きい場合、その時間が経過するまで、対象のプレイヤーはサーバーに再接続できません。]]
L.help_damage_log = "プレイヤーがダメージを受けるたびに、有効になっている場合は、ダメージログエントリがコンソールに追加されます。\nラウンド終了後にディスクに保存することもできます。ファイルは「data/terrortown/log/」に保存されています。"
L.help_spawn_waves = [[
0に設定すると、すべてのプレイヤーが一度にスポーンされます。大人数のプレイヤーがいるサーバーでは、ウェーブ間隔でプレイヤーをスポーンさせるのが良いでしょう。スポーンウェーブ間隔は、各スポーンウェーブの間の時間です。スポーンウェーブは、スポーンポイントの数だけプレイヤーをスポーンさせます。

注意 : 準備時間が希望する量のスポーンウェーブに十分な長さであることを確認してください。]]
L.help_voicechat_battery = [[
ボイスチャットバッテリーを有効にしたボイスチャットは、バッテリーの充電を減らします。バッテリーが空の場合、プレイヤーはボイスチャットを使用できず、再充電されるのを待つ必要があります。これにより、ボイスチャットの過度の使用を防ぐことができます。

注: 「ティック」とは、ゲームのティックを指します。たとえば、ティックレートが66に設定されている場合、1/66秒になります。]]
L.help_ply_spawn = "プレイヤーの(リ)スポーン時に使用される設定"
L.help_haste_mode = [[
HASTEモードは、プレイヤーが一人死亡するたびのラウンド時間追加により、ゲームのバランスを取ります。Traitor陣営の役職、又は観戦者のみが、実際のラウンド時間を見ることができます。他の役職は見れません。

HASTEモードが有効になっている場合、通常ラウンド時間は無視されます。]]
L.help_round_limit = "設定された制限条件の1つが満たされると、マップ変更が開始されます。"
L.help_armor_balancing = "アーマーのバランス調整ができる機能です。"
L.help_item_armor_classic = "クラシックアーマーモードは、プレイヤーがラウンドで一度だけボディアーマーを購入することができ、\nアーマーは弾丸とバールによるダメージの30%を軽減できます。"
L.help_item_armor_dynamic = [[
動的アーマーモードは購入できるアーマーの量は無制限で、アーマー値の重複が可能なモードです。ダメージを受けると、アーマーの値が減少します。購入したアーマーの耐久値は、上記項目の「装備設定」に設定されています。

ダメージを受けると、このダメージの一定の割合だけアーマーへのダメージに変換され、プレイヤーに対しては異なる割合が適用され、残りは消滅します。

強化アーマーが有効な場合、耐久値が補強しきい値を超える限り、プレイヤーに与えるダメージは15%減少します。]]
L.help_sherlock_mode = "シャーロックモードは、古典的なTTTモードです。シャーロックモードが無効になっている場合、\n死体は確認できず、スコアボードは生きている全ての人を示し、観戦者は生存者と会話が可能です。"
L.help_prop_possession = [[
エンティティ憑依は、観戦者がマップに存在するエンティティに憑依し、ゆっくりとチャージされていく「パンチ・オー・メーター」を使用して、そのエンティティを操作できる機能です。

「パンチ・オー・メーター」の最大値は、2つの定義された制限の間に遮断された死量/死の差が追加される基本的憑依値で構成されています。メーターは時間の経過とともにゆっくりチャージされます。セットの再チャージ時間は、「パンチ・オー・メーター」の単一ポイントをチャージするのに必要な時間です。]]
L.help_karma = "プレイヤーは一定量のカルマを持ってスタートし、チームメイトにダメージを与える、もしくは殺すとカルマを失います。失ってしまう量は、彼らが傷つけたり殺したりした人のカルマに依存します。カルマが低いほど、与えるダメージが減少します。"
L.help_karma_strict = "厳密なカルマが有効になっている場合、カルマがダウンするにつれてダメージペナルティが急速に増加します。オフの場合、800を超えるとダメージペナルティは非常に低くなります。ストリクトモードを有効にすると、カルマは不必要なキルを思いとどまらせるのに大きな役割を果たしますが、無効にすると、カルマがチームメイトを常に殺すプレイヤーだけを傷つける、ある意味より「緩い」ゲームになります。"
L.help_karma_max = "最大カルマの値を1000以上に設定しても、カルマが1000を超えるプレイヤーにはダメージボーナスは与えられません。カルマバッファとして使用できます。"
L.help_karma_ratio = "両者が同じ陣営にいる場合に、カルマを加害者から差し引く量を計算するためのダメージ比率。チームキルが発生した場合は、さらにペナルティが適用されます。"
L.help_karma_traitordmg_ratio = "両者が異なる陣営にいる場合に、加害者のカルマの量を攻撃者から差し引く計算するためのダメージ比率。\nチームキルが発生した場合は、さらにボーナスが適用されます。"
L.help_karma_bonus = "ラウンド中にカルマを獲得する2つの異なる受動的な方法もあります。まず、ラウンド復帰はすべてのプレイヤーに適用されます。\nその後、チームメイトがダメージを受けなかったり殺されたりしなかった場合、二次的な整理ボーナスが与えられます。"
L.help_karma_clean_half = [[
プレイヤーのカルマが開始レベルを超えている場合(カルマの最大値がそれより高く設定されている場合)、カルマがその開始レベルをどれだけ上回っているかによって、全てのカルマの増加が減少。高いほど遅く上がります。

この減少は指数的な減衰の曲線に入ります。最初は速く増分が小さくなるにつれて減速します。この設定は、ボーナスが半分になった時点で設定されます(所謂半減期)。\nデフォルト値が0.25だと、カルマの開始量が1000と最大1500 で、プレイヤーがカルマ 1125 ((1500 - 1000) * 0.25 = 125 を持つ場合、\nラウンド整理ボーナスは30/2 = 15になります。つまり、ボーナスをより速く下げるために、この設定を低く設定し、それが遅くなるように、1に向かってそれを増やすでしょう。]]
L.help_max_slots = "スロットあたりの武器の最大量を設定します。'-1' は制限がないということです。"
L.help_item_armor_value = "これは、ダイナミックモードでアーマーアイテムによって与えられるアーマー値です。クラシックモードが\n有効になっている場合(「管理」->'プレイヤー設定'を参照)、0より大きいすべての値が既存のアーマーとしてカウントされます。"

L.label_killer_dna_range = "DNAが残る最大殺害距離"
L.label_killer_dna_basetime = "DNAサンプル基本的残存時間"
L.label_dna_scanner_slots = "DNAサンプルスロット"
L.label_dna_radar = "従来のDNAスキャナモード有効"
L.label_dna_radar_cooldown = "DNAスキャナークールダウン"
L.label_radar_charge_time = "再チャージまでの時間"
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
L.label_prop_throwing = "エンティティを投げることを有効"
L.label_weapon_carrying = "武器の運搬を有効"
L.label_weapon_carrying_range = "武器を運べるまでの距離"
L.label_prop_carrying_force = "エンティティ拾得力"
L.label_teleport_telefrags = "テレポートした瞬間にテレポート位置にいる人を自動的に殺害"
L.label_allow_discomb_jump = "ディスコンボビュレーターによるジャンプ"
L.label_spawn_wave_interval = "スポーンウェーブインターバル(秒)"
L.label_voice_enable = "ボイスチャットの有効"
L.label_voice_drain = "ボイスチャットにおけるバッテリーの有効"
L.label_voice_drain_normal = "通常プレイヤーのボイスチャットのバッテリーのチックあたりの減少値"
L.label_voice_drain_admin = "管理者および確白役職のボイスチャットのバッテリーのチックあたりの減少値"
L.label_voice_drain_recharge = "ボイスチャットをしていないティックあたりのリチャージ率"
L.label_locational_voice = "生存者同士における近接ボイスチャットの有効"
L.label_locational_voice_prep = "準備フェーズにおける近接ボイスチャットの有効"
L.label_locational_voice_range = "近接ボイスチャット範囲"
L.label_armor_on_spawn = "全プレイヤーアーマー装着"
L.label_prep_respawn = "ラウンド準備中時のリスポーンを有効"
L.label_preptime_seconds = "ラウンド準備時間(秒)"
L.label_firstpreptime_seconds = "初めのラウンド準備時間(秒)"
L.label_roundtime_minutes = "通常ラウンド時間(分)"
L.label_haste = "Hasteモード有効"
L.label_haste_starting_minutes = "Hasteモード有の場合のラウンド時間(分)"
L.label_haste_minutes_per_death = "死亡毎の追加時間"
L.label_posttime_seconds = "ラウンド終了時間"
L.label_round_limit = "ラウンド最大数"
L.label_time_limit_minutes = "ラウンド時間の上限(分)"
L.label_nade_throw_during_prep = "準備時間中に手榴弾の投擲の有効"
L.label_postround_dm = "ラウンド終了時間中のデスマッチを有効"
L.label_spectator_chat = "観戦者同士でのチャットの有無"
L.label_lastwords_chatprint = "タイピング中に殺されたら遺言を送信する"
L.label_identify_body_woconfirm = "'確認'ボタン無しで死体を特定"
L.label_announce_body_found = "遺体が確認されたときに遺体が発見されたことを発表する"
L.label_confirm_killlist = "確認済みの死体のリストの報告"
L.label_dyingshot = "アイアンサイト中で死に撃つ[実験的]"
L.label_armor_block_headshots = "ヘッドショットへの耐久"
L.label_armor_block_blastdmg = "爆破ダメージへの耐久"
L.label_armor_dynamic = "動的アーマー"
L.label_armor_value = "アーマーアイテムによる耐久値"
L.label_armor_damage_block_pct = "アーマー自体がダメージ比率"
L.label_armor_damage_health_pct = "プレイヤーが受けるダメージ比率"
L.label_armor_enable_reinforced = "強化アーマーを有効"
L.label_armor_threshold_for_reinforced = "強化アーマーのしきい値"
L.label_sherlock_mode = "シャーロックモードを有効"
L.label_highlight_admins = "サーバー管理者のハイライト"
L.label_highlight_dev = "TTT2開発者ハイライト"
L.label_highlight_vip = "TTT2支援者のハイライト"
L.label_highlight_addondev = "TTT2アドオン開発者のハイライト"
L.label_highlight_supporter = "その他のハイライト"
L.label_enable_hud_element = "{elem}のHUD要素を有効"
L.label_spec_prop_control = "エンティティ憑依"
L.label_spec_prop_base = "基本的憑依価値"
L.label_spec_prop_maxpenalty = "憑依ボーナス最低制限"
L.label_spec_prop_maxbonus = "上限所有ボーナス限度額"
L.label_spec_prop_force = "エンティティ憑依のプッシュ力"
L.label_spec_prop_rechargetime = "再チャージ時間(秒)"
L.label_doors_force_pairs = "二重ドアとして強制的に閉じる"
L.label_doors_destructible = "ドアの損傷を有効"
L.label_doors_locked_indestructible = "鍵がかかっているドアへの破壊ができないようにする"
L.label_doors_health = "ドアの体力"
L.label_doors_prop_health = "破損済みのドアの体力"
L.label_minimum_players = "ラウンド開始に必要な最低人数"
L.label_karma = "カルマを有効"
L.label_karma_strict = "厳密なカルマを有効にする"
L.label_karma_starting = "初期カルマ"
L.label_karma_max = "カルマ最大値"
L.label_karma_ratio = "チームへのダメージによるカルマ減少率"
L.label_karma_kill_penalty = "チームキルによるカルマ減少率"
L.label_karma_round_increment = "カルマ復旧"
L.label_karma_clean_bonus = "ラウンド整理ボーナス"
L.label_karma_traitordmg_ratio = "敵へのダメージによるボーナス率"
L.label_karma_traitorkill_bonus = "敵の殺害によるキルボーナス"
L.label_karma_clean_half = "ラウンドボーナスの低減"
L.label_karma_persist = "カルマはマップの変更後でも持続"
L.label_karma_low_autokick = "低カルマ値の人を自動でキック"
L.label_karma_low_amount = "低カルマ値のしきい値"
L.label_karma_low_ban = "BANされるまでのカルマ値"
L.label_karma_low_ban_minutes = "BAN継続時間"
L.label_karma_debugspam = "カルマの変更に関するコンソールへのデバッグ出力を有効にする"
L.label_max_melee_slots = "近接武器スロット最大値"
L.label_max_secondary_slots = "セカンダリー武器スロット最大値"
L.label_max_primary_slots = "プライマリー武器スロット最大値"
L.label_max_nade_slots = "グレネードスロット最大値"
L.label_max_carry_slots = "運搬系スロット最大値"
L.label_max_unarmed_slots = "無防備スロット最大値"
L.label_max_special_slots = "特殊アイテムスロット最大値"
L.label_max_extra_slots = "その他スロット最大値"
L.label_weapon_autopickup = "自動で武器を拾う"
L.label_sprint_enabled = "走行を有効"
--L.label_sprint_max = "Speed boost factor"
L.label_sprint_stamina_consumption = "スタミナ消費率"
L.label_sprint_stamina_regeneration = "スタミナ再生率"
L.label_crowbar_unlocks = "バールによる鍵解除"
L.label_crowbar_pushforce = "バールで押す力"

-- 2022-07-02
L.header_playersettings_falldmg = "落下ダメージ設定"

L.label_falldmg_enable = "落下ダメージを有効にする。"
L.label_falldmg_min_velocity = "落下ダメージが発生するまでの最小落下速度"
L.label_falldmg_exponent = "落下速度に対する落下ダメージ増加指数"

L.help_falldmg_exponent = [[
この値は、プレイヤーが地面に当たる速度に応じて、落下ダメージが指数関数的に増加する方法を変更します。

この値を変更するときは注意してください。高すぎると、少し下っただけでも致命的になる可能性があり、低すぎると、プレイヤーは極端な高さから落下してもほとんどもしくは全くダメージを受けなくなってしまいます。]]

-- 2023-02-08
L.testpopup_title = "テストポップアップ、複数行のタイトルが追加されました、なんて素敵なんだ！"
L.testpopup_subtitle = "こんにちは！これは、いくつかの特別な情報を含む派手なポップアップです。テキストも複数行にすることができます、なんて派手なのでしょう！うーん、何かアイデアがあればもっと多くのテキストを追加できたのに..."

L.hudeditor_chat_hint1 = "[TTT2]要素にカーソルを合わせ、左クリックしたままマウスを動かして移動またはサイズ変更します。"
L.hudeditor_chat_hint2 = "[TTT2]Altキーを押したままにすると、対称的なサイズ変更ができます。"
L.hudeditor_chat_hint3 = "[TTT2]Shiftキーを押し続けると、軸上に移動し、アスペクト比が維持されます。"
L.hudeditor_chat_hint4 = "[TTT2]右クリックから「閉じる」を押してHUDエディタを終了することができます。"

L.guide_nothing_title = "まだ何もありません"
L.guide_nothing_desc = "こちらは現在開発中です。GitHubから私たちへの貢献を出来ればお願いします。"

L.sb_rank_tooltip_developer = "TTT2開発者"
L.sb_rank_tooltip_vip = "TTT2支援者"
L.sb_rank_tooltip_addondev = "TTT2アドオン開発者"
L.sb_rank_tooltip_admin = "サーバーアドミン"
L.sb_rank_tooltip_streamer = "ストリーマー"
L.sb_rank_tooltip_heroes = "TTT2ヒーローズ"
L.sb_rank_tooltip_team = "陣営"

L.tbut_adminarea = "アドミンエリア:"

-- 2023-08-10
L.equipmenteditor_name_damage_scaling = "ダメージスケーリング"

-- 2023-08-11
L.equipmenteditor_name_allow_drop = "投棄の許可"
L.equipmenteditor_desc_allow_drop = "有効にすることで、武器をいつでも落とすことができます。"

L.equipmenteditor_name_drop_on_death_type = "死亡時の投棄"
L.equipmenteditor_desc_drop_on_death_type = "有効にすることで、死亡時に装備がその場でばら撒かれるようになります。"

L.drop_on_death_type_default = "デフォルト"
L.drop_on_death_type_force = "死亡時の投棄"
L.drop_on_death_type_deny = "死亡時の拒否"

-- 2023-08-26
L.equipmenteditor_name_kind = "装備スロット"
L.equipmenteditor_desc_kind = "拡張パーツが占めるインベントリスロット"

L.slot_weapon_melee = "近接武器スロット"
L.slot_weapon_pistol = "セカンダリースロット"
L.slot_weapon_heavy = "プライマリースロット"
L.slot_weapon_nade = "グレネードスロット"
L.slot_weapon_carry = "運搬スロット"
L.slot_weapon_unarmed = "無防備スロット"
L.slot_weapon_special = "特殊武器スロット"
L.slot_weapon_extra = "エキストラスロット"
L.slot_weapon_class = "クラススロット"

-- 2023-10-04
L.label_voice_duck_spectator = "スペクテイターの声を消す"
L.label_voice_duck_spectator_amount = "スペクテイターの声量"
L.label_voice_scaling = "ボイス音量スケーリングモード"
L.label_voice_scaling_mode_linear = "リニア"
L.label_voice_scaling_mode_power4 = "パワー4"
L.label_voice_scaling_mode_log = "対数"

-- 2023-10-07
L.search_title = "調査結果 - {player}"
L.search_info = "情報"
L.search_confirm = "確認済み"
L.search_confirm_credits = "{credits}クレジットを確認"
L.search_take_credits = "{credits}クレジットを回収する"
L.search_confirm_forbidden = "秘匿を確認"
L.search_confirmed = "死亡が確認された"
L.search_call = "死亡報告する"
L.search_called = "死亡報告された"

L.search_team_role_unknown = "???"

L.search_words = "遺言:「{lastwords}」"
L.search_armor = "ボディアーマーを着ていたようだ。"
L.search_disguiser = "変装をしていたようだ。"
L.search_radar = "レーダーを所持していたようだ。もう機能していないがな。"
L.search_c4 = "ポケットからメモを見つけた。「爆弾を解除するには{num}番のワイヤーをカットしろ」と書かれている。"

L.search_dmg_crush = "こいつの骨の多くが折れている。重たい物でもぶつかって死んだようだ。"
L.search_dmg_bullet = "こいつは撃たれて死んだようだな。"
L.search_dmg_fall = "こいつは転落死したようだな。"
L.search_dmg_boom = "こいつの傷と焼けた衣服から見ると、爆発で死んだように思えるな。"
L.search_dmg_club = "死体には打撲傷と殴られた跡がある。殴られて死んだようだな。"
L.search_dmg_drown = "死因は溺死のようだ。"
L.search_dmg_stab = "こいつは刃物に刺されて出血死したようだ。。"
L.search_dmg_burn = "この辺りにはテロリストが焼けたような臭いがするな..."
L.search_dmg_teleport = "こいつのDNAはタキオン粒子の放出によってかき混ぜられたように見えるな。"
L.search_dmg_car = "このテロリストが道路を渡った際、野蛮なドライバーにでも轢かれたのか。"
L.search_dmg_other = "このテロリストの死因を特定できない。"

L.search_floor_antlions = "まだ全身に蟻がいます。床はきっとそれらで覆われているに違いない。"
L.search_floor_bloodyflesh = "この体についた血は古くて嫌に見えます。彼らの靴には血まみれの肉片が少しも付着しています。"
L.search_floor_concrete = "灰色の埃が彼らの靴と膝を覆っています。犯行現場にはコンクリートの床があったように見えます。"
L.search_floor_dirt = "泥の匂いがします。それはおそらく、被害者の靴にまとわりつく汚れから来ているのでしょう。"
L.search_floor_eggshell = "被害者の体を覆ってるのは何か嫌な白い斑点のようだ。卵の殻のようにも見えます。"
L.search_floor_flesh = "被害者の服はちょっとしっとりした感じがします。まるで濡れた表面に落ちたかのように。肉質の表面のように、または水域の砂地のように。"
L.search_floor_grate = "被害者の皮はステーキのように見えます。格子状に配置された太い線が、そのいたるところに見えます。格子の上にでも休んでいたんだろうか？"
L.search_floor_alienflesh = "エイリアンの肉体だと思いますか?ちょっと話が突拍子に聞こえます。しかし、あなたの探偵ヘルパーの本には、可能な床面としてリストされています。"
L.search_floor_snow = "一見すると、彼らの服は濡れて氷のように冷たく感じるだけです。しかし、リムの白いフォームを見れば理解できます。そう、雪です!"
L.search_floor_plastic = "「痛い、何か怪我したに違いない」彼らの体は火傷で覆われています。プラスチックの表面を滑ったときのように見えます。"
L.search_floor_metal = "少なくとも、彼らは死んだ今、破傷風にかかることはできません。傷口は錆で覆われています。彼らはおそらく金属表面で死んだでしょう。"
L.search_floor_sand = "その冷たい体には、小さな小さなざらざらした岩がくっついています。ビーチの粗い砂のように。ああ、どこにでも行きます！"
L.search_floor_foliage = "自然は素晴らしい。被害者の血まみれな傷がほとんど隠れるほど葉っぱで覆われています。"
L.search_floor_computer = "ピーピー。コンピューターの表面で覆われています！これはどのように見えるのか、と疑問に思うかもしれません。まあ、当たり前ですが。"
L.search_floor_slosh = "濡れていて、少しぬるぬるしているかもしれません。全身がそれに覆われて服はびしょ濡れです。しかも臭い！"
L.search_floor_tile = "小さな破片が皮膚に付着しています。衝撃で粉々になった床タイルの破片のように。"
L.search_floor_grass = "刈りたての草のような香りがします。その匂いは、血と死の匂いをほとんど誤魔化してくれます。"
L.search_floor_vent = "相手の体に触れると、新鮮な空気が湧き出るのを感じます。彼らは通気口で死んで、空気を吸い込んだのでしょうか？"
L.search_floor_wood = "堅木張りの床に座って物思いにふけることほど素晴らしいことは何だろうか？少なくとも、木の床に横たわっている沢山の死体だろう！"
L.search_floor_default = "それはとても基本的で、とても普通のことのように思えます。ほぼデフォルト。表面の種類については何もわかりません。"
L.search_floor_glass = "彼らの体は多くの血まみれの切り傷で覆われています。それらのいくつかでは、ガラスの破片が詰まっており、あなたにとってかなり脅威に見えます。"
L.search_floor_warpshield = "ワープシールドで作られた床?うん、私たちもあなたと同じように混乱しています。しかし、私たちのメモにははっきりと書かれています。ワープシールドとね。"

L.search_water_1 = "被害者の靴は濡れていますが、残りの部分は乾いているようです。おそらく足を水につけたまま殺されたのでしょう。"
L.search_water_2 = "被害者の靴やズボンがびしょ濡れです。殺される前に水の中をさまよっていたのでしょうか？"
L.search_water_3 = "全身が濡れて腫れています。おそらく完全に水没している間に死んだでしょう。"

L.search_weapon = "{weapon}によって殺されたようだな。"
L.search_head = "ヘッドショットされたのか。叫ぶ暇も無いな。"
L.search_time = "捜索を行う丁度少し前に亡くなったようだ。"
L.search_dna = "DNAスキャナーで殺人犯のDNAサンプルを回収します。DNAサンプルはしばらくすると崩壊します。"

L.search_kills1 = "{player}の死を立証するための殺害リストを見つけた。"
L.search_kills2 = "これらの名前の載った殺害リストを見つけた:{player}"
L.search_eyes = "こいつが最後の人物は、{player}。こいつは敵か、それとも偶然か？"

L.search_credits = "被害者に{credits}クレジットがポケット内にあった。ショップを使用できる役職はそれらをうまく活用するかもしれない。目を離すな！"

L.search_kill_distance_point_blank = "至近距離からあっという間だった。"
L.search_kill_distance_close = "攻撃は近距離から来たようだ。"
L.search_kill_distance_far = "攻撃は遠距離から来たようだ。"

L.search_kill_from_front = "被害者は正面から撃たれたようだ。"
L.search_kill_from_back = "被害者は後ろから撃たれたようだ。"
L.search_kill_from_side = "被害者は横から撃たれたようだ。"

L.search_hitgroup_head = "弾丸が頭から見つかった"
L.search_hitgroup_chest = "弾丸が胸から見つかった"
L.search_hitgroup_stomach = "弾丸が腹から見つかった"
L.search_hitgroup_rightarm = "弾丸が右腕から見つかった"
L.search_hitgroup_leftarm = "弾丸が左腕から見つかった"
L.search_hitgroup_rightleg = "弾丸が右脚から見つかった"
L.search_hitgroup_leftleg = "弾丸が左脚から見つかった"
L.search_hitgroup_gear = "弾丸が尻から見つかった"

L.search_policingrole_report_confirm = [[
Detectiveは、死体が確認された後にのみ、死体の位置に呼ぶことができます。]]
L.search_policingrole_confirm_disabled_1 = [[
死体はDetectiveのみ確認することができます。まず死体を報告するんだ！]]
L.search_policingrole_confirm_disabled_2 = [[
死体は、Detectiveのみ確認することができます。まず死体を報告するんだ！
彼らが確認した後、ここで情報を見ることができます。]]
L.search_spec = [[
スペクテイターは、死体のすべての情報を見ることができますが、UIは操作することはできません。]]

L.search_title_words = "被害者の遺言"
L.search_title_c4 = "事故の解決"
L.search_title_dmg_crush = "衝突によるダメージ ({amount} HP)"
L.search_title_dmg_bullet = "銃撃によるダメージ({amount} HP)"
L.search_title_dmg_fall = "落下によるダメージ ({amount} HP)"
L.search_title_dmg_boom = "爆発によるダメージ ({amount} HP)"
L.search_title_dmg_club = "打撃によるダメージ ({amount} HP)"
L.search_title_dmg_drown = "溺水によるダメージ ({amount} HP)"
L.search_title_dmg_stab = "裂傷によるダメージ ({amount} HP)"
L.search_title_dmg_burn = "火傷によるダメージ ({amount} HP)"
L.search_title_dmg_teleport = "瞬間移動時のダメージ ({amount} HP)"
L.search_title_dmg_car = "衝突事故によるダメージ ({amount} HP)"
L.search_title_dmg_other = "意味不明なダメージ ({amount} HP)"
L.search_title_time = "死亡時間"
L.search_title_dna = "DNAサンプルの腐敗"
L.search_title_kills = "被害者による殺害者リスト"
L.search_title_eyes = "殺人者の影"
L.search_title_floor = "Floor of the crime scene"
L.search_title_credits = "{credits}クレジット"
L.search_title_water = "溺水レベル{level}"
L.search_title_policingrole_report_confirm = "死亡報告の確認"
L.search_title_policingrole_confirm_disabled = "死亡を報告する"
L.search_title_spectator = "現在スペクテイターモードです"

L.target_credits_on_confirm = "未使用のクレジットの受け取りを確認する"
L.target_credits_on_search = "確認して未使用のクレジットを受け取る"
L.corpse_hint_no_inspect_details = "この死体に関する情報を見つけることができるのは、Detectiveだけです。"
L.corpse_hint_inspect_limited_details = "Detectiveのみ遺体を確認することができます。"
L.corpse_hint_spectator = "[{usekey}]でUIを確認することができます。"
L.corpse_hint_public_policing_searched = "[{usekey}]でDetectiveによる確認による結果を閲覧することができます。"

L.label_inspect_confirm_mode = "死体捜索モードを選択"
L.choice_inspect_confirm_mode_0 = "モード0: スタンダードTTT"
L.choice_inspect_confirm_mode_1 = "モード1: 限定的な確認"
L.choice_inspect_confirm_mode_2 = "モード2: 限定的な検知"
L.help_inspect_confirm_mode = [[
このゲームモードには、3つの異なる死体捜索/確認モードがあります。このモードの選択は、Detectiveのような探偵系役職の重要性に大きな影響を与えます。

モード0: これが基本的なモードです。誰でも遺体を捜索・確認することができます。遺体を報告したり、遺体からクレジットを取得したりするには、まず遺体を確認する必要があります。これにより、ショップを使用できる役職がこっそりクレジットを盗むことが少し難しくなります。ただし、無実のプレイヤーが遺体を報告して探偵系役職に連絡したい場合は、最初に確認する必要があります。

モード1:このモードは、確認を探偵系役職に限定することで、探偵系役職の重要性を高めます。これは、遺体を確認する前に、クレジットを取得し、遺体を報告することも可能になったことを意味します。誰もがまだ死体を探して情報を見つけることができますが、見つけた情報を公表することはできません。

モード2: このモードは、モード1よりも少し厳格です。このモードでは、通常のプレイヤーからも検索能力が削除されます。つまり、死体をDetectiveに報告することが、死体から情報を得る唯一の方法になったのです。]]

-- 2023-10-19
L.label_grenade_trajectory_ui = "手榴弾軌道インジケーター"

-- 2023-10-23
L.label_hud_pulsate_health_enable = "体力が25%未満の場合、HPバーを振動させる"
L.header_hud_elements_customize = "HUDエレメントのカスタマイズ"
L.help_hud_elements_special_settings = "これらは、使用するHUDエレメントにおける固有設定です。"

-- 2023-10-25
L.help_keyhelp = [[
キーバインドヘルパーは、常に関連するキーバインドをプレイヤーに表示するUI要素であり、特に新しいプレイヤーに役立ちます。キーバインディングには、次の3つのタイプがあります。

Core: TTT2で見つかった最も重要なバインディングが含まれています。彼らがいなければ、ゲームはその可能性を最大限に発揮するのは難しいでしょう。
Extra: Coreと似ていますが、常に必要というわけではありません。チャット、音声、懐中電灯などが含まれています。これを有効にすることで、新しいプレイヤーが役立つ場合があります。
Equipment: 一部の装備アイテムには独自のバインディングがあり、これらはこのカテゴリに表示されます。

無効になったカテゴリは、スコアボードが表示されていても引き続き表示されます]]

L.label_keyhelp_show_core = "Coreバインディングの有効"
L.label_keyhelp_show_extra = "Extraバインディングの有効"
L.label_keyhelp_show_equipment = "Equipmentバインディングの有効"

L.header_interface_keys = "キーヘルパー設定"
L.header_interface_wepswitch = "武器交換UI設定"

L.label_keyhelper_help = "ゲームモードメニューを開く"
L.label_keyhelper_mutespec = "スペクテイターにおけるミュートモードの切り替え"
L.label_keyhelper_shop = "装備ショップを開く"
L.label_keyhelper_show_pointer = "マウスポインタを表示させる"
L.label_keyhelper_possess_focus_entity = "正面のエンティティに憑依する"
L.label_keyhelper_spec_focus_player = "正面のプレイヤーを監視する"
L.label_keyhelper_spec_previous_player = "前のプレイヤー"
L.label_keyhelper_spec_next_player = "次のプレイヤー"
L.label_keyhelper_spec_player = "ランダムのプレイヤーを監視する"
L.label_keyhelper_possession_jump = "ジャンプ"
L.label_keyhelper_possession_left = "左"
L.label_keyhelper_possession_right = "右"
L.label_keyhelper_possession_forward = "前"
L.label_keyhelper_possession_backward = "後"
L.label_keyhelper_free_roam = "憑依をやめる"
L.label_keyhelper_flashlight = "懐中電灯"
L.label_keyhelper_quickchat = "クイックチャット"
L.label_keyhelper_voice_global = "ボイスチャット"
L.label_keyhelper_voice_team = "チームボイスチャット"
L.label_keyhelper_chat_global = "テキストチャット"
L.label_keyhelper_chat_team = "チームテキストチャット"
L.label_keyhelper_show_all = "全ての閲覧"
L.label_keyhelper_disguiser = "変装の切り替え"
L.label_keyhelper_save_exit = "保存/中断"
L.label_keyhelper_spec_third_person = "三人称視点の切り替え"

-- 2023-10-26
L.item_armor_reinforced = "強化アーマー"
L.item_armor_sidebar = "アーマーは、弾丸が体を貫通するのを防いでくれます。しかし、永続的ではないことに注意。"
L.item_disguiser_sidebar = "変装者は、他のプレイヤーにあなたの名前を見せないようにすることで、あなたの身元を保護してくれます。"
L.status_speed_name = "スピード増加"
L.status_speed_description_good = "通常よりも速いです。アイテム、装備、エフェクトがこれに影響を与える可能性があります。"
L.status_speed_description_bad = "通常よりも遅いです。アイテム、装備、エフェクトがこれに影響を与える可能性があります。"

L.status_on = "on"
L.status_off = "off"

L.crowbar_help_primary = "打撃"
L.crowbar_help_secondary = "プレイヤーを押す"

-- 2023-10-27
L.help_HUD_enable_description = [[
キーヘルパーやサイドバーなどの一部のHUD要素は、スコアボードが開いているときに詳細情報を表示します。これを無効にすると、煩雑さを減らすことができます。]]
L.label_HUD_enable_description = "スコアボードが開いているときの説明の有効"
L.label_HUD_enable_box_blur = "UIボックスの背景のぼかしの有効"

-- 2023-10-28
L.submenu_gameplay_voiceandvolume_title = "ボイスと音量"
L.header_soundeffect_settings = "音響関連"
L.header_voiceandvolume_settings = "ボイスと音量設定"

-- 2023-11-06
L.drop_reserve_prevented = "何かが予備の弾薬を落とすのを妨げています。"
L.drop_no_reserve = "予備の弾薬が不足しているため、弾薬箱としてドロップできません。"
L.drop_no_room_ammo = "弾薬を捨てたいがそのためのスペースが足りない。"

-- 2023-11-14
L.hat_deerstalker_name = "Detectiveの帽子"

-- 2023-11-16
L.help_prop_spec_dash = [[
Propspecダッシュは、照準ベクトルの方向への移動です。それらは、通常の動きよりも高い力を持つことができます。力が大きければ大きいほど、基本値の消費量も大きくなります。

この変数は、押す力の乗数です。]]
L.label_spec_prop_dash = "ダッシュフォースマルチプライヤー"
L.label_keyhelper_possession_dash = "プロップ: ビュー方向へのダッシュ"
L.label_keyhelper_weapon_drop = "可能な場合は選択した武器をドロップする"
L.label_keyhelper_ammo_drop = "選択した武器から予約済みの弾薬をドロップする"

-- 2023-12-07
L.c4_help_primary = "C4を設置する"
L.c4_help_secondary = "平面に設置する"

-- 2023-12-11
L.magneto_help_primary = "エンティティを押す"
L.magneto_help_secondary = "エンティティを引く、もしくは拾う"
L.knife_help_primary = "刺突"
L.knife_help_secondary = "ナイフ投擲"
L.polter_help_primary = "thumperを発射する"
L.polter_help_secondary = "長距離まで撃てるようチャージする"

-- 2023-12-12
L.newton_help_primary = "ノックバックショット"
L.newton_help_secondary = "ノックバックショットをチャージする"

-- 2023-12-13
L.vis_no_pickup = "Detectiveのような役職のみ可視化装置を拾うことができます"
L.newton_force = "発射"
L.defuser_help_primary = "目の前のC4を解除する"
L.radio_help_primary = "ラジオを設置する"
L.radio_help_secondary = "平面に設置する"
L.hstation_help_primary = "回復ステーションを設置する"
L.flaregun_help_primary = "死体やエンティティを焼却する"

-- 2023-12-14
L.marker_vision_owner = "所持者: {owner}"
L.marker_vision_distance = "距離: {distance}"
L.marker_vision_distance_collapsed = "{distance}"

L.c4_marker_vision_time = "爆発まで{time}秒"
L.c4_marker_vision_collapsed = "{time} / {distance}"

L.c4_marker_vision_safe_zone = "爆破のセーフゾーン"
L.c4_marker_vision_damage_zone = "爆破のダメージゾーン"
L.c4_marker_vision_kill_zone = "爆破のキルゾーン"

L.beacon_marker_vision_player = "プレイヤーの追跡"
L.beacon_marker_vision_player_tracked = "このプレイヤーはビーコンにより追跡されています"

-- 2023-12-18
L.beacon_help_pri = "地面にビーコンを落とす"
L.beacon_help_sec = "ビーコンを平面に設置する"
L.beacon_name = "ビーコン"
L.beacon_desc = [[
このビーコンの周りの球体にいる全員に

プレイヤーの位置をブロードキャストします。

主に地図上で見つけづらい場所を探すために使用します。]]

L.msg_beacon_destroyed = "ビーコンが破壊されました！"
L.msg_beacon_death = "ビーコンの近くでプレイヤーが死亡したようだ"

L.beacon_short_desc = "ビーコンはDetectiveのみ使用することができ、周囲のウォールハックをしてくれます"

L.entity_pickup_owner_only = "所持者のみ回収が可能です"

L.body_confirm_one = "{finder}は{victim}の死を確認した。"
L.body_confirm_more = "{finder}は死亡回数が{count}である{victims}を確認した。"

-- 2023-12-19
L.builtin_marker = "ビルトインしました。"
L.equipmenteditor_desc_builtin = "この装備はビルトインされています。"
L.help_roles_builtin = "この役職はビルトインされています。"
L.header_equipment_info = "装備情報"

-- 2023-12-20
L.equipmenteditor_desc_damage_scaling = [[武器の基本ダメージ値にこの係数を掛けます。
ショットガンの場合、これは各ペレットに影響します。
ライフルの場合、これは弾丸だけに影響します。
ポルターガイストの場合、爆発に影響を与えます。

0.5 = ダメージを半分へと低減
2 = ダメージを2倍へと増加

注: 一部の武器ではこの値を使用しない場合があり、その場合この倍率は無効になります。]]

-- 2023-12-24
L.submenu_gameplay_accessibility_title = "アクセシビリティ"

L.header_accessibility_settings = "アクセシビリティ設定"

L.label_enable_dynamic_fov = "動的なFOVを有効にする"
L.label_enable_bobbing = "視界の揺れを有効にする"
L.label_enable_bobbing_strafe = "機銃掃射時の揺れを有効にする"

L.help_enable_dynamic_fov = "動的なFOVは、プレイヤーの速度に応じて適用されます。例えば、プレイヤーが全力疾走しているとき、速度を視覚化するためにFOVが増加します。"
L.help_enable_bobbing_strafe = "視界の揺れは、歩いたり、泳いだり、転んだりするときのわずかな手ぶれです。"

L.binoc_help_reload = "ターゲットクリア"
L.cl_sb_row_sresult_direct_conf = "直接確認"
L.cl_sb_row_sresult_pub_police = "探偵系役職の確認"

-- 2024-01-05
L.label_crosshair_thickness_outline_enable = "クロスへの外枠を有効にする"
L.label_crosshair_outline_high_contrast = "外枠のハイコントラストカラーを有効にする"
L.label_crosshair_mode = "クロスヘアモード"
L.label_crosshair_static_length = "静的なクロスヘアの長さを有効にする"

L.choice_crosshair_mode_0 = "線とドット"
L.choice_crosshair_mode_1 = "線のみ"
L.choice_crosshair_mode_2 = "ドットのみ"

L.help_crosshair_scale_enable = [[
ダイナミッククロスヘアにより、武器の円錐に応じてクロスヘアをスケーリングできます。円錐形は、武器の基本精度に、ジャンプやダッシュなどの外的要因が加わった影響を受けます。

線分の長さが静的なままの場合、ギャップのみが円錐とともに変化します。]]

L.header_weapon_settings = "武器設定"

-- 2024-01-24
L.grenade_fuse = "ヒューズ"

-- 2024-01-25
L.header_roles_magnetostick = "マグネットスティック"
L.label_roles_ragdoll_pinning = "ラグドールの固定の有効"
L.magneto_stick_help_carry_rag_pin = "ラグドールの固定"
L.magneto_stick_help_carry_rag_drop = "ラグドールを落とす"
L.magneto_stick_help_carry_prop_release = "エンティティを放す"
L.magneto_stick_help_carry_prop_drop = "エンティティを落とす"

-- 2024-01-27
L.decoy_help_primary = "デコイを設置する"
L.decoy_help_secondary = "デコイを平面に設置する"


L.marker_vision_visible_for_0 = "あなたに見える"
L.marker_vision_visible_for_1 = "あなたの役職に見える"
L.marker_vision_visible_for_2 = "仲間たちのみ見えます"
L.marker_vision_visible_for_3 = "全員に見えます"

-- 2024-02-14
L.throw_no_room = "この機器を落とすためのスペースが足りないようだ。"

-- 2024-03-04
L.use_entity = "[{usekey}]で使用する"

-- 2024-03-06
L.submenu_gameplay_sounds_title = "クライアントサウンド"

L.header_sounds_settings = "UIサウンド設定"

L.help_enable_sound_interact = "インタラクション音は、UIを開いたときに再生される音です。このような音は、たとえばラジオマーカーと対話するときに再生されます。"
L.help_enable_sound_buttons = "ボタンサウンドは、ボタンをクリックしたときに再生されるカチッとする音のことです。"
L.help_enable_sound_message = "メッセージまたは通知音は、チャットメッセージと通知で再生されます。彼らはかなり不快になることがあります。"

L.label_enable_sound_interact = "インタラクション音を有効にする"
L.label_enable_sound_buttons = "ボタン音を有効にする"
L.label_enable_sound_message = "メッセージ音を有効にする"

L.label_level_sound_interact = "インタラクション音の段階倍率"
L.label_level_sound_buttons = "ボタン音の段階倍率"
L.label_level_sound_message = "メッセージ音の段階倍率"

-- 2024-03-07
L.label_crosshair_static_gap_length = "静的なクロスヘアギャップサイズを有効にする"
L.label_crosshair_size_gap = "クロスヘアギャップサイズの倍率"

-- 2024-03-31
L.help_locational_voice = "近接ボイスチャットとは、TTT2におけるロケーション3D音声のことです。プレイヤーの声は周囲に設定された半径内でのみ聞こえ、離れるほど静かになります。"
L.help_locational_voice_prep = [[デフォルトでは、近接ボイスチャットは準備フェーズでは無効になっています。このオプションを有効にすることで、準備フェーズで近接ボイスチャットも有効になります。

注:ラウンド後のフェーズでは、近接ボイスチャットは設定に関わらず常に無効になります。]]
L.help_voice_duck_spectator = "スペクテイター達の声を消音することで、他のスペクテイターは生存者達と比べて静かになります。生存者達の議論をじっくり聞きたい時に便利です。"

L.help_equipmenteditor_configurable_clip = [[設定可能なサイズは、ショップで購入したとき、またはワールドでスポーンしたときの武器の使用量を定義します。

注: この設定は、この機能を有効にしている武器でのみ使用できます。]]
L.label_equipmenteditor_configurable_clip = "設定可能なクリップサイズ"

-- 2024-04-06
L.help_locational_voice_range = [[このオプションは、プレイヤー同士の声が聞こえる最大範囲を制限します。距離とともにボリュームが減少する方法は変わりませんが、ハードカットオフポイントが設定されます。

このカットオフを無効にするには、0に設定します。]]

-- 2024-04-07
L.help_voice_activation = [[ボイスチャットのマイクの有効化方法を変更できます。これらはすべて「ボイスチャット」キーバインドを使用します。チームボイスチャットは基本的にプッシュ・トゥ・トークです。

プッシュ・トゥ・トーク:キーを押し続けることで話せます。
プッシュ・トゥ・ミュート:キーを押し続けることでミュートになります。
トグル:キーを押して、マイクのオン/オフを切り替えます。
トグル(参加時に有効):「トグル」に似ていますが、サーバーに参加するとマイクが有効になります。]]
L.label_voice_activation = "ボイスチャット有効化モード"
L.label_voice_activation_mode_ptt = "話す"
L.label_voice_activation_mode_ptm = "ミュート"
L.label_voice_activation_mode_toggle_disabled = "トグル"
L.label_voice_activation_mode_toggle_enabled = "トグル(参加時に有効)"

-- 2024-04-08
L.label_inspect_credits_always = "全てのプレイヤーに死体に残ったクレジットを見ることを許可する"
L.help_inspect_credits_always = [[
ショップを使用することができる役職が死亡すると、そのクレジットは同様なプレイヤーが引き継ぐことができます。

このオプションを無効にすることで、クレジットを拾うことができるプレイヤーのみが死体からクレジットを見ることができます。
有効にすることで、全プレイヤーが死体からクレジットを表示できます。]]

-- 2024-05-13
L.menu_commands_title = "管理者コマンド"
L.menu_commands_description = "マップの変更や、ボットの生成や役職の変更ができます。"

L.submenu_commands_maps_title = "マップ"

L.header_maps_prefixes = "Prefixによるマップの有効の有無"
L.header_maps_select = "マップの選択・変更"

L.button_change_map = "マップ変更"

-- 2024-05-20
L.submenu_commands_commands_title = "コマンド"

L.header_commands_round_restart = "ラウンドリスタート"
L.header_commands_player_slay = "プレイヤー消去"
L.header_commands_player_teleport = "正面にプレイヤー召喚"
L.header_commands_player_respawn = "正面にプレイヤーを復活させる"
L.header_commands_player_add_credits = "クレジット追加"
L.header_commands_player_set_health = "HPの変更"
L.header_commands_player_set_armor = "アーマー装着"

L.label_button_round_restart = "ラウンドリスタート"
L.label_button_player_slay = "プレイヤー消去"
L.label_button_player_teleport = "プレイヤー転送"
L.label_button_player_respawn = "プレイヤーのリスポーン"
L.label_button_player_add_credits = "クレジット追加"
L.label_button_player_set_health = "HPの変更"
L.label_button_player_set_armor = "アーマー装着"

L.label_slider_add_credits = "クレジット追加"
L.label_slider_set_health = "HPの変更"
L.label_slider_set_armor = "アーマー装着"

L.label_player_select = "プレイヤー選択"
L.label_execute_command = "Executeコマンド"

-- 2024-05-22
L.tip38 = "{usekey}で正面にある武器を拾うことができます。 そうすることで既に所持している武器と交換できます。"
L.tip39 = "{helpkey}から開くことができるメニューにおけるキー設定により、キーバインドの設定することができます。"
L.tip40 = "画面の左側には、現在適用されている装備またはステータス効果を示すアイコンが表示されています。"
L.tip41 = "スコアボードを開くことで、サイドバーとキーヘルパーに追加情報が表示されます。"
L.tip42 = "画面下部のキーヘルパーには、その時点で使用可能なキーバインドが表示されます。"
L.tip43 = "確認された死体の名前の横にあるアイコンは、死亡したプレイヤーの役職を示しています。"

L.header_loadingscreen = "ロード画面"

L.help_enable_loadingscreen = "ロード画面は、ラウンド後にマップが更新されると表示されます。基本的に大きなマップに表示される可視および可聴の遅延を隠すために導入されました。また、ゲームプレイのヒントを示すためにも使用されます。"

L.label_enable_loadingscreen = "ロード画面の有効"
L.label_enable_loadingscreen_tips = "ロード画面におけるヒントの有効"

-- 2024-05-25
L.help_round_restart_reset = [[
ラウンドを再開するか、レベルをリセットします。

ラウンドを再開すると、現在のラウンドのみが再開されるため、最初からやり直すことができます。レベルをリセットするとすべてがクリアされ、マップ変更後の新しいゲームのようにゲームが新しく開始されます。]]

L.label_button_level_reset = "リセットレベル"

L.loadingscreen_round_restart_title = "新しいラウンドの開始中"
--L.loadingscreen_round_restart_subtitle_limits_mode_0 = "you're playing on {map}"
--L.loadingscreen_round_restart_subtitle_limits_mode_1 = "you're playing on {map} for another {rounds} round(s) or {time}"
--L.loadingscreen_round_restart_subtitle_limits_mode_2 = "you're playing on {map} for {time}"
--L.loadingscreen_round_restart_subtitle_limits_mode_3 = "you're playing on {map} for another {rounds} round(s)"

-- 2024-06-23
L.header_roles_derandomize = "役職のランダム化"

L.help_roles_derandomize = [[
役職のランダム化は、セッションの過程で役職の配分をより公平に感じさせるために使用できます。

基本的にこれを有効にすることで、プレイヤーがその役職を割り当てられていない間に役職を受け取る確率が増加します。これによってより公平に感じられるかもしれませんが、これによりメタゲーミングも可能になり、プレイヤーはいくつかのラウンドでTraitorと同盟を組んでいないという事実に基づいて、他のプレイヤーがTraitorと同盟関係にあると推測することができます。このオプションが望ましくない場合は、このオプションを有効にしないでください。

次の4つのモードがあります。

モード0: 無効 - ランダム化は行われません。

モード1: 基本役職のみ - ランダム化は基本役職に対してのみ実行されます。サブ役職はランダムに選択されます。これらは、InnocentやTraitorのような役割です。

モード2: サブ役職のみ - サブ役職に対してのみランダム化が実行されます。基本役職はランダムに選択されます。サブ役職は、基本役職にすでに選択されているプレイヤーにのみ割り当てられることに注意してください。

モード3: 基本役職とサブ役職 - 基本役職とサブ役職の両方に対してランダム化解除が実行されます。]]
L.label_roles_derandomize_mode = "ランダム化モード"
L.label_roles_derandomize_mode_none = "モード0: 無効"
L.label_roles_derandomize_mode_base_only = "モード1: 基本役職のみ"
L.label_roles_derandomize_mode_sub_only = "モード2: サブ役職のみ"
L.label_roles_derandomize_mode_base_and_sub = "モード3: 基本役職とサブ役職"

L.help_roles_derandomize_min_weight = [[
ランダム化は、役職配布中にランダムにプレイヤーを選択する際に、各プレイヤーの各役職に関連付けられた重みを使用し、その重みがプレイヤーにその役職が割り当てられないたびに1ずつ増加させることによって実行されます。これらの重みは、接続間またはマップ間で保持されません。

プレイヤーに役職が割り当てられるたびに、対応する重みはこの最小の重みにリセットされます。この重みには絶対的な意味はありません。これは、他の重みに関してのみ解釈できます。

たとえば、プレイヤーAの重みが1で、プレイヤーBの重みが5の場合、プレイヤーBはプレイヤーAよりも5倍選択される可能性が高くなります。ただし、プレイヤーAの重みが4の場合、プレイヤーBは選択される可能性が5/4倍しか高くありません。

したがって、最小の重みは、各ラウンドがプレイヤーの選択確率にどの程度影響するかを効果的に制御し、値が高いほど影響が少なくなります。デフォルト値の1は、各ラウンドで確率がかなり大幅に増加することを意味し、逆に、プレイヤーが同じ役割を2回連続で取得する可能性は極めて低いことを意味します。

この値の変更は、プレイヤーが再接続するか、マップが変更されるまで有効になりません。]]
L.label_roles_derandomize_min_weight = "脱乱択の最小の重み"

-- 2024-08-17
L.name_button_default = "ボタン"
L.name_button_rotating = "レバー"

L.button_default = "[{usekey}]で引く"
L.button_rotating = "[{usekey}]でさっと動かす"

L.undefined_key = "???"

-- 2024-08-18
L.header_commands_player_force_role = "役職の強制決定"

L.label_button_player_force_role = "役職の強制決定"

L.label_player_role = "役職選択"

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
L.length_in_meters = "{length}m"
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
