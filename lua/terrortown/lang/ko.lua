local L = LANG.CreateLanguage("ko")

L.__alias = "Korean"

L.lang_name = "Korean (한글)"

-- General text used in various places
L.traitor = "트레이터"
L.detective = "탐정"
L.innocent = "이노센트"
L.last_words = "유언"

L.terrorists = "테러리스트들"
L.spectators = "관전자들"

L.nones = "팀 없음"
L.innocents = "팀 이노센트"
L.traitors = "팀 트레이터"

-- Round status messages
L.round_minplayers = "라운드를 시작하기엔 플레이어가 모자랍니다..."
L.round_voting = "투표 진행중, 라운드 시작을 {num} 초간 유예합니다..."
L.round_begintime = "새 라운드가 {num} 초 후에 시작됩니다."

L.round_traitors_one = "당신이 유일한 트레이터입니다."
L.round_traitors_more = "당신은 트레이터입니다. 동료 이름: {names}"

L.win_time = "제한 시간 도달, 트레이터의 패배입니다."
L.win_traitors = "트레이터가 이겼습니다!"
L.win_innocents = "이노센트가 이겼습니다!"
L.win_nones = "아무도 이기지 못했습니다!"
L.win_showreport = "{num}초 간 라운드 보고서를 살펴보겠습니다."

L.limit_round = "라운드 제한 도달. 다음 맵으로 곧 변경됩니다."
L.limit_time = "시간 제한 도달. 다음 맵으로 곧 변경됩니다."
L.limit_left_session_mode_1 = "{num} 라운드나 {time} 분 후에 맵이 변경됩니다."
--L.limit_left_session_mode_2 = "{time} minutes remaining before the map changes."
--L.limit_left_session_mode_3 = "{num} round(s) remaining before the map changes."

-- Credit awards
L.credit_all = "당신의 활약으로 팀이 {num} 장비 크레딧을 얻었습니다."
L.credit_kill = "{role}를 죽여 {num} 개의 장비 크레딧을 얻었습니다."

-- Karma
L.karma_dmg_full = "당신의 카르마는 {amount} 입니다. 데미지를 최대로 줄 수 있습니다!"
L.karma_dmg_other = "당신의 카르마는 {amount} 입니다. {num}%의 데미지만을 줍니다."

-- Body identification messages
L.body_found = "{finder} 가 {victim}의 시체를 찾았습니다. 그는 {role}"
L.body_found_team = "{finder} 가 {victim}의 시체를 찾았습니다. 그는 {role} ({team})"

-- The {role} in body_found will be replaced by one of the following:
L.body_found_traitor = "트레이터였습니다!"
L.body_found_det = "탐정이었습니다."
L.body_found_inno = "이노센트였습니다."

L.body_call = "{player}가 {victim}의 시체에 탐정을 불렀습니다!"
L.body_call_error = "탐정을 부르기 전에 이 사람의 사망을 확정해야 합니다!"

L.body_burning = "아이쿠! 이 시체는 불에 탔습니다!"
L.body_credits = "당신은 {num} 개의 장비 크레딧을 시체에서 찾았습니다!"

-- Menus and windows
L.close = "닫기"
L.cancel = "취소"

-- For navigation buttons
L.next = "다음"
L.prev = "이전"

-- Equipment buying menu
L.equip_title = "장비"
L.equip_tabtitle = "장비 주문"

L.equip_status = "주문 상태"
L.equip_cost = "{num}개의 크레딧이 남았습니다."
L.equip_help_cost = "어떤 장비 종류든 구매할때 1개의 크레딧을 소모합니다."

L.equip_help_carry = "인벤토리에 자리가 있을때만 구매할 수 있습니다."
L.equip_carry = "이 장비를 착용 할 수 있습니다."
L.equip_carry_own = "이미 이 장비를 착용하고 있습니다."
L.equip_carry_slot = "이 장비를 위한 {slot} 슬롯에 이미 장비가 있습니다."
L.equip_carry_minplayers = "이 장비를 사용하기 위한 서버 플레이어 수가 부족합니다."

L.equip_help_stock = "특정 품목은 한 라운드당 한개만 구매할 수 있습니다."
L.equip_stock_deny = "이 아이템은 재고가 없습니다."
L.equip_stock_ok = "이 아이템은 재고가 있습니다."

L.equip_custom = "이 서버에서 추가한 커스텀 아이템입니다."

L.equip_spec_name = "이름"
L.equip_spec_type = "타입"
L.equip_spec_desc = "설명"

L.equip_confirm = "장비 사기"

-- Disguiser tab in equipment menu
L.disg_name = "변장 도구"
L.disg_menutitle = "변장 제어"
L.disg_not_owned = "당신은 변장 도구를 가지고 있지 않습니다!"
L.disg_enable = "변장 활성화"

L.disg_help1 = "변장이 활성화 되있는 도중에는, 다른 사람이 당신의 이름과 체력, 카르마를 볼 수 없습니다. 또한, 탐정의 레이더에 포착되지 않습니다."
L.disg_help2 = "넘패드 엔터키를 눌러 매뉴를 열지 않고 바로 변장을 활성화 할 수 있습니다. 'ttt_toggle_disguise'를 바인드하여 다른 키로 변경할 수 있습니다."

-- Radar tab in equipment menu
L.radar_name = "레이더"
L.radar_menutitle = "레이더 제어"
L.radar_not_owned = "당신은 레이더를 가지고 있지 않습니다!"
L.radar_scan = "스캔 시작"
L.radar_auto = "자동 스캔 활성화"
L.radar_help = "상대의 위치가 {num} 초 동안 보여집니다. 재충전 후 사용 가능합니다."
L.radar_charging = "레이더가 아직 충전되지 않았습니다!"

-- Transfer tab in equipment menu
L.xfer_name = "송금"
L.xfer_menutitle = "크레딧 송금"
L.xfer_send = "크레딧 송금하기"

L.xfer_no_recip = "송금 받는 사람이 불분명합니다. 송금이 중단되었습니다."
L.xfer_no_credits = "송금하기엔 크레딧이 부족합니다."
L.xfer_success = "{player} 로 송금이 완료되었습니다."
L.xfer_received = "{player}가 {num} 개의 크레딧을 당신에게 송금하였습니다."

-- Radio tab in equipment menu
L.radio_name = "라디오"

-- Radio soundboard buttons
L.radio_button_scream = "비명"
L.radio_button_expl = "폭발"
L.radio_button_pistol = "권총 사격"
L.radio_button_m16 = "M16 사격"
L.radio_button_deagle = "Deagle 사격"
L.radio_button_mac10 = "MAC10 사격"
L.radio_button_shotgun = "샷건 사격"
L.radio_button_rifle = "라이플 사격"
L.radio_button_huge = "H.U.G.E 점사 사격"
L.radio_button_c4 = "C4 소리"
L.radio_button_burn = "타는 소리"
L.radio_button_steps = "발소리"

-- Intro screen shown after joining
L.intro_help = "게임에 새로 오셨다면, F1을 눌러 도움말을 참조하세요!"

-- Radiocommands/quickchat
L.quick_title = "퀵쳇 키"

L.quick_yes = "좋아요."
L.quick_no = "아니요."
L.quick_help = "도와줘!"
L.quick_imwith = "{player}와 있습니다."
L.quick_see = "{player}를 보고 있습니다."
L.quick_suspect = "{player} 가 수상하게 행동합니다."
L.quick_traitor = "{player} 가 트레이터입니다!"
L.quick_inno = "{player} 는 이노센트입니다."
L.quick_check = "누구 살아있는 사람?"

-- {player} in the quickchat text normally becomes a player nickname, but can
-- also be one of the below.  Keep these lowercase.
L.quick_nobody = "알 수 없음"
L.quick_disg = "누군가 변장 중"
L.quick_corpse = "신원 미상의 시체"
L.quick_corpse_id = "{player}의 시체"

-- Scoreboard
L.sb_playing = "당신이 플레이 중인 곳은..."
L.sb_mapchange_mode_0 = "세션 제한이 비활성화 되었습니다."
L.sb_mapchange_mode_1 = "{num}라운드 또는 {time} 분 후에 맵이 변경됩니다."
--L.sb_mapchange_mode_2 = "Map changes in {time}"
--L.sb_mapchange_mode_3 = "Map changes in {num} rounds"

L.sb_mia = "실종"
L.sb_confirmed = "사망 확인"

L.sb_ping = "핑"
L.sb_deaths = "데스"
L.sb_score = "점수"
L.sb_karma = "카르마"

L.sb_info_help = "이 플레이어의 시체를 검안하면 여기서 결과를 볼 수 있습니다."

L.sb_tag_friend = "친구"
L.sb_tag_susp = "용의자"
L.sb_tag_avoid = "회피"
L.sb_tag_kill = "죽일 것"
L.sb_tag_miss = "실종"

-- Equipment actions, like buying and dropping
L.buy_no_stock = "이 무기는 재고가 없습니다. 이미 이 라운드에 구매했습니다."
L.buy_pending = "주문이 대기중입니다. 받을 때 까지 기다리세요."
L.buy_received = "특별한 아이템을 받았습니다."

L.drop_no_room = "무기를 버리기에는 공간이 부족합니다!"

L.disg_turned_on = "변장 활성화!"
L.disg_turned_off = "변장 비활성화."

-- Equipment item descriptions
L.item_passive = "패시브 아이템"
L.item_active = "엑티브 아이템"
L.item_weapon = "무기"

L.item_armor = "방탄복"
L.item_armor_desc = [[
탄, 불, 폭발 데미지를 줄여줍니다. 피격마다 방어력이 깎입니다.

여러번 구매 가능하며, 일정 수치 이상일 경우 방어구 효과가 더 강해집니다.]]

L.item_radar = "레이더"
L.item_radar_desc = [[
생명 신호를 스캔해줍니다.

구매 하자마자 자동 스캔을 진행합니다. 레이더 설정에서 이를 바꿀 수 있습니다.]]

L.item_disg = "변장 도구"
L.item_disg_desc = [[
키면, 특정성을 숨겨줍니다. 피해자가 마지막으로 본 사람이 되는것 또한 막아줍니다.

변장 도구 탭이나 넘패드 엔터로 활성화 할 수 있습니다.]]

-- C4
L.c4_disarm_warn = "당신이 설치한 C4가 해체되었습니다."
L.c4_armed = "C4를 성공적으로 활성화 했습니다."
L.c4_disarmed = "C4 해체를 성공했습니다."
L.c4_no_room = "C4를 더 이상 가지고 다닐 수 없습니다."

L.c4_desc = "강력한 시한 폭탄."

L.c4_arm = "C4 활성화"
L.c4_arm_timer = "타이머"
L.c4_arm_seconds = "폭발까지 남은 시간:"
L.c4_arm_attempts = "해체 시도 중, 6개중 {num} 개의 선은 자르는 즉시 폭발합니다."

L.c4_remove_title = "삭제"
L.c4_remove_pickup = "C4 줍기"
L.c4_remove_destroy1 = "C4 파괴"
L.c4_remove_destroy2 = "확인: 파괴"

L.c4_disarm = "C4 해체"
L.c4_disarm_cut = "{num} 선을 클릭하여 자르기"

L.c4_disarm_t = "선을 잘라 폭탄을 해체합니다. 당신이 트레이터라면, 모든 선이 안전한 선입니다. 이노센트가 쉽게 해체 못할걸요!"
L.c4_disarm_owned = "선을 잘라 폭탄을 해체합니다. 당신의 폭탄이라면, 어느 선을 잘라도 해체가 됩니다."
L.c4_disarm_other = "선을 잘라 폭탄을 해체하십시오. 잘못된 선을 자르면 터집니다!"

L.c4_status_armed = "활성화"
L.c4_status_disarmed = "비활성화"

-- Visualizer
L.vis_name = "비쥬얼라이저"

L.vis_desc = [[
범죄 현장 분석기입니다.

희생자가 어떻게 죽었는지 보여줍니다, 총상으로 죽었을때만 알려줍니다.]]

-- Decoy
L.decoy_name = "디코이"
L.decoy_broken = "당신의 디코이가 파괴되었습니다!"

L.decoy_short_desc = "이 디코이는 다른 팀에게 가짜 레이더 신호를 방출합니다."
L.decoy_pickup_wrong_team = "다른 팀의 디코이를 주울 수 없습니다"

L.decoy_desc = [[
다른 팀에게 가짜 레이더 신호를 보냅니다, 탐정이 당신의 DNA를 스캔한다면, 당신이 아닌 디코이를 추적합니다.]]

-- Defuser
L.defuser_name = "해체 장치"

L.defuser_desc = [[
C4를 즉시 해체합니다.

무한정 사용 가능합니다. 이 장치를 가지고 있으면 C4를 더 빠르게 찾을 수 있기도 합니다.]]

-- Flare gun
L.flare_name = "플레어 건"

L.flare_desc = [[
남들이 조사하지 못하게 시체를 태워버립니다.

시체를 태우면 이상한 소리가 납니다.]]

-- Health station
L.hstation_name = "치료 스테이션"

L.hstation_broken = "당신의 치료 스테이션이 파괴되었습니다!"

L.hstation_desc = [[
다른 사람들이 치료할 수 있게 바닥에 설치합니다.

낮은 충전속도. 그러나 아무나 사용할 수 있고, 피해를 입어 파괴될 수 있으며, 사용한 사람들의 DNA를 확보 할 수 있습니다.]]

-- Knife
L.knife_name = "칼"
L.knife_thrown = "칼 던지기"

L.knife_desc = [[
부상당한 타겟을 즉시 처치합니다. 한 번만 사용 할 수 있습니다.

우클릭으로 던질 수 있습니다.]]

