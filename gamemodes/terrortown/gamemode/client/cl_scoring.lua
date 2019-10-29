---
-- @class CLSCORE
-- @desc Game report

ttt_include("cl_awards")

local table = table
local string = string
local vgui = vgui
local pairs = pairs
local math = math
local net = net
local ipairs = ipairs
local timer = timer
local util = util
local IsValid = IsValid

local skull_icon = Material("HUD/killicons/default")

CLSCORE = {}
CLSCORE.Events = {}
CLSCORE.Scores = {}
CLSCORE.Tms = {}
CLSCORE.Players = {}
CLSCORE.EventDisplay = {}
CLSCORE.StartTime = 0
CLSCORE.Panel = nil

surface.CreateFont("WinHuge", {font = "Trebuchet24", size = 72, weight = 1000, shadow = true})

-- so much text here I'm using shorter names than usual
local T = LANG.GetTranslation
local PT = LANG.GetParamTranslation

---
-- Returns the output of an event
-- @param string key Index of the display @{function}
-- @param table event
-- @return any
-- @realm client
-- @internal
function CLSCORE:GetDisplay(key, event)
	local displayfns = self.EventDisplay[event.id]
	if not displayfns then return end

	local keyfn = displayfns[key]
	if not keyfn then return end

	return keyfn(event)
end

---
-- Returns the text for a given event
-- @param table e The event
-- @return string The event text
-- @realm client
-- @internal
function CLSCORE:TextForEvent(e)
	return self:GetDisplay("text", e)
end

---
-- Returns the icon data for a given event
-- @param table e The event
-- @return table Icon data table
-- @realm client
-- @internal
function CLSCORE:IconForEvent(e)
	return self:GetDisplay("icon", e)
end

---
-- Returns the time for an event
-- @param table e The event
-- @return string Formatted time
-- @realm client
-- @internal
function CLSCORE:TimeForEvent(e)
	local t = e.t - self.StartTime

	if t >= 0 then
		return util.SimpleTime(t, "%02i:%02i")
	else
		return "	 "
	end
end

---
-- Tell CLSCORE how to display an event. See @{file/cl_scoring_events.lua} for examples.
-- @param number event_id
-- @param table event_fns The event table @{function}s. Pass an empty table to keep an event from showing up.
-- @realm client
-- @module CLSCORE
function CLSCORE.DeclareEventDisplay(event_id, event_fns)
	-- basic input vetting, can't check returned value types because the
	-- functions may be impure
	if not tonumber(event_id) then
		Error("Event ??? display: invalid event id\n")
	end

	if not event_fns or not istable(event_fns) then
		Error(Format("Event %d display: no display functions found.\n", event_id))
	end

	if not event_fns.text then
		Error(Format("Event %d display: no text display function found.\n", event_id))
	end

	if not event_fns.icon then
		Error(Format("Event %d display: no icon and tooltip display function found.\n", event_id))
	end

	CLSCORE.EventDisplay[event_id] = event_fns
end

---
-- Fills a given @{Panel} DList with the stored event data
-- @param Panel dlst
-- @realm client
-- @internal
function CLSCORE:FillDList(dlst)
	for _, e in pairs(self.Events) do
		local etxt = self:TextForEvent(e)
		local eicon, ttip = self:IconForEvent(e)
		local etime = self:TimeForEvent(e)

		if etxt then
			if eicon then
				local mat = eicon

				eicon = vgui.Create("DImage")
				eicon:SetMaterial(mat)
				eicon:SetTooltip(ttip)
				eicon:SetKeepAspect(true)
				eicon:SizeToContents()
			end

			dlst:AddLine(etime, eicon, "	" .. etxt)
		end
	end
end

---
-- Creates the event logs
-- @param Panel dpanel
-- @realm client
-- @internal
function CLSCORE:BuildEventLogPanel(dpanel)
	local margin = 10
	local w, h = dpanel:GetSize()

	local dlist = vgui.Create("DListView", dpanel)
	dlist:SetPos(0, 0)
	dlist:SetSize(w, h - margin * 2)
	dlist:SetSortable(true)
	dlist:SetMultiSelect(false)

	local timecol = dlist:AddColumn(T("col_time"))
	local iconcol = dlist:AddColumn("")
	local eventcol = dlist:AddColumn(T("col_event"))

	iconcol:SetFixedWidth(16)
	timecol:SetFixedWidth(40)

	-- If sortable is off, no background is drawn for the headers which looks
	-- terrible. So enable it, but disable the actual use of sorting.
	iconcol.Header:SetDisabled(true)
	timecol.Header:SetDisabled(true)
	eventcol.Header:SetDisabled(true)

	self:FillDList(dlist)
