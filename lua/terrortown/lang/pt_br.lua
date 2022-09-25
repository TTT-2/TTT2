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
L.traitors = "Team Traitor"

-- Round status messages
L.round_minplayers = "Não há jogadores suficientes para começar uma nova rodada..."
L.round_voting = "Votação em andamento, adiando nova rodada em {num} segundos..."
L.round_begintime = "Uma nova rodada começará em {num} segundos. Prepare-se."
L.round_selected = "Os Traidores foram escolhidos"
L.round_started = "A rodada começou!"
L.round_restart = "A rodada foi reiniciada por um administrador."

L.round_traitors_one = "Traidor, você é um assassino solitário."
L.round_traitors_more = "Traidor, estes são seus aliados: {names}"

L.win_time = "O tempo acabou. Os Traidores perderam."
L.win_traitors = "Os Traidores venceram!"
L.win_innocents = "Os Inocentes venceram!!"
L.win_nones = "Não há vencedores!"
L.win_showreport = "Os resultados da rodada serão exibidos por {num} segundos."

L.limit_round = "Limite de rodadas atingido. O próximo mapa mudará em breve."
L.limit_time = "Tempo limite atingindo. O próximo mapa mudará em breve."
L.limit_left = "Ainda há {num} rodada(s) ou {time} minutos restantes antes da troca de mapa."

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

L.body_confirm = "{finder} confirmou a morte de {victim}."

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
L.radio_help = "Clique em um botão para fazer seu Rádio reproduzir tal som."
L.radio_notplaced = "Você deve posicionar o Rádio em algum lugar para poder reproduzir sons."

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

--{player} in the quickchat text normally becomes a player nickname, but can
-- also be one of the below.  Keep these lowercase.
L.quick_nobody = "ninguém"
L.quick_disg = "alguém disfarçado"
L.quick_corpse = "um corpo não identificado"
L.quick_corpse_id = "o cadáver de {player}"

-- Body search window
L.search_title = "Resultados de investigação corporal"
L.search_info = "Informação"
L.search_confirm = "Confirmar Morte"
L.search_call = "Chamar Detetive"

-- Descriptions of pieces of information found
L.search_nick = "Este é o corpo de {player}."

L.search_role_traitor = "Este jogador era um Traidor!"
L.search_role_det = "Este jogador era um Detetive."
L.search_role_inno = "Este jogador era um terrorista inocente."

L.search_words = "Algo lhe diz que algumas das últimas palavras desta pessoa foram: '{lastwords}'"
L.search_armor = "Ele estava vestindo um colete balístico atípico."
L.search_disg = "Ele estava carregando um dispositivo que podia ocultar sua identidade."
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
L.search_dmg_tele = "Parece que a amostra de DNA dele foi embaraçada por emissões de táquion!"
L.search_dmg_car = "Quando este terrorista atravessou a estrada, acabou sendo atropelado por um motorista com a CNH vencida."
L.search_dmg_other = "Você não pôde encontrar uma causa específica da morte deste terrorista."

L.search_weapon = "Aparentemente, um(a) {weapon} foi usado(a) para matá-lo."
L.search_head = "O disparo foi direto na cabeça. A vítima não teve tempo para gritar."
L.search_time = "Ele morreu aproximadamente após {time} antes de seu corpo ser encontrado."
L.search_dna = "Recupere uma amostra do DNA do assassino utilizando um Scanner de DNA. A amostra de DNA sumirá em aproximadamente {time} a partir de agora."

L.search_kills1 = "Você encontrou uma lista de assassinatos que comprovam a morte de {player}."
L.search_kills2 = "Você encontrou uma lista de assassinatos com estes nomes:"
L.search_eyes = "Usando suas técnicas de detetive, você identificou a última pessoa que ele viu: {player}. O assassino, ou uma coincidência?"

-- Scoreboard
L.sb_playing = "Você está jogando em..."
L.sb_mapchange = "O mapa será mudado em {num} rodadas ou em {time}"

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
Reduz o dano das balas em 30%
quando você é atingido.

Equipamento padrão de Detetives.]]

L.item_radar = "Radar"
L.item_radar_desc = [[
Permite varrer sinais vitais.

Varre automaticamente assim que você o compra.
Configure-o na aba Radar deste menu.]]

L.item_disg = "Disfarce"
L.item_disg_desc = [[
Oculta sua identidade enquanto habilitado. Também
evita ser a última pessoa vista por uma vítima.

Habilite-o na aba Disfarce deste menu
ou aperte a tecla Enter do teclado numérico.]]

-- C4
L.c4_hint = "Pressione {usekey} para armar ou desarmar."
L.c4_no_disarm = "Você não pode desarmar o C4 de outro Traidor, a não ser que ele esteja morto."
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

L.c4_disarm_owned = "Corte um fio para desarmar a bomba. É a sua bomba, então todos os fios a desarmarão."
L.c4_disarm_other = "Corte um fio seguro para desarmar a bomba. Vai explodir se você errar!"

L.c4_status_armed = "ARMADO"
L.c4_status_disarmed = "DESARMADO"

-- Visualizer
L.vis_name = "Visualizador"
L.vis_hint = "Pressione {usekey} para pegar (somente Detetives)."

L.vis_desc = [[
Permite visualizar uma cena de crime.

Analisa um cadáver para mostrar como
a vítima morreu, mas somente se
ela tiver morrido por ferimentos de armas de fogo.]]

-- Decoy
L.decoy_name = "Isca"
L.decoy_no_room = "Você não pode pegar esta Isca."
L.decoy_broken = "Sua Isca foi destruída!"

L.decoy_short_desc = "Está isca, mostrará um radar falso para o outro time."
L.decoy_pickup_wrong_team = "Você não pode pegar está isca, pertence ao time diferente!"

L.decoy_desc = [[
Mostra um sinal de radar falso para Detetives,
e faz os scanners de DNA deles indicar a
localização da sua Isca se eles procurarem
a amostra do seu DNA.]]

-- Defuser
L.defuser_name = "Kit de Desarme"
L.defuser_help = "{primaryfire} desarma um C4 que está sob sua mira."

L.defuser_desc = [[
Instantaneamente desarma um explosivo C4.

Usos ilimitados. Um C4 será mais fácil de
ser notado se você estiver com isto equipado.]]

-- Flare gun
L.flare_name = "Pistola Sinalizadora"

L.flare_desc = [[
Pode ser usado para queimar cadáveres para que
eles nunca sejam encontrados. Munição limitada.

Queimar um cadáver emite um som estranho.]]

-- Health station
L.hstation_name = "Estação de Cura"

L.hstation_broken = "Sua Estação de Cura foi destruída!"
L.hstation_help = "{primaryfire} posiciona a Estação de Cura."

L.hstation_desc = [[
Permite que as pessoas se curem quando posicionada.

Seu tempo de recarga é lento. Qualquer um pode
usá-la, e ela pode ser danificada. Pode ser usada
para analisar o DNA de seus utilizadores.]]

-- Knife
L.knife_name = "Faca"
L.knife_thrown = "Faca arremessada"

L.knife_desc = [[
Mata o alvo instantaneamente e de forma silenciosa,
mas só pode ser usada uma vez.

Pode ser arremessada ao usar
o botão de ataque alternativo.]]

-- Poltergeist
L.polter_desc = [[
Planta batedores em objetos para empurrar pessoas
à sua volta de maneira violenta.

A energia causa dano em pessoas
que estejam nas proximidades.]]

-- Radio
L.radio_broken = "Seu Rádio foi destruído!"
L.radio_help_pri = "{primaryfire} posiciona o Rádio."

L.radio_desc = [[
Reproduz sons para distrair e/ou enganar.

Posicione o Rádio em algum lugar, e então
reproduza os sons nele utilizando a aba Rádio
deste menu.]]

-- Silenced pistol
L.sipistol_name = "Pistola Silenciada"

L.sipistol_desc = [[
Pistola de baixo ruído, usa munição
de pistola normal.

As vítimas não gritarão quando forem mortas.]]

-- Newton launcher
L.newton_name = "Lançador Newton"

L.newton_desc = [[
Empurra pessoas a partir de uma distância segura.

Sua munição é infinita, mas dispara lentamente.]]

-- Binoculars
L.binoc_name = "Binóculos"

L.binoc_desc = [[
Permite dar zoom em cadáveres para identificá-los
a partir de uma longa distância.

Seus usos são ilimitados, porém o processo
de identificação demora alguns segundos.]]

-- UMP
L.ump_desc = [[
SMG experimental que desorienta
alvos.

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
Colete amostras de DNA de objetos
e analise-as para saber quem os usou.

Utilize-o em terroristas recentemente mortos
para coletar a amostra do DNA do assassino e assim
poder rastreá-lo.]]

