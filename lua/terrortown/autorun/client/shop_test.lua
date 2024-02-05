local menuFrame

--local offsetVec = Vector(8.5, -1.5, -3.6)

concommand.Add("shop", function()
    -- IF MENU ELEMENT DOES NOT ALREADY EXIST, CREATE IT
    if IsValid(menuFrame) then
        menuFrame:CloseFrame()

        return
    else
        menuFrame = vguihandler.GenerateFrame(1000, 750, "shop_title")
    end

    local profileBox1 = vgui.Create("DWeaponPreviewTTT2", menuFrame)
    profileBox1:SetSize(200, 300)
    profileBox1:SetPos(0, 50)
    profileBox1:SetPlayerModel(LocalPlayer():GetModel())
    profileBox1:SetWeaponClass("weapon_ttt_melonmine")
    profileBox1:SetHoverEffect(false)

    local profileBox2 = vgui.Create("DWeaponPreviewTTT2", menuFrame)
    profileBox2:SetSize(200, 300)
    profileBox2:SetPos(200, 50)
    profileBox2:SetPlayerModel(LocalPlayer():GetModel())
    profileBox2:SetWeaponClass("weapon_ttt_knife")

    local profileBox3 = vgui.Create("DWeaponPreviewTTT2", menuFrame)
    profileBox3:SetSize(200, 300)
    profileBox3:SetPos(400, 50)
    profileBox3:SetPlayerModel(LocalPlayer():GetModel())
    profileBox3:SetWeaponClass("melonlauncher")

    local profileBox4 = vgui.Create("DWeaponPreviewTTT2", menuFrame)
    profileBox4:SetSize(200, 300)
    profileBox4:SetPos(600, 50)
    profileBox4:SetPlayerModel(LocalPlayer():GetModel())
    profileBox4:SetWeaponClass("weapon_ttt_boomerang")

    local profileBox5 = vgui.Create("DWeaponPreviewTTT2", menuFrame)
    profileBox5:SetSize(200, 300)
    profileBox5:SetPos(800, 50)
    profileBox5:SetPlayerModel(LocalPlayer():GetModel())
    profileBox5:SetWeaponClass("weapon_ttt_m16")

    local profileBox6 = vgui.Create("DWeaponPreviewTTT2", menuFrame)
    profileBox6:SetSize(200, 300)
    profileBox6:SetPos(0, 350)
    profileBox6:SetPlayerModel(LocalPlayer():GetModel())
    profileBox6:SetWeaponClass("weapon_zm_improvised")

    local profileBox7 = vgui.Create("DWeaponPreviewTTT2", menuFrame)
    profileBox7:SetSize(200, 300)
    profileBox7:SetPos(200, 350)
    profileBox7:SetPlayerModel(LocalPlayer():GetModel())
    profileBox7:SetWeaponClass("ttt_m9k_harpoon")

    local profileBox8 = vgui.Create("DWeaponPreviewTTT2", menuFrame)
    profileBox8:SetSize(200, 300)
    profileBox8:SetPos(400, 350)
    profileBox8:SetPlayerModel(LocalPlayer():GetModel())
    profileBox8:SetWeaponClass("weapon_ttt_beacon")

    local profileBox9 = vgui.Create("DWeaponPreviewTTT2", menuFrame)
    profileBox9:SetSize(200, 300)
    profileBox9:SetPos(600, 350)
    profileBox9:SetPlayerModel(LocalPlayer():GetModel())
    profileBox9:SetWeaponClass("weapon_ttt_springmine")

    local profileBox10 = vgui.Create("DWeaponPreviewTTT2", menuFrame)
    profileBox10:SetSize(200, 300)
    profileBox10:SetPos(800, 350)
    profileBox10:SetPlayerModel(LocalPlayer():GetModel())
    profileBox10:SetWeaponClass("weapon_ttt_glock")
end)
