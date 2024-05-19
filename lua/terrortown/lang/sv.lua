-- Swedish language strings

local L = LANG.CreateLanguage("sv")

-- Compatibility language name that might be removed soon.
-- the alias name is based on the original TTT language name:
-- https://github.com/Facepunch/garrysmod/blob/master/garrysmod/gamemodes/terrortown/gamemode/lang/swedish.lua
L.__alias = "Svenska"

L.lang_name = "Svenska (Swedish)"

-- General text used in various places
L.traitor = "Förrädare"
L.detective = "Detektiv"
L.innocent = "Oskyldig"
L.last_words = "Sista Ord"

L.terrorists = "Terrorister"
L.spectators = "Åskådare"

--L.nones = "No Team"
--L.innocents = "Team Innocent"
--L.traitors = "Team Traitor"

-- Round status messages
L.round_minplayers = "För få spelare för att påbörja ny runda..."
L.round_voting = "Omröstning pågår, fördröjer ny runda med {num} sekunder..."
L.round_begintime = "En ny runda påbörjas om {num} sekunder. Bered dig."
L.round_selected = "Förrädarna har blivit utvalda."
L.round_started = "Rundan har påbörjats!"
L.round_restart = "Rundan har blivit omstartad av en admin."

L.round_traitors_one = "Förrädare, du står ensam"
L.round_traitors_more = "Förrädare, detta är dina lagkamrater: {names}"

L.win_time = "Tiden har tagit slut. Förrädarna har förlorat."
--L.win_traitors = "The Traitors have won!"
--L.win_innocents = "The Innos have won!"
--L.win_nones = "No-one won!"
L.win_showreport = "Låt oss ta en titt på rund-rapporten i {num} sekunder."

--L.limit_round = "Round limit reached. The next map will load soon."
--L.limit_time = "Time limit reached. The next map will load soon."
--L.limit_left = "{num} round(s) or {time} minutes remaining before the map changes."

-- Credit awards
--L.credit_all = "Your team have been awarded {num} equipment credit(s) for your performance."
L.credit_kill = "Du har blivit tilldelad {num} kredit(er) för att ha dödat en {role}."

-- Karma
L.karma_dmg_full = "Din Karma är {amount}, så du utdelar full skada denna runda!"
L.karma_dmg_other = "Din Karma är {amount}. Till följd av detta är skadan du utdelar reducerad med {num}%"

-- Body identification messages
L.body_found = "{finder} fann {victim}s kropp. {role}"
--L.body_found_team = "{finder} found the body of {victim}. {role} ({team})"

-- The {role} in body_found will be replaced by one of the following:
--L.body_found_traitor = "They were a Traitor!"
--L.body_found_det = "They were a Detective."
--L.body_found_inno = "They were Innocent."

L.body_call = "{player} kallade en Detektiv till {victim}s kropp!"
L.body_call_error = "Du måste bekräfta denna spelarens död för att kunna kalla på en Detektiv!"

L.body_burning = "Aj! Den här kroppen brinner!"
L.body_credits = "Du fann {num} kredit(er) på kroppen!"

-- Menus and windows
L.close = "Stäng"
L.cancel = "Avbryt"

-- For navigation buttons
L.next = "Nästa"
L.prev = "Föregående"

-- Equipment buying menu
L.equip_title = "Verktyg"
L.equip_tabtitle = "Beställ verktyg"

L.equip_status = "Beställnings-status"
L.equip_cost = "Du har {num} kredit(er) kvar."
L.equip_help_cost = "Varje verktyg du köper kostar 1 kredit."

L.equip_help_carry = "Du kan endast köpa verktyg för vilka du har rum."
L.equip_carry = "Du kan bära detta verktyg."
L.equip_carry_own = "Du bär redan detta verktyg."
L.equip_carry_slot = "Du har redan ett vapen i nummer {slot}."
--L.equip_carry_minplayers = "There are not enough players on the server to enable this weapon."

L.equip_help_stock = "Vissa verktyg kan du endast köpa en utav varje runda."
L.equip_stock_deny = "Detta verktyg har tagit slut."
L.equip_stock_ok = "Detta verktyg finns tillgängligt."

L.equip_custom = "Egengjort verktyg tillagt av denna server."

L.equip_spec_name = "Namn:"
L.equip_spec_type = "Typ:"
L.equip_spec_desc = "Beskrivning:"

L.equip_confirm = "Köp föremål"

-- Disguiser tab in equipment menu
L.disg_name = "Förklädare"
L.disg_menutitle = "Förklädningskontroll"
L.disg_not_owned = "Du har ingen Förklädare!"
L.disg_enable = "Aktivera förklädare"

L.disg_help1 = "När din förklädare är påslagen visas inte ditt namn, din hälsa eller din karma när någon tittar på dig. Du syns heller inte på en Detektivs radar."
L.disg_help2 = "Tryck på Numpad Enter för att sätta på/stänga av förklädnaden utan att använda menyn. Du kan även binda en annan tangent till 'ttt_toggle_disguise' genom att använda konsollen."

-- Radar tab in equipment menu
L.radar_name = "Radar"
L.radar_menutitle = "Radar-kontroll"
L.radar_not_owned = "Du har ingen Radar!"
L.radar_scan = "Utför skanning"
L.radar_auto = "Auto-repetera skanning"
L.radar_help = "Skannings-resultat visas i {num} sekunder. Efter detta laddas Radarn om och kan användas igen."
L.radar_charging = "Din Radar laddar fortfarande!"

-- Transfer tab in equipment menu
L.xfer_name = "Överför"
L.xfer_menutitle = "Överför krediter"
L.xfer_send = "Sänd en kredit"

L.xfer_no_recip = "Mottagare ej giltig avbryter kredit-överföring."
L.xfer_no_credits = "Du har inga krediter att ge!"
L.xfer_success = "Kredit-överföring till {player} utförd."
L.xfer_received = "{player} har gett dig {num} krediter."

-- Radio tab in equipment menu
L.radio_name = "Radio"

-- Radio soundboard buttons
L.radio_button_scream = "Skrik"
L.radio_button_expl = "Explosion"
L.radio_button_pistol = "Pistol-skott"
L.radio_button_m16 = "M16-skott"
L.radio_button_deagle = "Deagle-skott"
L.radio_button_mac10 = "MAC10-skott"
L.radio_button_shotgun = "Hagelgevär-skott"
L.radio_button_rifle = "Gevärsskott"
L.radio_button_huge = "H.U.G.E-salva"
L.radio_button_c4 = "C4-pip"
L.radio_button_burn = "Brand"
L.radio_button_steps = "Fotsteg"

-- Intro screen shown after joining
L.intro_help = "Om du är ny till detta spel, tryck F1 för att få instruktioner!"

-- Radiocommands/quickchat
L.quick_title = "Snabb-knappar"

L.quick_yes = "Ja."
L.quick_no = "Nej."
L.quick_help = "Hjälp!"
L.quick_imwith = "Jag är med {player}."
L.quick_see = "Jag ser {player}."
L.quick_suspect = "{player} beter sig skumt."
L.quick_traitor = "{player} är en Förrädare!"
L.quick_inno = "{player} är oskyldig."
L.quick_check = "Lever någon fortfarande?"

-- {player} in the quickchat text normally becomes a player nickname, but can
-- also be one of the below.  Keep these lowercase.
L.quick_nobody = "ingen"
L.quick_disg = "någon i förklädnad"
L.quick_corpse = "ett oidentifierat lik"
L.quick_corpse_id = "{player}s lik"

-- Scoreboard
L.sb_playing = "Du spelar på..."
L.sb_mapchange = "Kartan ändras om {num} rundor eller om {time}"
--L.sb_mapchange_disabled = "Session limits are disabled."

L.sb_mia = "Saknad I Strid"
L.sb_confirmed = "Bekräftad Död"

L.sb_ping = "Ping"
L.sb_deaths = "Döda"
L.sb_score = "Poäng"
L.sb_karma = "Karma"

L.sb_info_help = "Om du kollar igenom denna spelares lik kan du se resultaten här."

L.sb_tag_friend = "VÄN"
L.sb_tag_susp = "MISSTÄNKT"
L.sb_tag_avoid = "UNDVIK"
L.sb_tag_kill = "DÖDA"
L.sb_tag_miss = "SAKNAD"

-- Equipment actions, like buying and dropping
L.buy_no_stock = "Det här vapnet finns inte tillgängligt: du har redan köpt det den här rundan."
L.buy_pending = "Du har redan en beställning som väntar, vänta tills du får den."
L.buy_received = "Du har fått ditt specialverktyg."

L.drop_no_room = "Det finns ingen plats här för att släppa ditt vapen!"

L.disg_turned_on = "Förklädnad aktiverad!"
L.disg_turned_off = "Förklädnad avaktiverad."

-- Equipment item descriptions
L.item_passive = "Passivt verktyg"
L.item_active = "Aktiv användning-verktyg"
L.item_weapon = "Vapen"

L.item_armor = "Kroppsrustning"
L.item_armor_desc = [[
Reducerar skottskador med 30% när du blir träffad.

Standard-verktyg för Detektiver.]]

L.item_radar = "Radar"
L.item_radar_desc = [[
Tillåter dig att skanna efter livstecken.

Startar automatiskt så fort du köper den. Konfigurera den i Radar-fliken i den här menyn.]]

L.item_disg = "Förklädare"
L.item_disg_desc = [[
Döljer din identitet när den är påslagen. Hindrar även att man blir den sista sedda personen av ett offer.

Slå av/på i Förklädnads-fliken i den här menyn eller tryck Numpad Enter.]]

-- C4
L.c4_disarm_warn = "En C4 som du har placerat har blivit desarmerad."
L.c4_armed = "Du lyckades armera bomben."
L.c4_disarmed = "Du lyckades desarmera bomben."
L.c4_no_room = "Du kan ej bära denna C4."

L.c4_desc = "Kraftfullt tidsbestämt sprängämne."

L.c4_arm = "Armera C4"
L.c4_arm_timer = "Timer"
L.c4_arm_seconds = "Sekunder tills detonering:"
L.c4_arm_attempts = "Vid desarmeringsförsök kommer {num} av de 6 sladdarna att orsaka en omedelbar detonering vid avklippning."

L.c4_remove_title = "Avlägsnande"
L.c4_remove_pickup = "Plocka upp C4"
L.c4_remove_destroy1 = "Förstör C4"
L.c4_remove_destroy2 = "Bekräfta: förstör"

L.c4_disarm = "Desarmera C4"
L.c4_disarm_cut = "Klicka för att klippa av sladd nummer {num}"

L.c4_disarm_t = "Klipp av en sladd för att desarmera bomben. Eftersom du är en Förrädare är varje sladd säker. De oskylda har det inte lika lätt!"
L.c4_disarm_owned = "Klipp av en sladd för att desarmera bomben. Det är din bomb, så varje sladd kommer att desarmera den."
L.c4_disarm_other = "Klipp av en säker sladd för att desarmera bomben. Den kommer att explodera om du klipper fel!"

L.c4_status_armed = "ARMERAD"
L.c4_status_disarmed = "DESARMERAD"

-- Visualizer
L.vis_name = "Visualiserare"

L.vis_desc = [[
Verktyg för brottsscens-visualisering.

Analyserar ett lik för att visa hur offret dog, men enbart om han dog av skottskador.]]

-- Decoy
L.decoy_name = "Lockbete"
L.decoy_broken = "Ditt Lockbete har förstörts!"

--L.decoy_short_desc = "This decoy shows a fake radar sign visible for other teams"
--L.decoy_pickup_wrong_team = "You can't pick it up as it belongs to a different team"

L.decoy_desc = [[
Visar ett fejkat radar-spår för detektiver, och gör så att deras DNA-skanner visa platsen för Lockbetet om de skannar efter ditt DNA.]]

-- Defuser
L.defuser_name = "Desarmerare"

L.defuser_desc = [[
Desarmerar C4 omedelbart.

Kan användas oändligt många gånger. C4 märks tydligare om du bär detta verktyg.]]

-- Flare gun
L.flare_name = "Signalpistol"

L.flare_desc = [[
Kan användas till att bränna lik så att de aldrig återfinns. Begränsad ammunition.

Att bränna ett lik gör ett tydligt ljud.]]

-- Health station
L.hstation_name = "Hälsostation"

L.hstation_broken = "Din Hälsostation har blivit förstörd!"

L.hstation_desc = [[
Tillåter spelare att helas när den är utplacerad.

Långsam omladdning. Vem som helst kan använda den, och den kan utsättas för skada. Kan kollas efter DNA-prov av dess användare.]]

-- Knife
L.knife_name = "Kniv"
L.knife_thrown = "Kastkniv"

--L.knife_desc = [[
--Kills wounded targets instantly and silently, but only has a single use.
--
--Can be thrown using alternate fire.]]

-- Poltergeist
L.polter_desc = [[
Placerar enheter på föremål som knuffar omkring dem med våldsam kraft.

Explosionerna skadar spelare i närheten.]]

-- Radio
L.radio_broken = "Din Radio har blivit förstörd!"

L.radio_desc = [[
Spelar upp distraherande eller bedragande ljud.

Placera radion någonstans, och spela sedan upp ljud på den genom att använda Radio-fliken i den här menyn.]]

-- Silenced pistol
L.sipistol_name = "Ljuddämpad Pistol"

