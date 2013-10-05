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

return curvestest