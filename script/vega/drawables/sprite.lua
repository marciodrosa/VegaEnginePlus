require "vega.vegatable"
require "vega.drawable"
require "vega.util"

local function getframescount(self)
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
	return { x = left, y = top }, { x = right, y = bottom }
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
local function beforedraw(self)
	self.texturebackup = self.texture
	self.texture, self.topleftuv, self.bottomrightuv = gettextureanduvsforcurrentframe(self)
end

--- Implements the afterdraw function to reset some modifications made before the rendering.
local function afterdraw(self)
	self.texture = self.texturebackup
	self.texturebackup = nil
end

local function configuremetatable(sprite)
	local mt = getmetatable(sprite)
	local originalindex = mt.__index
	local originalnewindex = mt.__newindex
	mt.__index = function(t, index)
		if index == "framescount" then return getframescount(t)
		else return originalindex(t, index) end
	end 
	mt.__newindex = function(t, index, value)
		if index == "framescount" then error "Field 'framescount' is read-only."
		else originalnewindex(t, index, value) end
	end
end

--- Creates a drawable that subdivide the texture in multiple frames. This division is calculated
-- with the columns and rows fields. To define witch cell of that subdivision should be
-- rendered, set the frame field. The returned table is a drawable table with a few fields more and
-- some values setted.
-- @field columns the columns count, it is 1 by default.
-- @field rows the rows count, it is 1 by default.
-- @field frame the current frame of the sprite, it is 1 (first) by default.
-- @field extensions list of extensions (tables with fields columns, rows and texture). If
-- defined, the sprite can use many images to represent the frames. It can be used if you have
-- so many frames that you extrapolates the max texture size allowed by the video hardware.
-- @field texturebackup internal field
-- @field framescount the total frames count, calculated using the columns and rows count. This is a
-- read-only field.
function vega.drawables.sprite(initialvalues)
	local sprite = vega.util.mix {
		vega.drawable {
			columns = 1,
			rows = 1,
			frame = 1,
			beforedraw = beforedraw,
			afterdraw = afterdraw
		},
		initialvalues
	}
	configuremetatable(sprite)
	return sprite
end