L.sipistol_desc = [[
Pistol med dämpade ljud. Använder vanlig pistol-ammunition.

Offer skriker inte när de blir dödade.]]

-- Newton launcher
L.newton_name = "Avståndsknuffare"

L.newton_desc = [[
Knuffa spelare från ett bekvämt avstånd.

Oändligt med ammunition, men laddar om långsamt.]]

-- Binoculars
L.binoc_name = "Kikare"

L.binoc_desc = [[
Zooma in på lik och identifiera dem från ett långt avstånd.

Kan användas oändligt många gånger, men identifieringen tar några sekunder.]]

-- UMP
L.ump_desc = [[
Experimentell k-pist som desorienterar målen.

Använder vanlig k-pist-ammunition.]]

-- DNA scanner
L.dna_name = "DNA-skanner"
L.dna_notfound = "Inget DNA-prov kunde hittas på målet."
L.dna_limit = "Lagringsbegränsningen nådd. Ta bort gamla prov för att lägga till nya."
L.dna_decayed = "Mördarens DNA-prov har förruttnat."
L.dna_killer = "Hittade ett prov av mördarens DNA på liket!"
--L.dna_duplicate = "Match! You already have this DNA sample in your scanner."
L.dna_no_killer = "DNAt kunde inte återfås (har mördaren gått ur spelet?)"
L.dna_armed = "Bomben går fortfarande! Desarmera den först!"
--L.dna_object = "Collected a sample of the last owner from the object."
L.dna_gone = "DNA kunde inte hittas i området. (Har mördaren gått ur spelet?)"

L.dna_desc = [[
Samla DNA-prov från saker och använd dem för att hitta dess ägare.

Använd på färska lik för att få mördarens DNA och söka upp honom.]]

-- Magneto stick
L.magnet_name = "Magnetstav"
L.magnet_help = "{primaryfire} för att sätta fast kropp på ytan."

-- Grenades and misc
L.grenade_smoke = "Rökgranat"
L.grenade_fire = "Brandbomb"

L.unarmed_name = "Hölstrad"
L.crowbar_name = "Kofot"
L.pistol_name = "Pistol"
L.rifle_name = "Gevär"
L.shotgun_name = "Hagelgevär"

-- Teleporter
L.tele_name = "Teleportör"
L.tele_failed = "Teleportering misslyckad."
L.tele_marked = "Teleporteringsplats markerad."

L.tele_no_ground = "Kan ej teleportera om du inte står på fast mark!"
L.tele_no_crouch = "Kan ej teleportera när du duckar!"
L.tele_no_mark = "Ingen plats markerad. Markera en destination innan du teleporterar."

L.tele_no_mark_ground = "Kan ej markera en teleporteringsplats om du inte står på fast mark!"
L.tele_no_mark_crouch = "Kan ej markera en teleporteringsplats om du duckar!"

--L.tele_help_pri = "Teleports to marked location"
--L.tele_help_sec = "Marks current location"

L.tele_desc = [[
Teleportera till en tidigare markerad plats.

Teleportering orsakar oljud, och antalet gånger den kan användas är begränsat.]]

-- Ammo names, shown when picked up
L.ammo_pistol = "9mm ammunition"

L.ammo_smg1 = "K-pist-ammunition"
L.ammo_buckshot = "Hagelgevärsammunition"
L.ammo_357 = "Gevärsammunition"
L.ammo_alyxgun = "Deagle-ammunition"
L.ammo_ar2altfire = "Signalammunition"
L.ammo_gravity = "Poltergeist-ammunition"

-- Round status
L.round_wait = "Väntar"
L.round_prep = "Förbereder"
L.round_active = "Pågår"
L.round_post = "Runda över"

-- Health, ammo and time area
L.overtime = "ÖVERTID"
L.hastemode = "HETSLÄGE"

-- TargetID health status
L.hp_healthy = "Frisk"
L.hp_hurt = "Skadad"
L.hp_wounded = "Ganska Skadad"
L.hp_badwnd = "Svårt Skadad"
L.hp_death = "Nära Döden"

-- TargetID Karma status
L.karma_max = "Ansedd"
L.karma_high = "Klumpig"
L.karma_med = "Skjutglad"
L.karma_low = "Farlig"
L.karma_min = "Varning"

-- TargetID misc
L.corpse = "Lik"
L.corpse_hint = "Tryck {usekey} för att söka igenom. {usekey} + {walkkey} för att söka i smyg."

L.target_disg = " (FÖRKLÄDD)"
L.target_unid = "Oidentifierad kropp"
--L.target_unknown = "A Terrorist"

-- HUD buttons with hand icons that only some roles can see and use
L.tbut_single = "Engångsanvändning"
L.tbut_reuse = "Omanvändningsbar"
L.tbut_retime = "Omanvändningsbar efter {num} sekunder"
L.tbut_help = "Tryck {usekey} för att aktivera"

-- Spectator muting of living/dead
L.mute_living = "Levande spelare nedtystade"
L.mute_specs = "Åskådare nedtystade"
--L.mute_all = "All muted"
L.mute_off = "Ingen nedtystad"

-- Spectators and prop possession
L.punch_title = "KNUFF-MÄTARE"
L.punch_bonus = "Din dåliga poäng har sänkt din knuff-mätargräns med {num}"
L.punch_malus = "Din goda poäng har höjt din knuff-mätargräns med {num}!"

-- Info popups shown when the round starts
L.info_popup_innocent = [[
Du är en oskyldig Terrorist! Men det finns förrädare omkring...
Vem kan du lita på, och vem är ute för att mörda dig?

Var aktsam och arbeta med dina kamrater för att komma ut härifrån levande!]]

L.info_popup_detective = [[
Du är en Detektiv! Terrorist-högkvarteren har givit dig speciella resurser för att finna förrädarna.
Använd dem för att hjälpa de oskyldiga överleva, men var försiktig:
förrädarna kommer att försöka ta ned dig först!

Tryck {menukey} för att få dina verktyg!]]

L.info_popup_traitor_alone = [[
Du är en FÖRRÄDARE! Du har inga förrädarkamrater denna runda.

Döda alla andra för att vinna!

Tryck {menukey} för att få dina verktyg!]]

L.info_popup_traitor = [[
Du är en FÖRRÄDARE! Arbeta med dina förrädarkamrater för att döda alla andra.
Men var försiktig, annars kan ditt förräderi upptäckas...

Detta är dina kamrater:
{traitorlist}

Tryck {menukey} för att få dina verktyg!]]

-- Various other text
L.name_kick = "En spelare blev utsparkad automatiskt för att ha bytt sitt namn under en runda."

L.idle_popup = [[
Du var borta i {num} sekunder och blev därför förflyttad till Åskådar-läge. Så länge du är i detta läge kommer du inte att kunna spela när en ny runda börjar.

Du kan slå av/på Åskådar-läge när som helst genom att trycka på {helpkey} och bocka av lådan i inställningsfliken. Du kan även välja att stänga av det nu medsamma.]]

L.idle_popup_close = "Gör ingenting"
L.idle_popup_off = "Stäng av Åskådar-läge nu"

L.idle_warning = "Varning: du verkar vara borta, och kommer att bli tvingad att åskåda om du inte gör någonting!"

L.spec_mode_warning = "Du är i Åskådar-läge och kommer inte att starta när en runda påbörjas. För att stänga av detta läge, tryck F1, gå till inställningar och bocka av 'Åskådar-läge'."

-- Tips panel
L.tips_panel_title = "Tips"
L.tips_panel_tip = "Tips:"

-- Tip texts
L.tip1 = "Förrädare kan söka igenom kroppar tyst, utan att bekräfta deras död, genom att hålla in {walkkey} och trycka {usekey} på liket."

L.tip2 = "Genom att armera en C4 med en längre timer kommer antalet sladdar som orsakar omedelbar detonering att öka. Den kommer även att pipa svagare och med större mellanrum mellan pipen."

L.tip3 = "Detektiver kan söka igenom lik för att se vem som 'reflekteras på näthinnan'. Detta är den sista personen som den döde snubben såg. Det är dock inte nödvändigtvis mördaren om han skjöts i ryggen."

L.tip4 = "Ingen kommer att veta om att du har dött förrän de har funnit din döda kropp och identifierat den genom att söka igenom den."

L.tip5 = "När en Förrädare dödar en Detektiv får han omedelbart en kreditbelöning."

L.tip6 = "När en Förrädare dör får alla Detektiver kreditbelöning."

L.tip7 = "När Förrädarna har dödat tillräckligt många får de en kreditbelöning."

L.tip8 = "Förrädare och Detektiver kan samla på sig oanvända verktygskrediter från döda Förrädar- och Detektiv-kroppar."

L.tip9 = "Poltergeisten kan förvandla vilket rörligt föremål som helst till en dödlig projektil. Varje knuff medför en stark smäll som skadar alla i närheten."

L.tip10 = "Som en Förrädare eller som en Detektiv bör du hålla ett öga på röda meddelanden i det övre högra hörnet av skärmen, då dessa innehåller viktig information."

L.tip11 = "Som en Förrädare eller som en Detektiv får du extra verktygskrediter om dina kamrater arbetar väl. Kom också ihåg att spendera dem!"

L.tip12 = "Detektivernas DNA-skanner kan användas till att samla DNA-prov från vapen och föremål för att sedan skanna och finna dess användare. Detta är användbart när du kan hitta ett prov från ett lik eller en avstängd C4!"

L.tip13 = "Om du är nära ditt mordoffer kommer ditt DNA att hamna på liket. DNAt kan sedan användas med Detektivernas DNA-skannrar för att hitta var du är. Du gör därför bäst i att gömma liken efter att du har knivhuggit det!"

L.tip14 = "Ju längre ifrån du är ditt mordoffer, desto kortare tid kommer ditt DNA finnas kvar på liket innan det förruttnar."

L.tip15 = "Tänkte du skjuta prick som Förrädare? Överväg att använda en Förklädare. Om du missar ett skott kan du springa till en säker plats, stänga av apparaten och komma ut som om ingenting hade hänt."

L.tip16 = "Som Förrädare kan Teleportören hjälpa dig fly när du är jagad, och tillåter dig att komma från plats A till plats B på väldigt kort tid. Se bara till så att du har en säker plats markerad."

L.tip17 = "Är de oskylda ihopklumpade och svåra att ha ihjäl? Prova att använda Radion och spela upp C4-pip eller ljud av en skottlossning för att splittra gruppen."

L.tip18 = "Genom att använda Radion som Förrädare kan du spela upp ljud genom din Verktygs-meny efter att Radion har blivit placerad. Köa flera ljud genom att klicka på flera knappar i den ordning du vill att de ska spelas upp i."

L.tip19 = "Om du har krediter över kan du som Detektiv ge en Desarmerare till en oskyldig som du litar på. Då kan du spendera mer tid till att utreda och lämna den riskfulla bombdesarmeringen till dem."

L.tip20 = "Detektivernas Kikare tillåter likidentifiering från långa avstånd. Det är dåliga nyheter för Förrädarna, om de tänkte använda liket som lockbete. Å andra sidan är Detektiven distraherad och obeväpnad när han använder Kikaren..."

L.tip21 = "Detektivernas Hälsostation tillåter skadade spelare att återhämta sig. Å andra sidan kan de skadade spelarna vara Förrädare..."

L.tip22 = "Genom att använda DNA-skannern på Hälsostationen kan man få fram DNA-prov från alla som använt den."

L.tip23 = "Till skillnad från vapen och C4 lämnas inga DNA-spår på Radion, så Förrädare behöver inte oroa sig för att Detektiver hittar den och förstör deras dag."

L.tip24 = "Tryck på {helpkey} för att se en kort genomgång eller ändra några inställningar för TTT. Till exempel kan du stänga av dessa tips där för gott."

L.tip25 = "När en Detektiv söker igenom en kropp kan resultaten hittas för alla spelare på poängtavlan genom att klicka på den döde personens namn."

L.tip26 = "På poängtavlan betyder ett förstoringsglass bredvid någons namn att det finns sökinformation om den personen. Om ikonen är ljus kommer informationen från en Detektiv och kan innehålla mer information."

L.tip27 = "Som en Detektiv betyder ett förstoringsglas bredvid någons namn att kroppen har blivit genomsökt och att informationen finns tillgänglig för alla spelare via poängtavlan."

L.tip28 = "Åskådare kan trycka på {mutekey} för att rotera mellan alternativ för att tysta ned åskådare eller levande spelare."

L.tip29 = "If the server has installed additional languages, you can switch to a different language at any time in the Settings menu."

L.tip30 = "Snabbknappar eller 'radio-kommandon' kan användas genom att trycka på {zoomkey}."

L.tip31 = "Som en åskådare kan du trycka på {duckkey} för att låsa upp din muspekare och klicka på knapparna på den här panelen. Tryck på {duckkey} igen för att komma tillbaka till musstyrning."

L.tip32 = "Kofotens alternativa avfyrningsläge knuffar andra spelare."

L.tip33 = "Genom att använda siktet på vapnen kommer träffsäkerheten att höjas något och rekylen minskas. Att ducka gör ingen skillnad."

L.tip34 = "Rökgranater är effektiva inomhus, särskilt för att skapa förvirring i ett rum proppfullt med folk."

L.tip35 = "Som en Förrädare bör du komma ihåg att du kan gömma kroppar från oskyldiga och Detektivers snokande ögon."

