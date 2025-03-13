-- Portuguese language strings

local L = LANG.CreateLanguage("pt_br")

-- Compatibility language name that might be removed soon.
-- the alias name is based on the original TTT language name:
-- https://github.com/Facepunch/garrysmod/blob/master/garrysmod/gamemodes/terrortown/gamemode/lang/english.lua
L.__alias = "portuguese"

L.lang_name = "Português (Brasil)"

-- General text used in various places
L.traitor = "Traidor"
L.detective = "Detetive"
L.innocent = "Inocente"
L.last_words = "Últimas palavras"

L.terrorists = "Terroristas"
L.spectators = "Espectadores"

L.nones = "Sem time"
L.innocents = "Time Inocente"
--L.traitors = "Team Traitor"

-- Round status messages
L.round_minplayers = "Não há jogadores suficientes para começar uma nova rodada..."
L.round_voting = "Votação em andamento, adiando nova rodada em {num} segundos..."
L.round_begintime = "Uma nova rodada começará em {num} segundos. Prepare-se."

L.round_traitors_one = "Traidor, você é um assassino solitário."
L.round_traitors_more = "Traidor, estes são seus aliados: {names}"

L.win_time = "O tempo acabou. Os Traidores perderam."
L.win_traitors = "Os Traidores venceram!"
L.win_innocents = "Os Inocentes venceram!!"
L.win_nones = "Não há vencedores!"
L.win_showreport = "Os resultados da rodada serão exibidos por {num} segundos."

L.limit_round = "Limite de rodadas atingido. O próximo mapa mudará em breve."
L.limit_time = "Tempo limite atingindo. O próximo mapa mudará em breve."
L.limit_left_session_mode_1 = "Ainda há {num} rodada(s) ou {time} minutos restantes antes da troca de mapa."
--L.limit_left_session_mode_2 = "{time} minutes remaining before the map changes."
--L.limit_left_session_mode_3 = "{num} round(s) remaining before the map changes."

-- Credit awards
L.credit_all = "Seu time foi recompensado com {num} crédito(s) de equipamento por seu desempenho."
L.credit_kill = "Você recebeu {num} crédito(s) por matar um {role}."

-- Karma
L.karma_dmg_full = "Seu Karma é {amount}, então você causará dano total nesta rodada!!"
L.karma_dmg_other = "Seu Karma é {amount}. Portanto, todo dano que você causar será reduzido em {num}%"

-- Body identification messages
L.body_found = "{finder} encontrou o corpo de {victim}. {role}"
L.body_found_team = "{finder} encontrou o corpo de {victim}. {role} ({team})"

-- The {role} in body_found will be replaced by one of the following:
L.body_found_traitor = "Ele(a) era um(a) Traidor(a)!"
L.body_found_det = "Ele(a) era um(a) Detetive."
L.body_found_inno = "Ele(a) era um(a) Inocente."

L.body_call = "{player} chamou o Detetive para o corpo de {victim}!"
L.body_call_error = "Você deve confirmar a morte deste jogador antes de chamar um Detetive!"

L.body_burning = "Eita! Este cadáver está pegando fogo!"
L.body_credits = "Você encontrou {num} crédito(s) no corpo!"

-- Menus and windows
L.close = "Fechar"
L.cancel = "Cancelar"

-- For navigation buttons
L.next = "Próximo"
L.prev = "Anterior"

-- Equipment buying menu
L.equip_title = "Equipamento"
L.equip_tabtitle = "Adquirir Equipamento"

L.equip_status = "Status da compra"
L.equip_cost = "Você tem {num} crédito(s) restantes."
L.equip_help_cost = "Cada equipamento que você comprar custará 1 crédito."

L.equip_help_carry = "Você só pode comprar coisas as quais você tenha algum compartimento para guardá-las."
L.equip_carry = "Você pode comprar este equipamento."
L.equip_carry_own = "Você já tem este equipamento."
L.equip_carry_slot = "Você já tem um equipamento no compartimento {slot}."
L.equip_carry_minplayers = "Não há jogadores o suficiente para habilitar esta arma."

L.equip_help_stock = "Certos itens só poderão ser comprados uma única vez por rodada."
L.equip_stock_deny = "Este item não está mais em estoque."
L.equip_stock_ok = "Este item está em estoque."

L.equip_custom = "Item personalizado adicionado por este servidor."

L.equip_spec_name = "Nome"
L.equip_spec_type = "Tipo"
L.equip_spec_desc = "Descrição"

L.equip_confirm = "Comprar"

-- Disguiser tab in equipment menu
L.disg_name = "Disfarce"
L.disg_menutitle = "Controle do Disfarce"
L.disg_not_owned = "Você não possui um Disfarce!"
L.disg_enable = "Habilitar Disfarce"

L.disg_help1 = "Quando você está disfarçado, seu nome, saúde e karma não são exibidos quando alguém olha para você. Em adição, você é ocultado dos radares dos Detetives"
L.disg_help2 = "Pressione a tecla Enter do teclado numérico para disfarçar-se sem usar o menu. Você também pode fazer uma bind com o comando 'ttt_toggle_disguise' usando o console."

-- Radar tab in equipment menu
L.radar_name = "Radar"
L.radar_menutitle = "Controle do Radar"
L.radar_not_owned = "Você não possui um Radar!"
L.radar_scan = "Realizar varredura"
L.radar_auto = "Automatizar"
L.radar_help = "Os resultados serão exibidos por {num} segundos. Logo após, o Radar será recarregado para poder ser utilizado novamente."
L.radar_charging = "O seu Radar ainda está sendo recarregado!"

-- Transfer tab in equipment menu
L.xfer_name = "Transferência"
L.xfer_menutitle = "Transferência de créditos"
L.xfer_send = "Enviar um crédito"

L.xfer_no_recip = "Destinatário inválido, transferência de créditos cancelada."
L.xfer_no_credits = "Você não tem créditos suficientes para transferir."
L.xfer_success = "A transferência de créditos para {player} foi bem-sucedida."
L.xfer_received = "{player} lhe deu {num} crédito(s)."

-- Radio tab in equipment menu
L.radio_name = "Rádio"

-- Radio soundboard buttons
L.radio_button_scream = "Grito"
L.radio_button_expl = "Explosão"
L.radio_button_pistol = "Tiros de Pistola"
L.radio_button_m16 = "Tiros de M16"
L.radio_button_deagle = "Tiros de Deagle"
L.radio_button_mac10 = "Tiros de MAC10"
L.radio_button_shotgun = "Tiros de Escopeta"
L.radio_button_rifle = "Tiro de Rifl"
L.radio_button_huge = "Tiros de H.U.G.E"
L.radio_button_c4 = "C4 apitando"
L.radio_button_burn = "Em chamas"
L.radio_button_steps = "Passos"

-- Intro screen shown after joining
L.intro_help = "Caso você seja novato, pressione F1 para abrir o tutorial!"

-- Radiocommands/quickchat
L.quick_title = "Atalhos do chat"

L.quick_yes = "Sim."
L.quick_no = "Não."
L.quick_help = "Ajuda!"
L.quick_imwith = "Estou com {player}."
L.quick_see = "Eu vejo {player}."
L.quick_suspect = "{player} está agindo de maneira suspeita."
L.quick_traitor = "{player} é um Traidor!"
L.quick_inno = "{player} é inocente."
L.quick_check = "Alguém ainda está vivo?"

-- {player} in the quickchat text normally becomes a player nickname, but can
-- also be one of the below.  Keep these lowercase.
L.quick_nobody = "ninguém"
L.quick_disg = "alguém disfarçado"
L.quick_corpse = "um corpo não identificado"
L.quick_corpse_id = "o cadáver de {player}"

-- Scoreboard
L.sb_playing = "Você está jogando em..."
--L.sb_mapchange_mode_0 = "Session limits are disabled."
L.sb_mapchange_mode_1 = "O mapa será mudado em {num} rodadas ou em {time}"
--L.sb_mapchange_mode_2 = "Map changes in {time}"
--L.sb_mapchange_mode_3 = "Map changes in {num} rounds"

L.sb_mia = "Desaparecidos"
L.sb_confirmed = "Mortes Confirmadas"

L.sb_ping = "Ping"
L.sb_deaths = "Mortes"
L.sb_score = "Pontos"
L.sb_karma = "Karma"

L.sb_info_help = "Investigue o corpo deste jogador e então você poderá rever os resultados aqui."

L.sb_tag_friend = "AMIGO"
L.sb_tag_susp = "SUSPEITO"
L.sb_tag_avoid = "EVITAR"
L.sb_tag_kill = "MATAR"
L.sb_tag_miss = "DESAPARECIDO"

-- Equipment actions, like buying and dropping
L.buy_no_stock = "Esta arma está fora de estoque: você já a comprou nesta rodada."
L.buy_pending = "Você já tem um pedido pendente, aguarde até recebê-lo."
L.buy_received = "Você recebeu seu equipamento especial."

L.drop_no_room = "Não há espaço suficiente para jogar esta arma fora!"

L.disg_turned_on = "Disfarce habilitado!"
L.disg_turned_off = "Disfarce desabilitado."

-- Equipment item descriptions
L.item_passive = "Item de efeito passivo"
L.item_active = "Item de uso ativo"
L.item_weapon = "Arma"

L.item_armor = "Colete Balístico"
L.item_armor_desc = [[
Reduz o dano das balas em 30% quando você é atingido.

Equipamento padrão de Detetives.]]

L.item_radar = "Radar"
L.item_radar_desc = [[
Permite varrer sinais vitais.

Varre automaticamente assim que você o compra. Configure-o na aba Radar deste menu.]]

L.item_disg = "Disfarce"
L.item_disg_desc = [[
Oculta sua identidade enquanto habilitado. Também evita ser a última pessoa vista por uma vítima.

Habilite-o na aba Disfarce deste menu ou aperte a tecla Enter do teclado numérico.]]

