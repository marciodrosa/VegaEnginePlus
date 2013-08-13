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

return utiltest