L.tip36 = "En genomgång av spelläget finns tillgängligt under {helpkey}. I den finns en översikt över viktiga element i spelet."

L.tip37 = "På poängtavlan kan du klicka på någons namn och välja en tagg för dem, t.ex. 'misstänkt' eller 'vän'. Denna tagg dyker sedan upp om du siktar på spelaren."

--L.tip38 = "Many of the placeable equipment items (such as C4, Radio) can be stuck on walls using secondary fire."

L.tip39 = "C4 som exploderar på grund av en misslyckad desarmering har mindre explosionsradie än en C4 där timern når noll."

L.tip40 = "Om det står 'HETSLÄGE' ovanför rundtimern kommer rundan först bara att vara några minuter lång, men efter varje oskyldig död kommer tiden att ökas. Det här läget pressar Förrädarna att göra någonting och inte bara stå still hela rundan."

-- Round report
L.report_title = "Rundrapport"

-- Tabs
L.report_tab_hilite = "Höjdpunkter"
L.report_tab_hilite_tip = "Rund-höjdpunkter"
L.report_tab_events = "Händelser"
L.report_tab_events_tip = "Händelseloggen om vad som hände den här rundan"
L.report_tab_scores = "Poäng"
L.report_tab_scores_tip = "Varje spelares poäng den här rundan"

-- Event log saving
L.report_save = "Spara Log .txt"
L.report_save_tip = "Sparar Händelseloggen i en textfil"
L.report_save_error = "Ingen Händelselogg-data att spara."
L.report_save_result = "Händelseloggen har sparats i:"

-- Columns
L.col_time = "Tid"
L.col_event = "Händelse"
L.col_player = "Spelare"
--L.col_roles = "Role(s)"
--L.col_teams = "Team(s)"
L.col_kills1 = "Oskyldiga dödade"
L.col_kills2 = "Förrädare dödade"
L.col_points = "Poäng"
L.col_team = "Lagbonus"
L.col_total = "Totala poäng"

-- Awards/highlights
L.aw_sui1_title = "Ledare av Själmordssekt"
L.aw_sui1_text = "visade de andra självmördarna hur man gjorde genom att göra det själv först."

L.aw_sui2_title = "Ensam och Deprimerad"
L.aw_sui2_text = "var den ende som begick självmord."

L.aw_exp1_title = "Explosivt Forskningsbidrag"
L.aw_exp1_text = "vart erkänd för sin forskning kring explosioner. {num} försöksobjekt hjälpte till."

L.aw_exp2_title = "Fältforskning"
L.aw_exp2_text = "provade sin motståndskraft mot explosioner. Den var inte tillräckligt hög."

L.aw_fst1_title = "Första Förräderiet"
L.aw_fst1_text = "levererade det första oskyldiga mordet genom en förrädares händer."

L.aw_fst2_title = "Första Dumma DödandetFirst Bloody Stupid Kill"
L.aw_fst2_text = "fick det första dödandet genom att skjuta en förrädarkamrat. Bra jobbat."

L.aw_fst3_title = "Första Tabben"
L.aw_fst3_text = "var den första att döda. Synd att det var en oskyldig kamrat."

L.aw_fst4_title = "Första Slaget"
L.aw_fst4_text = "slog det första slaget för de oskyldiga terroristerna genom att göra den första döden till en förrädares."

L.aw_all1_title = "Dödlig Bland Jämlikar"
L.aw_all1_text = "var ansvarig för alla de oskyldigas dödande den här rundan."

L.aw_all2_title = "Ensamvarg"
L.aw_all2_text = "var ansvarig för alla förrädarnas dödande den här rundan."

L.aw_nkt1_title = "Jag Fick En, Chefen!"
L.aw_nkt1_text = "lyckades döda en enda oskyldig. Schysst!!"

L.aw_nkt2_title = "En Kula För Två"
L.aw_nkt2_text = "visade att den första inte bara var tur genom att döda en till."

L.aw_nkt3_title = "Serie-Förrädare"
L.aw_nkt3_text = "tog idag slut på tre oskyldiga terrorist-liv."

L.aw_nkt4_title = "En Varg i Fårakläder"
L.aw_nkt4_text = "äter oskyldiga terrorister till middag. En middag bestående av {num} rätter."

L.aw_nkt5_title = "Kontra-Terroristisk Operation"
L.aw_nkt5_text = "får betalt för varje dödad. Kan nu köpa ännu en lyxjakt."

L.aw_nki1_title = "Förräd detta"
L.aw_nki1_text = "hittade en förrädare. Sköt en förrädare. Enkelt."

L.aw_nki2_title = "Ansökte till Rättvise-Patrullen"
L.aw_nki2_text = "eskorterade två förrädare till den andra sidan."

L.aw_nki3_title = "Drömmer Förrädare Om Förrädiska Får?"
L.aw_nki3_text = "hjälpte tre förrädare till sömns."

L.aw_nki4_title = "Anställd på Interna Affärer"
L.aw_nki4_text = "får betalt för varje dödad. Kan nu beställa sin femte simbassäng."

L.aw_fal1_title = "Fia med Knuff"
L.aw_fal1_text = "knuffade någon från en hög höjd."

L.aw_fal2_title = "Däckad"
L.aw_fal2_text = "föll från en väldigt hög höjd."

L.aw_fal3_title = "Den Mänsklige Meteoriten"
L.aw_fal3_text = "krossade en man med sin tyngd genom att falla på honom."

L.aw_hed1_title = "Effektivitet"
L.aw_hed1_text = "upptäckte nöjet med huvudskott och utförde {num}."

L.aw_hed2_title = "Hjärnkirurg"
L.aw_hed2_text = "avlägsnade {num} hjärnor från dess huvud för en närmare analys."

L.aw_hed3_title = "Jag Beskyller TV-Spelen"
L.aw_hed3_text = "applicerade sin mordsimulerings-träning och placerade {num} dödliga huvudskott."

L.aw_cbr1_title = "Dunk Dunk Dunk"
L.aw_cbr1_text = "har en riktig bra svingarm med kofoten, vilket {num} offer fick reda på."

L.aw_cbr2_title = "Martin Timell"
L.aw_cbr2_text = "täckte sin kofot med inte mindre än {num} människors hjärnor."

L.aw_pst1_title = "Ihärdig Liten Rackare"
L.aw_pst1_text = "dödade {num} spelare med hjälp av pistolen. Sedan gick han och kramade någon till döds."

L.aw_pst2_title = "Slakt Med Låg Kaliber"
L.aw_pst2_text = "dödade en liten armé på {num} med en pistol. Förmodligen har han ett litet hagelgevär i mynningen."

L.aw_sgn1_title = "Lätt Som En Plätt"
L.aw_sgn1_text = "applicerade haglet där det gör som mest skada, och dödade {num} mål på kuppen."

L.aw_sgn2_title = "Tusen Små Hagel"
L.aw_sgn2_text = "gillade inte riktigt sitt hagel, så han gav bort allt. {num} mottagare levde inte länge nog för att ha kul med det."

L.aw_rfl1_title = "Peka och Klicka"
L.aw_rfl1_text = "visar att allt du behöver för {num} döda är ett gevär och en stadig hand."

L.aw_rfl2_title = "Jag Kan Se Ditt Huvud Härifrån"
L.aw_rfl2_text = "kände sitt gevär utan och innan. Nu känner {num} andra också hans till det."

L.aw_dgl1_title = "Gevär I Mini-Format"
L.aw_dgl1_text = "börjar få grepp om sin Desert Eagle och dödade {num} människor."

L.aw_dgl2_title = "Deaglar'n"
L.aw_dgl2_text = "blåste iväg {num} människor med sin handkanon."

L.aw_mac1_title = "Sikta(inte) och Skjut"
L.aw_mac1_text = "dödade {num} människor med sin MAC10, men vägrar uppge hur många skott som krävdes."

L.aw_mac2_title = "Köttbullar med MACaroner"
L.aw_mac2_text = "undrar vad som skulle hända om han kunde använda två MAC10 samtidigt. {num} gånger två?"

L.aw_sip1_title = "Var Tyst"
L.aw_sip1_text = "fick tyst på {num} människor med den ljuddämpade pistolen."

L.aw_sip2_title = "Tyst Men Dödlig"
L.aw_sip2_text = "dödade {num} människor som inte kunde höra sig själv dö."

L.aw_knf1_title = "Knivig Situation"
L.aw_knf1_text = "stack någon i ansiktet över internet."

L.aw_knf2_title = "Var Hittade Du Den Där?"
L.aw_knf2_text = "var inte en Förrädare, men lyckades ändå döda någon med en kniv."

L.aw_knf3_title = "En Knivig Situation"
L.aw_knf3_text = "hittade {num} knivar, och gjorde det bästa med dem."

L.aw_knf4_title = "En Knivslug Man"
L.aw_knf4_text = "dödade {num} människor med knivar. Fråga mig inte hur."

L.aw_flg1_title = "Till Undsättning"
L.aw_flg1_text = "använde sin signalpistol till att signalera {num} mord."

L.aw_flg2_title = "Ingen Rök Utan Eld"
L.aw_flg2_text = "lärde {num} män om faran med att ha lättantändliga kläder på sig."

L.aw_hug1_title = "HUGEnottkrig"
L.aw_hug1_text = "gick ut i krig med sin H.U.G.E, och lyckades på något sätt skjuta ihjäl {num} människor."

L.aw_hug2_title = "Fett Mycket Para"
L.aw_hug2_text = "hade väldigt många skott, och investerade dem i {num} människor."

L.aw_msx1_title = "Ett M16-Protokoll"
L.aw_msx1_text = "prickade av {num} människor från listan med sin M16."

L.aw_msx2_title = "Galenskap På Medelavstånd"
L.aw_msx2_text = "lyckades plocka ner {num} mål med sin M16."

L.aw_tkl1_title = "Aja-baja!"
L.aw_tkl1_text = "slant med fingret när han siktade på en kompis."

L.aw_tkl2_title = "De Såg Ut Som Förrädare"
L.aw_tkl2_text = "trodde att han lyckats döda en Förrädare två gånger, men hade fel båda gångerna."

L.aw_tkl3_title = "Låg Karma"
L.aw_tkl3_text = "kunde inte sluta efter att ha dödat två medspelare. Hans turnummer är tre."

L.aw_tkl4_title = "Lagslakt"
L.aw_tkl4_text = "mördade hela sitt lag. Lyckligtvis är han nog inte kvar så länge till."

L.aw_tkl5_title = "Rollspelare"
L.aw_tkl5_text = "antog sig rollen som was roleplaying en blådåre. Det är därför han dödade merparten av sitt lag."

L.aw_tkl6_title = "Pucko"
L.aw_tkl6_text = "förstod inte vilken sida han var på, så han dödade mer än hälften av sina lagkamrater."

L.aw_tkl7_title = "Bondlurk"
L.aw_tkl7_text = "försvarade sin mark genom att döda mer än en fjärdedel av sitt lag."

L.aw_brn1_title = "Precis Som Mormors"
L.aw_brn1_text = "grillade flera människor tills de fått en fin yta."

L.aw_brn2_title = "Leker Med Elden"
L.aw_brn2_text = "lärde sig tydligen inte vad mamma lärt honom, vilket flera människor får sota för."

L.aw_brn3_title = "Pyrrhic Burnery"
L.aw_brn3_text = "burned them all, but is now all out of incendiary grenades! How will he cope!?"

L.aw_fnd1_title = "Coroner"
L.aw_fnd1_text = "found {num} bodies lying around."

L.aw_fnd2_title = "Gotta Catch Em All"
L.aw_fnd2_text = "found {num} corpses for his collection."

L.aw_fnd3_title = "Death Scent"
L.aw_fnd3_text = "keeps stumbling on random corpses, {num} times this round."

L.aw_crd1_title = "Recycler"
L.aw_crd1_text = "scrounged up {num} leftover credits from corpses."

L.aw_tod1_title = "Pyrrhusseger"
L.aw_tod1_text = "dog bara några sekunder innan hans lag vann rundan."

L.aw_tod2_title = "Jag Hatar Detta Spel"
L.aw_tod2_text = "dog precis efter att rundan påbörjats."

-- New and modified pieces of text are placed below this point, marked with the
-- version in which they were added, to make updating translations easier.

-- v24
L.drop_no_ammo = "Otillräcklig ammunition i vapnets klipp att släppa som en ammo låda."

-- 2015-05-25
L.hat_retrieve = "Du plockade upp hatten av en detektiv."

-- 2017-09-03
--L.sb_sortby = "Sort By:"

-- 2018-07-24
--L.equip_tooltip_main = "Equipment menu"
--L.equip_tooltip_radar = "Radar control"
--L.equip_tooltip_disguise = "Disguise control"
--L.equip_tooltip_radio = "Radio control"
--L.equip_tooltip_xfer = "Transfer credits"
--L.equip_tooltip_reroll = "Reroll equipment"

--L.confgrenade_name = "Discombobulator"
--L.polter_name = "Poltergeist"
--L.stungun_name = "UMP Prototype"

--L.knife_instant = "INSTANT KILL"

--L.binoc_zoom_level = "Zoom Level"
--L.binoc_body = "BODY DETECTED"

--L.idle_popup_title = "Idle"

