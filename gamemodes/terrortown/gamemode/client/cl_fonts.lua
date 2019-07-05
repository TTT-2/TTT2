FONTS = {}

local shadowColorDark = Color(0, 0, 0, 200)
local shadowColorWhite = Color(200, 200, 200, 200)

function util.DrawShadowedText(text, font, x, y, color, xalign, yalign, dark)
    local tmpCol = color.r + color.g + color.b > 200 and Color(shadowColorDark.r, shadowColorDark.g, shadowColorDark.b, color.a) or Color(shadowColorWhite.r, shadowColorWhite.g, shadowColorWhite.b, color.a)

    draw.SimpleText(text, font, x + 2, y + 2, tmpCol, xalign, yalign)
    draw.SimpleText(text, font, x + 1, y + 1, tmpCol, xalign, yalign)
    draw.SimpleText(text, font, x, y, color, xalign, yalign)
end

function util.DrawAdvancedText(text, font, x, y, color, xalign, yalign, shadow, scale)
    local mat
    if isvector(scale) or scale ~= 1.0 then
        mat = Matrix()
        mat:Translate(Vector(x, y))
        mat:Scale(isvector(scale) and scale or Vector(scale, scale, scale))
        mat:Translate(-Vector(ScrW() * 0.5, ScrH() * 0.5))

        render.PushFilterMag(TEXFILTER.ANISOTROPIC)
        render.PushFilterMin(TEXFILTER.ANISOTROPIC)

        cam.PushModelMatrix(mat)

        x = ScrW() * 0.5
        y = ScrH() * 0.5
    end

    if shadow then
        util.DrawShadowedText(text, font, x, y, color, xalign, yalign)
    else
        draw.SimpleText(text, font, x, y, color, xalign, yalign)
    end

    if isvector(scale) or scale ~= 1.0 then
        cam.PopModelMatrix(mat)

        render.PopFilterMag()
        render.PopFilterMin()
    end
end
