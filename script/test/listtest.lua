local listtest = {}
local list = {}
local callbackmock = {}

function listtest.setup()
	list = vega.list()
	assert_table(list, "Should create a table for the list.")

	callbackmock = {}

	function callbackmock.beforeremove(index, value)
		callbackmock.beforeremovecalled = true
		callbackmock.beforeremoveindex = index
		callbackmock.beforeremovevalue = value
	end

	function callbackmock.afterremove(index, value)
		callbackmock.afterremovecalled = true
		callbackmock.afterremoveindex = index
		callbackmock.afterremovevalue = value
	end

	function callbackmock.beforeset(index, value)
		callbackmock.beforesetcalled = true
		callbackmock.beforesetindex = index
		callbackmock.beforesetvalue = value
	end

	function callbackmock.afterset(index, value)
		callbackmock.aftersetcalled = true
		callbackmock.aftersetindex = index
		callbackmock.aftersetvalue = value
	end
end

function listtest.test_should_get_and_set_using_index()
	-- given:
	local v1 = {}
	local v2 = {}
	local v3 = {}

	-- when:
	list[1] = v1
	list[2] = v2
	list[3] = v3

	-- then:
	assert_equal(v1, list[1], "list[1] is not the expected.")
	assert_equal(v2, list[2], "list[2] is not the expected.")
	assert_equal(v3, list[3], "list[3] is not the expected.")
end

