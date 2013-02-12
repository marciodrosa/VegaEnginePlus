VegaMainLoop = {
	startframetime = 0,
}

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
		currentmodule:executemodule(self.context)
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
		vegasyncend(self.context.scene.fps)
	else
		vegasyncend(30)
	end
end

function VegaMainLoop:executeloop()
	while self.context.executing do
		vegasyncbegin()
		vegacheckinput(self.context)
		self:update()
		self:draw()
		self:sync()
	end
end

function VegaMainLoop:start()
	-- creates the context and sets the StartModule into it
	self.context = {
		module = StartModule,
		executing = true
	}
	self:executeloop()
end

VegaMainLoop:start()
