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

---
-- Gets the index of an item in the provided table, weighted according to the weights (derived from getWeight).
-- @param table tbl The array of items to find a weighted item in.
-- @param function getWeight Called as getWeight(item, index). Must return number.
-- @return number
-- @realm shared
function math.WeightedRandom(tbl, getWeight)
    -- There are several possible ways to get a weighted item. The most obvious is to simply include an item in
    -- the table N times, where N is an integer proportional to the weight. This, however, requires maintaining
    -- that table, which may be undesirable.
    --
    -- For a more friendly API, we instead compute the sum, generate a random number from 0 to that sum, then
    -- take the first item whose weight prefix-sum is greater than that random number. This requires 2 passes
    -- over the table, but enables processing on a normal table, with arbitrary weight storage.

    -- Special case short arrays, because they may otherwise cause problems
    if #tbl == 0 then
        return nil
    end
    if #tbl == 1 then
        return 1
    end

    -- first, compute the sum weight
    local sum = 0
    for k, v in pairs(tbl) do
        sum = sum + getWeight(v, k)
    end

    -- get the random number
    local rand = math.Rand(0, sum)

    -- now do the prefix-sum for the final value
    sum = 0
    for k, v in pairs(tbl) do
        sum = sum + getWeight(v, k)
        if sum >= rand then
            return k
        end
    end

    -- it SHOULD be impossible to reach here, but just in case, we'll do a simple random selection
    return math.random(#tbl)
end
