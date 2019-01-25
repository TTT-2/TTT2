include("shared.lua")

-- If this is a buyable item (ie. CanBuy is not nil) EquipMenuData must be
-- a table containing some information to show in the Equipment Menu. See
-- default equipment items for real-world examples.
ITEM.EquipMenuData = nil

-- Example data:
-- ITEM.EquipMenuData = {
--
---- Type tells players if it's a weapon or item
--     type = "Weapon",
--
---- Desc is the description in the menu. Needs manual linebreaks (via \n).
--     desc = "Text."
-- }

-- This sets the icon shown for the item in the DNA sampler, search window,
-- equipment menu (if buyable), etc.
ITEM.Icon = "vgui/ttt/icon_nades" -- most generic icon I guess

-- You can make your own item icon using the template in:
--   /garrysmod/gamemodes/terrortown/template/

-- Open one of TTT's icons with VTFEdit to see what kind of settings to use
-- when exporting to VTF. Once you have a VTF and VMT, you can
-- resource.AddFile("materials/vgui/...") them here. GIVE YOUR ICON A UNIQUE
-- FILENAME, or it WILL be overwritten by other servers! Gmod does not check
-- if the files are different, it only looks at the name. I recommend you
-- create your own directory so that this does not happen,
-- eg. /materials/vgui/ttt/mycoolserver/mygun.vmt
