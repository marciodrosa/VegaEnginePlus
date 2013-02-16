local drawable = {}

function suite_setup()
	drawable = Drawable.new()
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
	assert_metatable(getmetatable(drawable), newdrawable, "The metatable of the new instance is not the expected.")
	assert_equal(10, newdrawable.position.x, "The position.x is not the expected.")
	assert_equal(20, newdrawable.position.y, "The position.y is not the expected.")
	assert_equal(0.5, newdrawable.visibility, "The visibility is not the expected.")
	assert_equal(Vector2.one, newdrawable.scale, "The scale is not the expected (should be the default Drawable value).")
end























