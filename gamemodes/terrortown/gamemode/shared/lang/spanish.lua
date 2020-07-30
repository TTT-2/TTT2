-- Spanish language strings

local L = LANG.CreateLanguage("Español")

-- General text used in various places
L.traitor = "Traidor"
L.detective = "Detective"
L.innocent = "Inocente"
L.last_words = "Últimas palabras"

L.terrorists = "Terroristas"
L.spectators = "Espectadores"

L.noteam = "SIN EQUIPO"
L.innocents = "EQUIPO Inocentes"
L.traitors = "EQUIPO Traidores"

-- role description
L.ttt2_desc_none = "¡No tienes un rol ahora mismo!"
L.ttt2_desc_innocent = "Tu objetivo es sobrevivir de los traidores"
L.ttt2_desc_traitor = "¡Asesina a todos los otros roles con tu tienda de traidor ([C])!"
L.ttt2_desc_detective = "¡Eres detective! Colabora con los inocentes para encontrar a los traidores y eliminarlos"

-- Round status messages
L.round_minplayers = "No hay jugadores suficientes para empezar la ronda..."
L.round_voting = "Votación en curso, retrasando la nueva ronda {num} segundos..."
L.round_begintime = "Una nueva ronda comenzará en {num} segundos ¡Preparate!"
L.round_selected = "Los traidores han sido seleccionados."
L.round_started = "¡La ronda ha comenzado!"
L.round_restart = "La ronda fue reiniciada por el Staff."

L.round_traitors_one = "Traidor, estás solo."
L.round_traitors_more = "Traidor, estos son tus camaradas: {names}"

L.win_time = "Te has quedado sin tiempo. Los traidores pierden."
L.win_traitors = "¡Los traidores han ganado!"
L.win_innocents = "¡Los inocentes han ganado!"
L.win_bees = "¡Las abejas han ganado! (Empate)"
L.win_showreport = "Veamos el reporte de la ronda por {num} segundos."

L.limit_round = "Límite de rondas alcanzado. El siguiente mapa se cargará pronto."
L.limit_time = "Tiempo límite alcanzado. El siguiente mapa cargará pronto."
L.limit_left = "{num} ronda(s) o {time} minutos restantes para que el mapa cambie."

-- Credit awards
L.credit_all = "Tu equipo fue recompensado con {num} créditos por tu desempeño."

L.credit_kill = "Has recibido {num} créditos por matar un {role}."

-- Karma
L.karma_dmg_full = "¡Tu karma es {amount}, por lo que harás todo el daño esta ronda!"
L.karma_dmg_other = "¡Tu karma es {amount}. Como resultado, tu daño se ve reducido en {num}%"

-- Body identification messages
L.body_found = "{finder} encontró el cuerpo de {victim}. Era {role}"
L.body_found_team = "{finder} encontró el cuerpo de {victim}. Era {role} ({team})"

-- The {role} in body_found will be replaced by one of the following:
L.body_found_traitor = "¡Era un traidor!"
L.body_found_det = "Era un detective."
L.body_found_inno = "Era un inocente."

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
L.equip_tabtitle = "Ordenar equipamiento"

L.equip_status = "Estatus de la orden"
L.equip_cost = "Tienes {num} créditos restantes."
L.equip_help_cost = "Cada pieza de equipamiento que compras cuesta cierta cantidad de créditos."

L.equip_help_carry = "Sólo puedes comprar cosas que puedas llevar o haya espacio en tu habitación."
L.equip_carry = "Puedes equiparte este objeto."
L.equip_carry_own = "Ya tienes ese objeto equipado."
L.equip_carry_slot = "Ya estás llevando un arma en el espacio {slot}."
L.equip_carry_minplayers = "No hay jugadores suficientes en el servidor para activar esta arma."

L.equip_help_stock = "Algunos objetos puedes comprarlos únicamente una vez por ronda."
L.equip_stock_deny = "Este objeto no tiene stock."
L.equip_stock_ok = "Este objeto está disponible."

L.equip_custom = "Objeto personalizado agregado al servidor."

L.equip_spec_name = "Nombre"
L.equip_spec_type = "Tipo"
L.equip_spec_desc = "Descripción"

L.equip_confirm = "Comprar equipamiento"

L.equip_not_alive = "Puedes ver todo el equipamiento disponible seleccionando un rol a la derecha ¡No olvides marcar tus favoritos!"

-- Disguiser tab in equipment menu
L.disg_name = "Disfraz"
L.disg_menutitle = "Control de Disfraz"
L.disg_not_owned = "¡No estás llevando un disfraz!"
L.disg_enable = "Activar disfraz"

L.disg_help1 = "Cuando tu disfraz esté activo, tu nombre, vida y karma no se mostrarán cuando alguien te mire. Además, estarás oculto del radar del detective."
L.disg_help2 = "Presiona el enter del numpad para activar el disfraz sin el menú. También puedes configurar una tecla bajo el comando 'ttt_toggle_disguise' usando la consola."

-- Radar tab in equipment menu
L.radar_name = "Radar"
L.radar_menutitle = "Control del Radar"
L.radar_not_owned = "¡No estás llevando un Radar!"
L.radar_scan = "Realizar escaneo"
L.radar_auto = "Repetir escaneo"
L.radar_help = "Resultado del escaneo mostrándose durante {num} segundos. Luego de estos segundos el Radar se re-activará"
L.radar_charging = "¡Tu radar sigue en recarga!"

-- Transfer tab in equipment menu
L.xfer_name = "Transferir"
L.xfer_menutitle = "Transferir créditos"
L.xfer_no_credits = "¡No tienes créditos suficientes!"
L.xfer_send = "Envía un crédito"
L.xfer_help = "Sólo puedes enviar créditos a tu compañero {role}."

L.xfer_no_recip = "Receptor no válido, transferencia cancelada."
L.xfer_no_credits = "Créditos insuficientes."
L.xfer_success = "Transferencia de créditos a {player} completada."
L.xfer_received = "{player} te ha dado {num} créditos."

-- Reroll tab in equipment menu
L.reroll_name = ""
L.reroll_menutitle = "Reestablecer objetos (Reroll)"
L.reroll_no_credits = "¡Necesitas {amount} créditos para reestablecer!"
L.reroll_button = "Reestablecer"
L.reroll_help = "Usa {amount} créditos para obtener nuevos objetos."

-- Radio tab in equipment menu
L.radio_name = "Radio"
L.radio_help = "Clickea un botón para que tu radio haga un sonido."
L.radio_notplaced = "Debes poner primero la radio para hacer sonidos."

-- Radio soundboard buttons
L.radio_button_scream = "Gritar"
L.radio_button_expl = "Explosión"
L.radio_button_pistol = "Disparos de pistola"
L.radio_button_m16 = "Disparos de M16"
L.radio_button_deagle = "Disparos de Deagle"
L.radio_button_mac10 = "Disparos de MAC10"
L.radio_button_shotgun = "Disparos de Escopeta"
L.radio_button_rifle = "Disparos de Rifle"
L.radio_button_huge = "Ráfaga de H.U.G.E."
L.radio_button_c4 = "Bip de C4"
L.radio_button_burn = "Fuego"
L.radio_button_steps = "Pisadas"


