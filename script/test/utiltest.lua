local utiltest = {}

function utiltest.test_should_copy_values_into_table()
	-- given:
	local values = {
		somevalue = "a",
		somenumber = 10
	}
	local table = {}

	-- when:
	local returnedtable = vega.util.copyvaluesintotable(values, table)

	-- then:
	assert_equal(table, returnedtable, "The function should return the table.")
	assert_equal("a", table.somevalue, "table.somevalue is not the expected.")
	assert_equal(10, table.somenumber, "table.somenumber is not the expected.")
end

function utiltest.test_should_not_copy_values_into_table_if_values_is_nil()
	-- given:
	local table = {}

	-- when:
	local returnedtable = vega.util.copyvaluesintotable(nil, table)

	-- then:
	assert_equal(table, returnedtable, "The function should return the table.")
end

function utiltest.test_should_mix_tables()
	-- given:
	local t1 = {
		a = 10,
		b = 20,
	}
	local t2 = {
		b = 30,
		c = 40
	}
	local t3 = {
		c = 50,
		d = 60
	}

	-- when:
	local result = vega.util.mix { t1, t2, t3 }

	-- then:
	assert_equal(t1, result, "The result should be the same table as the first argument.")
	assert_equal(10, result.a, "result.a is not the expected.")
	assert_equal(30, result.b, "result.b is not the expected.")
	assert_equal(50, result.c, "result.c is not the expected.")
	assert_equal(60, result.d, "result.d is not the expected.")
end

function utiltest.test_should_return_nil_when_mix_zero_tables()
	-- when:
	local result = vega.util.mix {}

	-- then:
	assert_nil(result)
end

function utiltest.test_should_return_table_when_mix_single_table()
	-- given:
	local t = {
		a = 10
	}

	-- when:
	local result = vega.util.mix { t }

	-- then:
	assert_equal(t, result, "Should return the same table passed as argument.")
	assert_equal(10, result.a, "result.a is not the expected.")
end

return utiltest