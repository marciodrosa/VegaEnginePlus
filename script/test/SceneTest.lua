local scenetest = {}

local scene = {}

local function createmockcontroller()
	return {
		wasupdated = false,
		update = function(self, context)
			self.wasupdated = true
			self.context = context
		end
	}
end

function scenetest.setup()
	scene = vega.scene()
	assert_table(scene, "Should create the Scene table.")
end

function scenetest.test_should_initialize_scene_table()
	assert_table(scene.layers, "Should create a layers table.")
	assert_equal(1, #scene.layers, "Should initialize the layers with one layer.")
	assert_table(scene.controllers, "Should create a controllers table.")
	assert_equal(0, #scene.controllers, "Should initialize the controllers with zero controllers.")
	assert_equal(25, scene.backgroundcolor.r, "backgroundcolor.r is not the expected.")
	assert_equal(70, scene.backgroundcolor.g, "backgroundcolor.g is not the expected.")
	assert_equal(255, scene.backgroundcolor.b, "backgroundcolor.b is not the expected.")
	assert_equal(30, scene.framespersecond, "framespersecond is not the expected.")
end

function scenetest.test_should_update_all_controllers()
	-- given:
	local context = vega.context()
	local controller1 = createmockcontroller()
	local controller2 = createmockcontroller()
	scene.controllers = { controller1, controller2 }
	
	-- when:
	scene:updatecontrollers(context)
	
	-- then:
	assert_true(controller1.wasupdated, "Should call the update method of the first controller.")
	assert_true(controller2.wasupdated, "Should call the update method of the second controller.")
	assert_equal(context, controller1.context, "The context passed to the first controller is not the expected.")
	assert_equal(context, controller2.context, "The context passed to the second controller is not the expected.")
end

function scenetest.test_should_not_update_controller_if_update_function_is_not_defined()
	-- given:
	local context = vega.context()
	local controllerwithoutupdatefunction = {}
	local controllerwithupdatefunction = createmockcontroller()
	scene.controllers = { controllerwithoutupdatefunction, controllerwithupdatefunction }
	
	-- when:
	scene:updatecontrollers(context)
	
	-- then:
	assert_true(controllerwithupdatefunction.wasupdated, "Should update the second controller after skip the first controller.")
end

function scenetest.test_should_not_update_controller_if_it_is_finished()
	-- given:
	local context = vega.context()
	local controller1 = createmockcontroller()
	controller1.finished = true
	local controller2 = createmockcontroller()
	scene.controllers = { controller1, controller2 }
	
	-- when:
	scene:updatecontrollers(context)
	
	-- then:
	assert_false(controller1.wasupdated, "Should not call the update method of the first controller because it is already finished.")
	assert_true(controller2.wasupdated, "Should call the update method of the second controller.")
	assert_equal(1, #scene.controllers, "Should have only one controller, because the finished controller should be removed.")
	assert_equal(controller2, scene.controllers[1], "The only controller in the list should be the second controller.")
end

function scenetest.test_should_remove_controller_if_it_is_finished_after_update()
	-- given:
	local context = vega.context()
	local controller1 = {
		update = function(self)
			self.wasupdated = true
			self.finished = true -- finishes itself after the update
		end
	}
	local controller2 = createmockcontroller()
	scene.controllers = { controller1, controller2 }
	
	-- when:
	scene:updatecontrollers(context)
	
	-- then:
	assert_true(controller1.wasupdated, "Should call the update method of the first controller.")
	assert_true(controller2.wasupdated, "Should call the update method of the second controller.")
	assert_equal(1, #scene.controllers, "Should have only one controller, because the finished controller should be removed.")
	assert_equal(controller2, scene.controllers[1], "The only controller in the list should be the second controller.")
end

function scenetest.test_should_call_controller_init_before_first_update()
	-- given:
	local context = vega.context()
	local controller = {
		functionscalled = {},

		init = function(self, context)
			self.contextoninit = context
			table.insert(self.functionscalled, self.init)
		end,

		update = function(self)
			table.insert(self.functionscalled, self.update)
		end
	}
	scene.controllers = { controller }
	
	-- when:
	scene:updatecontrollers(context)
	scene:updatecontrollers(context)
	scene:updatecontrollers(context)
	
	-- then:
	assert_equal(context, controller.contextoninit, "The context passed to init function is not the expected.")
	assert_equal(controller.init, controller.functionscalled[1], "The first called function is not the expected.")
	assert_equal(controller.update, controller.functionscalled[2], "The second called function is not the expected.")
	assert_equal(controller.update, controller.functionscalled[3], "The third called function is not the expected.")
	assert_equal(controller.update, controller.functionscalled[4], "The fourth called function is not the expected.")
	assert_true(controller.initiated, "Should set the 'initiated' field after init the controller.")
end

function scenetest.test_should_set_controller_as_initiated_event_if_without_init_function()
	-- given:
	local context = vega.context()
	local controller = {
		update = function(self)
		end
	}
	scene.controllers = { controller }
	
	-- when:
	scene:updatecontrollers(context)
	
	-- then:
	assert_true(controller.initiated, "Should set the 'initiated' field.")
end

function scenetest.test_should_not_init_controller_if_it_is_already_finished()
	-- given:
	local context = vega.context()
	local controller = {
		finished = true,

		init = function(self, context)
			self.initcalled = true
		end,
	}
	scene.controllers = { controller }
	
	-- when:
	scene:updatecontrollers(context)
	
	-- then:
	assert_nil(controller.initcalled, "Should not call the init function.")
	assert_nil(controller.initiated, "Should not set the initiated field.")
end

return scenetest