function listtest.test_should_override_when_set_using_index()
	-- given:
	local v1 = {}
	local v2 = {}
	local v3 = {}
	local v4 = {}
	list[1] = v1
	list[2] = v2
	list[3] = v3

	-- when:
	list[2] = v4

	-- then:
	assert_equal(3, #list, "The length of the list is not the expected.")
	assert_equal(v1, list[1], "list[1] is not the expected.")
	assert_equal(v4, list[2], "list[2] is not the expected.")
	assert_equal(v3, list[3], "list[3] is not the expected.")
end

function listtest.test_should_insert_at_end_and_set_name_field()
	-- given:
	local v1 = {}
	local v2 = {}
	list[1] = v1

	-- when:
	list["an alias"] = v2

	-- then:
	assert_equal(v1, list[1], "list[1] is not the expected.")
	assert_equal(v2, list[2], "list[2] is not the expected.")
	assert_equal("an alias", v2.name, "Should set the 'name' field on v2.")
end

function listtest.test_should_get_using_name()
	-- given:
	list[1] = { name = "an alias" }
	list[2] = {}
	list[3] = 10
	list[4] = { anotherfield = "expected alias" }
	list[5] = { name = "expected alias" }
	list[6] = { name = "another alias" }

	-- when:
	local value = list["expected alias"]

	-- then:
	assert_equal(list[5], value)
end

function listtest.test_should_not_override_when_set_using_name()
-- given:
	local v1 = {}
	local v2 = {}
	local v3 = {}
	local v4 = {}
	list[1] = v1
	list["an alias"] = v2
	list[3] = v3

	-- when:
	list["an alias"] = v4

	-- then:
	assert_equal(4, #list, "The length of the list is not the expected.")
	assert_equal(v1, list[1], "list[1] is not the expected.")
	assert_equal(v2, list[2], "list[2] is not the expected.")
	assert_equal(v3, list[3], "list[3] is not the expected.")
	assert_equal(v4, list[4], "list[4] is not the expected.")
end

function listtest.test_should_throw_error_when_set_a_no_table_with_string_key()
	-- when / then:
	assert_error("When set a value into the list using a name key, the value must be a table.", function() list["str"] = 10 end, "Should throw an error when set a number value with string key.")
	assert_error("When set a value into the list using a name key, the value must be a table.", function() list["str"] = true end, "Should throw an error when set a bool value with string key.")
	assert_error("When set a value into the list using a name key, the value must be a table.", function() list["str"] = "str" end, "Should throw an error when set a string value with string key.")
	assert_error("When set a value into the list using a name key, the value must be a table.", function() list["str"] = function() end end, "Should throw an error when set a function value with string key.")
end

function listtest.test_should_throw_error_when_set_value_without_string_or_number_key()
	-- when / then:
	list["string key"] = {}
	list[10] = {}
	assert_error("When set a value into the list, the key must be a number or string.", function() list[true] = {} end, "Should throw an error when set a bool key.")
	assert_error("When set a value into the list, the key must be a number or string.", function() list[{}] = {} end, "Should throw an error when set a table key.")
	assert_error("When set a value into the list, the key must be a number or string.", function() list[function() end] = {} end, "Should throw an error when set a function key.")
end

function listtest.test_should_insert_at_end()
	-- given:
	local v1 = {}
	local v2 = {}
	local v3 = {}
	list[1] = v1

	-- when:
	list.insert(v2)
	list.insert(v3)

	-- then:
	assert_equal(3, #list, "The length of the list is not the expected.")
	assert_equal(v1, list[1], "list[1] is not the expected.")
	assert_equal(v2, list[2], "list[2] is not the expected.")
	assert_equal(v3, list[3], "list[3] is not the expected.")
end

function listtest.test_should_insert_at_index_and_shift_other_elements()
	-- given:
	local v1 = {}
	local v2 = {}
	local v3 = {}
	local v4 = {}
	list[1] = v1
	list[2] = v2
	list[3] = v3

	-- when:
	list.insert(v4, 2)

	-- then:
	assert_equal(4, #list, "The length of the list is not the expected.")
	assert_equal(v1, list[1], "list[1] is not the expected.")
	assert_equal(v4, list[2], "list[2] is not the expected.")
	assert_equal(v2, list[3], "list[3] is not the expected.")
	assert_equal(v3, list[4], "list[4] is not the expected.")
end

function listtest.test_should_remove_by_index()
	-- given:
	local v1 = {}
	local v2 = {}
	local v3 = {}
	local v4 = {}
	list[1] = v1
	list[2] = v2
	list[3] = v3
	list[4] = v4

	-- when:
	list.remove(2)

	-- then:
	assert_equal(3, #list, "The length of the list is not the expected.")
	assert_equal(v1, list[1], "list[1] is not the expected.")
	assert_equal(v3, list[2], "list[2] is not the expected.")
	assert_equal(v4, list[3], "list[3] is not the expected.")
end

function listtest.test_should_remove_by_name()
	-- given:
	local v1 = {}
	local v3 = {}
	local v4 = {}
	v1.name = "an alias"
	v3.name = "expected alias"
	list[1] = v1
	list[2] = 10
	list[3] = v3
	list[4] = v4

	-- when:
	list.remove("expected alias")

	-- then:
	assert_equal(3, #list, "The length of the list is not the expected.")
	assert_equal(v1, list[1], "list[1] is not the expected.")
	assert_equal(10, list[2], "list[2] is not the expected.")
	assert_equal(v4, list[3], "list[3] is not the expected.")
end

function listtest.test_should_remove_by_value()
	-- given:
	local v1 = {}
	local v3 = {}
	local v4 = {}
	list[1] = v1
	list[2] = 10
	list[3] = v3
	list[4] = v4

	-- when:
	list.remove(v3)

	-- then:
	assert_equal(3, #list, "The length of the list is not the expected.")
	assert_equal(v1, list[1], "list[1] is not the expected.")
	assert_equal(10, list[2], "list[2] is not the expected.")
	assert_equal(v4, list[3], "list[3] is not the expected.")
end

function listtest.test_should_remove_many_values_by_name()
	-- given:
	local v1 = {}
	local v2 = {}
	local v3 = {}
	local v4 = {}
	v1.name = "expected alias"
	v3.name = "expected alias"
	list[1] = v1
	list[2] = v2
	list[3] = v3
	list[4] = v4

	-- when:
	list.remove("expected alias")

	-- then:
	assert_equal(2, #list, "The length of the list is not the expected.")
	assert_equal(v2, list[1], "list[1] is not the expected.")
	assert_equal(v4, list[2], "list[2] is not the expected.")
end

function listtest.test_should_remove_many_values_by_value()
	-- given:
	local v1 = {}
	local v2 = {}
	local v3 = {}
	list[1] = v1
	list[2] = v2
	list[3] = v3
	list[4] = v2

	-- when:
	list.remove(v2)

	-- then:
	assert_equal(2, #list, "The length of the list is not the expected.")
	assert_equal(v1, list[1], "list[1] is not the expected.")
	assert_equal(v3, list[2], "list[2] is not the expected.")
end

function listtest.test_should_return_list_length()
	-- given:
	list[1] = {}
	list[2] = {}
	list[3] = {}
	list["str"] = {}

	-- when:
	local length = #list

	-- then:
	assert_equal(4, length)
end

function listtest.test_should_iterate_by_indexes_using_ipairs_function()
	-- given:
	list[1] = {}
	list[2] = {}
	list[3] = {}
	list["str"] = {}

	-- when:
	local t = {}
	for i, v in ipairs(list) do
		t[i] = v
	end

	-- then:
	assert_equal(4, #t, "The length of the auxiliar table is not the expected.")
	assert_equal(list[1], t[1], "The first element returned on iteration is not the expected.")
	assert_equal(list[2], t[2], "The second element returned on iteration is not the expected.")
	assert_equal(list[3], t[3], "The third element returned on iteration is not the expected.")
	assert_equal(list[4], t[4], "The fourth element returned on iteration is not the expected.")
end

function listtest.test_should_iterate_by_keys_using_pairs_function()
	-- given:
	list[1] = {}
	list[2] = {}
	list[3] = {}
	list["str"] = {}

	-- when:
	local t = {}
	local keyscount = 0
	for k, v in pairs(list) do
		t[k] = v
		keyscount = keyscount + 1
	end

	-- then:
	assert_equal(4, keyscount, "The keys count is not the expected.")
	assert_equal(list[1], t[1], "The value of key 1 returned on iteration is not the expected.")
	assert_equal(list[2], t[2], "The value of key 2 returned on iteration is not the expected.")
	assert_equal(list[3], t[3], "The value of key 3 returned on iteration is not the expected.")
	assert_equal(list[4], t[4], "The value of key 4 returned on iteration is not the expected.")
end

function listtest.test_should_insert_same_element()
	-- given:
	local value = {}

	-- when:
	list.insert(value)
	list.insert(value)

	-- then:
	assert_equal(2, #list, "The length of the list is not the expected.")
	assert_equal(value, list[1], "list[1] is not the expected.")
	assert_equal(value, list[2], "list[2] is not the expected.")
end

function listtest.test_should_set_same_element()
	-- given:
	local value = {}

	-- when:
	list[1] = value
	list[2] = value

	-- then:
	assert_equal(2, #list, "The length of the list is not the expected.")
	assert_equal(value, list[1], "list[1] is not the expected.")
	assert_equal(value, list[2], "list[2] is not the expected.")
end

function listtest.test_should_not_insert_same_element()
	-- given:
	list = vega.list { singleoccurrence = true }
	local value = {}

	-- when:
	list.insert(value)
	list.insert(value)

	-- then:
	assert_equal(1, #list, "The length of the list is not the expected.")
	assert_equal(value, list[1], "list[1] is not the expected.")
end

function listtest.test_should_not_set_same_element()
	-- given:
	list = vega.list { singleoccurrence = true }
	local value = {}

	-- when:
	list[1] = value
	list[2] = value

	-- then:
	assert_equal(1, #list, "The length of the list is not the expected.")
	assert_equal(value, list[1], "list[1] is not the expected.")
end

function listtest.test_should_initialize_with_table_elements()
	-- given:
	local v1 = {}
	local v2 = {}
	local v3 = {}
	local t = { v1, v2, v3, v2 }

	-- when:
	list = vega.list { initialvalues = t }

	-- then:
	assert_equal(4, #list, "The length of the list is not the expected.")
	assert_equal(v1, list[1], "list[1] is not the expected.")
	assert_equal(v2, list[2], "list[2] is not the expected.")
	assert_equal(v3, list[3], "list[3] is not the expected.")
	assert_equal(v2, list[4], "list[4] is not the expected.")
end

function listtest.test_should_initialize_with_table_elements_without_repeat_elements()
	-- given:
	local v1 = {}
	local v2 = {}
	local v3 = {}
	local t = { v1, v2, v3, v2 }

	-- when:
	list = vega.list { initialvalues = t, singleoccurrence = true }

	-- then:
	assert_equal(3, #list, "The length of the list is not the expected.")
	assert_equal(v1, list[1], "list[1] is not the expected.")
	assert_equal(v2, list[2], "list[2] is not the expected.")
	assert_equal(v3, list[3], "list[3] is not the expected.")
end

function listtest.test_should_callback_when_insert()
	-- given:
	list = vega.list { callback = callbackmock }
	local v1 = {}

	-- when:
	list.insert(v1)

	-- then:
	assert_equal(1, callbackmock.beforesetindex, "The index passed to beforeset callback is not the expected.")
	assert_equal(v1, callbackmock.beforesetvalue, "The value passed to beforeset callback is not the expected.")
	assert_equal(1, callbackmock.aftersetindex, "The index passed to afterset callback is not the expected.")
	assert_equal(v1, callbackmock.aftersetvalue, "The value passed to afterset callback is not the expected.")
	assert_false(callbackmock.beforeremovecalled, "Should not call beforeremove.")
	assert_false(callbackmock.afterremovecalled, "Should not call afterremove.")
end

function listtest.test_should_callback_when_set()
	-- given:
	list = vega.list { callback = callbackmock }
	local v1 = {}

	-- when:
	list[1] = v1

	-- then:
	assert_equal(1, callbackmock.beforesetindex, "The index passed to beforeset callback is not the expected.")
	assert_equal(v1, callbackmock.beforesetvalue, "The value passed to beforeset callback is not the expected.")
	assert_equal(1, callbackmock.aftersetindex, "The index passed to afterset callback is not the expected.")
	assert_equal(v1, callbackmock.aftersetvalue, "The value passed to afterset callback is not the expected.")
	assert_false(callbackmock.beforeremovecalled, "Should not call beforeremove.")
	assert_false(callbackmock.afterremovecalled, "Should not call afterremove.")
end

function listtest.test_should_callback_when_remove()
	-- given:
	list = vega.list { callback = callbackmock }
	local v1 = {}
	list[1] = v1

	-- when:
	list.remove(1)

	-- then:
	assert_equal(1, callbackmock.beforeremoveindex, "The index passed to beforeremove callback is not the expected.")
	assert_equal(v1, callbackmock.beforeremovevalue, "The value passed to beforeremove callback is not the expected.")
	assert_equal(1, callbackmock.afterremoveindex, "The index passed to afterremove callback is not the expected.")
	assert_equal(v1, callbackmock.afterremovevalue, "The value passed to afterremove callback is not the expected.")
end

function listtest.test_should_callback_when_set_nil()
	-- given:
	list = vega.list { callback = callbackmock }
	local v1 = {}
	list[1] = v1

	-- when:
	list[1] = nil

	-- then:
	assert_equal(1, callbackmock.beforeremoveindex, "The index passed to beforeremove callback is not the expected.")
	assert_equal(v1, callbackmock.beforeremovevalue, "The value passed to beforeremove callback is not the expected.")
	assert_equal(1, callbackmock.afterremoveindex, "The index passed to afterremove callback is not the expected.")
	assert_equal(v1, callbackmock.afterremovevalue, "The value passed to afterremove callback is not the expected.")
end

function listtest.test_should_not_callback_when_element_is_not_setted()
	-- given:
	list = vega.list { callback = callbackmock, singleoccurrence = true }
	local v1 = {}
	list.insert(v1)

	-- when:
	list.insert(v1)

	-- then:
	assert_equal(1, callbackmock.beforesetindex, "The index passed to beforeset callback is not the expected.")
	assert_equal(v1, callbackmock.beforesetvalue, "The value passed to beforeset callback is not the expected.")
	assert_equal(1, callbackmock.aftersetindex, "The index passed to afterset callback is not the expected.")
	assert_equal(v1, callbackmock.aftersetvalue, "The value passed to afterset callback is not the expected.")
	assert_false(callbackmock.beforeremovecalled, "Should not call beforeremove.")
	assert_false(callbackmock.afterremovecalled, "Should not call afterremove.")
end

function listtest.test_should_callback_when_set_elements_from_initial_values()
	-- given:
	local v1 = {}
	list = vega.list { callback = callbackmock, initialvalues = { v1 } }
	
	-- then:
	assert_equal(1, callbackmock.beforesetindex, "The index passed to beforeset callback is not the expected.")
	assert_equal(v1, callbackmock.beforesetvalue, "The value passed to beforeset callback is not the expected.")
	assert_equal(1, callbackmock.aftersetindex, "The index passed to afterset callback is not the expected.")
	assert_equal(v1, callbackmock.aftersetvalue, "The value passed to afterset callback is not the expected.")
	assert_false(callbackmock.beforeremovecalled, "Should not call beforeremove.")
	assert_false(callbackmock.afterremovecalled, "Should not call afterremove.")
end

function listtest.test_should_callback_when_replace()
	-- given:
	local v1 = {}
	local v2 = {}
	list = vega.list { callback = callbackmock }
	list[1] = v1

	-- when:
	list[1] = v2

	-- then:
	assert_equal(1, callbackmock.beforesetindex, "The index passed to beforeset callback is not the expected.")
	assert_equal(v2, callbackmock.beforesetvalue, "The value passed to beforeset callback is not the expected.")
	assert_equal(1, callbackmock.aftersetindex, "The index passed to afterset callback is not the expected.")
	assert_equal(v2, callbackmock.aftersetvalue, "The value passed to afterset callback is not the expected.")
	assert_equal(1, callbackmock.beforeremoveindex, "The index passed to beforeremove callback is not the expected.")
	assert_equal(v1, callbackmock.beforeremovevalue, "The value passed to beforeremove callback is not the expected.")
	assert_equal(1, callbackmock.afterremoveindex, "The index passed to afterremove callback is not the expected.")
	assert_equal(v1, callbackmock.afterremovevalue, "The value passed to afterremove callback is not the expected.")
end

return listtest
