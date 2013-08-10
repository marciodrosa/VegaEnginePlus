local drawabletest = {}
local drawable = {}
local parent = {}

function drawabletest.setup()
	drawable = vega.drawable()
	parent = vega.drawable()
	assert_table(drawable, "Should create a table for the drawable.")
end

function drawabletest.test_drawable_fields()
	assert_equal(0, drawable.position.x, "position.x is not the expected.")
	assert_equal(0, drawable.position.y, "position.y is not the expected.")
	assert_equal(1, drawable.size.x, "size.x is not the expected.")
	assert_equal(1, drawable.size.y, "size.y is not the expected.")
	assert_equal(0, drawable.origin.x, "origin.x is not the expected.")
	assert_equal(0, drawable.origin.y, "origin.y is not the expected.")
	assert_equal(0, drawable.childrenorigin.x, "childrenorigin.x is not the expected.")
	assert_equal(0, drawable.childrenorigin.y, "childrenorigin.y is not the expected.")
	assert_equal(1, drawable.scale.x, "scale.x is not the expected.")
	assert_equal(1, drawable.scale.y, "scale.y is not the expected.")
	assert_equal(0, drawable.rotation, "rotation is not the expected.")
	assert_equal(1, drawable.visibility, "visibility is not the expected.")
	assert_equal(false, drawable.position.keeprelativex, "position.keeprelativex is not the expected.")
	assert_equal(false, drawable.position.keeprelativey, "position.keeprelativey is not the expected.")
	assert_equal(false, drawable.size.keeprelativex, "size.keeprelativex is not the expected.")
	assert_equal(false, drawable.size.keeprelativey, "size.keeprelativey is not the expected.")
	assert_equal(false, drawable.origin.keeprelativex, "origin.keeprelativex is not the expected.")
	assert_equal(false, drawable.origin.keeprelativey, "origin.keeprelativey is not the expected.")
	assert_equal(false, drawable.childrenorigin.keeprelativex, "childrenorigin.keeprelativex is not the expected.")
	assert_equal(false, drawable.childrenorigin.keeprelativey, "childrenorigin.keeprelativey is not the expected.")
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

function drawabletest.test_relative_position_should_be_relative_to_parent_size()
	-- given:
	parent.children.insert(drawable)
	parent.size = { x = 50, y = 200 }

	-- when:
	drawable.position = { relativex = 0.1, relativey = 0.5 }

	-- then:
	assert_equal(5, drawable.position.x, "x is not the expected.")
	assert_equal(100, drawable.position.y, "y is not the expected.")
end

function drawabletest.test_relative_position_should_be_equal_to_absolute_if_there_is_no_parent()
	-- when:
	drawable.position = { relativex = 0.1, relativey = 0.5 }

	-- then:
	assert_equal(0.1, drawable.position.x, "x is not the expected.")
	assert_equal(0.5, drawable.position.y, "y is not the expected.")
end

function drawabletest.test_relative_size_should_be_relative_to_parent_size()
	-- given:
	parent.children.insert(drawable)
	parent.size = { x = 50, y = 200 }

	-- when:
	drawable.size = { relativex = 0.1, relativey = 0.5 }

	-- then:
	assert_equal(5, drawable.size.x, "size.x is not the expected.")
	assert_equal(100, drawable.size.y, "size.y is not the expected.")
end

function drawabletest.test_relative_size_should_be_equal_to_absolute_if_there_is_no_parent()
	-- when:
	drawable.size = { relativex = 0.1, relativey = 0.5 }

	-- then:
	assert_equal(0.1, drawable.size.x, "size.x is not the expected.")
	assert_equal(0.5, drawable.size.y, "size.y is not the expected.")
end

function drawabletest.test_relative_origin_should_be_relative_to_size()
	-- given:
	drawable.size = { x = 50, y = 200 }

	-- when:
	drawable.origin = { relativex = 0.1, relativey = 0.5 }

	-- then:
	assert_equal(5, drawable.origin.x, "origin.x is not the expected.")
	assert_equal(100, drawable.origin.y, "origin.y is not the expected.")
end

function drawabletest.test_relative_childrenorigin_should_be_relative_to_size()
	-- given:
	drawable.size = { x = 50, y = 200 }

	-- when:
	drawable.childrenorigin = { relativex = 0.1, relativey = 0.5 }

	-- then:
	assert_equal(5, drawable.childrenorigin.x, "childrenorigin.x is not the expected.")
	assert_equal(100, drawable.childrenorigin.y, "childrenorigin.y is not the expected.")
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