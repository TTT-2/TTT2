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

L.round_traitors_one = "Verräter, du bist alleine."
L.round_traitors_more = "Verräter, dies sind die Namen deiner Verbündeten: {names}"

L.win_time = "Die Zeit ist abgelaufen. Die Verräter haben verloren."
L.win_traitors = "Die Verräter haben gewonnen!"
L.win_innocents = "Die Unschuldigen haben gewonnen!"
L.win_nones = "Die Bienen haben gewonnen! (Es ist ein Unentschieden)"
L.win_showreport = "Schauen wir uns den Rundenbericht die nächste(n) {num} Sekunde(n) an."

L.limit_round = "Rundenlimit erreicht. Die nächste Map wird bald geladen."
L.limit_time = "Zeitlimit erreicht. Die nächste Map wird bald geladen."
L.limit_left_session_mode_1 = "{num} Runde(n) oder {time} Minute(n) verbleibend bis die Map gewechselt wird."
L.limit_left_session_mode_2 = "{time} Minute(n) verbleibend bis die Map gewechselt wird."
L.limit_left_session_mode_3 = "{num} Runde(n) verbleibend bis die Map gewechselt wird."

-- Credit awards
L.credit_all = "Deinem Team wurde(n) {num} Ausrüstungspunkt(e) für eure Leistung gegeben."
L.credit_kill = "Dir wurde(n) {num} Ausrüstungspunkt(e) gegeben, da du einen {role} getötet hast."

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

L.body_call = "{player} rief einen Detektiv zum Körper von {victim}!"
L.body_call_error = "Du musst erst den Tod dieses Spielers bestätigen, bevor du einen Detektiv rufen kannst!"

L.body_burning = "Autsch! Diese Leiche brennt lichterloh!"
L.body_credits = "Du hast {num} Ausrüstungspunkt(e) an diesem Körper gefunden!"

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
L.equip_cost = "Du hast {num} Ausrüstungspunkt(e) übrig."
L.equip_help_cost = "Jedes Ausrüstungsteil, das du kaufst, kostet 1 Ausrüstungspunkt."

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
L.xfer_menutitle = "Ausrüstungspunkte transferieren"
L.xfer_send = "Sende einen Ausrüstungspunkt"

L.xfer_no_recip = "Der Empfänger ist ungültig, Ausrüstungspunkt-Transfer abgebrochen."
L.xfer_no_credits = "Ungenügend Ausrüstungspunkte für einen Transfer."
L.xfer_success = "Ausrüstungspunkt-Transfer an {player} abgeschlossen."
L.xfer_received = "{player} gab dir {num} Ausrüstungspunkt(e)."

-- Radio tab in equipment menu
L.radio_name = "Radio"

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

-- Scoreboard
L.sb_playing = "Du spielst auf..."
L.sb_mapchange_mode_0 = "Das Sitzungslimit ist deaktiviert."
L.sb_mapchange_mode_1 = "Die Karte wechselt in {num} Runden oder in {time}"
L.sb_mapchange_mode_2 = "Die Karte wechselt in {time}"
L.sb_mapchange_mode_3 = "Die Karte wechselt in {num} Runden"

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

L.c4_disarm_t = "Durchschneide ein Kabel zum Entschärfen der Bombe. Wenn du Verräter bist, ist jedes Kabel sicher. Unschuldige haben es da nicht so einfach!"
L.c4_disarm_owned = "Durchschneide ein Kabel zum Entschärfen der Bombe. Es ist deine Bombe, also wird jedes Kabel sie sicher entschärfen."
L.c4_disarm_other = "Durchschneide das richtige Kabel, um die Bombe zu entschärfen. Sie explodiert, wenn du das falsche triffst!"

L.c4_status_armed = "SCHARF"
L.c4_status_disarmed = "ENTSCHÄRFT"

-- Visualizer
L.vis_name = "Visualisierer"

L.vis_desc = [[
Tatort-Visualisierungs-Gerät.

Analysiere eine Leiche, um zu sehen, wie die Person umgebracht wurde, funktioniert nur bei Tod durch Beschuss.]]

-- Decoy
L.decoy_name = "Attrappe"
L.decoy_broken = "Deine Attrappe wurde zerstört!"

L.decoy_short_desc = "Diese Attrappe erzeugt ein gefälschtes Radar-Signal sichtbar für andere Teams"
L.decoy_pickup_wrong_team = "Du kannst sie nicht aufnehmen, da sie einem anderen Team gehört"

L.decoy_desc = [[
Zeigt Detektiven ein gefälschtes Radar-Signal und bewirkt, dass der DNA-Scanner den Ort der Attrappe zeigt, wenn sie nach deiner DNA suchen.]]

-- Defuser
L.defuser_name = "Entschärfer"

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

-- Grenades and misc
L.grenade_smoke = "Rauchgranate"
L.grenade_fire = "Brandgranate"

L.unarmed_name = "Unbewaffnet"
L.crowbar_name = "Brechstange"
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

L.tele_help_pri = "Teleportiert dich zur markierten Stelle"
L.tele_help_sec = "Markiert momentane Position"

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

-- TargetID Karma status
L.karma_max = "Verlässlich"
L.karma_high = "Grob"
L.karma_med = "Schießwütig"
L.karma_low = "Gefährlich"
L.karma_min = "Verantwortungslos"

-- TargetID misc
L.corpse = "Leiche"
L.corpse_hint = "Drücke [{usekey}] zum Durchsuchen und Bestätigen. [{walkkey} + {usekey}] um verdeckt zu untersuchen."

L.target_disg = "(Getarnt)"
L.target_unid = "Unidentifizierter Körper"
L.target_unknown = "Ein Terrorist"

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

L.tip5 = "Wenn ein Verräter einen Detektiv tötet, erlangen diese direkt einen Ausrüstungspunkt als Belohnung."

L.tip6 = "Wenn ein Verräter von einem Detektiv getötet wird, erhalten alle Detektive einen Ausrüstungspunkt."

L.tip7 = "Wenn Verräter einen guten Fortschritt beim Töten von Unschuldigen gemacht haben, erhalten sie als Belohnung einen Ausrüstungspunkt."

L.tip8 = "Shopping-Rollen können unverbrauchte Ausrüstungspunkte von Leichen anderer Shopping-Rollen aufsammeln."

L.tip9 = "Der Poltergeist kann physikalische Objekte in tödliche Projektile verwandeln. Jeder Schlag ist begleitet von einem Energieimpuls, der jeden in der Nähe verletzt."

L.tip10 = "Behalte als Shopping-Rollen im Kopf, dass du Ausrüstungspunkte verdienst, wenn deine Partner gut arbeiten. Vergiss nicht diese auch auszugeben!"

L.tip11 = "Der DNA-Scanner des Detektivs kann genutzt werden, um DNA-Proben von Waffen und Objekten zu erhalten. Diese können zum Scannen benutzt werden, um die Position des Spielers herauszufinden, der diese benutzt hat. Nützlich, wenn du eine Probe von einer Leiche oder einer entschärften Ladung C4 erhalten hast!"

L.tip12 = "Wenn du in der Nähe von jemandem standest, den du getötet hast, hinterlässt du deine DNA auf der Leiche. Diese DNA kann ein Detektiv mit seinem DNA-Scanner untersuchen, um deine momentane Position herauszufinden. Es wäre besser, wenn du die Leiche versteckst, nachdem du jemanden mit dem Messer getötet hast!"

L.tip13 = "Je weiter du dich von der Leiche entfernst, an der deine DNA hängt, desto schneller verschwindet die DNA-Spur."

L.tip14 = "Du bist ein böser Heckenschütze? Dann solltest du in Betracht ziehen eine Tarnung zu kaufen. Wenn du verfehlst, renn an einen sicheren Ort und deaktiviere deine Tarnung. Niemand wird wissen, dass du der Heckenschütze warst."

L.tip15 = "Der Teleporter kann dir helfen zu entkommen oder dich schnell auf der Karte zu bewegen. Stelle sicher, dass du stets einen sicheren Punkt hast, zu dem du dich teleportieren kannst."

L.tip16 = "Stehen die Unschuldigen alle zusammen und sind schwer einzeln zu erledigen? Schnapp' dir das Radio, spiel Sounds von C4 oder Schüssen ab, um sie wegzulocken."

L.tip17 = "Du kannst mit dem platzierten Radio Sounds abspielen, indem du auf seinen Platzierungsmarker schaust. Du kannst mehrere Sounds hintereinander in Warteschlange geben, indem du sie in der Reihenfolge anklickst, in der sie gespielt werden sollen."

L.tip18 = "Wenn du als Detektiv Ausrüstungspunkte übrighast, kannst du deinen Entschärfer an einen glaubwürdigen Unschuldigen abgeben, dich um Wichtigeres kümmern und ihm den gefährlichen Job des Entschärfens überlassen."

L.tip19 = "Das Fernglas der Detektive kann Leichen aus großer Distanz untersuchen. Schlechte Nachrichten für die Verräter, wenn die die Leiche als Lockmittel nutzen wollten. Allerdings ist der Detektiv währenddessen unbewaffnet und abgelenkt..."

L.tip20 = "Die Gesundheitsstation der Detektive lässt verwundeten Spielern zu, sich zu heilen. Natürlich könnten diese verwundeten Spieler auch Verräter sein..."

L.tip21 = "Die Gesundheitsstation zeichnet die DNA jedes Spielers auf, der diese benutzt. Detektive können somit herausfinden, wer mit der Station bereits Lebenspunkte wiederhergestellt hat."

L.tip22 = "Anders als bei Waffen und C4 bleibt keine DNA des Platzierers auf einem Radio. Mach dir also keine Sorge darüber, ob Detektive dein Radio finden."

L.tip23 = "Drücke {helpkey} um eine kurze Anleitung anzuzeigen und einige TTT-spezifische Einstellungen zu ändern."

L.tip24 = "Wenn ein Detektiv einen Körper untersucht, dann sind die Ergebnisse für alle Spieler durch Klicken auf den Spielernamen im Scoreboard sichtbar."

L.tip25 = "Eine Lupe weist im Scoreboard darauf hin, dass es Untersuchungsergebnisse für diese Person gibt. Wenn das Symbol hell ist, dann kommen die Daten von einem Detektiv und können noch mehr Informationen enthalten."

L.tip26 = "Leichen mit einem Lupensymbol unter ihrem Namen heißen, dass diese von einem Detektiv untersucht wurde. Die Ergebnisse sind für alle im Scoreboard verfügbar."

L.tip27 = "Zuschauer können {mutekey} drücken, um durch die Stummschaltmodi von anderen Zuschauern oder lebenden Spielern zu schalten."

L.tip28 = "Du kannst die Sprache jederzeit im Einstellungsmenü aufrufen, welches du mit {helpkey} öffnest."

L.tip29 = "Schnellkommunikation oder 'radio' Kommandos können durch Drücken von {zoomkey} genutzt werden."

L.tip30 = "Das Sekundärfeuer der Brechstange schubst andere Spieler weg."

L.tip31 = "Das Schießen, während du mit Kimme und Korn zielst, erhöht deine Präzision leicht und verringert den Rückstoß beim Schießen. Ducken tut dies nicht."

L.tip32 = "Rauchgranaten sind innerhalb von Räumen effektiv. Speziell um Verwirrung zwischen vielen Leuten zu schaffen."

L.tip33 = "Als Verräter, denke daran, dass du die Leichen wegschleppen und vor den Stielaugen der Unschuldigen und der Detektive verstecken kannst und auch solltest."

L.tip34 = "Auf dem Scoreboard kannst du auf die Namen der lebendigen Spieler klicken und ihnen Markierungen setzen, wie zum Beispiel 'Verdächtig' oder 'Freund'. Diese Markierungen erscheinen, wenn du den markierten Spieler anvisierst."

L.tip35 = "Viele der platzierbaren Ausrüstungsgegenstände (wie zum Beispiel C4 oder das Radio) können mit einem Druck auf die Sekundärfeuertaste an Wänden befestigt werden."

L.tip36 = "C4, das beim Entschärfen ungewollt gezündet wird, hat eine geringere Detonationskraft als solches, bei dem die gesamte Zeit abläuft."

L.tip37 = "Wenn 'HAST MODUS' über der Rundenzeit zu lesen ist, dauert die Runde zunächst nur wenige Minuten länger, wird jedoch mit jedem Tod weiter und weiter verlängert. Dieser Modus übt Druck auf die Verräter aus und sorgt dafür, dass sie sich nicht alle Zeit der Welt nehmen können."

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
L.aw_crd1_text = "schnorrte sich {num} zurückgelassene Ausrüstungspunkte von Leichen zusammen."

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
L.equip_tooltip_xfer = "Ausrüstungspunkte transferieren"
L.equip_tooltip_reroll = "Ausrüstung neu auswürfeln"

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
L.reroll_menutitle = "Ausrüstung auswürfeln"
L.reroll_no_credits = "Du brauchst {amount} Ausrüstungspunkt(e) zum neu ausrollen!"
L.reroll_button = "Reroll"
L.reroll_help = "Verwende {amount} Ausrüstungspunkt(e), um ein neues zufälliges Set von Ausrüstungsgegenständen in deinem Shop zu erhalten!"

-- 2019-05-06
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

-- 2019-10-19
L.drop_ammo_prevented = "Etwas hindert dich daran deine Munition fallenzulassen."

-- 2019-10-28
L.target_c4 = "Drücke [{usekey}] um C4 Menü zu öffnen"
L.target_c4_armed = "Drücke [{usekey}] um C4 zu entschärfen"
L.target_c4_armed_defuser = "Drücke [{primaryfire}] um Entschärfer zu verwenden"
L.target_c4_not_disarmable = "Du kannst kein C4 eines lebenden Teamkollegen entschärfen"
L.c4_short_desc = "Etwas sehr explosives"

