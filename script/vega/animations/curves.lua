require "vegatable"

--- Table with functions to be used on animations. See vega.animation function.
vega.animations.curves = {}

--- Curve function used by animations created with the vega.animation function. It just returns
-- the y value equal to the given x value.
function vega.animations.curves.linear(x)
	return x
end
