
-- This table is used by the client to show items in the equipment menu, and by
-- the server to check if a certain role is allowed to buy a certain item.


-- If you have custom items you want to add, consider using a separate lua
-- script that uses table.insert to add an entry to this table. This method
-- means you won't have to add your code back in after every TTT update. Just
-- make sure the script is also run on the client.
--
-- For example:
--	table.insert(EquipmentItems[ROLES.DETECTIVE.index], { id = EQUIP_ARMOR, ... })
--
-- Note that for existing items you can just do:
--	table.insert(EquipmentItems[ROLES.DETECTIVE.index], GetEquipmentItem(ROLES.TRAITOR.index, EQUIP_ARMOR))


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
EQUIP_NONE = 0
EQUIP_ARMOR	= 1
EQUIP_RADAR	= 2
EQUIP_DISGUISE = 4

EQUIP_MAX = 4

-- Icon doesn't have to be in this dir, but all default ones are in here
local mat_dir = "vgui/ttt/"

-- Stick to around 35 characters per description line, and add a "\n" where you
-- want a new line to start.

EquipmentItems = {}
SYNC_EQUIP = {}

function SetupEquipment()
	for _, v in pairs(GetTeamRoles(TEAM_TRAITOR)) do
		if not EquipmentItems[v.index] then
			EquipmentItems[v.index] = {
				-- body armor
				{	
					id		 = EQUIP_ARMOR,
					type	 = "item_passive",
					material = mat_dir .. "icon_armor",
					name	 = "item_armor",
					desc	 = "item_armor_desc"
				},
				-- radar
				{	
					id		 = EQUIP_RADAR,
					type	 = "item_active",
					material = mat_dir .. "icon_radar",
					name	 = "item_radar",
					desc	 = "item_radar_desc"
				},
				-- disguiser
				{	
					id		 = EQUIP_DISGUISE,
					type	 = "item_active",
					material = mat_dir .. "icon_disguise",
					name	 = "item_disg",
					desc	 = "item_disg_desc"
				}
			}
		end
	end

	for _, v in pairs(ROLES) do
		if v.team ~= TEAM_TRAITOR and not EquipmentItems[v.index] then
			EquipmentItems[v.index] = {}
		end
	end
end

SetupEquipment() -- pre init to support normal TTT addons

