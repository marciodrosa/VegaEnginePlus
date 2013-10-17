textsample = {}

function textsample:load(context)
end

function textsample:execute(context)
	context.scene = vega.scene {
		layers = {
			vega.layer {
				root = vega.drawable {
					children = {
						vega.drawables.text {
							content = "This is a\nmultiline text.",
							font = context.content.fonts.arial,
							fontsize = 0.1
						}
					}
				}
			}
		}
	}
	sampleutil.createbackbuttonlayer(context)
end
