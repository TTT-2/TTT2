local mathMax = math.max
local mathMin = math.min

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

	local profileBox = vgui.Create("DWeaponPreviewTTT2", menuFrame)
	profileBox:SetSize(1000, 750)
	profileBox:Dock(LEFT)
	profileBox:SetPlayerModel(LocalPlayer():GetModel())
	profileBox:SetWeaponClass("weapon_ttt_glock")
	profileBox:SetCamPos(Vector(50, -60, 75))
	profileBox:SetFOV(85)

	--[[

	--local wep = weapons.Get("weapon_ttt_knife")
	--local wep = weapons.Get("weapon_ttt_glock")
	--local wep = weapons.Get("weapon_ttt_m16")
	local wep = weapons.Get("weapon_ttt_c4")
	--local wep = weapons.Get("weapon_ttt_tigers")
	--local wep = weapons.Get("bbylauncher")
	--local wep = weapons.Get("weapon_ttt_chickenator")
	--local wep = weapons.Get("melonlauncher")
	--local wep = weapons.Get("weapon_ttt_boomerang")
	--local wep = weapons.Get("weapon_zm_improvised")
	--local wep = weapons.Get("weapon_ttt_beacon")
	--local wep = weapons.Get("weapon_ttt_melonmine")

	profileBox.entPly = ClientsideModel(LocalPlayer():GetModel(), RENDERGROUP_OTHER)
	profileBox.entWep = ClientsideModel(wep.WorldModel, RENDERGROUP_OTHER)

	if wep.HoldType == "normal" then
		profileBox.entPly:SetSequence(profileBox.entPly:LookupSequence("idle_all_01"))
	else
		profileBox.entPly:SetSequence(profileBox.entPly:LookupSequence("idle_" .. wep.HoldType))
	end
	profileBox.entPly:SetupBones()

	function profileBox.DrawModel(slf)
		local entPly = slf.entPly
		local entWep = slf.entWep

		--print("sequence: idle_" .. tostring(wep.HoldType) .. " / " .. tostring(entPly:LookupSequence("idle_" .. wep.HoldType)))

		--print(wep.HoldType)
		--PrintTable(entPly:GetSequenceList())
		--print(entPly:LookupBone("ValveBiped.Bip01_R_Hand"))

		--local matrix = entPly:GetBoneMatrix(entPly:LookupBone("ValveBiped.Bip01_R_Hand"))

		if wep.HoldType ~= "normal" then

			PrintTable(entPly:GetAttachments())

			--print(entPly:LookupAttachment("righthand"))

			local attachment = entPly:GetAttachment(entPly:LookupAttachment("anim_attachment_RH"))

			--local posHand = matrix:GetTranslation()
			--local angHand = matrix:GetAngles()
			local posHand = attachment.Pos
			local angHand = attachment.Ang

			--local newPosHand, newAngHand = LocalToWorld(offsetVec, Angle(0,0,0), posHand, angHand)

			--print("pos hand: " .. tostring(newPosHand))
			--print("ang hand: " .. tostring(newAngHand))

			--print(entPly:OBBCenter())

			--PrintTable(entPly:GetAttachments())

			--angHand:RotateAroundAxis(Vector(1, 0, 0), 180)

			--entWep:SetAngles(angHand)
			--entWep:SetPos(posHand)

			entWep:SetParent(entPly)
			entWep:AddEffects(EF_BONEMERGE)
		end

		--print("bone matrix:")
		--print(profileBox.entWep:GetBoneMatrix(0))
		--print(profileBox.entWep:GetBoneMatrix(1))
		--print(profileBox.entWep:GetBoneMatrix(2))

		-- handle size
		local w, h = slf:GetSize()
		local xBaseStart, yBaseStart = slf:LocalToScreen(0, 0)

		local xLimitStart, yLimitStart = xBaseStart, yBaseStart
		local xLimitEnd, yLimitEnd = slf:LocalToScreen(slf:GetWide(), slf:GetTall())

		local curparent = slf

		-- iterate till the top is found to make sure the image is not out of bounds
		while curparent:GetParent() do
			curparent = curparent:GetParent()

			local x1, y1 = curparent:LocalToScreen(0, 0)
			local x2, y2 = curparent:LocalToScreen(curparent:GetWide(), curparent:GetTall())

			xLimitStart = mathMax(xLimitStart, x1)
			yLimitStart = mathMax(yLimitStart, y1)
			xLimitEnd = mathMin(xLimitEnd, x2)
			yLimitEnd = mathMin(yLimitEnd, y2)
		end
		-- handle size END

		slf:LayoutEntity(entPly)

		if wep.HoldType ~= "normal" then
			slf:LayoutEntity(entWep)
		end

		local ang = slf.aLookAngle or (slf.vLookatPos - slf.vCamPos):Angle()

		cam.Start3D(slf.vCamPos, ang, slf.fFOV, xBaseStart, yBaseStart, w, h, 5, slf.farZ)
			render.SuppressEngineLighting(true)
			render.SetLightingOrigin(entPly:GetPos())
			render.ResetModelLighting(slf.colAmbientLight.r / 255, slf.colAmbientLight.g / 255, slf.colAmbientLight.b / 255)
			render.SetColorModulation(slf.colColor.r / 255, slf.colColor.g / 255, slf.colColor.b / 255)
			render.SetBlend((slf:GetAlpha() / 255) * (slf.colColor.a / 255))

			for i = 0, 6 do
				local col = slf.directionalLight[i]

				if col then
					render.SetModelLighting(i, col.r / 255, col.g / 255, col.b / 255)
				end
			end

			-- make a mask to make sure the graphic is limited
			render.SetScissorRect(xLimitStart, yLimitStart, xLimitEnd, yLimitEnd, true)

			entPly:DrawModel()

			if wep.HoldType ~= "normal" then
				entWep:DrawModel()
			end

			render.SetScissorRect(0, 0, 0, 0, false)
			render.SuppressEngineLighting(false)
		cam.End3D()

		slf.lastPaint = RealTime()
	end

	]]

	--profileBox.data.ent:Give("weapon_ttt_glock")
end)
