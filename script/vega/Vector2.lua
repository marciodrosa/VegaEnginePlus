require "vegatable"

--- A table with x and y coordinates.
-- @field x the x coordinate.
-- @field y the y coordinate.
-- @field zero a Vector2 object with coordinates (0, 0).
-- @field one a Vector2 object with coordinates (1, 1).
vega.Vector2 = {}

local Vector2MT = {
	__eq = function(a, b)
		return a.x == b.x and a.y == b.y
	end,
	__tostring = function(v)
		return "Vector2("..v.x..", "..v.y..")"
	end
}

--- Creates a new Vector2.
-- @param xvalue the x coordinate
-- @param yvalue the y coordinate
function vega.Vector2.new(xvalue, yvalue)
	local v2 = {
		x = xvalue or 0,
		y = yvalue or xvalue or 0
	}
	setmetatable(v2, Vector2MT)
	return v2
end

vega.Vector2.zero = vega.Vector2.new(0, 0)

vega.Vector2.one = vega.Vector2.new(1, 1)
