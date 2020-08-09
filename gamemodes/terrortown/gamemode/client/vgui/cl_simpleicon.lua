---
-- @class PANEL
-- @realm client
-- @section SimpleIcon
-- @desc Altered version of gmod's SpawnIcon
-- This panel does not deal with models and such

local matHover = Material("vgui/spawnmenu/hover")
local doubleClickTime = 0.5

local PANEL = {}

local math = math
local ipairs = ipairs
local IsValid = IsValid
local surface = surface
local draw = draw
local vgui = vgui

---
-- @function GetIconSize()
-- @return number
--
---
-- @function SetIconSize(i)
-- @param number i
---
AccessorFunc(PANEL, "m_iIconSize", "IconSize")

function PANEL:Init()
	self.Icon = vgui.Create("DImage", self)
	self.Icon:SetMouseInputEnabled(false)
	self.Icon:SetKeyboardInputEnabled(false)

	self.lastLeftClick = 0

	self.animPress = Derma_Anim("Press", self, self.PressedAnim)

	self:SetIconSize(64)
end

---
-- @param number mcode mouse key / code
function PANEL:OnMousePressed(mcode)
	if mcode == MOUSE_LEFT then
		self:DoClick()
		self:PressedLeftMouse(SysTime() <= self.lastLeftClick + doubleClickTime)

		self.lastLeftClick = SysTime()

		self.animPress:Start(0.1)
	end
end

function PANEL:OnMouseReleased()

end

---
-- @param boolean doubleClick doubleClick happened in 0.8s
function PANEL:PressedLeftMouse(doubleClick)

end

function PANEL:DoClick()

end

function PANEL:OpenMenu()

end

function PANEL:ApplySchemeSettings()

end

function PANEL:OnCursorEntered()
	self.PaintOverOld = self.PaintOver
	self.PaintOver = self.PaintOverHovered
end

function PANEL:OnCursorExited()
	if self.PaintOver == self.PaintOverHovered then
		self.PaintOver = self.PaintOverOld
	end
end

function PANEL:PaintOverHovered()
	if self.animPress:Active() then return end

	surface.SetDrawColor(255, 255, 255, 80)
	surface.SetMaterial(matHover)

	self:DrawTexturedRect()
end

function PANEL:PerformLayout()
	if self.animPress:Active() then return end

	self:SetSize(self.m_iIconSize, self.m_iIconSize)

	self.Icon:StretchToParent(0, 0, 0, 0)
end

---
-- @param Material icon
function PANEL:SetIcon(icon)
	self.Icon:SetImage(icon)
end

-- @param Material icon
function PANEL:SetMaterial(material)
	self.Icon:SetMaterial(material)
end

---
-- @return Material
function PANEL:GetIcon()
	return self.Icon:GetImage()
end

function PANEL:SetIconColor(c)
	self.Icon:SetImageColor(c)
end

function PANEL:Think()
	self.animPress:Run()
end

---
-- @param table anim
-- @param number delta
-- @param table data
function PANEL:PressedAnim(anim, delta, data)
	if anim.Started then return end

	if anim.Finished then
		self.Icon:StretchToParent(0, 0, 0, 0)

		return
	end

	local border = math.sin(delta * math.pi) * (self.m_iIconSize * 0.05)

	self.Icon:StretchToParent(border, border, border, border)
end

vgui.Register("SimpleIcon", PANEL, "Panel")

---
-- @section LayeredIcon
---

PANEL = {}

function PANEL:Init()
	self.Layers = {}
end

