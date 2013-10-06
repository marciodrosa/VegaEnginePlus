local timelinetest = {}
local timeline
local context

function timelinetest.setup()
	timeline = vega.timeline()
	context = {}
end

function timelinetest.test_should_call_function_at_second_frame()
	-- given:
	local functionwasexecuted = false
	local contextarg = nil
	local function f(c)
		functionwasexecuted = true
		contextarg = c
	end
	timeline.actions = {
		[2] = f
	}

	-- when:
	timeline:update(context)

	-- then:
	assert_false(functionwasexecuted, "Should not have executed the function yet, the function should execute only in the next frame.")

	-- when:
	timeline:update(context)
	assert_true(functionwasexecuted, "Should have executed the function after update the second frame.")
	assert_equal(context, contextarg, "Should pass the context as argument to the function.")
end

return timelinetest