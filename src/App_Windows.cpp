#include "../include/CApi.h"
#include "../include/App.h"
#include "../include/Log.h"
#include "../include/Mouse.h"

#include <sstream>
using namespace vega;
using namespace std;

// This cpp file contains some implementations of the App class available only for the Windows platform.

#ifdef VEGA_WINDOWS

void App::InitSDL()
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
Process the input events.
*/
void App::ProcessInput()
{
	SDL_Event evt;
	float motionZ = 0.f;
	while (SDL_PollEvent(&evt))
	{
		switch (evt.type)
		{
		case SDL_QUIT:
			SetExecutingFieldToFalse();
			break;
		case SDL_MOUSEBUTTONDOWN:
			if (evt.button.button == SDL_BUTTON_WHEELUP)
				motionZ = 1.f;
			if (evt.button.button == SDL_BUTTON_WHEELDOWN)
				motionZ = -1.f;
			break;
		}
	}

	int newMouseX, newMouseY;
	Uint8 mouseState = SDL_GetMouseState(&newMouseX, &newMouseY);
	newMouseY = SDL_GetVideoSurface()->h - newMouseY; // to invert the Y coordinate; for vega, 0 is the bottom of the screen.
	Mouse lastMouseState = currentMouseState;
	Mouse newMouseState;
	newMouseState.SetPosition(Vector2(newMouseX, newMouseY));
	newMouseState.SetMotion(Vector2(newMouseX - lastMouseState.GetPosition().x, newMouseY - lastMouseState.GetPosition().y), motionZ);
	newMouseState.SetLeftMouseButton(GetMouseButtonState(1, mouseState, lastMouseState.GetLeftMouseButton()));
	newMouseState.SetMiddleMouseButton(GetMouseButtonState(2, mouseState, lastMouseState.GetMiddleMouseButton()));
	newMouseState.SetRightMouseButton(GetMouseButtonState(3, mouseState, lastMouseState.GetRightMouseButton()));
	currentMouseState = newMouseState;
	
	lua_getfield(luaState, -1, "input");
	lua_getfield(luaState, -1, "mouse");
	newMouseState.WriteOnLuaTable(luaState);
	lua_pop(luaState, 2); // pops mouse and input
}

MouseButton App::GetMouseButtonState(int sdlMouseButtonId, Uint8 sdlMouseState, MouseButton& lastMouseButtonState)
{
	MouseButton newMouseButtonState;
	newMouseButtonState.pressed = sdlMouseState & SDL_BUTTON(sdlMouseButtonId);
	newMouseButtonState.wasClicked = newMouseButtonState.pressed && !lastMouseButtonState.pressed;
	newMouseButtonState.wasReleased = !newMouseButtonState.pressed && lastMouseButtonState.pressed;
	return newMouseButtonState;
}

void App::GetScreenSize(int *w, int *h)
{
	*w = SDL_GetVideoSurface()->w;
	*h = SDL_GetVideoSurface()->h;
}

void App::OnRenderFinished()
{
	SDL_GL_SwapBuffers();
	SDL_Flip(SDL_GetVideoSurface());
}

#endif
