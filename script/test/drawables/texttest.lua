local texttest = {}
local text = {}

local function createvalidfont()
	return {
		texture = {
			width = 10,
			height = 20
		}
	}
end

function texttest.setup()
	text = vega.drawables.text()
end

function texttest.test_should_have_valid_font()
	-- given:
	text.font = createvalidfont()

	-- when:
	local validfont = text:hasvalidfont()

	-- then:
	assert_true(validfont)
end

function texttest.test_should_not_have_valid_font_if_doesnt_have_font()
	-- given:
	text.font = nil

	-- when:
	local validfont = text:hasvalidfont()

	-- then:
	assert_false(validfont)
end

function texttest.test_should_not_have_valid_font_if_font_doesnt_have_texture()
	-- given:
	text.font = {
		texture = nil
	}

	-- when:
	local validfont = text:hasvalidfont()

	-- then:
	assert_false(validfont)
end

function texttest.test_should_not_have_valid_font_if_font_doesnt_have_texture_width()
	-- given:
	text.font = {
		texture = {
			width = nil,
			height = 20
		}
	}

	-- when:
	local validfont = text:hasvalidfont()

	-- then:
	assert_false(validfont)
end

function texttest.test_should_not_have_valid_font_if_font_doesnt_have_texture_height()
	-- given:
	text.font = {
		texture = {
			width = 10,
			height = nil
		}
	}

	-- when:
	local validfont = text:hasvalidfont()

	-- then:
	assert_false(validfont)
end

function texttest.test_should_have_valid_data()
	-- given:
	text.font = createvalidfont()
	text.content = ""
	text.fontsize = 0

	-- when:
	local validdata = text:hasvaliddata()

	-- then:
	assert_true(validdata)
end

function texttest.test_should_not_have_valid_data_if_doesnt_have_valid_font()
	-- given:
	text.hasvalidfont = function() return false end
	text.content = ""
	text.fontsize = 0

	-- when:
	local validdata = text:hasvaliddata()

	-- then:
	assert_false(validdata)
end

function texttest.test_should_not_have_valid_data_if_doesnt_have_content()
	-- given:
	text.font = createvalidfont()
	text.content = nil
	text.fontsize = 0

	-- when:
	local validdata = text:hasvaliddata()

	-- then:
	assert_false(validdata)
end

function texttest.test_should_not_have_valid_data_if_doesnt_have_fontsize()
	-- given:
	text.font = createvalidfont()
	text.content = ""
	text.fontsize = nil

	-- when:
	local validdata = text:hasvaliddata()

	-- then:
	assert_false(validdata)
end

function texttest.test_char_width_should_be_calculated_with_font_texture_width_and_fontsize()
	-- given:
	text.font = {
		texture = {
			width = 160,
			height = 32,
		}
	}
	text.fontsize = 200

	-- when:
	local charwidth = text:widthforascii(12)

	-- then:
	assert_equal(1000, charwidth)
end

function texttest.test_char_width_should_be_calculated_with_font_metric_and_fontsize()
	-- given:
	text.font = {
		texture = {
			width = 123,
			height = 32,
		},
		metrics = {
			[12] = 10
		}
	}
	text.fontsize = 200

	-- when:
	local charwidth = text:widthforascii(12)

	-- then:
	assert_equal(1000, charwidth)
end

function texttest.test_char_width_should_be_calculated_with_font_texture_width_if_char_metric_is_unknow()
	-- given:
	text.font = {
		texture = {
			width = 160,
			height = 32,
		},
		metrics = {
			[13] = 123
		}
	}
	text.fontsize = 200

	-- when:
	local charwidth = text:widthforascii(12)

	-- then:
	assert_equal(1000, charwidth)
end

