Vector2 = {
	zero = { x = 0, y = 0 },
	one = { x = 1, y = 1 },
	new = function(xvalue, yvalue)
		return { x = xvalue or 0, y = yvalue or xvalue or 0 }
	end
}