-- Magneto stick
L.magnet_name = "Magneto-stick"
L.magnet_help = "{primaryfire} para prender um corpo a uma superfície."

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

L.tele_help_pri = "{primaryfire} teletransporta para o local marcado."
L.tele_help_sec = "{secondaryfire} marca um local de teletransporte."

L.tele_desc = [[
Teletransporta para um local previamente marcado.

Teletransportar-se faz barulho, e tem
um número limitado de usos.]]

-- Ammo names, shown when picked up
L.ammo_pistol = "Munição de Pistola"

L.ammo_smg1       = "Munição de SMG"
L.ammo_buckshot   = "Munição de Escopeta"
L.ammo_357        = "Munição de Rifle"
L.ammo_alyxgun    = "Munição de Deagle"
L.ammo_ar2altfire = "Munição de Pistola Sinalizadora"
L.ammo_gravity    = "Munição de Poltergeist"

-- Round status
L.round_wait   = "Aguardando"
L.round_prep   = "Preparando"
L.round_active = "Em progresso"
L.round_post   = "Terminando"

-- Health, ammo and time area
L.overtime     = "TEMPO EXTRA"
L.hastemode    = "MODO PRESSA"

-- TargetID health status
L.hp_healthy   = "Saudável"
L.hp_hurt      = "Machucado"
L.hp_wounded   = "Ferido"
L.hp_badwnd    = "Muito Ferido"
L.hp_death     = "Quase Morto"

-- TargetID karma status
L.karma_max    = "Respeitável"
L.karma_high   = "Bruto"
L.karma_med    = "Guerreiro"
L.karma_low    = "Perigoso"
L.karma_min    = "Irresponsável"

-- TargetID misc
L.corpse       = "Cadáver"
L.corpse_hint  = "Pressione {usekey} para investigar. {walkkey} + {usekey} para investigar furtivamente."

L.target_disg  = " (DISFARÇADO)"
L.target_unid  = "Corpo não identificado"
L.target_unknown = "Um terrorista"

L.target_credits = "Vasculhe para receber créditos não gastos"

-- HUD buttons with hand icons that only some roles can see and use
L.tbut_single  = "Uso único"
L.tbut_reuse   = "Reutilizável"
L.tbut_retime  = "Reutilizável após {num} seg"
L.tbut_help    = "Pressione {key} para ativar"

-- Spectator muting of living/dead
L.mute_living  = "Jogadores vivos emudecidos"
L.mute_specs   = "Espectadores emudecidos"
L.mute_all     = "Todos emudecidos"
L.mute_off     = "Ninguém emudecido"

-- Spectators and prop possession
L.punch_title  = "SOCÔMETRO"
L.punch_help   = "Movimentar-se ou pular: soca o objeto. Agachar-se: sai do objeto."
L.punch_bonus  = "Sua má pontuação diminuiu seu limite do socômetro em {num}"
L.punch_malus  = "Sua boa pontuação aumentou seu limite do socômetro em {num}!"

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
L.idle_popup_off   = "Desabilitar Somente-Espectador"

L.idle_warning = "Aviso: você aparenta estar ausente, e será movido para a equipe dos espectadores a não ser que demonstre alguma atividade!"

L.spec_mode_warning = "Você está no Modo Espectador e não renascerá quando uma nova rodada começar. Para desabilitar esse modo, pressione F1, clique na aba Configurações e desmarque a opção 'Modo Somente-Espectador'."

-- Tips panel
L.tips_panel_title = "Dicas"
L.tips_panel_tip   = "Dica:"

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

L.tip10 = "Como Traidor ou Detetive, fique de olho em mensagens vermelhas no canto superior direito da tela. Elas serão importantes para você."

L.tip11 = "Como Traidor ou Detetive, tenha em mente que você será recompensado com créditos se você e seus comparsas progredirem bem. Lembre-se de gastá-los!"

L.tip12 = "O Scanner de DNA dos Detetives pode ser usado para coletar amostras de DNA de armas e itens e analisá-las para descobrir a localização do jogador que os usou. Isso é útil quando você consegue coletar uma amostra de um cadáver ou de um C4 desarmado!"

L.tip13 = "Quando estiver perto de alguém que você matou, um pouco do seu DNA será deixado no cadáver. Esse DNA pode ser coletado por um Scanner de DNA de um Detetive para encontrar sua localização atual. É melhor esconder o corpo da vítima depois de esfaqueá-la!"

L.tip14 = "Quanto mais longe você estiver de alguém que você matar, mais rapidamente a amostra do seu DNA no corpo da sua vítima vai deteriorar-se."

L.tip15 = "Você é um Traidor e quer tentar matar alguém com um rifle de precisão? Considere habilitar o Disfarce antes. Se você errar um tiro, fuja para um local seguro, desabilite o Disfarce, e ninguém saberá que era você que estava atirando neles."

L.tip16 = "Como Traidor, o Teletransportador pode ajudar-lhe a escapar enquanto você estiver sendo perseguido, além de permitir que você se desloque rapidamente em um mapa grande. Certifique-se de sempre ter uma posição segura marcada."

L.tip17 = "Os inocentes estão todos agrupados sendo difíceis de serem mortos? Considere experimentar o Rádio para reproduzir sons de um C4 ou de um tiroteio para fazer com que eles se desagrupem."

L.tip18 = "Ao usar o Rádio como Traidor, você pode reproduzir sons através do seu Menu de Equipamentos depois que o Rádio for posicionado. Coloque vários sons para serem reproduzidos em sequência ao clicar nos botões usando a ordem desejada."

L.tip19 = "Como Detetive, se você estiver com alguns créditos sobrando, você pode dar um Kit de Desarme para um Inocente confiável. Assim, você pode gastar seu tempo com um trabalho mais sério de investigação enquanto você deixa a missão arriscada de desarmamento para ele."

L.tip20 = "Os Binóculos dos Detetives permitem localizar e identificar cadáveres a distância. Más notícias se os Traidores estavam querendo usar um cadáver como isca. Mas é claro que, quando um Detetive estiver usando os Binóculos, ele estará desarmado e distraído..."

L.tip21 = "A Estação de Cura dos Detetives permite que jogadores feridos se curem. Mas é claro que, os jogadores feridos podem ser Traidores..."

L.tip22 = "A Estação de Cura armazena uma amostra do DNA de cada jogador que a utilizar. Os Detetives podem utilizar o Scanner de DNA na Estação de Cura para descobrir quem andou se curando."

L.tip23 = "Diferentemente de armas e do C4, o Rádio dos Traidores não contém uma amostra do DNA de quem o posicionou. Não se preocupe com Detetives encontrando o seu DNA e descobrindo a sua verdadeira identidade."

L.tip24 = "Pressione {helpkey} para ver um curto tutorial ou modificar suas configurações do TTT. Por exemplo, você pode desabilitar permanentemente estas dicas lá."

L.tip25 = "Quando um Detetive investiga um corpo, o resultado é disponibilizado para todos no placar ao clicar no nome da pessoa morta."

L.tip26 = "No placar, um ícone de lupa próximo ao nome de alguém indica que você coletou informações sobre aquela pessoa. Se o ícone estiver brilhando, os dados da investigação são provindos de um Detetive e podem conter informações adicionais."

L.tip27 = "Como Detetive, cadáveres com um ícone de lupa depois de seu nome foram investigados por um Detetive e os resultados estão disponíveis para todos os jogadores pelo placar."

L.tip28 = "Espectadores podem pressionar {mutekey} para alternar entre emudecer outros espectadores ou jogadores vivos."

L.tip29 = "Se o servidor instalou idiomas adicionais, você pode mudar para um idioma diferente a qualquer momento no menu Configurações."

L.tip30 = "Os atalhos do chat ou comandos do 'rádio' podem ser utilizados ao pressionar {zoomkey}."

L.tip31 = "Como Espectador, pressione {duckkey} para destravar o cursor do seu mouse e ser possibilitado de clicar neste painel de dicas. Pressione {duckkey} novamente para voltar à visualização normal."

L.tip32 = "O ataque alternativo do Pé de Cabra empurrará outros jogadores."

L.tip33 = "Atirar usando a retícula de ferro de uma arma aumentará levemente a sua precisão e diminuirá o seu recuo. Agachar-se não fará diferença."

L.tip34 = "Granadas de Fumaça são eficazes em ambientes fechados, especialmente para criar confusão em salas lotadas."

L.tip35 = "Como Traidor, lembre-se de que você pode deslocar corpos e escondê-los dos inocentes e dos Detetives."

L.tip36 = "O tutorial disponível na tecla {helpkey} contém uma visão geral sobre as características mais importantes do TTT."

