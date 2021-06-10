-- Polish language strings

local L = LANG.CreateLanguage("pl")

-- Compatibility language name that might be removed soon.
-- the alias name is based on the original TTT language name:
-- - does not exist -
L.__alias = "polski"

L.lang_name = "Polski (Polish)"

-- General text used in various places
L.traitor = "Zdrajca"
L.detective = "Detektyw"
L.innocent = "Niewinny"
L.last_words = "Ostatnie słowa"

L.terrorists = "Terroryści"
L.spectators = "Obserwatorzy"

L.nones = "Brak Teamu"
L.innocents = "Team Niewinni"
L.traitors = "Team Zdrajcy"

-- Round status messages
L.round_minplayers = "Nie wystarczająca ilość graczy do rozpoczęcia nowej rundy"
L.round_voting = "Głosowanie w toku, opóźnia nową rundę o {num} sekund..."
L.round_begintime = "Nowa runda zacznie się za {num} sekund. Przygotuj się."
L.round_selected = "Zdrajcy zostali wybrani."
L.round_started = "Runda rozpoczeła się!"
L.round_restart = "Admin postanowił zrestartować rundę."

L.round_traitors_one = "Zdrajco, pracujesz sam"
L.round_traitors_more = "Zdrajco, to są twoi sojusznicy: {names}"

L.win_time = "Czas minął. Zdrajcy przegrali."
L.win_traitors = "Zdrajcy wygrali!"
L.win_innocents = "Zdrajcy zostali pokonani!"
L.win_nones = "Wygrały pszczoły! (To oznacza remis)"
L.win_showreport = "Spójrzmy na raport rundy na {num} sekund."

L.limit_round = "Limit rund osiągnięty. {mapname} wkrótce się załaduje."
L.limit_time = "Limit czasowy osiągnięty. {mapname} wkrótce się załaduje."
L.limit_left = "{num} rund(a), albo {time} minut, do zmiany mapy na {mapname}."

-- Credit awards
L.credit_all = "Twój team został nagrodzony {num} kredytami na zakupy."
L.credit_kill = "Zdobyłeś {num} kredyt(ów) za zabicie {role}."

-- Karma
L.karma_dmg_full = "Twoja karma to {amount}, dlatego w tej rundzie zadajesz pełne obrażenia!"
L.karma_dmg_other = "Twoja karma to {amount}. Dlatego twoje obrażenia zostaną zredukowane o {num}%"

-- Body identification messages
L.body_found = "{finder} znalazł ciało {victim}. {role}"
L.body_found_team = "{finder} znalazł ciało {victim}. {role} ({team})"

-- The {role} in body_found will be replaced by one of the following:
L.body_found_traitor = "On był zdrajcą!"
L.body_found_det = "On był detektywem."
L.body_found_inno = "On był niewinny."

L.body_confirm = "{finder} potwierdził śmierć {victim}."

L.body_call = "{player} zawołał detektywa do ciała {victim}!"
L.body_call_error = "Musisz potwierdić zgon tego gracza, zanim zawołasz detektywa!"

L.body_burning = "O nie! Te zwłoki się palą!"
L.body_credits = "Znalazłeś {num} kredyt(ów) na ciele!"

--- Menus and windows
L.close = "Zamknij"
L.cancel = "Anuluj"

-- For navigation buttons
L.next = "Następny"
L.prev = "Poprzedni"

-- Equipment buying menu
L.equip_title = "Wyposażenie"
L.equip_tabtitle = "Zamów wyposażenie"

L.equip_status = "Status zamówienia"
L.equip_cost = "Został(o) ci {num} kredyt(ów)."
L.equip_help_cost = "Każdy element sprzęty kosztuje 1 kredyt."

L.equip_help_carry = "Możesz kupować jedynie przedmioty na, które masz miejsce."
L.equip_carry = "Możesz wziąć ten przedmiot."
L.equip_carry_own = "Aktualnie posiadasz ten przedmiot."
L.equip_carry_slot = "Posiadasz już inny przedmiot na slocie {slot}."
L.equip_carry_minplayers = "Nie ma wystarczającej liczby graczy, aby odblokować tę broń."

L.equip_help_stock = "Istnieją przedmioty, które możesz kupić tylko raz na rundę."
L.equip_stock_deny = "Ten przedmiot nie jest już dłużej dostępny."
L.equip_stock_ok = "Ten przedmiot jest dostępny."

L.equip_custom = "Przedmiot dodany przez serwer."

L.equip_spec_name = "Nazwa"
L.equip_spec_type = "Typ"
L.equip_spec_desc = "Opis"

L.equip_confirm = "Kup wyposażenie"

-- Disguiser tab in equipment menu
L.disg_name = "Przebranie"
L.disg_menutitle = "Obsługa przebrania"
L.disg_not_owned = "Nie masz przebrania!"
L.disg_enable = "Włącz przebranie"

L.disg_help1 = "Kiedy twoje przebranie jest aktywne, twoje imie, zdrowie i karma nie będzie widoczna, gdy ktoś na ciebie spojrzy. Ponadto, będziesz niewidzoczny dla radaru Detektywa."
L.disg_help2 = "Kliknij Enter na Numpadzie, by przełączać przebranie bez używania menu. Możesz też ustawić inny przycisk do 'ttt_toggle_disguise' używając konsoli."

-- Radar tab in equipment menu
L.radar_name = "Radar"
L.radar_menutitle = "Obsługa radaru"
L.radar_not_owned = "Nie masz radaru!"
L.radar_scan = "Wykonaj skanowanie"
L.radar_auto = "Auto-powtarzaj skanowanie"
L.radar_help = "Wyniki skanowania pokazują się na {num} sekund, po którym radar zostanie przeładowany i będzie mógł być ponownie użyty."
L.radar_charging = "Twój radar nadal się ładuje!"

-- Transfer tab in equipment menu
L.xfer_name = "Transfer"
L.xfer_menutitle = "Transferuj kredyty"
L.xfer_send = "Wyślij kredyty"

L.xfer_no_recip = "Odbiorca nie jest prawidłowy, transfer kredytów został przerwany."
L.xfer_no_credits = "Niewystarczająca ilość kreytów do transferu."
L.xfer_success = "Transfer kredytów do {player} zakończony."
L.xfer_received = "{player} dał ci {num} kredyt(ów)."

-- Radio tab in equipment menu
L.radio_name = "Radio"
L.radio_help = "Klkinij przycisk, by twoje radio zaczeło grać."
L.radio_notplaced = "Musisz postawić radio, by móc puścić jakieś dźwięki."

-- Radio soundboard buttons
L.radio_button_scream = "Krzyk"
L.radio_button_expl = "Eksplozja"
L.radio_button_pistol = "Strzały z pistoletu"
L.radio_button_m16 = "Strzały z M16"
L.radio_button_deagle = "Strzały z Deagle'a"
L.radio_button_mac10 = "Strzały z MAC10"
L.radio_button_shotgun = "Strzałty z shotguna"
L.radio_button_rifle = "Strzały z Rifle'a"
L.radio_button_huge = "Wystrzały z H.U.G.E"
L.radio_button_c4 = "Pikanie C4"
L.radio_button_burn = "Palenie się"
L.radio_button_steps = "Kroki"

-- Intro screen shown after joining
L.intro_help = "Jeśli jesteś nowy w grze, kliknij F1 dla instrukcji!"

-- Radiocommands/quickchat
L.quick_title = "Szybkie odpowiedzi"

L.quick_yes = "Tak."
L.quick_no = "Nie."
L.quick_help = "Pomocy!"
L.quick_imwith = "Jestem z {player}."
L.quick_see = "Widzę {player}."
L.quick_suspect = "{player} jest podejrzany."
L.quick_traitor = "{player} jest zdrajcą!"
L.quick_inno = "{player} jest niewinny."
L.quick_check = "Ktoś jeszcze żyje?"

-- {player} in the quickchat text normally becomes a player nickname, but can
-- also be one of the below. Keep these lowercase.
L.quick_nobody = "nikt"
L.quick_disg = "ktoś w przebraniu"
L.quick_corpse = "niezidentyfikowane zwłoki"
L.quick_corpse_id = "ciało gracza {player}"

--- Body search window
L.search_title = "Rezultaty przeszukania ciała"
L.search_info = "Informacje"
L.search_confirm = "Potwierdź śmierć"
L.search_call = "Zawołaj detektywa"

-- Descriptions of pieces of information found
L.search_nick = "To jest ciało gracza {player}."

