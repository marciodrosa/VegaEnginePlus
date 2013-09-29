require "vegatable"
require "vega.coordinates"

--- Creates a mouse state object. It is not normally called by the user, because an object
-- is automatically created by SDK.
-- @field position x and y coordinates, where (0, 0) are the coordinates of the left bottom corner
-- of the screen. These coordinates are created with vega.vector function, so the relative values
-- can be used (relative to screen size, where (1, 1) is the position of the right top corner of the screen).
-- @field motion x and y coordinates of the mouse motion in the last frame. Like the position field, it
-- is created with the vega.vector function. It also contains a z field, that indicates the mouse wheel
-- movement. Wheel up generates positive values, wheel down generates negative values.
-- @field buttons contains three fields with the state of each mouse button: left, right and middle. Each field
-- contains the boolean fields pressed, wasclicked (if it was clicked in the last frame) and wasreleased (if it
-- was released in the last frame).
function vega.mouse(display)
	local function createbuttonstate()
		return {
			pressed = false,
			wasclicked = false,
			wasreleased = false,
		}
	end

	local function getdisplaysize()
		return display.size
	end

	local mouse = {
		position = vega.vector({}, getdisplaysize),
		motion = vega.vector({}, getdisplaysize),
		buttons = {
			left = createbuttonstate(),
			right = createbuttonstate(),
			middle = createbuttonstate()
		}
	}
	mouse.motion.z = 0
	return mouse
end