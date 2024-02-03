---
-- Used to build custom world and view models. 
-- @author Mineotopia
-- @module modelbuilder

---@class ModelData
---@field type string The type of this model, it can be "Model", "SPrite" or "Quad"
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

modelbuilder = {}

local propertiesMaterial = {"nocull", "additive", "vertexalpha", "vertexcolor", "ignorez"}

---
-- Creates a clientside model that is used as a view or world model with the provided model data.
-- @param Entity wep The weapon for which the model should be created
-- @param ModelData modelData The model data for the model
-- @realm client
function modelbuilder.CreateModel(wep, modelData)
	-- handle a model being added to the view or world model
	if modelData.type == "Model" and modelData.model and modelData.model ~= ""
		and (not IsValid(modelData.modelEnt) or modelData.createdModel ~= modelData.model)
		and string.find(modelData.model, ".mdl") and file.Exists (modelData.model, "GAME")
	then
		modelData.modelEnt = ClientsideModel(modelData.model, RENDER_GROUP_VIEW_MODEL_OPAQUE) --todo check correct render group

		if IsValid(modelData.modelEnt) then
			modelData.modelEnt:SetPos(wep:GetPos())
			modelData.modelEnt:SetAngles(wep:GetAngles())
			modelData.modelEnt:SetParent(wep)
			modelData.modelEnt:SetNoDraw(true)
			modelData.createdModel = modelData.model
		else
			modelData.modelEnt = nil
		end

	-- handle a sprite being added to the view or world model
	elseif modelData.type == "Sprite" and modelData.sprite and modelData.sprite ~= ""
		and (not modelData.spriteMaterial or modelData.createdSprite ~= modelData.sprite)
		and file.Exists ("materials/" .. modelData.sprite .. ".vmt", "GAME")
	then
		local name = modelData.sprite .. "-"
		local params = {
			["$basetexture"] = modelData.sprite
		}

		-- make sure we create a unique name based on the selected options
		for i = 1, #propertiesMaterial do
			local property = propertiesMaterial[i]

			if modelData[property] then
				params["$" .. property] = 1
				name = name .. "1"
			else
				name = name .. "0"
			end
		end

		modelData.createdSprite = modelData.sprite
		modelData.spriteMaterial = CreateMaterial(name, "UnlitGeneric", params)
	end
end

---
-- Resets the bone positions of a view model.
-- @param Entity viewModel The view model of the weapon
-- @realm client
function modelbuilder.ResetBonePositions(viewModel)
	if not IsValid(viewModel) then return end

	local boneCount = viewModel:GetBoneCount()

	if not boneCount then return end

	for i = 0, boneCount do
		viewModel:ManipulateBoneScale(i, Vector(1, 1, 1))
		viewModel:ManipulateBoneAngles(i, Angle(0, 0, 0))
		viewModel:ManipulateBonePosition(i, Vector(0, 0, 0))
	end
end

---
-- Updates the bone positions of the view model of a weapon. Is used to hide a
-- default view model of a weapon.
-- @param Entity wep The weapon for which the view model should be updated
-- @param Entity viewModel The view model of the weapon
-- @realm client
function modelbuilder.UpdateBonePositions(wep, viewModel)
	if not wep.ViewModelBoneMods then
		modelbuilder.ResetBonePositions(viewModel)

		return
	end

	local allBones = {}

	for i = 0, viewModel:GetBoneCount() do
		local bonename = viewModel:GetBoneName(i)

		if wep.ViewModelBoneMods[bonename] then
			allBones[bonename] = wep.ViewModelBoneMods[bonename]
		else
			allBones[bonename] = {
				scale = Vector(1, 1, 1),
				pos = Vector(0, 0, 0),
				angle = Angle(0, 0, 0)
			}
		end
	end

	for identifier, dataTable in pairs(allBones) do
		local bone = viewModel:LookupBone(identifier)

		if not bone then continue end

		local scale = Vector(dataTable.scale.x, dataTable.scale.y, dataTable.scale.z)
		local position = Vector(dataTable.pos.x, dataTable.pos.y, dataTable.pos.z)
		local modelScale = Vector(1, 1, 1)

		local currentBone = viewModel:GetBoneParent(bone)

		while (currentBone >= 0) do
			modelScale = modelScale * allBones[viewModel:GetBoneName(currentBone)].scale
			currentBone = viewModel:GetBoneParent(currentBone)
		end

		scale = scale * modelScale

		if viewModel:GetManipulateBoneScale(bone) ~= scale then
			viewModel:ManipulateBoneScale(bone, scale)
		end

		if viewModel:GetManipulateBoneAngles(bone) ~= dataTable.angle then
			viewModel:ManipulateBoneAngles(bone, dataTable.angle)
		end

		if viewModel:GetManipulateBonePosition(bone) ~= position then
			viewModel:ManipulateBonePosition(bone, position)
		end
	end
end

