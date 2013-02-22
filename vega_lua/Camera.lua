require "Drawable"
--[[
--- Camera extends the Drawable table. It is attached to a Layer of the Scene to configure how the objects of the Scene are viewed.
Camera = {}
local _Camera = {}

--- Creates a new instance of a camera table.
function Camera.new()
	local drawable = Drawable.new()
	drawable.viewheigth = 1
	return drawable
end
]]
