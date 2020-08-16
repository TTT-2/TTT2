---- Japanese language strings

local L = LANG.CreateLanguage("日本語")

--- General text used in various places
L.traitor    = "Traitor"
L.detective  = "Detective"
L.innocent   = "Innocent"
L.last_words = "最期の言葉"

L.terrorists = "テロリスト"
L.spectators = "観戦者"

L.noteam = "無所属"
L.innocents = "Innocent陣営"
L.traitors = "Traitor陣営"

-- role description
L.ttt2_desc_none = "今のところあなたは役職もちではありません!"
L.ttt2_desc_innocent = "あなたの目標はTraitorから生き延びることです!!"
L.ttt2_desc_traitor = "Traitorショップ([C])を用いてTraitor陣営以外を殺しましょう!"
L.ttt2_desc_detective = "あなたはDetectiveです! Innocentの生存を手助け、Traitorを探しましょう!"

--- Round status messages
L.round_minplayers = "新しいラウンドを開始するのに十分なプレイヤーがいません…"
L.round_voting     = "投票中, {num}秒まで新しいラウンドを延期しています."
L.round_begintime  = "{num}秒内に新しいラウンドを開始します. 準備してくださいね."
L.round_selected   = "Traitorが選ばれました."
L.round_started    = "ラウンドを開始します!"
L.round_restart    = "ラウンドは管理者によってリスタートされます."

L.round_traitors_one  = "Traitorさん, あなたは一人です."
L.round_traitors_more = "Traitor達、力を合わせて彼らを皆殺しにしましょう."

L.win_time         = "時間切れです. Traitorは負けました."
L.win_traitors      = "Traitorが勝ちました!"
L.win_innocents     = "Traitorは倒されました!"
L.win_bees = "蜂が勝ちました! (つまり引き分け)"
L.win_showreport   = "さあ{num}秒の間ラウンドレポートを見てみましょう."

L.limit_round      = "ラウンドリミットに達しました. {mapname}がすぐにロードされるでしょう."
L.limit_time       = "タイムリミットに達しました. {mapname}がすぐにロードされるでしょう."
L.limit_left       = "{mapname}にマップ変更するまで{num}ラウンドないし{time}分残っています."

--- Credit awards
L.credit_det_all   = "Detectiveさん, あなたは任務遂行のために{num}クレジットを与えられました."
L.credit_tr_all    = "Traitorさん, あなたは任務遂行のために{num}クレジットを与えられました."

L.credit_kill      = "あなたは{role}を始末したため{num}クレジットを受け取りました."

--- Karma
L.karma_dmg_full   = "あなたのカルマは{amount}なのでこのラウンドでは最大のダメージを与えられますよ!"
L.karma_dmg_other  = "あなたのカルマは{amount}です. 結果としてあなたの与える全てのダメージは{num}%減少します."

--- Body identification messages
L.body_found       = "{finder}は{victim}の死体を見つけました. {role}"

-- The {role} in body_found will be replaced by one of the following:
L.body_found_t     = "彼はTraitorでした!"
L.body_found_d     = "彼はDetectiveでした."
L.body_found_i     = "彼はInnocentでした."

L.body_confirm     = "{finder}は{victim}の死を確認しました."

L.body_call        = "{player}はDetectiveを{victim}の死体の場所に呼びました!"
L.body_call_error  = "あなたはDetectiveを呼ぶ前にこのプレイヤーの死を確認しなくてはなりません!"

L.body_burning     = "痛っ! この死体は燃えていますよ!"
L.body_credits     = "あなたは死体から{num}クレジットを見つけました!"

--- Menus and windows
L.close = "閉じる"
L.cancel = "キャンセル"

-- For navigation buttons
L.next = "次へ"
L.prev = "前へ"

-- Equipment buying menu
L.equip_title     = "装備品"
L.equip_tabtitle  = "装備品購入"

L.equip_status    = "Ordering status"
L.equip_cost      = "あなたは残り{num}クレジット持っています."
L.equip_help_cost = "いずれの装備も購入費用は1クレジットです."

L.equip_help_carry = "あなたが持っていない物だけ買うことができます."
L.equip_carry      = "あなたはこの装備を持つことができます."
L.equip_carry_own  = "あなたは既にこのアイテムを持っています."
L.equip_carry_slot = "あなたは既にスロット{slot}の武器を持っています."

L.equip_help_stock = "いくつかのアイテムはラウンド毎に1つしか買えません."
L.equip_stock_deny = "このアイテムはもう在庫がありません."
L.equip_stock_ok   = "このアイテムは在庫があります."

L.equip_custom     = "このサーバーはカスタムアイテムを追加しました."

L.equip_spec_name  = "名前"
L.equip_spec_type  = "タイプ"
L.equip_spec_desc  = "説明"

L.equip_confirm    = "装備品購入"

-- Disguiser tab in equipment menu
L.disg_name      = "Disguiser(変装装置)"
L.disg_menutitle = "Disguiseコントロール"
L.disg_not_owned = "あなたはDisguiserを持っていません!"
L.disg_enable    = "変装する."

L.disg_help1     = "変装(Disguise)が有効な時, 誰かがあなたを見てもあなたの名前, ヘルスとカルマを表示しません. 加えて, あなたはDetectiveのレーダーからも隠されるでしょう."
L.disg_help2     = "テンキーのEnterを押すとメニューを使用せずに変装を切り替えます. 開発者コンソールで'ttt_toggle_disguise'を異なるキーに割り当てることもできます."

-- Radar tab in equipment menu
L.radar_name      = "Radar(レーダー)"
L.radar_menutitle = "Radarコントロール"
L.radar_not_owned = "あなたはRadarを持っていません!"
L.radar_scan      = "スキャンを実行."
L.radar_auto      = "自動で繰り返し実行."
L.radar_help      = "スキャン結果を{num}秒間表示し, その後Radarはリチャージして再び使えるようになります."
L.radar_charging  = "Radarはまだチャージしています!"

-- Transfer tab in equipment menu
L.xfer_name       = "譲渡"
L.xfer_menutitle  = "クレジット譲渡."
L.xfer_no_credits = "あなたはあげられるだけのクレジットを持っていません."
L.xfer_send       = "クレジットを送る."
L.xfer_help       = "あなたは仲間の{role}にクレジットを渡すことだけできます."

L.xfer_no_recip   = "受取人が妥当ではないのでクレジットの移動は中断しました."
L.xfer_no_credits = "渡すクレジットが不足しています."
L.xfer_success    = "クレジットの{player}への受け渡しを完了しました."
L.xfer_received   = "{player}はあなたに{num}クレジットを渡しました."

-- Radio tab in equipment menu
L.radio_name      = "Radio(ラジオ)"
L.radio_help      = "音を再生するためにボタンをクリックしましょう."
L.radio_notplaced = "再生するためにはRadioを置かなくてはなりません."

-- Radio soundboard buttons
L.radio_button_scream  = "悲鳴"
L.radio_button_expl    = "爆発音"
L.radio_button_pistol  = "Pistol発砲音"
L.radio_button_m16     = "M16発砲音"
L.radio_button_deagle  = "Deagle発砲音"
L.radio_button_mac10   = "MAC10発砲音"
L.radio_button_shotgun = "Shotgun発砲音"
L.radio_button_rifle   = "Rifle発砲音"
L.radio_button_huge    = "H.U.G.E発砲音"
L.radio_button_c4      = "C4警告音"
L.radio_button_burn    = "燃焼音"
L.radio_button_steps   = "足音"


