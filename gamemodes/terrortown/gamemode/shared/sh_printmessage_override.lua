if SERVER then
	function PrintMessage(type, message, plys)
		if type == HUD_PRINTNOTIFY or type == HUD_PRINTCONSOLE then
			LANG.Msg(plys, message, nil, MSG_CONSOLE)
		elseif type == HUD_PRINTTALK then
			LANG.Msg(plys, message, nil, MSG_CHAT_PLAIN)
		elseif type == HUD_PRINTCENTER then
			EPOP:AddMessage(plys, message, nil, 4, true)
		end
	end
end

if CLIENT then

end