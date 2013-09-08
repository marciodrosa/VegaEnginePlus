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
	local rpos1_2 = {
		x = rpos1.x + rsize1.x,
		y = rpos1.y + rsize1.y,
	}
	local rpos2_2 = {
		x = rpos2.x + rsize2.x,
		y = rpos2.y + rsize2.y,
	}
	return not (rpos2.x > rpos1_2.x or rpos2_2.x < rpos1.x or rpos2.y > rpos1_2.y or rpos2_2.y < rpos1.y)
end

function vega.collision.drawablecollideswithpoint(d, point, layer1, layer2)
end

function vega.collision.drawablecollideswithrect(d, rpos, rsize, layer1, layer2)
end

function vega.collision.drawablecollideswithdrawable(d1, d2, layer1, layer2)
end
