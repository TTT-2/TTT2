FONTS = {}
FONTS.fonts = {}
FONTS.Scales = {1, 1.5, 2, 2.5}

local shadowColorDark = Color(0, 0, 0, 200)
local shadowColorWhite = Color(200, 200, 200, 200)

local function getScaleModifier(scale)      
    local scaleFactor = isvector(scale) and math.max(scale.x, math.max(scale.y, scale.z)) or scale
    scaleFactor = tonumber(scaleFactor)
    
    for _, scale in ipairs(FONTS.Scales) do
        if scaleFactor <= scale then
            return scale
        end
    end
    
    --fallback (return the last scale)
    return FONTS.Scales[#FONTS.Scales]
end

function surface.CreateAdvancedFont(fontName, fontData)
    local originalSize = fontData.size or 13
    
    FONTS.fonts[fontName] = {}

    for _, scale in ipairs(FONTS.Scales) do
        --note: the original font should be always created
        local scaledFontName = scale == 1 and fontName or fontName .. tostring(scale)

        --create font
        fontData.size = scale * originalSize
        surface.CreateFont(scaledFontName, fontData)

        FONTS.fonts[fontName][scale] = scaledFontName
    end
end

function draw.ShadowedText(text, font, x, y, color, xalign, yalign, scaleModifier)
    local tmpCol = color.r + color.g + color.b > 200 and Color(shadowColorDark.r, shadowColorDark.g, shadowColorDark.b, color.a) or Color(shadowColorWhite.r, shadowColorWhite.g, shadowColorWhite.b, color.a)

    draw.SimpleText(text, font, x + 2 * scaleModifier, y + 2 * scaleModifier, tmpCol, xalign, yalign)
    draw.SimpleText(text, font, x + 1 * scaleModifier, y + 1 * scaleModifier, tmpCol, xalign, yalign)
    draw.SimpleText(text, font, x, y, color, xalign, yalign)
end

function draw.AdvancedText(text, font, x, y, color, xalign, yalign, shadow, scale)
    local scaleModifier = 1.0
    if FONTS.fonts[font] then
        scaleModifier = getScaleModifier(scale)
        font = FONTS.fonts[font][scaleModifier]
        scale = scale / scaleModifier
    end
    
    local mat
    if isvector(scale) or scale ~= 1.0 then
        mat = Matrix()
        mat:Translate(Vector(x, y))
        mat:Scale(isvector(scale) and scale or Vector(scale, scale, scale))
        mat:Translate(-Vector(ScrW() * 0.5, ScrH() * 0.5))

        render.PushFilterMag(TEXFILTER.LINEAR)
        render.PushFilterMin(TEXFILTER.LINEAR)

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
