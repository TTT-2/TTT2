---
-- This is the <code>thermalvision</code> library.
-- It offers the possibility of rendering entities giving them the typical thermal vision look
-- @author LeBroomer
-- @module thermalvision

local render = render
local table = table
local IsValid = IsValid
local cam = cam
local surface = surface
local hook = hook

if SERVER then
    AddCSLuaFile()

    return
end

thermalvision = {}

---@alias thermalvision_mode
---| `THERMALVISION_MODE_BOTH`
---| `THERMALVISION_MODE_NOTVISIBLE`
---| `THERMALVISION_MODE_VISIBLE`

THERMALVISION_MODE_BOTH = 0
THERMALVISION_MODE_NOTVISIBLE = 1
THERMALVISION_MODE_VISIBLE = 2

local bgColoring = false
local thermalvisionList = {}
local thermalvisionHookInstalled = false

local overlayColorWithBG = Color(0, 0, 50, 235)
local overlayColorWithoutBG = Color(0, 0, 0, 235)

local colorModifyBG = {
    ["$pp_colour_addr"] = 0,
    ["$pp_colour_addg"] = 0.0,
    ["$pp_colour_addb"] = 0.8,
    ["$pp_colour_brightness"] = 0.1,
    ["$pp_colour_contrast"] = 0.15,
    ["$pp_colour_colour"] = 0.0,
    ["$pp_colour_mulr"] = 0,
    ["$pp_colour_mulg"] = 0,
    ["$pp_colour_mulb"] = 1,
}

local colorModifyEnts = {
    ["$pp_colour_addr"] = 0.4,
    ["$pp_colour_addg"] = 0.2,
    ["$pp_colour_addb"] = 0.0,
    ["$pp_colour_brightness"] = 1.0,
    ["$pp_colour_contrast"] = 0.35,
    ["$pp_colour_colour"] = 30,
    ["$pp_colour_mulr"] = 0,
    ["$pp_colour_mulg"] = 0,
    ["$pp_colour_mulb"] = 0,
}
---
-- Hook that renders the entities with the thermalvision
-- @realm client
local function RenderHook()
    render.ClearStencil()
    render.SetStencilEnable(true)
    render.SetStencilWriteMask(255)
    render.SetStencilTestMask(255)
    render.SetStencilReferenceValue(1)

    --first render pass: draw all entities even when z test fails
    if #thermalvisionList > 0 then
        --draw stencil mask and let everything through
        render.SetStencilCompareFunction(STENCIL_ALWAYS)
        render.SetStencilZFailOperation(STENCIL_REPLACE)
        render.SetStencilPassOperation(STENCIL_REPLACE)
        render.SetStencilFailOperation(STENCIL_ZERO)

        --omit depth test but block writing to depth buffer
        render.SuppressEngineLighting(true)
        render.OverrideDepthEnable(true, false)

        cam.Start3D()
        cam.IgnoreZ(true)
        for i = 1, #thermalvisionList do
            local entry = thermalvisionList[i]
            local ent = entry.ent

            if not IsValid(ent) or entry.mode == THERMALVISION_MODE_VISIBLE then
                continue
            end

            ent:DrawModel()
        end
        cam.End3D()

        render.OverrideDepthEnable(false, false)
        render.SuppressEngineLighting(false)

        --screenspace effect on stenciled areas to highlight entities
        render.SetStencilCompareFunction(STENCIL_EQUAL)
        render.SetStencilZFailOperation(STENCIL_KEEP)
        render.SetStencilPassOperation(STENCIL_KEEP)
        render.SetStencilFailOperation(STENCIL_KEEP)

        DrawColorModify(colorModifyEnts)

        --weaken the effect behind walls
        cam.Start2D()
        surface.SetDrawColor(bgColoring and overlayColorWithBG or overlayColorWithoutBG)
        surface.DrawRect(0, 0, ScrW(), ScrH())
        cam.End2D()
    end

    --draw the blue colored background
    if bgColoring then
        render.SetStencilCompareFunction(STENCIL_NOTEQUAL)
        render.SetStencilZFailOperation(STENCIL_KEEP)
        render.SetStencilPassOperation(STENCIL_KEEP)
        render.SetStencilFailOperation(STENCIL_KEEP)

        DrawColorModify(colorModifyBG)
    end

    --second render pass: draw all parts of entities which are visible (z test succceeds)
    if #thermalvisionList > 0 then
        render.ClearStencil()

        --draw stencil mask only for visible parts
        render.SetStencilCompareFunction(STENCIL_ALWAYS)
        render.SetStencilZFailOperation(STENCIL_KEEP)
        render.SetStencilPassOperation(STENCIL_REPLACE)
        render.SetStencilFailOperation(STENCIL_ZERO)

        --render all entities but keep depth testing
        render.SuppressEngineLighting(true)

        for i = 1, #thermalvisionList do
            local entry = thermalvisionList[i]
            local ent = entry.ent

            if not IsValid(ent) or (ent:IsPlayer() and not ent:IsTerror()) then
                continue
            end

            --overwrite with the original model and prevent effect appliance afterwards if the effect should be only applied for non visible things
            if entry.mode == THERMALVISION_MODE_NOTVISIBLE then
                render.SetStencilWriteMask(0)
                render.SuppressEngineLighting(false)
            end

            ent:DrawModel()

            render.SetStencilWriteMask(255)
            render.SuppressEngineLighting(true)
        end

        render.SuppressEngineLighting(false)

        --screenspace effect on stenciled areas again
        render.SetStencilCompareFunction(STENCIL_EQUAL)
        render.SetStencilZFailOperation(STENCIL_KEEP)
        render.SetStencilPassOperation(STENCIL_KEEP)
        render.SetStencilFailOperation(STENCIL_KEEP)

        DrawColorModify(colorModifyEnts)
    end

    render.SetStencilEnable(false)
