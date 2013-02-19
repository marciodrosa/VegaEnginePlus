require "VegaEngine"

StartComponent = {}

function StartComponent:load(context)
	print "Component loaded."
end

function StartComponent:exec(context)
	print "Component executed."
	context.nextscene = Scene.new()
end
