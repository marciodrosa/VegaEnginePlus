require "vegatable"
require "Drawable"

--- A scene viewport. This is a simple table that contains a root Drawable. The root
-- Drawable is positioned at (0, 0) and has the same size of the viewport.
-- Future versions of Vega Engine will possible have multiple viewports in one Scene,
-- with customizable positions and sizes, and the possibility to share the same root
-- Drawable.
-- @field sceneviewheight the height of the view of the scene. This is the visible area
-- of the scene. The default value (1) means that all drawables of the scene positioned
-- between the Y coordinates 0 and 1 are visible. The width of this area is automatically
-- calculate (given the proportion of the device screen).
-- @field rootdrawable the root drawable. All children are rendered when the scene is drawn.
-- A new Drawable table is created when the viewport is created.
vega.Viewport = {}

local _Viewport = {}

--- Internal function called to update the viewport with the screen size.
function _Viewport:updatescreensize(screenwidth, screenheight)
	self.rootdrawable.position = { x = 0, y = 0 }
	self.rootdrawable.size = { x = self.sceneviewheight * screenwidth / screenheight, y = self.sceneviewheight }
end

--- Creates a new Viewport.
function vega.Viewport.new()
	return {
		sceneviewheight = 1,
		rootdrawable = vega.drawable(),
		updatescreensize = _Viewport.updatescreensize
	}
end
