local ViewportTest = {}

local viewport = {}

function ViewportTest.setup()
	viewport = vega.Viewport.new()
	assert_table(viewport, "Should create the Viewport table.")
end

function ViewportTest.test_should_initialize_table()
	assert_equal(1, viewport.sceneviewheight, "sceneviewheight is not the expected.")
	assert_table(viewport.rootdrawable, "rootdrawable is not the expected.")
	assert_not_nil(viewport.rootdrawable.position, "rootdrawable should be a Drawable table, but doesn't have the position field.")
end

function ViewportTest.test_should_set_position_and_size_of_root_drawable_to_fit_screen()
	-- given:
	viewport.sceneviewheight = 480
	
	-- when:
	viewport:updatescreensize(1366, 768)
	
	-- then:
	assert_equal(0, viewport.rootdrawable.position.x, "Should set the position.x of the root drawable to 0.")
	assert_equal(0, viewport.rootdrawable.position.y, "Should set the position.y of the root drawable to 0.")
	assert_equal(853.75, viewport.rootdrawable.size.x, 0.01, "Should set the width of the root drawable to fit the proportions of the screen")
	assert_equal(480, viewport.rootdrawable.size.y, 0.01, "Should set the heigth of the root drawable to fit the proportions of the screen")
end

return ViewportTest
