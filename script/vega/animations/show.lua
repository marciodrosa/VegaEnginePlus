require "vegatable"
require "animation"
require "util"

--- Creates an animation with the function vega.animation that shows a hidden drawable,
-- changing the value of the "visibility" field. This function is equivalent of
-- calling vega.animation with what="visibility" and to=1.
-- @param initialvalues table with initial values for the fields.
function vega.animations.show(initialvalues)
	local defaultvalues = {
		what = "visibility",
		to = 1
	}
	vega.util.copyvaluesintotable(initialvalues, defaultvalues)
	return vega.animation(defaultvalues)
end