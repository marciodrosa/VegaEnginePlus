require "vegatable"
require "util"

local function gettrackposition(animation)
	return animation.trackposition or 1
end

local function mustupdateanimation(self, animation)
	local trackposition = gettrackposition(animation)
	return self.frame >= trackposition and self.frame < (animation.length + trackposition)
end

local function getframetoupdateanimation(self, animation)
	return self.frame - gettrackposition(animation) + 1
end

local function iscurrentiterationreverse(self)
	return self.pingpong and (self.currentiteration % 2) == 0
end

local function islastframeofiteration(self)
	local islastframe
	if iscurrentiterationreverse(self) then
		islastframe = self.frame <= 1
	else
		if self.length == nil then
			local allanimationsfinished = true
			for i, animation in ipairs(self.animations) do
				if gettrackposition(animation) + animation.length - 1 > self.frame then
					allanimationsfinished = false
					break
				end
			end
			islastframe = allanimationsfinished
		else
			islastframe = self.frame >= self.length
		end
	end
	return islastframe
end

local function mustfinishanimationaftercurrentiteration(self)
	return self.iterations ~= 0 and self.currentiteration + 1 > self.iterations 
end

--- Updates the controller.
local function update(self, context)
	for i, animation in ipairs(self.animations) do
		if mustupdateanimation(self, animation) then
			if not animation.initiated then
				animation.initiated = true
				if animation.init ~= nil then
					animation:init(context)
				end
			end
			animation.frame = getframetoupdateanimation(self, animation)
			animation:updateframe()
		end
	end
	if islastframeofiteration(self) then
		if mustfinishanimationaftercurrentiteration(self) then
			self.finished = true
		else
			self.currentiteration = self.currentiteration + 1
			if not iscurrentiterationreverse(self) then
				self.frame = 1
			end
		end
	else
		if iscurrentiterationreverse(self) then
			self.frame = self.frame - 1
		else
			self.frame = self.frame + 1
		end
	end
end

--- Adds this animation track as a controller to the current scene of the current context.
local function execute(self, context)
	context.scene.controllers.insert(self)
end

--- Creates an animation track. An animation track is a table that contains one or more
-- animations (created by vega.animation function) attached to it. Instead of add an animation
-- as a controller to a scene, attach this animation to an animation track and, then, add the
-- animation track to the scene as a controller. This can be better because the animation track
-- can handle the animations, rewind, manage loops, etc. Note: the animations attached to the
-- track must have the field trackposition setted. If not, the default position 1 is used.
-- @field iterations the amount of times this track executes. It can be used to repeat the
-- execution of the animations n times. For infinite loop, set to 0. The default value is 1,
-- witch means the animations will execute one time, and then this controller will be setted as
-- finished.
-- @field currentiteration the current iteration of the execution. Starts with 1. While this
-- controller is executing, this property is automatically updated.
-- @field pingpong if true, each iteration will have the reverse direction of the previous iteration.
-- So, if the current iteration is playing as usual, the next one will play from last frame to the
-- first one. Default value is false.
-- @field frame the current frame of the track, starts with 0 and it's automatically increased on
-- each update of the controller.
-- @field length the size of the track. If not nil, then each iteration will be finished after updates
-- all frames defined by this field. Otherwise, the iteration will be finished after update all frames
-- of all animations. This field is nil by default.
-- @field animations the list of animations attached to this track. This is a simple Lua table, not a
-- list created with vega.list.
function vega.animationtrack(initialvalues)
	local animationtrack = {
		iterations = 1,
		currentiteration = 1,
		pingpong = false,
		frame = 1,
		animations = {},
		update = update,
		execute = execute
	}
	return vega.util.copyvaluesintotable(initialvalues, animationtrack)
end