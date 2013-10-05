require "vegatable"

--- Table with functions to be used on animations. See vega.animation function.
vega.animations.curves = {}

--- Curve function used by animations created with the vega.animation function. It just returns
-- the y value equal to the given x value.
function vega.animations.curves.linear(x)
	return x
end

--- Curve function used by animations created with the vega.animation function. It uses a quadratic
-- function to simulate an acceleration. So, the Y values starts to increase slowly and finishes with
-- a boost.
function vega.animations.curves.acceleration(x)
	return x * x
end
