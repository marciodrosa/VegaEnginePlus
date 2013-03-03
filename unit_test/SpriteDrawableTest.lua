local SpriteDrawableTest = {}
local sprite = {}
local parent = {}

function SpriteDrawableTest.setup()
	sprite = vega.SpriteDrawable.new()
	assert_table(sprite, "Should create a table for the sprite drawable.")
end

function SpriteDrawableTest.test_drawable_fields()
	assert_equal(1, sprite.columns, "columns is not the expected.")
	assert_equal(1, sprite.rows, "rows is not the expected.")
	assert_equal(1, sprite.frame, "frame is not the expected.")
	assert_equal(vega.Vector2.zero, sprite.position, "The sprite should be a drawable, but the drawable field 'position' is not the expected.")
end

function SpriteDrawableTest.test_should_calculate_frames_count()
	-- given:
	sprite.rows = 10
	sprite.columns = 3
	
	-- when:
	local count = sprite:getframescount()
	
	-- then:
	assert_equal(30, count, "The frames count is not the expected.")
end

function SpriteDrawableTest.test_should_update_uvs_before_draw()
	-- given:
	sprite.columns = 10
	sprite.rows = 2
	sprite.frame = 14
	
	-- when:
	sprite:beforedraw()
	
	-- then:
	assert_equal(vega.Vector2.new(0.3, 0.5), sprite.topleftuv, "topleftuv is not the expected.")
	assert_equal(vega.Vector2.new(0.4, 1), sprite.bottomrightuv, "bottomrightuv is not the expected.")
end

function SpriteDrawableTest.test_should_set_uvs_for_nil_if_frame_is_less_than_one()
	-- given:
	sprite.columns = 10
	sprite.rows = 2
	sprite.frame = 0
	
	-- when:
	sprite:beforedraw()
	
	-- then:
	assert_nil(sprite.topleftuv, "topleftuv should be nil.")
	assert_nil(sprite.bottomrightuv, "bottomrightuv should be nil.")
end

function SpriteDrawableTest.test_should_set_uvs_for_nil_if_columns_is_less_than_one()
	-- given:
	sprite.columns = 0
	sprite.rows = 2
	sprite.frame = 15
	
	-- when:
	sprite:beforedraw()
	
	-- then:
	assert_nil(sprite.topleftuv, "topleftuv should be nil.")
	assert_nil(sprite.bottomrightuv, "bottomrightuv should be nil.")
end

function SpriteDrawableTest.test_should_set_uvs_for_nil_if_rows_is_less_than_one()
	-- given:
	sprite.columns = 10
	sprite.rows = 0
	sprite.frame = 15
	
	-- when:
	sprite:beforedraw()
	
	-- then:
	assert_nil(sprite.topleftuv, "topleftuv should be nil.")
	assert_nil(sprite.bottomrightuv, "bottomrightuv should be nil.")
end

function SpriteDrawableTest.test_should_set_uvs_for_nil_if_frame_is_out_of_range()
	-- given:
	sprite.columns = 10
	sprite.rows = 2
	sprite.frame = 21
	
	-- when:
	sprite:beforedraw()
	
	-- then:
	assert_nil(sprite.topleftuv, "topleftuv should be nil.")
	assert_nil(sprite.bottomrightuv, "bottomrightuv should be nil.")
end

return SpriteDrawableTest
