if SERVER then
    AddCSLuaFile()
end

DEFINE_BASECLASS("weapon_tttbase")

SWEP.Base = "weapon_tttbase"

if CLIENT then
    SWEP.ViewModelFOV = 45
    SWEP.ViewModelFlip = false

    SWEP.EquipMenuData = {
        type = "item_weapon",
        name = "spawneditor_name",
        desc = "spawneditor_desc",
    }
end

SWEP.Kind = WEAPON_EQUIP2
SWEP.CanBuy = {}
SWEP.notBuyable = true
SWEP.AutoSpawnable = false

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

SWEP.lastReload = 0

SWEP.AllowDrop = false

SWEP.builtin = true

local previewData = {}

if SERVER then
    util.AddNetworkString("weapon_ttt_spawneditor_spawninfo_ent")

    ---
    -- @ignore
    function SWEP:Deploy()
        -- add entity which is used for the targetID integration
        self.entSpawnInfo = ents.Create("ttt_spawninfo_ent")
        self.entSpawnInfo:Spawn()

        -- Send SpawnInfo-Entity next frame, so it can be created first
        timer.Simple(0, function()
            if not IsValid(self) or not IsValid(self.entSpawnInfo) then
                return
            end

            net.Start("weapon_ttt_spawneditor_spawninfo_ent")
            net.WriteEntity(self.entSpawnInfo)
            net.Send(self:GetOwner())
        end)

        BaseClass.Deploy(self)
    end

    ---
    -- @ignore
    function SWEP:OnRemove()
        -- using the on remove hook to store the updated spawns because it is called in the following scenarios:
        -- * manual stop of the spawn edit process
        -- * stop of the spawn edit process triggered by a death
        -- * stop of the spawn edit process triggered by a new round
        -- * stop of the spawn edit process triggered by a mapchange
        entspawnscript.UpdateSpawnFile()

        -- remove entity which is used for the targetID integration
        if not IsValid(self.entSpawnInfo) then
            return
        end

        self.entSpawnInfo:Remove()
    end

    ---
    -- @ignore
    function SWEP:OnDrop()
        self:Remove()
    end
end

