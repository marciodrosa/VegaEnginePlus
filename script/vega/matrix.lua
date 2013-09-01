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
	return {
		{ 1, 0, translation.x or translation[1] },
		{ 0, 1, translation.y or translation[2] },
		{ 0, 0, 1 }
	}
end

--- Creates and returns a 3x3 rotation matrix.
-- @param degrees the angle of the rotation, in degrees.
function vega.matrix.rotation(degrees)
	local radians = math.rad(degrees)
	local cos = math.cos(radians)
	local sin = math.sin(radians)
	return {
		{ cos, sin, 0 },
		{ -sin, cos, 0 },
		{ 0, 0, 1 }
	}
end

--- Creates and returns a 3x3 scale matrix.
-- @param scale a 2D vector table with the scale in x and y (the keys may be 1, 2, x and/or y).
function vega.matrix.scale(scale)
	return {
		{ scale.x or scale[1], 0, 0 },
		{ 0, scale.y or scale[2], 0 },
		{ 0, 0, 1 }
	}
end

--- Multiply the two matrixes and returns the result matrix.
-- @param m1 the first 3x3 matrix table.
-- @param m1 the second 3x3 matrix table.
function vega.matrix.multiply(m1, m2)
	local result = { {}, {}, {} }
	for i = 1, 3 do
		for j = 1, 3 do
			result[i][j] = (m1[i][1] * m2[1][j]) + (m1[i][2] * m2[2][j]) + (m1[i][3] * m2[3][j])
		end
	end
	return result
end
