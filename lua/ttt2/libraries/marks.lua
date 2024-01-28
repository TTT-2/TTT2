---
-- This is the <code>marks</code> library.
-- It massively improves the performance while rendering an entity (highlighting it) with caching (compared with the default halo library)
-- @author Alf21
-- @todo make marksList sequential
-- @todo improve storing of list sizes
-- @module marks

local render = render
local table = table
local IsValid = IsValid
local hook = hook
local pairs = pairs

if SERVER then
	AddCSLuaFile()

	return
end

marks = {}

local marksList = {}
local marksHookInstalled = false

-- reuse the same memory for each render
local oldR, oldG, oldB = 1, 1, 1
local oldBlend = 1
local markedEnt = NULL
local markedColor = color_white

---
-- Renders marked models, this is a sub function for Render.
-- @param table markedEntsTable list of @{Entity}
-- @param Color col color of rendering
-- @param number size size of markedEntsTable table
-- @realm client
local function RenderMarkedModels(markedEntsTable, col, size)
	for i = 1, size do
		markedEnt = markedEntsTable[i]

		-- prevent messing up materials
		markedEnt:SetNoDraw(true)
		-- get/set the color of our marked entity
		markedColor = markedEnt:GetColor()
		oldR, oldG, oldB = render.GetColorModulation()
		render.SetColorModulation(markedColor.r / 255, markedColor.g / 255, markedColor.b / 255)
		-- get/set the transparency of our marked entity
		oldBlend = render.GetBlend()
		render.SetBlend(markedColor.a / 255)

		-- draw the entity
		markedEnt:DrawModel()

		-- reset the values back to what they were
		markedEnt:SetNoDraw(false)
		render.SetColorModulation(oldR, oldG, oldB)
		render.SetBlend(oldBlend)
	end
end

---
-- Renders the entity based on the color.
-- @param table markedEntsTable list of @{Entity}
-- @param Color col color of rendering
-- @realm client
local function Render(markedEntsTable, col)
	-- check for valid data
	local tmp = {}
	local index = 1
	local remTable = {}
	local remSize = 0

	local entsTableSize = #markedEntsTable

	for i = 1, entsTableSize do
		local ent = markedEntsTable[i]

		if not IsValid(ent) then -- search for invalid data
			remSize = remSize + 1
			remTable[remSize] = ent
		elseif not ent:IsPlayer() or ent:Alive() and ent:IsTerror() then
			tmp[index] = ent
			index = index + 1
		end
	end

	-- clear invalid data. Should just happen if a player disconnects or an entity is deleted
	if remSize ~= 0 then
		local tableRemove = table.remove

		for i = 1, remSize do
			for x = 1, entsTableSize do
				if markedEntsTable[x] == remTable[i] then
					tableRemove(markedEntsTable, x)

					entsTableSize = entsTableSize - 1

					break
				end
			end
		end
	end

	local size = #tmp
	if size == 0 then return end

	-- reset everything to known good values
	render.SetStencilWriteMask(0xFF)
	render.SetStencilTestMask(0xFF)
	render.SetStencilReferenceValue(0)
	render.SetStencilCompareFunction(STENCIL_ALWAYS)
	render.SetStencilPassOperation(STENCIL_KEEP)
	render.SetStencilFailOperation(STENCIL_KEEP)
	render.SetStencilZFailOperation(STENCIL_KEEP)
	render.ClearStencil()

	-- enable stencils
	render.SetStencilEnable(true)
	-- set the reference value to 1. This is what the compare function tests against
	render.SetStencilReferenceValue(1)

	-- always draw everything, since we need the ZFail to work we cannot use STENCIL_NEVER to avoid drawing to the RT
	render.SetStencilCompareFunction(STENCIL_ALWAYS)
	-- if something would draw to the screen but is behind something, set the pixels it draws to 1
	render.SetStencilZFailOperation(STENCIL_REPLACE)

	RenderMarkedModels(tmp, col, size)

	-- now we basically do the same thing again but this time we set stencil values to 0 if the operation passes
	-- this fixes the entity zfailing with itself
	render.SetStencilZFailOperation(STENCIL_KEEP)
	render.SetStencilPassOperation(STENCILOPERATION_ZERO)

	RenderMarkedModels(tmp, col, size)

	-- now, only draw things that have their pixels set to 1. This is the hidden parts of the stencil tests
	render.SetStencilCompareFunction(STENCIL_EQUAL)
	-- flush the screen. This will draw our color onto the screen
	render.ClearBuffersObeyStencil(col.r, col.g, col.b, col.a, false)

	-- let everything render normally again
	render.SetStencilEnable(false)
end

---
-- Hook that renders the entities with the highlighting
-- @realm client
local function RenderHook()
	for _, list in pairs(marksList) do
		Render(list.ents, list.col)
	end
end

---
-- Hook adding
-- @realm client
local function AddMarksHook()
	if marksHookInstalled then return end

	hook.Add("PostDrawOpaqueRenderables", "RenderMarks", RenderHook)
end

---
-- Hook removing
-- @realm client
local function RemoveMarksHook()
	hook.Remove("PostDrawOpaqueRenderables", "RenderMarks")

	marksHookInstalled = false
end

---
-- Initialization of the markers list
-- @realm client
local function SetupMarkList(col)
	if not col then return end

	local str = tostring(col)

	marksList[str] = marksList[str] or {}
	marksList[str].ents = marksList[str].ents or {}
	marksList[str].col = col
end

---
-- Clearing the cached @{Entity} list
-- @realm client
function marks.Clear()
	marksList = {}

	RemoveMarksHook()
end

---
-- Removes entities from the @{Entity} list
-- @param table ents list of entities that should get removed
-- @realm client
function marks.Remove(ents)
	local entsSize = #ents

	if entsSize == 0 or table.Count(marksList) == 0 then return end

	for i = 1, entsSize do
		local ent = ents[i]

		for _, list in pairs(marksList) do
			local ret = nil
			local size = #list.ents

			for x = 1, size do
				if ent == list.ents[x] then
					table.remove(list.ents, x)

					ret = true

					break
				end
			end

			if ret then break end
		end
	end

	if table.IsEmpty(marksList) then
		RemoveMarksHook()
	end
end

---
-- Adds entities into the @{Entity} list that should be rendered with a specific @{Color}
-- @param table ents list of @{Entity} that should be added
-- @param Color col the color the added entities should get rendered
-- @realm client
function marks.Add(ents, col)
	if #ents == 0 or not col then return end

	-- check if an entity is already inserted and remove it
	marks.Remove(ents)

	-- setup the table
	SetupMarkList(col)

	-- add entities into the table
	table.Add(marksList[tostring(col)].ents, ents)

	-- add the hook if there is something to render
	AddMarksHook()
end

---
-- Sets entities of the @{Entity} list that based on a specific @{Color}.
-- All the other previously inserted entities with the same color will get removed
-- @param table ents list of @{Entity} that should be set
-- @param Color col the color the added entities should get rendered
-- @usage marks.Set({}, COLOR_WHITE) -- this will clear all entities rendered in white
-- @realm client
function marks.Set(ents, col)
	if not col or not istable(ents) then return end

	-- check if an entity is already inserted and remove it
	marks.Remove(ents)

	-- set the entities or remove table if empty
	local str = tostring(col)

	SetupMarkList(col)

	if #ents == 0 then
		marksList[str] = nil
	else
		marksList[str].ents = ents
	end

	if table.IsEmpty(marksList) then
		RemoveMarksHook()
	else
		AddMarksHook()
	end
end
