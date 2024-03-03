-- Simplified Chinese language strings (by 8Z & TEGTianFan)

local L = LANG.CreateLanguage("zh_hans")

-- Compatibility language name that might be removed soon.
-- the alias name is based on the original TTT language name:
-- https://github.com/Facepunch/garrysmod/blob/master/garrysmod/gamemodes/terrortown/gamemode/lang/simpchinese.lua
L.__alias = "简体中文"

L.lang_name = "简体中文（Simplified Chinese）"

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
L.round_minplayers = "没有足够的玩家来开始新的回合..."
L.round_voting = "投票进行中，新的回合将推迟到 {num} 秒后开始..."
L.round_begintime = "新回合将在 {num} 秒后开始。请做好准备。"
L.round_selected = "叛徒玩家已选出。"
L.round_started = "回合开始！"
L.round_restart = "游戏被管理员强制重新开始。"

L.round_traitors_one = "叛徒，你将孤身奋斗。"
L.round_traitors_more = "叛徒，你的队友是：{names}"

L.win_time = "时间用尽，叛徒失败了。"
L.win_traitors = "叛徒取得了胜利！"
L.win_innocents = "叛徒们被击败了！"
L.win_nones = "无人胜出！（平局）"
L.win_showreport = "来看一下 {num} 秒的回合总结吧！"

L.limit_round = "达到回合限制。即将加载下一张地图。"
L.limit_time = "达到时间限制。即将加载下一张地图。"
L.limit_left = "新地图将在 {num} 回合或 {time} 分钟后切换。"

-- Credit awards
L.credit_all = "你的阵营因为表现获得了 {num} 点积分。"
L.credit_kill = "你杀死 {role} 获得了 {num} 点积分。"

-- Karma
L.karma_dmg_full = "你的人品为 {amount}，因此本回合你将造成正常伤害。"
L.karma_dmg_other = "你的人品为 {amount}，因此本回合你造成的伤害将减少 {num}%"

-- Body identification messages
L.body_found = " {finder} 发现了 {victim} 的尸体。{role}"
L.body_found_team = "{finder} 发现了 {victim} 的尸体。{role} ({team})"

-- The {role} in body_found will be replaced by one of the following:
L.body_found_traitor = "他是一位叛徒！"
L.body_found_det = "他是一位探长。"
L.body_found_inno = "他是一位无辜者。"

L.body_call = "{player} 请求探长前来检查 {victim} 的尸体！"
L.body_call_error = "你必须先确认玩家死亡后才能呼叫探长！"

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

L.disg_help1 = "伪装开启后，别人瞄准你时将不会看见你的名字，生命值以及人品。除此之外，你也能躲避探长的雷达。"
L.disg_help2 = "按下小键盘回车键可不通过菜单直接切换伪装。你也可以使用控制台把另一个键位绑定'ttt_toggle_disguise'。"

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
L.intro_help = "若你是该模式的新手，请按下F1查看模式教程！"

-- Radiocommands/quickchat
L.quick_title = "快速聊天"

L.quick_yes = "是。"
L.quick_no = "不是。"
L.quick_help = "救命！"
L.quick_imwith = "我和 {player} 在一起。"
L.quick_see = "我看到了 {player}。"
L.quick_suspect = " {player} 行迹可疑。"
L.quick_traitor = " {player} 是叛徒！"
L.quick_inno = " {player} 是无辜者。"
L.quick_check = "还有人活着吗？"

-- {player} in the quickchat text normally becomes a player nickname, but can
-- also be one of the below.  Keep these lowercase.
L.quick_nobody = "没有人"
L.quick_disg = "伪装着的人"
L.quick_corpse = "一具未搜索过的尸体"
L.quick_corpse_id = " {player} 的尸体"

-- Scoreboard
L.sb_playing = "你正在玩的服务器是..."
L.sb_mapchange = "地图将于 {num} 个回合或是 {time} 后更换。"
L.sb_mapchange_disabled = "地图更换被禁用。"

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

L.c4_disarm_t = "剪断引线以拆除C4。你是叛徒，因此每条引线都是安全的，但其他人可就没那么容易了！"
L.c4_disarm_owned = "剪断引线以拆除C4。你是安放此C4的人，任何引线都能成功拆除。"
L.c4_disarm_other = "剪断正确的引线以拆除C4。如果你剪错的话，后果不堪设想！"

L.c4_status_armed = "安放"
L.c4_status_disarmed = "拆除"

-- Visualizer
L.vis_name = "显像器"

L.vis_desc = [[
可让犯罪现场显像化的仪器。

分析尸体，显出死者被杀害时的情况，但仅限于死者被枪杀时。]]

-- Decoy
L.decoy_name = "雷达诱饵"
L.decoy_broken = "你的雷达诱饵被摧毁了！"

L.decoy_short_desc = "这个诱饵会为其他阵营显示一个假雷达信号"
L.decoy_pickup_wrong_team = "这个诱饵属于其他阵营，你无法捡起"

L.decoy_desc = [[
显示假的雷达信号给探长，探长执行DNA扫描时，将会显示雷达诱饵的位置作为代替。]]

-- Defuser
L.defuser_name = "拆弹器"

L.defuser_desc = [[
迅速拆除一个C4。

不限制使用次数。若你持有此装备，拆除C4时会轻松许多。]]

-- Flare gun
L.flare_name = "信号枪"

L.flare_desc = [[
可用来烧毁尸体，使它们永远不会被发现。该武器有有弹药限制。

燃烧尸体会发出十分明显的声音。]]

-- Health station
L.hstation_name = "医疗站"

L.hstation_broken = "你的医疗站被摧毁了！"

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
L.dna_notfound = "目标上没有DNA样本。"
L.dna_limit = "已达最大采集额度，请先移除旧样本。"
L.dna_decayed = "凶手的DNA样本已经消失。"
L.dna_killer = "成功采集到凶手的DNA样本！"
L.dna_duplicate = "匹配！你的扫描仪里已经有这个DNA样本了。"
L.dna_no_killer = "DNA样本无法检索（凶手已离线？）"
L.dna_armed = "炸弹已启动！赶紧拆除它！"
L.dna_object = "从目标上采集了最后一位所有者的样本"
L.dna_gone = "区域内没侦测到可采集之DNA样本。"

L.dna_desc = [[
采集物体上的DNA样本，并用其找寻对应的主人。

使用在尸体上，采集杀手的DNA并追踪他。]]

-- Magneto stick
L.magnet_name = "电磁棍"
L.magnet_help = "{primaryfire} 将其定在墙上。"

-- Grenades and misc
L.grenade_smoke = "烟雾弹"
L.grenade_fire = "燃烧弹"

L.unarmed_name = "收起武器"
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

L.tele_help_pri = "传送到标记位置"
L.tele_help_sec = "标记当前位置"

L.tele_desc = [[
可以传送到先前标记的地点。

传送器会产生噪音，而且使用次数是有限的。]]

-- Ammo names, shown when picked up
L.ammo_pistol = "手枪弹药"

L.ammo_smg1 = "冲锋枪弹药"
L.ammo_buckshot = "霰弹枪弹药"
L.ammo_357 = "步枪弹药"
L.ammo_alyxgun = "沙漠之鹰弹药"
L.ammo_ar2altfire = "信号枪弹药"
L.ammo_gravity = "捣蛋鬼弹药"

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

-- TargetID Karma status
L.karma_max = "良好"
L.karma_high = "粗鲁"
L.karma_med = "不可靠"
L.karma_low = "危险"
L.karma_min = "滥杀者"

-- TargetID misc
L.corpse = "尸体"
L.corpse_hint = "按下 [{usekey}] 进行搜索并确认。按下 [{walkkey} + {usekey}] 进行隐秘搜索。"

L.target_disg = "（伪装状态）"
L.target_unid = "未确认的尸体"
L.target_unknown = "一名恐怖分子"

-- HUD buttons with hand icons that only some roles can see and use
L.tbut_single = "一次性"
L.tbut_reuse = "重复使用"
L.tbut_retime = "{num} 秒可后再次使用"
L.tbut_help = "按下 [{usekey}] 键使用"

-- Spectator muting of living/dead
L.mute_living = "静音存活玩家"
L.mute_specs = "静音观察者"
L.mute_all = "全部静音"
L.mute_off = "取消静音"

-- Spectators and prop possession
L.punch_title = "飞击量表"
L.punch_bonus = "你的分数较低，飞击量表上限减少 {num}"
L.punch_malus = "你的分数较高，飞击量表上限增加 {num}！"

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

这些是你的同伴们：
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

L.tip25 = "探长确认尸体后，相关信息将在计分板公布，如要查看只需点击死者之名字即可。"

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
L.report_tab_scores_tip = "本回合单个玩家获得的分数"

-- Event log saving
L.report_save = "保存 Log.txt"
L.report_save_tip = "将事件记录并保存在txt档内"
L.report_save_error = "没有可供保存的事件记录"
L.report_save_result = "事件记录已存在："

-- Columns
L.col_time = "时间"
L.col_event = "事件"
L.col_player = "玩家"
L.col_roles = "角色"
L.col_teams = "阵营"
L.col_kills1 = "无辜者杀敌数"
L.col_kills2 = "叛徒杀敌数"
L.col_points = "得分"
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
L.sb_sortby = "排序方法："

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
L.reroll_help = "使用 {amount} 积分在你的商店里获得新的随机装备！"

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