L.tip37 = "No placar, clique no nome de um jogador vivo e então você poderá marcá-lo como 'suspeito' ou 'amigo', entre outras marcações. A marcação será exibida quando você estiver com a mira sobre o jogador marcado."

L.tip38 = "A maioria dos equipamentos especiais posicionáveis (como o C4 e o Rádio) podem ser presos nas paredes ao usar o botão de ataque alternativo."

L.tip39 = "Um explosivo C4 que explodir devido a uma falha no seu desarmamento causará uma explosão menor do que um explosivo C4 que explodir devido ao seu temporizador ter chegado a zero."

L.tip40 = "Caso esteja escrito 'MODO PRESSA' acima do tempo da rodada, a rodada terá inicialmente apenas alguns minutos, mas a cada morte o tempo restante aumentará (como capturar um ponto no TF2). Esse modo pressiona os traidores para que eles mantenham as coisas em movimento."

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
L.report_save     = "Salvar Log .txt"
L.report_save_tip = "Salvar o Registro de Acontecimentos para um documento de texto"
L.report_save_error  = "Não há nenhum Registro de Acontecimentos a ser salvo."
L.report_save_result = "O Registro de Acontecimentos foi salvo em:"

-- Columns
L.col_time   = "Tempo"
L.col_event  = "Acontecimento"
L.col_player = "Jogador"
L.col_role   = "Cargo"
L.col_kills1 = "Inocentes mortos"
L.col_kills2 = "Traidores mortos"
L.col_points = "Pontos"
L.col_team   = "Bônus de equipe"
L.col_total  = "Total de pontos"

-- Awards/highlights
L.aw_sui1_title = "LÍDER DA SEITA SUICIDA"
L.aw_sui1_text  = "mostrou aos outros suicidas como as coisas funcionam sendo o primeiro a partir."

L.aw_sui2_title = "SOZINHO E DEPRESSIVO"
L.aw_sui2_text  = "foi o único que se matou."

L.aw_exp1_title = "BOLSA PARA PESQUISA DE EXPLOSIVOS"
L.aw_exp1_text  = "foi reconhecido por sua pesquisa com explosivos. {num} cobaias o ajudaram."

L.aw_exp2_title = "PESQUISA DE CAMPO"
L.aw_exp2_text  = "testou sua própria resistência a explosões. Não era alta o suficiente."

L.aw_fst1_title = "FIRST BLOOD"
L.aw_fst1_text  = "entregou a primeira morte de um inocente nas mãos de um traidor."

L.aw_fst2_title = "FIRST BLOOD REVERSO"
L.aw_fst2_text  = "marcou a primeira morte matando um traidor aliado. Bom trabalho."

L.aw_fst3_title = "ATAQUE DE PÂNICO"
L.aw_fst3_text  = "foi o primeiro a matar. Pena que era um camarada inocente."

L.aw_fst4_title = "TIRO CERTO"
L.aw_fst4_text  = "foi o inocente que marcou a primeira morte matando um traidor."

L.aw_all1_title = "MAIS MORTAL ENTRE IGUAIS"
L.aw_all1_text  = "foi responsável por cada morte causada pelos inocentes nesta rodada."

L.aw_all2_title = "LOBO SOLITÁRIO"
L.aw_all2_text  = "foi responsável por cada morte causada pelos traidores nesta rodada."

L.aw_nkt1_title = "EU PEGUEI UM, CHEFE!"
L.aw_nkt1_text  = "conseguiu matar apenas um inocente. Congratulações!"

L.aw_nkt2_title = "UMA BALA PARA DOIS"
L.aw_nkt2_text  = "mostrou que a primeira vítima não foi alva de um tiro de sorte ao matar outra vítima com a mesma bala."

L.aw_nkt3_title = "TRAIDOR EM SÉRIE"
L.aw_nkt3_text  = "acabou com três vidas inocentes de terrorismo hoje."

L.aw_nkt4_title = "O LOBO ENTRE LOBOS QUE MAIS PARECEM OVELHAS"
L.aw_nkt4_text  = "comeu terroristas inocentes no jantar. Um jantar de {num} pratos."

L.aw_nkt5_title = "OPERAÇÃO CONTRA-TERRORISTA"
L.aw_nkt5_text  = "é pago por cada assassinato. Agora já pode comprar outro iate luxuoso."

L.aw_nki1_title = "TRAIA ISTO"
L.aw_nki1_text  = "achou um traidor. Atirou num traidor. Fácil."

L.aw_nki2_title = "JAPONÊS DA FEDERAL"
L.aw_nki2_text  = "escoltou dois traidores para o além."

L.aw_nki3_title = "TRAIDORES CONTAM CARNEIRINHOS?"
L.aw_nki3_text  = "colocou três traidores para dormir."

L.aw_nki4_title = "FUNCIONÁRIO DE ASSUNTOS INTERNOS"
L.aw_nki4_text  = "é pago por cada assassinato. Agora já pode encomendar sua quinta piscina olímpica."

L.aw_fal1_title = "NÃO, SR. BOND, ESPERO QUE VOCÊ CAIA"
L.aw_fal1_text  = "empurrou alguém de um lugar alto."

L.aw_fal2_title = "PAVIMENTADO"
L.aw_fal2_text  = "deixou seu corpo bater no chão depois de cair de uma altura significativa."

L.aw_fal3_title = "O METEORITO HUMANO"
L.aw_fal3_text  = "esmagou alguém caindo sobre este de uma grande altura."

L.aw_hed1_title = "EFICIÊNCIA"
L.aw_hed1_text  = "descobriu a alegria dos tiros na cabeça e atirou em {num} cabeças."

L.aw_hed2_title = "NEUROLOGIA"
L.aw_hed2_text  = "removeu o cérebro de {num} cabeças para um exame minucioso."

L.aw_hed3_title = "A CULPA É DOS VIDEOGAMES"
L.aw_hed3_text  = "aplicou seu treinamento de simulação de assassinato e atirou em {num} cabeças de inimigos."

L.aw_cbr1_title = "THUNK THUNK THUNK"
L.aw_cbr1_text  = "descobriu que esse é o barulho que o Pé de Cabra faz ao matar, como {num} vítimas também descobriram."

L.aw_cbr2_title = "FREEMAN"
L.aw_cbr2_text  = "cobriu seu Pé de Cabra com nada menos do que {num} cérebros."

L.aw_pst1_title = "PEQUENO INSETO PERSISTENTE"
L.aw_pst1_text  = "marcou {num} mortes usando uma pistola. Logo após, ele abraçou alguém até a morte."

L.aw_pst2_title = "CHACINA DE PEQUENO CALIBRE"
L.aw_pst2_text  = "matou um pequeno exército de {num} com uma pistola. Provavelmente instalou uma pequena escopeta dentro do cano."

L.aw_sgn1_title = "MODO FÁCIL"
L.aw_sgn1_text  = "aplicou tiro onde dói, conseguindo matar {num} alvos."

L.aw_sgn2_title = "MILHARES DE BALAS PEQUENAS"
L.aw_sgn2_text  = "não gostou muito do chumbo grosso, e decidiu doá-lo. {num} destinatários não viveram para aproveitá-lo."

L.aw_rfl1_title = "APONTAR E CLICAR"
L.aw_rfl1_text  = "mostrou que tudo que você precisa para cometer {num} assassinatos é um rifle e uma mão firme."

L.aw_rfl2_title = "EU POSSO VER SUA CABEÇA DAQUI"
L.aw_rfl2_text  = "conhece o rifle que tem. Agora {num} pessoas conhecem o seu rifle também."

L.aw_dgl1_title = "É COMO UM PEQUENO RIFLE"
L.aw_dgl1_text  = "está pegando o jeito de jogar com a Desert Eagle, conseguindo matar {num} pessoas."

L.aw_dgl2_title = "MESTRE DA DESERT EAGLE"
L.aw_dgl2_text  = "surpreendeu {num} pessoas com sua Desert Eagle."

L.aw_mac1_title = "REZAR E MATAR"
L.aw_mac1_text  = "matou {num} pessoas com a MAC10, mas não dirá quanta munição precisou."

L.aw_mac2_title = "MAC COM QUEIJO"
L.aw_mac2_text  = "imagina o que aconteceria se ele estivesse com duas MAC10 em suas mãos. {num} vezes dois?"

L.aw_sip1_title = "FIQUE QUIETO"
L.aw_sip1_text  = "calou a boca de {num} pessoas com sua pistola silenciada."

L.aw_sip2_title = "ASSASSINO SILENCIOSO"
L.aw_sip2_text  = "matou {num} pessoas que não ouviram sua própria morte."

