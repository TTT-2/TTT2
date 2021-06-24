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
SWEP.Primary.Delay = 1
SWEP.Primary.Ammo = "none"

SWEP.Secondary.Recoil = 0
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Delay = 0.5

if SERVER then
	function SWEP:Deploy()
		-- send the data of the existing spawn entities
		entspawnscript.StreamToClient(self:GetOwner())
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

	local colorWeapon = Color(0, 175, 175, 100)
	local colorAmmo = Color(175, 75, 75, 100)

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
				color = colorWeapon
			elseif spawnType == SPAWN_TYPE_AMMO then
				color = colorAmmo
			end

			if i == 1 then
				renderDrawSphere(pos, 11, 4 + 750 / dist3d, 4 + 750 / dist3d, ColorAlpha(color, 245))

				entspawnscript.SetFocusedSpawn(spawnType, entType, id, spawn)
			else
				renderDrawSphere(pos, 10, 4 + 750 / dist3d, 4 + 750 / dist3d, color)
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
		self:AddTTT2HUDHelp("place / remove weapon", "place / remove ammo")
		self:AddHUDHelpLine("change weapon", Key("+reload", "R"))
	end
end

function SWEP:PrimaryAttack()
	if SERVER or not IsFirstTimePredicted() then return end

	self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
	self:SetNextSecondaryFire(CurTime() + self.Primary.Delay)

	local focusedSpawn = entspawnscript.GetFocusedSpawn()

	if focusedSpawn then
		entspawnscript.RemoveSpawnById(focusedSpawn.spawnType, focusedSpawn.entType, focusedSpawn.id)
	else
		local client = LocalPlayer()
		local trace = client:GetEyeTrace()

		if not trace.Hit or trace.StartPos:Distance(trace.HitPos) > 150 then return end

		entspawnscript.AddSpawn(SPAWN_TYPE_WEAPON, WEAPON_TYPE_SHOTGUN, trace.HitPos, client:GetAngles())
	end
end
