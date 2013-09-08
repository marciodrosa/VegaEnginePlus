require "vegatable"

--- Contains functions to calculate collisions between points, rectangles and drawables.
vega.collision = {}

--- Returns true if the rectangle collides with the point.
-- @arg rpos the position of the rectangle (table with x and y fields).
-- @arg rsize the size of the rectangle (table with x and y fields).
-- @arg point the position of the point (table with x and y fields).
function vega.collision.rectcollideswithpoint(rpos, rsize, point)
	local rpos2 = {
		x = rpos.x + rsize.x,
		y = rpos.y + rsize.y,
	}
	return point.x >= rpos.x and point.y >= rpos.y and point.x <= rpos2.x and point.y <= rpos2.y
end

function vega.collision.rectcollideswithrect(rpos1, rsize1, rpos2, rsize2)
	
end

function vega.collision.drawablecollideswithpoint(d, point, layer1, layer2)
end

function vega.collision.drawablecollideswithrect(d, rpos, rsize, layer1, layer2)
end

function vega.collision.drawablecollideswithdrawable(d1, d2, layer1, layer2)
end
