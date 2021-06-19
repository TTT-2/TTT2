-- German language strings

local L = LANG.CreateLanguage("de")

-- Compatibility language name that might be removed soon.
-- the alias name is based on the original TTT language name:
-- https://github.com/Facepunch/garrysmod/blob/master/garrysmod/gamemodes/terrortown/gamemode/lang/german.lua
L.__alias = "deutsch"

L.lang_name = "Deutsch (German)"

-- General text used in various places
L.traitor = "Verräter"
L.detective = "Detektiv"
L.innocent = "Unschuldiger"
L.last_words = "Letzte Worte"

L.terrorists = "Terroristen"
L.spectators = "Zuschauer"

L.nones = "Kein Team"
L.innocents = "Team Unschuldige"
L.traitors = "Team Verräter"

-- Round status messages
L.round_minplayers = "Zu wenig Spieler, um eine neue Runde zu beginnen..."
L.round_voting = "Es läuft eine Umfrage, verzögere neue Runde um {num} Sekunde(n)..."
L.round_begintime = "Eine neue Runde beginnt in {num} Sekunde(n). Bereite dich vor."
L.round_selected = "Die Verräter wurden ausgewählt."
L.round_started = "Die Runde hat begonnen!"
L.round_restart = "Ein Admin erzwang den Neustart der Runde."

L.round_traitors_one = "Verräter, du bist alleine."
L.round_traitors_more = "Verräter, dies sind die Namen deiner Verbündeten: {names}"

L.win_time = "Die Zeit ist abgelaufen. Die Verräter haben verloren."
L.win_traitors = "Die Verräter haben gewonnen!"
L.win_innocents = "Die Innos haben gewonnen!"
L.win_nones = "Die Bienen haben gewonnen! (Es ist ein Unentschieden)"
L.win_showreport = "Schauen wir uns den Rundenbericht die nächste(n) {num} Sekunde(n) an."

L.limit_round = "Rundenlimit erreicht. Die nächste Map wird bald geladen."
L.limit_time = "Zeitlimit erreicht. Die nächste Map wird bald geladen."
L.limit_left = "{num} Runde(n) oder {time} Minute(n) verbleibend bis die Map gewechselt wird."

-- Credit awards
L.credit_all = "Deinem Team wurde(n) {num} Ausrüstungs-Credit(s) für eure Leistung gegeben."
L.credit_kill = "Dir wurde(n) {num} Credit(s) gegeben, da du einen {role} getötet hast."

-- Karma
L.karma_dmg_full = "Dein Karma ist {amount}, also verteilst du diese Runde vollen Schaden!"
L.karma_dmg_other = "Dein Karma ist {amount}. Daher ist dein Schaden um {num}% reduziert!"

-- Body identification messages
L.body_found = "{finder} fand den Körper von {victim}. {role}"
L.body_found_team = "{finder} fand den Körper von {victim}. {role} ({team})"

-- The {role} in body_found will be replaced by one of the following:
L.body_found_traitor = "Er war ein Verräter!"
L.body_found_det = "Er war ein Detektiv."
L.body_found_inno = "Er war unschuldig."

L.body_confirm = "{finder} bestätigte den Tod von {victim}."

L.body_call = "{player} rief einen Detektiv zum Körper von {victim}!"
L.body_call_error = "Du musst erst den Tod dieses Spielers bestätigen, bevor du einen Detektiv rufen kannst!"

L.body_burning = "Autsch! Diese Leiche brennt lichterloh!"
L.body_credits = "Du hast {num} Credit(s) an diesem Körper gefunden!"

-- Menus and windows
L.close = "Schließen"
L.cancel = "Abbrechen"

-- For navigation buttons
L.next = "Weiter"
L.prev = "Zurück"

-- Equipment buying menu
L.equip_title = "Ausrüstung"
L.equip_tabtitle = "Ausrüstung bestellen"

L.equip_status = "Bestellstatus"
L.equip_cost = "Du hast {num} Credit(s) übrig."
L.equip_help_cost = "Jedes Ausrüstungsteil, das du kaufst, kostet 1 Credit."

L.equip_help_carry = "Du kannst nur das kaufen, für das du auch Platz hast."
L.equip_carry = "Du kannst diese Ausrüstung tragen."
L.equip_carry_own = "Du trägst dieses Teil bereits."
L.equip_carry_slot = "Du trägst bereits eine Waffe in Slot {slot}."
L.equip_carry_minplayers = "Es sind nicht genug Spieler auf dem Server, um diese Waffe zu aktivieren."

L.equip_help_stock = "Einige Teile kannst du nur einmal pro Runde kaufen."
L.equip_stock_deny = "Dieses Teil ist nicht länger vorrätig."
L.equip_stock_ok = "Dieses Teil ist vorrätig."

L.equip_custom = "Neues Teil durch den Server hinzugefügt."

L.equip_spec_name = "Name"
L.equip_spec_type = "Typ"
L.equip_spec_desc = "Beschreibung"

L.equip_confirm = "Ausrüstung kaufen"

-- Disguiser tab in equipment menu
L.disg_name = "Tarnung"
L.disg_menutitle = "Tarnung-Einstellungen"
L.disg_not_owned = "Du trägst keine Tarnung!"
L.disg_enable = "Tarnung aktivieren"

L.disg_help1 = "Wenn deine Tarnung aktiv ist, werden dein Name, Leben und Karma nicht angezeigt, wenn dich jemand anschaut. Zusätzlich tauchst du nicht auf dem Radar des Detektivs auf."
L.disg_help2 = "Drücke Enter auf dem Numpad, um die Tarnung an- oder auszuschalten, ohne das Menü zu nutzen. Du kannst alternativ 'ttt_toggle_diguise' durch die Konsole auf eine andere Taste legen."

-- Radar tab in equipment menu
L.radar_name = "Radar"
L.radar_menutitle = "Radar-Einstellungen"
L.radar_not_owned = "Du trägst kein Radar!"
L.radar_scan = "Scan durchführen"
L.radar_auto = "Scan automatisch wiederholen"
L.radar_help = "Scan-Ergebnisse werden {num} Sekunden angezeigt, danach ist das Radar wieder aufgeladen und kann erneut genutzt werden."
L.radar_charging = "Dein Radar lädt immer noch auf!"

-- Transfer tab in equipment menu
L.xfer_name = "Transfer"
L.xfer_menutitle = "Credits transferieren"
L.xfer_send = "Sende einen Credit"

L.xfer_no_recip = "Der Empfänger ist ungültig, Credit-Transfer abgebrochen."
L.xfer_no_credits = "Ungenügend Credits für einen Transfer."
L.xfer_success = "Credit-Transfer an {player} abgeschlossen."
L.xfer_received = "{player} gab dir {num} Credit(s)."

-- Radio tab in equipment menu
L.radio_name = "Radio"
L.radio_help = "Drücke einen Knopf, um das Radio den Ton abspielen zu lassen."
L.radio_notplaced = "Du musst das Radio platzieren, um einen Ton abspielen zu lassen."

-- Radio soundboard buttons
L.radio_button_scream = "Schrei"
L.radio_button_expl = "Explosion"
L.radio_button_pistol = "Pistolen-Schuss"
L.radio_button_m16 = "M16-Schuss"
L.radio_button_deagle = "Deagle-Schuss"
L.radio_button_mac10 = "MAC10-Schuss"
L.radio_button_shotgun = "Shotgun-Schuss"
L.radio_button_rifle = "Gewehr-Schuss"
L.radio_button_huge = "H.U.G.E-Salve"
L.radio_button_c4 = "C4-Piepen"
L.radio_button_burn = "Brennen"
L.radio_button_steps = "Schritte"

-- Intro screen shown after joining
L.intro_help = "Wenn du zum ersten Mal spielst, drücke F1 für Instruktionen!"

-- Radiocommands/quickchat
L.quick_title = "Quickchat-Befehle"

L.quick_yes = "Ja."
L.quick_no = "Nein."
L.quick_help = "Hilfe!"
L.quick_imwith = "Ich bin bei {player}."
L.quick_see = "Ich sehe {player}."
L.quick_suspect = "{player} verhält sich verdächtig."
L.quick_traitor = "{player} ist ein Verräter!"
L.quick_inno = "{player} ist unschuldig."
L.quick_check = "Lebt noch irgendjemand?"

-- {player} in the quickchat text normally becomes a player nickname, but can
-- also be one of the below.  Keep these lowercase.
L.quick_nobody = "niemand(en)"
L.quick_disg = "jemand(en) in Tarnung"
L.quick_corpse = "ein(en) unidentifizierten/r Körper"
L.quick_corpse_id = "{player}'s Leiche"

-- Body search window
L.search_title = "Ergebnisse der Leichenuntersuchung"
L.search_info = "Information"
L.search_confirm = "Tod bestätigen"
L.search_call = "Detektiv rufen"

-- Descriptions of pieces of information found
L.search_nick = "Dies ist der Körper von {player}."

L.search_role_traitor = "Diese Person war ein Verräter!"
L.search_role_det = "Diese Person war ein Detektiv."
L.search_role_inno = "Diese Person war ein unschuldiger Terrorist!"

L.search_words = "Etwas sagt dir, dass die letzten Worte dieser Person \"{lastwords}\" waren."
L.search_armor = "Sie trug eine nicht-standardmäßige Körperrüstung."
L.search_disg = "Sie trug ein Gerät, dass ihre Identität verstecken konnte."
L.search_radar = "Sie trug eine Form eines Radars. Es funktioniert nicht mehr."
L.search_c4 = "In der Tasche war eine Notiz. Sie besagt, dass das Durchschneiden des Drahtes {num} die Bombe sicher entschärfen wird."

L.search_dmg_crush = "Viele Knochen des Opfers sind gebrochen. Es scheint, als habe der Einschlag eines schweren Objekts zum Tode geführt."
L.search_dmg_bullet = "Es ist offensichtlich, dass die Person erschossen wurde."
L.search_dmg_fall = "Sie fiel in ihren Tod."
L.search_dmg_boom = "Ihre Wunden und die versengte Kleidung weisen auf eine Explosion hin, die ihr ein Ende bereitet hat."
L.search_dmg_club = "Der Körper ist ramponiert und verbeult. Die Person wurde mit Sicherheit zu Tode geprügelt."
L.search_dmg_drown = "Der Körper zeigt Anzeichen und Symptome von Ertrinken."
L.search_dmg_stab = "Sie wurde stark geschnitten und hatte tiefe Wunden und verblutete schlussendlich."
L.search_dmg_burn = "Es riecht hier nach gerösteten Terroristen..."
L.search_dmg_tele = "Es scheint, als sei ihre DNA durch Tachyonen verunstaltet worden!"
L.search_dmg_car = "Als diese Person die Straße überquerte, wurde sie von einem rücksichtslosen Fahrer überrollt."
L.search_dmg_other = "Du kannst keinen spezifischen Grund für den Tod dieser Person finden."

