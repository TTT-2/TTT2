---
-- surface extension
-- @author Mineotopia, LeBroomer
-- @module surface

if SERVER then
	AddCSLuaFile()

	return
end

---
-- Registers an advanced text (scalable)
-- @important The original font should be always created. See @{surface.CreateFont}
-- @param string fontName
-- @param table fontData
-- @realm client
function surface.CreateAdvancedFont(fontName, fontData)
	fonts.AddFont(fontName, fontData.size, fontData)
end


function render.FullReset()
	render.SetStencilWriteMask( 0xFF )
	render.SetStencilTestMask( 0xFF )
	render.SetStencilReferenceValue( 0 )
	render.SetStencilCompareFunction( STENCIL_ALWAYS )
	render.SetStencilPassOperation( STENCIL_KEEP )
	render.SetStencilFailOperation( STENCIL_KEEP )
	render.SetStencilZFailOperation( STENCIL_KEEP )
	render.ClearStencil()
end

---
-- A function that takes a table with triangles and draws them to the screen.
-- @note The draw color has to be set beforehand
-- @param table tbl A table with triangles
-- @realm client
function surface.DrawPolyTable(tbl)
	for i = 1, #tbl do
		render.FullReset()

		surface.DrawPoly(tbl[i])
	end
end
