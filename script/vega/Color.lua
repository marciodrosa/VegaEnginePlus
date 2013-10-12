require "vega.vegatable"

--- A table with functions to manipulate colors. When using Vega SDK, colors can be represented by a number (ARGB values,
-- one byte per component, from 0 to 255) or by a table (with a, r, g and b fields, each one with values from 0 to 255).
vega.color = {}

--- Returns a table with a, r, g and b fields. If the given color already is a table, a new table is created and the fields
-- are copied. If tha "a" field is nil, it is converted to 255. If "r", "g" or "b" are nil, they are converted to 0.
-- @param color the color, that can be nil, a number or a table. And error is thrown if color is another type.
-- @returns a new table with a, r, g and b fields, or nil, if the given color is nil.
function vega.color.getcomponents(color)
	if (color == nil) then
		return nil
	elseif type(color) == "table" then
		return {
			a = color.a or 255,
			r = color.r or 0,
			g = color.g or 0,
			b = color.b or 0
		}
	elseif type(color) == "number" then
		return {
			a = bit32.band(bit32.arshift(color, 24), 0x000000ff),
			r = bit32.band(bit32.arshift(color, 16), 0x000000ff),
			g = bit32.band(bit32.arshift(color, 8), 0x000000ff),
			b = bit32.band(color, 0x000000ff)
		}
	else
		error("Can not get components from color, it should be a table or number, but was "..type(color)..".")
	end
end

--- Returns a number that represents the color components.
-- @param color the color, that can be nil, a number or a table. And error is thrown if color is another type.
-- @returns the number. If the given color already is a number, then it returns the same number. If the given color is
-- nil, then returns nil.
function vega.color.gethexa(color)
	if (color == nil) then
		return nil
	elseif type(color) == "table" then
		local fixedtable = vega.color.getcomponents(color)
		return bit32.bor(bit32.arshift(fixedtable.a, -24), bit32.arshift(fixedtable.r, -16), bit32.arshift(fixedtable.g, -8), fixedtable.b)
	elseif type(color) == "number" then
		return color
	else
		error("Can not get hexadecimal value from color, it should be a table or number, but was "..type(color)..".")
	end
end