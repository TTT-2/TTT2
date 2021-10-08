local display_type = CreateConVar("ttt2_roleinfo_display_type", 0, FCVAR_NONE, "0 = Chat, 1 = EPops")
local display_time = CreateConVar("ttt2_roleinfo_display_time", 15, FCVAR_NONE, "Duration in Seconds")

if CLIENT then

    hook.Add("TTT2UpdateSubrole", "TTT2ShowRoleInfo", function (ply, _, new_role)

        local role_team = new_role.defaultTeam
        local title = "You are "

        if role_team == TEAM_INNOCENT then
            title = title .. "Innocent!"
        elseif role_team == TEAM_TRAITOR then
            title = title .. "Traitor!"
        else
            title = title .. "alone!"
        end

        local desc = "Lorem Ipsum dolo...."
        
        if display_type:GetInt() == 0 then
            chat.AddText(new_role.color, title)
            chat.AddText(Color(255, 255, 255), desc)
        elseif display_type:GetInt( == 1 then
            EPOP:AddMessage({text = title, color = new_role.color}, desc, display_time:GetInt())
        end
    end)

end