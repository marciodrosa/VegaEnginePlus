package.path = package.path..";../vega/?.lua;lunatest/?;lunatest/?.lua"

require "vega"
require "lunatest"

lunatest.suite("colortest")
lunatest.suite("contentmanagertest")
lunatest.suite("contexttest")
lunatest.suite("drawabletest")
lunatest.suite("inputtest")
lunatest.suite("scenetest")
lunatest.suite("spritedrawabletest")
lunatest.suite("touchpointtest")
lunatest.suite("vector2test")
lunatest.suite("viewporttest")

lunatest.run()