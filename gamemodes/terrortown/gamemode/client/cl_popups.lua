---
-- Some popup window stuff

local GetTranslation = LANG.GetTranslation
local GetPTranslation = LANG.GetParamTranslation
local timer = timer

---
-- Round start
local function GetTextForPlayer(ply)
    local menukey = Key("+menu_context", "C")
    local roleData = ply:GetSubRoleData()

    if ply:GetTeam() ~= TEAM_TRAITOR then
        local fallback = GetGlobalString("ttt_" .. roleData.abbr .. "_shop_fallback")

        ---
        -- @realm client
        if fallback == SHOP_DISABLED or hook.Run("TTT2PreventAccessShop", ply) then
            return GetTranslation("info_popup_" .. roleData.name)
        else
            return GetPTranslation("info_popup_" .. roleData.name, { menukey = menukey })
        end
    else
        local traitors = roles.GetTeamMembers(TEAM_TRAITOR)

        if traitors and #traitors > 1 then
            local traitorlist = {}

            for i = 1, #traitors do
                local p = traitors[i]

                if p == ply then
                    continue
                end

                local index = #traitorlist

                traitorlist[index + 1] = string.rep(" ", 42)
                traitorlist[index + 2] = p:Nick()
                traitorlist[index + 3] = "\n"
            end

            traitorlist = table.concat(traitorlist)

            local fallback = GetGlobalString("ttt_" .. roleData.abbr .. "_shop_fallback")

            ---
            -- @realm client
            if fallback == SHOP_DISABLED or hook.Run("TTT2PreventAccessShop", ply) then
                return GetPTranslation(
                    "info_popup_" .. roleData.name,
                    { traitorlist = traitorlist }
                )
            else
                return GetPTranslation(
                    "info_popup_" .. roleData.name,
                    { menukey = menukey, traitorlist = traitorlist }
                )
            end
        else
            local fallback = GetGlobalString("ttt_" .. roleData.abbr .. "_shop_fallback")

            ---
            -- @realm client
            if fallback == SHOP_DISABLED or hook.Run("TTT2PreventAccessShop", ply) then
                return GetTranslation("info_popup_" .. roleData.name .. "_alone")
            else
                return GetPTranslation(
                    "info_popup_" .. roleData.name .. "_alone",
                    { menukey = menukey }
                )
            end
        end
    end
end

---
-- @realm client
local startshowtime = CreateConVar("ttt_startpopup_duration", "17", FCVAR_ARCHIVE)

local function drawFunc(s, w, h)
    draw.RoundedBox(8, 0, 0, w, h, s.paintColor)
end

---
-- shows info about goal and fellow traitors (if any)
local function RoundStartPopup()
    -- based on Derma_Message
    if startshowtime:GetInt() <= 0 then
        return
    end

    local client = LocalPlayer()
    if not client or client:GetRole() == ROLE_NONE then
        return
    end

    local dframe = vgui.Create("Panel")
    dframe:SetDrawOnTop(true)
    dframe:SetMouseInputEnabled(false)
    dframe:SetKeyboardInputEnabled(false)

    dframe.paintColor = Color(0, 0, 0, 200)

    local paintFn = drawFunc

    if huds and HUDManager then
        local hud = huds.GetStored(HUDManager.GetHUD())
        if hud then
            paintFn = hud.PopupPaint or paintFn
        end
    end

    dframe.Paint = paintFn

    local text = GetTextForPlayer(client)

    local dtext = vgui.Create("DLabel", dframe)
    dtext:SetFont("TabLarge")
    dtext:SetText(text)
    dtext:SizeToContents()
    dtext:SetContentAlignment(5)
    dtext:SetTextColor(COLOR_WHITE)

    local w, h = dtext:GetSize()
    local m = 10

    dtext:SetPos(m, m)

    dframe:SetSize(w + m * 2, h + m * 2)
    dframe:Center()

    dframe:AlignBottom(10)

    timer.Simple(startshowtime:GetInt(), function()
        if not IsValid(dframe) then
            return
        end

        dframe:Remove()
    end)
end
concommand.Add("ttt_cl_startpopup", RoundStartPopup)

---
-- Idle message
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
    text:SetText(
        GetPTranslation("idle_popup", { num = idle_limit, helpkey = Key("gm_showhelp", "F1") })
    )
    text:SetDark(true)
    text:StretchToParent(10, 5, 10, 5)

    local bw, bh = 75, 25
    local cancel = vgui.Create("DButton", dframe)

    cancel:SetPos(10, h - 40)
    cancel:SetSize(bw, bh)
    cancel:SetText(GetTranslation("idle_popup_close"))

    cancel.DoClick = function()
        if not IsValid(dframe) then
            return
        end

        dframe:Close()
    end

    local disable = vgui.Create("DButton", dframe)
    disable:SetPos(w - 185, h - 40)
    disable:SetSize(175, bh)
    disable:SetText(GetTranslation("idle_popup_off"))

    disable.DoClick = function()
        if not IsValid(dframe) then
            return
        end

        RunConsoleCommand("ttt_spectator_mode", "0")

        dframe:Close()
    end

    dframe:MakePopup()
end
concommand.Add("ttt_cl_idlepopup", IdlePopup)