function texttest.test_should_process_lines()
	-- given:
	text.content = "This is a text\nwith multiple\nlines."
	text.font = createvalidfont()
	text.widthforascii = function() return 10 end

	-- when:
	local next1, text1, width1 = text:processline(1)
	local next2, text2, width2 = text:processline(next1)
	local next3, text3, width3 = text:processline(next2)

	-- then:
	assert_equal(16, next1, "The initial index of line above the first is not the expected.")
	assert_equal("This is a text", text1, "The first line text is not the expected.")
	assert_equal(140, width1, "The first line width is not the expected.")

	assert_equal(30, next2, "The initial index of line above the second is not the expected.")
	assert_equal("with multiple", text2, "The second line text is not the expected.")
	assert_equal(130, width2, "The second line width is not the expected.")

	assert_equal(36, next3, "The initial index of line above the third is not the expected.")
	assert_equal("lines.", text3, "The third line text is not the expected.")
	assert_equal(60, width3, "The third line width is not the expected.")
end

function texttest.test_should_wrap_line_to_max_width_when_process_lines()
	-- given:
	text.content = "This is a text with original single line."
	text.font = createvalidfont()
	text.maxlinewidth = 120
	text.widthforascii = function() return 10 end

	-- when:
	local next1, text1, width1 = text:processline(1)
	local next2, text2, width2 = text:processline(next1)
	local next3, text3, width3 = text:processline(next2)
	local next4, text4, width4 = text:processline(next3)

	-- then:
	assert_equal(11, next1, "The initial index of line above the first is not the expected.")
	assert_equal("This is a", text1, "The first line text is not the expected.")
	assert_equal(90, width1, "The first line width is not the expected.")

	assert_equal(21, next2, "The initial index of line above the second is not the expected.")
	assert_equal("text with", text2, "The second line text is not the expected.")
	assert_equal(90, width2, "The second line width is not the expected.")

	assert_equal(30, next3, "The initial index of line above the third is not the expected.")
	assert_equal("original", text3, "The third line text is not the expected.")
	assert_equal(80, width3, "The third line width is not the expected.")

	assert_equal(42, next4, "The initial index of line above the fourth is not the expected.")
	assert_equal("single line.", text4, "The fourth line text is not the expected.")
	assert_equal(120, width4, "The fourth line width is not the expected.")
end

function texttest.test_should_wrap_line_to_max_width_when_process_lines_and_cut_word_in_half()
	-- given:
	text.content = "onebigword."
	text.font = createvalidfont()
	text.maxlinewidth = 50
	text.widthforascii = function() return 10 end

	-- when:
	local next1, text1, width1 = text:processline(1)
	local next2, text2, width2 = text:processline(next1)
	local next3, text3, width3 = text:processline(next2)

	-- then:
	assert_equal(6, next1, "The initial index of line above the first is not the expected.")
	assert_equal("onebi", text1, "The first line text is not the expected.")
	assert_equal(50, width1, "The first line width is not the expected.")

	assert_equal(11, next2, "The initial index of line above the second is not the expected.")
	assert_equal("gword", text2, "The second line text is not the expected.")
	assert_equal(50, width2, "The second line width is not the expected.")

	assert_equal(12, next3, "The initial index of line above the third is not the expected.")
	assert_equal(".", text3, "The third line text is not the expected.")
	assert_equal(10, width3, "The third line width is not the expected.")
end

function texttest.test_should_calculate_line_position()
	-- given:
	text.fontsize = 10

	-- when:
	local pos = text:lineposition(3, 400)

	-- then:
	assert_equal(0, pos.x, "x is not the expected.")
	assert_equal(20, pos.y, "y is not the expected.")
end

function texttest.test_should_calculate_line_position_align_left()
	-- given:
	text.fontsize = 10
	text.size = { x = 1000, y = 1 }
	text.align = "left"

	-- when:
	local pos = text:lineposition(3, 400)

	-- then:
	assert_equal(0, pos.x, "x is not the expected.")
	assert_equal(20, pos.y, "y is not the expected.")
end

function texttest.test_should_calculate_line_position_align_right()
	-- given:
	text.fontsize = 10
	text.size = { x = 1000, y = 1 }
	text.align = "right"

	-- when:
	local pos = text:lineposition(3, 400)

	-- then:
	assert_equal(600, pos.x, "x is not the expected.")
	assert_equal(20, pos.y, "y is not the expected.")
end

function texttest.test_should_calculate_line_position_align_center()
	-- given:
	text.fontsize = 10
	text.size = { x = 1000, y = 1 }
	text.align = "center"

	-- when:
	local pos = text:lineposition(3, 400)

	-- then:
	assert_equal(300, pos.x, "x is not the expected.")
	assert_equal(20, pos.y, "y is not the expected.")
