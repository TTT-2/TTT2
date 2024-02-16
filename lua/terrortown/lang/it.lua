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

-- Scoreboard
L.sb_playing = "Stai giocando su..."
L.sb_mapchange = "La mappa cambierà tra {num} round o tra {time}"
--L.sb_mapchange_disabled = "Session limits are disabled."

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

L.c4_disarm_t = "Taglia un filo per disinnescare la bomba. Come Traditore, ogni filo va bene. Per gli Innocenti non è così facile!"
L.c4_disarm_owned = "Taglia un filo per disinnescare la bomba. È la tua bomba, quindi ogni filo la disinnescherà."
L.c4_disarm_other = "Taglia un filo sicuro per disinnescare la bomba. Esploderà se tagli quello sbagliato!"

L.c4_status_armed = "INNESCATA"
L.c4_status_disarmed = "DISINNESCATA"

-- Visualizer
L.vis_name = "Visualizzatore"

L.vis_desc = [[
Dispositivo per visualizzare una scena del crimine.

Analizza un cadavere per mostrare come la vittima è stata uccisa, ma solo se è morta per colpi di arma da fuoco.]]

-- Decoy
L.decoy_name = "Esca"
L.decoy_broken = "la tua Esca è stata distrutta!"

L.decoy_short_desc = "Questa esca mostra un finto segnale radar per gli altri team"
L.decoy_pickup_wrong_team = "Non puoi prenderlo perchè appartiene a un team differente"