-- 2019-10-19
L.drop_ammo_prevented = "有什么东西阻挡你丢出子弹。"

-- 2019-10-28
L.target_c4 = "按 [{usekey}] 打开C4菜单"
L.target_c4_armed = "按 [{usekey}] 拆除C4"
L.target_c4_armed_defuser = "按 [{primaryfire}] 使用拆弹器"
L.target_c4_not_disarmable = "你不能拆除存活队友的C4"
L.c4_short_desc = "可以炸得很欢"

L.target_pickup = "按 [{usekey}] 捡起"
L.target_slot_info = "槽位：{slot}"
L.target_pickup_weapon = "按 [{usekey}] 捡起武器"
L.target_switch_weapon = "按 [{usekey}] 和当前武器交换"
L.target_pickup_weapon_hidden = "按 [{walkkey} + {usekey}] 隐秘地捡起"
L.target_switch_weapon_hidden = "按 [{walkkey} + {usekey}] 隐秘地交换"
L.target_switch_weapon_nospace = "没有提供给这个武器的槽位"
L.target_switch_drop_weapon_info = "丢弃槽位 {slot} 的 {name}"
L.target_switch_drop_weapon_info_noslot = "槽位 {slot} 没有可丢弃的武器"

L.corpse_searched_by_detective = "这具尸体已被公共警察角色搜索过"
L.corpse_too_far_away = "这个尸体太远了。"

L.radio_short_desc = "武器声音，悦耳动听"

L.hstation_subtitle = "按 [{usekey}] 恢复生命值"
L.hstation_charge = "剩余充能：{charge}"
L.hstation_empty = "这个医疗站没有剩余充能"
L.hstation_maxhealth = "你的生命值已满"
L.hstation_short_desc = "医疗站会逐渐回复充能"

-- 2019-11-03
L.vis_short_desc = "还原被枪杀的尸体的犯罪现场"
L.corpse_binoculars = "按 [{key}] 用望远镜搜查尸体"
L.binoc_progress = "搜查进度：{progress}%"

L.pickup_no_room = "你没有存放此类武器的空间"
L.pickup_fail = "你无法捡起这个武器"
L.pickup_pending = "你已经捡起这个武器，请等捡起完成"

-- 2020-01-07
L.tbut_help_admin = "编辑叛徒按钮设定"
L.tbut_role_toggle = "[{walkkey} + {usekey}] 切换 {role} 的按钮权限"
L.tbut_role_config = "身份：{current}"
L.tbut_team_toggle = "[SHIFT + {walkkey} + {usekey}] 切换 {team} 的按钮权限"
L.tbut_team_config = "阵营：{current}"
L.tbut_current_config = "当前设定："
L.tbut_intended_config = "地图默认设定："
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
L.door_open_touch_and_use = "接触门或按 [{usekey}] 开门。"

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
--L.menu_gameplay_description = "Tweak voice and sound volume, accessibility settings, and gameplay settings."
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

L.submenu_gameplay_general_title = "通用"

L.submenu_administration_hud_title = "HUD 设置"
L.submenu_administration_randomshop_title = "随机商店"

L.help_color_desc = "此选项启用后，准星和目标高亮的外框会显示一个全局通用的颜色"
L.help_scale_factor = "这个比例影响所有界面大小（HUD， vgui 和目标高亮）。屏幕分辨率修改后会自动更新这个比例。改变此比例会重置 HUD！"
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
L.label_crosshair_opacity = "准星透明度"
L.label_crosshair_ironsight_opacity = "瞄准时准星透明度"
L.label_crosshair_size = "准星长度"
L.label_crosshair_thickness = "准星粗细"
L.label_crosshair_thickness_outline = "准星外框粗细"
L.label_crosshair_scale_enable = "启用动态十字准线刻度"
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
L.label_hud_default = "默认 HUD"
L.label_hud_force = "强制 HUD"

L.label_bind_weaponswitch = "捡起武器"
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
L.door_destructible = "此门不可摧毁 （{health}生命值）"

-- 2020-05-28
L.corpse_hint_inspect_limited = "按下 [{usekey}] 进行搜索。按下 [{walkkey} + {usekey}] 仅查看搜索界面。"

-- 2020-06-04
L.label_bind_disguiser = "切换伪装器"

-- 2020-06-24
L.dna_help_primary = "收集DNA样本"
L.dna_help_secondary = "切换当前DNA"
L.dna_help_reload = "删除当前样本"

L.binoc_help_pri = "确认尸体"
L.binoc_help_sec = "切换放大倍率"

L.vis_help_pri = "丢弃当前装备。"


-- 2020-08-07
L.pickup_error_spec = "作为观察者你无法捡起这个。"
L.pickup_error_owns = "你已经有这个武器，无法再次捡起"
L.pickup_error_noslot = "你没有对应空槽位，无法捡起这个"

-- 2020-11-02
L.lang_server_default = "服务器默认"
L.help_lang_info = [[
该语言翻译已经{coverage}%，未翻译的文本将会用英语作为默认的参考。

请记住，这些翻译是基于社区提供的。如果有遗漏或不正确的地方，请自行修改。]]

-- 2021-04-13
L.title_score_info = "回合总结"
L.title_score_events = "事件时间表"

L.label_bind_clscore = "打开回合总结"
L.title_player_score = "{player}的评分："

L.label_show_events = "显示相关的事件："
L.button_show_events_you = "你"
L.button_show_events_global = "全局"
L.label_show_roles = "显示角色分配，当"
L.button_show_roles_begin = "回合开始时"
L.button_show_roles_end = "回合结束时"

L.hilite_win_traitors = "叛徒获胜"
L.hilite_win_innocents = "无辜者获胜"
L.hilite_win_tie = "达成共识"
L.hilite_win_time = "时间已到"

L.tooltip_karma_gained = "本局的人品值变化："
L.tooltip_score_gained = "本局得分变化："
L.tooltip_roles_time = "本局的角色变化："

L.tooltip_finish_score_alive_teammates = "存活的队友：{score}"
L.tooltip_finish_score_alive_all = "存活的玩家：{score}"
L.tooltip_finish_score_timelimit = "超时：{score}"
L.tooltip_finish_score_dead_enemies = "死去的敌人：{score}"
L.tooltip_kill_score = "击杀：{score}"
L.tooltip_bodyfound_score = "发现尸体：{score}"

L.finish_score_alive_teammates = "存活的队友："
L.finish_score_alive_all = "存活的玩家："
L.finish_score_timelimit = "超时："
L.finish_score_dead_enemies = "死去的敌人："
L.kill_score = "击杀："
L.bodyfound_score = "发现尸体："

L.title_event_bodyfound = "发现了一具尸体"
L.title_event_c4_disarm = "一枚C4被解除了"
L.title_event_c4_explode = "一枚C4爆炸了"
L.title_event_c4_plant = "放置了一枚C4"
L.title_event_creditfound = "搜到积分"
L.title_event_finish = "本回合已经结束"
L.title_event_game = "新回合已经开始"
L.title_event_kill = "一名玩家被杀害"
L.title_event_respawn = "一名玩家复活了"
L.title_event_rolechange = "一名玩家改变了它的角色或阵营"
L.title_event_selected = "角色分配"
L.title_event_spawn = "一名玩家生成了"

L.desc_event_bodyfound = "{finder} ({firole} / {fiteam}) 发现了 {found} ({forole} / {foteam}) 的尸体。尸体上有 {credits} 个积分。"
L.desc_event_bodyfound_headshot = "受害者被爆头致死。"
L.desc_event_c4_disarm_success = "{disarmer} ({drole} / {dteam})成功解除了由{owner} ({orole} / {oteam})放置的C4。"
L.desc_event_c4_disarm_failed = "{disarmer}({drole}/{dteam})试图解除{owner}({orole}/{oteam})武装的C4。他们失败了。"
L.desc_event_c4_explode = "由 {owner} ({role} / {team}) 放置的C4爆炸了。"
L.desc_event_c4_plant = "{owner} ({role} / {team}) 放置了一个爆炸性的C4。"
L.desc_event_creditfound = "{finder} ({firole} / {fiteam}) 在 {found} ({forole} / {foteam}) 的尸体中找到了 {credits} 个积分。"
L.desc_event_finish = "该回合持续了 {minutes}:{seconds}。 有 {alive} 个玩家活到了最后。"
L.desc_event_game = "新的回合已经开始。"
L.desc_event_respawn = "{player} 复活了。"
L.desc_event_rolechange = "{player} 将自己从 {orole} ({oteam}) 改为了 {nrole} ({nteam})。"
L.desc_event_selected = "所有 {amount} 名玩家的阵营和角色都已选定。"
L.desc_event_spawn = "{player} 生成了。"

-- Name of a trap that killed us that has not been named by the mapper
L.trap_something = "某件物品"

-- Kill events
L.desc_event_kill_suicide = "是自杀的"
L.desc_event_kill_team = "是被队友杀的"

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
L.none = "无角色"

-- 2021-04-24
L.karma_teamkill_tooltip = "击杀队友"
L.karma_teamhurt_tooltip = "对队友造成伤害"
L.karma_enemykill_tooltip = "击杀敌人"
L.karma_enemyhurt_tooltip = "对敌人造成伤害"
L.karma_cleanround_tooltip = "绝对中立"
L.karma_roundheal_tooltip = "人品值回合奖励"
L.karma_unknown_tooltip = "未知"

