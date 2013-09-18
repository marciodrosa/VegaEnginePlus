local coordinatesconverter = {}

function coordinatesconverter.test_should_convert_from_layer_to_display()
	-- given:
	local layer = vega.layer {
		camera = vega.camera {
			position = { x = 1, y = 2 },
			size = { x = 10, y = 8 },
			scale = { x = 1.1, y = 0.7 },
			origin = { x = 0.5, y = 0.25 },
			rotation = 30
		}
	}
	local display = {
		size = {
			x = 800,
			y = 600,
		}
	}
	local originalcoordinates = { x = 3, y = 6 }

	-- when:
	local convertedcoordinates = vega.coordinatesconverter.fromlayertodisplay(originalcoordinates, layer, display)

	-- then:
	assert_equal(311.4218, convertedcoordinates.x, 0.0001, "convertedcoordinates.x is not the expected.")
	assert_equal(282.7608, convertedcoordinates.y, 0.0001, "convertedcoordinates.y is not the expected.")
end

function coordinatesconverter.test_should_return_values_relative_to_display_size_when_convert_from_layer_to_display()
	-- given:
	local layer = vega.layer {
		camera = vega.camera {
			position = { x = 0, y = 0 },
			size = { x = 10, y = 20 },
			origin = { relativex = 0.5, relativey = 0.5 },
		}
	}
	local display = {
		size = {
			x = 800,
			y = 600,
		}
	}
	local originalcoordinates = { x = 4, y = -1 }

	-- when:
	local convertedcoordinates = vega.coordinatesconverter.fromlayertodisplay(originalcoordinates, layer, display)

	-- then:
	assert_equal(0.9, convertedcoordinates.relativex, 0.0001, "convertedcoordinates.relativex is not the expected.")
	assert_equal(0.45, convertedcoordinates.relativey, 0.0001, "convertedcoordinates.relativey is not the expected.")
end

function coordinatesconverter.test_should_convert_from_display_to_layer()
	-- given:
	local layer = vega.layer {
		camera = vega.camera {
			position = { x = 1, y = 2 },
			size = { x = 10, y = 8 },
			scale = { x = 1.1, y = 0.7 },
			origin = { x = 0.5, y = 0.25 },
			rotation = 30
		}
	}
	local display = {
		size = {
			x = 800,
			y = 600,
		}
	}
	local originalcoordinates = { x = 3, y = 6 }

	-- when:
	local convertedcoordinates = vega.coordinatesconverter.fromdisplaytolayer(originalcoordinates, display, layer)

	-- then:
	assert_equal(0.6189, convertedcoordinates.x, 0.0001, "convertedcoordinates.x is not the expected.")
	assert_equal(1.6425, convertedcoordinates.y, 0.0001, "convertedcoordinates.y is not the expected.")
end

function coordinatesconverter.test_should_return_values_relative_to_layer_size_when_convert_from_display_to_layer()
	-- given:
	local layer = vega.layer {
		camera = vega.camera {
			position = { x = 0, y = 0 },
			size = { x = 10, y = 20 },
			origin = { relativex = 0.5, relativey = 0.5 },
		}
	}
	local display = {
		size = {
			x = 1000,
			y = 800,
		}
	}
	local originalcoordinates = { x = 900, y = 800 }

	-- when:
	local convertedcoordinates = vega.coordinatesconverter.fromdisplaytolayer(originalcoordinates, display, layer)

	-- then:
	assert_equal(0.4, convertedcoordinates.relativex, 0.0001, "convertedcoordinates.relativex is not the expected.")
	assert_equal(0.5, convertedcoordinates.relativey, 0.0001, "convertedcoordinates.relativey is not the expected.")
end

return coordinatesconverter