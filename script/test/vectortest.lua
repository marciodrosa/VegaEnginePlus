local vectortest = {}
local vector = {}
local parentvector = {}
local function relativetofunction()
	return parentvector
end

function vectortest.setup()
	vector = vega.vector()
	assert_table(vector, "Should create a table for the vector.")
	assert_equal(0, vector.x, "Initial x should be 0.")
	assert_equal(0, vector.y, "Initial y should be 0.")
	assert_equal(0, vector.relativex, "Initial relativex should be 0.")
	assert_equal(0, vector.relativey, "Initial relativey should be 0.")
	assert_false(vector.keeprelativex, "Initial keeprelativex should be false.")
	assert_false(vector.keeprelativey, "Initial keeprelativey should be false.")
end

function vectortest.test_set_x_and_y()
	-- when:
	vector.x = 10
	vector.y = 20

	-- then:
	assert_equal(10, vector.x, "x is not the expected.")
	assert_equal(20, vector.y, "y is not the expected.")
	assert_equal(10, vector.relativex, "relativex is not the expected.")
	assert_equal(20, vector.relativey, "relativey is not the expected.")
	assert_false(vector.keeprelativex, "Initial keeprelativex should be false.")
	assert_false(vector.keeprelativey, "Initial keeprelativey should be false.")
end

function vectortest.test_set_relativex_and_relativey_without_relativeto_object()
	-- when:
	vector.relativex = 10
	vector.relativey = 20

	-- then:
	assert_equal(10, vector.x, "x is not the expected.")
	assert_equal(20, vector.y, "y is not the expected.")
	assert_equal(10, vector.relativex, "relativex is not the expected.")
	assert_equal(20, vector.relativey, "relativey is not the expected.")
	assert_true(vector.keeprelativex, "Initial keeprelativex should be true.")
	assert_true(vector.keeprelativey, "Initial keeprelativey should be true.")
end

function vectortest.test_should_set_absolute_and_get_relative()
	-- given:
	vector = vega.vector(nil, relativetofunction)
	parentvector.x = 100
	parentvector.y = 200

	-- when:
	vector.x = 50
	vector.y = 20

	-- then:
	assert_equal(0.5, vector.relativex, "relativex is not the expected.")
	assert_equal(0.1, vector.relativey, "relativey is not the expected.")
end

function vectortest.test_should_set_relative_and_get_absolute()
	-- given:
	vector = vega.vector(nil, relativetofunction)
	parentvector.x = 100
	parentvector.y = 200

	-- when:
	vector.relativex = 0.5
	vector.relativey = 0.1

	-- then:
	assert_equal(50, vector.x, "x is not the expected.")
	assert_equal(20, vector.y, "y is not the expected.")
end

function vectortest.test_should_update_when_set_relative_and_change_parent()
	-- given:
	vector = vega.vector(nil, relativetofunction)
	parentvector.x = 100
	parentvector.y = 200
	vector.relativex = 0.5
	vector.relativey = 0.1

	-- when:
	parentvector.x = 1000
	parentvector.y = 2000

	-- then:
	assert_equal(500, vector.x, "x is not the expected.")
	assert_equal(200, vector.y, "y is not the expected.")
	assert_equal(0.5, vector.relativex, "relativex is not the expected.")
	assert_equal(0.1, vector.relativey, "relativey is not the expected.")
end

function vectortest.test_should_not_update_when_set_relative_and_dont_keep_relative()
	-- given:
	vector = vega.vector(nil, relativetofunction)
	parentvector.x = 100
	parentvector.y = 200
	vector.relativex = 0.5
	vector.relativey = 0.1
	vector.keeprelativex = false
	vector.keeprelativey = false

	-- when:
	parentvector.x = 1000
	parentvector.y = 2000

	-- then:
	assert_equal(50, vector.x, "x is not the expected.")
	assert_equal(20, vector.y, "y is not the expected.")
	assert_equal(0.05, vector.relativex, "relativex is not the expected.")
	assert_equal(0.01, vector.relativey, "relativey is not the expected.")
