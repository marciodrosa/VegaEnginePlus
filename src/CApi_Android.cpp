#include "../include/CApi.h"
#include "../include/Log.h"

#ifdef VEGA_ANDROID

void CApi::SetVegaApp(android_app* androidApp)
{
	this->androidApp = androidApp;
	androidApp->onAppCmd = CApi::OnAndroidCommand;
}

void CApi::InitAndroidVideo()
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

    ANativeWindow_setBuffersGeometry(androidApp->window, 0, 0, format);

    surface = eglCreateWindowSurface(display, config, androidApp->window, NULL);
    context = eglCreateContext(display, config, NULL, NULL);

    /*if (eglMakeCurrent(display, surface, surface, context) == EGL_FALSE) {
        LOGW("Unable to eglMakeCurrent");
        return -1;
    }*/
	
	eglSurface = surface;
	eglDisplay = display;
	sceneRender.Init();
}

void CApi::OnAndroidCommand(struct android_app* androidApp, int32_t cmd)
{
	switch (cmd)
	{
        case APP_CMD_INIT_WINDOW:
            if (androidApp->window != NULL)
				CApi::GetInstance()->InitAndroidVideo();
            break;
	}
}

/**
Called by the main loop Lua script. Answer to the input events of the application.
On lua, call vegacheckinput(context).
*/
int CApi::CheckInputLuaFunction(lua_State* luaState)
{
	Log::Info("Checking input");
	int eventId;
	int events;
	struct android_poll_source* source;
	while ((eventId = ALooper_pollAll(0, NULL, &events, (void**)&source)) >= 0)
	{
		if (source != NULL) {
			source->process(CApi::GetInstance()->androidApp, source);
		}
		if (eventId == LOOPER_ID_USER) {
		}
		if (CApi::GetInstance()->androidApp->destroyRequested != 0) {
			Log::Info("Destroy requested");
			SetExecutingFieldToFalse(luaState);
			break;
		}
	}
	return 0;
}

void CApi::GetScreenSize(int *w, int *h)
{
	eglQuerySurface(eglDisplay, eglSurface, EGL_WIDTH, w);
    eglQuerySurface(eglDisplay, eglSurface, EGL_HEIGHT, h);
}

void CApi::OnRenderFinished()
{
	eglSwapBuffers(eglDisplay, eglSurface);
}

int App::SearchModuleInAssetsLuaFunction(lua_State *luaState)
{
	/*
	- Extrair a string do parâmetro (nome do módulo)
	- verificar se o asset existe (na raíz, na pasta vega_lua, com ou sem extensão) (todo: evoluir para usar package.searchpath)
	- se existe, adiciona na pilha a função LoadModuleFromAssetsLuaFunction e o nome do asset e retorna 2
	- se não existe, adiciona nil na pilha e retorna 1


	- onde usar:
	- pegar o tamanho de package.searchers
	- em package.searchers[tamanho +1], setar a função SearchModuleInAssetsLuaFunction
	
	*/
	return 1;
}

int App::LoadModuleFromAssetsLuaFunction(lua_State *luaState)
{
	/*
	- extrai nome do módulo (passado pela função 'require') o nome do asset (extra value, também passado pela função require)
	- carrega o asset (tamanho e dados)
	- chama o luaL_loadbuffer com o tamanho e dados do asset
	- executa módulo carregado, retornando 1 valor (não sei se entendi bem o que Lua deve fazer se o módulo retornar mais de 1 valor...)
	*/
	return 1;
}

//void App::LoadAndExecuteScriptOnAndroid(string scriptName)
//{
//	ANDROID_LOGE("Loading asset: ", scriptName.c_str());
//	AAsset* asset = AAssetManager_open(androidApp->activity->assetManager, scriptName.c_str(), AASSET_MODE_BUFFER);
//	const void *data = AAsset_getBuffer(asset);
//	size_t dataSize = AAsset_getLength(asset);
//	ANDROID_LOGE("Loading asset done.");
//	ANDROID_LOGE("Loading Lua script using the asset buffer.");
//	if (luaL_loadbuffer(luaState, (const char*)data, dataSize, scriptName.c_str()) != 0)
//		ANDROID_LOGE("Lua error: ", lua_tostring(luaState, -1));
//	else if (lua_pcall(luaState, 0, 0, 0) != 0)
//	{
//		ANDROID_LOGE("Executing the script.");
//		ANDROID_LOGE("Lua error: ", lua_tostring(luaState, -1));
//	}
//	ANDROID_LOGE("Script executed.");
//	AAsset_close(asset);
//}

#endif
