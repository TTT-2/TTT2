---
-- addonChecker to detect known incompatabilities.
-- @author saibotk
-- @author Mineotopia
-- @module addonChecker

ADDON_INCOMPATIBLE = 0
ADDON_OUTDATED = 1
TTT2_GMOD_MIN_VERSION = 240313

addonChecker = addonChecker or {}

addonChecker.curatedList = {
    ["656662924"] = { -- Killer Notifier by nerzlakai96
        alternative = "1367128301",
        reason = "Does not work with our role system.",
        type = ADDON_INCOMPATIBLE,
    },
    ["167547072"] = { -- Killer Notifier by StarFox
        alternative = "1367128301",
        reason = "Does not work with our role system.",
        type = ADDON_INCOMPATIBLE,
    },
    ["649273679"] = { -- Role Counter by Zaratusa
        alternative = "1367128301",
        reason = "Does not work with our role system.",
        type = ADDON_INCOMPATIBLE,
    },
    ["1531794562"] = { -- Killer Info by wurffl
        alternative = "1367128301",
        reason = "Does not work with our role system.",
        type = ADDON_INCOMPATIBLE,
    },
    ["257624318"] = { -- Killer info by DerRene
        alternative = "1367128301",
        reason = "Does not work with our role system.",
        type = ADDON_INCOMPATIBLE,
    },
    ["308966836"] = { -- Death Faker by Exho
        alternative = "1473581448",
        reason = "Does not work with our role system.",
        type = ADDON_INCOMPATIBLE,
    },
    ["922007616"] = { -- Death Faker by BocciardoLight
        alternative = "1473581448",
        reason = "Does not work with our role system.",
        type = ADDON_INCOMPATIBLE,
    },
    ["785423990"] = { -- Death Faker by markusmarkusz
        alternative = "1473581448",
        reason = "Does not work with our role system.",
        type = ADDON_INCOMPATIBLE,
    },
    ["236217898"] = { -- Death Faker by jayjayjay1
        alternative = "1473581448",
        reason = "Does not work with our role system.",
        type = ADDON_INCOMPATIBLE,
    },
    ["912181642"] = { -- Death Faker by w4rum
        alternative = "1473581448",
        reason = "Does not work with our role system.",
        type = ADDON_INCOMPATIBLE,
    },
    ["127865722"] = { -- TTT ULX by Bender180
        alternative = "1362430347",
        reason = "All TTT2 features are missing from this version.",
        type = ADDON_INCOMPATIBLE,
    },
    ["305101059"] = { -- ID Bomb by MolagA
        type = ADDON_INCOMPATIBLE,
    },
    ["663328966"] = { -- damagelogs by Hundreth
        reason = "Breaks the TTT2 gamemode, alternative available here: https://github.com/Alf21/tttdamagelogs",
        type = ADDON_INCOMPATIBLE,
    },
    ["404599106"] = { -- SpectatorDeathmatch by P4sca1 [EGM]
        alternative = "1997666028",
        reason = "Breaks the TTT2 gamemode.",
        type = ADDON_INCOMPATIBLE,
    },
    ["1376434172"] = { -- Golden Deagle by DaniX_Chile
        alternative = "1398388611",
        reason = "Does not work with our role system.",
        type = ADDON_INCOMPATIBLE,
    },
    ["1434026961"] = { -- Golden Deagle by Mangonaut
        alternative = "1398388611",
        reason = "Does not work with our role system.",
        type = ADDON_INCOMPATIBLE,
    },
    ["303535203"] = { -- Golden Deagle by Navusaur
        alternative = "1398388611",
        reason = "Does not work with our role system.",
        type = ADDON_INCOMPATIBLE,
    },
    ["1325415810"] = { -- Golden Deagle by Faedon | Max
        alternative = "1398388611",
        reason = "Does not work with our role system.",
        type = ADDON_INCOMPATIBLE,
    },
    ["648505481"] = { -- Golden Deagle by TypicalRookie
        alternative = "1398388611",
        reason = "Does not work with our role system.",
        type = ADDON_INCOMPATIBLE,
    },
    ["659643589"] = { -- Golden Deagle by 中國是同性戀
        alternative = "1398388611",
        reason = "Does not work with our role system.",
        type = ADDON_INCOMPATIBLE,
    },
    ["828347015"] = { -- TTT Totem by Gamefreak
        alternative = "1566390281",
        reason = "Has its own role selection system.",
        type = ADDON_INCOMPATIBLE,
    },
    ["644532564"] = { -- TTT Totem Content by Gamefreak
        type = ADDON_INCOMPATIBLE,
    },
    ["1092556189"] = { -- Town of Terror by Jenssons
        reason = "Inferior role selection system that breaks TTT2.",
        type = ADDON_INCOMPATIBLE,
    },
    ["1215502383"] = { -- Custom Roles by Noxx
        reason = "Inferior role selection system that breaks TTT2.",
        type = ADDON_INCOMPATIBLE,
    },
    ["886346394"] = { -- Identity Swapper by Lesh
        reason = "Overwrites the targetID gamemode function and therefore removes the TTT2 targetID.",
        type = ADDON_INCOMPATIBLE,
    },
    ["844284735"] = { -- Identity Swapper by Saty
        reason = "Overwrites the targetID gamemode function and therefore removes the TTT2 targetID.",
        type = ADDON_INCOMPATIBLE,
    },
    ["1382102057"] = { -- Thanos's Infinity Gauntlet SWEP and Model
        reason = "Sets everybodies sprintspeed quite high.",
        type = ADDON_INCOMPATIBLE,
    },
    ["1757151213"] = { -- Random Shop by Lupus
        reason = "Random shop is already included in TTT2.",
        type = ADDON_INCOMPATIBLE,
    },
    ["481440358"] = { -- Drowning Indicator by Moe
        reason = "A drowning indicator is already included in TTT2.",
        type = ADDON_INCOMPATIBLE,
    },
    ["933056549"] = { -- Sprint by Fresh Garry
        reason = "A sprinting system is already included in TTT2.",
        type = ADDON_INCOMPATIBLE,
    },
    ["1729301513"] = { -- Sprint by Lesh
        reason = "A sprinting system is already included in TTT2.",
        type = ADDON_INCOMPATIBLE,
    },
    ["367945571"] = { -- Advanced Body Search by Mr Trung
        reason = "This addon breaks the whole body confirmation system.",
        type = ADDON_INCOMPATIBLE,
    },
    ["878772496"] = { -- BEM by Long Long Longson
        reason = "A reworked shop is already part of TTT2.",
        type = ADDON_INCOMPATIBLE,
    },
    ["1107420703"] = { -- BEM by Fresh Garry
        reason = "A reworked shop is already part of TTT2.",
        type = ADDON_INCOMPATIBLE,
    },
    ["290961117"] = { -- Destructible Doors by Exho
        reason = "Breakable doors are already a part of TTT2 that can be enabled with a convar. This addon has also problems with area portals in some doors.",
        type = ADDON_INCOMPATIBLE,
    },
    ["606792331"] = { -- Advanced disguiser by Gamefreak
        alternative = "2144375749",
        reason = "Does not work with TTT2 targetID.",
        type = ADDON_INCOMPATIBLE,
    },
    ["610632051"] = { -- Advanced disguiser by Killberty
        alternative = "2144375749",
        reason = "Does not work with TTT2 targetID.",
        type = ADDON_INCOMPATIBLE,
    },
    ["375989005"] = { -- Jihad bomb by Roy301
        alternative = "254177214",
        reason = "Breaks the equipment shop.",
        type = ADDON_INCOMPATIBLE,
    },
    ["1729451064"] = { -- TTT - More Melee Weapons by Solrob
        reason = "Overwrites stock TTT2 crowbar which causes problems with doors and ttt_map_settings entity.",
        type = ADDON_INCOMPATIBLE,
    },
    ["2912756384"] = { -- TTT ProofOfConcept InnocentTasks by Emzatin.
        reason = "Overwrites stock TTT2 crowbar which causes problems with doors and ttt_map_settings entity.",
        type = ADDON_INCOMPATIBLE,
    },
    ["1961869471"] = { -- [TTT/2] Crowbar to throwable Crowbar by GengarDC
        reason = "Overwrites stock TTT2 crowbar which causes problems with doors and ttt_map_settings entity.",
        type = ADDON_INCOMPATIBLE,
    },
    ["1629273484"] = { -- ttt_broken_hand_fix by Jolez
        reason = "Already built in into TTT2",
        type = ADDON_INCOMPATIBLE,
    },
    ["2990353959"] = { -- Weapon Spawn Ratio Mod by Corvatile
        reason = "Breaks random weapon spawns by overwriting the random weapon entity.",
        type = ADDON_INCOMPATIBLE,
    },
    ["2705642928"] = { -- Graffiti by Leeroy
        reason = "This addon doesn't use the TTT base correctly and also causes sound and broken playermodel issues.",
        type = ADDON_INCOMPATIBLE,
    },
    ["2795122660"] = { -- TTT Weapon Rework by wget
        reason = "This addon messes with some core TTT(2) functions, creating issues like corpses being recognized as 'fake' even though they are not.",
        type = ADDON_INCOMPATIBLE,
    },
    ["456247192"] = { -- TTT Coffee-Cup Hunt by Niandra!
        alternative = "2150924507",
        reason = "Addon is broken and doesn't do anything.",
        type = ADDON_OUTDATED,
    },
    ["1125892999"] = { -- TTT Coffee-Cup Hunt by Niandra!
        alternative = "2150924507",
        reason = "Addon is broken and doesn't do anything.",
        type = ADDON_OUTDATED,
    },
    ["654341247"] = { -- Clairvoyancy by Liberty
        alternative = "1637001449",
        reason = "Does not use the TTT2 sidebar system.",
        type = ADDON_OUTDATED,
    },
    ["130051756"] = { -- Spartan Kick by uacnix
        alternative = "1584675927",
        reason = "Broken area portals in some doors and improved use of TTT2 systems.",
        type = ADDON_OUTDATED,
    },
    ["122277196"] = { -- Spartan Kick by Chowder908
        alternative = "1584675927",
        reason = "Broken area portals in some doors and improved use of TTT2 systems.",
        type = ADDON_OUTDATED,
    },
    ["922510848"] = { -- Spartan Kick by BocciardoLight
        alternative = "1584675927",
        reason = "Broken area portals in some doors and improved use of TTT2 systems.",
        type = ADDON_OUTDATED,
    },
    ["282584080"] = { -- Spartan Kick by Porter
        alternative = "1584675927",
        reason = "Broken area portals in some doors and improved use of TTT2 systems.",
        type = ADDON_OUTDATED,
    },
    ["1092632443"] = { -- Spartan Kick by Jenssons
        alternative = "1584675927",
        reason = "Broken area portals in some doors and improved use of TTT2 systems.",
        type = ADDON_OUTDATED,
    },
    ["1523332573"] = { -- Thomas by Tubner
        alternative = "2024902834",
        reason = "Broken models, sounds and damage inflictor info.",
        type = ADDON_OUTDATED,
    },
    ["962093923"] = { -- Thomas by ThunfischArnold
        alternative = "2024902834",
        reason = "Broken models, sounds and damage inflictor info.",
        type = ADDON_OUTDATED,
    },
    ["1479128258"] = { -- Thomas by JollyJelly1001
        alternative = "2024902834",
        reason = "Broken models, sounds and damage inflictor info.",
        type = ADDON_OUTDATED,
    },
    ["1390915062"] = { -- Thomas by Doc Snyder
        alternative = "2024902834",
        reason = "Broken models, sounds and damage inflictor info.",
        type = ADDON_OUTDATED,
    },
    ["1171584841"] = { -- Thomas by Maxdome
        alternative = "2024902834",
        reason = "Broken models, sounds and damage inflictor info.",
        type = ADDON_OUTDATED,
    },
    ["811718553"] = { -- Thomas by Mr C Funk
        alternative = "2024902834",
        reason = "Broken models, sounds and damage inflictor info.",
        type = ADDON_OUTDATED,
    },
    ["922355426"] = { -- Melon Mine by Phoenixf129
        alternative = "1629914760",
        reason = "Doesn't really work with the TTT2 role system.",
        type = ADDON_OUTDATED,
    },
    ["960077088"] = { -- Melon Mine by TheSoulrester
        alternative = "1629914760",
        reason = "Doesn't really work with the TTT2 role system.",
        type = ADDON_OUTDATED,
    },
    ["309299668"] = { -- Martyrdom by Exho
        alternative = "1630269736",
        reason = "Does not use the TTT2 sidebar system.",
        type = ADDON_OUTDATED,
    },
    ["899206223"] = { -- Martyrdom by Koksgesicht
        alternative = "1630269736",
        reason = "Does not use the TTT2 sidebar system.",
        type = ADDON_OUTDATED,
    },
    ["652046425"] = { -- Juggernaut Suit by Zaratusa
        alternative = "2157829981",
        reason = "Does not use the TTT2 sidebar system.",
        type = ADDON_OUTDATED,
    },
    ["650523807"] = { -- Lucky Horseshoe by Zaratusa
        alternative = "2157888469",
        reason = "Does not use the TTT2 sidebar system.",
        type = ADDON_OUTDATED,
    },
    ["650523765"] = { -- Hermes Boots by Zaratusa
        alternative = "2157850255",
        reason = "Does not use the TTT2 sidebar system.",
        type = ADDON_OUTDATED,
    },
    ["1470823315"] = { -- Beartrap by Milkwater
        alternative = "1641605106",
        reason = "Has some problems with damage after roundend and doesn't use the TTT2 sidebar system.",
        type = ADDON_OUTDATED,
    },
    ["407751746"] = { -- Beartrap by Nerdhive
        alternative = "1641605106",
        reason = "Has some problems with damage after roundend and doesn't use the TTT2 sidebar system.",
        type = ADDON_OUTDATED,
    },
    ["273623128"] = { -- zombie perk bottles by Hoff
        alternative = "2243578658",
        type = ADDON_OUTDATED,
    },
    ["1387914296"] = { -- zombie perk bottles by Schmitler
        alternative = "2243578658",
        type = ADDON_OUTDATED,
    },
    ["1371596971"] = { -- zombie perk bottles by Amenius
        alternative = "2243578658",
        type = ADDON_OUTDATED,
    },
    ["860794236"] = { -- zombie perk bottles by Menzek
        alternative = "2243578658",
        type = ADDON_OUTDATED,
    },
    ["1198504029"] = { -- zombie perk bottles by RedocPlays
        alternative = "2243578658",
        type = ADDON_OUTDATED,
    },
    ["911658617"] = { -- zombie perk bottles by Luchix
        alternative = "2243578658",
        type = ADDON_OUTDATED,
    },
    ["869353740"] = { -- zombie perk bottles by Railroad Engineer 111
        alternative = "2243578658",
        type = ADDON_OUTDATED,
    },
    ["842302491"] = { -- zombie perk bottles by Hagen
        alternative = "2243578658",
        reason = "Rebalancing, fixing stamin-up, UI integration.",
        type = ADDON_OUTDATED,
    },
    ["662342819"] = { -- randomat by hagen
        alternative = "2266894222",
        reason = "TTT2 Minigames randomat is more powerful, streamlined and cleaned up. Use TTT2 minigames, minigame packs and the TTT2 Randomat.",
        type = ADDON_OUTDATED,
    },
    ["1398629839"] = { -- randomat by GhostPhanom
        alternative = "2266894222",
        reason = "TTT2 Minigames randomat is more powerful, streamlined and cleaned up. Use TTT2 minigames, minigame packs and the TTT2 Randomat.",
        type = ADDON_OUTDATED,
    },
    ["1244828603"] = { -- randomat by SnowSoulAngel
        alternative = "2266894222",
        reason = "TTT2 Minigames randomat is more powerful, streamlined and cleaned up. Use TTT2 minigames, minigame packs and the TTT2 Randomat.",
        type = ADDON_OUTDATED,
    },
    ["2037019426"] = { -- randomat by HyruleKrieger
        alternative = "2266894222",
        reason = "TTT2 Minigames randomat is more powerful, streamlined and cleaned up. Use TTT2 minigames, minigame packs and the TTT2 Randomat.",
        type = ADDON_OUTDATED,
    },
    ["1406495040"] = { -- randomat 2.0 by Abi
        alternative = "2266894222",
        reason = "TTT2 Minigames randomat is more powerful, streamlined and cleaned up. Use TTT2 minigames, minigame packs and the TTT2 Randomat.",
        type = ADDON_OUTDATED,
    },
    ["2055805086"] = { -- randomat 2.0 for CR by Malivil
        alternative = "2266894222",
        reason = "TTT2 Minigames randomat is more powerful, streamlined and cleaned up. Use TTT2 minigames, minigame packs and the TTT2 Randomat.",
        type = ADDON_OUTDATED,
    },
    ["671603913"] = { -- Space and Time manipulator by Hagen
        alternative = "2237612513",
        reason = "Improved integration into TTT2 systems.",
        type = ADDON_OUTDATED,
    },
    ["1558020463"] = { -- TTT - Thanos Snap by Pocable
        alternative = "1837434311",
        reason = "Improved integration into TTT2 systems and viewmodels.",
        type = ADDON_OUTDATED,
    },
    ["1466843055"] = { -- [TTT] - Teleport Gun - Fixed version by cookie
        alternative = "931856840",
        reason = "Jazz fixed their original addon.",
        type = ADDON_OUTDATED,
    },
    ["590909626"] = { -- Handcuffs by porter
        alternative = "2401563697",
        reason = "Broken handcuffs that don't do anything or make the game unplayable.",
        type = ADDON_OUTDATED,
    },
    ["2249861635"] = { -- Handcuffs by Malivil
        alternative = "2401563697",
        reason = "Doesn't use the targetID system of TTT2",
        type = ADDON_OUTDATED,
    },
    ["2124909686"] = { -- Handcuffs by DJ Bat
        alternative = "2401563697",
        reason = "Doesn't use the targetID system of TTT2",
        type = ADDON_OUTDATED,
    },
    ["1667876426"] = { -- Handcuffs by Wokki
        alternative = "2401563697",
        reason = "Doesn't use the targetID system of TTT2",
        type = ADDON_OUTDATED,
    },
    ["1190286764"] = { -- Handcuffs 2 by porter
        alternative = "2401563697",
        reason = "Doesn't use the targetID system of TTT2",
        type = ADDON_OUTDATED,
    },
    ["310403937"] = { -- Prop Disguiser by Exho
        alternative = "2127939503",
        type = ADDON_OUTDATED,
    },
    ["843092697"] = { -- Prop Disguiser by Soren
        alternative = "2127939503",
        type = ADDON_OUTDATED,
    },
    ["937535488"] = { -- Prop Disguiser by St Addi
        alternative = "2127939503",
        type = ADDON_OUTDATED,
    },
    ["1168304202"] = { -- Prop Disguiser by Izellix
        alternative = "2127939503",
        type = ADDON_OUTDATED,
    },
    ["1361103159"] = { -- Prop Disguiser by Derp altamas
        alternative = "2127939503",
        type = ADDON_OUTDATED,
    },
    ["1301826793"] = { -- Prop Disguiser by Akechi
        alternative = "2127939503",
        type = ADDON_OUTDATED,
    },
    ["1662844145"] = { -- Prop Disguiser by TeamAlgee
        alternative = "2127939503",
        type = ADDON_OUTDATED,
    },
    ["254779132"] = { -- Dead Ringer by Porter
        alternative = "3074845055",
        reason = "HUD elements clash with TTT2 HUD on certain scales, doesn't integrate with TTT2 features such as corpses, UI, bindings.",
        type = ADDON_OUTDATED,
    },
    ["922459145"] = { -- Explosive Corpse by Bocciardo Light
        alternative = "2664879356",
        reason = "Corpse integration with TargetID, correct key input detection, teammates see where boombodies are located, etc.",
        type = ADDON_OUTDATED,
    },
    ["359372950"] = { -- Explosive Corpse by Daywalker
        alternative = "2664879356",
        reason = "Corpse integration with TargetID, correct key input detection, teammates see where boombodies are located, etc.",
        type = ADDON_OUTDATED,
    },
    ["1553970745"] = { -- Explosive Corpse by DasNerdwork
        alternative = "2664879356",
        reason = "Corpse integration with TargetID, correct key input detection, teammates see where boombodies are located, etc.",
        type = ADDON_OUTDATED,
    },
    ["1315377462"] = { -- Dead Ringer by MuratYilderimTM
        alternative = "3074845055",
        reason = "HUD elements clash with TTT2 HUD on certain scales, doesn't integrate with TTT2 features such as corpses, UI, bindings.",
        type = ADDON_OUTDATED,
    },
    ["240281783"] = { -- Dead Ringer by Niandra
        alternative = "3074845055",
        reason = "HUD elements clash with TTT2 HUD on certain scales, doesn't integrate with TTT2 features such as corpses, UI, bindings.",
        type = ADDON_OUTDATED,
    },
    ["810154456"] = { -- Dead Ringer by Hagen
        alternative = "3074845055",
        reason = "HUD elements clash with TTT2 HUD on certain scales, doesn't integrate with TTT2 features such as corpses, UI, bindings.",
        type = ADDON_OUTDATED,
    },
    ["284419411"] = { -- Minifier by Lykrast
        alternative = "1896918348",
        reason = "Broken hitboxes and other problems. Also no integration in the TTT2 sidebar system.",
        type = ADDON_OUTDATED,
    },
    ["1338887971"] = { -- Minifier by Evan
        alternative = "1896918348",
        reason = "Broken hitboxes and other problems. Also no integration in the TTT2 sidebar system.",
        type = ADDON_OUTDATED,
    },
    ["1551396306"] = { -- Minifier by FaBe2
        alternative = "1896918348",
        reason = "Broken hitboxes and other problems. Also no integration in the TTT2 sidebar system.",
        type = ADDON_OUTDATED,
    },
    ["1354031183"] = { -- Minifier by SnowSoulAnget
        alternative = "1896918348",
        reason = "Broken hitboxes and other problems. Also no integration in the TTT2 sidebar system.",
        type = ADDON_OUTDATED,
    },
    ["1670942051"] = { -- Minifier by Not Jesus
        alternative = "1896918348",
        reason = "Broken hitboxes and other problems. Also no integration in the TTT2 sidebar system.",
        type = ADDON_OUTDATED,
    },
    ["1376141849"] = { -- Minifier by ---
        alternative = "1896918348",
        reason = "Broken hitboxes and other problems. Also no integration in the TTT2 sidebar system.",
        type = ADDON_OUTDATED,
    },
    ["1599819393"] = { -- Minifier by Coe
        alternative = "1896918348",
        reason = "Broken hitboxes and other problems. Also no integration in the TTT2 sidebar system.",
        type = ADDON_OUTDATED,
    },
    ["863963592"] = { -- Super Soda by ---
        alternative = "1815518231",
        reason = "Less bottles, no integration in TTT2 systems, generally buggy.",
        type = ADDON_OUTDATED,
    },
    ["2672799157"] = { -- Minifier by The Stig
        alternative = "1896918348",
        reason = "TTT2 integration.",
        type = ADDON_OUTDATED,
    },
    ["801433502"] = { -- Defibrillator by Minty
        alternative = "2115944312",
        reason = "Improved integration into TTT2 systems.",
        type = ADDON_OUTDATED,
    },
    ["162581348"] = { -- Defibrillator by Willox
        alternative = "2115944312",
        reason = "Improved integration into TTT2 systems.",
        type = ADDON_OUTDATED,
    },
    ["921953443"] = { -- Defibrillator by BocciardoLight
        alternative = "2115944312",
        reason = "Improved integration into TTT2 systems.",
        type = ADDON_OUTDATED,
    },
    ["785796753"] = { -- Defibrillator by Shiratori
        alternative = "2115944312",
        reason = "Improved integration into TTT2 systems.",
        type = ADDON_OUTDATED,
    },
    ["299479443"] = { -- Defibrillator by PixL
        alternative = "2115944312",
        reason = "Improved integration into TTT2 systems.",
        type = ADDON_OUTDATED,
    },
    ["1553970612"] = { -- Defibrillator by DasNedwork
        alternative = "2115944312",
        reason = "Improved integration into TTT2 systems.",
        type = ADDON_OUTDATED,
    },
    ["821963023"] = { -- Defibrillator by DarkIce
        alternative = "2115944312",
        reason = "Improved integration into TTT2 systems.",
        type = ADDON_OUTDATED,
    },
    ["1695163471"] = { -- Defibrillator by Mr. KobraX
        alternative = "2115944312",
        reason = "Improved integration into TTT2 systems.",
        type = ADDON_OUTDATED,
    },
    ["1563553647"] = { -- Defibrillator by _BLU
        alternative = "2115944312",
        reason = "Improved integration into TTT2 systems.",
        type = ADDON_OUTDATED,
    },
    ["1445820970"] = { -- Defibrillator by Mangonaut
        alternative = "2115944312",
        reason = "Improved integration into TTT2 systems.",
        type = ADDON_OUTDATED,
    },
    ["805980529"] = { -- Defibrillator by Musiker15
        alternative = "2115944312",
        reason = "Improved integration into TTT2 systems.",
        type = ADDON_OUTDATED,
    },
    ["422006754"] = { -- Defibrillator by Toxic_Terrorists
        alternative = "2115944312",
        reason = "Improved integration into TTT2 systems.",
        type = ADDON_OUTDATED,
    },
    ["840688276"] = { -- Defibrillator by Saty
        alternative = "2115944312",
        reason = "Improved integration into TTT2 systems.",
        type = ADDON_OUTDATED,
    },
    ["1198501844"] = { -- Defibrillator by Brannium
        alternative = "2115944312",
        reason = "Improved integration into TTT2 systems.",
        type = ADDON_OUTDATED,
    },
    ["1199113632"] = { -- Defibrillator by Brannium
        alternative = "2115944312",
        reason = "Improved integration into TTT2 systems.",
        type = ADDON_OUTDATED,
    },
    ["290945941"] = { -- Door Locker by Exho
        alternative = "2115945573",
        reason = "Improved integration into TTT2 systems and fixed area portal problems for some doors.",
        type = ADDON_OUTDATED,
    },
    ["1132650862"] = { -- Door Locker by Saiyajin ByTayro
        alternative = "2115945573",
        reason = "Improved integration into TTT2 systems and fixed area portal problems for some doors.",
        type = ADDON_OUTDATED,
    },
    ["672173225"] = { -- Second Chance by Hagen
        alternative = "2143268505",
        reason = "Doesn't use the TTT2 spawn and UI system.",
        type = ADDON_OUTDATED,
    },
    ["1361100842"] = { -- Door Locker by Altamas
        alternative = "2115945573",
        reason = "Improved integration into TTT2 systems and fixed area portal problems for some doors.",
        type = ADDON_OUTDATED,
    },
    ["922285407"] = { -- Spring mine by Phoenixf
        alternative = "3166539189",
        reason = "The addon is completely broken and doesn't work at all. Also this rework has better integration into TTT2 systems.",
        type = ADDON_OUTDATED,
    },
    ["611873052"] = { -- Mirror fate by Hagen
        alternative = "3229789817",
        reason = "Broken model, no UI feedback for affected people, no integration into TTT2 systems.",
        type = ADDON_OUTDATED,
    },
    ["340790912"] = { -- Mirror fate / Final hour by KhrumoX
        alternative = "3229789817",
        reason = "Broken model, no UI feedback for affected people, no integration into TTT2 systems.",
        type = ADDON_OUTDATED,
    },
    ["2000714335"] = { -- Mirror fate remix by Pocable
        alternative = "3229789817",
        reason = "Broken model, no UI feedback for affected people, no integration into TTT2 systems.",
        type = ADDON_OUTDATED,
    },
    ["1115379772"] = { -- Mirror fate by Steven3233
        alternative = "3229789817",
        reason = "Broken model, no UI feedback for affected people, no integration into TTT2 systems.",
        type = ADDON_OUTDATED,
    },
    ["899488990"] = { -- Mirror fate by Keksgesicht
        alternative = "3229789817",
        reason = "Broken model, no UI feedback for affected people, no integration into TTT2 systems.",
        type = ADDON_OUTDATED,
    },
    ["3118796974"] = { -- Death Note by Xopez
        alternative = "278185787",
        reason = "Old Addon got massive update and works now with TTT2. The version with the workaround will be discontinued.",
        type = ADDON_OUTDATED,
    },
    ["2758610950"] = { -- Death Note TTT2 Fixed Edition by pat201290
        alternative = "278185787",
        reason = "Prints only Detectives in TTT2. Roles are hard coded.",
        type = ADDON_OUTDATED,
    },
    ["110148946"] = { -- Death Note by SmokeTheBanana
        alternative = "278185787",
        reason = "Prints only Detectives in TTT2. Roles are hard coded.",
        type = ADDON_OUTDATED,
    },
}

