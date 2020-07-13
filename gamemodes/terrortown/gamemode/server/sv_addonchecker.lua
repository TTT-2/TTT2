---
-- addonChecker to detect known incompatabilities.
-- @author saibotk
-- @author Mineotopia

ADDON_INCOMPATIBLE = 0
ADDON_OUTDATED = 1

addonChecker = addonChecker or {}

addonChecker.curatedList = {
	["656662924"] = { -- Killer Notifier by nerzlakai96
		alternative = "1367128301",
		reason = "Does not work with our role system.",
		type = ADDON_INCOMPATIBLE
	},
	["167547072"] = { -- Killer Notifier by StarFox
		alternative = "1367128301",
		reason = "Does not work with our role system.",
		type = ADDON_INCOMPATIBLE
	},
	["649273679"] = { -- Role Counter by Zaratusa
		alternative = "1367128301",
		reason = "Does not work with our role system.",
		type = ADDON_INCOMPATIBLE
	},
	["1531794562"] = { -- Killer Info by wurffl
		alternative = "1367128301",
		reason = "Does not work with our role system.",
		type = ADDON_INCOMPATIBLE
	},
	["257624318"] = { -- Killer info by DerRene
		alternative = "1367128301",
		reason = "Does not work with our role system.",
		type = ADDON_INCOMPATIBLE
	},
	["308966836"] = { -- Death Faker by Exho
		alternative = "1473581448",
		reason = "Does not work with our role system.",
		type = ADDON_INCOMPATIBLE
	},
	["922007616"] = { -- Death Faker by BocciardoLight
		alternative = "1473581448",
		reason = "Does not work with our role system.",
		type = ADDON_INCOMPATIBLE
	},
	["785423990"] = { -- Death Faker by markusmarkusz
		alternative = "1473581448",
		reason = "Does not work with our role system.",
		type = ADDON_INCOMPATIBLE
	},
	["236217898"] = { -- Death Faker by jayjayjay1
		alternative = "1473581448",
		reason = "Does not work with our role system.",
		type = ADDON_INCOMPATIBLE
	},
	["912181642"] = { -- Death Faker by w4rum
		alternative = "1473581448",
		reason = "Does not work with our role system.",
		type = ADDON_INCOMPATIBLE
	},
	["127865722"] = { -- TTT ULX by Bender180
		alternative = "1362430347",
		reason = "All TTT2 features are missing from this version.",
		type = ADDON_INCOMPATIBLE
	},
	["305101059"] = { -- ID Bomb by MolagA
		type = ADDON_INCOMPATIBLE
	},
	["663328966"] = { -- damagelogs by Hundreth
		reason = "Breaks the TTT2 gamemode, alternative available here: https://github.com/Alf21/tttdamagelogs",
		type = ADDON_INCOMPATIBLE
	},
	["404599106"] = { -- SpectatorDeathmatch by P4sca1 [EGM]
		alternative = "1997666028",
		reason = "Breaks the TTT2 gamemode.",
		type = ADDON_INCOMPATIBLE
	},
	["1376434172"] = { -- Golden Deagle by DaniX_Chile
		alternative = "1398388611",
		reason = "Does not work with our role system.",
		type = ADDON_INCOMPATIBLE
	},
	["1434026961"] = { -- Golden Deagle by Mangonaut
		alternative = "1398388611",
		reason = "Does not work with our role system.",
		type = ADDON_INCOMPATIBLE
	},
	["303535203"] = { -- Golden Deagle by Navusaur
		alternative = "1398388611",
		reason = "Does not work with our role system.",
		type = ADDON_INCOMPATIBLE
	},
	["1325415810"] = { -- Golden Deagle by Faedon | Max
		alternative = "1398388611",
		reason = "Does not work with our role system.",
		type = ADDON_INCOMPATIBLE
	},
	["648505481"] = { -- Golden Deagle by TypicalRookie
		alternative = "1398388611",
		reason = "Does not work with our role system.",
		type = ADDON_INCOMPATIBLE
	},
	["659643589"] = { -- Golden Deagle by 中國是同性戀
		alternative = "1398388611",
		reason = "Does not work with our role system.",
		type = ADDON_INCOMPATIBLE
	},
	["828347015"] = { -- TTT Totem by Gamefreak
		alternative = "1566390281",
		reason = "Has its own role selection system.",
		type = ADDON_INCOMPATIBLE
	},
	["644532564"] = { -- TTT Totem Content by Gamefreak
		type = ADDON_INCOMPATIBLE
	},
	["1092556189"] = { -- Town of Terror by Jenssons
		reason = "Inferior role selection system that breaks TTT2.",
		type = ADDON_INCOMPATIBLE
	},
	["1215502383"] = { -- Custom Roles by Noxx
		reason = "Inferior role selection system that breaks TTT2.",
		type = ADDON_INCOMPATIBLE
	},
	["886346394"] = { -- Identity Swapper by Lesh
		reason = "Overwrites the targetID gamemode function and therefore removes the TTT2 targetID.",
		type = ADDON_INCOMPATIBLE
	},
	["844284735"] = { -- Identity Swapper by Saty
		reason = "Overwrites the targetID gamemode function and therefore removes the TTT2 targetID.",
		type = ADDON_INCOMPATIBLE
	},
	["1382102057"] = { -- Thanos's Infinity Gauntlet SWEP and Model
		reason = "Sets everybodies sprintspeed quite high.",
		type = ADDON_INCOMPATIBLE
	},
	["1757151213"] = { -- Random Shop by Lupus
		reason = "Random shop is already included in TTT2.",
		type = ADDON_INCOMPATIBLE
	},
	["481440358"] = { -- Drowning Indicator by Moe
		reason = "A drowning indicator is already included in TTT2.",
		type = ADDON_INCOMPATIBLE
	},
	["933056549"] = { -- Sprint by Fresh Garry
		reason = "A sprinting system is already included in TTT2.",
		type = ADDON_INCOMPATIBLE
	},
	["1729301513"] = { -- Sprint by Lesh
		reason = "A sprinting system is already included in TTT2.",
		type = ADDON_INCOMPATIBLE
	},
	["367945571"] = { -- Advanced Body Search by Mr Trung
		reason = "This addon breaks the whole body confirmation system.",
		type = ADDON_INCOMPATIBLE
	},
	["878772496"] = { -- BEM by Long Long Longson
		reason = "A reworked shop is already part of TTT2.",
		type = ADDON_INCOMPATIBLE
	},
	["1107420703"] = { -- BEM by Fresh Garry
		reason = "A reworked shop is already part of TTT2.",
		type = ADDON_INCOMPATIBLE
	},
	["290961117"] = { -- Destructible Doors by Exho
		reason = "Breakable doors are already a part of TTT2 that can be enabled with a convar. This addon has also problems with area portals in some doors.",
		type = ADDON_INCOMPATIBLE
	},
	["606792331"] = { -- Advanced disguiser by Gamefreak
		alternative = "2144375749",
		reason = "Does not work with TTT2 targetID.",
		type = ADDON_INCOMPATIBLE
	},
	["610632051"] = { -- Advanced disguiser by Killberty
		alternative = "2144375749",
		reason = "Does not work with TTT2 targetID.",
		type = ADDON_INCOMPATIBLE
	},
	["940215686"] = { -- Clairvoyancy by Doctor Jew
		alternative = "1637001449",
		reason = "Does not use the TTT2 sidebar system.",
		type = ADDON_OUTDATED
	},
	["654341247"] = { -- Clairvoyancy by Liberty
		alternative = "1637001449",
		reason = "Does not use the TTT2 sidebar system.",
		type = ADDON_OUTDATED
	},
	["130051756"] = { -- Spartan Kick by uacnix
		alternative = "1584675927",
		reason = "Broken area portals in some doors and improved use of TTT2 systems.",
		type = ADDON_OUTDATED
	},
	["122277196"] = { -- Spartan Kick by Chowder908
		alternative = "1584675927",
		reason = "Broken area portals in some doors and improved use of TTT2 systems.",
		type = ADDON_OUTDATED
	},
	["922510848"] = { -- Spartan Kick by BocciardoLight
		alternative = "1584675927",
		reason = "Broken area portals in some doors and improved use of TTT2 systems.",
		type = ADDON_OUTDATED
	},
	["282584080"] = { -- Spartan Kick by Porter
		alternative = "1584675927",
		reason = "Broken area portals in some doors and improved use of TTT2 systems.",
		type = ADDON_OUTDATED
	},
	["1092632443"] = { -- Spartan Kick by Jenssons
		alternative = "1584675927",
		reason = "Broken area portals in some doors and improved use of TTT2 systems.",
		type = ADDON_OUTDATED
	},
	["1523332573"] = { -- Thomas by Tubner
		alternative = "2024902834",
		reason = "Broken models, sounds and damage inflictor info.",
		type = ADDON_OUTDATED
	},
	["962093923"] = { -- Thomas by ThunfischArnold
		alternative = "2024902834",
		reason = "Broken models, sounds and damage inflictor info.",
		type = ADDON_OUTDATED
	},
	["1479128258"] = { -- Thomas by JollyJelly1001
		alternative = "2024902834",
		reason = "Broken models, sounds and damage inflictor info.",
		type = ADDON_OUTDATED
	},
	["1390915062"] = { -- Thomas by Doc Snyder
		alternative = "2024902834",
		reason = "Broken models, sounds and damage inflictor info.",
		type = ADDON_OUTDATED
	},
	["1171584841"] = { -- Thomas by Maxdome
		alternative = "2024902834",
		reason = "Broken models, sounds and damage inflictor info.",
		type = ADDON_OUTDATED
	},
	["811718553"] = { -- Thomas by Mr C Funk
		alternative = "2024902834",
		reason = "Broken models, sounds and damage inflictor info.",
		type = ADDON_OUTDATED
	},
	["922355426"] = { -- Melon Mine by Phoenixf129
		alternative = "1629914760",
		reason = "Doesn't really work with the TTT2 role system.",
		type = ADDON_OUTDATED
	},
	["960077088"] = { -- Melon Mine by TheSoulrester
		alternative = "1629914760",
		reason = "Doesn't really work with the TTT2 role system.",
		type = ADDON_OUTDATED
	},
	["309299668"] = { -- Martyrdom by Exho
		alternative = "1630269736",
		reason = "Does not use the TTT2 sidebar system.",
		type = ADDON_OUTDATED
	},
	["1324649928"] = { -- Martyrdom by Doctor Jew
		alternative = "1630269736",
		reason = "Does not use the TTT2 sidebar system.",
		type = ADDON_OUTDATED
	},
	["899206223"] = { -- Martyrdom by Koksgesicht
		alternative = "1630269736",
		reason = "Does not use the TTT2 sidebar system.",
		type = ADDON_OUTDATED
	},
	["652046425"] = { -- Juggernaut Suit by Zaratusa
		alternative = "2157829981",
		reason = "Does not use the TTT2 sidebar system.",
		type = ADDON_OUTDATED
	},
	["650523807"] = { -- Lucky Horseshoe by Zaratusa
		alternative = "2157888469",
		reason = "Does not use the TTT2 sidebar system.",
		type = ADDON_OUTDATED
	},
	["650523765"] = { -- Hermes Boots by Zaratusa
		alternative = "2157850255",
		reason = "Does not use the TTT2 sidebar system.",
		type = ADDON_OUTDATED
	},
	["1470823315"] = { -- Beartrap by Milkwater
		alternative = "1641605106",
		reason = "Has some problems with damage after roundend and doesn't use the TTT2 sidebar system.",
		type = ADDON_OUTDATED
	},
	["407751746"] = { -- Beartrap by Nerdhive
		alternative = "1641605106",
		reason = "Has some problems with damage after roundend and doesn't use the TTT2 sidebar system.",
		type = ADDON_OUTDATED
	},
	["273623128"] = { -- zombie perk bottles by Hoff
		alternative = "842302491",
		type = ADDON_OUTDATED
	},
	["1387914296"] = { -- zombie perk bottles by Schmitler
		alternative = "842302491",
		type = ADDON_OUTDATED
	},
	["1371596971"] = { -- zombie perk bottles by Amenius
		alternative = "842302491",
		type = ADDON_OUTDATED
	},
	["860794236"] = { -- zombie perk bottles by Menzek
		alternative = "842302491",
		type = ADDON_OUTDATED
	},
	["1198504029"] = { -- zombie perk bottles by RedocPlays
		alternative = "842302491",
		type = ADDON_OUTDATED
	},
	["911658617"] = { -- zombie perk bottles by Luchix
		alternative = "842302491",
		type = ADDON_OUTDATED
	},
	["869353740"] = { -- zombie perk bottles by Railroad Engineer 111
		alternative = "842302491",
		type = ADDON_OUTDATED
	},
	["310403937"] = { -- Prop Disguiser by Exho
		alternative = "1662844145",
		type = ADDON_OUTDATED
	},
	["843092697"] = { -- Prop Disguiser by Soren
		alternative = "1662844145",
		type = ADDON_OUTDATED
	},
	["937535488"] = { -- Prop Disguiser by St Addi
		alternative = "1662844145",
		type = ADDON_OUTDATED
	},
	["1168304202"] = { -- Prop Disguiser by Izellix
		alternative = "1662844145",
		type = ADDON_OUTDATED
	},
	["1361103159"] = { -- Prop Disguiser by Derp altamas
		alternative = "1662844145",
		type = ADDON_OUTDATED
	},
	["1301826793"] = { -- Prop Disguiser by Akechi
		alternative = "1662844145",
		type = ADDON_OUTDATED
	},
	["254779132"] = { -- Dead Ringer by Porter
		alternative = "810154456",
		type = ADDON_OUTDATED
	},
	["1315377462"] = { -- Dead Ringer by MuratYilderimTM
		alternative = "810154456",
		type = ADDON_OUTDATED
	},
	["240281783"] = { -- Dead Ringer by Niandra
		alternative = "810154456",
		type = ADDON_OUTDATED
	},
	["284419411"] = { -- Minifier by Lykrast
		alternative = "1896918348",
		reason = "Broken hitboxes and other problems. Also no integration in the TTT2 sidebar system.",
		type = ADDON_OUTDATED
	},
	["1338887971"] = { -- Minifier by Evan
		alternative = "1896918348",
		reason = "Broken hitboxes and other problems. Also no integration in the TTT2 sidebar system.",
		type = ADDON_OUTDATED
	},
	["1551396306"] = { -- Minifier by FaBe2
		alternative = "1896918348",
		reason = "Broken hitboxes and other problems. Also no integration in the TTT2 sidebar system.",
		type = ADDON_OUTDATED
	},
	["1354031183"] = { -- Minifier by SnowSoulAnget
		alternative = "1896918348",
		reason = "Broken hitboxes and other problems. Also no integration in the TTT2 sidebar system.",
		type = ADDON_OUTDATED
	},
	["1670942051"] = { -- Minifier by Not Jesus
		alternative = "1896918348",
		reason = "Broken hitboxes and other problems. Also no integration in the TTT2 sidebar system.",
		type = ADDON_OUTDATED
	},
	["1376141849"] = { -- Minifier by ---
		alternative = "1896918348",
		reason = "Broken hitboxes and other problems. Also no integration in the TTT2 sidebar system.",
		type = ADDON_OUTDATED
	},
	["1599819393"] = { -- Minifier by Coe
		alternative = "1896918348",
		reason = "Broken hitboxes and other problems. Also no integration in the TTT2 sidebar system.",
		type = ADDON_OUTDATED
	},
	["863963592"] = { -- Super Soda by ---
		alternative = "1815518231",
		reason = "Less bottles, no integration in TTT2 systems, generally buggy.",
		type = ADDON_OUTDATED
	},
	["801433502"] = { -- Defibrillator by Minty
		alternative = "2115944312",
		reason = "Improved integration into TTT2 systems.",
		type = ADDON_OUTDATED
	},
	["162581348"] = { -- Defibrillator by Willox
		alternative = "2115944312",
		reason = "Improved integration into TTT2 systems.",
		type = ADDON_OUTDATED
	},
	["921953443"] = { -- Defibrillator by BocciardoLight
		alternative = "2115944312",
		reason = "Improved integration into TTT2 systems.",
		type = ADDON_OUTDATED
	},
	["785796753"] = { -- Defibrillator by Shiratori
		alternative = "2115944312",
		reason = "Improved integration into TTT2 systems.",
		type = ADDON_OUTDATED
	},
	["299479443"] = { -- Defibrillator by PixL
		alternative = "2115944312",
		reason = "Improved integration into TTT2 systems.",
		type = ADDON_OUTDATED
	},
	["1553970612"] = { -- Defibrillator by DasNedwork
		alternative = "2115944312",
		reason = "Improved integration into TTT2 systems.",
		type = ADDON_OUTDATED
	},
	["821963023"] = { -- Defibrillator by DarkIce
		alternative = "2115944312",
		reason = "Improved integration into TTT2 systems.",
		type = ADDON_OUTDATED
	},
	["1695163471"] = { -- Defibrillator by Mr. KobraX
		alternative = "2115944312",
		reason = "Improved integration into TTT2 systems.",
		type = ADDON_OUTDATED
	},
	["1563553647"] = { -- Defibrillator by _BLU
		alternative = "2115944312",
		reason = "Improved integration into TTT2 systems.",
		type = ADDON_OUTDATED
	},
	["1445820970"] = { -- Defibrillator by Mangonaut
		alternative = "2115944312",
		reason = "Improved integration into TTT2 systems.",
		type = ADDON_OUTDATED
	},
	["805980529"] = { -- Defibrillator by Musiker15
		alternative = "2115944312",
		reason = "Improved integration into TTT2 systems.",
		type = ADDON_OUTDATED
	},
	["422006754"] = { -- Defibrillator by Toxic_Terrorists
		alternative = "2115944312",
		reason = "Improved integration into TTT2 systems.",
		type = ADDON_OUTDATED
	},
	["840688276"] = { -- Defibrillator by Saty
		alternative = "2115944312",
		reason = "Improved integration into TTT2 systems.",
		type = ADDON_OUTDATED
	},
	["1198501844"] = { -- Defibrillator by Brannium
		alternative = "2115944312",
		reason = "Improved integration into TTT2 systems.",
		type = ADDON_OUTDATED
	},
	["1199113632"] = { -- Defibrillator by Brannium
		alternative = "2115944312",
		reason = "Improved integration into TTT2 systems.",
		type = ADDON_OUTDATED
	},
	["290945941"] = { -- Door Locker by Exho
		alternative = "2115945573",
		reason = "Improved integration into TTT2 systems and fixed area portal problems for some doors.",
		type = ADDON_OUTDATED
	},
	["1132650862"] = { -- Door Locker by Saiyajin ByTayro
		alternative = "2115945573",
		reason = "Improved integration into TTT2 systems and fixed area portal problems for some doors.",
		type = ADDON_OUTDATED
	},
	["1361100842"] = { -- Door Locker by Altamas
		alternative = "2115945573",
		reason = "Improved integration into TTT2 systems and fixed area portal problems for some doors.",
		type = ADDON_OUTDATED
	}
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
		local detectedAddon = addonChecker.curatedList[tostring(addon.wsid)]

		if not detectedAddon then continue end

		ErrorNoHalt(((detectedAddon.type == ADDON_OUTDATED) and "Outdated add-on detected: " or "Incompatible add-on detected: ") .. addon.title .. "\n")

		if detectedAddon.reason then
			ErrorNoHalt("Reason: " .. detectedAddon.reason .. "\n")
		end

		ErrorNoHalt("--> Detected add-on: https://steamcommunity.com/sharedfiles/filedetails/?id=" .. addon.wsid .. "\n")

		if detectedAddon.alternative then
			ErrorNoHalt("--> Alternative add-on: https://steamcommunity.com/sharedfiles/filedetails/?id=" .. detectedAddon.alternative .. "\n")
		end

		print("")
	end

	print("=============================================================")
	print("This is the end of the addon checker output.")
	print("")
end

concommand.Add("addonchecker", addonChecker.Check)
