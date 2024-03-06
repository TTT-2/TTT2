---
-- Traitor radio controls
-- @module TRADIO
TRADIO = TRADIO or {}
TRADIO.sizes = TRADIO.sizes or {}
TRADIO.menuFrame = TRADIO.menuFrame or nil

local sounds = {
    scream = "radio_button_scream",
    explosion = "radio_button_expl",
    pistol = "radio_button_pistol",
    m16 = "radio_button_m16",
    deagle = "radio_button_deagle",
    mac10 = "radio_button_mac10",
    shotgun = "radio_button_shotgun",
    rifle = "radio_button_rifle",
    huge = "radio_button_huge",
    beeps = "radio_button_c4",
    burning = "radio_button_burn",
    footsteps = "radio_button_steps",
}

---
-- Calculates and caches the dimensions of the Radio UI.
-- @realm client
function TRADIO:CalculateSizes()
    self.sizes.padding = 10

    self.sizes.heightButton = 45
    self.sizes.widthButton = 160

    self.sizes.numWidthButtons = 3
    self.sizes.numHeightButtons = math.ceil(table.Count(sounds) / 3)

    self.sizes.widthMainArea = self.sizes.widthButton * self.sizes.numWidthButtons
        + (self.sizes.numWidthButtons - 1) * self.sizes.padding
    self.sizes.heightMainArea = self.sizes.heightButton * self.sizes.numHeightButtons
        + (self.sizes.numHeightButtons - 1) * self.sizes.padding

    self.sizes.width = self.sizes.widthMainArea + 2 * self.sizes.padding
    self.sizes.height = self.sizes.heightMainArea
        + vskin.GetHeaderHeight()
        + vskin.GetBorderSize()
        + 2 * self.sizes.padding
end

---
-- Show the radio UI with all sound buttons. Generates the whole UI.
-- @param Entity radioEnt The radio Entity to toggle UI for
-- @realm client
function TRADIO:Toggle(radioEnt)
    self.radio = radioEnt
    self.entIndex = tostring(radioEnt:EntIndex())

    self:CalculateSizes()

    -- IF MENU ELEMENT DOES NOT ALREADY EXIST, CREATE IT
    if IsValid(self.menuFrame) then
        self.menuFrame:CloseFrame()
    else
        self.menuFrame =
            vguihandler.GenerateFrame(self.sizes.width, self.sizes.height, "radio_name")
    end

    self.menuFrame:SetPadding(
        self.sizes.padding,
        self.sizes.padding,
        self.sizes.padding,
        self.sizes.padding
    )

    -- any keypress closes the frame
    self.menuFrame:SetKeyboardInputEnabled(false)
    self.menuFrame.OnKeyCodePressed = util.BasicKeyHandler

    local contentBox = vgui.Create("DPanelTTT2", self.menuFrame)
    contentBox:SetSize(self.sizes.widthMainArea, self.sizes.heightMainArea)
    contentBox:Dock(TOP)

    local buttonField = vgui.Create("DIconLayout", contentBox)
    buttonField:SetSpaceY(self.sizes.padding)
    buttonField:SetSpaceX(self.sizes.padding)
    buttonField:SetSize(self.sizes.widthContentArea, self.sizes.heightMainArea)
    buttonField:Dock(TOP)

    for sound, translationName in pairs(sounds) do
        local buttonReport = vgui.Create("DButtonTTT2", buttonField)
        buttonReport:SetText(LANG.GetTranslation(translationName))
        buttonReport:SetSize(self.sizes.widthButton, self.sizes.heightButton)
        buttonReport.DoClick = function(btn)
            if not IsValid(self.radio) then
                return
            end

            RunConsoleCommand("ttt_radio_play", self.entIndex, sound)
        end
    end
end
