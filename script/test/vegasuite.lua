package.path = package.path..";../?;../?.lua;../vega/?.lua"

require "vega"
require "vegaunit"

vegaunit.addsuite("cameratest")
vegaunit.addsuite("collisiontest")
vegaunit.addsuite("colortest")
vegaunit.addsuite("contenttest")
vegaunit.addsuite("contexttest")
vegaunit.addsuite("drawabletest")
vegaunit.addsuite("drawables.texttest")
vegaunit.addsuite("inputtest")
vegaunit.addsuite("layertest")
vegaunit.addsuite("listtest")
vegaunit.addsuite("mainlooptest")
vegaunit.addsuite("matrixtest")
vegaunit.addsuite("mousetest")
vegaunit.addsuite("scenetest")
vegaunit.addsuite("spaceconvertertest")
vegaunit.addsuite("spritedrawabletest")
vegaunit.addsuite("transformtest")
vegaunit.addsuite("utiltest")
vegaunit.addsuite("vectortest")

vegaunit.run()