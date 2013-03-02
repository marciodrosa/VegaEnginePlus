require "vegatable"
require "Context"
require "ContentManager"
require "capi"

vega.mainloop = {
	startframetime = 0,
}

function vega.mainloop:refreshviewportsize(scene)
	local screenwidth, screenheight = vega.capi.screensize()
	scene.viewport:updatescreensize(screenwidth, screenheight)
end

function vega.mainloop:checkcomponent()
	if currentcomponent ~= self.context.component then
		currentcomponent = self.context.component;
		self.context.contentmanager:releaseresources()
		self.context.contentmanager = vega.ContentManager.new()
		currentcomponent:load(self.context)
		currentcomponent:exec(self.context)
	end
end

function vega.mainloop:checkscene()
	if self.context.scene ~= self.context.nextscene then
		self.context.scene = self.context.nextscene;
	end
end

function vega.mainloop:update()
	self:checkcomponent()
	self:checkscene()
	if self.context.scene then
		self:refreshviewportsize(self.context.scene)
		self.context.scene:updatecontrollers(self.context)
	end
end

function vega.mainloop:draw()
	if self.context.scene then
		vega.capi.render(self.context.scene)
	else
		vega.capi.clearscreen()
	end
end

function vega.mainloop:sync()
	if (self.context.scene) then
		vega.capi.syncend(self.context.scene.framespersecond)
	else
		vega.capi.syncend(30)
	end
end

function vega.mainloop:executeloop()
	while self.context.executing do
		vega.capi.syncbegin()
		vega.capi.checkinput(self.context)
		self:update()
		self:draw()
		self:sync()
	end
end

function vega.mainloop:start()
	self.context = vega.Context.new()
	self:executeloop()
end

vega.mainloop:start()
