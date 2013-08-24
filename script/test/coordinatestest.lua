local coordinatestest = {}
local coordinates = {}
local parentcoordinates = {}
local function relativetofunction()
	return parentcoordinates
end

function coordinatestest.setup()
	coordinates = vega.coordinates()
	assert_table(coordinates, "Should create a table for the coordinates.")
	assert_equal(0, coordinates.x, "Initial x should be 0.")
	assert_equal(0, coordinates.y, "Initial y should be 0.")
	assert_equal(0, coordinates.relativex, "Initial relativex should be 0.")
	assert_equal(0, coordinates.relativey, "Initial relativey should be 0.")
	assert_false(coordinates.keeprelativex, "Initial keeprelativex should be false.")
	assert_false(coordinates.keeprelativey, "Initial keeprelativey should be false.")
end

function coordinatestest.test_set_x_and_y()
	-- when:
	coordinates.x = 10
	coordinates.y = 20

	-- then:
	assert_equal(10, coordinates.x, "x is not the expected.")
	assert_equal(20, coordinates.y, "y is not the expected.")
	assert_equal(10, coordinates.relativex, "relativex is not the expected.")
	assert_equal(20, coordinates.relativey, "relativey is not the expected.")
	assert_false(coordinates.keeprelativex, "Initial keeprelativex should be false.")
	assert_false(coordinates.keeprelativey, "Initial keeprelativey should be false.")
end

function coordinatestest.test_set_relativex_and_relativey_without_relativeto_object()
	-- when:
	coordinates.relativex = 10
	coordinates.relativey = 20

	-- then:
	assert_equal(10, coordinates.x, "x is not the expected.")
	assert_equal(20, coordinates.y, "y is not the expected.")
	assert_equal(10, coordinates.relativex, "relativex is not the expected.")
	assert_equal(20, coordinates.relativey, "relativey is not the expected.")
	assert_true(coordinates.keeprelativex, "Initial keeprelativex should be true.")
	assert_true(coordinates.keeprelativey, "Initial keeprelativey should be true.")
end

function coordinatestest.test_should_set_absolute_and_get_relative()
	-- given:
	coordinates = vega.coordinates(nil, relativetofunction)
	parentcoordinates.x = 100
	parentcoordinates.y = 200

	-- when:
	coordinates.x = 50
	coordinates.y = 20

	-- then:
	assert_equal(0.5, coordinates.relativex, "relativex is not the expected.")
	assert_equal(0.1, coordinates.relativey, "relativey is not the expected.")
end

function coordinatestest.test_should_set_relative_and_get_absolute()
	-- given:
	coordinates = vega.coordinates(nil, relativetofunction)
	parentcoordinates.x = 100
	parentcoordinates.y = 200

	-- when:
	coordinates.relativex = 0.5
	coordinates.relativey = 0.1

	-- then:
	assert_equal(50, coordinates.x, "x is not the expected.")
	assert_equal(20, coordinates.y, "y is not the expected.")
end

function coordinatestest.test_should_update_when_set_relative_and_change_parent()
	-- given:
	coordinates = vega.coordinates(nil, relativetofunction)
	parentcoordinates.x = 100
	parentcoordinates.y = 200
	coordinates.relativex = 0.5
	coordinates.relativey = 0.1

	-- when:
	parentcoordinates.x = 1000
	parentcoordinates.y = 2000

	-- then:
	assert_equal(500, coordinates.x, "x is not the expected.")
	assert_equal(200, coordinates.y, "y is not the expected.")
	assert_equal(0.5, coordinates.relativex, "relativex is not the expected.")
	assert_equal(0.1, coordinates.relativey, "relativey is not the expected.")
end

function coordinatestest.test_should_not_update_when_set_relative_and_dont_keep_relative()
	-- given:
	coordinates = vega.coordinates(nil, relativetofunction)
	parentcoordinates.x = 100
	parentcoordinates.y = 200
	coordinates.relativex = 0.5
	coordinates.relativey = 0.1
	coordinates.keeprelativex = false
	coordinates.keeprelativey = false

	-- when:
	parentcoordinates.x = 1000
	parentcoordinates.y = 2000

	-- then:
	assert_equal(50, coordinates.x, "x is not the expected.")
	assert_equal(20, coordinates.y, "y is not the expected.")
	assert_equal(0.05, coordinates.relativex, "relativex is not the expected.")
	assert_equal(0.01, coordinates.relativey, "relativey is not the expected.")
end

function coordinatestest.test_should_not_update_when_set_absolute_and_change_parent()
	-- given:
	coordinates = vega.coordinates(nil, relativetofunction)
	parentcoordinates.x = 100
	parentcoordinates.y = 200
	coordinates.x = 50
	coordinates.y = 20

	-- when:
	parentcoordinates.x = 1000
	parentcoordinates.y = 2000

	-- then:
	assert_equal(50, coordinates.x, "x is not the expected.")
	assert_equal(20, coordinates.y, "y is not the expected.")
	assert_equal(0.05, coordinates.relativex, "relativex is not the expected.")
	assert_equal(0.01, coordinates.relativey, "relativey is not the expected.")
end

function coordinatestest.test_should_update_when_set_absolute_and_keep_relative()
	-- given:
	coordinates = vega.coordinates(nil, relativetofunction)
	parentcoordinates.x = 100
	parentcoordinates.y = 200
	coordinates.x = 50
	coordinates.y = 20
	coordinates.keeprelativex = true
	coordinates.keeprelativey = true

	-- when:
	parentcoordinates.x = 1000
	parentcoordinates.y = 2000

	-- then:
	assert_equal(500, coordinates.x, "x is not the expected.")
	assert_equal(200, coordinates.y, "y is not the expected.")
	assert_equal(0.5, coordinates.relativex, "relativex is not the expected.")
	assert_equal(0.1, coordinates.relativey, "relativey is not the expected.")
