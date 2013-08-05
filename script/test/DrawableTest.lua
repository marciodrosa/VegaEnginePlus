local drawabletest = {}
local drawable = {}
local parent = {}

function drawabletest.setup()
	drawable = vega.drawable()
	parent = vega.drawable()
	assert_table(drawable, "Should create a table for the drawable.")
end

function drawabletest.test_drawable_fields()
	assert_equal(vega.Vector2.zero, drawable.position, "position is not the expected.")
	assert_equal(vega.Vector2.one, drawable.size, "size is not the expected.")
	assert_equal(vega.Vector2.zero, drawable.origin, "origin is not the expected.")
	assert_equal(vega.Vector2.one, drawable.scale, "scale is not the expected.")
	assert_equal(vega.Vector2.zero, drawable.childrenorigin, "childrenorigin is not the expected.")
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
	assert_nil(drawable.parent, "parent should be nil.")
	assert_nil(drawable.background, "background should be nil.")
	assert_nil(drawable.color, "color should be nil.")
	assert_nil(drawable.texture, "texture should be nil.")
	assert_nil(drawable.topleftuv, "topleftuv should be nil.")
	assert_nil(drawable.bottomrightuv, "bottomrightuv should be nil.")
	assert_nil(drawable.texturemodeu, "texturemodeu should be nil.")
	assert_nil(drawable.texturemodev, "texturemodev should be nil.")
	assert_nil(drawable.beforedraw, "beforedraw should be nil.")
	assert_nil(drawable.afterdraw, "afterdraw should be nil.")
end

function drawabletest.test_should_return_position_relative_to_parent_size()
	-- given:
	parent.children.insert(drawable)
	parent.size = vega.Vector2.new(50, 200)
	drawable.position = vega.Vector2.new(5, 100)
	
	-- when:
	local relativeposition = drawable:getrelativeposition()
	
	-- then:
	assert_equal(vega.Vector2.new(0.1, 0.5), relativeposition, "The relative position is not the expected.")
end

function drawabletest.test_should_relative_position_be_equal_to_position_when_there_is_no_parent()
	-- given:
	drawable.position = vega.Vector2.new(5, 100)
	
	-- when:
	local relativeposition = drawable:getrelativeposition()
	
	-- then:
	assert_equal(vega.Vector2.new(5, 100), relativeposition, "The relative position is not the expected.")
end

function drawabletest.test_should_return_size_relative_to_parent_size()
	-- given:
	parent.children.insert(drawable)
	parent.size = vega.Vector2.new(50, 200)
	drawable.size = vega.Vector2.new(5, 100)
	
	-- when:
	local relativesize = drawable:getrelativesize()
	
	-- then:
	assert_equal(vega.Vector2.new(0.1, 0.5), relativesize, "The relative size is not the expected.")
end

function drawabletest.test_should_relative_size_be_equal_to_size_when_there_is_no_parent()
	-- given:
	drawable.size = vega.Vector2.new(5, 100)
	
	-- when:
	local relativesize = drawable:getrelativesize()
	
	-- then:
	assert_equal(vega.Vector2.new(5, 100), relativesize, "The relative size is not the expected.")
end

function drawabletest.test_should_return_origin_relative_to_size()
	-- given:
	drawable.size = vega.Vector2.new(50, 200)
	drawable.origin = vega.Vector2.new(5, 100)
	
	-- when:
	local relativeorigin = drawable:getrelativeorigin()
	
	-- then:
	assert_equal(vega.Vector2.new(0.1, 0.5), relativeorigin, "The relative origin is not the expected.")
end

function drawabletest.test_should_calculate_absolute_position_when_x_is_relative()
	-- given:
	parent.children.insert(drawable)
	parent.size = vega.Vector2.new(50, 200)
	drawable.position = vega.Vector2.new(0.1, 0.5)
	drawable.isrelativex = true
	drawable.isrelativey = false
	
	-- when:
	local absoluteposition = drawable:getabsoluteposition()
	
	-- then:
	assert_equal(vega.Vector2.new(5, 0.5), absoluteposition, "The absolute position is not the expected.")
end

function drawabletest.test_should_calculate_absolute_position_when_y_is_relative()
	-- given:
	parent.children.insert(drawable)
	parent.size = vega.Vector2.new(50, 200)
	drawable.position = vega.Vector2.new(0.1, 0.5)
	drawable.isrelativex = false
	drawable.isrelativey = true
	
	-- when:
	local absoluteposition = drawable:getabsoluteposition()
	
	-- then:
	assert_equal(vega.Vector2.new(0.1, 100), absoluteposition, "The absolute position is not the expected.")
