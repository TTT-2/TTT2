SWEP.Base = "weapon_tttbase"

if CLIENT then
	SWEP.ViewModelFOV = 78
	SWEP.DrawCrosshair = false
	SWEP.ViewModelFlip = false

	SWEP.EquipMenuData = {
		type = "item_weapon",
		name = "xxx",
		desc = "xxx"
	}

	--SWEP.Icon = "vgui/ttt/icon_doorlocker"
end

SWEP.Kind = WEAPON_EQUIP2
SWEP.CanBuy = {}
SWEP.notBuyable = true

SWEP.UseHands = true
SWEP.ViewModel = "models/weapons/c_toolgun.mdl"
SWEP.WorldModel = "models/weapons/w_toolgun.mdl"

SWEP.AutoSpawnable = false
SWEP.NoSights = true

SWEP.HoldType = "pistol"
SWEP.LimitedStock = true

SWEP.Primary.Recoil = 0
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false
SWEP.Primary.Delay = 0.5
SWEP.Primary.Ammo = "none"

SWEP.Secondary.Recoil = 0
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Delay = 0.5

if SERVER then
	util.AddNetworkString("weapon_ttt_wepeditor_spawninfo_ent")

	function SWEP:Deploy()
		-- send the data of the existing spawn entities
		entspawnscript.StreamToClient(self:GetOwner())

		-- add entity which is used for the targetID integration
		self.entSpawnInfo = ents.Create("ttt_spawninfo_ent")
		self.entSpawnInfo:Spawn()

		timer.Simple(0, function()
			if not IsValid(self) or not IsValid(self.entSpawnInfo) then return end

			net.Start("weapon_ttt_wepeditor_spawninfo_ent")
			net.WriteEntity(self.entSpawnInfo)
			net.Send(self:GetOwner())
		end)

		self.BaseClass.Deploy(self)
	end

	function SWEP:Holster(wep)
		-- remove entity which is used for the targetID integration
		self.entSpawnInfo:Remove()

		return self.BaseClass.Holster(self, wep)
	end
end

