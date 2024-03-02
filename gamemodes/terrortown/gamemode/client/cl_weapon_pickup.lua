-- picking up a weapon should update the client weapon cache
net.Receive("ttt2_switch_weapon_update_cache", function()
    -- this for now is a workaround to test if the timing of the refresh is the problem
    timer.Simple(0.25, function()
        local client = LocalPlayer()

        if not IsValid(client) or not client:IsReady() then
            return
        end

        WSWITCH:UpdateWeaponCache()
    end)
end)
