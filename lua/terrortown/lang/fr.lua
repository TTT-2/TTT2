-- French language strings

local L = LANG.CreateLanguage("fr")

-- Compatibility language name that might be removed soon.
-- the alias name is based on the original TTT language name:
-- https://github.com/Facepunch/garrysmod/blob/master/garrysmod/gamemodes/terrortown/gamemode/lang/french.lua
L.__alias = "français"

L.lang_name = "Français (French)"

-- General text used in various places
L.traitor = "Traître"
L.detective = "Détective"
L.innocent = "Innocent"
L.last_words = "Derniers mots"

L.terrorists = "Terroristes"
L.spectators = "Spectateurs"

L.nones = "Sans Équipe"
L.innocents = "Équipe des Innocents"
L.traitors = "Équipe des Traîtres"

-- Round status messages
L.round_minplayers = "Pas assez de joueurs pour commencer une nouvelle partie..."
L.round_voting = "Un vote est en cours, la partie est retardé de {num} secondes..."
L.round_begintime = "Une nouvelle partie commencera dans {num} secondes. Préparez-vous."

L.round_traitors_one = "Traître, vous êtes seul."
L.round_traitors_more = "Traîtres, voici vos alliés: {names}"

L.win_time = "Temps écoulé. Les Traîtres ont perdu."
L.win_traitors = "Les Traîtres ont gagné !"
L.win_innocents = "Les Traîtres ont été vaincus !"
L.win_nones = "Les Abeilles ont gagné !"
L.win_showreport = "Regardons le rapport de la partie {num} secondes."

L.limit_round = "Limite de partie atteinte. La prochaine carte va bientôt chargée."
L.limit_time = "Limite de temps atteinte. La prochaine carte va bientôt chargée."
L.limit_left_session_mode_1 = "Il reste {num} partie(s) ou {time} minutes avant que la carte change."
--L.limit_left_session_mode_2 = "{time} minutes remaining before the map changes."
--L.limit_left_session_mode_3 = "{num} round(s) remaining before the map changes."

-- Credit awards
L.credit_all = "Vous êtes récompensés de {num} crédit(s) pour vos performances."
L.credit_kill = "Vous avez reçu {num} crédit(s) pour avoir tué un {role}."

-- Karma
L.karma_dmg_full = "Votre Karma est à {amount}, vous infligerez donc des dégâts normaux cette partie !"
L.karma_dmg_other = "Votre Karma est à {amount}. De ce fait, tous les dégâts que vous infligerez seront réduits de {num}%"

-- Body identification messages
L.body_found = "{finder} à trouvé le corps de {victim}. {role}"
L.body_found_team = "{finder} à trouvé le corps de {victim}. {role} ({team})"

-- The {role} in body_found will be replaced by one of the following:
L.body_found_traitor = "C'était un Traître !"
L.body_found_det = "C'était un Détective."
L.body_found_inno = "C'était un Innocent."

L.body_call = "{player} appelle un Détective sur le corps de {victim} !"
L.body_call_error = "Veuillez identifier le corps avant d'appeler un Détective !"

L.body_burning = "Aie! Ce corps est en feu !"
L.body_credits = "Vous avez trouvé {num} crédit(s) sur le corps !"

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

L.equip_help_stock = "Certains objets ne peuvent être achetés qu'une fois par partie."
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
L.disg_not_owned = "Vous n'avez pas de déguisement !"
L.disg_enable = "Activer le déguisement"

L.disg_help1 = "Lorsque votre déguisement est actif, votre nom, santé et karma ne sont pas visibles quand quelqu'un vous regarde. De plus, vous n'apparaîtrez pas sur le radar du Détective."
L.disg_help2 = "Appuyez sur Entrée du Pavé-Numérique pour activer/désactiver le déguisement sans le menu. Vous pouvez aussi choisir une autre touche en appuyant sur F1 -> Configuration."

-- Radar tab in equipment menu
L.radar_name = "Radar"
L.radar_menutitle = "Contrôle du radar"
L.radar_not_owned = "Vous n'avez pas de Radar !"
L.radar_scan = "Scanner"
L.radar_auto = "Scanner à répétition"
L.radar_help = "Les résultats du scan restent pendant {num} secondes, après cela le Radar devra recharger et pourra être utilisé de nouveau."
L.radar_charging = "Votre Radar charge !"

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
L.intro_help = "Si vous êtes nouveau, appuyez sur F1 pour lire les instructions !"

-- Radiocommands/quickchat
L.quick_title = "Touches de Tchat-rapide"

L.quick_yes = "Oui."
L.quick_no = "Non."
L.quick_help = "À l'aide !"
L.quick_imwith = "Je suis avec {player}."
L.quick_see = "Je vois {player}."
L.quick_suspect = "{player} est suspect."
L.quick_traitor = "{player} est un traître !"
L.quick_inno = "{player} est innocent."
L.quick_check = "Quelqu'un est encore en vie ?"

-- {player} in the quickchat text normally becomes a player nickname, but can
-- also be one of the below.  Keep these lowercase.
L.quick_nobody = "Personne"
L.quick_disg = "Quelqu'un de déguisé"
L.quick_corpse = "un corps non-identifié"
L.quick_corpse_id = "le corps de {player}"

-- Scoreboard
L.sb_playing = "Vous jouez sur..."
L.sb_mapchange_mode_0 = "Les limites de partie sont désactivées."
L.sb_mapchange_mode_1 = "Changement de carte dans {num} partie(s) ou dans {time}"
--L.sb_mapchange_mode_2 = "Map changes in {time}"
--L.sb_mapchange_mode_3 = "Map changes in {num} rounds"

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
L.buy_no_stock = "Cette arme est en rupture de stock: vous l'avez déjà acheté durant cette partie."
L.buy_pending = "Vous avez déjà une commande en attente, attendez de la recevoir d'abord."
L.buy_received = "Vous avez reçu votre équipement spécial."

L.drop_no_room = "Il n'y a pas la place pour jeter votre arme !"

L.disg_turned_on = "Déguisement activé !"
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

L.c4_disarm_t = "Coupez un fil pour désamorcer la bombe. En tant que Traître, tous les fils fonctionneront. Les innocents n'ont pas cette chance !"
L.c4_disarm_owned = "Coupez un fil pour désamorcer la bombe. C'est votre bombe, donc tous les fils fonctionneront."
L.c4_disarm_other = "Coupez un fil pour désamorcer la bombe. Si vous vous trompez, ça va péter !"

L.c4_status_armed = "ARMÉE"
L.c4_status_disarmed = "DÉSARMÉE"

-- Visualizer
L.vis_name = "Visualiseur"

L.vis_desc = [[
Dispositif de visualisation de scène de crime.

Analyse un corps pour montrer comment la victime a été tuée, mais seulement s'il est mort d'un coup de feu.]]

-- Decoy
L.decoy_name = "Leurre"
L.decoy_broken = "Votre leurre a été détruit !"

L.decoy_short_desc = "Ce leurre montre un faux signal radar visible par les autres équipes"
L.decoy_pickup_wrong_team = "Vous ne pouvez pas le ramasser, car il appartient à une autre équipe"

