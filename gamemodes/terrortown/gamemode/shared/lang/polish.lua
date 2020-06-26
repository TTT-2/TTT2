-- Polish language strings

local L = LANG.CreateLanguage("Polski")

-- General text used in various places
L.traitor    = "Zdrajca"
L.detective  = "Detektyw"
L.innocent   = "Niewinny"
L.last_words = "Ostatnie słowa"

L.terrorists = "Terroryści"
L.spectators = "Obserwatorzy"

L.noteam = "BRAK TEAMU"
L.innocents = "TEAM Niewinni"
L.traitors = "TEAM Zdrajcy"

-- role description
L.ttt2_desc_none = "Obecnie nie masz roli!"
L.ttt2_desc_innocent = "Twoim celem jest przerwanie!"
L.ttt2_desc_traitor = "Zabij każdego kto nie jest zdrajcą z pomocą sklepu ([C])!"
L.ttt2_desc_detective = "Jesteś detektywem, pomóż niewinnym przetrwać i pokonaj zdrajców!"

-- Round status messages
L.round_minplayers = "Nie wystarczająca ilość graczy do rozpoczęcia nowej rundy"
L.round_voting     = "Głosowanie w toku, opóźnia nową rundę o {num} sekund..."
L.round_begintime  = "Nowa runda zacznie się za {num} sekund. Przygotuj się."
L.round_selected   = "Zdrajcy zostali wybrani."
L.round_started    = "Runda rozpoczeła się!"
L.round_restart    = "Admin postanowił zrestartować rundę."

L.round_traitors_one  = "Zdrajco, pracujesz sam"
L.round_traitors_more = "Zdrajco, to są twoi sojusznicy: {names}"

L.win_time         = "Czas minął. Zdrajcy przegrali."
L.win_traitors     = "Zdrajcy wygrali!"
L.win_innocents    = "Zdrajcy zostali pokonani!"
L.win_bees         = "Wygrały pszczoły! (To oznacza remis)"
L.win_showreport   = "Spójrzmy na raport rundy na {num} sekund."

L.limit_round      = "Limit rund osiągnięty. {mapname} wkrótce się załaduje."
L.limit_time       = "Limit czasowy osiągnięty. {mapname} wkrótce się załaduje."
L.limit_left       = "{num} rund(a), albo {time} minut, do zmiany mapy na {mapname}."

-- Credit awards
L.credit_all = "Twój team został nagrodzony {num} kredytami na zakupy."

L.credit_kill      = "Zdobyłeś {num} kredyt(ów) za zabicie {role}."

-- Karma
L.karma_dmg_full   = "Twoja karma to {amount}, dlatego w tej rundzie zadajesz pełne obrażenia!"
L.karma_dmg_other  = "Twoja karma to {amount}. Dlatego twoje obrażenia zostaną zredukowane o {num}%"

-- Body identification messages
L.body_found       = "{finder} znalazł ciało {victim}. {role}"
L.body_found_team = "{finder} znalazł ciało {victim}. {role} ({team})"

-- The {role} in body_found will be replaced by one of the following:
L.body_found_traitor      = "On był zdrajcą!"
L.body_found_det    = "On był detektywem."
L.body_found_inno    = "On był niewinny."

L.body_confirm     = "{finder} potwierdził śmierć {victim}."

L.body_call        = "{player} zawołał detektywa do ciała {victim}!"
L.body_call_error  = "Musisz potwierdić zgon tego gracza, zanim zawołasz detektywa!"

L.body_burning     = "O nie! Te zwłoki się palą!"
L.body_credits     = "Znalazłeś {num} kredyt(ów) na ciele!"

--- Menus and windows
L.close = "Zamknij"
L.cancel = "Anuluj"

-- For navigation buttons
L.next = "Następny"
L.prev = "Poprzedni"


-- Equipment buying menu
L.equip_title     = "Wyposażenie"
L.equip_tabtitle  = "Zamów wyposażenie"

L.equip_status    = "Status zamówienia"
L.equip_cost      = "Został(o) ci {num} kredyt(ów)."
L.equip_help_cost = "Każdy element sprzęty kosztuje 1 kredyt."

L.equip_help_carry = "Możesz kupować jedynie przedmioty na, które masz miejsce."
L.equip_carry      = "Możesz wziąć ten przedmiot."
L.equip_carry_own  = "Aktualnie posiadasz ten przedmiot."
L.equip_carry_slot = "Posiadasz już inny przedmiot na slocie {slot}."

L.equip_help_stock = "Istnieją przedmioty, które możesz kupić tylko raz na rundę."
L.equip_stock_deny = "Ten przedmiot nie jest już dłużej dostępny."
L.equip_stock_ok   = "Ten przedmiot jest dostępny."

L.equip_custom     = "Przedmiot dodany przez serwer."

L.equip_spec_name  = "Nazwa"
L.equip_spec_type  = "Typ"
L.equip_spec_desc  = "Opis"

L.equip_confirm    = "Kup wyposażenie"

L.equip_not_alive = "Możesz teraz zobaczyć zawartość sklepu, nie zapomnij dodać ulubionych!"

-- Disguiser tab in equipment menu
L.disg_name      = "Przebranie"
L.disg_menutitle = "Obsługa przebrania"
L.disg_not_owned = "Nie masz przebrania!"
L.disg_enable    = "Włącz przebranie"

L.disg_help1     = "Kiedy twoje przebranie jest aktywne, twoje imie, zdrowie i karma nie będzie widoczna, gdy ktoś na ciebie spojrzy. Ponadto, będziesz niewidzoczny dla radaru Detektywa."
L.disg_help2     = "Kliknij Enter na Numpadzie, by przełączać przebranie bez używania menu. Możesz też ustawić inny przycisk do 'ttt_toggle_disguise' używając konsoli."

-- Radar tab in equipment menu
L.radar_name      = "Radar"
L.radar_menutitle = "Obsługa radaru"
L.radar_not_owned = "Nie masz radaru!"
L.radar_scan      = "Wykonaj skanowanie"
L.radar_auto      = "Auto-powtarzaj skanowanie"
L.radar_help      = "Wyniki skanowania pokazują się na {num} sekund, po którym radar zostanie przeładowany i będzie mógł być ponownie użyty."
L.radar_charging  = "Twój radar nadal się ładuje!"

-- Transfer tab in equipment menu
L.xfer_name       = "Transfer"
L.xfer_menutitle  = "Transferuj kredyty"
L.xfer_no_credits = "Nie masz żądnych kredytów do dania!"
L.xfer_send       = "Wyślij kredyty"
L.xfer_help       = "Możesz tylko wysłać kredyty do graczy w roli {role}."

L.xfer_no_recip   = "Odbiorca nie jest prawidłowy, transfer kredytów został przerwany."
L.xfer_no_credits = "Niewystarczająca ilość kreytów do transferu."
L.xfer_success    = "Transfer kredytów do {player} zakończony."
L.xfer_received   = "{player} dał ci {num} kredyt(ów)."


