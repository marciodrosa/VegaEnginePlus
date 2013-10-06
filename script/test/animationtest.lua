local animationtest = {}

local animation

function animationtest.setup()
	animation = vega.animation()
end

function animationtest.test_should_initialize_with_default_values()
	assert_equal(animation.length, 1, "length is not the expected.")
	assert_equal(animation.frame, 1, "frame is not the expected.")
	assert_equal(animation.curvefunction, vega.animations.curves.linear, "curvefunction is not the expected.")
	assert_nil(animation.trackposition, "Should not initialize the field trackposition.")
end

function animationtest.test_should_set_value_of_a_table_field()
	-- given:
	local t = {}
	animation.on = t
	animation.what = "a"
	animation.from = 10
	animation.to = 20
	animation.length = 3

	-- when:
	animation.frame = 1
	animation:updateframe()
	local valueatframe1 = t.a

	animation.frame = 2
	animation:updateframe()
	local valueatframe2 = t.a

	animation.frame = 3
	animation:updateframe()
	local valueatframe3 = t.a

	-- then:
	assert_equal(valueatframe1, 10, "The value at frame 1 is not the expected.")
	assert_equal(valueatframe2, 15, "The value at frame 2 is not the expected.")
	assert_equal(valueatframe3, 20, "The value at frame 3 is not the expected.")
end

function animationtest.test_should_get_x()
	-- given:
	animation.length = 3

	-- when:
	animation.frame = 1
	local xat1 = animation.x
	animation.frame = 2
	local xat2 = animation.x
	animation.frame = 3
	local xat3 = animation.x

	-- then:
	assert_equal(xat1, 0, "x at frame 1 is not the expected.")
	assert_equal(xat2, 0.5, "x at frame 2 is not the expected.")
	assert_equal(xat3, 1, "x at frame 3 is not the expected.")
end

function animationtest.test_should_get_y_using_default_curve_function()
	-- given:
	animation.length = 3

	-- when:
	animation.frame = 1
	local yat1 = animation.y
	animation.frame = 2
	local yat2 = animation.y
	animation.frame = 3
	local yat3 = animation.y

	-- then:
	assert_equal(yat1, 0, "y at frame 1 is not the expected.")
	assert_equal(yat2, 0.5, "y at frame 2 is not the expected.")
	assert_equal(yat3, 1, "y at frame 3 is not the expected.")
end

function animationtest.test_should_get_y_using_custom_curve_function()
	-- given:
	animation.length = 3
	animation.curvefunction = function(x) return -x end

	-- when:
	animation.frame = 1
	local yat1 = animation.y
	animation.frame = 2
	local yat2 = animation.y
	animation.frame = 3
	local yat3 = animation.y

	-- then:
	assert_equal(0, yat1, "y at frame 1 is not the expected.")
	assert_equal(-0.5, yat2, "y at frame 2 is not the expected.")
	assert_equal(-1, yat3, "y at frame 3 is not the expected.")
end

function animationtest.test_should_throw_error_when_set_x()
	assert_error("The animation field x is read-only.", function() animation.x = 0.5 end, "The error should contains a message.")
end

function animationtest.test_should_throw_error_when_set_y()
	assert_error("The animation field y is read-only.", function() animation.y = 0.5 end, "The error should contains a message.")
end

function animationtest.test_should_create_animation_with_initial_values()
	-- when:
	local t = {}
	local curvefunction = function(x) return x end
	animation = {
		on = t,
		what = "a",
		from = 10,
		to = 20,
		length = 3,
		frame = 2,
		curvefunction = curvefunction
	}

	-- then:
	assert_equal(t, animation.on, "animation.on is not the expected.")
	assert_equal("a", animation.what, "animation.what is not the expected.")
	assert_equal(10, animation.from, "animation.from is not the expected.")
	assert_equal(20, animation.to, "animation.to is not the expected.")
	assert_equal(3, animation.length, "animation.length is not the expected.")
	assert_equal(2, animation.frame, "animation.frame is not the expected.")
	assert_equal(curvefunction, animation.curvefunction, "animation.curvefunction is not the expected.")
end

function animationtest.test_should_call_updateframe_when_call_update()
	-- given:
	local updatedframe
	animation.updateframe = function(self)
		updatedframe = self.frame
	end
	animation.frame = 2

	-- when:
	animation:update()

	-- then:
	assert_equal(2, updatedframe, "Should call updatedframe at frame 2.")
end

function animationtest.test_should_inc_frame_after_update()
	-- given:
	animation.on = {}
	animation.what = "a"
	animation.from = 10
	animation.to = 20
	animation.length = 5
	animation.frame = 4

	-- when:
	animation:update()

	-- then:
	assert_equal(5, animation.frame, "Should set the frame to 5 after the update.")
	assert_false(animation.finished, "Should not set as finished.")
end

function animationtest.test_should_set_finished_field_after_last_frame()
	-- given:
	animation.on = {}
	animation.what = "a"
	animation.from = 10
	animation.to = 20
	animation.length = 5
	animation.frame = 5

	-- when:
	animation:update()

	-- then:
	assert_equal(5, animation.frame, "Should keep the frame as 5 after the update.")
	assert_true(animation.finished, "Should set as finished.")
end

function animationtest.test_should_initialize_initial_value_with_current_value_if_nil()
	-- given:
	local t = {
		a = 10
	}
	animation.from = nil
	animation.to = 20
	animation.on = t
	animation.what = "a"

	-- when:
	animation:init()

	-- then:
	assert_equal(10, animation.from, "The initial value is not the expected.")
	assert_equal(20, animation.to, "The final value is not the expected.")
end

function animationtest.test_should_initialize_initial_value_with_current_value_if_nil()
	-- given:
	local t = {
		a = 10
	}
	animation.from = 20
	animation.to = nil
	animation.on = t
	animation.what = "a"

	-- when:
	animation:init()

	-- then:
	assert_equal(20, animation.from, "The initial value is not the expected.")
	assert_equal(10, animation.to, "The final value is not the expected.")
end

function animationtest.test_should_add_animation_as_scene_controller_when_call_execute()
	-- given:
	local context = {
		scene = vega.scene()
	}

	-- when:
	animation:execute(context)

	-- then:
	assert_equal(1, #context.scene.controllers, "The scene should have 1 attached controller.")
	assert_equal(animation, context.scene.controllers[1], "The animation should be the attached controller.")
end

return animationtest