end

---
-- Hook adding
-- @realm client
local function AddThermalvisionHook()
    if thermalvisionHookInstalled then
        return
    end

    hook.Add("PostDrawTranslucentRenderables", "RenderThermalvision", RenderHook)

    thermalvisionHookInstalled = true
end

---
-- Hook removing
-- @realm client
local function RemoveThermalvisionHook()
    hook.Remove("PostDrawTranslucentRenderables", "RenderThermalvision")

    thermalvisionHookInstalled = false
end

---
-- Clearing the cached @{Entity} list
-- @realm client
function thermalvision.Clear()
    thermalvisionList = {}

    RemoveThermalvisionHook()
end

---
-- internal entity removing
-- @realm client
local function RemoveInternal(ents)
    local thermalvisionListSize = #thermalvisionList
    local entsSize = #ents

    if thermalvisionListSize == 0 or entsSize == 0 then
        return
    end

    for i = 1, thermalvisionListSize do
        for j = 1, entsSize do
            if thermalvisionList[i].ent ~= ents[j] then
                continue
            end

            --for now only setting it to nil
            thermalvisionList[i] = nil

            break
        end
    end

    --cleanup table by
    table.RemoveEmptyEntries(thermalvisionList, thermalvisionListSize)

    thermalvisionList = {}
end

---
-- Removes entities from the @{Entity} list
-- @param table ents list of entities that should get removed
-- @realm client
function thermalvision.Remove(ents)
    ents = istable(ents) and ents or { ents }

    RemoveInternal(ents)

    if table.IsEmpty(thermalvisionList) and not bgColoring then
        RemoveThermalvisionHook()
    end
end

---
-- Adds entities into the @{Entity} list that should be rendered with thermalvision
-- @param table ents list of @{Entity} that should be added
-- @param[default=THERMALVISION_MODE_BOTH] thermalvision_mode mode when should the entity be rendererd
-- @realm client
function thermalvision.Add(ents, mode)
    ents = istable(ents) and ents or { ents }

    local thermalvisionListSize = #thermalvisionList
    local entsSize = #ents

    if entsSize == 0 then
        return
    end

    mode = mode or THERMALVISION_MODE_BOTH

    for i = 1, entsSize do
        thermalvisionList[thermalvisionListSize + i] = { ent = ents[i], mode = mode }
    end

    -- add the hook if there is something to render
    AddThermalvisionHook()
end

---
-- Enables/disables rendering the background in the thermalvision typical blue tone
-- @param boolean enabled whether or not the background should get colored
-- @realm client
function thermalvision.SetBackgroundColoring(enabled)
    bgColoring = enabled
end

---
-- Sets entities of the @{Entity} list to the specified mode
-- @param table ents list of @{Entity} that should be set
-- @param thermalvision_mode mode when should the entity be rendered
-- @realm client
function thermalvision.Set(ents, mode)
    ents = istable(ents) and ents or { ents }

    local thermalvisionListSize = #thermalvisionList
    local entsSize = #ents

    if entsSize == 0 then
        return
    end

    -- check if an entity is already inserted and remove it
    RemoveInternal(ents)

    for i = 1, entsSize do
        thermalvisionList[thermalvisionListSize + i] = { ent = ents[i], mode = mode }
    end

    -- add the hook if there is something to render
    AddThermalvisionHook()
end
