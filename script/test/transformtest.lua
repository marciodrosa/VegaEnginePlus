local transformtest = {}

function transformtest.test_should_calculate_drawable_matrix()
	--[[
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
	assert_equal(0, matrix[1][3], 0.01, "The 1,3 cell of the matrix is not the expected.")

	assert_equal(-1.767, matrix[2][1], 0.01, "The 2,1 cell of the matrix is not the expected.")
	assert_equal(1.767, matrix[2][2], 0.01, "The 2,2 cell of the matrix is not the expected.")
	assert_equal(0, matrix[2][3], 0.01, "The 2,3 cell of the matrix is not the expected.")

	assert_equal(0, matrix[3][1], 0.01, "The 3,1 cell of the matrix is not the expected.")
	assert_equal(0, matrix[3][2], 0.01, "The 3,2 cell of the matrix is not the expected.")
	assert_equal(1, matrix[3][3], 0.01, "The 3,3 cell of the matrix is not the expected.")]]
end

return transformtest