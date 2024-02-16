-- French language strings

local L = LANG.CreateLanguage("fr")

-- Compatibility language name that might be removed soon.
-- the alias name is based on the original TTT language name:
-- https://github.com/Facepunch/garrysmod/blob/master/garrysmod/gamemodes/terrortown/gamemode/lang/french.lua
L.__alias = "français"

L.lang_name = "Français (French)"

-- General text used in various places
L.traitor = "Traitre"
L.detective = "Détective"
L.innocent = "Innocent"
L.last_words = "Derniers mots"

L.terrorists = "Terroristes"
L.spectators = "Spectateurs"

L.nones = "Pas de Team"
L.innocents = "Team des Innocents"
L.traitors = "Team des Traitres"

-- Round status messages
L.round_minplayers = "Pas assez de joueurs pour commencer un nouveau round..."
L.round_voting = "Un vote est en cours, le round est retardé de {num} secondes..."
L.round_begintime = "Un nouveau round commencera dans {num} secondes. Préparez-vous."
L.round_selected = "Les Traitres ont été choisis."
L.round_started = "Le round a commencé!"
L.round_restart = "Un admin a redémarré le round."

L.round_traitors_one = "Traitre, vous êtes seul."
L.round_traitors_more = "Traitres, voici vos alliés: {names}"

L.win_time = "Temps écoulé. Les Traitres ont perdu."
L.win_traitors = "Les Traitres ont gagné!"
L.win_innocents = "Les Traitres ont été vaincus!"
L.win_nones = "Les Abeilles ont gagné!"
L.win_showreport = "Regardons le rapport du round {num} secondes."

--L.limit_round = "Round limit reached. The next map will load soon."
--L.limit_time = "Time limit reached. The next map will load soon."
L.limit_left = "Il reste {num} round(s) ou {time} minutes avant que la carte change."

-- Credit awards
L.credit_all = "Vous êtes récompensés de {num} crédit(s) pour vos performances."
L.credit_kill = "Vous avez reçu {num} crédit(s) pour avoir tué un {role}."

-- Karma
L.karma_dmg_full = "Votre Karma est à {amount}, vous infligerez donc des dégâts normaux ce round!"
L.karma_dmg_other = "Votre Karma est à {amount}. De ce fait, tous les dégâts que vous infligerez seront réduits de {num}%"

-- Body identification messages
L.body_found = "{finder} à trouvé le corps de {victim}. {role}"
L.body_found_team = "{finder} à trouvé le corps de {victim}. {role} ({team})"

-- The {role} in body_found will be replaced by one of the following:
L.body_found_traitor = "C'était un Traitre!"
L.body_found_det = "C'était un Détective."
L.body_found_inno = "C'était un Innocent."

L.body_call = "{player} appelle un Détective sur le corps de {victim}!"
L.body_call_error = "Veuillez identifier le corps avant d'appeler un Détective!"

L.body_burning = "Aie! Ce cadavre est en feu!"
L.body_credits = "Vous avez trouvé {num} crédit(s) sur le corps!"

-- Menus and windows
L.close = "Fermer"
L.cancel = "Annuler"

-- For navigation buttons
L.next = "Suivant"
L.prev = "Précédent"

-- Equipment buying menu
L.equip_title = "Équipement"
L.equip_tabtitle = "Commander de l'Équipement"

L.equip_status = "Statut de la commande"
L.equip_cost = "Il vous reste {num} crédit(s)."
L.equip_help_cost = "Chaque équipement que vous achetez coûte 1 crédit."

L.equip_help_carry = "Vous pouvez acheter que si l’emplacement pour l'objet est libre."
L.equip_carry = "Vous pouvez porter cet objet."
L.equip_carry_own = "Vous portez déjà cet objet."
L.equip_carry_slot = "Vous avez déjà une arme dans l’emplacement {slot}."
L.equip_carry_minplayers = "Il n'y a pas assez de joueurs sur le serveur pour activer cette arme."

L.equip_help_stock = "Certains objets ne peuvent être achetés qu'une fois par round."
L.equip_stock_deny = "Cet objet n'est plus en stock."
L.equip_stock_ok = "Cet objet est en stock."

L.equip_custom = "Objet ajouté par le serveur."

L.equip_spec_name = "Nom"
L.equip_spec_type = "Type"
L.equip_spec_desc = "Description"

L.equip_confirm = "Acheter"

-- Disguiser tab in equipment menu
L.disg_name = "Déguisement"
L.disg_menutitle = "Contrôle du déguisement"
L.disg_not_owned = "Vous n'avez pas de Déguisement!"
L.disg_enable = "Activer le déguisement"

L.disg_help1 = "Lorsque votre déguisement est actif, votre nom, santé et karma ne sont pas visibles quand quelqu'un vous regarde. De plus, vous n'apparaîtrez pas sur le radar du Détective."
L.disg_help2 = "Appuyez sur Entrée du Pavé-Numérique pour activer/désactiver le déguisement sans le menu. Vous pouvez aussi choisir une autre touche en appuyant sur F1 -> Configuration."

-- Radar tab in equipment menu
L.radar_name = "Radar"
L.radar_menutitle = "Contrôle du radar"
L.radar_not_owned = "Vous n'avez pas de Radar!"
L.radar_scan = "Scanner"
L.radar_auto = "Scanner à répétition"
L.radar_help = "Les résultats du scan restent pendant {num} secondes, après cela le Radar devra recharger et pourra être utilisé de nouveau."
L.radar_charging = "Votre Radar charge!"

-- Transfer tab in equipment menu
L.xfer_name = "Transfert"
L.xfer_menutitle = "Transférer des crédits"
L.xfer_send = "Envoyer un crédit"

L.xfer_no_recip = "Récepteur non-valide, transfert annulé."
L.xfer_no_credits = "Pas assez de crédit pour le transfert."
L.xfer_success = "Transfert de crédits vers {player} complété."
L.xfer_received = "{player} vous a donné {num} crédit."

-- Radio tab in equipment menu
L.radio_name = "Radio"
L.radio_help = "Appuyez sur un bouton pour que votre Radio joue ce son."
L.radio_notplaced = "Vous devez placer la Radio pour la faire jouer un son."

-- Radio soundboard buttons
L.radio_button_scream = "Cri d'agonie"
L.radio_button_expl = "Explosion"
L.radio_button_pistol = "Tir de Pistolet"
L.radio_button_m16 = "Tir de M16"
L.radio_button_deagle = "Tir de Deagle"
L.radio_button_mac10 = "Tir de MAC10"
L.radio_button_shotgun = "Tir de fusil à pompe"
L.radio_button_rifle = "Tir de fusil de sniper"
L.radio_button_huge = "Tir de H.U.G.E"
L.radio_button_c4 = "Bip de C4"
L.radio_button_burn = "Bruits de feu"
L.radio_button_steps = "Bruits de pas"

-- Intro screen shown after joining
L.intro_help = "Si vous êtes nouveau, appuyez sur F1 pour lire les instructions!"

-- Radiocommands/quickchat
L.quick_title = "Touches de Tchat-rapide"

L.quick_yes = "Oui."
L.quick_no = "Non."
L.quick_help = "À l'aide!"
L.quick_imwith = "Je suis avec {player}."
L.quick_see = "Je vois {player}."
L.quick_suspect = "{player} est suspect."
L.quick_traitor = "{player} est un Traitre!"
L.quick_inno = "{player} est innocent."
L.quick_check = "Quelqu'un est encore en vie?"

-- {player} in the quickchat text normally becomes a player nickname, but can
-- also be one of the below.  Keep these lowercase.
L.quick_nobody = "Personne"
L.quick_disg = "Quelqu'un de déguisé"
L.quick_corpse = "un corps non-identifié"
L.quick_corpse_id = "le corps de {player}"

-- Scoreboard
L.sb_playing = "Vous jouez sur..."
L.sb_mapchange = "On change de carte dans {num} round(s) ou dans {time}"
--L.sb_mapchange_disabled = "Session limits are disabled."

L.sb_mia = "Portés disparus"
L.sb_confirmed = "Morts Confirmés"

L.sb_ping = "Ping"
L.sb_deaths = "Morts"
L.sb_score = "Score"
L.sb_karma = "Karma"

L.sb_info_help = "Si vous cherchez le corps de ce joueur, vous aurez les détails de sa mort."

L.sb_tag_friend = "AMI"
L.sb_tag_susp = "SUSPECT"
L.sb_tag_avoid = "A ÉVITER"
L.sb_tag_kill = "A TUER"
L.sb_tag_miss = "PERDU"

-- Equipment actions, like buying and dropping
L.buy_no_stock = "Cette arme est en rupture de stock: vous l'avez déjà acheté ce round."
L.buy_pending = "Vous avez déjà une commande en attente, attendez de la recevoir d'abord."
L.buy_received = "Vous avez reçu votre équipement spécial."

L.drop_no_room = "Il n'y a pas la place pour jeter votre arme!"

L.disg_turned_on = "Déguisement activé!"
L.disg_turned_off = "Déguisement désactivé."

-- Equipment item descriptions
L.item_passive = "Objet à effet passif"
L.item_active = "Objet à effet actif"
L.item_weapon = "Arme"

