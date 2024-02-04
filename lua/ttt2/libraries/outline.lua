---
-- @author https://github.com/ShadowBonnieRUS
-- @module outline

local render = render
local cam = cam
local surface = surface
local hook = hook
local Material = Material

if SERVER then
    AddCSLuaFile()

    return
end

outline = {}

OUTLINE_MODE_BOTH = 0
OUTLINE_MODE_NOTVISIBLE = 1
OUTLINE_MODE_VISIBLE = 2

local List, ListSize = {}, 0
local RenderEnt = NULL

local outlineMatSettings = {
    ["$ignorez"] = 1,
    ["$alphatest"] = 1,
}

local copyMat = Material("pp/copy")
local outlineMat = CreateMaterial("OutlineMat", "UnlitGeneric", outlineMatSettings)
local storeTexture = render.GetScreenEffectTexture(0)
local drawTexture = render.GetScreenEffectTexture(1)

local ENTS = 1
local COLOR = 2
local MODE = 3

---
-- @param table ents List of @{Entity}
-- @param Color color
-- @param number mode [OUTLINE_MODE_BOTH, OUTLINE_MODE_NOTVISIBLE, OUTLINE_MODE_VISIBLE]
-- @realm client
function outline.Add(ents, color, mode)
    -- Maximum 255 reference values
    if ListSize >= 255 then
        return
    end

    -- Support for passing Entity as first argument
    if not istable(ents) then
        ents = { ents }
    end

    -- Do not pass empty tables
    if ents[1] == nil then
        return
    end

    local t = {
        [ENTS] = ents,
        [COLOR] = color,
        [MODE] = mode or OUTLINE_MODE_BOTH,
    }

    ListSize = ListSize + 1
    List[ListSize] = t
end

---
-- @return Entity The last rendered @{Entity}
-- @realm client
function outline.RenderedEntity()
    return RenderEnt
end

local function Render()
    local client = LocalPlayer()
    local IsLineOfSightClear = client.IsLineOfSightClear
    local scene = render.GetRenderTarget()

    render.CopyRenderTargetToTexture(storeTexture)

    local w = ScrW()
    local h = ScrH()

    render.Clear(0, 0, 0, 0, true, true)

    -- start stencil modification
    render.SetStencilEnable(true)

    cam.IgnoreZ(true)

    render.SuppressEngineLighting(true)

    render.SetStencilWriteMask(0xFF)
    render.SetStencilTestMask(0xFF)

    render.SetStencilCompareFunction(STENCIL_ALWAYS)
    render.SetStencilFailOperation(STENCIL_KEEP)
    render.SetStencilZFailOperation(STENCIL_REPLACE)
    render.SetStencilPassOperation(STENCIL_REPLACE)

    -- start cam modification
    cam.Start3D()

    for i = 1, ListSize do
        local v = List[i]
        local mode = v[MODE]
        local ents = v[ENTS]

        render.SetStencilReferenceValue(i)

        for j = 1, #ents do
            local ent = ents[j]

            if
                not IsValid(ent)
                or mode == OUTLINE_MODE_NOTVISIBLE and IsLineOfSightClear(client, ent)
                or mode == OUTLINE_MODE_VISIBLE and not IsLineOfSightClear(client, ent)
            then
                continue
            end

            RenderEnt = ent

            ent:DrawModel()
        end
    end

    RenderEnt = NULL

    cam.End3D()
    -- end cam modification

    render.SetStencilCompareFunction(STENCIL_EQUAL)

    -- start cam modification
    cam.Start2D()

    for i = 1, ListSize do
        render.SetStencilReferenceValue(i)

        surface.SetDrawColor(List[i][COLOR])
        surface.DrawRect(0, 0, w, h)
    end

    cam.End2D()
    -- end cam modification

    render.SuppressEngineLighting(false)

    cam.IgnoreZ(false)

    render.SetStencilEnable(false)
    -- end stencil modification

    render.CopyRenderTargetToTexture(drawTexture)

    render.SetRenderTarget(scene)

    copyMat:SetTexture("$basetexture", storeTexture)

    render.SetMaterial(copyMat)
    render.DrawScreenQuad()

    -- start stencil modification
    render.SetStencilEnable(true)

    render.SetStencilReferenceValue(0)
    render.SetStencilCompareFunction(STENCIL_EQUAL)

    outlineMat:SetTexture("$basetexture", drawTexture)

    render.SetMaterial(outlineMat)

    render.DrawScreenQuadEx(-1, -1, w, h)
    render.DrawScreenQuadEx(-1, 0, w, h)
    render.DrawScreenQuadEx(-1, 1, w, h)
    render.DrawScreenQuadEx(0, -1, w, h)
    render.DrawScreenQuadEx(0, 1, w, h)
    render.DrawScreenQuadEx(1, 1, w, h)
    render.DrawScreenQuadEx(1, 0, w, h)
    render.DrawScreenQuadEx(1, 1, w, h)

    render.SetStencilEnable(false)
    -- end stencil modification
end

hook.Add("PostDrawEffects", "RenderOutlines", function()
    ---
    -- @realm client
    -- stylua: ignore
    hook.Run("PreDrawOutlines")

    if ListSize == 0 then
        return
    end

    Render()

    List, ListSize = {}, 0
end)

---
-- A rendering hook that is run in @{GM:PostDrawEffects} before the outlines are rendered.
-- @2D
-- @hook
-- @realm client
function GM:PreDrawOutlines() end
