require "VegaEngine"

StartComponent = {}

function StartComponent:load(context)
	print "Component loaded."
end

function StartComponent:exec(context)
	print "Component executed."
	
	local scene = Scene.new()
	
	local rect = RectangleDrawable.new()
	rect.color = Color.new(255, 0, 0)
	rect.size = Vector2.new(0.3, 0.3)
	scene.viewport.rootdrawable:addchild(rect)
	
	local child = RectangleDrawable.new()
	child.color = Color.new(0, 200, 0)
	child.size = Vector2.new(0.2, 0.2)
	child.position = Vector2.new(0.25, 0.25)
	child.origin = Vector2.new(0.5, 0.5)
	child.isrelativeoriginx, child.isrelativeoriginy = true, true
	rect:addchild(child)
	
	local child2 = RectangleDrawable.new()
	child2.color = Color.new(255, 255, 255)
	child2.size = Vector2.new(0.1, 0.1)
	rect:addchild(child2)
	
	scene.controllers = {
		{
			update = function(self, context)
				child.rotation = child.rotation + 1
			end
		}
	}
	
	context.nextscene = scene
end
