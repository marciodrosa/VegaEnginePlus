require "vega.vegatable"

local function setvectorvalues(t, field, absolutevalue, relativevalue)
	rawset(t, field, absolutevalue)
	rawset(t, "relative"..field, relativevalue)
end

local function getrelativetotable(relativeto)
	if type(relativeto) == "function" then return relativeto()
	else return nil
	end
end

local function getvaluetoberelative(relativeto, field)
	local result
	local relativetotable = getrelativetotable(relativeto)
	if relativetotable ~= nil then
		result = relativetotable[field]
	end
	return result or 1
end

local function getabsolute(t, field, relativeto)
	local relativetovalue = getvaluetoberelative(relativeto, field)
	if rawget(t, field) == nil then
		return rawget(t, "relative"..field) * relativetovalue
	else
		return rawget(t, field)
	end
end

local function getrelative(t, field, relativeto)
	local relativetovalue = getvaluetoberelative(relativeto, field)
	if rawget(t, "relative"..field) == nil then
		if relativetovalue == 0 then
			return rawget(t, field)
		else
			return rawget(t, field) / relativetovalue
		end
	else
		return rawget(t, "relative"..field)
	end
end

local function convertrelative(t, field, converttorelative, relativeto)
	if rawget(t, "relative"..field) == nil and converttorelative then
		setvectorvalues(t, field, nil, getrelative(t, field, relativeto))
	elseif rawget(t, field) == nil and not converttorelative then
		setvectorvalues(t, field, getabsolute(t, field, relativeto), nil)
	end
end

local function setinitialvalues(t, initialvalues)
	if initialvalues ~= nil then
		if initialvalues.relativex ~= nil then t.relativex = initialvalues.relativex end
		if initialvalues.relativey ~= nil then t.relativey = initialvalues.relativey end
		if (initialvalues.x or initialvalues[1]) ~= nil then t.x = initialvalues.x or initialvalues[1] end
		if (initialvalues.y or initialvalues[2]) ~= nil then t.y = initialvalues.y or initialvalues[2] end
		if initialvalues.keeprelativex ~= nil then t.keeprelativex = initialvalues.keeprelativex end
		if initialvalues.keeprelativey ~= nil then t.keeprelativey = initialvalues.keeprelativey end
	end
end

local function areequal(v1, v2)
	return rawget(v1, "x") == rawget(v2, "x") and rawget(v1, "y") == rawget(v2, "y") and rawget(v1, "relativex") == rawget(v2, "relativex") and rawget(v1, "relativey") == rawget(v2, "relativey")
end

--- Creates a 2D vector with x and y fields. You can set/get relative values with myvector.relativex
-- and myvector.relativey. For example, when working with the size of a drawable, you can set
-- drawable.size.relativex = 0.5. With this value, the drawable width will be 50% of its parent width.
-- When the parent size changes, the drawable size automatically changes too.
--
-- Instead of use the x and y fields, you can also use 1 and 2 keys. It will be automatically converted
-- to/from x and y.
--
-- To set a relative value and turn off the auto-update feature, you can set the relativex or relativey and then set
-- keeprelativex = false or keeprelativey = false. Using the above example, the drawable width is changed to 50% of its
-- parent width, but then is no more updated when the parent size changes. The opposite can also be done: set the x or
-- y field and then set keeprelativex or keeprelativey to true.
--
-- After set an absolute (not relative) value on x or y, you can get the relative value (relativex or relativey).
-- It will be calculated in real time. The same if you set the relative value and want to get the absolute one.
--
-- Note that the relative values depends of the context: a drawable size, for example, is relative to the drawable's
-- parent size. The drawable origin is relative to the size of itself.
--
-- @param initialvalues optional table with the initial values
-- @param relativefunction optional function that must return a table with x and y fields. This table is used as
-- absolute values when calculate relative values.
function vega.vector(initialvalues, relativefunction)

	local relativefunction = relativefunction or function() end

	local v = {
		x = 0,
		y = 0
	}

	local metatable = {}

	function metatable.__newindex(t, index, value)
		if index == "x" then setvectorvalues(t, "x", value, nil, false)
		elseif index == "y" then setvectorvalues(t, "y", value, nil, false)
		elseif index == "relativex" then setvectorvalues(t, "x", nil, value, true)
		elseif index == "relativey" then setvectorvalues(t, "y", nil, value, true)
		elseif index == "keeprelativex" then convertrelative(t, "x", value, relativefunction)
		elseif index == "keeprelativey" then convertrelative(t, "y", value, relativefunction)
		elseif index == 1 then t.x = value
		elseif index == 2 then t.y = value
		else rawset(t, index, value) end
	end

	function metatable.__index(t, index)
		if index == "x" then return getabsolute(t, "x", relativefunction)
		elseif index == "y" then return getabsolute(t, "y", relativefunction)
		elseif index == "relativex" then return getrelative(t, "x", relativefunction)
		elseif index == "relativey" then return getrelative(t, "y", relativefunction)
		elseif index == "keeprelativex" then return rawget(t, "relativex") ~= nil
		elseif index == "keeprelativey" then return rawget(t, "relativey") ~= nil
		elseif index == 1 then return t.x
		elseif index == 2 then return t.y
		else return rawget(t, index) end
	end

	metatable.__eq = areequal

	setmetatable(v, metatable)
	setinitialvalues(v, initialvalues)
	return v
end
