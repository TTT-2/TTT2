---
-- @module HUDEditor

local mathRound = math.Round
local mathClamp = math.Clamp

if not HUDEditor then
    HUDEditor = {}
    HUDEditor.IsEditing = false
end

local function CreateEditOptions(x, y)
    local client = LocalPlayer()

    client.editOptionsX = x
    client.editOptionsY = y

    local menu = DermaMenu()

    local editReset = menu:AddOption(LANG.GetTranslation("button_reset"))
    editReset.OnMousePressed = function(slf, keyCode)
        local hud = huds.GetStored(HUDManager.GetHUD())

        if hud then
            hud:Reset()
        end

        menu:Remove()
    end

    local editClose = menu:AddOption(LANG.GetTranslation("button_close"))
    editClose.OnMousePressed = function(slf, keyCode)
        menu:Remove()

        HELPSCRN:Unhide()
    end

    -- Open the menu
    menu:Open()

    client.editOptions = menu
end

local function GetClickedElement(x, y)
    local hud = huds.GetStored(HUDManager.GetHUD())
    if not hud then
        return
    end

    local elems = hud:GetElements()

    for i = 1, #elems do
        local elObj = hudelements.GetStored(elems[i])
        if elObj and elObj:IsInPos(x, y) then
            return elObj
        end
    end
end

local function TryResizeLocalHUD(elem, trans_data, dif_x, dif_y, shift_pressed)
    local client = LocalPlayer()

    -- calc base data while checking for the shift key
    local additional_w, additional_h

    if shift_pressed and trans_data.edge or elem:AspectRatioIsLocked() then
        if
            dif_x * trans_data.direction_x * client.size.h
            > dif_y * trans_data.direction_y * client.size.w
        then
            dif_x = mathRound(dif_y * trans_data.direction_y * client.aspect)
                * trans_data.direction_x
        else
            dif_y = mathRound(dif_x * trans_data.direction_x / client.aspect)
                * trans_data.direction_y
        end
    end

    additional_w = dif_x * trans_data.direction_x
    additional_h = dif_y * trans_data.direction_y

    -- calc and clamp new data
    local new_w_p, new_w_m, new_h_p, new_h_m = 0, 0, 0, 0

    if trans_data.x_p then
        new_w_p =
            mathClamp(additional_w, -1 * client.size.w, ScrW() - (client.size.w + client.base.x))
    end

    if trans_data.x_m then
        new_w_m = mathClamp(additional_w, -1 * client.size.w, client.base.x)
    end

    if trans_data.y_p then
        new_h_p =
            mathClamp(additional_h, -1 * client.size.h, ScrH() - (client.size.h + client.base.y))
    end

    if trans_data.y_m then
        new_h_m = mathClamp(additional_h, -1 * client.size.h, client.base.y)
    end

    -- get min data for this element
    local min = elem:GetMinSize()

    -- combine new size data
    local new_w, new_h, new_x, new_y
    if client.size.w + new_w_p < min.w and new_w_m == 0 then -- limit scale of only the right side of the element
        new_w = min.w
        new_x = client.base.x
    elseif client.size.w + new_w_m < min.w and new_w_p == 0 then -- limit scale of only the left side of the element
        new_w = min.w
        new_x = client.base.x + client.size.w - min.w
    elseif client.size.w + new_w_p + new_w_m < min.w then -- limit scale of both sides of the element
        new_w = min.w
        new_x = client.base.x + mathRound((client.size.w - min.w) * 0.5)
    else
        new_w = client.size.w + new_w_p + new_w_m
        new_x = client.base.x - new_w_m
    end

    if client.size.h + new_h_p < min.h and new_h_m == 0 then -- limit scale of only the bottom side of the element
        new_h = min.h
        new_y = client.base.y
    elseif client.size.h + new_h_m < min.h and new_h_p == 0 then -- limit scale of only the top side of the element
        new_h = min.h
        new_y = client.base.y + client.size.h - min.h
    elseif client.size.h + new_h_p + new_h_m < min.h then -- limit scale of both sides of the element
        new_h = min.h
        new_y = client.base.y + mathRound((client.size.h - min.h) * 0.5)
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

local function TryMoveLocalHUD(elem, dif_x, dif_y, shift_pressed)
    if not elem:ShouldDraw() then
        return
    end -- restrict movement when element is hidden

    local client = LocalPlayer()

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
    new_x = mathClamp(new_x, 0, ScrW() - client.size.w - (client.pos.x - client.base.x))
    new_y = mathClamp(new_y, 0, ScrH() - client.size.h - (client.pos.y - client.base.y))

    elem:SetBasePos(new_x, new_y)