L.search_weapon = "Es scheint, als wurde ein(e) {weapon} benutzt, um sie zu töten."
L.search_head = "Die tödliche Wunde war ein Kopfschuss. Keine Zeit, um zu schreien."
L.search_time = "Sie wurde etwa {time} getötet, bevor du die Untersuchung begonnen hast."
L.search_dna = "Erlange eine Probe der DNA des Mörders mit dem DNA-Scanner. Die DNA-Probe wird in etwa {time} verfallen."

L.search_kills1 = "Du fandest eine Liste an Tötungen, die den Tod von {player} beweist."
L.search_kills2 = "Du fandest eine Liste an Tötungen mit diesen Namen:"
L.search_eyes = "Mit deinen Detektiv-Fähigkeiten identifizierst du die letzte Person, die sie sah: {player}. Der Mörder oder ein Zufall?"

-- Scoreboard
L.sb_playing = "Du spielst auf..."
L.sb_mapchange = "Die Karte wechselt in {num} Runden oder in {time}"

L.sb_mia = "Vermisst"
L.sb_confirmed = "Definitiv tot"

L.sb_ping = "Ping"
L.sb_deaths = "Tode"
L.sb_score = "Punkte"
L.sb_karma = "Karma"

L.sb_info_help = "Durchsuche den Körper des Spielers und du wirst hier die Ergebnisse lesen können."

L.sb_tag_friend = "FREUND"
L.sb_tag_susp = "VERDÄCHTIG"
L.sb_tag_avoid = "VERMEIDEN"
L.sb_tag_kill = "TÖTEN"
L.sb_tag_miss = "VERMISST"

-- Equipment actions, like buying and dropping
L.buy_no_stock = "Diese Waffe ist nicht mehr vorrätig: Du hast sie bereits gekauft."
L.buy_pending = "Du hast bereits eine Bestellung aufgegeben, warte bis du sie erhältst."
L.buy_received = "Du hast deine Spezialausrüstung erhalten."

L.drop_no_room = "Du hast hier keinen Platz, um deine Waffe fallen zu lassen!"

L.disg_turned_on = "Tarnung aktiviert!"
L.disg_turned_off = "Tarnung deaktiviert!"

-- Equipment item descriptions
L.item_passive = "Gegenstand mit passivem Effekt"
L.item_active = "Aktiv einsetzbarer Gegenstand"
L.item_weapon = "Waffe"

L.item_armor = "Körperrüstung"
L.item_armor_desc = [[
Verringere den Schaden durch Kugeln, Feuer und Explosionen. Geht mit der Zeit kaputt.

Du kannst es mehrfach kaufen. Beim Erreichen eines gewissen Rüstungswert wird die Rüstung stärker.]]

L.item_radar = "Radar"
L.item_radar_desc = [[
Dies erlaubt dir nach Lebenszeichen zu scannen.

Es startet automatisch beim Kauf. Stelle es im Reiter "Radar" dieses Menüs ein.]]

L.item_disg = "Tarnung"
L.item_disg_desc = [[
Versteckt deine ID. Vermeidet außerdem, dass du die letzte vom Opfer gesehene Person bist.

Schalte es im Reiter "Tarnung" ein oder aus oder drücke Enter auf dem Numpad.]]

-- C4
L.c4_hint = "Drücke {usekey} zum Scharfstellen oder Entschärfen."
L.c4_disarm_warn = "Eine Ladung C4, die du platziert hast, ist entschärft worden."
L.c4_armed = "Du hast die Bombe erfolgreich scharf gestellt."
L.c4_disarmed = "Du hast die Bombe erfolgreich entschärft."
L.c4_no_room = "Du kannst dieses C4 nicht tragen."

L.c4_desc = "Starke Zeitbombe."

L.c4_arm = "C4 scharf machen"
L.c4_arm_timer = "Zünder"
L.c4_arm_seconds = "Sekunden bis zur Detonation:"
L.c4_arm_attempts = "Beim Versuch die Bombe zu entschärfen, lösen {num} der 6 Kabel eine sofortige Detonation beim Durchschneiden aus."

L.c4_remove_title = "Entfernen"
L.c4_remove_pickup = "C4 aufheben"
L.c4_remove_destroy1 = "C4 vernichten"
L.c4_remove_destroy2 = "Bestätigen: Vernichten"

L.c4_disarm = "C4 entschärfen"
L.c4_disarm_cut = "Klicke zum Durchschneiden von Kabel {num}"

L.c4_disarm_owned = "Durchschneide ein Kabel zum Entschärfen der Bombe. Es ist deine Bombe, also wird jedes Kabel sie sicher entschärfen."
L.c4_disarm_other = "Durchschneide das richtige Kabel, um die Bombe zu entschärfen. Sie explodiert, wenn du das falsche triffst!"

L.c4_status_armed = "SCHARF"
L.c4_status_disarmed = "ENTSCHÄRFT"

-- Visualizer
L.vis_name = "Visualisierer"
L.vis_hint = "Drücke {usekey} zum Aufheben (nur Detektive)."

L.vis_desc = [[
Tatort-Visualisierungs-Gerät.

Analysiere eine Leiche, um zu sehen, wie die Person umgebracht wurde, funktioniert nur bei Tod durch Beschuss.]]

-- Decoy
L.decoy_name = "Attrappe"
L.decoy_no_room = "Du kannst diese Attrappe nicht tragen."
L.decoy_broken = "Deine Attrappe wurde zerstört!"

L.decoy_short_desc = "Diese Attrappe erzeugt ein gefälschtes Radar-Signal sichtbar für andere Teams"
L.decoy_pickup_wrong_team = "Du kannst sie nicht aufnehmen, da sie einem anderen Team gehört"

L.decoy_desc = [[
Zeigt Detektiven ein gefälschtes Radar-Signal und bewirkt, dass der DNA-Scanner den Ort der Attrappe zeigt, wenn sie nach deiner DNA suchen.]]

-- Defuser
L.defuser_name = "Entschärfer"
L.defuser_help = "{primaryfire} entschärft anvisiertes C4."

L.defuser_desc = [[
Entschärft sofort eine C4-Bombe.

Unbegrenzt nutzbar. C4 wird leichter zu entdecken sein, wenn du das bei dir trägst.]]

-- Flare gun
L.flare_name = "Leuchtkanone"

L.flare_desc = [[
Kann benutzt werden, um Leichen zu verbrennen, damit sie nie gefunden werden können. Begrenzte Munition.

Das Verbrennen einer Leiche macht ein ganz bestimmtes Geräusch.]]

-- Health station
L.hstation_name = "Gesundheitsstation"

L.hstation_broken = "Deine Gesundheitsstation wurde zerstört!"
L.hstation_help = "{primaryfire} platziert die Gesundheitsstation."

L.hstation_desc = [[
Ermöglicht bei Platzierung, dass sich jeder Spieler an ihr heilen kann.

Langsame Wiederaufladung, kann beschädigt werden. Am Gerät sind DNA-Spuren ihrer Benutzer zu finden.]]

-- Knife
L.knife_name = "Messer"
L.knife_thrown = "Geworfenes Messer"

L.knife_desc = [[
Tötet verletzte Ziele sofort und leise, kann aber nur einmal genutzt werden.

Kann mit alternativer Feuertaste geworfen werden.]]

-- Poltergeist
L.polter_desc = [[
Platziert Beschleuniger an Objekte um sie wild herumwirbeln zu lassen.

Die Energiespitzen schädigen nahestehende Spieler.]]

-- Radio
L.radio_broken = "Dein Radio wurde zerstört!"
L.radio_help_pri = "{primaryfire} platziert das Radio."

L.radio_desc = [[
Spielt Geräusche zur Ablenkung ab.

Platziere das Radio irgendwo und spiele Geräusche im Reiter "Radio" dieses Menüs ab.]]

-- Silenced pistol
L.sipistol_name = "Schallgedämpfte Pistole"

L.sipistol_desc = [[
Handfeuerwaffe mit geringer Lautstärke, nutzt normale Pistolenmunition.

Opfer schreien nicht, wenn sie damit getötet werden.]]

-- Newton launcher
L.newton_name = "Newton Launcher"

L.newton_desc = [[
Stoße Spieler aus einer sicheren Entfernung.

Unbegrenzt Munition, aber langsame Schussfolge.]]

-- Binoculars
L.binoc_name = "Fernglas"

L.binoc_desc = [[
Zoome an eine Leiche heran um sie aus einer großen Entfernung zu identifizieren.

Unbegrenzt nutzbar, aber das Identifizieren dauert einige Sekunden.]]

-- UMP
L.ump_desc = [[
Experimentelles SMG, das Ziele desorientiert.

Nutzt normale SMG Munition.]]

-- DNA scanner
L.dna_name = "DNA-Scanner"
L.dna_notfound = "Keine Spuren von DNA am Ziel gefunden."
L.dna_limit = "Speicherlimit erreicht. Entferne alte Spuren, um neue hinzuzufügen."
L.dna_decayed = "Die DNA-Spur des Mörders ist verfallen."
L.dna_killer = "Es wurde eine DNA-Spur des Mörders von der Leiche aufgesammelt!"
L.dna_duplicate = "Treffer! Die DNA befindet sich bereits in deinem Scanner!"
L.dna_no_killer = "Die DNA konnte nicht erlangt werden (Mörder vom Server gegangen?)."
L.dna_armed = "Die Bombe ist scharf! Entschärfe sie zuerst!"
L.dna_object = "Es wurde eine DNA-Spur vom letzten Besitzer des Objektes gefunden."
L.dna_gone = "DNA nicht in diesem Bereich gefunden."

L.dna_desc = [[
Sammelt DNA-Spuren von Objekten auf und wird genutzt, um den Besitzer dieser ausfindig zu machen.

Kann an frischen Leichen verwendet werden, um die DNA des Mörders zu erhalten und um ihn aufzuspüren.]]

-- Magneto stick
L.magnet_name = "Magneto-Stick"
L.magnet_help = "{primaryfire} um Körper an Oberfläche anzubinden."

-- Grenades and misc
L.grenade_smoke = "Rauchgranate"
L.grenade_fire = "Brandgranate"

L.unarmed_name = "Unbewaffnet"
L.crowbar_name = "Brecheisen"
L.pistol_name = "Pistole"
L.rifle_name = "Gewehr"
L.shotgun_name = "Schrotgewehr"

-- Teleporter
L.tele_name = "Teleporter"
L.tele_failed = "Teleport fehlgeschlagen."
L.tele_marked = "Teleportstelle markiert."