-- Intro screen shown after joining
L.intro_help = "Si sos nuevo por favor verifica las reglas en F1."

-- Radiocommands/quickchat
L.quick_title = "Teclas de Quickchat "

L.quick_yes = "Sí."
L.quick_no = "No."
L.quick_help = "¡Ayuda!"
L.quick_imwith = "Estoy con {player}."
L.quick_see = "Veo a {player}."
L.quick_suspect = "{player} parece sospechoso."
L.quick_traitor = "¡{player} es un Traidor!"
L.quick_inno = "{player} es inocente."
L.quick_check = "¿Hay alguien vivo?"

L.radio_pickup_wrong_team = "No puedes recoger la radio de otro equipo."
L.radio_short_desc = "Los sonidos de las armas son música para mis oídos"

-- {player} in the quickchat text normally becomes a player nickname, but can
-- also be one of the below.  Keep these lowercase.
L.quick_nobody = "nadie"
L.quick_disg = "alguien disfrazado"
L.quick_corpse = "un cuerpo sin identificar"
L.quick_corpse_id = "el cadáver de {player}"


-- Body search window
L.search_title = "Resultados de la búsqueda del cadáver"
L.search_info = "Información"
L.search_confirm = "Confirmar Muerte"
L.search_call = "Llamar a un Detective"

-- Descriptions of pieces of information found
L.search_nick = "Este es el cuerpo de {player}."

L.search_role_traitor = "¡Esta persona era un Traidor!"
L.search_role_det = "Esta persona era inocente."
L.search_role_inno = "Esta persona era un terrorista inocente."

L.search_words = "Algo te dice una de las últimas palabras de esta persona: '{lastwords}'"
L.search_armor = "Estaban utilizando protección antibalas."
L.search_disg = "Estaba utilizando un dispositivo para falsificar su identidad."
L.search_radar = "Estaban llevando algún tipo de radar. Aparentemente ya no funciona."
L.search_c4 = "En el bolsillo encuentras una nota. Establece que el cable {num} desactivará la bomba correctamente."

L.search_dmg_crush = "Varios de sus huesos están rotos. Parece que la muerte se dio por un objeto pesado."
L.search_dmg_bullet = "Es evidente que fueron acribillados hasta la muerte."
L.search_dmg_fall = "Cayeron a su muerte."
L.search_dmg_boom = "Sus heridas y la ropa chamuscada indican que una explosión acabó con esta persona."
L.search_dmg_club = "El cuerpo está golpeado y abollado. Probablemente fue apaleado hasta la muerte."
L.search_dmg_drown = "El cuerpo muestra señales de que la persona se ahogó."
L.search_dmg_stab = "Hay clara evidencia de que fue apuñalado y cortado hasta morir desangrado."
L.search_dmg_burn = "Huele a terrorista quemado..."
L.search_dmg_tele = "¡Parece que su ADN fue alterado por partículas taquión!"
L.search_dmg_car = "Cuando este terrorista cruzó la calle, fueron atropellados por un conductor temerario."
L.search_dmg_other = "No puedes determinar la causa de muerte de esta persona."

L.search_weapon = "Parece que se uso un/una {weapon} para matarlo."
L.search_head = "La herida mortal fue un Disparo en la cabeza. No tuvo tiempo para gritar."
L.search_time = "Murió apróximadamente {time} antes de empezar la investigación."
L.search_timefake = "Murió aproximadamente 00:37 antes de empezar la investigación."
L.search_dna = "Recoge una muestra del ADN del asesino con un Escáner ADN. La muestra ADN se deteriorará en {time}."

L.search_kills1 = "Has encontrado una lista de asesinatos que confirman la muerte de {player}."
L.search_kills2 = "Has encontrado una lista de asesinatos con los siguientes nombres:"
L.search_eyes = "Usando tu intuición de detective, logras ver que la última persona que vio fue: {player}. ¿Es el asesino o es una coincidencia?"


-- Scoreboard
L.sb_playing = "Estás jugando en..."
L.sb_mapchange = "El mapa cambia en {num} rondas o en {time}"

L.sb_sortby = "Buscar por:"

L.sb_mia = "Desaparecido en Acción"
L.sb_confirmed = "Muerte confirmada"

L.sb_ping = "Ping"
L.sb_deaths = "Muertes"
L.sb_score = "Puntaje"
L.sb_karma = "Karma"

L.sb_info_help = "Buscar en el cadáver de este jugador, luego podrás encontrar los resultados aquí."

L.sb_tag_friend = "AMIGO"
L.sb_tag_susp = "SOSPECHOSO"
L.sb_tag_avoid = "EVADIR"
L.sb_tag_kill = "ASESINAR"
L.sb_tag_miss = "PERDIDO"

-- Help and settings menu (F1)

L.help_title = "Ayuda y configuración"

-- Tabs
L.help_tut = "Tutorial"
L.help_tut_tip = "Cómo funciona el TTT, en 6 pasos"

L.help_settings = "Configuración"
L.help_settings_tip = "Configuración del Cliente "

-- Settings
L.set_title_gui = "Configuración del Interfaz"

L.set_tips = "Mostrar consejos del juego en la parte inferior de la pantalla en modo espectador"

L.set_startpopup = "Duración de la información de ronda"
L.set_startpopup_tip = "Cuando la ronda empiece, un pequeño mensaje aparecerá abajo de tu pantalla con información de la ronda. Cambia la duración de esta aquí."

L.set_cross_opacity = "Opacidad del Crosshair"
L.set_cross_disable = "Desactivar el crosshair"
L.set_minimal_id = "Información minimalista del target debajo del crosshair (no karma, pistas, etc)"
L.set_healthlabel = "Mostrar el estado de salud en conjunto a la barra"
L.set_lowsights = "Baja el arma cuando uses la mira de hierro"
L.set_lowsights_tip = "Activa para posicionar el modelo del arma más abajo cuando estés apuntando. Esto hará que dispares mucho más fácil, pero le quitará realismo."
L.set_fastsw = "Cambio de armas rápido"
L.set_fastsw_tip = "Activa para navegar por el menú de armas sin tener que hacer click. Activa el menú para activar el menú de cambio rápido."
L.set_fastsw_menu = "Activa el menú con el cambio rápido"
L.set_fastswmenu_tip = "Cuando el cambio de armas rápido esté activo, el menú de cambio aparecerá."
L.set_wswitch = "Desactivar cerrado automático del menú rápido"
L.set_wswitch_tip = "Por defecto el menú de cambio rápido de armas se cierra después de un tiempo sin navegar por este. Activa esto para hacerlo estático."
L.set_cues = "Activa el sonido de inicio o fin de ronda"
L.entity_draw_halo = "Dibuja una línea al rededor de las entidades al mirarlas"


L.set_title_play = "Gameplay settings"

