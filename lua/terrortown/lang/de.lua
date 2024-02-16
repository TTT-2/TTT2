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

-- Scoreboard
L.sb_playing = "Du spielst auf..."
L.sb_mapchange = "Die Karte wechselt in {num} Runden oder in {time}"
L.sb_mapchange_disabled = "Das Sitzungslimit ist deaktiviert."

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
L.equip_tooltip_xfer = "Credits transferieren"
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
L.reroll_no_credits = "Du brauchst {amount} Credits zum neu ausrollen!"
L.reroll_button = "Reroll"
L.reroll_help = "Verwende {amount} Credits, um ein neues zufälliges Set von Ausrüstungsgegenständen in deinem Shop zu erhalten!"

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
L.label_crosshair_size = "Fadenkreuz Größe"
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
L.label_interface_tips_enable = "Zeige Tipps zum Spiel während des Zuschauens am unteren Bildschirmrand"
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

L.label_bind_weaponswitch = "Waffe aufheben"
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
--L.corpse_hint_inspect_limited = "Press [{usekey}] to search. [{walkkey} + {usekey}] to only view search UI."

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

L.tooltip_finish_score_alive_teammates = "Lebende Teammitglieder: {score}"
L.tooltip_finish_score_alive_all = "Lebende Spieler: {score}"
L.tooltip_finish_score_timelimit = "Zeit vorbei: {score}"
L.tooltip_finish_score_dead_enemies = "Tote Gegner: {score}"
L.tooltip_kill_score = "Mord: {score}"
L.tooltip_bodyfound_score = "Leichenfund: {score}"

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
Das Neuauswürfeln ermöglicht es dir, für Credits ein neues zufälliges Ausrüstungsset zu erhalten.]]
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
L.equipmenteditor_name_credits = "Kosten in Credits"

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
L.submenu_administration_rolelayering_title = "Rollenebenen"
L.header_rolelayering_info = "Rollenebeneninformationen"
L.help_rolelayering_roleselection = "Der Rollenverteilungsprozess ist in zwei Phasen unterteilt. In der ersten Phase werden Basisrollen verteilt, zu denen Unschuldige, Verräter und diejenigen gehören, welche in der 'Basisrollenebene' unten aufgeführt sind. Die zweite Phase dient dazu, diese Basisrollen zu Unterrollen aufzuwerten."
L.help_rolelayering_layers = "Aus jeder Ebene wird nur eine Rolle ausgewählt. Zuerst werden die Rollen aus den benutzerdefinierten Ebenen verteilt, beginnend mit der ersten Ebene, bis die letzte erreicht ist oder keine Rollen mehr aufgewertet werden können. Was auch immer zuerst passiert, wenn noch aufwertbare Slots verfügbar sind, werden auch die nicht geschichteten Rollen verteilt."
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

L.submenu_administration_roles_general_title = "Allgemeine Rolleneinstellungen"

L.header_roles_info = "Roleninformationen"
L.header_roles_selection = "Rollenauswahlparameter"
L.header_roles_tbuttons = "Zugriff zu Verräterknöpfen"
L.header_roles_credits = "Rollenausrüstungspunkte"
L.header_roles_additional = "Weitere Rolleneinstellungen"
L.header_roles_reward_credits = "Belohnungsausrüstungspunkte"

L.help_roles_default_team = "Standardteam: {team}"
L.help_roles_unselectable = "Diese Rolle ist nicht verteilbar. Sie wird im Rollenverteilungsprozess nicht berücksichtigt. In den meisten Fällen handelt es sich dabei um eine Rolle, die während der Runde manuell durch ein Ereignis wie eine Wiederbelebung, eine Sidekick-Deagle oder etwas Ähnliches zugewiesen wird."
L.help_roles_selectable = "Diese Rolle ist verteilbar. Wenn alle Kriterien erfüllt sind, wird diese Rolle im Rollenverteilungsprozess berücksichtigt."
L.help_roles_credits = "Credits werden verwendet, um Ausrüstung im Shop zu kaufen. Es ergibt meistens Sinn, sie nur für die Rollen zu vergeben, die Zugang zu Shops haben. Da es jedoch möglich ist, Credits in Leichen zu finden, kannst du Rollen auch Startcredits als Belohnung für ihren Mörder geben."
L.help_roles_selection_short = "Die Rollenverteilung pro Spieler definiert den Prozentsatz der Spieler, denen diese Rolle zugewiesen wird. Zum Beispiel, wenn der Wert auf '0,2' eingestellt ist, erhält jeder fünfte Spieler diese Rolle."
L.help_roles_selection = [[
Die Rollenverteilung pro Spieler definiert den Prozentsatz der Spieler, denen diese Rolle zugewiesen wird. Zum Beispiel, wenn der Wert auf '0,2' eingestellt ist, erhält jeder fünfte Spieler diese Rolle. Dies bedeutet auch, dass mindestens 5 Spieler benötigt werden, damit diese Rolle überhaupt verteilt wird.
Beachte, dass all dies nur gilt, wenn die Rolle für den Verteilungsprozess berücksichtigt wird.

Die oben genannte Rollenverteilung hat eine besondere Integration mit der unteren Spielerbegrenzung. Wenn die Rolle für die Verteilung in Betracht gezogen wird und der Mindestwert unter dem Wert liegt, der durch den Verteilungsfaktor angegeben wird, aber die Anzahl der Spieler gleich oder größer als die untere Begrenzung ist, kann immer noch ein einzelner Spieler diese Rolle erhalten. Der Verteilungsprozess funktioniert dann wie gewohnt für den zweiten Spieler.]]
L.help_roles_award_info = "Einige Rollen (wenn in ihren Credit-Einstellungen aktiviert) erhalten Credits, wenn ein bestimmter Prozentsatz an Feinden gestorben ist. Die damit verbundenen Werte können hier angepasst werden."
L.help_roles_award_pct = "Wenn dieser Prozentsatz der Feinde tot ist, erhalten bestimmte Rollen Credits als Belohnung."
L.help_roles_award_repeat = "Ob die Creditvergabe mehrmals erfolgt. Zum Beispiel, wenn der Prozentsatz auf '0.25' eingestellt ist und diese Einstellung aktiviert ist, erhalten Spieler bei '25%', '50%' und '75%' toten Feinden jeweils Ausrüstungspunkte."
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
Es gibt zwei verschiedene Möglichkeiten, um in Basis-TTT2 Credits zu erhalten:

