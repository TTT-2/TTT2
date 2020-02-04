---
-- string extensions
-- @author saibotk

AddCSLuaFile()

---
-- Receive a stream message, usually for data that can be longer than
-- the 64kb limit of a single net message. This will register a callback
-- for a specific messageId and execute it when the stream was received and
-- the data is reconstructed from all fragments.
--
-- @param string messageId a unique message id similar to the network strings
-- @param function callback This is the function that is called after the data was received.
-- @realm shared
function string.SplitAtSize(str, splitSize)
	local result = {}
	local size = #str

	-- If the string is already small enough, just return it.
	if size <= splitSize then
		return { str }
	end

	local integralPart, fractionalPart = math.modf(size / splitSize)
	-- If the number can not be perfectly divided into the given size, we have to add another for the last part
	local splitCount = (fractionalPart == 0) and integralPart or (integralPart + 1)
	for i = 1, splitCount do
		-- first need to subtract one of the iterator, because we want to calculate the end position of the previous split.
		-- And add one to the result because lua starts with 1 instead of 0.
		local offset = ((i - 1) * splitSize) + 1
		-- Calculate the endPos with the current offset (next start position) plus the splitSize, minus 1 because the first symbol at the offset is already included
		local endPos = offset + splitSize - 1
		-- If the calculated endPos is higher than the size, just set it to nil, to select the string until the end
		endPos = endPos < size and endPos or nil
		result[i] = string.sub(str, offset, endPos)
	end

	return result
end
