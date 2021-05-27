-- Simplified Chinese language strings

local L = LANG.CreateLanguage("zh_hans")

-- Compatibility language name that might be removed soon.
-- the alias name is based on the original TTT language name:
-- https://github.com/Facepunch/garrysmod/blob/master/garrysmod/gamemodes/terrortown/gamemode/lang/simpchinese.lua
L.__alias = "简体中文"

L.lang_name = "简体中文 (Simplified Chinese)"

-- General text used in various places
L.traitor = "叛徒"
L.detective = "探长"
L.innocent = "无辜者"
L.last_words = "遗言"

L.terrorists = "恐怖分子"
L.spectators = "观察者"

L.nones = "无阵营"
L.innocents = "无辜阵营"
L.traitors = "叛徒阵营"

-- Round status messages
L.round_minplayers = "没有足够的玩家来开始新的回合…"
L.round_voting = "投票进行中，新的回合将推迟到 {num} 秒后开始…"
L.round_begintime = "新回合将在 {num} 秒后开始。请做好准备。"
L.round_selected = "叛徒玩家已选出"
L.round_started = "回合开始！"
L.round_restart = "游戏被管理员强制重新开始。"

L.round_traitors_one = "叛徒，你将孤身奋斗。"
L.round_traitors_more = "叛徒，你的队友是： {names} 。"

L.win_time = "时间用尽，叛徒失败了。"
L.win_traitor = "叛徒取得了胜利！"
L.win_innocent = "叛徒们被击败了！"
L.win_nones = "蜜蜂们胜利了！（平局）"
L.win_showreport = "来看一下 {num} 秒的回合总结吧！"

L.limit_round = "已达游戏回合上限，即将载入地图 {mapname}"
L.limit_time = "已达游戏时间上限，即将载入地图 {mapname}"
L.limit_left = "在载入地图 {mapname} 前，还有 {num} 回合或者 {time} 分钟的剩余时间。"

-- Credit awards
L.credit_all = "你的阵营因为表现获得了 {num} 点积分。"
L.credit_kill = "你杀死 {role} 获得了 {num} 点积分。"

-- Karma
L.karma_dmg_full = "你的人品为 {amount} ，因此本回合你将造成正常伤害。"
L.karma_dmg_other = "你的人品为 {amount} ，因此本回合你造成的伤害将减少 {num} %"

-- Body identification messages
L.body_found = " {finder} 发现了 {victim} 的尸体。{role}"
L.body_found_team = "{finder} 发现了 {victim} 的尸体。{role} ({team})"

-- The {role} in body_found will be replaced by one of the following:
L.body_found_traitor = "他是一位叛徒！"
L.body_found_det = "他是一位探长。"
L.body_found_inno = "他是一位无辜者。"

L.body_confirm = "{finder} 确认了 {victim} 的死亡。"

L.body_call = "{player} 请求探长前来检查 {victim} 的尸体！"
L.body_call_error = "你必须先确定该玩家的死才能呼叫探长！"

L.body_burning = "好烫！这个尸体着火了！"
L.body_credits = "你在尸体上找到 {num} 积分！"

-- Menus and windows
L.close = "关闭"
L.cancel = "取消"

-- For navigation buttons
L.next = "下一个"
L.prev = "上一个"

-- Equipment buying menu
L.equip_title = "装备"
L.equip_tabtitle = "购买装备"

L.equip_status = "购买菜单"
L.equip_cost = "你的积分剩下 {num} 点。"
L.equip_help_cost = "每一件装备都需要花费 1 点积分。"

L.equip_help_carry = "你只能在拥有空位时购买装备。"
L.equip_carry = "你能携带这件装备。"
L.equip_carry_own = "你已拥有这件装备。"
L.equip_carry_slot = "已拥有武器栏第 {slot} 项的武器。"
L.equip_carry_minplayers = "服务器玩家数量不足以启用这个武器。"

L.equip_help_stock = "每回合你只能购买一件相同的装备。"
L.equip_stock_deny = "这件装备卖空了。"
L.equip_stock_ok = "这件装备有库存。"

L.equip_custom = "此服务器的自定义装备。"

L.equip_spec_name = "名字"
L.equip_spec_type = "类型"
L.equip_spec_desc = "描述"

L.equip_confirm = "购买装备"

-- Disguiser tab in equipment menu
L.disg_name = "伪装器"
L.disg_menutitle = "伪装器控制"
L.disg_not_owned = "你没有伪装器！"
L.disg_enable = "执行伪装"

L.disg_help1 = "伪装开启后，别人瞄准你时将不会看见你的名字，生命以及人品。除此之外，你也能躲避探长的雷达。"
L.disg_help2 = "可直接在主选单外，使用数字键来切换伪装。你也可以用控制台指令绑定指令 ttt_toggle_disguise。"

-- Radar tab in equipment menu
L.radar_name = "雷达"
L.radar_menutitle = "雷达控制"
L.radar_not_owned = "你没有雷达！"
L.radar_scan = "执行扫描"
L.radar_auto = "自动重复扫描"
L.radar_help = "扫描结果将显示 {num} 秒，接着雷达充电后你便可以再次使用。"
L.radar_charging = "你的雷达还在充电中！"

-- Transfer tab in equipment menu
L.xfer_name = "转移"
L.xfer_menutitle = "转移积分"
L.xfer_send = "发送积分"

L.xfer_no_recip = "接收者无效，发送失败。"
L.xfer_no_credits = "积分不足，无法转移"
L.xfer_success = "成功向 {player} 发送积分！"
L.xfer_received = "{player} 给予你 {num} 积分。"

-- Radio tab in equipment menu
L.radio_name = "收音机"
L.radio_help = "点击按钮，让收音机播放音效。"
L.radio_notplaced = "你必须放置收音机以播放音效。"

-- Radio soundboard buttons
L.radio_button_scream = "尖叫"
L.radio_button_expl = "爆炸"
L.radio_button_pistol = "手枪射击"
L.radio_button_m16 = "M16步枪射击"
L.radio_button_deagle = "沙漠之鹰射击"
L.radio_button_mac10 = "MAC10冲锋枪射击"
L.radio_button_shotgun = "霰弹射击"
L.radio_button_rifle = "狙击步枪射击"
L.radio_button_huge = "M249机枪连发"
L.radio_button_c4 = "C4哔哔声"
L.radio_button_burn = "燃烧"
L.radio_button_steps = "脚步声"

-- Intro screen shown after joining
L.intro_help = "若你是TTT新手，可按下F1查看游戏教学！"

-- Radiocommands/quickchat
L.quick_title = "快速聊天"

L.quick_yes = "是。"
L.quick_no = "不是。"
L.quick_help = "救命！"
L.quick_imwith = "我和 {player} 在一起。"
L.quick_see = "我看到了 {player} 。"
L.quick_suspect = " {player} 行迹可疑。"
L.quick_traitor = " {player} 是叛徒！"
L.quick_inno = " {player} 是无辜者。"
L.quick_check = "还有人活着吗？"

-- {player} in the quickchat text normally becomes a player nickname, but can
-- also be one of the below. Keep these lowercase.
L.quick_nobody = "没有人"
L.quick_disg = "伪装着的人"
L.quick_corpse = "一具未搜索过的尸体"
L.quick_corpse_id = " {player} 的尸体"

-- Body search window
L.search_title = "尸体搜索结果"
L.search_info = "信息"
L.search_confirm = "确认死亡"
L.search_call = "呼叫探长"

-- Descriptions of pieces of information found
L.search_nick = "这是 {player} 的尸体。"

