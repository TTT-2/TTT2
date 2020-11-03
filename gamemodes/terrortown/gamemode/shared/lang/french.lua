---- French language strings

local L = LANG.CreateLanguage("French")

--- General text used in various places
L.traitor    = "Traitre"
L.detective  = "Détective"
L.innocent   = "Innocent"
L.last_words = "Derniers mots"

L.terrorists = "Terroristes"
L.spectators = "Spectateurs"

L.noteam = "Pas de Team"
L.innocents = "Team Innocents"
L.traitors = "Team Traitres"

--- Round statut messages
L.round_minplayers = "Pas assez de joueurs pour commencer un nouveau round..."
L.round_voting     = "Vote en cours, le round est retardé de {num} secondes..."
L.round_begintime  = "Un nouveau round commence dans {num} secondes. Préparez-vous."
L.round_selected   = "Les Traitres ont été choisis."
L.round_started    = "Le round a commencé !"
L.round_restart    = "Le round a recommencé de force par un admin."

L.round_traitors_one  = "Traitre, vous êtes seul."
L.round_traitors_more = "Traitre, voici vos alliés : {names}"

L.win_time         = "Temps écoulé. Les Traitres ont perdu."
L.win_traitor      = "Les Traitres ont gagné !"
L.win_innocent     = "Les Traitres ont été battus !"
L.win_bees = "Les Abeilles ont gagné!(é)"
L.win_showreport   = "Regardons le rapport du round {num} secondes."

L.limit_round      = "Limite de round atteinte. {mapname} va bientôt charger."
L.limit_time       = "Limite de temps atteinte. {mapname} va bientôt charger."
L.limit_left       = "Il reste {num} round(s) ou {time} minutes avant que la carte change."

--- Credit awards
L.credit_all       = "Vous êtes récompensés de {num} crédit(s) pour vos performances."
L.credit_kill      = "Vous avez reçu {num} crédit(s) pour avoir tué un {role}."

--- Karma
L.karma_dmg_full   = "Votre Karma est à {amount}, donc vous ferez plein dégâts ce round !"
L.karma_dmg_other  = "Votre Karma est à {amount}. De ce fait tous les dégâts que vous faites seront réduits de {num}%"

--- Body identification messages
L.body_found       = "{finder} à trouvé le corps de {victim}. {role}"
L.body_found_team  = "{finder} à trouvé le corps de {victim}. {role} ({team})"

-- The {role} in body_found will be replaced by one of the following :
L.body_found_traitor    = "C'était un Traitre !"
L.body_found_det    = "C'était un Détective."
L.body_found_inno     = "C'était un Innocent."

L.body_confirm     = "{finder} a confirmé la mort de {victim}."

L.body_call        = "{player} a appelé un Détective pour le corps de {victim} !"
L.body_call_error  = "Vous devez confirmer la mort de ce joueur avant d'appeler un Détective !"

L.body_burning     = "Aie ! Ce cadavre est en feu !"
L.body_credits     = "Vous avez trouvé {num} crédit(s) sur le corps !"

--- Menus and windows
L.close = "Fermer"
L.cancel = "Annuler"

-- For navigation buttons
L.next = "Suivant"
L.prev = "Précédent"

-- Equipment buying menu
L.equip_title     = "Équipement"
L.equip_tabtitle  = "Commander de l'Équipement"

L.equip_statut    = "Statut de la commande"
L.equip_cost      = "Il vous reste {num} crédit(s)."
L.equip_help_cost = "Chaque équipement que vous achetez coûte 1 crédit."

L.equip_help_carry = "Vous ne pouvez que acheter où vous avez de la place."
L.equip_carry      = "Vous pouvez porter cet objet."
L.equip_carry_own  = "Vous portez déjà cet objet."
L.equip_carry_slot = "Vous avez déjà une arme dans l’emplacement {slot}."
L.equip_carry_minplayers = "Il n'y a pas assez de joueurs sur le serveur pour activer cette arme."

L.equip_help_stock = "De certains objets vous ne pouvez en acheter qu'un par round."
L.equip_stock_deny = "Cet objet n'est plus en stock."
L.equip_stock_ok   = "Cet objet est en stock."

L.equip_custom     = "Objet ajouté par le serveur."

L.equip_spec_name  = "Nom"
L.equip_spec_type  = "Type"
L.equip_spec_desc  = "Description"

L.equip_confirm    = "Acheter"

-- Disguiser tab in equipment menu
L.disg_name      = "Déguisement"
L.disg_menutitle = "Contrôle déguisement"
L.disg_not_owned = "Vous n'avez pas de Déguisement !"
L.disg_enable    = "Activer déguisement"

L.disg_help1     = "Lorsque votre déguisement est actif, votre nom, santé et karma ne sont pas visibles quand quelqu'un vous regarde. De plus, vous n'apparaîtrez pas sur le radar du Détective."
L.disg_help2     = "Appuyez sur Numpad Enter pour activer/desactiver  le déguisement sans le menu. Vous pouvez aussi lier une touche à 'ttt_toggle_disguise' avec la console."

-- Radar tab in equipment menu
L.radar_name      = "Radar"
L.radar_menutitle = "Contrôle radar"
L.radar_not_owned = "Vous n'avez pas de Radar !"
L.radar_scan      = "Faire un scan"
L.radar_auto      = "Auto-répéter le scan"
L.radar_help      = "Les résultats du scan restent pendant {num} secondes, après cela le Radar devra recharger et pourra être utilisé de nouveau."
L.radar_charging  = "Votre Radar charge !"

-- Transfer tab in equipment menu
L.xfer_name       = "Transfert"
L.xfer_menutitle  = "Transférer crédits"
L.xfer_no_credits = "Vous n'avez aucun crédit à donner !"
L.xfer_send       = "Envoyer un crédit"
L.xfer_help       = "Vous ne pouvez envoyer des crédits qu'à vos amis {role}s."

L.xfer_no_recip   = "Récepteur non valide, transfert annulé."
L.xfer_no_credits = "Pas assez de crédit pour le transfert."
L.xfer_success    = "Transfert de crédit vers {player} complété."
L.xfer_received   = "{player} vous a donné {num} crédit."

-- Radio tab in equipment menu
L.radio_name      = "Radio"
L.radio_help      = "Appuyez sur un bouton pour que votre Radio joue ce son."
L.radio_notplaced = "Vous devez placer la Radio pour la faire jouer un son."

-- Radio soundboard buttons
L.radio_button_scream  = "Cri"
L.radio_button_expl    = "Explosion"
L.radio_button_pistol  = "Tir de Pistolet"
L.radio_button_m16     = "Tir de M16"
L.radio_button_deagle  = "Tir de Deagle"
L.radio_button_mac10   = "Tir de MAC10"
L.radio_button_shotgun = "Tir fusil à pompe"
L.radio_button_rifle   = "Tir de fusil"
L.radio_button_huge    = "Tir de H.U.G.E"
L.radio_button_c4      = "Beep de C4"
L.radio_button_burn    = "En feu"
L.radio_button_steps   = "Bruits de pas"

-- Intro screen shown after joining
L.intro_help     = "Si vous êtes nouveau, appuyez sur F1 pour des instructions !"

-- Radiocommands/quickchat
L.quick_title   = "Touches de Quickchat"

L.quick_yes     = "Oui."
L.quick_no      = "Non."
L.quick_help    = "À l'aide !"
L.quick_imwith  = "Je suis avec {player}."
L.quick_see     = "Je vois {player}."
L.quick_suspect = "{player} est suspect."
L.quick_traitor = "{player} est un Traitre !"
L.quick_inno    = "{player} est innocent."
L.quick_check   = "Y a quelqu'un  ?"

-- {player} in the quickchat text normally becomes a player nickname, but can
-- also be one of the below.  Keep these lowercase.
L.quick_nobody    = "personne"
L.quick_disg      = "quelqu'un de déguisé"
L.quick_corpse    = "un corps non-identifié"
L.quick_corpse_id = "le corps de {player}"

--- Body search window
L.search_title  = "Résultats de la fouille"
L.search_info   = "Information"
L.search_confirm = "Confirmer la mort"
L.search_call   = "Appeler un Détective"

-- Descriptions of pieces of information found
L.search_nick   = "C'est le corps de {player}."

L.search_role_traitor = "C'était un Traitre !"
L.search_role_det = "C'était un Détective."
L.search_role_inno = "C'était un terroriste innocent."

