-- Experimental table extension.

-- New implementation for the table.insert. Instead of set the value using rawset, use a normal set.
-- Based on the C implementation.
--[[
table.insert = function(list, pos, value)
	local e = #list + 1 -- first empty element
	if value == nil then -- called with only 2 arguments
		value = pos
		pos = e
	else
		if pos > e then e = pos end -- 'grow' array if necessary
		for i = e, pos + 1, -1 do -- move up elements
			rawset(list, i, rawget(list, i - 1))
		end
	end
	list[pos] = value
end
]]

-- New implementation for the table.remove. Instead of set nil value using rawset, it uses a normal set.
-- It also uses a normal get to return the value to be removed. Based on the C implementation.
--[[
table.remove = function(list, pos)
	if type(list) ~= "table" then error("First arg is not a table.") end
	local e = #list
	pos = pos or e
	if not(1 <= pos and pos <= e) then -- position is outside bounds?
		return nil -- nothing to remove
	end
	local result = list[pos]
	list[pos] = nil
	for i = pos, e - 1 do
		rawset(list, i, rawget(list, i + 1))
	end
	rawset(list, e, nil)
	return result
end
]]