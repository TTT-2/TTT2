---
-- render extension
-- @author WardenPotato
-- @module render

if SERVER then
    AddCSLuaFile()

    return
end

---
-- Completely resets stencils.
-- This is useful for things near @{surface.DrawPoly} when `gmod_mcore_test` is 1,
-- because stencils seem to act unstable across different architectures.
-- @realm client
function render.FullReset()
    render.SetStencilWriteMask(0xFF)
    render.SetStencilTestMask(0xFF)
    render.SetStencilReferenceValue(0)
    render.SetStencilCompareFunction(STENCIL_ALWAYS)
    render.SetStencilPassOperation(STENCIL_KEEP)
    render.SetStencilFailOperation(STENCIL_KEEP)
    render.SetStencilZFailOperation(STENCIL_KEEP)
    render.ClearStencil()
end