L.search_words  = "Quelque chose vous dit que quelques unes des dernières paroles de cette personne étaient : '{lastwords}'"
L.search_armor  = "Il avait une armure non-standard."
L.search_disg   = "Il portait un dispositif qui permet de cacher son identité."
L.search_radar  = "Il portait une sorte de radar. Ce radar ne fonctionne plus."
L.search_c4     = "Dans une poche, il y a une note. Elle dit que couper le fil numéro {num} va désamorcer la bombe."

L.search_dmg_crush  = "Il a beaucoup de fractures. On dirait que l'impact d'un objet lourd l'a tué."
L.search_dmg_bullet = "Il est évident qu'on lui a tiré dessus jusqu'à la mort."
L.search_dmg_fall   = "Une chute lui a été fatale."
L.search_dmg_boom   = "Ses blessures et les vêtements déchirés indiquent qu'une explosion l'a tué."
L.search_dmg_club   = "Il est couvert d'ecchymoses et semble avoir été battu. Très clairement, il a été frappé à mort."
L.search_dmg_drown  = "Le corps montre les signes d'une inévitable noyade."
L.search_dmg_stab   = "Il s'est fait coupé et poignardé avant de saigner à mort."
L.search_dmg_burn   = "Ça sent le terroriste grillé, non  ?"
L.search_dmg_tele   = "On dirait que son ADN a été altéré par des émission de tachyons !"
L.search_dmg_car    = "Pendant que cette personne traversait la route, ils s'est fait roulé dessus par un conducteur imprudent."
L.search_dmg_other  = "Vous n'arrivez pas à identifier la cause de sa mort."

L.search_weapon = "Il semblerait qu'un {weapon} a été utilisé pour le tuer."
L.search_head   = "Le blessure fatale a été portée à la tête. Impossible de crier."
L.search_time   = "Il est mort {time} avant que vous fassiez l'enquête."
L.search_dna    = "Ramassez un échantillon de l'ADN du tueur avec un Scanner ADN. Cet échantillon va se décomposer dans à peu près {time}."

L.search_kills1 = "Vous avez trouvé une liste de meurtres qui confirme la mort de {player}."
L.search_kills2 = "Vous avez trouvé une liste de meurtres avec les noms suivants :"
L.search_eyes   = "En utilisant vos compétences de détectives, vous avez identifié la dernière personne qu'il a vu : {player}. Serait-ce le tueur, ou une coïncidence  ?"

-- Scoreboard
L.sb_playing    = "Vous jouez sur..."
L.sb_mapchange  = "On change de carte dans {num} round(s) ou dans {time}"

L.sb_mia        = "Portés disparus"
L.sb_confirmed  = "Confirmés Morts"

L.sb_ping       = "Ping"
L.sb_deaths     = "Morts"
L.sb_score      = "Score"
L.sb_karma      = "Karma"

L.sb_info_help  = "Si vous cherchez le corps de ce joueur, vous aurez les détails de sa mort."

L.sb_tag_friend = "AMI"
L.sb_tag_susp   = "SUSPECT"
L.sb_tag_avoid  = "A EVITER"
L.sb_tag_kill   = "A TUER"
L.sb_tag_miss   = "PERDU"

-- Equipment actions, like buying and dropping
L.buy_no_stock    = "Cette arme est à court de stock : vous l'avez déjà acheté ce round."
L.buy_pending     = "Vous avez déjà une commande en attente, attendez de la recevoir d'abord."
L.buy_received    = "Vous avez reçu votre équipement spécial."

L.drop_no_room    = "Il n'y pas la place pour jeter votre arme !"

L.disg_turned_on  = "Déguisement activé !"
L.disg_turned_off = "Déguisement désactivé."

-- Equipment item descriptions
L.item_passive    = "Objet à effet passif"
L.item_active     = "Objet à effet actif"
L.item_weapon     = "Arme"

L.item_armor      = "Armure"
L.item_armor_desc = [[
Rréduit les dommages causés par les balles, les flammes et les explosions. Diminue avec le temps.

Il peut être acheté plusieurs fois. Après avoir atteint une valeur d'armure spécifique, l'armure devient plus résistante.]]

L.item_radar      = "Radar"
L.item_radar_desc = [[
Vous laisse scanner des formes de vies.

Commence des scans automatiques dès que vous l'achetez. Configurez-le dans l'onglet Radar de ce menu.]]

