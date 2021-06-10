-- Spanish language strings

local L = LANG.GetLanguageTableReference("es")

-- Compatibility language name that might be removed soon.
-- the alias name is based on the original TTT language name:
-- https://github.com/Facepunch/garrysmod/blob/master/garrysmod/gamemodes/terrortown/gamemode/lang/spanish.lua
L.__alias = "Español"

L.lang_name = "Español (Spanish)"

-- General text used in various places
L.traitor = "Traidor"
L.detective = "Detective"
L.innocent = "Inocente"
L.last_words = "Últimas Palabras"

L.terrorists = "Terroristas"
L.spectators = "Espectadores"

L.nones = "Sin Equipo"
L.innocents = "Equipo Inocentes"
L.traitors = "Equipo Traidores"

-- Round status messages
L.round_minplayers = "No hay jugadores suficientes para empezar la ronda..."
L.round_voting = "Votación en curso, retrasando la nueva ronda {num} segundos..."
L.round_begintime = "Una nueva ronda comenzará en {num} segundos ¡Preparate!"
L.round_selected = "Los traidores han sido seleccionados."
L.round_started = "¡La ronda ha comenzado!"
L.round_restart = "La ronda fue reiniciada por un administrador."

L.round_traitors_one = "Eres el Traidor, estás solo."
L.round_traitors_more = "Eres el Traidor. Estos son tus aliados: {names}"

L.win_time = "Te has quedado sin tiempo. Los traidores pierden."
L.win_traitors = "¡Los Traidores han ganado!"
L.win_innocents = "¡Los Inocentes han ganado!"
L.win_nones = "¡Las Abejas han ganado! (Empate)"
L.win_showreport = "Veamos el reporte de la ronda por {num} segundos."

L.limit_round = "Límite de rondas alcanzado. El siguiente mapa se cargará pronto."
L.limit_time = "Tiempo límite alcanzado. El siguiente mapa cargará pronto."
L.limit_left = "{num} rondas o {time} minutos restantes para que el mapa cambie."

-- Credit awards
L.credit_all = "Tu equipo fue recompensado con {num} créditos por su desempeño."
L.credit_kill = "Has recibido {num} crédito(s) por matar un {role}."

-- Karma
L.karma_dmg_full = "¡Tu karma es {amount}, por lo que harás todo el daño esta ronda!"
L.karma_dmg_other = "¡Tu karma es {amount}. Como resultado, tu daño se ve reducido en {num}%"

-- Body identification messages
L.body_found = "{finder} encontró el cuerpo de {victim}. {role}"
L.body_found_team = "{finder} encontró el cuerpo de {victim}. {role} ({team})"

-- The {role} in body_found will be replaced by one of the following:
L.body_found_traitor = "¡Era un Traidor!"
L.body_found_det = "Era un Detective."
L.body_found_inno = "Era un Inocente."

L.body_confirm = "{finder} confirmó la muerte de {victim}."

L.body_call = "¡{player} llamó a un detective al cuerpo de {victim}!"
L.body_call_error = "¡Debes confirmar el cadáver antes de llamar a un detective!"

L.body_burning = "¡Ouch! ¡Este cuerpo está incendiándose!"
L.body_credits = "¡Has encontrado {num} créditos en este cuerpo!"

-- Menus and windows
L.close = "Cerrar"
L.cancel = "Cancelar"

-- For navigation buttons
L.next = "Siguiente"
L.prev = "Atrás"

-- Equipment buying menu
L.equip_title = "Equipamiento"
L.equip_tabtitle = "Menú de compra"

L.equip_status = "Estado de la compra"
L.equip_cost = "Tienes {num} crédito(s) restantes."
L.equip_help_cost = "Cada pieza de equipamiento que compres cuesta cierta cantidad de créditos."

L.equip_help_carry = "Sólo puedes comprar cosas para las que haya espacio en tu inventario."
L.equip_carry = "Puedes equiparte este objeto."
L.equip_carry_own = "Ya tienes ese objeto equipado."
L.equip_carry_slot = "Ya estás llevando un arma en el espacio {slot}."
L.equip_carry_minplayers = "No hay jugadores suficientes en el servidor para activar esta arma."

L.equip_help_stock = "Algunos objetos puedes comprarlos únicamente una vez por ronda."
L.equip_stock_deny = "Este objeto no tiene stock."
L.equip_stock_ok = "Este objeto está disponible."

L.equip_custom = "Objeto personalizado del servidor."

L.equip_spec_name = "Nombre"
L.equip_spec_type = "Tipo"
L.equip_spec_desc = "Descripción"

L.equip_confirm = "Comprar equipamiento"

-- Disguiser tab in equipment menu
L.disg_name = "Disfraz"
L.disg_menutitle = "Control de Disfraz"
L.disg_not_owned = "¡No estás llevando un disfraz!"
L.disg_enable = "Activar disfraz"

L.disg_help1 = "Cuando tu disfraz esté activo, tu nombre, vida y karma no se mostrarán cuando alguien te mire. Además, estarás oculto del radar del detective."
L.disg_help2 = "Pulsa la telca Enter del Numpad para activar el disfraz sin tener que usar de menú. También puedes configurar una tecla bajo el comando 'ttt_toggle_disguise' usando la consola."

-- Radar tab in equipment menu
L.radar_name = "Radar"
L.radar_menutitle = "Control del Radar"
L.radar_not_owned = "¡No estás llevando un Radar!"
L.radar_scan = "Realizar escaneo"
L.radar_auto = "Repetir escaneo"
L.radar_help = "Resultado del escaneo mostrándose durante {num} segundos. Luego de estos segundos el Radar se re-activará"
L.radar_charging = "¡Tu radar todavia se está cargando!"

-- Transfer tab in equipment menu
L.xfer_name = "Transferir"
L.xfer_menutitle = "Transferir créditos"
L.xfer_send = "Envía un crédito"

L.xfer_no_recip = "Receptor no válido, transferencia cancelada."
L.xfer_no_credits = "Créditos insuficientes."
L.xfer_success = "Transferencia de créditos a {player} completada."
L.xfer_received = "{player} te ha dado {num} crédito(s)."

-- Radio tab in equipment menu
L.radio_name = "Radio"
L.radio_help = "Haz clic un botón para que tu radio reproduzca sonido."
L.radio_notplaced = "Debes colocar la radio para que suene."

-- Radio soundboard buttons
L.radio_button_scream = "Grito"
L.radio_button_expl = "Explosión"
L.radio_button_pistol = "Disparos de pistola"
L.radio_button_m16 = "Disparos de M16"
L.radio_button_deagle = "Disparos de Deagle"
L.radio_button_mac10 = "Disparos de MAC10"
L.radio_button_shotgun = "Disparos de Escopeta"
L.radio_button_rifle = "Disparos de Rifle"
L.radio_button_huge = "Ráfaga de H.U.G.E."
L.radio_button_c4 = "Pitido de C4"
L.radio_button_burn = "Fuego"
L.radio_button_steps = "Pasos"

-- Intro screen shown after joining
L.intro_help = "¡Si eres nuevo en el juego pulsa F1 para ver el tutorial!"

-- Radiocommands/quickchat
L.quick_title = "Teclas de acceso rápido a chat"

L.quick_yes = "Si."
L.quick_no = "No."
L.quick_help = "¡Ayuda!"
L.quick_imwith = "Estoy con {player}."
L.quick_see = "Veo a {player}."
L.quick_suspect = "{player} es sospechoso."
L.quick_traitor = "¡{player} es un Traidor!"
L.quick_inno = "{player} es Inocente."
L.quick_check = "¿Queda alguien vivo?"

-- {player} in the quickchat text normally becomes a player nickname, but can
-- also be one of the below.  Keep these lowercase.
L.quick_nobody = "nadie"
L.quick_disg = "alguien disfrazado"
L.quick_corpse = "un cuerpo sin identificar"
L.quick_corpse_id = "el cadáver de {player}"

