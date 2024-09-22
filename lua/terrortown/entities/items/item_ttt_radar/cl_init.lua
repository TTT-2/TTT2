local math = math

---
-- @ignore
function ITEM:Equip(ply)
    RunConsoleCommand("ttt_radar_scan")
end

---
-- @ignore
function ITEM:DrawInfo()
    return math.ceil(math.max(0, (LocalPlayer().radarTime or 30) - (CurTime() - radar.startTime)))
end

---
-- @ignore
function ITEM:AddToSettingsMenu(parent)
    local form = vgui.CreateTTT2Form(parent, "header_equipment_additional")

    form:MakeSlider({
        serverConvar = "ttt2_radar_charge_time",
        label = "label_radar_charge_time",
        min = 0,
        max = 60,
        decimal = 0,
    })
end
