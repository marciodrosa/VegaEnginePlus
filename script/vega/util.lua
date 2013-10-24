require "vega.vegatable"

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

--- Similar to copyvaluesintotable function. It receives a list of tables and returns a mix
-- of all fields. The second table fields are setted into the first table, then the third table
-- fields, then the fourth, and so on.
-- @param tables a list of tables.
-- @return the first table, with all fields of the other tables setted into it.
function vega.util.mix(tables)
	local result = nil
	if #tables > 0 then
		result = tables[1]
		for i, t in ipairs(tables) do
			if i > 1 then
				for k, v in pairs(t) do
					result[k] = v
				end
			end
		end
	end
	return result
end
