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