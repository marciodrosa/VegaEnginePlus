require "vegatable"
require "contentmanager"
require "input"

--- Context is the current state of the engine. Contains the variables that
-- can be changed to modify the current context.
-- @field executing true if the main loop is executing. Set to false to finish the execution.
-- @field scene the current scene. The current scene is being drawn on the screen and updated
-- each frame. WARNING: to change the scene, set the "nextscene" field. If you change the "scene" field
-- while the scene is actually being updated (while the main loop is running), you can have issues.
-- Set the "nextscene" will change the "scene" field only after the current frame finishes the update and
-- draw functions.
-- @field nextscene the scene to be setted as current scene for the next frame. See the "scene" field.
-- @field component the last executed component. The StartComponent object is setted into this
-- field when the context is initialized. Change the value of this field to execute another component.
-- @field contentmanager a ContentManager object. This field is renewed with a new object and releases
-- the current resources each time a new component is executed.
-- @input the Input table, contains information about the input state.

function vega.context()
	local display = {
		size = { x = 0, y = 0 }
	}
	return {
		executing = true,
		component = StartComponent,
		contentmanager = vega.ContentManager.new(),
		input = vega.input(display),
		output = {
			display = display
		}
	}
end