L.decoy_desc = [[
Montre un faux signe sur le radar des autres équipes, et fait que leur scanner ADN montre la position du leurre s'il cherche le vôtre.]]

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

L.hstation_broken = "Votre Station de Soins a été détruite !"

L.hstation_desc = [[
Soigne les personnes qui l'utilisent.

Recharge lente. Tout le monde peut l'utiliser, et elle peut être endommagée. On peut en extraire des échantillons ADN de ses utilisateurs.]]

-- Knife
L.knife_name = "Couteau"
L.knife_thrown = "Couteau lancé"

L.knife_desc = [[
Tue les cibles blessées sur-le-champ et sans faire de bruit, mais à usage unique.

Peut-être lancé avec le tir secondaire.]]

-- Poltergeist
L.polter_desc = [[
Plante des propulseurs sur des objets pour les propulser violemment.

Ces éclats d'énergie peuvent frapper les gens à proximité.]]

-- Radio
L.radio_broken = "Votre Radio a été détruite !"

-- Silenced pistol
L.sipistol_name = "Pistolet Silencieux"

L.sipistol_desc = [[
Pistolet bas bruit, utilise des munitions de pistolet normales.

Les victimes ne crieront pas quand elles sont tuées.]]

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
L.dna_killer = "Échantillon ADN du tueur récupéré sur le corps !"
L.dna_duplicate = "Correspondance ! Vous avez déjà cet échantillon ADN dans votre scanner."
L.dna_no_killer = "L'ADN n'a pas pu être récupéré (le tueur s'est déconnecté?)."
L.dna_armed = "La bombe est amorcée ! Désamorcez-la d'abord !"
L.dna_object = "Prélèvement d'un échantillon du dernier propriétaire de l'objet."
L.dna_gone = "Aucun ADN détecté dans la zone."

L.dna_desc = [[
Collectez des échantillons ADN d'objets et utilisez-les pour trouver le propriétaire de cet ADN.

Essayez-le sur des corps tout frais pour récupérer l'ADN du tueur pour le traquer.]]

-- Magneto stick
L.magnet_name = "Magnéto-stick"

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

L.tele_no_ground = "Impossible de se téléporter à moins d'être sur un sol solide !"
L.tele_no_crouch = "Impossible de se téléporter en étant accroupi !"
L.tele_no_mark = "Aucune position marquée. Marquez une destination avant de vous téléporter."

L.tele_no_mark_ground = "Impossible de marquer une position à moins d'être sur un sol solide !"
L.tele_no_mark_crouch = "Impossible de marquer une position en étant accroupi !"

L.tele_help_pri = "Téléporte à la position marquée"
L.tele_help_sec = "Marque la position actuelle"

L.tele_desc = [[
Téléporte vers un lieu marqué.

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
L.hp_death = "Proche de la mort"

-- TargetID Karma status
L.karma_max = "Réputé"
L.karma_high = "Honnête"
L.karma_med = "Gâchette facile"
L.karma_low = "Dangereux"
L.karma_min = "Irresponsable"

-- TargetID misc
L.corpse = "Corps"
L.corpse_hint = "Appuyez sur [{usekey}] pour fouiller et confirmer un corps. Appuyez sur [{walkkey} + {usekey}] pour fouiller silencieusement."

L.target_disg = "(DÉGUISÉ)"
L.target_unid = "Corps non-identifié"
L.target_unknown = "Un Terroriste"

-- HUD buttons with hand icons that only some roles can see and use
L.tbut_single = "Usage unique"
L.tbut_reuse = "Réutilisable"
L.tbut_retime = "Réutilisable après {num} sec"
L.tbut_help = "Appuyez sur {usekey} pour activer"

-- Spectator muting of living/dead
L.mute_living = "Joueurs vivants muets"
L.mute_specs = "Spectateurs muets"
L.mute_all = "Tous muets"
L.mute_off = "Aucun muets"

-- Spectators and prop possession
L.punch_title = "FRAPPE-O-METRE"
L.punch_bonus = "Votre mauvais score a baissé votre limite frappe-o-metre de {num}"
L.punch_malus = "Votre bon score a augmenté votre limite frappe-o-metre de {num} !"

-- Info popups shown when the round starts
L.info_popup_innocent = [[
Vous êtes un Terroriste Innocent ! Mais il y a des Traîtres qui traînent...
À qui pouvez-vous faire confiance, et qui cherche à vous remplir de balles?

Surveillez vos arrières, et bossez avec vos alliés pour vous sortir d'ici en vie !]]

L.info_popup_detective = [[
Vous êtes un Détective ! Terroriste QG vous a donné des ressources spéciales pour trouver les Traîtres.
Utilisez-les pour aider les innocents à survivre, mais attention:
les traîtres chercheront à vous tuer en premier !

Appuyez sur {menukey} pour recevoir votre équipement !]]

L.info_popup_traitor_alone = [[
Vous êtes un TRAÎTRE ! Vous n'avez pas d'amis traîtres cette partie.

Tuez tout le monde pour gagner !

Appuyez sur {menukey} pour recevoir votre équipement !]]

L.info_popup_traitor = [[
Vous êtes un TRAÎTRE ! Travaillez avec vos amis traîtres pour tuer tout le monde.
Mais faites attention, ou votre trahison pourrait sortir au grand jour...

Voici vos Alliés:
{traitorlist}

Appuyez sur {menukey} pour recevoir votre équipement !]]

-- Various other text
L.name_kick = "Un joueur a été automatiquement expulsé pour avoir changé son nom pendant une partie."

L.idle_popup = [[
Vous avez été inactif {num} secondes et donc été mis en mode Spectateur. Dans ce mode, vous n'apparaîtrez pas quand un nouveau round démarre.

Vous pouvez Rejoindre/Quitter ce mode quand vous voulez en appuyant sur {helpkey} allez vers Jouabilité -> Général -> Paramètres de jeu -> 'Mode Spectateur'.]]

L.idle_popup_close = "Ne rien faire"
L.idle_popup_off = "Désactiver le mode Spectateur"

L.idle_warning = "Attention: on dirait que vous n'êtes plus là, vous allez être déplacés en spectateur sauf si vous montrez de l'activité !"

L.spec_mode_warning = "Vous êtes en mode Spectateur et vous n'apparaîtrez pas quand une partie commencera. Pour désactiver ce mode, appuyez sur F1, allez vers Jouabilité -> Général -> Paramètres de jeu -> 'Mode Spectateur'."

-- Tips panel
L.tips_panel_title = "Astuces"
L.tips_panel_tip = "Astuce:"

-- Tip texts
L.tip1 = "Les Traîtres peuvent fouiller un corps silencieusement, sans confirmer la mort, en maintenant {walkkey} et en pressant {usekey} sur le corps."

L.tip2 = "Amorcer un explosif C4 avec un minuteur plus long va augmenter le nombre de fils qui va causer une explosion imminente quand un innocent essaiera de la désamorcer. Le bip de l'explosif sera moins fort et moins fréquent."

L.tip3 = "Les Détectives peuvent fouiller un corps pour trouver qui est reflété dans ses yeux. C'est la dernière personne que le mort a vue. Ce n'est pas forcément le tueur si le mort a été tué dans le dos."

L.tip4 = "Personne ne saura que vous êtes mort jusqu'à ce qu'ils trouvent votre corps et vous identifient en le fouillant."

L.tip5 = "Quand un Traître tue un Détective, ils reçoivent instantanément un crédit."

L.tip6 = "Quand un Traître meurt, tous les Détectives sont récompensés d'un crédit d'équipement."

L.tip7 = "Quand les Traîtres ont bien avancé pour tuer les innocents, ils recevront un crédit d'équipement comme récompense."

L.tip8 = "Les Traîtres et les Détectives peuvent prendre les crédits d'équipements non-dépensés des corps morts d'autres Traîtres et Détectives."

L.tip9 = "Le Poltergeist peut transformer n'importe quel objet physique en un projectile mortel. Chaque coup est un accompagné de coups d'énergie qui fait mal à tout le monde à proximité."

L.tip10 = "En tant qu'acheteur (rôle ayant une boutique), n'oubliez pas que vous recevez des crédits d'équipement supplémentaires si vous et vos alliés obtenez de bons résultats. N'oubliez pas de les dépenser !"

L.tip11 = "Le scanner ADN des Détectives peut-être utilisé pour collecter des échantillons ADN d'armes et d'objets puis les scanner pour localiser le joueur qui les a utilisés. Pratique quand vous venez d'obtenir un échantillon d'un corps ou d'un C4 désamorcé !"

L.tip12 = "Quand vous êtes proches de quelqu'un quand vous le tuez, un peu de votre ADN est déposé sur le corps. Cet ADN peut être utilisé pour le Scanner ADN d'un Détective pour vous localiser. Vous feriez mieux de cacher le corps quand vous coupez quelqu'un !"

L.tip13 = "Plus vous êtes nombreux quand vous tuez quelqu'un, plus vite votre échantillon d'ADN sur son corps se dégradera."

L.tip14 = "Vous allez tirer au sniper ? Pensez à acheter un Déguisement. Si vous ratez votre tir, fuyez vers un endroit sûr, désactivez le Déguisement et personne ne saura que c'est vous qui leur avez tiré dessus."

L.tip15 = "Si vous avez un Téléporteur, il peut vous aider à fuir lorsque vous êtes poursuivi et vous permet de vous déplacer rapidement sur une grande carte. Assurez-vous de toujours avoir une position sûre de marquée."

L.tip16 = "Les innocents sont tous groupés et vous n'arrivez pas à un en séparer un? Pourquoi pas utiliser la Radio pour jouer des sons de C4 ou d'un coup de feu pour les mener ailleurs?"

L.tip17 = "Avec la Radio, vous pouvez jouer des sons après l'avoir placée. Mettez plusieurs sons en file d'attente dans l'ordre que vous souhaitez."

L.tip18 = "En tant que Détective, si vous avez des crédits en réserve, vous pouvez donner à un innocent de confiance un Kit de désamorçage. Vous pourriez ensuite vous consacrer à un travail sérieux d'investigation et leur laisser les désamorçages risqués."

L.tip19 = "Les Jumelles des Détectives permettent une vue et une fouille longue portée des corps. Ce n'est pas bon pour les Traîtres s'ils espéraient utiliser un corps comme appât. Bien sûr, ceux qui utilisent les jumelles sont désarmés et distraits..."

L.tip20 = "La Station de Soins des Détectives laisse les joueurs blessés guérir. Bien sûr, ces gens blessés pourraient bien être des Traîtres..."

L.tip21 = "La Station de Soins enregistre un échantillon ADN de quiconque l'utilise. Les détectives peuvent l'utiliser avec le Scanner ADN pour trouver qui s'est soigné avec."

L.tip22 = "À l'inverse des armes et du C4, le dispositif Radio pour Traîtres ne contiennent pas d'échantillon ADN de la personne qui l'a planté. Ne vous inquiétez donc pas d'un Détective qui gâcherait votre couverture."

L.tip23 = "Appuyez sur {helpkey} pour visionner un petit didacticiel ou modifier certains paramètres spécifiques au mode TTT."

L.tip24 = "Quand un Détective fouille un corps, les résultats sont disponibles pour tous les joueurs à travers le tableau de scores, en cliquant sur le nom de la personne morte."

L.tip25 = "Dans le tableau des scores, une icône de loupe à côté du nom de quelqu'un indique que vous avez déjà cherché des informations à propos de cette personne. Si l'icône est lumineuse, les données viennent d'un Détective et peuvent contenir des informations additionnelles."

L.tip26 = "Les corps dont le nom est marqué d'une loupe ont fait l'objet d'une fouille par un Détective et les résultats de cette fouille sont accessibles à tous les joueurs via le tableau des scores."

L.tip27 = "Les Spectateurs peuvent appuyer sur {mutekey} pour choisir de rendre muet les spectateurs et/ou les joueurs vivants."

L.tip28 = "Vous pouvez changer de langue à tout moment dans les Paramètres en appuyant sur {helpkey}."

L.tip29 = "Les commandes Tchat-rapide ou 'radio' sont accessibles avec {zoomkey}."

L.tip30 = "Le tir secondaire du Pied de biche va pousser les autres joueurs."

L.tip31 = "Tirer à travers le viseur d'une arme augmentera légèrement votre précision et réduira le recul. S'accroupir, en revanche, non."

L.tip32 = "Les grenades fumigènes sont efficaces dans les bâtiments, surtout pour créer de la confusion dans les salles bondées."

L.tip33 = "En tant que Traître, souvenez-vous que vous pouvez porter des corps et les cacher des pauvres yeux implorants des innocents et de leurs Détectives."

L.tip34 = "Sur le tableau des scores, cliquez sur le nom d'un joueur vivant et vous pouvez lui poser un label pour eux comme 'suspect' ou 'ami'. Ce label apparaîtra sur la personne concernée en dessous de votre réticule."

L.tip35 = "Beaucoup des équipements qui sont posables (comme le C4, ou la Radio) peuvent aussi être fixés sur des murs avec le tir secondaire."

L.tip36 = "Le C4 qui explose à cause d'une erreur de déminage a une plus petite explosion qu'un C4 qui atteint zéro sur le minuteur."

L.tip37 = "S'il est indiqué « MODE HÂTIF » au-dessus du temps de la partie, la partie ne durera que quelques minutes, mais à chaque mort, le temps disponible augmente. Ce mode met la pression aux traîtres pour qu'ils fassent avancer les choses."

-- Round report
L.report_title = "Rapport de la partie"

-- Tabs
L.report_tab_hilite = "Temps forts"
L.report_tab_hilite_tip = "Temps forts de la partie"
L.report_tab_events = "Événements"
L.report_tab_events_tip = "Voici les événements qui sont arrivés durant cette partie"
L.report_tab_scores = "Scores"
L.report_tab_scores_tip = "Points marqués par chaque joueur dans cette partie"

-- Event log saving
L.report_save = "Sauv .txt"
L.report_save_tip = "Sauvegarde les logs vers un fichier texte"
L.report_save_error = "Aucune donnée des logs à sauvegarder."
L.report_save_result = "Les logs ont été sauvegardés dans:"

-- Columns
L.col_time = "Temps"
L.col_event = "Événement"
L.col_player = "Joueur"
L.col_roles = "Rôle(s)"
L.col_teams = "Équipe(s)"
L.col_kills1 = "Meurtres des innocents"
L.col_kills2 = "Meurtres des traîtres"
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
L.aw_fst2_text = "a fait la peau le premier a un allié traître. Bon travail."

L.aw_fst3_title = "Premier... Bêtisier"
L.aw_fst3_text = "a été le premier à tuer. Dommage que c'était un allié innocent."

L.aw_fst4_title = "Premier Coup"
L.aw_fst4_text = "a envoyé le premier (bon) coup pour les terroristes innocents en abattant en premier un traître."

L.aw_all1_title = "Le Plus Mortel Parmi Ses Pairs"
L.aw_all1_text = "est responsable de tous les meurtres des innocents cette partie."

L.aw_all2_title = "Loup Solitaire"
L.aw_all2_text = "est responsable de tous les meurtres des traîtres cette partie."

L.aw_nkt1_title = "J'en Ai Eu Un, Patron !"
L.aw_nkt1_text = "a réussi à tuer un seul innocent. Sympa !"

L.aw_nkt2_title = "Une Balle Pour Deux"
L.aw_nkt2_text = "a montré que le premier n'était pas un coup de feu chanceux en tuant un autre gaillard."

L.aw_nkt3_title = "Traître En Série"
L.aw_nkt3_text = "a mis fin à la vie de 3 pauvres terroristes innocents aujourd'hui."

L.aw_nkt4_title = "Loup Parmi Les Loups-Moutons"
L.aw_nkt4_text = "mange des innocents pour le diner. Un diner composé de {num} plats."

L.aw_nkt5_title = "Agent Anti-Terrorisme"
L.aw_nkt5_text = "est payé à chaque assassinat. Il est temps d'acheter un yacht de luxe."

L.aw_nki1_title = "Trahis Donc Ça"
L.aw_nki1_text = "a trouvé un traître. Puis il l'a buté. Facile."

L.aw_nki2_title = "Postulé pour la Justice Squad"
L.aw_nki2_text = "a escorté deux traîtres dans l'au-delà."

L.aw_nki3_title = "Est-ce Que Les Traîtres Rêvent De Moutons Traîtres?"
L.aw_nki3_text = "a descendu trois traîtres."

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

L.aw_rfl2_title = "Je Peux Voir Ta Tête D'ici !"
L.aw_rfl2_text = "connaît son fusil. Maintenant {num} autres le connaissent aussi."

L.aw_dgl1_title = "C'est Comme Un, Un Petit Fusil"
L.aw_dgl1_text = "commence à se débrouiller avec le deagle et a tué {num} joueurs."

L.aw_dgl2_title = "Maître du Deagle"
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
L.aw_knf2_text = "n'était pas un Traître, mais a quand même terrassé quelqu'un avec un couteau."

L.aw_knf3_title = "Regardez, C'est L'Homme Au Couteau !"
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
L.aw_tkl1_text = "a vu son doigt glisser quand il visait un allié."

L.aw_tkl2_title = "Double Oups"
L.aw_tkl2_text = "a cru qu'il a eu deux Traîtres, mais s'est trompé deux fois."

L.aw_tkl3_title = "Oû Est Mon Karma ?!"
L.aw_tkl3_text = "ne s'est pas arrêté après avoir buté deux alliés. Trois c'est son nombre chanceux."

L.aw_tkl4_title = "Équipocide"
L.aw_tkl4_text = "a massacré son équipe tout entière. OMGBANBANBAN."

L.aw_tkl5_title = "Roleplayer"
L.aw_tkl5_text = "a pris le rôle d'un malade, mais vraiment. C'est pour ça qu'il a tué la plupart de son équipe."

L.aw_tkl6_title = "Abruti"
L.aw_tkl6_text = "n'a pas compris dans quel camp il était, et il a tué la moitié de ses alliés."

L.aw_tkl7_title = "Plouc"
L.aw_tkl7_text = "a vraiment bien protéger son territoire en tuant plus d'un quart de ses alliés."

L.aw_brn1_title = "Comme Mamie Me Les Faisait"
L.aw_brn1_text = "a frit quelques hommes pour les rendre croustillants."

L.aw_brn2_title = "Pyroïde"
L.aw_brn2_text = "a été entendu rire aux éclats après avoir brûlé un paquet de ses victimes."

L.aw_brn3_title = "Brûleur Pyrrhique"
L.aw_brn3_text = "les a tous cramés, et maintenant il est à court de grenades incendiaires ! Comment va-t-il surmonter ça !?"

L.aw_fnd1_title = "Médecin Légiste"
L.aw_fnd1_text = "a trouvé {num} corps qui traînaient."

L.aw_fnd2_title = "Attrapez Les Tous"
L.aw_fnd2_text = "a trouvé {num} corps pour sa collection."

L.aw_fnd3_title = "Arôme De Mort"
L.aw_fnd3_text = "n'arrête pas de tomber sur des corps au hasard comme ça, {num} fois pendant cette partie."

L.aw_crd1_title = "Recycleur"
L.aw_crd1_text = "a rassemblé {num} crédits des corps."

L.aw_tod1_title = "Victoire À la Pyrrhus"
L.aw_tod1_text = "n'est mort que quelques secondes avant que son équipe remporte la victoire."

L.aw_tod2_title = "Je Hais Ce Jeu"
L.aw_tod2_text = "est mort juste après que la partie ait commencé."

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
L.equip_tooltip_reroll = "Relancer l'équipement"

L.confgrenade_name = "Discombobulateur"
L.polter_name = "Poltergeist"
L.stungun_name = "Prototype UMP"

L.knife_instant = "MORT INSTANTANÉE"

L.binoc_zoom_level = "NIVEAU DE ZOOM"
L.binoc_body = "CORPS REPÉRÉ"

L.idle_popup_title = "Inactif"

-- 2019-01-31
L.create_own_shop = "Créer sa boutique"
L.shop_link = "Lier avec"
L.shop_disabled = "Désactiver la boutique"
L.shop_default = "Utiliser la boutique par défaut"

-- 2019-05-05
L.reroll_name = "Relance"
L.reroll_menutitle = "Relance d'équipement"
L.reroll_no_credits = "Tu as besoin de {amount} crédit(s) pour relancer !"
L.reroll_button = "Relancer"
L.reroll_help = "Utilise {amount} crédit(s) pour obtenir un nouvel équipement aléatoire dans la boutique !"

-- 2019-05-06
L.equip_not_alive = "Vous pouvez voir tous les items disponibles en sélectionnant un rôle à droite. N'oubliez pas de choisir vos favoris !"

-- 2019-06-27
L.shop_editor_title = "Éditeur de boutique"
L.shop_edit_items_weapong = "Éditer les Objets / Armes"
L.shop_edit = "Éditer la boutique"
L.shop_settings = "Paramètres"
L.shop_select_role = "Sélectionner un rôle"
L.shop_edit_items = "Éditer les objets"
L.shop_edit_shop = "Éditer les boutiques"
L.shop_create_shop = "Créer une boutique personnalisée"
L.shop_selected = "Sélectionné {role}"
L.shop_settings_desc = "Changer les valeurs pour adapter les ConVars des boutiques aléatoires. N'oubliez pas de sauvegarder vos modifications !"

L.bindings_new = "Nouvelle touche choisis pour {name}: {key}"

L.hud_default_failed = "Le HUD {hudname} n'a pas été défini comme nouveau paramètre par défaut. Vous n'avez pas la permission, ou bien ce HUD n'existe pas."
L.hud_forced_failed = "Échec du chargement du HUD {hudname}. Vous n'avez pas la permission, ou bien ce HUD n'existe pas."
L.hud_restricted_failed = "Échec de la restriction du HUD {hudname}. Vous n'avez pas la permission."

L.shop_role_select = "Sélectionnez un rôle"
L.shop_role_selected = "La boutique des {role}'s a été sélectionnée !"
L.shop_search = "Recherche"

-- 2019-10-19
L.drop_ammo_prevented = "Quelque chose vous empêche de jeter vos munitions."

-- 2019-10-28
L.target_c4 = "Appuyez sur [{usekey}] pour ouvrir le menu du C4"
L.target_c4_armed = "Appuyez sur [{usekey}] pour désarmer le C4"
L.target_c4_armed_defuser = "Appuyez sur [{primaryfire}] pour désamorcer le C4"
L.target_c4_not_disarmable = "Vous ne pouvez pas désamorcer le C4 d'un autre Traître, à moins qu'il soit mort"
L.c4_short_desc = "Quelque chose de très explosif"

L.target_pickup = "Appuyez sur [{usekey}] pour ramasser"
L.target_slot_info = "Emplacement: {slot}"
L.target_pickup_weapon = "Appuyez sur [{usekey}] pour ramasser l'arme"
L.target_switch_weapon = "Appuyez sur [{usekey}] pour changer d'arme"
L.target_pickup_weapon_hidden = ", Appuyez sur [{walkkey} + {usekey}] pour ramasser discrètement"
L.target_switch_weapon_hidden = ", Appuyez sur [{walkkey} + {usekey}] pour changer discrètement"
L.target_switch_weapon_nospace = "Il n'y a pas de place disponible dans l'inventaire pour cette arme"
L.target_switch_drop_weapon_info = "Lâcher {name} de l'emplacement {slot}"
L.target_switch_drop_weapon_info_noslot = "Il n'y a pas d'arme à lâcher dans cet emplacement {slot}"

L.corpse_searched_by_detective = "Ce corps a été fouillé par un Détective."
L.corpse_too_far_away = "Ce corps est trop loin."

L.radio_short_desc = "Les sons des armes sont de la musique pour moi"

L.hstation_subtitle = "Appuyez sur [{usekey}] pour recevoir des soins."
L.hstation_charge = "Charge restante de la station de soin: {charge}"
L.hstation_empty = "Il n'y a plus de charge dans cette station de soins"
L.hstation_maxhealth = "Votre santé est pleine"
L.hstation_short_desc = "La station de soins se recharge lentement au fil du temps"

-- 2019-11-03
L.vis_short_desc = "Visualise une scène de crime si la victime est morte d'une blessure par balle"
L.corpse_binoculars = "Appuyez sur [{key}] pour fouiller un corps à l'aide des jumelles."
L.binoc_progress = "Progression des recherches: {progress}%"

L.pickup_no_room = "Vous n'avez pas de place dans votre inventaire pour ce type d'arme"
L.pickup_fail = "Vous ne pouvez pas prendre cette arme"
L.pickup_pending = "Vous avez déjà pris une arme, attendez de la recevoir"

-- 2020-01-07
L.tbut_help_admin = "Éditer les paramètres du traître"
L.tbut_role_toggle = " Appuyez sur [{walkkey} + {usekey}] pour activer/désactiver ce bouton pour {role}"
L.tbut_role_config = "Rôle: {current}"
L.tbut_team_toggle = "Appuyez sur [SHIFT + {walkkey} + {usekey}] pour activer/désactiver ce bouton pour la {team}"
L.tbut_team_config = "Équipe: {current}"
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
L.automoved_to_spec = "(MESSAGE AUTOMATIQUE) Vous avez été transféré dans l'équipe Spectateur car vous était inactif/AFK."
L.mute_team = "{team} muet."

-- 2020-02-16
L.door_auto_closes = "Cette porte se ferme automatiquement"
L.door_open_touch = "Marchez vers la porte pour l'ouvrir."
L.door_open_touch_and_use = "Marchez vers la porte ou appuyez sur [{usekey}] pour l'ouvrir."

-- 2020-03-09
L.help_title = "Aide et Paramètres"

L.menu_changelog_title = "Changelog"
L.menu_guide_title = "TTT2 Guide"
L.menu_bindings_title = "Configuration"
L.menu_language_title = "Langue"
L.menu_appearance_title = "Apparence"
L.menu_gameplay_title = "Jouabilité"
L.menu_addons_title = "Addons"
L.menu_legacy_title = "Legacy Addons"
L.menu_administration_title = "Administration"
L.menu_equipment_title = "Éditez les équipements"
L.menu_shops_title = "Éditez les boutiques"

L.menu_changelog_description = "Liste des changements et des corrections dans les versions récentes"
L.menu_guide_description = "Vous aide à démarrer TTT2 et vous explique certaines notions sur le gameplay, les rôles et d'autres choses"
L.menu_bindings_description = "Configurer les caractéristiques spécifiques de TTT2 et de ses addons"
L.menu_language_description = "Sélectionner la langue du jeu"
L.menu_appearance_description = "Modifier l'apparence et la performance de votre UI"
L.menu_gameplay_description = "Ajuster le volume des voix et des sons, les paramètres d'accessibilité et les paramètres de jeu."
L.menu_addons_description = "Configurer les addons locaux à votre convenance"
L.menu_legacy_description = "Une interface avec des onglets convertis à partir du TTT original, ils devraient être portés sur le nouveau système"
L.menu_administration_description = "Paramètres généraux pour les HUD, les shops, etc."
L.menu_equipment_description = "Fixer le nombre de crédit, les limites, la disponibilité et d'autres choses"
L.menu_shops_description = "Ajoutez/supprimez des boutiques aux rôles et définir les équipements qu'ils contiennent"

L.submenu_guide_gameplay_title = "Jouabilité"
L.submenu_guide_roles_title = "Rôles"
L.submenu_guide_equipment_title = "Équipement"

L.submenu_bindings_bindings_title = "Configuration des touches"

L.submenu_language_language_title = "Langue"

L.submenu_appearance_general_title = "Général"
L.submenu_appearance_hudswitcher_title = "Paramètres du HUD"
L.submenu_appearance_vskin_title = "VSkin"
L.submenu_appearance_targetid_title = "TargetID"
L.submenu_appearance_shop_title = "Paramètres des Boutiques"
L.submenu_appearance_crosshair_title = "Réticule"
L.submenu_appearance_dmgindicator_title = "Indicateur de dégats"
L.submenu_appearance_performance_title = "Performance"
L.submenu_appearance_interface_title = "Interface"

L.submenu_gameplay_general_title = "Général"

L.submenu_administration_hud_title = "Paramètres HUD"
L.submenu_administration_randomshop_title = "Boutique Aléatoire"

L.help_color_desc = "Si cette option est activée, il est possible de choisir une couleur qui sera utilisée pour le contour du targetID et du réticule."
L.help_scale_factor = "L'échelle influence tous les éléments de l'UI (HUD, vgui et targetID). Il est automatiquement mis à jour si la résolution de l'écran est modifiée. La modification de cette valeur entraîne la réinitialisation du HUD !"
L.help_hud_game_reload = "Le HUD n'est pas disponible pour le moment. Le jeu doit être rechargé."
L.help_hud_special_settings = "Voici les paramètres spécifiques de ce HUD."
L.help_vskin_info = "Le VSkin (vgui skin) est le skin appliqué à tous les éléments du menu comme celui en cours. Les skins peuvent être facilement créés avec un simple script lua et peuvent changer les couleurs et la taille de certains paramètres."
L.help_targetid_info = "Le TargetID est l'information rendue lors de la focalisation d'une entité. Une couleur fixe peut être définie dans le panneau des paramètres généraux."
L.help_hud_default_desc = "Définissez le HUD par défaut pour tous les joueurs. Les joueurs qui n'ont pas encore sélectionné de HUD recevront ce HUD par défaut. Cela ne changera pas le HUD des joueurs qui ont déjà sélectionné leur HUD."
L.help_hud_forced_desc = "Forcer un HUD pour tous les joueurs. Cela désactive la fonction de sélection du HUD pour tout les joueurs."
L.help_hud_enabled_desc = "Activez/Désactivez les HUD pour restreindre la sélection de ces HUD."
L.help_damage_indicator_desc = "L'indicateur de dégâts est la couche affichée lorsque le joueur prend des dégâts. Pour ajouter un nouveau thème, placez un png dans 'materials/vgui/ttt/damageindicator/themes/'."
L.help_shop_key_desc = "Ouvrer la boutique en appuyant sur votre touche de boutique (c par défaut) au lieu du menu 'score' pendant la préparation / à la fin de la partie?"

L.label_menu_menu = "MENU"
L.label_menu_admin_spacer = "Zone d'administration (cachée aux utilisateurs normaux)"
L.label_language_set = "Sélectionner une langue"
L.label_global_color_enable = "Activez les couleurs globales"
L.label_global_color = "Couleur globale"
L.label_global_scale_factor = "Taille de l'interface"
L.label_hud_select = "Sélectionnez un HUD"
L.label_vskin_select = "Sélectionnez un VSkin"
L.label_blur_enable = "Activer le flou à l'arrière-plan du VSkin"
L.label_color_enable = "Activer la couleur de fond du VSkin"
L.label_minimal_targetid = "Target ID minimaliste sous le réticule (pas d'affichage du karma, indice, etc.)"
L.label_shop_always_show = "Toujours montrer la boutique"
L.label_shop_double_click_buy = "Acheter un article dans la boutique en double-cliquant dessus"
L.label_shop_num_col = "Nombre de colonnes"
L.label_shop_num_row = "Nombre de lignes"
L.label_shop_item_size = "Taille des icônes"
L.label_shop_show_slot = "Afficher le marqueur d'emplacement"
L.label_shop_show_custom = "Afficher le marqueur d'objet personnalisé"
L.label_shop_show_fav = "Afficher le marqueur d'article favoris"
L.label_crosshair_enable = "Activer le réticule"
L.label_crosshair_opacity = "Opacité du réticule"
L.label_crosshair_ironsight_opacity = "Opacité du réticule du viseur"
L.label_crosshair_size = "Taille du réticule"
L.label_crosshair_thickness = "Épaisseur du réticule"
L.label_crosshair_thickness_outline = "Épaisseur du contour du réticule"
L.label_crosshair_scale_enable = "Activer l'échelle dynamique du réticule"
L.label_crosshair_ironsight_low_enabled = "Baisser votre arme lorsque vous utilisez le viseur"
L.label_damage_indicator_enable = "Activer l'indicateur de dégâts"
L.label_damage_indicator_mode = "Sélectionner le thème de l'indicateur de dégâts"
L.label_damage_indicator_duration = "Temps d'affichage de l'indicateur de dégâts"
L.label_damage_indicator_maxdamage = "Dommages nécessaires pour une opacité maximale"
L.label_damage_indicator_maxalpha = "Opacité maximale de l'indicateur de dégâts "
L.label_performance_halo_enable = "Dessiner un contour autour de certaines entités quand vous les regardez"
L.label_performance_spec_outline_enable = "Activer les contours des objets contrôlés"
L.label_performance_ohicon_enable = "Activer les icônes des rôles"
L.label_interface_popup = "Durée de la pop-up de début de partie"
L.label_interface_fastsw_menu = "Activer le menu avec un changement d'arme rapide"
L.label_inferface_wswitch_hide_enable = "Activer la fermeture automatique du menu quand l'arme change"
L.label_inferface_scues_enable = "Jouer un son au début et à la fin d'une partie"
L.label_gameplay_specmode = "Mode Spectateur (toujours resté en spectateur)"
L.label_gameplay_fastsw = "Changement d'arme rapide"
L.label_gameplay_hold_aim = "Maintenir pour viser"
L.label_gameplay_mute = "Rendre muets les joueurs vivants quand vous mourrez"
L.label_hud_default = "HUD par défaut"
L.label_hud_force = "HUD obligatoire"

L.label_bind_voice = "Chat Vocal Global"
L.label_bind_voice_team = "Chat Vocal d'Équipe"

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
L.header_shop_settings = "Paramètres de la boutique d'Équipement"
L.header_shop_layout = "Mise en page de la liste des objets"
L.header_shop_marker = "Paramètres des marqueurs d'objets"
L.header_crosshair_settings = "Paramètres du réticule"
L.header_damage_indicator = "Paramètres de l'indicateur de dégâts"
L.header_performance_settings = "Paramètres de performance"
L.header_interface_settings = "Paramètres de l'interface"
L.header_gameplay_settings = "Paramètres de jeu"
L.header_hud_administration = "Sélectionnez le HUD par défaut et obligatoire"
L.header_hud_enabled = "Activer/Désactiver les HUD"

L.button_menu_back = "Retour"
L.button_none = "Aucun"
L.button_press_key = "Appuyer sur une touche"
L.button_save = "Sauvegarder"
L.button_reset = "Réinitialiser"
L.button_close = "Fermer"
L.button_hud_editor = "Éditeur d'HUD"

-- 2020-04-20
L.item_speedrun = "Speedrun"
L.item_speedrun_desc = [[Vous rend 50 % plus rapides !]]
L.item_no_explosion_damage = "Pas de dégâts d'explosion"
L.item_no_explosion_damage_desc = [[Vous immunise contre les dégâts causés par les explosions.]]
L.item_no_fall_damage = "Pas de dégâts dus aux chutes"
L.item_no_fall_damage_desc = [[Vous immunise contre les dégâts causés par les chutes.]]
L.item_no_fire_damage = "Pas de dégâts dus au feu"
L.item_no_fire_damage_desc = [[Vous immunise contre les dégâts causés par le feu.]]
L.item_no_hazard_damage = "Pas de dégâts dus aux radiations"
L.item_no_hazard_damage_desc = [[Vous immunise contre les dégâts causés par le poison, les radiations et les acides.]]
L.item_no_energy_damage = "Pas de dégâts énergétiques"
L.item_no_energy_damage_desc = [[Vous immunise contre les dégâts énergétiques tels que les lasers, le plasma et l'électricité.]]
L.item_no_prop_damage = "Pas de dégâts dus aux entité"
L.item_no_prop_damage_desc = [[Vous immunise contre les dégâts causés par les entités.]]
L.item_no_drown_damage = "Pas de dégâts de noyade"
L.item_no_drown_damage_desc = [[Vous immunise contre les dégâts dus à la noyade.]]

-- 2020-04-21
L.dna_tid_possible = "Scan possible"
L.dna_tid_impossible = "Scan impossible"
L.dna_screen_ready = "Pas d'ADN"
L.dna_screen_match = "Correspondance"

-- 2020-04-30
L.message_revival_canceled = "Réanimation annulée."
L.message_revival_failed = "Réanimation ratée."
L.message_revival_failed_missing_body = "Vous n'avez pas été réanimé car votre corps n'existe plus."
L.hud_revival_title = "Temps restant avant réanimation:"
L.hud_revival_time = "{time}s"

-- 2020-05-03
L.door_destructible = "La porte est destructible ({health}HP)"

-- 2020-05-28
L.corpse_hint_inspect_limited = "Appuyez sur [{usekey}] pour fouiller. [{walkkey} + {usekey}] pour afficher uniquement l'UI de fouille."

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
L.pickup_error_owns = "Vous ne pouvez pas prendre cela car vous avez déjà cette arme."
L.pickup_error_noslot = "Vous ne pouvez pas prendre cela car vous n'avez pas d'emplacement libre."

-- 2020-11-02
L.lang_server_default = "Langue du serveur par défaut"
L.help_lang_info = [[
Cette traduction est complète à {coverage}%.

Gardez en tête que les traductions sont réalisées par la communauté. N'hésitez pas à y contribuer s'il y a quelque chose qui manque ou s'il y a des erreurs.]]

-- 2021-04-13
L.title_score_info = "Info de fin de partie"
L.title_score_events = "Historique des événements"

L.label_bind_clscore = "Ouvrir le rapport de la partie"
L.title_player_score = "{player}'s score:"

L.label_show_events = "Afficher les événements de"
L.button_show_events_you = "Vous"
L.button_show_events_global = "Global"
L.label_show_roles = "Afficher la distribution des rôles de"
L.button_show_roles_begin = "Début de la partie"
L.button_show_roles_end = "Fin de la partie"

L.hilite_win_traitors = "L'ÉQUIPE DES TRAÎTRES A GAGNÉ"
L.hilite_win_innocents = "L'ÉQUIPE DES INNOCENTS A GAGNÉ"
L.hilite_win_tie = "C'EST UNE ÉGALITÉ"
L.hilite_win_time = "LE TEMPS EST ÉCOULÉ"

L.tooltip_karma_gained = "Changement du Karma pour cette partie:"
L.tooltip_score_gained = "Changement du Score pour cette partie:"
L.tooltip_roles_time = "Changement de Rôle pour cette partie:"

--L.tooltip_finish_score_win = "Win: {score}"
L.tooltip_finish_score_alive_teammates = "Allié(s) en vie: {score}"
L.tooltip_finish_score_alive_all = "Joueurs en vie: {score}"
L.tooltip_finish_score_timelimit = "Temps écoulé: {score}"
L.tooltip_finish_score_dead_enemies = "Ennemis morts: {score}"
L.tooltip_kill_score = "Meurtres: {score}"
L.tooltip_bodyfound_score = "Corps découvert: {score}"

--L.finish_score_win = "Win:"
L.finish_score_alive_teammates = "Allié(s) en vie:"
L.finish_score_alive_all = "Joueurs en vie:"
L.finish_score_timelimit = "Temps écoulé:"
L.finish_score_dead_enemies = "Ennemis morts:"
L.kill_score = "Meurtres:"
L.bodyfound_score = "Corps découvert:"

L.title_event_bodyfound = "Un corps à était trouvé"
L.title_event_c4_disarm = "Un C4 a été désamorcé"
L.title_event_c4_explode = "Un C4 a explosé"
L.title_event_c4_plant = "Un C4 a été armé"
L.title_event_creditfound = "Des crédits d'équipement ont été trouvés"
L.title_event_finish = "La partie est terminée"
L.title_event_game = "Une nouvelle partie a commencé"
L.title_event_kill = "Un joueur a été tué"
L.title_event_respawn = "Un joueur est réapparu"
L.title_event_rolechange = "Un joueur a changé de rôle ou d'équipe"
L.title_event_selected = "Les rôles ont été distribués"
L.title_event_spawn = "Un joueur est apparu"

L.desc_event_bodyfound = "{finder} ({firole} / {fiteam}) a trouvé le corps de {found} ({forole} / {foteam}). Le corps avait {credits} crédit(s) d'équipement."
L.desc_event_bodyfound_headshot = "La victime a été tuée d'une balle à la tête."
L.desc_event_c4_disarm_success = "{disarmer} ({drole} / {dteam}) a réussi à désamorcer un C4 armé par {owner} ({orole} / {oteam})."
L.desc_event_c4_disarm_failed = "{disarmer} ({drole} / {dteam}) a essayé de désamorcer un C4 armé par {owner} ({orole} / {oteam}). They failed."
L.desc_event_c4_explode = "Le C4 armé par {owner} ({role} / {team}) explosé."
L.desc_event_c4_plant = "{owner} ({role} / {team}) a armé un C4."
L.desc_event_creditfound = "{finder} ({firole} / {fiteam}) a trouvé {credits} crédit(s) d'équipement sur le corps de {found} ({forole} / {foteam})."
L.desc_event_finish = "La partie a duré {minutes}:{seconds}. Il y avait {alive} joueur(s) en vie à la fin."
L.desc_event_game = "La partie a commencé."
L.desc_event_respawn = "{player} est réapparu."
L.desc_event_rolechange = "{player} a changé de rôle/équipe de {orole} ({oteam}) pour devenir un {nrole} ({nteam})."
L.desc_event_selected = "Les équipes et les rôles ont été distribués aux {amount} joueur(s)."
L.desc_event_spawn = "{player} est apparu."

-- Name of a trap that killed us that has not been named by the mapper
L.trap_something = "quelque chose"

-- Kill events
L.desc_event_kill_suicide = "C'était un suicide."
L.desc_event_kill_team = "C'était un meurtre allié."

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
L.karma_teamkill_tooltip = "Allié tué"
L.karma_teamhurt_tooltip = "Dégât allié infligé"
L.karma_enemykill_tooltip = "Ennemi tué"
L.karma_enemyhurt_tooltip = "Dégât infligé"
L.karma_cleanround_tooltip = "Partie parfaite"
L.karma_roundheal_tooltip = "Karma restoré"
L.karma_unknown_tooltip = "Inconnu"

-- 2021-05-07
L.header_random_shop_administration = "Paramètres Aléatoires de la Boutique"
L.header_random_shop_value_administration = "Paramètres d'Équilibrage"

L.shopeditor_name_random_shops = "Activez les boutiques aléatoires"
L.shopeditor_desc_random_shops = [[Les boutiques aléatoires attribuent à chaque joueur un ensemble limité et aléatoire de tous les équipements disponibles.
Les boutiques d'équipe donnent de manière systématique les mêmes ensembles d'équipements à tous les joueurs de l'équipe.
La relance vous permet d'obtenir un nouvel ensemble d'équipements aléatoires en échange de crédits.]]
L.shopeditor_name_random_shop_items = "Nombre d'équipements aléatoires"
L.shopeditor_desc_random_shop_items = "Cela inclut les équipements qui sont marqués par la mention « Toujours disponible dans la boutique ». Choisissez donc un nombre suffisamment élevé d'équipements ou vous n'obtiendrez que ceux-là."
L.shopeditor_name_random_team_shops = "Activez les boutiques d'équipe"
L.shopeditor_name_random_shop_reroll = "Activer la relance d'équipement de la boutique"
L.shopeditor_name_random_shop_reroll_cost = "Coût par relance"
L.shopeditor_name_random_shop_reroll_per_buy = "Relance d'équipement automatique à chaque achat"

-- 2021-06-04
L.header_equipment_setup = "Paramètres d'Équipements"
L.header_equipment_value_setup = "Paramètres d'Équilibrage"

L.equipmenteditor_name_not_buyable = "Achetable"
L.equipmenteditor_desc_not_buyable = "Si cette option est désactivée l'équipement n'apparaîtra pas dans la boutique. Les rôles ayant cet équipement assigné le recevront quand même."
L.equipmenteditor_name_not_random = "Toujours disponible dans la boutique"
L.equipmenteditor_desc_not_random = "Si cette option est activée l'équipement sera toujours disponible dans la boutique. Lorsque la boutique aléatoire est activée, il prend un emplacement aléatoire disponible et le réserve toujours pour cet équipement."
L.equipmenteditor_name_global_limited = "Quantité globale limitée"
L.equipmenteditor_desc_global_limited = "Si cette option est activée, l'équipement ne peut être acheté qu'une seule fois sur le serveur pendant la partie en cours."
L.equipmenteditor_name_team_limited = "Quantité limitée par équipe"
L.equipmenteditor_desc_team_limited = "Si cette option est activée, l'équipement ne peut être acheté qu'une seule fois par équipe sur le serveur pendant la partie en cours."
L.equipmenteditor_name_player_limited = "Quantité limitée par joueur"
L.equipmenteditor_desc_player_limited = "Si cette option est activée, l'équipement ne peut être acheté qu'une seule fois par joueur sur le serveur pendant la partie en cours."
L.equipmenteditor_name_min_players = "Nombre minimum de joueurs pour l'acheter"
L.equipmenteditor_name_credits = "Prix en crédits"

-- 2021-06-08
L.equip_not_added = "non ajouté"
L.equip_added = "ajouté"
L.equip_inherit_added = "ajouté (hériter)"
L.equip_inherit_removed = "retiré (hériter)"

-- 2021-06-09
L.layering_not_layered = "Sans couche"
L.layering_layer = "Couche {layer}"
L.header_rolelayering_role = "Couche des rôles des {role}"
L.header_rolelayering_baserole = "Couche des rôles de base"
L.submenu_roles_rolelayering_title = "Couche des Rôles"
L.header_rolelayering_info = "Informations sur la priorité de distribution des rôles"
L.help_rolelayering_roleselection = [[La distribution des rôles se fait en deux étapes. La première étape consiste à distribuer les rôles de base, à savoir les rôles d'innocent, de traître et les rôles énumérés dans la case 'couche des rôles de base' ci-dessous. La deuxième étape permet de transformer ces rôles de base en sous-rôles.]]
L.help_rolelayering_layers = [[Un seul rôle est sélectionné dans chaque couche. En premier les rôles des couches personnalisées sont distribués en commençant par la première couche jusqu'à la dernière ou jusqu'à ce qu'il n'y ait plus de rôles pouvant être assignés. Selon ce qui se passe en premier, s'il reste des places disponibles pour des rôles, les rôles sans couche personnalisées seront également distribués.]]
L.scoreboard_voice_tooltip = "Défiler avec la molette de la souris pour modifier le volume"

-- 2021-06-15
L.header_shop_linker = "Paramètres"
L.label_shop_linker_set = "Sélectionner le type de boutique :"

-- 2021-06-18
L.xfer_team_indicator = "Équipe"

-- 2021-06-25
L.searchbar_default_placeholder = "Rechercher dans la liste..."

-- 2021-07-11
L.spec_about_to_revive = "Mode spectateur limité pendant la période de réanimation."

-- 2021-09-01
L.spawneditor_name = "Outil d'Édition de Point d'Apparitions"
L.spawneditor_desc = "Utilisé pour placer des armes, des munitions et des points d'apparitions de joueurs sur la carte. Utilisable uniquement par un super admin."

L.spawneditor_place = "Placer un point d'apparition"
L.spawneditor_remove = "Retirer un point d'apparition"
L.spawneditor_change = "Changer le type de point d'apparition (Maintenez la touche [SHIFT] enfoncée pour inverser)"
L.spawneditor_ammo_edit = "Rester appuyé sur le point d'apparition d'une arme pour modifier les munitions qui apparaissent automatiquement"

L.spawn_weapon_random = "Armes Aléatoire"
L.spawn_weapon_melee = "Armes de Mêlée"
L.spawn_weapon_nade = "Grenade"
L.spawn_weapon_shotgun = "Fusil à pompe"
L.spawn_weapon_heavy = "Fusil/Armes Lourde/SMG"
L.spawn_weapon_sniper = "Fusil de sniper"
L.spawn_weapon_pistol = "Pistolet"
L.spawn_weapon_special = "Arme Spéciale"
L.spawn_ammo_random = "Munitions Aléatoire"
L.spawn_ammo_deagle = "Munitions de Deagle"
L.spawn_ammo_pistol = "Munitions de 9mm"
L.spawn_ammo_mac10 = "Munitions de SMG"
L.spawn_ammo_rifle = "Munitions de Fusil de sniper"
L.spawn_ammo_shotgun = "Munitions de Fusil à pompe"
L.spawn_player_random = "Point d'Apparition de Joueurs"

L.spawn_weapon_ammo = "(Munitions: {ammo})"

L.spawn_weapon_edit_ammo = "Maintenez la touche [{walkkey}] et appuyez sur [{primaryfire} ou {secondaryfire}] pour augmenter ou diminuer le nombre de munitions pour cette arme"

L.spawn_type_weapon = "C'est un point d'apparition d'arme"
L.spawn_type_ammo = "C'est un point d'apparition de munitions"
L.spawn_type_player = "C'est un point d'apparition de joueur"

L.spawn_remove = "Appuyez sur [{secondaryfire}] pour retirer ce point d'apparition"

L.submenu_administration_entspawn_title = "Éditeur de Point d'Apparition"
L.header_entspawn_settings = "Paramètres de l'Éditeur de point d'Apparition"
L.button_start_entspawn_edit = "Édition des apparitions"
L.button_delete_all_spawns = "Supprimer tout"

L.label_dynamic_spawns_enable = "Activez les apparitions dynamiques sur cette carte"
L.label_dynamic_spawns_global_enable = "Activez les apparitions dynamiques sur toutes les cartes"

L.header_equipment_weapon_spawn_setup = "Paramètres d'Apparition des Armes"

L.help_spawn_editor_info = [[
L'éditeur d'apparitions est utilisé pour placer, supprimer et modifier les points d'apparitions sur la carte. Ces apparitions concernent les armes, les munitions et les joueurs.

Ces points d'apparition sont sauvegardés dans des fichiers situés dans 'data/ttt/weaponspawnscripts/'. Ils peuvent être supprimés pour une réinitialisation complète. Les fichiers de point d'apparitions par défaut sont créés à partir des points d'apparitions présents sur la carte et dans les scripts de point d'apparitions par défaut des armes du TTT. En appuyant sur le bouton de réinitialisation, vous revenez à l'état initial de la carte.

Noter que ce système de points d'apparition utilise des points d'apparitions dynamiques. Ce système est intéressant pour les armes car il ne définit plus une arme spécifique, mais un type d'armes. Par exemple, au lieu de faire apparaître un fusil à pompe TTT, il y a maintenant un point d'apparition général à tous les fusils à pompe où n'importe quelle arme définie comme fusil a pompe peut apparaître. Le type de point d'apparition de chaque arme peut être défini dans le menu 'Éditez les équipements'. Cela permet de faire apparaître n'importe quelle arme sur la carte, ou de désactiver certaines armes par défaut.

Gardez en tête que de nombreux changements ne prennent effet qu'après le début d'une nouvelle partie.]]
L.help_spawn_editor_enable = "Sur certaines cartes, il peut être conseillé d'utiliser les points d'apparitions originaux de la carte sans les remplacer par le système dynamique. La modification de cette option ci-dessous n'affecte que la carte active, de sorte que le système dynamique soit toujours utilisé pour toutes les autres cartes."
L.help_spawn_editor_hint = "Conseil : Pour quitter l'éditeur de point d'apparitions, ouvrez à nouveau le menu du jeu."
L.help_spawn_editor_spawn_amount = [[
Il y a actuellement {weapon} points d'apparitions d'armes, {ammo}  points d'apparitions de munitions et {player} points d'apparitions de joueurs sur cette carte.
Cliquez sur 'Édition des apparitions' pour modifier ce montant.

{weaponrandom}x Point d'Apparition d'Armes Aléatoire
{weaponmelee}x Point d'Apparition d'Armes de Mêlée Aléatoire
{weaponnade}x Point d'Apparition de Grenade Aléatoire
{weaponshotgun}x Point d'Apparition de Fusil à pompe
{weaponheavy}x Point d'Apparition de Fusil/Armes Lourde/SMG
{weaponsniper}x Point d'Apparition de Fusil de sniper
{weaponpistol}x Point d'Apparition de Pistolet
{weaponspecial}x Point d'Apparition d'Arme Spéciale

{ammorandom}x Point d'Apparition de Munitions Aléatoire
{ammodeagle}x Point d'Apparition de Munitions de Deagle
{ammopistol}x Point d'Apparition de Munitions de 9mm
{ammomac10}x Point d'Apparition de Munitions de SMG
{ammorifle}x Point d'Apparition de Munitions de Fusil de sniper
{ammoshotgun}x Point d'Apparition de Munitions de Fusil à pompe

{playerrandom}x Point d'Apparition de Joueurs]]

L.equipmenteditor_name_auto_spawnable = "L'équipement apparaît de manière aléatoire sur la carte"
L.equipmenteditor_name_spawn_type = "Sélection du type de point d'apparition"
L.equipmenteditor_desc_auto_spawnable = [[
Le système de point d'apparitions de TTT2 permet à toutes les armes d'apparaître sur la carte. Par défaut, seules les armes marquées d'un 'AutoSpawnable' par le créateur de la carte apparaîtra sur la carte, mais cela peut être modifié à partir de ce menu.

La plupart des équipements sont réglés par défaut sur 'Point d'Apparition d'Arme Spéciale'. Cela signifie que l'équipement n'apparaît que sur des point d'apparition d'armes aléatoires. Cependant, il est possible de placer des points d'apparitions d'armes spéciales sur la carte ou de changer le type de point d'apparition ici pour utiliser d'autres types de point d'apparitions existants.]]

L.pickup_error_inv_cached = "Vous ne pouvez pas le ramasser maintenant car votre inventaire est en mémoire cache."

-- 2021-09-02
L.submenu_administration_playermodels_title = "Modèles de Joueurs"
L.header_playermodels_general = "Paramètres Généraux des Modèles de Joueurs"
L.header_playermodels_selection = "Sélection de Modèles de Joueurs"

L.label_enforce_playermodel = "Appliquer le modèle de joueurs spécifiques à un rôle"
L.label_use_custom_models = "Utiliser un modèle de joueur choisi au hasard parmi ceux qui ont été sélectionnés"
L.label_prefer_map_models = "Privilégier les modèles de joueurs spécifiques aux cartes plutôt que les modèles de joueurs par défaut"
L.label_select_model_per_round = "Sélectionner un nouveau modèle de joueurs aléatoire à chaque partie (quand la carte change si désactivé)"
L.label_select_unique_model_per_round = "Sélectionner au hasard un modèle de joueur unique pour chaque joueur"

L.help_prefer_map_models = [[
Certaines cartes définissent leurs propres modèles de joueurs. Par défaut, ces modèles ont une priorité plus élevée que ceux qui sont attribués automatiquement. En désactivant cette option, les modèles de joueurs spécifiques à la carte sont désactivés.

Les modèles de joueurs spécifiques à un rôle ont toujours une priorité plus élevée et ne sont pas affectés par ce paramètre.]]
L.help_enforce_playermodel = [[
Certains rôles ont des modèles de joueurs personnalisés. Ils peuvent être désactivés, ce qui peut être important pour la compatibilité avec certains modèles de joueurs.
Les modèles de joueurs aléatoires par défaut peuvent toujours être sélectionnés si cette option est désactivée.]]
L.help_use_custom_models = [[
Par défaut, seul le modèle de joueur CS:S Phoenix est attribué à tous les joueurs. En activant cette option, il est possible de sélectionner une selection de modèles de joueurs. Avec cette option activée, chaque joueur se verra attribuer le même modèle de joueur, mais il s'agira d'un modèle aléatoire provenant de la selection de modèles joueurs défini.

Cette sélection de modèles de joueurs peut être élargie par l'installation d'autres modèles de joueurs.]]

-- 2021-10-06
L.menu_server_addons_title = "Addons du Serveur"
L.menu_server_addons_description = "Paramètres réservés à l'administrateur du serveur pour les addons"

L.tooltip_finish_score_penalty_alive_teammates = "Pénalité d'allié en vie: {score}"
L.finish_score_penalty_alive_teammates = "Pénalité d'allié en vie:"
L.tooltip_kill_score_suicide = "Suicide: {score}"
L.kill_score_suicide = "Suicide:"
L.tooltip_kill_score_team = "Meurtre allié: {score}"
L.kill_score_team = "Meurtre allié:"

-- 2021-10-09
L.help_models_select = [[
Clic gauche sur les modèles de joueurs pour les ajouter à la sélection de modèles de joueur. Cliquez à nouveau dessus pour les retirer de la sélection. Clic droit permet d'activer ou de désactiver le chapeau du détective pour le modèle de joueur sélectionné.

L'indicateur en haut à gauche indique si le modèle de joueur a une hitbox pour la tête. L'icône ci-dessous indique si ce modèle est applicable pour le chapeau du détective.]]

L.menu_roles_title = "Paramètres des Rôles"
L.menu_roles_description = "Configurez la sélection de rôles, les crédits d'équipement et bien plus encore."

L.submenu_roles_roles_general_title = "Paramètres Généraux des Rôles"

L.header_roles_info = "Informations sur le Rôle"
L.header_roles_selection = "Paramètres de Sélection des Rôles"
L.header_roles_tbuttons = "Accès aux boutons des Traîtres"
L.header_roles_credits = "Crédits d'Équipements du Rôle"
L.header_roles_additional = "Paramètres Additionnels des Rôles"
L.header_roles_reward_credits = "Crédits d'Équipement de Récompense"

L.help_roles_default_team = "Équipe par défaut: {team}"
L.help_roles_unselectable = "Ce rôle n'est pas distribuable. Il n'est pas pris en compte dans le processus de distribution des rôles. La plupart du temps, cela signifie qu'il s'agit d'un rôle attribué manuellement au cours de la partie par le biais d'un événement comme une réanimation, un Deagle d'Acolyte ou autre chose de similaire."
L.help_roles_selectable = "Ce rôle est distribuable. Si tous les critères sont remplis, ce rôle est pris en compte dans le processus de distribution des rôles."
L.help_roles_credits = "Les crédits d'équipement sont utilisés pour acheter de l'équipement dans la boutique. Il est généralement logique de ne les donner qu'aux rôles qui ont accès aux boutiques. Cependant, comme il est possible de trouver des crédits sur les corps, vous pouvez également donner des crédits de départ aux rôles en guise de récompense à leur meurtrier."
L.help_roles_selection_short = "La répartition des rôles par joueur définit le pourcentage de joueurs auxquels ce rôle est attribué. Par exemple, si la valeur est fixée à '0.2' un joueur sur cinq se voit attribuer ce rôle."
L.help_roles_selection = [[
La répartition des rôles par joueur définit le pourcentage de joueurs auxquels ce rôle est attribué. Par exemple, si la valeur est fixée à '0.2' un joueur sur cinq se voit attribuer ce rôle. Cela veut aussi dire qu'il faut au moins 5 joueurs pour que ce rôle soit distribué.
Gardez en tête que tout ceci ne s'applique que si le rôle est considéré pour le processus de distribution.

La distribution des rôles susmentionnée est spécialement intégrée à la limite inférieure de joueurs. Si le rôle est considéré pour la distribution et que la valeur minimale est inférieure à la valeur donnée par le facteur de distribution, mais que le nombre de joueurs est égal ou supérieur à la limite inférieure, un seul joueur pourra toujours recevoir ce rôle. Le processus de distribution se déroule alors comme d'habitude pour le second joueur.]]
L.help_roles_award_info = "Certains rôles (s'ils sont activés dans leurs paramètres de crédits) reçoivent des crédits d'équipement si un certain pourcentage d'ennemis sont morts. Les valeurs correspondantes peuvent être modifiées ici."
L.help_roles_award_pct = "Lorsque ce pourcentage d'ennemis mort est atteint, des rôles spécifiques sont récompensés par des crédits d'équipement."
L.help_roles_award_repeat = "Indique si les crédits sont attribués plusieurs fois. Par exemple, si le pourcentage est fixé à '0.25', et que cette option est activée, les joueurs recevront des crédits à '25%', '50%' et '75%' d'ennemis morts."
L.help_roles_advanced_warning = "AVERTISSEMENT : Il s'agit de paramètres avancés qui peuvent complètement perturber le processus de distribution des rôles. En cas de doute, conservez toutes les valeurs à '0'. Cette valeur signifie qu'aucune limite n'est appliquée et que la distribution des rôles tentera d'attribuer autant de rôles que possible."
L.help_roles_max_roles = [[
Le terme rôles ici comprend les rôles de base et les sous-rôles. Par défaut, il n'y a pas de limite au nombre de rôles différents qui peuvent être attribués. Cependant, il existe deux façons différentes de les limiter.

1. Les limiter par un montant fixe.
2. Les limiter par un pourcentage.

Ce dernier n'est utilisé que si le montant fixe est '0' et fixe une limite supérieure basée sur le pourcentage défini de joueurs disponibles.]]
L.help_roles_max_baseroles = [[
Les rôles de base sont uniquement les rôles dont les autres héritent. Par exemple, le rôle Innocent est un rôle de base, tandis qu'un Pharaon est un sous-rôle de ce rôle. Par défaut, il n'y a pas de limite au nombre de rôles de base différents pouvant être attribués. Cependant, voici deux façons différentes de les limiter.

1. Les limiter par un montant fixe.
2. Les limiter par un pourcentage.

Ce dernier n'est utilisé que si le montant fixe est '0' et fixe une limite supérieure basée sur le pourcentage défini de joueurs disponibles.]]

L.label_roles_enabled = "Activer le rôle"
L.label_roles_min_inno_pct = "Distribution des innocents selon le nombre de joueurs"
L.label_roles_pct = "Distribution du rôle selon le nombre de joueurs"
L.label_roles_max = "Nombre de joueurs maximum pouvant avoir ce rôle"
L.label_roles_random = "Taux de chances que ce rôle soit distribué"
L.label_roles_min_players = "Nombre de joueurs minimum pour attribués ce rôle"
L.label_roles_tbutton = "Le rôle peut utiliser les boutons de Traître"
L.label_roles_credits_starting = "Crédits de départ"
L.label_roles_credits_award_pct = "Pourcentage de crédit de récompense"
L.label_roles_credits_award_size = "Nombre de crédit de récompense"
L.label_roles_credits_award_repeat = "Répétition de la récompense de crédit"
L.label_roles_newroles_enabled = "Activez les rôles personnalisés"
L.label_roles_max_roles = "Nombre maximum de rôle"
L.label_roles_max_roles_pct = "Nombre maximum de rôle en pourcentage"
L.label_roles_max_baseroles = "Nombre maximum de rôle de base"
L.label_roles_max_baseroles_pct = "Nombre maximum de rôle de base en pourcentage"
L.label_detective_hats = "Activer les chapeaux pour les rôles de détective (si le modèle du joueur permet d'en avoir)"

L.ttt2_desc_innocent = "L'Innocent n'a pas de capacités. Il doit trouver les Traîtres parmi les terroristes et les tuer. Mais il doit faire attention à ne pas tuer ses alliés."
L.ttt2_desc_traitor = "Le Traître est l'ennemi des Innocents. Il dispose d'un menu d'équipement qui lui permet d'acheter des équipements spéciaux. Il doit tuer tout le monde sauf ses alliés."
L.ttt2_desc_detective = "Le Détective est la seule personne en qui les Innocents peuvent avoir confiance. Mais qui est Innocent ? Le grand Détective doit trouver tous les Traîtres. Les équipements qui se trouvent dans leur boutique peuvent l'aider dans cette tâche."

-- 2021-10-10
L.button_reset_models = "Réinitialiser les modèles"

-- 2021-10-13
L.help_roles_credits_award_kill = "Une autre façon de gagner des crédits est de tuer des joueurs ayant un 'rôle public' comme par exemple un Détective. Si le rôle du meurtrier a cette option activée, il gagne le nombre de crédits défini ci-dessous."
L.help_roles_credits_award = [[
Il y a deux façons différentes d'obtenir des crédits dans TTT2:

1. Si un certain pourcentage de l'équipe ennemie est morte, toute l'équipe reçoit des crédits.
2. Si un joueur a tué un joueur avec un 'rôle public' comme par exemple un Détective, le tueur reçoit des crédits.

Notez que cette option peut être activé/désactivé pour chaque rôle, même si toute l'équipe est récompensée. Par exemple, si l'équipe Innocent est récompensée, mais que le rôle Innocent est désactivé, seul le Détective recevra ses crédits.
Les valeurs d'équilibrage de ce paramètre peuvent être définies dans la rubrique 'Administration' -> 'Paramètres Généraux des Rôles'.]]
L.help_detective_hats = [[
Les Détectives peuvent porter des chapeaux pour montrer leur autorité. Ils le perdent en cas de décès ou de blessure à la tête.

Certains modèles de joueurs ne prennent pas en charge les chapeaux par défaut. Ceci peut être modifié dans 'Administration' -> 'Modèles de Joueurs']]

L.label_roles_credits_award_kill = "Montant de crédit de récompense pour un meurtre"
L.label_roles_credits_dead_award = "Activez les crédits de récompense en fonction d'un certain pourcentage d'ennemis morts"
L.label_roles_credits_kill_award = "Activez les crédits de récompense pour le meurtre d'un rôle public"
L.label_roles_min_karma = "Karma minimum pour avoir la chance d'obtenir ce rôle"

-- 2021-11-07
L.submenu_administration_administration_title = "Administration"
L.submenu_administration_voicechat_title = "Chat Vocal / Chat Textuel"
L.submenu_administration_round_setup_title = "Paramètres des Parties"
L.submenu_administration_mapentities_title = "Entités de la Carte"
L.submenu_administration_inventory_title = "Inventaire"
L.submenu_administration_karma_title = "Karma"
L.submenu_administration_sprint_title = "Sprint"
L.submenu_administration_playersettings_title = "Paramètres des Joueurs"

L.header_roles_special_settings = "Paramètres des Rôles Spéciaux"
L.header_equipment_additional = "Paramètres Additionnels de l'Équipement"
L.header_administration_general = "Paramètres Admin Généraux"
L.header_administration_logging = "Rapport des parties"
L.header_administration_misc = "Divers"
L.header_entspawn_plyspawn = "Paramètres d'Apparition des Joueurs"
L.header_voicechat_general = "Paramètres Généraux du Chat Vocal"
L.header_voicechat_battery = "Batterie du Chat Vocal "
L.header_voicechat_locational = "Chat Vocal de Proximité "
L.header_playersettings_plyspawn = "Paramètres d'Apparition des Joueurs"
L.header_round_setup_prep = "Partie : En Préparation"
L.header_round_setup_round = "Partie : En cours"
L.header_round_setup_post = "Partie : Fin"
L.header_round_setup_map_duration = "Session sur la carte"
L.header_textchat = "Chat Textuel"
L.header_round_dead_players = "Paramètres des Joueurs Morts"
L.header_administration_scoreboard = "Paramètres du Tableau des Scores"
L.header_hud_toggleable = "Éléments du HUD Activables"
L.header_mapentities_prop_possession = "Possession des Entités"
L.header_mapentities_doors = "Portes"
L.header_karma_tweaking = "Modification du Karma"
L.header_karma_kick = "Karma Kick et Ban"
L.header_karma_logging = "Rapport de Karma"
L.header_inventory_gernal = "Taille de l'Inventaire"
L.header_inventory_pickup = "Ramassage des armes dans l'Inventaire"
L.header_sprint_general = "Paramètres du Sprint"
L.header_playersettings_armor = "Paramètres du Système d'Armure"

L.help_killer_dna_range = "Quand un joueur est tué par un autre joueur, un échantillon d'ADN est laissé sur son corps. Le paramètre ci-dessous définit la distance maximale en unités de Hammer (1 Hammer =19mm) à laquelle les échantillons d'ADN peuvent être laissés. Si le tueur se trouve à une distance supérieure à cette valeur lorsque la victime meurt, aucun échantillon ne sera laissé sur le corps."
L.help_killer_dna_basetime = "Temps de base en secondes jusqu'à ce qu'un échantillon d'ADN se décompose, si le tueur est à 0 unité de Hammer. Plus le tueur est loin, moins l'échantillon d'ADN aura le temps de se décomposer."
L.help_dna_radar = "Le scanner d'ADN du TTT2 indique la distance et la direction exactes de l'échantillon d'ADN sélectionné s'il en est équipé. Cependant, il existe également un mode scanner d'ADN classique qui met à jour l'échantillon sélectionné avec un affichage dans le monde à chaque fois que le temps de rechargement est écoulé."
L.help_idle = "Le mode inactif est utilisé pour forcer les joueurs inactifs à passer en mode spectateur automatiquement. Pour quitter ce mode, ils devront le désactiver dans leur menu 'Jouabilité'."
L.help_namechange_kick = [[
Changer votre nom au cours d'une partie active peut être une source d'abus. C'est pourquoi cette pratique est interdite par défaut et entraînera une expulsion du joueur.

Si le temps d'expulsion est supérieur à 0, le joueur ne pourra pas se reconnecter au serveur tant que ce temps ne sera pas écoulé.]]
L.help_damage_log = "Chaque fois qu'un joueur subit des dégâts, une entrée dans le rapport de dégâts est ajoutée à la console si cette option est activée. Ce rapport peut également être stocké sur le disque après la fin d'une partie. Le fichier est situé dans 'data/terrortown/logs/'"
L.help_spawn_waves = [[
Si cette variable est fixée à 0, tous les joueurs apparaissent en même temps. Pour les serveurs avec un grand nombre de joueurs, il peut être avantageux de faire apparaître les joueurs par vagues. L'intervalle entre les vagues est le temps qui s'écoule entre chaque vague. Une vague d'apparition génère toujours autant de joueurs qu'il y a de points d'apparition valides.

Note : Assurez-vous que le temps de préparation d'une partie est suffisamment long pour le nombre de vagues de d'apparition désiré.]]
L.help_voicechat_battery = [[
Le chat vocal avec une batterie activée réduit la charge de la batterie. Lorsqu'elle est vide, le joueur ne peut plus utiliser le chat vocal et doit attendre qu'elle se recharge. Cela permet d'éviter une utilisation excessive du chat vocal.

Remarque : Le terme 'Tick ' fait référence à un Tick de jeu. Par exemple, si le taux de tick est fixé à 66, il sera de 1/66e de seconde.]]
L.help_ply_spawn = "Paramètres de joueur utilisés lors de la (ré)apparition d'un joueur."
L.help_haste_mode = [[
Le mode Hâtif équilibre le jeu en augmentant la durée de la partie pour chaque joueur mort. Seuls les rôles qui voient des joueurs disparus peuvent voir la durée réelle de la partie. Tous les autres rôles ne peuvent voir que le temps de départ du mode Hâtif.

Si le mode Hâtif est activé, le temps de la partie fixé est ignoré.]]
L.help_round_limit = "Lorsque l'une des conditions est remplie, un changement de carte est enclenché."
L.help_armor_balancing = "Les valeurs suivantes peuvent être utilisées pour équilibrer l'armure."
L.help_item_armor_classic = "Si le mode d'armure classique est activé, seuls les paramètres précédents sont pris en compte. Le mode d'armure classique signifie qu'un joueur ne peut acheter une armure qu'une seule fois par partie, et que cette armure bloque 30 % des dégâts infligés par les balles et les pieds de biche jusqu'à ce qu'il meure."
L.help_item_armor_dynamic = [[
L'armure dynamique est l'approche de TTT2 pour rendre l'armure plus intéressante. La quantité d'armure pouvant être achetée est désormais illimitée, et la valeur de l'armure s'accumule. Les dégâts subis diminuent la valeur de l'armure. La valeur d'armure par objet d'armure acheté est définie dans les 'Paramètres d'Équipements' de l'objet en question.

Lorsque le joueur subit des dégâts, un certain pourcentage de ces dégâts sont convertis en dégâts d'armure, un autre pourcentage est encore appliqué au joueur et le reste disparaît.

Si l'armure renforcée est activée, les dégâts appliqués au joueur sont diminués de 15 % tant que la valeur de l'armure est supérieure au seuil de renforcement.]]
L.help_sherlock_mode = "Le mode sherlock est un mode TTT classique. Si le mode sherlock est désactivé, les corps ne peuvent pas être confirmés, le tableau des scores indique que tout le monde est en vie et les spectateurs peuvent parler aux joueurs vivants."
L.help_prop_possession = [[
La possession d'entité peut être utilisée par les spectateurs pour posséder des entités qui se trouvent dans le monde et utiliser le 'FRAPPE-O-METRE' qui se recharge lentement pour déplacer l'entité.

La valeur maximale du 'FRAPPE-O-METRE' se compose d'une valeur de base de possession, à laquelle s'ajoute la différence meurtres/morts, comprise entre deux limites définies. Le compteur se recharge lentement au fil du temps. Le temps de recharge défini est le temps nécessaire pour recharger un seul point du 'FRAPPE-O-METRE'.]]
L.help_karma = "Les joueurs commencent avec un certain montant de Karma et le perdent lorsqu'ils blessent/tuent des alliés. Le montant qu'ils perdent dépend du Karma de la personne qu'ils ont blessée/tuée. Un Karma faible réduit les dégâts infligés."
L.help_karma_strict = "Si le Karma strict est activé, la pénalité de dégâts augmente plus rapidement lorsque le Karma diminue. Lorsqu'il est désactivé, la pénalité de dégâts est très faible lorsque les joueurs restent au-dessus de 800 de Karma. En activant le mode strict, le Karma joue un rôle plus important en décourageant tout meurtre inutile, alors qu'en le désactivant on obtient un jeu plus 'relâché' où le Karma ne nuit qu'aux joueurs qui tuent constamment leurs alliés."
L.help_karma_max = "Le fait de fixer la valeur du Karma maximum à plus de 1000 ne donne pas de bonus de dégâts aux joueurs ayant plus de 1000 Karma. Il peut être utilisé comme une réserve de Karma."
L.help_karma_ratio = "Le ratio des dégâts qui est utilisé pour calculer le montant de Karma de la victime qui est soustrait de celui de l'attaquant si les deux font partie de la même équipe. Si un meurtre allié a lieu, une pénalité supplémentaire est appliquée."
L.help_karma_traitordmg_ratio = "Le ratio des dégâts qui est utilisé pour calculer le montant de Karma de la victime qui est ajouté à celui de l'attaquant si les deux sont dans des équipes différentes. Si un ennemi est tué, un bonus supplémentaire est appliqué."
L.help_karma_bonus = "Il existe également deux manières passives différentes de gagner du Karma au cours d'une partie. La première est une restauration du Karma qui s'applique à tous les joueurs à la fin de la partie. Ensuite, un bonus de partie parfaite est accordé si aucun allié n'a été blessé ou tué par un joueur."
L.help_karma_clean_half = [[
Lorsqu'un joueur a un Karma supérieur au montant de départ (c'est-à-dire que le Karma maximum a été configuré pour être supérieur à ce montant), toutes ses augmentations de Karma seront réduites en fonction de l'écart entre son Karma et le montant de départ. Il augmente donc moins vite au fur et à mesure qu'il est plus élevé.

Cette réduction suit une courbe de décroissance exponentielle : au début, elle est rapide, puis elle ralentit au fur et à mesure que l'incrément diminue. Ce convar détermine à quel moment le bonus a été divisé par deux. Avec la valeur par défaut de 0.25, si le montant de départ du Karma est de 1000 et le maximum de 1500, et qu'un joueur a un Karma de 1125 ((1500 - 1000) * 0.25 = 125), alors son bonus sera de 30 / 2 = 15. Donc pour que le bonus descende plus vite il faut baisser ce convar, pour qu'il descende moins vite il faut l'augmenter proche de 1.]]
L.help_max_slots = "Définit le nombre maximum d'armes par emplacement. '-1' signifie qu'il n'y a pas de limite."
L.help_item_armor_value = "Il s'agit de la valeur d'armure donnée par l'armure en mode dynamique. Si le mode classique est activé (voir 'Administration' -> 'Paramètres des joueurs'), toute valeur supérieure à 0 est comptée comme une armure existante."

L.label_killer_dna_range = "Portée maximale pour laisser de l'ADN"
L.label_killer_dna_basetime = "Temps de base de la durée de vie de l'échantillon d'ADN"
L.label_dna_scanner_slots = "Emplacements pour les échantillons d'ADN"
L.label_dna_radar = "Activer le mode classique du scanner d'ADN"
L.label_dna_radar_cooldown = "Temps de recharge du scanner ADN"
L.label_radar_charge_time = "Temps de recharge après utilisation"
L.label_crowbar_shove_delay = "Temps de recharge après avoir poussé"
L.label_idle = "Activer le mode inactif"
L.label_idle_limit = "Temps maximum d'inactivité en secondes"
L.label_namechange_kick = "Activer l'expulsion en cas de changement de nom"
L.label_namechange_bantime = "Durée du bannissement en minutes après une expulsion"
L.label_log_damage_for_console = "Activer le rapport des dégâts dans la console"
L.label_damagelog_save = "Sauvegarder le rapport des dégâts sur un disque"
L.label_debug_preventwin = "Empêcher toute condition de victoire [debug]"
L.label_bots_are_spectators = "Les bots sont toujours en mode spectateurs"
L.label_tbutton_admin_show = "Affiche les boutons des traîtres aux administrateurs"
L.label_ragdoll_carrying = "Activer le fait de pouvoir transporter n'importe quel corps"
L.label_prop_throwing = "Activer le lancer d'entité"
L.label_weapon_carrying = "Activer le port d'armes"
L.label_weapon_carrying_range = "Portée de l'arme"
L.label_prop_carrying_force = "Force de ramassage d'entité"
L.label_teleport_telefrags = "Tuer le(s) joueur(s) bloquant(s) le point de téléportation lors d'une téléportation (téléfrag)"
L.label_allow_discomb_jump = "Autoriser le saut a la discombobulateur pour le lanceur de grenade"
L.label_spawn_wave_interval = "Intervalle entre les vagues d'apparition en secondes"
L.label_voice_enable = "Activer le chat vocal"
L.label_voice_drain = "Activer la fonction de batterie du chat vocal"
L.label_voice_drain_normal = "Consommation par tick pour les joueurs"
L.label_voice_drain_admin = "Consommation par tick pour les admin et rôles de détective"
L.label_voice_drain_recharge = "Temps de recharge par tick"
L.label_locational_voice = "Activer le chat vocal de proximité pour les joueurs vivants"
L.label_locational_voice_prep = "Activer le chat vocal de proximité pendant la phase de préparation"
L.label_locational_voice_range = "Portée du chat vocal de proximité"
L.label_armor_on_spawn = "Armure du joueur lors d'une (ré)apparition"
L.label_prep_respawn = "Activer la réapparition instantanée pendant la phase de préparation"
L.label_preptime_seconds = "Durée de la phase de préparation en secondes"
L.label_firstpreptime_seconds = "Durée de la PREMIÈRE phase de préparation en secondes"
L.label_roundtime_minutes = "Durée d'une partie en minutes"
L.label_haste = "Activer le mode hâtif"
L.label_haste_starting_minutes = "Temps de démarrage du mode hâtif en minutes"
L.label_haste_minutes_per_death = "Temps additionnel en minutes par mort"
L.label_posttime_seconds = "Durée de la phase de fin de partie en secondes"
L.label_round_limit = "Nombre de parties maximum sur cette carte"
L.label_time_limit_minutes = "Temps de jeu maximum en minutes sur cette carte"
L.label_nade_throw_during_prep = "Activer le lancer de grenade pendant la phase de préparation"
L.label_postround_dm = "Activer le match à mort a la fin de la partie"
L.label_spectator_chat = "Activer le chat entre les spectateurs et les vivants"
L.label_lastwords_chatprint = "Affiche les derniers mots dans le chat si la personne est tuée pendant qu'elle écrit."
L.label_identify_body_woconfirm = "Identifier les corps sans appuyer sur le bouton 'confirmer'"
L.label_announce_body_found = "Annoncer qu'un corps a été trouvé quand que le corps est confirmé"
L.label_confirm_killlist = "Annoncer la liste des meurtres du corps confirmé"
L.label_dyingshot = "Tirer quand vous mourrez si quelqu'un est dans votre ligne de mire [expérimental]"
L.label_armor_block_headshots = "Activer le blocage des tirs à la tête grâce à l'armure"
L.label_armor_block_blastdmg = "Activer le blocage des dégâts d'explosion grâce à l'armure"
L.label_armor_dynamic = "Activer l'armure dynamique"
L.label_armor_value = "Montant d'armure"
L.label_armor_damage_block_pct = "Pourcentage de dégâts encaissés par l'armure"
L.label_armor_damage_health_pct = "Pourcentage de dégâts encaissés par le joueur"
L.label_armor_enable_reinforced = "Activer l'armure renforcée"
L.label_armor_threshold_for_reinforced = "Seuil de renforcement"
L.label_sherlock_mode = "Activer le mode sherlock"
L.label_highlight_admins = "Mettre en surbrillance les noms des administrateurs du serveur"
L.label_highlight_dev = "Mettre en surbrillance les noms des développeurs du TTT2"
L.label_highlight_vip = "Mettre en surbrillance les noms des supporter du TTT2"
L.label_highlight_addondev = "Mettre en surbrillance les noms des développeurs d'addons du TTT2"
L.label_highlight_supporter = "Mettre en surbrillance les noms des autres"
L.label_enable_hud_element = "Activer l'éléments {elem} du HUD"
L.label_spec_prop_control = "Activer la possession d'entité"
L.label_spec_prop_base = "Valeur de base de la possession"
L.label_spec_prop_maxpenalty = "Limite minimale de la possession d'entité"
L.label_spec_prop_maxbonus = "Limite maximale de la possession d'entité"
L.label_spec_prop_force = "Force de poussée lors de la possession d'entité"
L.label_spec_prop_rechargetime = "Temps de recharge en secondes"
L.label_doors_force_pairs = "Forcer les portes proches à devenir des portes doubles"
L.label_doors_destructible = "Activer la destruction des portes"
L.label_doors_locked_indestructible = "Les portes initialement verrouillées sont indestructibles"
L.label_doors_health = "Point de vie des portes"
L.label_doors_prop_health = "Point de vie des portes détruite"
L.label_minimum_players = "Nombre minimum de joueurs pour commencer une partie"
L.label_karma = "Activer le Karma"
L.label_karma_strict = "Activer le Karma strict"
L.label_karma_starting = "Karma de départ"
L.label_karma_max = "Karma maximum"
L.label_karma_ratio = "Ratio de pénalité par dégâts causés à un allié"
L.label_karma_kill_penalty = "Pénalité pour le meurtre d'un allié"
L.label_karma_round_increment = "Restauration du Karma"
L.label_karma_clean_bonus = "Bonus de partie parfaite"
L.label_karma_traitordmg_ratio = "Ratio bonus par dégâts infligés aux ennemis"
L.label_karma_traitorkill_bonus = "Bonus pour le meutre d'un ennemi"
L.label_karma_clean_half = "Réduction du bonus de partie parfaite "
L.label_karma_persist = "Le Karma ne se remet pas à zéro lors d'un changement de carte"
L.label_karma_low_autokick = "Expulsion automatique des joueurs ayant un Karma faible"
L.label_karma_low_amount = "Seuil du Karma faible"
L.label_karma_low_ban = "Bannissement des joueurs ayant un Karma faible"
L.label_karma_low_ban_minutes = "Durée du bannissement en minutes"
L.label_karma_debugspam = "Activer les messages de débug dans la console concernant les modifications apportées au Karma"
L.label_max_melee_slots = "Nombre maximal d'emplacements d'armes de mêlée"
L.label_max_secondary_slots = "Nombre maximal d'emplacements d'armes secondaires"
L.label_max_primary_slots = "Nombre maximal d'emplacements d'arme principale"
L.label_max_nade_slots = "Nombre maximal d'emplacements de grenade"
L.label_max_carry_slots = "Nombre maximal d'emplacements d'objets portable"
L.label_max_unarmed_slots = "Nombre maximal d'emplacements non armés"
L.label_max_special_slots = "Nombre maximal d'emplacements d'armes spéciales"
L.label_max_extra_slots = "Nombre maximal d'emplacements supplémentaire"
L.label_weapon_autopickup = "Activer le ramassage automatique des armes"
L.label_sprint_enabled = "Activer le sprint"
L.label_sprint_max = "Vitesse du sprint"
L.label_sprint_stamina_consumption = "Consommation d'endurance"
L.label_sprint_stamina_regeneration = "Régénération d'endurance"
L.label_crowbar_unlocks = "L'attaque principale peut être utilisée pour interagir (Ouvrir des portes)"
L.label_crowbar_pushforce = "Force de la poussée du pied de biche"

-- 2022-07-02
L.header_playersettings_falldmg = "Paramètres des dégâts de chute"

L.label_falldmg_enable = "Activer les dégâts de chute"
L.label_falldmg_min_velocity = "Vitesse minimum pour pouvoir surbir des dégâts de chute"
L.label_falldmg_exponent = "Exposant des dégâts de chute en fonction de la vitesse"

L.help_falldmg_exponent = [[
Cette valeur modifie l'augmentation exponentielle des dégâts de chute en fonction de la vitesse à laquelle le joueur touche le sol.

Soyez prudent lorsque vous modifiez cette valeur. Une valeur trop élevée peut rendre les plus petites chutes mortelles, tandis qu'une valeur trop basse permet aux joueurs de tomber d'une hauteur extrême sans subir de dégâts.]]

-- 2023-02-08
L.testpopup_title = "Une pop-up de test, maintenant avec un titre multiligne, comme il est BEAU !"
L.testpopup_subtitle = "Eh bien, bonjour ! Il s'agit d'une fenêtre pop-up sophistiquée contenant des informations spéciales. Le texte peut également être multiligne, quelle classe ! Ugh, je pourrais ajouter tellement plus de texte si j'avais eu des idées..."

L.hudeditor_chat_hint1 = "[TTT2][INFO] Passez au-dessus d'un élément, maintenez enfoncée le [Clic gauche] et bougez la souris pour le DÉPLACER ou le REDIMENSIONNER."
L.hudeditor_chat_hint2 = "[TTT2][INFO] Appuyez sur la touche ALT et maintenez-la enfoncée pour redimensionner de manière symétrique."
L.hudeditor_chat_hint3 = "[TTT2][INFO] Appuyez sur la touche MAJ et maintenez-la enfoncée pour vous déplacer sur l'axe et conserver le ratio d'aspect."
L.hudeditor_chat_hint4 = "[TTT2][INFO] Appuyez su [Clic droit] -> 'Fermer' pour quitter l'Éditeur d'HUD !"

L.guide_nothing_title = "Il n'y a rien ici pour l'instant !"
L.guide_nothing_desc = "Ce projet est en cours, aidez-nous en contribuant au projet sur GitHub."

L.sb_rank_tooltip_developer = "Développeur TTT2"
L.sb_rank_tooltip_vip = "Supporter TTT2"
L.sb_rank_tooltip_addondev = "Développeur d'Addon TTT2"
L.sb_rank_tooltip_admin = "Administrateur du Serveur"
L.sb_rank_tooltip_streamer = "Streamer"
L.sb_rank_tooltip_heroes = "Héros TTT2"
L.sb_rank_tooltip_team = "Équipe"

L.tbut_adminarea = "ESPACE ADMIN :"

-- 2023-08-10
L.equipmenteditor_name_damage_scaling = "Évolution des dégâts"

-- 2023-08-11
L.equipmenteditor_name_allow_drop = "Autorisation de jeter"
L.equipmenteditor_desc_allow_drop = "Si cette option est activée, l'équipement peut être jeté librement par le joueur."

L.equipmenteditor_name_drop_on_death_type = "Lâcher à la mort"
L.equipmenteditor_desc_drop_on_death_type = "L'équipement a des chances d'être lâché à la mort du joueur."

L.drop_on_death_type_default = "Par défaut (équipement défini)"
L.drop_on_death_type_force = "Forcée le lâcher d'équipement à la mort"
L.drop_on_death_type_deny = "Interdire le lâcher d'équipement à la mort"

-- 2023-08-26
L.equipmenteditor_name_kind = "Emplacement d'équipement"
L.equipmenteditor_desc_kind = "L'emplacement que l'équipement occupera."

L.slot_weapon_melee = "Emplacement d'armes de mêlée"
L.slot_weapon_pistol = "Emplacement d'armes secondaires"
L.slot_weapon_heavy = "Emplacement d'arme principale"
L.slot_weapon_nade = "Emplacement de grenade"
L.slot_weapon_carry = "Emplacement d'objets pouvant être portés"
L.slot_weapon_unarmed = "Emplacement non armés"
L.slot_weapon_special = "Emplacement d'armes spéciales"
L.slot_weapon_extra = "Emplacement supplémentaire"
L.slot_weapon_class = "Emplacement de la classe"

-- 2023-10-04
L.label_voice_duck_spectator = "Réduire les voix des spectateurs"
L.label_voice_duck_spectator_amount = "Niveau de réduction de la voix des spectateurs"
L.label_voice_scaling = "Mode d'évolution du volume de la voix"
L.label_voice_scaling_mode_linear = "Linéaire"
L.label_voice_scaling_mode_power4 = "Puissance 4"
L.label_voice_scaling_mode_log = "Logarithmique"

-- 2023-10-07
L.search_title = "Résultats de la fouille - {player}"
L.search_info = "Information"
L.search_confirm = "Confirmer la mort"
L.search_confirm_credits = "Confirmer (+{credits} Crédit(s))"
L.search_take_credits = "Prendre {credits} Crédit(s)"
L.search_confirm_forbidden = "Confirmation interdite"
L.search_confirmed = "Mort confirmée"
L.search_call = "Rapport de mort"
L.search_called = "Mort signalée"

L.search_team_role_unknown = "???"

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

L.search_floor_antlions = "Il y a encore des fourmi-lion sur tout le corps. Le sol doit en être recouvert."
L.search_floor_bloodyflesh = "Le sang sur ce corps est vieux et dégoûtant. Il y a même des petits morceaux de chair ensanglantée collés à ses chaussures."
L.search_floor_concrete = "De la poussière recouvre leurs chaussures et leurs genoux. On dirait que le sol de la scène de crime était en béton."
L.search_floor_dirt = "Ça sent la terre. Cela vient probablement de la saleté accrochée aux chaussures des victimes."
L.search_floor_eggshell = "Des taches blanches dégoûtantes recouvrent le corps de la victime. On dirait des coquilles d'œuf."
L.search_floor_flesh = "Les vêtements de la victime sont un peu humides. Comme s'ils étaient tombés sur une surface humide. Comme une surface charnue, ou un sol sablonneux d'un plan d'eau."
L.search_floor_grate = "La peau des la victimes ressemble à un steak. Des lignes épaisses formant une grille sont visibles sur l'ensemble de la peau. On-t-ils reposé sur une grille ?"
L.search_floor_alienflesh = "De la chair d'extraterrestre, vous pensez ? Ça semble un peu exagéré. Mais votre livre du détective pour les nuls l'indique comme une matière du sol possible."
L.search_floor_snow = "À première vue, leurs vêtements semblent seulement humides et glacés. Mais une fois que l'on voit la mousse blanche sur les bords on comprend. C'est de la neige !"
L.search_floor_plastic = "'Aïe, ça doit faire mal.' Leur corps est couvert de brûlures. Elles ressemblent à celles que l'on peut avoir en glissant sur une surface en plastique."
L.search_floor_metal = "Au moins, ils ne peuvent pas attraper le tétanos maintenant qu'ils sont morts. La rouille recouvre leurs plaies. Ils sont probablement morts sur une surface métallique."
L.search_floor_sand = "Des petits cailloux rugueux sont collés à leur corps froid. Comme du sable a la plage. Argh, il y en a partout !"
L.search_floor_foliage = "La nature est merveilleuse. Les plaies ensanglantées de la victime sont recouvertes de suffisamment de végétation pour être presque cachées."
L.search_floor_computer = "Bip-boop. Leur corps est recouvert d'une surface informatique ! Comment cela se présente-t-il, me direz-vous ? Eh bien,euh!"
L.search_floor_slosh = "Mouillé et peut-être même un peu visqueux. Tout leur corps en est recouvert et leurs vêtements sont trempés. Ça pue !"
L.search_floor_tile = "De petits éclats sont coincés dans leur peau. Comme des éclats de carreaux brisés lors de l'impact."
L.search_floor_grass = "Ça sent l'herbe fraîchement coupée. L'odeur domine presque celle du sang et de la mort."
L.search_floor_vent = "Vous sentez une bouffée d'air frais lorsque vous touchez leur corps. Est-il mort dans une bouche d'aération et a-t-il emporté de l'air avec lui ?"
L.search_floor_wood = "Qu'y a-t-il de plus agréable que de s'asseoir sur un parquet et de se plonger dans ses pensées ? Au moins beaucoup sont morts sur un plancher en bois !"
L.search_floor_default = "Cela semble si simple, si normal. Presque standard. On ne peut rien dire du type de surface."
L.search_floor_glass = "Leur corps est couvert de nombreuses entailles sanglantes. Dans certaines d'entre elles des éclats de verre sont coincés et semblent plutôt menaçantes."
L.search_floor_warpshield = "Un sol fait de warpshield ? Oui, nous sommes aussi confus que vous. Mais nos notes l'indiquent clairement. Warpshield."

L.search_water_1 = "Les chaussures de la victime sont mouillées, mais le reste semble sec. La victime a probablement été tuée les pieds dans l'eau."
L.search_water_2 = "Les chaussures et le pantalon de la victime sont trempés. La victime s'est-elle promenée dans l'eau avant d'être tuée ?"
L.search_water_3 = "Tout le corps est mouillé et gonflé. La victime est probablement morte alors qu'elle était complètement immergée."

L.search_weapon = "Il semblerait qu'un {weapon} a été utilisé pour le tuer."
L.search_head = "Une blessure fatale a été portée à la tête. Impossible de crier."
L.search_time = "Il est mort il y a peu de temps avant que vous ne le recherchiez."
L.search_dna = "Récupérez un échantillon de l'ADN du tueur à l'aide d'un scanner ADN. L'échantillon d'ADN se décompose au bout d'un certain temps."

L.search_kills1 = "Vous avez trouvé une liste de meurtres qui confirme la mort de {player}."
L.search_kills2 = "Vous avez trouvé une liste de meurtres avec les noms suivants: {player}"
L.search_eyes = "En utilisant vos compétences de détective, vous avez identifié la dernière personne qu'il a vue: {player}. Serait-ce le tueur, ou une coïncidence?"

L.search_credits = "La victime a {credits} crédit(s) d'équipement dans sa poche. Un rôle ayant une boutique pourrait les prendre et les utiliser à bon escient. Gardez un œil dessus !"

L.search_kill_distance_point_blank = "C'était une attaque à bout portant."
L.search_kill_distance_close = "L'attaque est venue d'une courte distance."
L.search_kill_distance_far = "L'attaque est venue d'une grande distance."

L.search_kill_from_front = "La victime a été tuée de face."
L.search_kill_from_back = "La victime a été tuée par derrière."
L.search_kill_from_side = "La victime a été tuée sur de côté."

L.search_hitgroup_head = "Le projectile a été retrouvé dans sa tête."
L.search_hitgroup_chest = "Le projectile a été retrouvé dans sa poitrine."
L.search_hitgroup_stomach = "Le projectile a été retrouvé dans son estomac."
L.search_hitgroup_rightarm = "Le projectile a été retrouvé dans son bras droit."
L.search_hitgroup_leftarm = "Le projectile a été retrouvé dans son bras gauche."
L.search_hitgroup_rightleg = "Le projectile a été retrouvé dans sa jambe droite."
L.search_hitgroup_leftleg = "Le projectile a été retrouvé dans sa jambe gauche."
L.search_hitgroup_gear = "Le projectile a été retrouvé dans sa hanche."

L.search_policingrole_report_confirm = [[
Un rôle de détective public ne peut être appelé auprès d'un corps qu'après que la mort du corps a été confirmée.]]
L.search_policingrole_confirm_disabled_1 = [[
Le corps ne peut être confirmé que par un rôle de détective public. Signalez le corps pour les informer !]]
L.search_policingrole_confirm_disabled_2 = [[
Le corps ne peut être confirmé que par un rôle de détective public. Signalez le corps pour les informer !
Vous pouvez consulter les informations ici après qu'elles aient été confirmées.]]
L.search_spec = [[
En tant que spectateur, vous pouvez voir toutes les informations relatives à un corps, mais vous ne pouvez pas interagir avec l'interface utilisateur.]]

L.search_title_words = "Derniers mots de la victime"
L.search_title_c4 = "Incident lors d'un désamorçage"
L.search_title_dmg_crush = "Dégâts dus à un écrasement ({amount} HP)"
L.search_title_dmg_bullet = "Dégâts causés par les balles ({amount} HP)"
L.search_title_dmg_fall = "Dégâts dus à la chute ({amount} HP)"
L.search_title_dmg_boom = "Dégâts dus à l'explosion ({amount} HP)"
L.search_title_dmg_club = "Dégâts causés par un club ({amount} HP)"
L.search_title_dmg_drown = "Dégâts dus à la noyade ({amount} HP)"
L.search_title_dmg_stab = "Dégâts causés par les coups de couteau ({amount} HP)"
L.search_title_dmg_burn = "Dégâts de brûlure  ({amount} HP)"
L.search_title_dmg_teleport = "Dégâts de téléportation ({amount} HP)"
L.search_title_dmg_car = "Accident de voiture ({amount} HP)"
L.search_title_dmg_other = "Dégâts inconnus ({amount} HP)"
L.search_title_time = "Heure du décès"
L.search_title_dna = "Décomposition de l'échantillon d'ADN"
L.search_title_kills = "Liste des victimes du meurtrier"
L.search_title_eyes = "L'ombre du meurtrier"
L.search_title_floor = "Sol de la scène de crime"
L.search_title_credits = "{credits} Crédit(s) d'équipement"
L.search_title_water = "Niveau de l'eau {level}"
L.search_title_policingrole_report_confirm = "Confirmer le signalement du corps"
L.search_title_policingrole_confirm_disabled = "Confirmer la mort"
L.search_title_spectator = "Vous êtes en spectateur"

L.target_credits_on_confirm = "Confirmer la réception des crédits non dépensés"
L.target_credits_on_search = "Recherche de crédits non dépensés"
L.corpse_hint_no_inspect_details = "Seuls les rôles de détective public peuvent trouver des informations sur ce corps."
L.corpse_hint_inspect_limited_details = "Seules les rôles de détective public peuvent confirmer la mort du corps."
L.corpse_hint_spectator = "Appuyez sur [{usekey}] pour afficher l'interface utilisateur de fouille"
L.corpse_hint_public_policing_searched = "Appuyez sur [{usekey}] pour afficher les résultats de la  fouille du rôle de détective public"

L.label_inspect_confirm_mode = "Sélectionner le mode de fouille des corps"
L.choice_inspect_confirm_mode_0 = "mode 0: TTT standard"
L.choice_inspect_confirm_mode_1 = "mode 1: confirmation limitée"
L.choice_inspect_confirm_mode_2 = "mode 2: fouille limitée"
L.help_inspect_confirm_mode = [[
Ce mode de jeu propose trois modes différents de fouille/confirmation de corps. Le choix du mode a une grande influence sur l'importance des rôles de détective public, comme celui du détective.

mode 0: C'est le fonctionnement standard du TTT. Tout le monde peut fouiller et confirmer les corps. Pour signaler un corps ou en prendre les crédits, le corps doit d'abord être confirmé. Cela rend un peu plus difficile pour les rôles ayant une boutique de voler discrètement des crédits. Cependant, les joueurs innocents qui veulent signaler le corps pour appeler un joueur ayant un rôles de détective public doivent également confirmer le corps au préalable.

mode 1: Ce mode renforce l'importance des rôles de détective public en limitant l'option de confirmation à ces derniers. Cela signifie également qu'il est désormais possible de prendre des crédits et de signaler des corps avant de confirmer un corps. Tout le monde peut toujours fouiller les corps et trouver des informations, mais il n'est pas possible d'annoncer les informations trouvées.

mode 2: Ce mode est un peu plus strict que le mode 1. Dans ce mode, la capacité de fouille est également retirée aux joueurs normaux. Cela signifie que le signalement d'un corps à un joueur ayant un rôles de détective public est désormais le seul moyen d'obtenir des informations (comme le rôle du joueur par exemple) sur les corps.]]

-- 2023-10-19
L.label_grenade_trajectory_ui = "Indicateur de trajectoire des grenades"

-- 2023-10-23
L.label_hud_pulsate_health_enable = "Pulsation de la barre de santé en dessous de 25 %"
L.header_hud_elements_customize = "Personnaliser l'élément du HUD"
L.help_hud_elements_special_settings = "Il s'agit de paramètres spécifiques pour l'élément du HUD utilisés."

-- 2023-10-25
L.help_keyhelp = [[
L'assistant de touches est un élément de l'interface utilisateur qui affiche toujours les raccourcis clavier pertinents pour le joueur, ce qui est particulièrement utile pour les nouveaux joueurs. Il existe trois types d'assistant de touches :

Base : Ils contiennent les touches les plus importantes de TTT2. Sans eux, le jeu est difficile à jouer à son plein potentiel.
Extra : Similaire au touche de base, mais vous n'en avez pas toujours besoin. Ils contiennent des éléments comme le chat textuel, le chat vocal ou la lampe torche. Il peut être utile pour les nouveaux joueurs de les activer.
Équipement : Certains équipements ont leurs propres touches, elles sont présentées dans cette catégorie.

Les catégories désactivées sont toujours affichées lorsque le tableau des scores est visible]]

L.label_keyhelp_show_core = "Activer l'affichage en permanence des touches de Base"
L.label_keyhelp_show_extra = "Activer l'affichage en permanence des touches touches Extra"
L.label_keyhelp_show_equipment = "Activer l'affichage en permanence des touches des Équipement"

L.header_interface_keys = "Paramètres de l'assistant de touches"
L.header_interface_wepswitch = "Paramètres de l'interface utilisateur des changement d'arme"

L.label_keyhelper_help = "ouvrir le menu du mode de jeu"
L.label_keyhelper_mutespec = "cycle du mode muet des spectateurs"
L.label_keyhelper_shop = "ouvrir la boutique d'équipement"
L.label_keyhelper_show_pointer = "afficher le curseur de la souris"
L.label_keyhelper_possess_focus_entity = "posséder l'entité ciblée"
L.label_keyhelper_spec_focus_player = "observer le joueur ciblé"
L.label_keyhelper_spec_previous_player = "joueur précédent"
L.label_keyhelper_spec_next_player = "joueur suivant"
L.label_keyhelper_spec_player = "observer un joueur au hasard"
L.label_keyhelper_possession_jump = "entité: sauter"
L.label_keyhelper_possession_left = "entité: gauche"
L.label_keyhelper_possession_right = "entité: droite"
L.label_keyhelper_possession_forward = "entité: avancer"
L.label_keyhelper_possession_backward = "entité: reculer"
L.label_keyhelper_free_roam = "quitter l'entité et se déplacer librement"
L.label_keyhelper_flashlight = "activer/désactiver la lampe torche"
L.label_keyhelper_quickchat = "ouvrir le chat rapide"
L.label_keyhelper_voice_global = "chat vocal global"
L.label_keyhelper_voice_team = "chat vocal d'équipe"
L.label_keyhelper_chat_global = "chat textuel global"
L.label_keyhelper_chat_team = "chat textuel d'équipe"
L.label_keyhelper_show_all = "tout afficher"
L.label_keyhelper_disguiser = "activer/désactiver le déguisement"
L.label_keyhelper_save_exit = "sauvegarder et quitter"
L.label_keyhelper_spec_third_person = "activer/désactiver la vue en 3ème personne"

-- 2023-10-26
L.item_armor_reinforced = "Armure renforcée"
L.item_armor_sidebar = "L'armure vous protège contre les balles qui pénètrent dans votre corps. Mais pas pour toujours."
L.item_disguiser_sidebar = "Le déguisement protège votre identité en ne montrant pas votre nom aux autres joueurs."
L.status_speed_name = "Multiplicateur de vitesse"
L.status_speed_description_good = "Vous êtes plus rapide que la normale. Les objets, équipement et les effets peuvent influer sur votre vitesse."
L.status_speed_description_bad = "Vous êtes plus lent que la normale. Les objets, équipement et les effets peuvent influer sur votre vitesse."

L.status_on = "Activer"
L.status_off = "Désactiver"

L.crowbar_help_primary = "Attaquer"
L.crowbar_help_secondary = "Pousser le joueur"

-- 2023-10-27
L.help_HUD_enable_description = [[
Certains éléments du HUD, comme l'assistant de touches ou la barre latérale, affichent des informations détaillées lorsque le tableau des scores est ouvert. Ces éléments peuvent être désactivés pour réduire la pollution visuelle.]]
L.label_HUD_enable_description = "Activer les descriptions lorsque le tableau des scores est ouvert"
L.label_HUD_enable_box_blur = "Activer le flou en arrière-plan de l'interface utilisateur"

-- 2023-10-28
L.submenu_gameplay_voiceandvolume_title = "Voix & Volume"
L.header_soundeffect_settings = "Effets Sonores"
L.header_voiceandvolume_settings = "Paramètres des Voix et des Volumes"

-- 2023-11-06
L.drop_reserve_prevented = "Quelque chose vous empêche de jeter vos munitions en réserve."
L.drop_no_reserve = "Nombre de munitions insuffisant dans votre réserve pour jeter une boîte de munitions."
L.drop_no_room_ammo = "Vous n'avez pas de place ici pour jeter vos munitions !"

-- 2023-11-14
L.hat_deerstalker_name = "Chapeau du Détective"

-- 2023-11-16
L.help_prop_spec_dash = [[
Les entités possédées par les spectateurs se déplacent dans la direction qu'ils visent. Les déplacements peuvent être plus puissants que les mouvements normaux. Une force plus élevée signifie également une consommation de la force de base plus importante.

Cette variable est un multiplicateur de la force de poussée.]]
L.label_spec_prop_dash = "Force de déplacement"
L.label_keyhelper_possession_dash = "entité: déplacement dans la direction visée"
L.label_keyhelper_weapon_drop = "jeter l'arme sélectionnée si possible"
L.label_keyhelper_ammo_drop = "jeter les munitions en réserve de l'arme sélectionnée"

-- 2023-12-07
L.c4_help_primary = "Placer le C4"
L.c4_help_secondary = "Coller à la surface"

-- 2023-12-11
L.magneto_help_primary = "Pousser l'entité"
L.magneto_help_secondary = "Tirer / porter l'entité"
L.knife_help_primary = "Poignarder"
L.knife_help_secondary = "Lancer le couteau"
L.polter_help_primary = "Tirer une impulsion"
L.polter_help_secondary = "Charger une impulsion à longue portée"

-- 2023-12-12
L.newton_help_primary = "Tir de propulsion"
L.newton_help_secondary = "Charger un tir de propulsion"

-- 2023-12-13
L.vis_no_pickup = "Seules les joueurs ayant un rôle de détective public peuvent utiliser le visualiseur."
L.newton_force = "FORCE"
L.defuser_help_primary = "Désamorcer le C4 ciblé"
L.radio_help_primary = "Placer la Radio"
L.radio_help_secondary = "Coller à la surface"
L.hstation_help_primary = "Placer la Station de Soins"
L.flaregun_help_primary = "Brûler un corps/une entité"

-- 2023-12-14
L.marker_vision_owner = "Propriétaire : {owner}"
L.marker_vision_distance = "Distance : {distance}"
L.marker_vision_distance_collapsed = "{distance}"

L.c4_marker_vision_time = "Temps avant détonation : {time}"
L.c4_marker_vision_collapsed = "{time} / {distance}"

L.c4_marker_vision_safe_zone = "Zone hors de portée du C4"
L.c4_marker_vision_damage_zone = "Zone de dégâts du C4"
L.c4_marker_vision_kill_zone = "Zone meurtrière du C4"

L.beacon_marker_vision_player = "Joueur traqué"
L.beacon_marker_vision_player_tracked = "Ce joueur est traqué par une Balise"

-- 2023-12-18
L.beacon_help_pri = "Placer la balise au sol"
L.beacon_help_sec = "Coller la balise à une surface"
L.beacon_name = "Balise"
L.beacon_desc = [[
Affiche l'emplacement des joueur à tous ceux qui se trouvent à proximité de la balise.

Utiliser la pour garder un œil sur les endroits de la carte qui sont difficiles à voir.]]

L.msg_beacon_destroyed = "Une de vos balises a été détruite !"
L.msg_beacon_death = "Un joueur est mort à proximité d'une de vos balises."

L.beacon_short_desc = "Les balises sont utilisées par les joueurs ayant un rôle de détective public pour avoir une vission a travers les murs proches d'eux."

L.entity_pickup_owner_only = "Seul le propriétaire peut le récupérer"

L.body_confirm_one = "{finder} a confirmé la mort de {victim}."
L.body_confirm_more = "{finder} a confirmé {count} morts : {victims}."

-- 2023-12-19
L.builtin_marker = "Intégré."
L.equipmenteditor_desc_builtin = "Cet équipement est intégré, il est inclus dans TTT2 !"
L.help_roles_builtin = "Ce rôle est intégré, il vient de TTT2 !"
L.header_equipment_info = "Informations d'Équipement"

-- 2023-12-20
L.equipmenteditor_desc_damage_scaling = [[Multiplie la valeur des dégâts de base d'une arme par ce facteur.
Pour un fusil à pompe, cela affecte chaque projectile.
Pour un fusil de sniper, cela affecte chaque balle.
Pour le poltergeist, cela affecte chaque propulseur et l'explosion finale.

0.5 = Inflige la moitié des dégâts.
2 = Inflige le double des dégâts.

Note: Certaines armes peuvent ne pas utiliser cette valeur, ce qui rend ce multiplicateur sans effet.]]

-- 2023-12-24
L.submenu_gameplay_accessibility_title = "Accessibilité"

L.header_accessibility_settings = "Paramètres d'Accessibilité"

L.label_enable_dynamic_fov = "Activer le changement dynamique du FOV"
L.label_enable_bobbing = "Activer le view bobbing"
L.label_enable_bobbing_strafe = "Activer le view bobbing quand vous mitraillez"

L.help_enable_dynamic_fov = "Le FOV dynamique est appliqué en fonction de la vitesse du joueur. Lorsqu'un joueur sprint par exemple, le FOV est augmenté pour visualiser la vitesse."
L.help_enable_bobbing_strafe = "Le view bobbing est un léger tremblement de la caméra lorsque l'on marche, que l'on nage ou que l'on tombe."

L.binoc_help_reload = "Effacer la cible"
L.cl_sb_row_sresult_direct_conf = "Confirmation directe"
L.cl_sb_row_sresult_pub_police = "Confirmation par un rôle de Détective public"

-- 2024-01-05
L.label_crosshair_thickness_outline_enable = "Activer le contour du réticule"
L.label_crosshair_outline_high_contrast = "Activer la couleur à fort contraste de contour"
L.label_crosshair_mode = "Mode du réticule"
L.label_crosshair_static_length = "Activer la ligne statique du réticule"

L.choice_crosshair_mode_0 = "Lignes et points"
L.choice_crosshair_mode_1 = "Lignes seulement"
L.choice_crosshair_mode_2 = "Points seulement"

L.help_crosshair_scale_enable = [[
Le réticule dynamique permet de redimensionner le réticule en fonction du champ de tir de l'arme. Le champ de tir est influencé par la précision de base de l'arme, multipliée par des facteurs externes tels que le saut et le sprint.

Si la longueur de la ligne reste statique, seul l'écart varie en fonction des changements du champ de tir.]]

L.header_weapon_settings = "Paramètres des Armes"

-- 2024-01-24
L.grenade_fuse = "EXPLOSION"

-- 2024-01-25
L.header_roles_magnetostick = "Magnéto-stick"
L.label_roles_ragdoll_pinning = "Le rôle peut accrocher les corps"
L.magneto_stick_help_carry_rag_pin = "Accrocher le corps"
L.magneto_stick_help_carry_rag_drop = "Décrocher le corps"
L.magneto_stick_help_carry_prop_release = "Porter l'entité"
L.magneto_stick_help_carry_prop_drop = "Poser l'entité"

-- 2024-01-27
L.decoy_help_primary = "Placer le leurre"
L.decoy_help_secondary = "Coller le leurre à la surface"


L.marker_vision_visible_for_0 = "Visible par vous"
L.marker_vision_visible_for_1 = "Visible par votre rôle"
L.marker_vision_visible_for_2 = "Visible par votre équipe"
L.marker_vision_visible_for_3 = "Visible pour tout le monde"

-- 2024-02-14
L.throw_no_room = "Vous n'avez pas de place ici pour jeter cet appareil"

-- 2024-03-04
L.use_entity = "Appuyez sur [{usekey}] pour utiliser"

-- 2024-03-06
L.submenu_gameplay_sounds_title = "Sons du Client"

L.header_sounds_settings = "Paramètres de l'Interface Utilisateur Sonores "

L.help_enable_sound_interact = "Les sons d'interaction sont les sons joués à l'ouverture d'une interface utilisateur. Ce type de son est joué par exemple lors de l'interaction avec un marqueur de la radio."
L.help_enable_sound_buttons = "Les sons de bouton sont des sons cliquetants qui sont joués lorsque l'on clique sur un bouton."
L.help_enable_sound_message = "Les sons de message ou de notification sont joués pour les messages de chat et les notifications. Ils peuvent être assez désagréables."

L.label_enable_sound_interact = "Activer les sons des interactions"
L.label_enable_sound_buttons = "Activer les sons des boutons"
L.label_enable_sound_message = "Activer les sons des messages"

L.label_level_sound_interact = "Volume des interactions"
L.label_level_sound_buttons = "Volume des boutons"
L.label_level_sound_message = "Volume des messages"

-- 2024-03-07
L.label_crosshair_static_gap_length = "Activer la taille d'espacement statique du réticule"
L.label_crosshair_size_gap = "Taille d'espacement des lignes statiques du réticule"

-- 2024-03-31
L.help_locational_voice = "Le chat de proximité est une implémentation de TTT2 de la voix localisée en 3D. Les joueurs ne sont audibles que dans un rayon déterminé autour d'eux et deviennent de plus en plus silencieux à mesure qu'ils s'éloignent."
L.help_locational_voice_prep = [[Par défaut, le chat de proximité est désactivé pendant la phase de préparation. Si cette option est activée, le chat de proximité est également activé pendant la phase de préparation.

Note: Le chat de proximité est toujours désactivé pendant la phase de fin de partie.]]
L.help_voice_duck_spectator = "La réduction des voix des spectateurs rend les autres spectateurs plus silencieux par rapport aux joueurs vivants. Cela peut être utile si vous souhaitez écouter attentivement les discussions des joueurs vivants."

L.help_equipmenteditor_configurable_clip = [[La valeur configurable définit le nombre d'utilisations de l'arme lorsqu'elle est achetée dans la boutique ou qu'elle apparaît dans le monde.

Note: Ce paramètre n'est disponible que pour les armes qui activent cette fonction.]]
L.label_equipmenteditor_configurable_clip = "Taille du chargeur configurable"

-- 2024-04-06
L.help_locational_voice_range = [[Cette option limite la portée maximale à laquelle les joueurs peuvent s'entendre. Elle ne modifie pas la façon dont le volume diminue en fonction de la distance mais fixe plutôt un point de coupure des voix.

Régler à 0 pour désactiver cette coupure.]]

-- 2024-04-07
L.help_voice_activation = [[Modifie la façon dont votre microphone est activé pour le chat vocal global. Toutes ces fonctions utilisent votre raccourci clavier 'Chat Vocal Global'. Le chat vocal d'équipe est toujours en mode appuyer-pour-parler.

Appuyer-pour-Parler: Maintenez la touche enfoncée pour parler.
Appuyer-pour-Muet: Votre micro est toujours activé, maintenez la touche enfoncée pour vous rendre muet.
Activer/Désactiver: Appuyez sur la touche pour activer/désactiver votre micro.
Activer/Désactiver (Activer lors de votre connexion): Comme 'Activer/Désactiver' mais votre micro est activé lorsque vous rejoignez le serveur.]]
L.label_voice_activation = "Mode d'Activation du Chat Vocal"
L.label_voice_activation_mode_ptt = "Appuyer pour Parler"
L.label_voice_activation_mode_ptm = "Appuyer pour Muet"
L.label_voice_activation_mode_toggle_disabled = "Activer/Désactiver"
L.label_voice_activation_mode_toggle_enabled = "Activer/Désactiver (Activer lors de votre connexion)"

-- 2024-04-08
L.label_inspect_credits_always = "Permettre à tous les joueurs de voir les crédits sur les corps"
L.help_inspect_credits_always = [[
Lorsqu'un rôle ayant une boutique meure, ses crédits peuvent être récupérés par d'autres joueurs possédant un rôle ayant une boutique.

Lorsque cette option est désactivée, seuls les joueurs qui peuvent ramasser des crédits peuvent les voir sur un corps.
Lorsque cette option est activée, tous les joueurs peuvent voir les crédits sur un corps.]]

-- 2024-05-13
L.menu_commands_title = "Commandes Administrateur"
L.menu_commands_description = "Changez de carte, faites apparaître des bots et modifiez les rôles des joueurs."

L.submenu_commands_maps_title = "Cartes"

L.header_maps_prefixes = "Activer/Désactiver les cartes en fonction de leur Préfixe"
L.header_maps_select = "Sélectionner et changer de carte"

L.button_change_map = "Changer de carte"

-- 2024-05-20
L.submenu_commands_commands_title = "Commandes"

L.header_commands_round_restart = "Redémarrer la partie"
L.header_commands_player_slay = "Tuer un Joueur"
L.header_commands_player_teleport = "Téléporter un joueur a l'emplacement visé"
L.header_commands_player_respawn = "Réanimer un joueur a l'emplacement visét"
L.header_commands_player_add_credits = "Ajouter des crédits d'équipement"
L.header_commands_player_set_health = "Définir la santé"
L.header_commands_player_set_armor = "Définir l'armure"

L.label_button_round_restart = "redémarrer la partie"
L.label_button_player_slay = "tuer le joueur"
L.label_button_player_teleport = "téléporter le joueur"
L.label_button_player_respawn = "réanimer le joueur"
L.label_button_player_add_credits = "ajouter des crédits"
L.label_button_player_set_health = "définir la santé"
L.label_button_player_set_armor = "définir l'armure"

L.label_slider_add_credits = "Définir le montant de crédit"
L.label_slider_set_health = "Définir la santé"
L.label_slider_set_armor = "Définir l'armure"

L.label_player_select = "Sélectionner un joueur"
L.label_execute_command = "Exécuter la commande"

-- 2024-05-22
L.tip38 = "Vous pouvez ramasser des armes ciblées en appuyant sur {usekey}. Vous déposerez automatiquement votre arme actuelle."
L.tip39 = "Vous pouvez modifier la configuration de vos touches dans le menu de Configuration des touches, situé dans le menu Paramètres, que vous pouvez ouvrir avec {helpkey}."
L.tip40 = "Sur le côté gauche de l'écran se trouvent des icônes indiquant les équipements actuels et les effets de statut qui vous sont appliqués."
L.tip41 = "Si vous ouvrez votre tableau des scores, la barre latérale et l'assistant de touches affichent des informations supplémentaires."
L.tip42 = "L'assistant de touches au bas de l'écran affiche les raccourcis clavier disponibles en temps réel."
L.tip43 = "L'icône à côté du nom d'un corps confirmé indique le rôle du joueur mort."

L.header_loadingscreen = "Écran de chargement"

L.help_enable_loadingscreen = "L'écran de chargement s'affiche lorsque la carte s'actualise après une partie. Il a été introduit pour masquer les ralentissements visibles et audibles qui apparaissent sur les grandes cartes. Il est également utilisé pour afficher des astuces."

L.label_enable_loadingscreen = "Activer l'écran de chargement"
L.label_enable_loadingscreen_tips = "Activer les astuces sur l'écran de chargement"

-- 2024-05-25
L.help_round_restart_reset = [[
Redémarrer une partie ou réinitialiser le niveau.

Redémarrer une partie ne fait que redémarrer la partie en cours pour que vous puissiez recommencer. La réinitialisation du niveau efface tout, de sorte que la partie recommence comme si la carte venait d'être changée.]]

L.label_button_level_reset = "réinitialiser le niveau"

L.loadingscreen_round_restart_title = "Démarrage d'une nouvelle partie"
--L.loadingscreen_round_restart_subtitle_limits_mode_0 = "you're playing on {map}"
--L.loadingscreen_round_restart_subtitle_limits_mode_1 = "you're playing on {map} for another {rounds} round(s) or {time}"
--L.loadingscreen_round_restart_subtitle_limits_mode_2 = "you're playing on {map} for {time}"
--L.loadingscreen_round_restart_subtitle_limits_mode_3 = "you're playing on {map} for another {rounds} round(s)"

-- 2024-06-23
L.header_roles_derandomize = "Dérandomisation des rôles"

L.help_roles_derandomize = [[
La Dérandomisation des rôles peut être utilisé pour rendre la distribution des rôles plus équitable au cours d'une session.

Lorsqu'elle est activée, les chances d'un joueur de recevoir un rôle augmentent s'il ne s'est pas vu attribuer ce rôle. Bien que cela puisse sembler plus juste, cela crée du métagaming, où un joueur peut deviner qu'un autre joueur sera un traître en se basant sur le fait qu'il n'a pas été traître depuis plusieurs parties. N'activez pas cette option si vous voulez éviter ce genre de situation.

Il y a 4 modes :

mode 0: Désactivé - Aucune Dérandomisation n'est effectuée.

mode 1: Rôles de base uniquement - La Dérandomisation est effectuée pour les rôles de base uniquement. Les sous-rôles sont sélectionnés de manière aléatoire. Ce sont les rôles comme Innocent et Traître.

mode 2: Sous-rôles uniquement - La Dérandomisation n'est effectuée que pour les sous-rôles. Les rôles de base seront sélectionnés de manière aléatoire. Notez que les sous-rôles ne sont attribués qu'aux joueurs qui ont déjà été sélectionnés pour leur rôle de base.

mode 3: Rôles de base ET sous-rôles - La Dérandomisation est effectuée à la fois pour les rôles de base et les sous-rôles.]]
L.label_roles_derandomize_mode = "Mode de Dérandomisation"
L.label_roles_derandomize_mode_none = "mode 0: Désactivé"
L.label_roles_derandomize_mode_base_only = "mode 1: Rôles de base uniquement"
L.label_roles_derandomize_mode_sub_only = "mode 2: Sous-rôles uniquement"
L.label_roles_derandomize_mode_base_and_sub = "mode 3: Rôles de base ET sous-rôles"

L.help_roles_derandomize_min_weight = [[
La Dérandomisation est réalisée en faisant en sorte que la sélection aléatoire des joueurs lors de la distribution des rôles utilise une probabilité associée à chaque rôle, et cette probabilité augmente de 1 chaque fois que le joueur ne se voit pas attribuer le rôle en question. Ces probabilités ne sont pas conservées entre les connexions, ni entre les cartes.

Chaque fois qu'un joueur se voit attribuer un rôle, la probabilité correspondante est ramenée à cette probabilité minimale. Cette probabilité n'a pas de signification absolue ; il ne peut être interprété que par rapport à d'autres probabilités.

Par exemple, si le joueur A a une probabilité de 1 et le joueur B une probabilité de 5, le joueur B a 5 fois plus de chances d'être sélectionné que le joueur A. Cependant, si le joueur A a une probabilité de 4, le joueur B n'a que 5/4 fois plus de chances d'être sélectionné.

La probabilité minimale permet donc de déterminer dans quelle mesure chaque partie affecte les chances d'un joueur d'être sélectionné, les valeurs les plus élevées ayant un effet moins important sur les chances du joueur. La valeur par défaut de 1 signifie que chaque partie entraîne une augmentation assez importante des chances et, inversement, qu'il est extrêmement improbable qu'un joueur obtienne le même rôle deux fois de suite.

Les modifications apportées à cette valeur ne prendront effet que lorsque les joueurs se reconnecteront ou que la carte aura changé.]]
L.label_roles_derandomize_min_weight = "Probabilité minimale de Dérandomisation"

-- 2024-08-17
L.name_button_default = "Bouton"
L.name_button_rotating = "Levier"

L.button_default = "Appuyez sur [{usekey}] pour actionner"
L.button_rotating = "Appuyez sur [{usekey}] pour basculer"

L.undefined_key = "???"

-- 2024-08-18
L.header_commands_player_force_role = "Forcer le Rôle d'un Joueur"

L.label_button_player_force_role = "forcer le rôle"

L.label_player_role = "Sélectionner un rôle"

-- 2024-09-16
L.help_enable_loadingscreen_server = [[
Les paramètres de l'écran de chargement existent également sur le client. Ils sont cachés s'ils sont désactivés sur le serveur.

Le temps d'affichage minimum est là pour donner au joueur le temps de lire les conseils. Si l'actualisation de la carte prend plus de temps que le temps minimum, l'écran de chargement sera affiché aussi longtemps qu'il le faudra. En général, l'actualisation de la carte prend entre 0.5 et 1 seconde.]]

L.label_enable_loadingscreen_server = "Activer l'écran de chargement du côté du serveur"
L.label_loadingscreen_min_duration = "Temps d'affichage minimum de l'écran de chargement"

-- 2024-09-18
L.label_keyhelper_leave_vehicle = "sortir du véhicule"
L.name_vehicle = "Véhicule"
L.vehicle_enter = "Appuyez sur [{usekey}] pour entrer dans le véhicule"

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