-- Poltergeist
L.polter_desc = [[
물체에 설치해 물체를 격렬하게 밀어냅니다.

에너지 폭발은 근방에 있는 사람들에게 데미지를 줍니다.]]

-- Radio
L.radio_broken = "라디오가 파괴되었습니다!"

-- Silenced pistol
L.sipistol_name = "소음 권총"

L.sipistol_desc = [[
저소음 권총입니다. 일반 권총 탄약을 사용합니다.

피해자는 사망시 소리를 내지 않습니다.]]

-- Newton launcher
L.newton_name = "뉴턴 런쳐"

L.newton_desc = [[
거리가 좀 되는 곳에서 안전하게 사람을 밀칠 수 있는 런쳐입니다.

무한 탄약입니다. 그러나 발사 속도가 느립니다.]]

-- Binoculars
L.binoc_name = "망원경"

L.binoc_desc = [[
시체에 조준하여 먼 거리에서 신원을 확인 할 수 있는 아이템입니다.

무한정 사용 가능합니다만, 신원을 확인하는데 시간이 좀 걸립니다.]]

-- UMP
L.ump_desc = [[
실험적 SMG입니다. 맞은 타겟은 방향 감각을 상실합니다.

SMG 탄약을 사용합니다.]]

-- DNA scanner
L.dna_name = "DNA 스캐너"
L.dna_notfound = "DNA 샘플이 발견되지 않았습니다."
L.dna_limit = "샘플 보관함이 꽉찼습니다. 새 샘플을 추가하려면, 오래된 샘플을 제거하세요."
L.dna_decayed = "살해자의 DNA 샘플이 부식되었습니다."
L.dna_killer = "시체에서 살해자의 DNA 샘플을 확보했습니다!"
L.dna_duplicate = "일치합니다! 이 DNA 샘플이 이미 스캐너에 저장되어 있습니다."
L.dna_no_killer = "DNA를 읽어들일 수 없습니다. (살해자가 접속종료 했을지도?)."
L.dna_armed = "이 폭탄은 활성화 상태입니다! 먼저 해체하세요!"
L.dna_object = "이 물체의 마지막 사용자의 DNA를 추적합니다."
L.dna_gone = "DNA가 감지되지 않았습니다."

L.dna_desc = [[
DNA 샘플을 수집하여 DNA의 주인을 찾을 수 있습니다.

갓 죽은 시체에서 살해자의 DNA를 추출하고, 추적하세요.]]

-- Magneto stick
L.magnet_name = "자석봉"

-- Grenades and misc
L.grenade_smoke = "연막탄"
L.grenade_fire = "소이탄"

L.unarmed_name = "수납"
L.crowbar_name = "빠루"
L.pistol_name = "권총"
L.rifle_name = "라이플"
L.shotgun_name = "샷건"

-- Teleporter
L.tele_name = "순간이동기"
L.tele_failed = "순간이동 실패."
L.tele_marked = "순간이동 위치 지정됨."

L.tele_no_ground = "바닥에 서 있지 않으면 순간이동 할 수 없습니다!"
L.tele_no_crouch = "앉은 상태로는 순간이동 할 수 없습니다!"
L.tele_no_mark = "순간이동 위치가 지정되지 않았습니다. 사용하기 전에 순간이동 위치를 먼저 지정하세요."

L.tele_no_mark_ground = "바닥에 서 있지 않은 상태에서는 위치를 지정 할 수 없습니다!"
L.tele_no_mark_crouch = "앉은 상태로는 위치를 지정 할 수 없습니다!"

L.tele_help_pri = "지정한 위치로 순간이동"
L.tele_help_sec = "현재 지점 지정하기"

L.tele_desc = [[
이전에 지정한 곳으로 순간이동합니다.

순간이동기는 사용 횟수에 제한이 있으며, 사용시 소리를 냅니다.]]

-- Ammo names, shown when picked up
L.ammo_pistol = "9mm 탄약"

L.ammo_smg1 = "SMG 탄약"
L.ammo_buckshot = "샷건 탄약"
L.ammo_357 = "라이플 탄약"
L.ammo_alyxgun = "Deagle 탄약"
L.ammo_ar2altfire = "플레어 탄약"
L.ammo_gravity = "폴터가이스트 탄약"

-- Round status
L.round_wait = "대기 중"
L.round_prep = "준비 중"
L.round_active = "진행 중"
L.round_post = "라운드 끝"

-- Health, ammo and time area
L.overtime = "오버타임"
L.hastemode = "가속 모드"

-- TargetID health status
L.hp_healthy = "건강함"
L.hp_hurt = "약한 상처"
L.hp_wounded = "중간 상처"
L.hp_badwnd = "큰 상처"
L.hp_death = "죽기 직전"

-- TargetID Karma status
L.karma_max = "평판 좋음"
L.karma_high = "매정함"
L.karma_med = "호전적임"
L.karma_low = "위험함"
L.karma_min = "악랄한"

-- TargetID misc
L.corpse = "시체"
L.corpse_hint = "[{usekey}] 키를 눌러 수색하고, 시체를 확인하세요. [{walkkey} + {usekey}]키로 알리지 않고 시체를 확인 할 수 있습니다."

L.target_disg = "(변장함)"
L.target_unid = "신원 미상의 시체"
L.target_unknown = "테러리스트입니다."

-- HUD buttons with hand icons that only some roles can see and use
L.tbut_single = "일회용"
L.tbut_reuse = "재사용 가능"
L.tbut_retime = "{num}초 후에 재사용 가능"
L.tbut_help = "[{usekey}]를 눌러 활성화"

-- Spectator muting of living/dead
L.mute_living = "살아있는 플레이어 음소거"
L.mute_specs = "관전자 음소거"
L.mute_all = "전체 음소거"
L.mute_off = "음소거 없음"

-- Spectators and prop possession
L.punch_title = "PUNCH-O-METER"
L.punch_bonus = "당신의 낮은 카르마로 인해 Punch-O-Meter의 게이지가 {num}로 제한되었습니다."
L.punch_malus = "당신의 높은 카르마로 인해 Punch-O-Meter의 게이지간 {num}로 제한되었습니다!"

-- Info popups shown when the round starts
L.info_popup_innocent = [[
당신은 이노센트입니다! 그러나 이 중에 트레이터가 있습니다....
누구를 믿어야 하고, 누구에게 총알을 박아넣어야 할까요?

항상 경계하고, 동료들과 함께하여 이곳에서 살아나가세요!]]

L.info_popup_detective = [[
당신은 탐정입니다! 테러리스트 본부가 트레이터를 찾기 위해 특별한 장비를 주었습니다.
장비들을 사용하여 이노센트들을 생존시키세요! 하지만 조심하세요,
트레이터는 당신을 가장 먼저 죽이려고 할겁니다!

{menukey}키를 눌러 장비를 구매하세요!]]

L.info_popup_traitor_alone = [[
당신은 트레이터입니다! 이번 라운드엔 동료 트레이터들이 없군요.

다른 사람들을 모두 죽여 승리하세요!

{menukey}키를 눌러 장비를 구매하세요!]]

L.info_popup_traitor = [[
당신은 트레이터입니다! 다른 트레이터들과 협력해 모두를 죽이세요!
그러니 조심하세요... 당신의 반역이 들킬 수도 있습니다.

당신의 동료 목록:
{traitorlist}

{menukey}키를 눌러 장비를 구매하세요!]]

-- Various other text
L.name_kick = "라운드 도중에 이름을 바꿔 킥 되었습니다."

L.idle_popup = [[
당신은 {num} 초 동안 움직이지 않아 관전모드로 넘어갔습니다. 관전모드에 있는 한, 이후의 새 라운드에서도 스폰하지 않습니다.

언제든 관전모드를 {helpkey} 키를 눌러, 관전 모드 설정을 눌러 풀 수 있습니다. 또한, 지금 당장 풀지 선택 할 수 있습니다.]]

L.idle_popup_close = "아무것도 하지 않기"
L.idle_popup_off = "당장 관전 모드 풀기"

L.idle_warning = "경고: 잠수 중이신것 같군요, 활동을 하지 않을 시 관전 모드로 넘어갑니다!"

L.spec_mode_warning = "당신은 현재 관전모드 상태입니다. 이 상태를 해제하려면, F1키를 눌러 게임플레이 항목으로 이동 후, 관전모드를 해제하시면 됩니다."

-- Tips panel
L.tips_panel_title = "팁"
L.tips_panel_tip = "팁:"

-- Tip texts
--L.tip1 = "Traitors can search a corpse silently, without confirming the death, by holding {walkkey} and pressing {usekey} on the corpse."

--L.tip2 = "Arming a C4 explosive with a longer timer will increase the number of wires that cause it to explode instantly when an innocent attempts to disarm it. It will also beep softer and less often."

--L.tip3 = "Detectives can search a corpse to find who is 'reflected in its eyes'. This is the last person the dead guy saw. That does not have to be the killer if they were shot in the back."

--L.tip4 = "No one will know you have died until they find your dead body and identify you by searching it."

--L.tip5 = "When a Traitor kills a Detective, they instantly receive a credit reward."

--L.tip6 = "When a Traitor dies, all Detectives are rewarded equipment credits."

--L.tip7 = "When the Traitors have made significant progress in killing innocents, they will receive an equipment credit as reward."

--L.tip8 = "Shopping roles can collect unspent equipment credits from the dead bodies of other shopping roles such as Traitors and Detectives."

--L.tip9 = "The Poltergeist can turn any physics object into a deadly projectile. Each punch is accompanied by a blast of energy hurting anyone nearby."

--L.tip10 = "As a shopping role, keep in mind you are rewarded extra equipment credits if you and your comrades perform well. Make sure you remember to spend them!"

--L.tip11 = "The Detectives' DNA Scanner can be used to gather DNA samples from weapons and items and then scan to find the location of the player who used them. Useful when you can get a sample from a corpse or a disarmed C4!"

--L.tip12 = "When you are close to someone you kill, some of your DNA is left on the corpse. This DNA can be used with a Detective's DNA Scanner to find your current location. Better hide the body after you knife someone!"

--L.tip13 = "The further you are away from someone you kill, the faster your DNA sample on their body will decay."

--L.tip14 = "Are you going sniping? Consider buying the Disguiser. If you miss a shot, run away to a safe spot, disable the Disguiser, and no one will know it was you who was shooting at them."

--L.tip15 = "If you have a Teleporter, it can help you escape when chased, and allows you to quickly travel across a big map. Make sure you always have a safe position marked."

--L.tip16 = "Are the innocents all grouped up and hard to pick off? Consider trying out the Radio to play sounds of C4 or a firefight to lead some of them away."

--L.tip17 = "Using the Radio, you can play sounds by looking at its placement marker after the radio has been placed. Queue up multiple sounds by clicking multiple buttons in the order you want them."

--L.tip18 = "As Detective, if you have leftover credits you could give a trusted Innocent a Defuser. Then you can spend your time doing the serious investigative work and leave the risky bomb defusal to them."

--L.tip19 = "The Detectives' Binoculars allow long-range searching and identifying of corpses. Bad news if the Traitors were hoping to use a corpse as bait. Of course, while using the Binoculars a Detective is unarmed and distracted..."

--L.tip20 = "The Detectives' Health Station lets wounded players recover. Of course, those wounded people could be Traitors..."

--L.tip21 = "The Health Station records a DNA sample of everyone who uses it. Detectives can use this with the DNA Scanner to find out who has been healing up."

--L.tip22 = "Unlike weapons and C4, the Radio equipment for Traitors does not contain a DNA sample of the person who planted it. Don't worry about Detectives finding it and blowing your cover."

--L.tip23 = "Press {helpkey} to view a short tutorial or modify some TTT-specific settings."

--L.tip24 = "When a Detective searches a body, the result is available to all players via the scoreboard by clicking on the name of the dead person."

--L.tip25 = "In the scoreboard, a magnifying glass icon next to someone's name indicates you have search information about that person. If the icon is bright, the data comes from a Detective and may contain additional information."

--L.tip26 = "Corpses with a magnifying glass below the nickname have been searched by a Detective and their results are available to all players via the scoreboard."

--L.tip27 = "Spectators can press {mutekey} to cycle through muting other spectators or living players."

--L.tip28 = "You can switch to a different language at any time in the Settings menu by pressing {helpkey}."

--L.tip29 = "Quickchat or 'radio' commands can be used by pressing {zoomkey}."

--L.tip30 = "The Crowbar's secondary fire will push other players."

--L.tip31 = "Firing through the ironsights of a weapon will slightly increase your accuracy and decrease recoil. Crouching does not."

--L.tip32 = "Smoke grenades are effective indoors, especially for creating confusion in crowded rooms."

--L.tip33 = "As Traitor, remember you can carry dead bodies and hide them from the prying eyes of the innocent and their Detectives."

--L.tip34 = "On the scoreboard, click the name of a living player and you can select a tag for them such as 'suspect' or 'friend'. This tag will show up if you have them under your crosshair."

--L.tip35 = "Many of the placeable equipment items (such as C4, Radio) can be stuck on walls using secondary fire."

--L.tip36 = "C4 that explodes due to a mistake in disarming it has a smaller explosion than C4 that reaches zero on its timer."

--L.tip37 = "If it says 'HASTE MODE' above the round timer, the round will at first be only a few minutes long, but with every death the available time increases. This mode puts the pressure on the traitors to keep things moving."

-- Round report
L.report_title = "라운드 보고"

-- Tabs
L.report_tab_hilite = "하이라이트"
L.report_tab_hilite_tip = "라운드 하이라이트"
L.report_tab_events = "이벤트"
L.report_tab_events_tip = "이번 라운드에 일어난 이벤트 로그입니다"
L.report_tab_scores = "점수"
L.report_tab_scores_tip = "이 라운드에서 각 플레이어들이 얻은 점수입니다."

