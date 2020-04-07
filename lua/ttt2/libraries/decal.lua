if SERVER then
	AddCSLuaFile()

	return
end

local renderSetMaterial = render.SetMaterial

local function CopyVertices(point, u, v, normal, bnormal, tangent)
	local vert = table.Copy(point)
	vert.u = u or 0
	vert.v = v or 0
	vert.normal = normal or 1
	vert.bitnormal = bnormal or Vector(0,0,0)
	vert.tangent = tangent or 1

	return vert
end

local function VerticesFromCoordinates(coords, resolution)
	local amountX = resolution - 1
	local amountY = resolution - 1
	local devider = resolution - 1

	local vertices = {}

	for ix = 1, amountX do
		for iy = 1, amountY do
			local a = CopyVertices(coords[ix + 0][iy + 0], (ix + 0) / devider, 1 - ((iy + 0) / devider))
			local b = CopyVertices(coords[ix + 1][iy + 0], (ix + 1) / devider, 1 - ((iy + 0) / devider))
			local c = CopyVertices(coords[ix + 1][iy + 1], (ix + 1) / devider, 1 - ((iy + 1) / devider))
			local d = CopyVertices(coords[ix + 0][iy + 1], (ix + 0) / devider, 1 - ((iy + 1) / devider))

			-- add vertices into table to crreate two triangles per square
			vertices[#vertices + 1] = a
			vertices[#vertices + 1] = d
			vertices[#vertices + 1] = c
			vertices[#vertices + 1] = c
			vertices[#vertices + 1] = b
			vertices[#vertices + 1] = a
		end
	end

	return vertices
end

decal = decal or {
	registered = {},
	active = {}
}

function decal.Registered(materialName)
	return decal.registered[materialName] or false
end

function decal.Register(materialName, materialPath, size, resolution)
	if decal.Registered(materialName) then
		return false
	end

	decal.registered[materialName] = {
		material = Material(materialPath),
		size = size,
		resolution = resolution
	}
end

function decal.GetMaterial(materialName)
	if not decal.Registered(materialName) then return end

	return decal.registered[materialName].material
end

function decal.Exists(identifier)
	-- we're using a indexed list here since it is faster to iterate
	-- in a draw environment, the small drawback for this check
	-- is therefore neglectable
	for i = 1, #decal.active do
		if decal.active[i].identifier == identifier then
			return true
		end
	end

	return false
end

function decal.Remove(identifier)
	for i = 1, #decal.active do
		decalActive = decal.active[i]

		if decalActive.identifier == identifier then
			decalActive.mesh:Destroy()

			table.remove(decal.active, i)

			return true
		end
	end

	return false
end

function decal.Paint(identifier, materialName, startPos, endPos, filter)
	if decal.Exists(identifier) then
		return false
	end

	if not decal.Registered(materialName) then
		return false
	end

	local centerTrace = util.TraceLine({
		start = startPos,
		endpos = endPos,
		filter = filter,
		mask = MASK_SOLID
	})

	if not centerTrace.HitWorld then
		return false
	end

	local center = centerTrace.HitPos
	local normal = centerTrace.HitNormal

	local data = decal.registered[materialName]
	local size = data.size
	local shift = 0.5 * size
	local resolution = data.resolution
	local step = size / (resolution - 1)

	local points = {}

	for x = - 1 * shift, shift, step do
		points[#points + 1] = {}

		for y = - 1 * shift, shift, step do
			local point = center + Vector(x, y, 0)

			local pointTrace = util.TraceLine({
				start = point + 16 * normal,
				endpos = point - 16 * normal,
				filter = filter,
				mask = MASK_SOLID
			})

			points[#points][#points[#points] + 1] = {
				pos = pointTrace.HitPos + Vector(0, 0, 1)
			}
		end
	end

	local vertices = VerticesFromCoordinates(points, resolution)

	local mesh = Mesh()
	mesh:BuildFromTriangles(vertices)

	decal.active[#decal.active + 1] = {
		identifier = identifier,
		materialName = materialName,
		points = points,
		vertices = vertices,
		mesh = mesh
	}
end

function decal.PaintDown(identifier, materialName, filter)

end


hook.Add("PostDrawOpaqueRenderables", "TTT2DrawRemovableDecals", function()
	for i = 1, #decal.active do
		local dec = decal.active[i]

		renderSetMaterial(decal.GetMaterial(dec.materialName))
		dec.mesh:Draw()
	end
end)