L.search_role_traitor = "Ta osoba była zdrajcą!"
L.search_role_det = "Ta osoba była detektywem."
L.search_role_inno = "Ta osoba była niewinnym terrorystą."

L.search_words = "Coś ci mówi, że jego ostanie słowa to: '{lastwords}'"
L.search_armor = "On nosił niestandardową kamizelkę kuloodporną."
L.search_disg = "Trzymał urządzenie, które mogło ukryć jego tożsamość."
L.search_radar = "Miał jakiegoś rodzaju radar. Już nie działa."
L.search_c4 = "W kieszeni znalazłeś notkę. Stwierdza, że przecięcie przewodu {num} bezpiecznie rozbroi bombę."

L.search_dmg_crush = "Wiele z jego kości jest połamanych. To pokazuje, że zabił go jakiś duży obiekt."
L.search_dmg_bullet = "Jest oczywiste, że został zastrzelony na śmierć."
L.search_dmg_fall = "Spadł i połamał sobie kark."
L.search_dmg_boom = "Stan jego ubrania pokazują, że wybuch zakończył jego żywot."
L.search_dmg_club = "Ciało jest posiniaczone i poobijane. Najwyraźniej został zatłuczony na śmierć."
L.search_dmg_drown = "Ciało wykazuje, że delikwent utonął."
L.search_dmg_stab = "Został dźgnięty nożem, zanim szybko się wykrwawił."
L.search_dmg_burn = "Pachnie jak pieczony terrorysta..."
L.search_dmg_tele = "Jego DNA zostało uszkodzone przez fale tachionu."
L.search_dmg_car = "Gdy ten terrorysta przechodził przez drogę, został przejechany przez lekkomyślnego kierowce."
L.search_dmg_other = "Nie możesz znaleźć konkretnej przyczyny śmierci tego terrorysty."

L.search_weapon = "Wygląda na to, że {weapon} posłużyła do tego zabójstwa."
L.search_head = "Rana śmiertelna była strzałem w głowę. Nie miał czasu, aby krzyczeć."
L.search_time = "Zmarł w przybliżeniu {time}, zanim go przeszukałeś."
L.search_dna = "Pobierz próbkę DNA zabójcy za pomocą skanera DNA. Próbka DNA przeterminuje się za {time}."

L.search_kills1 = "Znalazłeś listę zabójstw, co potwierdza śmierć {player}."
L.search_kills2 = "Znalazłeś listę zabójstw z tymi imionami:"
L.search_eyes = "Używając umiejętności detektywa, zidentyfikowałeś ostatnią osobę, która go widziała: {player}. Morderca, czy zbieg okoliczności?"

-- Scoreboard
L.sb_playing = "Grasz na..."
L.sb_mapchange = "Mapa zmieni się za {num} rund(ę) lub za {time}"

L.sb_mia = "Zaginiony w akcji"
L.sb_confirmed = "Potwierdzony zgon"

L.sb_ping = "Ping"
L.sb_deaths = "Śmierci"
L.sb_score = "Wynik"
L.sb_karma = "Karma"

L.sb_info_help = "Przejrzyj zwłoki tego gracza, a znajdziesz tutaj wyniki jego przeszukania."

L.sb_tag_friend = "PRZYJACIEL"
L.sb_tag_susp = "PODEJRZANY"
L.sb_tag_avoid = "UNIKAĆ"
L.sb_tag_kill = "ZABIĆ"
L.sb_tag_miss = "ZAGINIONY"

-- Equipment actions, like buying and dropping
L.buy_no_stock = "Ta broń się skończyła: już kupiłeś ją w tej rundzie."
L.buy_pending = "Masz już oczekujące zamówienie, poczekaj na jego odbiór"
L.buy_received = "Otrzymałeś specjalne uzbrojenie."

L.drop_no_room = "Nie ma tutaj mniejsca, aby wyrzucić broń!"

L.disg_turned_on = "Przebranie włączone!"
L.disg_turned_off = "Przebranie wyłączone."

-- Equipment item descriptions
L.item_passive = "Pasywne"
L.item_active = "Aktywne"
L.item_weapon = "Broń"

L.item_armor = "Kamizelka kuloodporna"
L.item_armor_desc = [[
Zmniejsza obrażenia, zużywa się z czasem

Można ją zakupić kilka razy. Po osiągnięciu odpowiedniej liczby punktów, kamizelka się wzmacnia!]]

L.item_radar = "Radar"
L.item_radar_desc = [[
Wyszukuje oznak życia, skanując.

Zaczyna automatycznie skanować tylko jak go kupisz. Skonfiguruj to w zakładce radaru w tym menu.]]

L.item_disg = "Przebranie"
L.item_disg_desc = [[
Ukrywa twój status, gdy jest włączone. Także unika, bycia ostanią osobą widzaną przez ofiare.

Przełącz w zakładce Przebrania w tym menu lub kliknij Enter na Numpadzie.]]

-- C4
L.c4_hint = "Kliknij {usekey}, by uzbroić lub rozbroić."
L.c4_disarm_warn = "C4, które uzbroiłeś, zostało rozbrojone."
L.c4_armed = "Pomyślnie uzbroiłeś bombę."
L.c4_disarmed = "Pomyślnie rozbroiłeś bombę."
L.c4_no_room = "Nie możesz wziąć tego C4."

L.c4_desc = "Potężny, wybuchowy, czasowy."

L.c4_arm = "Uzbrój C4"
L.c4_arm_timer = "Timer"
L.c4_arm_seconds = "Sekund do detonacji:"
L.c4_arm_attempts = "Przy próbie rozbrojenia, {num} z 6 przewodów spowoduje natychmiastowy wybuch podczas cięcia."

L.c4_remove_title = "Usuwanie"
L.c4_remove_pickup = "Weź C4"
L.c4_remove_destroy1 = "Zniszcz C4"
L.c4_remove_destroy2 = "Potwierdź: zniszcz"

L.c4_disarm = "Rozbrój C4"
L.c4_disarm_cut = "Kliknij, by przeciąć kabel {num}"

L.c4_disarm_owned = "Przetnij kabel, by rozbroić bombe. To twoja bomba, więc każdy kabel ją rozbraja"
L.c4_disarm_other = "Przetnij odpowiedni kabel, by rozbroić bombe. Jak się pomylisz, to ona wybuchnie!"

L.c4_status_armed = "UZBROJONA"
L.c4_status_disarmed = "ROZBROJONA"

-- Visualizer
L.vis_name = "Wizualizer"
L.vis_hint = "Kliknij {usekey} by podnieść (tylko Detektywi)."

L.vis_desc = [[
Wizualizator chwili zabójstwa.

Analizuje ciało by pokazać jak jak ofiara zostałą zabita, ale tylko jak zgineła od strzałów z broni.]]

-- Decoy
L.decoy_name = "Wabik"
L.decoy_no_room = "Nie możesz wziąć tego wabika."
L.decoy_broken = "Twój wabik został zniszczony!"

L.decoy_short_desc = "Pokazuje oszukaną pozycję na radarze"
L.decoy_pickup_wrong_team = "You can't pick it up as it belongs to a different team"

L.decoy_desc = [[
Pokazuje fałszywy znacznik na radarze Detektywów, i sprawia, że DNA skaner pokazuje Detektywowi lokalizacje wabika, jeżeli zeskanuje twoje DNA.]]

-- Defuser
L.defuser_name = "Rozbrajacz"
L.defuser_help = "{primaryfire} rozbraja zaznaczone C4."

L.defuser_desc = [[
Natychmiastowo robraja ładunek C4.

Brak limitu użyć. C4 będzie łatwiej zauważyć, jeśli go nosisz.]]

-- Flare gun
L.flare_name = "Pistolet sygnałowy"

L.flare_desc = [[
Pozwala spalić zwłoki, żeby nikt ich nigdy nie odnalazł. Ograniczona amunicja.

Palenie zwłok wydaje charakterystyczny dźwięk.]]

-- Health station
L.hstation_name = "Stacja Lecząca"

L.hstation_broken = "Twoja stacja lecząca została zniszczona!"
L.hstation_help = "{primaryfire} kładzie stacje."

L.hstation_desc = [[
Pozwala ludzią się leczyć, gdy jest położone.

Powolne ładowanie. Każdy może użyć i może być uszkodzone. Może posłużyć do sprawdzenia DNA jej użytkowników.]]

-- Knife
L.knife_name = "Nóż"
L.knife_thrown = "Nóż do rzucania"

