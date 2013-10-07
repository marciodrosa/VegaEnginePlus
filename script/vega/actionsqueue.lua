require "vegatable"

local function update(self, context, privatedata)
	while privatedata.iterator <= #self.actions do
		local action = self.actions[privatedata.iterator]
		if action ~= privatedata.lastexecutedaction then
			if type(action) == "function" then
				action(context)
			elseif type(action) == "table" then
				action:execute(context)
			end
			privatedata.lastexecutedaction = action
		end
		if type(action) == "table" and not action.finished then
			break
		else
			privatedata.iterator = privatedata.iterator + 1
		end
	end
	if privatedata.iterator > #self.actions then
		self.finished = true
	end
end

--- Creates and returns a controller that executes a queue of actions.
-- When attached to a scene, each action is executed. When an action
-- has a duration of many frames, the next action of the queue is not
-- executed until the previous one is not finished. An action can be a
-- function that receives the context as parameter (in this case, the
-- action does'nt have a duration) or a table with an "execute(self, context)"
-- function (in this case, the actions is considered finished when it has
-- the field "finished" set to true).
--
-- This controller is finished after all actions were finished.
-- 
-- @param actions a list of actions to be attached to this queue. If nil, a new
-- list is setted in the table.
-- @field actions the attached actions.
function vega.actionsqueue(actions)
	local privatedata = {
		iterator = 1,
	}
	return {
		actions = actions or {},
		update = function(self, context)
			update(self, context, privatedata)
		end
	}
end