end

---
-- Creates the score @{Panel}
-- @param Panel dpanel
-- @realm client
-- @internal
-- @internal
function CLSCORE:BuildScorePanel(dpanel)
	--local margin = 10
	local w, h = dpanel:GetSize()

	local dlist = vgui.Create("DListView", dpanel)
	dlist:SetPos(0, 0)
	dlist:SetSize(w, h)
	dlist:SetSortable(true)
	dlist:SetMultiSelect(false)

	local colnames = {"", "col_player", "col_roles", "col_teams", "col_kills1", "col_kills2", "col_points", "col_team", "col_total"}

	for _, name in pairs(colnames) do
		if name == "" then
			-- skull icon column
			local c = dlist:AddColumn("")
			c:SetFixedWidth(18)
		else
			dlist:AddColumn(T(name))
		end
	end

	-- the type of win condition triggered is relevant for team bonus
	local wintype = WIN_NONE
	local events = self.Events
	local rls = {}
	local teams = {}
	local role = {}
	local team = {}

	for i = #events, 1, -1 do
		local e = events[i]

		if e.id == EVENT_FINISH then
			wintype = e.win
		elseif e.id == EVENT_SELECTED then
			local subroles = e.rt
			local tms = e.tms

			for sr, ids in pairs(subroles) do
				for _, id in ipairs(ids) do
					rls[id] = rls[id] or {}
					teams[id] = teams[id] or {}
					role[id] = role[id] or ""
					team[id] = team[id] or ""

					if not rls[id][sr] then
						role[id] = (role[id] ~= "" and (role[id] .. "/") or "") .. T(roles.GetByIndex(sr).name)
						rls[id][sr] = true
					end
				end
			end

			for tm, ids in pairs(tms) do
				for _, id in ipairs(ids) do
					rls[id] = rls[id] or {}
					teams[id] = teams[id] or {}
					role[id] = role[id] or ""
					team[id] = team[id] or ""

					if tm ~= TEAM_NONE and not teams[id][tm] then
						team[id] = (team[id] ~= "" and (team[id] .. "/") or "") .. T(tm)
						teams[id][tm] = true
					end
				end
			end
		end
	end

	local scores = self.Scores
	local nicks = self.Players
	local bonus = ScoreTeamBonus(scores, wintype)

	for id, s in pairs(scores) do
		if id ~= -1 then
			local kills = 0
			local teamkills = 0

			rls[id] = rls[id] or {}
			teams[id] = teams[id] or {}
			role[id] = role[id] or ""
			team[id] = team[id] or ""

			if s.ev then
				for _, ev in ipairs(s.ev) do
					if ev.t == TEAM_NONE or ev.t ~= ev.v or TEAMS[ev.t].alone then
						kills = kills + 1
					else
						teamkills = teamkills + 1
					end

					if not rls[id][ev.r] then
						role[id] = (role[id] ~= "" and (role[id] .. "/") or "") .. T(roles.GetByIndex(ev.r).name)
						rls[id][ev.r] = true
					end

					if ev.t ~= TEAM_NONE and not teams[id][ev.t] then
						team[id] = (team[id] ~= "" and (team[id] .. "/") or "") .. T(ev.t)
						teams[id][ev.t] = true
					end
				end
			end

			local surv = ""

			if s.deaths > 0 then
				surv = vgui.Create("ColoredBox", dlist)
				surv:SetColor(Color(150, 50, 50))
				surv:SetBorder(false)
				surv:SetSize(18, 18)

				local skull = vgui.Create("DImage", surv)
				skull:SetMaterial(skull_icon)
				skull:SetTooltip("Dead")
				skull:SetKeepAspect(true)
				skull:SetSize(18, 18)
			end

			local points_own = KillsToPoints(s)
			local points_team = bonus[id]
			local points_total = points_own + points_team

			local l = dlist:AddLine(surv, nicks[id], role[id], team[id], kills, teamkills, points_own, points_team, points_total)

			-- center align
			for _, col in pairs(l.Columns) do
				col:SetContentAlignment(5)
			end

			-- when sorting on the column showing survival, we would get an error
			-- because images can't be sorted, so instead hack in a dummy value
			local surv_col = l.Columns[1]
			if surv_col then
				surv_col.Value = type(surv_col.Value) == "Panel" and "1" or "0"
			end
		end
	end

	dlist:SortByColumn(6)
