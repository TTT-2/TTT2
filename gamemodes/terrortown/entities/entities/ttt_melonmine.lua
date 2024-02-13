if SERVER then
    AddCSLuaFile()

    util.PrecacheSound("npc/scanner/combat_scan2.wav")
end

AccessorFunc(ENT, "dmg", "Dmg", FORCE_NUMBER)

ENT.Base = "ttt_base_placeable"

if CLIENT then
    ENT.PrintName = "weapon_melonmine_name"
    ENT.Icon = "vgui/ttt/icon_melonmine.png"
end

ENT.Spawnable = false
ENT.AdminSpawnable = false

ENT.CanUseKey = true
ENT.pickupWeaponClass = "weapon_ttt_melonmine"

ENT.soundWarning = Sound("weapons/c4/c4_beep1.wav")

function ENT:Initialize()
    self:SetModel("models/props_junk/watermelon01.mdl")
    self:SetColor(Color(255, 175, 0, 255))

    self.BaseClass.Initialize(self)

    self:SetHealth(100)

    if SERVER then
        self:WeldToSurface(true)

        self.StartupDelay = CurTime() + 3
        self.fingerprints = {}

        if not self:GetDmg() then
            self:SetDmg(200)
        end

        local mvObject = self:AddMarkerVision("melon_owner")
        mvObject:SetOwner(self:GetOriginator())
        mvObject:SetVisibleFor(VISIBLE_FOR_TEAM)
        mvObject:SyncToClients()
    end

    if CLIENT then
        self.DrawText = false
        self.Text = ""

        local rand = math.random(1, 3)
        if rand == 1 then
            self.Text = "O_O"
        elseif rand == 2 then
            self.Text = "O.o"
        else
            self.Text = "-.-"
        end

        timer.Simple(3, function()
            if IsValid(self) then
                self.DrawText = true
            end
        end)
    end
end

if CLIENT then
    surface.CreateFont("TrebuchetMelon", { font = "Tahoma", size = 60, antialias = true })
end

function ENT:Draw()
    self:DrawModel()

    local FixAngles = self:GetAngles()
    local FixRotation = Vector(0, 270, 0)

    FixAngles:RotateAroundAxis(FixAngles:Right(), FixRotation.x)
    FixAngles:RotateAroundAxis(FixAngles:Up(), FixRotation.y)
    FixAngles:RotateAroundAxis(FixAngles:Forward(), FixRotation.z)

    local TargetPos = self:GetPos() + (self:GetUp() * 9)
    local _, _, _, a = self:GetColor()

    if self.DrawText then
        cam.Start3D2D(TargetPos, FixAngles, 0.15)
        draw.SimpleText(
            self.Text,
            "TrebuchetMelon",
            TEXT_ALIGN_CENTER,
            TEXT_ALIGN_CENTER,
            Color(255, 0, 0, a),
            1,
            1
        )
        cam.End3D2D()
    end
end

ENT.StartupDelay = nil

if SERVER then
    function ENT:OnRemoe()
        self:RemoveMarkerVision("melon_owner")
    end

    function ENT:Think()
        if not self.StartupDelay or self.StartupDelay >= CurTime() then
            return
        end

        local foundEnts = ents.FindInSphere(self:GetPos(), 150)

        for i = 1, #foundEnts do
            local ply = foundEnts[i]

            if
                not IsValid(ply)
                or not ply:IsPlayer()
                or ply:GetTeam() == self:GetOriginator():GetTeam()
                or (isfunction(ply.IsGhost) and ply:IsGhost())
            then
                continue
            end

            local rags = ents.FindByClass("prop_ragdoll")
            local trace = {}

            table.insert(rags, self)

            trace.start = self:GetPos()
            trace.endpos = ply:GetPos() + Vector(0, 0, 60)
            trace.filter = rags

            local tr = util.TraceLine(trace)

            -- Checks if there's a clear view of the player, the melon can be hidden beneath a ragdoll
            if IsValid(tr.Entity) and tr.Entity == ply then
                timer.Create("beep", 0.1, 8, function()
                    if not IsValid(self) then
                        return
                    end

                    self:EmitSound(soundWarning)
                end)

                timer.Simple(1, function()
                    if not IsValid(self) then
                        return
                    end

                    self:Explode(ply)
                end)

                function self.Think() end
            end
        end
    end

    function ENT:Explode(plyTrigger)
        self:SetNoDraw(true)
        self:SetSolid(SOLID_NONE)

        local pos = self:GetPos()

        if self:GetPos().z < plyTrigger:GetPos().z + 50 then
            pos.z = pos.z + 30
        end

        local dmgOwner = self:GetOriginator()
        dmgOwner = IsValid(dmgOwner) and dmgOwner or self

        local r_outer = 240

        -- explosion damage
        util.BlastDamage(self, dmgOwner, pos, r_outer, self:GetDmg())

        sound.Play("explode_4", self:GetPos(), 130, 100)

        local effect = EffectData()
        effect:SetStart(pos)
        effect:SetOrigin(pos)
        effect:SetScale(r_outer)
        effect:SetRadius(r_outer)
        effect:SetMagnitude(self:GetDmg())

        effect:SetOrigin(pos)
        util.Effect("Explosion", effect, true, true)
        util.Effect("HelicopterMegaBomb", effect, true, true)

        -- extra push
        local phexp = ents.Create("env_physexplosion")
        phexp:SetPos(pos)
        phexp:SetKeyValue("magnitude", self:GetDmg())
        phexp:SetKeyValue("radius", r_outer)
        phexp:SetKeyValue("spawnflags", "19")
        phexp:Spawn()
        phexp:Fire("Explode", "", 0)

        self:Remove()
    end

    local smallExplosion = 75

    function ENT:WasDestroyed(pos, dmgInfo)
        local originator = self:GetOriginator()
        local attacker = dmgInfo:GetAttacker()

        local blastAttacker = (IsValid(attacker) and attacker:IsPlayer()) and attacker or originator

        util.BlastDamage(self, blastAttacker or self, pos, smallExplosion, smallExplosion)

        local effect = EffectData()
        effect:SetStart(pos)
        effect:SetOrigin(pos)
        effect:SetScale(smallExplosion)
        effect:SetRadius(smallExplosion)
        effect:SetMagnitude(smallExplosion)

        effect:SetOrigin(pos)
        util.Effect("Explosion", effect, true, true)

        LANG.Msg(originator, "weapon_melonmine_destroyed", nil, MSG_MSTACK_WARN)

        return "Scorch"
    end

    function ENT:PlayerCanPickupWeapon(activator)
        return self:GetOriginator() == activator
    end
