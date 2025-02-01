---
-- @author https://github.com/WardenPotato and https://github.com/ShadowBonnieRUS
-- @module outline

local istable = istable
local render = render
local Material = Material
local CreateMaterial = CreateMaterial
local hook = hook
local cam = cam
local ScrW = ScrW
local ScrH = ScrH
local IsValid = IsValid
local surface = surface

if SERVER then
    AddCSLuaFile()

    return
end

outline = {}

OUTLINE_MODE_BOTH = 0
OUTLINE_MODE_NOTVISIBLE = 1
OUTLINE_MODE_VISIBLE = 2

OUTLINE_RENDERTYPE_BEFORE_VM = 0 -- Render before drawing the view model
OUTLINE_RENDERTYPE_BEFORE_EF = 1 -- Render before drawing all effects (after drawing the viewmodel)
OUTLINE_RENDERTYPE_AFTER_EF = 2 -- Render after drawing all effects

local Lists = {
    [OUTLINE_RENDERTYPE_BEFORE_VM] = {},
    [OUTLINE_RENDERTYPE_BEFORE_EF] = {},
    [OUTLINE_RENDERTYPE_AFTER_EF] = {},
}

local ListsSize = {
    [OUTLINE_RENDERTYPE_BEFORE_VM] = {},
    [OUTLINE_RENDERTYPE_BEFORE_EF] = {},
    [OUTLINE_RENDERTYPE_AFTER_EF] = {},
}
local RenderEnt = NULL
local RenderType = OUTLINE_RENDERTYPE_AFTER_EF
local OutlineThickness = 1
local texture_store = render.GetScreenEffectTexture(0)
local texture_draw = render.GetScreenEffectTexture(1)

local outline_mat_settings = {
    ["$basetexture"] = texture_draw:GetName(),
    ["$ignorez"] = 1,
    ["$alphatest"] = 1,
    ["$smooth"] = 0,
}
local outline_mat = CreateMaterial("ttt2_outline", "UnlitGeneric", outline_mat_settings)

local copy_mat = Material("pp/copy")

local ENTS = 1
local COLOR = 2
local MODE = 3

local function SetRenderType(render_type)
    if
        render_type ~= OUTLINE_RENDERTYPE_BEFORE_VM
        and render_type ~= OUTLINE_RENDERTYPE_BEFORE_EF
        and render_type ~= OUTLINE_RENDERTYPE_AFTER_EF
    then
        return
    end

    RenderType = render_type

    return true
end

local function GetRenderType()
    return RenderType
end

local function GetOutlineThickness()
    return OutlineThickness
end

local function SetOutlineThickness(thickness)
    if thickness < 1 then
        return
    end

    OutlineThickness = thickness

    return true
end

local function GetCurrentLists()
    return Lists[GetRenderType()]
end

local function GetCurrentListsSize()
    return ListsSize[GetRenderType()]
end

local function GetCurrentList()
    return Lists[GetRenderType()][GetOutlineThickness()]
end

local function GetCurrentListSize()
    return ListsSize[GetRenderType()][GetOutlineThickness()]
end

local function ResetCurrentLists()
    Lists[GetRenderType()] = {}
end

local function ResetCurrentListsSize()
    ListsSize[GetRenderType()] = {}
end

local function SetCurrentListSize(size)
    ListsSize[GetRenderType()][GetOutlineThickness()] = size
end

local function InitializeCurrentListIfNeeded()
    local render_type, outline_thickness = GetRenderType(), GetOutlineThickness()

    if not Lists[render_type] then
        Lists[render_type] = {}
    end

    if not ListsSize[render_type] then
        ListsSize[render_type] = {}
    end

    if not Lists[render_type][outline_thickness] then
        Lists[render_type][outline_thickness] = {}
    end

    if not ListsSize[render_type][outline_thickness] then
        ListsSize[render_type][outline_thickness] = 0
    end
end

