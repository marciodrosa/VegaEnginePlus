local cameratest = {}
local camera

function cameratest.setup()
	camera = vega.camera()
	assert_table(camera, "Should return a table.")
	assert_true(camera.autocalculatewidth, "camera.autocalculatewidth should be true.")
	assert_false(camera.autocalculateheight, "camera.autocalculateheight should be false.")
	assert_not_nil(camera.position, "The camera should have the fields of the drawable, like the position.")
end

function cameratest.test_should_initialize_with_initial_values()
	-- when:
	camera = vega.camera {
		autocalculatewidth = false,
		autocalculateheight = true,
		size = { x = 10, y = 20 }
	}
	
	-- then:
	assert_false(camera.autocalculatewidth, "camera.autocalculatewidth should be false.")
	assert_true(camera.autocalculateheight, "camera.autocalculateheight should be false.")
	assert_equal(10, camera.size.x, "camera.size.x is not the expected.")
	assert_equal(20, camera.size.y, "camera.size.y is not the expected.")
end

function cameratest.test_should_refresh_size_when_autocalculate_width_and_height()
	-- given:
	camera.autocalculatewidth = true
	camera.autocalculateheight = true
	camera.size = { x = 10, y = 20 }

	-- when:
	camera:refreshsizebylayer(320, 240)

	-- then:
	assert_equal(320, camera.size.x, "camera.size.x is not the expected.")
	assert_equal(240, camera.size.y, "camera.size.y is not the expected.")
end

function cameratest.test_should_refresh_size_when_autocalculate_width()
	-- given:
	camera.autocalculatewidth = true
	camera.autocalculateheight = false
	camera.size = { x = 50, y = 24 }

	-- when:
	camera:refreshsizebylayer(320, 240)

	-- then:
	assert_equal(32, camera.size.x, "camera.size.x is not the expected.")
	assert_equal(24, camera.size.y, "camera.size.y is not the expected.")
end

function cameratest.test_should_refresh_size_when_autocalculate_width()
	-- given:
	camera.autocalculatewidth = false
	camera.autocalculateheight = true
	camera.size = { x = 32, y = 50 }

	-- when:
	camera:refreshsizebylayer(320, 240)

	-- then:
	assert_equal(32, camera.size.x, "camera.size.x is not the expected.")
	assert_equal(24, camera.size.y, "camera.size.y is not the expected.")
end

return cameratest
