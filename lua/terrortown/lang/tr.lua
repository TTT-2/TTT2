-- Turkish language strings

local L = LANG.CreateLanguage("tr")

-- Compatibility language name that might be removed soon.
-- the alias name is based on the original TTT language name:
-- https://github.com/Facepunch/garrysmod/blob/master/garrysmod/gamemodes/terrortown/gamemode/lang/turkish.lua
L.__alias = "türkçe"

L.lang_name = "Türkçe (Turkish)"

-- General text used in various places
L.traitor = "Hain"
L.detective = "Dedektif"
L.innocent = "Masum"
L.last_words = "Son Sözleri"

L.terrorists = "Teröristler"
L.spectators = "İzleyiciler"

L.nones = "Takım Yok"
L.innocents = "Masum Takımı"
L.traitors = "Hain Takımı"

-- Round status messages
L.round_minplayers = "Yeni raunda başlamak için yeterli sayıda oyuncu yok..."
L.round_voting = "Oylama devam ediyor, yeni raunt {num} saniye geciktirilecek..."
L.round_begintime = "Yeni raunt {num} saniyede başlayacak. Kendini hazırla."

L.round_traitors_one = "Hey hain, yalnızsın."
L.round_traitors_more = "Hey hain, bunlar senin müttefiklerin {names}"

L.win_time = "Süre doldu. Hainler kaybetti."
L.win_traitors = "Hainler kazandı!"
L.win_innocents = "Masumlar kazandı!"
L.win_nones = "Kimse kazanamadı!"
L.win_showreport = "{num} saniye boyunca raunt raporuna bakalım."

L.limit_round = "Raunt sınırına ulaşıldı. Bir sonraki harita yakında yüklenecek."
L.limit_time = "Zaman sınırına ulaşıldı. Bir sonraki harita yakında yüklenecek."
L.limit_left_session_mode_1 = "Harita değişmeden önce {num} raunt veya {time} dakika kaldı."
L.limit_left_session_mode_2 = "Harita değişmeden önce {time} dakika kaldı."
L.limit_left_session_mode_3 = "Harita değişmeden önce {num} raunt kaldı."

-- Credit awards
L.credit_all = "Takımınıza performansınız için {num} ekipman kredisi verildi."
L.credit_kill = "Bir {role} öldürdüğünüz için {num} kredi aldınız."

-- Karma
L.karma_dmg_full = "Karman {amount}, bu yüzden bu raunt tam hasar veriyorsun!"
L.karma_dmg_other = "Karman {amount}. Bu nedenle, verdiğiniz tüm hasar ​%{num}​ azaltıldı."

-- Body identification messages
L.body_found = "{finder}, {victim} adlı kişinin cesedini buldu. {role}"
L.body_found_team = "{finder}, {victim} adlı kişinin cesedini buldu. {role} ({team})"

-- The {role} in body_found will be replaced by one of the following:
L.body_found_traitor = "Onlar bir Haindi!"
L.body_found_det = "Onlar bir Dedektifti."
L.body_found_inno = "Onlar bir Masumdu."

L.body_call = "{player}, {victim} adlı kurbanın cesedine Dedektif çağırdı!"
L.body_call_error = "Bir Dedektif çağırmadan önce bu oyuncunun ölümünü onaylamalısın!"

L.body_burning = "Ah! Bu ceset yanıyor!"
L.body_credits = "Cesette {num} kredi buldunuz!"

-- Menus and windows
L.close = "Kapat"
L.cancel = "İptal"

-- For navigation buttons
L.next = "Sonraki"
L.prev = "Önceki"

-- Equipment buying menu
L.equip_title = "Ekipman"
L.equip_tabtitle = "Ekipman Sipariş Et"

L.equip_status = "Sipariş durumu"
L.equip_cost = "{num} krediniz kaldı."
L.equip_help_cost = "Satın aldığınız her ekipman parçası 1 krediye mal olur."

L.equip_help_carry = "Yalnızca yeriniz olan şeyleri satın alabilirsiniz."
L.equip_carry = "Bu ekipmanı taşıyabilirsiniz."
L.equip_carry_own = "Bu öğeyi zaten taşıyorsunuz."
L.equip_carry_slot = "{slot} yuvasında zaten bir silah taşıyorsun."
L.equip_carry_minplayers = "Sunucuda bu silahı etkinleştirmek için yeterli oyuncu yok."

L.equip_help_stock = "Belirli öğelerden her rauntta yalnızca bir tane satın alabilirsiniz."
L.equip_stock_deny = "Bu ürün artık stokta yok."
L.equip_stock_ok = "Bu ürün stokta mevcut."

L.equip_custom = "Bu sunucu tarafından eklenen özel öğe."

L.equip_spec_name = "Ad"
L.equip_spec_type = "Tür"
L.equip_spec_desc = "Açıklama"

L.equip_confirm = "Ekipman satın al"

-- Disguiser tab in equipment menu
L.disg_name = "Kılık Değiştirici"
L.disg_menutitle = "Kılık değiştirme kontrolü"
L.disg_not_owned = "Kılık Değiştirici taşımıyorsun!"
L.disg_enable = "Kılık değiştirmeyi etkinleştir"

L.disg_help1 = "Kılık değiştiğinde, biri sana baktığında adın, sağlığın ve Karman gösterilmez. Ayrıca, bir Dedektifin radarından gizleneceksiniz."
L.disg_help2 = "Menüyü kullanmadan kılık değiştirmek için Numpad Enter tuşuna basın. Konsolu kullanarak farklı bir tuşa 'ttt_toggle_digguise' olarak da atayabilirsiniz."

-- Radar tab in equipment menu
L.radar_name = "Radar"
L.radar_menutitle = "Radar kontrolü"
L.radar_not_owned = "Radar taşımıyorsun!"
L.radar_scan = "Tarama yap"
L.radar_auto = "Otomatik tekrarlı tarama"
L.radar_help = "Tarama sonuçları {num} saniye boyunca gösterilir, bundan sonra Radar yeniden yüklenir ve tekrar kullanılabilir."
L.radar_charging = "Radarın hala şarj oluyor!"

-- Transfer tab in equipment menu
L.xfer_name = "Transfer"
L.xfer_menutitle = "Kredi transferi"
L.xfer_send = "Kredi gönder"

L.xfer_no_recip = "Alıcı geçerli değil, kredi transferi iptal edildi."
L.xfer_no_credits = "Transfer için yetersiz kredi."
L.xfer_success = "{player} adlı oyuncuya kredi transferi tamamlandı."
L.xfer_received = "{player} sana {num} kredi verdi."

-- Radio tab in equipment menu
L.radio_name = "Radyo"

-- Radio soundboard buttons
L.radio_button_scream = "Çığlık"
L.radio_button_expl = "Patlama"
L.radio_button_pistol = "Tabanca atışları"
L.radio_button_m16 = "M16 atışları"
L.radio_button_deagle = "Deagle atışları"
L.radio_button_mac10 = "MAC10 atışları"
L.radio_button_shotgun = "Pompalı tüfek atışları"
L.radio_button_rifle = "Tüfek atışı"
L.radio_button_huge = "H.U.G.E. patlaması"
L.radio_button_c4 = "C4 bip sesi"
L.radio_button_burn = "Yanma sesi"
L.radio_button_steps = "Adım sesi"

-- Intro screen shown after joining
L.intro_help = "Oyunda yeniyseniz, talimatlar için F1'e basın!"

-- Radiocommands/quickchat
L.quick_title = "Hızlı sohbet tuşları"

L.quick_yes = "Evet."
L.quick_no = "Hayır."
L.quick_help = "Yardım edin!"
L.quick_imwith = "{player} ile birlikteyim."
L.quick_see = "{player} oyuncusunu görüyorum."
L.quick_suspect = "{player} şüpheli davranıyor."
L.quick_traitor = "{player} Hain!"
L.quick_inno = "{player} masum."
L.quick_check = "Kimse hayatta mı?"

-- {player} in the quickchat text normally becomes a player nickname, but can
-- also be one of the below.  Keep these lowercase.
L.quick_nobody = "hiç kimse"
L.quick_disg = "kılık değiştirmiş"
L.quick_corpse = "kimliği belirsiz bir ceset"
L.quick_corpse_id = "{player} adlı ceset"

-- Scoreboard
L.sb_playing = "Şu anda bu sunucuda oynuyorsunuz..."
L.sb_mapchange_mode_0 = "Oturum sınırları devre dışı."
L.sb_mapchange_mode_1 = "{num} rauntta veya {time} içinde harita değişecektir."
L.sb_mapchange_mode_2 = "{time} içinde harita değişecektir."
L.sb_mapchange_mode_3 = "{num} raunt sonra harita değişecektir."

L.sb_mia = "Çatışmada Kayıp"
L.sb_confirmed = "Onaylanmış Ölü"

L.sb_ping = "Gecikme"
L.sb_deaths = "Ölüm"
L.sb_score = "Puan"
L.sb_karma = "Karma"

L.sb_info_help = "Bu oyuncunun cesedinde arama yapıp sonuçları buradan inceleyebilirsiniz."

L.sb_tag_friend = "ARKADAŞ"
L.sb_tag_susp = "ŞÜPHELİ"
L.sb_tag_avoid = "KAÇIN"
L.sb_tag_kill = "ÖLDÜR"
L.sb_tag_miss = "KAYIP"

-- Equipment actions, like buying and dropping
L.buy_no_stock = "Silahı bu rauntta aldın ve stoğu tükendi."
L.buy_pending = "Zaten bekleyen bir siparişiniz var, alana kadar bekleyin."
L.buy_received = "Özel ekipmanınızı aldınız."

L.drop_no_room = "Burada silahını bırakacak yerin yok!"

L.disg_turned_on = "Kılık değiştirme etkinleştirildi!"
L.disg_turned_off = "Kılık değiştirme devre dışı."

-- Equipment item descriptions
L.item_passive = "Pasif etki öğesi"
L.item_active = "Aktif kullanım öğesi"
L.item_weapon = "Silah"

L.item_armor = "Vücut Zırhı"
L.item_armor_desc = [[
Mermi, ateş ve patlama hasarını azaltır. Zamanla tükenir.

Birden çok kez satın alınabilir. Belirli bir zırh değerine ulaştıktan sonra, zırh güçlenir.]]

L.item_radar = "Radar"
L.item_radar_desc = [[
Yaşam belirtilerini taramanızı sağlar.

Satın alır almaz otomatik taramaları başlatır. Bu menünün Radar sekmesinde yapılandırın.]]

L.item_disg = "Kılık Değiştirici"
L.item_disg_desc = [[
Açıkken kimlik bilgilerinizi gizler. Ayrıca bir mağdur tarafından en son görülen kişi olmaktan korur.

Bu menünün Kılık Değiştirme sekmesini açın veya Numpad Enter tuşuna basın.]]

-- C4
L.c4_disarm_warn = "Yerleştirdiğiniz bir C4 patlayıcı etkisiz hale getirildi."
L.c4_armed = "Bombayı başarıyla devreye aldınız."
L.c4_disarmed = "Bombayı başarıyla etkisiz hale getirdiniz."
L.c4_no_room = "Bu C4'ü taşıyamazsınız."

L.c4_desc = "Güçlü zaman ayarlı patlayıcı."

L.c4_arm = "C4 kur"
L.c4_arm_timer = "Zamanlayıcı"
L.c4_arm_seconds = "Patlamaya saniye kaldı"
L.c4_arm_attempts = "Etkisiz hale getirme girişimlerinde, 6 telden {num} tanesi kesildiğinde anında patlamaya neden olur."

L.c4_remove_title = "Kaldırma"
L.c4_remove_pickup = "C4'ü al"
L.c4_remove_destroy1 = "C4'ü yok et"
L.c4_remove_destroy2 = "İmhayı onayla"

L.c4_disarm = "C4'ü devre dışı bırak"
L.c4_disarm_cut = "{num} telini kesmek için tıklayın"

L.c4_disarm_t = "Bombayı etkisiz hale getirmek için bir kablo kesin. Hain olduğun için her kablo güvende. Masumlar için iş o kadar kolay değil!"
L.c4_disarm_owned = "Bombayı etkisiz hale getirmek için bir kablo kesin. Bu senin bomban, bu yüzden her kablo onu etkisiz hale getirecek."
L.c4_disarm_other = "Bombayı etkisiz hale getirmek için bir kablo kesin. Yanlış yaparsan patlar!"

L.c4_status_armed = "DEVREYE ALINDI"
L.c4_status_disarmed = "DEVRE DIŞI"

-- Visualizer
L.vis_name = "Görüntüleyici"

L.vis_desc = [[
Olay yeri görüntüleme cihazı.

Kurbanın nasıl öldürüldüğünü göstermek için bir cesedi analiz eder, ancak sadece kurşun yaralarından ölmüşlerse.]]

-- Decoy
L.decoy_name = "Tuzak"
L.decoy_broken = "Tuzağınız yok edildi!"

L.decoy_short_desc = "Bu tuzak, diğer takımlar tarafından görülebilen sahte bir radar işareti gösterir"
L.decoy_pickup_wrong_team = "Farklı bir takıma ait olduğu için alamazsınız"