-- Reroll tab in equipment menu
L.reroll_name = "Reroll"
L.reroll_menutitle = "Reroll Items"
L.reroll_no_credits = "You need {amount} credits to reroll!"
L.reroll_button = "Reroll"
L.reroll_help = "Use {amount} credits to get new items in your shop!"

-- Radio tab in equipment menu
L.radio_name      = "Radio"
L.radio_help      = "Klkinij przycisk, by twoje radio zaczeło grać."
L.radio_notplaced = "Musisz postawić radio, by móc puścić jakieś dźwięki."

-- Radio soundboard buttons
L.radio_button_scream  = "Krzyk"
L.radio_button_expl    = "Eksplozja"
L.radio_button_pistol  = "Strzały z pistoletu"
L.radio_button_m16     = "Strzały z M16"
L.radio_button_deagle  = "Strzały z Deagle'a"
L.radio_button_mac10   = "Strzały z MAC10"
L.radio_button_shotgun = "Strzałty z shotguna"
L.radio_button_rifle   = "Strzały z Rifle'a"
L.radio_button_huge    = "Wystrzały z H.U.G.E"
L.radio_button_c4      = "Pikanie C4"
L.radio_button_burn    = "Palenie się"
L.radio_button_steps   = "Kroki"


-- Intro screen shown after joining
L.intro_help     = "Jeśli jesteś nowy w grze, kliknij F1 dla instrukcji!"

-- Radiocommands/quickchat
L.quick_title   = "Szybkie odpowiedzi"

L.quick_yes     = "Tak."
L.quick_no      = "Nie."
L.quick_help    = "Pomocy!"
L.quick_imwith  = "Jestem z {player}."
L.quick_see     = "Widzę {player}."
L.quick_suspect = "{player} jest podejrzany."
L.quick_traitor = "{player} jest zdrajcą!"
L.quick_inno    = "{player} jest niewinny."
L.quick_check   = "Ktoś jeszcze żyje?"

L.radio_pickup_wrong_team = "Nie możesz mieć radio innego teamu."
L.radio_short_desc = "Wystrzały broni są dla mnie muzyką"

-- {player} in the quickchat text normally becomes a player nickname, but can
-- also be one of the below.  Keep these lowercase.
L.quick_nobody    = "nikt"
L.quick_disg      = "ktoś w przebraniu"
L.quick_corpse    = "niezidentyfikowane zwłoki"
L.quick_corpse_id = "ciało gracza {player}"


--- Body search window
L.search_title  = "Rezultaty przeszukania ciała"
L.search_info   = "Informacje"
L.search_confirm = "Potwierdź śmierć"
L.search_call   = "Zawołaj detektywa"

-- Descriptions of pieces of information found
L.search_nick   = "To jest ciało gracza {player}."

L.search_role_t = "Ta osoba była zdrajcą!"
L.search_role_d = "Ta osoba była detektywem."
L.search_role_i = "Ta osoba była niewinnym terrorystą."

L.search_words  = "Coś ci mówi, że jego ostanie słowa to: '{lastwords}'"
L.search_armor  = "On nosił niestandardową kamizelkę kuloodporną."
L.search_disg   = "Trzymał urządzenie, które mogło ukryć jego tożsamość."
L.search_radar  = "Miał jakiegoś rodzaju radar. Już nie działa."
L.search_c4     = "W kieszeni znalazłeś notkę. Stwierdza, że przecięcie przewodu {num} bezpiecznie rozbroi bombę."

L.search_dmg_crush  = "Wiele z jego kości jest połamanych. To pokazuje, że zabił go jakiś duży obiekt."
L.search_dmg_bullet = "Jest oczywiste, że został zastrzelony na śmierć."
L.search_dmg_fall   = "Spadł i połamał sobie kark."
L.search_dmg_boom   = "Stan jego ubrania pokazują, że wybuch zakończył jego żywot."
L.search_dmg_club   = "Ciało jest posiniaczone i poobijane. Najwyraźniej został zatłuczony na śmierć."
L.search_dmg_drown  = "Ciało wykazuje, że delikwent utonął."
L.search_dmg_stab   = "Został dźgnięty nożem, zanim szybko się wykrwawił."
L.search_dmg_burn   = "Pachnie jak pieczony terrorysta..."
L.search_dmg_tele   = "Jego DNA zostało uszkodzone przez fale tachionu."
L.search_dmg_car    = "Gdy ten terrorysta przechodził przez drogę, został przejechany przez lekkomyślnego kierowce."
L.search_dmg_other  = "Nie możesz znaleźć konkretnej przyczyny śmierci tego terrorysty."

L.search_weapon = "Wygląda na to, że {weapon} posłużyła do tego zabójstwa."
L.search_head   = "Rana śmiertelna była strzałem w głowę. Nie miał czasu, aby krzyczeć."
L.search_time   = "Zmarł w przybliżeniu {time}, zanim go przeszukałeś."
L.search_timefake = "Umarli 00:25 przed ich przeszukaniem."
L.search_dna    = "Pobierz próbkę DNA zabójcy za pomocą skanera DNA. Próbka DNA przeterminuje się za {time}."

L.search_kills1 = "Znalazłeś listę zabójstw, co potwierdza śmierć {player}."
L.search_kills2 = "Znalazłeś listę zabójstw z tymi imionami:"
L.search_eyes   = "Używając umiejętności detektywa, zidentyfikowałeś ostatnią osobę, która go widziała: {player}. Morderca, czy zbieg okoliczności?"


-- Scoreboard
L.sb_playing    = "Grasz na..."
L.sb_mapchange  = "Mapa zmieni się za {num} rund(ę) lub za {time}"

L.sb_sortby = "Sortuj:"

L.sb_mia        = "Zaginiony w akcji"
L.sb_confirmed  = "Potwierdzony zgon"

L.sb_ping       = "Ping"
L.sb_deaths     = "Śmierci"
L.sb_score      = "Wynik"
L.sb_karma      = "Karma"

L.sb_info_help  = "Przejrzyj zwłoki tego gracza, a znajdziesz tutaj wyniki jego przeszukania."

L.sb_tag_friend = "PRZYJACIEL"
L.sb_tag_susp   = "PODEJRZANY"
L.sb_tag_avoid  = "UNIKAĆ"
L.sb_tag_kill   = "ZABIĆ"
L.sb_tag_miss   = "ZAGINIONY"

--- Help and settings menu (F1)

L.help_title = "Pomoc i ustawienia"

-- Tabs
L.help_tut     = "Tutorial"
L.help_tut_tip = "Jak TTT działa, w 6 krokach"

L.help_settings = "Ustawienia"
L.help_settings_tip = "Ustawienia klienta"

-- Settings
L.set_title_gui = "Ustawienia interfejsu"

L.set_tips      = "Pokaż wskazówki dotyczące rozgrywki u dołu ekranu, podczas trybu obserwatora"

L.set_startpopup = "Czas okienka inforamcji na pocztątku rundy"
L.set_startpopup_tip = "Kiedy runda się zaczyna, małe okienko pojawia się na dole twoje ekranu na kilka sekund. Wybierz czas jego wyświetlania tutaj."