L.set_specmode = "Modo Sólo-Espectador (Siempre aparecerás como espectador)"
L.set_specmode_tip = "Modo Sólo-Espectador previene que respawnees al principio de una nueva ronda, sólo quedarás en Espectador."
L.set_mute = "Silencia a los jugadores vivos cuando estás muerto"
L.set_mute_tip = "Activa para silenciar a los vivos cuando estés en modo espectador."


L.set_title_lang = "Language settings"

-- It may be best to leave this next one english, so english players can always
-- find the language setting even if it's set to a language they don't know.
L.set_lang = "Selecciona tu lenguaje:"


-- Weapons and equipment, HUD and messages

-- Equipment actions, like buying and dropping
L.buy_no_stock = "Este arma no tiene stock: ya has comprado una esta ronda."
L.buy_pending = "Ya tienes una orden pendiente, espera hasta recibirlo."
L.buy_received = "Has recibido tu equipamiento especial."

L.drop_no_room = "¡No tienes espacio para entregar tu arma!"
L.pickup_fail = "No puedes agarrar esto"
L.pickup_no_room = "No tienes espacio en tu inventario para este tipo de arma"
L.pickup_pending = "Ya has recogido un arma, espera mientras lo recibes"

L.disg_turned_on = "¡Disfraz activado!"
L.disg_turned_off = "Disfraz desactivado."

-- Equipment item descriptions
L.item_passive = "Objeto de uso pasivo"
L.item_active = "Objeto de uso activo"
L.item_weapon = "Arma"

L.item_armor = "Armadura"
L.item_armor_desc = [[
Reduce daño balístico, de fuego y explosión. Baja con el tiempo.

Puede ser comprado múltiples veces. Luego de alcanzar un valor específico, la armadura gana más blindaje.]]

L.item_radar = "Radar"
L.item_radar_desc = [[
Permite detectar señales de vida.

Empieza por sí solo luego de ser comprado.
Configúrelo en la pestaña del 
radar.]]

L.item_disg = "Disfraz"
L.item_disg_desc = [[
Esconde tu ID mientras está en uso. Además evade 
ser la última persona vista por un muerto.

Actívalo en la pestaña disfraz de este menú 
o presiona el numpad Enter.]]

-- C4
L.c4_hint = "Presiona {usekey} para armar o desarmar."
L.c4_no_disarm = "No puedes desactivar el C4 de otro traidor al menos que esté muerto."
L.c4_disarm_warn = "Un C4 que has plantado fue desactivado."
L.c4_armed = "Has armado la bomba correctamente."
L.c4_disarmed = "Has desarmado la bomba correctamente."
L.c4_no_room = "No puedes llevar este C4 contigo."

L.c4_desc = "Explosivo con temporizador potente."

L.c4_arm = "Armar C4"
L.c4_arm_timer = "Temporizador"
L.c4_arm_seconds = "Segundos antes de la detonación:"
L.c4_arm_attempts = "Al intentar desactivarlo, {num} de los 6 cables causarán una explosión instantánea al ser cortados."

L.c4_remove_title = "Remover"
L.c4_remove_pickup = "Recoger C4"
L.c4_remove_destroy1 = "Destruir C4"
L.c4_remove_destroy2 = "Confirmar: destruir"

L.c4_disarm = "Desarmar C4"
L.c4_disarm_cut = "Click para cortar el cable {num}"

L.c4_disarm_t = "Corta un cable para desactivar la bomba. Como eres traidor, todos los cables son seguros ¡Los inocentes no lo tendrán tan fácil!"
L.c4_disarm_owned = "Corta un cable para desactivar la bomba. Es tu bomba, así que cualquier cable la desarmará."
L.c4_disarm_other = "Corta un cable para desactivar la bomba ¡Explotará si eliges el incorrecto!"

L.c4_status_armed = "ARMADO"
L.c4_status_disarmed = "DESARMADO"

-- Visualizer
L.vis_name = "Visualizador"
L.vis_hint = "Presiona {usekey} para recogerlo (Sólo detectives)."

L.vis_short_desc = "Reproduce una escena del crimen si la victima fue asesinada con Disparos"

L.vis_desc = [[
Dispositivo para visualizar crímenes.

Analiza el cuerpo para saber cómo 
la víctima fue aseinada, únicamente 
si murió por heridas de bala.]]

-- Decoy
L.decoy_name = "Señuelo"
L.decoy_no_room = "No puedes llevar este señuelo."
L.decoy_broken = "¡Tu señuelo fue destruído!"

L.decoy_short_desc = "Este señuelo muestra una señal de vida falsa en el radar"
L.decoy_pickup_wrong_team = "No puedes recogerlo porque pertenece a otro equipo"

L.decoy_desc = [[
Muestra una señal falsa en el radar,
y hace que el escáner ADN muestre una falsa 
localización del señuelo si alguien escanea 
tu ADN.]]

-- Defuser
L.defuser_name = "Kit de Desactivación"
L.defuser_help = "{primaryfire} desactiva el C4."

L.defuser_desc = [[
Desactiva instantáneamente un C4.

Usos ilimitados. El C4 será más fácil 
de ver si llevas esto.]]

-- Flare gun
L.flare_name = "Pistola de Bengalas"
L.flare_desc = [[
Puede ser usada para quemar cadáveres 
para nunca ser encontrados. Munición limitada.

Quemar un cuerpo hace un 
sonido distintivo.]]

-- Health station
L.hstation_name = "Estación de Curación"
L.hstation_subtitle = "Presiona [{usekey}] para recibir curación."
L.hstation_charge = "Carga restante de la estación: {charge}"
L.hstation_empty = "No hay más carga en la estación"
L.hstation_maxhealth = "Ya estás curado completamente"
L.hstation_short_desc = "La estación de curación se re-llena con el tiempo"

L.hstation_broken = "¡Tu estación de curación fue destruida!"
L.hstation_help = "{primaryfire} coloca la Estación de Curación."

L.hstation_desc = [[
Permite que las personas se curen.

Recarga lenta. Cualquiera puede usarlo y 
puede ser dañada. Puede chequearse por el ADN 
de las personas que lo usen.]]

-- Knife
L.knife_name = "Cuchillo"
L.knife_thrown = "Cuchillo arrojadizo"

L.knife_desc = [[
Mata a los objetivos heridos instantáneamente y 
de manera silenciosa, pero tiene un solo uso.

Puede ser arrojado con el disparo alternativo (Click2).]]

-- Poltergeist
L.polter_desc = [[
Planta proyectiles en entidades para sacarlas 
volando violentamente.

El daño de energía daña a las personas en 
corta distancia.]]

-- Radio
L.radio_broken = "¡Tu radio fue destruida!"
L.radio_help_pri = "{primaryfire} coloca la Radio."

L.radio_desc = [[
Reproduce sonidos para distraer o confundir. 

Coloca la radio y luego 
reproduce sonidos en la pestaña de Radio 
en este menú.]]

-- Silenced pistol
L.sipistol_name = "Pistola Silenciada"

L.sipistol_desc = [[
Pistola de bajo sonido, usa munición de pistola 
común.

Las víctimas asesinadas con este arma no gritarán al morir.]]

-- Newton launcher
L.newton_name = "Cañón Newton"

