package.path = package.path..";../vega_lua/?.lua;lunatest/?;lunatest/?.lua"

require "vega"
require "lunatest"

lunatest.suite("ColorTest")
lunatest.suite("ContentManagerTest")
lunatest.suite("ContextTest")
lunatest.suite("DrawableTest")
lunatest.suite("SceneTest")
lunatest.suite("SpriteDrawableTest")
lunatest.suite("Vector2Test")
lunatest.suite("ViewportTest")

lunatest.run()