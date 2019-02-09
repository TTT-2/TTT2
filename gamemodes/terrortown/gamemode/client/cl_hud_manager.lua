ttt_include("vgui__cl_hudswitcher")

local current_hud = CreateClientConVar("ttt2_current_hud", HUDManager.defaultHUD, true, true)

local currentHUD

HUDManager.IsEditing = false

local function EditLocalHUD()
	local client = LocalPlayer()
	local x, y = math.Round(gui.MouseX()), math.Round(gui.MouseY())
	local elem = client.activeElement

	if input.IsMouseDown(MOUSE_LEFT) then
		if not elem then
			local hud = huds.GetStored(HUDManager.GetHUD())
			if hud then
				for _, el in ipairs(hud:GetHUDElements()) do
					local elObj = hudelements.GetStored(el)
					if elObj and elObj:IsInPos(x, y) then
						elem = elObj

						local difPos = elem:GetPos()

						client.difX = x - difPos.x
						client.difY = y - difPos.y

						break
					end
				end
			end
		end

		local difX = client.difX or 0
		local difY = client.difY or 0

		if elem and (client.oldMX and client.oldMX ~= x or client.oldMY and client.oldMY ~= y) then
			local nx = x - difX
			local ny = y - difY
			local size = elem:GetSize()

			if nx < 0 then
				nx = 0
			elseif nx + size.w > ScrW() then
				nx = ScrW() - size.w
			end

			if ny < 0 then
				ny = 0
			elseif ny + size.h > ScrH() then
				ny = ScrH() - size.h
			end

			elem:SetPos(nx, ny)
			elem:PerformLayout()
		end
	else
		elem = nil
		client.difX = nil
		client.difY = nil
	end

	client.oldMX = x
	client.oldMY = y
	client.activeElement = elem
end

function HUDManager.EditHUD(bool)
	local client = LocalPlayer()

	gui.EnableScreenClicker(bool)

	if bool then
		if IsValid(client.hudswitcher) then
			client.hudswitcher:Hide()
		end

		local helper = vgui.Create("DFrame")
		helper:SetSize(100, 80)
		helper:Center()
		helper:SetTitle("HUD Editor")
		helper:SetVisible(true)
		helper:ShowCloseButton(true)
		helper:SetDeleteOnClose(true)

		helper.OnClose = function(slf)
			if not slf.forceClosing then
				HUDManager.EditHUD(false)
			end
		end

		helper:MakePopup()

		client.hudeditorHelp = helper

		hook.Add("Think", "TTT2EditHUD", EditLocalHUD)
	else
		if IsValid(client.hudswitcher) then
			client.hudswitcher:Show()
		end

		if IsValid(client.hudeditorHelp) then
			client.hudeditorHelp.forceClosing = true

			client.hudeditorHelp:Remove()
		end

		hook.Remove("Think", "TTT2EditHUD")

		local hud = huds.GetStored(HUDManager.GetHUD())

		if hud then
			for _, elem in ipairs(hud.GetHUDElements()) do
				local el = hudelements.GetStored(elem)
				if el then
					SQL.Save("ttt2_hudelements", elem, el, el.savingKeys)

					el:Save()
				end
			end
		end
	end

	HUDManager.IsEditing = bool
end

function HUDManager.ShowHUDSwitcher(bool)
	local client = LocalPlayer()

	if IsValid(client.hudswitcher) then
		client.hudswitcher.forceClosing = true

		client.hudswitcher:Remove()
	end

	if bool then
		client.hudswitcher = vgui.Create("HUDSwitcher")
		client.hudswitcher:MakePopup()
	end
end

function HUDManager.GetHUD()
	if not currentHUD then
		currentHUD = current_hud:GetString()
	end

	if not huds.GetStored(currentHUD) then
		currentHUD = "old_ttt"
	end

	return currentHUD
end

function HUDManager.SetHUD(name)
	local curHUD = HUDManager.GetHUD()

	net.Start("TTT2RequestHUD")
	net.WriteString(name or curHUD)
	net.WriteString(curHUD)
	net.SendToServer()
end

function HUDManager.DrawHUD()
	local hud = huds.GetStored(HUDManager.GetHUD())

	if not hud then return end

	local client = LocalPlayer()

	for _, elemName in ipairs(hud:GetHUDElements()) do
		local elem = hudelements.GetStored(elemName)
		if not elem then
			Msg("Error: Hudelement with name " .. elemName .. " not found!")

			return
		end

		if elem.initialized and elem.type and hud:ShouldShow(elem.type) and hook.Call("HUDShouldDraw", GAMEMODE, elem.type) then
			elem:Draw()

			if elem == client.activeElement then
				elem:DrawSize()
			end
		end
	end
end

-- Paints player status HUD element in the bottom left
function GM:HUDPaint()
	local client = LocalPlayer()

	-- Perform Layout
	local scrW = ScrW()
	local scrH = ScrH()
	local changed = false

	if client.oldScrW and client.oldScrW ~= scrW and client.oldScrH and client.oldScrH ~= scrH then
		local hud = huds.GetStored(HUDManager.GetHUD())
		if hud then
			hud:PerformLayout()
		end

		changed = true
	end

	if changed or not client.oldScrW or not client.oldScrH then
		client.oldScrW = scrW
		client.oldScrH = scrH
	end

	if hook.Call("HUDShouldDraw", GAMEMODE, "TTTTargetID") then
		hook.Call("HUDDrawTargetID", GAMEMODE)
	end

	HUDManager.DrawHUD()

	if not client:Alive() or client:Team() == TEAM_SPEC then return end

	if hook.Call("HUDShouldDraw", GAMEMODE, "TTTRadar") then
		RADAR:Draw(client)
	end

	if hook.Call("HUDShouldDraw", GAMEMODE, "TTTTButton") then
		TBHUD:Draw(client)
	end

	if hook.Call("HUDShouldDraw", GAMEMODE, "TTTVoice") then
		VOICE.Draw(client)
	end

	if hook.Call("HUDShouldDraw", GAMEMODE, "TTTPickupHistory") then
		hook.Call("HUDDrawPickupHistory", GAMEMODE)
	end
end

-- Hide the standard HUD stuff
local hud = {
	["CHudHealth"] = true,
	["CHudBattery"] = true,
	["CHudAmmo"] = true,
	["CHudSecondaryAmmo"] = true
}

function GM:HUDShouldDraw(name)
	if hud[name] then
		return false
	end

	return self.BaseClass.HUDShouldDraw(self, name)
end

-- if forced or requested, modified by server restrictions
net.Receive("TTT2ReceiveHUD", function()
	local name = net.ReadString()
	local hudEl = huds.GetStored(name)

	if not hudEl then
		Msg("Error: HUD with name " .. name .. " was not found!\n")

		return
	end

	RunConsoleCommand(current_hud:GetName(), name)

	currentHUD = name

	-- Initialize elements
	hudEl:Initialize()
end)
