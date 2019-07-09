-- this is a massively performance improved version of entity rendering (highlighting) with caching

local baseclass = baseclass
local list = list
local pairs = pairs

local marksList = {}
local marksHookInstalled = false

module("marks", package.seeall)

if SERVER then
	AddCSLuaFile()
else
	-- this was made by Bletotum and improved by Alf21
	local function Render(ents, col, pos, ang)
		-- check for valid data
		local tmp = {}
		local index = 1

		for _, ent in ipairs(ents) do
			if not ent:IsPlayer() or ent:Alive() and ent:IsTerror() then
				tmp[index] = ent
				index = index + 1
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
		-- workaround via 3D2D

		cam.Start3D2D(pos, ang, 1)

		surface.SetDrawColor(clr(col))
		surface.DrawRect(-ScrW(), -ScrH(), ScrW() * 2, ScrH() * 2)

		cam.End3D2D()

		for _, ent in ipairs(tmp) do
			ent:DrawModel()
		end

		render.SetStencilEnable(false)
	end

	local function RenderHook()
		local client = LocalPlayer()
		local ang = client:EyeAngles()
		local pos = client:EyePos() + ang:Forward() * 10

		ang = Angle(ang.p + 90, ang.y, 0)

		for _, list in pairs(marksList) do
			Render(list.ents, list.col, pos, ang)
		end
	end

	local function AddMarksHook()
		if marksHookInstalled then return end

		hook.Add("PostDrawOpaqueRenderables", "RenderMarks", RenderHook)
	end

	local function RemoveMarksHook()
		hook.Remove("PostDrawOpaqueRenderables", "RenderMarks")

		marksHookInstalled = false
	end

	local function SetupMarkList(col)
		if not col then return end

		local str = tostring(col)

		marksList[str] = marksList[str] or {}
		marksList[str].ents = marksList[str].ents or {}
		marksList[str].col = col
	end

	function Clear()
		marksList = {}

		RemoveMarksHook()
	end

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
