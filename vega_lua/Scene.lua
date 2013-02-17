require "Viewport"

Scene = {}

function Scene.new()
	return {
		viewport = Viewport.new()
	}
end