L.target_pickup = "Drücke [{usekey}] um aufzuheben"
L.target_slot_info = "Inventarplatz: {slot}"
L.target_pickup_weapon = "Drücke [{usekey}] um Waffe aufzuheben"
L.target_switch_weapon = "Drücke [{usekey}] um mit aktueller Waffe zu tauschen"
L.target_pickup_weapon_hidden = ", drücke [{walkkey} + {usekey}] für verstecktes Aufheben"
L.target_switch_weapon_hidden = ", drücke [{walkkey} + {usekey}] für verstecktes Tauschen"
L.target_switch_weapon_nospace = "Es ist kein Invetarplatz frei für diese Waffe"
L.target_switch_drop_weapon_info = "Lasse {name} aus Inventarplatz {slot} fallen"
L.target_switch_drop_weapon_info_noslot = "In Inventatplatz {slot} ist keine wegwerfbare Waffe"

L.corpse_searched_by_detective = "Diese Leiche wurde von einer öffentlichen Ordnungsrolle untersucht"
L.corpse_too_far_away = "Leiche zu weit weg zum Untersuchen."

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

-- 2020-01-07
L.tbut_help_admin = "Bearbeite Knopfeinstellungen"
L.tbut_role_toggle = "[{walkkey} + {usekey}] zum Umschalten dieses Knopfes für {role}"
L.tbut_role_config = "Rolle: {current}"
L.tbut_team_toggle = "[SHIFT + {walkkey} + {usekey}] zum Umschalten dieses Knopfes für {team}"
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
L.menu_gameplay_description = "Verändere Lautstärke-, Barrierefreiheits- und Gameplay-Einstellungen."
L.menu_addons_description = "Stelle lokale Addons nach deinem Geschmack ein"
L.menu_legacy_description = "Einstellungen von alten TTT Erweiterungen, die zum neuen UI-System konvertiert werden sollten"
L.menu_administration_description = "Allgemeine Einstellungen für HUDs, Ausrüstung und Shops"
L.menu_equipment_description = "Stelle Ausrüstungspunkte, Limitierungen, Verfügbarkeiten und anderes ein"
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

L.submenu_gameplay_general_title = "Allgemein"

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
L.label_crosshair_opacity = "Transparenz des Fadenkreuzes"
L.label_crosshair_ironsight_opacity = "Durchlässigkeit des Fadenkreuz-Visiers"
L.label_crosshair_size = "Fadenkreuz Liniengrößeskalierungsfaktor"
L.label_crosshair_thickness = "Fadenkreuz Dicke"
L.label_crosshair_thickness_outline = "Dicke der Umrandung des Fadenkreuzes"
L.label_crosshair_scale_enable = "Aktiviere die dynamische Skalierung des Fadenkreuzes"
L.label_crosshair_ironsight_low_enabled = "Senke Waffe beim Zielen durch Kimme und Korn"
L.label_damage_indicator_enable = "Aktiviere Schadensanzeige"
L.label_damage_indicator_mode = "Schadensanzeigen Thema"
L.label_damage_indicator_duration = "Sekunden, die die Schadensanzeige sichtbar ist"
L.label_damage_indicator_maxdamage = "Erlittener Schaden für maximale Sichtbarkeit"
L.label_damage_indicator_maxalpha = "Maximaler Transparenzwert"
L.label_performance_halo_enable = "Zeichne eine Linie um einige Entities, die man anschaut"
L.label_performance_spec_outline_enable = "Aktiviere Zuschauerumrandungen"
L.label_performance_ohicon_enable = "Aktiviere Rollenicons über den Köpfen"
L.label_interface_popup = "Dauer des Popups mit Infos am Anfang einer Runde"
L.label_interface_fastsw_menu = "Aktiviert das Waffenwechselmenü, selbst wenn der schnelle Waffenwechsel aktiv ist"
L.label_inferface_wswitch_hide_enable = "Aktiviere das automatische Schließen des Waffenwechselmenüs"
L.label_inferface_scues_enable = "Spiele einen Ton ab, wenn eine Runde beginnt oder endet"
L.label_gameplay_specmode = "Nur-Zuschauer-Modus (bleibe immer Zuschauer)"
L.label_gameplay_fastsw = "Schneller Waffenwechsel"
L.label_gameplay_hold_aim = "Aktiviere Halten zum Anvisieren"
L.label_gameplay_mute = "Stelle lebende Spieler stumm, wenn du tot bist"
L.label_hud_default = "Standard HUD"
L.label_hud_force = "Erzwungenes HUD"

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
L.corpse_hint_inspect_limited = "Drücke [{usekey}] zum Untersuchen. [{walkkey} + {usekey}] um nur die Untersuchungs-UI anzuzeigen."

-- 2020-06-04
L.label_bind_disguiser = "Tarnung umschalten"

-- 2020-06-24
L.dna_help_primary = "Entnehme eine DNA-Probe"
L.dna_help_secondary = "Wechsel den DNA Slot"
L.dna_help_reload = "Lösche eine Probe"

L.binoc_help_pri = "Identifiziere einen Körper."
L.binoc_help_sec = "Ändere Zoom-Level."

L.vis_help_pri = "Lass das aktivierte Gerät fallen."

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

L.label_bind_clscore = "Öffne den Rundenbericht"
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

L.tooltip_karma_gained = "Karmaänderungen für diese Runde:"
L.tooltip_score_gained = "Punkteänderungen für diese Runde:"
L.tooltip_roles_time = "Rollenwechsel für diese Runde:"

L.tooltip_finish_score_win = "Gewinner: {score}"
L.tooltip_finish_score_alive_teammates = "Lebende Teammitglieder: {score}"
L.tooltip_finish_score_alive_all = "Lebende Spieler: {score}"
L.tooltip_finish_score_timelimit = "Zeit vorbei: {score}"
L.tooltip_finish_score_dead_enemies = "Tote Gegner: {score}"
L.tooltip_kill_score = "Mord: {score}"
L.tooltip_bodyfound_score = "Leichenfund: {score}"

L.finish_score_win = "Gewinner:"
L.finish_score_alive_teammates = "Lebende Teammitglieder:"
L.finish_score_alive_all = "Lebende Spieler:"
L.finish_score_timelimit = "Zeit vorbei:"
L.finish_score_dead_enemies = "Tote Gegner:"
L.kill_score = "Mord:"
L.bodyfound_score = "Leichenfindung:"

L.title_event_bodyfound = "Eine Leiche wurde gefunden"
L.title_event_c4_disarm = "Ein C4 wurde entschärft"
L.title_event_c4_explode = "Ein C4 ist explodiert"
L.title_event_c4_plant = "Ein C4 wurde scharf geschaltet"
L.title_event_creditfound = "Ausrüstungspunkte wurden gefunden"
L.title_event_finish = "Die Runde ist vorbei"
L.title_event_game = "Eine neue Runde hat begonnen"
L.title_event_kill = "Ein Spieler wurde umgebracht"
L.title_event_respawn = "Ein Spieler wurde wiederbelebt"
L.title_event_rolechange = "Ein Spieler hat seine Rolle oder sein Team geändert"
L.title_event_selected = "Die Rollen wurden verteilt"
L.title_event_spawn = "Ein Spieler ist erschienen"

L.desc_event_bodyfound = "{finder} ({firole} / {fiteam}) hat die Leiche von {found} ({forole} / {foteam}) gefunden. Sie hatte {credits} Ausrüstungspunkt(e) in sich."
L.desc_event_bodyfound_headshot = "Das Opfer wurde durch einen Kopfschuss getötet."
L.desc_event_c4_disarm_success = "{disarmer} ({drole} / {dteam}) hat erfolgreich das C4 entschärft, welches von {owner} ({orole} / {oteam}) scharf geschaltet wurde."
L.desc_event_c4_disarm_failed = "{disarmer} ({drole} / {dteam}) hat versucht, das C4 zu entschärfen, welches von {owner} ({orole} / {oteam}) scharf geschaltet wurde. Der Versuch war nicht erfolgreich."
L.desc_event_c4_explode = "Das C4 von {owner} ({role} / {team}) explodierte."
L.desc_event_c4_plant = "{owner} ({role} / {team}) hat ein C4 scharf geschaltet."
L.desc_event_creditfound = "{finder} ({firole} / {fiteam}) hat {credits} Ausrüstungspunkt(e) in der Leiche von {found} ({forole} / {foteam}) gefunden."
L.desc_event_finish = "Die Runde dauerte {minutes}:{seconds}. Am Ende waren {alive} Spieler am Leben."
L.desc_event_game = "Eine neue Runde hat begonnen."
L.desc_event_respawn = "{player} wurde wiederbelebt."
L.desc_event_rolechange = "{player} hat seine Rolle/Team von {orole} ({oteam}) zu {nrole} ({nteam}) geändert."
L.desc_event_selected = "Die Teams und Rollen wurden für alle {amount} Spieler verteilt."
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
L.karma_teamkill_tooltip = "Teammate getötet"
L.karma_teamhurt_tooltip = "Teammate geschadet"
L.karma_enemykill_tooltip = "Gegner getötet"
L.karma_enemyhurt_tooltip = "Schaden"
L.karma_cleanround_tooltip = "Saubere Runde"
L.karma_roundheal_tooltip = "Karma wiederhergestellt"
L.karma_unknown_tooltip = "Unbekannt"

-- 2021-05-07
L.header_random_shop_administration = "Zufallsshop Einstellungen"
L.header_random_shop_value_administration = "Balance Einstellungen"

L.shopeditor_name_random_shops = "Aktiviere Zufalls-Shop"
L.shopeditor_desc_random_shops = [[Zufallsshops geben jedem Spieler ein begrenztes, zufällig ausgewähltes Set aller verfügbaren Ausrüstungen.
Teamshops geben allen Spielern in einem Team zwangsweise dasselbe Set, anstelle von individuellen.
Das Neuauswürfeln ermöglicht es dir, für Ausrüstungspunkte ein neues zufälliges Ausrüstungsset zu erhalten.]]
L.shopeditor_name_random_shop_items = "Anzahl zufälliger Equipments"
L.shopeditor_desc_random_shop_items = "Dies schließt Ausrüstungsgegenstände ein, die mit \"Immer im Shop verfügbar\" markiert sind. Wähle also eine ausreichend hohe Zahl, oder du bekommst nur diese."
L.shopeditor_name_random_team_shops = "Aktiviere Team-Shops"
L.shopeditor_name_random_shop_reroll = "Aktiviere Möglichkeit Shop neu auszuwürfeln"
L.shopeditor_name_random_shop_reroll_cost = "Kosten pro Auswürfeln"
L.shopeditor_name_random_shop_reroll_per_buy = "Automatisches Auswürfeln nach jedem Kauf"

-- 2021-06-04
L.header_equipment_setup = "Ausrüstungseinstellungen"
L.header_equipment_value_setup = "Balance Einstellungen"

L.equipmenteditor_name_not_buyable = "Kann gekauft werden"
L.equipmenteditor_desc_not_buyable = "Das Equipment ist in keinem Shop zu finden, wenn dies deaktiviert ist. Rollen, die dieses Equipment als Standardausrüstung bekommen sind davon jedoch nicht betroffen."
L.equipmenteditor_name_not_random = "Immer im Shop verfügbar"
L.equipmenteditor_desc_not_random = "Wenn aktiviert, ist die Ausrüstung immer im Shop verfügbar. Wenn der Zufallsshop aktiviert ist, wird ein verfügbarer zufälliger Slot genommen und immer für diese Ausrüstung reserviert."
L.equipmenteditor_name_global_limited = "Global limitierte Anzahl"
L.equipmenteditor_desc_global_limited = "Wenn aktiviert, kann die Ausrüstung nur einmal auf dem Server in der laufenden Runde gekauft werden."
L.equipmenteditor_name_team_limited = "Team limitierte Anzahl"
L.equipmenteditor_desc_team_limited = "Wenn aktiviert, kann die Ausrüstung nur einmal pro Team in der laufenden Runde gekauft werden."
L.equipmenteditor_name_player_limited = "Spieler limitierte Anzahl"
L.equipmenteditor_desc_player_limited = "Wenn aktiviert, kann die Ausrüstung nur einmal pro Spieler in der laufenden Runde gekauft werden."
L.equipmenteditor_name_min_players = "Mindestanzahl von Spielern zum Kauf"
L.equipmenteditor_name_credits = "Kosten in Ausrüstungspunkten"

-- 2021-06-08
L.equip_not_added = "nicht enthalten"
L.equip_added = "enthalten"
L.equip_inherit_added = "enthalten (geerbt)"
L.equip_inherit_removed = "entfernt (geerbt)"

-- 2021-06-09
L.layering_not_layered = "Ohne Ebene"
L.layering_layer = "Ebene {layer}"
L.header_rolelayering_role = "{role}-Ebene"
L.header_rolelayering_baserole = "Basisrollenebenen"
L.submenu_roles_rolelayering_title = "Rollenebenen"
L.header_rolelayering_info = "Rollenebeneninformationen"
L.help_rolelayering_roleselection = [[Der Rollenverteilungsprozess ist in zwei Phasen unterteilt. In der ersten Phase werden Basisrollen verteilt, zu denen Unschuldige, Verräter und diejenigen gehören, welche in der 'Basisrollenebene' unten aufgeführt sind. Die zweite Phase dient dazu, diese Basisrollen zu Unterrollen aufzuwerten.]]
L.help_rolelayering_layers = [[Aus jeder Ebene wird nur eine Rolle ausgewählt. Zuerst werden die Rollen aus den benutzerdefinierten Ebenen verteilt, beginnend mit der ersten Ebene, bis die letzte erreicht ist oder keine Rollen mehr aufgewertet werden können. Was auch immer zuerst passiert, wenn noch aufwertbare Slots verfügbar sind, werden auch die nicht geschichteten Rollen verteilt.]]
L.scoreboard_voice_tooltip = "Scrolle um die Lautstärke zu ändern"

-- 2021-06-15
L.header_shop_linker = "Einstellungen"
L.label_shop_linker_set = "Wähle Shopart aus:"

-- 2021-06-18
L.xfer_team_indicator = "Team"

-- 2021-06-25
L.searchbar_default_placeholder = "Durchsuche Liste..."