end

function texttest.test_should_create_drawables_for_characters()
	-- given:
	text.font = createvalidfont()
	text.fontsize = 20
	text.widthforascii = function() return 10 end
	text.content = "Vega\nSDK"

	-- when:
	text:refresh()

	-- then:
	assert_equal(7, #text.charactersdrawable.children, "Should create 7 drawables for the 7 characters.")
	local v = text.charactersdrawable.children[1]
	local e = text.charactersdrawable.children[2]
	local g = text.charactersdrawable.children[3]
	local a = text.charactersdrawable.children[4]
	local s = text.charactersdrawable.children[5]
	local d = text.charactersdrawable.children[6]
	local k = text.charactersdrawable.children[7]
	assert_equal(0, v.position.x, "v.position.x is not the expected.")
	assert_equal(0, v.position.y, "v.position.y is not the expected.")
	assert_equal(10, v.size.x, "v.size.x is not the expected.")
	assert_equal(20, v.size.y, "v.size.y is not the expected.")

	assert_equal(10, e.position.x, "e.position.x is not the expected.")
	assert_equal(0, e.position.y, "e.position.y is not the expected.")
	assert_equal(10, e.size.x, "e.size.x is not the expected.")
	assert_equal(20, e.size.y, "e.size.y is not the expected.")

	assert_equal(20, g.position.x, "g.position.x is not the expected.")
	assert_equal(0, g.position.y, "g.position.y is not the expected.")
	assert_equal(10, g.size.x, "g.size.x is not the expected.")
	assert_equal(20, g.size.y, "g.size.y is not the expected.")

	assert_equal(30, a.position.x, "a.position.x is not the expected.")
	assert_equal(0, a.position.y, "a.position.y is not the expected.")
	assert_equal(10, a.size.x, "a.size.x is not the expected.")
	assert_equal(20, a.size.y, "a.size.y is not the expected.")

	assert_equal(0, s.position.x, "s.position.x is not the expected.")
	assert_equal(20, s.position.y, "s.position.y is not the expected.")
	assert_equal(10, s.size.x, "s.size.x is not the expected.")
	assert_equal(20, s.size.y, "s.size.y is not the expected.")

	assert_equal(10, d.position.x, "d.position.x is not the expected.")
	assert_equal(20, d.position.y, "d.position.y is not the expected.")
	assert_equal(10, d.size.x, "d.size.x is not the expected.")
	assert_equal(20, d.size.y, "d.size.y is not the expected.")

	assert_equal(20, k.position.x, "k.position.x is not the expected.")
	assert_equal(20, k.position.y, "k.position.y is not the expected.")
	assert_equal(10, k.size.x, "k.size.x is not the expected.")
	assert_equal(20, k.size.y, "k.size.y is not the expected.")
end

function texttest.test_should_set_texture_and_color_on_characters()
	-- given:
	text.font = createvalidfont()
	text.fontsize = 20
	text.fontcolor = { r = 255, g = 255, b = 255 }
	text.widthforascii = function() return 10 end
	text.content = "A" -- ascii 65

	-- when:
	text:refresh()

	-- then:
	local a = text.charactersdrawable.children[1]
	assert_equal(text.font.texture, a.texture, "Should set the texture of the character.")
	assert_equal(text.fontcolor, a.color, "Should set the color of the character.")
	assert_equal(0.0625, a.topleftuv.x, "topleftuv.x is not the expected.")
	assert_equal(0.25, a.topleftuv.y, "topleftuv.y is not the expected.")
	assert_equal(0.125, a.bottomrightuv.x, "bottomrightuv.x is not the expected.")
	assert_equal(0.3125, a.bottomrightuv.y, "bottomrightuv.y is not the expected.")
end

function texttest.test_should_set_size_to_fit_characters()
	-- given:
	text.font = createvalidfont()
	text.fontsize = 20
	text.widthforascii = function() return 10 end
	text.content = "The vega\nSDK"

	-- when:
	text:refresh()

	-- then:
	assert_equal(80, text.size.x, "The width is not the expected.")
	assert_equal(40, text.size.y, "The height is not the expected.")
end

return texttest