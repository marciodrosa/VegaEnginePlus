local animationtracktest = {}

local animationtrack
local animation
local updatedframes

function animationtracktest.setup()
	animationtrack = vega.animationtrack()
	animation = vega.animation()
	updatedframes = {}
	animation.updateframe = function(self)
		table.insert(updatedframes, self.frame)
	end
	animation.on = {
		a = 0
	}
	animation.what = "a"
end

function animationtracktest.test_initial_values()
	assert_equal(1, animationtrack.iterations, "animationtrack.iterations is not the expected.")
	assert_equal(1, animationtrack.currentiteration, "animationtrack.currentiteration is not the expected.")
	assert_nil(animationtrack.length, "animationtrack.length is not the expected.")
	assert_table(animationtrack.animations, "animationtrack.animations is not the expected.")
	assert_false(animationtrack.pingpong, "animationtrack.pingpong is not the expected.")
	assert_equal(1, animationtrack.frame, "animationtrack.frame is not the expected.")
end

function animationtracktest.test_should_update_animation()
	-- given:
	animation.length = 3
	table.insert(animationtrack.animations, animation)

	-- when:
	animationtrack:update()
	animationtrack:update()
	animationtrack:update()

	-- then:
	assert_equal(3, #updatedframes, "Should have updated 3 frames of the animation.")
	assert_equal(1, updatedframes[1], "Should have updated the frame 1 of the animation.")
	assert_equal(2, updatedframes[2], "Should have updated the frame 2 of the animation.")
	assert_equal(3, updatedframes[3], "Should have updated the frame 3 of the animation.")
end

function animationtracktest.test_should_not_update_animation_before_initial_track_position()
	-- given:
	animation.length = 1
	animation.trackposition = 3
	table.insert(animationtrack.animations, animation)

	-- when / then:
	animationtrack:update()
	animationtrack:update()
	assert_equal(0, #updatedframes, "Should not have updated any frames of the animation, because the initial frame is the frame 3.")

	animationtrack:update()
	assert_equal(1, #updatedframes, "Should have updated 1 frame of the animation, after the update of the track frame 3.")
	assert_equal(1, updatedframes[1], "Should have updated the frame 1 of the animation.")
end

function animationtracktest.test_should_not_update_animation_after_the_end_of_the_animation()
	-- given:
	animationtrack.length = 10
	animation.length = 3
	animation.trackposition = 2
	table.insert(animationtrack.animations, animation)

	-- when / then:
	animationtrack.frame = 4
	animationtrack:update()
	assert_equal(1, #updatedframes, "Should have updated 1 frame of the animation, because the frame of the animation track is the last frame of the attached animation.")
	assert_equal(3, updatedframes[1], "Should have updated the last frame of the animation.")

	animationtrack:update()
	assert_equal(1, #updatedframes, "Should still have updated only 1 frame of the animation, because the animation length is reached, so it should not be updated anymore.")
end

function animationtracktest.test_should_finish_after_all_animations()
	-- given:
	local table t = {}

	local animation = vega.animation()
	animation.length = 2
	animation.trackposition = 2
	animation.updateframe = function() end
	animation.on = t
	animation.what = "a"

	local animation2 = vega.animation()
	animation2.length = 3
	animation2.trackposition = 3
	animation2.updateframe = function() end
	animation2.on = t
	animation2.what = "a"

	local animation3 = vega.animation()
	animation3.length = 2
	animation3.trackposition = 3
	animation3.updateframe = function() end
	animation3.on = t
	animation3.what = "a"

	animationtrack.animations = { animation, animation2, animation3 }

	-- when / then:
	animationtrack.frame = 4
	animationtrack:update()
	assert_nil(animationtrack.finished, "Should not be finished, it must update one more frame to complete the last animation.")

	animationtrack:update()
	assert_true(animationtrack.finished, "Should have finished, because the last updated frame was the last frame of the last animation.")
end

function animationtracktest.test_should_finish_after_update_frames_in_track_length()
	-- given:
	animationtrack.length = 3
	animation.length = 5
	animation.trackposition = 2
	table.insert(animationtrack.animations, animation)

	-- when / then:
	animationtrack:update()
	animationtrack:update()
	assert_nil(animationtrack.finished, "Should not be finished, the length is 3, but just 2 frames were updated.")

	animationtrack:update()
	assert_true(animationtrack.finished, "Should have finished after update 3 frames.")
end

function animationtracktest.test_should_iterate_n_times_before_finish()
	-- given:
	animationtrack.iterations = 3
	animation.length = 2
	animation.trackposition = 2
	table.insert(animationtrack.animations, animation)

	-- when:
	for i = 1, 8 do
		animationtrack:update()
	end

	-- then:
	assert_equal(5, #updatedframes, "Should have updated the animation 5 times, 2 for each iteration and 1 for the last iteration (not finished yet).")
	assert_equal(1, updatedframes[1], "Should have updated the frame 1 for the first iteration.")
	assert_equal(2, updatedframes[2], "Should have updated the frame 2 for the first iteration.")
	assert_equal(1, updatedframes[3], "Should have updated the frame 1 for the second iteration.")
	assert_equal(2, updatedframes[4], "Should have updated the frame 2 for the second iteration.")
	assert_equal(1, updatedframes[5], "Should have updated the frame 1 for the third iteration.")
	assert_nil(animationtrack.finished, "The track should not be finished yet.")

	-- when:
	animationtrack:update()
	assert_true(animationtrack.finished, "The track should be finished after the last update.")
	assert_equal(6, #updatedframes, "Should have updated the animation 6 times, 2 for each iteration.")
	assert_equal(2, updatedframes[6], "Should have updated the frame 1 for the third iteration.")	
end

function animationtracktest.test_should_iterate_infinite_times()
	-- given:
	animationtrack.iterations = 0
	animation.length = 2
	animation.trackposition = 2
	table.insert(animationtrack.animations, animation)

	-- when:
	for i = 1, 10 do
		animationtrack:update()
	end

	-- then:
	assert_equal(6, #updatedframes, "Should have updated the animation 6 times, 2 for each iteration.")
	assert_equal(1, updatedframes[1], "Should have updated the frame 1 for the first iteration.")
	assert_equal(2, updatedframes[2], "Should have updated the frame 2 for the first iteration.")
	assert_equal(1, updatedframes[3], "Should have updated the frame 1 for the second iteration.")
	assert_equal(2, updatedframes[4], "Should have updated the frame 2 for the second iteration.")
	assert_equal(1, updatedframes[5], "Should have updated the frame 1 for the third iteration.")
	assert_equal(2, updatedframes[6], "Should have updated the frame 2 for the third iteration.")
	assert_nil(animationtrack.finished, "The track should not be finished because it iterates infinite times.")
end

function animationtracktest.test_should_iterate_using_ping_pong()
	-- given:
	animationtrack.iterations = 0
	animationtrack.pingpong = true

	animation.length = 2
	animation.trackposition = 2
	table.insert(animationtrack.animations, animation)

	-- when:
	for i = 1, 9 do
		animationtrack:update()
	end

	-- then:
	assert_equal(6, #updatedframes, "Should have updated the animation 6 times, 2 for each iteration.")
	assert_equal(1, updatedframes[1], "Should have updated the frame 1 for the first iteration.")
	assert_equal(2, updatedframes[2], "Should have updated the frame 2 for the first iteration.")
	assert_equal(2, updatedframes[3], "Should have updated the frame 2 for the second iteration.")
	assert_equal(1, updatedframes[4], "Should have updated the frame 1 for the second iteration.")
	assert_equal(1, updatedframes[5], "Should have updated the frame 1 for the third iteration.")
	assert_equal(2, updatedframes[6], "Should have updated the frame 2 for the third iteration.")
	assert_nil(animationtrack.finished, "The track should not be finished because it iterates infinite times.")
end

function animationtracktest.test_should_initialize_animation_if_not_initialized_yet()
	-- given:
	local initwascalled
	local initarg
	animation.init = function(self)
		initwascalled = true
		initarg = self
	end
	table.insert(animationtrack.animations, animation)

	-- when:
	animationtrack:update()

	-- then:
	assert_true(initwascalled, "The init function should be called.")
	assert_equal(animation, initarg, "The init function should be called with self as argument.")
	assert_true(animation.initiated, "The initiated field should be setted in the animation table.")
end

function animationtracktest.test_should_not_initialize_animation_if_already_initialized()
	-- given:
	local initwascalled
	animation.init = function(self)
		initwascalled = true
	end
	animation.initiated = true
	table.insert(animationtrack.animations, animation)

	-- when:
	animationtrack:update()

	-- then:
	assert_false(initwascalled, "The init function should not be called because the animation is already initiated.")
end

function animationtracktest.test_should_add_animation_track_as_scene_controller_when_call_execute()
	-- given:
	local context = {
		scene = vega.scene()
	}

	-- when:
	animationtrack:execute(context)

	-- then:
	assert_equal(1, #context.scene.controllers, "The scene should have 1 attached controller.")
	assert_equal(animationtrack, context.scene.controllers[1], "The animation track should be the attached controller.")
end

return animationtracktest