---
-- Adds an outline to a given list of entities.
-- @param table ents List of @{Entity}
-- @param Color color The color of the added outline
-- @param number mode [OUTLINE_MODE_BOTH, OUTLINE_MODE_NOTVISIBLE, OUTLINE_MODE_VISIBLE]
-- @param number render_type [OUTLINE_RENDERTYPE_BEFORE_VM, OUTLINE_RENDERTYPE_BEFORE_EF, OUTLINE_RENDERTYPE_AFTER_EF]
-- @param number outline_thickness The thickness of the added outline in pixels
-- @realm client
function outline.Add(ents, color, mode, render_type, outline_thickness)
    -- Make the default behaviour comply with older revisions
    if not render_type then
        render_type = OUTLINE_RENDERTYPE_AFTER_EF
    end

    if not outline_thickness then
        outline_thickness = 1
    end

    -- Check for a validity
    if not SetRenderType(render_type) then
        return
    end

    if not SetOutlineThickness(outline_thickness) then
        return
    end

    -- Create list if it doesnt exist
    InitializeCurrentListIfNeeded()

    -- Get List and ListSize for this render type and outline thickness
    local List, ListSize = GetCurrentList(), GetCurrentListSize()

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
    SetCurrentListSize(ListSize)
    List[ListSize] = t
end

---
-- @return Entity The last rendered @{Entity}
-- @realm client
function outline.RenderedEntity()
    return RenderEnt
end

local function RenderModels(render_ents)
    for i = 1, #render_ents do
        local ent = render_ents[i]

        if IsValid(ent) then
            RenderEnt = ent
            ent:DrawModel(STUDIO_RENDER + STUDIO_NOSHADOWS)
        end
    end
end

