require "vega.vegatable"
require "vega.mouse"

--- Creates a input table. Used internally ny the SDK.
-- @param display the current display.
-- @field mouse the mouse state.
function vega.input(display)
	return {
		mouse = vega.mouse(display)
	}
end
