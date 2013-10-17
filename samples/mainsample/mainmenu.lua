require "sampleutil"
require "firstsample"
require "secondsample"
require "textsample"

mainmenu = {}

function mainmenu:load(context)
end

function mainmenu:execute(context)
	context.scene = vega.scene {
		backgroundcolor = 0xff000000
	}
	sampleutil.createbuttonslayer(context, {
		{
			label = "first",
			callback = function(context)
				context.nextmodule = firstsample
			end
		},
		{
			label = "second",
			callback = function(context)
				context.nextmodule = secondsample
			end
		},
		{
			label = "text",
			callback = function(context)
				context.nextmodule = textsample
			end
		},
	})
end

vega.mainloop.context.module = mainmenu