L.knife_desc = [[
Zabija ranne cele natychmiastowo i po cichu, ale ma tylko jedno użycie.

Może być rzucone za pomocą strzału alternatywnego.]]

-- Poltergeist
L.polter_desc = [[
Miota przedmiotami jak szatan.

Rani ludzi, których trafi.]]

-- Radio
L.radio_broken = "Twoje radio zostało zniszczone!"
L.radio_help_pri = "{primaryfire} kładzie radio."

L.radio_desc = [[
Odtwarza dźwięki lub odgłosy.

Postaw gdzieś radio, i potem puszczaj dźwięki używając specjalnej zakładki w tym menu.]]

-- Silenced pistol
L.sipistol_name = "Pistolet z tłumikiem"

L.sipistol_desc = [[
Cichy pistolet, używa normalnego ammo do pistoletu.

Ofiara nie będzie krzyczeć, gdy zginie.]]

-- Newton launcher
L.newton_name = "Wyrzutnia Newtona"

L.newton_desc = [[
Zpychaj ludzi z bezpiecznego dystansu.

Nieskończona amunicja, ale wolno strzela.]]

-- Binoculars
L.binoc_name = "Lornetka"

L.binoc_desc = [[
Przybliżaj na ciała i identyfikuj je z dalekiego dystansu.

Nielimitowana liczba użyć, ale identyfikacja trwa pare sekund.]]

-- UMP
L.ump_desc = [[
Eksperymentalne SMG dezorientujące cel.

Używa standardowego ammo do SMG.]]

-- DNA scanner
L.dna_name = "DNA skaner"
L.dna_identify = "Zwłoki muszą być zidentyfikowane, by sprawdzić DNA sprawcy."
L.dna_notfound = "Nie znaleziono próbki DNA na cel."
L.dna_limit = "Osiągnięto limit pamięci. Usuń stare próbki, aby dodać nowe."
L.dna_decayed = "Próbka DNA zabójcy uległa rozkładowi."
L.dna_killer = "Zebrano próbkę DNA zabójcy z trupa!"
L.dna_no_killer = "Nie można było pobrać DNA (zabójca się rozłączył?)."
L.dna_armed = "Ta bomba jest uzbrojona! Rozbrój ją najpierw!"
L.dna_object = "Zebrano {num} nową próbkę DNA z obiektu."
L.dna_gone = "DNA nie zostało znalezione na tym terenie."

L.dna_desc = [[
Zbiera próbki DNA z różnych rzeczy i używa ich do znalezienia właściela tego DNA.

Użyj na świeżych zwłokach, by znaleźć DNA zabójcy i śledzić go.]]

-- Magneto stick
L.magnet_name = "Kijek magnetyczny"
L.magnet_help = "{primaryfire}, aby przymocować ciało do powierzchni."

-- Grenades and misc
L.grenade_smoke = "Granat dymny"
L.grenade_fire = "Wybuchowy granat"

L.unarmed_name = "Bez broni"
L.crowbar_name = "Łom"
L.pistol_name = "Pistolet"
L.rifle_name = "Rifle"
L.shotgun_name = "Shotgun"

-- Teleporter
L.tele_name = "Teleporter"
L.tele_failed = "Teleportacja nieudana."
L.tele_marked = "Zaznaczona lokalizacja teleportacji."

L.tele_no_ground = "Nie można teleportować gracza, zanim nie stanie na twardym gruncie!"
L.tele_no_crouch = "Nie można teleportować, podczas skradania!"
L.tele_no_mark = "Brak zaznaczonej lokalizacji.Zaznacz miejsce przeznaczenia przed teleportacją."

L.tele_no_mark_ground = "Nie można zaznaczyć lokalizacji, gdy nie jest się na stałym gruncie!"
L.tele_no_mark_crouch = "Nie można zaznaczyć lokalizacji podczas skradania!"

L.tele_help_pri = "{primaryfire} teleportuje do zaznaczonej lokalizacji."
L.tele_help_sec = "{secondaryfire} zaznacza aktualną lokalizacje."

L.tele_desc = [[
Teleportuje do wcześniej zaznaczonego miejsca.

Teleportowanie emituje dźwięk, i liczba użyć jest ograniczona.]]

-- Ammo names, shown when picked up
L.ammo_pistol = "9mm ammo"

L.ammo_smg1 = "SMG ammo"
L.ammo_buckshot = "Shotgun ammo"
L.ammo_357 = "Rifle ammo"
L.ammo_alyxgun = "Deagle ammo"
L.ammo_ar2altfire = "Flare ammo"
L.ammo_gravity = "Poltergeist ammo"

-- Round status
L.round_wait = "Oczekiwanie"
L.round_prep = "Przygotowanie"
L.round_active = "W trakcie"
L.round_post = "Koniec rundy"

-- Health, ammo and time area
L.overtime = "DOGRYWKA"
L.hastemode = "TRYB SZYBKI"

-- TargetID health status
L.hp_healthy = "Zdrowy"
L.hp_hurt = "Poturbowany"
L.hp_wounded = "Ranny"
L.hp_badwnd = "Bardzo ranny"
L.hp_death = "Bliski śmierci"

-- TargetID karma status
L.karma_max = "Renomowany"
L.karma_high = "Szorski"
L.karma_med = "Brutalny"
L.karma_low = "Niebezpieczny"
L.karma_min = "Szaleniec"

-- TargetID misc
L.corpse = "Zwłoki"
L.corpse_hint = "Kliknij [{usekey}] by zbadać. [{walkkey} + {usekey}], aby je zbadać po cichu."

L.target_disg = "przebrany"
L.target_unid = "Niezidentyfikowane ciało"

L.target_credits = "Przeszukaj, aby otrzymywać niewykorzystane kredyty"

-- HUD buttons with hand icons that only some roles can see and use
L.tbut_single = "Jednorazowe"
L.tbut_reuse = "Wielorazowe"
L.tbut_retime = "Użyj ponownie po {num} sek"
L.tbut_help = "Naciśnij [{usekey}] aby użyć"

-- Spectator muting of living/dead
L.mute_living = "Living players muted"
L.mute_specs = "Spectators muted"
L.mute_all = "All muted"
L.mute_off = "None muted"

-- Spectators and prop possession
L.punch_title = "PUNCH-O-METER"
L.punch_help = "Klawisze ruchu lub skok: uderz obiekt. Skradanie: opuść obiekt."
L.punch_bonus = "Twój słaby wynik pomniejszył twój limit punch-o-metera o {num}"
L.punch_malus = "Twój dobry wynik powiększył twój limit punch-o-metera o {num}!"

-- Info popups shown when the round starts
L.info_popup_innocent = [[
Jesteś niewinnym terrorystą! Ale zdrajcy są do okoła...
Komu możesz ufać, a kto cię nafaszruje ołowiem?

Uważaj na siebie i wspópracuj ze swoimi komratami, by wyjść z tego cało!]]

L.info_popup_detective = [[
Jesteś Detektywem! Centrala terrorystów dała ci specjalne wyposażenie do znaleznienia zdrajców.
Użyj ich, by pomóc przetrwać niewinnym, ale bądź uważny:
Zdrajcy będą chcieli zabić cię jako pierwszego!

Kliknij {menukey}, aby otrzymać swoje wyposażenie!]]

L.info_popup_traitor_alone = [[
Jesteś ZDRAJCĄ! Nie masz żadnych kolegów zdrajców.

Zabij innych i wygraj!

Kliknij {menukey}, aby otrzymać swoje specjalne wyposażenie!]]

L.info_popup_traitor = [[
Jesteś ZDRAJCĄ! Wspópracuj ze swoimi kolegami zdrajcami i zabij innych.
Ale musisz uważać, albo twoja zdrada może sostać odkryta...

To są twoi kamraci:
{traitorlist}

Kliknij {menukey}, aby otrzymać swoje specjalne wyposażenie!]]

-- Various other text
L.name_kick = "Gracz został automatycznie wyrzucony, za zmienienie nazwy podczas gry."

L.idle_popup = [[
Byłeś bezczynny przez {num} sekund i w rezultacie zostałeś przeniesony do trybu obserwatora . Kiedy jesteś w tym trybie, nie będziesz się pojawiał w nowych rundach.

Możesz to zmienić tryb obserwatora w każdej chwili klikając {helpkey} i odznaczając tą opcje w zakładce ustawień. Możesz również to zrobić teraz.]]

L.idle_popup_close = "Nic nie rób"
L.idle_popup_off = "Wyłącz tryb obserwatora teraz"

