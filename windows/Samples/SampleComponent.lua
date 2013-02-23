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
	rect.childrenorigin = Vector2.new(0.3, 0.3)
	rect.scale = Vector2.new(2, 2)
	scene.viewport.rootdrawable:addchild(rect)
	
	local child = RectangleDrawable.new()
	child.color = Color.new(0, 200, 0)
	child.size = Vector2.new(0.2, 0.2)
	rect:addchild(child)
	
	context.nextscene = scene
end
