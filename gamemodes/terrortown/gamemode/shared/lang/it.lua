-- Italian language strings (by AL24 & THEPLATYNUMGHOST)

local L = LANG.CreateLanguage("it")

-- Compatibility language name that might be removed soon.
-- the alias name is based on the original TTT language name:
-- https://github.com/Facepunch/garrysmod/blob/master/garrysmod/gamemodes/terrortown/gamemode/lang/italian.lua
L.__alias = "italiano"

L.lang_name = "Italiano (Italian)"

-- General text used in various places
L.traitor = "Traditore"
L.detective = "Detective"
L.innocent = "Innocente"
L.last_words = "Ultime parole"

L.terrorists = "Terroristi"
L.spectators = "Spettatori"

--L.nones = "No Team"
L.innocents = "Team Innocenti"
L.traitors = "Team Traditori"

-- Round status messages
L.round_minplayers = "Non ci sono abbastanza giocatore per cominciare un nuovo round..."
L.round_voting = "Voto in corso, prolungando il round di {num} secondi..."
L.round_begintime = "Un nuovo round inizia tra {num} secondo/i. Preparatevi."
L.round_selected = "I traditori sono stati scelti."
L.round_started = "Il round è iniziato!"
L.round_restart = "È stato forzato il riavvio del round da un admin."

L.round_traitors_one = "Traditore, sei rimasto da solo."
L.round_traitors_more = "Traditore, questi sono i tuoi alleati: {names}"

L.win_time = "Il tempo è finito. I Traditori hanno perso."
L.win_traitors = "I Traditori hanno vinto!"
L.win_innocents = "Gli Innocenti hanno vinto!"
L.win_nones = "Pareggio!"
L.win_showreport = "Guardiamo il report per {num} secondi."

L.limit_round = "Raggiunto il limite del tempo del round. la prossima mappa caricherà presto."
L.limit_time = "Il tempo è finito. la prossima mappa caricherà presto."
L.limit_left = "{num} round o {time} minuti rimanenti prima che la mappa cambi."

-- Credit awards
L.credit_all = "Al tuo team sono stati dati {num} crediti per la vostra performance."
L.credit_kill = "Hai ricevuto {num} credito/i per aver ucciso un {role}."

-- Karma
L.karma_dmg_full = "Il tuo Karma è {amount}, quindi questo round fai il massimo del danno!"
L.karma_dmg_other = "Il tuo Karma è {amount}. Come risultato il danno è diminuito del {num}%"

-- Body identification messages
L.body_found = "{finder} ha trovato il corpo di {victim}. {role}"
L.body_found_team = "{finder} ha trovato il corpo di {victim}. {role} ({team})"

-- The {role} in body_found will be replaced by one of the following:
L.body_found_traitor = "Era un Traditore!"
L.body_found_det = "Era un Detective."
L.body_found_inno = "Era un Innocente."

L.body_confirm = "{finder} ha confermato la morte di {victim}."

L.body_call = "{player} ha chiamato un detective al corpo di {victim}!"
L.body_call_error = "Devi confermare la morte di questo giocatore prima di chiamare un Detective!"

L.body_burning = "Ahia! Questo corpo va a fuoco!"
L.body_credits = "Hai trovato {num} credito/i sul corpo!"

-- Menus and windows
L.close = "Chiudi"
L.cancel = "Cancella"

-- For navigation buttons
L.next = "Prossimo"
L.prev = "Precedente"

-- Equipment buying menu
L.equip_title = "Equipaggiamento"
L.equip_tabtitle = "Ordina Equipaggiamento"

L.equip_status = "Stato ordinamento"
L.equip_cost = "Hai {num} credito/i."
L.equip_help_cost = "Ogni oggetto dell'equipaggiamento che acquisti costa 1 credito."

L.equip_help_carry = "Puoi solo acquistare oggetti per i quali hai spazio."
L.equip_carry = "Puoi portare questo oggetto."
L.equip_carry_own = "Stai già portando questo oggetto."
L.equip_carry_slot = "Hai già un'arma nello slot {slot}."
L.equip_carry_minplayers = "Non ci sono abbastanza giocatori sul server per usare quest'arma."

L.equip_help_stock = "Di alcuni oggetti ne puoi acquistare solo uno per round."
L.equip_stock_deny = "Questo oggetto non si può più acquistare."
L.equip_stock_ok = "Questo oggetto si può più acquistare."

L.equip_custom = "Oggetti personalizzati aggiunti dal server."

L.equip_spec_name = "Nome"
L.equip_spec_type = "Tipo"
L.equip_spec_desc = "Descrizione"

L.equip_confirm = "Compra oggetto"

-- Disguiser tab in equipment menu
L.disg_name = "Travestimento"
L.disg_menutitle = "Controllo travestimento"
L.disg_not_owned = "Non hai un travestimento!"
L.disg_enable = "Attiva travestimento"

L.disg_help1 = "Quando il tuo travestimento è attivo, il tuo nome, la tua vita e il tuo karma non si vedono quando qualcuno ti guarda. In più, sarai nascosto al radar del Detective."
L.disg_help2 = "Premi Numpad Enter per togliere il travestimento senza aprire il menù. Puoi anche metter un tasto diverso in 'ttt_toggle_disguise' usando la console."

-- Radar tab in equipment menu
L.radar_name = "Radar"
L.radar_menutitle = "Controllo del Radar"
L.radar_not_owned = "Non hai un Radar!"
L.radar_scan = "Fai una scansione"
L.radar_auto = "Scansione automatica"
L.radar_help = "I risultati della scansione si vedono per {num} secondi, dopo di quello il radar dovrà essere ricaricato e potrà essere usato nuovamente."
L.radar_charging = "Il tuo Radar si sta ancora caricando!"

-- Transfer tab in equipment menu
L.xfer_name = "Trasferimento"
L.xfer_menutitle = "Trasferisci crediti"
L.xfer_send = "Dai un credito"

L.xfer_no_recip = "Bersaglio non valido, trasferimento dei crediti annullato."
L.xfer_no_credits = "Crediti insufficienti per il trasferimento."
L.xfer_success = "Trasferimento crediti a {player} completato."
L.xfer_received = "{player} ti ha dato {num} crediti."

-- Radio tab in equipment menu
L.radio_name = "Radio"
L.radio_help = "Clicca un bottone per far fare alla Radio quel suono."
L.radio_notplaced = "Devi piazzare la Radio prima di far partire un suono."

-- Radio soundboard buttons
L.radio_button_scream = "Urlo"
L.radio_button_expl = "Esplosione"
L.radio_button_pistol = "Colpi di pistola"
L.radio_button_m16 = "Colpi di M16"
L.radio_button_deagle = "Colpi di Deagle"
L.radio_button_mac10 = "Colpi di MAC10"
L.radio_button_shotgun = "Colpi di Fucile a Pompa"
L.radio_button_rifle = "Colpi di Cecchino"
L.radio_button_huge = "Colpi di H.U.G.E"
L.radio_button_c4 = "Rumore del C4"
L.radio_button_burn = "Fuoco"
L.radio_button_steps = "Passi"

-- Intro screen shown after joining
L.intro_help = "Se sei nuovo al gioco, premi F1 per istruzioni!"

-- Radiocommands/quickchat
L.quick_title = "Tasti veloci della chat"

L.quick_yes = "Sì."
L.quick_no = "No."
L.quick_help = "Aiuto!"
L.quick_imwith = "Sono con {player}."
L.quick_see = "Vedo {player}."
L.quick_suspect = "{player} è sospetto."
L.quick_traitor = "{player} è un Traditore!"
L.quick_inno = "{player} è innocente."
L.quick_check = "Qualcuno è ancora vivo?"

-- {player} in the quickchat text normally becomes a player nickname, but can
-- also be one of the below.  Keep these lowercase.
L.quick_nobody = "nessuno"
L.quick_disg = "qualcuno con travestimento"
L.quick_corpse = "un corpo non identificato"
L.quick_corpse_id = " il corpo di {player}"

-- Body search window
L.search_title = "Risultati ricerca"
L.search_info = "Informazione"
L.search_confirm = "Conferma morte"
L.search_call = "Chiama Detective"

-- Descriptions of pieces of information found
L.search_nick = "Questo è il corpo di {player}."

L.search_role_traitor = "Questa persona era un Traditore!"
L.search_role_det = "Questa persona era un Detective."
L.search_role_inno = "Questa persona era un Innocente."

L.search_words = "Qualcosa ti dice che le ultime parole di questa persona erano: '{lastwords}'"
L.search_armor = "Stava indossando un'armatura speciale."
L.search_disg = "Stava usando un dispositivo che poteva nascondere la sua identità."
L.search_radar = "Avevano qualche tipo di radar. Non funziona più."
L.search_c4 = "In una tasca hai trovato una nota. Dice che tagliare il filo {num} disarmerà la bomba."