L.idle_warning = "Uwaga: wydajesz się być bezczynny/AFK, zostaniesz przeniesony do trybu obserwatora, jeśli nie przejawisz jakiejś aktywności!"

L.spec_mode_warning = "Jesteś w trybie obserwatora, dlatego nie będziesz się respawnować w następnytch rundach. By wyłączyć ten tryb, kliknij F1, idź do ustawień i odkliknij 'tryb obserwatora'."

-- Tips panel
L.tips_panel_title = "Porady"
L.tips_panel_tip = "Porada:"

-- Tip texts
L.tip1 = "Zdrajcy mogą przeszukiwać ciała po cichu, bez potwierdzania zgonu przez {walkkey} i kliknięcie {usekey} na ciało."

L.tip2 = "Uzbrojenie C4 z dłuższym czasem na timerze zwiększy liczbę nieporawnych kabli, które spowodują wybuch, gdy będzie bombę rozbrajać ktoś niewinnny. Będzie też bipać ciszej i rzadziej."

L.tip3 = "Detektywi mogą sprawdzać ciała, by zobaczyć kto jest 'odbity w jego oczach'. To jest ostatnia osoba, którą widziała ofiara. To nie musi być zabójca jeśli został postrzelony od tyłu."

L.tip4 = "Nikt nie będzie wiedział, że zgniąłeś dopóki ktoś nie znajdzie twojego ciała i przeszuka go."

L.tip5 = "Kiedy zdrajca zabija Detektywa, dostaje odrazu premie kretydów."

L.tip6 = "Kiedy zdrajca zginie, wszyscy detektywi dostają kredyty na ekwipunek specjalny."

L.tip7 = "Kiedy zdrajcy robią znaczy postęp w zabijaniu niewinnych, dostaną kredyty jako nagrodę."

L.tip8 = "Zdrajcy i detektywi mogą zbierać niewykorzystany sprzęt i kredyty z ciał innych zdrajców i detektywów."

L.tip9 = "Poltergeist może zmienić każdy fizyczny obiekt w śmiercionośny pocisk. Każdemu uderzeniu towarzyszy uderzenie energii, które rani pobliskie osoby."

L.tip10 = "Jako Zdrajca i Detektyw, miej na oku czerwone wiadomości w górnym prawym rogu. Będą dla ciebie ważne."

L.tip11 = "Jako Zdrajca i Detektyw, pamiętaj, że otrzymasz dodatkowe kredyty, jeśli ty i twoi towarzysze osiągniecie dobre wyniki. Pamiętaj by je zużyć na coś przydatnego!"

L.tip12 = "DNA Skaner detektywów może służyć do zbierania próbek DNA z broni i przedmiotów i potem skanowania, by zobaczyć lokalizacje ich właściela. Przydatne kiedy masz próbkę z martwego ciała lub rozbrojonej bomby!"

L.tip13 = "Kiedy jesteś blisko osoby którą mordujesz, trochę twojego DNA zostaje na ciele. To DNA może posłużyć detektywowi by zobaczyć twoją aktualną lokalizacje przy pomocy DNA skanera. Lepiej schowaj ciało, kiedy kogoś zanożujesz!"

L.tip14 = "Im dalej jesteś od osoby, którą mordujesz, tym szybciej twoja próbka DNA się zepsuje."

L.tip15 = "Jako zdrajca będziesz snajpił? Zastanów się nad wypróbowaniem przebrania. Jeśli spudłujesz, ucieknij do bezpiecznego miejsca, wyłącz przebranie i nikt nie będzie wiedział, że to ty strzelałeś"

L.tip16 = "Jak Zdrajca, Teleporter może pomóc ci uciec, gdy jesteś ścigany, i pozwala ci szybko podróżować po dużej mapie. Zawsze upewnij się, że masz zanzaczoną bepieczną lokalizacje teleportacji."

L.tip17 = "Niewinni są wszyscy w grupie i trudni do zdjęcia? Zastanów się nad wypróbowaniem Radia, aby odtworzyć dźwięki C4 lub strzelaniny, aby rozbiegli się w panice."

L.tip18 = "Używając radia jako zdrajca, możesz puszczać dźwięki przez twoje menu ekwipunku, kiedy radio jest położone. Ustaw wiele dźwięków w kolejce, klikając wiele przycisków w żądanej kolejności."

L.tip19 = "Jako detektyw, jeśli posiadasz niewykorzystane kredyty, możesz dać zaufanej osobie rozbrajacz. Następnie możesz spędzić czas na poważnych pracach dochodzeniowych i pozostawić ryzykowne rozbrajanie bomb innym."

L.tip20 = "Lornetka detektywów pozwala długo dysanstowe szukanie i indetyfukowanie zwłok. Złe wieści, jeśli zdrajcy mieli nadzieję użyć zwłok jako przynęty. Oczywiście podczas korzystania z lornetki detektyw jest nieuzbrojony i rozproszony..."

L.tip21 = "Stacja lecząca detektywów pomoże poobijanym graczom się wyleczyć. Oczywiście poobijanymi osobami mogą być zdrajcy..."

L.tip22 = "Stacja lecząca pobiera próbki DNA wszystkich jej użytkowników. Detektyw może użyć z DNA skanerem i znaleźć tego go się nią leczył ."

L.tip23 = "W przeciwieństwie do broni i C4, radio zdrajców nie zawiera próbki DNA osoby, która je postawiła. Nie martw się, że detektywi je znajdą i zepsują twoją przykrywkę."

L.tip24 = "Kliknij {helpkey} by zobaczyć szybki tutorial albo edytować jakieś ustawienia TTT. Na przykład, możesz wyłączyć na zawsze podpowiedzi w grze."

L.tip25 = "Kiedy detektyw przeszuka ciało, rezultaty będą dostępne dla wszystkich przez klniknięcie nicku martwej osoby na tabeli wyników."

L.tip26 = "W tabeli wyników ikona lupy obok czyjegoś imienia wskazuje, że masz informacje o przeszukaniu tej osoby. Jeśli ikona jest jasna, dane pochodzą od detektywa i mogą zawierać dodatkowe przydatne informacje."

L.tip27 = "Jako detektyw trupy z lupą po nicku zostali przeszukani przez detektywa, a ich wyniki są dostępne dla wszystkich graczy za pośrednictwem tablicy wyników."

L.tip28 = "Obserwatorzy mogą kliknąć {mutekey} by wyciszyć innych obserwatorów lub żywych graczy."

L.tip29 = "Jeśli serwer ma zainstalowane dodatkowe języki, możesz je ustawić w menu ustawień."

L.tip30 = "Szybki-chat albo komendy 'radia' mogą zostać użyte przez kliknięcie {zoomkey}."

L.tip31 = "Jako obserwator, kliknij {duckkey} by odblokować twój kursor i kliknąć na tym panelu ciekawostek. Kliknij {duckkey} ponownie, aby powrócić."

L.tip32 = "Drugi atak łomu odpycha innych graczy."

L.tip33 = "Celowanie przez celowniki broni nieco zwiększy twoją dokładność i zmniejszyć odrzut. Kucanie już nie."

L.tip34 = "Granaty dymne są efektywniejsze w pomieszczeniach, sczególnie tworzą zamieszanie w tych zatłoczonych."

L.tip35 = "Jako Zdrajca pamiętaj, że możesz prznosić ciała i chować przed wzrokiem niewinnych i detektywów."

L.tip36 = "Samouczek jest dostępny pod {helpkey} zawierający zbiór najpotrzebnieszych zasad i klawiszy podczas gry."

L.tip37 = "Na tablicy wyników, kliknij nick żyjącego gracza, a będziesz mógł oznaczyć go jako 'podejrzany' albo 'przyjaciel'. Ten przydomek pojawi się, gdy będziesz go miał na muszce."

L.tip38 = "Wiele stawialnych przedmiotów (takich jak C4, Radio) może być postawinych na ściania przez drugi atak."

L.tip39 = "Tłumaczenie TTT2 ogarnął Wuker."

L.tip40 = "Jeśli jest napisane 'TRYB SZYBKI' ponad czasem rundy, runda z początku potrwa tylko kilka minut, ale z każdą śmiercią czas będzię się zwiększał (jak przejmowanie punktów w TF2). Ten tryb wywiera presję na zdrajców, aby szybciej się uwijali."

--- Round report
L.report_title = "Raport rundy"

-- Tabs
L.report_tab_hilite = "Ciekawostki"
L.report_tab_hilite_tip = "Ważne momenty ostatniej rundy"
L.report_tab_events = "Wydarzenia"
L.report_tab_events_tip = "Log wydarzeń tej rundy"
L.report_tab_scores = "Punkty"
L.report_tab_scores_tip = "Punkty zdobyte przez każdego zawodnika w tej rundzie"