-- Intro screen shown after joining
L.intro_help     = "このゲームは始めてですか? F1を押すとインストラクションを見れますよ!"

-- Radiocommands/quickchat
L.quick_title   = "クイックチャットキー"

L.quick_yes     = "わかった."
L.quick_no      = "ダメだ."
L.quick_help    = "助けてくれ!"
L.quick_imwith  = "{player}と一緒にいるぞ."
L.quick_see     = "{player}を見ているぞ."
L.quick_suspect = "{player}が怪しい動きをしているぞ."
L.quick_traitor = "{player}はTraitorだ!"
L.quick_inno    = "{player}はInnocentだな."
L.quick_check   = "まだ生きている奴はいるか?"

-- {player} in the quickchat text normally becomes a player nickname, but can
-- also be one of the below.  Keep these lowercase.
L.quick_nobody    = "いない奴"
L.quick_disg      = "変装中の誰か"
L.quick_corpse    = "誰かの死体"
L.quick_corpse_id = "{player}の死体"


--- Body search window
L.search_title  = "調査結果"
L.search_info   = "情報"
L.search_confirm = "死亡確認"
L.search_call   = "Detectiveを呼ぶ"

-- Descriptions of pieces of information found
L.search_nick   = "これは{player}の死体だ."

L.search_role_t = "こいつはTraitorだった!"
L.search_role_d = "こいつはDetectiveだった."
L.search_role_i = "こいつはInnocentだった."

L.search_words  = "こいつの最期の言葉:'{lastwords}'は俺に何を教えるのか."
L.search_armor  = "奴らは非標準のボディアーマーを着ている."
L.search_disg   = "奴らは正体を隠すことのできるデバイスを持っている."
L.search_radar  = "奴らはある種のレーダーを持っている. もう機能していないがな."
L.search_c4     = "ポケットからメモを見つけた. それには安全に爆弾を解除するには{num}番のワイヤーをカットしろと書かれている."

L.search_dmg_crush  = "こいつの骨の多くが折れている. 重たい物がぶつかった衝撃で死んだようだ."
L.search_dmg_bullet = "こいつが撃たれて死んだのは明白だ."
L.search_dmg_fall   = "こいつは落下して死んだか."
L.search_dmg_boom   = "こいつの傷と焼けた衣服は爆発によってこいつが死を迎えたことを示している."
L.search_dmg_club   = "死体には打撲傷と殴られた跡がある.  明らかにこいつは殴られて死んでいる."
L.search_dmg_drown  = "死体は溺れた証拠を示している."
L.search_dmg_stab   = "こいつは刺され,切られてすぐに出血死している."
L.search_dmg_burn   = "この辺りはテロリストが焼けたような臭いがするな..."
L.search_dmg_tele   = "こいつのDNAはタキオン粒子の放出によってかき混ぜられたように見える!"
L.search_dmg_car    = "このテロリストが道路を渡った際, 無謀なドライバーに轢かれたか."
L.search_dmg_other  = "このテロリストの死因を特定できない."

L.search_weapon = "{weapon}の扱いに慣れているようだな."
L.search_head   = "致命的な傷はヘッドショットによるものだ. 叫ぶ間も無い."
L.search_time   = "こいつは調査のおおよそ{time}秒前に死んだな."
L.search_dna    = "裏切り者のDNAサンプルをDNA scannerで回収しなくては. DNAサンプルは今からおおよそ{time}秒で腐敗するだろう."

L.search_kills1 = "{player}の死を立証する殺害リストを見つけた."
L.search_kills2 = "これらの名前の載った殺害リストを見つけた:"
L.search_eyes   = "Detectiveスキルを使用し, こいつの見た最後の人物を確認した: {player}. 裏切り者か, それとも偶然か?"


-- Scoreboard
L.sb_playing    = "You are playing on..."
L.sb_mapchange  = "マップ変更まで{num}ラウンドか{time}秒"

L.sb_mia        = "行方不明"
L.sb_confirmed  = "死亡確認"

L.sb_ping       = "Ping"
L.sb_deaths     = "死亡回数"
L.sb_score      = "スコア"
L.sb_karma      = "カルマ"

L.sb_info_help  = "このプレイヤーの死体を調査すると, ここで結果を精査することができます."

L.sb_tag_friend = "仲間"
L.sb_tag_susp   = "疑わしい"
L.sb_tag_avoid  = "避ける"
L.sb_tag_kill   = "殺す"
L.sb_tag_miss   = "行方不明"

--- Help and settings menu (F1)

L.help_title = "ヘルプと設定"

-- Tabs
L.help_tut     = "チュートリアル"
L.help_tut_tip = "6ステップでわかるTTTの遊び方"

L.help_settings = "設定"
L.help_settings_tip = "クライアント側の設定"

-- Settings
L.set_title_gui = "インターフェース設定"

L.set_tips      = "観戦中は画面下にゲームのTIPSを表示する"

L.set_startpopup = "ラウンド開始情報のポップアップ時間"
L.set_startpopup_tip = "ラウンド開始時に小さなポップアップを画面下に数秒間表示します. 表示時間を変更するにはここを変更してください."

L.set_cross_opacity = "アイアンサイトクロスヘアの不透明度"
L.set_cross_disable = "クロスヘアを完全に消す"
L.set_minimal_id    = "クロスヘア下のターゲットIDを最小限にする(カルマ, ヒント等を消す)"
L.set_healthlabel   = "ヘルスバー上にステータスラベルを表示する"
L.set_lowsights     = "アイアンサイト使用時に武器を下に下げる"
L.set_lowsights_tip = "有効にするとアイアンサイト使用中は武器のモデルの位置を画面の下の方にします. これはターゲットを見やすくしますが, 見た目のリアリティは下がるでしょう."
L.set_fastsw        = "高速武器スイッチ"
L.set_fastsw_tip    = "有効にするとホイールスクロールで順番に武器を切り替えます. 武器スイッチメニューを表示するには下の\"高速武器スイッチ時のメニュー表示を有効にする\"を有効にしてください."
L.set_fastsw_menu     = "高速武器スイッチ時のメニュー表示を有効にする"
L.set_fastswmenu_tip  = "高速武器スイッチ有効時でもスイッチメニューをポップアップ表示します."
L.set_wswitch       = "武器スイッチメニューが自動で閉じるのを無効にする"
L.set_wswitch_tip   = "デフォルトでは武器スイッチメニューはホイールスクロール後数秒で自動的に閉じます. 有効にするとメニューをそのままにします."
L.set_cues          = "ラウンド開始時ないし終了時にサウンドキューを再生する"


L.set_title_play    = "ゲームプレイ設定"

L.set_specmode      = "観戦オンリーモード (常に観戦者であり続ける)"
L.set_specmode_tip  = "観戦オンリーモードは新たにラウンドが始まる際にあなたがリスポーンするのを妨げます.代わりにあなたは観戦者のままになります."
L.set_mute          = "死亡時に生存者の発言をミュートする"
L.set_mute_tip      = "有効にすると死亡時もしくは観戦中は生存者の発言をミュートします."


