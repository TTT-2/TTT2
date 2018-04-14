
-- This table is used by the client to show items in the equipment menu, and by
-- the server to check if a certain role is allowed to buy a certain item.


-- If you have custom items you want to add, consider using a separate lua
-- script that uses table.insert to add an entry to this table. This method
-- means you won't have to add your code back in after every TTT update. Just
-- make sure the script is also run on the client.
--
-- For example:
--   table.insert(EquipmentItems[ROLES.DETECTIVE.index], { id = EQUIP_ARMOR, ... })
--
-- Note that for existing items you can just do:
--   table.insert(EquipmentItems[ROLES.DETECTIVE.index], GetEquipmentItem(ROLES.TRAITOR.index, EQUIP_ARMOR))


-- Special equipment bitflags. Every unique piece of equipment needs its own
-- id. 
--
-- Use the GenerateNewEquipmentID function (see below) to get a unique ID for
-- your equipment. This is guaranteed not to clash with other addons (as long
-- as they use the same safe method).
--
-- Details you shouldn't need:
-- The number should increase by a factor of two for every item (ie. ids
-- should be powers of two).
EQUIP_NONE     = 0
EQUIP_ARMOR    = 1
EQUIP_RADAR    = 2
EQUIP_DISGUISE = 4

EQUIP_MAX      = 4

-- Icon doesn't have to be in this dir, but all default ones are in here
local mat_dir = "vgui/ttt/"

-- Stick to around 35 characters per description line, and add a "\n" where you
-- want a new line to start.

EquipmentItems = nil

function SetupEquipment(first)
   if first then
      EquipmentItems = {}
   end

   for _, v in pairs(GetTeamRoles(TEAM_TRAITOR)) do
      if not EquipmentItems[v.index] then
         EquipmentItems[v.index] = {
             -- body armor
             {  id       = EQUIP_ARMOR,
                type     = "item_passive",
                material = mat_dir .. "icon_armor",
                name     = "item_armor",
                desc     = "item_armor_desc"
             },
             -- radar
             {  id       = EQUIP_RADAR,
                type     = "item_active",
                material = mat_dir .. "icon_radar",
                name     = "item_radar",
                desc     = "item_radar_desc"
             },
             -- disguiser
             {  id       = EQUIP_DISGUISE,
                type     = "item_active",
                material = mat_dir .. "icon_disguise",
                name     = "item_disg",
                desc     = "item_disg_desc"
             }
         }
      end
   end

   for _, v in pairs(GetShopRoles()) do
      if v.team ~= TEAM_TRAITOR and not EquipmentItems[v.index] then
         EquipmentItems[v.index] = {
             -- body armor
             {  id       = EQUIP_ARMOR,
                loadout  = true, -- default equipment for detectives
                type     = "item_passive",
                material = mat_dir .. "icon_armor",
                name     = "item_armor",
                desc     = "item_armor_desc"
             },
             -- radar
             {  id       = EQUIP_RADAR,
                type     = "item_active",
                material = mat_dir .. "icon_radar",
                name     = "item_radar",
                desc     = "item_radar_desc"
             }
          }
      end
   end
end

SetupEquipment(true)

hook.Add("TTT2_FinishedSync", "updateEquRol", function(first)
   SetupEquipment(false)
end)

-- Search if an item is in the equipment table of a given role, and return it if
-- it exists, else return nil.
function GetEquipmentItem(role, id)
   local tbl = EquipmentItems[role]
   
   if not tbl then return end

   for _, v in pairs(tbl) do
      if v and v.id == id then
         return v
      end
   end
end

 -- Utility function to register a new Equipment ID
function GenerateNewEquipmentID()
   EQUIP_MAX = EQUIP_MAX * 2
   
   return EQUIP_MAX
end