L.set_cross_opacity   = "Ukrycie celownika podczas korzystania z celowniku mechanicznego"
L.set_cross_disable   = "Wyłącz celownik całkowicie"
L.set_minimal_id      = "Minimalistyczny status celu pod celownikiem (bez karmy, porad, itp)"
L.set_healthlabel     = "Pokaż stan zdrowia na pasku zdrowia"
L.set_lowsights       = "Obniż broń podczas użycia celowniku mechanicznego"
L.set_lowsights_tip   = "Włącz, aby obniżyć broń na ekranie podczas użycia celowniku mechanicznego. Bedzie łatwiej widać twój cel, ale jest mniej realistyczne."
L.set_fastsw          = "Szybkie przełącznie broni"
L.set_fastsw_tip      = "Włącz przełączanie się między broniami bez klikania ponownie by jej użyć. Włącz pokazywanie się menu, aby pokazać menu przełączania."
L.set_fastsw_menu     = "Włącz menu z szybkim przełączniem broni"
L.set_fastswmenu_tip  = "Kiedy szybkie przełączanie broni jest włączone, menu przełączania będzie wyskakiwać."
L.set_wswitch         = "Wyłacz auto-ukrywanie paska przełączania broni"
L.set_wswitch_tip     = "Domyślnie menu broni automatycznie zamyka się kilka sekund po ostatnim scrollu. Włącz to, by był cały czas widoczny."
L.set_cues            = "Zagraj dźwięk, kiedy runda się rozpoczyna lub kończy"
L.entity_draw_halo = "Dodaj otoczkę na przedmioty patrząc na nie"

L.set_title_play    = "Ustawienia rozgrywki"

L.set_specmode      = "Tryb obserwatora (zawsze bądź obserwatorem)"
L.set_specmode_tip  = "Tryb obserwatora powstrzyma cię przed pojawieniem się na początku rundy przez pozostawienie cię obserwatorem."
L.set_mute          = "Wycisz żyjących graczy, gdy zginiesz"
L.set_mute_tip      = "Włącz wycziszenie żywych graczy, kiedy jesteś martwy/obserwatorem."


L.set_title_lang    = "Ustawienia języka"

-- It may be best to leave this next one english, so english players can always
-- find the language setting even if it's set to a language they don't know.
L.set_lang = "Select language:"


-- Weapons and equipment, HUD and messages

-- Equipment actions, like buying and dropping
L.buy_no_stock = "This weapon is out of stock: you already bought it this round."
L.buy_pending = "You already have an order pending, wait until you receive it."
L.buy_received = "You have received your special equipment."

L.drop_no_room = "You have no room here to drop your weapon!"
L.pickup_fail = "You cannot pick up this"
L.pickup_no_room = "You have no space in your inventory for this weapon kind"
L.pickup_pending = "You already picked up a weapon, wait until you receive it"

L.disg_turned_on = "Disguise enabled!"
L.disg_turned_off = "Disguise disabled."

-- Equipment item descriptions
L.item_passive    = "Pasywne"
L.item_active     = "Aktywne"
L.item_weapon     = "Broń"

L.item_armor      = "Kamizelka kuloodporna"
L.item_armor_desc = [[
Redukuje obrażenia od pocisków 
o 30%, kiedy zostaniesz trafiony

Podstawowe wyposażenie detektywa.]]

L.item_radar      = "Radar"
L.item_radar_desc = [[
Wyszukuje oznak życia, skanując.

Zaczyna automatycznie skanować tylko jak
go kupisz. Skonfiguruj to w zakładce radaru
w tym menu.]]

L.item_disg       = "Przebranie"
L.item_disg_desc  = [[
Ukrywa twój status, gdy jest włączone. Także
unika, bycia ostanią osobą widzaną przez ofiare.

Przełącz w zakładce Przebrania w tym menu
lub kliknij Enter na Numpadzie.]]

-- C4
L.c4_hint         = "Kliknij {usekey}, by uzbroić lub rozbroić."
L.c4_no_disarm    = "Nie możesz rozbroić C4 innego zdrajcy, dopóki on żyje."
L.c4_disarm_warn  = "C4, które uzbroiłeś, zostało rozbrojone."
L.c4_armed        = "Pomyślnie uzbroiłeś bombę."
L.c4_disarmed     = "Pomyślnie rozbroiłeś bombę."
L.c4_no_room      = "Nie możesz wziąć tego C4."

L.c4_desc         = "Potężny, wybuchowy, czasowy."

L.c4_arm          = "Uzbrój C4"
L.c4_arm_timer    = "Timer"
L.c4_arm_seconds  = "Sekund do detonacji:"
L.c4_arm_attempts = "Przy próbie rozbrojenia, {num} z 6 przewodów spowoduje natychmiastowy wybuch podczas cięcia."

L.c4_remove_title    = "Usuwanie"
L.c4_remove_pickup   = "Weź C4"
L.c4_remove_destroy1 = "Zniszcz C4"
L.c4_remove_destroy2 = "Potwierdź: zniszcz"

L.c4_disarm       = "Rozbrój C4"
L.c4_disarm_cut   = "Kliknij, by przeciąć kabel {num}"

L.c4_disarm_t     = "Przetnij kabel, by rozbroić bombe. Kiedy jesteś zdrajcą, każdy kabel jest bezpieczny. Niewinni nie mają tak łatwo!"
L.c4_disarm_owned = "Przetnij kabel, by rozbroić bombe. To twoja bomba, więc każdy kabel ją rozbraja"
L.c4_disarm_other = "Przetnij odpowiedni kabel, by rozbroić bombe. Jak się pomylisz, to ona wybuchnie!"

L.c4_status_armed    = "UZBROJONA"
L.c4_status_disarmed = "ROZBROJONA"

-- Visualizer
L.vis_name        = "Wizualizer"
L.vis_hint        = "Kliknij {usekey} by podnieść (tylko Detektywi)."

L.vis_desc        = [[
Wizualizator chwili zabójstwa.

Analizuje ciało by pokazać jak
jak ofiara zostałą zabita, ale tylko jak
zgineła od strzałów z broni.]]

-- Decoy
L.decoy_name      = "Wabik"
L.decoy_no_room   = "Nie możesz wziąć tego wabika."
L.decoy_broken    = "Twój wabik został zniszczony!"

L.decoy_short_desc = "Pokazuje oszukaną pozycję na radarze"
L.decoy_pickup_wrong_team = "You can't pick it up as it belongs to a different team"

L.decoy_desc      = [[
Pokazuje fałszywy znacznik na radarze Detektywów,
i sprawia, że DNA skaner pokazuje Detektywowi
lokalizacje wabika, jeżeli zeskanuje 
twoje DNA.]]

-- Defuser
L.defuser_name    = "Rozbrajacz"
L.defuser_help    = "{primaryfire} rozbraja zaznaczone C4."

L.defuser_desc    = [[
Natychmiastowo robraja ładunek C4.

Brak limitu użyć. C4 będzie łatwiej 
zauważyć, jeśli go nosisz.]]

