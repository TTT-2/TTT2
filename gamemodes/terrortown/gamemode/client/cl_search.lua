---
-- Body search popup
-- @section body_search_manager

-- cache global functions
local net = net
local pairs = pairs
local util = util
local IsValid = IsValid
local hook = hook

-- cache materials
local materialCredits = Material("vgui/ttt/icon_credits_transparent")
local materialRoleUnknown = Material("vgui/ttt/tid/tid_big_role_not_known")
local materialPlayerIconUnknown = Material("vgui/ttt/b-draw/icon_avatar_default")

net.Receive("TTT2SendConfirmMsg", function()
    local msgName = net.ReadString()
    local sid64 = net.ReadString()
    local clr = Color(net.ReadUInt(8), net.ReadUInt(8), net.ReadUInt(8), net.ReadUInt(8))
    local bool = net.ReadBool()

    local tbl = {}
    tbl.finder = net.ReadString()
    tbl.victim = net.ReadString()
    tbl.role = LANG.GetTranslation(net.ReadString())

    if bool then
        tbl.team = LANG.GetTranslation(net.ReadString())
    end

    local searchUID = net.ReadUInt(16)

    -- update credits on victim table
    local victimEnt = player.GetBySteamID64(tbl.victim)
    if IsValid(victimEnt) and victimEnt.searchResultData then
        victimEnt.searchResultData.credits = credits
    end

    -- checking for bots
    if sid64 == "" then
        sid64 = nil
    end

    local img = draw.GetAvatarMaterial(sid64, "medium")

    ---
    -- @realm client
    hook.Run("TTT2ConfirmedBody", tbl.finder, tbl.victim)

    MSTACK:AddColoredImagedMessage(LANG.GetParamTranslation(msgName, tbl), clr, img)

    if IsValid(SEARCHSCREEN.menuFrame) and SEARCHSCREEN.data.searchUID == searchUID then
        SEARCHSCREEN:UpdateUIWhenPlayerWasConfirmed()
    end
end)

net.Receive("ttt2_credits_were_taken", function()
    local searchUID = net.ReadUInt(16)

    if IsValid(SEARCHSCREEN.menuFrame) and SEARCHSCREEN.data.searchUID == searchUID then
        SEARCHSCREEN:UpdateUIWhenCreditsWereTaken()
    end
end)

---
-- @class SEARCHSCREEN
SEARCHSCREEN = SEARCHSCREEN or {}
SEARCHSCREEN.sizes = SEARCHSCREEN.sizes or {}
SEARCHSCREEN.menuFrame = SEARCHSCREEN.menuFrame or nil
SEARCHSCREEN.data = SEARCHSCREEN.data or {}
SEARCHSCREEN.infoBoxes = {}

---
-- Calculates and caches the dimensions of the bodysearch UI.
-- @realm client
function SEARCHSCREEN:CalculateSizes()
    self.sizes.width = 600
    self.sizes.height = 500
    self.sizes.padding = 10

    self.sizes.heightButton = 45
    self.sizes.widthButton = 160
    self.sizes.widthButtonCredits = 220
    self.sizes.widthButtonTakeCredits = 180
    self.sizes.widthButtonClose = 100
    self.sizes.heightBottomButtonPanel = self.sizes.heightButton + self.sizes.padding + 1

    self.sizes.widthMainArea = self.sizes.width - 2 * self.sizes.padding
    self.sizes.heightMainArea = self.sizes.height
        - self.sizes.heightBottomButtonPanel
        - 3 * self.sizes.padding
        - vskin.GetHeaderHeight()
        - vskin.GetBorderSize()

    self.sizes.widthProfileArea = 200

    self.sizes.widthContentArea = self.sizes.width
        - self.sizes.widthProfileArea
        - 3 * self.sizes.padding
    self.sizes.widthContentBox = self.sizes.widthContentArea - 2 * self.sizes.padding - 100

    self.sizes.heightInfoItem = 78
end

