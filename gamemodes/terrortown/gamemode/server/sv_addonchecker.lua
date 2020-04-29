---
-- Addonchecker to detect known incompatabilities.
-- @author saibotk

Addonchecker = {}

---
-- This will iterate through all <code>Addonchecker.buggyAddons</code> and <code>Addonchecker.outdatedAddons</code>
-- to notify about known incompatible / outdated addons and about a working alternative, if one exists.
-- @realm server
function Addonchecker:Check()
	local buggyAddons = table.Copy(self.buggyAddons)
	local outdatedAddons = table.Copy(self.outdatedAddons)

	hook.Run("TTT2ModifyIncompatibleAddons", buggyAddons)
	hook.Run("TTT2ModifyOutdatedAddons", outdatedAddons)

	local c = 0
	local addns = engine.GetAddons()

	print("=============================================================\n")
	print("TTT2 ADDON CHECKER\n")

	for i = 1, #addns do
		local addon = addns[i]
		local key = tostring(addon.wsid)

		local buggy_addon = buggyAddons[key]
		if buggy_addon then
			c = c + 1
			buggyAddons[key] = nil

			if buggy_addon ~= "" then
				buggy_addon = "\nThere is a compatible Add-On available at: https://steamcommunity.com/sharedfiles/filedetails/?id=" .. buggy_addon
			end

			ErrorNoHalt((c == 1 and "\n\n" or "") .. "[TTT2][ERROR] Incompatible Add-On detected: " .. addon.title .. " (WS-ID: '" .. addon.wsid .. "')." .. buggy_addon .. "\n\n")
		end

		local outdated_addon = outdatedAddons[key]
		if outdated_addon then
			c = c + 1
			buggyAddons[key] = nil

			if outdated_addon ~= "" then
				outdated_addon = "\nThere is an updated Add-On available at: https://steamcommunity.com/sharedfiles/filedetails/?id=" .. outdated_addon
			end

			ErrorNoHalt((c == 1 and "\n\n" or "") .. "[TTT2][ERROR] Outdated Add-On detected: " .. addon.title .. " (WS-ID: '" .. addon.wsid .. "').\nYour version does work with TTT2, but there's an addon which uses some of the new features of TTT2." .. outdated_addon .. "\n\n")
		end
	end

	print("This is the end of the addon checker output.")
	print("=============================================================\n")
end

-- Addons that do not work (well) with TTT2 and can lead to errors.
Addonchecker.buggyAddons = {
	["656662924"] = "1367128301", -- Killer Notifier by nerzlakai96
	["167547072"] = "1367128301", -- Killer Notifier by StarFox

	["649273679"] = "1367128301", -- Role Counter by Zaratusa

	["1531794562"] = "1367128301", -- Killer Info by wurffl
	["257624318"] = "1367128301", -- Killer info by DerRene

	["308966836"] = "1473581448", -- Death Faker by Exho
	["922007616"] = "1473581448", -- Death Faker by BocciardoLight
	["785423990"] = "1473581448", -- Death Faker by markusmarkusz
	["236217898"] = "1473581448", -- Death Faker by jayjayjay1
	["912181642"] = "1473581448", -- Death Faker by w4rum

	["127865722"] = "1362430347", -- TTT ULX by Bender180

	["305101059"] = "", -- ID Bomb by MolagA

	["663328966"] = "", -- damagelogs by Hundreth

	["404599106"] = "", -- SpectatorDeathmatch by P4sca1 [EGM]

	["253737047"] = "1398388611", -- Golden Deagle by Zaratusa
	["637848943"] = "1398388611", -- Golden Deagle by Zaratusa
	["1376434172"] = "1398388611", -- Golden Deagle by DaniX_Chile
	["1434026961"] = "1398388611", -- Golden Deagle by Mangonaut
	["303535203"] = "1398388611", -- Golden Deagle by Navusaur
	["1325415810"] = "1398388611", -- Golden Deagle by Faedon | Max
	["648505481"] = "1398388611", -- Golden Deagle by TypicalRookie
	["659643589"] = "1398388611", -- Golden Deagle by 中國是同性戀

	["828347015"] = "1566390281", -- TTT Totem

	["644532564"] = "", -- TTT Totem content

	["1092556189"] = "", -- Town of Terror by Jenssons

	["1215502383"] = "", -- Custom Roles by Noxx

	["1382102057"] = "", -- Thanos's Infinity Gauntlet SWEP and Model

	["886346394"] = "", -- Identity Swapper by Lesh
	["844284735"] = "", -- Identity Swapper by Saty

	["606792331"] = "", -- Advanced disguiser by Gamefreak
	["610632051"] = "" -- Advanced disguiser by Killberty
}

-- Addons that have newer version in the WS, that will work better with TTT2.
Addonchecker.outdatedAddons = {
	["940215686"] = "1637001449", -- Clairvoyancy by Doctor Jew
	["654341247"] = "1637001449", -- Clairvoyancy by Liberty

	["130051756"] = "1584675927", -- Spartan Kick by uacnix
	["122277196"] = "1584675927", -- Spartan Kick by Chowder908
	["922510848"] = "1584675927", -- Spartan Kick by BocciardoLight
	["282584080"] = "1584675927", -- Spartan Kick by Porter
	["1092632443"] = "1584675927", -- Spartan Kick by Jenssons

	["1523332573"] = "1584780982", -- Thomas by Tubner
	["962093923"] = "1584780982", -- Thomas by ThunfischArnold
	["1479128258"] = "1584780982", -- Thomas by JollyJelly1001
	["1390915062"] = "1584780982", -- Thomas by Doc Snyder
	["1171584841"] = "1584780982", -- Thomas by Maxdome
	["811718553"] = "1584780982", -- Thomas by Mr C Funk

	["922355426"] = "1629914760", -- Melon Mine by Phoenixf129
	["960077088"] = "1629914760", -- Melon Mine by TheSoulrester

	["309299668"] = "1630269736", -- Martyrdom by Exho
	["1324649928"] = "1630269736", -- Martyrdom by Doctor Jew
	["899206223"] = "1630269736", -- Martyrdom by Koksgesicht

	["652046425"] = "1640512667", -- Juggernaut Suit by Zaratusa

	["652046425"] = "1470823315", -- Beartrap by Milkwater
	["652046425"] = "407751746", -- Beartrap by Nerdhive

	["273623128"] = "842302491", -- Juggernaut by Hoff
	["1387914296"] = "842302491", -- Juggernaut by Schmitler
	["1371596971"] = "842302491", -- Juggernaut by Amenius
	["860794236"] = "842302491", -- Juggernaut by Menzek
	["1198504029"] = "842302491", -- Juggernaut by RedocPlays
	["911658617"] = "842302491", -- Juggernaut by Luchix
	["869353740"] = "842302491", -- Juggernaut by Railroad Engineer 111

	["310403937"] = "1662844145", -- Prop Disguiser by Exho
	["843092697"] = "1662844145", -- Prop Disguiser by Soren
	["937535488"] = "1662844145", -- Prop Disguiser by St Addi
	["1168304202"] = "1662844145", -- Prop Disguiser by Izellix
	["1361103159"] = "1662844145", -- Prop Disguiser by Derp altamas
	["1301826793"] = "1662844145", -- Prop Disguiser by Akechi

	["254779132"] = "810154456", -- Dead Ringer by Porter
	["1315377462"] = "810154456", -- Dead Ringer by MuratYilderimTM
	["240281783"] = "810154456", -- Dead Ringer by Niandra

	["863963592"] = "1815518231" -- Super Soda by ---
}
