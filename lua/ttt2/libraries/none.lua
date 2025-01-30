---
-- A bunch of random function bundled in no module globally
-- @author Mineotopia
-- @author LeBroomer
-- @author Alf21
-- @author tkindanight
-- @module none

if SERVER then
    AddCSLuaFile()
end

---
-- Color unpacking
-- @param Color color
-- @return number red value of the given color
-- @return number green value of the given color
-- @return number blue value of the given color
-- @return number alpha value of the given color
-- @realm shared
function clr(color)
    return color.r, color.g, color.b, color.a
end

---
-- This @{function} creates a getter and a setter @{function} for DTVars of an entity
-- The create @{function} names are based on the var name and the prefix "Get" and "Set"
-- @note Instead of using this function simply replace `ENT:DTVar()` calls with `ENT:NetworkVar()`.
-- @param table tbl the @{table} that should receive the Getter and Setter @{function}
-- @param string varName the name the tbl @{table} should have as key value
-- @param string name the name that should be concatenated to the prefix "Get" and "Set"
-- @deprecated
-- @realm shared
function AccessorFuncDT(tbl, varName, name)
    ErrorNoHaltWithStack(
        "[DEPRECATION WARNING] Using `AccessorFuncDT` is deprecated and will be removed in a future version."
    )
    tbl["Get" .. name] = function(s)
        return s.dt and s.dt[varName]
    end

    tbl["Set" .. name] = function(s, v)
        if s.dt then
            s.dt[varName] = v
        end
    end
end

---
-- Adds simple Get/Set accessor functions on the specified table. Can also force the value to be set to a number, bool or string.
-- @ref https://wiki.facepunch.com/gmod/Global.AccessorFunc
-- @param table tableScope The table to add the accessor functions to
-- @param string varName The key of the table to be get/set
-- @param string name The name of the functions (will be prefixed with Get and Set)
-- @param[opt] number forceType The type the setter should force to (uses FORCE enum)
-- @param[default=false] returnSelf Makes Setters return a reference to itself
-- @realm shared
function AccessorFunc(tableScope, varName, name, forceType, returnSelf)
    if not tableScope then
        debug.Trace()
    end

    tableScope["Get" .. name] = function(slf)
        return self[varName]
    end

    if forceType == FORCE_STRING then
        tableScope["Set" .. name] = function(slf, v)
            slf[varName] = tostring(v)

            if returnSelf then
                return slf
            end
        end

        return
    end

    if forceType == FORCE_NUMBER then
        tableScope["Set" .. name] = function(slf, v)
            slf[varName] = tonumber(v)

            if returnSelf then
                return slf
            end
        end

        return
    end

    if forceType == FORCE_BOOL then
        tableScope["Set" .. name] = function(slf, v)
            slf[varName] = tobool(v)

            if returnSelf then
                return slf
            end
        end

        return
    end

    if forceType == FORCE_ANGLE then
        tableScope["Set" .. name] = function(slf, v)
            slf[varName] = Angle(v)

            if returnSelf then
                return slf
            end
        end

        return
    end

    if forceType == FORCE_COLOR then
        tableScope["Set" .. name] = function(slf, v)
            if type(v) == "Vector" then
                slf[varName] = v:ToColor()
            else
                slf[varName] = string.ToColor(tostring(v))
            end

            if returnSelf then
                return slf
            end
        end

        return
    end

    if forceType == FORCE_VECTOR then
        tableScope["Set" .. name] = function(slf, v)
            if IsColor(v) then
                slf[varName] = v:ToVector()
            else
                slf[varName] = Vector(v)
            end

            if returnSelf then
                return slf
            end
        end

        return
    end

    tableScope["Set" .. name] = function(slf, v)
        slf[varName] = v

        if returnSelf then
            return slf
        end
    end
end

---
-- Short helper for input.LookupBinding, returns capitalised key or a default
-- @param string binding
-- @param string default
-- @return string
-- @realm shared
-- @ref https://wiki.facepunch.com/gmod/input.LookupBinding
function Key(binding, default)
    local b = input.LookupBinding(binding)
    if not b then
        return default
    end

    return string.upper(b)
end

---
-- Debugging function
-- @param number level required level
-- @param any ... anything that should be printed
-- @realm shared
function Dev(level, ...)
    if not cvars or cvars.Number("developer", 0) < level then
        return
    end

    Msg("[TTT dev]")
    -- table.concat does not tostring, derp

    local params = { ... }

    for i = 1, #params do
        Msg(" " .. tostring(params[i]))
    end

    Msg("\n")
end

---
-- A simple check whether a variable is a valid @{Player}
-- @param any var The variable that should be checked
-- @return boolean Returns true if the variable is a valid player
-- @realm shared
function IsPlayer(var)
    return var and isentity(var) and IsValid(var) and var:IsPlayer()
end

---
-- A simple check whether an @{Entity} is a valid ragdoll.
-- @param Entity ent
-- @return boolean
-- @deprecated Use @{ENTITY:IsPlayerRagdoll } instead
-- @realm shared
function IsRagdoll(ent)
    return IsValid(ent) and ent:IsPlayerRagdoll()
end
