local InputTest = {}

function InputTest.test_should_create_touch_lists()
	-- when:
	local input = vega.Input.new()
	
	-- then:
	assert_not_nil(input.touchpoints, "Should create the touchpoints field.")
	assert_not_nil(input.newtouchpoints, "Should create the newtouchpoints field.")
	assert_not_nil(input.releasedtouchpoints, "Should create the releasedtouchpoints field.")
	assert_len(0, input.touchpoints, "touchpoints length should be 0.")
	assert_len(0, input.newtouchpoints, "newtouchpoints length should be 0.")
	assert_len(0, input.releasedtouchpoints, "releasedtouchpoints length should be 0.")
end

return InputTest