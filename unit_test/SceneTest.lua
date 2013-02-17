local SceneTest = {}

local scene = {}

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

return SceneTest
