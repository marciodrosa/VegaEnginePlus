require "vega"

local mainmodule = {}

function mainmodule:load(context)
	print "Module loaded."
end

function mainmodule:execute(context)
	print "Module executed."
	local scene = vega.scene()

	local xaxis = vega.drawable {
		color = { r = 255, g = 0, b = 0 },
		size = { x = 10, y = 0.005 },
		origin = { relativex = 0.5, relativey = 0.5 }
	}

	local yaxis = vega.drawable {
		color = { r = 0, g = 255, b = 0 },
		size = { x = 0.005, y = 10 },
		origin = { relativex = 0.5, relativey = 0.5 }
	}

	local yellowrectangle = vega.drawable {
		color = { r = 255, g = 255, b = 0 },
		size = { x = 0.1, y = 0.1 },
		position = { x = -0.3, y = -0.2 },
		origin = { relativex = 0.5, relativey = 0.5 },
		rotation = 0
	} 

	local whiterectangle = vega.drawable {
		color = { r = 255, g = 255, b = 255 },
		size = { x = 0.1, y = 0.1 },
		position = { x = 0.2, y = 0.1 },
		origin = { relativex = 0.5, relativey = 0.5 },
		scale = { x = 2, y = 1 },
		rotation = 35
	} 

	local blackrectangle = vega.drawable {
		color = { r = 0, g = 0, b = 0 },
		size = { x = 0.1, y = 0.1 },
		position = { x = 0.2, y = 0.3 },
		origin = { relativex = 0.5, relativey = 0.5 },
		rotation = 80
	}

	yellowrectangle.children.insert(whiterectangle)
	whiterectangle.children.insert(blackrectangle)

	scene.layers[1].root.children = {
		xaxis,
		yaxis,
		yellowrectangle
	}
	scene.layers[1].camera = vega.camera {
		position = { x = -0.1, y = -0.05 },
		rotation = 30,
		scale = { x = 0.9, y = 0.9 }
	}

	local displaydot = vega.drawable {
		color = { r = 255, g = 255, b = 0 },
		visibility = 0.75,
		size = { x = 50, y = 50 },
		origin = { x = 25, y = 25 }
	}
	local displaylayer = vega.layer {
		size = context.output.display.size,
		root = vega.drawable {
			children = {
				displaydot
			}
		},
		camera = vega.camera {
			position = { x = -100, y = 200 },
			size = { x = 500, y = 500 },
			rotation = 45
		}
	}
	scene.layers.insert(displaylayer)
	
	scene.controllers = {
		{
			update = function(self, context)
				whiterectangle.rotation = whiterectangle.rotation - 0.5
				blackrectangle.rotation = blackrectangle.rotation + 1
				local blackrectanglematrix = vega.transform.getglobalmatrix(blackrectangle, scene.layers[1])
			end
		},
		{
			update = function(self, context)
				local blackrectanglematrix = vega.transform.getglobalmatrix(blackrectangle)
				local blackrectanglepos = vega.transform.transformpoint({ x = 0, y = 0 }, blackrectanglematrix)
				local layer2pos = vega.coordinatesconverter.fromlayertoanotherlayer(blackrectanglepos, scene.layers[1], scene.layers[2])
				--local screenposition = vega.coordinatesconverter.fromlayertodisplay(blackrectanglepos, scene.layers[1], context.output.display)
				displaydot.position = layer2pos
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
