---
-- A file loading library for a custom ttt2 file loader
-- @author Mineotopia
-- @module fileloader

if SERVER then
    AddCSLuaFile()
end

CLIENT_FILE = 0
SERVER_FILE = 1
SHARED_FILE = 2

local fileFind = file.Find
local stringRight = string.Right

fileloader = fileloader or {}

---
-- Sets up files by scanning through directories and including them into the runtime.
-- @note Has to be run on both server and client for client and shared files.
-- @param string path The absolute path to search in, has to end with `/`
-- @param[default=false] boolean deepsearch If true, files are searched one level down inside all available subfolders
-- @param[default=SHARED_FILE] number realm The realm where the file should be included
-- @param[opt] function callback A function that is called after the file is included
-- @param[opt] function preFolderCallback A function that is called before the load of the given folder is started
-- @param[opt] function postFolderCallback A function that is called after the load of the given folder is finished
-- @realm shared
function fileloader.LoadFolder(
    path,
    deepsearch,
    realm,
    callback,
    preFolderCallback,
    postFolderCallback
)
    deepsearch = deepsearch or false
    realm = realm or SHARED_FILE

    local file_paths = {}

    if isfunction(preFolderCallback) then
        preFolderCallback(path, deepsearch, realm)
    end

    if deepsearch then
        local _, sub_folders = fileFind(path .. "*", "LUA")

        if not sub_folders then
            return
        end

        for k = 1, #sub_folders do
            local subname = sub_folders[k]
            local files = fileFind(path .. subname .. "/*.lua", "LUA")

            if not files then
                continue
            end

            for i = 1, #files do
                file_paths[#file_paths + 1] = path .. subname .. "/" .. files[i]
            end
        end
    else
        local files = fileFind(path .. "*.lua", "LUA")

        if not files then
            return
        end

        for i = 1, #files do
            file_paths[#file_paths + 1] = path .. files[i]
        end
    end

    for i = 1, #file_paths do
        local file_path = file_paths[i]

        -- filter out directories and temp files (like .lua~)
        if stringRight(file_path, 3) ~= "lua" then
            continue
        end

        if SERVER and realm == CLIENT_FILE then
            AddCSLuaFile(file_path)
        elseif SERVER and realm == SHARED_FILE then
            AddCSLuaFile(file_path)
            include(file_path)
        elseif SERVER and realm ~= CLIENT_FILE then
            include(file_path)
        elseif CLIENT and realm ~= SERVER_FILE then
            include(file_path)
        else
            continue
        end

        if isfunction(callback) then
            callback(file_path, path, deepsearch, realm)
        end
    end

    if isfunction(postFolderCallback) then
        postFolderCallback(file_paths, path, deepsearch, realm)
    end
end
