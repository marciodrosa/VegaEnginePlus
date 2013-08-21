#include "../include/CApi.h"
#include "../include/Log.h"

#include <sstream>
using namespace vega;
using namespace std;

#ifdef VEGA_WINDOWS

void CApi::InitSDL()
{
	if (SDL_Init(SDL_INIT_EVERYTHING) < 0)
	{
		stringstream ss;
		ss << "Unable to init SDL: " << SDL_GetError() << ".";
		Log::Error(ss.str());
		return;
	}
	int imageFlags = IMG_INIT_JPG | IMG_INIT_PNG | IMG_INIT_TIF;
	if (IMG_Init(imageFlags) && imageFlags != imageFlags)
	{
		stringstream ss;
		ss << "Warning: failed to init image libraries: " << IMG_GetError();
		Log::Info(ss.str());
	}
	int videoModeFlags = SDL_OPENGL | SDL_DOUBLEBUF | SDL_HWSURFACE;
	int w = 800;
	int h = 600;
	SDL_SetVideoMode(w, h, 32, videoModeFlags);
	SDL_WM_GrabInput(SDL_GRAB_OFF);
	SDL_ShowCursor(true);
	SDL_WM_SetCaption("Vega", NULL);
	sceneRender.Init();
	sceneRender.SetScreenSize(w, h);
}

/**
Called by the main loop Lua script. Answer to the input events of the application.
On lua, call vegacheckinput(context).
*/
int CApi::CheckInputLuaFunction(lua_State* luaState)
{
	SDL_Event evt;
	while (SDL_PollEvent(&evt))
	{
		switch (evt.type)
		{
		case SDL_QUIT:
			CApi::GetInstance()->SetExecutingFieldToFalse();
			break;
		}
	}
	// creates a new Input object and set it into the context
	lua_getglobal(luaState, "vega");
	lua_getfield(luaState, -1, "Input");
	lua_getfield(luaState, -1, "new");
	lua_call(luaState, 0, 1); // pushes the new input instance in the top of the stack
	lua_remove(luaState, -2); // removes the "Input"
	lua_remove(luaState, -2); // removes "vega"
	lua_pushstring(luaState, "input"); // stack now: context, the input instance, "input"
	lua_pushvalue(luaState, -2);  // stack now: context, the input instance, "input", the input instance again
	lua_settable(luaState, -4); // set context["input"] = the input instance; the stack now is context, then the input instance

	int newMouseX, newMouseY;
	Uint8 mouseState = SDL_GetMouseState(&newMouseX, &newMouseY);
	newMouseY = SDL_GetVideoSurface()->h - newMouseY; // to invert the Y coordinate; for vega, 0 is the bottom of the screen.

	bool isClicked = mouseState & SDL_BUTTON(1);
	bool isNewClick = isClicked && !CApi::GetInstance()->wasMouseClicked;
	bool wasReleasedNow = !isClicked && CApi::GetInstance()->wasMouseClicked;

	if (!CApi::GetInstance()->wasMouseClicked)
	{
		CApi::GetInstance()->mouseX = newMouseX;
		CApi::GetInstance()->mouseY = newMouseY;
	}
	if (isClicked)
		CApi::GetInstance()->AddTouchPointToList("touchpoints", newMouseX, newMouseY, CApi::GetInstance()->mouseX, CApi::GetInstance()->mouseY);
	if (isNewClick)
		CApi::GetInstance()->AddTouchPointToList("newtouchpoints", newMouseX, newMouseY, CApi::GetInstance()->mouseX, CApi::GetInstance()->mouseY);
	if (wasReleasedNow)
		CApi::GetInstance()->AddTouchPointToList("releasedtouchpoints", newMouseX, newMouseY, CApi::GetInstance()->mouseX, CApi::GetInstance()->mouseY);

	CApi::GetInstance()->mouseX = newMouseX;
	CApi::GetInstance()->mouseY = newMouseY;
	CApi::GetInstance()->wasMouseClicked = isClicked;

	lua_pop(luaState, 1); // pops the input instance
	return 0;
}

void CApi::GetScreenSize(int *w, int *h)
{
	*w = SDL_GetVideoSurface()->w;
	*h = SDL_GetVideoSurface()->h;
}

void CApi::OnRenderFinished()
{
	SDL_GL_SwapBuffers();
	SDL_Flip(SDL_GetVideoSurface());
}

#endif