L.tele_no_ground = "Kann nur auf solidem Untergrund teleportieren!"
L.tele_no_crouch = "Kann nicht geduckt teleportieren!"
L.tele_no_mark = "Keine Stelle markiert. Markiere ein Ziel vor dem Teleportieren."

L.tele_no_mark_ground = "Kann keine Teleportstelle markieren, während man nicht auf solidem Untergrund steht!"
L.tele_no_mark_crouch = "Kann keine Teleportstelle markieren, während man geduckt ist!"

L.tele_help_pri = "{primaryfire} teleportiert dich zur markierten Stelle."
L.tele_help_sec = "{secondaryfire} markiert momentane Position."

L.tele_desc = [[
Teleportiert dich zu einer zuvor markierten Stelle.

Das Teleportieren macht Geräusche und die Anzahl der Benutzungen ist begrenzt.]]

-- Ammo names, shown when picked up
L.ammo_pistol = "9mm Munition"

L.ammo_smg1 = "SMG Munition"
L.ammo_buckshot = "Shotgun Munition"
L.ammo_357 = "Gewehr Munition"
L.ammo_alyxgun = "Deagle Munition"
L.ammo_ar2altfire = "Leucht Munition"
L.ammo_gravity = "Poltergeist Munition"

-- Round status
L.round_wait = "Warte..."
L.round_prep = "Vorbereitung"
L.round_active = "Läuft"
L.round_post = "Runde vorbei"

-- Health, ammo and time area
L.overtime = "VERLÄNGERUNG"
L.hastemode = "HAST MODUS"

-- TargetID health status
L.hp_healthy = "Gesund"
L.hp_hurt = "Verletzt"
L.hp_wounded = "Verwundet"
L.hp_badwnd = "Schwer Verwundet"
L.hp_death = "Dem Tode nah"

-- TargetID karma status
L.karma_max = "Verlässlich"
L.karma_high = "Grob"
L.karma_med = "Schießwütig"
L.karma_low = "Gefährlich"
L.karma_min = "Verantwortungslos"

-- TargetID misc
L.corpse = "Leiche"
L.corpse_hint = "Drücke [{usekey}] zum Durchsuchen. [{walkkey} + {usekey}] um verdeckt zu untersuchen."

L.target_disg = "(Getarnt)"
L.target_unid = "Unidentifizierter Körper"

L.target_credits = "Durchsuche, um ungenutzte Credits zu erhalten."

-- HUD buttons with hand icons that only some roles can see and use
L.tbut_single = "Einmaliger Gebrauch"
L.tbut_reuse = "Wiederverwendbar"
L.tbut_retime = "Wiederverwendbar nach {num} Sekunden"
L.tbut_help = "Drücke [{usekey}] zum Aktivieren"

-- Spectator muting of living/dead
L.mute_living = "Lebende stumm gestellt"
L.mute_specs = "Zuschauer stumm gestellt"
L.mute_all = "Jeden stumm gestellt"
L.mute_off = "Niemanden stumm gestellt"

-- Spectators and prop possession
L.punch_title = "PUNCH-O-METER"
L.punch_help = "Die Bewegungstasten oder Springen: Objekt bewegen. Ducken: Objekt verlassen."
L.punch_bonus = "Deine schlechte Punktzahl hat dein Punch-O-Meter Limit um {num} verringert."
L.punch_malus = "Deine gute Punktzahl hat dein Punch-O-Meter Limit um {num} erhöht!"

-- Info popups shown when the round starts
L.info_popup_innocent = [[
Du bist ein unschuldiger Terrorist! Aber es gibt Verräter...
Wem kannst du trauen, und wem füllst du den Körper mit Blei?

Gib Acht und arbeite mit anderen zusammen, um zu überleben!]]

L.info_popup_detective = [[
Du bist ein Detektiv! Das Terroristen Hauptquartier hat dir spezielle Ressourcen gegeben, um die Verräter zu finden.
Benutze sie, um den Unschuldigen zu helfen, aber sei auf der Hut:
Die Verräter werden zusehen dich als erstes zu töten!

Drücke {menukey} für neue Ausrüstung!]]

L.info_popup_traitor_alone = [[
Du bist ein VERRÄTER! Du hast keine weiteren Verräter diese Runde.

Töte ALLE anderen, um zu gewinnen!

Drücke {menukey} um den Verräter Shop zu öffnen!]]

L.info_popup_traitor = [[
Du bist VERRÄTER! Arbeite mit deinen Verräter Kollegen, um alle anderen Terroristen zu töten.
Aber sei vorsichtig, damit dein Verrat nicht aufgedeckt wird...

Das sind deine Kollegen:
{traitorlist}

Drücke {menukey} um den Verräter Shop zu öffnen!]]

-- Various other text
L.name_kick = "Ein Spieler wurde automatisch gekickt, weil er seinen Namen während einer laufenden Runde geändert hat."

L.idle_popup = [[
Du warst untätig für {num} Sekunden und wurdest deshalb in den Zuschauer-Modus gesetzt. Während du in diesem Modus bist, kannst du nicht an einer neuen Runde teilnehmen.

Du kannst den Nur-Zuschauer-Modus ausschalten, indem du {helpkey} drückst und den Haken im Einstellungsreiter rausmachst. Du kannst es aber auch jetzt sofort ausschalten.]]

L.idle_popup_close = "Nichts tun"
L.idle_popup_off = "Deaktiviere Nur-Zuschauer-Modus"

L.idle_warning = "Warnung: Du scheinst AFK zu sein und wirst zum Zuschauer, außer du zeigst Aktivität!"

L.spec_mode_warning = "Du bist im Zuschauermodus und wirst nicht spielen, wenn eine Runde beginnt. Um diesen Modus zu verlassen, drücke F1, gehe in die ‘Gameplay’ Einstellungen und nimm den Haken bei ‘Nur-Zuschauer-Modus’ raus."

-- Tips panel
L.tips_panel_title = "Tipps"
L.tips_panel_tip = "Tipp:"

-- Tip texts
L.tip1 = "Verräter können eine Leiche durch Halten von {walkkey} und Drücken von {usekey} verdeckt untersuchen, ohne ihren Tod zu bestätigen."

L.tip2 = "Das Scharfmachen einer C4 Bombe mit längerem Zünder erhöht die Anzahl an Kabeln, die zu einer sofortigen Detonation führen, wenn ein Unschuldiger versucht es zu entschärfen. Außerdem piepst sie leiser und seltener."

L.tip3 = "Detektive können Leichen untersuchen, um herauszufinden, wer ‘in den Augen gespiegelt’ wurde. Das ist die letzte Person, die der Tote sah. Das muss nicht der Mörder sein, wenn er von hinten erschossen wurde."

L.tip4 = "Niemand wird von deinem Tod erfahren, bis jemand deine Leiche gefunden und untersucht hat."

L.tip5 = "Wenn ein Verräter einen Detektiv tötet, erlangen diese direkt einen Credit als Belohnung."

L.tip6 = "Wenn ein Verräter von einem Detektiv getötet wird, erhalten alle Detektive einen Credit."

L.tip7 = "Wenn Verräter einen guten Fortschritt beim Töten von Unschuldigen gemacht haben, erhalten sie als Belohnung einen Credit."

L.tip8 = "Verräter und Detektive können unverbrauchte Credits von Leichen anderer Verräter oder Detektive aufsammeln."

L.tip9 = "Der Poltergeist kann physikalische Objekte in tödliche Projektile verwandeln. Jeder Schlag ist begleitet von einem Energieimpuls, der jeden in der Nähe verletzt."

L.tip10 = "Halte als Verräter auf rote oder als Detektiv auf blaue Nachrichten in der oberen rechten Bildschirmecke Ausschau. Diese sind wichtig für dich."

L.tip11 = "Behalte als Verräter oder Detektiv im Kopf, dass du Credits verdienst, wenn deine Partner gut arbeiten. Vergiss nicht diese auch auszugeben!"

L.tip12 = "Der DNA-Scanner des Detektivs kann genutzt werden, um DNA-Proben von Waffen und Objekten zu erhalten. Diese können zum Scannen benutzt werden, um die Position des Spielers herauszufinden, der diese benutzt hat. Nützlich, wenn du eine Probe von einer Leiche oder einer entschärften Ladung C4 erhalten hast!"

L.tip13 = "Wenn du in der Nähe von jemandem standest, den du getötet hast, hinterlässt du deine DNA auf der Leiche. Diese DNA kann ein Detektiv mit seinem DNA-Scanner untersuchen, um deine momentane Position herauszufinden. Es wäre besser, wenn du die Leiche versteckst, nachdem du jemanden mit dem Messer getötet hast!"

L.tip14 = "Je weiter du dich von der Leiche entfernst, an der deine DNA hängt, desto schneller verschwindet die DNA-Spur."

L.tip15 = "Du bist ein böser Heckenschütze? Dann solltest du in Betracht ziehen eine Tarnung zu kaufen. Wenn du verfehlst, renn an einen sicheren Ort und deaktiviere deine Tarnung. Niemand wird wissen, dass du der Heckenschütze warst."

L.tip16 = "Der Teleporter kann dir als Verräter helfen zu entkommen oder dich schnell auf der Karte zu bewegen. Stelle sicher, dass du stets einen sicheren Punkt hast, zu dem du dich teleportieren kannst."

L.tip17 = "Stehen die Unschuldigen alle zusammen und sind schwer einzeln zu erledigen? Schnapp' dir das Radio, spiel Sounds von C4 oder Schüssen ab, um sie wegzulocken."

L.tip18 = "Du kannst mit dem platzierten Radio als Verräter Sounds im Ausrüstungsmenü abspielen. Du kannst mehrere Sounds hintereinander in Warteschlange geben, indem du sie in der Reihenfolge anklickst, in der sie gespielt werden sollen."

L.tip19 = "Wenn du als Detektiv Credits übrighast, kannst du deinen Entschärfer an einen glaubwürdigen Unschuldigen abgeben, dich um Wichtigeres kümmern und ihm den gefährlichen Job des Entschärfens überlassen."

L.tip20 = "Das Fernglas der Detektive kann Leichen aus großer Distanz untersuchen. Schlechte Nachrichten für die Verräter, wenn die die Leiche als Lockmittel nutzen wollten. Allerdings ist der Detektiv währenddessen unbewaffnet und abgelenkt..."

L.tip21 = "Die Gesundheitsstation der Detektive lässt verwundeten Spielern zu, sich zu heilen. Natürlich könnten diese verwundeten Spieler auch Verräter sein..."

L.tip22 = "Die Gesundheitsstation zeichnet die DNA jedes Spielers auf, der diese benutzt. Detektive können somit herausfinden, wer mit der Station bereits Lebenspunkte wiederhergestellt hat."