-- 2021-07-11
L.spec_about_to_revive = "Zuschauen während der Widerbelebung nicht möglich."

-- 2021-09-01
L.spawneditor_name = "Spawneditor-Werkzeug"
L.spawneditor_desc = "Wird verwendet, um Waffen-, Munitions- und Spielerspawns in der Welt zu plazuieren. Kann nur von Superadmins verwendet werden."

L.spawneditor_place = "Platziere Spawn"
L.spawneditor_remove = "Entferne Spawn"
L.spawneditor_change = "Ändere den Spawntyp (halte [SHIFT] zum Umkehren)"
L.spawneditor_ammo_edit = "Halten bei Waffen-Spawns, um autogenerierte Munition zu bearbeiten"

L.spawn_weapon_random = "Zufallswaffenspawn"
L.spawn_weapon_melee = "Nahkampfwaffenspawn"
L.spawn_weapon_nade = "Granatenspawn"
L.spawn_weapon_shotgun = "Schrotflintenspawn"
L.spawn_weapon_heavy = "Schwerewaffenspawn"
L.spawn_weapon_sniper = "Sniperspawn"
L.spawn_weapon_pistol = "Pistolenspawn"
L.spawn_weapon_special = "Spezialwaffenspawn"
L.spawn_ammo_random = "Zufallsmunitionsspawn"
L.spawn_ammo_deagle = "Deaglemunitionsspawn"
L.spawn_ammo_pistol = "Pistolenmunitionsspawn"
L.spawn_ammo_mac10 = "Mac10-Munitionsspawn"
L.spawn_ammo_rifle = "Gewehrmunitionsspawn"
L.spawn_ammo_shotgun = "Schrotflintenmunitionsspawn"
L.spawn_player_random = "Zufallsspielerspawn"

L.spawn_weapon_ammo = "(Munition: {ammo})"

L.spawn_weapon_edit_ammo = "Halte [{walkkey}] und drücke [{primaryfire} oder {secondaryfire}], um die Munition für diesen Waffenspawn zu erhöhen / reduzieren"

L.spawn_type_weapon = "Dies ist ein Waffenspawn"
L.spawn_type_ammo = "Dies ist ein Munitionsspawn"
L.spawn_type_player = "Dies ist ein Spielerspawn"

L.spawn_remove = "Drücke [{secondaryfire}], um diesen Spawn zu entfernen"

L.submenu_administration_entspawn_title = "Spawn Editor"
L.header_entspawn_settings = "Spawn Editor Einstellungen"
L.button_start_entspawn_edit = "Starte Spawn Editor"
L.button_delete_all_spawns = "Lösche alle Spawns"

L.label_dynamic_spawns_enable = "Aktiviere dynamische Spawns für diese Map"
L.label_dynamic_spawns_global_enable = "Aktiviere dynamische Spawns für alle Karten"

L.header_equipment_weapon_spawn_setup = "Waffenspawneinstellungen"

L.help_spawn_editor_info = [[
Der Spawndeditor wird verwendet, um Spawns in der Welt zu platzieren, zu entfernen und zu bearbeiten. Diese Spawns sind für Waffen, Munition und Spieler.

Diese Spawns werden in Dateien im Verzeichnis 'data/ttt/weaponspawnscripts/' gespeichert. Sie können für einen harten Reset gelöscht werden. Die ursprünglichen Spawndateien werden aus den auf der Karte gefundenen Spawns und den ursprünglichen TTT-Waffenspawnskripten erstellt. Das Drücken der Zurücksetzen-Schaltfläche führt immer zur Ausgangsposition zurück.

Es sollte beachtet werden, dass dieses Spawnsystem dynamische Spawns verwendet. Dies ist besonders interessant für Waffen, da es nicht mehr eine bestimmte Waffe definiert, sondern einen Typ von Waffen. Zum Beispiel gibt es anstelle eines TTT-Schrotgewehr-Spawns jetzt einen allgemeinen Schrotgewehr-Spawn, auf dem jede als Schrotgewehr definierte Waffe erscheinen kann. Der Spawntyp für jede Waffe kann im 'Ausrüstung bearbeiten'-Menü festgelegt werden. Dies ermöglicht es, dass jede Waffe auf der Karte erscheinen kann, oder bestimmte Standardwaffen deaktiviert werden können.

Beachte, dass viele Änderungen erst nach Beginn einer neuen Runde wirksam werden.]]
L.help_spawn_editor_enable = "Auf einigen Karten kann es ratsam sein, die ursprünglichen Spawns auf der Karte zu verwenden, anstatt sie durch das dynamische System zu ersetzen. Die Änderung dieser Option unten betrifft nur die derzeit aktive Karte, sodass das dynamische System weiterhin für jede andere Karte verwendet wird."
L.help_spawn_editor_hint = "Hinweis: Öffne das Gamemode Menü erneut, um den Spawneditor zu verlassen"
L.help_spawn_editor_spawn_amount = [[
Aktuell existieren {weapon} Waffenspawns, {ammo} Munitionssapawns und {player} Spielerspawns auf dieser Map.
Drücke 'Starte Spawn Editor' um diese zu ändern.

{weaponrandom}x Zufallswaffenspawn
{weaponmelee}x Nahkampfwaffenspawn
{weaponnade}x Granatenspawn
{weaponshotgun}x Schrotflintenspawn
{weaponheavy}x Schwerewaffenspawn
{weaponsniper}x Sniperspawn
{weaponpistol}x Pistolenspawn
{weaponspecial}x Spezialwaffenspawn

{ammorandom}x Zufallsmunitionsspawn
{ammodeagle}x Deaglemunitionsspawn
{ammopistol}x Pistolenmunitionsspawn
{ammomac10}x Mac10-Munitionsspawn
{ammorifle}x Gewehrmunitionsspawn
{ammoshotgun}x Schrotflintenmunitionsspawn

{playerrandom}x Zufallsspielerspawn]]

L.equipmenteditor_name_auto_spawnable = "Ausrüstung spawnt zufällig in der Welt"
L.equipmenteditor_name_spawn_type = "Wähle Spawntyp"
L.equipmenteditor_desc_auto_spawnable = [[
Das TTT2-Spawnsystem ermöglicht es, dass jede Waffe in der Welt erscheint. Standardmäßig erscheinen nur Waffen, die vom Ersteller als 'AutoSpawnable' markiert wurden, in der Welt. Dies kann jedoch in diesem Menü geändert werden.

Die meisten Ausrüstungsgegenstände sind standardmäßig auf 'Spezialwaffenspawn' eingestellt. Das bedeutet, dass die Ausrüstungsgegenstände nur auf zufälligen Waffenspawns erscheint. Es ist jedoch möglich, spezielle Waffenspawns in der Welt zu platzieren oder den Spawntyp hier zu ändern, um andere vorhandene Spawntypen zu verwenden.]]

L.pickup_error_inv_cached = "Du kannst dies im AUgenblick nicht aufheben, da dein Inventar gecached ist."

-- 2021-09-02
L.submenu_administration_playermodels_title = "Spielermodell"
L.header_playermodels_general = "Allgemeine Spielermodelleinstellungen"
L.header_playermodels_selection = "Wähle Spielermodellliste"

L.label_enforce_playermodel = "Erzwinge rollenspezifisches Spielermodell"
L.label_use_custom_models = "Verwende ein zufällig ausgewähltes Spielermodell"
L.label_prefer_map_models = "Bevorzuge kartenspezifische Modelle über die Standardspielermodelle"
L.label_select_model_per_round = "Wähle in jeder Runde ein neues zufälliges Modell aus (wenn deaktiviert, dann nur bei Kartenwechsel)"
L.label_select_unique_model_per_round = "Unterschiedliches zufälliges Spielermodell je Spieler"

L.help_prefer_map_models = [[
Einige Karten definieren ihre eigenen Spielermodelle. Standardmäßig haben diese Modelle eine höhere Priorität als die automatisch zugewiesenen Modelle. Durch das Deaktivieren dieser Einstellung werden die kartenspezifischen Modelle deaktiviert.

Rollen-spezifische Modelle haben immer Vorrang und werden von dieser Einstellung nicht beeinflusst.]]
L.help_enforce_playermodel = [[
Einige Rollen haben benutzerdefinierte Spielermodelle. Diese können deaktiviert werden, was in Bezug auf die Kompatibilität mit bestimmten Spielermodell-Selektoren relevant sein kann.
Zufällige Standardmodelle können immer noch ausgewählt werden, wenn diese Einstellung deaktiviert ist.]]
L.help_use_custom_models = [[
Standardmäßig wird allen Spielern standardmäßig das CS:S Phoenix-Spielermodell zugewiesen. Durch Aktivieren dieser Option ist es jedoch möglich, einen Spielermodell-Pool auszuwählen. Bei dieser Einstellung wird jedem Spieler immer noch dasselbe Spielermodell zugewiesen, jedoch handelt es sich um ein zufälliges Modell aus dem definierten Modell-Pool.

Diese Auswahl an Modellen kann durch die Installation weiterer Spielermodelle erweitert werden.]]

-- 2021-10-06
L.menu_server_addons_title = "Server Addons"
L.menu_server_addons_description = "Serverweite Administrator-Einstellungen für Addons."

L.tooltip_finish_score_penalty_alive_teammates = "Lebende Teammitglieder (Strafe): {score}"
L.finish_score_penalty_alive_teammates = "Lebende Teammitglieder (Strafe):"
L.tooltip_kill_score_suicide = "Selbstmord: {score}"
L.kill_score_suicide = "Selbstmord:"
L.tooltip_kill_score_team = "Teammord: {score}"
L.kill_score_team = "Teammord:"

-- 2021-10-09
L.help_models_select = [[
Linksklick auf die Modelle, um sie dem Spielermodell-Pool hinzuzufügen. Klicke erneut mit der linken Maustaste, um sie zu entfernen. Das Rechtsklicken schaltet die aktivierten und deaktivierten Detektivhüte für das ausgewählte Modell um.

Der kleine Indikator oben links zeigt an, ob das Spielermodell eine Kopftrefferbox hat. Das Symbol darunter zeigt an, ob dieses Modell für einen Detektivhut geeignet ist.]]

L.menu_roles_title = "Rollen Einstellungen"
L.menu_roles_description = "Richte Rollenspawning, Ausrüsungspunkte und mehr ein."

L.submenu_roles_roles_general_title = "Allgemeine Rolleneinstellungen"

L.header_roles_info = "Roleninformationen"
L.header_roles_selection = "Rollenauswahlparameter"
L.header_roles_tbuttons = "Zugriff zu Verräterknöpfen"
L.header_roles_credits = "Rollenausrüstungspunkte"
L.header_roles_additional = "Weitere Rolleneinstellungen"
L.header_roles_reward_credits = "Belohnungsausrüstungspunkte"

L.help_roles_default_team = "Standardteam: {team}"
L.help_roles_unselectable = "Diese Rolle ist nicht verteilbar. Sie wird im Rollenverteilungsprozess nicht berücksichtigt. In den meisten Fällen handelt es sich dabei um eine Rolle, die während der Runde manuell durch ein Ereignis wie eine Wiederbelebung, eine Sidekick-Deagle oder etwas Ähnliches zugewiesen wird."
L.help_roles_selectable = "Diese Rolle ist verteilbar. Wenn alle Kriterien erfüllt sind, wird diese Rolle im Rollenverteilungsprozess berücksichtigt."
L.help_roles_credits = "Ausrüstungspunkte werden verwendet, um Ausrüstung im Shop zu kaufen. Es ergibt meistens Sinn, sie nur für die Rollen zu vergeben, die Zugang zu Shops haben. Da es jedoch möglich ist, Ausrüstungspunkte in Leichen zu finden, kannst du Rollen auch Start-Ausrüstungspunkte als Belohnung für ihren Mörder geben."
L.help_roles_selection_short = "Die Rollenverteilung pro Spieler definiert den Prozentsatz der Spieler, denen diese Rolle zugewiesen wird. Zum Beispiel, wenn der Wert auf '0,2' eingestellt ist, erhält jeder fünfte Spieler diese Rolle."
L.help_roles_selection = [[
Die Rollenverteilung pro Spieler definiert den Prozentsatz der Spieler, denen diese Rolle zugewiesen wird. Zum Beispiel, wenn der Wert auf '0,2' eingestellt ist, erhält jeder fünfte Spieler diese Rolle. Dies bedeutet auch, dass mindestens 5 Spieler benötigt werden, damit diese Rolle überhaupt verteilt wird.
Beachte, dass all dies nur gilt, wenn die Rolle für den Verteilungsprozess berücksichtigt wird.

Die oben genannte Rollenverteilung hat eine besondere Integration mit der unteren Spielerbegrenzung. Wenn die Rolle für die Verteilung in Betracht gezogen wird und der Mindestwert unter dem Wert liegt, der durch den Verteilungsfaktor angegeben wird, aber die Anzahl der Spieler gleich oder größer als die untere Begrenzung ist, kann immer noch ein einzelner Spieler diese Rolle erhalten. Der Verteilungsprozess funktioniert dann wie gewohnt für den zweiten Spieler.]]
L.help_roles_award_info = "Einige Rollen (wenn in ihren Ausrüstungspunkt-Einstellungen aktiviert) erhalten Ausrüstungspunkte, wenn ein bestimmter Prozentsatz an Feinden gestorben ist. Die damit verbundenen Werte können hier angepasst werden."
L.help_roles_award_pct = "Wenn dieser Prozentsatz der Feinde tot ist, erhalten bestimmte Rollen Ausrüstungspunkte als Belohnung."
L.help_roles_award_repeat = "Ob die Ausrüstungspunktevergabe mehrmals erfolgt. Zum Beispiel, wenn der Prozentsatz auf '0.25' eingestellt ist und diese Einstellung aktiviert ist, erhalten Spieler bei '25%', '50%' und '75%' toten Feinden jeweils Ausrüstungspunkte."
L.help_roles_advanced_warning = "WARNUNG: Dies sind fortgeschrittene Einstellungen, die den Rollenverteilungsprozess komplett durcheinander bringen können. Bei Unsicherheit sollten alle Werte auf '0' belassen werden. Dieser Wert bedeutet, dass keine Grenzen gelten und die Rollenverteilung versuchen wird, so viele Rollen wie möglich zuzuweisen."
L.help_roles_max_roles = [[
Der Begriff "Rollen" umfasst hier sowohl die Basisrollen als auch die Unterrollen. Standardmäßig gibt es keine Begrenzung, wie viele verschiedene Rollen zugewiesen werden können. Es gibt jedoch zwei verschiedene Möglichkeiten, sie zu beschränken:

1. Begrenzung durch eine feste Menge.
2. Begrenzung durch einen Prozentsatz.

Letzteres wird nur verwendet, wenn die feste Menge '0' beträgt und setzt eine Obergrenze auf Grundlage des festgelegten Prozentsatzes der verfügbaren Spieler.]]
L.help_roles_max_baseroles = [[
Basisrollen sind nur die Rollen, von denen andere erben. Zum Beispiel ist die Unschuldigen-Rolle eine Basisrolle, während ein Pharao eine Unterrolle dieser Rolle ist. Standardmäßig gibt es keine Begrenzung, wie viele verschiedene Basisrollen zugewiesen werden können. Es gibt jedoch zwei verschiedene Möglichkeiten, sie zu beschränken:

1. Begrenzung durch eine feste Menge.
2. Begrenzung durch einen Prozentsatz.

Letzteres wird nur verwendet, wenn die feste Menge '0' beträgt und setzt eine Obergrenze auf Grundlage des festgelegten Prozentsatzes der verfügbaren Spieler.]]

