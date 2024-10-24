---
-- @class ENT
-- @section ttt_hat_deerstalker

AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_anim"

ENT.PrintName = "hat_deerstalker_name"
ENT.Model = Model("models/ttt/deerstalker.mdl")
ENT.CanHavePrints = false

ENT.CanUseKey = true

---
-- @realm shared
function ENT:SetupDataTables()
    self:NetworkVar("Bool", 0, "BeingWorn")
end

---
-- @realm shared
function ENT:Initialize()
    self:SetModel(self.Model)

    self:DrawShadow(false)

    -- don't physicsinit the ent here, because physicsing and then setting
    -- movetype none is 1) a waste of memory, 2) broken

    if SERVER then
        if IsValid(self:GetParent()) then
            self:EquipTo(self:GetParent())
        else
            self:Drop()
        end
        self:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
        self:SetUseType(SIMPLE_USE)
        self:AddEffects(bit.bor(EF_BONEMERGE, EF_BONEMERGE_FASTCULL, EF_PARENT_ANIMATES))
    end
end

if SERVER then
    ---
    -- @realm server
    local ttt_hats_reclaim = CreateConVar("ttt_detective_hats_reclaim", "1")

    ---
    -- @realm server
    local ttt_hats_innocent = CreateConVar("ttt_detective_hats_reclaim_any", "0")

    ---
    -- @realm server
    function ENT:OnRemove()
        -- only focus on cleaning up external links, we're not long for this world
        if self.Wearer and self.Wearer.hat == self then
            self.Wearer.hat = nil
        end
    end

    ---
    -- @param Player ply The player to put the hat on.
    -- @realm server
    function ENT:EquipTo(ply)
        self.Wearer = ply
        ply.hat = self

        self:SetBeingWorn(true)

        self:SetMoveType(MOVETYPE_NONE)
        self:SetSolid(SOLID_NONE)

        local pos, ang = playermodels.GetHatPosition(ply)
        self:SetPos(pos)
        self:SetAngles(ang)
        self:SetParent(ply)
    end

    ---
    -- @param Vector dir The drop direction.
    -- @realm server
    function ENT:Drop(dir)
        local ply = self:GetParent()

        ply.hat = nil
        self:SetParent(nil)

        self:SetBeingWorn(false)

        -- only now physics this entity
        self:PhysicsInit(SOLID_VPHYSICS)
        self:SetSolid(SOLID_VPHYSICS)
        self:SetMoveType(MOVETYPE_VPHYSICS)

        -- if we're not already on the player's head,
        if IsValid(ply) then
            local pos, ang = playermodels.GetHatPosition(ply)
            self:SetPos(pos)
            self:SetAngles(ang)
        end

        -- physics push
        local phys = self:GetPhysicsObject()
        if IsValid(phys) then
            phys:SetMass(10)

            if IsValid(ply) then
                phys:SetVelocityInstantaneous(ply:GetVelocity())
            end

            if not dir then
                phys:ApplyForceCenter(Vector(0, 0, 1200))
            else
                phys:ApplyForceCenter(Vector(0, 0, 700) + dir * 500)
            end

            phys:AddAngleVelocity(VectorRand() * 200)

            phys:Wake()
        end
    end

    local function CanEquipHat(ply)
        local rd = ply:GetSubRoleData()
        return not IsValid(ply.hat)
            and (ttt_hats_innocent:GetBool() or (rd.isPolicingRole and rd.isPublicRole))
    end

    ---
    -- @param Player ply
    -- @realm server
    function ENT:Use(ply)
        if not ttt_hats_reclaim:GetBool() then
            return
        end

        if IsValid(ply) and not self:GetBeingWorn() then
            if gameloop.GetRoundState() ~= ROUND_ACTIVE then
                SafeRemoveEntity(self)
                return
            elseif not CanEquipHat(ply) then
                return
            end

            sound.Play("weapon.ImpactSoft", self:GetPos(), 75, 100, 1)

            self:EquipTo(ply)

            LANG.Msg(ply, "hat_retrieve")
        end
    end

    local function TestHat(ply, cmd, args)
        playermodels.ApplyPlayerHat(ply, nil, args[1] or "ttt_hat_deerstalker")
    end
    concommand.Add("ttt_debug_testhat", TestHat, nil, nil, FCVAR_CHEAT)
end
