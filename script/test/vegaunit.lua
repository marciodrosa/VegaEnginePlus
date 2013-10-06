
vegaunit = {}

local suites = {}
local fails = {}
local testscount = 0

local function printseparator()
	print "--------------------------------------------"
end

local function printfails()
	for k, v in pairs(failures) do
		printseparator()
		print(v)
	end
end

local function printstatistics()
	printseparator()
	print("Finish running "..testscount.." tests with "..#failures.." failures.")
end

local function runsuitefunction(suite, funcname, suitename)
	local ok, err = pcall(suite[funcname] or function() end)
	if not ok then
		table.insert(failures, "FAILED: "..suitename.."."..funcname..": "..err)
	end
	return ok
end

local function runsuite(suite, suitename)
	print("Running "..suitename)
	for k, v in pairs(suite) do
		if string.sub(k, 1, 4) == "test" then
			io.write(".")
			local setupok = runsuitefunction(suite, "setup", suitename)
			if (setupok) then
				runsuitefunction(suite, k, suitename)
			end
			runsuitefunction(suite, "teardown", suitename)
			testscount = testscount + 1
		end
	end
	io.write("\n")
end

local function concatmessages(m1, m2)
	local finalmessage = m1 or ""
	if m2 then
		if string.len(finalmessage) > 0 then finalmessage = finalmessage.." " end
		finalmessage = finalmessage..m2
	end
	return finalmessage
end

function vegaunit.addsuite(name)
	table.insert(suites, name)
end

function vegaunit.run()
	failures = {}
	testscount = 0
	for i, suitename in ipairs(suites) do
		local suite = require(suitename)
		runsuite(suite, suitename)
	end
	printfails()
	printstatistics()
end

function fail(message)
	error(debug.traceback(message or "", 2))
end

function assert_true(expression, message)
	if not expression then
		fail(concatmessages("Expected true, but was false.", message))
	end
end

function assert_false(expression, message)
	if expression then
		fail(concatmessages("Expected false, but was true.", message))
	end
end

function assert_equal(expected, actual, deltaormessage, message)
	local delta = deltaormessage
	if message == nil then delta = nil end
	message = message or deltaormessage
	local failed
	if delta then
		failed = not ((actual <= (expected + delta)) and (actual > (expected - delta)))
	else
		failed = not (expected == actual)
	end
	if failed then
		fail(concatmessages("'"..tostring(actual or "nil").."' is not equal to '"..tostring(expected or "nil").."'.", message))
	end
end

function assert_not_equal(expected, actual, message)
	local failed = not (expected ~= actual)
	if failed then
		fail(concatmessages("'"..tostring(actual or "nil").."' is not different from '"..tostring(expected or "nil").."'.", message))
	end
end

local function assert_type(expectedtype, value, message)
	if type(value) ~= expectedtype then
		fail(concatmessages("Value is not a "..expectedtype, message))
	end
end

function assert_table(actual, message)
	assert_type("table", actual, message)
end

function assert_function(actual, message)
	assert_type("function", actual, message)
end

function assert_error(expectederror, func, message)
	local ok, err = pcall(func)
	if ok then
		fail(concatmessages("Expected error '"..expectederror.."'' was not thrown."), message)
	elseif string.find(err, expectederror, 1, true) == nil then
		fail(concatmessages("Expected error '"..expectederror.."'' is not equal to '"..err.."'."), message)
	end
end

function assert_nil(expression, message)
	if expression ~= nil then
		fail(concatmessages("Value is not nil.", message))
	end
end

function assert_not_nil(expression, message)
	if expression == nil then
		fail(concatmessages("Value is nil.", message))
	end
end
