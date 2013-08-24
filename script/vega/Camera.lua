require "vegatable"
require "util"

--- Refreshes the size of the camera, given the layer size. The size is calculated with
-- the autocalculatewidth and autocalculateheight. This function is automatically called
-- by the SDK, it is not normally called by the user.
-- @param layerwidth the layer width
-- @param layerheigth the layer heigth
local function refreshsizebylayer(self, layerwidth, layerheight)
	if self.autocalculatewidth and self.autocalculateheight then
		self.size.x, self.size.y = layerwidth, layerheight
	elseif self.autocalculatewidth then
		self.size.x = (layerwidth * self.size.y) / layerheight
	elseif self.autocalculateheight then
		self.size.y = (layerheight * self.size.x) / layerwidth
	end
end

--- Creates a new camera. The camera is a drawable table with a few fields more.
-- When attached to a layer, the visible area of this layer is equal to the rectangle area of
-- this camera.
--  
-- @arg initialvalues optional table with initial values for the camera table.
-- 
-- @field autocalculatewidth if true (default value), the width is automatically calculated
-- to keep the aspect ratio. If both autocalculatewidth and autocalculateheight are true,
-- then the size will be equal to the available area of the layer.
-- @field autocalculateheight if true, the height is automatically calculated to keep the
-- aspect ratio. It is false by default. If both autocalculatewidth and autocalculateheight
-- are true, then the size will be equal to the available area of the layer.
function vega.camera(initialvalues)
	local cam = vega.drawable()
	cam.autocalculatewidth = true
	cam.autocalculateheight = false
	cam.refreshsizebylayer = refreshsizebylayer
	cam.origin = {
		relativex = 0.5,
		relativey = 0.5
	}
	return vega.util.copyvaluesintotable(initialvalues, cam)
end
