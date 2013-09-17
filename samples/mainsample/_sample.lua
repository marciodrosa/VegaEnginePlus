require "vega"

local mainmodule = {}

function mainmodule:load(context)
	print "Module loaded."
end

function mainmodule:execute(context)
	print "Module executed."
	local scene = vega.scene()

	scene.layers[1].camera.position = { x = 0.5, y = 0.5 }

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
				},
			}
		},
		vega.drawable {
			texture = context.content.textures.vegatexture,
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
			texture = context.content.textures.coin,
			extensions = {
				{
					texture = context.content.textures.coinblue,
					rows = 2,
					columns = 10
				},
				{
					texture = context.content.textures.coinred,
					rows = 2,
					columns = 10
				},
			}
		}
	}

	scene.layers[2] = vega.layer {
		camera = vega.camera {
			size = { x = 100, y = 100},
			autocalculatewidth = false,
			autocalculateheight = false
		},
		root = vega.drawable {
			children = {
				vega.drawable {
					size = { x = 100, y = 100 },
					origin = { x = 50, y = 50 },
					children = {
						vega.drawable {
							size = { x = 5, y = 5 },
							color = { r = 0, g = 0, b = 255},
							position = { relativex = 0, relativey = 0 },
							origin = { relativex = 0.5, relativey = 0.5 }
						},
						vega.drawable {
							size = { x = 5, y = 5 },
							color = { r = 0, g = 0, b = 255},
							position = { relativex = 1, relativey = 0 },
							origin = { relativex = 0.5, relativey = 0.5 }
						},
						vega.drawable {
							size = { x = 5, y = 5 },
							color = { r = 0, g = 0, b = 255},
							position = { relativex = 1, relativey = 1 },
							origin = { relativex = 0.5, relativey = 0.5 }
						},
						vega.drawable {
							size = { x = 5, y = 5 },
							color = { r = 0, g = 0, b = 255},
							position = { relativex = 0, relativey = 1 },
							origin = { relativex = 0.5, relativey = 0.5 }
						}
					}
				},
			}
		}
	}

	scene.layers[3] = vega.layer {
		root = vega.drawable {
			children = {
				vega.drawables.text {
					content = "This is a text.",
					fontsize = 0.05,
					font = context.content.fonts.arial
				}
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
				local mouse = context.input.mouse
				if mouse.buttons.left.wasclicked then
					print("Left mouse button clicked at "..mouse.position.x..", "..mouse.position.y)
				end
				if mouse.buttons.left.wasreleased then
					print("Left mouse button released at "..mouse.position.x..", "..mouse.position.y)
				end
				if mouse.buttons.right.wasclicked then
					print("Right mouse button clicked at "..mouse.position.x..", "..mouse.position.y)
				end
				if mouse.buttons.right.wasreleased then
					print("Right mouse button released at "..mouse.position.x..", "..mouse.position.y)
				end
				if mouse.buttons.middle.wasclicked then
					print("Middle mouse button clicked at "..mouse.position.x..", "..mouse.position.y)
				end
				if mouse.buttons.middle.wasreleased then
					print("Middle mouse button released at "..mouse.position.x..", "..mouse.position.y)
				end
				if mouse.motion.z ~= 0 then
					print(mouse.motion.z)
				end
			end
		},
	}
	
	context.nextscene = scene
end

vega.mainloop.context.module = mainmodule