L.newton_desc = [[
Empuja a las personas desde una distancia segura.

Munición infita pero disparo lento.]]

-- Binoculars
L.binoc_name = "Binoculares"
L.binoc_desc = [[
Apunta a los cadáveres e identifícalos 
desde una distancia lejana.

Usos ilimitados pero la identificación 
toma unos segundos.]]

-- UMP
L.ump_desc = [[
SMG Experimental que desorienta 
a tus objetivos.

Usa la munición estándar de las SMG.]]

-- DNA scanner
L.dna_name = "escáner de ADN"
L.dna_notfound = "No se encontraron muestras de ADN en el cadáver."
L.dna_limit = "Límite de depósito alcanzado. Remueva viejas muestras para adquirir nuevas."
L.dna_decayed = "La muestra de ADN del asesino se ha deteriorado."
L.dna_killer = "¡Has recogido una muestra de ADN del asesino que quedó en el cadáver!"
L.dna_duplicate = "¡Confirmado! La muestra analizada ya la tienes en tu escáner."
L.dna_no_killer = "El ADN no pudo ser analizado (¿Asesino desconectado?)."
L.dna_armed = "¡La bomba está andando! ¡Desármala primero!"
L.dna_object = "Se ha recogido una muestra del último dueño del objeto."
L.dna_gone = "No se detectó ADN en la zona."
L.dna_tid_possible = "Escaneo posible"
L.dna_tid_impossible = "No hay escaneo posible"
L.dna_screen_ready = "Sin ADN"
L.dna_screen_match = "¡Se confirma!"

L.dna_desc = [[
Recoge muestras de ADN de las cosas 
y úsalas para encontrar el dueño del ADN.

Úsalo en cuerpos frescos para encontrar el ADN del asesino
y así encontrarlo para capturarlo.]]

-- Magneto stick
L.magnet_name = "Palo-Magnético"
L.magnet_help = "{primaryfire} para colgar el cuerpo a la superficie."

-- Grenades and misc
L.grenade_smoke = "Granada de Humo"
L.grenade_fire = "Granada Incendiaria"

L.unarmed_name = "Desarmado"
L.crowbar_name = "Crowbar"
L.pistol_name = "Pistola"
L.rifle_name = "Rifle"
L.shotgun_name = "Escopeta"

-- Teleporter
L.tele_name = "Teletransportador"
L.tele_failed = "Teletransporte abortado."
L.tele_marked = "Marca de Teletransporte colocada."

L.tele_no_ground = "¡No se lo podrá teletransportar sino se encuentra sobre una superficie sólida!"
L.tele_no_crouch = "¡No se lo podrá teletransportar si está agachado!"
L.tele_no_mark = "Sin marca. Marca un destino antes de pedir un teletransporte."

L.tele_no_mark_ground = "¡No se podrá marcar una ubicación sino se encuentra en una superficie sólida!"
L.tele_no_mark_crouch = "¡No se podrá marcar una ubicación si se encuentra agachado!"

L.tele_help_pri = "{primaryfire} lo teletransporta a la ubicación marcada."
L.tele_help_sec = "{secondaryfire} marca la ubicación actual."

L.tele_desc = [[
Lo teletransporta a una ubicación marcada previamente.

Teletransportarse hace ruido y el 
número de usos es limitado.]]

-- Ammo names, shown when picked up
L.ammo_pistol = "Munición de 9mm "

L.ammo_smg1 = "Munición de SMG"
L.ammo_buckshot = "Munición de Escopeta"
L.ammo_357 = "Munición de Rifle"
L.ammo_alyxgun = "Munición de Deagle"
L.ammo_ar2altfire = "Bengalas"
L.ammo_gravity = "Recarga de Poltergeist"


-- HUD interface text

-- Round status
L.round_wait = "Esperando"
L.round_prep = "Preparando"
L.round_active = "En progreso"
L.round_post = "Ronda terminada"

-- Health, ammo and time area
L.overtime = "TIEMPO EXTRA"
L.hastemode = "MODO RÁPIDO"

-- TargetID health status
L.hp_healthy = "Saludable"
L.hp_hurt = "Lastimado"
L.hp_wounded = "Herido"
L.hp_badwnd = "Gravemente herido"
L.hp_death = "Moribundo"


-- TargetID karma status
L.karma_max = "Respetable"
L.karma_high = "Vulgar"
L.karma_med = "Gatillo-fácil"
L.karma_low = "Peligroso"
L.karma_min = "Monstruo"

-- TargetID misc
L.corpse = "Cadáver"
L.corpse_hint = "Presiona [{usekey}] para inspeccionar. [{walkkey} + {usekey}] para inspeccionar silenciosamente."
L.corpse_too_far_away = "El cadáver está muy lejos."
L.corpse_binoculars = "Presiona [{key}] para inspeccionar el cadáver."
L.corpse_searched_by_detective = "Este cadáver fue inspeccionado por un detective."

L.target_disg = "(disfrazado)"
L.target_unid = "Cuerpo sin identificar"

L.target_credits = "Inspecciona para recibir los créditos no gastados"

L.target_c4 = "Presiona [{usekey}] para abrir el menú de C4"
L.target_c4_armed = "Presiona [{usekey}] para desarmar el C4"
L.target_c4_armed_defuser = "Presiona [{usekey}] para usar el kit de desactivación"
L.target_c4_not_disarmable = "No puedes desactivar el C4 de un compañero vivo"
L.c4_short_desc = "Algo muy explosivo"

L.target_pickup = "Presiona [{usekey}] para recoger"
L.target_slot_info = "Espacio: {slot}"
L.target_pickup_weapon = "Presiona [{usekey}] para recoger el arma"
L.target_switch_weapon = "Presiona [{usekey}] para intercambiar con tu arma actual"
L.target_pickup_weapon_hidden = ", presiona [{usekey} + {walkkey}] para recogerla silenciosamente"
L.target_switch_weapon_hidden = ", presiona [{usekey} + {walkkey}] para intercambiarla silenciosamente"
L.target_switch_weapon_nospace = "No hay espacio disponible para esta arma en tu inventario"
L.target_switch_drop_weapon_info = "Tirando {name} del espacio {slot}"
L.target_switch_drop_weapon_info_noslot = "No hay un arma que ocupe el espacio {slot}"

-- HUD buttons with hand icons that only some roles can see and use
L.tbut_single = "Único uso"
L.tbut_reuse = "Re-usable"
L.tbut_retime = "Re-usable después de {num} segundos"
L.tbut_help = "Presiona [{usekey}] para activarlo"
L.tbut_help_admin = "Editar configuración de traidor botón"
L.tbut_role_toggle = "[{walkkey} + {usekey}] para activar esto para {role}"
L.tbut_role_config = "Rol: {current}"
L.tbut_team_toggle = "[SHIFT + {walkkey} + {usekey}] para activar este botón para el equipo {team}"
L.tbut_team_config = "Equipo: {current}"
L.tbut_current_config = "Configuración actual:"
L.tbut_intended_config = "Configuración estándar recomendada:"
L.tbut_admin_mode_only = "Sólo visible para administradores '{cv}' está establecido en '1'"
L.tbut_allow = "Permitir"
L.tbut_prohib = "Prohibir"
L.tbut_default = "Por defecto"

