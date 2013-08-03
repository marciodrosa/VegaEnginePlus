require "vegatable"

--- A special drawable table attached to a Layer table to define how the drawables of the
-- layer are seeing. The visible are is equal to the size of the camera. The metatable has
-- a drawable as __index.
-- @field autocalculatewidth if true (default value), the width is automatically calculated
-- to keep the aspect ratio. If both autocalculatewidth and autocalculateheight are true,
-- then the size will be equal to the available area of the layer (screen size).
-- @field autocalculateheight if true, the height is automatically calculated to keep the
-- aspect ratio. It is false by default. If both autocalculatewidth and autocalculateheight
-- are true, then the size will be equal to the available area of the layer (screen size).
vega.Camera = {}

--- Creates a new instance of the table.
function vega.Camera.new()
	local mt = {
		__index = vega.Drawable.new()
	}
	local obj = {
		autocalculatewidth = true,
		autocalculateheight = false,
	}
	return setmetatable(obj, mt)
end
