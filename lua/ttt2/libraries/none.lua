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
-- @param string varname the name the tbl @{table} should have as key value
-- @param string name the name that should be concatenated to the prefix "Get" and "Set"
-- @deprecated
-- @realm shared
function AccessorFuncDT(tbl, varname, name)
    ErrorNoHaltWithStack(
        "[DEPRECATION WARNING] Using `AccessorFuncDT` is deprecated and will be removed in a future version."
    )
    tbl["Get" .. name] = function(s)
        return s.dt and s.dt[varname]
    end

    tbl["Set" .. name] = function(s, v)
        if s.dt then
            s.dt[varname] = v
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
