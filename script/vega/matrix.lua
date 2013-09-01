require "vegatable"

--- Table with 3x3 matrix operations functions. The functions that receives matrix or vectors as parameters
-- doesn't check the integrity of the parameters for performance reasons. So, it is assumed the data is
-- correct. The 3x3 matrixes are tables with numeric indices 1, 2 and 3. Each value is another table with
-- numeric indices 1, 2 and 3, which each value is a number.
-- 
-- Each matrix returned from the functions contains a metatable that allows the conversion of the matrix to a
-- string and a :multiply(anothermatrix) function.
vega.matrix = {}

local matrixmetatable = {}

local matrixmetatableindex = {}

--- Creates a 3x3 identity matrix.
function vega.matrix.identity()
	local m = {
		{ 1, 0, 0 },
		{ 0, 1, 0 },
		{ 0, 0, 1 }
	}
	return setmetatable(m, matrixmetatable)
end

--- Creates and returns a 3x3 translation matrix.
-- @param translation a 2D vector table with the translation x and y (the keys may be 1, 2, x and/or y).
function vega.matrix.translation(translation)
	local m = {
		{ 1, 0, translation.x or translation[1] },
		{ 0, 1, translation.y or translation[2] },
		{ 0, 0, 1 }
	}
	return setmetatable(m, matrixmetatable)
end

--- Creates and returns a 3x3 rotation matrix.
-- @param degrees the angle of the rotation, in degrees.
function vega.matrix.rotation(degrees)
	local radians = math.rad(degrees)
	local cos = math.cos(radians)
	local sin = math.sin(radians)
	local m = {
		{ cos, sin, 0 },
		{ -sin, cos, 0 },
		{ 0, 0, 1 }
	}
	return setmetatable(m, matrixmetatable)
end

--- Creates and returns a 3x3 scale matrix.
-- @param scale a 2D vector table with the scale in x and y (the keys may be 1, 2, x and/or y).
function vega.matrix.scale(scale)
	local m = {
		{ scale.x or scale[1], 0, 0 },
		{ 0, scale.y or scale[2], 0 },
		{ 0, 0, 1 }
	}
	return setmetatable(m, matrixmetatable)
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
	return setmetatable(result, matrixmetatable)
end

--- Returns the transpose of the matrix (transposes the rows and columns).
function vega.matrix.transpose(matrix)
	local m = {
		{ matrix[1][1], matrix[2][1], matrix[3][1] },
		{ matrix[1][2], matrix[2][2], matrix[3][2] },
		{ matrix[1][3], matrix[2][3], matrix[3][3] },
	}
	return setmetatable(m, matrixmetatable)
end

function matrixmetatable.__tostring(t)
	return ""..t[1][1].." "..t[1][2].." "..t[1][3].."\n"..t[2][1].." "..t[2][2].." "..t[2][3].."\n"..t[3][1].." "..t[3][2].." "..t[3][3]
end

-- todo: add to the metatable functions to extract the position, rotation and scale values from the matrix

matrixmetatableindex.multiply = vega.matrix.multiply
matrixmetatableindex.transpose = vega.matrix.transpose

matrixmetatable.__index = matrixmetatableindex
