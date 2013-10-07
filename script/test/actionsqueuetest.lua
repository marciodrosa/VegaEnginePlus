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

	-- when / then:
	actionsqueue:update(context)
	assert_true(t2executed, "The second table should be executed, because the first table was executed and finished.")
end

return actionsqueuetest