L.set_title_lang    = "言語設定 (Language settings)"

-- It may be best to leave this next one english, so english players can always
-- find the language setting even if it's set to a language they don't know.
L.set_lang          = "Select language:"


--- Weapons and equipment, HUD and messages

-- Equipment actions, like buying and dropping
L.buy_no_stock    = "この武器は品切れです: このラウンドでは既に購入しています."
L.buy_pending     = "既にオーダーしています, 受け取りまでお待ちください."
L.buy_received    = "特殊装備を受け取りました."

L.drop_no_room    = "空きが無いので武器を捨ててください!"

L.disg_turned_on  = "変装しました!"
L.disg_turned_off = "変装をやめました."

-- Equipment item descriptions
L.item_passive    = "パッシブ効果アイテム"
L.item_active     = "使用アイテム"
L.item_weapon     = "武器"

L.item_armor      = "Body Armor(ボディアーマー)"
L.item_armor_desc = [[
銃によるダメージを30%減少させます.

Detectivesは標準で装備しています.]]


L.item_radar      = "Radar(レーダー)"
L.item_radar_desc = [[
生命反応のスキャンを可能にします.

購入するとすぐに自動でスキャンを開始します. 
設定はこのメニューのRadarタブでします.]]


L.item_disg       = "Disguiser(変装装置)"
L.item_disg_desc  = [[
使用中はあなたのID情報を隠します. 
さらに獲物が最期に目撃した人物になるのも避けます.

このメニューのDisguiseタブ内か
テンキーのEnterで切り替えます.]]

-- C4
L.c4_hint         = "{usekey}を押して起動もしくは解除する."
L.c4_no_disarm    = "他のTraitorのC4は彼らが死ぬまで解除できません."
L.c4_disarm_warn  = "あなたが設置したC4爆弾は解除されました."
L.c4_armed        = "あなたは首尾よく爆弾を起動しました."
L.c4_disarmed     = "あなたは爆弾を上手い事解除しました."
L.c4_no_room      = "あなたはこのC4を持てません."

L.c4_desc         = "強力な時限爆弾です."

L.c4_arm          = "C4を起動"
L.c4_arm_timer    = "タイマー"
L.c4_arm_seconds  = "爆発まで:"
L.c4_arm_attempts = "解除を試みる際, 6本のワイヤーの{num}本はカットすると即時爆発の原因となるでしょう."

L.c4_remove_title    = "撤去"
L.c4_remove_pickup   = "C4を取る"
L.c4_remove_destroy1 = "C4を破壊する"
L.c4_remove_destroy2 = "確認: 破壊"

L.c4_disarm       = "C4を解除"
L.c4_disarm_cut   = "クリックして{num}本目のワイヤーを切断する"

L.c4_disarm_t     = "ワイヤーをカットして爆弾を解除してください. あなたがTraitorなら全てのワイヤーは安全です. Innocentsなら簡単にはいきません!"
L.c4_disarm_owned = "ワイヤーをカットして爆弾を解除してください. あなたの爆弾なのでどのワイヤーでも解除となるでしょう."
L.c4_disarm_other = "安全なワイヤーをカットして爆弾を解除してください. 間違えたら爆発しますよ!"

L.c4_status_armed    = "起動中"
L.c4_status_disarmed = "解除済み"

-- Visualizer
L.vis_name        = "Visualizer(可視化装置)"
L.vis_hint        = "{usekey}を押して拾う(Detectiveのみ)."

L.vis_help_pri    = "{primaryfire}で起動したデバイスを落とす."

L.vis_desc        = [[
犯行シーンを可視化するデバイスです.

死体を分析して被害者がどのように殺害されたかを
表示しますが, 被害者が銃撃の傷で死んだ場合
のみです.]]

-- Decoy
L.decoy_name      = "Decoy(囮)"
L.decoy_no_room   = "あなたはこのDecoyを持つことができません."
L.decoy_broken    = "あなたのDecoyは破壊されました!"

L.decoy_help_pri  = "{primaryfire}でDecoyを設置する."

L.decoy_desc      = [[
Detectiveに偽のレーダーサインを表示し,
彼らがあなたのDNAをスキャンしていた場合は
彼らのDNA ScannerがDecoyの場所を
表示するようにします.]]

-- Defuser
L.defuser_name    = "Defuser(除去装置)"
L.defuser_help    = "{primaryfire}で狙ったC4を除去する."

L.defuser_desc    = [[
C4爆弾を即座に除去します.

使用は無制限です. これを持っていれば
C4に気がつくのは簡単になるでしょう.]]

-- Flare gun
L.flare_name      = "Flare gun(信号拳銃)"
L.flare_desc      = [[
発見されないように死体を燃やすことができるようになります.
弾は無限です.

燃えている死体は異音を発します.]]

-- Health station
L.hstation_name   = "Health Station(回復ステーション)"
L.hstation_hint   = "{usekey}を押してヘルスを受け取る. チャージ: {num}."
L.hstation_broken = "あなたのHealth Stationは破壊されました!"
L.hstation_help   = "{primaryfire}でHealth Stationを設置する."

L.hstation_desc   = [[
置いてあると回復が可能になります.

リチャージは遅いです. 誰でも使用することができ,
傷つけられることもあります. 使用者の
DNAサンプルをチェックすることができます.]]


-- Knife
L.knife_name      = "Knife(ナイフ)"
L.knife_thrown    = "Knife投擲"

L.knife_desc      = [[
負傷したターゲットを即座に静かに始末しますが,
一度しか使用できません.

オルトファイアで投げることができます.]]

-- Poltergeist
L.polter_desc     = [[
オブジェクトにThumperを設置すると彼らの
周囲に乱暴に押し動かします.

エナジーバーストはすぐ近くの人間にダメージを
与えます.]]

-- Radio
L.radio_broken    = "あなたのRadioは破壊されました!"
L.radio_help_pri  = "{primaryfire}でRadioを置く."

L.radio_desc      = [[
注意を逸らしたり欺くために音を再生します.

適当な場所にRadioを置いてから, 
このメニュー内のRadioタブで使用して
音を再生します.]]

-- Silenced pistol
L.sipistol_name   = "Silenced Pistol(消音ピストル)"

L.sipistol_desc   = [[
発砲音の小さいハンドガンで, ノーマルピストルの
弾丸を使用します.

撃たれた犠牲者は悲鳴をあげないでしょう.]]

-- Newton launcher
L.newton_name     = "Newton launcher(ニュートンランチャー)"

L.newton_desc     = [[
安全な距離から人を押します.

弾は無限ですが, 発射は遅いです.]]

-- Binoculars
L.binoc_name      = "Binoculars(双眼鏡)"
L.binoc_desc      = [[
遠く離れた距離から死体にズームインし彼らを
確認できます.

無制限で使用できますが, 確認には数秒かかります.]]


L.binoc_help_pri  = "{primaryfire}で死体を確認する."
L.binoc_help_sec  = "{secondaryfire}でズームレベルを変更する."

-- UMP
L.ump_desc        = [[
ターゲットを混乱させる実験的なSMGです.

標準的なSMGの弾丸を使用します.]]