-- Spectator muting of living/dead
L.mute_living = "Jugadores vivos silenciados"
L.mute_specs = "Espectadores silenciados"
L.mute_all = "Todos silenciados"
L.mute_off = "Nadie silenciado"
L.mute_team = "{team} silenciado."

-- Spectators and prop possession
L.punch_title = "MIDE-TU-FUERZA"
L.punch_help = "Teclas de movimiento o salto: golpea el objeto. Agacharse: dejar el objeto."
L.punch_bonus = "Tu bajo puntaje redujo el límite de tu MIDE-TU-FUERZA a {num}"
L.punch_malus = "¡Tu alto puntaje incrementó el límite de tu MIDE-TU-FUERZA por {num}!"

L.spec_help = "Click para ver o presiona {usekey} en un prop (physics) para controlarlo."
L.spec_help2 = "Para salir del modo espectador, abre el menú presionando {helpkey}, ve a 'Jugabilidad' y desactiva el modo espectador."

-- Info popups shown when the round starts

-- These are spread over multiple lines, hence the square brackets instead of
-- quotes. That's a Lua thing. Every line break (enter) will show up in-game.
L.info_popup_innocent = [[¡Eres un terrorista inocente! Pero hay traidores cerca...
¿En quién puedes confiar? ¿Quién estará dispuesto a acribillarte?

¡Cuida muy bien tu espalda y colabora con tus camaradas para salir vivo de esta!]]

L.info_popup_detective = [[¡Eres un detective! El cuartel general te ha dado herramientas para descubrir a los traidores.
Úsalas para ayudar a los inocentes, pero ten cuidado:
¡Es probable que los traidores intenten matarte primero!

¡Presiona {menukey} para recibir tus herramientas!]]

L.info_popup_traitor_alone = [[¡Eres un traidor! No tendrás camaradas esta ronda.

¡Mata a los demás roles para ganar!

¡Presiona {menukey} para recibir tu equipamiento especial!]]

L.info_popup_traitor = [[¡Eres un traidor! Colabora con tus camaradas asesinando a todos los demás.
Ten cuidado, tu traición puede ser descubierta...

Estos son tus compañeros: 
{traitorlist}

¡Presiona {menukey} para recibir tu equipamiento especial!]]

-- Various other text
L.name_kick = "Un jugador fue automáticamente expulsado por cambiarse el nombre."

L.idle_popup = [[Estuviste quieto por {num} segundos y como consecuencia fuiste movido al modo Sólo-Espectador. Mientras estés en este modo, no reaparecerás la siguiente ronda.

Siempre puedes entrar o salir del modo Sólo-Espectador usando el menú {helpkey} y destildando la opción en la configuración. También puedes desactivarlo ahora mismo.]]

L.idle_popup_close = "No hacer nada"
L.idle_popup_off = "Desactivar modo Sólo-Espectador ahora"

L.idle_warning = "Cuidado: ¡Parece que estás quieto/AFK, te convertirás en espectador al menos que muestres señales de vida!"

L.spec_mode_warning = "Estás en modo Sólo-Espectador y no reaparecerás cuando una nueva ronda comience. Para desactivar este modo, presiona F1, ve a Configuración y desactiva el modo 'Sólo-Espectador'."


-- Tips, shown at bottom of screen to spectators

-- Tips panel
L.tips_panel_title = "Consejos"
L.tips_panel_tip = "Consejo:"

-- Tip texts

L.tip1 = "Los traidores pueden inspeccionar los cuerpos silenciosamente, sin confirmar la muerte, manteniendo {walkkey} y presionando {usekey} en el cadáver."

L.tip2 = "Armar un C4 con un temporizador largo incrementará el número de cables que causan explosión instantánea cuando un inocente intenta desarmarlo. Además, hará menos ruido."

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

L.tip21 = "La estación de curación de los detectives. Obviamente, esos curados pueden ser traidores..."

L.tip22 = "La estación de curación toma una muestra de ADN de todo aquel que la use. Los detectives pueden usar un escáner ADN para analizar estas muestras."

L.tip23 = "A diferencia de las armas y el C4, la radio de traidores no deja marcas de ADN. No te preocupes si la encuentran y la rompen."

L.tip24 = "Presiona {helpkey} para ver el tutorial o cambiar configuraciones. Por ejemplo, puedes desactivar estos consejos."

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

L.tip40 = "Si dice 'MODO RÁPIDO' la ronda inicial tendrá menos tiempo que de lo común, pero con cada muerte el tiempo incrementa. Este modo presiona a los traidores a mantenerse activos."


-- Round report

L.report_title = "Reporte de Ronda"

-- Tabs
L.report_tab_hilite = "Jugadas destacadas"
L.report_tab_hilite_tip = "Jugadas de la partda"
L.report_tab_events = "Eventos"
L.report_tab_events_tip = "Registro de eventos de esta ronda"
L.report_tab_scores = "Puntajes"
L.report_tab_scores_tip = "Puntaje por jugador durante esta ronda"

-- Event log saving
L.report_save = "Save Log .txt"
L.report_save_tip = "Guarda los registros de evento en un archivo de texto"
L.report_save_error = "No hay data de eventos para guardar."
L.report_save_result = "El registro de eventos fue guardado en:"

-- Big title window
L.hilite_win_traitors = "LOS TRAIDORES GANAN"
L.hilite_win_bees = "LAS ABEJAS GANAN"
L.hilite_win_innocents = "LOS INOCENTES GANAN"

L.hilite_players1 = "{numplayers} tomaron parte, {numtraitors} eran traidores"
L.hilite_players2 = "{numplayers} tomaron parte, uno de ellos era traidor"

L.hilite_duration = "La ronda duró {time}"

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

-- Name of a trap that killed us that has not been named by the mapper
L.something = "Algo"

-- Kill events
L.ev_blowup = "{victim} se reventó"
L.ev_blowup_trap = "{victim} fue reventado por {trap}"

L.ev_tele_self = "{victim} se telemató"
L.ev_sui = "{victim} no pudo soportarlo y se suicidó"
L.ev_sui_using = "{victim} se suicidó usando {tool}"

L.ev_fall = "{victim} se cayó hacia su muerte"
L.ev_fall_pushed = "{victim} se cayó hacia su muerta luego de que {attacker} lo empujara"
L.ev_fall_pushed_using = "{victim} se cayó hacia su muerte luego de que {attacker} usara {trap} para empujarlo"

L.ev_shot = "{victim} fue acribillado por {attacker}"
L.ev_shot_using = "{victim} fue acribillado por {attacker} usando un/a {weapon}"

L.ev_drown = "{victim} fue asfixiado hasta la muerte por {attacker}"
L.ev_drown_using = "{victim} fue asfixiado hasta la muerte con {trap} activado por {attacker}"

L.ev_boom = "{attacker} hizo volar por los aires a {victim}"
L.ev_boom_using = "{attacker} hizo volar por los aires a {victim} usando {trap}"

