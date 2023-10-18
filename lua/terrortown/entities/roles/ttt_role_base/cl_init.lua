---
-- @author Alf21
-- @author saibotk
-- @author Mineotopia
-- @class ROLE

---
-- This hook can be used by role addons to populate the role settings page
-- with custom convars. The parent is the submenu, where a new form has to
-- be added.
-- @param DPanel parent The parent panel which is the submenu
-- @hook
-- @realm client
function ROLE:AddToSettingsMenu(parent)

end

---
-- This hook can be used by role addons to populate the role credit settings form
-- with custom convars. The parent is the credits form, where menu elements can be
-- directly added.
-- @param DPanel parent The parent panel which is the credits form
-- @hook
-- @realm client
function ROLE:AddToSettingsMenuCreditsForm(parent)

end

-- todo change this so that users can overwrite this function
function ROLE:AddSyncedSettingsToRoleInfo(info)
    if self.name == "ttt_role_base" or self.name == "none" then return end

    info:MakeSyncedEntry(
        "ttt_" .. self.name .. "_pct",
        Material(), -- an icon
        function(value)
            return {
                body = "label_roleinfo_pct",
                params = {value = math.floor(1 / tonumber(value))}
            }
        end
    )
end
