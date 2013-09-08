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

return collisiontest