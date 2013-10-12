require "vega.vegatable"
require "vega.drawable"
require "vega.camera"
require "vega.util"

vega.Layer = {}

--- Creates a layer table. A layer contains a root drawable and a camera. Many layers can be rendered at same time,
-- sequentially, if attached to a scene (see the 'layers' field of the scene table).
-- @field root a root drawable object. A new instance is created by default with vega.drawable() function.
-- @camera the camera to view the root drawable and his children. A new instance is created by default with vega.camera() function.
function vega.layer(initialvalues)
	local l = {
		root = vega.drawable(),
		camera = vega.camera(),
	}
	return vega.util.copyvaluesintotable(initialvalues, l)
end
