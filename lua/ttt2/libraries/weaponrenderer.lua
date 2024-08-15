---
-- Used to build custom world and view models. It also renders those custom models.
-- This module can only be used by entities that are based on `weapon_ttt_base` as this
-- relies on some functions defined in this class.
-- This code is based on the SWEP construction kit.
-- @ref https://github.com/MagicSwap/SWEP_Construction_Kit
-- @author Mineotopia
-- @module weaponrenderer

---@class ModelData
---@field type string The type of this model, it can be "Model", "Sprite" or "Quad"
---@field model string The path to the model file
---@field bone string The name of the reference bone
---@field rel string The name of a related identifier
---@field pos Vector The position offset of the model
---@field angle Angle The rotation offset of the model
---@field size Vector The size multiplier of the model
---@field color Color The color for the model
---@field surpresslightning boolean Set to true if the engine lightning should be suppressed
---@field material string The model material
---@field skin number The skin index of the model
---@field bodygroup table A table of bodygroups

---@class BoneData
---@field scale Vector The scale multiplier
---@field pos Vector The position offset
---@field angle Angle The rotation offset

if SERVER then
    AddCSLuaFile()

    return
end

weaponrenderer = {}

local propertiesMaterial = { "nocull", "additive", "vertexalpha", "vertexcolor", "ignorez" }

---
-- Gets the orientation of a given bone.
-- @param Entity wep The weapon whose bone orientation is desired
-- @param table baseDataTable The base data table, most of the time the view elements
-- @param table dataTable The data table, most of the time the model data
-- @param Entity boneEntity The bone entity, can be the view model, the player or the weapon
-- @param boolean isInWorld If the weapon is placed in the world, without a player holding it
-- @return Vector pos The bone position
-- @return Angle ang The bone angle
-- @realm client
local function GetBoneOrientation(wep, baseDataTable, dataTable, boneEntity, isInWorld)
    local bone, pos, ang

    if dataTable.rel and dataTable.rel ~= "" then
        local tbl = baseDataTable[dataTable.rel]

        if not tbl then
            return
        end

        -- Technically, if there exists an element with the same name as a bone
        -- you can get in an infinite loop. Let's just hope nobody's that stupid.
        pos, ang = GetBoneOrientation(wep, baseDataTable, tbl, boneEntity, isInWorld)

        if not pos then
            return
        end

        pos = pos + ang:Forward() * tbl.pos.x + ang:Right() * tbl.pos.y + ang:Up() * tbl.pos.z

        ang:RotateAroundAxis(ang:Up(), tbl.angle.y)
        ang:RotateAroundAxis(ang:Right(), tbl.angle.p)
        ang:RotateAroundAxis(ang:Forward(), tbl.angle.r)
    else
        bone = boneEntity:LookupBone(dataTable.bone)

        -- as a fallback, always try to use the first bone
        -- this is important when the model is thrown in the world and has to be
        -- rendered on its own; especially for models that chose random names for
        -- their main bone
        if isInWorld then
            bone = bone or boneEntity:LookupBone(boneEntity:GetBoneName(0))
        end

        if not bone then
            return
        end

        pos, ang = Vector(0, 0, 0), Angle(0, 0, 0)

        local matrix = boneEntity:GetBoneMatrix(bone)

        if matrix then
            pos, ang = matrix:GetTranslation(), matrix:GetAngles()
        end

        -- if the entity has no function to determine the owner it is probably a clientside entity
        -- meaning that no view model is needed since it only renders a world model
        if isfunction(wep.GetOwner) then
            local owner = wep:GetOwner()

            if
                IsValid(owner)
                and owner:IsPlayer()
                and boneEntity == owner:GetViewModel()
                and wep.ViewModelFlip
            then
                ang.r = -ang.r -- Fixes mirrored models
            end
        end
    end

    return pos, ang
end

