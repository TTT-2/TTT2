concommand.Add("vguitest", function()
	local w = 1100
	local h = 700

	local Frame = vgui.Create("DFrameTTT2")
	Frame:SetPos(0.5 * (ScrW() - w), 0.5 * (ScrH() - h))
	Frame:SetSize(w, h)
	Frame:SetTitle("Testing Window")
	Frame:SetVisible(true)
	Frame:SetDraggable(true)
	Frame:ShowCloseButton(true)
	Frame:MakePopup()
	Frame:SetSkin("ttt2_default")
end)