end

local function Think_EditLocalHUD()
    local client = LocalPlayer()
    local x, y = mathRound(gui.MouseX()), mathRound(gui.MouseY())

    local mouse_down = input.IsMouseDown(MOUSE_LEFT)

    -- open context menu when rightclicked
    if
        input.IsMouseDown(MOUSE_RIGHT) and (client.editOptionsX ~= x or client.editOptionsY ~= y)
    then
        if IsValid(client.editOptions) then
            client.editOptions:Remove()
        end

        CreateEditOptions(x, y)

    -- remove contextmenu when leftclicked
    elseif input.IsMouseDown(MOUSE_LEFT) then
        if IsValid(client.editOptions) then
            client.editOptions:Remove()
        end
    end

    -- mouse rising/falling edge detection
    if not client.mouse_clicked_prev and mouse_down then
        client.mouse_clicked = true
        client.mouse_clicked_prev = true
    elseif client.mouse_clicked_prev and not mouse_down then
        client.mouse_clicked_prev = false
    end

    -- cache old data for the next frame to calculate the difference
    client.oldMX = x
    client.oldMY = y

    -- cache active element only when the mouse is pressed
    client.activeElement = mouse_down and client.activeElement or nil

    -- handle moving when left mouse buttin is pressed
    if mouse_down then
        local shift_pressed = input.IsKeyDown(KEY_LSHIFT) or input.IsKeyDown(KEY_RSHIFT)
        local alt_pressed = input.IsKeyDown(KEY_LALT) or input.IsKeyDown(KEY_LALT)

        -- set to true to get new click zone, because this sould only happen ONCE; this zone is now the active zone until the button is released
        if client.mouse_clicked then
            client.activeElement = GetClickedElement(x, y)

            -- completely stop with the hdu editing, when no element is clicked
            if not client.activeElement then
                return
            end

            client.activeElement:SetMouseClicked(client.mouse_clicked, x, y)

            -- save initial mouse position
            client.mouse_start_X = x
            client.mouse_start_Y = y

            -- save initial element data
            client.size = client.activeElement:GetSize() -- initial size
            client.pos = client.activeElement:GetPos() -- initial pos
            client.base = client.activeElement:GetBasePos() -- initial base pos

            -- store aspect ratio for shift-rescaling
            client.aspect = math.abs(client.size.w / client.size.h)

            -- reset clicked because this block sould be only executed once
            client.mouse_clicked = false
        end

        -- get data about the element, it returns the transformation direction
        trans_data = client.activeElement:GetClickedArea(x, y, alt_pressed)

        if trans_data then
            -- track mouse movement
            local dif_x = x - client.mouse_start_X
            local dif_y = y - client.mouse_start_Y

            if trans_data.move then -- move mode
                TryMoveLocalHUD(client.activeElement, dif_x, dif_y, shift_pressed)
            else -- resize mode
                TryResizeLocalHUD(client.activeElement, trans_data, dif_x, dif_y, shift_pressed)
            end

            client.activeElement:PerformLayout()
        end
    end
end

---
-- Enables the HUD editing state
-- @realm client
function HUDEditor.EditHUD()
    if HUDEditor.IsEditing == true then
        return
    end

    local curHUD = HUDManager.GetHUD()
    local curHUDTbl = huds.GetStored(curHUD)

    -- don't let the user edit a hud that explicitly disallows editing
    if not curHUDTbl or curHUDTbl.disableHUDEditor then
        return
    end

    HUDEditor.IsEditing = true

    gui.EnableScreenClicker(true)

    local colorText = Color(150, 210, 255)
    local TryT = LANG.TryTranslation

    chat.AddText(colorText, TryT("hudeditor_chat_hint1"))
    chat.AddText(colorText, TryT("hudeditor_chat_hint2"))
    chat.AddText(colorText, TryT("hudeditor_chat_hint3"))
    chat.AddText(colorText, TryT("hudeditor_chat_hint4"))

    hook.Add("Think", "TTT2EditHUD", Think_EditLocalHUD)
end

---
-- Disables the HUD editing state
-- @realm client
function HUDEditor.StopEditHUD()
    if HUDEditor.IsEditing == false then
        return
    end

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
-- @param HUDELEMENT elem
-- @realm client
-- @internal
function HUDEditor.DrawElem(elem)
    if not HUDEditor.IsEditing then
        return
    end

    local client = LocalPlayer()

    elem:DrawSize()

    if not client.activeElement then
        elem:DrawHovered(mathRound(gui.MouseX()), mathRound(gui.MouseY()))
    end
end
