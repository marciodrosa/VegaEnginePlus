local Vector2Test = {}

function Vector2Test.test_should_create_new_table_with_x_and_y()
	-- when:
	local v = vega.Vector2.new(10, 20)
	
	-- then:
	assert_table(v)
	assert_equal(10, v.x, "x is not the expected.")
	assert_equal(20, v.y, "y is not the expected.")
end

function Vector2Test.test_should_create_new_table_with_default_x_and_y()
	-- when:
	local v = vega.Vector2.new()
	
	-- then:
	assert_table(v)
	assert_equal(0, v.x, "x is not the expected.")
	assert_equal(0, v.y, "y is not the expected.")
end

function Vector2Test.test_should_create_new_table_with_one_value_for_x_and_y()
	-- when:
	local v = vega.Vector2.new(10)
	
	-- then:
	assert_table(v)
	assert_equal(10, v.x, "x is not the expected.")
	assert_equal(10, v.y, "y is not the expected.")
end

function Vector2Test.test_zero_vector()
	assert_table(vega.Vector2.zero)
	assert_equal(0, vega.Vector2.zero.x, "x is not the expected.")
	assert_equal(0, vega.Vector2.zero.y, "y is not the expected.")
end

function Vector2Test.test_one_vector()
	assert_table(vega.Vector2.one)
	assert_equal(1, vega.Vector2.one.x, "x is not the expected.")
	assert_equal(1, vega.Vector2.one.y, "y is not the expected.")
end

function Vector2Test.test_eq_metamethod()
	assert_true(vega.Vector2.new(10, 20) == vega.Vector2.new(10, 20), "The vectors (10, 20) should be equal.")
	assert_true(vega.Vector2.zero == vega.Vector2.new(0, 0), "The vector zero should be equal to the new vector (0, 0).")
	assert_true(vega.Vector2.one == vega.Vector2.new(1, 1), "The vector one should be equal to the new vector (1, 1).")
	assert_false(vega.Vector2.new(10, 20) == vega.Vector2.new(10, 30), "The vectors (10, 20) and (10, 30) should not be equal.")
end

function Vector2Test.test_tostring_metamethod()
	assert_equal("Vector2(10, 20)", tostring(vega.Vector2.new(10, 20)), "The Vector2 as string is not the expected.")
end

return Vector2Test
