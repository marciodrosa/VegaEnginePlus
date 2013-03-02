require "VegaEngine"

StartComponent = {}

function StartComponent:load(context)
	print "Component loaded."
end

function StartComponent:exec(context)
	print "Component executed."
	
	local scene = Scene.new()
	
	local rect = Drawable.new()
	rect.color = Color.new(255, 0, 0)
	rect.size = Vector2.new(0.3, 0.3)
	scene.viewport.rootdrawable:addchild(rect)
	
	local child = Drawable.new()
	child.color = Color.new(0, 200, 0)
	child.size = Vector2.new(0.2, 0.2)
	child.position = Vector2.new(0.25, 0.25)
	child.origin = Vector2.new(0.5, 0.5)
	child.isrelativeoriginx, child.isrelativeoriginy = true, true
	rect:addchild(child)
	
	local child2 = Drawable.new()
	child2.color = Color.new(255, 255, 255)
	child2.size = Vector2.new(0.1, 0.1)
	rect:addchild(child2)
	
	local texturedrectangle = Drawable.new()
	texturedrectangle.texture = context.contentmanager:gettexture("vegatexture.png")
	texturedrectangle.size = Vector2.new(0.4, 0.4)
	texturedrectangle.origin = Vector2.new(0.5, 0.5)
	texturedrectangle.position = Vector2.new(0.5, 0.5)
	texturedrectangle.isrelativeoriginx, texturedrectangle.isrelativeoriginy = true, true
	texturedrectangle.isrelativepositionx, texturedrectangle.isrelativepositiony = true, true
	scene.viewport.rootdrawable:addchild(texturedrectangle)
	
	scene.controllers = {
		{
			update = function(self, context)
				child.rotation = child.rotation + 1
			end
		}
	}
	
	context.nextscene = scene
end
