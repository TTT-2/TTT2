---
-- This is the <code>marks</code> module.
-- It massively improves the performance while rendering an entity (highlighting it) with caching
-- @author Alf21
module("marks", package.seeall)

local baseclass = baseclass
local list = list
local pairs = pairs

local marksList = {}
local marksHookInstalled = false

if SERVER then
	AddCSLuaFile()
else
	---
	-- Renders the entity based on the color
	-- @param table ents list of @{Entity}
	-- @param Color col color of rendering
	-- @param Vector pos position of client's view the rendering starts from
	-- @param Angle ang angle of client's view the rendering starts from
	-- @realm client
	local function Render(ents, col, pos, ang)
		-- check for valid data
		local tmp = {}
		local index = 1
		local remTable = nil

		for _, ent in ipairs(ents) do
			if not IsValid(ent) then -- search for invalid data
				remTable = remTable or {}
				remTable[#remTable + 1] = ent
			elseif not ent:IsPlayer() or ent:Alive() and ent:IsTerror() then
				tmp[index] = ent
				index = index + 1
			end
		end

		-- clear invalid data. Should just happen if a player disconnects or an entity is deleted
		if remTable then
			for _, ent in ipairs(remTable) do
				for k, v in ipairs(ents) do
					if v == ent then
						table.remove(ents, k)

						break
					end
				end
			end
		end

		if #tmp == 0 then return end

		render.ClearStencil()
		render.SetStencilEnable(true)
		render.SetStencilWriteMask(255)
		render.SetStencilTestMask(255)
		render.SetStencilReferenceValue(15)
		render.SetStencilFailOperation(STENCILOPERATION_KEEP)
		render.SetStencilZFailOperation(STENCILOPERATION_REPLACE)
		render.SetStencilPassOperation(STENCILOPERATION_KEEP)
		render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_ALWAYS)
		render.SetBlend(0)

		for _, ent in ipairs(tmp) do
			ent:DrawModel()
		end

		render.SetBlend(1)
		render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_EQUAL)

		-- stencil work is done in postdrawopaquerenderables, where surface doesn't work correctly
		-- workaround via 3D2D by Bletotum

		cam.Start3D2D(pos, ang, 1)

		surface.SetDrawColor(clr(col))
		surface.DrawRect(-ScrW(), -ScrH(), ScrW() * 2, ScrH() * 2)

		cam.End3D2D()

		for _, ent in ipairs(tmp) do
			ent:DrawModel()
		end

		render.SetStencilEnable(false)
	end

	---
	-- Hook that renders the entities with the highlighting
	-- @realm client
	local function RenderHook()
		local client = LocalPlayer()
		local ang = client:EyeAngles()
		local pos = client:EyePos() + ang:Forward() * 10

		ang = Angle(ang.p + 90, ang.y, 0)

		for _, list in pairs(marksList) do
			Render(list.ents, list.col, pos, ang)
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
	function Clear()
		marksList = {}

		RemoveMarksHook()
	end

	---
	-- Removes entities from the @{Entity} list
	-- @param table ents list of entities that should get removed
	-- @realm client
	function Remove(ents)
		if #ents == 0 or table.Count(marksList) == 0 then return end

		for _, ent in ipairs(ents) do
			for _, list in pairs(marksList) do
				local ret = nil

				for k, mark in ipairs(list.ents) do
					if ent == mark then
						table.remove(list.ents, k)

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
	function Add(ents, col)
		if #ents == 0 or not col then return end

		-- check if an entity is already inserted and remove it
		Remove(ents)

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
	function Set(ents, col)
		if not col or not istable(ents) then return end

		-- check if an entity is already inserted and remove it
		Remove(ents)

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
end
