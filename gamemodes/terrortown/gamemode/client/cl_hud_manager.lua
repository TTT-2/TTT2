ttt_include("vgui__cl_hudswitcher")

local current_hud = CreateClientConVar("ttt2_current_hud", HUDManager.defaultHUD, true, true)

local currentHUD

HUDManager.IsEditing = false

local function CreateEditOptions(x, y)
	local client = LocalPlayer()

	client.editOptionsX = x
	client.editOptionsY = y

	local menu = DermaMenu()

	local editPos = menu:AddOption("Position")
	editPos.OnMousePressed = function(slf, keyCode)
		LocalPlayer().hudEditMode = 0

		menu:Remove()
	end

	local editSize = menu:AddOption("Size")
	editSize.OnMousePressed = function(slf, keyCode)
		LocalPlayer().hudEditMode = 1

		menu:Remove()
	end

	menu:AddSpacer()

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

	if input.IsMouseDown(MOUSE_LEFT) then
		if not elem then
			local hud = huds.GetStored(HUDManager.GetHUD())
			if hud then
				for _, el in ipairs(hud:GetHUDElements()) do
					local elObj = hudelements.GetStored(el)
					if elObj and elObj:IsInPos(x, y) then
						elem = elObj

						local difPos = elem:GetPos()
						local difSize = elem:GetSize()

						client.difX = x - difPos.x
						client.difY = y - difPos.y
						client.difW = x - difSize.w
						client.difH = y - difSize.h

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
			local size = elem:GetSize()

			if mode == 0 then
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

				elem:SetPos(nx, ny)
			elseif mode == 1 then
				local nw = x - difW
				local nh = y - difH

				if nw < 1 then
					nw = 1
				end

				if nh < 1 then
					nh = 1
				end

				elem:SetSize(nw, nh)
			end

			elem:PerformLayout()
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

function HUDManager.EditHUD(bool)
	local client = LocalPlayer()

	gui.EnableScreenClicker(bool)

	if bool then
		if IsValid(client.hudswitcher) then
			client.hudswitcher:Hide()
		end

		hook.Add("Think", "TTT2EditHUD", EditLocalHUD)
	else
		if IsValid(client.hudswitcher) then
			client.hudswitcher:Show()
		end

		hook.Remove("Think", "TTT2EditHUD")

		local hud = huds.GetStored(HUDManager.GetHUD())
		if hud then
			for _, elem in ipairs(hud:GetHUDElements()) do
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

function HUDManager.AddHUDSettings(panel, hudEl)
	if not IsValid(panel) or not hudEl then return end

	local tmp = table.Copy(hudEl.savingKeys) or {}
	tmp.el_pos = {typ = "el_pos", desc = "Change element's\nposition and size"}

	for key, data in pairs(tmp) do
		local el
		local container

		if data.typ == "el_pos" then -- HUD edit button
			el = vgui.Create("DButton")
			el:SetText("Position Editor")
			el:SizeToContents()

			el.DoClick = function(btn)
				HUDManager.EditHUD(true)
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

			if HUDManager.IsEditing and not client.activeElement then
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

	-- load and initialize all HUD data from database
	if SQL.CreateSqlTable("ttt2_huds", hudEl.savingKeys) then
		local loaded = SQL.Load("ttt2_huds", hudEl.id, hudEl, hudEl.savingKeys)

		if not loaded then
			SQL.Init("ttt2_huds", hudEl.id, hudEl, hudEl.savingKeys)
		end
	end

	hudEl:Loaded()
end)
