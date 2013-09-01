require "vegatable"
require "matrix"

vega.transform = {}

function vega.transform.getmatrix(drawable)
	local originmatrix = vega.matrix.translation { x = -drawable.origin.x, y = -drawable.origin.y }
	local scalematrix = vega.matrix.scale(drawable.scale)
	local rotationmatrix = vega.matrix.rotation(drawable.rotation)
	local translationmatrix = vega.matrix.translation(drawable.position)
	local mult = vega.matrix.multiply
	return mult(mult(mult(originmatrix, scalematrix), rotationmatrix), translationmatrix)
end

function vega.transform.getglobalmatrix(drawable, layer)
	--[[local matrix = vega.transform.getmatrix(drawable)
	if drawable.parent ~= nil then
		local parentmatrix = vega.transform.getglobalmatrix(drawable.parent)
		matrix = matrix:multiply(parentmatrix)
	end
	if layer ~= nil then
		local cameramatrix = vega.transform.getglobalmatrix(layer.camera)
		matrix = matrix:multiply(cameramatrix.transpose)
	end
	return matrix]]
end
