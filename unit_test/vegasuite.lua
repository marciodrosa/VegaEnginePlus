package.path = package.path..";../vega_lua/?.lua;lunatest/?;lunatest/?.lua"

require "VegaEngine"
require "lunatest"

lunatest.suite("ColorTest")
lunatest.suite("ContextTest")
lunatest.suite("DrawableTest")
lunatest.suite("RectangleDrawableTest")
lunatest.suite("Vector2Test")

lunatest.run()