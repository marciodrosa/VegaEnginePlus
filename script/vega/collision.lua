require "vega.vegatable"
require "vega.matrix"
require "vega.spaceconverter"
require "vega.transform"

--- Contains functions to calculate collisions between points, rectangles and drawables.
vega.collision = {}

--- Returns true if the rectangle collides with the point.
-- @arg rect the rectangle table, should have the position and size fields, each one with x and y fields.
-- @arg point the position of the point (table with x and y fields).
function vega.collision.rectcollideswithpoint(rect, point)
	local rpos2 = {
		x = rect.position.x + rect.size.x,
		y = rect.position.y + rect.size.y,
	}
	return point.x >= rect.position.x and point.y >= rect.position.y and point.x <= rpos2.x and point.y <= rpos2.y
end

--- Returns true if both rectangles collides with each other.
-- @arg rect1 the rectangle 1 table, should have the position and size fields, each one with x and y fields.
-- @arg rect2 the rectangle 2 table, should have the position and size fields, each one with x and y fields.
-- @arg rsize2 the size of the rectangle 2 (table with x and y fields).
function vega.collision.rectcollideswithrect(rect1, rect2)
	local rpos1_2 = {
		x = rect1.position.x + rect1.size.x,
		y = rect1.position.y + rect1.size.y,
	}
	local rpos2_2 = {
		x = rect2.position.x + rect2.size.x,
		y = rect2.position.y + rect2.size.y,
	}
	return not (rect2.position.x > rpos1_2.x or rpos2_2.x < rect1.position.x or rect2.position.y > rpos1_2.y or rpos2_2.y < rect1.position.y)
end

--- Returns true if the drawable collides with point.
-- @arg d the drawable to test.
-- @arg point the point (table with x and y fields).
-- @arg layer1 the layer of the drawable, If nil, it is ignored.
-- @arg layer2 the layer of the point. If nil, layer1 is used. If layer1 is nil, layer2 is also ignored.
function vega.collision.drawablecollideswithpoint(d, point, layer1, layer2)
	local inversematrix = vega.transform.getglobalmatrix(d):inverse()
	local drawablerectangle = {
		position = { x = 0, y = 0},
		size = d.size
	}
	if layer1 ~= nil and layer2 ~= nil then
		point = vega.spaceconverter.fromlayertoanotherlayer(point, layer2, layer1)
	end
	point = vega.transform.transformpoint(point, inversematrix)
	return vega.collision.rectcollideswithpoint(drawablerectangle, point)
end

--- Returns true if the drawable collides with display point.
-- @arg d the drawable to test.
-- @arg point the point (table with x and y fields).
-- @arg layer the layer of the drawable, If nil, it is ignored.
-- @arg display the display. If nil or layer is nil, it is ignored.
function vega.collision.drawablecollideswithdisplaypoint(d, point, layer, display)
	if layer ~= nil and display ~= nil then
		point = vega.spaceconverter.fromdisplaytolayer(point, display, layer)
	end
	return vega.collision.drawablecollideswithpoint(d, point)
end

--[[
function vega.collision.drawablecollideswithrect(d, rect, layer1, layer2)
end

function vega.collision.drawablecollideswithdrawable(d1, d2, layer1, layer2)
end
]]
