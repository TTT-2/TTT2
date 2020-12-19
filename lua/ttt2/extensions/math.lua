---
-- A bunch of random function bundled in the math module
-- @module math

if SERVER then
	AddCSLuaFile()
end

local exp = math.exp

---
-- Equivalent to ExponentialDecay from Source's mathlib.
-- Convenient for falloff curves.
-- @param number halflife
-- @param number dt
-- @return number
-- @realm shared
function math.ExponentialDecay(halflife, dt)
	-- ln(0.5) = -0.69..
	return exp((-0.69314718 / halflife) * dt)
end