-- Body search window
L.search_title = "Resultados de búsqueda"
L.search_info = "Información"
L.search_confirm = "Confirmar Muerte"
L.search_call = "Llamar a un Detective"

-- Descriptions of pieces of information found
L.search_nick = "Este es el cuerpo de {player}."

L.search_role_traitor = "¡Esta persona era un Traidor!"
L.search_role_det = "Esta persona era Inocente."
L.search_role_inno = "Esta persona era un terrorista inocente."

L.search_words = "Algo te dice una de las últimas palabras de esta persona fueron: '{lastwords}'"
L.search_armor = "Estaba utilizando protección antibalas."
L.search_disg = "Estaba utilizando un dispositivo para camuflar su identidad."
L.search_radar = "Estaba llevando un radar. Pero ya no funciona."
L.search_c4 = "En el bolsillo encuentras una nota. Pone que cortando el cable {num} se desactiva una bomba."

L.search_dmg_crush = "Varios de sus huesos están rotos. Parece ser que ha muerto por el impacto de un objeto."
L.search_dmg_bullet = "Es evidente que le han disparado hasta morir."
L.search_dmg_fall = "Cayó directo hacia su muerte."
L.search_dmg_boom = "Sus heridas y la ropa chamuscada indican que una explosión acabó con la vida de esta persona."
L.search_dmg_club = "El cuerpo está golpeado y amorotonado. Fue apalizado hasta la muerte."
L.search_dmg_drown = "El cuerpo muestra signos de axfisia. Ha muerto ahogado"
L.search_dmg_stab = "Fue apuñalado y cortado para después desangrarse rápidamente hasta morir."
L.search_dmg_burn = "Aquí huele a terrorista quemado..."
L.search_dmg_tele = "¡Parece que su ADN fue alterado por partículas de taquión!"
L.search_dmg_car = "Cuando este terrorista quiso crusar la calle, fue atropellado por un conductor descuidado."
L.search_dmg_other = "No puedes determinar la causa de muerte de esta persona."

L.search_weapon = "Parece que se uso un/una {weapon} para matarlo."
L.search_head = "Murió de un solo disparo en la cabeza. No le dio tiempo a gritar."
L.search_time = "Murió apróximadamente {time} antes de empezar la investigación."
L.search_dna = "Recoge una muestra del ADN del asesino con un Escáner ADN. La muestra de ADN caducará en {time}."

L.search_kills1 = "Has encontrado una lista de asesinatos que confirman la muerte de {player}."
L.search_kills2 = "Has encontrado una lista de asesinatos con los siguientes nombres:"
L.search_eyes = "Gracias a tus habilidades de detective, has identificado que la última persona a la que vio fue: {player}. ¿Es el asesino o sólo fue una coincidencia?"

-- Scoreboard
L.sb_playing = "Estás jugando en..."
L.sb_mapchange = "El mapa cambia en {num} rondas o en {time}"

L.sb_mia = "Perdido en Acción"
L.sb_confirmed = "Muerto confirmado"

L.sb_ping = "Ping"
L.sb_deaths = "Muertes"
L.sb_score = "Punt."
L.sb_karma = "Karma"

L.sb_info_help = "Investiga el cadáver de este jugador, puedes revisar los resultados aquí."

L.sb_tag_friend = "AMIGO"
L.sb_tag_susp = "SOSPECHOSO"
L.sb_tag_avoid = "EVITAR"
L.sb_tag_kill = "MATAR"
L.sb_tag_miss = "PERDIDO"

-- Equipment actions, like buying and dropping
L.buy_no_stock = "Esta arma ya no tiene stock: ya la has comprado en esta ronda."
L.buy_pending = "Tienes una orden de compra pendiente, espera a recibirla."
L.buy_received = "Has recibido tu equipamiento especial."

L.drop_no_room = "¡No tienes espacio para arrojar tu arma!"

L.disg_turned_on = "¡Disfraz activado!"
L.disg_turned_off = "Disfraz desactivado."

-- Equipment item descriptions
L.item_passive = "Objeto de uso pasivo"
L.item_active = "Objeto de uso activo"
L.item_weapon = "Arma"

L.item_armor = "Chaleco Antibalas"
L.item_armor_desc = [[
Reduce el daño de bala, fuego y explosivo. Se desgasta con el uso.

Puede ser comprado múltiples veces. Tras alcanzar cierto valor de armadura, el chaleco se vuelve más resistente.]]

L.item_radar = "Radar"
L.item_radar_desc = [[
Permite detectar señales de vida.

Empieza por si solo luego de ser comprado. Configúrelo en la pestaña del radar.]]

L.item_disg = "Disfraz"
L.item_disg_desc = [[
Esconde tu ID mientras está en uso. Además evita ser la última persona vista por una víctima.

Actívalo en la pestaña disfraz de este menú o presiona el numpad Enter.]]

-- C4
L.c4_hint = "Presiona {usekey} para activar o desactivar."
L.c4_disarm_warn = "Un C4 que has plantado fue desactivado."
L.c4_armed = "Has activado la bomba correctamente."
L.c4_disarmed = "Has desactivado la bomba correctamente."
L.c4_no_room = "No puedes llevar este C4 contigo."

L.c4_desc = "Artefacto explosivo programado."

L.c4_arm = "Activar C4"
L.c4_arm_timer = "Temporizador"
L.c4_arm_seconds = "Segundos antes de la detonación:"
L.c4_arm_attempts = "Al intentar desactivarlo, {num} de los 6 cables causarán una explosión instantánea al ser cortados."

L.c4_remove_title = "Remover"
L.c4_remove_pickup = "Recoger C4"
L.c4_remove_destroy1 = "Destruir C4"
L.c4_remove_destroy2 = "Confirmar: destruir"

L.c4_disarm = "Desactivar C4"
L.c4_disarm_cut = "Click para cortar el cable {num}"

L.c4_disarm_owned = "Corta un cable para desactivar la bomba. Es tu bomba, así que cualquier cable la desactivará."
L.c4_disarm_other = "Corta un cable para desactivar la bomba ¡Explotará si cortas el incorrecto!"

L.c4_status_armed = "ACTIVADA"
L.c4_status_disarmed = "DESACTIVADA"

-- Visualizer
L.vis_name = "Visualizador"
L.vis_hint = "Pulsa {usekey} para recogerlo (Sólo detectives)."

L.vis_desc = [[
Dispositivo para visualizar crímenes.

Analiza el cuerpo para saber cómo la víctima fue aseinada, únicamente si murió por heridas de bala.]]

-- Decoy
L.decoy_name = "Señuelo"
L.decoy_no_room = "No puedes llevar este señuelo."
L.decoy_broken = "¡Tu señuelo fue destruído!"

L.decoy_short_desc = "Este señuelo muestra una señal de vida falsa en el radar"
L.decoy_pickup_wrong_team = "No puedes recogerlo porque pertenece a otro equipo"

L.decoy_desc = [[
Muestra una señal falsa en el radar,y hace que el escáner ADN muestre una falsa localización del señuelo si alguien escanea tu ADN.]]

-- Defuser
L.defuser_name = "Kit de Desactivación"
L.defuser_help = "{primaryfire} desactiva el C4."

L.defuser_desc = [[
Desactiva instantáneamente un C4.

Usos ilimitados. El C4 será más fácil de ver si llevas esto.]]

-- Flare gun
L.flare_name = "Pistola de Bengalas"

L.flare_desc = [[
Puede ser usada para quemar cadáveres para nunca ser encontrados. Munición limitada.

Quemar un cuerpo hace un sonido distintivo.]]

-- Health station
L.hstation_name = "Estación de salud"

L.hstation_broken = "¡Tu estación de salud ha sido destruida!"
L.hstation_help = "{primaryfire} coloca una estación de salud."

L.hstation_desc = [[
Permite que las personas se curen.

Recarga lenta. Cualquiera puede usarlo y puede ser dañada. Puede chequearse por el ADN de las personas que lo usen.]]

