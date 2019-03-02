-- Variables that are used on both client and server

ITEM.PrintName = "Scripted Item" -- 'Nice' Item name (Shown on HUD)
ITEM.Author = ""
ITEM.Contact = ""
ITEM.Purpose = ""
ITEM.Instructions = ""

-- If CanBuy is a table that contains ROLE_TRAITOR and/or ROLE_DETECTIVE, those
-- players are allowed to purchase it and it will appear in their Equipment Menu
-- for that purpose. If CanBuy is nil this item cannot be bought.
--   Example: ITEM.CanBuy = { ROLE_TRAITOR }
-- (just setting to nil here to document its existence, don't make this buyable)
ITEM.CanBuy = nil

ITEM.Category = "TTT"

if CLIENT then

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
	ITEM.material = "vgui/ttt/icon_nades" -- most generic icon I guess

	-- You can make your own item icon using the template in:
	--   /garrysmod/gamemodes/terrortown/template/

	-- Open one of TTT's icons with VTFEdit to see what kind of settings to use
	-- when exporting to VTF. Once you have a VTF and VMT, you can
	-- resource.AddFile("materials/vgui/...") them here. GIVE YOUR ICON A UNIQUE
	-- FILENAME, or it WILL be overwritten by other servers! Gmod does not check
	-- if the files are different, it only looks at the name. I recommend you
	-- create your own directory so that this does not happen,
	-- eg. /materials/vgui/ttt/mycoolserver/mygun.vmt

	--[[---------------------------------------------------------
		Name: DrawInfo
		Desc: Draw some information in a small box next to the icon
	-----------------------------------------------------------]]
	function ITEM:DrawInfo()

	end
end

--[[---------------------------------------------------------
	Name: Reset
	Desc: Called just before entity is deleted
-----------------------------------------------------------]]
function ITEM:Reset(ply)

end

--[[---------------------------------------------------------
	Name: Equip
	Desc: A player or NPC has picked the item up
-----------------------------------------------------------]]
function ITEM:Equip(ply)

end

--[[---------------------------------------------------------
	Name: Bought
	Desc: A player or NPC has bought the item
-----------------------------------------------------------]]
function ITEM:Bought(ply)

end

-- useable, but do not modify this!
function ITEM:IsEquipment()
	return WEPS.IsEquipment(self)
end
