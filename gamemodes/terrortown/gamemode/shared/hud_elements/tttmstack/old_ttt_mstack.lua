--- @ignore

local base = "old_ttt_element"

DEFINE_BASECLASS(base)

HUDELEMENT.Base = base

if CLIENT then
    local surface = surface
    local draw = draw
    local math = math

    -- Constants for configuration
    local msg_sound = Sound("Hud.Hint")
    local base_text_display_options = {
        font = "DefaultBold",
        xalign = TEXT_ALIGN_CENTER,
        yalign = TEXT_ALIGN_TOP,
    }

    local top_y = 0
    local top_x = 0

    local staytime = 12
    local max_items = 8

    local fadein = 0.1
    local fadeout = 0.6
    local movespeed = 2

    local margin = 6
    local line_margin = 6
    local top_margin = 8
    local title_bottom_margin = 8
    local msg_width = 400
    local text_width = msg_width - line_margin * 3
    local pad = 7
    local leftImagePad = 10
    local msgfont = "DefaultBold"
    local imagedmsgfont = "DefaultBold"
    local text_color = COLOR_WHITE
    local bg_color = Color(0, 0, 0, 200)
    local imageSize = 64
    local imageMinHeight = imageSize + 2 * pad

    local const_defaults = {
        basepos = { x = 0, y = 0 },
        size = { w = msg_width, h = 80 },
        minsize = { w = msg_width, h = 80 },
    }

    function HUDELEMENT:Initialize()
        base_text_display_options = {
            font = msgfont,
            xalign = TEXT_ALIGN_CENTER,
            yalign = TEXT_ALIGN_TOP,
        }

        BaseClass.Initialize(self)
    end

    function HUDELEMENT:GetDefaults()
        top_y = margin
        top_x = ScrW() - margin - msg_width

        const_defaults["basepos"] = { x = top_x, y = top_y }

        return const_defaults
    end

    function HUDELEMENT:PerformLayout()
        top_x = self.pos.x
        top_y = self.pos.y

        msg_width = self.size.w
        text_width = msg_width - pad * 2

        -- invalidate previous item size calculations
        for _, v in pairs(MSTACK.msgs) do
            v.ready = false
        end

        BaseClass.PerformLayout(self)
    end

    local function PrepareItem(item, bg_col)
        local max_text_width = text_width
        local item_height = pad * 2

        item.text_spec = table.Copy(base_text_display_options)

        item.bg = item.bg and table.Copy(item.bg) or table.Copy(bg_col)
        item.bg.a_max = item.bg.a

        item.col = item.col and table.Copy(item.col) or table.Copy(text_color)
        item.col.a_max = item.col.a

        if item.image then
            max_text_width = max_text_width - imageSize - leftImagePad
            item.text_spec.font = imagedmsgfont
            item.title_spec = table.Copy(base_text_display_options)
            item.title_spec.font = imagedmsgfont
            item.title_spec.font_height = draw.GetFontHeight(item.title_spec.font)

            item.title_wrapped =
                draw.GetWrappedText(item.title, max_text_width, item.title_spec.font)

            -- calculate the new height
            item_height = item_height
                + top_margin
                + title_bottom_margin
                + #item.title_wrapped * (item.title_spec.font_height + line_margin)
                - line_margin
        end

        item.text_spec.font_height = draw.GetFontHeight(item.text_spec.font)

        item.text_wrapped = draw.GetWrappedText(item.text, max_text_width, item.text_spec.font)

        -- Height depends on number of lines, which is equal to number of table
        -- elements of the wrapped item.text
        item_height = item_height
            + #item.text_wrapped * (item.text_spec.font_height + line_margin)
            - line_margin

        if item.image then
            item_height = math.max(item_height, imageMinHeight)
        end

        item.move_y = -item_height
        item.height = item_height

        item.ready = true
    end

    function HUDELEMENT:DrawSmallMessage(item, pos_y, alpha)
        -- Background box
        draw.RoundedBox(8, top_x, pos_y, msg_width, item.height, item.bg)

        -- Text
        local tx = top_x + msg_width * 0.5
        local ty = pos_y + pad

        -- draw the normal text
        local text_spec = item.text_spec
        text_spec.color = item.col

        for i = 1, #item.text_wrapped do
            text_spec.text = item.text_wrapped[i]
            text_spec.pos = { tx, ty }

            draw.TextShadow(text_spec, 1, alpha)

            ty = ty + text_spec.font_height + line_margin
        end
    end

    function HUDELEMENT:DrawMessageWithImage(item, pos_y, alpha)
        -- Background box
        draw.RoundedBox(8, top_x, pos_y, msg_width, item.height, item.bg)

        -- Text
        local tx = top_x + (msg_width + leftImagePad + pad + imageSize) * 0.5
        local ty = pos_y + pad + top_margin

        -- draw the title text
        local title_spec = item.title_spec
        title_spec.color = item.col

        for i = 1, #item.title_wrapped do
            title_spec.text = item.title_wrapped[i]
            title_spec.pos = { tx, ty }

            draw.TextShadow(title_spec, 1, alpha)

            ty = ty + title_spec.font_height + line_margin
        end

        ty = ty + title_bottom_margin - line_margin -- remove old margin used for new line set in for loop above

        -- draw the normal text
        local text_spec = item.text_spec
        text_spec.color = item.col

        for i = 1, #item.text_wrapped do
            text_spec.text = item.text_wrapped[i]
            text_spec.pos = { tx, ty }

            draw.TextShadow(text_spec, 1, alpha)

            ty = ty + text_spec.font_height + line_margin
        end

        -- image
        surface.SetMaterial(item.image)
        surface.SetDrawColor(255, 255, 255, item.bg.a)
        surface.DrawTexturedRect(top_x + pad, pos_y + pad, imageSize, imageSize)
    end

    function HUDELEMENT:Draw()
        if next(MSTACK.msgs) == nil then
            return
        end -- fast empty check

        local running_y = top_y

        for k, item in pairs(MSTACK.msgs) do
            if item.time < CurTime() then
                if not item.ready then
                    PrepareItem(item, bg_color)
                end

                if item.sounded == false then
                    sound.ConditionalPlay(msg_sound, SOUND_TYPE_MESSAGE)

                    item.sounded = true
                end

                -- Apply move effects to y
                local y = running_y + margin + item.move_y

                item.move_y = (item.move_y < 0) and item.move_y + movespeed or 0

                local delta = item.time + staytime - CurTime()
                delta = delta / staytime -- pct of staytime left

                -- Hurry up if we have too many
                if k >= max_items then
                    delta = delta * 0.5
                end

                local alpha = 255
                -- These somewhat arcane delta and alpha equations are from gmod's
                -- HUDPickup stuff
                if delta > 1 - fadein then
                    alpha = math.Clamp((1.0 - delta) * (255 / fadein), 0, 255)
                elseif delta < fadeout then
                    alpha = math.Clamp(delta * (255 / fadeout), 0, 255)
                end

                item.bg.a = math.Clamp(alpha, 0, item.bg.a_max)
                item.col.a = math.Clamp(alpha, 0, item.col.a_max)

                if item.image then
                    self:DrawMessageWithImage(item, y, alpha)
                else
                    self:DrawSmallMessage(item, y, alpha)
                end

                if alpha == 0 then
                    MSTACK.msgs[k] = nil
                end

                running_y = y + item.height
            end
        end
    end
end
