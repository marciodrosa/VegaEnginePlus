require "vegatable"
require "animation"
require "util"

--- Creates an animation with the function vega.animation that hides a drawable,
-- changing the value of the "visibility" field. This function is equivalent of
-- calling vega.animation with what="visibility" and to=0.
function vega.animations.hide(initialvalues)
	local defaultvalues = {
		what = "visibility",
		to = 0
	}
	vega.util.copyvaluesintotable(initialvalues, defaultvalues)
	return vega.animation(defaultvalues)
end