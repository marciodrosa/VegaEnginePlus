local contexttest = {}
local context

function contexttest.setup()
	context = vega.context()
end

function contexttest.teardown()
end

function contexttest.test_should_create_new_context()
	assert_table(context)
	assert_true(context.executing, "The executing flag should be true.")
	assert_false(context.isframeupdating, "The isframeupdating flag should be false.")
	assert_nil(context.module, "module should be nil.")
	assert_nil(context.scene, "scene should be nil.")
	assert_nil(context.nextmodule, "nextmodule should be nil.")
	assert_nil(context.nextscene, "nextscene should be nil.")
	assert_table(context.content, "Should create a content table.")
	assert_table(context.input, "Should create an input table.")
	assert_table(context.output, "Should create an output table.")
	assert_table(context.output.display, "Should create a display table into the output table.")
end

function contexttest.test_should_throw_error_when_set_scene_and_frame_is_updating()
	-- given:
	context.isframeupdating = true

	-- then:
	assert_error("Set the scene field of the context while the frame is being updated is forbidden. Set nextscene field instead, so the changes will apply in the next frame.", function() context.scene = {} end)
	assert_nil(context.scene, "Should not set the scene field.")
end

function contexttest.test_should_throw_error_when_set_module_and_frame_is_updating()
	-- given:
	context.isframeupdating = true

	-- then:
	assert_error("Set the module field of the context while the frame is being updated is forbidden. Set nextmodule field instead, so the changes will apply in the next frame.", function() context.module = {} end)
	assert_nil(context.module, "Should not set the module field.")
end

function contexttest.test_should_not_throw_error_when_set_scene_and_frame_is_not_updating()
	-- given:
	context.isframeupdating = false

	-- when:
	local scene = vega.scene()
	context.scene = scene

	-- then:
	assert_equal(scene, context.scene, "Should set the scene field.")
end

function contexttest.test_should_not_throw_error_when_set_module_and_frame_is_not_updating()
	-- given:
	context.isframeupdating = false

	-- when:
	local m = {}
	context.module = m

	-- then:
	assert_equal(m, context.module, "Should set the module field.")
end

function contexttest.test_should_iterate_by_fields()
	-- given:
	local scene = vega.scene()
	local m = {}
	local nextscene = vega.scene()
	local nextmodule = {}
	context.scene = scene
	context.module = m
	context.nextscene = nextscene
	context.nextmodule = nextmodule

	-- when:
	local t = {}
	for k, v in pairs(context) do
		t[k] = v
	end

	-- then:
	assert_equal(scene, t.scene, "Should set the scene in the temp table.")
	assert_equal(m, t.module, "Should set the module in the temp table.")
	assert_equal(nextscene, t.nextscene, "Should set the nextscene in the temp table.")
	assert_equal(nextmodule, t.nextmodule, "Should set the nextmodule in the temp table.")
	assert_false(t.isframeupdating, "Should set the isframeupdating in the temp table.")
	assert_true(t.executing, "Should set the executing in the temp table.")
	assert_table(t.content, "Should set the content in the temp table.")
	assert_table(t.input, "Should set the input in the temp table.")
	assert_table(t.output, "Should set the output in the temp table.")
end

return contexttest
