require "Color"
require "Drawable"

--- A drawable that renders a rectangle with a color and optional texture.
-- @field color the color of the rectangle.
RectangleDrawable = {}
local _RectangleDrawable = {}

--- Creates a new instance of a rectangle drawable table.
-- @param o the new table, can be nil.
function RectangleDrawable.new(o)
	o = o or {}
	local defaultdata = Drawable.new {
		color = Color.new()
		--[[texture = {},
		lefttopuv = Vector2.zero,
		rightbottomuv = Vector2.one,
		texturemodeu = "clamp",
		texturemodev = "clamp",]]
	}
	local metatable = {
		__index = defaultdata
	}
	setmetatable(o, metatable)
	return o;
end
