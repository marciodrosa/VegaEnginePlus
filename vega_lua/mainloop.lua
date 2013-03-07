require "vegatable"
require "Context"
require "ContentManager"
require "capi"

--- Implements the main loop of the game or application. Create a new instance with the "new" function,
-- set a Component into the "context" field and execute the loop with the "exec" function, or call the
-- shortcut function vega.MainLoop.exec(mycomponent). The MainLoop calls many functions of the vega.capi
-- table, so the App clas must be initialized on C++ code.
-- @field context the context of the main loop.
vega.MainLoop = {}

--- Creates a new instance of a main loop, sets the component into the context and executes.
function vega.MainLoop.exec(component)
	local mainloop = vega.MainLoop.new()
	mainloop.context.component = component
	mainloop:exec()
end

--- Creates a new main loop table.
function vega.MainLoop.new()
	
	local function refreshviewportsize(scene)
		local screenwidth, screenheight = vega.capi.screensize()
		scene.viewport:updatescreensize(screenwidth, screenheight)
	end
	
	local function checkcomponent(self)
		if currentcomponent ~= self.context.component then
			currentcomponent = self.context.component;
			self.context.contentmanager:releaseresources()
			self.context.contentmanager = vega.ContentManager.new()
			currentcomponent:load(self.context)
			currentcomponent:exec(self.context)
		end
	end
	
	local function checkscene(self)
		if self.context.scene ~= self.context.nextscene then
			self.context.scene = self.context.nextscene;
		end
	end
	
	local function update(self)
		checkcomponent(self)
		checkscene(self)
		if self.context.scene then
			refreshviewportsize(self.context.scene)
			self.context.scene:updatecontrollers(self.context)
		end
	end
	
	local function draw(self)
		if self.context.scene then
			vega.capi.render(self.context.scene)
		else
			vega.capi.clearscreen()
		end
	end
	
	local function sync(self)
		if (self.context.scene) then
			vega.capi.syncend(self.context.scene.framespersecond)
		else
			vega.capi.syncend(30)
		end
	end
	
	local mainloop = {
		context = vega.Context.new(),
	}
	
	--- Runs the loop. This function doesn't return until the loop is running. To finish the loop execution,
	-- set the "executing" field of the context to false.
	function mainloop:exec()
		while self.context.executing do
			vega.capi.syncbegin()
			vega.capi.checkinput(self.context)
			update(self)
			draw(self)
			sync(self)
		end
	end
	
	return mainloop
end