local materialDebugWhite = Material("models/debug/debugwhite")
local cvMaterialAntialias = GetConVar("mat_antialias")
local function Render()
    local scene = render.GetRenderTarget()

    -- Only draw inside of the actual main screen RT, prevents breaking addons and other rendering
    if scene ~= nil then
        return
    end

    -- Copy the current RT to another RT so we can restore this later on
    -- the way the drawing of this library works is as follows:
    -- 1. Store Current Screen in the "store" rendertarget.
    -- 2. Render all the entities that need to be outlined to just the stencil
    -- 3. Clear the main rendertarget to be fully transparent
    -- 4. Loop through all stencil values and draw the appropiate color, essentially each value in the stencil buffer (0-255) represent a list index,
    --    which contains the entities to render and their color, using this info we then draw to the color buffer for that set of entities.
    -- 5. Copy the main render target which right now consists of solidly colored versions of all the entities we wanted to be outlined into the "draw" rendertarget
    -- 6. Put the contents of the "store" rendertarget back onto our main rendertarget
    -- 7. Configure the stencil to only allow drawing on the pixels that our previous rendering didnt touch, right now thats the solidly colored entities, what this does
    --    is essentially create a mask that only allows drawing right outside of those entities but not over them.
    -- 8. Now draw what we stored in the "draw" rendertarget back onto the main render target 8 times using the stencil we configured in step 7
    --    but the important part is that we offset it to each side and corner of a square, essentially if you took a keyboard numpad the entity would be at
    --    the key 5 while 1 2 3 4 6 7 8 9 would be offset positions we draw back the solidly colored entity, this is what creates our final outline.
    --    because of this approach where a solid version of the entity is just offset by a certain amount of pixels it becomes less pretty and accurate the thicker you go.
    render.CopyRenderTargetToTexture(texture_store)

    local w, h = ScrW(), ScrH()
    local List, ListSize = GetCurrentList(), GetCurrentListSize()
    local reference = 0

    -- Make sure we got a 3D context for our model rendering
    cam.Start3D()
    -- Clear out the stencil
    render.ClearStencil()

    -- Start stencil modification
    render.SetStencilEnable(true)
    -- Render using a cheap material
    render.MaterialOverride(materialDebugWhite)
    -- We dont need lighting
    render.SuppressEngineLighting(true)
    -- We dont need color
    render.OverrideColorWriteEnable(true, false)
    -- We dont need depth
    render.OverrideDepthEnable(true, false)

    -- reset everything to known good values
    render.SetStencilWriteMask(0xFF)
    render.SetStencilTestMask(0xFF)
    render.SetStencilReferenceValue(0)
    render.SetStencilCompareFunction(STENCIL_GREATER)
    render.SetStencilPassOperation(STENCIL_KEEP)
    render.SetStencilFailOperation(STENCIL_KEEP)
    render.SetStencilZFailOperation(STENCIL_KEEP)

    -- Render the models onto the stencil
    render.SetBlend(1)
    for i = 1, ListSize do
        -- Determine our reference value based on the list index
        reference = 0xFF - (i - 1)

        -- Get the data we need for this list index
        local data = List[i]
        local mode = data[MODE]
        local render_ents = data[ENTS]

        -- Set our reference value
        render.SetStencilReferenceValue(reference)

        if mode == OUTLINE_MODE_BOTH or mode == OUTLINE_MODE_VISIBLE then
            -- Setup the stencil for hidden or parts or the entire thing
            render.SetStencilCompareFunction(STENCIL_GREATER)
            render.SetStencilZFailOperation(
                mode == OUTLINE_MODE_BOTH and STENCIL_REPLACE or STENCIL_KEEP
            )
            render.SetStencilFailOperation(STENCIL_KEEP)
            render.SetStencilPassOperation(STENCIL_REPLACE)

            RenderModels(render_ents)
        elseif mode == OUTLINE_MODE_NOTVISIBLE then
            -- Setup the stencil for 2-pass rendering where we first determine what is hidden and then what is shown to prevent self z-fail
            render.SetStencilCompareFunction(STENCIL_GREATER)
            render.SetStencilZFailOperation(STENCIL_REPLACE)
            render.SetStencilFailOperation(STENCIL_KEEP)
            render.SetStencilPassOperation(STENCIL_KEEP)

            RenderModels(render_ents)

            -- Setup the stencil for the second pass
            render.SetStencilCompareFunction(STENCIL_EQUAL)
            render.SetStencilZFailOperation(STENCIL_KEEP)
            render.SetStencilFailOperation(STENCIL_KEEP)
            render.SetStencilPassOperation(STENCIL_ZERO)

            RenderModels(render_ents)
        end
    end

    -- Undo color override
    render.OverrideColorWriteEnable(false)

    -- We are not rendering anything specific anymore
    RenderEnt = NULL

    -- Setup the stencil to override the color of values equal to reference
    -- this makes sure we can only touch pixels that the previous rendering operations have touched
    render.SetStencilCompareFunction(STENCIL_EQUAL)
    render.SetStencilZFailOperation(STENCIL_KEEP)
    render.SetStencilFailOperation(STENCIL_KEEP)
    render.SetStencilPassOperation(STENCIL_KEEP)

    -- Make the screen transparent, on opaque RT's this will make it black instead, all the main game RT's in source are RGB888 wich is opaque,
    -- but the actual RT inside of D3D has alpha support, its merely the ones that source uses which are RGB888, those are not the actual RT,
    -- because its just something the result is copied over to during the rendering process.
    -- The halo library does not suffer from this given it uses additive/subtractive rendering where you can use a black/white background as a psuedo transparent layer,
    -- but such an approach is only desirable for a brightening glow.
    render.Clear(0, 0, 0, 0, false, false)

    -- Render the color onto the RT using our stencil values
    for i = 1, ListSize do
        reference = 0xFF - (i - 1)

        render.SetStencilReferenceValue(reference)
        local col = List[i][COLOR]

        -- While clearing the buffer would be proper here for some reason the base color of the RT bleeds through which makes me believe this
        -- somehow talks to the gmod RT and not what we got in D3D, its really hard to say but using surface works fine
        -- otherwise we could have done: render.ClearBuffersObeyStencil(col.r, col.g, col.b, col.a, false)
        cam.Start2D()
        surface.SetDrawColor(col)
        surface.DrawRect(0, 0, w, h)
        cam.End2D()
    end

    --Undo the rest of the overrides
    render.SuppressEngineLighting(false)
    render.MaterialOverride(nil)
    render.OverrideDepthEnable(false)
    -- End stencil modification
    render.SetStencilEnable(false)
    cam.End3D()

    -- Copy solidly colored result to draw texture
    render.CopyRenderTargetToTexture(texture_draw)

    -- Set the correct basetexture
    copy_mat:SetTexture("$basetexture", texture_store)

    -- Prevent leaking through anything to pp/copy
    copy_mat:SetString("$color", "1 1 1")
    copy_mat:SetString("$alpha", "1")

    -- Draw the old screen back onto our current
    render.SetMaterial(copy_mat)
    render.DrawScreenQuad()

    -- Draw the outlines
    render.SetStencilEnable(true)
    -- Setup the stencil to only draw pixels when the reference is 0,
    -- this basically means that we can only draw outside of outlined objects
    render.SetStencilReferenceValue(0)
    render.SetStencilCompareFunction(STENCIL_EQUAL)

    outline_mat:SetTexture("$basetexture", texture_draw)

    -- Set our outline material
    render.SetMaterial(outline_mat)

    -- When antiliasing is on we run into the problem of the transparency looking very off
    -- when its only 1px thick, so if AA is on we add 1px to compensate.
    -- This is done in all cases to still differentiate between 1px and 2px outlines
    local outline_thickness = OutlineThickness
    if cvMaterialAntialias:GetInt() ~= 0 then
        outline_thickness = outline_thickness + 1
    end

    -- Draw each corner/side of the outline.
    -- We use the Ex version because the non Ex has some alignment issues.
    render.DrawScreenQuadEx(-outline_thickness, -outline_thickness, w, h)
    render.DrawScreenQuadEx(-outline_thickness, 0, w, h)
    render.DrawScreenQuadEx(-outline_thickness, outline_thickness, w, h)
    render.DrawScreenQuadEx(0, -outline_thickness, w, h)
    render.DrawScreenQuadEx(0, outline_thickness, w, h)
    render.DrawScreenQuadEx(outline_thickness, -outline_thickness, w, h)
    render.DrawScreenQuadEx(outline_thickness, 0, w, h)
    render.DrawScreenQuadEx(outline_thickness, outline_thickness, w, h)
    render.SetStencilEnable(false)
