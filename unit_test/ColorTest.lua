local ColorTest = {}

function ColorTest.test_should_create_new_color_with_rgba()
	-- when:
	local c = Color.new(10, 20, 30, 40)
	
	-- then:
	assert_table(c)
	assert_equal(10, c.r, "r is not the expected.")
	assert_equal(20, c.g, "g is not the expected.")
	assert_equal(30, c.b, "b is not the expected.")
	assert_equal(40, c.a, "a is not the expected.")
end

function ColorTest.test_should_create_new_color_with_default_values()
	-- when:
	local c = Color.new()
	
	-- then:
	assert_table(c)
	assert_equal(0, c.r, "r is not the expected.")
	assert_equal(0, c.g, "g is not the expected.")
	assert_equal(0, c.b, "b is not the expected.")
	assert_equal(255, c.a, "a is not the expected.")
end

function ColorTest.test_tostring_metamethod()
	-- given:
	assert_equal("Color(r:10 g:20 b:30 a:40)", tostring(Color.new(10, 20, 30, 40)))
end

function ColorTest.test_colors_should_be_equal()
	-- given
	local color1 = Color.new(10, 20, 30, 40)
	local color2 = Color.new(10, 20, 30, 40)
	
	-- then:
	assert_equal(color1, color2, "The colors should be equal")
end

function ColorTest.test_colors_should_not_be_equal()
	assert_not_equal(Color.new(10, 20, 30, 40), Color.new(11, 20, 30, 40), "Colors should not be equal, r is different.")
	assert_not_equal(Color.new(10, 20, 30, 40), Color.new(10, 21, 30, 40), "Colors should not be equal, g is different.")
	assert_not_equal(Color.new(10, 20, 30, 40), Color.new(10, 20, 31, 40), "Colors should not be equal, b is different.")
	assert_not_equal(Color.new(10, 20, 30, 40), Color.new(10, 20, 30, 41), "Colors should not be equal, a is different.")
end

return ColorTest