L.search_role_traitor = "这个人是叛徒！"
L.search_role_det = "这个人是探长。"
L.search_role_inno = "这个人是无辜的恐怖分子。"

L.search_words = "直觉告诉你这个人的遗言是： {lastwords}"
L.search_armor = "他穿着非标准装甲。"
L.search_disg = "他持有一个能隐匿身份的设备"
L.search_radar = "他持有像是雷达的装备，已经无法使用了。"
L.search_c4 = "你在他口袋中找到了一本笔记。记载着第 {num} 根线才能解除炸弹。"

L.search_dmg_crush = "他多处骨折。看起来是某种重物的冲击撞死了他。"
L.search_dmg_bullet = "他很明显是被射杀身亡的。"
L.search_dmg_fall = "他是坠落身亡的。"
L.search_dmg_boom = "他的伤口以及烧焦的衣物，应是爆炸导致其死亡。"
L.search_dmg_club = "他的身体有许多擦伤打击痕迹，明显是被殴打致死的。"
L.search_dmg_drown = "他身上的蛛丝马迹显示是溺死的。"
L.search_dmg_stab = "他是被刺击与挥砍后，迅速失血致死的。"
L.search_dmg_burn = "闻起来像烧焦的恐怖分子.."
L.search_dmg_tele = "看起来他的DNA以超光速粒子之形式散乱在附近。"
L.search_dmg_car = "他穿越马路时被一个粗心的驾驶碾死了。"
L.search_dmg_other = "你无法找到这恐怖份子的具体死因。"

L.search_weapon = "死者是被 {weapon} 所杀。"
L.search_head = "最后一击打在头上。完全没机会叫喊。"
L.search_time = "他大约死于你进行搜索的 {time} 前。"
L.search_dna = "用DNA扫描器检索凶手的DNA标本，DNA样本大约在 {time} 前开始衰退。"

L.search_kills1 = "你找到一个名单，记载着他发现的死者： {player}"
L.search_kills2 = "你找到了一个名单，记载着他杀的这些人:"
L.search_eyes = "透过你的探查技能，你确信他临死前见到的最后一个人是 {player} 。凶手，还是巧合？"

-- Scoreboard
L.sb_playing = "你正在玩的服务器是.."
L.sb_mapchange = "地图将于 {num} 个回合或是 {time} 后更换"

L.sb_mia = "下落不明"
L.sb_confirmed = "确认死亡"

L.sb_ping = "延迟"
L.sb_deaths = "死亡数"
L.sb_score = "分数"
L.sb_karma = "人品"

L.sb_info_help = "搜索此玩家的尸体，可以获取一些线索。"

L.sb_tag_friend = "可信"
L.sb_tag_susp = "可疑"
L.sb_tag_avoid = "躲避"
L.sb_tag_kill = "死亡"
L.sb_tag_miss = "失踪"

-- Equipment actions, like buying and dropping
L.buy_no_stock = "无法购买此装备：你已拥有它了。"
L.buy_pending = "你已订购此装备，请等待配送。"
L.buy_received = "你已收到此装备。"

L.drop_no_room = "你没有足够空间存放新武器！"

L.disg_turned_on = "伪装开启！"
L.disg_turned_off = "伪装关闭。"

-- Equipment item descriptions
L.item_passive = "被动道具"
L.item_active = "主动道具"
L.item_weapon = "武器"

L.item_armor = "护甲"
L.item_armor_desc = [[
阻挡子弹，火焰和爆炸伤害。耐久会随着使用而降低。

这个装备可以购买多次。护甲达到一定阈值后防御力会上升。]]

L.item_radar = "雷达"
L.item_radar_desc = [[
允许你扫描存活着的玩家。

一旦持有，雷达会开始自动扫描。使用该页面的雷达菜单来设置。]]

L.item_disg = "伪装"
L.item_disg_desc = [[
启用时，你的ID将被隐藏；也可避免探长在尸体上找到死者生前见到的最后一个人。

需要启用时，使用本页面的伪装菜单或按下小键盘回车键。]]

-- C4
L.c4_hint = "按下 {usekey} 来安放或拆除C4。"
L.c4_disarm_warn = "你所安放的C4已被拆除。"
L.c4_armed = "C4安放成功。"
L.c4_disarmed = "你成功拆除了C4。"
L.c4_no_room = "你无法携带C4。"

L.c4_desc = "C4爆炸！"

L.c4_arm = "安放C4。"
L.c4_arm_timer = "计时器"
L.c4_arm_seconds = "引爆秒数："
L.c4_arm_attempts = "拆除C4时，6条引线中有 {num} 条会立即引发爆炸。"

L.c4_remove_title = "移除"
L.c4_remove_pickup = "捡起C4"
L.c4_remove_destroy1 = "销毁C4"
L.c4_remove_destroy2 = "确认：销毁"

L.c4_disarm = "拆除C4"
L.c4_disarm_cut = "点击以剪断 {num} 号引线"

L.c4_disarm_owned = "剪断引线以拆除C4。你是安放此C4的人，所以任何引线都能成功拆除。"
L.c4_disarm_other = "剪断正确的引线以拆除C4。如果你剪错的话，后果不堪设想！"

L.c4_status_armed = "安放"
L.c4_status_disarmed = "拆除"

-- Visualizer
L.vis_name = "显像器"
L.vis_hint = "按下 {usekey} 键捡起它（仅限侦探）。"

L.vis_desc = [[
可让犯罪现场显像化的仪器。

分析尸体，显出死者被杀害时的情况，但仅限于死者被枪杀时。]]

-- Decoy
L.decoy_name = "雷达诱饵"
L.decoy_no_room = "你无法携带雷达诱饵。"
L.decoy_broken = "你的雷达诱饵被摧毁了！"

L.decoy_short_desc = "这个诱饵会为其他阵营显示一个假雷达信号"
L.decoy_pickup_wrong_team = "这个诱饵属于其他阵营，你无法捡起"

L.decoy_desc = [[
显示假的雷达信号给探长，探长执行DNA扫描时，将会显示雷达诱饵的位置作为代替。]]

-- Defuser
L.defuser_name = "拆弹器"
L.defuser_help = " {primaryfire} 拆除目标炸弹。"

L.defuser_desc = [[
迅速拆除一个C4。

不限制使用次数。若你持有此设备，拆除C4时会轻松许多。]]

-- Flare gun
L.flare_name = "信号枪"

L.flare_desc = [[
可用来烧毁尸体，使它们永远不会被发现。该武器有有弹药限制。

燃烧尸体会发出十分明显的声音。]]

-- Health station
L.hstation_name = "医疗站"
L.hstation_hint = "按下 {usekeu} 恢复健康。剩馀存量： {num}"
L.hstation_broken = "你的医疗站被摧毁了！"
L.hstation_help = " {primaryfire} 安放了一个医疗站。"

L.hstation_desc = [[
安放后，允许人们用其治疗自己。

充能速度相当缓慢。所有人都可以使用，而且医疗站可以受到伤害。每位使用者会留下可采集的DNA样本。]]

-- Knife
L.knife_name = "刀子"
L.knife_thrown = "飞刀"

L.knife_desc = [[
可以迅速、无声的杀死受伤的目标，但只能使用一次。

按下右键即可使用飞刀。]]

-- Poltergeist
L.polter_desc = [[
放置震动器在物体上，使它们危险地四处飞动。

能量爆炸会使附近的人受到伤害。]]

-- Radio
L.radio_broken = "你的收音机已被摧毁！"
L.radio_help_pri = " {primaryfire} 安放了收音机。"

L.radio_desc = [[
播放音效来误导或欺骗玩家。

将收音机安放下来，然后用该页面的收音机菜单播放。]]