-- C4
L.c4_disarm_warn = "Um explosivo C4 que você plantou foi desarmado."
L.c4_armed = "Você armou a bomba com sucesso."
L.c4_disarmed = "Você desarmou a bomba com sucesso."
L.c4_no_room = "Você não pode pegar este C4."

L.c4_desc = "Poderoso explosivo de contagem regressiva."

L.c4_arm = "Armar C4"
L.c4_arm_timer = "Temporizador"
L.c4_arm_seconds = "Segundos até a detonação:"
L.c4_arm_attempts = "Quando alguém tentar desarmar, {num} dos 6 fios causarão detonação instantânea quando cortados."

L.c4_remove_title = "Remoção"
L.c4_remove_pickup = "Pegar C4"
L.c4_remove_destroy1 = "Destruir C4"
L.c4_remove_destroy2 = "onfirmar: destruir"

L.c4_disarm = "Desarmar C4"
L.c4_disarm_cut = "Clique para cortar o fio {num}"

L.c4_disarm_t = "Corte um fio para desarmar a bomba. Como você é um Traidor, todos os fios são seguros. Para os Inocentes, porém, não é tão fácil assim!"
L.c4_disarm_owned = "Corte um fio para desarmar a bomba. É a sua bomba, então todos os fios a desarmarão."
L.c4_disarm_other = "Corte um fio seguro para desarmar a bomba. Vai explodir se você errar!"

L.c4_status_armed = "ARMADO"
L.c4_status_disarmed = "DESARMADO"

-- Visualizer
L.vis_name = "Visualizador"

L.vis_desc = [[
Permite visualizar uma cena de crime.

Analisa um cadáver para mostrar como a vítima morreu, mas somente se ela tiver morrido por ferimentos de armas de fogo.]]

-- Decoy
L.decoy_name = "Isca"
L.decoy_broken = "Sua Isca foi destruída!"

L.decoy_short_desc = "Está isca, mostrará um radar falso para o outro time."
L.decoy_pickup_wrong_team = "Você não pode pegar está isca, pertence ao time diferente!"

L.decoy_desc = [[
Mostra um sinal de radar falso para Detetives, e faz os scanners de DNA deles indicar a localização da sua Isca se eles procurarem a amostra do seu DNA.]]

-- Defuser
L.defuser_name = "Kit de Desarme"

L.defuser_desc = [[
Instantaneamente desarma um explosivo C4.

Usos ilimitados. Um C4 será mais fácil de ser notado se você estiver com isto equipado.]]

-- Flare gun
L.flare_name = "Pistola Sinalizadora"

L.flare_desc = [[
Pode ser usado para queimar cadáveres para que eles nunca sejam encontrados. Munição limitada.

Queimar um cadáver emite um som estranho.]]

-- Health station
L.hstation_name = "Estação de Cura"

L.hstation_broken = "Sua Estação de Cura foi destruída!"

L.hstation_desc = [[
Permite que as pessoas se curem quando posicionada.

Seu tempo de recarga é lento. Qualquer um pode usá-la, e ela pode ser danificada. Pode ser usada para analisar o DNA de seus utilizadores.]]

-- Knife
L.knife_name = "Faca"
L.knife_thrown = "Faca arremessada"

L.knife_desc = [[
Mata o alvo instantaneamente e de forma silenciosa, mas só pode ser usada uma vez.

Pode ser arremessada ao usar o botão de ataque alternativo.]]

-- Poltergeist
L.polter_desc = [[
Planta batedores em objetos para empurrar pessoas à sua volta de maneira violenta.

A energia causa dano em pessoas que estejam nas proximidades.]]

-- Radio
L.radio_broken = "Seu Rádio foi destruído!"

-- Silenced pistol
L.sipistol_name = "Pistola Silenciada"

L.sipistol_desc = [[
Pistola de baixo ruído, usa munição de pistola normal.

As vítimas não gritarão quando forem mortas.]]

-- Newton launcher
L.newton_name = "Lançador Newton"

L.newton_desc = [[
Empurra pessoas a partir de uma distância segura.

Sua munição é infinita, mas dispara lentamente.]]

-- Binoculars
L.binoc_name = "Binóculos"

L.binoc_desc = [[
Permite dar zoom em cadáveres para identificá-los a partir de uma longa distância.

Seus usos são ilimitados, porém o processo de identificação demora alguns segundos.]]

-- UMP
L.ump_desc = [[
SMG experimental que desorienta alvos.

Usa munição de SMG comum.]]

-- DNA scanner
L.dna_name = "Scanner de DNA"
L.dna_notfound = "Nenhuma amostra de DNA foi encontrada no cadáver."
L.dna_limit = "Limite de armazenamento atingido. Remova amostras antigas para adicionar novas."
L.dna_decayed = "A amostra do DNA do assassino se deteriorou."
L.dna_killer = "Você coletou a amostra do DNA do assassino provinda deste cadáver!"
L.dna_duplicate = "Você já tem esse DNA no seu Scanner."
L.dna_no_killer = "A amostra de DNA não pôde ser coletada (o assassino se desconectou?)."
L.dna_armed = "Esta bomba está ativa! Desarme-a primeiro!"
L.dna_object = "A mostra coletada para o dono deste objeto."
L.dna_gone = "Não há nenhuma amostra de DNA nesta área."

L.dna_desc = [[
Colete amostras de DNA de objetos e analise-as para saber quem os usou.

Utilize-o em terroristas recentemente mortos para coletar a amostra do DNA do assassino e assim poder rastreá-lo.]]

-- Magneto stick
L.magnet_name = "Magneto-stick"

-- Grenades and misc
L.grenade_smoke = "Granada de Fumaça"
L.grenade_fire = "Granada Incendiária"

L.unarmed_name = "Coldre"
L.crowbar_name = "Pé de Cabra"
L.pistol_name = "Pistola"
L.rifle_name = "Rifle"
L.shotgun_name = "Escopeta"

-- Teleporter
L.tele_name = "Teletransportador"
L.tele_failed = "O teletransporte falhou."
L.tele_marked = "Local de teletransporte marcado."

L.tele_no_ground = "Você não pode teletransportar-se se você não estiver em um chão sólido!"
L.tele_no_crouch = "Você não pode teletransportar-se enquanto estiver agachado!"
L.tele_no_mark = "Nenhum local marcado. Marque um local para teletransportar-se."

L.tele_no_mark_ground = "Você não pode marcar um local para teletransportar-se se você não estiver em um chão sólido!"
L.tele_no_mark_crouch = "Você não pode marcar um local para teletransportar-se enquanto estiver agachado!"

--L.tele_help_pri = "Teleports to marked location"
--L.tele_help_sec = "Marks current location"

L.tele_desc = [[
Teletransporta para um local previamente marcado.

Teletransportar-se faz barulho, e tem um número limitado de usos.]]

-- Ammo names, shown when picked up
L.ammo_pistol = "Munição de Pistola"

L.ammo_smg1 = "Munição de SMG"
L.ammo_buckshot = "Munição de Escopeta"
L.ammo_357 = "Munição de Rifle"
L.ammo_alyxgun = "Munição de Deagle"
L.ammo_ar2altfire = "Munição de Pistola Sinalizadora"
L.ammo_gravity = "Munição de Poltergeist"

-- Round status
L.round_wait = "Aguardando"
L.round_prep = "Preparando"
L.round_active = "Em progresso"
L.round_post = "Terminando"

-- Health, ammo and time area
L.overtime = "TEMPO EXTRA"
L.hastemode = "MODO PRESSA"

-- TargetID health status
L.hp_healthy = "Saudável"
L.hp_hurt = "Machucado"
L.hp_wounded = "Ferido"
L.hp_badwnd = "Muito Ferido"
L.hp_death = "Quase Morto"

-- TargetID Karma status
L.karma_max = "Respeitável"
L.karma_high = "Bruto"
L.karma_med = "Guerreiro"
L.karma_low = "Perigoso"
L.karma_min = "Irresponsável"

-- TargetID misc
L.corpse = "Cadáver"
--L.corpse_hint = "Press [{usekey}] to search and confirm. [{walkkey} + {usekey}] to search covertly."

L.target_disg = " (DISFARÇADO)"
L.target_unid = "Corpo não identificado"
L.target_unknown = "Um terrorista"

-- HUD buttons with hand icons that only some roles can see and use
L.tbut_single = "Uso único"
L.tbut_reuse = "Reutilizável"
L.tbut_retime = "Reutilizável após {num} seg"
L.tbut_help = "Pressione {usekey} para ativar"

-- Spectator muting of living/dead
L.mute_living = "Jogadores vivos emudecidos"
L.mute_specs = "Espectadores emudecidos"
L.mute_all = "Todos emudecidos"
L.mute_off = "Ninguém emudecido"

-- Spectators and prop possession
L.punch_title = "SOCÔMETRO"
L.punch_bonus = "Sua má pontuação diminuiu seu limite do socômetro em {num}"
L.punch_malus = "Sua boa pontuação aumentou seu limite do socômetro em {num}!"

-- Info popups shown when the round starts
L.info_popup_innocent = [[
Você é um Terrorista inocente! Mas há traidores à solta...
Em quem você pode confiar, e quem está por aí para lhe encher de balas?

Tenha cuidado e trabalhe em conjunto com seus camaradas para saírem vivos dessa!]]

L.info_popup_detective = [[
Você é um Detetive! O QG de Terroristas disponibilizou recursos especiais para encontrar os traidores.
Use-os para ajudar os inocentes a sobreviver, mas tenha cuidado:
os traidores podem querer que você bata as botas primeiro!

Pressione {menukey} para pegar seu equipamento!]]

L.info_popup_traitor_alone = [[
Você é um TRAIDOR! Você não tem aliados nesta rodada.

Mate todos os terroristas inocentes para vencer!

Pressione {menukey} para pegar seu equipamento especial!]]

L.info_popup_traitor = [[
Você é um TRAIDOR! Trabalhe com seus comparsas para aniquilar todos os terroristas inocentes.
Mas seja cauteloso, ou sua traição pode ser descoberta...

Estes são seus aliados:
{traitorlist}

Pressione {menukey} para pegar seu equipamento especial!]]

