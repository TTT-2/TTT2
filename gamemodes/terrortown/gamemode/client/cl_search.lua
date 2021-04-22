---
-- Body search popup
-- @section body_search_manager

local T = LANG.GetTranslation
local PT = LANG.GetParamTranslation
local RT = LANG.GetRawTranslation
local table = table
local net = net
local pairs = pairs
local util = util
local IsValid = IsValid
local hook = hook

local is_dmg = util.BitSet

local dtt = {
	search_dmg_crush = DMG_CRUSH,
	search_dmg_bullet = DMG_BULLET,
	search_dmg_fall = DMG_FALL,
	search_dmg_boom = DMG_BLAST,
	search_dmg_club = DMG_CLUB,
	search_dmg_drown = DMG_DROWN,
	search_dmg_stab = DMG_SLASH,
	search_dmg_burn = DMG_BURN,
	search_dmg_tele = DMG_SONIC,
	search_dmg_car = DMG_VEHICLE
}

-- "From his body you can tell XXX"
local function DmgToText(d)
	for k, v in pairs(dtt) do
		if is_dmg(d, v) then
			return T(k)
		end
	end

	if is_dmg(d, DMG_DIRECT) then
		return T("search_dmg_burn")
	end

	return T("search_dmg_other")
end

-- Info type to icon mapping

-- Some icons have different appearances based on the data value. These have a
-- separate table inside the TypeToMat table.

-- Those that have a lot of possible data values are defined separately, either
-- as a function or a table.

local dtm = {
	bullet = DMG_BULLET,
	rock = DMG_CRUSH,
	splode = DMG_BLAST,
	fall = DMG_FALL,
	fire = DMG_BURN,
	drown = DMG_DROWN
}

local function DmgToMat(d)
	for k, v in pairs(dtm) do
		if is_dmg(d, v) then
			return k
		end
	end

	if is_dmg(d, DMG_DIRECT) then
		return "fire"
	else
		return "skull"
	end
end

local function WeaponToIcon(d)
	local wep = util.WeaponForClass(d)

	return wep and wep.Icon or "vgui/ttt/icon_nades"
end

local TypeToMat = {
	nick = "id",
	words = "halp",
	c4 = "code",
	dmg = DmgToMat,
	wep = WeaponToIcon,
	head = "head",
	dtime = "time",
	stime = "wtester",
	lastid = "lastid",
	kills = "list",
	role = {}
}

-- Accessor for better fail handling
local function IconForInfoType(t, data)
	local base = "vgui/ttt/icon_"
	local mat = TypeToMat[t]

	if istable(mat) then
		if t == "role" and not mat[data] then
			TypeToMat[t][data] = roles.GetByIndex(data).icon
		end

		mat = mat[data]
	elseif isfunction(mat) then
		mat = mat(data)
	end

	if not mat then
		mat = TypeToMat["nick"]
	end

	-- ugly special casing for weapons, because they are more likely to be
	-- customized and hence need more freedom in their icon filename
	if t == "wep" or t == "role" then
		return mat
	else
		return base .. mat
	end
end

