require "vegatable"
require "vega.coordinates"

--- Creates a mouse state object. It is not normally called by the user, because an object
-- is automatically created by SDK.
function vega.mouse(screen)
	local function createbuttonstate()
		return {
			pressed = false,
			wasclicked = false,
			wasdoubleclicked = false,
			wasreleased = false,
		}
	end

	local function relativeto()
		return screen.size
	end

	local mouse = {
		position = vega.coordinates({}, relativeto),
		motion = vega.coordinates({}, relativeto),
		buttons = {
			left = createbuttonstate(),
			right = createbuttonstate(),
			middle = createbuttonstate()
		}
	}
	mouse.motion.z = 0
	return mouse
end