-- 2019-01-31
--L.create_own_shop = "Create own shop"
--L.shop_link = "Link with"
--L.shop_disabled = "Disable shop"
--L.shop_default = "Use default shop"

-- 2019-05-05
--L.reroll_name = "Reroll"
--L.reroll_menutitle = "Reroll equipment"
--L.reroll_no_credits = "You need {amount} credits to reroll!"
--L.reroll_button = "Reroll"
--L.reroll_help = "Use {amount} credits to get a new random set of equipment in your shop!"

-- 2019-05-06
--L.equip_not_alive = "You can view all available items by selecting a role on the right. Don't forget to mark your favorites!"

-- 2019-06-27
--L.shop_editor_title = "Shop Editor"
--L.shop_edit_items_weapong = "Edit Items / Weapons"
--L.shop_edit = "Edit Shops"
--L.shop_settings = "Settings"
--L.shop_select_role = "Select Role"
--L.shop_edit_items = "Edit Items"
--L.shop_edit_shop = "Edit Shop"
--L.shop_create_shop = "Create Custom Shop"
--L.shop_selected = "Selected {role}"
--L.shop_settings_desc = "Change the values to adapt Random Shop ConVars. Don't forget to save your changes!"

--L.bindings_new = "New bound key for {name}: {key}"

--L.hud_default_failed = "Failed to set the HUD {hudname} as new default. You don't have permission to do that, or this HUD doesn't exist."
--L.hud_forced_failed = "Failed to force the HUD {hudname}. You don't have permission to do that, or this HUD doesn't exist."
--L.hud_restricted_failed = "Failed to restrict the HUD {hudname}. You don't have permission to do that."

--L.shop_role_select = "Select a role"
--L.shop_role_selected = "{role}'s shop was selected!"
--L.shop_search = "Search"

-- 2019-10-19
--L.drop_ammo_prevented = "Something prevents you from dropping your ammo."

-- 2019-10-28
--L.target_c4 = "Press [{usekey}] to open C4 menu"
--L.target_c4_armed = "Press [{usekey}] to disarm C4"
--L.target_c4_armed_defuser = "Press [{primaryfire}] to use defuser"
--L.target_c4_not_disarmable = "You can't disarm C4 of a living teammate"
--L.c4_short_desc = "Something very explosive"

--L.target_pickup = "Press [{usekey}] to pick up"
--L.target_slot_info = "Slot: {slot}"
--L.target_pickup_weapon = "Press [{usekey}] to pickup weapon"
--L.target_switch_weapon = "Press [{usekey}] to swap with your current weapon"
--L.target_pickup_weapon_hidden = ", press [{walkkey} + {usekey}] for hidden pickup"
--L.target_switch_weapon_hidden = ", press [{walkkey} + {usekey}] for hidden switch"
--L.target_switch_weapon_nospace = "There is no inventory slot available for this weapon"
--L.target_switch_drop_weapon_info = "Dropping {name} from slot {slot}"
--L.target_switch_drop_weapon_info_noslot = "There is no droppable weapon in slot {slot}"

--L.corpse_searched_by_detective = "This corpse was searched by a public policing role"
--L.corpse_too_far_away = "The corpse is too far away."

--L.radio_short_desc = "Weapon sounds are music to me"

--L.hstation_subtitle = "Press [{usekey}] to receive health."
--L.hstation_charge = "Remaining charge of health station: {charge}"
--L.hstation_empty = "There is no more charge left in this health station"
--L.hstation_maxhealth = "Your health is full"
--L.hstation_short_desc = "The heath station slowly recharges over time"

-- 2019-11-03
--L.vis_short_desc = "Visualizes a crime scene if the victim died by a gunshot wound"
--L.corpse_binoculars = "Press [{key}] to search corpse with binoculars."
--L.binoc_progress = "Search progress: {progress}%"

--L.pickup_no_room = "You have no space in your inventory for this weapon kind."
--L.pickup_fail = "You cannot pick up this weapon."
--L.pickup_pending = "You already picked up a weapon, wait until you receive it."

-- 2020-01-07
--L.tbut_help_admin = "Edit traitor button settings"
--L.tbut_role_toggle = "[{walkkey} + {usekey}] to toggle this button for {role}"
--L.tbut_role_config = "Role: {current}"
--L.tbut_team_toggle = "[SHIFT + {walkkey} + {usekey}] to toggle this button for team {team}"
--L.tbut_team_config = "Team: {current}"
--L.tbut_current_config = "Current config:"
--L.tbut_intended_config = "Intended config by map creator:"
--L.tbut_admin_mode_only = "You see this button because you're an admin and '{cv}' is set to '1'."
--L.tbut_allow = "Allow"
--L.tbut_prohib = "Prohibit"
--L.tbut_default = "Default"

-- 2020-02-09
--L.name_door = "Door"
--L.door_open = "Press [{usekey}] to open door."
--L.door_close = "Press [{usekey}] to close door."
--L.door_locked = "This door is locked."

-- 2020-02-11
--L.automoved_to_spec = "(AUTOMATED MESSAGE) I have been moved to the Spectator team because I was idle/AFK."
--L.mute_team = "{team} muted."

-- 2020-02-16
--L.door_auto_closes = "This door closes automatically."
--L.door_open_touch = "Walk into door to open."
--L.door_open_touch_and_use = "Walk into door or press [{usekey}] to open."

-- 2020-03-09
L.help_title = "Hjälp och Inställningar"

--L.menu_changelog_title = "Changelog"
--L.menu_guide_title = "TTT2 Guide"
--L.menu_bindings_title = "Key Bindings"
--L.menu_language_title = "Language"
--L.menu_appearance_title = "Appearance"
--L.menu_gameplay_title = "Gameplay"
--L.menu_addons_title = "Addons"
--L.menu_legacy_title = "Legacy Addons"
--L.menu_administration_title = "Administration"
--L.menu_equipment_title = "Edit Equipment"
--L.menu_shops_title = "Edit Shops"

--L.menu_changelog_description = "A list of changes and fixes in recent versions."
--L.menu_guide_description = "Helps you to get started with TTT2 and explains some things about gameplay, roles and other stuff."
--L.menu_bindings_description = "Bind specific features of TTT2 and its addons to your own liking."
--L.menu_language_description = "Select the language of the gamemode."
--L.menu_appearance_description = "Tweak the appearance and performance of the UI."
--L.menu_gameplay_description = "Tweak voice and sound volume, accessibility settings, and gameplay settings."
--L.menu_addons_description = "Configure local addons to your liking."
--L.menu_legacy_description = "A panel with converted tabs from the original TTT that should be ported over to the new system."
--L.menu_administration_description = "General settings for HUDs, shops etc."
--L.menu_equipment_description = "Set credits, limitations, availability and other stuff."
--L.menu_shops_description = "Add/Remove shops for roles and configure what equipment they have."

--L.submenu_guide_gameplay_title = "Gameplay"
--L.submenu_guide_roles_title = "Roles"
--L.submenu_guide_equipment_title = "Equipment"

--L.submenu_bindings_bindings_title = "Bindings"

--L.submenu_language_language_title = "Language"

--L.submenu_appearance_general_title = "General"
--L.submenu_appearance_hudswitcher_title = "HUD Switcher"
--L.submenu_appearance_vskin_title = "VSkin"
--L.submenu_appearance_targetid_title = "TargetID"
--L.submenu_appearance_shop_title = "Shop Settings"
--L.submenu_appearance_crosshair_title = "Crosshair"
--L.submenu_appearance_dmgindicator_title = "Damage Indicator"
--L.submenu_appearance_performance_title = "Performance"
--L.submenu_appearance_interface_title = "Interface"

--L.submenu_gameplay_general_title = "General"

--L.submenu_administration_hud_title = "HUD Settings"
--L.submenu_administration_randomshop_title = "Random Shop"

--L.help_color_desc = "If this setting is enabled, you can choose a global color that will be used for the targetID outline and the crosshair."
--L.help_scale_factor = "This scale factor influences all UI elements (HUD, VGUI and TargetID). It is automatically updated if the screen resolution is changed. Changing this value will reset the HUD!"
--L.help_hud_game_reload = "The HUD is not available right now. Reconnect to the server or relaunch the game."
--L.help_hud_special_settings = "These are specific settings of this HUD."
--L.help_vskin_info = "VSkin (VGUI skin) is the skin applied to all menu elements like the current one. They can be easily created with a simple Lua script and can change colors and some size parameters."
--L.help_targetid_info = "TargetID is the information rendered when pointing your crosshair at an entity. Its color can be configured in the 'General' tab."
--L.help_hud_default_desc = "Sets the default HUD for all players. Players that have not yet selected a HUD will receive this HUD as their default. Changing this won't change the HUD for players that have already selected their HUD."
--L.help_hud_forced_desc = "Forces a HUD for all players. This disables the HUD selection feature for everyone."
--L.help_hud_enabled_desc = "Enable/Disable HUDs to restrict the selection of these HUDs."
--L.help_damage_indicator_desc = "The damage indicator is the overlay shown when the player is damaged. To add a new theme, place a png in 'materials/vgui/ttt/damageindicator/themes/'."
--L.help_shop_key_desc = "Open the shop by pressing the shop key instead of the score menu during preparing / at the end of a round?"

--L.label_menu_menu = "MENU"
--L.label_menu_admin_spacer = "Admin Area (not shown to normal users)"
--L.label_language_set = "Select language"
--L.label_global_color_enable = "Enable global color"
--L.label_global_color = "Global color"
--L.label_global_scale_factor = "Global scale factor"
--L.label_hud_select = "Select HUD"
--L.label_vskin_select = "Select VSkin"
--L.label_blur_enable = "Enable VSkin background blur"
--L.label_color_enable = "Enable VSkin background color"
--L.label_minimal_targetid = "Minimalist Target ID under crosshair (no Karma text, hints etc.)"
--L.label_shop_always_show = "Always show the shop"
--L.label_shop_double_click_buy = "Enable an item purchase by double-clicking on it in the shop"
--L.label_shop_num_col = "Number of columns"
--L.label_shop_num_row = "Number of rows"
--L.label_shop_item_size = "Icon size"
--L.label_shop_show_slot = "Show slot marker"
--L.label_shop_show_custom = "Show custom item marker"
--L.label_shop_show_fav = "Show favourite item marker"
--L.label_crosshair_enable = "Enable crosshair"
--L.label_crosshair_opacity = "Crosshair opacity"
--L.label_crosshair_ironsight_opacity = "Ironsight crosshair opacity"
--L.label_crosshair_size = "Crosshair line size multiplier"
--L.label_crosshair_thickness = "Crosshair thickness multiplier"
--L.label_crosshair_thickness_outline = "Crosshair outline thickness multiplier"
--L.label_crosshair_scale_enable = "Enable dynamic crosshair scale"
--L.label_crosshair_ironsight_low_enabled = "Lower weapon when using ironsights"
--L.label_damage_indicator_enable = "Enable damage indicator"
--L.label_damage_indicator_mode = "Select damage indicator theme"
--L.label_damage_indicator_duration = "Fade time after getting hit (in seconds)"
--L.label_damage_indicator_maxdamage = "Damage needed for the maximum opacity"
--L.label_damage_indicator_maxalpha = "Maximum opacity"
--L.label_performance_halo_enable = "Draw an outline around some entities while looking at them"
--L.label_performance_spec_outline_enable = "Enable controlled objects' outlines"
--L.label_performance_ohicon_enable = "Enable role icons over players' heads"
--L.label_interface_tips_enable = "Show gameplay tips at the bottom of the screen while spectating"
--L.label_interface_popup = "Start of round info popup duration"
--L.label_interface_fastsw_menu = "Enable menu with fast weapon switch"
--L.label_inferface_wswitch_hide_enable = "Enable weapon switch menu auto-closing"
--L.label_inferface_scues_enable = "Play sound cue when a round begins or ends"
--L.label_gameplay_specmode = "Spectate-only mode (always stay spectator)"
--L.label_gameplay_fastsw = "Fast weapon switch"
--L.label_gameplay_hold_aim = "Enable hold to aim"
--L.label_gameplay_mute = "Mute living players when dead"
--L.label_hud_default = "Default HUD"
--L.label_hud_force = "Forced HUD"

--L.label_bind_voice = "Global Voice Chat"
--L.label_bind_voice_team = "Team Voice Chat"

--L.label_hud_basecolor = "Base Color"

--L.label_menu_not_populated = "This submenu does not contain any content."

--L.header_bindings_ttt2 = "TTT2 Bindings"
--L.header_bindings_other = "Other Bindings"
--L.header_language = "Language Settings"
--L.header_global_color = "Select Global Color"
--L.header_hud_select = "Select a HUD"
--L.header_hud_customize = "Customize the HUD"
--L.header_vskin_select = "Select and Customize the VSkin"
--L.header_targetid = "TargetID Settings"
--L.header_shop_settings = "Equipment Shop Settings"
--L.header_shop_layout = "Item List Layout"
--L.header_shop_marker = "Item Marker Settings"
--L.header_crosshair_settings = "Crosshair Settings"
--L.header_damage_indicator = "Damage Indicator Settings"
--L.header_performance_settings = "Performance Settings"
--L.header_interface_settings = "Interface Settings"
--L.header_gameplay_settings = "Gameplay Settings"
--L.header_hud_administration = "Select Default and Forced HUDs"
--L.header_hud_enabled = "Enable/Disable HUDs"