end

function vectortest.test_should_not_update_when_set_absolute_and_change_parent()
	-- given:
	vector = vega.vector(nil, relativetofunction)
	parentvector.x = 100
	parentvector.y = 200
	vector.x = 50
	vector.y = 20

	-- when:
	parentvector.x = 1000
	parentvector.y = 2000

	-- then:
	assert_equal(50, vector.x, "x is not the expected.")
	assert_equal(20, vector.y, "y is not the expected.")
	assert_equal(0.05, vector.relativex, "relativex is not the expected.")
	assert_equal(0.01, vector.relativey, "relativey is not the expected.")
end

function vectortest.test_should_update_when_set_absolute_and_keep_relative()
	-- given:
	vector = vega.vector(nil, relativetofunction)
	parentvector.x = 100
	parentvector.y = 200
	vector.x = 50
	vector.y = 20
	vector.keeprelativex = true
	vector.keeprelativey = true

	-- when:
	parentvector.x = 1000
	parentvector.y = 2000

	-- then:
	assert_equal(500, vector.x, "x is not the expected.")
	assert_equal(200, vector.y, "y is not the expected.")
	assert_equal(0.5, vector.relativex, "relativex is not the expected.")
	assert_equal(0.1, vector.relativey, "relativey is not the expected.")
end

function vectortest.test_set_relative_value_when_parent_vector_are_zero()
	-- given:
	vector = vega.vector(nil, relativetofunction)
	parentvector.x = 0
	parentvector.y = 0

	-- when:
	vector.relativex = 0.5
	vector.relativey = 0.1

	-- then:
	assert_equal(0, vector.x, "x is not the expected.")
	assert_equal(0, vector.y, "y is not the expected.")
	assert_equal(0.5, vector.relativex, "relativex is not the expected.")
	assert_equal(0.1, vector.relativey, "relativey is not the expected.")
end

function vectortest.test_set_absolute_value_when_parent_vector_are_zero()
	-- given:
	vector = vega.vector(nil, relativetofunction)
	parentvector.x = 0
	parentvector.y = 0

	-- when:
	vector.x = 50
	vector.y = 20

	-- then:
	assert_equal(50, vector.x, "x is not the expected.")
	assert_equal(20, vector.y, "y is not the expected.")
	assert_equal(50, vector.relativex, "relativex is not the expected.")
	assert_equal(20, vector.relativey, "relativey is not the expected.")
end

function vectortest.test_should_initialize_with_absolute_values()
	-- when:
	vector = vega.vector {
		x = 10,
		y = 20
	}

	-- then:
	assert_equal(10, vector.x, "x is not the expected.")
	assert_equal(20, vector.y, "y is not the expected.")
	assert_false(vector.keeprelativex, "keeprelativex is not the expected.")
	assert_false(vector.keeprelativey, "keeprelativey is not the expected.")
end

function vectortest.test_should_initialize_with_relative_values()
	-- when:
	vector = vega.vector {
		relativex = 10,
		relativey = 20
	}

	-- then:
	assert_equal(10, vector.relativex, "relativex is not the expected.")
	assert_equal(20, vector.relativey, "relativey is not the expected.")
	assert_true(vector.keeprelativex, "keeprelativex is not the expected.")
	assert_true(vector.keeprelativey, "keeprelativey is not the expected.")
end

function vectortest.test_should_initialize_with_absolute_values_and_set_keep_relative_to_true()
	-- when:
	vector = vega.vector {
		x = 10,
		y = 20,
		keeprelativex = true,
		keeprelativey = true
	}

	-- then:
	assert_equal(10, vector.relativex, "x is not the expected.")
	assert_equal(20, vector.relativey, "y is not the expected.")
	assert_true(vector.keeprelativex, "keeprelativex is not the expected.")
	assert_true(vector.keeprelativey, "keeprelativey is not the expected.")