---
-- Updates the UI if the player, that is inspected right now, was confirmed.
-- @realm client
function SEARCHSCREEN:UpdateUIWhenPlayerWasConfirmed()
    self.buttonConfirm:SetEnabled(false)
    self.buttonConfirm:SetText("search_confirmed")
    self.buttonConfirm:SetIcon(nil)

    if not LocalPlayer():IsSpec() then
        self.buttonReport:SetEnabled(true)
    end

    -- remove hint about player needing to confirm corpse
    local confirmBox = self.infoBoxes["policingrole_call_confirm"]
    if IsValid(confirmBox) then
        confirmBox:Remove()
    end

    -- remove hint about player unable to confirm
    local confirmDisabledBox = self.infoBoxes["policingrole_confirm_disabled"]
    if IsValid(confirmDisabledBox) then
        confirmDisabledBox:Remove()
    end
end

---
-- Updates the UI if the player, that is inspected right now, lost their credits.
-- @realm client
function SEARCHSCREEN:UpdateUIWhenCreditsWereTaken()
    -- if credits were taken, remove credit box
    local creditBox = self.infoBoxes["credits"]
    if IsValid(creditBox) then
        creditBox:Remove()
    end

    if not bodysearch.CanConfirmBody() then
        self.buttonConfirm:SetText("search_confirm_forbidden")
        self.buttonConfirm:SetEnabled(false)
        self.buttonConfirm:SetIcon(nil)
    end
end

---
-- Helper function to create an info item for the search UI.
-- @param Panel parent The parent panel where it should be added to
-- @param string name A unique name to keep a reference to the item
-- @param table data The data that is added to the element
-- @param[opt] number height The height of the element
-- @return Panel The box element
-- @realm client
function SEARCHSCREEN:MakeInfoItem(parent, name, data, height)
    local box = vgui.Create("DInfoItemTTT2", parent)
    box:SetSize(self.sizes.widthContentBox, height or self.sizes.heightInfoItem)
    box:Dock(TOP)
    box:DockMargin(0, 0, 0, self.sizes.padding)
    box:SetData(data)

    -- cache reference to box
    self.infoBoxes[name] = box

    return box
end