-- Flare gun
L.flare_name      = "Pistolet sygnałowy"
L.flare_desc      = [[
Pozwala spalić zwłoki, żeby nikt ich
nigdy nie odnalazł. Ograniczona amunicja.

Palenie zwłok wydaje charakterystyczny
dźwięk.]]

-- Health station
L.hstation_name   = "Stacja Lecząca"
L.hstation_subtitle = "Naciśnij [{usekey}] aby otrzymać życie."
L.hstation_charge = "Pozostały ładunek: {charge}"
L.hstation_empty = "Brak ładunku"
L.hstation_maxhealth = "Życie pełne"
L.hstation_short_desc = "Powoli odnawia swój ładunek"

L.hstation_broken = "Twoja stacja lecząca została zniszczona!"
L.hstation_help   = "{primaryfire} kładzie stacje."

L.hstation_desc   = [[
Pozwala ludzią się leczyć, gdy jest
położone.
Powolne ładowanie. Każdy może użyć i
może być uszkodzone. Może posłużyć
do sprawdzenia DNA  jej użytkowników.]]

-- Knife
L.knife_name      = "Nóż"
L.knife_thrown    = "Nóż do rzucania"

L.knife_desc      = [[
Zabija ranne cele natychmiastowo i
po cichu, ale ma tylko jedno użycie.
Może być rzucone za pomocą strzału
alternatywnego.]]

-- Poltergeist
L.polter_desc     = [[
Miota przedmiotami jak szatan.

Rani ludzi, których trafi.]]

-- Radio
L.radio_broken    = "Twoje radio zostało zniszczone!"
L.radio_help_pri  = "{primaryfire} kładzie radio."

L.radio_desc      = [[
Odtwarza dźwięki lub odgłosy.

Postaw gdzieś radio, i potem
puszczaj dźwięki używając specjalnej zakładki
w tym menu.]]

-- Silenced pistol
L.sipistol_name   = "Pistolet z tłumikiem"

L.sipistol_desc   = [[
Cichy pistolet, używa normalnego ammo
do pistoletu.

Ofiara nie będzie krzyczeć, gdy zginie.]]

-- Newton launcher
L.newton_name     = "Wyrzutnia Newtona"

L.newton_desc     = [[
Zpychaj ludzi z bezpiecznego dystansu.

Nieskończona amunicja, ale wolno strzela.]]

-- Binoculars
L.binoc_name      = "Lornetka"
L.binoc_desc      = [[
Przybliżaj na ciała i identyfikuj je
z dalekiego dystansu.

Nielimitowana liczba użyć, ale 
identyfikacja trwa pare sekund.]]

-- UMP
L.ump_desc        = [[
Eksperymentalne SMG dezorientujące
cel.

Używa standardowego ammo do SMG.]]

-- DNA scanner
L.dna_name        = "DNA skaner"
L.dna_identify    = "Zwłoki muszą być zidentyfikowane, by sprawdzić DNA sprawcy."
L.dna_notfound    = "Nie znaleziono próbki DNA na cel."
L.dna_limit       = "Osiągnięto limit pamięci. Usuń stare próbki, aby dodać nowe."
L.dna_decayed     = "Próbka DNA zabójcy uległa rozkładowi."
L.dna_killer      = "Zebrano próbkę DNA zabójcy z trupa!"
L.dna_no_killer   = "Nie można było pobrać DNA (zabójca się rozłączył?)."
L.dna_armed       = "Ta bomba jest uzbrojona! Rozbrój ją najpierw!"
L.dna_object      = "Zebrano {num} nową próbkę DNA z obiektu."
L.dna_gone        = "DNA nie zostało znalezione na tym terenie."

L.dna_desc        = [[
Zbiera próbki DNA z różnych rzeczy
i używa ich do znalezienia właściela tego DNA.

Użyj na świeżych zwłokach, by znaleźć 
DNA zabójcy i śledzić go.]]

L.dna_menu_title  = "Ustawienia skanowania DNA"
L.dna_menu_sample = "Próbka DNA znaleziona na {source}"
L.dna_menu_remove = "Usuń zaznaczony"
L.dna_menu_help1  = "To są próbki DNA, króre zabrałeś."
L.dna_menu_help2  = [[
Kiedy naładowany, możesz skanować dla lokalizacji
gracza, do którego należy wybrana próbka DNA.
Znalezienie odległych celów powoduje większe złużycie energii.]]

L.dna_menu_scan   = "Skanuj"
L.dna_menu_repeat = "Auto-powtarzanie"
L.dna_menu_ready  = "GOTOWY"
L.dna_menu_charge = "ŁADOWANIE"
L.dna_menu_select = "WYBIERZ PRÓBKĘ"

-- Magneto stick
L.magnet_name     = "Kijek magnetyczny"
L.magnet_help     = "{primaryfire}, aby przymocować ciało do powierzchni."

-- Grenades and misc
L.grenade_smoke   = "Granat dymny"
L.grenade_fire    = "Wybuchowy granat"

L.unarmed_name    = "Bez broni"
L.crowbar_name    = "Łom"
L.pistol_name     = "Pistolet"
L.rifle_name      = "Rifle"
L.shotgun_name    = "Shotgun"

-- Teleporter
L.tele_name       = "Teleporter"
L.tele_failed     = "Teleportacja nieudana."
L.tele_marked     = "Zaznaczona lokalizacja teleportacji."

L.tele_no_ground  = "Nie można teleportować gracza, zanim nie stanie na twardym gruncie!"
L.tele_no_crouch  = "Nie można teleportować, podczas skradania!"
L.tele_no_mark    = "Brak zaznaczonej lokalizacji.Zaznacz miejsce przeznaczenia przed teleportacją."

L.tele_no_mark_ground = "Nie można zaznaczyć lokalizacji, gdy nie jest się na stałym gruncie!"
L.tele_no_mark_crouch = "Nie można zaznaczyć lokalizacji podczas skradania!"

L.tele_help_pri   = "{primaryfire} teleportuje do zaznaczonej lokalizacji."
L.tele_help_sec   = "{secondaryfire} zaznacza aktualną lokalizacje."

L.tele_desc       = [[
Teleportuje do wcześniej zaznaczonego miejsca.

Teleportowanie emituje dźwięk, i
liczba użyć jest ograniczona.]]

-- Ammo names, shown when picked up
L.ammo_pistol = "9mm ammo"

L.ammo_smg1 = "SMG ammo"
L.ammo_buckshot = "Shotgun ammo"
L.ammo_357 = "Rifle ammo"
L.ammo_alyxgun = "Deagle ammo"
L.ammo_ar2altfire = "Flare ammo"
L.ammo_gravity = "Poltergeist ammo"


-- HUD interface text

-- Round status
L.round_wait   = "Oczekiwanie"
L.round_prep   = "Przygotowanie"
L.round_active = "W trakcie"
L.round_post   = "Koniec rundy"

-- Health, ammo and time area
L.overtime     = "DOGRYWKA"
L.hastemode    = "TRYB SZYBKI"

