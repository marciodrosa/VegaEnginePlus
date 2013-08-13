require "vegatable"

local function setcoordinatevalues(t, coordinate, absolutevalue, relativevalue)
	rawset(t, coordinate, absolutevalue)
	rawset(t, "relative"..coordinate, relativevalue)
end

local function getvaluetoberelative(relativeto, coordinate)
	local result = 1
	local relativetotable = relativeto()
	if relativetotable ~= nil then
		result = relativetotable[coordinate]
	end
	return result
end

local function getabsolute(t, coordinate, relativeto)
	local relativetovalue = getvaluetoberelative(relativeto, coordinate)
	if rawget(t, coordinate) == nil then
		return rawget(t, "relative"..coordinate) * relativetovalue
	else
		return rawget(t, coordinate)
	end
end

local function getrelative(t, coordinate, relativeto)
	local relativetovalue = getvaluetoberelative(relativeto, coordinate)
	if rawget(t, "relative"..coordinate) == nil then
		if relativetovalue == 0 then
			return rawget(t, coordinate)
		else
			return rawget(t, coordinate) / relativetovalue
		end
	else
		return rawget(t, "relative"..coordinate)
	end
end

local function convertrelative(t, coordinate, converttorelative, relativeto)
	if rawget(t, "relative"..coordinate) == nil and converttorelative then
		setcoordinatevalues(t, coordinate, nil, getrelative(t, coordinate, relativeto))
	elseif rawget(t, coordinate) == nil and not converttorelative then
		setcoordinatevalues(t, coordinate, getabsolute(t, coordinate, relativeto), nil)
	end
end

local function setinitialvalues(t, initialvalues)
	if initialvalues ~= nil then
		if initialvalues.x ~= nil then t.x = initialvalues.x end
		if initialvalues.y ~= nil then t.y = initialvalues.y end
		if initialvalues.relativex ~= nil then t.relativex = initialvalues.relativex end
		if initialvalues.relativey ~= nil then t.relativey = initialvalues.relativey end
		if initialvalues.keeprelativex ~= nil then t.keeprelativex = initialvalues.keeprelativex end
		if initialvalues.keeprelativey ~= nil then t.keeprelativey = initialvalues.keeprelativey end
	end
end

local function areequal(coordinate1, coordinate2)
	return rawget(coordinate1, "x") == rawget(coordinate2, "x") and rawget(coordinate1, "y") == rawget(coordinate2, "y") and rawget(coordinate1, "relativex") == rawget(coordinate2, "relativex") and rawget(coordinate1, "relativey") == rawget(coordinate2, "relativey")
end

--- Creates a 2D coordinates system (X, Y). It is more used internally by the SDK with the drawables tables.
-- To get or set the coordinates, use mytable.x and mytable.y. You an also set/get relative values with mytable.relativex
-- and mytable.relativey. For example, when working with the size of a drawable, you can set drawable.size.relativex = 0.5.
-- With this value, the drawable width will be 50% of his parent width. When the parent size changes, the drawable size
-- automatically changes too.
--
-- To set a relative value and turn off the auto-update feature, you can set the relativex or relativey and then set
-- keeprelativex = false or keeprelativey = false. Using the above example, the drawable width is changed to 50% of his
-- parent width, but then is no more updated when the parent size changes. The opposite can also be done: set the x or
-- y coordinate and then set keeprelativex or keeprelativey to true.
--
-- After set an absolute coordinate (x or y), you can get the relative coordinate (relativex or relativey). It will be
-- calculated on the fly. The same if you set the relative coordinate and want to get the absolute one.
--
-- Note that the relative coordinates depends of the context: a drawable size, for example, is relative to the drawable's
-- parent size. The drawable origin is relative to the size of himself.
--
-- @param initialvalues optional table with the initial values
-- @param relativeto optional function that can return a table (with x and y fields). This table is used as absolute values
-- when set relative values in the coordinates.
function vega.coordinates(initialvalues, relativeto)

	relativeto = relativeto or function() end

	local coordinates = {
		x = 0,
		y = 0
	}

	local coordinatesmetatable = {}

	function coordinatesmetatable.__newindex(t, index, value)
		if index == "x" then setcoordinatevalues(t, "x", value, nil, false)
		elseif index == "y" then setcoordinatevalues(t, "y", value, nil, false)
		elseif index == "relativex" then setcoordinatevalues(t, "x", nil, value, true)
		elseif index == "relativey" then setcoordinatevalues(t, "y", nil, value, true)
		elseif index == "keeprelativex" then convertrelative(t, "x", value, relativeto)
		elseif index == "keeprelativey" then convertrelative(t, "y", value, relativeto)
		else rawset(t, index, value) end
	end

	function coordinatesmetatable.__index(t, index)
		if index == "x" then return getabsolute(t, "x", relativeto)
		elseif index == "y" then return getabsolute(t, "y", relativeto)
		elseif index == "relativex" then return getrelative(t, "x", relativeto)
		elseif index == "relativey" then return getrelative(t, "y", relativeto)
		elseif index == "keeprelativex" then return rawget(t, "relativex") ~= nil
		elseif index == "keeprelativey" then return rawget(t, "relativey") ~= nil
		else return rawget(t, index) end
	end

	coordinatesmetatable.__eq = areequal

	setmetatable(coordinates, coordinatesmetatable)
	setinitialvalues(coordinates, initialvalues)
	return coordinates
end