-- Knife
L.knife_name = "Cuchillo"
L.knife_thrown = "Cuchillo arrojado"

L.knife_desc = [[
Mata a los objetivos heridos instantáneamente y de manera silenciosa, pero tiene un solo uso.

Puede ser arrojado con el disparo secundario.]]

-- Poltergeist
L.polter_desc = [[
Planta proyectiles en entidades para sacarlas volando violentamente.

El daño de energía daña a las personas en corta distancia.]]

-- Radio
L.radio_broken = "¡Tu radio fue destruida!"
L.radio_help_pri = "{primaryfire} coloca la Radio."

L.radio_desc = [[
Reproduce sonidos para distraer o confundir.

Coloca la radio y luego reproduce sonidos en la pestaña de Radio en este menú.]]

-- Silenced pistol
L.sipistol_name = "Pistola Silenciada"

L.sipistol_desc = [[
Pistola equipada con un silenciador, usa munición de pistola estándar.

Las víctimas asesinadas con este arma no gritarán al morir.]]

-- Newton launcher
L.newton_name = "Cañón Newton"

L.newton_desc = [[
Empuja a las personas desde una distancia segura.

Munición infita pero disparo lento.]]

-- Binoculars
L.binoc_name = "Binoculares"

L.binoc_desc = [[
Apunta a los cadáveres e identifícalos desde una distancia lejana.

Usos ilimitados pero la identificación toma unos segundos.]]

-- UMP
L.ump_desc = [[
SMG Experimental que desorienta a tus objetivos.

Usa la munición estándar de las SMGs.]]

-- DNA scanner
L.dna_name = "Escáner de ADN"
L.dna_notfound = "No se encontraron muestras de ADN en el cadáver."
L.dna_limit = "Se ha alcanzado el límite de almacenamiento. Remueva muestras viejas para adquirir nuevas."
L.dna_decayed = "La muestra de ADN del asesino se ha deteriorado."
L.dna_killer = "¡Se ha encontrado una muestra de ADN del asesino en el cadáver!"
L.dna_duplicate = "¡Duplicado! Ya tienes esta muestra de ADN en tu escáner."
L.dna_no_killer = "El ADN no pudo ser analizado (¿Asesino desconectado?)."
L.dna_armed = "¡Hay una bomba colocada! ¡Desactívala primero!"
L.dna_object = "Se han encontrado {num} muestra(s) de ADN nueva(s) del objeto."
L.dna_gone = "No se han encontrado restos de ADN en esta zona."

L.dna_desc = [[
Toma muestras de ADN a las cosas y úsalas para encontrar el dueño del ADN.

Úsalo en cuerpos frescos para encontrar el ADN del asesino para así encontrarlo y capturarlo.]]

-- Magneto stick
L.magnet_name = "Magnetopalo"
L.magnet_help = "{primaryfire} para colgar el cuerpo a una superficie."

-- Grenades and misc
L.grenade_smoke = "Granada de Humo"
L.grenade_fire = "Granada Incendiaria"

L.unarmed_name = "Sin nada"
L.crowbar_name = "Palanca"
L.pistol_name = "Pistola"
L.rifle_name = "Rifle"
L.shotgun_name = "Escopeta"

-- Teleporter
L.tele_name = "Teletransportador"
L.tele_failed = "Teletransporte fallido."
L.tele_marked = "Destino marcado."

L.tele_no_ground = "¡No puedes teleportarte si no estás en una superficie sólida!"
L.tele_no_crouch = "¡No puedes teleportarte mientras estás agachado!"
L.tele_no_mark = "No hay ningún destino marcado. Marca uno antes de teleportarte."

L.tele_no_mark_ground = "¡No puedes establecer un destino si no estás en una superficie sólida!"
L.tele_no_mark_crouch = "¡No puedes establecer un destino mientras estás agachado!"

L.tele_help_pri = "{primaryfire} teleportarte a la ubicación marcada."
L.tele_help_sec = "{secondaryfire} marca la ubicación actual."

L.tele_desc = [[
Lo teletransporta a una ubicación marcada previamente.

Teletransportarse hace ruido y el número de usos es limitado.]]

-- Ammo names, shown when picked up
L.ammo_pistol = "Munición de 9mm"

L.ammo_smg1 = "Munición de SMG"
L.ammo_buckshot = "Munición de Escopeta"
L.ammo_357 = "Munición de Rifle"
L.ammo_alyxgun = "Munición de Deagle"
L.ammo_ar2altfire = "Munición de Bengalas"
L.ammo_gravity = "Munición de Poltergeist"

-- Round status
L.round_wait = "Esperando"
L.round_prep = "Preparando"
L.round_active = "En progreso"
L.round_post = "Ronda acabada"

-- Health, ammo and time area
L.overtime = "PRÓRROGA"
L.hastemode = "MODO PRISA"

-- TargetID health status
L.hp_healthy = "Saludable"
L.hp_hurt = "Dañado"
L.hp_wounded = "Herido"
L.hp_badwnd = "Gravemente herido"
L.hp_death = "Casi muerto"

-- TargetID karma status
L.karma_max = "Respetable"
L.karma_high = "Vulgar"
L.karma_med = "Gatillo fácil"
L.karma_low = "Peligroso"
L.karma_min = "Responsable"

-- TargetID misc
L.corpse = "Cadáver"
L.corpse_hint = "Pulsa [{usekey}] para inspeccionar. [{walkkey} + {usekey}] para inspeccionar silenciosamente."

L.target_disg = "(disfrazado)"
L.target_unid = "Cuerpo sin identificar"

L.target_credits = "Inspecciona para recibir los créditos no usados"

-- HUD buttons with hand icons that only some roles can see and use
L.tbut_single = "Un solo uso"
L.tbut_reuse = "Reutilizable"
L.tbut_retime = "Reutilizable después de {num} segundos"
L.tbut_help = "Pulsa [{usekey}] para activarlo"

-- Spectator muting of living/dead
L.mute_living = "Jugadores vivos silenciados"
L.mute_specs = "Espectadores silenciados"
L.mute_all = "Todos silenciados"
L.mute_off = "Nadie silenciado"

-- Spectators and prop possession
L.punch_title = "PUÑÓMETRO"
L.punch_help = "Teclas de movimiento o salto: golpea el objeto. Agacharse: dejar el objeto."
L.punch_bonus = "Tu bajo puntaje redujo el límite de tu PUÑÓMETRO a {num}"
L.punch_malus = "¡Tu alto puntaje incrementó el límite de tu PUÑÓMETRO por {num}!"

-- Info popups shown when the round starts
L.info_popup_innocent = [[
¡Eres un terrorista inocente! Pero hay traidores cerca...
¿En quién puedes confiar? ¿Quién estará dispuesto a llenarte de plomo?

¡Cuida de tu espalda y colabora con tus camaradas para salir vivo de esta!]]

L.info_popup_detective = [[
¡Eres un detective! El cuartel general te ha dado herramientas para descubrir a los traidores.
Úsalas para ayudar a los inocentes, pero ten cuidado:
¡Es probable que los traidores intenten matarte primero!

¡Pulsa {menukey} para recibir tus herramientas!]]

L.info_popup_traitor_alone = [[
¡Eres un traidor! No tienes compañeros en esta ronda.

¡Mata a los demás roles para ganar!

¡Presiona {menukey} para recibir tu equipamiento especial!]]

L.info_popup_traitor = [[
¡Eres un traidor! Colabora con tus compañeros asesinando a todos los demás.
Ten cuidado, tu traición puede ser descubierta...

Estos son tus compañeros:
{traitorlist}

¡Pulsa {menukey} para recibir tu equipamiento especial!]]

-- Various other text
L.name_kick = "Un jugador fue automáticamente expulsado por cambiarse de nombre."