-- Event log saving
L.report_save = "Zapisz Log.txt"
L.report_save_tip = "Zapisuje log wydarzeń do pliku .txt"
L.report_save_error = "Brak danych logu, aby zapisać."
L.report_save_result = "Log wydarzeń został zapisany:"

-- Big title window
L.hilite_win_traitors = "ZDRAJCY WYGRALI"
L.hilite_win_none = "PSZCZOŁY WYGRAŁY"
L.hilite_win_innocents = "NIEWINNI WYGRALI"

L.hilite_players1 = "{numplayers} graczy brało udział, {numtraitors} było zdrajcami"
L.hilite_players2 = "{numplayers} graczy brało udział, jeden z nich był zdrajcą"

L.hilite_duration = "Runda trwała {time}"

-- Columns
L.col_time = "Czas"
L.col_event = "Wydażenie"
L.col_player = "Gracz"
L.col_roles = "Role"
L.col_teams = "Teamy"
L.col_kills1 = "Zabójstwa niewinnych"
L.col_kills2 = "Zabójstwa zdrajców"
L.col_points = "Punkty"
L.col_team = "Drużynowy bonus"
L.col_total = "Punktów ogółem"

-- Awards/highlights
L.aw_sui1_title = "Lider Kultu SamobÓjstwa"
L.aw_sui1_text = "pokazał innym samobÓjcom, jak to zrobić zabijąc się jako pierwszy."

L.aw_sui2_title = "Samotny i zdesperowany"
L.aw_sui2_text = "był jedynym, który zabił samego siebie."

L.aw_exp1_title = "Badania MateriaŁÓw Wybuchowych"
L.aw_exp1_text = "został wyrÓżniony za badania nad eksplozjami. Pomogło mu [num} obiektów."

L.aw_exp2_title = "Badania Terenowe"
L.aw_exp2_text = "sprawdził swoją odporność na wybuchy. Nie była wystarczająco wysoka."

L.aw_fst1_title = "Pierwsza Krew"
L.aw_fst1_text = "wykonał pierwsze zabójstwo z rąk zdrajców."

L.aw_fst2_title = "Pierwsze Krwawe GŁupie ZabÓjstwo"
L.aw_fst2_text = "zyskał pierwsze zabójstwo przez strzelanie do kolegów zdrajców. Dobra robota."

L.aw_fst3_title = "Pierwsza Gafa"
L.aw_fst3_text = "zabił jako pierwszy. Szkoda, że ofiarą był niewinny kolega."

L.aw_fst4_title = "Pierwszy Cios"
L.aw_fst4_text = "zadał pierwszy cios ze strony niewinnych terrorystów poprzez zabicie pierwszego zdrajcy."

L.aw_all1_title = "NajgroŹniejszy WŚrÓd RÓwnych"
L.aw_all1_text = "był odpowiedzilany za każde zabójstwo popełnione przez niewinnych w tej rundzie."

L.aw_all2_title = "Samotny Wilk"
L.aw_all2_text = "był odpowiedzilany za każde zabójstwo popełnione przez zdrajców."

L.aw_nkt1_title = "I Got One, Boss!"
L.aw_nkt1_text = "zabił jednego niewinnego. Słodko!"

L.aw_nkt2_title = "Pocisk Na Dwa"
L.aw_nkt2_text = "pokazał, że pierwszy nie był szczęśliwy, zabijając innym."

L.aw_nkt3_title = "Seryjny Zdrajca"
L.aw_nkt3_text = "zakończył dzisiaj trzy niewinne życia."

L.aw_nkt4_title = "Wilk WŚRÓd Owczych WilkÓw"
L.aw_nkt4_text = "je niewinnych terrosrystów na śniadanie. Kolacja składająca się z {num} dań."

L.aw_nkt5_title = "Antyterrorsta"
L.aw_nkt5_text = "otrzymywał wynagrodzenie za każdą śmierć. Może sobie kupić kolejny jacht."

L.aw_nki1_title = "ZdradŹ To"
L.aw_nki1_text = "znalazł zdrajcę. Zabił zdrajcę. Łatwe."

L.aw_nki2_title = "Liga Sprawiedliwych"
L.aw_nki2_text = "eskortował dwóch zdrajców do nieba."

L.aw_nki3_title = "Czy Zdrajcy ŚniĄ O Zdradzieckich Owcach?"
L.aw_nki3_text = "dał trzem zdrajcom odpocząć. Na zawsze."

L.aw_nki4_title = "Hitman do wynajĘcia"
L.aw_nki4_text = "otrzymywał wynagrodzenie za każdego zabitego. Teraz zamawia swój piąty basen."

L.aw_fal1_title = "Nie, Panie Bond, OczekujĘ, Że Spadniesz"
L.aw_fal1_text = "zrzucił kogoś z dużej wysokości."

L.aw_fal2_title = "ZapodŁogowany"
L.aw_fal2_text = "pozwolił ciału uderzyć w podłogę z impetem po pięknym locie."

L.aw_fal3_title = "Ludzki Meteoryt"
L.aw_fal3_text = "zmiażdżył kogoś spadająć na niego z dużej wysokości."

L.aw_hed1_title = "EfektywnoŚĆ"
L.aw_hed1_text = "odkrył radość ze strzelania w głowy i trafił ich {num}."

L.aw_hed2_title = "Neurologia"
L.aw_hed2_text = "usunął mózgi z {num} głów dla bliższych oględzin."

L.aw_hed3_title = "Gry Mnie Do Tego ZmusiŁy"
L.aw_hed3_text = "wykorzystał swoje szkolenie na symulatorach morderstwa i strzelił headshottów {num} wrogom."

L.aw_cbr1_title = "BrzdĘk BrzdĘk BrzdĘk"
L.aw_cbr1_text = "potrafi nieźle przywalić łomem, dowiedziało się o tym {num} ofiar."

L.aw_cbr2_title = "Freeman"
L.aw_cbr2_text = "pogrzebał w mózgach nie mniej niż {num} ludziom."

L.aw_pst1_title = "TrwaŁy MaŁy Pistolecik"
L.aw_pst1_text = "uzyskał {num} zabójstw używając pistoletu. Następnie poszedł kogoś zatulić na śmierć."

L.aw_pst2_title = "UbÓj MaŁego Kalibru"
L.aw_pst2_text = "zabił małą armię {num} osób z pistoletu. Prawdopodobnie zamocował małą strzelbę w lufie."

L.aw_sgn1_title = "Easy Mode"
L.aw_sgn1_text = "posyła śrut tam gdzie boli, mordując {num} celi."

L.aw_sgn2_title = "TysiĄc MaŁych PociskÓw"
L.aw_sgn2_text = "nie lubi swojego śrutu, więc dał go innym. {num} odbiorców nie żyje, by się tym cieszyć."

L.aw_rfl1_title = "Wyceluj i Kliknij"
L.aw_rfl1_text = "pokazuje, że wszystko czego potrzebuje do {num} zabójst jest snajperka i pewna ręka."

L.aw_rfl2_title = "WidzĘ StĄd TwojĄ GłowĘ"
L.aw_rfl2_text = "zna swoją broń. Teraz {num} ludzi też ją zna."

L.aw_dgl1_title = "To Jak MaŁa Snajperka!"
L.aw_dgl1_text = "dostał w swoje ręce Desert Eagle i zabił {num} ludzi."

L.aw_dgl2_title = "Mistrz Desert Eagle"
L.aw_dgl2_text = "zniszczył {num} ludzi z deaglem."

L.aw_mac1_title = "MÓdl Się I Zabijaj"
L.aw_mac1_text = "zabił {num} ludzi z MAC10, ale nie pytaj ile amunicji zużył."

L.aw_mac2_title = "MAC Z Serem"
L.aw_mac2_text = "wyobraź sobie co by się stało gdyby używał dwóch MAC10. {num} razy dwa?"

L.aw_sip1_title = "BĄdŹ Cicho"
L.aw_sip1_text = "zabił {num} ludzi pistoletem z tłumikiem."

L.aw_sip2_title = "SkrytobÓjca"
L.aw_sip2_text = "zabił {num} ludzi, którzy nawet nie słyszeli swojej śmierci."

L.aw_knf1_title = "NÓŻ Cię Nie Ominie"
L.aw_knf1_text = "zabił kogoś z nożem przez internet."

