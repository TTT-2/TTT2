--- Credit transfer tab for equipment menu
local GetTranslation = LANG.GetTranslation
local player = player
local ipairs = ipairs
local IsValid = IsValid

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
	for _, p in ipairs(player.GetAll()) do
		if p ~= client and p:IsActive() and (not p:GetSubRoleData().unknownTeam or p:IsRole(ROLE_DETECTIVE) and client:IsRole(ROLE_DETECTIVE)) and p:IsInTeam(client) then
			dpick:AddChoice(p:Nick(), p:SteamID64())
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