-- Various other text
L.name_kick = "Um jogador foi expulso automaticamente por ter alterado seu nome durante uma rodada."

L.idle_popup = [[
Você esteve inativo por {num} segundos e foi movido para o modo Somente-Espectador como resultado. Você não renascerá quando uma nova rodada começar.

Você pode alterná-lo a qualquer momento ao pressionar {helpkey} e desmarcar a opção correspondente na aba Configurações. Você pode optar por desabilitá-lo agora mesmo.]]

L.idle_popup_close = "Fazer nada"
L.idle_popup_off = "Desabilitar Somente-Espectador"

L.idle_warning = "Aviso: você aparenta estar ausente, e será movido para a equipe dos espectadores a não ser que demonstre alguma atividade!"

L.spec_mode_warning = "Você está no Modo Espectador e não renascerá quando uma nova rodada começar. Para desabilitar esse modo, pressione F1, clique na aba Configurações e desmarque a opção 'Modo Somente-Espectador'."

-- Tips panel
L.tips_panel_title = "Dicas"
L.tips_panel_tip = "Dica:"

-- Tip texts
L.tip1 = "Traidores podem investigar cadáveres furtivamente, sem confirmar a sua morte, ao segurar {walkkey} e pressionar {usekey} no cadáver."

L.tip2 = "Armar um explosivo C4 com um longo tempo de duração aumentará o número de fios que causarão sua detonação instantânea quando um inocente tentar desarmá-lo. Ele também emitirá um bipe mais suave e com menos frequência."

L.tip3 = "Detetives podem investigar cadáveres para descobrir quem estava 'refletindo em seus olhos'. Essa é a última pessoa que o terrorista morto viu. Isso não necessariamente indica quem é o assassino, pois o terrorista pode ter sido baleado pelas costas."

L.tip4 = "Ninguém saberá que você morreu até que encontrem seu cadáver e o investiguem."

L.tip5 = "Quando um Traidor mata um Detetive, todos os Traidores são instantaneamente recompensados com créditos."

L.tip6 = "Quando um Traidor morre, todos os Detetives são recompensados com créditos."

L.tip7 = "Quando os Traidores fizerem um progresso significativo matando inocentes, eles serão recompensados com créditos."

L.tip8 = "Traidores e Detetives podem coletar créditos não gastos dos cadáveres de outros Traidores e Detetives."

L.tip9 = "O Poltergeist pode tornar qualquer objeto de física em um projétil mortal. Cada empurrão é acompanhado de uma explosão de energia que fere todos que estiverem ao redor."

--L.tip10 = "As a shopping role, keep in mind you are rewarded extra equipment credits if you and your comrades perform well. Make sure you remember to spend them!"

L.tip11 = "O Scanner de DNA dos Detetives pode ser usado para coletar amostras de DNA de armas e itens e analisá-las para descobrir a localização do jogador que os usou. Isso é útil quando você consegue coletar uma amostra de um cadáver ou de um C4 desarmado!"

L.tip12 = "Quando estiver perto de alguém que você matou, um pouco do seu DNA será deixado no cadáver. Esse DNA pode ser coletado por um Scanner de DNA de um Detetive para encontrar sua localização atual. É melhor esconder o corpo da vítima depois de esfaqueá-la!"

L.tip13 = "Quanto mais longe você estiver de alguém que você matar, mais rapidamente a amostra do seu DNA no corpo da sua vítima vai deteriorar-se."

--L.tip14 = "Are you going sniping? Consider buying the Disguiser. If you miss a shot, run away to a safe spot, disable the Disguiser, and no one will know it was you who was shooting at them."

--L.tip15 = "If you have a Teleporter, it can help you escape when chased, and allows you to quickly travel across a big map. Make sure you always have a safe position marked."

L.tip16 = "Os inocentes estão todos agrupados sendo difíceis de serem mortos? Considere experimentar o Rádio para reproduzir sons de um C4 ou de um tiroteio para fazer com que eles se desagrupem."

--L.tip17 = "Using the Radio, you can play sounds by looking at its placement marker after the radio has been placed. Queue up multiple sounds by clicking multiple buttons in the order you want them."

L.tip18 = "Como Detetive, se você estiver com alguns créditos sobrando, você pode dar um Kit de Desarme para um Inocente confiável. Assim, você pode gastar seu tempo com um trabalho mais sério de investigação enquanto você deixa a missão arriscada de desarmamento para ele."

L.tip19 = "Os Binóculos dos Detetives permitem localizar e identificar cadáveres a distância. Más notícias se os Traidores estavam querendo usar um cadáver como isca. Mas é claro que, quando um Detetive estiver usando os Binóculos, ele estará desarmado e distraído..."

L.tip20 = "A Estação de Cura dos Detetives permite que jogadores feridos se curem. Mas é claro que, os jogadores feridos podem ser Traidores..."

L.tip21 = "A Estação de Cura armazena uma amostra do DNA de cada jogador que a utilizar. Os Detetives podem utilizar o Scanner de DNA na Estação de Cura para descobrir quem andou se curando."

L.tip22 = "Diferentemente de armas e do C4, o Rádio dos Traidores não contém uma amostra do DNA de quem o posicionou. Não se preocupe com Detetives encontrando o seu DNA e descobrindo a sua verdadeira identidade."

--L.tip23 = "Press {helpkey} to view a short tutorial or modify some TTT-specific settings."

L.tip24 = "Quando um Detetive investiga um corpo, o resultado é disponibilizado para todos no placar ao clicar no nome da pessoa morta."

L.tip25 = "No placar, um ícone de lupa próximo ao nome de alguém indica que você coletou informações sobre aquela pessoa. Se o ícone estiver brilhando, os dados da investigação são provindos de um Detetive e podem conter informações adicionais."

--L.tip26 = "Corpses with a magnifying glass below the nickname have been searched by a Detective and their results are available to all players via the scoreboard."

L.tip27 = "Espectadores podem pressionar {mutekey} para alternar entre emudecer outros espectadores ou jogadores vivos."

--L.tip28 = "You can switch to a different language at any time in the Settings menu by pressing {helpkey}."

L.tip29 = "Os atalhos do chat ou comandos do 'rádio' podem ser utilizados ao pressionar {zoomkey}."

L.tip30 = "O ataque alternativo do Pé de Cabra empurrará outros jogadores."

L.tip31 = "Atirar usando a retícula de ferro de uma arma aumentará levemente a sua precisão e diminuirá o seu recuo. Agachar-se não fará diferença."

L.tip32 = "Granadas de Fumaça são eficazes em ambientes fechados, especialmente para criar confusão em salas lotadas."

L.tip33 = "Como Traidor, lembre-se de que você pode deslocar corpos e escondê-los dos inocentes e dos Detetives."

L.tip34 = "No placar, clique no nome de um jogador vivo e então você poderá marcá-lo como 'suspeito' ou 'amigo', entre outras marcações. A marcação será exibida quando você estiver com a mira sobre o jogador marcado."

L.tip35 = "A maioria dos equipamentos especiais posicionáveis (como o C4 e o Rádio) podem ser presos nas paredes ao usar o botão de ataque alternativo."

L.tip36 = "Um explosivo C4 que explodir devido a uma falha no seu desarmamento causará uma explosão menor do que um explosivo C4 que explodir devido ao seu temporizador ter chegado a zero."

--L.tip37 = "If it says 'HASTE MODE' above the round timer, the round will at first be only a few minutes long, but with every death the available time increases. This mode puts the pressure on the traitors to keep things moving."

-- Round report
L.report_title = "Relatório da rodada"

-- Tabs
L.report_tab_hilite = "Destaques"
L.report_tab_hilite_tip = "Destaques da rodada"
L.report_tab_events = "Acontecimentos"
L.report_tab_events_tip = "Registro dos acontecimentos desta rodada"
L.report_tab_scores = "Pontuações"
L.report_tab_scores_tip = "Pontos marcados por cada jogador nesta rodada"

-- Event log saving
L.report_save = "Salvar Log .txt"
L.report_save_tip = "Salvar o Registro de Acontecimentos para um documento de texto"
L.report_save_error = "Não há nenhum Registro de Acontecimentos a ser salvo."
L.report_save_result = "O Registro de Acontecimentos foi salvo em:"

-- Columns
L.col_time = "Tempo"
L.col_event = "Acontecimento"
L.col_player = "Jogador"
--L.col_roles = "Role(s)"
--L.col_teams = "Team(s)"
L.col_kills1 = "Inocentes mortos"
L.col_kills2 = "Traidores mortos"
L.col_points = "Pontos"
L.col_team = "Bônus de equipe"
L.col_total = "Total de pontos"

-- Awards/highlights
L.aw_sui1_title = "LÍDER DA SEITA SUICIDA"
L.aw_sui1_text = "mostrou aos outros suicidas como as coisas funcionam sendo o primeiro a partir."

L.aw_sui2_title = "SOZINHO E DEPRESSIVO"
L.aw_sui2_text = "foi o único que se matou."

L.aw_exp1_title = "BOLSA PARA PESQUISA DE EXPLOSIVOS"
L.aw_exp1_text = "foi reconhecido por sua pesquisa com explosivos. {num} cobaias o ajudaram."

L.aw_exp2_title = "PESQUISA DE CAMPO"
L.aw_exp2_text = "testou sua própria resistência a explosões. Não era alta o suficiente."

L.aw_fst1_title = "FIRST BLOOD"
L.aw_fst1_text = "entregou a primeira morte de um inocente nas mãos de um traidor."

L.aw_fst2_title = "FIRST BLOOD REVERSO"
L.aw_fst2_text = "marcou a primeira morte matando um traidor aliado. Bom trabalho."

L.aw_fst3_title = "ATAQUE DE PÂNICO"
L.aw_fst3_text = "foi o primeiro a matar. Pena que era um camarada inocente."

L.aw_fst4_title = "TIRO CERTO"
L.aw_fst4_text = "foi o inocente que marcou a primeira morte matando um traidor."