-- Event log saving
L.report_save = "로그 .txt로 저장"
L.report_save_tip = "이벤트 로그를 텍스트 파일로 저장합니다."
L.report_save_error = "저장 할 이벤트 로그가 없습니다."
L.report_save_result = "이벤트 로그가 이 위치에 저장되었습니다. :"

-- Columns
L.col_time = "시간"
L.col_event = "이벤트"
L.col_player = "플레이어"
L.col_roles = "역할"
L.col_teams = "팀"
L.col_kills1 = "킬"
L.col_kills2 = "팀 킬"
L.col_points = "점수"
L.col_team = "팀 보너스"
L.col_total = "총 점수"

-- Awards/highlights
L.aw_sui1_title = "자살 교단 교주"
L.aw_sui1_text = "다른 교단원들에게 어떻게 자살하는지 보여줬습니다."

L.aw_sui2_title = "우울증"
L.aw_sui2_text = "유일하게 자살 한 사람입니다."

L.aw_exp1_title = "폭발 수석 조교"
L.aw_exp1_text = "폭발에 대한 논문으로 학계의 모범이 되었습니다. {num}명의 피실험자가 도움을 주었습니다."

L.aw_exp2_title = "현장 연구가"
L.aw_exp2_text = "폭발 저항성을 실험했습니다. 그렇게 저항력이 크지는 않았군요."

L.aw_fst1_title = "퍼스트 블러드"
L.aw_fst1_text = "트레이터의 손에 죽은 첫 이노센트였습니다."

L.aw_fst2_title = "멍청한 퍼스트 블러드"
L.aw_fst2_text = "첫 킬을 동료 트레이터로 시작했습니다. 매우 잘했습니다."

L.aw_fst3_title = "퍼스트 트롤"
L.aw_fst3_text = "첫 킬이었습니다. 같은 이노센트 동료라는게 아쉽네요."

L.aw_fst4_title = "첫 한 방"
L.aw_fst4_text = "이노센트로서의 첫 킬을 트레이터로 시작했습니다."

L.aw_all1_title = "죽음은 공평하다"
L.aw_all1_text = "모든 이노센트의 킬이 이 이노센트로부터 나왔습니다."

L.aw_all2_title = "고독한 늑대"
L.aw_all2_text = "모든 트레이터의 킬이 이 트레이터로부터 나왔습니다."

L.aw_nkt1_title = "한 놈 잡았어!"
L.aw_nkt1_text = "한 이노센트를 죽였습니다. 쩌네요!"

L.aw_nkt2_title = "두 사람을 위한 총알"
L.aw_nkt2_text = "첫 살해가 운이 좋았음을 보여주기 위해 또 다른 사람을 죽여버렸습니다."

L.aw_nkt3_title = "연쇄 트레이터"
L.aw_nkt3_text = "오늘 세 무고한 테러리스트가 죽었습니다."

L.aw_nkt4_title = "순한 양 처럼 생긴 늑대 중에서도 최고의 늑대 "
L.aw_nkt4_text = "저녁으로 이노센트를 먹습니다. {num}명의 이노센트를요."

L.aw_nkt5_title = "카운터-테러리스트 협력자"
L.aw_nkt5_text = "킬마다 보수를 받습니다. 또 다른 럭셔리 요트를 사겠군요."

L.aw_nki1_title = "이것도 배신해 보시지"
L.aw_nki1_text = "트레이터를 찾아, 쐈습니다. 간단하지요?"

L.aw_nki2_title = "정의 분대에 지원함"
L.aw_nki2_text = "두 명의 트레이터를 저 멀리 보내버렸습니다."

L.aw_nki3_title = "트레이터는 트레이터양의 꿈을 꾸는가?"
L.aw_nki3_text = "세 명의 트레이터에게 안식을 주었습니다."

L.aw_nki4_title = "내부 감사 직원"
L.aw_nki4_text = "킬마다 보수를 받습니다. 5번째 수영장도 지을 수 있겠군요."

L.aw_fal1_title = "아니요 본드씨, 떨어질거라고 생각합니다."
L.aw_fal1_text = "누군가를 높은 곳에서 떨어트렸습니다."

L.aw_fal2_title = "바닥에 놓인"
L.aw_fal2_text = "높은 고도에서 시체를 바닥에 떨궈버렸습니다."

L.aw_fal3_title = "인간 운석"
L.aw_fal3_text = "높은 곳에서 떨어져, 누군가를 깔아뭉갰습니다."

L.aw_hed1_title = "효율성"
L.aw_hed1_text = "헤드샷의 재미를 깨달았습니다. {num} 명의 머리를 땄군요."

L.aw_hed2_title = "신경외과"
L.aw_hed2_text = "정밀 검사를 위해 {num} 명의 머리를 땄습니다."

L.aw_hed3_title = "게임이 날 이렇게 만들었다."
L.aw_hed3_text = "사람을 죽이기 위한 훈련을 하였습니다. {num} 명이 머리에 맞았군요."

L.aw_cbr1_title = "휙 휙 휙"
L.aw_cbr1_text = "잔인하게 빠루를 휘둘러 죽였습니다. {num} 명의 희생자가 발견되었습니다."

L.aw_cbr2_title = "프리맨"
L.aw_cbr2_text = "{num} 명의 뇌가 묻은 빠루를 가지고 있습니다."

L.aw_pst1_title = "짜증나는 작은 놈"
L.aw_pst1_text = "{num} 킬을 권총으로 해냈습니다. 그 다음 누군가를 껴안고 죽었군요."

L.aw_pst2_title = "저구경 학살"
L.aw_pst2_text = "{num} 명을 권총으로 죽였습니다. 거의 소부대 수준인데, 아마도 권총에 산탄총을 장착하지 않았나 싶습니다."

L.aw_sgn1_title = "쉬움"
L.aw_sgn1_text = "아픈곳을 정확하게 샷건으로 찝었습니다. {num} 명을 죽였습니다."

L.aw_sgn2_title = "수천개의 작은 펠릿이"
L.aw_sgn2_text = "벅샷을 그렇게 좋아하지 않아서 멀리 쏴버렸습니다. {num} 명의 수신자들은 이를 매우 좋아하지 않았습니다."

L.aw_rfl1_title = "포인트 앤 클릭"
L.aw_rfl1_text = "{num} 킬을 라이플로 해냈습니다."

L.aw_rfl2_title = "니 머리가 여기서도 보인다고"
L.aw_rfl2_text = "총기를 잘 알게 되었습니다. {num} 명의 희생자도 잘 알겠군요."

L.aw_dgl1_title = "작은 소총처럼"
L.aw_dgl1_text = "데저트 이글로 {num} 명을 죽였습니다."

L.aw_dgl2_title = "이글 전문가"
L.aw_dgl2_text = "{num} 명을 데저트 이글로 끝장냈습니다."

L.aw_mac1_title = "기도하고, 쏘세요"
L.aw_mac1_text = "{num}명을 MAC10으로 죽였습니다. 총알을 얼마나 썼는진 물어보지 마세요."

L.aw_mac2_title = "맥 앤 치즈"
L.aw_mac2_text = "만약 MAC10을 두개 든다면 몆명이나 죽을까요. {num}곱하기 2?"

L.aw_sip1_title = "조용히 해"
L.aw_sip1_text = "{num}명을 닥치게 만들었습니다."

L.aw_sip2_title = "사일런트 어쎄신"
L.aw_sip2_text = "자기가 죽은지도 모르는 {num} 명을 죽였습니다."

L.aw_knf1_title = "칼은 너를 안다"
L.aw_knf1_text = "인터넷에서 누군가의 얼굴을 찔러버렸습니다."

L.aw_knf2_title = "어디서 그딴걸 가져온거야?"
L.aw_knf2_text = "트레이터는 아니지만, 칼로 누군가를 죽였습니다."

L.aw_knf3_title = "칼잡이시구만?"
L.aw_knf3_text = "{num} 개의 칼이 놓여있었습니다. 불행하게도, 모두 사용되었군요."

L.aw_knf4_title = "가장 날카로운 사람"
L.aw_knf4_text = "{num} 명을 칼로 죽였습니다. 어떻게 죽였는진 물어보지 마세요."

L.aw_flg1_title = "구조를 위해서"
L.aw_flg1_text = "{num}개의 시체를 표시하기 위해서 플레어를 사용했습니다."

L.aw_flg2_title = "플레어는 불을 뜻해"
L.aw_flg2_text = "{num} 명에게 인화성 옷을 입는것은 위험하다는걸 알려줬습니다."

L.aw_hug1_title = "매.우.큰 난사"
L.aw_hug1_text = "H.U.G.E를 난사했습니다.어떻게 {num}명을 죽였네요."

L.aw_hug2_title = "환자 매개 변수"
L.aw_hug2_text = "계속 쏘기만 했습니다, {num} 명의 환자를 만들었군요."

L.aw_msx1_title = "퓻 퓻 퓻"
L.aw_msx1_text = "{num} 킬을 M16으로 해냈습니다."

L.aw_msx2_title = "중거리의 악마"
L.aw_msx2_text = "M16으로 죽이는 법을 깨우쳤군요. {num} 킬을 달성했습니다."

L.aw_tkl1_title = "실수였다고"
L.aw_tkl1_text = "친구를 조준 중에 손가락이 미끄러졌군요."

L.aw_tkl2_title = "두 번의 실수"
L.aw_tkl2_text = "트레이터를 두명이나 잡은 줄 알았나봐요. 사실 그게 아닌데 말이죠."

L.aw_tkl3_title = "카르마는 지속된다"
L.aw_tkl3_text = "두명의 동료로는 모자랐나보죠? 셋이 럭키 넘버였나 봅니다."

L.aw_tkl4_title = "팀킬러"
L.aw_tkl4_text = "팀의 거의 모든 사람을 죽였습니다."

L.aw_tkl5_title = "역할극"
L.aw_tkl5_text = "미친놈을 연기했나보죠? 진심으로 그게 아니면 어떻게 이렇게 많이 죽일수가 있었겠습니까?"

L.aw_tkl6_title = "멍청이"
L.aw_tkl6_text = "게임이 어떻게 돌아가는지도 몰라서 팀의 절반을 죽여버렸습니다."

L.aw_tkl7_title = "촌뜨기"
L.aw_tkl7_text = "팀의 절반을 죽임으로써 양을 지켜냈습니다."

L.aw_brn1_title = "할머니가 하던 것 처럼"
L.aw_brn1_text = "몆 명을 구워버렸습니다."

L.aw_brn2_title = "방화광"
L.aw_brn2_text = "희생자중 하나를 불태우고 쪼개는 소리가 들렸습니다."

L.aw_brn3_title = "피로스의 화형"
L.aw_brn3_text = "모두 불태웠지만, 소이탄이 다 떨어졌습니다. 이제 어떻게 하라는거야?"

L.aw_fnd1_title = "검시관"
L.aw_fnd1_text = "{num} 개의 시체를 찾았습니다."

L.aw_fnd2_title = "포켓몬"
L.aw_fnd2_text = "{num} 개의 시체를 도감에 추가했습니다."

L.aw_fnd3_title = "죽음의 향기"
L.aw_fnd3_text = "자꾸 시체를 밟고 넘어지는군요. {num} 번이나 말입니다."

L.aw_crd1_title = "재활용"
L.aw_crd1_text = "{num} 개의 크레딧을 시체에서 챙겼습니다."

L.aw_tod1_title = "피로스의 승리"
L.aw_tod1_text = "라운드 승리를 얼마 남겨두지 않고 사망했습니다."

L.aw_tod2_title = "이 게임 존나 싫어"
L.aw_tod2_text = "게임 시작 직후 사살당했습니다."

-- New and modified pieces of text are placed below this point, marked with the
-- version in which they were added, to make updating translations easier.

-- v24
L.drop_no_ammo = "탄약 상자를 떨어트리기엔 무기에 탄약이 부족합니다."

-- 2015-05-25
L.hat_retrieve = "탐정의 모자를 주웠습니다."

-- 2017-09-03
L.sb_sortby = "정렬 :"

-- 2018-07-24
L.equip_tooltip_main = "장비 메뉴"
L.equip_tooltip_radar = "레이더 설정"
L.equip_tooltip_disguise = "변장 기구 설정"
L.equip_tooltip_radio = "라디오 설정"
L.equip_tooltip_xfer = "크레딧 송금"
L.equip_tooltip_reroll = "장비 재배치"

L.confgrenade_name = "혼란 수류탄"
L.polter_name = "폴터가이스트"
L.stungun_name = "UMP 프로토타입"

L.knife_instant = "즉사"

L.binoc_zoom_level = "줌 단계"
L.binoc_body = "시체 발견"

L.idle_popup_title = "기본"

-- 2019-01-31
L.create_own_shop = "자체 상점 만들기"
L.shop_link = "연동하기"
L.shop_disabled = "상점 끄기"
L.shop_default = "기본 상점 사용"

-- 2019-05-05
L.reroll_name = "리롤"
L.reroll_menutitle = "장비 리롤"
L.reroll_no_credits = "리롤하려면 {amount} 개의 크레딧이 필요합니다!"
L.reroll_button = "리롤"
L.reroll_help = "당신의 상점에 새 랜덤 장비 세트를 만드려면 {amount} 개의 크레딧이 필요합니다!"

-- 2019-05-06
L.equip_not_alive = "오른쪽에서 역할을 선택하면 그 역할군이 선택 가능한 항목을 볼 수 있습니다. 즐겨찾기 잊지 마세요!"

