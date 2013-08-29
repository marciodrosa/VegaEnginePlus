#ifndef VEGA_MOUSE_H
#define VEGA_MOUSE_H

#include "Vector2.h"
#include "Lua.h"
#include <string>

namespace vega
{
	struct MouseButton
	{
		bool pressed, wasClicked, wasDoubleClicked, wasReleased;

		MouseButton() : pressed(false), wasClicked(false), wasDoubleClicked(false), wasReleased(false)
		{
		}
	};

	/**
	Represents the mouse state.
	*/
	class Mouse
	{
	private:
		Vector2 position;
		Vector2 motion;
		double motionZ;
		MouseButton leftMouseButton;
		MouseButton rightMouseButton;
		MouseButton middleMouseButton;
	public:
		Mouse();
		virtual ~Mouse();
		
		Vector2 GetPosition() const;
		void SetPosition(Vector2&);

		Vector2 GetMotion() const;
		double GetMotionZ() const;
		void SetMotion(Vector2&, double);
		
		MouseButton GetLeftMouseButton() const;
		void SetLeftMouseButton(MouseButton&);

		MouseButton GetRightMouseButton() const;
		void SetRightMouseButton(MouseButton&);

		MouseButton GetMiddleMouseButton() const;
		void SetMiddleMouseButton(MouseButton&);

		void WriteOnLuaTable(lua_State*) const;

	private:
		void WriteMouseButtonOnLuaTable(lua_State*, const MouseButton&, std::string buttonName) const;
	};
}

#endif