L.ev_burn = "{victim} fue incinerazo por {attacker}"
L.ev_burn_using = "{victim} fue incinerado con {trap} por {attacker}"

L.ev_club = "{victim} fue golpeado hasta la muerte por {attacker}"
L.ev_club_using = "{victim} fue golpeado hasta la muerte por {attacker} usando {trap}"

L.ev_slash = "{victim} fue apuñalado por {attacker}"
L.ev_slash_using = "{victim} fue cortado en partes por {attacker} usando {trap}"

L.ev_tele = "{victim} fue teleasesinado por {attacker}"
L.ev_tele_using = "{victim} fue reventado con {trap} por {attacker}"

L.ev_goomba = "{victim} fue lanzado por los aires por {attacker}"

L.ev_crush = "{victim} fue aplastado por {attacker}"
L.ev_crush_using = "{victim} fue aplastado con {trap} por {attacker}"

L.ev_other = "{victim} fue asesinado por {attacker}"
L.ev_other_using = "{victim} fue asesinado por {attacker} usando {trap}"

-- Other events
L.ev_body = "{finder} encontró el cuerpo de {victim}"
L.ev_c4_plant = "{player} plantó un C4"
L.ev_c4_boom = "El C4 plantado por {player} explotó"
L.ev_c4_disarm1 = "{player} desarmó un  C4 plantado por {owner}"
L.ev_c4_disarm2 = "{player} falló al intentar desarmar un C4 plantado por {owner}"
L.ev_credit = "{finder} encontró {num} crédito(s) en el cuerpo de {player}"

L.ev_start = "La ronda comenzó"
L.ev_win_traitors = "¡Los asquerosos traidores ganaron la ronda!"
L.ev_win_innocents = "¡Los dulces inocentes ganaron la ronda!"
L.ev_win_time = "Los traidores han agotado las reservas. El tiempo se acabó."

-- Awards/highlights

L.aw_sui1_title = "Líder del Culto Suicida"
L.aw_sui1_text = "les ha mostrado el camino a los otros suicidas siendo el primero en hacerlo."

L.aw_sui2_title = "Solo y deprimido"
L.aw_sui2_text = "fue el único que se mató a sí mismo."

L.aw_exp1_title = "Beca para Investigación de Químicos"
L.aw_exp1_text = "era reconocido por su gran investigación en el campo de la química, especialmente explosiva. {num} sujetos de investigación contribuyeron."

L.aw_exp2_title = "Investigación de Campo"
L.aw_exp2_text = "probó su resistencia a los explosivos. No era una buena defensa."

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

L.aw_nkt5_title = "Operación masacre"
L.aw_nkt5_text = "le pagan por matar. Parece que se divirtió."

L.aw_nki1_title = "Traiciona esta"
L.aw_nki1_text = "encontró a un traidor. Le disparó. Fácil."

L.aw_nki2_title = "Almas Corruptas"
L.aw_nki2_text = "unió a dos traidores en el más allá."

L.aw_nki3_title = "Los traidores en discordia"
L.aw_nki3_text = "pon tres traidores a dormir."

L.aw_nki4_title = "Problemas Internos"
L.aw_nki4_text = "mató traidores como si fuera un traidor. Creemos que el juego era al revés."

L.aw_fal1_title = "Salto, Saltito, Saltote"
L.aw_fal1_text = "empujó a alguien desde una gran altura."

L.aw_fal2_title = "En Picada"
L.aw_fal2_text = "Dejó que su cuerpo se desplome luego de haber viajado en picada."

L.aw_fal3_title = "El Meteorito Humano"
L.aw_fal3_text = "aplastó a alguien cayendo sobre él desde una gran altura."

L.aw_hed1_title = "Sensor de Cerebros"
L.aw_hed1_text = "descubrió el placer de volar cabezas haciendo saltar por los aires a {num} personas."

L.aw_hed2_title = "Neurólogo"
L.aw_hed2_text = "removió exitosamente el cerebro de {num} personas para examinarlos... en otra partida."

L.aw_hed3_title = "Programa Nuevo Mundo"
L.aw_hed3_text = "aplicó su programa de realidad virtual y fue asistido para abrir los cráneos a {num} personas."

L.aw_cbr1_title = "Palancazo"
L.aw_cbr1_text = "Tiene el verdadero swing para agitar la crowbar, cobrándose así {num} víctimas."

L.aw_cbr2_title = "Freeman"
L.aw_cbr2_text = "Terminó Half-Life machacando a {num} personas."

L.aw_pst1_title = "Pequeño pero poderoso"
L.aw_pst1_text = "marcó {num} usando la pistola. Poderoso el chiquitín."

L.aw_pst2_title = "Masacre calibre 9mm"
L.aw_pst2_text = "asesinó una pequeña armada de {num} personas con pistola."

L.aw_sgn1_title = "Cartuchos de venta libre"
L.aw_sgn1_text = "activó su escopeta contra {num} objetivos. No eran balas de goma."

L.aw_sgn2_title = "Lluvia de Perdigones"
L.aw_sgn2_text = "le disgustaba la lluvia así que le dio su estilo propio. {num} personas fueron "mojadas" por esta."

L.aw_rfl1_title = "Apunta y dispara"
L.aw_rfl1_text = "demostró que para matar {num} personas sólo es necesario un rifle y una buena mano."

L.aw_rfl2_title = "Puedo ver esa cabeza desde aquí"
L.aw_rfl2_text = "conoce bien su rifle. Otras {num} personas lo conocieron bien también."

L.aw_dgl1_title = "Es como un rifle pequeño"
L.aw_dgl1_text = "le encontró el truco a la Desert Eagle y se llevó consigo a {num} personas."

L.aw_dgl2_title = "Maestro de la Deagle"
L.aw_dgl2_text = "reventó a {num} personas con su pequeño cañón de mano."

L.aw_mac1_title = "Reza y mata"
L.aw_mac1_text = "mató a {num} personas con la MAC10. No pregunten cuánta munición usó para lograrlo."

L.aw_mac2_title = "Máquina de matar"
L.aw_mac2_text = "se cuestiona cuánto podría matar si pudiera llevar dos MAC10. ¿{num} por dos?"

L.aw_sip1_title = "SHHHH"
L.aw_sip1_text = "le cerró la boca a {num} personas con la pistola silenciada."

L.aw_sip2_title = "Asesino Silencioso"
L.aw_sip2_text = "asesinó a {num} personas que no lograron oir su muerte."

L.aw_knf1_title = "Al filo del internet"
L.aw_knf1_text = "nos ha mostrado como untar manteca en la cara de alguien y lo ha subido a internet."

L.aw_knf2_title = "Origen Desconocido"
L.aw_knf2_text = "no era traidor, de igual manera logró cortar a alguien en pedacitos."

L.aw_knf3_title = "El Hombre Alfanje"
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

L.aw_tkl1_title = "La cagó"
L.aw_tkl1_text = "se le resbaló el dedo, cobrándose la vida de un compañero."

L.aw_tkl2_title = "Esta es la vencida"
L.aw_tkl2_text = "pensó que atrapó a un traidor dos veces... las dos veces falló."

