require "vega"

StartComponent = {}

function StartComponent:load(context)
	print "Component loaded."
end

function StartComponent:exec(context)
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
	texturedrectangle.texturemodeu = "repeat"
	texturedrectangle.texturemodev = "repeat"
	texturedrectangle.size = vega.Vector2.new(0.4, 0.4)
	texturedrectangle.origin = vega.Vector2.new(0.5, 0.5)
	texturedrectangle.position = vega.Vector2.new(0.5, 0.5)
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
