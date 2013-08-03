local SpriteDrawableTest = {}
local sprite = {}
local parent = {}

function SpriteDrawableTest.setup()
	sprite = vega.spritedrawable()
	assert_table(sprite, "Should create a table for the sprite drawable.")
end

function SpriteDrawableTest.test_drawable_fields()
	assert_equal(1, sprite.columns, "columns is not the expected.")
	assert_equal(1, sprite.rows, "rows is not the expected.")
	assert_equal(1, sprite.frame, "frame is not the expected.")
	assert_nil(sprite.extensions, "extensions is not the expected.")
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
	sprite.frame = 20
	
	-- when:
	sprite:beforedraw()
	
	-- then:
	assert_equal(vega.Vector2.new(0.9, 0.5), sprite.topleftuv, "topleftuv is not the expected.")
	assert_equal(vega.Vector2.new(1, 1), sprite.bottomrightuv, "bottomrightuv is not the expected.")
end

function SpriteDrawableTest.test_should_keep_texture_before_draw() -- this test exist because the texture can be changed when the extensions are used
	-- given:
	local texture = {}
	sprite.texture = texture
	sprite.columns = 10
	sprite.rows = 2
	sprite.frame = 14
	
	-- when:
	sprite:beforedraw()
	
	-- then:
	assert_equal(texture, sprite.texture, "texture is not the expected.")
end

function SpriteDrawableTest.test_should_set_nil_uvs_and_texture_if_frame_is_less_than_one()
	-- given:
	sprite.columns = 10
	sprite.rows = 2
	sprite.frame = 0
	
	-- when:
	sprite:beforedraw()
	
	-- then:
	assert_nil(sprite.topleftuv, "topleftuv should be nil.")
	assert_nil(sprite.bottomrightuv, "bottomrightuv should be nil.")
	assert_nil(sprite.texture, "texture should be nil.")
end

function SpriteDrawableTest.test_should_set_nil_uvs_and_texture_if_columns_is_less_than_one()
	-- given:
	sprite.columns = 0
	sprite.rows = 2
	sprite.frame = 15
	
	-- when:
	sprite:beforedraw()
	
	-- then:
	assert_nil(sprite.topleftuv, "topleftuv should be nil.")
	assert_nil(sprite.bottomrightuv, "bottomrightuv should be nil.")
	assert_nil(sprite.texture, "texture should be nil.")
end

function SpriteDrawableTest.test_should_set_nil_uvs_and_texture_if_rows_is_less_than_one()
	-- given:
	sprite.columns = 10
	sprite.rows = 0
	sprite.frame = 15
	
	-- when:
	sprite:beforedraw()
	
	-- then:
	assert_nil(sprite.topleftuv, "topleftuv should be nil.")
	assert_nil(sprite.bottomrightuv, "bottomrightuv should be nil.")
	assert_nil(sprite.texture, "texture should be nil.")
end

function SpriteDrawableTest.test_should_set_nil_uvs_and_texture_if_frame_is_out_of_range()
	-- given:
	sprite.columns = 10
	sprite.rows = 2
	sprite.frame = 21
	
	-- when:
	sprite:beforedraw()
	
	-- then:
	assert_nil(sprite.topleftuv, "topleftuv should be nil.")
	assert_nil(sprite.bottomrightuv, "bottomrightuv should be nil.")
	assert_nil(sprite.texture, "texture should be nil.")
end

function SpriteDrawableTest.test_should_set_uvs_and_texture_from_extension()
	-- given:
	sprite.extensions = {
		{
			texture = {},
			columns = 10,
			rows = 2,
		},
	}
	sprite.columns = 2
	sprite.rows = 1
	sprite.frame = 22
	
	-- when:
	sprite:beforedraw()
	
	-- then:
	assert_equal(vega.Vector2.new(0.9, 0.5), sprite.topleftuv, "topleftuv is not the expected.")
	assert_equal(vega.Vector2.new(1, 1), sprite.bottomrightuv, "bottomrightuv is not the expected.")
	assert_equal(sprite.extensions[1].texture, sprite.texture, "Should set the texture of the extension.")
end

function SpriteDrawableTest.test_should_set_uvs_and_texture_from_second_extension()
	-- given:
	sprite.extensions = {
		{
			texture = {},
			columns = 1,
			rows = 2,
		},
		{
			texture = {},
			columns = 10,
			rows = 2,
		},
	}
	sprite.columns = 2
	sprite.rows = 1
	sprite.frame = 24
	
	-- when:
	sprite:beforedraw()
	
	-- then:
	assert_equal(vega.Vector2.new(0.9, 0.5), sprite.topleftuv, "topleftuv is not the expected.")
	assert_equal(vega.Vector2.new(1, 1), sprite.bottomrightuv, "bottomrightuv is not the expected.")
	assert_equal(sprite.extensions[2].texture, sprite.texture, "Should set the texture of the extension.")
end

function SpriteDrawableTest.test_should_set_current_texture_after_draw_with_extension_texture()
	-- given:
	local defaulttexture = {}
	sprite.extensions = {
		{
			texture = {},
			columns = 10,
			rows = 2,
		},
	}
	sprite.texture = defaulttexture
	sprite.columns = 2
	sprite.rows = 1
	sprite.frame = 16
	
	-- when:
	sprite:beforedraw()
	sprite:afterdraw()
	
	-- then:
	assert_equal(defaulttexture, sprite.texture, "Should set the default texture (not the extension texture) after draw.")
end

function SpriteDrawableTest.test_should_calculate_frames_count_with_extensions()
	-- given:
	sprite.extensions = {
		{
			texture = {},
			columns = 2,
			rows = 5,
		},
		{
			texture = {},
			columns = 3,
			rows = 6,
		},
	}
	sprite.rows = 10
	sprite.columns = 3
	
	-- when:
	local count = sprite:getframescount()
	
	-- then:
	assert_equal(58, count, "The frames count is not the expected.")
end

function SpriteDrawableTest.test_should_set_nil_uvs_and_texture_if_frame_is_out_of_range_with_extensions()
	-- given:
	sprite.extensions = {
		{
			texture = {},
			columns = 3,
			rows = 1,
		},
		{
			texture = {},
			columns = 4,
			rows = 1,
		},
	}
	sprite.columns = 5
	sprite.rows = 1
	sprite.frame = 13
	
	-- when:
	sprite:beforedraw()
	
	-- then:
	assert_nil(sprite.topleftuv, "topleftuv should be nil.")
	assert_nil(sprite.bottomrightuv, "bottomrightuv should be nil.")
	assert_nil(sprite.texture, "texture should be nil.")
end

return SpriteDrawableTest
