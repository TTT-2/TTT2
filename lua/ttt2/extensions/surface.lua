---
-- surface extension
-- @author Mineotopia, LeBroomer

AddCSLuaFile()

if SERVER then return end

---
-- Registers an advanced text (scalable)
-- @important The original font should be always created. See @{surface.CreateFont}
-- @param string fontName
-- @param table fontData
-- @realm client
function surface.CreateAdvancedFont(fontName, fontData)
	fonts.AddFont(fontName, fontData.size, fontData)
end