L.label_roles_enabled = "Aktiviere Rolle"
L.label_roles_min_inno_pct = "Unschuldigenverteilung pro Spieler"
L.label_roles_pct = "Rollenverteilung pro Spieler"
L.label_roles_max = "Oberes Limit von Spielern mit dieser Rolle"
L.label_roles_random = "Chance, dass diese Rolle verteilt wird"
L.label_roles_min_players = "Die untere Spielerbegrenzung, um die Verteilung in Betracht zu ziehen"
L.label_roles_tbutton = "Rolle kann Verräterknöpfe nutzen"
L.label_roles_credits_starting = "Ausrüstungspunkte zu Beginn"
L.label_roles_credits_award_pct = "Belohnungsspieleranteil"
L.label_roles_credits_award_size = "Belohnungsgröße"
L.label_roles_credits_award_repeat = "Mehrfache Belohnung"
L.label_roles_newroles_enabled = "Aktiviere eigene Rollen"
L.label_roles_max_roles = "Obere Grenze für Rollen"
L.label_roles_max_roles_pct = "Prozentuale obere Grenze für Rollen"
L.label_roles_max_baseroles = "Obere Basisrollenbegrenzung"
L.label_roles_max_baseroles_pct = "Obere Basisrollenbegrenzung in Prozent"
L.label_detective_hats = "Aktiviere Hüte für öffentliche Ordnungsrollen wie den Detektiv (sofern das Spielermodell dies zulässt)"

L.ttt2_desc_innocent = "Ein Unschuldiger hat keine besonderen Fähigkeiten. Sie müssen die Bösen unter den Terroristen finden und sie töten. Dabei müssen sie jedoch vorsichtig sein, ihre Teammitglieder nicht zu töten."
L.ttt2_desc_traitor = "Der Verräter ist der Feind der Unschuldigen. Sie verfügen über ein Ausrüstungsmenü, mit dem sie spezielle Ausrüstung kaufen können. Ihr Ziel ist es, jeden zu töten, außer ihre Teammitglieder."
L.ttt2_desc_detective = "Der Detektiv ist derjenige, dem die Unschuldigen trauen können. Aber wer sind die Unschuldigen? Der Detektiv muss genau das herausfinden. Ihr Ausrüstungsshop hilft ihnen vielleicht dabei."

-- 2021-10-10
L.button_reset_models = "Spielermodelle Zurücksetzen"

-- 2021-10-13
L.help_roles_credits_award_kill = "Ein weiterer Weg Ausrüstungspunkte zu erhalten ist es wichtige Spieler mit 'öffentlichen Rollen' (wie beispielsweise dem Detektiv) zu töten. Wenn die Rolle des Mörders dies aktiviert hat, dann bekommt der Spieler die hier definierte Anzahl an Ausrüstungspunkten."
L.help_roles_credits_award = [[
Es gibt zwei verschiedene Möglichkeiten, um in Basis-TTT2 Ausrüstungspunkte zu erhalten:

1. Wenn ein bestimmter Prozentsatz des feindlichen Teams tot ist, erhält das gesamte Team Ausrüstungspunkte.
2. Wenn ein Spieler einen Spieler mit einer 'öffentlichen Rolle' wie einem Detektiv getötet hat, werden dem Mörder Ausrüstungspunkte verliehen.

Bitte beachte, dass dies immer noch für jede Rolle aktiviert/deaktiviert werden kann, selbst wenn das gesamte Team belohnt wird. Zum Beispiel, wenn das Team Unschuldige belohnt wird, aber die Rolle Unschuldiger diese Funktion deaktiviert hat, erhält nur der Detektiv seine Ausrüstungspunkte.
Die Balanceeinstellungen für diese Funktion können in 'Administration' -> 'Allgemeine Rolleneinstellungen' festgelegt werden.]]
L.help_detective_hats = [[
Öffentliche Ordnungsrollen wie der Detektiv können Hüte tragen, um ihre Autorität zu zeigen. Sie verlieren diese Hüte bei ihrem Tod oder wenn der Kopf beschädigt wird.

Einige Spielermodelle unterstützen standardmäßig keine Hüte. Dies kann in 'Administration' -> 'Spielermodell' geändert werden.]]

L.label_roles_credits_award_kill = "Anzahl an Ausrüstungspunkten für die Tötung"
L.label_roles_credits_dead_award = "Aktiviere Ausrüstungspunktebelohnung für gewissen Anteil an toten Gegnern"
L.label_roles_credits_kill_award = "Aktiviere Ausrüstungspunktebelohnung für Mord an wichtigem Spieler"
L.label_roles_min_karma = "Untere Grenze des Karmas, um die Verteilung in Betracht zu ziehen"

-- 2021-11-07
L.submenu_administration_administration_title = "Administration"
L.submenu_administration_voicechat_title = "Sprachchat / Textchat"
L.submenu_administration_round_setup_title = "Rundeneinstellungen"
L.submenu_administration_mapentities_title = "Karten Objekte"
L.submenu_administration_inventory_title = "Inventar"
L.submenu_administration_karma_title = "Karma"
L.submenu_administration_sprint_title = "Sprinten"
L.submenu_administration_playersettings_title = "Spielereinstellungen"

L.header_roles_special_settings = "Spezialrolleneinstellungen"
L.header_equipment_additional = "Zusätzliche Ausrüstungseinstellungen"
L.header_administration_general = "Allgemeine administrative Einstellungen"
L.header_administration_logging = "Protokollierung"
L.header_administration_misc = "Verschiedenes"
L.header_entspawn_plyspawn = "Player Spawn Einstellungen"
L.header_voicechat_general = "Allgemeine Sprachchat Einstellungen"
L.header_voicechat_battery = "Sprachchat Batterie"
L.header_voicechat_locational = "Proximity Sprachchat"
L.header_playersettings_plyspawn = "Player Spawn Einstellungen"
L.header_round_setup_prep = "Runde: Vorbereitung"
L.header_round_setup_round = "Runde: Aktiv"
L.header_round_setup_post = "Runde: Beendet"
L.header_round_setup_map_duration = "Karten Sitzung"
L.header_textchat = "Textchat"
L.header_round_dead_players = "Einstellungen für tote Spieler"
L.header_administration_scoreboard = "Scoreboardeinstellungen"
L.header_hud_toggleable = "Einblendbare HUD-Elemente"
L.header_mapentities_prop_possession = "Prop Übernahme"
L.header_mapentities_doors = "Türen"
L.header_karma_tweaking = "Karma-Anpassung"
L.header_karma_kick = "Karma Kick und Ban"
L.header_karma_logging = "Karma Protokollierung"
L.header_inventory_gernal = "Inventargröße"
L.header_inventory_pickup = "Inventar Waffenaufnahme"
L.header_sprint_general = "Sprinteinstellungen"
L.header_playersettings_armor = "Rüstungssystem Einstellungen"

L.help_killer_dna_range = "Wenn ein Spieler von einem anderen Spieler getötet wird, wird eine DNA-Probe auf ihrem Körper hinterlassen. Die untenstehende Einstellung definiert die maximale Entfernung in Hammer-Einheiten, in der DNA-Proben hinterlassen werden. Wenn der Mörder weiter entfernt ist als dieser Wert, wenn das Opfer stirbt, wird keine Probe auf der Leiche hinterlassen."
L.help_killer_dna_basetime = "Die Grundzeit in Sekunden, bis eine DNA-Probe zerfällt, wenn der Mörder 0 Hammer-Einheiten entfernt ist. Je weiter der Mörder entfernt ist, desto weniger Zeit wird der DNA-Probe gegeben, um zu zerfallen."
L.help_dna_radar = "Der TTT2 DNA-Scanner zeigt die genaue Entfernung und Richtung der ausgewählten DNA-Probe, wenn er ausgerüstet ist. Es gibt jedoch auch einen klassischen DNA-Scanner-Modus, der die ausgewählte Probe mit einer In-World-Anzeige aktualisiert, sobald die Abklingzeit abgelaufen ist."
L.help_idle = "Der Idle-Modus wird verwendet, um inaktive Spieler zwangsweise in den Zuschauermodus zu versetzen. Um diesen Modus zu verlassen, müssen die Spieler ihn in ihrem 'Gameplay'-Menü deaktivieren."
L.help_namechange_kick = [[
Eine Namensänderung während einer laufenden Runde könnte missbraucht werden. Daher ist dies standardmäßig verboten und führt dazu, dass der betroffene Spieler vom Server gekickt wird.

Wenn die Sperrzeit größer als 0 ist, wird der Spieler erst nach Ablauf dieser Zeit wieder in der Lage sein, sich erneut mit dem Server zu verbinden.]]
L.help_damage_log = "Jedes Mal, wenn ein Spieler Schaden erleidet, wird ein Schadensprotokolleintrag in der Konsole hinzugefügt, wenn dies aktiviert ist. Dies kann auch auf die Festplatte gespeichert werden, nachdem eine Runde beendet wurde. Die Datei befindet sich unter 'data/terrortown/logs/'"
L.help_spawn_waves = [[
Wenn diese Variable auf 0 gesetzt ist, werden alle Spieler auf einmal gespawnt. Für Server mit einer großen Anzahl von Spielern kann es vorteilhaft sein, die Spieler in Wellen zu spawnen. Der Spawnwellenintervall ist die Zeit zwischen jeder Spawnwelle. Eine Spawnwelle spawnt immer so viele Spieler wie es gültige Spawnpunkte gibt.

Hinweis: Stellen Sie sicher, dass die Vorbereitungszeit lang genug für die gewünschte Anzahl von Spawnwellen ist.]]
L.help_voicechat_battery = [[
Die Verwendung des Sprachchats mit aktivierter Sprachchat-Batterie reduziert dabei die Batterieladung. Wenn die Batterie leer ist, kann der Spieler den Sprachchat nicht mehr verwenden und muss warten, bis sie sich wieder auflädt. Dies kann dazu beitragen, den übermäßigen Gebrauch des Sprachchats zu verhindern.

Hinweis: 'Tick' bezieht sich auf einen Spieltick. Wenn beispielsweise die Tickrate auf 66 eingestellt ist, entspricht dies 1/66 Sekunde.]]
L.help_ply_spawn = "Spieler-Einstellungen, die beim Spieler (Neu-)Spawn verwendet werden."
L.help_haste_mode = [[
Der Hast-Modus balanciert das Spiel, indem er die Rundenzeit mit jedem getöteten Spieler erhöht. Nur Rollen, die tote Spieler sehen können, können die tatsächliche Rundenzeit sehen. Alle anderen Rollen können nur die Startzeit des Hast-Modus sehen.

Wenn der Hast-Modus aktiviert ist, wird die festgelegte Rundenzeit ignoriert.]]
L.help_round_limit = "Nachdem eine der festgelegten Bedingungen erfüllt ist, wird ein Kartenwechsel ausgelöst."
L.help_armor_balancing = "Die folgenden Werte können verwendet werden, um die Rüstung auszugleichen."
L.help_item_armor_classic = "Wenn der klassische Rüstungsmodus aktiviert ist, sind nur die vorangegangenen Einstellungen relevant. Im klassischen Rüstungsmodus kann ein Spieler in einer Runde nur einmal Rüstung kaufen, und diese Rüstung blockiert 30% des eintreffenden Kugel- und Brechstangenschadens, bis sie sterben."
L.help_item_armor_dynamic = [[
Die dynamische Rüstung ist der Ansatz von TTT2, um Rüstung interessanter zu gestalten. Die Menge an Rüstung, die gekauft werden kann, ist jetzt unbegrenzt, und der Rüstungswert stapelt sich. Bei Verletzungen wird der Rüstungswert verringert. Der Rüstungswert pro gekauftem Rüstungsgegenstand wird in den 'Ausrüstungseinstellungen' dieses Gegenstands festgelegt.

Bei Schäden wird ein bestimmter Prozentsatz dieses Schadens in Rüstungsschaden umgewandelt, ein anderer Prozentsatz wird immer noch auf den Spieler angewendet und der Rest verschwindet.

Wenn verstärkte Rüstung aktiviert ist, wird der dem Spieler zugefügte Schaden um 15% verringert, solange der Rüstungswert über der Verstärkungsschwelle liegt.]]
L.help_sherlock_mode = "Der Sherlock-Modus ist der klassische TTT-Modus. Wenn der Sherlock-Modus deaktiviert ist, können tote Körper nicht bestätigt werden, das Scoreboard zeigt jeden als lebendig an, und die Zuschauer können mit den lebenden Spielern sprechen."
L.help_prop_possession = [[
Die Prop-Übernahme kann von Zuschauern verwendet werden, um im Spiel liegende Gegenstände zu besitzen und den langsam wieder aufladenden 'Schlagzähler' zu verwenden, um den genannten Gegenstand zu bewegen.

Der maximale Wert des 'Schlagzählers' berechnet sich aus dem Grundwert für die Prop Übernahme und dem Addieren der Differenz zwischen Kills und Toden zwischen den zwei definierten Grenzen. Der Zähler lädt sich im Laufe der Zeit langsam auf. Die eingestellte Aufladezeit ist die Zeit, die benötigt wird, um einen einzelnen Punkt im 'Schlagzähler' aufzuladen.]]
L.help_karma = "Spieler starten mit einer bestimmten Menge an Karma und verlieren es, wenn sie Teammitglieder verletzen/töten. Die Menge, die sie verlieren, hängt vom Karma der Person ab, die sie verletzt oder getötet haben. Niedrigeres Karma reduziert den verursachten Schaden."
L.help_karma_strict = "Wenn das strenge Karma aktiviert ist, erhöht sich die Schadensstrafe schneller, wenn das Karma sinkt. Wenn es deaktiviert ist, ist die Schadensstrafe sehr gering, solange die Spieler über 800 bleiben. Das Aktivieren des strengen Modus bewirkt, dass das Karma eine größere Rolle spielt, um unnötige Tötungen zu verhindern, während die Deaktivierung zu einem 'lockeren' Spiel führt, bei dem das Karma nur Spieler bestraft, die ständig Teammitglieder töten."
L.help_karma_max = "Das Festlegen des Werts des maximalen Karma über 1000 verleiht Spielern mit mehr als 1000 Karma keinen Schadensbonus. Es kann als Karma-Puffer verwendet werden."
L.help_karma_ratio = "Das Verhältnis des Schadens, das zur Berechnung abgezogen wird, um festzulegen, wie viel des Opferkarmas vom Angreifer abgezogen wird, wenn beide im selben Team sind. Bei einem Team-Kill wird eine zusätzliche Strafe verhängt."
L.help_karma_traitordmg_ratio = "Das Verhältnis des Schadens, das zur Berechnung verwendet wird, um festzulegen, wie viel des Opferkarmas dem Angreifer hinzugefügt wird, wenn beide in unterschiedlichen Teams sind. Bei einem Feind-Kill wird ein weiterer Bonus angewendet."
L.help_karma_bonus = "Es gibt auch zwei verschiedene passive Möglichkeiten, während einer Runde Karma zu gewinnen. Erstens gibt es eine Karma-Wiederherstellung, die am Ende der Runde auf jeden Spieler angewendet wird. Dann wird ein sekundärer 'Saubere Runde'-Bonus vergeben, wenn kein Teammitglied von einem Spieler verletzt oder getötet wurde."
L.help_karma_clean_half = [[
Wenn das Karma eines Spielers über dem Startniveau liegt (was bedeutet, dass das maximale Karma so konfiguriert wurde, dass es höher ist), werden alle Karma-Erhöhungen reduziert, basierend darauf, wie weit ihr Karma über diesem Startniveau liegt. Das bedeutet, dass es langsamer steigt, je höher es ist.

Diese Reduzierung erfolgt in einer Kurve exponentiellen Zerfalls: Anfangs ist sie schnell und verlangsamt sich, wenn die Inkremente kleiner werden. Diese Einstellung legt fest, an welchem Punkt der Bonus halbiert wurde (also die Halbwertszeit). Mit dem Standardwert von 0,25, wenn die Startmenge des Karmas 1000 beträgt und das Maximum 1500 beträgt, und ein Spieler Karma 1125 hat ((1500 - 1000) * 0,25 = 125), dann wird sein Saubere-Runde-Bonus 30 / 2 = 15 betragen. Um den Bonus schneller zu verringern, würde man diesen Wert niedriger einstellen, um ihn langsamer zu verringern, würde man ihn in Richtung 1 erhöhen.]]
L.help_max_slots = "Setzt die maximale Anzahl von Waffen pro Slot. '-1' bedeutet, dass es keine Begrenzung gibt."
L.help_item_armor_value = "Dies ist der Rüstungswert, der durch den Rüstungsgegenstand im dynamischen Modus verliehen wird. Wenn der klassische Modus aktiviert ist (siehe 'Administration' -> 'Spieler-Einstellungen'), wird jeder Wert größer als 0 als vorhandene Rüstung betrachtet."