-- DNA scanner
L.dna_name        = "DNA scanner(DNAスキャナー)"
L.dna_identify    = "殺害者のDNAを取るためには死体を確認しなければなりません."
L.dna_notfound    = "DNAサンプルは見つかりませんでした."
L.dna_limit       = "容器は限界に達しました. 古いサンプルを捨てて新しいのを加えてください."
L.dna_decayed     = "殺害者のDNAサンプルは腐っていました."
L.dna_killer      = "死体から殺害者のDNAサンプルを入手しました!"
L.dna_no_killer   = "DNAは回収されることができません (殺害者は切断した?)."
L.dna_armed       = "この爆弾は動いています! 早く解除してください!"
L.dna_object      = "オブジェクトから{num}個の新しいDNAサンプルを入手しました."
L.dna_gone        = "このエリアにDNA反応はありません."

L.dna_desc        = [[
物からDNAサンプルを入手しそれらを使用してDNAの
持ち主を探します.

新鮮な死体に使用し殺害者のDNAを入手して彼らを
追跡します.]]

L.dna_menu_title  = "DNAスキャニングコントロール"
L.dna_menu_sample = "DNAサンプルは{source}から見つけました."
L.dna_menu_remove = "選択対象を削除"
L.dna_menu_help1  = "これらはあなたが入手したDNAサンプルです."
L.dna_menu_help2  = [[
変更した際, あなたは選択したDNAサンプルの
持ち主の場所をスキャンできます.
距離のあるターゲットを発見するにはよりエネルギーを
消耗します.]]

L.dna_menu_scan   = "スキャン"
L.dna_menu_repeat = "自動で繰り返す"
L.dna_menu_ready  = "準備完了"
L.dna_menu_charge = "チャージ中"
L.dna_menu_select = "サンプルを選択"

L.dna_help_primary   = "{primaryfire}でDNAサンプルを入手する"
L.dna_help_secondary = "{secondaryfire}でスキャンコントロールを開く"

-- Magneto stick
L.magnet_name     = "Magneto-stick(マグネットスティック)"
L.magnet_help     = "{primaryfire}で死体を面に貼り付ける."

-- Grenades and misc
L.grenade_smoke   = "Smoke grenade(スモークグレネード)"
L.grenade_fire    = "Incendiary grenade(焼夷グレネード)"

L.unarmed_name    = "Holstered"
L.crowbar_name    = "Crowbar"
L.pistol_name     = "Pistol"
L.rifle_name      = "Rifle"
L.shotgun_name    = "Shotgun"

-- Teleporter
L.tele_name       = "Teleporter(テレポーター)"
L.tele_failed     = "テレポートに失敗しました."
L.tele_marked     = "テレポート位置をマークしました."

L.tele_no_ground  = "しっかりとした足場に立つまではテレポートはできません!"
L.tele_no_crouch  = "しゃがんでいるとテレポートできませんよ!"
L.tele_no_mark    = "マークした場所がありません. テレポートする前に移動先をマークしてください."

L.tele_no_mark_ground = "しっかりとした足場に立つまではテレポート位置をマークすることはできません!"
L.tele_no_mark_crouch = "しゃがんでいるとテレポート位置をマークすることができません!"

L.tele_help_pri   = "{primaryfire}でマークした場所にテレポートする."
L.tele_help_sec   = "{secondaryfire}で現在地をマークする."

L.tele_desc       = [[
あらかじめマークした地点にテレポートします.

テレポートはノイズを発し, 使用回数は無限です.]]


-- Ammo names, shown when picked up
L.ammo_pistol     = "9mm弾"

L.ammo_smg1       = "SMG弾"
L.ammo_buckshot   = "Shotgun弾"
L.ammo_357        = "Rifle弾"
L.ammo_alyxgun    = "Deagle弾"
L.ammo_ar2altfire = "Flare弾"
L.ammo_gravity    = "Poltergeist弾"


--- HUD interface text

-- Round status
L.round_wait   = "待機中"
L.round_prep   = "準備中"
L.round_active = "進行中"
L.round_post   = "ラウンド終了"

-- Health, ammo and time area
L.overtime     = "OVERTIME"
L.hastemode    = "HASTE MODE"

-- TargetID health status
L.hp_healthy   = "健康"
L.hp_hurt      = "苦痛"
L.hp_wounded   = "怪我"
L.hp_badwnd    = "重症"
L.hp_death     = "瀕死"


-- TargetID karma status
L.karma_max    = "標準的"
L.karma_high   = "粗野"
L.karma_med    = "トリガーハッピー"
L.karma_low    = "危険"
L.karma_min    = "どうしようもない"

-- TargetID misc
L.corpse       = "死体"
L.corpse_hint  = "{usekey}を押して調査する. {walkkey} + {usekey}で密かに調査する."

L.target_disg  = " (変装中)"
L.target_unid  = "誰かの死体"

L.target_traitor = "仲間のTRAITOR"
L.target_detective = "DETECTIVE"

L.target_credits = "調べて未使用クレジットを入手する"

-- Traitor buttons (HUD buttons with hand icons that only traitors can see)
L.tbut_single  = "使いきり"
L.tbut_reuse   = "再使用可能"
L.tbut_retime  = "{num}秒後に再使用可能"
L.tbut_help    = "{key}を押して起動"

-- Equipment info lines (on the left above the health/ammo panel)
L.disg_hud     = "変装中. あなたの名前は隠されます."
L.radar_hud    = "Radarの次のスキャンの準備ができるまで: {time}秒"

-- Spectator muting of living/dead
L.mute_living  = "生存者をミュートしました"
L.mute_specs   = "観戦者をミュートしました"
L.mute_all     = "全てをミュートしました"
L.mute_off     = "ミュートを解除しました"

-- Spectators and prop possession
L.punch_title  = "PUNCH-O-METER(パンチ・オー・メーター)"
L.punch_help   = "移動キーもしくはジャンプ: オブジェクトを押す. じゃがみ: オブジェクトを離れる."
L.punch_bonus  = "あなたの悪いスコアはpunch-o-meterのリミットを{num}下げました."
L.punch_malus  = "あなたの良いスコアはpunch-o-meterのリミットを{num}上げました!"

L.spec_help    = "クリックしてプレイヤーを観戦するか, {usekey}を押して物理オブジェクトに乗り移ります."

--- Info popups shown when the round starts

-- These are spread over multiple lines, hence the square brackets instead of
-- quotes. That's a Lua thing. Every line break (enter) will show up in-game.
L.info_popup_innocent = [[あなたはInnocent(無実)のテロリストです! でも周囲にTraitor(裏切り者)が...
あなたは誰を信用し, 誰があなたを蜂の巣にするのでしょうか?

背中に注意し信頼関係を築き生き延びましょう!]]

L.info_popup_detective = [[あなたはDetective(探偵)です! テロリストの本部はTraitor(裏切り者)を見つけるためにあなたに特別な力を与えました.
それらを使用しInnocent(無実)の生存を助けてください, でも気をつけて:
Traitorは真っ先にあなたを始末しようと注意を向けていますよ!

{menukey}を押して装備を受け取ってください!]]

L.info_popup_traitor_alone = [[あなたはTrator(裏切り者)です! あなたにはこのラウンドでは裏切り者の仲間はいません.

全員始末すればあなたの勝利です!

{menukey}を押して特別な装備を受け取ってください!]]