L.aw_knf1_title = "ESFAQUEAR-LHE-EI"
L.aw_knf1_text  = "esfaqueou a cara de alguém pela internet."

L.aw_knf2_title = "ONDE VOCÊ CONSEGUIU ISSO?"
L.aw_knf2_text  = "não era um Traidor, e mesmo assim matou alguém com uma faca."

L.aw_knf3_title = "O TAL ESFAQUEADOR"
L.aw_knf3_text  = "encontrou {num} facas espalhadas, e fez bom uso delas."

L.aw_knf4_title = "O MELHOR ESFAQUEADOR DO MUNDO"
L.aw_knf4_text  = "matou {num} pessoas com uma faca. Não me pergunte como."

L.aw_flg1_title = "AO RESGATE"
L.aw_flg1_text  = "usou seu sinalizador para sinalizar {num} mortes."

L.aw_flg2_title = "SINALIZADOR INDICA FOGO"
L.aw_flg2_text  = "ensinou a {num} homens sobre o perigo de vestir roupas inflamáveis."

L.aw_hug1_title = "UMA H.U.G.E SINTONIZADA"
L.aw_hug1_text  = "estava em sintonia com sua H.U.G.E, fazendo com que suas balas atingissem {num} pessoas."

L.aw_hug2_title = "ESQUIZOFRENIA BALÍSTICA"
L.aw_hug2_text  = "só ficou atirando, e viu sua H.U.G.E ser recompensada com {num} mortes."

L.aw_msx1_title = "PUTT PUTT PUTT"
L.aw_msx1_text  = "levou {num} pessoas com o M16."

L.aw_msx2_title = "LOUCURA DE ALCANCE MÉDIO"
L.aw_msx2_text  = "sabe derrubar pessoas com o M16, conseguindo marcar {num} mortes."

L.aw_tkl1_title = "FOI SEM QUERER"
L.aw_tkl1_text  = "pressionou o gatilho enquanto mirava em um aliado."

L.aw_tkl2_title = "FOI SEM QUERER QUERENDO"
L.aw_tkl2_text  = "pensou que havia matado dois Traidores, mas estava errado sobre ambos."

L.aw_tkl3_title = "KARMA-A-ARMA-AÊ"
L.aw_tkl3_text  = "não conseguiu parar depois de matar dois aliados. Três é seu número da sorte."

L.aw_tkl4_title = "OS MEUS ALIADOS SÃO MEUS INIMIGOS"
L.aw_tkl4_text  = "matou toda a sua equipe. PIMBA!"

L.aw_tkl5_title = "FUNÇÕES DIFERENTES"
L.aw_tkl5_text  = "estava interpretando um louco honesto. E é por isso que ele matou quase toda a sua equipe."

L.aw_tkl6_title = "ANTA"
L.aw_tkl6_text  = "não conseguiu descobrir em que equipe estava, e matou mais da metade de seus aliados."

L.aw_tkl7_title = "PEÃO"
L.aw_tkl7_text  = "protegeu seu território de maneira fantástica ao matar mais de um quarto de seus aliados."

L.aw_brn1_title = "COMO A VOVÓ FAZIA"
L.aw_brn1_text  = "fritou várias pessoas para fazer uma batata frita agradável."

L.aw_brn2_title = "PIROMANÍACO"
L.aw_brn2_text  = "foi ouvido gargalhando alto depois de queimar uma de suas muitas vítimas."

L.aw_brn3_title = "PIROMANÍACO GRANADEIRO"
L.aw_brn3_text  = "queimou todos, mas agora está sem granadas incendiárias! Como ele vai lidar com isso!?"

L.aw_fnd1_title = "MÉDICO LEGISTA"
L.aw_fnd1_text  = "encontrou {num} cadáveres por aí."

L.aw_fnd2_title = "TEMOS QUE PEGAR TODOS ELES"
L.aw_fnd2_text  = "encontrou {num} cadáveres para a sua coleção."

L.aw_fnd3_title = "CHEIRO DE MORTE"
L.aw_fnd3_text  = "continua tropeçando em cadáveres, conseguindo tropeçar {num} vezes nesta rodada."

L.aw_crd1_title = "RECICLADOR"
L.aw_crd1_text  = "coletou {num} créditos perdidos em cadáveres."

L.aw_tod1_title = "UMA-QUASE-VITÓRIA"
L.aw_tod1_text  = "morreu segundos antes de sua equipe vencer a partida."

L.aw_tod2_title = "EU ODEIO ESTE JOGO"
L.aw_tod2_text  = "morreu logo após o início da rodada."

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
L.equip_tooltip_reroll = "Items rolativo"

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
L.reroll_menutitle = "Items rolativo"
L.reroll_no_credits = "Você precisa de {amount} crédito(s) para rolar!"
L.reroll_button = "Rolar"
L.reroll_help = "Use {amount} crédito(s) para conseguir um novo item na loja!"

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

L.spec_help = "Clique para espectar um jogador, ou pressione {usekey} em um objeto para possuir ele.."
L.spec_help2 = "Para sair do modo espectador, abra o menu pressionando {helpkey}, vá em 'gameplay' e desative o modo espectador.."

-- 2019-10-19
L.drop_ammo_prevented = "Alguma coisa fez você soltar sua munição.."

-- 2019-10-28
L.target_c4 = "Pressione [{usekey}] para abrir o menu da C4"
L.target_c4_armed = "Pressione [{usekey}] para desarmar a C4"
L.target_c4_armed_defuser = "Pressione [{usekey}] para usar o desarme"
L.target_c4_not_disarmable = "Você não pode desarmar uma C4 de um companheiro ainda vivo"
L.c4_short_desc = "Alguma coisa muito explosivo"

L.target_pickup = "Pressione [{usekey}] para pegar"
L.target_slot_info = "Slot: {slot}"
L.target_pickup_weapon = "Pressione [{usekey}] para pegar a arma"
L.target_switch_weapon = "Pressione [{usekey}] para trocar com a sua arma no momento"
L.target_pickup_weapon_hidden = ", pressione [{usekey} + {walkkey}] para esconder a arma"
L.target_switch_weapon_hidden = ", pressione [{usekey} + {walkkey}] para esconder"
L.target_switch_weapon_nospace = "Não há slot de inventário para esta arma"
L.target_switch_drop_weapon_info = "Dropar {name} do slot {slot}"
L.target_switch_drop_weapon_info_noslot = "Não há uma arma dropavel no slot {slot}"

L.corpse_searched_by_detective = "Esse corpo foi encontrado por um detetive"
L.corpse_too_far_away = "Este corpo está muito longe."

L.radio_pickup_wrong_team = "Você não pode pegar a rádio de outro time."
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
L.tbut_team_toggle = "[SHIFT + {walkkey} + {usekey}] para ocultar o botão do time {team}"
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
L.mute_team = "{time} mutado."

-- 2020-02-16
L.door_auto_closes = "Esta porta fecha automaticamente.."
L.door_open_touch = "Ande até a porta para abrir."
L.door_open_touch_and_use = "Ande até a porta ou pressione [{usekey}] para abrir."
L.hud_health = "Vida"

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
L.menu_gameplay_description = "Evite funções e outras coisas também."
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
L.submenu_appearance_miscellaneous_title = "Outros"

L.submenu_gameplay_general_title = "Geral"
L.submenu_gameplay_avoidroles_title = "Evitar funções"

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
L.label_crosshair_gap_enable = "Ativar lacuna da mira personalizada"
L.label_crosshair_gap = "Lacuna personalizada da mira"
L.label_crosshair_opacity = "Opacidade da mira"
L.label_crosshair_ironsight_opacity = "Opacidade da mira de ferro"
L.label_crosshair_size = "Tamanho da mira"
L.label_crosshair_thickness = "Espessura da mira"
L.label_crosshair_thickness_outline = "Contorno da espessura da mira"
L.label_crosshair_static_enable = "Ativar mira estática"
L.label_crosshair_dot_enable = "Ativar ponto na mira"
L.label_crosshair_lines_enable = "Ativar linha da mira"
L.label_crosshair_scale_enable = "Ativar escala dependendo da arma"
L.label_crosshair_ironsight_low_enabled = "Mira de ferro para armas fracas"
L.label_damage_indicator_enable = "Ativar indicador de dano"
L.label_damage_indicator_mode = "Selecione o tema do indicador de dano"
L.label_damage_indicator_duration = "Desaparecimento depois de tomar dano (em segundos)"
L.label_damage_indicator_maxdamage = "Dano necessário para máximo opacidade"
L.label_damage_indicator_maxalpha = "Máximo opacidade"
L.label_performance_halo_enable = "Desenhar um contorno em volta a entidade quando olhar para ela"
L.label_performance_spec_outline_enable = "Ativar contorno de controle de objetos"
L.label_performance_ohicon_enable = "Ativar icone de funções acima da cabeça dos jogadores"
L.label_interface_tips_enable = "Mostrar dica de jogo na tela quando estiver espectando"
L.label_interface_popup = "Mostrar popup da duração de rodada"
L.label_interface_fastsw_menu = "Ativar menu de troca de arma rápida"
L.label_inferface_wswitch_hide_enable = "Ativar auto-fechamento de troca de arma rápida"
L.label_inferface_scues_enable = "Ativar som quando acabar/iniciar uma rodada"
L.label_gameplay_specmode = "Ativar modo espectador (ficar sempre em modo espectador)"
L.label_gameplay_fastsw = "Troca de arma rápida"
L.label_gameplay_hold_aim = "Ativar segurar para mirar"
L.label_gameplay_mute = "Mutar jogadores vivos quando morrer"
L.label_gameplay_dtsprint_enable = "Ativar apertar duas veze para correr"
L.label_gameplay_dtsprint_anykey = "Continuar apertando duas vezes antes de você parar"
L.label_hud_default = "HUD Padrão"
L.label_hud_force = "HUD Forçada"

