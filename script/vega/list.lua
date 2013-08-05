require "vegatable"

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
-- To iterate the list elements, use mylist.ipairs. The default pairs and ipairs functions doesn't work with vega.list,
-- because the elements of vega.list are not exposed. 
--
-- @param args optional table with the following optional fields: callback (a table with callback functions beforeremove(index, value),
-- afterremove(index, value), beforeset(index, value), afterset(index, value)), singleoccurrence (if the element already
-- is on list, just moves it to the new index; default is false) and initialvalues (a table from where all elements are added to
-- the new list).
function vega.list(args)

	local list = {}

	local proxylist = {}

	local listmetatable = {}

	local function beforeset(index, value)
		if args and args.callback and args.callback.beforeset then args.callback.beforeset(index, value) end
	end

	local function afterset(index, value)
		if args and args.callback and args.callback.afterset then args.callback.afterset(index, value) end
	end

	local function beforeremove(index, value)
		if args and args.callback and args.callback.beforeremove and value ~= nil then args.callback.beforeremove(index, value) end
	end

	local function afterremove(index, value)
		if args and args.callback and args.callback.afterremove and value ~= nil then args.callback.afterremove(index, value) end
	end

	local function insertvalues(values)
		for k, v in pairs(values) do
			list.insert(v)
		end
	end

	local function contains(value)
		for k, v in pairs(proxylist) do
			if v == value then return true end
		end
		return false
	end

	local function setat(value, index, shift)
		local oldvalue = proxylist[index]
		if value == nil then
			beforeremove(index, oldvalue)
			if shift then 
				table.remove(proxylist, index)
			else
				proxylist[index] = nil
			end
			afterremove(index, oldvalue)
		else
			local canset = true
			if args and args.singleoccurrence == true and contains(value) then
				canset = false
			end
			if canset then
				if shift then
					beforeset(index, value)
					table.insert(proxylist, index, value)
					afterset(index, value)
				else
					beforeremove(index, oldvalue)
					beforeset(index, value)
					proxylist[index] = value
					afterremove(index, oldvalue)
					afterset(index, value)
				end
			end
		end
	end

	function listmetatable.__index(t, key)
		if type(key) == "string" then
			for i, v in ipairs(proxylist) do
				if type(v) == "table" and v.name == key then return v end
			end
		else
			return rawget(proxylist, key)
		end
	end

	function listmetatable.__newindex(t, key, value)
		if type(key) == "number" then
			setat(value, key, false)
		elseif type(key) == "string" then
			if type(value) == "table" then
				value.name = key
				setat(value, #proxylist + 1, false)
			else
				error("When set a value into the list using a name key, the value must be a table.")
			end
		else
			error("When set a value into the list, the key must be a number or string.")
		end
	end

	function listmetatable.__len(op)
		return #proxylist
	end

	--- Removes an element from the list.
	-- @param index if number, removes the element at given index; if string, searches for the element that contains the 'name'
	-- field equal to the id; otherwise, searches for the element equal to the id.
	function list.remove(id)
		if type(id) == "number" then
			setat(nil, id, true)
		elseif type(id) == "string" then
			local i = 1
			while i <= #proxylist do
				local v = proxylist[i]
				if type(v) == "table" and v.name == id then
					setat(nil, i, true)
				else
					i = i + 1
				end
			end
		else
			local i = 1
			while i <= #proxylist do
				local v = proxylist[i]
				if v == id then
					setat(nil, i, true)
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
		index = index or #proxylist + 1
		setat(value, index, true)
	end

	--- Used to iterate through list elements.
	function list.ipairs()
		return ipairs(proxylist)
	end

	setmetatable(list, listmetatable)
	if args and args.initialvalues then insertvalues(args.initialvalues) end
	return list
end