require "vegatable"

vega.util = {}

--- Copies the fields of values into the table. If values is nil, nothing happens. It
-- returns the table.
function vega.util.copyvaluesintotable(values, table)
	values = values or {}
	for k, v in pairs(values) do
		table[k] = v
	end
	return table
end

--- Useful function to be called by __pairs function of a metatable that must iterate by the keys of
-- a table and, then, iterates by the keys of a private table too.
function vega.util.pairswithprivatetable(t, privatet)
	local function nextfunction(t, index)
		local k, v
		if index == nil or rawget(t, index) ~= nil then
			k, v = next(t, index)
			if k == nil then
				k, v = next(privatet)
			end
		else
			k, v = next(privatet, index)
		end
		return k, v
	end
	return nextfunction, t, nil
end
