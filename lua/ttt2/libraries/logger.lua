---
--- This is the <code>logger</code> module
--- @author G4PLS
--- @module logger

logger = logger or {}
logger.__index = logger

if SERVER then
    AddCSLuaFile()
end

function logger.New(name, enabled, timestamp_enabled)
    if name == nil then return end

    local instance = setmetatable({}, logger)

    instance.name = name
    instance.enabled = enabled ~= false
    instance.timestamp_enabled = timestamp_enabled ~= false
    instance.log_levels = {}

    return instance
end

---
--- Add a new Log Level to the current Logger
--- @param string log_level The name of the Log Level
--- @param string method_name The name of the method to call in the logger to log something
--- @param boolean enabled The start state of the log level
--- @param boolean timestamp_enabled Whether this log level should add the timestamp to the log
--- @realm shared
function logger:AddLogLevel(log_level, method_name, enabled, timestamp_enabled)
    if log_level == nil or method_name == nil then return end

    self.log_levels[log_level] = {
        log_level = log_level,
        method_name = method_name,
        enabled = enabled ~= false,
        timestamp_enabled = timestamp_enabled ~= false
    }

    self[method_name] = function(...)
        if not self.enabled then return end
        if not self.log_levels[log_level].enabled then return end

        local log_message = string.format("[%s %s]:", self.name, log_level)

        if self.timestamp_enabled and self.log_levels[log_level].timestamp_enabled then
            local current_time = os.date("%Y-%m-%d %H:%M:%S")
            log_message = string.format("[%s] %s", current_time, log_message)
        end

        print(log_message, ...)
    end
end

---
--- Removes a log level from the current logger
--- @param string log_level The log level to be removed
--- @realm shared
function logger:RemoveLogLevel(log_level)
    local current_log_level = self.log_levels[log_level]

    if current_log_level == nil then return end

    self[current_log_level] = nil
    self.log_levels[log_level] = nil
end