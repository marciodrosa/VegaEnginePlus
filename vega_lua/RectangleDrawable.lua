require "Color"
require "Drawable"

--- A drawable that renders a rectangle with a color and optional texture.
-- @field color the color of the rectangle.
RectangleDrawable = {}
local _RectangleDrawable = {}

--- Creates a new instance of a rectangle drawable table.
function RectangleDrawable.new()
	local drawable = Drawable.new()
	drawable.color = Color.new()
	return drawable
end
