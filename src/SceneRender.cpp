#include "../include/SceneRender.h"
#include "../include/SDL.h"

#include <iostream>

#include <windows.h>
#include <GL/GL.h>
#include <GL/glu.h>

using namespace vega;
using namespace std;

vega::SceneRender::SceneRender()
{
}

vega::SceneRender::~SceneRender()
{
}

/**
Initializes the render engine. Call it after the video initialization and before SceneRender::Render.
*/
void vega::SceneRender::Init()
{
	glEnable(GL_CULL_FACE);
	glEnable(GL_ALPHA_TEST);
	glEnable(GL_BLEND);

	glEnableClientState(GL_COLOR_ARRAY);
	glEnableClientState(GL_TEXTURE_COORD_ARRAY);
	glEnableClientState(GL_VERTEX_ARRAY);

	glCullFace(GL_BACK);
	glFrontFace(GL_CCW);

	glAlphaFunc(GL_LEQUAL, 1);
	glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);

	glHint(GL_LINE_SMOOTH_HINT, GL_NICEST);
	glHint(GL_PERSPECTIVE_CORRECTION_HINT, GL_NICEST);
	glHint(GL_POINT_SMOOTH_HINT, GL_NICEST);
	glHint(GL_POLYGON_SMOOTH_HINT, GL_NICEST);
}

/**
Renders the current frame of the scene.
*/
void vega::SceneRender::Render(lua_State* luaState)
{
	if (luaState != NULL)
	{
		lua_getfield(luaState, 1, "backgroundcolor");
		lua_getfield(luaState, -1, "r");
		lua_Number backgroundR = lua_tonumber(luaState, -1);
		lua_pop(luaState, 1);

		lua_getfield(luaState, -1, "g");
		lua_Number backgroundG = lua_tonumber(luaState, -1);
		lua_pop(luaState, 1);

		lua_getfield(luaState, -1, "b");
		lua_Number backgroundB = lua_tonumber(luaState, -1);
		lua_pop(luaState, 1);

		lua_getfield(luaState, -1, "a");
		lua_Number backgroundA = lua_tonumber(luaState, -1);
		lua_pop(luaState, 1);

		glClearColor(backgroundR / 255.f, backgroundG / 255.f, backgroundB / 255.f, backgroundA / 255.f);
		glClear(GL_COLOR_BUFFER_BIT);
		RenderViewport(); // todo: send the viewport as parameter
	}
	else
	{
		glClearColor(0.f, 0.f, 0.f, 1.f);
		glClear(GL_COLOR_BUFFER_BIT);
	}
	SDL_GL_SwapBuffers();
	SDL_Flip(SDL_GetVideoSurface());
}

void vega::SceneRender::RenderViewport()
{
	glMatrixMode (GL_MODELVIEW);
	glLoadIdentity();
	SetUpView(); // todo send the view information
	RenderDrawable(); // todo: send the root drawable
}

void vega::SceneRender::RenderDrawable()
{
}

void vega::SceneRender::SetUpView()
{
}
