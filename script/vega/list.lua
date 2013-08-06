require "vegatable"

local function listcontainsvalue(list, value)
	for k, v in pairs(list.content) do
		if v == value then return true end
	end
	return false
end

local function setat(value, index, list, callback, shift, singleoccurrence)
	local oldvalue = list.content[index]
	if value == nil then
		callback.beforeremove(index, oldvalue)
		if shift then 
			table.remove(list.content, index)
		else
			list.content[index] = nil
		end
		callback.afterremove(index, oldvalue)
	else
		local canset = true
		if singleoccurrence == true and listcontainsvalue(list, value) then
			canset = false
		end
		if canset then
			if shift then
				callback.beforeset(index, value)
				table.insert(list.content, index, value)
				callback.afterset(index, value)
			else
				callback.beforeremove(index, oldvalue)
				callback.beforeset(index, value)
				list.content[index] = value
				callback.afterremove(index, oldvalue)
				callback.afterset(index, value)
			end
		end
	end
end

local function insertvaluesatlist(values, list)
	for k, v in pairs(values) do
		list.insert(v)
	end
end

--- Creates a list. This kind of list is used by most of the collections of Vega SDK. The values can be accessed
-- by the index or by a text (if a value with a 'name' field equal to that text is found, than it is returned).
--
-- The elements can be accessed using [index] or [name]. If using the [name] option, the list searches for an element
-- with a 'name' field with the given string value.
-- 
-- The elements can be setted using [index] or [name] also. If using the [name] option, the value is added to the end
-- of the list and the field 'name' is setted into the value (if not a table, an error is thrown). If using the [index]
-- option, a number must be given, otherwise an error is thrown.
--
-- A table with the contents can be accessed with the 'content' field. But it's not recomended to change the content directly.
-- Use only for read access. To change the content, do it with the list table returned by this function.
-- 
-- To iterate the list elements, use mylist.ipairs. The default pairs and ipairs functions doesn't work with vega.list,
-- because the elements of vega.list are not exposed. 
--
-- @param args optional table with the following optional fields: callback (a table with callback functions beforeremove(index, value),
-- afterremove(index, value), beforeset(index, value), afterset(index, value)), singleoccurrence (if the element already
-- is on list, just moves it to the new index; default is false) and initialvalues (a table from where all elements are added to
-- the new list).
function vega.list(args)

	local singleoccurrence = args and args.singleoccurrence == true

	local list = {
		content = {}
	}

	local listmetatable = {}

	local callback = {}

	function callback.beforeset(index, value)
		if args and args.callback and args.callback.beforeset then args.callback.beforeset(index, value) end
	end

	function callback.afterset(index, value)
		if args and args.callback and args.callback.afterset then args.callback.afterset(index, value) end
	end

	function callback.beforeremove(index, value)
		if args and args.callback and args.callback.beforeremove and value ~= nil then args.callback.beforeremove(index, value) end
	end

	function callback.afterremove(index, value)
		if args and args.callback and args.callback.afterremove and value ~= nil then args.callback.afterremove(index, value) end
	end

	function listmetatable.__index(t, key)
		if type(key) == "string" then
			for i, v in ipairs(list.content) do
				if type(v) == "table" and v.name == key then return v end
			end
		else
			return rawget(list.content, key)
		end
	end

	function listmetatable.__newindex(t, key, value)
		if type(key) == "number" then
			setat(value, key, list, callback, false, singleoccurrence)
		elseif type(key) == "string" then
			if type(value) == "table" then
				value.name = key
				setat(value, #list.content + 1, list, callback, false, singleoccurrence)
			else
				error("When set a value into the list using a name key, the value must be a table.")
			end
		else
			error("When set a value into the list, the key must be a number or string.")
		end
	end

	function listmetatable.__len(op)
		return #list.content
	end

	--- Removes an element from the list.
	-- @param index if number, removes the element at given index; if string, searches for the element that contains the 'name'
	-- field equal to the id; otherwise, searches for the element equal to the id.
	function list.remove(id)
		if type(id) == "number" then
			setat(nil, id, list, callback, true)
		elseif type(id) == "string" then
			local i = 1
			while i <= #list.content do
				local v = list.content[i]
				if type(v) == "table" and v.name == id then
					setat(nil, i, list, callback, true)
				else
					i = i + 1
				end
			end
		else
			local i = 1
			while i <= #list.content do
				local v = list.content[i]
				if v == id then
					setat(nil, i, list, callback, true)
				else
					i = i + 1
				end
			end
		end
	end

	--- Inserts the value at the given index.
	-- @param value the object to add.
	-- @param index optional parameter. If nil, inserts the object in the end of the list.
	function list.insert(value, index)
		index = index or #list.content + 1
		setat(value, index, list, callback, true, singleoccurrence)
	end

	--- Used to iterate through list elements.
	function list.ipairs()
		return ipairs(list.content)
	end

	setmetatable(list, listmetatable)
	if args and args.initialvalues then insertvaluesatlist(args.initialvalues, list) end
	return list
end