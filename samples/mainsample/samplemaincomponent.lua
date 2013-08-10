require "vega"

local maincomponent = {}

function maincomponent:load(context)
	print "Component loaded."
end

function maincomponent:exec(context)
	print "Component executed."
	local scene = vega.Scene.new()

	local rect = vega.drawable()
	rect.color = vega.Color.new(255, 0, 0)
	rect.size = { x = 0.3, y = 0.3 }
	scene.viewport.rootdrawable.children.insert(rect)

	local child = vega.drawable()
	child.color = vega.Color.new(0, 200, 0)
	child.size = { x = 0.2, y = 0.2 }
	child.position = { x = 0.25, y = 0.25 }
	child.origin = { relativex = 0.5, relativey = 0.5 }
	rect.children.insert(child)
	
	local child2 = vega.drawable()
	child2.color = vega.Color.new(255, 255, 255)
	child2.size = { x = 0.1, y = 0.1 }
	rect.children.insert(child2)
	
	local texturedrectangle = vega.drawable()
	texturedrectangle.texture = context.contentmanager:gettexture("vegatexture.png")
	texturedrectangle.bottomrightuv = { x = 3, y = 3 }
	texturedrectangle.size = { x = 0.4, y = 0.4 }
	texturedrectangle.origin = { relativex = 0.5, relativey = 0.5 }
	texturedrectangle.position = { relativex = 0.5, relativey = 0.5 }
	scene.viewport.rootdrawable.children.insert(texturedrectangle)
	
	local coin = vega.spritedrawable()
	coin.size = { x = 0.2, y = 0.2 }
	coin.position = { x = 0.5, y = 0.5 }
	coin.rows = 2
	coin.columns = 10
	coin.texture = context.contentmanager:gettexture("coin.png")
	coin.extensions = {
		{
			texture = context.contentmanager:gettexture("coin_blue.png"),
			rows = 2,
			columns = 10
		},
		{
			texture = context.contentmanager:gettexture("coin_red.png"),
			rows = 2,
			columns = 10
		},
	}
	scene.viewport.rootdrawable.children.insert(coin)
	
	scene.controllers = {
		{
			update = function(self, context)
				child.rotation = child.rotation + 1
			end
		},
		{
			update = function(self, context)
				coin.frame = coin.frame + 1
				if coin.frame > coin:getframescount() then coin.frame = 1 end
			end
		},
		{
			update = function(self, context)
				if #context.input.newtouchpoints > 0 then
					print("Started touching at "..tostring(context.input.newtouchpoints[1].position))
				end
				if #context.input.touchpoints > 0 then
					print("Touching at "..tostring(context.input.touchpoints[1].position))
				end
				if #context.input.releasedtouchpoints > 0 then
					print("Released touching at "..tostring(context.input.releasedtouchpoints[1].position))
				end
			end
		},
	}
	
	context.nextscene = scene
end

vega.MainLoop.exec(maincomponent)
