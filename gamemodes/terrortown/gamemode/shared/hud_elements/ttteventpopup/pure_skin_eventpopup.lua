--- @ignore

local base = "pure_skin_element"

DEFINE_BASECLASS(base)

HUDELEMENT.Base = base

if CLIENT then
    local const_defaults = {
        basepos = { x = 0, y = 0 },
        size = { w = 1000, h = 86 },
        minsize = { w = 500, h = 86 },
    }

    local pad = 14
    local icon_size = 64

    local titlefont = "PureSkinPopupTitle"
    local textfont = "PureSkinPopupText"

    function HUDELEMENT:Initialize()
        self.pad = pad
        self.basecolor = self:GetHUDBasecolor()

        BaseClass.Initialize(self)
    end

    -- parameter overwrites
    function HUDELEMENT:IsResizable()
        return true, false
    end
    -- parameter overwrites end

    function HUDELEMENT:GetDefaults()
        const_defaults["basepos"] = {
            x = math.Round((ScrW() - self.size.w) * 0.5),
            y = math.Round((ScrH() - self.size.h) * 0.5) - 250,
        }

        return const_defaults
    end

    function HUDELEMENT:ShouldDraw()
        return HUDEditor.IsEditing or EPOP:ShouldRender()
    end

    function HUDELEMENT:PerformLayout()
        self.scale = appearance.GetGlobalScale()
        self.pad = pad * self.scale
        self.icon_size = icon_size * self.scale

        self.basecolor = self:GetHUDBasecolor()

        -- reset item ready
        if EPOP.msg then
            EPOP.msg.ready = false
        end

        BaseClass.PerformLayout(self)
    end

    function HUDELEMENT:PrepareItem(item)
        local size = self:GetSize()
        local pos = self:GetPos()
        local width_title, width_text, height_title, height_text = 0, 0, 0, 0
        local pad2 = 2 * self.pad

        -- wrap title if needed
        item.wrappedTitle, width_title, height_title = draw.GetWrappedText(
            LANG.TryTranslation(item.title.text),
            size.w - pad2,
            titlefont,
            self.scale
        )

        -- wrap text if needed
        item.wrappedSubtitle, width_text, height_text = draw.GetWrappedText(
            LANG.TryTranslation(item.subtitle.text),
            size.w - pad2,
            textfont,
            self.scale
        )

        item.size = {}
        item.size.w = ((width_title > width_text) and width_title or width_text) + pad2
        item.size.h = height_title + pad2 + height_text + ((height_text > 0) and self.pad or 0)

        item.pos = {}
        item.pos.y = pos.y
        item.pos.x = pos.x + math.Round(0.5 * (size.w - item.size.w))
        item.pos.center_x = pos.x + math.Round(0.5 * size.w)

        local wrappedItems = #item.wrappedTitle
        local wrappedTexts = #item.wrappedSubtitle

        -- precalculate text positions
        local height_title_line = height_title / wrappedItems
        local height_text_line = height_text / wrappedTexts

        item.pos.title_y = {}

        for i = 1, wrappedItems do
            item.pos.title_y[i] = pos.y + self.pad + (i - 1) * height_title_line
        end

        item.pos.text_y = {}

        for i = 1, wrappedTexts do
            item.pos.text_y[i] = item.pos.title_y[wrappedItems]
                + height_title_line
                + self.pad
                + (i - 1) * height_text_line
        end

        -- add item positions
        local icon_amt = #item.iconTable
        local icon_start_x = item.pos.center_x
            - math.Round(0.5 * (icon_amt * self.icon_size + math.max(0, icon_amt - 1) * self.pad))

        item.pos.icon_y = item.pos.y + item.size.h + self.pad
        item.pos.icon_x = { icon_start_x }

        for i = 1, icon_amt do
            item.pos.icon_x[i] = icon_start_x + (i * 2 - 1) * (self.icon_size + self.pad)
        end

        -- mark as ready
        item.ready = true
    end

    function HUDELEMENT:Draw()
        local size = self:GetSize()
        local msg = HUDEditor.IsEditing and EPOP:GetDefaultMessage() or EPOP:GetMessage()

        -- prepare item, caches the data of the element to improve performance
        if not msg.ready then
            self:PrepareItem(msg)
        end

        -- calculate fadeout
        local fadetime = 1.5
        local timediff = HUDEditor.IsEditing and 5 or (msg.time - CurTime())
        local opacity = (timediff > fadetime) and 255 or math.Round(255 * timediff / fadetime)

        local colorTitle = msg.title.color or COLOR_WHITE
        local colorSubtitle = msg.subtitle.color or COLOR_WHITE

        -- draw content
        local wrappedTitles = msg.wrappedTitle

        for i = 1, #wrappedTitles do
            draw.AdvancedText(
                wrappedTitles[i],
                titlefont,
                msg.pos.center_x,
                msg.pos.title_y[i],
                Color(colorTitle.r, colorTitle.g, colorTitle.b, opacity),
                TEXT_ALIGN_CENTER,
                TEXT_ALIGN_TOP,
                true,
                self.scale
            )
        end

        local wrappedTexts = msg.wrappedSubtitle

        for i = 1, #wrappedTexts do
            draw.AdvancedText(
                wrappedTexts[i],
                textfont,
                msg.pos.center_x,
                msg.pos.text_y[i],
                Color(colorSubtitle.r, colorSubtitle.g, colorSubtitle.b, opacity),
                TEXT_ALIGN_CENTER,
                TEXT_ALIGN_TOP,
                true,
                self.scale
            )
        end

        local wrappedIcons = msg.iconTable

        for i = 1, #wrappedIcons do
            draw.FilteredTexture(
                msg.pos.icon_x[i],
                msg.pos.icon_y,
                self.icon_size,
                self.icon_size,
                wrappedIcons[i],
                opacity
            )
        end

        self:SetSize(size.w, msg.size.h)
    end
end