L.idle_popup = [[
Estuviste quieto por {num} segundos y como consecuencia fuiste movido al modo Sólo-Espectador. Mientras estés en este modo, no reaparecerás la siguiente ronda.

Siempre puedes entrar o salir del modo Sólo-Espectador usando el menú {helpkey} y desactivando la opción en la configuración. También puedes desactivarlo ahora mismo.]]

L.idle_popup_close = "No hacer nada"
L.idle_popup_off = "Desactivar modo Sólo-Espectador ahora"

L.idle_warning = "Cuidado: ¡Parece que estás ausente/AFK, serás movido a espectador a menos que muestres señales de vida!"

L.spec_mode_warning = "Estás en modo Sólo-Espectador y no reaparecerás cuando una nueva ronda comience. Para desactivar este modo, pulsa F1, ve a Configuración y desactiva el modo 'Sólo-Espectador'."

-- Tips panel
L.tips_panel_title = "Consejos"
L.tips_panel_tip = "Consejo:"

-- Tip texts
L.tip1 = "Los traidores pueden inspeccionar los cuerpos silenciosamente, sin confirmar la muerte, manteniendo {walkkey} y presionando {usekey} en el cadáver."

L.tip2 = "Activar un C4 con un temporizador largo incrementará el número de cables que causan explosión instantánea cuando un inocente intenta desactivarlo. Además, hará menos ruido."

L.tip3 = "Los detectives pueden inspeccionar un cadá ver y ver quién fue 'reflejo en sus ojos'. Esto es la última persona que vio. Si fueron asesinados de otro lado, no tiene por qué ser el asesino. De igual manera es información útil."

L.tip4 = "Nadie sabrá que has muerto hasta que inspeccionen tu cuerpo e identifiquen quién eras."

L.tip5 = "Cuando un traidor mata a un detective, instantáneamente recibirán recompensa con créditos."

L.tip6 = "Cuando un traidor muere, todos los detectives son recompensados con créditos."

L.tip7 = "Cuando un traidor haga un buen trabajo asesinado inocentes, recibirán un crédito como recompensa."

L.tip8 = "Los traidores y los detectives pueden recolectar créditos no gastados de otros traidores y detectives."

L.tip9 = "El Poltergeist puede convertir cualquier objeto en un proyectil mortal. Cada golpe está acompañado de energía que hará daño a las personas cercanas."

L.tip10 = "Como traidor o detective, mantén un ojo en los mensajes rojos en la parte superior derecha de la pantalla. Comúnmente son información importante para tí."

L.tip11 = "Como traidor o detective, recuerda que eres recompensado con créditos si cumples con tu trabajo ¡Recuerda utilizarlos!"

L.tip12 = "El escáner ADN de los detectives puede ser usado para obtener muestras de ADN de armas y objetos y luego obtener la posición de la persona que las utilizó ¡Muy útil cuando puedes obtener ADN de un C4 o un cadáver!"

L.tip13 = "Cuando estés cerca de alguien que asesinaste, algo de tu ADN queda en el cuerpo. Este ADN puede ser usado para encontrar tu posición actual por el detective ¡Mejor esconde bien el cuerpo!"

L.tip14 = "Mientras más lejos estés de la persona que asesinaste más rápido se deteriorará la muestra de ADN restante en su cadáver."

L.tip15 = "¿Eres un traidor y atacás a la distancia? Considera usar el disfraz. Sino conectas un disparo, corre a una posición segura, desactiva el disfraz, y de esa manera nadie sabrá que el que intentó disparar eras tú."

L.tip16 = "Como traidor, el teletransportador puede ayudarte cuando te están persiguiendo y te permite desplazarte grandes distancias. Mantén siempre una posición segura seleccionada."

L.tip17 = "¿Los inocentes están todos juntos y es difícil matarlos? Considera usar la radio con sonidos de C4 o Disparos para separarlos."

L.tip18 = "Para usar la Radio como traidor, debes acceder al menú de equipamiento y reproducir los sonidos después de haberla puesto. Pon múltiples sonidos en cola clickeando cada uno de ellos."

L.tip19 = "Como detective, si te sobran créditos, puedes darle a un inocente un Kit de Desactivación. De esta manera puedes gastar tu tiempo en otra cosa, dejando a cargo a un inocente para los C4."

L.tip20 = "Los binoculares de los detectives permiten inspeccionar cuerpos a la distancia. Malas noticias si los traidores pensaban usar ese cuerpo como carnada. Claro, los detectives están desarmados al utilizar los binoculares..."

L.tip21 = "La estación de salud de los detectives. Obviamente, esos curados pueden ser traidores..."

L.tip22 = "La estación de salud toma una muestra de ADN de todo aquel que la use. Los detectives pueden usar un escáner ADN para analizar estas muestras."

L.tip23 = "A diferencia de las armas y el C4, la radio de traidores no deja marcas de ADN. No te preocupes si la encuentran y la rompen."

L.tip24 = "Pulsa {helpkey} para ver el tutorial o cambiar configuraciones. Por ejemplo, puedes desactivar estos consejos."

L.tip25 = "Cuando un detective inspecciona un cuerpo, los resultados son visibles por cualquier persona en la tabla de puntuaciones haciendo click en la persona muerta."

L.tip26 = "En la tabla de puntuaciones, un ícono de lupa sale al lado del nombre de las personas si la inspeccionaste. Si el ícono brilla, significa que esa información viene de un detective y contiene datos adicionales."

L.tip27 = "Como detective, verás una lupa si el cuerpo fue inspeccionado por ti mismo en la tabla de puntuaciones. Además, esta información será visible para los demás jugadores."

L.tip28 = "Los espectadores pueden presionar {mutekey} para variar el estado de silenciado."

L.tip29 = "Si el servidor tiene distintos idiomas instalados, puedes cambiarlo en el menú de configuraciones."

L.tip30 = "El chat rápido o la 'radio' puede ser usada con {zoomkey}."

L.tip31 = "Como espectador puedes presionar {duckkey} para desbloquear el cursor y ver los distintos consejos. Presiona {duckkey} de vuelta para volver al control de la cámara."

L.tip32 = "El click secundario de la Crowbar empuja a las personas."

L.tip33 = "Disparar a través de la mira aumenta la precisión y reduce el retroceso. Agacharse no ayuda."

L.tip34 = "Las granadas de humo son útiles en espacios cerrados. Especialmente en las salas con laberintos o varios pasillos."

L.tip35 = "Como traidor, recuerda que puedes arrastrar los cuerpos para que nunca sean encontrados por un detective o inocente."

L.tip36 = "El tutorial disponible con {helpkey} contiene información importante de la clave de este modo de juego."

L.tip37 = "En la tabla de puntuaciones, puedes etiquetar a las personas como 'sospechosos' o 'amigos'. Esta etiqueta te puede servir a la hora de combatir o apuntarles."

L.tip38 = "La mayoría de objetos que se pueden soltar son también acoplables a la pared usando el click secundario."

L.tip39 = "Los C4 que explotan for una falla en la desactivación tienen un radio menor que los que explotan naturalmente."

L.tip40 = "Si dice 'MODO PRISA' la ronda inicial tendrá menos tiempo que de lo común, pero con cada muerte el tiempo incrementa. Este modo presiona a los traidores a mantenerse activos."

-- Round report
L.report_title = "Reporte de Ronda"

-- Tabs
L.report_tab_hilite = "Jugadas destacadas"
L.report_tab_hilite_tip = "Jugadas de la ronda"
L.report_tab_events = "Eventos"
L.report_tab_events_tip = "Registro de eventos de esta ronda"
L.report_tab_scores = "Puntajes"
L.report_tab_scores_tip = "Puntaje por jugador durante esta ronda"

-- Event log saving
L.report_save = "Guardar Log .txt"
L.report_save_tip = "Guarda los registros de evento en un archivo de texto"
L.report_save_error = "No hay un registro de eventos para guardar."
L.report_save_result = "El registro de eventos fue guardado en:"