end

---
-- Adds an award into the stored events and returns the new Y Coordinate
-- @param number y the Y Coordinate
-- @param number pw the @{Panel} width
-- @param table award the award data
-- @param Panel dpanel
-- @return number The modified Y Coordinate
-- @realm client
-- @internal
function CLSCORE:AddAward(y, pw, award, dpanel)
	local nick = award.nick
	local text = award.text
	local title = string.upper(award.title)

	local titlelbl = vgui.Create("DLabel", dpanel)
	titlelbl:SetText(title)
	titlelbl:SetFont("TabLarge")
	titlelbl:SizeToContents()

	local tiw, tih = titlelbl:GetSize()

	local nicklbl = vgui.Create("DLabel", dpanel)
	nicklbl:SetText(nick)
	nicklbl:SetFont("DermaDefaultBold")
	nicklbl:SizeToContents()

	local nw, nh = nicklbl:GetSize()

	local txtlbl = vgui.Create("DLabel", dpanel)
	txtlbl:SetText(text)
	txtlbl:SetFont("DermaDefault")
	txtlbl:SizeToContents()

	local tw = txtlbl:GetSize()

	titlelbl:SetPos((pw - tiw) * 0.5, y)

	y = y + tih + 2

	local fw = nw + tw + 5
	local fx = (pw - fw) * 0.5

	nicklbl:SetPos(fx, y)
	txtlbl:SetPos(fx + nw + 5, y)

	y = y + nh

	return y
end

---
-- double check that we have no nils
local function ValidAward(a)
	return a and a.nick and a.text and a.title and a.priority
end

---
-- Creates the highlights @{Panel}
-- @param Panel dpanel
-- @realm client
-- @internal
function CLSCORE:BuildHilitePanel(dpanel)
	local w, h = dpanel:GetSize()
	local title = {c = TEAMS[TEAM_INNOCENT].color or INNOCENT.color, txt = "hilite_win_" .. TEAM_INNOCENT}
	local endtime = self.StartTime

	for i = #self.Events, 1, -1 do
		local e = self.Events[i]

		if e.id == EVENT_FINISH then
			endtime = e.t

			local wintype = e.win

			-- when win is due to timeout, innocents win
			if wintype == WIN_TIMELIMIT then
				wintype = WIN_INNOCENT
			end

			if wintype ~= WIN_NONE then
				if wintype == WIN_TRAITOR then
					wintype = TEAM_TRAITOR
				elseif wintype == WIN_INNOCENT then
					wintype = TEAM_INNOCENT
				end

				title = {c = TEAMS[wintype].color or c, txt = "hilite_win_" .. wintype}
			end

			break
		end
	end

	local tr = {}

	for k, v in pairs(self.Tms) do
		if k == TEAM_TRAITOR then
			table.Add(tr, v)
		end
	end

	local roundtime = endtime - self.StartTime
	local numply = table.Count(self.Players)
	local numtr = table.Count(tr)

	local bg = vgui.Create("ColoredBox", dpanel)
	bg:SetColor(Color(50, 50, 50, 255))
	bg:SetSize(w, h)
	bg:SetPos(0, 0)

	local winlbl = vgui.Create("DLabel", dpanel)
	winlbl:SetFont("WinHuge")
	winlbl:SetText(T(title.txt))
	winlbl:SetTextColor(COLOR_WHITE)
	winlbl:SizeToContents()

	local xwin = (w - winlbl:GetWide()) * 0.5
	local ywin = 30

	winlbl:SetPos(xwin, ywin)

	bg.PaintOver = function()
		draw.RoundedBox(8, xwin - 15, ywin - 5, winlbl:GetWide() + 30, winlbl:GetTall() + 10, title.c)
	end

	local ysubwin = ywin + winlbl:GetTall()
	local partlbl = vgui.Create("DLabel", dpanel)
	local plytxt = PT(numtr == 1 and "hilite_players2" or "hilite_players1", {numplayers = numply, numtraitors = numtr})

	partlbl:SetText(plytxt)
	partlbl:SizeToContents()
	partlbl:SetPos(xwin, ysubwin + 8)

	local timelbl = vgui.Create("DLabel", dpanel)
	timelbl:SetText(PT("hilite_duration", {time = util.SimpleTime(roundtime, "%02i:%02i")}))
	timelbl:SizeToContents()
	timelbl:SetPos(xwin + winlbl:GetWide() - timelbl:GetWide(), ysubwin + 8)

	-- Awards
	local wa = math.Round(w * 0.9)
	local ha = h - ysubwin - 40
	local xa = (w - wa) * 0.5
	local ya = h - ha

	local awardp = vgui.Create("DPanel", dpanel)
	awardp:SetSize(wa, ha)
	awardp:SetPos(xa, ya)
	awardp:SetPaintBackground(false)

	-- Before we pick awards, seed the rng in a way that is the same on all
	-- clients. We can do this using the round start time. To make it a bit more
	-- random, involve the round's duration too.
	math.randomseed(self.StartTime + endtime)
	math.random(); math.random(); math.random() -- warming up

	-- Attempt to generate every award, then sort the succeeded ones based on
	-- priority/interestingness
	local award_choices = {}

	for _, afn in pairs(AWARDS) do
		local a = afn(self.Events, self.Scores, self.Players, tr) -- TODO: get this tr var out of scores.sid64.lt == TEAM_TRAITOR

		if ValidAward(a) then
			table.insert(award_choices, a)
		end
	end

	--local num_choices = #award_choices
	local max_awards = 5

	-- sort descending by priority
	table.SortByMember(award_choices, "priority")

	-- put the N most interesting awards in the menu
	for i = 1, max_awards do
		local a = award_choices[i]
		if a then
			self:AddAward((i - 1) * 42, wa, a, awardp)
		end
	end
