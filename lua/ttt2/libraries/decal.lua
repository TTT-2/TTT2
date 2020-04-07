if SERVER then
	AddCSLuaFile()

	util.AddNetworkString("TTT2PlaceDecal")

	---
	-- Paints a custom decal on the world and brushes, entities are ignored.
	-- @param @{Player}|table receiver A single player or a table of players that should receive this
	-- decal, sends it to all players if set to nil
	-- @param string identifier A unique identifier for this specific decal; decal placement fails
	-- if identifier is already used
	-- @param string materialName The material name registered by @{decal.Register}; decal placement
	-- fails if identifier is already used
	-- @param Vector startPos The starting position of the trace
	-- @param Vector endPos The end position of the trace
	-- @param [opt]table filter A table of objects that should be ignored
	-- @param [default=0]number displacement The displacement in y direction in units
	-- @realm server
	function decal.Paint(receiver, identifier, materialName, startPos, endPos, filter, displacement)
		net.Start("TTT2PlaceDecal")
		net.WriteString(identifier)
		net.WriteString(materialName)
		net.WriteVector(startPos)
		net.WriteVector(endPos)
		net.WriteTable(filter or {})
		net.WriteInt(displacement or 0, 16)

		if receiver then
			net.Send(receiver)
		else
			net.Broadcast()
		end
	end

	return
end

local renderSetMaterial = render.SetMaterial

local function CopyVertices(point, u, v, normal, bnormal, tangent)
	local vert = table.Copy(point)
	vert.u = u or 0
	vert.v = v or 0
	vert.normal = normal or 1
	vert.bitnormal = bnormal or Vector(0, 0, 0)
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
			local a = CopyVertices(coords[ix + 0][iy + 0], (ix - 1) / devider, 1 - ((iy - 1) / devider))
			local b = CopyVertices(coords[ix + 1][iy + 0], (ix + 0) / devider, 1 - ((iy - 1) / devider))
			local c = CopyVertices(coords[ix + 1][iy + 1], (ix + 0) / devider, 1 - ((iy + 0) / devider))
			local d = CopyVertices(coords[ix + 0][iy + 1], (ix - 1) / devider, 1 - ((iy + 0) / devider))

			-- add vertices into table to create two triangles per square
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

---
-- Checks if a decal with a given name is already registered
-- @param string materialName The unique name of a decal material
-- @return boolean Returns if a decal with this name is already registered
function decal.Registered(materialName)
	return decal.registered[materialName] or false
end

---
-- Registers a new decal taht can be used by @{decal.Paint}
-- @param string materialName The unique name of this decal material
-- @param string materialPath The path where the material is stored
-- @param number size The size in units of the decal, both sides have the same size
-- @param resolution The amount of points per side, this is used for the vertices
-- creation of the decal mesh
-- @return boolean Returns false if the registration failed
-- @realm client
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

---
-- Returns the @{Material} that is registered with a given materialName
-- @return Material|nil The material if it exists
-- @realm client
function decal.GetMaterial(materialName)
	if not decal.Registered(materialName) then return end

	return decal.registered[materialName].material
end

---
-- Checks if a decal with this identifier is already painted
-- @return boolean Returns if a decal with this identifier is already painted
-- @realm client
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

---
-- Removes an already painted decal
-- @param string identifier The identifier of the existing decal; fails if no decal with
-- this identifier was painted
-- @return boolean Returns false if decal removal failed
-- @realm client
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

---
-- Paints a custom decal on the world and brushes, entities are ignored.
-- @param string identifier A unique identifier for this specific decal; decal placement fails
-- if identifier is already used
-- @param string materialName The material name registered by @{decal.Register}; decal placement
-- fails if identifier is already used
-- @param Vector startPos The starting position of the trace
-- @param Vector endPos The end position of the trace
-- @param [opt]table filter A table of objects that should be ignored
-- @param [default=0]number displacement The displacement in y direction in units
-- @return boolean Returns false if the decal placement failed
-- @realm client
function decal.Paint(identifier, materialName, startPos, endPos, filter, displacement)
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
		mask = MASK_SOLID_BRUSHONLY
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
				mask = MASK_SOLID_BRUSHONLY
			})

			points[#points][#points[#points] + 1] = {
				pos = pointTrace.HitPos + Vector(0, 0, displacement or 0)
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

	return true
end

---
-- Paints a custom decal on the ground on the world and brushes, entities are ignored.
-- @param string identifier A unique identifier for this specific decal; decal placement fails
-- if identifier is already used
-- @param string materialName The material name registered by @{decal.Register}; decal placement
-- fails if identifier is already used
-- @param Vector startPos The starting position of the trace
-- @param [opt]table filter A table of objects that should be ignored
-- @param [default=0]number displacement The displacement in y direction in units
-- @return boolean Returns false if the decal placement failed
-- @realm client
function decal.PaintDown(identifier, materialName, startPos, filter, displacement)
	return decal.Paint(
		identifier,
		materialName,
		startPos,
		startPos - Vector(0, 0, 256),
		filter,
		displacement
	)
end

hook.Add("PostDrawOpaqueRenderables", "TTT2DrawRemovableDecals", function()
	for i = 1, #decal.active do
		local dec = decal.active[i]

		renderSetMaterial(decal.GetMaterial(dec.materialName))
		dec.mesh:Draw()
	end
end)

net.Receive("TTT2PlaceDecal", function()
	decal.Paint(
		net.ReadString(),
		net.ReadString(),
		net.ReadVector(),
		net.ReadVector(),
		net.ReadTable(),
		net.ReadInt(16)
	)
end)