L.aw_all1_title = "MAIS MORTAL ENTRE IGUAIS"
L.aw_all1_text = "foi responsável por cada morte causada pelos inocentes nesta rodada."

L.aw_all2_title = "LOBO SOLITÁRIO"
L.aw_all2_text = "foi responsável por cada morte causada pelos traidores nesta rodada."

L.aw_nkt1_title = "EU PEGUEI UM, CHEFE!"
L.aw_nkt1_text = "conseguiu matar apenas um inocente. Congratulações!"

L.aw_nkt2_title = "UMA BALA PARA DOIS"
L.aw_nkt2_text = "mostrou que a primeira vítima não foi alva de um tiro de sorte ao matar outra vítima com a mesma bala."

L.aw_nkt3_title = "TRAIDOR EM SÉRIE"
L.aw_nkt3_text = "acabou com três vidas inocentes de terrorismo hoje."

L.aw_nkt4_title = "O LOBO ENTRE LOBOS QUE MAIS PARECEM OVELHAS"
L.aw_nkt4_text = "comeu terroristas inocentes no jantar. Um jantar de {num} pratos."

L.aw_nkt5_title = "OPERAÇÃO CONTRA-TERRORISTA"
L.aw_nkt5_text = "é pago por cada assassinato. Agora já pode comprar outro iate luxuoso."

L.aw_nki1_title = "TRAIA ISTO"
L.aw_nki1_text = "achou um traidor. Atirou num traidor. Fácil."

L.aw_nki2_title = "JAPONÊS DA FEDERAL"
L.aw_nki2_text = "escoltou dois traidores para o além."

L.aw_nki3_title = "TRAIDORES CONTAM CARNEIRINHOS?"
L.aw_nki3_text = "colocou três traidores para dormir."

L.aw_nki4_title = "FUNCIONÁRIO DE ASSUNTOS INTERNOS"
L.aw_nki4_text = "é pago por cada assassinato. Agora já pode encomendar sua quinta piscina olímpica."

L.aw_fal1_title = "NÃO, SR. BOND, ESPERO QUE VOCÊ CAIA"
L.aw_fal1_text = "empurrou alguém de um lugar alto."

L.aw_fal2_title = "PAVIMENTADO"
L.aw_fal2_text = "deixou seu corpo bater no chão depois de cair de uma altura significativa."

L.aw_fal3_title = "O METEORITO HUMANO"
L.aw_fal3_text = "esmagou alguém caindo sobre este de uma grande altura."

L.aw_hed1_title = "EFICIÊNCIA"
L.aw_hed1_text = "descobriu a alegria dos tiros na cabeça e atirou em {num} cabeças."

L.aw_hed2_title = "NEUROLOGIA"
L.aw_hed2_text = "removeu o cérebro de {num} cabeças para um exame minucioso."

L.aw_hed3_title = "A CULPA É DOS VIDEOGAMES"
L.aw_hed3_text = "aplicou seu treinamento de simulação de assassinato e atirou em {num} cabeças de inimigos."

L.aw_cbr1_title = "THUNK THUNK THUNK"
L.aw_cbr1_text = "descobriu que esse é o barulho que o Pé de Cabra faz ao matar, como {num} vítimas também descobriram."

L.aw_cbr2_title = "FREEMAN"
L.aw_cbr2_text = "cobriu seu Pé de Cabra com nada menos do que {num} cérebros."

L.aw_pst1_title = "PEQUENO INSETO PERSISTENTE"
L.aw_pst1_text = "marcou {num} mortes usando uma pistola. Logo após, ele abraçou alguém até a morte."

L.aw_pst2_title = "CHACINA DE PEQUENO CALIBRE"
L.aw_pst2_text = "matou um pequeno exército de {num} com uma pistola. Provavelmente instalou uma pequena escopeta dentro do cano."

L.aw_sgn1_title = "MODO FÁCIL"
L.aw_sgn1_text = "aplicou tiro onde dói, conseguindo matar {num} alvos."

L.aw_sgn2_title = "MILHARES DE BALAS PEQUENAS"
L.aw_sgn2_text = "não gostou muito do chumbo grosso, e decidiu doá-lo. {num} destinatários não viveram para aproveitá-lo."

L.aw_rfl1_title = "APONTAR E CLICAR"
L.aw_rfl1_text = "mostrou que tudo que você precisa para cometer {num} assassinatos é um rifle e uma mão firme."

L.aw_rfl2_title = "EU POSSO VER SUA CABEÇA DAQUI"
L.aw_rfl2_text = "conhece o rifle que tem. Agora {num} pessoas conhecem o seu rifle também."

L.aw_dgl1_title = "É COMO UM PEQUENO RIFLE"
L.aw_dgl1_text = "está pegando o jeito de jogar com a Desert Eagle, conseguindo matar {num} pessoas."

L.aw_dgl2_title = "MESTRE DA DESERT EAGLE"
L.aw_dgl2_text = "surpreendeu {num} pessoas com sua Desert Eagle."

L.aw_mac1_title = "REZAR E MATAR"
L.aw_mac1_text = "matou {num} pessoas com a MAC10, mas não dirá quanta munição precisou."

L.aw_mac2_title = "MAC COM QUEIJO"
L.aw_mac2_text = "imagina o que aconteceria se ele estivesse com duas MAC10 em suas mãos. {num} vezes dois?"

L.aw_sip1_title = "FIQUE QUIETO"
L.aw_sip1_text = "calou a boca de {num} pessoas com sua pistola silenciada."

L.aw_sip2_title = "ASSASSINO SILENCIOSO"
L.aw_sip2_text = "matou {num} pessoas que não ouviram sua própria morte."

L.aw_knf1_title = "ESFAQUEAR-LHE-EI"
L.aw_knf1_text = "esfaqueou a cara de alguém pela internet."

L.aw_knf2_title = "ONDE VOCÊ CONSEGUIU ISSO?"
L.aw_knf2_text = "não era um Traidor, e mesmo assim matou alguém com uma faca."

L.aw_knf3_title = "O TAL ESFAQUEADOR"
L.aw_knf3_text = "encontrou {num} facas espalhadas, e fez bom uso delas."

L.aw_knf4_title = "O MELHOR ESFAQUEADOR DO MUNDO"
L.aw_knf4_text = "matou {num} pessoas com uma faca. Não me pergunte como."

L.aw_flg1_title = "AO RESGATE"
L.aw_flg1_text = "usou seu sinalizador para sinalizar {num} mortes."

L.aw_flg2_title = "SINALIZADOR INDICA FOGO"
L.aw_flg2_text = "ensinou a {num} homens sobre o perigo de vestir roupas inflamáveis."

L.aw_hug1_title = "UMA H.U.G.E SINTONIZADA"
L.aw_hug1_text = "estava em sintonia com sua H.U.G.E, fazendo com que suas balas atingissem {num} pessoas."

L.aw_hug2_title = "ESQUIZOFRENIA BALÍSTICA"
L.aw_hug2_text = "só ficou atirando, e viu sua H.U.G.E ser recompensada com {num} mortes."

L.aw_msx1_title = "PUTT PUTT PUTT"
L.aw_msx1_text = "levou {num} pessoas com o M16."

L.aw_msx2_title = "LOUCURA DE ALCANCE MÉDIO"
L.aw_msx2_text = "sabe derrubar pessoas com o M16, conseguindo marcar {num} mortes."

L.aw_tkl1_title = "FOI SEM QUERER"
L.aw_tkl1_text = "pressionou o gatilho enquanto mirava em um aliado."

L.aw_tkl2_title = "FOI SEM QUERER QUERENDO"
L.aw_tkl2_text = "pensou que havia matado dois Traidores, mas estava errado sobre ambos."

L.aw_tkl3_title = "KARMA-A-ARMA-AÊ"
L.aw_tkl3_text = "não conseguiu parar depois de matar dois aliados. Três é seu número da sorte."

L.aw_tkl4_title = "OS MEUS ALIADOS SÃO MEUS INIMIGOS"
L.aw_tkl4_text = "matou toda a sua equipe. PIMBA!"

L.aw_tkl5_title = "FUNÇÕES DIFERENTES"
L.aw_tkl5_text = "estava interpretando um louco honesto. E é por isso que ele matou quase toda a sua equipe."

L.aw_tkl6_title = "ANTA"
L.aw_tkl6_text = "não conseguiu descobrir em que equipe estava, e matou mais da metade de seus aliados."

L.aw_tkl7_title = "PEÃO"
L.aw_tkl7_text = "protegeu seu território de maneira fantástica ao matar mais de um quarto de seus aliados."

L.aw_brn1_title = "COMO A VOVÓ FAZIA"
L.aw_brn1_text = "fritou várias pessoas para fazer uma batata frita agradável."

L.aw_brn2_title = "PIROMANÍACO"
L.aw_brn2_text = "foi ouvido gargalhando alto depois de queimar uma de suas muitas vítimas."

L.aw_brn3_title = "PIROMANÍACO GRANADEIRO"
L.aw_brn3_text = "queimou todos, mas agora está sem granadas incendiárias! Como ele vai lidar com isso!?"

L.aw_fnd1_title = "MÉDICO LEGISTA"
L.aw_fnd1_text = "encontrou {num} cadáveres por aí."

L.aw_fnd2_title = "TEMOS QUE PEGAR TODOS ELES"
L.aw_fnd2_text = "encontrou {num} cadáveres para a sua coleção."

L.aw_fnd3_title = "CHEIRO DE MORTE"
L.aw_fnd3_text = "continua tropeçando em cadáveres, conseguindo tropeçar {num} vezes nesta rodada."

L.aw_crd1_title = "RECICLADOR"
L.aw_crd1_text = "coletou {num} créditos perdidos em cadáveres."

L.aw_tod1_title = "UMA-QUASE-VITÓRIA"
L.aw_tod1_text = "morreu segundos antes de sua equipe vencer a partida."

L.aw_tod2_title = "EU ODEIO ESTE JOGO"
L.aw_tod2_text = "morreu logo após o início da rodada."

-- New and modified pieces of text are placed below this point, marked with the
-- version in which they were added, to make updating translations easier.