-- Columns
L.col_time = "Tiempo"
L.col_event = "Evento"
L.col_player = "Jugador"
L.col_roles = "Rol(es)"
L.col_teams = "Equipo(s)"
L.col_kills1 = "Asesinatos"
L.col_kills2 = "Asesinatos de equipo"
L.col_points = "Puntos"
L.col_team = "Bonus de Equipo"
L.col_total = "Puntos totales"

-- Awards/highlights
L.aw_sui1_title = "Líder del Culto Suicida"
L.aw_sui1_text = "les ha mostrado el camino a los otros suicidas siendo el primero en hacerlo."

L.aw_sui2_title = "Solo y deprimido"
L.aw_sui2_text = "fue el único que se mató a sí mismo."

L.aw_exp1_title = "Beca para Investigación de Químicos"
L.aw_exp1_text = "era reconocido por su gran investigación en el campo de la química, especialmente explosiva. {num} sujetos de investigación contribuyeron."

L.aw_exp2_title = "Investigación de Campo"
L.aw_exp2_text = "probó su resistencia a los explosivos. Parece que no fue suficiente."

L.aw_fst1_title = "Primera Sangre"
L.aw_fst1_text = "llevó acabo el primer asesinato de un inocente."

L.aw_fst2_title = "Primera Sangre: Edición imbécil"
L.aw_fst2_text = "logró la primera sangre matando a su compañero traidor. Muy buena, crack."

L.aw_fst3_title = "Primer Error"
L.aw_fst3_text = "fue el primero en matar. Una pena que haya sido su inocente compañero."

L.aw_fst4_title = "Primera victoria del día"
L.aw_fst4_text = "logró consagrarse como el primer justiciero por hacer de la primera muerte la de un traidor."

L.aw_all1_title = "Oveja negra del grupo"
L.aw_all1_text = "fue responsable de cada asesinato cometido por los inocentes."

L.aw_all2_title = "Lobo Solitario"
L.aw_all2_text = "fue responsable de cada asesinato cometido por los traidores."

L.aw_nkt1_title = "Peor es nada"
L.aw_nkt1_text = "se las arregló para matar un único inocente. Algo es algo."

L.aw_nkt2_title = "Dos pájaros de un tiro"
L.aw_nkt2_text = "demostró que se puede hacer más con una bala que matar una persona. En este caso, matar dos."

L.aw_nkt3_title = "Traidor Serial"
L.aw_nkt3_text = "acabó con tres vidas inocentes. Menos mal que eran terroristas."

L.aw_nkt4_title = "Lobo entre Lobos (Parecen más ovejas)"
L.aw_nkt4_text = "se comió varios inocentes para la cena. Una cena de {num} platos."

L.aw_nkt5_title = "Operación Contra-Terrorista"
L.aw_nkt5_text = "le pagan por matar. Ahora podrá disfrutar de su yate con juegos de azar y mujerzuelas."

L.aw_nki1_title = "Traiciona esta"
L.aw_nki1_text = "encuentra un traidor. Y le dispara a un Traidor. Fácil."

L.aw_nki2_title = "Almas Corruptas"
L.aw_nki2_text = "llevó a dos traidores al más allá."

L.aw_nki3_title = "¿Sueñan los Traidores con Ovejas traidoras?"
L.aw_nki3_text = "puso tres traidores a dormir."

L.aw_nki4_title = "Empleado de Asuntos Internos"
L.aw_nki4_text = "le pagan por cada asesinato. Ahora puede ir a comprarse su quinta piscina de lujo."

L.aw_fal1_title = "No, señor Bond. Espero que muera"
L.aw_fal1_text = "empujó a alguien desde una gran altura."

L.aw_fal2_title = "En Picada"
L.aw_fal2_text = "dejó que su cuerpo se desplomara luego de haber viajado en picada."

L.aw_fal3_title = "El Meteorito Humano"
L.aw_fal3_text = "aplastó a alguien cayendo sobre él desde una gran altura."

L.aw_hed1_title = "Eficiencia"
L.aw_hed1_text = "descubrió el placer de volarle la cabeza a la gente a y lo a hecho con {num} personas."

L.aw_hed2_title = "Neurólogo"
L.aw_hed2_text = "removió exitosamente el cerebro de {num} personas para examinarlos... en otra partida."

L.aw_hed3_title = "Los videojuegos me hicieron hacerlo"
L.aw_hed3_text = "puso en práctica su programa de entrenamiento virtual y encajó a {num} personas con un disparo en la cabeza."

L.aw_cbr1_title = "Palancazo"
L.aw_cbr1_text = "Tiene el verdadero swing para agitar la palanca, cobrándose así {num} víctimas."

L.aw_cbr2_title = "Freeman"
L.aw_cbr2_text = "Terminó Half-Life machacando a {num} personas."

L.aw_pst1_title = "Pequeño pero poderoso"
L.aw_pst1_text = "marcó {num} usando la pistola. Poderoso el chiquitín."

L.aw_pst2_title = "Masacre calibre 9mm"
L.aw_pst2_text = "asesinó una pequeña armada de {num} personas con pistola."

L.aw_sgn1_title = "Modo fácil"
L.aw_sgn1_text = "aplicó sus perdigones justo dónde duele, asesinando {num} objetivos."

L.aw_sgn2_title = "Lluvia de Perdigones"
L.aw_sgn2_text = "le disgustaba la lluvia así que le dio su estilo propio. {num} personas fueron 'mojadas' por esta."

L.aw_rfl1_title = "Apunta y dispara"
L.aw_rfl1_text = "demostró que para matar {num} personas sólo es necesario un rifle y una buena mano."

L.aw_rfl2_title = "Puedo ver esa cabeza desde aquí"
L.aw_rfl2_text = "conoce bien su rifle. Otras {num} personas lo conocieron bien también."

L.aw_dgl1_title = "Es como un rifle pequeño"
L.aw_dgl1_text = "le encontró el truco a la Desert Eagle y asesinó a {num} personas."

L.aw_dgl2_title = "Maestro de la Deagle"
L.aw_dgl2_text = "reventó a {num} personas con su pequeño cañón de mano."

L.aw_mac1_title = "Reza y dispara"
L.aw_mac1_text = "mató a {num} personas con la MAC10. No pregunten cuánta munición usó para lograrlo."

L.aw_mac2_title = "Máquina de matar"
L.aw_mac2_text = "se cuestiona cuánto podría matar si pudiera llevar dos MAC10. ¿{num} multiplicado por dos?"

L.aw_sip1_title = "SHHHH"
L.aw_sip1_text = "le cerró la boca a {num} personas con la pistola silenciada."

L.aw_sip2_title = "Asesino Silencioso"
L.aw_sip2_text = "asesinó a {num} personas que no lograron oir su muerte."

L.aw_knf1_title = "Al filo del internet"
L.aw_knf1_text = "nos ha mostrado como untar manteca en la cara de alguien y lo ha subido a internet."

L.aw_knf2_title = "¿De dónde sacaste eso?"
L.aw_knf2_text = "no era traidor, de igual manera logró cortar a alguien en pedacitos."

L.aw_knf3_title = "Obseción con los cuchillos"
L.aw_knf3_text = "encontró {num} cuchillos tirados por ahí... y los usó."

L.aw_knf4_title = "Al Filo del Vacío"
L.aw_knf4_text = "mató {num} personas con cuchillo. Nadie sabe cómo."

L.aw_flg1_title = "Al Rescate"
L.aw_flg1_text = "usó sus bengalas para remarcar {num} muertes."

L.aw_flg2_title = "Señales de... ¿fuego?"
L.aw_flg2_text = "enseñó a {num} personas el peligro de usar ropa inflamable."

L.aw_hug1_title = "Ráfaga H.U.G.E"
L.aw_hug1_text = "mantuvo su emoción disparando con la H.U.G.E, de alguna manera logró darle a {num} personas."

L.aw_hug2_title = "El Paciente más paciente"
L.aw_hug2_text = "perseveró y triunfó. Su recompensa fueron {num} asesinatos con H.U.G.E."