L.decoy_desc = [[
Mostra un segnale falso sul radar dei Detective, e mostra sui loro DNA scanner la posizione dell'Esca se scannerizzano il tuo DNA.]]

-- Defuser
L.defuser_name = "Disinnescatore"

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
L.dna_notfound = "Nessun campione di DNA trovato sul bersaglio."
L.dna_limit = "Limite di deposito raggiunge. Rimuovi vecchi campioni per aggiungerne altri."
L.dna_decayed = "Campione di DNA dell'assassino si è deteriorato."
L.dna_killer = "Preso un campione di DNA dell'assassino dal cadavere!"
--L.dna_duplicate = "Match! You already have this DNA sample in your scanner."
L.dna_no_killer = "Il DNA non può essere preso (assassino disconnesso?)."
L.dna_armed = "La bomba è innescata! Disinnescala prima!"
--L.dna_object = "Collected a sample of the last owner from the object."
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

L.tele_help_pri = "Teletrasporta alla posizione segnalata"
L.tele_help_sec = "Segnala questa posizione"

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

-- TargetID Karma status
L.karma_max = "Affidabile"
L.karma_high = "Poco affidabile"
L.karma_med = "Grilletto facile"
L.karma_low = "Pericoloso"
L.karma_min = "Irresponsabile"

-- TargetID misc
L.corpse = "Cadavere"
--L.corpse_hint = "Press [{usekey}] to search and confirm. [{walkkey} + {usekey}] to search covertly."

L.target_disg = "travestito"
L.target_unid = "Corpo non identificato"
--L.target_unknown = "A Terrorist"

-- HUD buttons with hand icons that only some roles can see and use
L.tbut_single = "Uso singolo"
L.tbut_reuse = "Riutilizzabile"
L.tbut_retime = "Riutilizzabile dopo {num} secondi"
L.tbut_help = "Premi {usekey} per attivare"

-- Spectator muting of living/dead
L.mute_living = "Giocatori in vita mutati"
L.mute_specs = "Spettatori mutati"
L.mute_all = "Tutti mutati"
L.mute_off = "Nessuno mutato"

-- Spectators and prop possession
L.punch_title = "PUNCH-O-METER"
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
--L.equip_tooltip_reroll = "Reroll equipment"

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
--L.reroll_menutitle = "Reroll equipment"
--L.reroll_no_credits = "You need {amount} credits to reroll!"
L.reroll_button = "Rimescola"
--L.reroll_help = "Use {amount} credits to get a new random set of equipment in your shop!"

-- 2019-05-06
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
L.shop_role_selected = "Lo shop del {role} è stato selezionato!"
L.shop_search = "Cerca"

-- 2019-10-19
L.drop_ammo_prevented = "Qualcosa ti impedisce di lasciare queste munizioni."

-- 2019-10-28
L.target_c4 = "Premi [{usekey}] per aprire il menù del C4"
L.target_c4_armed = "Premi [{usekey}] per disinnescare il C4"
L.target_c4_armed_defuser = "Premi [{primaryfire}] per usare il disinnescatore"
L.target_c4_not_disarmable = "Non puoi disinnescare il C4 di un compagno in vita"
L.c4_short_desc = "Qualcosa molto esplosivo"

L.target_pickup = "Premi [{usekey}] per raccogliere"
L.target_slot_info = "Slot: {slot}"
L.target_pickup_weapon = "Premi [{usekey}] per prendere l'arma"
L.target_switch_weapon = "Premi [{usekey}] per scambiare con la tua arma corrente"
L.target_pickup_weapon_hidden = ", premi [{walkkey} + {usekey}] per prenderla silenziosamente"
L.target_switch_weapon_hidden = ", premi [{walkkey} + {usekey}] per scambiarla silenziosamente"
L.target_switch_weapon_nospace = "Non hai uno slot nell'inventario adatto a quest'arma"
L.target_switch_drop_weapon_info = "Lasciando l'arma {name} nello slot {slot}"
L.target_switch_drop_weapon_info_noslot = "Non c'è un'arma che puoi lasciare nello slot {slot}"

--L.corpse_searched_by_detective = "This corpse was searched by a public policing role"
L.corpse_too_far_away = "Il cadavere è troppo lontano."

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
--L.menu_gameplay_description = "Tweak voice and sound volume, accessibility settings, and gameplay settings."
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

L.submenu_gameplay_general_title = "Generale"

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
L.label_crosshair_opacity = "Opacità mirino"
L.label_crosshair_ironsight_opacity = "Opacità mirino di ferro"
L.label_crosshair_size = "Grandezza mirino"
L.label_crosshair_thickness = "Spessore mirino"
L.label_crosshair_thickness_outline = "Spessore contorno del mirino"
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
L.label_hud_default = "HUD di Default"
L.label_hud_force = "Forza HUD"

L.label_bind_weaponswitch = "Prendi Arma"
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
--L.corpse_hint_inspect_limited = "Press [{usekey}] to search. [{walkkey} + {usekey}] to only view search UI."

-- 2020-06-04
L.label_bind_disguiser = "Abilita travestimento"

-- 2020-06-24
L.dna_help_primary = "Colleziona il campione di DNA"
L.dna_help_secondary = "Cambia lo slot del DNA"
L.dna_help_reload = "Cancella il campione di DNA"

L.binoc_help_pri = "Identifica il corpo."
L.binoc_help_sec = "Cambia livello di zoom."

L.vis_help_pri = "Getta il dispositivo."


-- 2020-08-07
L.pickup_error_spec = "Non puoi prendere questo da spettatore."
L.pickup_error_owns = "Non puoi prendere questo perché tu hai già quest'arma."
L.pickup_error_noslot = "Non puoi prendere questo perchè non hai nessuno slot libero."

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

--L.hilite_win_traitors = "TEAM TRAITOR WON"
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
L.search_title = "Risultati ricerca - {player}"
L.search_info = "Informazione"
L.search_confirm = "Conferma morte"
--L.search_confirm_credits = "Confirm (+{credits} Credit(s))"
--L.search_take_credits = "Take {credits} Credit(s)"
--L.search_confirm_forbidden = "Confirm forbidden"
--L.search_confirmed = "Death Confirmed"
--L.search_call = "Report Death"
--L.search_called = "Death Reported"

--L.search_team_role_unknown = "???"

L.search_words = "Qualcosa ti dice che le ultime parole di questa persona erano: '{lastwords}'"
L.search_armor = "Stava indossando un'armatura speciale."
L.search_disguiser = "Stava usando un dispositivo che poteva nascondere la sua identità."
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
L.search_dmg_teleport = "Sembra che il DNA stato criptato da delle emissioni tachioniche!"
L.search_dmg_car = "Quando il terrorista ha attraversato la strada, sono stati investiti da un pilota spericolato."
L.search_dmg_other = "Non puoi trovare una causa di morte specifica per la morte di questo terrorista."

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

L.search_weapon = "Sembra che sia stato usato un {weapon} per ucciderlo."
L.search_head = "La ferita fatale è stata un colpo in testa. Non c'era il tempo di urlare."
--L.search_time = "They died a while before you conducted the search."
--L.search_dna = "Retrieve a sample of the killer's DNA with a DNA Scanner. The DNA sample will decay after a while."

L.search_kills1 = "Hai trovato una lista di uccisioni che conferma la morte di {player}."
L.search_kills2 = "Hai trovato una lista di uccisioni con questi nomi: {player}"
L.search_eyes = "Usando le tue abilità da detective, hai identificato che l'ultima persona che ha visto è: {player}. L'assassino, o una coincidenza?"

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
L.body_confirm_one = "{finder} ha confermato la morte di {victim}."
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
L.decoy_help_primary = "Piazza un esca"
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
