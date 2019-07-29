---
-- @module HUDEditor
if not HUDEditor then
	HUDEditor = {}
	HUDEditor.IsEditing = false
end

local function CreateEditOptions(x, y)
	local client = LocalPlayer()

	client.editOptionsX = x
	client.editOptionsY = y

	local menu = DermaMenu()

	local editReset = menu:AddOption(LANG.GetTranslation("f1_settings_hudswitcher_button_reset"))
	editReset.OnMousePressed = function(slf, keyCode)
		local hud = huds.GetStored(HUDManager.GetHUD())
		if hud then
			hud:Reset()
		end

		menu:Remove()
	end

	local editClose = menu:AddOption(LANG.GetTranslation("f1_settings_hudswitcher_button_close"))
	editClose.OnMousePressed = function(slf, keyCode)
		HUDEditor.StopEditHUD()
		HUDManager.ShowHUDSwitcher()
		menu:Remove()
	end

	-- Open the menu
	menu:Open()

	client.editOptions = menu
end

local function Think_EditLocalHUD()
	local client = LocalPlayer()
	local x, y = math.Round(gui.MouseX()), math.Round(gui.MouseY())
	local elem = client.activeElement

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
					if elem:ShouldDraw() then -- restrict movement when element is hidden
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
					end
				else -- resize mode
					-- calc base data while checking for the shift key
					local additional_w, additional_h
					if (shift_pressed and trans_data.edge) or elem:AspectRatioIsLocked() then
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

					-- make sure the element does not leave the screen when the aspect ratio is fixed
					if elem:AspectRatioIsLocked() then
						new_w = (new_w < new_h) and new_w or new_h
						new_h = new_w
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

---
-- Enables the HUD editing state
-- @realm client
function HUDEditor.EditHUD()
	if HUDEditor.IsEditing == true then return end

	local curHUD = HUDManager.GetHUD()
	local curHUDTbl = huds.GetStored(curHUD)

	-- don't let the user edit a hud that explicitly disallows editing
	if not curHUDTbl or curHUDTbl.disableHUDEditor then return end

	HUDEditor.IsEditing = true

	gui.EnableScreenClicker(true)

	chat.AddText("[TTT2][INFO] Hover over the elements and press [LMB] and move the mouse to ", Color(20, 150, 245), "move", Color(151, 211, 255), " or ", Color(245, 30, 80), "resize", Color(151, 211, 255), " it.")
	chat.AddText("[TTT2][INFO] Press and hold the ", Color(255, 255, 255), "alt-key", Color(151, 211, 255), " for symmetric resizing.")
	chat.AddText("[TTT2][INFO] Press and hold the ", Color(255, 255, 255), "shift-key", Color(151, 211, 255), " to move on axis and to keep the aspect ratio.")
	chat.AddText("[TTT2][INFO] Press [RMB] -> 'close' to exit the HUD editor!")

	hook.Add("Think", "TTT2EditHUD", Think_EditLocalHUD)
end

---
-- Disables the HUD editing state
-- @realm client
function HUDEditor.StopEditHUD()
	if HUDEditor.IsEditing == false then return end

	HUDEditor.IsEditing = false

	hud = huds.GetStored(HUDManager.GetHUD())

	gui.EnableScreenClicker(false)

	hook.Remove("Think", "TTT2EditHUD")

	if hud then
		hud:SaveData()
	end
end

---
-- Draws an element with red borders
-- @realm client
-- @internal
function HUDEditor.DrawElem(elem)
	if not HUDEditor.IsEditing then return end

	local client = LocalPlayer()

	elem:DrawSize()

	if not client.activeElement then
		elem:DrawHovered(math.Round(gui.MouseX()), math.Round(gui.MouseY()))
	end
end
