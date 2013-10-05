require "vegatable"

--- Table with functions to be used on animations curves. See vega.animation function.
vega.animations.curves = {}

--- It just returns the y value equal to the given x value.
function vega.animations.curves.linear(x)
	return x
end

--- It uses a quadratic function to simulate an acceleration. The Y values starts to increase
-- slowly and finishes with a boost.
function vega.animations.curves.acceleration(x)
	return x * x
end

--- It uses a quadratic function to simulate a slowdown. The Y values starts to increase
-- quickly and finishes with a slow increase.
function vega.animations.curves.slowdown(x)
	x = x - 1
	return -(x * x) + 1
end

--- A mix of acceleration and slowdown functions. Y starts accelerating and finishes with a slowdown.
function vega.animations.curves.accelerationandslowdown(x)
	if x < 0.5 then
		x = x * 2
		return (x * x) / 2
	else
		x = (x - 1) * 2
		return ((-x * x) / 2) + 1
	end
end
