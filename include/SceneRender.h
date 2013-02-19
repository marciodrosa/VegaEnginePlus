#ifndef VEGAENGINE_SCENERENDER_H
#define VEGAENGINE_SCENERENDER_H

#include "Lua.h"

namespace vega
{
	/**
	Renders a scene and the attached drawables.
	*/
	class SceneRender
	{
	public:
		SceneRender();
		virtual ~SceneRender();
		void Init();
		void Render(lua_State*);
	private:
		void RenderViewport();
		void RenderDrawable();
		void SetUpView();
	};
}

#endif
