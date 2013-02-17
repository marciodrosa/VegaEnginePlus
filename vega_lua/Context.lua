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
Context = {}

function Context.new()
	return {
		executing = true,
		component = StartComponent,
	}
end
