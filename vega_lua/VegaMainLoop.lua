VegaMainLoop = {}

function VegaMainLoop:refreshviewportsize(scene)
	screensize = vegascreensize()
	sizechanged = screensize.x ~= scene.viewport.screensize.x or screensize.y ~= scene.viewport.screensize.y
	if sizechanged then
		scene.viewport:onscreensizechanged(screensize)
	end
end

function VegaMainLoop:checkmodule()
	if currentmodule ~= self.context.module then
		currentmodule = self.context.module;
		currentmodule:executemodule()
	end
end

function VegaMainLoop:update()
	self:checkmodule()
	if self.context.scene then
		self:refreshviewportsize(self.context.scene)
		self.context.scene:updatecontrollers()
	end
end

function VegaMainLoop:draw()
	if self.context.scene then
		vegarender(self.context.scene)
	else
		vegaclearscreen()
	end
end

function VegaMainLoop:sync()
	if (self.context.scene) then
		vegasync(self.context.scene.fps)
	else
		vegasync(30)
	end
end

function VegaMainLoop:executeloop()
	while self.context.executing do
		vegacheckinput(self.context)
		self:update()
		self:draw()
		self:sync()
	end
end

function VegaMainLoop:start(startmodule)
	self.context = {
		module = startmodule,
		executing = true
	}
	self:executeloop()
end

VegaMainLoop:start()
