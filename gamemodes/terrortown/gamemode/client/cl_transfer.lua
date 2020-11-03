---
-- Credit transfer tab for equipment menu
-- @section credit_transfer

local GetTranslation = LANG.GetTranslation
local player = player

---
-- Creates the credit transfer menu
-- @param Panel parent
-- @return Panel the created DForm menu
-- @realm client
function CreateTransferMenu(parent)
	local client = LocalPlayer()

	local dform = vgui.Create("DForm", parent)
	dform:SetName(GetTranslation("xfer_menutitle"))
	dform:StretchToParent(0, 0, 0, 0)
	dform:SetAutoSize(false)

	if client:GetCredits() <= 0 then
		dform:Help(GetTranslation("xfer_no_credits"))

		return dform
	end

	local bw, bh = 100, 20

	local dsubmit = vgui.Create("DButton", dform)
	dsubmit:SetSize(bw, bh)
	dsubmit:SetDisabled(true)
	dsubmit:SetText(GetTranslation("xfer_send"))

	local selected_sid

	local dpick = vgui.Create("DComboBox", dform)
	dpick.OnSelect = function(s, idx, val, data)
		if data then
			selected_sid = data

			dsubmit:SetDisabled(false)
		end
	end

	dpick:SetWide(250)

	-- fill combobox
	local plys = player.GetAll()

	for i = 1, #plys do
		local ply = plys[i]

		if ply ~= client and ply:IsActive() and (not ply:GetSubRoleData().unknownTeam or ply:IsRole(ROLE_DETECTIVE) and client:IsRole(ROLE_DETECTIVE)) and ply:IsInTeam(client) then
			dpick:AddChoice(ply:Nick(), ply:SteamID64())
		end
	end

	-- select first player by default
	if dpick:GetOptionText(1) then
		dpick:ChooseOptionID(1)
	end

	dsubmit.DoClick = function(s)
		if selected_sid then
			RunConsoleCommand("ttt_transfer_credits", selected_sid, "1")
		end
	end

	dsubmit.Think = function(s)
		if client:GetCredits() < 1 then
			s:SetDisabled(true)
		end
	end

	dform:AddItem(dpick)
	dform:AddItem(dsubmit)

	local tm = client:GetTeam()

	dform:Help(LANG.GetParamTranslation("xfer_help", {role = GetTranslation(tm)}))

	return dform
end