--L.button_menu_back = "Back"
--L.button_none = "None"
--L.button_press_key = "Press a key"
--L.button_save = "Save"
--L.button_reset = "Reset"
--L.button_close = "Close"
--L.button_hud_editor = "HUD Editor"

-- 2020-04-20
--L.item_speedrun = "Speedrun"
--L.item_speedrun_desc = [[Makes you 50% faster!]]
--L.item_no_explosion_damage = "No Explosion Damage"
--L.item_no_explosion_damage_desc = [[Makes you immune to explosion damage.]]
--L.item_no_fall_damage = "No Fall Damage"
--L.item_no_fall_damage_desc = [[Makes you immune to fall damage.]]
--L.item_no_fire_damage = "No Fire Damage"
--L.item_no_fire_damage_desc = [[Makes you immune to fire damage.]]
--L.item_no_hazard_damage = "No Hazard Damage"
--L.item_no_hazard_damage_desc = [[Makes you immune to hazard damage such as poison, radiation and acid.]]
--L.item_no_energy_damage = "No Energy Damage"
--L.item_no_energy_damage_desc = [[Makes you immune to energy damage such as lasers, plasma and lightning.]]
--L.item_no_prop_damage = "No Prop Damage"
--L.item_no_prop_damage_desc = [[Makes you immune to prop damage.]]
--L.item_no_drown_damage = "No Drowning Damage"
--L.item_no_drown_damage_desc = [[Makes you immune to drowning damage.]]

-- 2020-04-21
--L.dna_tid_possible = "Scan possible."
--L.dna_tid_impossible = "No scan possible."
--L.dna_screen_ready = "No DNA"
--L.dna_screen_match = "Match"

-- 2020-04-30
--L.message_revival_canceled = "Revival canceled."
--L.message_revival_failed = "Revival failed."
--L.message_revival_failed_missing_body = "You have not been revived because your corpse no longer exists."
--L.hud_revival_title = "Time left until revival:"
--L.hud_revival_time = "{time}s"

-- 2020-05-03
--L.door_destructible = "This door is destructible ({health}HP)."

-- 2020-05-28
--L.corpse_hint_inspect_limited = "Press [{usekey}] to search. [{walkkey} + {usekey}] to only view search UI."

-- 2020-06-04
--L.label_bind_disguiser = "Toggle disguiser"

-- 2020-06-24
--L.dna_help_primary = "Collect a DNA sample"
--L.dna_help_secondary = "Switch the DNA slot"
--L.dna_help_reload = "Delete a sample"

--L.binoc_help_pri = "Search a body."
--L.binoc_help_sec = "Change zoom level."

--L.vis_help_pri = "Drop the activated device."


-- 2020-08-07
--L.pickup_error_spec = "You cannot pick this up as a spectator."
--L.pickup_error_owns = "You cannot pick this up because you already have this weapon."
--L.pickup_error_noslot = "You cannot pick this up because you have no free slot available."

-- 2020-11-02
--L.lang_server_default = "Server Default"
--L.help_lang_info = [[
--This translation is {coverage}% complete with the English language taken as a default reference.
--
--Keep in mind that these translations are made by the community. Feel free to contribute if something is missing or incorrect.]]

-- 2021-04-13
--L.title_score_info = "Round End Info"
--L.title_score_events = "Event Timeline"

--L.label_bind_clscore = "Open round report"
--L.title_player_score = "{player}'s score:"

--L.label_show_events = "Show events from"
--L.button_show_events_you = "You"
--L.button_show_events_global = "Global"
--L.label_show_roles = "Show role distribution from"
--L.button_show_roles_begin = "Round Begin"
--L.button_show_roles_end = "Round End"

L.hilite_win_traitors = "FÖRRÄDISK VINST"
--L.hilite_win_innocents = "TEAM INNOCENT WON"
--L.hilite_win_tie = "IT IS A TIE"
--L.hilite_win_time = "TIME IS UP"

--L.tooltip_karma_gained = "Karma changes for this round:"
--L.tooltip_score_gained = "Score changes for this round:"
--L.tooltip_roles_time = "Role changes for this round:"

--L.tooltip_finish_score_alive_teammates = "Alive teammates: {score}"
--L.tooltip_finish_score_alive_all = "Alive players: {score}"
--L.tooltip_finish_score_timelimit = "Time is up: {score}"
--L.tooltip_finish_score_dead_enemies = "Dead enemies: {score}"
--L.tooltip_kill_score = "Kill: {score}"
--L.tooltip_bodyfound_score = "Body found: {score}"

--L.finish_score_alive_teammates = "Alive teammates:"
--L.finish_score_alive_all = "Alive players:"
--L.finish_score_timelimit = "Time is up:"
--L.finish_score_dead_enemies = "Dead enemies:"
--L.kill_score = "Kill:"
--L.bodyfound_score = "Body found:"

--L.title_event_bodyfound = "A body was found"
--L.title_event_c4_disarm = "A C4 was disarmed"
--L.title_event_c4_explode = "A C4 exploded"
--L.title_event_c4_plant = "A C4 was armed"
--L.title_event_creditfound = "Equipment credits were found"
--L.title_event_finish = "The round has ended"
--L.title_event_game = "A new round has started"
--L.title_event_kill = "A player was killed"
--L.title_event_respawn = "A player respawned"
--L.title_event_rolechange = "A player changed their role or team"
--L.title_event_selected = "The roles were distributed"
--L.title_event_spawn = "A player spawned"

--L.desc_event_bodyfound = "{finder} ({firole} / {fiteam}) has found the body of {found} ({forole} / {foteam}). The corpse has {credits} equipment credit(s)."
--L.desc_event_bodyfound_headshot = "The victim was killed by a headshot."
--L.desc_event_c4_disarm_success = "{disarmer} ({drole} / {dteam}) successfully disarmed the C4 armed by {owner} ({orole} / {oteam})."
--L.desc_event_c4_disarm_failed = "{disarmer} ({drole} / {dteam}) tried to disarm the C4 armed by {owner} ({orole} / {oteam}). They failed."
--L.desc_event_c4_explode = "The C4 armed by {owner} ({role} / {team}) exploded."
--L.desc_event_c4_plant = "{owner} ({role} / {team}) armed an explosive C4."
--L.desc_event_creditfound = "{finder} ({firole} / {fiteam}) has found {credits} equipment credit(s) in the corpse of {found} ({forole} / {foteam})."
--L.desc_event_finish = "The round lasted {minutes}:{seconds}. There were {alive} player(s) alive in the end."
--L.desc_event_game = "A new round has started."
--L.desc_event_respawn = "{player} has respawned."
--L.desc_event_rolechange = "{player} changed their role/team from {orole} ({oteam}) to {nrole} ({nteam})."
--L.desc_event_selected = "The teams and roles were distributed for all {amount} player(s)."
--L.desc_event_spawn = "{player} has spawned."

-- Name of a trap that killed us that has not been named by the mapper
--L.trap_something = "something"

-- Kill events
--L.desc_event_kill_suicide = "It was suicide."
--L.desc_event_kill_team = "It was a team kill."

--L.desc_event_kill_blowup = "{victim} ({vrole} / {vteam}) blew themselves up."
--L.desc_event_kill_blowup_trap = "{victim} ({vrole} / {vteam}) was blown up by {trap}."

--L.desc_event_kill_tele_self = "{victim} ({vrole} / {vteam}) telefragged themselves."
--L.desc_event_kill_sui = "{victim} ({vrole} / {vteam}) couldn't take it and killed themselves."
--L.desc_event_kill_sui_using = "{victim} ({vrole} / {vteam}) killed themselves using {tool}."

--L.desc_event_kill_fall = "{victim} ({vrole} / {vteam}) fell to their death."
--L.desc_event_kill_fall_pushed = "{victim} ({vrole} / {vteam}) fell to their death after {attacker} pushed them."
--L.desc_event_kill_fall_pushed_using = "{victim} ({vrole} / {vteam}) fell to their death after {attacker} ({arole} / {ateam}) used {trap} to push them."

--L.desc_event_kill_shot = "{victim} ({vrole} / {vteam}) was shot by {attacker}."
--L.desc_event_kill_shot_using = "{victim} ({vrole} / {vteam}) was shot by {attacker} ({arole} / {ateam}) using a {weapon}."

--L.desc_event_kill_drown = "{victim} ({vrole} / {vteam}) was drowned by {attacker}."
--L.desc_event_kill_drown_using = "{victim} ({vrole} / {vteam}) was drowned by {trap} triggered by {attacker} ({arole} / {ateam})."

--L.desc_event_kill_boom = "{victim} ({vrole} / {vteam}) was exploded by {attacker}."
--L.desc_event_kill_boom_using = "{victim} ({vrole} / {vteam}) was blown up by {attacker} ({arole} / {ateam}) using {trap}."

--L.desc_event_kill_burn = "{victim} ({vrole} / {vteam}) was fried by {attacker}."
--L.desc_event_kill_burn_using = "{victim} ({vrole} / {vteam}) was burned by {trap} due to {attacker} ({arole} / {ateam})."

--L.desc_event_kill_club = "{victim} ({vrole} / {vteam}) was beaten up by {attacker}."
--L.desc_event_kill_club_using = "{victim} ({vrole} / {vteam}) was pummeled to death by {attacker} ({arole} / {ateam}) using {trap}."

--L.desc_event_kill_slash = "{victim} ({vrole} / {vteam}) was stabbed by {attacker}."
--L.desc_event_kill_slash_using = "{victim} ({vrole} / {vteam}) was cut up by {attacker} ({arole} / {ateam}) using {trap}."

--L.desc_event_kill_tele = "{victim} ({vrole} / {vteam}) was telefragged by {attacker}."
--L.desc_event_kill_tele_using = "{victim} ({vrole} / {vteam}) was atomized by {trap} set by {attacker} ({arole} / {ateam})."

--L.desc_event_kill_goomba = "{victim} ({vrole} / {vteam}) was crushed by the massive bulk of {attacker} ({arole} / {ateam})."

--L.desc_event_kill_crush = "{victim} ({vrole} / {vteam}) was crushed by {attacker}."
--L.desc_event_kill_crush_using = "{victim} ({vrole} / {vteam}) was crushed by {trap} of {attacker} ({arole} / {ateam})."

--L.desc_event_kill_other = "{victim} ({vrole} / {vteam}) was killed by {attacker}."
--L.desc_event_kill_other_using = "{victim} ({vrole} / {vteam}) was killed by {attacker} ({arole} / {ateam}) using {trap}."

-- 2021-04-20
--L.none = "No Role"

-- 2021-04-24
--L.karma_teamkill_tooltip = "Teammate killed"
--L.karma_teamhurt_tooltip = "Teammate damaged"
--L.karma_enemykill_tooltip = "Enemy killed"
--L.karma_enemyhurt_tooltip = "Enemy damaged"
--L.karma_cleanround_tooltip = "Clean round"
--L.karma_roundheal_tooltip = "Karma restoration"
--L.karma_unknown_tooltip = "Unknown"

-- 2021-05-07
--L.header_random_shop_administration = "Random Shop Settings"
--L.header_random_shop_value_administration = "Balance Settings"

--L.shopeditor_name_random_shops = "Enable random shops"
--L.shopeditor_desc_random_shops = [[Random shops give every player a limited randomized set of all available equipments.
--Team shops forcefully give the same set to all players in a team instead of individual ones.
--Rerolling allows you to get a new randomized set of equipment for credits.]]
--L.shopeditor_name_random_shop_items = "Number of random equipments"
--L.shopeditor_desc_random_shop_items = "This includes equipments, which are marked with \"Always available in shop\". So choose a high enough number or you only get those."
--L.shopeditor_name_random_team_shops = "Enable team shops"
--L.shopeditor_name_random_shop_reroll = "Enable shop reroll availability"
--L.shopeditor_name_random_shop_reroll_cost = "Cost per reroll"
--L.shopeditor_name_random_shop_reroll_per_buy = "Auto reroll after buy"

-- 2021-06-04
--L.header_equipment_setup = "Equipment Settings"
--L.header_equipment_value_setup = "Balance Settings"

--L.equipmenteditor_name_not_buyable = "Can be bought"
--L.equipmenteditor_desc_not_buyable = "If disabled the equipment will not show in the shop. Roles that have this equipment assigned will still receive it."
--L.equipmenteditor_name_not_random = "Always available in shop"
--L.equipmenteditor_desc_not_random = "If enabled, the equipment is always available in the shop. When the random shop is enabled, it takes one available random slot and always reserves it for this equipment."
--L.equipmenteditor_name_global_limited = "Global limited amount"
--L.equipmenteditor_desc_global_limited = "If enabled, the equipment can be bought only once on the server in the active round."
--L.equipmenteditor_name_team_limited = "Team limited amount"
--L.equipmenteditor_desc_team_limited = "If enabled, the equipment can be bought only once per team in the active round."
--L.equipmenteditor_name_player_limited = "Player limited amount"
--L.equipmenteditor_desc_player_limited = "If enabled, the equipment can be bought only once per player in the active round."
--L.equipmenteditor_name_min_players = "Minimum amount of players for buying"
--L.equipmenteditor_name_credits = "Price in credits"

-- 2021-06-08
--L.equip_not_added = "not added"
--L.equip_added = "added"
--L.equip_inherit_added = "added (inherit)"
--L.equip_inherit_removed = "removed (inherit)"

