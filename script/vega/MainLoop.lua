require "vega.vegatable"
require "vega.context"
require "vega.content"
require "vega.capi"

local currentmodule = nil

local displaybackup = {
	size = {
		x = 0,
		y = 0
	},
	windowmode = false
}

--- The main loop of the application. It contains an "execute" functions that starts the loop. The
-- app automatically calls this function. To set the entry point of the app, sets the field "module"
-- using vega.mainloop.context.module = myentrypointmodule.
vega.mainloop = {
	context = vega.context()
}

local function wasdisplaychanged(display)
	return display.size.x ~= displaybackup.size.x or display.size.y ~= displaybackup.size.y or display.windowmode ~= displaybackup.windowmode
end

local function changerealdisplaysizeifneeded(context)
	local display = context.output.display
	if wasdisplaychanged(display) then
		vega.capi.setscreensize(display.size.x, display.size.y, display.windowmode)
	end
end

local function updatedisplaytablewithrealdisplay(context)
	local screenwidth, screenheight, windowmode = vega.capi.screensize()
	context.output.display.size.x = screenwidth
	context.output.display.size.y = screenheight
	context.output.display.windowmode = windowmode
	displaybackup.size.x = screenwidth
	displaybackup.size.y = screenheight
	displaybackup.windowmode = windowmode
end

local function updatelayerssizewithdisplay(context)
	local screenwidth, screenheight = context.output.display.size.x, context.output.display.size.y
	for i, v in ipairs(context.scene.layers) do
		v.camera:refreshsizebylayer(screenwidth, screenheight)
	end
end

local function checkdisplaysize(context)
	changerealdisplaysizeifneeded(context)
	updatedisplaytablewithrealdisplay(context)
	updatelayerssizewithdisplay(context)
end

local function checkmodule(self)
	if self.context.module ~= self.context.nextmodule and self.context.nextmodule ~= nil then
		self.context.module = self.context.nextmodule;
		self.context.nextmodule = nil
	end
	if currentmodule ~= self.context.module then
		currentmodule = self.context.module;
		self.context.content:releaseresources()
		currentmodule:load(self.context)
		currentmodule:execute(self.context)
	end
end

local function checkscene(self)
	if self.context.scene ~= self.context.nextscene and self.context.nextscene ~= nil then
		self.context.scene = self.context.nextscene;
		self.context.nextscene = nil
	end
end

local function update(self)
	if self.context.scene then
		checkdisplaysize(self.context)
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

--- Internal function called by the app to initialize the display table.
function vega.mainloop:initdisplay()
	updatedisplaytablewithrealdisplay(self.context)
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