L.info_popup_traitor = [[あなたはTrator(裏切り者)です! 他者を全て始末するために仲間と共に仕事をしてください.
でも気をつけて, あなたの裏切りはバレるかもしれませんよ...

あなたの仲間達:
{traitorlist}

{menukey}を押して特別な装備を受け取ってください!]]

--- Various other text
L.name_kick = "プレイヤーはラウンド中に名前を変更したため自動的にKickされました."

L.idle_popup = [[あなたは{num}秒間アイドル状態だったので結果として観戦オンリーモードに移動させられました. このモードでいる間, あなたは新しいラウンドが始まった時に参加しません.

{helpkey}を押して設定タブでボックスのチェックを外すことでいつでも観戦オンリーモードを切り替えることができます. 今すぐに無効を選ぶこともできます.]]

L.idle_popup_close = "何もしない"
L.idle_popup_off   = "観戦オンリーモードを無効化"

L.idle_warning = "注意: あなたが無操作状態かAFKに見えると, あなたが動きを示すまで観戦にされます!"

L.spec_mode_warning = "あなたは観戦モードなのでラウンド開始時に参加しません. このモードを無効にするにはF1を押して設定タブで'観戦オンリーモード'のチェックを外してください."


--- Tips, shown at bottom of screen to spectators

-- Tips panel
L.tips_panel_title = "Tips"
L.tips_panel_tip   = "Tip:"

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

L.tip21 =  "DetectiveのHealth Stationは負傷したプレイヤーを回復させます. もちろん, それらの負傷した人はTraitorかもしれないですけどね..."

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

L.tip40 = "ラウンドタイマーの上に'HASTE MODE'と書かれている場合, ラウンドは数分だけ早くなりますが, あらゆる死によって追加の時間を得られます(TF2のCPのように). このモードはTraitorに動き続けるようプレッシャーをかけます."


--- Round report

L.report_title = "ラウンドレポート"

-- Tabs
L.report_tab_hilite = "ハイライト"
L.report_tab_hilite_tip = "ラウンドハイライト"
L.report_tab_events = "イベント"
L.report_tab_events_tip = "このラウンドでの出来事のログ"
L.report_tab_scores = "スコア"
L.report_tab_scores_tip = "このラウンドのみの各プレイヤーのポイント"

-- Event log saving
L.report_save     = "Save Log .txt"
L.report_save_tip = "Saves the Event Log to a text file"
L.report_save_error  = "No Event Log data to save."
L.report_save_result = "The Event Log has been saved to:"

-- Big title window
L.hilite_win_traitors = "THE TRAITORS WIN"
L.hilite_win_innocent = "THE INNOCENT WIN"

L.hilite_players1 = "{numplayers}人のプレイヤーが参加して, {numtraitors}人がTraitorでした"
L.hilite_players2 = "{numplayers}人のプレイヤーが参加して, 彼らの1人がTraitorでした"

L.hilite_duration = "ラウンドは{time}秒で終わりました"

-- Columns
L.col_time   = "時間"
L.col_event  = "イベント"
L.col_player = "プレイヤー"
L.col_role   = "役割"
L.col_kills1 = "Innocent殺害数"
L.col_kills2 = "Traitor殺害数"
L.col_points = "ポイント"
L.col_team   = "チームボーナス"
L.col_total  = "合計ポイント"

-- Name of a trap that killed us that has not been named by the mapper
L.something      = "何か"

-- Kill events
L.ev_blowup      = "{victim}は吹き飛びました"
L.ev_blowup_trap = "{victim}は{trap}によって吹き飛ばされました"

L.ev_tele_self   = "{victim}は手投げ弾で自爆しました"
L.ev_sui         = "{victim}は受け入れられず自殺しました"
L.ev_sui_using   = "{victim}は{tool}を使用して自殺しました"

L.ev_fall        = "{victim}は落下して死亡しました"
L.ev_fall_pushed = "{victim}は{attacker}が押したことにより落下して死亡しました"
L.ev_fall_pushed_using = "{victim}は{attacker}が{trap}で押したことにより落下して死亡しました"

L.ev_shot        = "{victim}は{attacker}に撃たれました"
L.ev_shot_using  = "{victim}は{attacker}に{weapon}で撃たれました"

L.ev_drown       = "{victim}は{attacker}によって溺死させられました"
L.ev_drown_using = "{victim}は{attacker}が{trap}を起動したことにより溺死させられました"

L.ev_boom        = "{victim}は{attacker}によって爆破されました"
L.ev_boom_using  = "{victim}は{attacker}の使用した{trap}によって吹き飛ばされました"

L.ev_burn        = "{victim}は{attacker}によって焼かれました"
L.ev_burn_using  = "{victim}は{attacker}の仕組んだ{trap}により燃やされました"

L.ev_club        = "{victim}は{attacker}によって殴られました"
L.ev_club_using  = "{victim}は{attacker}の{trap}でしたたかに殴られ死亡しました"

L.ev_slash       = "{victim}は{attacker}に刺されました"
L.ev_slash_using = "{victim}は{attacker}に{trap}で切り刻まれました"

L.ev_tele        = "{victim}は{attacker}により手投げ弾で爆殺されました"
L.ev_tele_using  = "{victim}は{attacker}が仕掛けた{trap}により粉々にされました"

L.ev_goomba      = "{victim}は巨大な{attacker}により踏み潰されました"

L.ev_crush       = "{victim}は{attacker}により押し潰されました"
L.ev_crush_using = "{victim}は{attacker}の{trap}により押し潰されました"

L.ev_other       = "{victim}は{attacker}により殺されました"
L.ev_other_using = "{victim}は{attacker}の使用した{trap}により殺されました"

-- Other events
L.ev_body        = "{finder}は{victim}の死体を見つけました"
L.ev_c4_plant    = "{player}はC4を設置しました"
L.ev_c4_boom     = "{player}の設置したC4は爆発しました"
L.ev_c4_disarm1  = "{player}は{owner}の設置したC4を解除しました"
L.ev_c4_disarm2  = "{player}は{owner}の設置したC4の解除に失敗しました"
L.ev_credit      = "{finder}は{player}の死体から{num}クレジットを見つけました"

L.ev_start       = "ラウンドを開始しました"
L.ev_win_traitor = "卑劣なTraitor達はラウンドに勝利しました!"
L.ev_win_inno    = "愛すべきInnocentのテロリスト達はラウンドに勝利しました!"
L.ev_win_time    = "Traitor達は時間切れで敗北しました!"

--- Awards/highlights

L.aw_sui1_title = "自殺カルトのリーダー"
L.aw_sui1_text  = "は最初の一歩を踏み出す者になることでどうすれば良いのかを他の自殺者達に示しました."

L.aw_sui2_title = "孤独と憂鬱"
L.aw_sui2_text  = "は唯一の自殺者でした."

L.aw_exp1_title = "爆発物研究証"
L.aw_exp1_text  = "は爆発物の研究が認められました. {num}人の被験者を助け出しましたからね."

L.aw_exp2_title = "フィールドリサーチ"
L.aw_exp2_text  = "は爆発への耐久力をテストしました. 耐久力は高くなかったようです."