-- 2021-05-07
L.header_random_shop_administration = "随机商店设置"
L.header_random_shop_value_administration = "平衡性设置"

L.shopeditor_name_random_shops = "启用随机商店"
L.shopeditor_desc_random_shops = [[随机商店只给每个玩家提供一套有限的随机化装备。
阵营商店迫使一个阵营中的所有玩家拥有相同的套装，而不是定制化。
重选可以让你使用积分来刷新随机装备。]]
L.shopeditor_name_random_shop_items = "随机装备的数量"
L.shopeditor_desc_random_shop_items = "这包括那些标有“非随机”的装备。所以请选择一个足够高的数字，否则你只能得到这些。"
L.shopeditor_name_random_team_shops = "启用阵营商店"
L.shopeditor_name_random_shop_reroll = "启用商店重选功能"
L.shopeditor_name_random_shop_reroll_cost = "每次重选的花费"
L.shopeditor_name_random_shop_reroll_per_buy = "购买后自动重选"

-- 2021-06-04
L.header_equipment_setup = "装备设置"
L.header_equipment_value_setup = "平衡性设置"

L.equipmenteditor_name_not_buyable = "可以购买"
L.equipmenteditor_desc_not_buyable = "如果禁用，该装备将不会显示在商店里。分配了这种装备的角色仍然会获得它。"
L.equipmenteditor_name_not_random = "永远可用"
L.equipmenteditor_desc_not_random = "如果启用，该装备在商店中始终可用。当随机商店被启用时，它会占用一个可用的随机槽，并总是为这个装备保留它。"
L.equipmenteditor_name_global_limited = "全局限量"
L.equipmenteditor_desc_global_limited = "如果启用，该装备只能在回合中购买一次。"
L.equipmenteditor_name_team_limited = "阵营限量"
L.equipmenteditor_desc_team_limited = "如果启用，该装备在回合中每个阵营只能购买一次。"
L.equipmenteditor_name_player_limited = "玩家限量"
L.equipmenteditor_desc_player_limited = "如果启用，每个玩家在回合中只能购买一次。"
L.equipmenteditor_name_min_players = "购买该装备时最低玩家数量"
L.equipmenteditor_name_credits = "价格以积分计算"

-- 2021-06-08
L.equip_not_added = "未添加"
L.equip_added = "已添加"
L.equip_inherit_added = "已添加（继承）"
L.equip_inherit_removed = "移除（继承）"

-- 2021-06-09
L.layering_not_layered = "未分层"
L.layering_layer = "{layer} 层"
L.header_rolelayering_role = "{role} 层"
L.header_rolelayering_baserole = "基础层"
L.submenu_administration_rolelayering_title = "角色分层"
L.header_rolelayering_info = "角色分层信息"
L.help_rolelayering_roleselection = "角色选择过程被分成两个阶段。在第一轮中，基础角色被分配。基本角色是无辜者、叛徒和那些列在“基本角色层”框中的角色。第二遍是用来将这些基础角色升级为子角色。"
L.help_rolelayering_layers = "每个层中只有一个角色被选中。首先，来自自定义层的角色从第一层开始分配，直到到达最后一层或没有更多的角色可以被升级。无论哪种情况先发生。如果可升级的槽位仍然可用，未分层的角色也将被分配。"
L.scoreboard_voice_tooltip = "滚动以改变音量"

-- 2021-06-15
L.header_shop_linker = "设置"
L.label_shop_linker_set = "商店的设置"

-- 2021-06-18
L.xfer_team_indicator = "阵营"

-- 2021-06-25
L.searchbar_default_placeholder = "在列表中搜索..."

-- 2021-07-11
L.spec_about_to_revive = "在复活时，观察将被限制。"

-- 2021-09-01
L.spawneditor_name = "生成点编辑器工具"
L.spawneditor_desc = "用于在地图中放置武器，弹药和玩家生成位置。只能由超级管理员使用。"

L.spawneditor_place = "左键放置生成点"
L.spawneditor_remove = "右键删除生成点"
L.spawneditor_change = "更改生成类型（按住 [SHIFT] 以反转）"
L.spawneditor_ammo_edit = "按住编辑武器生成时自动生成的弹药数量。"

L.spawn_weapon_random = "随机武器生成"
L.spawn_weapon_melee = "近战武器生成"
L.spawn_weapon_nade = "手榴弹武器生成"
L.spawn_weapon_shotgun = "霰弹枪武器生成"
L.spawn_weapon_heavy = "重武器生成"
L.spawn_weapon_sniper = "狙击武器生成"
L.spawn_weapon_pistol = "手枪武器生成"
L.spawn_weapon_special = "特殊武器生成"
L.spawn_ammo_random = "随机弹药生成"
L.spawn_ammo_deagle = "沙漠之鹰弹药生成"
L.spawn_ammo_pistol = "手枪弹药生成"
L.spawn_ammo_mac10 = "冲锋枪弹药生成"
L.spawn_ammo_rifle = "狙击枪弹药生成"
L.spawn_ammo_shotgun = "霰弹枪弹药生成"
L.spawn_player_random = "随机玩家生成"

L.spawn_weapon_ammo = "（弹药：{ammo}）"

L.spawn_weapon_edit_ammo = "按住 [{walkkey}]并按 [{primaryfire} 或 {secondaryfire}] 以增加或减少此武器生成的弹药量"

L.spawn_type_weapon = "这是个武器生成点"
L.spawn_type_ammo = "这是个弹药生成点"
L.spawn_type_player = "这是个玩家生成点"

L.spawn_remove = "按 [{secondaryfire}] 删除此生成点"

L.submenu_administration_entspawn_title = "生成点编辑器"
L.header_entspawn_settings = "生成点编辑器设置"
L.button_start_entspawn_edit = "开始生成点编辑"
L.button_delete_all_spawns = "删除所有生成点位置"

L.label_dynamic_spawns_enable = "为该地图启用动态生成"
L.label_dynamic_spawns_global_enable = "为所有地图启用自定义生成"

L.header_equipment_weapon_spawn_setup = "武器生成设置"

L.help_spawn_editor_info = [[
生成编辑器是用来放置，移除和编辑世界上的生成点。这些生成点是为武器，弹药和玩家准备的。

这些生成点被保存在位于"data/ttt/weaponspawnscripts/"的文件中。它们可以被删除以进行硬重置。最初的生成文件是由地图上和原始TTT武器生成脚本中的生成创建的。按下重置按钮总是会恢复到这个状态。

应该注意的是，这个生成系统使用动态生成。这将使武器生成系统更加有趣，因为它不再定义一个特定的武器。而是定义一种武器类型。例如，现在不是生成TTT自带的霰弹枪，而是生成被分类成霰弹枪的武器，任何定义为霰弹枪的武器都可以生成。每个武器的生成类型可以在装备编辑器中设置，这使得任何武器都可以在地图上生成，或者禁用某些默认武器。

请记住，更改只有在新的一轮开始后才会生效。]]
L.help_spawn_editor_enable = "在某些地图上，可能会建议使用在地图自带的原始生成点，而不用动态系统来取代它们。禁用这个复选框只对当前活动地图禁用。其他地图仍将使用动态系统。"
L.help_spawn_editor_hint = "提示：要离开生成编辑器，重新打开游戏模式菜单。"
L.help_spawn_editor_spawn_amount = [[
目前在这张地图上有 {weapon} 个武器生成点，{ammo} 个弹药生成点和 {player} 个玩家生成点。
点击'开始编辑生成'来改变这个生成。

{weaponrandom}x 随机武器生成
{weaponmelee}x 近战类武器生成
{weaponnade}x 爆炸物类武器生成
{weaponshotgun}x 霰弹类武器生成
{weaponheavy}x 重型类武器生成
{weaponsniper}x 狙击类武器生成
{weaponpistol}x 手枪类武器生成
{weaponspecial}x 特殊武器生成

{ammorandom}x 随机弹药生成
{ammodeagle}x 沙漠之鹰弹药生成
{ammopistol}x 手枪弹药生成
{ammomac10}x Mac10弹药生成器
{ammorifle}x 狙击枪弹药生成
{ammoshotgun}x 霰弹枪弹药生成

{playerrandom}x 玩家随机位置生成]]

L.equipmenteditor_name_auto_spawnable = "装备可在地图中随机生成"
L.equipmenteditor_name_spawn_type = "选择生成类型"
L.equipmenteditor_desc_auto_spawnable = [[
TTT2的生成系统允许每种武器在世界中生成，默认情况下，只有被创造者标记为'自动生成'的武器才会在世界中生成，但这些设置可以在该菜单中更改。

大多数装备在默认情况下被设置为'特殊武器生成'。这意味着它们只在随机武器生成点上生成。然而，我们可以在地图中放置特殊的武器生成点，或者改变生成点的生成类型，以使用其他现有的生成类型。]]

L.pickup_error_inv_cached = "你现在不能拿起这个，因为你的库存被缓存了。"

-- 2021-09-02
L.submenu_administration_playermodels_title = "玩家模型"
L.header_playermodels_general = "通用玩家模型设置"
L.header_playermodels_selection = "选择玩家模型库"

L.label_enforce_playermodel = "强制设置玩家模型"
L.label_use_custom_models = "使用一个随机选择的玩家模型"
L.label_prefer_map_models = "优先选择地图特定模型而不是默认模型"
L.label_select_model_per_round = "每轮选择一个新的随机模型（如果禁用，则仅在地图变更时）"

