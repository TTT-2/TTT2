ttt_include("vgui__cl_hudswitcher")

local current_hud = CreateClientConVar("ttt2_current_hud", HUDManager.defaultHUD or "pure_skin", true, true)

local currentHUD

HUDManager.IsEditing = false

local function CreateEditOptions(x, y)
	local client = LocalPlayer()

	client.editOptionsX = x
	client.editOptionsY = y

	local menu = DermaMenu()

	local editReset = menu:AddOption("Reset")
	editReset.OnMousePressed = function(slf, keyCode)
		local hud = huds.GetStored(HUDManager.GetHUD())
		if hud then
			for _, elem in ipairs(hud:GetHUDElements()) do
				local el = hudelements.GetStored(elem)
				if el then
					el:Reset()
				end
			end

			hud:Reset()
		end

		menu:Remove()
	end

	local editClose = menu:AddOption("Close")
	editClose.OnMousePressed = function(slf, keyCode)
		HUDManager.EditHUD(false)

		menu:Remove()
	end

	-- Open the menu
	menu:Open()

	client.editOptions = menu
end

local function EditLocalHUD()
	local client = LocalPlayer()
	local x, y = math.Round(gui.MouseX()), math.Round(gui.MouseY())
	local elem = client.activeElement
	local mode = client.hudEditMode or 0

	local mouse_down = input.IsMouseDown(MOUSE_LEFT)

	-- mouse rising/falling edge detection
	if (not client.mouse_clicked_prev and mouse_down) then
		client.mouse_clicked = true
		client.mouse_clicked_prev = true
	elseif (client.mouse_clicked_prev and not mouse_down) then
		client.mouse_clicked_prev = false
	end

	if mouse_down then
		if not elem then
			local hud = huds.GetStored(HUDManager.GetHUD())
			if hud then
				for _, el in ipairs(hud:GetHUDElements()) do
					local elObj = hudelements.GetStored(el)
					if elObj and elObj:IsInPos(x, y) then
						elem = elObj

						local difPos = elem:GetPos()
						local difBasePos = elem:GetBasePos()
						local difSize = elem:GetSize()

						client.difX = x - difPos.x
						client.difY = y - difPos.y
						client.difW = x - difSize.w
						client.difH = y - difSize.h
						client.difBaseX = difBasePos.x - difPos.x
						client.difBaseY = difBasePos.y - difPos.y

						break
					end
				end
			end
		end

		local difX = client.difX or 0
		local difY = client.difY or 0
		local difW = client.difW or 0
		local difH = client.difH or 0

		if elem and (client.oldMX and client.oldMX ~= x or client.oldMY and client.oldMY ~= y) then
			-- set to true to get new click zone
			elem:SetMouseClicked(client.mouse_clicked, x, y)
			client.mouse_clicked = false

			local size = elem:GetSize()

			local shift_pressed = input.IsKeyDown(KEY_LSHIFT) or input.IsKeyDown(KEY_RSHIFT)
			local alt_pressed = input.IsKeyDown(KEY_LALT) or input.IsKeyDown(KEY_LALT)
			trans_data = elem:GetClickedArea(x, y, alt_pressed)

			if trans_data then
				if trans_data.move then -- move mode
					local nx = x - difX
					local ny = y - difY

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

					elem:SetBasePos(nx + client.difBaseX, ny + client.difBaseY)
				else -- resize mode
					local size = elem:GetSize() -- curent size
					local pos = elem:GetPos() -- current pos

					local multi_w = (trans_data.x_p and 1 or 0) + (trans_data.x_m and 1 or 0)
					local multi_h = (trans_data.y_p and 1 or 0) + (trans_data.y_m and 1 or 0)
					local new_w = size.w + (x - client.oldMX) * trans_data.direction_x * multi_w
					local new_h = size.h + (y - client.oldMY) * trans_data.direction_y * multi_h

					elem:SetSize(new_w, new_h)
					elem:SetBasePos(trans_data.x_m and pos.x + trans_data.direction_x * (client.oldMX - x) or pos.x, trans_data.y_m and pos.y + trans_data.direction_y * (client.oldMY - y) or pos.y)
				end

				elem:PerformLayout()
			end

		end
	else
		elem = nil
		client.difX = nil
		client.difY = nil
	end

	if input.IsMouseDown(MOUSE_RIGHT) and (client.editOptionsX ~= x or client.editOptionsY ~= y) then
		if IsValid(client.editOptions) then
			client.editOptions:Remove()
		end

		CreateEditOptions(x, y)
	elseif input.IsMouseDown(MOUSE_LEFT) then
		if IsValid(client.editOptions) then
			client.editOptions:Remove()
		end
	end

	client.oldMX = x
	client.oldMY = y
	client.activeElement = elem
end