if CLIENT then
    local draw = draw
    local camStart2D = cam.Start2D
    local camEnd2D = cam.End2D
    local camStart3D2D = cam.Start3D2D
    local camEnd3D2D = cam.End3D2D
    local renderPushRenderTarget = render.PushRenderTarget
    local renderSetColorMaterial = render.SetColorMaterial
    local renderDrawSphere = render.DrawSphere
    local camStart3D = cam.Start3D
    local camEnd3D = cam.End3D
    local Vector = Vector
    local mathPi = math.pi
    local mathTan = math.tan
    local mathMax = math.max
    local mathMin = math.min
    local ColorAlpha = ColorAlpha

    local centerX = 0.5 * ScrW()
    local centerY = 0.5 * ScrH()
    local sphereRadius = 10
    local tolerance = 32 * sphereRadius

    local maxEditDistance = 1500
    local distWalls = 7.5

    local colorPreview = Color(255, 255, 255, 100)

    local matScreen = Material("models/weapons/v_toolgun/screen")
    local screenSize = 256
    local padding = 16
    local iconSize = 64
    local iconX = 0.5 * (screenSize - iconSize)
    local iconY = 2 * padding
    local textX = 0.5 * screenSize
    local textY = iconY + iconSize + padding
    local lineY = screenSize - 48
    local lineW = screenSize - 2 * padding
    local circleS = 6
    local circleY = screenSize - 24

    local RTTexture = GetRenderTarget("TTT2SpawnPlacer", screenSize, screenSize)

    local colorBasic = Color(255, 255, 255, 100)
    local colorSelect = Color(255, 255, 255, 235)

    local function GetSteps(distance3D)
        if not isnumber(distance3D) then
            return 10
        end

        -- Norm Steps to be the maximum 10 at 200 units and minimum of 5 at 400 units seems reasonable
        -- Dont go below 5, as you wont recognize it as a sphere anymore
        return mathMin(10, mathMax(5, 10 * 200 / distance3D))
    end

    local function IsHighlighted(pos, screenPos)
        local localPlayer = LocalPlayer()
        local dist3d = localPlayer:EyePos():Distance(pos)

        if dist3d > maxEditDistance then
            return false, dist3d
        end

        if
            math.Distance(screenPos.x, screenPos.y, centerX, centerY)
            > tolerance * ScrW() / localPlayer:GetFOV() / dist3d
        then
            return false, dist3d
        end

        return true, dist3d
    end

    local function PaintSpawns(spawnType, entTable, color, proximitySpawns)
        local screenPos

        -- While iterating over the table containing all spawn ents for one spawn
        -- type most spheres are directly drawn. However a small selection of those
        -- speres is stored in the proximity spawns table. These spawns spheres are
        -- so close to the crosshair that they might be highligted right now. To
        -- detect which one is highlighted right now, we later have to sort this table
        -- by 3d distance. But since sorting is a heavy task, especially when done
        -- in the rendering queue, only the selected minority is sorted.

        for entType, spawns in pairs(entTable) do
            for i = 1, #spawns do
                local spawn = spawns[i]
                local pos = spawn.pos

                -- If pos is nil, continue to the next iteration
                if not pos then
                    continue
                end

                -- the screenPos has to be calculatet inside a non modified cam3D space
                -- to yield correct results
                camStart3D()
                screenPos = pos:ToScreen()
                camEnd3D()

                if util.IsOffScreen(screenPos) then
                    continue
                end

                local isHighlighted, dist3d = IsHighlighted(pos, screenPos)

                if dist3d > maxEditDistance then
                    continue
                end

                local steps = GetSteps(dist3d)

                if not isHighlighted then
                    renderDrawSphere(pos, 10, steps, steps, color)
                else
                    proximitySpawns[#proximitySpawns + 1] = {
                        entType = entType,
                        spawnType = spawnType,
                        spawn = spawn,
                        dist3d = dist3d,
                        screenPos = screenPos,
                        id = i,
                    }
                end
            end
        end
    end

    local function RenderForType(spawnType, spawnEntList, proximitySpawns)
        local spawnEnts = spawnEntList[spawnType] or {}
        local colorEnt = ColorAlpha(entspawnscript.GetColorFromSpawnType(spawnType), 100)

        -- draw spawn bubbles and put bubbles that might be highlighted in
        -- the 'proximitySpawns' table
        PaintSpawns(spawnType, spawnEnts, colorEnt, proximitySpawns)

        return colorEnt
    end

    local function RenderHook()
        entspawnscript.SetFocusedSpawn(nil)

        local spawnEntList = entspawnscript.GetSpawns()
        local proximitySpawns = {}
        local colorSpawnTypes = {}

        if not spawnEntList then
            return
        end

        renderSetColorMaterial()

        local spawnTypesTable = entspawnscript.GetSpawnTypes()

        for i = 1, #spawnTypesTable do
            local spawnType = spawnTypesTable[i]

            colorSpawnTypes[spawnType] = RenderForType(spawnType, spawnEntList, proximitySpawns)
        end

        -- sort the proximity spawns by distance
        table.sort(proximitySpawns, function(a, b)
            return a.dist3d < b.dist3d
        end)

        -- draw the proximity spawns and highlight the first one
        for i = 1, #proximitySpawns do
            local proximitySpawn = proximitySpawns[i]
            local spawn = proximitySpawn.spawn
            local spawnType = proximitySpawn.spawnType
            local pos = proximitySpawn.spawn.pos
            local entType = proximitySpawn.entType
            local id = proximitySpawn.id
            local dist3d = proximitySpawn.dist3d
            local color = colorSpawnTypes[spawnType]
            local steps = GetSteps(dist3d)

            screenPos = proximitySpawn.screenPos

            -- only highlight the first in the table because this is the foucused spawn bubble
            if i == 1 then
                local client = LocalPlayer()

                -- make sure there is nothing in the way
                local trace = util.TraceLine({
                    start = client:EyePos(),
                    endpos = client:EyePos() + client:EyeAngles():Forward() * dist3d,
                    filter = { client },
                    mask = MASK_SOLID,
                })

                if not trace.HitWorld then
                    entspawnscript.SetFocusedSpawn(spawnType, entType, id, spawn)
                end

                renderDrawSphere(
                    pos,
                    sphereRadius * (trace.HitWorld and 1 or 1.1),
                    steps,
                    steps,
                    ColorAlpha(color, 245)
                )
            else
                renderDrawSphere(pos, sphereRadius, steps, steps, ColorAlpha(color, 100))
            end
        end

        if not previewData.inRange then
            return
        end

        local colorSphere

        if previewData.inPlacement then
            colorSphere =
                ColorAlpha(entspawnscript.GetColorFromSpawnType(previewData.spawnType), 245)

            -- render circle on ground
            camStart3D2D(
                previewData.posBase + previewData.normalBase * 2,
                previewData.normalBase:Angle() + Angle(90, 0, 0),
                0.25
            )

            draw.Circle(0, 0, 30, colorPreview)

            camEnd3D2D()

            -- render line that shows shift
            camStart3D2D(
                previewData.posBase + previewData.normalBase * 2,
                Angle(0, LocalPlayer():GetAngles().y - 90, 90),
                0.25
            )

            draw.Box(-1, 0, 2, 4 * (previewData.heightShift or 0), colorPreview)

            camEnd3D2D()
        else
            colorSphere = colorPreview
        end

        local steps = GetSteps(previewData.distance3d)

        renderDrawSphere(previewData.currentPos, sphereRadius, steps, steps, colorSphere)
    end

    ---
    -- @realm client
    function SWEP:OnRemove()
        BaseClass.OnRemove(self)

        hook.Remove("PostDrawTranslucentRenderables", "RenderWeaponSpawnEdit")

        -- clear the local cache to prevent flickering after reset
        entspawnscript.ClearLocalCache()
    end

    ---
    -- @ignore
    function SWEP:Initialize()
        self.modes = entspawnscript.GetSpawnTypeList()
        self.selectedMode = 1

        self:AddTTT2HUDHelp("spawneditor_place", "spawneditor_remove")
        self:AddHUDHelpLine("spawneditor_change", Key("+reload", "undefined_key"))
        self:AddHUDHelpLine("spawneditor_ammo_edit", Key("+walk", "undefined_key"))

        hook.Add("PostDrawTranslucentRenderables", "RenderWeaponSpawnEdit", RenderHook)
    end

    ---
    -- @ignore
    function SWEP:RenderScreen()
        -- Set the material of the screen to our render target
        matScreen:SetTexture("$basetexture", RTTexture)

        -- Set up our view for drawing to the texture
        renderPushRenderTarget(RTTexture)

        local mode = self.modes[self.selectedMode]

        camStart2D()
        draw.Box(0, 0, screenSize, screenSize, entspawnscript.GetColorFromSpawnType(mode.spawnType))

        draw.ShadowedTexture(
            iconX,
            iconY,
            iconSize,
            iconSize,
            entspawnscript.GetIconFromSpawnType(mode.spawnType, mode.entType),
            255,
            COLOR_WHITE
        )

        draw.ShadowedText(
            LANG.TryTranslation(
                entspawnscript.GetLangIdentifierFromSpawnType(mode.spawnType, mode.entType)
            ),
            "DermaTTT2SubMenuButtonTitle",
            textX,
            textY,
            COLOR_WHITE,
            TEXT_ALIGN_CENTER,
            TEXT_ALIGN_TOP
        )

        draw.Box(padding, lineY, lineW, 2, colorBasic)

        for i = 1, #self.modes do
            if i == self.selectedMode then
                draw.Circle(i * padding, circleY, circleS, colorSelect)
            else
                draw.Circle(i * padding, circleY, circleS, colorBasic)
            end
        end
        camEnd2D()

        render.PopRenderTarget()
    end

    net.Receive("weapon_ttt_spawneditor_spawninfo_ent", function()
        entspawnscript.SetSpawnInfoEntity(net.ReadEntity())
    end)

    ---
    -- @ignore
    function SWEP:Think()
        local client = LocalPlayer()

        -- Make sure the user is currently not typing anything, to prevent unwanted execution of a placement
        if
            vgui.GetKeyboardFocus()
            or client:IsTyping()
            or gui.IsConsoleVisible()
            or vguihandler.IsOpen()
        then
            return
        end

        local focusedSpawn = entspawnscript.GetFocusedSpawn()
        local mode = self.modes[self.selectedMode]

        -- always set spawnType
        previewData.spawnType = mode.spawnType

        if input.IsBindingDown("+attack") and not self.wasAttackDown then
            -- first key down of the attack button: get basepos
            self.wasAttackDown = true

            if focusedSpawn then
                return
            end

            local trace = client:GetEyeTrace()

            local posEye = client:EyePos()
            local posBase = trace.HitPos
            local distance3d = posEye:Distance(posBase)

            if not trace.Hit or distance3d > maxEditDistance then
                return
            end

            previewData.normalBase = trace.HitNormal
            previewData.inPlacement = true
            previewData.posBase = posBase
            previewData.distance3d = distance3d

            -- find limits for top and bottom
            local traceLimitUpper = util.TraceLine({
                start = posBase + trace.HitNormal,
                endpos = posBase + Vector(0, 0, maxEditDistance),
                mask = MASK_PLAYERSOLID_BRUSHONLY,
            })

            previewData.posLimitUpper = traceLimitUpper.HitPos
            previewData.normalLimitUpper = traceLimitUpper.HitNormal

            local traceLimitLower = util.TraceLine({
                start = posBase + trace.HitNormal,
                endpos = posBase - Vector(0, 0, maxEditDistance),
                mask = MASK_PLAYERSOLID_BRUSHONLY,
            })

            previewData.posLimitLower = traceLimitLower.HitPos
            previewData.normalLimitLower = traceLimitLower.HitNormal
        elseif input.IsBindingDown("+attack") and previewData.inPlacement then
            -- hold attack key: update preview position
            local posBase = previewData.posBase

            local posEye = client:EyePos()
            local posGround = Vector(posEye.x, posEye.y, posBase.z)

            local distance2d = posGround:Distance(posBase)
            local distance3d = posEye:Distance(posBase)

            local angle = LocalPlayer():EyeAngles().p / 180 * mathPi -- angle in rad
            local diff = distance2d * mathTan(angle)

            local currentPos = Vector(posBase.x, posBase.y, posEye.z - diff)

            -- limit current position in between valid range
            currentPos.z = math.min(currentPos.z, previewData.posLimitUpper.z - distWalls)
            currentPos.z = math.max(currentPos.z, previewData.posLimitLower.z + distWalls)

            previewData.currentPos = currentPos
            previewData.distance3d = distance3d
            previewData.heightShift = posBase.z - previewData.currentPos.z
        elseif not input.IsBindingDown("+attack") and self.wasAttackDown then
            -- attack key released: set spawn
            self.wasAttackDown = false

            if not previewData.inPlacement then
                return
            end

            previewData.inPlacement = false
            previewData.heightShift = 0

            if focusedSpawn then
                return
            end

            entspawnscript.AddSpawn(
                mode.spawnType,
                mode.entType,
                previewData.currentPos,
                client:GetAngles(),
                0,
                true
            )
        else
            -- just store current position for rendering of preview
            local trace = client:GetEyeTrace()
            local posEye = client:EyePos()
            local posBase = trace.HitPos
            local distance3d = posEye:Distance(posBase)

            previewData.currentPos = trace.HitPos
            previewData.normalBase = trace.HitNormal
            previewData.distance3d = distance3d
            previewData.inRange = distance3d <= maxEditDistance and not focusedSpawn
        end
    end
