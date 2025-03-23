---
-- Traitor equipment menu
-- @section shop

local GetTranslation = LANG.GetTranslation
local GetPTranslation = LANG.GetParamTranslation
local SafeTranslate = LANG.TryTranslation
local table = table
local net = net
local pairs = pairs
local IsValid = IsValid
local hook = hook

-- create ClientConVars

---
-- @realm client
local numColsVar = CreateConVar(
    "ttt_bem_cols",
    5,
    FCVAR_ARCHIVE,
    "Sets the number of columns in the Traitor/Detective menu's item list."
)

---
-- @realm client
local numRowsVar = CreateConVar(
    "ttt_bem_rows",
    6,
    FCVAR_ARCHIVE,
    "Sets the number of rows in the Traitor/Detective menu's item list."
)

---
-- @realm client
local itemSizeVar = CreateConVar(
    "ttt_bem_size",
    64,
    FCVAR_ARCHIVE,
    "Sets the item size in the Traitor/Detective menu's item list."
)

---
-- @realm client
local showCustomVar =
    CreateConVar("ttt_bem_marker_custom", 1, FCVAR_ARCHIVE, "Should custom items get a marker?")

---
-- @realm client
local showFavoriteVar =
    CreateConVar("ttt_bem_marker_fav", 1, FCVAR_ARCHIVE, "Should favorite items get a marker?")

---
-- @realm client
local showSlotVar =
    CreateConVar("ttt_bem_marker_slot", 1, FCVAR_ARCHIVE, "Should items get a slot-marker?")

---
-- @realm client
local alwaysShowShopVar = CreateConVar(
    "ttt_bem_always_show_shop",
    1,
    FCVAR_ARCHIVE,
    "Should the shop be opened/closed instead of the score menu during preparing / at the end of a round?"
)

---
-- @realm client
local enableDoubleClickBuy = CreateConVar(
    "ttt_bem_enable_doubleclick_buy",
    1,
    FCVAR_ARCHIVE,
    "Sets if you will be able to double click on an Item to buy it."
)

-- get serverside ConVars
local allowChangeVar = GetConVar("ttt_bem_allow_change")
local serverColsVar = GetConVar("ttt_bem_sv_cols")
local serverRowsVar = GetConVar("ttt_bem_sv_rows")
local serverSizeVar = GetConVar("ttt_bem_sv_size")

---
-- Some database functions of the shop

local color_bad = Color(244, 67, 54, 255)
--local color_good = Color(76, 175, 80, 255)
local color_darkened = Color(255, 255, 255, 80)

-- Buyable weapons are loaded automatically. Buyable items are defined in
-- equip_items_shd.lua

local eqframe = nil
local dlist = nil
local curSearch = nil

--
--     GENERAL HELPER FUNCTIONS
--

local function RolenameToRole(val)
    local rlsList = roles.GetList()

    for i = 1, #rlsList do
        local v = rlsList[i]

        if SafeTranslate(v.name) == val then
            return v.index
        end
    end

    return 0
end

local function ItemIsWeapon(item)
    return not items.IsItem(item.id)
end

local function CanCarryWeapon(item)
    return LocalPlayer():CanCarryWeapon(item)
end

--
-- Creates tabel of labels showing the status of ordering prerequisites
--

