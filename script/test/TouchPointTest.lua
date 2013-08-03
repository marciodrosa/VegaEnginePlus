local TouchPointTest = {}

function TouchPointTest.test_should_create_new_touch_point()
	-- when:
	local touchpoint = vega.TouchPoint.new(99, 10, 20, 6, 15, 800, 400)
	
	-- then:
	assert_equal(99, touchpoint.id, "id is not the expected.")
	assert_equal(vega.Vector2.new(10, 20), touchpoint.position, "position is not the expected.")
	assert_equal(vega.Vector2.new(4, 5), touchpoint.motion, "motion is not the expected.")
	assert_equal(vega.Vector2.new(0.0125, 0.05), touchpoint.relativeposition, "relativeposition is not the expected.")
	assert_equal(0.005, touchpoint.relativemotion.x, 0.0001, "relativemotion.x is not the expected.")
	assert_equal(0.0125, touchpoint.relativemotion.y, 0.0001, "relativemotion.y is not the expected.")
end

return TouchPointTest
