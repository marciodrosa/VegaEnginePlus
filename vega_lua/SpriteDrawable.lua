require "vegatable"
require "Vector2"
require "Drawable"

--- A drawable that subdivide the texture in multiple frames. This division is calculated
-- with the columns and rows fields. To define witch cell of that subdivision should be
-- rendered, set the frame field. The metatable has a drawable as __index.
-- @field columns the columns count, it is 1 by default.
-- @field rows the rows count, it is 1 by default.
-- @field frame the current frame of the sprite, it is 1 (first) by default.
-- @field extensions list of extensions (tables with fields columns, rows and texture). If
-- defined, the sprite can use many images to represent the frames. It can be used if you have
-- so many frames that you extrapolates the max texture size allowed by the video hardware.
-- @field texturebackup internal field
vega.SpriteDrawable = {}

local spritedrawable = {}

--- Calculates and returns the total frames count, based on columns and rows count.
function spritedrawable:getframescount()
	local count = self.rows * self.columns
	if self.extensions ~= nil then
		for i, v in ipairs(self.extensions) do
			count = count + v.rows * v.columns
		end
	end
	return count
end

local function calculateuvs(rows, columns, frame)
	frame = math.floor(frame - 1)
	local column = frame % columns
	local row = math.floor(frame / columns)
	local left = column / columns
	local top = row / rows
	local right = (column + 1) / columns
	local bottom = (row + 1) / rows
	return vega.Vector2.new(left, top), vega.Vector2.new(right, bottom)
end

local function gettextureanduvsforcurrentframe(self)
	local texture, topleftuv, bottomrightuv = nil, nil, nil
	if self.frame > 0 then
		if self.rows > 0 and self.columns > 0 and self.frame <= (self.rows * self.columns) then
			texture, topleftuv, bottomrightuv = self.texture, calculateuvs(self.rows, self.columns, self.frame)
		elseif self.extensions ~= nil then
			local previoustexturesframes = self.rows * self.columns
			for i, extension in ipairs(self.extensions) do
				local relativeframe = self.frame - previoustexturesframes
				if relativeframe <= extension.rows * extension.columns then
					texture, topleftuv, bottomrightuv = extension.texture, calculateuvs(extension.rows, extension.columns, relativeframe)
					break
				else
					previoustexturesframes = previoustexturesframes + (extension.rows * extension.columns)
				end
			end
		end
	end
	return texture, topleftuv, bottomrightuv
end

--- Implements the beforedraw function to calculate the texture and uvs coordinates of the sprite.
function spritedrawable:beforedraw()
	self.texturebackup = self.texture
	self.texture, self.topleftuv, self.bottomrightuv = gettextureanduvsforcurrentframe(self)
end

--- Implements the afterdraw function to reset some modifications made before the rendering.
function spritedrawable:afterdraw()
	self.texture = self.texturebackup
	self.texturebackup = nil
end

function vega.SpriteDrawable.new()
	mt = {
		__index = vega.Drawable.new()
	}
	obj = {
		columns = 1,
		rows = 1,
		frame = 1,
		getframescount = spritedrawable.getframescount,
		beforedraw = spritedrawable.beforedraw,
		afterdraw = spritedrawable.afterdraw,
	}
	return setmetatable(obj, mt)
end
