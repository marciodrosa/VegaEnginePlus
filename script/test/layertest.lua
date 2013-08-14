local layertest = {}

function layertest.test_should_initialize_with_a_camera_and_a_root()
	-- when:
	local layer = vega.layer()

	-- then:
	assert_table(layer, "Should return a table.")
	assert_table(layer.camera, "Should return a camera table.")
	assert_table(layer.root, "Should return a root table.")
	assert_not_nil(layer.camera.autocalculatewidth, "Should return a camera table, but it doesn't have the autocalculatewidth field.")
	assert_not_nil(layer.root.position, "Should return a drawable table, but it doesn't have the position field.")
end

function layertest.test_should_initialize_with_initial_values()
	-- given:
	local root = vega.drawable()
	local camera = vega.camera()

	-- when:
	local layer = vega.layer {
		root = root,
		camera = camera,
	}

	-- then:
	assert_equal(root, layer.root, "layer.root is not the expected.")
	assert_equal(camera, layer.camera, "layer.camera is not the expected.")
end

return layertest