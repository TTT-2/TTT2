---
-- Shared corpsey stuff
-- @module CORPSE

CORPSE = CORPSE or {}

local IsValid = IsValid

-- Manual datatable indexing
CORPSE.dti = {
    BOOL_FOUND = 0,
    ENT_PLAYER = 0,
    INT_CREDITS = 0,
}

CORPSE.cv = {
    ---
    -- @realm shared
    identify_body_woconfirm = CreateConVar(
        "ttt_identify_body_woconfirm",
        "1",
        { FCVAR_NOTIFY, FCVAR_ARCHIVE, FCVAR_REPLICATED },
        "Toggles whether ragdolls should be confirmed in gameloop.IsDetectiveMode() without clicking on confirm espacially"
    ),
}

local dti = CORPSE.dti

---
-- Returns whether a @{CORPSE} was found already
-- @param Entity rag
-- @param boolean default
-- @return boolean
-- @note networked data abstraction
-- @realm shared
function CORPSE.GetFound(rag, default)
    return rag and rag:GetDTBool(dti.BOOL_FOUND) or default
end

---
-- Returns the @{Player}'s nickname of the CORPSE
-- @param Entity rag
-- @param string default
-- @return string
-- @realm shared
function CORPSE.GetPlayerNick(rag, default)
    if not IsValid(rag) then
        return default
    end

    local ply = rag:GetDTEntity(dti.ENT_PLAYER)

    if IsValid(ply) then
        return ply:Nick()
    else
        return rag:GetNWString("nick", default)
    end
end

---
-- Returns the amount of credits which are stored in the CORPSE
-- @param Entity rag
-- @param number default
-- @return number
-- @realm shared
function CORPSE.GetCredits(rag, default)
    if not IsValid(rag) then
        return default
    end

    return rag:GetDTInt(dti.INT_CREDITS)
end

---
-- Returns the owner of a CORPSE
-- @param Entity rag
-- @return Player owner
-- @realm shared
function CORPSE.GetPlayer(rag)
    if not IsValid(rag) then
        return NULL
    end

    return rag:GetDTEntity(dti.ENT_PLAYER)
end

---
-- Checks if a ragdoll belongs to a player.
-- Because ragdolls can also be used for props (e.g. a mattress).
-- @param Entity rag The ragdoll
-- @return boolean Returns if the ragdoll is valid
-- @realm shared
function CORPSE.IsValidBody(rag)
    return IsValid(rag) and CORPSE.GetPlayerNick(rag, false) ~= false
end

---
-- Checks if this corpse is a real corpse. There can be fake corpses that
-- are tied to a specific player that are not real corpses
-- @param Entity rag The ragdoll
-- @return boolean Returns if the ragdoll is a real player corpse
-- @realm shared
function CORPSE.IsRealPlayerCorpse(rag)
    return rag:GetNWBool("real_player_corpse", false)
end
