---
-- @class PANEL
-- @section DRoleImage

local PANEL = {}

local surface = surface
local vgui = vgui

---
-- @accessor Material
-- @realm client
AccessorFunc(PANEL, "m_Material", "Material")

---
-- @accessor Material
-- @realm client
AccessorFunc(PANEL, "m_Material2", "Material2")

---
-- @accessor Material
-- @realm client
AccessorFunc(PANEL, "m_MaterialOverlay", "MaterialOverlay")

---
-- @accessor Material
-- @realm client
AccessorFunc(PANEL, "m_RoleIcon", "RoleIcon")

---
-- @accessor Color
-- @realm client
AccessorFunc(PANEL, "m_Color", "ImageColor")

---
-- @accessor boolean
-- @realm client
AccessorFunc(PANEL, "m_bKeepAspect", "KeepAspect")

---
-- @accessor string
-- @realm client
AccessorFunc(PANEL, "m_strMatName", "MatName")

---
-- @accessor string
-- @realm client
AccessorFunc(PANEL, "m_strMatName2", "MatName2")

---
-- @accessor string
-- @realm client
AccessorFunc(PANEL, "m_strMatOverName", "MatOverName")

---
-- @accessor string
-- @realm client
AccessorFunc(PANEL, "m_strRoleIconName", "RoleIconName")

--- @ignore
function PANEL:Init()
    self:SetImageColor(Color(255, 255, 255, 255))
    self:SetMouseInputEnabled(false)
    self:SetKeyboardInputEnabled(false)
    self:SetKeepAspect(false)

    self.ImageName = ""
    self.ImageName2 = ""
    self.ImageOverlayName = ""
    self.RoleIconImageName = ""

    self.ActualWidth = 10
    self.ActualHeight = 10
end

---
-- @param string matName
-- @param string matName2
-- @param string roleIconName
-- @param string matOverName
-- @realm client
function PANEL:SetOnViewMaterial(matName, matName2, roleIconName, matOverName)
    self:SetMatName(matName)
    self:SetMatName2(matName2)
    self:SetMatOverName(matOverName)
    self:SetRoleIconName(roleIconName)

    self.ImageName = matName
    self.ImageName2 = matName2
    self.ImageOverlayName = matOverName
    self.RoleIconImageName = roleIconName
end

---
-- @return boolean returns whether the current @{PANEL} is unloaded
-- @realm client
function PANEL:Unloaded()
    return self.m_strMatName ~= nil
end

---
-- Loads the @{Material}
-- @realm client
function PANEL:LoadMaterial()
    if not self:Unloaded() then
        return
    end

    self:DoLoadMaterial()

    self:SetMatName(nil)
    self:SetMatName2(nil)
    self:SetRoleIconName(nil)
    self:SetMatOverName(nil)
end

---
-- Post loads the @{Material}
-- @realm client
function PANEL:DoLoadMaterial()
    local mat = Material(self:GetMatName())
    local mat2 = Material(self:GetMatName2())
    local matover = Material(self:GetMatOverName())
    local roleIcon = Material(self:GetRoleIconName())

    self:SetMaterial(mat)
    self:FixVertexLitMaterial()

    if mat2 then
        self:SetMaterial2(mat2)
        self:FixVertexLitMaterial2()
    end

    if matover then
        self:MaterialOverlay(matover)
        self:FixVertexLitMaterialOverlay()
    end

    if roleIcon then
        self:SetRoleIcon(roleIcon)
        self:FixVertexLitRoleIcon()
    end

    --
    -- This isn't ideal, but it will probably help you out of a jam
    -- in cases where you position the image according to the texture
    -- size and you want to load on view - instead of on load.
    --
    self:InvalidateParent()
end

---
-- @param Material|string mat
-- @realm client
function PANEL:SetMaterial(mat)
    -- Everybody makes mistakes,
    -- that's why they put erasers on pencils.
    if isstring(mat) then
        self:SetImage(mat)

        return
    end

    self.m_Material = mat

    if not self.m_Material then
        return
    end

    local Texture = self.m_Material:GetTexture("$basetexture")
    if Texture then
        self.ActualWidth = Texture:Width()
        self.ActualHeight = Texture:Height()
    else
        self.ActualWidth = self.m_Material:Width()
        self.ActualHeight = self.m_Material:Height()
    end
end

---
-- @param Material|string mat
-- @realm client
function PANEL:SetMaterial2(mat)
    -- Everybody makes mistakes,
    -- that's why they put erasers on pencils.
    if isstring(mat) then
        self:SetImage2(mat)

        return
    end

    self.m_Material2 = mat
end

