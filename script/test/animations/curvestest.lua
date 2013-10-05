local curvestest = {}

local function assert_fx_should_returns_y(f, x, y)
	assert_equal(y, f(x), "Y at f("..x..") is not the expected.")
end

function curvestest.test_linear_function_should_return_y_equal_to_x()
	assert_fx_should_returns_y(vega.animations.curves.linear, 0, 0)
	assert_fx_should_returns_y(vega.animations.curves.linear, 0.25, 0.25)
	assert_fx_should_returns_y(vega.animations.curves.linear, 0.5, 0.5)
	assert_fx_should_returns_y(vega.animations.curves.linear, 0.75, 0.75)
	assert_fx_should_returns_y(vega.animations.curves.linear, 1, 1)
end

function curvestest.test_acceleration_function_should_return_y_accelerating()
	assert_fx_should_returns_y(vega.animations.curves.acceleration, 0, 0)
	assert_fx_should_returns_y(vega.animations.curves.acceleration, 0.25, 0.0625)
	assert_fx_should_returns_y(vega.animations.curves.acceleration, 0.5, 0.25)
	assert_fx_should_returns_y(vega.animations.curves.acceleration, 0.75, 0.5625)
	assert_fx_should_returns_y(vega.animations.curves.acceleration, 1, 1)
end

function curvestest.test_slowdown_function_should_return_y_slowing()
	assert_fx_should_returns_y(vega.animations.curves.slowdown, 0, 0)
	assert_fx_should_returns_y(vega.animations.curves.slowdown, 0.25, 0.4375)
	assert_fx_should_returns_y(vega.animations.curves.slowdown, 0.5, 0.75)
	assert_fx_should_returns_y(vega.animations.curves.slowdown, 0.75, 0.9375)
	assert_fx_should_returns_y(vega.animations.curves.slowdown, 1, 1)
end

function curvestest.test_accelerationandslowdown_function_should_return_y_accelerating_and_slowing()
	assert_fx_should_returns_y(vega.animations.curves.accelerationandslowdown, 0, 0)
	assert_fx_should_returns_y(vega.animations.curves.accelerationandslowdown, 0.25, 0.125)
	assert_fx_should_returns_y(vega.animations.curves.accelerationandslowdown, 0.5, 0.5)
	assert_fx_should_returns_y(vega.animations.curves.accelerationandslowdown, 0.75, 0.875)
	assert_fx_should_returns_y(vega.animations.curves.accelerationandslowdown, 1, 1)
end

function curvestest.test_slowdownandacceleration_function_should_return_y_slowing_and_accelerating()
	assert_fx_should_returns_y(vega.animations.curves.slowdownandacceleration, 0, 0)
	assert_fx_should_returns_y(vega.animations.curves.slowdownandacceleration, 0.25, 0.375)
	assert_fx_should_returns_y(vega.animations.curves.slowdownandacceleration, 0.5, 0.5)
	assert_fx_should_returns_y(vega.animations.curves.slowdownandacceleration, 0.75, 0.625)
	assert_fx_should_returns_y(vega.animations.curves.slowdownandacceleration, 1, 1)
end

return curvestest