L.aw_msx1_title = "Tap Tap Tap"
L.aw_msx1_text = "se llevó con tiros limpios a {num} personas (M16)."

L.aw_msx2_title = "Campeón de Cancha"
L.aw_msx2_text = "sabe moverse en el campo de batalla. Su M16 se lo demostró a {num} personas."

L.aw_tkl1_title = "Cagada"
L.aw_tkl1_text = "se le resbaló el dedo justo cuándo le apuntaba a un compañero."

L.aw_tkl2_title = "Esta es la vencida"
L.aw_tkl2_text = "pensó que atrapó a un traidor dos veces... las dos veces falló."

L.aw_tkl3_title = "Superstición"
L.aw_tkl3_text = "no pudo parar luego de matar a dos compañeros. El tres es su número de la suerte."

L.aw_tkl4_title = "Elba Neado"
L.aw_tkl4_text = "asesinó a todo su equipo. Seguramente lo banean."

L.aw_tkl5_title = "Sádico"
L.aw_tkl5_text = "disfruta mucho de ver morir a los suyos. Una pisca de desesperación."

L.aw_tkl6_title = "¡Aprende a leer!"
L.aw_tkl6_text = "no entendió en qué equipo estaba y terminó matando a la mitad de sus compañeros."

L.aw_tkl7_title = "Gangster Ciego"
L.aw_tkl7_text = "tenía que proteger su territorio, pero no de los suyos."

L.aw_brn1_title = "Como en McDonald's"
L.aw_brn1_text = "convirtió a varias personas en papas fritas."

L.aw_brn2_title = "Fosforescente"
L.aw_brn2_text = "inventó las balizas fosforescentes... con un cuerpo humano."

L.aw_brn3_title = "Parrillada al aire libre"
L.aw_brn3_text = "hizo un gran parrillada y todos fueron invitados... lástima que estuvieron algo pasados de cocción."

L.aw_fnd1_title = "Forense"
L.aw_fnd1_text = "encontró {num} cuerpos tirados por ahí."

L.aw_fnd2_title = "¡Hazte con todos!"
L.aw_fnd2_text = "capturó, digo, encontró {num} cuerpos y los llevó a su colección, digo, a la morgue."

L.aw_fnd3_title = "Olor a Muerte"
L.aw_fnd3_text = "no puedo parar de encontrar cadáveres, {num} veces durante esta ronda."

L.aw_crd1_title = "Reciclaje"
L.aw_crd1_text = "recuperó {num} crédito(s) en cuerpos de otros jugadores."

L.aw_tod1_title = "Pérdida culposa"
L.aw_tod1_text = "murió pocos segundos después de que su equipo ganara la ronda."

L.aw_tod2_title = "A Casa"
L.aw_tod2_text = "murió justo después de que empezara la ronda."

-- New and modified pieces of text are placed below this point, marked with the
-- version in which they were added, to make updating translations easier.

-- v24
L.drop_no_ammo = "Munición insuficiente en tu cargador como para soltarla en una caja."

-- 2015-05-25
L.hat_retrieve = "Has recogido el Sombrero del Detective."

-- 2017-09-03
L.sb_sortby = "Ordenar por:"

-- 2018-07-24
L.equip_tooltip_main = "Menú de Equipamiento"
L.equip_tooltip_radar = "Control del Radar"
L.equip_tooltip_disguise = "Control del Disfraz"
L.equip_tooltip_radio = "Control de la Radio"
L.equip_tooltip_xfer = "Transferir Créditos"
L.equip_tooltip_reroll = "Volver a tirar objetos"

L.confgrenade_name = "Discombobulator"
L.polter_name = "Poltergeist"
L.stungun_name = "Prototipo UMP"

L.knife_instant = "ASESINATO INSTANTÁNEO"

L.binoc_zoom_level = "Nivel de Zoom"
L.binoc_body = "CUERPO DETECTADO"

L.idle_popup_title = "Ausente"

-- 2019-01-31
L.create_own_shop = "Crear tienda propia"
L.shop_link = "Enlazar con"
L.shop_disabled = "Desactivar tienda"
L.shop_default = "Usar tienda predeterminada"

-- 2019-05-05
L.reroll_name = "Nueva tirada (Reroll)"
L.reroll_menutitle = "Volver a tirar items"
L.reroll_no_credits = "¡Necesitas {amount} créditos para volver a tirar!"
L.reroll_button = "Nueva tirada (Reroll)"
L.reroll_help = "Usa {amount} crédito(s) para obtener nuevos items en la tienda."

-- 2019-05-06
L.equip_not_alive = "Aquí puedes ver los objetos del rol que quieras. ¡No olvides de marcar tus favoritos!"

-- 2019-06-27
L.shop_editor_title = "Editor de la Tienda"
L.shop_edit_items_weapong = "Editar objetos / armas"
L.shop_edit = "Editar Tienda"
L.shop_settings = "Configuración"
L.shop_select_role = "Seleccionar Rol"
L.shop_edit_items = "Editar Objetos"
L.shop_edit_shop = "Editar Tienda"
L.shop_create_shop = "Crear tienda personalizada"
L.shop_selected = "Selccionado {role}"
L.shop_settings_desc = "Cambia las ConVars de la tienda aleatoria. ¡No olvides guardar los cambios!"

L.bindings_new = "Nuevo bind/atajo para {name}: {key}"

L.hud_default_failed = "Error al establecer el HUD {hudname} como el nuevo predeterminado. No tienes permiso o ese HUD no existe."
L.hud_forced_failed = "Error al establecer el HUD {hudname}. No tienes permiso o ese HUD no existe."
L.hud_restricted_failed = "Error al restringir el HUD {hudname}. No tienes permiso para hacer eso."

L.shop_role_select = "Selecciona un rol"
L.shop_role_selected = "La tienda de {role} fue seleccionada"
L.shop_search = "Buscar"

L.spec_help = "Click para ver o presiona {usekey} en un prop (physics) para controlarlo."
L.spec_help2 = "Para salir del modo espectador, abre el menú presionando {helpkey}, ve a 'Jugabilidad' y desactiva el modo espectador."

-- 2019-10-19
--L.drop_ammo_prevented = "Something prevents you from dropping your ammo."

-- 2019-10-28
L.target_c4 = "Pulsa [{usekey}] para abrir el menú de C4"
L.target_c4_armed = "Pulsa [{usekey}] para desactivar el C4"
L.target_c4_armed_defuser = "Pulsa [{usekey}] para usar el kit de desactivación"
L.target_c4_not_disarmable = "No puedes desactivar el C4 de un compañero vivo"
L.c4_short_desc = "Algo muy explosivo"

L.target_pickup = "Pulsa [{usekey}] para recoger"
L.target_slot_info = "Espacio: {slot}"
L.target_pickup_weapon = "Pulsa [{usekey}] para recoger el arma"
L.target_switch_weapon = "Pulsa [{usekey}] para intercambiar con tu arma actual"
L.target_pickup_weapon_hidden = ", pulsa [{usekey} + {walkkey}] para recogerla silenciosamente"
L.target_switch_weapon_hidden = ", pulsa [{usekey} + {walkkey}] para intercambiarla silenciosamente"
L.target_switch_weapon_nospace = "No hay espacio disponible para esta arma en tu inventario"
L.target_switch_drop_weapon_info = "Soltando {name} del espacio {slot}"
L.target_switch_drop_weapon_info_noslot = "No hay un arma que esté ocupando el espacio {slot}"

L.corpse_searched_by_detective = "Este cadáver fue inspeccionado por un detective."
L.corpse_too_far_away = "El cadáver está muy lejos."

L.radio_pickup_wrong_team = "No puedes recoger la radio de otro equipo."
L.radio_short_desc = "Los sonidos de las armas son música para mis oídos"

L.hstation_subtitle = "Mantén presionado [{usekey}] para recibir curación."
L.hstation_charge = "Carga restante de la estación: {charge}"
L.hstation_empty = "No hay más carga en la estación"
L.hstation_maxhealth = "Ya estás completamente curado"
L.hstation_short_desc = "La estación de salud se recarga con el tiempo"