local function PreqLabels(parent, x, y)
    local client = LocalPlayer()

    local tbl = {}
    tbl.credits = vgui.Create("DLabel", parent)
    --tbl.credits:SetTooltip(GetTranslation("equip_help_cost"))
    tbl.credits:SetPos(x, y)

    -- coins icon
    tbl.credits.img = vgui.Create("DImage", parent)
    tbl.credits.img:SetSize(32, 32)
    tbl.credits.img:CopyPos(tbl.credits)
    tbl.credits.img:MoveLeftOf(tbl.credits)
    tbl.credits.img:SetImage("vgui/ttt/equip/coin.png")

    -- remaining credits text
    tbl.credits.Check = function(s, sel)
        local credits = client:GetCredits()
        local cr = sel and sel.credits or 1

        return credits >= cr,
            " " .. cr .. " / " .. credits,
            GetPTranslation("equip_cost", { num = credits })
    end

    tbl.owned = vgui.Create("DLabel", parent)
    --tbl.owned:SetTooltip(GetTranslation("equip_help_carry"))
    tbl.owned:CopyPos(tbl.credits)
    tbl.owned:MoveRightOf(tbl.credits, y * 5)

    -- carry icon
    tbl.owned.img = vgui.Create("DImage", parent)
    tbl.owned.img:SetSize(32, 32)
    tbl.owned.img:CopyPos(tbl.owned)
    tbl.owned.img:MoveLeftOf(tbl.owned)
    tbl.owned.img:SetImage("vgui/ttt/equip/briefcase.png")

    tbl.owned.Check = function(s, sel)
        if ItemIsWeapon(sel) and not CanCarryWeapon(sel) then
            return false,
                MakeKindValid(sel.Kind),
                GetPTranslation("equip_carry_slot", { slot = MakeKindValid(sel.Kind) })
        elseif not ItemIsWeapon(sel) and sel.limited and client:HasEquipmentItem(sel.id) then
            return false, "X", GetTranslation("equip_carry_own")
        else
            if ItemIsWeapon(sel) then
                local cv_maxCount = GetConVar(ORDERED_SLOT_TABLE[MakeKindValid(sel.Kind)])

                local maxCount = cv_maxCount and cv_maxCount:GetInt() or 0
                maxCount = maxCount < 0 and "∞" or maxCount

                return true,
                    " " .. #client:GetWeaponsOnSlot(MakeKindValid(sel.Kind)) .. " / " .. maxCount,
                    GetTranslation("equip_carry")
            else
                return true, "✔", GetTranslation("equip_carry")
            end
        end
    end

    -- TODO add global limited
    tbl.bought = vgui.Create("DLabel", parent)
    --tbl.bought:SetTooltip(GetTranslation("equip_help_stock"))
    tbl.bought:CopyPos(tbl.credits)
    tbl.bought:MoveBelow(tbl.credits, y * 2)

    -- stock icon
    tbl.bought.img = vgui.Create("DImage", parent)
    tbl.bought.img:SetSize(32, 32)
    tbl.bought.img:CopyPos(tbl.bought)
    tbl.bought.img:MoveLeftOf(tbl.bought)
    tbl.bought.img:SetImage("vgui/ttt/equip/package.png")

    tbl.bought.Check = function(s, sel)
        if sel.limited and client:HasBought(tostring(sel.id)) then
            return false, "X", GetTranslation("equip_stock_deny")
        else
            return true, "✔", GetTranslation("equip_stock_ok")
        end
    end

    -- custom info
    tbl.info = vgui.Create("DLabel", parent)
    --tbl.info:SetTooltip(GetTranslation("equip_help_stock"))
    tbl.info:CopyPos(tbl.bought)
    tbl.info:MoveRightOf(tbl.bought, y * 5)

    -- stock icon
    tbl.info.img = vgui.Create("DImage", parent)
    tbl.info.img:SetSize(32, 32)
    tbl.info.img:CopyPos(tbl.info)
    tbl.info.img:MoveLeftOf(tbl.info)
    tbl.info.img:SetImage("vgui/ttt/equip/icon_info")

    tbl.info.Check = function(s, sel)
        if not istable(sel) then
            return false, "X", "No table given."
        end

        local isBuyable, statusCode = shop.CanBuyEquipment(client, sel.id)
        local iconText = isBuyable and "✔" or "X"
        local tooltipText

        if statusCode == shop.statusCode.SUCCESS then
            tooltipText = "Ok"
        elseif statusCode == shop.statusCode.INVALIDID then
            ErrorNoHaltWithStack("[TTT2][ERROR] Missing id in table:", sel)
            PrintTable(sel)
            tooltipText = "No ID"
        elseif statusCode == shop.statusCode.NOTBUYABLE then
            tooltipText = "This equipment cannot be bought."
        elseif statusCode == shop.statusCode.NOTENOUGHPLAYERS then
            iconText = " " .. #util.GetActivePlayers() .. " / " .. sel.minPlayers
            tooltipText = "Minimum amount of active players needed."
        elseif statusCode == shop.statusCode.LIMITEDBOUGHT then
            tooltipText = "This equipment is limited and is already bought."
        elseif statusCode == shop.statusCode.GLOBALLIMITEDBOUGHT then
            tooltipText = "This equipment is globally limited and is already bought by someone."
        elseif statusCode == shop.statusCode.TEAMLIMITEDBOUGHT then
            tooltipText = "This equipment is limited in team and is already bought by a teammate."
        elseif statusCode == shop.statusCode.NOTBUYABLEFORROLE then
            tooltipText = "Your role can't buy this equipment."
        else
            tooltipText = "Undefined statusCode " .. tostring(statusCode)
        end

        return isBuyable, iconText, tooltipText
    end

    for _, pnl in pairs(tbl) do
        pnl:SetFont("DermaLarge")
        pnl:SetText(" - ")
    end

    return function(selected)
        local allow = true

        for _, pnl in pairs(tbl) do
            local result, text, tooltip = pnl:Check(selected)

            pnl:SetTextColor(result and COLOR_WHITE or color_bad)
            pnl:SetText(text)
            pnl:SizeToContents()
            pnl:SetTooltip(tooltip)

            pnl.img:SetImageColor(result and COLOR_WHITE or color_bad)
            pnl.img:SetTooltip(tooltip)

            allow = allow and result
        end

        return allow
    end