L.label_killer_dna_range = "Maximale Tötungsentfernung, um DNA zu hinterlassen"
L.label_killer_dna_basetime = "Basiszeit für die Lebensdauer der Probe"
L.label_dna_scanner_slots = "DNA-Proben Slots"
L.label_dna_radar = "Aktiviere den klassischen DNA Scanner Modus"
L.label_dna_radar_cooldown = "DNA Scanner Abklingzeit"
L.label_radar_charge_time = "Aufladezeit nach Verwendung"
L.label_crowbar_shove_delay = "Abklingzeit nach einem Brechstangenschubser"
L.label_idle = "Aktiviere den Inaktivitäts Modus"
L.label_idle_limit = "Maximale inaktive Zeit in Sekunden"
L.label_namechange_kick = "Aktiviere Kick bei Namensänderung"
L.label_namechange_bantime = "Sperrzeit in Minuten nach dem Kick"
L.label_log_damage_for_console = "Aktiviere Schadensprotokollierung in der Konsole"
L.label_damagelog_save = "Speichere Schadensprotokollierung auf der Festplatte"
L.label_debug_preventwin = "Verhindere jegliche Gewinnbedingung [debug]"
L.label_bots_are_spectators = "Bots sind immer Zuschauer"
L.label_tbutton_admin_show = "Zeige Verräterknöpfe für Admins"
L.label_ragdoll_carrying = "Aktiviere das Tragen von Ragdolls"
L.label_prop_throwing = "Aktiviere das Werfen von Props"
L.label_weapon_carrying = "Aktiviere das Tragen von Waffen"
L.label_weapon_carrying_range = "Tragreichweite für Waffen"
L.label_prop_carrying_force = "Prop Aufhebkraft"
L.label_teleport_telefrags = "Töte blockierende Spieler beim Teleportieren (telefrag)"
L.label_allow_discomb_jump = "Erlaube Discombobulator-Sprünge für den Werfer"
L.label_spawn_wave_interval = "Intervall zwischen den Spawn-Wellen in Sekunden"
L.label_voice_enable = "Aktiviere Sprachchat"
L.label_voice_drain = "Aktiviere die Sprachchat Batterie"
L.label_voice_drain_normal = "Entladung pro Tick für normale Spieler"
L.label_voice_drain_admin = "Entladung pro Tick für Admins und öffentliche Ordnungsrollen"
L.label_voice_drain_recharge = "Aufladungsrate pro Tick wenn nicht gesprochen wird"
L.label_locational_voice = "Aktiviere Proximity Sprachchat für lebende Spieler"
L.label_locational_voice_prep = "Aktiviere Proximity Sprachchat während der Vorbereitungszeit"
L.label_locational_voice_range = "Proximity Sprachchat Reichweite"
L.label_armor_on_spawn = "Spielerrüstung beim (Neu-)Spawnen"
L.label_prep_respawn = "Aktiviere automatischen Respawn während der Vorbereitungszeit"
L.label_preptime_seconds = "Vorbereitungszeit in Sekunden"
L.label_firstpreptime_seconds = "Erste Vorbereitungszeit in Sekunden"
L.label_roundtime_minutes = "Fixe Rundenzeit in Minuten"
L.label_haste = "Aktiviere Hast Modus"
L.label_haste_starting_minutes = "Hast Modus Startzeit in Minuten"
L.label_haste_minutes_per_death = "Zusätzliche Zeit pro Tod in Minuten"
L.label_posttime_seconds = "Zeit nach der Runde in Sekunden"
L.label_round_limit = "Rundenlimit"
L.label_time_limit_minutes = "Spielzeitlimit"
L.label_nade_throw_during_prep = "Erlaube das Werfen von Granaten während der Vorbereitungszeit"
L.label_postround_dm = "Aktiviere Deathmatch nach Rundenende"
L.label_spectator_chat = "Aktiviere, dass Zuschauer mit jedem chatten können"
L.label_lastwords_chatprint = "Gib die letzten Worte im Chat aus, wenn der Spieler getötet wird, während er tippt"
L.label_identify_body_woconfirm = "Leichnam identifizieren, ohne die Schaltfläche 'Tod Bestätigen' drücken zu müssen"
L.label_announce_body_found = "Ankündigen, dass ein Leichnam gefunden wurde, wenn dieser bestätigt wird"
L.label_confirm_killlist = "Die Todesliste des bestätigten Leichnams verkünden"
L.label_dyingshot = "Beim Tod schießen, wenn Visier aktiv [experimentell]"
L.label_armor_block_headshots = "Aktiviere das Blockieren von Kopfschüssen durch Rüstung"
L.label_armor_block_blastdmg = "Aktiviere das Blockieren von Explosionsschaden durch Rüstung"
L.label_armor_dynamic = "Aktiviere dynamische Rüstung"
L.label_armor_value = "Anzahl an Rüstung welche vom Rüstungsgegenstand gegeben wird"
L.label_armor_damage_block_pct = "Prozentsatz des durch die Rüstung aufgenommenen Schadens"
L.label_armor_damage_health_pct = "Prozentsatz des durch den Spieler aufgenommenen Schadens"
L.label_armor_enable_reinforced = "Aktiviere verstärkte Rüstung"
L.label_armor_threshold_for_reinforced = "Schwelle für verstärkte Rüstung"
L.label_sherlock_mode = "Aktiviere den Sherlock Modus"
L.label_highlight_admins = "Server Admins hervorherben"
L.label_highlight_dev = "TTT2 Entwickler hervorherben"
L.label_highlight_vip = "TTT2 Supporter hervorherben"
L.label_highlight_addondev = "TTT2 Addon Entwickler hervorherben"
L.label_highlight_supporter = "Andere hervorherben"
L.label_enable_hud_element = "Aktiviere das {elem} HUD Element"
L.label_spec_prop_control = "Aktiviere Prop Übernahme"
L.label_spec_prop_base = "Übernahme Basiswert"
L.label_spec_prop_maxpenalty = "Untere Übernahme-Bonus-Grenze"
L.label_spec_prop_maxbonus = "Obere Übernahme-Bonus-Grenze"
L.label_spec_prop_force = "Prop Übernahme Stoßkraft"
L.label_spec_prop_rechargetime = "Aufladezeit in Sekunden"
L.label_doors_force_pairs = "Behandle nahestehende Türen als Doppeltüren"
L.label_doors_destructible = "Aktiviere zerstörbare Türen"
L.label_doors_locked_indestructible = "Standardmäßig versperrte Türen sind unzerstörbar"
L.label_doors_health = "Tür-Lebenspunkte"
L.label_doors_prop_health = "Zerstörte-Tür-Lebenspunkte"
L.label_minimum_players = "Mindestspieleranzahl, um die Runde zu starten"
L.label_karma = "Aktiviere Karma"
L.label_karma_strict = "Aktiviere strenges Karma"
L.label_karma_starting = "Initiales Karma"
L.label_karma_max = "Maximales Karma"
L.label_karma_ratio = "Strafverhältnis für Team-Schäden"
L.label_karma_kill_penalty = "Strafverhältnis für Team-Tötungen"
L.label_karma_round_increment = "Karma Wiederherstellung"
L.label_karma_clean_bonus = "Saubere Runde Bonus"
L.label_karma_traitordmg_ratio = "Bonusverhältnis für Schäden an Feinden"
L.label_karma_traitorkill_bonus = "Bonus für das Töten von Feinden"
L.label_karma_clean_half = "Reduzierung des 'Saubere-Runde'-Bonus"
L.label_karma_persist = "Karma bleibt über Kartenwechsel erhalten"
L.label_karma_low_autokick = "Spieler mit niedrigem Karma automatisch rauswerfen"
L.label_karma_low_amount = "Schwellenwert für niedriges Karma"
L.label_karma_low_ban = "Banne Spieler mit zu niedrigem Karma"
L.label_karma_low_ban_minutes = "Bann-Zeit in Minuten"
L.label_karma_debugspam = "Aktiviere Debug-Ausgabe in die Konsole über Karma-Veränderungen"
L.label_max_melee_slots = "Maximale Nahkampf Slots"
L.label_max_secondary_slots = "Maximale Sekundär Slots"
L.label_max_primary_slots = "Maximale Primär Slots"
L.label_max_nade_slots = "Maximale Granat Slots"
L.label_max_carry_slots = "Maximale Trage Slots"
L.label_max_unarmed_slots = "Maximale Unbewaffnete Slots"
L.label_max_special_slots = "Maximale Spezial Slots"
L.label_max_extra_slots = "Maximale extra Slots"
L.label_weapon_autopickup = "Aktiviere automatisches Aufheben von Waffen"
L.label_sprint_enabled = "Aktiviere Sprinten"
L.label_sprint_max = "Geschwindigkeitsboostfaktor"
L.label_sprint_stamina_consumption = "Faktor für den Verbrauch von Ausdauer"
L.label_sprint_stamina_regeneration = "Faktor für die Regeneration von Ausdauer"
L.label_crowbar_unlocks = "Der Primärangriff kann als Interaktion (z. B. Entsperren) verwendet werden"
L.label_crowbar_pushforce = "Brechstangen-Schubsstärke"

-- 2022-07-02
L.header_playersettings_falldmg = "Fallschaden Einstellungen"

L.label_falldmg_enable = "Aktiviere Fallschaden"
L.label_falldmg_min_velocity = "Mindestgeschwindigkeit, bei der Fallschaden auftritt."
L.label_falldmg_exponent = "Exponent mit dem der Fallschaden in Relation zur Geschwindigkeit erhöht wird"