---
-- Creates a clientside model that is used as a view or world model with the provided model data.
-- @param Entity wep The weapon for which the model should be created
-- @param ModelData modelData The model data for the model
-- @return table The new created model data table
-- @realm client
function weaponrenderer.CreateModel(wep, modelData)
    local modelDataCopy = table.FullCopy(modelData)

    -- handle a model being added to the view or world model
    if
        modelDataCopy.type == "Model"
        and modelDataCopy.model
        and modelDataCopy.model ~= ""
        and (not IsValid(modelDataCopy.modelEnt) or modelDataCopy.createdModel ~= modelDataCopy.model)
        and string.find(modelDataCopy.model, ".mdl")
        and file.Exists(modelDataCopy.model, "GAME")
    then
        modelDataCopy.modelEnt = ClientsideModel(modelDataCopy.model)

        if IsValid(modelDataCopy.modelEnt) then
            -- for clientside entities wep:GetPos is not defined; since a view model is not needed
            -- for these entities, this can be ignored
            if isfunction(wep.GetPos) then
                modelDataCopy.modelEnt:SetPos(wep:GetPos())
                modelDataCopy.modelEnt:SetAngles(wep:GetAngles())
                modelDataCopy.modelEnt:SetParent(wep)
                modelDataCopy.modelEnt:SetNoDraw(true)
            end
            modelDataCopy.createdModel = modelDataCopy.model
        else
            modelDataCopy.modelEnt = nil
        end

    -- handle a sprite being added to the view or world model
    elseif
        modelDataCopy.type == "Sprite"
        and modelDataCopy.sprite
        and modelDataCopy.sprite ~= ""
        and (not modelDataCopy.spriteMaterial or modelDataCopy.createdSprite ~= modelDataCopy.sprite)
        and file.Exists("materials/" .. modelDataCopy.sprite .. ".vmt", "GAME")
    then
        local name = modelDataCopy.sprite .. "-"
        local params = {
            ["$basetexture"] = modelDataCopy.sprite,
        }

        -- make sure we create a unique name based on the selected options
        for i = 1, #propertiesMaterial do
            local property = propertiesMaterial[i]

            if modelDataCopy[property] then
                params["$" .. property] = 1
                name = name .. "1"
            else
                name = name .. "0"
            end
        end

        modelDataCopy.createdSprite = modelDataCopy.sprite
        modelDataCopy.spriteMaterial = CreateMaterial(name, "UnlitGeneric", params)
    end

    return modelDataCopy
end

---
-- Resets the bone positions of a view model.
-- @param Entity viewModel The view model of the weapon
-- @realm client
function weaponrenderer.ResetBonePositions(viewModel)
    if not IsValid(viewModel) then
        return
    end

    local boneCount = viewModel:GetBoneCount()

    if not boneCount then
        return
    end

    for i = 0, boneCount do
        viewModel:ManipulateBoneScale(i, Vector(1, 1, 1))
        viewModel:ManipulateBoneAngles(i, Angle(0, 0, 0))
        viewModel:ManipulateBonePosition(i, Vector(0, 0, 0))
    end
end

---
-- Updates the bone positions of the view model of a weapon. If there are
-- none setup yet, it will reset it to a default state.
-- @param Entity wep The weapon for which the view model should be updated
-- @param Entity viewModel The view model of the weapon
-- @realm client
function weaponrenderer.UpdateBonePositions(wep, viewModel)
    if not wep.customViewModelBoneMods then
        weaponrenderer.ResetBonePositions(viewModel)

        return
    end

    for i = 0, viewModel:GetBoneCount() do
        local bonename = viewModel:GetBoneName(i)
        local dataTable

        if wep.customViewModelBoneMods[bonename] then
            dataTable = wep.customViewModelBoneMods[bonename]
        else
            dataTable = {
                scale = Vector(1, 1, 1),
                pos = Vector(0, 0, 0),
                angle = Angle(0, 0, 0),
            }
        end

        local scale = dataTable.scale
        local position = dataTable.pos
        local modelScale = Vector(1, 1, 1)

        local currentBone = viewModel:GetBoneParent(i)

        while currentBone >= 0 do
            local viewModelBoneMod = wep.customViewModelBoneMods[viewModel:GetBoneName(currentBone)]

            if viewModelBoneMod then
                modelScale = modelScale * viewModelBoneMod.scale
            end

            currentBone = viewModel:GetBoneParent(currentBone)
        end

        scale = scale * modelScale

        if viewModel:GetManipulateBoneScale(i) ~= scale then
            viewModel:ManipulateBoneScale(i, scale)
        end

        if viewModel:GetManipulateBoneAngles(i) ~= dataTable.angle then
            viewModel:ManipulateBoneAngles(i, dataTable.angle)
        end

        if viewModel:GetManipulateBonePosition(i) ~= position then
            viewModel:ManipulateBonePosition(i, position)
        end
    end
end

---
-- Returns an ordered elements table. The render order is necessary
-- because models have to be drawn before sprites and quads.
-- @param table elements the view elements table
-- @return table Returns a new or the cached render order
-- @realm client
local function BuildRenderOrder(elements)
    local newRenderOrder = {}

    for identifier, dataTable in pairs(elements) do
        if dataTable.type == "Model" then
            table.insert(newRenderOrder, 1, identifier)
        elseif dataTable.type == "Sprite" or dataTable.type == "Quad" then
            table.insert(newRenderOrder, identifier)
        end
    end

    return newRenderOrder
end

