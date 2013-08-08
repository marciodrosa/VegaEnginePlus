require "vegatable"

local function setcoordinatevalues(t, coordinate, absolutevalue, relativevalue)
	t.values[coordinate] = absolutevalue
	t.values["relative"..coordinate] = relativevalue
end

local function getvaluetoberelative(relativeto, coordinate)
	local result = 1
	if relativeto ~= nil then
		result = relativeto.table[relativeto.field][coordinate]
	end
	return result
end

local function getabsolute(t, coordinate, relativeto)
	local relativetovalue = getvaluetoberelative(relativeto, coordinate)
	if t.values[coordinate] == nil then
		return t.values["relative"..coordinate] * relativetovalue
	else
		return t.values[coordinate]
	end
end

local function getrelative(t, coordinate, relativeto)
	local relativetovalue = getvaluetoberelative(relativeto, coordinate)
	if t.values["relative"..coordinate] == nil then
		if relativetovalue == 0 then
			return t.values[coordinate]
		else
			return t.values[coordinate] / relativetovalue
		end
	else
		return t.values["relative"..coordinate]
	end
end

local function convertrelative(t, coordinate, converttorelative, relativeto)
	if t.values["relative"..coordinate] == nil and converttorelative then
		setcoordinatevalues(t, coordinate, nil, getrelative(t, coordinate, relativeto))
	elseif t.values[coordinate] == nil and not converttorelative then
		setcoordinatevalues(t, coordinate, getabsolute(t, coordinate, relativeto), nil)
	end
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
-- The returned table has dynamic indexes (they are automatically calculated). To get the values, call mytable.values. It
-- has the x, y, relativex and relativey values, but some can be nil.
--
-- @param args optional table with the following args: relativeto (a table that contains the coordinates used to calculate
-- the relative coordinates, with two fields: "table", the owner of these coordinates, and "field", a string with the field
-- name that contains the coordinates).
function vega.coordinates(args)

	args = args or {}

	local coordinates = {
		values = {
			x = 0,
			y = 0
		},
	}

	local coordinatesmetatable = {}

	function coordinatesmetatable.__newindex(t, index, value)
		if index == "x" then setcoordinatevalues(t, "x", value, nil, false)
		elseif index == "y" then setcoordinatevalues(t, "y", value, nil, false)
		elseif index == "relativex" then setcoordinatevalues(t, "x", nil, value, true)
		elseif index == "relativey" then setcoordinatevalues(t, "y", nil, value, true)
		elseif index == "keeprelativex" then convertrelative(t, "x", value, args.relativeto)
		elseif index == "keeprelativey" then convertrelative(t, "y", value, args.relativeto)
		else rawset(t, index, value) end
	end

	function coordinatesmetatable.__index(t, index)
		if index == "x" then return getabsolute(t, "x", args.relativeto)
		elseif index == "y" then return getabsolute(t, "y", args.relativeto)
		elseif index == "relativex" then return getrelative(t, "x", args.relativeto)
		elseif index == "relativey" then return getrelative(t, "y", args.relativeto)
		elseif index == "keeprelativex" then return coordinates.values.relativex ~= nil and coordinates.values.x == nil
		elseif index == "keeprelativey" then return coordinates.values.relativey ~= nil and coordinates.values.y == nil
		else return rawget(t, index) end
	end

	setmetatable(coordinates, coordinatesmetatable)
	return coordinates
end