L.label_bind_weaponswitch = "Pegar arma"
L.label_bind_sprint = "Correr"
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
L.header_roleselection = "Selecione a função que deseja evitar"
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
L.confirm_detective_only = "Apenas detetives podem confirmar o corpo."
L.inspect_detective_only = "Apenas detetive podem encontrar corpos."
L.corpse_hint_no_inspect = "Apenas detetives podem encontrar este corpo."
L.corpse_hint_inspect_only = "Pressione [{usekey}] para procurar. Apenas detetive pode confirmar o corpo."
L.corpse_hint_inspect_only_credits = "Pressione [{usekey}] para pegar os créditos. Apenas detetives podem encontrar este corpo."

-- 2020-06-04
L.label_bind_disguiser = "Alternar disfarce"

-- 2020-06-24
L.dna_help_primary = "Coletar uma amostra DNA"
L.dna_help_secondary = "Trocar slot do DNA"
L.dna_help_reload = "Deletar amostra"

L.binoc_help_pri = "Procurar um corpo."
L.binoc_help_sec = "Alterar o zoom."

L.vis_help_pri = "Largar o dispositivo ativo."

L.decoy_help_pri = "Plantar a isca."

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

L.label_bind_clscore = "Abrir menu do final da rodada"
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

L.tooltip_karma_gained = "Karma ganhado nessa rodada:"
L.tooltip_score_gained = "Ponto ganhado nessa rodada::"
L.tooltip_roles_time = "Funções ao longo do tempo:"

L.tooltip_finish_score_alive_teammates = "Companheiros vivos: {score}"
L.tooltip_finish_score_alive_all = "Jogadores vivos: {score}"
L.tooltip_finish_score_timelimit = "Tempo acabou: {score}"
L.tooltip_finish_score_dead_enemies = "Inimigos mortos: {score}"
L.tooltip_kill_score = "Mortes: {score}"
L.tooltip_bodyfound_score = "Corpos encontrados: {score}"

L.finish_score_alive_teammates = "Companheiros vivos:"
L.finish_score_alive_all = "Jogadores vivos:"
L.finish_score_timelimit = "Tempo acabou:"
L.finish_score_dead_enemies = "Inimigos mortos:"
L.kill_score = "Mortes:"
L.bodyfound_score = "Corpos encontrados:"

L.title_event_bodyfound = "Um corpo foi encontrado"
L.title_event_c4_disarm = "Uma C4 foi desarmada"
L.title_event_c4_explode = "Uma C4 explodiu"
L.title_event_c4_plant = "Uma C4 foi plantada"
L.title_event_creditfound = "Créditos que foram encontrados"
L.title_event_finish = "A rodada terminou"
L.title_event_game = "Uma nova rodada foi iniciada"
L.title_event_kill = "Um jogador foi morto"
L.title_event_respawn = "Um jogador respawnou"
L.title_event_rolechange = "Um jogador mudou de papél ou de time"
L.title_event_selected = "Os papéis foram selecionados"
L.title_event_spawn = "Um jogador spawnou"

L.desc_event_bodyfound = "{finder} ({firole} / {fiteam}) encontrou o corpo de {found} ({forole} / {foteam}). O corpo tinha {credits} credito(s)."
L.desc_event_bodyfound_headshot = "O jogador foi morto por um tiro na cabeça."
L.desc_event_c4_disarm_success = "{disarmer} ({drole} / {dteam}) C4 desarmada com sucesso colocada por {owner} ({orole} / {oteam})."
L.desc_event_c4_disarm_failed = "{disarmer} ({drole} / {dteam}) tentou desarmar a C4 colocada por {owner} ({orole} / {oteam}). Ele falhou."
L.desc_event_c4_explode = "A C4 colocada por {owner} ({role} / {team}) explodiu."
L.desc_event_c4_plant = "{owner} ({role} / {team}) colocou um explosivo C4."
L.desc_event_creditfound = "{finder} ({firole} / {fiteam}) encontrou {credits} credito(s) no corpo de {found} ({forole} / {foteam})."
L.desc_event_finish = "O round durou {minutes}:{seconds}. Havia {alive} jogadore(s) vivos no final."
L.desc_event_game = "Um novo round começou."
L.desc_event_respawn = "{player} foi respawnado."
L.desc_event_rolechange = "{player} mudou seu função para {orole} ({oteam}) para {nrole} ({nteam})."
L.desc_event_selected = "As funções foram selecionadas para todos os {amount} jogadores."
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
L.karma_teamkill_tooltip = "Morte de time"
L.karma_teamhurt_tooltip = "Dano no time"
L.karma_enemykill_tooltip = "Morte de inimigos"
L.karma_enemyhurt_tooltip = "Enemy damaged"
L.karma_cleanround_tooltip = "Limpar rodada"
L.karma_roundheal_tooltip = "Roundheal"
L.karma_unknown_tooltip = "Desconhecido"

-- 2021-05-07
L.header_random_shop_administration = "Configuração randomização da Loja"
L.header_random_shop_value_administration = "Configuração de Balanceamento"

L.shopeditor_name_random_shops = "Ativar loja aleatória"
L.shopeditor_desc_random_shops = [[Loja aleatória quando ativado, dara uma limitação randomicamente para os jogadores com equipamentos disponíveis.
Loja de time forçara todos os jogadores de um time a ter a mesma loja.
Relançamento permitirá você a ter uma nova variação de equipamento nos créditos..]]
L.shopeditor_name_random_shop_items = "Número de equipamentos aleatórios"
L.shopeditor_desc_random_shop_items = "Isso inclui equipamentos, quando está marcado como \"Não randomizar\". Então escolha um número alto para tal."
L.shopeditor_name_random_team_shops = "Ativar loja de times"
L.shopeditor_name_random_shop_reroll = "Ativar habilidade de rolagem"
L.shopeditor_name_random_shop_reroll_cost = "Custo por rolagem"
L.shopeditor_name_random_shop_reroll_per_buy = "Rolar automaticamente após compra"

-- 2021-06-04
L.header_equipment_setup = "Configurar Equipamentot"
L.header_equipment_value_setup = "Configuração de Balanceamento"

L.equipmenteditor_name_not_buyable = "Equipamento comprável"
L.equipmenteditor_desc_not_buyable = "Se desativado, o equipamento não irá mostrar na loja. Papéis que comprarem, terão o equipamento ainda."
L.equipmenteditor_name_not_random = "Sempre disponível na loja"
L.equipmenteditor_desc_not_random = "Se habilitado, o equipamento vai estar sempre disponível na loja. Isso relevara na randomização da loja."
L.equipmenteditor_name_global_limited = "Limitar na quantia global"
L.equipmenteditor_desc_global_limited = "Se houver limitação global, o item será apenas comprado como único na rodada ativa."
L.equipmenteditor_name_team_limited = "Limite na quantia por time"
L.equipmenteditor_desc_team_limited = "Se ativado, o time terá equipamento limitado, só poderá ser comprado apenas uma vez por time."
L.equipmenteditor_name_player_limited = "Limite de quantia por jogador"
L.equipmenteditor_desc_player_limited = "Se ativado, o equipamento será limitado por jogador, que poderá ser comprado apenas uma vez por rodada."
L.equipmenteditor_name_min_players = "Limite minino para seleção de jogador"
L.equipmenteditor_name_credits = "Preço por créditos"

-- 2021-06-08
L.equip_not_added = "não adicionado"
L.equip_added = "adicionado"
L.equip_inherit_added = "adicionado (herdar)"
L.equip_inherit_removed = "removido (herdar)"

