local inputtest = {}

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