L.tip23 = "Anders als bei Waffen und C4 bleibt keine DNA des Platzierers auf einem Radio. Mach dir also keine Sorge darüber, ob Detektive dein Radio finden."

L.tip24 = "Drücke {helpkey} um ein kurzes Tutorium anzuzeigen und einige TTT-spezifische Einstellungen zu ändern. Du kannst beispielsweise diese Tipps hier deaktivieren."

L.tip25 = "Wenn ein Detektiv einen Körper untersucht, dann sind die Ergebnisse für alle Spieler durch Klicken auf den Spielernamen im Scoreboard sichtbar."

L.tip26 = "Eine Lupe weist im Scoreboard darauf hin, dass es Untersuchungsergebnisse für diese Person gibt. Wenn das Symbol hell ist, dann kommen die Daten von einem Detektiv und können noch mehr Informationen enthalten."

L.tip27 = "Als Detektiv wird eine Lupe neben dem Namen einer Leiche angezeigt, was bedeutet, dass diese von einem Detektiv untersucht wurde. Die Ergebnisse sind für alle im Scoreboard verfügbar."

L.tip28 = "Zuschauer können {mutekey} drücken, um durch die Stummschaltmodi von anderen Zuschauern oder lebenden Spielern zu schalten."

L.tip29 = "Wenn der Server zusätzliche Sprachen installiert hat, kannst du diese jederzeit im Einstellungsmenü aufrufen."

L.tip30 = "Schnellkommunikation oder 'radio' Kommandos können durch Drücken von {zoomkey} genutzt werden."

L.tip31 = "Als Zuschauer, drücke {duckkey} um deinen Mauszeiger zu aktivieren und klicke auf die Schaltflächen in diesem Hinweis-Fenster. Drücke {duckkey} erneut, um die Maussicht wieder zu aktivieren."

L.tip32 = "Das Sekundärfeuer der Brechstange schubst andere Spieler weg."

L.tip33 = "Das Schießen, während du mit Kimme und Korn zielst, erhöht deine Präzision leicht und verringert den Rückstoß beim Schießen. Ducken tut dies nicht."

L.tip34 = "Rauchgranaten sind innerhalb von Räumen effektiv. Speziell um Verwirrung zwischen vielen Leuten zu schaffen."

L.tip35 = "Als Verräter, denke daran, dass du die Leichen wegschleppen und vor den Stielaugen der Unschuldigen und der Detektive verstecken kannst und auch solltest."

L.tip36 = "Das Tutorial ist unter {helpkey} verfügbar und beinhaltet eine Übersicht der wichtigsten Tastenbelegungen des Spiels."

L.tip37 = "Auf dem Scoreboard kannst du auf die Namen der lebendigen Spieler klicken und ihnen Markierungen setzen, wie zum Beispiel 'Verdächtig' oder 'Freund'. Diese Markierungen erscheinen, wenn du den markierten Spieler anvisierst."

L.tip38 = "Viele der platzierbaren Ausrüstungsgegenstände (wie zum Beispiel C4 oder das Radio) können mit einem Druck auf die Sekundärfeuertaste an Wänden befestigt werden."

L.tip39 = "C4, das beim Entschärfen ungewollt gezündet wird, hat eine geringere Detonationskraft als solches, bei dem die gesamte Zeit abläuft."

L.tip40 = "Wenn 'HAST MODUS' über der Rundenzeit zu lesen ist, dauert die Runde zunächst nur wenige Minuten länger, wird jedoch mit jedem Tod weiter und weiter verlängert. Dieser Modus übt Druck auf die Verräter aus und sorgt dafür, dass sie sich nicht alle Zeit der Welt nehmen können."

-- Round report
L.report_title = "Rundenbericht"

-- Tabs
L.report_tab_hilite = "Höhepunkte"
L.report_tab_hilite_tip = "Höhepunkte dieser Runde"
L.report_tab_events = "Ereignis"
L.report_tab_events_tip = "Liste der Ereignisse dieser Runde"
L.report_tab_scores = "Punkte"
L.report_tab_scores_tip = "Punkte pro Spieler in dieser Runde"

-- Event log saving
L.report_save = "Speichere Log .txt"
L.report_save_tip = "Speichert den Ereignis-Log in einer Textdatei"
L.report_save_error = "Keine Ereignis-Log Daten vorhanden."
L.report_save_result = "Der Ereignis-Log wurde gespeichert:"

-- Columns
L.col_time = "Dauer"
L.col_event = "Ereignis"
L.col_player = "Spieler"
L.col_roles = "Rolle(n)"
L.col_teams = "Team(s)"
L.col_kills1 = "Kills"
L.col_kills2 = "Teamkills"
L.col_points = "Punkte"
L.col_team = "Team Bonus"
L.col_total = "Gesamtpunktzahl"

-- Awards/highlights
L.aw_sui1_title = "Leiter des Selbstmord-Kultes"
L.aw_sui1_text = "zeigte den anderen Selbstmördern, wie sie es zu tun haben, indem er der erste war."

L.aw_sui2_title = "Allein und deprimiert"
L.aw_sui2_text = "war der Einzige, der sich selbst umgebracht hat."

L.aw_exp1_title = "Stipendium für Explosive Forschungen"
L.aw_exp1_text = "wurde für seine Forschungen an Explosionen anerkannt. {num} Versuchskaninchen haben mitgeholfen."

L.aw_exp2_title = "Feldforschung"
L.aw_exp2_text = "testete seinen Widerstand gegen Explosionen. Er war nicht genug."

L.aw_fst1_title = "First Blood"
L.aw_fst1_text = "ließ als Verräter das erste unschuldige Blut vergießen."

L.aw_fst2_title = "First Bloody Stupid Kill"
L.aw_fst2_text = "hat die erste Tötung durch das Umbringen eines Verräter-Kollegen erzielt. Ganz tolle Arbeit."

L.aw_fst3_title = "Erstes Missgeschick"
L.aw_fst3_text = "übte die erste Tötung aus. Blöd nur, dass es ein Unschuldiger war."

L.aw_fst4_title = "Erster Schlag"
L.aw_fst4_text = "hat den ersten Schlag für die Unschuldigen getätigt, indem er den ersten Verräter getötet hat."

L.aw_all1_title = "Der Tödlichste unter Gleichen"
L.aw_all1_text = "war für jede einzelne Tötung der Unschuldigen in dieser Runde verantwortlich."

L.aw_all2_title = "Einsamer Wolf"
L.aw_all2_text = "war für jede einzelne Tötung der Verräter in dieser Runde verantwortlich."

L.aw_nkt1_title = "Ich hab' einen, Boss!"
L.aw_nkt1_text = "hat es geschafft einen einzigen Unschuldigen zu töten. Wie süß!"

L.aw_nkt2_title = "Eine Kugel für zwei"
L.aw_nkt2_text = "zeigte, dass der Erste nicht nur Glück war, indem er auch noch einen Zweiten umbrachte."

L.aw_nkt3_title = "Serien-Verräter"
L.aw_nkt3_text = "beendete heute drei unschuldige Leben."

L.aw_nkt4_title = "Wolf unter eher Schaf-gleichen Wölfen"
L.aw_nkt4_text = "verspeist Unschuldige zum Frühstück. Heute ist es mit {num} Stück groß ausgefallen!"

L.aw_nkt5_title = "Konter-terroristische Maßnahme"
L.aw_nkt5_text = "wird pro Tötung bezahlt. Bald gibt's eine neue Yacht."

L.aw_nki1_title = "Betray This!"
L.aw_nki1_text = "fand einen Verräter. Tötete einen Verräter. Ganz simpel."

L.aw_nki2_title = "Mitglied beim Gerechtigkeits-Trupp"
L.aw_nki2_text = "eskortierte zwei Verräter ins Jenseits."

L.aw_nki3_title = "Träumen Verräter von verräterischen Schafen?"
L.aw_nki3_text = "legte drei Verräter schlafen."

L.aw_nki4_title = "Angestellter innerer Angelegenheiten"
L.aw_nki4_text = "wird pro Tötung bezahlt. Er kann sich nun seinen fünften Pool leisten."

L.aw_fal1_title = "Nein, Mr. Bond, ich erwarte, dass sie fallen"
L.aw_fal1_text = "hat jemanden von ganz weit oben heruntergeschubst."

L.aw_fal2_title = "Geplättet"
L.aw_fal2_text = "hat seinen Körper den Boden berühren lassen, nachdem er von einer bemerkenswerten Höhe gefallen ist."

L.aw_fal3_title = "Der menschliche Meteorit"
L.aw_fal3_text = "hat jemanden zerquetscht indem er auf ihm gelandet ist."

L.aw_hed1_title = "Effizienz"
L.aw_hed1_text = "hat die Freude an Kopfschüssen erkannt und verteilte insgesamt {num} Stück."

L.aw_hed2_title = "Neurologie"
L.aw_hed2_text = "entfernte insgesamt {num} Gehirne aus den Köpfen anderer, um sie genauer zu untersuchen."

L.aw_hed3_title = "Killerspiele sind schuld"
L.aw_hed3_text = "hat sich zur Mörder-Simulation angemeldet und insgesamt {num} Gegnern in die Rübe geschossen."

L.aw_cbr1_title = "Thunk Thunk Thunk"
L.aw_cbr1_text = "hat einen ganz schönen Schwung mit der Brechstange, wie {num} Opfer schmerzlich herausfinden mussten."

L.aw_cbr2_title = "Freeman"
L.aw_cbr2_text = "hat seine Brechstange in den Gehirnen von nicht weniger als {num} Leuten versenkt."

L.aw_pst1_title = "Hartnäckige kleine Lümmel"
L.aw_pst1_text = "erzielte {num} Tötungen mit einer Pistole. Danach führten sie fort, jemanden zu Tode zu umarmen."

L.aw_pst2_title = "Kleinkaliber-Gemetzel"
L.aw_pst2_text = "tötete eine kleine Armee von {num} mit einer Pistole. Wahrscheinlich installierte er ein kleines Schrotgewehr im Lauf."

L.aw_sgn1_title = "Easy Mode"
L.aw_sgn1_text = "verwendete Schrot da, wo es wehtut, und ermordete {num} Ziele."

L.aw_sgn2_title = "Tausend kleine Kügelchen"
L.aw_sgn2_text = "mochte sein Schrot nicht und gab alles weg. {num} Empfänger genossen es nicht."

L.aw_rfl1_title = "Zielen und abdrücken"
L.aw_rfl1_text = "zeigte: Alles, was man für {num} Tötungen benötigt ist ein Gewehr und eine ruhige Hand."

