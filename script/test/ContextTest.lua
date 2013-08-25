local contexttest = {}

function contexttest.setup()
	StartComponent = {}
end

function contexttest.teardown()
	StartComponent = nil
end

function contexttest.test_should_create_new_context()
	-- when:
	context = vega.context()
	
	-- then:
	assert_table(context)
	assert_true(context.executing, "The executing flag should be true.")
	assert_equal(StartComponent, context.component, "component is not the expected.")
	assert_table(context.contentmanager, "Should create a contentmanager table.")
	assert_table(context.input, "Should create an input table.")
	assert_table(context.output, "Should create an output table.")
	assert_table(context.output.display, "Should create a display table into the output table.")
end

return contexttest