end

---
-- @ignore
function SWEP:PrimaryAttack()
    if SERVER or not IsFirstTimePredicted() then
        return
    end

    local nextUseTime = CurTime() + self.Primary.Delay
    self:SetNextPrimaryFire(nextUseTime)
    self:SetNextSecondaryFire(nextUseTime)

    local focusedSpawn = entspawnscript.GetFocusedSpawn()

    if input.IsBindingDown("+walk") then
        if not focusedSpawn then
            return
        end

        local spawnType = focusedSpawn.spawnType
        local entType = focusedSpawn.entType
        local id = focusedSpawn.id
        local ammo = focusedSpawn.spawn.ammo

        entspawnscript.UpdateSpawn(spawnType, entType, id, nil, nil, ammo + 1, true)
    end
end

---
-- @ignore
function SWEP:SecondaryAttack()
    if SERVER or not IsFirstTimePredicted() then
        return
    end

    local nextUseTime = CurTime() + self.Primary.Delay
    self:SetNextPrimaryFire(nextUseTime)
    self:SetNextSecondaryFire(nextUseTime)

    local focusedSpawn = entspawnscript.GetFocusedSpawn()

    if not focusedSpawn then
        return
    end

    local spawnType = focusedSpawn.spawnType
    local entType = focusedSpawn.entType
    local id = focusedSpawn.id
    local ammo = focusedSpawn.spawn.ammo

    if input.IsBindingDown("+walk") then
        entspawnscript.UpdateSpawn(spawnType, entType, id, nil, nil, math.max(ammo - 1, 0), true)
    else
        entspawnscript.RemoveSpawnById(
            focusedSpawn.spawnType,
            focusedSpawn.entType,
            focusedSpawn.id,
            true
        )
    end
end

---
-- @ignore
function SWEP:Reload()
    if SERVER or not IsFirstTimePredicted() then
        return
    end

    if self.lastReload + 0.175 > CurTime() then
        return
    end

    self.lastReload = CurTime()

    if input.IsKeyDown(KEY_LSHIFT) or input.IsKeyDown(KEY_RSHIFT) then
        if self.selectedMode == 1 then
            self.selectedMode = #self.modes
        else
            self.selectedMode = self.selectedMode - 1
        end
    else
        if self.selectedMode == #self.modes then
            self.selectedMode = 1
        else
            self.selectedMode = self.selectedMode + 1
        end
    end
end