-- v24
L.drop_no_ammo = "Munição insuficiente no clipe da sua arma para largar como uma caixa de munição."

-- 2015-05-25
L.hat_retrieve = "Você pegou o chapéu de um Detetive."

-- 2017-09-03
L.sb_sortby = "Classificar por:"

-- 2018-07-24
L.equip_tooltip_main = "Menu de Equipamentos"
L.equip_tooltip_radar = "Controle do Radar"
L.equip_tooltip_disguise = "Controle do Disfarce"
L.equip_tooltip_radio = "Controle do Rádio"
L.equip_tooltip_xfer = "Transferir créditos"
--L.equip_tooltip_reroll = "Reroll equipment"

L.confgrenade_name = "Granada de Impulso"
L.polter_name = "Poltergeist"
L.stungun_name = "Protótipo UMP"

L.knife_instant = "MORTE INSTANTÂNEA"

L.binoc_zoom_level = "NÍVEL"
L.binoc_body = "CORPO DETECTADO"

L.idle_popup_title = "Ausência"

-- 2019-01-31
L.create_own_shop = "Criar sua própria loja"
L.shop_link = "Linkar com"
L.shop_disabled = "Desativar loja"
L.shop_default = "Usar loja padrão"

-- 2019-05-05
L.reroll_name = "Rolar"
--L.reroll_menutitle = "Reroll equipment"
L.reroll_no_credits = "Você precisa de {amount} crédito(s) para rolar!"
L.reroll_button = "Rolar"
--L.reroll_help = "Use {amount} credits to get a new random set of equipment in your shop!"

-- 2019-05-06
L.equip_not_alive = "Você consegue ver todos os items disponíveis selecionando pelo papel na direita. Não esqueça de marcar os eu favorito!"

-- 2019-06-27
L.shop_editor_title = "Editor de loja"
L.shop_edit_items_weapong = "Editar Items / Armas"
L.shop_edit = "Editar Loja"
L.shop_settings = "Configurações"
L.shop_select_role = "Selecionar papel"
L.shop_edit_items = "Editar items"
L.shop_edit_shop = "Editar Loja"
L.shop_create_shop = "Criar loja customizada"
L.shop_selected = "Selecionar {role}"
L.shop_settings_desc = "Mude o valor para se adaptar a randomização da ConVars da Loja. Não esqueça de salvar suas mudanças!"

L.bindings_new = "Nova chave vinculada para {name}: {key}"

L.hud_default_failed = "Falha ao setar a nova HUD {hudname} como padrão. Você não tem permissão para fazer isso, ou essa HUD não existe."
L.hud_forced_failed = "Falha ao forçar a HUD {hudname}. Você não tem permissão para fazer isso, ou a HUD não existe.."
L.hud_restricted_failed = "Falha ao restringir a HUD {hudname}. Você não tem permissão para isso.."

L.shop_role_select = "Selecione o papel"
L.shop_role_selected = "Loja de {role} foi selecionada!"
L.shop_search = "Procurar"

-- 2019-10-19
L.drop_ammo_prevented = "Alguma coisa fez você soltar sua munição.."

-- 2019-10-28
L.target_c4 = "Pressione [{usekey}] para abrir o menu da C4"
L.target_c4_armed = "Pressione [{usekey}] para desarmar a C4"
L.target_c4_armed_defuser = "Pressione [{primaryfire}] para usar o desarme"
L.target_c4_not_disarmable = "Você não pode desarmar uma C4 de um companheiro ainda vivo"
L.c4_short_desc = "Alguma coisa muito explosivo"

L.target_pickup = "Pressione [{usekey}] para pegar"
L.target_slot_info = "Slot: {slot}"
L.target_pickup_weapon = "Pressione [{usekey}] para pegar a arma"
L.target_switch_weapon = "Pressione [{usekey}] para trocar com a sua arma no momento"
L.target_pickup_weapon_hidden = ", pressione [{walkkey} + {usekey}] para esconder a arma"
L.target_switch_weapon_hidden = ", pressione [{walkkey} + {usekey}] para esconder"
L.target_switch_weapon_nospace = "Não há slot de inventário para esta arma"
L.target_switch_drop_weapon_info = "Dropar {name} do slot {slot}"
L.target_switch_drop_weapon_info_noslot = "Não há uma arma dropavel no slot {slot}"

--L.corpse_searched_by_detective = "This corpse was searched by a public policing role"
L.corpse_too_far_away = "Este corpo está muito longe."

L.radio_short_desc = "Tiros de arma são músicas para meus ouvidos"

L.hstation_subtitle = "Pressione [{usekey}] para receber vida."
L.hstation_charge = "Carga na Estação de Cura restantes:: {charge}"
L.hstation_empty = "Não há mais cargas na Estação de Cura restantes"
L.hstation_maxhealth = "Sua vida está cheia"
L.hstation_short_desc = "A Estação de Cura recarrega lentamente"

-- 2019-11-03
L.vis_short_desc = "Visualize a cena do crime se a vítima teve ferimentos de bala"
L.corpse_binoculars = "Pressione [{key}] para encontrar corpos com o binóculos."
L.binoc_progress = "Progresso: {progress}%"

L.pickup_no_room = "Você não tem espaço no inventário para esse tipo de arma."
L.pickup_fail = "Você não pode pegar esta arma."
L.pickup_pending = "Você já pegou uma arma, espere alguns segundos."

-- 2020-01-07
L.tbut_help_admin = "Configurar botão de traidor"
L.tbut_role_toggle = "[{walkkey} + {usekey}] para ocultar este botão para {role}"
L.tbut_role_config = "Papel: {current}"
L.tbut_team_toggle = "[SHIFT + {walkkey} + {usekey}] para ocultar o botão do {team}"
L.tbut_team_config = "Time: {current}"
L.tbut_current_config = "Configuração padrão:"
L.tbut_intended_config = "Configuração padrão do padrão do criador do mapa:"
L.tbut_admin_mode_only = "Você pode ver esse botão por você é um admin e '{cv}' está setado para '1'."
L.tbut_allow = "Permitir"
L.tbut_prohib = "Proibir"
L.tbut_default = "Padrão"

-- 2020-02-09
L.name_door = "Porta"
L.door_open = "Pressione [{usekey}] para abrir a porta."
L.door_close = "Pressione [{usekey}] para fechar a porta."
L.door_locked = "Esta porta esta trancada."

-- 2020-02-11
L.automoved_to_spec = "(MENSAGEM AUTOMATICA) Eu fui movimentado para o Espetador porque eu estava Parado/AFK."
L.mute_team = "{team} mutado."

-- 2020-02-16
L.door_auto_closes = "Esta porta fecha automaticamente.."
L.door_open_touch = "Ande até a porta para abrir."
L.door_open_touch_and_use = "Ande até a porta ou pressione [{usekey}] para abrir."

-- 2020-03-09
L.help_title = "Ajuda e Configurações"

L.menu_changelog_title = "Changelog"
L.menu_guide_title = "TTT2 Guia"
L.menu_bindings_title = "Binds"
L.menu_language_title = "Linguagem"
L.menu_appearance_title = "Aparência"
L.menu_gameplay_title = "Gameplay"
L.menu_addons_title = "Addons"
L.menu_legacy_title = "Legacy Addons"
L.menu_administration_title = "Administração"
L.menu_equipment_title = "Editar Equipamentos"
L.menu_shops_title = "Editar Loja"

L.menu_changelog_description = "Uma lista de mudanças da última atualização."
L.menu_guide_description = "Ajuda você a começar no TTT2 explicando sobre o gameplay, funções e outras coisas."
L.menu_bindings_description = "Binds especificas do TTT2 para fazer você virar pro."
L.menu_language_description = "Selecione a linguagem do modo."
L.menu_appearance_description = "Aparencias personalizadas do TTT2."
--L.menu_gameplay_description = "Tweak voice and sound volume, accessibility settings, and gameplay settings."
L.menu_addons_description = "Configure addons locais do seu jeito."
L.menu_legacy_description = "Um painel com guias convertidas do TTT original que deve ser portado para o novo sistema."
L.menu_administration_description = "Configurações gerais para Huds, lojas e etc."
L.menu_equipment_description = "Setar créditos, limitações, disponibilidade e outras coisas."
L.menu_shops_description = "Add/Remover loja para funções e configurações de equipamentos que tem."

L.submenu_guide_gameplay_title = "Gameplay"
L.submenu_guide_roles_title = "Funções"
L.submenu_guide_equipment_title = "Equipamento"

L.submenu_bindings_bindings_title = "Bindings"

L.submenu_language_language_title = "Linguagem"

L.submenu_appearance_general_title = "Geral"
L.submenu_appearance_hudswitcher_title = "HUD"
L.submenu_appearance_vskin_title = "VSkin"
L.submenu_appearance_targetid_title = "Alvo"
L.submenu_appearance_shop_title = "Loja"
L.submenu_appearance_crosshair_title = "Mira"
L.submenu_appearance_dmgindicator_title = "Indicador de Dano"
L.submenu_appearance_performance_title = "Desempenho"
L.submenu_appearance_interface_title = "Interface"

L.submenu_gameplay_general_title = "Geral"

L.submenu_administration_hud_title = "Configurações da HUD"
L.submenu_administration_randomshop_title = "Loja Aleatória"

