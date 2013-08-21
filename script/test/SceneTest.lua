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
	local context = vega.Context:new()
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
	local context = vega.Context.new()
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
	local context = vega.Context:new()
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
	local context = vega.Context:new()
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

return scenetest
