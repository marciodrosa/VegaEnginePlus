require "vegatable"
require "Drawable"
require "Camera"

--- A layer contains a root drawable and a camera. Many layers can be rendered at same time, sequentially,
-- when attached to a scene (see the 'layers' field of the Scene table).
-- @field rootdrawable a root Drawable object. A new instance is created by default.
-- @camera the camera to view the root drawable and the children. A new instance is created by default.
-- @stretchroot if true (default value), the root drawable is always keept with the same size of the view
-- (the camera size).
vega.Layer = {}

--- Creates a new instance of the table.
function vega.Layer.new()
	return {
		rootdrawable = vega.Drawable.new(),
		camera = vega.Camera.new(),
		stretchroot = true,
	}
end