L.help_color_desc = "Se esta opção estiver ativada, você poderá escolher a cor global que será usada para a linha em volta do alvo ou na mira."
L.help_scale_factor = "Essa escala influenciara em todo a UI (HUD, VGUI e alvo). Automaticamente atualiza se o resolução de tela mudar. Mudar este valor resetará a HUD!"
L.help_hud_game_reload = "A HUD não está disponível no momento. Reconecte no servidor ou reinicie o jogo."
L.help_hud_special_settings = "Há configurações especificas para esta HUD."
L.help_vskin_info = "VSkin (VGUI Skin) esta skin é aplicada a todos os elementos de menu. Pode ser facilmente criado com Lua e pode ser mudado os parametros de tamanho e colores."
L.help_targetid_info = "Informação do alvo aparecem na mira. Cor e tamanho podem ser mudado na configuração 'Geral'."
L.help_hud_default_desc = "Setar HUD padrão para todos os jogadores. Jogadores que não tiveram suas HUDs mudadas serão colocados como padrão. Esta alteração não mudara a HUD dos jogadores que alteraram suas HUDs."
L.help_hud_forced_desc = "Forçar a HUD para todos os jogadores. Essa função desativa a seleção de HUD para todos."
L.help_hud_enabled_desc = "Ativar/Desativar restrição de HUD."
L.help_damage_indicator_desc = "A indicação de dano mostra na sobreposição do jogador. Para adicionar um novo tema, coloque um png em 'materials/vgui/ttt/damageindicator/themes/'."
L.help_shop_key_desc = "Abrir a loja durante o preparamento ou no final da rodada?"

L.label_menu_menu = "MENU"
L.label_menu_admin_spacer = "Área administrativa (não mostrada para usuários comuns)"
L.label_language_set = "Selecionar linguagem"
L.label_global_color_enable = "Ativar cor global"
L.label_global_color = "Cor Global"
L.label_global_scale_factor = "Escala Global"
L.label_hud_select = "Selecionar HUD"
L.label_vskin_select = "Selecionar VSkin"
L.label_blur_enable = "Ativar borrão da VSkin"
L.label_color_enable = "Ativar cor de fundo da VSkin"
L.label_minimal_targetid = "ID do alvo abaixo da mira minimalista (sem texto de karma, dano e etc.)"
L.label_shop_always_show = "Sempre mostrar a loja"
L.label_shop_double_click_buy = "Ativar a compra de item apertando duas vezes no item"
L.label_shop_num_col = "Número de colunas"
L.label_shop_num_row = "Número de linhas"
L.label_shop_item_size = "Tamanho do icone"
L.label_shop_show_slot = "Mostrar marcação de slot"
L.label_shop_show_custom = "Mostrar marca de item customizado"
L.label_shop_show_fav = "Mostar marcação de itens favoritos"
L.label_crosshair_enable = "Ativar mira"
L.label_crosshair_opacity = "Opacidade da mira"
L.label_crosshair_ironsight_opacity = "Opacidade da mira de ferro"
L.label_crosshair_size = "Tamanho da mira"
L.label_crosshair_thickness = "Espessura da mira"
L.label_crosshair_thickness_outline = "Contorno da espessura da mira"
--L.label_crosshair_scale_enable = "Enable dynamic crosshair scale"
L.label_crosshair_ironsight_low_enabled = "Mira de ferro para armas fracas"
L.label_damage_indicator_enable = "Ativar indicador de dano"
L.label_damage_indicator_mode = "Selecione o tema do indicador de dano"
L.label_damage_indicator_duration = "Desaparecimento depois de tomar dano (em segundos)"
L.label_damage_indicator_maxdamage = "Dano necessário para máximo opacidade"
L.label_damage_indicator_maxalpha = "Máximo opacidade"
L.label_performance_halo_enable = "Desenhar um contorno em volta a entidade quando olhar para ela"
L.label_performance_spec_outline_enable = "Ativar contorno de controle de objetos"
L.label_performance_ohicon_enable = "Ativar icone de funções acima da cabeça dos jogadores"
L.label_interface_popup = "Mostrar popup da duração de rodada"
L.label_interface_fastsw_menu = "Ativar menu de troca de arma rápida"
L.label_inferface_wswitch_hide_enable = "Ativar auto-fechamento de troca de arma rápida"
L.label_inferface_scues_enable = "Ativar som quando acabar/iniciar uma rodada"
L.label_gameplay_specmode = "Ativar modo espectador (ficar sempre em modo espectador)"
L.label_gameplay_fastsw = "Troca de arma rápida"
L.label_gameplay_hold_aim = "Ativar segurar para mirar"
L.label_gameplay_mute = "Mutar jogadores vivos quando morrer"
L.label_hud_default = "HUD Padrão"
L.label_hud_force = "HUD Forçada"

L.label_bind_voice = "Microfone Global"
L.label_bind_voice_team = "Microfone do Time"

L.label_hud_basecolor = "Cor Base"

L.label_menu_not_populated = "Este submenu ainda não tem conteúdo."

L.header_bindings_ttt2 = "TTT2 Binds"
L.header_bindings_other = "Outras Binds"
L.header_language = "Configuração de Linguagem"
L.header_global_color = "Selecionar Cor Global"
L.header_hud_select = "Selecionar uma HUD"
L.header_hud_customize = "Customizar a HUD"
L.header_vskin_select = "Selecionar e Custoamizar a VSkin"
L.header_targetid = "Configuração do alvo"
L.header_shop_settings = "Configuração da Loja"
L.header_shop_layout = "Estilo da lista de itens"
L.header_shop_marker = "Item Marker Settings"
L.header_crosshair_settings = "Configuração da mira"
L.header_damage_indicator = "Configuração do indicador de dano"
L.header_performance_settings = "Configuração de Performance"
L.header_interface_settings = "Configuração da Interface"
L.header_gameplay_settings = "Configuração do Gameplay"
L.header_hud_administration = "Selecionar HUD padrão e forçada"
L.header_hud_enabled = "Ativar/Desativar HUD"

L.button_menu_back = "Voltar"
L.button_none = "Nenhum"
L.button_press_key = "Pressione o botão"
L.button_save = "Salvar"
L.button_reset = "Resetar"
L.button_close = "Fechar"
L.button_hud_editor = "Editor de HUD"

-- 2020-04-20
L.item_speedrun = "Speedrun"
L.item_speedrun_desc = [[Faz você ficar 50% mais rápido!]]
L.item_no_explosion_damage = "Sem dano de Explosivos"
L.item_no_explosion_damage_desc = [[Faz você ficar imune a dano de explosivos.]]
L.item_no_fall_damage = "Sem dano de queda"
L.item_no_fall_damage_desc = [[Faz você ficar imune a danos de queda.]]
L.item_no_fire_damage = "Sem dano de fogo"
L.item_no_fire_damage_desc = [[Faz você ficar imune a dano de fogo.]]
L.item_no_hazard_damage = "Sem dano de perigo"
L.item_no_hazard_damage_desc = [[Faz você ficar imune a dano de venenos, radiação e acído.]]
L.item_no_energy_damage = "Sem dano de energia"
L.item_no_energy_damage_desc = [[Faz você ficar imune a dano de energia como lasers, plasma e luzes.]]
L.item_no_prop_damage = "Sem dano de objetos"
L.item_no_prop_damage_desc = [[Faz você ficar imune a dano de objetos.]]
L.item_no_drown_damage = "Sem dano de afogamento"
L.item_no_drown_damage_desc = [[Faz você ficar imune a dano de afogamento.]]

-- 2020-04-21
L.dna_tid_possible = "Possível escannear."
L.dna_tid_impossible = "Não é possível escannear."
L.dna_screen_ready = "Sem DNA"
L.dna_screen_match = "Combina"

-- 2020-04-30
L.message_revival_canceled = "Reavivamento cancelado."
L.message_revival_failed = "Falha ao reviver."
L.message_revival_failed_missing_body = "Você não renascerá porque o seu corpo não existe mais.."
L.hud_revival_title = "Tempo restante antes de reviver:"
L.hud_revival_time = "{time}s"

-- 2020-05-03
L.door_destructible = "Está porta é destrutível ({health}HP)."

-- 2020-05-28
--L.corpse_hint_inspect_limited = "Press [{usekey}] to search. [{walkkey} + {usekey}] to only view search UI."

-- 2020-06-04
L.label_bind_disguiser = "Alternar disfarce"

-- 2020-06-24
L.dna_help_primary = "Coletar uma amostra DNA"
L.dna_help_secondary = "Trocar slot do DNA"
L.dna_help_reload = "Deletar amostra"

L.binoc_help_pri = "Procurar um corpo."
L.binoc_help_sec = "Alterar o zoom."

L.vis_help_pri = "Largar o dispositivo ativo."

-- 2020-08-07
L.pickup_error_spec = "Você não pode pegar isto como espectaor."
L.pickup_error_owns = "Você não pode pegar, pois você já tem esta arma."
L.pickup_error_noslot = "Você não pode pegar, pois você não tem slot disponível."

-- 2020-11-02
L.lang_server_default = "Padrão do servidor"
L.help_lang_info = [[
Esta tradução está {coverage}% completa com a linguagem padrão em inglês.

Por favor, leve em mente que a tradução é feita pela comunidade. Sinta-se livre para contribuir caso houver erros ou palavras incorretas.]]

-- 2021-04-13
L.title_score_info = "Informação do final da Rodada"
L.title_score_events = "Evento"

--L.label_bind_clscore = "Open round report"
L.title_player_score = "{player}'s score:"

L.label_show_events = "Mostrar evento de"
L.button_show_events_you = "Você"
L.button_show_events_global = "Global"
L.label_show_roles = "Mostrar distribuição de papéis de"
L.button_show_roles_begin = "Inicio da rodada"
L.button_show_roles_end = "Témino da rodada"

L.hilite_win_traitors = "TIME TRAIDORES VENCERAM"
L.hilite_win_innocents = "TIME INOCENTES VENCERAM"
L.hilite_win_tie = "É UM EMPATE"
L.hilite_win_time = "TEMPO ACABOU"

--L.tooltip_karma_gained = "Karma changes for this round:"
--L.tooltip_score_gained = "Score changes for this round:"
--L.tooltip_roles_time = "Role changes for this round:"

--L.tooltip_finish_score_win = "Win: {score}"
L.tooltip_finish_score_alive_teammates = "Companheiros vivos: {score}"
L.tooltip_finish_score_alive_all = "Jogadores vivos: {score}"
L.tooltip_finish_score_timelimit = "Tempo acabou: {score}"
L.tooltip_finish_score_dead_enemies = "Inimigos mortos: {score}"
L.tooltip_kill_score = "Mortes: {score}"
--L.tooltip_bodyfound_score = "Body found: {score}"