-- TargetID health status
L.hp_healthy   = "Zdrowy"
L.hp_hurt      = "Poturbowany"
L.hp_wounded   = "Ranny"
L.hp_badwnd    = "Bardzo ranny"
L.hp_death     = "Bliski śmierci"


-- TargetID karma status
L.karma_max    = "Renomowany"
L.karma_high   = "Szorski"
L.karma_med    = "Brutalny"
L.karma_low    = "Niebezpieczny"
L.karma_min    = "Szaleniec"
-- TargetID misc
L.corpse       = "Zwłoki"
L.corpse_hint  = "Kliknij {usekey} by zbadać. {walkkey} + {usekey}, aby je zbadać po cichu."
L.corpse_too_far_away = "Ciało jest za daleko."
L.corpse_binoculars = "Press [{key}] to search corpse with binoculars."
L.corpse_searched_by_detective = "Te ciało przeszukał detektyw"

L.target_disg  = "(przebrany)"
L.target_unid  = "Niezidentyfikowane ciało"

L.target_credits = "Przeszukaj, aby otrzymywać niewykorzystane kredyty"

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

-- HUD buttons with hand icons that only some roles can see and use
L.tbut_single = "Jednorazowe"
L.tbut_reuse = "Wielorazowe"
L.tbut_retime = "Użyj ponownie po {num} sek"
L.tbut_help = "Naciśnij [{usekey}] aby użyć"
L.tbut_help_admin = "Edytuj ustawienia guzika treitora"
L.tbut_role_toggle = "[{walkkey} + {usekey}] aby włączyć ten przycisk dla roli {role}"
L.tbut_role_config = "Rola: {current}"
L.tbut_team_toggle = "[SHIFT + {walkkey} + {usekey}] aby włączyć ten guzik dla teamu {team}"
L.tbut_team_config = "Team: {current}"
L.tbut_current_config = "Obecne ustawienia:"
L.tbut_intended_config = "Domyślny config twórcy mapy:"
L.tbut_admin_mode_only = "Only visible to you because you're an admin and '{cv}' is set to '1'"
L.tbut_allow = "Pozwól"
L.tbut_prohib = "Zabroń"
L.tbut_default = "Domyślne"

-- Spectator muting of living/dead
L.mute_living = "Living players muted"
L.mute_specs = "Spectators muted"
L.mute_all = "All muted"
L.mute_off = "None muted"
L.mute_team = "{team} muted."

-- Spectators and prop possession
L.punch_title  = "PUNCH-O-METER"
L.punch_help   = "Klawisze ruchu lub skok: uderz obiekt. Skradanie: opuść obiekt."
L.punch_bonus  = "Twój słaby wynik pomniejszył twój limit punch-o-metera o {num}"
L.punch_malus  = "Twój dobry wynik powiększył twój limit punch-o-metera o {num}!"

L.spec_help    = "Kliknij by obserować gracza, lub kliknij {usekey} na obiekt fizyczny, by go posiąść."
L.spec_help2 = "Aby opuścić tryb widza, naciśnij guzik {helpkey}, idź do 'rozgrywa' i zmień tryb obserwatora."

-- Info popups shown when the round starts

-- These are spread over multiple lines, hence the square brackets instead of
-- quotes. That's a Lua thing. Every line break (enter) will show up in-game.
L.info_popup_innocent = [[Jesteś niewinnym terrorystą! Ale zdrajcy są do okoła...
Komu możesz ufać, a kto cię nafaszruje ołowiem?

Uważaj na siebie i wspópracuj ze swoimi komratami, by wyjść z tego cało!]]

L.info_popup_detective = [[Jesteś Detektywem! Centrala terrorystów dała ci specjalne wyposażenie do znaleznienia zdrajców.
Użyj ich, by pomóc przetrwać niewinnym, ale bądź uważny:
Zdrajcy będą chcieli zabić cię jako pierwszego!

Kliknij {menukey}, aby otrzymać swoje wyposażenie!]]

L.info_popup_traitor_alone = [[Jesteś ZDRAJCĄ! Nie masz żadnych kolegów zdrajców.

Zabij innych i wygraj!

Kliknij {menukey}, aby otrzymać swoje specjalne wyposażenie!]]

L.info_popup_traitor = [[Jesteś ZDRAJCĄ! Wspópracuj ze swoimi kolegami zdrajcami i zabij innych.
Ale musisz uważać, albo twoja zdrada może sostać odkryta...

To są twoi kamraci:
{traitorlist}

Kliknij {menukey}, aby otrzymać swoje specjalne wyposażenie!]]

-- Various other text
L.name_kick = "Gracz został automatycznie wyrzucony, za zmienienie nazwy podczas gry."

L.idle_popup = [[Byłeś bezczynny przez {num} sekund i w rezultacie zostałeś przeniesony do trybu obserwatora . Kiedy jesteś w tym trybie, nie będziesz się pojawiał w nowych rundach.

Możesz to zmienić tryb obserwatora w każdej chwili klikając {helpkey} i odznaczając tą opcje w zakładce ustawień. Możesz również to zrobić teraz.]]

L.idle_popup_close = "Nic nie rób"
L.idle_popup_off   = "Wyłącz tryb obserwatora teraz"

L.idle_warning = "Uwaga: wydajesz się być bezczynny/AFK, zostaniesz przeniesony do trybu obserwatora, jeśli nie przejawisz jakiejś aktywności!"

L.spec_mode_warning = "Jesteś w trybie obserwatora, dlatego nie będziesz się respawnować w następnytch rundach. By wyłączyć ten tryb, kliknij F1, idź do ustawień i odkliknij 'tryb obserwatora'."


--- Tips, shown at bottom of screen to spectators

-- Tips panel
L.tips_panel_title = "Porady"
L.tips_panel_tip   = "Porada:"

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

L.tip29 = "If the server has installed additional languages, you can switch to a different language at any time in the Settings menu."

L.tip30 = "Quickchat albo komendy 'radia' mogą zostać użyte przez kliknięcie {zoomkey}."

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
L.report_save     = "Zapisz Log.txt"
L.report_save_tip = "Zapisuje log wydarzeń do pliku .txt"
L.report_save_error  = "Brak danych logu, aby zapisać."
L.report_save_result = "Log wydarzeń został zapisany:"

-- Big title window
L.hilite_win_traitors = "ZDRAJCY WYGRALI"
L.hilite_win_bees = "PSZCZOŁY WYGRAŁY"
L.hilite_win_innocents = "NIEWINNI WYGRALI"

L.hilite_players1 = "{numplayers} graczy brało udział, {numtraitors} było zdrajcami"
L.hilite_players2 = "{numplayers} graczy brało udział, jeden z nich był zdrajcą"

L.hilite_duration = "Runda trwała {time}"


-- Columns
L.col_time   = "Czas"
L.col_event  = "Wydażenie"
L.col_player = "Gracz"
L.col_roles = "Role"
L.col_teams = "Teamy"
L.col_kills1 = "Zabójstwa niewinnych"
L.col_kills2 = "Zabójstwa zdrajców"
L.col_points = "Punkty"
L.col_team   = "Drużynowy bonus"
L.col_total  = "Punktów ogółem"

