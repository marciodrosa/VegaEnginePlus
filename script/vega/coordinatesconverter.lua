require "vegatable"
require "transform"
require "matrix"
require "coordinates"

--- Table with functions to convert coordinates from one space to another.
vega.coordinatesconverter = {}

--- Returns where the layer coordinates are located on display. If the coordinates are out
-- of the display, it returns negative values or values greater than the display size.
-- @param coordinates table with x and y fields.
-- @param layer the layer where the coordinates are.
-- @param display the display.
-- @returns a table created with the function vega.coordinates, where the x and y fields
-- are the pixels of the screen, and relativex and relativey are relative to the screen
-- size.
function vega.coordinatesconverter.fromlayertodisplay(coordinates, layer, display)
	local viewmatrix = vega.transform.getviewmatrix(layer)
	local newcoordinates = vega.transform.transformpoint(coordinates, viewmatrix)
	newcoordinates.x = (display.size.x * newcoordinates.x) / layer.camera.size.x
	newcoordinates.y = (display.size.y * newcoordinates.y) / layer.camera.size.y
	return vega.coordinates(newcoordinates, function() return display.size end)
end

--- Returns where the display coordinates are located in the given layer.
function vega.coordinatesconverter.fromdisplaytolayer(coordinates, layer, display)
end

--- Returns where the coordinates of the first layer are located in the second layer.
function vega.coordinatesconverter.fromlayertoanotherlayer(coordinates, layer1, layer2)
end