-- 2019-06-27
L.shop_editor_title = "상점 에디터"
L.shop_edit_items_weapong = "아이템/무기 수정"
L.shop_edit = "상점 수정"
L.shop_settings = "세팅"
L.shop_select_role = "역할 선택"
L.shop_edit_items = "아이템 수정"
L.shop_edit_shop = "상점 수정"
L.shop_create_shop = "커스텀 상점 만들기"
L.shop_selected = "{role} 선택됨"
L.shop_settings_desc = "Random Shop ConVars에 맞게 상점을 수정합니다. 저장 잊지 마세요!"

L.bindings_new = "{name}에 대한 새로운 바인드 키: {key}"

--L.hud_default_failed = "Failed to set the HUD {hudname} as new default. You don't have permission to do that, or this HUD doesn't exist."
--L.hud_forced_failed = "Failed to force the HUD {hudname}. You don't have permission to do that, or this HUD doesn't exist."
--L.hud_restricted_failed = "Failed to restrict the HUD {hudname}. You don't have permission to do that."

L.shop_role_select = "역할 선택"
L.shop_role_selected = "{role} 역할의 상점이 선택되었습니다!"
L.shop_search = "검색"

-- 2019-10-19
L.drop_ammo_prevented = "무언가 탄약을 떨어트리는 것을 막고 있습니다."

-- 2019-10-28
L.target_c4 = "[{usekey}] 키를 눌러 C4 메뉴를 열기"
L.target_c4_armed = "[{usekey}] 키를 눌러 C4 해체"
L.target_c4_armed_defuser = "[{primaryfire}] 를 눌러 해체 키트 사용하기"
L.target_c4_not_disarmable = "살아있는 팀원의 C4는 해체 할 수 없습니다!"
L.c4_short_desc = "아주 폭발적인 인기를 가지고 있습니다."

L.target_pickup = "[{usekey}] 키를 눌러 습득"
L.target_slot_info = "슬롯: {slot}"
L.target_pickup_weapon = "[{usekey}] 키를 눌러 무기 습득"
L.target_switch_weapon = "[{usekey}] 키를 눌러 현재 무기와 교체"
L.target_pickup_weapon_hidden = ", [{walkkey} + {usekey}] 키를 물러 몰래 줍기"
L.target_switch_weapon_hidden = ",  [{walkkey} + {usekey}] 키를 눌러 몰래 교체"
L.target_switch_weapon_nospace = "이 아이템을 위한 칸이 없습니다."
L.target_switch_drop_weapon_info = "{slot} 슬롯의 {name}를 떨어트렸습니다."
L.target_switch_drop_weapon_info_noslot = "{slot}의 아이템 중 떨어트릴 수 있는게 없습니다."

L.corpse_searched_by_detective = "이 시체는 탐정에 의해 수색되었습니다."
L.corpse_too_far_away = "시체가 너무 멉니다."

L.radio_short_desc = "무기 소리가 내게는 노래같은데."

L.hstation_subtitle = "[{usekey}] 키를 눌러 회복합니다."
L.hstation_charge = "치료 스테이션 남은 충전 수: {charge}"
L.hstation_empty = "치료 스테이션에 남은 충전 수가 부족합니다."
L.hstation_maxhealth = "체력이 꽉 찼습니다."
L.hstation_short_desc = "치료 스테이션은 시간에 따라 천천히 재충전됩니다."

-- 2019-11-03
L.vis_short_desc = "총격에 의한 사망시 사망시 현장을 보여줍니다."
L.corpse_binoculars = "[{key}] 키를 눌러 망원경으로 시체를 수색 할 수 있습니다."
L.binoc_progress = "수색 진행상황: {progress}%"

L.pickup_no_room = "그 무기를 위한 칸이 없습니다."
L.pickup_fail = "이 무기를 주울 수 없습니다."
L.pickup_pending = "이미 무기를 주웠습니다. 착용 할 때 까지 기다리세요."

-- 2020-01-07
L.tbut_help_admin = "트레이터 버튼 설정"
L.tbut_role_toggle = "[{walkkey} + {usekey}] 를 눌러 {role}를 위한 이 버튼을 토글합니다."
L.tbut_role_config = "역할: {current}"
L.tbut_team_toggle = "[SHIFT + {walkkey} + {usekey}] 를 눌러 {team}를 위한 이 버튼을 토글합니다."
L.tbut_team_config = "팀: {current}"
L.tbut_current_config = "현재 설정:"
L.tbut_intended_config = "맵 제작자가 설정한 값:"
L.tbut_admin_mode_only = "관리자이고 '{cv}'가 '1'로 설정되어 있기 때문에 이 버튼이 표시됩니다."
L.tbut_allow = "허가"
L.tbut_prohib = "금지"
L.tbut_default = "기본"

-- 2020-02-09
L.name_door = "문"
L.door_open = "[{usekey}] 키를 눌러 문을 엽니다."
L.door_close = "[{usekey}] 키를 눌러 문을 닫습니다."
L.door_locked = "이 문은 잠겨있습니다."

-- 2020-02-11
L.automoved_to_spec = "(자동 메세지) 잠수 중 입니다."
L.mute_team = "{team} 뮤트됨."

-- 2020-02-16
L.door_auto_closes = "이 문은 자동으로 닫힙니다."
L.door_open_touch = "문을 열려면 가까이 다가가세요."
L.door_open_touch_and_use = "문을 열려면 가까이 다가가서 [{usekey}]키를 누르세요."

-- 2020-03-09
L.help_title = "도움과 설정"

L.menu_changelog_title = "체인지로그"
L.menu_guide_title = "TTT2 가이드"
L.menu_bindings_title = "키 바인딩"
L.menu_language_title = "언어"
L.menu_appearance_title = "외형"
L.menu_gameplay_title = "게임 플레이"
L.menu_addons_title = "에드온"
L.menu_legacy_title = "레거시 에드온"
L.menu_administration_title = "관리"
L.menu_equipment_title = "장비 설정"
L.menu_shops_title = "상점 설정"

L.menu_changelog_description = "현재 버전의 변경 사항입니다."
L.menu_guide_description = "TTT2를 시작하는데 도움을 주는 도움말입니다. 역할이나 다른 여러가지를 알려줍니다."
L.menu_bindings_description = "TTT2에 있는 기능이나 다른 에드온의 기능을 바인드합니다. "
L.menu_language_description = "게임모드의 언어를 설정합니다."
L.menu_appearance_description = "UI의 외형과 성능을 변경합니다."
L.menu_gameplay_description = "보이스 볼륨과 볼륨, 접근성 항목과 게임플레이 항목을 설정합니다."
L.menu_addons_description = "당신이 추가한 로컬 에드온을 설정합니다."
L.menu_legacy_description = "옛 TTT에서 포팅된 기능들을 설정합니다."
L.menu_administration_description = "허드/상점 등을 설정합니다."
L.menu_equipment_description = "크레딧/제한/금지항목과 다른 것들을 설정합니다."
L.menu_shops_description = "직업별 장비 항목을 수정하거나 설정하는 항목입니다."

L.submenu_guide_gameplay_title = "게임플레이"
L.submenu_guide_roles_title = "역할"
L.submenu_guide_equipment_title = "장비"

L.submenu_bindings_bindings_title = "바인드"

L.submenu_language_language_title = "언어"

L.submenu_appearance_general_title = "일반"
L.submenu_appearance_hudswitcher_title = "HUD 변경"
L.submenu_appearance_vskin_title = "VSkin"
L.submenu_appearance_targetid_title = "타겟 ID"
L.submenu_appearance_shop_title = "상점 설정"
L.submenu_appearance_crosshair_title = "크로스헤어"
L.submenu_appearance_dmgindicator_title = "데미지 인디케이터"
L.submenu_appearance_performance_title = "성능"
L.submenu_appearance_interface_title = "인터페이스"

L.submenu_gameplay_general_title = "일반"

L.submenu_administration_hud_title = "HUD 설정"
L.submenu_administration_randomshop_title = "랜덤 상점"

L.help_color_desc = "이걸 활성화하면, 크로스헤어와 타겟ID가 지정된 적의 외곽선의 색을 변경합니다."
L.help_scale_factor = "이 옵션은 모든 UI요소들에 영향을 끼칩니다. 화면 해상도 변경시 자동으로 업데이트됩니다. 이 값을 변경하면 HUD를 재실행하게 됩니다!"
L.help_hud_game_reload = "HUD를 지금 사용할 수 없습니다. 서버에 다시 연결하거나 게임을 다시 시작하십시오."
L.help_hud_special_settings = "HUD의 특정 설정을 변경합니다."
L.help_vskin_info = "VSkin (VGUI 스킨)은 현재와 같은 모든 메뉴 요소에 적용되는 스킨입니다. 간단한 Lua 스크립트로 쉽게 생성할 수 있으며 색상 및 일부 크기 매개변수를 변경할 수 있습니다."
L.help_targetid_info = "타겟 ID는 크로스헤어를 가져다 댔을때 나오는 정보입니다. 그 색상은 '일반'탭에서 바꿀 수 있습니다."
L.help_hud_default_desc = "기본 HUD를 설정합니다. 아직 HUD를 설정하지 않은 플레이어들은 이 HUD 설정이 자동으로 설정됩니다. 그러나 이미 HUD를 선택한 플레이어들에게는 이 설정이 반영되지 않습니다."
L.help_hud_forced_desc = "모든 플레이어들에게 이 HUD 설정을 강제로 반영합니다. 모든 사람들에게 HUD 설정 기능을 비활성화 시킵니다."
L.help_hud_enabled_desc = "활성화/비활성화하여 HUD 선택을 비활성화 합니다."
L.help_damage_indicator_desc = "데미지 인디케이터는 플레이어가 데미지를 입었을 때 표시되는 오버레이입니다. 새로운 테마를 추가하려면 'materials/vgui/ttttt/damage indicator/themes/'에 png 파일을 놓습니다."
L.help_shop_key_desc = "라운드 준비 중 / 라운드 종료 후 스코어 메뉴 대신 상점을 열려면 상점 키를 누르세요."

L.label_menu_menu = "메뉴"
L.label_menu_admin_spacer = "관리자 영역(일반 플레이어에겐 보이지 않음)"
L.label_language_set = "언어 선택"
L.label_global_color_enable = "글로벌 컬러 선택"
L.label_global_color = "글로벌 컬러"
L.label_global_scale_factor = "글로벌 스케일 인자"
L.label_hud_select = "HUD 선택"
L.label_vskin_select = "VSkin 선택"
L.label_blur_enable = "VSkin 배경 블러 활성화"
L.label_color_enable = "VSkin 배경 컬러 활성화"
L.label_minimal_targetid = "타겟 ID 최소화 (카르마, 힌트 등을 표시하지 않음.)"
L.label_shop_always_show = "항상 상점을 보이기"
L.label_shop_double_click_buy = "상점에서 아이템을 더블클릭하여 구매하기"
L.label_shop_num_col = "열의 수"
L.label_shop_num_row = "행의 수"
L.label_shop_item_size = "아이콘 사이즈"
L.label_shop_show_slot = "슬롯 표시 보이기"
L.label_shop_show_custom = "커스텀 아이템 표시 보이기"
L.label_shop_show_fav = "즐겨찾기 아이템 표시 보이기"
L.label_crosshair_enable = "크로스헤어 보이기"
L.label_crosshair_opacity = "크로스헤어 불투명도"
L.label_crosshair_ironsight_opacity = "조준시 크로스헤어 불투명도"
L.label_crosshair_size = "크로스헤어 선 길이 배율"
L.label_crosshair_thickness = "크로스헤어 크기 배율"
L.label_crosshair_thickness_outline = "크로스헤어 외곽선 굵기 배율"
L.label_crosshair_scale_enable = "다이나믹 크로스헤어 크기 활성화"
L.label_crosshair_ironsight_low_enabled = "조준시 무기 내리기 활성화"
L.label_damage_indicator_enable = "데미지 인디케이터 활성화"
L.label_damage_indicator_mode = "데미지 인디케이터 테마 설정"
L.label_damage_indicator_duration = "맞은 후에 인디케이터가 사라지는 시간 (초)"
L.label_damage_indicator_maxdamage = "최대 불투명도를 위해 필요한 데미지"
L.label_damage_indicator_maxalpha = "최대 불투명도"
L.label_performance_halo_enable = "일부 엔티티 주변 윤곽선 그리기"
L.label_performance_spec_outline_enable = "제어된 객체의 윤곽선 그리기"
L.label_performance_ohicon_enable = "플레이어 위에 역할 아이콘 표시"
L.label_interface_popup = "라운드 시작시 정보 표시 지속시간"
L.label_interface_fastsw_menu = "빠른 무기 전환 메뉴 활성화"
L.label_inferface_wswitch_hide_enable = "무기 전환 메뉴 자동 닫기 활성화"
L.label_inferface_scues_enable = "라운드 시작 혹은 종료시 사운드 재생"
L.label_gameplay_specmode = "관전 모드 (항상 관전자로 시작합니다)"
L.label_gameplay_fastsw = "빠른 무기 전환"
L.label_gameplay_hold_aim = "눌러 조준하기 키기"
L.label_gameplay_mute = "죽었을 때 생존한 플레이어 음소거"
L.label_hud_default = "기본 HUD"
L.label_hud_force = "강제 HUD"

L.label_bind_voice = "글로벌 보이스 챗"
L.label_bind_voice_team = "팀 보이스 챗"

L.label_hud_basecolor = "기초 색상"

L.label_menu_not_populated = "이 하위 메뉴에는 내용이 없습니다."