---
-- Add a panel to this icon. Most recent addition will be the top layer.
-- @param Panel pnl
function PANEL:AddLayer(pnl)
	if not IsValid(pnl) then return end

	pnl:SetParent(self)
	pnl:SetMouseInputEnabled(false)
	pnl:SetKeyboardInputEnabled(false)

	self.Layers[#self.Layers + 1] = pnl
end

function PANEL:PerformLayout()
	if self.animPress:Active() then return end

	self:SetSize(self.m_iIconSize, self.m_iIconSize)

	self.Icon:StretchToParent(0, 0, 0, 0)

	for _, p in ipairs(self.Layers) do
		p:SetPos(0, 0)
		p:InvalidateLayout()
	end
end

---
-- @param Panel pnl
function PANEL:EnableMousePassthrough(pnl)
	for _, p in ipairs(self.Layers) do
		if p == pnl then
			p.OnMousePressed = function(s, mc)
				s:GetParent():OnMousePressed(mc)
			end

			p.OnCursorEntered = function(s)
				s:GetParent():OnCursorEntered()
			end

			p.OnCursorExited = function(s)
				s:GetParent():OnCursorExited()
			end

			p:SetMouseInputEnabled(true)
		end
	end
end

vgui.Register("LayeredIcon", PANEL, "SimpleIcon")

---
-- @section SimpleIconAvatar
-- @desc Avatar icon
---

PANEL = {}

function PANEL:Init()
	self.imgAvatar = vgui.Create("AvatarImage", self)
	self.imgAvatar:SetMouseInputEnabled(false)
	self.imgAvatar:SetKeyboardInputEnabled(false)
	self.imgAvatar.PerformLayout = function(s) s:Center() end

	self:SetAvatarSize(32)

	self:AddLayer(self.imgAvatar)

	--return self.BaseClass.Init(self)
end

---
-- @param number s
function PANEL:SetAvatarSize(s)
	self.imgAvatar:SetSize(s, s)
end

---
-- @param Player ply
function PANEL:SetPlayer(ply)
	self.imgAvatar:SetPlayer(ply)
end

vgui.Register("SimpleIconAvatar", PANEL, "LayeredIcon")

---
-- @section SimpleIconLabelled
-- @desc Labelled icon
---

PANEL = {}

---
-- @function GetIconText()
-- @return string
--
---
-- @function SetIconText(str)
-- @param string str
---
AccessorFunc(PANEL, "IconText", "IconText")

---
-- @function GetIconTextColor()
-- @return Color
--
---
-- @function SetIconTextColor(color)
-- @param Color color
---
AccessorFunc(PANEL, "IconTextColor", "IconTextColor")

---
-- @function GetIconFont()
-- @return string
--
---
-- @function SetIconFont(str)
-- @param string str
---
AccessorFunc(PANEL, "IconFont", "IconFont")

---
-- @function GetIconTextShadow()
-- @return table
--
---
-- @function SetIconTextShadow(tab)
-- @param table tab
---
AccessorFunc(PANEL, "IconTextShadow", "IconTextShadow")

---
-- @function GetIconTextPos()
-- @return table
--
---
-- @function SetIconTextPos(tab)
-- @param table tab
---
AccessorFunc(PANEL, "IconTextPos", "IconTextPos")

function PANEL:Init()
	self:SetIconText("")
	self:SetIconTextColor(Color(255, 200, 0))
	self:SetIconFont("TargetID")
	self:SetIconTextShadow({opacity = 255, offset = 2})
	self:SetIconTextPos({32, 32})

	-- DPanelSelect loves to overwrite its children's PaintOver hooks and such,
	-- so have to use a dummy panel to do some custom painting.
	self.FakeLabel = vgui.Create("Panel", self)
	self.FakeLabel.PerformLayout = function(s)
		s:StretchToParent(0, 0, 0, 0)
	end

	self:AddLayer(self.FakeLabel)

	return self.BaseClass.Init(self)
end

function PANEL:PerformLayout()
	self:SetLabelText(self:GetIconText(), self:GetIconTextColor(), self:GetIconFont(), self:GetIconTextPos())

	return self.BaseClass.PerformLayout(self)
end

---
-- @param Color color
-- @param string font
-- @param table shadow
-- @param table pos
function PANEL:SetIconProperties(color, font, shadow, pos)
	self:SetIconTextColor(color or self:GetIconTextColor())
	self:SetIconFont(font or self:GetIconFont())
	self:SetIconTextShadow(shadow or self:GetIconShadow())
	self:SetIconTextPos(pos or self:GetIconTextPos())
end

---
-- @param string text
-- @param Color color
-- @param string font
-- @param table pos
function PANEL:SetLabelText(text, color, font, pos)
	if self.FakeLabel then
		local spec = {pos = pos, color = color, text = text, font = font, xalign = TEXT_ALIGN_CENTER, yalign = TEXT_ALIGN_CENTER}
		local shadow = self:GetIconTextShadow()
		local opacity = shadow and shadow.opacity or 0
		local offset = shadow and shadow.offset or 0
		local drawfn = shadow and draw.TextShadow or draw.Text

		self.FakeLabel.Paint = function()
			drawfn(spec, offset, opacity)
		end
	end
end

vgui.Register("SimpleIconLabelled", PANEL, "LayeredIcon")
