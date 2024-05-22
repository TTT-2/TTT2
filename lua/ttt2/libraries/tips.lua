---
-- Handles the gamemode tips
-- @author Mineotopia

if SERVER then
    AddCSLuaFile()

    return
end

tips = {}
tips.registry = {}

function tips.Register(tip, keys)
    tips.registry[#tips.registry + 1] = {
        tip = tip,
        keys = keys,
    }
end

function tips.GetRandomTip()
    local tip = tips.registry[math.random(#tips.registry)]

    return tip.tip, tip.keys or {}
end

function tips.Initialize()
    tips.Register("tip1", { walkkey = Key("+walk", "WALK"), usekey = Key("+use", "USE") })
    tips.Register("tip2")
    tips.Register("tip3")
    tips.Register("tip4")
    tips.Register("tip5")
    tips.Register("tip6")
    tips.Register("tip7")
    tips.Register("tip8")
    tips.Register("tip9")
    tips.Register("tip10")
    tips.Register("tip11")
    tips.Register("tip12")
    tips.Register("tip13")
    tips.Register("tip14")
    tips.Register("tip15")
    tips.Register("tip16")
    tips.Register("tip17")
    tips.Register("tip18")
    tips.Register("tip19")
    tips.Register("tip20")
    tips.Register("tip21")
    tips.Register("tip22")
    tips.Register("tip23")
    tips.Register("tip24", { helpkey = Key("+gm_showhelp", "F1") })
    tips.Register("tip25")
    tips.Register("tip26")
    tips.Register("tip27")
    tips.Register("tip28", { mutekey = Key("+gm_showteam", "F2") })
    tips.Register("tip29")
    tips.Register("tip30", { zoomkey = Key("+zoom", "the 'Suit Zoom' key") })
    tips.Register("tip31", { duckkey = Key("+duck", "DUCK") })
    tips.Register("tip32")
    tips.Register("tip33")
    tips.Register("tip34")
    tips.Register("tip35")
    tips.Register("tip36", { helpkey = Key("+gm_showhelp", "F1") })
    tips.Register("tip37")
    tips.Register("tip38")
    tips.Register("tip39")
    tips.Register("tip40")
end