-- Name of a trap that killed us that has not been named by the mapper
L.something      = "coś"

-- Kill events
L.aw_sui1_title = "Lider Kultu SamobÓjstwa"
L.aw_sui1_text  = "pokazał innym samobójcom, jak to zrobić zabijąc się jako pierwszy."

L.aw_sui2_title = "Samotny i zdesperowany"
L.aw_sui2_text  = "był jedynym, który zabił samego siebie."

L.aw_exp1_title = "Badania MateriaŁÓw Wybuchowych"
L.aw_exp1_text  = "został wyróżniony za badania nad eksplozjami. Pomogło mu [num} obiektów."

L.aw_exp2_title = "Badania Terenowe"
L.aw_exp2_text  = "sprawdził swoją odporność na wybuchy. Nie była wystarczająco wysoka."

L.aw_fst1_title = "Pierwsza Krew"
L.aw_fst1_text  = "wykonał pierwsze zabójstwo z rąk zdrajców."

L.aw_fst2_title = "Pierwsze Krwawe GŁupie ZabÓjstwo"
L.aw_fst2_text  = "zyskał pierwsze zabójstwo przez strzelanie do kolegów zdrajców. Dobra robota."

L.aw_fst3_title = "Pierwsza Gafa"
L.aw_fst3_text  = "zabił jako pierwszy. Szkoda, że ofiarą był niewinny kolega."

L.aw_fst4_title = "Pierwszy Cios"
L.aw_fst4_text  = "zadał pierwszy cios ze strony niewinnych terrorystów poprzez zabicie pierwszego zdrajcy."

L.aw_all1_title = "NajgroŹniejszy WŚrÓd RÓwnych"
L.aw_all1_text  = "był odpowiedzilany za każde zabójstwo popełnione przez niewinnych w tej rundzie."

L.aw_all2_title = "Samotny Wilk"
L.aw_all2_text  = "był odpowiedzilany za każde zabójstwo popełnione przez zdrajców."

L.aw_nkt1_title = "I Got One, Boss!"
L.aw_nkt1_text  = "zabił jednego niewinnego. Słodko!"

L.aw_nkt2_title = "Pocisk Na Dwa"
L.aw_nkt2_text  = "pokazał, że pierwszy nie był szczęśliwy, zabijając innym."

L.aw_nkt3_title = "Seryjny Zdrajca"
L.aw_nkt3_text  = "zakończył dzisiaj trzy niewinne życia."

L.aw_nkt4_title = "Wilk WŚRÓd Owczych WilkÓw"
L.aw_nkt4_text  = "je niewinnych terrosrystów na śniadanie. Kolacja składająca się z {num} dań."

L.aw_nkt5_title = "Antyterrorsta"
L.aw_nkt5_text  = "otrzymywał wynagrodzenie za każdą śmierć. Może sobie kupić kolejny jacht."

L.aw_nki1_title = "ZdradŹ To"
L.aw_nki1_text  = "znalazł zdrajcę. Zabił zdrajcę. Łatwe."

L.aw_nki2_title = "Liga Sprawiedliwych"
L.aw_nki2_text  = "eskortował dwóch zdrajców do nieba."

L.aw_nki3_title = "Czy Zdrajcy ŚniĄ O Zdradzieckich Owcach?"
L.aw_nki3_text  = "dał trzem zdrajcom odpocząć. Na zawsze."

L.aw_nki4_title = "Hitman do wynajĘcia"
L.aw_nki4_text  = "otrzymywał wynagrodzenie za każdego zabitego. Teraz zamawia swój piąty basen."

L.aw_fal1_title = "Nie, Panie Bond, OczekujĘ, Że Spadniesz"
L.aw_fal1_text  = "zrzucił kogoś z dużej wysokości."

L.aw_fal2_title = "ZapodŁogowany"
L.aw_fal2_text  = "pozwolił ciału uderzyć w podłogę z impetem po pięknym locie."

L.aw_fal3_title = "Ludzki Meteoryt"
L.aw_fal3_text  = "zmiażdżył kogoś spadająć na niego z dużej wysokości."

L.aw_hed1_title = "EfektywnoŚĆ"
L.aw_hed1_text  = "odkrył radość ze strzelania w głowy i trafił ich {num}."

L.aw_hed2_title = "Neurologia"
L.aw_hed2_text  = "usunął mózgi z {num} głów dla bliższych oględzin."

L.aw_hed3_title = "Gry Mnie Do Tego ZmusiŁy"
L.aw_hed3_text  = "wykorzystał swoje szkolenie na symulatorach morderstwa i strzelił headshottów {num} wrogom."

L.aw_cbr1_title = "BrzdĘk BrzdĘk BrzdĘk"
L.aw_cbr1_text  = "potrafi nieźle przywalić łomem, dowiedziało się o tym {num} ofiar."

L.aw_cbr2_title = "Freeman"
L.aw_cbr2_text  = "pogrzebał w mózgach nie mniej niż {num} ludziom."

L.aw_pst1_title = "TrwaŁy MaŁy Pistolecik"
L.aw_pst1_text  = "uzyskał {num} zabójstw używając pistoletu. Następnie poszedł kogoś zatulić na śmierć."

L.aw_pst2_title = "UbÓj MaŁego Kalibru"
L.aw_pst2_text  = "zabił małą armię {num} osób z pistoletu. Prawdopodobnie zamocował małą strzelbę w lufie."

L.aw_sgn1_title = "Easy Mode"
L.aw_sgn1_text  = "posyła śrut tam gdzie boli, mordując {num} celi."

L.aw_sgn2_title = "TysiĄc MaŁych PociskÓw"
L.aw_sgn2_text  = "nie lubi swojego śrutu, więc dał go innym. {num} odbiorców nie żyje, by się tym cieszyć."

L.aw_rfl1_title = "Wyceluj i Kliknij"
L.aw_rfl1_text  = "pokazuje, że wszystko czego potrzebuje do {num} zabójst jest snajperka i pewna ręka."

L.aw_rfl2_title = "WidzĘ StĄd TwojĄ GłowĘ"
L.aw_rfl2_text  = "zna swoją broń. Teraz {num} ludzi też ją zna."

L.aw_dgl1_title = "To Jak MaŁa Snajperka!"
L.aw_dgl1_text  = "dostał w swoje ręce Desert Eagle i zabił {num} ludzi."

L.aw_dgl2_title = "Mistrz Desert Eagle"
L.aw_dgl2_text  = "zniszczył {num} ludzi z deaglem."

L.aw_mac1_title = "MÓdl Się I Zabijaj"
L.aw_mac1_text  = "zabił {num} ludzi z MAC10, ale nie pytaj ile amunicji zużył."

L.aw_mac2_title = "MAC Z Serem"
L.aw_mac2_text  = "wyobraź sobie co by się stało gdyby używał dwóch MAC10. {num} razy dwa?"

L.aw_sip1_title = "BĄdŹ Cicho"
L.aw_sip1_text  = "zabił {num} ludzi pistoletem z tłumikiem."

