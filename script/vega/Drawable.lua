require "vegatable"
require "vector2"

--- A drawable node. Create your own instance with Drawable.new(myTable).
-- The coordinates are from the top/left to the bottom/right. All transforms
-- are relative to the parent node.
-- @field position a Vector2 with the position of the Drawable.
-- @field size a Vector2 with the size of the Drawable, it is (1, 1) by default.
-- @field origin the origin pivot, it is (0, 0) by default.
-- @field scale the scale, it is (1, 1) by default.
-- @field childrenorigin the origin point of the children, relative to the origin pivot. It is (0, 0) by default.
-- @field rotation the rotation.
-- @field visibility the visibility, where 0 is full transparent and 1 is full opaque. It is 1 by default.
-- @field isrelativex set to true to make the x coordinate of the position relative to the size of the parent.
-- @field isrelativey set to true to make the y coordinate of the position relative to the size of the parent.
-- @field isrelativewidth set to true to make the x coordinate of the size relative to the size of the parent.
-- @field isrelativeheigth set to true to make the y coordinate of the size relative to the size of the parent.
-- @field isrelativeoriginx set to true to make the x coordinate of the origin relative to the size of the Drawable.
-- @field isrelativeoriginy set to true to make the y coordinate of the origin relative to the size of the Drawable.
-- @field children the children list. Please do not modify this list. Use the addchild, insertchild, setchildren or removechild functions instead.
-- @field parent the parent Drawable. It is nil until this Drawable is added to another Drawable with the addchild function.
-- @field background the background Drawable. To set, use the setbackground function, so the drawable is also added as child.
-- @field color the Color table to be used to draw this object. If not defined, it will be full transparent.
-- @field texture a texture to be used to draw this object, loaded from the ContentManager. If not defined, no texture is used.
-- @field topleftuv a Vector2 UV coordinate used to map the texture to the top left corner. If not defined, (0, 0) is assumed.
-- @field bottomrightuv a Vector2 UV coordinate used to map the texture to the bottom right corner. If not defined, (1, 1) is assumed.
-- @field texturemodeu the horizontal texture mode to use when the U coordinate is out of the range 0-1, can be "clamp" or "repeat"
-- (default value used if not defined)
-- @field texturemodev the vertical texture mode to use when the V coordinate is out of the range 0-1, can be "clamp" or "repeat"
-- (default value used if not defined)
-- the range (0, 0) and (1, 1).
-- @field beforedraw if defined, this function is called with self argument before the drawable is rendered.
-- @field afterdraw if defined, this function is called with self argument after the drawable is rendered.
local drawable = {}

--- Returns the position, relative to the parent size.
-- @return a Vector2 with the relative position.
function drawable:getrelativeposition()
	local rp = vega.Vector2.new(self.position.x, self.position.y)
	if (self.parent) then
		if not self.isrelativex then rp.x = self.position.x / self.parent:getabsolutesize().x end
		if not self.isrelativey then rp.y = self.position.y / self.parent:getabsolutesize().y end
	end
	return rp
end

--- Returns the size, relative to the parent size.
-- @return a Vector2 with the relative size.
function drawable:getrelativesize()
	local rs = vega.Vector2.new(self.size.x, self.size.y)
	if (self.parent) then
		if not self.isrelativewidth then rs.x = self.size.x / self.parent:getabsolutesize().x end
		if not self.isrelativeheigth then rs.y = self.size.y / self.parent:getabsolutesize().y end
	end
	return rs
end

--- Returns the origin, relative to the size.
-- @return a Vector2 with the relative origin.
function drawable:getrelativeorigin()
	local ro = vega.Vector2.new(self.origin.x, self.origin.y)
	if not self.isrelativeoriginx then ro.x = self.origin.x / self:getabsolutesize().x end
	if not self.isrelativeoriginy then ro.y = self.origin.y / self:getabsolutesize().y end
	return ro
end

--- Returns the absolute position (useful if isrelativepositionx or isrelativepositiony is true).
-- @return a Vector2 with the absolute position.
function drawable:getabsoluteposition()
	local ap = vega.Vector2.new(self.position.x, self.position.y)
	if (self.parent) then
		if self.isrelativex then ap.x = self.position.x * self.parent:getabsolutesize().x end
		if self.isrelativey then ap.y = self.position.y * self.parent:getabsolutesize().y end
	end
	return ap