L.help_falldmg_exponent = [[
Dieser Wert verändert, wie exponentiell der Fallschaden mit der Geschwindigkeit zunimmt, mit der der Spieler auf den Boden aufprallt.

Sei vorsichtig bei der Änderung dieses Werts. Wenn er zu hoch eingestellt wird, kann selbst der kleinste Sturz tödlich sein, während ein zu niedriger Wert es Spielern ermöglicht, aus extremen Höhen zu fallen und nur wenig oder gar keinen Schaden zu erleiden.]]

-- 2023-02-08
L.testpopup_title = "Ein Test Popup, jetzt auch mit Mehrzeilen-Titel, wie cool!"
L.testpopup_subtitle = "Nun, hallo! Dies ist ein schickes Popup mit einigen besonderen Informationen. Der Text kann auch mehrzeilig sein, wie schick! Oh, ich könnte noch so viel mehr Text hinzufügen, wenn ich Ideen hätte..."

L.hudeditor_chat_hint1 = "[TTT2][INFO] Fahre mit der Maus über ein Element, drücke und halte [LMT] und bewege die Maus, um es zu VERSCHIEBEN oder zu VERGRÖßERN."
L.hudeditor_chat_hint2 = "[TTT2][INFO] Halte die ALT-Taste gedrückt, um eine symmetrische Vergrößerung/Verkleinerung durchzuführen."
L.hudeditor_chat_hint3 = "[TTT2][INFO] Halte die UMSCHALT-Taste gedrückt, um auf der Achse zu bewegen und das Seitenverhältnis beizubehalten."
L.hudeditor_chat_hint4 = "[TTT2][INFO] Drücke [RMT] -> 'Schließen' um den HUD Editor zu beenden!"

L.guide_nothing_title = "Hier gibt es noch nichts zu sehen!"
L.guide_nothing_desc = "Dieser Bereich ist noch in Arbeit. Hilf uns dabei, indem du auf GitHub dazu beiträgst."

L.sb_rank_tooltip_developer = "TTT2 Entwickler"
L.sb_rank_tooltip_vip = "TTT2 Supporter"
L.sb_rank_tooltip_addondev = "TTT2 Addon Entwickler"
L.sb_rank_tooltip_admin = "Server Admin"
L.sb_rank_tooltip_streamer = "Streamer"
L.sb_rank_tooltip_heroes = "TTT2 Heroes"
L.sb_rank_tooltip_team = "Team"

L.tbut_adminarea = "ADMIN BEREICH:"

-- 2023-08-10
L.equipmenteditor_name_damage_scaling = "Schadensskalierung"

-- 2023-08-11
L.equipmenteditor_name_allow_drop = "Erlaube Fallenlassen"
L.equipmenteditor_desc_allow_drop = "Wenn aktiviert, kann Ausrüstung beliebig vom Spieler fallengelassen werden"

L.equipmenteditor_name_drop_on_death_type = "Fallenlassen beim Tod"
L.equipmenteditor_desc_drop_on_death_type = "Versuche, die Aktion zu überschreiben, die festlegt, ob die Ausrüstung beim Tod des Spielers fallengelassen wird."

L.drop_on_death_type_default = "Standard (pro Waffe definiert)"
L.drop_on_death_type_force = "Erzwinge Fallenlassen beim Tod"
L.drop_on_death_type_deny = "Verhindere Fallenlassen beim Tod"

-- 2023-08-26
L.equipmenteditor_name_kind = "Ausrüstungs Slot"
L.equipmenteditor_desc_kind = "Der Inventar Slot, welcher von Ausrüstungsgegenständen verwendet wird"

L.slot_weapon_melee = "Nahrkampf Slot"
L.slot_weapon_pistol = "Pistolen Slot"
L.slot_weapon_heavy = "Schwerer Slot"
L.slot_weapon_nade = "Granaten Slot"
L.slot_weapon_carry = "Trage Slot"
L.slot_weapon_unarmed = "Unbewaffneter Slot"
L.slot_weapon_special = "Spezial Slot"
L.slot_weapon_extra = "Extra Slot"
L.slot_weapon_class = "Klassen Slot"

-- 2023-10-04
L.label_voice_duck_spectator = "Dämpfe Zuschauerstimmen"
L.label_voice_duck_spectator_amount = "Zuschauerdämpfung"
L.label_voice_scaling = "Skalierungsmodus der Lautstärke der Stimme"
L.label_voice_scaling_mode_linear = "Linear"
L.label_voice_scaling_mode_power4 = "Hoch 4"
L.label_voice_scaling_mode_log = "Logarithmisch"

-- 2023-10-07
L.search_title = "Ergebnisse der Leichenuntersuchung - {player}"
L.search_info = "Information"
L.search_confirm = "Tod bestätigen"
L.search_confirm_credits = "Bestätigen (+{credits} Ausrüstungspunkt(e))"
L.search_take_credits = "Nehme {credits} Ausrüstungspunkt(e)"
L.search_confirm_forbidden = "Bestätigen verboten"
L.search_confirmed = "Tod bestätigt"
L.search_call = "Tod melden"
L.search_called = "Tod gemeldet"

--L.search_team_role_unknown = "???"

L.search_words = "Etwas sagt dir, dass die letzten Worte des Opfers \"{lastwords}\" waren."
L.search_armor = "Das Opfer trug eine nicht-standardmäßige Körperrüstung."
L.search_disguiser = "Das Opfer trug ein Gerät, dass die Identität verstecken konnte."
L.search_radar = "Das Opfer trug eine Form eines Radars. Es funktioniert nicht mehr."
L.search_c4 = "In der Tasche war eine Notiz. Sie besagt, dass das Durchschneiden des Drahtes {num} die Bombe sicher entschärfen wird."

L.search_dmg_crush = "Viele Knochen des Opfers sind gebrochen. Es scheint, als habe der Einschlag eines schweren Objekts zum Tode geführt."
L.search_dmg_bullet = "Es ist offensichtlich, dass das Opfer erschossen wurde."
L.search_dmg_fall = "Das Opfer fiel in den Tod."
L.search_dmg_boom = "Die Wunden und die versengte Kleidung weisen auf eine Explosion hin, die das Ende bereitet hat."
L.search_dmg_club = "Der Körper ist ramponiert und verbeult. Das Opfer wurde mit Sicherheit zu Tode geprügelt."
L.search_dmg_drown = "Der Körper zeigt Anzeichen und Symptome von Ertrinken."
L.search_dmg_stab = "Das Opfer wurde stark geschnitten und hatte tiefe Wunden und verblutete schlussendlich."
L.search_dmg_burn = "Es riecht hier nach gerösteten Terroristen..."
L.search_dmg_teleport = "Es scheint, als wäre die DNA durch Tachyonen verunstaltet worden!"
L.search_dmg_car = "Als das Opfer die Straße überquerte, wurde es von einem rücksichtslosen Fahrer überrollt."
L.search_dmg_other = "Du kannst keinen spezifischen Grund für den Tod des Opfers finden."

L.search_floor_antlions = "Es gibt immer noch Ameisenlöwen überall am Körper. Der Boden muss mit ihnen bedeckt sein."
L.search_floor_bloodyflesh = "Das Blut an diesem Körper sieht alt und eklig aus. Es sind sogar kleine Stücke blutigen Fleisches an den Schuhen kleben geblieben."
L.search_floor_concrete = "Grauer Staub bedeckt die Schuhe und Knie. Es sieht so aus, als hätte der Tatort einen Betonboden."
L.search_floor_dirt = "Es riecht erdig. Das kommt wahrscheinlich von dem Schmutz, der an den Schuhen des Opfers haftet."
L.search_floor_eggshell = "Ekelhaft aussehende weiße Flecken bedecken den Körper des Opfers. Es sieht aus wie Eierschalen."
L.search_floor_flesh = "Die Kleidung des Opfers fühlt sich irgendwie feucht an. Als ob es auf eine nasse Oberfläche gefallen wäre. Wie eine fleischige Oberfläche oder der sandige Boden eines Gewässers."
L.search_floor_grate = "Die Haut des Opfers sieht aus wie ein Steak. Dicke Linien, die in einem Raster angeordnet sind, sind überall auf ihr sichtbar. Hat es auf einem Rost gelegen?"
L.search_floor_alienflesh = "Außerirdisches Fleisch, denkst du? Klingt ziemlich abwegig. Aber dein Detektivhilfebuch führt es als mögliche Bodenoberfläche auf."
L.search_floor_snow = "Auf den ersten Blick fühlt sich die Kleidung nur nass und eiskalt an. Aber sobald du den weißen Schaum an den Rändern siehst, verstehst du es. Es ist Schnee!"
L.search_floor_plastic = "'Autsch, das muss wehtun.' Der Körper ist von Verbrennungen bedeckt. Sie sehen aus wie die, die entstehen, wenn man über eine Plastikoberfläche rutscht."
L.search_floor_metal = "Zumindest kann das Opfer jetzt keine Tetanusinfektion bekommen, da es tot ist. Rost bedeckt die Wunden. Es ist wahrscheinlich auf einer metallischen Oberfläche gestorben."
L.search_floor_sand = "Kleine grobe Steine kleben am kalten Körper des Opfers. Wie rauer Sand vom Strand. Er ist einfach überall!"
L.search_floor_foliage = "Die Natur ist wunderbar. Die blutigen Wunden des Opfers sind mit genügend Laub bedeckt, dass sie fast versteckt sind."
L.search_floor_computer = "Beep-boop. Der Körper ist von einer Computeroberfläche bedeckt! Wie sieht das aus, fragst du vielleicht? Nun, wer weiß!"
L.search_floor_slosh = "Feucht und vielleicht sogar ein wenig schleimig. Der ganze Körper ist damit bedeckt und die Kleider sind durchnässt. Es stinkt!"
L.search_floor_tile = "Kleine Scherben kleben an der Haut. Wie Scherben von Bodenfliesen, die beim Aufprall zerbrochen sind."
L.search_floor_grass = "Es riecht nach frisch geschnittenem Gras. Der Geruch überwältigt fast den Geruch von Blut und Tod."
L.search_floor_vent = "Du spürst einen frischen Luftstoß, wenn du den Körper berührst. Ist das Opfer in einem Lüftungsschacht gestorben und hat die Luft mitgenommen?"
L.search_floor_wood = "Was gibt es Schöneres, als auf einem Holzboden zu sitzen und in Gedanken zu versinken? Zumindest nicht tot auf einem Holzboden liegen!"
L.search_floor_default = "Das scheint so grundlegend, so normal. Fast standardmäßig. Du kannst nichts über die Art der Oberfläche sagen."
L.search_floor_glass = "Der Körper ist mit vielen blutigen Schnitten bedeckt. In einigen von ihnen stecken Glasscherben, die ziemlich bedrohlich aussehen."
L.search_floor_warpshield = "Ein Boden aus Warpshield? Ja, wir sind genauso verwirrt wie du es warst. Aber unsere Notizen erwähnen es eindeutig. Warpshield."

L.search_water_1 = "Die Schuhe des Opfers sind nass, aber der Rest scheint trocken zu sein. Es wurden wahrscheinlich getötet, während die Füße im Wasser waren."
L.search_water_2 = "Die Schuhe und Hosen des Opfers sind durchnässt. Ist es durch Wasser gelaufen, bevor es getötet wurde?"
L.search_water_3 = "Der gesamte Körper ist nass und geschwollen. Es ist wahrscheinlich gestorben, während es vollständig untergetaucht war."

L.search_weapon = "Es scheint, als wurde ein(e) {weapon} zum töten benutzt."
L.search_head = "Die tödliche Wunde war ein Kopfschuss. Keine Zeit, um zu schreien."
L.search_time = "Das Opfer wurde eine Weile bevor du die Untersuchung begonnen hast getötet."
L.search_dna = "Erlange eine Probe der DNA des Mörders mit dem DNA-Scanner. Die DNA-Probe verfällt nach einer Weile."

L.search_kills1 = "Du fandest eine Liste an Tötungen, die den Tod von {player} beweist."
L.search_kills2 = "Du fandest eine Liste an Tötungen mit diesen Namen: {player}"
L.search_eyes = "Mit deinen Detektiv-Fähigkeiten identifizierst du die Person, die vom Opfer zuletzt gesehen wurde: {player}. Der Mörder oder ein Zufall?"

L.search_credits = "Das Opfer hat {credits} Ausrüstungspunkt(e) in der Tasche. Eine Shopping-Rolle könnte sie an sich nehmen und sinnvoll verwenden. Behalte es im Auge!"

L.search_kill_distance_point_blank = "Es war ein Angriff aus nächster Nähe."
L.search_kill_distance_close = "Der Angriff erfolgte aus kurzer Entfernung."
L.search_kill_distance_far = "Das Opfer wurde aus großer Entfernung angegriffen."

L.search_kill_from_front = "Das Opfer wurde von vorne erschossen."
L.search_kill_from_back = "Das Opfer wurde von hinten erschossen."
L.search_kill_from_side = "Das Opfer wurde von der Seite erschossen."

L.search_hitgroup_head = "Das Projektil wurde im Kopf gefunden."
L.search_hitgroup_chest = "Das Projektil wurde in der Brust gefunden."
L.search_hitgroup_stomach = "Das Projektil wurde im Bauch gefunden."
L.search_hitgroup_rightarm = "Das Projektil wurde im rechten Arm gefunden."
L.search_hitgroup_leftarm = "Das Projektil wurde im linken Arm gefunden."
L.search_hitgroup_rightleg = "Das Projektil wurde im rechten Bein gefunden."
L.search_hitgroup_leftleg = "Das Projektil wurde im linken Bein gefunden."
L.search_hitgroup_gear = "Das Projektil wurde in der Hüfte gefunden."

