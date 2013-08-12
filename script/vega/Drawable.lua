require "vegatable"
require "vector2"
require "list"
require "coordinates"

local drawablefunctions = {}

--function drawablefunctions:getmatrix()
--end

--function drawablefunctions:getglobalmatrix()
--end

--- Removes this Drawable from its parent.
function drawablefunctions:removefromparent()
	if self.parent then self.parent.children.remove(self) end
end

local function getparentsize(drawable)
	if drawable.parent ~= nil then
		return drawable.parent.size
	else
		return nil
	end
end

local function copyvaluesintodrawable(values, drawable)
	for k, v in pairs(values) do
		drawable[k] = v
	end
end

--- Creates a drawable node. The coordinates are from the top/left to the bottom/right. All transforms
-- are relative to the parent node. Some of the fields are dynamic (managed by the metatable).
--
-- The coordinates fields (position, size, origin, childrenorigin, scale, topleftuv and bottomrightuv)
-- requires a table with x and y fields. Some of them (position, size, origin and childrenorigin) copies the
-- values when they are setted and converts it to a coordinates table using the vega.coordinates function. So,
-- you can use relative values, as you can read on vega.coordinates documentation (fields relativex/y and
-- keeprelativex/y). Position and size can be relative to the drawable's parent size; origin and childrenorigin
-- can be relative to the drawable size. 
-- @param initialvalues optional table with the initial values of the drawable. The fields are copied into the
-- new table, so the initialvalues table is discarded.
-- @field position the position coordinates.
-- @field size the size of the drawable.
-- @field origin the origin pivot.
-- @field childrenorigin the origin point of the children, relative to the origin pivot.
-- @field scale the scale of the drawable, (1, 1) by default.
-- @field rotation the rotation in degrees.
-- @field visibility the visibility, where 0 is full transparent and 1 is full opaque. It is 1 by default.
-- @field children a vega.list with the children. When set a table, the values are copied into a new vega.list. New elements
-- can only be added into the list if they aren't in the list yet. If new elements are children of another drawable, they are
-- removed from the old parent.
-- @field color the Color table to be used to draw this object. If not defined, it will be full transparent.
-- @field texture a texture to be used to draw this object, loaded from the ContentManager. If not defined, no texture is used.
-- @field topleftuv the coordinates used to map the texture to the top left corner. If not defined, (0, 0) is assumed.
-- @field bottomrightuv the coordinates used to map the texture to the bottom right corner. If not defined, (1, 1) is assumed.
-- @field texturemodeu the horizontal texture mode to use when the U coordinate is out of the range 0-1, can be "clamp" or "repeat"
-- (default).
-- @field texturemodev the vertical texture mode to use when the V coordinate is out of the range 0-1, can be "clamp" or "repeat"
-- (default).
-- @field beforedraw if defined, this function is called with self argument before the drawable is rendered.
-- @field afterdraw if defined, this function is called with self argument after the drawable is rendered.
-- @field background a child with one special feature: it is drawn before this drawable itself. It automatically adds the background
-- into the children list when a new background is setted. If a new background is setted, the old background is not removed from the
-- children, so it must be done manually.
function vega.drawable(initialvalues)
	local private = {}

	local drawable = {}

	local drawablemetatable = {} 

	function drawablemetatable.__index(t, key)
		if key == "background" or key == "children" or key == "position" or key == "size" or key == "origin" or key == "childrenorigin" then
			return private[key]
		end
	end

	function drawablemetatable.__newindex(t, key, value)
		if key == "position" or key == "size" then
			private[key] = vega.coordinates(value, function() return getparentsize(t) end)
		elseif key == "origin" or key == "childrenorigin" then
			private[key] = vega.coordinates(value, function() return t.size end)
		elseif key == "background" then
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

	drawable.position = { x = 0, y = 0 }
	drawable.size = { x = 1, y = 1 }
	drawable.origin = { x = 0, y = 0 }
	drawable.childrenorigin = { x = 0, y = 0 }
	drawable.scale = { x = 1, y = 1 }
	drawable.rotation = 0
	drawable.visibility = 1
	drawable.children = {}
	drawable.removefromparent = drawablefunctions.removefromparent
	--drawable.getmatrix = drawablefunctions.getmatrix
	--drawable.getglobalmatrix = drawablefunctions.getglobalmatrix

	copyvaluesintodrawable(initialvalues or {}, drawable)

	return drawable
end
