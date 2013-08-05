require "vegatable"
require "vector2"
require "list"

local drawablefunctions = {}

--- Returns the position, relative to the parent size.
-- @return a Vector2 with the relative position.
function drawablefunctions:getrelativeposition()
	local rp = vega.Vector2.new(self.position.x, self.position.y)
	if (self.parent) then
		if not self.isrelativex then rp.x = self.position.x / self.parent:getabsolutesize().x end
		if not self.isrelativey then rp.y = self.position.y / self.parent:getabsolutesize().y end
	end
	return rp
end

--- Returns the size, relative to the parent size.
-- @return a Vector2 with the relative size.
function drawablefunctions:getrelativesize()
	local rs = vega.Vector2.new(self.size.x, self.size.y)
	if (self.parent) then
		if not self.isrelativewidth then rs.x = self.size.x / self.parent:getabsolutesize().x end
		if not self.isrelativeheigth then rs.y = self.size.y / self.parent:getabsolutesize().y end
	end
	return rs
end

--- Returns the origin, relative to the size.
-- @return a Vector2 with the relative origin.
function drawablefunctions:getrelativeorigin()
	local ro = vega.Vector2.new(self.origin.x, self.origin.y)
	if not self.isrelativeoriginx then ro.x = self.origin.x / self:getabsolutesize().x end
	if not self.isrelativeoriginy then ro.y = self.origin.y / self:getabsolutesize().y end
	return ro
end

--- Returns the absolute position (useful if isrelativepositionx or isrelativepositiony is true).
-- @return a Vector2 with the absolute position.
function drawablefunctions:getabsoluteposition()
	local ap = vega.Vector2.new(self.position.x, self.position.y)
	if (self.parent) then
		if self.isrelativex then ap.x = self.position.x * self.parent:getabsolutesize().x end
		if self.isrelativey then ap.y = self.position.y * self.parent:getabsolutesize().y end
	end
	return ap
end

--- Returns the absolute size (useful if isrelativewidth or isrelativeheigth is true).
-- @return a Vector2 with the absolute position.
function drawablefunctions:getabsolutesize()
	local as = vega.Vector2.new(self.size.x, self.size.y)
	if (self.parent) then
		if self.isrelativewidth then as.x = self.size.x * self.parent:getabsolutesize().x end
		if self.isrelativeheigth then as.y = self.size.y * self.parent:getabsolutesize().y end
	end
	return as
end

--- Returns the absolute origin (useful if isrelativeoriginx or isrelativeoriginy is true).
-- @return a Vector2 with the absolute origin.
function drawablefunctions:getabsoluteorigin()
	local ao = vega.Vector2.new(self.origin.x, self.origin.y)
	if self.isrelativeoriginx then ao.x = self.origin.x * self:getabsolutesize().x end
	if self.isrelativeoriginy then ao.y = self.origin.y * self:getabsolutesize().y end
	return ao
end

function drawablefunctions:getmatrix()
end

function drawablefunctions:getglobalmatrix()
end

--- Removes this Drawable from its parent.
function drawablefunctions:removefromparent()
	if self.parent then self.parent.children.remove(self) end
end

--- Creates a drawable node. The coordinates are from the top/left to the bottom/right. All transforms
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
-- @field children a vega.list with the children. When set a table, the values are copied into a new vega.list. New elements
-- can only be added into the list if they aren't in the list yet. If new elements are children of another drawable, they are
-- removed from the old parent.
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
-- @field background a child with one special feature: it is drawn before this drawable itself. It automatically adds the background
-- into the children list when a new background is setted. If a new background is setted, the old background is not removed from the
-- children, so it must be done manually.
function vega.drawable()
	local private = {}

	local drawable = {}

	local drawablemetatable = {} 

	function drawablemetatable.__index(t, key)
		if key == "background" then
			return private.background
		elseif key == "children" then
			return private.children
		end
	end

	function drawablemetatable.__newindex(t, key, value)
		if key == "background" then
			private.background = value
			if value ~= nil then
				t.children.insert(value)
			end
		elseif key == "children" then
			if private.children ~= nil then
				while #private.children > 0 do
					private.children.remove(#private.children)
				end
			end
			if value == nil then
				private.children = nil
			else
				private.children = vega.list {
					singleoccurrence = true,
					initialvalues = value,
					callback = {
						beforeset = function(index, value)
							if type(value) ~= "table" then error "Only tables can be added into the children table." end
							if value.parent ~= drawable and value.parent ~= nil then value.parent.children.remove(value) end
						end,

						afterset = function(index, value)
							value.parent = drawable
						end,
						
						beforeremove = function(index, value)
							value.parent = nil
						end
					}
				}
			end
		else
			rawset(t, key, value)
		end
	end
	setmetatable(drawable, drawablemetatable)

	drawable.position = vega.Vector2.zero
	drawable.size = vega.Vector2.one
	drawable.origin = vega.Vector2.zero
	drawable.scale = vega.Vector2.one
	drawable.childrenorigin = vega.Vector2.zero
	drawable.rotation = 0
	drawable.visibility = 1
	drawable.isrelativex = false
	drawable.isrelativey = false
	drawable.isrelativewidth = false
	drawable.isrelativeheigth = false
	drawable.isrelativeoriginx = false
	drawable.isrelativeoriginy = false
	drawable.children = {}
	drawable.getrelativeposition = drawablefunctions.getrelativeposition
	drawable.getrelativesize = drawablefunctions.getrelativesize
	drawable.getrelativeorigin = drawablefunctions.getrelativeorigin
	drawable.getabsoluteposition = drawablefunctions.getabsoluteposition
	drawable.getabsolutesize = drawablefunctions.getabsolutesize
	drawable.getabsoluteorigin = drawablefunctions.getabsoluteorigin
	drawable.getmatrix = drawablefunctions.getmatrix
	drawable.getglobalmatrix = drawablefunctions.getglobalmatrix
	drawable.removefromparent = drawablefunctions.removefromparent

	return drawable
end