L.search_policingrole_report_confirm = [[
Eine öffentliche Ordnungsrolle kann nur zu einer Leiche gerufen werden, nachdem der Tod des Opfers bestätigt wurde.]]
L.search_policingrole_confirm_disabled_1 = [[
Die Leiche kann nur von einer öffentlichen Ordnungsrolle bestätigt werden. Melde die Leiche, um sie zu informieren!]]
L.search_policingrole_confirm_disabled_2 = [[
Die Leiche kann nur von einer öffentlichen Ordnungsrolle bestätigt werden. Melde die Leiche, um sie darüber zu informieren!
Du kannst die Informationen hier sehen, nachdem sie es bestätigt haben.]]
L.search_spec = [[
Als Zuschauer kannst du alle Informationen einer Leiche sehen, bist aber nicht in der Lage, mit der Benutzeroberfläche zu interagieren.]]

L.search_title_words = "Die letzten Worte des Opfers"
L.search_title_c4 = "Missgeschick bei der Entschärfung"
L.search_title_dmg_crush = "Quetschschaden ({amount} HP)"
L.search_title_dmg_bullet = "Kugelschaden ({amount} HP)"
L.search_title_dmg_fall = "Fallschaden ({amount} HP)"
L.search_title_dmg_boom = "Explosionsschaden ({amount} HP)"
L.search_title_dmg_club = "Schlagstockschaden ({amount} HP)"
L.search_title_dmg_drown = "Ertrinkungsschaden ({amount} HP)"
L.search_title_dmg_stab = "Stichschaden ({amount} HP)"
L.search_title_dmg_burn = "Brandschaden ({amount} HP)"
L.search_title_dmg_teleport = "Teleportationsschaden ({amount} HP)"
L.search_title_dmg_car = "Autounfall ({amount} HP)"
L.search_title_dmg_other = "Unbekannter Schaden ({amount} HP)"
L.search_title_time = "Todeszeit"
L.search_title_dna = "Zerfall von DNA-Proben"
L.search_title_kills = "Die Tötungsliste des Opfers"
L.search_title_eyes = "Der Schatten des Mörders"
L.search_title_floor = "Der Boden des Tatorts"
L.search_title_credits = "{credits} Ausrüstungspunkt(e)"
L.search_title_water = "Wasserpegel {level}"
L.search_title_policingrole_report_confirm = "Bestätige um den Tod zu melden"
L.search_title_policingrole_confirm_disabled = "Leiche melden"
L.search_title_spectator = "Du bist ein Zuschauer"

L.target_credits_on_confirm = "Bestätige Toten, um ungenutzte Ausrüstungspunkte zu erhalten"
L.target_credits_on_search = "Untersuchen, um ungenutzte Ausrüstungspunkte zu erhalten"
L.corpse_hint_no_inspect_details = "Nur öffentliche Ordnungsrollen können Informationen über diese Leiche finden."
L.corpse_hint_inspect_limited_details = "Nur öffentliche Ordnungsrollen können diesen Körper bestätigen."
L.corpse_hint_spectator = "Drücke [{usekey}] um die Untersuchungs-UI anzuzeigen."
L.corpse_hint_public_policing_searched = "Drücke [{usekey}] um die Untersuchungsergebnisse einer öffentlichen Ordnungsrolle einzusehen"

L.label_inspect_confirm_mode = "Wähle den Körfper-Untersuchungsmodus"
L.choice_inspect_confirm_mode_0 = "Modus 0: standard TTT"
L.choice_inspect_confirm_mode_1 = "Modus 1: limitiertes Bestätigen"
L.choice_inspect_confirm_mode_2 = "Modus 2: limitiertes Untersuchen"
L.help_inspect_confirm_mode = [[
Es gibt drei verschiedene Körper-Untersuchungs-/Bestätigungsmodi in diesem Spielmodus. Die Auswahl dieses Modus hat einen großen Einfluss auf die Wichtigkeit von öffentlichen Ordnungsrollen wie den Detektiv.

Modus 0: Dieser Modus ist der standard TTT-Modus. Jeder kann Körper untersuchen und bestätigen. Um einen Körper zu melden, oder die Ausrüstungspunkte zu nehmen, muss der Körper zuerst bestätigt werden. Dies macht es etwas schwerer für Shopping-Rollen heimlich an die Ausrüstungspunkte zu kommen. Jedoch müssen auch Unschuldige den Körper zuerst melden, bevor sie eine öffentliche Ordnungsrolle rufen können.

Modus 1: Dieser Modus erhöht die Wichtigkeit von öffentlichen Ordnungsrollen, indem die Bestätigungsoption auf diese limitiert wird. Das bedeutet auch, dass das Nehmen von Ausrüstungspunkten und das Melden von Körpern nun vor dem Bestätigen möglich ist. Jeder ist in der Lage Leichen zu untersuchen und Informationen dadurch zu gewinnen, diese können aber nicht an alle verkündet werden.

Modus 2: Diser Modus ist noch etwas strikter als Modus 1. In diesem Modus wird die Untersuchungsoption für normale Spieler ebenfalls entfernt. Das bedeutet, dass das melden von Leichen an eine öffentliche Ordnungsrolle nun der einzige Weg ist, um an Informationen der Leiche zu kommen.]]

-- 2023-10-19
L.label_grenade_trajectory_ui = "Anzeige der Granatenflugbahn"

-- 2023-10-23
L.label_hud_pulsate_health_enable = "Pulsieren der Lebensleiste bei weniger als 25% Gesundheit"
L.header_hud_elements_customize = "Passe die HUD-Elemente an"
L.help_hud_elements_special_settings = "Dies sind die HUD-Element spezifischen Einstellungen."

-- 2023-10-25
L.help_keyhelp = [[
Tastenhelfer sind ein UI Element, welches dauerhaft relevante Tastenbelegungen für den Spieler anzeigen. Gerade unerfahrene Spieler können hiervon profitieren. Es gibt drei unterschiedliche Kategorien von Tastenbelegungen:

Core: Diese Kategorie enthält die wichtigsten Tastenbelegungen in TTT2. Ohne diese ist es schwer das volle Potential von TTT2 zu nutzen.
Extra: Ähnlich zu 'core', enthält aber eher nicht durchgehend nötige Tastenbelegungen. Dinge wie der Chat, Sprachchat und Taschenlampe sind hier enthalten. Gerade für neue Spieler kann das aktivieren sinnvoll sein.
Equipment: Ausrüstungsgegenstände können eigene Tastenbelegungen haben, diese werden in dieser Kategorie angezeigt.

Deaktivierte Kategorien werden weiterhin angezeigt solange die Punktetafel geöffnet ist]]

L.label_keyhelp_show_core = "Aktiviere dauerhaftes anzeigen der 'core' Tastenhelfer"
L.label_keyhelp_show_extra = "Aktiviere dauerhaftes anzeigen der 'extra' Tastenhelfer"
L.label_keyhelp_show_equipment = "Aktiviere dauerhaftes anzeigen der 'equipment' Tastenhelfer"

L.header_interface_keys = "Tastenhelfer Einstellungen"
L.header_interface_wepswitch = "Waffenwechsel UI Einstellungen"

L.label_keyhelper_help = "öffne Spielmodus Menü"
L.label_keyhelper_mutespec = "Wechsle Zuschauer Sprachmodus"
L.label_keyhelper_shop = "öffne Ausrüstungsshop"
L.label_keyhelper_show_pointer = "Befreie Mauszeiger"
L.label_keyhelper_possess_focus_entity = "fokusiertes Objekt übernehmen"
L.label_keyhelper_spec_focus_player = "fokusiertem Spieler zuschauen"
L.label_keyhelper_spec_previous_player = "vorheriger Spieler"
L.label_keyhelper_spec_next_player = "nächster Spieler"
L.label_keyhelper_spec_player = "Spieler zuschauen"
L.label_keyhelper_possession_jump = "Objekt: springen"
L.label_keyhelper_possession_left = "Objekt: links"
L.label_keyhelper_possession_right = "Objekt: rechts"
L.label_keyhelper_possession_forward = "Objekt: vorwärts"
L.label_keyhelper_possession_backward = "Objekt: rückwärts"
L.label_keyhelper_free_roam = "verlasse Objekt und bewege dich frei"
L.label_keyhelper_flashlight = "Taschenlampe an-/ausschalten"
L.label_keyhelper_quickchat = "Schnellchat öffnen"
L.label_keyhelper_voice_global = "Globaler Sprachchat"
L.label_keyhelper_voice_team = "Team Sprachchat"
L.label_keyhelper_chat_global = "Globaler Chat"
L.label_keyhelper_chat_team = "Team Chat"
L.label_keyhelper_show_all = "Alle anzeigen"
L.label_keyhelper_disguiser = "Tarnung an-/ausschalten"
L.label_keyhelper_save_exit = "Speichern und Verlassen"
L.label_keyhelper_spec_third_person = "Wechsle Ansicht aus dritter Person"

-- 2023-10-26
L.item_armor_reinforced = "Verstärkte Rüstung"
L.item_armor_sidebar = "Rüstung bietet dir etwas Schutz vor Kugelschüssen. Aber nicht auf Dauer."
L.item_disguiser_sidebar = "Die Tarnung versteckt deine Identität vor anderen Spielern."
L.status_speed_name = "Geschwindigkeits Faktor"
L.status_speed_description_good = "Du bist schneller als normal. Gegenstände, Ausrüstung oder verschiedene Effekte können dies beeinflussen."
L.status_speed_description_bad = "Du bist langsamer als normal. Gegenstände, Ausrüstung oder verschiedene Effekte können dies beeinflussen."

L.status_on = "an"
L.status_off = "aus"

L.crowbar_help_primary = "Zuschlagen"
L.crowbar_help_secondary = "Spieler schubsen"

-- 2023-10-27
L.help_HUD_enable_description = [[
Manche HUD-Elemente, wie der Tastenhelfer oder die Seitenleiste, zeigen detailliertere Informationen an, wenn das Scoreboard offen ist. Dies kann deaktiviert werden, um Unordnung zu reduzieren.]]
L.label_HUD_enable_description = "Aktiviere Beschreibungen, wenn das Scoreboard offen ist"
L.label_HUD_enable_box_blur = "Aktiviere Hintergrund-Verschwommenheit der UI-Box"

-- 2023-10-28
L.submenu_gameplay_voiceandvolume_title = "Sprache & Lautstärke"
L.header_soundeffect_settings = "Sound Effekte"
L.header_voiceandvolume_settings = "Sprache- & Lautstärkeeinstellungen"

-- 2023-11-06
L.drop_reserve_prevented = "Etwas hindert dich daran, deine Reserve-Munition abzulegen."
L.drop_no_reserve = "Nicht genügend Munition in deinem Vorrat, um als Munitionskiste abgelegt zu werden."
L.drop_no_room_ammo = "Hier ist kein Platz, um deine Munition fallen zu lassen!"

-- 2023-11-14
L.hat_deerstalker_name = "Detektivshut"

-- 2023-11-16
L.help_prop_spec_dash = [[
Propspec-Schübe sind Bewegungen in Richtung des Zielvektors. Sie können eine höhere Kraft als die normale Bewegung haben. Eine höhere Kraft bedeutet auch einen höheren Verbrauch des Basiswerts.

Diese Variable ist ein Multiplikator der Push-Force.]]
L.label_spec_prop_dash = "Schubkraft Multiplikator"
L.label_keyhelper_possession_dash = "prop: Schub in Blickrichtung"
L.label_keyhelper_weapon_drop = "wenn möglich, ausgewählte Waffe ablegen"
L.label_keyhelper_ammo_drop = "Munition der ausgewählten Waffe aus dem Magazin ablegen"

-- 2023-12-07
L.c4_help_primary = "C4 Platzieren"
L.c4_help_secondary = "An Oberfläche kleben"

-- 2023-12-11
L.magneto_help_primary = "Entität wegschieben"
L.magneto_help_secondary = "Entität heranziehen / aufheben"
L.knife_help_primary = "Stechen"
L.knife_help_secondary = "Messer werfen"
L.polter_help_primary = "Feuere Klopfer"
L.polter_help_secondary = "Langstreckenschuss aufladen"

-- 2023-12-12
L.newton_help_primary = "Rückstoßschuss"
L.newton_help_secondary = "Aufgeladener Rückstoßschuss"

-- 2023-12-13
L.vis_no_pickup = "Nur öffentliche Ordnungsrollen können den Visualisierer aufheben"
L.newton_force = "KRAFT"
L.defuser_help_primary = "Ausgewähltes C4 entschärfen"
L.radio_help_primary = "Radio platzieren"
L.radio_help_secondary = "An Oberfläche kleben"
L.hstation_help_primary = "Gesundheitsstation platzieren"
L.flaregun_help_primary = "Körper/Entität verbrennen"

-- 2023-12-14
L.marker_vision_owner = "Besitzer: {owner}"
L.marker_vision_distance = "Distanz: {distance}"
L.marker_vision_distance_collapsed = "{distance}"

L.c4_marker_vision_time = "Explosionszeit: {time}"
L.c4_marker_vision_collapsed = "{time} / {distance}"

L.c4_marker_vision_safe_zone = "Bombensicherheitszone"
L.c4_marker_vision_damage_zone = "Bombenschadenszone"
L.c4_marker_vision_kill_zone = "Bombentötungszone"

L.beacon_marker_vision_player = "Verfolgter Spieler"
L.beacon_marker_vision_player_tracked = "Dieser Spieler wird von einem Peilsender verfolgt."

-- 2023-12-18
L.beacon_help_pri = "Peilsender auf den Boden werfen"
L.beacon_help_sec = "Peilsender an Oberfläche kleben"
L.beacon_name = "Peilsender"
L.beacon_desc = [[
Überträgt die Spielerpositionen an alle in einer Kugel um diesen Peilsender herum.

Verwenden, um Orte auf der Karte im Auge zu behalten, die schwer zu sehen sind.]]

L.msg_beacon_destroyed = "Einer deiner Peilsender wurde zerstört!"
L.msg_beacon_death = "Ein Spieler ist in unmittelbarer Nähe eines deiner Peilsender gestorben."

L.beacon_short_desc = "Peilsender werden von öffentlichen Ordnungsrollen verwendet, um lokale Wallhacks um sie herum hinzuzufügen"

L.entity_pickup_owner_only = "Nur der Besitzer kann dies aufheben"