end

---
-- Displays the score @{Panel} for the local @{Player}
-- @realm client
function CLSCORE:ShowPanel()
	local margin = 15
	local dpanel = vgui.Create("DFrame")
	local w, h = 700, 500

	dpanel:SetSize(700, 500)
	dpanel:Center()
	dpanel:SetTitle(T("report_title"))
	dpanel:SetVisible(true)
	dpanel:ShowCloseButton(true)
	dpanel:SetMouseInputEnabled(true)
	dpanel:SetKeyboardInputEnabled(true)
	dpanel.OnKeyCodePressed = util.BasicKeyHandler

	-- keep it around so we can reopen easily
	dpanel:SetDeleteOnClose(false)

	self.Panel = dpanel

	local dbut = vgui.Create("DButton", dpanel)
	local bw, bh = 100, 25

	dbut:SetSize(bw, bh)
	dbut:SetPos(w - bw - margin, h - bh - margin * 0.5)
	dbut:SetText(T("close"))

	dbut.DoClick = function()
		dpanel:Close()
	end

	local dsave = vgui.Create("DButton", dpanel)
	dsave:SetSize(bw, bh)
	dsave:SetPos(margin, h - bh - margin * 0.5)
	dsave:SetText(T("report_save"))
	dsave:SetTooltip(T("report_save_tip"))
	dsave:SetConsoleCommand("ttt_save_events")

	local dtabsheet = vgui.Create("DPropertySheet", dpanel)
	dtabsheet:SetPos(margin, margin + 15)
	dtabsheet:SetSize(w - margin * 2, h - margin * 3 - bh)

	local padding = dtabsheet:GetPadding()

	-- Highlight tab
	local dtabhilite = vgui.Create("DPanel", dtabsheet)
	dtabhilite:SetPaintBackground(false)
	dtabhilite:StretchToParent(padding, padding, padding, padding)

	self:BuildHilitePanel(dtabhilite)

	dtabsheet:AddSheet(T("report_tab_hilite"), dtabhilite, "icon16/star.png", false, false, T("report_tab_hilite_tip"))

	-- Event log tab
	local dtabevents = vgui.Create("DPanel", dtabsheet)
	--	dtab1:SetSize(650, 450)
	dtabevents:StretchToParent(padding, padding, padding, padding)

	self:BuildEventLogPanel(dtabevents)

	dtabsheet:AddSheet(T("report_tab_events"), dtabevents, "icon16/application_view_detail.png", false, false, T("report_tab_events_tip"))

	-- Score tab
	local dtabscores = vgui.Create("DPanel", dtabsheet)
	dtabscores:SetPaintBackground(false)
	dtabscores:StretchToParent(padding, padding, padding, padding)

	self:BuildScorePanel(dtabscores)

	dtabsheet:AddSheet(T("report_tab_scores"), dtabscores, "icon16/user.png", false, false, T("report_tab_scores_tip"))

	dpanel:MakePopup()

	-- makepopup grabs keyboard, whereas we only need mouse
	dpanel:SetKeyboardInputEnabled(false)
