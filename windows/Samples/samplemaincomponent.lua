require "vega"

local maincomponent = {}

function maincomponent:load(context)
	print "Component loaded."
end

function maincomponent:exec(context)
	print "Component executed."
	
	local scene = vega.Scene.new()
	
	local rect = vega.Drawable.new()
	rect.color = vega.Color.new(255, 0, 0)
	rect.size = vega.Vector2.new(0.3, 0.3)
	scene.viewport.rootdrawable:addchild(rect)
	
	local child = vega.Drawable.new()
	child.color = vega.Color.new(0, 200, 0)
	child.size = vega.Vector2.new(0.2, 0.2)
	child.position = vega.Vector2.new(0.25, 0.25)
	child.origin = vega.Vector2.new(0.5, 0.5)
	child.isrelativeoriginx, child.isrelativeoriginy = true, true
	rect:addchild(child)
	
	local child2 = vega.Drawable.new()
	child2.color = vega.Color.new(255, 255, 255)
	child2.size = vega.Vector2.new(0.1, 0.1)
	rect:addchild(child2)
	
	local texturedrectangle = vega.Drawable.new()
	texturedrectangle.texture = context.contentmanager:gettexture("vegatexture.png")
	texturedrectangle.bottomrightuv = vega.Vector2.new(3, 3)
	texturedrectangle.size = vega.Vector2.new(0.4, 0.4)
	texturedrectangle.origin = vega.Vector2.new(0.5, 0.5)
	texturedrectangle.position = vega.Vector2.new(0.5, 0.5)
	texturedrectangle.isrelativeoriginx, texturedrectangle.isrelativeoriginy = true, true
	texturedrectangle.isrelativepositionx, texturedrectangle.isrelativepositiony = true, true
	scene.viewport.rootdrawable:addchild(texturedrectangle)
	
	local coin = vega.SpriteDrawable.new()
	coin.size = vega.Vector2.new(0.2, 0.2)
	coin.position = vega.Vector2.new(0.5, 0.5)
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
	scene.viewport.rootdrawable:addchild(coin)
	
	--[[
	local transparentrectangle = vega.Drawable.new()
	transparentrectangle.color = vega.Color.new(255, 0, 255)
	transparentrectangle.position = vega.Vector2.new(0.0, 0)
	transparentrectangle.size = vega.Vector2.new(0.6, 0.6)
	transparentrectangle.visibility = 0.5
	scene.viewport.rootdrawable:addchild(transparentrectangle)
	
	local transparentrectangle2 = vega.Drawable.new()
	transparentrectangle2.color = vega.Color.new(255, 0, 255)
	transparentrectangle2.position = vega.Vector2.new(0.6, 0.6)
	transparentrectangle2.size = vega.Vector2.new(0.2, 0.2)
	transparentrectangle2.visibility = 1
	transparentrectangle:addchild(transparentrectangle2)
	]]
	
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
