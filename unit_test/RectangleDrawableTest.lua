local RectangleDrawableTest = {}
local rectangledrawable = {}

function RectangleDrawableTest.setup()
	rectangledrawable = RectangleDrawable.new()
	assert_table(rectangledrawable, "Should create a table for the rectangle drawable.")
end

function RectangleDrawableTest.test_rectangle_drawable_fields()
	assert_equal(Color.new(), rectangledrawable.color, "color is not the expected.")
	assert_equal(Vector2.zero, rectangledrawable.position, "Should contains the data of the Drawable object, but the position is not the expected.")
end

return RectangleDrawableTest