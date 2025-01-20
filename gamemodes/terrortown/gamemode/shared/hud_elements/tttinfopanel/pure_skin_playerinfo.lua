--- @ignore

local base = "pure_skin_element"

DEFINE_BASECLASS(base)

HUDELEMENT.Base = base

if CLIENT then
    local GetLang = LANG.GetUnsafeLanguageTable

    local pad = 14 -- padding
    local lpw = 44 -- left panel width
    local sri_text_width_padding = 8 -- secondary role information padding (needed for size calculations)

    local watching_icon = Material("vgui/ttt/watching_icon")
    local credits_default = Material("vgui/ttt/equip/credits_default")
    local credits_zero = Material("vgui/ttt/equip/credits_zero")

    local icon_health = Material("vgui/ttt/hud_health.vmt")
    local icon_health_low = Material("vgui/ttt/hud_health_low.vmt")

    local icon_armor = Material("vgui/ttt/hud_armor.vmt")
    local icon_armor_rei = Material("vgui/ttt/hud_armor_reinforced.vmt")

    local mat_tid_ammo = Material("vgui/ttt/tid/tid_ammo")

    local color_sprint = Color(36, 154, 198)
    local color_health = Color(234, 41, 41)
    local color_ammoBar = Color(238, 151, 0)

    local const_defaults = {
        basepos = { x = 0, y = 0 },
        size = { w = 365, h = 146 },
        minsize = { w = 240, h = 146 },
    }

    function HUDELEMENT:Initialize()
        self.scale = 1.0
        self.basecolor = self:GetHUDBasecolor()
        self.pad = pad
        self.lpw = lpw
        self.sri_text_width_padding = sri_text_width_padding
        --self.secondaryRoleInformationFunc = nil

        BaseClass.Initialize(self)
    end

    ---
    -- This function will return a table containing all keys that will be stored by
    -- the @{HUDELEMENT:SaveData} function.
    -- @return table
    -- @realm client
    function HUDELEMENT:GetSavingKeys()
        local savingKeys = BaseClass.GetSavingKeys(self) or {}
        savingKeys.healthPulsate = {
            typ = "bool",
            desc = "label_hud_pulsate_health_enable",
            default = true,
            OnChange = function(slf, bool)
                slf:PerformLayout()
                slf:SaveData()
            end,
        }

        savingKeys.showTeamName = {
            typ = "bool",
            desc = "label_hud_show_team_name",
            default = false,
            OnChange = function(slf, bool)
                slf:PerformLayout()
                slf:SaveData()
            end,
        }

        return table.Copy(savingKeys)
    end

    -- parameter overwrites
    function HUDELEMENT:IsResizable()
        return true, true
    end
    -- parameter overwrites end

    function HUDELEMENT:GetDefaults()
        const_defaults["basepos"] = {
            x = 10 * self.scale,
            y = ScrH() - (10 * self.scale + self.size.h),
        }

        return const_defaults
    end

    function HUDELEMENT:PerformLayout()
        local defaults = self:GetDefaults()

        self.basecolor = self:GetHUDBasecolor()
        self.scale = math.min(self.size.w / defaults.minsize.w, self.size.h / defaults.minsize.h)
        self.lpw = lpw * self.scale
        self.pad = pad * self.scale
        self.sri_text_width_padding = sri_text_width_padding * self.scale

        BaseClass.PerformLayout(self)
    end

    -- Returns player's ammo information
    function HUDELEMENT:GetAmmo(ply)
        local weap = ply:GetActiveWeapon()

        if not weap or not ply:Alive() then
            return -1
        end

        local ammo_inv = weap.Ammo1 and weap:Ammo1() or 0
        local ammo_clip = weap:Clip1() or 0
        local ammo_max = weap.Primary.ClipSize or 0
        local ammo_type = string.lower(weap.Primary.Ammo)

        return ammo_clip, ammo_max, ammo_inv, ammo_type
    end

    --[[
        This function expects to receive a function as a parameter which later returns a table with the following keys: { text: "", color: Color }
        The function should also take care of managing the visibility by returning nil to tell the UI that nothing should be displayed
    ]]
    --
    function HUDELEMENT:SetSecondaryRoleInfoFunction(func)
        if not isfunction(func) then
            return
        end

        self.secondaryRoleInformationFunc = func
    end

    function HUDELEMENT:Draw()
        local client = LocalPlayer()
        local calive = client:Alive() and client:IsTerror()
        local cactive = client:IsActive()
        local L = GetLang()

        local x2, y2, w2, h2 = self.pos.x, self.pos.y, self.size.w, self.size.h
        local t_scale = self.scale
        local t_lpw = self.lpw
        local t_pad = self.pad
        local t_basecolor = self.basecolor
        local t_sri_text_width_padding = self.sri_text_width_padding

        if not calive then
            y2 = y2 + h2 - t_lpw
            h2 = t_lpw
        end

        -- draw bg and shadow
        self:DrawBg(x2, y2, w2, h2, t_basecolor)

        -- draw left panel
        local c

        if cactive then
            c = client:GetRoleColor()
        else
            c = COLOR_SPEC
        end

        surface.SetDrawColor(clr(c))
        surface.DrawRect(x2, y2, t_lpw, h2)

        local ry = y2 + t_lpw * 0.5
        local ty = y2 + t_lpw + t_pad -- new y
        local nx = x2 + t_lpw + t_pad -- new x

        -- draw role icon
        local rd = client:GetSubRoleData()
        if rd then
            local tgt = client:GetObserverTarget()

            if cactive then
                if rd.iconMaterial then
                    draw.FilteredShadowedTexture(
                        x2 + 4,
                        y2 + 4,
                        t_lpw - 8,
                        t_lpw - 8,
                        rd.iconMaterial,
                        255,
                        util.GetDefaultColor(c),
                        t_scale
                    )
                end
            elseif IsValid(tgt) and tgt:IsPlayer() then
                draw.FilteredShadowedTexture(
                    x2 + 4,
                    y2 + 4,
                    t_lpw - 8,
                    t_lpw - 8,
                    watching_icon,
                    255,
                    util.GetDefaultColor(c),
                    t_scale
                )
            end

            -- draw role string name
            local text
            local round_state = gameloop.GetRoundState()

            if cactive then
                if self.showTeamName then
                    text = L[rd.name] .. " (" .. L[client:GetTeam()] .. ")"
                else
                    text = L[rd.name]
                end
            else
                if IsValid(tgt) and tgt:IsPlayer() then
                    text = tgt:Nick()
                else
                    text = L[self.roundstate_string[round_state]]
                end
            end

            --calculate the scale multplier for role text
            surface.SetFont("PureSkinRole")

            local role_text_width = surface.GetTextSize(string.upper(text)) * t_scale
            local role_scale_multiplier = (w2 - t_lpw - 2 * t_pad) / role_text_width

            if calive and cactive and isfunction(self.secondaryRoleInformationFunc) then
                local secInfoTbl = self.secondaryRoleInformationFunc()

                if secInfoTbl and secInfoTbl.text then
                    surface.SetFont("PureSkinBar")

                    local sri_text_width = surface.GetTextSize(string.upper(secInfoTbl.text))
                        * t_scale

                    role_scale_multiplier = (
                        w2
                        - sri_text_width
                        - t_lpw
                        - 2 * t_pad
                        - 3 * t_sri_text_width_padding
                    ) / role_text_width
                end
            end

            role_scale_multiplier = math.Clamp(role_scale_multiplier, 0.55, 0.85) * t_scale

            draw.AdvancedText(
                string.upper(text),
                "PureSkinRole",
                nx,
                ry,
                util.GetDefaultColor(t_basecolor),
                TEXT_ALIGN_LEFT,
                TEXT_ALIGN_CENTER,
                true,
                Vector(role_scale_multiplier * 0.9, role_scale_multiplier, role_scale_multiplier)
            )
        end

        -- player informations
        if calive then
            -- draw secondary role information
            if cactive and isfunction(self.secondaryRoleInformationFunc) then
                local secInfoTbl = self.secondaryRoleInformationFunc()

                if secInfoTbl and secInfoTbl.color and secInfoTbl.text then
                    surface.SetFont("PureSkinBar")

                    local sri_text_caps = string.upper(secInfoTbl.text)
                    local sri_text_width = surface.GetTextSize(sri_text_caps) * t_scale
                    local sri_margin_top_bottom = 8 * t_scale
                    local sri_width = sri_text_width + t_sri_text_width_padding * 2
                    local sri_xoffset = w2 - sri_width - t_pad

                    local nx2 = x2 + sri_xoffset
                    local ny = y2 + sri_margin_top_bottom
                    local nh = t_lpw - sri_margin_top_bottom * 2

                    surface.SetDrawColor(clr(secInfoTbl.color))
                    surface.DrawRect(nx2, ny, sri_width, nh)

                    draw.AdvancedText(
                        sri_text_caps,
                        "PureSkinBar",
                        nx2 + sri_width * 0.5,
                        ry,
                        util.GetDefaultColor(secInfoTbl.color),
                        TEXT_ALIGN_CENTER,
                        TEXT_ALIGN_CENTER,
                        true,
                        t_scale
                    )

                    -- draw lines around the element
                    self:DrawLines(nx2, ny, sri_width, nh, secInfoTbl.color.a)
                end
            end

            -- draw dark bottom overlay
            surface.SetDrawColor(0, 0, 0, 90)
            surface.DrawRect(x2, y2 + t_lpw, w2, h2 - t_lpw)

            -- draw bars
            local bw = w2 - t_lpw - t_pad * 2 -- bar width
            local bh = 26 * t_scale -- bar height
            local sbh = 8 * t_scale -- spring bar height
            local spc = 7 * t_scale -- space between bars

            -- health bar
            local health = math.max(0, client:Health())
            local armor = client:GetArmor()
            local alpha = 255
            local health_icon = icon_health

            if health <= client:GetMaxHealth() * 0.25 and self.healthPulsate then
                local frequency =
                    util.TransformToRange(health, 1, client:GetMaxHealth() * 0.25 + 1, 1, 6)
                health_icon = icon_health_low

                local factor = math.abs(math.sin(CurTime() * (7 - frequency)))

                alpha = math.Round(factor * 255)
            end

            color_health = ColorAlpha(color_health, alpha)

            self:DrawBar(nx, ty, bw, bh, color_health, health / client:GetMaxHealth(), t_scale)

            local a_size = bh - math.Round(11 * t_scale)
            local a_pad = math.Round(5 * t_scale)

            local a_pos_y = ty + a_pad
            local a_pos_x = nx + (a_size / 2)

            local at_pos_y = ty + 1
            local at_pos_x = a_pos_x + a_size + a_pad

            draw.FilteredShadowedTexture(
                a_pos_x,
                a_pos_y,
                a_size,
                a_size,
                health_icon,
                255,
                COLOR_WHITE,
                t_scale
            )
            draw.AdvancedText(
                health,
                "PureSkinBar",
                at_pos_x,
                at_pos_y,
                util.GetDefaultColor(color_health),
                TEXT_ALIGN_LEFT,
                TEXT_ALIGN_LEFT,
                true,
                t_scale
            )

            -- draw armor information
            if GetGlobalBool("ttt_armor_dynamic", false) and armor > 0 then
                local icon_mat = client:ArmorIsReinforced() and icon_armor_rei or icon_armor

                a_pos_x = nx + bw - math.Round(65 * t_scale)
                at_pos_x = a_pos_x + a_size + a_pad

                draw.FilteredShadowedTexture(
                    a_pos_x,
                    a_pos_y,
                    a_size,
                    a_size,
                    icon_mat,
                    255,
                    COLOR_WHITE,
                    t_scale
                )

                draw.AdvancedText(
                    armor,
                    "PureSkinBar",
                    at_pos_x,
                    at_pos_y,
                    util.GetDefaultColor(color_health),
                    TEXT_ALIGN_LEFT,
                    TEXT_ALIGN_LEFT,
                    true,
                    t_scale
                )
            end

            -- ammo bar
            ty = ty + bh + spc
            a_pos_y = ty + a_pad

            -- Draw ammo
            if client:GetActiveWeapon().Primary then
                local ammo_clip, ammo_max, ammo_inv, ammo_type = self:GetAmmo(client)

                if ammo_clip ~= -1 then
                    local text = string.format("%i + %02i", ammo_clip, ammo_inv)

                    self:DrawBar(nx, ty, bw, bh, color_ammoBar, ammo_clip / ammo_max, t_scale)

                    local icon_mat = BaseClass.BulletIcons[ammo_type] or mat_tid_ammo

                    a_pos_x = nx + (a_size / 2)
                    at_pos_y = ty + 1
                    at_pos_x = a_pos_x + a_size + a_pad

                    draw.FilteredShadowedTexture(
                        a_pos_x,
                        a_pos_y,
                        a_size,
                        a_size,
                        icon_mat,
                        255,
                        COLOR_WHITE,
                        t_scale
                    )
                    draw.AdvancedText(
                        text,
                        "PureSkinBar",
                        at_pos_x,
                        at_pos_y,
                        util.GetDefaultColor(color_ammoBar),
                        TEXT_ALIGN_LEFT,
                        TEXT_ALIGN_LEFT,
                        true,
                        t_scale
                    )
                end
            end

            -- sprint bar
            ty = ty + bh + spc

            if SPRINT.convars.enabled:GetBool() then
                self:DrawBar(nx, ty, bw, sbh, color_sprint, client:GetSprintStamina(), t_scale, "")
            end

            -- coin info
            if cactive and client:IsShopper() then
                local coinSize = 24 * t_scale
                local x2_pad = math.Round((t_lpw - coinSize) * 0.5)

                if client:GetCredits() > 0 then
                    draw.FilteredTexture(
                        x2 + x2_pad,
                        y2 + h2 - coinSize - x2_pad,
                        coinSize,
                        coinSize,
                        credits_default,
                        200
                    )
                else
                    draw.FilteredTexture(
                        x2 + x2_pad,
                        y2 + h2 - coinSize - x2_pad,
                        coinSize,
                        coinSize,
                        credits_zero,
                        100
                    )
                end
            end
        end

        -- draw lines around the element
        self:DrawLines(x2, y2, w2, h2, t_basecolor.a)
    end
end