L.header_bindings_ttt2 = "TTT2 바인딩"
L.header_bindings_other = "다른 바인딩"
L.header_language = "언어 설정"
L.header_global_color = "글로벌 색 설정"
L.header_hud_select = "HUD 설정"
L.header_hud_customize = "HUD 커스터마이징"
L.header_vskin_select = "VSkin 선택/커스터마이징"
L.header_targetid = "타겟 ID 설정"
L.header_shop_settings = "장비 상점 설정"
L.header_shop_layout = "아이템 리스트 레이아웃"
L.header_shop_marker = "아이템 마커 설정"
L.header_crosshair_settings = "크로스헤어 설정"
L.header_damage_indicator = "데미지 인디케이터 설정"
L.header_performance_settings = "성능 설정"
L.header_interface_settings = "인터페이스 설정"
L.header_gameplay_settings = "게임플레이 설정"
L.header_hud_administration = "강제 HUD와 기본 HUD 설정"
L.header_hud_enabled = "HUD 키기/끄기"

L.button_menu_back = "뒤로"
L.button_none = "없음"
L.button_press_key = "키를 누르기"
L.button_save = "저장"
L.button_reset = "초기화"
L.button_close = "닫기"
L.button_hud_editor = "HUD 에디터"

-- 2020-04-20
L.item_speedrun = "스피드런"
L.item_speedrun_desc = [[50% 더 빠르게 달립니다!]]
L.item_no_explosion_damage = "폭발 데미지 면역"
L.item_no_explosion_damage_desc = [[폭발 데미지에 면역을 줍니다.]]
L.item_no_fall_damage = "추락 데미지 면역"
L.item_no_fall_damage_desc = [[추락 데미지에 면역을 줍니다.]]
L.item_no_fire_damage = "불 데미지 면역"
L.item_no_fire_damage_desc = [[불 데미지에 면역을 줍니다.]]
L.item_no_hazard_damage = "환경 피해 면역"
L.item_no_hazard_damage_desc = [[독, 방사능, 산 등의 환경 피해에 면역이 됩니다.]]
L.item_no_energy_damage = "에너지 피해 면역"
L.item_no_energy_damage_desc = [[레이저, 플라즈마, 전기 등의 에너지 피해에 면역이 됩니다.]]
L.item_no_prop_damage = "프롭 데미지 면역"
L.item_no_prop_damage_desc = [[프롭 데미지에 면역이 됩니다.]]
L.item_no_drown_damage = "익사 면역"
L.item_no_drown_damage_desc = [[익사에 면역이 됩니다.]]

-- 2020-04-21
L.dna_tid_possible = "스캔 가능."
L.dna_tid_impossible = "스캔 불가."
L.dna_screen_ready = "DNA 없음"
L.dna_screen_match = "일치"

-- 2020-04-30
L.message_revival_canceled = "부활 취소."
L.message_revival_failed = "부활 실패."
L.message_revival_failed_missing_body = "시체가 없기 때문에 부활 할 수 없습니다."
L.hud_revival_title = "부활까지 남은 시간:"
L.hud_revival_time = "{time}초"

-- 2020-05-03
L.door_destructible = "이 문은 파괴 가능합니다. ({health}HP)."

-- 2020-05-28
L.corpse_hint_inspect_limited = "[{usekey}] 키를 눌러 수색합니다. [{walkkey} + {usekey}] 로 UI만 띄우기."

-- 2020-06-04
L.label_bind_disguiser = "변장 기구 토글"

-- 2020-06-24
L.dna_help_primary = "DNA 샘플 수집"
L.dna_help_secondary = "DNA 슬롯 변경"
L.dna_help_reload = "샘플 삭제하기"

L.binoc_help_pri = "시체 조사하기."
L.binoc_help_sec = "줌 단계 변경."

L.vis_help_pri = "활성화 된 장치 떨어트리기."

-- 2020-08-07
L.pickup_error_spec = "관전자로는 주울 수 없습니다."
L.pickup_error_owns = "이미 이 무기가 있어 주울 수 없습니다."
L.pickup_error_noslot = "슬롯에 이미 무기가 있어 이 무기를 주울 수 없습니다."

-- 2020-11-02
L.lang_server_default = "서버 기본"
L.help_lang_info = [[
이 번역은 {coverage}% 정도 완성되었습니다.

오역이 있거나 빠진 부분이 있을 수 있습니다.]]

-- 2021-04-13
L.title_score_info = "라운드 종료 정보"
L.title_score_events = "이벤트 타임라인"

L.label_bind_clscore = "라운드 정보 열기"
L.title_player_score = "{player}의 점수:"

L.label_show_events = "이벤트 표시 위치"
L.button_show_events_you = "당신"
L.button_show_events_global = "전체"
L.label_show_roles = "역할 분배 보이기"
L.button_show_roles_begin = "라운드 시작"
L.button_show_roles_end = "라운드 종료"

L.hilite_win_traitors = "트레이터 승리"
L.hilite_win_innocents = "이노센트 승리"
L.hilite_win_tie = "비겼습니다"
L.hilite_win_time = "시간 종료"

L.tooltip_karma_gained = "이번 라운드 카르마 변경 수치:"
L.tooltip_score_gained = "이번 라운드 점수 변경 수치:"
L.tooltip_roles_time = "이번 라운드 역할 변경 :"

--L.tooltip_finish_score_win = "Win: {score}"
L.tooltip_finish_score_alive_teammates = "살아 있는 팀원: {score}"
L.tooltip_finish_score_alive_all = "살아 있는 플레이어: {score}"
L.tooltip_finish_score_timelimit = "시간 종료까지: {score}"
L.tooltip_finish_score_dead_enemies = "죽은 적: {score}"
L.tooltip_kill_score = "킬: {score}"
L.tooltip_bodyfound_score = "시체 발견: {score}"

--L.finish_score_win = "Win:"
L.finish_score_alive_teammates = "살아 있는 팀원:"
L.finish_score_alive_all = "살아 있는 플레이어:"
L.finish_score_timelimit = "시간 종료까지:"
L.finish_score_dead_enemies = "죽은 적:"
L.kill_score = "킬:"
L.bodyfound_score = "시체 발견:"

L.title_event_bodyfound = "시체를 발견했습니다."
L.title_event_c4_disarm = "C4가 해체되었습니다"
L.title_event_c4_explode = "C4가 폭발하였습니다"
L.title_event_c4_plant = "C4가 설치되었습니다"
L.title_event_creditfound = "장비 크레딧이 발견되었습니다."
L.title_event_finish = "라운드가 종료되었습니다"
L.title_event_game = "새 라운드가 시작되었습니다"
L.title_event_kill = "플레이어가 사망했습니다"
L.title_event_respawn = "플레이어가 리스폰되었습니다"
L.title_event_rolechange = "플레이어가 자신의 역할이나 팀을 변경했습니다"
L.title_event_selected = "역할이 분배되었습니다"
L.title_event_spawn = "플레이어가 스폰되었습니다"

L.desc_event_bodyfound = "{finder} ({firole} / {fiteam}) 가 {found} ({forole} / {foteam}). 의 시체를 찾았습니다. 시체는 {credits} 개의 크레딧을 가지고 있습니다."
L.desc_event_bodyfound_headshot = "희생자는 헤드샷으로 사망하였습니다."
L.desc_event_c4_disarm_success = "{disarmer} ({drole} / {dteam}) 가 {owner} ({orole} / {oteam})가 설치한 C4를 해체하였습니다."
L.desc_event_c4_disarm_failed = "{disarmer} ({drole} / {dteam})가 {owner} ({orole} / {oteam})가 설치한 C4를 해체하다가 실패하였습니다."
L.desc_event_c4_explode = "{owner} ({role} / {team})가 설치한 폭탄이 폭발하였습니다."
L.desc_event_c4_plant = "{owner} ({role} / {team})가 C4를 설치하였습니다."
L.desc_event_creditfound = "{finder} ({firole} / {fiteam}) 가 {credits} 개의 장비 크레딧을 {found} ({forole} / {foteam}) 로 부터 발견하였습니다."
L.desc_event_finish = "라운드는 {minutes}:{seconds}동안 진행되었으며. {alive} 명의 플레이어가 생존하였습니다."
L.desc_event_game = "새 라운드가 시작되었습니다."
L.desc_event_respawn = "{player} 가 리스폰되었습니다."
L.desc_event_rolechange = "{player} 가 팀을 {orole} ({oteam}) 로 변경하였습니다. {nrole} ({nteam})."
L.desc_event_selected = "{amount} 명에게 팀과 역할이 배정되었습니다."
L.desc_event_spawn = "{player} 가 스폰되었습니다."

-- Name of a trap that killed us that has not been named by the mapper
L.trap_something = "무언가"

-- Kill events
L.desc_event_kill_suicide = "자살이었습니다."
L.desc_event_kill_team = "팀킬 이었습니다."

L.desc_event_kill_blowup = "{victim} ({vrole} / {vteam}) 가 자폭했습니다."
L.desc_event_kill_blowup_trap = "{victim} ({vrole} / {vteam}) 가 {trap}로 인해 폭발하였습니다."

L.desc_event_kill_tele_self = "{victim} ({vrole} / {vteam}) 가 텔레포트사 했습니다."
L.desc_event_kill_sui = "{victim} ({vrole} / {vteam}) 가 받아들이지 못하고 스스로 목숨을 끊었습니다."
L.desc_event_kill_sui_using = "{victim} ({vrole} / {vteam}) 가 {tool}를 이용해 죽었습니다."

L.desc_event_kill_fall = "{victim} ({vrole} / {vteam}) 가 떨어져 사망했습니다."
L.desc_event_kill_fall_pushed = "{victim} ({vrole} / {vteam}) 는 {attacker} 가 밀어 죽였습니다."
L.desc_event_kill_fall_pushed_using = "{victim} ({vrole} / {vteam}) 를 {attacker} ({arole} / {ateam}) 가 {trap} 를 이용해 추락사 시켰습니다."

L.desc_event_kill_shot = "{victim} ({vrole} / {vteam}) 를 {attacker}가 쏴 죽였습니다."
L.desc_event_kill_shot_using = "{victim} ({vrole} / {vteam}) 를 {attacker} ({arole} / {ateam})가 {weapon}로 쏴죽였습니다."

L.desc_event_kill_drown = "{victim} ({vrole} / {vteam}) 를 {attacker}가 익사시켰습니다."
L.desc_event_kill_drown_using = "{victim} ({vrole} / {vteam}) 를 {attacker} ({arole} / {ateam})가 {trap}를 이용하여 익사시켰습니다."

L.desc_event_kill_boom = "{victim} ({vrole} / {vteam}) 를 {attacker}가 폭사시켰습니다."
L.desc_event_kill_boom_using = "{victim} ({vrole} / {vteam}) 를 {attacker} ({arole} / {ateam})가 {trap}를 이용하여 폭사시켰습니다."

L.desc_event_kill_burn = "{victim} ({vrole} / {vteam}) 를 {attacker}가 태워죽였습니다."
L.desc_event_kill_burn_using = "{victim} ({vrole} / {vteam}) 를 {trap}로 {attacker} ({arole} / {ateam}) 가 태워죽였습니다."

L.desc_event_kill_club = "{victim} ({vrole} / {vteam}) 를 {attacker}가 때려죽였습니다."
L.desc_event_kill_club_using = "{victim} ({vrole} / {vteam}) 를 {attacker} ({arole} / {ateam})가 {trap}를 이용해서 죽였습니다."

L.desc_event_kill_slash = "{victim} ({vrole} / {vteam}) 를 {attacker}가 찔러죽였습니다."
L.desc_event_kill_slash_using = "{victim} ({vrole} / {vteam}) was cut up by {attacker} ({arole} / {ateam}) using {trap}."

L.desc_event_kill_tele = "{victim} ({vrole} / {vteam}) 를 {attacker}가 텔레포트킬 했습니다."
L.desc_event_kill_tele_using = "{victim} ({vrole} / {vteam}) 를 {attacker} ({arole} / {ateam})가 {trap} 를 이용해서 뼈와 살을 분리시켰습니다."

L.desc_event_kill_goomba = "{victim} ({vrole} / {vteam})를 {attacker} ({arole} / {ateam})가 밟아 죽였습니다."

L.desc_event_kill_crush = "{victim} ({vrole} / {vteam}) 를 {attacker}가 깔아뭉개 죽였습니다."
L.desc_event_kill_crush_using = "{victim} ({vrole} / {vteam}) 를 {trap} 러 {attacker} ({arole} / {ateam})가 깔아뭉개 죽였습니다."

L.desc_event_kill_other = "{victim} ({vrole} / {vteam}) 를 {attacker}가 죽였습니다."
L.desc_event_kill_other_using = "{victim} ({vrole} / {vteam}) 를 {attacker} ({arole} / {ateam}) 가 {trap}를 이용해서 죽였습니다."

-- 2021-04-20
L.none = "No Role"

-- 2021-04-24
L.karma_teamkill_tooltip = "팀원을 죽임"
L.karma_teamhurt_tooltip = "팀원에게 데미지를 줌"
L.karma_enemykill_tooltip = "적을 죽임"
L.karma_enemyhurt_tooltip = "적에게 데미지를 줌"
L.karma_cleanround_tooltip = "깔끔한 라운드"
L.karma_roundheal_tooltip = "카르마 복구"
L.karma_unknown_tooltip = "알 수 없음"

-- 2021-05-07
L.header_random_shop_administration = "랜덤 상점 설정"
L.header_random_shop_value_administration = "잔액 설정"

L.shopeditor_name_random_shops = "랜덤 상점 키기"
L.shopeditor_desc_random_shops = [[플레이어들에게 활성화 된 장비중 아무 장비나 랜덤하게 지급합니다.
팀 상점은 한 팀의 모든 플레이어들에게 개인적인 장비 대신 동일한 장비를 제공합니다.
크레딧을 사용하여 리롤하여, 무작위 장비를 얻을 수 있습니다.]]
L.shopeditor_name_random_shop_items = "랜덤 장비 개수"
L.shopeditor_desc_random_shop_items = "장비를 포함합니다. \"언제나 상점에서 사용 가능\". 이라고 표시된 장비가 포함됩니다. 그러니 제대로 된 숫자를 넣지 않으면 그 장비만 얻게 됩니다."
L.shopeditor_name_random_team_shops = "팀 상점 활성화"
L.shopeditor_name_random_shop_reroll = "상점 리롤 사용"
L.shopeditor_name_random_shop_reroll_cost = "리롤마다 사용할 크레딧"
L.shopeditor_name_random_shop_reroll_per_buy = "구매 후 오토리롤"

