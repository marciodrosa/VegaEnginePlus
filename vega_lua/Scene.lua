require "vegatable"
require "Viewport"
require "Color"

--- Scene contains the elements to be drawn and the controllers that updates
-- the state of the scene. Set a scene into the current context (the "nextscene"
-- field of the Context table) to render and update the scene in the main loop.
-- @field viewport a Viewport table, a new instance is created by default.
-- @field background color the color of the background, a blue color is created by default.
-- @field framespersecond the frames per second used by the main loop to update and render
-- this scene. It is 30 by default.
-- @field controllers list of controller tables. You can add or remove tables from this list.
-- If the table defines a function called "update", then this function is called at each frame
-- of the main loop, with self and the Context table as arguments. Define a field called "finished"
-- with true value to finish the controller and automatically remove it from the scene.
vega.Scene = {}
local _Scene = {}

--- Update all controllers attached to this scene. This function is automatically called by the
-- main loop.
function _Scene:updatecontrollers(context)
	local i = 1
	while i <= #self.controllers do
		local controller = self.controllers[i]
		if not controller.finished and controller.update ~= nil then
			controller:update(context)
		end
		if controller.finished == true then
			table.remove(self.controllers, i)
		else
			i = i + 1
		end
	end
end

--- Create a new Scene table.
function vega.Scene.new()
	return {
		viewport = vega.Viewport.new(),
		backgroundcolor = vega.Color.new(25, 70, 255),
		framespersecond = 30,
		controllers = {},
		updatecontrollers = _Scene.updatecontrollers
	}
end
