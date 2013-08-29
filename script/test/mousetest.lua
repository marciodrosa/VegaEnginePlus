local mousetest = {}

function mousetest.test_should_initialize()
	-- given:
	local display = {
		size = {
			x = 100,
			y = 50,
		}
	}

	-- when:
	local mouse = vega.mouse(display)

	-- then:
	assert_equal(0, mouse.position.x, "mouse.position.x is not the expected.")
	assert_equal(0, mouse.position.y, "mouse.position.y is not the expected.")
	assert_equal(0, mouse.motion.x, "mouse.motion.x is not the expected.")
	assert_equal(0, mouse.motion.y, "mouse.motion.y is not the expected.")
	assert_equal(0, mouse.motion.z, "mouse.motion.z is not the expected.")
	assert_false(mouse.buttons.left.pressed, "mouse.buttons.left.pressed is not the expected.")
	assert_false(mouse.buttons.left.wasclicked, "mouse.buttons.left.wasclicked is not the expected.")
	assert_false(mouse.buttons.left.wasreleased, "mouse.buttons.left.wasreleased is not the expected.")
	assert_false(mouse.buttons.right.pressed, "mouse.buttons.right.pressed is not the expected.")
	assert_false(mouse.buttons.right.wasclicked, "mouse.buttons.right.wasclicked is not the expected.")
	assert_false(mouse.buttons.right.wasdoubleclicked, "mouse.buttons.right.wasdoubleclicked is not the expected.")
	assert_false(mouse.buttons.right.wasreleased, "mouse.buttons.right.wasreleased is not the expected.")
	assert_false(mouse.buttons.middle.pressed, "mouse.buttons.middle.pressed is not the expected.")
	assert_false(mouse.buttons.middle.wasclicked, "mouse.buttons.middle.wasclicked is not the expected.")
	assert_false(mouse.buttons.middle.wasdoubleclicked, "mouse.buttons.middle.wasdoubleclicked is not the expected.")
	assert_false(mouse.buttons.middle.wasreleased, "mouse.buttons.middle.wasreleased is not the expected.")
end

function mousetest.test_should_return_position_relative_to_screen()
	-- given:
	local display = {
		size = {
			x = 100,
			y = 50,
		}
	}

	local mouse = vega.mouse(display)
	mouse.position.x = 50
	mouse.position.y = 5

	-- then:
	assert_equal(0.5, mouse.position.relativex, "relativex is not the expected.")
	assert_equal(0.1, mouse.position.relativey, "relativey is not the expected.")
end

function mousetest.test_should_return_motion_relative_to_screen()
	-- given:
	local display = {
		size = {
			x = 100,
			y = 50,
		}
	}

	local mouse = vega.mouse(display)
	mouse.motion.x = 50
	mouse.motion.y = 5

	-- then:
	assert_equal(0.5, mouse.motion.relativex, "relativex is not the expected.")
	assert_equal(0.1, mouse.motion.relativey, "relativey is not the expected.")
end

return mousetest