-- 2021-06-09
--L.layering_not_layered = "Not layered"
--L.layering_layer = "Layer {layer}"
--L.header_rolelayering_role = "{role} layering"
--L.header_rolelayering_baserole = "Base role layering"
--L.submenu_administration_rolelayering_title = "Role Layering"
--L.header_rolelayering_info = "Role layering information"
--L.help_rolelayering_roleselection = "The role distribution process is split into two stages. In the first stage base roles are distributed, which are innocent, traitor and those listed in the 'base role layer' box below. The second stage is used to upgrade those base roles to a subrole."
--L.help_rolelayering_layers = "From each layer only one role is selected. First the roles from the custom layers are distributed starting from the first layer until the last is reached or no more roles can be upgraded. Whichever happens first, if upgradeable slots are still available, the unlayered roles will be distributed as well."
--L.scoreboard_voice_tooltip = "Scroll to change the volume"

-- 2021-06-15
--L.header_shop_linker = "Settings"
--L.label_shop_linker_set = "Select shop type:"

-- 2021-06-18
--L.xfer_team_indicator = "Team"

-- 2021-06-25
--L.searchbar_default_placeholder = "Search in list..."

-- 2021-07-11
--L.spec_about_to_revive = "Spectating is limited during revival period."

-- 2021-09-01
--L.spawneditor_name = "Spawn Editor Tool"
--L.spawneditor_desc = "Used to place weapon, ammo and player spawns in the world. Can only be used by super admin."

--L.spawneditor_place = "Place spawn"
--L.spawneditor_remove = "Remove spawn"
--L.spawneditor_change = "Change spawn type (hold [SHIFT] to reverse)"
--L.spawneditor_ammo_edit = "Hold on weapon spawn to edit autospawning ammo"

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

--L.spawn_weapon_ammo = "(Ammo: {ammo})"

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
--L.label_dynamic_spawns_global_enable = "Enable dynamic spawns for all maps"

--L.header_equipment_weapon_spawn_setup = "Weapon Spawn Settings"

--L.help_spawn_editor_info = [[
--The spawn editor is used to place, remove and edit spawns in the world. These spawns are for weapons, ammunition and players.
--
--These spawns are saved in files located in 'data/ttt/weaponspawnscripts/'. They can be deleted for a hard reset. The initial spawn files are created from spawns found on the map and in the original TTT weapon spawn scripts. Pressing the reset button always reverts to the initial state.
--
--It should be noted that this spawn system uses dynamic spawns. This is most interesting for weapons because it no longer defines a specific weapon, but a type of weapons. For example instead of a TTT shotgun spawn, there is now a general shotgun spawn where any weapon defined as shotgun can spawn. The spawn type for each weapon can be set in the 'Edit Equipment' menu. This makes it possible for any weapon to spawn on the map, or to disable certain default weapons.
--
--Keep in mind that many changes only take effect after a new round has started.]]
--L.help_spawn_editor_enable = "On some maps it might be advised to use the original spawns found on the map without replacing them with the dynamic system. Changing this option below only affects the currently active map, so the dynamic system will still be used for every other map."
--L.help_spawn_editor_hint = "Hint: To leave the spawn editor, reopen the gamemode menu."
--L.help_spawn_editor_spawn_amount = [[
--There currently are {weapon} weapon spawns, {ammo} ammunition spawns and {player} player spawns on this map.
--Click 'start spawn edit' to change this amount.
--
--{weaponrandom}x Random weapon spawn
--{weaponmelee}x Melee weapon spawn
--{weaponnade}x Grenade weapon spawn
--{weaponshotgun}x Shotgun weapon spawn
--{weaponheavy}x Heavy weapon spawn
--{weaponsniper}x Sniper weapon spawn
--{weaponpistol}x Pistol weapon spawn
--{weaponspecial}x Special weapon spawn
--
--{ammorandom}x Random ammo spawn
--{ammodeagle}x Deagle ammo spawn
--{ammopistol}x Pistol ammo spawn
--{ammomac10}x Mac10 ammo spawn
--{ammorifle}x Rifle ammo spawn
--{ammoshotgun}x Shotgun ammo spawn
--
--{playerrandom}x Random player spawn]]

--L.equipmenteditor_name_auto_spawnable = "Equipment spawns randomly in world"
--L.equipmenteditor_name_spawn_type = "Select spawn type"
--L.equipmenteditor_desc_auto_spawnable = [[
--The TTT2 spawn system allows every weapon to spawn in the world. By default only weapons marked as 'AutoSpawnable' by the creator will spawn in the world, however this can be changed from within this menu.
--
--Most of the equipment is set to 'special weapon spawns' by default. This means that equipment only spawns on random weapon spawns. However it is possible to place special weapon spawns in the world or change the spawn type here to use other existing spawn types.]]

--L.pickup_error_inv_cached = "You cannot pick this up right now because your inventory is cached."

-- 2021-09-02
--L.submenu_administration_playermodels_title = "Player Models"
--L.header_playermodels_general = "General Player Model Settings"
--L.header_playermodels_selection = "Select Player Model Pool"

--L.label_enforce_playermodel = "Enforce role player model"
--L.label_use_custom_models = "Use a randomly selected player model"
--L.label_prefer_map_models = "Prefer map specific models over default models"
--L.label_select_model_per_round = "Select a new random model each round (only on map change if disabled)"

--L.help_prefer_map_models = [[
--Some maps define their own player models. By default these models have a higher priority than those that are assigned automatically. By disabling this setting, map specific models are disabled.
--
--Role specific models always have a higher priority and are unaffected by this setting.]]
--L.help_enforce_playermodel = [[
--Some roles have custom player models. They can be disabled which can be relevant for compatibility with some player model selectors.
--Random default models can still be selected, if this setting is disabled.]]
--L.help_use_custom_models = [[
--By default only the CS:S Phoenix player model is assigned to all players. By enabling this option however it is possible to select a player model pool. With this setting enabled each player will still be assigned the same player model, however it is a random model from the defined model pool.
--
--This selection of models can be extended by installing more player models.]]

-- 2021-10-06
--L.menu_server_addons_title = "Server Addons"
--L.menu_server_addons_description = "Server-wide admin only settings for addons."

--L.tooltip_finish_score_penalty_alive_teammates = "Alive teammates penalty: {score}"
--L.finish_score_penalty_alive_teammates = "Alive teammates penalty:"
--L.tooltip_kill_score_suicide = "Suicide: {score}"
--L.kill_score_suicide = "Suicide:"
--L.tooltip_kill_score_team = "Team kill: {score}"
--L.kill_score_team = "Team kill:"

-- 2021-10-09
--L.help_models_select = [[
--Left click on the models to add them to the player model pool. Left click again to remove them. Right clicking toggles between enabled and disabled detective hats for the focused model.
--
--The small indicator in the top left shows if the player model has a head hitbox. The icon below shows if this model is applicable for a detective hat.]]

--L.menu_roles_title = "Role Settings"
--L.menu_roles_description = "Set up the spawning, equipment credits and more."

--L.submenu_administration_roles_general_title = "General Role Settings"

--L.header_roles_info = "Role Information"
--L.header_roles_selection = "Role Selection Parameters"
--L.header_roles_tbuttons = "Traitor Buttons Access"
--L.header_roles_credits = "Role Equipment Credits"
--L.header_roles_additional = "Additional Role Settings"
--L.header_roles_reward_credits = "Reward Equipment Credits"

--L.help_roles_default_team = "Default team: {team}"
--L.help_roles_unselectable = "This role is not distributable. It is not considered in the role distribution process. Most of the times this means that this is a role that is manually assigned during the round through an event like a revival, a sidekick deagle or something similar."
--L.help_roles_selectable = "This role is distributable. If all criteria is met, this role is considered in the role distribution process."
--L.help_roles_credits = "Equipment credits are used to buy equipment in the shop. It mostly makes sense to give them only for those roles that have access to the shops. However, since it is possible to find credits on corpses, you can also give starting credits to roles as a reward to their killer."
--L.help_roles_selection_short = "The role distribution per player defines the percentage of players that are assigned this role. For example, if the value is set to '0.2' every fifth player receives this role."
--L.help_roles_selection = [[
--The role distribution per player defines the percentage of players that are assigned this role. For example, if the value is set to '0.2' every fifth player receives this role. This also means that at least 5 players are needed for this role to be distributed at all.
--Keep in mind that all of this only applies if the role is considered for distribution process.
--
--The aforementioned role distribution has a special integration with the lower limit of players. If the role is considered for distribution and the minimum value is below the value given by the distribution factor, but the amount of players is equal or greater than the lower limit, a single player can still receive this role. The distribution process then works as usual for the second player.]]
--L.help_roles_award_info = "Some roles (if enabled in their credits settings) receive equipment credits if a certain percentage of enemies has died. Related values can be tweaked here."
--L.help_roles_award_pct = "When this percentage of enemies are dead, specific roles are awarded equipment credits."
--L.help_roles_award_repeat = "Whether the credit award is handed out multiple times. For example, if the percentage is set to '0.25', and this setting is enabled, players will be awarded credits at '25%', '50%' and '75%' dead enemies respectively."
--L.help_roles_advanced_warning = "WARNING: These are advanced settings that can completely mess up the role distribution process. When in doubt keep all values at '0'. This value means that no limits are applied and the role distribution will try to assign as many roles as possible."
--L.help_roles_max_roles = [[
--The term roles here includes both the base roles and the subroles. By default, there is no limit on how many different roles can be assigned. However, here are two different ways to limit them.
--
--1. Limit them by a fixed amount.
--2. Limit them by a percentage.
--
--The latter is only used if the fixed amount is '0' and sets an upper limit based on the set percentage of available players.]]
--L.help_roles_max_baseroles = [[
--Base roles are only those roles others inherit from. For example, the Innocent role is a base role, while a Pharaoh is a subrole of this role. By default, there is no limit on how many different base roles can be assigned. However, here are two different ways to limit them.
--
--1. Limit them by a fixed amount.
--2. Limit them by a percentage.
--
--The latter is only used if the fixed amount is '0' and sets an upper limit based on the set percentage of available players.]]

--L.label_roles_enabled = "Enable role"
--L.label_roles_min_inno_pct = "Innocent distribution per player"
--L.label_roles_pct = "Role distribution per player"
--L.label_roles_max = "Upper limit of players assigned for this role"
--L.label_roles_random = "Chance this role is distributed"
--L.label_roles_min_players = "Lower limit of players to consider distribution"
--L.label_roles_tbutton = "Role can use Traitor buttons"
--L.label_roles_credits_starting = "Starting credits"
--L.label_roles_credits_award_pct = "Credit reward percentage"
--L.label_roles_credits_award_size = "Credit reward size"
--L.label_roles_credits_award_repeat = "Credit reward repeat"
--L.label_roles_newroles_enabled = "Enable custom roles"
--L.label_roles_max_roles = "Upper role limit"
--L.label_roles_max_roles_pct = "Upper role limit by percentage"
--L.label_roles_max_baseroles = "Upper base role limit"
--L.label_roles_max_baseroles_pct = "Upper base role limit by percentage"
--L.label_detective_hats = "Enable hats for policing roles like the Detective (if player model allows to have them)"

--L.ttt2_desc_innocent = "An Innocent has no special abilities. They have to find the evil ones among the terrorists and kill them. But they have to be careful not to kill their teammates."
--L.ttt2_desc_traitor = "The Traitor is the enemy of the Innocent. They have an equipment menu with which they are being able to buy special equipment. They have to kill everyone but their teammates."
--L.ttt2_desc_detective = "The Detective is the one whom the Innocents can trust. But who even is an Innocent? The mighty Detective has to find all the evil terrorists. The equipment in their shop may help them with this task."

-- 2021-10-10
--L.button_reset_models = "Reset Player Models"

-- 2021-10-13
--L.help_roles_credits_award_kill = "Another way of gaining credits is by killing high value players with a 'public role' such as a Detective. If the killer's role has this enabled, they gain the below defined amount of credits."
--L.help_roles_credits_award = [[
--There are two different ways to be awarded credits in base TTT2:
--
--1. If a certain percentage of the enemy team is dead, the whole team is awarded credits.
--2. If a player killed a high value player with a 'public role' such as a Detective, the killer is awarded credits.
--
--Please note, that this still can be enabled/disabled for every role, even if the whole team is awarded. For example, if team Innocent is awarded, but the Innocent role has this disabled, only the Detective will receive their credits.
--The balancing values for this feature can be set in 'Administration' -> 'General Role Settings'.]]
--L.help_detective_hats = [[
--Policing roles such as the Detective may wear hats to show their authority. They lose them on death or if damaged at the head.
--
--Some player models do not support hats by default. This can be changed in 'Administration' -> 'Player Models']]

--L.label_roles_credits_award_kill = "Credit reward amount for the kill"
--L.label_roles_credits_dead_award = "Enable credits award for certain percentage of dead enemies"
--L.label_roles_credits_kill_award = "Enable credits award for high value player kill"
--L.label_roles_min_karma = "Lower limit of Karma to consider distribution"

