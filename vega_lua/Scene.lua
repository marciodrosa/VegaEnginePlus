require "Viewport"
require "Color"

--- Scene contains the elements to be drawn and the controllers that updates
-- the state of the scene. Set a scene into the current context (the "nextscene"
-- field of the Context table) to render and update the scene in the main loop.
-- @field viewport a Viewport table, a new instance is created by default.
-- @field background color the color of the background, a blue color is created by default.
-- @field framespersecond the frames per second used by the main loop to update and render
-- this scene. It is 30 by default.
Scene = {}

--- Create a new Scene table.
function Scene.new()
	return {
		viewport = Viewport.new(),
		backgroundcolor = Color.new(25, 70, 255),
		framespersecond = 30,
	}
end
