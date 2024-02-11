--- @ignore

local base = "pure_skin_element"

DEFINE_BASECLASS(base)

HUDELEMENT.Base = base

if CLIENT then
    local dna = Material("vgui/ttt/dnascanner/dna_hud")

    local pad = 14
    local iconSize = 64

    local const_defaults = {
        basepos = { x = 0, y = 0 },
        size = { w = 326, h = 92 },
        minsize = { w = 326, h = 92 },
    }

    function HUDELEMENT:Initialize()
        self.scale = 1
        self.pad = pad
        self.iconSize = iconSize
        self.basecolor = self:GetHUDBasecolor()
        self.slotCount = 4

        BaseClass.Initialize(self)
    end

    -- parameter overwrites
    function HUDELEMENT:IsResizable()
        return false, false
    end
    -- parameter overwrites end

    function HUDELEMENT:GetDefaults()
        const_defaults["basepos"] =
            { x = math.Round(ScrW() * 0.5 - self.size.w * 0.5), y = ScrH() - self.size.h - 105 }

        return const_defaults
    end

    function HUDELEMENT:ShouldDraw()
        local client = LocalPlayer()
        local scanner = client:GetWeapon("weapon_ttt_wtester")

        return HUDEditor.IsEditing
            or IsValid(scanner) and client:GetActiveWeapon() == scanner and client:Alive()
    end

    function HUDELEMENT:PerformLayout()
        self.scale = self:GetHUDScale()
        self.basecolor = self:GetHUDBasecolor()
        self.pad = pad * self.scale
        self.iconSize = iconSize * self.scale

        BaseClass.PerformLayout(self)
    end

    function HUDELEMENT:DrawMarker(x, y, size, color)
        local thickness = 2 * self.scale
        local margin = 3 * self.scale
        local marker_x = x - margin - thickness
        local marker_y = y - margin - thickness
        local marker_size = size + margin * 2 + thickness * 2

        surface.SetDrawColor(color)

        for i = 0, thickness - 1 do
            surface.DrawOutlinedRect(
                marker_x + i,
                marker_y + i,
                marker_size - i * 2,
                marker_size - i * 2
            )
        end
    end

    function HUDELEMENT:GetAlpha(selectTime)
        local time_left = CurTime() - selectTime

        if time_left < 2 then
            local num = 0.5 * math.pi + (-2.0 * time_left + 7) * math.pi
            local factor = 0.5 * (math.sin(num) + 1)

            return 20 + 235 * (1 - factor)
        end

        return 255
    end

    function HUDELEMENT:Draw()
        local client = LocalPlayer()
        local pos = self:GetPos()
        local size = self:GetSize()
        local x, y = pos.x, pos.y
        local w, h = size.w, size.h
        local scanner = client:GetWeapon("weapon_ttt_wtester")

        --fake scanner for HUD editing
        if not IsValid(scanner) then
            scanner = {
                ItemSamples = { true },
                ScanSuccess = 0,
                NewSample = 0,
                ScanTime = 0,
                ActiveSample = 3,
            }
        end

        local slotCount = GetGlobalBool("ttt2_dna_scanner_slots")
        local newWidth = self.pad + slotCount * (self.pad + self.iconSize)

        if newWidth ~= size.w then
            local newX = pos.x + size.w * 0.5 - newWidth * 0.5
            w = newWidth
            x = newX
        end

        -- draw bg and shadow
        self:DrawBg(x, y, w, h, self.basecolor)

        local tmp_x = x + self.pad
        local tmp_y = y + self.pad
        local icon_size = 64 * self.scale
        local label_offset = 8 * self.scale

        for i = 1, GetGlobalBool("ttt2_dna_scanner_slots") do
            local identifier = string.char(64 + i)

            --draw background
            surface.SetDrawColor(50, 50, 50, 255)
            surface.DrawRect(tmp_x, tmp_y, icon_size, icon_size)

            if scanner.ItemSamples[i] then
                local alpha = 255

                if scanner.ScanSuccess > 0 and scanner.NewSample == i then
                    alpha = self:GetAlpha(scanner.ScanTime)
                end

                surface.SetDrawColor(40, 120, 40, alpha)
                surface.DrawRect(tmp_x, tmp_y, icon_size, icon_size)

                draw.FilteredShadowedTexture(
                    tmp_x + 3,
                    tmp_y + 3,
                    icon_size - 6,
                    icon_size - 6,
                    dna,
                    190,
                    COLOR_WHITE
                )
            else
                draw.FilteredTexture(
                    tmp_x + 3,
                    tmp_y + 3,
                    icon_size - 6,
                    icon_size - 6,
                    dna,
                    150,
                    COLOR_BLACK
                )
            end

            if scanner.ActiveSample == i then
                self:DrawMarker(tmp_x, tmp_y, icon_size, COLOR_WHITE)
            end

            draw.AdvancedText(
                identifier,
                "PureSkinMSTACKMsg",
                tmp_x + label_offset,
                tmp_y + label_offset,
                COLOR_WHITE,
                TEXT_ALIGN_CENTER,
                TEXT_ALIGN_CENTER,
                true,
                self.scale
            )

            self:DrawLines(tmp_x, tmp_y, icon_size, icon_size, 255)

            tmp_x = tmp_x + self.pad + icon_size
        end

        -- draw lines around the element
        self:DrawLines(x, y, w, h, self.basecolor.a)
    end
end