-- Silenced pistol
L.sipistol_name = "消音手枪"

L.sipistol_desc = [[
噪音极小的手枪。使用普通手枪弹药。

被害者被射杀时不会喊叫。]]

-- Newton launcher
L.newton_name = "牛顿发射器"

L.newton_desc = [[
在安全的距离推他人。

弹药无限，但射击间隔较长。]]

-- Binoculars
L.binoc_name = "双筒望远镜"

L.binoc_desc = [[
可以放大并远距离确认尸体。

不限使用次数，但确认尸体需要一些时间。]]

-- UMP
L.ump_desc = [[
实验型冲锋枪，能阻扰目标视角。

使用普通冲锋枪弹药。]]

-- DNA scanner
L.dna_name = "DNA扫描器"
L.dna_identify = "检索尸体将能确认凶手身分。"
L.dna_notfound = "目标上没有DNA样本。"
L.dna_limit = "已达最大采集额度，请先移除旧样本。"
L.dna_decayed = "凶手的DNA样本已经消失。"
L.dna_killer = "成功采集到凶手的DNA样本！"
L.dna_no_killer = "DNA样本无法检索（凶手已离线？）"
L.dna_armed = "炸弹已启动！赶紧拆除它！"
L.dna_object = "在目标上采集到 {num} 个新DNA样本。"
L.dna_gone = "区域内没侦测到可采集之DNA样本。"

L.dna_desc = [[
采集物体上的DNA样本，并用其找寻对应的主人。

使用在尸体上，采集杀手的DNA并追踪他。]]

-- Magneto stick
L.magnet_name = "电磁棍"
L.magnet_help = " {primaryfire} 将其定在墙上。"

-- Grenades and misc
L.grenade_smoke = "烟雾弹"
L.grenade_fire = "燃烧弹"

L.unarmed_name = "无武装"
L.crowbar_name = "撬棍"
L.pistol_name = "手枪"
L.rifle_name = "狙击枪"
L.shotgun_name = "霰弹枪"

-- Teleporter
L.tele_name = "传送安放"
L.tele_failed = "传送失败"
L.tele_marked = "传送地点已标记"

L.tele_no_ground = "你必须站在地面才能传送！"
L.tele_no_crouch = "蹲着的时候不能传送！"
L.tele_no_mark = "标记传送地点后才能传送。"

L.tele_no_mark_ground = "站在地面上才能标记传送地点！"
L.tele_no_mark_crouch = "站起来才能标记传送点！"

L.tele_help_pri = " {primaryfire} 传送到已标记的传送地点。"
L.tele_help_sec = " {scondaryfire} 标记传送地点。"

L.tele_desc = [[
可以传送到先前标记的地点。

传送器会产生噪音，而且使用次数是有限的。]]

-- Ammo names, shown when picked up
L.ammo_pistol = "手枪弹药"

L.ammo_smg1 = "冲锋枪弹药"
L.ammo_buckshot = "霰弹枪弹药"
L.ammo_357 = "步枪弹药"
L.ammo_alyxgun = "沙漠之鹰弹药"
L.ammo_ar2altfire = "信号弹药"
L.ammo_gravity = "促狭鬼弹药"

-- Round status
L.round_wait = "等待中"
L.round_prep = "准备中"
L.round_active = "进行中"
L.round_post = "回合结束"

-- Health, ammo and time area
L.overtime = "加时"
L.hastemode = "急速模式"

-- TargetID health status
L.hp_healthy = "健康"
L.hp_hurt = "轻伤"
L.hp_wounded = "受伤"
L.hp_badwnd = "重伤"
L.hp_death = "濒死"

-- TargetID karma status
L.karma_max = "良好"
L.karma_high = "粗鲁"
L.karma_med = "不可靠"
L.karma_low = "危险"
L.karma_min = "滥杀者"

-- TargetID misc
L.corpse = "尸体"
L.corpse_hint = "按下 {usekey} 来搜索，用 {walkkey} + {usekey} 进行无声搜索。"

L.target_disg = " （伪装状态）"
L.target_unid = "未确认的尸体"

L.target_credits = "搜索尸体以获取未被消耗积分"

-- HUD buttons with hand icons that only traitors can see
L.tbut_single = "一次性"
L.tbut_reuse = "重复使用"
L.tbut_retime = "{num} 秒可后再次使用"
L.tbut_help = "按下 {key} 键使用"

-- Spectator muting of living/dead
L.mute_living = "静音存活玩家"
L.mute_specs = "静音观察者"
L.mute_all = "全部静音"
L.mute_off = "取消静音"

-- Spectators and prop possession
L.punch_title = "飞击量表" --"PUNCH-O-METER"
L.punch_help = "按下行走键或跳跃键以推撞物品；按蹲下键则离开物品控制。"
L.punch_bonus = "你的分数较低，飞击量表上限减少 {num}"
L.punch_malus = "你的分数较高，飞击量表上限增加 {num} ！"

-- Info popups shown when the round starts
L.info_popup_innocent = [[
你是位无辜的恐怖分子！但你的周围存在着叛徒...
你能相信谁？谁又想背地里害死你？

看好你的背后并与同伴合作，争取活下来！]]

L.info_popup_detective = [[
你是位探长！恐怖分子总部给予你许多特殊资源以揪出叛徒。
用它们来确保无辜者的生命，不过要当心：
叛徒会优先杀害你！

按 {menukey} 获得装备！]]

L.info_popup_traitor_alone = [[
你是位叛徒！这回合中你没有同伴。

杀死所有其他玩家，以获得胜利！

按 {menukey} 取得装备！]]

L.info_popup_traitor = [[
你是位叛徒！和其他叛徒合作杀害其他所有人，以获得胜利。
但请小心，你的身份可能会暴露...

这些是你的同伴们:
{traitorlist}

按 {menukey} 取得装备！]]

-- Various other text
L.name_kick = "一名玩家因于此回合中改变了名字而被自动踢出游戏。"