end

---
-- Clears the current score @{Panel} and removes it
-- @realm client
-- @internal
function CLSCORE:ClearPanel()
	if self.Panel then
		-- move the mouse off any tooltips and then remove the panel next tick

		-- we need this hack as opposed to just calling Remove because gmod does
		-- not offer a means of killing the tooltip, and doesn't clean it up
		-- properly on Remove
		input.SetCursorPos(ScrW() * 0.5, ScrH() * 0.5)

		local pnl = self.Panel

		timer.Simple(0, function()
			if IsValid(pnl) then
				pnl:Remove()
			end
		end)
	end
end

---
-- Saves the current score @{Panel}'s data into a log file
-- @note The logfiles are stored in <code>ttt/logs</code>
-- @realm client
-- @internal
function CLSCORE:SaveLog()
	if self.Events and #self.Events <= 0 then
		chat.AddText(COLOR_WHITE, T("report_save_error"))

		return
	end

	local logdir = "ttt/logs"

	if not file.IsDir(logdir, "DATA") then
		file.CreateDir(logdir)
	end

	local logname = logdir .. "/ttt_events_" .. os.time() .. ".txt"
	local log = "Trouble in Terrorist Town 2 - Round Events Log\n" .. string.rep("-", 50) .. "\n"

	log = log .. string.format("%s | %-25s | %s\n", " TIME", "TYPE", "WHAT HAPPENED") .. string.rep("-", 50) .. "\n"

	for _, e in pairs(self.Events) do
		local etxt = self:TextForEvent(e)
		local etime = self:TimeForEvent(e)
		local _, etype = self:IconForEvent(e)

		if etxt then
			log = log .. string.format("%s | %-25s | %s\n", etime, etype, etxt)
		end
	end

	file.Write(logname, log)

	chat.AddText(COLOR_WHITE, T("report_save_result"), COLOR_GREEN, " /garrysmod/data/" .. logname)
end

---
-- Resets the stored data of the current score @{Panel}
-- @realm client
-- @internal
function CLSCORE:Reset()
	self.Events = {}
	self.Tms = {} -- team setup on round start
	self.Scores = {}
	self.Players = {}
	self.RoundStarted = 0

	self:ClearPanel()
end

---
-- Initializes the score @{Panel}
-- @param table events The list of events
-- @realm client
-- @internal
function CLSCORE:Init(events)
	-- Get start time and traitors
	local starttime
	local tms

	for _, e in pairs(events) do
		if e.id == EVENT_GAME and e.state == ROUND_ACTIVE then
			starttime = e.t
		elseif e.id == EVENT_SELECTED then
			tms = e.tms
		end

		if starttime and tms then break end
	end

	-- Get scores and players
	local scores = {}
	local nicks = {}

	for _, e in pairs(events) do
		if e.id == EVENT_SPAWN and e.sid64 ~= nil then
			scores[e.sid64] = ScoreInit()
			nicks[e.sid64] = e.ni
		end
	end

	scores = ScoreEventLog(events, scores)

	self.Players = nicks
	self.Scores = scores
	self.Tms = tms
	self.StartTime = starttime
	self.Events = events
end

---
-- Resets the old score @{Panel}, Initializes a new one
-- and displays it to the local @{Player}
-- @realm client
-- @internal
function CLSCORE:ReportEvents(events)
	self:Reset()

	self:Init(events)
	self:ShowPanel()
end

---
-- Toggles the visibility of the current score @{Panel}
-- @realm client
-- @internal
function CLSCORE:Toggle()
	if IsValid(self.Panel) then
		self.Panel:ToggleVisible()
	end
end

local buff = ""

local function ReceiveReportStream(len)
	local cont = net.ReadBit() == 1

	buff = buff .. net.ReadString()

	if cont then
		return
	else
		-- do stuff with buffer contents

		local json_events = buff -- util.Decompress(buff)

		if not json_events then
			ErrorNoHalt("Round report decompression failed!\n")
		else
			-- convert the json string back to a table
			local events = util.JSONToTable(json_events)

			if istable(events) then
				CLSCORE:ReportEvents(events)
			else
				ErrorNoHalt("Round report event decoding failed!\n")
			end
		end

		-- flush
		buff = ""
	end
end
net.Receive("TTT_ReportStream", ReceiveReportStream)

local function SaveLog(ply, cmd, args)
	CLSCORE:SaveLog()
end
concommand.Add("ttt_save_events", SaveLog)