L.aw_tkl3_title = "Superstición"
L.aw_tkl3_text = "no pudo parar luego de matar a dos compañeros. El tres es su número de la suerte."

L.aw_tkl4_title = "Elba Neado"
L.aw_tkl4_text = "asesinó a todo su equipo. Seguramente lo banean."

L.aw_tkl5_title = "Sádico"
L.aw_tkl5_text = "disfruta mucho de ver morir a los suyos. Una pisca de desesperación."

L.aw_tkl6_title = "Hay que leer"
L.aw_tkl6_text = "no entendió en qué equipo estaba y terminó matando a la mitad de sus compañeros."

L.aw_tkl7_title = "Gangster Ciego"
L.aw_tkl7_text = "tenía que proteger su territorio, pero no de los suyos."

L.aw_brn1_title = "Como en McDonald's"
L.aw_brn1_text = "convirtió a varias personas en papas fritas."

L.aw_brn2_title = "Fosforescente"
L.aw_brn2_text = "inventó las balizas fosforescentes... con un cuerpo humano."

L.aw_brn3_title = "Parrilla Libre"
L.aw_brn3_text = "hizo un gran almuerzo y todos están invitados... lástima que no quedó nadie."

L.aw_fnd1_title = "Forense"
L.aw_fnd1_text = "encontró {num} cuerpos tirados por ahí."

L.aw_fnd2_title = "¡Atrápalos ya!"
L.aw_fnd2_text = "capturó, digo, encontró {num} cuerpos y los llevó a su colección, digo, a la morgue."

L.aw_fnd3_title = "Olor a Muerte"
L.aw_fnd3_text = "no puedo parar de encontrar cadáveres, {num} veces durante esta ronda."

L.aw_crd1_title = "Reciclaje"
L.aw_crd1_text = "recuperó {num} créditos sin gastar de otros jugadores."

L.aw_tod1_title = "Pérdida culposa"
L.aw_tod1_text = "murió pocos segundos después de que su equipo ganara la ronda."

L.aw_tod2_title = "A Casa"
L.aw_tod2_text = "murió justo después de que empezara la ronda."


-- New and modified pieces of text are placed below this point, marked with the
-- version in which they were added, to make updating translations easier.


-- v23
L.set_avoid = "Evadir se seleccionado como {role}."
L.set_avoid_tip = "Activa esto para solicitarle al servidor que evite asignarte el rol {role} si es posible."

-- v24
L.drop_no_ammo = "Munición insuficiente en tu cargador como para soltarla en una caja."
L.drop_ammo_prevented = "Algo previene que puedas tirar tu munición."

-- v31
L.set_cross_brightness = "Brillo de la mira"
L.set_cross_size = "Tamaño de la mira"

-- 5-25-15
L.hat_retrieve = "Has recogido el Sombrero del Detective."

-- 2018-07-24
L.equip_tooltip_main = "Menu de Equipamiento"
L.equip_tooltip_radar = "Control del Radar"
L.equip_tooltip_disguise = "Control del Disfraz"
L.equip_tooltip_radio = "Controla de la Radio"
L.equip_tooltip_xfer = "Transferir créditos"
L.equip_tooltip_reroll = "Mezclar objetos"

L.confgrenade_name = "Granada"
L.polter_name = "Poltergeist"
L.stungun_name = "Prototipo UMP"

L.knife_instant = "ASESINATO INSTANTÁNEO"

L.dna_hud_type = "TIPO"
L.dna_hud_body = "CUERPO"
L.dna_hud_item = "OBJETO"

L.binoc_zoom_level = "Nivel de Zoom"
L.binoc_body = "CUERPO DETECTADO"
L.binoc_progress = "Progreso de búsqueda: {progress}%"

L.idle_popup_title = "Inactivo"

-- 6-22-17 (Crosshair)
L.set_title_cross = "Configuración de la mira"

L.set_cross_color_enable = "Activar color personalizado"
L.set_cross_color = "Color de la mira:"
L.set_cross_gap_enable = "Activar espaciado personalizado"
L.set_cross_gap = "Espaciado de la mira"
L.set_cross_static_enable = "Activar mira estática"
L.set_ironsight_cross_opacity = "Opacidad de la mira de hierro"
L.set_cross_weaponscale_enable = "Activar diferentes escalados para distintas armas"
L.set_cross_thickness = "Ancho de la mira:"
L.set_cross_outlinethickness = "Ancho externo de la mira"
L.set_cross_dot_enable = "Activar punto en la mira"

-- ttt2
L.create_own_shop = "Crear tienda propia"
L.shop_link = "Enlazar con"
L.shop_disabled = "Desactivar tienda"
L.shop_default = "Usar tienda por defecto"

L.shop_editor_title = "Editor de Tienda"
L.shop_edit_items_weapong = "Editar objetos / armas"
L.shop_edit = "Editar tienda"
L.shop_settings = "Configuración"
L.shop_select_role = "Seleccionar rol"
L.shop_edit_items = "Editar Objetos"
L.shop_edit_shop = "Editar Tienda"
L.shop_create_shop = "Crear tienda personalizada"
L.shop_selected = "Selccionado {role}"
L.shop_settings_desc = "Cambia los valores para adaptar una Tienda Random (ConVars). No olvides guardar los cambios."

L.f1_settings_changes_title = "Cambios"
L.f1_settings_hudswitcher_title = "Alternar HUD"
L.f1_settings_bindings_title = "Binds de Teclas"
L.f1_settings_interface_title = "Interfaz"
L.f1_settings_gameplay_title = "Jugabilidad"
L.f1_settings_crosshair_title = "Mira"
L.f1_settings_dmgindicator_title = "Indicador de Daño"
L.f1_settings_language_title = "Lenguaje"
L.f1_settings_administration_title = "Administración"
L.f1_settings_shop_title = "Tienda de Equipamiento"

L.f1_settings_shop_desc_shopopen = "¿Abrir la tienda con botón de tienda en vez del botón para la tabla de puntuaciones al principio / final de la ronda?"
L.f1_settings_shop_title_layout = "Diseño de lista de Objetos"
L.f1_settings_shop_desc_num_columns = "Número de columnas"
L.f1_settings_shop_desc_num_rows = "Número de filas"
L.f1_settings_shop_desc_item_size = "Tamaño del Ícono"
L.f1_settings_shop_title_marker = "Configuración del marcador de objetos"
L.f1_settings_shop_desc_show_slot = "Mostrar el marcador"
L.f1_settings_shop_desc_show_custom = "Mostrar el marcador personalizado"
L.f1_settings_shop_desc_show_favourite = "Mostrar marcador favorito"

L.f1_shop_restricted = "Cambios individuales en la estructura de la tienda no habilitados en el servidor."