L.aw_rfl2_title = "Ich seh' deinen Kopf von hier drüben"
L.aw_rfl2_text = "kennt sein Gewehr. Jetzt tun es {num} andere Leute ebenso."

L.aw_dgl1_title = "Wie ein kleines Gewehr"
L.aw_dgl1_text = "gewöhnt sich langsam an die Desert Eagle und tötete {num} Leute."

L.aw_dgl2_title = "Eagle Master"
L.aw_dgl2_text = "hat {num} Leute mit der Deagle weggeblasen."

L.aw_mac1_title = "Pray and Slay"
L.aw_mac1_text = "tötete {num} Leute mit der MAC10, sagte allerdings nicht wie viel Munition er dafür gebraucht hat."

L.aw_mac2_title = "Mac and Cheese"
L.aw_mac2_text = "fragt sich, was passieren würde, wenn man zwei MAC10s gleichzeitig benutzen würde. Zweimal {num}?"

L.aw_sip1_title = "Ruhe"
L.aw_sip1_text = "stellt {num} Leute mit einer schallgedämpften Pistole stumm."

L.aw_sip2_title = "Lautloser Assassine"
L.aw_sip2_text = "tötete {num} Leute, die sich nicht einmal selbst schreien hören haben."

L.aw_knf1_title = "Das Messer kennt dich"
L.aw_knf1_text = "hat jemandem über das Internet ins Gesicht gestochen."

L.aw_knf2_title = "Woher hast du das!?"
L.aw_knf2_text = "war zwar kein Verräter, hat allerdings trotzdem jemanden aufgeschlitzt."

L.aw_knf3_title = "Such A 'Knife' Man"
L.aw_knf3_text = "fand {num} herumliegende Messer und nutzte sie."

L.aw_knf4_title = "World's 'Knifest' Man"
L.aw_knf4_text = "tötete {num} mit Messern. Frag' nicht wie..."

L.aw_flg1_title = "Zur Rettung"
L.aw_flg1_text = "benutzte die Signalpistole um {num} Tode zu signalisieren."

L.aw_flg2_title = "Lodern weist auf Feuer hin"
L.aw_flg2_text = "zeigte {num} Leuten wie riskant es ist, leicht entflammbare Kleidung zu tragen."

L.aw_hug1_title = "A H.U.G.E Spread"
L.aw_hug1_text = "war in der Laune mit seiner H.U.G.E irgendwie dafür zu sorgen, dass dessen Kugeln {num} Leute trafen."

L.aw_hug2_title = "A Patient Para"
L.aw_hug2_text = "hat den Abzug einfach nicht losgelassen und hat seine H.U.G.E-Geduld mit {num} Tötungen belohnt."

L.aw_msx1_title = "Putt Putt Putt"
L.aw_msx1_text = "hat sich {num} Leute mit der M16 geschnappt."

L.aw_msx2_title = "Wahnsinn auf mittlere Entfernung"
L.aw_msx2_text = "weiß, wie er Ziele mit der M16 rausnimmt und erzielte {num} Tötungen."

L.aw_tkl1_title = "Nur ein Versehen"
L.aw_tkl1_text = "rutschte genau in dem Moment, als er seinen Kumpel ansah, mit dem Finger ab."

L.aw_tkl2_title = "Doppeltes Versehen"
L.aw_tkl2_text = "verdächtigte zwei Leute als Verräter. Leider zwei Mal falsch."

L.aw_tkl3_title = "Karma-bewusst"
L.aw_tkl3_text = "tötete zwei Verbündete und machte dann auch beim Dritten kein Halt. Immerhin ist drei 'ne Glückszahl!"

L.aw_tkl4_title = "Teamkiller"
L.aw_tkl4_text = "brachte das komplette eigene Team um. OMGBANBANBAN."

L.aw_tkl5_title = "Rollenspieler"
L.aw_tkl5_text = "spielte seine Rolle als böser Mann wirklich authentisch. Das ist auch der Grund, warum er die meisten seines Teams umbrachte."

L.aw_tkl6_title = "Trottel"
L.aw_tkl6_text = "konnte nicht herausfinden, auf welcher Seite er eigentlich spielte und brachte mehr als die Hälfte seines Teams um."

L.aw_tkl7_title = "Redneck"
L.aw_tkl7_text = "hat sein Gebiet recht gut verteidigt und etwa ein Viertel des eigenen Teams ausgelöscht."

L.aw_brn1_title = "Wie bei Oma"
L.aw_brn1_text = "verbrannte mehrere Leute, bis sie schön knusprig waren."

L.aw_brn2_title = "Pyromane"
L.aw_brn2_text = "wurde laut knisternd erhört, nachdem er eines seiner vielen Opfer verbrannte."

L.aw_brn3_title = "Pyromanische Brennerei"
L.aw_brn3_text = "hat sie alle verbrannt, aber hat nun keine Brandgranaten mehr! Wie will er die Lage meistern!?"

L.aw_fnd1_title = "Gerichtsmediziner"
L.aw_fnd1_text = "fand {num} Leichen, die in der Gegend herumlagen."

L.aw_fnd2_title = "Schnapp sie dir alle"
L.aw_fnd2_text = "fand {num} Leichen für seine Sammlung."

L.aw_fnd3_title = "Geruch des Todes"
L.aw_fnd3_text = "stolperte immer wieder über irgendwelche Leichen. {num} Mal diese Runde."

L.aw_crd1_title = "Leichenfledderer"
L.aw_crd1_text = "schnorrte sich {num} zurückgelassene Credits von Leichen zusammen."

L.aw_tod1_title = "Teuer erkaufter Sieg"
L.aw_tod1_text = "starb nur wenige Sekunden bevor sein Team die Runde gewann."

L.aw_tod2_title = "Ich hasse dieses Spiel"
L.aw_tod2_text = "starb direkt am Anfang der Runde."

-- New and modified pieces of text are placed below this point, marked with the
-- version in which they were added, to make updating translations easier.

-- v24
L.drop_no_ammo = "Du hast zu wenig Munition im Magazin, um eine Munitionskiste fallenzulassen."

-- 2015-05-25
L.hat_retrieve = "Du hast den Hut eines Detektivs aufgehoben."

-- 2017-09-03
L.sb_sortby = "Sortiere nach:"

-- 2018-07-24
L.equip_tooltip_main = "Ausrüstungsmenü"
L.equip_tooltip_radar = "Radar-Einstellungen"
L.equip_tooltip_disguise = "Tarnungs-Einstellungen"
L.equip_tooltip_radio = "Radio-Einstellungen"
L.equip_tooltip_reroll = "Items neu ausrollen"
L.equip_tooltip_xfer = "Credits transferieren"

L.confgrenade_name = "Discombobulator"
L.polter_name = "Poltergeist"
L.stungun_name = "UMP Prototype"

L.knife_instant = "INSTANT KILL"

L.binoc_zoom_level = "Zoom Stufe"
L.binoc_body = "LEICHE GEFUNDEN"

L.idle_popup_title = "Untätig"

-- 2019-01-31
L.create_own_shop = "Erstelle einen eigenen Shop"
L.shop_link = "Verlinke mit"
L.shop_disabled = "Shop deaktivieren"
L.shop_default = "Standart-Shop verwenden"

-- 2019-05-05
L.reroll_name = "Reroll"
L.reroll_menutitle = "Items neu ausrollen"
L.reroll_no_credits = "Du brauchst {amount} Credits zum neu ausrollen!"
L.reroll_button = "Reroll"
L.reroll_help = "Bekomme neu zufällige Items für {amount} Credits!"

--2019-05-06
L.equip_not_alive = "Du kannst alle verfügbaren Items sehen, wenn du eine Rolle auf der rechten Seite auswählst. Denk dran, du kannst zu jeder Zeit Favoriten hinzufügen!"

-- 2019-06-27
L.shop_editor_title = "Shop Editor"
L.shop_edit_items_weapong = "Bearbeite Gegenstände / Waffen"
L.shop_edit = "Bearbeite Shops"
L.shop_settings = "Einstellungen"
L.shop_select_role = "Wähle Role"
L.shop_edit_items = "Bearbeite Gegenstände"
L.shop_edit_shop = "Bearbeite Shop"
L.shop_create_shop = "Erstelle eigenen Shop"
L.shop_selected = "{role} ausgewählt"
L.shop_settings_desc = "Ändere die Werte, um den Random-Shop anzupassen. Vergiss nicht am Ende zu speichern!"

L.bindings_new = "Neue Tastenbelegung für {name}: {key}"

L.hud_default_failed = "Es ist fehlgeschlagen {hudname} als Standard HUD zu setzen. Bist du Admin und existiert dieses HUD überhaupt?"
L.hud_forced_failed = "Es ist fehlgeschlagen {hudname} zu erzwingen. Bist du Admin und existiert dieses HUD überhaupt?"
L.hud_restricted_failed = "Es ist fehlgeschlagen {hudname} zu beschränken. Bist du Admin?"

L.shop_role_select = "Wähle eine Rolle"
L.shop_role_selected = "Der {role} Shop wurde gewählt!"
L.shop_search = "Suche"

L.spec_help = "Klicke, um Spielern zu zuschauen, oder drücke {usekey} auf ein physikalisches Objekt, um die Kontrolle zu erhalten."
L.spec_help2 = "Zum Verlassen des Zuschauer-Modus öffne das Menü mit {helpkey}, navigiere in 'Gameplay' und schalte den Zuschauermodus um."

-- 2019-10-10
L.drop_ammo_prevented = "Etwas hindert dich daran deine Munition fallenzulassen."

-- 2019-10-28
L.target_c4 = "Drücke [{usekey}] um C4 Menü zu öffnen"
L.target_c4_armed = "Drücke [{usekey}] um C4 zu entschärfen"
L.target_c4_armed_defuser = "Drücke [{usekey}] um Entschärfer zu verwenden"
L.target_c4_not_disarmable = "Du kannst kein C4 eines lebenden Teamkollegen entschärfen"
L.c4_short_desc = "Etwas sehr explosives"

L.target_pickup = "Drücke [{usekey}] um aufzuheben"
L.target_slot_info = "Inventarplatz: {slot}"
L.target_pickup_weapon = "Drücke [{usekey}] um Waffe aufzuheben"
L.target_switch_weapon = "Drücke [{usekey}] um mit aktueller Waffe zu tauschen"
L.target_pickup_weapon_hidden = ", drücke [{usekey} + {walkkey}] für verstecktes Aufheben"
L.target_switch_weapon_hidden = ", drücke [{usekey} + {walkkey}] für verstecktes Tauschen"
L.target_switch_weapon_nospace = "Es ist kein Invetarplatz frei für diese Waffe"
L.target_switch_drop_weapon_info = "Lasse {name} aus Inventarplatz {slot} fallen"
L.target_switch_drop_weapon_info_noslot = "In Inventatplatz {slot} ist keine wegwerfbare Waffe"

