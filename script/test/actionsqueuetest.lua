local actionsqueuetest = {}
local actionsqueue
local context

function actionsqueuetest.setup()
	actionsqueue = vega.actionsqueue()
	context = {}
end

function actionsqueuetest.test_should_execute_attached_tables_one_after_other()
	-- given:
	local t1executed = false
	local t1selfarg
	local t1contextarg
	local t2executed = false
	local t2selfarg
	local t2contextarg
	local t1 = {
		execute = function(self, context)
			t1executed = true
			t1selfarg = self
			t1contextarg = context
		end
	}
	local t2 = {
		execute = function(self, context)
			t2executed = true
			t2selfarg = self
			t2contextarg = context
		end
	}
	actionsqueue.actions = { t1, t2 }

	-- when / then:
	actionsqueue:update(context)
	assert_true(t1executed, "The first table should have been executed.")
	assert_equal(t1, t1selfarg, "The self arg passed to the first table is not the expected.")
	assert_equal(context, t1contextarg, "The context arg passed to the first table is not the expected.")

	actionsqueue:update(context)
	actionsqueue:update(context)
	actionsqueue:update(context)
	assert_false(t2executed, "The t2 should be executed only after the t1 was finished.")

	t1.finished = true
	actionsqueue:update(context)
	assert_true(t2executed, "The second table should have been executed.")
	assert_equal(t2, t2selfarg, "The self arg passed to the second table is not the expected.")
	assert_equal(context, t2contextarg, "The context arg passed to the second table is not the expected.")

	actionsqueue:update(context)
	actionsqueue:update(context)
	actionsqueue:update(context)
	assert_nil(actionsqueue.finished, "The actions queue should not be finished because one of the tables is not finished yet.")

	t2.finished = true
	actionsqueue:update(context)
	assert_true(actionsqueue.finished, "The actions queue should be finished after all tables were finished.")
end

function actionsqueuetest.test_should_execute_next_table_in_the_same_frame_if_current_table_is_finished()
	-- given:
	local t2executed = true
	local t1 = {
		execute = function(self, context)
			self.finished = true
		end
	}
	local t2 = {
		execute = function(self, context)
			t2executed = true
		end
	}
	actionsqueue.actions = { t1, t2 }

	-- when:
	actionsqueue:update(context)

	-- then:
	assert_true(t2executed, "The second table should be executed, because the first table was executed and finished.")
end

function actionsqueuetest.test_should_execute_action_functions()
	-- given:
	local t1executed = false
	local f1executed = false
	local f1contextarg
	local f2executed = false
	local t1 = {
		execute = function(self, context)
			t1executed = true
		end
	}
	local f1 = function(context)
		f1executed = true
		f1contextarg = context
	end
	local f2 = function(context)
		f2executed = true
	end
	actionsqueue.actions = { f1, t1, f2 }

	-- when / then:
	actionsqueue:update(context)
	assert_true(f1executed, "The first function should be executed.")
	assert_equal(context, f1contextarg, "The context arg passed to the function is not the expected.")
	assert_true(t1executed, "The first table should be executed.")

	actionsqueue:update(context)
	actionsqueue:update(context)
	assert_false(f2executed, "The second function should not be executed before the previous table is finished.")
	assert_nil(actionsqueue.finished, "The actions queue should not be finished yet.")

	t1.finished = true
	actionsqueue:update(context)
	assert_true(f2executed, "The second function should be executed.")
	assert_true(actionsqueue.finished, "The actions queue should be finished.")
end

function actionsqueuetest.test_should_initialize_with_list_of_tables_and_functions()
	-- given:
	local list = {
		function() end,
		function() end,
		{}
	}

	-- when:
	actionsqueue = vega.actionsqueue(list)

	-- then:
	assert_equal(list, actionsqueue.actions, "Should create the actions queue using the list passed as parameter.")
end

function actionsqueuetest.test_should_attach_controller_to_scene_when_call_execute_function()
	-- given:
	local scene = vega.scene()
	context.scene = scene

	-- when:
	actionsqueue:execute(context)

	-- then:
	assert_equal(1, #scene.controllers, "The scene should have 1 attached controller.")
	assert_equal(actionsqueue, scene.controllers[1], "The actions queue should be the attached controller.")
end

return actionsqueuetest