-- 2021-11-07
--L.submenu_administration_administration_title = "Administration"
--L.submenu_administration_voicechat_title = "Voice chat / Text chat"
--L.submenu_administration_round_setup_title = "Round Settings"
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
--L.header_voicechat_general = "General Voice chat Settings"
--L.header_voicechat_battery = "Voice chat Battery"
--L.header_voicechat_locational = "Proximity Voice chat"
--L.header_playersettings_plyspawn = "Player Spawn Settings"
--L.header_round_setup_prep = "Round: Preparing"
--L.header_round_setup_round = "Round: Active"
--L.header_round_setup_post = "Round: Post"
--L.header_round_setup_map_duration = "Map Session"
--L.header_textchat = "Text chat"
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

--L.help_killer_dna_range = "When a player is killed by another player, a DNA sample is left on their body. The setting below defines the maximum distance in hammer units for DNA samples to be left. If the killer is further away than this value when the victim dies, no sample will be left on the corpse."
--L.help_killer_dna_basetime = "The base time in seconds until a DNA sample decays, if the killer is 0 Hammer units away. The farther the killer is, the less time will be given to the DNA sample to decay."
--L.help_dna_radar = "The TTT2 DNA scanner shows the exact distance and direction of the selected DNA sample if equipped. However, there is also a classic DNA scanner mode that updates the selected sample with an in-world rendering every time the cooldown has passed."
--L.help_idle = "The idle mode is used to forcefully move idle players into the spectator mode. To leave this mode, they will have to disable it in their 'gameplay' menu."
--L.help_namechange_kick = [[
--A name change during an active round could be abused. Therefore, this is prohibited by default and will lead to the offending player being kicked from the server.
--
--If the bantime is greater than 0, the player will be unable to reconnect to the server until that time has passed.]]
--L.help_damage_log = "Each time a player is damaged, a damage log entry is added to the console if enabled. This can also be stored to disk after a round has ended. The file is located at 'data/terrortown/logs/'"
--L.help_spawn_waves = [[
--If this variable is set to 0, all players are spawned at once. For servers with huge amounts of players, it can be beneficial to spawn the players in waves. The spawn wave interval is the time between each spawn wave. A spawn wave always spawns as many players as there are valid spawn points.
--
--Note: Make sure that the preparing time is long enough for the desired amount of spawn waves.]]
--L.help_voicechat_battery = [[
--Voice chatting with enabled voice chat battery reduces battery charge. When it's empty, the player can't use voice chat and has to wait for it to recharge. This can help to prevent excessive voice chat usage.
--
--Note: 'Tick' refers to a game tick. For example, if the tick rate is set to 66, then it will be 1/66th of a second.]]
--L.help_ply_spawn = "Player settings that are used on player (re-)spawn."
--L.help_haste_mode = [[
--Haste mode balances the game by increasing the round time with every dead player. Only roles that see missing in action players can see the real round time. Every other role can only see the haste mode starting time.
--
--If haste mode is enabled, the fixed round time is ignored.]]
--L.help_round_limit = "After one of the set limit conditions is met, a map change is triggered."
--L.help_armor_balancing = "The following values can be used to balance the armor."
--L.help_item_armor_classic = "If classic armor mode is enabled, only the previous settings matter. Classic armor mode means that a player can only buy armor once in a round, and that this armor blocks 30% of the incoming bullet and crowbar damage until they die."
--L.help_item_armor_dynamic = [[
--Dynamic armor is the TTT2 approach to make armor more interesting. The amount of armor that can be bought is now unlimited, and the armor value stacks. Getting damaged decreases the armor value. The armor value per bought armor item is set in the 'Equipment Settings' of said item.
--
--When taking damage, a certain percentage of this damage is converted into armor damage, a different percentage is still applied to the player and the rest vanishes.
--
--If reinforced armor is enabled, the damage applied to the player is decreased by 15% as long as the armor value is above the reinforcement threshold.]]
--L.help_sherlock_mode = "The sherlock mode is the classic TTT mode. If the sherlock mode is disabled, dead bodies can not be confirmed, the scoreboard shows everyone as alive and the spectators can talk to the living players."
--L.help_prop_possession = [[
--Prop possession can be used by spectators to possess props lying in the world and use the slowly recharging 'punch-o-meter' to move said prop around.
--
--The maximum value of the 'punch-o-meter' consists of a possession base value, where the kills/deaths difference clamped inbetween two defined limits is added. The meter slowly recharges over time. The set recharge time is the time needed to recharge a single point in the 'punch-o-meter'.]]
--L.help_karma = "Players start with a certain amount of Karma, and lose it when they damage/kill teammates. The amount they lose is dependent on the Karma of the person they hurt or killed. Lower Karma reduces damage given."
--L.help_karma_strict = "If strict Karma is enabled, the damage penalty increases more quickly as Karma goes down. When it is off, the damage penalty is very low when people stay above 800. Enabling strict mode makes Karma play a larger role in discouraging any unnecessary kills, while disabling it results in a more “loose” game where Karma only hurts players who constantly kill teammates."
--L.help_karma_max = "Setting the value of the max Karma above 1000 doesn't give a damage bonus to players with more than 1000 Karma. It can be used as a Karma buffer."
--L.help_karma_ratio = "The ratio of the damage that is used to compute how much of the victim's Karma is subtracted from the attacker's if both are in the same team. If a team kill happens, a further penalty is applied."
--L.help_karma_traitordmg_ratio = "The ratio of the damage that is used to compute how much of the victim's Karma is added to the attacker's if both are in different teams. If an enemy kill happens, a further bonus is applied."
--L.help_karma_bonus = "There are also two different passive ways to gain Karma during a round. First is a karma restoration which applied to every player at the round end. Then a secondary clean round bonus is given if no teammates were hurt or killed by a player."
--L.help_karma_clean_half = [[
--When a player's Karma is above the starting level (meaning the Karma max has been configured to be higher than that), all their Karma increases will be reduced based on how far their Karma is above that starting level. So it goes up slower the higher it is.
--
--This reduction goes in a curve of exponential decay: initially it's fast, and it slows down as the increment gets smaller. This convar sets at what point the bonus has been halved (so the half-life). With the default value of 0.25, if the starting amount of Karma is 1000 and the max 1500, and a player has Karma 1125 ((1500 - 1000) * 0.25 = 125), then his clean round bonus will be 30 / 2 = 15. So to make the bonus go down faster you’d set this convar lower, to make it go down slower you’d increase it towards 1.]]
--L.help_max_slots = "Sets the maximum amount of weapons per slot. '-1' means that there is no limit."
--L.help_item_armor_value = "This is the armor value given by the armor item in dynamic mode. If classic mode is enabled (see 'Administration' -> 'Player Settings') then every value greater than 0 is counted as existing armor."

--L.label_killer_dna_range = "Max kill range to leave DNA"
--L.label_killer_dna_basetime = "Sample life base time"
--L.label_dna_scanner_slots = "DNA sample slots"
--L.label_dna_radar = "Enable classic DNA scanner mode"
--L.label_dna_radar_cooldown = "DNA scanner cooldown"
--L.label_radar_charge_time = "Recharge time after being used"
--L.label_crowbar_shove_delay = "Cooldown after crowbar push"
--L.label_idle = "Enable idle mode"
--L.label_idle_limit = "Maximum idle time in seconds"
--L.label_namechange_kick = "Enable name change kick"
--L.label_namechange_bantime = "Banned time in minutes after kick"
--L.label_log_damage_for_console = "Enable damage logging in console"
--L.label_damagelog_save = "Save damage log to disk"
--L.label_debug_preventwin = "Prevent any win condition [debug]"
--L.label_bots_are_spectators = "Bots are always spectators"
--L.label_tbutton_admin_show = "Show traitor buttons to admins"
--L.label_ragdoll_carrying = "Enable ragdoll carrying"
--L.label_prop_throwing = "Enable prop throwing"
--L.label_weapon_carrying = "Enable weapon carrying"
--L.label_weapon_carrying_range = "Weapon carry range"
--L.label_prop_carrying_force = "Prop pickup force"
--L.label_teleport_telefrags = "Kill blocking player(s) when teleporting (telefrag)"
--L.label_allow_discomb_jump = "Allow disco jump for grenade thrower"
--L.label_spawn_wave_interval = "Spawn wave interval in seconds"
--L.label_voice_enable = "Enable voice chat"
--L.label_voice_drain = "Enable the voice chat battery feature"
--L.label_voice_drain_normal = "Drain per tick for normal players"
--L.label_voice_drain_admin = "Drain per tick for admins and public policing roles"
--L.label_voice_drain_recharge = "Recharge rate per tick of not voice chatting"
--L.label_locational_voice = "Enable proximity voice chat for living players"
--L.label_locational_voice_prep = "Enable proximity voice chat during preparing phase"
--L.label_locational_voice_range = "Proximity voice chat range"
--L.label_armor_on_spawn = "Player armor on (re-)spawn"
--L.label_prep_respawn = "Enable instant respawn during preparing phase"
--L.label_preptime_seconds = "Preparing time in seconds"
--L.label_firstpreptime_seconds = "First preparing time in seconds"
--L.label_roundtime_minutes = "Fixed round time in minutes"
--L.label_haste = "Enable haste mode"
--L.label_haste_starting_minutes = "Haste mode starting time in minutes"
--L.label_haste_minutes_per_death = "Additional time in minutes per death"
--L.label_posttime_seconds = "Postround time in seconds"
--L.label_round_limit = "Upper limit of rounds"
--L.label_time_limit_minutes = "Upper limit of playtime in minutes"
--L.label_nade_throw_during_prep = "Enable grenade throwing during preparing time"
--L.label_postround_dm = "Enable deathmatch after round ended"
--L.label_session_limits_enabled = "Enable session limits"
--L.label_spectator_chat = "Enable spectators chatting with everybody"
--L.label_lastwords_chatprint = "Print last words to chat if killed while typing"
--L.label_identify_body_woconfirm = "Identify corpse without pressing the 'confirm' button"
--L.label_announce_body_found = "Announce that a body was found when the body was confirmed"
--L.label_confirm_killlist = "Announce kill list of confirmed corpse"
--L.label_dyingshot = "Shoot on death if in ironsights [experimental]"
--L.label_armor_block_headshots = "Enable armor blocking headshots"
--L.label_armor_block_blastdmg = "Enable armor blocking blast damage"
--L.label_armor_dynamic = "Enable dynamic armor"
--L.label_armor_value = "Amount of armor given by the armor item"
--L.label_armor_damage_block_pct = "Damage percentage taken by armor"
--L.label_armor_damage_health_pct = "Damage percentage taken by player"
--L.label_armor_enable_reinforced = "Enable reinforced armor"
--L.label_armor_threshold_for_reinforced = "Reinforced armor threshold"
--L.label_sherlock_mode = "Enable sherlock mode"
--L.label_highlight_admins = "Highlight server admins"
--L.label_highlight_dev = "Highlight TTT2 developer"
--L.label_highlight_vip = "Highlight TTT2 supporter"
--L.label_highlight_addondev = "Highlight TTT2 addon developer"
--L.label_highlight_supporter = "Highlight others"
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
--L.label_doors_prop_health = "Destructed door health"
--L.label_minimum_players = "Minimum player amount to start round"
--L.label_karma = "Enable Karma"
--L.label_karma_strict = "Enable strict Karma"
--L.label_karma_starting = "Starting Karma"
--L.label_karma_max = "Maximum Karma"
--L.label_karma_ratio = "Penalty ratio for team damage"
--L.label_karma_kill_penalty = "Kill penalty for team kill"
--L.label_karma_round_increment = "Karma restoration"
--L.label_karma_clean_bonus = "Clean round bonus"
--L.label_karma_traitordmg_ratio = "Bonus ratio for enemy damage"
--L.label_karma_traitorkill_bonus = "Kill bonus for enemy kill"
--L.label_karma_clean_half = "Clean round bonus reduction"
--L.label_karma_persist = "Karma persists over map changes"
--L.label_karma_low_autokick = "Automatically kick players with low Karma"
--L.label_karma_low_amount = "Low Karma threshold"
--L.label_karma_low_ban = "Ban picked players with low Karma"
--L.label_karma_low_ban_minutes = "Ban time in minutes"
--L.label_karma_debugspam = "Enable debug output to console about Karma changes"
--L.label_max_melee_slots = "Max melee slots"
--L.label_max_secondary_slots = "Max secondary slots"
--L.label_max_primary_slots = "Max primary slots"
--L.label_max_nade_slots = "Max grenade slots"
--L.label_max_carry_slots = "Max carry slots"
--L.label_max_unarmed_slots = "Max unarmed slots"
--L.label_max_special_slots = "Max special slots"
--L.label_max_extra_slots = "Max extra slots"
--L.label_weapon_autopickup = "Enable automatic weapon pickup"
--L.label_sprint_enabled = "Enable sprinting"
--L.label_sprint_max = "Max sprinting stamina"
--L.label_sprint_stamina_consumption = "Stamina consumption factor"
--L.label_sprint_stamina_regeneration = "Stamina regeneration factor"
--L.label_crowbar_unlocks = "Primary attack can be used as interaction (i.e. unlocking)"
--L.label_crowbar_pushforce = "Crowbar push force"

-- 2022-07-02
--L.header_playersettings_falldmg = "Fall Damage Settings"

--L.label_falldmg_enable = "Enable fall damage"
--L.label_falldmg_min_velocity = "Minimum velocity threshold for fall damage to occur"
--L.label_falldmg_exponent = "Exponent to increase fall damage in relation to velocity"

--L.help_falldmg_exponent = [[
--This value modifies how exponentially fall damage is increased with the speed the player hits the ground at.
--
--Take care when altering this value. Setting it too high can make even the smallest falls lethal, while setting it too low will allow players to fall from extreme heights and suffer little to no damage.]]

-- 2023-02-08
--L.testpopup_title = "A Test Popup, now with a multiline title, how NICE!"
--L.testpopup_subtitle = "Well, hello there! This is a fancy popup with some special information. The text can be also multiline, how fancy! Ugh, I could add so much more text if I'd had any ideas..."

--L.hudeditor_chat_hint1 = "[TTT2][INFO] Hover over an element, press and hold [LMB] and move the mouse to MOVE or RESIZE it."
--L.hudeditor_chat_hint2 = "[TTT2][INFO] Press and hold the ALT key for symmetric resizing."
--L.hudeditor_chat_hint3 = "[TTT2][INFO] Press and hold the SHIFT key to move on axis and to keep the aspect ratio."
--L.hudeditor_chat_hint4 = "[TTT2][INFO] Press [RMB] -> 'Close' to exit the HUD Editor!"

--L.guide_nothing_title = "Nothing here yet!"
--L.guide_nothing_desc = "This is work in progress, help us by contributing to the project on GitHub."

--L.sb_rank_tooltip_developer = "TTT2 Developer"
--L.sb_rank_tooltip_vip = "TTT2 Supporter"
--L.sb_rank_tooltip_addondev = "TTT2 Addon Developer"
--L.sb_rank_tooltip_admin = "Server Admin"
--L.sb_rank_tooltip_streamer = "Streamer"
--L.sb_rank_tooltip_heroes = "TTT2 Heroes"
--L.sb_rank_tooltip_team = "Team"

--L.tbut_adminarea = "ADMIN AREA:"

-- 2023-08-10
--L.equipmenteditor_name_damage_scaling = "Damage Scaling"

-- 2023-08-11
--L.equipmenteditor_name_allow_drop = "Allow Drop"
--L.equipmenteditor_desc_allow_drop = "If enabled, the equipment can be dropped freely by the player."

--L.equipmenteditor_name_drop_on_death_type = "Drop on Death"
--L.equipmenteditor_desc_drop_on_death_type = "Attempt overriding the action taken for whether the equipment is dropped on player's death."

--L.drop_on_death_type_default = "Default (weapon-defined)"
--L.drop_on_death_type_force = "Force Drop on Death"
--L.drop_on_death_type_deny = "Deny Drop on Death"

-- 2023-08-26
--L.equipmenteditor_name_kind = "Equipment Slot"
--L.equipmenteditor_desc_kind = "The inventory slot the equipment will occupy."

--L.slot_weapon_melee = "Melee Slot"
--L.slot_weapon_pistol = "Pistol Slot"
--L.slot_weapon_heavy = "Heavy Slot"
--L.slot_weapon_nade = "Grenade Slot"
--L.slot_weapon_carry = "Carry Slot"
--L.slot_weapon_unarmed = "Unarmed Slot"
--L.slot_weapon_special = "Special Slot"
--L.slot_weapon_extra = "Extra Slot"
--L.slot_weapon_class = "Class Slot"

-- 2023-10-04
--L.label_voice_duck_spectator = "Duck spectator voices"
--L.label_voice_duck_spectator_amount = "Spectator voice duck amount"
--L.label_voice_scaling = "Voice Volume Scaling Mode"
--L.label_voice_scaling_mode_linear = "Linear"
--L.label_voice_scaling_mode_power4 = "Power 4"
--L.label_voice_scaling_mode_log = "Logarithmic"

-- 2023-10-07
L.search_title = "Resultat från Kroppsvisit - {player}"
L.search_info = "Information"
L.search_confirm = "Bekräfta Död"
--L.search_confirm_credits = "Confirm (+{credits} Credit(s))"
--L.search_take_credits = "Take {credits} Credit(s)"
--L.search_confirm_forbidden = "Confirm forbidden"
--L.search_confirmed = "Death Confirmed"
L.search_call = "Kalla på Detektiv"
--L.search_called = "Death Reported"

--L.search_team_role_unknown = "???"

L.search_words = "Någonting säger dig att en del av den här personens sista ord var: '{lastwords}'"
L.search_armor = "Han bar skyddsutrustning som inte var av vanlig standard."
--L.search_disguiser = "They were carrying a device that could hide their identity."
L.search_radar = "Han bar någon sorts radar. Den fungerar inte längre."
L.search_c4 = "In en av fickorna hittar du en lapp. Det står att om sladd nummer {num} klipps av, kommer bomben att stängas av."

L.search_dmg_crush = "Många av hans ben är brutna. Det verkar som att ett tungt föremål dödade honom."
L.search_dmg_bullet = "Det är uppenbart att han blev ihjälskjuten."
L.search_dmg_fall = "Han föll till sin död."
L.search_dmg_boom = "Hans skador och svedda kläder antyder att en explosion blev slutet för honom."
L.search_dmg_club = "Kroppen är alldeles blåslagen och mörbultad. Uppenbarligen blev han ihjälklubbad."
L.search_dmg_drown = "Kroppen visar tecken på drunkning."
L.search_dmg_stab = "Han blev stucken och förblödde hastigt."
L.search_dmg_burn = "Det luktar grillad terrorist häromkring..."
--L.search_dmg_teleport = "It looks like their DNA was scrambled by tachyon emissions!"
L.search_dmg_car = "När den här terroristen gick över vägen, blev han överkörd av en hänsynslös bilförare."
L.search_dmg_other = "Du kan inte hitta en specifik orsakt till den här terroristens död."

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
--L.search_floor_tile = "Small shards are stuck to their skin. Like shards from floor tiles that shattered on inpact."
--L.search_floor_grass = "It smells like fresh cut grass. The smell almost overpowers the smell of blood and death."
--L.search_floor_vent = "You feel a fresh gust of air when feeling their body. Did they die in a vent and take the air with them?"
--L.search_floor_wood = "What's nicer than sitting on a hardwood floor and dwelling in thoughts? At least lot lying dead on a wooden floor!"
--L.search_floor_default = "That seems so basic, so normal. Almost default. You can't tell anything about the kind of surface."
--L.search_floor_glass = "Their body is covered with many bloody cuts. In some of them glass shards are stuck and look rather threatening to you."
--L.search_floor_warpshield = "A floor made out of warpshield? Yep, we are as confused as you were. But our notes clearly state it. Warpshield."

--L.search_water_1 = "The victim's shoes are wet, but the rest seems dry. They were probably killed with their feet in water."
--L.search_water_2 = "The victim's shoes are trousers are soaked through. Did they wander through water before they were killed?"
--L.search_water_3 = "The whole body is wet and swollen. They probably died while they were completely submerged."

L.search_weapon = "En {weapon} användes för att döda den här terroristen."
L.search_head = "Det slutgiltiga skottet var i huvudet. Det fanns ingen tid till att skrika."
--L.search_time = "They died a while before you conducted the search."
--L.search_dna = "Retrieve a sample of the killer's DNA with a DNA Scanner. The DNA sample will decay after a while."

L.search_kills1 = "Du hittade en lista över mordoffer som bekräftar morden på {player}."
L.search_kills2 = "Du hittade en lista över mordoffer med dessa namn: {player}"
L.search_eyes = "Genom att använda dina detektivfärdigheter kan du identifiera den sista personen han såg: {player}. Mördaren, eller ett sammanträffande?"

--L.search_credits = "The victim has {credits} equipment credit(s) in their pocket. A shopping role might take them and put them to good use. Keep an eye out!"

--L.search_kill_distance_point_blank = "It was a point blank attack."
--L.search_kill_distance_close = "The attack came from a short distance."
--L.search_kill_distance_far = "The victim was attacked from a long distance away."

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
--L.corpse_hint_spectator = "Press [{usekey}] to view corpse UI"
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
--Key bind helpers are part of a UI element that always shows relevant keybindings to the player, which is especially helpful for new players. There are three different types of key bindings:
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
--L.label_keyhelper_mutespec = "cycle spectator voice mode"
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
--L.label_keyhelper_ammo_drop = "drop ammo from selected weapon out of clip"

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
--L.marker_vision_distance = "Distance: {distance}m"
--L.marker_vision_distance_collapsed = "{distance}m"

--L.c4_marker_vision_time = "Detonation time: {time}"
--L.c4_marker_vision_collapsed = "{time} / {distance}m"

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

--L.beacon_pickup_disabled = "Only the owner of the beacon can pick it up"
--L.beacon_short_desc = "Beacons are used by policing roles to add local wallhacks around them"

-- 2023-12-18
--L.entity_pickup_owner_only = "Only the owner can pick this up"

-- 2023-12-18
L.body_confirm_one = "{finder} bekräftade att {victim} har dött."
--L.body_confirm_more = "{finder} confirmed the {count} deaths of: {victims}."

-- 2023-12-19
--L.builtin_marker = "Built-in."
--L.equipmenteditor_desc_builtin = "This equipment is built-in, it comes with TTT2!"
--L.help_roles_builtin = "This role is built-in, it comes with TTT2!"
--L.header_equipment_info = "Equipment information"


-- 2023-12-24
--L.submenu_gameplay_accessibility_title = "Accessibility"

--L.header_accessibility_settings = "Accessibility Settings"

--L.label_enable_dynamic_fov = "Enable dynamic FOV change"
--L.label_enable_bobbing = "Enable view bobbing"
--L.label_enable_bobbing_strafe = "Enable view bobbing when strafing"

--L.help_enable_dynamic_fov = "Dynamic FOV is applied depending on the player's speed. When a player is sprinting for example, the FOV is increased to visualize the speed."
--L.help_enable_bobbing_strafe = "View bobbing is the slight camera shake while walking, swimming or falling."
-- 2023-12-20
--L.equipmenteditor_desc_damage_scaling = [[Multiplies the base damage value of a weapon by this factor.
--For a shotgun, this would affect each pellet.
--For a rifle, this would affect just the bullet.
--For the poltergeist, this would affect each "thump" and the final explosion.
--
--0.5 = Deal half the amount of damage.
--2 = Deal twice the amount of damage.
--
--Note: Some weapons might not use this value which causes this modifier to be ineffective.]]

-- 2023-12-24
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


--L.marker_vision_visible_for_0 = "Visible for you"
--L.marker_vision_visible_for_1 = "Visible for your role"
--L.marker_vision_visible_for_2 = "Visible for your team"
--L.marker_vision_visible_for_3 = "Visible for everyone"

-- 2024-01-27
--L.decoy_help_primary = "Throw Decoy on the ground"
--L.decoy_help_secondary = "Stick Decoy to surface"

-- 2024-01-24
--L.grenade_fuse = "FUSE"

-- 2024-01-25
--L.header_roles_magnetostick = "Magneto Stick"
--L.label_roles_ragdoll_pinning = "Enable ragdoll pinning"
--L.magneto_stick_help_carry_rag_pin = "Pin ragdoll"
--L.magneto_stick_help_carry_rag_drop = "Drop ragdoll"
--L.magneto_stick_help_carry_prop_release = "Release prop"
--L.magneto_stick_help_carry_prop_drop = "Drop prop"

-- 2024-02-14
--L.throw_no_room = "You have no space here to throw this device"

-- 2024-03-04
--L.use_entity = "Press [{usekey}] to use"

-- 2024-03-06
--L.submenu_gameplay_sounds_title = "Client-Sounds"

--L.header_sounds_settings = "UI Sound Settings"

--L.help_enable_sound_interact = "Interaction sounds are those sounds that are played when opening an UI. Such a sound is played for example when interacting with the radio marker."
--L.help_enable_sound_buttons = "Button sounds are clicky sounds that are played when clicking a button."
--L.help_enable_sound_message = "Message or notification sounds are played for chat mesages and notifications. They can be quite obnoxious."

--L.label_enable_sound_interact = "Enable interaction sounds"
--L.label_enable_sound_buttons = "Enable button sounds"
--L.label_enable_sound_message = "Enable message sounds"

--L.label_level_sound_interact = "Interaction sound level multiplier"
--L.label_level_sound_buttons = "Button sound level multiplier"
--L.label_level_sound_message = "Message sound level multiplier"

-- 2024-03-07
--L.label_crosshair_static_gap_length = "Enable static crosshair gap length"
--L.label_crosshair_size_gap = "Crosshair gap size multiplier"

-- 2024-03-31
--L.help_locational_voice = "Proximity chat is TTT2's implementation of locational 3D voice. Players are only audible in a set radius around them and become quieter the farther away they are."
--L.help_locational_voice_prep = [[By default the proximity chat is disabled in the preparing phase. Change this convar to also use proximity chat in the preparing phase.
--
--Note: Proximity chat is always disabled during the post round phase.]]
--L.help_voice_duck_spectator = "Ducking spectators makes other spectators quieter in comparison to living players. This can be useful if one wants to listen closely to the discussions of the living players."

--L.help_equipmenteditor_configurable_clip = [[The configurable size defines the amount of uses the weapon has when bought in the shop or spawned in the world.
--
--Note: This setting is only available for weapons that enable this feature.]]
--L.label_equipmenteditor_configurable_clip = "Configurable clip size"

-- 2024-04-06
--L.help_locational_voice_range = [[This convar constrains the maximum range at which players can hear each other. It does not change how the volume decreases with distance but rather sets a hard cut-off point.
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