--L.finish_score_win = "Win:"
L.finish_score_alive_teammates = "Companheiros vivos:"
L.finish_score_alive_all = "Jogadores vivos:"
L.finish_score_timelimit = "Tempo acabou:"
L.finish_score_dead_enemies = "Inimigos mortos:"
L.kill_score = "Mortes:"
L.bodyfound_score = "Corpos encontrados:"

L.title_event_bodyfound = "Um corpo foi encontrado"
--L.title_event_c4_disarm = "A C4 was disarmed"
--L.title_event_c4_explode = "A C4 exploded"
--L.title_event_c4_plant = "A C4 was armed"
L.title_event_creditfound = "Créditos que foram encontrados"
L.title_event_finish = "A rodada terminou"
L.title_event_game = "Uma nova rodada foi iniciada"
L.title_event_kill = "Um jogador foi morto"
L.title_event_respawn = "Um jogador respawnou"
L.title_event_rolechange = "Um jogador mudou de papél ou de time"
--L.title_event_selected = "The roles were distributed"
L.title_event_spawn = "Um jogador spawnou"

L.desc_event_bodyfound = "{finder} ({firole} / {fiteam}) encontrou o corpo de {found} ({forole} / {foteam}). O corpo tinha {credits} credito(s)."
--L.desc_event_bodyfound_headshot = "The victim was killed by a headshot."
--L.desc_event_c4_disarm_success = "{disarmer} ({drole} / {dteam}) successfully disarmed the C4 armed by {owner} ({orole} / {oteam})."
--L.desc_event_c4_disarm_failed = "{disarmer} ({drole} / {dteam}) tried to disarm the C4 armed by {owner} ({orole} / {oteam}). They failed."
--L.desc_event_c4_explode = "The C4 armed by {owner} ({role} / {team}) exploded."
--L.desc_event_c4_plant = "{owner} ({role} / {team}) armed an explosive C4."
L.desc_event_creditfound = "{finder} ({firole} / {fiteam}) encontrou {credits} credito(s) no corpo de {found} ({forole} / {foteam})."
L.desc_event_finish = "O round durou {minutes}:{seconds}. Havia {alive} jogadore(s) vivos no final."
L.desc_event_game = "Um novo round começou."
L.desc_event_respawn = "{player} foi respawnado."
L.desc_event_rolechange = "{player} mudou seu função para {orole} ({oteam}) para {nrole} ({nteam})."
--L.desc_event_selected = "The teams and roles were distributed for all {amount} player(s)."
L.desc_event_spawn = "{player} spawnou."

-- Name of a trap that killed us that has not been named by the mapper
L.trap_something = "alguma coisa"

-- Kill events
L.desc_event_kill_suicide = "Foi um suicídio."
L.desc_event_kill_team = "Foi uma team kill."

L.desc_event_kill_blowup = "{victim} ({vrole} / {vteam}) se explodiu."
L.desc_event_kill_blowup_trap = "{victim} ({vrole} / {vteam}) foi explodido por {trap}."

L.desc_event_kill_tele_self = "{victim} ({vrole} / {vteam}) se matou com um teletransporte."
L.desc_event_kill_sui = "{victim} ({vrole} / {vteam}) não aguentou a pressão e se matou."
L.desc_event_kill_sui_using = "{victim} ({vrole} / {vteam}) se matou usando {tool}."

L.desc_event_kill_fall = "{victim} ({vrole} / {vteam}) caiu para sua morte."
L.desc_event_kill_fall_pushed = "{victim} ({vrole} / {vteam}) caiu para sua morte depois que {attacker} o empurrou."
L.desc_event_kill_fall_pushed_using = "{victim} ({vrole} / {vteam}) caiu para sua morte depos que {attacker} ({arole} / {ateam}) usou {trap} para empurrá-lo."

L.desc_event_kill_shot = "{victim} ({vrole} / {vteam}) foi baleado por {attacker}."
L.desc_event_kill_shot_using = "{victim} ({vrole} / {vteam}) foi baleado por {attacker} ({arole} / {ateam}) usando um(a) {weapon}."

L.desc_event_kill_drown = "{victim} ({vrole} / {vteam}) foi afogado por {attacker}."
L.desc_event_kill_drown_using = "{victim} ({vrole} / {vteam}) foi afogado pela {trap} acionado por {attacker} ({arole} / {ateam})."

L.desc_event_kill_boom = "{victim} ({vrole} / {vteam}) foi explodido por {attacker}."
L.desc_event_kill_boom_using = "{victim} ({vrole} / {vteam}) foi explodido por {attacker} ({arole} / {ateam}) usando {trap}."

L.desc_event_kill_burn = "{victim} ({vrole} / {vteam}) foi fritado por {attacker}."
L.desc_event_kill_burn_using = "{victim} ({vrole} / {vteam}) foi queimado por {trap} devido a(o) {attacker} ({arole} / {ateam})."

L.desc_event_kill_club = "{victim} ({vrole} / {vteam}) foi espancado por {attacker}."
L.desc_event_kill_club_using = "{victim} ({vrole} / {vteam}) foi espancado até a morte por {attacker} ({arole} / {ateam}) usando {trap}."

L.desc_event_kill_slash = "{victim} ({vrole} / {vteam}) foi esfaqueado por {attacker}."
L.desc_event_kill_slash_using = "{victim} ({vrole} / {vteam}) foi cortado por {attacker} ({arole} / {ateam}) usando {trap}."

L.desc_event_kill_tele = "{victim} ({vrole} / {vteam}) foi telefragged por {attacker}."
L.desc_event_kill_tele_using = "{victim} ({vrole} / {vteam}) foi atomizado pela {trap} definido por {attacker} ({arole} / {ateam})."

L.desc_event_kill_goomba = "{victim} ({vrole} / {vteam}) foi esmagado pela enorme massa de {attacker} ({arole} / {ateam})."

L.desc_event_kill_crush = "{victim} ({vrole} / {vteam}) foi esmagado por {attacker}."
L.desc_event_kill_crush_using = "{victim} ({vrole} / {vteam}) foi esmagado pela {trap} de {attacker} ({arole} / {ateam})."

L.desc_event_kill_other = "{victim} ({vrole} / {vteam}) foi morto por {attacker}."
L.desc_event_kill_other_using = "{victim} ({vrole} / {vteam}) foi morto por {attacker} ({arole} / {ateam}) usando {trap}."

-- 2021-04-20
L.none = "Sem função"

-- 2021-04-24
--L.karma_teamkill_tooltip = "Teammate killed"
--L.karma_teamhurt_tooltip = "Teammate damaged"
--L.karma_enemykill_tooltip = "Enemy killed"
L.karma_enemyhurt_tooltip = "Enemy damaged"
L.karma_cleanround_tooltip = "Limpar rodada"
--L.karma_roundheal_tooltip = "Karma restoration"
L.karma_unknown_tooltip = "Desconhecido"

-- 2021-05-07
--L.header_random_shop_administration = "Random Shop Settings"
L.header_random_shop_value_administration = "Configuração de Balanceamento"

L.shopeditor_name_random_shops = "Ativar loja aleatória"
--L.shopeditor_desc_random_shops = [[Random shops give every player a limited randomized set of all available equipments.
--Team shops forcefully give the same set to all players in a team instead of individual ones.
--Rerolling allows you to get a new randomized set of equipment for credits.]]
L.shopeditor_name_random_shop_items = "Número de equipamentos aleatórios"
--L.shopeditor_desc_random_shop_items = "This includes equipments, which are marked with \"Always available in shop\". So choose a high enough number or you only get those."
L.shopeditor_name_random_team_shops = "Ativar loja de times"
L.shopeditor_name_random_shop_reroll = "Ativar habilidade de rolagem"
L.shopeditor_name_random_shop_reroll_cost = "Custo por rolagem"
L.shopeditor_name_random_shop_reroll_per_buy = "Rolar automaticamente após compra"

-- 2021-06-04
--L.header_equipment_setup = "Equipment Settings"
L.header_equipment_value_setup = "Configuração de Balanceamento"

--L.equipmenteditor_name_not_buyable = "Can be bought"
L.equipmenteditor_desc_not_buyable = "Se desativado, o equipamento não irá mostrar na loja. Papéis que comprarem, terão o equipamento ainda."
L.equipmenteditor_name_not_random = "Sempre disponível na loja"
--L.equipmenteditor_desc_not_random = "If enabled, the equipment is always available in the shop. When the random shop is enabled, it takes one available random slot and always reserves it for this equipment."
L.equipmenteditor_name_global_limited = "Limitar na quantia global"
--L.equipmenteditor_desc_global_limited = "If enabled, the equipment can be bought only once on the server in the active round."
L.equipmenteditor_name_team_limited = "Limite na quantia por time"
--L.equipmenteditor_desc_team_limited = "If enabled, the equipment can be bought only once per team in the active round."
L.equipmenteditor_name_player_limited = "Limite de quantia por jogador"
--L.equipmenteditor_desc_player_limited = "If enabled, the equipment can be bought only once per player in the active round."
--L.equipmenteditor_name_min_players = "Minimum amount of players for buying"
L.equipmenteditor_name_credits = "Preço por créditos"

-- 2021-06-08
L.equip_not_added = "não adicionado"
L.equip_added = "adicionado"
L.equip_inherit_added = "adicionado (herdar)"
L.equip_inherit_removed = "removido (herdar)"

-- 2021-06-09
L.layering_not_layered = "Sem camada"
L.layering_layer = "Camada {layer}"
--L.header_rolelayering_role = "{role} layering"
--L.header_rolelayering_baserole = "Base role layering"
L.submenu_roles_rolelayering_title = "Camada da função"
L.header_rolelayering_info = "Informação da função da camada"
--L.help_rolelayering_roleselection = [[
--The role distribution process is split into two stages. In the first stage base roles are distributed, which are Innocent, Traitor and those listed in the 'base role layer' box below. The second stage is used to upgrade those base roles to a subrole.
--
--Further details are available in the "Roles Overview" submenu.]]
--L.help_rolelayering_layers = [[
--After determining the assignable roles according to role-specific convars (including the random chance they will be selected at all!), one role from each layer (if there are any) is selected for distribution. After handling the layers, unlayered roles are selected at random. Role distribution stops as soon as there are no more slots which need to be filled.
--
--Roles which are not considered due to convar-related requirements are not distributed.]]
L.scoreboard_voice_tooltip = "Rolar para mudar de volume"