L.help_prefer_map_models = [[
有些地图定义了他们自己的玩家模型，默认情况下。这些模型的优先级比自动分配的模型高。如果禁用此设置。地图自带的玩家模型将被禁用，

角色的特定模型总是有更高的优先权。不受这个设置的影响。]]
L.help_enforce_playermodel = [[
有些角色有自定义的玩家模型。但是它可以被禁用，可能会导致玩家模型选择器的兼容出现问题。
如果这个设置被禁用，仍然可以选择默认的随机模型。]]
L.help_use_custom_models = [[
默认情况下，只有CS起源版凤凰战士的模型被分配给所有玩家，然而，如果启用这个选项，将使用玩家模型库，启用此设置后，每个玩家将被分配到相同的玩家模型，但这些模型将从模型库中选择。

模型选择可通过安装更多的玩家模型来扩展。]]

-- 2021-10-06
L.menu_server_addons_title = "服务器插件"
L.menu_server_addons_description = "服务器端管理员专用的插件设置。"

L.tooltip_finish_score_penalty_alive_teammates = "存活队友处罚：{score}"
L.finish_score_penalty_alive_teammates = "存活队友处罚："
L.tooltip_kill_score_suicide = "自杀：{score}"
L.kill_score_suicide = "自杀："
L.tooltip_kill_score_team = "击杀队友：{score}"
L.kill_score_team = "击杀队友："

-- 2021-10-09
L.help_models_select = [[
左键点击模型，将其添加到玩家模型库中。再次以左键删除它们。右键可在所关注的模型的启用和禁用侦探帽之间进行切换。

左上角的小指示器显示玩家模型是否有头部的命中箱，下面的图标显示了这个模型是否可佩戴侦探帽。]]

L.menu_roles_title = "角色设置"
L.menu_roles_description = "设置生成概率、装备积分及更多。"

L.submenu_administration_roles_general_title = "通用角色设置"

L.header_roles_info = "角色信息"
L.header_roles_selection = "角色选择概率"
L.header_roles_tbuttons = "角色叛徒按钮"
L.header_roles_credits = "角色装备积分"
L.header_roles_additional = "附加角色设置"
L.header_roles_reward_credits = "奖励装备积分"

L.help_roles_default_team = "默认团队：{team}"
L.help_roles_unselectable = "这个角色是不可选择的。这意味着它在角色选择系统中不被考虑。大多数情况下，这意味着这是回合中通过某个事件（如复活为僵尸，副手老鹰或类似的东西）手动应用的角色。"
L.help_roles_selectable = "这个角色是可选择的，这意味着如果满足所有的标准，这个角色在角色选择过程中会被考虑。"
L.help_roles_credits = "积分用于在商店购买装备。大部分情况下，积分只对能使用商店的身份有用。不过，由于尸体上可以搜刮到积分，可以考虑给一个身份提供初始积分来作为杀手的奖励。"
L.help_roles_selection_short = "每个玩家的角色分布定义了被分配到这个角色的玩家的百分比。例如，如果该值被设置为'0.2'，那么每五名玩家中就有一人会变为此角色。"
L.help_roles_selection = [[
每个玩家的角色分配定义了被分配到这个角色的玩家的百分比。例如，如果该值被设置为 "0.2"，那么每五个玩家就会得到这个角色。这也意味着，至少需要5名玩家才能分配到这个角色。
请记住，所有这些都只适用于该角色被考虑分配过程。

前面提到的角色分配与玩家的下限有一个特殊的整合。如果该角色被考虑用于分配，且最小值低于分配系数所给的值，但玩家数量等于或大于下限，则单个玩家仍可获得该角色。然后分配过程对第二个玩家照常进行。]]
L.help_roles_award_info = "部分身份（如果在积分设置中启用）在一定比例的敌人死亡后会获得积分。此功能的相关数值可以在这里调整。"
L.help_roles_award_pct = "当这个百分比的敌人死亡后，特定的角色会获得积分。"
L.help_roles_award_repeat = "积分奖励是否会多次发放。例如，如果你将百分比设置为'0.25'，并启用此功能，玩家将在死亡人数到达全玩家的'25%'，'50%'和'75%'时获得积分。"
L.help_roles_advanced_warning = "警告：这些是高级设置，可以完全扰乱角色分配过程。如果有疑问，请将所有值保持在 '0'。这个值意味着不应用任何限制，角色分配将尝试分配尽可能多的角色。"
L.help_roles_max_roles = [[
角色类别包含TTT2中的每个角色。默认情况下，对于可以分配多少个不同的角色没有限制。然而，这里有两种不同的方法来限制它们。

1.用一个固定的数值限制。
2.通过百分比限制。

后者仅在固定数值为'0'时使用，并根据设定的可用玩家百分比设置上限。]]
L.help_roles_max_baseroles = [[
基础角色只是那些其他角色所继承的角色阵营。例如，"无辜者"角色是一个基础角色，而"法老"是这个角色的一个子角色。默认情况下，对于可以分配多少个不同的角色没有限制。然而，这里有两种不同的方法来限制它们。

1.用一个固定的数值限制。
2.通过百分比限制。

后者只在固定数值为'0'时使用，并根据设定的可用玩家百分比设置上限。]]

L.label_roles_enabled = "启用角色"
L.label_roles_min_inno_pct = "每个玩家所分配的无辜者角色比例"
L.label_roles_pct = "每位玩家的角色分配"
L.label_roles_max = "分配到该角色的玩家上限"
L.label_roles_random = "分配到该角色的可能性"
L.label_roles_min_players = "分配到该角色的最低下限"
L.label_roles_tbutton = "是否可使用叛徒按钮"
L.label_roles_credits_starting = "初始装备积分"
L.label_roles_credits_award_pct = "积分奖励报酬率"
L.label_roles_credits_award_size = "积分奖励比例"
L.label_roles_credits_award_repeat = "积分奖励重复量"
L.label_roles_newroles_enabled = "启用自定义角色"
L.label_roles_max_roles = "角色上限"
L.label_roles_max_roles_pct = "按百分比计算角色上限"
L.label_roles_max_baseroles = "基础角色上限"
L.label_roles_max_baseroles_pct = "按百分比计算基础角色上限"
L.label_detective_hats = "为像侦探这样的警察角色启用帽子（如果玩家模型允许戴帽子）。"

L.ttt2_desc_innocent = "无辜者没有特殊能力。他们必须在恐怖分子中找到邪恶的人并杀死他们。但他们必须小心，不要误杀自己的同伴。"
L.ttt2_desc_traitor = "叛徒是无辜者的敌人。他们有一个装备菜单，可以购买特殊装备。他们必须杀死所有的人，除了他们的队友。"
L.ttt2_desc_detective = "侦探是无辜者们最信任的人。但谁是无辜者？强大的侦探必须要找到所有图谋不轨恐怖分子。他们商店里的装备可能会帮助他们完成这项任务。"

-- 2021-10-10
L.button_reset_models = "重置玩家模型"

-- 2021-10-13
L.help_roles_credits_award_kill = "另一种获得积分的方式是通过杀死拥有'公开身份'的高价值玩家，比如侦探。如果杀手的身份启用了这个功能，他们会获得此处配置的积分量。"
L.help_roles_credits_award = [[
在TTT2中，有两种不同的方式可以获得积分：

1.如果敌方队伍中有一定比例的人死亡，整个队伍将会被奖励积分。
2.如果一个玩家用'公开角色'（如侦探）杀死了一个高价值的角色，那么这位玩家就会得到奖励。

请注意，即使整个团队都获得了奖励，每个身份仍可启用/禁用此功能。例如，如果'无辜者'团队获得了奖励，但'无辜者'身份禁用了此功能，则只有'侦探'会获得积分。
这个功能的平衡值可以在'管理'->'通用角色设置'中设置。]]
L.help_detective_hats = [[
侦探等警察角色可以戴帽子以显示其权威。他们在死亡时或头部受损时将失去帽子。

部分玩家模型默认不支持帽子。你可以在'管理'->'玩家模型'中改变这一点。]]

L.label_roles_credits_award_kill = "击杀获得的积分奖励"
L.label_roles_credits_dead_award = "启用对依据一定比例敌人死亡数提供积分奖励"
L.label_roles_credits_kill_award = "启用对击杀高价值角色时提供积分奖励"
L.label_roles_min_karma = "分配角色时玩家的最低人品值"

-- 2021-11-07
L.submenu_administration_administration_title = "管理"
L.submenu_administration_voicechat_title = "语音聊天/文本聊天"
L.submenu_administration_round_setup_title = "回合设置"
L.submenu_administration_mapentities_title = "地图实体"
L.submenu_administration_inventory_title = "库存"
L.submenu_administration_karma_title = "人品值"
L.submenu_administration_sprint_title = "冲刺"
L.submenu_administration_playersettings_title = "玩家设定"

