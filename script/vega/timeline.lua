require "vegatable"
require "util"

local function findactionsforcurrentframe(self)
	local frameobject = self.actions[self.frame]
	if frameobject ~= nil then
		if type(frameobject) == "function" then
			return { frameobject }
		elseif type(frameobject) == "table" then
			if #frameobject > 0 then
				return frameobject
			else
				return { frameobject }
			end
		end
	else
		return {}
	end
end

local function verifyongoingactions(ongoingactions)
	local i = 1
	while true do
		if i > #ongoingactions then break end
		if ongoingactions[i].finished then
			table.remove(ongoingactions, i)
		else
			i = i + 1
		end
	end
end

local function thereisactionsexecuting(ongoingactions)
	return #ongoingactions > 0
end

local function thereismoreactionsinfuture(self)
	for k, v in pairs(self.actions) do
		if k > self.frame then
			return true
		end
	end
	return false
end

local function update(self, context, ongoingactions)
	local actionsforcurrentframe = findactionsforcurrentframe(self)
	for i, action in ipairs(actionsforcurrentframe) do
		if type(action) == "function" then
			action(context)
		elseif type(action) == "table" then
			action:execute(context)
			if not action.finished then
				table.insert(ongoingactions, action)
			end
		end
	end
	verifyongoingactions(ongoingactions)
	if not thereisactionsexecuting(ongoingactions) and not thereismoreactionsinfuture(self) then
		self.finished = true
	else
		self.frame = self.frame + 1
	end
end

--- Creates and returns a timeline table. It can be attached to a scene as a controller.
-- It executes actions (functions or tables which a function named "execute") attached to
-- a given frame of the timeline. The timeline controller is finished when there is no more
-- actions to be executed and all executed actions were finished (contains the field "finished"
-- set to true, if the action is a table).
-- @param initialvalues the initial values of the new table.
-- @field frame the current frame. It starts with 1 and it's increased at each update.
-- @field actions table with the actions. Each key must be the frame (number) when the action
-- should execute. Each key should be a function (which receives the context as parameter),
-- or a table with a function called execute (which receives self and the context as parameters),
-- or a list of table/functions. If it is a table, the field "finished" should be setted as true
-- when the execution finishes, to tell the timeline the action is finished.
function vega.timeline(initialvalues)
	local ongoingactions = {}
	local timeline = {
		frame = 1,
		actions = {},
		update = function(self, context)
			update(self, context, ongoingactions)
		end
	}
	return vega.util.copyvaluesintotable(initialvalues, timeline)
end
