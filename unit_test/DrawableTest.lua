local drawable = {}
local parent = {}

function suite_setup()
end

function setup()
	drawable = Drawable.new()
	parent = Drawable.new()
	assert_table(drawable, "Should create a table for the drawable.")
end

function test_drawable_fields()
	assert_equal(Vector2.zero, drawable.position, "position is not the expected.")
	assert_equal(Vector2.one, drawable.size, "size is not the expected.")
	assert_equal(Vector2.zero, drawable.origin, "origin is not the expected.")
	assert_equal(Vector2.one, drawable.scale, "scale is not the expected.")
	assert_equal(Vector2.zero, drawable.childrenorigin, "childrenorigin is not the expected.")
	assert_equal(0, drawable.rotation, "rotation is not the expected.")
	assert_equal(1, drawable.visibility, "visibility is not the expected.")
	assert_equal(false, drawable.isrelativex, "isrelativex is not the expected.")
	assert_equal(false, drawable.isrelativey, "isrelativey is not the expected.")
	assert_equal(false, drawable.isrelativewidth, "isrelativewidth is not the expected.")
	assert_equal(false, drawable.isrelativeheigth, "isrelativeheigth is not the expected.")
	assert_equal(false, drawable.isrelativeoriginx, "isrelativeoriginx is not the expected.")
	assert_equal(false, drawable.isrelativeoriginy, "isrelativeoriginy is not the expected.")
	assert_table(drawable.children, "children should be a table.")
	assert_equal(0, #drawable.children, "children size is not the expected.")
end

function test_create_new_drawable_with_an_existing_object()
	-- when:
	local newdrawable = Drawable.new { position = Vector2.new(10, 20), visibility = 0.5 }
	
	-- then:
	assert_table(newdrawable, "Should create a table for the drawable.")
	assert_equal(10, newdrawable.position.x, "The position.x is not the expected.")
	assert_equal(20, newdrawable.position.y, "The position.y is not the expected.")
	assert_equal(0.5, newdrawable.visibility, "The visibility is not the expected.")
	assert_equal(Vector2.one, newdrawable.scale, "The scale is not the expected (should be the default Drawable value).")
end

function test_should_return_position_relative_to_parent_size()
	-- given:
	parent:addchild(drawable)
	parent.size = Vector2.new(50, 200)
	drawable.position = Vector2.new(5, 100)
	
	-- when:
	local relativeposition = drawable:getrelativeposition()
	
	-- then:
	assert_equal(Vector2.new(0.1, 0.5), relativeposition, "The relative position is not the expected.")
end

function test_should_relative_position_be_equal_to_position_when_there_is_no_parent()
	-- given:
	drawable.position = Vector2.new(5, 100)
	
	-- when:
	local relativeposition = drawable:getrelativeposition()
	
	-- then:
	assert_equal(Vector2.new(5, 100), relativeposition, "The relative position is not the expected.")
end

function test_should_return_size_relative_to_parent_size()
	-- given:
	parent:addchild(drawable)
	parent.size = Vector2.new(50, 200)
	drawable.size = Vector2.new(5, 100)
	
	-- when:
	local relativesize = drawable:getrelativesize()
	
	-- then:
	assert_equal(Vector2.new(0.1, 0.5), relativesize, "The relative size is not the expected.")
end

function test_should_relative_size_be_equal_to_size_when_there_is_no_parent()
	-- given:
	drawable.size = Vector2.new(5, 100)
	
	-- when:
	local relativesize = drawable:getrelativesize()
	
	-- then:
	assert_equal(Vector2.new(5, 100), relativesize, "The relative size is not the expected.")
end

function test_should_return_origin_relative_to_size()
	-- given:
	drawable.size = Vector2.new(50, 200)
	drawable.origin = Vector2.new(5, 100)
	
	-- when:
	local relativeorigin = drawable:getrelativeorigin()
	
	-- then:
	assert_equal(Vector2.new(0.1, 0.5), relativeorigin, "The relative origin is not the expected.")
end

function test_should_calculate_absolute_position_when_x_is_relative()
	-- given:
	parent:addchild(drawable)
	parent.size = Vector2.new(50, 200)
	drawable.position = Vector2.new(0.1, 0.5)
	drawable.isrelativex = true
	drawable.isrelativey = false
	
	-- when:
	local absoluteposition = drawable:getabsoluteposition()
	
	-- then:
	assert_equal(Vector2.new(5, 0.5), absoluteposition, "The absolute position is not the expected.")
end

function test_should_calculate_absolute_position_when_y_is_relative()
	-- given:
	parent:addchild(drawable)
	parent.size = Vector2.new(50, 200)
	drawable.position = Vector2.new(0.1, 0.5)
	drawable.isrelativex = false
	drawable.isrelativey = true
	
	-- when:
	local absoluteposition = drawable:getabsoluteposition()
	
	-- then:
	assert_equal(Vector2.new(0.1, 100), absoluteposition, "The absolute position is not the expected.")
end

function test_should_absolute_position_be_equal_to_position_when_there_is_no_parent()
	-- given:
	drawable.position = Vector2.new(0.1, 0.5)
	drawable.isrelativex = true
	drawable.isrelativey = true
	
	-- when:
	local absoluteposition = drawable:getabsoluteposition()
	
	-- then:
	assert_equal(Vector2.new(0.1, 0.5), absoluteposition, "The absolute position is not the expected.")
end

function test_should_calculate_absolute_size_when_width_is_relative()
	-- given:
	parent:addchild(drawable)
	parent.size = Vector2.new(50, 200)
	drawable.size = Vector2.new(0.1, 0.5)
	drawable.isrelativewidth = true
	drawable.isrelativeheigth = false
	
	-- when:
	local absolutesize = drawable:getabsolutesize()
	
	-- then:
	assert_equal(Vector2.new(5, 0.5), absolutesize, "The absolute size is not the expected.")
end

function test_should_calculate_absolute_size_when_heigth_is_relative()
	-- given:
	parent:addchild(drawable)
	parent.size = Vector2.new(50, 200)
	drawable.size = Vector2.new(0.1, 0.5)
	drawable.isrelativewidth = false
	drawable.isrelativeheigth = true
	
	-- when:
	local absolutesize = drawable:getabsolutesize()
	
	-- then:
	assert_equal(Vector2.new(0.1, 100), absolutesize, "The absolute size is not the expected.")
end

function test_should_absolute_size_be_equal_to_size_when_there_is_no_parent()
	-- given:
	drawable.size = Vector2.new(0.1, 0.5)
	drawable.isrelativewidth = true
	drawable.isrelativeheigth = true
	
	-- when:
	local absolutesize = drawable:getabsolutesize()
	
	-- then:
	assert_equal(Vector2.new(0.1, 0.5), absolutesize, "The absolute size is not the expected.")
end

function test_should_calculate_absolute_origin_when_originx_is_relative()
	-- given:
	drawable.size = Vector2.new(50, 100)
	drawable.origin = Vector2.new(0.1, 0.5)
	drawable.isrelativeoriginx = true
	drawable.isrelativeoriginy = false
	
	-- when:
	local absoluteorigin	= drawable:getabsoluteorigin()
	
	-- then:
	assert_equal(Vector2.new(5, 0.5), absoluteorigin, "The absolute origin is not the expected.")
end

function test_should_calculate_absolute_origin_when_originy_is_relative()
	-- given:
	drawable.size = Vector2.new(50, 100)
	drawable.origin = Vector2.new(0.1, 0.5)
	drawable.isrelativeoriginx = false
	drawable.isrelativeoriginy = true
	
	-- when:
	local absoluteorigin = drawable:getabsoluteorigin()
	
	-- then:
	assert_equal(Vector2.new(0.1, 50), absoluteorigin, "The absolute origin is not the expected.")
end





