L.item_armor = "Armure"
L.item_armor_desc = [[
Réduit les dommages causés par les balles, les flammes et les explosions. Diminue avec le temps.

Il peut être acheté plusieurs fois. Après avoir atteint une valeur d'armure spécifique, l'armure devient plus résistante.]]

L.item_radar = "Radar"
L.item_radar_desc = [[
Vous laisse scanner des formes de vie.

Commence des scans automatiques dès que vous l'achetez. Configurez-le dans l'onglet Radar de ce menu.]]

L.item_disg = "Déguisement"
L.item_disg_desc = [[
Cache votre ID. Évite de paraître comme la dernière personne vue avant de mourir.

Activer/Désactiver le déguisement vers l'onglet Déguisement de ce menu ou appuyer sur Numpad Enter.]]

-- C4
L.c4_disarm_warn = "Un explosif C4 que vous avez planté a été désamorcé."
L.c4_armed = "Vous avez amorcé le C4 avec succès."
L.c4_disarmed = "Vous avez désamorcé le C4 avec succès."
L.c4_no_room = "Vous n'avez pas la place pour ce C4."

L.c4_desc = "Explosif surpuissant à retardement.Utiliser le avec précaution."

L.c4_arm = "Amorcer le C4"
L.c4_arm_timer = "Minuteur"
L.c4_arm_seconds = "Secondes avant détonation:"
L.c4_arm_attempts = "Pendant le désamorçage, {num} des 6 fils va instantanément faire exploser le C4 quand il sera coupé."

L.c4_remove_title = "Retrait"
L.c4_remove_pickup = "Ramasser le C4"
L.c4_remove_destroy1 = "Détruire le C4"
L.c4_remove_destroy2 = "Confirmer: destruction"

L.c4_disarm = "Désamorcer le C4"
L.c4_disarm_cut = "Couper le fil {num}"

L.c4_disarm_t = "Coupez un fil pour désamorcer la bombe. En tant que Traitre, tous les fils fonctionneront. Les innocents n'ont pas cette chance !"
L.c4_disarm_owned = "Coupez un fil pour désamorcer la bombe. C'est votre bombe, donc tous les fils fonctionneront."
L.c4_disarm_other = "Coupez un fil pour désamorcer la bombe. Si vous vous trompez, ça va péter!"

L.c4_status_armed = "ARMÉE"
L.c4_status_disarmed = "DÉSARMÉE"

-- Visualizer
L.vis_name = "Visualiseur"

L.vis_desc = [[
Dispositif de visualisation de scène de crime.

Analyse un corps pour montrer comment la victime a été tuée, mais seulement s'il est mort d'un coup de feu.]]

-- Decoy
L.decoy_name = "Leurre"
L.decoy_broken = "Votre leurre a été détruit!"

L.decoy_short_desc = "Ce leurre montre un faux signal radar visible par les autres teams"
L.decoy_pickup_wrong_team = "Vous ne pouvez pas le ramasser, car il appartient à une autre team"

L.decoy_desc = [[
Montre un faux signe sur le radar des autres teams, et fait que leur scanner ADN montre la position du leurre s'il cherche le vôtre.]]

-- Defuser
L.defuser_name = "Kit de désamorçage"

L.defuser_desc = [[
Désamorce instantanément un explosif C4.

Usages illimités. Le C4 sera plus visible si vous avez ça sur vous.]]

-- Flare gun
L.flare_name = "Pistolet de détresse"

L.flare_desc = [[
Peut-être utilisés pour brûler les corps pour qu'ils ne soient pas trouvés. Munitions limitées

Brûler un corps fait un son distinct.]]

-- Health station
L.hstation_name = "Station de Soins"

L.hstation_broken = "Votre Station de Soins a été détruite!"

L.hstation_desc = [[
Soigne les personnes qui l'utilisent.

Recharge lente. Tout le monde peut l'utiliser, et elle peut être endommagée. On peut en extraire des échantillons ADN de ses utilisateurs.]]

-- Knife
L.knife_name = "Couteau"
L.knife_thrown = "Couteau lancé"

L.knife_desc = [[
Tue les cibles blessées sur-le-champ et sans faire de bruit, mais à usage unique.

Peut-être lancé avec l'alt-fire.]]

-- Poltergeist
L.polter_desc = [[
Plante des pousseurs sur des objets pour les pousser violemment.

Ces éclats d'énergie peuvent frapper les gens à proximité.]]

-- Radio
L.radio_broken = "Votre Radio a été détruite!"

L.radio_desc = [[
Joue des sons pour distraire ou tromper.

Placez la radio quelque part, ensuite jouez des sons depuis l'onglet Radio dans ce menu.]]

-- Silenced pistol
L.sipistol_name = "Pistolet Silencieux"

L.sipistol_desc = [[
Pistolet bas bruit, utilise des munitions de pistolet normales.

Les victimes ne crieront pas quand tuées.]]

-- Newton launcher
L.newton_name = "Lanceur de Newton"

L.newton_desc = [[
Pousse les gens à une distance de sécurité.

Munitions illimitées, mais lent à tirer.]]

-- Binoculars
L.binoc_name = "Jumelles"

L.binoc_desc = [[
Zoomer sur des corps et les identifier de loin.

Usages illimités, mais l'identification prend quelques secondes.]]

-- UMP
L.ump_desc = [[
SMG expérimental qui désoriente les cibles.

Utilise les munitions normales de SMG.]]

-- DNA scanner
L.dna_name = "Scanner ADN"
L.dna_notfound = "Pas d'échantillon ADN trouvé sur la cible."
L.dna_limit = "Limite de stockage atteint. Retirez les vieux échantillons pour en ajouter de nouveaux."
L.dna_decayed = "L'échantillon ADN du tueur s'est décomposé."
L.dna_killer = "Échantillon ADN du tueur récupéré sur le corps!"
--L.dna_duplicate = "Match! You already have this DNA sample in your scanner."
L.dna_no_killer = "L'ADN n'a pas pu être récupérée (le tueur s'est déconnecté?)."
L.dna_armed = "La bombe est amorcée! Désamorcez-la d'abord!"
--L.dna_object = "Collected a sample of the last owner from the object."
L.dna_gone = "Aucun ADN détecté dans la zone."

L.dna_desc = [[
Collectez des échantillons ADN d'objets et utilisez-les pour trouver le propriétaire de cet ADN.

Essayez-le sur des corps tout frais pour récupérer l'ADN du tueur pour le traquer.]]

-- Magneto stick
L.magnet_name = "Magnéto-stick"
L.magnet_help = "{primaryfire} pour attacher le corps sur cette surface."

-- Grenades and misc
L.grenade_smoke = "Grenade fumigène"
L.grenade_fire = "Grenade incendiaire"

L.unarmed_name = "Sans arme"
L.crowbar_name = "Pied de biche"
L.pistol_name = "Pistolet"
L.rifle_name = "Fusil de sniper"
L.shotgun_name = "Fusil à pompe"

-- Teleporter
L.tele_name = "Téléporteur"
L.tele_failed = "Téléportation ratée."
L.tele_marked = "Position de téléportation marquée."

L.tele_no_ground = "Impossible de se téléporter à moins d'être sur un sol solide!"
L.tele_no_crouch = "Impossible de se téléporter en étant accroupi!"
L.tele_no_mark = "Aucune position marquée. Marquez une destination avant de vous téléporter."

L.tele_no_mark_ground = "Impossible de marquer une position à moins d'être sur un sol solide!"
L.tele_no_mark_crouch = "Impossible de marquer une position en étant accroupi!"

L.tele_help_pri = "Téléporte à la position marquée"
L.tele_help_sec = "Marque la position actuelle"

L.tele_desc = [[
Téleporte vers un lieu marqué.

La téléportation fait du bruit, et le nombre d'utilisations est limité.]]

-- Ammo names, shown when picked up
L.ammo_pistol = "Munitions de 9mm"

L.ammo_smg1 = "Munitions de SMG"
L.ammo_buckshot = "Munitions de fusil à pompe"
L.ammo_357 = "Munitions de fusil"
L.ammo_alyxgun = "Munitions de Deagle"
L.ammo_ar2altfire = "Munitions du pistolet de détresse"
L.ammo_gravity = "Munitions du Poltergeist"

-- Round status
L.round_wait = "En attente"
L.round_prep = "Préparation"
L.round_active = "En cours"
L.round_post = "Terminé"

-- Health, ammo and time area
L.overtime = "PROLONGATIONS"
L.hastemode = "MODE HÂTIF"

-- TargetID health status
L.hp_healthy = "En bonne santé"
L.hp_hurt = "Touché"
L.hp_wounded = "Blessé"
L.hp_badwnd = "Grièvement blessé"
L.hp_death = "Proche de la Mort"

-- TargetID Karma status
L.karma_max = "Réputé"
L.karma_high = "Honnnête"
L.karma_med = "Gâchette facile"
L.karma_low = "Dangereux"
L.karma_min = "Irresponsable"

-- TargetID misc
L.corpse = "Corps"
--L.corpse_hint = "Press [{usekey}] to search and confirm. [{walkkey} + {usekey}] to search covertly."

L.target_disg = "(DÉGUISÉ)"
L.target_unid = "Corps non-identifié"
--L.target_unknown = "A Terrorist"

-- HUD buttons with hand icons that only some roles can see and use
L.tbut_single = "Usage unique"
L.tbut_reuse = "Réutilisable"
L.tbut_retime = "Réutilisable après {num} sec"
L.tbut_help = "Appuyez sur {usekey} pour activer"

-- Spectator muting of living/dead
L.mute_living = "Joueurs vivants mutés"
L.mute_specs = "Spectateurs mutés"
L.mute_all = "Tous mutés"
L.mute_off = "Aucun mutés"

-- Spectators and prop possession
L.punch_title = "FRAPPE-O-METRE"
L.punch_bonus = "Votre mauvais score a baissé votre limite frappe-o-metre de {num}"
L.punch_malus = "Votre bon score a augmenté votre limite frappe-o-metre de {num}!"

-- Info popups shown when the round starts
L.info_popup_innocent = [[
Vous êtes un Terroriste Innocent! Mais il y a des Traitres qui traînent...
À qui pouvez-vous faire confiance, et qui cherche à vous remplir de balles?

Surveillez vos arrières, et bossez avec vos camarades pour vous sortir d'ici en vie!]]

L.info_popup_detective = [[
Vous êtes un Détective! Terroriste QG vous a donné des ressources spéciales pour trouver les Traitres.
Utilisez-les pour aider les innocent à survivre, mais attention:
les traitres chercheront à vous tuer en premier!

Appuyez sur {menukey} pour recevoir votre équipement!]]

L.info_popup_traitor_alone = [[
Vous êtes un TRAITRE! Vous n'avez pas d'amis traitres ce round.

Tuez tout le monde pour gagner!

Appuyez sur {menukey} pour recevoir votre équipement!]]

L.info_popup_traitor = [[
Vous êtes un TRAITRE! Travaillez avec vos amis traitres pour tuer tout le monde.
Mais faites attention, ou votre trahison pourrait sortir au grand jour...

Voici vos camarades:
{traitorlist}

Appuyez sur {menukey} pour recevoir votre équipement!]]

-- Various other text
L.name_kick = "Un joueur a été automatiquement expulsé pour avoir changé son nom pendant un round."

L.idle_popup = [[
Vous avez été absent {num} secondes et donc été mis en mode Spectateur. Dans ce mode, vous n'apparaîtrez pas quand un nouveau round démarre.

Vous pouvez Rejoindre/Quitter ce mode quand vous voulez en appuyant sur {helpkey} allez vers Jouabilité -> Général -> Paramètres de jeu -> 'Mode Spectateur'.]]

L.idle_popup_close = "Ne rien faire"
L.idle_popup_off = "Désactiver le mode Spectateur"

L.idle_warning = "Attention: on dirait que vous n'êtes plus là, vous allez être déplacés en spectateurs sauf si vous montrez de l'activité!"

L.spec_mode_warning = "Vous êtes en mode Spectateur et vous n'apparaîtrez pas quand un round commencera. Pour désactiver ce mode, appuyez sur F1, allez vers Jouabilité -> Général -> Paramètres de jeu -> 'Mode Spectateur'."

-- Tips panel
L.tips_panel_title = "Astuces"
L.tips_panel_tip = "Astuce:"

-- Tip texts
L.tip1 = "Les traitres peuvent fouiller un corps silencieusement, sans confirmer la mort, en maintenant {walkkey} et en pressant {usekey} sur le corps."

L.tip2 = "Amorcer un explosif C4 avec un minuteur plus long va augmenter le nombre de fils qui va causer une explosion imminente quand un innocent essaiera de la désamorcer. Le bip de l'explosif sera moins fort et moins fréquent."

L.tip3 = "Les Détectives peuvent fouiller un corps pour trouver qui est 'reflété dans ses yeux'. C'est la dernière personne que le mort a vue. Ce n'est pas forcément le tueur si le mort a été tué dans le dos."

L.tip4 = "Personne ne saura que vous êtes mort jusqu'à ce qu'ils trouvent votre cadavre et vous identifient en le fouillant."

L.tip5 = "Quand un Traitre tue un Détective, ils reçoivent instantanément un crédit."

L.tip6 = "Quand un Traitre meure, tous les Détectives sont récompensés d'un crédit d'équipement."

L.tip7 = "Quand les Traitres ont bien avancé pour tuer les innocents, ils recevront un crédit d'équipement comme récompense."

L.tip8 = "Les Traitres et les Détectives peuvent prendre les crédits d'équipements non-dépensés des corps morts d'autres Traitres et Détectives."

L.tip9 = "Le Poltergeist peut transformer n'importe quel objet physique en un projectile mortel. Chaque coup est un accompagné de coups d'énergie qui fait mal à tout le monde à proximité."

L.tip10 = "Traitre ou Détective, gardez à l’œil les messages rouges en haut à droite. Ils sont importants pour vous."

L.tip11 = "Traitre ou Détective, gardez en tête que vous récompensez de crédits d'équipement si vos camarades et vous vous débrouillez bien. Assurez-vous de les dépenser!"

L.tip12 = "Le scanner ADN des Détectives peut-être utilisé pour collecter des échantillons ADN d'armes et d'objets puis les scanner pour localiser le joueur qui les a utilisés. Pratique quand vous venez d'obtenir un échantillon d'un corps ou d'un C4 désamorcé!"

L.tip13 = "Quand vous êtes proches de quelqu'un quand vous le tuez, un peu de votre ADN est déposé sur le corps. Cet ADN peut être utilisé pour le Scanner ADN d'un Détective pour vous localiser. Vous feriez mieux de cacher le corps quand vous coupez quelqu'un!"

L.tip14 = "Plus vous étiez quand vous avez tué quelqu'un, plus vite votre échantillon d'ADN sur son corps se dégradera."

L.tip15 = "Vous êtes Traitre et vous allez sniper? Essayez le Déguisement. Si vous ratez voter coup, trouvez un endroit sécurisé, désactivez le Déguisement, et personne ne saura que c'était vous qui tiriez."

L.tip16 = "En tant que Traitre, le Téléporteur peut vous aider à vous enfuir quand on vous traque, et vous permet de voyager rapidement à travers une grande carte. Assurez-vous de marquer une position sécurisée avant."

L.tip17 = "Les innocents sont tous groupés et vous n'arrivez pas à un en séparer un? Pourquoi pas utiliser la Radio pour jouer des sons de C4 ou d'un coup de feu pour les mener ailleurs?"

L.tip18 = "Avec la Radio, en tant que Traitre, vous pouvez jouer des sons dans votre Menu des Équipements après que la radio a été placée. Mettez en attente plusieurs sons en cliquant sur plusieurs boutons dans l'ordre dans lequel vous voulez qu'ils soient."

L.tip19 = "En tant que Détective, si vous avez des crédits en réserve, vous pourriez donner à un innocent de confiance un Démineur. Vous pourriez ensuite vous consacrez à un travail sérieux d'investigation et leur laisser le désamorçage risqué."

L.tip20 = "Les Jumelles des Détectives permettent une vue et une fouille longue portée des corps. Ce n'est pas bon pour les Traitres s'ils espéraient utiliser un corps comme appât. Bien sûr, ceux qui utilisent les jumelles sont désarmés et distraits..."

L.tip21 = "La Station de Soins des Détectives laisse les joueurs blessés guérir. Bien sûr, ces gens blessés pourraient bien être des Traitres..."

L.tip22 = "La Station de Soins enregistre un échantillon ADN de quiconque l'utilise. Les détectives peuvent l'utiliser avec le Scanner ADN pour trouver qui s'est soigné avec."

L.tip23 = "À l'inverse des armes et du C4, le dispositif Radio pour Traitres ne contiennent pas d'échantillon ADN de la personne qui l'a planté. Ne vous inquiétez donc pas d'un Détective qui gâcherait votre couverture."

L.tip24 = "Appuyez sur {helpkey} pour voir un court tutoriel ou modifier des options spécifiques au TTT. Par exemple, vous pouvez désactiver ces astuces pour de bon."

L.tip25 = "Quand un Détective fouille un corps, les résultats sont disponibles pour tous les joueurs à travers le tableau de scores, en cliquant sur le nom de la personne morte."

L.tip26 = "Dans le tableau des scores, une icône de loupe à côté du nom de quelqu'un indique que vous avez déjà cherché des informations à propos de cette personne. Si l'icône est lumineuse, les données viennent d'un Détective et peuvent contenir des informations additionnelles."

L.tip27 = "En tant que Détective, les corps avec une loupe après leur nom ont été fouillés par un Détective et leurs résultats sur accessibles pour tout le monde via le tableau des scores."

L.tip28 = "Les Spectateurs peuvent appuyer sur {mutekey} pour choisir de mute les spectateurs et/ou les joueurs vivants."

L.tip29 = "Si le serveur a installé des langues en plus, vous pouvez choisir une autre langue n'importe quand en appuyant sur F1 -> Langue."

L.tip30 = "Les commandes quickchat ou 'radio' sont accessibles avec {zoomkey}."

L.tip31 = "En tant que Spectateur, appuyez sur {duckkey} pour déverrouiller votre curseur et cliquer les boutons sur le panneau des astuces. Appuyez encore sur {duckkey} pour revenir en vue normale."

L.tip32 = "L'alt-fire du Pied de biche va pousser les autres joueurs."

L.tip33 = "Tirer à travers le viseur d'une arme augmentera légèrement votre précision et réduira le recul. S'accroupir, en revanche, non."

L.tip34 = "Les grenades fumigènes sont efficaces dans les bâtiments, surtout pour créer de la confusion dans les salles bondées."

L.tip35 = "En tant que Traitre, souvenez-vous que vous pouvez porter des cadavres et les cacher des pauvres yeux implorants des innocents et de leurs Détectives."

L.tip36 = "Le tutoriel accessible avec {helpkey} contient un aperçu des clés les plus importantes du jeu."

L.tip37 = "Sur le tableau des scores, cliquez sur le nom d'un joueur vivant et vous pouvez lui poser un label pour eux comme 'suspect' ou 'ami'. Ce label apparaîtra sur la personne concernée en dessous de votre réticule."

L.tip38 = "Beaucoup des équipements qui sont posables (comme le C4, ou la Radio) peuvent aussi être fixés sur des murs avec l'alt-fire."

L.tip39 = "Le C4 qui explose à cause d'une erreur de déminage a une plus petite explosion qu'un C4 qui atteint zéro sur le minuteur."

L.tip40 = "Si vous voyez 'MODE HÂTIF' au-dessus du chrono du round, le round ne durera au début que quelques minutes, mais chaque mort prolongera le temps restant (comme capturer un point de contrôle dans TF2). Ce mode met la pression aux traitres pour faire bouger les choses."

-- Round report
L.report_title = "Rapport du round"

-- Tabs
L.report_tab_hilite = "Temps forts"
L.report_tab_hilite_tip = "Temps forts du round"
L.report_tab_events = "Événements"
L.report_tab_events_tip = "Voici les événements qui sont arrivés durant ce round"
L.report_tab_scores = "Scores"
L.report_tab_scores_tip = "Points marqués par chaque joueur dans ce round"

-- Event log saving
L.report_save = "Sauv .txt"
L.report_save_tip = "Sauvegarde les logs vers un fichier texte"
L.report_save_error = "Aucune donnée des logs à sauvegarder."
L.report_save_result = "Les logs ont été sauvegardé dans:"

-- Columns
L.col_time = "Temps"
L.col_event = "Événement"
L.col_player = "Joueur"
L.col_roles = "Rôle(s)"
L.col_teams = "Team(s)"
L.col_kills1 = "Meurtres des innocents"
L.col_kills2 = "Meurtres des traitres"
L.col_points = "Points"
L.col_team = "Bonus d'équipe"
L.col_total = "Points totaux"

-- Awards/highlights
L.aw_sui1_title = "Leader du Culte du Suicide"
L.aw_sui1_text = "a montré aux autres suicidaires comment on fait en y allant en premier."

L.aw_sui2_title = "Seul et Déprimé"
L.aw_sui2_text = "est le seul qui s'est donné la mort."

L.aw_exp1_title = "Subventions des Recherches sur les Explosifs"
L.aw_exp1_text = "est reconnu pour ses recherches sur les explosifs. {num} cobayes ont contribué."

L.aw_exp2_title = "Recherche sur le Terrain"
L.aw_exp2_text = "a testé sa résistance aux explosions. Hélas, elle était trop faible."

L.aw_fst1_title = "Premier Sang"
L.aw_fst1_text = "est le premier tueur d'Innocent."

L.aw_fst2_title = "Premier Sang d'un Idiot"
L.aw_fst2_text = "a fait la peau le premier a un allié traitre. Bon travail."

L.aw_fst3_title = "Premier... Bêtisier"
L.aw_fst3_text = "a été le premier à tuer. Dommage que c'était un camarade innocent."

L.aw_fst4_title = "Premier Coup"
L.aw_fst4_text = "a envoyé le premier (bon) coup pour les terroristes innocents en abattant en premier un traitre."

L.aw_all1_title = "Le Plus Mortel Parmi Ses Pairs"
L.aw_all1_text = "est responsable de tous les meurtres des innocents ce round."

L.aw_all2_title = "Loup Solitaire"
L.aw_all2_text = "est responsable de tous les meurtres des traitres ce round."

L.aw_nkt1_title = "J'en Ai Eu Un, Patron!"
L.aw_nkt1_text = "a réussi à tuer un seul innocent. Sympa!"

L.aw_nkt2_title = "Une Balle Pour Deux"
L.aw_nkt2_text = "a montré que le premier n'était pas un coup de feu chanceux en tuant un autre gaillard."

L.aw_nkt3_title = "Traitre En Série"
L.aw_nkt3_text = "a mit fin à la vie de 3 pauvres terroristes innocents aujourd'hui."

L.aw_nkt4_title = "Loup Parmi Les Loups-Moutons"
L.aw_nkt4_text = "mange des innocents pour le diner. Un diner composé de {num} plats."

L.aw_nkt5_title = "Agent Anti-Terrorisme"
L.aw_nkt5_text = "est payé à chaque assassinat. Il est temps d'acheter un yacht de luxe."

L.aw_nki1_title = "Trahis Donc Ça"
L.aw_nki1_text = "a trouvé un traitre. Puis il l'a buté. Facile."

L.aw_nki2_title = "Postulé pour la Justice Squad"
L.aw_nki2_text = "a escorté deux traitres dans l'au-delà."

L.aw_nki3_title = "Est-ce Que Les Traitres Rêvent De Moutons Traitres?"
L.aw_nki3_text = "a descendu trois traitres."

L.aw_nki4_title = "Employé d'Affaires Internes"
L.aw_nki4_text = "est payé à chaque assassinat. Il est temps de commander une cinquième piscine."

L.aw_fal1_title = "Non M. Bond, Je M'attends À Ce Que Vous Tombiez"
L.aw_fal1_text = "a poussé quelqu'un d'une grande altitude."

L.aw_fal2_title = "Atterré"
L.aw_fal2_text = "a laissé son corps se fracasser sur le sol après être tombé d'une grande altitude."

L.aw_fal3_title = "La Météorite Humaine"
L.aw_fal3_text = "a écrasé quelqu'un en lui tombant dessus d'une haute altitude."

L.aw_hed1_title = "Efficacité"
L.aw_hed1_text = "a découvert la joie des headshots et en a fait {num}."

L.aw_hed2_title = "Neurologie"
L.aw_hed2_text = "a retiré le cerveau de {num} têtes après un examen minutieux."

L.aw_hed3_title = "C'est À Cause Des Jeux-Vidéos"
L.aw_hed3_text = "n'a fait qu'appliquer son entraînement d'assassin et a headshot {num} ennemis."

L.aw_cbr1_title = "Plonk Plonk Plonk"
L.aw_cbr1_text = "est un maître dans l'art de la manipulation du pied de biche, comme l'ont découvert {num} victimes."

L.aw_cbr2_title = "Freeman"
L.aw_cbr2_text = "a recouvert son pied de biche des cerveaux de pas moins de {num} personnes."

L.aw_pst1_title = "Le P'tit Salaud Persistant"
L.aw_pst1_text = "a tué {num} personnes avec un pistolet. Puis ils ont embrassé quelqu'un jusqu'à sa mort."

L.aw_pst2_title = "Massacre Petit Calibre"
L.aw_pst2_text = "a tué une petite armée de {num} personnes avec un pistolet. Il a vraisemblablement installé un petit fusil à pompe dans le canon."

L.aw_sgn1_title = "Mode Facile"
L.aw_sgn1_text = "mets les balles où ça fait mal, {num} terroristes en ont fait les frais."

L.aw_sgn2_title = "1000 Petites Balles"
L.aw_sgn2_text = "n'aimait pas vraiment son plomb, donc il a tout donné. {num} n'ont pas pu apprécier le moment."

L.aw_rfl1_title = "Point and Click"
L.aw_rfl1_text = "montre que tout ce dont vous avez besoin pour descendre {num} cibles est un fusil et une bonne main."

L.aw_rfl2_title = "Je Peux Voir Ta Tête D'ici!"
L.aw_rfl2_text = "connaît son fusil. Maintenant {num} autres le connaissent aussi."

L.aw_dgl1_title = "C'est Comme Un, Un Petit Fusil"
L.aw_dgl1_text = "commence à se débrouiller avec le deagle et a tué {num} joueurs."

L.aw_dgl2_title = "Maître de l'Aigle"
L.aw_dgl2_text = "a flingué {num} joueurs avec le deagle."

L.aw_mac1_title = "Prier et Tuer"
L.aw_mac1_text = "a tué {num} personnes avec le MAC10, mais ne compte pas dire combien de munitions il a utilisé."

L.aw_mac2_title = "Mac 'n' Cheese"
L.aw_mac2_text = "se demande ce qu'il se passerait s'il pouvait porter deux MAC10. {num} fois deux ça fait?"

L.aw_sip1_title = "Silence"
L.aw_sip1_text = "a fermé le clapet à {num} piplette(s) avec un pistolet silencieux."

L.aw_sip2_title = "Assassin Silencieux"
L.aw_sip2_text = "a tué {num} personnes qui ne se sont pas entendu mourir."

L.aw_knf1_title = "Le Couteau Qui Te Connaît"
L.aw_knf1_text = "a poignardé quelqu'un en pleine tête devant tout internet."

L.aw_knf2_title = "Oû Est-Ce Que T'as Trouvé Ça?"
L.aw_knf2_text = "n'était pas un Traitre, mais a quand même terrassé quelqu'un avec un couteau."

L.aw_knf3_title = "Regardez, C'est L'Homme Au Couteau!"
L.aw_knf3_text = "a trouvé {num} couteaux qui gisaient, et les a utilisés."

L.aw_knf4_title = "Le Plus Gros Couteau Du Monde"
L.aw_knf4_text = "a tué {num} personnes avec un couteau. Ne me demandez pas comment."

L.aw_flg1_title = "À la rescousse"
L.aw_flg1_text = "a utilisé son pistolet de détresse pour {num} morts."

L.aw_flg2_title = "Fusée = Feu"
L.aw_flg2_text = "a montré à {num} hommes comme c'est dangereux de porter des vêtements inflammables."

L.aw_hug1_title = "Expansion Digne D'un H.U.G.E"
L.aw_hug1_text = "a été en harmonie avec son H.U.G.E, et s'est débrouillé pour faire en sorte que les balles tuent {num} hommes."

L.aw_hug2_title = "Un Para Patient"
L.aw_hug2_text = "n'a fait que tirer, et a vu sa -H.U.G.E- patience le récompenser de {num} éliminations."

L.aw_msx1_title = "Poot Poot Poot"
L.aw_msx1_text = "a dégommé {num} victimes avec le M16."

L.aw_msx2_title = "Folie Moyenne Portée"
L.aw_msx2_text = "sais démontrer avec le M16, et il l'a prouvé à {num} victimes."

L.aw_tkl1_title = "Oups..."
L.aw_tkl1_text = "a vu son doigt glisser quand il visait un copain."

L.aw_tkl2_title = "Double Oups"
L.aw_tkl2_text = "a cru qu'il a eu deux Traitres, mais s'est trompé deux fois."

L.aw_tkl3_title = "Oû Est Mon Karma?!"
L.aw_tkl3_text = "ne s'est pas arrêté après avoir buté deux coéquipiers. Trois c'est son nombre chanceux."

L.aw_tkl4_title = "Équipocide"
L.aw_tkl4_text = "a massacré son équipe tout entière. OMGBANBANBAN."

L.aw_tkl5_title = "Roleplayer"
L.aw_tkl5_text = "a pris le rôle d'un malade, mais vraiment. C'est pour ça qu'il a tué la plupart de son équipe."

L.aw_tkl6_title = "Abruti"
L.aw_tkl6_text = "n'a pas compris dans quel camp il était, et il a tué la moitié de ses camarades."

L.aw_tkl7_title = "Plouc"
L.aw_tkl7_text = "a vraiment bien protéger son territoire en tuant plus d'un quart des ses collègues."

L.aw_brn1_title = "Comme Mamie Me Les Faisait"
L.aw_brn1_text = "a frit quelques hommes pour les rendre croustillants."

L.aw_brn2_title = "Pyroïde"
L.aw_brn2_text = "a été entendu rire aux éclats après avoir brûlé un paquet de ses victimes."

L.aw_brn3_title = "Brûleur Pyrrhique"
L.aw_brn3_text = "les a tous cramés, et maintenant il est à court de grenades incendiaires! Comment va-t-il surmonter ça!?"

L.aw_fnd1_title = "Médecin Légiste"
L.aw_fnd1_text = "a trouvé {num} corps qui traînaient."

L.aw_fnd2_title = "Attrapez Les Tous"
L.aw_fnd2_text = "a trouvé {num} corps pour sa collection."

L.aw_fnd3_title = "Arôme De Mort"
L.aw_fnd3_text = "n'arrête pas de tomber sur des corps au hasard comme ça, {num} fois pendant ce round."

L.aw_crd1_title = "Recycleur"
L.aw_crd1_text = "a rassemblé {num} crédits des corps."

L.aw_tod1_title = "Victoire À la Pyrrhus"
L.aw_tod1_text = "n'est mort que quelques secondes avant que son équipe remporte la victoire."

L.aw_tod2_title = "Je Hais Ce Jeu"
L.aw_tod2_text = "est mort juste après que le round ait commencé."

-- New and modified pieces of text are placed below this point, marked with the
-- version in which they were added, to make updating translations easier.

-- v24
L.drop_no_ammo = "Pas assez de munitions dans le chargeur de votre arme pour les jeter en tant que boîte de munitions."

-- 2015-05-25
L.hat_retrieve = "Vous avez ramassé le chapeau d'un Détective."

-- 2017-09-03
L.sb_sortby = "Trier Par:"

-- 2018-07-24
L.equip_tooltip_main = "Menu d'Équipement"
L.equip_tooltip_radar = "Contrôle du Radar"
L.equip_tooltip_disguise = "Contrôle du Déguisement"
L.equip_tooltip_radio = "Contrôle de la Radio"
L.equip_tooltip_xfer = "Transfert de crédits"
--L.equip_tooltip_reroll = "Reroll equipment"

L.confgrenade_name = "Discombobulateur"
L.polter_name = "Poltergeist"
L.stungun_name = "Prototype UMP"

L.knife_instant = "MORT INSTANTANÉE"

L.binoc_zoom_level = "NIVEAU DE ZOOM"
L.binoc_body = "CORPS REPÉRÉ"

L.idle_popup_title = "Inactif"

-- 2019-01-31
L.create_own_shop = "Créer son shop"
L.shop_link = "Lier avec"
L.shop_disabled = "Désactiver le shop"
L.shop_default = "Utiliser le shop par défaut"

-- 2019-05-05
L.reroll_name = "Reroll"
--L.reroll_menutitle = "Reroll equipment"
L.reroll_no_credits = "Tu as besoin de {amount} crédits pour reroll!"
L.reroll_button = "Reroll"
--L.reroll_help = "Use {amount} credits to get a new random set of equipment in your shop!"

-- 2019-05-06
L.equip_not_alive = "Vous pouvez voir tous les items disponibles en sélectionnant un rôle à droite. N'oubliez pas de choisir vos favoris!"

-- 2019-06-27
L.shop_editor_title = "Éditeur du shop"
L.shop_edit_items_weapong = "Éditer Items / Armes"
L.shop_edit = "Éditer le shop"
L.shop_settings = "Paramètres"
L.shop_select_role = "Sélectionner un rôle"
L.shop_edit_items = "Éditer Items"
L.shop_edit_shop = "Éditer le shop"
L.shop_create_shop = "Créer un shop personnalisée"
L.shop_selected = "Sélectionné {role}"
L.shop_settings_desc = "Changer les valeurs pour adapter les Random Shop ConVars. N'oubliez pas de sauvegarder vos modifications!"

L.bindings_new = "Nouvelle touche choisis pour {name}: {key}"

L.hud_default_failed = "Le HUD {hudname} n'a pas été défini comme nouveau paramètre par défaut. Vous n'avez pas la permission, ou bien ce HUD n'existe pas."
L.hud_forced_failed = "Échec du chargement du HUD {hudname}. Vous n'avez pas la permission, ou bien ce HUD n'existe pas."
L.hud_restricted_failed = "Échec de la restriction du HUD {hudname}. Vous n'avez pas la permission."

L.shop_role_select = "Sélectionnez un rôle"
L.shop_role_selected = "{role}'s shop a été sélectionné!"
L.shop_search = "Recherche"

-- 2019-10-19
--L.drop_ammo_prevented = "Something prevents you from dropping your ammo."

-- 2019-10-28
L.target_c4 = "Appuyez sur [{usekey}] pour ouvrir le menu du C4"
L.target_c4_armed = "Appuyez sur [{usekey}] pour désarmer le C4"
L.target_c4_armed_defuser = "Appuyez sur [{primaryfire}] pour désamorcer le C4"
L.target_c4_not_disarmable = "Vous ne pouvez pas désamorcer le C4 d'un autre Traitre, à moins qu'il soit mort"
L.c4_short_desc = "Quelque chose de très explosif"

L.target_pickup = "Appuyez sur [{usekey}] pour ramasser"
L.target_slot_info = "Emplacement: {slot}"
L.target_pickup_weapon = "Appuyez sur [{usekey}] pour ramasser l'arme"
L.target_switch_weapon = "Appuyez sur [{usekey}] pour changer d'arme"
L.target_pickup_weapon_hidden = ", Appuyez sur [{walkkey} + {usekey}] pour ramasser discrètement"
L.target_switch_weapon_hidden = ", Appuyez sur [{walkkey} + {usekey}] pour changer discrètement"
L.target_switch_weapon_nospace = "Il n'y a pas de place disponible dans l'inventaire  pour cette arme"
L.target_switch_drop_weapon_info = "Lâcher {name} du slot {slot}"
L.target_switch_drop_weapon_info_noslot = "Il n'y a pas d'arme à lâcher dans ce slot {slot}"

--L.corpse_searched_by_detective = "This corpse was searched by a public policing role"
L.corpse_too_far_away = "Ce cadavre est trop loin."

L.radio_short_desc = "Les sons des armes sont de la musique pour moi"

L.hstation_subtitle = "Appuyez sur [{usekey}] pour recevoir des soins."
L.hstation_charge = "Charge restante de la station de soin: {charge}"
L.hstation_empty = "Il n'y a plus de charge dans cette station de soins"
L.hstation_maxhealth = "Votre santé est pleine"
L.hstation_short_desc = "La station de soins se recharge lentement au fil du temps"

-- 2019-11-03
L.vis_short_desc = "Visualise une scène de crime si la victime est morte d'une blessure par balle"
L.corpse_binoculars = "Appuyez sur [{key}] pour rechercher un cadavre à l'aide des jumelles."
L.binoc_progress = "Progression des recherches: {progress}%"

L.pickup_no_room = "Vous n'avez pas de place dans votre inventaire pour ce type d'arme"
L.pickup_fail = "Vous ne pouvez pas prendre cette arme"
L.pickup_pending = "Vous avez déjà pris une arme, attendez de la recevoir"

-- 2020-01-07
L.tbut_help_admin = "Éditer les paramètres du traître"
L.tbut_role_toggle = " Appuyez sur [{walkkey} + {usekey}] pour basculer ce bouton pour {role}"
L.tbut_role_config = "Rôle: {current}"
L.tbut_team_toggle = "Appuyez sur [SHIFT + {walkkey} + {usekey}] pour basculer ce bouton pour la team {team}"
L.tbut_team_config = "Team: {current}"
L.tbut_current_config = "Configuration actuelle:"
L.tbut_intended_config = "Configuration prévue par le créateur de la carte:"
L.tbut_admin_mode_only = "Uniquement visible par vous car vous êtes un administrateur et que '{cv}' est réglé sur '1'"
L.tbut_allow = "Autoriser"
L.tbut_prohib = "Interdire"
L.tbut_default = "Par défaut"

-- 2020-02-09
L.name_door = "Porte"
L.door_open = "Appuyez sur [{usekey}] pour ouvrir la porte."
L.door_close = "Appuyez sur [{usekey}] pour fermer la porte."
L.door_locked = "Cette porte est verrouillée."

-- 2020-02-11
L.automoved_to_spec = "(MESSAGE AUTOMATIQUE) Vous avez été transféré dans la team Spectateur car vous était inactif/AFK."
L.mute_team = "{team} muet."

-- 2020-02-16
L.door_auto_closes = "Cette porte se ferme automatiquement"
L.door_open_touch = "Marchez vers la porte pour l'ouvrir."
L.door_open_touch_and_use = "Marchez vers la porte ou appuyez sur [{usekey}] pour ouvrir."

-- 2020-03-09
L.help_title = "Aide et paramètres"

L.menu_changelog_title = "Changelog"
L.menu_guide_title = "TTT2 Guide"
L.menu_bindings_title = "Configuration"
L.menu_language_title = "Langue"
L.menu_appearance_title = "Apparence"
L.menu_gameplay_title = "Jouabilité"
L.menu_addons_title = "Addons"
L.menu_legacy_title = "Legacy Addons"
L.menu_administration_title = "Administration"
L.menu_equipment_title = "Édité l'équipement"
L.menu_shops_title = "Édité les Shops"

L.menu_changelog_description = "Liste des changements et des corrections dans les versions récentes"
L.menu_guide_description = "Vous aide à démarrer TTT2 et vous explique certaines notions sur le gameplay, les rôles et d'autres choses"
L.menu_bindings_description = "Configurer les caractéristiques spécifiques de TTT2 et de ses addons"
L.menu_language_description = "Sélectionnez la langue du jeu"
L.menu_appearance_description = "Modifier l'apparence et la performance de votre UI"
--L.menu_gameplay_description = "Tweak voice and sound volume, accessibility settings, and gameplay settings."
L.menu_addons_description = "Configurer les addons locaux à votre convenance"
L.menu_legacy_description = "Une interface avec des onglets convertis à partir du TTT original, ils devraient être portés sur le nouveau système"
L.menu_administration_description = "Paramètres généraux pour les HUD, les shops, etc."
L.menu_equipment_description = "Fixer les crédits, les limites, la disponibilité et d'autres choses"
L.menu_shops_description = "Ajouter/supprimer des shop aux rôles et définir les équipements qu'ils contiennent"

L.submenu_guide_gameplay_title = "Jouabilité"
L.submenu_guide_roles_title = "Rôles"
L.submenu_guide_equipment_title = "Équipement"

L.submenu_bindings_bindings_title = "Configuration des touches"

L.submenu_language_language_title = "Langue"

L.submenu_appearance_general_title = "Général"
L.submenu_appearance_hudswitcher_title = "Paramètres du HUD"
L.submenu_appearance_vskin_title = "VSkin"
L.submenu_appearance_targetid_title = "TargetID"
L.submenu_appearance_shop_title = "Paramètres des Shops"
L.submenu_appearance_crosshair_title = "Réticule"
L.submenu_appearance_dmgindicator_title = "Indicateur de dégats"
L.submenu_appearance_performance_title = "Performance"
L.submenu_appearance_interface_title = "Interface"

L.submenu_gameplay_general_title = "Général"

L.submenu_administration_hud_title = "Paramètres HUD"
L.submenu_administration_randomshop_title = "Shop Aléatoire"

L.help_color_desc = "Si ce paramètre est activé, il est possible de choisir une couleur qui sera utilisée pour le contour du targetID et du réticule."
L.help_scale_factor = "L'échelle influence tous les éléments de l'UI (HUD, vgui et targetID). Il est automatiquement mis à jour si la résolution de l'écran est modifiée. La modification de cette valeur entraîne la réinitialisation du HUD!"
L.help_hud_game_reload = "Le HUD n'est pas disponible pour le moment. Le jeu doit être rechargé."
L.help_hud_special_settings = "Voici les paramètres spécifiques de ce HUD."
L.help_vskin_info = "VSkin (vgui skin) est le skin appliqué à tous les éléments du menu comme celui en cours. Les skins peuvent être facilement créés avec un simple script lua et peuvent changer les couleurs et la taille de certains paramètres."
L.help_targetid_info = "TargetID est l'information rendue lors de la focalisation d'une entité. Une couleur fixe peut être définie dans le panneau des paramètres généraux."
L.help_hud_default_desc = "Définissez le HUD par défaut pour tous les joueurs. Les joueurs qui n'ont pas encore sélectionné de HUD recevront ce HUD par défaut. Cela ne changera pas le HUD des joueurs qui ont déjà sélectionné leur HUD."
L.help_hud_forced_desc = "Forcer un HUD pour tous les joueurs. Cela désactive la fonction de sélection du HUD pour tous."
L.help_hud_enabled_desc = "Activer/désactiver les HUD pour restreindre la sélection de ces HUD."
L.help_damage_indicator_desc = "L'indicateur de dégâts est la couche affichée lorsque le joueur prend des dégâts. Pour ajouter un nouveau thème, placez un png dans 'materials/vgui/ttt/damageindicator/themes/'."
L.help_shop_key_desc = "Ouvrez le shop en appuyant sur votre touche de shop (c par défaut) au lieu du menu 'score' pendant la préparation / à la fin du round?"

L.label_menu_menu = "MENU"
L.label_menu_admin_spacer = "Zone d'administration (cachée aux utilisateurs normaux)"
L.label_language_set = "Sélectionnez une langue"
L.label_global_color_enable = "Activer les couleurs globales"
L.label_global_color = "Couleur globale"
L.label_global_scale_factor = "Taille de l'interface"
L.label_hud_select = "Sélectionnez un HUD"
L.label_vskin_select = "Sélectionnez un VSkin"
L.label_blur_enable = "Activer le flou à l'arrière-plan du VSkin"
L.label_color_enable = "Activer la couleur de fond VSkin"
L.label_minimal_targetid = "Minimaliste Target ID sous le réticule (pas d'affichage du karma, indice, etc.)"
L.label_shop_always_show = "Toujours montrer le shop"
L.label_shop_double_click_buy = "Possibilité d'acheter un article dans le shop en double-cliquant sur celui-ci"
L.label_shop_num_col = "Nombre de colonnes"
L.label_shop_num_row = "Nombre de lignes"
L.label_shop_item_size = "Taille des icônes"
L.label_shop_show_slot = "Afficher le marqueur de slot"
L.label_shop_show_custom = "Afficher le marqueur d'objet personnalisé"
L.label_shop_show_fav = "Afficher le marqueur d'article favoris"
L.label_crosshair_enable = "Activer le réticule"
L.label_crosshair_opacity = "Opacité du réticule"
L.label_crosshair_ironsight_opacity = "Opacité du réticule du viseur"
L.label_crosshair_size = "Taille du réticule"
L.label_crosshair_thickness = "Épaisseur du réticule"
L.label_crosshair_thickness_outline = "Épaisseur du contour du réticule"
--L.label_crosshair_scale_enable = "Enable dynamic crosshair scale"
L.label_crosshair_ironsight_low_enabled = "Baissez votre arme lorsque vous utilisez le viseur"
L.label_damage_indicator_enable = "Activer l'indicateur de dégâts"
L.label_damage_indicator_mode = "Sélectionnez le thème de l'indicateur de dégâts"
L.label_damage_indicator_duration = "Temps d'affichage de l'indicateur de dégâts"
L.label_damage_indicator_maxdamage = "Dommages nécessaires pour une opacité maximale"
L.label_damage_indicator_maxalpha = "Opacité maximale de l'indicateur de dégâts "
L.label_performance_halo_enable = "Dessinez un contour autour de certaines entités quand vous les regardez"
L.label_performance_spec_outline_enable = "Activer les contours des objets contrôlés"
L.label_performance_ohicon_enable = "Activer les icônes des rôles"
L.label_interface_tips_enable = "Afficher des conseils de jeu au bas de l'écran en mode spectateur"
L.label_interface_popup = "Durée du pop-up de début de round"
L.label_interface_fastsw_menu = "Activer le menu avec un changement d'arme rapide"
L.label_inferface_wswitch_hide_enable = "Activer la fermeture automatique du menu quand je change d'arme"
L.label_inferface_scues_enable = "Jouer un son au début ou à la fin d'un round"
L.label_gameplay_specmode = "Mode Spectateur (toujours resté en spectateur)"
L.label_gameplay_fastsw = "Changement d'arme rapide"
L.label_gameplay_hold_aim = "Permettre de maintenir pour viser"
L.label_gameplay_mute = "Mettez en sourdine les joueurs vivants lorsqu'ils sont morts"
L.label_hud_default = "HUD par défaut"
L.label_hud_force = "HUD Obligatoire"

L.label_bind_weaponswitch = "Ramasser une arme"
L.label_bind_voice = "Chat Vocal Global"
L.label_bind_voice_team = "Chat Vocal de Team"

L.label_hud_basecolor = "Couleur de base"

L.label_menu_not_populated = "Ce sous-menu ne contient aucun contenu."

L.header_bindings_ttt2 = "Configuration des touches TTT2"
L.header_bindings_other = "Autre touches"
L.header_language = "Paramètres de langue"
L.header_global_color = "Sélection de couleur"
L.header_hud_select = "Sélectionner un HUD"
L.header_hud_customize = "Personnaliser le HUD"
L.header_vskin_select = "Sélectionner et personnalise le VSkin"
L.header_targetid = "Paramètres TargetID"
L.header_shop_settings = "Paramètres du shop d'Équipement"
L.header_shop_layout = "Mise en page de la liste des objets"
L.header_shop_marker = "Paramètres des marqueurs d'objets"
L.header_crosshair_settings = "Réglages du réticule"
L.header_damage_indicator = "Paramètres de l'indicateur de dégâts"
L.header_performance_settings = "Paramètres de performance"
L.header_interface_settings = "Paramètres de l'interface"
L.header_gameplay_settings = "Paramètres de jeu"
L.header_hud_administration = "Sélectionnez l'HUDs par Défaut et Obligatoire"
L.header_hud_enabled = "Activer/Désactiver l'HUDs"

L.button_menu_back = "Retour"
L.button_none = "Aucun"
L.button_press_key = "Appuyez sur une touche"
L.button_save = "Sauvegarder"
L.button_reset = "Réinitialiser"
L.button_close = "Fermer"
L.button_hud_editor = "Éditeur d'HUD"

-- 2020-04-20
L.item_speedrun = "Speedrun"
L.item_speedrun_desc = [[Vous rend 50 % plus rapides!]]
L.item_no_explosion_damage = "Pas de dégâts d'explosion"
L.item_no_explosion_damage_desc = [[Vous immunise contre les dégâts causés par les explosions.]]
L.item_no_fall_damage = "Pas de dégâts dus aux chutes"
L.item_no_fall_damage_desc = [[Vous immunise contre les dégâts causés par les chutes.]]
L.item_no_fire_damage = "Pas de dégâts dus au feu"
L.item_no_fire_damage_desc = [[Vous immunise contre les dégâts causés par le feu.]]
L.item_no_hazard_damage = "Pas de dégâts dus au radiations"
L.item_no_hazard_damage_desc = [[Vous immunise contre les dégâts causés par le poison, les radiations et les acides.]]
L.item_no_energy_damage = "Pas de dégâts énergétiques"
L.item_no_energy_damage_desc = [[Vous immunise contre les dégâts énergétiques tels que les lasers, le plasma et l'électricité.]]
L.item_no_prop_damage = "Pas de dégâts dus au props"
L.item_no_prop_damage_desc = [[Vous immunise contre les dégâts causés par les props.]]
L.item_no_drown_damage = "Pas de dégâts de noyade"
L.item_no_drown_damage_desc = [[Vous immunise contre les dégâts dus à la noyade.]]

-- 2020-04-21
L.dna_tid_possible = "Scan possible"
L.dna_tid_impossible = "Scan impossible"
L.dna_screen_ready = "Pas d'ADN"
L.dna_screen_match = "Match"

-- 2020-04-30
L.message_revival_canceled = "Réanimation annulé."
L.message_revival_failed = "Réanimation raté."
L.message_revival_failed_missing_body = "Vous n'avez pas été réanimé car votre cadavre n'existe plus."
L.hud_revival_title = "Temps restant avant réanimation:"
L.hud_revival_time = "{time}s"

-- 2020-05-03
L.door_destructible = "La porte est destructible ({health}HP)"

-- 2020-05-28
--L.corpse_hint_inspect_limited = "Press [{usekey}] to search. [{walkkey} + {usekey}] to only view search UI."

-- 2020-06-04
L.label_bind_disguiser = "Activer/Désactiver le déguisement"

-- 2020-06-24
L.dna_help_primary = "Prélever un échantillon d'ADN"
L.dna_help_secondary = "Changer la place de l'ADN"
L.dna_help_reload = "Supprimer un échantillon"

L.binoc_help_pri = "Identifier un corps."
L.binoc_help_sec = "Changer le niveau de zoom."

L.vis_help_pri = "Lâcher l'appareil activé."


-- 2020-08-07
L.pickup_error_spec = "Vous ne pouvez pas prendre cela en tant que spectateur."
L.pickup_error_owns = "Vous ne pouvez pas prendre ça parce que vous avez déjà cette arme."
L.pickup_error_noslot = "Vous ne pouvez pas prendre cela car vous n'avez pas de place libre."

-- 2020-11-02
L.lang_server_default = "Langue du serveur par défaut"
L.help_lang_info = [[
Cette traduction est complète à {coverage}%.

Gardez à l'esprit que les traductions sont réalisées par la communauté. N'hésitez pas à y contribuer s'il y a quelque chose qui manque ou s'il y a des erreurs.]]

-- 2021-04-13
L.title_score_info = "Info de fin de round"
L.title_score_events = "Historique des événements"

--L.label_bind_clscore = "Open round report"
L.title_player_score = "{player}'s score:"

L.label_show_events = "Afficher les événements de"
L.button_show_events_you = "Vous"
L.button_show_events_global = "Global"
L.label_show_roles = "Afficher la distribution des rôles de"
L.button_show_roles_begin = "Début du round"
L.button_show_roles_end = "Fin du round"

L.hilite_win_traitors = "LA TEAM DES TRAITRES A GAGNÉ"
L.hilite_win_innocents = "LA TEAM DES INNOCENTS A GAGNÉ"
L.hilite_win_tie = "C'EST UNE ÉGALITÉ"
L.hilite_win_time = "LE TEMPS EST ÉCOULÉ"

--L.tooltip_karma_gained = "Karma changes for this round:"
--L.tooltip_score_gained = "Score changes for this round:"
--L.tooltip_roles_time = "Role changes for this round:"

L.tooltip_finish_score_alive_teammates = "Allié(s) en vie: {score}"
L.tooltip_finish_score_alive_all = "Joueurs en vie: {score}"
L.tooltip_finish_score_timelimit = "Temps écoulé: {score}"
L.tooltip_finish_score_dead_enemies = "Ennemis morts: {score}"
L.tooltip_kill_score = "Kill: {score}"
--L.tooltip_bodyfound_score = "Body found: {score}"

L.finish_score_alive_teammates = "Coéquipiers en vie:"
L.finish_score_alive_all = "Joueurs en vie:"
L.finish_score_timelimit = "Temps écoulé:"
L.finish_score_dead_enemies = "Ennemis morts:"
L.kill_score = "Kill:"
L.bodyfound_score = "Corps découvert:"

L.title_event_bodyfound = "Un corps à était trouvé"
--L.title_event_c4_disarm = "A C4 was disarmed"
--L.title_event_c4_explode = "A C4 exploded"
--L.title_event_c4_plant = "A C4 was armed"
L.title_event_creditfound = "Des crédits d'équipement ont été trouvés"
L.title_event_finish = "Le round est terminé"
L.title_event_game = "Un nouveau round a commencé"
L.title_event_kill = "Un joueur a été tué"
L.title_event_respawn = "Un joueur est réapparu"
L.title_event_rolechange = "Un joueur a changé de rôle ou de team"
--L.title_event_selected = "The roles were distributed"
L.title_event_spawn = "Un joueur est apparu"

L.desc_event_bodyfound = "{finder} ({firole} / {fiteam}) a trouvé le corps de {found} ({forole} / {foteam}). Le cadavre avait {credits} crédit(s) d'équipement."
--L.desc_event_bodyfound_headshot = "The victim was killed by a headshot."
--L.desc_event_c4_disarm_success = "{disarmer} ({drole} / {dteam}) successfully disarmed the C4 armed by {owner} ({orole} / {oteam})."
--L.desc_event_c4_disarm_failed = "{disarmer} ({drole} / {dteam}) tried to disarm the C4 armed by {owner} ({orole} / {oteam}). They failed."
--L.desc_event_c4_explode = "The C4 armed by {owner} ({role} / {team}) exploded."
--L.desc_event_c4_plant = "{owner} ({role} / {team}) armed an explosive C4."
L.desc_event_creditfound = "{finder} ({firole} / {fiteam}) a trouvé {credits} crédit(s) d'équipement dans le cadavre de {found} ({forole} / {foteam})."
L.desc_event_finish = "Le round a duré {minutes}:{seconds}. Il y avait {alive} joueur(s) en vie à la fin."
L.desc_event_game = "Le round a commencé."
L.desc_event_respawn = "{player} est réapparu."
L.desc_event_rolechange = "{player} a changé de rôle/team de {orole} ({oteam}) pour devenir un {nrole} ({nteam})."
--L.desc_event_selected = "The teams and roles were distributed for all {amount} player(s)."
L.desc_event_spawn = "{player} est apparu."

-- Name of a trap that killed us that has not been named by the mapper
L.trap_something = "quelque chose"

-- Kill events
L.desc_event_kill_suicide = "C'était un suicide."
L.desc_event_kill_team = "C'était un kill allié."

L.desc_event_kill_blowup = "{victim} ({vrole} / {vteam}) s'est fait exploser."
L.desc_event_kill_blowup_trap = "{victim} ({vrole} / {vteam}) s'est fait exploser par {trap}."

L.desc_event_kill_tele_self = "{victim} ({vrole} / {vteam}) s'est fait téléfrag."
L.desc_event_kill_sui = "{victim} ({vrole} / {vteam}) n'en pouvait plus et s'est tué."
L.desc_event_kill_sui_using = "{victim} ({vrole} / {vteam}) s'est tué avec un(e) {tool}."

L.desc_event_kill_fall = "{victim} ({vrole} / {vteam}) a fait une chute mortelle."
L.desc_event_kill_fall_pushed = "{victim} ({vrole} / {vteam}) a fait une chute mortelle après que {attacker} l'est poussé."
L.desc_event_kill_fall_pushed_using = "{victim} ({vrole} / {vteam}) a fait une chute mortelle après que {attacker} ({arole} / {ateam}) est utilisé un {trap} pour le pousser."

L.desc_event_kill_shot = "{victim} ({vrole} / {vteam}) s'est fait tirer dessus par {attacker}."
L.desc_event_kill_shot_using = "{victim} ({vrole} / {vteam}) s'est fait tirer dessus par {attacker} ({arole} / {ateam}) avec un {weapon}."

L.desc_event_kill_drown = "{victim} ({vrole} / {vteam}) s'est noyé à cause de {attacker}."
L.desc_event_kill_drown_using = "{victim} ({vrole} / {vteam}) s'est noyé à cause de {trap} activé par {attacker} ({arole} / {ateam})."

L.desc_event_kill_boom = "{victim} ({vrole} / {vteam}) est mort d'une explosion causée par {attacker}."
L.desc_event_kill_boom_using = "{victim} ({vrole} / {vteam}) est mort d'une explosion causée par {attacker} ({arole} / {ateam}) avec {trap}."

L.desc_event_kill_burn = "{victim} ({vrole} / {vteam}) s'est fait griller par {attacker}."
L.desc_event_kill_burn_using = "{victim} ({vrole} / {vteam}) a brûlé de {trap} à cause de {attacker} ({arole} / {ateam})."

L.desc_event_kill_club = "{victim} ({vrole} / {vteam}) a été battu par {attacker}."
L.desc_event_kill_club_using = "{victim} ({vrole} / {vteam}) a été roué de coups {attacker} ({arole} / {ateam}) avec {trap}."

L.desc_event_kill_slash = "{victim} ({vrole} / {vteam}) a été poignardé par {attacker}."
L.desc_event_kill_slash_using = "{victim} ({vrole} / {vteam}) s'est fait coupé par {attacker} ({arole} / {ateam}) avec {trap}."

L.desc_event_kill_tele = "{victim} ({vrole} / {vteam}) s'est fait téléfrag par {attacker}."
L.desc_event_kill_tele_using = "{victim} ({vrole} / {vteam}) s'est fait atomiser par {attacker} ({arole} / {ateam}) en utilisant {trap}."

L.desc_event_kill_goomba = "{victim} ({vrole} / {vteam}) s'est fait écrasé par la masse imposante de {attacker} ({arole} / {ateam})."

L.desc_event_kill_crush = "{victim} ({vrole} / {vteam}) s'est fait broyer par {attacker}."
L.desc_event_kill_crush_using = "{victim} ({vrole} / {vteam}) s'est fait broyer par {attacker} ({arole} / {ateam}) avec {trap}."

L.desc_event_kill_other = "{victim} ({vrole} / {vteam}) est mort à cause de {attacker}."
L.desc_event_kill_other_using = "{victim} ({vrole} / {vteam}) est mort à cause de {attacker} ({arole} / {ateam}) avec {trap}."

-- 2021-04-20
L.none = "Sans Rôle"

-- 2021-04-24
--L.karma_teamkill_tooltip = "Teammate killed"
--L.karma_teamhurt_tooltip = "Teammate damaged"
--L.karma_enemykill_tooltip = "Enemy killed"
L.karma_enemyhurt_tooltip = "Dégât infligé"
L.karma_cleanround_tooltip = "Round parfait"
--L.karma_roundheal_tooltip = "Karma restoration"
L.karma_unknown_tooltip = "Inconnu"

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
L.search_title = "Résultats de la fouille - {player}"
L.search_info = "Information"
L.search_confirm = "Confirmer la mort"
--L.search_confirm_credits = "Confirm (+{credits} Credit(s))"
--L.search_take_credits = "Take {credits} Credit(s)"
--L.search_confirm_forbidden = "Confirm forbidden"
--L.search_confirmed = "Death Confirmed"
--L.search_call = "Report Death"
--L.search_called = "Death Reported"

--L.search_team_role_unknown = "???"

L.search_words = "Quelque chose vous dit que quelques-unes des dernières paroles de cette personne étaient: '{lastwords}'"
L.search_armor = "Il avait une armure non-standard."
L.search_disguiser = "Il portait un dispositif qui permet de cacher son identité."
L.search_radar = "Il portait une sorte de radar. Ce radar ne fonctionne plus."
L.search_c4 = "Dans une poche, il y a une note. Elle dit que couper le fil numéro {num} va désamorcer le C4."

L.search_dmg_crush = "Il a beaucoup de fractures. On dirait que l'impact d'un objet lourd l'a tué."
L.search_dmg_bullet = "Il est évident qu'on lui a tiré dessus jusqu'à la mort."
L.search_dmg_fall = "Une chute lui a été fatale."
L.search_dmg_boom = "Les blessures et les vêtements déchirés indiquent qu'une explosion l'a tué."
L.search_dmg_club = "Il est couvert d'ecchymoses et semble avoir été battu. Très clairement, il a été frappé à mort."
L.search_dmg_drown = "Le corps montre les signes d'une inévitable noyade."
L.search_dmg_stab = "Il s'est fait couper et poignarder avant de saigner à mort."
L.search_dmg_burn = "Ça sent le terroriste grillé, non?"
L.search_dmg_teleport = "On dirait que son ADN a été altéré par des émissions de tachyons!"
L.search_dmg_car = "Pendant que cette personne traversait la route, il s'est fait rouler dessus par un conducteur imprudent."
L.search_dmg_other = "Vous n'arrivez pas à identifier la cause de sa mort."

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

L.search_weapon = "Il semblerait qu'un {weapon} a été utilisé pour le tuer."
L.search_head = "Une blessure fatale a été portée à la tête. Impossible de crier."
--L.search_time = "They died a while before you conducted the search."
--L.search_dna = "Retrieve a sample of the killer's DNA with a DNA Scanner. The DNA sample will decay after a while."

L.search_kills1 = "Vous avez trouvé une liste de meurtres qui confirme la mort de {player}."
L.search_kills2 = "Vous avez trouvé une liste de meurtres avec les noms suivants: {player}"
L.search_eyes = "En utilisant vos compétences de détective, vous avez identifié la dernière personne qu'il a vue: {player}. Serait-ce le tueur, ou une coïncidence?"

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
L.body_confirm_one = "{finder} a confirmé la mort de {victim}."
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
L.decoy_help_primary = "Planter le leurre"
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