L.header_roles_special_settings = "特殊角色设定"
L.header_equipment_additional = "额外装备设置"
L.header_administration_general = "通用管理设置"
L.header_administration_logging = "日志"
L.header_administration_misc = "杂项"
L.header_entspawn_plyspawn = "玩家生成设置"
L.header_voicechat_general = "通用语音聊天设置"
L.header_voicechat_battery = "语音聊天电池"
L.header_voicechat_locational = "基于玩家位置范围语音"
L.header_playersettings_plyspawn = "玩家生成设置"
L.header_round_setup_prep = "回合：准备阶段"
L.header_round_setup_round = "回合：进行阶段"
L.header_round_setup_post = "回合：结束阶段"
L.header_round_setup_map_duration = "地图持续时间"
L.header_textchat = "文本聊天"
L.header_round_dead_players = "死亡玩家设置"
L.header_administration_scoreboard = "记分版设置"
L.header_hud_toggleable = "可切换的HUD元素"
L.header_mapentities_prop_possession = "Prop附体"
L.header_mapentities_doors = "门"
L.header_karma_tweaking = "人品值调整"
L.header_karma_kick = "人品值踢出和封禁"
L.header_karma_logging = "人品值记录"
L.header_inventory_gernal = "库存大小"
L.header_inventory_pickup = "库存武器拾取"
L.header_sprint_general = "冲刺设置"
L.header_playersettings_armor = "护甲系统设置"

L.help_killer_dna_range = "当玩家被其他玩家杀死时，会在他们身上留下DNA指纹，最大范围convar定义了留下DNA样本的最大距离，以锤子编辑器为单位，如果杀手在更远的地方，那么就不会在尸体上留下样本。"
L.help_killer_dna_basetime = "直到DNA样本衰变的基本时间，以秒为单位，从这个基准时间中减去一个杀手距离的平方系数。"
L.help_dna_radar = "如果配备了TTT2 DNA扫描器，会显示所选DNA样本的确切距离和方向。然而，也有一种经典的DNA扫描器模式，每次冷却时间过后都会用世界范围的渲染来更新所选的样本。"
L.help_idle = "挂机模式是用来将挂机的玩家转移到一个强制的旁观者模式。要再次离开这个模式，他们必须在他们的'游戏'设置中禁用'强制旁观模式'。"
L.help_namechange_kick = [[
如果玩家在回合中改变他们的名字，这可能会被滥用来提供信息。因此，禁止在进行中的回合改变昵称。

如果被封禁时间大于0，该玩家将无法重新连接到服务器，直到该时间结束。]]
L.help_damage_log = "每次玩家受到伤害时，就会在控制台中添加一个伤害日志条目。这也可以在一个回合结束后存储到磁盘上。该文件位于'data/terrortown/logs/'"
L.help_spawn_waves = [[
如果这个变量被设置为0，所有玩家将会同时生成。对于拥有大量玩家的服务器来说，一波一波地生成玩家可能是有益的。生成波的时间间隔是指每个生成波之间的时间，一个生成波总是产生与会生成与生成点相同数量的玩家。

注意：确保准备时间足够长，以达到所需的生成波数量。]]
L.help_voicechat_battery = [[
在启用语音聊天电池的情况下，语音聊天会减少电量。当电量耗尽时，玩家将不能语音聊天。必须等待几秒钟来充电。这可以帮助防止过度使用语音聊天。

注意：'Tick'指的是游戏中的Tick，即1/66秒的时间。]]
L.help_ply_spawn = "在玩家（重新）产生时使用的玩家设定。"
L.help_haste_mode = [[
急速模式通过增加在玩家死亡时增加回合时间来平衡游戏。只有看到回合中失踪的玩家的角色才能看到真正的回合时间，其他角色只能看到急速模式的起始时间。

如果急速模式被启用，固定的回合时间将被忽略。]]
L.help_round_limit = "在满足设定的限制条件之一后，将会更换地图。"
L.help_armor_balancing = "以下数值可以用来平衡护甲。"
L.help_item_armor_classic = "如果启用了经典护甲模式，只有之前的设置才是生效的。经典护甲模式意味着玩家在一个回合中只能购买一次护甲，并且这个护甲可以阻挡30%的子弹和撬棍的伤害，直到他们死亡。"
L.help_item_armor_dynamic = [[
动态护甲是TTT2的新系统，使护甲系统更加有趣。现在可以购买的护甲数量是无限的，而且护甲的效果可以叠加。受到伤害会降低护甲值，每件物品的护甲值是在该物品的"装备设置"中设置的。

当受到伤害时。这个伤害的一定比例会转化为护甲伤害，不同的比例仍然适用于玩家，其余的则会消失。

如果强化护甲被启用，只要护甲值高于强化阈值，施加给玩家的伤害就会减少15%。]]
L.help_sherlock_mode = "侦探模式是经典的TTT模式。如果侦探模式被禁用，尸体将被确认，记分牌上显示每个人都活着，观察者可以与活着的玩家交谈。"
L.help_prop_possession = [[
观察者可以使用道具附身来附身于躺在世界中的道具，并使用缓慢充能的'飞击量表'来移动上述道具。

'飞击量表'的最大值由一个基础值和其他判断值组成，其中击杀数/死亡数将影响该值。随着时间的推移，能量条会慢慢充电。设定的充电时间是为'飞击量表'中的一个点进行充电所需的时间。]]
L.help_karma = "玩家有一定量的初始人品值，伤害/杀死队友时会失去人品。失去的数值取决于他们伤害或杀死的人的人品值，对方人品越低，损失的人品越低。"
L.help_karma_strict = "如果严格人品模式被启用，伤害惩罚会随着人品值的减少快速增加。非严格模式下，人品值保持在 800 以上时的伤害惩罚非常低。启用严格模式使人品值在阻止任何不必要的击杀方面发挥更大的作用，而禁用它则导致一个更宽松的游戏范围，人品系统只会影响不断击杀队友的玩家。"
L.help_karma_max = "将最大人品值设置为1000以上，不会给人品值超过1000的玩家提供伤害加成，它可以作为一个人品值缓冲区。"
L.help_karma_ratio = "用于计算如果双方在同一个团队中，受害者的人品值被减去多少的伤害比例。如果发生击杀友军事件，会有进一步的惩罚。"
L.help_karma_traitordmg_ratio = "如果双方在不同的队伍中，用来计算受害者的人品值被减去多少的伤害比率。如果发生击杀事件，会有进一步的奖励。"
L.help_karma_bonus = "在一个回合中也有两种不同的被动方式来获得人品值。首先，一个回合的回复会应用于每个玩家。然后，如果没有伤害队友或击杀，会有一个二次回复的奖励。"
L.help_karma_clean_half = [[
当玩家的人品值高于起始水平时（意味着人品值最大值已被配置为高于该水平），他们所有的人品值增加将根据其人品值高于起始水平的程度而减少。因此，它越高，增加的速度就越慢。

这种减少是以指数衰减的曲线进行的：最初速度很快，随着增量的变小，速度也会变慢。这个控制台指令设定了奖金减半的时间点（即半衰期）。在默认值为0.25的情况下，如果人品值的起始值为1000，最大值为1500，而玩家有1125（1500-1000）*0.25=125)人品值，那么他的无误杀轮奖励将是30/2=15。因此，为了使值下降得更快，你应该把该设置得更低，为了使它下降得更慢，你应该把它增加到1。]]
L.help_max_slots = "设置每个插槽的最大武器数量。'-1'表示没有限制。"
L.help_item_armor_value = "这是动态模式下的护甲项目给出的护甲值。如果启用了经典模式（见'管理'->'玩家设置'），那么每一个大于0的值都被算作护甲。"

