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

function test_should_add_child()
	-- given:
	local child1 = Drawable.new()
	local child2 = Drawable.new()
	local child3 = Drawable.new()
	
	-- when:
	drawable:addchild(child1)
	drawable:addchild(child2)
	drawable:addchild(child3)
	
	-- then:
	assert_equal(3, #drawable.children, "Drawable should have 3 children.")
	assert_equal(child1, drawable.children[1], "The first child is not the expected.")
	assert_equal(child2, drawable.children[2], "The second child is not the expected.")
	assert_equal(child3, drawable.children[3], "The third child is not the expected.")
	assert_equal(drawable, child1.parent, "Should set the drawable as parent of the first child.")
	assert_equal(drawable, child2.parent, "Should set the drawable as parent of the second child.")
	assert_equal(drawable, child3.parent, "Should set the drawable as parent of the third child.")
end

function test_should_add_child_at_index()
	-- given:
	local child1 = Drawable.new()
	local child2 = Drawable.new()
	local child3 = Drawable.new()
	drawable:addchild(child1)
	drawable:addchild(child2)
	
	-- when:
	drawable:addchild(child3, 2)
	
	-- then:
	assert_equal(3, #drawable.children, "Drawable should have 3 children.")
	assert_equal(child1, drawable.children[1], "The first child is not the expected.")
	assert_equal(child3, drawable.children[2], "The second child is not the expected, it should be the child added to the index 2.")
	assert_equal(child2, drawable.children[3], "The third child is not the expected.")
end

function test_should_not_add_child_if_it_is_already_a_child_of_the_drawable()
	-- given:
	local child = Drawable.new()
	drawable:addchild(child)
	
	-- when:
	drawable:addchild(child)
	
	-- then:
	assert_equal(1, #drawable.children, "Drawable should have just one child.")
	assert_equal(child, drawable.children[1], "The child is not the expected.")
end

function test_should_add_child_at_end_when_index_is_greater_than_children_count()
	-- given:
	local child1 = Drawable.new()
	local child2 = Drawable.new()
	local child3 = Drawable.new()
	drawable:addchild(child1)
	drawable:addchild(child2)
	
	-- when:
	drawable:addchild(child3, 10)
	
	-- then:
	assert_equal(3, #drawable.children, "Drawable should have 3 children.")
	assert_equal(child1, drawable.children[1], "The first child is not the expected.")
	assert_equal(child2, drawable.children[2], "The second child is not the expected.")
	assert_equal(child3, drawable.children[3], "The third child is not the expected.")
end

function test_should_add_child_at_begin_when_index_is_less_than_zero()
	-- given:
	local child1 = Drawable.new()
	local child2 = Drawable.new()
	local child3 = Drawable.new()
	drawable:addchild(child1)
	drawable:addchild(child2)
	
	-- when:
	drawable:addchild(child3, -1)
	
	-- then:
	assert_equal(3, #drawable.children, "Drawable should have 3 children.")
	assert_equal(child3, drawable.children[1], "The first child is not the expected.")
	assert_equal(child1, drawable.children[2], "The second child is not the expected.")
	assert_equal(child2, drawable.children[3], "The third child is not the expected.")
end

function test_should_throw_error_when_child_is_not_a_table()
	-- when:
	local status, err = pcall(drawable.addchild, drawable, 1)
	
	-- then:
	assert_false(status, "Should throw an error.")
	assert_true(string.match(err, "The child argument of addchild function must be a table."), "Error message is not the expected.")
end

function test_should_throw_error_when_index_is_not_a_number()
	-- when:
	local status, err = pcall(drawable.addchild, drawable, {}, "str")
	
	-- then:
	assert_false(status, "Should throw an error.")
	assert_true(string.match(err, "The index argument of addchild function must be a number."), "Error message is not the expected.")
end

function test_should_remove_from_old_parent_when_add_child()
	-- given:
	local oldparent = Drawable.new()
	local child = Drawable.new()
	oldparent:addchild(child)
	
	-- when:
	drawable:addchild(child)
	
	-- then:
	assert_equal(drawable, child.parent, "The child should have a new parent.")
	assert_equal(0, #oldparent.children, "The old parent should not have the old child anymore.")
	assert_equal(1, #drawable.children, "The new parent should have one new child.")
	assert_equal(child, drawable.children[1], "The child of the new parent is not the expected.")
end

function test_should_remove_child()
	-- given:
	local child1 = Drawable.new()
	local child2 = Drawable.new()
	local child3 = Drawable.new()
	drawable:addchild(child1)
	drawable:addchild(child2)
	drawable:addchild(child3)
	
	-- when:
	drawable:removechild(child2)
	
	-- then:
	assert_equal(2, #drawable.children, "The drawable should have only 2 children.")
	assert_equal(drawable, child1.parent, "The parent of child1 is not the expected.")
	assert_equal(drawable, child3.parent, "The parent of child3 is not the expected.")
	assert_nil(child2.parent, "The parent of the removed child should be nil.")
	assert_equal(child1, drawable.children[1], "The first child is not the expected.")
	assert_equal(child3, drawable.children[2], "The second child is not the expected.")
end

function test_should_set_children_list()
	-- given:
	local child1 = Drawable.new()
	local child2 = Drawable.new()
	local child3 = Drawable.new()
	local children = { child1, child2, child3 }

	-- when:
	drawable:setchildren(children)
	
	-- then:
	assert_equal(3, #drawable.children, "The drawable should have 3 children.")
	assert_equal(child1, drawable.children[1], "The first child is not the expected.")
	assert_equal(child2, drawable.children[2], "The second child is not the expected.")
	assert_equal(child3, drawable.children[3], "The third child is not the expected.")
	assert_equal(drawable, child1.parent, "Should set the parent of the first child.")
	assert_equal(drawable, child2.parent, "Should set the parent of the second child.")
	assert_equal(drawable, child2.parent, "Should set the parent of the third child.")
end

function test_should_remove_from_old_parents_when_set_children_list()
	-- given:
	local oldchild1 = Drawable.new()
	local oldchild2 = Drawable.new()
	drawable:addchild(oldchild1)
	drawable:addchild(oldchild2)
	
	local child1 = Drawable.new()
	local child2 = Drawable.new()
	local child3 = Drawable.new()
	local children = { child1, child2, child3 }

	-- when:
	drawable:setchildren(children)
	
	-- then:
	assert_equal(3, #drawable.children, "The drawable should have 3 children.")
	assert_equal(child1, drawable.children[1], "The first child is not the expected.")
	assert_equal(child2, drawable.children[2], "The second child is not the expected.")
	assert_equal(child3, drawable.children[3], "The third child is not the expected.")
	assert_equal(drawable, child1.parent, "Should set the parent of the first child.")
	assert_equal(drawable, child2.parent, "Should set the parent of the second child.")
	assert_equal(drawable, child2.parent, "Should set the parent of the third child.")
	assert_nil(oldchild1.parent, "The first old child should not have a parent anymore.")
	assert_nil(oldchild2.parent, "The second old child should not have a parent anymore.")
end









