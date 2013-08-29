#ifndef VEGA_VECTOR2_H
#define VEGA_VECTOR2_H

namespace vega
{
	struct Vector2
	{
		float x, y;
		Vector2() : x(0), y(0)
		{
		}

		Vector2(float x, float y) : x(x), y(y)
		{
		}
	};
}

#endif
