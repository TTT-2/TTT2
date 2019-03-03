ttt_include("vgui__cl_hudswitcher")

local current_hud = CreateClientConVar("ttt2_current_hud", HUDManager.defaultHUD or "pure_skin", true, true)
local hud_scale = CreateClientConVar("ttt2_hud_scale", 1.0, true, false)

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
				for _, el in ipairs(hud:GetElements()) do
					local elObj = hudelements.GetStored(el)
					if elObj and elObj:IsInPos(x, y) then
						elem = elObj
						break
					end
				end
			end
		end

		local shift_pressed = input.IsKeyDown(KEY_LSHIFT) or input.IsKeyDown(KEY_RSHIFT)
		local alt_pressed = input.IsKeyDown(KEY_LALT) or input.IsKeyDown(KEY_LALT)

		if elem then
			-- set to true to get new click zone, because this sould only happen ONCE; this zone is now the active zone until the button is released
			if client.mouse_clicked then
				elem:SetMouseClicked(client.mouse_clicked, x, y)

				-- save initial mouse position
				client.mouse_start_X = x
				client.mouse_start_Y = y

				-- save initial element data
				client.size = elem:GetSize() -- initial size
				client.pos = elem:GetPos() -- initial pos
				client.base = elem:GetBasePos() -- initial base pos

				-- store aspect ratio for shift-rescaling
				client.aspect = math.abs(client.size.w / client.size.h)

				-- reset clicked because it sould be only executed once
				client.mouse_clicked = false
			end

			-- get data about the element, it returns the transformation direction
			trans_data = elem:GetClickedArea(x, y, alt_pressed)

			if trans_data then
				-- track mouse movement
				local dif_x = x - client.mouse_start_X
				local dif_y = y - client.mouse_start_Y

				if trans_data.move then -- move mode
					-- move on axis when shift is pressed
					local new_x, new_y
					if shift_pressed then
						if math.abs(dif_x) > math.abs(dif_y) then
							new_x = dif_x + client.base.x
							new_y = client.base.y
						else
							new_x = client.base.x
							new_y = dif_y + client.base.y
						end
					else -- default movement
						new_x = dif_x + client.base.x
						new_y = dif_y + client.base.y
					end

					-- clamp values between min and max
					new_x = math.Clamp(new_x, 0, ScrW() - client.size.w - (client.pos.x - client.base.x))
					new_y = math.Clamp(new_y, 0, ScrH() - client.size.h - (client.pos.y - client.base.y))

					elem:SetBasePos(new_x, new_y)
				else -- resize mode
					-- calc base data wihile checking for the shift key
					local additional_w, additional_h
					if shift_pressed and trans_data.edge then
						if dif_x * trans_data.direction_x * client.size.h > dif_y * trans_data.direction_y * client.size.w then
							dif_x = math.Round(dif_y * trans_data.direction_y * client.aspect) * trans_data.direction_x
						else
							dif_y = math.Round(dif_x * trans_data.direction_x / client.aspect) * trans_data.direction_y
						end
					end
					additional_w = dif_x * trans_data.direction_x
					additional_h = dif_y * trans_data.direction_y

					-- calc and clamp new data
					local new_w_p, new_w_m, new_h_p, new_h_m = 0,0,0,0
					if trans_data.x_p then
						new_w_p = math.Clamp(additional_w, (-1) * client.size.w, ScrW() - (client.size.w + client.base.x))
					end
					if trans_data.x_m then
						new_w_m = math.Clamp(additional_w, (-1) * client.size.w, client.base.x)
					end
					if trans_data.y_p then
						new_h_p = math.Clamp(additional_h, (-1) * client.size.h, ScrH() - (client.size.h + client.base.y))
					end
					if trans_data.y_m then
						new_h_m = math.Clamp(additional_h, (-1) * client.size.h, client.base.y)
					end

					-- get min data for this element
					local min = elem:GetMinSize()

					-- combine new size data
					local new_w, new_h, new_x, new_y
					if (client.size.w + new_w_p < min.w and new_w_m == 0) then -- limit scale of only the right side of the element
						new_w = min.w
						new_x = client.base.x
					elseif (client.size.w + new_w_m < min.w and new_w_p == 0) then -- limit scale of only the left side of the element
						new_w = min.w
						new_x = client.base.x + client.size.w - min.w
					elseif (client.size.w + new_w_p + new_w_m < min.w) then -- limit scale of both sides of the element
						new_w = min.w
						new_x = client.base.x + math.Round((client.size.w - min.w) / 2)
					else
						new_w = client.size.w + new_w_p + new_w_m
						new_x = client.base.x - new_w_m
					end

					if (client.size.h + new_h_p < min.h and new_h_m == 0) then -- limit scale of only the bottom side of the element
						new_h = min.h
						new_y = client.base.y
					elseif (client.size.h + new_h_m < min.h and new_h_p == 0) then -- limit scale of only the top side of the element
						new_h = min.h
						new_y = client.base.y + client.size.h - min.h
					elseif (client.size.h + new_h_p + new_h_m < min.h) then -- limit scale of both sides of the element
						new_h = min.h
						new_y = client.base.y + math.Round((client.size.h - min.h) / 2)
					else
						new_h = client.size.h + new_h_p + new_h_m
						new_y = client.base.y - new_h_m
					end

					elem:SetSize(new_w, new_h)
					elem:SetBasePos(new_x, new_y)
				end

				elem:PerformLayout()
			end
		end
	else
		-- element lost
		elem = nil
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
		chat.AddText("[TTT2][INFO] Press and hold the ", Color(255, 255, 255), "alt-key", Color(151, 211, 255), " for symmetric resizing.")
		chat.AddText("[TTT2][INFO] Press and hold the ", Color(255, 255, 255), "shift-key", Color(151, 211, 255), " to move on axis and to keep the aspect ratio.")
		chat.AddText("[TTT2][INFO] Press [RMB] (right mouse-button) -> 'close' to exit the HUD editor!")

		hook.Add("Think", "TTT2EditHUD", EditLocalHUD)
	else
		if client.hudswitcherShown then
			client.hudswitcherShown = nil

			HUDManager.ShowHUDSwitcher(true)
		end

		hook.Remove("Think", "TTT2EditHUD")

		if hud then
			hud:SaveData()
		end
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
					hudEl:Reset()
					hudEl:SaveData()
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
		elseif data.typ == "scale" then
			el = vgui.Create("DNumSlider")
			el:SetSize(600, 100)
			el:SetMin( 0.1 )
			el:SetMax( 4.0 )
			if hudEl[key] then
				el:SetDefaultValue( hudEl[key] )
				el:SetValue( hudEl[key] )
				hud_scale:SetFloat( hudEl[key] )
			end
			el:SetDecimals( 1 )
			el:SetConVar( "ttt2_hud_scale" )

			function el:ValueChanged(val)
				val = math.Round(val, 1)
				if val ~= math.Round(hudEl[key], 1) then
					if isfunction(data.OnChange) then
						data.OnChange(hudEl, val)
					end

					hudEl[key] = val
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

	for _, elemName in ipairs(hud:GetElements()) do
		local elem = hudelements.GetStored(elemName)
		if not elem then
			MsgN("Error: Hudelement with name " .. elemName .. " not found!")

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

local function UpdateHUD(name)
	local hudEl = huds.GetStored(name)

	if not hudEl then
		MsgN("Error: HUD with name " .. name .. " was not found!")
		return
	end

	RunConsoleCommand(current_hud:GetName(), name)

	currentHUD = name

	-- Initialize elements
	hudEl:Initialize()

	hudEl:LoadData()

	hudEl:Loaded()
end

function HUDManager.GetHUD()
	if not currentHUD then
		return current_hud:GetString()
	end

	if not huds.GetStored(currentHUD) then
		return "pure_skin"
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

-- if forced or requested, modified by server restrictions
net.Receive("TTT2ReceiveHUD", function()
	UpdateHUD(net.ReadString())
end)