end

function vectortest.test_should_initialize_with_relative_values_and_set_keep_relative_to_false()
	-- when:
	vector = vega.vector {
		relativex = 10,
		relativey = 20,
		keeprelativex = false,
		keeprelativey = false
	}

	-- then:
	assert_equal(10, vector.x, "x is not the expected.")
	assert_equal(20, vector.y, "y is not the expected.")
	assert_false(vector.keeprelativex, "keeprelativex is not the expected.")
	assert_false(vector.keeprelativey, "keeprelativey is not the expected.")
end

function vectortest.test_eq_operator()
	assert_equal(vega.vector(), vega.vector(), "Default vector should be equal.")
	assert_equal(vega.vector { x = 10, y = 20 }, vega.vector { x = 10, y = 20 }, "Coordinates (10, 20) should be equal.")
	assert_equal(vega.vector { relativex = 10, relativey = 20 }, vega.vector { relativex = 10, relativey = 20 }, "Relative vector (10, 20) should be equal.")
	assert_not_equal(vega.vector { x = 10, y = 20 }, vega.vector { x = 100, y = 20 }, "Coordinates should not be equal because the x is not equal.")
	assert_not_equal(vega.vector { x = 10, y = 20 }, vega.vector { x = 10, y = 200 }, "Coordinates should not be equal because the y is not equal.")
	assert_not_equal(vega.vector { relativex = 10, relativey = 20 }, vega.vector { relativex = 100, relativey = 20 }, "Coordinates should not be equal because the relative x is not equal.")
	assert_not_equal(vega.vector { relativex = 10, relativey = 20 }, vega.vector { relativex = 10, relativey = 200 }, "Coordinates should not be equal because the relative y is not equal.")
	assert_not_equal(vega.vector { x = 10, y = 20 }, vega.vector { relativex = 10, y = 20 }, "Coordinates should not be equal because on x is relative and other is absolute.")
	assert_not_equal(vega.vector { x = 10, y = 20 }, vega.vector { x = 10, relativey = 20 }, "Coordinates should not be equal because on y is relative and other is absolute.")
end

function vectortest.test_pairs_iteration()
	-- given:
	vector = vega.vector()
	vector.x = 10
	vector.y = 20
	vector.relativey = 30

	-- when:
	local t = {}
	local keyscount = 0
	for k, v in pairs(vector) do
		t[k] = v
		keyscount = keyscount + 1
	end

	-- then:
	assert_equal(2, keyscount, "Should have iterate by two keys.")
	assert_not_nil(t.x, "Should have iterate the key x.")
	assert_not_nil(t.relativey, "Should have iterate the key relativey.")
	assert_equal(10, t.x, "t.x is not the expected.")
	assert_equal(30, t.relativey, "t.relativey is not the expected.")
end

function vectortest.test_set_x_and_y_using_keys_1_and_2()
	-- given:
	vector = vega.vector()
	vector[1] = 10
	vector[2] = 20

	-- when:
	local x = vector.x
	local y = vector.y

	-- then:
	assert_equal(10, x, "x is not the expected.")
	assert_equal(20, y, "y is not the expected.")
end

function vectortest.test_get_x_and_y_using_keys_1_and_2()
	-- given:
	vector = vega.vector()
	vector.x = 10
	vector.y = 20

	-- when:
	local x = vector[1]
	local y = vector[2]

	-- then:
	assert_equal(10, x, "x is not the expected.")
	assert_equal(20, y, "y is not the expected.")
end

function vectortest.test_should_create_vector_using_keys_1_and_2()
	-- given:
	vector = vega.vector { 10, 20 }

	-- when:
	local x = vector.x
	local y = vector.y

	-- then:
	assert_equal(10, x, "x is not the expected.")
	assert_equal(20, y, "y is not the expected.")
end

return vectortest