---
-- @param Material|string mat
-- @realm client
function PANEL:SetMaterialOverlay(mat)
    -- Everybody makes mistakes,
    -- that's why they put erasers on pencils.
    if isstring(mat) then
        self:SetImageOverlay(mat)

        return
    end

    self.m_MaterialOverlay = mat
end

---
-- @param Material|string mat
-- @realm client
function PANEL:SetRoleIcon(mat)
    -- Everybody makes mistakes,
    -- that's why they put erasers on pencils.
    if isstring(mat) then
        self:SetRoleIconImage(mat)

        return
    end

    self.m_RoleIcon = mat
end

---
-- @param string strImage The image name
-- @realm client
function PANEL:SetImage(strImage)
    self.ImageName = strImage

    local mat = Material(strImage)

    self:SetMaterial(mat)
    self:FixVertexLitMaterial()
end

---
-- @param string strImage2 The image name
-- @realm client
function PANEL:SetImage2(strImage2)
    self.ImageName2 = strImage2

    local mat = Material(strImage2)

    self:SetMaterial2(mat)
    self:FixVertexLitMaterial2()
end

---
-- @param string strImageOverlay The image overlay name
-- @realm client
function PANEL:SetImageOverlay(strImageOverlay)
    self.ImageOverlayName = strImageOverlay

    local mat = Material(strImageOverlay)

    self:SetMaterialOverlay(mat)
    self:FixVertexLitMaterialOverlay()
end

---
-- @param string strImage The role icon image name
-- @realm client
function PANEL:SetRoleIconImage(strImage)
    self.RoleIconImageName = strImage

    local mat = Material(strImage)

    self:SetRoleIcon(mat)
    self:FixVertexLitRoleIcon()
end

---
-- @realm client
function PANEL:UnloadImage2()
    self.ImageName2 = nil
    self.m_Material2 = nil
end

---
-- @realm client
function PANEL:UnloadImageOverlay()
    self.ImageOverlayName = nil
    self.m_MaterialOverlay = nil
end

---
-- @realm client
function PANEL:UnloadRoleIconImage()
    self.RoleIconImageName = nil
    self.m_RoleIcon = nil
end

---
-- @return string
-- @realm client
function PANEL:GetImage()
    return self.ImageName
end

---
-- @return string
-- @realm client
function PANEL:GetImage2()
    return self.ImageName2
end

---
-- @return string
-- @realm client
function PANEL:GetImageOverlay()
    return self.ImageOverlayName
end

---
-- @return string
-- @realm client
function PANEL:GetRoleIconImage()
    return self.RoleIconImageName
end

---
-- @local
function PANEL:FixVertexLitMaterial()
    --
    -- If it's a vertexlitgeneric material we need to change it to be
    -- UnlitGeneric so it doesn't go dark when we enter a dark room
    -- and flicker all about
    --

    local mat = self:GetMaterial()
    local strImage = mat:GetName()

    if
        string.find(mat:GetShader(), "VertexLitGeneric") or string.find(mat:GetShader(), "Cable")
    then
        local t = mat:GetString("$basetexture")
        if t then
            local params = {}
            params["$basetexture"] = t
            params["$vertexcolor"] = 1
            params["$vertexalpha"] = 1

            mat = CreateMaterial(strImage .. "_DImage", "UnlitGeneric", params)
        end
    end

    self:SetMaterial(mat)
end

---
-- @local
function PANEL:FixVertexLitMaterial2()
    --
    -- If it's a vertexlitgeneric material we need to change it to be
    -- UnlitGeneric so it doesn't go dark when we enter a dark room
    -- and flicker all about
    --

    local mat = self:GetMaterial2()
    local strImage = mat:GetName()

    if
        string.find(mat:GetShader(), "VertexLitGeneric") or string.find(mat:GetShader(), "Cable")
    then
        local t = mat:GetString("$basetexture")
        if t then
            local params = {}
            params["$basetexture"] = t
            params["$vertexcolor"] = 1
            params["$vertexalpha"] = 1

            mat = CreateMaterial(strImage .. "_DImage", "UnlitGeneric", params)
        end
    end

    self:SetMaterial2(mat)
end

---
-- @local
function PANEL:FixVertexLitMaterialOverlay()
    --
    -- If it's a vertexlitgeneric material we need to change it to be
    -- UnlitGeneric so it doesn't go dark when we enter a dark room
    -- and flicker all about
    --

    local mat = self:GetMaterialOverlay()
    local strImage = mat:GetName()

    if
        string.find(mat:GetShader(), "VertexLitGeneric") or string.find(mat:GetShader(), "Cable")
    then
        local t = mat:GetString("$basetexture")
        if t then
            local params = {}
            params["$basetexture"] = t
            params["$vertexcolor"] = 1
            params["$vertexalpha"] = 1

            mat = CreateMaterial(strImage .. "_DImage", "UnlitGeneric", params)
        end
    end

    self:SetMaterialOverlay(mat)