L.aw_fst1_title = "First Blood"
L.aw_fst1_text  = "はTraitor達の手に最初のInnocentの死を届けました."

L.aw_fst2_title = "1人目は人違い"
L.aw_fst2_text  = "は仲間のTraitorを撃ったことでファーストキルを取りました. Good job."

L.aw_fst3_title = "初めの過ち"
L.aw_fst3_text  = "は殺害1番乗りでした. 残念ながら始末したのはInnocentの仲間でしたが."

L.aw_fst4_title = "最初の衝撃"
L.aw_fst4_text  = "が最初に始末したのがTraitorだったことでInnocentのテロリスト達に衝撃が走りました."

L.aw_all1_title = "真に危険な者"
L.aw_all1_text  = "はこのラウンドでInnocentによる全ての死を招きました."

L.aw_all2_title = "一匹狼"
L.aw_all2_text  = "はこのラウンドでTraitorによる全ての死を招きました."

L.aw_nkt1_title = "1人殺りましたよ, ボス!"
L.aw_nkt1_text  = "は首尾よく1人のInnocentを始末しました. 嬉しいですね!"

L.aw_nkt2_title = "凶弾は2人へ"
L.aw_nkt2_text  = "は他も始末することで最初の1人はラッキーショットではなかったことを示しました."

L.aw_nkt3_title = "シリアルトレイター"
L.aw_nkt3_text  = "は今日3人のInnocentのテロリズム人生を終わらせました."

L.aw_nkt4_title = "羊のような狼達の中の狼"
L.aw_nkt4_text  = "はディナーにInnocentのテロリスト達を食しました. ディナーは{num}コースでした."

L.aw_nkt5_title = "対テロ諜報員"
L.aw_nkt5_text  = "は始末する度に報酬を得ました. 今や豪華なヨットを買うことができます."

L.aw_nki1_title = "この裏切り者が"
L.aw_nki1_text  = "はTraitorを見つけました. Traitorを撃ちました. 簡単でしたね."

L.aw_nki2_title = "ジャスティススクワッドへの志願"
L.aw_nki2_text  = "は2名のTraitorを来世へとエスコートしました."

L.aw_nki3_title = "Traitorは裏切り羊の夢を見るか?"
L.aw_nki3_text  = "は3人のTraitorを寝かしつけました."

L.aw_nki4_title = "内務従業員"
L.aw_nki4_text  = "は始末する度に報酬を得ました.　今や5個目のスイミングプールを買うことができます."

L.aw_fal1_title = "いや, ボンドさん, 落ちてもらうだけだ."
L.aw_fal1_text  = "は高所から誰かを突き落としました."

L.aw_fal2_title = "おやすみなさい"
L.aw_fal2_text  = "は彼らの体をかなりの高度から落として床にヒットさせました."

L.aw_fal3_title = "人間隕石"
L.aw_fal3_text  = "は誰かを高所から落とすことによって潰しました."

L.aw_hed1_title = "効率的"
L.aw_hed1_text  = "はヘッドショットの楽しさを見出して{num}人始末しました."

L.aw_hed2_title = "神経学"
L.aw_hed2_text  = "はよく調べるため{num}人の頭から脳を取り除きました."

L.aw_hed3_title = "ビデオゲームの影響"
L.aw_hed3_text  = "は殺人鬼シミュレーショントレーニングに傾倒して{num}人の敵をヘッドショットしました."

L.aw_cbr1_title = "ドカッ バキッ ボカッ"
L.aw_cbr1_text  = "は{num}人の犠牲者に見つかった際にCrowbarを振ってみせました."

L.aw_cbr2_title = "Freeman"
L.aw_cbr2_text  = "は{num}人もの脳漿をCrowberに浴びせました."

L.aw_pst1_title = "根気強いちっちゃなやつ"
L.aw_pst1_text  = "はピストルで{num}キルを取りました. そして続いて死に至らしめるために抱きしめました."

L.aw_pst2_title = "小口径での殺戮"
L.aw_pst2_text  = "はピストルで{num}人の小規模な軍隊を始末しました. おそらくバレルの中に小さなショットガンを入れていたのでしょう."

L.aw_sgn1_title = "Easy Mode"
L.aw_sgn1_text  = "は負傷者にバックショット弾を命中させて, {num}人のターゲットを殺害しました."

L.aw_sgn2_title = "千の小弾"
L.aw_sgn2_text  = "はバックショット弾が大嫌いなので, 全部ばら撒きました. 受け取った{num}人は人生を楽しめませんでしたが."

L.aw_rfl1_title = "ポイントアンドクリック"
L.aw_rfl1_text  = "は{num}人を始末するにはライフルと安定した手が必要な全てだと示しました."

L.aw_rfl2_title = "頭, 見えてますよ"
L.aw_rfl2_text  = "はライフルを理解しています. 今, 他の{num}人もライフルを理解しました."

L.aw_dgl1_title = "小さなライフルみたいだね"
L.aw_dgl1_text  = "はデザートイーグルのコツを掴んで{num}人を始末しました."

L.aw_dgl2_title = "イーグルマスター"
L.aw_dgl2_text  = "はデザートイーグルで{num}人を消しました."

L.aw_mac1_title = "敬虔と殺人"
L.aw_mac1_text  = "はMAC10で{num}人を始末しましたが, どのくらいの弾を必要としたかは言わないでしょう."

L.aw_mac2_title = "マカロニ・アンド・チーズ"
L.aw_mac2_text  = "は2挺のMAC10を上手く扱うことができたらどうなるのか驚きました.　{num}回もを2挺で?"

L.aw_sip1_title = "お静かに"
L.aw_sip1_text  = "は消音ピストルで{num}人を黙らせました."

L.aw_sip2_title = "静寂のアサシン"
L.aw_sip2_text  = "は{num}人を自身の死を聞き取らせずに始末しました."

L.aw_knf1_title = "ナイフは知っている"
L.aw_knf1_text  = "はインターネット越しに面前の誰かを刺しました."

L.aw_knf2_title = "どこから手に入れたんだい?"
L.aw_knf2_text  = "はTraitorではありませんでしたが, それでも誰かをナイフで殺害しました."

L.aw_knf3_title = "とんでもないナイフ使い"
L.aw_knf3_text  = "は周囲に転がっている{num}本のナイフを見つけ, 活用しました."

L.aw_knf4_title = "世界一のナイフ使い"
L.aw_knf4_text  = "はナイフで{num}人を始末しました. どうやったのかは聞かないでください."

L.aw_flg1_title = "助けに行くよ"
L.aw_flg1_text  = "は{num}人の死の合図にフレアを使用しました."

L.aw_flg2_title = "フレアは炎へ"
L.aw_flg2_text  = "は{num}人の男に可燃性の衣服を着ることの危険性を教えました."

L.aw_hug1_title = "大きな拡散"
L.aw_hug1_text  = "はH.U.G.Eと1つになり, とにかくうまいこと{num}人に弾丸をヒットさせました."

L.aw_hug2_title = "忍耐強いパラ"
L.aw_hug2_text  = "はただただ撃ち続け, そしてH.U.G.Eの忍耐は{num}人の始末で報いるのを見ました."