end

-- It seems intuitive to use FindInSphere here, but that will find all ents
-- in the radius, whereas there exist only ~16 players. Hence it is more
-- efficient to cycle through all those players and do a Lua-side distance
-- check.
function ENT:SphereDamage(dmgOwner, center, radius)
    local r = radius ^ 2 -- square so we can compare with dotproduct directly

    -- pre-declare to avoid realloc
    local d = 0.0
    local diff = nil
    local dmg = 0

    local plys = player.GetAll()

    for i = 1, #plys do
        local ply = plys[i]

        if not IsValid(ply) or not ply:IsTerror() then
            continue
        end

        -- dot of the difference with itself is distance squared
        diff = center - ply:GetPos()
        d = diff:Dot(diff)

        if d < r then
            -- deadly up to a certain range, then a quick falloff within 100 units
            d = math.max(0, math.sqrt(d) - 490)
            dmg = -0.01 * (d ^ 2) + 125

            local dmginfo = DamageInfo()
            dmginfo:SetDamage(dmg)
            dmginfo:SetAttacker(dmgOwner)
            dmginfo:SetInflictor(self)
            dmginfo:SetDamageType(DMG_BLAST)
            dmginfo:SetDamageForce(center - ply:GetPos())
            dmginfo:SetDamagePosition(ply:GetPos())

            ply:TakeDamageInfo(dmginfo)
        end
    end
end

if CLIENT then
    local TryT = LANG.TryTranslation
    local ParT = LANG.GetParamTranslation

    local materialMelonmine = Material("vgui/ttt/marker_vision/melonmine")

    -- handle looking at C4
    hook.Add("TTTRenderEntityInfo", "HUDDrawTargetIDMelonmine", function(tData)
        local client = LocalPlayer()
        local ent = tData:GetEntity()

        if
            not client:IsTerror()
            or not IsValid(ent)
            or tData:GetEntityDistance() > 100
            or ent:GetClass() ~= "ttt_melonmine"
            or client:GetTeam() ~= ent:GetOriginator():GetTeam()
        then
            return
        end

        -- enable targetID rendering
        tData:EnableText()
        tData:EnableOutline()
        tData:SetOutlineColor(client:GetRoleColor())

        tData:SetTitle(TryT(ent.PrintName))

        if ent:GetOriginator() == client then
            tData:SetKeyBinding("+use")
            tData:SetSubtitle(ParT("target_pickup", { usekey = Key("+use", "USE") }))
        else
            tData:AddIcon(materialMelonmine)
            tData:SetSubtitle(TryT("target_pickup_disabled"))
        end
    end)

    hook.Add("TTT2RenderMarkerVisionInfo", "HUDDrawMarkerVisionMelonMine", function(mvData)
        local client = LocalPlayer()
        local ent = mvData:GetEntity()
        local mvObject = mvData:GetMarkerVisionObject()

        if not client:IsTerror() or not mvObject:IsObjectFor(ent, "melon_owner") then
            return
        end

        local originator = ent:GetOriginator()
        local nick = IsValid(originator) and originator:Nick() or "---"

        local distance = math.Round(util.HammerUnitsToMeters(mvData:GetEntityDistance()), 1)

        mvData:EnableText()

        mvData:AddIcon(materialMelonmine)
        mvData:SetTitle(TryT(ent.PrintName))

        mvData:AddDescriptionLine(ParT("marker_vision_owner", { owner = nick }))
        mvData:AddDescriptionLine(ParT("marker_vision_distance", { distance = distance }))

        mvData:AddDescriptionLine(TryT(mvObject:GetVisibleForTranslationKey()), COLOR_SLATEGRAY)
    end)
end
