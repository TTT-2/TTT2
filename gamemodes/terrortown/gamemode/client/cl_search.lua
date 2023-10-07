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

local utilBitSet = util.BitSet
local is_dmg = util.BitSet

local dtt = {
	crush = DMG_CRUSH,
	bullet = DMG_BULLET,
	fall = DMG_FALL,
	boom = DMG_BLAST,
	club = DMG_CLUB,
	drown = DMG_DROWN,
	stab = DMG_SLASH,
	burn = DMG_BURN,
	tele = DMG_SONIC,
	car = DMG_VEHICLE
}

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

---
-- This hook can be used to populate the body search panel.
-- @param table search The search data table
-- @param table raw The raw search data
-- @hook
-- @realm client
function GM:TTTBodySearchPopulate(search, raw)

end

---
-- This hook can be used to modify the equipment info of a corpse.
-- @param table search The search data table
-- @param table equip The raw equipment table
-- @hook
-- @realm client
function GM:TTTBodySearchEquipment(search, equip)

end

---
-- This hook is called right before the killer found @{MSTACK} notification
-- is added.
-- @param string finder The nickname of the finder
-- @param string victim The nickname of the victim
-- @hook
-- @realm client
function GM:TTT2ConfirmedBody(finder, victim)

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

local function TTTRagdollSearch()
	local search = {}

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

	search.kill_distance = net.ReadUInt(2)
	search.kill_hitgroup = net.ReadUInt(8)
	search.kill_floor_surface = net.ReadUInt(8)
	search.kill_water_level = net.ReadUInt(2)
	search.kill_angle = net.ReadUInt(2)
	search.ply_model = net.ReadString()
	search.ply_model_color = net.ReadVector()
	search.ply_sid64 = net.ReadString()
	search.credits = net.ReadUInt(8)
	search.last_damage = net.ReadUInt(16)

	-- searched by detective?
	search.detective_search = net.ReadBool()

	-- set search.show_sb based on detective_search or self search
	search.show_sb = search.show or search.detective_search

	---
	-- @realm shared
	hook.Run("TTTBodySearchEquipment", search, eq)

	if search.show then
		SEARCHSCRN:Show(search)
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

	eidx = net.ReadUInt(8)

	-- checking for bots
	if sid64 == "" then
		sid64 = nil
	end

	local img = draw.GetAvatarMaterial(sid64, "medium")

	---
	-- @realm client
	hook.Run("TTT2ConfirmedBody", tbl.finder, tbl.victim)

	MSTACK:AddColoredImagedMessage(LANG.GetParamTranslation(msgName, tbl), clr, img)

	if (IsValid(SEARCHSCRN.menuFrame) and SEARCHSCRN.menuFrame.data.idx == edix) then
		SEARCHSCRN.buttonConfirm:SetEnabled(false)
		SEARCHSCRN.buttonConfirm:SetText("search_confirmed")
	end
end
net.Receive("TTT2SendConfirmMsg", TTT2ConfirmMsg)






local distance_to_text = {
	[CORPSE_KILL_POINT_BLANK] = "kill_distance_point_blank",
	[CORPSE_KILL_CLOSE] = "kill_distance_close",
	[CORPSE_KILL_FAR] = "kill_distance_far"
}

local orientation_to_text = {
	[CORPSE_KILL_FRONT] = "kill_from_front",
	[CORPSE_KILL_BACK] = "kill_from_back"
}

local floorid_to_text = {
	[MAT_ANTLION] = "search_floor_antillions",
	[MAT_BLOODYFLESH] = "search_floor_bloodyflesh",
	[MAT_CONCRETE] = "search_floor_concrete",
	[MAT_DIRT] = "search_floor_dirt",
	[MAT_EGGSHELL] = "search_floor_eggshell",
	[MAT_FLESH] = "search_floor_flesh",
	[MAT_GRATE] = "search_floor_grate",
	[MAT_ALIENFLESH] = "search_floor_alienflesh",
	[MAT_SNOW] = "search_floor_snow",
	[MAT_PLASTIC] = "search_floor_plastic",
	[MAT_METAL] = "search_floor_metal",
	[MAT_SAND] = "search_floor_sand",
	[MAT_FOLIAGE] = "search_floor_foliage",
	[MAT_COMPUTER] = "search_floor_computer",
	[MAT_SLOSH] = "search_floor_slosh",
	[MAT_TILE] = "search_floor_tile",
	[MAT_GRASS] = "search_floor_grass",
	[MAT_VENT] = "search_floor_vent",
	[MAT_WOOD] = "search_floor_wood",
	[MAT_DEFAULT] = "search_floor_default",
	[MAT_GLASS] = "search_floor_glass",
	[MAT_WARPSHIELD] = "search_floor_warpshield"
}

