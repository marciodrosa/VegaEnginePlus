local SceneTest = {}

local scene = {}

local function createMockController()
	return {
		wasupdated = false,
		update = function(self, context)
			self.wasupdated = true
			self.context = context
		end
	}
end

function SceneTest.setup()
	scene = Scene.new()
	assert_table(scene, "Should create the Scene table.")
end

function SceneTest.test_should_initialize_scene_table()
	assert_table(scene.viewport, "Should create a viewport table.")
	assert_not_nil(scene.viewport.rootdrawable, "Should create an instance of the Viewport table, but the rootdrawable is not defined.")
	assert_equal(Color.new(25, 70, 255), scene.backgroundcolor, "backgroundcolor is not the expected.")
	assert_equal(30, scene.framespersecond, "framespersecond is not the expected.")
end

function SceneTest.test_should_update_all_controllers()
	-- given:
	local context = Context:new()
	local controller1 = createMockController()
	local controller2 = createMockController()
	scene.controllers = { controller1, controller2 }
	
	-- when:
	scene:updatecontrollers(context)
	
	-- then:
	assert_true(controller1.wasupdated, "Should call the update method of the first controller.")
	assert_true(controller2.wasupdated, "Should call the update method of the second controller.")
	assert_equal(context, controller1.context, "The context passed to the first controller is not the expected.")
	assert_equal(context, controller2.context, "The context passed to the second controller is not the expected.")
end

function SceneTest.test_should_not_update_controller_if_update_function_is_not_defined()
	-- given:
	local context = Context.new()
	local controllerwithoutupdatefunction = {}
	local controllerwithupdatefunction = createMockController()
	scene.controllers = { controllerwithoutupdatefunction, controllerwithupdatefunction }
	
	-- when:
	scene:updatecontrollers(context)
	
	-- then:
	assert_true(controllerwithupdatefunction.wasupdated, "Should update the second controller after skip the first controller.")
end

function SceneTest.test_should_not_update_controller_if_it_is_finished()
	-- given:
	local context = Context:new()
	local controller1 = createMockController()
	controller1.finished = true
	local controller2 = createMockController()
	scene.controllers = { controller1, controller2 }
	
	-- when:
	scene:updatecontrollers(context)
	
	-- then:
	assert_false(controller1.wasupdated, "Should not call the update method of the first controller because it is already finished.")
	assert_true(controller2.wasupdated, "Should call the update method of the second controller.")
	assert_equal(1, #scene.controllers, "Should have only one controller, because the finished controller should be removed.")
	assert_equal(controller2, scene.controllers[1], "The only controller in the list should be the second controller.")
end

function SceneTest.test_should_remove_controller_if_it_is_finished_after_update()
	-- given:
	local context = Context:new()
	local controller1 = {
		update = function(self)
			self.wasupdated = true
			self.finished = true -- finishes itself after the update
		end
	}
	local controller2 = createMockController()
	scene.controllers = { controller1, controller2 }
	
	-- when:
	scene:updatecontrollers(context)
	
	-- then:
	assert_true(controller1.wasupdated, "Should call the update method of the first controller.")
	assert_true(controller2.wasupdated, "Should call the update method of the second controller.")
	assert_equal(1, #scene.controllers, "Should have only one controller, because the finished controller should be removed.")
	assert_equal(controller2, scene.controllers[1], "The only controller in the list should be the second controller.")
end

return SceneTest












