local coordinatestest = {}
local coordinates = {}
local parentcoordinates = {}
local parentobject = {
	coordinates = parentcoordinates
}
local relativeto = {
	table = parentobject,
	field = "coordinates"
}

function coordinatestest.setup()
	coordinates = vega.coordinates()
	assert_table(coordinates, "Should create a table for the coordinates.")
	assert_equal(0, coordinates.x, "Initial x should be 0.")
	assert_equal(0, coordinates.y, "Initial y should be 0.")
	assert_equal(0, coordinates.relativex, "Initial relativex should be 0.")
	assert_equal(0, coordinates.relativey, "Initial relativey should be 0.")
	assert_false(coordinates.keeprelativex, "Initial keeprelativex should be false.")
	assert_false(coordinates.keeprelativey, "Initial keeprelativey should be false.")
	assert_table(coordinates.values, "Should return a table with the values.")
	assert_equal(0, coordinates.values.x, "The values.x should be 0.")
	assert_equal(0, coordinates.values.y, "The values.y should be 0.")
	assert_nil(coordinates.values.relativex, "The values.relativex should be nil.")
	assert_nil(coordinates.values.relativey, "The values.relativey should be nil.")
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
	assert_equal(10, coordinates.values.x, "values.x is not the expected.")
	assert_equal(20, coordinates.values.y, "values.y is not the expected.")
	assert_nil(coordinates.values.relativex, "values.relativex is not the expected.")
	assert_nil(coordinates.values.relativey, "values.relativey is not the expected.")
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
	assert_equal(10, coordinates.values.relativex, "values.relativex is not the expected.")
	assert_equal(20, coordinates.values.relativey, "values.relativey is not the expected.")
	assert_nil(coordinates.values.x, "values.x is not the expected.")
	assert_nil(coordinates.values.y, "values.y is not the expected.")
end

function coordinatestest.test_should_set_absolute_and_get_relative()
	-- given:
	coordinates = vega.coordinates { relativeto = relativeto }
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
	coordinates = vega.coordinates { relativeto = relativeto }
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
	coordinates = vega.coordinates { relativeto = relativeto }
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
	coordinates = vega.coordinates { relativeto = relativeto }
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
	coordinates = vega.coordinates { relativeto = relativeto }
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
	coordinates = vega.coordinates { relativeto = relativeto }
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
	coordinates = vega.coordinates { relativeto = relativeto }
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
	coordinates = vega.coordinates { relativeto = relativeto }
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

function coordinatestest.test_should_initialize_with_values()
	-- todo: not yet implemented on vega.coordinates
end

return coordinatestest
