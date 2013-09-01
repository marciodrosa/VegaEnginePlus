package.path = package.path..";../?;../?.lua;../vega/?.lua;lunatest/?;lunatest/?.lua"

require "vega"
require "vegaunit"

vegaunit.addsuite("cameratest")
vegaunit.addsuite("colortest")
vegaunit.addsuite("contenttest")
vegaunit.addsuite("contexttest")
vegaunit.addsuite("coordinatestest")
vegaunit.addsuite("drawabletest")
vegaunit.addsuite("inputtest")
vegaunit.addsuite("layertest")
vegaunit.addsuite("listtest")
vegaunit.addsuite("mainlooptest")
vegaunit.addsuite("matrixtest")
vegaunit.addsuite("mousetest")
vegaunit.addsuite("scenetest")
vegaunit.addsuite("spritedrawabletest")
vegaunit.addsuite("touchpointtest")
vegaunit.addsuite("utiltest")
vegaunit.addsuite("vector2test")

vegaunit.run()