1. Wenn ein bestimmter Prozentsatz des feindlichen Teams tot ist, erhält das gesamte Team Credits.
2. Wenn ein Spieler einen Spieler mit einer 'öffentlichen Rolle' wie einem Detektiv getötet hat, werden dem Mörder Credits verliehen.

Bitte beachte, dass dies immer noch für jede Rolle aktiviert/deaktiviert werden kann, selbst wenn das gesamte Team belohnt wird. Zum Beispiel, wenn das Team Unschuldige belohnt wird, aber die Rolle Unschuldiger diese Funktion deaktiviert hat, erhält nur der Detektiv seine Credits.
Die Balanceeinstellungen für diese Funktion können in 'Administration' -> 'Allgemeine Rolleneinstellungen' festgelegt werden.]]
L.help_detective_hats = [[
Öffentliche Ordnungsrollen wie der Detektiv können Hüte tragen, um ihre Autorität zu zeigen. Sie verlieren diese Hüte bei ihrem Tod oder wenn der Kopf beschädigt wird.

Einige Spielermodelle unterstützen standardmäßig keine Hüte. Dies kann in 'Administration' -> 'Spielermodell' geändert werden.]]

L.label_roles_credits_award_kill = "Anzahl an Credits für die Tötung"
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
L.label_session_limits_enabled = "Aktiviere Sitzungs Limitierungen"
L.label_spectator_chat = "Aktiviere, dass Zuschauer mit jedem chatten können"
L.label_lastwords_chatprint = "Gib die letzten Worte im Chat aus, wenn der Spieler getötet wird, während er tippt"
L.label_identify_body_woconfirm = "Leichnam identifizieren, ohne die Schaltfläche 'Tod Bestätigen' drücken zu müssen."
--L.label_announce_body_found = "Announce that a body was found when the body was confirmed"
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
L.label_sprint_max = "Maximale Sprint-Ausdauer"
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
--L.search_confirm_credits = "Confirm (+{credits} Credit(s))"
--L.search_take_credits = "Take {credits} Credit(s)"
--L.search_confirm_forbidden = "Confirm forbidden"
--L.search_confirmed = "Death Confirmed"
--L.search_call = "Report Death"
--L.search_called = "Death Reported"

--L.search_team_role_unknown = "???"

L.search_words = "Etwas sagt dir, dass die letzten Worte dieser Person \"{lastwords}\" waren."
L.search_armor = "Sie trug eine nicht-standardmäßige Körperrüstung."
L.search_disguiser = "Sie trug ein Gerät, dass ihre Identität verstecken konnte."
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
L.search_dmg_teleport = "Es scheint, als sei ihre DNA durch Tachyonen verunstaltet worden!"
L.search_dmg_car = "Als diese Person die Straße überquerte, wurde sie von einem rücksichtslosen Fahrer überrollt."
L.search_dmg_other = "Du kannst keinen spezifischen Grund für den Tod dieser Person finden."

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

L.search_weapon = "Es scheint, als wurde ein(e) {weapon} benutzt, um sie zu töten."
L.search_head = "Die tödliche Wunde war ein Kopfschuss. Keine Zeit, um zu schreien."
L.search_time = "Sie wurde eine Weile bevor du die Untersuchung begonnen hast getötet."
L.search_dna = "Erlange eine Probe der DNA des Mörders mit dem DNA-Scanner. Die DNA-Probe verfällt nach einer Weile."

L.search_kills1 = "Du fandest eine Liste an Tötungen, die den Tod von {player} beweist."
L.search_kills2 = "Du fandest eine Liste an Tötungen mit diesen Namen: {player}"
L.search_eyes = "Mit deinen Detektiv-Fähigkeiten identifizierst du die letzte Person, die sie sah: {player}. Der Mörder oder ein Zufall?"

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

L.target_credits_on_confirm = "Bestätige Toten, um ungenutzte Credits zu erhalten"
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
L.body_confirm_one = "{finder} bestätigte den Tod von {victim}."
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
L.decoy_help_primary = "Platziere die Attrappe"
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