L.label_killer_dna_range = "留下DNA的最大击杀范围"
L.label_killer_dna_basetime = "样本存活基础时间"
L.label_dna_scanner_slots = "DNA样本插槽"
L.label_dna_radar = "启用经典DNA扫描模式"
L.label_dna_radar_cooldown = "DNA扫描仪的冷却时间"
L.label_radar_charge_time = "雷达采样后的充电时间"
L.label_crowbar_shove_delay = "撬棍推动玩家后的冷却时间"
L.label_idle = "启用挂机模式"
L.label_idle_limit = "最长可挂机时间（秒）"
L.label_namechange_kick = "启用改名踢出"
L.label_namechange_bantime = "踢出后封禁的时间，以分钟为单位"
L.label_log_damage_for_console = "启用控制台的伤害记录"
L.label_damagelog_save = "将伤害日志保存到磁盘上"
L.label_debug_preventwin = "禁用回合结束[debug]"
L.label_bots_are_spectators = "机器人永远是观察者"
L.label_tbutton_admin_show = "向管理员显示叛徒按钮"
L.label_ragdoll_carrying = "启用布娃娃搬运"
L.label_prop_throwing = "启用道具投掷"
L.label_weapon_carrying = "启用武器搬运"
L.label_weapon_carrying_range = "武器搬运范围"
L.label_prop_carrying_force = "Prop推进力"
L.label_teleport_telefrags = "在传送时杀死被封禁的玩家"
L.label_allow_discomb_jump = "允许手榴弹发射器进行迪斯科跳跃"
L.label_spawn_wave_interval = "生成的间隔时间，以秒为单位"
L.label_voice_enable = "启用语音聊天"
L.label_voice_drain = "启用语音聊天的电池功能"
L.label_voice_drain_normal = "普通玩家的每滴答消耗量"
L.label_voice_drain_admin = "让管理员和公共警察角色的电池会耗尽"
L.label_voice_drain_recharge = "不进行语音聊天时每滴答的充能率"
L.label_locational_voice = "为活着的玩家启用近距离语音聊天功能"
L.label_armor_on_spawn = "玩家在重生时的默认护甲量"
L.label_prep_respawn = "在准备阶段启用即时重生"
L.label_preptime_seconds = "准备时间（秒）"
L.label_firstpreptime_seconds = "首局准备时间（秒）"
L.label_roundtime_minutes = "固定回合时间（分钟）"
L.label_haste = "启用急速模式"
L.label_haste_starting_minutes = "急速模式开始时间（分钟）"
L.label_haste_minutes_per_death = "玩家死亡给予的额外时间（分钟）"
L.label_posttime_seconds = "回合后时间，以秒为单位"
L.label_round_limit = "回合数上限"
L.label_time_limit_minutes = "游戏时间上限，以分钟为单位"
L.label_nade_throw_during_prep = "在准备时间内允许投掷手榴弹"
L.label_postround_dm = "回合结束后启用死亡竞赛"
L.label_session_limits_enabled = "启用地图更换"
L.label_spectator_chat = "启用观察者与大家聊天的功能"
L.label_lastwords_chatprint = "如果在打字时被杀，则发出最后一句话至聊天室"
L.label_identify_body_woconfirm = "不按'确认'按钮识别尸体"
L.label_announce_body_found = "当尸体被确认时，宣布找到了一个尸体"
L.label_confirm_killlist = "宣布确认尸体时，该尸体的击杀名单"
L.label_dyingshot = "如果玩家在瞄准中，则在死亡时开枪[试验性]"
L.label_armor_block_headshots = "启用护甲阻挡爆头伤害"
L.label_armor_block_blastdmg = "启用护甲阻挡爆炸伤害"
L.label_armor_dynamic = "启用动态护甲"
L.label_armor_value = "护甲物品所赋予的护甲"
L.label_armor_damage_block_pct = "护甲承受的伤害百分比"
L.label_armor_damage_health_pct = "玩家承受的伤害百分比"
L.label_armor_enable_reinforced = "启用强化护甲"
L.label_armor_threshold_for_reinforced = "强化护甲阈值"
L.label_sherlock_mode = "启用侦探模式"
L.label_highlight_admins = "突出服务器管理员"
L.label_highlight_dev = "突出显示TTT2开发者"
L.label_highlight_vip = "突出显示TTT2支持者"
L.label_highlight_addondev = "突出显示TTT2附加组件的开发者"
L.label_highlight_supporter = "突出显示其他人"
L.label_enable_hud_element = "启用 {elem} HUD 元素"
L.label_spec_prop_control = "启用Prop附体"
L.label_spec_prop_base = "附体时的基础值"
L.label_spec_prop_maxpenalty = "降低附体奖金下限"
L.label_spec_prop_maxbonus = "提高附体奖金上限"
L.label_spec_prop_force = "附体时推动力"
L.label_spec_prop_rechargetime = "充能时间（秒）"
L.label_doors_force_pairs = "强迫让只能关闭的门变为正常门"
L.label_doors_destructible = "启用破坏门系统"
L.label_doors_locked_indestructible = "初始锁定的门是不可摧毁的"
L.label_doors_health = "门的生命值"
L.label_doors_prop_health = "被破坏的门生命值"
L.label_minimum_players = "开始游戏的最低玩家数量"
L.label_karma = "启用人品值"
L.label_karma_strict = "启用严格的人品值"
L.label_karma_starting = "初始人品值"
L.label_karma_max = "最大人品值"
L.label_karma_ratio = "团队伤害的惩罚比例"
L.label_karma_kill_penalty = "击杀队友的惩罚"
L.label_karma_round_increment = "回合结束时所给予的人品值"
L.label_karma_clean_bonus = "无误杀回合奖励"
L.label_karma_traitordmg_ratio = "伤害其他团队玩家的奖励比例"
L.label_karma_traitorkill_bonus = "击杀其他团队玩家的奖励"
L.label_karma_clean_half = "无误杀奖励减少比例"
L.label_karma_persist = "人品值在地图更换后依然保留"
L.label_karma_low_autokick = "自动踢掉低人品值的玩家"
L.label_karma_low_amount = "低人品值阈值"
L.label_karma_low_ban = "封禁选中的最低人品值玩家"
L.label_karma_low_ban_minutes = "封禁时间（分钟）"
L.label_karma_debugspam = "启用关于人品值变化的调试输出到控制台"
L.label_max_melee_slots = "近战槽位最多可携带"
L.label_max_secondary_slots = "辅助槽位最多可携带"
L.label_max_primary_slots = "主要插槽最多可携带"
L.label_max_nade_slots = "最大手榴弹插槽"
L.label_max_carry_slots = "携带槽位最多可携带"
L.label_max_unarmed_slots = "非武装槽位最多可携带"
L.label_max_special_slots = "特殊槽位最多可携带"
L.label_max_extra_slots = "额外槽位最多可携带"
L.label_weapon_autopickup = "启用自动武器拾取"
L.label_sprint_enabled = "启用冲刺功能"
L.label_sprint_max = "冲刺体力最大值"
L.label_sprint_stamina_consumption = "体力消耗系数"
L.label_sprint_stamina_regeneration = "体力恢复系数"
L.label_crowbar_unlocks = "主要攻击键可以作为互动（即解锁）使用"
L.label_crowbar_pushforce = "撬棍推动力"

-- 2022-07-02
L.header_playersettings_falldmg = "摔落伤害设置"

L.label_falldmg_enable = "启用摔落伤害"
L.label_falldmg_min_velocity = "发生摔落伤害的最小速度阈值"
L.label_falldmg_exponent = "与速度相关的摔落伤害增加指数"

L.help_falldmg_exponent = [[
该值修改了随着玩家撞击地面的速度而以指数方式增加的摔落伤害。

更改此值时请小心。设置得太高，即使是二阶阶梯的高度也会致命，而设置得太低，玩家从五楼跳下来时也安然无恙。]]

-- 2023-02-08
L.testpopup_title = "一个测试弹出窗口，现在有一个多行标题，多好啊！"
L.testpopup_subtitle = "好吧，你好！这是一个带有一些特殊信息的花式弹出窗口。文字也可以是多行的，多好啊！呃，如果我有什么想法的话，我可以添加这么多的文字..."

L.hudeditor_chat_hint1 = "[TTT2][INFO] 将鼠标悬停在一个元素上，按住[LMB]并移动鼠标来移动或调整其大小。"
L.hudeditor_chat_hint2 = "[TTT2][INFO] 按住ALT键进行对称调整大小。"
L.hudeditor_chat_hint3 = "[TTT2][INFO] 按住SHIFT键，在轴上移动并保持长宽比。"
L.hudeditor_chat_hint4 = "[TTT2][INFO] 按[RMB] -> 'Close' 来退出HUD编辑器！"

L.guide_nothing_title = "这里暂时什么都没有！"
L.guide_nothing_desc = "这是一项正在进行中的工作，通过在GitHub上为项目做贡献来帮助我们。"

L.sb_rank_tooltip_developer = "TTT2开发者"
L.sb_rank_tooltip_vip = "TTT2支持者"
L.sb_rank_tooltip_addondev = "TTT2插件开发者"
L.sb_rank_tooltip_admin = "服务器管理员"
L.sb_rank_tooltip_streamer = "主播"
L.sb_rank_tooltip_heroes = "TTT2 英雄"
L.sb_rank_tooltip_team = "阵营"

L.tbut_adminarea = "管理区:"

-- 2023-08-10
L.equipmenteditor_name_damage_scaling = "伤害缩放"

-- 2023-08-11
L.equipmenteditor_name_allow_drop = "允许丢弃"
L.equipmenteditor_desc_allow_drop = "如果启用，玩家可以自由地丢弃装备。"

L.equipmenteditor_name_drop_on_death_type = "死亡时丢弃"
L.equipmenteditor_desc_drop_on_death_type = "尝试覆盖玩家死亡时装备是否被丢弃的操作。"

L.drop_on_death_type_default = "默认（由武器定义）"
L.drop_on_death_type_force = "强制死亡时丢弃"
L.drop_on_death_type_deny = "拒绝死亡时丢弃"

-- 2023-08-26
L.equipmenteditor_name_kind = "装备槽"
L.equipmenteditor_desc_kind = "装备将占用的库存槽。"

L.slot_weapon_melee = "近战槽"
L.slot_weapon_pistol = "手枪槽"
L.slot_weapon_heavy = "重型槽"
L.slot_weapon_nade = "手雷槽"
L.slot_weapon_carry = "携带槽"
L.slot_weapon_unarmed = "空手槽"
L.slot_weapon_special = "特殊槽"
L.slot_weapon_extra = "额外槽"
L.slot_weapon_class = "职业槽"

-- 2023-10-04
L.label_voice_duck_spectator = "观察者语音淡化"
L.label_voice_duck_spectator_amount = "观察者语音淡化程度"
L.label_voice_scaling = "语音淡化比例"
L.label_voice_scaling_mode_linear = "线性"
L.label_voice_scaling_mode_power4 = "四次方"
L.label_voice_scaling_mode_log = "对数"

-- 2023-10-07
L.search_title = "尸检 - {player}"
L.search_info = "信息"
L.search_confirm = "确认死亡"
L.search_confirm_credits = "确认（+{credits} 积分）"
L.search_take_credits = "获取 {credits} 积分"
L.search_confirm_forbidden = "确认死亡被禁用"
L.search_confirmed = "确认死亡"
L.search_call = "呼叫探长"
L.search_called = "死亡报告"

L.search_team_role_unknown = "???"

