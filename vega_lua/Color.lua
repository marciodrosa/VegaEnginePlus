--- A color representation.
-- @field r the red component, from 0 to 255.
-- @field g the green component, from 0 to 255.
-- @field b the blue component, from 0 to 255.
-- @field a the alpha component, from 0 to 255.
Color = {}

local ColorMT = {
	__eq = function(a, b)
		return a.r == b.r and a.g == b.g and a.b == b.b and a.a == b.a
	end,
	__tostring = function(c)
		return "Color(r:"..c.r.." g:"..c.g.." b: "..c.b.." a: "..c.a..")"
	end
}

--- Creates a new Color. If the components are not defined, then 0 is the default value
-- (but the default value for alpha is 255).
-- @param red the red component.
-- @param green the green component.
-- @param blue the blue component.
-- @param alpha the alpha component. If not defined, the default value is 255.
function Color.new(red, green, blue, alpha)
	local c = {
		r = red or 0,
		g = green or 0,
		b = blue or 0,
		a = alpha or 255
	}
	setmetatable(c, ColorMT)
	return c
end