L.aw_sip2_title = "SkrytobÓjca"
L.aw_sip2_text  = "zabił {num} ludzi, którzy nawet nie słyszeli swojej śmierci."

L.aw_knf1_title = "NÓŻ Cię Nie Ominie"
L.aw_knf1_text  = "zabił kogoś z nożem przez internet."

L.aw_knf2_title = "SkĄd To WziĄŁeś?"
L.aw_knf2_text  = "nie był zdrajcą, ale i tak zabił kogoś nożem."

L.aw_knf3_title = "Po Prostu CzŁowiek Z NoŻami"
L.aw_knf3_text  = "znalazł {num} noży leżących do okoła i zrobił z nich użytek."

L.aw_knf4_title = "CzŁowiek Przecinak"
L.aw_knf4_text  = "zabił {num} ludzi nożem. Nie pytaj jak."

L.aw_flg1_title = "Na Ratunek"
L.aw_flg1_text  = "użył flar do sygnalizacji {num} śmierci."

L.aw_flg2_title = "Flara = PoŻar"
L.aw_flg2_text  = "nauczył {num} ludzi o niebezpieczeństwie noszenia łątwopalnych ubrań."

L.aw_hug1_title = "RATTATTATTATTA"
L.aw_hug1_text  = "użył swojego H.U.G.E, by zabić {num} ludzi."

L.aw_hug2_title = "Cierpliwy Strzelec"
L.aw_hug2_text  = "po prostu strzelał i zobaczył, że przyniosło mu to rezultat {num} zabójstw."

L.aw_msx1_title = "Pyk Pyk Pyk"
L.aw_msx1_text  = "wystrzelał {num} ludzi z M16."

L.aw_msx2_title = "Średnio ZasiĘgowe SzaleŃstwo"
L.aw_msx2_text  = "wie jak ściągać ludzi z M16, osiągając {num} zabóstw."

L.aw_tkl1_title = "Ups"
L.aw_tkl1_text  = "osunął mu się palec, gdy celował w kolegę."

L.aw_tkl2_title = "PodwÓjne Ups"
L.aw_tkl2_text  = "myślał, że był zdrajcą dwa razy, ale pomylił się dwa razy."

L.aw_tkl3_title = "Co To Karma?"
L.aw_tkl3_text  = "nie mógł poprzestać na dwóch ofiarach. Trzy to szczęśliwa liczba."

L.aw_tkl4_title = "Teamkiller"
L.aw_tkl4_text  = "wymordował całą swoją drużynę. OMGBANBANBAN."

L.aw_tkl5_title = "Roleplayer"
L.aw_tkl5_text  = "grał rolę szaleńca. Dlatego zabił większość swojej drużyny."

L.aw_tkl6_title = "Debil"
L.aw_tkl6_text  = "nie potrafił zrozumieć, z którą stroną był, i zabił ponad połowę swoich towarzyszy."

L.aw_tkl7_title = "WieŚniak"
L.aw_tkl7_text  = "skutecznie bronił sowjej ziemii zabijąc ćwierć drużyny."

L.aw_brn1_title = "Takie Jak Babcia RobiŁa"
L.aw_brn1_text  = "przypiekł na chrupiąco pare ludzi."

L.aw_brn2_title = "Piromanta"
L.aw_brn2_text  = "śmiał się głośno po spaleniu jednej ze swoich ofiar."

L.aw_brn3_title = "Pyrrysowy Palacz"
L.aw_brn3_text  = "spalił je wszyskie, ale teraz brak mu granatów! Jak on sobie poradzi!?"

L.aw_fnd1_title = "Koroner"
L.aw_fnd1_text  = "znalazł {num} ciał leżących wokół."

L.aw_fnd2_title = "ZŁap Je Wszystkie"
L.aw_fnd2_text  = "znalazł {num} ciał do jego kolekcji."

L.aw_fnd3_title = "Zapach Śmierci"
L.aw_fnd3_text  = "co chwilę znajduje przypadkowe zwłoki. Znalazł ich {num} w tej rundzie."

L.aw_crd1_title = "Mistrz Recyklingu"
L.aw_crd1_text  = "znalazł {num} kredytów przy trupach."

L.aw_tod1_title = "Pyrrusowe ZwyciĘstwo"
L.aw_tod1_text  = "zginął chwile przed wygraną jego drużyny."

L.aw_tod2_title = "NienawidzĘ Tej Gry"
L.aw_tod2_text  = "umarł zaraz po rozpoczęciu rundy."


-- New and modified pieces of text are placed below this point, marked with the
-- version in which they were added, to make updating translations easier.


--- v23
L.set_avoid_det     = "Unikaj bycia detektywem"
L.set_avoid_det_tip = "Włącz, by serwer wiedział, że nie chcesz być nigdy detektywem. To nie oznacza, że będziesz częściej zdrajcą."

--- v24
L.drop_no_ammo = "Niewystarczająca ilość amunicji w magazynku twojej broni do upuszczenia pudełka amunicji."

--- v31
L.set_cross_brightness = "Jasność celownika"
L.set_cross_size = "Wielkość celownika"

--- 5-25-15
L.hat_retrieve = "Podniosłeś czapkę detektywa."

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

L.dna_hud_type = "TYP"
L.dna_hud_body = "CIAŁO"
L.dna_hud_item = "ITEM"

L.binoc_zoom_level = "Powiększenie"
L.binoc_body = "WYKRYTO CIAŁO"
L.binoc_progress = "Wyszukiwanie: {progress}%"

L.idle_popup_title = "Idle"

-- 6-22-17 (Crosshair)
L.set_title_cross = "Ustawienia celownika"

L.set_cross_color_enable = "Umożliw kolor celownika"
L.set_cross_color = "Kolor celownika:"
L.set_cross_gap_enable = "Umożliw odstęp"
L.set_cross_gap = "Odstęp celownika"
L.set_cross_static_enable = "Umożliw statyczny celownik "
L.set_ironsight_cross_opacity = "Widoczność celownika z przycelowania"
L.set_cross_weaponscale_enable = "Umożliw różne wielkości"
L.set_cross_thickness = "Grubość celownika"
L.set_cross_outlinethickness = "Grubość otoczki celownika"
L.set_cross_dot_enable = "Umożliw kropkę celownika"

-- ttt2
L.create_own_shop = "Stwórz własny sklep"
L.shop_link = "Połącz z..."
L.shop_disabled = "Wyłącz sklep"
L.shop_default = "Użyj domyślnego sklepu"

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

L.f1_settings_changes_title = "Zmiany"
L.f1_settings_hudswitcher_title = "PrzeŁĄcznik HUDu"
L.f1_settings_bindings_title = "Bindy Klawiszy"
L.f1_settings_interface_title = "Interfejs"
L.f1_settings_gameplay_title = "Rozgrywka"
L.f1_settings_crosshair_title = "Celownik"
L.f1_settings_dmgindicator_title = "OBRAŻENIA"
L.f1_settings_language_title = "JĘzyk"
L.f1_settings_administration_title = "Administracja"
L.f1_settings_shop_title = "Sklep"