L.body_confirm_one = "{finder} bestätigte den Tod von {victim}."
L.body_confirm_more = "{finder} bestätigte {count} Tode von: {victims}."

-- 2023-12-19
L.builtin_marker = "Integriert."
L.equipmenteditor_desc_builtin = "Diese Ausrüstung ist integriert, sie kommt mit TTT2!"
L.help_roles_builtin = "Diese Rolle ist integriert, sie kommt mit TTT2!"
L.header_equipment_info = "Ausrüstungsinformationen"

-- 2023-12-20
L.equipmenteditor_desc_damage_scaling = [[Multipliziert den Basisschadenswert der Waffe um diesen Faktor.
Für eine Schrotflinte würde sich dies auf jedes Geschoss auswirken.
Für ein Gewehr würde sich dies nur auf die Kugel auswirken.
Für den Poltergeist würde sich dies auf jeden Stoß und die finale Explosion auswirken.

0.5 = Halbiert den zugefügten Schaden.
2 = Verdoppelt den zugefügten Schaden.

Notiz: Einige Waffen verwenden diesen Wert möglicherweise nicht, was dazu führt, dass dieser Modifikator unwirksam ist.]]

-- 2023-12-24
L.submenu_gameplay_accessibility_title = "Barrierefreiheit"

L.header_accessibility_settings = "Einstellungen für Barrierefreiheit"

L.label_enable_dynamic_fov = "Aktiviere das dynamische Sichtfeld"
L.label_enable_bobbing = "Aktiviere 'Sichtwackeln'"
L.label_enable_bobbing_strafe = "Aktiviere 'Sichtwackeln' beim seitwärts gehen"

L.help_enable_dynamic_fov = "Das dynamische Sichtfeld wird je nach Geschwindigkeit des Spielers angewendet. Wenn ein Spieler zum Beispiel rennt, wird das Sichtfeld vergrößert, um die Geschwindigkeit zu visualisieren."
L.help_enable_bobbing_strafe = "'View bobbing' ist das leichte Kamerawackeln beim Gehen, Schwimmen oder Fallen."

L.binoc_help_reload = "Ziel löschen."
L.cl_sb_row_sresult_direct_conf = "Direkte Bestätigung"
L.cl_sb_row_sresult_pub_police = "Bestätigung einer öffentlichen Ordnungsrolle"

-- 2024-01-05
L.label_crosshair_thickness_outline_enable = "Aktiviere Umrandung des Fadenkreuz"
L.label_crosshair_outline_high_contrast = "Aktiviere hohen Kontrast der Umrandung"
L.label_crosshair_mode = "Fadenkreuzmodus"
L.label_crosshair_static_length = "Aktiviere konstante Länge der Fadenkreuzlinien"

L.choice_crosshair_mode_0 = "Linien und Punkt"
L.choice_crosshair_mode_1 = "Nur Linien"
L.choice_crosshair_mode_2 = "Nur Punkt"

L.help_crosshair_scale_enable = [[
Das dynamische Fadenkreuz ermöglicht das Skalieren des Fadenkreuzes je nach Streukegel der Waffe. Der Streukegel wird von der Basisgenauigkeit der Waffe beeinflusst, multipliziert mit externen Faktoren wie Springen und Sprinten.

Wenn die Linienlänge konstant bleibt, skaliert nur der Abstand mit den Streukegeländerungen.]]

L.header_weapon_settings = "Waffeneinstellungen"

-- 2024-01-24
L.grenade_fuse = "LUNTE"

-- 2024-01-25
L.header_roles_magnetostick = "Magneto-Stick"
L.label_roles_ragdoll_pinning = "Aktivere das anheften von Ragdolls"
L.magneto_stick_help_carry_rag_pin = "Ragdoll anheften"
L.magneto_stick_help_carry_rag_drop = "Ragdoll fallenlassen"
L.magneto_stick_help_carry_prop_release = "Prop freilassen"
L.magneto_stick_help_carry_prop_drop = "Prop fallenlassen"

-- 2024-01-27
L.decoy_help_primary = "Platziere die Attrappe"
L.decoy_help_secondary = "Attrappe an Oberfläche kleben"


L.marker_vision_visible_for_0 = "Für dich sichtbar"
L.marker_vision_visible_for_1 = "Für deine Rolle sichtbar"
L.marker_vision_visible_for_2 = "Für dein Team sichtbar"
L.marker_vision_visible_for_3 = "Für jeden sichtbar"

-- 2024-02-14
L.throw_no_room = "Hier ist kein Platz, um dieses Gerät zu werfen."

-- 2024-03-04
--L.use_entity = "Press [{usekey}] to use"

-- 2024-03-06
--L.submenu_gameplay_sounds_title = "Client-Sounds"

--L.header_sounds_settings = "UI Sound Settings"

--L.help_enable_sound_interact = "Interaction sounds are those sounds that are played when opening an UI. Such a sound is played for example when interacting with the radio marker."
--L.help_enable_sound_buttons = "Button sounds are clicky sounds that are played when clicking a button."
--L.help_enable_sound_message = "Message or notification sounds are played for chat messages and notifications. They can be quite obnoxious."

--L.label_enable_sound_interact = "Enable interaction sounds"
--L.label_enable_sound_buttons = "Enable button sounds"
--L.label_enable_sound_message = "Enable message sounds"

--L.label_level_sound_interact = "Interaction sound level multiplier"
--L.label_level_sound_buttons = "Button sound level multiplier"
--L.label_level_sound_message = "Message sound level multiplier"

-- 2024-03-07
--L.label_crosshair_static_gap_length = "Enable static crosshair gap size"
--L.label_crosshair_size_gap = "Crosshair gap size multiplier"

-- 2024-03-31
--L.help_locational_voice = "Proximity chat is TTT2's implementation of locational 3D voice. Players are only audible in a set radius around them and become quieter the farther away they are."
--L.help_locational_voice_prep = [[By default the proximity chat is disabled in the preparing phase. If this option enabled, proximity chat is also enabled in the preparing phase.
--
--Note: Proximity chat is always disabled during the post round phase.]]
--L.help_voice_duck_spectator = "Muffling spectators makes other spectators quieter in comparison to living players. This can be useful if you want to listen closely to the discussions of the living players."

--L.help_equipmenteditor_configurable_clip = [[The configurable size defines the amount of uses the weapon has when bought in the shop or spawned in the world.
--
--Note: This setting is only available for weapons that enable this feature.]]
--L.label_equipmenteditor_configurable_clip = "Configurable clip size"

-- 2024-04-06
--L.help_locational_voice_range = [[This option constrains the maximum range at which players can hear each other. It does not change how the volume decreases with distance but rather sets a hard cut-off point.
--
--Set to 0 to disable this cut-off.]]

-- 2024-04-07
L.help_voice_activation = [[Stellt ein, wie dein Mikro für den globalen Sprachchat aktiviert wird. Alle Optionen nutzen deine 'Globaler Sprachchat'-Taste. Der Team Sprachchat nutzt immer always Push-to-Talk.

Push-to-Talk: Halte die Taste gedrückt, um zu sprechen.
Push-to-Mute: Dein Mikro ist immer an, halte die Taste gedrückt um dich stumm zu stellen.
Umschalten: Drücke einmal die Taste, um dein Mikro an-/auszuschalten.
Umschalten (Aktiviert zum Start): Wie 'Umschalten', zusätzlich wird dein Mikro beim Server-Beitritt angeschaltet.]]
L.label_voice_activation = "Sprachchat Aktivierungsmodus"
L.label_voice_activation_mode_ptt = "Push-to-Talk"
L.label_voice_activation_mode_ptm = "Push-to-Mute"
L.label_voice_activation_mode_toggle_disabled = "Umschalten"
L.label_voice_activation_mode_toggle_enabled = "Umschalten (Aktiviert zum Start)"

-- 2024-04-08
--L.label_inspect_credits_always = "Allow all players to see credits on dead bodies"
--L.help_inspect_credits_always = [[
--When shopping roles die, their credits can be picked up by other players with shopping roles.
--
--When this option is disabled, only players that can pick up credits can see them on a body.
--When enabled, all players can see credits on a body.]]

-- 2024-05-13
--L.menu_commands_title = "Admin Commands"
--L.menu_commands_description = "Change maps, spawn bots and edit player roles."

--L.submenu_commands_maps_title = "Maps"

--L.header_maps_prefixes = "Enable/Disable Maps by their Prefix"
--L.header_maps_select = "Select and Change Maps"

--L.button_change_map = "Change Map"

-- 2024-05-20
--L.submenu_commands_commands_title = "Commands"

--L.header_commands_round_restart = "Round Restart"
--L.header_commands_player_slay = "Slay Player"
--L.header_commands_player_teleport = "Teleport Player to Focused Point"
--L.header_commands_player_respawn = "Respawn Player at Focused Point"
--L.header_commands_player_add_credits = "Add Equipment Credits"
--L.header_commands_player_set_health = "Set Health"
--L.header_commands_player_set_armor = "Set Armor"

--L.label_button_round_restart = "round restart"
--L.label_button_player_slay = "slay player"
--L.label_button_player_teleport = "teleport player"
--L.label_button_player_respawn = "respawn player"
--L.label_button_player_add_credits = "add credits"
--L.label_button_player_set_health = "set health"
--L.label_button_player_set_armor = "set armor"

--L.label_slider_add_credits = "Set credit amount"
--L.label_slider_set_health = "Set health"
--L.label_slider_set_armor = "Set armor"

--L.label_player_select = "Select affected player"
--L.label_execute_command = "Execute command"

-- 2024-05-22
--L.tip38 = "You can pick up focused weapons by pressing {usekey}. It will automatically drop you blocking weapon."
--L.tip39 = "You can change your key bindings in the bindings menu, located in the Settings menu opened with {helpkey}."
--L.tip40 = "On the left side of your screen are icons showing current equipment or status effects applied to you."
--L.tip41 = "If you open your scoreboard, the sidebar and key helper show additional information."
--L.tip42 = "The key helper at the bottom of your screen shows relevant bindings available to you at that moment."
--L.tip43 = "The icon next to the name of a confirmed corpse shows the role of the deceased player."

--L.header_loadingscreen = "Loading Screen"

--L.help_enable_loadingscreen = "The loading screen is shown when the map refreshes after a round. It is introduced to hide the visible and audible lag that appears on big maps. It is also used to show gameplay tips."

--L.label_enable_loadingscreen = "Enable the loading screen"
--L.label_enable_loadingscreen_tips = "Enable tips on loading screen"

-- 2024-05-25
--L.help_round_restart_reset = [[
--Restart a round or reset the level.
--
--Restarting a round only restarts the current round so you can start over. Resetting the level clears everything so that the game starts new as if it is fresh after a map change.]]

--L.label_button_level_reset = "reset level"

--L.loadingscreen_round_restart_title = "Starting new round"
--L.loadingscreen_round_restart_subtitle_limits_mode_0 = "you're playing on {map}"
--L.loadingscreen_round_restart_subtitle_limits_mode_1 = "you're playing on {map} for another {rounds} round(s) or {time}"
--L.loadingscreen_round_restart_subtitle_limits_mode_2 = "you're playing on {map} for {time}"
--L.loadingscreen_round_restart_subtitle_limits_mode_3 = "you're playing on {map} for another {rounds} round(s)"

-- 2024-06-23
--L.header_roles_derandomize = "Role Derandomization"

--L.help_roles_derandomize = [[
--Role derandomization can be used to make role distribution feel more fair over the course of a session.
--
--In essence, when it is enabled, a player's chance of receiving a role increases while they have not been assigned that role. While this can feel more fair, this also enables metagaming, where a player can guess that another will be traitor-aligned based on the fact that they have not been traitor aligned in several rounds. Do not enable this option if this is undesirable.
--
--There are 4 modes:
--
--mode 0: Disabled - No derandomization is done.
--
--mode 1: Base roles only - Derandomization is performed for base roles only. Subroles will be selected randomly. These are roles like Innocent and Traitor.
--
--mode 2: Subroles only - Derandomization is performed for subroles only. Base roles will be selected randomly. Note that subroles are only assigned to players which have already been selected for their base role.
--
--mode 3: Base roles AND subroles - Derandomization is performed for both base roles and subroles.]]
--L.label_roles_derandomize_mode = "Derandomization mode"
--L.label_roles_derandomize_mode_none = "mode 0: Disabled"
--L.label_roles_derandomize_mode_base_only = "mode 1: Base roles only"
--L.label_roles_derandomize_mode_sub_only = "mode 2: Subroles only"
--L.label_roles_derandomize_mode_base_and_sub = "mode 3: Base roles AND subroles"

--L.help_roles_derandomize_min_weight = [[
--Derandomization is performed by making the random player selections during role distribution use a weight associated with each role for each player, and that weight increases by 1 each time the player does not get assigned that role. These weights are not persisted between connections, or across maps.
--
--Each time a player is assigned a role, the corresponding weight is reset to this minimum weight. This weight does not have any absolute meaning; it can only be interpreted with respect to other weights.
--
--For example, given player A with a weight of 1, and player B with a weight of 5, player B is 5 times more likely than player A to be selected. However, if player A had a weight of 4, player B is only 5/4 times more likely to be selected.
--
--The minimum weight, therefore, effectively controls how much each round affects a player's chance at being selected, with higher values causing it to be affected less. The default value of 1 means that each round causes a fairly significant increase in chance, and conversely, that it is extremely unlikely that a player will get the same role twice in a row.
--
--Changes to this value will not take effect until players reconnect or the map changes.]]
--L.label_roles_derandomize_min_weight = "Derandomization minimum weight"

-- 2024-08-17
--L.name_button_default = "Button"
--L.name_button_rotating = "Lever"

--L.button_default = "Press [{usekey}] to trigger"
--L.button_rotating = "Press [{usekey}] to flip"

--L.undefined_key = "???"

-- 2024-08-18
--L.header_commands_player_force_role = "Force Player Role"

--L.label_button_player_force_role = "force role"

--L.label_player_role = "Select role"

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
