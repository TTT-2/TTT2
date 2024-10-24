---
-- @class HUDELEMENT
-- @section old_ttt_element

local surface = surface
local draw = draw
local math = math

local base = "hud_element_base"

DEFINE_BASECLASS(base)

HUDELEMENT.Base = base

if CLIENT then
    ---
    -- @realm client
    local hudWidth = CreateConVar("ttt2_base_hud_width", "0", FCVAR_ARCHIVE)

    -- Color presets
    HUDELEMENT.bg_colors = {
        background_main = Color(0, 0, 10, 200),
        noround = Color(100, 100, 100, 200),
    }

    HUDELEMENT.health_colors = {
        border = COLOR_WHITE,
        background = Color(100, 25, 25, 222),
        fill = Color(200, 50, 50, 250),
    }

    HUDELEMENT.ammo_colors = {
        border = COLOR_WHITE,
        background = Color(20, 20, 5, 222),
        fill = Color(205, 155, 0, 255),
    }

    HUDELEMENT.sprint_colors = {
        border = COLOR_WHITE,
        background = Color(10, 50, 73, 222),
        fill = Color(36, 154, 198, 255),
    }

    -- Modified RoundedBox
    HUDELEMENT.Tex_Corner8 = surface.GetTextureID("gui/corner8")

    ---
    -- Draws a rounded bar
    -- @param number bs
    -- @param number x
    -- @param number y
    -- @param number w
    -- @param number h
    -- @param Color color
    -- @realm client
    function HUDELEMENT:RoundedMeter(bs, x, y, w, h, color)
        surface.SetDrawColor(clr(color))

        surface.DrawRect(x + bs, y, w - bs * 2, h)
        surface.DrawRect(x, y + bs, bs, h - bs * 2)

        surface.SetTexture(self.Tex_Corner8)
        surface.DrawTexturedRectRotated(x + bs * 0.5, y + bs * 0.5, bs, bs, 0)
        surface.DrawTexturedRectRotated(x + bs * 0.5, y + h - bs * 0.5, bs, bs, 90)

        if w > 14 then
            surface.DrawRect(x + w - bs, y + bs, bs, h - bs * 2)
            surface.DrawTexturedRectRotated(x + w - bs * 0.5, y + bs * 0.5, bs, bs, 270)
            surface.DrawTexturedRectRotated(x + w - bs * 0.5, y + h - bs * 0.5, bs, bs, 180)
        else
            surface.DrawRect(x + math.max(w - bs, bs), y, bs * 0.5, h)
        end
    end

    ---
    -- Paints the main bar area
    -- @param number x
    -- @param number y
    -- @param number w
    -- @param number h
    -- @param table colors Table of @{Color}. There need to be a .background and a .fill attribute
    -- @param number value
    -- @realm client
    function HUDELEMENT:PaintBar(x, y, w, h, colors, value)
        value = value or 1

        -- Background
        -- slightly enlarged to make a subtle border
        draw.RoundedBox(8, x - 1, y - 1, w + 2, h + 2, colors.background)

        -- Fill
        local width = w * math.Clamp(value, 0, 1)
        if width <= 0 then
            return
        end

        self:RoundedMeter(8, x, y, width, h, colors.fill)
    end

    HUDELEMENT.roundstate_string = {
        [ROUND_WAIT] = "round_wait",
        [ROUND_PREP] = "round_prep",
        [ROUND_ACTIVE] = "round_active",
        [ROUND_POST] = "round_post",
    }

    HUDELEMENT.margin = 10
    HUDELEMENT.dmargin = HUDELEMENT.margin * 2
    HUDELEMENT.smargin = 2
    HUDELEMENT.maxheight = 90
    HUDELEMENT.maxwidth = hudWidth:GetInt() + HUDELEMENT.maxheight + HUDELEMENT.margin + 170
    HUDELEMENT.hastewidth = 80
    HUDELEMENT.bgheight = 30

    ---
    -- Returns player's ammo information
    -- @param Player ply
    -- @return number ammo in the current clip
    -- @return number maximum ammo of the current clip
    -- @return number ammo in the inventory
    -- @realm client
    function HUDELEMENT:GetAmmo(ply)
        local weap = ply:GetActiveWeapon()

        if not weap or not ply:Alive() then
            return -1
        end

        local ammo_inv = weap.Ammo1 and weap:Ammo1() or 0
        local ammo_clip = weap:Clip1() or 0
        local ammo_max = weap.Primary.ClipSize or 0

        return ammo_clip, ammo_max, ammo_inv
    end

    ---
    -- Draws the main background
    -- @param number x
    -- @param number y
    -- @param number width
    -- @param number height
    -- @param Player client should be the <code>LocalPlayer()</code>
    -- @realm client
    function HUDELEMENT:DrawBg(x, y, width, height, client)
        -- Traitor area sizes
        local th = self.bgheight
        local tw = width - self.hastewidth - self.bgheight - self.smargin * 2 -- bgheight = team icon

        -- Adjust for these
        y = y - th
        height = height + th

        -- main bg area, invariant
        -- encompasses entire area
        draw.RoundedBox(8, x, y, width, height, self.bg_colors.background_main)

        -- main border, role based
        draw.RoundedBox(
            8,
            x,
            y,
            tw,
            th,
            gameloop.GetRoundState() ~= ROUND_ACTIVE and self.bg_colors.noround
                or client:GetRoleColor()
        )
    end

    ---
    -- Draws a shadowed text
    -- @param string text
    -- @param string font
    -- @param number x
    -- @param number y
    -- @param Color color
    -- @param number xalign
    -- @param number yalign
    -- @realm client
    function HUDELEMENT:ShadowedText(text, font, x, y, color, xalign, yalign)
        draw.SimpleText(text, font, x + 2, y + 2, COLOR_BLACK, xalign, yalign)
        draw.SimpleText(text, font, x, y, color, xalign, yalign)
    end
end
