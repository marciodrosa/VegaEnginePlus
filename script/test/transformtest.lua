local transformtest = {}

function transformtest.test_should_calculate_drawable_matrix()
	-- given:
	local drawable = vega.drawable {
		origin = { x = 10, y = 20 },
		position = { x = 100, y = 200 },
		rotation = 45,
		scale = { x = 1.5, y = 2.5 }
	}

	-- when:
	local matrix = vega.transform.getmatrix(drawable)

	-- then:
	assert_equal(1.060, matrix[1][1], 0.01, "The 1,1 cell of the matrix is not the expected.")
	assert_equal(-1.767, matrix[1][2], 0.01, "The 1,2 cell of the matrix is not the expected.")
	assert_equal(124.748, matrix[1][3], 0.01, "The 1,3 cell of the matrix is not the expected.")

	assert_equal(1.060, matrix[2][1], 0.01, "The 2,1 cell of the matrix is not the expected.")
	assert_equal(1.767, matrix[2][2], 0.01, "The 2,2 cell of the matrix is not the expected.")
	assert_equal(154.038, matrix[2][3], 0.01, "The 2,3 cell of the matrix is not the expected.")

	assert_equal(0, matrix[3][1], 0.01, "The 3,1 cell of the matrix is not the expected.")
	assert_equal(0, matrix[3][2], 0.01, "The 3,2 cell of the matrix is not the expected.")
	assert_equal(1, matrix[3][3], 0.01, "The 3,3 cell of the matrix is not the expected.")
end

function transformtest.test_should_transform_point()
	-- given:
	local m = {
		{ 1, 2, 3 },
		{ 4, 5, 6 },
		{ 7, 8, 9 }
	}
	local v = { x = 10, y = 11 }

	-- when:
	local result = vega.transform.transformpoint(v, m)

	-- then:
	assert_equal(35, result.x, "x is not the expected.")
	assert_equal(101, result.y, "y is not the expected.")
end

function transformtest.test_should_calculate_drawable_global_matrix()
	-- given:
	local drawable1 = vega.drawable {
		origin = { x = 10, y = 20 },
		position = { x = 100, y = 200 },
		rotation = 45,
		scale = { x = 1.5, y = 2.5 }
	}
	local drawable2 = vega.drawable {
		origin = { x = 30, y = 40 },
		position = { x = 110, y = 220 },
		rotation = -10,
		scale = { x = 2, y = 1.5 }
	}
	local drawable3 = vega.drawable {
		origin = { x = 50, y = 60 },
		position = { x = -500, y = -1000 },
		rotation = 80,
		scale = { x = 4, y = 5 }
	}

	drawable1.children.insert(drawable2)
	drawable2.children.insert(drawable3)

	-- when:
	local matrix = vega.transform.getglobalmatrix(drawable3)

	-- then:
	assert_equal(-7.3209, matrix[1][1], 0.01, "The 1,1 cell of the matrix is not the expected.")
	assert_equal(-15.3372, matrix[1][2], 0.01, "The 1,2 cell of the matrix is not the expected.")
	assert_equal(2134.6865, matrix[1][3], 0.01, "The 1,3 cell of the matrix is not the expected.")

	assert_equal(12.3997, matrix[2][1], 0.01, "The 2,1 cell of the matrix is not the expected.")
	assert_equal(-4.7565, matrix[2][2], 0.01, "The 2,2 cell of the matrix is not the expected.")
	assert_equal(-3459.9484, matrix[2][3], 0.01, "The 2,3 cell of the matrix is not the expected.")

	assert_equal(0, matrix[3][1], 0.01, "The 3,1 cell of the matrix is not the expected.")
	assert_equal(0, matrix[3][2], 0.01, "The 3,2 cell of the matrix is not the expected.")
	assert_equal(1, matrix[3][3], 0.01, "The 3,3 cell of the matrix is not the expected.")
end