L.corpse_searched_by_detective = "Diese Leiche wurde von einem Detektiv untersucht"
L.corpse_too_far_away = "Leiche zu weit weg zum Untersuchen."

L.radio_pickup_wrong_team = "Du kannst nicht das Radio eines anderen Teams aufheben."
L.radio_short_desc = "Waffengeräusche sind Musik für mich"

L.hstation_subtitle = "Drücke [{usekey}] um Leben zu regenerieren."
L.hstation_charge = "Verbleibende Ladung der Gesundheitsstation: {charge}"
L.hstation_empty = "Es ist keine Ladung mehr in der Gesundheitsstation enthalten"
L.hstation_maxhealth = "Du hast bereits dein maximales Leben erreicht"
L.hstation_short_desc = "Die Gesundheitsstation lädt sich langsam über die Zeit wieder auf"

-- 2019-11-03
L.vis_short_desc = "Visualisiert den Tatort, wenn das Opfer an einer Schusswunde starb"
L.corpse_binoculars = "Drücke [{key}] um Leiche mit Fernglas zu untersuchen."
L.binoc_progress = "Durchsuchungsfortschritt: {progress}%"

L.pickup_no_room = "Du hast keinen Platz für diese Waffe in deinem Inventar"
L.pickup_fail = "Du kannst diese Waffe nicht aufheben"
L.pickup_pending = "Du hebst bereits eine Waffe auf, warte bis du sie erhältst"

--2020-01-07
L.tbut_help_admin = "Bearbeite Knopfeinstellungen"
L.tbut_role_toggle = "[{walkkey} + {usekey}] zum Umschalten dieses Knopfes für {role}"
L.tbut_role_config = "Rolle: {current}"
L.tbut_team_toggle = "[SHIFT + {walkkey} + {usekey}] zum Umschalten dieses Knopfes für Team {team}"
L.tbut_team_config = "Team: {current}"
L.tbut_current_config = "Aktuelle Einstellung:"
L.tbut_intended_config = "Voreinstellung des Maperstellers:"
L.tbut_admin_mode_only = "Nur sichtbar für dich, da du ein Admin bist und '{cv}' auf '1' gesetzt ist"
L.tbut_allow = "Erlaubt"
L.tbut_prohib = "Verboten"
L.tbut_default = "Standard"

-- 2020-02-09
L.name_door = "Tür"
L.door_open = "Drücke [{usekey}] um Tür zu öffnen."
L.door_close = "Drücke [{usekey}] um Tür zu schließen."
L.door_locked = "Diese Tür ist verschlossen"

-- 2020-02-11
L.automoved_to_spec = "(AUTOMATISCHE NACHRICHT) Ich wurde in das Zuschauerteam geschoben, da ich untätig/AFK war."
L.mute_team = "{team} stummgestellt."

-- 2020-02-16
L.door_auto_closes = "Diese Tür schließt automatisch"
L.door_open_touch = "Laufe gegen die Tür um sie zu öffnen."
L.door_open_touch_and_use = "Laufe gegen die Tür oder drücke [{usekey}] um Tür zu öffnen."
L.hud_health = "Leben"

-- 2020-03-09
L.help_title = "Hilfe und Einstellungen"

L.menu_changelog_title = "Änderungsverlauf"
L.menu_guide_title = "TTT2 Guide"
L.menu_bindings_title = "Tastenbelegungen"
L.menu_language_title = "Sprache"
L.menu_appearance_title = "Aussehen"
L.menu_gameplay_title = "Gameplay"
L.menu_addons_title = "Erweiterungen"
L.menu_legacy_title = "Alte Erweiterungen"
L.menu_administration_title = "Administration"
L.menu_equipment_title = "Bearbeite Ausrüstung"
L.menu_shops_title = "Bearbeite Shops"

L.menu_changelog_description = "Eine Liste von Fixes und Verbesserungen in den vergangenen Versionen"
L.menu_guide_description = "Hilft dir mit TTT2 zurecht zu kommen und erklärt einiges über Gamplay, Rollen und anderes"
L.menu_bindings_description = "Belege Tasten von TTT2 und seinen Erweiterungen nach deinem Geschmack"
L.menu_language_description = "Stelle die Sprache des Spiels ein"
L.menu_appearance_description = "Verändere die Erscheinung und Performance der UI"
L.menu_gameplay_description = "Vermeide Rollen und verändere ein paar andere Funktionen"
L.menu_addons_description = "Stelle lokale Addons nach deinem Geschmack ein"
L.menu_legacy_description = "Einstellungen von alten TTT Erweiterungen, die zum neuen UI-System konvertiert werden sollten"
L.menu_administration_description = "Allgemeine Einstellungen für HUDs, Ausrüstung und Shops"
L.menu_equipment_description = "Stelle Credits, Limitierungen, Verfügbarkeiten und anderes ein"
L.menu_shops_description = "Entferne oder füge Shops zu Rollen hinzu und definiere die Ausrüstung in diesen"

L.submenu_guide_gameplay_title = "Gameplay"
L.submenu_guide_roles_title = "Rollen"
L.submenu_guide_equipment_title = "Ausrüstung"

L.submenu_bindings_bindings_title = "Tastenbelegungen"

L.submenu_language_language_title = "Sprache"

L.submenu_appearance_general_title = "Allgemein"
L.submenu_appearance_hudswitcher_title = "HUD Wechsler"
L.submenu_appearance_vskin_title = "VSkin"
L.submenu_appearance_targetid_title = "TargetID"
L.submenu_appearance_shop_title = "Shop Einstellungen"
L.submenu_appearance_crosshair_title = "Fadenkreuz"
L.submenu_appearance_dmgindicator_title = "Schadensanzeige"
L.submenu_appearance_performance_title = "Performance"
L.submenu_appearance_interface_title = "Interface"
L.submenu_appearance_miscellaneous_title = "Verschiedenes"

L.submenu_gameplay_general_title = "Allgemein"
L.submenu_gameplay_avoidroles_title = "Vermeide Rollen"

L.submenu_administration_hud_title = "HUD Einstellungen"
L.submenu_administration_randomshop_title = "Zufälliger Shop"

L.help_color_desc = "Wenn diese Einstellung aktiviert ist, kann eine globale Farbe ausgesucht werden, die für targetID Umrandung und das Fadenkreuz verwendet wird."
L.help_scale_factor = "Dieser Skalierungsfaktor beeinflusst alle UI Elmente (HUD, VGUI, targetID). Er wird automatisch aktualisiert, wenn die Auflösung sich ändert. Das Ändern dieses Wertes setzt das HUD zurück!"
L.help_hud_game_reload = "Das HUD ist zur Zeit nicht verfügbar. Das Spiel muss neu geladen werden."
L.help_hud_special_settings = "Dies sind die HUD spezifischen Einstellungen."
L.help_vskin_info = "VSkin (vgui skin) ist der Skin für alle Menü Elemente wie dieses hier. Skins können mit einem einfachen Lua-Skript erstellt werden und beeinflussen die Farben, sowie einige Größenparameter."
L.help_targetid_info = "TargetID sind die Informationen, die in der Mitte des Bildschirmes angezeigt werden, wenn man eine Entity anschaut. Eine feste Farbe kann in den allgemeinen Einstellungen eingestellt werden."
L.help_hud_default_desc = "Setze das Standard HUD für alle Spieler. Spieler, die bisher noch kein HUD selber ausgesucht haben, werden dieses standardmäßig erhalten. Dies beeinflusst nicht die Einstellungen von Spielern, die bereits ein HUD gesetzt haben."
L.help_hud_forced_desc = "Erzwinge ein HUD für alle Spieler. Dies deaktiviert die HUD Auswahl für alle Spieler."
L.help_hud_enabled_desc = "Aktiviere/Deaktiviere HUDs um ihre Auswahl zu limitieren."
L.help_damage_indicator_desc = "Die Schadensanzeige ist der Bildschirmeffekt, den man sieht, wenn man Schaden erhält. Um ein neues Thema hinzuzufügen muss ein PNG in 'materials/vgui/ttt/damageindicator/themes/' platziert werden."
L.help_shop_key_desc = "Soll der Shop geöffnet/geschlossen werden anstelle der Punkteverteilung während der Vorbereitungs-/Endzeit?"

L.label_menu_menu = "MENU"
L.label_menu_admin_spacer = "Admin Bereich (nicht sichbar für normale Benutzer)"
L.label_language_set = "Sprache auswählen"
L.label_global_color_enable = "Aktiviere globale Farbe"
L.label_global_color = "Globale Farbe"
L.label_global_scale_factor = "Globaler Skalierungsfaktor"
L.label_hud_select = "Wähle HUD"
L.label_vskin_select = "Wähle VSkin"
L.label_blur_enable = "Aktiviere VSkin Hintergrundunschärfe"
L.label_color_enable = "Aktiviere VSkin Hintergrundfarbe"
L.label_minimal_targetid = "Minimale Ziel ID unter dem Fadenkreuz (kein Karmatext, Hinweise, etc.)"
L.label_shop_always_show = "Zeige immer den Shop"
L.label_shop_double_click_buy = "Kaufe ein Item im Shop, indem du es doppelt anklickst"
L.label_shop_num_col = "Anzahl der Spalten"
L.label_shop_num_row = "Anzahl der Zeilen"
L.label_shop_item_size = "Icon Größe"
L.label_shop_show_slot = "Zeige Slot Symbol"
L.label_shop_show_custom = "Zeige Symbol für benutzerdefiniertes Element"
L.label_shop_show_fav = "Zeige Symbol für favorisiertes Element"
L.label_crosshair_enable = "Aktiviere Fadenkreuz"
L.label_crosshair_gap_enable = "Aktiviere benutzerdefinierte Fadenkreuz-Lücke"
L.label_crosshair_gap = "Benutzerdefinierte Fadenkreuz-Lücke"
L.label_crosshair_opacity = "Transparenz des Fadenkreuzes"
L.label_crosshair_ironsight_opacity = "Durchlässigkeit des Fadenkreuz-Visiers"
L.label_crosshair_size = "Fadenkreuz Größe"
L.label_crosshair_thickness = "Fadenkreuz Dicke"
L.label_crosshair_thickness_outline = "Dicke der Umrandung des Fadenkreuzes"
L.label_crosshair_static_enable = "Aktiviere statisches Fadenkreuz"
L.label_crosshair_dot_enable = "Aktiviere Fadenkreuz-Punkt"
L.label_crosshair_lines_enable = "Aktiviere Fadenkreuz-Linien"
L.label_crosshair_scale_enable = "Aktiviere die Skalierung des Fadenkreuzes"
L.label_crosshair_ironsight_low_enabled = "Senke Waffe beim Zielen durch Kimme und Korn"
L.label_damage_indicator_enable = "Aktiviere Schadensanzeige"
L.label_damage_indicator_mode = "Schadensanzeigen Thema"
L.label_damage_indicator_duration = "Sekunden, die die Schadensanzeige sichtbar ist"
L.label_damage_indicator_maxdamage = "Erlittener Schaden für maximale Sichtbarkeit"
L.label_damage_indicator_maxalpha = "Maximaler Transparenzwert"
L.label_performance_halo_enable = "Zeichne eine Linie um einige Entities, die man anschaut"
L.label_performance_spec_outline_enable = "Aktiviere Zuschauerumrandungen"
L.label_performance_ohicon_enable = "Aktiviere Rollenicons über den Köpfen"
L.label_interface_tips_enable = "Zeige Tipps zum Spiel während des Zuschauens am unteren Bildschirmrand"
L.label_interface_popup = "Dauer des Popups mit Infos am Anfang einer Runde"
L.label_interface_fastsw_menu = "Aktiviert das Waffenwechselmenü, selbst wenn der schnelle Waffenwechsel aktiv ist"
L.label_inferface_wswitch_hide_enable = "Aktiviere das automatische Schließen des Waffenwechselmenüs"
L.label_inferface_scues_enable = "Spiele einen Ton ab, wenn eine Runde beginnt oder endet"
L.label_gameplay_specmode = "Nur-Zuschauer-Modus (bleibe immer Zuschauer)"
L.label_gameplay_fastsw = "Schneller Waffenwechsel"
L.label_gameplay_hold_aim = "Aktiviere Halten zum Anvisieren"
L.label_gameplay_mute = "Stelle lebende Spieler stumm, wenn du tot bist"
L.label_gameplay_dtsprint_enable = "Aktiviere Double-Tap Sprinten"
L.label_gameplay_dtsprint_anykey = "Setze Double-Tap Sprinten fort, bis du stehen bleibst"
L.label_hud_default = "Standard HUD"
L.label_hud_force = "Erzwungenes HUD"