end

--
-- PANEL OVERRIDES
-- quick, very basic override of DPanelSelect
--

local PANEL = {}

local function DrawSelectedEquipment(pnl)
    surface.SetDrawColor(255, 200, 0, 255)
    surface.DrawOutlinedRect(0, 0, pnl:GetWide(), pnl:GetTall())
end

---
-- @param Panel pnl
-- @realm client
-- @local
function PANEL:SelectPanel(pnl)
    if not pnl then
        return
    end

    pnl.PaintOver = nil

    self.BaseClass.SelectPanel(self, pnl)

    if pnl then
        pnl.PaintOver = DrawSelectedEquipment
    end
end
vgui.Register("EquipSelect", PANEL, "DPanelSelect")

--
-- Create Equipment GUI / refresh
--

local function PerformStarLayout(s)
    s:AlignTop(2)
    s:AlignRight(2)
    s:SetSize(12, 12)
end

local function PerformMarkerLayout(s)
    s:AlignBottom(2)
    s:AlignRight(2)
    s:SetSize(16, 16)
end

local function CreateEquipmentList(t)
    t = t or {}

    setmetatable(t, {
        __index = {
            search = nil,
            role = nil,
            notalive = false,
        },
    })

    if t.search == LANG.GetTranslation("shop_search") .. "..." or t.search == "" then
        t.search = nil
    end

    -- icon size = 64 x 64
    if IsValid(dlist) then
        ---@cast dlist -nil
        dlist:Clear()
    else
        TraitorMenuPopup()

        return
    end

    local client = LocalPlayer()
    local currole = client:GetSubRole()
    local credits = client:GetCredits()

    local itemSize = 64

    if allowChangeVar:GetBool() then
        itemSize = itemSizeVar:GetInt()
    end

    -- make sure that the players old role is not used anymore
    if t.notalive then
        currole = t.role or ROLE_NONE
    end

    -- Determine if we already have equipment
    local owned_ids = {}
    local weps = client:GetWeapons()

    for i = 1, #weps do
        local wep = weps[i]

        if wep.IsEquipment and wep:IsEquipment() then
            owned_ids[#owned_ids + 1] = wep:GetClass()
        end
    end

    -- Stick to one value for no equipment
    if #owned_ids == 0 then
        owned_ids = nil
    end

    local itms = {}
    local tmp = GetEquipmentForRole(client, currole, t.notalive)

    for i = 1, #tmp do
        if not tmp[i].notBuyable then
            itms[#itms + 1] = tmp[i]
        end
    end

    if #itms == 0 and not t.notalive then
        client:ChatPrint(
            "[TTT2][SHOP] You need to run 'shopeditor' as admin in the developer console to create a shop for this role. Link it with another shop or click on the icons to add weapons and items to the shop."
        )

        return
    end

    -- temp table for sorting
    local paneltablefav = {}
    local paneltable = {}
    local col = client:GetRoleColor()

    for k = 1, #itms do
        local item = itms[k]
        local equipName = GetEquipmentTranslation(item.name, item.PrintName)

        if
            t.search and string.find(string.lower(equipName), string.lower(t.search), 1, true)
            or not t.search
        then
            local ic = nil

            -- Create icon panel
            if item.iconMaterial then
                ic = vgui.Create("LayeredIcon", dlist)

                if item.builtin and showCustomVar:GetBool() then
                    -- Custom marker icon
                    local marker = vgui.Create("DImage")
                    marker:SetImage("vgui/ttt/vskin/markers/builtin")
                    marker:SetImageColor(col)

                    marker.PerformLayout = PerformMarkerLayout

                    marker:SetTooltip(GetTranslation("builtin_marker"))

                    ic:AddLayer(marker)
                    ic:EnableMousePassthrough(marker)
                end

                -- Favorites marker icon
                ic.favorite = false

                if shop.IsFavorite(item.id) then
                    ic.favorite = true

                    if showFavoriteVar:GetBool() then
                        local star = vgui.Create("DImage")
                        star:SetImage("icon16/star.png")

                        star.PerformLayout = PerformStarLayout

                        star:SetTooltip("Favorite")

                        ic:AddLayer(star)
                        ic:EnableMousePassthrough(star)
                    end
                end

                -- Slot marker icon
                if ItemIsWeapon(item) and showSlotVar:GetBool() then
                    local slot = vgui.Create("SimpleIconLabelled")
                    slot:SetIcon("vgui/ttt/slotcap")
                    slot:SetIconColor(col or COLOR_LGRAY)
                    slot:SetIconSize(16)
                    slot:SetIconText(MakeKindValid(item.Kind))
                    slot:SetIconProperties(
                        COLOR_WHITE,
                        "DefaultBold",
                        { opacity = 220, offset = 1 },
                        { 10, 8 }
                    )

                    ic:AddLayer(slot)
                    ic:EnableMousePassthrough(slot)
                end

                ic:SetIconSize(itemSize or 64)
                ic:SetMaterial(item.iconMaterial)
            elseif item.itemModel then
                ic = vgui.Create("SpawnIcon", dlist)
                ic:SetModel(item.itemModel)
            else
                ErrorNoHaltWithStack(
                    "Equipment item does not have model or material specified:" .. equipName
                )
                PrintTable(item)

                continue
            end

            ic.item = item

            ic:SetTooltip(equipName .. " (" .. SafeTranslate(item.type) .. ")")

            -- If we cannot order this item, darken it
            if
                not t.notalive
                and (
                    (
                                                -- already owned
table.HasValue(owned_ids, item.id)
                        or items.IsItem(item.id) and item.limited and client:HasEquipmentItem(
                            item.id
                        )
                        -- already carrying a weapon for this slot
                        or ItemIsWeapon(item) and not CanCarryWeapon(item)
                        or not shop.CanBuyEquipment(client, item.id)
                        -- already bought the item before
                        or item.limited and client:HasBought(item.id)
                    ) or (item.credits or 1) > credits
                )
            then
                ic:SetIconColor(color_darkened)
            end

            if ic.favorite then
                paneltablefav[k] = ic
            else
                paneltable[k] = ic
            end

            -- icon doubleclick to buy
            ic.PressedLeftMouse = function(self, doubleClick)
                if
                    not doubleClick
                    or self.item.disabledBuy
                    or not enableDoubleClickBuy:GetBool()
                then
                    return
                end

                shop.BuyEquipment(client, self.item.id)

                ---@cast eqframe -nil
                eqframe:Close()
            end
        end
    end

    -- add favorites first
    for _, panel in pairs(paneltablefav) do
        dlist:AddPanel(panel)
    end

    -- non favorites second
    for _, panel in pairs(paneltable) do
        dlist:AddPanel(panel)
    end
end

local currentEquipmentCoroutine = coroutine.create(function(tbl)
    while true do
        tbl = coroutine.yield(CreateEquipmentList(tbl))
    end
end)

--
-- Create/Show Shop frame
--
--  dframe
--   \-> dsheet
--      \-> dequip
--         \-> dlist
--         \-> depanel
--            \-> dsearch
--         \-> dbtnpnl
--         \-> dinfobg
--            \-> dhelp
--
--

local color_bggrey = Color(90, 90, 95, 255)

---
-- Creates / opens the shop frame
-- @realm client
function TraitorMenuPopup()
    local client = LocalPlayer()

    if not IsValid(client) then
        return
    end

    local subrole = client:GetSubRole()
    local fallbackRole = GetShopFallback(subrole)
    local rd = roles.GetByIndex(fallbackRole)
    local notalive = false
    local fallback = GetGlobalString("ttt_" .. rd.abbr .. "_shop_fallback")

    if client:Alive() and client:IsActive() and fallback == SHOP_DISABLED then
        return
    end

    -- calculate dimensions
    local numCols, numRows, itemSize

    if allowChangeVar:GetBool() then
        numCols = numColsVar:GetInt()
        numRows = numRowsVar:GetInt()
        itemSize = itemSizeVar:GetInt()
    else
        numCols = serverColsVar:GetInt()
        numRows = serverRowsVar:GetInt()
        itemSize = serverSizeVar:GetInt()
    end

    -- margin
    local m = 5
    local itemSizePad = itemSize + 2

    -- item list width
    local dlistw = itemSizePad * numCols + 13
    local dlisth = itemSizePad * numRows + 13

    -- right column width
    local diw = 270

    -- frame size
    local w = dlistw + diw + m * 4
    local h = dlisth + 75

    -- Close shop if player clicks button again
    if IsValid(eqframe) then
        ---@cast eqframe -nil
        eqframe:Close()

        return
    end

    -- if the player is not alive / the round is not active let him choose his shop
    if not client:Alive() or not client:IsActive() then
        notalive = true
    end

    -- Close any existing traitor menu
    if IsValid(eqframe) then
        ---@cast eqframe -nil
        eqframe:Close()
    end

    local credits = client:GetCredits()
    local can_order = true
    local name = GetTranslation("equip_title")

    if GetGlobalBool("ttt2_random_shops") then
        name = name .. " (RANDOM)"
    end

    local dframe = vgui.Create("DFrame")
    dframe:SetSize(w, h)
    dframe:Center()
    dframe:SetTitle(name)
    dframe:SetVisible(true)
    dframe:ShowCloseButton(true)
    dframe:SetMouseInputEnabled(true)
    dframe:SetDeleteOnClose(true)

    local dsheet = vgui.Create("DPropertySheet", dframe)

    -- Add a callback when switching tabs
    local oldfunc = dsheet.SetActiveTab

    dsheet.SetActiveTab = function(self, new)
        if not IsValid(new) then
            return
        end

        if self.m_pActiveTab ~= new and self.OnTabChanged then
            self:OnTabChanged(self.m_pActiveTab, new)
        end

        oldfunc(self, new)
    end

    dsheet:SetPos(0, 0)
    dsheet:StretchToParent(m, m + 25, m, m)

    local padding = dsheet:GetPadding()

    local dequip = vgui.Create("DPanel", dsheet)
    dequip:SetPaintBackground(false)
    dequip:StretchToParent(padding, padding, padding, padding)

    -- Construct icon listing
    -- icon size = 64 x 64
    dlist = vgui.Create("EquipSelect", dequip)
    -- local dlistw = 288
    dlist:SetPos(0, 0)
    dlist:SetSize(dlistw, dlisth)
    dlist:EnableVerticalScrollbar(true)
    dlist:EnableHorizontal(true)

    coroutine.resume(currentEquipmentCoroutine, { notalive = notalive })

    local bw, bh = 100, 25 -- button size
    local dsph = 30 -- search panel height
    local drsh = 30 -- role select DComboBox height
    local depw = diw - m -- dequip panel width

    local depanel = vgui.Create("DPanel", dequip)
    depanel:SetSize(depw, dsph + m * 2)
    depanel:SetPos(dlistw + m, 0)
    depanel:SetMouseInputEnabled(true)
    depanel:SetPaintBackground(false)

    local dsearch = vgui.Create("DTextEntry", depanel)
    dsearch:SetSize(depw - 20, dsph)
    dsearch:SetPos(5, 5)
    dsearch:SetUpdateOnType(true)
    dsearch:SetEditable(true)
    dsearch:SetText(LANG.GetTranslation("shop_search") .. "...")

    dsearch.selectAll = true

    local dbph = bh + m
    local dbpw = bw + bh + m * 2

    local dbtnpnl = vgui.Create("DPanel", dequip)
    dbtnpnl:SetSize(dbpw, dbph)
    dbtnpnl:SetPos(dlistw + m, dlisth - dbph + 2)
    dbtnpnl:SetPaintBackground(false)

    local dconfirm = vgui.Create("DButton", dbtnpnl)
    dconfirm:SetPos(m, m)
    dconfirm:SetSize(bw, bh)
    dconfirm:SetEnabled(false)
    dconfirm:SetText(GetTranslation("equip_confirm"))

    --add a favorite button
    dfav = vgui.Create("DButton", dbtnpnl)
    dfav:CopyPos(dconfirm)
    dfav:MoveRightOf(dconfirm)
    dfav:SetSize(bh, bh)
    dfav:SetEnabled(true)
    dfav:SetText("")
    dfav:SetImage("icon16/star.png")

    --add a cancel button
    local dcancel = vgui.Create("DButton", dframe)
    dcancel:SetPos(w - m * 3 - bw, h - bh - m * 3)
    dcancel:SetSize(bw, bh)
    dcancel:SetEnabled(true)
    dcancel:SetText(GetTranslation("close"))

    local _, bpy = dbtnpnl:GetPos()

    local dinfobg = vgui.Create("DPanel", dequip)
    dinfobg:SetPaintBackground(false)
    dinfobg:SetPos(dlistw + m, 40)

    local drolesel = nil

    if notalive then
        dnotaliveHelp = vgui.Create("DLabel", dequip)
        dnotaliveHelp:SetText(GetTranslation("equip_not_alive"))
        dnotaliveHelp:SetFont("DermaLarge")
        dnotaliveHelp:SetWrap(true)
        dnotaliveHelp:DockMargin(10, 0, depanel:GetWide() + 10, 0)
        dnotaliveHelp:Dock(FILL)

        depanel:SetSize(depanel:GetWide(), depanel:GetTall() + drsh + m)

        drolesel = vgui.Create("DComboBox", depanel)
        drolesel:SetSize(depw - 20, drsh)
        drolesel:SetPos(m, dsph + m * 2)
        drolesel:MoveBelow(dsearch, m)

        local rlsList = roles.GetList()

        for k = 1, #rlsList do
            local v = rlsList[k]

            if v:IsShoppingRole() then
                drolesel:AddChoice(SafeTranslate(v.name))
            end
        end

        drolesel:SetValue(LANG.GetTranslation("shop_role_select") .. " ...")

        drolesel.OnSelect = function(panel, index, value)
            Dev(2, LANG.GetParamTranslation("shop_role_selected", { role = value }))

            dnotaliveHelp:SetText("")

            coroutine.resume(
                currentEquipmentCoroutine,
                { role = RolenameToRole(value), search = dsearch:GetValue(), notalive = notalive }
            )
        end

        dinfobg:MoveBelow(depanel, m)
    end

    local _, ibgy = dinfobg:GetPos()

    dinfobg:SetSize(diw - m, bpy - ibgy - 120) -- -90 to let the help panel have more size

    dsearch.OnValueChange = function(slf, text)
        if text == "" then
            text = nil
        end

        curSearch = text

        local crole

        if drolesel then
            crole = RolenameToRole(drolesel:GetValue())
        end

        coroutine.resume(
            currentEquipmentCoroutine,
            { search = text, role = crole, notalive = notalive }
        )
    end

    -- item info pane
    local dinfo = vgui.Create("DScrollPanel", dinfobg)
    dinfo:SetBackgroundColor(color_bggrey)
    dinfo:SetPaintBackground(true)
    dinfo:SetPos(0, 0)
    dinfo:StretchToParent(0, 0, m * 2, m * 2)

    local dfields = {}
    local _tmp = { "name", "type", "desc" }

    for i = 1, #_tmp do
        local k = _tmp[i]

        dfields[k] = vgui.Create("DLabel", dinfo)
        dfields[k]:SetTooltip(GetTranslation("equip_spec_" .. k))
        dfields[k]:SetPos(m * 3, m * 2)
        dfields[k]:SetWidth(diw - m * 6)
        dfields[k]:SetText("")
    end

    dfields.name:SetFont("TabLarge")

    dfields.type:SetFont("DermaDefault")
    dfields.type:MoveBelow(dfields.name)

    dfields.desc:SetFont("DermaDefaultBold")
    dfields.desc:SetContentAlignment(7)
    dfields.desc:MoveBelow(dfields.type, 1)

    local dhelp = vgui.Create("DPanel", dequip)
    dhelp:SetPaintBackground(false)
    dhelp:SetSize(diw, 116)
    dhelp:SetPos(dlistw + m, 0)
    dhelp:MoveBelow(dinfobg, 0)

    local update_preqs = PreqLabels(dhelp, m * 7, m * 2)

    dhelp:SizeToContents()

    dsheet:AddSheet(
        GetTranslation("equip_tabtitle"),
        dequip,
        "icon16/bomb.png",
        false,
        false,
        GetTranslation("equip_tooltip_main")
    )

    -- Item control
    if client:HasEquipmentItem("item_ttt_radar") then
        local dradar = RADAR.CreateMenu(dsheet, dframe)

        dsheet:AddSheet(
            GetTranslation("radar_name"),
            dradar,
            "icon16/magnifier.png",
            false,
            false,
            GetTranslation("equip_tooltip_radar")
        )
    end

    -- Credit transferring
    if credits > 0 then
        local dtransfer = CreateTransferMenu(dsheet)

        dsheet:AddSheet(
            GetTranslation("xfer_name"),
            dtransfer,
            "icon16/group_gear.png",
            false,
            false,
            GetTranslation("equip_tooltip_xfer")
        )
    end

    -- Random Shop Rerolling
    if shop.CanRerollShop(client) then
        local dtransfer = CreateRerollMenu(dsheet)

        dsheet:AddSheet(
            GetTranslation("reroll_name"),
            dtransfer,
            "vgui/ttt/equip/reroll.png",
            false,
            false,
            GetTranslation("equip_tooltip_reroll")
        )
    end

    ---
    -- @realm client
    hook.Run("TTTEquipmentTabs", dsheet)

    -- couple panelselect with info
    dlist.OnActivePanelChanged = function(_, _, new)
        if not IsValid(new) or not new.item then
            return
        end

        for k, v in pairs(new.item) do
            if dfields[k] then
                if k == "name" and new.item.PrintName then
                    dfields[k]:SetText(GetEquipmentTranslation(new.item.name, new.item.PrintName))
                else
                    dfields[k]:SetText(SafeTranslate(v))
                end

                dfields[k]:SetAutoStretchVertical(true)
                dfields[k]:SetWrap(true)
            end
        end

        -- Trying to force everything to update to
        -- the right size is a giant pain, so just
        -- force a good size.
        dfields.desc:SetTall(70)

        can_order = update_preqs(new.item)

        -- Easy accessable var for double-click buying
        new.item.disabledBuy = not can_order

        dconfirm:SetEnabled(can_order)
    end

    -- select first
    dlist:SelectPanel(dlist:GetItems()[1])

    -- prep confirm action
    dconfirm.DoClick = function()
        local pnl = dlist.SelectedPanel

        if not pnl or not pnl.item then
            return
        end

        local choice = pnl.item

        shop.BuyEquipment(client, choice.id)

        dframe:Close()
    end

    -- update some basic info, may have changed in another tab
    -- specifically the number of credits in the preq list
    dsheet.OnTabChanged = function(_, _, new)
        if not IsValid(new) or not IsValid(dlist.SelectedPanel) or new:GetPanel() ~= dequip then
            return
        end

        can_order = update_preqs(dlist.SelectedPanel.item)

        dlist.SelectedPanel.item.disabledBuy = not can_order

        dconfirm:SetEnabled(can_order)
    end

    dcancel.DoClick = function()
        dframe:Close()
    end

    dfav.DoClick = function()
        local pnl = dlist.SelectedPanel
        local role = drolesel and RolenameToRole(drolesel:GetValue()) or client:GetSubRole()

        if not pnl or not pnl.item then
            return
        end

        shop.SetFavoriteState(pnl.item.id, not pnl.favorite)

        -- Reload item list
        coroutine.resume(
            currentEquipmentCoroutine,
            { role = role, search = curSearch, notalive = notalive }
        )
    end

    dframe:MakePopup()
    dframe:SetKeyboardInputEnabled(false)

    eqframe = dframe
end
concommand.Add("ttt_cl_traitorpopup", TraitorMenuPopup)

--
-- Force closes the menu
--

local function ForceCloseTraitorMenu(ply, cmd, args)
    if IsValid(eqframe) then
        ---@cast eqframe -nil
        eqframe:Close()
    end
end
concommand.Add("ttt_cl_traitorpopup_close", ForceCloseTraitorMenu)

--
-- NET RELATED STUFF:
--

local r = 0

local function ReceiveBought()
    local client = LocalPlayer()
    if not IsValid(client) then
        return
    end

    client.bought = {}

    local num = net.ReadUInt(8)

    for i = 1, num do
        local equipmentName = net.ReadString()
        if equipmentName ~= "" then
            client.bought[#client.bought + 1] = equipmentName

            shop.SetEquipmentBought(LocalPlayer(), equipmentName)
            shop.SetEquipmentTeamBought(client, equipmentName)
        end
    end

    -- This usermessage sometimes fails to contain the last weapon that was
    -- bought, even though resending then works perfectly. Possibly a bug in
    -- bf_read. Anyway, this hack is a workaround: we just request a new umsg.
    if num ~= #client.bought and r < 10 then -- r is an infinite loop guard
        RunConsoleCommand("ttt_resend_bought")

        r = r + 1
    else
        r = 0
    end
end
net.Receive("TTT_Bought", ReceiveBought)

-- Player received the item he has just bought, so run clientside init
local function ReceiveBoughtItem()
    local id = net.ReadString()

    local item = items.GetStored(id)
    if item and isfunction(item.Bought) then
        item:Bought(LocalPlayer())
    end

    ---
    -- I can imagine custom equipment wanting this, so making a hook
    -- @realm client
    hook.Run("TTTBoughtItem", item ~= nil, (item and item.oldId or nil) or id)
end
net.Receive("TTT_BoughtItem", ReceiveBoughtItem)

--
-- HOOKS / GAMEMODE RELATED STUFF:
--

---
-- Called when the context menu keybind (+menu_context) is pressed, which by default is C.<br />
-- See also @{GM:OnContextMenuClose}.
-- @hook
-- @realm client
-- @ref https://wiki.facepunch.com/gmod/GM:OnContextMenuOpen
-- @local
function GM:OnContextMenuOpen()
    local rs = gameloop.GetRoundState()

    if (rs == ROUND_PREP or rs == ROUND_POST) and not alwaysShowShopVar:GetBool() then
        CLSCORE:Toggle()

        return
    end

    -- this will close the CLSCORE panel if its currently visible
    if IsValid(CLSCORE.Panel) and CLSCORE.Panel:IsVisible() then
        CLSCORE.Panel:SetVisible(false)

        return
    end

    ---
    -- @realm client
    if hook.Run("TTT2PreventAccessShop", LocalPlayer()) then
        return
    end

    if IsValid(eqframe) then
        ---@cast eqframe -nil
        eqframe:Close()
    else
        RunConsoleCommand("ttt_cl_traitorpopup")
    end
end

-- Closes menu when roles are selected
hook.Add("TTTBeginRound", "TTTBEMCleanUp", function()
    if not IsValid(eqframe) then
        return
    end

    ---@cast eqframe -nil
    eqframe:Close()
end)

-- Closes menu when round is overwritten
hook.Add("TTTEndRound", "TTTBEMCleanUp", function()
    if not IsValid(eqframe) then
        return
    end

    ---@cast eqframe -nil
    eqframe:Close()
end)

-- Search text field focus hooks
local function getKeyboardFocus(pnl)
    if IsValid(eqframe) and pnl:HasParent(eqframe) then
        ---@cast eqframe -nil
        eqframe:SetKeyboardInputEnabled(true)
    end

    if not pnl.selectAll then
        return
    end

    pnl:SelectAllText()
end
hook.Add("OnTextEntryGetFocus", "BEM_GetKeyboardFocus", getKeyboardFocus)

local function loseKeyboardFocus(pnl)
    if not IsValid(eqframe) or not pnl:HasParent(eqframe) then
        return
    end

    ---@cast eqframe -nil
    eqframe:SetKeyboardInputEnabled(false)
end
hook.Add("OnTextEntryLoseFocus", "BEM_LoseKeyboardFocus", loseKeyboardFocus)

---
-- Called after TTT's settings window has been created. Used to add
-- your own tab to the settings window.
-- @param DPropertySheet dSheet The property sheet where contents can be added
-- @hook
-- @realm client
function GM:TTTEquipmentTabs(dSheet) end

---
-- A clientside hook that is called on the client of the player
-- that just bought an item. You probably don't want to use this as it
-- is recommended to use @{ITEM:Bought}.
-- @param boolean True if item, false if weapon
-- @param string idOrCls The id of the @{ITEM} or @{Weapon}, old id for @{ITEM} and class for @{Weapon}
-- @hook
-- @realm client
function GM:TTTBoughtItem(isItem, idOrCls) end

---
-- Cancelable hook to prevent the usage of the shop on the client.
-- @param Player ply The player that tries to access the shop
-- @return boolean Return true to prevent shop access
-- @hook
-- @realm client
function GM:TTT2PreventAccessShop(ply) end
