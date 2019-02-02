--This code can be improved alot.
--Feel free to improve, use or modify in anyway altough credit would be apreciated.
--this code is made by Blue (https://forum.facepunch.com/f/gmoddev/oaxt/Blue-s-Masks-and-Shadows/1/)

--Global table
if not BSHADOWS then
	BSHADOWS = {}

	--The original drawing layer
	BSHADOWS.RenderTarget = GetRenderTarget("bshadows_original", ScrW(), ScrH())

	--The shadow layer
	BSHADOWS.RenderTarget2 = GetRenderTarget("bshadows_shadow",  ScrW(), ScrH())

	--The matarial to draw the render targets on
	BSHADOWS.ShadowMaterial = CreateMaterial("bshadows", "UnlitGeneric", {
		["$translucent"] = 1,
		["$vertexalpha"] = 1,
		["alpha"] = 1
	})

	--When we copy the rendertarget it retains color, using this allows up to force any drawing to be black
	--Then we can blur it to create the shadow effect
	BSHADOWS.ShadowMaterialGrayscale = CreateMaterial("bshadows_grayscale", "UnlitGeneric", {
		["$translucent"] = 1,
		["$vertexalpha"] = 1,
		["$alpha"] = 1,
		["$color"] = "0 0 0",
		["$color2"] = "0 0 0"
	})

	--Call this to begin drawing a shadow
	BSHADOWS.BeginShadow = function()

		--Set the render target so all draw calls draw onto the render target instead of the screen
		render.PushRenderTarget(BSHADOWS.RenderTarget)

		--Clear is so that theres no color or alpha
		render.OverrideAlphaWriteEnable(true, true)
		render.Clear(0, 0, 0, 0)
		render.OverrideAlphaWriteEnable(false, false)

		--Start Cam2D as where drawing on a flat surface
		cam.Start2D()

		--Now leave the rest to the user to draw onto the surface
	end

	--This will draw the shadow, and mirror any other draw calls the happened during drawing the shadow
	BSHADOWS.EndShadow = function(intensity, spread, blur, opacity, direction, distance, _shadowOnly)

		--Set default opcaity
		opacity = opacity or 255
		direction = direction or 0
		distance = distance or 0
		_shadowOnly = _shadowOnly or false

		--Copy this render target to the other
		render.CopyRenderTargetToTexture(BSHADOWS.RenderTarget2)

		--Blur the second render target
		if blur > 0 then
			render.OverrideAlphaWriteEnable(true, true)
			render.BlurRenderTarget(BSHADOWS.RenderTarget2, spread, spread, blur)
			render.OverrideAlphaWriteEnable(false, false)
		end

		--First remove the render target that the user drew
		render.PopRenderTarget()

		--Now update the material to what was drawn
		BSHADOWS.ShadowMaterial:SetTexture("$basetexture", BSHADOWS.RenderTarget)

		--Now update the material to the shadow render target
		BSHADOWS.ShadowMaterialGrayscale:SetTexture("$basetexture", BSHADOWS.RenderTarget2)

		--Work out shadow offsets
		local xOffset = math.sin(math.rad(direction)) * distance
		local yOffset = math.cos(math.rad(direction)) * distance

		--Now draw the shadow
		BSHADOWS.ShadowMaterialGrayscale:SetFloat("$alpha", opacity / 255) --set the alpha of the shadow

		render.SetMaterial(BSHADOWS.ShadowMaterialGrayscale)

		for i = 1 , math.ceil(intensity) do
			render.DrawScreenQuadEx(xOffset, yOffset, ScrW(), ScrH())
		end

		if not _shadowOnly then
			--Now draw the original
			BSHADOWS.ShadowMaterial:SetTexture("$basetexture", BSHADOWS.RenderTarget)

			render.SetMaterial(BSHADOWS.ShadowMaterial)
			render.DrawScreenQuad()
		end

		cam.End2D()
	end

	--This will draw a shadow based on the texture you passed it.
	BSHADOWS.DrawShadowTexture = function(texture, intensity, spread, blur, opacity, direction, distance, shadowOnly)

		--Set default opcaity
		opacity = opacity or 255
		direction = direction or 0
		distance = distance or 0
		shadowOnly = shadowOnly or false

		--Copy the texture we wish to create a shadow for to the shadow render target
		render.CopyTexture(texture, BSHADOWS.RenderTarget2)

		--Blur the second render target
		if blur > 0 then
			render.PushRenderTarget(BSHADOWS.RenderTarget2)
			render.OverrideAlphaWriteEnable(true, true)
			render.BlurRenderTarget(BSHADOWS.RenderTarget2, spread, spread, blur)
			render.OverrideAlphaWriteEnable(false, false)
			render.PopRenderTarget()
		end

		--Now update the material to the shadow render target
		BSHADOWS.ShadowMaterialGrayscale:SetTexture("$basetexture", BSHADOWS.RenderTarget2)

		--Work out shadow offsets
		local xOffset = math.sin(math.rad(direction)) * distance
		local yOffset = math.cos(math.rad(direction)) * distance

		--Now draw the shadow
		BSHADOWS.ShadowMaterialGrayscale:SetFloat("$alpha", opacity / 255) --Set the alpha

		render.SetMaterial(BSHADOWS.ShadowMaterialGrayscale)

		for i = 1 , math.ceil(intensity) do
			render.DrawScreenQuadEx(xOffset, yOffset, ScrW(), ScrH())
		end

		if not shadowOnly then

			--Now draw the original
			BSHADOWS.ShadowMaterial:SetTexture("$basetexture", texture)

			render.SetMaterial(BSHADOWS.ShadowMaterial)
			render.DrawScreenQuad()
		end
	end
end