-- 2019-11-03
L.vis_short_desc = "Visualizes a crime scene if the victim died by a gunshot wound"
L.corpse_binoculars = "Pulsa [{key}] para inspeccionar el cadáver."
L.binoc_progress = "Search progress: {progress}%"

L.pickup_no_room = "No tienes espacio en tu inventario para este tipo de arma"
L.pickup_fail = "No puedes agarrar esto"
L.pickup_pending = "Ya has recogido un arma, espera a recibirla"

-- 2020-01-07
L.tbut_help_admin = "Editar configuración de teclas para el Traidor"
L.tbut_role_toggle = "[{walkkey} + {usekey}] para activar y desactivar esto para {role}"
L.tbut_role_config = "Rol: {current}"
L.tbut_team_toggle = "[SHIFT + {walkkey} + {usekey}] para activar este botón para el equipo {team}"
L.tbut_team_config = "Equipo: {current}"
L.tbut_current_config = "Configuración actual:"
L.tbut_intended_config = "Configuración recomendada por el creador del mapa:"
L.tbut_admin_mode_only = "Sólo visible para ti ya que eres un administrador y '{cv}' está establecido en '1'"
L.tbut_allow = "Permitir"
L.tbut_prohib = "Prohibir"
L.tbut_default = "Predeterminado"

-- 2020-02-09
L.name_door = "Puerta"
L.door_open = "Pulsa [{usekey}] para abrir la puerta."
L.door_close = "Pulsa [{usekey}] para cerrar la puerta."
L.door_locked = "¡Esta puerta está bloqueada!"

-- 2020-02-11
L.automoved_to_spec = "(MENSAJE AUTOMÁTICO) Fuiste movido al modo espectador por estar ausente/AFK."
L.mute_team = "{team} silenciado."

-- 2020-02-16
L.door_auto_closes = "Esta puerta se cierra automáticamente."
L.door_open_touch = "Acércate a la puerta para abrirla."
L.door_open_touch_and_use = "Acércate a la puerta y pulsa [{usekey}] para abrirla."
L.hud_health = "Salud"

-- 2020-03-09
--L.help_title = "Help and Settings"

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

--L.menu_changelog_description = "A list of changes and fixes in recent versions"
--L.menu_guide_description = "Helps you to get started with TTT2 and explains some things about gameplay, roles and other stuff"
--L.menu_bindings_description = "Bind specific features of TTT2 and its addons to your own liking"
--L.menu_language_description = "Select the language of the game"
--L.menu_appearance_description = "Tweak the appearance and performance of the UI"
--L.menu_gameplay_description = "Avoid roles and tweak some features"
--L.menu_addons_description = "Configure local addons to your liking"
--L.menu_legacy_description = "A panel with converted tabs from original TTT, they should be ported over to the new system"
--L.menu_administration_description = "General settings for HUDs, shops etc"
--L.menu_equipment_description = "Set credits, limitations, availability and other stuff"
--L.menu_shops_description = "Add/Remove shops to roles and define the equipment in it"

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
--L.submenu_appearance_miscellaneous_title = "Misellaneous"

--L.submenu_gameplay_general_title = "General"
--L.submenu_gameplay_avoidroles_title = "Avoid Role Selection"

--L.submenu_administration_hud_title = "HUD Settings"
--L.submenu_administration_randomshop_title = "Random Shop"

--L.help_color_desc = "If this setting is enabled, a global color can be chosen that will be used for the targetID outline and the crosshair."
--L.help_scale_factor = "This scale factor influences all UI elements (HUD, vgui and targetID). It is automatically updated if the screen resolution is changed. Changing this value will reset the HUD!"
--L.help_hud_game_reload = "The HUD is not available right now. The game has to be reloaded."
--L.help_hud_special_settings = "These are specific settings of this HUD."
--L.help_vskin_info = "VSkin (vgui skin) is the skin applied to all menu elements like the current one. Skins can be easily created with a simple lua script and can change colors and some size parameters."
--L.help_targetid_info = "TargetID is the information rendered when focusing an entity. A fixed color can be set in the general settings panel."
--L.help_hud_default_desc = "Set the default HUD for all players. Players that have not yet selected a HUD will receive this HUD as their default. This won't change the HUD of players that have already selected their HUD."
--L.help_hud_forced_desc = "Force a HUD for all players. This disables the HUD selection feature for everyone."
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
--L.label_minimal_targetid = "Minimalist Target ID under crosshair (no karma text, hints, etc.)"
--L.label_shop_always_show = "Always show the shop"
--L.label_shop_double_click_buy = "Enable to buy an item in the shop by double clicking on it"
--L.label_shop_num_col = "Number of columns"
--L.label_shop_num_row = "Number of rows"
--L.label_shop_item_size = "Icon size"
--L.label_shop_show_slot = "Show slot marker"
--L.label_shop_show_custom = "Show custom item marker"
--L.label_shop_show_fav = "Show favourite item marker"
--L.label_crosshair_enable = "Enable Crosshair"
--L.label_crosshair_gap_enable = "Enable custom crosshair gap"
--L.label_crosshair_gap = "Custom crosshair gap"
--L.label_crosshair_opacity = "Crosshair opacity"
--L.label_crosshair_ironsight_opacity = "Ironsight crosshair opacity"
--L.label_crosshair_size = "Crosshair size"
--L.label_crosshair_thickness = "Crosshair thickness"
--L.label_crosshair_thickness_outline = "Crosshair outline thickness"
--L.label_crosshair_static_enable = "Enable static crosshair"
--L.label_crosshair_dot_enable = "Enable crosshair dot"
L.label_crosshair_lines_enable = "Habilitar líneas de la mira"
--L.label_crosshair_scale_enable = "Enable weapon dependant weapon scale"
--L.label_crosshair_ironsight_low_enabled = "Lower weapon when using ironsights"
--L.label_damage_indicator_enable = "Enable damage indicator"
--L.label_damage_indicator_mode = "Select damage indicator theme"
--L.label_damage_indicator_duration = "Seconds the damage indicator is visible after a hit"
--L.label_damage_indicator_maxdamage = "Damage needed for the maximum opacity"
--L.label_damage_indicator_maxalpha = "Damage Indicators maximum opacity"
--L.label_performance_halo_enable = "Draw an outline around some entities while looking at them"
--L.label_performance_spec_outline_enable = "Enable controlled objects' outlines"
--L.label_performance_ohicon_enable = "Enable overhead role icons"
--L.label_interface_tips_enable = "Show gameplay tips at the bottom of the screen while spectating"
--L.label_interface_popup = "Start of round info popup duration"
--L.label_interface_fastsw_menu = "Enable menu with fast weapon switch"
--L.label_inferface_wswitch_hide_enable = "Enable weapon switch menu auto-closing"
--L.label_inferface_scues_enable = "Play sound cue when a round begins or ends"
--L.label_gameplay_specmode = "Spectate-only mode (always stay spectator)"
--L.label_gameplay_fastsw = "Fast weapon switch"
--L.label_gameplay_hold_aim = "Enable hold to aim"
--L.label_gameplay_mute = "Mute living players when dead"
--L.label_gameplay_dtsprint_enable = "Enable double tap sprinting"
--L.label_gameplay_dtsprint_anykey = "Continue double tap sprinting until you stop moving"
--L.label_hud_default = "Default HUD"
--L.label_hud_force = "Forced HUD"

--L.label_bind_weaponswitch = "Pickup Weapon"
--L.label_bind_sprint = "Sprint"
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
--L.header_roleselection = "Enable Role Assignment"
--L.header_hud_administration = "Select Default and Forced HUDs"
--L.header_hud_enabled = "Enable/Disable HUDs"

--L.button_menu_back = "back"
--L.button_none = "None"
--L.button_press_key = "Press a key"
--L.button_save = "Save"
--L.button_reset = "Reset"
--L.button_close = "Close"
--L.button_hud_editor = "HUD Editor"