---
-- Show the searchscreen with the provided data. Generates the whole UI.
-- @param table data The scene data that should be added
-- @realm client
function SEARCHSCREEN:Show(data)
    local client = LocalPlayer()

    self:CalculateSizes()

    local frame = self.menuFrame

    -- IF MENU ELEMENT DOES NOT ALREADY EXIST, CREATE IT
    if IsValid(frame) then
        frame:ClearFrame(
            nil,
            nil,
            { body = "search_title", params = { player = data.nick or "???" } }
        )
    else
        frame = vguihandler.GenerateFrame(
            self.sizes.width,
            self.sizes.height,
            { body = "search_title", params = { player = data.nick or "???" } }
        )
    end

    frame:SetPadding(self.sizes.padding, self.sizes.padding, self.sizes.padding, self.sizes.padding)

    -- any keypress closes the frame
    frame:SetKeyboardInputEnabled(true)
    frame.OnKeyCodePressed = util.BasicKeyHandler

    self.data = data
    self.menuFrame = frame

    local playerDataKnown = data.nick ~= nil
    local rd = roles.GetByIndex(data.subrole)
    local clientRoleData = client:GetSubRoleData()

    local contentBox = vgui.Create("DPanelTTT2", frame)
    contentBox:SetSize(self.sizes.widthMainArea, self.sizes.heightMainArea)
    contentBox:Dock(TOP)

    local profileBox = vgui.Create("DProfilePanelTTT2", contentBox)
    profileBox:SetSize(self.sizes.widthProfileArea, self.sizes.heightMainArea)
    profileBox:Dock(LEFT)
    profileBox:SetModel(data.playerModel)
    profileBox:SetPlayerIcon(
        playerDataKnown and draw.GetAvatarMaterial(data.sid64, "medium")
            or materialPlayerIconUnknown
    )
    profileBox:SetPlayerRoleColor(playerDataKnown and data.roleColor or COLOR_SLATEGRAY)
    profileBox:SetPlayerRoleIcon(playerDataKnown and rd.iconMaterial or materialRoleUnknown)
    profileBox:SetPlayerRoleString(playerDataKnown and rd.name or "search_team_role_unknown")
    profileBox:SetPlayerTeamString(playerDataKnown and data.team or "search_team_role_unknown")

    -- ADD STATUS BOX AND ITS CONTENT
    local contentAreaScroll = vgui.Create("DScrollPanelTTT2", contentBox)
    contentAreaScroll:SetVerticalScrollbarEnabled(true)
    contentAreaScroll:SetSize(self.sizes.widthContentArea, self.sizes.heightMainArea)
    contentAreaScroll:Dock(RIGHT)

    local searchMode = bodysearch.GetInspectConfirmMode()

    -- POPULATE WITH SPECIAL INFORMATION
    if client:IsSpec() then
        -- a spectator can see all information, but not interact with the UI
        self:MakeInfoItem(contentAreaScroll, "sepc_search_info", {
            text = {
                title = {
                    body = "search_title_spectator",
                    params = nil,
                },
                text = {
                    {
                        body = "search_spec",
                        params = nil,
                    },
                },
            },
            colorBox = COLOR_SLATEGRAY,
        }, 62)
    elseif searchMode == 0 and not bodysearch.IsConfirmed(data.ragOwner) then
        -- a detective can only be called AFTER a body was confirmed
        self:MakeInfoItem(contentAreaScroll, "policingrole_call_confirm", {
            text = {
                title = {
                    body = "search_title_policingrole_report_confirm",
                    params = nil,
                },
                text = {
                    {
                        body = "search_policingrole_report_confirm",
                        params = nil,
                    },
                },
            },
            colorBox = roles.DETECTIVE.ltcolor,
        }, 62)
    elseif
        bodysearch.CanReportBody(data.ragOwner)
        and not bodysearch.IsConfirmed(data.ragOwner)
        and not (clientRoleData.isPolicingRole and clientRoleData.isPublicRole)
    then
        self:MakeInfoItem(contentAreaScroll, "policingrole_confirm_disabled", {
            text = {
                title = {
                    body = "search_title_policingrole_confirm_disabled",
                    params = nil,
                },
                text = {
                    {
                        body = "search_policingrole_confirm_disabled_" .. tostring(searchMode),
                        params = nil,
                    },
                },
            },
            colorBox = roles.DETECTIVE.ltcolor,
        }, (searchMode == 1) and 62 or 78)
    end

    -- POPULATE WITH INFORMATION
    for i = 1, #bodysearch.searchResultOrder do
        local searchResultName = bodysearch.searchResultOrder[i]
        local searchResultData = bodysearch.GetContentFromData(searchResultName, data)

        if not searchResultData then
            continue
        end

        self:MakeInfoItem(contentAreaScroll, searchResultName, searchResultData)
    end

    if playerDataKnown then
        -- additional information by other addons
        local searchAdd = {}
        ---
        -- @realm client
        hook.Run("TTTBodySearchPopulate", searchAdd, data)
        for _, v in pairs(searchAdd) do
            if istable(v.text) then
                self:MakeInfoItem(
                    contentAreaScroll,
                    Material(v.img),
                    { title = v.title or "", text = v.text }
                )
            else
                self:MakeInfoItem(
                    contentAreaScroll,
                    Material(v.img),
                    { title = "", text = { { body = v.text } } }
                )
            end
        end
    end

    -- BUTTONS
    local buttonArea = vgui.Create("DButtonPanelTTT2", frame)
    buttonArea:SetSize(self.sizes.width, self.sizes.heightBottomButtonPanel)
    buttonArea:Dock(BOTTOM)

    local buttonReport = vgui.Create("DButtonTTT2", buttonArea)
    buttonReport:SetText("search_call")
    buttonReport:SetSize(self.sizes.widthButton, self.sizes.heightButton)
    buttonReport:SetPos(0, self.sizes.padding + 1)
    buttonReport.DoClick = function(btn)
        bodysearch.ClientReportsCorpse(data.rag)
    end
    buttonReport:SetIcon(roles.DETECTIVE.iconMaterial, true, 16)

    if not bodysearch.CanReportBody(data.ragOwner) then
        buttonReport:SetEnabled(false)
    end

    local playerCanTakeCredits = bodysearch.CanTakeCredits(client, data.rag)

    local buttonConfirm = vgui.Create("DButtonTTT2", buttonArea)

    if client:IsSpec() then
        local text = "search_confirm"
        if bodysearch.IsConfirmed(data.ragOwner) then
            text = "search_confirmed"
        end

        buttonConfirm:SetEnabled(false)
        buttonConfirm:SetText(text)
        buttonConfirm:SetSize(self.sizes.widthButton, self.sizes.heightButton)
        buttonConfirm:SetPos(
            self.sizes.widthMainArea - self.sizes.widthButton,
            self.sizes.padding + 1
        )
    elseif bodysearch.IsConfirmed(data.ragOwner) then
        buttonConfirm:SetText("search_confirmed")
        buttonConfirm:SetEnabled(false)
        buttonConfirm:SetSize(self.sizes.widthButton, self.sizes.heightButton)
        buttonConfirm:SetPos(
            self.sizes.widthMainArea - self.sizes.widthButton,
            self.sizes.padding + 1
        )
    elseif not bodysearch.CanConfirmBody() then
        if playerCanTakeCredits then
            buttonConfirm:SetText("search_take_credits")
            buttonConfirm:SetTextParams({ credits = data.credits })
            buttonConfirm:SetIcon(materialCredits)
            buttonConfirm:SetSize(self.sizes.widthButtonTakeCredits, self.sizes.heightButton)
            buttonConfirm:SetPos(
                self.sizes.widthMainArea - self.sizes.widthButtonTakeCredits,
                self.sizes.padding + 1
            )
        else
            buttonConfirm:SetText("search_confirm_forbidden")
            buttonConfirm:SetEnabled(false)
            buttonConfirm:SetSize(self.sizes.widthButton, self.sizes.heightButton)
            buttonConfirm:SetPos(
                self.sizes.widthMainArea - self.sizes.widthButton,
                self.sizes.padding + 1
            )
        end
    elseif playerCanTakeCredits then
        buttonConfirm:SetText("search_confirm_credits")
        buttonConfirm:SetTextParams({ credits = data.credits })
        buttonConfirm:SetSize(self.sizes.widthButtonCredits, self.sizes.heightButton)
        buttonConfirm:SetPos(
            self.sizes.widthMainArea - self.sizes.widthButtonCredits,
            self.sizes.padding + 1
        )
        buttonConfirm:SetIcon(materialCredits)
    else
        buttonConfirm:SetText("search_confirm")
        buttonConfirm:SetSize(self.sizes.widthButton, self.sizes.heightButton)
        buttonConfirm:SetPos(
            self.sizes.widthMainArea - self.sizes.widthButton,
            self.sizes.padding + 1
        )
    end
    buttonConfirm.DoClick = function(btn)
        bodysearch.ClientConfirmsCorpse(
            data.rag,
            data.searchUID,
            data.isLongRange,
            playerCanTakeCredits
        )

        -- call these functions locally to give the user an instant feedback
        -- the same function will be called again after the server processed
        -- the confirmation and reported back to the clients

        if playerCanTakeCredits then
            self:UpdateUIWhenCreditsWereTaken()
        end

        if bodysearch.CanConfirmBody() then
            self:UpdateUIWhenPlayerWasConfirmed()
        end
    end

    -- cache button references for external interaction
    self.buttonReport = buttonReport
    self.buttonConfirm = buttonConfirm
end

---
-- Closes the curren searchscreen window if open
-- @realm client
function SEARCHSCREEN:Close()
    if not IsValid(self.menuFrame) then
        return
    end

    self.menuFrame:CloseFrame()
end
