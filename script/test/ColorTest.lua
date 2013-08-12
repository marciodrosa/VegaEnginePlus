local colortest = {}

function colortest.test_should_return_components_from_number()
	-- given:
	local color = 0xd2648c3c

	-- when:
	local components = vega.color.getcomponents(color)

	-- then:
	assert_equal(210, components.a, "a is not the expected.")
	assert_equal(100, components.r, "r is not the expected.")
	assert_equal(140, components.g, "g is not the expected.")
	assert_equal(60, components.b, "b is not the expected.")
end

function colortest.test_should_return_components_from_table()
	-- given:
	local color = {
		a = 1,
		r = 2,
		g = 3,
		b = 4
	}

	-- when:
	local components = vega.color.getcomponents(color)

	-- then:
	assert_equal(1, components.a, "a is not the expected.")
	assert_equal(2, components.r, "r is not the expected.")
	assert_equal(3, components.g, "g is not the expected.")
	assert_equal(4, components.b, "b is not the expected.")
end

function colortest.test_should_return_components_from_table_using_default_values_for_nil_fields()
	-- given:
	local color = {
	}

	-- when:
	local components = vega.color.getcomponents(color)

	-- then:
	assert_equal(255, components.a, "a is not the expected.")
	assert_equal(0, components.r, "r is not the expected.")
	assert_equal(0, components.g, "g is not the expected.")
	assert_equal(0, components.b, "b is not the expected.")
end

function colortest.test_should_return_nil_components_when_color_is_nil()
	-- when:
	local components = vega.color.getcomponents(nil)

	-- then:
	assert_nil(components, "Should return nil.")
end

function colortest.test_should_throw_error_when_get_components_from_an_invalid_color_type()
	assert_error("Can not get components from color, it should be a table or number, but was string.", function() vega.color.getcomponents("") end, "Should thrown a error when color is a string.")
	assert_error("Can not get components from color, it should be a table or number, but was boolean.", function() vega.color.getcomponents(true) end, "Should thrown a error when color is a boolean.")
	assert_error("Can not get components from color, it should be a table or number, but was function.", function() vega.color.getcomponents(function() end) end, "Should thrown a error when color is a function.")
end

function colortest.test_should_return_hexa_from_number()
	-- given:
	local color = 0xd2648c3c

	-- when:
	local hexa = vega.color.gethexa(color)

	-- then:
	assert_equal(0xd2648c3c, hexa, "The result is not the expected.")
end

function colortest.test_should_return_hexa_from_table()
	-- given:
	local color = {
		a = 210,
		r = 100,
		g = 140,
		b = 60
	}

	-- when:
	local hexa = vega.color.gethexa(color)

	-- then:
	assert_equal(0xd2648c3c, hexa, "The result is not the expected.")
end

function colortest.test_should_return_hexa_from_table_using_default_values_for_nil_fields()
	-- given:
	local color = {
	}

	-- when:
	local hexa = vega.color.gethexa(color)

	-- then:
	assert_equal(0xff000000, hexa, "The result is not the expected.")
end

function colortest.test_should_return_nil_hexa_when_color_is_nil()
	-- when:
	local hexa = vega.color.gethexa(nil)

	-- then:
	assert_nil(hexa, "Should return nil.")
end

function colortest.test_should_throw_error_when_get_hexa_from_an_invalid_color_type()
	assert_error("Can not get hexadecimal value from color, it should be a table or number, but was string.", function() vega.color.gethexa("") end, "Should thrown a error when color is a string.")
	assert_error("Can not get hexadecimal value from color, it should be a table or number, but was boolean.", function() vega.color.gethexa(true) end, "Should thrown a error when color is a boolean.")
	assert_error("Can not get hexadecimal value from color, it should be a table or number, but was function.", function() vega.color.gethexa(function() end) end, "Should thrown a error when color is a function.")
end

return colortest