L.aw_msx1_title = "バタバタバタ"
L.aw_msx1_text  = "はM16で{num}人排除しました."

L.aw_msx2_title = "ミドルレンジマッドネス"
L.aw_msx2_text  = "が{num}人キル取っているということはM16でのターゲットの仕留め方を知っていますね."

L.aw_tkl1_title = "驚かせよう"
L.aw_tkl1_text  = "はちょうど相棒の方を向いている時に指を滑らせてしまいました."

L.aw_tkl2_title = "2重の驚き"
L.aw_tkl2_text  = "は2回Traitorを始末したと思っていましたが, 2回ともハズレでした."

L.aw_tkl3_title = "カルマ重視"
L.aw_tkl3_text  = "はチームメイトを2人始末した後も止められませんでした. 3はラッキーナンバーですから."

L.aw_tkl4_title = "チームキラー"
L.aw_tkl4_text  = "はチーム全員を始末しました. BANしましょうよ!"

L.aw_tkl5_title = "ロールプレイヤー"
L.aw_tkl5_text  = "は狂人のロールプレイをしていました, 本当にね. それはなぜならチームの多くを始末したからです."

L.aw_tkl6_title = "ばか"
L.aw_tkl6_text  = "は彼らがどちら側かを理解できず, 半数を超える仲間を始末しました."

L.aw_tkl7_title = "レッドネック"
L.aw_tkl7_text  = "はチームメイトの4分の1以上を始末したことで十分な縄張りを守りました."

L.aw_brn1_title = "おばあちゃんのお料理レシピ"
L.aw_brn1_text  = "は何人かを良い感じのクリスプに揚げました."

L.aw_brn2_title = "パイロイド"
L.aw_brn2_text  = "は燃えている多くの犠牲者の後ろで高笑いしているのを聞かれました."

L.aw_brn3_title = "ピュロスの焼却"
L.aw_brn3_text  = "はIncendiary grenadeを使い切りましたが全員を燃やしてやりました! どうやって対処するのでしょう!?"

L.aw_fnd1_title = "検死官"
L.aw_fnd1_text  = "は{num}人の転がっている死体を発見しました."

L.aw_fnd2_title = "めざせテロリストマスター"
L.aw_fnd2_text  = "はコレクションのために{num}人の死体を発見しました."

L.aw_fnd3_title = "死の芳香"
L.aw_fnd3_text  = "はこのラウンドで奇遇にも{num}回死体を発見しました."

L.aw_crd1_title = "リサイクル屋"
L.aw_crd1_text  = "は死体から{num}未使用クレジットをあさりました."

L.aw_tod1_title = "ピュロスの勝利"
L.aw_tod1_text  = "はチームがラウンドを勝利するたった数秒前に死亡しました."

L.aw_tod2_title = "クソゲー"
L.aw_tod2_text  = "はラウンド開始してすぐに死亡しました."


--- New and modified pieces of text are placed below this point, marked with the
--- version in which they were added, to make updating translations easier.


--- v23
L.set_avoid_det     = "Detectiveに選択されることを避ける"
L.set_avoid_det_tip = "有効にすると可能であればサーバーはあなたを探偵に選択しなくなります. あなたがTraitorなら大抵は意味がありません."

--- v24
L.drop_no_ammo = "弾薬箱として捨てるのに十分な武器のクリップ内の弾がありません."

--- v31
L.set_cross_brightness = "クロスヘアの明るさ"
L.set_cross_size = "クロスヘアの大きさ"

--- 5-25-15
L.hat_retrieve = "あなたはDetectiveの帽子を拾いました."

-- 2018-07-24
L.equip_tooltip_main = "装備品一覧"
L.equip_tooltip_radar = "Radarコントロール"
L.equip_tooltip_disguise = "Disguiseコントロール"
L.equip_tooltip_radio = "Radioコントロール"
L.equip_tooltip_xfer = "クレジット譲渡"
L.equip_tooltip_reroll = "アイテムのリロール"

L.confgrenade_name = "Discombobulator"
L.polter_name = "Poltergeist"
L.stungun_name = "UMP Prototype"

L.knife_instant = "インスタントキル"

L.dna_hud_type = "タイプ"
L.dna_hud_body = "ボディ"
L.dna_hud_item = "アイテム"

L.binoc_zoom_level = "ズームレベル"
L.binoc_body = "死体が検出されました"
L.binoc_progress = "検索の進行状況: {progress}%"

L.idle_popup_title = "Idle"

-- 6-22-17 (Crosshair)
L.set_title_cross = "クロスヘア設定"

L.set_cross_color_enable = "カスタムクロスヘアカラーを有効"
L.set_cross_color = "クロスヘアカラーをカスタムする:"
L.set_cross_gap_enable = "カスタムクロスヘアギャップを有効"
L.set_cross_gap = "カスタムクロスヘアギャップ"
L.set_cross_static_enable = "固定されたクロスヘアを有効"
L.set_ironsight_cross_opacity = "アイアンサイトのクロスヘアの不透明度"
L.set_cross_weaponscale_enable = "異なる武器によってクロスヘアの大きさが異なることを有効"
L.set_cross_thickness = "クロスヘアの厚さ"
L.set_cross_outlinethickness = "クロスヘアの外枠の厚さ"
L.set_cross_dot_enable = "クロスヘアドットを有効"

-- ttt2
L.create_own_shop = "オリジナルのショップを作成"
L.shop_link = "リンク先"
L.shop_disabled = "ショップ使用不可"
L.shop_default = "デフォルトのショップを使用"

L.shop_editor_title = "ショップエディタ"
L.shop_edit_items_weapong = "アイテムエディタ / ウェポンエディタ"
L.shop_edit = "ショップ編集"
L.shop_settings = "設定"
L.shop_select_role = "役職選択"
L.shop_edit_items = "アイテム編集"
L.shop_edit_shop = "ショップ編集"
L.shop_create_shop = "カスタムショップ作成"
L.shop_selected = "{role}を選択"
L.shop_settings_desc = "値を変更してランダムショップのConvarsを調整します. 変更を保存することを忘れないでください!"

L.f1_settings_changes_title = "更新履歴"
L.f1_settings_hudswitcher_title = "HUD切り替え"
L.f1_settings_bindings_title = "キー設定"
L.f1_settings_interface_title = "インターフェイス"
L.f1_settings_gameplay_title = "ゲーム設定"
L.f1_settings_crosshair_title = "クロスヘア"
L.f1_settings_dmgindicator_title = "ダメージインジケーター"
L.f1_settings_language_title = "言語"
L.f1_settings_administration_title = "管理"
L.f1_settings_shop_title = "ショップ設定"

L.f1_settings_shop_desc_shopopen = "ラウンド終了時、または準備中にスコアメニューの代わりにショップキーを押してショップの内容を閲覧しますか?"
L.f1_settings_shop_title_layout = "アイテム一覧レイアウト"
L.f1_settings_shop_desc_num_columns = "列数"
L.f1_settings_shop_desc_num_rows = "行数"
L.f1_settings_shop_desc_item_size = "アイコンサイズ"
L.f1_settings_shop_title_marker = "アイテムマーカー設定"
L.f1_settings_shop_desc_show_slot = "スロットマーカー閲覧"
L.f1_settings_shop_desc_show_custom = "カスタムアイテムマーカー閲覧"
L.f1_settings_shop_desc_show_favourite = "お気に入りのアイテムマーカー一覧"

