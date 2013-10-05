require "vegatable"
require "util"
require "animations.curves"

local metatable = {}

function metatable.__newindex(t, index, value)
	if index == "x" or index == "y" then
		error("The animation field "..index.." is read-only.")
	end
	rawset(t, index, value)
end

function metatable.__index(t, index)
	if index == "x" then
		if t.frame >= t.length then
			return 1
		else
			return (t.frame - 1) / (t.length - 1)
		end
	elseif index == "y" then
		return t.curvefunction(t.x)
	end
end

local function init(self)
	if self.from == nil then self.from = self.on[self.what] end
	if self.to == nil then self.to = self.on[self.what] end
end

local function update(self)
	self:updateframe()
	if self.frame >= self.length then self.finished = true end
	if self.frame < self.length then self.frame = self.frame + 1 end
end

local function updateframe(self)
	self.on[self.what] = self.from + ((self.to - self.from) * self.y)
end

--- Creates an animation. If added to a scene as controller, it changes the field value
-- of a given object at each frame. The value is changed from an initial value to a final value.
-- @field frame the current frame of the animation. When added to a scene as a controller,
-- the value of the frame is incremented after each frame. It is initiated with 1.
-- @field length the length of the animation, in frames.
-- @field what the name of the field to animate.
-- @field on the table that contains the field to animate.
-- @field from the initial value of the field. If nil, then the current value is used.
-- @field to the final value of the field. If nil, then the current value is used.
-- @field x a value between 0 and 1. 0 is returned when the animation is in the first frame, 1 is
-- returned when the animation is in the last frame. This value is read-only, an error is thrown
-- if a value is setted.
-- @field y a value between 0 and 1. It is automatically calculated by the curve function and it is
-- read-only, so an error is thronw if a value is setted.
-- @field curvefunction a function that receives x and must return a y. It defines the how the
-- initialvalue and finalvalue are interpolated. This field is initiated with the function
-- vega.animations.curves.linear, so the interpolation is linear.
function vega.animation(initialvalues)
	local animation = {
		init = init,
		update = update,
		updateframe = updateframe,
		curvefunction = vega.animations.curves.linear,
		frame = 1,
		length = 1,
	}
	setmetatable(animation, metatable)
	vega.util.copyvaluesintotable(initialvalues, animation)
	return animation
end
