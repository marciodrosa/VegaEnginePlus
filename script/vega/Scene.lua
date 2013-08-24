require "vegatable"
require "color"
require "layer"
require "list"
require "util"

--- Update all controllers attached to this scene. This function is automatically called by the
-- main loop.
local function updatecontrollers(self, context)
	local i = 1
	while i <= #self.controllers do
		local controller = self.controllers[i]
		if not controller.finished then
			if not controller.initiated then
				controller.initiated = true
				if controller.init ~= nil then
					controller:init(context)
				end
			end
			if controller.update ~= nil then
				controller:update(context)
			end
		end
		if controller.finished == true then
			self.controllers.remove(i)
		else
			i = i + 1
		end
	end
end

--- Creates and returns a new scene table. It contains the elements to be drawn and the
-- controllers that updates the state of the scene. Set a scene into the current context
-- (the "nextscene" field of the Context table) to render and update the scene in the main loop.
-- @field viewport a Viewport table, a new instance is created by default.
-- @field background color the color of the background, a blue color is created by default.
-- @field framespersecond the frames per second used by the main loop to update and render
-- this scene. It is 30 by default.
-- @field controllers list of controller tables. You can add or remove tables from this list.
-- If the table defines a function called "update", then this function is called at each frame
-- of the main loop, with self and the Context table as arguments. Define a field called "finished"
-- with true value to finish the controller and automatically remove it from the scene. Before the
-- first update, the scene calls the function :init(context) of the controller (if exists) and
-- sets a field called "initiated" as true into the controller table.
function vega.scene(initialvalues)

	local scene = {}

	local private = {}

	local scenemetatable = {
	}

	function scenemetatable.__newindex(t, index, value)
		if index == "layers" then
			private.layers = vega.list {
				singleoccurrence = true,
				initialvalues = value
			}
		elseif index == "controllers" then
			private.controllers = vega.list {
				singleoccurrence = true,
				initialvalues = value
			}
		else
			rawset(t, index, value)
		end
	end

	function scenemetatable.__index(t, index)
		if index == "layers" or index == "controllers" then
			return private[index];
		end
	end

	setmetatable(scene, scenemetatable)

	scene.layers = {
		vega.layer()
	}
	scene.backgroundcolor = { r = 25, g = 70, b = 255 }
	scene.framespersecond = 30
	scene.controllers = {}
	scene.updatecontrollers = updatecontrollers

	return vega.util.copyvaluesintotable(initialvalues, scene)
end