L.aw_knf2_title = "SkĄd To WziĄŁeś?"
L.aw_knf2_text = "nie był zdrajcą, ale i tak zabił kogoś nożem."

L.aw_knf3_title = "Po Prostu CzŁowiek Z NoŻami"
L.aw_knf3_text = "znalazł {num} noży leżących do okoła i zrobił z nich użytek."

L.aw_knf4_title = "CzŁowiek Przecinak"
L.aw_knf4_text = "zabił {num} ludzi nożem. Nie pytaj jak."

L.aw_flg1_title = "Na Ratunek"
L.aw_flg1_text = "użył flar do sygnalizacji {num} śmierci."

L.aw_flg2_title = "Flara = PoŻar"
L.aw_flg2_text = "nauczył {num} ludzi o niebezpieczeństwie noszenia łątwopalnych ubrań."

L.aw_hug1_title = "RATTATTATTATTA"
L.aw_hug1_text = "użył swojego H.U.G.E, by zabić {num} ludzi."

L.aw_hug2_title = "Cierpliwy Strzelec"
L.aw_hug2_text = "po prostu strzelał i zobaczył, że przyniosło mu to rezultat {num} zabójstw."

L.aw_msx1_title = "Pyk Pyk Pyk"
L.aw_msx1_text = "wystrzelał {num} ludzi z M16."

L.aw_msx2_title = "Średnio ZasiĘgowe SzaleŃstwo"
L.aw_msx2_text = "wie jak ściągać ludzi z M16, osiągając {num} zabóstw."

L.aw_tkl1_title = "Ups"
L.aw_tkl1_text = "osunął mu się palec, gdy celował w kolegę."

L.aw_tkl2_title = "PodwÓjne Ups"
L.aw_tkl2_text = "myślał, że był zdrajcą dwa razy, ale pomylił się dwa razy."

L.aw_tkl3_title = "Co To Karma?"
L.aw_tkl3_text = "nie mógł poprzestać na dwóch ofiarach. Trzy to szczęśliwa liczba."

L.aw_tkl4_title = "Teamkiller"
L.aw_tkl4_text = "wymordował całą swoją drużynę. OMGBANBANBAN."

L.aw_tkl5_title = "Roleplayer"
L.aw_tkl5_text = "grał rolę szaleńca. Dlatego zabił większość swojej drużyny."

L.aw_tkl6_title = "Debil"
L.aw_tkl6_text = "nie potrafił zrozumieć, z którą stroną był, i zabił ponad połowę swoich towarzyszy."

L.aw_tkl7_title = "WieŚniak"
L.aw_tkl7_text = "skutecznie bronił sowjej ziemii zabijąc ćwierć drużyny."

L.aw_brn1_title = "Takie Jak Babcia RobiŁa"
L.aw_brn1_text = "przypiekł na chrupiąco pare ludzi."

L.aw_brn2_title = "Piromanta"
L.aw_brn2_text = "śmiał się głośno po spaleniu jednej ze swoich ofiar."

L.aw_brn3_title = "Pyrrysowy Palacz"
L.aw_brn3_text = "spalił je wszyskie, ale teraz brak mu granatów! Jak on sobie poradzi!?"

L.aw_fnd1_title = "Koroner"
L.aw_fnd1_text = "znalazł {num} ciał leżących wokół."

L.aw_fnd2_title = "ZŁap Je Wszystkie"
L.aw_fnd2_text = "znalazł {num} ciał do jego kolekcji."

L.aw_fnd3_title = "Zapach Śmierci"
L.aw_fnd3_text = "co chwilę znajduje przypadkowe zwłoki. Znalazł ich {num} w tej rundzie."

L.aw_crd1_title = "Mistrz Recyklingu"
L.aw_crd1_text = "znalazł {num} kredytów przy trupach."

L.aw_tod1_title = "Pyrrusowe ZwyciĘstwo"
L.aw_tod1_text = "zginął chwile przed wygraną jego drużyny."

L.aw_tod2_title = "NienawidzĘ Tej Gry"
L.aw_tod2_text = "umarł zaraz po rozpoczęciu rundy."

-- New and modified pieces of text are placed below this point, marked with the
-- version in which they were added, to make updating translations easier.

--- v24
L.drop_no_ammo = "Niewystarczająca ilość amunicji w magazynku twojej broni do upuszczenia pudełka amunicji."

--- 2015-05-25
L.hat_retrieve = "Podniosłeś czapkę detektywa."

-- 2017-09-03
L.sb_sortby = "Sortuj:"

-- 2018-07-24
L.equip_tooltip_main = "Menu Ekwipunktu"
L.equip_tooltip_radar = "Kontrola radaru"
L.equip_tooltip_disguise = "Kontrola przebrania"
L.equip_tooltip_radio = "Kontrola radia"
L.equip_tooltip_xfer = "Transfer kredytów"
L.equip_tooltip_reroll = "Reroll"

L.confgrenade_name = "Discobomba"
L.polter_name = "Poltergeist"
L.stungun_name = "UMP Proto"

L.knife_instant = "ZGON NA MIEJSCU"

L.binoc_zoom_level = "Powiększenie"
L.binoc_body = "WYKRYTO CIAŁO"

L.idle_popup_title = "Bezczynny"

-- 2019-01-31
L.create_own_shop = "Stwórz własny sklep"
L.shop_link = "Połącz z..."
L.shop_disabled = "Wyłącz sklep"
L.shop_default = "Użyj domyślnego sklepu"

-- 2019-05-05
L.reroll_name = "Losuj"
L.reroll_menutitle = "Losuj przedmioty"
L.reroll_no_credits = "Potrzebujesz {amount} kredytów żeby losować!"
L.reroll_button = "Losuj"
L.reroll_help = "Użyj {amount} kredytów aby wylosować przedmiot!"

-- 2019-05-06
L.equip_not_alive = "Możesz teraz zobaczyć zawartość sklepu, nie zapomnij dodać ulubionych!"

-- 2019-06-27
L.shop_editor_title = "Edytor sklepu"
L.shop_edit_items_weapong = "Edytuj Itemy/ Bronie"
L.shop_edit = "Edytuj sklepy"
L.shop_settings = "Ustawienia"
L.shop_select_role = "Wybierz rolę"
L.shop_edit_items = "Edytuj itemy"
L.shop_edit_shop = "Edytuj sklep"
L.shop_create_shop = "Stwórz specjalny sklep"
L.shop_selected = "Wybrano {role}"
L.shop_settings_desc = "Adaptacja Randomowego Sklepu."

L.bindings_new = "Nowy klawisz dla {name}: {key}"

L.hud_default_failed = "Nie udało się ustawić {hudname} jako domoślne. Nie masz permisji, albo HUD nie istnieje."
L.hud_forced_failed = "Nie udało się wymusić HUD {hudname}. Nie masz permisji, albo HUD nie istnieje."
L.hud_restricted_failed = "Nie udało się nadać restrykcji HUDa {hudname}. Nie masz permisji."

L.shop_role_select = "Wybierz rolę"
L.shop_role_selected = "{roles} wybrano do sklepu!"
L.shop_search = "Szukaj"

L.spec_help = "Kliknij by obserować gracza, lub kliknij {usekey} na obiekt fizyczny, by go posiąść."
L.spec_help2 = "Aby opuścić tryb widza, naciśnij guzik {helpkey}, idź do 'rozgrywa' i zmień tryb obserwatora."

-- 2019-10-19
L.drop_ammo_prevented = "Coś Cię powstrzymuje przed wyrzuceniem amunicji."

-- 2019-10-28
L.target_c4 = "Naciśnij [{usekey}] aby otworzyć menu C4"
L.target_c4_armed = "Naciśnij [{usekey}] aby rozborić C4"
L.target_c4_armed_defuser = "Naciśnij [{usekey}] aby rozborić przyżądem"
L.target_c4_not_disarmable = "Nie możesz rozbroić bomby żywego gracza"
L.c4_short_desc = "Coś bardzo wybuchowego"

L.target_pickup = "Naciśnij [{usekey}] aby podnieść"
L.target_slot_info = "Slot: {slot}"
L.target_pickup_weapon = "Naciśnij [{usekey}] aby ponieść broń"
L.target_switch_weapon = "Naciśnij [{usekey}] aby zamienić broń"
L.target_pickup_weapon_hidden = ", Naciśnij [{usekey} + {walkkey}] dla ukrytego podniesienia"
L.target_switch_weapon_hidden = ", Naciśnij [{usekey} + {walkkey}] dla ukrytej zamiany"
L.target_switch_weapon_nospace = "Brak slotu!"
L.target_switch_drop_weapon_info = "Upuszczanie {name} ze slotu {slot}"
L.target_switch_drop_weapon_info_noslot = "Broni z tego slotu {slot} nie można wywalić"