-- 2021-06-15
L.header_shop_linker = "Configuração"
L.label_shop_linker_set = "Selecionar tipo de loja:"

-- 2021-06-18
L.xfer_team_indicator = "Time"

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
--L.label_select_unique_model_per_round = "Select a random unique model for each player"

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

--L.submenu_roles_roles_general_title = "General Role Settings"

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
--L.help_item_armor_classic = "If classic armor mode is enabled, only the previous settings matter. Classic armor mode means that a player can only buy armor once in a round, and that this armor blocks 30% of the incoming bullet damage until they die."
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
--L.label_sprint_max = "Speed boost factor"
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

--L.drop_on_death_type_default = "Default (equipment-defined)"
--L.drop_on_death_type_force = "Force Drop on Death"
--L.drop_on_death_type_deny = "Deny Drop on Death"

-- 2023-08-26
--L.equipmenteditor_name_kind = "Equipment Slot"
--L.equipmenteditor_desc_kind = "The inventory slot the equipment will occupy."

--L.slot_weapon_melee = "Melee Slot"
--L.slot_weapon_pistol = "Secondary Slot"
--L.slot_weapon_heavy = "Primary Slot"
--L.slot_weapon_nade = "Grenade Slot"
--L.slot_weapon_carry = "Carry Slot"
--L.slot_weapon_unarmed = "Unarmed Slot"
--L.slot_weapon_special = "Special Slot"
--L.slot_weapon_extra = "Extra Slot"
--L.slot_weapon_class = "Class Slot"

-- 2023-10-04
--L.label_voice_duck_spectator = "Muffle spectator voices"
--L.label_voice_duck_spectator_amount = "Spectator voice muffle amount"
--L.label_voice_scaling = "Voice Volume Scaling Mode"
--L.label_voice_scaling_mode_linear = "Linear"
--L.label_voice_scaling_mode_power4 = "Power 4"
--L.label_voice_scaling_mode_log = "Logarithmic"

-- 2023-10-07
L.search_title = "Resultados de investigação corporal - {player}"
L.search_info = "Informação"
L.search_confirm = "Confirmar Morte"
--L.search_confirm_credits = "Confirm (+{credits} Credit(s))"
--L.search_take_credits = "Take {credits} Credit(s)"
--L.search_confirm_forbidden = "Confirm forbidden"
--L.search_confirmed = "Death Confirmed"
--L.search_call = "Report Death"
--L.search_called = "Death Reported"

--L.search_team_role_unknown = "???"

L.search_words = "Algo lhe diz que algumas das últimas palavras desta pessoa foram: '{lastwords}'"
L.search_armor = "Ele estava vestindo um colete balístico atípico."
L.search_disguiser = "Ele estava carregando um dispositivo que podia ocultar sua identidade."
L.search_radar = "Ele estava carregando algum tipo de radar. Não está mais funcionando."
L.search_c4 = "Você encontrou uma nota em um bolso. Ela diz que ao cortar o fio {num}, a bomba será desarmada com segurança."

L.search_dmg_crush = "A maioria dos ossos dele estão quebrados. Parece que ele foi esmagado por algo pesado."
L.search_dmg_bullet = "É óbvio que ele foi baleado."
L.search_dmg_fall = "Ele caiu para sua morte."
L.search_dmg_boom = "Seus ferimentos e roupas rasgadas indicam que uma explosão o matou."
L.search_dmg_club = "Este corpo está muito ferido. Claramente ele foi espancado até a morte."
L.search_dmg_drown = "O corpo revela sinais de afogamento."
L.search_dmg_stab = "Ele foi esfaqueado e cortado antes de rapidamente sangrar até a morte."
L.search_dmg_burn = "Cheiro de terrorista assado por aqui..."
L.search_dmg_teleport = "Parece que a amostra de DNA dele foi embaraçada por emissões de táquion!"
L.search_dmg_car = "Quando este terrorista atravessou a estrada, acabou sendo atropelado por um motorista com a CNH vencida."
L.search_dmg_other = "Você não pôde encontrar uma causa específica da morte deste terrorista."

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
--L.search_floor_tile = "Small shards are stuck to their skin. Like shards from floor tiles that shattered on impact."
--L.search_floor_grass = "It smells like fresh cut grass. The smell almost overpowers the smell of blood and death."
--L.search_floor_vent = "You feel a fresh gust of air when you touch their body. Did they die in a vent and take the air with them?"
--L.search_floor_wood = "What's nicer than sitting on a hardwood floor and dwelling in thoughts? At least lot lying dead on a wooden floor!"
--L.search_floor_default = "That seems so basic, so normal. Almost default. You can't tell anything about the kind of surface."
--L.search_floor_glass = "Their body is covered with many bloody cuts. In some of them glass shards are stuck and look rather threatening to you."
--L.search_floor_warpshield = "A floor made out of warpshield? Yep, we are as confused as you were. But our notes clearly state it. Warpshield."

--L.search_water_1 = "The victim's shoes are wet, but the rest seems dry. They were probably killed with their feet in water."
--L.search_water_2 = "The victim's shoes are trousers are soaked through. Did they wander through water before they were killed?"
--L.search_water_3 = "The whole body is wet and swollen. They probably died while they were completely submerged."

L.search_weapon = "Aparentemente, um(a) {weapon} foi usado(a) para matá-lo."
L.search_head = "O disparo foi direto na cabeça. A vítima não teve tempo para gritar."
--L.search_time = "They died a while before you conducted the search."
--L.search_dna = "Retrieve a sample of the killer's DNA with a DNA Scanner. The DNA sample will decay after a while."

L.search_kills1 = "Você encontrou uma lista de assassinatos que comprovam a morte de {player}."
L.search_kills2 = "Você encontrou uma lista de assassinatos com estes nomes: {player}"
L.search_eyes = "Usando suas técnicas de detetive, você identificou a última pessoa que ele viu: {player}. O assassino, ou uma coincidência?"

--L.search_credits = "The victim has {credits} equipment credit(s) in their pocket. A shopping role might take them and put them to good use. Keep an eye out!"

--L.search_kill_distance_point_blank = "It was a point blank attack."
--L.search_kill_distance_close = "The attack came from a short distance."
--L.search_kill_distance_far = "The attack came from a long distance away."

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
--L.corpse_hint_spectator = "Press [{usekey}] to view search UI"
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
--Key bind helper is a UI element that always shows relevant keybindings to the player, which is especially helpful for new players. There are three different types of key bindings:
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
--L.label_keyhelper_mutespec = "cycle spectator mute mode"
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
--L.label_keyhelper_ammo_drop = "drop reserved ammo from selected weapon"

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
--L.marker_vision_distance = "Distance: {distance}"
--L.marker_vision_distance_collapsed = "{distance}"

--L.c4_marker_vision_time = "Detonation time: {time}"
--L.c4_marker_vision_collapsed = "{time} / {distance}"

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

--L.beacon_short_desc = "Beacons are used by policing roles to add local wallhacks around them"

--L.entity_pickup_owner_only = "Only the owner can pick this up"

L.body_confirm_one = "{finder} confirmou a morte de {victim}."
--L.body_confirm_more = "{finder} confirmed the {count} deaths of: {victims}."

-- 2023-12-19
--L.builtin_marker = "Built-in."
--L.equipmenteditor_desc_builtin = "This equipment is built-in, it comes with TTT2!"
--L.help_roles_builtin = "This role is built-in, it comes with TTT2!"
--L.header_equipment_info = "Equipment information"

-- 2023-12-20
--L.equipmenteditor_desc_damage_scaling = [[Multiplies the base damage value of a weapon by this factor.
--For a shotgun, this would affect each pellet.
--For a rifle, this would affect just the bullet.
--For the poltergeist, this would affect each "thump" and the final explosion.
--
--0.5 = Deal half the amount of damage.
--2 = Deal twice the amount of damage.
--
--Note: Some weapons might not use this value which causes this multiplier to be ineffective.]]

-- 2023-12-24
--L.submenu_gameplay_accessibility_title = "Accessibility"

--L.header_accessibility_settings = "Accessibility Settings"

--L.label_enable_dynamic_fov = "Enable dynamic FOV change"
--L.label_enable_bobbing = "Enable view bobbing"
--L.label_enable_bobbing_strafe = "Enable view bobbing when strafing"

--L.help_enable_dynamic_fov = "Dynamic FOV is applied depending on the player's speed. When a player is sprinting for example, the FOV is increased to visualize the speed."
--L.help_enable_bobbing_strafe = "View bobbing is the slight camera shake while walking, swimming or falling."

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

-- 2024-01-24
--L.grenade_fuse = "FUSE"

-- 2024-01-25
--L.header_roles_magnetostick = "Magneto Stick"
--L.label_roles_ragdoll_pinning = "Enable ragdoll pinning"
--L.magneto_stick_help_carry_rag_pin = "Pin ragdoll"
--L.magneto_stick_help_carry_rag_drop = "Put down ragdoll"
--L.magneto_stick_help_carry_prop_release = "Release prop"
--L.magneto_stick_help_carry_prop_drop = "Put down prop"

-- 2024-01-27
L.decoy_help_primary = "Plantar a isca"
--L.decoy_help_secondary = "Stick Decoy to surface"


--L.marker_vision_visible_for_0 = "Visible for you"
--L.marker_vision_visible_for_1 = "Visible for your role"
--L.marker_vision_visible_for_2 = "Visible for your team"
--L.marker_vision_visible_for_3 = "Visible for everyone"

-- 2024-02-14
--L.throw_no_room = "You have no space here to drop this device"

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
--L.length_in_meters = "{length}m"
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
