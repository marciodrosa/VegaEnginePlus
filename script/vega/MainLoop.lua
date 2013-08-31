require "vegatable"
require "context"
require "ContentManager"
require "capi"

local currentmodule = nil

--- The main loop of the application. It contains an "execute" functions that starts the loop. The
-- app automatically calls this function. To set the entry point of the app, sets the field "module"
-- using vega.mainloop.context.module = myentrypointmodule.
vega.mainloop = {
	context = vega.context()
}

local function refreshviewportsize(scene)
	local screenwidth, screenheight = vega.capi.screensize()
	for i, v in ipairs(scene.layers) do
		v.camera:refreshsizebylayer(screenwidth, screenheight)
	end
end

local function checkmodule(self)
	if currentmodule ~= self.context.module then
		currentmodule = self.context.module;
		self.context.contentmanager:releaseresources()
		self.context.contentmanager = vega.ContentManager.new()
		currentmodule:load(self.context)
		currentmodule:execute(self.context)
	end
end

local function checkscene(self)
	if self.context.scene ~= self.context.nextscene then
		self.context.scene = self.context.nextscene;
		self.context.nextscene = nil
	end
end

local function update(self)
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

--- Runs the loop. This function doesn't return until the loop is running. To finish the loop execution,
-- set the "executing" field of the context to false (context.executing = false). This function is automatically
-- called by the app after run the initial script.
function vega.mainloop:execute()
	while self.context.executing do
		self:updateframe()
	end
end

--- Called by the main loop each frame. It is an internal method, automatically called by the "execute" function
-- while the main loop is running.
function vega.mainloop:updateframe()
	checkmodule(self)
	checkscene(self)
	self.context.isframeupdating = true
	vega.capi.syncbegin()
	vega.capi.checkinput(self.context)
	update(self)
	draw(self)
	sync(self)
	self.context.isframeupdating = false
end