L.corpse_searched_by_detective = "Te ciało przeszukał detektyw"
L.corpse_too_far_away = "Ciało jest za daleko."

L.radio_pickup_wrong_team = "Nie możesz mieć radio innego teamu."
L.radio_short_desc = "Wystrzały broni są dla mnie muzyką"

L.hstation_subtitle = "Naciśnij [{usekey}] aby otrzymać życie."
L.hstation_charge = "Pozostały ładunek: {charge}"
L.hstation_empty = "Brak ładunku"
L.hstation_maxhealth = "Życie pełne"
L.hstation_short_desc = "Powoli odnawia swój ładunek"

-- 2019-11-03
L.vis_short_desc = "Wskazuje co się działo podczas zabójstwa"
L.corpse_binoculars = "Naciśnij [{key}] aby przeszukać ciało lornetką."
L.binoc_progress = "Wyszukiwanie: {progress}%"

L.pickup_no_room = "Nie masz już miejsca na ten przedmiot!"
L.pickup_fail = "Nie możesz podnieść tej broni"
L.pickup_pending = "Podniosłeś już broń! Poczekaj, aż ją otrzymasz!"

-- 2020-01-07
L.tbut_help_admin = "Edytuj ustawienia guzika zdrajcy"
L.tbut_role_toggle = "[{walkkey} + {usekey}] aby włączyć ten przycisk dla roli {role}"
L.tbut_role_config = "Rola: {current}"
L.tbut_team_toggle = "[SHIFT + {walkkey} + {usekey}] aby włączyć ten guzik dla teamu {team}"
L.tbut_team_config = "Team: {current}"
L.tbut_current_config = "Obecne ustawienia:"
L.tbut_intended_config = "Domyślny config twórcy mapy:"
L.tbut_admin_mode_only = "Widoczne tylko gdy jesteś adminem lub '{cv}' jest ustawione na '1'"
L.tbut_allow = "Pozwól"
L.tbut_prohib = "Zabroń"
L.tbut_default = "Domyślne"

-- 2020-02-09
L.name_door = "Drzwi"
L.door_open = "Naciśnij [{usekey}] aby otworzyć drzwi."
L.door_close = "Naciśnij [{usekey}] aby zamknąć drzwi"
L.door_locked = "Drzwi są zamknięte"

-- 2020-02-11
L.automoved_to_spec = "(SERWER) Zostałeś przeniesiony do teamu obserwujących za brak aktywności!"
L.mute_team = "{team} zmutowani."

-- 2020-02-16
L.door_auto_closes = "Te drzwi zamykają się same"
L.door_open_touch = "Wejdź w drzwi żeby je otworzyć."
L.door_open_touch_and_use = "Wejdź w drzwi i naciśnij [{usekey}] aby otworzyć."
L.hud_health = "Zdrowie"

-- 2020-03-09
L.help_title = "Pomoc i ustawienia"

L.menu_changelog_title = "Zmiany"
L.menu_guide_title = "TTT2 Poradnik"
L.menu_bindings_title = "Bindy"
L.menu_language_title = "Język"
L.menu_appearance_title = "Wygląd"
L.menu_gameplay_title = "Rozgrywka"
L.menu_addons_title = "Addony"
L.menu_legacy_title = "Addony(Legacy)"
L.menu_administration_title = "Administrowanie"
L.menu_equipment_title = "Edytuj Zaopatrzenie"
L.menu_shops_title = "Edytuj Sklepy"

L.menu_changelog_description = "Lista zmian w ostatnich wersjach"
L.menu_guide_description = "Pomaga zapoznać się z TTT i pomóc Ci je zrozumieć"
L.menu_bindings_description = "Ustaw swoje własne bindy dotyczące rozgrywki"
L.menu_language_description = "Wybierz język gry"
L.menu_appearance_description = "Popraw wygląd i wydajność UI"
L.menu_gameplay_description = "Unikaj ról, bądź widzem itp"
L.menu_addons_description = "Konfiguracja addonów"
L.menu_legacy_description = "Panle z przekonwertowanymi addonami TTT, powinny być przeportowane do nowego systemu"
L.menu_administration_description = "Ustawienia generalne HUDu, sklepów itd."
L.menu_equipment_description = "Ustaw kredyty, limity, dostępność i pozostałe rzeczy"
L.menu_shops_description = "Dodaj/Usuwaj sklepy i przedmioty w nich"

L.submenu_guide_gameplay_title = "Rozgrywka"
L.submenu_guide_roles_title = "Role"
L.submenu_guide_equipment_title = "Przedmioty"

L.submenu_bindings_bindings_title = "Bindy"

L.submenu_language_language_title = "Język"

L.submenu_appearance_general_title = "Główne"
L.submenu_appearance_hudswitcher_title = "Przełącznik HUDa"
L.submenu_appearance_vskin_title = "VSkin"
L.submenu_appearance_targetid_title = "TargetID"
L.submenu_appearance_shop_title = "Ustawienia sklepu"
L.submenu_appearance_crosshair_title = "Celownik"
L.submenu_appearance_dmgindicator_title = "Pow. o obrażeniach"
L.submenu_appearance_performance_title = "Wydajność"
L.submenu_appearance_interface_title = "Interfejs"
L.submenu_appearance_miscellaneous_title = "Różne"

L.submenu_gameplay_general_title = "Główne"
L.submenu_gameplay_avoidroles_title = "Unikaj ról"

L.submenu_administration_hud_title = "Ustawienia HUDa"
L.submenu_administration_randomshop_title = "Losowy Sklep"

L.help_color_desc = "Jeśli włączone, kolor globalny ustawiany dla obrysu (targetID) i koloru celownika."
L.help_scale_factor = "Skaluje wszystkie elemnty UI (HUD, vgui i targetID). Dostosowuje się automatycznie do rozdzielczości. Zmiana tej wartości zresetuje HUD!"
L.help_hud_game_reload = "Ten HUD jest obecnie niedostępny. Gramu musi być przeładowana"
L.help_hud_special_settings = "Szczegółowe ustawienia tego HUDa."
L.help_vskin_info = "VSkin (skórka vgui) to skórka używana w każdym menu. Skórki można łatwo robić poprzez lua i kolory."
L.help_targetid_info = "TargetID jest dla zaawansowanych. Naprawiony kolor można dodać w ustawieniach."
L.help_hud_default_desc = "Ustawia domyślny HUD dla każdego gracza. Gracze którzy nie wybrali żadnego HUDa będą mieć ten. Nie zmieni HUDa graczy którzy już go zmienili."
L.help_hud_forced_desc = "Wymusza HUD dla każdego gracza. Wylącza możliwość wyboru HUDu."
L.help_hud_enabled_desc = "Włącz/wyłącz restrykcję HUDów."
L.help_damage_indicator_desc = "Powiadomiena o obrażeniach pojawiąją się dookoła ekranu. Aby zmienić wygląd zajrzyj do 'materials/vgui/ttt/damageindicator/themes/'."
L.help_shop_key_desc = "Otworzyć sklep zamiast ekranu końca rundy guzikiem podczas końca/początku rundy?"