-- 2021-06-04
L.header_equipment_setup = "장비 설정"
L.header_equipment_value_setup = "잔액 설정"

L.equipmenteditor_name_not_buyable = "살 수 있습니다"
L.equipmenteditor_desc_not_buyable = "비활성화 시 이 장비가 상점에 표시되지 않습니다. 이 장비를 쓸 수 있는 역할은 장비를 받을 수 있습니다."
L.equipmenteditor_name_not_random = "언제나 상점에서 구매 가능합니다."
L.equipmenteditor_desc_not_random = "켜져 있다면, 장비는 항상 상점에서 구매 가능합니다. 랜덤 상점이 활성화 되어있다면, 이 장비를 위해 슬롯을 예약해둡니다."
L.equipmenteditor_name_global_limited = "전역으로 한정된 금액"
L.equipmenteditor_desc_global_limited = "활성화 시 라운드에서 이 장비를 한번만 구매 가능합니다."
L.equipmenteditor_name_team_limited = "팀 제한 수"
L.equipmenteditor_desc_team_limited = "활성화 시 팀에서 정해진 개수만 이 장비를 구매 가능합니다."
L.equipmenteditor_name_player_limited = "플레이어 제한 수"
L.equipmenteditor_desc_player_limited = "활성화 시 전체 플레이어들이 정해진 개수만 장비를 구매 가능합니다."
L.equipmenteditor_name_min_players = "사기 위해 필요한 최소 플레이어 수"
L.equipmenteditor_name_credits = "사기 위한 크레딧 수"

-- 2021-06-08
L.equip_not_added = "추가되지 않음"
L.equip_added = "추가됨"
L.equip_inherit_added = "추가됨 (계승)"
L.equip_inherit_removed = "추가되지 않음 (계승)"

-- 2021-06-09
--L.layering_not_layered = "Not layered"
--L.layering_layer = "Layer {layer}"
--L.header_rolelayering_role = "{role} layering"
--L.header_rolelayering_baserole = "Base role layering"
--L.submenu_roles_rolelayering_title = "Role Layering"
--L.header_rolelayering_info = "Role layering information"
--L.help_rolelayering_roleselection = [[
--The role distribution process is split into two stages. In the first stage base roles are distributed, which are Innocent, Traitor and those listed in the 'base role layer' box below. The second stage is used to upgrade those base roles to a subrole.
--
--Further details are available in the "Roles Overview" submenu.]]
--L.help_rolelayering_layers = [[
--After determining the assignable roles according to role-specific convars (including the random chance they will be selected at all!), one role from each layer (if there are any) is selected for distribution. After handling the layers, unlayered roles are selected at random. Role distribution stops as soon as there are no more slots which need to be filled.
--
--Roles which are not considered due to convar-related requirements are not distributed.]]
--L.scoreboard_voice_tooltip = "Scroll to change the volume"

-- 2021-06-15
L.header_shop_linker = "세팅"
L.label_shop_linker_set = "상점 타입 선택:"

-- 2021-06-18
L.xfer_team_indicator = "팀"

-- 2021-06-25
L.searchbar_default_placeholder = "리스트에서 검색 중..."

-- 2021-07-11
L.spec_about_to_revive = "부활 시간 동안은 관전이 제한됩니다."

-- 2021-09-01
L.spawneditor_name = "스폰 에디터 툴"
L.spawneditor_desc = "플레이어들이 무기, 탄약 등을 배치합니다. 슈퍼 어드민만 사용 가능합니다."

L.spawneditor_place = "스폰 생성"
L.spawneditor_remove = "스폰 삭제"
L.spawneditor_change = "스폰 타입 변경 ([SHIFT] 키를 눌러 뒤로)"
L.spawneditor_ammo_edit = "자동 생성되는 탄약을 편집하려면 무기 생성을 길게 누르세요."

L.spawn_weapon_random = "랜덤 무기 스폰"
L.spawn_weapon_melee = "근접 무기 스폰"
L.spawn_weapon_nade = "수류탄 스폰"
L.spawn_weapon_shotgun = "샷건 스폰"
L.spawn_weapon_heavy = "중화기 스폰"
L.spawn_weapon_sniper = "스나이퍼 스폰"
L.spawn_weapon_pistol = "권총 스폰"
L.spawn_weapon_special = "특수 무기 스폰"
L.spawn_ammo_random = "랜덤 탄약 스폰"
L.spawn_ammo_deagle = "Deagle 탄약 스폰"
L.spawn_ammo_pistol = "권총 탄약 스폰"
L.spawn_ammo_mac10 = "Mac10 탄약 스폰"
L.spawn_ammo_rifle = "라이플 탄약 스폰"
L.spawn_ammo_shotgun = "샷건 탄약 스폰"
L.spawn_player_random = "랜덤 플레이어 스폰"

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
L.submenu_administration_playermodels_title = "플레이어 모델"
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
L.help_roles_credits_award_kill = "크레딧을 얻는 또 다른 방법이 있습니다. 탐정과 같은 HVT 타겟을 죽이는 것입니다. 만약 이 기능이 켜져있다면, 특정한 양의 크레딧을 얻습니다."
L.help_roles_credits_award = [[
TTT2에서 크레딧을 얻는 또 다른 방법이 있습니다:

1. 상대 팀을 일정 비율 이상 죽일 시 그 보상으로 크레딧을 얻습니다.
2. 플레이어가 탐정, 트레이터 같은 HVT 타겟을 사살시 일정량의 크레딧을 얻을 수 있습니다.

이 기능은 팀 전체에 대해 수여 등을 선택할 수 있고, 각 역할 별로 활성화/비활성화 가능한 기능입니다. 예를 들어 팀 이노센트가 HVT를 죽였다고 가정했을 때, 크레딧이 수여되었으나 이노센트가 크레딧을 사용하지 못하게끔 설정되었다면, 크레딧은 탐정만 받게 됩니다.
이 기능의 값을 '관리 -> 일반 역할 설정'에서 설정 가능합니다.]]
L.help_detective_hats = [[
탐정같은 특정 직업은, 직업의 권위를 상징하기 위해 모자를 쓰고 있습니다. 죽거나, 머리에 데미지를 입으면 모자를 잃어버립니다.
어떤 플레이어 모델들은 기본적으로 탐정 모자를 지원하지 않을 수 있습니다. 그럴 경우엔 '관리' -> '플레이어 모델에서 바꿀 수 있습니다']]

L.label_roles_credits_award_kill = "사살로 인한 크레딧 보상 비율"
L.label_roles_credits_dead_award = "적 팀 일정비율 사상 크레딧 보상 비율"
L.label_roles_credits_kill_award = "HVT 사살 크레딧 보상 비율"
L.label_roles_min_karma = "자산 분배 할 최소 카르마 비율"

-- 2021-11-07
L.submenu_administration_administration_title = "관리"
L.submenu_administration_voicechat_title = "보이스챗 / 채팅"
L.submenu_administration_round_setup_title = "라운드 설정"
L.submenu_administration_mapentities_title = "맵 엔티티"
L.submenu_administration_inventory_title = "인벤토리"
L.submenu_administration_karma_title = "카르마"
L.submenu_administration_sprint_title = "달리기"
L.submenu_administration_playersettings_title = "플레이어 설정"

L.header_roles_special_settings = "특수 역할 설정"
L.header_equipment_additional = "추가 장비 설정"
L.header_administration_general = "일반 관리 설정"
L.header_administration_logging = "로그"
L.header_administration_misc = "기타"
L.header_entspawn_plyspawn = "플레이어 스폰 설정"
L.header_voicechat_general = "일반 보이스 채팅 설정"
L.header_voicechat_battery = "보이스 채팅 배터리"
L.header_voicechat_locational = "근접 보이스 채팅"
L.header_playersettings_plyspawn = "플레이어 스폰 세팅"
L.header_round_setup_prep = "라운드: 준비중"
L.header_round_setup_round = "라운드: 진행중"
L.header_round_setup_post = "라운드: 종료"
L.header_round_setup_map_duration = "맵 세션"
L.header_textchat = "채팅"
L.header_round_dead_players = "죽은 플레이어 설정"
L.header_administration_scoreboard = "스코어보드 설정"
L.header_hud_toggleable = "끄고 킬 수 있는 HUD 설정"
L.header_mapentities_prop_possession = "프롭 빙의"
L.header_mapentities_doors = "문"
L.header_karma_tweaking = "카르마 기능"
L.header_karma_kick = "카르마 킥/밴"
L.header_karma_logging = "카르마 로그"
L.header_inventory_gernal = "인벤토리 사이즈"
L.header_inventory_pickup = "인벤토리 무기 습득"
L.header_sprint_general = "달리기 설정"
L.header_playersettings_armor = "방어구 시스템 설정"

