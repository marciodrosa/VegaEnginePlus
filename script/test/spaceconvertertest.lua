local spaceconvertertest = {}

function spaceconvertertest.test_should_convert_from_layer_to_display()
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
	local originalvector = { x = 3, y = 6 }

	-- when:
	local convertedvector = vega.spaceconverter.fromlayertodisplay(originalvector, layer, display)

	-- then:
	assert_equal(311.4218, convertedvector.x, 0.0001, "convertedvector.x is not the expected.")
	assert_equal(282.7608, convertedvector.y, 0.0001, "convertedvector.y is not the expected.")
end

function spaceconvertertest.test_should_return_values_relative_to_display_size_when_convert_from_layer_to_display()
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
	local originalvector = { x = 4, y = -1 }

	-- when:
	local convertedvector = vega.spaceconverter.fromlayertodisplay(originalvector, layer, display)

	-- then:
	assert_equal(0.9, convertedvector.relativex, 0.0001, "convertedvector.relativex is not the expected.")
	assert_equal(0.45, convertedvector.relativey, 0.0001, "convertedvector.relativey is not the expected.")
end

function spaceconvertertest.test_should_convert_from_display_to_layer()
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
	local originalvector = { x = 3, y = 6 }

	-- when:
	local convertedvector = vega.spaceconverter.fromdisplaytolayer(originalvector, display, layer)

	-- then:
	assert_equal(0.6189, convertedvector.x, 0.0001, "convertedvector.x is not the expected.")
	assert_equal(1.6425, convertedvector.y, 0.0001, "convertedvector.y is not the expected.")
end

function spaceconvertertest.test_should_return_values_relative_to_layer_size_when_convert_from_display_to_layer()
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
	local originalvector = { x = 900, y = 800 }

	-- when:
	local convertedvector = vega.spaceconverter.fromdisplaytolayer(originalvector, display, layer)

	-- then:
	assert_equal(0.4, convertedvector.relativex, 0.0001, "convertedvector.relativex is not the expected.")
	assert_equal(0.5, convertedvector.relativey, 0.0001, "convertedvector.relativey is not the expected.")
end

function spaceconvertertest.test_should_convert_from_one_layer_to_another()
	-- given:
	local layer1 = vega.layer {
		camera = vega.camera {
			position = { x = 0, y = 0 },
			size = { x = 10, y = 20 },
			origin = { relativex = 0.5, relativey = 0.5 },
		}
	}
	local layer2 = vega.layer {
		camera = vega.camera {
			position = { x = -100, y = 200 },
			size = { x = 1000, y = 800 },
			rotation = 45
		}
	}
	local originalvector = { x = 900, y = 800 }

	-- when:
	local convertedvector = vega.spaceconverter.fromlayertoanotherlayer(originalvector, layer1, layer2)

	-- then:
	assert_equal(40912.1933, convertedvector.x, 0.0001, "convertedvector.x is not the expected.")
	assert_equal(86467.0273, convertedvector.y, 0.0001, "convertedvector.y is not the expected.")
end

function spaceconvertertest.test_should_return_values_relative_to_the_other_layer_size_when_convert_from_layer_to_another_layer()
	-- given:
	local layer1 = vega.layer {
		camera = vega.camera {
			size = { x = 100, y = 200 },
		}
	}
	local layer2 = vega.layer {
		camera = vega.camera {
			size = { x = 200, y = 400 },
		}
	}
	local originalvector = { x = 50, y = 50 }

	-- when:
	local convertedvector = vega.spaceconverter.fromlayertoanotherlayer(originalvector, layer1, layer2)

	-- then:
	assert_equal(0.5, convertedvector.relativex, 0.0001, "convertedvector.relativex is not the expected.")
	assert_equal(0.25, convertedvector.relativey, 0.0001, "convertedvector.relativey is not the expected.")
end

return spaceconvertertest