L.search_dmg_crush = "Molte delle sua ossa sono rotte. Sembra che l'impatto di un oggetto pesante lo abbia ucciso."
L.search_dmg_bullet = "È ovvio che sia stato ucciso da dei colpi di arma da fuoco."
L.search_dmg_fall = "Sono morti di caduta."
L.search_dmg_boom = "Le sue ferite e i vestiti bruciati indicano che un'esplosione lo hanno ucciso."
L.search_dmg_club = "Il suo corpo è pieno di ferite. Chiaramente è stato ucciso a bastonate."
L.search_dmg_drown = "Il corpo morta i segni dell'affogamento."
L.search_dmg_stab = "È stato accoltellato prima di morire velocemente dissanguato."
L.search_dmg_burn = "Si sente odore di terrorista bruciato qui..."
L.search_dmg_tele = "Sembra che il DNA stato criptato da delle emissioni tachioniche!"
L.search_dmg_car = "Quando il terrorista ha attraversato la strada, sono stati investiti da un pilota spericolato."
L.search_dmg_other = "Non puoi trovare una causa di morte specifica per la morte di questo terrorista."

L.search_weapon = "Sembra che sia stato usato un {weapon} per ucciderlo."
L.search_head = "La ferita fatale è stata un colpo in testa. Non c'era il tempo di urlare."
L.search_time = "È morto all'incirca {time} prima che facessi la ricerca."
L.search_dna = "Prendi un campione di DNA con il DNA Scanner. Il campione di DNA scadrà {time} da ora."

L.search_kills1 = "Hai trovato una lista di uccisioni che conferma la morte di {player}."
L.search_kills2 = "Hai trovato una lista di uccisioni con questi nomi:"
L.search_eyes = "Usando le tue abilità da detective, hai identificato che l'ultima persona che ha visto è: {player}. L'assassino, o una coincidenza?"

-- Scoreboard
L.sb_playing = "Stai giocando su..."
L.sb_mapchange = "La mappa cambierà tra {num} round o tra {time}"

L.sb_mia = "Disperso"
L.sb_confirmed = "Morti confermati"

L.sb_ping = "Ping"
L.sb_deaths = "Morti"
L.sb_score = "Punti"
L.sb_karma = "Karma"

L.sb_info_help = "Identifica il corpo di questo giocatore, e potrai vedere qui i risultati."

L.sb_tag_friend = "AMICO"
L.sb_tag_susp = "SOSPETTO"
L.sb_tag_avoid = "EVITA"
L.sb_tag_kill = "UCCIDI"
L.sb_tag_miss = "DISPERSO"

-- Equipment actions, like buying and dropping
L.buy_no_stock = "Quest'arma non puoi più acquistarla: lo hai già fatto questo round."
L.buy_pending = "Hai già un ordine in attesa, aspetta di riceverlo."
L.buy_received = "Hai ricevuto il tuo equipaggiamento speciale."

L.drop_no_room = "Non c'è spazio qui per lasciare la tua arma!"

L.disg_turned_on = "Travestimento attivato!"
L.disg_turned_off = "Travestimento disattivato."

-- Equipment item descriptions
L.item_passive = "Oggetti con effetto passivo"
L.item_active = "Oggetti con effetto passivo"
L.item_weapon = "Armi"

