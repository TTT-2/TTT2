local display_type = CreateConVar("ttt2_roleinfo_display_type", 1, FCVAR_NONE, "0 = Chat, 1 = EPops")
local display_time = CreateConVar("ttt2_roleinfo_display_time", 15, FCVAR_NONE, "Duration in Seconds")

if CLIENT then

    local TryTranslation = LANG.TryTranslation
    local GetTranslation = LANG.GetTranslation

    local is_round_running = false

    hook.Add("TTTPrepareRound", "TTT2AllowShowRoleInfo", function ()
        is_round_running = true
    end)

    hook.Add("TTTEndRound", "TTT2DenyShowRoleInfo", function ()
        is_round_running = false
    end)

    hook.Add("TTT2UpdateSubrole", "TTT2ShowRoleInfo", function (ply, _, new_role_id)

        if ply:EntIndex() ~= LocalPlayer():EntIndex() or is_round_running == false then
            return
        end

        local new_role = roles.GetByIndex(new_role_id)

        local role_team = new_role.defaultTeam
        local title = ""

        if role_team == TEAM_INNOCENT then
            title = GetTranslation("roleinfo_belong_innocent")
        elseif role_team == TEAM_TRAITOR then
            title = GetTranslation("roleinfo_belong_traitor")
        else
            title = GetTranslation("roleinfo_belong_none")
        end

        local desc = GetRoleDescription(new_role)
        
        if display_type:GetInt() == 0 then
            chat.AddText(new_role.color, title)
            chat.AddText(Color(255, 255, 255), desc)
        elseif display_type:GetInt() == 1 then
            EPOP:AddMessage({text = title, color = new_role.color}, desc, display_time:GetInt())
        end
    end)

    function GetRoleDescription(role) 
        local key = "ttt2_roleinfo_" .. role.name

        local desc = TryTranslation(key)

        if desc == key then
            return TryTranslation("info_popup_" .. role.name)
        end

        return desc
    end
end