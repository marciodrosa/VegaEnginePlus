require "vegatable"
require "Vector2"

--- Table with touch point data.
-- @field id the identifier of this touch point.
-- @field position Vector2 with the position of the touch point, relative to the screen size, where (0, 0) is the bottom left corner.
-- @field relativeposition same as position, but the values are between 0 and 1.
-- @field motion Vector2 with the motion between the current position and the position in the last frame.
-- @field relativemotion same as motion, but using the relativeposition instead the position.
vega.TouchPoint = {}

--- Creates a new table. It is internally called by the c api, you don't need to call this function.
function vega.TouchPoint.new(id, x, y, previousx, previousy, screenwidth, screenheight)
	return {
		id = id,
		position = vega.Vector2.new(x, y),
		motion = vega.Vector2.new(x - previousx, y - previousy),
		relativeposition = vega.Vector2.new(x / screenwidth, y / screenheight),
		relativemotion = vega.Vector2.new((x / screenwidth) - (previousx / screenwidth), (y / screenheight) - (previousy / screenheight)),
	}
end
