require "vega"

sampleutil = {}

local function createbuttondrawable(label, context)
	return vega.drawable {
		size = { 300, 60 },
		children = {
			vega.drawable {
				name = "border",
				color = 0xffffffff,
				size = { 300, 60 }
			},
			vega.drawable {
				name = "background",
				color = 0xff000000,
				size = { 298, 58 },
				position = { 1, 1 }
			},
			vega.drawables.text {
				name = "text",
				content = label,
				fontcolor = 0xffffffff,
				font = context.content.fonts.arial,
				fontsize = 36,
				origin = { relativex = 0.5, relativey = 0.5 },
				position = { relativex = 0.5, relativey = 0.5 }
			}
		}
	}
end

local function createbuttoncontroller(buttondrawable, callback, layer, context)
	return {
		update = function(self, context)
			local isfocused = vega.collision.drawablecollideswithdisplaypoint(buttondrawable, context.input.mouse.position, layer, context.output.display)
			if isfocused then
				buttondrawable.children.background.color = 0xffffffff
				buttondrawable.children.text.fontcolor = 0xff000000
			else
				buttondrawable.children.background.color = 0xff000000
				buttondrawable.children.text.fontcolor = 0xffffffff
			end
			buttondrawable.children.text:refresh()
			if isfocused and context.input.mouse.buttons.left.wasclicked then
				callback(context)
			end
		end
	}
end

--- Creates and adds a layer with buttons.
-- @param context the current context.
-- @param buttons list of buttons (tables with two fields: the 'label' text and the 'callback' function, that receives
-- the context object as parameter).
function sampleutil.createbuttonslayer(context, buttons)
	local layer = vega.layer {
		camera = vega.camera {
			size = { 1000, 1000 },
			origin = { relativex = 0, relativey = 1 }
		}
	}
	context.scene.layers.insert(layer)
	local margin = 5
	local y = margin
	for i, v in ipairs(buttons) do
		local drawable = createbuttondrawable(v.label, context)
		local controller = createbuttoncontroller(drawable, v.callback, layer, context)
		drawable.position.x = margin
		drawable.position.y = -y - drawable.size.y
		y = y + drawable.size.y + margin
		layer.root.children.insert(drawable)
		context.scene.controllers.insert(controller)
	end
end

--- Creates and adds a layer with the button to go back to main menu.
function sampleutil.createbackbuttonlayer(context)
	sampleutil.createbuttonslayer(context, {
		{
			label = "back",
			callback = function (context)
				context.nextmodule = mainmenu
			end
		}
	})
end
