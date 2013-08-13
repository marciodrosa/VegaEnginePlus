package.path = package.path..";../?;../?.lua;../vega/?.lua;lunatest/?;lunatest/?.lua"

require "vega"
require "vegaunit"

vegaunit.addsuite("colortest")
vegaunit.addsuite("contentmanagertest")
vegaunit.addsuite("contexttest")
vegaunit.addsuite("coordinatestest")
vegaunit.addsuite("drawabletest")
vegaunit.addsuite("inputtest")
vegaunit.addsuite("listtest")
vegaunit.addsuite("scenetest")
vegaunit.addsuite("spritedrawabletest")
vegaunit.addsuite("touchpointtest")
vegaunit.addsuite("utiltest")
vegaunit.addsuite("vector2test")
vegaunit.addsuite("viewporttest")

vegaunit.run()