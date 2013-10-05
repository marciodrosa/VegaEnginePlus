local showtest = {}

function showtest.test_should_create_animation_that_changes_visibility_field_to_one()
	-- when:
	local animation = vega.animations.show()

	-- then:
	assert_equal(1, animation.to, "animation.to is not the expected.")
	assert_equal("visibility", animation.what, "animation.what is not the expected.")
	assert_function(animation.updateframe, "The object should have the functions of the animation table.")
end

function showtest.test_should_use_initial_values()
	-- when:
	local mydrawable = vega.drawable()
	local animation = vega.animations.show {
		on = mydrawable
	}

	-- then:
	assert_equal(1, animation.to, "animation.to is not the expected.")
	assert_equal("visibility", animation.what, "animation.what is not the expected.")
	assert_equal(mydrawable, animation.on, "animation.on is not the expected.")
	assert_function(animation.updateframe, "The object should have the functions of the animation table.")
end

function showtest.test_should_replace_default_values_with_initial_values()
	-- when:
	local animation = vega.animations.show {
		to = 0.5
	}

	-- then:
	assert_equal(0.5, animation.to, "animation.to is not the expected.")
	assert_equal("visibility", animation.what, "animation.what is not the expected.")
	assert_function(animation.updateframe, "The object should have the functions of the animation table.")
end

return showtest