L.item_armor = "Armatura"
L.item_armor_desc = [[
Riduce il danno dei proiettili, fuoco e il danno esplosivo. Si consuma nel tempo.

Può essere comprata multiple volte. Dopo aver superato uno specifico valore, l'armatura diventa più forte.]]

L.item_radar = "Radar"
L.item_radar_desc = [[
Ti permette di fare una scansione dei segni vitali.

Comincia una ricerca automatica appena lo compri. Configuralo nella finestra Radar di questo menù.]]

L.item_disg = "Travestimento"
L.item_disg_desc = [[
Nasconde le tue informazioni quando attivo. Evita anche di essere l'ultima persona vista da una vittima.

Disabilitalo nella finestra Travestimento di questo menù o premi Numpad Enter.]]

-- C4
L.c4_hint = "Premi {usekey} per innescare o disinnescare."
L.c4_disarm_warn = "Un C4 che hai piazzato è stato disinnescato."
L.c4_armed = "Hai innescato la bomba con successo."
L.c4_disarmed = "Hai disinnescato la bomba con successo."
L.c4_no_room = "Non puoi portare questo C4."

L.c4_desc = "Potente esplosivo a tempo."

L.c4_arm = "Arma C4"
L.c4_arm_timer = "Timer"
L.c4_arm_seconds = "Secondi alla detonazione:"
L.c4_arm_attempts = "Nei tentativi di disinnesco, {num} dei 6 fili causerà l'esplosione istantanea del C4."

L.c4_remove_title = "Rimuovi"
L.c4_remove_pickup = "Prendi C4"
L.c4_remove_destroy1 = "Distruggi C4"
L.c4_remove_destroy2 = "Conferma: distruggi"

L.c4_disarm = "Disinnesca C4"
L.c4_disarm_cut = "Clicca per tagliare il filo {num}"

L.c4_disarm_owned = "Taglia un filo per disinnescare la bomba. È la tua bomba, quindi ogni filo la disinnescherà."
L.c4_disarm_other = "Taglia un filo sicuro per disinnescare la bomba. Esploderà se tagli quello sbagliato!"

L.c4_status_armed = "INNESCATA"
L.c4_status_disarmed = "DISINNESCATA"

-- Visualizer
L.vis_name = "Visualizzatore"
L.vis_hint = "Premi {usekey} per raccoglierlo (solo Detective)."

L.vis_desc = [[
Dispositivo per visualizzare una scena del crimine.

Analizza un cadavere per mostrare come la vittima è stata uccisa, ma solo se è morta per colpi di arma da fuoco.]]

-- Decoy
L.decoy_name = "Esca"
L.decoy_no_room = "Non puoi portare questa Esca."
L.decoy_broken = "la tua Esca è stata distrutta!"

L.decoy_short_desc = "Questa esca mostra un finto segnale radar per gli altri team"
L.decoy_pickup_wrong_team = "Non puoi prenderlo perchè appartiene a un team differente"

L.decoy_desc = [[
Mostra un segnale falso sul radar dei Detective, e mostra sui loro DNA scanner la posizione dell'Esca se scannerizzano il tuo DNA.]]

-- Defuser
L.defuser_name = "Disinnescatore"
L.defuser_help = "{primaryfire} disinnesca C4 selezionato."

L.defuser_desc = [[
Disinnesca istantaneamente un C4.

Usi illimitati. Il C4 sarà più facile notarlo se porti quest'oggetto con te.]]

-- Flare gun
L.flare_name = "Pistola lanciarazzi"

L.flare_desc = [[
Può essere usata per bruciare corpi così che non vengano mai trovati. Munizioni limitate.

Bruciare un cadavere fa un suono distinto.]]

-- Health station
L.hstation_name = "Stazione di Cura"

L.hstation_broken = "La tua Stazione di Cura è stata distrutta!"
L.hstation_help = "{primaryfire} piazza la Stazione di Cura."

L.hstation_desc = [[
Permette ai giocatori di curarsi una volta piazzata.

Ricarica lenta. Chiunque può usarla, e può essere danneggiata. Può essere analizzata per prendere i campioni di DNA di chi l'ha usata.]]

-- Knife
L.knife_name = "Coltello"
L.knife_thrown = "Coltello lanciato"

L.knife_desc = [[
Uccidi bersagli feriti istantaneamente e silenziosamente, ma ha un solo utilizzo.

Può essere tirato con il tasto del fuoco alternativo.]]

-- Poltergeist
L.polter_desc = [[
Pianta dei razzi su degli oggetti per lanciarli per lanciarli violentemente.

Le scariche di energia danneggiano i giocatori nelle vicinanze.]]

-- Radio
L.radio_broken = "La tua Radio è stata distrutta!"
L.radio_help_pri = "{primaryfire} piazza una Radio."

L.radio_desc = [[
Fa dei suoni per distrarre o ingannare.

Piazza la radio da qualche parte, poi fai partire dei suoni dalla finestra Radio in questo menù.]]

-- Silenced pistol
L.sipistol_name = "Pistola silenziata"

L.sipistol_desc = [[
Pistola silenziata, usa i proiettili della pistola.

Le vittime non urleranno quando uccise.]]

-- Newton launcher
L.newton_name = "Newton launcher"

L.newton_desc = [[
Spinge i giocatori fad una distanza di sicurezza.

Munizioni infinite, ma spara lentamente.]]

-- Binoculars
L.binoc_name = "Binocolo"

L.binoc_desc = [[
Zooma sui cadaveri e li identifica da molto distante.

Usi illimitati, ma l'identificazione necessita di alcuni secondi.]]

-- UMP
L.ump_desc = [[
SMG sperimentale che disorienta i bersagli.

Usa munizioni SMG standard.]]

-- DNA scanner
L.dna_name = "DNA scanner"
L.dna_identify = "Il cadavere deve essere identificato per prendere il DNA dell'assassino."
L.dna_notfound = "Nessun campione di DNA trovato sul bersaglio."
L.dna_limit = "Limite di deposito raggiunge. Rimuovi vecchi campioni per aggiungerne altri."
L.dna_decayed = "Campione di DNA dell'assassino si è deteriorato."
L.dna_killer = "Preso un campione di DNA dell'assassino dal cadavere!"
L.dna_no_killer = "Il DNA non può essere preso (assassino disconnesso?)."
L.dna_armed = "La bomba è innescata! Disinnescala prima!"
L.dna_object = "Preso {num} nuovo campione di DNA dall'oggetto."
L.dna_gone = "DNA non rilevato nella zona."

L.dna_desc = [[
Prendi campioni di DNA dagli oggetti e usali per trovare il proprietario del DNA.

Usalo su giocatori appena uccisi per prendere il DNA dell'assassino e trovarli.]]

-- Magneto stick
L.magnet_name = "Magneto-stick"
L.magnet_help = "{primaryfire} per attaccare i corpi alle superfici."

-- Grenades and misc
L.grenade_smoke = "Granata fumogena"
L.grenade_fire = "Granata incendiaria"

L.unarmed_name = "Disarmato"
L.crowbar_name = "Crowbar"
L.pistol_name = "Pistola"
L.rifle_name = "Fucile da cecchino"
L.shotgun_name = "Fucile a pompa"

-- Teleporter
L.tele_name = "Teletrasporto"
L.tele_failed = "Teletrasporto fallito."
L.tele_marked = "Posizione teletrasporto segnalata."

L.tele_no_ground = "Non puoi teletrasportarti se non sei a terra!"
L.tele_no_crouch = "Non puoi teletrasportarti mentre sei abbassato!"
L.tele_no_mark = "Nessuna posizione segnalata. Segnala una destinazione prima di teletrasportarti."

L.tele_no_mark_ground = "Non puoi segnalare una posizione per il teletrasporto se non sei a terra!"
L.tele_no_mark_crouch = "Non puoi segnalare una posizione per il teletrasporto mentre sei abbassato!"

L.tele_help_pri = "{primaryfire} teletrasporta alla posizione segnalata."
L.tele_help_sec = "{secondaryfire} segnala questa posizione."

L.tele_desc = [[
Teletrasportati ad una posizione precedentemente segnalata.

Teletrasportarti fa rumore, e il numero di utilizzi è limitato.]]

-- Ammo names, shown when picked up
L.ammo_pistol = "Munizioni 9mm"

L.ammo_smg1 = "Munizioni SMG"
L.ammo_buckshot = "Munizioni Fucile a Pompa"
L.ammo_357 = "Munizioni Fucile da Cecchino"
L.ammo_alyxgun = "Munizioni Deagle"
L.ammo_ar2altfire = "Munizioni Pistola Lanciarazzi"
L.ammo_gravity = "Munizioni Poltergeist"

-- Round status
L.round_wait = "In attesa"
L.round_prep = "Preparazione"
L.round_active = "In corso"
L.round_post = "Round finito"

-- Health, ammo and time area
L.overtime = "SUPPLEMENTARI"
L.hastemode = "SUPPLEMENTARI"

-- TargetID health status
L.hp_healthy = "In salute"
L.hp_hurt = "Colpito"
L.hp_wounded = "Ferito"
L.hp_badwnd = "Ferito gravemente"
L.hp_death = "Quasi morto"

-- TargetID karma status
L.karma_max = "Affidabile"
L.karma_high = "Poco affidabile"
L.karma_med = "Grilletto facile"
L.karma_low = "Pericoloso"
L.karma_min = "Irresponsabile"

-- TargetID misc
L.corpse = "Cadavere"
L.corpse_hint = "Premi {usekey} per identificare. {walkkey} + {usekey} per identificare segretamente."

L.target_disg = "travestito"
L.target_unid = "Corpo non identificato"

L.target_credits = "Identifica per ricevere i crediti non spesi"

-- Traitor buttons (HUD buttons with hand icons that only traditori can see)
L.tbut_single = "Uso singolo"
L.tbut_reuse = "Riutilizzabile"
L.tbut_retime = "Riutilizzabile dopo {num} secondi"
L.tbut_help = "Premi {key} per attivare"

-- Spectator muting of living/dead
L.mute_living = "Giocatori in vita mutati"
L.mute_specs = "Spettatori mutati"
L.mute_all = "Tutti mutati"
L.mute_off = "Nessuno mutato"

-- Spectators and prop possession
L.punch_title = "PUNCH-O-METER"
L.punch_help = "Tasti per il movimento o salto: lancia oggetto. Abbassati: lascia oggetto."
L.punch_bonus = "Il tuo punteggio basso ha diminuito il livello del punch-o-meter di {num}"
L.punch_malus = "Il tuo punteggio alto ha aumentato il livello del punch-o-meter di {num}!"

-- Info popups shown when the round starts
L.info_popup_innocent = [[
Sei un innocente! Ma ci sono dei traditori...
Ma di chi ti puoi fidare, e chi invece è li per ucciderti?

Guardati le spalle e collabora con i tuoi compagni per uscirne vivo!]]

L.info_popup_detective = [[
Sei un Detective! La sede dei terroristi ti ha dato delle risorse speciali per trovare i traditori.
Usale per aiutare gli innocenti a sopravvivere, ma fai attenzione:
i traditori cercheranno di ucciderti per primo!

Premi {menukey} per ricevere il tuo equipaggiamento!]]

L.info_popup_traitor_alone = [[
Sei un TRADITORE! Non hai compagni traditori questo round.

Uccidi tutti gli per vincere!

Premi {menukey} per ricevere il tuo equipaggiamento!]]

L.info_popup_traitor = [[
Sei un TRADITORE! Collabora con i compagni traditori per uccidere gli altri.
Ma fai attenzione, o il tuo tradimento potrebbe essere scoperto...

Questi sono i tuoi compagni:
{traitorlist}

Premi {menukey} per ricevere il tuo equipaggiamento!]]

-- Various other text
L.name_kick = "Un giocatore è stato espulso per aver cambiato il suo nome durante round."

L.idle_popup = [[
Sei stato inattivo per {num} secondi e sei stato spostato nella modalità solo Spettatori. Mentre sei in questa modalità, non spawnerai all'inizio del round.

Puoi rimuovere la modalità solo Spettatori in ogni momento premendo {helpkey} e deselezionando la casella nella finestra Impostazioni. Puoi anche scegliere di disabilitarla ora.]]

L.idle_popup_close = "Non fare niente"
L.idle_popup_off = "Disabilita modalità solo spettatori ora"

L.idle_warning = "Attenzione: sembri essere inattivo/AFK, e verrai spostato negli Spettatori almeno che tu non ti muova!"

L.spec_mode_warning = "Sei in modalità Spettatore e non spawnerai all'inizio del round. Per disabilitare questa modalità, premi F1, vai nelle Impostazioni e togli la spunta a 'modalità solo Spettatori'."

-- Tips panel
L.tips_panel_title = "Consigli"
L.tips_panel_tip = "Consiglio:"

-- Tip texts
L.tip1 = "Traditori possono identificare un corpo silenziosamente, senza confermare la morte, tenendo premuto {walkkey} e premendo {usekey} sul cadavere."

L.tip2 = "Innescare un C4 con più tempo aumenterà il numero di cavi che la fanno esplodere istantaneamente quando un innocente prova a disinnescarla. Fara suoni meno forti e più di rado."

L.tip3 = "I Detective possono identificare un cadavere per trovare chi è 'riflesso nei suoi occhi'. Questa è l'ultima persona che il cadavere vedesse prima di morire. Non è per obbligatoriamente l'assassino se è stato ucciso alle spalle."

L.tip4 = "Nessuno saprà che sei morto finché non trovano il tuo cadavere e lo identificano."

L.tip5 = "Quando un Traditore uccide un Detective, ricevono istantaneamente una ricompensa in crediti."

L.tip6 = "Quando un Traditore muore, tutti i Detective ricevono una ricompensa in crediti."

L.tip7 = "Quando i Traditori hanno fatto un progresso importante nell'uccidere gli innocenti, ricevono un credito come ricompensa."

L.tip8 = "Traditori e Detective possono collezionare crediti non spesi dai cadaveri di altri Traditori e Detective."

L.tip9 = "Il Poltergeist può trasformare qualsiasi oggetto in un proiettile mortale. Ogni colpo è accompagnato da una scarica di energia ferendo tutti quanti nei dintorni."

L.tip10 = "Come Traditore o Detective, tieni d'occhio i messaggi rossi in alto a destra. Saranno importanti per te."

L.tip11 = "Come Traditore o Detective, tieni a mente che riceverai altri crediti se i tuoi compagni giocheranno bene. Ricordati di spenderli!"

L.tip12 = "Il DNA Scanner dei Detective DNA Scanner può essere usato per prendere campioni di DNA da armi e oggetti e scansionarli per trovare chi li ha usati. Utile prendere un campione da un cadavere o da un C4 disinnescato!"

L.tip13 = "Quando sei vicino ad uccidere qualcuno, un po' del tuo DNA rimane sul cadavere. Questo DNA può essere usato dal DNA Scanner del Detective per trovarti. Meglio nascondere i cadaveri dopo averli accoltellati!"

L.tip14 = "Più sarai lontano dalla persona che uccidi, più velocemente il DNA sul corpo si deteriorerà."

L.tip15 = "Sei un Traditore e vuoi sparare con il cecchino? Prova ad usare il Trasferimento. Se non colpisci, scappa in un posto sicuro, disabilita il Travestimento, e nessuno saprà che gli stavi sparando."

L.tip16 = "Come Traditore, il Teletrasporto può aiutarti a scappare quando inseguito, e ti permette di viaggiare velocemente in una mappa grande. Assicurati che tu abbia sempre una posizione sicura segnalata."

L.tip17 = "Gli innocenti sono tutti raggruppati e difficili da trovare soli? Prova ad usare la Radio e fare i suoni di un C4 o di una sparatoria per farli scappare."

L.tip18 = "Usando la Radio da Traditore, puoi far partire i suoni tramite il menù dopo aver piazzato la radio. Metti in coda diversi suoni cliccandoli più volte nell'ordine in cui li vuoi."

L.tip19 = "Come Detective, se ti rimangono dei crediti potresti dare ad un Innocente fidato un Disinnescatore. Poi puoi spendere tempo facendo investigazioni serie e lasciare il pericoloso disinnescaggio a loro."

L.tip20 = "Il binocolo dei Detective permette di identificare cadaveri a distanza. Brutte notizie se i Traditori speravano di usare questo cadavere come esca. Ovviamente, mentre usa il Binocolo un Detective è disarmato e distratto..."

L.tip21 = "La Stazione di Cura dei Detective fa curare i giocatori feriti. Ovviamente, potrebbero essere Traditori..."

L.tip22 = "La Stazione di Cura registra il campione di DNA di chiunque la usa. I Detective possano usare il DNA Scanner per scoprire chi si è curato."

L.tip23 = "Al contrario delle armi e del C4, la Radio dei Traditori non contiene campioni di DNA di chi l'ha piazzata. Non preoccupatevi che i Detective al trovino e facciano saltare la vostra copertura."

L.tip24 = "Premi {helpkey} per vedere un piccolo tutorial o modifica alcune impostazioni di TTT. Per esempio, puoi disabilitare questi consigli."

L.tip25 = "Quando un Detective identifica un corpo, il risultato è disponibile per tutti sullo scoreboard, cliccando il nome della persona morta."

L.tip26 = "Nello scoreboard, una magnifica icona di vetro vicino al nome di qualcuno indica che hai delle informazioni su quella persona. Se l'icona è chiara, le informazioni vengono da un Detective e potrebbero essere più complete."

L.tip27 = "Come Detective, i cadaveri con una magnifica icona di vetro vicino al nome di qualcuno indica che sono stati identificati da un Detective e i risultati sono disponibili a tutti tramite lo scoreboard."

L.tip28 = "Gli Spettatori possono premere {mutekey} per mutare altri spettatori o i giocatori in vita."

L.tip29 = "Se il server ha installate altre lingue, puoi cambiare lingua in ogni momento dal menù delle Impostazioni."

L.tip30 = "Chat veloce o i comandi 'radio' possono essere usati con il tasto {zoomkey}."

L.tip31 = "Come Spettatore, premi {duckkey} per sbloccare il cursore del mouse e clicca i bottoni su questa finestra dei consigli. Premi {duckkey} ancora per muovere la visuale."

L.tip32 = "Il fuoco secondario della Crowbar spingerà gli altri giocatori."

L.tip33 = "Sparare dal mirino di ferro di un'arma migliora leggermente la tua precisione e diminuisci il rinculo. Abbassarti non lo fa."

L.tip34 = "Le granate fumogene sono efficienti in luoghi chiusi, specialmente per creare confusione in stanze con molte persone."

L.tip35 = "Come Traditore, ricorda che puoi prendere i cadaveri e nasconderli dagli occhi degli Innocenti e dei Detective."

L.tip36 = "Il tutorial disponibile premendo {helpkey} contiene una descrizione sui tasti più importanti di questa modalità."

L.tip37 = "Nello scoreboard, clicca il nome di un giocatore in vita e potrai selezionare un tag per loro, come 'sospetto' o 'amico'. Questo tag si vedrà quando li miri."

L.tip38 = "Molti degli oggetti che si possono piazzare (come C4, Radio) posso essere attacati ai muri usando il fuoco secondario."

L.tip39 = "Il C4 che esplode per errore durante le operazione di disinnescamento ha un'esplosione più piccola di quando esplode perché è scaduto il tempo."

L.tip40 = "Se dice 'SUPPLEMENTARI' sopra il tempo del round, il round all'inizio durerà solo qualche minuto, ma con ogni uccisione il tempo a disposizione aumenterà (come catturare un punto su TF2). Questa modalità mette pressione ai traditori, così che facciano in fretta."

-- Round report
L.report_title = "Report del Round"

-- Tabs
L.report_tab_hilite = "Momenti chiave"
L.report_tab_hilite_tip = "Momenti chiave del round"
L.report_tab_events = "Eventi"
L.report_tab_events_tip = "Log degli eventi accaduti in questo round"
L.report_tab_scores = "Punteggi"
L.report_tab_scores_tip = "Punteggi fatti da ogni giocatore in questo round"

-- Event log saving
L.report_save = "Salva il Log .txt"
L.report_save_tip = "Salva il Log degli eventi in un file di testo"
L.report_save_error = "Nessun Log degli eventi da salvare."
L.report_save_result = "Il Log degli eventi è stato salvato in:"

-- Big title window
L.hilite_win_traitors = "I TRADITORI HANNO VINTO"
L.hilite_win_none = "PAREGGIO"
L.hilite_win_innocents = "GLI INNOCENTI HANNO VINTO"

L.hilite_players1 = "{numplayers} hanno partecipato, {numtraitors} erano traditori"
L.hilite_players2 = "{numplayers} hanno partecipato, uno di loro era un traditore"

L.hilite_duration = "Il round è durato {time}"

-- Columns
L.col_time = "Tempo"
L.col_event = "Evento"
L.col_player = "Giocatore"
L.col_roles = "Ruolo"
L.col_teams = "Team"
L.col_kills1 = "Uccisioni"
L.col_kills2 = "Uccisioni squadra"
L.col_points = "Punti"
L.col_team = "Bonus team"
L.col_total = "Punti totali"

-- Awards/highlights
L.aw_sui1_title = "Capo del Culto dei Suicidi"
L.aw_sui1_text = "ha mostrato a tutti gli altri suicidi come farlo facendolo per primo."

L.aw_sui2_title = "Solo e Depresso"
L.aw_sui2_text = "l'unico che si è ucciso da solo."

L.aw_exp1_title = "Ricerca Esplosivi"
L.aw_exp1_text = "è stato premiato per la sua ricerca sugli esplosivi. {num} persone lo hanno aiutato nei test."

L.aw_exp2_title = "Ricerca sul Campo"
L.aw_exp2_text = "ha provato la sua resistenza agli esplosivi. Non era abbastanza alta."

L.aw_fst1_title = "Primo Sangue"
L.aw_fst1_text = "è stato il primo traditore ad uccidere un innocente."

L.aw_fst2_title = "Prima Stupida Uccisione"
L.aw_fst2_text = "ha fatto la prima uccisione uccidendo un compagno traditore. Complimenti."

L.aw_fst3_title = "Primo Errore"
L.aw_fst3_text = "è stato il primo ad uccidere. Peccato che fosse un compagno innocente."

L.aw_fst4_title = "Primo Colpo"
L.aw_fst4_text = "ha ucciso fatto la prima uccisione colpendo un traditore."

L.aw_all1_title = "Più Letale tra Compagni"
L.aw_all1_text = "è stato responsabile di ogni uccisione fatta dagli innocenti."

L.aw_all2_title = "Lupo Solitario"
L.aw_all2_text = "è stato responsabile per ogni uccisione fatta dai traditori."

L.aw_nkt1_title = "Ne Ho Preso Uno, Boss!"
L.aw_nkt1_text = "ha ucciso un singolo innocente. Bene!"

L.aw_nkt2_title = "Un Proiettile per Due"
L.aw_nkt2_text = "ha mostrato al primo che non era un colpo fortunato uccidendone un altro."

L.aw_nkt3_title = "Traditore Seriale"
L.aw_nkt3_text = "ha tolto la vita a tre innocenti oggi."

L.aw_nkt4_title = "Lupo tra Più Pecore Simili a Lupi"
L.aw_nkt4_text = "mangia innocenti per cena. Una cena di {num} portate."

L.aw_nkt5_title = "Operazione Anti-Terrorismo"
L.aw_nkt5_text = "viene pagato per uccisione. Ora ha uno yacht di lusso."

L.aw_nki1_title = "Tradisci Questo"
L.aw_nki1_text = "trovato un traditore. Ucciso un traditore. Facile."

L.aw_nki2_title = "Fatto Domanda alla Justice Squad"
L.aw_nki2_text = "ha portato due traditori nell'altro mondo."

L.aw_nki3_title = "I Traditori Sognano una Pecorella Traditrice?"
L.aw_nki3_text = "ha messo a riposo tre traditori."

L.aw_nki4_title = "Dipendente degli Affari Interni"
L.aw_nki4_text = "viene pagato per uccisione. Ora può ordinare la sua quinta piscina."

L.aw_fal1_title = "No Mr. Bond, mi Aspetto che Lei Cada"
L.aw_fal1_text = "ha spinto qualcuno da un posto molto alto."

L.aw_fal2_title = "Atterrato"
L.aw_fal2_text = "ha fatto cadere il suo corpo a terra dopo essere caduto da un'altezza importante."

L.aw_fal3_title = "Meteorite Umano"
L.aw_fal3_text = "ha schiacciato qualcuno cadendogli in testa da una grande altezza."

L.aw_hed1_title = "Efficienza"
L.aw_hed1_text = "ha scoperto la bellezza dei colpi alla testa facendone {num}."

L.aw_hed2_title = "Neurologia"
L.aw_hed2_text = "ha rimosso il cervello da {num} teste per esaminarli."

L.aw_hed3_title = "I Videogiochi me l'Hanno Fatto Fare"
L.aw_hed3_text = "ha applicato le sue conoscenze nelle simulazione sparando in testa a {num} persone."

L.aw_cbr1_title = "Thunk Thunk Thunk"
L.aw_cbr1_text = "da belle mazzate con la crowbar, come constatato da {num} vittime."

L.aw_cbr2_title = "Freeman"
L.aw_cbr2_text = "ha coperto la sua crowbar con il cervello di {num} persone."

L.aw_pst1_title = "Persistente Piccolo Bastardo"
L.aw_pst1_text = "ha ucciso {num} persone con la pistola. Poi sono andati ad abbracciare qualcuno fino alla morte."

L.aw_pst2_title = "Strage di Piccolo Calibro"
L.aw_pst2_text = "ha ucciso un piccolo gruppo di {num} persone con la pistola. Probabilmente con un piccolo fucile a pompa nella canna."

L.aw_sgn1_title = "Modalità Facile"
L.aw_sgn1_text = "ha infilato il pallettone dove fa male, uccidendo {num} persone."

L.aw_sgn2_title = "Migliaia di Piccoli Pellet"
L.aw_sgn2_text = "non gli piaceva tanto il suo pallettone, quindi li ha regalati tutti. {num} persone che lo hanno ricevuto non sono sopravvissute abbastanza a lungo per apprezzarlo."

L.aw_rfl1_title = "Punta e Clicca"
L.aw_rfl1_text = "ha mostrato che quello che serve per uccidere {num} persone è un fucile da cecchino e una mano ferma."

L.aw_rfl2_title = "Posso Vedere la tua Testa da Qui"
L.aw_rfl2_text = "conosce il suo fucile. Ora anche altre {num} persone lo conoscono."

L.aw_dgl1_title = "È Come un Piccolo Fucile"
L.aw_dgl1_text = "si sta abituando con la Desert Eagle e ha ucciso {num} persone."

L.aw_dgl2_title = "Eagle Master"
L.aw_dgl2_text = "ha distrutto {num} persone con la deagle."

L.aw_mac1_title = "Prega e Uccidi"
L.aw_mac1_text = "ha ucciso {num} persone con il MAC10, ma non parliamo di quante munizioni ha usato."

L.aw_mac2_title = "Mac-cheroni al Formaggio"
L.aw_mac2_text = "cosa potrebbe succedere se potesse sparare con due MAC10. {num} uccisioni per 2?"

L.aw_sip1_title = "Fai Silenzio"
L.aw_sip1_text = "ha fatto stare in silenzio {num} persone con la sua pistola silenziata."

L.aw_sip2_title = "Assassino Silenzioso"
L.aw_sip2_text = "ha ucciso {num} persone e nessuno ha sentito niente."

L.aw_knf1_title = "Coltello che ti Conosce"
L.aw_knf1_text = "ha accoltellato qualcuno sul volto su internet."

L.aw_knf2_title = "Da Dove l'Hai Preso?"
L.aw_knf2_text = "non era un Traditore, ma ha comunque ucciso qualcuno con un coltello."

L.aw_knf3_title = "Un Apprezzatore di Coltelli"
L.aw_knf3_text = "ha trovato {num} coltelli in giro, e li ha utilizzati per uccidere."

L.aw_knf4_title = "Il Più Abile Accoltellatore del Mondo"
L.aw_knf4_text = "ha ucciso {num} persone con un coltello. Non chiedete come."

L.aw_flg1_title = "Al Salvataggio"
L.aw_flg1_text = "ha usato i suoi razzi per segnalare le sue {num} uccisioni."

L.aw_flg2_title = "Razzo Segnalatore"
L.aw_flg2_text = "ha insegnato a {num} persone il pericolo di indossare vestiti infiammabili."

L.aw_hug1_title = "Una strage di H.U.G.E."
L.aw_hug1_text = "era in sintonia con il suo H.U.G.E, riuscendo in qualche modo a colpire {num} persone."

L.aw_hug2_title = "Tranquillità"
L.aw_hug2_text = "ha continuato a sparare, e ha visto la sua grande pazienza essere ricompensata con {num} uccisioni."

L.aw_msx1_title = "Putt Putt Putt"
L.aw_msx1_text = "ha fatto fuori {num} persone con il suo M16."

L.aw_msx2_title = "Follia a Media Distanza"
L.aw_msx2_text = "sa come colpire i suoi bersagli con il suo M16, uccidendo {num} persone."

L.aw_tkl1_title = "Fatto un Errorino"
L.aw_tkl1_text = "gli è partito un colpo mentre mirava ad un compagno."

L.aw_tkl2_title = "Doppio Errorino"
L.aw_tkl2_text = "pensava di aver ucciso un Traditore due volte, invece si è sbagliato entrambe le volte."

L.aw_tkl3_title = "Consapevole del Karma"
L.aw_tkl3_text = "non poteva fermarsi dopo aver ucciso due compagni. Tre è un numero fortunato."

L.aw_tkl4_title = "Uccisore di compagni"
L.aw_tkl4_text = "ha ucciso tutta la sua squadra. OHMIODIOBANBANBAN."

L.aw_tkl5_title = "Giocatore di ruolo"
L.aw_tkl5_text = "stava facendo finta di essere un pazzo. Per questo ha ucciso la maggior parte della sua squadra."

L.aw_tkl6_title = "Idiota"
L.aw_tkl6_text = "non riusciva a capire a che squadra appartenesse, e ha ucciso più della metà dei suoi compagni."

L.aw_tkl7_title = "Contadino"
L.aw_tkl7_text = "ha protetto il suo campo perfettamente uccidendo più di un quarto dei suoi compagni."

L.aw_brn1_title = "Come le Faceva la Nonna"
L.aw_brn1_text = "ha fritto diverse persone come patatine fritte."

L.aw_brn2_title = "Piromane"
L.aw_brn2_text = "lo abbiamo sentito ridere dopo aver bruciato una delle sue tante vittime."

L.aw_brn3_title = "Bruciatore Pirrico"
L.aw_brn3_text = "li ha bruciati tutti, ma ora ha finito le sue granate incendiarie! Come farà!?"

L.aw_fnd1_title = "Coroner"
L.aw_fnd1_text = "ha trovato {num} cadaveri in giro."

L.aw_fnd2_title = "Gotta Catch 'Em All"
L.aw_fnd2_text = "ha trovato {num} cadaveri per la sua collezione."

L.aw_fnd3_title = "Odore di morte"
L.aw_fnd3_text = "continua a incontrare cadaveri a terra, {num} volte questo round."

L.aw_crd1_title = "Riciclatore"
L.aw_crd1_text = "ha raccolto {num} crediti da cadaveri."

L.aw_tod1_title = "Vittoria Pirrica"
L.aw_tod1_text = "morto solo pochi secondi prima che la sua squadra vincesse."

L.aw_tod2_title = "Odio Questo Gioco"
L.aw_tod2_text = "morto proprio all'inizio del round."

-- New and modified pieces of text are placed below this point, marked with the
-- version in which they were added, to make updating translations easier.

-- v24
L.drop_no_ammo = "Munizioni insufficienti nel tuo caricatore per lasciare un pacchetto di munizioni."

-- 2015-05-25
L.hat_retrieve = "Hai raccolto il cappello di un Detective."

-- 2017-09-03
L.sb_sortby = "Ordina per:"

-- 2018-07-24
L.equip_tooltip_main = "Menù equipaggiamento"
L.equip_tooltip_radar = "Controllo Radar"
L.equip_tooltip_disguise = "Controllo Travestimento"
L.equip_tooltip_radio = "Controllo Radio"
L.equip_tooltip_xfer = "Trasferisci crediti"
L.equip_tooltip_reroll = "Rimescola oggetti"

L.confgrenade_name = "Discombobulator"
L.polter_name = "Poltergeist"
L.stungun_name = "Prototipo UMP"

L.knife_instant = "UCCISIONE ISTANTANEA"

L.binoc_zoom_level = "LIVELLO"
L.binoc_body = "CORPO TROVATO"

L.idle_popup_title = "Inattivo"

-- 2019-01-31
L.create_own_shop = "Crea shop proprio"
L.shop_link = "Collega con"
L.shop_disabled = "Disabilita shop"
L.shop_default = "Usa shop di default"

-- 2019-05-05
L.reroll_name = "Rimescola"
L.reroll_menutitle = "Rimescola oggetti"
L.reroll_no_credits = "Non hai crediti per rimescolare!"
L.reroll_button = "Rimescola"
L.reroll_help = "Usa {amount} crediti per prendere nuovi oggetti nello shop!"

-- 2019-05-05
L.equip_not_alive = "Puoi vedere tutti gli oggetti disponibili selezionando un ruolo sulla destra. Non ti dimenticare di segnare i toui preferiti!"

-- 2019-06-27
L.shop_editor_title = "Editor Shop"
L.shop_edit_items_weapong = "Modifica Oggetti / Armi"
L.shop_edit = "Modifica Shop"
L.shop_settings = "Impostazioni"
L.shop_select_role = "Scegli Ruolo"
L.shop_edit_items = "Modifica Oggetti"
L.shop_edit_shop = "Modifica Shop"
L.shop_create_shop = "Crea Shop personalizzato"
L.shop_selected = "Selezionato: {role}"
L.shop_settings_desc = "Cambia i valori per adattare le ConVars del Random Shop ConVars. Non dimenticarti di salvare dopo!"

L.bindings_new = "Nuovo tasto assegnato per {name}: {key}"

L.hud_default_failed = "Fallito nell'impostare l'HUD {hudname} come nuovo default. Sei un admin ed esiste questo HUD?"
L.hud_forced_failed = "Fallito nell'impostare l'HUD {hudname}. Sei un admin ed esiste questo HUD?"
L.hud_restricted_failed = "Fallito nell'impostare l'HUD {hudname}. Sei un admin?"

L.shop_role_select = "Seleziona un ruolo"
L.shop_role_selected = "Lo shop del {roles} è stato selezionato!"
L.shop_search = "Cerca"

L.spec_help = "Clicca per guardare i giocatori, o premi {usekey} su un oggetto per possederlo."
L.spec_help2 = "Per lasciare la modalità spettatore devi aprire il menù premendo {helpkey}, vai a 'gameplay' e rimuovi la modalità spettatore."

-- 2019-10-19
L.drop_ammo_prevented = "Qualcosa ti impedisce di lasciare queste munizioni."

-- 2019-10-28
L.target_c4 = "Premi [{usekey}] per aprire il menù del C4"
L.target_c4_armed = "Premi [{usekey}] per disinnescare il C4"
L.target_c4_armed_defuser = "Premi [{usekey}] per usare il disinnescatore"
L.target_c4_not_disarmable = "Non puoi disinnescare il C4 di un compagno in vita"
L.c4_short_desc = "Qualcosa molto esplosivo"

L.target_pickup = "Premi [{usekey}] per raccogliere"
L.target_slot_info = "Slot: {slot}"
L.target_pickup_weapon = "Premi [{usekey}] per prendere l'arma"
L.target_switch_weapon = "Premi [{usekey}] per scambiare con la tua arma corrente"
L.target_pickup_weapon_hidden = ", premi [{usekey} + {walkkey}] per prenderla silenziosamente"
L.target_switch_weapon_hidden = ", premi [{usekey} + {walkkey}] per scambiarla silenziosamente"
L.target_switch_weapon_nospace = "Non hai uno slot nell'inventario adatto a quest'arma"
L.target_switch_drop_weapon_info = "Lasciando l'arma {name} nello slot {slot}"
L.target_switch_drop_weapon_info_noslot = "Non c'è un'arma che puoi lasciare nello slot {slot}"

L.corpse_searched_by_detective = "Questo cadavere è stato identificato da un detective"
L.corpse_too_far_away = "Il cadavere è troppo lontano."

L.radio_pickup_wrong_team = "Non puoi prendere la radio di un'altra squadra."
L.radio_short_desc = "I suoni delle armi sono come musica per me"

L.hstation_subtitle = "Premi [{usekey}] per ricevere vita."
L.hstation_charge = "Carica rimasta nella Stazione di Cura: {charge}"
L.hstation_empty = "Non c'è più carica nella Stazione di Cura"
L.hstation_maxhealth = "I tuoi HP sono al massimo"
L.hstation_short_desc = "La Stazione di Cura si ricarica lentamente con il tempo"

-- 2019-11-03
L.vis_short_desc = "Visualizza un scena del crimine se la vittima è morta per un colpo di arma da fuoco"
L.corpse_binoculars = "Premi [{key}] per identificare i cadaveri con il binocolo."
L.binoc_progress = "Progresso ricerca: {progress}%"

L.pickup_no_room = "Non hai spazio nell'inventario per questo tipo di arma"
L.pickup_fail = "Non puoi prendere quest'arma"
L.pickup_pending = "Hai gia preso un arma, aspetta finche non la ricevi"

-- 2020-01-07
L.tbut_help_admin = "Modifica le impostazioni per i bottoni dei traditori"
L.tbut_role_toggle = "[{walkkey} + {usekey}] to toggle this button for {role}"
L.tbut_role_config = "Ruolo: {current}"
L.tbut_team_toggle = "[SHIFT + {walkkey} + {usekey}] per rimuovere questo bottone per il team {team}"
L.tbut_team_config = "Team: {current}"
L.tbut_current_config = "Configurazione corrente:"
L.tbut_intended_config = "Configurazione voluta dal creatore della mappa:"
L.tbut_admin_mode_only = "Visibile solo perché sei admin e '{cv}' è impostato a '1'"
L.tbut_allow = "Permetti"
L.tbut_prohib = "Proibisci"
L.tbut_default = "Default"

-- 2020-02-09
L.name_door = "Porta"
L.door_open = "Premi [{usekey}] per aprire la porta."
L.door_close = "Premi [{usekey}] per chiudere la porta."
L.door_locked = "La porta è chiusa!"

-- 2020-02-11
L.automoved_to_spec = "(MESSAGGIO AUTOMATICO) Sono stato spostato negli Spettatori perché ero inattivo/AFK."
L.mute_team = "{team} mutato."

-- 2020-02-16
L.door_auto_closes = "Questa porta si chiude automaticamente"
L.door_open_touch = "Cammina addosso ad una porta per aprirla."
L.door_open_touch_and_use = "Cammina addosso ad una porta o premi [{usekey}] per aprire."
L.hud_health = "Vita"

-- 2020-03-09
L.help_title = "Aiuto e Impostazioni"

L.menu_changelog_title = "Cambiamenti"
L.menu_guide_title = "Guida TTT2"
L.menu_bindings_title = "Assegnazione Tasti"
L.menu_language_title = "Lingua"
L.menu_appearance_title = "Aspetto"
L.menu_gameplay_title = "Gameplay"
L.menu_addons_title = "Addon"
L.menu_legacy_title = "Addon legacy"
L.menu_administration_title = "Amministrazione"
L.menu_equipment_title = "Modifica Equipaggiamento"
L.menu_shops_title = "Modifica Shop"

L.menu_changelog_description = "Una lista di cambiamenti e correzioni nelle ultime versioni"
L.menu_guide_description = "Ti aiuta a cominciare con TTT2 e ti spiega delle cose su gameplay, ruoli and altre cose"
L.menu_bindings_description = "Assegna specifiche funzioni di TTT2 e le sue addon a tuo piacimento"
L.menu_language_description = "Seleziona la lingua del gioco"
L.menu_appearance_description = "Modifica l'aspetto e la performane dell'interfaccia"
L.menu_gameplay_description = "Evita dei ruoli e modifica alcune funzioni"
L.menu_addons_description = "Configura le addon locali a tuo piacimento"
L.menu_legacy_description = "Un pannello con le finestre convertite dal TTT originale, dovrebbero essere portate al nuovo sistema"
L.menu_administration_description = "Impostazioni generli per gli HUD, shop ecc."
L.menu_equipment_description = "Imposta crediti, limitazioni, disponibilità e altre cose"
L.menu_shops_description = "Aggiungi/Rimuovi gli shop ai ruoli e definisci l'equipaggiamento all'interno"

L.submenu_guide_gameplay_title = "Gameplay"
L.submenu_guide_roles_title = "Ruoli"
L.submenu_guide_equipment_title = "Equipaggiamento"

L.submenu_bindings_bindings_title = "Assegnazione tasti"

L.submenu_language_language_title = "Lingua"

L.submenu_appearance_general_title = "Generale"
L.submenu_appearance_hudswitcher_title = "Selettore HUD"
L.submenu_appearance_vskin_title = "VSkin"
L.submenu_appearance_targetid_title = "TargetID"
L.submenu_appearance_shop_title = "Impostazioni Shop"
L.submenu_appearance_crosshair_title = "Mirino"
L.submenu_appearance_dmgindicator_title = "Indicatore del Danno"
L.submenu_appearance_performance_title = "Performance"
L.submenu_appearance_interface_title = "Interfaccia"
L.submenu_appearance_miscellaneous_title = "Varie"

L.submenu_gameplay_general_title = "Generale"
L.submenu_gameplay_avoidroles_title = "Evita Selezione Ruoli"

L.submenu_administration_hud_title = "Impostazioni HUD"
L.submenu_administration_randomshop_title = "Shop Casuale"

L.help_color_desc = "Se questa impostazione è abilitata, un colore globale può essere scelto e quello verrà usato per il contorno del targetID e il mirino."
L.help_scale_factor = "Questo numero influenza tutti gli elementi dell'interfaccia (HUD, vgui e targetID). Viene automaticamente aggiornato se viene modificata la risoluzione. Cambiare questo valore reimposterà l'HUD!"
L.help_hud_game_reload = "L'HUD non è disponibile ora. Il gioco deve essere riavviato."
L.help_hud_special_settings = "Queste impostazioni sono specifiche per l'HUD."
L.help_vskin_info = "VSkin (vgui skin) è la skin applicata a tutti gli elementi del menù come quello corrente. Le skin possono essere create facilmente con un semplice script lua e possono cambiare colori e altri parametri per la grandezza."
L.help_targetid_info = "TargetID è l'informazione visualizzata quando miri un'entità. Un colore fisso può essere impostato nelle impostazioni generali."
L.help_hud_default_desc = "Imposta l'HUD di default per tutti i giocatori. I giocatori che non selezionano un HUD avranno questo come default. Questo non cambierà l'HUD dei giocatori che l'hanno selezionato."
L.help_hud_forced_desc = "Forza un HUD per gli altri giocatori. Questo disabilita la selezione degli HUD selection per tutti."
L.help_hud_enabled_desc = "Abilita/Disabilita gli HUD per limitarne la selezione."
L.help_damage_indicator_desc = "L'indicatore di danno è quello che appare quando un giocatore viene danneggiato. Per aggiungere un nuovo tema, metti un png in 'materials/vgui/ttt/damageindicator/themes/'."
L.help_shop_key_desc = "Lo shop dovrebbe essere aperto/chiuso invece del menù dei punteggi in preparazione e alla fine del round?"

L.label_menu_menu = "MENÙ"
L.label_menu_admin_spacer = "Area Admin (non mostrato agli utenti normali)"
L.label_language_set = "Select lingua"
L.label_global_color_enable = "Abilita colore globale"
L.label_global_color = "Colore globale"
L.label_global_scale_factor = "Fattore di scala globale"
L.label_hud_select = "Seleziona HUD"
L.label_vskin_select = "Seleziona VSkin"
L.label_blur_enable = "Abilita blur di sfondo VSkin"
L.label_color_enable = "Abilita colore di sfondo del VSkin"
L.label_minimal_targetid = "ID bersaglio minimale sotto il mirino (niente karma, consigli, ecc.)"
L.label_shop_always_show = "Mostra sempre lo shop"
L.label_shop_double_click_buy = "Enable to buy an item in the shop by double clicking on it"
L.label_shop_num_col = "Numero di colonne"
L.label_shop_num_row = "Numero di righe"
L.label_shop_item_size = "Grandezza icona"
L.label_shop_show_slot = "Mostra indicatore dello slot"
L.label_shop_show_custom = "Mostra indicatore dell'oggetto personalizzato"
L.label_shop_show_fav = "Mostra indicatore oggetto preferito"
L.label_crosshair_enable = "Abilita Crosshair"
L.label_crosshair_gap_enable = "Abilita gap del mirino personalizzato"
L.label_crosshair_gap = "Gap mirino personalizzato"
L.label_crosshair_opacity = "Opacità mirino"
L.label_crosshair_ironsight_opacity = "Opacità mirino di ferro"
L.label_crosshair_size = "Grandezza mirino"
L.label_crosshair_thickness = "Spessore mirino"
L.label_crosshair_thickness_outline = "Spessore contorno del mirino"
L.label_crosshair_static_enable = "Abilita mirino statico"
L.label_crosshair_dot_enable = "Abilita punto del mirino"
L.label_crosshair_lines_enable = "Abilita linee del mirino"
L.label_crosshair_scale_enable = "Abilita scalatura del mirino dell'arma"
L.label_crosshair_ironsight_low_enabled = "Abbassa arma quando usi il mirino di ferro"
L.label_damage_indicator_enable = "Abilita indicatore del danno"
L.label_damage_indicator_mode = "Seleziona tema dell'indicatore del danno"
L.label_damage_indicator_duration = "Secondi per cui l'indicatore di danno è visible dopo un colpo"
L.label_damage_indicator_maxdamage = "Danno necessario per il massimo dell'opacità"
L.label_damage_indicator_maxalpha = "Massima opacità dell'Indicatore del Danno"
L.label_performance_halo_enable = "Disegna un contorno intorno ad alcune entità quando le guardi"
L.label_performance_spec_outline_enable = "Abilita il contorno agli oggetti controllati"
L.label_performance_ohicon_enable = "Abilita icone dei ruoli sopra la testa"
L.label_interface_tips_enable = "Mostra consigli in basso mentre sei uno spettatore"
L.label_interface_popup = "Durata delle informazioni all'inizio del round"
L.label_interface_fastsw_menu = "Abilita il menu con il cambio veloce di armi"
L.label_inferface_wswitch_hide_enable = "Abilita la chiusura automatica del menù di switch rapido"
L.label_inferface_scues_enable = "Senti un avviso appena inizia o finisce il round"
L.label_gameplay_specmode = "Modalità solo spettatore (rimani sempre in spettatori)"
L.label_gameplay_fastsw = "Cambio armi veloce"
L.label_gameplay_hold_aim = "Tieni premuto per mirare"
L.label_gameplay_mute = "Muta tutti i giocatori vivi quando muori"
L.label_gameplay_dtsprint_enable = "Abilita la corsa con il doppio tap"
L.label_gameplay_dtsprint_anykey = "Continua la corsa finché non smette di muoverti"
L.label_hud_default = "HUD di Default"
L.label_hud_force = "Forza HUD"

L.label_bind_weaponswitch = "Prendi Arma"
L.label_bind_sprint = "Corsa"
L.label_bind_voice = "Chat Vocale Globale"
L.label_bind_voice_team = "Chat Vocale di Squadra"

L.label_hud_basecolor = "Colore base"

L.label_menu_not_populated = "Questo sottomenu contiene nessun contenuto."

L.header_bindings_ttt2 = "Assegnazione dei tasti di TTT2"
L.header_bindings_other = "Altre Assegnazioni dei tasti"
L.header_language = "Impostazioni della Lingua"
L.header_global_color = "Seleziona Colore Globale"
L.header_hud_select = "Seleziona un HUD"
L.header_hud_customize = "Personalizza l'HUD"
L.header_vskin_select = "Seleziona e Personalizza la VSkin"
L.header_targetid = "Impostazioni TargetID"
L.header_shop_settings = "Impostazioni Equipaggiamento Shop"
L.header_shop_layout = "Layout Lista di Oggetti"
L.header_shop_marker = "Impostazioni Indicatore Arma"
L.header_crosshair_settings = "Impostazioni Mirino"
L.header_damage_indicator = "Impostazioni Indicatori del Danno"
L.header_performance_settings = "Impostazioni Performance"
L.header_interface_settings = "Impostazioni Interfaccia"
L.header_gameplay_settings = "Impostazioni del Gameplay"
L.header_roleselection = "Abilita Assegnamento Ruoli"
L.header_hud_administration = "Seleziona HUD di Default e Forzati"
L.header_hud_enabled = "Abilita/Disabilita HUD"

L.button_menu_back = "indietro"
L.button_none = "Nessuno"
L.button_press_key = "Premi un tasto"
L.button_save = "Salva"
L.button_reset = "Reimposta"
L.button_close = "Chiudi"
L.button_hud_editor = "Modifica HUD"

-- 2020-04-20
L.item_speedrun = "Speedrun"
L.item_speedrun_desc = [[Ti fa il 50% più veloce!]]
L.item_no_explosion_damage = "No danno Esplosivo"
L.item_no_explosion_damage_desc = [[Ti rende immune al danno esplosivo.]]
L.item_no_fall_damage = "No danno da Caduta"
L.item_no_fall_damage_desc = [[Ti rende immune al danno da caduta.]]
L.item_no_fire_damage = "No danno da Fuoco"
L.item_no_fire_damage_desc = [[Ti rende immune al danno da fuoco.]]
L.item_no_hazard_damage = "No danno da Contaminazione"
L.item_no_hazard_damage_desc = [[Ti rende immune al danno come veleno, radiazioni e acido.]]
L.item_no_energy_damage = "No danno Energetico"
L.item_no_energy_damage_desc = [[Ti rende immune al danno energerico come laser, plasma e fulmini.]]
L.item_no_prop_damage = "No danni da Prop"
L.item_no_prop_damage_desc = [[Ti rende immune al danno dei prop.]]
L.item_no_drown_damage = "No danni da Affogamento"
L.item_no_drown_damage_desc = [[Ti rende immune al danno da affogamento.]]

-- 2020-04-21
L.dna_tid_possible = "Scan possibile"
L.dna_tid_impossible = "No scan possibile"
L.dna_screen_ready = "No DNA"
L.dna_screen_match = "Combacia"

-- 2020-04-30
L.message_revival_canceled = "Rianimazione cancellata."
L.message_revival_failed = "Rianimazione fallita."
L.message_revival_failed_missing_body = "Non sei stato rianimato perchè il tuo corpo non esiste più."
L.hud_revival_title = "Tempo rimasto:"
L.hud_revival_time = "{time}s"

-- 2020-05-03
L.door_destructible = "Questa porta è distruttibile ({health}HP)"

-- 2020-05-28
L.confirm_detective_only = "Solo i detective possono confermare i cadaveri."
L.inspect_detective_only = "Solo i detective possono ispezionare i cadaveri."
L.corpse_hint_no_inspect = "Solo i detective possono ispezione questo cadavere."
L.corpse_hint_inspect_only = "Premi [{usekey}] per ispezionare. Solo i detective possono confermare questo cadavere."
L.corpse_hint_inspect_only_credits = "Premi [{usekey}] per ricevere i crediti. Solo i detective possono ispezionare questo cadavere."

-- 2020-06-04
L.label_bind_disguiser = "Abilita travestimento"

-- 2020-06-24
L.dna_help_primary = "Colleziona il campione di DNA"
L.dna_help_secondary = "Cambia lo slot del DNA"
L.dna_help_reload = "Cancella il campione di DNA"

L.binoc_help_pri = "Identifica il corpo."
L.binoc_help_sec = "Cambia livello di zoom."

L.vis_help_pri = "Getta il dispositivo."

L.decoy_help_pri = "Piazza un esca."

-- 2020-08-07
L.pickup_error_spec = "Non puoi prendere questo da spettatore."
L.pickup_error_owns = "Non puoi prendere questo perché tu hai già quest'arma."
L.pickup_error_noslot = "Non puoi prendere questo perchè non hai nessuno slot libero."

-- 2020-11-02
--L.lang_server_default = "Server Default"
--L.help_lang_info = [[
--This translation is {coverage}% complete with the english language taken as a default reference.

--Keep in mind that these translations are community based. Feel free to contribute if there is something missing or incorrect.]]

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
L.trap_something = "qualcosa"

-- Kill events
--L.desc_event_kill_suicide = "It was suicide."
--L.desc_event_kill_team = "It was a team kill."

L.desc_event_kill_blowup = "{victim} ({vrole} / {vteam}) si è fatto esplodere."
L.desc_event_kill_blowup_trap = "{victim} ({vrole} / {vteam}) è stato fatto esplodere da {trap}."

L.desc_event_kill_tele_self = "{victim} ({vrole} / {vteam}) si è telefraggato."
L.desc_event_kill_sui = "{victim} ({vrole} / {vteam}) non ce l'ha fatta e si è ucciso."
L.desc_event_kill_sui_using = "{victim} ({vrole} / {vteam}) si è ucciso usando {tool}."

L.desc_event_kill_fall = "{victim} ({vrole} / {vteam}) è morto di caduta."
L.desc_event_kill_fall_pushed = "{victim} ({vrole} / {vteam}) è morto di caduta dopo essere stato spinto da {attacker}."
L.desc_event_kill_fall_pushed_using = "{victim} ({vrole} / {vteam}) è morto di caduta dopo essere stato spinto da {attacker} ({arole} / {ateam}) con la trappola {trap}."

L.desc_event_kill_shot = "{victim} ({vrole} / {vteam}) è stata ucciso con un arma da {attacker}."
L.desc_event_kill_shot_using = "{victim} ({vrole} / {vteam}) è stata ucciso da {attacker} ({arole} / {ateam}) con l'arma {weapon}."

L.desc_event_kill_drown = "{victim} ({vrole} / {vteam}) è stato affogato da {attacker}."
L.desc_event_kill_drown_using = "{victim} ({vrole} / {vteam}) è stato affogato da {trap} tramite {attacker} ({arole} / {ateam})."

L.desc_event_kill_boom = "{victim} ({vrole} / {vteam}) è stato fatto esplodere da {attacker}."
L.desc_event_kill_boom_using = "{victim} ({vrole} / {vteam}) è stato fatto esplodere da {attacker} ({arole} / {ateam}) con la trappola {trap}."

L.desc_event_kill_burn = "{victim} ({vrole} / {vteam}) è stato bruciato da {attacker}."
L.desc_event_kill_burn_using = "{victim} ({vrole} / {vteam}) è stato bruciato dalla trappola {trap} attivata da {attacker} ({arole} / {ateam})."

L.desc_event_kill_club = "{victim} ({vrole} / {vteam}) è stato massacrato da {attacker}."
L.desc_event_kill_club_using = "{victim} ({vrole} / {vteam}) è stato massacrato da {attacker} ({arole} / {ateam}) usando la trappola {trap}."

L.desc_event_kill_slash = "{victim} ({vrole} / {vteam}) è stato accoltellato da {attacker}."
L.desc_event_kill_slash_using = "{victim} ({vrole} / {vteam}) è stato accoltellato da {attacker} ({arole} / {ateam}) usando la trappola {trap}."

L.desc_event_kill_tele = "{victim} ({vrole} / {vteam}) è stato telefraggato da {attacker}."
L.desc_event_kill_tele_using = "{victim} ({vrole} / {vteam}) è stato atomizzato dalla trappola {trap} attivata da {attacker} ({arole} / {ateam})."

L.desc_event_kill_goomba = "{victim} ({vrole} / {vteam}) è stata schiacciato dall'enorme masso di {attacker} ({arole} / {ateam})."

L.desc_event_kill_crush = "{victim} ({vrole} / {vteam}) è stato schiacciato da {attacker}."
L.desc_event_kill_crush_using = "{victim} ({vrole} / {vteam}) è stato schiacciato dalla trappola {trap} attivata da {attacker} ({arole} / {ateam})."

L.desc_event_kill_other = "{victim} ({vrole} / {vteam}) è stata ucciso da {attacker}."
L.desc_event_kill_other_using = "{victim} ({vrole} / {vteam}) è stata ucciso da {attacker} ({arole} / {ateam}) con la trappola {trap}."

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
