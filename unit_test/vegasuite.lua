package.path = package.path..";../vega_lua/?.lua;lunatest/?;lunatest/?.lua"

require "VegaEngine"
require "lunatest"

lunatest.suite("Vector2Test")

lunatest.run()