L.f1_shop_restricted = "このサーバーでは、備品店レイアウトに対する個別の変更は許可されていません。詳細については、サーバー管理者にお問い合わせください."

L.f1_settings_hudswitcher_desc_basecolor = "基本色"
L.f1_settings_hudswitcher_desc_hud_scale = "HUDの大きさ(リセット セーブ 変更)"
L.f1_settings_hudswitcher_button_close = "閉じる"
L.f1_settings_hudswitcher_desc_reset = "HUDデータをリセットする"
L.f1_settings_hudswitcher_button_reset = "リセット"
L.f1_settings_hudswitcher_desc_layout_editor = "位置と大きさを変更する"
L.f1_settings_hudswitcher_button_layout_editor = "レイアウトエディタ"
L.f1_settings_hudswitcher_desc_hud_not_supported = "! このHUDはHUDエディタに対応していません !"

L.f1_bind_reset_default = "デフォルト"
L.f1_bind_disable_bind = "クリア"
L.f1_bind_description = "クリックして設定したいキーを入力."
L.f1_bind_reset_default_description = "デフォルトのキーに戻す."
L.f1_bind_disable_description = "この設定されていたキーをクリアしました."
L.ttt2_bindings_new = " {name} が新しくキー設定されました: {key} "

L.f1_bind_weaponswitch = "武器を切り替える"
L.f1_bind_sprint = "走る"
L.f1_bind_voice = "通常ボイスチャット"
L.f1_bind_voice_team = "チームボイスチャット"

L.f1_dmgindicator_title = "ダメージインジケーター設定"
L.f1_dmgindicator_enable = "有効"
L.f1_dmgindicator_mode = "ダメージインジケーターテーマを選択"
L.f1_dmgindicator_duration = "ヒット後に表示される秒数ダメージインジケーター"
L.f1_dmgindicator_maxdamage = "必要なダメージの最大不透明度"
L.f1_dmgindicator_maxalpha = "ダメージインジケーターの最大不透明度"

L.ttt2_bindings_new = " {name} を新しくキー設定しました: {key}"
L.hud_default = "デフォルトHUD"
L.hud_force = "オリジナルHUD"
L.hud_restricted = "リストリクテッドHUD"
L.hud_default_failed = " {hudname} を新しいデフォルトとして設定できませんでした.これを行う権限がないか、このHUDが存在しません."
L.hud_forced_failed = " {hudname} を固定できませんでした.これを行う権限がないか、この HUD が存在しません."
L.hud_restricted_failed = " {hudname} を制限できませんでした.あなたはそれを行う許可を持っていません."

L.shop_role_select = "役職を選択"
L.shop_role_selected = "{roles}のショップが選ばれました!"
L.shop_search = "検索"

L.button_save = "保存"

L.disable_spectatorsoutline = "オブジェクトの操作するときのアウトラインを無効"
L.disable_spectatorsoutline_tip = "観戦がオブジェクトの操作するときの周囲のアウトラインを無効 (+パフォーマンス)"

L.disable_overheadicons = "役職のアイコンを無効にする"
L.disable_overheadicons_tip = "プレイヤーの頭上の役職のアイコンを無効にする (+パフォーマンス)"

-- 2020-01-04
L.doubletap_sprint_anykey = "あなたが止まるまでダブルタップ走行が続く"
L.doubletap_sprint_anykey_tip = "あなたが動き続ける限り走行は続く"

L.disable_doubletap_sprint = "ダブルタップ走行を無効にする"
L.disable_doubletap_sprint_tip = "移動キーをダブルタップしても走行しないようになりました"

-- 2020-02-03
L.hold_aim = "Aimを合わせる"
L.hold_aim_tip = "セカンダリーアクションを続ける限りアイアンサイトを使い続ける (default: 右クリック)"

-- 2020-02-09
L.name_door = "Door"
L.door_open = " [{usekey}] でドアを開ける."
L.door_close = " [{usekey}] でドアを閉める."
L.door_locked = "このドアはかぎが掛かっています"

-- 2020-02-11
L.automoved_to_spec = "(AUTOMATED MESSAGE) しばらくAFK状態だったため、観戦状態になりました."

-- 2020-02-16
L.door_auto_closes = "このドアは自動で閉まります."
L.door_open_touch = "歩くだけでドアが開きます."
L.door_open_touch_and_use = "歩く、または [{usekey}] でドアが開きます."
L.hud_health = "体力"

-- 2020-04-20
L.item_speedrun = "Speedrun"
L.item_speedrun_desc = [[足が50%速くなります!]]
L.item_no_explosion_damage = "No Explosion Damage"
L.item_no_explosion_damage_desc = [[爆破ダメージを無効にする.]]
L.item_no_fall_damage = "No Fall Damage"
L.item_no_fall_damage_desc = [[落下ダメージを無効にする.]]
L.item_no_fire_damage = "No Fire Damage"
L.item_no_fire_damage_desc = [[炎によるダメージを無効にする]]
L.item_no_hazard_damage = "No Hazard Damage"
L.item_no_hazard_damage_desc = [[毒や放射能によるダメージを無効にする.]]
L.item_no_energy_damage = "No Energy Damage"
L.item_no_energy_damage_desc = [[電気やビームによるダメージを無効にする.]]
L.item_no_prop_damage = "No Prop Damage"
L.item_no_prop_damage_desc = [[物によるダメージを無効にする]]
L.item_no_drown_damage = "No Drowning Damage"
L.item_no_drown_damage_desc = [[溺れるダメージを無効にする.]]

-- 2020-04-30
L.message_revival_canceled = "蘇生が中断されました."
L.message_revival_failed = "蘇生に失敗しました."
L.message_revival_failed_missing_body = "長い時間死体にとどまらなかったので、蘇生できませんでした."
L.hud_revival_title = "蘇生完了まで:"
L.hud_revival_time = "{time} 秒"

-- 2020-05-03
L.door_destructible = "ドアが破損しています ({health}HP)"

-- 2020-05-28
L.confirm_detective_only = "探偵しか死体を確認できません."
L.inspect_detective_only = "探偵しか死体を検査できません."
L.corpse_hint_no_inspect = "探偵しかこの死体を探せません."
L.corpse_hint_inspect_only = "[{usekey}] で探す. 探偵しか死体を確認できません."
L.corpse_hint_inspect_only_credits = "[{usekey}] でクレジットを受け取る. 探偵しか個の死体を探せません."

-- 2020-06-04
L.label_bind_disguiser = "変装する"

-- 2020-06-24
L.dna_help_primary = "DNAサンプルを集める"
L.dna_help_secondary = "DNAスロットを切り替え"
L.dna_help_reload = "サンプル消去"

L.binoc_help_pri = "死体を確認する."
L.binoc_help_sec = "ズームレベルを変更."

L.vis_help_pri = "Visualizerを落とす."

L.decoy_help_pri = "Decoyを設置する."

L.set_cross_lines_enable = "クロスヘアラインを有効"

-- 2020-08-11
L.f1_settings_shop_desc_double_click = "ダブルクリックでショップのアイテムを購入できることを有効にする."