L.idle_popup = [[
你挂机了 {num} 秒，所以被转往观察者模式。当你位于此模式时，将不会在回合开始时重生。

你可在任何时间取消观察者模式，按下 {helpkey} 并在选单取消勾选\"观察者模式\"即可。当然，你也可以选择立刻关闭它。]]

L.idle_popup_close = "什么也不做"
L.idle_popup_off = "立刻关闭观察者模式"

L.idle_warning = "警告：你已挂机一段时间，如果接下来没有动作将进入观察者模式。"

L.spec_mode_warning = "你位于观察者模式所以不会在回合开始时重生。若要关闭此模式，按下F1并取消勾选\"观察者模式\"即可。"

-- Tips panel
L.tips_panel_title = "提示"
L.tips_panel_tip = "提示："

-- Tip texts
L.tip1 = "叛徒不用确认其死亡即可悄悄检查尸体，只需对着尸体按着 {walkkey} 键后再按 {usekey} 键即可。"

L.tip2 = "将C4爆炸时间设置更长，可增加引线数量，使拆弹者失败可的能性大幅上升，且能让C4的哔哔声更轻更慢。"

L.tip3 = "探长能在尸体查出谁是\"死者最后看见的人\"。若是遭到背后攻击，最后看见的将不会是凶手。"

L.tip4 = "被你的尸体被发现并确认之前，没人知道你已经死亡。"

L.tip5 = "叛徒杀死探长时会立即得到一点积分。"

L.tip6 = "一名叛徒死后，探长将得到一点积分作为奖励。"

L.tip7 = "叛徒杀害一定数量的无辜者后，全体都会获得一点积分作为奖励。"

L.tip8 = "叛徒和探长能从同伴尸体上取得未被消耗的积分。"

L.tip9 = "促狭鬼将使物体变得极其危险。促狭鬼调整过的物体将产生爆炸能量伤害接近它的人。"

L.tip10 = "叛徒与探长应保持注意屏幕右上方的红色信息，这对你无比重要。"

L.tip11 = "叛徒或探长和同伴配合得好时会获得额外积分。请善用这些积分！"

L.tip12 = "探长的DNA扫描器可使用在武器或道具上，找到曾使用它的玩家的位置。用在尸体或C4上效果将更好！"

L.tip13 = "太靠近你杀害的人的话，DNA将残留在尸体上，探长的DNA扫描器会以此找到你的正确位置。切记，杀了人最好将尸体藏好！"

L.tip14 = "杀人时离被害者越远，残留在尸体上的DNA就会越快消失！"

L.tip15 = "你是叛徒而且想进行狙击？试试伪装吧！若你狙杀失手，逃到安全的地方，取消伪装，就没人知道是你开的枪了！"

L.tip16 = "作为叛徒，传送器可帮助你逃脱追踪，并让你得以迅速穿过整个地图。请随时确保有个安全的传送标记。"

L.tip17 = "是否遇过无辜者群聚在一起而难以下手？请试试用收音机发出C4哔哔声或交火声，让他们分散。"

L.tip18 = "叛徒可以在选单使用已放置的收音机，依序点击想播放的声音，就会按顺序排列播放。"

L.tip19 = "探长若有多余积分，可将拆弹器交给一位可信任的无辜者，将危险的C4交给他们，自己全神贯注地调查与处决叛徒。"

L.tip20 = "探长的望远镜可让你远距离搜索并确认尸体，坏消息是叛徒总是会用诱饵欺骗你。当然，使用望远镜的探长全身都是破绽。"

L.tip21 = "探长的医疗站可让受伤的玩家恢复健康，当然，其中也包括叛徒..."

L.tip22 = "治疗站将遗留每位前来治疗的人的DNA样本，探长可将其用在DNA扫描器上，寻找究竟谁曾受过治疗。"

L.tip23 = "与武器、C4不同，收音机并不会留下你的DNA样本，不用担心探长会在上头用DNA识破你的身分。"

L.tip24 = "按下 {helpkey} 阅读教学或变更设定，比如说，你可以永远关掉现在所看到的提示唷～"

L.tip25 = "探长确认尸体后，相关信息将在计分板公布，如要查看只需点击死者之名字即可。."

L.tip26 = "计分板上，人物名字旁的放大镜图样可以查看关于他的信息，若图样亮着，代表是某位探长确认后的结果。"

L.tip27 = "探长调查尸体后的结果将公布在计分板，供所有玩家查看。"

L.tip28 = "观察者可以按下 {mutekey} 循环调整对其他观察者或游戏中的玩家静音。"

L.tip29 = "若服务器有安装其他语言，你可以在任何时间开启F1选单，启用不同语言。"

L.tip30 = "若要使用语音或无线电，可以按下 {zoomkey} 使用。"

L.tip31 = "作为观察者，按下 {duckkey} 能固定视角并在游戏内移动光标，可以点击提示栏里的按钮。此外，再次按下 {duckkey} 会解除并恢复默认视角控制。"

L.tip32 = "使用撬棍时，按下右键可推开其他玩家。"

L.tip33 = "使用武器瞄准器射击将些微提升你的精准度，并降低后座力。蹲下则不会。"

L.tip34 = "烟雾弹在室内相当有效，尤其是在拥挤的房间中制造混乱。"

L.tip35 = "叛徒，请记住你能搬运尸体并将它们藏起来，避开无辜者与探长的耳目。"

L.tip36 = "按下 {helpkey} 可以观看教学，其中包含了重要的游戏信息。"

L.tip37 = "在计分板上，点击活人玩家的名字，可以选择一个标记（如令人怀疑的或友好的）记录这位玩家。此标志会在你的准心指向该玩家时显示。"

L.tip38 = "许多需放置的装备（如C4或收音机）可以使用右键放在墙上。"

L.tip39 = "拆除C4时失误导致的爆炸，比起直接引爆时来得小。"

L.tip40 = "若时间上显示\"急速模式\"，此回合的时间会很短，但每位玩家的死亡都将延长时间（就像TF2的占点模式）。延长时间将迫使叛徒加紧脚步。"

-- Round report
L.report_title = "回合报告"

-- Tabs
L.report_tab_hilite = "亮点"
L.report_tab_hilite_tip = "回合亮点"
L.report_tab_events = "事件"
L.report_tab_events_tip = "发生在此回合的亮点事件"
L.report_tab_scores = "分数"
L.report_tab_scores_tip = "本回合单个玩家获得的点数"

-- Event log saving
L.report_save = "保存 Log.txt"
L.report_save_tip = "将事件记录并保存在txt档内"
L.report_save_error = "没有可供保存的事件记录"
L.report_save_result = "事件记录已存在："

-- Big title window
L.hilite_win_traitors = "叛徒胜利"
L.hilite_win_none = "蜜蜂胜利"
L.hilite_win_innocent = "无辜者胜利"

L.hilite_players1 = " {numplayers} 名玩家参与游戏，其中 {numtraitors} 人是叛徒"
L.hilite_players2 = " {numplayers} 名玩家参与游戏，其中一人是叛徒"

L.hilite_duration = "回合持续了 {time}"

-- Columns
L.col_time = "时间"
L.col_event = "事件"
L.col_player = "玩家"
L.col_roles = "角色"
L.col_teams = "阵营"
L.col_kills1 = "无辜者杀敌数"
L.col_kills2 = "叛徒杀敌数"
L.col_points = "点数"
L.col_team = "团队奖励"
L.col_total = "总分"

-- Awards/highlights
L.aw_sui1_title = "自杀邪教教主"
L.aw_sui1_text = "率先向其他自杀者展示如何自杀。"

L.aw_sui2_title = "孤独沮丧者"
L.aw_sui2_text = "就他一人自杀，无比哀戚。"

L.aw_exp1_title = "炸弹研究的第一把交椅"
L.aw_exp1_text = "决心研究C4。{num} 名受试者证明了他的理论。"

L.aw_exp2_title = "就地研究"
L.aw_exp2_text = "测试自己的抗爆炸能力，显然完全不够高。"

L.aw_fst1_title = "第一滴血"
L.aw_fst1_text = "将第一位无辜者的生命送到叛徒手上。"

L.aw_fst2_title = "愚蠢的血腥首杀"
L.aw_fst2_text = "击杀一名叛徒同伴而得到首杀，做得好啊！"

L.aw_fst3_title = "首杀大挫折"
L.aw_fst3_text = "第一杀便将无辜者同伴误认为叛徒，真是乌龙。"

L.aw_fst4_title = "吹响号角"
L.aw_fst4_text = "杀害一名叛徒，为无辜者阵营吹响了号角。"

L.aw_all1_title = "鹤立鸡群"
L.aw_all1_text = "对无辜者团队的每一个击杀负责。"

L.aw_all2_title = "孤狼"
L.aw_all2_text = "对叛徒团队的每一个击杀负责。"

L.aw_nkt1_title = "老大！我干掉一个！"
L.aw_nkt1_text = "在一名无辜者落单时策划了一场谋杀，漂亮！"

L.aw_nkt2_title = "一石二鸟"
L.aw_nkt2_text = "用另一具尸体证明上一枪不是巧合。"

L.aw_nkt3_title = "连续杀人魔"
L.aw_nkt3_text = "在今天结束了三名无辜者的生命。"

L.aw_nkt4_title = "穿梭在批着羊皮的狼之间的狼"
L.aw_nkt4_text = "将无辜者们作为晚餐吃了。共吃了 {num} 人。"

L.aw_nkt5_title = "反恐特工"
L.aw_nkt5_text = "按恐怖分子人头收钱。现在已经买得起豪华游艇了。"

L.aw_nki1_title = "背叛这个试试！"
L.aw_nki1_text = "找出了一个叛徒，然后杀死了一个叛徒。简单吧？"

L.aw_nki2_title = "申请进入正义连队"
L.aw_nki2_text = "将两名叛徒送下地狱。"

L.aw_nki3_title = "恐怖分子会梦到叛徒羊吗？"
L.aw_nki3_text = "让三名叛徒安息。"

L.aw_nki4_title = "内部事件部门"
L.aw_nki4_text = "按叛徒人头收钱。现在已经买得起第五个游泳池了。"

L.aw_fal1_title = "不，庞德先生，我希望你跳下去"
L.aw_fal1_text = "将一个人推下致死的高度。"

L.aw_fal2_title = "地板人"
L.aw_fal2_text = "让自己的身体从极端无尽的高度上落地。"

L.aw_fal3_title = "人体流星"
L.aw_fal3_text = "让一名玩家从高处落下，摔成烂泥。"

L.aw_hed1_title = "高效能"
L.aw_hed1_text = "发现爆头的乐趣，并击杀了 {num} 名敌人。"

L.aw_hed2_title = "神经内科"
L.aw_hed2_text = "近距离将 {num} 名玩家的脑袋取出，完成自己的脑神经研究。"

L.aw_hed3_title = "从游戏里学来的"
L.aw_hed3_text = "好好应用了暴力游戏的经验，爆了 {num} 颗头。"

L.aw_cbr1_title = "物理学圣剑"
L.aw_cbr1_text = "应用了物理学原理，向 {num} 证明了自己的毕业论文。"

L.aw_cbr2_title = "戈登•弗里曼"
L.aw_cbr2_text = "离开黑山，用喜爱的撬棍杀了至少 {num} 名玩家。"

L.aw_pst1_title = "死亡之握"
L.aw_pst1_text = "用手枪杀死 {num} 名玩家前，都上前握了手。"

L.aw_pst2_title = "小口径屠杀"
L.aw_pst2_text = "用手枪杀了 {num} 人的小队。我们推测他枪管里头有个微型霰弹枪。"

L.aw_sgn1_title = "简单模式"
L.aw_sgn1_text = "用霰弹枪近距离杀了 {num} 名玩家。切。"

L.aw_sgn2_title = "一千颗小弹丸"
L.aw_sgn2_text = "不喜欢自己的霰弹，打算送人。已经有 {num} 名受赠人接受了这个礼物。"

L.aw_rfl1_title = "把准心对准目标扣下扳机……"
L.aw_rfl1_text = "用一把好枪和一个沉稳的手终结了 {num} 名玩家的生命。"

L.aw_rfl2_title = "你的脑袋冒出来了！"
L.aw_rfl2_text = "十分了解他的狙击枪，其他 {num} 名玩家随即也了解了他的狙击枪。"

L.aw_dgl1_title = "这简直像是小型狙击枪"
L.aw_dgl1_text = "用沙漠之鹰娴熟地杀了 {num} 名玩家。"

L.aw_dgl2_title = "老鹰大师"
L.aw_dgl2_text = "用他手中的沙漠之鹰杀了 {num} 名玩家。"

L.aw_mac1_title = "按下扳机，然后祈祷"
L.aw_mac1_text = "用MAC10冲锋枪杀了 {num} 名玩家，但别提他需要多少发子弹。"

L.aw_mac2_title = "单枪老太婆"
L.aw_mac2_text = "好奇如果他能有两把冲锋枪会发生什么事。大概是 {num} 个人头再翻倍？"

L.aw_sip1_title = "嘘！"
L.aw_sip1_text = "用消音手枪射杀了 {num} 人。"

L.aw_sip2_title = "光头杀手"
L.aw_sip2_text = "用消音手枪无声地杀死了 {num} 个人。不愧是专业的。"

L.aw_knf1_title = "很刀兴见到你"
L.aw_knf1_text = "隔着网线捅死了一个人。"

L.aw_knf2_title = "管制刀具"
L.aw_knf2_text = "不是叛徒，却找到刀子并用它杀了人。"

L.aw_knf3_title = "开膛手杰克"
L.aw_knf3_text = "在地上捡到 {num} 把匕首，并好好利用了它们。"

L.aw_knf4_title = "女仆长的执著"
L.aw_knf4_text = "用刀子杀死了 {num} 个人。这些刀子都是裙底下找出来的吗？"

L.aw_flg1_title = "买根烟吗？"
L.aw_flg1_text = "用燃烧弹点燃了 {num} 人的香烟。"

L.aw_flg2_title = "火上浇油"
L.aw_flg2_text = "使 {num} 名玩家葬身于火海。"

L.aw_hug1_title = "子弹龙头"
L.aw_hug1_text = "和自己的M249很合得来，不知道怎么打中了 {num} 名玩家。"

L.aw_hug2_title = "耐心机枪手"
L.aw_hug2_text = "从未抛弃心爱的M249，最终用其杀戮了 {num} 名玩家。"

L.aw_msx1_title = "啪啪啪"
L.aw_msx1_text = "用M16步枪射杀了 {num} 名玩家。"

L.aw_msx2_title = "中距离疯子"
L.aw_msx2_text = "了解如何用他手中的M16，射杀了敌人。共有 {num} 名不幸的亡魂。"

L.aw_tkl1_title = "抱歉"
L.aw_tkl1_text = "瞄准自己的队友，并不小心扣下扳机。"

L.aw_tkl2_title = "抱歉抱歉"
L.aw_tkl2_text = "认为自己抓到了两次叛徒，但两次都错了！"

L.aw_tkl3_title = "小心人品！"
L.aw_tkl3_text = "杀死两个同伴已不能满足他，三个才是他的最终目标！"

L.aw_tkl4_title = "专业卖队友！"
L.aw_tkl4_text = "杀了所有同伴！快踢了他！"

L.aw_tkl5_title = "角色扮演"
L.aw_tkl5_text = "在扮演一个疯子，所以把自己大部分的同伴杀死了。"

L.aw_tkl6_title = "痛击队友"
L.aw_tkl6_text = "弄不清他属于哪一队，并杀死了半数以上的队友。"

L.aw_tkl7_title = "园丁"
L.aw_tkl7_text = "好好保护着自己的草坪，并杀死了四分之一以上的队友。"

L.aw_brn1_title = "炭烤恐怖分子"
L.aw_brn1_text = "使用燃烧弹点燃数个玩家，把他们烤熟了！"

L.aw_brn2_title = "火化官"
L.aw_brn2_text = "将每一具被他杀死的受害者尸体燃烧乾淨。"

L.aw_brn3_title = "纵火狂"
L.aw_brn3_text = "十分喜欢火焰，以至于用掉了地图上每一颗燃烧弹。也许应该去看一下医生。"

L.aw_fnd1_title = "验尸官"
L.aw_fnd1_text = "在地上发现 {num} 具尸体。"

L.aw_fnd2_title = "尸体收藏家"
L.aw_fnd2_text = "在地上发现了 {num} 具尸体，大概是要搞收藏。"

L.aw_fnd3_title = "死亡的气味"
L.aw_fnd3_text = "在这回合偶遇尸体共 {num} 次。"

L.aw_crd1_title = "回收利用"
L.aw_crd1_text = "在同伴尸体上找到了 {num} 点积分。"

L.aw_tod1_title = "痛失胜利"
L.aw_tod1_text = "在他的团队即将获得胜利的前几秒死去。"

L.aw_tod2_title = "垃圾游戏！"
L.aw_tod2_text = "在这回合刚开始不久即被杀害。"

-- New and modified pieces of text are placed below this point, marked with the
-- version in which they were added, to make updating translations easier.

-- v24
L.drop_no_ammo = "你弹夹内的子弹不足以丢弃成弹药盒。"

-- 2015-05-25
L.hat_retrieve = "你捡起了一顶探长的帽子。"

-- 2017-09-03
L.sb_sortby = "排序方法:"

-- 2018-07-24
L.equip_tooltip_main = "装备菜单"
L.equip_tooltip_radar = "雷达控制"
L.equip_tooltip_disguise = "伪装器控制"
L.equip_tooltip_radio = "收音机控制"
L.equip_tooltip_xfer = "转移积分"
L.equip_tooltip_reroll = "重选装备"

L.confgrenade_name = "眩晕弹"
L.polter_name = "促狭鬼"
L.stungun_name = "实验型 UMP"

L.knife_instant = "必杀"

L.binoc_zoom_level = "放大"
L.binoc_body = "发现尸体"

L.idle_popup_title = "挂机"

-- 2019-01-31
L.create_own_shop = "新建商店"
L.shop_link = "连接"
L.shop_disabled = "禁用商店"
L.shop_default = "使用默认商店"

-- 2019-05-05
L.reroll_name = "重选"
L.reroll_menutitle = "重选装备"
L.reroll_no_credits = "你需要花费 {amount} 积分进行重选！"
L.reroll_button = "重选"
L.reroll_help = "使用 {amount} 积分刷新商店的装备！"

-- 2019-05-06
L.equip_not_alive = "在右侧选择身份来查看这个身份的全部装备。不要忘记标记最爱装备！"

-- 2019-06-27
L.shop_editor_title = "商店编辑器"
L.shop_edit_items_weapong = "修改武器/道具"
L.shop_edit = "修改商店"
L.shop_settings = "设置"
L.shop_select_role = "选择身份"
L.shop_edit_items = "修改道具"
L.shop_edit_shop = "修改商店"
L.shop_create_shop = "新建自定义商店"
L.shop_selected = "选中 {role}"
L.shop_settings_desc = "改变数值来适应随机商店参数。不要忘记保存！"

L.bindings_new = "{name} 的新按键：{key}"

L.hud_default_failed = "未能将界面 {hudname} 设为默认。你没有权限，或这个界面不存在。"
L.hud_forced_failed = "未能将界面 {hudname} 设为强制。你没有权限，或这个界面不存在。"
L.hud_restricted_failed = "未能将界面 {hudname} 设为限制。你没有权限，或这个界面不存在。"

L.shop_role_select = "选择身份"
L.shop_role_selected = "选中了 {role} 的商店！"
L.shop_search = "搜索"

L.spec_help = "点击来观察玩家，或对着物理道具按 {usekey} 来附身。"
L.spec_help2 = "若想离开观察者模式，用 {helpkey} 打开菜单，在“游戏性”选项中勾选选项。"

-- 2019-10-19
L.drop_ammo_prevented = "有什么东西阻挡你丢出子弹。"

-- 2019-10-28
L.target_c4 = "按 [{usekey}] 打开C4菜单"
L.target_c4_armed = "按 [{usekey}] 拆除C4"
L.target_c4_armed_defuser = "按 [{usekey}] 使用拆弹器"
L.target_c4_not_disarmable = "你不能拆除存活队友的C4"
L.c4_short_desc = "可以炸得很欢"

L.target_pickup = "按 [{usekey}] 捡起"
L.target_slot_info = "槽位：{slot}"
L.target_pickup_weapon = "按 [{usekey}] 捡起武器"
L.target_switch_weapon = "按 [{usekey}] 和当前武器交换"
L.target_pickup_weapon_hidden = "，按 [{usekey} + {walkkey}] 隐秘地捡起"
L.target_switch_weapon_hidden = "，按 [{usekey} + {walkkey}] 隐秘地交换"
L.target_switch_weapon_nospace = "没有提供给这个武器的槽位"
L.target_switch_drop_weapon_info = "丢弃槽位 {slot} 的 {name}"
L.target_switch_drop_weapon_info_noslot = "槽位 {slot} 没有可丢弃的武器"

L.corpse_searched_by_detective = "这个尸体被探长搜查过"
L.corpse_too_far_away = "这个尸体太远了。"

L.radio_pickup_wrong_team = "你不能捡起其他队伍的收音机"
L.radio_short_desc = "武器声音，悦耳动听"

L.hstation_subtitle = "按 [{usekey}] 恢复生命"
L.hstation_charge = "剩余充能: {charge}"
L.hstation_empty = "这个医疗站没有剩余充能"
L.hstation_maxhealth = "你的生命恢复已满"
L.hstation_short_desc = "医疗站会逐渐回复充能"

-- 2019-11-03
L.vis_short_desc = "还原被枪杀的尸体的犯罪现场"
L.corpse_binoculars = "按 [{key}] 用望远镜搜查尸体"
L.binoc_progress = "搜查进度: {progress}%"

L.pickup_no_room = "你没有存放此类武器的空间"
L.pickup_fail = "你无法捡起这个武器"
L.pickup_pending = "你已经捡起这个武器，请等捡起完成"

-- 2020-01-07
L.tbut_help_admin = "编辑叛徒按钮设定"
L.tbut_role_toggle = "[{walkkey} + {usekey}] 切换 {role} 的按钮权限"
L.tbut_role_config = "身份: {current}"
L.tbut_team_toggle = "[SHIFT + {walkkey} + {usekey}] 切换 {team} 的按钮权限"
L.tbut_team_config = "阵营: {current}"
L.tbut_current_config = "当前设定:"
L.tbut_intended_config = "地图默认设定:"
L.tbut_admin_mode_only = "只有你看得到这个，因为你是管理员而且 '{cv}' 目前被设为 '1'"
L.tbut_allow = "允许"
L.tbut_prohib = "禁止"
L.tbut_default = "默认"

-- 2020-02-09
L.name_door = "门"
L.door_open = "按 [{usekey}] 开门"
L.door_close = "按 [{usekey}] 关门"
L.door_locked = "此门被锁上了"

-- 2020-02-11
L.automoved_to_spec = "（自动消息）我因为挂机而被移到了观察者。"
L.mute_team = "静音 {team}"

-- 2020-02-16
L.door_auto_closes = "此门会自动关闭"
L.door_open_touch = "此门接触后会自动开启"
L.door_open_touch_and_use = "接触门或按 [{usekey}] 开门."
L.hud_health = "生命"

-- 2020-03-09
L.help_title = "帮助和设定"

L.menu_changelog_title = "更新内容"
L.menu_guide_title = "TTT2 向导"
L.menu_bindings_title = "键位绑定"
L.menu_language_title = "语言"
L.menu_appearance_title = "外观"
L.menu_gameplay_title = "游戏性"
L.menu_addons_title = "插件"
L.menu_legacy_title = "旧式插件"
L.menu_administration_title = "管理"
L.menu_equipment_title = "编辑装备"
L.menu_shops_title = "编辑商店"

L.menu_changelog_description = "最近版本的一系列优化和改动"
L.menu_guide_description = "帮助你开始游玩 TTT2 并解释玩法和身份等内容"
L.menu_bindings_description = "将 TTT2 和其插件的功能绑到你想要的键位"
L.menu_language_description = "选择游戏语言"
L.menu_appearance_description = "调整界面的样式和性能"
L.menu_gameplay_description = "避免特定身份和其他游戏相关选项"
L.menu_addons_description = "配置本地插件"
L.menu_legacy_description = "旧TTT的菜单，应该已被导入新系统"
L.menu_administration_description = "界面和商店的通用管理菜单"
L.menu_equipment_description = "设置装备的价格，限制，可用性等"
L.menu_shops_description = "给身份添加菜单和装备"

L.submenu_guide_gameplay_title = "玩法"
L.submenu_guide_roles_title = "身份"
L.submenu_guide_equipment_title = "装备"

L.submenu_bindings_bindings_title = "键位绑定"

L.submenu_language_language_title = "语言"

L.submenu_appearance_general_title = "通用"
L.submenu_appearance_hudswitcher_title = "HUD 切换器"
L.submenu_appearance_vskin_title = "VSkin"
L.submenu_appearance_targetid_title = "目标高亮"
L.submenu_appearance_shop_title = "商店设置"
L.submenu_appearance_crosshair_title = "准星"
L.submenu_appearance_dmgindicator_title = "伤害指示"
L.submenu_appearance_performance_title = "性能"
L.submenu_appearance_interface_title = "界面"
L.submenu_appearance_miscellaneous_title = "其他"

L.submenu_gameplay_general_title = "通用"
L.submenu_gameplay_avoidroles_title = "避免特定身份"

L.submenu_administration_hud_title = "HUD 设置"
L.submenu_administration_randomshop_title = "随机商店"

L.help_color_desc = "此选项启用后，准星和目标高亮的外框会显示一个全局通用的颜色"
L.help_scale_factor = "这个比例影响所有界面大小 (HUD, vgui 和目标高亮)。屏幕分辨率修改后会自动更新这个比例。改变此比例会重置 HUD！"
L.help_hud_game_reload = "这个 HUD 当前无法使用，必须先重新加载游戏。"
L.help_hud_special_settings = "以下是当前 HUD 的专用设定。"
L.help_vskin_info = "VSkin（vgui 皮肤）是应用在所有菜单界面（包括这个）的皮肤。皮肤可以用一个简单的 Lua 脚本创建，并能改变颜色，大小等参数。"
L.help_targetid_info = "目标高亮（TargetID）是显示在实体和玩家下面的信息。可以在通用菜单启用全局颜色。"
L.help_hud_default_desc = "设置全体玩家的默认 HUD。未选择 HUD 的玩家会使用这个，但已经选择其他 HUD 的玩家不会受影响。"
L.help_hud_forced_desc = "强制选择一个 HUD。这会阻止玩家选择其他 HUD。"
L.help_hud_enabled_desc = "启用/禁用 HUD 来限制玩家选择它们。"
L.help_damage_indicator_desc = "伤害指示是收到伤害时屏幕上出现的标记。若要添加新的主题，请把 png 文件放置在 'materials/vgui/ttt/damageindicator/themes/' 文件夹中。"
L.help_shop_key_desc = "在回合开始/结束时，按商店键是否打开商店而不是计分板？"

L.label_menu_menu = "菜单"
L.label_menu_admin_spacer = "管理员选项"
L.label_language_set = "选择语言"
L.label_global_color_enable = "启用全局颜色"
L.label_global_color = "全局颜色"
L.label_global_scale_factor = "全局大小比例"
L.label_hud_select = "选择 HUD"
L.label_vskin_select = "选择 VSkin"
L.label_blur_enable = "选择 VSkin 背景模糊"
L.label_color_enable = "选择 VSkin 背景颜色"
L.label_minimal_targetid = "简易目标高亮（没有人品，提示等）"
L.label_shop_always_show = "一直显示商店"
L.label_shop_double_click_buy = "启用来双击购买商店装备"
L.label_shop_num_col = "商店列数"
L.label_shop_num_row = "商店行数"
L.label_shop_item_size = "图标大小"
L.label_shop_show_slot = "显示装备槽位"
L.label_shop_show_custom = "显示自定义标记"
L.label_shop_show_fav = "显示最爱标记"
L.label_crosshair_enable = "启用十字准星"
L.label_crosshair_gap_enable = "启用自定义准星大小"
L.label_crosshair_gap = "自定义准星大小"
L.label_crosshair_opacity = "准星透明度"
L.label_crosshair_ironsight_opacity = "瞄准时准星透明度"
L.label_crosshair_size = "准星长度"
L.label_crosshair_thickness = "准星粗细"
L.label_crosshair_thickness_outline = "准星外框粗细"
L.label_crosshair_static_enable = "启用静态准星"
L.label_crosshair_dot_enable = "启用准星中点"
L.label_crosshair_lines_enable = "启用准星直线"
L.label_crosshair_scale_enable = "启用武器对应准星大小"
L.label_crosshair_ironsight_low_enabled = "瞄准时降低武器模型"
L.label_damage_indicator_enable = "启用伤害指示"
L.label_damage_indicator_mode = "选择伤害指示主题"
L.label_damage_indicator_duration = "受伤后指示显示时间"
L.label_damage_indicator_maxdamage = "最大透明度对应伤害值"
L.label_damage_indicator_maxalpha = "最大透明度"
L.label_performance_halo_enable = "指向特定实体时显示外框"
L.label_performance_spec_outline_enable = "启用被附身物品的外框"
L.label_performance_ohicon_enable = "启用头上身份图标"
L.label_interface_tips_enable = "启用观察时屏幕下方的游戏提示"
L.label_interface_popup = "回合开始信息持续时间"
L.label_interface_fastsw_menu = "启用快速切换菜单"
L.label_inferface_wswitch_hide_enable = "启用武器菜单自动关闭"
L.label_inferface_scues_enable = "回合开始或结束时播放特定声音"
L.label_gameplay_specmode = "观察者模式（永远观察）"
L.label_gameplay_fastsw = "武器快速切换"
L.label_gameplay_hold_aim = "启用持续瞄准"
L.label_gameplay_mute = "死亡时静音存活玩家"
L.label_gameplay_dtsprint_enable = "启用双击冲刺"
L.label_gameplay_dtsprint_anykey = "冲刺时任何方向键都持续冲刺"
L.label_hud_default = "默认 HUD"
L.label_hud_force = "强制 HUD"

L.label_bind_weaponswitch = "捡起武器"
L.label_bind_sprint = "冲刺"
L.label_bind_voice = "全局语言"
L.label_bind_voice_team = "团队语言"

L.label_hud_basecolor = "基础颜色"

L.label_menu_not_populated = "这个子菜单什么都没有。"

L.header_bindings_ttt2 = "TTT2 键位"
L.header_bindings_other = "其他键位"
L.header_language = "语言设置"
L.header_global_color = "选择全局颜色"
L.header_hud_select = "选择 HUD"
L.header_hud_customize = "自定义 HUD"
L.header_vskin_select = "选择并自定义 VSkin"
L.header_targetid = "目标高亮设置"
L.header_shop_settings = "装备菜单设置"
L.header_shop_layout = "装备页面布局"
L.header_shop_marker = "装备标记设置"
L.header_crosshair_settings = "准星设置"
L.header_damage_indicator = "伤害指示设置"
L.header_performance_settings = "性能设置"
L.header_interface_settings = "界面设置"
L.header_gameplay_settings = "游戏性设置"
L.header_roleselection = "启用身份分配"
L.header_hud_administration = "选择默认和强制 HUD"
L.header_hud_enabled = "启用/禁用 HUDs"

L.button_menu_back = "返回"
L.button_none = "无"
L.button_press_key = "按任何键"
L.button_save = "保存"
L.button_reset = "重置"
L.button_close = "关闭"
L.button_hud_editor = "HUD 编辑器"

-- 2020-04-20
L.item_speedrun = "疾跑如风"
L.item_speedrun_desc = [[让你的移动速度提高 50%！]]
L.item_no_explosion_damage = "防爆部队"
L.item_no_explosion_damage_desc = [[让你免疫爆炸伤害。]]
L.item_no_fall_damage = "金刚不败腿"
L.item_no_fall_damage_desc = [[让你免疫摔落伤害。]]
L.item_no_fire_damage = "消防员"
L.item_no_fire_damage_desc = [[让你免疫火焰伤害。]]
L.item_no_hazard_damage = "防化部队"
L.item_no_hazard_damage_desc = [[让你免疫硫酸，辐射和毒气伤害。]]
L.item_no_energy_damage = "电男"
L.item_no_energy_damage_desc = [[让你免疫激光，电浆和电磁伤害。]]
L.item_no_prop_damage = "头铁"
L.item_no_prop_damage_desc = [[让你免疫物品伤害。]]
L.item_no_drown_damage = "潜水员"
L.item_no_drown_damage_desc = [[让你免疫溺水伤害。]]

-- 2020-04-21
L.dna_tid_possible = "可以扫描"
L.dna_tid_impossible = "无法扫描"
L.dna_screen_ready = "无 DNA"
L.dna_screen_match = "配对成功"

-- 2020-04-30
L.message_revival_canceled = "复活取消。"
L.message_revival_failed = "复活失败。"
L.message_revival_failed_missing_body = "因为你的尸体不存在，复活失败了。"
L.hud_revival_title = "复活剩余时间："
L.hud_revival_time = "{time}秒"

-- 2020-05-03
L.door_destructible = "此门不可摧毁 ({health}生命)"

-- 2020-05-28
L.confirm_detective_only = "只有侦探能确认死亡"
L.inspect_detective_only = "只有侦探能检查尸体"
L.corpse_hint_no_inspect = "只有侦探能检查这个尸体4."
L.corpse_hint_inspect_only = "按 [{usekey}] 搜索。只有侦探能确认死亡。"
L.corpse_hint_inspect_only_credits = "按 [{usekey}] 获取积分。只有侦探能确认死亡。"

-- 2020-06-04
L.label_bind_disguiser = "切换伪装器"

-- 2020-06-24
L.dna_help_primary = "收集DNA样本"
L.dna_help_secondary = "切换当前DNA"
L.dna_help_reload = "删除当前样本"

L.binoc_help_pri = "确认尸体"
L.binoc_help_sec = "切换放大倍率"

L.vis_help_pri = "丢弃当前设备。"

L.decoy_help_pri = "安放诱饵。"

-- 2020-08-07
L.pickup_error_spec = "作为观察者你无法捡起这个。"
L.pickup_error_owns = "你已经有这个武器，无法再次捡起"
L.pickup_error_noslot = "你没有对应空槽位，无法捡起这个"

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
--L.desc_event_finish = "The round lasted {minutes}:{seconds}. There were {alive} player(s) alive in the end."
--L.desc_event_game = "A new round has started."
--L.desc_event_respawn = "{player} has respawned."
--L.desc_event_rolechange = "{player} changed their role/team from {orole} ({oteam}) to {nrole} ({nteam})."
--L.desc_event_selected = "The teams and roles were selected for all {amount} player(s)."
--L.desc_event_spawn = "{player} has spawned."

-- Name of a trap that killed us that has not been named by the mapper
L.trap_something = "某件物品"

-- Kill events
--L.desc_event_kill_suicide = "It was suicide."
--L.desc_event_kill_team = "It was a team kill."

L.desc_event_kill_blowup = "{victim} ({vrole} / {vteam}) 被自己炸飞。"
L.desc_event_kill_blowup_trap = "{victim} ({vrole} / {vteam}) 被 {trap} 炸飞。"

L.desc_event_kill_tele_self = "{victim} ({vrole} / {vteam}) 被自己给传送杀了。"
L.desc_event_kill_sui = "{victim} ({vrole} / {vteam}) 受不了然后自杀了！"
L.desc_event_kill_sui_using = "{victim} ({vrole} / {vteam}) 用 {tool} 杀了自己。"

L.desc_event_kill_fall = "{victim} ({vrole} / {vteam}) 摔死了。"
L.desc_event_kill_fall_pushed = "{victim} ({vrole} / {vteam}) 因为 {attacker} 而摔死了。"
L.desc_event_kill_fall_pushed_using = "{victim} ({vrole} / {vteam}) 被 {attacker} ({arole} / {ateam}) 用 {trap} 推下摔死。"

L.desc_event_kill_shot = "{victim} ({vrole} / {vteam}) 被 {attacker}射杀。"
L.desc_event_kill_shot_using = "{victim} ({vrole} / {vteam}) 被 {attacker} ({arole} / {ateam}) 用 {weapon} 射杀。"

L.desc_event_kill_drown = "{victim} ({vrole} / {vteam}) 被 {attacker} 推入水中溺死。"
L.desc_event_kill_drown_using = "{victim} ({vrole} / {vteam}) 被 {attacker} ({arole} / {ateam}) 用 {trap} 推入水中溺死。"

L.desc_event_kill_boom = "{victim} ({vrole} / {vteam}) 被 {attacker} 炸死。"
L.desc_event_kill_boom_using = "{victim} ({vrole} / {vteam}) 被 {attacker} ({arole} / {ateam}) 用 {trap} 炸烂。"

L.desc_event_kill_burn = "{victim} ({vrole} / {vteam}) 被 {attacker} 烧死。"
L.desc_event_kill_burn_using = "{victim} ({vrole} / {vteam}) 被 {attacker} ({arole} / {ateam}) 用 {trap} 烧成焦尸。"

L.desc_event_kill_club = "{victim} ({vrole} / {vteam}) 被 {attacker} 打死。"
L.desc_event_kill_club_using = "{victim} ({vrole} / {vteam}) 被 {attacker} ({arole} / {ateam}) 用 {trap} 打成烂泥。"

L.desc_event_kill_slash = "{victim} ({vrole} / {vteam}) 被 {attacker} 砍死。"
L.desc_event_kill_slash_using = "{victim} ({vrole} / {vteam}) 被 {attacker} ({arole} / {ateam}) 用 {trap} 砍成两半。"

L.desc_event_kill_tele = "{victim} ({vrole} / {vteam}) 被 {attacker} 传送杀。"
L.desc_event_kill_tele_using = "{victim} ({vrole} / {vteam}) 被 {attacker} ({arole} / {ateam}) 用 {trap} 传送时之能量分裂成原子。"

L.desc_event_kill_goomba = "{victim} ({vrole} / {vteam}) 被 {attacker} ({arole} / {ateam}) 用巨大物体压烂。"

L.desc_event_kill_crush = "{victim} ({vrole} / {vteam}) 被 {attacker} 压烂。"
L.desc_event_kill_crush_using = "{victim} ({vrole} / {vteam}) 被 {attacker} ({arole} / {ateam}) 用 {trap} 压碎。"

L.desc_event_kill_other = "{victim} ({vrole} / {vteam}) 被 {attacker} 杀死。"
L.desc_event_kill_other_using = "{victim} ({vrole} / {vteam}) 被 {attacker} ({arole} / {ateam}) 用 {trap} 杀死。"

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
