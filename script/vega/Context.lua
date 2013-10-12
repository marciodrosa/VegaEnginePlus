require "vega.vegatable"
require "vega.content"
require "vega.input"
require "vega.util"

--- Context is the current state of the engine. Contains the variables that
-- can be changed to modify the current context. Note: some fields, like scene and module, can't
-- be changed while the frame of the main loop is being updated, to avoid break the data in unexpected
-- ways. So, set the nextmodule or nextscene fields instead. This function is called internally to
-- create a new context for the main loop.
-- @field executing true if the main loop is executing. Set to false to finish the execution.
-- @field isframeupdating a boolean value that indicates if the frame is in the middle of a update. It
-- is setted automatically by the main loop. Some operations, like change the scene or module, can't be
-- made if isframeupdating is true.
-- @field scene the current scene. The current scene is being drawn on the screen and updated
-- each frame. See vega.scene.
-- @field module the last executed module.
-- @field content a content object. This field is renewed with a new object and releases
-- the current resources each time a new module is executed. See vega.content.
-- @field input the input table, contains information about the input state. See vega.input.
-- @field nextmodule as you can't change the module field in the middle of a frame update, set the
-- nextmodule field. So, the module field will be automatically be setted to the next frame.
-- @field nextscene as you can't change the scene field in the middle of a frame update, set the
-- nextscene field. So, the scene field will be automatically be setted to the next frame.
function vega.context()
	local display = {
		size = { x = 0, y = 0 }
	}
	local private = {
	}
	local context = {
		executing = true,
		isframeupdating = false,
		content = vega.content(),
		input = vega.input(display),
		output = {
			display = display
		}
	}
	local contextmetatable = {
		__index = private,
		__newindex = function(t, index, value)
			if index == "scene" or index == "module" then
				if t.isframeupdating then
					error("Set the "..index.." field of the context while the frame is being updated is forbidden. Set next"..index.." field instead, so the changes will apply in the next frame.")
				else
					private[index] = value
				end
			else
				rawset(t, index, value)
			end
		end,
		__pairs = function(t)
			return vega.util.pairswithprivatetable(t, private)
		end
	}
	setmetatable(context, contextmetatable)
	return context
end
