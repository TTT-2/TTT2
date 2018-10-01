-- Some popup window stuff

local GetTranslation = LANG.GetTranslation
local GetPTranslation = LANG.GetParamTranslation

---- Round start

local function GetTextForPlayer(ply)
	local menukey = Key("+menu_context", "C")
	local roleData = ply:GetSubRoleData()

	if ply:GetTeam() ~= TEAM_TRAITOR then
		local fallback = GetConVar("ttt_" .. roleData.abbr .. "_shop_fallback"):GetString()
		if fallback == SHOP_DISABLED or hook.Run("TTT2PreventAccessShop", ply) then
			return GetTranslation("info_popup_" .. roleData.name)
		else
			return GetPTranslation("info_popup_" .. roleData.name, {menukey = Key("+menu_context", "C")})
		end
	else
		local traitors = {}

		for _, p in ipairs(player.GetAll()) do
			if p:HasTeam(TEAM_TRAITOR) then
				table.insert(traitors, p)
			end
		end

		if #traitors > 1 then
			local traitorlist = ""

			for _, p in ipairs(traitors) do
				if p ~= ply then
					traitorlist = traitorlist .. string.rep(" ", 42) .. p:Nick() .. "\n"
				end
			end

			local fallback = GetConVar("ttt_" .. roleData.abbr .. "_shop_fallback"):GetString()
			if fallback == SHOP_DISABLED or hook.Run("TTT2PreventAccessShop", ply) then
				return GetTranslation("info_popup_" .. roleData.name, {traitorlist = traitorlist})
			else
				return GetPTranslation("info_popup_" .. roleData.name, {menukey = menukey, traitorlist = traitorlist})
			end
		else
			local fallback = GetConVar("ttt_" .. roleData.abbr .. "_shop_fallback"):GetString()
			if fallback == SHOP_DISABLED or hook.Run("TTT2PreventAccessShop", ply) then
				return GetPTranslation("info_popup_" .. roleData.name .. "_alone")
			else
				return GetPTranslation("info_popup_" .. roleData.name .. "_alone", {menukey = menukey})
			end
		end
	end
end

local startshowtime = CreateConVar("ttt_startpopup_duration", "17", FCVAR_ARCHIVE)
-- shows info about goal and fellow traitors (if any)
local function RoundStartPopup()
	-- based on Derma_Message

	if startshowtime:GetInt() <= 0 then return end

	if not LocalPlayer() then return end

	local dframe = vgui.Create("Panel")
	dframe:SetDrawOnTop(true)
	dframe:SetMouseInputEnabled(false)
	dframe:SetKeyboardInputEnabled(false)

	local color = Color(0, 0, 0, 200)

	dframe.Paint = function(s)
		draw.RoundedBox(8, 0, 0, s:GetWide(), s:GetTall(), color)
	end

	local text = GetTextForPlayer(LocalPlayer())

	local dtext = vgui.Create("DLabel", dframe)
	dtext:SetFont("TabLarge")
	dtext:SetText(text)
	dtext:SizeToContents()
	dtext:SetContentAlignment(5)
	dtext:SetTextColor(color_white)

	local w, h = dtext:GetSize()
	local m = 10

	dtext:SetPos(m, m)

	dframe:SetSize(w + m * 2, h + m * 2)
	dframe:Center()

	dframe:AlignBottom(10)

	timer.Simple(startshowtime:GetInt(), function()
		dframe:Remove()
	end)
end
concommand.Add("ttt_cl_startpopup", RoundStartPopup)

--- Idle message
local function IdlePopup()
	local w, h = 300, 180

	local dframe = vgui.Create("DFrame")
	dframe:SetSize(w, h)
	dframe:Center()
	dframe:SetTitle(GetTranslation("idle_popup_title"))
	dframe:SetVisible(true)
	dframe:SetMouseInputEnabled(true)

	local inner = vgui.Create("DPanel", dframe)
	inner:StretchToParent(5, 25, 5, 45)

	local idle_limit = GetGlobalInt("ttt_idle_limit", 300) or 300

	local text = vgui.Create("DLabel", inner)
	text:SetWrap(true)
	text:SetText(GetPTranslation("idle_popup", {num = idle_limit, helpkey = Key("gm_showhelp", "F1")}))
	text:SetDark(true)
	text:StretchToParent(10, 5, 10, 5)

	local bw, bh = 75, 25
	local cancel = vgui.Create("DButton", dframe)

	cancel:SetPos(10, h - 40)
	cancel:SetSize(bw, bh)
	cancel:SetText(GetTranslation("idle_popup_close"))

	cancel.DoClick = function()
		dframe:Close()
	end

	local disable = vgui.Create("DButton", dframe)
	disable:SetPos(w - 185, h - 40)
	disable:SetSize(175, bh)
	disable:SetText(GetTranslation("idle_popup_off"))

	disable.DoClick = function()
		RunConsoleCommand("ttt_spectator_mode", "0")
		dframe:Close()
	end

	dframe:MakePopup()
end
concommand.Add("ttt_cl_idlepopup", IdlePopup)