end

function drawabletest.test_should_absolute_position_be_equal_to_position_when_there_is_no_parent()
	-- given:
	drawable.position = vega.Vector2.new(0.1, 0.5)
	drawable.isrelativex = true
	drawable.isrelativey = true
	
	-- when:
	local absoluteposition = drawable:getabsoluteposition()
	
	-- then:
	assert_equal(vega.Vector2.new(0.1, 0.5), absoluteposition, "The absolute position is not the expected.")
end

function drawabletest.test_should_calculate_absolute_size_when_width_is_relative()
	-- given:
	parent.children.insert(drawable)
	parent.size = vega.Vector2.new(50, 200)
	drawable.size = vega.Vector2.new(0.1, 0.5)
	drawable.isrelativewidth = true
	drawable.isrelativeheigth = false
	
	-- when:
	local absolutesize = drawable:getabsolutesize()
	
	-- then:
	assert_equal(vega.Vector2.new(5, 0.5), absolutesize, "The absolute size is not the expected.")
end

function drawabletest.test_should_calculate_absolute_size_when_heigth_is_relative()
	-- given:
	parent.children.insert(drawable)
	parent.size = vega.Vector2.new(50, 200)
	drawable.size = vega.Vector2.new(0.1, 0.5)
	drawable.isrelativewidth = false
	drawable.isrelativeheigth = true
	
	-- when:
	local absolutesize = drawable:getabsolutesize()
	
	-- then:
	assert_equal(vega.Vector2.new(0.1, 100), absolutesize, "The absolute size is not the expected.")
end

function drawabletest.test_should_absolute_size_be_equal_to_size_when_there_is_no_parent()
	-- given:
	drawable.size = vega.Vector2.new(0.1, 0.5)
	drawable.isrelativewidth = true
	drawable.isrelativeheigth = true
	
	-- when:
	local absolutesize = drawable:getabsolutesize()
	
	-- then:
	assert_equal(vega.Vector2.new(0.1, 0.5), absolutesize, "The absolute size is not the expected.")
end

function drawabletest.test_should_calculate_absolute_origin_when_originx_is_relative()
	-- given:
	drawable.size = vega.Vector2.new(50, 100)
	drawable.origin = vega.Vector2.new(0.1, 0.5)
	drawable.isrelativeoriginx = true
	drawable.isrelativeoriginy = false
	
	-- when:
	local absoluteorigin = drawable:getabsoluteorigin()
	
	-- then:
	assert_equal(vega.Vector2.new(5, 0.5), absoluteorigin, "The absolute origin is not the expected.")
end

function drawabletest.test_should_calculate_absolute_origin_when_originy_is_relative()
	-- given:
	drawable.size = vega.Vector2.new(50, 100)
	drawable.origin = vega.Vector2.new(0.1, 0.5)
	drawable.isrelativeoriginx = false
	drawable.isrelativeoriginy = true
	
	-- when:
	local absoluteorigin = drawable:getabsoluteorigin()
	
	-- then:
	assert_equal(vega.Vector2.new(0.1, 50), absoluteorigin, "The absolute origin is not the expected.")
end