L.f1_settings_shop_desc_shopopen = "Otworzyć sklep zamiast ekranu końca rundy guzikiem podczas końca/początku rundy?"
L.f1_settings_shop_title_layout = "Układ listy"
L.f1_settings_shop_desc_num_columns = "Liczba kolumn"
L.f1_settings_shop_desc_num_rows = "Liczba rzędów"
L.f1_settings_shop_desc_item_size = "Wielkość ikon"
L.f1_settings_shop_title_marker = "Ustawienia tworzenie przedmiotów"
L.f1_settings_shop_desc_show_slot = "Pokaż sloty"
L.f1_settings_shop_desc_show_custom = "Pokaż customowe intemy"
L.f1_settings_shop_desc_show_favourite = "Pokaż ulubione itemy"

L.f1_shop_restricted = "Zmiany w sklepie są zablokowane przez admina."

L.f1_settings_hudswitcher_desc_basecolor = "Kolor bazowy"
L.f1_settings_hudswitcher_desc_hud_scale = "skala HUDu (resetuje ustawienia)"
L.f1_settings_hudswitcher_button_close = "Zamknij"
L.f1_settings_hudswitcher_desc_reset = "Resetuj dane HUDu"
L.f1_settings_hudswitcher_button_reset = "Resetuj"
L.f1_settings_hudswitcher_desc_layout_editor = "Zmień położenie i\nrozmiar elementów"
L.f1_settings_hudswitcher_button_layout_editor = "Edytor położenia"
L.f1_settings_hudswitcher_desc_hud_not_supported = "! TEN HUD NIE WSPIERA EDYCJI!"

L.f1_bind_reset_default = "Podstawowy"
L.f1_bind_disable_bind = "Wyczyść"
L.f1_bind_description = "Kliknij i naciśnij guzik, aby go zbindować."
L.f1_bind_reset_default_description = "Resetuj do podstawowego guzika."
L.f1_bind_disable_description = "Wyczyść bind."
L.ttt2_bindings_new = "Nowy klawisz dla {name}: {key}"

L.f1_bind_weaponswitch = "Zmień broń"
L.f1_bind_sprint = "Sprint"
L.f1_bind_voice = "Globalny Czat"
L.f1_bind_voice_team = "Teamowy Czat"

L.f1_dmgindicator_title = "Ustawienia powiadomień obrażeń"
L.f1_dmgindicator_enable = "Zezwól"
L.f1_dmgindicator_mode = "Wybierz motyw"
L.f1_dmgindicator_duration = "Liczba sekund widoczności"
L.f1_dmgindicator_maxdamage = "Obrażenia do maksymalnej widoczności"
L.f1_dmgindicator_maxalpha = "Obrażenia do minimalnej widoczności"

L.ttt2_bindings_new = "Nowy klawisz dla {name}: {key}"
L.hud_default = "Zwykły HUD"
L.hud_force = "Wymuszony HUD"
L.hud_restricted = "Zakazany HUD"
L.hud_default_failed = "Failed to set the HUD {hudname} as new default. You don't have permission to do that, or this HUD doesn't exist."
L.hud_forced_failed = "Failed to force the HUD {hudname}. You don't have permission to do that, or this HUD doesn't exist."
L.hud_restricted_failed = "Failed to restrict the HUD {hudname}. You don't have permission to do that."

L.shop_role_select = "Wybierz rolę"
L.shop_role_selected = "{roles} wybrano do sklepu!"
L.shop_search = "Szukaj"

L.button_save = "Zapisz"

L.disable_spectatorsoutline = "Wyłącz otoczki przedmiotów"
L.disable_spectatorsoutline_tip = "Więcej fps"

L.disable_overheadicons = "Wyłącz Ilony nad głową"
L.disable_overheadicons_tip = "Więcej fps"

-- 2020-01-04
L.doubletap_sprint_anykey = "Continue double tap sprinting until you stop moving"
L.doubletap_sprint_anykey_tip = "You will keep sprinting as long as you keep moving"

L.disable_doubletap_sprint = "Wyłącz sprint poprzez wielokrotne wciskanie"
L.disable_doubletap_sprint_tip = "Double tapping a movement key will no longer cause you to sprint"

-- 2020-02-03
L.hold_aim = "Trzymaj aby celować"
L.hold_aim_tip = "Będzie działać tak długo jak będziesz trzymać klawisz"

-- 2020-02-09
L.name_door = "Drzwi"
L.door_open = "Naciśnij [{usekey}] aby otworzyć drzwi."
L.door_close = "Naciśnij [{usekey}] aby zamknąć drzwi"
L.door_locked = "Drzwi są zamknięte"

-- 2020-02-11
L.automoved_to_spec = "(SERWER) Zostałeś przeniesiony do teamu obserwujących za brak aktywności!"

-- 2020-02-16
L.door_auto_closes = "Te drzwi zamykają się same"
L.door_open_touch = "Wejdź w drzwi żeby je otworzyć."
L.door_open_touch_and_use = "Wejdź w drzwi i naciśnij [{usekey}] aby otworzyć."
L.hud_health = "Zdrowie"

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
--L.item_no_hazard_damage_desc = [[Makes you immune to hazard damage such as posion, radiation and acid.]]
--L.item_no_energy_damage = "No Energy Damage"
--L.item_no_energy_damage_desc = [[Makes you immune to energy damage such as lasers, plasma and lightning.]]
--L.item_no_prop_damage = "No Prop Damage"
--L.item_no_prop_damage_desc = [[Makes you immune to prop damage.]]
--L.item_no_drown_damage = "No Drowning Damage"
--L.item_no_drown_damage_desc = [[Makes you immune to drowning damage.]]

-- 2020-04-30
--L.message_revival_canceled = "Revival canceled."
--L.message_revival_failed = "Revival failed."
--L.message_revival_failed_missing_body = "You have not been revived because your corpse no longer exists."
--L.hud_revival_title = "Time left until revival:"
--L.hud_revival_time = "{time}s"

-- 2020-05-03
--L.door_destructible = "Door is destructible ({health}HP)"

-- 2020-05-28
--L.confirm_detective_only = "Only detectives can confirm bodies"
--L.inspect_detective_only = "Only detectives can inspect bodies"
--L.corpse_hint_no_inspect = "Only detectives can search this body."
--L.corpse_hint_inspect_only = "Press [{usekey}] to serch. Only detectives can confirm the body."
--L.corpse_hint_inspect_only_credits = "Press [{usekey}] to receive credits. Only detectives can search this body."

-- 2020-06-04
--L.label_bind_disguiser = "Toggle disguiser"

-- 2020-06-24

--L.dna_help_primary = "Collect a DNA sample"
--L.dna_help_secondary = "Switch the DNA slot"
--L.dna_help_reload = "Delete a sample"

--L.binoc_help_pri = "Identify a body."
--L.binoc_help_sec = "Change zoom level."

--L.vis_help_pri = "Drop the activated device."

--L.decoy_help_pri = "Plant the Decoy."