local pfmc_tbl = {
	nick = function(search, d, raw)
		search.nick.text = PT("search_nick", {player = d})
		search.nick.p = 1
		search.nick.nick = d
	end,
	role = function(search, d, raw)
		local rd = roles.GetByIndex(d)

		search.role.text = T("search_role_" .. rd.abbr)
		search.role.color = raw["role_color"] or rd.color
		search.role.p = 2
	end,
	team = function(search, d, raw)
		search.team.text = "Team: " .. d .. "." -- will be merged with role later
	end,
	words = function(search, d, raw)
		if d == "" then return end

		-- only append "--" if there's no ending interpunction
		local final = string.match(d, "[\\.\\!\\?]$") ~= nil

		search.words.text = PT("search_words", {lastwords = d .. (final and "" or "--.")})
	end,
	c4 = function(search, d, raw)
		if d <= 0 then return end

		search.c4.text = PT("search_c4", {num = d})
	end,
	dmg = function(search, d, raw)
		search.dmg.text = DmgToText(d)
		search.dmg.p = 12
	end,
	wep = function(search, d, raw)
		local wep = util.WeaponForClass(d)
		local wname = wep and LANG.TryTranslation(wep.PrintName)

		if not wname then return end

		search.wep.text = PT("search_weapon", {weapon = wname})
	end,
	head = function(search, d, raw)
		search.head.p = 15

		if not d then return end

		search.head.text = T("search_head")
	end,
	dtime = function(search, d, raw)
		if d == 0 then return end

		local ftime = util.SimpleTime(d, "%02i:%02i")

		search.dtime.text = PT("search_time", {time = ftime})
		search.dtime.text_icon = ftime
		search.dtime.p = 8
	end,
	stime = function(search, d, raw)
		if d <= 0 then return end

		local ftime = util.SimpleTime(d, "%02i:%02i")

		search.stime.text = PT("search_dna", {time = ftime})
		search.stime.text_icon = ftime
	end,
	kills = function(search, d, raw)
		local num = table.Count(d)

		if num == 1 then
			local vic = Entity(d[1])
			local dc = d[1] == -1 -- disconnected

			if dc or IsValid(vic) and vic:IsPlayer() then
				search.kills.text = PT("search_kills1", {player = dc and "<Disconnected>" or vic:Nick()})
			end
		elseif num > 1 then
			local txt = T("search_kills2") .. "\n"
			local nicks = {}

			for k, idx in pairs(d) do
				local vic = Entity(idx)
				local dc = idx == -1

				if dc or IsValid(vic) and vic:IsPlayer() then
					nicks[#nicks + 1] = dc and "<Disconnected>" or vic:Nick()
				end
			end

			local last = #nicks

			txt = txt .. table.concat(nicks, "\n", 1, last)
			search.kills.text = txt
		end

		search.kills.p = 30
	end,
	lastid = function(search, d, raw)
		if not d or d.idx == -1 then return end

		local ent = Entity(d.idx)

		if not IsValid(ent) or not ent:IsPlayer() then return end

		search.lastid.text = PT("search_eyes", {player = ent:Nick()})
		search.lastid.ply = ent
	end,
}

---
-- Creates a table with icons, text,... out of search_raw table
-- @param table raw
-- @return table a converted search data table
-- @realm client
function PreprocSearch(raw)
	local search = {}

	for t, d in pairs(raw) do
		search[t] = {
			img = nil,
			text = "",
			p = 10 -- sorting number
		}

		if isfunction(pfmc_tbl[t]) then
			pfmc_tbl[t](search, d, raw)
		else
			search[t] = nil
		end

		-- anything matching a type but not given a text should be removed
		if search[t] and search[t].text == "" then
			search[t] = nil
		end

		-- don't display an extra icon for the team. Merge with role desc
		if search.role and search.team then
			if GetGlobalBool("ttt2_confirm_team") then
				search.role.text = search.role.text .. " " .. search.team.text
			end

			search.team = nil
		end

		-- if there's still something here, we'll be showing it, so find an icon
		if search[t] then
			search[t].img = IconForInfoType(t, d)
		end
	end

	local itms = items.GetList()

	for i = 1, #itms do
		local item = itms[i]

		if not item.noCorpseSearch and raw["eq_" .. item.id] then
			local highest = 0

			for _, v in pairs(search) do
				highest = math.max(highest, v.p)
			end

			local text

			if item.corpseDesc then
				text = RT(item.corpseDesc) or item.corpseDesc
			else
				if item.desc then
					text = RT(item.desc)
				end

				local tmpText

				if not text and item.EquipMenuData and item.EquipMenuData.desc then
					tmpText = item.EquipMenuData.desc
					text = RT(tmpText)
				end

				if not text then
					text = item.desc or tmpText or ""
				end
			end

			-- add item to body search if flag is set
			if item.populateSearch then
				search["eq_" .. item.id] = {
					img = item.corpseIcon or item.material,
					text = text,
					p = highest + 1
				}
			end
		end
	end

	---
	-- @realm client
	hook.Run("TTTBodySearchPopulate", search, raw)

	return search
end

---
-- Returns a function meant to override OnActivePanelChanged, which modifies
-- dactive and dtext based on the search information that is associated with the
-- newly selected panel
local function SearchInfoController(search, dactive, dtext)
	return function(s, pold, pnew)
		local t = pnew.info_type

		local data = search[t]
		if not data then
			ErrorNoHalt("Search: data not found", t, data, "\n")

			return
		end

		-- If wrapping is on, the Label's SizeToContentsY misbehaves for
		-- text that does not need wrapping. I long ago stopped wondering
		-- "why" when it comes to VGUI. Apply hack, move on.
		dtext:GetLabel():SetWrap(#data.text > 50)
		dtext:SetText(data.text)

		local icon = data.img

		if t == "role" then
			dactive:SetImage2("vgui/ttt/dynamic/icon_base_base")
			dactive:SetImageOverlay("vgui/ttt/dynamic/icon_base_base_overlay")
			dactive:SetRoleIconImage(icon)

			icon = "vgui/ttt/dynamic/icon_base"
		else
			dactive:UnloadImage2()
			dactive:UnloadImageOverlay()
			dactive:UnloadRoleIconImage()
		end

		dactive:SetImage(icon)
		dactive:SetImageColor(data.color or COLOR_WHITE)
	end
end

local function ShowSearchScreen(search_raw)
	local client = LocalPlayer()
	if not IsValid(client) then return end

	local m = 8
	local bw, bh = 100, 25
	local bw_large = 125
	local w, h = 425, 260

	local rw, rh = (w - m * 2), (h - 25 - m * 2)
	local rx, ry = 0, 0

	local rows = 1
	local listw, listh = rw, (64 * rows + 6)
	local listx, listy = rx, ry

	ry = ry + listh + m * 2
	rx = m

	local descw, desch = rw - m * 2, 80
	local descx, descy = rx, ry

	ry = ry + desch + m

	--local butx, buty = rx, ry

	local dframe = vgui.Create("DFrame")
	dframe:SetSize(w, h)
	dframe:Center()
	dframe:SetTitle(T("search_title") .. " - " .. search_raw.nick or "???")
	dframe:SetVisible(true)
	dframe:ShowCloseButton(true)
	dframe:SetMouseInputEnabled(true)
	dframe:SetKeyboardInputEnabled(true)
	dframe:SetDeleteOnClose(true)

	dframe.OnKeyCodePressed = util.BasicKeyHandler

	-- contents wrapper
	local dcont = vgui.Create("DPanel", dframe)
	dcont:SetPaintBackground(false)
	dcont:SetSize(rw, rh)
	dcont:SetPos(m, 25 + m)

	-- icon list
	local dlist = vgui.Create("DPanelSelect", dcont)
	dlist:SetPos(listx, listy)
	dlist:SetSize(listw, listh)
	dlist:EnableHorizontal(true)
	dlist:SetSpacing(1)
	dlist:SetPadding(2)

	if dlist.VBar then
		dlist.VBar:Remove()

		dlist.VBar = nil
	end

	-- description area
	local dscroll = vgui.Create("DHorizontalScroller", dlist)
	dscroll:StretchToParent(3, 3, 3, 3)

	local ddesc = vgui.Create("ColoredBox", dcont)
	ddesc:SetColor(Color(50, 50, 50))
	ddesc:SetName(T("search_info"))
	ddesc:SetPos(descx, descy)
	ddesc:SetSize(descw, desch)

	local dactive = vgui.Create("DRoleImage", ddesc)
	dactive:SetImage("vgui/ttt/icon_id")
	dactive:SetPos(m, m)
	dactive:SetSize(64, 64)

	local dtext = vgui.Create("ScrollLabel", ddesc)
	dtext:SetSize(descw - 120, desch - m * 2)
	dtext:MoveRightOf(dactive, m * 2)
	dtext:AlignTop(m)
	dtext:SetText("...")

	-- buttons
	local by = rh - bh - m * 0.5

	local dconfirm = vgui.Create("DButton", dcont)
	dconfirm:SetPos(m, by)
	dconfirm:SetSize(bw_large, bh)
	dconfirm:SetText(T("search_confirm"))

	local id = search_raw.eidx + search_raw.dtime

	dconfirm.DoClick = function(s)
		RunConsoleCommand("ttt_confirm_death", search_raw.eidx, id, search_raw.lrng)
	end

	dconfirm:SetDisabled(client:IsSpec() or search_raw.owner and IsValid(search_raw.owner) and search_raw.owner:TTT2NETGetBool("body_found", false))

	local dcall = vgui.Create("DButton", dcont)
	dcall:SetPos(m * 2 + bw_large, by)
	dcall:SetSize(bw_large, bh)
	dcall:SetText(T("search_call"))

	dcall.DoClick = function(s)
		client.called_corpses = client.called_corpses or {}
		client.called_corpses[#client.called_corpses + 1] = search_raw.eidx

		s:SetDisabled(true)

		RunConsoleCommand("ttt_call_detective", search_raw.eidx)
	end

	dcall:SetDisabled(client:IsSpec() or table.HasValue(client.called_corpses or {}, search_raw.eidx))

	local dclose = vgui.Create("DButton", dcont)
	dclose:SetPos(rw - m - bw, by)
	dclose:SetSize(bw, bh)
	dclose:SetText(T("close"))

	dclose.DoClick = function()
		dframe:Close()
	end

	-- Finalize search data, prune stuff that won't be shown etc
	-- search is a table of tables that have an img and text key
	local search = PreprocSearch(search_raw)

	-- Install info controller that will link up the icons to the text etc
	dlist.OnActivePanelChanged = SearchInfoController(search, dactive, dtext)

	-- Create table of SimpleIcons, each standing for a piece of search
	-- information.
	local start_icon

	for t, info in SortedPairsByMemberValue(search, "p") do
		local ic
		local icon = info.img

		-- Certain items need a special icon conveying additional information
		if t == "nick" then
			local avply = IsValid(search_raw.owner) and search_raw.owner or nil

			ic = vgui.Create("SimpleIconAvatar", dlist)
			ic:SetPlayer(avply)

			start_icon = ic
		elseif t == "lastid" then
			ic = vgui.Create("SimpleIconAvatar", dlist)
			ic:SetPlayer(info.ply)
			ic:SetAvatarSize(24)
		elseif info.text_icon then
			ic = vgui.Create("SimpleIconLabelled", dlist)
			ic:SetIconText(info.text_icon)
		elseif t == "role" then
			ic = vgui.Create("SimpleRoleIcon", dlist)

			ic.Icon:SetImage2("vgui/ttt/dynamic/icon_base_base")
			ic.Icon:SetImageOverlay("vgui/ttt/dynamic/icon_base_base_overlay")
			ic.Icon:SetRoleIconImage(icon)

			icon = "vgui/ttt/dynamic/icon_base"
		else
			ic = vgui.Create("SimpleIcon", dlist)
		end

		ic:SetIconSize(64)
		ic:SetIcon(icon)

		if info.color then
			ic:SetIconColor(info.color)
		end

		ic.info_type = t

		dlist:AddPanel(ic)
		dscroll:AddPanel(ic)
	end

	dlist:SelectPanel(start_icon)
	dframe:MakePopup()
end

local function StoreSearchResult(search)
	if not search.owner then return end

	-- if existing result was not ours, it was detective's, and should not
	-- be overwritten
	local ply = search.owner

	if ply.search_result and not ply.search_result.show then return end

	ply.search_result = search

	-- this is useful for targetid
	local rag = Entity(search.eidx)
	if not IsValid(rag) then return end

	rag.search_result = search
end

local function bitsRequired(num)
	local bits, max = 0, 1

	while max <= num do
		bits = bits + 1
		max = max + max
	end

	return bits
end

local search = {}

local function TTTRagdollSearch()
	search = {}

	-- Basic info
	search.eidx = net.ReadUInt(16)

	local owner = Entity(net.ReadUInt(8))

	search.owner = owner

	if not IsValid(search.owner) or not search.owner:IsPlayer() or search.owner:IsTerror() then
		search.owner = nil
	end

	search.nick = net.ReadString()
	search.role_color = net.ReadColor()

	-- Equipment
	local eq = {}

	local eqAmount = net.ReadUInt(16)

	for i = 1, eqAmount do
		local eqStr = net.ReadString()

		eq[i] = eqStr
		search["eq_" .. eqStr] = true
	end

	-- Traitor things
	search.role = net.ReadUInt(ROLE_BITS)
	search.team = net.ReadString()
	search.c4 = net.ReadInt(bitsRequired(C4_WIRE_COUNT) + 1)

	-- Kill info
	search.dmg = net.ReadUInt(30)
	search.wep = net.ReadString()
	search.head = net.ReadBit() == 1
	search.dtime = net.ReadInt(16)
	search.stime = net.ReadInt(16)

	-- Players killed
	local num_kills = net.ReadUInt(8)
	if num_kills > 0 then
		local t_kills = {}

		for i = 1, num_kills do
			t_kills[i] = net.ReadUInt(8)
		end

		search.kills = t_kills
	else
		search.kills = nil
	end

	search.lastid = {idx = net.ReadUInt(8)}

	-- should we show a menu for this result?
	search.finder = net.ReadUInt(8)
	search.show = LocalPlayer():EntIndex() == search.finder

	--
	-- last words
	--
	local words = net.ReadString()
	search.words = (words ~= "") and words or nil

	-- long range
	search.lrng = net.ReadBit()

	-- searched by detective?
	search.detective_search = net.ReadBool()

	-- set search.show_sb based on detective_search or self search
	search.show_sb = search.show or search.detective_search

	---
	-- @realm shared
	hook.Run("TTTBodySearchEquipment", search, eq)

	if search.show then
		ShowSearchScreen(search)
	end

	-- cache search result in rag.search_result, e.g. useful for scoreboard
	StoreSearchResult(search)

	search = nil
end
net.Receive("TTT_RagdollSearch", TTTRagdollSearch)

local function TTT2ConfirmMsg()
	local msgName = net.ReadString()
	local sid64 = net.ReadString()
	local clr = Color(net.ReadUInt(8), net.ReadUInt(8), net.ReadUInt(8), net.ReadUInt(8))
	local bool = net.ReadBool()

	local tbl = {}
	tbl.finder = net.ReadString()
	tbl.victim = net.ReadString()
	tbl.role = LANG.GetTranslation(net.ReadString())

	if bool then
		tbl.team = LANG.GetTranslation(net.ReadString())
	end

	-- checking for bots
	if sid64 == "" then
		sid64 = nil
	end

	local img = draw.GetAvatarMaterial(sid64, "medium")

	---
	-- @realm client
	hook.Run("TTT2ConfirmedBody", tbl.finder, tbl.victim)

	MSTACK:AddColoredImagedMessage(LANG.GetParamTranslation(msgName, tbl), clr, img)
end
net.Receive("TTT2SendConfirmMsg", TTT2ConfirmMsg)