-- 2021-06-09
L.layering_not_layered = "Sem camada"
L.layering_layer = "Camada {layer}"
L.header_rolelayering_role = "{role} camada"
L.header_rolelayering_baserole = "Base da camada da função"
L.submenu_administration_rolelayering_title = "Camada da função"
L.header_rolelayering_info = "Informação da função da camada"
L.help_rolelayering_roleselection = "O processo de seleção de papéis é dividido em duas etapas. Na primeira passagem, as funções básicas são distribuídas. As funções base são inocentes, traidores e aqueles listados na caixa 'base role layer' abaixo. A segunda passagem é usada para atualizar essas funções básicas para uma subfunção."
L.help_rolelayering_layers = "De cada camada, apenas uma função é selecionada. Primeiro, as funções das camadas personalizadas são distribuídas a partir da primeira camada até a última ser alcançada ou nenhuma outra função pode ser atualizada. O que acontecer primeiro. Se os slots atualizáveis ainda estiverem disponíveis, as funções sem camadas também serão distribuídas."
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
--L.spawneditor_ammo_edit = "Hold to edit ammo auto spawn on weapon spawns"

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

--L.spawn_weapon_ammo = " (Ammo: {ammo})"

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
--L.label_dynamic_spawns_global_enable = "Enable custom spawns for all maps"

--L.header_equipment_weapon_spawn_setup = "Weapon Spawn Settings"

--L.help_spawn_editor_info = [[
-- The spawn editor is used to place, remove and edit spawns in the world. These spawns are for weapons, ammunition and players.

-- These spawns are saved in files located in 'data/ttt/weaponspawnscripts/'. They can be deleted for a hard reset. The initial spawn files are created from spawns found on the map and in the original TTT weapon spawn scripts. Pressing the reset button always reverts to this state.

-- It should be noted that this spawn system uses dynamic spawns. This is most interesting for weapons because it no longer defines a specific weapon, but a type of weapons. For example instead of a TTT shotgun spawn, there is now a general shotgun spawn where any weapon defined as shotgun can spawn. The spawn type for each weapon can be set in the equipment editor. This makes it possible for any weapon to spawn on the map, or to disable certain default weapons.

-- Keep in mind that many changes only take effect after a new round has started.]]
--L.help_spawn_editor_enable = "On some maps it might be advised to use the original spawns found on the map without replacing them with the dynamic system. Disabling this checkbox only disables it for the currently active map. The dynamic system will still be used for every other map."
--L.help_spawn_editor_hint = "Hint: To leave the spawn editor, reopen the gamemode menu."
--L.help_spawn_editor_spawn_amount = [[
-- There currently are {weapon} weapon spawns, {ammo} ammunition spawns and {player} player spawns on this map. Click 'start spawn edit' to change this amount.

--{weaponrandom}x Random weapon spawn
--{weaponmelee}x Melee weapon spawn
--{weaponnade}x Grenade weapon spawn
--{weaponshotgun}x Shotgun weapon spawn
--{weaponheavy}x Heavy weapon spawn
--{weaponsniper}x Sniper weapon spawn
--{weaponpistol}x Pistol weapon spawn
--{weaponspecial}x Special weapon spawn

--{ammorandom}x Random ammo spawn
--{ammodeagle}x Deagle ammo spawn
--{ammopistol}x Pistol ammo spawn
--{ammomac10}x Mac10 ammo spawn
--{ammorifle}x Rifle ammo spawn
--{ammoshotgun}x Shotgun ammo spawn

--{playerrandom}x Random player spawn]]

--L.equipmenteditor_name_auto_spawnable = "Equipment spawns randomly in world"
--L.equipmenteditor_name_spawn_type = "Select spawn type"
--L.equipmenteditor_desc_auto_spawnable = [[
-- The TTT2 spawn system allows every weapon to spawn in the world. By default only weapons marked as 'AutoSpawnable' by the creator will spawn in the world, however these settings can be changed from within this menu.

-- Most of the equipment is set to 'special weapon spawns' by default. This means that equipment only spawns on random weapon spawns. However it is possible to place special weapon spawns in the world or change the spawn type here to use other existing spawn types.]]

--L.pickup_error_inv_cached = "You cannot pick this up right now because your inventory is cached."

-- 2021-09-02
--L.submenu_administration_playermodels_title = "Player Models"
--L.header_playermodels_general = "General Player Model Settings"
--L.header_playermodels_selection = "Select Player Model Pool"

--L.label_enforce_playermodel = "Enforce role player model"
--L.label_use_custom_models = "Use a random selected player model"
--L.label_prefer_map_models = "Prefer map specific models over default models"
--L.label_select_model_per_round = "Select a new random model each round (only on mapchange if disabled)"

--L.help_prefer_map_models = [[
-- Some maps define their own player models. By default these models have a higher priority then the models that are automatically assigned. By disabling this setting, map specific models are disabled.

-- Role specific models always have a higher priority and are unaffected by this setting.]]
--L.help_enforce_playermodel = [[
-- Some roles have custom player models. This can be disabled which can be relevant for compatibility with some player model selectors.
-- Random default models can still be selected, if this setting is disabled.]]
--L.help_use_custom_models = [[
-- By default only the CSS Phoenix player model is assigned to all players. By enabling this option however it is possible to select a player model pool. With this setting enabled each player will still be assigned the same player model, however it is a random model from the defined model pool.

-- This selection of models can be extended by installing more player models.]]

-- 2021-10-06
--L.menu_server_addons_title = "Server Addons"
--L.menu_server_addons_description = "Serverwide admin only settings for addons."

--L.tooltip_finish_score_penalty_alive_teammates = "Alive teammates penalty: {score}"
--L.finish_score_penalty_alive_teammates = "Alive teammates penalty:"
--L.tooltip_kill_score_suicide = "Suicide: {score}"
--L.kill_score_suicide = "Suicide:"
--L.tooltip_kill_score_team = "Team kill: {score}"
--L.kill_score_team = "Team kill:"

-- 2021-10-09
--L.help_models_select = [[
--Left click on the models to add them to the player model pool. Left click again to remove them. Right clicking toggles between enabled and disabled detective hats for the focused model.

-- The small indicator in the top left shows if the player model has a headshot hitbox. The icon below shows if this model is applicable for a detective hat.]]

--L.menu_roles_title = "Role Settings"
--L.menu_roles_description = "Set up the spawning, equipment credits and more."

--L.submenu_administration_roles_general_title = "General Role Settings"

--L.header_roles_info = "Role Information"
--L.header_roles_selection = "Role Selection Parameters"
--L.header_roles_tbuttons = "Role Traitor Buttons"
--L.header_roles_credits = "Role Equipment Credits"
--L.header_roles_additional = "Additonal Role Settings"
--L.header_roles_reward_credits = "Reward Equipment Credits"

--L.help_roles_default_team = "Default team: {team}"
--L.help_roles_unselectable = "This role is not selectable. This means it is not considered in the role selection. Most of the times this means that this is a role that is manually applied during the round through an event like a revival, a sidekick deagle or something similar."
--L.help_roles_selectable = "This role is selectable. This means if all criteria is met, this role is considered in the role selection process."
--L.help_roles_credits = "Equipment credits are used to buy equipment in the shop. It mostly makes sense to give only those roles that have access to the shop credits. However since it is possible to loot credits from corpses, it could also be an idea to give starting credits to roles as a reward for their killer."
--L.help_roles_selection_short = "The role distribution per player defines the percentage of players that are assigned this role. If for example the value is set to '0.2' every fifth player receives this role."
--L.help_roles_selection = [[
-- The role distribution per player defines the percentage of players that are assigned this role. If for example the value is set to '0.2' every fifth player receives this role. This also means that at least 5 players are needed for this role to be selected at all.
-- Keep in mind that all of this only applies if the role is considered for selection.

-- The aforementioned role distribution has a special integration with the lower limit of players. If the role is considered for selection and the minimum value is below the value given by the distribution factor, but the amount of players is equal or greater than the lower limit, a single player can still receive this role. The distribution setting then holds true again for the second player to receive this role.]]
--L.help_roles_award_info = "Some roles (if enabled in their credits settings) receive equipment credits if a certain percentage of adversaries has died. Those values can be tweaked here."
--L.help_roles_award_pct = "When this percentage of other players are dead, players are awarded more credits."
--L.help_roles_award_repeat = "Whether the credit award is handed out multiple times. If for example you set the percentage to '0.25', and enable this, players will be awarded credits at '25%' killed, '50%' killed, and '75%' killed."
--L.help_roles_advanced_warning = "WARNING: These are advanced settings that can completely mess up your role selection. When in doubt keep all values at '0'. This value means that no limits are applied and the role selection is trying to assign as many roles as possible."
--L.help_roles_max_roles = [[
-- The roles category contains every role in TTT2. By default there is no limit on how many different roles can be assigned. However here are two different ways to limit them.

-- 1. Limit them by a fixed amount.
-- 2. Limit them by a percentage.

-- The latter is only used if the fixed amount is '0' and sets an upper limit based on the set percentage of available players.]]
--L.help_roles_max_baseroles = [[
-- Baseroles are only those role others inherit from. For example the Innocent role is a baserole, while a Pharaoh is a sub role of this role. By default there is no limit on how many different baseroles can be assigned. However here are two different ways to limit them.

-- 1. Limit them by a fixed amount.
-- 2. Limit them by a percentage.

-- The latter is only used if the fixed amount is '0' and sets an upper limit based on the set percentage of available players.]]

