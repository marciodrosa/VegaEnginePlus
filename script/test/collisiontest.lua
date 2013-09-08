local collisiontest = {}

function collisiontest.test_rectangle_should_collide_with_point_at_begining()
	-- given:
	local rpos = {
		x = 10,
		y = 11
	}
	local rsize = {
		x = 5,
		y = 6
	}
	local point = {
		x = 10,
		y = 11
	}

	-- when:
	local collides = vega.collision.rectcollideswithpoint(rpos, rsize, point)

	-- then:
	assert_true(collides)
end

function collisiontest.test_rectangle_should_collide_with_point_at_end()
	-- given:
	local rpos = {
		x = 10,
		y = 11
	}
	local rsize = {
		x = 5,
		y = 6
	}
	local point = {
		x = 15,
		y = 17
	}

	-- when:
	local collides = vega.collision.rectcollideswithpoint(rpos, rsize, point)

	-- then:
	assert_true(collides)
end

function collisiontest.test_rectangle_should_collide_with_point_at_middle()
	-- given:
	local rpos = {
		x = 10,
		y = 11
	}
	local rsize = {
		x = 5,
		y = 6
	}
	local point = {
		x = 12,
		y = 14
	}

	-- when:
	local collides = vega.collision.rectcollideswithpoint(rpos, rsize, point)

	-- then:
	assert_true(collides)
end

function collisiontest.test_rectangle_should_not_collide_with_point_at_left()
	-- given:
	local rpos = {
		x = 10,
		y = 11
	}
	local rsize = {
		x = 5,
		y = 6
	}
	local point = {
		x = 9,
		y = 11
	}

	-- when:
	local collides = vega.collision.rectcollideswithpoint(rpos, rsize, point)

	-- then:
	assert_false(collides)
end

function collisiontest.test_rectangle_should_not_collide_with_point_at_right()
	-- given:
	local rpos = {
		x = 10,
		y = 11
	}
	local rsize = {
		x = 5,
		y = 6
	}
	local point = {
		x = 16,
		y = 11
	}

	-- when:
	local collides = vega.collision.rectcollideswithpoint(rpos, rsize, point)

	-- then:
	assert_false(collides)
end

function collisiontest.test_rectangle_should_not_collide_with_point_above()
	-- given:
	local rpos = {
		x = 10,
		y = 11
	}
	local rsize = {
		x = 5,
		y = 6
	}
	local point = {
		x = 10,
		y = 18
	}

	-- when:
	local collides = vega.collision.rectcollideswithpoint(rpos, rsize, point)

	-- then:
	assert_false(collides)
end

function collisiontest.test_rectangle_should_not_collide_with_point_below()
	-- given:
	local rpos = {
		x = 10,
		y = 11
	}
	local rsize = {
		x = 5,
		y = 6
	}
	local point = {
		x = 10,
		y = 10
	}

	-- when:
	local collides = vega.collision.rectcollideswithpoint(rpos, rsize, point)

	-- then:
	assert_false(collides)
end

function collisiontest.test_rectangle_should_collide_with_rectangle()
	-- given:
	local pos1 = {
		x = 10,
		y = 20,
	}
	local size1 = {
		x = 100,
		y = 200,
	}
	local pos2 = {
		x = 0,
		y = 0
	}
	local size2 = {
		x = 10,
		y = 20
	}
	local pos3 = {
		x = 110,
		y = 0
	}
	local size3 = {
		x = 1,
		y = 20
	}
	local pos4 = {
		x = 0,
		y = 220
	}
	local size4 = {
		x = 10,
		y = 1
	}
	local pos5 = {
		x = 110,
		y = 220
	}
	local size5 = {
		x = 1,
		y = 1
	}

	-- when:
	local rect1collideswithrect2 = vega.collision.rectcollideswithrect(pos1, size1, pos2, size2)
	local rect1collideswithrect3 = vega.collision.rectcollideswithrect(pos1, size1, pos3, size3)
	local rect1collideswithrect4 = vega.collision.rectcollideswithrect(pos1, size1, pos4, size4)
	local rect1collideswithrect5 = vega.collision.rectcollideswithrect(pos1, size1, pos5, size5)

	-- then:
	assert_true(rect1collideswithrect2, "The rectangle should collide with rect2.")
	assert_true(rect1collideswithrect3, "The rectangle should collide with rect3.")
	assert_true(rect1collideswithrect4, "The rectangle should collide with rect4.")
	assert_true(rect1collideswithrect5, "The rectangle should collide with rect5.")
end

function collisiontest.test_rectangle_should_not_collide_with_rectangle()
	-- given:
	local pos1 = {
		x = 10,
		y = 20,
	}
	local size1 = {
		x = 100,
		y = 200,
	}
	local pos2 = {
		x = 0,
		y = 110
	}
	local size2 = {
		x = 9,
		y = 1
	}
	local pos3 = {
		x = 60,
		y = 0
	}
	local size3 = {
		x = 1,
		y = 19
	}
	local pos4 = {
		x = 111,
		y = 110,
	}
	local size4 = {
		x = 1,
		y = 1
	}
	local pos5 = {
		x = 60,
		y = 221,
	}
	local size5 = {
		x = 1,
		y = 1
	}
	
	-- when:
	local rect1collideswithrect2 = vega.collision.rectcollideswithrect(pos1, size1, pos2, size2)
	local rect1collideswithrect3 = vega.collision.rectcollideswithrect(pos1, size1, pos3, size3)
	local rect1collideswithrect4 = vega.collision.rectcollideswithrect(pos1, size1, pos4, size4)
	local rect1collideswithrect5 = vega.collision.rectcollideswithrect(pos1, size1, pos5, size5)

	-- then:
	assert_false(rect1collideswithrect2, "The rectangle should not collide with rect2.")
	assert_false(rect1collideswithrect3, "The rectangle should not collide with rect3.")
	assert_false(rect1collideswithrect4, "The rectangle should not collide with rect4.")
	assert_false(rect1collideswithrect5, "The rectangle should not collide with rect5.")
end

return collisiontest