function drawabletest.test_should_add_child()
	-- given:
	local child1 = vega.drawable()
	local child2 = vega.drawable()
	local child3 = vega.drawable()
	
	-- when:
	drawable.children.insert(child1)
	drawable.children.insert(child2)
	drawable.children.insert(child3)
	
	-- then:
	assert_equal(3, #drawable.children, "Drawable should have 3 children.")
	assert_equal(child1, drawable.children[1], "The first child is not the expected.")
	assert_equal(child2, drawable.children[2], "The second child is not the expected.")
	assert_equal(child3, drawable.children[3], "The third child is not the expected.")
	assert_equal(drawable, child1.parent, "Should set the drawable as parent of the first child.")
	assert_equal(drawable, child2.parent, "Should set the drawable as parent of the second child.")
	assert_equal(drawable, child3.parent, "Should set the drawable as parent of the third child.")
end

function drawabletest.test_should_add_child_at_index()
	-- given:
	local child1 = vega.drawable()
	local child2 = vega.drawable()
	local child3 = vega.drawable()
	drawable.children.insert(child1)
	drawable.children.insert(child2)
	
	-- when:
	drawable.children.insert(child3, 2)

	-- then:
	assert_equal(3, #drawable.children, "Drawable should have 3 children.")
	assert_equal(child1, drawable.children[1], "The first child is not the expected.")
	assert_equal(child3, drawable.children[2], "The second child is not the expected, it should be the child added to the index 2.")
	assert_equal(child2, drawable.children[3], "The third child is not the expected.")
end

function drawabletest.test_should_not_add_child_if_it_is_already_a_child_of_the_drawable()
	-- given:
	local child = vega.drawable()
	drawable.children.insert(child)
	
	-- when:
	drawable.children.insert(child)
	
	-- then:
	assert_equal(1, #drawable.children, "Drawable should have just one child.")
	assert_equal(child, drawable.children[1], "The child is not the expected.")
end

function drawabletest.test_should_throw_error_when_child_is_not_a_table()
	-- when:
	local status, err = pcall(function() parent.children.insert(1) end)
	
	-- then:
	assert_false(status, "Should throw an error.")
	assert_true(string.match(err, "Only tables can be added into the children table."), "Error message is not the expected.")
end

function drawabletest.test_should_remove_from_old_parent_when_add_child()
	-- given:
	local oldparent = vega.drawable()
	local child = vega.drawable()
	oldparent.children.insert(child)
	
	-- when:
	drawable.children.insert(child)
	
	-- then:
	assert_equal(drawable, child.parent, "The child should have a new parent.")
	assert_equal(0, #oldparent.children, "The old parent should not have the old child anymore.")
	assert_equal(1, #drawable.children, "The new parent should have one new child.")
	assert_equal(child, drawable.children[1], "The child of the new parent is not the expected.")
end

function drawabletest.test_should_remove_child()
	-- given:
	local child1 = vega.drawable()
	local child2 = vega.drawable()
	local child3 = vega.drawable()
	drawable.children.insert(child1)
	drawable.children.insert(child2)
	drawable.children.insert(child3)
	
	-- when:
	drawable.children.remove(child2)
	
	-- then:
	assert_equal(2, #drawable.children, "The drawable should have only 2 children.")
	assert_equal(drawable, child1.parent, "The parent of child1 is not the expected.")
	assert_equal(drawable, child3.parent, "The parent of child3 is not the expected.")
	assert_nil(child2.parent, "The parent of the removed child should be nil.")
	assert_equal(child1, drawable.children[1], "The first child is not the expected.")
	assert_equal(child3, drawable.children[2], "The second child is not the expected.")
end

function drawabletest.test_should_set_children_list()
	-- given:
	local child1 = vega.drawable()
	local child2 = vega.drawable()
	local child3 = vega.drawable()

	-- when:
	drawable.children = { child1, child2, child3 }
	
	-- then:
	assert_equal(3, #drawable.children, "The drawable should have 3 children.")
	assert_equal(child1, drawable.children[1], "The first child is not the expected.")
	assert_equal(child2, drawable.children[2], "The second child is not the expected.")
	assert_equal(child3, drawable.children[3], "The third child is not the expected.")
	assert_equal(drawable, child1.parent, "Should set the parent of the first child.")
	assert_equal(drawable, child2.parent, "Should set the parent of the second child.")
	assert_equal(drawable, child2.parent, "Should set the parent of the third child.")
end

function drawabletest.test_should_remove_from_old_parents_when_set_children_list()
	-- given:
	local oldchild1 = vega.drawable()
	local oldchild2 = vega.drawable()
	drawable.children.insert(oldchild1)
	drawable.children.insert(oldchild2)
	
	local child1 = vega.drawable()
	local child2 = vega.drawable()
	local child3 = vega.drawable()

	-- when:
	drawable.children = { child1, child2, child3 }
	
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

function drawabletest.test_should_set_background()
	-- given:
	local background = vega.drawable()
	
	-- when:
	drawable.background = background
	
	-- then:
	assert_equal(background, drawable.background, "The background is not the expected.")
	assert_equal(1, #drawable.children, "Should have 1 child, because the background should be added as child.")
	assert_equal(background, drawable.children[1], "The child should be the background.")
end

function drawabletest.test_not_remove_old_background_from_children()
	-- given:
	local oldbackground = vega.drawable()
	drawable.background = oldbackground
	
	-- when:
	local newbackground = vega.drawable()
	drawable.background = newbackground
	
	-- then:
	assert_equal(newbackground, drawable.background, "The background is not the expected.")
	assert_equal(2, #drawable.children, "Should have 2 children, because the background should be added as child and the old background should not be removed.")
	assert_equal(oldbackground, drawable.children[1], "The first child should be the old background.")
	assert_equal(newbackground, drawable.children[2], "The second child should be the new background.")
end

return drawabletest