---
-- Builds a render order or returns the cache if already built. The render order is necessary
-- because models have to be drawn before sprites and quads.
-- @param table elements the view elements table
-- @param table cachedRenderOrder The cached render order that is uesed as a fallback
-- @return table Returns a new or the cached render order
-- @realm client
function modelbuilder.BuildRenderOrder(elements, cachedRenderOrder)
	if cachedRenderOrder then
		return cachedRenderOrder
	end

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
-- Gets the orientation of a given bone.
-- @param Entity wep The weapon whose bone orientation is desired
-- @param table baseDataTable The base data table, most of the time the view elements
-- @param table dataTable The data table, most of the time the model data
-- @param Entity boneEntity The bone entity, can be the view model, the player or the weapon
-- @param string boneOverride An override to get a secific bone
-- @return Vector pos The bone position
-- @return Angle ang The bone angle
-- @realm client
function modelbuilder.GetBoneOrientation(wep, baseDataTable, dataTable, boneEntity, boneOverride)
	local bone, pos, ang

	if dataTable.rel and dataTable.rel ~= "" then
		local tbl = baseDataTable[dataTable.rel]

		if not tbl then return end

		-- Technically, if there exists an element with the same name as a bone
		-- you can get in an infinite loop. Let's just hope nobody's that stupid.
		pos, ang = modelbuilder.GetBoneOrientation(wep, baseDataTable, tbl, boneEntity)

		if not pos then return end

		pos = pos + ang:Forward() * tbl.pos.x + ang:Right() * tbl.pos.y + ang:Up() * tbl.pos.z

		ang:RotateAroundAxis(ang:Up(), tbl.angle.y)
		ang:RotateAroundAxis(ang:Right(), tbl.angle.p)
		ang:RotateAroundAxis(ang:Forward(), tbl.angle.r)
	else
		bone = boneEntity:LookupBone(boneOverride or dataTable.bone)

		if not bone then return end

		pos, ang = Vector(0,0,0), Angle(0,0,0)

		local matrix = boneEntity:GetBoneMatrix(bone)

		if matrix then
			pos, ang = matrix:GetTranslation(), matrix:GetAngles()
		end

		local owner = wep:GetOwner()

		if IsValid(owner) and owner:IsPlayer() and boneEntity == owner:GetViewModel() and wep.ViewModelFlip then
			ang.r = -ang.r -- Fixes mirrored models
		end
	end

	return pos, ang
end

---
-- Renders the world or view model.
-- @param Entity wep The weapon whose view model should be rendered
-- @param table renerOrder The render order of the view model elements
-- @param table elements The elements of the view model
-- @param Entity boneEntity The bone entity, can be the view model, the player or the weapon
-- @realm client
function modelbuilder.Render(wep, renderOrder, elements, boneEntity)
	for i = 1, #renderOrder do
		local identifier = renderOrder[i]
		local modelData = elements[identifier]

		if modelData.hide or not modelData.bone then continue end

		local model = modelData.modelEnt
		local sprite = modelData.spriteMaterial

		local pos, ang = modelbuilder.GetBoneOrientation(wep, elements, modelData, boneEntity)

		if not pos then continue end

		if modelData.type == "Model" and IsValid(model) then
			model:SetPos(pos + ang:Forward() * modelData.pos.x + ang:Right() * modelData.pos.y + ang:Up() * modelData.pos.z)
			ang:RotateAroundAxis(ang:Up(), modelData.angle.y)
			ang:RotateAroundAxis(ang:Right(), modelData.angle.p)
			ang:RotateAroundAxis(ang:Forward(), modelData.angle.r)

			model:SetAngles(ang)

			local matrix = Matrix()
			matrix:Scale(modelData.size)

			model:EnableMatrix("RenderMultiply", matrix)
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

			render.SetColorModulation(modelData.color.r / 255, modelData.color.g / 255, modelData.color.b / 255)
			render.SetBlend(modelData.color.a / 255)

			model:DrawModel()

			render.SetBlend(1)
			render.SetColorModulation(1, 1, 1)

			if modelData.surpresslightning then
				render.SuppressEngineLighting(false)
			end
		elseif modelData.type == "Sprite" and sprite then
			local drawpos = pos + ang:Forward() * modelData.pos.x + ang:Right() * modelData.pos.y + ang:Up() * modelData.pos.z
			render.SetMaterial(sprite)
			render.DrawSprite(drawpos, modelData.size.x, modelData.size.y, modelData.color)
		elseif modelData.type == "Quad" and modelData.draw_func then
			local drawpos = pos + ang:Forward() * modelData.pos.x + ang:Right() * modelData.pos.y + ang:Up() * modelData.pos.z
			ang:RotateAroundAxis(ang:Up(), modelData.angle.y)
			ang:RotateAroundAxis(ang:Right(), modelData.angle.p)
			ang:RotateAroundAxis(ang:Forward(), modelData.angle.r)

			cam.Start3D2D(drawpos, ang, modelData.size)
				modelData.draw_func(wep)
			cam.End3D2D()
		end
	end
end