end

--- Returns the absolute size (useful if isrelativewidth or isrelativeheigth is true).
-- @return a Vector2 with the absolute position.
function drawable:getabsolutesize()
	local as = vega.Vector2.new(self.size.x, self.size.y)
	if (self.parent) then
		if self.isrelativewidth then as.x = self.size.x * self.parent:getabsolutesize().x end
		if self.isrelativeheigth then as.y = self.size.y * self.parent:getabsolutesize().y end
	end
	return as
end

--- Returns the absolute origin (useful if isrelativeoriginx or isrelativeoriginy is true).
-- @return a Vector2 with the absolute origin.
function drawable:getabsoluteorigin()
	local ao = vega.Vector2.new(self.origin.x, self.origin.y)
	if self.isrelativeoriginx then ao.x = self.origin.x * self:getabsolutesize().x end
	if self.isrelativeoriginy then ao.y = self.origin.y * self:getabsolutesize().y end
	return ao
end

function drawable:getmatrix()
end

function drawable:getglobalmatrix()
end

--- Adds the child to the end of the children list. It does nothing if the parent of the
-- object is already a child of this Drawable. If the Drawable is child of another Drawable,
-- it is first removed from the current parent.
-- @param child the Drawable to add.
-- @param the index. If not defined, the child is appended to the end of the children list.
-- If less than 1, then the child is added in the index 1. If greater than list size, then
-- the child is added in the end of the list.
function drawable:addchild(child, index)
	if (index == nil) then index = #self.children + 1 end
	if type(child) ~= "table" then error "The child argument of addchild function must be a table." end
	if type(index) ~= "number" then error "The index argument of addchild function must be a number." end
	if index < 1 then index = 1 end
	if index > #self.children + 1 then index = #self.children + 1 end
	if child.parent ~= self then
		if (child.parent) then child.parent:removechild(child) end
		table.insert(self.children, index, child)
		child.parent = self
	end
end

--- Removes the child from the children list.
-- @param child the child to be removed.
function drawable:removechild(child)
	if child and child.parent == self then
		for i, v in ipairs(self.children) do
			if (v == child) then
				table.remove(self.children, i)
				child.parent = nil
				break
			end
		end
	end
end

--- First, it removes all current children of this Drawable. Then, it adds the new children.
-- @param children the children list to be added to this Drawable.
function drawable:setchildren(children)
	while (#self.children > 0) do
		self:removechild(self.children[#self.children])
	end
	for k, v in pairs(children) do
		self:addchild(v)
	end
end

--- Removes this Drawable from its parent.
function drawable:removefromparent()
	if self.parent then self.parent:removechild(self) end
end


--- Sets a child with one special feature: it is drawn before this drawable itself.
-- This function also added the background to the children list with the addchild
-- function. If this function is called again with another background the old background
-- is not removed from the children, so it must be done manually.
function drawable:setbackground(bg)
	self.background = bg
	if bg ~= nil then self:addchild(bg) end
end

--- Creates a new instance of a drawable table.
function vega.drawable()
	return {
		position = vega.Vector2.zero,
		size = vega.Vector2.one,
		origin = vega.Vector2.zero,
		scale = vega.Vector2.one,
		childrenorigin = vega.Vector2.zero,
		rotation = 0,
		visibility = 1,
		isrelativex = false,
		isrelativey = false,
		isrelativewidth = false,
		isrelativeheigth = false,
		isrelativeoriginx = false,
		isrelativeoriginy = false,
		children = {},
		getrelativeposition = drawable.getrelativeposition,
		getrelativesize = drawable.getrelativesize,
		getrelativeorigin = drawable.getrelativeorigin,
		getabsoluteposition = drawable.getabsoluteposition,
		getabsolutesize = drawable.getabsolutesize,
		getabsoluteorigin = drawable.getabsoluteorigin,
		getmatrix = drawable.getmatrix,
		getglobalmatrix = drawable.getglobalmatrix,
		addchild = drawable.addchild,
		insertchildat = drawable.insertchildat,
		removechild = drawable.removechild,
		setchildren = drawable.setchildren,
		removefromparent = drawable.removefromparent,
		setbackground = drawable.setbackground
	}
end