function HUDManager.EditHUD(bool, hud)
	HUDManager.IsEditing = bool

	local client = LocalPlayer()

	hud = hud or huds.GetStored(HUDManager.GetHUD())

	gui.EnableScreenClicker(bool)

	if bool then
		if IsValid(client.hudswitcher) then
			client.hudswitcherShown = true
		end

		HUDManager.ShowHUDSwitcher(false)

		chat.AddText("[TTT2][INFO] Hover over the elements and kick and move the mouse to ", Color(20, 150, 245), "move", Color(151, 211, 255), " or ", Color(245, 30, 80), "resize", Color(151, 211, 255), " it.")
		chat.AddText("[TTT2][INFO] Press [RMB] (right mouse-button) -> 'close' to exit the HUD editor!")

		hook.Add("Think", "TTT2EditHUD", EditLocalHUD)
	else
		if client.hudswitcherShown then
			client.hudswitcherShown = nil

			HUDManager.ShowHUDSwitcher(true)
		end

		hook.Remove("Think", "TTT2EditHUD")

		if hud then
			for _, elem in ipairs(hud:GetHUDElements()) do
				local el = hudelements.GetStored(elem)
				if el then
					el:SaveData()
				end
			end
		end

		SQL.Save("ttt2_huds", hud.id, hud, hud:GetSavingKeys())
	end
end

function HUDManager.ShowHUDSwitcher(bool)
	local client = LocalPlayer()

	if IsValid(client.hudswitcher) then
		client.hudswitcher.forceClosing = true

		client.hudswitcher:Remove()
	end

	if not bool and not client.settingsFrameForceClose and not HUDManager.IsEditing then
		HELPSCRN:Show()
	end

	if bool then
		client.hudswitcher = vgui.Create("HUDSwitcher")

		if client.hudswitcherSettingsF1 then
			client.settingsFrame = client.hudswitcher
		end

		client.hudswitcher:MakePopup()
	end

	return client.hudswitcher
end

function HUDManager.GetHUD()
	if not currentHUD then
		currentHUD = current_hud:GetString()
	end

	if not huds.GetStored(currentHUD) then
		currentHUD = "pure_skin"
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

function HUDManager.AddHUDSettings(panel, hudEl)
	if not IsValid(panel) or not hudEl then return end

	local tmp = table.Copy(hudEl:GetSavingKeys()) or {}
	tmp.el_pos = {typ = "el_pos", desc = "Change element's\nposition and size"}
	tmp.reset = {typ = "reset", desc = "Reset HUD's data"}

	for key, data in pairs(tmp) do
		local el
		local container

		if data.typ == "el_pos" then -- HUD edit button
			el = vgui.Create("DButton")
			el:SetText("Position Editor")
			el:SizeToContents()

			el.DoClick = function(btn)
				HUDManager.EditHUD(true, hudEl)
			end
		elseif data.typ == "reset" then
			el = vgui.Create("DButton")
			el:SetTextColor(Color(255, 0, 0))
			el:SetText("- Reset -")
			el:SizeToContents()

			el.DoClick = function(btn)
				if hudEl then
					for _, elem in ipairs(hudEl:GetHUDElements()) do
						local tel = hudelements.GetStored(elem)
						if tel then
							tel:Reset()

							SQL.Save("ttt2_hudelements", elem, tel, tel:GetSavingKeys())

							tel:SaveData()
						end
					end

					hudEl:Reset()

					SQL.Save("ttt2_huds", hudEl.id, hudEl, hudEl:GetSavingKeys())
				end

				HUDManager.ShowHUDSwitcher(true)
			end
		elseif data.typ == "color" then
			el = vgui.Create("DColorMixer")
			el:SetSize(267, 186)

			if hudEl[key] then
				el:SetColor(hudEl[key])
			end

			function el:ValueChanged(col)
				hudEl[key] = col

				if isfunction(data.OnChange) then
					data.OnChange(hudEl, col)
				end
			end
		end

		if el then
			local add = false

			if not container then
				container = vgui.Create("DPanel")
				add = true
			end

			local label = vgui.Create("DLabel", container)
			label:SetText((data.desc or key) .. ":")
			label:SetTextColor(COLOR_BLACK)
			label:SetContentAlignment(5) -- center
			label:SizeToContents()
			label:DockMargin(20, 0, 0, 0)
			label:DockPadding(10, 0, 10, 0)
			label:Dock(LEFT)

			if add then
				el:SetParent(container)
			end

			el:DockPadding(10, 0, 10, 0)
			el:DockMargin(20, 0, 0, 0)
			el:Dock(LEFT)

			local w, h = el:GetSize()
			local lw, lh = label:GetSize()

			w = w + 10
			h = h + 10
			lw = lw + 10
			lh = lh + 10

			if w < lw then
				w = lw
			end

			h = h + lh

			container:SetSize(w, h)
			container:SetParent(panel)
			container:DockPadding(0, 10, 0, 10)
			container:Dock(TOP)
		end
	end
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

			if HUDManager.IsEditing then
				elem:DrawSize()
			end
			if HUDManager.IsEditing and not client.activeElement then
				elem:DrawHowered(math.Round(gui.MouseX()), math.Round(gui.MouseY()))
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
			hud:ResolutionChanged()
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

	local skeys = hudEl:GetSavingKeys()

	-- load and initialize all HUD data from database
	if SQL.CreateSqlTable("ttt2_huds", skeys) then
		local loaded = SQL.Load("ttt2_huds", hudEl.id, hudEl, skeys)

		if not loaded then
			SQL.Init("ttt2_huds", hudEl.id, hudEl, skeys)
		end
	end

	hudEl:Loaded()
end)
