local transformtest = {}
--[[
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
	assert_equal(1.060, matrix[1][2], 0.01, "The 1,2 cell of the matrix is not the expected.")
	assert_equal(308.198, matrix[1][3], 0.01, "The 1,3 cell of the matrix is not the expected.")

	assert_equal(-1.767, matrix[2][1], 0.01, "The 2,1 cell of the matrix is not the expected.")
	assert_equal(1.767, matrix[2][2], 0.01, "The 2,2 cell of the matrix is not the expected.")
	assert_equal(156.777, matrix[2][3], 0.01, "The 2,3 cell of the matrix is not the expected.")

	assert_equal(0, matrix[3][1], 0.01, "The 3,1 cell of the matrix is not the expected.")
	assert_equal(0, matrix[3][2], 0.01, "The 3,2 cell of the matrix is not the expected.")
	assert_equal(1, matrix[3][3], 0.01, "The 3,3 cell of the matrix is not the expected.")
end

function transformtest.test_should_calculate_global_drawable_matrix()
	-- given:
	local parent1 = vega.drawable {
		origin = { x = 10, y = 20 },
		position = { x = 100, y = 200 },
		rotation = 45,
		scale = { x = 1.5, y = 2.5 }
	}
	local parent2 = vega.drawable {
		origin = { x = 30, y = 40 },
		position = { x = 110, y = 220 },
		rotation = 35,
		scale = { x = 3.5, y = 4.5 }
	}
	local drawable = vega.drawable {
		origin = { x = 50, y = 60 },
		position = { x = 190, y = 280 },
		rotation = 25,
		scale = { x = 5.5, y = 6.5 }
	}
	parent1.children.insert(parent2)
	parent2.children.insert(drawable)

	-- when:
	local matrix = vega.transform.getglobalmatrix(drawable)

	-- then:
	assert_equal(1.060, matrix[1][1], 0.01, "The 1,1 cell of the matrix is not the expected.")
	assert_equal(1.060, matrix[1][2], 0.01, "The 1,2 cell of the matrix is not the expected.")
	assert_equal(308.198, matrix[1][3], 0.01, "The 1,3 cell of the matrix is not the expected.")

	assert_equal(-1.767, matrix[2][1], 0.01, "The 2,1 cell of the matrix is not the expected.")
	assert_equal(1.767, matrix[2][2], 0.01, "The 2,2 cell of the matrix is not the expected.")
	assert_equal(156.777, matrix[2][3], 0.01, "The 2,3 cell of the matrix is not the expected.")

	assert_equal(0, matrix[3][1], 0.01, "The 3,1 cell of the matrix is not the expected.")
	assert_equal(0, matrix[3][2], 0.01, "The 3,2 cell of the matrix is not the expected.")
	assert_equal(1, matrix[3][3], 0.01, "The 3,3 cell of the matrix is not the expected.")
end

function transformtest.test_should_calculate_global_drawable_matrix_on_layer()
	-- given:
	local camera = vega.camera {
		origin = { x = 5, y = 6 },
		position = { x = 7, y = 8 },
		rotation = 7,
		scale = { x = 0.5, y = 0.7 }
	}
	local parent1 = vega.drawable {
		origin = { x = 10, y = 20 },
		position = { x = 100, y = 200 },
		rotation = 45,
		scale = { x = 1.5, y = 2.5 }
	}
	local parent2 = vega.drawable {
		origin = { x = 30, y = 40 },
		position = { x = 110, y = 220 },
		rotation = 35,
		scale = { x = 3.5, y = 4.5 }
	}
	local drawable = vega.drawable {
		origin = { x = 50, y = 60 },
		position = { x = 190, y = 280 },
		rotation = 25,
		scale = { x = 5.5, y = 6.5 }
	}
	layer = vega.layer {
		camera = camera
	}
	parent1.children.insert(parent2)
	parent2.children.insert(drawable)

	-- when:
	local matrix = vega.transform.getglobalmatrix(drawable, layer)

	-- then:
	assert_equal(1.060, matrix[1][1], 0.01, "The 1,1 cell of the matrix is not the expected.")
	assert_equal(1.060, matrix[1][2], 0.01, "The 1,2 cell of the matrix is not the expected.")
	assert_equal(308.198, matrix[1][3], 0.01, "The 1,3 cell of the matrix is not the expected.")

	assert_equal(-1.767, matrix[2][1], 0.01, "The 2,1 cell of the matrix is not the expected.")
	assert_equal(1.767, matrix[2][2], 0.01, "The 2,2 cell of the matrix is not the expected.")
	assert_equal(156.777, matrix[2][3], 0.01, "The 2,3 cell of the matrix is not the expected.")

	assert_equal(0, matrix[3][1], 0.01, "The 3,1 cell of the matrix is not the expected.")
	assert_equal(0, matrix[3][2], 0.01, "The 3,2 cell of the matrix is not the expected.")
	assert_equal(1, matrix[3][3], 0.01, "The 3,3 cell of the matrix is not the expected.")
end
]]
return transformtest