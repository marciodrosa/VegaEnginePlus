local matrixtest = {}

function matrixtest.test_should_return_identity_matrix()
	-- when:
	local identitymatrix = vega.matrix.identity()

	-- then:
	assert_equal(1, identitymatrix[1][1], "Matrix[1][1] is not the expected.")
	assert_equal(0, identitymatrix[2][1], "Matrix[2][1] is not the expected.")
	assert_equal(0, identitymatrix[3][1], "Matrix[3][1] is not the expected.")
	assert_equal(0, identitymatrix[1][2], "Matrix[1][2] is not the expected.")
	assert_equal(1, identitymatrix[2][2], "Matrix[2][2] is not the expected.")
	assert_equal(0, identitymatrix[3][2], "Matrix[3][2] is not the expected.")
	assert_equal(0, identitymatrix[1][3], "Matrix[1][3] is not the expected.")
	assert_equal(0, identitymatrix[2][3], "Matrix[2][3] is not the expected.")
	assert_equal(1, identitymatrix[3][3], "Matrix[3][3] is not the expected.")
end

function matrixtest.test_should_multiply_matrixes()
	-- given:
	local m1 = {
		{ 1, 2, 3 },
		{ 4, 5, 6 },
		{ 7, 8, 9 }
	}
	local m2 = {
		{ 10, 20, 30 },
		{ 40, 50, 60 },
		{ 70, 80, 90 }
	}

	-- when:
	local result = vega.matrix.multiply(m1, m2)

	-- then:
	assert_equal(300, result[1][1], "Matrix[1][1] is not the expected.")
	assert_equal(660, result[2][1], "Matrix[2][1] is not the expected.")
	assert_equal(1020, result[3][1], "Matrix[3][1] is not the expected.")
	assert_equal(360, result[1][2], "Matrix[1][2] is not the expected.")
	assert_equal(810, result[2][2], "Matrix[2][2] is not the expected.")
	assert_equal(1260, result[3][2], "Matrix[3][2] is not the expected.")
	assert_equal(420, result[1][3], "Matrix[1][3] is not the expected.")
	assert_equal(960, result[2][3], "Matrix[2][3] is not the expected.")
	assert_equal(1500, result[3][3], "Matrix[3][3] is not the expected.")
end

return matrixtest