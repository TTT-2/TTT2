---
-- A file loading library for a custom ttt2 file loader
-- @author Mineotopia

if SERVER then
	AddCSLuaFile()
end

local fileFind = file.Find
local stringRight = string.Right

fileloader = fileloader or {}

---
-- Sets up files by scanning through directories and including them into the runtime.
-- @note Has to be run on both server and client for client and shared files.
-- @param string path The path to search in
-- @param[default=false] boolean deepsearch If true, subfolders are scanned
-- @param[default=SHARED] number realm The realm where the file should be included
-- @param[opt] funcion callback A function that is called after the file is included
-- @realm shared
function fileloader.LoadFolder(path, deepsearch, realm, callback)
	deepsearch = deepsearch or false
	realm = realm or SHARED

	local file_paths = {}

	if deepsearch then
		local _, sub_folders = fileFind(path .. "*", "LUA")

		if not sub_folders then return end

		for k = 1, #sub_folders do
			local subname = sub_folders[k]
			local files = fileFind(path .. subname .. "/*.lua", "LUA")

			if not files then continue end

			for i = 1, #files do
				file_paths[#file_paths + 1] = path .. subname .. "/" .. files[i]
			end
		end
	else
		local files = fileFind(path .. "*.lua", "LUA")

		if not files then return end

		for i = 1, #files do
			file_paths[#file_paths + 1] = path .. files[i]
		end
	end

	for i = 1, #file_paths do
		local file_path = file_paths[i]

		-- filter out directories and temp files (like .lua~)
		if stringRight(file_path, 3) ~= "lua" then continue end

		if SERVER and realm == CLIENT then
			AddCSLuaFile(file_path)
		elseif SERVER and realm == SHARED then
			AddCSLuaFile(file_path)
			include(file_path)
		elseif SERVER and realm ~= CLIENT then
			include(file_path)
		elseif CLIENT and realm ~= SERVER then
			include(file_path)
		else
			continue
		end

		if isfunction(callback) then
			callback(file_path, path, deepsearch, realm)
		end
	end
end