-- 2020-04-20
L.item_speedrun = "Velocista"
L.item_speedrun_desc = [[¡Te hace 50% más rápido!]]
L.item_no_explosion_damage = "Negar daño por explosión"
L.item_no_explosion_damage_desc = [[Te hace inmune al daño explosivo.]]
L.item_no_fall_damage = "Negar daño por caída"
L.item_no_fall_damage_desc = [[Te hace inmune al daño por caída.]]
L.item_no_fire_damage = "Negar daño por fuego"
L.item_no_fire_damage_desc = [[Te hace inmune al daño por quemaduras.]]
L.item_no_hazard_damage = "Negar daño tóxico"
L.item_no_hazard_damage_desc = [[Te hace inmune al veneno, radiación y ácido.]]
L.item_no_energy_damage = "Negar daño por energía"
L.item_no_energy_damage_desc = [[Te hace inmune a los láseres, plasma y rayos.]]
L.item_no_prop_damage = "Negar daño por objetos"
L.item_no_prop_damage_desc = [[Te hace inmune al daño por objetos arrojados hacia tí.]]
L.item_no_drown_damage = "Negar daño por ahogo"
L.item_no_drown_damage_desc = [[Te hace inmune al daño por agotamiento del oxígeno.]]

-- 2020-04-21
L.dna_tid_possible = "Se puede escanear"
L.dna_tid_impossible = "No se puede escanear"
L.dna_screen_ready = "Sin ADN"
L.dna_screen_match = "Duplicado"

-- 2020-04-30
L.message_revival_canceled = "Reanimación cancelada."
L.message_revival_failed = "Reanimación fallida."
L.message_revival_failed_missing_body = "No has sido revivido porque tu cuerpo ya no existe."
L.hud_revival_title = "Tiempo faltante para ser reanimado:"
L.hud_revival_time = "{time}s"

-- 2020-05-03
L.door_destructible = "La puerta es desctructible (VIDA {health})"

-- 2020-05-28
L.confirm_detective_only = "Sólo los detectives pueden confirmar cuerpos"
L.inspect_detective_only = "Sólo los detectives pueden inspeccionar cuerpos"
L.corpse_hint_no_inspect = "Sólo los detectives pueden inspeccionar este cuerpo."
L.corpse_hint_inspect_only = "Pulsa [{usekey}] para inspeccionar. Sólo los detectives pueden confirmar este cuerpo."
L.corpse_hint_inspect_only_credits = "Pulsa [{usekey}] para recibir los créditos. Sólo los detectives pueden inspeccionar este cuerpo."

-- 2020-06-04
L.label_bind_disguiser = "Disfraz"

-- 2020-06-24
L.dna_help_primary = "Tomar muestra de ADN"
L.dna_help_secondary = "Cambiar muestra de ADN"
L.dna_help_reload = "Borrar muestra"

L.binoc_help_pri = "Identificar el cuerpo."
L.binoc_help_sec = "Cambiar nivel de zoom."

L.vis_help_pri = "Soltar el dispositivo activo."

L.decoy_help_pri = "Colocar el señuelo."

-- 2020-08-07
L.pickup_error_spec = "No puedes recoger esto como espectador."
L.pickup_error_owns = "No puedes recoger esto porque ya lo tienes en el inventario."
L.pickup_error_noslot = "No puedes recoger esto porque no tienes un espacio disponible en el inventario."

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
--L.desc_event_finish = "The round lasted {minutes}:{seconds}. There were {alive} plaplayer(s)yers alive in the end."
--L.desc_event_game = "A new round has started."
--L.desc_event_respawn = "{player} has respawned."
--L.desc_event_rolechange = "{player} changed their role/team from {orole} ({oteam}) to {nrole} ({nteam})."
--L.desc_event_selected = "The teams and roles were selected for all {amount} player(s)."
--L.desc_event_spawn = "{player} has spawned."

-- Name of a trap that killed us that has not been named by the mapper
L.trap_something = "Algo"

-- Kill events
--L.desc_event_kill_suicide = "It was suicide."
--L.desc_event_kill_team = "It was a team kill."

L.desc_event_kill_blowup = "{victim} ({vrole} / {vteam}) se reventó."
L.desc_event_kill_blowup_trap = "{victim} ({vrole} / {vteam}) fue reventado por {trap}."

L.desc_event_kill_tele_self = "{victim} ({vrole} / {vteam}) se tele-mató."
L.desc_event_kill_sui = "{victim} ({vrole} / {vteam}) no pudo soportarlo y se suicidó."
L.desc_event_kill_sui_using = "{victim} ({vrole} / {vteam}) se suicidó usando {tool}."

L.desc_event_kill_fall = "{victim} ({vrole} / {vteam}) cayó hacia su muerte."
L.desc_event_kill_fall_pushed = "{victim} ({vrole} / {vteam}) cayó hacia su muerta luego de que {attacker} lo empujara."
L.desc_event_kill_fall_pushed_using = "{victim} ({vrole} / {vteam}) cayó hacia su muerte luego de que {attacker} ({arole} / {ateam}) usara {trap} para empujarlo."

L.desc_event_kill_shot = "{victim} ({vrole} / {vteam}) fue fusilado por {attacker}."
L.desc_event_kill_shot_using = "{victim} ({vrole} / {vteam}) fue fusilado por {attacker} ({arole} / {ateam}) usando un/a {weapon}."

L.desc_event_kill_drown = "{victim} ({vrole} / {vteam}) fue asfixiado hasta la muerte por {attacker}."
L.desc_event_kill_drown_using = "{victim} ({vrole} / {vteam}) fue asfixiado hasta la muerte con {trap} activado por {attacker} ({arole} / {ateam})."

L.desc_event_kill_boom = "{attacker} ({vrole} / {vteam}) hizo volar por los aires a {victim}."
L.desc_event_kill_boom_using = "{attacker} ({vrole} / {vteam}) hizo volar por los aires a {victim} usando {trap} ({arole} / {ateam})."

L.desc_event_kill_burn = "{victim} ({vrole} / {vteam}) fue incinerado por {attacker}."
L.desc_event_kill_burn_using = "{victim} ({vrole} / {vteam}) fue incinerado con {trap} por {attacker} ({arole} / {ateam})."

L.desc_event_kill_club = "{victim} ({vrole} / {vteam}) fue golpeado hasta la muerte por {attacker}."
L.desc_event_kill_club_using = "{victim} ({vrole} / {vteam}) fue golpeado hasta la muerte por {attacker} ({arole} / {ateam}) usando {trap}."

L.desc_event_kill_slash = "{victim} ({vrole} / {vteam}) fue apuñalado por {attacker}."
L.desc_event_kill_slash_using = "{victim} ({vrole} / {vteam}) fue cortado en partes por {attacker} ({arole} / {ateam}) usando {trap}."

L.desc_event_kill_tele = "{victim} ({vrole} / {vteam}) fue tele-asesinado por {attacker}."
L.desc_event_kill_tele_using = "{victim} ({vrole} / {vteam}) a muerto con {trap} por {attacker} ({arole} / {ateam})."

L.desc_event_kill_goomba = "{victim} ({vrole} / {vteam}) fue aplastado por una masa contundente de {attacker} ({arole} / {ateam})."

L.desc_event_kill_crush = "{victim} ({vrole} / {vteam}) fue aplastado por {attacker}."
L.desc_event_kill_crush_using = "{victim} ({vrole} / {vteam}) fue aplastado con {trap} por {attacker} ({arole} / {ateam})."

L.desc_event_kill_other = "{victim} ({vrole} / {vteam}) fue asesinado por {attacker}."
L.desc_event_kill_other_using = "{victim} ({vrole} / {vteam}) fue asesinado por {attacker} ({arole} / {ateam}) usando {trap}."

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

--2021-06-09
--L.scoreboard_voice_tooltip = "Scroll to change the volume"