L.help_killer_dna_range = "플레이어가 다른 플레이어에 의해 죽임을 당하면, 그들의 시체에는 DNA 샘플이 남게 됩니다. 아래 설정은 DNA 샘플이 남는 최대 거리를 설정합니다. 살인자가 희생자가 죽을 때 이 값보다 더 멀리 있으면 시체에는 샘플이 남지 않습니다."
L.help_killer_dna_basetime = "살인자가 더 멀리 있을수록 DNA 샘플이 부패되는데 더 짧은 시간이 필요하게 됩니다."
L.help_dna_radar = "TTT2의 DNA 스캐너는, 장착시 선택된 DNA 샘플의 거리와 방향을 표시합니다. 기존 TTT DNA 스캐너 모드도 있습니다. 이 모드를 선택 할 시 쿨다운마다 위치를 업데이트합니다."
--L.help_idle = "The idle mode is used to forcefully move idle players into the spectator mode. To leave this mode, they will have to disable it in their 'gameplay' menu."
L.help_namechange_kick = [[
이미 진행된 라운드 도중 이름을 변경하는것은 기본적으로 금지되어 있습니다. 이를 시도한 플레이어는 서버에서 퇴장됩니다.

만약 밴 시간이 0보다 크다면, 그 플레이어는 그 시간이 지날 때 까지 서버에 재접속 할 수 없습니다.]]
L.help_damage_log = "플레이어가 피해를 입을 때 마다. 기능이 활성화 되있다면 콘솔에 피해 로그 항목이 추가됩니다. 이는 라운드 종료 후에 저장됩니다. 'data/terrortown/logs/'에 저장됩니다."
L.help_spawn_waves = [[
이 변수가 0으로 설정된 경우, 모든 플레이어가 한꺼번에 스폰됩니다. 많은 플레이어가 있는 서버에서는 플레이어를 웨이브 단위로 스폰하는 것이 유리할 수 있습니다. 스폰 웨이브 간격은 각 스폰 웨이브 사이의 시간입니다. 각 스폰 웨이브는 유효한 스폰 지점 수만큼 플레이어를 스폰합니다.

참고: 원하는 스폰 웨이브 수에 맞는 준비 시간을 충분히 설정해야 합니다.]]
L.help_voicechat_battery = [[
보이스 채팅 배터리가 활성화된 상태에서 보이스 채팅을 하면 배터리가 감소합니다. 배터리가 다 떨어지면 플레이어는 보이스 채팅을 사용할 수 없으며, 충전될 때까지 기다려야 합니다. 이는 보이스 채팅 남용을 방지하는 데 도움이 될 수 있습니다.

참고: 틱은 게임의 틱을 의미합니다. 예를 들어, 서버 틱이 66으로 설정되어 있다면 1/66초입니다.]]
L.help_ply_spawn = "플레이어 리스폰에 사용되는 세팅."
L.help_haste_mode = [[
헤이스트 모드는 매 죽은 플레이어마다 라운드 시간을 증가시킵니다. 실종된 플레이어를 볼 수 있는 역할만 실제 라운드가 끝나는 시간을 알 수 있습니다.English

다른 모든 역할은 헤이스트 모드 시작 시간만 볼 수 있습니다.

헤이스트 모드가 활성화 된 경우, 일반 라운드 시간은 무시합니다.]]
L.help_round_limit = "시간 제한이 다 되면, 맵을 바꿉니다."
L.help_armor_balancing = "방탄복의 벨런스를 맞추는 데 사용할 수 있는 값입니다."
L.help_item_armor_classic = "클래식 아머 모드는 한 라운드에 플레이어가 아머를 한 번만 구매할 수 있으며, 이 아머는 총알과 빠루의 피해 30%를 방어합니다. 방탄복은 플레이어가 사망할 때까지 지속됩니다."
L.help_item_armor_dynamic = [[
다이내믹 아머는 TTT2에서 방탄복을 더 흥미롭게 만들기 위해 만들어졌습니다. 이제 구매할 수 있는 아머의 양에 제한이 없으며, 방탄값은 쌓일 수 있습니다. 피해를 입으면 값이 감소합니다. 각 방탄복의 방탄값은 해당 아이템의 '장비 설정'에서 설정됩니다.

피해를 입을 때, 일정 비율의 이 피해는 방탄 피해로 변환되고, 다른 비율은 HP에 들어가며, 나머지는 사라집니다.

다이나믹 아머가 활성화된 경우, 방탄 값이 플레이어에게 적용되는 피해가 15% 감소됩니다.]]
L.help_sherlock_mode = "셜록 모드는 클래식 TTT 모드입니다. 셜록 모드가 비활성화된 경우, 사망한 시체를 확인할 수 없으며, 점수판에서는 모든 플레이어가 살아있는 것으로 표시되며, 관전자는 생존 플레이어와 대화할 수 있습니다."
--L.help_prop_possession = [[
--Prop possession can be used by spectators to possess props lying in the world and use the slowly recharging 'punch-o-meter' to move said prop around.
--
--The maximum value of the 'punch-o-meter' consists of a possession base value, where the kills/deaths difference clamped inbetween two defined limits is added. The meter slowly recharges over time. The set recharge time is the time needed to recharge a single point in the 'punch-o-meter'.]]
L.help_karma = "플레이어들은 일정한 카르마 점수로 시작하며, 팀원을 공격하거나 처치할 경우 카르마 점수를 잃습니다. 잃는 카르마 점수는 공격하거나 처치한 상대의 카르마 점수에 따라 달라집니다. 카르마 점수가 낮을수록 입히는 피해가 줄어듭니다."
L.help_karma_strict = "제한된 카르마 설정이 활성화되면, 카르마가 낮아질수록 피해 감소 벌칙 수치가 더 빨리 증가합니다. 비활성화 시에는 800 이상의 카르마에서는 별 영향이 없습니다. 제한된 카르마 모드를 활성화하면, 불필요한 킬에 대한 강력한 처벌이 있지만, 비활성화시엔 팀원을 자주 죽이는 플레이어에게만 해를 끼칩니다."
L.help_karma_max = "최대 카르마 값을 1000 이상으로 설정해도, 1000 이상의 카르마를 가진 플레이어에게 추가 데미지 보너스를 제공하지는 않습니다."
L.help_karma_ratio = "만약 두 사람이 같은 팀에 속해 있다면, 피해의 비율을 따져 공격자의 카르마가 얼마나 감소하는지를 따집니다. 팀을 죽였을 경우엔 추가적인 벌칙이 부여됩니다."
L.help_karma_traitordmg_ratio = "만약 둘이 다른 팀에 속할 경우, 피해의 비율은 공격자의 카르마가 증가시킵니다. 적을 처치할 경우 추가적인 보너스가 적용됩니다."
L.help_karma_bonus = "라운드 동안 카르마를 얻는 두 가지 방법이 있습니다. 첫 번째는 라운드 종료 시 모든 플레이어에게 적용되는 카르마 복원입니다. 그리고 두 번째로, 팀원을 쏘거나 죽이지 않았을 경우 보너스 카르마가 주어집니다."
--L.help_karma_clean_half = [[
--When a player's Karma is above the starting level (meaning the Karma max has been configured to be higher than that), all their Karma increases will be reduced based on how far their Karma is above that starting level. So it goes up slower the higher it is.
--
--This reduction goes in a curve of exponential decay: initially it's fast, and it slows down as the increment gets smaller. This convar sets at what point the bonus has been halved (so the half-life). With the default value of 0.25, if the starting amount of Karma is 1000 and the max 1500, and a player has Karma 1125 ((1500 - 1000) * 0.25 = 125), then his clean round bonus will be 30 / 2 = 15. So to make the bonus go down faster you’d set this convar lower, to make it go down slower you’d increase it towards 1.]]
L.help_max_slots = "한 슬롯당 최대 무기 수를 설정합니다. '-1'은 제한이 없음을 의미합니다."
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
L.header_playersettings_falldmg = "추락 데미지 설정"

L.label_falldmg_enable = "추락 데미지 켜기"
L.label_falldmg_min_velocity = "추락 데미지의 필요 속도"
L.label_falldmg_exponent = "속도에 따른 추락 데미지 증가"

L.help_falldmg_exponent = [[
이 값은 플레이어가 땅에 충돌할 때 지수적으로 증가하는 낙하 데미지를 속도에 따라 조절합니다.

이 값 조정 시 주의가 필요합니다. 너무 높게 설정하면 작은 낙하도 치명적일 수 있으며, 너무 낮게 설정하면 매우 높은 높이에서도 플레이어가 데미지를 입지 않고 떨어질 수 있습니다.]]

-- 2023-02-08
--L.testpopup_title = "A Test Popup, now with a multiline title, how NICE!"
--L.testpopup_subtitle = "Well, hello there! This is a fancy popup with some special information. The text can be also multiline, how fancy! Ugh, I could add so much more text if I'd had any ideas..."

L.hudeditor_chat_hint1 = "[TTT2][INFO] 요소 위에 마우스를 올리고 [왼쪽 마우스 버튼]을 누른 채로 마우스를 움직여서 이동하거나 크기를 조정할 수 있습니다."
L.hudeditor_chat_hint2 = "[TTT2][INFO] 크기 조정을 위해 ALT 키를 누른 채로 누르세요."
L.hudeditor_chat_hint3 = "[TTT2][INFO] SHIFT 키를 누른 채로 움직이면 축을 따라 이동하고 종횡비를 유지할 수 있습니다."
L.hudeditor_chat_hint4 = "[TTT2][INFO] 우클릭 -> '닫기'를 눌러 HUD 편집기를 종료하세요!"

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
L.search_title = "시체 조사 결과 - {player}"
L.search_info = "정보"
L.search_confirm = "확인"
L.search_confirm_credits = "(+{credits} Credit(s))개의 크레딧이 있음을 확인했습니다."
L.search_take_credits = "{credits} 개의 크레딧을 챙겼습니다."
L.search_confirm_forbidden = "확인 불가"
L.search_confirmed = "사망 확인"
L.search_call = "사망 보고"
L.search_called = "사망 보고됨"

L.search_team_role_unknown = "???"

L.search_words = "이 사람의 마지막 유언은: '{lastwords}'"
L.search_armor = "비표준 방탄복을 입고 있었습니다."
L.search_disguiser = "신원을 숨기는 장치를 가지고 있었습니다."
L.search_radar = "레이더를 가지고 있었습니다. 더 이상 작동하지는 않는군요."
L.search_c4 = "주머니에서 노트를 발견했습니다. {num} 번의 선을 자르면 C4를 해체할 수 있다고 써있군요."

L.search_dmg_crush = "매우 많은 뼈가 부러져 있습니다. 무거운 물체로 얻어맞은 것 같네요."
L.search_dmg_bullet = "확실하게 총을 맞아 사망했습니다."
L.search_dmg_fall = "떨어져 사망했습니다."
L.search_dmg_boom = "옷이 처참하게 찢긴 걸 보니 폭발로 사망한게 확실하군요."
L.search_dmg_club = "멍들고, 어딘가 부러져있습니다. 어떤 둔기로 격살당했군요."
L.search_dmg_drown = "익사의 흔적이 보이는 시체입니다."
L.search_dmg_stab = "찌르고, 잘린 흔적이 있습니다. 죽기 전에 치명적인 출혈이 있었군요."
L.search_dmg_burn = "여기서 탄 테러리스트 냄새가 났던거군요..."
L.search_dmg_teleport = "타키온 방출로 인해 DNA가 뒤섞였네요!"
L.search_dmg_car = "무신경한 운전자에게 치여 사망했습니다."
L.search_dmg_other = "어떻게 죽었는지 모르겠네요."

L.search_floor_antlions = "몸 구석구석 개미귀신 찌꺼기가 묻어있네요. 바닥에도요."
L.search_floor_bloodyflesh = "이 시체의 핏자국은 오래되고 역겨운 냄새를 풍깁니다. 심지어는 신발에도 피 묻은 살점이 있네요."
L.search_floor_concrete = "회색 먼지가 신발과 무릎에 있군요. 피해자는 콘크리트 바닥에서 살해당한 것 같습니다."
L.search_floor_dirt = "흙 냄새가 나네요. 피해자의 신발에 있는 진흙이 그 이유인것 같습니다."
L.search_floor_eggshell = "피해자의 몸 전체에 흰색 작은 물체들이 덮여 있습니다. 알껍질처럼 보입니다."
L.search_floor_flesh = "피해자의 옷이 축축한 느낌이군요. 살 같은 표면에 쓰러진 것 같습니다."
L.search_floor_grate = "희생자의 피부가 스테이크처럼 되었군요. 격자모양의 두꺼운 무늬가 보입니다. 바베큐 그릴 위에서 죽었을까요?"
L.search_floor_alienflesh = "외계 생물의 살? 이야기가 좀 기묘하군요. 하지만 탐정 책에는 있을법한 일로 기록되어 있군요."
L.search_floor_snow = "처음에는 옷이 젖어있고 얼어붙기만 한 것 같았습니다. 하지만 옷자락에 흰 물체가 보이면서 눈이 떠졌습니다. 눈에서 죽었습니다!"
L.search_floor_plastic = "이것 참 아팠겠군요. 피해자의 몸이 전체적으로 화상을 입었습니다. 아마 플라스틱같은 표면에서 쓸린것일지도요?"
L.search_floor_metal = "죽어서 파상풍에 걸릴 일은 없겠네요. 상처들에 녹 가루들이 있습니다. 금속 위에서 죽었군요."
L.search_floor_sand = "작고 거친 조각들이 몸에 붙어있군요. 마치 해변의 모래처럼요."
L.search_floor_foliage = "자연은 역시 대단합니다. 상처들이 나뭇잎에 가려 잘 보이지 않습니다."
L.search_floor_computer = "삡-삡, 컴퓨터 케이스 플라스틱 쪼가리들이 시체에 붙어있군요."
L.search_floor_slosh = "젖었고, 미끈거리는군요. 전신이 미끌거리는 물체로 덮여 있으며 옷도 젖어 있습니다. 어우 냄새야!"
L.search_floor_tile = "파편들이 피부에 붙어 있습니다. 마치 바닥 타일이 깨진 조각들 같습니다."
L.search_floor_grass = "풀 냄새가 납니다. 피 냄새를 가릴 정도입니다."
L.search_floor_vent = "몸을 만졌을 때 차가운 감이 듭니다. 바람과 같이 환풍구에서 죽었을까요?"
L.search_floor_wood = "나무 바닥에 앉아 몽상하는 것 보다 더 좋은건? 나무 바닥 위에서 죽는거지요."
L.search_floor_default = "너무 평범해 보입니다. 거의 기본 설정처럼요. 표면의 종류에 대해 아무것도 말할 수 없군요."
L.search_floor_glass = "몸에 많은 상처들이 있네요. 상처에 유리 파편들이 박혀있어서 위험해 보이네요."
L.search_floor_warpshield = "워프실드라고요? 매우 혼란스럽군요. 하지만 탐정 노트에 명확히 기재되어 있습니다. 워프실드군요."

L.search_water_1 = "피해자의 신발은 젖어 있지만 나머지는 말라 있군요. 아마 발치에만 물이 있었던것 같습니다."
L.search_water_2 = "피해자의 신발과 바지는 젖어있군요. 죽기전에 물이라도 건넌걸까요?"
L.search_water_3 = "전신이 젖어있고 부어오른 상태입니다. 물 속에 잠긴 상태로 죽은 것 같습니다."

L.search_weapon = "죽이는데 {weapon}가 사용된 것 같습니다."
L.search_head = "치명상은 헤드샷이었습니다. 비명을 지를 시간도 없었습니다."
L.search_time = "수색 하기도 전에 죽어있었습니다."
L.search_dna = "DNA 스캐너로 가해자의 DNA 샘플을 획득하세요. 그러나 DNA 샘플은 시간이 지남에 따라 부패합니다."

L.search_kills1 = "이 사람이 죽인 목록입니다. {player}."
L.search_kills2 = "이 사람이 죽인 목록입니다. : {player}"
L.search_eyes = "탐정의 시각으로, 마지막으로 이 사람이 본 사람은 : {player} 입니다. 살인자일까요? 우연일까요?"

L.search_credits = "피해자는 {credits} 개의 크레딧을 가지고 있었습니다. 상점을 이용 가능한 직업은 이 크레딧을 가져 갈 수 있습니다. 시체 잘 지키세요!"

L.search_kill_distance_point_blank = "초근거리에서 맞아 죽었습니다."
L.search_kill_distance_close = "중거리에서 맞아 죽었습니다."
L.search_kill_distance_far = "원거리에서 맞아 죽었습니다."

L.search_kill_from_front = "정면에서 맞아 죽었습니다."
L.search_kill_from_back = "뒤에서 맞아 죽었습니다."
L.search_kill_from_side = "옆에서 맞아 죽었습니다."

L.search_hitgroup_head = "발사체가 머리에서 발견되었습니다."
L.search_hitgroup_chest = "발사체가 가슴에서 발견되었습니다."
L.search_hitgroup_stomach = "발사체가 배에서 발견되었습니다."
L.search_hitgroup_rightarm = "발사체가 오른쪽 팔에서 발견되었습니다."
L.search_hitgroup_leftarm = "발사체가 왼쪽 팔에서 발견되었습니다."
L.search_hitgroup_rightleg = "발사체가 오른쪽 팔에서 발견되었습니다."
L.search_hitgroup_leftleg = "발사체가 다리에서 발견되었습니다."
L.search_hitgroup_gear = "발사체가 둔부에서 발견되었습니다."

L.search_policingrole_report_confirm = [[
사망이 확인된 후에만 탐정을 부를 수 있습니다.]]
L.search_policingrole_confirm_disabled_1 = [[
시체는 탐정만 확인할 수 있습니다. 탐정에게 알리기 위해 시체를 신고하세요!]]
L.search_policingrole_confirm_disabled_2 = [[
시체는 탐정만 확인할 수 있습니다. 탐정에게 알리기 위해 시체를 신고하세요!
탐정이 확인 후 여기서 정보를 볼 수 있습니다.]]
L.search_spec = [[
관전자로 시체를 확인 할 수는 있지만, 시체를 신고하는 등의 행위를 하지는 못합니다.]]

L.search_title_words = "피해자의 유언"
L.search_title_c4 = "해체 실수"
L.search_title_dmg_crush = "깔린 피해 ({amount} HP)"
L.search_title_dmg_bullet = "탄환 피해 ({amount} HP)"
L.search_title_dmg_fall = "낙하 피해 ({amount} HP)"
L.search_title_dmg_boom = "폭발 피해 ({amount} HP)"
L.search_title_dmg_club = "둔기 피해 ({amount} HP)"
L.search_title_dmg_drown = "익사 피해 ({amount} HP)"
L.search_title_dmg_stab = "찔린 피해 ({amount} HP)"
L.search_title_dmg_burn = "불 피해 ({amount} HP)"
L.search_title_dmg_teleport = "텔레포트 피해 ({amount} HP)"
L.search_title_dmg_car = "차 사고 ({amount} HP)"
L.search_title_dmg_other = "알 수 없는 피해 ({amount} HP)"
L.search_title_time = "사망 시간"
L.search_title_dna = "DNA 샘플 부패"
L.search_title_kills = "희생자의 킬 목록"
L.search_title_eyes = "살인자의 그림자"
L.search_title_floor = "사망 현장의 바닥"
L.search_title_credits = "{credits} 개의 크레딧"
L.search_title_water = "수위 {level}"
L.search_title_policingrole_report_confirm = "죽었음을 알리기"
L.search_title_policingrole_confirm_disabled = "시체를 보고하기"
L.search_title_spectator = "당신은 관전자입니다"

L.target_credits_on_confirm = "확인하여 사용하지 않은 크레딧 수거"
L.target_credits_on_search = "수색하여 사용하지 않은 크레딧 수거"
L.corpse_hint_no_inspect_details = "탐정만이 이 시체의 자세한 정보를 알 수 있습니다."
L.corpse_hint_inspect_limited_details = "탐정만이 이 시체를 확인 할 수 있습니다."
L.corpse_hint_spectator = "[{usekey}] 키를 눌러 시체 정보 확인"
L.corpse_hint_public_policing_searched = "[{usekey}] 키를 눌러 탐정이 알아낸 정보를 보기"

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
L.label_grenade_trajectory_ui = "수류탄 궤적 표시기"

-- 2023-10-23
L.label_hud_pulsate_health_enable = "체력이 25% 미만일 때 헬스바를 떨리게 표시."
L.header_hud_elements_customize = "HUD 커스터마이징하기"
L.help_hud_elements_special_settings = "HUD 요소들을 설정할 수 있습니다."

-- 2023-10-25
L.help_keyhelp = [[
키 바인드 도우미는 플레이어에게 항상 관련된 키 바인딩을 보여주는 UI 요소입니다. 새로운 플레이어들에게 유용합니다. 세 가지 종류의 키 바인딩이 있습니다:

핵심: TTT2에서 가장 중요한 바인드을 포함합니다. 이 바인딩이 없으면 게임을 완전히 플레이하기 어려울 수 있습니다.

추가: 핵심과 유사하지만 항상 필요하지는 않습니다. 채팅, 음성 또는 손전등과 같은 것들이 포함됩니다.

장비: 일부 장비 아이템들은 자체 바인드를 가지고 있습니다. 이러한 바인드는 이 카테고리에서 표시됩니다.

비활성화된 카테고리는 스코어보드가 표시될 때에도 여전히 보여집니다.]]

L.label_keyhelp_show_core = "핵심 바인딩을 항상 표시하도록 설정."
L.label_keyhelp_show_extra = "추가 바인딩을 항상 표시하도록 설정"
L.label_keyhelp_show_equipment = "장비 바인딩을 항상 표시하도록 설정"

L.header_interface_keys = "키 도우미 설정"
L.header_interface_wepswitch = "무기 변경 UI 설정"

L.label_keyhelper_help = "게임모드 매뉴 열기"
L.label_keyhelper_mutespec = "관전자 보이스 모드 바꾸기"
L.label_keyhelper_shop = "장비 상점 열기"
L.label_keyhelper_show_pointer = "마우스 포인터 보이기"
L.label_keyhelper_possess_focus_entity = "엔티티에 빙의하기"
L.label_keyhelper_spec_focus_player = "플레이어 관전하기"
L.label_keyhelper_spec_previous_player = "이전 플레이어"
L.label_keyhelper_spec_next_player = "다음 플레이어"
L.label_keyhelper_spec_player = "아무 플레이어나 관전하기"
L.label_keyhelper_possession_jump = "프롭 점프"
L.label_keyhelper_possession_left = "프롭 왼쪽으로"
L.label_keyhelper_possession_right = "프롭 오른쪽으로"
L.label_keyhelper_possession_forward = "프롭 전진"
L.label_keyhelper_possession_backward = "프롭 후진"
L.label_keyhelper_free_roam = "프롭에서 나와서 자유롭게 돌아다니기"
L.label_keyhelper_flashlight = "손전등 토글"
L.label_keyhelper_quickchat = "퀵챗 열기"
L.label_keyhelper_voice_global = "글로벌 보이스 챗"
L.label_keyhelper_voice_team = "팀 보이스 챗"
L.label_keyhelper_chat_global = "글로벌 채팅"
L.label_keyhelper_chat_team = "팀 채팅"
L.label_keyhelper_show_all = "모두 보이기"
L.label_keyhelper_disguiser = "변장 기구 활성화"
L.label_keyhelper_save_exit = "저장/종료"
L.label_keyhelper_spec_third_person = "3인칭 모드 활성화"

-- 2023-10-26
L.item_armor_reinforced = "강화된 방탄복"
L.item_armor_sidebar = "총알을 막아줍니다. 영원히 가지는 않습니다."
L.item_disguiser_sidebar = "변장 기구는 당신의 신원이 다른사람들에게 보여지는걸 막아줍니다."
L.status_speed_name = "속도 배수"
L.status_speed_description_good = "평소보다 빠릅니다. 장비나 아이템의 개수가 이 수치를 조정합니다."
L.status_speed_description_bad = "평소보다 느립니다. 장비나 아이템의 개수가 이 수치를 조정합니다."

L.status_on = "키기"
L.status_off = "끄기"

L.crowbar_help_primary = "공격"
L.crowbar_help_secondary = "밀치기"

-- 2023-10-27
L.help_HUD_enable_description = [[
스코어보드가 열려 있을 때 키 도우미나 사이드바와 같은 일부 HUD 요소는 자세한 정보를 보여줍니다. 이를 비활성화하여 혼란을 줄일 수 있습니다.]]
L.label_HUD_enable_description = "스코어보드 열렸을때 설명 키기"
L.label_HUD_enable_box_blur = "UI 박스 백그라운드 블러 키기"

-- 2023-10-28
L.submenu_gameplay_voiceandvolume_title = "보이스 & 볼륨"
L.header_soundeffect_settings = "사운드 효과"
L.header_voiceandvolume_settings = "보이스 & 볼륨 설정"

-- 2023-11-06
L.drop_reserve_prevented = "무언가 탄약을 떨어트리는걸 방해하고 있습니다."
L.drop_no_reserve = "탄약을 떨어트릴 탄약이 부족합니다."
L.drop_no_room_ammo = "탄약을 떨어트릴 공간이 없습니다!"

-- 2023-11-14
L.hat_deerstalker_name = "탐정의 모자"

-- 2023-11-16
L.help_prop_spec_dash = [[
프롭의 대쉬는 에임방향 쪽으로 대쉬합니다. 일반 이동보다 더 빠르게 움직일 수 있습니다.

이 변수는 밀치는힘 배율을 따라갑니다.]]
L.label_spec_prop_dash = "프로 대쉬 배율"
L.label_keyhelper_possession_dash = "프롭: 보는 방향으로 대쉬하기"
L.label_keyhelper_weapon_drop = "가능하다면 선택된 무기를 버립니다."
L.label_keyhelper_ammo_drop = "선택한 무기의 탄약을 버립니다."

-- 2023-12-07
L.c4_help_primary = "C4 설치"
L.c4_help_secondary = "표면에 부착하기"

-- 2023-12-11
L.magneto_help_primary = "엔티티 밀치기"
L.magneto_help_secondary = "엔티티 당기기/줍기"
L.knife_help_primary = "찌르기"
L.knife_help_secondary = "칼 던지기"
L.polter_help_primary = "썸퍼 발사"
L.polter_help_secondary = "원거리 사격 충전"

-- 2023-12-12
L.newton_help_primary = "밀치기 사격"
L.newton_help_secondary = "충전된 밀치기 사격"

-- 2023-12-13
L.vis_no_pickup = "비주얼라이저는 탐정만 주울 수 있습니다."
L.newton_force = "힘"
L.defuser_help_primary = "C4 해체하기"
L.radio_help_primary = "라디오 설치하기"
L.radio_help_secondary = "표면에 부착하기"
L.hstation_help_primary = "헬스 스테이션 배치하기"
L.flaregun_help_primary = "엔티티/시체 태우기"

-- 2023-12-14
L.marker_vision_owner = "소유자: {owner}"
L.marker_vision_distance = "거리: {distance}"
L.marker_vision_distance_collapsed = "{distance}"

L.c4_marker_vision_time = "폭파 시간: {time}"
L.c4_marker_vision_collapsed = "{time} / {distance}"

L.c4_marker_vision_safe_zone = "C4 안전 구역"
L.c4_marker_vision_damage_zone = "C4 데미지 구역"
L.c4_marker_vision_kill_zone = "C4 사망 구역"

L.beacon_marker_vision_player = "플레이어 쫒기"
L.beacon_marker_vision_player_tracked = "이 플레이어는 비콘에 의해 추적되고 있습니다."

-- 2023-12-18
L.beacon_help_pri = "신호기를 바닥에 놓기"
L.beacon_help_sec = "바닥에 신호기 설치"
L.beacon_name = "신호기"
L.beacon_desc = [[
신호기 주변에 있는 사람들의 위치를 모두에게 알립니다.

잘 보이지 않는 맵에서 추적하는 데 사용하세요.]]

L.msg_beacon_destroyed = "신호기중 하나가 파괴되었습니다!"
L.msg_beacon_death = "누군가 당신 신호기 근처에서 사망했습니다."

L.beacon_short_desc = "신호기는 탐정이 제한된 월핵을 사용할 수 있게끔 합니다."

L.entity_pickup_owner_only = "주인만 주울 수 있습니다."

L.body_confirm_one = "{finder} 가 {victim} 의 사망을 확인했습니다."
L.body_confirm_more = "{finder} 가 {count} 명의 사망을 확인했습니다. 사망자: {victims}."

-- 2023-12-19
L.builtin_marker = "빌트인"
L.equipmenteditor_desc_builtin = "이 장비는 빌트인입니다. 기본 TTT2에 포함되어 있습니다!"
L.help_roles_builtin = "이 역할은 빌트인입니다. 기본 TTT2에 포함되어 있습니다"
L.header_equipment_info = "장비 정보"

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
L.submenu_gameplay_accessibility_title = "접근성"

L.header_accessibility_settings = "접근성 설정"

L.label_enable_dynamic_fov = "다이나믹 FOV 키기"
L.label_enable_bobbing = "카메라 움직임 키기"
L.label_enable_bobbing_strafe = "마우스 회전 시 카메라 움직임 키기"

L.help_enable_dynamic_fov = "플레이어의 속도에 FOV가 적용됩니다. 예를 들어, 플레이어가 이동할 때 FOV가 증가하여 속도를 시각적으로 나타냅니다."
L.help_enable_bobbing_strafe = "걷거나 수영하거나 떨어질 때 약간의 카메라 흔들림을 표현합니다."

L.binoc_help_reload = "타겟 초기화."
L.cl_sb_row_sresult_direct_conf = "직접 확인"
L.cl_sb_row_sresult_pub_police = "탐정 확인"

-- 2024-01-05
L.label_crosshair_thickness_outline_enable = "크로스헤어 외곽선 설정"
L.label_crosshair_outline_high_contrast = "외곽선 고대비 색 활성화"
L.label_crosshair_mode = "크로스헤어 모드"
L.label_crosshair_static_length = "정적 크로스헤어 활성화"

L.choice_crosshair_mode_0 = "선과 점"
L.choice_crosshair_mode_1 = "선"
L.choice_crosshair_mode_2 = "점"

L.help_crosshair_scale_enable = [[
동적 크로스헤어는 무기의 명중률에 따라 크로스헤어를 조정합니다. 크기는 무기의 기본 정확도에 영향을 받으며, 점프나 달리기와 같은 외부 요인에 인해서 더 커집니다.
]]

L.header_weapon_settings = "무기 설정"

-- 2024-01-24
L.grenade_fuse = "퓨즈"

-- 2024-01-25
L.header_roles_magnetostick = "자석 막대"
L.label_roles_ragdoll_pinning = "레그돌 핀 활성화"
L.magneto_stick_help_carry_rag_pin = "레그돌 핀"
L.magneto_stick_help_carry_rag_drop = "레그돌 떨어트리기"
L.magneto_stick_help_carry_prop_release = "프롭 놓기"
L.magneto_stick_help_carry_prop_drop = "프롭 떨어트리기"

-- 2024-01-27
L.decoy_help_primary = "바닥에 디코이 던지기"
L.decoy_help_secondary = "디코이 부착시키기"


L.marker_vision_visible_for_0 = "당신한테만 보임"
L.marker_vision_visible_for_1 = "당신 역할에만 보임"
L.marker_vision_visible_for_2 = "당신 팀에게만 보임"
L.marker_vision_visible_for_3 = "모두에게 보임"

-- 2024-02-14
L.throw_no_room = "이 장치를 떨어트릴 공간이 없습니다."

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
L.label_crosshair_static_gap_length = "정적 크로스헤어 활성화"
L.label_crosshair_size_gap = "크로스헤어 공간 배율"

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