end

function coordinatestest.test_set_relative_value_when_parent_coordinates_are_zero()
	-- given:
	coordinates = vega.coordinates(nil, relativetofunction)
	parentcoordinates.x = 0
	parentcoordinates.y = 0

	-- when:
	coordinates.relativex = 0.5
	coordinates.relativey = 0.1

	-- then:
	assert_equal(0, coordinates.x, "x is not the expected.")
	assert_equal(0, coordinates.y, "y is not the expected.")
	assert_equal(0.5, coordinates.relativex, "relativex is not the expected.")
	assert_equal(0.1, coordinates.relativey, "relativey is not the expected.")
end

function coordinatestest.test_set_absolute_value_when_parent_coordinates_are_zero()
	-- given:
	coordinates = vega.coordinates(nil, relativetofunction)
	parentcoordinates.x = 0
	parentcoordinates.y = 0

	-- when:
	coordinates.x = 50
	coordinates.y = 20

	-- then:
	assert_equal(50, coordinates.x, "x is not the expected.")
	assert_equal(20, coordinates.y, "y is not the expected.")
	assert_equal(50, coordinates.relativex, "relativex is not the expected.")
	assert_equal(20, coordinates.relativey, "relativey is not the expected.")
end

function coordinatestest.test_should_initialize_with_absolute_values()
	-- when:
	coordinates = vega.coordinates {
		x = 10,
		y = 20
	}

	-- then:
	assert_equal(10, coordinates.x, "x is not the expected.")
	assert_equal(20, coordinates.y, "y is not the expected.")
	assert_false(coordinates.keeprelativex, "keeprelativex is not the expected.")
	assert_false(coordinates.keeprelativey, "keeprelativey is not the expected.")
end

function coordinatestest.test_should_initialize_with_relative_values()
	-- when:
	coordinates = vega.coordinates {
		relativex = 10,
		relativey = 20
	}

	-- then:
	assert_equal(10, coordinates.relativex, "relativex is not the expected.")
	assert_equal(20, coordinates.relativey, "relativey is not the expected.")
	assert_true(coordinates.keeprelativex, "keeprelativex is not the expected.")
	assert_true(coordinates.keeprelativey, "keeprelativey is not the expected.")
end

function coordinatestest.test_should_initialize_with_absolute_values_and_set_keep_relative_to_true()
	-- when:
	coordinates = vega.coordinates {
		x = 10,
		y = 20,
		keeprelativex = true,
		keeprelativey = true
	}

	-- then:
	assert_equal(10, coordinates.relativex, "x is not the expected.")
	assert_equal(20, coordinates.relativey, "y is not the expected.")
	assert_true(coordinates.keeprelativex, "keeprelativex is not the expected.")
	assert_true(coordinates.keeprelativey, "keeprelativey is not the expected.")
end

function coordinatestest.test_should_initialize_with_relative_values_and_set_keep_relative_to_false()
	-- when:
	coordinates = vega.coordinates {
		relativex = 10,
		relativey = 20,
		keeprelativex = false,
		keeprelativey = false
	}

	-- then:
	assert_equal(10, coordinates.x, "x is not the expected.")
	assert_equal(20, coordinates.y, "y is not the expected.")
	assert_false(coordinates.keeprelativex, "keeprelativex is not the expected.")
	assert_false(coordinates.keeprelativey, "keeprelativey is not the expected.")
end

function coordinatestest.test_eq_operator()
	assert_equal(vega.coordinates(), vega.coordinates(), "Default coordinates should be equal.")
	assert_equal(vega.coordinates { x = 10, y = 20 }, vega.coordinates { x = 10, y = 20 }, "Coordinates (10, 20) should be equal.")
	assert_equal(vega.coordinates { relativex = 10, relativey = 20 }, vega.coordinates { relativex = 10, relativey = 20 }, "Relative coordinates (10, 20) should be equal.")
	assert_not_equal(vega.coordinates { x = 10, y = 20 }, vega.coordinates { x = 100, y = 20 }, "Coordinates should not be equal because the x is not equal.")
	assert_not_equal(vega.coordinates { x = 10, y = 20 }, vega.coordinates { x = 10, y = 200 }, "Coordinates should not be equal because the y is not equal.")
	assert_not_equal(vega.coordinates { relativex = 10, relativey = 20 }, vega.coordinates { relativex = 100, relativey = 20 }, "Coordinates should not be equal because the relative x is not equal.")
	assert_not_equal(vega.coordinates { relativex = 10, relativey = 20 }, vega.coordinates { relativex = 10, relativey = 200 }, "Coordinates should not be equal because the relative y is not equal.")
	assert_not_equal(vega.coordinates { x = 10, y = 20 }, vega.coordinates { relativex = 10, y = 20 }, "Coordinates should not be equal because on x is relative and other is absolute.")
	assert_not_equal(vega.coordinates { x = 10, y = 20 }, vega.coordinates { x = 10, relativey = 20 }, "Coordinates should not be equal because on y is relative and other is absolute.")
end

function coordinatestest.test_pairs_iteration()
	-- given:
	coordinates = vega.coordinates()
	coordinates.x = 10
	coordinates.y = 20
	coordinates.relativey = 30

	-- when:
	local t = {}
	local keyscount = 0
	for k, v in pairs(coordinates) do
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

return coordinatestest