---
-- Renders the world or view model.
-- @param Entity wep The weapon whose view or world model should be rendered
-- @param table elements The elements of the view or world model
-- @param Entity boneEntity The bone entity, can be the view model, the player or the weapon
-- @realm client
function weaponrenderer.Render(wep, elements, boneEntity)
    local renderOrder = BuildRenderOrder(elements)

    -- if a model has a hand bone, it is probably created as a weapon and should therefore
    -- be handled that way. If a model is abused as a weapon then it doesn't have a handbone
    -- and should therefore not be rotated
    local boneId = boneEntity:LookupBone("ValveBiped.Bip01_R_Hand")
    local hasHandBone = boneId and boneId ~= "__INVALIDBONE__"

    for i = 1, #renderOrder do
        local identifier = renderOrder[i]
        local modelData = elements[identifier]

        if modelData.hide or not modelData.bone then
            continue
        end

        local model = modelData.modelEnt
        local sprite = modelData.spriteMaterial

        local pos, ang = GetBoneOrientation(wep, elements, modelData, boneEntity, not hasHandBone)

        if not pos then
            continue
        end

        local posModel = pos

        if hasHandBone then
            posModel = posModel
                + ang:Forward() * modelData.pos.x
                + ang:Right() * modelData.pos.y
                + ang:Up() * modelData.pos.z
        end

        if modelData.type == "Model" and IsValid(model) then
            if hasHandBone then
                model:SetPos(posModel)

                ang:RotateAroundAxis(ang:Up(), modelData.angle.y)
                ang:RotateAroundAxis(ang:Right(), modelData.angle.p)
                ang:RotateAroundAxis(ang:Forward(), modelData.angle.r)

                model:SetAngles(ang)

                local matrix = Matrix()
                matrix:Scale(modelData.size)

                model:EnableMatrix("RenderMultiply", matrix)
            end

            model:SetMaterial(modelData.material)

            if modelData.skin then
                model:SetSkin(modelData.skin)
            end

            if modelData.bodygroup then
                for bodygroup, value in pairs(modelData.bodygroup) do
                    wep:SetBodygroup(bodygroup, value)
                end
            end

            if modelData.surpresslightning then
                render.SuppressEngineLighting(true)
            end

            render.SetColorModulation(
                modelData.color.r / 255,
                modelData.color.g / 255,
                modelData.color.b / 255
            )
            render.SetBlend(modelData.color.a / 255)

            model:DrawModel()

            render.SetBlend(1)
            render.SetColorModulation(1, 1, 1)

            if modelData.surpresslightning then
                render.SuppressEngineLighting(false)
            end
        elseif modelData.type == "Sprite" and sprite then
            render.SetMaterial(sprite)
            render.DrawSprite(posModel, modelData.size.x, modelData.size.y, modelData.color)
        elseif modelData.type == "Quad" and modelData.draw_func then
            ang:RotateAroundAxis(ang:Up(), modelData.angle.y)
            ang:RotateAroundAxis(ang:Right(), modelData.angle.p)
            ang:RotateAroundAxis(ang:Forward(), modelData.angle.r)

            cam.Start3D2D(posModel, ang, modelData.size)
            modelData.draw_func(wep)
            cam.End3D2D()
        end
    end
end

---
-- Renders the view model if valid view model elements are provided. It also updates the bone
-- positions so that the view model tracks the hands.
-- @param Entity wep The weapon whose view model should be rendered
-- @param table elements The elements of the view model
-- @param Entity viewModel The player's view model
-- @realm client
function weaponrenderer.RenderViewModel(wep, elements, viewModel)
    if not elements then
        return
    end

    weaponrenderer.UpdateBonePositions(wep, viewModel)

    weaponrenderer.Render(wep, elements, viewModel)
end

---
-- Renders the wold model if valid wold model elements are provided. It also renders the default
-- world model of the weapon if enabled
-- @param Entity wep The weapon whose world model should be rendered
-- @param Entity wepModel The weapon mode whose world model should be rendered, in most cases
-- identical to the first parameter
-- @param table elements The elements of the world model
-- @param[opt] Player owner The owner entity of the weapon, binds the model to their hands
-- @realm client
function weaponrenderer.RenderWorldModel(wep, wepModel, elements, owner)
    -- note: while ShowDefaultWorldModel is set to true in the weapon base, addons such as TFA do not
    -- use the weapon base and only implement parts of it to work with TTT. In a perfect world TFA would
    -- be updated to fix this issue, but we can also prevent it by explicitly checking for false here.
    -- This means that `nil` (when the weapon isn't based on our base) counts as `true` as well.
    if wep.ShowDefaultWorldModel ~= false then
        wepModel:DrawModel()
    end

    if not elements then
        return
    end

    local boneEnt

    if IsValid(owner) then
        boneEnt = owner
    else
        -- when the weapon is dropped for example
        boneEnt = wepModel
    end

    weaponrenderer.Render(wepModel, elements, boneEnt)
end
