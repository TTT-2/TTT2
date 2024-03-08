---
-- @class ITEM

ITEM.PrintName = "Scripted Item" -- displayed @{ITEM} name (Shown on HUD), language supported

ITEM.Author = "" -- author
ITEM.Contact = "" -- contact to the author
ITEM.Purpose = "" -- purpose of this @{ITEM}
ITEM.Instructions = "" -- some Instructions for this @{ITEM}

-- If CanBuy is a table that contains ROLE_TRAITOR and/or ROLE_DETECTIVE, those
-- players are allowed to purchase it and it will appear in their Equipment Menu
-- for that purpose. If CanBuy is nil this @{ITEM} cannot be bought.
--   Example: ITEM.CanBuy = { ROLE_TRAITOR }
-- (just setting to nil here to document its existence, don't make this buyable)
ITEM.CanBuy = nil -- this @{table} contains a list of subrole ids (@param number) which are able to access this @{ITEM} in the shop

-- per default items can be bought only once. However this variable can be set to false to allow multibuy
ITEM.limited = true

ITEM.Category = "TTT" -- the @{ITEM} Category

if CLIENT then
    -- If this is a buyable @{ITEM} (ie. CanBuy is not nil) EquipMenuData must be
    -- a table containing some information to show in the Equipment Menu. See
    -- default equipment items for real-world examples.
    ITEM.EquipMenuData = nil

    -- Example data:
    -- ITEM.EquipMenuData = {
    --
    --   Type tells players if it's a weapon or @{ITEM}
    --     type = "Weapon",
    --
    --   Desc is the description in the menu. Needs manual linebreaks (via \n).
    --     desc = "Text."
    -- }

    -- A short description for the sidebar
    ITEM.sidebarDescription = nil

    -- This sets the icon shown for the @{ITEM} in the DNA sampler, search window,
    -- equipment menu (if buyable), etc.
    ITEM.material = "vgui/ttt/icon_nades" -- most generic icon I guess

    -- set to false if item should not be shown in body search
    ITEM.populateSearch = true

    -- You can make your own @{ITEM} icon using the template in:
    --   /garrysmod/gamemodes/terrortown/template/

    -- Open one of TTT's icons with VTFEdit to see what kind of settings to use
    -- when exporting to VTF. Once you have a VTF and VMT, you can
    -- resource.AddFile("materials/vgui/...") them here. GIVE YOUR ICON A UNIQUE
    -- FILENAME, or it WILL be overwritten by other servers! Gmod does not check
    -- if the files are different, it only looks at the name. I recommend you
    -- create your own directory so that this does not happen,
    -- eg. /materials/vgui/ttt/mycoolserver/mygun.vmt

    ---
    -- Draw some information in a small box next to the icon in the hud if a @{Player} is owning this @{ITEM}
    -- @hook
    -- @realm client
    function ITEM:DrawInfo() end

    ---
    -- This hook can be used by item addons to populate the equipment settings page
    -- with custom convars. The parent is the submenu, where a new form has to
    -- be added.
    -- @param DPanel parent The parent panel which is the submenu
    -- @hook
    -- @realm client
    function ITEM:AddToSettingsMenu(parent) end
end

---
-- Called just before entity is deleted. This is used to reset data you set before
-- @param Player ply
-- @hook
-- @realm shared
function ITEM:Reset(ply) end

---
-- A player or NPC has picked the @{ITEM} up
-- @param Player ply
-- @hook
-- @realm shared
function ITEM:Equip(ply) end

---
-- A player or NPC has bought the @{ITEM}
-- @param Player ply
-- @hook
-- @realm shared
function ITEM:Bought(ply) end

---
-- Called when the @{ITEM} is created.
-- @realm shared
function ITEM:Initialize() end

---
-- Checks whether this items is a valid equipment item.
-- @note Useable, but do not modify or overwrite this!
-- @return boolean Return whether this @{ITEM} is an equipment
-- @realm shared
function ITEM:IsEquipment()
    return WEPS.IsEquipment(self)
end

---
-- Returns the classname of an item. This is often the name of the Lua file or folder containing the files for the item.
-- @return string The item's class name
-- @realm shared
function ITEM:GetClass()
    return self.ClassName
end

---
-- Checks if the item is valid. Returns true if valid.
-- @return boolean Returns true if item is valid
-- @realm shared
function ITEM:IsValid()
    -- this is probably always valid if there is no custom weird stuff done
    -- to the item's class
    if self:GetClass() and self:GetClass() ~= "" then
        return true
    end

    return false
end