end

---
-- @local
function PANEL:FixVertexLitRoleIcon()
    --
    -- If it's a vertexlitgeneric material we need to change it to be
    -- UnlitGeneric so it doesn't go dark when we enter a dark room
    -- and flicker all about
    --

    local mat = self:GetRoleIcon()
    local strImage = mat:GetName()

    if
        string.find(mat:GetShader(), "VertexLitGeneric") or string.find(mat:GetShader(), "Cable")
    then
        local t = mat:GetString("$basetexture")
        if t then
            local params = {}
            params["$basetexture"] = t
            params["$vertexcolor"] = 1
            params["$vertexalpha"] = 1

            mat = CreateMaterial(strImage .. "_DImage", "UnlitGeneric", params)
        end
    end

    self:SetRoleIcon(mat)
end

---
-- @ignore
function PANEL:SizeToContents()
    self:SetSize(self.ActualWidth, self.ActualHeight)
end

---
-- @ignore
function PANEL:Paint()
    self:PaintAt(0, 0, self:GetWide(), self:GetTall())
end

---
-- @param number x
-- @param number y
-- @param number dw
-- @param number dh
-- @return[default=true] boolean
-- @realm client
function PANEL:PaintAt(x, y, dw, dh)
    dw, dh = dw or self:GetWide(), dh or self:GetTall()

    self:LoadMaterial()

    if not self.m_Material then
        return true
    end

    surface.SetMaterial(self.m_Material)
    surface.SetDrawColor(255, 255, 255, 255)

    if self:GetKeepAspect() then
        local w = self.ActualWidth
        local h = self.ActualHeight

        -- Image is bigger than panel, shrink to suitable size
        if w > dw and h > dh then
            if w > dw then
                local diff = dw / w

                w = w * diff
                h = h * diff
            end

            if h > dh then
                local diff = dh / h

                w = w * diff
                h = h * diff
            end
        end

        if w < dw then
            local diff = dw / w

            w = w * diff
            h = h * diff
        end

        if h < dh then
            local diff = dh / h

            w = w * diff
            h = h * diff
        end

        local OffX = (dw - w) * 0.5
        local OffY = (dh - h) * 0.5

        local tx = OffX + x
        local ty = OffY + y

        surface.DrawTexturedRect(tx, ty, w, h)

        if self.m_Material2 then
            surface.SetDrawColor(self.m_Color.r, self.m_Color.g, self.m_Color.b, self.m_Color.a)
            surface.SetMaterial(self.m_Material2)
            surface.DrawTexturedRect(tx, ty, w, h)
        end

        if self.m_MaterialOverlay then
            surface.SetDrawColor(self.m_Color.r, self.m_Color.g, self.m_Color.b, self.m_Color.a)
            surface.SetMaterial(self.m_MaterialOverlay)
            surface.DrawTexturedRect(tx, ty, w, h)
        end

        if self.m_RoleIcon then
            surface.SetDrawColor(255, 255, 255, 255)
            surface.SetMaterial(self.m_RoleIcon)
            surface.DrawTexturedRect(tx + 8, ty + 8, w - 16, h - 16)
        end

        return true
    end

    surface.DrawTexturedRect(x, y, dw, dh)

    if self.m_Material2 then
        surface.SetDrawColor(self.m_Color.r, self.m_Color.g, self.m_Color.b, self.m_Color.a)
        surface.SetMaterial(self.m_Material2)
        surface.DrawTexturedRect(x, y, dw, dh)
    end

    if self.m_MaterialOverlay then
        surface.SetDrawColor(self.m_Color.r, self.m_Color.g, self.m_Color.b, self.m_Color.a)
        surface.SetMaterial(self.m_MaterialOverlay)
        surface.DrawTexturedRect(x, y, dw, dh)
    end

    if self.m_RoleIcon then
        surface.SetDrawColor(255, 255, 255, 255)
        surface.SetMaterial(self.m_RoleIcon)
        surface.DrawTexturedRect(x + 8, y + 8, dw - 16, dh - 16)
    end

    return true
end

---
-- @param string className name of a @{Panel}
-- @param Panel propertySheet the parent element
-- @param number width
-- @param number height
-- @realm client
function PANEL:GenerateExample(className, propertySheet, width, height)
    local ctrl = vgui.Create(className)
    ctrl:SetImage("brick/brick_model")
    ctrl:SetSize(200, 200)

    propertySheet:AddSheet(className, ctrl, nil, true, true)
end

derma.DefineControl("DRoleImage", "A simple role image", PANEL, "DPanel")