L.item_disg       = "Déguisement"
L.item_disg_desc  = [[
Cache votre ID. Évite de paraître comme la dernière personne vue avant de mourir.

Activer/Desactiver le déguisement vers l'onglet Déguisement de ce menu ou appuyez sur Numpad Enter.]]

-- C4
L.c4_hint         = "Utilisez {usekey} pour amorcer ou désamorcer."
L.c4_disarm_warn  = "Un explosif C4 que vous avez planté a été désamorcé."
L.c4_armed        = "Vous avez amorcé la bombe avec succès."
L.c4_disarmed     = "Vous avez désamorcé la bombe avec succès."
L.c4_no_room      = "Vous n'avez pas la place pour ce C4."

L.c4_desc         = "Explosif surpuissant menu d'un minuteur."

L.c4_arm          = "Amorcer le C4"
L.c4_arm_timer    = "Minuteur"
L.c4_arm_secondes  = "Secondes avant détonation :"
L.c4_arm_attempts = "Pendant le désamorçage, {num} des 6 fils va instantanément détoner quand coupé."

L.c4_remove_title    = "Retrait"
L.c4_remove_pickup   = "Ramasser C4"
L.c4_remove_destroy1 = "Détruire C4"
L.c4_remove_destroy2 = "Confirmer : destruction"

L.c4_disarm       = "Désamorcer C4"
L.c4_disarm_cut   = "Couper le fil {num}"

L.c4_disarm_owned = "Coupez un fil pour désamorcer la bombe. C'est votre bombe, donc tous les fils fonctionneront."
L.c4_disarm_other = "Coupez un fil pour désamorcer la bombe. Si vous vous trompez, ça va péter !"

L.c4_statut_armed    = "ARMÉE"
L.c4_statut_disarmed = "DÉSARMÉE"

-- Visualizer
L.vis_name        = "Visualiseur"
L.vis_hint        = "Appuyez sur {usekey} pour ramasser (Détectives uniquement)."

L.vis_help_pri    = "{primaryfire} pour jeter l'appareil activé."

L.vis_desc        = [[
Dispositif de visualisation de scène de crime.

Analyse un corps pour montrer commentla victime a été tuée, mais seulement s'il est mort d'un coup de feu.]]

-- Decoy
L.decoy_name      = "Leurre"
L.decoy_no_room   = "Vous ne pouvez pas porter ce leurre."
L.decoy_broken    = "Votre Leurre a été détruit !"

L.decoy_short_desc = "Ce leurre montre un faux signal radar visible par les autres team"
L.decoy_pickup_wrong_team = "Vous ne pouvez pas le ramasser car il appartient à une autre team"

L.decoy_desc      = [[
Montre un faux signe sur le radar des autres team ,et font que leur scanner ADN montre la position du Leurre s'il cherche le vôtre.]]

-- Defuser
L.defuser_name    = "Démineur"
L.defuser_help    = "{primaryfire} désamorce le C4 ciblé."

L.defuser_desc    = [[
Désamorce instantanément un explosif C4.

Usages illimités. Le C4 sera plus visible si vous avez ça sur vous.]]

-- Flare gun
L.flare_name      = "Pistolet de détresse"

L.flare_desc      = [[
Peut être utilisé pour brûler les corps pourqu'ils ne soient pas trouvés. Munitions limitées

Brûler un corps fait un son distinct.]]

-- Health station
L.hstation_name   = "Station de Soins"

L.hstation_broken = "Votre Station de Soins a été détruite !"
L.hstation_help   = "{primaryfire} place la Station de Soins."

L.hstation_desc   = [[
Soigne les personnes qui l'utilise.

Recharge lente. Tout le monde peut l'utiliser, et elle peut être endommagée. Peut être vérifiée pour les échantillons ADN de ses utilisateurs.]]

-- Knife
L.knife_name      = "Couteau"
L.knife_thrown    = "Couteau lancé"

L.knife_desc      = [[
Tue les cibles blessées sur le champ et sans faire de bruit, mais à usage unique.

Peut être lancé avec l'alt-fire.]]

-- Poltergeist
L.polter_desc     = [[
Plante des pousseurs sur des objets pour les pousser violemment.

Ces éclats d'énergie peuvent frapper les gens à proximité.]]

-- Radio
L.radio_broken    = "Votre Radio a été détruite !"
L.radio_help_pri  = "{primaryfire} place la Radio."

L.radio_desc      = [[
Joue des sons pour distraire ou tromper.

Placez la radio quelque part, ensuite jouez des sons depuis l'onglet Radio dans ce menu.]]

-- Silenced pistol
L.sipistol_name   = "Pistolet Silencieux"

L.sipistol_desc   = [[
Pistolet bas bruit, utilise des munitions de pistolet normales.

Les victimes ne crieront pas quand tuées.]]

-- Newton launcher
L.newton_name     = "Lanceur de Newton"

L.newton_desc     = [[
Pousse les gens à une distance de sécurité.

Munitions illimitées, mais lent à tirer.]]

-- Binoculars
L.binoc_name      = "Binocles"

L.binoc_desc      = [[
Zoomer sur des corps et les identifier de loin.

Usages illimités, mais l'identification prend quelques secondes.]]

-- UMP
L.ump_desc        = [[
SMG expérimental qui désoriente les cibles.

Utilise les munitions normales de SMG.]]

-- ADN scanner
L.dna_name        = "Scanner ADN"
L.dna_identify    = "Le corps doit être identifié pour récupérer l'ADN du tueur."
L.dna_notfound    = "Pas d'échantillon ADN trouvé sur la cible."
L.dna_limit       = "Limite de stockage atteinte. Retirez les vieux échantillons pour en ajouter de nouveaux."
L.dna_decayed     = "L'échantillon ADN du tueur s'est dégradé."
L.dna_killer      = "Échantillon ADN du tueur récupéré du corps !"
L.dna_no_killer   = "L'ADN n'a pas pu être récupérée (le tueur s'est déconnecté  ?)."
L.dna_armed       = "La bombe est amorcée ! Désamorcez-la d'abord !"
L.dna_object      = "{num} nouveaux échantillon(s) ADN de l'objet."
L.dna_gone        = "Pas d'ADN par ici."

L.dna_desc        = [[
Collectez des échantillons ADN d'objets et utilisez-les pour trouvez le propriétaire de cet ADN.

Essayez-le sur des corps tout frais pour récupérer l'ADN du tueur pour le traquer.]]

-- Magneto stick
L.magnet_name     = "Magneto-stick"
L.magnet_help     = "{primaryfire} pour attacher le corps sur cette surface."

-- Grenades and misc
L.grenade_smoke   = "Grenade fumigène"
L.grenade_fire    = "Grenade incendiaire"

L.unarmed_name    = "Sans arme"
L.crowbar_name    = "Pied de biche"
L.pistol_name     = "Pistolet"
L.rifle_name      = "Fusil de sniper"
L.shotgun_name    = "Fusil à pompe"

-- Teleporter
L.tele_name       = "TÉlÉporteur"
L.tele_failed     = "Téléport raté."
L.tele_marked     = "Position de téléport marquée."

L.tele_no_ground  = "Impossible de téléporter à moins d'être sur un sol solide !"
L.tele_no_crouch  = "Impossible de téléporter en étant accroupi !"
L.tele_no_mark    = "Aucune position marquée. Marquez une destination avant de vous téléporter."

L.tele_no_mark_ground = "Impossible de marquer une position à moins d'être sur un sol solide !"
L.tele_no_mark_crouch = "Impossible de marquer une position en étant accroupi !"

L.tele_help_pri   = "{primaryfire} téléporte la position marquée."
L.tele_help_sec   = "{secondaryfire} marque la position actuelle."

L.tele_desc       = [[
Teleporte vers un lieu marqué.

La téléportation fait du bruit, et le nombre d'utilisations est limité.]]

-- Ammo names, shown when picked up
L.ammo_pistol     = "Munitions 9mm"

L.ammo_smg1       = "Munitions SMG"
L.ammo_buckshot   = "Munitions de fusil à pompe"
L.ammo_357        = "Munitions fusil"
L.ammo_alyxgun    = "Munitions Deagle"
L.ammo_ar2altfire = "Munitions de pistolet de détresse"
L.ammo_gravity    = "Munitions de Poltergeist"

-- Round statut
L.round_wait   = "En attente"
L.round_prep   = "Préparation"
L.round_active = "En cours"
L.round_post   = "Terminé"

-- Health, ammo and time area
L.overtime     = "PROLONGATIONS"
L.hastemode    = "MODE HÂTE"

-- TargetID health statut
L.hp_healthy   = "En Bonne Santé"
L.hp_hurt      = "Touché"
L.hp_wounded   = "Blessé"
L.hp_badwnd    = "Grièvement Blessé"
L.hp_death     = "Presque Mort"

-- TargetID karma statut
L.karma_max    = "Honorable"
L.karma_high   = "Cru"
L.karma_med    = "Gâchette facile"
L.karma_low    = "Dangereux"
L.karma_min    = "Irresponsable"

-- TargetID misc
L.corpse       = "Corps"
L.corpse_hint  = "Appuyez sur {usekey} pour fouiller. {walkkey} + {usekey} pour une fouille approfondie."

L.target_disg  = "(DÉGUISÉ)"
L.target_unid  = "Corps non-identifié"

L.target_credits = "Fouiller pour récupérer crédit non dépensés"

-- HUD buttons with hand icons that only some roles can see and use
L.tbut_single  = "Usage unique"
L.tbut_reuse   = "Réutilisable"
L.tbut_retime  = "Réutilisable après {num} sec"
L.tbut_help    = "Appuyez sur {usekey} pour activer"

-- Spectator muting of living/dead
L.mute_living  = "Joueurs vivants mutés"
L.mute_specs   = "Spectateurs mutés"
L.mute_all     = "Tous mutés"
L.mute_off     = "Aucun mutés"

-- Spectators and prop possession
L.punch_title  = "FRAPPE-O-METRE"
L.punch_help   = "Touche de déplacement ou saut : frappe l'objet. Accroupir : quitter l'objet."
L.punch_bonus  = "Votre mauvais score a baissé votre limite frappe-o-metre de {num}"
L.punch_malus  = "Votre bon score a augmenté votre limite frappe-o-metre de {num} !"

--- Info popups shown when the round starts
L.info_popup_innocent = [[
Vous êtes un Terroriste Innocent ! Mais il y a des Traitres qui traînent...
À qui pouvez-vous faire confiance, et qui cherche à vous remplir de balles  ?

Surveillez vos arrières, et bossez avec vos camarades pour vous sortir d'ici en vie !]]

L.info_popup_detective = [[
Vous êtes un Détective ! Terroriste QG vous a donné des ressources spéciales pour trouver les Traitres.
Utilisez-les pour aider les innocent à survire, mais attention :
les traitres chercheront à vous tuer en premier !

Appuyez sur {menukey} pour recevoir votre équipement !]]

L.info_popup_traitor_alone = [[
Vous êtes un TRAITRE ! Vous n'avez pas d'amis traitres ce round.

Tuez tous les autres pour gagner !

Appuyez sur {menukey} pour recevoir votre équipement !]]

L.info_popup_traitor = [[
Vous êtes un TRAITRE ! Travaillez avec vos amis traitres pour tuer tout le monde.
Mais faites attention, ou votre trahison pourrait sortir au grand jour...

Voici vos camarades :
{traitorlist}

Appuyez sur {menukey} pour recevoir votre équipement !]]

--- Various other text
L.name_kick = "Un joueur a été automatiquement expulsé pour avoir changé son nom pendant un round."

L.idle_popup = [[
Vous avez étiez absent {num} secondes et a donc été mis dans le mode Spectateur uniquement. Dans ce mode, vous n'apparaîtrez pas quand un nouveau round démarre.

Vous pouvez Rejoindre/Quitter ce mode quand vous voulez en appuyant sur {helpkey} et en décochant la case adéquat dans l'onglet Options. Vous pouvez aussi choisir de le désactiver maintenant.]]

L.idle_popup_close = "Ne rien faire"
L.idle_popup_off   = "Désactiver le mode maintenant"

L.idle_warning = "Attention : on dirait que vous n'êtes plus là, vous allez être déplacé vers les spectateurs à moins de montrer de l'activité !"

L.spec_mode_warning = "Vous êtes en mode Spectateur et vous n'apparaîtrez pas quand un round commence. Pour désactivez ce mode, appuyez sur F1, allez vers Jouabilité -> Général -> Paramètres de jeu -> 'Mode Spectateur-only'."

-- Tips panel
L.tips_panel_title = "Astuces"
L.tips_panel_tip   = "Astuce :"

-- Tip texts
L.tip1 = "Les traitres peuvent fouillez un corps silencieusement, sans confirmer la mort, en maintenant {walkkey} et en pressant {usekey} sur le corps."

L.tip2 = "Amorcer un explosif C4 avec un minuteur plus long va augmenter le nombre de fils qui va cause une explosion imminente quand un innocent essaiera de la désamorcer. L'explosif beepera plus doucement et à moins grande fréquence."

L.tip3 = "Les Détectives peuvent fouiller un corps pour trouver qui est 'reflété dans ses yeux'. C'est la dernière personne que le mort a vu. Ce n'est pas forcement le tueur si le mort a été tué dans le dos."

L.tip4 = "Personne ne saura que vous êtes mort jusqu'à ce qu'ils trouvent votre cadavre et vous identifie en le fouillant."

L.tip5 = "Quand un Traitre tue un Détective, ils reçoivent instantanément un crédit."

L.tip6 = "Quand un Traitre meure, tous les Détectives sont récompensés d'un crédit d'équipement."

L.tip7 = "Quand les Traitres ont bien avancé pour tuer les innocents, ils recevront un crédit d'équipement comme récompense."

L.tip8 = "Les Traitres et les Détectives peuvent prendre les crédits d'équipement non-dépensés des corps morts d'autres Traitres et Détectives."

L.tip9 = "Le Poltergeist peut transformer n'importe quel objet physique en un projectile mortel. Chaque coup est un accompagné de coups d'énergie qui fait mal à tout le monde à proximité."

L.tip10 = "Traitre ou Détective, gardez à l’œil les messages rouges en haut à droite. Ils sont importants pour vous."

L.tip11 = "Traitre ou Détective, gardez en tête que vous récompensés de crédits d'équipement si vos camarades et vous vous débrouillez bien. Assurez-vous de les dépenser !"

L.tip12 = "Le scanner ADN des Détectives peut être utilisé pour collecter des échantillons ADN d'armes et d'objets puis les scanner pour localiser le joueur qui les a utilisés. Pratique quand vous venez d'obtenir un échantillon d'un corps ou d'un C4 désamorcé !"

L.tip13 = "Quand vous êtes proches de quelqu'un quand vous le tuez, un peu de votre ADN est déposé sur le corps. Cet ADN peut être utilisé pour le Scanner ADN d'un Détective pour vous localiser. Vous feriez mieux de cacher le corps quand vous coupez quelqu'un !"

L.tip14 = "Plus vous étiez quand vous avez tué quelqu'un, plus vite votre échantillon d'ADN sur son corps se dégradera."

L.tip15 = "Vous êtes Traitre et vous allez sniper  ? Essayez le Déguisement. Si vous ratez voter coup, trouvez un endroit sécurisé, désactivez le Déguisement, et personne ne saura que c'était vous qui tirait."

L.tip16 = "En tant que Traitre, le Téléporteur peut vous aider à vous enfuir quand on vous traque, et vous permet de voyager rapidement à travers une grande carte. Assurez-vous de marquer une position sécurisée avant."

L.tip17 = "Les innocents sont tous groupés et vous n'arrivez pas à un en séparer un  ? Pourquoi pas utiliser la Radio pour jouer des sons de C4 ou d'un coup de feu pour les mener ailleurs  ?"

L.tip18 = "Avec la Radio, en tant que Traitre, vous pouvez jouer des sons dans votre Menu des Équipements après que la radio a été placée. Mettez en attente plusieurs sons en cliquant sur plusieurs boutons dans l'ordre dans lequel vous voulez qu'ils soient."

L.tip19 = "En tant que Détective, si vous avez des crédits en réserve, vous pourriez donner à un innocent de confiance un Démineur. Vous pourriez ensuite vous consacrez à un travail sérieux d'investigation et leur laisser le désamorçage risqué."

L.tip20 = "Les Binocles des Détectives permettent une vue et une fouille longue portée des corps. C'est pas bon pour les Traitres s'ils espéraient utiliser un corps comme appât. Bien sûr, ceux qui utilisent les Binocles sont désarmés et distraits..."

L.tip21 =  "La Station de Soins des Détectives laisse les joueurs blessés guérir. Bien sûr, ces gens blessés pourraient bien être des Traitres..."

L.tip22 = "La Station de Soins enregistre un échantillon ADN de quiconque l'utilise. Les détectives peuvent l'utiliser avec le Scanner ADN pour trouver qui s'est soigné avec."

L.tip23 = "À l'inverse des armes et du C4, le dispositif Radio pour Traitres ne contiennent pas de échantillon ADN de la personne qui l'a planté. Ne vous inquiétez donc pas d'un Détective qui gâcherai votre couverture."

L.tip24 = "Appuyez sur {helpkey} pour voir un court tutoriel ou modifier des options spécifiques au TTT. Par exemple, vous pouvez désactiver ces astuces pour de bon."

L.tip25 = "Quand un Détective fouille un corps, les résultats sont disponibles pour tous les joueurs à travers le tableau de scores, en cliquant sur le nom de la personne morte."

L.tip26 = "Dans le tableau des scores, une icône de loupe à côté du nom de quelqu'un indique que vous avez déjà cherché des informations à propos de cette personne. Si l'icône est lumineuse, les données viennent d'un Détective et peut contenir des informations additionnelles."

L.tip27 = "En tant que Détective, les corps avec une loupe après leur nom ont été fouillés par un Détective et leur résultats sur accessibles pour tout le monde via le tableau des scores."

L.tip28 = "Les Spectateurs peuvent appuyer sur {mutekey} pour parcourir les mutes pour les spectateurs ou les joueurs vivants."

L.tip29 = "Si le serveur a installé des langues en plus, vous pouvez commuter sur une langue différent n'importe quand dans le menu Options."

L.tip30 = "Les commandes quickchat ou 'radio' sont accessibles avec {zoomkey}."

L.tip31 = "En tant que Spectateur, appuyez sur {duckkey} pour déverrouiller votre curseur et cliquer les boutons sur le panneau des astuces. Appuyez encore sur {duckkey} pour revenir en vue normale."

L.tip32 = "L'alt-fire du Pied de biche va pousser les autres joueurs."

L.tip33 = "Tirer à travers le viseur d'une arme augmentera légèrement votre précision et réduira le recul. S'accroupir, en revanche, non."

L.tip34 = "Les grenades fumigènes sont efficaces dans les bâtiments, surtout pour créer de la confusion dans les salles bondées."

L.tip35 = "En tant que Traitre, souvenez-vous que vous pouvez porter des cadavres et les cacher des pauvre yeux implorants des innocents et de leurs Détectives."

L.tip36 = "Le tutoriel accessible avec {helpkey} contient un aperçu des clés les plus importantes du jeu."

L.tip37 = "Sur le tableau des scores, cliquez sur le nom d'un joueur vivant et vous pouvez lui poser un label pour eux comme 'suspect' or 'ami'. Ce label apparaîtra sur la personne concernée en dessous de votre réticule."

L.tip38 = "Beaucoup des équipements qui sont posables (comme le C4, ou la Radio) peuvent aussi être fixés sur des murs avec l'alt-fire."

L.tip39 = "Le C4 qui explose à cause d'une erreur de déminage a une plus petite explosion qu'un C4 qui atteint zéro sur le minuteur."

L.tip40 = "Si vous voyez 'MODE HÂTIF' au-dessus du chrono du round, le round ne durera au début que quelques minutes, mais chaque mort prolongera le temps restant (comme capturer un point de contrôle dans TF2). Ce mode met la pression aux traitres pour faire bouger les choses."

--- Round report
L.report_title = "Rapport du round"

-- Tabs
L.report_tab_hilite = "Temps forts"
L.report_tab_hilite_tip = "Temps forts du round"
L.report_tab_events = "Événements"
L.report_tab_events_tip = "Journal des événements qui sont arrivés ce round"
L.report_tab_scores = "Scores"
L.report_tab_scores_tip = "Points marqués par chaque joueur dans ce round seul"

-- Event log saving
L.report_save     = "Sauv. .txt"
L.report_save_tip = "Sauvegarde le Journal des Événements vers un fichier texte"
L.report_save_error  = "Aucune donnée du Journal à sauvegarder."
L.report_save_result = "Le Journal a été sauvegardé dans :"

-- Big title window
L.hilite_win_traitors = "VICTOIRE DES TRAITRES !"
L.hilite_win_bees = "VICTOIRE DES ABEILLES"
L.hilite_win_innocents = "VICTOIRE DES INNOCENTS !"

L.hilite_players1 = "Vous étiez {numplayers}, dont {numtraitors} traitres"
L.hilite_players2 = "Vous étiez {numplayers}, dont un traitre"

L.hilite_duration = "Le round a duré {time}"

-- Columns
L.col_time   = "Temps"
L.col_event  = "Événement"
L.col_player = "Joueur"
L.col_roles  = "Rôle(s)"
L.col_teams  = "Team(s)"
L.col_kills1 = "Meurtres innocents"
L.col_kills2 = "Meurtres traitres"
L.col_points = "Points"
L.col_team   = "Bonus d'équipe"
L.col_total  = "Points totaux"

-- Name of a trap that killed us that has not been named by the mapper
L.something      = "quelque chose"

-- Kill events
L.ev_blowup      = "{victim} s'est fait exploser"
L.ev_blowup_trap = "{victim} s'est fait exploser par {trap}"

L.ev_tele_self   = "{victim} s'est téléfrag"
L.ev_sui         = "{victim} n'en pouvait plus et s'est tué"
L.ev_sui_using   = "{victim} s'est tué avec {tool}"

L.ev_fall        = "{victim} a fait une chute mortelle"
L.ev_fall_pushed = "{victim} a fait une chute mortelle après que {attacker} l'a poussé"
L.ev_fall_pushed_using = "{victim} a fait une chute mortelle après que {attacker} a utilisé {trap} pour le pousser"

L.ev_shot        = "{victim} s'est fait tiré dessus par {attacker}"
L.ev_shot_using  = "{victim} s'est fait tiré dessus par {attacker} avec un {weapon}"

L.ev_drown       = "{victim} s'est noyé à cause de {attacker}"
L.ev_drown_using = "{victim} s'est noyé à cause de {trap} activé par {attacker}"

L.ev_boom        = "{victim} est mort d'une explosion causée par {attacker}"
L.ev_boom_using  = "{victim} est mort d'une explosion causée par {attacker} avec {trap}"

L.ev_burn        = "{victim} s'est fait grillé par {attacker}"
L.ev_burn_using  = "{victim} a brûlé de {trap} à cause de {attacker}"

L.ev_club        = "{victim} a été battu par {attacker}"
L.ev_club_using  = "{victim} a été roué de coups {attacker} avec {trap}"

L.ev_slash       = "{victim} a été poignardé par {attacker}"
L.ev_slash_using = "{victim} s'est fait coupé par {attacker} avec {trap}"

L.ev_tele        = "{victim}s'est fait téléfrag par {attacker}"
L.ev_tele_using  = "{victim} s'est fait atomisé par {attacker} en utilisant {trap}"

L.ev_goomba      = "{victim} s'est fait écrasé par la masse imposante de {attacker}"

L.ev_crush       = "{victim} s'est fait broyé par {attacker}"
L.ev_crush_using = "{victim} s'est fait broyé par {attacker} avec {trap}"

L.ev_other       = "{victim} est mort à cause de {attacker}"
L.ev_other_using = "{victim} est mort à cause de {attacker} avec {trap}"

-- Other events
L.ev_body        = "{finder} a trouvé le corps de {victim}"
L.ev_c4_plant    = "{player} a planté un C4"
L.ev_c4_boom     = "Le C4 planté par {player} a explosé"
L.ev_c4_disarm1  = "{player} a désamorcé le C4 planté par {owner}"
L.ev_c4_disarm2  = "{player} a échoué au déminage du C4 planté par {owner}"
L.ev_credit      = "{finder} a trouvé {num} crédit(s) sur le corps de {player}"

L.ev_start       = "Les round a commencé"
L.ev_win_traitor = "Les ignobles traitres remportent la victoire !"
L.ev_win_inno    = "Les adorable innocents remportent la victoire !"
L.ev_win_time    = "Les traitres ont manqué de temps et ont perdu !"

--- Awards/highlights
L.aw_sui1_title = "Leader du Culte du Suicide"
L.aw_sui1_text  = "a montré les autres suicidaires comment on fait en y allant le premier."

L.aw_sui2_title = "Seul et DÉprimÉ"
L.aw_sui2_text  = "est le seul qui s'est donné la mort."

L.aw_exp1_title = "Subventions des Recherches sur les Explosifs"
L.aw_exp1_text  = "est reconnu pour ses recherches sur les explosifs. {num} cobayes ont contribué."

L.aw_exp2_title = "Recherche sur le Terrain"
L.aw_exp2_text  = "a testé sa résistance aux explosions. Hélas, elle était trop faible."

L.aw_fst1_title = "Premier Sang"
L.aw_fst1_text  = "a expédié la première mort d'un innocent dans les mains de traitres."

L.aw_fst2_title = "Premier Sang d'un Idiot"
L.aw_fst2_text  = "a fait la peau le premier a un allié traitre. Bon travail."

L.aw_fst3_title = "Premier... BÊtisier"
L.aw_fst3_text  = "a été le premier à tuer. Dommage que c'était un camarade innocent."

L.aw_fst4_title = "Premier Coup"
L.aw_fst4_text  = "a envoyé le premier (bon) coup pour les terroristes innocents en abattant en premier un traitre."

L.aw_all1_title = "Le Plus Mortel Parmi Ses Pairs"
L.aw_all1_text  = "est responsable de tous les meurtres des innocents ce round."

L.aw_all2_title = "Loup Solitaire"
L.aw_all2_text  = "est responsable de tous les meurtres des traitres ce round."

L.aw_nkt1_title = "J'en Ai Eu Un, Patron !"
L.aw_nkt1_text  = "a réussi à tuer un seul innocent. Sympa !"

L.aw_nkt2_title = "Une Balle Pour Deux"
L.aw_nkt2_text  = "a montré que le premier n'était pas un coup de feu chanceux en tuant un autre gaillard."

L.aw_nkt3_title = "Traitre En SÉrie"
L.aw_nkt3_text  = "a terminé trois vies innocentes du terrorisme aujourd'hui."

L.aw_nkt4_title = "Loup Parmi Les Loups-Moutons"
L.aw_nkt4_text  = "mange des innocents pour le diner. Un diner composé de {num} plats."

L.aw_nkt5_title = "Agent Anti-Terrorisme"
L.aw_nkt5_text  = "est payé à chaque assassinat. Il est temps d'acheter un yacht de luxe."

L.aw_nki1_title = "Trahis Donc Ça"
L.aw_nki1_text  = "a trouvé un traitre. Puis il l'a buté. Facile."

L.aw_nki2_title = "PostulÉ pour la Justice Squad"
L.aw_nki2_text  = "a escorté deux traitres dans l'au-delà."

L.aw_nki3_title = "Est-ce Que Les Traitres RÊvent De Moutons Traitres ?"
L.aw_nki3_text  = "a descendu trois traites."

L.aw_nki4_title = "EmployÉ d'Affaires Internes"
L.aw_nki4_text  = "est payé à chaque assassinat. Il est temps de commander une cinquième piscine."

L.aw_fal1_title = "Non M. Bond, Je M'attends À Ce Que Vous Tombiez"
L.aw_fal1_text  = "a poussé quelqu'un d'une grande altitude."

L.aw_fal2_title = "AtterrÉ"
L.aw_fal2_text  = "a laissé son corps se fracasser sur le sol après être tombé d'une grande altitude."

L.aw_fal3_title = "La MÉtÉorite Humaine"
L.aw_fal3_text  = "a écrasé quelqu'un en lui tombant dessus d'une haute altitude."

L.aw_hed1_title = "EfficacitÉ"
L.aw_hed1_text  = "a découvert la joie des headshots et en a fait {num}."

L.aw_hed2_title = "Neurologie"
L.aw_hed2_text  = "a retiré le cerveau de {num} têtes après un examen minutieux."

L.aw_hed3_title = "C'est À Cause Des Jeux-Vidéos"
L.aw_hed3_text  = "n'a fait qu'appliquer son entraînement d'assassin et a headshot {num} ennemis."

L.aw_cbr1_title = "Plonk Plonk Plonk"
L.aw_cbr1_text  = "a bon poignet avec son pied de biche, et {num} victimes en sont témoins."

L.aw_cbr2_title = "Freeman"
L.aw_cbr2_text  = "a recouvert son pied de biche des cerveaux de pas moins de {num} personnes."

L.aw_pst1_title = "Le P'tit Salaud Persistant"
L.aw_pst1_text  = "a tué {num} personnes avec un pistolet. Puis ils ont embrassé quelqu'un jusqu'à sa mort."

L.aw_pst2_title = "Massacre Petit Calibre"
L.aw_pst2_text  = "a tué une petite armée de {num} personnes avec un pistolet. Il a vraisemblablement installé un petit fusil à pompe dans le canon."

L.aw_sgn1_title = "Mode Facile"
L.aw_sgn1_text  = "mets les balles où ça fait mal, {num} terroristes en ont fait les frais."

L.aw_sgn2_title = "1000 Petites Balles"
L.aw_sgn2_text  = "n'aimait pas vraiment son plomb, donc il a tout donné. {num} n'ont pas pu apprécier le moment."

L.aw_rfl1_title = "Point and Click"
L.aw_rfl1_text  = "montre que tout ce dont vous avez besoin pour descendre {num} cibles est un fusil est une bonne main."

L.aw_rfl2_title = "Je Peux Voir Ta TÊte D'ici !"
L.aw_rfl2_text  = "connait son fusil. Maintenant {num} autres le connaissent aussi."

L.aw_dgl1_title = "C'est Comme Un, Un Petit Fusil"
L.aw_dgl1_text  = "commence à se débrouiller avec le Desert Eagle et a tué {num} joueurs."

L.aw_dgl2_title = "MaÎtre de l'Aigle"
L.aw_dgl2_text  = "a flingué {num} joueurs avec le deagle."

L.aw_mac1_title = "Prier et Tuer"
L.aw_mac1_text  = "a tué {num} personnes avec le MAC10, mais ne compte pas dire combien de munitions il a utilisé."

L.aw_mac2_title = "Mac 'n' Cheese"
L.aw_mac2_text  = "se demande ce qu'il se passerai s'il pouvait porter deux MAC10. {num} fois deux ça fait ?"

L.aw_sip1_title = "Silence"
L.aw_sip1_text  = "a fermé le clapet à {num} piplette(s) avec un pistolet silencieux."

L.aw_sip2_title = "Assassin Silencieux"
L.aw_sip2_text  = "a tué {num} personnes qui ne se sont pas entendu mourir."

L.aw_knf1_title = "Le Couteau Qui Te ConnaÎt"
L.aw_knf1_text  = "a poignardé quelqu'un en pleine tête devant tout internet."

L.aw_knf2_title = "OÛ Est-Ce Que T'as TrouvÉ Ça  ?"
L.aw_knf2_text  = "n'était pas un Traitre, mais a quand même terrassé quelqu'un avec un couteau."

L.aw_knf3_title = "Regardez, C'est L'Homme Au Couteau !"
L.aw_knf3_text  = "a trouvé {num} couteaux qui gisaient, et les a utilisés."

L.aw_knf4_title = "Le Plus Gros Couteau Du Monde"
L.aw_knf4_text  = "a tué {num} avec un couteau. Ne me demandez pas comment."

L.aw_flg1_title = "À la rescousse"
L.aw_flg1_text  = "a utilisé son pistolet de détresse pour {num} morts."

L.aw_flg2_title = "FusÉe = Feu"
L.aw_flg2_text  = "a montré à {num} hommes comme c'est dangereux de porter des vêtements inflammables."

L.aw_hug1_title = "Expansion Digne D'un H.U.G.E"
L.aw_hug1_text  = "a été en harmonie avec son H.U.G.E, et s'est débrouillé pour faire en sorte que les balles tuent {num} hommes."

L.aw_hug2_title = "Un Para Patient"
L.aw_hug2_text  = "n'a fait que tirer, et a vu sa -H.U.G.E- patience le récompenser de {num} éliminations."

L.aw_msx1_title = "Poot Poot Poot"
L.aw_msx1_text  = "a dégommé {num} victimes avec le M16."

L.aw_msx2_title = "Folie Moyenne PortÉe"
L.aw_msx2_text  = "sais démonter avec le M16, et il l'a prouvé à {num} victimes."

L.aw_tkl1_title = "Oups..."
L.aw_tkl1_text  = "a vu son doigt glisser quand il visait un copain."

L.aw_tkl2_title = "Double Oups"
L.aw_tkl2_text  = "a cru qu'il a eu deux Traitres, mais s'est les deux fois trompé."

L.aw_tkl3_title = "OÙ Est Mon Karma ?!"
L.aw_tkl3_text  = "ne s'est pas arrêté après avoir buté deux coéquipiers. Trois c'est son nombre chanceux."

L.aw_tkl4_title = "Équipocide"
L.aw_tkl4_text  = "a massacré son équipe toute entière. OMGBANBANBAN."

L.aw_tkl5_title = "Roleplayer"
L.aw_tkl5_text  = "a pris le rôle d'un malade, mais vraiment. C'est pour ça qu'il a tué la plupart de son équipe."

L.aw_tkl6_title = "Abruti"
L.aw_tkl6_text  = "n'a pas compris dans quel camp il était, et il a tué le moitié de ses camarades."

L.aw_tkl7_title = "Plouc"
L.aw_tkl7_text  = "a vraiment bien protégé son territoire en tuant plus d'un quart des ses collègues."

L.aw_brn1_title = "Comme Mamie Me Les Faisait"
L.aw_brn1_text  = "a frit quelques hommes pour les rendre croustillants."

L.aw_brn2_title = "PyroÏde"
L.aw_brn2_text  = "a été entendu rire aux éclats après avoir brûlé un paquet de ses victimes."

L.aw_brn3_title = "BrÛleur Pyrrhique"
L.aw_brn3_text  = "les a tous cramés, et maintenant il est à court de grenades incendiaires ! Comment va-t-il surmonter ça !  ?"

L.aw_fnd1_title = "MÉdecin LÉgiste"
L.aw_fnd1_text  = "a trouvé {num} corps qui traînaient."

L.aw_fnd2_title = "Attrapez Les Tous"
L.aw_fnd2_text  = "a trouvé {num} corps pour sa collection."

L.aw_fnd3_title = "ArÔme De Mort"
L.aw_fnd3_text  = "n'arrête pas de tomber sur des corps au hasard comme ça, {num} fois pour ce round."

L.aw_crd1_title = "Recycleur"
L.aw_crd1_text  = "a rassemblé {num} crédits des corps."

L.aw_tod1_title = "Victoire À la Pyrrhus"
L.aw_tod1_text  = "n'est mort que quelques secondes avant que son équipe remporte la victoire."

L.aw_tod2_title = "Je Hais Ce Jeu"
L.aw_tod2_text  = "est mort juste après que le round ait commencé."

--- New and modified pieces of text are placed below this point, marked with the
--- version in which they were added, to make updating translations easier.

--- v24
L.drop_no_ammo = "Pas assez de munitions dans le chargeur de votre arme pour les jeter en tant que boîte de munitions."

--- 2015-05-25
L.hat_retrieve = "Vous avez ramassé le chapeau d'un Détective."

--- 2017-09-03
L.sb_sortby = "Trier Par :"

--- 2018-07-24
L.equip_tooltip_main = "Menu d'Équipement"
L.equip_tooltip_radar = "Contrôle Radar"
L.equip_tooltip_disguise = "Contrôle Déguisement"
L.equip_tooltip_radio = "Contrôle Radar"
L.equip_tooltip_xfer = "Transfert crédits"
L.equip_tooltip_reroll = "Reroll Items"

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
L.reroll_menutitle = "Reroll Items"
L.reroll_no_credits = "Tu as besoin de {amount} crédits pour reroll!"
L.reroll_button = "Reroll"
L.reroll_help = "Utiliser {amount} crédits pour obtenir un nouvelle item du shop!"

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
L.shop_settings_desc = "Changer les valeurs pour adapter les Random Shop ConVars . N'oubliez pas de sauvegarder vos modifications!"

L.bindings_new = "Nouvelle touche choisis pour {name}: {key}"

L.hud_default_failed = "Le HUD {hudname} n'a pas été défini comme nouveau paramètre par défaut. Vous n'avez pas la permission de ça faire, ou bien ce HUD n'existe pas."
L.hud_forced_failed = "Échec du chargement du HUD {hudname}. Vous n'avez pas la permission de le faire, ou bien ce HUD n'existe pas."
L.hud_restricted_failed = "Echec de la restriction du HUD {hudname}. Vous n'avez pas la permission de le faire."

L.shop_role_select = "Sélectionnez un rôle"
L.shop_role_selected = "{role}'s shop a été sélectionné!"
L.shop_search = "Recherche"

L.spec_help = "Cliquez pour voir la vue du joueur, ou {usekey} sur un objet pour en prendre possession."
L.spec_help2 = "Pour quitter le mode spectateur, ouvrez le menu en appuyant sur {helpkey}, allez vers Jouabilité -> Général -> Paramètres de jeu -> 'Mode Spectateur-only'."

-- 2019-10-19
L.drop_ammo_prevented = "Quelque chose vous empêche de lâcher vos munitions."

-- 2019-10-28
L.target_c4 = "Appuyez sur [{usekey}] pour ouvrir le menu C4"
L.target_c4_armed = "Appuyez sur [{usekey}] pour désarmer le C4"
L.target_c4_armed_defuser = "Appuyez sur [{usekey}] pour utiliser le désamorçage"
L.target_c4_not_disarmable = "Vous ne pouvez pas désamorcer le C4 d'un autre Traitre, à moins qu'il soit mort"
L.c4_short_desc = "Quelque chose de très explosif"

L.target_pickup = "Appuyez sur [{usekey}] pour ramasser"
L.target_slot_info = "Emplacement: {slot}"
L.target_pickup_weapon = "Appuyez sur [{usekey}] pour ramasser l'arme"
L.target_switch_weapon = "Appuyez sur [{usekey}] pour changer d'arme"
L.target_pickup_weapon_hidden = ", Appuyez sur [{usekey} + {walkkey}] pour le ramasser discrètement"
L.target_switch_weapon_hidden = ", Appuyez sur [{usekey} + {walkkey}] pour changer discrètement"
L.target_switch_weapon_nospace = "Il n'y a pas de slot d'inventaire disponible pour cette arme"
L.target_switch_drop_weapon_info = "Lâcher {name} du slot {slot}"
L.target_switch_drop_weapon_info_noslot = "Il n'y a pas d'arme a lâcher  dans ce slot {slot}"

L.corpse_searched_by_detective = "Ce cadavre a été fouillé par un détective"
L.corpse_too_far_away = "Ce cadavre est trop loin."

L.radio_pickup_wrong_team = "Vous ne pouvez pas prendre la radio d'une autre team."
L.radio_short_desc = "Les sons des armes sont de la musique pour moi"

L.hstation_subtitle = "Appuiez sur [{usekey}] pour recevoir ds soins."
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
L.tbut_role_config = "Role: {current}"
L.tbut_team_toggle = "Appuyez sur [SHIFT + {walkkey} + {usekey}] pour basculer ce bouton pour la team {team}"
L.tbut_team_config = "Team: {current}"
L.tbut_current_config = "Configuration actuelle:"
L.tbut_intended_config = "Configuration prévue par le créateur de la carte:"
L.tbut_admin_mode_only = "Uniquement visible pour vous parce que vous êtes un administrateur et que '{cv}' est réglé sur '1'"
L.tbut_allow = "Autoriser"
L.tbut_prohib = "Interdire"
L.tbut_default = "Par défaut"

-- 2020-02-09
L.name_door = "Porte"
L.door_open = "Appuyez sur [{usekey}] pour ouvrir la porte."
L.door_close = "Appuyez sur [{usekey}] pour fermer la porte."
L.door_locked = "Cette porte est verrouillé"

-- 2020-02-11
L.automoved_to_spec = "(AUTOMATED MESSAGE) Vous avez été transféré dans la team Spectateur car vous était inactif/AFK."
L.mute_team = "{team} muet."

-- 2020-02-16
L.door_auto_closes = "Cette porte se ferme automatiquement"
L.door_open_touch = "Marchez vers la porte pour l'ouvrir."
L.door_open_touch_and_use = "Marchez vers la porte ou appuyez sur [{usekey}] pour ouvrir."
L.hud_health = "SantÉ"

-- 2020-03-09
L.help_title = "Aide et paramètres"

L.menu_changelog_title = "Changelog"
L.menu_guide_title = "TTT2 Guide"
L.menu_bindings_title = "Key Bindings"
L.menu_language_title = "Langue"
L.menu_appearance_title = "Apparence"
L.menu_gameplay_title = "Jouabilité"
L.menu_addons_title = "Addons"
L.menu_legacy_title = "Legacy Addons"
L.menu_administration_title = "Administration"
L.menu_equipment_title = "Édité l'équipement"
L.menu_shops_title = "Édité les Shops"

L.menu_changelog_description = "Une liste de changements et de corrections dans les versions récentes"
L.menu_guide_description = "Vous aide à démarrer avec TTT2 et vous explique certaines choses sur le gameplay, les rôles et d'autres choses"
L.menu_bindings_description = "Lie les caractéristiques spécifiques de TTT2 et de ses addons à votre guise"
L.menu_language_description = "Sélectionnez la langue du jeu"
L.menu_appearance_description = "Modifier l'apparence et la performance de votre UI"
L.menu_gameplay_description = "Empêcher des rôles et modifier certains éléments"
L.menu_addons_description = "Configurer les addons locaux à votre convenance"
L.menu_legacy_description = "Une interface avec des onglets convertis à partir du TTT original, ils devraient être portés sur le nouveau système"
L.menu_administration_description = "Paramètres généraux pour les HUD, les shop, etc."
L.menu_equipment_description = "Fixer les crédits, les limites, la disponibilité et d'autres choses"
L.menu_shops_description = "Ajouter/supprimer des shop aux rôles et définir les équipements qu'ils contiennent"

L.submenu_guide_gameplay_title = "Jouabilité"
L.submenu_guide_roles_title = "Rôles"
L.submenu_guide_equipment_title = "Équipement"

L.submenu_bindings_bindings_title = "Bindings"

L.submenu_language_language_title = "Langue"

L.submenu_appearance_general_title = "Général"
L.submenu_appearance_hudswitcher_title = "HUD Switcher"
L.submenu_appearance_vskin_title = "VSkin"
L.submenu_appearance_targetid_title = "TargetID"
L.submenu_appearance_shop_title = "Paramètres des Shop"
L.submenu_appearance_crosshair_title = "Réticule"
L.submenu_appearance_dmgindicator_title = "Indicateur de dégats"
L.submenu_appearance_performance_title = "Performance"
L.submenu_appearance_interface_title = "Interface"
L.submenu_appearance_miscellaneous_title = "Autre"

L.submenu_gameplay_general_title = "Général"
L.submenu_gameplay_avoidroles_title = "Blacklistage de role"

L.submenu_administration_hud_title = "HUD Settings"
L.submenu_administration_random_shop = "Shop Aléatoire"

L.help_color_desc = "Si ce paramètre est activé, il est possible de choisir une couleur globale qui sera utilisée pour le contour du targetID et le réticule."
L.help_scale_factor = "L'échelle influence tous les éléments de l'UI (HUD, vgui et targetID). Il est automatiquement mis à jour si la résolution de l'écran est modifiée. La modification de cette valeur entraîne la réinitialisation du HUD!"
L.help_hud_game_reload = "Le HUD n'est pas disponible pour le moment. Le jeu doit être rechargé."
L.help_hud_special_settings = "Voici les paramètres spécifiques de ce HUD."
L.help_vskin_info = "VSkin (vgui skin) est le skin appliquée à tous les éléments du menu comme celui en cours. Les skins peuvent être facilement créés avec un simple script lua et peuvent changer les couleurs et la taille de certains paramètres."
L.help_targetid_info = "TargetID est l'information rendue lors de la focalisation d'une entité. Une couleur fixe peut être définie dans le panneau des paramètres généraux."
L.help_hud_default_desc = "Définissez le HUD par défaut pour tous les joueurs. Les joueurs qui n'ont pas encore sélectionné de HUD recevront ce HUD par défaut. Cela ne changera pas le HUD des joueurs qui ont déjà sélectionné leur HUD."
L.help_hud_forced_desc = "Forcer un HUD pour tous les joueurs. Cela désactive la fonction de sélection du HUD pour tous."
L.help_hud_enabled_desc = "Activer/désactiver les HUD pour restreindre la sélection de ces HUD."
L.help_damage_indicator_desc = "L'indicateur de dégâts est la couche affichée lorsque le joueur prends des dégâts. Pour ajouter un nouveau thème, placez un png dans 'materials/vgui/ttt/damageindicator/themes/'."
L.help_shop_key_desc = "Ouvrez le shop en appuyant sur votre touche de shop (c par défaut) au lieu du menu 'score' pendant la préparation / à la fin du round?"

L.label_menu_menu = "MENU"
L.label_menu_admin_spacer = "Zone d'administration (cachée aux utilisateurs normaux)"
L.label_language_set = "Sélectionnez une langue"
L.label_global_color_enable = "Activer les couleur globale"
L.label_global_color = "Couleur globale"
L.label_global_scale_factor = "Taille de l'interface"
L.label_hud_select = "Selectionnez un HUD"
L.label_vskin_select = "Selectionnez un VSkin"
L.label_blur_enable = "Activer le flou a l'arrière-plan du VSkin"
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
L.label_crosshair_gap_enable = "Activer le réticule centrer"
L.label_crosshair_gap = "Personnalisé l'écartement du Réticule centrer"
L.label_crosshair_opacity = "Opacité du réticule"
L.label_crosshair_ironsight_opacity = "Opacité du réticule du viseur"
L.label_crosshair_size = "Taille du réticule"
L.label_crosshair_thickness = "Épaisseur du réticule"
L.label_crosshair_thickness_outline = "Épaisseur du contour du réticule"
L.label_crosshair_static_enable = "Activer le réticule statique"
L.label_crosshair_dot_enable = "Activer le point du réticule "
L.label_crosshair_lines_enable = "Activer les lignes du réticule"
L.label_crosshair_scale_enable = "Activer la dépendance du réticule par rapport au type d'arme"
L.label_crosshair_ironsight_low_enabled = "Baissez votre arme lorsque vous utilisez le viseur"
L.label_damage_indicator_enable = "Activer l'indicateur de dégats"
L.label_damage_indicator_mode = "Sélectionnez le thème de l'indicateur de dégats"
L.label_damage_indicator_duration = "Temps d'affichage de l'indicateur de dégats"
L.label_damage_indicator_maxdamage = "Dommages nécessaires pour une opacité maximale"
L.label_damage_indicator_maxalpha = "Opacité maximale de l'indicateurs de dégats "
L.label_performance_halo_enable = "Dessinez un contour autour de certaines entités quand vous les regardez"
L.label_performance_spec_outline_enable = "Activer les contours des objets contrôlés"
L.label_performance_ohicon_enable = "Activer les icônes des rôle"
L.label_interface_tips_enable = "Afficher des conseils de jeu au bas de l'écran en mode spectateur"
L.label_interface_popup = "Durée du popup début de round"
L.label_interface_fastsw_menu = "Activer le menu avec un changement d'arme rapide"
L.label_inferface_wswitch_hide_enable = "Activer la fermeture automatique du menu quand je change d'arme"
L.label_inferface_scues_enable = "Jouer un son au début ou à la fin d'un round"
L.label_gameplay_specmode = "Mode Spectateur-only (rester toujours en spectateur)"
L.label_gameplay_fastsw = "Changement d'arme rapide"
L.label_gameplay_hold_aim = "Permettre de maintenir pour viser"
L.label_gameplay_mute = "Mettez en sourdine les joueurs vivants lorsqu'ils sont morts"
L.label_gameplay_dtsprint_enable = "Permettre le sprint en appuyant deux fois sur la touche Avancer"
L.label_gameplay_dtsprint_anykey = "Continuez à sprinter en appuyant deux fois sur la touche Avancer jusqu'à ce que vous arrêtiez de bouger"
L.label_hud_default = "HUD par défaut"
L.label_hud_force = "HUD Obligatoire"

L.label_bind_weaponswitch = "Ramasser une arme"
L.label_bind_sprint = "Sprint"
L.label_bind_voice = "Chat Vocal Global"
L.label_bind_voice_team = "Chat Vocal Team"

L.label_hud_basecolor = "Couleur de base"

L.label_menu_not_populated = "Ce sous-menu ne contient aucun contenu."

L.header_bindings_ttt2 = "TTT2 Bindings"
L.header_bindings_other = "Autre Bindings"
L.header_language = "Paramètres de langue"
L.header_global_color = "Select Global Color"
L.header_hud_select = "Sélectionnez un HUD"
L.header_hud_customize = "Personnaliser le HUD"
L.header_vskin_select = "Sélectionnez et personnalisez le VSkin"
L.header_targetid = "Paramètres TargetID"
L.header_shop_settings = "Paramètres du shop d'équipement"
L.header_shop_layout = "Mise en page de la liste des objets"
L.header_shop_marker = "Paramètres des marqueurs d'objet"
L.header_crosshair_settings = "Réglages du réticule"
L.header_damage_indicator = "Paramètres des indicateurs de dégats"
L.header_performance_settings = "Paramètres de performance"
L.header_interface_settings = "Paramètres de l'interface"
L.header_gameplay_settings = "Paramètres de jeu"
L.header_roleselection = "Activez/Desactiver l'attribution des rôles"
L.header_hud_administration = "Sélectionnez  le HUDs par Défaut et Obligatoire"
L.header_hud_enabled = "Activer/Désactiver HUDs"

L.button_menu_back = "Retour"
L.button_none = "Aucun"
L.button_press_key = "Appuyez sur une touche"
L.button_save = "Sauvegarder"
L.button_reset = "RÉinitialiser"
L.button_close = "Fermer"
L.button_hud_editor = "HUD Éditeur"

-- 2020-04-20
L.item_speedrun = "Speedrun"
L.item_speedrun_desc = [[Vous rend 50 % plus rapide!]]
L.item_no_explosion_damage = "Pas de dégâts d'explosion"
L.item_no_explosion_damage_desc = [[Vous immunise contre les dégats causés par les explosions.]]
L.item_no_fall_damage = "Pas de dégâts dus aux chutes"
L.item_no_fall_damage_desc = [[Vous immunise contre les dégats causés par les chutes.]]
L.item_no_fire_damage = "Pas de dégâts dus au feu"
L.item_no_fire_damage_desc = [[Vous immunise contre les dégâts causés par le feu.]]
L.item_no_hazard_damage = "Pas de dégâts dus au radiations"
L.item_no_hazard_damage_desc = [[Vous immunise contre les dégâts causés par le poison, les radiations et les acides.]]
L.item_no_energy_damage = "Pas de dégâts énergétiques"
L.item_no_energy_damage_desc = [[vous immunise contre les dégâts énergétiques tels que les lasers, le plasma et l'électricité.]]
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
L.confirm_detective_only = "Seuls les détectives peuvent confirmer les corps"
L.inspect_detective_only = "Seuls les détectives peuvent inspecter les corps"
L.corpse_hint_no_inspect = "Seuls les inspecteurs peuvent fouiller ce corps."
L.corpse_hint_inspect_only = "Appuyez sur [{usekey}] pour effectuer une recherche. Seuls les détectives peuvent confirmer le corps."
L.corpse_hint_inspect_only_credits = "Appuyez sur [{usekey}] pour recevoir des crédits. Seuls les détectives peuvent fouiller ce corps."

-- 2020-06-04
L.label_bind_disguiser = "Activer/Désactiver le déguisement"

-- 2020-06-24
L.dna_help_primary = "Prélever un échantillon d'ADN"
L.dna_help_secondary = "Changer le slot de l'ADN"
L.dna_help_reload = "Supprimer un échantillon"

L.binoc_help_pri = "Identifier un corps."
L.binoc_help_sec = "Changer le niveau de zoom."

L.vis_help_pri = "Lâcher l'appareil activé."

L.decoy_help_pri = "Planter le leurre."

-- 2020-08-07
L.pickup_error_spec = "Vous ne pouvez pas prendre cela en tant que spectateur."
L.pickup_error_owns = "Vous ne pouvez pas prendre ça parce que vous avez déjà cette arme."
L.pickup_error_noslot = "Vous ne pouvez pas prendre cela car vous n'avez pas de slot libre."