---
-- This will iterate through all addons in a curated list to notify about known
-- incompatible / outdated addons and about a working alternative, if one exists.
-- @realm server
function addonChecker.Check()
    local addonTable = engine.GetAddons()

    print("")
    print("TTT2 ADDON CHECKER")
    print("=============================================================")
    print("")

    for i = 1, #addonTable do
        local addon = addonTable[i]
        if not addon.mounted then
            continue
        end

        local detectedAddon = addonChecker.curatedList[tostring(addon.wsid)]
        if not detectedAddon then
            continue
        end

        ErrorNoHalt(
            (
                (detectedAddon.type == ADDON_OUTDATED) and "Outdated add-on detected: "
                or "Incompatible add-on detected: "
            )
                .. addon.title
                .. "\n"
        )

        if detectedAddon.reason then
            print("Reason: " .. detectedAddon.reason .. "\n")
        end

        print(
            "--> Detected add-on: https://steamcommunity.com/sharedfiles/filedetails/?id="
                .. addon.wsid
                .. "\n"
        )

        if detectedAddon.alternative then
            print(
                "--> Alternative add-on: https://steamcommunity.com/sharedfiles/filedetails/?id="
                    .. detectedAddon.alternative
                    .. "\n"
            )
        end

        print("")
    end

    print("=============================================================")

    print("\n" .. "Current TTT2 version: " .. GAMEMODE.Version .. "\n")

    if tonumber(VERSION) < TTT2_GMOD_MIN_VERSION then
        ErrorNoHalt("Incompatible Garry's Mod version detected: " .. VERSION .. "\n" .. "\n")
    else
        print("Current Garry's Mod version: " .. VERSION .. "\n")
    end

    print(
        "Minimum required Garry's Mod version for TTT2 to work: " .. TTT2_GMOD_MIN_VERSION .. "\n"
    )

    print("=============================================================")

    print("This is the end of the addon checker output.")
    print("")
end

concommand.Add("addonchecker", addonChecker.Check)
