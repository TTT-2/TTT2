--- @ignore

local base = "pure_skin_element"

HUDELEMENT.Base = base

DEFINE_BASECLASS(base)

HUDELEMENT.togglable = true

if SERVER then
    return
end -- clientside-only

local margin = 14
local element_margin = 6
local row_count = 2

local color_blacktrans = Color(0, 0, 0, 130)
local color_indirconfirm = Color(215, 215, 215, 155)

local const_defaults = {
    basepos = { x = 0, y = 0 },
    size = { w = 72, h = 72 },
    minsize = { w = 0, h = 0 },
}

local plysList = {}

local function SortMiniscoreboardFunc(a, b)
    if not a:OnceFound() then
        return false
    end

    -- bodies were confirmed and body a was confirmed prior to body b
    if b:OnceFound() and a:GetFirstFound() >= b:GetFirstFound() then
        return false
    end

    return true
end

local refreshPaths = {
    ["t_first_found"] = true,
    ["t_last_found"] = true,
    ["role_found"] = true,
    ["body_found"] = true,
}

function HUDELEMENT:PreInitialize()
    hudelements.RegisterChildRelation(self.id, "pure_skin_roundinfo", false)

    -- resort miniscoreboard if body_found is changed
    ttt2net.OnUpdate("players", function(oldval, newval, reversePath)
        -- check if path of changed value is one of our releavant paths
        if not refreshPaths[reversePath[2]] then
            return
        end

        -- sort playerlist: confirmed players should be in the first position
        table.sort(plysList, SortMiniscoreboardFunc)
    end)
end

HUDELEMENT.icon_in_conf = Material("vgui/ttt/indirect_confirmed")
HUDELEMENT.icon_revived = Material("vgui/ttt/revived")

function HUDELEMENT:Initialize()
    self.margin = margin
    self.element_margin = element_margin
    self.column_count = 0
    self.parentInstance = hudelements.GetStored(self.parent)
    self.curPlayerCount = 0
    self.ply_ind_size = 0
    self.scale = 1.0
    self.basecolor = self:GetHUDBasecolor()

    plysList = util.GetFilteredPlayers(function(ply)
        return ply:WasActiveInRound()
    end)

    self.curPlayerCount = #plysList

    -- sort playerlist: confirmed players should be in the first position
    table.sort(plysList, SortMiniscoreboardFunc)

    self.lastUpdate = CurTime()

    BaseClass.Initialize(self)
end

-- parameter overwrites
function HUDELEMENT:ShouldDraw()
    return gameloop.GetRoundState() == ROUND_ACTIVE
end

function HUDELEMENT:InheritParentBorder()
    return true
end
-- parameter overwrites end

function HUDELEMENT:GetDefaults()
    return const_defaults
end

function HUDELEMENT:PerformLayout()
    local parent_pos = self.parentInstance:GetPos()
    local parent_size = self.parentInstance:GetSize()
    local parent_defaults = self.parentInstance:GetDefaults()
    local h = parent_size.h

    self.basecolor = self:GetHUDBasecolor()
    self.scale = h / parent_defaults.size.h
    self.margin = margin * self.scale
    self.element_margin = element_margin * self.scale
    self.ply_ind_size = math.Round((h - self.element_margin - self.margin * 2) * 0.5)
    self.column_count = math.Round(self.curPlayerCount * 0.5)

    local w = self.element_margin * (self.column_count - 1)
        + self.ply_ind_size * self.column_count
        + 2 * self.margin

    self:SetPos(parent_pos.x + parent_size.w, parent_pos.y)
    self:SetSize(w, h)

    BaseClass.PerformLayout(self)
end

local function GetMSBColorForPlayer(ply)
    local color = color_blacktrans -- not yet confirmed

    if ply:OnceFound() then
        if ply:HasRole() then
            local roleColor = ply:GetRoleColor()

            color = Color(roleColor.r, roleColor.g, roleColor.b, 155) -- role known
        else
            color = color_indirconfirm -- indirect confirmed
        end
    end

    ---
    -- @realm client
    return hook.Run("TTT2ModifyMiniscoreboardColor", ply, color) or color
end

function HUDELEMENT:Draw()
    -- just update every 0.1 seconds; TODO maybe add a client ConVar
    if self.lastUpdate + 0.1 < CurTime() then
        local plys = util.GetFilteredPlayers(function(ply)
            return ply:WasActiveInRound()
        end)

        if #plys ~= self.curPlayerCount then
            plysList = plys
            self.curPlayerCount = #plys

            self:PerformLayout()

            -- sort playerlist: confirmed players should be in the first position
            table.sort(plysList, SortMiniscoreboardFunc)
        end

        self.lastUpdate = CurTime()
    end

    -- draw bg and shadow
    self:DrawBg(self.pos.x, self.pos.y, self.size.w, self.size.h, self.basecolor)

    -- draw dark bottom overlay
    surface.SetDrawColor(0, 0, 0, 90)
    surface.DrawRect(self.pos.x, self.pos.y, self.size.w, self.size.h)

    -- draw squares
    local tmp_x, tmp_y = self.pos.x, self.pos.y

    for i = 1, self.curPlayerCount do
        local ply = plysList[i]

        tmp_x = self.pos.x
            + self.margin
            + (self.element_margin + self.ply_ind_size) * math.floor((i - 1) * 0.5)
        tmp_y = self.pos.y
            + self.margin
            + (self.element_margin + self.ply_ind_size) * ((i - 1) % row_count)

        local ply_color = GetMSBColorForPlayer(ply)

        surface.SetDrawColor(clr(ply_color))
        surface.DrawRect(tmp_x, tmp_y, self.ply_ind_size, self.ply_ind_size)

        if IsValid(ply) then
            if ply:WasRevivedAndConfirmed() then
                draw.FilteredTexture(
                    tmp_x + 3,
                    tmp_y + 3,
                    self.ply_ind_size - 6,
                    self.ply_ind_size - 6,
                    self.icon_revived,
                    180,
                    COLOR_BLACK
                )
            elseif ply:OnceFound() and not ply:RoleKnown() then -- draw marker on indirect confirmed bodies
                draw.FilteredTexture(
                    tmp_x + 3,
                    tmp_y + 3,
                    self.ply_ind_size - 6,
                    self.ply_ind_size - 6,
                    self.icon_in_conf,
                    120,
                    COLOR_BLACK
                )
            end
        end

        -- draw lines around the element
        self:DrawLines(tmp_x, tmp_y, self.ply_ind_size, self.ply_ind_size, ply_color.a)
    end

    -- draw lines around the element
    if not self:InheritParentBorder() then
        self:DrawLines(self.pos.x, self.pos.y, self.size.w, self.size.h, self.basecolor.a)
    end
end

---
-- This hook is used to modify the color of the dot seen in the miniscoreboard.
-- @param Player ply The player whose dot color should be changed
-- @param Color col The originally intended color
-- @return nil|Color The new color for the dot
-- @hook
-- @realm client
function GM:TTT2ModifyMiniscoreboardColor(ply, col) end
