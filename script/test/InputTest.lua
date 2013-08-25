local inputtest = {}

function inputtest.test_should_create_touch_lists()
	-- when:
	local input = vega.input()
	
	-- then:
	assert_not_nil(input.touchpoints, "Should create the touchpoints field.")
	assert_not_nil(input.newtouchpoints, "Should create the newtouchpoints field.")
	assert_not_nil(input.releasedtouchpoints, "Should create the releasedtouchpoints field.")
	assert_equal(0, #input.touchpoints, "touchpoints length should be 0.")
	assert_equal(0, #input.newtouchpoints, "newtouchpoints length should be 0.")
	assert_equal(0, #input.releasedtouchpoints, "releasedtouchpoints length should be 0.")
end

function inputtest.test_should_create_mouse()
	-- given:
	local display = {
		size = {
			x = 10,
			y = 20,
		}
	}
	
	-- when:
	local input = vega.input(display)
	
	-- then:
	assert_not_nil(input.mouse, "Should create the mouse field.")

	input.mouse.position.x = 5
	assert_equal(0.5, input.mouse.position.relativex, "Should return the mouse position relative to the display size.")
end

return inputtest