hook.Add("TTT2_FinishedSync", "updateEquRol", function()
	SetupEquipment()
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

function GetEquipmentItemByID(id)
	for _, v in pairs(ROLES) do
		local tbl = EquipmentItems[v.index]
		
		if tbl then
			for _, v2 in pairs(tbl) do
				if v2.id == id then
					return v2
				end
			end
		end
	end
end

function GetEquipmentItemByName(name)
	for role, tbl in pairs(EquipmentItems) do
		for _, equip in pairs(tbl) do
			if string.lower(equip.name) == name then
				return equip
			end
		end
	end
end

function GetEquipmentFileName(name)
	local newName = name

	string.gsub(newName, "%W", "_") -- clean string
	string.gsub(newName, " ", "_") -- clean string
	
	newName = string.lower(newName)
	
	return newName
end

function GetEquipmentItemByFileName(name)
	for role, tbl in pairs(EquipmentItems) do
		for _, equip in pairs(tbl) do
			if GetEquipmentFileName(equip.name) == name then
				return equip
			end
		end
	end
end

-- Utility function to register a new Equipment ID
function GenerateNewEquipmentID()
	EQUIP_MAX = EQUIP_MAX * 2
	
	return EQUIP_MAX
end

function EquipmentTableHasValue(tbl, equip)
	table.HasValue(tbl, equip)
	
	for _, eq in pairs(tbl) do
		if eq.id == equip.id then
			return true
		end
	end
	
	return false
end

if SERVER then
	util.AddNetworkString("TTT2SyncEquipment")
	function SyncEquipment(ply)
		net.Start("TTT2SyncEquipment")
		net.WriteTable(SYNC_EQUIP) -- todo handle like role update. What if there is huge data (>64kb)?
		net.Send(ply)
	end
	
	function SyncSingleEquipment(ply, role, equipTbl)
		net.Start("TTT2SyncEquipment")
		net.WriteTable({[role] = {equipTbl}}) -- todo handle like role update. What if there is huge data (>64kb)?
		net.Send(ply)
	end
	
	function AddEquipmentItemToRole(role, item)
		EquipmentItems[role] = EquipmentItems[role] or {}
		
		if not table.HasValue(EquipmentItems[role], item) then
			table.insert(EquipmentItems[role], item)
		end
		
		SYNC_EQUIP[role] = SYNC_EQUIP[role] or {}
		
		local tbl = {equip = item.id, type = 1}
		
		if not table.HasValue(SYNC_EQUIP[role], tbl) then -- TODO fix
			table.insert(SYNC_EQUIP[role], tbl)
		end
		
		for _, v in pairs(player.GetAll()) do
			--SyncEquipment(v)
			SyncSingleEquipment(v, role, tbl)
		end
	end
	
	function AddEquipmentWeaponToRole(role, swep_table)
		if not swep_table.CanBuy then
			swep_table.CanBuy = {}
		end
		
		if not table.HasValue(swep_table.CanBuy, role) then
			table.insert(swep_table.CanBuy, role)
		end
		--
		
		SYNC_EQUIP[role] = SYNC_EQUIP[role] or {}
		
		local tbl = {equip = swep_table.ClassName, type = 0}
		
		if not table.HasValue(SYNC_EQUIP[role], tbl) then -- TODO fix
			table.insert(SYNC_EQUIP[role], tbl)
		end
		
		for _, v in pairs(player.GetAll()) do
			--SyncEquipment(v)
			SyncSingleEquipment(v, role, tbl)
		end
	end
else -- CLIENT
	function AddEquipmentToRoleEquipment(role, equip, item)
		-- start with all the non-weapon goodies
		local toadd

		-- find buyable weapons to load info from
		if not item then
			if equip and not equip.Doublicated and equip.CanBuy and table.HasValue(equip.CanBuy, role) then
				local data = equip.EquipMenuData or {}
				local base = {
					id		 = WEPS.GetClass(equip),
					name	 = equip.ClassName or "Unnamed",
					limited	 = equip.LimitedStock,
					kind	 = equip.Kind or WEAPON_NONE,
					slot	 = (equip.Slot or 0) + 1,
					material = equip.Icon or "vgui/ttt/icon_id",
					-- the below should be specified in EquipMenuData, in which case
					-- these values are overwritten
					type	 = "Type not specified",
					model	 = "models/weapons/w_bugbait.mdl",
					desc	 = "No description specified."
				}

				-- Force material to nil so that model key is used when we are
				-- explicitly told to do so (ie. material is false rather than nil).
				if data.modelicon then
					base.material = nil
				end

				table.Merge(base, data)
				
				toadd = base
			end
		else
			toadd = equip
		end

		-- mark custom items
		if toadd and toadd.id then
			toadd.custom = not table.HasValue(DefaultEquipment[role], toadd.id) -- TODO
		end
		
		if not EquipmentTableHasValue(Equipment[role], toadd) then
			table.insert(Equipment[role], toadd)
		end
		
		print("Added " .. toadd.id .. " to " .. role)
	end
	
	net.Receive("TTT2SyncEquipment", function(len)
		local additions = net.ReadTable()
		
		for role, tbl in pairs(additions) do
			EquipmentItems[role] = EquipmentItems[role] or {}
			
			-- init
			Equipment = Equipment or {}

			if not Equipment[role] then
				GetEquipmentForRole(role)
			end
		
			for _, equip in pairs(tbl) do
				if equip.type == 1 then
					local item = GetEquipmentItemByID(equip.equip)
					if item then
						AddEquipmentToRoleEquipment(role, item, true)
					end
				else
					local swep_table = weapons.GetStored(equip.equip)
					if swep_table then
						if not swep_table.CanBuy then
							swep_table.CanBuy = {}
						end
						
						if not table.HasValue(swep_table.CanBuy, role) then
							table.insert(swep_table.CanBuy, role)
						end
					
						AddEquipmentToRoleEquipment(role, swep_table, false)
					end
				end
			end
		end
	end)
end
