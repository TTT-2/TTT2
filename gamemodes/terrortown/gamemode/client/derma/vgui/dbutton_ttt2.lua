local PANEL = {}

AccessorFunc(PANEL, "m_bBorder", "DrawBorder", FORCE_BOOL)

function PANEL:Init()
	self:SetContentAlignment(5)

	--self:SetDrawBorder(true)
	--self:SetPaintBackground(true)

	self:SetTall(22)
	self:SetMouseInputEnabled(true)
	self:SetKeyboardInputEnabled(true)

	self:SetCursor("hand")
	self:SetFont("DermaTTT2Button")

	self.text = ""

	-- remove label and overwrite function
	self:SetText("")
	self.SetText = function(slf, text)
		slf.text = text
	end
end

function PANEL:GetText()
	return self.text
end

function PANEL:IsDown()
	return self.Depressed
end

function PANEL:Paint(w, h)
	-- I'm a bit lost here right now. For some reason the derma hook
	-- does not work here, even though this code is identical to
	-- the other buttons. Therefore I use a classical hook here
	-- because that works. It breaks the purpose of skins though.
	-- But it is the best solution for now, feel free to solve.
	hook.Call("PaintButtonTTT2", SKINTTT2, self, w, h)
	--derma.SkinHook("Paint", "ButtonTTT2", self, w, h)

	return false
end

function PANEL:SetConsoleCommand(strName, strArgs)
	self.DoClick = function(slf, val)
		RunConsoleCommand(strName, strArgs)
	end
end

function PANEL:SizeToContents()
	local w, h = self:GetContentSize()

	self:SetSize(w + 8, h + 4)
end

--function PANEL:GenerateExample(ClassName, PropertySheet, Width, Height)
--	local ctrl = vgui.Create(ClassName)
--	ctrl:SetText("Example Button")
--	ctrl:SetWide(200)

--	PropertySheet:AddSheet(ClassName, ctrl, nil, true, true)
--end

derma.DefineControl("DButtonTTT2", "A standard Button", PANEL, "DLabel")
