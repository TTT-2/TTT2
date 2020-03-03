---
-- A handler of the skin colors
-- @author Mineotopia

VSKIN = VSKIN or {}

---
-- Sets up the skins by scanning through the given directory; has to be
-- run on both client and server
-- @param string skin_path The path to search in
-- @internal
-- @realm shared
function VSKIN.SetupFiles(skin_path)
	local file_paths = {}

	local files = file.Find(skin_path .. "*.lua", "LUA")

	if not files then return end

	for i = 1, #files do
		file_paths[#file_paths + 1] = skin_path .. files[i]
	end

	for i = 1, #file_paths do
		local path = file_paths[i]

		-- filter out directories and temp files (like .lua~)
		if string.Right(path, 3) == "lua" then
			util.IncludeClientFile(path)

			MsgN("Included TTT2 VSkin file: " .. path)
		end
	end
end
