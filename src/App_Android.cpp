#include "../include/App.h"

// This cpp file contains some implementations of the App class available only for the Android platform.

#ifdef VEGA_ANDROID

using namespace std;
using namespace vega;

string* App::_initialScriptName = NULL;

void android_main(struct android_app* state)
{
	if (App::_initialScriptName != NULL)
	{
		vega::App app(state);
		app.LoadAndExecuteScript(*App::_initialScriptName);
		delete App::_initialScriptName;
	}
}

void App::InitAndroidApp(android_app* androidApp)
{
	app_dummy();
	this->androidApp = androidApp;
	androidApp->onAppCmd = App::OnAndroidCommand;
}

void App::InitAndroidVideo()
{
    const EGLint attribs[] = {
            EGL_SURFACE_TYPE, EGL_WINDOW_BIT,
            EGL_BLUE_SIZE, 8,
            EGL_GREEN_SIZE, 8,
            EGL_RED_SIZE, 8,
            EGL_NONE
    };
    EGLint w, h, dummy, format;
    EGLint numConfigs;
    EGLConfig config;
    EGLSurface surface;
    EGLContext context;

    EGLDisplay display = eglGetDisplay(EGL_DEFAULT_DISPLAY);
    eglInitialize(display, 0, 0);
    eglChooseConfig(display, attribs, &config, 1, &numConfigs);
    eglGetConfigAttrib(display, config, EGL_NATIVE_VISUAL_ID, &format);

    ANativeWindow_setBuffersGeometry(appInstance->androidApp->window, 0, 0, format);

    surface = eglCreateWindowSurface(display, config, appInstance->androidApp->window, NULL);
    context = eglCreateContext(display, config, NULL, NULL);

    /*if (eglMakeCurrent(display, surface, surface, context) == EGL_FALSE) {
        LOGW("Unable to eglMakeCurrent");
        return -1;
    }*/
	
	appInstance->eglSurface = surface;
	appInstance->eglDisplay = display;
	appInstance->sceneRender.Init();
}

void App::CheckInputOnAndroid(lua_State* luaState)
{
	int eventId;
	int events;
	struct android_poll_source* source;
	while ((eventId = ALooper_pollAll(0, NULL, &events, (void**)&source)) >= 0)
	{
		if (source != NULL) {
			source->process(appInstance->androidApp, source);
		}
		if (eventId == LOOPER_ID_USER) {
		}
		if (appInstance->androidApp->destroyRequested != 0) {
			SetExecutingFieldToFalse(luaState);
			break;
		}
	}
}

void App::OnAndroidCommand(struct android_app* androidApp, int32_t cmd)
{
	switch (cmd)
	{
        case APP_CMD_INIT_WINDOW:
            if (androidApp->window != NULL)
				appInstance->InitAndroidVideo();
            break;
	}
}

void App::GetScreenSize(int *w, int *h)
{
	eglQuerySurface(appInstance->eglDisplay, appInstance->eglSurface, EGL_WIDTH, w);
    eglQuerySurface(appInstance->eglDisplay, appInstance->eglSurface, EGL_HEIGHT, h);
}

void App::OnRenderFinished()
{
	eglSwapBuffers(eglDisplay, eglSurface);
}

#endif // VEGA_ANDROID