function transformtest.test_should_calculate_drawable_global_matrix_with_layer()
	-- given:
	local drawable1 = vega.drawable {
		origin = { x = 10, y = 20 },
		position = { x = 100, y = 200 },
		rotation = 45,
		scale = { x = 1.5, y = 2.5 }
	}
	local drawable2 = vega.drawable {
		origin = { x = 30, y = 40 },
		position = { x = 110, y = 220 },
		childrenorigin = { x = -7, y = 8 },
		rotation = -10,
		scale = { x = 2, y = 1.5 }
	}
	local drawable3 = vega.drawable {
		origin = { x = 50, y = 60 },
		position = { x = -500, y = -1000 },
		rotation = 80,
		scale = { x = 4, y = 5 }
	}
	local cameraparent1 = vega.drawable {
		origin = { x = 70, y = 80 },
		position = { x = 120, y = 230 },
		rotation = 60,
		scale = { x = 1.5, y = 2.5 }
	}
	local cameraparent2 = vega.drawable {
		origin = { x = 90, y = 100 },
		position = { x = 130, y = 240 },
		rotation = -7,
		scale = { x = 0.8, y = 0.8 }
	}
	local camera = vega.camera {
		origin = { x = 100, y = 110 },
		position = { x = 140, y = 250 },
		rotation = -14,
		scale = { x = 5, y = 6 }
	}

	drawable1.children.insert(drawable2)
	drawable2.children.insert(drawable3)
	cameraparent1.children.insert(cameraparent2)
	cameraparent2.children.insert(camera)

	local layer = vega.layer {
		camera = camera,
		root = vega.drawable {
			children = {
				drawable1,
				cameraparent1
			}
		}
	}

	-- when:
	local matrix = vega.transform.getglobalmatrix(drawable3, layer)

	-- then:
	assert_equal(0.6519, matrix[1][1], 0.01, "The 1,1 cell of the matrix is not the expected.")
	assert_equal(-2.2249, matrix[1][2], 0.01, "The 1,2 cell of the matrix is not the expected.")
	assert_equal(-116.5531, matrix[1][3], 0.01, "The 1,3 cell of the matrix is not the expected.")

	assert_equal(1.3278, matrix[2][1], 0.01, "The 2,1 cell of the matrix is not the expected.")
	assert_equal(0.2616, matrix[2][2], 0.01, "The 2,2 cell of the matrix is not the expected.")
	assert_equal(-337.4195, matrix[2][3], 0.01, "The 2,3 cell of the matrix is not the expected.")

	assert_equal(0, matrix[3][1], 0.01, "The 3,1 cell of the matrix is not the expected.")
	assert_equal(0, matrix[3][2], 0.01, "The 3,2 cell of the matrix is not the expected.")
	assert_equal(1, matrix[3][3], 0.01, "The 3,3 cell of the matrix is not the expected.")
end

function transformtest.test_should_calculate_view_matrix()
	-- given:
	local cameraparent1 = vega.drawable {
		origin = { x = 70, y = 80 },
		position = { x = 120, y = 230 },
		rotation = 60,
		scale = { x = 1.5, y = 2.5 }
	}
	local cameraparent2 = vega.drawable {
		origin = { x = 90, y = 100 },
		position = { x = 130, y = 240 },
		rotation = -7,
		scale = { x = 0.8, y = 0.8 }
	}
	local camera = vega.camera {
		origin = { x = 100, y = 110 },
		position = { x = 140, y = 250 },
		rotation = -14,
		scale = { x = 5, y = 6 }
	}

	cameraparent1.children.insert(cameraparent2)
	cameraparent2.children.insert(camera)

	local layer = vega.layer {
		camera = camera,
	}

	-- when:
	local matrix = vega.transform.getviewmatrix(layer)

	-- then:
	assert_equal(0.1088, matrix[1][1], 0.01, "The 1,1 cell of the matrix is not the expected.")
	assert_equal(0.1168, matrix[1][2], 0.01, "The 1,2 cell of the matrix is not the expected.")
	assert_equal(57.9542, matrix[1][3], 0.01, "The 1,3 cell of the matrix is not the expected.")

	assert_equal(-0.0424, matrix[2][1], 0.01, "The 2,1 cell of the matrix is not the expected.")
	assert_equal(0.0820, matrix[2][2], 0.01, "The 2,2 cell of the matrix is not the expected.")
	assert_equal(34.3653, matrix[2][3], 0.01, "The 2,3 cell of the matrix is not the expected.")

	assert_equal(0, matrix[3][1], 0.01, "The 3,1 cell of the matrix is not the expected.")
	assert_equal(0, matrix[3][2], 0.01, "The 3,2 cell of the matrix is not the expected.")
	assert_equal(1, matrix[3][3], 0.01, "The 3,3 cell of the matrix is not the expected.")
end

function transformtest.test_should_calculate_position_relative_to_root()
	-- given:
	local drawable1 = vega.drawable {
		position = { x = 10, y = 20 },
		rotation = 45,
		scale = { x = 30, y = 40 },
		origin = { x = 50, y = 60 },
		childrenorigin = { x = 70, y = 80 },
	}
	local drawable2 = vega.drawable {
		position = { x = 90, y = 100 },
		rotation = 50,
		scale = { x = 110, y = 120 },
		origin = { x = 130, y = 140 },
		childrenorigin = { x = 150, y = 160 },
	}
	local drawable3 = vega.drawable {
		position = { x = 170, y = 180 },
		rotation = 55,
		scale = { x = 190, y = 200 },
		origin = { x = 210, y = 220 },
		childrenorigin = { x = 230, y = 240 },
	}
	drawable1.children.insert(drawable2)
	drawable2.children.insert(drawable3)

	-- when:
	local position = vega.transform.getpositionrelativetoroot(drawable3)

	-- then:
	assert_equal(226696907.9447, position.x, 0.0001, "position.x is not the expected.")
	assert_equal(38463992.0554, position.y, 0.0001, "position.y is not the expected.")

end

return transformtest