end

local function RenderOutlines()
    -- @realm client
    hook.Run("PreDrawOutlines", GetRenderType())

    local listSizes = GetCurrentListsSize()
    for outlineThickness, renderEnts in pairs(GetCurrentLists()) do
        if not listSizes[outlineThickness] or listSizes[outlineThickness] == 0 then
            continue
        end
        SetOutlineThickness(outlineThickness)
        Render()
    end

    ResetCurrentLists()
    ResetCurrentListsSize()
end

hook.Add("PreDrawViewModels", "RenderOutlines", function()
    SetRenderType(OUTLINE_RENDERTYPE_BEFORE_VM)
    RenderOutlines()
end)

hook.Add("PreDrawEffects", "RenderOutlines", function()
    SetRenderType(OUTLINE_RENDERTYPE_BEFORE_EF)
    RenderOutlines()
end)

hook.Add("PostDrawEffects", "RenderOutlines", function()
    SetRenderType(OUTLINE_RENDERTYPE_AFTER_EF)
    RenderOutlines()
end)

---
-- A rendering hook that is run in @{GM:PostDrawEffects}, @{GM:PreDrawEffects} and @{GM:PreDrawViewModels} before the outlines are rendered.
-- @param number render_type [OUTLINE_RENDERTYPE_BEFORE_VM, OUTLINE_RENDERTYPE_BEFORE_EF, OUTLINE_RENDERTYPE_AFTER_EF]
-- @2D
-- @hook
-- @realm client
function GM:PreDrawOutlines(render_type) end