L.search_words = "直觉告诉你这个人的遗言是：{lastwords}"
L.search_armor = "他穿着非标准护甲。"
L.search_disguiser = "他持有一个能隐匿身份的设备"
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
L.search_dmg_teleport = "看起来他的DNA以超光速粒子之形式散乱在附近。"
L.search_dmg_car = "他穿越马路时被一个粗心的驾驶碾死了。"
L.search_dmg_other = "你无法找到这恐怖份子的具体死因。"

L.search_floor_antlions = "尸体上仍然爬满了蚂蚁。地上也爬满了它们。"
L.search_floor_bloodyflesh = "尸体上的血看起来又老又恶心，甚至有小块血肉粘在鞋上。"
L.search_floor_concrete = "灰色的尘土覆盖了尸体的鞋子和膝盖。看起来犯罪现场的地面是混凝土制的。"
L.search_floor_dirt = "闻起来有泥土的味道。可能是来自粘在受害者鞋子上的泥土。"
L.search_floor_eggshell = "恶心的白色斑点覆盖了受害者的身体。看起来像鸡蛋壳。"
L.search_floor_flesh = "受害者的衣服感觉有点湿。好像摔在了一个潮湿的表面上。比如肉质的表面，或者水体里的沙地。"
L.search_floor_grate = "受害者的皮肤像牛排一样，全身都有网格状的粗线。他们是不是倒在了格栅上？"
L.search_floor_alienflesh = "外星人的肉？听起来有点离谱。但你的侦探助手书将其列为可能的地面材质。"
L.search_floor_snow = "一眼看去，他的衣服只是潮湿而冰冷的。但当你看到边缘的白色泡沫时你就明白了。是雪！"
L.search_floor_plastic = "'哎哟，那一定很疼。' 尸体上布满了烫伤的痕迹，看起来像是和塑料表面摩擦出来的伤势。"
L.search_floor_metal = "尸体上布满了锈迹斑斑的伤口，至少他们现在死了，不会得破伤风。他们可能是在金属表面上死的。"
L.search_floor_sand = "小小的粗糙的岩石粘在他们冰冷的身体上。像海滩上的粗砂。啊，它到处都是！"
L.search_floor_foliage = "大自然真美。受害者的血腥伤口被足够的叶子覆盖，几乎被隐藏起来。"
L.search_floor_computer = "嘀嗒嘀嗒。他的尸体被计算机表面覆盖着！你问这看起来会是什么样子？额，诶嘿！"
L.search_floor_slosh = "湿漉漉的，甚至可能有点黏糊糊的。他们的整个身体都被它覆盖，衣服也被浸湿。它很臭！"
L.search_floor_tile = "许多碎片插在尸体上，像是摔在瓷砖地面上时砸出的痕迹。"
L.search_floor_grass = "闻起来像刚割过的草。这种气味几乎盖过了血和死亡的气味。"
L.search_floor_vent = "当你摸他们的身体时，你感觉到一股新鲜的气流。他是不是在死在了通风口里然后带走了空气？"
L.search_floor_wood = "有什么比坐在硬木地板上沉思更好的事情呢？至少不是躺在木地板上死！"
L.search_floor_default = "那看起来很基础，很普通。像是默认的一样。你无法判断出这个表面的任何特征。"
L.search_floor_glass = "他的尸体上全是血腥的切口。有些伤口里卡着玻璃碎片，看上去挺吓人的。"
L.search_floor_warpshield = "由'warpshield'制成的地板？没错，我们和你一样困惑。但我们的笔记上清楚地这么写着。'Warpshield'。"

L.search_water_1 = "受害者的鞋子沾了水，但其他地方都是干的。他可能是脚踩在水里时被杀的。"
L.search_water_2 = "受害者的鞋子和裤子都湿透了。他们在被杀时是不是在涉水？"
L.search_water_3 = "潮湿的尸体全身肿胀着。他可能是在完全被淹没的时候死的。"

L.search_weapon = "死者是被 {weapon} 所杀。"
L.search_head = "最后一击打在头上。完全没机会叫喊。"
L.search_time = "他们在你进行搜索之前就已经死了一段时间了。"
L.search_dna = "用DNA扫描仪获取杀手的DNA样本。DNA样本会在一段时间后消逝。"

L.search_kills1 = "你找到一个名单，记载着他发现的死者：{player}"
L.search_kills2 = "你找到了一个名单，记载着他杀的这些人：{player}"
L.search_eyes = "透过你的探查技能，你确信他临死前见到的最后一个人是 {player}。是凶手，还是巧合？"

L.search_credits = "受害者口袋里有 {credits} 积分。带商店的身份也许会拿走它们并好好利用。请留意！"

L.search_kill_distance_point_blank = "受害者是从近处被攻击的。"
L.search_kill_distance_close = "受害者是从不远处被攻击的。"
L.search_kill_distance_far = "受害者是从远处被攻击的。"

L.search_kill_from_front = "受害者是正面中弹的。"
L.search_kill_from_back = "受害者是背面中弹的。"
L.search_kill_from_side = "受害者是侧面中弹的。"

L.search_hitgroup_head = "弹头发现于尸体的头部。"
L.search_hitgroup_chest = "弹头发现于尸体的胸部。"
L.search_hitgroup_stomach = "弹头发现于尸体的胃部。"
L.search_hitgroup_rightarm = "弹头发现于尸体的右臂。"
L.search_hitgroup_leftarm = "弹头发现于尸体的左臂。"
L.search_hitgroup_rightleg = "弹头发现于尸体的右腿。"
L.search_hitgroup_leftleg = "弹头发现于尸体的左腿。"
L.search_hitgroup_gear = "弹头发现于尸体的腰部。"

L.search_policingrole_report_confirm = [[
只有在尸体被确认死亡后，才能召唤公开警察角色到死亡尸体的位置。]]
L.search_policingrole_confirm_disabled_1 = [[
只有公开警察角色才能确认死亡。报告尸体位置来让他们知道！]]
L.search_policingrole_confirm_disabled_2 = [[
只有公开警察角色才能确认死亡。报告尸体位置来让他们知道！
他们确认后，你可以在这里看到尸检。]]
L.search_spec = [[
作为观察者，你能看到尸检的全部信息，但不能与界面交互。]]

L.search_title_words = "受害者遗言"
L.search_title_c4 = "拆弹失误"
L.search_title_dmg_crush = "挤压伤害 ({amount} 生命值)"
L.search_title_dmg_bullet = "枪弹伤害 ({amount} 生命值)"
L.search_title_dmg_fall = "跌落伤害 ({amount} 生命值)"
L.search_title_dmg_boom = "爆炸伤害 ({amount} 生命值)"
L.search_title_dmg_club = "钝器伤害 ({amount} 生命值)"
L.search_title_dmg_drown = "溺水伤害 ({amount} 生命值)"
L.search_title_dmg_stab = "刺伤伤害 ({amount} 生命值)"
L.search_title_dmg_burn = "烧伤伤害 ({amount} 生命值)"
L.search_title_dmg_teleport = "传送伤害 ({amount} 生命值)"
L.search_title_dmg_car = "车祸 ({amount} 生命值)"
L.search_title_dmg_other = "未知伤害 ({amount} 生命值)"
L.search_title_time = "死亡时间"
L.search_title_dna = "DNA样本衰变"
L.search_title_kills = "受害者名单"
L.search_title_eyes = "眼中的倒影"
L.search_title_floor = "犯罪现场的地板"
L.search_title_credits = "{credits} 设备积分"
L.search_title_water = "水位 {level}"
L.search_title_policingrole_report_confirm = "确认死亡"
L.search_title_policingrole_confirm_disabled = "报告尸体位置"
L.search_title_spectator = "你是观察者"

L.target_credits_on_confirm = "确认死亡可获得未使用的积分"
L.target_credits_on_search = "搜索可获得未使用的积分"
L.corpse_hint_no_inspect_details = "只有公开警察角色可以找到这具尸体的信息。"
L.corpse_hint_inspect_limited_details = "只有公共警察角色可以确认这具尸体。"
L.corpse_hint_spectator = "按 [{usekey}] 查看尸体界面"
L.corpse_hint_public_policing_searched = "按 [{usekey}] 查看公共警察角色的搜索结果"

L.label_inspect_confirm_mode = "选择尸体搜索模式"
L.choice_inspect_confirm_mode_0 = "模式 0: 标准 TTT"
L.choice_inspect_confirm_mode_1 = "模式 1: 限制确认"
L.choice_inspect_confirm_mode_2 = "模式 2: 限制搜索"
L.help_inspect_confirm_mode = [[
在这个游戏模式中，有三种不同的尸体搜索/确认模式。选择这个模式对公开警察角色（如侦探）的重要性有很大影响。

模式 0: 这是标准的 TTT 行为。每个人都可以搜索和确认尸体。要取得尸检或从尸体上取得积分，首先必须确认死亡。这使得带商店角色偷偷地偷取积分变得有点困难。然而，想要报告尸体位置以召唤公开警察玩家的无辜玩家也需要先确认。

模式 1: 这种模式通过将确认死亡选项限制为公开警察角色，提升了公开警察角色的重要性。这也意味着在确认死亡之前就可以取得积分和尸检。每个人仍然可以搜索死尸并找到信息，但他们无法宣布找到的信息。

模式 2: 这种模式比模式 1 更严格一些。在这种模式中，普通玩家的搜索能力也被移除了。这意味着向公开警察玩家报告尸体位置现在是获取任何尸体信息的唯一方式。]]

