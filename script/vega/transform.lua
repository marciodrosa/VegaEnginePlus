require "vegatable"
require "matrix"

vega.transform = {}

--- Creates and returns the matrix with all transforms of the given drawable, relative to
-- the drawable parent.
function vega.transform.getmatrix(drawable)
	local originmatrix = vega.matrix.translation { x = -drawable.origin.x, y = -drawable.origin.y }
	local scalematrix = vega.matrix.scale(drawable.scale)
	local rotationmatrix = vega.matrix.rotation(drawable.rotation)
	local translationmatrix = vega.matrix.translation(drawable.position)
	return translationmatrix:multiply(rotationmatrix):multiply(scalematrix):multiply(originmatrix)
end

--- Creates and returns the matrix with all transforms of the given drawable, relative to
-- the world. So, all transforms of all parents are included in the matrix. If layer is not nil,
-- then the camera transforms are included too.
function vega.transform.getglobalmatrix(drawable, layer)
	local matrix = vega.transform.getmatrix(drawable)
	if drawable.parent ~= nil then
		local childrenoriginmatrix = vega.matrix.translation(drawable.parent.childrenorigin)
		local parentmatrix = vega.transform.getglobalmatrix(drawable.parent)
		matrix = matrix:multiply(childrenoriginmatrix):multiply(parentmatrix)
	end
	if layer ~= nil then
		local cameramatrix = vega.transform.getglobalmatrix(layer.camera)
		matrix = matrix:multiply(cameramatrix:inverse())
	end
	return matrix
end

--- Returns the point v transformed with the transformation matrix m.
-- @param v the point to be transformed, the fields can be x or 1 and y or 2.
-- @param m the transformation matrix.
function vega.transform.transformpoint(v, m)
	local vx = v.x or v[1]
	local vy = v.y or v[2]
	return {
		x = (m[1][1] * vx) + (m[1][2] * vy) + m[1][3],
		y = (m[2][1] * vx) + (m[2][2] * vy) + m[2][3]
	}
end