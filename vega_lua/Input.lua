require "vegatable"

--- Contains informations about the input state, like the touch points.
-- @field touchpoints array of TouchPoint objects with informations about the current touch points.
-- @field newtouchpoints array of TouchPoint objects with informations about the current touch points
-- (but only with new touch points: points touched on current frame).
-- @field releasedtouchpoints array of TouchPoint objects with informations about the points that were
-- released on current frame.
vega.Input = {}

function vega.Input.new()
	return {
		touchpoints = {},
		newtouchpoints = {},
		releasedtouchpoints = {}
	}
end