-- 2023-10-19
--L.label_grenade_trajectory_ui = "Grenade trajectory indicator"

-- 2023-10-23
L.label_hud_pulsate_health_enable = "当生命值低于 25% 时，生命条将会开始闪烁"
L.header_hud_elements_customize = "自定义 HUD 元素"
L.help_hud_elements_special_settings = "这些是所使用的 HUD 元素的特殊设置"

-- 2023-10-25
L.help_keyhelp = [[
键位助手是一个向玩家显示相关键位的界面元素，对新玩家特别有帮助。键位分为三种类型：

核心：包含 TTT2 中最重要的键位。不使用它们的话很难体验游戏的全部潜力。
附加：类似核心键位，但并非必要使用。这包含聊天、语音或手电筒等功能。显示这些键位也许会对新玩家有所帮助。
装备：部分装备有自己的键位，这些都显示在此类别中。

当记分板可见时，已禁用的类别仍会显示]]

L.label_keyhelp_show_core = "启用始终显示核心键位"
L.label_keyhelp_show_extra = "启用始终显示额外键位"
L.label_keyhelp_show_equipment = "启用始终显示装备键位"

L.header_interface_keys = "键位助手设置"
L.header_interface_wepswitch = "武器选择界面设置"

L.label_keyhelper_help = "打开游戏模式菜单"
L.label_keyhelper_mutespec = "切换观看语音模式"
L.label_keyhelper_shop = "打开装备商店"
L.label_keyhelper_show_pointer = "显示鼠标指针"
L.label_keyhelper_possess_focus_entity = "附体焦点中的Prop"
L.label_keyhelper_spec_focus_player = "观看焦点中的玩家"
L.label_keyhelper_spec_previous_player = "上一个玩家"
L.label_keyhelper_spec_next_player = "下一个玩家"
L.label_keyhelper_spec_player = "观看随机玩家"
L.label_keyhelper_possession_jump = "Prop：跳跃"
L.label_keyhelper_possession_left = "Prop：向左"
L.label_keyhelper_possession_right = "Prop：向右"
L.label_keyhelper_possession_forward = "Prop：向前"
L.label_keyhelper_possession_backward = "Prop：向后"
L.label_keyhelper_free_roam = "离开对象并自由漫游"
L.label_keyhelper_flashlight = "切换手电筒"
L.label_keyhelper_quickchat = "打开快速聊天"
L.label_keyhelper_voice_global = "全局语音聊天"
L.label_keyhelper_voice_team = "团队语音聊天"
L.label_keyhelper_chat_global = "全局聊天"
L.label_keyhelper_chat_team = "团队聊天"
L.label_keyhelper_show_all = "显示全部"
L.label_keyhelper_disguiser = "切换伪装"
L.label_keyhelper_save_exit = "保存退出"
L.label_keyhelper_spec_third_person = "切换第三人称视图"

-- 2023-10-26
L.item_armor_reinforced = "强化护甲"
L.item_armor_sidebar = "护甲可以保护你免受子弹穿透身体。但不是永久的。"
L.item_disguiser_sidebar = "伪装者不会向其他玩家显示你的名字，从而保护你的身份。"
L.status_speed_name = "移速倍率"
L.status_speed_description_good = "你的移动速度高于普通。物品，装备或效果可能会影响此值。"
L.status_speed_description_bad = "你的移动速度低于普通。物品，装备或效果可能会影响此值。"

L.status_on = "开启"
L.status_off = "关闭"

L.crowbar_help_primary = "攻击"
L.crowbar_help_secondary = "推动玩家"

-- 2023-10-27
L.help_HUD_enable_description = [[
当记分板打开时，一些 HUD 元素（如键位助手或侧边栏）会显示详细信息。可以禁用此功能以减少杂乱。]]
L.label_HUD_enable_description = "打开记分板时启用描述"
L.label_HUD_enable_box_blur = "启用用户界面框背景模糊"

-- 2023-10-28
L.submenu_gameplay_voiceandvolume_title = "声音和音量"
L.header_soundeffect_settings = "声音效果"
L.header_voiceandvolume_settings = "声音和音量设置"

-- 2023-11-06
L.drop_reserve_prevented = "有东西阻止你丢弃备弹。"
L.drop_no_reserve = "你的备弹不足，无法作为弹药箱投放。"
L.drop_no_room_ammo = "你没有地方放置弹药箱！"

-- 2023-11-14
L.hat_deerstalker_name = "侦探帽"

-- 2023-11-16
L.help_prop_spec_dash = [[
Propspec 冲刺是向目标矢量方向的移动。它们可以比正常移动的力度更大。更高的力度也意味着更高的基础值消耗。

该变量是推力的乘数。]]
L.label_spec_prop_dash = "冲刺力倍增器"
L.label_keyhelper_possession_dash = "Prop：向视线方向冲刺"
L.label_keyhelper_weapon_drop = "尽可能丢出所选武器"
L.label_keyhelper_ammo_drop = "将选定武器的弹药从弹夹中取出"

-- 2023-12-07
L.c4_help_primary = "安放C4"
L.c4_help_secondary = "将其放置在墙面上"

-- 2023-12-11
L.magneto_help_primary = "推动实体"
L.magneto_help_secondary = "推动/拾取实体"
L.knife_help_primary = "刺"
L.knife_help_secondary = "投掷小刀"
--L.polter_help_primary = "Fire thumper"
--L.polter_help_secondary = "Charge long range shot"

-- 2023-12-12
--L.newton_help_primary = "Knockback shot"
--L.newton_help_secondary = "Charged knockback shot"

-- 2023-12-13
L.vis_no_pickup = "只有公开警察角色才能捡起显像器"
L.newton_force = "推力"
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
L.beacon_help_pri = "将信标扔在地上"
L.beacon_help_sec = "将信标粘贴到表面"
L.beacon_name = "信标"
L.beacon_desc = [[
将玩家位置广播给信标周围球形范围内的所有人。

用于跟踪地图上难以看到的位置。]]

L.msg_beacon_destroyed = "你的一个信标已被摧毁！"
L.msg_beacon_death = "一个玩家在你的一个信标的附近死亡。"

L.beacon_pickup_disabled = "只有信标的拥有者才能拾起它"
L.beacon_short_desc = "警察角色使用信标在他们周围添加本地透视效果"

-- 2023-12-18
L.entity_pickup_owner_only = "只有拥有者才能捡起这个"

-- 2023-12-18
L.body_confirm_one = "{finder} 确认了 {victim} 的死亡。"
L.body_confirm_more = "{finder} 确认了以下 {count} 人的死亡: {victims}。"

-- 2023-12-19
L.builtin_marker = "内置。"
L.equipmenteditor_desc_builtin = "此装备为内置装备（TTT2自带！）"
L.help_roles_builtin = "此角色为内置角色（TTT2自带！）"
L.header_equipment_info = "装备信息"


-- 2023-12-24
L.submenu_gameplay_accessibility_title = "辅助功能"

L.header_accessibility_settings = "辅助功能设置"

L.label_enable_dynamic_fov = "启用动态 FOV 更改"
L.label_enable_bobbing = "启用视图晃动"
L.label_enable_bobbing_strafe = "在扫射时启用视图晃动"

L.help_enable_dynamic_fov = "根据玩家的速度应用动态 FOV。例如，当玩家在冲刺时，FOV 会增加，以显示速度。"
L.help_enable_bobbing_strafe = "视图晃动是指摄像机在行走、游泳或下落时发生轻微抖动。"
-- 2023-12-20
L.equipmenteditor_desc_damage_scaling = [[将武器的基础伤害值乘以此因子。
对于霰弹枪，这将影响每个弹丸。
对于步枪，这将只影响子弹。
对于鬼怪，这将影响每次"砰"声和最后的爆炸。

0.5 = 造成一半的伤害。
2 = 造成两倍的伤害。

注意：有些武器可能不使用这个值，这会导致这个修饰符无效。]]

-- 2023-12-24
L.binoc_help_reload = "清除目标。"
--L.cl_sb_row_sresult_direct_conf = "Direct confirmation"
--L.cl_sb_row_sresult_pub_police = "Public policing role confirmation"

-- 2024-01-05
L.label_crosshair_thickness_outline_enable = "启用准星轮廓"
L.label_crosshair_outline_high_contrast = "启用轮廓高对比度颜色"
L.label_crosshair_mode = "准星模式"
L.label_crosshair_static_length = "启用静态准星长度"

L.choice_crosshair_mode_0 = "线条和点"
L.choice_crosshair_mode_1 = "仅线条"
L.choice_crosshair_mode_2 = "仅点"

L.help_crosshair_scale_enable = [[
动态准星可根据武器的扩散度缩放准星。扩散度受武器的基本精度影响，并与跳跃和冲刺等外部因素相乘。

如果线的长度保持不变，则只有间隙会随着扩散度的变化而缩放。]]

L.header_weapon_settings = "武器设置"


--L.marker_vision_visible_for_0 = "Visible for you"
--L.marker_vision_visible_for_1 = "Visible for your role"
--L.marker_vision_visible_for_2 = "Visible for your team"
--L.marker_vision_visible_for_3 = "Visible for everyone"

-- 2024-01-27
L.decoy_help_primary = "安放诱饵"
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