local hitgroup_to_text = {
	[HITGROUP_HEAD] = "search_hitgroup_head",
	[HITGROUP_CHEST] = "search_hitgroup_chest",
	[HITGROUP_STOMACH] = "search_hitgroup_stomach",
	[HITGROUP_RIGHTARM] = "search_hitgroup_rightarm",
	[HITGROUP_LEFTARM] = "search_hitgroup_leftarm",
	[HITGROUP_RIGHTLEG] = "search_hitgroup_rightleg",
	[HITGROUP_LEFTLEG] = "search_hitgroup_leftleg",
	[HITGROUP_GEAR] = "search_hitgroup_gear"
}

local function DamageToText(dmg)
	for key, value in pairs(dtt) do
		if is_dmg(dmg, value) then
			return key
		end
	end

	if is_dmg(dmg, DMG_DIRECT) then
		return "burn"
	end

	return "other"
end

local RawToText = {
	last_words = function(data)
		if not data.words or data.words == "" then return end

		-- only append "--" if there's no ending interpunction
		local final = string.match(data.words, "[\\.\\!\\?]$") ~= nil

		return {
			title = {
				body = "search_title_words",
				params = nil
			},
			text = {{
				body = "search_words",
				params = {lastwords = d .. (final and "" or "--.")}
			}}
		}
	end,
	c4_disarm = function(data)
		if data.c4wire <= 0 then return end

		return {
			title = {
				body = "search_title_c4",
				params = nil
			},
			text = {{
				body = "search_c4",
				params = {num = data.c4wire}
			}}
		}
	end,
	dmg = function(data)
		local ret_text = {
			title = {
				body = "search_title_dmg_" .. DamageToText(data.dmg),
				params = {amount = data.last_damage}
			},
			text = {{
				body = "search_dmg_" .. DamageToText(data.dmg),
				params = nil
			}}
		}

		if (data.ori ~= CORPSE_KILL_NONE) then
			ret_text.text[#ret_text.text + 1] = {
				body = orientation_to_text[data.ori],
				params = nil
			}
		end

		if (data.head) then
			ret_text.text[#ret_text.text + 1] = {
				body = "search_head",
				params = nil
			}
		end

		return ret_text
	end,
	wep = function(data)
		local wep = util.WeaponForClass(data.wep)

		local wname = wep and wep.PrintName

		if not wname then return end

		local ret_text = {
			title = {
				body = wname,
				params = nil
			},
			text = {{
				body = "search_weapon",
				params = {weapon = wname}
			}}
		}

		if data.dist ~= CORPSE_KILL_NONE then
			ret_text.text[#ret_text.text + 1] = {
				body = distance_to_text[data.dist],
				params = nil
			}
		end

		if data.hit_group > 0 then
			ret_text.text[#ret_text.text + 1] = {
				body = hitgroup_to_text[data.hit_group],
				params = nil
			}
		end

		return ret_text
	end,
	death_time = function(data)
		return {
			title = {
				body = "search_title_time",
				params = nil
			},
			text = {{
				body = "search_time",
				params = nil
			}}
		}
	end,
	dna_time = function(data)
		return {
			title = {
				body = "search_title_dna",
				params = nil
			},
			text = {{
				body = "search_dna",
				params = nil
			}}
		}
	end,
	kill_list = function(data)
		if not data.kills then return end

		local num = table.Count(data.kills)

		if num == 1 then
			local vic = Entity(data.kills[1])
			local dc = data.kills[1] == -1 -- disconnected

			if dc or IsValid(vic) and vic:IsPlayer() then
				return {
					title = {
						body = "search_title_kills",
						params = nil
					},
					text = {{
						body = "search_kills1",
						params = {player = dc and "<Disconnected>" or vic:Nick()}
					}}
				}
			end
		elseif num > 1 then
			local nicks = {}

			for k, idx in pairs(data.kills) do
				local vic = Entity(idx)
				local dc = idx == -1

				if dc or IsValid(vic) and vic:IsPlayer() then
					nicks[#nicks + 1] = dc and "<Disconnected>" or vic:Nick()
				end
			end

			return {
				title = {
					body = "search_title_kills",
					params = nil
				},
				text = {{
					body = "search_kills2",
					params = {player = table.concat(nicks, "\n", 1, last)}
				}}
			}
		end
	end,
	last_id = function(data)
		if not data.idx or data.idx == -1 then return end

		local ent = Entity(data.idx)

		if not IsValid(ent) or not ent:IsPlayer() then return end

		return {
			title = {
				body = "search_title_eyes",
				params = nil
			},
			text = {{
				body = "search_eyes",
				params = {player = ent:Nick()}
			}}
		}
	end,
	floor_surface = function(data)
		if data.floor == 0 or not floorid_to_text[data.floor] then return end

		return {
			title = {
				body = "search_title_floor",
				params = nil
			},
			text = {{
				body = floorid_to_text[data.floor],
				params = {}
			}}
		}
	end,
	credits = function(data)
		if data.credits == 0 then return end

		return {
			title = {
				body = "search_title_credits",
				params = {credits = data.credits}
			},
			text = {{
				body = "search_credits",
				params = {credits = data.credits}
			}}
		}
	end,
	water_level = function(data)
		if not data.water_level or data.water_level == 0 then return end

		return {
			title = {
				body = "search_title_water",
				params = {level = data.water_level}
			},
			text = {{
				body = "search_water_" .. data.water_level,
				params = nil
			}}
		}
	end
}

local function WeaponToIconMaterial(cls)
	local wep = util.WeaponForClass(cls)

	return (wep and wep.Icon) and Material(wep.Icon) or Material("vgui/ttt/missing_equip_icon")
end

local function DamageToIconMaterial(dmg)
	for key, value in pairs(dtm) do
		if utilBitSet(dmg, value) then
			return Material("vgui/ttt/icon_" .. key)
		end
	end

	if utilBitSet(dmg, DMG_DIRECT) then
		return Material("vgui/ttt/icon_fire")
	else
		return Material("vgui/ttt/icon_skull")
	end
end


---
-- @class SEARCHSCRN
SEARCHSCRN = SEARCHSCRN or {}
SEARCHSCRN.sizes = SEARCHSCRN.sizes or {}
SEARCHSCRN.menuFrame = SEARCHSCRN.menuFrame or nil
SEARCHSCRN.data = SEARCHSCRN.data or {}

function SEARCHSCRN:CalculateSizes()
	self.sizes.width = 600
	self.sizes.height = 500
	self.sizes.padding = 10

	self.sizes.heightButton = 45
	self.sizes.widthButton = 160
	self.sizes.widthButtonCredits = 210
	self.sizes.widthButtonClose = 100
	self.sizes.heightBottomButtonPanel = self.sizes.heightButton + self.sizes.padding + 1

	self.sizes.widthMainArea = self.sizes.width - 2 * self.sizes.padding
	self.sizes.heightMainArea = self.sizes.height - self.sizes.heightBottomButtonPanel - 3 * self.sizes.padding - vskin.GetHeaderHeight() - vskin.GetBorderSize()

	self.sizes.widthProfileArea = 200

	self.sizes.widthContentArea = self.sizes.width - self.sizes.widthProfileArea - 3 * self.sizes.padding
	self.sizes.widthContentBox = self.sizes.widthContentArea - 2 * self.sizes.padding - 100

	self.sizes.heightInfoItem = 78
end

function SEARCHSCRN:MakeInfoItem(parent, icon, raw_text, color, live_time)
	local box = vgui.Create("DInfoItemTTT2", parent)
	box:SetSize(self.sizes.widthContentBox, self.sizes.heightInfoItem)
	box:Dock(TOP)
	box:DockMargin(0, 0, 0, self.sizes.padding)

	box:SetIcon(icon)
	box:SetTitle(raw_text.title)
	box:SetText(raw_text.text)
	box:SetColor(color)
	box:SetLiveTime(live_time)

	return box
end

function SEARCHSCRN:Show(data)
	local client = LocalPlayer()

	self:CalculateSizes()

	local frame = self.menuFrame

	-- IF MENU ELEMENT DOES NOT ALREADY EXIST, CREATE IT
	if IsValid(frame) then
		frame:ClearFrame(nil, nil, "search_title")
	else
		frame = vguihandler.GenerateFrame(self.sizes.width, self.sizes.height, "search_title", true)
	end

	frame:SetPadding(self.sizes.padding, self.sizes.padding, self.sizes.padding, self.sizes.padding)

	-- any keypress closes the frame
	frame:SetKeyboardInputEnabled(true)
	frame.OnKeyCodePressed = util.BasicKeyHandler

	self.menuFrame = frame

	frame.data = data

	local search_add = {}
	---
	-- @realm client
	hook.Run("TTTBodySearchPopulate", search_add, search)

	local rd = roles.GetByIndex(data.role)

	local contentBox = vgui.Create("DPanelTTT2", frame)
	contentBox:SetSize(self.sizes.widthMainArea, self.sizes.heightMainArea)
	contentBox:Dock(TOP)

	local profileBox = vgui.Create("DProfilePanelTTT2", contentBox)
	profileBox:SetSize(self.sizes.widthProfileArea, self.sizes.heightMainArea)
	profileBox:Dock(LEFT)
	profileBox:SetModel(data.ply_model, data.ply_model_color)
	profileBox:SetPlayerIconBySteamID64(data.ply_sid64)
	profileBox:SetPlayerRoleColor(data.role_color)
	profileBox:SetPlayerRoleIcon(rd.iconMaterial)
	profileBox:SetPlayerRoleString(rd.name)
	profileBox:SetPlayerTeamString(data.team)

	-- ADD STATUS BOX AND ITS CONTENT
	local contentAreaScroll = vgui.Create("DScrollPanelTTT2", contentBox)
	contentAreaScroll:SetVerticalScrollbarEnabled(true)
	contentAreaScroll:SetSize(self.sizes.widthContentArea, self.sizes.heightMainArea)
	contentAreaScroll:Dock(RIGHT)

	-- weapon information
	local wep_data = RawToText.wep({wep = data.wep, dist = data.kill_distance, hit_group = data.kill_hitgroup})
	if (wep_data) then
		self:MakeInfoItem(contentAreaScroll, WeaponToIconMaterial(data.wep), wep_data)
	end

	-- damage information
	local damage_icon = DamageToIconMaterial(data.dmg)
	if (data.head) then
		damage_icon = Material("vgui/ttt/icon_head")
	end
	self:MakeInfoItem(contentAreaScroll, damage_icon, RawToText.dmg({dmg = data.dmg, ori = data.kill_angle, head = data.head, last_damage = data.last_damage}))

	-- time information
	self:MakeInfoItem(contentAreaScroll, Material("vgui/ttt/icon_time"), RawToText.death_time({}), nil, data.dtime)

	-- credit information
	local credit_box
	if (data.credits > 0) then
		credit_box = self:MakeInfoItem(contentAreaScroll, Material("vgui/ttt/icon_credits"), RawToText.credits({credits = data.credits}), COLOR_GOLD)
	end

	-- dna sample information
	if (data.stime - CurTime() > 0) then
		self:MakeInfoItem(contentAreaScroll, Material("vgui/ttt/icon_wtester"), RawToText.dna_time({}), roles.DETECTIVE.ltcolor, data.stime):SetLiveTimeInverted(true)
	end

	-- floor surface information
	local floor_data = data.kill_floor_surface
	if (floor_data) then
		self:MakeInfoItem(contentAreaScroll, Material("vgui/ttt/icon_floor"), RawToText.floor_surface({floor = floor_data}))
	end

	-- water death information
	local water_data = RawToText.water_level({water_level = data.kill_water_level})
	if (water_data) then
		self:MakeInfoItem(contentAreaScroll, Material("vgui/ttt/icon_water_" .. data.kill_water_level), water_data)
	end

	-- c4 information
	local c4_data = RawToText.c4_disarm({c4wire = data.c4})
	if (c4_data) then
		self:MakeInfoItem(contentAreaScroll, Material("vgui/ttt/icon_code"), c4_data)
	end

	-- last id information
	local lastid_data = RawToText.last_id({idx = data.idx})
	if (lastid_data) then
		self:MakeInfoItem(contentAreaScroll, Material("vgui/ttt/icon_lastid"), lastid_data)
	end

	-- kill list information
	local killlist_data = RawToText.kill_list({kills = data.kills})
	if (killlist_data) then
		self:MakeInfoItem(contentAreaScroll, Material("vgui/ttt/icon_list"), killlist_data)
	end

	-- last words information
	local last_words_data = RawToText.last_words({words = data.words})
	if (last_words_data) then
		self:MakeInfoItem(contentAreaScroll, Material("vgui/ttt/icon_halp"), last_words_data)
	end

	-- additional information by other addons
	for _, v in pairs(search_add) do
		if (istable(v.text)) then
			self:MakeInfoItem(contentAreaScroll, Material(v.img), {title = v.title, text = text})
		else
			self:MakeInfoItem(contentAreaScroll, Material(v.img), {title = v.title, text = {{body = v.text}}})
		end
	end

	-- BUTTONS
	local buttonArea = vgui.Create("DButtonPanelTTT2", frame)
	buttonArea:SetSize(self.sizes.width, self.sizes.heightBottomButtonPanel)
	buttonArea:Dock(BOTTOM)

	local buttonCall = vgui.Create("DButtonTTT2", buttonArea)
	buttonCall:SetText("search_call")
	buttonCall:SetSize(self.sizes.widthButton, self.sizes.heightButton)
	buttonCall:SetPos(0, self.sizes.padding + 1)
	buttonCall.DoClick = function(btn)
		RunConsoleCommand("ttt_call_detective", data.eidx)
	end
	buttonCall:SetIcon(roles.DETECTIVE.iconMaterial, true, 16)

	local buttonConfirm = vgui.Create("DButtonTTT2", buttonArea)

	if client:IsSpec() then
		local text = "search_confirm"
		if (data.owner and IsValid(data.owner) and data.owner:TTT2NETGetBool("body_found", false)) then
			text = "search_confirmed"
		end

		buttonConfirm:SetEnabled(false)
		buttonConfirm:SetText(text)
		buttonConfirm:SetSize(self.sizes.widthButton, self.sizes.heightButton)
		buttonConfirm:SetPos(self.sizes.widthMainArea - self.sizes.widthButton, self.sizes.padding + 1)
	elseif data.owner and IsValid(data.owner) and data.owner:TTT2NETGetBool("body_found", false) then
		buttonConfirm:SetEnabled(false)
		buttonConfirm:SetText("search_confirmed")
		buttonConfirm:SetSize(self.sizes.widthButton, self.sizes.heightButton)
		buttonConfirm:SetPos(self.sizes.widthMainArea - self.sizes.widthButton, self.sizes.padding + 1)
	elseif data.credits > 0 and client:IsActiveShopper() and not client:GetSubRoleData().preventFindCredits then
		buttonConfirm:SetText("search_confirm_credits")
		buttonConfirm:SetParams({credits = data.credits})
		buttonConfirm:SetSize(self.sizes.widthButtonCredits, self.sizes.heightButton)
		buttonConfirm:SetPos(self.sizes.widthMainArea - self.sizes.widthButtonCredits, self.sizes.padding + 1)
		buttonConfirm:SetIcon(Material("vgui/ttt/icon_credits_transparent"))

		buttonConfirm.player_can_take_credits = true
	else
		buttonConfirm:SetText("search_confirm")
		buttonConfirm:SetSize(self.sizes.widthButton, self.sizes.heightButton)
		buttonConfirm:SetPos(self.sizes.widthMainArea - self.sizes.widthButton, self.sizes.padding + 1)
	end
	buttonConfirm.DoClick = function(btn)
		RunConsoleCommand("ttt_confirm_death", data.eidx, data.eidx + data.dtime, data.lrng)

		if (IsValid(credit_box) and btn.player_can_take_credits) then
			credit_box:Remove()
		end
	end

	self.buttonConfirm = buttonConfirm
end

function SEARCHSCRN:Close()
	if not IsValid(self.menuFrame) then return end

	self.menuFrame:CloseFrame()
end
