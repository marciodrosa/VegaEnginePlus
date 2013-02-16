local Vector2MT = {
	__eq = function(a, b)
		return a.x == b.x and a.y == b.y
	end,
	__tostring = function(v)
		return "Vector2("..v.x..", "..v.y..")"
	end
}

Vector2 = {}

function Vector2.new(xvalue, yvalue)
	local v2 = {
		x = xvalue or 0,
		y = yvalue or xvalue or 0
	}
	setmetatable(v2, Vector2MT)
	return v2
end

Vector2.zero = Vector2.new(0, 0)

Vector2.one = Vector2.new(1, 1)
