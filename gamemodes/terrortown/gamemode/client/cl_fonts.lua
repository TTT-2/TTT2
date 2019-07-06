FONTS = {}

local shadowColorDark = Color(0, 0, 0, 200)
local shadowColorWhite = Color(200, 200, 200, 200)

local function getScaleModifier(scale)
    print(scale)

    local scaleFactor = isvector(scale) and math.max(scale.x, math.max(scale.y, scale.z)) or scale
    if scaleFactor < 0.75 then
        return 0.5
    elseif scaleFactor < 1.5 then
        return 1
    else
        return 2
    end
end

function draw.CreateAdvancedFont(fontName, fontData)
    local fontName2 = fontName .. "2" 
    local fontName05 = fontName .. "0.5" 
    
    FONTS[fontName] = {}

    FONTS[fontName][0.5] = fontName05
    FONTS[fontName][1] = fontName
    FONTS[fontName][2] = fontName2

    --create original font
    surface.CreateFont(fontName, fontData)

    --create font with halfed size
    fontData.size = 0.5 * fontData.size
    surface.CreateFont(fontName05, fontData)
    fontData.size = 2 * fontData.size

    --create font with doubled size
    fontData.size = 2 * fontData.size
    surface.CreateFont(fontName2, fontData)
end

function draw.ShadowedText(text, font, x, y, color, xalign, yalign, scaleModifier)
    local tmpCol = color.r + color.g + color.b > 200 and Color(shadowColorDark.r, shadowColorDark.g, shadowColorDark.b, color.a) or Color(shadowColorWhite.r, shadowColorWhite.g, shadowColorWhite.b, color.a)

    draw.SimpleText(text, font, x + 2 * scaleModifier, y + 2 * scaleModifier, tmpCol, xalign, yalign)
    draw.SimpleText(text, font, x + 1 * scaleModifier, y + 1 * scaleModifier, tmpCol, xalign, yalign)
    draw.SimpleText(text, font, x, y, color, xalign, yalign)
end

function draw.AdvancedText(text, font, x, y, color, xalign, yalign, shadow, scale)
    local scaleModifier = 1.0
    if FONTS[font] then
        scaleModifier = getScaleModifier(scale)
        font = FONTS[font][scaleModifier]
        scale = scale / scaleModifier
    end
    
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
        draw.ShadowedText(text, font, x, y, color, xalign, yalign, scaleModifier)
    else
        draw.SimpleText(text, font, x, y, color, xalign, yalign)
    end

    if isvector(scale) or scale ~= 1.0 then
        cam.PopModelMatrix(mat)

        render.PopFilterMag()
        render.PopFilterMin()
    end
end