L.label_menu_menu = "MENU"
L.label_menu_admin_spacer = "Strefa Admina"
L.label_language_set = "Wybierz Język"
L.label_global_color_enable = "Włącz kolor globalny"
L.label_global_color = "Globalny Kolor"
L.label_global_scale_factor = "Globalna Skala"
L.label_hud_select = "Wybierz HUDa"
L.label_vskin_select = "Wybierz VSkin"
L.label_blur_enable = "Włącz blur dla tła VSkina"
L.label_color_enable = "Zezwól na VSkin kolor tła"
L.label_minimal_targetid = "Minimalistyczny status celu pod celownikiem (bez karmy, porad, itp)"
L.label_shop_always_show = "Zawsze pokazuj sklep"
L.label_shop_double_click_buy = "Zezwól na kupoanie przedmiotów poprzed podwtójne wciśnięcie"
L.label_shop_num_col = "Liczba kolumn"
L.label_shop_num_row = "Liczba rzędów"
L.label_shop_item_size = "Liczba rzędów"
L.label_shop_show_slot = "Pokaż sloty"
L.label_shop_show_custom = "Pokaż customowe intemy"
L.label_shop_show_fav = "Pokaż ulubione itemy"
L.label_crosshair_enable = "Włącz celownik"
L.label_crosshair_gap_enable = "Umożliw odstęp"
L.label_crosshair_gap = "Odstęp celownika"
L.label_crosshair_opacity = "Ukrycie celownika podczas korzystania z celowniku mechanicznego"
L.label_crosshair_ironsight_opacity = "Widoczność celownika z przycelowania"
L.label_crosshair_size = "Wielkość celownika"
L.label_crosshair_thickness = "Grubość celownika"
L.label_crosshair_thickness_outline = "Grubość otoczki celownika"
L.label_crosshair_static_enable = "Umożliw statyczny celownik "
L.label_crosshair_dot_enable = "Umożliw kropkę celownika"
L.label_crosshair_lines_enable = "Zezwól na linie celownika"
L.label_crosshair_scale_enable = "Umożliw różne wielkości"
L.label_crosshair_ironsight_low_enabled = "Obniż broń podczas użycia celowniku mechanicznego"
L.label_damage_indicator_enable = "Enable damage indicator"
L.label_damage_indicator_mode = "Wybierz motyw"
L.label_damage_indicator_duration = "Liczba sekund widoczności"
L.label_damage_indicator_maxdamage = "Obrażenia do maksymalnej widoczności"
L.label_damage_indicator_maxalpha = "Obrażenia do minimalnej widoczności"
L.label_performance_halo_enable = "Dodaj otoczkę na przedmioty patrząc na nie"
L.label_performance_spec_outline_enable = "Włącz obwódkę przedmiotów"
L.label_performance_ohicon_enable = "Włącz ikony ról na głową"
L.label_interface_tips_enable = "Pokaż wskazówki dotyczące rozgrywki u dołu ekranu, podczas trybu obserwatora"
L.label_interface_popup = "Czas okienka inforamcji na pocztątku rundy"
L.label_interface_fastsw_menu = "Włącz menu z szybkim przełączniem broni"
L.label_inferface_wswitch_hide_enable = "Włącz chowanie się menu zmiany broni"
L.label_inferface_scues_enable = "Zagraj dźwięk, kiedy runda się rozpoczyna lub kończy"
L.label_gameplay_specmode = "Tryb obserwatora (zawsze bądź obserwatorem)"
L.label_gameplay_fastsw = "Szybkie przełącznie broni"
L.label_gameplay_hold_aim = "Trzymaj aby celować"
L.label_gameplay_mute = "Wycisz żyjących graczy, gdy zginiesz"
L.label_gameplay_dtsprint_enable = "Włącz 2x przód, aby sprintować"
L.label_gameplay_dtsprint_anykey = "Sprintuj dopóki Ci się nie szkończy wytrzymałość"
L.label_hud_default = "Zwykły HUD"
L.label_hud_force = "Wymuszony HUD"

L.label_bind_weaponswitch = "Zmień broń"
L.label_bind_sprint = "Sprint"
L.label_bind_voice = "Globalny Czat"
L.label_bind_voice_team = "Teamowy Czat"

L.label_hud_basecolor = "Kolor bazowy"

L.label_menu_not_populated = "To menu nie ma w sobie nic."

L.header_bindings_ttt2 = "Bindy TTT2"
L.header_bindings_other = "Inne bindy"
L.header_language = "Ustawienia języka"
L.header_global_color = "Wybierz kolor globalny"
L.header_hud_select = "Wybierz HUD"
L.header_hud_customize = "Personalizuj HUD"
L.header_vskin_select = "Wybierz i zmień VSkin"
L.header_targetid = "Ustawienia TargetID"
L.header_shop_settings = "Menu przdmiotów sklepu"
L.header_shop_layout = "Układ listy"
L.header_shop_marker = "Ustawienia tworzenie przedmiotów"
L.header_crosshair_settings = "Ustawienia celownika"
L.header_damage_indicator = "Ustawienia powiadomień obrażeń"
L.header_performance_settings = "Ustawienia Wydajności"
L.header_interface_settings = "Ustawienia interfejsu"
L.header_gameplay_settings = "Ustawienia rozgrywki"
L.header_roleselection = "Włącz przypisywanie ról"
L.header_hud_administration = "Wybierz Domyślne i wymuś HUDy"
L.header_hud_enabled = "Włącz/Wyłącz HUDy"

L.button_menu_back = "Wróć"
L.button_none = "Brak"
L.button_press_key = "Naciśnij klawisz"
L.button_save = "Zapisz"
L.button_reset = "Reset"
L.button_close = "Zamknij"
L.button_hud_editor = "Edytor HUDa"

-- 2020-04-20
L.item_speedrun = "Wyścig"
L.item_speedrun_desc = [[Jesteś o 50% szybszy!]]
L.item_no_explosion_damage = "Odporność Na Obrażenia"
L.item_no_explosion_damage_desc = [[Stajesz się w pełni odporny na wybuchy.]]
L.item_no_fall_damage = "Odporność Na Upadki"
L.item_no_fall_damage_desc = [[Stajesz się odporny na upadki.]]
L.item_no_fire_damage = "Ognioodporny"
L.item_no_fire_damage_desc = [[Stajesz się odporny na ogień.]]
L.item_no_hazard_damage = "Odporność Na Zatrucia"
L.item_no_hazard_damage_desc = [[Stajesz się odporny na truciznę, radjacje itp.]]
L.item_no_energy_damage = "Odporność Na Energię"
L.item_no_energy_damage_desc = [[Stajesz się odporny na lasery, plazmę oraz pioruny.]]
L.item_no_prop_damage = "Odporność Na Przedmioty"
L.item_no_prop_damage_desc = [[Stajesz się odporny na obrażenia od przedmiotów.]]
L.item_no_drown_damage = "Odporność Na Topienie Się"
L.item_no_drown_damage_desc = [[Stajesz się odporny na wodę w płucach.]]

-- 2020-04-21
L.dna_tid_possible = "Możliwy skan"
L.dna_tid_impossible = "Brak skanów"
L.dna_screen_ready = "Brak DNA"
L.dna_screen_match = "Dopasuj"

-- 2020-04-30
L.message_revival_canceled = "Odrodzenie anulowane."
L.message_revival_failed = "Odrodzenie nieudane."
L.message_revival_failed_missing_body = "Nie zostałeś ożywiony, ponieważ twoje ciało już nie istnieje."
L.hud_revival_title = "Czas pozostały do odrodzenia:"
L.hud_revival_time = "{time}s"

-- 2020-05-03
L.door_destructible = "Te drzwi da się zniszczyć ({health}PW)"

-- 2020-05-28
L.confirm_detective_only = "Tylko detektywni mogą potwierdzić ciało"
L.inspect_detective_only = "Tylko detektywni mogą sprawdzać ciało"
L.corpse_hint_no_inspect = "Tylko detektywni mogą przeszukać ciało"
L.corpse_hint_inspect_only = "Naciśnij [{usekey}] aby wyszukać. Tylko detektywni mogą potwierdzić ciało."
L.corpse_hint_inspect_only_credits = "Naciśnij [{usekey}] aby otrzymać kredyty. Tylko detektywni mogą przeszukać ciało."

-- 2020-06-04
L.label_bind_disguiser = "Przełącz przebranie"

-- 2020-06-24
L.dna_help_primary = "Zbierz próbkę DNA"
L.dna_help_secondary = "Zmień slot DNA"
L.dna_help_reload = "Usuń próbkę"

L.binoc_help_pri = "Rozpoznaj Ciało."
L.binoc_help_sec = "Zmień Przybliżenie."

L.vis_help_pri = "Wyrzuć aktywne urządzenie."

L.decoy_help_pri = "Rozstaw Wabik."

-- 2020-08-07
L.pickup_error_spec = "Nie możesz tego zrobić jako widz."
L.pickup_error_owns = "Nie możesz tego podnieść, bo już masz tą broń."
L.pickup_error_noslot = "Nie możesz tego podnieść, bo nie masz na to miejsca."

-- 2020-11-02
L.lang_server_default = "Ustawienie Serwera"
L.help_lang_info = [[
Te tłumaczenie ma w sobie {coverage}% angielskich tłumaczeń.

--Weż pod uwagę że tłumaczenia są robione przez społeczność, możesz pomóc je robić!]]

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
--L.title_event_game = "A new round started"
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
L.trap_something = "coś"

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
L.none = "Brak Roli"

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

--2021-06-09
--L.scoreboard_voice_tooltip = "Scroll to change the volume"
