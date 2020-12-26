---
-- Credit transfer tab for equipment menu
-- @section credit_transfer

--Constants and Wrappers
local GetTranslation = LANG.GetTranslation
local CREDITS_PER_XFER = 1

--Globals (Due to server to client communication)
local dsubmit
local dhelp
local dform
local selected_sid

local function UpdateTransferSubmitButton(dsubmit, dhelp, dform, selected_sid)
	local client = LocalPlayer()
	if client:GetCredits() <= 0 then
		dhelp:SetText(GetTranslation("xfer_no_credits"))
		dsubmit:SetDisabled(true)
	elseif selected_sid then
		local ply = player.GetBySteamID64(selected_sid)
		local allow, msg = hook.Run("TTT2CanTransferCredits", client, ply, CREDITS_PER_XFER)

		if allow == false then
			dsubmit:SetDisabled(true)
		else
			dsubmit:SetDisabled(false)
		end

		if isstring(msg) then
			dhelp:SetText(msg)
		end
	end
end

net.Receive("TTT2CreditTransferUpdate", function()
	--Called after the server performs a successful transfer of credits.
	UpdateTransferSubmitButton(dsubmit, dhelp, dform, selected_sid)
end)

---
-- Creates the credit transfer menu
-- @param Panel parent
-- @return Panel the created DForm menu
-- @realm client
function CreateTransferMenu(parent)
	local client = LocalPlayer()

	dform = vgui.Create("DForm", parent)
	dform:SetName(GetTranslation("xfer_menutitle"))
	dform:StretchToParent(0, 0, 0, 0)
	dform:SetAutoSize(false)

	local bw, bh = 100, 20

	dsubmit = vgui.Create("DButton", dform)
	dsubmit:SetSize(bw, bh)
	dsubmit:SetDisabled(true)
	dsubmit:SetText(GetTranslation("xfer_send"))

	--Add the help button. Change its text dynamically to match the situation.
	dhelp = dform:Help("")

	local dpick = vgui.Create("DComboBox", dform)
	dpick.OnSelect = function(s, idx, val, data)
		if data then
			selected_sid = data

			--Upon selecting the player, determine if a transfer can be made to them.
			UpdateTransferSubmitButton(dsubmit, dhelp, dform, selected_sid)
		end
	end

	dpick:SetWide(250)

	-- fill combobox
	local plys = player.GetAll()

	for i = 1, #plys do
		local ply = plys[i]
		local sid = ply:SteamID64()

		--SteamID64() returns nil for bots on the client, and so credits can't be transferred to them.
		--Transfers can be made to players who have died (as the sender may not know if they're alive), but can't be made to spectators who joined in the middle of a match.
		if ply ~= client and (ply:IsTerror() or ply:IsDeadTerror()) and sid then
			dpick:AddChoice(ply:Nick(), sid)
		end
	end

	-- select first player by default
	if dpick:GetOptionText(1) then
		dpick:ChooseOptionID(1)
	end

	dsubmit.DoClick = function(s)
		if selected_sid then
			RunConsoleCommand("ttt_transfer_credits", selected_sid, CREDITS_PER_XFER)
		end
	end

	dform:AddItem(dpick)
	dform:AddItem(dsubmit)

	return dform
end