L.decoy_desc = [[
Diğer takımlara sahte bir radar işareti gösterir ve biri DNA'nızı tararsa DNA tarayıcısının tuzağın yerini göstermesini sağlar.]]

-- Defuser
L.defuser_name = "İmha Kiti"

L.defuser_desc = [[
Bir C4 patlayıcısını anında etkisiz hale getirin.

Sınırsız kullanım. Bunu taşırsanız C4'ün fark edilmesi daha kolay olacaktır.]]

-- Flare gun
L.flare_name = "İşaret Fişeği"

L.flare_desc = [[
Cesetleri asla bulunamayacak şekilde yakmak için kullanılabilir. Sınırlı cephane.

Bir cesedi yakmak belirgin bir ses çıkarır.]]

-- Health station
L.hstation_name = "Sağlık İstasyonu"

L.hstation_broken = "Sağlık İstasyonun yok edildi!"

L.hstation_desc = [[
Yerleştirildiğinde insanların iyileşmesini sağlar.

Yavaş şarj. Herkes kullanabilir ve zarar görebilir. Kullanıcılarının DNA örnekleri için kontrol edilebilir.]]

-- Knife
L.knife_name = "Bıçak"
L.knife_thrown = "Fırlatılan bıçak"

L.knife_desc = [[
Yaralı hedefleri anında ve sessizce öldürür, ancak yalnızca tek bir kullanımı vardır.

Alternatif ateş kullanılarak atılabilir.]]

-- Poltergeist
L.polter_desc = [[
Katilleri nesnelerle şiddetle itip kakarlar.

Enerji patlamaları yakındaki insanlara zarar verir.]]

-- Radio
L.radio_broken = "Radyonuz yok edildi!"

-- Silenced pistol
L.sipistol_name = "Susturuculu Tabanca"

L.sipistol_desc = [[
Düşük gürültülü tabanca, normal tabanca mermisi kullanır.

Kurbanlar öldürüldüklerinde çığlık atmazlar.]]

-- Newton launcher
L.newton_name = "Newton Fırlatıcı"

L.newton_desc = [[
İnsanları güvenli bir mesafeden itin.

Sonsuz cephane, ama ateş etmesi yavaş.]]

-- Binoculars
L.binoc_name = "Dürbün"

L.binoc_desc = [[
Cesetleri yakınlaştırın ve uzak mesafeden teşhis edin.

Sınırsız kullanım, ancak teşhis birkaç saniye sürer.]]

-- UMP
L.ump_desc = [[
Hedeflerin yönünü şaşırtan deneysel bir HMS.

Standart HMS cephanesi kullanır.]]

-- DNA scanner
L.dna_name = "DNA tarayıcı"
L.dna_notfound = "Hedefte DNA örneği bulunamadı."
L.dna_limit = "Depolama sınırına ulaşıldı. Yenilerini eklemek için eski numuneleri kaldırın."
L.dna_decayed = "Katilin DNA örneği çürümüş."
L.dna_killer = "Cesetten katilin DNA'sından bir örnek toplandı!"
L.dna_duplicate = "Eşleşme! Tarayıcınızda bu DNA örneği zaten var."
L.dna_no_killer = "DNA alınamadı (katil bağlantısı kesildi)."
L.dna_armed = "Bu bomba aktif! Önce onu etkisiz hale getir!"
L.dna_object = "Nesneden son sahibin bir örneği toplandı."
L.dna_gone = "Bölgede DNA tespit edilmedi."

L.dna_desc = [[
Nesnelerden DNA örnekleri toplayın ve bunları DNA'nın sahibini bulmak için kullanın.

Katilin DNA'sını almak ve izini sürmek için taze cesetler üzerinde kullanın.]]

-- Magneto stick
L.magnet_name = "Manyeto çubuğu"

-- Grenades and misc
L.grenade_smoke = "Duman bombası"
L.grenade_fire = "Yanıcı bomba"

L.unarmed_name = "Gizle"
L.crowbar_name = "Levye"
L.pistol_name = "Tabanca"
L.rifle_name = "Tüfek"
L.shotgun_name = "Pompalı tüfek"

-- Teleporter
L.tele_name = "Işınlayıcı"
L.tele_failed = "Işınlama başarısız oldu."
L.tele_marked = "Işınlanma konumu işaretlendi."

L.tele_no_ground = "Sağlam bir zemin üzerinde durmadan ışınlanamazsın!"
L.tele_no_crouch = "Çömelmişken ışınlanamazsın!"
L.tele_no_mark = "Konum işaretlenmedi. Işınlanmadan önce varış noktasını işaretleyin."

L.tele_no_mark_ground = "Sağlam bir zemin üzerinde durmadan ışınlanamazsın!"
L.tele_no_mark_crouch = "Çömelmişken ışınlanma konumu işaretlenemez!"

L.tele_help_pri = "İşaretli konuma ışınlanır"
L.tele_help_sec = "Mevcut konumu işaretler"

L.tele_desc = [[
Daha önce işaretlenmiş bir noktaya ışınlanın.

Işınlanma gürültü yapar ve kullanım sayısı sınırlıdır.]]

-- Ammo names, shown when picked up
L.ammo_pistol = "9mm cephanesi"

L.ammo_smg1 = "HMS cephanesi"
L.ammo_buckshot = "Pompalı Tüfek cephanesi"
L.ammo_357 = "Tüfek cephanesi"
L.ammo_alyxgun = "Deagle cephanesi"
L.ammo_ar2altfire = "İşaret Fişeği cephanesi"
L.ammo_gravity = "Afacan Peri cephanesi"

-- Round status
L.round_wait = "Bekleniyor"
L.round_prep = "Hazırlanıyor"
L.round_active = "Devam ediyor"
L.round_post = "Raunt bitti"

-- Health, ammo and time area
L.overtime = "UZATMA"
L.hastemode = "HIZLI MOD"

-- TargetID health status
L.hp_healthy = "Sağlıklı"
L.hp_hurt = "Hasar Görmüş"
L.hp_wounded = "Yaralı"
L.hp_badwnd = "Ağır Yaralı"
L.hp_death = "Ölüme Yakın"

-- TargetID Karma status
L.karma_max = "Saygın"
L.karma_high = "İyi"
L.karma_med = "Tetik Çekmeye Meyilli"
L.karma_low = "Tehlikeli"
L.karma_min = "Sorumsuz"

-- TargetID misc
L.corpse = "Ceset"
L.corpse_hint = "Arama yapmak için [{usekey}] tuşuna basın. Gizlice arama yapmak için [{walkkey}+{usekey}]."

L.target_disg = "(gizlenmiş)"
L.target_unid = "Tanımlanamayan ceset"
L.target_unknown = "Terörist"

-- HUD buttons with hand icons that only some roles can see and use
L.tbut_single = "Tek kullanımlık"
L.tbut_reuse = "Yeniden kullanılabilir"
L.tbut_retime = "{num} saniye sonra tekrar kullanılabilir"
L.tbut_help = "Etkinleştirmek için [{usekey}] tuşuna basın"

-- Spectator muting of living/dead
L.mute_living = "Canlı oyuncular sessize alındı"
L.mute_specs = "İzleyiciler sessize alındı"
L.mute_all = "Tümü sessize alındı"
L.mute_off = "Kimse sessize alınmadı"

-- Spectators and prop possession
L.punch_title = "GÜÇ ÖLÇER"
L.punch_bonus = "Kötü puanınız güç ölçer sınırınızı {num} düşürdü."
L.punch_malus = "İyi puanın güç ölçer sınırını {num} arttırdı!"

-- Info popups shown when the round starts
L.info_popup_innocent = [[
Sen masum bir teröristsin ama etrafta hainler var...
Kime güvenebilirsin ve seni kurşuna dizmek isteyen kim olabilir?

Arkanı kolla ve bu işten canlı çıkmak için yoldaşlarınla birlikte çalış!]]

L.info_popup_detective = [[
Sen bir Dedektifsin! Terörist Karargahı, hainleri bulman için sana özel kaynaklar verdi.
Masumların hayatta kalmasına yardımcı olmak için bunları kullanın, ancak dikkatli olun
hainler önce seni alaşağı etmek isteyecekler!

Ekipmanınızı almak için {menukey} tuşuna basın!]]

L.info_popup_traitor_alone = [[
Sen bir HAİNSİN! Bu rauntta hain arkadaşın yok.

Kazanmak için diğerlerini öldür!

Ekipmanınızı almak için {menukey} tuşuna basın!]]

L.info_popup_traitor = [[
Sen bir HAİNSİN! Diğerlerini öldürmek için diğer hainlerle birlikte çalışın.
Kendine iyi bak, yoksa vatan hainliğin ortaya çıkabilir...

Bunlar senin yoldaşların
{traitorlist}

Ekipmanınızı almak için {menukey} tuşuna basın!]]

-- Various other text
L.name_kick = "Rauntta bir oyuncu ismini değiştirdiği için otomatik olarak atıldı."

L.idle_popup = [[
{num} saniye boyunca boşta olduğun için İzleyici moduna aktarıldın. Bu moddayken, yeni bir raunt başladığında oyuna başlamayacaksın.

{helpkey} tuşuna basarak ve Ayarlar sekmesindeki kutunun işaretini kaldırarak istediğiniz zaman İzleyici modunu değiştirebilirsiniz. Ayrıca şu anda devre dışı bırakmayı da seçebilirsiniz.]]

L.idle_popup_close = "Hiçbir şey yapma"
L.idle_popup_off = "İzleyici modunu şimdi devre dışı bırak"

L.idle_warning = "Uyarı! Boşta gibi görünüyorsunuz ve hareket etmediğiniz sürece izleyiciye alınacaksınız!"

L.spec_mode_warning = "İzleyici modundasın ve bir raunt başladığında oyuna başlamayacaksın. Bu modu devre dışı bırakmak için F1'e basın, 'Oynanış'a gidin ve 'Yalnızca İzle modu'nun işaretini kaldırın."

-- Tips panel
L.tips_panel_title = "İpuçları"
L.tips_panel_tip = "İpucu"

-- Tip texts
L.tip1 = "Hainler, {walkkey} tuşunu basılı tutarak ve {usekey} tuşuna basarak, ölümü onaylamadan bir cesedi sessizce arayabilirler."

L.tip2 = "Bir C4'ü daha uzun bir zamanlayıcıyla donatmak, masum biri onu etkisiz hale getirmeye çalıştığında anında patlamasına neden olan tellerin sayısını artıracaktır. Ayrıca daha yumuşak ve daha az sıklıkta bip sesi çıkaracaktır."

L.tip3 = "Dedektifler, 'gözlerine yansıyanı' bulmak için bir cesedi arayabilirler. Bu, ölü adamın gördüğü son kişi. Arkadan vurulduysa katil olmak zorunda değil."

L.tip4 = "Kimse cesedinizi bulana ve sizi arayarak teşhis edene kadar öldüğünüzü bilmeyecek."

L.tip5 = "Bir Hain bir Dedektifi öldürdüğünde, anında bir kredi ödülü alır."

L.tip6 = "Bir Hain öldüğünde, tüm Dedektifler ekipman kredisi ile ödüllendirilir."

L.tip7 = "Hainler masumları öldürmede önemli ilerleme kaydettiklerinde, ödül olarak bir ekipman kredisi alacaklar."

L.tip8 = "Hainler ve Dedektifler, diğer Hainlerin ve Dedektiflerin cesetlerinden harcanmamış ekipman kredileri toplayabilir."

L.tip9 = "Afacan Peri herhangi bir fizik nesnesini ölümcül bir mermiye dönüştürebilir. Her darbeye, yakındaki herkese zarar veren bir enerji patlaması eşlik eder."

L.tip10 = "Bir alışveriş rolü olarak, siz ve yoldaşlarınız iyi performans gösterirseniz ekstra ekipman kredisi ile ödüllendirileceğinizi unutmayın. Harcamayı unutmayın!"

L.tip11 = "Dedektiflerin DNA Tarayıcısı, silahlardan ve eşyalardan DNA örnekleri toplamak ve daha sonra bunları kullanan oyuncunun yerini bulmak için tarama yapmak için kullanılabilir. Bir cesetten veya etkisiz hale getirilmiş bir C4'ten numune alabildiğinizde kullanışlıdır!"

L.tip12 = "Öldürdüğünüz birine yakın olduğunuzda, DNA'nızın bir kısmı cesedin üzerinde kalır. Bu DNA, mevcut konumunuzu bulmak için bir Dedektifin DNA Tarayıcısı ile kullanılabilir. Birini bıçakladıktan sonra cesedi saklasan iyi olur!"

L.tip13 = "Öldürdüğünüz birinden ne kadar uzaktaysanız, vücudundaki DNA örneğiniz o kadar hızlı bozulur."

L.tip14 = "Keskin nişancılık mı yapacaksın? Kılık Değiştiriciyi satın almayı düşünün. Bir atışı kaçırırsan, güvenli bir yere kaç, Kılık Değiştiriciyi devre dışı bırak ve hiç kimse onlara ateş edenin sen olduğunu bilmeyecek."

L.tip15 = "Bir Işınlayıcınız varsa, kovalandığınızda kaçmanıza yardımcı olabilir ve büyük bir harita üzerinde hızlı bir şekilde seyahat etmenizi sağlar. Her zaman işaretli güvenli bir pozisyonunuz olduğundan emin olun."

L.tip16 = "Masumların hepsi gruplanmış ve öldürmesi zor mu? C4 seslerini çalmak için Radyoyu veya bazılarını uzaklaştırmak için ateş etmeyi düşünün."

L.tip17 = "Radyoyu kullanarak, radyo yerleştirildikten sonra yerleştirme işaretçisine bakarak sesleri çalabilirsiniz. İstediğiniz sırayla birden fazla düğmeye tıklayarak birden fazla sesi sıraya koyun."

L.tip18 = "Dedektifken, kalan kredileriniz varsa, güvenilir bir Masuma İmha Kiti verebilirsiniz. O zaman zamanınızı ciddi araştırma çalışmaları yaparak geçirebilir ve riskli bomba imha işini onlara bırakabilirsiniz."

L.tip19 = "Dedektiflerin Dürbünü, cesetlerin uzun menzilli aranmasına ve tanımlanmasına izin verir. Hainler bir cesedi yem olarak kullanmayı umuyorsa kötü haber. Elbette, Dürbünü kullanırken bir Dedektif silahsızdır ve dikkati dağılır..."

L.tip20 = "Dedektiflerin Sağlık İstasyonu, yaralı oyuncuların iyileşmesini sağlar. Tabii o yaralılar da Hain olabilir..."

L.tip21 = "Sağlık İstasyonu, onu kullanan herkesin DNA örneğini kaydeder. Dedektifler bunu DNA Tarayıcısı ile kimin iyileştiğini bulmak için kullanabilirler."

L.tip22 = "Silahlar ve C4'ten farklı olarak, Hainler için Radyo ekipmanı, onu yerleştiren kişinin DNA örneğini içermez. Dedektiflerin onu bulması ve kimliğini ifşa etmesi konusunda endişelenme."

L.tip23 = "Kısa bir öğreticiyi görüntülemek veya TTT'ye özgü bazı ayarları değiştirmek için {helpkey} tuşuna basın."

L.tip24 = "Dedektif bir cesedi aradığında, sonuç ölü kişinin adına tıklayarak puan tablosu aracılığıyla tüm oyuncuların kullanımına açıktır."

L.tip25 = "Skor tablosunda, birinin adının yanındaki büyüteç simgesi, o kişi hakkında arama bilgilerine sahip olduğunuzu gösterir. Simge parlaksa, veriler bir Dedektiften gelir ve ek bilgiler içerebilir."

L.tip26 = "Takma adın altında büyüteç bulunan cesetler bir Dedektif tarafından arandığında sonuçları puan tablosu aracılığıyla tüm oyunculara açıktır."

L.tip27 = "İzleyiciler, diğer izleyicileri veya yaşayan oyuncuları susturmak için {mutekey} tuşuna basabilir."

L.tip28 = "{helpkey} tuşuna basarak Ayarlar menüsünde istediğiniz zaman farklı bir dile geçebilirsiniz."

L.tip29 = "Hızlı sohbet veya 'radyo' komutları {zoomkey} tuşuna basılarak kullanılabilir."

L.tip30 = "Levyenin ikincil ateşi diğer oyuncuları itecektir."

L.tip31 = "Nişangâhı kullanarak ateş etmek, isabetini biraz artıracak ve geri tepmeyi azaltacaktır. Çömelmek işe yaramaz."

L.tip32 = "Duman bombaları, özellikle kalabalık odalarda kafa karışıklığı yaratmak için iç mekanlarda etkilidir."

L.tip33 = "Hain olarak, cesetleri taşıyabileceğinizi ve onları masumların ve Dedektiflerinin meraklı gözlerinden saklayabileceğinizi unutmayın."

L.tip34 = "Skor tablosunda, yaşayan bir oyuncunun adına tıklayıp 'şüpheli' veya 'arkadaş' gibi bir etiket seçebilirsiniz. Bu etiket, nişangâhınızın altındaysa görünecektir."

L.tip35 = "Yerleştirilebilir ekipman öğelerinin çoğu (C4, Radyo gibi) ikincil ateş kullanılarak duvarlara yapıştırılabilir."

L.tip36 = "Etkisiz hale getirilirken bir hata nedeniyle patlayan C4, zamanlayıcısında sıfıra ulaşan C4'ten daha küçük bir patlamaya sahiptir."

L.tip37 = "Raunt zamanlayıcısının üzerinde 'HIZLI MOD' yazıyorsa, raunt ilk başta sadece birkaç dakika uzunluğunda olacaktır, ancak her ölümle birlikte mevcut süre artar. Bu mod, hainlere işlerini devam ettirmeleri için baskı yapar."

-- Round report
L.report_title = "Raunt Raporu"

-- Tabs
L.report_tab_hilite = "Öne Çıkanlar"
L.report_tab_hilite_tip = "Rauntta Öne Çıkanlar"
L.report_tab_events = "Olaylar"
L.report_tab_events_tip = "Bu raunt gerçekleşen olayların kaydı"
L.report_tab_scores = "Puanlar"
L.report_tab_scores_tip = "Sadece bu rauntta her oyuncunun aldığı puan"

-- Event log saving
L.report_save = ".txt olarak kaydet"
L.report_save_tip = "Olay Kaydını bir metin dosyasına kaydeder"
L.report_save_error = "Kaydedilecek Olay Kaydı verisi yok."
L.report_save_result = "Olay Kaydı şuraya kaydedildi:"

-- Columns
L.col_time = "Zaman"
L.col_event = "Olay"
L.col_player = "Oyuncu"
L.col_roles = "Rol"
L.col_teams = "Takım"
L.col_kills1 = "Öldürmeler"
L.col_kills2 = "Takım öldürmeleri"
L.col_points = "Puanlar"
L.col_team = "Takım bonusu"
L.col_total = "Toplam puan"

-- Awards/highlights
L.aw_sui1_title = "İntihar Tarikatı Lideri"
L.aw_sui1_text = "ilk giden olarak diğer intihar edenlere nasıl yapılacağını gösterdi."

L.aw_sui2_title = "Yalnız ve Depresyonda"
L.aw_sui2_text = "kendini öldüren tek kişiydi."

L.aw_exp1_title = "Patlayıcı Araştırma Hibesi"
L.aw_exp1_text = "patlamalar üzerine yaptıkları araştırmalarla tanındı. {num} denek yardımcı oldu."

L.aw_exp2_title = "Saha Araştırması"
L.aw_exp2_text = "patlamalara karşı kendi dirençlerini test etti. Yeterince yüksek değildi."

L.aw_fst1_title = "İlk Kan"
L.aw_fst1_text = "bir hainin elindeki ilk masum ölümü teslim etti."

L.aw_fst2_title = "İlk Kanlı Aptal Öldürme"
L.aw_fst2_text = "bir hain dostunu vurarak ilk cinayeti işledi. İyi iş."

L.aw_fst3_title = "İlk Hatacı"
L.aw_fst3_text = "ilk öldüren oldu. Masum bir yoldaş olması çok kötü oldu."

L.aw_fst4_title = "İlk Darbe"
L.aw_fst4_text = "ilk ölümü hainin yaparak masum teröristlere ilk darbeyi vurdu."

L.aw_all1_title = "Eşitler Arasında En Ölümcül"
L.aw_all1_text = "bu rauntta masumlar tarafından yapılan her cinayetten sorumluydu."

L.aw_all2_title = "Yalnız Kurt"
L.aw_all2_text = "bu rauntta bir hain tarafından yapılan her cinayetten sorumluydu."

L.aw_nkt1_title = "Birini Aldım Patron!"
L.aw_nkt1_text = "tek bir masumu öldürmeyi başardı. Güzel!"

L.aw_nkt2_title = "İki Kişilik Kurşun"
L.aw_nkt2_text = "ilkinin bir başkasını öldürerek şanslı bir atış olmadığını gösterdi."

L.aw_nkt3_title = "Seri Hain"
L.aw_nkt3_text = "bugün üç masum terörizm hayatına son verdi."

L.aw_nkt4_title = "Daha Fazla Koyun Benzeri Kurt Arasında Kurt"
L.aw_nkt4_text = "Masum teröristleri akşam yemeğinde yer. {num} yemekten oluşan bir akşam yemeği."

L.aw_nkt5_title = "Terörle Mücadele Operatörü"
L.aw_nkt5_text = "öldürme başına ödeme alır. Artık başka bir lüks yat satın alabilirim."

L.aw_nki1_title = "Buna İhanet Et"
L.aw_nki1_text = "bir hain buldu. Bir haini vurdu. Kolaydı."

L.aw_nki2_title = "Adalet Ekibine Müracaat Edildi"
L.aw_nki2_text = "iki haine büyük öteye kadar eşlik etti."

L.aw_nki3_title = "Hainler Hain Koyun Düşler mi"
L.aw_nki3_text = "üç haine tatlı rüyalar gördür."

L.aw_nki4_title = "İçişleri Çalışanı"
L.aw_nki4_text = "öldürme başına ödeme alır. Artık beşinci yüzme havuzunu sipariş edebilir."

L.aw_fal1_title = "Hayır Bay Bond, Düşmenizi Bekliyorum"
L.aw_fal1_text = "birini büyük bir yükseklikten itti."

L.aw_fal2_title = "Döşenmiş"
L.aw_fal2_text = "kayda değer bir yükseklikten düştükten sonra bedenlerinin yere çarpmasına izin verin."

L.aw_fal3_title = "İnsan Göktaşı"
L.aw_fal3_text = "büyük bir yükseklikten birinin üstüne düşerek ezdi."

L.aw_hed1_title = "Verimlilik"
L.aw_hed1_text = "kafadan vurma sevincini keşfetti ve {num} kazandı."

L.aw_hed2_title = "Nöroloji"
L.aw_hed2_text = "daha yakından incelemek için beyinleri {num} kafadan çıkardı."

L.aw_hed3_title = "Video Oyunları Bana Zorla Yaptırdı"
L.aw_hed3_text = "cinayet simülasyonu eğitimini uyguladı ve {num} düşmanı kafadan vurdu."

L.aw_cbr1_title = "Sırra Kadem Bas"
L.aw_cbr1_text = "levyeyi gelişigüzel sallar ve bunu {num} kurban öğrenir."

L.aw_cbr2_title = "Freeman"
L.aw_cbr2_text = "levyelerini en az {num} kişinin beynine sapladı."

L.aw_pst1_title = "Israrcı Küçük Alçak"
L.aw_pst1_text = "tabancayı kullanarak {num} kişi öldürdü. Sonra birine ölümüne sarılmaya devam ettiler."

L.aw_pst2_title = "Küçük Kalibreli Kesim"
L.aw_pst2_text = "{num} kişilik küçük bir orduyu tabancayla öldürdü. Muhtemelen namlunun içine küçük bir av tüfeği yerleştirdi."

L.aw_sgn1_title = "Kolay Mod"
L.aw_sgn1_text = "iri saçmayı acıdığı yere uygulayarak {num} hedefi öldürür."

L.aw_sgn2_title = "Bin Küçük Saçma Tanesi"
L.aw_sgn2_text = "saçmalarını gerçekten beğenmedi, bu yüzden hepsini verdiler. {num} alıcı bundan zevk alacak kadar yaşamadı."

L.aw_rfl1_title = "İşaretle ve Tıkla"
L.aw_rfl1_text = "{num} öldürme için ihtiyacın olan tek şeyin bir tüfek ve titremeyen bir el olduğunu gösterir."

L.aw_rfl2_title = "Kafanı Buradan Görebiliyorum"
L.aw_rfl2_text = "tüfeğini biliyor. Şimdi {num} kişi daha tüfeği biliyor."

L.aw_dgl1_title = "Küçük Bir Tüfek Gibi"
L.aw_dgl1_text = "Desert Eagle'a alışıp {num} kişiyi öldürdü."

L.aw_dgl2_title = "Deagle Ustası"
L.aw_dgl2_text = "{num} kişiyi deagle ile darmadağın etti."

L.aw_mac1_title = "Dua Et ve Öldür"
L.aw_mac1_text = "MAC10 ile {num} kişiyi öldürdü, ama öldürmek için ne kadar mermiye ihtiyaç duyduğunu söylemeyecek."

L.aw_mac2_title = "Gülümse ve Seyret"
L.aw_mac2_text = "iki MAC10 kullanabilseler ne olacağını merak ediyor. {num} çarpı iki"

L.aw_sip1_title = "Sessiz Ol"
L.aw_sip1_text = "{num} kişiyi susturulmuş tabancayla sustur."

L.aw_sip2_title = "Susturulmuş Suikastçı"
L.aw_sip2_text = "kendini ölürken duymayan {num} kişiyi öldürdü."

L.aw_knf1_title = "Seni Bilen Bıçak"
L.aw_knf1_text = "internet üzerinden birini yüzünden bıçakladı."

L.aw_knf2_title = "Bunu Nereden Aldın"
L.aw_knf2_text = "bir Hain değildi, ama yine de bıçakla birini öldürdü."

L.aw_knf3_title = "Böyle Bir Bıçak Adam"
L.aw_knf3_text = "etrafta {num} bıçak buldu ve bunlardan faydalandı."

L.aw_knf4_title = "Dünyanın En Bıçak Adamı"
L.aw_knf4_text = "{num} kişiyi bıçakla öldürdü. Nasıl olduğunu sorma."

L.aw_flg1_title = "Kurtarmaya"
L.aw_flg1_text = "işaret fişeklerini {num} ölüm sinyali vermek için kullandı."

L.aw_flg2_title = "İşaret Fişeği Yangını Gösterir"
L.aw_flg2_text = "{num} erkeğe yanıcı kıyafet giymenin tehlikesini öğretti."

L.aw_hug1_title = "H.U.G.E Felaketi"
L.aw_hug1_text = "H.U.G.E.'leriyle uyumluydu, bir şekilde mermilerini {num} kişiye isabet ettirmeyi başardı."

L.aw_hug2_title = "Sabırlı Er"
L.aw_hug2_text = "sadece ateş etmeye devam etti ve H.U.G.E.'nin sabrının {num} öldürme ile ödüllendirildiğini gördü."

L.aw_msx1_title = "Bam Bam Bam"
L.aw_msx1_text = "M16 ile {num} kişiyi öldürdü."

L.aw_msx2_title = "Orta Menzil Çılgınlığı"
L.aw_msx2_text = "M16 ile hedefleri nasıl indireceğini bilir ve {num} düşman öldürür."

L.aw_tkl1_title = "Sakar Şakir"
L.aw_tkl1_text = "tam bir arkadaşa nişan alırken parmakları kaydı."

L.aw_tkl2_title = "Çifte Sakar Şakir"
L.aw_tkl2_text = "iki kez Hain aldıklarını düşündüler, ancak her iki seferde de yanıldılar."

L.aw_tkl3_title = "Karma bilincine sahip"
L.aw_tkl3_text = "iki takım arkadaşını öldürdükten sonra duramadı. Üç onların uğurlu sayısıdır."

L.aw_tkl4_title = "Takım Katili"
L.aw_tkl4_text = "tüm takımını öldürdü. ALLAH'INI SEVEN BANLASIN."

L.aw_tkl5_title = "Rol Oyuncusu"
L.aw_tkl5_text = "dürüstçe deli bir adamı canlandırıyordu. Bu yüzden takımlarının çoğunu öldürdüler."

L.aw_tkl6_title = "Aptal"
L.aw_tkl6_text = "hangi tarafta olduklarını anlayamadılar ve yoldaşlarının yarısından fazlasını öldürdüler."

L.aw_tkl7_title = "Cahil"
L.aw_tkl7_text = "takım arkadaşlarının dörtte birinden fazlasını öldürerek bölgelerini gerçekten iyi korudu."

L.aw_brn1_title = "Eskiden Büyükannemin Yaptığı Gibi"
L.aw_brn1_text = "birkaç kişiyi güzelce kızarttı."

L.aw_brn2_title = "Kundakçı"
L.aw_brn2_text = "kurbanlarından birini yaktıktan sonra yüksek sesle kıkırdadığı duyuldu."

L.aw_brn3_title = "Kundakçının Ateşi Söner"
L.aw_brn3_text = "hepsini yaktı, ama şimdi hiç yakıcı el bombası kalmadı! Nasıl başa çıkacaklar!"

L.aw_fnd1_title = "Adli tabip"
L.aw_fnd1_text = "etrafta {num} ceset bulundu."

L.aw_fnd2_title = "Hepsini Yakalamalıyım"
L.aw_fnd2_text = "koleksiyonları için {num} ceset bulundu."

L.aw_fnd3_title = "Ölüm Kokusu"
L.aw_fnd3_text = "bu turda {num} kez rastgele cesetler üzerinde tökezler."

L.aw_crd1_title = "Geri Dönüştürücü"
L.aw_crd1_text = "cesetlerden {num} kredi toplandı."

L.aw_tod1_title = "Kundakçının Zaferi"
L.aw_tod1_text = "takımları raundu kazanmadan sadece saniyeler önce öldü."

L.aw_tod2_title = "Bu Oyundan Nefret Ediyorum"
L.aw_tod2_text = "raundun başlamasından hemen sonra öldü."

-- New and modified pieces of text are placed below this point, marked with the
-- version in which they were added, to make updating translations easier.

-- v24
L.drop_no_ammo = "Silahının şarjöründe cephane kutusu olarak düşecek yeterli cephane yok."

-- 2015-05-25
L.hat_retrieve = "Bir Dedektif'in şapkasını aldın."

-- 2017-09-03
L.sb_sortby = "Sıralama Ölçütü"

-- 2018-07-24
L.equip_tooltip_main = "Ekipman menüsü"
L.equip_tooltip_radar = "Radar kontrolü"
L.equip_tooltip_disguise = "Kılık değiştirme kontrolü"
L.equip_tooltip_radio = "Radyo kontrolü"
L.equip_tooltip_xfer = "Kredileri aktar"
L.equip_tooltip_reroll = "Ekipmanı yeniden dağıt"

L.confgrenade_name = "Kafa Karıştırıcı"
L.polter_name = "Afacan Peri"
L.stungun_name = "UMP Prototipi"

L.knife_instant = "ANINDA ÖLDÜRME"

L.binoc_zoom_level = "Yakınlaştırma Seviyesi"
L.binoc_body = "CESET ALGILANDI"

L.idle_popup_title = "Boşta"

-- 2019-01-31
L.create_own_shop = "Kendi mağazanı oluştur"
L.shop_link = "Şununla bağlantı kur"
L.shop_disabled = "Mağazayı devre dışı bırak"
L.shop_default = "Varsayılan mağazayı kullan"

-- 2019-05-05
L.reroll_name = "Yeniden dağıt"
L.reroll_menutitle = "Ekipmanı yeniden dağıt"
L.reroll_no_credits = "Yeniden dağıtmak için {amount} krediye ihtiyacınız var!"
L.reroll_button = "Yeniden Dağıt"
L.reroll_help = "Mağazanızda yeni bir rastgele ekipman seti almak için {amount} kredi kullanın!"

-- 2019-05-06
L.equip_not_alive = "Sağdan bir rol seçerek mevcut tüm öğeleri görüntüleyebilirsiniz. Favorilerinizi işaretlemeyi unutmayın!"

-- 2019-06-27
L.shop_editor_title = "Mağaza Düzenleme"
L.shop_edit_items_weapong = "Silahları Düzenle"
L.shop_edit = "Mağazaları Düzenle"
L.shop_settings = "Ayarlar"
L.shop_select_role = "Rol Seç"
L.shop_edit_items = "Öğeleri Düzenle"
L.shop_edit_shop = "Mağazayı Düzenle"
L.shop_create_shop = "Özel Mağaza Oluştur"
L.shop_selected = "Seçili {role}"
L.shop_settings_desc = "Rastgele Mağaza Konsol Değişkeni uyarlamak için değerleri değiştirin. Değişikliklerinizi kaydetmeyi unutmayın!"

L.bindings_new = "{name} {key} için atanan yeni tuş"

L.hud_default_failed = "{hudname} arayüzü varsayılan olarak ayarlanamadı. Bunu yapma izniniz yok veya bu arayüz mevcut değil."
L.hud_forced_failed = "{hudname} arayüzü zorlanamadı. Bunu yapma izniniz yok veya bu arayüz mevcut değil."
L.hud_restricted_failed = "{hudname} arayüzü kısıtlanamadı. Bunu yapmak için iznin yok."

L.shop_role_select = "Bir rol seçin"
L.shop_role_selected = "{role} adlı rolün mağazası seçildi!"
L.shop_search = "Ara"

-- 2019-10-19
L.drop_ammo_prevented = "Bir şey cephanenizi düşürmenizi engelliyor."

-- 2019-10-28
L.target_c4 = "C4 menüsünü açmak için [{usekey}] tuşuna basın"
L.target_c4_armed = "C4'ü devre dışı bırakmak için [{usekey}] tuşuna basın"
L.target_c4_armed_defuser = "İmha kitini kullanmak için [{primaryfire}] tuşuna basın"
L.target_c4_not_disarmable = "Yaşayan bir takım arkadaşının C4'ünü devre dışı bırakamazsın"
L.c4_short_desc = "Çok patlayıcı bir şey"

L.target_pickup = "Almak için [{usekey}] tuşuna basın"
L.target_slot_info = "{slot} yuvası"
L.target_pickup_weapon = "Silahı almak için [{usekey}] tuşuna basın"
L.target_switch_weapon = "Mevcut silahınla değiştirmek için [{usekey}] tuşuna basın"
L.target_pickup_weapon_hidden = "Gizli alım için [{walkkey} + {usekey}] tuşuna basın"
L.target_switch_weapon_hidden = "Gizli anahtar için [{walkkey} + {usekey}] tuşuna basın"
L.target_switch_weapon_nospace = "Bu silah için kullanılabilir envanter yuvası yok"
L.target_switch_drop_weapon_info = "{name} {slot} yuvasından bırakılıyor"
L.target_switch_drop_weapon_info_noslot = "{slot} yuvasında düşürülebilir silah yok"

L.corpse_searched_by_detective = "Bu ceset bir dedektif tarafından arandı"
L.corpse_too_far_away = "Ceset çok uzakta."

L.radio_short_desc = "Silah sesleri benim için müziktir"

L.hstation_subtitle = "Sağlık almak için [{usekey}] tuşuna basın."
L.hstation_charge = "Sağlık istasyonunun kalan şarjı {charge}"
L.hstation_empty = "Bu sağlık istasyonunda daha fazla şarj kalmadı"
L.hstation_maxhealth = "Sağlığınız tam"
L.hstation_short_desc = "Sağlık istasyonu zaman içinde yavaş yavaş şarj olur"

-- 2019-11-03
L.vis_short_desc = "Kurban ateşli silahla yaralanarak öldüyse olay yerini gösterir"
L.corpse_binoculars = "Cesedi dürbünle aramak için [{key}] tuşuna basın."
L.binoc_progress = "Aranıyor: %{progress}"

L.pickup_no_room = "Bu silah türü için envanterinizde yer yok."
L.pickup_fail = "Bu silahı alamazsın."
L.pickup_pending = "Zaten bir silah aldın, alana kadar bekle."

-- 2020-01-07
L.tbut_help_admin = "Hain düğmesi ayarlarını düzenle"
L.tbut_role_toggle = "[{walkkey} + {usekey}] düğmesi {role} için"
L.tbut_role_config = "Rol {current}"
L.tbut_team_toggle = "{team} için bu düğmeyi açmak için [SHIFT + {walkkey} + {usekey}]"
L.tbut_team_config = "Takım {current}"
L.tbut_current_config = "Geçerli yapılandırma"
L.tbut_intended_config = "Harita oluşturucu tarafından tasarlanan yapılandırma"
L.tbut_admin_mode_only = "Yönetici olduğunuz ve '{cv}' öğesi '1' olarak ayarlandığı için bu düğmeyi görüyorsunuz."
L.tbut_allow = "İzin ver"
L.tbut_prohib = "Yasakla"
L.tbut_default = "Varsayılan"

-- 2020-02-09
L.name_door = "Kapı"
L.door_open = "Kapıyı açmak için [{usekey}] tuşuna basın."
L.door_close = "Kapıyı kapatmak için [{usekey}] tuşuna basın."
L.door_locked = "Bu kapı kilitli."

-- 2020-02-11
L.automoved_to_spec = "(OTOMATİK MESAJ) Boşta olduğum için İzleyici takımına alındım."
L.mute_team = "{team} sessize alındı."

-- 2020-02-16
L.door_auto_closes = "Bu kapı otomatik olarak kapanır."
L.door_open_touch = "Açmak için kapıya doğru yürü."
L.door_open_touch_and_use = "Kapıya doğru yürü veya açmak için [{usekey}] tuşuna bas."

-- 2020-03-09
L.help_title = "Ayarlar ve Yardım"

L.menu_changelog_title = "Değişiklik günlüğü"
L.menu_guide_title = "TTT2 Kılavuzu"
L.menu_bindings_title = "Tuş Atamaları"
L.menu_language_title = "Dil"
L.menu_appearance_title = "Görünüm"
L.menu_gameplay_title = "Oynanış"
L.menu_addons_title = "Eklentiler"
L.menu_legacy_title = "Eski Eklentiler"
L.menu_administration_title = "Yönetim"
L.menu_equipment_title = "Ekipmanı Düzenle"
L.menu_shops_title = "Mağazaları Düzenle"

L.menu_changelog_description = "Son sürümlerdeki değişikliklerin ve düzeltmelerin listesi."
L.menu_guide_description = "TTT2'ye başlamanıza yardımcı olur ve oyun, roller ve diğer şeyler hakkında bazı şeyleri açıklar."
L.menu_bindings_description = "TTT2'nin ve eklentilerinin belirli özelliklerini kendi beğeninize göre ayarlayın."
L.menu_language_description = "Oyun modunun dilini seçin."
L.menu_appearance_description = "Kullanıcı arayüzünün görünümünü ve performansını değiştirin."
L.menu_gameplay_description = "Ses, erişilebilirlik ve oynanış ayarlarını düzenleyin."
L.menu_addons_description = "Yerel eklentileri istediğiniz gibi yapılandırın."
L.menu_legacy_description = "Orijinal TTT'den dönüştürülen sekmelerin yeni sisteme taşınması gereken bir panel."
L.menu_administration_description = "Arayüzler, mağazalar vb. için genel ayarlar"
L.menu_equipment_description = "Kredileri, sınırlamaları, kullanılabilirliği ve diğer şeyleri ayarlayın."
L.menu_shops_description = "Mağazaları istediğiniz roller için ekleyin ve hangi ekipmanlara sahip olduklarını yapılandırın."

L.submenu_guide_gameplay_title = "Oynanış"
L.submenu_guide_roles_title = "Roller"
L.submenu_guide_equipment_title = "Ekipman"

L.submenu_bindings_bindings_title = "Atamalar"

L.submenu_language_language_title = "Dil"

L.submenu_appearance_general_title = "Genel"
L.submenu_appearance_hudswitcher_title = "Arayüz Değiştirici"
L.submenu_appearance_vskin_title = "Valve Arayüzü"
L.submenu_appearance_targetid_title = "Hedef Kimliği"
L.submenu_appearance_shop_title = "Mağaza Ayarları"
L.submenu_appearance_crosshair_title = "Nişangâh"
L.submenu_appearance_dmgindicator_title = "Hasar Göstergesi"
L.submenu_appearance_performance_title = "Performans"
L.submenu_appearance_interface_title = "Arayüz"

L.submenu_gameplay_general_title = "Genel"

L.submenu_administration_hud_title = "Arayüz Ayarları"
L.submenu_administration_randomshop_title = "Rasgele Mağaza"

L.help_color_desc = "Bu ayar etkinleştirilirse, hedef kimliği dış çizgisi ve nişangâh için kullanılacak genel bir renk seçebilirsiniz."
L.help_scale_factor = "Bu ölçek faktörü tüm arayüz öğelerini (Arayüz, Valve Grafiksel Kullanıcı Arayüzü ve Hedef Kimliği) etkiler. Ekran çözünürlüğü değiştirilirse otomatik olarak güncellenir. Bu değerin değiştirilmesi arayüzü sıfırlayacaktır!"
L.help_hud_game_reload = "Arayüz şu anda kullanılamıyor. Sunucuya yeniden bağlanın veya oyunu yeniden başlatın."
L.help_hud_special_settings = "Bunlar bu arayüzün özel ayarlarıdır."
L.help_vskin_info = "Valve Arayüzü (Valve Grafiksel Kullanıcı Arayüz görünümü), mevcut olan tüm menü öğelerine uygulanan görünümdür. Basit bir Lua komut dosyası ile kolayca oluşturulabilirler ve renkleri ve bazı boyut parametrelerini değiştirebilirler."
L.help_targetid_info = "Hedef Kimliği, nişangâhınızı bir varlığa yönlendirirken oluşturulan bilgilerdir. Rengi 'Genel' sekmesinde yapılandırılabilir."
L.help_hud_default_desc = "Tüm oyuncular için varsayılan arayüz değerini ayarlar. Henüz bir arayüz seçmemiş olan oyuncular, varsayılan olarak bu arayüzü alacaklardır. Bunu değiştirmek, arayüzlerini zaten seçmiş olan oyuncuların arayüzlerini değiştirmez."
L.help_hud_forced_desc = "Tüm oyuncular için bir arayüz zorlar. Bu, arayüz seçim özelliğini herkes için devre dışı bırakır."
L.help_hud_enabled_desc = "Bu arayüzlerin seçimini kısıtlamak için etkinleştir veya devre dışı bırak."
L.help_damage_indicator_desc = "Hasar göstergesi, oyuncu hasar gördüğünde gösterilen bir göstergedir. Yeni bir tema eklemek için 'materialsvguitttdamageindicatorthemes' içine bir png yerleştirin."
L.help_shop_key_desc = "Bir raundun sonunda hazırlanırken skor menüsü yerine mağaza tuşuna basarak mağazayı açın"

L.label_menu_menu = "MENÜ"
L.label_menu_admin_spacer = "Yönetici Alanı (normal kullanıcılara gösterilmez)"
L.label_language_set = "Dil seç"
L.label_global_color_enable = "Genel rengi etkinleştir"
L.label_global_color = "Genel renk"
L.label_global_scale_factor = "Genel ölçek faktörü"
L.label_hud_select = "Arayüz Seç"
L.label_vskin_select = "Valve Arayüzü seçin"
L.label_blur_enable = "Valve Arayüz arka plan bulanıklığını etkinleştir"
L.label_color_enable = "Valve Arayüz arka plan rengini etkinleştir"
L.label_minimal_targetid = "Nişangâh altında minimalist Hedef Kimliği (Karma metni, ipuçları vb.)"
L.label_shop_always_show = "Her zaman mağazayı göster"
L.label_shop_double_click_buy = "Mağazada üzerine çift tıklayarak bir ürün satın almayı etkinleştir"
L.label_shop_num_col = "Sütun sayısı"
L.label_shop_num_row = "Satır sayısı"
L.label_shop_item_size = "Simge boyutu"
L.label_shop_show_slot = "Yuva işaretini göster"
L.label_shop_show_custom = "Özel öğe işaretini göster"
L.label_shop_show_fav = "Favori öğe işaretini göster"
L.label_crosshair_enable = "Nişangâhı etkinleştir"
L.label_crosshair_opacity = "Nişangâh opaklığı"
L.label_crosshair_ironsight_opacity = "Gez ve arpacık opaklığı"
L.label_crosshair_size = "Nişangâh boyutu"
L.label_crosshair_thickness = "Nişangâh kalınlığı"
L.label_crosshair_thickness_outline = "Nişangâh dış çizgi kalınlığı"
L.label_crosshair_scale_enable = "Silaha bağlı nişangâh ölçeğini etkinleştir"
L.label_crosshair_ironsight_low_enabled = "Gez ve arpacık kullanırken silahı indirin"
L.label_damage_indicator_enable = "Hasar göstergesini etkinleştir"
L.label_damage_indicator_mode = "Hasar göstergesi temasını seçin"
L.label_damage_indicator_duration = "Vurulduktan sonra solma süresi (saniye olarak)"
L.label_damage_indicator_maxdamage = "Maksimum opaklık için gereken hasar"
L.label_damage_indicator_maxalpha = "Maksimum opaklık"
L.label_performance_halo_enable = "Bazı varlıklara bakarken etrafına bir dış çizgi çizin"
L.label_performance_spec_outline_enable = "Kontrol edilen nesnelerin dış çizgilerini etkinleştir"
L.label_performance_ohicon_enable = "Oyuncuların başındaki rol simgelerini etkinleştir"
L.label_interface_popup = "Raunt başlangıç bilgisini gösteren açılan pencerenin süresi"
L.label_interface_fastsw_menu = "Hızlı silah değişme ile menüyü etkinleştir"
L.label_inferface_wswitch_hide_enable = "Silah değişme menüsünün otomatik olarak kapanmasını etkinleştir"
L.label_inferface_scues_enable = "Bir raunt başladığında veya bittiğinde ses işaretini çal"
L.label_gameplay_specmode = "Yalnızca İzle modu (her zaman izleyici olarak kal)"
L.label_gameplay_fastsw = "Hızlı silah değişme"
L.label_gameplay_hold_aim = "Nişan almak için tutmayı etkinleştir"
L.label_gameplay_mute = "Öldüğünde canlı oyuncuları sessize al"
L.label_hud_default = "Varsayılan Arayüz"
L.label_hud_force = "Zorunlu Arayüz"

L.label_bind_voice = "Genel Sesli Sohbet"
L.label_bind_voice_team = "Takım Sesli Sohbeti"

L.label_hud_basecolor = "Temel Renk"

L.label_menu_not_populated = "Bu alt menü herhangi bir içerik içermiyor."

L.header_bindings_ttt2 = "TTT2 Tuş Atamaları"
L.header_bindings_other = "Diğer Atamalar"
L.header_language = "Dil Ayarları"
L.header_global_color = "Genel Rengi Seç"
L.header_hud_select = "Bir arayüz seçin"
L.header_hud_customize = "Arayüzü Özelleştir"
L.header_vskin_select = "Valve Arayüzü Seç ve Özelleştir"
L.header_targetid = "Hedef Kimliği Ayarları"
L.header_shop_settings = "Ekipman Mağazası Ayarları"
L.header_shop_layout = "Öğe Listesi Düzeni"
L.header_shop_marker = "Öğe İşaretleyici Ayarları"
L.header_crosshair_settings = "Nişangâh Ayarları"
L.header_damage_indicator = "Hasar Göstergesi Ayarları"
L.header_performance_settings = "Performans Ayarları"
L.header_interface_settings = "Arayüz Ayarları"
L.header_gameplay_settings = "Oynanış Ayarları"
L.header_hud_administration = "Varsayılan ve Zorunlu Arayüzleri Seç"
L.header_hud_enabled = "Arayüzleri etkinleştir veya devre dışı bırak"

L.button_menu_back = "Geri"
L.button_none = "Yok"
L.button_press_key = "Bir tuşa basın"
L.button_save = "Kaydet"
L.button_reset = "Sıfırla"
L.button_close = "Kapat"
L.button_hud_editor = "Arayüz Düzenleyici"

-- 2020-04-20
L.item_speedrun = "Hız"
L.item_speedrun_desc = [[Sizi %50 daha hızlı yapar!]]
L.item_no_explosion_damage = "Patlama Hasarı Yok"
L.item_no_explosion_damage_desc = [[Patlama hasarına karşı bağışıklık kazandırır.]]
L.item_no_fall_damage = "Düşme Hasarı Yok"
L.item_no_fall_damage_desc = [[Düşme hasarına karşı bağışıklık kazandırır.]]
L.item_no_fire_damage = "Yanma Hasarı Yok"
L.item_no_fire_damage_desc = [[Yanma hasarına karşı bağışıklık kazandırır.]]
L.item_no_hazard_damage = "Tehlike Hasarı Yok"
L.item_no_hazard_damage_desc = [[Zehir, radyasyon ve asit gibi tehlike hasarlarına karşı bağışıklık kazandırır.]]
L.item_no_energy_damage = "Enerji Hasarı Yok"
L.item_no_energy_damage_desc = [[Lazer, plazma ve yıldırım gibi enerji hasarlarına karşı bağışıklık kazandırır.]]
L.item_no_prop_damage = "Nesne Hasarı Yok"
L.item_no_prop_damage_desc = [[Nesne hasarına karşı bağışıklık kazandırır.]]
L.item_no_drown_damage = "Boğulma Hasarı Yok"
L.item_no_drown_damage_desc = [[Boğulma hasarına karşı bağışıklık kazandırır.]]

-- 2020-04-21
L.dna_tid_possible = "Tarama yapılabilir."
L.dna_tid_impossible = "Tarama yapılamaz."
L.dna_screen_ready = "DNA yok"
L.dna_screen_match = "Eşleşme"

-- 2020-04-30
L.message_revival_canceled = "Diriliş iptal edildi."
L.message_revival_failed = "Diriliş başarısız oldu."
L.message_revival_failed_missing_body = "Cesediniz artık mevcut olmadığı için diriltilemediniz."
L.hud_revival_title = "Dirilişe kalan süre"
L.hud_revival_time = "{time}sn"

-- 2020-05-03
L.door_destructible = "Bu kapı yok edilebilir ({health}SP)."

-- 2020-05-28
L.corpse_hint_inspect_limited = "Arama yapmak için [{usekey}] tuşuna basın. Yalnızca arama kullanıcı arayüzünü görüntülemek için [{walkkey} + {usekey}]"

-- 2020-06-04
L.label_bind_disguiser = "Kılık Değiştiriciyi aç/kapat"

-- 2020-06-24
L.dna_help_primary = "DNA örneği al"
L.dna_help_secondary = "DNA yuvasını değiştirin"
L.dna_help_reload = "Numuneyi sil"

L.binoc_help_pri = "Bir ceset ara."
L.binoc_help_sec = "Yakınlaştırma seviyesini değiştirin."

L.vis_help_pri = "Etkinleştirilmiş cihazı bırakın."

-- 2020-08-07
L.pickup_error_spec = "Bunu izleyici olarak alamazsın."
L.pickup_error_owns = "Bu silah zaten sende olduğu için bunu alamazsın."
L.pickup_error_noslot = "Boş alanın olmadığı için bunu alamazsın."

-- 2020-11-02
L.lang_server_default = "Sunucu Varsayılanı"
L.help_lang_info = [[
Bu çeviri %{coverage} oranında tamamlandı ve İngilizce dili varsayılan referans olarak alındı.

Bu çevirilerin topluluk tarafından yapıldığını unutmayın. Bir şey eksik veya yanlışsa katkıda bulunmaktan çekinmeyin.]]

-- 2021-04-13
L.title_score_info = "Raunt Sonu Bilgisi"
L.title_score_events = "Olay Zaman Çizelgesi"

L.label_bind_clscore = "Açık raunt raporu"
L.title_player_score = "{player} puanı"

L.label_show_events = "Şuradaki olayları göster"
L.button_show_events_you = "Siz"
L.button_show_events_global = "Genel"
L.label_show_roles = "Rol dağılımını göster"
L.button_show_roles_begin = "Raunt Başlangıcı"
L.button_show_roles_end = "Raunt Sonu"

L.hilite_win_traitors = "HAİN TAKIMI KAZANDI"
L.hilite_win_innocents = "MASUM TAKIMI KAZANDI"
L.hilite_win_tie = "BERABERE"
L.hilite_win_time = "SÜRE DOLDU"

L.tooltip_karma_gained = "Bu raunt için Karma değişiklikleri"
L.tooltip_score_gained = "Bu raunt için puan değişiklikleri"
L.tooltip_roles_time = "Bu raunt için rol değişiklikleri"

L.tooltip_finish_score_win = "Kazanılan: {score}"
L.tooltip_finish_score_alive_teammates = "Canlı takım arkadaşları {score}"
L.tooltip_finish_score_alive_all = "Canlı oyuncular {score}"
L.tooltip_finish_score_timelimit = "Süre doldu {score}"
L.tooltip_finish_score_dead_enemies = "Ölü düşmanlar {score}"
L.tooltip_kill_score = "Öldürme {score}"
L.tooltip_bodyfound_score = "Ceset bulundu {score}"

L.finish_score_win = "Kazanılan:"
L.finish_score_alive_teammates = "Canlı takım arkadaşları"
L.finish_score_alive_all = "Canlı oyuncular"
L.finish_score_timelimit = "Süre doldu"
L.finish_score_dead_enemies = "Ölü düşmanlar"
L.kill_score = "Öldürme"
L.bodyfound_score = "Ceset bulundu"

L.title_event_bodyfound = "Bir ceset bulundu"
L.title_event_c4_disarm = "Bir C4 devre dışı bırakıldı"
L.title_event_c4_explode = "Bir C4 patladı"
L.title_event_c4_plant = "Bir C4 kuruldu"
L.title_event_creditfound = "Ekipman kredileri bulundu"
L.title_event_finish = "Raunt sona erdi"
L.title_event_game = "Yeni bir raunt başladı"
L.title_event_kill = "Bir oyuncu öldürüldü"
L.title_event_respawn = "Bir oyuncu yeniden canlandı"
L.title_event_rolechange = "Bir oyuncu rolünü veya takımını değiştirdi"
L.title_event_selected = "Roller dağıtıldı"
L.title_event_spawn = "Bir oyuncu canlandı"

L.desc_event_bodyfound = "{finder} ({firole} {fiteam}), {found} ({forole} {foteam}) adlı kişinin cesedini buldu. Cesedin {credits} ekipman kredisi var."
L.desc_event_bodyfound_headshot = "Kurban kafadan vurularak öldürüldü."
L.desc_event_c4_disarm_success = "{disarmer} ({drole} {dteam}), {owner} ({orole} {oteam}) tarafından kurulan C4'ü başarıyla etkisiz hale getirdi."
L.desc_event_c4_disarm_failed = "{disarmer} ({drole} {dteam}), {owner} ({orole} {oteam}) tarafından kurulan C4'ü etkisiz hale getirmeye çalıştı. Başarısız oldular."
L.desc_event_c4_explode = "{owner} ({role} {team}) tarafından kurulan C4 patladı."
L.desc_event_c4_plant = "{owner} ({role} {team}), bir C4 patlayıcı kurdu."
L.desc_event_creditfound = "{finder} ({firole} {fiteam}), {found} ({forole} {foteam}) cesedinde {credits} ekipman kredisi buldu."
L.desc_event_finish = "Raunt {minutes}{seconds} sürdü. Sonunda {alive} oyuncu hayatta kaldı."
L.desc_event_game = "Yeni bir raunt başladı."
L.desc_event_respawn = "{player} yeniden canlandı."
L.desc_event_rolechange = "{player}, {orole} ({oteam}) olan rol takımını {nrole} ({nteam}) olarak değiştirdi."
L.desc_event_selected = "Takımlar ve roller tüm {amount} oyuncu için dağıtıldı."
L.desc_event_spawn = "{player} canlandı."

-- Name of a trap that killed us that has not been named by the mapper
L.trap_something = "bir şey"

-- Kill events
L.desc_event_kill_suicide = "Bir intihar vakası."
L.desc_event_kill_team = "Bu bir takım öldürmesiydi."

L.desc_event_kill_blowup = "{victim} ({vrole} {vteam}) kendini havaya uçurdu."
L.desc_event_kill_blowup_trap = "{victim} ({vrole} {vteam}), {trap} tarafından havaya uçuruldu."

L.desc_event_kill_tele_self = "{victim} ({vrole} {vteam}) kendilerini ışınlanarak öldürdüler."
L.desc_event_kill_sui = "{victim} ({vrole} {vteam}) bunu kaldıramadı ve kendini öldürdü."
L.desc_event_kill_sui_using = "{victim} ({vrole} {vteam}), {tool} kullanarak kendini öldürdü."

L.desc_event_kill_fall = "{victim} ({vrole} {vteam}) ölümüne düştü."
L.desc_event_kill_fall_pushed = "{victim} ({vrole} {vteam}, {attacker} onları ittikten sonra ölüme düştü."
L.desc_event_kill_fall_pushed_using = "{victim} ({vrole} {vteam}), {attacker} ({arole} {ateam}) onları itmek için {trap} kullandıktan sonra ölümüne düştü."

L.desc_event_kill_shot = "{victim} ({vrole} {vteam}), {attacker} tarafından vuruldu."
L.desc_event_kill_shot_using = "{victim} ({vrole} {vteam}), {attacker} ({arole} {ateam}) tarafından bir {weapon} kullanılarak vuruldu."

L.desc_event_kill_drown = "{victim} ({vrole} {vteam}), {attacker} tarafından boğuldu."
L.desc_event_kill_drown_using = "{victim} ({vrole} {vteam}), {attacker} ({arole} {ateam}) tarafından tetiklenen {trap} tarafından boğuldu."

L.desc_event_kill_boom = "{victim} ({vrole} {vteam}), {attacker} tarafından havaya uçuruldu."
L.desc_event_kill_boom_using = "{victim} ({vrole} {vteam}), {trap} kullanılarak {attacker} ({arole} {ateam}) tarafından havaya uçuruldu."

L.desc_event_kill_burn = "{victim} ({vrole} {vteam}) / {attacker} tarafından vuruldu."
L.desc_event_kill_burn_using = "{victim} ({vrole} {vteam}), {attacker} ({arole} {ateam}) nedeniyle {trap} tarafından yakıldı."

L.desc_event_kill_club = "{victim} ({vrole} {vteam}), {attacker} tarafından dövüldü."
L.desc_event_kill_club_using = "{victim} ({vrole} {vteam}), {trap} kullanılarak {attacker} ({arole} {ateam}) tarafından dövülerek öldürüldü."

L.desc_event_kill_slash = "{victim} ({vrole} {vteam}), {attacker} tarafından bıçaklandı."
L.desc_event_kill_slash_using = "{victim} ({vrole} {vteam}), {trap} kullanılarak {attacker} ({arole} {ateam}) tarafından havaya uçuruldu."

L.desc_event_kill_tele = "{victim} ({vrole} {vteam}), {attacker} tarafından ışınlanarak öldürüldü."
L.desc_event_kill_tele_using = "{victim} ({vrole} {vteam}), {attacker} ({arole} {ateam}) tarafından ayarlanan {trap} tarafından atomlarına ayrıldı."

L.desc_event_kill_goomba = "{victim} ({vrole} {vteam}), {attacker} ({arole} {ateam}) kendi cüssesiyle onu ezdi."

L.desc_event_kill_crush = "{victim} ({vrole} {vteam}), {attacker} tarafından ezildi."
L.desc_event_kill_crush_using = "{victim} ({vrole} {vteam}), {trap} aracılıyla {attacker} ({arole} {ateam}) tarafından ezildi."

L.desc_event_kill_other = "{victim} ({vrole} {vteam}), {attacker} tarafından öldürüldü."
L.desc_event_kill_other_using = "{victim} ({vrole} {vteam}), {trap} kullanılarak {attacker} ({arole} {ateam}) tarafından havaya uçuruldu."

-- 2021-04-20
L.none = "Rol Yok"

-- 2021-04-24
L.karma_teamkill_tooltip = "Öldürülen takım arkadaşı"
L.karma_teamhurt_tooltip = "Hasar verilen takım arkadaşı"
L.karma_enemykill_tooltip = "Öldürülen düşman"
L.karma_enemyhurt_tooltip = "Hasar verilen düşman"
L.karma_cleanround_tooltip = "Raundu Temizle"
L.karma_roundheal_tooltip = "Karma yenileme"
L.karma_unknown_tooltip = "Bilinmiyor"

-- 2021-05-07
L.header_random_shop_administration = "Rastgele Mağaza Ayarları"
L.header_random_shop_value_administration = "Bakiye Ayarları"

L.shopeditor_name_random_shops = "Rastgele mağazaları etkinleştir"
L.shopeditor_desc_random_shops = [[Rastgele mağazalar, her oyuncuya mevcut tüm ekipmanların sınırlı bir rastgele setini verir."
Takım mağazaları, aynı seti bireysel olanlar yerine bir takımdaki tüm oyunculara zorla verir."
Yeniden dağıtma, yeni bir rastgele ekipman seti almanızı sağlar.]]
L.shopeditor_name_random_shop_items = "Rastgele ekipman sayısı"
L.shopeditor_desc_random_shop_items = "Bu, her zaman mağazada mevcut olarak işaretlenmiş ekipmanları içerir. Bu yüzden yeterince yüksek bir sayı seç yoksa sadece onları alırsın."
L.shopeditor_name_random_team_shops = "Takım mağazalarını etkinleştir"
L.shopeditor_name_random_shop_reroll = "Mağaza yeniden dağıtım kullanılabilirliğini etkinleştir"
L.shopeditor_name_random_shop_reroll_cost = "Yeniden dağıtım başına maliyet"
L.shopeditor_name_random_shop_reroll_per_buy = "Satın aldıktan sonra otomatik olarak yeniden dağıt"

-- 2021-06-04
L.header_equipment_setup = "Ekipman Ayarları"
L.header_equipment_value_setup = "Bakiye Ayarları"

L.equipmenteditor_name_not_buyable = "Satın alınabilir"
L.equipmenteditor_desc_not_buyable = "Devre dışı bırakılırsa ekipman mağazada gösterilmez. Bu ekipmanın atandığı roller yine de onu alacaktır."
L.equipmenteditor_name_not_random = "Mağazada her zaman mevcuttur"
L.equipmenteditor_desc_not_random = "Etkinleştirilirse, ekipman her zaman mağazada mevcuttur. Rastgele mağaza etkinleştirildiğinde, mevcut bir rastgele yuva alır ve her zaman bu ekipman için ayırır."
L.equipmenteditor_name_global_limited = "Genel sınırlı miktar"
L.equipmenteditor_desc_global_limited = "Etkinleştirilirse, ekipman aktif rauntta sunucuda yalnızca bir kez satın alınabilir."
L.equipmenteditor_name_team_limited = "Takım sınırlı miktar"
L.equipmenteditor_desc_team_limited = "Etkinleştirilirse, ekipman aktif rauntta takım başına yalnızca bir kez satın alınabilir."
L.equipmenteditor_name_player_limited = "Oyuncu sınırlı miktarı"
L.equipmenteditor_desc_player_limited = "Etkinleştirilirse, ekipman aktif rauntta oyuncu başına yalnızca bir kez satın alınabilir."
L.equipmenteditor_name_min_players = "Satın almak için minimum oyuncu sayısı"
L.equipmenteditor_name_credits = "Kredi cinsinden fiyat"

-- 2021-06-08
L.equip_not_added = "eklenmedi"
L.equip_added = "eklendi"
L.equip_inherit_added = "eklendi (devralma)"
L.equip_inherit_removed = "kaldırıldı (devral)"

-- 2021-06-09
L.layering_not_layered = "Katmanlı değil"
L.layering_layer = "Katman {layer}"
L.header_rolelayering_role = "{role} dağıtımı"
L.header_rolelayering_baserole = "Temel rol dağıtma"
L.submenu_roles_rolelayering_title = "Rol Dağıtma"
L.header_rolelayering_info = "Rol dağıtma bilgileri"
L.help_rolelayering_roleselection = [[
Rol dağılım süreci iki aşamaya ayrılmıştır. İlk aşamada masum, hain ve aşağıdaki 'temel rol dağıtımı' kutusunda listelenen temel roller dağıtılır. İkinci aşama, bu temel rolleri bir alt role yükseltmek için kullanılır.

Daha fazla ayrıntıyı genel bakış sekmesinde bulabilirsiniz.]]
L.help_rolelayering_layers = [[
Role özgü değişkenlere göre atanabilir roller belirlendikten sonra (rastgele seçilme şansı da dahil!), dağıtım için her katmandan bir rol (varsa) seçilir. Katmanlar işlendikten sonra katmanlanmamış roller rastgele seçilir. Doldurulması gereken yuva kalmadığı anda rol seçimi durdurulur.

Convar ile ilgili gereksinimler nedeniyle dikkate alınmayan roller dağıtılmaz.]]
L.scoreboard_voice_tooltip = "Ses seviyesini değiştirmek için kaydırın"

-- 2021-06-15
L.header_shop_linker = "Ayarlar"
L.label_shop_linker_set = "Mağaza türünü seçin"

-- 2021-06-18
L.xfer_team_indicator = "Takım"

-- 2021-06-25
L.searchbar_default_placeholder = "Listede ara..."

-- 2021-07-11
L.spec_about_to_revive = "İzleme, canlanma sırasında sınırlıdır."

-- 2021-09-01
L.spawneditor_name = "Oluşum Düzenleyici Aracı"
L.spawneditor_desc = "Dünyaya silah, cephane ve oyuncu canlanma noktası yerleştirmek için kullanılır. Yalnızca süper yönetici tarafından kullanılabilir."

L.spawneditor_place = "Oluşum noktasını yerleştir"
L.spawneditor_remove = "Oluşum noktasını kaldır"
L.spawneditor_change = "Oluşum noktası türünü değiştirin (geri almak için [SHIFT] tuşunu basılı tutun)"
L.spawneditor_ammo_edit = "Otomatik ortaya çıkan cephaneyi düzenlemek için silahın ortaya çıkmasını bekle"

L.spawn_weapon_random = "Rastgele Silah Oluşum Noktası"
L.spawn_weapon_melee = "Yakın Dövüş Silahı Oluşum Noktası"
L.spawn_weapon_nade = "Bomba Oluşum Noktası"
L.spawn_weapon_shotgun = "Pompalı Oluşum Noktası"
L.spawn_weapon_heavy = "Ağır Silah Oluşum Noktası"
L.spawn_weapon_sniper = "Keskin Nişancı Silahı Oluşum Noktası"
L.spawn_weapon_pistol = "Tabanca Silahı Oluşum Noktası"
L.spawn_weapon_special = "Özel Silah Oluşum Noktası"
L.spawn_ammo_random = "Rastgele Cephane Oluşum Noktası"
L.spawn_ammo_deagle = "Deagle Cephanesi Oluşum Noktası"
L.spawn_ammo_pistol = "Tabanca Cephanesi Oluşum Noktası"
L.spawn_ammo_mac10 = "Mac10 Cephanesi Oluşum Noktası"
L.spawn_ammo_rifle = "Tüfek Cephanesi Oluşum Noktası"
L.spawn_ammo_shotgun = "Pompalı Cephanesi Oluşum Noktası"
L.spawn_player_random = "Rastgele Oyuncu Canlanma Noktası"

L.spawn_weapon_ammo = "(Cephane {ammo})"

L.spawn_weapon_edit_ammo = "Bu silahın oluşum noktasında cephaneyi artırmak veya azaltmak için [{walkkey}] tuşunu basılı tutun ve [{primaryfire} veya {secondaryfire}] tuşuna basın"

L.spawn_type_weapon = "Bu bir silah oluşum noktasıdır"
L.spawn_type_ammo = "Bu bir cephane oluşum noktasıdır"
L.spawn_type_player = "Bu bir oyuncu canlanma noktasıdır"

L.spawn_remove = "Bu oluşum noktasını kaldırmak için [{secondaryfire}] tuşuna basın"

L.submenu_administration_entspawn_title = "Oluşum Noktası Düzenleyici"
L.header_entspawn_settings = "Oluşum Noktası Düzenleyici Ayarları"
L.button_start_entspawn_edit = "Oluşum Noktası Düzenlemesini Başlat"
L.button_delete_all_spawns = "Tüm Oluşum Noktalarını Sil"

L.label_dynamic_spawns_enable = "Bu harita için dinamik oluşum noktalarını etkinleştir"
L.label_dynamic_spawns_global_enable = "Tüm haritalar için dinamik oluşum noktalarını etkinleştir"

L.header_equipment_weapon_spawn_setup = "Silah Oluşum Ayarları"

L.help_spawn_editor_info = [[
Oluşum noktası düzenleyicisi, dünyadaki oluşum noktalarını yerleştirmek, kaldırmak ve düzenlemek için kullanılır. Bu oluşum noktaları silahlar, cephaneler ve oyuncular içindir.

Bu oluşum noktaları, 'datatttweaponspawnscripts' içinde bulunan dosyalara kaydedilir. Donanım sıfırlaması için silinebilirler. İlk oluşum noktası dosyaları, haritada ve orijinal TTT silah oluşum noktası komut dosyalarında bulunan oluşum noktalarından oluşturulur. Sıfırlama düğmesine basıldığında her zaman başlangıç durumuna geri dönülür.

Bu oluşum noktası sisteminin dinamik oluşumları kullandığı unutulmamalıdır. Bu, silahlar için en ilginç olanıdır, çünkü artık belirli bir silahı değil, bir tür silahı tanımlar. Örneğin, bir TTT pompalı oluşum noktası yerine, artık pompalı olarak tanımlanan herhangi bir silahın çıkabileceği genel bir pompalı oluşum noktası var. Her silah için oluşum türü 'Ekipmanı Düzenle' menüsünden ayarlanabilir. Bu, herhangi bir silahın haritada ortaya çıkmasını veya belirli varsayılan silahları devre dışı bırakmasını mümkün kılar.

Birçok değişikliğin ancak yeni bir raunt başladıktan sonra yürürlüğe gireceğini unutmayın.]]
L.help_spawn_editor_enable = "Bazı haritalarda, haritada bulunan orijinal oluşum noktalarının dinamik sistemle değiştirilmeden kullanılması önerilebilir. Aşağıdaki bu seçeneğin değiştirilmesi yalnızca şu anda etkin olan haritayı etkiler, bu nedenle dinamik sistem diğer tüm haritalar için kullanılmaya devam edecektir."
L.help_spawn_editor_hint = "İpucu oluşum düzenleyicisinden çıkmak için oyun modu menüsünü yeniden açın."
L.help_spawn_editor_spawn_amount = [[
Şu anda bu haritada {weapon} silah oluşumu, {ammo} cephane oluşumu ve {player} oyuncu canlanma noktaları var.
Bu miktarı değiştirmek için 'ON düzenlemesini başlat'a tıklayın.

{weaponrandom}x Rastgele Silah Oluşumu
{weaponmelee}x Yakın Dövüş Silahı Oluşumu
{weaponnade}x El Bombası Oluşumu
{weaponshotgun}x Pompalı Silahı Oluşumu
{weaponheavy}x Ağır Silah Oluşumu
{weaponsniper}x Keskin Nişancı Oluşumu
{weaponpistol}x Tabanca Oluşumu
{weaponspecial}x Özel Silah Oluşumu

{ammorandom}x Rastgele Cephane Oluşumu
{ammodeagle}x Deagle Cephane Oluşumu
{ammopistol}x Tabanca Cephane Oluşumu
{ammomac10}x Mac10 Cephane Oluşumu
{ammorifle}x Tüfek Cephane Oluşumu
{ammoshotgun}x Pompalı Cephane Oluşumu

{playerrandom}x Rastgele Oyuncu Canlanması]]

L.equipmenteditor_name_auto_spawnable = "Ekipman dünyada rastgele ortaya çıkar"
L.equipmenteditor_name_spawn_type = "Canlanma türünü seçin"
L.equipmenteditor_desc_auto_spawnable = [[
TTT2 oluşum noktası sistemi, dünyadaki her silahın çıkmasına izin verir. Varsayılan olarak, yalnızca yaratıcı tarafından 'Otomatik Çıkabilir' olarak işaretlenen silahlar dünyada ortaya çıkacaktır, ancak bu menüden değiştirilebilir.

Ekipmanın çoğu, varsayılan olarak 'özel silahların ortaya çıkmasına' ayarlanmıştır. Bu, ekipmanın yalnızca rastgele silah oluşumlarında ortaya çıktığı anlamına gelir. Bununla birlikte, mevcut diğer oluşum türlerini kullanmak için dünyaya özel silah oluşum noktaları yerleştirmek veya burada oluşum noktası türünü değiştirmek mümkündür.]]

L.pickup_error_inv_cached = "Envanteriniz önbelleğe alındığı için şu anda bunu alamazsınız."

-- 2021-09-02
L.submenu_administration_playermodels_title = "Oyuncu Modelleri"
L.header_playermodels_general = "Genel Oyuncu Modeli Ayarları"
L.header_playermodels_selection = "Oyuncu Modeli Havuzunu Seçin"

L.label_enforce_playermodel = "Rol oyuncu modelini uygula"
L.label_use_custom_models = "Rastgele seçilen bir oyuncu modeli kullan"
L.label_prefer_map_models = "Varsayılan modeller yerine haritaya özgü modelleri tercih edin"
L.label_select_model_per_round = "Her rauntta yeni bir rastgele model seçin (devre dışı bırakılmışsa yalnızca harita değişikliğinde)"
L.label_select_unique_model_per_round = "Her oyuncu için rastgele bir özel model seç"

L.help_prefer_map_models = [[
Bazı haritalar kendi oyuncu modellerini tanımlar. Varsayılan olarak, bu modeller otomatik olarak atananlardan daha yüksek bir önceliğe sahiptir. Bu ayar devre dışı bırakıldığında, haritaya özgü modeller devre dışı bırakılır.

Role özgü modeller her zaman daha yüksek önceliğe sahiptir ve bu ayardan etkilenmez.]]
L.help_enforce_playermodel = [[
Bazı rollerin özel oyuncu modelleri vardır. Bazı oyuncu modeli seçicileriyle uyumluluk için uygun olabilecek şekilde devre dışı bırakılabilirler.
Bu ayar devre dışı bırakılırsa, rastgele varsayılan modeller yine de seçilebilir.]]
L.help_use_custom_models = [[
Varsayılan olarak tüm oyunculara yalnızca CSS Phoenix oyuncu modeli atanır. Ancak bu seçeneği etkinleştirerek bir oyuncu modeli havuzu seçmek mümkündür. Bu ayar etkinleştirildiğinde, her oyuncuya yine aynı oyuncu modeli atanacaktır, ancak tanımlanan model havuzundan rastgele bir modeldir.

Model seçimleri daha fazla oyuncu modeli yükleyerek genişletilebilir.]]

-- 2021-10-06
L.menu_server_addons_title = "Sunucu Eklentileri"
L.menu_server_addons_description = "Sunucu genelinde yalnızca eklentiler için yönetici ayarları."

L.tooltip_finish_score_penalty_alive_teammates = "Canlı takım arkadaşlarının cezası {score}"
L.finish_score_penalty_alive_teammates = "Canlı takım arkadaşlarının cezası"
L.tooltip_kill_score_suicide = "İntihar {score}"
L.kill_score_suicide = "İntihar"
L.tooltip_kill_score_team = "Takım arkadaşı öldürme {score}"
L.kill_score_team = "Takım arkadaşı öldürme"

-- 2021-10-09
L.help_models_select = [[
Oyuncu modeli havuzuna eklemek için modellere sol tıklayın. Kaldırmak için tekrar sol tıklayın. Odaklanan model için etkin ve devre dışı dedektif şapkaları arasında sağ tıklama geçiş yapar.

Sol üstteki küçük gösterge, oyuncu modelinin bir kafa vuruş kutusuna sahip olup olmadığını gösterir. Aşağıdaki simge, bu modelin bir dedektif şapkası için geçerli olup olmadığını gösterir.]]

L.menu_roles_title = "Rol Ayarları"
L.menu_roles_description = "Oluşum noktalarını, ekipman kredilerini ve daha fazlasını ayarla."

L.submenu_roles_roles_general_title = "Genel Rol Ayarları"

L.header_roles_info = "Rol Bilgileri"
L.header_roles_selection = "Rol Seçim Parametreleri"
L.header_roles_tbuttons = "Hain Düğmelerine Erişim"
L.header_roles_credits = "Rol Ekipmanı Kredileri"
L.header_roles_additional = "Ek Rol Ayarları"
L.header_roles_reward_credits = "Ödül Ekipmanı Kredileri"

L.help_roles_default_team = "Varsayılan takım {team}"
L.help_roles_unselectable = "Bu rol dağıtılamaz. Rol dağılım sürecinde dikkate alınmaz. Çoğu zaman bu, bunun bir canlanma, bir yardımcı deagle veya benzeri bir olay aracılığıyla raunt sırasında manuel olarak atanan bir rol olduğu anlamına gelir."
L.help_roles_selectable = "Bu rol dağıtılabilir. Tüm kriterlerin karşılanması durumunda bu rol, rol dağılımı sürecinde dikkate alınır."
L.help_roles_credits = "Ekipman kredileri, mağazadan ekipman satın almak için kullanılır. Onlara yalnızca mağazalara erişimi olan roller için vermek çoğunlukla mantıklıdır. Bununla birlikte, cesetler üzerinde kredi bulmak mümkün olduğundan, katillerine ödül olarak rollere başlangıç kredisi de verebilirsiniz."
L.help_roles_selection_short = "Oyuncu başına rol dağılımı, bu role atanan oyuncuların yüzdesini tanımlar. Örneğin, değer '0.2' olarak ayarlanırsa, her beşinci oyuncu bu rolü alır."
L.help_roles_selection = [[
Oyuncu başına rol dağılımı, bu role atanan oyuncuların yüzdesini tanımlar. Örneğin, değer '0.2' olarak ayarlanırsa, her beşinci oyuncu bu rolü alır. Bu aynı zamanda bu rolün dağıtılması için en az 5 oyuncunun gerekli olduğu anlamına gelir.
Tüm bunların yalnızca rolün dağıtım süreci için dikkate alınması durumunda geçerli olduğunu unutmayın.

Söz konusu rol dağılımı, oyuncuların alt sınırı ile özel bir entegrasyona sahiptir. Rol dağıtım için düşünülürse ve minimum değer dağıtım faktörünün verdiği değerin altındaysa, ancak oyuncu miktarı alt sınıra eşit veya daha büyükse, tek bir oyuncu yine de bu rolü alabilir. Dağıtım süreci daha sonra ikinci oyuncu için her zamanki gibi çalışır.]]
L.help_roles_award_info = "Bazı roller (kredi ayarlarında etkinleştirilmişse), düşmanların belirli bir yüzdesi öldüğünde ekipman kredisi alır. İlgili değerler burada düzeltilebilir."
L.help_roles_award_pct = "Düşmanların bu yüzdesi öldüğünde, belirli rollere ekipman kredisi verilir."
L.help_roles_award_repeat = "Kredi ödülünün birden çok kez verilip verilmediği. Örneğin, yüzde '0.25' olarak ayarlanırsa ve bu ayar etkinleştirilirse, oyunculara sırasıyla '%25', '%50' ve '%75' ölü düşmanlarda kredi verilecektir."
L.help_roles_advanced_warning = "UYARI Bunlar, rol dağıtım sürecini tamamen bozabilecek gelişmiş ayarlardır. Şüpheye düştüğünüzde tüm değerleri '0' da tutun. Bu değer, herhangi bir sınır uygulanmadığı ve rol dağılımının mümkün olduğunca çok rol atamaya çalışacağı anlamına gelir."
L.help_roles_max_roles = [[
Buradaki roller terimi hem temel rolleri hem de alt rolleri içerir. Varsayılan olarak, kaç farklı rolün atanabileceği konusunda bir sınır yoktur. Ancak, bunları sınırlamanın iki farklı yolu vardır.

1. Sabit bir miktarla sınırlayın.
2. Onları bir yüzde ile sınırlayın.

İkincisi, yalnızca sabit miktar '0' ise ve mevcut oyuncuların ayarlanan yüzdesine göre bir üst sınır belirlerse kullanılır.]]
L.help_roles_max_baseroles = [[
Temel roller yalnızca başkalarının devraldığı rollerdir. Örneğin, Masum rolü temel bir roldür, Firavun ise bu rolün bir alt rolüdür. Varsayılan olarak, kaç farklı rolün atanabileceği konusunda bir sınır yoktur. Ancak, bunları sınırlamanın iki farklı yolu vardır.

1. Sabit bir miktarla sınırlayın.
2. Onları bir yüzde ile sınırlayın.

İkincisi, yalnızca sabit miktar '0' ise ve mevcut oyuncuların ayarlanan yüzdesine göre bir üst sınır belirlerse kullanılır.]]

L.label_roles_enabled = "Rolü etkinleştir"
L.label_roles_min_inno_pct = "Oyuncu başına masum dağılımı"
L.label_roles_pct = "Oyuncu başına rol dağılımı"
L.label_roles_max = "Bu rol için atanan oyuncuların üst sınırı"
L.label_roles_random = "Bu rolün dağıtılma şansı"
L.label_roles_min_players = "Dağıtımı göz önünde bulundurmak için oyuncuların alt sınırı"
L.label_roles_tbutton = "Rol, Hain düğmelerini kullanabilir"
L.label_roles_credits_starting = "Başlangıç kredileri"
L.label_roles_credits_award_pct = "Kredi ödül yüzdesi"
L.label_roles_credits_award_size = "Kredi ödülü boyutu"
L.label_roles_credits_award_repeat = "Kredi ödülü tekrarı"
L.label_roles_newroles_enabled = "Özel rolleri etkinleştir"
L.label_roles_max_roles = "Üst rol sınırı"
L.label_roles_max_roles_pct = "Yüzde olarak üst rol sınırı"
L.label_roles_max_baseroles = "Üst temel rol sınırı"
L.label_roles_max_baseroles_pct = "Yüzde olarak üst temel rol sınırı"
L.label_detective_hats = "Dedektif gibi polislik rolleri için şapkaları etkinleştir (oyuncu modeli izin veriyorsa)"

L.ttt2_desc_innocent = "Bir Masum, hiçbir özel yeteneğe sahip değildir. Teröristler arasında kötüleri bulup öldürmek zorundalar. Ayrıca takım arkadaşlarını öldürmemeye dikkat etmek zorundalar."
L.ttt2_desc_traitor = "Hain, Masumların düşmanıdır. Özel ekipman satın alabilecekleri bir ekipman menüsü vardır. Takım arkadaşları hariç herkesi öldürmek zorundalar."
L.ttt2_desc_detective = "Masumların güvenebileceği kişi Dedektiftir. Kudretli Dedektif tüm kötü teröristleri bulmak zorundadır. Mağazalarındaki ekipmanlar bu görevde onlara yardımcı olabilir."

-- 2021-10-10
L.button_reset_models = "Oyuncu Modellerini Sıfırla"

-- 2021-10-13
L.help_roles_credits_award_kill = "Kredi kazanmanın bir başka yolu da Dedektif gibi 'herkese açık bir rolü' olan yüksek değerli oyuncuları öldürmektir. Eğer katilin rolü bunu etkinleştirdiyse, aşağıda tanımlanan miktarda kredi kazanır."
L.help_roles_credits_award = [[
Temel TTT2'de kredi almanın iki farklı yolu vardır

1. Düşman takımın belirli bir yüzdesi ölmüşse, tüm takıma kredi verilir.
2. Bir oyuncu, Dedektif gibi 'herkese açık bir role' sahip yüksek değerli bir oyuncuyu öldürdüyse, katile kredi verilir.

Tüm takım ödüllendirilse bile bunun yine de her rol için etkinleştirilebileceğini lütfen unutmayın. Örneğin, Masum takımı ödüllendirilirse, ancak Masum rolünün bu özelliği devre dışı bırakılmışsa, kredilerini yalnızca Dedektif alacaktır.
Bu özelliğin dengeleme değerleri 'Yönetim' - 'Genel Rol Ayarları' bölümünden ayarlanabilir.]]
L.help_detective_hats = [[
Dedektif gibi polislik rolleri, yetkilerini göstermek için şapka takabilir. Onları öldüklerinde veya kafadan hasar gördüklerinde kaybederler.

Bazı oyuncu modelleri varsayılan olarak şapkaları desteklemez. Bu, 'Yönetim' - 'Oyuncu Modelleri' bölümünden değiştirilebilir]]

L.label_roles_credits_award_kill = "Öldürme için kredi ödülü"
L.label_roles_credits_dead_award = "Ölü düşmanların belirli bir yüzdesi için kredi ödülünü etkinleştir"
L.label_roles_credits_kill_award = "Yüksek değerli oyuncu öldürme için kredi ödülünü etkinleştir"
L.label_roles_min_karma = "Dağılımı göz önünde bulundurmak için Karma'nın alt sınırı"

-- 2021-11-07
L.submenu_administration_administration_title = "Yönetim"
L.submenu_administration_voicechat_title = "Sesli sohbet Metin sohbeti"
L.submenu_administration_round_setup_title = "Raunt Ayarları"
L.submenu_administration_mapentities_title = "Harita Varlıkları"
L.submenu_administration_inventory_title = "Envanter"
L.submenu_administration_karma_title = "Karma"
L.submenu_administration_sprint_title = "Koşma"
L.submenu_administration_playersettings_title = "Oyuncu Ayarları"

L.header_roles_special_settings = "Özel Rol Ayarları"
L.header_equipment_additional = "Ek Ekipman Ayarları"
L.header_administration_general = "Genel Yönetim Ayarları"
L.header_administration_logging = "Günlük Kaydı"
L.header_administration_misc = "Diğer"
L.header_entspawn_plyspawn = "Oyuncu Canlanma Ayarları"
L.header_voicechat_general = "Genel Sesli Sohbet Ayarları"
L.header_voicechat_battery = "Sesli Sohbet Pili"
L.header_voicechat_locational = "Sesli Sohbet Mesafesi"
L.header_playersettings_plyspawn = "Oyuncu Canlanma Ayarları"
L.header_round_setup_prep = "Raunt Hazırlığı"
L.header_round_setup_round = "Raunt Aktif"
L.header_round_setup_post = "Raunt Sonu"
L.header_round_setup_map_duration = "Harita Oturumu"
L.header_textchat = "Metin sohbeti"
L.header_round_dead_players = "Ölü Oyuncu Ayarları"
L.header_administration_scoreboard = "Puan Tablosu Ayarları"
L.header_hud_toggleable = "Değiştirilebilir Arayüz Öğeleri"
L.header_mapentities_prop_possession = "Nesne Kontrolü"
L.header_mapentities_doors = "Kapılar"
L.header_karma_tweaking = "Karma Düzenlemesi"
L.header_karma_kick = "Sunucudan Atma ve Yasaklama Karması"
L.header_karma_logging = "Karma Günlüğü"
L.header_inventory_gernal = "Envanter Boyutu"
L.header_inventory_pickup = "Envanter Silah Toplama"
L.header_sprint_general = "Koşma Ayarları"
L.header_playersettings_armor = "Zırh Sistemi Ayarları"

L.help_killer_dna_range = "Bir oyuncu başka bir oyuncu tarafından öldürüldüğünde, cesedinde bir DNA örneği kalır. Aşağıdaki ayar, bırakılacak DNA numuneleri için hammer ünitelerindeki maksimum mesafeyi tanımlar. Kurban öldüğünde katil bu değerden daha uzaktaysa, ceset üzerinde hiçbir örnek kalmayacaktır."
L.help_killer_dna_basetime = "Katil 0 hammer birimi uzaktaysa, bir DNA örneği bozulana kadar saniye cinsinden baz süre. Katil ne kadar uzaktaysa, DNA örneğinin çürümesi için o kadar az zaman verilecektir."
L.help_dna_radar = "TTT2 DNA tarayıcısı, varsa seçilen DNA örneğinin tam mesafesini ve yönünü gösterir. Bununla birlikte, bekleme süresi her geçtiğinde seçilen numuneyi bir dünya içi render ile güncelleyen klasik bir DNA tarayıcı modu da vardır."
L.help_idle = "Boşta modu, boşta kalan oyuncuları izleyici moduna zorlamak için kullanılır. Bu moddan çıkmak için 'oyun' menüsünde devre dışı bırakmaları gerekir."
L.help_namechange_kick = [[
Aktif bir raunt sırasında isim değişikliği kötüye kullanılabilir. Bu nedenle, bu varsayılan olarak yasaktır ve suç işleyen oyuncunun sunucudan atılmasına neden olacaktır.

Yasaklama süresi 0'dan büyükse, oyuncu bu süre geçene kadar sunucuya yeniden bağlanamaz.]]
L.help_damage_log = "Bir oyuncu her hasar aldığında, etkinleştirilirse konsola bir hasar kaydı girişi eklenir. Bu, bir raunt sona erdikten sonra da diske kaydedilebilir. Dosya 'dataterrortownlogs' adresinde bulunur"
L.help_spawn_waves = [[
Bu değişken 0 olarak ayarlanırsa, tüm oyuncular bir kerede ortaya çıkar. Çok sayıda oyuncuya sahip sunucular için, oyuncuları dalgalar halinde canlandırmak faydalı olabilir. Canlandırma dalgası aralığı, her bir canlanma dalgası arasındaki süredir. Bir canlanma dalgası, geçerli canlanma noktaları olduğu sürece her zaman çok sayıda oyuncu canlandırır.

Not: Hazırlama süresinin istenen miktarda canlanma dalgası için yeterince uzun olduğundan emin olun.]]
L.help_voicechat_battery = [[
Etkinleştirilmiş sesli sohbet pili ile sesli sohbet, pil şarjını azaltır. Bittiğinde, oyuncu sesli sohbeti kullanamaz ve şarj olmasını beklemek zorundadır. Bu, aşırı sesli sohbet kullanımını önlemeye yardımcı olabilir.

Not: 'Tik' bir oyun tikini ifade eder. Örneğin, tik hızı 66 olarak ayarlanırsa, saniyenin 166'sı olacaktır.]]
L.help_ply_spawn = "Oyuncu (yeniden) canlanışında kullanılan oyuncu ayarları."
L.help_haste_mode = [[
Hız modu, her ölü oyuncu ile raunt süresini artırarak oyunu dengeler. Yalnızca eylemsiz oyuncularda eksik olan roller gerçek raunt zamanını görebilir. Diğer tüm roller yalnızca hız modu başlangıç zamanını görebilir.

Hız modu etkinleştirilirse, sabit raunt süresi göz ardı edilir.]]
L.help_round_limit = "Ayarlanan sınır koşullarından biri karşılandıktan sonra, bir harita değişikliği tetiklenir."
L.help_armor_balancing = "Zırhı dengelemek için aşağıdaki değerler kullanılabilir."
L.help_item_armor_classic = "Klasik zırh modu etkinleştirilmişse, yalnızca önceki ayarlar önemlidir. Klasik zırh modu, bir oyuncunun bir turda yalnızca bir kez zırh satın alabileceği ve bu zırhın gelen mermi ve levye hasarının %30'unu ölene kadar bloke ettiği anlamına gelir."
L.help_item_armor_dynamic = [[
Dinamik zırh, zırhı daha ilginç hale getirmek için TTT2 yaklaşımıdır. Satın alınabilecek zırh miktarı artık sınırsızdır ve zırh değeri birikir. Hasar almak, zırh değerini azaltır. Satın alınan zırh öğesi başına zırh değeri, söz konusu öğenin 'Ekipman Ayarları'nda ayarlanır.

Hasar alırken, bu hasarın belirli bir yüzdesi zırh hasarına dönüştürülür, oyuncuya hala farklı bir yüzde uygulanır ve geri kalanı kaybolur.

Güçlendirilmiş zırh etkinleştirilirse, zırh değeri takviye eşiğinin üzerinde olduğu sürece oyuncuya uygulanan hasar %15 azaltılır.]]
L.help_sherlock_mode = "Sherlock modu klasik TTT modudur. Sherlock modu devre dışı bırakılırsa, cesetler onaylanamaz, puan tablosu herkesi canlı olarak gösterir ve izleyiciler yaşayan oyuncularla konuşabilir."
L.help_prop_possession = [[
Nesne kontrolü, izleyiciler tarafından dünyada bulunan nesneleri kontrol etmek için kullanılabilir ve söz konusu nesneyi hareket ettirmek için yavaş şarj olan 'güç ölçeri' kullanılabilir.

'Güç Ölçeri'nin maksimum değeri, tanımlanmış iki sınır arasına sıkıştırılmış ölüm farkının eklendiği bir topa sahip olma temel değerinden oluşur. Sayaç zamanla yavaş yavaş şarj olur. Ayarlanan şarj süresi, 'güç ölçerde' tek bir noktayı şarj etmek için gereken süredir.]]
L.help_karma = "Oyuncular belirli miktarda Karma ile başlar ve takım arkadaşlarına zarar verdiklerinde kaybederler. Kaybettikleri miktar, hasar verdikleri veya öldürdükleri kişinin Karmasına bağlıdır. Düşük Karma, verilen hasarı azaltır."
L.help_karma_strict = "Katı Karma etkinleştirilirse, Karma düştükçe hasar cezası daha hızlı artar. Kapalı olduğunda, insanlar 800'ün üzerinde kaldığında hasar cezası çok düşüktür. Katı modu etkinleştirmek, Karma'nın gereksiz öldürmeleri caydırmada daha büyük bir rol oynamasını sağlarken, onu devre dışı bırakmak, Karma'nın yalnızca takım arkadaşlarını sürekli olarak öldüren oyunculara zarar verdiği daha \"gevşek\" bir oyunla sonuçlanır."
L.help_karma_max = "Maks. Karmanın değerini 1000'in üzerine ayarlamak, 1000'den fazla Karmaya sahip oyunculara hasar bonusu vermez. Karma sınırı olarak kullanılabilir."
L.help_karma_ratio = "Her ikisi de aynı takımdaysa, kurbanın Karmasının ne kadarının saldırgandan çıkarıldığını hesaplamak için kullanılan hasarın oranıdır. Bir takım öldürme gerçekleşirse, başka bir ceza uygulanır."
L.help_karma_traitordmg_ratio = "Her ikisi de farklı takımlarda ise, kurbanın Karmasının ne kadarının saldırgana eklendiğini hesaplamak için kullanılan hasarın oranı. Eğer bir düşman öldürülürse, bir bonus daha uygulanır."
L.help_karma_bonus = "Bir rauntta Karma kazanmanın iki farklı pasif yolu da vardır. Birincisi, raunt sonundaki her oyuncuya uygulanan bir karma restorasyonudur. Hiçbir takım arkadaşı bir oyuncu tarafından yaralanmamış veya öldürülmemişse, ikincil bir temiz raunt bonusu verilir."
L.help_karma_clean_half = [[
Bir oyuncunun Karması başlangıç seviyesinin üzerinde olduğunda (yani maksimum Karma bundan daha yüksek olacak şekilde yapılandırıldığında), tüm Karma artışları, Karmalarının başlangıç seviyesinin ne kadar üzerinde olduğuna bağlı olarak azaltılacaktır. Yani ne kadar yüksek olursa o kadar yavaş yükselir.

Bu azalma, başlangıçta hızlı olan üstel bir bozunma eğrisine girer ve artış küçüldükçe yavaşlar. Bu konvar, bonusun hangi noktada yarıya indirildiğini (yani yarılanma ömrünü) belirler. Varsayılan değer 0.25 ile, Karma'nın başlangıç miktarı 1000 ve maksimum 1500 ise ve bir oyuncu Karma 1125'e ((1500 - 1000) 0.25 = 125) sahipse, temiz raunt bonusu 30 2 = 15 olacaktır. Böylece bonusu daha hızlı düşürmek için bu konvarı düşürürsünüz, daha yavaş düşürmek için 1'e yükseltirsiniz.]]
L.help_max_slots = "Yuva başına maksimum silah miktarını ayarlar. '-1', sınır olmadığı anlamına gelir."
L.help_item_armor_value = "Dinamik modda zırh ögesinin verdiği zırh değeridir. Klasik mod etkinleştirilirse (bkz. 'Yönetim' - 'Oyuncu Ayarları'), 0'dan büyük her değer mevcut zırh olarak sayılır."

L.label_killer_dna_range = "DNA bırakmak için maksimum öldürme aralığı"
L.label_killer_dna_basetime = "Numune ömrü baz süresi"
L.label_dna_scanner_slots = "DNA numune yuvaları"
L.label_dna_radar = "Klasik DNA tarayıcı modunu etkinleştir"
L.label_dna_radar_cooldown = "DNA tarayıcı bekleme süresi"
L.label_radar_charge_time = "Kullanıldıktan sonra şarj süresi"
L.label_crowbar_shove_delay = "Levye itme işleminden sonra bekleme süresi"
L.label_idle = "Boşta modunu etkinleştir"
L.label_idle_limit = "Saniye cinsinden maksimum boşta kalma süresi"
L.label_namechange_kick = "İsim değiştirildiğinde atmayı etkinleştir"
L.label_namechange_bantime = "Attıktan sonra dakika cinsinden yasaklanan süre"
L.label_log_damage_for_console = "Konsolda hasar günlüğünü etkinleştir"
L.label_damagelog_save = "Hasar kaydını diske kaydet"
L.label_debug_preventwin = "Herhangi bir kazanma koşulunu önleyin [debug]"
L.label_bots_are_spectators = "Botlar her zaman izleyicidir"
L.label_tbutton_admin_show = "Hain düğmelerini yöneticilere göster"
L.label_ragdoll_carrying = "Ceset taşımayı etkinleştir"
L.label_prop_throwing = "Nesne fırlatmayı etkinleştir"
L.label_weapon_carrying = "Silah taşımayı etkinleştir"
L.label_weapon_carrying_range = "Silah taşıma menzili"
L.label_prop_carrying_force = "Nesne kaldırma gücü"
L.label_teleport_telefrags = "Işınlanırken engelleyen oyuncuları öldür"
L.label_allow_discomb_jump = "Bomba atıcı için disko sıçramasına izin ver"
L.label_spawn_wave_interval = "Saniye cinsinden canlanma aralığı"
L.label_voice_enable = "Sesli sohbeti etkinleştir"
L.label_voice_drain = "Sesli sohbet pil özelliğini etkinleştir"
L.label_voice_drain_normal = "Normal oyuncular için tik başına azalma"
L.label_voice_drain_admin = "Yöneticiler ve genel polislik rolleri için tik başına azalma"
L.label_voice_drain_recharge = "Sesli sohbet etmeme işareti başına şarj oranı"
L.label_locational_voice = "Canlı oyuncular için yakın sesli sohbeti etkinleştir"
L.label_locational_voice_prep = "Hazırlanma sürecinde konumsal ses sohbetini etkinleştir"
L.label_locational_voice_range = "Konumsal ses sohbetinin uzaklık oranı"
L.label_armor_on_spawn = "(Yeniden) canlanmada oyuncu zırhı"
L.label_prep_respawn = "Hazırlık aşamasında anında yeniden canlanmayı etkinleştir"
L.label_preptime_seconds = "Saniye cinsinden hazırlık süresi"
L.label_firstpreptime_seconds = "Saniye cinsinden ilk hazırlık süresi"
L.label_roundtime_minutes = "Dakika cinsinden sabit raunt süresi"
L.label_haste = "Hız modunu etkinleştir"
L.label_haste_starting_minutes = "Dakika cinsinden hızlı mod başlangıç süresi"
L.label_haste_minutes_per_death = "Ölüm başına dakika cinsinden ek süre"
L.label_posttime_seconds = "Saniye cinsinden raunt sonu süresi"
L.label_round_limit = "Rauntların üst sınırı"
L.label_time_limit_minutes = "Oyun süresinin dakika cinsinden üst sınırı"
L.label_nade_throw_during_prep = "Hazırlık süresi boyunca bomba atmayı etkinleştir"
L.label_postround_dm = "Raunt bittikten sonra ölüm maçını etkinleştir"
L.label_spectator_chat = "İzleyicilerin herkesle sohbet etmesini sağla"
L.label_lastwords_chatprint = "Yazarken öldürülürse sohbete son kelimelerini yazdır"
L.label_identify_body_woconfirm = "'Onayla' düğmesine basmadan cesedi tanımla"
L.label_announce_body_found = "Bir ceset bulunduğunu duyurun"
L.label_confirm_killlist = "Onaylanmış cesedin ölüm listesini duyur"
L.label_dyingshot = "Gez ve arpacıkta ölürken ateş et [deneysel]"
L.label_armor_block_headshots = "Zırh engelleyici kafadan vuruşları etkinleştir"
L.label_armor_block_blastdmg = "Patlama hasarını engelleyen zırhı etkinleştir"
L.label_armor_dynamic = "Dinamik zırhı etkinleştir"
L.label_armor_value = "Zırh öğesi tarafından verilen zırh miktarı"
L.label_armor_damage_block_pct = "Zırhın aldığı hasar yüzdesi"
L.label_armor_damage_health_pct = "Oyuncunun aldığı hasar yüzdesi"
L.label_armor_enable_reinforced = "Güçlendirilmiş zırhı etkinleştir"
L.label_armor_threshold_for_reinforced = "Güçlendirilmiş zırh eşiği"
L.label_sherlock_mode = "Sherlock modunu etkinleştir"
L.label_highlight_admins = "Sunucu yöneticilerini vurgula"
L.label_highlight_dev = "TTT2 geliştiricisini vurgula"
L.label_highlight_vip = "TTT2 destekçisini vurgula"
L.label_highlight_addondev = "TTT2 eklenti geliştiricisini vurgula"
L.label_highlight_supporter = "Diğerlerini vurgula"
L.label_enable_hud_element = "{elem} arayüz öğesini etkinleştir"
L.label_spec_prop_control = "Nesne kontrolünü etkinleştir"
L.label_spec_prop_base = "Kontrol temel değeri"
L.label_spec_prop_maxpenalty = "Daha düşük kontrol bonusu limiti"
L.label_spec_prop_maxbonus = "Üst kontrole sahip olma bonus limiti"
L.label_spec_prop_force = "Kontrol itme kuvveti"
L.label_spec_prop_rechargetime = "Saniye cinsinden şarj süresi"
L.label_doors_force_pairs = "Yakın kapıları çift kapı olarak zorla"
L.label_doors_destructible = "Yok edilebilir kapıları etkinleştir"
L.label_doors_locked_indestructible = "Başlangıçta kilitli kapılar yok edilemez"
L.label_doors_health = "Kapı sağlığı"
L.label_doors_prop_health = "Yok edilen kapı sağlığı"
L.label_minimum_players = "Raunda başlamak için minimum oyuncu miktarı"
L.label_karma = "Karmayı Etkinleştir"
L.label_karma_strict = "Katı Karmayı etkinleştir"
L.label_karma_starting = "Başlangıç Karması"
L.label_karma_max = "Maksimum Karma"
L.label_karma_ratio = "Takım hasarı için ceza oranı"
L.label_karma_kill_penalty = "Takım öldürme için öldürme cezası"
L.label_karma_round_increment = "Karma restorasyonu"
L.label_karma_clean_bonus = "Temiz raunt bonusu"
L.label_karma_traitordmg_ratio = "Düşman hasarı için bonus oranı"
L.label_karma_traitorkill_bonus = "Düşman öldürme bonusu"
L.label_karma_clean_half = "Temiz raunt bonus azaltımı"
L.label_karma_persist = "Harita değişiklikleri üzerinde Karma devam etsin"
L.label_karma_low_autokick = "Karması düşük olan oyuncuları otomatik olarak tekmele"
L.label_karma_low_amount = "Düşük Karma eşiği"
L.label_karma_low_ban = "Düşük Karmaya sahip oyuncuları yasakla"
L.label_karma_low_ban_minutes = "Dakika cinsinden yasaklama süresi"
L.label_karma_debugspam = "Karma değişiklikleri hakkında konsol kurmak için hata ayıklama çıkışını etkinleştir"
L.label_max_melee_slots = "Maksimum yakın dövüş yuvası"
L.label_max_secondary_slots = "Maksimum ikincil yuva"
L.label_max_primary_slots = "Maksimum birincil yuva"
L.label_max_nade_slots = "Maksimum bomba yuvası"
L.label_max_carry_slots = "Maksimum taşıma yuvası"
L.label_max_unarmed_slots = "Maksimum silahsız yuva"
L.label_max_special_slots = "Maksimum özel yuva"
L.label_max_extra_slots = "Maksimum ekstra yuva"
L.label_weapon_autopickup = "Otomatik silah alımını etkinleştir"
L.label_sprint_enabled = "Koşmayı etkinleştir"
L.label_sprint_max = "Hız artırma faktörü"
L.label_sprint_stamina_consumption = "Enerji tüketim faktörü"
L.label_sprint_stamina_regeneration = "Enerji yenileme faktörü"
L.label_crowbar_unlocks = "Birincil saldırı etkileşim (yani kilit açma) olarak kullanılabilir"
L.label_crowbar_pushforce = "Levye itme kuvveti"

-- 2022-07-02
L.header_playersettings_falldmg = "Düşme Hasarı Ayarları"

L.label_falldmg_enable = "Düşme hasarını etkinleştir"
L.label_falldmg_min_velocity = "Düşme hasarının oluşması için minimum hız eşiği"
L.label_falldmg_exponent = "Hıza bağlı olarak düşme hasarını artıran üs"

L.help_falldmg_exponent = [[
Bu değer, oyuncunun yere çarpma hızı ile katlanarak düşme hasarının ne kadar arttığını değiştirir.

Bu değeri değiştirirken dikkatli olun. Çok yükseğe ayarlamak en küçük düşüşleri bile ölümcül hale getirebilirken, çok düşük ayarlamak oyuncuların aşırı yüksekliklerden düşmesine ve çok az hasar görmesine veya hiç hasar görmemesine izin verecektir.]]

-- 2023-02-08
L.testpopup_title = "Çok satırlı bir başlık içeren bir test açılır penceresi, ne GÜZEL!"
L.testpopup_subtitle = "Aa merhaba! Bu, bazı özel bilgiler içeren süslü bir açılır penceredir. Metin çok satırlı da olabilir, ne kadar süslü! Off, herhangi bir fikrim olsaydı çok daha fazla metin ekleyebilirdim..."

L.hudeditor_chat_hint1 = "[TTT2][BİLGİ] Bir öğenin üzerine gelin, [SOL TIK] tuşuna basın ve basılı tutun. TAŞIMAK veya YENİDEN BOYUTLANDIRMAK için fareyi hareket ettirin."
L.hudeditor_chat_hint2 = "[TTT2][BİLGİ] Simetrik yeniden boyutlandırma için ALT tuşuna basın ve basılı tutun."
L.hudeditor_chat_hint3 = "[TTT2][BİLGİ] Eksen üzerinde hareket etmek ve en boy oranını korumak için SHIFT tuşunu basılı tutun."
L.hudeditor_chat_hint4 = "[TTT2][BİLGİ] Arayüz Düzenleyiciden çıkmak için [SAĞ TIK] - 'Kapat'a bas!"

L.guide_nothing_title = "Henüz burada bir şey yok!"
L.guide_nothing_desc = "Bu devam eden bir çalışmadır. GitHub'daki projeye katkıda bulunarak bize yardımcı olun."

L.sb_rank_tooltip_developer = "TTT2 Geliştirici"
L.sb_rank_tooltip_vip = "TTT2 Destekçisi"
L.sb_rank_tooltip_addondev = "TTT2 Eklenti Geliştirici"
L.sb_rank_tooltip_admin = "Sunucu Yöneticisi"
L.sb_rank_tooltip_streamer = "Yayıncı"
L.sb_rank_tooltip_heroes = "TTT2 Kahramanları"
L.sb_rank_tooltip_team = "Takım"

L.tbut_adminarea = "YÖNETİCİ ALANI"

-- 2023-08-10
L.equipmenteditor_name_damage_scaling = "Hasar Boyutu"

-- 2023-08-11
L.equipmenteditor_name_allow_drop = "Bırakmaya İzin Ver"
L.equipmenteditor_desc_allow_drop = "Etkinleştirilirse, ekipman oyuncu tarafından serbestçe bırakılabilir."

L.equipmenteditor_name_drop_on_death_type = "Ölürken Bırak"
L.equipmenteditor_desc_drop_on_death_type = "Oyuncunun ölümü üzerine ekipmanın düşürülüp düşürülmediğine ilişkin eylemi geçersiz kılmaya çalışır."

L.drop_on_death_type_default = "Varsayılan (silah tanımlı)"
L.drop_on_death_type_force = "Ölürken Bırakmaya Zorla"
L.drop_on_death_type_deny = "Ölürken Bırakmayı Reddet"

-- 2023-08-26
L.equipmenteditor_name_kind = "Ekipman Yuvası"
L.equipmenteditor_desc_kind = "Ekipmanın olduğu envanter yuvası."

L.slot_weapon_melee = "Yakın Dövüş Yuvası"
L.slot_weapon_pistol = "Tabanca Yuvası"
L.slot_weapon_heavy = "Ağır Silah Yuvası"
L.slot_weapon_nade = "Bomba Yuvası"
L.slot_weapon_carry = "Taşıma Yuvası"
L.slot_weapon_unarmed = "Silahsız Yuva"
L.slot_weapon_special = "Özel Yuva"
L.slot_weapon_extra = "Ekstra Yuva"
L.slot_weapon_class = "Sınıf Yuvası"

-- 2023-10-04
L.label_voice_duck_spectator = "İzleyici seslerini azalt"
L.label_voice_duck_spectator_amount = "İzleyici seslerini azaltma miktarı"
L.label_voice_scaling = "Ses Seviyesi Ölçekleme Modu"
L.label_voice_scaling_mode_linear = "Doğrusal"
L.label_voice_scaling_mode_power4 = "Güç 4"
L.label_voice_scaling_mode_log = "Logaritmik"

-- 2023-10-07
L.search_title = "Ceset Arama Sonuçları - {player}"
L.search_info = "Bilgi"
L.search_confirm = "Ölümü Onayla"
L.search_confirm_credits = "+{credits} Krediyi Onayla"
L.search_take_credits = "{credits} Kredi Al"
L.search_confirm_forbidden = "Yasak Onayla"
L.search_confirmed = "Ölüm Onaylandı"
L.search_call = "Dedektifi Ara"
L.search_called = "Ölüm Bildirildi"

L.search_team_role_unknown = "???"

L.search_words = "İçinizden bir ses bu kişinin son sözlerinden bazılarının '{lastwords}' olduğunu söylüyor."
L.search_armor = "Standart olmayan vücut zırhı giyiyorlardı."
L.search_disguiser = "Kimliklerini saklamaya yarayan bir cihaz taşıyorlardı."
L.search_radar = "Bir çeşit radar taşıyorlardı. Artık çalışmıyor."
L.search_c4 = "Cebinde bir not buldun. Tel {num} kesmenin bombayı güvenli bir şekilde etkisiz hale getireceğini belirtiyor."

L.search_dmg_crush = "Kemiklerinin çoğu kırılmış. Ağır bir nesnenin çarpması onları öldürmüş gibi görünüyor."
L.search_dmg_bullet = "Vurularak öldürüldükleri belli."
L.search_dmg_fall = "Düşüp öldüler."
L.search_dmg_boom = "Yaraları ve yanmış kıyafetleri bir patlamanın sonlarına neden olduğunu gösteriyor."
L.search_dmg_club = "Ceset çürümüş ve hırpalanmış. Belli ki dövülerek öldürülmüşler."
L.search_dmg_drown = "Ceset boğulma belirtileri gösteriyor."
L.search_dmg_stab = "Kanamadan hızlı bir şekilde ölmeden önce bıçaklandılar ve kesildiler."
L.search_dmg_burn = "Buralar kızartılmış terörist gibi kokuyor..."
L.search_dmg_teleport = "DNA'ları takyon emisyonları tarafından karıştırılmış gibi görünüyor!"
L.search_dmg_car = "Bu terörist yolu geçtiğinde, dikkatsiz bir sürücü tarafından ezildi."
L.search_dmg_other = "Bu teröristin ölümünün belirli bir nedenini bulamazsın."

L.search_floor_antlions = "Vücudun her yerinde hala antlionlar var. Zemin onlarla kaplı olmalı."
L.search_floor_bloodyflesh = "Bu vücuttaki kan eski ve iğrenç görünüyor. Ayakkabılarına yapışmış küçük kanlı et parçaları bile var."
L.search_floor_concrete = "Ayakkabılarını ve dizlerini gri toz kaplamış. Olay yerinin beton zemini varmış gibi görünüyor."
L.search_floor_dirt = "Toprak gibi kokuyor. Muhtemelen kurbanın ayakkabılarına yapışan topraktan kaynaklanıyor."
L.search_floor_eggshell = "İğrenç görünümlü beyaz lekeler kurbanın vücudunu kaplamış. Yumurta kabuğuna benziyor."
L.search_floor_flesh = "Kurbanın giysileri biraz nemli geliyor. Sanki ıslak bir yüzeye düşmüş gibi. Etli bir yüzey veya bir su kütlesinin kumlu zemini gibi."
L.search_floor_grate = "Kurbanın derisi bifteğe benziyor. Belli bir sırada kalın çizgiler kurbanın her yerinde görülüyor. Izgaranın üzerinde mi dinlendiler?"
L.search_floor_alienflesh = "Sence uzaylı eti mi? Kulağa biraz tuhaf geliyor ama dedektif yardımcısı kitabınız onu olası bir zemin yüzeyi olarak listeliyor."
L.search_floor_snow = "İlk bakışta giysileri sadece ıslak ve buz gibi geliyor ama kenarlardaki beyaz köpüğü gördüğünüzde anlarsınız. Bu kar!"
L.search_floor_plastic = "'Ah, bu acıtmış olmalı.' Cesetleri yanıklarla kaplıdır. Plastik bir yüzey üzerinde kayarken meydana gelenlere benziyorlar."
L.search_floor_metal = "En azından artık öldükleri için tetanoz olamazlar. Yaralarını pas kaplıyor. Muhtemelen metal bir yüzeyde öldüler."
L.search_floor_sand = "Küçük küçük pürüzlü taşlar soğuk cesetlerine yapışmış. Kumsaldaki kaba kum gibi. Ahh, her yere bulaşıyor!"
L.search_floor_foliage = "Doğa harikadır. Kurbanın kanlı yaraları, neredeyse gizlenecek kadar yeşilliklerle kaplı."
L.search_floor_computer = "Bip-bup. Cesetleri bilgisayar yüzeyiyle kaplı! Bu nasıl görünüyor diye sorabilirsiniz. Ee, yani!"
L.search_floor_slosh = "Islak ve hatta belki biraz sümüksü. Tüm vücudu bununla kaplı ve kıyafetleri sırılsıklam. Çok pis kokuyor!"
L.search_floor_tile = "Küçük parçalar derilerine yapışmış. Darbe aldığında paramparça olan yer fayanslarının parçaları gibi."
L.search_floor_grass = "Taze kesilmiş çimen gibi kokuyor. Koku neredeyse kan ve ölüm kokusunu bastırıyor."
L.search_floor_vent = "Vücudunu hissederken taze bir hava esintisi hissediyorsun. Havalandırmada ölüp yanlarında hava mı aldılar?"
L.search_floor_wood = "Bir parke zeminde oturup düşüncelere dalmaktan daha güzel ne olabilir? En azından kaderi ahşap bir zeminde ölü yatmak!"
L.search_floor_default = "Bu çok basit, çok normal görünüyor. Ne görüyorsanız o gibi. Yüzeyin türü hakkında hiçbir şey söyleyemiyorsunuz."
L.search_floor_glass = "Cesetleri birçok kanlı kesikle kaplı. Bazılarında cam kırıkları sıkışmış ve size oldukça tehditkar görünüyor."
L.search_floor_warpshield = "Warpshield'den yapılmış bir zemin mi? Evet, biz de senin kadar şaşkınız ama notlarımız bunu açıkça belirtiyor. Warpshield."

L.search_water_1 = "Kurbanın ayakkabıları ıslak, ancak geri kalanı kuru görünüyor. Muhtemelen ayakları suyun içindeyken öldürüldüler."
L.search_water_2 = "Kurbanın ayakkabıları sırılsıklam olmuş. Öldürülmeden önce suda dolaştılar mı?"
L.search_water_3 = "Cesedin tamamı ıslak ve şişmiş. Muhtemelen tamamen su altındayken öldüler."

L.search_weapon = "Görünüşe göre onları öldürmek için bir {weapon} kullanılmış."
L.search_head = "Ölümcül yara bir kafa vuruşuymuş. Çığlık atacak zaman yok."
L.search_time = "Siz aramayı yapmadan bir süre önce öldüler."
L.search_dna = "Bir DNA Tarayıcısı ile katilin DNA'sının bir örneğini alın. DNA örneği bir süre sonra çürüyecek."

L.search_kills1 = "{player} oyuncusunun ölümünü doğrulayan bir leş listesi buldun."
L.search_kills2 = "Bu adlara sahip bir leş listesi buldunuz: {player}"
L.search_eyes = "Dedektiflik becerilerini kullanarak, {player} adlı oyuncuyu gördükleri son kişiyi belirledin. Katil ya da bir tesadüf"

L.search_credits = "Kurbanın cebinde {credits} ekipman kredisi var. Bir alışveriş rolü onları alabilir ve iyi bir şekilde kullanabilir. Gözünüzü dört açın!"

L.search_kill_distance_point_blank = "Çok yakın bir saldırıydı."
L.search_kill_distance_close = "Saldırı kısa mesafeden geldi."
L.search_kill_distance_far = "Kurban uzak mesafeden saldırıya uğradı."

L.search_kill_from_front = "Kurban önden vuruldu."
L.search_kill_from_back = "Kurban arkadan vuruldu."
L.search_kill_from_side = "Kurban yandan vuruldu."

L.search_hitgroup_head = "Mermi başında bulundu."
L.search_hitgroup_chest = "Mermi gövdesinde bulundu."
L.search_hitgroup_stomach = "Mermi karnında bulundu."
L.search_hitgroup_rightarm = "Mermi sağ kolunda bulundu."
L.search_hitgroup_leftarm = "Mermi sol kolunda bulundu."
L.search_hitgroup_rightleg = "Mermi sağ bacağında bulundu."
L.search_hitgroup_leftleg = "Mermi sol bacağında bulundu."
L.search_hitgroup_gear = "Mermi kalçada bulundu."

L.search_policingrole_report_confirm = [[
Bir kamu polisliği rolü ancak ölüm doğrulandıktan sonra bir cesede çağrılabilir.]]
L.search_policingrole_confirm_disabled_1 = [[
Ceset ancak bir kamu polisliği rolü ile doğrulanabilir. Haberdar etmek için cesedi bildirin!]]
L.search_policingrole_confirm_disabled_2 = [[
Ceset ancak bir kamu polisliği rolü ile doğrulanabilir. Haberdar etmek için cesedi bildirin!
Onlar onayladıktan sonra buradaki bilgileri görebilirsiniz.]]
L.search_spec = [[
Bir izleyici olarak bir cesedin tüm bilgilerini görebilirsiniz, ancak kullanıcı arayüzü ile etkileşime giremezsiniz.]]

L.search_title_words = "Kurbanın son sözleri"
L.search_title_c4 = "Parçalarına ayrılma talihsizliği"
L.search_title_dmg_crush = "Ezme hasarı ({amount} SP)"
L.search_title_dmg_bullet = "Mermi hasarı ({amount} SP)"
L.search_title_dmg_fall = "Düşme hasarı ({amount} SP)"
L.search_title_dmg_boom = "Patlama hasarı ({amount} SP)"
L.search_title_dmg_club = "Beyzbol sopası hasarı ({amount} SP)"
L.search_title_dmg_drown = "Boğulma hasarı ({amount} SP)"
L.search_title_dmg_stab = "Bıçaklama hasarı ({amount} SP)"
L.search_title_dmg_burn = "Yanma hasarı ({amount} SP)"
L.search_title_dmg_teleport = "Işınlanma hasarı ({amount} SP)"
L.search_title_dmg_car = "Araba kaza hasarı ({amount} SP)"
L.search_title_dmg_other = "Bilinmeyen hasar ({amount} SP)"
L.search_title_time = "Ölüm zamanı"
L.search_title_dna = "DNA örneği bozunması"
L.search_title_kills = "Kurbanın ölüm listesi"
L.search_title_eyes = "Katilin gölgesi"
L.search_title_floor = "Olay yerinin zemini"
L.search_title_credits = "{credits} Ekipman kredisi"
L.search_title_water = "Su seviyesi {level}"
L.search_title_policingrole_report_confirm = "Ölümü bildirmeyi onayla"
L.search_title_policingrole_confirm_disabled = "Ceset bildir"
L.search_title_spectator = "İzleyicisin"

L.target_credits_on_confirm = "Harcanmamış kredi almak için onaylayın"
L.target_credits_on_search = "Harcanmamış kredileri almak için arama yapın"
L.corpse_hint_no_inspect_details = "Bu ceset hakkında yalnızca kamu polisliği rolleri bilgi bulabilir."
L.corpse_hint_inspect_limited_details = "Sadece kamu polisliği rolleri cesedi doğrulayabilir."
L.corpse_hint_spectator = "Ceset kullanıcı arayüzünü görüntülemek için [{usekey}] tuşuna basın"
L.corpse_hint_public_policing_searched = "Kamu polisliği rolündeki arama sonuçlarını görüntülemek için [{usekey}] tuşuna basın"

L.label_inspect_confirm_mode = "Ceset arama modunu seç"
L.choice_inspect_confirm_mode_0 = "mod 0: standart TTT"
L.choice_inspect_confirm_mode_1 = "mod 1: sınırlı onay"
L.choice_inspect_confirm_mode_2 = "mod 2: sınırlı arama"
L.help_inspect_confirm_mode = [[
Bu oyun modunda üç farklı ceset arama/onaylama modu vardır. Bu modun seçilmesinin, dedektif gibi kamu polisliği rollerinin önemi üzerinde büyük etkileri vardır.

mode 0: Bu standart TTT'dir. Herkes cesetleri arayabilir ve onaylayabilir. Bir cesedi bildirmek veya ondan kredi almak için önce bedenin onaylanması gerekir. Bu, alışveriş rollerinin gizlice kredi çalmasını biraz zorlaştırır. Bununla birlikte, bir kamu polis oyuncusunun aranması için cesedi ihbar etmek isteyen masum oyuncuların da önce onaylaması gerekir.

mode 1: Bu mod, onay seçeneğini bunlarla sınırlandırarak kamu polisliği rollerinin önemini artırır. Bu aynı zamanda, bir cesedi onaylamadan önce kredi almanın ve organları rapor etmenin artık mümkün olduğu anlamına gelir. Herkes hala cesetleri arayabilir ve bilgileri bulabilir, ancak bulunan bilgileri açıklayamazlar.

mode 2: Bu mod, mod 1'den biraz daha katıdır. Bu modda arama yeteneği normal oyunculardan da kaldırılır. Bu, bir cesedi bir kamu polis oyuncusuna bildirmenin artık cesetlerden herhangi bir bilgi almanın tek yolu olduğu anlamına gelir.]]

-- 2023-10-19
L.label_grenade_trajectory_ui = "Bomba yörüngesi göstergesi"

-- 2023-10-23
L.label_hud_pulsate_health_enable = "Sağlık %25'in altındayken sağlık göstergesini titret"
L.header_hud_elements_customize = "Arayüz Öğelerini Özelleştir"
L.help_hud_elements_special_settings = "Bunlar, kullanılan arayüz öğeleri için özel ayarlardır."

-- 2023-10-25
L.help_keyhelp = [[
Tuş atama yardımcıları, oyuncuya her zaman güncel tuş atamalarını gösteren ve özellikle yeni oyuncular için yararlı olan bir kullanıcı arayüzü öğesinin bir parçasıdır. Üç farklı türde tuş atama vardır.

Çekirdek: Bunlar, TTT2'de bulunan en önemli atamaları içerir. Onlar olmadan oyunu tam potansiyeliyle oynamak zordur.
Ekstra Core'a benzer, ancak her zaman onlara ihtiyacınız yoktur. Sohbet, ses veya el feneri gibi şeyler içerirler. Yeni oyuncuların bunu etkinleştirmesi yararlı olabilir.
Bazı ekipman öğelerinin kendi atamaları vardır, bunlar bu kategoride gösterilmiştir.

Puan tablosu görünür olduğunda devre dışı kategoriler hala gösterilir.]]

L.label_keyhelp_show_core = "Her zaman çekirdek atamaları göstermeyi etkinleştir"
L.label_keyhelp_show_extra = "Her zaman ekstra atamaları göstermeyi etkinleştir"
L.label_keyhelp_show_equipment = "Ekipman atamalarını her zaman göstermeyi etkinleştir"

L.header_interface_keys = "Tuş yardımcısı ayarları"
L.header_interface_wepswitch = "Silah değiştirme kullanıcı arayüzü ayarları"

L.label_keyhelper_help = "oyun modu menüsünü aç"
L.label_keyhelper_mutespec = "izleyici ses modunda dön"
L.label_keyhelper_shop = "ekipman mağazasını aç"
L.label_keyhelper_show_pointer = "serbest fare işaretçisi"
L.label_keyhelper_possess_focus_entity = "odaklanılmış varlığı kontrol et"
L.label_keyhelper_spec_focus_player = "odaklı oyuncuyu izle"
L.label_keyhelper_spec_previous_player = "önceki oyuncu"
L.label_keyhelper_spec_next_player = "sonraki oyuncu"
L.label_keyhelper_spec_player = "rastgele oyuncu izle"
L.label_keyhelper_possession_jump = "Nesne: Zıpla"
L.label_keyhelper_possession_left = "Nesne: Sol"
L.label_keyhelper_possession_right = "Nesne: Sağ"
L.label_keyhelper_possession_forward = "Nesne: İleri"
L.label_keyhelper_possession_backward = "Nesne: Geri"
L.label_keyhelper_free_roam = "nesneyi bırakın ve serbest dolaşın"
L.label_keyhelper_flashlight = "El fenerini aç/kapat"
L.label_keyhelper_quickchat = "hızlı sohbeti aç"
L.label_keyhelper_voice_global = "genel sesli sohbet"
L.label_keyhelper_voice_team = "Takım Sesli Sohbeti"
L.label_keyhelper_chat_global = "genel sohbet"
L.label_keyhelper_chat_team = "takım sohbeti"
L.label_keyhelper_show_all = "tümünü göster"
L.label_keyhelper_disguiser = "Kılık Değiştiriciyi aç/kapat"
L.label_keyhelper_save_exit = "kaydet ve çık"
L.label_keyhelper_spec_third_person = "Üçüncü kişi görünümünü aç/kapat"

-- 2023-10-26
L.item_armor_reinforced = "Güçlendirilmiş Zırh"
L.item_armor_sidebar = "Zırh sizi vücudunuza giren mermilere karşı korur. Ama sonsuza kadar değil."
L.item_disguiser_sidebar = "Kılık değiştirici, adınızı diğer oyunculara göstermeyerek kimliğinizi korur."
L.status_speed_name = "Hız Çarpanı"
L.status_speed_description_good = "Normalden daha hızlısın. Eşyalar, ekipmanlar veya etkiler bunu etkileyebilir."
L.status_speed_description_bad = "Normalden daha yavaşsınız. Eşyalar, ekipmanlar veya etkiler bunu etkileyebilir."

L.status_on = "açık"
L.status_off = "kapalı"

L.crowbar_help_primary = "Saldır"
L.crowbar_help_secondary = "Oyuncuları it"

-- 2023-10-27
L.help_HUD_enable_description = [[
Tuş yardımcısı veya kenar çubuğu gibi bazı arayüz öğeleri, puan tablosu açıkken ayrıntılı bilgi gösterir. Bu, dağınıklığı azaltmak için devre dışı bırakılabilir.]]
L.label_HUD_enable_description = "Puan tablosu açıkken açıklamaları etkinleştir"
L.label_HUD_enable_box_blur = "Arayüz kutusu arka plan bulanıklığını etkinleştir"

-- 2023-10-28
L.submenu_gameplay_voiceandvolume_title = "Ses Düzeyi"
L.header_soundeffect_settings = "Ses Efektleri"
L.header_voiceandvolume_settings = "Ses Ayarları"

-- 2023-11-06
L.drop_reserve_prevented = "Bir şey yedek cephanenizi düşürmenizi engelliyor."
L.drop_no_reserve = "Rezervinizde cephane kutusu olarak düşecek yeterli cephane yok."
L.drop_no_room_ammo = "Burada silahını bırakacak yerin yok!"

-- 2023-11-14
L.hat_deerstalker_name = "Dedektifin Şapkası"

-- 2023-11-16
L.help_prop_spec_dash = [[
İzleyiciyken nesneyle atılma, baktığınız yönde atılma hareketleridir. Normal hareketten daha yüksek kuvvette olabilirler. Daha yüksek kuvvet aynı zamanda daha yüksek temel değer tüketimi anlamına da gelir.

Bu değişken itme kuvvetinin bir çarpanıdır.]]
L.label_spec_prop_dash = "Atılma kuvveti çarpanı"
L.label_keyhelper_possession_dash = "nesne: bakılan yönde atıl"
L.label_keyhelper_weapon_drop = "mümkünse seçilen silahı bırak"
L.label_keyhelper_ammo_drop = "seçilen silahın şarjöründen cephane çıkar"

-- 2023-12-07
L.c4_help_primary = "C4'ü yerleştir"
L.c4_help_secondary = "Zemine koy"

-- 2023-12-11
L.magneto_help_primary = "Varlığı it"
L.magneto_help_secondary = "Varlığı al"
L.knife_help_primary = "Bıçakla"
L.knife_help_secondary = "Bıçağı fırlat"
L.polter_help_primary = "Ateşle"
L.polter_help_secondary = "Uzun menzil atışı şarjla"

-- 2023-12-12
L.newton_help_primary = "İtme vuruşu"
L.newton_help_secondary = "Şarjlı itme vuruşu"

-- 2023-12-13
L.vis_no_pickup = "Sadece kamu polisliği rolleri görüntüleyiciyi alabilir"
L.newton_force = "GÜÇ"
L.defuser_help_primary = "Hedef C4'ü çöz"
L.radio_help_primary = "Radyoyu yerleştir"
L.radio_help_secondary = "Zemine yapıştır"
L.hstation_help_primary = "Sağlık İstasyonunu yerleştir"
L.flaregun_help_primary = "Varlığı yak"

-- 2023-12-14
L.marker_vision_owner = "Sahip: {owner}"
L.marker_vision_distance = "Uzaklık: {distance}"
L.marker_vision_distance_collapsed = "{distance}"

L.c4_marker_vision_time = "Patlamaya: {time}"
L.c4_marker_vision_collapsed = "{time} / {distance}"

L.c4_marker_vision_safe_zone = "Bombadan güvenli bölge"
L.c4_marker_vision_damage_zone = "Bomba hasar bölgesi"
L.c4_marker_vision_kill_zone = "Bomba öldürme bölgesi"

L.beacon_marker_vision_player = "İzlenen Oyuncu"
L.beacon_marker_vision_player_tracked = "Bu oyuncu bir Fener tarafından izleniyor"

-- 2023-12-18
L.beacon_help_pri = "Feneri yere at"
L.beacon_help_sec = "Feneri yere kur"
L.beacon_name = "Fener"
L.beacon_desc = [[
Oyuncu konumlarını bu fenerin etrafındaki kürede herkese yayınlar.

Haritada görülmesi zor olan konumları takip etmek için kullanın.]]

L.msg_beacon_destroyed = "Fenerlerinden biri yok edildi!"
L.msg_beacon_death = "Fenerlerinden birinin yakınında bir oyuncu öldü."

L.beacon_short_desc = "Fenerler, etraflarına yerel duvar hilesi eklemek için polislik rolleri tarafından kullanılır"

L.entity_pickup_owner_only = "Bunu sadece sahibi alabilir"

L.body_confirm_one = "{finder}, {victim} adlı kişinin ölümünü doğruladı."
L.body_confirm_more = "{finder}, {count} ölümü doğruladı: {victims}."

-- 2023-12-19
L.builtin_marker = "Bütünleşik."
L.equipmenteditor_desc_builtin = "Bu ekipman TTT2 ile gelen bütünleşik bir öğedir!"
L.help_roles_builtin = "Bu rol TTT2 ile gelen bütünleşik bir öğedir!"
L.header_equipment_info = "Ekipman bilgisi"

-- 2023-12-20
L.equipmenteditor_desc_damage_scaling = [[Bir silahın temel hasar değerini bu faktörle çarpar.
Bir pompalı için bu, her bir saçmayı etkileyecektir.
Bir tüfek için bu sadece kurşunu etkiler.
Afacan Peri için bu, her bir "güm" ü ve son patlamayı etkileyecektir.

0.5 = Hasar miktarının yarısını ver.
2 = Hasar miktarının iki katı kadar hasar ver.

Not: Bazı silahlar bu değiştiricinin etkisiz kalmasına neden olan bu değeri kullanmayabilir.]]

-- 2023-12-24
L.submenu_gameplay_accessibility_title = "Erişilebilirlik"

L.header_accessibility_settings = "Erişilebilirlik Ayarları"

L.label_enable_dynamic_fov = "Dinamik FOV değişikliğini etkinleştir"
L.label_enable_bobbing = "Sallanmayı etkinleştir"
L.label_enable_bobbing_strafe = "Sağ sol yaparken sallanmayı etkinleştir"

L.help_enable_dynamic_fov = "Oyuncunun hızına bağlı olarak dinamik FOV uygulanır. Örneğin bir oyuncu koşarken hızı görselleştirmek için FOV artırılır."
L.help_enable_bobbing_strafe = "Ekran sallanması, yürürken, yüzerken veya düşerken hafif kamera sarsıntısıdır."

L.binoc_help_reload = "Hedefi kaldırın."
L.cl_sb_row_sresult_direct_conf = "Doğrudan Onay"
L.cl_sb_row_sresult_pub_police = "Kamu polisliği rolü onayı"

-- 2024-01-05
L.label_crosshair_thickness_outline_enable = "Nişangâh dış çizgisini etkinleştir"
L.label_crosshair_outline_high_contrast = "Dış çizgi yüksek kontrast rengini etkinleştir"
L.label_crosshair_mode = "Nişangâh modu"
L.label_crosshair_static_length = "Sabit nişangâh çizgi uzunluğunu etkinleştir"

L.choice_crosshair_mode_0 = "Çizgiler ve nokta"
L.choice_crosshair_mode_1 = "Sadece çizgiler"
L.choice_crosshair_mode_2 = "Sadece nokta"

L.help_crosshair_scale_enable = [[
Dinamik nişangâh, silahın konisine bağlı olarak nişangâhın ölçeklendirilmesini sağlar. Koni, zıplama ve koşma gibi dış faktörlerle çarpılan silahın taban isabetinden etkilenir.

Çizgi uzunluğu sabit tutulursa yalnızca konili boşluk ölçeklenir.]]

L.header_weapon_settings = "Silah Ayarları"

-- 2024-01-24
L.grenade_fuse = "ATEŞLE"

-- 2024-01-25
L.header_roles_magnetostick = "Manyeto Çubuğu"
L.label_roles_ragdoll_pinning = "Ceset sabitlemeyi etkinleştir"
L.magneto_stick_help_carry_rag_pin = "Ceseti sabitle"
L.magneto_stick_help_carry_rag_drop = "Ceseti bırak"
L.magneto_stick_help_carry_prop_release = "Nesneyi sal"
L.magneto_stick_help_carry_prop_drop = "Nesneyi bırak"

-- 2024-01-27
L.decoy_help_primary = "Tuzağı yerleştirin"
L.decoy_help_secondary = "Tuzağı kur"


L.marker_vision_visible_for_0 = "Sadece size görünür"
L.marker_vision_visible_for_1 = "Sadece sizin rolünüze görünür"
L.marker_vision_visible_for_2 = "Takıma görünür"
L.marker_vision_visible_for_3 = "Herkese görünür"

-- 2024-02-14
L.throw_no_room = "Bu cihazı atmak için yeterli alanınız yok"

-- 2024-03-04
L.use_entity = "Kullanmak için [{usekey}] tuşuna basın"

-- 2024-03-06
L.submenu_gameplay_sounds_title = "Kullanıcı Sesleri"

L.header_sounds_settings = "Arayüz Ses Ayarları"

L.help_enable_sound_interact = "Etkileşim sesleri, bir kullanıcı arayüzü açılırken çalınan seslerdir. Örneğin radyo işaretçisi ile etkileşime girerken bir ses çalınır."
L.help_enable_sound_buttons = "Düğme sesleri, bir düğmeye tıklandığında çalınan tıklama sesleridir."
L.help_enable_sound_message = "Sohbet mesajları ve bildirimler için mesaj veya bildirim sesleri çalınır. Oldukça can sıkıcı olabilirler."

L.label_enable_sound_interact = "Etkileşim seslerini etkinleştir"
L.label_enable_sound_buttons = "Düğme seslerini etkinleştir"
L.label_enable_sound_message = "Mesaj seslerini etkinleştir"

L.label_level_sound_interact = "Etkileşim ses seviyesi çarpanı"
L.label_level_sound_buttons = "Düğme ses seviyesi çarpanı"
L.label_level_sound_message = "Mesaj ses seviyesi çarpanı"

-- 2024-03-07
L.label_crosshair_static_gap_length = "Sabit nişangâh boşluk uzunluğunu etkinleştir"
L.label_crosshair_size_gap = "Nişangâh boşluk boyutu çarpanı"

-- 2024-03-31
L.help_locational_voice = "Konumsal sohbet, TTT2'nin konumsal 3D ses uygulamasıdır. Oyuncular sadece çevrelerindeki belirli bir yarıçapta duyulabilir ve oyuncular ne kadar uzakta olurlarsa sesleri o kadar sessizleşir."
L.help_locational_voice_prep = [[Varsayılan olarak, konumsal sohbet hazırlık aşamasında devre dışıdır. Hazırlık aşamasında konumsal sohbeti de kullanmak için bu konsol değerini değiştirin.

Not: Konumsal sohbet, raunt sonrası her zaman devre dışı bırakılır.]]
L.help_voice_duck_spectator = "İzleyici seslerini azaltmak, diğer izleyicileri canlı oyunculara kıyasla daha sessiz hale getirir. Yaşayan oyuncuların tartışmalarını yakından dinlemek istiyorsanız bu yararlı olabilir."

L.help_equipmenteditor_configurable_clip = [[Yapılandırılabilir boyut, silahın mağazadan satın alındığında veya haritada oluştuğunda sahip olduğu kullanım miktarını tanımlar.

Not: Bu ayar yalnızca bu özelliği etkinleştiren silahlar için kullanılabilir.]]
L.label_equipmenteditor_configurable_clip = "Yapılandırılabilir şarjör boyutu"

-- 2024-04-06
L.help_locational_voice_range = [[Bu konsol değeri, oyuncuların birbirlerini duyabilecekleri maksimum menzili kısıtlar. Sesin mesafeyle nasıl azaldığını değiştirmez, daha ziyade sert bir kesme noktası belirler.

Bu kesintiyi devre dışı bırakmak için 0'a ayarlayın.]]

-- 2024-04-07
L.help_voice_activation = [[Genel sesli sohbet için mikrofonunun etkinleştirilme şeklini değiştirir. Bunların hepsi 'Genel Sesli Sohbet' tuş atamanızı kullanır. Takım sesli sohbeti her zaman bas konuş şeklindedir.

Bas Konuş: Konuşmak için tuşa basılı tutun.
Ses Etkinliği: Mikrofonun her zaman açık, sesini kapatmak için tuşu basılı tut.
Aç - Kapat: Mikrofonunuzu açmak veya kapatmak için tuşa basın.
Aç - Kapat (Katılınca Etkinleştir): 'Aç - Kapat' gibi, ancak sunucuya katıldığınızda mikrofonunuz etkinleştirilir.]]
L.label_voice_activation = "Sesli Sohbet Etkinleştirme Modu"
L.label_voice_activation_mode_ptt = "Bas Konuş"
L.label_voice_activation_mode_ptm = "Sessize almak için bas"
L.label_voice_activation_mode_toggle_disabled = "Aç - Kapat"
L.label_voice_activation_mode_toggle_enabled = "Aç - Kapat (Katılınca Etkinleştir)"

-- 2024-04-08
L.label_inspect_credits_always = "Tüm oyuncuların cesetlerdeki kredileri görmesine izin ver"
L.help_inspect_credits_always = [[
Alışveriş rolleri öldüğünde kredileri alışveriş rolleri olan diğer oyuncular tarafından alınabilir.

Bu seçenek devre dışıyken, yalnızca kredi toplayabilen oyuncular kredileri bir ceset üzerinde görebilir.
Etkinleştirildiğinde, tüm oyuncular bir cesetteki kredileri görebilir.]]

-- 2024-05-13
L.menu_commands_title = "Yönetici Komutları"
L.menu_commands_description = "Haritaları değiştir, bot oluştur ve oyuncu rollerini düzenle."

L.submenu_commands_maps_title = "Haritalar"

L.header_maps_prefixes = "Haritaları Öneklerine Göre Etkinleştir veya Devre Dışı Bırak"
L.header_maps_select = "Haritaları Seç ve Değiştir"

L.button_change_map = "Haritayı Değiştir"

-- 2024-05-20
L.submenu_commands_commands_title = "Komutlar"

L.header_commands_round_restart = "Raundu Yeniden Başlat"
L.header_commands_player_slay = "Oyuncuyu Öldür"
L.header_commands_player_teleport = "Oyuncuyu Bakılan Yere Işınla"
L.header_commands_player_respawn = "Oyuncuyu Bakılan Yerde Yeniden Canlandır"
L.header_commands_player_add_credits = "Ekipman Kredisi Ekle"
L.header_commands_player_set_health = "Sağlık Ayarla"
L.header_commands_player_set_armor = "Zırh Ayarla"

L.label_button_round_restart = "raundu yeniden başlat"
L.label_button_player_slay = "oyuncuyu öldür"
L.label_button_player_teleport = "oyuncuyu ışınla"
L.label_button_player_respawn = "oyuncuyu yeniden canlandır"
L.label_button_player_add_credits = "kredi ekle"
L.label_button_player_set_health = "sağlık ayarla"
L.label_button_player_set_armor = "zırh ayarla"

L.label_slider_add_credits = "Kredi tutarını ayarla"
L.label_slider_set_health = "sağlık ayarla"
L.label_slider_set_armor = "zırh ayarla"

L.label_player_select = "Etkilenen oyuncuyu seç"
L.label_execute_command = "Komut Çalıştır"

-- 2024-05-22
L.tip38 = "{usekey} tuşuna basarak baktığınız silahları alabilirsiniz. Seni engelleyen silahı otomatik olarak bırakacak."
L.tip39 = "Tuş atamalarınızı {helpkey} ile açılan Ayarlar menüsünde bulunan atamalar menüsünden değiştirebilirsiniz."
L.tip40 = "Ekranınızın sol tarafında, size uygulanan mevcut ekipmanı veya durum efektlerini gösteren simgeler vardır."
L.tip41 = "Puan tablonuzu açarsanız, kenar çubuğu ve tuş yardımcısı ek bilgi gösterir."
L.tip42 = "Ekranınızın alt kısmındaki tuş yardımcısı, o anda kullanabileceğiniz ilgili bağlantıları gösterir."
L.tip43 = "Onaylanmış bir cesedin adının yanındaki simge, ölen oyuncunun rolünü gösterir."

L.header_loadingscreen = "Yükleme Ekranı"

L.help_enable_loadingscreen = "Yükleme ekranı, harita bir raunttan sonra yenilendiğinde gösterilir. Büyük haritalarda meydana gelen görünür ve duyulabilir gecikmeyi gizlemek için kullanılmaktadır. Oyun ipuçlarını göstermek için de kullanılır."

L.label_enable_loadingscreen = "Yükleme ekranını etkinleştir"
L.label_enable_loadingscreen_tips = "Yükleme ekranında ipuçlarını etkinleştir"

-- 2024-05-25
L.help_round_restart_reset = [[
Bir raundu yeniden başlat veya haritayı sıfırla.

Bir raundu yeniden başlatmak yalnızca mevcut raundu yeniden başlatır, böylece baştan başlayabilirsiniz. Raundu sıfırlamak her şeyi temizler, böylece oyun bir harita değişikliğinden sonra tazeymiş gibi yeni başlar.]]

L.label_button_level_reset = "haritayı sıfırla"

L.loadingscreen_round_restart_title = "Yeni raunt başlıyor"
L.loadingscreen_round_restart_subtitle_limits_mode_0 = "{map} adlı haritada oynuyorsunuz"
L.loadingscreen_round_restart_subtitle_limits_mode_1 = "{map} haritasında {rounds} raunt veya {time} daha oynayacaksınız"
L.loadingscreen_round_restart_subtitle_limits_mode_2 = "{map} haritasında {time} boyunca oynayacaksınız"
L.loadingscreen_round_restart_subtitle_limits_mode_3 = "{map} haritasında {rounds} raunt daha oynayacaksınız"

-- 2024-06-23
L.header_roles_derandomize = "Rastgele Rol Dağıtımı"

L.help_roles_derandomize = [[
Rol dağılımını bir oturum boyunca daha adil hissettirmek için kullanılabilir.

Özünde, etkinleştirildiğinde, bir oyuncunun o role atanmamışken bir rol alma şansı artar. Bu daha adil gelse de, bir oyuncunun birkaç rauntta hain olarak seçilmedikleri gerçeğine dayanarak bir başkasının hain olarak seçilebileceğini tahmin edebileceği 'metagaming''i de mümkün kılar. İstenmiyorsa bu seçeneği etkinleştirmeyin.

4 mod vardır:

mod 0: Devre Dışı - Rastgele dağıtım yapılmaz.

mod 1: Yalnızca temel roller - Rastgele dağıtıma son verme yalnızca temel roller için gerçekleştirilir. Alt roller rastgele seçilecektir. Bunlar Masum ve Hain gibi rollerdir.

mod 2: Yalnızca alt roller - Rastgele dağıtım yalnızca alt roller için gerçekleştirilir. Alt roller rastgele seçilecektir. Alt rollerin yalnızca temel rolleri için daha önce seçilmiş oyunculara atandığını unutmayın.

mod 3: Temel roller ve alt roller - Rastgele dağıtım hem temel roller hem de alt roller için gerçekleştirilir.]]
L.label_roles_derandomize_mode = "Rastgele dağıtım modu"
L.label_roles_derandomize_mode_none = "mod 0: Devre dışı"
L.label_roles_derandomize_mode_base_only = "mod 1: Yalnızca temel roller"
L.label_roles_derandomize_mode_sub_only = "mod 2: Yalnızca alt roller"
L.label_roles_derandomize_mode_base_and_sub = "mod 3: Temel roller ve alt roller"

L.help_roles_derandomize_min_weight = [[
Rastgele oyuncu seçimlerinin rol dağılımı sırasında her oyuncu için her rolle ilişkili bir ağırlık kullanması sağlanarak ve oyuncuya o rol atanmadığında bu ağırlık 1 artar. Bu ağırlıklar bağlantılar arasında veya haritalar arasında kalıcı değildir.

Bir oyuncuya her rol atandığında, ilgili ağırlık bu minimum ağırlığa sıfırlanır. Bu ağırlığın mutlak bir anlamı yoktur; sadece diğer ağırlıklara göre yorumlanabilir.

Örneğin, ağırlığı 1 olan A oyuncusu ve ağırlığı 5 olan B oyuncusu göz önüne alındığında, B oyuncusunun seçilme olasılığı A oyuncusundan 5 kat daha fazladır. Ancak, A oyuncusunun ağırlığı 4 ise, B oyuncusunun seçilme olasılığı sadece 5/4 kat daha fazladır.

Bu nedenle, minimum ağırlık, her raundun bir oyuncunun seçilme şansını ne kadar etkilediğini etkili bir şekilde kontrol eder ve daha yüksek değerler daha az etkilenmesine neden olur. Varsayılan 1 değeri, her raundun şansda oldukça önemli bir artışa neden olduğu ve tersine, bir oyuncunun arka arkaya iki kez aynı rolü almasının son derece düşük olduğu anlamına gelir.

Bu değerdeki değişiklikler, oyuncular yeniden bağlanana veya harita değişene kadar geçerli olmayacaktır.]]
L.label_roles_derandomize_min_weight = "Minimum rastgele dağıtım ağırlığı"

-- 2024-08-17
L.name_button_default = "Düğme"
L.name_button_rotating = "Anahtar"

L.button_default = "Tetiklemek için [{usekey}] tuşuna bas"
L.button_rotating = "Devreye sokmak için [{usekey}] tuşuna bas"

L.undefined_key = "???"

-- 2024-08-18
L.header_commands_player_force_role = "Oyuncu Rolünü Zorla"

L.label_button_player_force_role = "rolü zorla"

L.label_player_role = "Rol seç"

-- 2024-09-16
L.help_enable_loadingscreen_server = [[
Yükleme ekranı ayarları istemcide de mevcuttur. Sunucuda devre dışı bırakılırsa yükleme ekranı ayarları gizlenir.

Minimum görüntüleme süresi, oyuncuya ipuçlarını okuması için zaman vermek için oradadır. Haritanın yeniden yüklenmesi minimum süreden daha uzun sürerse, yükleme ekranı olması gerektiği kadar uzun süre gösterilir. Genel olarak 0,5 ila 1 saniyelik bir yeniden yükleme süresi beklenmektedir.]]

L.label_enable_loadingscreen_server = "Sunucu genelinde yükleme ekranını etkinleştir"
L.label_loadingscreen_min_duration = "Minimum yükleme ekranı görüntüleme süresi"

-- 2024-09-18
L.label_keyhelper_leave_vehicle = "araçtan çık"
L.name_vehicle = "Araç"
L.vehicle_enter = "Araca girmek için [{usekey}] tuşuna bas"

-- 2024-11-27
L.corpse_hint_without_confirm = "Aramak için [{usekey}] tuşuna bas."

-- 2025-01-05
L.help_session_limits_mode = [[
Aralarından seçim yapabileceğiniz üç farklı oturum sınırı modu vardır:

mod 0: Oturum sınırı yok. TTT2 oturumu sonlandırmayacak ve harita değişikliğini tetiklemeyecektir.

mod 1: Varsayılan TTT2 modu. Oturum süresi veya oturum raunt sayısı biterse bir harita değişikliği tetiklenir.

mod 2: Sadece zaman sınırı. Bir harita değişikliği yalnızca oturum süresi dolduğunda tetiklenir.

mod 3: Sadece raunt sınırı. Bir harita değişikliği yalnızca oturum raunt sayısı biterse tetiklenir.]]
L.label_session_limits_mode = "Oturum sınırı modunu ayarla"
L.choice_session_limits_mode_0 = "mod 0: oturum sınırı yok"
L.choice_session_limits_mode_1 = "mod 1: zaman ve raunt sınırı"
L.choice_session_limits_mode_2 = "mod 2: sadece zaman sınırı"
L.choice_session_limits_mode_3 = "mod 3: sadece raunt sınırı"

-- 2024-12-30
L.searchbar_roles_placeholder = "Rol ara..."
L.label_menu_search_no_items = "Aramanızla eşleşen bir öğe bulunamadı."

L.submenu_roles_overview_title = "Rollere Genel Bakış (BENİ OKU)"

-- Is there a way to ahve some sort of external file that's possibly-localized?
L.roles_overview_html = [[
<h1>Genel Bakış</h1>

TTT2'nin temel mekaniklerinden biri <em>roldür</em>. Roller hedeflerinizi,
ekip arkadaşlarınızın kimler olduğunu ve neler yapabileceğinizi belirler.
Oyunculara rollerin dağıtılış şekli bu nedenle çok önemlidir. Rol dağıtım
sistemi çok karmaşıktır ve bu sekmedeki menüler hemen hemen sistemin her
yönünü kontrol eder. Seçenekleri ve sistemin nasıl işlediğini anlamak
sunucunuzda yapacağınız değişiklikler için çok önemlidir.


<h2>Terminoloji</h2>

<ul>
<li><em>Rol</em> &mdash; Raunt başlangıcında bir oyuncuya atanan rol,
örn. <em>Hain</em>, <em>Masum</em>, <em>Ruh Çağıran (Necromancer)</em>vb.</li>
<li><em>Temel rol</em> &mdash; İlk olarak seçilen ve oyuncunun alacağı son rol
için bir tür üst düzey şablon görevi gören <em>rol</em>. <em>Temel roller</em>
son roller olabilir. Ör. <em>Masum</em>, <em>Hain</em>, <em>Korsan</em></li>
<li><em>Alt rol</em> &mdash; <em>Temel rolün</em> iyileştirilmesi için bir rol atılmasıdır.
Her olası <em>alt rol</em> bir <em>temel rolle</em> ilişkilendirilir; öyle ki,
bir oyuncuya bir <em>alt rol</em> alabilmesi için uygun <em>temel rolün</em> atanmış
olması gerekir. Örn. <em>Dedektif</em> (M-alt rol), <em>Tetikçi</em>
(T-alt rol), <em>Hayatta Kalma Uzmanı</em> (M-alt rol), vb.</li>
</ul>

<h2>Algoritma</h2>

<em>Kodu</em> <code>roleselection.SelectRoles</code>

<ol>

<li>
<p>
Her bir role verilebilecek oyuncu sayısını belirler.
<em>Masum</em> ve <em>Hain'in</em> her zaman boş yuvaları vardır.
</p>
<p>
Tüm roller (hem temel hem de alt roller) burada hesaplanır. Alt roller
yalnızca karşılık gelen temel rolleri varsa seçilebilir yuvalara sahiptir.
</p>
<p>
Her role dağıtılma şansı verilir. Bu şans
başarısız olursa, bu adım olası oyuncu sayısını sıfıra ayarlar.
</p>
<p>
<em>Kodu</em>
<code>roleselection.GetAllSelectableRolesList</code>
</p>
</li>

<li>
<p>
Dağıtılacak olan, katman yapılandırmasıyla sınırlanacak ve yapılandırılmış
maksimum rol sayısıyla sınırlandırılacak rolleri seçin. Bu işlem,
çok karmaşık olduğu için kendisine başka bir bölümde yer verilmiştir. Detaylar
bir sonraki bölümdedir.
</p>
<p>
<em>Kodu</em>
<code>roleselection.GetSelectableRolesList</code>
</p>
</li>

<li>
<p>
Zorunlu rolleri atayın. Bu aslında basit bir işlemdir; Bir oyuncuya birden fazla
zorunlu rolün atandığı durumu mantıklı bir şekilde ele almanın mantıklı bir açıklaması
vardır. Bu yaygın olarak kullanılmaz, ancak bütünlük için dahil edilir.
</p>
</li>

<li>
<p>
Oyuncu listesini rastgele karıştırın. Bu muhtemelen rol dağılımını
çok fazla etkilemese de, oyuncu katılım sırasına
bağlı kalmamayı garantiler.
</p>
</li>

<li>
<p>
Her seçilebilir temel rol için (sırasıyla <em>Hain</em>,
<em>Masum</em>, geriye kalan temel roller):
</p>
<ol type="a">
<li>
<p>
Ana kutuya izin verilen sayıda oyuncu ata. (Bu
daha sonra detaylandırılacaktır.)
</p>
<p><em>Kodu</em> <code>SelectBaseRolePlayers</code></p>
</li>
<li>
<p>
Temel rol <em>Masum</em> değilse, bu temel role
sahip oyuncuları mümkün olan alt rollere "yükseltmeye" çalışın. (Bu
daha sonra detaylandırılacaktır.)
</p>
<p><em>Kodu</em> <code>UpgradeRoles</code></p>
</li>
</ol>
</li>

<li>
<p>
Henüz bir rol atanmamış tüm oyunculara <em>Masum</em> rolü atanır.
</p>
</li>

<li>
<p>
<em>Masum</em> temel rolüne sahip tüm oyuncuların rolleri
tam olarak 5b adımında olduğu gibi "yükseltilmiştir".
</p>
</li>

<li>
<p>
<code>TTT2ModifyFinalRoles</code> hook'u, diğer eklentilerin son rolleri
değişiklik yapmasına izin vermek için kullanılır.
</p>
</li>

<li>
<p>
Her oyuncunun rol ağırlıkları son rollerine göre güncellenir.
(Oyuncunun son rolü bir alt rol ise, karşılık gelen temel rolleri
güncellenir.)
</p>
</li>

</ol>

<h3>
Rol Katmanlama (diğer adıyla <code>roleselection.GetSelectableRolesList</code>)
</h3>

<p>Rol katmanlama, rol seçiminin en kontrol edilebilir ve tarihsel olarak en kötü açıklanabilir kısmıdır. Kısacası, <em>rol katmanlama</em>
<em>hangi</em> rollerin <em>nasıl</em> dağıtılabileceğini DEĞİL, hangi rollerin dağıtılabileceğini belirler.</p>

<p>Algoritma aşağıdaki gibidir:</p>
<ol>
<li>
<p>Yapılandırılan her temel rol katmanı için (daha fazla role ihtiyaç
duyulacak kadar oyuncu olduğu sürece):</p>
<ol type="a">
<li>
<p>
Oyuncu yuvası olmayan katmandaki tüm rolleri kaldır.
(Bu, daha önce rastgele dağıtılmamasına karar verilen
rolleri kaldıracaktır.)
</p>
</li>
<li>
<p>
Katmanın kalanından rastgele bir rol seç.
</p>
</li>
<li>
<p>
Rolü, temel roller listesine ekle.
</p>
</li>
</ol>
</li>
<li>
<p>Katmanlı olmayan temel rolleri rastgele yinele. Bu tür her temel rol için,
rolü son aday listesine ekle.</p>
</li>
<li>
<p>Her adayın temel rolünün mevcut yuvalarını, ilk eklenen adayları tercih ederek, toplamın toplam oyuncu sayısı olacak şekilde değiştir.</p>
</li>
<li>
<p>Şimdi, alt roller. Seçilebilir alt rol başına bir kez değerlendirme (temel rol aday listesindeki
tüm temel roller için tüm katmanlı ve katmansız
alt roller dahil):</p>
<ol type="a">
<li>
<p>Rastgele bir temel rol adayı seçin.</p>
</li>
<li>
<p>
Bu temel rol için tanımlanmış herhangi bir katman varsa: Mevcut ilk katmandan
rastgele bir alt rol seçin. Katmanı kaldırın.
</p>
<p>
Temel rol için tanımlanmış katman yoksa: Katmansız alt rollerden
rastgele bir alt rol seçin. Bu alt rolü katmansız listeden kaldırın.

</p>
</li>
<li>
<p>Seçilen alt rolü son aday listesine ekleyin.</p>
</li>
<li>
<p>
Temel rolün artık alt rol katmanları veya alt rolleri yoksa: Temel rolü daha fazla
düşünmeden kaldırın (YALNIZCA bu döngü için. Aday listesinde kalır.)
</p>
</li>
</ol>
</li>
<li>
<p>Temel rol ve alt rol aday listeleri artık atanacaktır.</p>
</li>
</ol>

<h3>Temel Rol Seçimi (diğer adıyla <code>SelectBaseRolePlayers</code>)</h3>

<p>TÜM oyuncuları BİR temel role atadığımızı hatırlayın.</p>
<p>Atanacak oyuncular ve atanacak daha fazla kullanılabilir yuva olduğu sürece:
</p>
<ol>
<li>
<p>Rolün atanacağı bir oyuncu seçin.</p>
<p>
<em>Rastgele rol dağıtımı</em> (<em>Genel Rol Ayarları</em> sekmesindeki <em>Rastgele Rol Dağıtımı</em> bölümüne bakın)
"yalnızca temel rol" veya "mod 3" olarak ayarlanmışsa:
Mevcut oyuncular arasından bu temel rol ile ilişkili ağırlığa
göre ağırlıklandırılmış rastgele bir oyuncu seçin. (Her oyuncunun ağırlığa göre listede birden çok kez seçildiğini düşünün.)
</p>
<p>
<em>Rastgele rol dağıtımı</em> "devre dışı" veya "yalnızca alt roller" olarak ayarlanmışsa:
Mevcut oyuncular arasından eşit olasılıkla rastgele bir oyuncu seçin.
</p>
</li>

<li>
<p>
Seçilen oyuncunun rol için yeterli karması varsa, tüm yuvaları
doldurmaya yetecek kadar oyuncu yoksa, 1/3 şans geçerse veya hedef
temel rol <em>Masum</em> ise: Oyuncuyu mevcut oyuncular listesinden
çıkarın ve oyuncuya temel rolü atayın.
</p>
</li>
</ol>

<h3>Alt Rol Seçimi (diğer adıyla <code>UpgradeRoles</code>)</h3>

<p>Bu, temel rol seçimine <em>çok</em> benzer.</p>
<p>Rolleri yükseltirken, bir temel rolle ilişkili TÜM alt roller birlikte işlenir. Bu temel role sahip tüm oyuncular birlikte ele alınır.</p>
<p>Yalnızca doldurulmamış atanabilir yuvalara sahip alt roller
dikkate alınır. (Bu, zorunlu alt rollerin varlığıyla ilgilidir.)</p>

<p>Atanacak oyuncular ve atanabilir daha fazla alt rol olduğu sürece:</p>
<ol>
<li>
<p>Rolün atanacağı bir oyuncu seçin.</p>
<p>
<em>Rastgele rol dağıtımı</em> "yalnızca alt roller" veya "mod 3" olarak ayarlanmışsa:
Mevcut oyuncular arasından, bu temel rol ile ilişkili ağırlığa göre
ağırlıklandırılmış rastgele bir oyuncu seçin.
</p>
<p>
<em>Rastgele rol dağıtımı</em> "devre dışı" veya "yalnızca temel roller" olarak ayarlanmışsa:
Mevcut oyuncular arasından eşit olasılıkla rastgele bir oyuncu seçin.
</p>
</li>

<li>
<p>
Seçilen oyuncunun rol için yeterli karması varsa, tüm yuvaları doldurmaya
yetecek kadar oyuncu yoksa veya 1/3 şansı varsa
(bu, yukarıdakiyle aynı durumdur ve kodda paylaşılan bir işlevdir):
Mevcut oyuncular listesinden oyuncuyu seçin ve oyuncuya alt rolü
atayın. Alt rolün tüm boş yuvaları doldurulmuşsa, dikkate almayın.
</p>
</li>
</ol>

]]

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
L.help_rolelayering_enable = "Simgenin etrafındaki kırmızı ve yeşil kenarlık, rolün şu anda etkin olup olmadığını gösterir. Bu rolü hızlı bir şekilde etkinleştirmek/devre dışı bırakmak için bir simgeye sağ tıklayın."

-- 2025-01-20
L.label_hud_show_team_name = "Rol adının yanında takım adını göstermeyi etkinleştir"

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
