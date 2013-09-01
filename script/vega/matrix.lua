require "vegatable"

--- Table with 3x3 matrix operations functions. The functions that receives matrix or vectors as parameters
-- doesn't check the integrity of the parameters for performance reasons. So, it is assumed the data is
-- correct. The 3x3 matrixes are tables with numeric indices 1, 2 and 3. Each value is another table with
-- numeric indices 1, 2 and 3, which each value is a number.
vega.matrix = {}

--- Creates a 3x3 identity matrix.
function vega.matrix.identity()
	return {
		{ 1, 0, 0 },
		{ 0, 1, 0 },
		{ 0, 0, 1 }
	}
end

--- Creates and returns a 3x3 translation matrix.
-- @param translation a 2D vector table with the translation x and y (the keys may be 1, 2, x and/or y).
function vega.matrix.translation(translation)
end

--- Creates and returns a 3x3 rotation matrix.
-- @param degrees the angle of the rotation, in degrees.
function vega.matrix.rotation(degrees)
end

--- Creates and returns a 3x3 scale matrix.
-- @param scale a 2D vector table with the scale in x and y (the keys may be 1, 2, x and/or y).
function vega.matrix.scale(scale)
end

--- Multiply the two matrixes and returns the result matrix.
-- @param m1 the first 3x3 matrix table.
-- @param m1 the second 3x3 matrix table.
function vega.matrix.multiply(m1, m2)
end