--L.label_roles_enabled = "Enable role"
--L.label_roles_min_inno_pct = "Innocent distribution per player"
--L.label_roles_pct = "Role distribution per player"
--L.label_roles_max = "Upper limit of players assigned for this role"
--L.label_roles_random = "Chance this role is selected"
--L.label_roles_min_players = "Lower limit of players to consider selection"
--L.label_roles_tbutton = "Role can use Traitor buttons"
--L.label_roles_credits_starting = "Starting credits"
--L.label_roles_credits_award_pct = "Credit reward percentage"
--L.label_roles_credits_award_size = "Credit reward size"
--L.label_roles_credits_award_repeat = "Credit reward repeat"
--L.label_roles_newroles_enabled = "Enable custom roles"
--L.label_roles_max_roles = "Upper role limit"
--L.label_roles_max_roles_pct = "Upper role limit by percentage"
--L.label_roles_max_baseroles = "Upper baserole limit"
--L.label_roles_max_baseroles_pct = "Upper baserole limit by percentage"
--L.label_detective_hats = "Enable hats for policing roles like the Detective (if player model allows hat)"

--L.ttt2_desc_innocent = "An Innocent has no special abilities. They have to find the evil ones among the terrorists and kill them. But they have to be careful not to kill their fellow team mates."
--L.ttt2_desc_traitor = "The Traitor is the adversary of the Innocent. They have an equipment menu with which they are be able to buy special equipment. They have to kill everyone but their team mates."
--L.ttt2_desc_detective = "The Detective is the one whom the Innocents can trust. But who even is an Innocent? The mighty Detective has to find all the evil terrorists. The equipment in their shop may help them with this task."

-- 2021-10-10
--L.button_reset_models = "Reset Player Models"

-- 2021-10-13
--L.help_roles_credits_award_kill = "Another way of gaining credits is by killing high value players with a 'public role' such as a Detective. If the killer's role has this enabled, they gain the below defined amount of credits."
--L.help_roles_credits_award = [[
-- There are two different ways to be awarded credits in base TTT2:

-- 1. If a certain percentage of the enemy team is dead, the whole team is awarded credits.
-- 2. If a player killed a high value play with a 'public role' such as a Detective, the killer is awarded.

-- Please note that this still can be enabled/disabled for every role even if the whole team is awarded. If for example team Innocent is awarded, but the Innocent role has this disabled, only the Detective will receive their credits.
-- The balancing values for this feature can be set in 'Administration' -> 'General Role Settings'.]]
--L.help_detective_hats = [[
-- Policing roles such as the Detective may wear hats to show their authority. They lose them on death or if damaged at the head.

-- Some player models do not support hats by default. You can change this in 'Administration' -> 'Player Models']]

--L.label_roles_credits_award_kill = "Credit reward amount for kill"
--L.label_roles_credits_dead_award = "Enable credits award for certain percentage of dead enemies"
--L.label_roles_credits_kill_award = "Enable credits award for high value player kill"
--L.label_roles_min_karma = "Lower limit of Karma to consider selection"

-- 2021-11-07
--L.submenu_administration_administration_title = "Administration"
--L.submenu_administration_voicechat_title = "Voicechat / Textchat"
--L.submenu_administration_round_setup_title = "Round Setup"
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
--L.header_voicechat_general = "General Voicechat Settings"
--L.header_voicechat_battery = "Voicechat Battery"
--L.header_voicechat_locational = "Locational Voicechat"
--L.header_playersettings_plyspawn = "Player Spawn Settings"
--L.header_round_setup_prep = "Round: Preparing"
--L.header_round_setup_round = "Round: Active"
--L.header_round_setup_post = "Round: Post"
--L.header_round_setup_map_duration = "Map Session"
--L.header_textchat = "Textchat"
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

