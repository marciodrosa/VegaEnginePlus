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

return matrixtest