L.label_bind_weaponswitch = "Waffe aufheben"
L.label_bind_sprint = "Sprinten"
L.label_bind_voice = "Globaler Sprachchat"
L.label_bind_voice_team = "Team Sprachchat"

L.label_hud_basecolor = "Grundfarbe"

L.label_menu_not_populated = "Dieses Untermenü enthält keinen Inhalt."

L.header_bindings_ttt2 = "TTT2 Tastenbelegungen"
L.header_bindings_other = "Andere Tastenbelegungen"
L.header_language = "Spracheinstellungen"
L.header_global_color = "Wähle globale Farbe"
L.header_hud_select = "Wähle ein HUD"
L.header_hud_customize = "Passe das HUD an"
L.header_vskin_select = "Wähle und passe den VSkin an"
L.header_targetid = "TargetID Einstellungen"
L.header_shop_settings = "Ausrüstungs Shop Einstellungen"
L.header_shop_layout = "Layout der Elementliste"
L.header_shop_marker = "Element Symbol Einstellungen"
L.header_crosshair_settings = "Fadenkreuz Einstellungen"
L.header_damage_indicator = "Schadensanzeigen Einstellungen"
L.header_performance_settings = "Performance Einstellungen"
L.header_interface_settings = "Anzeigeeinstellungen"
L.header_gameplay_settings = "Spieleinstellungen"
L.header_roleselection = "Aktierung Rollenzuweisung"
L.header_hud_administration = "Wähle Standard-HUD und Erzwungenes-HUD"
L.header_hud_enabled = "De-/aktiviere HUDs"

L.button_menu_back = "Zurück"
L.button_none = "Nichts"
L.button_press_key = "Drücke eine Taste"
L.button_save = "Speichern"
L.button_reset = "Zurücksetzen"
L.button_close = "Schließen"
L.button_hud_editor = "HUD Editor"

-- 2020-04-20
L.item_speedrun = "Schnelllauf"
L.item_speedrun_desc = [[Macht dich 50% schneller!]]
L.item_no_explosion_damage = "Kein Explosionsschaden"
L.item_no_explosion_damage_desc = [[Macht dich immun für Explosionsschaden.]]
L.item_no_fall_damage = "Kein Fallschaden"
L.item_no_fall_damage_desc = [[Macht dich immun für Fallschaden.]]
L.item_no_fire_damage = "Kein Feuerschaden"
L.item_no_fire_damage_desc = [[Macht dich immun für Deuerschaden.]]
L.item_no_hazard_damage = "Kein Gefahrgutschaden"
L.item_no_hazard_damage_desc = [[Macht dich immunn für Gefahrgutschaden, wie Gift, Strahlung und Säure.]]
L.item_no_energy_damage = "Kein Energieschaden"
L.item_no_energy_damage_desc = [[Macht dich immun für Energieschaden, wie Laser, Plasma und Blitze.]]
L.item_no_prop_damage = "Kein Objektschaden"
L.item_no_prop_damage_desc = [[Macht dich immun fpr Objektschaden.]]
L.item_no_drown_damage = "Kein Ertrinkungsschaden"
L.item_no_drown_damage_desc = [[Macht dich immun für Ertrinkungsschaden.]]

-- 2020-04-21
L.dna_tid_possible = "Scan möglich"
L.dna_tid_impossible = "Scan unmöglich"
L.dna_screen_ready = "Keine DNA"
L.dna_screen_match = "Treffer"

-- 2020-04-30
L.message_revival_canceled = "Wiederbelebung abgebrochen."
L.message_revival_failed = "Wiederbelebung fehlgeschlagen."
L.message_revival_failed_missing_body = "Du wurdest nicht wiederbelebt, da deine Leiche nicht mehr existiert."
L.hud_revival_title = "Zeit bis zur Wiederbelebung:"
L.hud_revival_time = "{time}s"

-- 2020-05-03
L.door_destructible = "Tür ist zerstörbar ({health}HP)"

-- 2020-05-28
L.confirm_detective_only = "Nur Detektive können Leichen bestätigen"
L.inspect_detective_only = "Nur Detektive können Leichen untersuchen"
L.corpse_hint_no_inspect = "Nur ein Detektiv kann diesen Körper untersuchen."
L.corpse_hint_inspect_only = "Drücke [{usekey}] zum Durchsuchen. Nur Detektive können diesen Körper bestätigen."
L.corpse_hint_inspect_only_credits = "Drücke [{usekey}] zum Erhalten der Credits. Nur ein Detektiv kann diesen Körper untersuchen."

-- 2020-06-04
L.label_bind_disguiser = "Tarnung umschalten"

-- 2020-06-24
L.dna_help_primary = "Entnehme eine DNA-Probe"
L.dna_help_secondary = "Wechsel den DNA Slot"
L.dna_help_reload = "Lösche eine Probe"

L.binoc_help_pri = "Identifiziere einen Körper."
L.binoc_help_sec = "Ändere Zoom-Level."

L.vis_help_pri = "Lass das aktivierte Gerät fallen."

L.decoy_help_pri = "Platziere die Attrappe."

-- 2020-08-07
L.pickup_error_spec = "Du kannst eine Waffe als Zuschauer nicht aufheben."
L.pickup_error_owns = "Du kannst diese Waffe nicht aufheben, weil du die gleiche Waffe bereits trägst."
L.pickup_error_noslot = "Du verfügst über keinen freien Slot, um diese Waffe aufzuheben."

-- 2020-11-02
L.lang_server_default = "Server Standard"
L.help_lang_info = [[
Diese Übersetzung ist {coverage}% vollständig, wenn man die englische Übersetzung als Referenz betrachtet.

Beachte, dass diese Übersetzungen Communitybasiert sind. Hilf mit, wenn Du Fehler oder fehlende Übersetzungen findest.]]

-- 2021-04-13
L.title_score_info = "Rundenendeninfo"
L.title_score_events = "Ereignistimeline"

L.label_bind_clscore = "Öffne Rundenendeninfo"
L.title_player_score = "Punkte von {player}:"

L.label_show_events = "Zeige Ereignisse von"
L.button_show_events_you = "Dir"
L.button_show_events_global = "Global"
L.label_show_roles = "Zeige Rollenverteilung vom"
L.button_show_roles_begin = "Rundenbegin"
L.button_show_roles_end = "Rundenende"

L.hilite_win_traitors = "TEAM VERRÄTER GEWANN"
L.hilite_win_innocents = "TEAM UNSCHULDIGE GEWANN"
L.hilite_win_tie = "UNENTSCHIEDEN"
L.hilite_win_time = "ZEIT VORBEI"

L.tooltip_karma_gained = "Diese Runde bekommenes Karma:"
L.tooltip_score_gained = "Diese Runde bekommene Punkte:"
L.tooltip_roles_time = "Rollen in der Runde:"

L.tooltip_finish_score_alive_teammates = "Lebende Teammitglieder: {score}"
L.tooltip_finish_score_alive_all = "Lebende Spieler: {score}"
L.tooltip_finish_score_timelimit = "Zeit vorbei: {score}"
L.tooltip_finish_score_dead_enemies = "Tote Gegner: {score}"
L.tooltip_kill_score = "Mord: {score}"
L.tooltip_bodyfound_score = "Leichenfindung: {score}"

L.finish_score_alive_teammates = "Lebende Teammitglieder:"
L.finish_score_alive_all = "Lebende Spieler:"
L.finish_score_timelimit = "Zeit vorbei:"
L.finish_score_dead_enemies = "Tote Gegner:"
L.kill_score = "Mord:"
L.bodyfound_score = "Leichenfindung:"

L.title_event_bodyfound = "Eine Leiche wurde gefunden"
L.title_event_c4_disarm = "Eine C4 Ladung wurde entschärft"
L.title_event_c4_explode = "Eine C4 Ladung ist explodiert"
L.title_event_c4_plant = "Eine C4 Ladung wurde platziert"
L.title_event_creditfound = "Ausrüstungspunkte wurden gefunden"
L.title_event_finish = "Die Runde ist vorbei"
L.title_event_game = "Eine neue Runde hat begonnen"
L.title_event_kill = "Ein Spieler wurde umgebracht"
L.title_event_respawn = "Ein Spieler wurde wiederbelebt"
L.title_event_rolechange = "Ein Spieler hat seine Rolle oder sein Team geändert"
L.title_event_selected = "Die Rollen wurden verteilt"
L.title_event_spawn = "Ein Spieler ist erschienen"