if CLIENT then
	local renderSetColorMaterial = render.SetColorMaterial
	local renderDrawSphere = render.DrawSphere
	local camStart3D = cam.Start3D
	local camEnd3D = cam.End3D

	local weaponSpawnEditHookInstalled = false

	local centerX = 0.5 * ScrW()
	local centerY = 0.5 * ScrH()
	local tolerance = 7800

	local function IsHighlighted(pos, scPos)
		local dist3d = LocalPlayer():EyePos():Distance(pos)

		if dist3d > 150 then
			return false, dist3d
		end

		if math.Distance(scPos.x, scPos.y, centerX, centerY) > tolerance / dist3d then
			return false, dist3d
		end

		return true, dist3d
	end

	local function RenderHook()
		entspawnscript.SetFocusedSpawn(nil)

		local spawnEntList = entspawnscript.GetSpawnEntities()

		if not spawnEntList then return end

		local weps = spawnEntList[SPAWN_TYPE_WEAPON] or {}
		local ammo = spawnEntList[SPAWN_TYPE_AMMO] or {}

		local proximitySpawns = {}

		local scPos

		renderSetColorMaterial()

		local colorWeapon = ColorAlpha(entspawnscript.GetColorFromSpawnType(SPAWN_TYPE_WEAPON), 100)
		local colorAmmo = ColorAlpha(entspawnscript.GetColorFromSpawnType(SPAWN_TYPE_AMMO), 100)

		for entType, spawns in pairs(weps) do
			for i = 1, #spawns do
				local spawn = spawns[i]
				local pos = spawn.pos

				-- the scPos has to be calculatet inside a non modified cam3D space
				-- to yield correct results
				camStart3D()
					scPos = pos:ToScreen()
				camEnd3D()

				local isHighlighted, dist3d = IsHighlighted(pos, scPos)

				if util.IsOffScreen(scPos) or dist3d > 1500 then continue end

				if not isHighlighted then
					renderDrawSphere(pos, 10, 4 + 750 / dist3d, 4 + 750 / dist3d, colorWeapon)
				else
					proximitySpawns[#proximitySpawns + 1] = {
						entType = entType,
						spawnType = SPAWN_TYPE_WEAPON,
						spawn = spawn,
						dist3d = dist3d,
						scPos = scPos,
						id = i
					}
				end
			end
		end

		for entType, spawns in pairs(ammo) do
			for i = 1, #spawns do
				local spawn = spawns[i]
				local pos = spawn.pos

				-- the scPos has to be calculatet inside a non modified cam3D space
				-- to yield correct results
				camStart3D()
					scPos = pos:ToScreen()
				camEnd3D()

				local isHighlighted, dist3d = IsHighlighted(pos, scPos)

				if util.IsOffScreen(scPos) or dist3d > 1500 then continue end

				if not isHighlighted then
					renderDrawSphere(pos, 10, 4 + 750 / dist3d, 4 + 750 / dist3d, colorAmmo)
				else
					proximitySpawns[#proximitySpawns + 1] = {
						entType = entType,
						spawnType = SPAWN_TYPE_AMMO,
						spawn = spawn,
						dist3d = dist3d,
						scPos = scPos,
						id = i
					}
				end
			end
		end

		table.sort(proximitySpawns, function(a, b)
			return a.dist3d < b.dist3d
		end)

		for i = 1, #proximitySpawns do
			local proximitySpawn = proximitySpawns[i]
			local spawn = proximitySpawn.spawn
			local spawnType = proximitySpawn.spawnType
			local pos = proximitySpawn.spawn.pos
			local entType = proximitySpawn.entType
			local id = proximitySpawn.id
			local dist3d = proximitySpawn.dist3d
			local color

			scPos = proximitySpawn.scPos

			if spawnType == SPAWN_TYPE_WEAPON then
				color = entspawnscript.GetColorFromSpawnType(SPAWN_TYPE_WEAPON)
			elseif spawnType == SPAWN_TYPE_AMMO then
				color = entspawnscript.GetColorFromSpawnType(SPAWN_TYPE_AMMO)
			end

			if i == 1 then
				renderDrawSphere(pos, 11, 4 + 750 / dist3d, 4 + 750 / dist3d, ColorAlpha(color, 245))

				entspawnscript.SetFocusedSpawn(spawnType, entType, id, spawn)
			else
				renderDrawSphere(pos, 10, 4 + 750 / dist3d, 4 + 750 / dist3d, ColorAlpha(color, 100))
			end
		end
	end

	local function WeaponSpawnEditStart()
		if weaponSpawnEditHookInstalled then return end

		hook.Add("PostDrawTranslucentRenderables", "RenderWeaponSpawnEdit", RenderHook)

		weaponSpawnEditHookInstalled = true
	end

	local function WeaponSpawnEditStop()
		hook.Remove("PostDrawTranslucentRenderables", "RenderWeaponSpawnEdit")

		weaponSpawnEditHookInstalled = false
	end

	function SWEP:Deploy()
		WeaponSpawnEditStart()

		entspawnscript.SetEditing(true)
	end

	function SWEP:Holster()
		WeaponSpawnEditStop()

		entspawnscript.SetEditing(false)
	end

	function SWEP:Initialize()
		self:AddTTT2HUDHelp("place spawn", "remove spawn")
		self:AddHUDHelpLine("change spawn type", Key("+reload", "R"))
		self:AddHUDHelpLine("hold to edit ammo auto spawn on weapon spawns", Key("+walk", "WALK"))
	end

	net.Receive("weapon_ttt_wepeditor_spawninfo_ent", function()
		entspawnscript.SetSpawnInfoEntity(net.ReadEntity())
	end)
end

-- used to place / remove spawns
function SWEP:PrimaryAttack()
	if SERVER or not IsFirstTimePredicted() then return end

	self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
	self:SetNextSecondaryFire(CurTime() + self.Primary.Delay)

	local focusedSpawn = entspawnscript.GetFocusedSpawn()

	if input.IsBindingDown("+walk") then
		if not focusedSpawn then return end

		local spawnType = focusedSpawn.spawnType
		local entType = focusedSpawn.entType
		local id = focusedSpawn.id
		local ammo = focusedSpawn.spawn.ammo

		entspawnscript.UpdateSpawn(spawnType, entType, id, nil, nil, ammo + 1)
	else
		if focusedSpawn then return end

		local client = LocalPlayer()
		local trace = client:GetEyeTrace()

		if not trace.Hit or trace.StartPos:Distance(trace.HitPos) > 150 then return end

		entspawnscript.AddSpawn(SPAWN_TYPE_WEAPON, WEAPON_TYPE_SHOTGUN, trace.HitPos + 7.5 * trace.HitNormal, client:GetAngles(), 0)
	end
end

function SWEP:SecondaryAttack()
	if SERVER or not IsFirstTimePredicted() then return end

	self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
	self:SetNextSecondaryFire(CurTime() + self.Primary.Delay)

	local focusedSpawn = entspawnscript.GetFocusedSpawn()

	if not focusedSpawn then return end

	local spawnType = focusedSpawn.spawnType
	local entType = focusedSpawn.entType
	local id = focusedSpawn.id
	local ammo = focusedSpawn.spawn.ammo

	if input.IsBindingDown("+walk") then
		entspawnscript.UpdateSpawn(spawnType, entType, id, nil, nil, math.max(ammo - 1, 0))
	else
		entspawnscript.RemoveSpawnById(focusedSpawn.spawnType, focusedSpawn.entType, focusedSpawn.id)
	end
end

function SWEP:Reload()
	if SERVER or not IsFirstTimePredicted() then return end
end
