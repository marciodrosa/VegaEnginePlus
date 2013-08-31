local mainlooptest = {}
local mainloop
local capicallstack = {}

function mainlooptest.setup()
	capicallstack = {}
	vega.capi = {
	}
	mainloop = vega.mainloop
end

function mainlooptest.test_should_have_a_context()
	assert_table(mainloop.context, "Should have a context field.")
end

return mainlooptest