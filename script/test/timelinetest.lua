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

	-- when / then:
	timeline:update(context)
	assert_false(functionwasexecuted, "Should not have executed the function yet, the function should execute only in the next frame.")

	timeline:update(context)
	assert_true(functionwasexecuted, "Should have executed the function after update the second frame.")
	assert_equal(context, contextarg, "Should pass the context as argument to the function.")
end

function timelinetest.test_should_call_two_actions()
	-- given:
	local firstfunctioncalls = 0
	local secondfunctioncalls = 0
	local function firstfunction() firstfunctioncalls = firstfunctioncalls + 1 end
	local function secondfunction() secondfunctioncalls = secondfunctioncalls + 1 end
	timeline.actions = {
		[2] = firstfunction,
		[4] = secondfunction
	}

	-- when / then:
	timeline:update(context)
	assert_equal(0, firstfunctioncalls, "Should not have called the first function yet after first update.")
	assert_equal(0, secondfunctioncalls, "Should not have called the second function yet after first update.")

	timeline:update(context)
	assert_equal(1, firstfunctioncalls, "Should have called the first function 1 time after second update.")
	assert_equal(0, secondfunctioncalls, "Should not have called the second function yet after second update.")

	timeline:update(context)
	assert_equal(1, firstfunctioncalls, "Should have called the first function 1 time after third update.")
	assert_equal(0, secondfunctioncalls, "Should not have called the second function yet after third update.")

	timeline:update(context)
	assert_equal(1, firstfunctioncalls, "Should have called the first function 1 time after fourth update.")
	assert_equal(1, secondfunctioncalls, "Should have called the second function 1 time after fourth update.")
end

function timelinetest.test_should_call_two_actions_at_same_frame()
	-- given:
	local firstfunctioncalls = 0
	local secondfunctioncalls = 0
	local calledfunctions = {}
	local function firstfunction()
		table.insert(calledfunctions, firstfunction)
	end
	local function secondfunction()
		table.insert(calledfunctions, secondfunction)
	end
	timeline.actions = {
		[1] = { firstfunction, secondfunction }
	}

	-- when / then:
	timeline:update(context)
	assert_equal(firstfunction, calledfunctions[1], "Should have called the first function.")
	assert_equal(secondfunction, calledfunctions[2], "Should have called the second function.")
end

return timelinetest