L.desc_event_bodyfound = "{finder} ({firole} / {fiteam}) hat die Leiche von {found} ({forole} / {foteam}) gefunden. Sie hatte {credits} Ausrüstungspunkt(e) in sich."
L.desc_event_bodyfound_headshot = "Der tote Spieler wurde durch einen Kopfschuss ermordet."
L.desc_event_c4_disarm_success = "{disarmer} ({drole} / {dteam}) hat erfolgreich die C4 Ladung von {owner} ({orole} / {oteam}) entschärft."
L.desc_event_c4_disarm_failed = "{disarmer} ({drole} / {dteam}) hat versucht die C4 Ladung von {owner} ({orole} / {oteam}) zu entschärfen. Es ist fehlgeschlagen."
L.desc_event_c4_explode = "Die C4 Ladung von {owner} ({role} / {team}) ist explodiert."
L.desc_event_c4_plant = "{owner} ({role} / {team}) hat eine explosive C4 Ladung platziert."
L.desc_event_creditfound = "{finder} ({firole} / {fiteam}) hat {credits} Ausrüstungspunkt(e) in der Leiche von {found} ({forole} / {foteam}) gefunden."
L.desc_event_finish = "Die Runde dauerte {minutes}:{seconds}. Am Ende waren {alive} Spieler am Leben."
L.desc_event_game = "Eine neue Runde hat begonnen."
L.desc_event_respawn = "{player} wurde wiederbelebt."
L.desc_event_rolechange = "{player} hat seine Rolle/Team von {orole} ({oteam}) zu {nrole} ({nteam}) geändert."
L.desc_event_selected = "Die Rollen und Teams wurden für alle {amount} Spieler verteilt."
L.desc_event_spawn = "{player} ist erschienen."

-- Name of a trap that killed us that has not been named by the mapper
L.trap_something = "etwas"

-- Kill events
L.desc_event_kill_suicide = "Es war Selbstmord."
L.desc_event_kill_team = "Es war ein Teammord."

L.desc_event_kill_blowup = "{victim} ({vrole} / {vteam}) jagte sich selbst in die Luft."
L.desc_event_kill_blowup_trap = "{victim} ({vrole} / {vteam}) wurde durch {trap} in die Luft gejagt."

L.desc_event_kill_tele_self = "{victim} ({vrole} / {vteam}) telefragged sich selbst."
L.desc_event_kill_sui = "{victim} ({vrole} / {vteam}) hielt es nicht mehr aus und brachte sich um."
L.desc_event_kill_sui_using = "{victim} ({vrole} / {vteam}) brachte sich mit {tool} um."

L.desc_event_kill_fall = "{victim} ({vrole} / {vteam}) fiel in den Tod."
L.desc_event_kill_fall_pushed = "{victim} ({vrole} / {vteam}) fiel in den Tod nachdem {attacker} ihn schuppste."
L.desc_event_kill_fall_pushed_using = "{victim} ({vrole} / {vteam}) fiel in den Tod nachdem {attacker} ({arole} / {ateam}) {trap} benutzte, um ihn zu schubsen."

L.desc_event_kill_shot = "{victim} ({vrole} / {vteam}) wurde von {attacker} erschossen."
L.desc_event_kill_shot_using = "{victim} ({vrole} / {vteam}) wurde von {attacker} ({arole} / {ateam}) mit einer/m {weapon} erschossen."

L.desc_event_kill_drown = "{victim} ({vrole} / {vteam}) wurde von {attacker} ertränkt."
L.desc_event_kill_drown_using = "{victim} ({vrole} / {vteam}) wurde durch {trap} von {attacker} ({arole} / {ateam}) ertränkt."

L.desc_event_kill_boom = "{victim} ({vrole} / {vteam}) wurde von {attacker} gesprengt."
L.desc_event_kill_boom_using = "{victim} ({vrole} / {vteam}) wurde von {attacker} ({arole} / {ateam}) durch {trap} gesprengt."

L.desc_event_kill_burn = "{victim} ({vrole} / {vteam}) wurde von {attacker} verbrannt."
L.desc_event_kill_burn_using = "{victim} ({vrole} / {vteam}) wurde durch {trap} von {attacker} ({arole} / {ateam}) verbrannt."

L.desc_event_kill_club = "{victim} ({vrole} / {vteam}) wurde von {attacker} zu Tode geprügelt."
L.desc_event_kill_club_using = "{victim} ({vrole} / {vteam}) wurde von {attacker} ({arole} / {ateam}) durch/mit {trap} zu Tode geprügelt."

L.desc_event_kill_slash = "{victim} ({vrole} / {vteam}) wurde von {attacker} erstochen."
L.desc_event_kill_slash_using = "{victim} ({vrole} / {vteam}) wurde von {attacker} ({arole} / {ateam}) durch/mit {trap} aufgeschlitzt."

L.desc_event_kill_tele = "{victim} ({vrole} / {vteam}) wurde von {attacker} telefragged."
L.desc_event_kill_tele_using = "{victim} ({vrole} / {vteam}) wurde atomisiert durch {trap} von {attacker} ({arole} / {ateam})."

L.desc_event_kill_goomba = "{victim} ({vrole} / {vteam}) wurde unter der Masse von {attacker} ({arole} / {ateam}) zerquetscht."

L.desc_event_kill_crush = "{victim} ({vrole} / {vteam}) wurde von {attacker} zerquetscht."
L.desc_event_kill_crush_using = "{victim} ({vrole} / {vteam}) wurde durch {trap} von {attacker} ({arole} / {ateam}) zerquetscht."

L.desc_event_kill_other = "{victim} ({vrole} / {vteam}) wurde von {attacker} getötet."
L.desc_event_kill_other_using = "{victim} ({vrole} / {vteam}) wurde von {attacker} ({arole} / {ateam}) durch {trap} getötet."

-- 2021-04-20
L.none = "Keine Rolle"

-- 2021-04-24
L.karma_teamkill_tooltip = "Teamkills"
L.karma_teamhurt_tooltip = "Teamschaden"
L.karma_enemykill_tooltip = "Kills"
L.karma_enemyhurt_tooltip = "Schaden"
L.karma_cleanround_tooltip = "Saubere Runde"
L.karma_roundheal_tooltip = "Rundenheilung"
L.karma_unknown_tooltip = "Unbekannt"

-- 2021-05-07
L.header_random_shop_administration = "Zufalls-Shop"
L.header_random_shop_value_administration = "Balance Einstellungen"

L.shopeditor_name_random_shops = "Aktiviere Zufalls-Shop"
L.shopeditor_desc_random_shops = [[Zufalls-Shops geben jedem Spieler eine zufällige Menge an Ausrüstung.
Team-Shops zwingen alle Spieler aus einem Team zu ein und demselben Shopinhalt.
Auswürfeln erlaubt es ein gegebenes Set für Credits durch ein neues Zufallsset auszutauschen.]]
L.shopeditor_name_random_shop_items = "Anzahl zufälliger Equipments"
L.shopeditor_desc_random_shop_items = "Dies enthält Equipments, welche mit \"Nicht zufällig\" (immer enthalten) markiert sind. Also wähle die Anzahl hoch genug, damit nicht nur solches Equipment im Shop landet."
L.shopeditor_name_random_team_shops = "Aktiviere Team-Shops"
L.shopeditor_name_random_shop_reroll = "Aktiviere Möglichkeit Shop neu auszuwürfeln"
L.shopeditor_name_random_shop_reroll_cost = "Kosten pro Auswürfeln"
L.shopeditor_name_random_shop_reroll_per_buy = "Automatisches Auswürfeln nach jedem Kauf"

-- 2021-06-04
L.header_equipment_setup = "Equipment Einstellungen"
L.header_equipment_value_setup = "Balance Einstellungen"

L.itemeditor_name_not_buyable = "Equipment kaufbar"
L.itemeditor_desc_not_buyable = "Das Equipment ist in keinem Shop zu finden, wenn dies deaktiviert ist. Rollen, die dieses Equipment als Standardausrüstung bekommen sind davon jedoch nicht betroffen."
L.itemeditor_name_not_random = "Immer im Shop verfügbar"
L.itemeditor_desc_not_random = "Wenn aktiviert, dann ist das Equipment immer im Shop verfügbar. Das ist dann relevant, wenn der Zufalls-Shop verwendet wird. Dabei belegt dieses Equipment einen der verfügbaren Zufallsslots."
L.itemeditor_name_global_limited = "Global limitierte Anzahl"
L.itemeditor_desc_global_limited = "Wenn equipment eine global limitierte Anzahl hat, dann kann es auf dem Server nur ein mal pro Runde gekauft werden."
L.itemeditor_name_team_limited = "Team limitierte Anzahl"
L.itemeditor_desc_team_limited = "Wenn equipment eine global limitierte Anzahl hat, dann kann es pro Team nur ein mal pro Runde gekauft werden."
L.itemeditor_name_player_limited = "Spieler limitierte Anzahl"
L.itemeditor_desc_player_limited = "Wenn equipment eine global limitierte Anzahl hat, dann kann es pro Spieler nur ein mal pro Runde gekauft werden.."
L.itemeditor_name_min_players = "Mindestspielerzahl für Freischaltung"
L.itemeditor_name_credits = "Kosten in Credits"

-- 2021-06-08
L.equip_not_added = "nicht enthalten"
L.equip_added = "enthalten"
L.equip_inherit_added = "enthalten (geerbt)"
L.equip_inherit_removed = "entfernt (geerbt)"

-- 2021-06-09
L.layering_not_layered = "Ohne Ebene"
L.layering_layer = "Ebene {layer}"
L.header_rolelayering_role = "{role}ebene"
L.header_rolelayering_baserole = "Grundrollenebene"
L.submenu_administration_rolelayering_title = "Rollenebenen"
L.header_rolelayering_info = "Rollenebeneninformationen"
L.help_rolelayering_roleselection = "Die Rollenverteilung wird in zwei Durchgängen gemacht. Im ersten Durchgag werden die Grundrollen verteilt. Grundrollen sind Unschuldige, Verräter und die, die unten in der 'Grundrollenebene' zu sehen sind. Im zweioten Durchgang werden diese Grundrollen dann zu Unterrollen hochgestuft."
L.help_rolelayering_layers = "Von jeder Ebene wird immer nur eine Rolle ausgewählt. Zuerst werden die numerierten Ebenen durchlaufen, startend bei Ebene 1, bis die letzte Ebene erreicht wird, oder es keine Grundrollen zum Hochstufen mehr gibt. Was auch immer zuerst auftritt. Sind noch hochstufbare Grundrollen am Ende übrig, werden Rollen aus der Gruppe ohne Ebene verwendet."
L.scoreboard_voice_tooltip = "Scrolle um die Lautstärke zu ändern"

--2021-06-15
L.header_shop_linker = "Einstellungen"
L.label_shop_linker_set = "Wähle Shopart aus:"

--2021-08-18
L.xfer_team_indicator = "Team"