L.f1_settings_hudswitcher_desc_basecolor = "Color Base"
L.f1_settings_hudswitcher_desc_hud_scale = "Escalado del HUD (resets saved changes)"
L.f1_settings_hudswitcher_button_close = "Cerrar"
L.f1_settings_hudswitcher_desc_reset = "Reiniciar la Data del HUD"
L.f1_settings_hudswitcher_button_reset = "Reiniciar"
L.f1_settings_hudswitcher_desc_layout_editor = "Cambiar la posición y \ntamaño del elemento"
L.f1_settings_hudswitcher_button_layout_editor = "Editor de Diseño"
L.f1_settings_hudswitcher_desc_hud_not_supported = "! ESTE HUD NO SOPORTA EL EDITOR DE HUD !"

L.f1_bind_reset_default = "Por Defecto"
L.f1_bind_disable_bind = "Limpiar"
L.f1_bind_description = "Clickea y presiona una tecla para crear un bind/atajo."
L.f1_bind_reset_default_description = "Reiniciar a la tecla por defecto."
L.f1_bind_disable_description = "Limpiar el bind/atajo de una tecla."
L.ttt2_bindings_new = "Nuevo bind/atajo para {name}: {key}"

L.f1_bind_weaponswitch = "Intercambiar Arma"
L.f1_bind_sprint = "Correr"
L.f1_bind_voice = "Chat de Voz Global"
L.f1_bind_voice_team = "Chat de Voz Equipo"

L.f1_dmgindicator_title = "Configuración del Indicador de Daño "
L.f1_dmgindicator_enable = "Activar"
L.f1_dmgindicator_mode = "Seleccionar un tema para el indicador de daño"
L.f1_dmgindicator_duration = "Segundos que el indicador de daño está activo luego de recibir un golpe"
L.f1_dmgindicator_maxdamage = "Daño necesario para la opacidad máxima"
L.f1_dmgindicator_maxalpha = "Daño necesario para la opacidad mínima"

L.ttt2_bindings_new = "Nuevo bind/atajo para {name}: {key}"
L.hud_default = "HUD por defecto"
L.hud_force = "HUD Forzado"
L.hud_restricted = "HUDs Restringidos"
L.hud_default_failed = "Error al establecer el HUD {hudname} como el nuevo por defecto. No tienes permiso o ese HUD no existe."
L.hud_forced_failed = "Error al establecer el HUD {hudname}. No tienes permiso o ese HUD no existe."
L.hud_restricted_failed = "Error al restringir el HUD {hudname}. No tienes permiso para hacer eso."

L.shop_role_select = "Selecciona un rol"
L.shop_role_selected = "La tienda de{roles} fue seleccionada"
L.shop_search = "Buscar"

L.button_save = "Guardar"

L.disable_spectatorsoutline = "Desactivar delineado de los objetos seleccionados"
L.disable_spectatorsoutline_tip = "Desactivar delineado de objetos controlados por espectadores (+Optimización)"

L.disable_overheadicons = "Desactivar íconos de los roles"
L.disable_overheadicons_tip = "Desactivar el ícono del rol de los jugadores (+Optimización)"

-- 2020-01-04
L.doubletap_sprint_anykey = "Doble tecla de movimiento (W) para correr"
L.doubletap_sprint_anykey_tip = "No pararás de correr hasta que pares de moverte"

L.disable_doubletap_sprint = "Desactivar la doble tecla para correr"
L.disable_doubletap_sprint_tip = "Tocar dos veces la tecla de movimiento no hará que corras"

-- 2020-02-03
L.hold_aim = "Mantén para apuntar"
L.hold_aim_tip = "No pararás de apuntar hasta soltar el botón de apuntado (por defecto: botón derecho del mouse)"

-- 2020-02-09
L.name_door = "Puerta"
L.door_open = "Presiona [{usekey}] para abrir la puerta."
L.door_close = "Presiona [{usekey}] para cerrar la puerta."
L.door_locked = "¡Esta puerta está bloqueada!"

-- 2020-02-11
L.automoved_to_spec = "(MENSAJE AUTOMÁTICO) Fuiste movido al modo espectador por estar AFK/Inactivo."

-- 2020-02-16
L.door_auto_closes = "Esta puerta se cierra automáticamente."
L.door_open_touch = "Camina hacia esta puerta para abrirla."
L.door_open_touch_and_use = "Camina hacia esta puerta o presiona [{usekey}] para abrirla."
L.hud_health = "Vida"

-- 2020-04-20
L.item_speedrun = "Caminata ligera"
L.item_speedrun_desc = [[¡Te hace 50% más rápido!]]
L.item_no_explosion_damage = "Sin Daño a Explosiones"
L.item_no_explosion_damage_desc = [[Te hace inmune al daño explosivo.]]
L.item_no_fall_damage = "Sin Daño a Caídas"
L.item_no_fall_damage_desc = [[Te hace inmune al daño por caída.]]
L.item_no_fire_damage = "Sin Daño al Fuego"
L.item_no_fire_damage_desc = [[Te hace inmune al daño por quemaduras.]]
L.item_no_hazard_damage = "Adiós Peligros Biológicos"
L.item_no_hazard_damage_desc = [[Te hace inmune al veneno, radiación y ácido.]]
L.item_no_energy_damage = "Sin Daño a la Energía"
L.item_no_energy_damage_desc = [[Te hace inmune a los láseres, plasma y rayos.]]
L.item_no_prop_damage = "Sin Daño a los Objetos"
L.item_no_prop_damage_desc = [[Te hace inmune al daño por objetos arrojados hacia tí.]]
L.item_no_drown_damage = "Sin Daño a Ahogarse"
L.item_no_drown_damage_desc = [[Te hace inmune al daño por estar debajo del agua cuando se agote tu oxígeno.]]

-- 2020-04-30
L.message_revival_canceled = "Renacimiento cancelado."
L.message_revival_failed = "Renacimiento fallido."
L.message_revival_failed_missing_body = "No has sido revivido porque tu cuerpo ya no existe."
L.hud_revival_title = "Tiempo restante antes de renacer:"
L.hud_revival_time = "{time}s"

-- 2020-05-03
L.door_destructible = "La puerta es desctructible (VIDA {health})"

-- 2020-05-28
L.confirm_detective_only = "Sólo los detectives pueden confirmar cadáveres"
L.inspect_detective_only = "Sólo los detectives pueden inspeccionar cuerpos"
L.corpse_hint_no_inspect = "Sólo los detectives pueden inspeccionar este cuerpo."
L.corpse_hint_inspect_only = "Presiona [{usekey}] para inspeccionar. Sólo los detectives pueden inspeccionar cuerpos."
L.corpse_hint_inspect_only_credits = "Presiona [{usekey}] para recibir los créditos. Sólo los detectives pueden inspeccionar este cuerpo."

-- 2020-06-04
L.label_bind_disguiser = "Activar Disfraz"

-- 2020-06-24
L.dna_help_primary = "Recoger una muestra de ADN"
L.dna_help_secondary = "Cambiar espacio (slot) para el ADN"
L.dna_help_reload = "Borrar la muestra"

L.binoc_help_pri = "Identifica a un cuerpo."
L.binoc_help_sec = "Cambiar nivel de zoom."

L.vis_help_pri = "Deja el dispositivo activo."

L.decoy_help_pri = "Planta el señuelo."

L.set_cross_lines_enable = "Activar líneas de la mira"