--L.help_killer_dna_range = "When a player is killed by another player a DNA fingerprint is left on their body. The max range convar defines the maximum distance in hammer units for DNA samples to be left. If the killer is further away, then no sample is left at the corpse."
--L.help_killer_dna_basetime = "The basetime in seconds until a DNA sample is decayed. A factor of the squared killer distance is substracted from this basetime."
--L.help_dna_radar = "The TTT2 DNA scanner shows the exact distance and direction of the selected DNA sample if equipped. However, there is also a classic DNA scanner mode that updates the selected sample with an in-world rendering everytime the cooldown has passed."
--L.help_idle = "The idle mode is used to move idle players into a forced spectator mode. To leave this mode again, they have to disable 'enforce spectator mode' in their 'gameplay' settings."
--L.help_namechange_kick = [[
-- If a player changes their name during a round, this can be abused to evade being killed. Therefore it is prohibited to change the nickname during an active round.

-- If the bantime is greater than 0, the player will be unable to reconnect to the server until that time has passed.]]
--L.help_damage_log = "Each time a player is damaged, a damage log entry is added to the console if enabled. This can also be stored to disk after a round has ended. The file is located at 'data/terrortown/logs/'"
--L.help_spawn_waves = [[
-- If this variable is set to 0, all players are spawned at once. For servers with huge amounts of players, it can be beneficial to spawn the players in waves. The spawn wave interval is the time between each spawn wave. A spawn wave always spawns as many players as there are valid spawn points.

-- Note: Make sure that the preparing time is long enough for the desired amount of spawn waves.]]
--L.help_voicechat_battery = [[
-- Voicechatting with enabled voice chat battery reduces this meter. When it's empty the player can't voicechat and has to wait for a few seconds for it to recharge. This can help to prevent excessive voicechat usage.

-- Note: 'Tick' refers to a game tick, ie. 1/66th of a second.]]
--L.help_ply_spawn = "Player parameters that are used on player (re-)spawn."
--L.help_haste_mode = [[
-- Haste mode balances the game by increasing the round time with every dead player. Only roles that see missing in action players can see the real round time. Every other role can only see the haste mode starting time.

-- If haste mode is enabled, the fixed round time is ignored.]]
--L.help_round_limit = "After one of the set limit conditions is met, a mapchange is triggered."
--L.help_armor_balancing = "The following values can be used to balance the armor."
--L.help_item_armor_classic = "If classic armor mode is enabled, only the previous settings matter. Classic armor mode means that a player can only buy armor once in a round and that this armor blocks 30% of the incoming bullet and crowbar damage until they die."
--L.help_item_armor_dynamic = [[
-- Dynamic armor is the TTT2 approach to make armor more interesting. The amount of armor that can be bought is now unlimited and the armor value stacks. Getting damaged decreases the armor value. The armor value per baught armor item is set in the 'Equipment Settings' of said item.

-- When taking damage, a certain percentage of this damage is converted into armor damage, a different percentage is still applied to the player and the rest vanishes.

-- If reinforced armor is enabled, the damage applied to the player is decreased by 15% as long as the armor value is above the reinforcement threshold.]]
--L.help_sherlock_mode = "The sherlock mode is the classic TTT mode. If the sherlock mode is disabled, dead bodies can not be confirmed, the scoreboard shows everyone as alive and the spectators can talk to the living players."
--L.help_prop_possession = [[
-- Prop possession can be used by spectators to possess props lying in the world and use the slowly recharging 'punch-o-meter' to move said prop around.

-- The maximum value of the 'punch-o-meter' consists of a possession base value, where the kills/deaths difference clamped inbetween two defined limits is added. The meter slowly recharges over time. The set recharge time is the time needed to recharge a single point in the 'punch-o-meter'.]]
--L.help_karma = "Karma is used to reduce random killing. Players start with a certain amount of Karma, and lose it when they damage/kill team mates. The amount they lose is dependent on the Karma of the person they hurt or killed. Lower Karma reduces damage given."
--L.help_karma_strict = "If strict Karma is enabled, the damage penalty increases more quickly as Karma goes down. When it is off, the damage penalty is very low when people stay above 800. Enabling strict mode makes Karma play a larger role in discouraging any unnecessary kills, while disabling it results in a more “loose” game where Karma only hurts players who constantly teamkill."
--L.help_karma_max = "Setting the value of the max Karma above 1000 doesn't give a damage bonus to players with more that 1000 Karma. It can be used as a Karma buffer."
--L.help_karma_ratio = "The ratio of the damage that is used to compute how much of the victim's Karma is subtracted from the attacker's if both are in the same team. If a team kill happens, a further penalty is applied."
--L.help_karma_traitordmg_ratio = "The ratio of the damage that is used to compute how much of the victim's Karma is subtracted from the attacker's if both are in different teams. If a team kill happens, a further bonus is applied."
--L.help_karma_bonus = "There are also two different passive ways to gain Karma during a round. First a round heal is applied to every player. Then a secondary clean bonus is given if no teammates were hurt or killed."
--L.help_karma_clean_half = [[
-- When a player's Karma is above the starting level (meaning the Karma max has been configured to be higher than that), all their Karma increases will be reduced based on how far their Karma is above that starting level. So it goes up slower the higher it is.

-- This reduction goes in a curve of exponential decay: initially it's fast, and it slows down as the increment gets smaller. This convar sets at what point the bonus has been halved (so the half-life). With the default value of 0.25, if the starting amount of Karma is 1000 and the max 1500, and a player has Karma 1125 ((1500 - 1000) * 0.25 = 125), then his clean round bonus will be 30 / 2 = 15. So to make the bonus go down faster you’d set this convar lower, to make it go down slower you’d increase it towards 1.]]
--L.help_max_slots = "Sets the maximum amount of weapons per slot. '-1' means that there is no limit."
--L.help_item_armor_value = "This is the armor value given by a the armor item in dynamic mode. If classic mode is enabled (see 'Administration' -> 'Player Settings') then every value greater than 0 is counted as existing armor."

--L.label_killer_dna_range = "Max kill range to leave DNA"
--L.label_killer_dna_basetime = "Sample life base time"
--L.label_dna_scanner_slots = "DNA sample slots"
--L.label_dna_radar = "Enable classic DNA scanner mode"
--L.label_dna_radar_cooldown = "DNA scanner cooldown"
--L.label_radar_charge_time = "Recharge time after a radar sample"
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
--L.label_ragdoll_pinning = "Enable ragdoll pinning for non-Innocent roles"
--L.label_ragdoll_pinning_innocents = "Enable ragdoll pinning for Innocent roles"
--L.label_weapon_carrying = "Enable weapon carrying"
--L.label_weapon_carrying_range = "Weapon carry range"
--L.label_prop_carrying_force = "Prop pickup force"
--L.label_teleport_telefrags = "Kill blocking player(s) when teleporting (telefrag)"
--L.label_allow_discomb_jump = "Allow disco jump for grenade thrower"
--L.label_spawn_wave_interval = "Spawn wave interval in seconds"
--L.label_voice_enable = "Enable voicechat"
--L.label_voice_drain = "Enable the voicechat battery feature"
--L.label_voice_drain_normal = "Drain per tick for normal players"
--L.label_voice_drain_admin = "Drain per tick for admins and public policing roles"
--L.label_voice_drain_recharge = "Recharge rate per tick of not voicechatting"
--L.label_locational_voice = "Enable locational 3D voicechat sound for living players"
--L.label_armor_on_spawn = "Player armor on (re-)spawn"
--L.label_prep_respawn = "Enable instant respawn during preparing phase"
--L.label_preptime_seconds = "Preparing time in seconds"
--L.label_firstpreptime_seconds = "First preparing time in seconds"
--L.label_roundtime_minutes = "Fixed round time in minutes"
--L.label_haste = "Enable haste mode"
--L.label_haste_starting_minutes = "Haste mode starting time in minutes"
--L.label_haste_minutes_per_death = "Haste reward in minutes per death"
--L.label_posttime_seconds = "Postround time in seconds"
--L.label_round_limit = "Upper limit of rounds"
--L.label_time_limit_minutes = "Upper limit of playtime in minutes"
--L.label_nade_throw_during_prep = "Enable nade throwing during preparing time"
--L.label_postround_dm = "Enable deathmatch after round ended"
--L.label_session_limits_enabled = "Enable session limits"
--L.label_spectator_chat = "Enable spectators chatting with everybody"
--L.label_lastwords_chatprint = "Print last words to chat if killed while typing"
--L.label_identify_body_woconfirm = "Identify corpse without pressing the 'confirm' button"
--L.label_announce_body_found = "Announce that a body was found"
--L.label_confirm_killlist = "Announce kill list of confirmed corpse"
--L.label_inspect_detective_only = "Limit corpse inspection to policing roles"
--L.label_confirm_detective_only = "Limit corpse confirmation to policing roles"
--L.label_dyingshot = "Shoot on death if in ironsights [experimental]"
--L.label_armor_block_headshots = "Enable armor blocking headshots"
--L.label_armor_block_blastdmg = "Enable armor blocking blast damage"
--L.label_armor_dynamic = "Enable dynamic armor"
--L.label_armor_value = "Armor given by the armor item"
--L.label_armor_damage_block_pct = "Damage percentage taken by armor"
--L.label_armor_damage_health_pct = "Damage percentage taken by player"
--L.label_armor_enable_reinforced = "Enable reinforced armor"
--L.label_armor_threshold_for_reinforced = "Reinforced armor threshold"
--L.label_sherlock_mode = "Enable sherlock mode"
--L.label_highlight_admins = "Highlight server admins"
--L.label_highlight_dev = "Highlight TTT2 developer"
--L.label_highlight_vip = "Highlight VIP"
--L.label_highlight_addondev = "Highlight TTT2 addon developer"
--L.label_highlight_supporter = "Highlight other supporters"
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
--L.label_doors_prop_health = "Door prop health"
--L.label_minimum_players = "Minimum player amount to start round"
--L.label_karma = "Enable Karma"
--L.label_karma_strict = "Enable strict Karma"
--L.label_karma_starting = "Starting Karma"
--L.label_karma_max = "Maximum Karma"
--L.label_karma_ratio = "Penalty ratio for team damage"
--L.label_karma_kill_penalty = "Kill penalty for team kill"
--L.label_karma_round_increment = "Round heal"
--L.label_karma_clean_bonus = "Clean round bonus"
--L.label_karma_traitordmg_ratio = "Bonus ratio for other team damage"
--L.label_karma_traitorkill_bonus = "Kill bonus for other team kill"
--L.label_karma_clean_half = "Clean bonus reduction"
--L.label_karma_persist = "Karma persists over map changes"
--L.label_karma_low_autokick = "Automatically kick players with low Karma"
--L.label_karma_low_amount = "Low Karma threshold"
--L.label_karma_low_ban = "Ban picked players with low Karma"
--L.label_karma_low_ban_minutes = "Ban time in minutes"
--L.label_karma_debugspam = "Enable debug output to console about Karma changes"
--L.label_max_melee_slots = "Max melee slots"
--L.label_max_secondary_slots = "Max secondary slots"
--L.label_max_primary_slots = "Max primary slots"
--L.label_max_nade_slots = "Max nade slots"
--L.label_max_carry_slots = "Max carry slots"
--L.label_max_unarmed_slots = "Max unarmed slots"
--L.label_max_special_slots = "Max special slots"
--L.label_max_extra_slots = "Max extra slots"
--L.label_weapon_autopickup = "Enable automatic weapon pickup"
--L.label_sprint_enabled = "Enable sprinting"
--L.label_sprint_max = "Max sprinting stamina"
--L.label_sprint_stamina_consumption = "Stamina consumption factor"
--L.label_sprint_stamina_regeneration = "Stamina regeneration factor"
--L.label_sprint_crosshair = "Show crosshair while sprinting"
--L.label_crowbar_unlocks = "Primary attack can be used as interaction (i.e. unlocking)"
--L.label_crowbar_pushforce = "Crowbar push force"

-- 2022-07-02
--L.header_playersettings_falldmg = "Fall Damage Settings"

--L.label_falldmg_enable = "Enable fall damage"
--L.label_falldmg_min_velocity = "Minimum velocity threshold for fall damage to occur"
--L.label_falldmg_exponent = "Exponent to increase fall damage in relation to velocity"

--L.help_falldmg_exponent = [[
-- This value modifies how exponentially fall damage is increased with the speed the player hits the ground at.

-- Take care when altering this value. Setting it too high can make even the smallest falls lethal, while setting it too low will allow players to fall from extreme heights and suffer little to no damage.]]
