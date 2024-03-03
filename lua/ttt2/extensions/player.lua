---
-- Functions that are related to players in general
-- @module player

if SERVER then
    AddCSLuaFile()
end

if SERVER then
    player.playerSettingRegistry = {}

    ---
    -- Registers a synced client setting on the server. This has to be done so that settings set by
    -- `ply:SetSettingOnServer` are not discarded on the server.
    -- @param string identifier The identifier of the synced setting
    -- @param string type The data type of the setting, e.g. `number`, `bool` or `string`
    -- @realm server
    function player.RegisterSettingOnServer(identifier, type)
        player.playerSettingRegistry[identifier] = type
    end
end
