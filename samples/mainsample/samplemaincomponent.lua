require "vega"

local maincomponent = {}

function maincomponent:load(context)
	print "Component loaded."
end

function maincomponent:exec(context)
	print "Component executed."
	local scene = vega.scene()

	scene.layers[1].root.children = {
		vega.drawable {
			name = "firstrectangle",
			color = { r = 255, g = 0, b = 0 },
			size = { x = 0.3, y = 0.3 },
			children = {
				vega.drawable {
					name = "rotatedrectangle",
					color = { r = 0, g = 200, b = 0, a = 125 },
					size = { x = 0.2, y = 0.2 },
					position = { x = 0.25, y = 0.25 },
					origin = { relativex = 0.5, relativey = 0.5 }
				},
				vega.drawable {
					color = { r = 255, g = 255, b = 255 },
					size = { x = 0.1, y = 0.1 }
				}
			}
		},
		vega.drawable {
			texture = context.contentmanager:gettexture("vegatexture.png"),
			bottomrightuv = { x = 3, y = 3 },
			size = { x = 0.4, y = 0.4 },
			origin = { relativex = 0.5, relativey = 0.5 },
			position = { relativex = 0.5, relativey = 0.5 }
		},
		vega.spritedrawable {
			name = "coin",
			size = { x = 0.2, y = 0.2 },
			position = { x = 0.5, y = 0.5 },
			rows = 2,
			columns = 10,
			texture = context.contentmanager:gettexture("coin.png"),
			extensions = {
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
		}
	}
	
	scene.controllers = {
		{
			update = function(self, context)
				local rotatedrectangle = context.scene.layers[1].root.children.firstrectangle.children.rotatedrectangle
				rotatedrectangle.rotation = rotatedrectangle.rotation + 1
			end
		},
		{
			update = function(self, context)
				local coin = context.scene.layers[1].root.children.coin
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
